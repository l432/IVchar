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

byte DrivePins[] = {25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35};

byte incomingByte = 0;
byte PinControl, PinGate, DeviceId, ActionId;
byte DACDataToSend[3];
byte DACDataAnswer[3];

void setup() {
  Serial.begin(115200);
  Serial.setTimeout(1000);
  SPI.begin();
  /* Включаем защёлку */
  for (byte i = 0; i < sizeof(DrivePins); i++)
  {
    pinMode(DrivePins[i], OUTPUT);
    digitalWrite(DrivePins[i], HIGH);
  }
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

      if (FCS(packet, sizeof(packet)) != 0) goto start;

      DeviceId = packet[1];
      ActionId = packet[2];

      //      if (packet[1] == V7_21Command) {
      if (DeviceId == V7_21Command) {
        PinControl = packet[2];
        PinGate = packet[3];
        V721();
      }
      //      if (packet[1] == ParameterReceiveCommand) SendParameters();
      if (DeviceId == ParameterReceiveCommand) SendParameters();
      //      if (packet[1] == DACCommand) {
      if (DeviceId == DACCommand) {
        PinControl = packet[3];
        PinGate = packet[4];
        if (ActionId != DAC_Reset) {
          DACDataToSend[0] = packet[5];
          DACDataToSend[1] = packet[6];
          DACDataToSend[2] = packet[7];
        }

        switch (ActionId) {
          case DAC_OR:
            DACOutputRange();
            break;
          case DAC_Mode:
            DACSetMode();
            break;
          case DAC_Power:
            DACPower();
            break;
          case DAC_Reset:
            DACReset();
            break;
          case DAC_Output:
            DACOutput(packet[8]);
            break;
          case DAC_OutputSYN:
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

void GateOpen() {
  digitalWrite(PinGate, LOW);
  delay(1);
}

void GateClose() {
  digitalWrite(PinGate, HIGH);
  delay(1);
}

void SendPacket(byte Data[], int n) {
  Serial.write(PacketStart);
  Serial.write(Data, n);
  Serial.write(PacketEnd);
}

void CreateAndSendPacket(byte DDATA[], int n) {
  byte data[n + 4];
  data[0] = sizeof(data);
  data[1] = DeviceId;
  data[2] = ActionId;
  for (byte i = 0; i < n; i++)
  {
    data[i + 3] = DDATA[i];
  }
  data[sizeof(data) - 1] = 0;
  data[sizeof(data) - 1] = FCS(data, data[0]);
  SendPacket(data, sizeof(data));
}

void V721() {
  GateOpen();
  //  delay(5000);
  digitalWrite(PinControl, LOW);
  digitalWrite(PinControl, HIGH);
  byte data[4];
  //  data[0] = V7_21Command;
  //  data[1] = PinControl;
  for (byte i = 0; i < 4; i++)
  {
    data[i] = SPI.transfer(0);
  }
  CreateAndSendPacket(data, sizeof(data));
  GateClose();
}

void SendParameters() {
  //  byte data[sizeof(DrivePins) + 1];
  //  data[0] = ParameterReceiveCommand;
  //  for (byte i = 0; i < sizeof(DrivePins); i++)
  //  {
  //    data[i + 1] = DrivePins[i];
  //  }
  //  CreateAndSendPacket(data, sizeof(data));
  CreateAndSendPacket(DrivePins, sizeof(DrivePins));
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

void DACDataTransferBytes(byte Data1, byte Data2, byte Data3) {
  SPI.transfer(Data1);
  SPI.transfer(Data2);
  SPI.transfer(Data3);
  PinHL(PinControl);
}

void DACDataTransfer() {
  DACDataTransferBytes(DACDataToSend[0], DACDataToSend[1], DACDataToSend[2]);
}

void DACDataTransferSimple(byte Data) {
  DACDataTransferBytes(Data, 0, 0);
}

void DACDataReceive() {
  DACDataAnswer[0] = SPI.transfer(0x18);
  DACDataAnswer[1] = SPI.transfer(0);
  DACDataAnswer[2] = SPI.transfer(0);
}


void DACBeginTransfer() {
  GateOpen();
  digitalWrite(PinControl, LOW);
  DACDataTransfer();
}

void DACBeginReceive() {
  byte Inquiry = DACDataToSend[0];
  bitSet(Inquiry, 7);
  DACDataTransferSimple(Inquiry);
  DACDataReceive();
}

void DACBegin() {
  DACBeginTransfer();
  DACBeginReceive();
  digitalWrite(PinControl, HIGH);
}

void  DACOutputRange() {
  //  GateOpen();
  //  digitalWrite(PinControl, LOW);
  //  DACDataTransfer();
  //  byte Inquiry = DACDataToSend[0];
  //  bitSet(Inquiry, 7);
  //  DACDataTransferSimple(Inquiry);
  //  DACDataReceive();
  //  digitalWrite(PinControl, HIGH);
  DACBegin();

  if ((DACDataAnswer[2] & 0x07) != (DACDataToSend[2] & 0x07)) {
    byte data[2];
    //    data[0] = DACCommand;
    //    data[1] = DAC_OR;
    data[0] = (DACDataAnswer[0] & 0x07);
    data[1] = (DACDataAnswer[2] & 0x07);
    CreateAndSendPacket(data, sizeof(data));
  }
  GateClose();
}

void DACSetMode() {
  //  GateOpen();
  //  digitalWrite(PinControl, LOW);
  //  DACDataTransfer();
  //  byte Inquiry = DACDataToSend[0];
  //  bitSet(Inquiry, 7);
  //  DACDataTransferSimple(Inquiry);
  //  DACDataReceive();
  //  digitalWrite(PinControl, HIGH);
  DACBegin();

  if ((DACDataAnswer[2] & 0x0F) != (DACDataToSend[2] & 0x0F)) {
    //    byte data[2];
    //    data[0] = DACCommand;
    //    data[1] = DAC_Mode;
    CreateAndSendPacket(DrivePins, 0);
  }
  GateClose();
}

void DACPower() {
  //  GateOpen();
  //  digitalWrite(PinControl, LOW);
  //  DACDataTransfer();
  //  byte Inquiry = DACDataToSend[0];
  //  bitSet(Inquiry, 7);
  //  DACDataTransferSimple(Inquiry);
  //  DACDataReceive();
  //  digitalWrite(PinControl, HIGH);
  DACBegin();

  if (((DACDataAnswer[2] & 0x10) == 0) ||
      ((DACDataAnswer[2] & 0x01) != (DACDataToSend[2] & 0x01)) ||
      ((DACDataAnswer[2] & 0x04) != (DACDataToSend[2] & 0x04))) {
    byte data[1];
    //    data[0] = DACCommand;
    //    data[1] = DAC_Power;
    data[0] = DACDataAnswer[2];
    CreateAndSendPacket(data, sizeof(data));
  }
  GateClose();
}

void DACReset() {
  GateOpen();
  PinLH(PinControl);
  GateClose();
}

void DACOvercurrent() {
  PinHL(PinControl);
  DACDataTransferSimple(0x90);
  DACDataReceive();
  digitalWrite(PinControl, HIGH);

  if ((bitRead(DACDataAnswer[2], 7) == 1) ||
      (bitRead(DACDataAnswer[1], 1) == 1) ) {
    byte data[2];
    //    data[0] = DACCommand;
    //    data[1] = DAC_Overcurrent;
    ActionId = DAC_Overcurrent;
    data[0] = DACDataAnswer[1];
    data[1] = DACDataAnswer[2];
    CreateAndSendPacket(data, sizeof(data));
  }
}

void  DACOutput(byte PinLDAC) {
  //  GateOpen();
  //  digitalWrite(PinControl, LOW);
  //  DACDataTransfer();
  DACBeginTransfer();

  PinLH(PinLDAC);

  DACBeginReceive();
  //  byte Inquiry = DACDataToSend[0];
  //  bitSet(Inquiry, 7);
  //  DACDataTransferSimple(Inquiry);
  //  DACDataReceive();

  if ((DACDataAnswer[0] != DACDataToSend[0]) ||
      (DACDataAnswer[1] != DACDataToSend[1]) ||
      (DACDataAnswer[2] != DACDataToSend[2])) {
    //    byte data[2];
    //    data[0] = DACCommand;
    //    data[1] = DAC_Output;
    CreateAndSendPacket(DrivePins, 0);
  }

//  PinHL(PinControl);
//  DACDataTransferSimple(0x90);
//  DACDataReceive();
//  digitalWrite(PinControl, HIGH);
//
//  if ((bitRead(DACDataAnswer[2], 7) == 1) ||
//      (bitRead(DACDataAnswer[1], 1) == 1) ) {
//    byte data[2];
//    //    data[0] = DACCommand;
//    //    data[1] = DAC_Overcurrent;
//    ActionId = DAC_Overcurrent;
//    data[0] = DACDataAnswer[1];
//    data[1] = DACDataAnswer[2];
//    CreateAndSendPacket(data, sizeof(data));
//  }
  DACOvercurrent();
  GateClose();
}

void  DACOutputSyn(byte PinLDAC, byte DataAhi, byte DataAlo, byte DataBhi, byte DataBlo) {
  GateOpen();
  digitalWrite(PinControl, LOW);

  DACDataTransferBytes(0x00, DataAhi, DataAlo);
  DACDataTransferBytes(0x02, DataBhi, DataBlo);

  PinLH(PinLDAC);

  PinHL(PinControl);
  DACDataTransferSimple(0x80);
  DACDataReceive();
  if ((DACDataAnswer[1] != DataAhi) ||
      (DACDataAnswer[2] != DataAlo)) {
    //    byte data[2];
    //    data[0] = DACCommand;
    //    data[1] = DAC_Output;
    CreateAndSendPacket(DrivePins, 0);
  }

  PinHL(PinControl);
  DACDataTransferSimple(0x82);
  DACDataReceive();
  if ((DACDataAnswer[1] != DataBhi) ||
      (DACDataAnswer[2] != DataBlo)) {
    //    byte data[2];
    //    data[0] = DACCommand;
    //    data[1] = DAC_Output;
    CreateAndSendPacket(DrivePins, 0);
  }

//  PinHL(PinControl);
//  DACDataTransferSimple(0x90);
//  DACDataReceive();
//  digitalWrite(PinControl, HIGH);
//
//  if ((bitRead(DACDataAnswer[2], 7) == 1) ||
//      (bitRead(DACDataAnswer[1], 1) == 1) ) {
//    byte data[2];
//    //    data[0] = DACCommand;
//    //    data[1] = DAC_Overcurrent;
//    ActionId = DAC_Overcurrent;
//    data[0] = DACDataAnswer[1];
//    data[1] = DACDataAnswer[2];
//    CreateAndSendPacket(data, sizeof(data));
//  }
  DACOvercurrent();
  GateClose();
}





