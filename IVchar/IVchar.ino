#include <SPI.h>


#define PacketStart 10
#define PacketEnd 255
#define PacketMaxLength 15
#define V7_21Command 1

byte DrivePins[] = {25, 26, 27};
//enum { REG_LATCH = 5 };

byte incomingByte = 0;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.setTimeout(1000);
  SPI.begin();
  /* Включаем защёлку */
  for (byte i = 0; i < sizeof(DrivePins); i++)
  {
    pinMode(DrivePins[i], OUTPUT);
    digitalWrite(DrivePins[i], HIGH);
  }

  //  pinMode(REG_LATCH, OUTPUT);
  //  digitalWrite(REG_LATCH, HIGH);
}

void loop() {
start:
  if (Serial.available() > 0) {
    // считываем входящий байт:
    incomingByte = Serial.read();
    if (incomingByte = PacketStart)
    {
      byte packet[PacketMaxLength];
      for (byte i = 0; i < PacketMaxLength; i++)
        packet[i] = 0;
      byte number = Serial.readBytesUntil(PacketEnd, packet, PacketMaxLength);

      if (number != packet[0] + 1) goto start;
      packet[packet[0]] = 0;


      //      Serial.write(FCS(packet, sizeof(packet)));

      if (FCS(packet, sizeof(packet)) != 0) goto start;
      //       Serial.write(PacketStart);
      //       Serial.write(packet, packet[0]);
      //       Serial.write(PacketEnd);

      if (packet[1] = V7_21Command) V721(packet[2]);

    }
  }
}

void V721(byte PinNumber) {
  digitalWrite(PinNumber, LOW);
  digitalWrite(PinNumber, HIGH);
  byte data[8];
  data[0] = sizeof(data);
  data[1] = V7_21Command;
  data[2] = PinNumber;
  for (byte i = 0; i < 4; i++)
  {
    data[i + 3] = SPI.transfer(0);
  }
  data[sizeof(data) - 1] = 0;
  data[sizeof(data) - 1] = FCS(data, data[0]);

  Serial.write(PacketStart);
  Serial.write(data, sizeof(data));
  Serial.write(PacketEnd);
}

byte FCS (byte Data[], int n)
{
  int  FCS = 0;
  for (byte i = 0; i < n; i++)
  {
    FCS += Data[i];
    while (FCS > 255)
    {
      FCS = (FCS & 0xFF) + ((FCS >> 8) & 0xFF);
    }
  };
  FCS = ~FCS;
  return byte(FCS & 0xFF);
}

//
//  digitalWrite(REG_LATCH, LOW);
//  digitalWrite(REG_LATCH, HIGH);
//  uint8_t states = SPI.transfer(0);
//  uint8_t states1 = SPI.transfer(0);


// put your main code here, to run repeatedly:
//  for (int i = 1; i < 25; i++)
//  {
//  Serial.println(i);

//    Serial.write(states);
//    delay(1000);
//    Serial.write(states1);
//    delay(1000);
//    Serial.write(15);
//    delay(1000);

//  digitalWrite(REG_LATCH+1, LOW);
//  digitalWrite(REG_LATCH+1, HIGH);
//  states = SPI.transfer(0);
//   Serial.write(states);
//   delay(1000);
//
//   Serial.write(25);
//   delay(1000);

//  }

