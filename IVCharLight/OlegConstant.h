#ifndef OlegConstant_H
#define OlegConstant_H

const byte V7_21Command = 1;
const byte ParameterReceiveCommand = 2;
const byte DACCommand = 3;
const byte DACR2RCommand = 4;
const byte DAC_Pos = 0x0F;
const byte DAC_Neg = 0xFF;
const byte DS18B20Command = 0x5;
const byte D30_06Command = 0x6;
const byte PinChangeCommand = 0x7;
const byte HTU21DCommand = 0x8;
const byte TMP102Command = 0x9;
const byte PinToHigh = 0xF0;
const byte PinToLow = 0x0F;
const byte MCP3424Command = 0x0A;
const byte ADS1115Command = 0x0B;
const byte AD9833Command = 0x0C;
const byte MLX90615Command = 0x0D;
const byte INA226Command = 0x0E;
const byte STS21Command = 0x10;
const byte ADT74x0Command = 0x11;
const byte MCP9808Command = 0x12;
const byte AD5752Command = 0x13;
//const byte ArduinoIVCommand = 0x14;

//For MEGA
const byte DrivePins[] = {25, 26, 27, 28, 29, 30, 31, 32, 34, 35, 41, 42, 43, 44, 45};
const byte SignPins[] = {33, 40};
const byte OneWarePins[] = {36, 37};
const byte InputPins[] = {47, 48, 49};
const byte SCL_Pin = 21;

// byte DS18B20Pin = 36;
const byte LEDPin = 12;


//For UNO
//byte DrivePins[] = {2, 3, 4, 5, 6, 7};
//byte SignPins[] = {8, 9};
//byte DS18B20Pin = 10;

#endif
