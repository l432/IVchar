unit Measurement;

interface

uses
  StdCtrls, Classes, IniFiles;

type

IName = interface
  ['{5B51E68D-11D9-4410-8396-05DB50F07F35}']
  function GetName:string;
  property Name:string read GetName;
end;

IMeasurement = interface (IName)
  ['{7A6DCE4C-9A04-444A-B7FD-39B800BDE6A7}']
 function GetData:double;
end;

IDAC = interface (IName)
  ['{F729B2E9-AF49-4293-873B-83D53C258E0A}']
 procedure Output(Value:double);
 {встановлює на виході напругу Value}
 procedure OutputInt(Kod:integer);
 {встановлює на виході напругу, яка відповідає Kod}
 Procedure Reset();
 {встановлює на виході 0}
 function CalibrationStep(Voltage:double):double;
 {визначає крок при процедурі калібрування залежно від величини напруги Voltage}
 procedure OutputCalibr(Value:double);
 {встановлює на виході напругу Value під час калібрування}
end;

ITemperatureMeasurement = interface (IName)
  ['{DDC24597-B316-4E8B-B246-1DDD0B4D5E5D}']
  function GetTemperature:double;
end;

TSimulator = class (TInterfacedObject,IMeasurement,IDAC,ITemperatureMeasurement)
private
 FName: string;
 function GetName:string;
public
 property Name:string read GetName;
 Constructor Create();overload;
 Constructor Create(name:string);overload;
 function GetTemperature:double;
// function GetVoltage(Vin:double):double;
// function GetCurrent(Vin:double):double;
 function GetData:double;
 procedure Output(Value:double);
 Procedure Reset();
 function CalibrationStep(Voltage:double):double;
 procedure OutputCalibr(Value:double);
 procedure OutputInt(Kod:integer);
 procedure Free;
end;

//TDevice=class
//private
// fSetOfInterface:array of TInterfacedObject;
// DevicesComboBox:TComboBox;
// function GetActiveInterface():TInterfacedObject;
//public
// property ActiveInterface:TInterfacedObject read GetActiveInterface;
// Constructor Create(const SOI:array of TInterfacedObject;
//                    DevCB:TComboBox);
// procedure Add(IO:TInterfacedObject);
// procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
// procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
//end;


//TMeasuringDevice =class(TDevice)
//private
// ResultIndicator,DataForAction:TLabel;
// ActionButton:TButton;
// procedure ActionButtonOnClick(Sender: TObject);
// function GetResult(Value:double):double;virtual;
// function StringResult(data:double):string;virtual;
//public
// Constructor Create(const SOI:array of TInterfacedObject;
//                    DevCB:TComboBox;
//                    RI:TLabel
//                    );
// function GetMeasurementResult(Value: Double):double;
// procedure AddActionButton(AB:TButton;DFA:TLabel);
//// function GetResist():double;
//end;

TDevice=class
private
 DevicesComboBox:TComboBox;
// Procedure DevicesComboBoxFilling(INameArray:array of IName);
public
 Constructor Create(DevCB:TComboBox);
 procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
 procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
end;

 TMeasuringStringResult=(srCurrent,srVoltge,srPreciseVoltage);
 {клас, який визначає як виводити на мітку результати виміру}

TMeasuringDevice =class(TDevice)
private
 fSetOfInterface:array of IMeasurement;
 fStringResult:TMeasuringStringResult;
 ResultIndicator:TLabel;
 ActionButton:TButton;
 procedure ActionButtonOnClick(Sender: TObject);
 function GetResult():double;virtual;
 function GetActiveInterface():IMeasurement;
public
 property ActiveInterface:IMeasurement read GetActiveInterface;
 Constructor Create(const SOI:array of IMeasurement;
                    DevCB:TComboBox;
                    RI:TLabel;
                    SR:TMeasuringStringResult);
 function GetMeasurementResult():double;
 procedure AddActionButton(AB:TButton);
 procedure Add(IO:IMeasurement);
// procedure Free();
end;

TSettingDevice =class(TDevice)
private
 fSetOfInterface:array of IDAC;
 function GetActiveInterface():IDAC;
public
 property ActiveInterface:IDAC read GetActiveInterface;
 Constructor Create(const SOI:array of IDAC;
                    DevCB:TComboBox);
 procedure SetValue(Value:double);
 procedure Reset();
 function CalibrationStep(Voltage:double):double;
 procedure SetValueCalibr(Value:double);
// procedure Free;
end;

TTemperature_MD =class(TDevice)
private
 fSetOfInterface:array of ITemperatureMeasurement;
 ResultIndicator:TLabel;
 function GetResult():double;virtual;
 function GetActiveInterface():ITemperatureMeasurement;
public
 property ActiveInterface:ITemperatureMeasurement read GetActiveInterface;
 Constructor Create(const SOI:array of ITemperatureMeasurement;
                    DevCB:TComboBox;
                    RI:TLabel);
 function GetMeasurementResult():double;
end;

//
//TTemperature_MD =class(TMeasuringDevice)
//private
//// function GetResult(Value:double):double;override;
//// function StringResult(data:double):string;override;
//public
//en

//TCurrent_MD =class(TMeasuringDevice)
//private
// function GetResult(Value:double):double;override;
//public
//end;
//
//TVoltageIV_MD =class(TMeasuringDevice)
//private
// function StringResult(data:double):string;override;
//public
//end;
//
//TVoltageChannel_MD =class(TMeasuringDevice)
//private
// function StringResult(data:double):string;override;
//public
//end;

//TSettingDevice =class(TDevice)
//private
//public
// procedure SetValue(Value:double);
// procedure Reset();
// function CalibrationStep(Voltage:double):double;
// procedure SetValueCalibr(Value:double);
//end;

TDAC_Show=class
  private
//   fOutputInterface: TInterfacedObject;
   fOutputInterface: IDAC;
   ValueChangeButton,ValueSetButton,
   KodChangeButton,KodSetButton,ResetButton:TButton;
   ValueLabel,KodLabel:TLabel;
   procedure ValueChangeButtonAction(Sender:TObject);
   procedure ValueSetButtonAction(Sender:TObject);
   procedure KodChangeButtonAction(Sender:TObject);
   procedure KodSetButtonAction(Sender:TObject);
   procedure ResetButtonClick(Sender:TObject);
  public
//   Constructor Create(OI: TInterfacedObject;
   Constructor Create(OI: IDAC;
                      VL, KL: TLabel;
                      VCB, VSB, KCB,
                      KSB, RB: TButton);
end;






implementation

uses
  SysUtils, OlegType, SPIdevice, Dialogs, V7_21, DACR2R, RS232device, Graphics, 
  TemperatureSensor, Windows;

{ Simulator }

constructor TSimulator.Create;
begin
  inherited Create;
  fName:='Simulation';
end;

function TSimulator.CalibrationStep(Voltage: double): double;
begin
 Result:=0.01;
end;

constructor TSimulator.Create(name: string);
begin
 inherited Create();
 fName:=name;
end;

procedure TSimulator.Free;
begin

end;

//function TSimulator.GetCurrent(Vin: double): double;
//begin
// sleep(300);
// Result:=4e-4*Vin;
//// Result:=4e-11*Vin;
//end;

function TSimulator.GetName: string;
begin
  Result:=fName;
end;

function TSimulator.GetData: double;
begin
 Result:=GetTickCount/1e7;
end;

function TSimulator.GetTemperature: double;
begin
 sleep(500);
 result:=333;
 // Result:=Random(4000)/10.0;
end;

//function TSimulator.GetVoltage(Vin: double): double;
//begin
// sleep(300);
// Result:=Vin;
//end;


procedure TSimulator.Output(Value: double);
begin

end;

procedure TSimulator.OutputCalibr(Value: double);
begin

end;

procedure TSimulator.OutputInt(Kod: integer);
begin

end;

procedure TSimulator.Reset;
begin

end;




{ TMeasuringDevice }

//procedure TMeasuringDevice.ActionButtonOnClick(Sender: TObject);
// var value:double;
//begin
// try
//   value:=StrToFloat(DataForAction.Caption);
//   GetMeasurementResult(Value);
// except
////   value:=ErResult;
// end;
//end;
//
//procedure TMeasuringDevice.AddActionButton(AB: TButton; DFA: TLabel);
//begin
// ActionButton:=AB;
// ActionButton.OnClick:=ActionButtonOnClick;
// DataForAction:=DFA;
//end;
//
//constructor TMeasuringDevice.Create(const SOI:array of TInterfacedObject;
//                                    DevCB: TComboBox;
//                                    RI: TLabel);
//begin
// inherited Create(SOI,DevCB);
// ResultIndicator:=RI;
//end;
//
//function TMeasuringDevice.GetMeasurementResult(Value: Double): double;
//begin
// try
// Result:=GetResult(Value);
// if ResultIndicator<>nil then
//    ResultIndicator.Caption:=StringResult(Result);
// finally
//
// end;
//end;
//
//
//function TMeasuringDevice.GetResult(Value: double): double;
//begin
// Result:=ErResult;
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
//   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).GetVoltage(Value);
//// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TVoltmetr) then
////   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TVoltmetr).GetVoltage(Value);
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TRS232Meter) then
//   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TRS232Meter).GetVoltage(Value);
//end;
//
//
//function TMeasuringDevice.StringResult(data: double): string;
//begin
// Result:=FloatToStrF(data,ffExponent, 4, 2);
//end;
//

{ TTemperatureMD }

//function TTemperature_MD.GetResult(Value: double): double;
//begin
//  Result:=ErResult;
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
//   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).GetTemperature();
//// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TArduinoMeter) then
////   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TArduinoMeter).GetTemperature();
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TRS232Meter) then
//   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TRS232Meter).GetTemperature();
//
//// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TVoltmetr) then
////   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TVoltmetr).GetTemperature();
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TDS18B20) then
//   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TDS18B20).GetTemperature();
//end;

//function TTemperature_MD.StringResult(data: double): string;
//begin
//  Result:=FloatToStrF(data,ffFixed, 5, 2);
//end;

//{ TCurrentMD }
//
//function TCurrent_MD.GetResult(Value: double): double;
//begin
// Result:=ErResult;
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
//   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).GetCurrent(Value);
//// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TVoltmetr) then
////   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TVoltmetr).GetCurrent(Value);
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TRS232Meter) then
//   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TRS232Meter).GetCurrent(Value);
//end;


//{ TVoltageIV_MD }
//
//function TVoltageIV_MD.StringResult(data: double): string;
//begin
// Result:=FloatToStrF(data,ffFixed, 4, 3);
//end;
//
//{ TVoltageChannel_MD }
//
//function TVoltageChannel_MD.StringResult(data: double): string;
//begin
// Result:=FloatToStrF(data,ffFixed, 6, 4);
//end;

{ TDevice }

//procedure TDevice.Add(IO: TInterfacedObject);
//begin
//// showmessage(inttostr(High(fSetOfInterface)));
// SetLength(fSetOfInterface,High(fSetOfInterface)+2);
// fSetOfInterface[High(fSetOfInterface)]:=IO;
// if (fSetOfInterface[High(fSetOfInterface)] is TSimulator) then
//    DevicesComboBox.Items.Add((fSetOfInterface[High(fSetOfInterface)] as TSimulator).GetName);
//// if (fSetOfInterface[High(fSetOfInterface)] is TArduinoDevice) then
////    DevicesComboBox.Items.Add((fSetOfInterface[High(fSetOfInterface)] as TArduinoDevice).GetName);
// if (fSetOfInterface[High(fSetOfInterface)] is TRS232Device) then
//    DevicesComboBox.Items.Add((fSetOfInterface[High(fSetOfInterface)] as TRS232Device).GetName);
//// showmessage(inttostr(High(fSetOfInterface)));
//end;

//constructor TDevice.Create(const SOI: array of TInterfacedObject;
//                           DevCB: TComboBox);
//var
//  I: Integer;
//begin
// inherited Create;
//
// if High(SOI)<0 then Exit;
// DevicesComboBox:=DevCB;
// DevicesComboBox.Clear;
// SetLength(fSetOfInterface,High(SOI)+1);
//
//
// for I := 0 to High(SOI) do
//// Add(SOI[i]);
//  begin
//   fSetOfInterface[i]:=SOI[i];
//
//  if (fSetOfInterface[i] is TSimulator) then
//    DevicesComboBox.Items.Add((fSetOfInterface[i] as TSimulator).GetName);
////  if (fSetOfInterface[i] is TArduinoDevice) then
////    DevicesComboBox.Items.Add((fSetOfInterface[i] as TArduinoDevice).GetName);
//  if (fSetOfInterface[i] is TRS232Device) then
//    DevicesComboBox.Items.Add((fSetOfInterface[i] as TRS232Device).GetName);
//
//  end;
//
// DevicesComboBox.ItemIndex:=0;
//end;

constructor TDevice.Create(DevCB: TComboBox);
begin
 inherited Create;
 DevicesComboBox:=DevCB;
 DevicesComboBox.Clear;
end;

//function TDevice.GetActiveInterface: TInterfacedObject;
//begin
// if DevicesComboBox=nil then Result:=nil
//                    else
//     Result:=fSetOfInterface[DevicesComboBox.ItemIndex];
//
//end;

//procedure TDevice.DevicesComboBoxFilling(INameArray: array of IName);
//var
//  I: Integer;
//begin
// for I := 0 to High(INameArray) do
//   DevicesComboBox.Items.Add(INameArray[i].Name);
// if DevicesComboBox.Items.Count>0 then DevicesComboBox.ItemIndex:=0;
//end;

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

//function TSettingDevice.CalibrationStep(Voltage: double): double;
//begin
// Result:=0.01;
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
//   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).CalibrationStep(Voltage);
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TDACR2R) then
//   Result:=(fSetOfInterface[DevicesComboBox.ItemIndex] as TDACR2R).CalibrationStep(Voltage);
//end;

function TSettingDevice.CalibrationStep(Voltage: double): double;
begin
 Result:=0.01;
 ActiveInterface.CalibrationStep(Voltage);
end;

constructor TSettingDevice.Create(const SOI: array of IDAC; DevCB: TComboBox);
var I: Integer;
begin
 inherited Create(DevCB);
 if High(SOI)<0 then Exit;
 SetLength(fSetOfInterface,High(SOI)+1);
 for I := 0 to High(SOI) do
  begin
   DevicesComboBox.Items.Add(SOI[i].Name);
   fSetOfInterface[i]:=SOI[i];
  end;
 if DevicesComboBox.Items.Count>0 then DevicesComboBox.ItemIndex:=0;
end;

//procedure TSettingDevice.Free;
//begin
// SetLength(fSetOfInterface,0);
// inherited;
//end;

function TSettingDevice.GetActiveInterface: IDAC;
begin
  if DevicesComboBox=nil
   then Result:=nil
   else Result:=fSetOfInterface[DevicesComboBox.ItemIndex];
end;

//procedure TSettingDevice.Reset;
//begin
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
//   (fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).Reset();
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TDACR2R) then
//   (fSetOfInterface[DevicesComboBox.ItemIndex] as TDACR2R).Reset();
//end;

procedure TSettingDevice.Reset;
begin
 ActiveInterface.Reset;
end;

//procedure TSettingDevice.SetValue(Value: double);
//begin
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
//   (fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).Output(Value);
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TDACR2R) then
//   (fSetOfInterface[DevicesComboBox.ItemIndex] as TDACR2R).Output(Value);
//end;

procedure TSettingDevice.SetValue(Value: double);
begin
 ActiveInterface.Output(Value);
end;

//procedure TSettingDevice.SetValueCalibr(Value: double);
//begin
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TSimulator) then
//   (fSetOfInterface[DevicesComboBox.ItemIndex] as TSimulator).OutputCalibr(Value);
// if (fSetOfInterface[DevicesComboBox.ItemIndex] is TDACR2R) then
//   (fSetOfInterface[DevicesComboBox.ItemIndex] as TDACR2R).OutputCalibr(Value);
//end;

procedure TSettingDevice.SetValueCalibr(Value: double);
begin
ActiveInterface.OutputCalibr(Value);
end;

{ TDAC_Show }

//constructor TDAC_Show.Create(OI: TInterfacedObject;
constructor TDAC_Show.Create(OI: IDAC;
                               VL, KL: TLabel;
                               VCB, VSB, KCB,
                               KSB, RB: TButton);

begin
  fOutputInterface:=OI;
  ValueLabel:=VL;
  ValueLabel.Caption:='0';
  ValueLabel.Font.Color:=clBlack;
  ValueChangeButton:=VCB;
  ValueChangeButton.OnClick:=ValueChangeButtonAction;
  ValueSetButton:=VSB;
  ValueSetButton.OnClick:=ValueSetButtonAction;
  ResetButton:=RB;
  ResetButton.OnClick:=ResetButtonClick;
  KodLabel:=KL;
  KodLabel.Caption:='0';
  KodLabel.Font.Color:=clBlack;
  KodChangeButton:=KCB;
  KodChangeButton.OnClick:=KodChangeButtonAction;
  KodSetButton:=KSB;
  KodSetButton.OnClick:=KodSetButtonAction;
end;

procedure TDAC_Show.KodChangeButtonAction(Sender: TObject);
 var value:string;
begin
 if InputQuery('Value', 'Output kod is expect', value) then
  begin
    try
      KodLabel.Caption:=IntToStr(StrToInt(value));
      KodLabel.Font.Color:=clBlack;
    except

    end;
  end;

end;

//procedure TDAC_Show.KodSetButtonAction(Sender: TObject);
//begin
//   if (fOutputInterface is TDACR2R) then
//    (fOutputInterface as TDACR2R).OutputInt(StrToInt(KodLabel.Caption));
//   KodLabel.Font.Color:=clPurple;
//   ValueLabel.Font.Color:=clBlack;
//end;
//
//procedure TDAC_Show.ResetButtonClick(Sender: TObject);
//begin
// if (fOutputInterface is TDACR2R) then
//   (fOutputInterface as TDACR2R).Reset();
//   KodLabel.Font.Color:=clBlack;
//   ValueLabel.Font.Color:=clBlack;
//// (fOutputInterface as IDAC).Reset();
//end;

procedure TDAC_Show.KodSetButtonAction(Sender: TObject);
begin
   fOutputInterface.OutputInt(StrToInt(KodLabel.Caption));
   KodLabel.Font.Color:=clPurple;
   ValueLabel.Font.Color:=clBlack;
end;

procedure TDAC_Show.ResetButtonClick(Sender: TObject);
begin
 fOutputInterface.Reset();
   KodLabel.Font.Color:=clBlack;
   ValueLabel.Font.Color:=clBlack;
end;

procedure TDAC_Show.ValueChangeButtonAction(Sender: TObject);
 var value:string;
begin
 if InputQuery('Value', 'Output value is expect', value) then
  begin
    try
      ValueLabel.Caption:=FloatToStrF(StrToFloat(value),ffFixed, 6, 4);
      ValueLabel.Font.Color:=clBlack;
    except

    end;
  end;
end;

//procedure TDAC_Show.ValueSetButtonAction(Sender: TObject);
//begin
//   if (fOutputInterface is TDACR2R) then
//    (fOutputInterface as TDACR2R).Output(StrToFloat(ValueLabel.Caption));
//   ValueLabel.Font.Color:=clPurple;
//   KodLabel.Font.Color:=clBlack;
//end;

procedure TDAC_Show.ValueSetButtonAction(Sender: TObject);
begin
   fOutputInterface.Output(StrToFloat(ValueLabel.Caption));
   ValueLabel.Font.Color:=clPurple;
   KodLabel.Font.Color:=clBlack;
end;

{ TMeasuringDevice }

procedure TMeasuringDevice.ActionButtonOnClick(Sender: TObject);
begin
 try
   GetMeasurementResult();
 except
 end;
end;

procedure TMeasuringDevice.Add(IO: IMeasurement);
begin
 SetLength(fSetOfInterface,High(fSetOfInterface)+2);
 fSetOfInterface[High(fSetOfInterface)]:=IO;
 DevicesComboBox.Items.Add(fSetOfInterface[High(fSetOfInterface)].Name);
end;

procedure TMeasuringDevice.AddActionButton(AB: TButton);
begin
 ActionButton:=AB;
 ActionButton.OnClick:=ActionButtonOnClick;
end;

constructor TMeasuringDevice.Create(const SOI: array of IMeasurement;
                                    DevCB: TComboBox; RI: TLabel;
                                    SR:TMeasuringStringResult);
var I: Integer;
begin
 inherited Create(DevCB);
 if High(SOI)<0 then Exit;
 SetLength(fSetOfInterface,High(SOI)+1);
 for I := 0 to High(SOI) do
  begin
   DevicesComboBox.Items.Add(SOI[i].Name);
   fSetOfInterface[i]:=SOI[i];
  end;
 if DevicesComboBox.Items.Count>0 then DevicesComboBox.ItemIndex:=0;

 ResultIndicator:=RI;
 fStringResult:=SR;
end;


//procedure TMeasuringDevice.Free;
//begin
// SetLength(fSetOfInterface,0);
// inherited;
//end;

function TMeasuringDevice.GetActiveInterface: IMeasurement;
begin
 if DevicesComboBox=nil
   then Result:=nil
   else Result:=fSetOfInterface[DevicesComboBox.ItemIndex];
end;

function TMeasuringDevice.GetMeasurementResult(): double;
begin
 try
 Result:=GetResult();
 if ResultIndicator<>nil then
    case FStringResult of
      srCurrent: ResultIndicator.Caption:=FloatToStrF(Result,ffExponent, 4, 2);
      srVoltge:  ResultIndicator.Caption:=FloatToStrF(Result,ffFixed, 4, 3);
      srPreciseVoltage:ResultIndicator.Caption:=FloatToStrF(Result,ffFixed, 6, 4);
    end;
 finally

 end;
end;

function TMeasuringDevice.GetResult(): double;
begin
 Result:=GetActiveInterface.GetData();
end;

{ TTemperature_MD }

constructor TTemperature_MD.Create(const SOI: array of ITemperatureMeasurement;
                                   DevCB: TComboBox; RI: TLabel);
var I: Integer;
begin
 inherited Create(DevCB);
 if High(SOI)<0 then Exit;
 SetLength(fSetOfInterface,High(SOI)+1);
 for I := 0 to High(SOI) do
  begin
   DevicesComboBox.Items.Add(SOI[i].Name);
   fSetOfInterface[i]:=SOI[i];
  end;
 if DevicesComboBox.Items.Count>0 then DevicesComboBox.ItemIndex:=0;

 ResultIndicator:=RI;
end;

function TTemperature_MD.GetActiveInterface: ITemperatureMeasurement;
begin
 if DevicesComboBox=nil
   then Result:=nil
   else Result:=fSetOfInterface[DevicesComboBox.ItemIndex];
end;

function TTemperature_MD.GetMeasurementResult: double;
begin
 try
 Result:=GetResult();
 if ResultIndicator<>nil then
    ResultIndicator.Caption:=FloatToStrF(Result,ffFixed, 5, 2);
 finally

 end;
end;

function TTemperature_MD.GetResult: double;
begin
   Result:=GetActiveInterface.GetTemperature();
end;

end.
