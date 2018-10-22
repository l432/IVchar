#ifndef OLEG_MCP3424_H
#define OLEG_MCP3424_H

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include "SmartDelay.h"
#include "WireObject.h"
#include "OlegPacket.h"
#include "OlegConstant.h"

class MCP3424o: public SmartDelay, public WireObject, public PinAndID
{
  public:
    MCP3424o();
    bool Begin();
    void Process();

  private:
};


#endif
