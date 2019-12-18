#include <SPI.h>

void setup() {
  Serial.begin(115200);
  Serial.setTimeout(50);
  SPI.begin();
  /* Включаем защёлку */
  pinMode(2, OUTPUT);
  digitalWrite(2, HIGH);
  pinMode(3, OUTPUT);
  digitalWrite(3, HIGH);

}

void loop() {
  int value = 0;
  int mode = 2;
  if (Serial.available() > 0) {
//    mode = Serial.parseInt();
    value = Serial.parseInt();
    byte H_Value = 0x3F & (value >> 8);
    byte L_Value = 0xFF & value;
    Serial.println(H_Value,BIN);
    Serial.println(L_Value,BIN);
    Serial.println(mode);
//    if (mode = 1) {
      digitalWrite(mode, LOW);
      SPI.transfer(H_Value);
      SPI.transfer(L_Value);
      digitalWrite(mode, HIGH);
//   }
//    if (mode = 2) {
//      digitalWrite(3, LOW);
//      SPI.transfer(L_Value);
//      SPI.transfer(H_Value);
//      digitalWrite(3, HIGH);
//    }
   Serial.println("-----------"); 
  }

}
