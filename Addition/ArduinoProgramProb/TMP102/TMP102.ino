#include <Wire.h>

#define TEMPERATURE_REGISTER 0x00
#define CONFIG_REGISTER 0x01
#define T_LOW_REGISTER 0x02
#define T_HIGH_REGISTER 0x03
#define _address 0x49

uint8_t registerByte[2];
uint8_t rByte;

void setup() {
  Serial.begin(9600);
  Wire.begin();


  Wire.beginTransmission(_address);
  Wire.write(T_HIGH_REGISTER);   // Point to T_HIGH register
  Wire.write(0x7F);  // Write first byte
  Wire.write(0xF0);  // Write second byte
  Wire.endTransmission();
  //127.9375

  Wire.beginTransmission(_address);
  Wire.write(T_LOW_REGISTER);   // Point to T_HIGH register
  Wire.write(0x7E);  // Write first byte
  Wire.write(0x00);  // Write second byte
  Wire.endTransmission();
  //126


  Wire.beginTransmission(_address); // Connect to TMP102
  Wire.write(CONFIG_REGISTER); // Open specified register
  Wire.endTransmission();

  Wire.requestFrom(_address, 2);  // Read two bytes from TMP102
  Wire.endTransmission();
  registerByte[0] = (Wire.read());  // Read first byte
  registerByte[1] = (Wire.read());  // Read second byte
  rByte = registerByte[0];
  rByte &= 0xFD;
  rByte |= 2;

  rByte |= 0x01;  //sleep

  Wire.beginTransmission(_address);
  Wire.write(CONFIG_REGISTER);  // Point to configuration register
  Wire.write(rByte);     // Write byte to register
  Wire.endTransmission();       // Close communication with TMP102
  //interrupt regim
}

void loop() {
  Wire.beginTransmission(_address); // Connect to TMP102
  Wire.write(CONFIG_REGISTER); // Open specified register
  Wire.endTransmission();

  Wire.requestFrom(_address, 2);  // Read two bytes from TMP102
  Wire.endTransmission();
  rByte = (Wire.read());  // Read first byte
  registerByte[1] = (Wire.read());  // Read second byte

  rByte |= 0x80;  //OS->1

  Wire.beginTransmission(_address);
  Wire.write(CONFIG_REGISTER);  // Point to configuration register
  Wire.write(rByte);     // Write byte to register
  Wire.endTransmission();       // Close communication with TMP102


  delay(30);

  float temperature;

  Wire.beginTransmission(_address); // Connect to TMP102
  Wire.write(TEMPERATURE_REGISTER); // Open specified register
  Wire.endTransmission(); // Close communication with TMP102

  int16_t digitalTemp;

  Wire.requestFrom(_address, 2);  // Read two bytes from TMP102
  Wire.endTransmission();
  registerByte[0] = (Wire.read());  // Read first byte
  registerByte[1] = (Wire.read());  // Read second byte

  {
    // Combine bytes to create a signed int
    digitalTemp = ((registerByte[0]) << 4) | (registerByte[1] >> 4);
    // Temperature data can be + or -, if it should be negative,
    // convert 12 bit to 16 bit and use the 2s compliment.
    
//    digitalTemp=0xff0;
    if (digitalTemp > 0x7FF)
    {
      digitalTemp |= 0xF000;
    }
  }
  // Convert digital reading to analog temperature (1-bit is equal to 0.0625 C)
  temperature = digitalTemp * 0.0625;

//Smallint


  Serial.print("Temperature: ");
  Serial.println(temperature);
  Serial.println();
  delay(2000);
}


