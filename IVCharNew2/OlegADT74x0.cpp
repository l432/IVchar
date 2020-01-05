#include "OlegADT74x0.h"


ADT74o::ADT74o()
{
  adtInit =  ADT_Init(*this);
  adtOneShot = ADT_OneShot(*this);
  adtShutDown = ADT_ShutDown(*this);
  adtstate = adtInit;
}


bool ADT74o::Begin() {
  if (DeviceId != ADT74x0Command) return false;
  if ((NumberByte < 4) || (!isReady())) return true;

  if (PinControl != _address) {
    SetAdress(PinControl);
  }

  adtstate.Begin();
  Start();
  return true;
}

bool ADT74o::DataIsReady() {
  ByteTransfer(0x02);
  DataReceive();
  // read Status Register
  return (_DataReceived[0] & 0x80);
}

void ADT74o::Process() {
  if (adtstate.End()) {
    DeviceId = ADT74x0Command;
    ActionId = _address;
    CreateAndSendPacket(_DataReceived, GetDataReceivedNumber());
    Stop();
  };
}

void ADT_Init::Begin()
{
  adt74in.TwoByteTransfer(0x03, 0xA0);
  // Configuration Registr
  //  1 fault
  //  CT pin active low
  //  INT pin active low
  //  interrupt mode
  //  one shot mode
  //  16-bit resolution

  adt74in.ThreeByteTransfer(0x04, 0x49, 0x80);
  //  write 147 to Thigh
  adt74in.ThreeByteTransfer(0x06, 0xEC, 0x80);
  //  write -39 to Tlow

  adt74in.adtstate = adt74in.adtOneShot;
  adt74in.adtstate.Begin();
}


void ADT_OneShot::Begin()
{
  adt74in.SetInterval(240000);
  adt74in.SetDataReceivedNumber(1);
  adt74in.TwoByteTransfer(0x03, 0xA0);
}

bool ADT_OneShot::End()
{
  if (adt74in.DataIsReady()) {
    adt74in.SetDataReceivedNumber(2);
    adt74in.ByteTransfer(0x00);
    adt74in.DataReceive();
    //  read Temperature value Register

    adt74in.TwoByteTransfer(0x03, 0xE0);
    // shut down
    adt74in.adtstate = adt74in.adtShutDown;
  };
  return true;
}

void ADT_ShutDown::Begin()
{
  adt74in.SetInterval(2000);
  adt74in.TwoByteTransfer(0x03, 0x80);
}

bool ADT_ShutDown::End()
{
  adt74in.adtstate = adt74in.adtOneShot;
  adt74in.adtstate.Begin();
  adt74in.Start();
  return false;
}


