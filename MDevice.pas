unit MDevice;

interface

uses
  StdCtrls, IniFiles, Measurement, OlegTypePart2, OlegType;


type

TArrIMeas=class
 private
  fSetOfInterface:array of Pointer;
  function  GetHighIndex:integer;
  function  GetMeasurement(Index:Integer):IMeasurement;
  function  GetMeasurementName(Index:Integer):string;
 public
  property HighIndex:integer read GetHighIndex;
  property Measurement[Index:Integer]:IMeasurement read GetMeasurement;
  property MeasurementName[Index:Integer]:string read GetMeasurementName;
  Constructor Create(const SOI: array of IMeasurement);overload;
  Constructor Create;overload;
  procedure Add(const IO:IMeasurement);
end;

TDevice=class(TNamedInterfacedObject)
private
 DevicesComboBox:TComboBox;
 fHookParameterChange: TSimpleEvent;
 fSetOfInterface:array of Pointer;
 procedure ParameterChange(Sender: TObject);virtual;
public
 property HookParameterChange:TSimpleEvent read fHookParameterChange write fHookParameterChange;
 Constructor Create(DevCB: TComboBox; IdentName: string);overload;
// Constructor Create(const SOI: array of IName;
//                    DevCB: TComboBox; IdentName: string);
// Constructor Create(const SOI: array of Pointer;
//                    DevCB: TComboBox; IdentName: string);overload;
 procedure ReadFromIniFile(ConfigFile: TIniFile);override;
 procedure WriteToIniFile(ConfigFile: TIniFile);override;
// procedure Free;
end;

TMeasuringStringResult=(srCurrent,srVoltge,srPreciseVoltage);
 {клас, який визначає як виводити на мітку результати виміру}

TMeasuringDevice =class(TDevice)
private
// fSetOfInterface:array of IMeasurement;
// fSetOfInterface:array of Pointer;
 fStringResult:TMeasuringStringResult;
 ResultIndicator:TLabel;
 ActionButton:TButton;
 procedure ActionButtonOnClick(Sender: TObject);
// function GetResult():double;virtual;
 function GetActiveInterface():IMeasurement;virtual;
public
 property ActiveInterface:IMeasurement read GetActiveInterface;
 Constructor Create(const SOI: array of IMeasurement;
                  DevCB: TComboBox; IdentName: string;
                  RI: TLabel; SR: TMeasuringStringResult);overload;
// Constructor Create(const SOI: array of Pointer;
//                    DevCB: TComboBox; IdentName: string;
//                  RI: TLabel; SR: TMeasuringStringResult);overload;
 function GetResult():double;virtual;
 function GetMeasurementResult():double;
 procedure AddActionButton(AB:TButton);
 procedure Add(IO:IMeasurement);
 procedure Free;
end;

TMeasuringDeviceSimple =class(TMeasuringDevice)
 private
  function GetActiveInterface():IMeasurement;override;
 public
 Constructor Create(const Measurement:IMeasurement;
                  RI: TLabel; SR: TMeasuringStringResult;
                  AB:TButton);
 procedure Free;
end;

TSettingDevice =class(TDevice)
private
// fSetOfInterface:array of IDAC;
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
// fSetOfInterface:array of ITemperatureMeasurement;
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
  SysUtils;

{ TDevice }

constructor TDevice.Create(DevCB: TComboBox; IdentName: string);
//Constructor TDevice.Create(const SOI: array of IName;
//                           DevCB: TComboBox; IdentName: string);
// var i:integer;
begin
 inherited Create;
 if DevCB<>nil then
 begin
   DevicesComboBox:=DevCB;
   DevicesComboBox.Clear;
   DevicesComboBox.OnChange:=ParameterChange;
 end;
 fName:=IdentName;
 HookParameterChange:=TSimpleClass.EmptyProcedure;


// if High(SOI)<0 then Exit;
// SetLength(fSetOfInterface,High(SOI)+1);
// for I := 0 to High(SOI) do
//  begin
//   if DevicesComboBox<>nil then DevicesComboBox.Items.Add(SOI[i].Name);
//   fSetOfInterface[i] := Pointer(SOI[i]);
//  end;
//
//  if (DevicesComboBox<>nil)and
//     (DevicesComboBox.Items.Count>0) then DevicesComboBox.ItemIndex:=0;

end;

//procedure TDevice.Free;
//begin
// inherited;
//end;

//constructor TDevice.Create(const SOI: array of Pointer; DevCB: TComboBox;
//  IdentName: string);
// var i:integer;
//begin
// Create(DevCB,IdentName);
// if High(SOI)<0 then Exit;
// SetLength(fSetOfInterface,High(SOI)+1);
// for I := 0 to High(SOI) do
//  begin
//   fSetOfInterface[i] := SOI[i];
//   if DevicesComboBox<>nil
//     then DevicesComboBox.Items.Add(IMeasurement(fSetOfInterface[i]).Name);
//  end;
//
//  if (DevicesComboBox<>nil)and
//     (DevicesComboBox.Items.Count>0) then DevicesComboBox.ItemIndex:=0;
//end;

procedure TDevice.ParameterChange(Sender: TObject);
begin
 try
 HookParameterChange;
 finally
 end;
end;

procedure TDevice.ReadFromIniFile(ConfigFile: TIniFile);
  var index:integer;
begin
  index:=ConfigFile.ReadInteger('Dev'+fName, fName, 0);
  if index>=DevicesComboBox.Items.Count
     then DevicesComboBox.ItemIndex:=0
     else DevicesComboBox.ItemIndex:=index;
end;


procedure TDevice.WriteToIniFile(ConfigFile: TIniFile);
begin
  ConfigFile.EraseSection('Dev'+fName);
  WriteIniDef(ConfigFile,'Dev'+fName, fName,DevicesComboBox.ItemIndex,0);
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
//   if DevicesComboBox<>nil then DevicesComboBox.Items.Add(IMeasurement(fSetOfInterface[i]).Name);
   fSetOfInterface[i] := Pointer(SOI[i]);
   if DevicesComboBox<>nil then DevicesComboBox.Items.Add(IMeasurement(fSetOfInterface[i]).Name);
  end;

// if High(SOI)<0 then Exit;
// SetLength(fSetOfInterface,High(SOI)+1);
// for I := 0 to High(SOI) do
//  begin
//   DevicesComboBox.Items.Add(SOI[i].Name);
//   fSetOfInterface[i]:=SOI[i];
//  end;
  if (DevicesComboBox<>nil)and
     (DevicesComboBox.Items.Count>0) then DevicesComboBox.ItemIndex:=0;
end;

function TSettingDevice.GetActiveInterface: IDAC;
begin
  if DevicesComboBox=nil
   then Result:=nil
//   else Result:=fSetOfInterface[DevicesComboBox.ItemIndex];
   else Result:=IDAC(fSetOfInterface[DevicesComboBox.ItemIndex]);

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
// fSetOfInterface[High(fSetOfInterface)]:=IO;
// DevicesComboBox.Items.Add(fSetOfInterface[High(fSetOfInterface)].Name);
 fSetOfInterface[High(fSetOfInterface)]:=Pointer(IO);
 DevicesComboBox.Items.Add(IMeasurement(fSetOfInterface[High(fSetOfInterface)]).Name);
end;

procedure TMeasuringDevice.AddActionButton(AB: TButton);
begin
 ActionButton:=AB;
 ActionButton.OnClick:=ActionButtonOnClick;
end;

//constructor TMeasuringDevice.Create(const SOI: array of Pointer;
//                             DevCB: TComboBox; IdentName: string;
//                             RI: TLabel; SR: TMeasuringStringResult);
//begin
// inherited Create(SOI,DevCB,IdentName);
// ResultIndicator:=RI;
// fStringResult:=SR;
//end;

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
   fSetOfInterface[i] := Pointer(SOI[i]);
   if DevicesComboBox<>nil then DevicesComboBox.Items.Add(IMeasurement(fSetOfInterface[i]).Name);
  end;

  if (DevicesComboBox<>nil)and
     (DevicesComboBox.Items.Count>0) then DevicesComboBox.ItemIndex:=0;

 ResultIndicator:=RI;
 fStringResult:=SR;
end;

procedure TMeasuringDevice.Free;
// var i:integer;
begin
// for I := 0 to High(fSetOfInterface) do  fSetOfInterface[i]:=nil;
// SetLength(fSetOfInterface,0);
// ResultIndicator:=nil;
// ActionButton:=nil;

 inherited;
end;

function TMeasuringDevice.GetActiveInterface: IMeasurement;
begin
 if DevicesComboBox=nil
   then Result:=nil
//   else Result:=fSetOfInterface[DevicesComboBox.ItemIndex];
   else Result:=IMeasurement(fSetOfInterface[DevicesComboBox.ItemIndex]);
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
   if DevicesComboBox<>nil then DevicesComboBox.Items.Add(SOI[i].Name);
   fSetOfInterface[i] := Pointer(SOI[i]);
  end;

// if High(SOI)<0 then Exit;
// SetLength(fSetOfInterface,High(SOI)+1);
// for I := 0 to High(SOI) do
//  begin
//   DevicesComboBox.Items.Add(SOI[i].Name);
//   fSetOfInterface[i]:=SOI[i];
//  end;
  if (DevicesComboBox<>nil)and
     (DevicesComboBox.Items.Count>0) then DevicesComboBox.ItemIndex:=0;

 ResultIndicator:=RI;
end;

function TTemperature_MD.GetActiveInterface: ITemperatureMeasurement;
begin
 if DevicesComboBox=nil
   then Result:=nil
//   else Result:=fSetOfInterface[DevicesComboBox.ItemIndex];
   else Result:=ITemperatureMeasurement(fSetOfInterface[DevicesComboBox.ItemIndex]);
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

 inherited Create([Measurement],nil,'',RI,SR);


// SetLength(fSetOfInterface,1);
// fSetOfInterface[0]:=Pointer(Measurement);
// ResultIndicator:=RI;
// fStringResult:=SR;

 AddActionButton(AB);

end;


procedure TMeasuringDeviceSimple.Free;
begin
 inherited;
end;

function TMeasuringDeviceSimple.GetActiveInterface: IMeasurement;
begin
 Result:=IMeasurement(fSetOfInterface[0])
// Result:=fSetOfInterface[0];
end;

{ TArrIMeas }

constructor TArrIMeas.Create(const SOI: array of IMeasurement);
var I: Integer;
begin
 if High(SOI)<0 then Exit;
 SetLength(fSetOfInterface,High(SOI)+1);
 for I := 0 to High(SOI) do
   fSetOfInterface[i] := Pointer(SOI[i]);
 inherited Create;
end;

procedure TArrIMeas.Add(const IO: IMeasurement);
begin
  SetLength(fSetOfInterface,High(fSetOfInterface)+2);
  fSetOfInterface[High(fSetOfInterface)]:=Pointer(IO);
end;

constructor TArrIMeas.Create;
begin
 inherited;
end;

function TArrIMeas.GetHighIndex: integer;
begin
 Result:=High(fSetOfInterface);
end;

function TArrIMeas.GetMeasurement(Index: Integer): IMeasurement;
begin
 if (Index<0) or (Index>HighIndex)
   then Result:=nil
   else Result:=IMeasurement(fSetOfInterface[Index]);
end;

function TArrIMeas.GetMeasurementName(Index: Integer): string;
begin
 if (Index<0) or (Index>HighIndex)
   then Result:=''
   else Result:=IMeasurement(fSetOfInterface[Index]).Name;
end;

end.
