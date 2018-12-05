#ifndef D3006_H
#define D3006_H

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include "SmartDelay.h"
#include "DACR2R.h"

class D30_06: public DACR2R,
              public SmartDelay
{
  public:
    D30_06(byte SignPinNumber);
    bool Begin();
    void Process();

  private:
};


#endif
