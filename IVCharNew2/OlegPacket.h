#ifndef OLEGPACKET_H
#define OLEGPACKET_H

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

const byte PacketStart = 10;
const byte PacketEnd = 15;
const byte PacketMaxLength = 60;


byte FCS (byte Data[], int n);
bool SendParameters();
void SendPacket(byte Data[], int n);
void ControlBlink(byte n = 1);
void ShortDelay();

byte PinToInterruptNumber(byte PinNumber);
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
    //    static byte Data3;//PinGate;PinToChange
    //    static byte Data4;//DAC_Data1
    //    static byte Data5;//DAC_Data2
    //    static byte Data6;//DAC_Sign
    static void CreateAndSendPacket(byte DDATA[], int n);
    static void NamedByteFill();
    static byte DataFromPC[PacketMaxLength];
};

class FastIVData {
  public:
    static bool ToBackDoor;
    static bool CurrentMeasured;
    static bool VoltageMeasured;
    static byte VoltageMDId;
    static byte CurrentMDId;
    static byte VoltageResultNumber;
    static byte CurrentResultNumber;
    static byte DataToPC[PacketMaxLength];
    static void AddData(byte StartIndex, byte SourceData[], byte NumberToAdd);
    static byte DeviceCheck (byte Id);
};

#endif

