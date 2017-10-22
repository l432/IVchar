unit RS232_Mediator_Tread;

interface

uses
  RS232device, RS232_Meas_Tread;

Const
  ScanningPeriodShot=20;

type
  TRS232_MediatorTread = class(TTheadSleep)
  private
   fArrayDevice:array of TRS232Device;
   fNeededComPort:array of boolean;
   procedure DoSomething;
  protected
    procedure Execute; override;
  public
    constructor Create(ArrayDevice:array of TRS232Device);
  end;

implementation

uses
  Windows, Forms;


{ RS232_Mediator }

constructor TRS232_MediatorTread.Create(ArrayDevice: array of TRS232Device);
 var i:byte;
begin
  inherited Create;
  SetLength(fArrayDevice,High(ArrayDevice)+1);
  for I := 0 to High(ArrayDevice) do
   fArrayDevice[i]:=ArrayDevice[i];
  SetLength(fNeededComPort,High(ArrayDevice)+1);

  Resume;
end;

procedure TRS232_MediatorTread.DoSomething;
 var i:byte;
begin
  for I := 0 to High(fArrayDevice) do
    if fArrayDevice[i].isNeededComPort then
      begin
      fArrayDevice[i].ComPortUsing();
      fArrayDevice[i].isNeededComPort:=False;
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
       sleep(ScanningPeriodShot);
//       _Sleep(ScanningPeriodShot);
     end;
   i:=1-i;
  end;
end;

end.
