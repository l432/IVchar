#ifndef OLEGPACKET_H
#define OLEGPACKET_H

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

const byte PacketStart = 10;
const byte PacketEnd = 255;
const byte PacketMaxLength = 15;

byte FCS (byte Data[], int n);
bool SendParameters();
void SendPacket(byte Data[], int n);
void ControlBlink();
//void CreateAndSendPacket(byte DDATA[], int n);
//void ShortDelay();
//void GateOpen();
//void GateClose();

class PinAndID {
  public:
    static byte NumberByte;
    static byte DeviceId;
    static byte ActionId;
    static byte PinControl;//PinControl;
//    static byte PinGate;//PinControl;  
    static byte Data3;//PinGate;PinToChange
    static byte Data4;//DAC_Data1
    static byte Data5;//DAC_Data2
    static byte Data6;//DAC_Sign  
    static void CreateAndSendPacket(byte DDATA[], int n);
};


#endif

