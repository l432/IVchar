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
    int _speedMaximum;
    int _dataOrder;
    int _dataMode;

  public:
    SPIObject() {
      _pin = 0;
      _speedMaximum = SPI_CLOCK_DIV4;
      _dataOrder = MSBFIRST;
      _dataMode = SPI_MODE0;
    }

    void SetPin(byte Pin) {
      _pin = Pin;
    }

    byte getPin() {
      return _pin;
    }

    void TwoByteTransfer(byte Data1, byte Data2) {
      SPI.beginTransaction(SPISettings(_speedMaximum, _dataOrder, _dataMode));
      digitalWrite(_pin, LOW);
      SPI.transfer(Data1);
      SPI.transfer(Data2);
      digitalWrite(_pin, HIGH);
      SPI.endTransaction();
    }

    void WordTransfer(byte HighByte, byte LowByte) {
      uint16_t data = (HighByte << 8) + LowByte;
      SPI.beginTransaction(SPISettings(_speedMaximum, _dataOrder, _dataMode));
      digitalWrite(_pin, LOW);
      SPI.transfer16(data);
      digitalWrite(_pin, HIGH);
      SPI.endTransaction();
    }

    void ThreeByteTransfer(byte Data1, byte Data2, byte Data3) {
      SPI.beginTransaction(SPISettings(_speedMaximum, _dataOrder, _dataMode));
      digitalWrite(_pin, LOW);
      SPI.transfer(Data1);
      SPI.transfer(Data2);
      SPI.transfer(Data3);      
      digitalWrite(_pin, HIGH);
      SPI.endTransaction();
    }
    
    void ArrayByteTransfer (byte Data[], int n) {
      SPI.beginTransaction(SPISettings(_speedMaximum, _dataOrder, _dataMode));
      digitalWrite(_pin, LOW);
      for (byte i = 0; i < n; i++) {
        SPI.transfer(Data[i]);
      }
      digitalWrite(_pin, HIGH);
      SPI.endTransaction();
    }

};

#endif
