unit RS232_Meas_Tread;

interface

uses
  Classes, RS232device;

type
  TRS232MeasuringTread = class(TThread)
  private
    { Private declarations }
   fRS232Meter:TRS232Meter;
   fWPARAM: word;
   procedure FalseStatement();
   procedure ConvertToValue();
   procedure NewData();
   procedure ExuteBegin;virtual;
  protected
    procedure Execute; override;
  public
    constructor Create(RS_Meter:TRS232Meter;WPARAM: word);
  end;

  TV721_MeasuringTread = class(TRS232MeasuringTread)
  private
    { Private declarations }
//   fRS232Meter:TRS232Meter;
//   fWPARAM: word;
//   procedure FalseStatement();
//   procedure ConvertToValue();
   procedure ExuteBegin;override;
  protected
//    procedure Execute; override;
  public
//    constructor Create(RS_Meter:TRS232Meter;WPARAM: word);
  end;

implementation

uses
  Windows, OlegType, Measurement, Math, OlegMath;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure RS232Measuring.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ RS232Measuring }

procedure TRS232MeasuringTread.ConvertToValue;
begin
  fRS232Meter.ConvertToValue()
end;

constructor TRS232MeasuringTread.Create(RS_Meter: TRS232Meter; WPARAM: word);
begin
 inherited Create(True);    // Поток создаем в состоянии «Приостановлен»
  FreeOnTerminate := True;  // Поток освободит ресурсы при окончании работы
  fRS232Meter := RS_Meter;
  fWPARAM:=WPARAM;
  Self.Priority := tpNormal;
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
  sleep(fRS232Meter.MinDelayTime);
  i := 0;
  repeat
    sleep(10);
    inc(i);
  until ((i > 130) or (fRS232Meter.IsReceived) or (fRS232Meter.Error));
  if fRS232Meter.IsReceived then
    Synchronize(ConvertToValue);
  if ((fRS232Meter.Value = ErResult) or (fRS232Meter.ResultProblem(fRS232Meter.Value))) and (isFirst) then
  begin
    isFirst := false;
    goto start;
  end;
end;

procedure TRS232MeasuringTread.Execute;
begin
 ExuteBegin;
 Synchronize(NewData);
 PostMessage(FindWindow ('TIVchar', 'IVchar'), WM_MyMeasure,fWPARAM,0);
end;


procedure TRS232MeasuringTread.FalseStatement;
begin
 fRS232Meter.MeasurementBegin;
end;

procedure TRS232MeasuringTread.NewData;
begin
 fRS232Meter.NewData:=True;
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
  sleep(100);
  inherited ExuteBegin;
  b:=fRS232Meter.Value;
  if abs(a-b)<1e-5*Max(abs(a),abs(b))
     then
      fRS232Meter.Value:=(a+b)/2
     else
      begin
        sleep(100);
        inherited ExuteBegin;
        c:=fRS232Meter.Value;
        fRS232Meter.Value:=MedianFiltr(a,b,c);
      end;
  if (fRS232Meter.Value=0)and(isFirst) then
   begin
    sleep(300);
    isFirst:=False;
    goto st;
   end;
end;

end.
