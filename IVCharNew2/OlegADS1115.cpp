#include "OlegADS1115.h"


ADS1115o::ADS1115o()
{
  SetAdress(0x48);
  SetDataReceivedNumber(2);
//  _SetupIsNotDone = true;
//  _AlertPin = 0;
  Config(0x80);
}


bool ADS1115o::Begin() {

  if (DeviceId != ADS1115Command) return false;
  if ((NumberByte < 6) || (!isReady()))   return true;

  SetAdress(PinControl);
//  if (_SetupIsNotDone) Setup();
//  _AlertPin = Data3;
//  Config(Data5);
//  ThreeByteTransfer(ADS1115_REG_POINTER_CONFIG, Data4, Data5);
  Config(Data4);
  ThreeByteTransfer(ADS1115_REG_POINTER_CONFIG, Data3, Data4);
  Start();
  return true;
}



void ADS1115o::Process() {
  if (isConversionFinished()) {
//        ByteTransfer(ADS1115_REG_POINTER_CONFIG);
//        DataReceive();
//        _DataReceived[GetDataReceivedNumber()] = _DataReceived[0];
    ByteTransfer(ADS1115_REG_POINTER_CONVERT);
    DataReceive();
    DeviceId = ADS1115Command;
    ActionId = _address;
    CreateAndSendPacket(_DataReceived, GetDataReceivedNumber() + 1);
    Stop();
  } else {
    if (TimeFromStart() > 2 * GetInterval()) Stop();
  }

}

//void ADS1115o::Setup() {
//  ThreeByteTransfer(ADS1115_REG_POINTER_LOWTHRESH, 0x00, 0x00);
//  ThreeByteTransfer(ADS1115_REG_POINTER_HITHRESH, 0xFF, 0xFF);
//  _SetupIsNotDone = false;
//}

void  ADS1115o::Config(byte ConfigByte) {
    _dataRate = ads_DATA_RATE_t( ConfigByte & 0xE0);
  SetInterval(DelayTime());
}

bool ADS1115o::isConversionFinished() {
  ByteTransfer(ADS1115_REG_POINTER_CONFIG);
  DataReceive();
  _DataReceived[GetDataReceivedNumber()] = _DataReceived[0];
  return (_DataReceived[0] & 0x80);
//    return (digitalRead(_AlertPin) == HIGH);
}

unsigned long  ADS1115o::DelayTime() {
  unsigned long temp = 0;
  switch (_dataRate) {
    case ADS_DR8:
      temp = 125000;
      break;
    case ADS_DR16:
      temp = 62500;
      break;
    case ADS_DR32:
      temp = 31250;
      break;
    case ADS_DR64:
      temp = 15625;
      break;
    case ADS_DR128:
      temp = 7813;
      break;
    case ADS_DR250:
      temp = 4000;
      break;
    case ADS_DR475:
      temp = 2106;
      break;
    case ADS_DR860:
      temp = 1163;
      break;
  };
  return temp;
}


