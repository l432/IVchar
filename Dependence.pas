unit Dependence;

interface

uses
  ArduinoDevice, StdCtrls, ComCtrls, OlegType, Series, ShowTypes,
  ExtCtrls, Classes, OlegTypePart2;

var EventToStopDependence:THandle;

type

TFastDependence=class
private
  fHookBeginMeasuring: TSimpleEvent;
  fHookEndMeasuring: TSimpleEvent;
  fHookSecondMeas:TSimpleEvent;
  fHookFirstMeas:TSimpleEvent;
  fHookDataSave:TSimpleEvent;
  fHookAction:TSimpleEvent;
  ButtonStop: TButton;
  Results:PVector;
  ForwLine: TPointSeries;
  ForwLg: TPointSeries;
  procedure ButtonStopClick(Sender: TObject);virtual;
  procedure SeriesClear();virtual;
  procedure BeginMeasuring();virtual;
  procedure EndMeasuring();virtual;
  procedure DuringMeasuring(Action: TSimpleEvent);
  procedure ActionMeasurement();virtual;
  procedure DataSave();virtual;

 public
//  property isActive:boolean read FisActive;
  property HookBeginMeasuring:TSimpleEvent read FHookBeginMeasuring write FHookBeginMeasuring;
  property HookEndMeasuring:TSimpleEvent read fHookEndMeasuring write fHookEndMeasuring;
  property HookAction:TSimpleEvent read fHookAction write fHookAction;
  property HookDataSave:TSimpleEvent read fHookDataSave write fHookDataSave;
  property HookSecondMeas:TSimpleEvent read fHookSecondMeas write fHookSecondMeas;
  property HookFirstMeas:TSimpleEvent read fHookFirstMeas write fHookFirstMeas;
  Constructor Create(BS: TButton;
                     Res:PVector;
                     FLn,FLg:TPointSeries);
  class function PointNumber:word;
  class procedure PointNumberChange(Value: word);
  class function tempV:double;
  class procedure tempVChange(Value: double);
  class function tempI:double;
  class procedure tempIChange(Value: double);
//  procedure PeriodicMeasuring();virtual;
end;




TDependence=class (TFastDependence)
private
  ProgressBar: TProgressBar;
  FisActive: boolean;
  procedure BeginMeasuring();override;
  procedure EndMeasuring();override;
  function MeasurementNumberDetermine(): integer;virtual;
  procedure ActionMeasurement();override;
  procedure DataSave();override;
 public
  property isActive:boolean read FisActive;
  Constructor Create(PB:TProgressBar;
                     BS: TButton;
                     Res:PVector;
                     FLn,FLg:TPointSeries);
  procedure PeriodicMeasuring();virtual;
end;



TTimeDependence=class(TDependence)
private
  fTreadToStop:TThread;
  fBeginTime:TDateTime;
  fSecondMeasurementTime:single;
  procedure ActionMeasurement();override;
  function BadResult:boolean;virtual;
  public
  procedure BeginMeasuring();override;
  function TimeFromBegin:single;
end;

TTimeDependenceTread = class(TThread)
  private
    { Private declarations }
   fTimeDependence:TTimeDependence;
  protected
    procedure Execute; override;
  public
    constructor Create(TimeDep:TTimeDependence);
  end;

TTimeDependenceTimer=class(TTimeDependence)
private
  Timer:TTimer;
  FInterval: integer;
  FDuration: int64;
  procedure SetDuration(const Value: int64);
  procedure SetInterval(const Value: integer);
  procedure TimerOnTime(Sender: TObject);
  procedure ActionMeasurement();override;
  function MeasurementNumberDetermine(): integer;override;
 public
  property Interval:integer read FInterval write SetInterval;
  property Duration:int64 read FDuration write SetDuration;
  Constructor Create(PB:TProgressBar;
                     BS: TButton;
                     Res:PVector;
                     FLn,FLg:TPointSeries;
                     Tim:TTimer);
  procedure BeginMeasuring();override;
  procedure EndMeasuring();override;
end;


TTimeTwoDependenceTimer=class(TTimeDependenceTimer)
 private
  function BadResult:boolean;override;
  procedure DataSave();override;
 public
  isTwoValueOnTime:boolean;
  Constructor Create(PB:TProgressBar;
                     BS: TButton;
                     Res:PVector;
                     FLn,FLg:TPointSeries;
                     Tim:TTimer);
  procedure BeginMeasuring();override;
  class function SecondValue:double;
  class procedure SecondValueChange(Value: double);
end;


TIVDependence=class (TDependence)
private
  fHookCycle:TSimpleEvent;
  fHookStep:TSimpleEvent;
  fHookSetVoltage:TSimpleEvent;
  CBForw,CBRev: TCheckBox;
  RevLine: TPointSeries;
  RevLg: TPointSeries;

  procedure Cycle(ItIsForwardInput: Boolean; Action: TSimpleEvent);
  procedure FullCycle(Action: TSimpleEvent);
  procedure BeginMeasuring();override;
  procedure EndMeasuring();override;
  function MeasurementNumberDetermine(): integer;override;
  procedure ActionMeasurement();override;
  procedure DataSave();override;
public
  RangeFor:TLimitShow;
  RangeRev:TLimitShowRev;
  property HookCycle:TSimpleEvent read fHookCycle write fHookCycle;
  property HookStep:TSimpleEvent read fHookStep write fHookStep;
  property HookSetVoltage:TSimpleEvent read fHookSetVoltage write fHookSetVoltage;
  Constructor Create(
                     CBF,CBR: TCheckBox;
                     PB:TProgressBar;
                     BS: TButton;
                     Res:PVector;
                     FLn,RLn,FLg,RLg:TPointSeries);
  procedure Measuring();
  procedure SetVoltage();
  class function ItIsForward:boolean;
  class procedure ItIsForwardChange(Value: boolean);
  class function IVMeasuringToStop:boolean;
  class procedure IVMeasuringToStopChange(Value: boolean);
  class procedure SecondMeasIsDoneChange(Value: boolean);
  class function VoltageInput:double;
  class procedure VoltageInputChange(Value: double);
  class function VoltageInputReal:double;
  class function VoltageStep:double;
  class procedure VoltageStepChange(Value: double);
  class function VoltageCorrection:double;
  class procedure VoltageCorrectionChange(Value: double);
  class function DelayTime:integer;
  class procedure DelayTimeChange(Value: integer);
end;



TFastIVDependence=class (TFastDependence)
private
  fHookCycle:TSimpleEvent;
  fHookStep:TSimpleEvent;
  fHookSetVoltage:TSimpleEvent;
  FR_VtoI_Used: boolean;
  fR_VtoI:double;

  fTreadToStop:TThread;
  fTreadToMeasuring:TThread;

  fBeginBranchNumber:word;

  CBForw,CBRev: TCheckBox;
  RevLine: TPointSeries;
  RevLg: TPointSeries;

  procedure SeriesClear();override;
  procedure EndMeasuring();override;
  procedure ActionMeasurement();override;
  procedure SetR_VtoI(const Value: double);
  procedure SetR_VtoI_Used(const Value: boolean);
public
  RangeFor:TLimitShow;
  RangeRev:TLimitShowRev;
  property HookCycle:TSimpleEvent read fHookCycle write fHookCycle;
  property HookStep:TSimpleEvent read fHookStep write fHookStep;
  property HookSetVoltage:TSimpleEvent read fHookSetVoltage write fHookSetVoltage;
  property R_VtoI:double read FR_VtoI write SetR_VtoI;
  property R_VtoI_Used:boolean read FR_VtoI_Used write SetR_VtoI_Used;
  Constructor Create(
                     CBF,CBR: TCheckBox;
                     BS: TButton;
                     Res:PVector;
                     FLn,RLn,FLg,RLg:TPointSeries);
  procedure SetVoltage();
  procedure BeginMeasuring();override;
  procedure Cycle(ItIsForwardInput: Boolean);
  procedure Measuring();
end;

TFastIVDependenceNew=class (TFastDependence)
  private
    FImax: double;
    FForwardBranchIsMeasured: boolean;
    FImin: double;
    FCurrentValueLimitEnable: boolean;
    FReverseBranchIsMeasured: boolean;
    RevLine: TPointSeries;
    RevLg: TPointSeries;

    fTreadToStop:TThread;
    fTreadToMeasuring:TThread;

    procedure SetImax(const Value: double);
    procedure SetImin(const Value: double);

   procedure SeriesClear();override;
 public
  property Imax:double read FImax write SetImax;
  property Imin:double read FImin write SetImin;
  property CurrentValueLimitEnable:boolean read FCurrentValueLimitEnable write FCurrentValueLimitEnable;
  property ForwardBranchIsMeasured:boolean read FForwardBranchIsMeasured write FForwardBranchIsMeasured;
  property ReverseBranchIsMeasured:boolean read FReverseBranchIsMeasured write FForwardBranchIsMeasured;
  Constructor Create(
                     BS: TButton;
                     Res:PVector;
                     FLn,RLn,FLg,RLg:TPointSeries);
  procedure BeginMeasuring();override;
  procedure Cycle(ItIsForwardInput: Boolean);
  procedure Measuring();
end;


TFastIVDependenceAction = class(TThread)
  private
    { Private declarations }
   fFastIV:TFastIVDependence;
  protected
    procedure Execute; override;
  public
   constructor Create(FastIV:TFastIVDependence);
  end;

TFastIVDependenceStop = class(TThread)
  private
    { Private declarations }
   fThreadIVAction:TThread;
   fFastIV:TFastIVDependence;
  protected
    procedure Execute; override;
  public
   constructor Create(FastIV:TFastIVDependence;
                      ThreadIVAction:TThread);
  end;


TFastIVDependenceActionNew = class(TThread)
  private
    { Private declarations }
   fFastIV:TFastIVDependenceNew;
  protected
    procedure Execute; override;
  public
   constructor Create(FastIV:TFastIVDependenceNew);
  end;

TFastIVDependenceStopNew = class(TThread)
  private
    { Private declarations }
   fThreadIVAction:TThread;
   fFastIV:TFastIVDependenceNew;
  protected
    procedure Execute; override;
  public
   constructor Create(FastIV:TFastIVDependenceNew;
                      ThreadIVAction:TThread);
  end;

TIVMeasurementResult=class(TSimpleFreeAndAiniObject)
  private
    FDeltaToApplied: double;
    FCurrentMeasured: double;
    FVoltageMeasured: double;
    FDeltaToExpected: double;
    FisLarge: boolean;
    FisLargeToApplied: boolean;
    FCurrentDiapazon: ShortInt;
    FCorrection: double;
    FisEmpty: boolean;
    procedure SetCurrentMeasured(const Value: double);
    procedure SetDeltaToExpected(const Value: double);
    procedure SetDeltaToApplied(const Value: double);
    procedure SetVoltageMeasured(const Value: double);
    procedure SetisLarge(const Value: boolean);
    procedure SetisLargeToApplied(const Value: boolean);
    function GetRpribor:double;
    procedure SetCurrentDiapazon(const Value: ShortInt);
    procedure SetCorrection(const Value: double);
    procedure SetisEmpty(const Value: boolean);
  public
  property VoltageMeasured:double read FVoltageMeasured write SetVoltageMeasured;
  property CurrentMeasured:double read FCurrentMeasured write SetCurrentMeasured;
  property DeltaToExpected:double read FDeltaToExpected write SetDeltaToExpected;
  property DeltaToApplied:double read FDeltaToApplied write SetDeltaToApplied;
  property isLarge:boolean read FisLarge write SetisLarge;
  property isLargeToApplied:boolean read FisLargeToApplied write SetisLargeToApplied;
  property CurrentDiapazon:ShortInt read FCurrentDiapazon write SetCurrentDiapazon;
  property Correction:double read FCorrection write SetCorrection;
  property Rpribor:double read GetRpribor;
  property isEmpty:boolean read FisEmpty write SetisEmpty;

  procedure FromVoltageMeasurement();
  procedure FromCurrentMeasurement();
  procedure CopyTo(AnotherIVMR:TIVMeasurementResult);
  procedure SwapTo(AnotherIVMR:TIVMeasurementResult);
//  Constructor Create();
end;

implementation

uses
  SysUtils, Forms, Windows, Math, DateUtils, Dialogs, OlegGraph, OlegFunction;

var
  fItIsForward:boolean;
  fIVMeasuringToStop:boolean;
  fSecondMeasIsDone:boolean;
  fVoltageInput:double;
  fVoltageInputReal:double;
  fVoltageStep:double;
  fVoltageCorrection:double;
  ftempV,ftempI,fSecondValue:double;
  fPointNumber:word;
  fDelayTime:integer;

{ TIVDependence }

procedure TIVDependence.ActionMeasurement;
begin
  repeat
    SetVoltage();
    fSecondMeasIsDone:=True;
    HookFirstMeas();
    if ftempV=ErResult then
      begin
       fIVMeasuringToStop:=True;
       Exit;
      end;
    if not(fSecondMeasIsDone)  then Continue;

    fSecondMeasIsDone:=True;
    HookSecondMeas();
    if ftempI=ErResult then
      begin
       fIVMeasuringToStop:=True;
       Exit;
      end;
  until (fSecondMeasIsDone);

  inherited ActionMeasurement()
end;

procedure TIVDependence.BeginMeasuring;
begin
  inherited BeginMeasuring;
  CBForw.Enabled:=False;
  CBRev.Enabled:=False;
  RevLine.Clear;
  RevLg.Clear;
end;

constructor TIVDependence.Create(
              CBF,CBR: TCheckBox;
              PB:TProgressBar;
              BS: TButton;
              Res:PVector;
              FLn,RLn,FLg,RLg:TPointSeries
                     );
begin
  inherited Create(PB,BS,Res,FLn, FLg);
 CBForw:=CBF;
 CBRev:=CBR;
 RevLine:=RLn;
 RevLg:=RLg;

 HookCycle:=TSimpleClass.EmptyProcedure;
 HookStep:=TSimpleClass.EmptyProcedure;
 HookSetVoltage:=TSimpleClass.EmptyProcedure;

end;

procedure TIVDependence.Cycle(ItIsForwardInput: Boolean; Action: TSimpleEvent);
 var Start,Finish:double;
     Condition:boolean;
begin
 fItIsForward:=ItIsForwardInput;
 fDelayTime:=0;
 fVoltageCorrection:=0;


 if fItIsForward then
   begin
     Start:=RangeFor.LowValue;
     Finish:=RangeFor.HighValue;
     Condition:=CBForw.Checked;
   end          else
   begin
     Start:=RangeRev.LowValue;;
     Finish:=RangeRev.HighValue;;
     Condition:=CBRev.Checked;
  end;

  HookCycle();

 if Condition then
  begin
   fVoltageInput:=Start;
   if not(fItIsForward)
      and(fVoltageInput=0)
      and(RangeFor.LowValue=0)
      and(CBForw.Checked) then
    begin
     HookStep();
     fVoltageInput:=fVoltageInput+fVoltageStep;
    end;

   repeat
     Application.ProcessMessages;
     if fIVMeasuringToStop then Exit;

     DuringMeasuring(Action);
     HookStep();
     fVoltageInput:=fVoltageInput+fVoltageStep;
   until fVoltageInput>Finish;
  end;
end;


procedure TIVDependence.DataSave;
begin
  Application.ProcessMessages;
  if fIVMeasuringToStop then Exit;
  HookDataSave();
  if ftempI=ErResult then Exit;

  Results.Add(ftempV, ftempI);
  if fItIsForward then
  begin
    ForwLine.AddXY(ftempV, ftempI);
    if abs(ftempI) > 1E-11 then
      ForwLg.AddXY(ftempV, abs(ftempI));
  end            else
  begin
    RevLine.AddXY(-ftempV, -ftempI);
    if abs(ftempI) > 1E-11 then
      RevLg.AddXY(-ftempV, abs(ftempI));
  end;
end;

class function TIVDependence.DelayTime: integer;
begin
 Result:=fDelayTime;
end;

class procedure TIVDependence.DelayTimeChange(Value: integer);
begin
  fDelayTime:=Value;
end;

procedure TIVDependence.EndMeasuring;
begin
  CBForw.Enabled := True;
  CBRev.Enabled := True;
  inherited EndMeasuring;
end;

class procedure TIVDependence.SecondMeasIsDoneChange(Value: boolean);
begin
 fSecondMeasIsDone:=Value;
end;

procedure TIVDependence.FullCycle(Action: TSimpleEvent);
begin
  Cycle(True,Action);
  Cycle(False,Action);
end;

class function TIVDependence.ItIsForward: boolean;
begin
 Result:=fItIsForward;
end;

class procedure TIVDependence.ItIsForwardChange(Value: boolean);
begin
 fItIsForward:=Value;
end;

class function TIVDependence.IVMeasuringToStop: boolean;
begin
 Result:=fIVMeasuringToStop;
end;

class procedure TIVDependence.IVMeasuringToStopChange(Value: boolean);
begin
 fIVMeasuringToStop:=Value;
end;

function TIVDependence.MeasurementNumberDetermine: integer;
begin
 fPointNumber:=0;
 FullCycle(TSimpleClass.EmptyProcedure);
 Result:=fPointNumber;
end;

procedure TIVDependence.Measuring;
begin
  BeginMeasuring();
  FullCycle(ActionMeasurement);
  EndMeasuring();
end;

procedure TIVDependence.SetVoltage;
begin
 if fItIsForward then fVoltageInputReal := (fVoltageInput+fVoltageCorrection)
                 else fVoltageInputReal := -(fVoltageInput+fVoltageCorrection);
 HookSetVoltage();
 sleep(fDelayTime);
end;

class function TIVDependence.VoltageCorrection: double;
begin
  Result:=fVoltageCorrection;
end;

class procedure TIVDependence.VoltageCorrectionChange(Value: double);
begin
 if Value<>ErResult then
     fVoltageCorrection:=Value;
end;

class function TIVDependence.VoltageInput: double;
begin
  Result:=fVoltageInput;
end;

class procedure TIVDependence.VoltageInputChange(Value: double);
begin
  fVoltageInput:=Value;
end;

class function TIVDependence.VoltageInputReal: double;
begin
  Result:=fVoltageInputReal;
end;

class function TIVDependence.VoltageStep: double;
begin
  Result:=fVoltageStep;
end;

class procedure TIVDependence.VoltageStepChange(Value: double);
begin
  fVoltageStep:=Value;
end;

{ TTimeDependence }


procedure TTimeDependenceTimer.ActionMeasurement;
begin
  inherited ActionMeasurement;
  if (FDuration>0)and(ftempV>FDuration) then SetEvent(EventToStopDependence);
end;

procedure TTimeDependenceTimer.BeginMeasuring;
begin
  inherited BeginMeasuring;
//  {в HookBeginMeasuring потрібно передати значення Interval та Duration}

  Timer.Interval:=round(Interval*1000);
  Timer.OnTimer:=TimerOnTime;
  Timer.Enabled:=True;
end;

constructor TTimeDependenceTimer.Create(PB: TProgressBar;
                                   BS: TButton;
                                   Res: PVector;
                                   FLn, FLg: TPointSeries;
                                   Tim:TTimer);
begin
 inherited Create(PB,BS,Res,FLn, FLg);

 Timer:=Tim;
 FInterval:=15;
 FDuration:=0;
end;

procedure TTimeDependenceTimer.EndMeasuring;
begin
 inherited EndMeasuring;
 Timer.Enabled:=False;
end;

function TTimeDependenceTimer.MeasurementNumberDetermine: integer;
begin
 if Duration>0 then Result:=Ceil(Duration/Interval)
               else Result:=10;
end;

procedure TTimeDependenceTimer.SetDuration(const Value: int64);
begin
  FDuration := abs(Value);
end;

procedure TTimeDependenceTimer.SetInterval(const Value: integer);
begin
  if Value>=1 then FInterval := Value
             else FInterval := 15;
end;

procedure TTimeDependenceTimer.TimerOnTime(Sender: TObject);
begin
   PeriodicMeasuring;
   Timer.Interval:=round(Interval*1000);
end;

{ TTimeDependence }

procedure TTimeDependence.ActionMeasurement;
begin
  HookFirstMeas();
  ftempV:=TimeFromBegin();
  HookSecondMeas();
  fSecondMeasurementTime:=TimeFromBegin();

  if BadResult() then
    begin
      SetEvent(EventToStopDependence);
      Exit;
    end;
  if fPointNumber>=ProgressBar.Max-1
    then ProgressBar.Max :=2*ProgressBar.Max;

  inherited ActionMeasurement;
end;

function TTimeDependence.BadResult: boolean;
begin
 Result:=(ftempI=ErResult);
end;

procedure TTimeDependence.BeginMeasuring;
begin
  inherited BeginMeasuring;
  ProgressBar.Max := MeasurementNumberDetermine();

  ResetEvent(EventToStopDependence);

  fTreadToStop:=TTimeDependenceTread.Create(self);

  fBeginTime:=Now();
  PeriodicMeasuring;
end;

function TTimeDependence.TimeFromBegin: single;
begin
 Result:=round(SecondSpan(Now(),fBeginTime)*10)/10;
end;

{ TDependence }

procedure TDependence.ActionMeasurement;
begin
//  DataSave();
  inherited ActionMeasurement();
  ProgressBar.Position := fPointNumber;
  MelodyShot();
end;


procedure TDependence.BeginMeasuring;
begin



  fIVMeasuringToStop:=False;
  ProgressBar.Max := MeasurementNumberDetermine();
  ProgressBar.Position := 0;
  FisActive:=True;
  inherited  BeginMeasuring();

end;

constructor TDependence.Create(PB: TProgressBar;
                               BS: TButton;
                               Res: PVector;
                               FLn, FLg: TPointSeries);
begin
 inherited Create(BS,Res, FLn, FLg);
 ProgressBar:=PB;

 FisActive:=False;
end;

procedure TDependence.DataSave;
begin
  Application.ProcessMessages;
  inherited DataSave();

  ForwLine.AddXY(ftempV, ftempI);
  if abs(ftempI) > 1E-11 then
     ForwLg.AddXY(ftempV, abs(ftempI));
end;

procedure TDependence.EndMeasuring;
begin
  inherited EndMeasuring();

  FisActive:=False;
  MelodyLong();
end;

function TDependence.MeasurementNumberDetermine: integer;
begin
 Result:=10;
end;

procedure TDependence.PeriodicMeasuring;
begin
  DuringMeasuring(ActionMeasurement);
end;

class function TFastDependence.PointNumber: word;
begin
   Result:=fPointNumber;
end;

class procedure TFastDependence.PointNumberChange(Value: word);
begin
 fPointNumber:=Value;
end;

class function TFastDependence.tempI: double;
begin
  Result:=ftempI;
end;

class procedure TFastDependence.tempIChange(Value: double);
begin
  ftempI:=Value;
end;

class function TFastDependence.tempV: double;
begin
  Result:=ftempV;
end;

class procedure TFastDependence.tempVChange(Value: double);
begin
  ftempV:=Value;
end;

{ TTimeDependenceTread }

constructor TTimeDependenceTread.Create(TimeDep: TTimeDependence);
begin
 inherited Create(True);    // Поток создаем в состоянии «Приостановлен»
  FreeOnTerminate := True;  // Поток освободит ресурсы при окончании работы
  fTimeDependence := TimeDep;
  Priority := tpNormal;
  Resume;
end;

procedure TTimeDependenceTread.Execute;
begin
  WaitForSingleObject(EventToStopDependence, INFINITE);
  fTimeDependence.EndMeasuring;
end;


{ TTimeTwoDependenceTimer }

function TTimeTwoDependenceTimer.BadResult: boolean;
begin
  Result:=(ftempI=ErResult)or(fSecondValue=ErResult);
end;

procedure TTimeTwoDependenceTimer.BeginMeasuring;
begin
  inherited BeginMeasuring;
  if isTwoValueOnTime then
      ForwLg.ParentChart.Axes.Left.Logarithmic:=False;
end;

constructor TTimeTwoDependenceTimer.Create(PB: TProgressBar; BS: TButton;
  Res: PVector; FLn, FLg: TPointSeries; Tim: TTimer);
begin
  inherited Create(PB,BS,Res,FLn, FLg, Tim);
  isTwoValueOnTime:=True;
end;

procedure TTimeTwoDependenceTimer.DataSave;
begin
  Application.ProcessMessages;
  HookDataSave();

  if isTwoValueOnTime then
   begin
    Results.Add(ftempV, ftempI);
    ForwLine.AddXY(ftempV, ftempI);
    ForwLg.AddXY(fSecondMeasurementTime, fSecondValue);
   end
                      else
   begin
    Results.Add(fSecondValue, ftempI);
    ForwLine.AddXY(fSecondValue, ftempI);
    if abs(ftempI) > 1E-11 then
      ForwLg.AddXY(fSecondValue, abs(ftempI));
   end
end;

class function TTimeTwoDependenceTimer.SecondValue: double;
begin
 Result:=fSecondValue;
end;

class procedure TTimeTwoDependenceTimer.SecondValueChange(Value: double);
begin
 fSecondValue:=Value;
end;

{ TIVMeasurementResult }

procedure TIVMeasurementResult.CopyTo(AnotherIVMR: TIVMeasurementResult);
begin
 AnotherIVMR.VoltageMeasured:=FVoltageMeasured;
 AnotherIVMR.CurrentMeasured:=FCurrentMeasured;
 AnotherIVMR.DeltaToExpected:=FDeltaToExpected;
 AnotherIVMR.DeltaToApplied:=FDeltaToApplied;
 AnotherIVMR.isLarge:=FisLarge;
 AnotherIVMR.isLargeToApplied:=FisLargeToApplied;
 AnotherIVMR.CurrentDiapazon:=FCurrentDiapazon;
 AnotherIVMR.Correction:=FCorrection;
 AnotherIVMR.isEmpty:=False;
end;

procedure TIVMeasurementResult.FromCurrentMeasurement;
begin
 FCurrentMeasured:=ftempI;
end;

procedure TIVMeasurementResult.FromVoltageMeasurement;
begin
 FVoltageMeasured:=ftempV;
 FCorrection:=fVoltageCorrection;
 DeltaToApplied:=FVoltageMeasured-TIVDependence.VoltageInputReal;
 isLargeToApplied:=abs(FVoltageMeasured)>abs(TIVDependence.VoltageInputReal);
 if TIVDependence.ItIsForward then
   begin
   DeltaToExpected:=FVoltageMeasured-TIVDependence.VoltageInput;
   isLarge:=(FVoltageMeasured>TIVDependence.VoltageInput);
   end
                              else
   begin
   DeltaToExpected:=-FVoltageMeasured-TIVDependence.VoltageInput;
   isLarge:=(FVoltageMeasured<-TIVDependence.VoltageInput);
   end;

end;

function TIVMeasurementResult.GetRpribor: double;
begin
 if abs(FCurrentMeasured)>1e-11
   then Result:=abs(fDeltaToApplied/FCurrentMeasured)
   else Result:=ErResult;
end;

procedure TIVMeasurementResult.SetCorrection(const Value: double);
begin
  FCorrection := Value;
end;

procedure TIVMeasurementResult.SetCurrentDiapazon(const Value: ShortInt);
begin
  FCurrentDiapazon := Value;
end;

procedure TIVMeasurementResult.SetCurrentMeasured(const Value: double);
begin
  FCurrentMeasured := Value;
end;

procedure TIVMeasurementResult.SetDeltaToExpected(const Value: double);
begin
  FDeltaToExpected := Value;
end;

procedure TIVMeasurementResult.SetDeltaToApplied(const Value: double);
begin
  FDeltaToApplied := Value;
end;

procedure TIVMeasurementResult.SetisEmpty(const Value: boolean);
begin
  FisEmpty := Value;
end;

procedure TIVMeasurementResult.SetisLarge(const Value: boolean);
begin
  FisLarge := Value;
end;

procedure TIVMeasurementResult.SetisLargeToApplied(const Value: boolean);
begin
  FisLargeToApplied := Value;
end;

procedure TIVMeasurementResult.SetVoltageMeasured(const Value: double);
begin
  FVoltageMeasured := Value;
end;

procedure TIVMeasurementResult.SwapTo(AnotherIVMR: TIVMeasurementResult);
 var tempIVMR:TIVMeasurementResult;
begin
 tempIVMR:=TIVMeasurementResult.Create;
 Self.CopyTo(tempIVMR);
 AnotherIVMR.CopyTo(Self);
 tempIVMR.CopyTo(AnotherIVMR);
 tempIVMR.Free;
end;

{ TFastDependence }

procedure TFastDependence.ActionMeasurement;
begin
  DataSave();
end;

procedure TFastDependence.BeginMeasuring;
begin
//  fIVMeasuringToStop:=False;
  DecimalSeparator:='.';
  fPointNumber:=0;
  SetLenVector(Results,fPointNumber);
  ButtonStop.Enabled:=True;
//-----------------
  SeriesClear();
//  -------------------------
//  FisActive:=True;

  HookBeginMeasuring();
end;

procedure TFastDependence.ButtonStopClick(Sender: TObject);
begin
  SetEvent(EventToStopDependence);
  fIVMeasuringToStop:=True;
end;

constructor TFastDependence.Create(BS: TButton;
                                   Res: PVector;
                                   FLn, FLg: TPointSeries);
begin
  inherited Create;
 ButtonStop:=BS;
 ButtonStop.OnClick:=ButtonStopClick;
 Results:=Res;
 ForwLine:=FLn;
 ForwLg:=FLg;

// FisActive:=False;
//
 HookBeginMeasuring:=TSimpleClass.EmptyProcedure;
 HookEndMeasuring:=TSimpleClass.EmptyProcedure;
 HookSecondMeas:=TSimpleClass.EmptyProcedure;
 HookFirstMeas:=TSimpleClass.EmptyProcedure;
 HookDataSave:=TSimpleClass.EmptyProcedure;
 HookAction:=TSimpleClass.EmptyProcedure;
end;

procedure TFastDependence.DataSave;
begin
  HookDataSave();

  Results.Add(ftempV, ftempI);
end;

procedure TFastDependence.DuringMeasuring(Action: TSimpleEvent);
begin
   Application.ProcessMessages;
   inc(fPointNumber);
   HookAction();
   Action;
end;

procedure TFastDependence.EndMeasuring;
begin
  ButtonStop.Enabled := False;
  HookEndMeasuring();
//  FisActive:=False;
  MelodyShot();
end;

procedure TFastDependence.SeriesClear;
begin
  ForwLine.Clear;
  ForwLg.Clear;
  ForwLg.ParentChart.Axes.Left.Logarithmic:=True;
  ForwLg.ParentChart.Axes.Left.LogarithmicBase:=10;
end;

{ TFastIVDependence }

procedure TFastIVDependence.ActionMeasurement;
begin
    SetVoltage();
    HookFirstMeas();
    if ftempV=ErResult then
      begin
       SetEvent(EventToStopDependence);
       sleep(0);
       Exit;
      end;
    HookSecondMeas();
    if ftempI=ErResult then
      begin
       SetEvent(EventToStopDependence);
       sleep(0);
      end;


    if FR_VtoI_Used then
      ftempI:=ftempI/fR_VtoI;

  inherited ActionMeasurement()

end;


procedure TFastIVDependence.BeginMeasuring;
begin
  inherited  BeginMeasuring;
  ResetEvent(EventToStopDependence);


  fTreadToMeasuring:=TFastIVDependenceAction.Create(self);
  fTreadToStop:=TFastIVDependenceStop.Create(self,fTreadToMeasuring);
  fTreadToMeasuring.Resume;

end;

constructor TFastIVDependence.Create(CBF, CBR: TCheckBox; BS: TButton;Res: PVector; FLn,
  RLn, FLg, RLg: TPointSeries);
begin
  inherited Create(BS,Res,FLn, FLg);
 CBForw:=CBF;
 CBRev:=CBR;
 RevLine:=RLn;
 RevLg:=RLg;

 HookCycle:=TSimpleClass.EmptyProcedure;
 HookStep:=TSimpleClass.EmptyProcedure;
 HookSetVoltage:=TSimpleClass.EmptyProcedure;

 fR_VtoI:=1;
 FR_VtoI_Used:=True;

end;

procedure TFastIVDependence.Cycle(ItIsForwardInput: Boolean);
  var Start,Finish:double;
     Condition:boolean;
begin
 fItIsForward:=ItIsForwardInput;
 fBeginBranchNumber:=fPointNumber;

 if fItIsForward then
   begin
     Start:=RangeFor.LowValue;
     Finish:=RangeFor.HighValue;
     Condition:=CBForw.Checked;
   end          else
   begin
     Start:=RangeRev.LowValue;;
     Finish:=RangeRev.HighValue;;
     Condition:=CBRev.Checked;
  end;

  HookCycle();

 if Condition then
  begin
   fVoltageInput:=Start;


   repeat
     if not(fItIsForward)
      and(fVoltageInput=0)
      and(RangeFor.LowValue=0)
      and(CBForw.Checked)
        then
        else  DuringMeasuring(ActionMeasurement);
     HookStep();
     fVoltageInput:=fVoltageInput+fVoltageStep;
   until fVoltageInput>Finish;
  end;

end;

procedure TFastIVDependence.EndMeasuring;
 var i:integer;
begin
  if CBRev.Checked then
    for i:=0 to High(Results^.X) do
      begin
       if Results^.X[i]<0 then
            begin
            RevLine.AddXY(-Results^.X[i], -Results^.Y[i]);
            if abs(Results^.Y[i]) > 1E-11 then
             RevLg.AddXY(-Results^.X[i], abs(Results^.Y[i]));
            end
                          else
            begin
             ForwLine.AddXY(Results^.X[i], Results^.Y[i]);
             if abs(Results^.Y[i]) > 1E-11 then
               ForwLg.AddXY(Results^.X[i], abs(Results^.Y[i]));
            end;

      end
                   else
    for i:=0 to High(Results^.X) do
      begin
       ForwLine.AddXY(Results^.X[i], Results^.Y[i]);
       if abs(Results^.Y[i]) > 1E-11 then
         ForwLg.AddXY(Results^.X[i], abs(Results^.Y[i]));
      end;

 inherited EndMeasuring;
end;

procedure TFastIVDependence.Measuring;
begin
   BeginMeasuring();
//  FullCycle(ActionMeasurement);
//  EndMeasuring();
end;

procedure TFastIVDependence.SeriesClear;
begin
  inherited SeriesClear();
  RevLine.Clear;
  RevLg.Clear;
end;

procedure TFastIVDependence.SetR_VtoI(const Value: double);
begin
  if Value>0 then FR_VtoI := Value
             else FR_VtoI := 1;
end;

procedure TFastIVDependence.SetR_VtoI_Used(const Value: boolean);
begin
  FR_VtoI_Used := Value;
end;

procedure TFastIVDependence.SetVoltage;

begin
 if fItIsForward then fVoltageInputReal := fVoltageInput
                 else fVoltageInputReal := -fVoltageInput;


 if (FR_VtoI_Used) and((fPointNumber-fBeginBranchNumber)>2)
  then
   begin
   fVoltageCorrection:=abs(X_Y0(Results^.X[fPointNumber-3],
                            Results^.Y[fPointNumber-3],
                            Results^.X[fPointNumber-2],
                            Results^.Y[fPointNumber-2],
                            fVoltageInputReal))*fR_VtoI;
   if fItIsForward then fVoltageInputReal := (fVoltageInput+fVoltageCorrection)
                   else fVoltageInputReal := -(fVoltageInput+fVoltageCorrection);
   end;

 HookSetVoltage();
end;


{ TFastIVDependenceAction }

constructor TFastIVDependenceAction.Create(FastIV: TFastIVDependence);
begin
 inherited Create(True);    // Поток создаем в состоянии «Приостановлен»
//  FreeOnTerminate := True;  // Поток освободит ресурсы при окончании работы
   FreeOnTerminate := False;
  fFastIV := FastIV;
  Priority := tpNormal;
//  Resume;
end;

procedure TFastIVDependenceAction.Execute;
begin
  fFastIV.Cycle(True);
  fFastIV.Cycle(False);
  SetEvent(EventToStopDependence);
end;

{ TFastIVDependenceStop }

constructor TFastIVDependenceStop.Create(FastIV: TFastIVDependence;
  ThreadIVAction: TThread);
begin
  inherited Create(True);    // Поток создаем в состоянии «Приостановлен»
  FreeOnTerminate := True;  // Поток освободит ресурсы при окончании работы
  fFastIV := FastIV;
  fThreadIVAction:=ThreadIVAction;
  Priority := tpNormal;
  Resume;
end;

procedure TFastIVDependenceStop.Execute;
begin
  WaitForSingleObject(EventToStopDependence, INFINITE);

  fThreadIVAction.Terminate;
  fThreadIVAction.WaitFor;  //????
  fThreadIVAction.Free;

  fFastIV.EndMeasuring;
end;

{ TFastIVDependenceNew }

procedure TFastIVDependenceNew.BeginMeasuring;
begin
  inherited  BeginMeasuring;
  ResetEvent(EventToStopDependence);


  fTreadToMeasuring:=TFastIVDependenceActionNew.Create(self);
  fTreadToStop:=TFastIVDependenceStopNew.Create(self,fTreadToMeasuring);
  fTreadToMeasuring.Resume;
end;

constructor TFastIVDependenceNew.Create(BS: TButton;
                                        Res: PVector;
                                        FLn, RLn, FLg, RLg: TPointSeries);
begin
 inherited Create(BS,Res,FLn, FLg);
 RevLine:=RLn;
 RevLg:=RLg;

// HookCycle:=TSimpleClass.EmptyProcedure;
// HookStep:=TSimpleClass.EmptyProcedure;
// HookSetVoltage:=TSimpleClass.EmptyProcedure;
//
// fR_VtoI:=1;
// FR_VtoI_Used:=True;
end;

procedure TFastIVDependenceNew.Cycle(ItIsForwardInput: Boolean);
begin
 sleep(5000);
 HelpForMe(floattostr(Imin)+booltostr(ItIsForwardInput));

end;

procedure TFastIVDependenceNew.Measuring;
begin
   BeginMeasuring();
//  FullCycle(ActionMeasurement);
//  EndMeasuring();
end;

procedure TFastIVDependenceNew.SeriesClear;
begin
  inherited SeriesClear();
  RevLine.Clear;
  RevLg.Clear;
  RevLg.ParentChart.Axes.Left.Logarithmic:=True;
  RevLg.ParentChart.Axes.Left.LogarithmicBase:=10;
end;

procedure TFastIVDependenceNew.SetImax(const Value: double);
begin
  FImax := abs(Value);
end;

procedure TFastIVDependenceNew.SetImin(const Value: double);
begin
  FImin := abs(Value);
end;


{ TFastIVDependenceActionNew }

constructor TFastIVDependenceActionNew.Create(FastIV: TFastIVDependenceNew);
begin
 inherited Create(True);    // Поток создаем в состоянии «Приостановлен»
//  FreeOnTerminate := True;  // Поток освободит ресурсы при окончании работы
   FreeOnTerminate := False;
  fFastIV := FastIV;
  Priority := tpNormal;
//  Resume;
end;

procedure TFastIVDependenceActionNew.Execute;
begin
  fFastIV.Cycle(True);
  fFastIV.Cycle(False);
  SetEvent(EventToStopDependence);
end;

{ TFastIVDependenceStopNew }

constructor TFastIVDependenceStopNew.Create(FastIV: TFastIVDependenceNew;
  ThreadIVAction: TThread);
begin
  inherited Create(True);    // Поток создаем в состоянии «Приостановлен»
  FreeOnTerminate := True;  // Поток освободит ресурсы при окончании работы
  fFastIV := FastIV;
  fThreadIVAction:=ThreadIVAction;
  Priority := tpNormal;
  Resume;
end;

procedure TFastIVDependenceStopNew.Execute;
begin
  WaitForSingleObject(EventToStopDependence, INFINITE);

  HelpForMe('StopNew');

  fThreadIVAction.Terminate;
  fThreadIVAction.WaitFor;  //????
  fThreadIVAction.Free;
  HelpForMe('StopNewGGGGG');

  fFastIV.EndMeasuring;
end;

initialization
  EventToStopDependence := CreateEvent(nil,
                                 True, // тип сброса TRUE - ручной
                                 True, // начальное состояние TRUE - сигнальное
                                 nil);

finalization

  SetEvent(EventToStopDependence);
  CloseHandle(EventToStopDependence);
end.
