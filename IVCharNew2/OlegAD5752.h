#ifndef OLEGAD5752_H
#define OLEGAD5752_H

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include "SPIObject.h"
#include "OlegPacket.h"
#include "OlegConstant.h"

class AD5752o: public SPIObject,
  public PinAndID
{
  public:
    AD5752o();
    bool Action();
    void Setup(); //TSD enable/Clamp Enable/0 V on Clear/SDO Disable + 5V diapazone + Power on Ref
  private:
    bool  _SetupIsNotDone;
    byte _PowerByte;
};


#endif
