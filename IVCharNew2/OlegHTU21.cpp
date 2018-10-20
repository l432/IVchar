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
//  Wire.requestFrom(0x40, 3);
//  if (Wire.available() < 3) {
//    return;
//  };
//
//  for ( byte i = 0; i < 3; i++) {
//    _DataReceived[i] = Wire.read();
//  }
  DeviceId = HTU21DCommand;
  ActionId = HTU21DCommand;
  CreateAndSendPacket(_DataReceived, GetDataReceivedNumber());
  Stop();
}
