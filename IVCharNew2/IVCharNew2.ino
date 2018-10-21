#include <SPI.h>
#include <avr/wdt.h>
#include <Wire.h>


#include "OlegConstant.h"
#include "OlegPacket.h"
#include "OlegTMP102.h"
#include "OlegHTU21.h"
#include "D30_06.h"
#include "DS18B20.h"



DS18B20 ds18b20;

byte incomingByte = 0;

DACR2R dacR2R(SignPins[0]);
D30_06 d3006(SignPins[1]);
TMP102o tmp102;
HTU21o  htu21;


void setup() {
  Serial.begin(115200);
  //  Serial.begin(9600);
  Serial.setTimeout(50);
  SPI.begin();

  for (byte i = 0; i < sizeof(DrivePins); i++)
  {
    pinMode(DrivePins[i], OUTPUT);
    digitalWrite(DrivePins[i], HIGH);
  }
  pinMode(LEDPin, OUTPUT);
  dacR2R.Setup();
  d3006.Setup();

  wdt_enable(WDTO_500MS);
  Wire.begin();
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


      PinAndID::DeviceId = packet[1];
      if (packet[0] > 3) {
        PinAndID::PinControl = packet[2];
      }
      if (packet[0] > 4) {
        PinAndID::PinGate = packet[3];
      }

      if (PinAndID::DeviceId == V7_21Command) {
        if (packet[0] < 5) goto start;
        V721();
      }
      if (PinAndID::DeviceId == ParameterReceiveCommand) SendParameters();

      if (PinAndID::DeviceId == DACR2RCommand) {
        if (packet[0] < 8) goto start;
        dacR2R.Action(packet[4], packet[5], packet[6]);
      }

      if ((PinAndID::DeviceId == D30_06Command) && (d3006.isReady())) {
        if (packet[0] < 8) goto start;
        d3006.Begin(packet[4], packet[5], packet[6]);
      }

      if ((PinAndID::DeviceId == DS18B20Command) && (ds18b20.isReady())) {
        if (packet[0] < 4) goto start;
        ds18b20.Begin();
      }

      if (PinAndID::DeviceId == PinChangeCommand) {
        if (packet[3] == PinToHigh) digitalWrite(PinAndID::PinControl, HIGH);
        if (packet[3] == PinToLow)  digitalWrite(PinAndID::PinControl, LOW);
      }

      if ((PinAndID::DeviceId == HTU21DCommand) && (htu21.isReady()))  {
        htu21.Begin();
      }

      if ((PinAndID::DeviceId == TMP102Command) && (tmp102.isReady())) {
        if (packet[0] < 4) goto start;
        tmp102.Begin();
      }

    }
  }
start:
  ds18b20.End();
  d3006.End();
  htu21.End();
  tmp102.End();
  wdt_reset();
}


void V721() {
  GateOpen();
  digitalWrite(PinAndID::PinControl, LOW);
  digitalWrite(PinAndID::PinControl, HIGH);
  byte data[4];
  for (byte i = 0; i < 4; i++)
  {
    data[i] = SPI.transfer(0);
  }
  PinAndID::ActionId = PinAndID::PinControl;
  PinAndID::CreateAndSendPacket(data, sizeof(data));
  GateClose();
}







