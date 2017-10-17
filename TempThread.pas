unit TempThread;

interface

uses
  Classes, Measurement,SPIdevice, RS232_Meas_Tread;

const VdiodMax=2;

type
//  TTemperatureMeasuringThread = class(TThread)
//  TTemperatureMeasuringThread = class(TTheadSleep)

  TMeasuringThread = class(TTheadCycle)
  private
    fEventEnd:THandle;
    fMeasurement:IMeasurement;
    fWPARAM:word;
  protected
   procedure DoSomething;override;
  public
   constructor Create(Measurement:IMeasurement;
                      Interval:double;
                      WPARAM: word;
                      EventEnd:THandle);

  end;



  TTemperatureMeasuringThread = class(TTheadCycle)
  private
//    fInterval:int64;
    fEventEnd:THandle;
    fTemperatureMeasurement:ITemperatureMeasurement;
  protected
    procedure DoSomething;override;
  public
   constructor Create(TemperatureMeasurement:ITemperatureMeasurement;
                      Interval:double;
                      EventEnd:THandle);

  end;

  TControllerThread = class(TTheadCycle)
  private
//    fInterval:int64;
//    fEventEnd:THandle;
    fMeasurement:IMeasurement;
    fDAC:IDAC;
    fPID:TPID;
    function Mesuring():double;
  protected
    procedure DoSomething;override;
  public
   destructor Destroy; override;
   constructor Create(Measurement:IMeasurement;
                      IDAC:IDAC;
                      Interval:double;
                      Kpp,Kii,Kdd,{InitialValue,}NeededValue:double);
//                      EventEnd:THandle);

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

constructor TTemperatureMeasuringThread.Create(TemperatureMeasurement:ITemperatureMeasurement;
                                               Interval:double;
                                                EventEnd:THandle);
begin
//  inherited Create(True);    // ����� ������� � ��������� ���������������
//  FreeOnTerminate := True;  // ����� ��������� ������� ��� ��������� ������
//  inherited Create();
  inherited Create(Interval);
//  TemperatureMD:=TemMD;
//  fInterval:=Interval;
  fTemperatureMeasurement:=TemperatureMeasurement;
  fEventEnd:=EventEnd;
//  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;

//  Priority:=tpNormal;
  Resume;
end;

//procedure TTemperatureMeasuringThread.Doing;
procedure TTemperatureMeasuringThread.DoSomething;
// var temp:double;
begin
  fTemperatureMeasurement.GetTemperatureThread(fEventEnd);
//  TemperatureMD.ActiveInterface.GetTemperatureThread(fEventEnd);
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

//procedure TTemperatureMeasuringThread.Execute;
//var
//  t: TDateTime;
//  k: Int64;
//begin
//  while (not Terminated) and (not Application.Terminated) do
//  begin
//    t := Now();
//    Doing;
//    k := fInterval - Round(MilliSecondSpan(Now(), t));
//    if k>0 then
//      _Sleep(k);
////      sleep(k);
//  end;
//end;



{ TMeasuringThread }

constructor TMeasuringThread.Create(Measurement: IMeasurement; Interval: double;
  WPARAM: word; EventEnd: THandle);
begin
 inherited Create(Interval);
 fEventEnd:=EventEnd;
 fMeasurement:=Measurement;
 fWPARAM:=WPARAM;
 Resume;
end;

procedure TMeasuringThread.DoSomething;
begin
  fMeasurement.GetDataThread(fWPARAM, fEventEnd);
end;

{ TControllerThread }

constructor TControllerThread.Create(Measurement: IMeasurement;
                                     IDAC: IDAC;
                                     Interval: double;
                                     Kpp, Kii, Kdd,
                                     {InitialValue, }
                                     NeededValue: double);

begin
  inherited Create(Interval);
  fMeasurement:=Measurement;
  fDAC:=IDAC;
//  fPID:=TPID.Create(Kpp, Kii, Kdd, Interval, InitialValue, NeededValue);
  fPID:=TPID.Create(Kpp, Kii, Kdd, Interval, Mesuring(), NeededValue);
//  fDAC.Output(fPID.OutputValue);
  if (fDAC.Name='Ch2_ET1255')and
     (abs(fPID.OutputValue)>VdiodMax)
          then fDAC.Output(VdiodMax)
          else fDAC.Output(fPID.OutputValue);
  _Sleep(fInterval);
  Resume;
end;

function TControllerThread.Mesuring:double;
begin
  ResetEvent(FEventTerminate);
  fMeasurement.GetDataThread(ControlMessage, FEventTerminate);
  WaitForSingleObject(FEventTerminate, INFINITE);
  ResetEvent(FEventTerminate);
  Result:=fMeasurement.Value;
end;

destructor TControllerThread.Destroy;
begin
  fPID.Free;
  inherited Destroy;
end;

procedure TControllerThread.DoSomething;
begin
//  Mesuring;
//  fPID.ControlingSignal(fMeasurement.Value);
  fPID.ControlingSignal(Mesuring);

  if (fDAC.Name='Ch2_ET1255')and
     (abs(fPID.OutputValue)>VdiodMax)
          then fDAC.Output(VdiodMax)
          else fDAC.Output(fPID.OutputValue);

end;

end.
