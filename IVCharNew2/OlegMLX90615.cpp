#include "OlegMLX90615.h"


MLX90615o::MLX90615o()
{
  SetInterval(350000);
  SetAdress(0x5B);
  SetDataReceivedNumber(3);
}

bool MLX90615o::Begin() {
  if (DeviceId != MLX90615Command) return false;
  if (!isReady()) return true;
  //    SetAdress(PinControl);
  _DataToSend[0] = DataFromPC[3];
  if (_DataToSend[0] == MLX_Write_Emissivity)
  {
    _DataToSend[1] = DataFromPC[4];
    _DataToSend[2] = DataFromPC[5];
    _DataToSend[3] = DataFromPC[6];
  };

  ByteTransfer(0x00); //Exit from Sleep Mode
  Start();
  return true;
}


void MLX90615o::Process() {

  if (_DataToSend[0] == MLX_Write_Emissivity)
  {
    byte tempData[4] = {0xB6, 0x13, 0x00, 0x00};
    ArrayByteTransfer(tempData, 4);
    delayMicroseconds(5500);
    _DataToSend[0] = 0x13;
    ArrayByteTransfer(_DataToSend, 4);
    delayMicroseconds(5500);
  };
  ByteTransfer(_DataToSend[0]);
  DataReceive();
  DeviceId = MLX90615Command;
  ActionId = _address;
  CreateAndSendPacket(_DataReceived, GetDataReceivedNumber());
  Stop();
  TwoByteTransfer(0xC6, 0x6D); //Enter to Sleep Mode
}
