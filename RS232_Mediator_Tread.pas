unit RS232_Mediator_Tread;

interface

uses
  Measurement, HighResolutionTimer, CPort, 
  ArduinoDeviceNew, MDevice;

Const
  ScanningPeriodShot=5;

type

  TArrIArduinoSender=class(TArrI)
   private
    function  GetArduinoSender(Index:Integer):IArduinoSender;
   public
    property ArduinoSender[Index:Integer]:IArduinoSender read GetArduinoSender;
    Constructor Create(const SOI: array of IArduinoSender);
    procedure Add(const IO:IArduinoSender);overload;
    procedure Add(const SOI:array of IArduinoSender);overload;
  end;

  TRS232_MediatorTread = class(TTheadSleep)
  private
   fArduinoComPort:TRS232_Arduino;
//   fArrayDevice:array of IArduinoSender;
   fArrIAS:TArrIArduinoSender;
//   fDeviceNumber:byte;
   procedure DoSomething;
  protected
    procedure Execute; override;
  public
//    constructor Create(CP:TComPort; ArrayDevice:array of IArduinoSender);
    constructor Create(CP:TComPort; ArrIAS:TArrIArduinoSender);
    destructor Destroy;override;
//    procedure Free;overload;
  end;

//var
// RS232_MediatorTread:TRS232_MediatorTread;

implementation

uses
  Windows, Forms, RS232deviceNew, OlegFunction, SysUtils;


{ RS232_Mediator }

//constructor TRS232_MediatorTread.Create(CP:TComPort;
//                     ArrayDevice: array of IArduinoSender);
constructor TRS232_MediatorTread.Create(CP:TComPort;
                         ArrIAS:TArrIArduinoSender);
// var i:byte;
begin
  inherited Create;
  fArduinoComPort:=TRS232_Arduino.Create(CP);
  fArrIAS:=ArrIAS;
//  SetLength(fArrayDevice,High(ArrayDevice)+1);
//  for I := 0 to High(ArrayDevice) do
//   fArrayDevice[i]:=ArrayDevice[i];
//   fDeviceNumber:=Low(ArrayDevice);
  Resume;
end;

destructor TRS232_MediatorTread.Destroy;
begin
 DoSomething;

 fArrIAS:=nil;
 fArduinoComPort.Free;
 inherited;
end;

procedure TRS232_MediatorTread.DoSomething;
 var i:byte;
begin
//  for I := 0 to High(fArrayDevice) do
//    if fArrayDevice[i].isNeededComPort then
//      begin
//       fArrayDevice[i].PacketCreateToSend();
//       fArrayDevice[i].Error:=not(fArduinoComPort.IsSend(fArrayDevice[i].MessageError));
//       fArrayDevice[i].isNeededComPort:=False;
//      _Sleep(2);
//      end;
  for I := 0 to fArrIAS.HighIndex do
    if fArrIAS.ArduinoSender[i].isNeededComPort then
      begin
       HelpForMe(inttostr(MilliSecond)+fArrIAS.ArduinoSender[i].Name);
       fArrIAS.ArduinoSender[i].PacketCreateToSend();
       fArrIAS.ArduinoSender[i].Error:=not(fArduinoComPort.IsSend(fArrIAS.ArduinoSender[i].MessageError));
       fArrIAS.ArduinoSender[i].isNeededComPort:=False;
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

//procedure TRS232_MediatorTread.Free;
//begin
// fArduinoComPort.Free;
// inherited Free;
//end;

{ TArrIArduinoSender }

procedure TArrIArduinoSender.Add(const IO: IArduinoSender);
begin
  SetLength(fSetOfInterface,High(fSetOfInterface)+2);
  fSetOfInterface[High(fSetOfInterface)]:=Pointer(IO);
end;

procedure TArrIArduinoSender.Add(const SOI: array of IArduinoSender);
 var i:integer;
begin
 SetLength(fSetOfInterface,High(SOI)+High(fSetOfInterface)+2);
 for I := 0 to High(SOI) do
  fSetOfInterface[High(fSetOfInterface)-High(SOI)+i]:=Pointer(SOI[i]);
end;

constructor TArrIArduinoSender.Create(const SOI: array of IArduinoSender);
var I: Integer;
begin
  inherited Create;
 if High(SOI)<0 then Exit;
 SetLength(fSetOfInterface,High(SOI)+1);
 for I := 0 to High(SOI) do
   fSetOfInterface[i] := Pointer(SOI[i]);
end;

function TArrIArduinoSender.GetArduinoSender(Index: Integer): IArduinoSender;
begin
 if (Index<0) or (Index>HighIndex)
   then Result:=nil
   else Result:=IArduinoSender(fSetOfInterface[Index]);
end;

end.
