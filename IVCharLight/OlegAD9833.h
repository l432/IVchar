#ifndef OLEGAD9833_H
#define OLEGAD9833_H

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include "SPIObject.h"
#include "OlegPacket.h"
#include "OlegConstant.h"

class AD9833o: public SPIObject,
  public PinAndID
{
  public:
    AD9833o();
    bool Action();
    void Setup(); //AlRT/RDY pin to Ready state
  private:
    bool  _SetupIsNotDone;
};


#endif
