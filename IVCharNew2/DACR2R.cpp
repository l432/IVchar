#include "DACR2R.h"

DACR2R::DACR2R(byte SignPinNumber) {
  SetSignPin(SignPinNumber);
}

void DACR2R::Action(byte Data1, byte Data2, byte Sign) {
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


//void DACR2R() {
//  if (DACDataReceived[2] == DAC_Neg && !DACR2RPinSignBool)
//  {
//    digitalWrite(DACR2RPinSign, HIGH);
//    DACR2RPinSignBool = true;
//  };
//
//  if (DACDataReceived[2] == DAC_Pos && DACR2RPinSignBool)
//  {
//    digitalWrite(DACR2RPinSign, LOW);
//    DACR2RPinSignBool = false;
//  };
//  SPI2ByteTransfer(PinAndID::PinControl, DACDataReceived[0], DACDataReceived[1]);
//}





