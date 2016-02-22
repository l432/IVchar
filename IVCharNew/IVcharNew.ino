#include <SPI.h>


#define PacketStart 10
#define PacketEnd 255
#define PacketMaxLength 15
#define V7_21Command 1
#define ParameterReceiveCommand 2
#define DACCommand 3
#define DACR2RCommand 4

byte DrivePins[] = {25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35};

byte incomingByte = 0;
byte PinControl, PinGate, DeviceId, ActionId;
byte DACDataToSend[3];
//byte DACDataAnswer[3];

void setup() {
  Serial.begin(115200);
  Serial.setTimeout(50);
  SPI.begin();
  /* Включаем защёлку */
  for (byte i = 0; i < sizeof(DrivePins); i++)
  {
    pinMode(DrivePins[i], OUTPUT);
    digitalWrite(DrivePins[i], HIGH);
  }
}

void loop() {
start:
  if (Serial.available() > 0) {
    // считываем входящий байт:
    incomingByte = Serial.read();
    if (incomingByte = PacketStart)
    {
      byte packet[PacketMaxLength];
      for (byte i = 0; i < PacketMaxLength; i++)
        packet[i] = 0;
      byte number = Serial.readBytesUntil(PacketEnd, packet, PacketMaxLength);

      if (number != packet[0] + 1) goto start;
      packet[packet[0]] = 0;

      if (FCS(packet, sizeof(packet)) != 0) goto start;

      DeviceId = packet[1];
      ActionId = packet[2];

      if (DeviceId == V7_21Command) {
        PinControl = packet[2];
        PinGate = packet[3];
        V721();
      }
      if (DeviceId == ParameterReceiveCommand) SendParameters();

      if (DeviceId == DACR2RCommand) {
        PinControl = packet[2];
        PinGate = packet[3];
        DACDataToSend[0] = packet[4];
        DACDataToSend[1] = packet[5];
        DACR2R();
      }

    }
  }
}


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

void GateOpen() {
  digitalWrite(PinGate, LOW);
  delay(1);
}

void GateClose() {
  digitalWrite(PinGate, HIGH);
  delay(1);
}

void SendPacket(byte Data[], int n) {
  Serial.write(PacketStart);
  Serial.write(Data, n);
  Serial.write(PacketEnd);
}

void CreateAndSendPacket(byte DDATA[], int n) {
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

void V721() {
  GateOpen();
  //  delay(2000);
  digitalWrite(PinControl, LOW);
  digitalWrite(PinControl, HIGH);
  byte data[4];
  for (byte i = 0; i < 4; i++)
  {
    data[i] = SPI.transfer(0);
  }
  CreateAndSendPacket(data, sizeof(data));
  GateClose();
}

void SendParameters() {
  CreateAndSendPacket(DrivePins, sizeof(DrivePins));
}

void DACR2R() {
  GateOpen();
  digitalWrite(PinControl, LOW);
  SPI.transfer(DACDataToSend[0]);
  SPI.transfer(DACDataToSend[1]);
  digitalWrite(PinControl, HIGH);
  GateClose();
}

