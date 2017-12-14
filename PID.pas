unit PID;

interface

type

TPID=class
  private
    FKi: double;
    FKd: double;
    FKp: double;
    FPeriod: double;
    FNeeded: double;
    EpsSum:double;
    Epsi:array[0..1]of double;
    fOutputValue:double;
    procedure SetKd(const Value: double);
    procedure SetKi(const Value: double);
    procedure SetKp(const Value: double);
    procedure SetPeriod(const Value: double);
    procedure SetNeeded(const Value: double);
    procedure DeviationCalculation(CurrentValue:double);

 public
   property Kp:double read FKp write SetKp;
   property Ki:double read FKi write SetKi;
   property Kd:double read FKd write SetKd;
   property Period:double read FPeriod write SetPeriod;
   property Needed:double read FNeeded write SetNeeded;
   property OutputValue:double read fOutputValue;
   Constructor Create(Kpp,Kii,Kdd,T,NeededValue:double);
   function ControlingSignal(CurrentValue:double):double;
end;



implementation

uses
  OlegType;

{ TPID }

function TPID.ControlingSignal(CurrentValue: double): double;
begin
 if CurrentValue=ErResult then
    begin
     fOutputValue:=0;
    end                   else
    begin
     DeviationCalculation(CurrentValue);
     fOutputValue:=Kp*(Epsi[1]+Ki*Period*EpsSum+Kd/Period*(Epsi[1]-Epsi[0]));
    end;
 Result:=fOutputValue;
end;

constructor TPID.Create(Kpp, Kii, Kdd, T, NeededValue: double);
begin
  inherited Create;
  Kp:=Kpp;
  Ki:=Kii;
  Period:=T;
  Needed:=NeededValue;
  EpsSum:=0;
  Epsi[0]:=0;
  Epsi[1]:=0;
  Kd:=Kdd;
end;

procedure TPID.DeviationCalculation(CurrentValue: double);
 var eps:double;
begin
 eps:=FNeeded-CurrentValue;
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

procedure TPID.SetPeriod(const Value: double);
begin
  if Value>0 then FPeriod := Value
             else fPeriod :=1;
end;


end.
