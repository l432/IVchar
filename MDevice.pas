unit MDevice;

interface

uses
  StdCtrls, IniFiles, Measurement, OlegTypePart2, OlegType;


type

TArrI=class(TNamedInterfacedObject)
 private
//  fSetOfInterface:array of Pointer;
  function  GetHighIndex:integer;
  function  GetMeasurementName(Index:Integer):string;
 protected
  fSetOfInterface:array of Pointer;
 public
  property HighIndex:integer read GetHighIndex;
  property MeasurementName[Index:Integer]:string read GetMeasurementName;
end;

TArrIMeas=class(TArrI)
 private
  function  GetMeasurement(Index:Integer):IMeasurement;
 public
  property Measurement[Index:Integer]:IMeasurement read GetMeasurement;
  Constructor Create(const SOI: array of IMeasurement);
  procedure Add(const IO:IMeasurement);overload;
  procedure Add(const SOI:array of IMeasurement);overload;
end;


//TArrIDAC=class(TArrI)
// private
//  function  GetDAC(Index:Integer):IDAC;
// public
//  property DAC[Index:Integer]:IDAC read GetDAC;
//  Constructor Create(const SOI: array of IDAC);
//  procedure Add(const IO:IDAC);overload;
//  procedure Add(const SOI:array of IDAC);overload;
//end;

TArrIDAC=class(TArrI)
 private
  function  GetDAC(Index:Integer):ISource;
 public
  property DAC[Index:Integer]:ISource read GetDAC;
  Constructor Create(const SOI: array of ISource);
  procedure Add(const IO:ISource);overload;
  procedure Add(const SOI:array of ISource);overload;
end;

TArrITempMeas=class(TArrI)
 private
  function  GetTempMeas(Index:Integer):ITemperatureMeasurement;
 public
  property TemperatureMeasurement[Index:Integer]:ITemperatureMeasurement read GetTempMeas;
  Constructor Create(const SOI: array of ITemperatureMeasurement);
  procedure Add(const IO:ITemperatureMeasurement);overload;
  procedure Add(const SOI:array of ITemperatureMeasurement);overload;

end;


TDevice=class(TNamedInterfacedObject)
private
 DevicesComboBox:TComboBox;
 fHookParameterChange: TSimpleEvent;
// fSetOfInterface:array of Pointer;
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
 {����, ���� ������� �� �������� �� ���� ���������� �����}

TMeasuringDevice =class(TDevice)
private
 fArrIMeas:TArrIMeas;
 fStringResult:TMeasuringStringResult;
 ResultIndicator:TLabel;
 ActionButton:TButton;
 procedure ActionButtonOnClick(Sender: TObject);
 function GetActiveInterface():IMeasurement;virtual;
public
 property ActiveInterface:IMeasurement read GetActiveInterface;
 Constructor Create(ArrIMeas:TArrIMeas;
                  DevCB: TComboBox; IdentName: string;
                  RI: TLabel; SR: TMeasuringStringResult);overload;
 function GetResult():double;virtual;
 function GetMeasurementResult():double;
 procedure AddActionButton(AB:TButton);
 procedure Add(IO:IMeasurement);
end;



//TMeasuringDevice =class(TDevice)
//private
//// fSetOfInterface:array of IMeasurement;
//// fSetOfInterface:array of Pointer;
// fStringResult:TMeasuringStringResult;
// ResultIndicator:TLabel;
// ActionButton:TButton;
// procedure ActionButtonOnClick(Sender: TObject);
//// function GetResult():double;virtual;
// function GetActiveInterface():IMeasurement;virtual;
//public
// property ActiveInterface:IMeasurement read GetActiveInterface;
// Constructor Create(const SOI: array of IMeasurement;
//                  DevCB: TComboBox; IdentName: string;
//                  RI: TLabel; SR: TMeasuringStringResult);overload;
//// Constructor Create(const SOI: array of Pointer;
////                    DevCB: TComboBox; IdentName: string;
////                  RI: TLabel; SR: TMeasuringStringResult);overload;
// function GetResult():double;virtual;
// function GetMeasurementResult():double;
// procedure AddActionButton(AB:TButton);
// procedure Add(IO:IMeasurement);
// procedure Free;
//end;

TMeasuringDeviceSimple =class(TMeasuringDevice)
 private
  function GetActiveInterface():IMeasurement;override;
 public
 Constructor Create(const Measurement:IMeasurement;
                  RI: TLabel; SR: TMeasuringStringResult;
                  AB:TButton);
 destructor Destroy;override;
end;

TSettingDevice =class(TDevice)
private
 fArrIDAC:TArrIDAC;
// function GetActiveInterface():IDAC;
 function GetActiveInterface():ISource;
public
 property ActiveInterface:ISource read GetActiveInterface;
// property ActiveInterface:IDAC read GetActiveInterface;
 Constructor Create(ArrIDAC:TArrIDAC;
                    DevCB:TComboBox; IdentName: string);
 procedure SetValue(Value:double);
 procedure Reset();
end;

TTemperature_MD =class(TDevice)
private
// fSetOfInterface:array of ITemperatureMeasurement;
 fArrITempMeas:TArrITempMeas;
 ResultIndicator:TLabel;
 function GetResult():double;virtual;
 function GetActiveInterface():ITemperatureMeasurement;
public
 property ActiveInterface:ITemperatureMeasurement read GetActiveInterface;
// Constructor Create(const SOI:array of ITemperatureMeasurement;
 Constructor Create(ArrITempMeas:TArrITempMeas;
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

constructor TSettingDevice.Create(ArrIDAC:TArrIDAC;
                               DevCB: TComboBox;IdentName: string);
var I: Integer;
begin
 inherited Create(DevCB,IdentName);
 fArrIDAC:=ArrIDAC;

 if fArrIDAC.HighIndex<0 then Exit;
 for I := 0 to fArrIDAC.HighIndex do
   if DevicesComboBox<>nil
     then DevicesComboBox.Items.Add(fArrIDAC.MeasurementName[i]);

  if (DevicesComboBox<>nil)and
     (DevicesComboBox.Items.Count>0) then DevicesComboBox.ItemIndex:=0;
end;

function TSettingDevice.GetActiveInterface: ISource;
begin
 if DevicesComboBox=nil
   then Result:=nil
   else Result:=fArrIDAC.DAC[DevicesComboBox.ItemIndex];
end;
//function TSettingDevice.GetActiveInterface: IDAC;
//begin
// if DevicesComboBox=nil
//   then Result:=nil
//   else Result:=fArrIDAC.DAC[DevicesComboBox.ItemIndex];
//end;

procedure TSettingDevice.Reset;
begin
 ActiveInterface.Reset;
end;

procedure TSettingDevice.SetValue(Value: double);
begin
 ActiveInterface.Output(Value);
end;

//{ TMeasuringDevice }
//
//procedure TMeasuringDevice.ActionButtonOnClick(Sender: TObject);
//begin
// try
//   GetMeasurementResult();
// except
// end;
//end;
//
//procedure TMeasuringDevice.Add(IO: IMeasurement);
//begin
// SetLength(fSetOfInterface,High(fSetOfInterface)+2);
//// fSetOfInterface[High(fSetOfInterface)]:=IO;
//// DevicesComboBox.Items.Add(fSetOfInterface[High(fSetOfInterface)].Name);
// fSetOfInterface[High(fSetOfInterface)]:=Pointer(IO);
// DevicesComboBox.Items.Add(IMeasurement(fSetOfInterface[High(fSetOfInterface)]).Name);
//end;
//
//procedure TMeasuringDevice.AddActionButton(AB: TButton);
//begin
// ActionButton:=AB;
// ActionButton.OnClick:=ActionButtonOnClick;
//end;
//
////constructor TMeasuringDevice.Create(const SOI: array of Pointer;
////                             DevCB: TComboBox; IdentName: string;
////                             RI: TLabel; SR: TMeasuringStringResult);
////begin
//// inherited Create(SOI,DevCB,IdentName);
//// ResultIndicator:=RI;
//// fStringResult:=SR;
////end;
//
//constructor TMeasuringDevice.Create(const SOI: array of IMeasurement;
//                            DevCB: TComboBox; IdentName: string;
//                            RI: TLabel; SR: TMeasuringStringResult);
//var I: Integer;
//begin
//
// inherited Create(DevCB,IdentName);
//
// if High(SOI)<0 then Exit;
// SetLength(fSetOfInterface,High(SOI)+1);
// for I := 0 to High(SOI) do
//  begin
//   fSetOfInterface[i] := Pointer(SOI[i]);
//   if DevicesComboBox<>nil then DevicesComboBox.Items.Add(IMeasurement(fSetOfInterface[i]).Name);
//  end;
//
//  if (DevicesComboBox<>nil)and
//     (DevicesComboBox.Items.Count>0) then DevicesComboBox.ItemIndex:=0;
//
// ResultIndicator:=RI;
// fStringResult:=SR;
//end;
//
//procedure TMeasuringDevice.Free;
//// var i:integer;
//begin
//// for I := 0 to High(fSetOfInterface) do  fSetOfInterface[i]:=nil;
//// SetLength(fSetOfInterface,0);
//// ResultIndicator:=nil;
//// ActionButton:=nil;
//
// inherited;
//end;
//
//function TMeasuringDevice.GetActiveInterface: IMeasurement;
//begin
// if DevicesComboBox=nil
//   then Result:=nil
////   else Result:=fSetOfInterface[DevicesComboBox.ItemIndex];
//   else Result:=IMeasurement(fSetOfInterface[DevicesComboBox.ItemIndex]);
//end;
//
//function TMeasuringDevice.GetMeasurementResult(): double;
//begin
// try
// Result:=GetResult();
// if ResultIndicator<>nil then
//    case FStringResult of
//      srCurrent: ResultIndicator.Caption:=FloatToStrF(Result,ffExponent, 4, 2);
//      srVoltge:  ResultIndicator.Caption:=FloatToStrF(Result,ffFixed, 4, 3);
//      srPreciseVoltage:ResultIndicator.Caption:=FloatToStrF(Result,ffFixed, 6, 4);
//    end;
// finally
//
// end;
//end;
//
//function TMeasuringDevice.GetResult(): double;
//begin
// Result:=GetActiveInterface.GetData();
//end;

{ TTemperature_MD }

//constructor TTemperature_MD.Create(const SOI: array of ITemperatureMeasurement;
constructor TTemperature_MD.Create(ArrITempMeas:TArrITempMeas;
                                   DevCB: TComboBox; IdentName: string; RI: TLabel);
var I: Integer;
begin

 inherited Create(DevCB,IdentName);
 fArrITempMeas:=ArrITempMeas;
 ResultIndicator:=RI;

 if fArrITempMeas.HighIndex<0 then Exit;
 for I := 0 to fArrITempMeas.HighIndex do
   if DevicesComboBox<>nil
     then DevicesComboBox.Items.Add(fArrITempMeas.MeasurementName[i]);

  if (DevicesComboBox<>nil)and
     (DevicesComboBox.Items.Count>0) then DevicesComboBox.ItemIndex:=0;



// inherited Create(DevCB,IdentName);
//
// if High(SOI)<0 then Exit;
// SetLength(fSetOfInterface,High(SOI)+1);
// for I := 0 to High(SOI) do
//  begin
//   if DevicesComboBox<>nil then DevicesComboBox.Items.Add(SOI[i].Name);
//   fSetOfInterface[i] := Pointer(SOI[i]);
//  end;
//
//// if High(SOI)<0 then Exit;
//// SetLength(fSetOfInterface,High(SOI)+1);
//// for I := 0 to High(SOI) do
////  begin
////   DevicesComboBox.Items.Add(SOI[i].Name);
////   fSetOfInterface[i]:=SOI[i];
////  end;
//  if (DevicesComboBox<>nil)and
//     (DevicesComboBox.Items.Count>0) then DevicesComboBox.ItemIndex:=0;
//
// ResultIndicator:=RI;
end;

function TTemperature_MD.GetActiveInterface: ITemperatureMeasurement;
begin
  if DevicesComboBox=nil
   then Result:=nil
   else Result:=fArrITempMeas.TemperatureMeasurement[DevicesComboBox.ItemIndex];

// if DevicesComboBox=nil
//   then Result:=nil
////   else Result:=fSetOfInterface[DevicesComboBox.ItemIndex];
//   else Result:=ITemperatureMeasurement(fSetOfInterface[DevicesComboBox.ItemIndex]);
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

//procedure TMeasuringDeviceSimple.ActionButtonOnClick(Sender: TObject);
//begin
// try
//   GetMeasurementResult();
// except
// end;
//end;

//procedure TMeasuringDeviceSimple.AddActionButton(AB: TButton);
//begin
// ActionButton:=AB;
// ActionButton.OnClick:=ActionButtonOnClick;
//end;

constructor TMeasuringDeviceSimple.Create(const Measurement: IMeasurement;
                    RI: TLabel; SR: TMeasuringStringResult; AB: TButton);
begin
// fInterface := Pointer(Measurement);
// ResultIndicator:=RI;
// fStringResult:=SR;


 HookParameterChange:=TSimpleClass.EmptyProcedure;

 if Measurement=nil then Exit;

// inherited Create([Measurement],nil,'',RI,SR);

 fArrIMeas:=TArrIMeas.Create([Measurement]);
 ResultIndicator:=RI;
 fStringResult:=SR;


// SetLength(fSetOfInterface,1);
// fSetOfInterface[0]:=Pointer(Measurement);
// ResultIndicator:=RI;
// fStringResult:=SR;

 AddActionButton(AB);

end;


//procedure TMeasuringDeviceSimple.Free;
//begin
// inherited;
//end;

destructor TMeasuringDeviceSimple.Destroy;
begin
  fArrIMeas.Free;
  inherited;
end;

function TMeasuringDeviceSimple.GetActiveInterface: IMeasurement;
begin
// Result:=IMeasurement(fInterface);

 Result:=fArrIMeas.Measurement[0];
// Result:=IMeasurement(fSetOfInterface[0])
// Result:=fSetOfInterface[0];
end;

//function TMeasuringDeviceSimple.GetMeasurementResult: double;
//begin
// try
// Result:=GetResult();
// if ResultIndicator<>nil then
//    case FStringResult of
//      srCurrent: ResultIndicator.Caption:=FloatToStrF(Result,ffExponent, 4, 2);
//      srVoltge:  ResultIndicator.Caption:=FloatToStrF(Result,ffFixed, 4, 3);
//      srPreciseVoltage:ResultIndicator.Caption:=FloatToStrF(Result,ffFixed, 6, 4);
//    end;
// finally
//
// end;
//end;
//
//function TMeasuringDeviceSimple.GetResult: double;
//begin
//   Result:=GetActiveInterface.GetData();
//end;

{ TArrIMeas }

constructor TArrIMeas.Create(const SOI: array of IMeasurement);
var I: Integer;
begin
  inherited Create;
 if High(SOI)<0 then Exit;
 SetLength(fSetOfInterface,High(SOI)+1);
 for I := 0 to High(SOI) do
   fSetOfInterface[i] := Pointer(SOI[i]);

end;

procedure TArrIMeas.Add(const IO: IMeasurement);
begin
  SetLength(fSetOfInterface,High(fSetOfInterface)+2);
  fSetOfInterface[High(fSetOfInterface)]:=Pointer(IO);
end;

procedure TArrIMeas.Add(const SOI: array of IMeasurement);
 var i:integer;
begin
 SetLength(fSetOfInterface,High(SOI)+High(fSetOfInterface)+2);
 for I := 0 to High(SOI) do
  fSetOfInterface[High(fSetOfInterface)-High(SOI)+i]:=Pointer(SOI[i]);
end;

//constructor TArrIMeas.Create;
//begin
// inherited;
//end;

//function TArrIMeas.GetHighIndex: integer;
//begin
// Result:=High(fSetOfInterface);
//end;

function TArrIMeas.GetMeasurement(Index: Integer): IMeasurement;
begin
 if (Index<0) or (Index>HighIndex)
   then Result:=nil
   else Result:=IMeasurement(fSetOfInterface[Index]);
end;

//function TArrIMeas.GetMeasurementName(Index: Integer): string;
//begin
// if (Index<0) or (Index>HighIndex)
//   then Result:=''
//   else Result:=IMeasurement(fSetOfInterface[Index]).Name;
//end;

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
 fArrIMeas.Add(IO);
 DevicesComboBox.Items.Add(fArrIMeas.MeasurementName[fArrIMeas.HighIndex]);
end;

procedure TMeasuringDevice.AddActionButton(AB: TButton);
begin
 ActionButton:=AB;
 ActionButton.OnClick:=ActionButtonOnClick;
end;

constructor TMeasuringDevice.Create(ArrIMeas: TArrIMeas; DevCB: TComboBox;
                IdentName: string; RI: TLabel; SR: TMeasuringStringResult);
var I: Integer;
begin
 inherited Create(DevCB,IdentName);
 fArrIMeas:=ArrIMeas;
 ResultIndicator:=RI;
 fStringResult:=SR;

 if fArrIMeas.HighIndex<0 then Exit;
 for I := 0 to fArrIMeas.HighIndex do
   if DevicesComboBox<>nil
     then DevicesComboBox.Items.Add(fArrIMeas.MeasurementName[i]);

  if (DevicesComboBox<>nil)and
     (DevicesComboBox.Items.Count>0) then DevicesComboBox.ItemIndex:=0;

end;


function TMeasuringDevice.GetActiveInterface: IMeasurement;
begin
 if DevicesComboBox=nil
   then Result:=nil
   else Result:=fArrIMeas.Measurement[DevicesComboBox.ItemIndex];
end;

function TMeasuringDevice.GetMeasurementResult: double;
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

function TMeasuringDevice.GetResult: double;
begin
  Result:=GetActiveInterface.GetData();
end;

{ TArrI }

//procedure TArrI.Add(const IO: IName);
//begin
//  SetLength(fSetOfInterface,High(fSetOfInterface)+2);
//  fSetOfInterface[High(fSetOfInterface)]:=Pointer(IO);
//end;
//
//procedure TArrI.Add(const SOI: array of IName);
// var i:integer;
//begin
// SetLength(fSetOfInterface,High(SOI)+High(fSetOfInterface)+2);
// for I := 0 to High(SOI) do
//  fSetOfInterface[High(fSetOfInterface)-High(SOI)+i]:=Pointer(SOI[i]);
//end;
//
//constructor TArrI.Create(const SOI: array of IName);
//var I: Integer;
//begin
// if High(SOI)<0 then Exit;
// SetLength(fSetOfInterface,High(SOI)+1);
// for I := 0 to High(SOI) do
//   fSetOfInterface[i] := Pointer(SOI[i]);
// inherited Create;
//end;

function TArrI.GetHighIndex: integer;
begin
   Result:=High(fSetOfInterface);
end;

function TArrI.GetMeasurementName(Index: Integer): string;
begin
 if (Index<0) or (Index>HighIndex)
   then Result:=''
   else Result:=IName(fSetOfInterface[Index]).Name;
end;

{ TArrIDAC }

procedure TArrIDAC.Add(const IO: ISource);
begin
  SetLength(fSetOfInterface,High(fSetOfInterface)+2);
  fSetOfInterface[High(fSetOfInterface)]:=Pointer(IO);
end;

procedure TArrIDAC.Add(const SOI: array of ISource);
 var i:integer;
begin
 SetLength(fSetOfInterface,High(SOI)+High(fSetOfInterface)+2);
 for I := 0 to High(SOI) do
  fSetOfInterface[High(fSetOfInterface)-High(SOI)+i]:=Pointer(SOI[i]);
end;

//procedure TArrIDAC.Add(const IO: IDAC);
//begin
//  SetLength(fSetOfInterface,High(fSetOfInterface)+2);
//  fSetOfInterface[High(fSetOfInterface)]:=Pointer(IO);
//end;
//
//procedure TArrIDAC.Add(const SOI: array of IDAC);
// var i:integer;
//begin
// SetLength(fSetOfInterface,High(SOI)+High(fSetOfInterface)+2);
// for I := 0 to High(SOI) do
//  fSetOfInterface[High(fSetOfInterface)-High(SOI)+i]:=Pointer(SOI[i]);
//end;

constructor TArrIDAC.Create(const SOI: array of ISource);
var I: Integer;
begin
  inherited Create;
 if High(SOI)<0 then Exit;
 SetLength(fSetOfInterface,High(SOI)+1);
 for I := 0 to High(SOI) do
   fSetOfInterface[i] := Pointer(SOI[i]);
end;
//constructor TArrIDAC.Create(const SOI: array of IDAC);
//var I: Integer;
//begin
//  inherited Create;
// if High(SOI)<0 then Exit;
// SetLength(fSetOfInterface,High(SOI)+1);
// for I := 0 to High(SOI) do
//   fSetOfInterface[i] := Pointer(SOI[i]);
//end;

function TArrIDAC.GetDAC(Index: Integer): ISource;
begin
 if (Index<0) or (Index>HighIndex)
   then Result:=nil
   else Result:=ISource(fSetOfInterface[Index]);
end;
//function TArrIDAC.GetDAC(Index: Integer): IDAC;
//begin
// if (Index<0) or (Index>HighIndex)
//   then Result:=nil
//   else Result:=IDAC(fSetOfInterface[Index]);
//end;

{ TArrITempMeas }

procedure TArrITempMeas.Add(const IO: ITemperatureMeasurement);
begin
  SetLength(fSetOfInterface,High(fSetOfInterface)+2);
  fSetOfInterface[High(fSetOfInterface)]:=Pointer(IO);
end;

procedure TArrITempMeas.Add(const SOI: array of ITemperatureMeasurement);
 var i:integer;
begin
 SetLength(fSetOfInterface,High(SOI)+High(fSetOfInterface)+2);
 for I := 0 to High(SOI) do
  fSetOfInterface[High(fSetOfInterface)-High(SOI)+i]:=Pointer(SOI[i]);
end;

constructor TArrITempMeas.Create(const SOI: array of ITemperatureMeasurement);
var I: Integer;
begin
  inherited Create;
 if High(SOI)<0 then Exit;
 SetLength(fSetOfInterface,High(SOI)+1);
 for I := 0 to High(SOI) do
   fSetOfInterface[i] := Pointer(SOI[i]);

end;

function TArrITempMeas.GetTempMeas(Index: Integer): ITemperatureMeasurement;
begin
 if (Index<0) or (Index>HighIndex)
   then Result:=nil
   else Result:=ITemperatureMeasurement(fSetOfInterface[Index]);
end;

end.
