#include "DACR2R.h"

DACR2R::DACR2R(byte SignPinNumber) {
  SetSignPin(SignPinNumber);
}

bool DACR2R::Action() {
  if (DeviceId != DACR2RCommand) return false;
  if (NumberByte < 8) return true;
  
  SetPin(PinControl);
  if (SignMustBeChangedDetermine(DataFromPC[6]))
    ChangeSign();
  TwoByteTransfer(DataFromPC[4], DataFromPC[5]);  
  return true;
}

void DACR2R::DataTransfer() {
  TwoByteTransfer(_DataReceived[0], _DataReceived[1]);
}

void DACR2R::BeginDataRead(byte Data1, byte Data2) {
  _DataReceived[0] = Data1;
  _DataReceived[1] = Data2;
  SetPin(PinControl);
}






