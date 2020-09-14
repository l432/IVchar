#ifndef OLEG_IVChar
#define OLEG_IVChar

#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include "SmartDelay.h"
#include "WireObject.h"
#include "OlegPacket.h"
#include "OlegConstant.h"

const float DragonBackOvershootHeight = 1.05;
const byte MaxCurrentMeasuringAttemp = 2;

//bool ToBackDoor = false;

typedef enum  {
  Waiting,
  SetedVoltageFirst,
  SetedVoltageSecond,
  StartedCMD,
  StartedCMDandVMD
} IV_status;

class IVChar: public SmartDelay, public WireObject, public PinAndID, public FastIVData
{
  public:
    IVChar();
    bool Begin();
    void Process();
    byte ForwMaxCurrent[5];
    byte RevMaxCurrent[5];
    byte VMD_InResult;
    byte CMD_InResult;
    //    static bool ToBackDoor;

  private:
    IV_status _status;
    float ConvertByteToVoltage(byte B);
    //    void SetVoltageFirst(float VoltageToSet);
    void SetVoltage(float VoltageToSet);
    void MD_Start(byte Request[]);
    void PrepareToMeasuring(byte StartPosition, bool DoNotCheckCurrent = false);
    bool SecondCurrentIsMore(byte FirstStartIndex, byte FirstArray[],
                             byte SecondStartIndex, byte SecondArray[]);
    //    unsigned long _DragonBackTime; //[] microsec
    bool CurrentCheck();
    bool CurrentCheckLimit();
    bool ChangeVoltage();  
    void EndMeasuring();
    void SendDataToPC(byte EndByte);
    void StopMeasuring();
    byte _DACbytes[10];
    bool _ForwBranchEnable;
    bool _RevBranchEnable;
    bool _IsForward;
    float _VoltageToSet;
    float _V0_rev;
    float _ForwStepValue[7];
    float _RevStepValue[7];
    byte _ForwStepNumber[7];
    byte _RevStepNumber[7];
    byte _VMD_Request[8];
    byte _CMD_Request[8];
    bool _CurrentLimited;
    bool ReadInstruction();
    bool _CurrentChecked;
    byte _AtempNumber;
    byte _StepData;
    byte ForwStepNumber;
    byte RevStepNumber;    
};


#endif
