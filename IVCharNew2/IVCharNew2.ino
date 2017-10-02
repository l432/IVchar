#include <SPI.h>
#include <OneWire.h>
#include <avr/wdt.h>

//#define PacketStart 10
//#define PacketEnd 255
//#define PacketMaxLength 15
//#define V7_21Command 1
//#define ParameterReceiveCommand 2
//#define DACCommand 3
//#define DACR2RCommand 4
//#define DACR2R_Pos 0x00
//#define DACR2R_Neg 0xFF
//#define DACR2R_Reset 0xAA

const byte PacketStart = 10;
const byte PacketEnd = 255;
const byte PacketMaxLength = 15;
const byte V7_21Command = 1;
const byte ParameterReceiveCommand = 2;
const byte DACCommand = 3;
const byte DACR2RCommand = 4;
const byte DACR2R_Pos = 0x00;
const byte DACR2R_Neg = 0xFF;
const byte DACR2R_Reset = 0xAA;
const byte DS18B20Command = 0x5;


byte DrivePins[] = {25, 26, 27, 28, 29, 30, 31, 32, 34, 35};

byte incomingByte = 0;
byte PinControl, PinGate, DeviceId, ActionId;
byte DACR2RPinSign = 33;
byte DS18B20Pin = 36;
OneWire  ds(DS18B20Pin);

byte DACDataReceived[3];
boolean DACR2RPinSignBool;
boolean DS18B20delay;
unsigned long EndDS18B20delay;

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
  pinMode(DACR2RPinSign, OUTPUT);
  digitalWrite(DACR2RPinSign, LOW);
  DACR2RPinSignBool = false;
  DS18B20delay = false;
  EndDS18B20delay = 0;
  wdt_enable(WDTO_500MS);
  //  OneWire  ds(DS18B20Pin);
}

void loop() {
  //start:
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

      if (packet[0] < 3) goto start;
      DeviceId = packet[1];
      if (packet[0] > 4) {
        PinControl = packet[2];
        PinGate = packet[3];
      }

      if (DeviceId == V7_21Command) {
        if (packet[0] < 5) goto start;
        V721();
      }
      if (DeviceId == ParameterReceiveCommand) SendParameters();

      if (DeviceId == DACR2RCommand) {
        if (packet[0] < 8) goto start;
        DACDataReceived[0] = packet[4];
        DACDataReceived[1] = packet[5];
        DACDataReceived[2] = packet[6];
        DACR2R();
      }

      if (DeviceId == DS18B20Command) {
        if (packet[0] < 4) goto start;
        PinControl = packet[2];
        DS18B20();
      }

    }
  }
start:
  if (DS18B20delay && millis() >= EndDS18B20delay) {
    DS18B20End();
  }
  wdt_reset();
}

void ShortDelay() {
  delayMicroseconds(50);
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
  //  delay(1);
  ShortDelay();
}

void GateClose() {
  digitalWrite(PinGate, HIGH);
  //  delay(1);
  ShortDelay();
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
  ActionId = PinControl;
  CreateAndSendPacket(data, sizeof(data));
  GateClose();
}

void SendParameters() {
  ActionId = 0x00;
  CreateAndSendPacket(DrivePins, sizeof(DrivePins));
}

void DACR2R() {
  if (DACDataReceived[2] == DACR2R_Neg && !DACR2RPinSignBool)
  {
    digitalWrite(DACR2RPinSign, HIGH);
    DACR2RPinSignBool = true;
  };

  if (DACDataReceived[2] == DACR2R_Pos && DACR2RPinSignBool)
  {
    digitalWrite(DACR2RPinSign, LOW);
    DACR2RPinSignBool = false;
  };
  digitalWrite(PinControl, LOW);
  SPI.transfer(DACDataReceived[0]);
  SPI.transfer(DACDataReceived[1]);
  digitalWrite(PinControl, HIGH);
}

void DS18B20() {
  if (DS18B20Pin != PinControl)
  {
    delete &ds;
    DS18B20Pin = PinControl;
    OneWire ds(DS18B20Pin);
  };
  //  byte data[2];
  ds.reset();
  ds.write(0xCC);
  ds.write(0x44);

  DS18B20delay = true;
  EndDS18B20delay = millis() + 800;
  //  delay(800);     // maybe 750ms is enough, maybe not
  //  ds.reset();
  //  ds.write(0xCC);
  //  ds.write(0xBE);
  //
  //  for ( byte i = 0; i < 2; i++) {
  //    data[i] = ds.read();
  //  }
  //  ActionId = DS18B20Pin;
  //  CreateAndSendPacket(data, sizeof(data));
}

void DS18B20End() {
  byte data[2];
  ds.reset();
  ds.write(0xCC);
  ds.write(0xBE);

  for ( byte i = 0; i < 2; i++) {
    data[i] = ds.read();
  }
  DeviceId = DS18B20Command;
  ActionId = DS18B20Pin;
  CreateAndSendPacket(data, sizeof(data));
  DS18B20delay = false;
}

