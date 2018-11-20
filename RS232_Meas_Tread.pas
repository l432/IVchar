unit RS232_Meas_Tread;

interface

uses
  Classes, RS232device, Measurement;


type




  TRS232MeasuringTread = class(TMeasuringTread)
  private
   fRS232Meter:TRS232Meter;
   procedure FalseStatement();
   procedure ConvertToValue();
  protected
   procedure ExuteBegin;override;
  public
   constructor Create(RS_Meter:TRS232Meter;WPARAM: word; EventEnd: THandle);
  end;


  TV721_MeasuringTread = class(TRS232MeasuringTread)
  private
  protected
   procedure ExuteBegin;override;
  end;

implementation

uses
  Windows, OlegType, Math, OlegMath, SysUtils, DateUtils, Forms;

{ RS232Measuring }

procedure TRS232MeasuringTread.ConvertToValue;
begin
  fRS232Meter.ConvertToValue()
end;

constructor TRS232MeasuringTread.Create(RS_Meter: TRS232Meter; WPARAM: word; EventEnd: THandle);
begin
  inherited Create(RS_Meter,WPARAM,EventEnd);
  fRS232Meter := RS_Meter;
  fMeasurement:=fRS232Meter;
  Resume;
end;

procedure TRS232MeasuringTread.ExuteBegin;
label
  start;
var
  i: Integer;
  isFirst: Boolean;
begin
  isFirst := True;
start:
  Synchronize(FalseStatement);
  fRS232Meter.Request;
//  sleep(fRS232Meter.MinDelayTime);
  _Sleep(fRS232Meter.MinDelayTime);
  i := 0;
  repeat
//    sleep(fRS232Meter.DelayTimeStep);
    _Sleep(fRS232Meter.DelayTimeStep);
    inc(i);
  until ((i > fRS232Meter.DelayTimeMax) or (fRS232Meter.IsReceived) or (fRS232Meter.Error));
  if fRS232Meter.IsReceived then
    Synchronize(ConvertToValue);
//  if ((fRS232Meter.Value = ErResult) or (fRS232Meter.ResultProblem(fRS232Meter.Value))) and (isFirst) then
  if (fRS232Meter.RepeatInErrorCase) and (fRS232Meter.Value = ErResult) and (isFirst) then
  begin
    isFirst := false;
    goto start;
  end;
end;


procedure TRS232MeasuringTread.FalseStatement;
begin
 fRS232Meter.MeasurementBegin;
end;


{ TV721_MeasuringTread }

procedure TV721_MeasuringTread.ExuteBegin;
 label st;
 var a,b,c:double;
     isFirst:boolean;
begin
  isFirst:=True;
  st:
  inherited ExuteBegin;
  a:=fRS232Meter.Value;
//  sleep(100);
  _Sleep(100);
  inherited ExuteBegin;
  b:=fRS232Meter.Value;
  if abs(a-b)<1e-5*Max(abs(a),abs(b))
     then
      fRS232Meter.Value:=(a+b)/2
     else
      begin
//        sleep(100);
        _Sleep(100);
        inherited ExuteBegin;
        c:=fRS232Meter.Value;
        fRS232Meter.Value:=MedianFiltr(a,b,c);
      end;
  if (fRS232Meter.Value=0)and(isFirst) then
   begin
//    sleep(300);
    _Sleep(300);
    isFirst:=False;
    goto st;
   end;
end;


end.
