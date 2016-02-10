program IV;

uses
  Forms,
  IVchar_main in 'IVchar_main.pas' {IVchar},
  SPIdevice in 'SPIdevice.pas',
  PacketParameters in 'PacketParameters.pas',
  Measurement in 'Measurement.pas',
  TempThread in 'TempThread.pas',
  ShowTypes in 'ShowTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TIVchar, IVchar);
  Application.Run;
end.
