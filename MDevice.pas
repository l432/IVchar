unit MDevice;

interface

uses
  StdCtrls, IniFiles, Measurement;

type
TDevice=class
private
 DevicesComboBox:TComboBox;
 fIdentName:string;
public
 Constructor Create(DevCB: TComboBox; IdentName: string);
// procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
// procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
 procedure ReadFromIniFile(ConfigFile:TIniFile;const Section: string);
 procedure WriteToIniFile(ConfigFile:TIniFile;const Section: string);
end;

TMeasuringStringResult=(srCurrent,srVoltge,srPreciseVoltage);
 {����, ���� ������� �� �������� �� ���� ���������� �����}

TMeasuringDevice =class(TDevice)
private
 fSetOfInterface:array of IMeasurement;
 fStringResult:TMeasuringStringResult;
 ResultIndicator:TLabel;
 ActionButton:TButton;
 procedure ActionButtonOnClick(Sender: TObject);
 function GetResult():double;virtual;
 function GetActiveInterface():IMeasurement;virtual;
public
 property ActiveInterface:IMeasurement read GetActiveInterface;
 Constructor Create(const SOI: array of IMeasurement;
                  DevCB: TComboBox; IdentName: string;
                  RI: TLabel; SR: TMeasuringStringResult);
 function GetMeasurementResult():double;
 procedure AddActionButton(AB:TButton);
 procedure Add(IO:IMeasurement);
end;

TMeasuringDeviceSimple =class(TMeasuringDevice)
 private
  function GetActiveInterface():IMeasurement;override;
 public
 Constructor Create(const Measurement:IMeasurement;
                  RI: TLabel; SR: TMeasuringStringResult;
                  AB:TButton);
end;

TSettingDevice =class(TDevice)
private
 fSetOfInterface:array of IDAC;
 function GetActiveInterface():IDAC;
public
 property ActiveInterface:IDAC read GetActiveInterface;
 Constructor Create(const SOI:array of IDAC;
                    DevCB:TComboBox; IdentName: string);
 procedure SetValue(Value:double);
 procedure Reset();
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
                    DevCB:TComboBox; IdentName: string;
                    RI:TLabel);
 function GetMeasurementResult():double;
end;



implementation

uses
  OlegType, SysUtils;

{ TDevice }

constructor TDevice.Create(DevCB: TComboBox; IdentName: string);
begin
 inherited Create;
 DevicesComboBox:=DevCB;
 DevicesComboBox.Clear;
 fIdentName:=IdentName;
end;

procedure TDevice.ReadFromIniFile(ConfigFile: TIniFile; const Section: string);
  var index:integer;
begin
  index:=ConfigFile.ReadInteger(Section, fIdentName, 0);
  if index>=DevicesComboBox.Items.Count
     then DevicesComboBox.ItemIndex:=0
     else DevicesComboBox.ItemIndex:=index;
end;


procedure TDevice.WriteToIniFile(ConfigFile: TIniFile; const Section: string);
begin
  WriteIniDef(ConfigFile,Section, fIdentName,DevicesComboBox.ItemIndex,0);
end;

{ TSettingDevice }

constructor TSettingDevice.Create(const SOI: array of IDAC;
                               DevCB: TComboBox;IdentName: string);
var I: Integer;
begin
 inherited Create(DevCB,IdentName);
 if High(SOI)<0 then Exit;
 SetLength(fSetOfInterface,High(SOI)+1);
 for I := 0 to High(SOI) do
  begin
   DevicesComboBox.Items.Add(SOI[i].Name);
   fSetOfInterface[i]:=SOI[i];
  end;
 if DevicesComboBox.Items.Count>0 then DevicesComboBox.ItemIndex:=0;
end;

function TSettingDevice.GetActiveInterface: IDAC;
begin
  if DevicesComboBox=nil
   then Result:=nil
   else Result:=fSetOfInterface[DevicesComboBox.ItemIndex];
end;

procedure TSettingDevice.Reset;
begin
 ActiveInterface.Reset;
end;

procedure TSettingDevice.SetValue(Value: double);
begin
 ActiveInterface.Output(Value);
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
                            DevCB: TComboBox; IdentName: string;
                            RI: TLabel; SR: TMeasuringStringResult);
var I: Integer;
begin
 inherited Create(DevCB,IdentName);
 if High(SOI)<0 then Exit;
 SetLength(fSetOfInterface,High(SOI)+1);
 for I := 0 to High(SOI) do
  begin
   DevicesComboBox.Items.Add(SOI[i].Name);
   fSetOfInterface[i]:=SOI[i];
  end;
// if DevicesComboBox<>nil then
//   begin
//   for I := 0 to High(SOI) do
//        DevicesComboBox.Items.Add(SOI[i].Name);
  if DevicesComboBox.Items.Count>0 then DevicesComboBox.ItemIndex:=0;
//   end;

 ResultIndicator:=RI;
 fStringResult:=SR;
end;

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
                                   DevCB: TComboBox; IdentName: string; RI: TLabel);
var I: Integer;
begin
 inherited Create(DevCB,IdentName);
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



{ TMeasuringDeviceSimple }

constructor TMeasuringDeviceSimple.Create(const Measurement: IMeasurement;
                    RI: TLabel; SR: TMeasuringStringResult; AB: TButton);
begin
 if Measurement=nil then Exit;
 SetLength(fSetOfInterface,1);
 fSetOfInterface[0]:=Measurement;
 ResultIndicator:=RI;
 fStringResult:=SR;
 AddActionButton(AB);
end;


function TMeasuringDeviceSimple.GetActiveInterface: IMeasurement;
begin
 Result:=fSetOfInterface[0];
end;

end.
