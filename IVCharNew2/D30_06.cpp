#include "D30_06.h"

D30_06::D30_06(byte SignPinNumber): DACR2R(SignPinNumber) {
  SetInterval(500000);
}

bool D30_06::Begin() {
  if (DeviceId != D30_06Command) return false;
  if ((NumberByte < 8) || (!isReady())) return true;

  BeginDataRead(DataFromPC[4], DataFromPC[5]);
  if (SignMustBeChangedDetermine(DataFromPC[6]))
  {
    Start();
    TwoByteTransfer(0, 0);
  } else {
    DataTransfer();
  }
  return true;
}


void D30_06::Process() {
  ChangeSign();
  Stop();
  DataTransfer();
}

void  D30_06::TwoByteTransfer(byte Data1, byte Data2) {
  digitalWrite(DataFromPC[3], LOW);
  ShortDelay();

  SPIObject::TwoByteTransfer(Data1, Data2);
  
  digitalWrite(DataFromPC[3], HIGH);
  ShortDelay();
};




