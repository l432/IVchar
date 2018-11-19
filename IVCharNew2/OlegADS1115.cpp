#include "OlegADS1115.h"

//const unsigned long TimeInterval[] = {5, 17, 67, 270};

ADS1115o::ADS1115o()
{
  SetAdress(0x48);
  SetDataReceivedNumber(2);
  _SetupIsNotDone = true;
  _AlertPin = 0;
}


bool ADS1115o::Begin() {
  if (DeviceId != ADS1115Command) return false;
  if (NumberByte < 6)  return true;

  SetAdress(PinControl);
  if (_SetupIsNotDone) Setup();
  _AlertPin = Data3;
  ThreeByteTransfer(ADS1115_REG_POINTER_CONFIG, Data4, Data5);
//  attachInterrupt(PinToInterruptNumber(_AlertPin), Process, RISING)
  return true;
}



void ADS1115o::Process() {
  ByteTransfer(ADS1115_REG_POINTER_CONFIG);
  DataReceive();
  _DataReceived[GetDataReceivedNumber()] = _DataReceived[0];
  ByteTransfer(ADS1115_REG_POINTER_CONVERT);
  DataReceive();
  DeviceId = ADS1115Command;
  ActionId = _address;
  CreateAndSendPacket(_DataReceived, GetDataReceivedNumber() + 1);
//  detachInterrupt(PinToInterruptNumber(_AlertPin));
}

void ADS1115o::Setup() {
  ThreeByteTransfer(ADS1115_REG_POINTER_LOWTHRESH, 0x00, 0x00);
  ThreeByteTransfer(ADS1115_REG_POINTER_HITHRESH, 0xFF, 0xFF);
  _SetupIsNotDone = false;
}
//
//void  ADS1115o::Config(byte ConfigByte) {
//  _resolution = ((ConfigByte >> 2) & 0x3);
//  if (_resolution == 3) {
//    SetDataReceivedNumber(4) ;
//  } else {
//    SetDataReceivedNumber(3) ;
//  };
//  SetInterval(TimeInterval[_resolution]);
//}
//
//bool ADS1115o::isConversionFinished() {
//
//  DataReceive();
//  return !(_DataReceived[GetDataReceivedNumber() - 1] & 0x80);
//}


