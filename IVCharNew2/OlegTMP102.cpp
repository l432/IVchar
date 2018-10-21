#include "OlegTMP102.h"


TMP102o::TMP102o()
{
  SetInterval(30);
  SetDataReceivedNumber(2);
}

void TMP102o::ModeSetup()
{
  Wire.beginTransmission(_address);
  Wire.write(0x01);
  Wire.write(_DataReceived[0]);
  Wire.endTransmission();
}

void TMP102o::Initial() {
  Wire.beginTransmission(_address);
  Wire.write(0x03);
  Wire.write(0x7F);
  Wire.write(0xF0);
  Wire.endTransmission();
  // write 127.9375 to Thigh
  Wire.beginTransmission(_address);
  Wire.write(0x02);
  Wire.write(0x7E);
  Wire.write(0x00);
  Wire.endTransmission();
  // write 126 to Tlow

  ByteTransfer(0x01);
  DataReceive();
  _DataReceived[0] &= 0xFC;
  _DataReceived[0] |= 0x03;
  ModeSetup();
  //  TMP2ByteTransfer(0x01, TMP102DataReceived[0]);
  //to sleep-mode, to interrupt mode,
}

void TMP102o::Begin() {

  if (PinControl != _address) {
    SetAdress(PinControl);
    Initial();
  }

  ByteTransfer(0x01);
  DataReceive();
  _DataReceived[0] &= 0x7F;
  _DataReceived[0] |= 0x80;
  ModeSetup();
  //  TMP2ByteTransfer(0x01, TMP102DataReceived[0]);
  //OS->1
  Start();
}

void TMP102o::Process() {
  ByteTransfer(0x00);
  DataReceive();

  DeviceId = TMP102Command;
  ActionId = _address;
  CreateAndSendPacket(_DataReceived, GetDataReceivedNumber());
  Stop();
}


//void TMP3ByteTransfer(byte Data1, byte Data2, byte Data3) {
//  Wire.beginTransmission(TMP102_Adress);
//  Wire.write(Data1);
//  Wire.write(Data2);
//  Wire.write(Data3);
//  Wire.endTransmission();
//}
//
//void TMP2ByteTransfer(byte Data1, byte Data2) {
//  Wire.beginTransmission(TMP102_Adress);
//  Wire.write(Data1);
//  Wire.write(Data2);
//  Wire.endTransmission();
//}
//
//void TMP1ByteTransfer(byte Data1) {
//  Wire.beginTransmission(TMP102_Adress);
//  Wire.write(Data1);
//  Wire.endTransmission();
//}
//
//void TPMDataReceive() {
//  Wire.requestFrom(TMP102_Adress, 2);
//  Wire.endTransmission();
//  TMP102DataReceived[0] = Wire.read();
//  TMP102DataReceived[1] = Wire.read();
//}
//
//
//void TMP102First() {
//  if (PinControl != TMP102_Adress) {
//    TMP102_Adress = PinControl;
//    TMP102Initial();
//  }
//
//  TMP1ByteTransfer(0x01);
//  TPMDataReceive();
//  TMP102DataReceived[0] &= 0x7F;
//  TMP102DataReceived[0] |= 0x80;
//  TMP2ByteTransfer(0x01, TMP102DataReceived[0]);
//  //OS->1
//
//  EndTMP102delay = millis() + 30;
//
//}
//
//void TMP102Second () {
//  TMP1ByteTransfer(0x00);
//  TPMDataReceive();
//
//  DeviceId = TMP102Command;
//  ActionId = TMP102_Adress;
//  CreateAndSendPacket(TMP102DataReceived, sizeof(TMP102DataReceived));
//  EndTMP102delay = 0;
//}
//
//void TMP102Initial() {
//  TMP3ByteTransfer(0x03, 0x7F, 0xF0);
//  // write 127.9375 to Thigh
//  TMP3ByteTransfer(0x02, 0x7E, 0x00);
//  // write 126 to Tlow
//
//  TMP1ByteTransfer(0x01);
//  TPMDataReceive();
//  TMP102DataReceived[0] &= 0xFC;
//  TMP102DataReceived[0] |= 0x03;
//  TMP2ByteTransfer(0x01, TMP102DataReceived[0]);
//  //to sleep-mode, to interrupt mode,
//}


