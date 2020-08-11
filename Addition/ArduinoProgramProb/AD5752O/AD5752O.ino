#include <SPI.h>


byte _pin;
byte led_pin;
int _speedMaximum;
int _dataOrder;
int _dataMode;
byte _Data[3];

void setup() {
  _pin = 43;
  led_pin = 12;
  pinMode (_pin, OUTPUT);
  digitalWrite(_pin, HIGH);
  pinMode (led_pin, OUTPUT);
  digitalWrite(led_pin, LOW);
   
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
//  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  ThreeByteTransfer(B00010000,B00000000,B00010001);
  //живлення на REF та перший канал
  delay(5);
}

void loop() {

 
  _Data[0]=0x00;
  _Data[1]=0x00;
  _Data[2]=0x00; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //0 на вихід А
  Blink();
  
//  delay(1);
//  ThreeByteTransfer(0x1D,0x00,0x00);
//  delay(1);
  
  delay(3000);

  ThreeByteTransfer(B00001100,B00000000,B00000000);
  delay(1);

  
  _Data[0]=0x00;
  _Data[1]=0x80;
  _Data[2]=0x00; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //1 на вихід А
Blink();
Blink();

   
  delay(3000);


  ThreeByteTransfer(B00001100,B00000000,B00000001);
  delay(1);

//  _Data[0]=0x00;
//  _Data[1]=0x33;
//  _Data[2]=0x33; 
//  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //1 на вихід А  
  
  _Data[0]=0x00;
  _Data[1]=0x80;
  _Data[2]=0x00; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
//  //2,5 на вихід А
Blink();
Blink();
Blink();

  delay(3000);
  ThreeByteTransfer(B00001100,B00000000,B00000010);
  delay(1);

  _Data[0]=0x00;
  _Data[1]=0x80;
  _Data[2]=0x00; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //1 на вихід А  
  
//  _Data[0]=0x00;
//  _Data[1]=0x80;
//  _Data[2]=0x00; 
//  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
//  //2,5 на вихід А
Blink();
Blink();
Blink();
Blink();

  delay(3000);
  ThreeByteTransfer(B00001100,B00000000,B00000011);
  delay(1);

  _Data[0]=0x00;
  _Data[1]=0x80;
  _Data[2]=0x00; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //1 на вихід А  
  
//  _Data[0]=0x00;
//  _Data[1]=0x80;
//  _Data[2]=0x00; 
//  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
//  //2,5 на вихід А
Blink();
Blink();
Blink();
Blink();
Blink();

  delay(3000);
  ThreeByteTransfer(B00001100,B00000000,B00000100);
  delay(1);

  _Data[0]=0x00;
  _Data[1]=0x80;
  _Data[2]=0x00; 
  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
  //1 на вихід А  
  
//  _Data[0]=0x00;
//  _Data[1]=0x80;
//  _Data[2]=0x00; 
//  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
//  //2,5 на вихід А
Blink();
Blink();
Blink();
Blink();
Blink();
Blink();

//  delay(5000);
//  _Data[0]=0x00;
//  _Data[1]=0xCC;
//  _Data[2]=0xCC; 
//  ThreeByteTransfer(_Data[0],_Data[1],_Data[2]);
//  //4 на вихід А
//  delay(1);
//  ThreeByteTransfer(0x1D,0x00,0x00);
//  delay(1);
  
  delay(3000);

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

void Blink(){
  digitalWrite(led_pin, HIGH);
  delay(200);
  digitalWrite(led_pin, LOW);
delay(200);
}

