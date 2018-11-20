#include "OlegMCP3424.h"

const unsigned long TimeInterval[] = {5000, 17000, 67000, 270000};

MCP3424o::MCP3424o()
{
  SetAdress(0x68);
  Config(0);
}


bool MCP3424o::Begin() {
  if (DeviceId != MCP3424Command) return false;
  if ((NumberByte < 4) || (!isReady())) return true;

  SetAdress(PinControl);
  Config(Data3);
  ByteTransfer(Data3);
  Start();
  return true;
}


void MCP3424o::Process() {
  if (isConversionFinished()) {
    DeviceId = MCP3424Command;
    ActionId = _address;
    CreateAndSendPacket(_DataReceived, GetDataReceivedNumber());
    Stop();
  }
  else {
    if (GetInterval() > TimeInterval[_resolution]) {
      Stop();
    } else {
      SetInterval(round(GetInterval() * 1.35));
    }
  }
}

void MCP3424o::Setup() {
  ByteTransfer(0x00, 0x08);
}

void  MCP3424o::Config(byte ConfigByte) {
  _resolution = ((ConfigByte >> 2) & 0x3);
  if (_resolution == 3) {
    SetDataReceivedNumber(4) ;
  } else {
    SetDataReceivedNumber(3) ;
  };
  SetInterval(TimeInterval[_resolution]);
}

bool MCP3424o::isConversionFinished() {

  DataReceive();
  return !(_DataReceived[GetDataReceivedNumber() - 1] & 0x80);
}


