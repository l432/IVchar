unit Dependence;

interface

uses
  SPIdevice, StdCtrls, ComCtrls, OlegType, Series, ShowTypes,
  ExtCtrls, Classes;

var EventToStopDependence:THandle;

type

TDependence=class
private
  fHookBeginMeasuring: TSimpleEvent;
  fHookEndMeasuring: TSimpleEvent;
  fHookSecondMeas:TSimpleEvent;
  fHookFirstMeas:TSimpleEvent;
  fHookDataSave:TSimpleEvent;
  fHookAction:TSimpleEvent;
  ProgressBar: TProgressBar;
  ButtonStop: TButton;
  Results:PVector;
  ForwLine: TPointSeries;
  ForwLg: TPointSeries;
  FisActive: boolean;
  procedure ButtonStopClick(Sender: TObject);virtual;
  procedure BeginMeasuring();virtual;
  procedure EndMeasuring();virtual;
  procedure DuringMeasuring(Action: TSimpleEvent);
  function MeasurementNumberDetermine(): integer;virtual;
  procedure ActionMeasurement();virtual;
  procedure DataSave();virtual;
//  procedure AEmpty;

 public
  property isActive:boolean read FisActive;
  property HookBeginMeasuring:TSimpleEvent read FHookBeginMeasuring write FHookBeginMeasuring;
  property HookEndMeasuring:TSimpleEvent read fHookEndMeasuring write fHookEndMeasuring;
  property HookAction:TSimpleEvent read fHookAction write fHookAction;
  property HookDataSave:TSimpleEvent read fHookDataSave write fHookDataSave;
  property HookSecondMeas:TSimpleEvent read fHookSecondMeas write fHookSecondMeas;
  property HookFirstMeas:TSimpleEvent read fHookFirstMeas write fHookFirstMeas;
  Constructor Create(PB:TProgressBar;
                     BS: TButton;
                     Res:PVector;
                     FLn,FLg:TPointSeries);
  class function PointNumber:word;
  class procedure PointNumberChange(Value: word);
  class function tempV:double;
  class procedure tempVChange(Value: double);
  class function tempI:double;
  class procedure tempIChange(Value: double);
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
//  procedure EndMeasuring();override;
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
//  class procedure VoltageInputRealChange(Value: double);
  class function VoltageStep:double;
  class procedure VoltageStepChange(Value: double);
  class function VoltageCorrection:double;
  class procedure VoltageCorrectionChange(Value: double);
  class function DelayTime:integer;
  class procedure DelayTimeChange(Value: integer);
end;


TIVMeasurementResult=class
  private
    FDeltaToApplied: double;
    FCurrentMeasured: double;
    FVoltageMeasured: double;
    FDeltaToExpected: double;
    FisLarge: boolean;
    FisLargeToApplied: boolean;
    procedure SetCurrentMeasured(const Value: double);
    procedure SetDeltaToExpected(const Value: double);
    procedure SetDeltaToApplied(const Value: double);
    procedure SetVoltageMeasured(const Value: double);
    procedure SetisLarge(const Value: boolean);
    procedure SetisLargeToApplied(const Value: boolean);
    function GetRpribor:double;
  public
  property VoltageMeasured:double read FVoltageMeasured write SetVoltageMeasured;
  property CurrentMeasured:double read FCurrentMeasured write SetCurrentMeasured;
  property DeltaToExpected:double read FDeltaToExpected write SetDeltaToExpected;
  property DeltaToApplied:double read FDeltaToApplied write SetDeltaToApplied;
  property isLarge:boolean read FisLarge write SetisLarge;
  property isLargeToApplied:boolean read FisLargeToApplied write SetisLargeToApplied;
  property Rpribor:double read GetRpribor;

  procedure FromVoltageMeasurement();
  procedure FromCurrentMeasurement();
  procedure CopyTo(AnotherIVMR:TIVMeasurementResult);
end;

implementation

uses
  SysUtils, Forms, Windows, Math, DateUtils;

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

// HookCycle:=AEmpty;
// HookStep:=AEmpty;
// HookSetVoltage:=AEmpty;
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
// FullCycle(AEmpty);
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

//class procedure TIVDependence.VoltageInputRealChange(Value: double);
//begin
//  fVoltageInputReal:=Value;
//end;

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
end;

{ TTimeDependence }

procedure TTimeDependence.ActionMeasurement;
begin
  HookFirstMeas();
//  ftempV:=round(SecondSpan(Now(),fBeginTime)*10)/10;
  ftempV:=TimeFromBegin();
  HookSecondMeas();
  fSecondMeasurementTime:=TimeFromBegin();

//  if (ftempV=ErResult)or(ftempI=ErResult) then
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
  DataSave();
  ProgressBar.Position := fPointNumber;
  MelodyShot();
end;

//procedure TDependence.AEmpty;
//begin
//
//end;

procedure TDependence.BeginMeasuring;
begin
  fIVMeasuringToStop:=False;
  ProgressBar.Max := MeasurementNumberDetermine();
  DecimalSeparator:='.';

  ProgressBar.Position := 0;
  ButtonStop.Enabled:=True;

  fPointNumber:=0;
  ProgressBar.Position := fPointNumber;
  SetLenVector(Results,fPointNumber);

  ForwLine.Clear;
  ForwLg.Clear;
  ForwLg.ParentChart.Axes.Left.Logarithmic:=True;
  ForwLg.ParentChart.Axes.Left.LogarithmicBase:=10;

  FisActive:=True;

  HookBeginMeasuring();
end;

procedure TDependence.ButtonStopClick(Sender: TObject);
begin
  SetEvent(EventToStopDependence);
  fIVMeasuringToStop:=True;
end;

constructor TDependence.Create(PB: TProgressBar;
                               BS: TButton;
                               Res: PVector;
                               FLn, FLg: TPointSeries);
begin
 inherited Create;
 ProgressBar:=PB;
 ButtonStop:=BS;
 ButtonStop.OnClick:=ButtonStopClick;
 Results:=Res;
 ForwLine:=FLn;
 ForwLg:=FLg;

 FisActive:=False;

 HookBeginMeasuring:=TSimpleClass.EmptyProcedure;
 HookEndMeasuring:=TSimpleClass.EmptyProcedure;
 HookSecondMeas:=TSimpleClass.EmptyProcedure;
 HookFirstMeas:=TSimpleClass.EmptyProcedure;
 HookDataSave:=TSimpleClass.EmptyProcedure;
 HookAction:=TSimpleClass.EmptyProcedure;

// HookBeginMeasuring:=AEmpty;
// HookEndMeasuring:=AEmpty;
// HookSecondMeas:=AEmpty;
// HookFirstMeas:=AEmpty;
// HookDataSave:=AEmpty;
// HookAction:=AEmpty;
end;

procedure TDependence.DataSave;
begin
  Application.ProcessMessages;
  HookDataSave();

  Results.Add(ftempV, ftempI);
  ForwLine.AddXY(ftempV, ftempI);
  if abs(ftempI) > 1E-11 then
     ForwLg.AddXY(ftempV, abs(ftempI));
end;

procedure TDependence.DuringMeasuring(Action: TSimpleEvent);
begin
   Application.ProcessMessages;
   inc(fPointNumber);
   HookAction();
   Action;
end;

procedure TDependence.EndMeasuring;
begin
  ButtonStop.Enabled := False;
  HookEndMeasuring();
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

class function TDependence.PointNumber: word;
begin
   Result:=fPointNumber;
end;

class procedure TDependence.PointNumberChange(Value: word);
begin
 fPointNumber:=Value;
end;

class function TDependence.tempI: double;
begin
  Result:=ftempI;
end;

class procedure TDependence.tempIChange(Value: double);
begin
  ftempI:=Value;
end;

class function TDependence.tempV: double;
begin
  Result:=ftempV;
end;

class procedure TDependence.tempVChange(Value: double);
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

//procedure TTimeTwoDependenceTimer.EndMeasuring;
//begin
//  ForwLg.ParentChart.Axes.Left.Logarithmic:=True;
//  ForwLg.ParentChart.Axes.Left.LogarithmicBase:=10;
//  inherited EndMeasuring;
//end;

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
end;

procedure TIVMeasurementResult.FromCurrentMeasurement;
begin
 FCurrentMeasured:=ftempI;
end;

procedure TIVMeasurementResult.FromVoltageMeasurement;
begin
 FVoltageMeasured:=ftempV;
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

initialization
  EventToStopDependence := CreateEvent(nil,
                                 True, // тип сброса TRUE - ручной
                                 True, // начальное состояние TRUE - сигнальное
                                 nil);

finalization

  SetEvent(EventToStopDependence);
  CloseHandle(EventToStopDependence);

end.
