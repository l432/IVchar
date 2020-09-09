#include "OlegAD5752.h"

AD5752o::AD5752o()
{
  _SetupIsNotDone = true;
  _PowerByte = B00010000;
  _OutputRange[0] = ad_p050;
  _OutputRange[1] = ad_p050;
  _PowerOn[0] = false;
  _PowerOn[1] = false;
}


bool AD5752o::Action() {

  if (DeviceId != AD5752Command) return false;
  //  if (NumberByte < 6) return true;
  if (NumberByte < 7) return true;
  if (DataFromPC[3] > 1) return true;

  SetPin(PinControl);
  if (_SetupIsNotDone) Setup();

  if  (DataFromPC[4] == 0x10) {
    switch (DataFromPC[5]) {
      case 0x11:
        PowerOn(DataFromPC[3]);
        break;
      case 0x00:
        PowerOff(DataFromPC[3]);
        break;
      default: return true;
    }
  }

  if  (DataFromPC[4] > 5) return true;

  if (DataFromPC[4] != _OutputRange[DataFromPC[3]])
    SetOutputRange(DataFromPC[3], (ad_OUTPUT_RANGE)DataFromPC[4]);

  if (!_PowerOn[DataFromPC[3]]) PowerOn(DataFromPC[3]);

  ThreeByteTransfer(AD5752_DAC[DataFromPC[3]], DataFromPC[5], DataFromPC[6]);
  delayMicroseconds(12);

  return true;

  //  byte ByteUnderWork = 3;
  //
  //  while (ByteUnderWork < NumberByte) {
  //    byte OperationType = (DataFromPC[ByteUnderWork] >> 3) & B00000111;
  //    switch (OperationType) {
  //      case 0:
  //        ThreeByteTransfer(DataFromPC[ByteUnderWork], DataFromPC[ByteUnderWork + 1], DataFromPC[ByteUnderWork + 2]);
  //        ByteUnderWork += 3;
  //        delayMicroseconds(12);
  //        break;
  //      case 1:
  //        ThreeByteTransfer(DataFromPC[ByteUnderWork], 0x00, DataFromPC[ByteUnderWork + 1]);
  //        ByteUnderWork += 2;
  //        delayMicroseconds(12);
  //        break;
  //      case 2:
  //        if (bitRead(DataFromPC[ByteUnderWork + 1], 1) == 1) {
  //          if (bitRead(DataFromPC[ByteUnderWork + 1], 0) == 1) {
  //            _PowerByte |= B00000001;
  //          }
  //          else {
  //            _PowerByte &= B11111110;
  //          };
  //        };
  //        if (bitRead(DataFromPC[ByteUnderWork + 1], 3) == 1) {
  //          if (bitRead(DataFromPC[ByteUnderWork + 1], 2) == 1) {
  //            _PowerByte |= B00000100;
  //          }
  //          else {
  //            _PowerByte &= B11111011;
  //          };
  //        };
  //        ThreeByteTransfer(0x10, 0x00, DataFromPC[ByteUnderWork + 1]);
  //        ByteUnderWork += 2;
  //        delayMicroseconds(12);
  //        break;
  //
  //      default: ByteUnderWork = NumberByte;
  //    }
  //  }
}


void AD5752o::Setup() {

  ThreeByteTransfer(0x19, 0x00, 0x0D);
  //TSD enable/Clamp Enable/0 V on Clear/SDO Disable
  delayMicroseconds(50);

  ThreeByteTransfer(0x0C, 0x00, 0x00);
  //+5 V вихідний діапазон обох виходів
  delayMicroseconds(50);

  ThreeByteTransfer(0x10, 0x00, _PowerByte);
  //живлення на REF
  delayMicroseconds(50);
  _SetupIsNotDone = false;
}

word AD5752o::VoltageToKod(float Voltage, ad_OUTPUT_RANGE Range) {
  long temp = round(Voltage / AD5752_REFIN / AD5752_GainOutputRange[Range] * (AD5752_MaxKod + 1));
  if (temp < 0) temp = (~(abs(temp))) & 0xFFFF;
  return (temp & 0xFFFF); 
}

void AD5752o::PowerOn(byte Chanel) {
  switch (Chanel) {
    case 0:
      _PowerByte |= B00000001;
      break;
    case 1:
      _PowerByte |= B00000100;
      break;
    default: return;
  }
  ThreeByteTransfer(0x10, 0x00, _PowerByte);
  delayMicroseconds(50);
  _PowerOn[Chanel] = true;
}

void AD5752o::PowerOff(byte Chanel) {
  switch (Chanel) {
    case 0:
      _PowerByte &= B11111110;
      break;
    case 1:
      _PowerByte &= B11111011;
      break;
    default: return;
  }
  ThreeByteTransfer(0x10, 0x00, _PowerByte);
  delayMicroseconds(50);
  _PowerOn[Chanel] = false;
}

void AD5752o::SetOutputRange(byte Chanel, ad_OUTPUT_RANGE Range) {
  switch (Chanel) {
    case 0:
      ThreeByteTransfer(0x08, 0x00, Range);
      break;
    case 1:
      ThreeByteTransfer(0x0A, 0x00, Range);
      break;
    default: return;
  }
  delayMicroseconds(12);
  _OutputRange[Chanel] = Range;
}

