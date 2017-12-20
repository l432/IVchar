#ifndef ADT74X0_H_INCLUDED
#define ADT74X0_H_INCLUDED
/*
 * ADT74x0.h
 *
 * Author:   Hiromasa Ihara (taisyo)
 * Created:  2016-04-22
 */

#include <Arduino.h>

#define ADT74x0_DEFAULT_ADDRESS 0x48
#define ADT74x0_DEFAULT_TIMEOUT_MS 10

class ADT74x0 {
  private:
    byte addr;

  public:
    void begin(byte addr=ADT74x0_DEFAULT_ADDRESS);
    float readTemperature(uint16_t timeout_ms=ADT74x0_DEFAULT_TIMEOUT_MS);
};

#endif   /* LIB/ADT74X0/ADT74X0_H_INCLUDED */
