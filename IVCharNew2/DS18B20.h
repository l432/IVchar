#ifndef DS18B20_H
#define DS18B20_H

#if ARDUINO >= 100
  #include <Arduino.h>
#else
  #include <WProgram.h>
#endif

#include <OneWire.h>
#include "SmartDelay.h"
#include "OlegPacket.h"
#include "OlegConstant.h"

const byte DS18B20Pin = 36;

class DS18B20: public SmartDelay, public PinAndID
{
private:
 OneWire  ds;
 byte _pin;
public:
    DS18B20();
    void Begin();
    void Process();   
};

#endif
