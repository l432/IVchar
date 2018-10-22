#include "OlegMCP3424.h"


MCP3424o::MCP3424o()
{
  SetInterval(5);
  SetDataReceivedNumber(3);
  SetAdress(0x68);
}


bool MCP3424o::Begin() {
//  if (DeviceId != TMP102Command) return false;
//  if ((NumberByte < 4) || (!isReady())) return true;
//
//  if (PinControl != _address) {
//    SetAdress(PinControl);
//    Initial();
//  }
//
//  ByteTransfer(0x01);
//  DataReceive();
//  _DataReceived[0] &= 0x7F;
//  _DataReceived[0] |= 0x80;
//  ModeSetup();
//  //  TMP2ByteTransfer(0x01, TMP102DataReceived[0]);
//  //OS->1
  Start();
  return true;
}


void MCP3424o::Process() {
//  ByteTransfer(0x00);
//  DataReceive();
//
//  DeviceId = TMP102Command;
//  ActionId = _address;
//  CreateAndSendPacket(_DataReceived, GetDataReceivedNumber());
  Stop();
}



