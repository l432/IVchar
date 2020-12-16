unit OlegDevice;

interface

uses
  OlegTypePart2, Measurement, OlegShowTypes,
  MDevice, IniFiles, StdCtrls, 
  Buttons, ExtCtrls;

type

 TOCurrent_Mode=(oc_m3,
                 oc_m2,
                 oc_m1,
                 oc_m0,
                 oc_merror);

  TVoltage=class(TNamedInterfacedObject,IMeasurement)
  private
    function GetValueMeas: IMeasurement;
    procedure SetValueMeas(const Value: IMeasurement);
    protected
     fValue:double;
     fNewData:boolean;
     fValueMeas:pointer;
     function GetNewData:boolean;
     function GetValue:double;
     procedure SetNewData(value:boolean);
     function ValueCalculate(Voltage:double):double;virtual;
     function GetDeviceKod:byte;
    public
     property ValueMeas:IMeasurement read GetValueMeas write SetValueMeas;
     property NewData:boolean read GetNewData  write SetNewData;
     property Value:double read GetValue;
     Constructor Create();
     function GetData:double;virtual;
     procedure GetDataThread(WPARAM: word;EventEnd:THandle);
  end;


//  TCurrent=class(TNamedInterfacedObject,IMeasurement)
  TCurrent=class(TVoltage)
  private
    function GetDiapazonMeas: IMeasurement;
//    function GetValueMeas: IMeasurement;
    procedure SetDiapazonMeas(const Value: IMeasurement);
//    procedure SetValueMeas(const Value: IMeasurement);
    protected
//     fValue:double;
     fBias:double;
//     fNewData:boolean;
     fMode:TOCurrent_Mode;
//     fDiapazonMeas:IMeasurement;
//     fValueMeas:IMeasurement;
     fDiapazonMeas,fValueMeas:pointer;
//     function GetNewData:boolean;
//     function GetValue:double;
//     procedure SetNewData(value:boolean);
     procedure ModeDetermine;
     function ValueCalculate(Voltage:double):double;override;
     procedure ValueMeasOptimize;
    public
     property DiapazonMeas:IMeasurement read GetDiapazonMeas write SetDiapazonMeas;
//     property ValueMeas:IMeasurement read GetValueMeas write SetValueMeas;
//     property NewData:boolean read GetNewData  write SetNewData;
//     property Value:double read GetValue;
//     property Bias:double read fBias write fBias;
     Constructor Create();
     function GetData:double;override;
//     procedure GetDataThread(WPARAM: word;EventEnd:THandle);
  end;

  TVoltageResultShow=class(TMeasurementShowSimple)
    protected
     function UnitModeLabel():string;override;
    public
  end;

  TCurrentResultShow=class(TMeasurementShowSimple)
    protected
     function UnitModeLabel():string;override;
    public
  end;

  TVoltageShow=class(TNamedInterfacedObject)
    private
     fModule:TVoltage;
     TTShow:TTimer;
     fResultShow:TMeasurementShowSimple;
     fValueMeasuring:TMeasuringDevice;
     procedure ResultShowCreate(DL: TLabel; AB: TSpeedButton; UL: TLabel; MB: TButton);virtual;
     procedure ReadFromIniBody(ConfigFile: TIniFile);virtual;
    protected
     procedure ModuleUpDate();virtual;
    public
      Constructor Create(Module:TVoltage;
                         DL,UL,RIVal:TLabel;
                         MB,BMeasVal:TButton;
                         AB:TSpeedButton;
                         ArrIMeas:TArrIMeas;
                         DevValCB: TComboBox);
      procedure ReadFromIniFile(ConfigFile:TIniFile);override;
      procedure WriteToIniFile(ConfigFile:TIniFile);override;
      destructor Destroy;override;
  end;


//  TCurrentShow=class(TNamedInterfacedObject)
  TCurrentShow=class(TVoltageShow)
    private
//     fModule:TCurrent;
     fBiasShow: TDoubleParameterShow;
//     TTShow:TTimer;
     fResultShow:TCurrentResultShow;
     fDiapazMeasuring:TMeasuringDevice;
//     fValueMeasuring:TMeasuringDevice;
     procedure ResultShowCreate(DL: TLabel; AB: TSpeedButton; UL: TLabel; MB: TButton);override;
     procedure ReadFromIniBody(ConfigFile: TIniFile);override;
    protected
     procedure ModuleUpDate();override;
    public
      Constructor Create(Module:TCurrent;
                         STBias:TStaticText;
                         LBias,DL,UL,RIDiap,RIVal:TLabel;
                         MB,BMeasDiap,BMeasVal:TButton;
                         AB:TSpeedButton;
//                         const SOI: array of IMeasurement;
                         ArrIMeas:TArrIMeas;
                         DevDiapCB,DevValCB: TComboBox);
//      procedure ReadFromIniFile(ConfigFile:TIniFile);override;
      procedure WriteToIniFile(ConfigFile:TIniFile);override;
      destructor Destroy;override;
  end;

 function IledToVdac(Iled:double):Double;
 {взаємозв'язок струму через LED (мА)
 та не необхідної напруги на ЦАП (В)}

 var OlegCurrent:TCurrent;
     OlegVoltage:TVoltage;
     CurrentShow:TCurrentShow;
     VoltageShow:TVoltageShow;

implementation

uses
  OlegType, ArduinoADC, SysUtils;

{ TCurrent }

constructor TCurrent.Create;
begin
  inherited Create;
  fName:='OlegCurrent';
  fMode:=oc_merror;
//  fValue:=ErResult;
//  fNewData:=False;
  fBias:=0;
end;

function TCurrent.GetData: double;
begin
 ModeDetermine();
 if fMode=oc_merror
   then fValue:=ErResult
   else  fValue:=ValueCalculate(ValueMeas.GetData);
//    begin
//     fValue:=ValueCalculate(ValueMeas.GetData);
//    end;
 Result:=fValue;
 fNewData:=True;
end;

//procedure TCurrent.GetDataThread(WPARAM: word; EventEnd: THandle);
//begin
//
//end;

function TCurrent.GetDiapazonMeas: IMeasurement;
begin
 Result:=IMeasurement(fDiapazonMeas);
end;

//function TCurrent.GetNewData: boolean;
//begin
//  Result:=fNewData;
//end;

//function TCurrent.GetValue: double;
//begin
// Result:=fValue;
//end;

//function TCurrent.GetValueMeas: IMeasurement;
//begin
// Result:=IMeasurement(fValueMeas);
//end;

procedure TCurrent.ModeDetermine;
 var DiapVoltage:double;
     attemptCount:byte;
 label start;
begin
  attemptCount:=0;
start:
  DiapVoltage:=DiapazonMeas.GetData;
  if abs(DiapVoltage)<0.02
   then fMode:=oc_m0
   else
   if (DiapVoltage>0.21)and(DiapVoltage<0.25)
      then fMode:=oc_m1
      else
      if (DiapVoltage>0.44)and(DiapVoltage<0.48)
         then fMode:=oc_m2
         else
          if (DiapVoltage>0.68)and(DiapVoltage<0.72)
            then fMode:=oc_m3
            else fMode:=oc_merror;
   inc(attemptCount);
   if (DiapVoltage=ErResult)and(attemptCount=1) then goto start;
end;


procedure TCurrent.SetDiapazonMeas(const Value: IMeasurement);
begin
 fDiapazonMeas:=pointer(Value);
end;

//procedure TCurrent.SetNewData(value: boolean);
//begin
// fNewData:=value;
//end;

//procedure TCurrent.SetValueMeas(const Value: IMeasurement);
//begin
//  fValueMeas:=pointer(Value);
//end;

function TCurrent.ValueCalculate(Voltage: double): double;
begin
 if Voltage=ErResult then
    begin
      Result:=ErResult;
      Exit;
    end;
  case fMode of
    oc_m3: Result:=2.40593e-8-1.003795e-8*Voltage-fBias;
    oc_m2: Result:=2.506122e-6-9.98987e-7*Voltage-fBias;
    oc_m1: Result:=2.500326e-4-9.948939e-5*Voltage;
    oc_m0: Result:=0.002497837-0.009940625*Voltage;
    else Result:=ErResult;
  end;
end;

procedure TCurrent.ValueMeasOptimize;
begin
 if AnsiPos('ADS1115',ValueMeas.Name)>0  then Exit;

end;

{ TCurrentResultShow }

function TCurrentResultShow.UnitModeLabel: string;
begin
  Result:='A';
end;

{ TCurrentShow }

constructor TCurrentShow.Create(Module: TCurrent;
                                STBias:TStaticText;
                                LBias,DL,UL,RIDiap,RIVal:TLabel;
                                MB,BMeasDiap,BMeasVal:TButton;
                                AB:TSpeedButton;
//                                SOI: TIMeasArr;
//                                const SOI: array of IMeasurement;
                                ArrIMeas:TArrIMeas;
                                DevDiapCB,DevValCB: TComboBox);
begin
// inherited Create;
 inherited Create(Module,DL,UL,RIVal,MB,BMeasVal,AB,ArrIMeas,DevValCB);
// fModule:=Module;
 fBiasShow:=
     TDoubleParameterShow.Create(STBias,LBias,'Bias:',0);
 fBiasShow.SetName(fModule.Name);
 fBiasShow.HookParameterClick:=ModuleUpDate;

// TTShow:=TTimer.Create(nil);
// TTShow.Interval:=1000;
// fResultShow:=TCurrentResultShow.Create(fModule,DL,UL,MB,AB,TTShow);

 fDiapazMeasuring:=TMeasuringDevice.Create(ArrIMeas,DevDiapCB,
                                    fModule.Name+'Dia',RIDiap,
                                    srPreciseVoltage);
 fDiapazMeasuring.HookParameterChange:=ModuleUpDate;
 fDiapazMeasuring.AddActionButton(BMeasDiap);

// fValueMeasuring:=TMeasuringDevice.Create(ArrIMeas,DevValCB,
//                                   fModule.Name+'Val',RIVal,
//                                   srPreciseVoltage);
// fValueMeasuring.HookParameterChange:=ModuleUpDate;
// fValueMeasuring.AddActionButton(BMeasVal);

 ModuleUpDate;
end;

//procedure TCurrentShow.Free;
//begin
//  TTShow.Free;
//  fDiapazMeasuring.Free;
//  fValueMeasuring.Free;
//  fResultShow.Free;
//  fBiasShow.Free;
//  inherited Free;
//end;

destructor TCurrentShow.Destroy;
begin
//  TTShow.Free;
  fDiapazMeasuring.Free;
//  fValueMeasuring.Free;
//  fResultShow.Free;
  fBiasShow.Free;
  inherited;
end;

procedure TCurrentShow.ReadFromIniBody(ConfigFile: TIniFile);
begin
  inherited ReadFromIniBody(ConfigFile);
  fBiasShow.ReadFromIniFile(ConfigFile);
  fDiapazMeasuring.ReadFromIniFile(ConfigFile);
//  fValueMeasuring.ReadFromIniFile(ConfigFile);
end;

procedure TCurrentShow.ResultShowCreate(DL: TLabel; AB: TSpeedButton;
  UL: TLabel; MB: TButton);
begin
 fResultShow := TCurrentResultShow.Create(fModule, DL, UL, MB, AB, TTShow);
end;

procedure TCurrentShow.ModuleUpDate;
begin
  inherited ModuleUpDate;
  if assigned(fBiasShow) then
   (fModule as TCurrent).fBias:=fBiasShow.Data;
  if assigned(fDiapazMeasuring) then
   (fModule as TCurrent).DiapazonMeas:=fDiapazMeasuring.ActiveInterface;
//  fModule.ValueMeas:=fValueMeasuring.ActiveInterface;
end;

//procedure TCurrentShow.ReadFromIniFile(ConfigFile: TIniFile);
//begin
//  inherited ReadFromIniFile(ConfigFile);
//  ReadFromIniBody(ConfigFile);
//  ModuleUpDate;
//end;

procedure TCurrentShow.WriteToIniFile(ConfigFile: TIniFile);
begin
  inherited WriteToIniFile(ConfigFile);
  fBiasShow.WriteToIniFile(ConfigFile);
  fDiapazMeasuring.WriteToIniFile(ConfigFile);
//  fValueMeasuring.WriteToIniFile(ConfigFile);
end;

{ TVoltage }

constructor TVoltage.Create;
begin
  inherited Create;
  fName:='OlegVoltage';
//  fMode:=oc_merror;
  fValue:=ErResult;
  fNewData:=False;
//  fBias:=0;
end;

function TVoltage.GetData: double;
begin
 fValue:=ValueCalculate(ValueMeas.GetData);
 Result:=fValue;
 fNewData:=True;
end;

procedure TVoltage.GetDataThread(WPARAM: word; EventEnd: THandle);
begin

end;

function TVoltage.GetDeviceKod: byte;
begin
 Result:=ValueMeas.DeviceKod;
end;

function TVoltage.GetNewData: boolean;
begin
 Result:=fNewData;
end;

function TVoltage.GetValue: double;
begin
 Result:=fValue;
end;

function TVoltage.GetValueMeas: IMeasurement;
begin
 Result:=IMeasurement(fValueMeas);
end;

procedure TVoltage.SetNewData(value: boolean);
begin
 fNewData:=value;
end;

procedure TVoltage.SetValueMeas(const Value: IMeasurement);
begin
  fValueMeas:=pointer(Value);
end;

function TVoltage.ValueCalculate(Voltage: double): double;
begin
  if Voltage=ErResult
   then Result:=ErResult
   else
    begin
    Result:=-11.36084+4.52483*Voltage;
    Result:=0.006297+1.008421*Result;
//    Result:=0.01515+1.00839*Result;
    {остання калібровка по V7-21(2)}
    end;
end;

{ TVoltageResultShow }

function TVoltageResultShow.UnitModeLabel: string;
begin
  Result:='V';
end;

{ TVoltageShow }

constructor TVoltageShow.Create(Module: TVoltage;
                                DL, UL, RIVal: TLabel;
                                MB,BMeasVal: TButton;
                                AB: TSpeedButton;
                                ArrIMeas: TArrIMeas;
                                DevValCB: TComboBox);
begin
 inherited Create;
 fModule:=Module;

 TTShow:=TTimer.Create(nil);
 TTShow.Interval:=1000;
 ResultShowCreate(DL, AB, UL, MB);

 fValueMeasuring:=TMeasuringDevice.Create(ArrIMeas,DevValCB,
                                   fModule.Name+'Val',RIVal,
                                   srPreciseVoltage);
 fValueMeasuring.HookParameterChange:=ModuleUpDate;
 fValueMeasuring.AddActionButton(BMeasVal);

 ModuleUpDate;
end;

destructor TVoltageShow.Destroy;
begin
  TTShow.Free;
  fValueMeasuring.Free;
  fResultShow.Free;
  inherited;
end;

procedure TVoltageShow.ResultShowCreate(DL: TLabel; AB: TSpeedButton; UL: TLabel; MB: TButton);
begin
  fResultShow := TVoltageResultShow.Create(fModule, DL, UL, MB, AB, TTShow);
end;

procedure TVoltageShow.ModuleUpDate;
begin
  fModule.ValueMeas:=fValueMeasuring.ActiveInterface;
end;

procedure TVoltageShow.ReadFromIniBody(ConfigFile: TIniFile);
begin
  fValueMeasuring.ReadFromIniFile(ConfigFile);
end;

procedure TVoltageShow.ReadFromIniFile(ConfigFile: TIniFile);
begin
  inherited ReadFromIniFile(ConfigFile);
  ReadFromIniBody(ConfigFile);
  ModuleUpDate;
end;

procedure TVoltageShow.WriteToIniFile(ConfigFile: TIniFile);
begin
  inherited WriteToIniFile(ConfigFile);
  fValueMeasuring.WriteToIniFile(ConfigFile);
end;

function IledToVdac(Iled:double):Double;
 {взаємозв'язок струму через LED (мА)
 та не необхідної напруги на ЦАП (В)}
begin
  Result:=(Iled+1.25)/253.9;
end;


initialization
  OlegCurrent:=TCurrent.Create;
  OlegVoltage:=TVoltage.Create;
finalization
  OlegCurrent.Free;
  FreeAndNil(OlegVoltage);
end.
