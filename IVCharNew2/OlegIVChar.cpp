#include "OlegIVChar.h"
#include "OlegAD5752.h"

//bool IVChar::ToBackDoor = false;

IVChar::IVChar()
{
  _status = Waiting;
}


bool IVChar::Begin() {
//  ControlBlink();
  if (DeviceId != ArduinoIVCommand) return false;
  if ((PinControl == ArduinoIVCommand) &
      (DataFromPC[3] == 0x00) &
      (DataFromPC[4] == 0x00)) {
    StopMeasuring();
    return true;
  }


  switch (_status) {
    case Waiting:
      if (ReadInstruction()) {
        SetVoltage(_VoltageToSet * DragonBackOvershootHeight);
        _status = SetedVoltageFirst;
      }
      break;
    case SetedVoltageFirst:
      SetVoltage(_VoltageToSet);
      _status = SetedVoltageSecond;
      ToBackDoor = false;
      break;
    case SetedVoltageSecond:
      MD_Start(_CMD_Request);
      CurrentMDId = _CMD_Request[1];
      _status = StartedCMD;
      ToBackDoor = true;
      break;
    case StartedCMD:
      MD_Start(_VMD_Request);
      VoltageMDId = _VMD_Request[1];
      _status = StartedCMDandVMD;
      ToBackDoor = false;
      break;
    case StartedCMDandVMD:
      if (CurrentMeasured & ~(_CurrentChecked)) {
        if (CurrentCheck()) {
          _CurrentChecked = true;
        } else {
          CurrentMeasured = false;
          MD_Start(_CMD_Request);
          CurrentMDId = _CMD_Request[1];
          _AtempNumber++;
        }
      };
      if (_CurrentChecked & VoltageMeasured) {
        if (CurrentCheckLimit()) {
          PrepareToMeasuring(VoltageResultNumber + VMD_InResult + CMD_InResult);
          if (VoltageResultNumber > PacketMaxLength - 9) {
            SendDataToPC(0xBB);
            PrepareToMeasuring(0, true);
          }
          if (ChangeVoltage()) {
            SetVoltage(_VoltageToSet * DragonBackOvershootHeight);
            _status = SetedVoltageFirst;
          }
        }
      }
      ToBackDoor = false;
      break;
  }

  return true;
}



void IVChar::Process() {
  switch (_status) {
    case SetedVoltageFirst:
      DeviceId = ArduinoIVCommand;
      ToBackDoor = true;
      break;
    case SetedVoltageSecond:
      DeviceId = ArduinoIVCommand;
      ToBackDoor = true;
      break;
  }

}

float IVChar::ConvertByteToVoltage(byte B) {
  float temp = (B & 0x7F) * 0.01;
  if ((B & 0x80) > 0) temp *= -1;
  return temp;
}

void IVChar::SetVoltage(float VoltageToSet) {
  word temp = AD5752o::VoltageToKod(VoltageToSet, _DACbytes[4]);

  DataFromPC[0] = _DACbytes[0] + 2;
  for (byte i = 1; i < 5; i++) {
    DataFromPC[i] = _DACbytes[i];
  };
  DataFromPC[5] = (byte)(temp >> 8);
  DataFromPC[6] = (byte)(temp & 0x00FF);

  NamedByteFill();
  // NumberByte = DataFromPC[0];
  // DeviceId = DataFromPC[1];
  // PinControl = DataFromPC[2];

  Start();
}

void IVChar::MD_Start(byte Request[]) {
  DataFromPC[0] = Request[0] + 2;
  for (byte i = 1; i <= Request[0]; i++) {
    DataFromPC[i] = Request[i];
  };
  NamedByteFill();
}


bool IVChar::ReadInstruction() {
  if (NumberByte < 15) return false;

  byte ByteUnderWork = 3;

  SetInterval(1000 * DataFromPC[ByteUnderWork]);
  //  _DragonBackTime = 1000 * DataFromPC[ByteUnderWork];
  ByteUnderWork++;

  for (int i = 0; i <= DataFromPC[ByteUnderWork]; i++) {
    _DACbytes[i] = DataFromPC[ByteUnderWork + i];
  };
  ByteUnderWork += DataFromPC[ByteUnderWork] + 1;

  ForwStepNumber = ((DataFromPC[ByteUnderWork] >> 4) & 0x0F);
  RevStepNumber = (DataFromPC[ByteUnderWork] & 0x0F);
  ByteUnderWork++;

  _ForwBranchEnable = (ForwStepNumber != 0);
  if (_ForwBranchEnable) {
    //    _V0_forw = ConvertByteToVoltage(DataFromPC[ByteUnderWork]);
    _VoltageToSet = ConvertByteToVoltage(DataFromPC[ByteUnderWork]);
    ByteUnderWork++;
    _IsForward = true;
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
    if (_ForwBranchEnable) {
      _V0_rev = ConvertByteToVoltage(DataFromPC[ByteUnderWork]);
    } else {
      _VoltageToSet = ConvertByteToVoltage(DataFromPC[ByteUnderWork]);
      _IsForward = false;
    };

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

  if (!(_RevBranchEnable || _ForwBranchEnable)) return false;

  _StepData = 0;

  _VMD_Request[0] = ((DataFromPC[ByteUnderWork] >> 4) & 0x0F);
  VMD_InResult = (DataFromPC[ByteUnderWork] & 0x0F);
  ByteUnderWork++;
  for (int i = 1; i <= _VMD_Request[0]; i++) {
    _VMD_Request[i] = DataFromPC[ByteUnderWork];
    ByteUnderWork++;
  };



  _CMD_Request[0] = ((DataFromPC[ByteUnderWork] >> 4) & 0x0F);
  CMD_InResult = (DataFromPC[ByteUnderWork] & 0x0F);
  ByteUnderWork++;
  for (int i = 1; i <= _CMD_Request[0]; i++) {
    _CMD_Request[i] = DataFromPC[ByteUnderWork];
    ByteUnderWork++;
  };

  PrepareToMeasuring(0, true);
  // VoltageResultNumber = 0;
  // CurrentResultNumber = VoltageResultNumber + VMD_InResult;
  // CurrentMeasured = false;
  // VoltageMeasured = false;

  _CurrentLimited = (DataFromPC[ByteUnderWork] = CMD_InResult);
  ByteUnderWork++;
  if (_CurrentLimited) {
    for (int i = 0; i < CMD_InResult; i++) {
      ForwMaxCurrent[i] = DataFromPC[ByteUnderWork + i];
      RevMaxCurrent[i] = DataFromPC[ByteUnderWork + CMD_InResult +  i];
    }
  };

  return true;
}

void IVChar::PrepareToMeasuring(byte StartPosition, bool DoNotCheckCurrent) {
  VoltageResultNumber = StartPosition;
  CurrentResultNumber = VoltageResultNumber + VMD_InResult;
  CurrentMeasured = false;
  VoltageMeasured = false;
  _CurrentChecked = DoNotCheckCurrent;
  _AtempNumber = 0;
}

bool IVChar::SecondCurrentIsMore(byte FirstStartIndex, byte FirstArray[],
                                 byte SecondStartIndex, byte SecondArray[]) {
  byte FirstSign = FirstArray[FirstStartIndex] & 0x80;
  byte SecondSign = SecondArray[SecondStartIndex] & 0x80;
  if (FirstSign != SecondSign) {
    return (SecondSign < FirstSign);
  } else {
    unsigned long temp1 =  FirstArray[FirstStartIndex];
    unsigned long temp2 =  SecondArray[SecondStartIndex];
    for (byte i = 1; i < CMD_InResult; i++) {
      temp1 = temp1 << 8;
      temp1 += FirstArray[FirstStartIndex + i];
      temp2 = temp2 << 8;
      temp2 += SecondArray[SecondStartIndex + i];
    };
    return (temp2 > temp1);
    //    if (FirstSign == 0) {
    //      return (temp2 > temp1);
    //    } else {
    //      return (temp1 > temp2);
    //    }
  }
}

bool IVChar::CurrentCheck() {
  if (_AtempNumber > MaxCurrentMeasuringAttemp) return true;
  if (_IsForward) {
    return SecondCurrentIsMore(CurrentResultNumber - VMD_InResult - CMD_InResult, DataToPC,
                               CurrentResultNumber, DataToPC) ;
  } else {
    return !SecondCurrentIsMore(CurrentResultNumber - VMD_InResult - CMD_InResult, DataToPC,
                                CurrentResultNumber, DataToPC);
  }
}

bool IVChar::CurrentCheckLimit() {
  if (!_CurrentLimited) return true;
  if (_IsForward) {
    return SecondCurrentIsMore(CurrentResultNumber, DataToPC,
                               0, ForwMaxCurrent) ;
  } else {
    return !SecondCurrentIsMore(CurrentResultNumber, DataToPC,
                                0, RevMaxCurrent);
  }
}

bool IVChar::ChangeVoltage() {
  if (_IsForward) {
    if (_ForwStepNumber[_StepData] == 0) {
      _StepData++;
      if (_StepData >= ForwStepNumber) {
        if (_RevBranchEnable) {
          _VoltageToSet = _V0_rev;
          _IsForward = false;
          _CurrentChecked = true;
          _StepData = 0;
        } else {
          EndMeasuring();
          return false;
        }
      } else {
        _VoltageToSet += _ForwStepValue[_StepData];
        _ForwStepNumber[_StepData]--;
      }
    } else {
      _VoltageToSet += _ForwStepValue[_StepData];
      _ForwStepNumber[_StepData]--;
    };
  } else {
    if (_RevStepNumber[_StepData] == 0) {
      _StepData++;
      if (_StepData >= RevStepNumber) {
        EndMeasuring();
        return false;
      } else {
        ;
        _VoltageToSet += _RevStepValue[_StepData];
        _RevStepNumber[_StepData]--;
      }

    } else {
      _VoltageToSet += _RevStepValue[_StepData];
      _RevStepNumber[_StepData]--;
    }
  };
  return true;
}

void IVChar::EndMeasuring() {
  SendDataToPC(0xEE);
  StopMeasuring();
  //  _status = Waiting;
  //  VoltageMDId = 0;
  //  CurrentMDId = 0;
}

void IVChar::SendDataToPC(byte EndByte) {
  DataToPC[CurrentResultNumber + CMD_InResult] = EndByte;
  DeviceId = ArduinoIVCommand;
  ActionId = ArduinoIVCommand;
  CreateAndSendPacket(DataToPC, CurrentResultNumber + CMD_InResult + 1);
}

void IVChar::StopMeasuring() {
  _status = Waiting;
  VoltageMDId = 0;
  CurrentMDId = 0;
  SetVoltage(0);
}

