unit TempThread;

interface

uses
  Measurement, RS232_Meas_Tread, PID;

const VdiodMax=1.3;

type

  TMeasuringThread = class(TTheadCycle)
  private
    fEventEnd:THandle;
//    fMeasurement:IMeasurement;
    fMeasurement:Pointer;
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
//    fTemperatureMeasurement:ITemperatureMeasurement;
    fTemperatureMeasurement:Pointer;
  protected
    procedure DoSomething;override;
  public
   constructor Create(TemperatureMeasurement:ITemperatureMeasurement;
                      const Interval:double;
                      EventEnd:THandle);

  end;

  TControllerThread = class(TTheadCycle)
  private
//    fMeasurement:IMeasurement;
//    fDAC:IDAC;
    fMeasurement,fDAC:Pointer;
    fPID:TPID;
    fInterialPIDused:boolean;
    function GetMeasurement:IMeasurement;
    function GetDAC:IDAC;
    function Mesuring():double;
    procedure ControllerOutput;
  protected
    procedure DoSomething;override;
  public
   property Measurement:IMeasurement read GetMeasurement;
   property DAC:IDAC read GetDAC;
   destructor Destroy; override;
//   constructor Create(Measurement:IMeasurement;
//                      IDAC:IDAC;
//                      Interval:double;
//                      PID_ParamArr:TPID_ParamArr);overload;
////                      Kpp,Kii,Kdd,NeededValue,Tolerance:double);overload;
   constructor Create(Measurement:IMeasurement;
                      IDAC:IDAC;
                      Interval:double;
                      PID:TPID);overload;
  end;


implementation

uses
  Windows, OlegFunction, SysUtils, Dialogs;

{ TTemperatureMeasuringThread }

constructor TTemperatureMeasuringThread.Create(TemperatureMeasurement:ITemperatureMeasurement;
                                               const Interval:double;
                                                EventEnd:THandle);
begin
  inherited Create(Interval);
//  fTemperatureMeasurement:=TemperatureMeasurement;
  fTemperatureMeasurement:=Pointer(TemperatureMeasurement);
  fEventEnd:=EventEnd;
  Resume;
end;

procedure TTemperatureMeasuringThread.DoSomething;
begin
//  fTemperatureMeasurement.GetTemperatureThread(fEventEnd);
  ITemperatureMeasurement(fTemperatureMeasurement).GetTemperatureThread(fEventEnd);
end;

{ TMeasuringThread }

constructor TMeasuringThread.Create(Measurement: IMeasurement; Interval: double;
  WPARAM: word; EventEnd: THandle);
begin
 inherited Create(Interval);
 fEventEnd:=EventEnd;
// fMeasurement:=Measurement;
 fMeasurement:=Pointer(Measurement);
 fWPARAM:=WPARAM;
 Resume;
end;

procedure TMeasuringThread.DoSomething;
begin
//  fMeasurement.GetDataThread(fWPARAM, fEventEnd);
  IMeasurement(fMeasurement).GetDataThread(fWPARAM, fEventEnd);
end;

{ TControllerThread }

//constructor TControllerThread.Create(Measurement: IMeasurement;
//                                     IDAC: IDAC;
//                                     Interval: double;
//                                     PID_ParamArr:TPID_ParamArr);
////                                     Kpp, Kii, Kdd,
////                                     NeededValue,Tolerance: double);
//
//begin
//  inherited Create(Interval);
//
////  fMeasurement:=Measurement;
////  fDAC:=IDAC;
//  fMeasurement:=Pointer(Measurement);
//  fDAC:=Pointer(IDAC);
////  fPID:=TPID.Create(Kpp, Kii, Kdd, NeededValue,Tolerance, Interval);
//  fPID:=TPID.Create(PID_ParamArr, Interval);
//  fInterialPIDused:=True;
//  Resume;
//end;

procedure TControllerThread.ControllerOutput;
begin
  if (DAC.Name = 'Ch2_ET1255') and (abs(fPID.OutputValue) > VdiodMax) then
    DAC.Output(VdiodMax)
  else
    DAC.Output(fPID.OutputValue);
  PostMessage(FindWindow('TIVchar', 'IVchar'), WM_MyMeasure, ControlOutputMessage, 0);
end;

function TControllerThread.Mesuring:double;
 label bb;
begin
bb:
  ResetEvent(FEventTerminate);
  Measurement.GetDataThread(ControlMessage, FEventTerminate);
//  WaitForSingleObject(FEventTerminate, INFINITE);
  if WaitForSingleObject(FEventTerminate,5000)<>WAIT_OBJECT_0
    then goto bb;
   ResetEvent(FEventTerminate);
   Result:=Measurement.Value;
end;

constructor TControllerThread.Create(Measurement: IMeasurement; IDAC: IDAC;
  Interval: double; PID: TPID);
begin
  inherited Create(Interval);

//  fMeasurement:=Measurement;
//  fDAC:=IDAC;
  fMeasurement:=Pointer(Measurement);
  fDAC:=Pointer(IDAC);
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


function TControllerThread.GetDAC: IDAC;
begin
  Result:=IDAC(fDAC);
end;

function TControllerThread.GetMeasurement: IMeasurement;
begin
 Result:=IMeasurement(fMeasurement);
end;

end.
