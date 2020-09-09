#include "OlegIVChar.h"


IVChar::IVChar()
{

}


bool IVChar::Begin() {
  if (DeviceId != ArduinoIVCommand) return false;

  byte ByteUnderWork = 3;
  _DragonBackTime = DataFromPC[ByteUnderWork];
  ByteUnderWork++;

  for (int i = 0; i <= DataFromPC[ByteUnderWork]; i++) {
    _DACbytes[i] = DataFromPC[ByteUnderWork + i];
  };
  ByteUnderWork += DataFromPC[ByteUnderWork] + 1;

  byte ForwStepNumber = ((DataFromPC[ByteUnderWork] >> 4) & 0x0F);
  byte RevStepNumber = (DataFromPC[ByteUnderWork] & 0x0F);
  ByteUnderWork++;

  _ForwBranchEnable = (ForwStepNumber != 0);
  if (_ForwBranchEnable) {
    _V0_forw = ConvertByteToVoltage(DataFromPC[ByteUnderWork]);
    ByteUnderWork++;
    for (int i = 0; i < ForwStepNumber; i++) {
      _ForwStepValue[i] = ConvertByteToVoltage(DataFromPC[ByteUnderWork]);
      ByteUnderWork++;
      _ForwStepNumber[i] = DataFromPC[ByteUnderWork];
      ByteUnderWork++;
    };
    for (int i = ForwStepNumber; i < 7; i++) {
      _ForwStepNumber[i] = 0;
    }
  }

  _RevBranchEnable = (RevStepNumber != 0);
  if (_RevBranchEnable) {
    _V0_rev = ConvertByteToVoltage(DataFromPC[ByteUnderWork]);
    ByteUnderWork++;
    for (int i = 0; i < RevStepNumber; i++) {
      _RevStepValue[i] = ConvertByteToVoltage(DataFromPC[ByteUnderWork]);
      ByteUnderWork++;
      _RevStepNumber[i] = DataFromPC[ByteUnderWork];
      ByteUnderWork++;
    };
    for (int i = RevStepNumber; i < 7; i++) {
      _RevStepNumber[i] = 0;
    }
  }

  if (_RevBranchEnable || _ForwBranchEnable) return false;

  _VMD_Request[0] = ((DataFromPC[ByteUnderWork] >> 4) & 0x0F);
  _CMD_Request[0] = (DataFromPC[ByteUnderWork] & 0x0F);
  ByteUnderWork++;

  for (int i = 1; i <= _VMD_Request[0]; i++) {
    _VMD_Request[i] = DataFromPC[ByteUnderWork];
    ByteUnderWork++;
  };

  for (int i = 1; i <= _CMD_Request[0]; i++) {
    _CMD_Request[i] = DataFromPC[ByteUnderWork];
    ByteUnderWork++;
  };

  _CurrentLimited = (DataFromPC[ByteUnderWork] != 0);
  if (_CurrentLimited) {
    for (int i = 0; i < DataFromPC[ByteUnderWork]; i++) {
      ForwMaxCurrent[i] = DataFromPC[ByteUnderWork + 1 + i];
      ForwMaxCurrent[i] = DataFromPC[ByteUnderWork + DataFromPC[ByteUnderWork] + 1 + i];
    }
  };


  return true;
}



void IVChar::Process() {

}

float IVChar::ConvertByteToVoltage(byte B) {
  float temp = (B & 0x7F) * 0.01;
  if ((B & 0x80) > 0) temp *= -1;
  return temp;
}

