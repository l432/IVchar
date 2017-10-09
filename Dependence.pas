unit Dependence;

interface

uses
  SPIdevice, StdCtrls, ComCtrls, OlegType, Series, Measurement, ShowTypes, 
  ExtCtrls, Classes;

type

TDependence=class
private
  fHookBeginMeasuring: TSimpleEvent;
//  fHookEndMeasuring: TSimpleEvent;
//  fHookCycle:TSimpleEvent;
//  fHookStep:TSimpleEvent;
//  fHookSetVoltage:TSimpleEvent;
//  fHookSecondMeas:TSimpleEvent;
//  fHookFirstMeas:TSimpleEvent;
//  fHookDataSave:TSimpleEvent;
//  fHookAction:TSimpleEvent;
  ProgressBar: TProgressBar;
  ButtonStop: TButton;
  Results:PVector;
  ForwLine: TPointSeries;
  ForwLg: TPointSeries;
  procedure ButtonStopClick(Sender: TObject);virtual;
  procedure BeginMeasuring();virtual;
  function MeasurementNumberDetermine(): integer;virtual;
  procedure AEmpty;
 public
  property HookBeginMeasuring:TSimpleEvent read FHookBeginMeasuring write FHookBeginMeasuring;
  Constructor Create(PB:TProgressBar;
                     BS: TButton;
                     Res:PVector;
                     FLn,FLg:TPointSeries);
end;



TTimeDependence=class(TDependence)
private
  Timer:TTimer;
  FInterval: integer;
  FDuration: int64;
  fTreadToStop:TThread;
  procedure ButtonStopClick(Sender: TObject);override;
  procedure SetDuration(const Value: int64);
  procedure SetInterval(const Value: integer);
  procedure TimerOnTime(Sender: TObject);

  function MeasurementNumberDetermine(): integer;override;
 public
  EventStop: THandle;
  property Interval:integer read FInterval write SetInterval;
  property Duration:int64 read FDuration write SetDuration;
  Constructor Create(PB:TProgressBar;
                     BS: TButton;
                     Res:PVector;
                     FLn,FLg:TPointSeries;
                     Tim:TTimer);
  procedure BeginMeasuring();override;
  procedure EndMeasuring();
  Procedure Free;
end;

type
  TTimeDependenceTread = class(TThread)
  private
    { Private declarations }
   fTimeDependence:TTimeDependence;
   fEventStop:THandle;
  protected
    procedure Execute; override;
  public
    constructor Create(TimeDep:TTimeDependence;EvStop: THandle);
  end;


TIVDependence=class (TDependence)
private
//  fHookBeginMeasuring: TSimpleEvent;
  fHookEndMeasuring: TSimpleEvent;
  fHookCycle:TSimpleEvent;
  fHookStep:TSimpleEvent;
  fHookSetVoltage:TSimpleEvent;
  fHookSecondMeas:TSimpleEvent;
  fHookFirstMeas:TSimpleEvent;
  fHookDataSave:TSimpleEvent;
  fHookAction:TSimpleEvent;
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
  procedure EndMeasuring();
  function MeasurementNumberDetermine(): integer;override;
//  procedure ButtonStopClick(Sender: TObject);
  procedure ActionMeasurement();
  procedure DataSave();
//  procedure AEmpty;
public
//  SetDevice:TSettingDevice;
  RangeFor:TLimitShow;
  RangeRev:TLimitShowRev;
//  ButtonSave: TButton;
//  property HookBeginMeasuring:TSimpleEvent read FHookBeginMeasuring write FHookBeginMeasuring;
  property HookEndMeasuring:TSimpleEvent read fHookEndMeasuring write fHookEndMeasuring;
  property HookCycle:TSimpleEvent read fHookCycle write fHookCycle;
  property HookStep:TSimpleEvent read fHookStep write fHookStep;
  property HookSetVoltage:TSimpleEvent read fHookSetVoltage write fHookSetVoltage;
  property HookSecondMeas:TSimpleEvent read fHookSecondMeas write fHookSecondMeas;
  property HookFirstMeas:TSimpleEvent read fHookFirstMeas write fHookFirstMeas;
  property HookDataSave:TSimpleEvent read fHookDataSave write fHookDataSave;
  property HookAction:TSimpleEvent read fHookAction write fHookAction;
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
  class function tempV:double;
  class procedure tempVChange(Value: double);
  class function tempI:double;
  class procedure tempIChange(Value: double);
  class function PointNumber:word;
  class procedure PointNumberChange(Value: word);
  class function DelayTime:integer;
  class procedure DelayTimeChange(Value: integer);
end;


implementation

uses
  SysUtils, Forms, Graphics, Dialogs, Windows, Math;

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

  DataSave();
  ProgressBar.Position := fPointNumber;

  MelodyShot();
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

 HookBeginMeasuring:=AEmpty;
 HookEndMeasuring:=AEmpty;
 HookCycle:=AEmpty;
 HookStep:=AEmpty;
 HookSetVoltage:=AEmpty;
 HookSecondMeas:=AEmpty;
 HookFirstMeas:=AEmpty;
 HookDataSave:=AEmpty;
 HookAction:=AEmpty;
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
     inc(fPointNumber);
     HookAction();
     Action;
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
//  SetDevice.Reset;
  ButtonStop.Enabled := False;
  CBForw.Enabled := True;
  CBRev.Enabled := True;
//  if High(Results^.X)>0 then
//   begin
//   ButtonSave.Enabled := True;
//   ButtonSave.Font.Style:=ButtonSave.Font.Style-[fsStrikeOut];
////   Results.Sorting;
////   Results.DeleteDuplicate;
//   end;
  HookEndMeasuring();
  MelodyLong();
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


class function TIVDependence.PointNumber: word;
begin
   Result:=fPointNumber;
end;

class procedure TIVDependence.PointNumberChange(Value: word);
begin
 fPointNumber:=Value;
end;

procedure TIVDependence.SetVoltage;
begin
// showmessage(floattostr(fVoltageCorrection));
 if fItIsForward then fVoltageInputReal := (fVoltageInput+fVoltageCorrection)
                 else fVoltageInputReal := -(fVoltageInput+fVoltageCorrection);
 HookSetVoltage();
 sleep(fDelayTime);
end;

class function TIVDependence.tempI: double;
begin
  Result:=ftempI;
end;

class procedure TIVDependence.tempIChange(Value: double);
begin
  ftempI:=Value;
end;

class function TIVDependence.tempV: double;
begin
  Result:=ftempV;
end;

class procedure TIVDependence.tempVChange(Value: double);
begin
  ftempV:=Value;
end;

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


procedure TTimeDependence.BeginMeasuring;
begin
  inherited BeginMeasuring;
  {в HookBeginMeasuring потрібно передати значення Interval nf Duration}
  ProgressBar.Max := MeasurementNumberDetermine();

  ResetEvent(EventStop);
  fTreadToStop:=TTimeDependenceTread.Create(self,EventStop);

  Timer.Interval:=Interval;
  Timer.OnTimer:=TimerOnTime;
  Timer.Enabled:=True;
end;

procedure TTimeDependence.ButtonStopClick(Sender: TObject);
begin
 SetEvent(EventStop);
end;

constructor TTimeDependence.Create(PB: TProgressBar;
                                   BS: TButton;
                                   Res: PVector;
                                   FLn, FLg: TPointSeries;
                                   Tim:TTimer);
begin
 inherited Create(PB,BS,Res,FLn, FLg);
 Timer:=Tim;
 EventStop := CreateEvent(nil,
                          True, // тип сброса TRUE - ручной
                          True, // начальное состояние TRUE - сигнальное
                          nil);
 FInterval:=15;
 FDuration:=0;
end;

procedure TTimeDependence.EndMeasuring;
begin

end;

procedure TTimeDependence.Free;
begin
 SetEvent(EventStop);
 CloseHandle(EventStop);
end;

function TTimeDependence.MeasurementNumberDetermine: integer;
begin
 if Duration>0 then Result:=Ceil(Duration/Interval)
               else Result:=10;
end;

procedure TTimeDependence.SetDuration(const Value: int64);
begin
  FDuration := abs(Value);
end;

procedure TTimeDependence.SetInterval(const Value: integer);
begin
  if Value>1 then FInterval := Value
             else FInterval := 15;
end;

procedure TTimeDependence.TimerOnTime(Sender: TObject);
begin

end;

{ TDependence }

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


  HookBeginMeasuring();

end;

procedure TDependence.ButtonStopClick(Sender: TObject);
begin
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

 HookBeginMeasuring:=AEmpty;
// HookEndMeasuring:=AEmpty;
// HookCycle:=AEmpty;
// HookStep:=AEmpty;
// HookSetVoltage:=AEmpty;
// HookSecondMeas:=AEmpty;
// HookFirstMeas:=AEmpty;
// HookDataSave:=AEmpty;
// HookAction:=AEmpty;
end;

function TDependence.MeasurementNumberDetermine: integer;
begin
 Result:=10;
end;

{ TTimeDependenceTread }

constructor TTimeDependenceTread.Create(TimeDep: TTimeDependence;
  EvStop: THandle);
begin
 inherited Create(True);    // Поток создаем в состоянии «Приостановлен»
  FreeOnTerminate := True;  // Поток освободит ресурсы при окончании работы
  fTimeDependence := TimeDep;
  fEventStop:=EvStop;
  Self.Priority := tpNormal;
  Resume;
end;

procedure TTimeDependenceTread.Execute;
begin
  WaitForSingleObject(fEventStop, INFINITE);
  fTimeDependence.EndMeasuring;
end;

end.
