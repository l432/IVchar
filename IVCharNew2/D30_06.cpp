#include "D30_06.h"

D30_06::D30_06(byte SignPinNumber): DACR2R(SignPinNumber) {
  SetInterval(500);
}

//void D30_06::Begin(byte Data1, byte Data2, byte Sign) {
bool D30_06::Begin() {
  if (DeviceId != D30_06Command) return false;
  if ((NumberByte < 8) || (!isReady())) return true;

  BeginDataRead(Data4, Data5);
  if (SignMustBeChangedDetermine(Data6))
  {
    Start();
    TwoByteTransfer(0, 0);
  } else {
    DataTransfer();
  }
  return true;
}

//      if ((PinAndID::DeviceId == D30_06Command) && (d3006.isReady())) {
//        if (packet[0] < 8) goto start;
//        d3006.Begin(packet[4], packet[5], packet[6]);
//      }

void D30_06::Process() {
  ChangeSign();
  Stop();
  DataTransfer();
}

//void D30_06() {
//  if ((D30_06DataReceived[2] == DAC_Neg && !D30_06PinSignBool) ||
//      (D30_06DataReceived[2] == DAC_Pos && D30_06PinSignBool))
//  {
//    EndD30_06delay = millis() + 500;
//    //    D30_06delay = true;
//    SPI2ByteTransfer(D30_06DataReceived[3], 0, 0);
//
//  } else {
//    SPI2ByteTransfer(D30_06DataReceived[3], D30_06DataReceived[0], D30_06DataReceived[1]);
//  }
//}
//
//void D30_06_Second() {
//  if (D30_06DataReceived[2] == DAC_Neg && !D30_06PinSignBool)
//  {
//    digitalWrite(D30_06PinSign, HIGH);
//    D30_06PinSignBool = true;
//  };
//
//  if (D30_06DataReceived[2] == DAC_Pos && D30_06PinSignBool)
//  {
//    digitalWrite(D30_06PinSign, LOW);
//    D30_06PinSignBool = false;
//  };
//  //  D30_06delay = false;
//  EndD30_06delay = 0;
//  SPI2ByteTransfer(D30_06DataReceived[3], D30_06DataReceived[0], D30_06DataReceived[1]);
//}

