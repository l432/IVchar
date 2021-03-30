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

const byte AD5752_DAC[] = {0x00, 0x02};

typedef enum  {
  ad_p050,
  ad_p100,
  ad_p108,
  ad_pm050,
  ad_pm100,
  ad_pm108
} ad_OUTPUT_RANGE;

const float  AD5752_GainOutputRange[ad_pm108+1]={2.0,4.0,4.32,4.0,8.0,8.64}; 

const float  AD5752_REFIN=2.5;
const word  AD5752_MaxKod=65535;

class AD5752o: public SPIObject,
  public PinAndID
{
  public:
    AD5752o();
    bool Action();
    void Setup(); //TSD enable/Clamp Enable/0 V on Clear/SDO Disable + 5V diapazone + Power on Ref
    static word VoltageToKod(float Voltage, byte Range);
  private:
    void PowerOn(byte Chanel);
    void PowerOff(byte Chanel);
    void SetOutputRange(byte Chanel, ad_OUTPUT_RANGE Range);
    bool  _SetupIsNotDone;
    byte _PowerByte;
    ad_OUTPUT_RANGE _OutputRange[2];
    bool _PowerOn[2];
};


#endif
