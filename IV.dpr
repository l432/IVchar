program IV;

uses
  Forms,
  IVchar_main in 'IVchar_main.pas' {IVchar},
  PacketParameters in 'PacketParameters.pas',
  Measurement in 'Measurement.pas',
  TempThread in 'TempThread.pas',
  ShowTypes in 'ShowTypes.pas',
  Dependence in 'Dependence.pas',
  V7_21 in 'V7_21.pas',
  TemperatureSensor in 'TemperatureSensor.pas',
  AD5752R in 'AD5752R.pas',
  DACR2Ru in 'DACR2Ru.pas',
  HighResolutionTimer in 'HighResolutionTimer.pas',
  RS232_Meas_Tread in 'RS232_Meas_Tread.pas',
  ET1255 in 'ET1255.pas',
  RS232_Mediator_Tread in 'RS232_Mediator_Tread.pas',
  D30_06u in 'D30_06u.pas',
  PID in 'PID.pas',
  MDevice in 'MDevice.pas',
  MCP3424u in 'MCP3424u.pas',
  ArduinoADC in 'ArduinoADC.pas',
  ADS1115 in 'ADS1115.pas',
  MLX90615u in 'MLX90615u.pas',
  INA226 in 'INA226.pas',
  OlegDevice in 'OlegDevice.pas',
  ADT74x0u in 'ADT74x0u.pas',
  TMP102u in 'TMP102u.pas',
  MCP9808u in 'MCP9808u.pas',
  RS232deviceNew in 'RS232deviceNew.pas',
  UT70 in 'UT70.PAS',
  GDS_806Su in 'GDS_806Su.pas',
  ArduinoDeviceNew in 'ArduinoDeviceNew.pas',
  ArduinoDeviceShow in 'ArduinoDeviceShow.pas',
  AD9833u in 'AD9833u.pas',
  DependOnArduino in 'DependOnArduino.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TIVchar, IVchar);
  Application.Run;
end.
