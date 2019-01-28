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
  int PinsNumber = sizeof(DrivePins) + sizeof(OneWarePins) + 1 + sizeof(InputPins) + 1;
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
  Pins[sizeof(DrivePins) + sizeof(OneWarePins) + 1] = 200;
  for (byte i = 0; i < sizeof(InputPins); i++)
  {
    Pins[sizeof(DrivePins) + sizeof(OneWarePins) + 2 + i] = InputPins[i];
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

byte PinToInterruptNumber(byte PinNumber) {
  if (PinNumber == 2) return 0;
  if (PinNumber == 3) return 1;
  if (PinNumber == 18) return 5;
  if (PinNumber == 19) return 4;
  if (PinNumber == 20) return 3;
  if (PinNumber == 21) return 2;
}


byte PinAndID::NumberByte = 0;
byte PinAndID::PinControl = 0;
//byte PinAndID::PinGate = 0;
//byte PinAndID::Data3 = 0;
byte PinAndID::DeviceId = 0;
byte PinAndID::ActionId = 0;
//byte PinAndID::Data4 = 0;
//byte PinAndID::Data5 = 0;
//byte PinAndID::Data6 = 0;
byte PinAndID::DataFromPC[PacketMaxLength] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};


void PinAndID::CreateAndSendPacket(byte DDATA[], int n) {
  byte ProblemByteNumber = 0;
  for (byte i = 0; i < n; i++)
  {
    if (DDATA[i] == PacketEnd) ProblemByteNumber++;
  }

  byte data[n + 4 + ProblemByteNumber + 1];
  data[0] = sizeof(data);
  data[1] = ProblemByteNumber;
  byte counter=2;
  for (byte i = 0; i < n; i++)
  {
    if (DDATA[i] == PacketEnd) {
    DDATA[i]--;
    data[counter++]=i+4+ProblemByteNumber;
    }
  }  
  data[counter++] = DeviceId;
  data[counter++] = ActionId;
  for (byte i = 0; i < n; i++)
  {
    data[counter++] = DDATA[i];
  }

  //  byte data[n + 4];
  //  data[0] = sizeof(data);
  //  data[1] = DeviceId;
  //  data[2] = ActionId;
  //  for (byte i = 0; i < n; i++)
  //  {
  //    data[i + 3] = DDATA[i];
  //  }
  data[sizeof(data) - 1] = 0;
  data[sizeof(data) - 1] = FCS(data, data[0]);
  SendPacket(data, sizeof(data));
}

