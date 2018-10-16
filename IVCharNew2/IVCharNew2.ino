#include <SPI.h>
#include <OneWire.h>
#include <avr/wdt.h>
#include <Wire.h>
#include "OlegConstant.h"
#include "OlegPacket.h"


//const byte PacketStart = 10;
//const byte PacketEnd = 255;
//const byte PacketMaxLength = 15;
//const byte V7_21Command = 1;
//const byte ParameterReceiveCommand = 2;
//const byte DACCommand = 3;
//const byte DACR2RCommand = 4;
//const byte DAC_Pos = 0x0F;
//const byte DAC_Neg = 0xFF;
//const byte DS18B20Command = 0x5;
//const byte D30_06Command = 0x6;
//const byte PinChangeCommand = 0x7;
//const byte HTU21DCommand = 0x8;
//const byte TMP102Command = 0x9;
//const byte PinToHigh = 0xFF;
//const byte PinToLow = 0x0F;

////For MEGA
//byte DrivePins[] = {25, 26, 27, 28, 29, 30, 31, 32, 34, 35, 41, 42, 43};
//byte SignPins[] = {33, 40};
//byte OneWarePins[] = {36, 37};
//byte DS18B20Pin = 36;
//
////For UNO
////byte DrivePins[] = {2, 3, 4, 5, 6, 7};
////byte SignPins[] = {8, 9};
////byte DS18B20Pin = 10;


OneWire  ds(DS18B20Pin);


byte incomingByte = 0;
//byte PinControl, PinGate, DeviceId, ActionId;
byte DeviceId, ActionId;
byte DACR2RPinSign = SignPins[0];
byte D30_06PinSign = SignPins[1];
byte TMP102_Adress;


byte DACDataReceived[3];
byte D30_06DataReceived[4];
byte TMP102DataReceived[2];

boolean DACR2RPinSignBool;
boolean D30_06PinSignBool;
//boolean DS18B20delay;
//boolean D30_06delay;
unsigned long EndDS18B20delay;
unsigned long EndD30_06delay;
unsigned long EndHTU21Ddelay;
unsigned long EndTMP102delay;


void setup() {
  Serial.begin(115200);
  //  Serial.begin(9600);
  Serial.setTimeout(50);
  SPI.begin();
  /* Включаем защёлку */
  for (byte i = 0; i < sizeof(DrivePins); i++)
  {
    pinMode(DrivePins[i], OUTPUT);
    digitalWrite(DrivePins[i], HIGH);
  }
  for (byte i = 0; i < sizeof(SignPins); i++)
  {
    pinMode(SignPins[i], OUTPUT);
    digitalWrite(SignPins[i], LOW);
  }

  DACR2RPinSignBool = false;
  D30_06PinSignBool = false;
  //  DS18B20delay = false;
  //  D30_06delay = false;
  EndDS18B20delay = 0;
  EndD30_06delay = 0;
  EndHTU21Ddelay = 0;
  EndTMP102delay = 0;
  TMP102_Adress = 0;
  wdt_enable(WDTO_500MS);
  Wire.begin();

  pinMode(12, OUTPUT);
}

void loop() {

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
      if (packet[0] > 3) {
        PinControl = packet[2];
      }
      if (packet[0] > 4) {
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

      //      if ((DeviceId == D30_06Command) && (millis() >= EndD30_06delay)) {
      if ((DeviceId == D30_06Command) && (EndD30_06delay == 0)) {
        if (packet[0] < 8) goto start;
        D30_06DataReceived[0] = packet[4];
        D30_06DataReceived[1] = packet[5];
        D30_06DataReceived[2] = packet[6];
        D30_06DataReceived[3] = PinControl;
        D30_06();
      }

      //      if ((DeviceId == DS18B20Command) && (millis() >= EndDS18B20delay)) {
      if ((DeviceId == DS18B20Command) && (EndDS18B20delay == 0)) {
        if (packet[0] < 4) goto start;
        //        PinControl = packet[2];
        DS18B20();
      }

      if (DeviceId == PinChangeCommand) {
        if (packet[3] == PinToHigh) digitalWrite(PinControl, HIGH);
        if (packet[3] == PinToLow)  digitalWrite(PinControl, LOW);
      }

      if ((DeviceId == HTU21DCommand) && (EndHTU21Ddelay == 0))  {
        HTU21DBegin();
      }

      if ((DeviceId == TMP102Command) && (EndTMP102delay == 0)) {
        if (packet[0] < 4) goto start;
        TMP102First();
      }

    }
  }
start:
  if (EndDS18B20delay && millis() >= EndDS18B20delay) {
    DS18B20End();
  }
  if (EndD30_06delay && millis() >= EndD30_06delay) {
    D30_06_Second();
  }
  if (EndHTU21Ddelay && millis() >= EndHTU21Ddelay) {
    HTU21DEnd();
  }
  if (EndTMP102delay && millis() >= EndTMP102delay) {
    TMP102Second();
  }
  wdt_reset();
}

//void ShortDelay() {
//  delayMicroseconds(50);
//}

//byte FCS (byte Data[], int n)
//{
//  int  FCS = 0;
//  for (byte i = 0; i < n; i++)
//  {
//    FCS += Data[i];
//    while (FCS > 255)
//    {
//      FCS = (FCS & 0xFF) + ((FCS >> 8) & 0xFF);
//    }
//  };
//  FCS = ~FCS;
//  return byte(FCS & 0xFF);
//}

//void GateOpen() {
//  digitalWrite(PinGate, LOW);
//  ShortDelay();
//}
//
//void GateClose() {
//  digitalWrite(PinGate, HIGH);
//  ShortDelay();
//}

//void SendPacket(byte Data[], int n) {
//  Serial.write(PacketStart);
//  Serial.write(Data, n);
//  Serial.write(PacketEnd);
//}

//void CreateAndSendPacket(byte DDATA[], int n) {
//  byte data[n + 4];
//  data[0] = sizeof(data);
//  data[1] = DeviceId;
//  data[2] = ActionId;
//  for (byte i = 0; i < n; i++)
//  {
//    data[i + 3] = DDATA[i];
//  }
//  data[sizeof(data) - 1] = 0;
//  data[sizeof(data) - 1] = FCS(data, data[0]);
//  SendPacket(data, sizeof(data));
//}

void V721() {
  GateOpen();
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
  int PinsNumber=sizeof(DrivePins)+sizeof(OneWarePins)+1;
  byte Pins[PinsNumber];
  for (byte i = 0; i < sizeof(DrivePins); i++)
  {
    Pins[i] = DrivePins[i];
  }  
  Pins[sizeof(DrivePins)]= 100;
  for (byte i = 0; i < sizeof(OneWarePins); i++)
  {
    Pins[sizeof(DrivePins)+1+i] = OneWarePins[i];
  }  
  CreateAndSendPacket(Pins, sizeof(Pins));
  
//  CreateAndSendPacket(DrivePins, sizeof(DrivePins));
}

void SPI2ByteTransfer(byte CSPin, byte Data1, byte Data2) {
  digitalWrite(CSPin, LOW);
  SPI.transfer(Data1);
  SPI.transfer(Data2);
  digitalWrite(CSPin, HIGH);
}

void DACR2R() {
  if (DACDataReceived[2] == DAC_Neg && !DACR2RPinSignBool)
  {
    digitalWrite(DACR2RPinSign, HIGH);
    DACR2RPinSignBool = true;
  };

  if (DACDataReceived[2] == DAC_Pos && DACR2RPinSignBool)
  {
    digitalWrite(DACR2RPinSign, LOW);
    DACR2RPinSignBool = false;
  };
  SPI2ByteTransfer(PinControl, DACDataReceived[0], DACDataReceived[1]);
}

void D30_06() {
  if ((D30_06DataReceived[2] == DAC_Neg && !D30_06PinSignBool) ||
      (D30_06DataReceived[2] == DAC_Pos && D30_06PinSignBool))
  {
    EndD30_06delay = millis() + 500;
    //    D30_06delay = true;
    SPI2ByteTransfer(D30_06DataReceived[3], 0, 0);

  } else {
    SPI2ByteTransfer(D30_06DataReceived[3], D30_06DataReceived[0], D30_06DataReceived[1]);
  }
}

void D30_06_Second() {
  if (D30_06DataReceived[2] == DAC_Neg && !D30_06PinSignBool)
  {
    digitalWrite(D30_06PinSign, HIGH);
    D30_06PinSignBool = true;
  };

  if (D30_06DataReceived[2] == DAC_Pos && D30_06PinSignBool)
  {
    digitalWrite(D30_06PinSign, LOW);
    D30_06PinSignBool = false;
  };
  //  D30_06delay = false;
  EndD30_06delay = 0;
  SPI2ByteTransfer(D30_06DataReceived[3], D30_06DataReceived[0], D30_06DataReceived[1]);
}

void DS18B20() {
  if (DS18B20Pin != PinControl)
  {
    delete &ds;
    DS18B20Pin = PinControl;
    OneWire ds(DS18B20Pin);
  };
  ds.reset();
  ds.write(0xCC);
  ds.write(0x44);

  //  DS18B20delay = true;
  EndDS18B20delay = millis() + 800;
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
  EndDS18B20delay = 0;
}


void HTU21DBegin() {
  Wire.beginTransmission(0x40);
  Wire.write(0xF3);
  Wire.endTransmission();

  EndHTU21Ddelay = millis() + 55;
}

void HTU21DEnd() {
  if ((millis() - EndHTU21Ddelay ) > 2 * 55) {
    EndHTU21Ddelay = 0;
    return;
  }

  Wire.requestFrom(0x40, 3);
  if (Wire.available() < 3) {
    return;
  };

  byte data[3];
  for ( byte i = 0; i < 3; i++) {
    data[i] = Wire.read();
  }
  DeviceId = HTU21DCommand;
  ActionId = HTU21DCommand;
  CreateAndSendPacket(data, sizeof(data));
  EndHTU21Ddelay = 0;
}

void ControlBlink() {
  digitalWrite(12, HIGH);
  delay(200);
  digitalWrite(12, LOW);
}

void TMP3ByteTransfer(byte Data1, byte Data2, byte Data3) {
  Wire.beginTransmission(TMP102_Adress);
  Wire.write(Data1);
  Wire.write(Data2);
  Wire.write(Data3);
  Wire.endTransmission();
}

void TMP2ByteTransfer(byte Data1, byte Data2) {
  Wire.beginTransmission(TMP102_Adress);
  Wire.write(Data1);
  Wire.write(Data2);
  Wire.endTransmission();
}

void TMP1ByteTransfer(byte Data1) {
  Wire.beginTransmission(TMP102_Adress);
  Wire.write(Data1);
  Wire.endTransmission();
}

void TPMDataReceive() {
  Wire.requestFrom(TMP102_Adress, 2);
  Wire.endTransmission();
  TMP102DataReceived[0] = Wire.read();
  TMP102DataReceived[1] = Wire.read();
}


void TMP102First() {
  if (PinControl != TMP102_Adress) {
    TMP102_Adress = PinControl;
    TMP102Initial();
  }

  TMP1ByteTransfer(0x01);
  TPMDataReceive();
  TMP102DataReceived[0] &= 0x7F;
  TMP102DataReceived[0] |= 0x80;
  TMP2ByteTransfer(0x01, TMP102DataReceived[0]);
  //OS->1

  EndTMP102delay = millis() + 30;

}

void TMP102Second () {
  TMP1ByteTransfer(0x00);
  TPMDataReceive();

  DeviceId = TMP102Command;
  ActionId = TMP102_Adress;
  CreateAndSendPacket(TMP102DataReceived, sizeof(TMP102DataReceived));
  EndTMP102delay = 0;
}

void TMP102Initial() {
  TMP3ByteTransfer(0x03, 0x7F, 0xF0);
  // write 127.9375 to Thigh
  TMP3ByteTransfer(0x02, 0x7E, 0x00);
  // write 126 to Tlow

  TMP1ByteTransfer(0x01);
  TPMDataReceive();
  TMP102DataReceived[0] &= 0xFC;
  TMP102DataReceived[0] |= 0x03;
  TMP2ByteTransfer(0x01, TMP102DataReceived[0]);
  //to sleep-mode, to interrupt mode,
}

