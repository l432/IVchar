#ifndef OlegTMP102_H
#define OlegTMP102_H

#if ARDUINO >= 100
  #include <Arduino.h>
#else
  #include <WProgram.h>
#endif

#include "SmartDelay.h"
#include "WireObject.h"
#include "OlegPacket.h"
#include "OlegConstant.h"

class TMP102o: public SmartDelay, public WireObject, public PinAndID
{
  public:
    TMP102o();
    void Begin();
    void Process();

  private:
    void ModeSetup();
    void Initial();
};

#endif

