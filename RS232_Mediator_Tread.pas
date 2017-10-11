unit RS232_Mediator_Tread;

interface

uses
  Classes, RS232device, RS232_Meas_Tread;

Const
  ScanningPeriod=50;
  ScanningPeriodShot=20;

type
//  TRS232_MediatorTread = class(TThread)
  TRS232_MediatorTread = class(TTheadSleep)
  private
    { Private declarations }
   fArrayDevice:array of TRS232Device;
   fNeededComPort:array of boolean;
//   fEventTerminate: THandle;
   procedure DoSomething;
//   procedure _Sleep(AMilliSeconds: Cardinal);
   procedure Finish();
   procedure Start();
  protected
    procedure Execute; override;
  public
    constructor Create(ArrayDevice:array of TRS232Device);
//    destructor Destroy; override;
//    procedure Terminate;
  end;

implementation

uses
  Windows, SysUtils, Forms, DateUtils, IVchar_main;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure RS232_Mediator.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ RS232_Mediator }

procedure TRS232_MediatorTread.Finish;
 var i:byte;
begin
  for I := 0 to High(fArrayDevice) do
    fArrayDevice[i].isNeededComPort:=False;
end;

procedure TRS232_MediatorTread.Start;
 var i:byte;
begin
  for I := 0 to High(fArrayDevice) do
    fNeededComPort[i]:=fArrayDevice[i].isNeededComPort;
end;

constructor TRS232_MediatorTread.Create(ArrayDevice: array of TRS232Device);
 var i:byte;
begin
// inherited Create(True);    // Поток создаем в состоянии «Приостановлен»
//  FreeOnTerminate := True;  // Поток освободит ресурсы при окончании работы

  SetLength(fArrayDevice,High(ArrayDevice)+1);
  for I := 0 to High(ArrayDevice) do
   fArrayDevice[i]:=ArrayDevice[i];
  SetLength(fNeededComPort,High(ArrayDevice)+1);

//  FEventTerminate := CreateEvent(nil, False, False, nil);

//  Self.Priority := tpNormal;

  Resume;

//  if (FEventTerminate=0) then
//    Application.MessageBox('text', 'cap', MB_OK)

end;

//destructor TRS232_MediatorTread.Destroy;
//begin
//  CloseHandle(FEventTerminate);
//  inherited;
//end;

//procedure TRS232_MediatorTread.DoSomething;
// var i:byte;
//begin
//  Synchronize(Start);
//  for I := 0 to High(fArrayDevice) do
////    if fArrayDevice[i].isNeededComPort then
//    if fNeededComPort[i] then
//      fArrayDevice[i].ComPortUsing();
//  Synchronize(Finish);
//end;

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

//procedure TRS232_MediatorTread.Execute;
//var
//  t: TDateTime;
//  k: Int64;
//begin
//  while (not Terminated) and (not Application.Terminated) do
//  begin
//    t := Now();
////    DoSomething;
//    Synchronize(DoSomething);
////    k := ScanningPeriod - Round(MilliSecondSpan(Now(), t));
//    k := ScanningPeriod - MilliSecondsBetween(Now(), t);
//    if k>0 then
//      _Sleep(k);
//  end;
//end;

//procedure TRS232_MediatorTread.Execute;
//var
//  t: TDateTime;
//  k: Int64;
//begin
//
//  while (not Terminated) and (not Application.Terminated) do
//  begin
//   ComPortAlloved:=not(ComPortAlloved);
//   if ComPortAlloved  then
//    begin
//      _Sleep(ScanningPeriodShot);
//    end               else
//    begin
//      t := Now();
//      DoSomething;
//      k := ScanningPeriod - Round(MilliSecondSpan(Now(), t));
//      if k>0 then
//        _Sleep(k);
//    end;
//  end;
//end;

procedure TRS232_MediatorTread.Execute;
var
//  t: TDateTime;
//  k: Int64;
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

//procedure TRS232_MediatorTread.Terminate;
//begin
////  if (FEventTerminate=0) then
////    Application.MessageBox('text', 'cap', MB_OK)
////                          else
////    Application.MessageBox('text2', 'cap2', MB_OK);
//
//  SetEvent(FEventTerminate);
//  inherited Terminate;
//end;

//procedure TRS232_MediatorTread._Sleep(AMilliSeconds: Cardinal);
//begin
//   WaitForSingleObject(FEventTerminate, AMilliSeconds);
//end;

end.
