unit Dependence;

interface

uses
  SPIdevice, StdCtrls, ComCtrls, OlegType, Series, Measurement, ShowTypes, 
  ExtCtrls, Classes;

var EventToStopDependence:THandle;

type

TDependence=class
private
  fHookBeginMeasuring: TSimpleEvent;
  fHookEndMeasuring: TSimpleEvent;
//  fHookCycle:TSimpleEvent;
//  fHookStep:TSimpleEvent;
//  fHookSetVoltage:TSimpleEvent;
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
  procedure AEmpty;

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
//  Timer:TTimer;
//  FInterval: integer;
//  FDuration: int64;
  fTreadToStop:TThread;
  fBeginTime:TDateTime;
//  procedure ButtonStopClick(Sender: TObject);override;
//  procedure SetDuration(const Value: int64);
//  procedure SetInterval(const Value: integer);
//  procedure TimerOnTime(Sender: TObject);
  procedure ActionMeasurement();override;
//    function MeasurementNumberDetermine(): integer;override;
  public
//  EventStop: THandle;
//  property Interval:integer read FInterval write SetInterval;
//  property Duration:int64 read FDuration write SetDuration;
//  Constructor Create(PB:TProgressBar;
//                     BS: TButton;
//                     Res:PVector;
//                     FLn,FLg:TPointSeries);
//                     Tim:TTimer);
  procedure BeginMeasuring();override;
//  procedure EndMeasuring();override;
//  Procedure Free;
end;


TTimeDependenceTimer=class(TTimeDependence)
//TTimeDependenceTimer=class(TDependence)
private
  Timer:TTimer;
  FInterval: integer;
  FDuration: int64;
//  fTreadToStop:TThread;
//  fBeginTime:TDateTime;
//  procedure ButtonStopClick(Sender: TObject);override;
  procedure SetDuration(const Value: int64);
  procedure SetInterval(const Value: integer);
  procedure TimerOnTime(Sender: TObject);
  procedure ActionMeasurement();override;
  function MeasurementNumberDetermine(): integer;override;
 public
//  EventStop: THandle;
  property Interval:integer read FInterval write SetInterval;
  property Duration:int64 read FDuration write SetDuration;
  Constructor Create(PB:TProgressBar;
                     BS: TButton;
                     Res:PVector;
                     FLn,FLg:TPointSeries;
                     Tim:TTimer);
  procedure BeginMeasuring();override;
  procedure EndMeasuring();override;
//  Procedure Free;
end;

type
  TTimeDependenceTread = class(TThread)
  private
    { Private declarations }
   fTimeDependence:TTimeDependence;
//   fEventStop:THandle;
  protected
    procedure Execute; override;
  public
//    constructor Create(TimeDep:TTimeDependence;EvStop: THandle);
    constructor Create(TimeDep:TTimeDependence);
  end;


TIVDependence=class (TDependence)
private
//  fHookBeginMeasuring: TSimpleEvent;
//  fHookEndMeasuring: TSimpleEvent;
  fHookCycle:TSimpleEvent;
  fHookStep:TSimpleEvent;
  fHookSetVoltage:TSimpleEvent;
//  fHookSecondMeas:TSimpleEvent;
//  fHookFirstMeas:TSimpleEvent;
//  fHookDataSave:TSimpleEvent;
//  fHookAction:TSimpleEvent;
  CBForw,CBRev: TCheckBox;
//  ProgressBar: TProgressBar;
//  ButtonStop: TButton;
//  Results:PVector;
//  ForwLine: TPointSeries;
  RevLine: TPointSeries;
//  ForwLg: TPointSeries;
  RevLg: TPointSeries;

  procedure Cycle(ItIsForwardInput: Boolean; Action: TSimpleEvent);
  procedure FullCycle(Action: TSimpleEvent);
  procedure BeginMeasuring();override;
  procedure EndMeasuring();override;
  function MeasurementNumberDetermine(): integer;override;
//  procedure ButtonStopClick(Sender: TObject);
  procedure ActionMeasurement();override;
  procedure DataSave();override;
//  procedure AEmpty;
public
//  SetDevice:TSettingDevice;
  RangeFor:TLimitShow;
  RangeRev:TLimitShowRev;
//  ButtonSave: TButton;
//  property HookBeginMeasuring:TSimpleEvent read FHookBeginMeasuring write FHookBeginMeasuring;
//  property HookEndMeasuring:TSimpleEvent read fHookEndMeasuring write fHookEndMeasuring;
  property HookCycle:TSimpleEvent read fHookCycle write fHookCycle;
  property HookStep:TSimpleEvent read fHookStep write fHookStep;
  property HookSetVoltage:TSimpleEvent read fHookSetVoltage write fHookSetVoltage;
//  property HookSecondMeas:TSimpleEvent read fHookSecondMeas write fHookSecondMeas;
//  property HookFirstMeas:TSimpleEvent read fHookFirstMeas write fHookFirstMeas;
//  property HookDataSave:TSimpleEvent read fHookDataSave write fHookDataSave;
//  property HookAction:TSimpleEvent read fHookAction write fHookAction;
  Constructor Create({RF:TLimitShow;
                     RR:TLimitShowRev;}
                     CBF,CBR: TCheckBox;
                     PB:TProgressBar;
                     BS{,BSave}: TButton;
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
  class procedure VoltageInputRealChange(Value: double);
  class function VoltageStep:double;
  class procedure VoltageStepChange(Value: double);
  class function VoltageCorrection:double;
  class procedure VoltageCorrectionChange(Value: double);
//  class function tempV:double;
//  class procedure tempVChange(Value: double);
//  class function tempI:double;
//  class procedure tempIChange(Value: double);
//  class function PointNumber:word;
//  class procedure PointNumberChange(Value: word);
  class function DelayTime:integer;
  class procedure DelayTimeChange(Value: integer);
end;


implementation

uses
  SysUtils, Forms, Graphics, Dialogs, Windows, Math, DateUtils;

var
  fItIsForward:boolean;
  fIVMeasuringToStop:boolean;
  fSecondMeasIsDone:boolean;
  fVoltageInput:double;
  fVoltageInputReal:double;
  fVoltageStep:double;
  fVoltageCorrection:double;
  ftempV,ftempI:double;
  fPointNumber:word;
  fDelayTime:integer;

{ TIVDependence }

//procedure TIVDependence.AEmpty;
//begin
//
//end;

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
//  DataSave();
//  ProgressBar.Position := fPointNumber;
//
//  MelodyShot();
end;

procedure TIVDependence.BeginMeasuring;
begin
  inherited BeginMeasuring;

//  fIVMeasuringToStop:=False;
//  ProgressBar.Max := MeasurementNumberDetermine();
//  DecimalSeparator:='.';

//  ProgressBar.Position := 0;
//  ButtonStop.Enabled:=True;
  CBForw.Enabled:=False;
  CBRev.Enabled:=False;

//  fPointNumber:=0;
//  ProgressBar.Position := fPointNumber;
//  SetLenVector(Results,fPointNumber);

  ForwLine.Clear;
//  RevLine.Clear;
  ForwLg.Clear;
//  RevLg.Clear;


//  HookBeginMeasuring();
end;

//procedure TIVDependence.ButtonStopClick(Sender: TObject);
//begin
// fIVMeasuringToStop:=True;
//end;

constructor TIVDependence.Create({RF: TLimitShow;
              RR:TLimitShowRev;}
              CBF,CBR: TCheckBox;
              PB:TProgressBar;
              BS{,BSave}: TButton;
              Res:PVector;
              FLn,RLn,FLg,RLg:TPointSeries
                     );
begin
  inherited Create(PB,BS,Res,FLn, FLg);
// inherited Create;
 CBForw:=CBF;
 CBRev:=CBR;
// ProgressBar:=PB;
// ButtonStop:=BS;
// ButtonStop.OnClick:=ButtonStopClick;
// Results:=Res;
// ForwLine:=FLn;
 RevLine:=RLn;
// ForwLg:=FLg;
 RevLg:=RLg;

// HookBeginMeasuring:=AEmpty;
// HookEndMeasuring:=AEmpty;
 HookCycle:=AEmpty;
 HookStep:=AEmpty;
 HookSetVoltage:=AEmpty;
// HookSecondMeas:=AEmpty;
// HookFirstMeas:=AEmpty;
// HookDataSave:=AEmpty;
// HookAction:=AEmpty;
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
//     Start:=0.01;
     Finish:=RangeFor.HighValue;
     Condition:=CBForw.Checked;
   end          else
   begin
     Start:=RangeRev.LowValue;;
     Finish:=RangeRev.HighValue;;
     Condition:=CBRev.Checked;
  end;


   //**********************************
// if not(CBRev.Checked) then
// begin
//   if fItIsForward then
//    Start:=0
//                   else
//   begin
//     Condition:=true;
//     Start:=0.05;
//     Finish:=0.1;
//   end;
// end;


   //************************************



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
//     inc(fPointNumber);
//     HookAction();
//     Action;
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
//  ButtonStop.Enabled := False;
  CBForw.Enabled := True;
  CBRev.Enabled := True;

//  HookEndMeasuring();
//  MelodyLong();
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
 FullCycle(AEmpty);

// FullCycle(ActionEmpty);
 Result:=fPointNumber;
// showmessage('number'+inttostr(Result));
end;

procedure TIVDependence.Measuring;
begin
  BeginMeasuring();
  FullCycle(ActionMeasurement);
  EndMeasuring();
end;


//class function TIVDependence.PointNumber: word;
//begin
//   Result:=fPointNumber;
//end;
//
//class procedure TIVDependence.PointNumberChange(Value: word);
//begin
// fPointNumber:=Value;
//end;

procedure TIVDependence.SetVoltage;
begin
// showmessage(floattostr(fVoltageCorrection));
 if fItIsForward then fVoltageInputReal := (fVoltageInput+fVoltageCorrection)
                 else fVoltageInputReal := -(fVoltageInput+fVoltageCorrection);
 HookSetVoltage();
 sleep(fDelayTime);
end;

//class function TIVDependence.tempI: double;
//begin
//  Result:=ftempI;
//end;
//
//class procedure TIVDependence.tempIChange(Value: double);
//begin
//  ftempI:=Value;
//end;
//
//class function TIVDependence.tempV: double;
//begin
//  Result:=ftempV;
//end;
//
//class procedure TIVDependence.tempVChange(Value: double);
//begin
//  ftempV:=Value;
//end;

class function TIVDependence.VoltageCorrection: double;
begin
  Result:=fVoltageCorrection;
end;

class procedure TIVDependence.VoltageCorrectionChange(Value: double);
begin
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

class procedure TIVDependence.VoltageInputRealChange(Value: double);
begin
  fVoltageInputReal:=Value;
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
//  HookFirstMeas();
//  ftempV:=round(SecondSpan(Now(),fBeginTime)*10)/10;
//  HookSecondMeas();
//
//  if (ftempV=ErResult)or(ftempI=ErResult) then
//    begin
//      SetEvent(EventStop);
//      Exit;
//    end;
//  if fPointNumber>=ProgressBar.Max-1
//    then ProgressBar.Max :=2*ProgressBar.Max;

  inherited ActionMeasurement;

//  if (FDuration>0)and(ftempV>FDuration) then SetEvent(EventStop);
  if (FDuration>0)and(ftempV>FDuration) then SetEvent(EventToStopDependence);


end;

procedure TTimeDependenceTimer.BeginMeasuring;
begin
  inherited BeginMeasuring;
//  {в HookBeginMeasuring потрібно передати значення Interval nf Duration}
//  ProgressBar.Max := MeasurementNumberDetermine();
//
//
//  ResetEvent(EventStop);
//  fTreadToStop:=TTimeDependenceTread.Create(self,EventStop);
//
////   Application.ProcessMessages;
////   inc(fPointNumber);
////   HookAction();
////   ActionMeasurement;
//  fBeginTime:=Now();
//  DuringMeasuring(ActionMeasurement);

  Timer.Interval:=round(Interval*1000);
  Timer.OnTimer:=TimerOnTime;
  Timer.Enabled:=True;
end;

//procedure TTimeDependenceTimer.ButtonStopClick(Sender: TObject);
//begin
// SetEvent(EventStop);
//end;

constructor TTimeDependenceTimer.Create(PB: TProgressBar;
                                   BS: TButton;
                                   Res: PVector;
                                   FLn, FLg: TPointSeries;
                                   Tim:TTimer);
begin
 inherited Create(PB,BS,Res,FLn, FLg);
// EventStop := CreateEvent(nil,
//                          True, // тип сброса TRUE - ручной
//                          True, // начальное состояние TRUE - сигнальное
//                          nil);
 Timer:=Tim;
 FInterval:=15;
 FDuration:=0;
end;

procedure TTimeDependenceTimer.EndMeasuring;
begin
 inherited EndMeasuring;
 Timer.Enabled:=False;
end;

//procedure TTimeDependenceTimer.Free;
//begin
// SetEvent(EventStop);
// CloseHandle(EventStop);
//end;

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
//   Application.ProcessMessages;
//   inc(fPointNumber);
//   ActionMeasurement;

// DuringMeasuring(ActionMeasurement);
   PeriodicMeasuring;
end;

{ TTimeDependence }

procedure TTimeDependence.ActionMeasurement;
begin
  HookFirstMeas();
  ftempV:=round(SecondSpan(Now(),fBeginTime)*10)/10;
  HookSecondMeas();

  if (ftempV=ErResult)or(ftempI=ErResult) then
    begin
//      SetEvent(EventStop);
      SetEvent(EventToStopDependence);

      Exit;
    end;
  if fPointNumber>=ProgressBar.Max-1
    then ProgressBar.Max :=2*ProgressBar.Max;

  inherited ActionMeasurement;
//  SetEvent(EventStop);
end;

procedure TTimeDependence.BeginMeasuring;
begin
  inherited BeginMeasuring;
  {в HookBeginMeasuring потрібно передати значення Interval nf Duration}
  ProgressBar.Max := MeasurementNumberDetermine();


//  ResetEvent(EventStop);
  ResetEvent(EventToStopDependence);

//  fTreadToStop:=TTimeDependenceTread.Create(self,EventStop);
//  fTreadToStop:=TTimeDependenceTread.Create(self,EventToStopDependence);
  fTreadToStop:=TTimeDependenceTread.Create(self);


  fBeginTime:=Now();
//  DuringMeasuring(ActionMeasurement);
  PeriodicMeasuring;
end;

//procedure TTimeDependence.ButtonStopClick(Sender: TObject);
//begin
//// showmessage('kk');
//// SetEvent(EventStop);
// SetEvent(EventToStopDependence);
//
//
////  showmessage('kk2');
////   SetEvent(EventStop);
//end;

//constructor TTimeDependence.Create(PB: TProgressBar; BS: TButton; Res: PVector;
//  FLn, FLg: TPointSeries);
//begin
// inherited Create(PB,BS,Res,FLn, FLg);
//// EventStop := CreateEvent(nil,
////                          True, // тип сброса TRUE - ручной
////                          True, // начальное состояние TRUE - сигнальное
////                          nil);
//end;

//procedure TTimeDependence.EndMeasuring;
//begin
//  inherited;
//
//end;

//procedure TTimeDependence.Free;
//begin
//// SetEvent(EventStop);
//// CloseHandle(EventStop);
//// inherited Free;
//end;


{ TDependence }

procedure TDependence.ActionMeasurement;
begin
  DataSave();
  ProgressBar.Position := fPointNumber;
  MelodyShot();
end;

procedure TDependence.AEmpty;
begin

end;

procedure TDependence.BeginMeasuring;
begin
//  HookBeginMeasuring();


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

 HookBeginMeasuring:=AEmpty;
 HookEndMeasuring:=AEmpty;
// HookCycle:=AEmpty;
// HookStep:=AEmpty;
// HookSetVoltage:=AEmpty;
 HookSecondMeas:=AEmpty;
 HookFirstMeas:=AEmpty;
 HookDataSave:=AEmpty;
 HookAction:=AEmpty;
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

//constructor TTimeDependenceTread.Create(TimeDep: TTimeDependence;
//             EvStop: THandle);
constructor TTimeDependenceTread.Create(TimeDep: TTimeDependence);
begin
 inherited Create(True);    // Поток создаем в состоянии «Приостановлен»
  FreeOnTerminate := True;  // Поток освободит ресурсы при окончании работы
  fTimeDependence := TimeDep;
//  fEventStop:=EvStop;
  Priority := tpNormal;
  Resume;
end;

procedure TTimeDependenceTread.Execute;
begin
//  showmessage('start');
//  WaitForSingleObject(fEventStop, INFINITE);
  WaitForSingleObject(EventToStopDependence, INFINITE);
//  showmessage('finish');

  fTimeDependence.EndMeasuring;
end;


initialization
//  ComPortAlloved:= True;
  EventToStopDependence := CreateEvent(nil,
                                 True, // тип сброса TRUE - ручной
                                 True, // начальное состояние TRUE - сигнальное
                                 nil);

finalization

  SetEvent(EventToStopDependence);
  CloseHandle(EventToStopDependence);

end.
