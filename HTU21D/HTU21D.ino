#include <Wire.h>

#define HTDU21D_ADDRESS 0x40
#define TRIGGER_TEMP_MEASURE_NOHOLD  0xF3
#define SHIFTED_DIVISOR 0x988000 //This is the 0x0131 polynomial shifted to farthest left of three bytes

void setup() {
  Serial.begin(9600);
  Serial.println("HTU21D Write");
  Wire.begin();

}

void loop() {
  // put your main code here, to run repeatedly:
  Wire.beginTransmission(HTDU21D_ADDRESS);
  Wire.write(TRIGGER_TEMP_MEASURE_NOHOLD);
  Wire.endTransmission();
  delay(55);


  Wire.requestFrom(HTDU21D_ADDRESS, 3);
  int counter = 0;
  while (Wire.available() < 3)
  {
    counter++;
    delay(1);
    if (counter > 100) break; //Error out
  }
  Serial.print("Delay: ");
  Serial.print(counter);
  Serial.println(" ms");

  byte msb, lsb, checksum;
  msb = Wire.read();
  lsb = Wire.read();
  checksum = Wire.read();

  uint16_t rawValue = ((uint16_t) msb << 8) | (uint16_t) lsb;
  // unsigned int rawTemperature = ((unsigned int) msb << 8) | (unsigned int) lsb;
  if (checkCRCHTU21D(rawValue, checksum) != 0) Serial.println("ERROR_BAD_CRC");
  //return   (ERROR_BAD_CRC); //Error out

  rawValue &= 0xFFFC; // Zero out the status bits

  float tempTemperature = rawValue * (175.72 / 65536.0); //2^16 = 65536
  float realTemperature = tempTemperature - 46.85;

  Serial.print(" Temperature:");
  Serial.print(realTemperature, 2);
  Serial.println("C");

  delay(2000);
}

byte checkCRCHTU21D(uint16_t message_from_sensor, uint8_t check_value_from_sensor)
{
  //Test cases from datasheet:
  //message = 0xDC, checkvalue is 0x79
  //message = 0x683A, checkvalue is 0x7C
  //message = 0x4E85, checkvalue is 0x6B

  uint32_t remainder = (uint32_t)message_from_sensor << 8; //Pad with 8 bits because we have to add in the check value
  remainder |= check_value_from_sensor; //Add on the check value

  uint32_t divsor = (uint32_t)SHIFTED_DIVISOR;

  for (int i = 0 ; i < 16 ; i++) //Operate on only 16 positions of max 24. The remaining 8 are our remainder and should be zero when we're done.
  {
    //Serial.print("remainder: ");
    //    Serial.println(remainder);
    //    Serial.print("divsor:    ");
    //    Serial.println(divsor);
    //    Serial.println(remainder & (uint32_t)1 << (23 - i));
    //    Serial.println();

    if ( remainder & (uint32_t)1 << (23 - i) ) //Check if there is a one in the left position
      remainder ^= divsor;

    divsor >>= 1; //Rotate the divsor max 16 times so that we have 8 bits left of a remainder
  }

  return (byte)remainder;
}
