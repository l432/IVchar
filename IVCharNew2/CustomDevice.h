#ifndef CUSTOM_DEVICE_H
#define CUSTOM_DEVICE_H

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include "OlegPacket.h"

class CustomDevice: public PinAndID
{
  private:
//    void ShortDelay() {
//      delayMicroseconds(50);
//    }

    void GateOpen() {
      digitalWrite(DataFromPC[3], LOW);
      ShortDelay();
    }

    void GateClose() {
        digitalWrite(DataFromPC[3], HIGH);
       ShortDelay();
    }

  public:
    bool V721() {
      if (DeviceId != V7_21Command) return false;
      if (NumberByte < 5) return true;

      

      GateOpen();
      digitalWrite(PinControl, LOW);
      digitalWrite(PinControl, HIGH);
      byte data[4];
      for (byte i = 0; i < 4; i++)
      {
        data[i] = SPI.transfer(0);
      }
      ActionId = PinControl;
      CreateAndSendPacket(data, sizeof(data));
      GateClose();
      return true;
    }
    bool PinChange() {
      if (DeviceId != PinChangeCommand) return false;
//      if (Data3 == PinToHigh) digitalWrite(PinControl, HIGH);
//      if (Data3 == PinToLow)  digitalWrite(PinControl, LOW);
      if (DataFromPC[3] == PinToHigh) digitalWrite(PinControl, HIGH);
      if (DataFromPC[3] == PinToLow)  digitalWrite(PinControl, LOW);
      return true;
    }
};


#endif

//      if (PinAndID::DeviceId == PinChangeCommand) {
//        if (packet[3] == PinToHigh) digitalWrite(PinAndID::PinControl, HIGH);
//        if (packet[3] == PinToLow)  digitalWrite(PinAndID::PinControl, LOW);
//      }

//void V721() {
//  GateOpen();
//  digitalWrite(PinAndID::PinControl, LOW);
//  digitalWrite(PinAndID::PinControl, HIGH);
//  byte data[4];
//  for (byte i = 0; i < 4; i++)
//  {
//    data[i] = SPI.transfer(0);
//  }
//  PinAndID::ActionId = PinAndID::PinControl;
//  PinAndID::CreateAndSendPacket(data, sizeof(data));
//  GateClose();
//}

//      if (PinAndID::DeviceId == V7_21Command) {
//        if (packet[0] < 5) goto start;
//        V721();
//      }
