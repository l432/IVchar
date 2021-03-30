#ifndef OlegSTS21_H
#define OlegSTS21_H

#if ARDUINO >= 100
  #include <Arduino.h>
#else
  #include <WProgram.h>
#endif

#include "SmartDelay.h"
#include "WireObject.h"
#include "OlegPacket.h"
#include "OlegConstant.h"


class STS21o: public SmartDelay, public WireObject, public PinAndID
{
  public:
    STS21o();
    bool Begin();
    void Process();
};

#endif
