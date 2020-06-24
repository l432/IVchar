unit PID;

interface

uses
  ShowTypes, Windows, StdCtrls, IniFiles, OlegShowTypes,
  OlegTypePart2;

type

TPID_Parameters=(ppKp,ppKi,ppKd,ppNV,ppTol,ppOVmax,ppOVmin);
TPID_ParamArr=array[TPID_Parameters]of Double;

TPID_ParametersShow=class(TNamedInterfacedObject)
 private
  fParameterShow:array[TPID_Parameters]of TDoubleParameterShow;
  function GetParameter(Index:TPID_Parameters):double;
  function GetParameters:TPID_ParamArr;
  procedure SetNeededValue(Index:TPID_Parameters;const Value: double);
 public
//  property Kp:double Index ppKp read GetParameter;
//  property Ki:double Index ppKi read GetParameter;
//  property Kd:double Index ppKd read GetParameter;
  property NeededValue:double Index ppNV {read GetParameter }write SetNeededValue;
  property Tolerance:double Index ppTol read GetParameter;
  property Parameters:TPID_ParamArr read GetParameters;
  Constructor Create(Name:string;
                     STKp,STKi,STKd,STNV,STTol,STOVmax,STOVmin:TStaticText;
                     LKp,LKi,LKd,LNV,LTol,LOVmax,LOVmin:TLabel);
  procedure WriteToIniFile(ConfigFile:TIniFile);override;
  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
  destructor Destroy;override;
end;

TPID=class
  private
    fParameters:TPID_ParamArr;
//    FKi: double;
//    FKd: double;
//    FKp: double;
    FPeriod: double;
//    FNeeded: double;
//    FTolerance:double;
    EpsSum:double;
    Epsi:array[0..1]of double;
    fOutputValue:double;
//    FOutputValueMax: double;
//    FOutputValueMin: double;
//    procedure SetKd(const Value: double);
//    procedure SetKi(const Value: double);
//    procedure SetKp(const Value: double);
    procedure SetPeriod(const Value: double);
//    procedure SetNeeded(const Value: double);
//    procedure SetTolerance(const Value: double);
    procedure DeviationCalculation(CurrentValue:double);
//    procedure SetKd(const Value: double);
//    procedure SetKi(const Value: double);
//    procedure SetKp(const Value: double);
//    procedure SetNeeded(const Value: double);
//    procedure SetOutputValueMax(const Value: double);
//    procedure SetOutputValueMin(const Value: double);
//    procedure SetTolerance(const Value: double);
//    procedure SetOutputValueMax(const Value: double);
//    procedure SetOutputValueMin(const Value: double);

 public
//   property Kp:double read FKp write SetKp;
//   property Ki:double read FKi write SetKi;
//   property Kd:double read FKd write SetKd;
   property Period:double read FPeriod write SetPeriod;
//   property Needed:double read FNeeded write SetNeeded;
//   property Tolerance:double read FTolerance write SetTolerance;
//   property OutputValueMax:double read FOutputValueMax write SetOutputValueMax;
//   property OutputValueMin:double read FOutputValueMin write SetOutputValueMin;
   property OutputValue:double read fOutputValue;
   Constructor Create(const PID_ParamArr:TPID_ParamArr;const Interval:double);overload;
   Constructor Create(PID_PShow:TPID_ParametersShow;Interval:double);overload;
   function ControlingSignal(CurrentValue:double):double;
   procedure SetParametr(const PID_ParamArr:TPID_ParamArr;const IInterval:double);overload;
//   procedure SetParametr(Kpp,Kii,Kdd,NeededValue,Tol,IInterval:double);overload;
   procedure SetParametr(PID_PShow:TPID_ParametersShow;T:double);overload;
end;




implementation

uses
  OlegType, SysUtils, Math;

{ TPID }

function TPID.ControlingSignal(CurrentValue: double): double;
begin
 if CurrentValue=ErResult then
    begin
     fOutputValue:=ErResult;
    end                   else
    begin
     DeviationCalculation(CurrentValue);
     fOutputValue:=fParameters[ppKp]*(Epsi[1]
                    +fParameters[ppKi]*Period*EpsSum
                    +fParameters[ppKd]/Period*(Epsi[1]-Epsi[0]));
     if fParameters[ppOVmax]>fParameters[ppOVmin] then
      fOutputValue:=EnsureRange(fOutputValue,
                      fParameters[ppOVmin],
                      fParameters[ppOVmax]);
//     fOutputValue:=Kp*(Epsi[1]+Ki*Period*EpsSum+Kd/Period*(Epsi[1]-Epsi[0]));
//     if FOutputValueMax>FOutputValueMin then
//      fOutputValue:=EnsureRange(fOutputValue,FOutputValueMin,FOutputValueMax);
    end;
 Result:=fOutputValue;
end;

//constructor TPID.Create(Kpp,Kii,Kdd,NeededValue,Tol,Interval:double);
constructor TPID.Create(const PID_ParamArr:TPID_ParamArr;const Interval:double);
begin
  inherited Create;
  SetParametr(PID_ParamArr,Interval);
//  SetParametr(Kpp, Kii, Kdd, NeededValue, Tol,Interval);
  EpsSum:=0;
  Epsi[0]:=0;
  Epsi[1]:=0;
end;

constructor TPID.Create(PID_PShow: TPID_ParametersShow; Interval: double);
begin
 inherited Create;
 SetParametr(PID_PShow,Interval);
 EpsSum:=0;
 Epsi[0]:=0;
 Epsi[1]:=0;
// Create(PID_PShow.Kp,PID_PShow.Ki,PID_PShow.Kd,PID_PShow.NeededValue,PID_PShow.Tolerance,Interval);
end;

procedure TPID.DeviationCalculation(CurrentValue: double);
 var eps:double;
begin
// eps:=FNeeded-CurrentValue;
 eps:=fParameters[ppNV]-CurrentValue;
// if abs(eps)>abs(FTolerance) then
 if abs(eps)>abs(fParameters[ppTol]) then
   EpsSum:=EpsSum+eps;
 Epsi[0]:=Epsi[1];
 Epsi[1]:=eps;
end;

//procedure TPID.SetKd(const Value: double);
//begin
//  FKd := Value;
//end;
//
//procedure TPID.SetKi(const Value: double);
//begin
//  FKi := Value;
//end;
//
//procedure TPID.SetKp(const Value: double);
//begin
//  FKp := Value;
//end;
//
//procedure TPID.SetNeeded(const Value: double);
//begin
//  FNeeded := Value;
//end;

//procedure TPID.SetOutputValueMax(const Value: double);
//begin
//  FOutputValueMax := Value;
//end;
//
//procedure TPID.SetOutputValueMin(const Value: double);
//begin
//  FOutputValueMin := Value;
//end;

//procedure TPID.SetParametr(Kpp,Kii,Kdd,NeededValue,Tol,IInterval:double);
//begin
//  Kp:=Kpp;
//  Ki:=Kii;
//  Period:=IInterval;
//  Needed:=NeededValue;
//  Kd:=Kdd;
//  Tolerance:=Tol;
//end;

procedure TPID.SetParametr(PID_PShow: TPID_ParametersShow; T: double);
begin
 SetParametr(PID_PShow.Parameters,T);
// SetParametr(PID_PShow.Kp,PID_PShow.Ki,PID_PShow.Kd,PID_PShow.NeededValue,PID_PShow.Tolerance,T);
end;

procedure TPID.SetParametr(const PID_ParamArr: TPID_ParamArr;
                          const IInterval: double);
 var i:TPID_Parameters;
begin
 Period:=IInterval;
 for i:= Low(TPID_Parameters) to High(TPID_Parameters) do
  fParameters[i]:=PID_ParamArr[i];
end;

procedure TPID.SetPeriod(const Value: double);
begin
  if Value>0 then FPeriod := Value
             else fPeriod :=1;
end;


//procedure TPID.SetTolerance(const Value: double);
//begin
// FTolerance := Value;
//end;

{ TPID_ParametersShow }

constructor TPID_ParametersShow.Create(Name: string;
                                      STKp,STKi,STKd,STNV,STTol,STOVmax,STOVmin:TStaticText;
                                      LKp,LKi,LKd,LNV,LTol,LOVmax,LOVmin:TLabel);
 var i:TPID_Parameters;
begin
   inherited Create;
  FName:=Name;
  fParameterShow[ppKp]:=TDoubleParameterShow.Create(STKp,LKp,'Kp','Proportional term',1);
  fParameterShow[ppKi]:=TDoubleParameterShow.Create(STKi,LKi,'Ki','Integral term',0);
  fParameterShow[ppKd]:=TDoubleParameterShow.Create(STKd,LKd,'Kd','Derivative term',0);
  fParameterShow[ppNV]:=TDoubleParameterShow.Create(STNV,LNV,'Needed','Needed Value',0,4);
  fParameterShow[ppTol]:=TDoubleParameterShow.Create(STTol,LTol,'Tolerance','Tolerance to Needed Value',1e-4);
  fParameterShow[ppTol].Limits.SetLimits(0);
//  LowLimit:=0;
  fParameterShow[ppOVmax]:=TDoubleParameterShow.Create(STOVmax,LOVmax,'OutputMax','Max control signal',1);
  fParameterShow[ppOVmin]:=TDoubleParameterShow.Create(STOVmin,LOVmin,'OutputMin','Min control signal',0);

  for I := Low(TPID_Parameters) to High(TPID_Parameters) do
   fParameterShow[i].SetName(FName);
end;

destructor TPID_ParametersShow.Destroy;
 var i:TPID_Parameters;
begin
  for I := Low(TPID_Parameters) to High(TPID_Parameters) do
   fParameterShow[i].Free;
  inherited;
end;

function TPID_ParametersShow.GetParameter(Index: TPID_Parameters): double;
begin
 Result:=fParameterShow[Index].Data;
end;

function TPID_ParametersShow.GetParameters: TPID_ParamArr;
 var i:TPID_Parameters;
begin
 for I := Low(TPID_Parameters) to High(TPID_Parameters) do
   Result[i]:=fParameterShow[i].Data;
end;

procedure TPID_ParametersShow.ReadFromIniFile(ConfigFile: TIniFile);
 var i:TPID_Parameters;
begin
 for I := Low(TPID_Parameters) to High(TPID_Parameters) do
  fParameterShow[i].ReadFromIniFile(ConfigFile);
end;

procedure TPID_ParametersShow.SetNeededValue(Index: TPID_Parameters;
  const Value: double);
begin
   fParameterShow[Index].Data:=Value;
end;


procedure TPID_ParametersShow.WriteToIniFile(ConfigFile: TIniFile);
 var i:TPID_Parameters;
begin
 for I := Low(TPID_Parameters) to High(TPID_Parameters) do
  fParameterShow[i].WriteToIniFile(ConfigFile);
end;

end.
