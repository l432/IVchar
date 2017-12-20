/*
 * ADT74x0.cpp
 *
 * Author:   Hiromasa Ihara (taisyo)
 * Created:  2016-04-22
 */

#include "ADT74x0.h"

#include <math.h>

#include <Arduino.h>
#include <Wire.h>

void ADT74x0::begin(byte addr){
  this->addr = addr;
  Wire.beginTransmission(this->addr);
  Wire.write(0x03);
  Wire.write(0x80);
  Wire.endTransmission();
}

float ADT74x0::readTemperature(unsigned int timeout_ms){
  uint16_t start_ms = millis();
  uint16_t d;

  Wire.requestFrom(this->addr, 2U);

  while(Wire.available() < 2){
    if(millis() - start_ms > timeout_ms){
      return NAN;
    }
  }

  d = Wire.read()<<8;
  d |= Wire.read();

  if(((d>>15)&1) == 0){
    return d/128.0;
  }else{
    return (d-65536)/128.0;
  }
}
