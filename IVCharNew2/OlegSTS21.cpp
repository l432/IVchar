#include "OlegSTS21.h"


STS21o::STS21o()
{
  SetInterval(85000);
  SetAdress(0x4A);
  SetDataReceivedNumber(3);
}

bool STS21o::Begin() {
  if (DeviceId != STS21Command) return false;
  if (!isReady()) return true;
  ByteTransfer(0xF3);
  Start();
  return true;  
}


void STS21o::Process() {
  DataReceive();
  DeviceId = STS21Command;
  ActionId = STS21Command;
  CreateAndSendPacket(_DataReceived, GetDataReceivedNumber());
  Stop();
}

