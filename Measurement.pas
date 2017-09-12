unit Measurement;

interface

uses
  StdCtrls, Classes, IniFiles;

type

IName = interface
  ['{5B51E68D-11D9-4410-8396-05DB50F07F35}']
  function GetName:string;
end;

IMeasurement = interface
  ['{7A6DCE4C-9A04-444A-B7FD-39B800BDE6A7}']
 function GetTemperature:double;
 function GetVoltage(Vin:double):double;
 function GetCurrent(Vin:double):double;
 function GetResist:double;
// function GetName:string;
end;

IOutput = interface
  ['{F729B2E9-AF49-4293-873B-83D53C258E0A}']
 procedure Output(Value:double);
 Procedure Reset();
 function CalibrationStep(Voltage:double):double;
 procedure OutputCalibr(Value:double);
end;

TSimulator = class (TInterfacedObject,IMeasurement,IName,IOutput)
private
 FName: string;
public
 property Name:string read FName;
 Constructor Create();overload;
 Constructor Create(name:string);overload;
 function GetTemperature:double;
 function GetVoltage(Vin:double):double;
 function GetCurrent(Vin:double):double;
 function GetResist:double;
 function GetName:string;
 procedure Output(Value:double);
 Procedure Reset();
 function CalibrationStep(Voltage:double):double;
 procedure OutputCalibr(Value:double);
end;

TDevice=class
private
 fSetOfInterface:array of TInterfacedObject;
 DevicesComboBox:TComboBox;
 function GetActiveInterface():TInterfacedObject;
public
 property ActiveInterface:TInterfacedObject read GetActiveInterface;
 Constructor Create(const SOI:array of TInterfacedObject;
                    DevCB:TComboBox);
 procedure Add(IO:TInterfacedObject);
 procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
 procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
end;


TMeasuringDevice =class(TDevice)
private
 ResultIndicator,DataForAction:TLabel;
 ActionButton:TButton;
 procedure ActionButtonOnClick(Sender: TObject);
 function GetResult(Value:double):double;virtual;
 function StringResult(data:double):string;virtual;
public
 Constructor Create(const SOI:array of TInterfacedObject;
                    DevCB:TComboBox;
                    RI:TLabel
                    );
 function GetMeasurementResult(Value: Double):double;
 procedure AddActionButton(AB:TButton;DFA:TLabel);
 function GetResist():double;
end;

TTemperature_MD =class(TMeasuringDevice)
private
 function GetResult(Value:double):double;override;
 function StringResult(data:double):string;override;
public
end;

TCurrent_MD =class(TMeasuringDevice)
private
 function GetResult(Value:double):double;override;
public
end;

TVoltageIV_MD =class(TMeasuringDevice)
private
 function StringResult(data:double):string;override;
public
end;

TVoltageChannel_MD =class(TMeasuringDevice)
private
 function StringResult(data:double):string;override;
public
end;

TSettingDevice =class(TDevice)
private
public
 procedure SetValue(Value:double);
 procedure Reset();
 function CalibrationStep(Voltage:double):double;
 procedure SetValueCalibr(Value:double);
end;


function T_CuKo(Voltage:double):double;
{функция расчета температури по значениям напряжения
согласно градуировке термопары медь-константан}

implementation

uses
  SysUtils, OlegType, SPIdevice, Dialogs, V7_21, DACR2R;

{ Simulator }

constructor TSimulator.Create;
begin
 Create('Simulation');
end;

function TSimulator.CalibrationStep(Voltage: double): double;
begin
 Result:=0.01;
end;

constructor TSimulator.Create(name: string);
begin
 inherited Create;
 fname:=name;
end;

function TSimulator.GetCurrent(Vin: double): double;
begin
 sleep(300);
 Result:=4e-4*Vin;
// Result:=4e-11*Vin;
end;

function TSimulator.GetName: string;
begin
  Result:=Name;
end;

function TSimulator.GetResist: double;
begin
 Result:=0;
end;

function TSimulator.GetTemperature: double;
begin
 sleep(500);
 result:=333;
 // Result:=Random(4000)/10.0;
end;

function TSimulator.GetVoltage(Vin: double): double;
begin
 sleep(300);
 Result:=Vin;
end;


procedure TSimulator.Output(Value: double);
begin

end;

procedure TSimulator.OutputCalibr(Value: double);
begin

end;

procedure TSimulator.Reset;
begin

end;

function T_CuKo(Voltage:double):double;
{функция расчета температури по значениям напряжения
согласно градуировке термопары медь-константан}
begin
 Voltage:=Voltage*1e6;
 Result:=273.8+0.025*Voltage-1.006e-6*Voltage*Voltage+1.625e-10*Voltage*Voltage*Voltage;
end;


{ TMeasuringDevice }

procedure TMeasuringDevice.ActionButtonOnClick(Sender: TObject);
 var value:double;
begin
 try
   value:=StrToFloat(DataForAction.Caption);
   GetMeasurementResult(Value);
 except
//   value:=ErResult;
 end;
end;

procedure TMeasuringDevice.AddActionButton(AB: TButton; DFA: TLabel);
begin
 ActionButton:=AB;
 ActionButton.OnClick:=ActionButtonOnClick;
 DataForAction:=DFA;
end;

constructor TMeasuringDevice.Create(const SOI:array of TInterfacedObject;
                                    DevCB: TComboBox;
                                    RI: TLabel);
begin
 inherited Create(SOI,DevCB);
 ResultIndicator:=RI;
end;

function TMeasuringDevice.GetMeasurementResult(Value: Double): double;
begin
 try
 Result:=GetResult(Value);
 if ResultIndicator<>nil then
    ResultIndicator.Caption:=StringResult(Result);
 finally

 end;
end;

function TMeasuringDevice.GetResist: double;
begin
 Result:=ErResult;
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).GetResist();
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TVoltmetr) then
   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TVoltmetr).GetResist();
end;

function TMeasuringDevice.GetResult(Value: double): double;
begin
 Result:=ErResult;
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).GetVoltage(Value);
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TVoltmetr) then
   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TVoltmetr).GetVoltage(Value);
end;


function TMeasuringDevice.StringResult(data: double): string;
begin
 Result:=FloatToStrF(data,ffExponent, 4, 2);
end;


{ TTemperatureMD }

function TTemperature_MD.GetResult(Value: double): double;
begin
  Result:=ErResult;
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).GetTemperature();
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TArduinoMeter) then
   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TArduinoMeter).GetTemperature();

// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TVoltmetr) then
//   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TVoltmetr).GetTemperature();
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TDS18B20) then
//   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TDS18B20).GetTemperature();
end;

function TTemperature_MD.StringResult(data: double): string;
begin
  Result:=FloatToStrF(data,ffFixed, 5, 2);
end;

{ TCurrentMD }

function TCurrent_MD.GetResult(Value: double): double;
begin
 Result:=ErResult;
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).GetCurrent(Value);
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TVoltmetr) then
   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TVoltmetr).GetCurrent(Value);
end;


{ TVoltageIV_MD }

function TVoltageIV_MD.StringResult(data: double): string;
begin
 Result:=FloatToStrF(data,ffFixed, 4, 3);
end;

{ TVoltageChannel_MD }

function TVoltageChannel_MD.StringResult(data: double): string;
begin
 Result:=FloatToStrF(data,ffFixed, 6, 4);
end;

{ TDevice }

procedure TDevice.Add(IO: TInterfacedObject);
begin
// showmessage(inttostr(High(fSetOfInterface)));
 SetLength(fSetOfInterface,High(fSetOfInterface)+2);
 fSetOfInterface[High(fSetOfInterface)]:=IO;
 if (fSetOfInterface[High(fSetOfInterface)] is TSimulator) then
    DevicesComboBox.Items.Add((fSetOfInterface[High(fSetOfInterface)] as TSimulator).GetName);
 if (fSetOfInterface[High(fSetOfInterface)] is TArduinoDevice) then
    DevicesComboBox.Items.Add((fSetOfInterface[High(fSetOfInterface)] as TArduinoDevice).GetName);
// showmessage(inttostr(High(fSetOfInterface)));
end;

constructor TDevice.Create(const SOI: array of TInterfacedObject;
                           DevCB: TComboBox);
var
  I: Integer;
begin
 inherited Create;

 if High(SOI)<0 then Exit;
 DevicesComboBox:=DevCB;
 DevicesComboBox.Clear;
 SetLength(fSetOfInterface,High(SOI)+1);


 for I := 0 to High(SOI) do
// Add(SOI[i]);
  begin
   fSetOfInterface[i]:=SOI[i];

  if (fSetOfInterface[i] is TSimulator) then
    DevicesComboBox.Items.Add((fSetOfInterface[i] as TSimulator).GetName);
  if (fSetOfInterface[i] is TArduinoDevice) then
    DevicesComboBox.Items.Add((fSetOfInterface[i] as TArduinoDevice).GetName);

  end;

 DevicesComboBox.ItemIndex:=0;
end;

function TDevice.GetActiveInterface: TInterfacedObject;
begin
 if DevicesComboBox=nil then Result:=nil
                    else
     Result:=fSetOfInterface[DevicesComboBox.ItemIndex];

end;

procedure TDevice.ReadFromIniFile(ConfigFile: TIniFile; const Section,
  Ident: string);
begin
  DevicesComboBox.ItemIndex:=ConfigFile.ReadInteger(Section, Ident, 0);
end;


procedure TDevice.WriteToIniFile(ConfigFile: TIniFile; const Section,
  Ident: string);
begin
  WriteIniDef(ConfigFile,Section, Ident,DevicesComboBox.ItemIndex,0);
end;

{ TSettingDevice }

function TSettingDevice.CalibrationStep(Voltage: double): double;
begin
 Result:=0.01;
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).CalibrationStep(Voltage);
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TDACR2R) then
   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TDACR2R).CalibrationStep(Voltage);
end;

procedure TSettingDevice.Reset;
begin
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
   (fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).Reset();
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TDACR2R) then
   (fSetOfInterface[DevicesComboBox.ItemIndex] as TDACR2R).Reset();
end;

procedure TSettingDevice.SetValue(Value: double);
begin
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
   (fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).Output(Value);
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TDACR2R) then
   (fSetOfInterface[DevicesComboBox.ItemIndex] as TDACR2R).Output(Value);
end;



procedure TSettingDevice.SetValueCalibr(Value: double);
begin
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
   (fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).OutputCalibr(Value);
 if (fSetOfInterface[DevicesComboBox.ItemIndex] is TDACR2R) then
   (fSetOfInterface[DevicesComboBox.ItemIndex] as TDACR2R).OutputCalibr(Value);
end;

end.
