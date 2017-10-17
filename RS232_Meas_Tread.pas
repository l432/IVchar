unit RS232_Meas_Tread;

interface

uses
  Classes, RS232device;

//var
//    EventMeasuringEnd: THandle;

type

 TTheadSleep = class(TThread)
  protected
    FEventTerminate: THandle;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Terminate;
    procedure _Sleep(AMilliSeconds: Cardinal);
  end;

 TTheadCycle = class(TTheadSleep)
  private
  protected
    fInterval:int64;
    procedure DoSomething;virtual;
  public
    constructor Create(Interval:double);
    procedure Execute; override;
  end;



//  TRS232MeasuringTread = class(TThread)
  TRS232MeasuringTread = class(TTheadSleep)
  private
    { Private declarations }
   fRS232Meter:TRS232Meter;
   fWPARAM: word;
   fEventEnd:THandle;
   procedure FalseStatement();
   procedure ConvertToValue();
   procedure NewData();
   procedure ExuteBegin;virtual;
  protected
    procedure Execute; override;
  public
    constructor Create(RS_Meter:TRS232Meter;WPARAM: word; EventEnd: THandle);
  end;

  TV721_MeasuringTread = class(TRS232MeasuringTread)
  private
   procedure ExuteBegin;override;
  protected
  end;

implementation

uses
  Windows, OlegType, Measurement, Math, OlegMath, SysUtils, DateUtils, Forms;

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

constructor TRS232MeasuringTread.Create(RS_Meter: TRS232Meter; WPARAM: word; EventEnd: THandle);
begin
// inherited Create(True);    // ����� ������� � ��������� ���������������
//  FreeOnTerminate := True;  // ����� ��������� ������� ��� ��������� ������
  inherited Create();
  fRS232Meter := RS_Meter;
  fWPARAM:=WPARAM;
  fEventEnd:=EventEnd;
//  Self.Priority := tpNormal;
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
//    sleep(10);
    _Sleep(10);
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
 SetEvent(fEventEnd);
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

//initialization
//  EventMeasuringEnd := CreateEvent(nil,
//                                 True, // ��� ������ TRUE - ������
//                                 True, // ��������� ��������� TRUE - ����������
//                                 nil);
//
//finalization
//
//  SetEvent(EventMeasuringEnd);
//  CloseHandle(EventMeasuringEnd);

{ TTheadPeriodic }

constructor TTheadSleep.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  Self.Priority := tpNormal;
  
  FEventTerminate := CreateEvent(nil, True, False, nil);
//  FEventTerminate := CreateEvent(nil, False, False, nil);
end;

destructor TTheadSleep.Destroy;
begin
  CloseHandle(FEventTerminate);
  inherited;
end;

//procedure TTheadPeriodic.DoSomething;
//begin
//
//end;

//procedure TTheadPeriodic.Execute;
//var
//  t: TDateTime;
//  k: Int64;
//begin
//  while (not Terminated) and (not Application.Terminated) do
//  begin
//    t := Now();
//    DoSomething;
//    k := 5000 - Round(MilliSecondSpan(Now(), t));
//    if k>0 then
//      _Sleep(k);
//  end;
//end;

procedure TTheadSleep.Terminate;
begin
  SetEvent(FEventTerminate);
  inherited Terminate;
end;

procedure TTheadSleep._Sleep(AMilliSeconds: Cardinal);
begin
 WaitForSingleObject(FEventTerminate, AMilliSeconds);
end;

{ TTheadCycle }

constructor TTheadCycle.Create(Interval: double);
begin
 inherited Create();
 fInterval:=abs(round(1000*Interval));
end;

procedure TTheadCycle.DoSomething;
begin

end;

procedure TTheadCycle.Execute;
var
  t: TDateTime;
  k: Int64;
begin
  while (not Terminated) and (not Application.Terminated) do
  begin
    t := Now();
    DoSomething;
    k := fInterval - Round(MilliSecondSpan(Now(), t));
    if k>0 then
      _Sleep(k);
  end;
end;

end.
