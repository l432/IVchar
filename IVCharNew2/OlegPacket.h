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
void SendParameters();
void SendPacket(byte Data[], int n);
//void CreateAndSendPacket(byte DDATA[], int n);
void ShortDelay();
void GateOpen();
void GateClose();

class PinAndID {
  public:
    static byte PinControl;
    static byte PinGate;
    static byte DeviceId;
    static byte ActionId;
//    static byte packet[PacketMaxLength];
    static void CreateAndSendPacket(byte DDATA[], int n);
};


#endif

