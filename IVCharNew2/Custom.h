#ifndef Custom_H
#define Custom_H

#include <Wire.h>

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

class WireObject {
  protected:
    byte _address;
  public:
    WireObject()
    {
      _address = 0;
    }
    void ByteTransfer(byte Data)
    {
      Wire.beginTransmission(_address);
      Wire.write(Data);
      Wire.endTransmission();
    };
    void SetAdress(byte address)
    {
      _address = address;
    }
};


#endif

