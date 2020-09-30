#ifndef OlegHTU21_H
#define OlegHTU21_H

#if ARDUINO >= 100
  #include <Arduino.h>
#else
  #include <WProgram.h>
#endif

#include "SmartDelay.h"
#include "WireObject.h"
#include "OlegPacket.h"
#include "OlegConstant.h"


class HTU21o: public SmartDelay, public WireObject, public PinAndID
{
  public:
    HTU21o();
    bool Begin();
    void Process();

//  private:
};

#endif
