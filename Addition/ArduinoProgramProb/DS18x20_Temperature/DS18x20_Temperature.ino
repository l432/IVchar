#include <OneWire.h>

//#include <DallasTemperature.h>

OneWire  ds(10);  // on pin 10 (a 4.7K resistor is necessary)
//DallasTemperature sensors(&ds);
//DeviceAddress insideThermometer;

void setup(void) {
  Serial.begin(9600);
}

void loop(void) {
  byte i;
  byte present = 0;
  byte type_s;
  byte data[12];
  byte addr[8];
  float celsius, fahrenheit;

  ds.reset();
  ds.write(0xCC);
  ds.write(0x44);
  delay(800);     // maybe 750ms is enough, maybe not
  ds.reset();
ds.write(0xCC);
ds.write(0xBE);
  
  for ( i = 0; i < 9; i++) {           // we need 9 bytes
    data[i] = ds.read();
//    Serial.print(data[i], HEX);
//    Serial.print(" ");
  }
//  Serial.print(" CRC=");
//  Serial.print(OneWire::crc8(data, 8), HEX);
//  Serial.println();

  int16_t raw = (data[1] << 8) | data[0];
  celsius = (float)raw / 16.0;
  Serial.print("  Temperature = ");
  Serial.print(celsius);
  Serial.println(" Celsius, ");

//  Serial.println(sensors.getResolution(), DEC);
// sensors.setResolution(12);
//    Serial.println(sensors.getResolution(), DEC);
//
//   float tempC = sensors.getTempC(insideThermometer);
//  Serial.print("Temp C: ");
//  Serial.println(tempC);
}
