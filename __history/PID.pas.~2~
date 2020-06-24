unit PID;

interface

uses
  ShowTypes, Windows, StdCtrls, IniFiles, OlegShowTypes,
  OlegTypePart2;

type

TPID_Parameters=(ppKp,ppKi,ppKd,ppNV,ppTol);

TPID_ParametersShow=class(TNamedInterfacedObject)
  private
    fParameterShow:array[TPID_Parameters]of TDoubleParameterShow;
    function GetParameter(Index:TPID_Parameters):double;
    procedure SetNeededValue(Index:TPID_Parameters;const Value: double);
 public
  property Kp:double Index ppKp read GetParameter;
  property Ki:double Index ppKi read GetParameter;
  property Kd:double Index ppKd read GetParameter;
  property NeededValue:double Index ppNV read GetParameter write SetNeededValue;
  property Tolerance:double Index ppTol read GetParameter;
  Constructor Create(Name:string;
                     STKp,STKi,STKd,STNV,STTol:TStaticText;
                     LKp,LKi,LKd,LNV,LTol:TLabel);
  procedure WriteToIniFile(ConfigFile:TIniFile);override;
  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
  destructor Destroy;override;
end;

TPID=class
  private
    FKi: double;
    FKd: double;
    FKp: double;
    FPeriod: double;
    FNeeded: double;
    FTolerance:double;
    EpsSum:double;
    Epsi:array[0..1]of double;
    fOutputValue:double;
    procedure SetKd(const Value: double);
    procedure SetKi(const Value: double);
    procedure SetKp(const Value: double);
    procedure SetPeriod(const Value: double);
    procedure SetNeeded(const Value: double);
    procedure SetTolerance(const Value: double);
    procedure DeviationCalculation(CurrentValue:double);

 public
   property Kp:double read FKp write SetKp;
   property Ki:double read FKi write SetKi;
   property Kd:double read FKd write SetKd;
   property Period:double read FPeriod write SetPeriod;
   property Needed:double read FNeeded write SetNeeded;
   property Tolerance:double read FTolerance write SetTolerance;
   property OutputValue:double read fOutputValue;
   Constructor Create(Kpp,Kii,Kdd,NeededValue,Tol,Interval:double);overload;
   Constructor Create(PID_PShow:TPID_ParametersShow;Interval:double);overload;
   function ControlingSignal(CurrentValue:double):double;
   procedure SetParametr(Kpp,Kii,Kdd,NeededValue,Tol,IInterval:double);overload;
   procedure SetParametr(PID_PShow:TPID_ParametersShow;T:double);overload;
end;




implementation

uses
  OlegType, SysUtils;

{ TPID }

function TPID.ControlingSignal(CurrentValue: double): double;
begin
 if CurrentValue=ErResult then
    begin
     fOutputValue:=ErResult;
    end                   else
    begin
     DeviationCalculation(CurrentValue);
     fOutputValue:=Kp*(Epsi[1]+Ki*Period*EpsSum+Kd/Period*(Epsi[1]-Epsi[0]));
    end;
 Result:=fOutputValue;
end;

constructor TPID.Create(Kpp,Kii,Kdd,NeededValue,Tol,Interval:double);
begin
  inherited Create;
  SetParametr(Kpp, Kii, Kdd, NeededValue, Tol,Interval);
  EpsSum:=0;
  Epsi[0]:=0;
  Epsi[1]:=0;
end;

constructor TPID.Create(PID_PShow: TPID_ParametersShow; Interval: double);
begin
 Create(PID_PShow.Kp,PID_PShow.Ki,PID_PShow.Kd,PID_PShow.NeededValue,PID_PShow.Tolerance,Interval);
end;

procedure TPID.DeviationCalculation(CurrentValue: double);
 var eps:double;
begin
 eps:=FNeeded-CurrentValue;
 if abs(eps)>abs(FTolerance) then
   EpsSum:=EpsSum+eps;
 Epsi[0]:=Epsi[1];
 Epsi[1]:=eps;
end;

procedure TPID.SetKd(const Value: double);
begin
  FKd := Value;
end;

procedure TPID.SetKi(const Value: double);
begin
  FKi := Value;
end;

procedure TPID.SetKp(const Value: double);
begin
  FKp := Value;
end;

procedure TPID.SetNeeded(const Value: double);
begin
  FNeeded := Value;
end;

procedure TPID.SetParametr(Kpp,Kii,Kdd,NeededValue,Tol,IInterval:double);
begin
  Kp:=Kpp;
  Ki:=Kii;
  Period:=IInterval;
  Needed:=NeededValue;
  Kd:=Kdd;
  Tolerance:=Tol;
end;

procedure TPID.SetParametr(PID_PShow: TPID_ParametersShow; T: double);
begin
 SetParametr(PID_PShow.Kp,PID_PShow.Ki,PID_PShow.Kd,PID_PShow.NeededValue,PID_PShow.Tolerance,T);
end;

procedure TPID.SetPeriod(const Value: double);
begin
  if Value>0 then FPeriod := Value
             else fPeriod :=1;
end;


procedure TPID.SetTolerance(const Value: double);
begin
 FTolerance := Value;
end;

{ TPID_ParametersShow }

constructor TPID_ParametersShow.Create(Name: string;
                                       STKp, STKi, STKd, STNV, STTol: TStaticText;
                                       LKp, LKi, LKd, LNV, LTol: TLabel);
 var i:TPID_Parameters;
begin
   inherited Create;
  FName:=Name;
  fParameterShow[ppKp]:=TDoubleParameterShow.Create(STKp,LKp,'Kp','Proportional term',1);
  fParameterShow[ppKi]:=TDoubleParameterShow.Create(STKi,LKi,'Ki','Integral term',0);
  fParameterShow[ppKd]:=TDoubleParameterShow.Create(STKd,LKd,'Kd','Derivative term',0);
  fParameterShow[ppNV]:=TDoubleParameterShow.Create(STNV,LNV,'Needed','Needed Value',0,4);
  fParameterShow[ppTol]:=TDoubleParameterShow.Create(STTol,LTol,'Tolerance','Tolerance to Needed Value',1e-4);
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
