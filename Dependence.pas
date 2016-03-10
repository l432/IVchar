unit Dependence;

interface

uses
  SPIdevice, StdCtrls, ComCtrls, OlegType, Series, Measurement, ShowTypes;

type
TDependenceMeasuring=class
private
  fHookBeginMeasuring: TSimpleEvent;
  fHookEndMeasuring: TSimpleEvent;
  fHookCycle:TSimpleEvent;
  fHookStep:TSimpleEvent;
  fHookSetVoltage:TSimpleEvent;
  fHookSecondMeas:TSimpleEvent;
  fHookFirstMeas:TSimpleEvent;
  fHookDataSave:TSimpleEvent;
  CBForw,CBRev: TCheckBox;
  ProgressBar: TProgressBar;
  ButtonStop: TButton;
  Results:PVector;
  ForwLine: TPointSeries;
  RevLine: TPointSeries;
  ForwLg: TPointSeries;
  RevLg: TPointSeries;

  procedure Cycle(ItIsForwardInput: Boolean; Action: TSimpleEvent);
  procedure FullCycle(Action: TSimpleEvent);
  procedure BeginMeasuring();
  procedure EndMeasuring();
  function MeasurementNumberDetermine(): integer;
  procedure ButtonStopClick(Sender: TObject);
  procedure ActionMeasurement();
  procedure DataSave();
  procedure AEmpty;
public
//  SetDevice:TSettingDevice;
  RangeFor:TLimitShow;
  RangeRev:TLimitShowRev;
//  ButtonSave: TButton;
  property HookBeginMeasuring:TSimpleEvent read FHookBeginMeasuring write FHookBeginMeasuring;
  property HookEndMeasuring:TSimpleEvent read fHookEndMeasuring write fHookEndMeasuring;
  property HookCycle:TSimpleEvent read fHookCycle write fHookCycle;
  property HookStep:TSimpleEvent read fHookStep write fHookStep;
  property HookSetVoltage:TSimpleEvent read fHookSetVoltage write fHookSetVoltage;
  property HookSecondMeas:TSimpleEvent read fHookSecondMeas write fHookSecondMeas;
  property HookFirstMeas:TSimpleEvent read fHookFirstMeas write fHookFirstMeas;
  property HookDataSave:TSimpleEvent read fHookDataSave write fHookDataSave;
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
  SysUtils, Forms, Graphics, Dialogs;

var
  fItIsForward:boolean;
  fIVMeasuringToStop:boolean;
  fSecondMeasIsDone:boolean;
  fVoltageInput:double;
  fVoltageInputReal:double;
  fVoltageStep:double;
  ftempV,ftempI:double;
  fPointNumber:word;
  fDelayTime:integer;

{ TDependenceMeasuring }

procedure TDependenceMeasuring.AEmpty;
begin

end;

procedure TDependenceMeasuring.ActionMeasurement;
begin
 SetVoltage();

 repeat
   HookSecondMeas();
   if ftempI=ErResult then
    begin
     fIVMeasuringToStop:=True;
     Exit;
    end;

   HookFirstMeas();
   if ftempV=ErResult then
    begin
     fIVMeasuringToStop:=True;
     Exit;
    end;
 until (fSecondMeasIsDone);

  DataSave();

  //  if NumberOfTemperatureMeasuring=PointNumber then
//    Temperature:=Temperature_MD.GetMeasurementResult(VoltageInput);
  ProgressBar.Position := fPointNumber;
//
//  if ItIsBegining then ItIsBegining:=not(ItIsBegining);

  MelodyShot();
end;

procedure TDependenceMeasuring.BeginMeasuring;
begin
  fIVMeasuringToStop:=False;
  ProgressBar.Max := MeasurementNumberDetermine();
  DecimalSeparator:='.';

  ProgressBar.Position := 0;
  ButtonStop.Enabled:=True;
  CBForw.Enabled:=False;
  CBRev.Enabled:=False;
//  ButtonSave.Enabled:=False;

  fPointNumber:=0;
  ProgressBar.Position := fPointNumber;
  SetLenVector(Results,fPointNumber);

  ForwLine.Clear;
  RevLine.Clear;
  ForwLg.Clear;
  RevLg.Clear;

  HookBeginMeasuring();
end;

procedure TDependenceMeasuring.ButtonStopClick(Sender: TObject);
begin
 fIVMeasuringToStop:=True;
end;

constructor TDependenceMeasuring.Create({RF: TLimitShow;
              RR:TLimitShowRev;}
              CBF,CBR: TCheckBox;
              PB:TProgressBar;
              BS{,BSave}: TButton;
              Res:PVector;
              FLn,RLn,FLg,RLg:TPointSeries
                     );
begin
 inherited Create;
 CBForw:=CBF;
 CBRev:=CBR;
 ProgressBar:=PB;
 ButtonStop:=BS;
 ButtonStop.OnClick:=ButtonStopClick;
// ButtonSave:=BSave;
 Results:=Res;
 ForwLine:=FLn;
 RevLine:=RLn;
 ForwLg:=FLg;
 RevLg:=RLg;
end;

procedure TDependenceMeasuring.Cycle(ItIsForwardInput: Boolean; Action: TSimpleEvent);
 var Start,Finish:double;
     Condition:boolean;
begin
 fItIsForward:=ItIsForwardInput;
 fDelayTime:=0;
 HookCycle();

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
//   showmessage('Hiiiii2');

 if Condition then
  begin
   fVoltageInput:=Start;
   repeat
     Application.ProcessMessages;
     if fIVMeasuringToStop then Exit;

     inc(fPointNumber);
//     showmessage(inttostr(fPointNumber));
     Action;
//     showmessage('jjj');
     HookStep();
//     showmessage('jjj333');
     fVoltageInput:=fVoltageInput+fVoltageStep;
   until fVoltageInput>Finish;
  end;


end;


procedure TDependenceMeasuring.DataSave;
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

class function TDependenceMeasuring.DelayTime: integer;
begin
 Result:=fDelayTime;
end;

class procedure TDependenceMeasuring.DelayTimeChange(Value: integer);
begin
  fDelayTime:=Value;
end;

procedure TDependenceMeasuring.EndMeasuring;
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

class procedure TDependenceMeasuring.SecondMeasIsDoneChange(Value: boolean);
begin
 fSecondMeasIsDone:=Value;
end;

procedure TDependenceMeasuring.FullCycle(Action: TSimpleEvent);
begin
  Cycle(True,Action);
  Cycle(False,Action);
end;

class function TDependenceMeasuring.ItIsForward: boolean;
begin
 Result:=fItIsForward;
end;

class procedure TDependenceMeasuring.ItIsForwardChange(Value: boolean);
begin
 fItIsForward:=Value;
end;

class function TDependenceMeasuring.IVMeasuringToStop: boolean;
begin
 Result:=fIVMeasuringToStop;
end;

class procedure TDependenceMeasuring.IVMeasuringToStopChange(Value: boolean);
begin
 fIVMeasuringToStop:=Value;
end;

function TDependenceMeasuring.MeasurementNumberDetermine: integer;
begin
 fPointNumber:=0;
 FullCycle(AEmpty);

// FullCycle(ActionEmpty);
 Result:=fPointNumber;
// showmessage('number'+inttostr(Result));
end;

procedure TDependenceMeasuring.Measuring;
begin
  BeginMeasuring();

  FullCycle(ActionMeasurement);
  EndMeasuring();
end;


class function TDependenceMeasuring.PointNumber: word;
begin
   Result:=fPointNumber;
end;

class procedure TDependenceMeasuring.PointNumberChange(Value: word);
begin
 fPointNumber:=Value;
end;

procedure TDependenceMeasuring.SetVoltage;
begin
  if fItIsForward then fVoltageInputReal := fVoltageInput
                  else fVoltageInputReal := -fVoltageInput;

 HookSetVoltage();
// SetDevice.SetValue(fVoltageInputReal);

 sleep(1000);
 sleep(fDelayTime);
end;

class function TDependenceMeasuring.tempI: double;
begin
  Result:=ftempI;
end;

class procedure TDependenceMeasuring.tempIChange(Value: double);
begin
  ftempI:=Value;
end;

class function TDependenceMeasuring.tempV: double;
begin
  Result:=ftempV;
end;

class procedure TDependenceMeasuring.tempVChange(Value: double);
begin
  ftempV:=Value;
end;

class function TDependenceMeasuring.VoltageInput: double;
begin
  Result:=fVoltageInput;
end;

class procedure TDependenceMeasuring.VoltageInputChange(Value: double);
begin
  fVoltageInput:=Value;
end;

class function TDependenceMeasuring.VoltageInputReal: double;
begin
  Result:=fVoltageInputReal;
end;

class procedure TDependenceMeasuring.VoltageInputRealChange(Value: double);
begin
  fVoltageInputReal:=Value;
end;

class function TDependenceMeasuring.VoltageStep: double;
begin
  Result:=fVoltageStep;
end;

class procedure TDependenceMeasuring.VoltageStepChange(Value: double);
begin
  fVoltageStep:=Value;
end;

end.
