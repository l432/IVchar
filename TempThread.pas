unit TempThread;

interface

uses
  Measurement, RS232_Meas_Tread, PID;

const VdiodMax=1.3;

type

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
    fMeasurement:IMeasurement;
    fDAC:IDAC;
    fPID:TPID;
    function Mesuring():double;
    procedure ControllerOutput;
  protected
    procedure DoSomething;override;
  public
   destructor Destroy; override;
   constructor Create(Measurement:IMeasurement;
                      IDAC:IDAC;
                      Interval:double;
                      Kpp,Kii,Kdd,{InitialValue,}NeededValue:double);
  end;


implementation

uses
  Windows;

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
  inherited Create(Interval);
  fTemperatureMeasurement:=TemperatureMeasurement;
  fEventEnd:=EventEnd;
  Resume;
end;

procedure TTemperatureMeasuringThread.DoSomething;
begin
  fTemperatureMeasurement.GetTemperatureThread(fEventEnd);
end;

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
                                     NeededValue: double);

begin
  inherited Create(Interval);

  fMeasurement:=Measurement;
  fDAC:=IDAC;
  fPID:=TPID.Create(Kpp, Kii, Kdd, Interval, NeededValue);

  Resume;
end;

procedure TControllerThread.ControllerOutput;
begin
  if (fDAC.Name = 'Ch2_ET1255') and (abs(fPID.OutputValue) > VdiodMax) then
    fDAC.Output(VdiodMax)
  else
    fDAC.Output(fPID.OutputValue);
  PostMessage(FindWindow('TIVchar', 'IVchar'), WM_MyMeasure, ControlOutputMessage, 0);
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
  fPID.ControlingSignal(Mesuring);

  ControllerOutput;
end;


end.
