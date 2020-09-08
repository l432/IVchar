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

typedef enum  {
  ad_p050,
  ad_p100,
  ad_p108,
  ad_pm050,
  ad_pm100,
  ad_pm108
} ad_OUTPUT_RANGE;

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
    ad_OUTPUT_RANGE _OR_chA;
    ad_OUTPUT_RANGE _OR_chB;
    bool _PowerOn_chA;
    bool _PowerOn_chB;
};


#endif
