#ifndef CUSTOM_H
#define CUSTOM_H

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include "OlegPacket.h"



bool ParameterReceive() {


  byte incomingByte = Serial.read();
  if (incomingByte = PacketStart)
  {
    for (byte i = 0; i < PacketMaxLength; i++)
      PinAndID::DataFromPC[i] = 0;


    byte number  = Serial.readBytesUntil(PacketEnd, PinAndID::DataFromPC, PacketMaxLength);

    // for (byte i = 0; i < number; i++)
    //ControlBlink();


    if (number == PinAndID::DataFromPC[0] - 1)
    {
      PinAndID::DataFromPC[number] = PacketEnd;
      number += 1;
      //      ControlBlink();
    }
    if (number != PinAndID::DataFromPC[0] ) return false;


    PinAndID::DataFromPC[PinAndID::DataFromPC[0]] = 0;

    if (FCS(PinAndID::DataFromPC, sizeof(PinAndID::DataFromPC)) != 0) return false;



    number = PinAndID::DataFromPC[1];
    for (byte i = 1; i <= number; i++) {
      PinAndID::DataFromPC[PinAndID::DataFromPC[i + 1]]++;
    };
    for (byte i = 1; i < (PinAndID::DataFromPC[0] - number - 1); i++) {
      PinAndID::DataFromPC[i] = PinAndID::DataFromPC[i + 1 + number];
    };

    for (byte i = PinAndID::DataFromPC[0]; i < PacketMaxLength; i++)
      PinAndID::DataFromPC[i] = 0;

    PinAndID::DataFromPC[0] = PinAndID::DataFromPC[0] - 1 - number;

    if (PinAndID::DataFromPC[0] < 3) return false;

    PinAndID::NamedByteFill();
    //    PinAndID::NumberByte = PinAndID::DataFromPC[0];
    //    PinAndID::DeviceId = PinAndID::DataFromPC[1];
    //    PinAndID::PinControl = PinAndID::DataFromPC[2];


    return true;
  } else
  {
    return false;
  }
}


#endif
