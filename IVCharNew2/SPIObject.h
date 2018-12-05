#ifndef SPIObject_H
#define SPIObject_H

#include <SPI.h>

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

class SPIObject {
  protected:
    byte _pin;

  public:
    SPIObject() {
      _pin = 0;
    }

    void SetPin(byte Pin) {
      _pin = Pin;
    }

    byte getPin() {
      return _pin;
    }

    void TwoByteTransfer(byte Data1, byte Data2) {
      digitalWrite(_pin, LOW);
      SPI.transfer(Data1);
      SPI.transfer(Data2);
      digitalWrite(_pin, HIGH);
    }

    void WordTransfer(byte HighByte, byte LowByte) {
      uint16_t data = (HighByte << 8) + LowByte;
      digitalWrite(_pin, LOW);
      SPI.transfer16(data);
      digitalWrite(_pin, HIGH);
    }

};

#endif
