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
    byte _dataReceivedNumber;
    byte _DataReceived[3];

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
    }

    void SetAdress(byte address)
    {
      _address = address;
    }
    void SetDataReceivedNumber(byte DataReceivedNumber) {
      _dataReceivedNumber = DataReceivedNumber;
    }

    byte GetDataReceivedNumber() {
      return _dataReceivedNumber;
    }

    void DataReceive() {
      Wire.requestFrom(_address, _dataReceivedNumber);
      if (Wire.available() < _dataReceivedNumber)
      { for (byte i = 0; i < _dataReceivedNumber; i++)
          _DataReceived[i] = 0;
        return;
      }
      for (byte i = 0; i < _dataReceivedNumber; i++)
        _DataReceived[i] = Wire.read();
    }
};


#endif

