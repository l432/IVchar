#include "OlegPacket.h"

byte FCS (byte Data[], int n)
{
  int  FCS = 0;
  for (byte i = 0; i < n; i++)
  {
    FCS += Data[i];
    while (FCS > 255)
    {
      FCS = (FCS & 0xFF) + ((FCS >> 8) & 0xFF);
    }
  };
  FCS = ~FCS;
  return byte(FCS & 0xFF);
}

bool SendParameters() {
  if (PinAndID::DeviceId != ParameterReceiveCommand) return false;
  PinAndID::ActionId = 0x00;
  int PinsNumber = sizeof(DrivePins) + sizeof(OneWarePins) + 1;
  byte Pins[PinsNumber];
  for (byte i = 0; i < sizeof(DrivePins); i++)
  {
    Pins[i] = DrivePins[i];
  }
  Pins[sizeof(DrivePins)] = 100;
  for (byte i = 0; i < sizeof(OneWarePins); i++)
  {
    Pins[sizeof(DrivePins) + 1 + i] = OneWarePins[i];
  }
  PinAndID::CreateAndSendPacket(Pins, sizeof(Pins));
  return true;
}

//      if (PinAndID::DeviceId == ParameterReceiveCommand) SendParameters();


void SendPacket(byte Data[], int n) {
  Serial.write(PacketStart);
  Serial.write(Data, n);
  Serial.write(PacketEnd);
}

//void GateOpen() {
//  digitalWrite(PinAndID::Data3, LOW);
//  ShortDelay();
//}
//
//void GateClose() {
//  digitalWrite(PinAndID::Data3, HIGH);
//  ShortDelay();
//}
//
//void ShortDelay() {
//  delayMicroseconds(50);
//}

void ControlBlink() {
  digitalWrite(LEDPin, HIGH);
  delay(200);
  digitalWrite(LEDPin, LOW);
}

byte PinAndID::NumberByte = 0;
byte PinAndID::PinControl = 0;
//byte PinAndID::PinGate = 0;
byte PinAndID::Data3 = 0;
byte PinAndID::DeviceId = 0;
byte PinAndID::ActionId = 0;
byte PinAndID::Data4 = 0;
byte PinAndID::Data5 = 0;
byte PinAndID::Data6 = 0;


void PinAndID::CreateAndSendPacket(byte DDATA[], int n) {
  byte data[n + 4];
  data[0] = sizeof(data);
  data[1] = DeviceId;
  data[2] = ActionId;
  for (byte i = 0; i < n; i++)
  {
    data[i + 3] = DDATA[i];
  }
  data[sizeof(data) - 1] = 0;
  data[sizeof(data) - 1] = FCS(data, data[0]);
  SendPacket(data, sizeof(data));
}

