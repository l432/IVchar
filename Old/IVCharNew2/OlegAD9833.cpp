#include "OlegAD9833.h"

AD9833o::AD9833o()
{
  _SetupIsNotDone = true;
  _speedMaximum = SPI_CLOCK_DIV2;
  _dataMode = SPI_MODE2;
}


bool AD9833o::Action() {

  if (DeviceId != AD9833Command) return false;

  if (NumberByte < 6) return true;
  if (bitRead(NumberByte, 0) == 1)   return true;

  SetPin(PinControl);
  if (_SetupIsNotDone) Setup();
  for (byte i = 0; i < ((NumberByte - 4) >> 1); i++) {
    WordTransfer(DataFromPC[2 * i + 3], DataFromPC[2 * i + 4]);
  }
}


void AD9833o::Setup() {

  WordTransfer(0x21, 0x00); //Reset + DB28
  WordTransfer(0x69, 0xF1);
  WordTransfer(0x40, 0x00); //1kHz  to the FREQ0 Register
  WordTransfer(0xA9, 0xF1);
  WordTransfer(0x80, 0x00); //1kHz  to the FREQ1 Register
  WordTransfer(0xC0, 0x00); //0  to the PHASE0 Register
  WordTransfer(0xE0, 0x00); //0  to the PHASE1 Register
  WordTransfer(0x20, 0x00); //Exit Reset
  //  ControlBlink();
  _SetupIsNotDone = false;
}
