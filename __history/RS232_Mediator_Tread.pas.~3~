unit RS232_Mediator_Tread;

interface

uses
  RS232device,  Measurement, HighResolutionTimer, CPort, 
  ArduinoDeviceNew;

Const
  ScanningPeriodShot=5;

type
  TRS232_MediatorTread = class(TTheadSleep)
  private
   fArduinoComPort:TRS232_Arduino;
//   fArrayDevice:array of TRS232Device;
   fArrayDevice:array of IArduinoSender;
   fDeviceNumber:byte;
   procedure DoSomething;
  protected
    procedure Execute; override;
  public
//    constructor Create(CP:TComPort; ArrayDevice:array of TRS232Device);
    constructor Create(CP:TComPort; ArrayDevice:array of IArduinoSender);
    procedure Free;overload;
  end;

var
 RS232_MediatorTread:TRS232_MediatorTread;

implementation

uses
  Windows, Forms, RS232deviceNew;


{ RS232_Mediator }

//constructor TRS232_MediatorTread.Create(CP:TComPort;
//                     ArrayDevice: array of TRS232Device);
constructor TRS232_MediatorTread.Create(CP:TComPort;
                     ArrayDevice: array of IArduinoSender);
 var i:byte;
begin
  inherited Create;
  fArduinoComPort:=TRS232_Arduino.Create(CP);
  SetLength(fArrayDevice,High(ArrayDevice)+1);
  for I := 0 to High(ArrayDevice) do
   fArrayDevice[i]:=ArrayDevice[i];
   fDeviceNumber:=Low(ArrayDevice);
  Resume;
end;

procedure TRS232_MediatorTread.DoSomething;
 var i:byte;
begin
  for I := 0 to High(fArrayDevice) do
    if fArrayDevice[i].isNeededComPort then
      begin
//      fArrayDevice[i].ComPortUsing();
       fArrayDevice[i].PacketCreateToSend();
       fArrayDevice[i].Error:=not(fArduinoComPort.IsSend(fArrayDevice[i].MessageError));
       fArrayDevice[i].isNeededComPort:=False;
      _Sleep(2);
      end;
end;

procedure TRS232_MediatorTread.Execute;
var
  i:byte;
begin
  i:=0;
  while (not Terminated) and (not Application.Terminated) do
  begin
   if i=0 then
     begin
       ResetEvent(EventComPortFree);
       DoSomething;
     end;
   if i=1 then
     begin
       SetEvent(EventComPortFree);
//       sleep(ScanningPeriodShot);
       _Sleep(ScanningPeriodShot);
//       HRDelay(ScanningPeriodShot);
     end;
   i:=1-i;
  end;
end;

procedure TRS232_MediatorTread.Free;
begin
 fArduinoComPort.Free;
 inherited Free;
end;

end.
