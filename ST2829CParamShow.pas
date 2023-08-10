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

TST2829C_BoolParameterShow=class(TSCPI_BoolParameterShow)
 private
 protected
  function FuncForObjectToSetting:boolean;override;
 public
end;

TST2829C_AutoDelayShow=class(TST2829C_BoolParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_FreqMeasShow=class(TST2829C_DoubleParameterShow)
 protected
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
    else Result:=-1;
  end;
end;

{ TST2829C_BoolParameterShow }

function TST2829C_BoolParameterShow.FuncForObjectToSetting: boolean;
begin
  case TST2829CAction(fActionType) of
    st_aALE:Result:=(fSCPInew as TST2829C).AutoLevelControlEnable;
    else Result:=False;
  end;
end;

{ TST2829C_AutoDelayShow }

constructor TST2829C_AutoDelayShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aALE),'Auto Level Control');
end;

{ TST2829C_FreqMeasShow }

constructor TST2829C_FreqMeasShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aFreqMeas),
                 'Meas Freq',1000,2);
 SetLimits(ST2829C_FreqMeasLimits);
end;

{ TST2829C_VMeasShow }

constructor TST2829C_VMeasShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aVMeas),
                 'Meas Vmrs',0.01,2);
 SetLimits(ST2829C_VmrsMeasLimits);
end;

{ TST2829C_IMeasShow }

constructor TST2829C_IMeasShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aIMeas),
                 'Meas Imrs',0.1,2);
 SetLimits(ST2829C_ImrsMeasLimits);
end;

end.
