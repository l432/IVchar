unit RS232_Meas_Tread;

interface

uses
  Classes, RS232device;

type
  TRS232MeasuringTread = class(TThread)
  private
    { Private declarations }
   fRS232Meter:TRS232Meter;
   procedure FalseStatement();
   procedure ConvertToValue();
  protected
    procedure Execute; override;

  public
    constructor Create(RS_Meter:TRS232Meter);
  end;

implementation

uses
  Windows, OlegType;

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

constructor TRS232MeasuringTread.Create(RS_Meter: TRS232Meter);
begin
 inherited Create(True);    // Поток создаем в состоянии «Приостановлен»
  FreeOnTerminate := True;  // Поток освободит ресурсы при окончании работы
  fRS232Meter := RS_Meter;
  Self.Priority := tpNormal;
  Resume;
end;

procedure TRS232MeasuringTread.Execute;
label start;
var i:integer;
    isFirst:boolean;
    Rez:double;
begin
 Rez:=ErResult;

 isFirst:=True;
start:

 Synchronize(FalseStatement);


// if not(fRS232Meter.Request()) then Exit;
 fRS232Meter.Request();


 sleep(fRS232Meter.MinDelayTime);
 i:=0;
 repeat
   sleep(10);
   inc(i);
// Application.ProcessMessages;
 until ((i>130)or(fRS232Meter.IsReceived)or(fRS232Meter.Error));
 if fRS232Meter.IsReceived then Synchronize(ConvertToValue);
 if fRS232Meter.IsReady then Rez:=fRS232Meter.Value;

 if ((Rez=ErResult)or(fRS232Meter.ResultProblem(Rez)))and(isFirst) then
    begin
      isFirst:=false;
      goto start;
    end;

 fRS232Meter.NewData:=True;
end;


procedure TRS232MeasuringTread.FalseStatement;
begin
 fRS232Meter.MeasurementBegin;
end;

end.
