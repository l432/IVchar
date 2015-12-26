#include <SPI.h>


#define PacketStart 10
#define PacketEnd 255
#define PacketMaxLength 15
#define V7_21Command 1
#define ParameterReceiveCommand 2

byte DrivePins[] = {25, 26, 27, 28, 29, 30};
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
      if (packet[1] = ParameterReceiveCommand) SendParameters();

    }
  }
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

  SendPacket(data,sizeof(data));
//  Serial.write(PacketStart);
//  Serial.write(data, sizeof(data));
//  Serial.write(PacketEnd);
}

void SendParameters() {
  byte data[sizeof(DrivePins) + 3];
  data[0] = sizeof(data);
  data[1] = ParameterReceiveCommand;
  for (byte i = 0; i < sizeof(DrivePins); i++)
  {
    data[i + 2] = DrivePins[i];
  }
  data[sizeof(data) - 1] = 0;
  data[sizeof(data) - 1] = FCS(data, data[0]);

 SendPacket(data,sizeof(data));
//  Serial.write(PacketStart);
//  Serial.write(data, sizeof(data));
//  Serial.write(PacketEnd);
}

void SendPacket(byte Data[], int n){
  Serial.write(PacketStart);
  Serial.write(Data, n);
  Serial.write(PacketEnd);  
}

