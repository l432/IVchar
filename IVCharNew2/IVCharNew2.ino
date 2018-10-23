#include <SPI.h>
#include <avr/wdt.h>
#include <Wire.h>

#include <OneWire.h>

#include "OlegConstant.h"
//#include "OlegPacket.h"
#include "OlegTMP102.h"
#include "OlegHTU21.h"
#include "D30_06.h"
#include "DS18B20.h"
#include "CustomDevice.h"
#include "Custom.h"
#include "OlegMCP3424.h"

DS18B20o ds18b20;
CustomDevice cd;
DACR2R dacR2R(SignPins[0]);
D30_06 d3006(SignPins[1]);
TMP102o tmp102;
HTU21o  htu21;
MCP3424o mcp3424;


void setup() {
  Serial.begin(115200);
  //  Serial.begin(9600);
  Serial.setTimeout(50);
  SPI.begin();
  Wire.begin();
  
  for (byte i = 0; i < sizeof(DrivePins); i++)
  {
    pinMode(DrivePins[i], OUTPUT);
    digitalWrite(DrivePins[i], HIGH);
  }
  pinMode(LEDPin, OUTPUT);
  dacR2R.Setup();
  d3006.Setup();
  mcp3424.Setup();

  wdt_enable(WDTO_500MS);

}

void loop() {

  if (Serial.available() > 0) {
    if (ParameterReceive()) {
      if (cd.V721()) goto start;
      if (SendParameters()) goto start;
      if (dacR2R.Action()) goto start;
      if (d3006.Begin()) goto start;
      if (ds18b20.Begin()) goto start;
      if (cd.PinChange()) goto start;
      if (htu21.Begin()) goto start;
      if (tmp102.Begin()) goto start;
      if (mcp3424.Begin()) goto start;
    }
  }
start:
  ds18b20.End();
  d3006.End();
  htu21.End();
  tmp102.End();
  mcp3424.End();
  wdt_reset();
}










