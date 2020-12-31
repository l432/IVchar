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
    byte _DataReceived[4];

  public:
    WireObject()
    {
      _address = 0;
    }

    void ByteTransfer(byte Data)
    {
      ByteTransfer(_address, Data);
    }

    void ByteTransferStopFalse(byte Data)
    {
      ByteTransfer(_address, Data, false);
    }    

    void ByteTransfer(byte Address, byte Data, bool Stop=true)
    {
      Wire.beginTransmission(Address);
      Wire.write(Data);
      Wire.endTransmission(Stop);
    }

    void TwoByteTransfer(byte Data1, byte Data2)
    {
      Wire.beginTransmission(_address);
      Wire.write(Data1);
      Wire.write(Data2);
      Wire.endTransmission();
    }

    void ThreeByteTransfer(byte Data1, byte Data2, byte Data3)
    {
      Wire.beginTransmission(_address);
      Wire.write(Data1);
      Wire.write(Data2);
      Wire.write(Data3);
      Wire.endTransmission();
      //      delayMicroseconds(25);
    }

    void  ArrayByteTransfer (byte Data[], int n, bool Stop=true)
    {
      Wire.beginTransmission(_address);
      for (byte i = 0; i < n; i++)
      {
        Wire.write(Data[i]);
      }
      Wire.endTransmission(Stop);
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
      { for (uint8_t i = 0; i < _dataReceivedNumber; i++)
          _DataReceived[i] = 0;
        return;
      }
      for (uint8_t i = 0; i < _dataReceivedNumber; i++)
        _DataReceived[i] = Wire.read();
    }
};


#endif

