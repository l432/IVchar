program IV;

uses
  Forms,
  IVchar_main in 'IVchar_main.pas' {IVchar},
  SPIdevice in 'SPIdevice.pas',
  PacketParameters in 'PacketParameters.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TIVchar, Main);
  Application.Run;
end.
