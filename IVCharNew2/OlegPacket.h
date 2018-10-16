#ifndef OlegPacket_H
#define OlegPacket_H

const byte PacketStart = 10;
const byte PacketEnd = 255;

byte PinControl, PinGate;

byte FCS (byte Data[], int n);
void SendPacket(byte Data[], int n);
void CreateAndSendPacket(byte DDATA[], int n);
void ShortDelay();
void GateOpen();
void GateClose();

#endif

