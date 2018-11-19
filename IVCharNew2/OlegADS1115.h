#ifndef OLEG_ADS1115
#define OLEG_ADS1115

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

//#include "SmartDelay.h"
#include "WireObject.h"
#include "OlegPacket.h"
#include "OlegConstant.h"

#define ADS1115_REG_POINTER_CONVERT     (0x00)
#define ADS1115_REG_POINTER_CONFIG      (0x01)
#define ADS1115_REG_POINTER_LOWTHRESH   (0x02)
#define ADS1115_REG_POINTER_HITHRESH    (0x03)

class ADS1115o:/*{public SmartDelay,*/ public WireObject, public PinAndID
{
  public:
    ADS1115o();
    bool Begin();
    void Process();
    void Setup(); //AlRT/RDY pin to Ready state
  private:
    byte _SetupIsNotDone;
    byte _AlertPin;
    //    byte _resolution; //0 - 12 bits, 1 - 14 bits, 2 - 16 bits, 3 - 18 bits
    //    void Config(byte ConfigByte);
    //    bool isConversionFinished();
};


#endif
