#include <SPI.h>

#define SS 43

void setup() {
      pinMode(SS, OUTPUT);
    digitalWrite(SS, HIGH);
  SPI.begin();
  WriteAD9833(0x2100); //0010 0001 0000 0000 - Reset + DB28
//  WriteAD9833(0x50C7); //0101 0000 1100 0111 - Freq0 LSB (4295)
//  WriteAD9833(0x4000); //0100 0000 0000 0000 - Freq0 MSB (0)
  WriteAD9833(0x070A); //0101 0000 1100 0111 - Freq0 LSB (4295)
  WriteAD9833(0x68F5); //0100 0000 0000 0000 - Freq0 MSB (0)
  WriteAD9833(0xC000); //1100 0000 0000 0000 - Phase0 (0)
  WriteAD9833(0x2000); //0010 0000 0000 0000 - Exit Reset
}

void WriteAD9833(uint16_t Data){
  SPI.beginTransaction(SPISettings(SPI_CLOCK_DIV2, MSBFIRST, SPI_MODE2));
  digitalWrite(SS, LOW);
  delayMicroseconds(1);
  SPI.transfer16(Data);
  digitalWrite(SS, HIGH);
  SPI.endTransaction();
}

void loop() {
  WriteAD9833(0x2000); //0010 0000 0000 0000 - Синусоидальный сигнал
  delay(5000);
  WriteAD9833(0x2002); //0010 0000 0000 0010 - MODE=1 - Треугольный
  delay(5000);
  WriteAD9833(0x2020); //0010 0000 0010 0000 - OPBITEN=1 - Прямоугольный (MSB/2)
  delay(5000);
  WriteAD9833(0x2028); //0010 0000 0010 1000 - OPBITEN=1, DIV2=1 - Прямоугольный (MSB)
  delay(5000);
 }
