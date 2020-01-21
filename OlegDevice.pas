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


  TCurrent=class(TNamedInterfacedObject,IMeasurement)
    protected
     fValue:double;
     fBias:double;
     fNewData:boolean;
     fMode:TOCurrent_Mode;
     fDiapazonMeas:IMeasurement;
     fValueMeas:IMeasurement;
     function GetNewData:boolean;
     function GetValue:double;
     procedure SetNewData(value:boolean);
     procedure ModeDetermine;
     function ValueCalculate(Voltage:double):double;
     procedure ValueMeasOptimize;
    public
     property NewData:boolean read GetNewData  write SetNewData;
     property Value:double read GetValue;
//     property Bias:double read fBias write fBias;
     Constructor Create();
     function GetData:double;
     procedure GetDataThread(WPARAM: word;EventEnd:THandle);
  end;

  TCurrentResultShow=class(TMeasurementShowSimple)
    protected
     function UnitModeLabel():string;override;
    public
  end;

  TCurrentShow=class(TNamedInterfacedObject)
    private
     fModule:TCurrent;
     fBiasShow: TDoubleParameterShow;
     TTShow:TTimer;
     fResultShow:TCurrentResultShow;
     fDiapazMeasuring:TMeasuringDevice;
     fValueMeasuring:TMeasuringDevice;
    protected
     procedure ModuleUpDate();
    public
      Constructor Create(Module:TCurrent;
                         STBias:TStaticText;
                         LBias,DL,UL,RIDiap,RIVal:TLabel;
                         MB,BMeasDiap,BMeasVal:TButton;
                         AB:TSpeedButton;
                         const SOI: array of IMeasurement;
//                         ArrIMeas:TArrIMeas;
                         DevDiapCB,DevValCB: TComboBox);
      procedure ReadFromIniFile(ConfigFile:TIniFile);override;
      procedure WriteToIniFile(ConfigFile:TIniFile);override;
//      Procedure Free;//override;
      destructor Destroy;override;
  end;


// var OlegCurrent:TCurrent;

implementation

uses
  OlegType, ArduinoADC, SysUtils;

{ TCurrent }

constructor TCurrent.Create;
begin
  fName:='OlegCurrent';
  fMode:=oc_merror;
  fValue:=ErResult;
  fNewData:=False;
  fBias:=0;
end;

function TCurrent.GetData: double;
begin
 ModeDetermine();
 if fMode=oc_merror
   then fValue:=ErResult
   else
    begin
     fValue:=ValueCalculate(fValueMeas.GetData);
    end;
 Result:=fValue;
 fNewData:=True;
end;

procedure TCurrent.GetDataThread(WPARAM: word; EventEnd: THandle);
begin

end;

function TCurrent.GetNewData: boolean;
begin
  Result:=fNewData;
end;

function TCurrent.GetValue: double;
begin
 Result:=fValue;
end;

procedure TCurrent.ModeDetermine;
 var DiapVoltage:double;
     attemptCount:byte;
 label start;
begin
  attemptCount:=0;
start:
  DiapVoltage:=fDiapazonMeas.GetData;
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


procedure TCurrent.SetNewData(value: boolean);
begin
 fNewData:=value;
end;

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
 if AnsiPos('ADS1115',fValueMeas.Name)>0  then Exit;

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
                                const SOI: array of IMeasurement;
//                                ArrIMeas:TArrIMeas;
                                DevDiapCB,DevValCB: TComboBox);
begin
 inherited Create;
 fModule:=Module;
 fBiasShow:=
     TDoubleParameterShow.Create(STBias,LBias,'Bias:',0);
 fBiasShow.SetName(fModule.Name);
 fBiasShow.HookParameterClick:=ModuleUpDate;

 TTShow:=TTimer.Create(nil);
 fResultShow:=TCurrentResultShow.Create(fModule,DL,UL,MB,AB,TTShow);

 fDiapazMeasuring:=TMeasuringDevice.Create(SOI,DevDiapCB,
// fDiapazMeasuring:=TMeasuringDevice.Create(ArrIMeas,DevDiapCB,
                                    fModule.Name+'Dia',RIDiap,
                                    srPreciseVoltage);
 fDiapazMeasuring.HookParameterChange:=ModuleUpDate;
 fDiapazMeasuring.AddActionButton(BMeasDiap);

 fValueMeasuring:=TMeasuringDevice.Create(SOI,DevValCB,
//  fValueMeasuring:=TMeasuringDevice.Create(ArrIMeas,DevValCB,
                                   fModule.Name+'Val',RIVal,
                                   srPreciseVoltage);
 fValueMeasuring.HookParameterChange:=ModuleUpDate;
 fValueMeasuring.AddActionButton(BMeasVal);

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
  TTShow.Free;
  fDiapazMeasuring.Free;
  fValueMeasuring.Free;
  fResultShow.Free;
  fBiasShow.Free;
  inherited;
end;

procedure TCurrentShow.ModuleUpDate;
begin
  fModule.fBias:=fBiasShow.Data;
  fModule.fDiapazonMeas:=fDiapazMeasuring.ActiveInterface;
  fModule.fValueMeas:=fValueMeasuring.ActiveInterface;
end;

procedure TCurrentShow.ReadFromIniFile(ConfigFile: TIniFile);
begin
  inherited ReadFromIniFile(ConfigFile);
  fBiasShow.ReadFromIniFile(ConfigFile);
  fDiapazMeasuring.ReadFromIniFile(ConfigFile);
  fValueMeasuring.ReadFromIniFile(ConfigFile);
  ModuleUpDate;
end;

procedure TCurrentShow.WriteToIniFile(ConfigFile: TIniFile);
begin
  inherited WriteToIniFile(ConfigFile);
  fBiasShow.WriteToIniFile(ConfigFile);
  fDiapazMeasuring.WriteToIniFile(ConfigFile);
  fValueMeasuring.WriteToIniFile(ConfigFile);
end;

initialization
//  OlegCurrent:=TCurrent.Create;
finalization
//  OlegCurrent.Free;
end.
