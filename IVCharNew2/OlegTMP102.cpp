#include "OlegTMP102.h"


TMP102o::TMP102o()
{
  //  _address = 0;
  SetInterval(30);
}

//void TMP102o::SetAdress(byte address)
//{
//  _address = address;
//}


//void TMP102o::ByteTransfer(byte Data) {
//  Wire.beginTransmission(_address);
//  Wire.write(Data);
//  Wire.endTransmission();
//}

void TMP102o::DataReceive() {
  Wire.requestFrom(_address, 2);
  if (Wire.available() < 2)
  { _DataReceived[0] = 0;
    _DataReceived[1] = 0;
    return;
  }
  //  Wire.endTransmission();
  _DataReceived[0] = Wire.read();
  _DataReceived[1] = Wire.read();
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

//void TMP102o::Begin(byte Address) {
void TMP102o::Begin() {
//  if (Address != _address) {
//    SetAdress(Address);
//    Initial();
//  }
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
  CreateAndSendPacket(_DataReceived, sizeof(_DataReceived));
  Stop();
}

