unit Dependence;

interface

uses
  ArduinoDevice, StdCtrls, ComCtrls, OlegType, Series, ShowTypes,
  ExtCtrls, Classes, OlegTypePart2, MDevice, HighResolutionTimer;

var EventToStopDependence:THandle;

const
   VoltageStepDefault=0.01;
   DragonBackOvershootHeight=1.05;
   MaxCurrentMeasuringAttemp=3;
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
//  class procedure PointNumberChange(Value: word);
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

TIVParameters=class
 public
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
  procedure ButtonStopClick(Sender: TObject);override;
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
end;

TThreadTermin= class(TThread)
 private
  function getIsTerminated:boolean;
 public
  property IsTerminated:boolean read getIsTerminated;
end;

TFastIVDependence=class (TFastDependence)
  private
    FImax: double;
    FImin: double;
    FCurrentValueLimitEnable: boolean;
    fForwardBranch:boolean;
    fAbsVoltageValue:double;
    fVoltageFactor:double;
    fDiodOrientationVoltageFactor:integer;
    fVoltageMeasured,fCurrentMeasured:double;
    fDragonBackTime:double;
    fItIsBranchBegining:boolean;
    fItIsLightIV:boolean;
    fSingleMeasurement:boolean;
    fVoc:double;
    fIsc:double;

    RevLine: TPointSeries;
    RevLg: TPointSeries;

    fTreadToStop:TThread;
    fTreadToMeasuring:TThreadTermin;


    procedure SetImax(const Value: double);
    procedure SetImin(const Value: double);
    procedure SetDragonBackTime(const Value: double);

   procedure SeriesClear();override;
   procedure BeginMeasuring();override;
   function StepFromVector(Vector:Pvector):double;
   function VoltageStep:double;
   procedure VoltageChange;
   procedure ActionMeasurement();override;
   procedure VoltageFactorDetermination;
   procedure DiodOrientationVoltageFactorDetermination;
   procedure VoltageMeasuring();
   procedure CurrentMeasuring();
   function ValueMeasuring(MD:TMeasuringDevice):double;
   function CurrentGrowth():boolean;
   procedure DataSave();override;
   procedure EndMeasuring();override;
   procedure VocIscDetermine;
    procedure PointSeriesFilling;
 public
  RangeFor:TLimitShow;
  RangeRev:TLimitShowRev;
  ForwardDelV:PVector;
  ReverseDelV:PVector;
  CBForw,CBRev: TCheckBox;
  SettingDevice:TSettingDevice;
  RGDiodOrientation: TRadioGroup;
  Voltage_MD,Current_MD:TMeasuringDevice;
  PrefixToFileName:string;

  property Imax:double read FImax write SetImax;
  property Imin:double read FImin write SetImin;
  property CurrentValueLimitEnable:boolean read FCurrentValueLimitEnable write FCurrentValueLimitEnable;
  property ForwardBranch:boolean read fForwardBranch;
  property DragonBackTime:double read fDragonBackTime write SetDragonBackTime;
  property SingleMeasurement:boolean read fSingleMeasurement write fSingleMeasurement;
  property Voc:double read FVoc;
  property Isc:double read FIsc;

  Constructor Create(
                     BS: TButton;
                     Res:PVector;
                     FLn,RLn,FLg,RLg:TPointSeries);
  procedure Cycle(ItIsForwardInput: Boolean);
  procedure Measuring(SingleMeasurement:boolean=true;FilePrefix:string='');
  procedure SetVoltage();
  function DatFileNameToSave:string;
end;



TFastIVDependenceAction = class(TThreadTermin)
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
  SysUtils, Forms, Windows, Math, DateUtils, Dialogs, OlegGraph, OlegFunction, 
  OlegMath;

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
  fIVMeasuringToStop:=False;
  CBForw.Enabled:=False;
  CBRev.Enabled:=False;
  RevLine.Clear;
  RevLg.Clear;
end;

procedure TIVDependence.ButtonStopClick(Sender: TObject);
begin
 fIVMeasuringToStop:=True;
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

procedure TIVDependence.Cycle(ItIsForwardInput: Boolean;
                                 Action: TSimpleEvent);
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

//class function TIVDependence.DelayTime: integer;
//begin
// Result:=fDelayTime;
//end;

//class procedure TIVDependence.DelayTimeChange(Value: integer);
//begin
//  fDelayTime:=Value;
//end;

procedure TIVDependence.EndMeasuring;
begin
  CBForw.Enabled := True;
  CBRev.Enabled := True;
  inherited EndMeasuring;
end;

//class procedure TIVDependence.SecondMeasIsDoneChange(Value: boolean);
//begin
// fSecondMeasIsDone:=Value;
//end;

procedure TIVDependence.FullCycle(Action: TSimpleEvent);
begin
  Cycle(True,Action);
  Cycle(False,Action);
end;

//class function TIVDependence.ItIsForward: boolean;
//begin
// Result:=fItIsForward;
//end;
//
//class procedure TIVDependence.ItIsForwardChange(Value: boolean);
//begin
// fItIsForward:=Value;
//end;
//
//class function TIVDependence.IVMeasuringToStop: boolean;
//begin
// Result:=fIVMeasuringToStop;
//end;
//
//class procedure TIVDependence.IVMeasuringToStopChange(Value: boolean);
//begin
// fIVMeasuringToStop:=Value;
//end;

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

//class function TIVDependence.VoltageCorrection: double;
//begin
//  Result:=fVoltageCorrection;
//end;
//
//class procedure TIVDependence.VoltageCorrectionChange(Value: double);
//begin
// if Value<>ErResult then
//     fVoltageCorrection:=Value;
//end;

//class function TIVDependence.VoltageInput: double;
//begin
//  Result:=fVoltageInput;
//end;
//
//class procedure TIVDependence.VoltageInputChange(Value: double);
//begin
//  fVoltageInput:=Value;
//end;
//
//class function TIVDependence.VoltageInputReal: double;
//begin
//  Result:=fVoltageInputReal;
//end;
//
//class function TIVDependence.VoltageStep: double;
//begin
//  Result:=fVoltageStep;
//end;

//class procedure TIVDependence.VoltageStepChange(Value: double);
//begin
//  fVoltageStep:=Value;
//end;

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



//  fIVMeasuringToStop:=False;
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

//class procedure TFastDependence.PointNumberChange(Value: word);
//begin
// fPointNumber:=Value;
//end;

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
 DeltaToApplied:=FVoltageMeasured-TIVParameters.VoltageInputReal;
 isLargeToApplied:=abs(FVoltageMeasured)>abs(TIVParameters.VoltageInputReal);
 if TIVParameters.ItIsForward then
   begin
   DeltaToExpected:=FVoltageMeasured-TIVParameters.VoltageInput;
   isLarge:=(FVoltageMeasured>TIVParameters.VoltageInput);
   end
                              else
   begin
   DeltaToExpected:=-FVoltageMeasured-TIVParameters.VoltageInput;
   isLarge:=(FVoltageMeasured<-TIVParameters.VoltageInput);
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

{ TFastIVDependenceNew }

procedure TFastIVDependence.ActionMeasurement;
begin
//    secondmeter.Start();

    SetVoltage();

    VoltageMeasuring();

    CurrentMeasuring();


    DataSave();



    if fTreadToMeasuring.IsTerminated then Exit;


//    secondmeter.Finish();
//    helpforme('b'+floattostr(fAbsVoltageValue)+
//     '_'+floattostr(SecondMeter.Interval));
end;

procedure TFastIVDependence.BeginMeasuring;
begin
  inherited  BeginMeasuring;
  ResetEvent(EventToStopDependence);
  DiodOrientationVoltageFactorDetermination();
  fItIsLightIV:=False;

  fTreadToMeasuring:=TFastIVDependenceAction.Create(self);
  fTreadToStop:=TFastIVDependenceStop.Create(self,fTreadToMeasuring);
  fTreadToMeasuring.Resume;
end;


constructor TFastIVDependence.Create(BS: TButton;
                                        Res: PVector;
                                        FLn, RLn, FLg, RLg: TPointSeries);
begin
 inherited Create(BS,Res,FLn, FLg);
 RevLine:=RLn;
 RevLg:=RLg;
 PrefixToFileName:='';
 fVoc:=0;
 fIsc:=0;

end;

function TFastIVDependence.CurrentGrowth: boolean;
begin
 if fForwardBranch then
     Result:=fCurrentMeasured>Results^.Y[High(Results^.Y)]
                               else
     Result:=fCurrentMeasured<Results^.Y[High(Results^.Y)]
end;

procedure TFastIVDependence.CurrentMeasuring;
 var
  AtempNumber:byte;
begin
  AtempNumber := 0;
  repeat
   fCurrentMeasured:= ValueMeasuring(Current_MD);
   if fCurrentMeasured=ErResult then Exit;
   if (High(Results^.Y)<0) then Break;
   if fItIsBranchBegining then Break;
   if CurrentGrowth() then Break;
   inc(AtempNumber);
  until (AtempNumber>MaxCurrentMeasuringAttemp);

  if (FCurrentValueLimitEnable and (abs(fCurrentMeasured)>=Imax)) then
    fAbsVoltageValue:=50;
end;

procedure TFastIVDependence.Cycle(ItIsForwardInput: Boolean);
  var Finish:double;
     Condition:boolean;
begin
 fForwardBranch:=ItIsForwardInput;

 if fForwardBranch then
   begin
     fAbsVoltageValue:=RangeFor.LowValue;
     Finish:=RangeFor.HighValue;
     Condition:=CBForw.Checked;
//     Condition:=FForwardBranchIsMeasured;
   end          else
   begin
     fAbsVoltageValue:=RangeRev.LowValue;;
     Finish:=RangeRev.HighValue;;
     Condition:=CBRev.Checked;
//     Condition:=FReverseBranchIsMeasured;
  end;

 fItIsBranchBegining:=true;

 if Condition then
  begin
   if (not(fForwardBranch))
      and(fAbsVoltageValue=0)
      and(RangeFor.LowValue=0)
      and(CBForw.Checked) then VoltageChange();
//      and(FForwardBranchIsMeasured) then VoltageChange();
   VoltageFactorDetermination();

   while (fAbsVoltageValue<=Finish) do
     begin
      DuringMeasuring(ActionMeasurement);
      if fTreadToMeasuring.IsTerminated then Exit;
      VoltageChange();
     end;
  end;

end;

procedure TFastIVDependence.DataSave;
begin
 if fTreadToMeasuring.IsTerminated then Exit;
 if FCurrentValueLimitEnable and (abs(fCurrentMeasured)<Imin)
//      then  fCurrentMeasured:=ErResult;
      then  Exit;

 if (fItIsBranchBegining) and (fForwardBranch) then
      fItIsLightIV:=(fCurrentMeasured<-1e-5);

  if fItIsBranchBegining then fItIsBranchBegining:=False;

  Results.Add(fVoltageMeasured, fCurrentMeasured);

end;

function TFastIVDependence.DatFileNameToSave: string;
begin
  Result:=NextDATFileName(LastDATFileName(PrefixToFileName));
  if Result='1.dat' then Result:=PrefixToFileName+Result;
end;

procedure TFastIVDependence.PointSeriesFilling;
var
  i: Integer;
begin
  if fSingleMeasurement then
  begin
    if CBRev.Checked then
      for i := 0 to High(Results^.X) do
      begin
        if Results^.X[i] < 0 then
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
      for i := 0 to High(Results^.X) do
      begin
        ForwLine.AddXY(Results^.X[i], Results^.Y[i]);
        if abs(Results^.Y[i]) > 1E-11 then
          ForwLg.AddXY(Results^.X[i], abs(Results^.Y[i]));
      end;
  end;
end;

procedure TFastIVDependence.DiodOrientationVoltageFactorDetermination;
begin
  if RGDiodOrientation.ItemIndex = 1 then
        fDiodOrientationVoltageFactor := -1
                                     else
        fDiodOrientationVoltageFactor := 1;
end;

procedure TFastIVDependence.EndMeasuring;
begin
  PointSeriesFilling;
  ButtonStop.Enabled := False;
  SettingDevice.ActiveInterface.Reset();
//  sleep(1000);
  VocIscDetermine();
  HookEndMeasuring();

 secondmeter.Finish();
    helpforme('IVtime_'+floattostr(SecondMeter.Interval));

end;

procedure TFastIVDependence.Measuring(SingleMeasurement:boolean=true;
                           FilePrefix:string='');
begin

   secondmeter.Start();

  fSingleMeasurement:=SingleMeasurement;
  PrefixToFileName:=FilePrefix;
//  helpforme('1b'+inttostr(millisecond));
//  helpforme('2b'+inttostr(millisecond));

  BeginMeasuring();
end;

procedure TFastIVDependence.SeriesClear;
begin
  if fSingleMeasurement then
   begin
    inherited SeriesClear();
    RevLine.Clear;
    RevLg.Clear;
    RevLg.ParentChart.Axes.Left.Logarithmic:=True;
    RevLg.ParentChart.Axes.Left.LogarithmicBase:=10;
   end;
end;

procedure TFastIVDependence.SetDragonBackTime(const Value: double);
begin
  fDragonBackTime := abs(Value);
end;

procedure TFastIVDependence.SetImax(const Value: double);
begin
  FImax := abs(Value);
end;

procedure TFastIVDependence.SetImin(const Value: double);
begin
  FImin := abs(Value);
end;


procedure TFastIVDependence.SetVoltage;
begin
  SettingDevice.SetValue(DragonBackOvershootHeight*fVoltageFactor * fAbsVoltageValue);
  HRDelay(fDragonBackTime);
  SettingDevice.SetValue(fVoltageFactor * fAbsVoltageValue);
  HRDelay(fDragonBackTime);
end;

procedure TFastIVDependence.VoltageFactorDetermination;
begin
  if fForwardBranch then fVoltageFactor := 1
                    else fVoltageFactor := -1;
  fVoltageFactor:=fVoltageFactor*fDiodOrientationVoltageFactor;
end;


procedure TFastIVDependence.VoltageMeasuring;
begin
  fVoltageMeasured :=ValueMeasuring(Voltage_MD);
end;

function TFastIVDependence.StepFromVector(Vector: Pvector): double;
 var i:integer;
begin
  Result := VoltageStepDefault;
  for I := 0 to High(Vector^.X) do
    if abs(fAbsVoltageValue) < Vector^.X[i] then
    begin
      Result := Vector^.Y[i];
      Break;
    end;
end;

function TFastIVDependence.ValueMeasuring(MD: TMeasuringDevice): double;
begin
  if fTreadToMeasuring.IsTerminated then
   begin
    Result:=ErResult;
    Exit;
   end;
  try
//  Result := MD.GetMeasurementResult();
  Result := MD.GetResult();
//  Result:=fAbsVoltageValue;
  except
   Result:=ErResult;
  end;
  if Result=ErResult then
      begin
       SetEvent(EventToStopDependence);
       sleep(0);
       Exit;
      end;
  Result :=Result * fDiodOrientationVoltageFactor;
end;

procedure TFastIVDependence.VocIscDetermine;
begin
  Results.Sorting;
  Results.DeleteDuplicate;

 if fItIsLightIV and CBForw.Checked then
   begin
     if Results^.MaxY>0 then fVoc:=Results^.Xvalue(0)
                        else FVoc:=0;
     if Results^.MinX<=0 then fIsc:=Results^.Yvalue(0)
                         else fIsc:=Y_X0(Results^.X[0],
                                         Results^.Y[0],
                                         Results^.X[1],
                                         Results^.Y[1],
                                         0);
    if fVoc=ErResult then fVoc:=0;
    if fIsc=ErResult then fIsc:=0;
   end                              else
   begin
     fVoc:=0;
     fIsc:=0;
   end;
 
end;

procedure TFastIVDependence.VoltageChange;
begin
 fAbsVoltageValue:=fAbsVoltageValue+VoltageStep;
end;

function TFastIVDependence.VoltageStep: double;
begin
  if fForwardBranch then Result:=StepFromVector(ForwardDelV)
                    else Result:=StepFromVector(ReverseDelV)
end;

{ TFastIVDependenceActionNew }

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
  if Terminated then Exit;
  fFastIV.Cycle(False);
  SetEvent(EventToStopDependence);
end;
//
{ TFastIVDependenceStopNew }

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

{ TIVParameters }

class function TIVParameters.DelayTime: integer;
begin
 Result:=fDelayTime;
end;

class procedure TIVParameters.DelayTimeChange(Value: integer);
begin
  fDelayTime:=Value;
end;

class function TIVParameters.ItIsForward: boolean;
begin
  Result:=fItIsForward;
end;

class procedure TIVParameters.ItIsForwardChange(Value: boolean);
begin
  fItIsForward:=Value;
end;

class function TIVParameters.IVMeasuringToStop: boolean;
begin
  Result:=fIVMeasuringToStop;
end;

class procedure TIVParameters.IVMeasuringToStopChange(Value: boolean);
begin
  fIVMeasuringToStop:=Value;
end;

class procedure TIVParameters.SecondMeasIsDoneChange(Value: boolean);
begin
  fSecondMeasIsDone:=Value;
end;

class function TIVParameters.VoltageCorrection: double;
begin
  Result:=fVoltageCorrection;
end;

class procedure TIVParameters.VoltageCorrectionChange(Value: double);
begin
 if Value<>ErResult then
     fVoltageCorrection:=Value;
end;

class function TIVParameters.VoltageInput: double;
begin
   Result:=fVoltageInput;
end;

class procedure TIVParameters.VoltageInputChange(Value: double);
begin
   fVoltageInput:=Value;
end;

class function TIVParameters.VoltageInputReal: double;
begin
   Result:=fVoltageInputReal;
end;

class function TIVParameters.VoltageStep: double;
begin
   Result:=fVoltageStep;
end;

class procedure TIVParameters.VoltageStepChange(Value: double);
begin
  fVoltageStep:=Value;
end;

{ TThreadTermin }

function TThreadTermin.getIsTerminated: boolean;
begin
 Result:=Terminated;
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
