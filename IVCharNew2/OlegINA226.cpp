#include "OlegINA226.h"


INA226o::INA226o()
{
  SetAdress(0x45);
  SetDataReceivedNumber(2);
  _config = 0x4127;
  _mode = INA_MODE_TRIGGERED_BOTH;
  _timeFactor = 0;
}


bool INA226o::Begin() {
  // ControlBlink();
  // delay(1000);
  if (DeviceId != INA226Command) return false;

  //ActionId = _address;
  //    CreateAndSendPacket(_DataReceived, GetDataReceivedNumber());
  //    return true;

  if ((NumberByte < 7) || (!isReady()))   return true;
  SetAdress(PinControl);
  _timeFactor = DataFromPC[5];
  _config = (DataFromPC[3] << 8) | DataFromPC[4];
  _mode = (uint8_t)(_config & INA_CONFIG_MODE_MASK);
  SetInterval(DelayTime());
  ThreeByteTransfer(INA_CONFIGURATION_REGISTER, DataFromPC[3], DataFromPC[4]);
  Start();
  return true;
}



void INA226o::Process() {
  if (isConversionFinished()) {
    switch (_mode) {
      case INA_MODE_TRIGGERED_SHUNT:
        ByteTransfer(INA_SHUNT_VOLTAGE_REGISTER);
        break;
      case  INA_MODE_TRIGGERED_BUS:
        ByteTransfer(INA_BUS_VOLTAGE_REGISTER);
        break;
      default:
        ByteTransfer(INA_SHUNT_VOLTAGE_REGISTER);
        DataReceive();
        _DataReceived[2] = _DataReceived[0];
        _DataReceived[3] = _DataReceived[1];
        ByteTransfer(INA_BUS_VOLTAGE_REGISTER);
        SetDataReceivedNumber(4);
    };
    DataReceive();
    byte temp = DeviceCheck(INA226Command);
    if (temp == 0xFF) {
      DeviceId = INA226Command;
      ActionId = _address;
      CreateAndSendPacket(_DataReceived, GetDataReceivedNumber());
    } else {
      AddData(temp, _DataReceived, GetDataReceivedNumber());
      DeviceId = ArduinoIVCommand;
      ToBackDoor = true;
    };

    if (_mode == INA_MODE_TRIGGERED_BOTH) {
      SetDataReceivedNumber(2);
    };
    Stop();
    ToSleepMode();
  } else {
    if (TimeFromStart() > 2 * GetInterval()) {
      Stop();
      ToSleepMode();
    }
  }

}


bool INA226o::isConversionFinished() {
  ByteTransfer(INA_MASK_ENABLE_REGISTER);
  DataReceive();
  return (_DataReceived[1] & INA_CONVERSION_READY_MASK);
}

void INA226o::ToSleepMode() {
  _config &= INA_TO_SLEEP_MODE_MASK;
  ByteTransfer(INA_CONFIGURATION_REGISTER);
}

unsigned long  INA226o::DelayTime() {
  uint8_t  averages = (uint8_t)((_config & INA_CONFIG_AVG_MASK) >> 9);
  uint8_t shuntCT, busCT;
  uint8_t koef = 1;
  switch (_mode) {
    case INA_MODE_TRIGGERED_SHUNT:
      shuntCT = (uint8_t)((_config & INA_CONFIG_SHUNT_TIME_MASK) >> 3);
      return (unsigned long)_timeFactor * (INA226_averages[averages] * INA226_ConvTime[shuntCT]);
      break;
    case  INA_MODE_TRIGGERED_BUS:
      busCT = (uint8_t)((_config & INA_CONFIG_BUS_TIME_MASK) >> 6);

      return (unsigned long)_timeFactor * (INA226_averages[averages] * INA226_ConvTime[busCT]);
      break;
    default:
      shuntCT = (uint8_t)((_config & INA_CONFIG_SHUNT_TIME_MASK) >> 3);
      busCT = (uint8_t)((_config & INA_CONFIG_BUS_TIME_MASK) >> 6);
      return (unsigned long)_timeFactor * (INA226_averages[averages] * (INA226_ConvTime[shuntCT] + INA226_ConvTime[busCT]));
  };
}


