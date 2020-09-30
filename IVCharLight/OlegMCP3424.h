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

class MCP3424o: public SmartDelay, public WireObject, public PinAndID//, public FastIVData
{
  public:
    MCP3424o();
    bool Begin();
    void Process();
    void Setup(); //General Call, device will be set to the One-Shot Conversion mode
  private:
    byte _resolution; //0 - 12 bits, 1 - 14 bits, 2 - 16 bits, 3 - 18 bits
    void Config(byte ConfigByte);
    bool isConversionFinished();
};


#endif
