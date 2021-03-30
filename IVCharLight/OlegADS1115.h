#ifndef OLEG_ADS1115
#define OLEG_ADS1115

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include "SmartDelay.h"
#include "WireObject.h"
#include "OlegPacket.h"
#include "OlegConstant.h"

#define ADS1115_REG_POINTER_CONVERT     (0x00)
#define ADS1115_REG_POINTER_CONFIG      (0x01)
#define ADS1115_REG_POINTER_LOWTHRESH   (0x02)
#define ADS1115_REG_POINTER_HITHRESH    (0x03)

typedef enum  {
  ADS_DR8 = 0x00,
  ADS_DR16 = 0x20,
  ADS_DR32 = 0x40,
  ADS_DR64 = 0x60,
  ADS_DR128 = 0x80,
  ADS_DR250 = 0xA0,
  ADS_DR475 = 0xC0,
  ADS_DR860 = 0xE0
} ads_DATA_RATE_t;


class ADS1115o: public SmartDelay, public WireObject, public PinAndID//, public FastIVData
{
  public:
    ADS1115o();
    bool Begin();
    void Process();
//    void Setup(); //AlRT/RDY pin to Ready state
  private:
//    byte            _SetupIsNotDone;
//    byte            _AlertPin;
    ads_DATA_RATE_t _dataRate;
    void Config(byte ConfigByte);
    bool isConversionFinished();
    unsigned long DelayTime();    
};


#endif
