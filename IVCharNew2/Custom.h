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
//    byte packet[PacketMaxLength];
    for (byte i = 0; i < PacketMaxLength; i++)
      PinAndID::DataFromPC[i]=0;
//      packet[i] = 0;
    byte number = Serial.readBytesUntil(PacketEnd, PinAndID::DataFromPC, PacketMaxLength);
//    byte number = Serial.readBytesUntil(PacketEnd, packet, PacketMaxLength);

    if (number != PinAndID::DataFromPC[0] + 1) return false;
    PinAndID::DataFromPC[PinAndID::DataFromPC[0]] = 0;
 
    if (FCS(PinAndID::DataFromPC, sizeof(PinAndID::DataFromPC)) != 0) return false;
  
    if (PinAndID::DataFromPC[0] < 3) return false;
    
//    if (number != packet[0] + 1) return false;
//    packet[packet[0]] = 0;
// 
//    if (FCS(packet, sizeof(packet)) != 0) return false;
//  
//    if (packet[0] < 3) return false;

    PinAndID::NumberByte = PinAndID::DataFromPC[0];
    PinAndID::DeviceId = PinAndID::DataFromPC[1];
    PinAndID::PinControl = PinAndID::DataFromPC[2];


//    PinAndID::NumberByte = packet[0];
//    PinAndID::DeviceId = packet[1];
//      PinAndID::PinControl = packet[2];
//      PinAndID::Data3 = packet[3];
//      PinAndID::Data4 = packet[4];
//      PinAndID::Data5 = packet[5];
//      PinAndID::Data6 = packet[6];

      
//  ControlBlink();
    return true;
  } else
  {
    return false;
  }
}

//    // считываем входящий байт:
//    incomingByte = Serial.read();
//    if (incomingByte = PacketStart)
//    {
//      byte packet[PacketMaxLength];
//      for (byte i = 0; i < PacketMaxLength; i++)
//        packet[i] = 0;
//      byte number = Serial.readBytesUntil(PacketEnd, packet, PacketMaxLength);
//
//      if (number != packet[0] + 1) goto start;
//      packet[packet[0]] = 0;
//
//      if (FCS(packet, sizeof(packet)) != 0) goto start;
//
//      if (packet[0] < 3) goto start;
//
//
//      PinAndID::DeviceId = packet[1];
//      if (packet[0] > 3) {
//        PinAndID::PinControl = packet[2];
//      }
//      if (packet[0] > 4) {
//        PinAndID::Data3 = packet[3];
//      }


#endif
