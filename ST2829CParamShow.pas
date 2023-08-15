unit ST2829CParamShow;

interface

uses
  SCPIshow, ST2829C;

type

TST2829C_DoubleParameterShow=class(TSCPI_DoubleParameterShow)
 private
 protected
  function FuncForObjectToSetting:double;override;
 public
end;

TST2829C_IntegerParameterShow=class(TSCPI_IntegerParameterShow)
 private
 protected
  function FuncForObjectToSetting:integer;override;
 public
end;

TST2829C_BoolParameterShow=class(TSCPI_BoolParameterShow)
 private
 protected
  function FuncForObjectToSetting:boolean;override;
 public
end;


TST2829C_StringParameterShow=class(TSCPI_StringParameterShow)
 private
 protected
  function HighForSLFilling:byte;override;
  function StrForSLFilling(i:byte):string;override;
  function FuncForObjectToSetting:byte;override;
 public
end;

//---------------------------------------------------------

TST2829C_OutputImpedanceShow=class(TST2829C_StringParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;


TST2829C_MeasureTypeShow=class(TST2829C_StringParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_RangeShow=class(TST2829C_StringParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_MeasureSpeedShow=class(TST2829C_StringParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_TrigerSourceShow=class(TST2829C_StringParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;
//------------------------------------------------------------------

TST2829C_AutoLevelShow=class(TST2829C_BoolParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_BiasEnableShow=class(TST2829C_BoolParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_VrmsToMeasureShow=class(TST2829C_BoolParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_IrmsToMeasureShow=class(TST2829C_BoolParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

//----------------------------------------------------

TST2829C_FreqMeasShow=class(TST2829C_DoubleParameterShow)
 protected
//  procedure HookParameterClickFreqMeas;
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_VMeasShow=class(TST2829C_DoubleParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_IMeasShow=class(TST2829C_DoubleParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_BiasVoltageShow=class(TST2829C_DoubleParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_BiasCurrentShow=class(TST2829C_DoubleParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

//----------------------------------------------------------------
TST2829C_AverTimesShow=class(TST2829C_IntegerParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_DelayTimeShow=class(TST2829C_IntegerParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;


implementation

uses
  ST2829CConst;

{ TST2829C_DoubleParameterShow }

function TST2829C_DoubleParameterShow.FuncForObjectToSetting: double;
begin
  case TST2829CAction(fActionType) of
    st_aFreqMeas:Result:=(fSCPInew as TST2829C).FreqMeas;
    st_aVMeas:Result:=(fSCPInew as TST2829C).VrmsMeas;
    st_aIMeas:Result:=(fSCPInew as TST2829C).IrmsMeas;
    st_aBiasVol:Result:=(fSCPInew as TST2829C).BiasVoltageValue;
    st_aBiasCur:Result:=(fSCPInew as TST2829C).BiasCurrentValue;

    else Result:=-1;
  end;
end;

{ TST2829C_BoolParameterShow }

function TST2829C_BoolParameterShow.FuncForObjectToSetting: boolean;
begin
  case TST2829CAction(fActionType) of
    st_aALE:Result:=(fSCPInew as TST2829C).AutoLevelControlEnable;
    st_aBiasEn:Result:=(fSCPInew as TST2829C).BiasEnable;
    st_aVrmsToMeas:Result:=(fSCPInew as TST2829C).VrmsToMeasure;
    st_aIrmsToMeas:Result:=(fSCPInew as TST2829C).IrmsToMeasure;
    else Result:=False;
  end;
end;

{ TST2829C_AutoDelayShow }

constructor TST2829C_AutoLevelShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aALE),'Auto Level Control');
end;

{ TST2829C_FreqMeasShow }

constructor TST2829C_FreqMeasShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aFreqMeas),
                 'Meas Freq, Hz:',1000,10);
 SetLimits(ST2829C_FreqMeasLimits);
 HookParameterClick:=ObjectToSetting;
end;

//procedure TST2829C_FreqMeasShow.HookParameterClickFreqMeas;
//begin
//  ObjectToSetting;
//end;

{ TST2829C_VMeasShow }

constructor TST2829C_VMeasShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aVMeas),
                 'Meas Vmrs, V:',0.01,8);
 SetLimits(ST2829C_VmrsMeasLimits);
// HookParameterClick:=ObjectToSetting;
end;

{ TST2829C_IMeasShow }

constructor TST2829C_IMeasShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aIMeas),
                 'Meas Imrs, mA:',0.1,7);
 SetLimits(ST2829C_ImrsMeasLimits);
// HookParameterClick:=ObjectToSetting;
end;

{ TST2829C_BiasEnableShow }

constructor TST2829C_BiasEnableShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aBiasEn),'Bias Enable');
end;

{ TST2829C_BiasVoltageShow }

constructor TST2829C_BiasVoltageShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aBiasVol),
                 'Bias, V:',0,7);
 SetLimits(ST2829C_BiasVoltageLimits);
 HookParameterClick:=ObjectToSetting;
end;

{ TST2829C_StringParameterShow }

function TST2829C_StringParameterShow.FuncForObjectToSetting: byte;
begin
  case TST2829CAction(fActionType) of
    st_aOutImp:Result:=ord((fSCPInew as TST2829C).OutputImpedance);
    st_aSetMeasT:Result:=ord((fSCPInew as TST2829C).MeasureType);
    st_aSpeedMeas:Result:=ord((fSCPInew as TST2829C).MeasureSpeed);
    st_aTrigSource:Result:=ord((fSCPInew as TST2829C).TrigSource);
    else Result:=255;
  end;
end;

function TST2829C_StringParameterShow.HighForSLFilling: byte;
begin
 case TST2829CAction(fActionType) of
  st_aOutImp:Result:=ord(High(TST2829C_OutputImpedance));
  st_aSetMeasT:Result:=ord(High(TST2829C_MeasureType));
  st_aRange:Result:=ord(High(TST2829C_Range));
  st_aSpeedMeas:Result:=ord(High(TST2829C_MeasureSpeed));
  st_aTrigSource:Result:=ord(High(TST2829C_TrigerSource));

  else Result:=0;
 end;
end;

function TST2829C_StringParameterShow.StrForSLFilling(i: byte): string;
begin
 case TST2829CAction(fActionType) of
  st_aOutImp:Result:=ST2829C_OutputImpedanceLabels[TST2829C_OutputImpedance(i)];
  st_aSetMeasT:Result:=ST2829C_MeasureTypeLabels[TST2829C_MeasureType(i)];
  st_aRange:Result:=ST2829C_RangeLabels[TST2829C_Range(i)];
  st_aSpeedMeas:Result:=ST2829C_MeasureSpeedCommands[TST2829C_MeasureSpeed(i)];
  st_aTrigSource:Result:=ST2829C_TrigerSourceLabels[TST2829C_TrigerSource(i)];
  else Result:='';
 end;
end;

{ TST2829C_OutputImpedanceShow }

constructor TST2829C_OutputImpedanceShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aOutImp),
                     'Input Impedance:', True);
end;

{ TST2829C_MeasureTypeShow }

constructor TST2829C_MeasureTypeShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aSetMeasT),
                     'MeasType', False);
end;

{ TST2829C_RangeShow }

constructor TST2829C_RangeShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aRange),
                     'Range:', True);
end;

{ TST2829C_MeasureSpeedShow }

constructor TST2829C_MeasureSpeedShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aSpeedMeas),
                     'Speed:', True);
end;

{ TST2829C_IntegerParameterShow }

function TST2829C_IntegerParameterShow.FuncForObjectToSetting: integer;
begin
  case TST2829CAction(fActionType) of
    st_aAverTimes:Result:=(fSCPInew as TST2829C).AverTimes;
    st_aTrigDelay:Result:=(fSCPInew as TST2829C).DelayTime;
    else Result:=-1;
  end;
end;

{ TST2829C_AverTimesShow }

constructor TST2829C_AverTimesShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aAverTimes),
                 'Average Count:',1);
 SetLimits(ST2829C_AverTimes);
end;

{ TST2829C_VrmsToMeasureShow }

constructor TST2829C_VrmsToMeasureShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aVrmsToMeas),'To measure Vrms');
end;

{ TST2829C_IrmsToMeasureShow }

constructor TST2829C_IrmsToMeasureShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aIrmsToMeas),'To measure Irms');
end;

{ TST2829C_BiasCurrentShow }

constructor TST2829C_BiasCurrentShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aBiasCur),
                 'Bias, mA:',0,7);
 SetLimits(ST2829C_BiasCurrentLimits);
 HookParameterClick:=ObjectToSetting;
end;

{ TST2829C_TrigerSourceShow }

constructor TST2829C_TrigerSourceShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aTrigSource),
                     'Triger Source:', True);
end;

{ TST2829C_DelayTimeShow }

constructor TST2829C_DelayTimeShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aTrigDelay),
                 'Delay Time, ms:',0);
 SetLimits(ST2829C_DelayTime);
end;

end.
