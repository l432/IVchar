#include <SPI.h>
//#include <avr/wdt.h>
#include <Wire.h>

#include <OneWire.h>

#include "OlegConstant.h"
#include "OlegPacket.h"
#include "OlegTMP102.h"
#include "OlegHTU21.h"
#include "D30_06.h"
#include "DS18B20.h"
#include "CustomDevice.h"
#include "Custom.h"
#include "OlegMCP3424.h"
#include "OlegADS1115.h"
#include "OlegAD9833.h"
#include "OlegMLX90615.h"
#include "OlegINA226.h"
#include "OlegSTS21.h"
#include "OlegADT74x0.h"
#include "OlegAD5752.h"

DS18B20o ds18b20;
CustomDevice cd;
DACR2R dacR2R(SignPins[0]);
D30_06 d3006(SignPins[1]);
TMP102o tmp102;
HTU21o  htu21;
MCP3424o mcp3424;
ADS1115o ads1115;
AD9833o ad9833;
MLX90615o mlx90615;
INA226o ina226;
STS21o  sts21;
ADT74o adt74x0;
AD5752o ad5752;

void setup() {
  Serial.begin(115200);
  //  Serial.begin(256000);
  Serial.setTimeout(50);
  SPI.begin();
  Wire.begin();

  for (byte i = 0; i < sizeof(DrivePins); i++)
  {
    pinMode(DrivePins[i], OUTPUT);
    digitalWrite(DrivePins[i], HIGH);
  }
  pinMode(LEDPin, OUTPUT);
  for (byte i = 0; i < sizeof(InputPins); i++)
  {
    pinMode(InputPins[i], INPUT);
  }

  dacR2R.Setup();
  d3006.Setup();
  mcp3424.Setup();

  //  wdt_enable(WDTO_4S);
}

void loop() {
//   ControlBlink();
//   delay(1000);
  if (Serial.available() > 0) {
    if (ParameterReceive()) {
backdoor:
//      ControlBlink;
      if (cd.V721()) goto start;
      if (SendParameters()) goto start;
      if (dacR2R.Action()) goto start;
      if (d3006.Begin()) goto start;
      if (ds18b20.Begin()) goto start;
      if (cd.PinChange()) goto start;
      if (htu21.Begin()) goto start;
      if (sts21.Begin()) goto start;
      if (tmp102.Begin()) goto start;
      if (mcp3424.Begin()) goto start;
      if (ads1115.Begin()) goto start;
      if (ad9833.Action()) goto start;
      if (mlx90615.Begin()) goto start;
      if (ina226.Begin()) goto start;
      if (adt74x0.Begin()) goto start;
      if (ad5752.Action()) goto start;
    }
  }
start:
  ds18b20.End();
  d3006.End();
  htu21.End();
  sts21.End();
  tmp102.End();
  mcp3424.End();
  ads1115.End();
  ina226.End();
  adt74x0.End();
  //  wdt_reset();
}










