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



class IVChar: public SmartDelay, public WireObject, public PinAndID
{
  public:
    IVChar();
    bool Begin();
    void Process();
    byte ForwMaxCurrent[5];
    byte RevMaxCurrent[5];
  private:
   float ConvertByteToVoltage(byte B);
   unsigned long _DragonBackTime; //[] microsec
   byte _DACbytes[10];
   bool _ForwBranchEnable;
   bool _RevBranchEnable; 
   float _V0_forw;
   float _V0_rev;    
   float _ForwStepValue[7];
   float _RevStepValue[7];
   byte _ForwStepNumber[7];
   byte _RevStepNumber[7];
   byte _VMD_Request[8];
   byte _CMD_Request[8];
   bool _CurrentLimited;
   
};


#endif
