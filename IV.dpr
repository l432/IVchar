program IV;

uses
  Forms,
  IVchar_main in 'IVchar_main.pas' {IVchar},
  SPIdevice in 'SPIdevice.pas',
  PacketParameters in 'PacketParameters.pas',
  Measurement in 'Measurement.pas',
  TempThread in 'TempThread.pas',
  ShowTypes in 'ShowTypes.pas',
  Dependence in 'Dependence.pas',
  RS232device in 'RS232device.pas',
  V7_21 in 'V7_21.pas',
  TemperatureSensor in 'TemperatureSensor.pas',
  AD5752R in 'AD5752R.pas',
  DACR2R in 'DACR2R.pas',
  UT70 in 'UT70.pas',
  HighResolutionTimer in 'HighResolutionTimer.pas',
  RS232_Meas_Tread in 'RS232_Meas_Tread.pas',
  ET1255 in 'ET1255.pas',
  RS232_Mediator_Tread in 'RS232_Mediator_Tread.pas',
  D30_06 in 'D30_06.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TIVchar, IVchar);
  Application.Run;
end.
