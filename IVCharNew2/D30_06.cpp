#include "D30_06.h"

D30_06::D30_06(byte SignPinNumber):DACR2R(SignPinNumber) {
//  DACR2R::DACR2R(SignPinNumber);
//  SetSignPin(SignPinNumber);
  SetInterval(500);
}

void D30_06::Begin(byte Data1, byte Data2, byte Sign) {
//  _DataReceived[0] = Data1;
//  _DataReceived[1] = Data2;
//  SetPin(PinControl);
  BeginDataRead(Data1, Data2);
  if (SignMustBeChangedDetermine(Sign))
  {
    Start();
    TwoByteTransfer(0, 0);
  } else {
    DataTransfer();
  }
}

//void D30_06::DataTransfer() {
//  TwoByteTransfer(_DataReceived[0], _DataReceived[1]);
//}

void D30_06::Process() {
  ChangeSign();
  Stop();
  DataTransfer();
}



