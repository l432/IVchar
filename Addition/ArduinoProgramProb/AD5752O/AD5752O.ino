#include <SPI.h>


byte _pin;
int _speedMaximum;
int _dataOrder;
int _dataMode;
byte _Data[3];

void setup() {
  _pin = 43;
  pinMode (_pin, OUTPUT);
  digitalWrite(_pin, HIGH); 
  delay(10);
  _speedMaximum = SPI_CLOCK_DIV4;
  _dataOrder = MSBFIRST;
  _dataMode = SPI_MODE0;
   SPI.begin();
  _Data[0]=0x19;
  _Data[1]=0x00;
  _Data[2]=0x0D; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //початкові установки
  delay(10);
  _Data[0]=0x0C;
  _Data[1]=0x00;
  _Data[2]=0x00; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //+5 V вихідний діапазон обох виходів
  delay(5);
  _Data[0]=0x10;
  _Data[1]=0x00;
  _Data[2]=0x11; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //живлення на REF та перший канал
  delay(5);
}

void loop() {
  _Data[0]=0x00;
  _Data[1]=0x00;
  _Data[2]=0x00; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //0 на вихід А
  delay(1);
  ThreeByteTransfer(0x1D,0x00,0x00);
  delay(1);
  
  delay(3000);
  
  _Data[0]=0x00;
  _Data[1]=0x33;
  _Data[2]=0x33; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //1 на вихід А
  delay(1);
  ThreeByteTransfer(0x1D,0x00,0x00);
  delay(1);
  
  delay(5000);
  _Data[0]=0x00;
  _Data[1]=0x80;
  _Data[2]=0x00; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //2,5 на вихід А
  delay(5000);
  _Data[0]=0x00;
  _Data[1]=0xCC;
  _Data[2]=0xCC; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //4 на вихід А
  delay(5000);

}

void ThreeByteTransfer(byte Data1, byte Data2, byte Data3) {
  SPI.beginTransaction(SPISettings(_speedMaximum, _dataOrder, _dataMode));
  digitalWrite(_pin, LOW);
  SPI.transfer(Data1);
  SPI.transfer(Data2);
  SPI.transfer(Data3);
  digitalWrite(_pin, HIGH);
  SPI.endTransaction();
}
