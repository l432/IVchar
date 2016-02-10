unit Measurement;

interface

uses
  StdCtrls, Classes, IniFiles;

type

IMeasurement = interface
  ['{7A6DCE4C-9A04-444A-B7FD-39B800BDE6A7}']
 function GetTemperature:double;
 function GetVoltage(Vin:double):double;
 function GetCurrent(Vin:double):double;
end;

TSimulator = class (TInterfacedObject,IMeasurement)
private
public
 Constructor Create();
 function GetTemperature:double;
 function GetVoltage(Vin:double):double;
 function GetCurrent(Vin:double):double;
end;

TMeasuringDevice =class
private
// fActiveInterface:IMeasurement;
 fActiveInterfaceNumber:integer;
// fSetOfInterface:array of IMeasurement;
 fSetOfInterface:array of TInterfacedObject;
 SimulatorRadioBut,MeasurementRadioBut:TRadioButton;
 DevicesComboBox:TComboBox;
 ResultIndicator,DataForAction:TLabel;
 ActionButton:TButton;
 procedure DetermineInterface(Sender: TObject);
 procedure ActionButtonOnClick(Sender: TObject);
 procedure SetOnClickAction(Action: TNotifyEvent);
 function GetResult(Value:double):double;virtual;
 function StringResult(data:double):string;virtual;
 procedure SetVisualElementValue;
public
 Constructor Create(//const SOI:array of IMeasurement;
                    const SOI:array of TInterfacedObject;
                    SimRaB,MeaRB:TRadioButton;
                    DevCB:TComboBox;
                    RI:TLabel
                    );
// procedure Free;
 function GetMeasurementResult(Value: Double):double;
 procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
 procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
 procedure AddActionButton(AB:TButton;DFA:TLabel);
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


function T_CuKo(Voltage:double):double;
{функция расчета температури по значениям напряжения
согласно градуировке термопары медь-константан}

implementation

uses
  SysUtils, OlegType, SPIdevice;

{ Simulator }

constructor TSimulator.Create;
begin
 inherited Create;
end;

function TSimulator.GetCurrent(Vin: double): double;
begin
 sleep(300);
 Result:=4e-8*Vin;
// Result:=4e-11*Vin;
end;

function TSimulator.GetTemperature: double;
begin
 sleep(500);
 Result:=Random(4000)/10.0;
// Result:=300;
end;

function TSimulator.GetVoltage(Vin: double): double;
begin
 sleep(300);
 Result:=Vin;
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
 except
   value:=ErResult;
 end;
 GetMeasurementResult(Value);
end;

procedure TMeasuringDevice.AddActionButton(AB: TButton; DFA: TLabel);
begin
 ActionButton:=AB;
 ActionButton.OnClick:=ActionButtonOnClick;
 DataForAction:=DFA;
end;

constructor TMeasuringDevice.Create(//const SOI:array of IMeasurement;
                                    const SOI:array of TInterfacedObject;
                                    SimRaB,MeaRB: TRadioButton;
                                    DevCB: TComboBox;
                                    RI: TLabel);
var
  I: Integer;
begin
 inherited Create;
 SetLength(fSetOfInterface,High(SOI)+1);
 for I := 0 to High(SOI) do
  fSetOfInterface[i]:=SOI[i];
 SimulatorRadioBut:=SimRaB;
 MeasurementRadioBut:=MeaRB;
 DevicesComboBox:=DevCB;
 SetOnClickAction(DetermineInterface);

 ResultIndicator:=RI;
// fActiveInterface:=fSetOfInterface[0];
 fActiveInterfaceNumber:=0;

end;

procedure TMeasuringDevice.DetermineInterface(Sender: TObject);
begin
  if SimulatorRadioBut.Checked then
   begin
     fActiveInterfaceNumber:=0;
     DevicesComboBox.Enabled:=False;
   end;
  if MeasurementRadioBut.Checked then
   begin
     DevicesComboBox.Enabled:=True;
//     if True then
//
     fActiveInterfaceNumber:=DevicesComboBox.ItemIndex+1;
   end;
end;



//procedure TMeasuringDevice.Free;
// var  I: Integer;
//begin
// SetLength(fSetOfInterface,0);
// for I := 0 to High(fSetOfInterface) do
//  fSetOfInterface[i]:=nil;
//end;

function TMeasuringDevice.GetMeasurementResult(Value: Double): double;
begin
 try
 Result:=GetResult(Value);
 if ResultIndicator<>nil then
    ResultIndicator.Caption:=StringResult(Result);
 finally

 end;
end;

function TMeasuringDevice.GetResult(Value: double): double;
begin
 Result:=ErResult;
 if (fSetOfInterface[fActiveInterfaceNumber] is TSimulator) then
   Result:=(fSetOfInterface[fActiveInterfaceNumber] as TSimulator).GetVoltage(Value);
 if (fSetOfInterface[fActiveInterfaceNumber] is TVoltmetr) then
   Result:=(fSetOfInterface[fActiveInterfaceNumber] as TVoltmetr).GetVoltage(Value);

//  Result:=(fSetOfInterface[fActiveInterfaceNumber] as IMeasurement).GetVoltage(Value);
end;

procedure TMeasuringDevice.SetVisualElementValue;
begin
 SetOnClickAction(nil);
 if fActiveInterfaceNumber=0 then
  begin
   SimulatorRadioBut.Checked:=True;
   DevicesComboBox.Enabled:=False;
  end
                             else
  begin
   MeasurementRadioBut.Checked:=True;
   DevicesComboBox.Enabled:=True;
   try
     DevicesComboBox.ItemIndex:=fActiveInterfaceNumber-1;
   except
     DevicesComboBox.ItemIndex:=-1;
   end;
  end;
 SetOnClickAction(DetermineInterface);
end;


function TMeasuringDevice.StringResult(data: double): string;
begin
 Result:=FloatToStrF(data,ffExponent, 4, 2);
end;

procedure TMeasuringDevice.ReadFromIniFile(ConfigFile: TIniFile; const Section,
  Ident: string);
begin
  fActiveInterfaceNumber:=ConfigFile.ReadInteger(Section, Ident, 0);
  SetVisualElementValue;
end;

procedure TMeasuringDevice.WriteToIniFile(ConfigFile: TIniFile; const Section,
  Ident: string);
begin
  WriteIniDef(ConfigFile,Section, Ident,fActiveInterfaceNumber,0);
end;

procedure TMeasuringDevice.SetOnClickAction(Action: TNotifyEvent);
begin
  SimulatorRadioBut.OnClick := Action;
  MeasurementRadioBut.OnClick := Action;
  DevicesComboBox.OnChange := Action;
end;

{ TTemperatureMD }

//function TTemperatureMD.GetMeasurementResult: double;
//begin
// try
// Result:=fSetOfInterface[fActiveInterfaceNumber].GetTemperature;
// if ResultIndicator<>nil then
//    ResultIndicator.Caption:=StringResult(Result);
// finally
//
// end;
//end;

function TTemperature_MD.GetResult(Value: double): double;
begin
  Result:=ErResult;
 if (fSetOfInterface[fActiveInterfaceNumber] is TSimulator) then
   Result:=(fSetOfInterface[fActiveInterfaceNumber] as TSimulator).GetTemperature();
 if (fSetOfInterface[fActiveInterfaceNumber] is TVoltmetr) then
   Result:=(fSetOfInterface[fActiveInterfaceNumber] as TVoltmetr).GetTemperature();
// Result:=(fSetOfInterface[fActiveInterfaceNumber] as IMeasurement).GetTemperature();
end;

function TTemperature_MD.StringResult(data: double): string;
begin
  Result:=FloatToStrF(data,ffFixed, 4, 1);
end;

{ TCurrentMD }

function TCurrent_MD.GetResult(Value: double): double;
begin
 Result:=ErResult;
 if (fSetOfInterface[fActiveInterfaceNumber] is TSimulator) then
   Result:=(fSetOfInterface[fActiveInterfaceNumber] as TSimulator).GetCurrent(Value);
 if (fSetOfInterface[fActiveInterfaceNumber] is TVoltmetr) then
   Result:=(fSetOfInterface[fActiveInterfaceNumber] as TVoltmetr).GetCurrent(Value);
// Result:=(fSetOfInterface[fActiveInterfaceNumber] as IMeasurement).GetCurrent(Value);
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

end.
