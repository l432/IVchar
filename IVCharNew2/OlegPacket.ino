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


void SendPacket(byte Data[], int n) {
  Serial.write(PacketStart);
  Serial.write(Data, n);
  Serial.write(PacketEnd);
}


void ControlBlink(byte n ) {
  for (byte i = 0; i < n; i++) {
    digitalWrite(LEDPin, HIGH);
    delay(200);
    digitalWrite(LEDPin, LOW);
    delay(500);
  }
}

void ShortDelay() {
  delayMicroseconds(50);
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
byte PinAndID::DeviceId = 0;
byte PinAndID::ActionId = 0;
byte PinAndID::DataFromPC[PacketMaxLength] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                                             };


void PinAndID::CreateAndSendPacket(byte DDATA[], int n) {
  byte ProblemByteNumber = 0;
  for (byte i = 0; i < n; i++)
  {
    if (DDATA[i] == PacketEnd) ProblemByteNumber++;
  }

  byte data[n + 4 + ProblemByteNumber + 1];
  data[0] = sizeof(data);
  data[1] = ProblemByteNumber;
  byte counter = 2;
  for (byte i = 0; i < n; i++)
  {
    if (DDATA[i] == PacketEnd) {
      DDATA[i]--;
      data[counter++] = i + 4 + ProblemByteNumber;
    }
  }
  data[counter++] = DeviceId;
  data[counter++] = ActionId;
  for (byte i = 0; i < n; i++)
  {
    data[counter++] = DDATA[i];
  }

  data[sizeof(data) - 1] = 0;
  data[sizeof(data) - 1] = FCS(data, data[0]);
  SendPacket(data, sizeof(data));
}

void PinAndID::NamedByteFill() {
  NumberByte = DataFromPC[0];
  DeviceId = DataFromPC[1];
  PinControl = DataFromPC[2];
}

bool FastIVData::ToBackDoor = false;
bool FastIVData::CurrentMeasured = false;
bool FastIVData::VoltageMeasured = false;
byte FastIVData::VoltageMDId = 0;
byte FastIVData::CurrentMDId = 0;
byte FastIVData::VoltageResultNumber = 0;
byte FastIVData::CurrentResultNumber = 0;
byte FastIVData::DataToPC[PacketMaxLength] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                                             };

void FastIVData::AddData(byte StartIndex, byte SourceData[], byte NumberToAdd) {
  for (byte i = 0; i < NumberToAdd; i++) {
    DataToPC[StartIndex + i] = SourceData[i];
  }
}

byte FastIVData::DeviceCheck (byte Id) {
  if (Id == VoltageMDId) {
    VoltageMeasured = true;
    VoltageMDId = 0;
    return VoltageResultNumber;
  };
  if (Id == CurrentMDId) {
    CurrentMeasured = true;
    CurrentMDId = 0;
    return CurrentResultNumber;
  };
  return 0xFF;
}

