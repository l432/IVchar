#ifndef DACR2R_H
#define DACR2R_H

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include "SPIObject.h"
#include "SignPinObject.h"
#include "OlegPacket.h"

class DACR2R: public SignPinObject,
              public SPIObject,
              public PinAndID
{
  public:
    DACR2R(byte SignPinNumber);
    virtual void Begin(byte Data1, byte Data2, byte Sign);
    void DataTransfer();
    void BeginDataRead(byte Data1, byte Data2);

  private:
    byte _DataReceived[2];
};


#endif
