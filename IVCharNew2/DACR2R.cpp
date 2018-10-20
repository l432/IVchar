#include "DACR2R.h"

DACR2R::DACR2R(byte SignPinNumber) {
  SetSignPin(SignPinNumber);
}

void DACR2R::Begin(byte Data1, byte Data2, byte Sign) {
  //  _DataReceived[0] = Data1;
  //  _DataReceived[1] = Data2;
  //  SetPin(PinControl);
  BeginDataRead(Data1, Data2);
  if (SignMustBeChangedDetermine(Sign))
    ChangeSign();
  DataTransfer();
}


void DACR2R::DataTransfer() {
  TwoByteTransfer(_DataReceived[0], _DataReceived[1]);
}

void DACR2R::BeginDataRead(byte Data1, byte Data2) {
  _DataReceived[0] = Data1;
  _DataReceived[1] = Data2;
  SetPin(PinControl);
}





