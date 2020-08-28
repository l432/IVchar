#include "OlegAD5752.h"

AD5752o::AD5752o()
{
  _SetupIsNotDone = true;
  _PowerByte = B00010000;
}


bool AD5752o::Action() {

  if (DeviceId != AD5752Command) return false;
//ControlBlink();
  if (NumberByte < 6) return true;

  SetPin(PinControl);
  if (_SetupIsNotDone) Setup();

  byte ByteUnderWork = 3;

  while (ByteUnderWork < NumberByte) {
    byte OperationType = (DataFromPC[ByteUnderWork] >> 3) & B00000111;
    switch (OperationType) {
      case 0:
        ThreeByteTransfer(DataFromPC[ByteUnderWork], DataFromPC[ByteUnderWork + 1], DataFromPC[ByteUnderWork + 2]);
        ByteUnderWork += 3;
        delayMicroseconds(12);
        break;
      case 1:
        ThreeByteTransfer(DataFromPC[ByteUnderWork], 0x00, DataFromPC[ByteUnderWork + 1]);
        ByteUnderWork += 2;
        delayMicroseconds(12);
        break;
      case 2:
        if (bitRead(DataFromPC[ByteUnderWork + 1], 1) == 1) {
          if (bitRead(DataFromPC[ByteUnderWork + 1], 0) == 1) {
            _PowerByte |= B00000001;
          }
          else {
            _PowerByte &= B11111110;
          };
        };
        if (bitRead(DataFromPC[ByteUnderWork + 1], 3) == 1) {
          if (bitRead(DataFromPC[ByteUnderWork + 1], 2) == 1) {
            _PowerByte |= B00000100;
          }
          else {
            _PowerByte &= B11111011;
          };
        };
        ThreeByteTransfer(0x10, 0x00, DataFromPC[ByteUnderWork + 1]);
        ByteUnderWork += 2;
        delayMicroseconds(12);
        break;

      default: ByteUnderWork = NumberByte;
    }
  }
}


void AD5752o::Setup() {

  ThreeByteTransfer(0x19, 0x00, 0x0D);
  //TSD enable/Clamp Enable/0 V on Clear/SDO Disable
  delayMicroseconds(50);

  ThreeByteTransfer(0x0C, 0x00, 0x00);
  //+5 V вихідний діапазон обох виходів
  delayMicroseconds(50);
//ControlBlink();
  ThreeByteTransfer(0x10, 0x00, _PowerByte);
  //живлення на REF
  delayMicroseconds(50);
//delay(2000);
//ControlBlink();
//ControlBlink();
  _SetupIsNotDone = false;
}
