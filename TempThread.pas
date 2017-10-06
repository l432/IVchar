unit TempThread;

interface

uses
  Classes, Measurement,SPIdevice;

type
  TTemperatureMeasuringThread = class(TThread)
  private
    fInterval:int64;
    procedure Doing;
  protected
    procedure Execute; override;
  public
   TemperatureMD:TTemperature_MD;
   constructor Create(TemMD:TTemperature_MD;Interval:Int64);

  end;

implementation

uses
  OlegType, Forms, SysUtils, TemperatureSensor, DateUtils, Windows;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TTemperatureMeasuringThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TTemperatureMeasuringThread }

constructor TTemperatureMeasuringThread.Create(TemMD: TTemperature_MD;Interval:Int64);
begin
  inherited Create(True);    // Поток создаем в состоянии «Приостановлен»
  FreeOnTerminate := True;  // Поток освободит ресурсы при окончании работы
  TemperatureMD:=TemMD;
  fInterval:=Interval;
//  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;

  Priority:=tpNormal;
  Resume;
end;

procedure TTemperatureMeasuringThread.Doing;
// var temp:double;
begin
  TemperatureMD.ActiveInterface.GetTemperatureThread();
//  PostMessage(FindWindow ('TIVchar', 'IVchar'), WM_MyMeasure,TemperMessage,0);

//  temp:=TemperatureMD.GetMeasurementResult();
//  if temp=ErResult then Terminate;
//  if (TemperatureMD.ActiveInterface is TDS18B20) then Sleep(5000);
end;

//procedure TTemperatureMeasuringThread.Execute;
//begin
//  while not(Terminated) do
//  begin
//    Synchronize(Doing);
////  if (TemperatureMD.ActiveInterface is TDS18B20) then Sleep(5000);
//
//    //    Application.ProcessMessages;
//  end;
//end;

procedure TTemperatureMeasuringThread.Execute;
var
  t: TDateTime;
  k: Int64;
begin
  while (not Terminated) and (not Application.Terminated) do
  begin
    t := Now();
    Doing;
    k := fInterval - Round(MilliSecondSpan(Now(), t));
    if k>0 then
//      _Sleep(k);
      sleep(k);
  end;
end;

end.
