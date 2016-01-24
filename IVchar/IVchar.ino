#include <SPI.h>


#define PacketStart 10
#define PacketEnd 255
#define PacketMaxLength 15
#define V7_21Command 1
#define ParameterReceiveCommand 2
#define DACCommand 3
#define DAC_OR 0x01
#define DAC_Mode 0x02
#define DAC_Power 3
#define DAC_Reset 4
#define DAC_Output 5
#define DAC_OutputSYN 6
#define DAC_Overcurrent 7

byte DrivePins[] = {25, 26, 27, 28, 29, 30, 31, 32, 33, 34};
//enum { REG_LATCH = 5 };

byte incomingByte = 0;
byte DACPinControl, DACPinGate;
byte DACDataToSend[3];
byte DACDataAnswer[3];

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

      if (packet[1] == V7_21Command) V721(packet[2], packet[3]);
      if (packet[1] == ParameterReceiveCommand) SendParameters();
      if (packet[1] == DACCommand) {
        DACPinControl = packet[3];
        DACPinGate = packet[4];
        if (packet[2] != DAC_Reset) {
          DACDataToSend[0] = packet[5];
          DACDataToSend[1] = packet[6];
          DACDataToSend[2] = packet[7];
        }

        switch (packet[2]) {
          case DAC_OR:
            //            DACOutputRange(packet[3], packet[4], packet[5], packet[6], packet[7]);
            DACOutputRange();
            break;
          case DAC_Mode:
//            DACSetMode(packet[3], packet[4], packet[5], packet[6], packet[7]);
            DACSetMode();
            break;
          case DAC_Power:
//            DACPower(packet[3], packet[4], packet[5], packet[6], packet[7]);
            DACPower();
            break;
          case DAC_Reset:
//            DACReset(packet[3], packet[4]);
            DACReset();
            break;
          case DAC_Output:
//            DACOutput(packet[3], packet[4], packet[5], packet[6], packet[7], packet[8]);
            DACOutput(packet[8]);
            break;
          case DAC_OutputSYN:
//            DACOutputSyn(packet[3], packet[4], packet[5], packet[6], packet[7], packet[8], packet[9]);
            DACOutputSyn(packet[5], packet[6], packet[7], packet[8], packet[9]);
            break;

            //          default:
            // код для выполнения
        }
      }

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

void GateOpen(byte PinGate) {
  digitalWrite(PinGate, LOW);
  delay(1);
}

void GateClose(byte PinGate) {
  digitalWrite(PinGate, HIGH);
  delay(1);
}

void SendPacket(byte Data[], int n) {
  Serial.write(PacketStart);
  Serial.write(Data, n);
  Serial.write(PacketEnd);
}

void CreateAndSendPacket(byte DDATA[], int n) {
  byte data[n + 2];
  data[0] = sizeof(data);
  for (byte i = 0; i < n; i++)
  {
    data[i + 1] = DDATA[i];
  }
  data[sizeof(data) - 1] = 0;
  data[sizeof(data) - 1] = FCS(data, data[0]);
  SendPacket(data, sizeof(data));
}

void V721(byte PinNumber, byte PinGateNumber) {
  GateOpen(PinGateNumber);
  digitalWrite(PinNumber, LOW);
  digitalWrite(PinNumber, HIGH);
  //  byte data[8];
  //  data[0] = sizeof(data);
  //  data[1] = V7_21Command;
  //  data[2] = PinNumber;
  //  for (byte i = 0; i < 4; i++)
  //  {
  //    data[i + 3] = SPI.transfer(0);
  //  }
  //  data[sizeof(data) - 1] = 0;
  //  data[sizeof(data) - 1] = FCS(data, data[0]);
  //  SendPacket(data, sizeof(data));

  byte data[6];
  data[0] = V7_21Command;
  data[1] = PinNumber;
  for (byte i = 0; i < 4; i++)
  {
    data[i + 2] = SPI.transfer(0);
  }
  CreateAndSendPacket(data, sizeof(data));

  GateClose(PinGateNumber);
}

void SendParameters() {
  //  byte data[sizeof(DrivePins) + 3];
  //  data[0] = sizeof(data);
  //  data[1] = ParameterReceiveCommand;
  //  for (byte i = 0; i < sizeof(DrivePins); i++)
  //  {
  //    data[i + 2] = DrivePins[i];
  //  }
  //  data[sizeof(data) - 1] = 0;
  //  data[sizeof(data) - 1] = FCS(data, data[0]);
  //  SendPacket(data, sizeof(data));

  byte data[sizeof(DrivePins) + 1];
  data[0] = ParameterReceiveCommand;
  for (byte i = 0; i < sizeof(DrivePins); i++)
  {
    data[i + 1] = DrivePins[i];
  }
  CreateAndSendPacket(data, sizeof(data));
}



void PinHL(byte Pin) {
  digitalWrite(Pin, HIGH);
  delay(1);
  digitalWrite(Pin, LOW);
}

void PinLH(byte Pin) {
  digitalWrite(Pin, LOW);
  delay(1);
  digitalWrite(Pin, HIGH);
}

void DACDataTransferBytes(byte Data1, byte Data2, byte Data3){
  SPI.transfer(Data1);
  SPI.transfer(Data2);
  SPI.transfer(Data3);
  PinHL(DACPinControl);
}

void DACDataTransfer() {
  DACDataTransferBytes(DACDataToSend[0],DACDataToSend[1],DACDataToSend[2]);
//  SPI.transfer(DACDataToSend[0]);
//  SPI.transfer(DACDataToSend[1]);
//  SPI.transfer(DACDataToSend[2]);
//  PinHL(DACPinControl);
}

void DACDataTransferSimple(byte Data) {
  DACDataTransferBytes(Data,0,0);
//  SPI.transfer(Data);
//  SPI.transfer(0);
//  SPI.transfer(0);
//  PinHL(DACPinControl);
}

void DACDataReceive(){
 DACDataAnswer[0] = SPI.transfer(0x18);
 DACDataAnswer[1] = SPI.transfer(0);
 DACDataAnswer[2] = SPI.transfer(0); 
}


//void  DACOutputRange(byte PinControl, byte PinGate, byte Data1, byte Data2, byte Data3) {
void  DACOutputRange() {
  GateOpen(DACPinGate);
  digitalWrite(DACPinControl, LOW);

  DACDataTransfer();
  //  SPI.transfer(Data1);
  //  SPI.transfer(Data2);
  //  SPI.transfer(Data3);
  //  PinHL(PinControl);

  byte Inquiry = DACDataToSend[0];
  bitSet(Inquiry, 7);

  DACDataTransferSimple(Inquiry);
  //  SPI.transfer(Inquiry);
  //  SPI.transfer(0);
  //  SPI.transfer(0);
  //  PinHL(PinControl);

  DACDataReceive();
//  byte AnswerRange, AnswerChannel;
//  AnswerChannel = SPI.transfer(0x18);
//  SPI.transfer(0);
//  AnswerRange = SPI.transfer(0);
  digitalWrite(DACPinControl, HIGH);
  if ((DACDataAnswer[2] & 0x07) != (DACDataToSend[2] & 0x07)) {
//    byte data[6];
//    data[0] = sizeof(data);
//    data[1] = DACCommand;
//    data[2] = DAC_OR;
//    data[3] = (AnswerChannel & 0x07);
//    data[4] = (AnswerRange & 0x07);
//    data[5] = 0;
//    data[5] = FCS(data, data[0]);
//    SendPacket(data, sizeof(data));

    byte data[4];
    data[0] = DACCommand;
    data[1] = DAC_OR;
    data[2] = (DACDataAnswer[0] & 0x07);
    data[3] = (DACDataAnswer[2] & 0x07);
    CreateAndSendPacket(data, sizeof(data));
  }
  GateClose(DACPinGate);
}

//void DACSetMode(byte PinControl, byte PinGate, byte Data1, byte Data2, byte Data3) {
void DACSetMode() {
  GateOpen(DACPinGate);
  digitalWrite(DACPinControl, LOW);

  DACDataTransfer();
//  SPI.transfer(Data1);
//  SPI.transfer(Data2);
//  SPI.transfer(Data3);
//  PinHL(PinControl);

  byte Inquiry = DACDataToSend[0];
  bitSet(Inquiry, 7);
  DACDataTransferSimple(Inquiry);
//  SPI.transfer(Inquiry);
//  SPI.transfer(0);
//  SPI.transfer(0);
//  PinHL(PinControl);

  DACDataReceive();
//  byte Mode;
//  SPI.transfer(0x18);
//  SPI.transfer(0);
//  Mode = SPI.transfer(0);
  digitalWrite(DACPinControl, HIGH);
  if ((DACDataAnswer[2] & 0x0F) != (DACDataToSend[2] & 0x0F)) {
//    byte data[4];
//    data[0] = sizeof(data);
//    data[1] = DACCommand;
//    data[2] = DAC_Mode;
//    data[3] = 0;
//    data[3] = FCS(data, data[0]);
//    SendPacket(data, sizeof(data));

    byte data[2];
    data[0] = DACCommand;
    data[1] = DAC_Mode;
    CreateAndSendPacket(data, sizeof(data));
  }
  GateClose(DACPinGate);
}

//void DACPower(byte PinControl, byte PinGate, byte Data1, byte Data2, byte Data3) {
void DACPower() {
  GateOpen(DACPinGate);
  digitalWrite(DACPinControl, LOW);

  DACDataTransfer();
//  SPI.transfer(Data1);
//  SPI.transfer(Data2);
//  SPI.transfer(Data3);
//  PinHL(PinControl);

  byte Inquiry = DACDataToSend[0];
  bitSet(Inquiry, 7);
  DACDataTransferSimple(Inquiry);
//  byte Inquiry = Data1;
//  bitSet(Inquiry, 7);
//  SPI.transfer(Inquiry);
//  SPI.transfer(0);
//  SPI.transfer(0);
//  PinHL(PinControl);

  DACDataReceive();
//  byte Power;
//  SPI.transfer(0x18);
//  SPI.transfer(0);
//  Power = SPI.transfer(0);
  digitalWrite(DACPinControl, HIGH);
  if (((DACDataAnswer[2] & 0x10) == 0) ||
      ((DACDataAnswer[2] & 0x01) != (DACDataToSend[2] & 0x01)) ||
      ((DACDataAnswer[2] & 0x04) != (DACDataToSend[2] & 0x04))) {
//    byte data[5];
//    data[0] = sizeof(data);
//    data[1] = DACCommand;
//    data[2] = DAC_Mode;
//    data[3] = Power;
//    data[4] = 0;
//    data[4] = FCS(data, data[0]);
//    SendPacket(data, sizeof(data));

    byte data[3];
    data[0] = DACCommand;
    data[1] = DAC_Mode;
    data[2] = DACDataAnswer[2];
    CreateAndSendPacket(data, sizeof(data));
  }
  GateClose(DACPinGate);
}

//void DACReset(byte PinCLR, byte PinGate) {
void DACReset() {
  GateOpen(DACPinGate);
  PinLH(DACPinControl);
  //  digitalWrite(PinCLR, LOW);
  //  delay(1);
  //  digitalWrite(PinCLR, HIGH);
}

//void  DACOutput(byte PinControl, byte PinGate, byte PinLDAC, byte Data1, byte Data2, byte Data3) {
void  DACOutput(byte PinLDAC) {
  GateOpen(DACPinGate);
  digitalWrite(DACPinControl, LOW);

  DACDataTransfer();
//  SPI.transfer(Data1);
//  SPI.transfer(Data2);
//  SPI.transfer(Data3);

//  digitalWrite(PinControl, HIGH);
  PinLH(PinLDAC);
//  digitalWrite(PinControl, LOW);

  byte Inquiry = DACDataToSend[0];
  bitSet(Inquiry, 7);
  DACDataTransferSimple(Inquiry);
//  DACDataTransferSimple(Inquiry);
//  byte Inquiry = Data1;
//  bitSet(Inquiry, 7);
//  SPI.transfer(Inquiry);
//  SPI.transfer(0);
//  SPI.transfer(0);
//  PinHL(PinControl);

  DACDataReceive();  
//  byte AnswerData2, AnswerData3, AnswerChannel;
//  AnswerChannel = SPI.transfer(0x18);
//  AnswerData2 = SPI.transfer(0);
//  AnswerData3 = SPI.transfer(0);

  if ((DACDataAnswer[0] != DACDataToSend[0]) ||
      (DACDataAnswer[1] != DACDataToSend[1]) ||
      (DACDataAnswer[2] != DACDataToSend[2])) {
//    byte data[4];
//    data[0] = sizeof(data);
//    data[1] = DACCommand;
//    data[2] = DAC_Output;
//    data[3] = 0;
//    data[3] = FCS(data, data[0]);
//    SendPacket(data, sizeof(data));

    byte data[2];
    data[0] = DACCommand;
    data[1] = DAC_Output;
    CreateAndSendPacket(data, sizeof(data));
  }
  
  PinHL(DACPinControl);
  DACDataTransferSimple(0x90);
//  SPI.transfer(0x90);
//  SPI.transfer(0);
//  SPI.transfer(0);

  PinHL(DACPinControl);
 
  DACDataReceive();  
//  AnswerChannel = SPI.transfer(0x18);
//  AnswerData2 = SPI.transfer(0);
//  AnswerData3 = SPI.transfer(0);
  digitalWrite(DACPinControl, HIGH);

  if ((bitRead(DACDataAnswer[2], 7) == 1) ||
      (bitRead(DACDataAnswer[1], 1) == 1) ) {
//    byte data[6];
//    data[0] = sizeof(data);
//    data[1] = DACCommand;
//    data[2] = DAC_Overcurrent;
//    data[3] = AnswerData2;
//    data[4] = AnswerData3;
//    data[5] = 0;
//    data[5] = FCS(data, data[0]);
//    SendPacket(data, sizeof(data));

    byte data[4];
    data[0] = DACCommand;
    data[1] = DAC_Overcurrent;
    data[2] = DACDataAnswer[1];
    data[3] = DACDataAnswer[2];
    CreateAndSendPacket(data, sizeof(data));
  }
  GateClose(DACPinGate);
}

//void  DACOutputSyn(byte PinControl, byte PinGate, byte PinLDAC, byte DataAhi, byte DataAlo, byte DataBhi, byte DataBlo) {
void  DACOutputSyn(byte PinLDAC, byte DataAhi, byte DataAlo, byte DataBhi, byte DataBlo) {
  GateOpen(DACPinGate);
  digitalWrite(DACPinControl, LOW);

  DACDataTransferBytes(0x00,DataAhi,DataAlo);
//  SPI.transfer(0x00);
//  SPI.transfer(DataAhi);
//  SPI.transfer(DataAlo);
//  PinHL(PinControl);

  DACDataTransferBytes(0x02,DataBhi,DataBlo);
//  SPI.transfer(0x02);
//  SPI.transfer(DataBhi);
//  SPI.transfer(DataBlo);

//  digitalWrite(PinControl, HIGH);
  PinLH(PinLDAC);
//  digitalWrite(PinControl, LOW);

  DACDataTransferSimple(0x80);
//  SPI.transfer(0x80);
//  SPI.transfer(0);
//  SPI.transfer(0);
//  PinHL(PinControl);

  DACDataReceive();
//  byte AnswerData2, AnswerData3, AnswerData1;
//  AnswerData1 = SPI.transfer(0x18);
//  AnswerData2 = SPI.transfer(0);
//  AnswerData3 = SPI.transfer(0);

  if ((DACDataAnswer[1] != DataAhi) ||
      (DACDataAnswer[2] != DataAlo)) {
//    byte data[4];
//    data[0] = sizeof(data);
//    data[1] = DACCommand;
//    data[2] = DAC_Output;
//    data[3] = 0;
//    data[3] = FCS(data, data[0]);
//    SendPacket(data, sizeof(data));

    byte data[2];
    data[0] = DACCommand;
    data[1] = DAC_Output;
    CreateAndSendPacket(data, sizeof(data));
  }

  PinHL(DACPinControl);
  DACDataTransferSimple(0x82);
//  SPI.transfer(0x82);
//  SPI.transfer(0);
//  SPI.transfer(0);
//  PinHL(PinControl);

  DACDataReceive();
//  AnswerData1 = SPI.transfer(0x18);
//  AnswerData2 = SPI.transfer(0);
//  AnswerData3 = SPI.transfer(0);

  if ((DACDataAnswer[1] != DataBhi) ||
      (DACDataAnswer[2] != DataBlo)) {
//    byte data[4];
//    data[0] = sizeof(data);
//    data[1] = DACCommand;
//    data[2] = DAC_Output;
//    data[3] = 0;
//    data[3] = FCS(data, data[0]);
//    SendPacket(data, sizeof(data));

    byte data[2];
    data[0] = DACCommand;
    data[1] = DAC_Output;
    CreateAndSendPacket(data, sizeof(data));
  }

  PinHL(DACPinControl);
  DACDataTransferSimple(0x90);
//  SPI.transfer(0x90);
//  SPI.transfer(0);
//  SPI.transfer(0);

  PinHL(DACPinControl);
 
  DACDataReceive();  
//  AnswerChannel = SPI.transfer(0x18);
//  AnswerData2 = SPI.transfer(0);
//  AnswerData3 = SPI.transfer(0);
  digitalWrite(DACPinControl, HIGH);

  if ((bitRead(DACDataAnswer[2], 7) == 1) ||
      (bitRead(DACDataAnswer[1], 1) == 1) ) {
//    byte data[6];
//    data[0] = sizeof(data);
//    data[1] = DACCommand;
//    data[2] = DAC_Overcurrent;
//    data[3] = AnswerData2;
//    data[4] = AnswerData3;
//    data[5] = 0;
//    data[5] = FCS(data, data[0]);
//    SendPacket(data, sizeof(data));

    byte data[4];
    data[0] = DACCommand;
    data[1] = DAC_Overcurrent;
    data[2] = DACDataAnswer[1];
    data[3] = DACDataAnswer[2];
    CreateAndSendPacket(data, sizeof(data));
  } 
  GateClose(DACPinGate);
}





