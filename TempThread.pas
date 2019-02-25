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
    fInterialPIDused:boolean;
    function Mesuring():double;
    procedure ControllerOutput;
  protected
    procedure DoSomething;override;
  public
   destructor Destroy; override;
   constructor Create(Measurement:IMeasurement;
                      IDAC:IDAC;
                      Interval:double;
                      Kpp,Kii,Kdd,NeededValue,Tolerance:double);overload;
   constructor Create(Measurement:IMeasurement;
                      IDAC:IDAC;
                      Interval:double;
                      PID:TPID);overload;
  end;


implementation

uses
  Windows;

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
                                     NeededValue,Tolerance: double);

begin
  inherited Create(Interval);

  fMeasurement:=Measurement;
  fDAC:=IDAC;
  fPID:=TPID.Create(Kpp, Kii, Kdd, NeededValue,Tolerance, Interval);
  fInterialPIDused:=True;
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
 label bb;
begin
bb:
  ResetEvent(FEventTerminate);
  fMeasurement.GetDataThread(ControlMessage, FEventTerminate);
//  WaitForSingleObject(FEventTerminate, INFINITE);
  if WaitForSingleObject(FEventTerminate,5000)<>WAIT_OBJECT_0
    then goto bb;
   ResetEvent(FEventTerminate);
   Result:=fMeasurement.Value;
end;

constructor TControllerThread.Create(Measurement: IMeasurement; IDAC: IDAC;
  Interval: double; PID: TPID);
begin
  inherited Create(Interval);

  fMeasurement:=Measurement;
  fDAC:=IDAC;
  fPID:=PID;
  fInterialPIDused:=False;
  Resume;
end;

destructor TControllerThread.Destroy;
begin
  if fInterialPIDused then fPID.Free;
  inherited Destroy;
end;

procedure TControllerThread.DoSomething;
begin
  fPID.ControlingSignal(Mesuring);

  ControllerOutput;
end;


end.
