#include "OlegHTU21.h"


HTU21o::HTU21o()
{
  SetInterval(55);
  SetAdress(0x40);
  SetDataReceivedNumber(3);
}

void HTU21o::Begin() {
  ByteTransfer(0xF3);
  Start();
}

void HTU21o::Process() {
  if (TimeFromStart()  > 2 * GetInterval()) {
    Stop();
    return;
  }
  DataReceive();
  DeviceId = HTU21DCommand;
  ActionId = HTU21DCommand;
  CreateAndSendPacket(_DataReceived, GetDataReceivedNumber());
  Stop();
}

//void HTU21DBegin() {
//  Wire.beginTransmission(0x40);
//  Wire.write(0xF3);
//  Wire.endTransmission();
//
//  EndHTU21Ddelay = millis() + 55;
//}

//void HTU21DEnd() {
//  if ((millis() - EndHTU21Ddelay ) > 2 * 55) {
//    EndHTU21Ddelay = 0;
//    return;
//  }
//
//  Wire.requestFrom(0x40, 3);
//  if (Wire.available() < 3) {
//    return;
//  };
//
//  byte data[3];
//  for ( byte i = 0; i < 3; i++) {
//    data[i] = Wire.read();
//  }
//  PinAndID::DeviceId = HTU21DCommand;
//  PinAndID::ActionId = HTU21DCommand;
//  PinAndID::CreateAndSendPacket(data, sizeof(data));
//  EndHTU21Ddelay = 0;
//}