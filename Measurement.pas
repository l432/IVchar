unit Measurement;

interface

uses
  StdCtrls, IniFiles, Messages;

Const
   WM_MyMeasure=WM_USER+1;
   {повідомлення, яке відсилається після закінчування
   вимірювання в іншому потоці}

   TemperMessage=1;
   {WPARAM параметер, який надсилається при вимірюванні температури}
   ControlMessage=2;
   {WPARAM параметер, який надсилається при вимірюванні
   параметра в контроллері процесу}
   ControlOutputMessage=3;
   {WPARAM параметер, який надсилається при встановленні
   керуючого параметра в контроллері процесу}

type

IName = interface
  ['{5B51E68D-11D9-4410-8396-05DB50F07F35}']
  function GetName:string;
  property Name:string read GetName;
end;

IMeasurement = interface (IName)
  ['{7A6DCE4C-9A04-444A-B7FD-39B800BDE6A7}']
 function GetNewData:boolean;
 function GetValue:double;
 function GetData:double;
 procedure SetNewData(Value:boolean);
 procedure GetDataThread(WPARAM: word; EventEnd:THandle);
 property NewData:boolean read GetNewData write SetNewData;
 property Value:double read GetValue;
end;

IDAC = interface (IName)
  ['{F729B2E9-AF49-4293-873B-83D53C258E0A}']
 function GetOutputValue:double;
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
 property OutputValue:double read GetOutputValue;
end;

ITemperatureMeasurement = interface (IMeasurement)
  ['{DDC24597-B316-4E8B-B246-1DDD0B4D5E5D}']
  function GetTemperature:double;
  procedure GetTemperatureThread(EventEnd:THandle);
end;

TSimulator = class (TInterfacedObject,IMeasurement,IDAC,ITemperatureMeasurement)
private
 FName: string;
 fValue:double;
 fNewData:boolean;
 fOutputValue:double;
 function GetName:string;
 function GetNewData:boolean;
 function GetValue:double;
 function GetOutputValue:double;
 procedure SetNewData(Value:boolean);
public
 property Name:string read GetName;
 property Value:double read GetValue;
 property NewData:boolean read GetNewData write SetNewData;
 property OutputValue:double read GetOutputValue;
 Constructor Create();overload;
 Constructor Create(name:string);overload;
 function GetTemperature:double;
 function GetData:double;
 procedure Output(Value:double);
 Procedure Reset();
 function CalibrationStep(Voltage:double):double;
 procedure OutputCalibr(Value:double);
 procedure OutputInt(Kod:integer);
 procedure GetDataThread(WPARAM: word;EventEnd:THandle);
 procedure GetTemperatureThread(EventEnd:THandle);
 procedure Free;
end;

TDevice=class
private
 DevicesComboBox:TComboBox;
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

TDAC_Show=class
  private
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
   Constructor Create(OI: IDAC;
                      VL, KL: TLabel;
                      VCB, VSB, KCB,
                      KSB, RB: TButton);
end;


TPID=class
  private
    FKi: double;
    FKd: double;
    FKp: double;
    FPeriod: double;
    FNeeded: double;
    EpsSum:double;
    Epsi:array[0..1]of double;
    fOutputValue:double;
    procedure SetKd(const Value: double);
    procedure SetKi(const Value: double);
    procedure SetKp(const Value: double);
    procedure SetPeriod(const Value: double);
    procedure SetNeeded(const Value: double);
    procedure DeviationCalculation(CurrentValue:double);

 public
   property Kp:double read FKp write SetKp;
   property Ki:double read FKi write SetKi;
   property Kd:double read FKd write SetKd;
   property Period:double read FPeriod write SetPeriod;
   property Needed:double read FNeeded write SetNeeded;
   property OutputValue:double read fOutputValue;
   Constructor Create(Kpp,Kii,Kdd,T,NeededValue:double);
   function ControlingSignal(CurrentValue:double):double;
end;



implementation

uses
  SysUtils, OlegType,Dialogs, Graphics, Windows;

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

function TSimulator.GetName: string;
begin
  Result:=fName;
end;

function TSimulator.GetNewData: boolean;
begin
 Result:=fNewData;
end;

function TSimulator.GetOutputValue: double;
begin
 Result:=fOutputValue;
end;

function TSimulator.GetData: double;
begin
 Result:=GetTickCount/1e7;
end;

procedure TSimulator.GetDataThread(WPARAM: word;EventEnd:THandle);
begin
 fValue:=GetTickCount/1e7;
 PostMessage(FindWindow ('TIVchar', 'IVchar'), WM_MyMeasure,WPARAM,0);
 SetEvent(EventEnd);
end;

function TSimulator.GetTemperature: double;
begin
 fValue:=333.00;
 Result:=333.00;
 // Result:=Random(4000)/10.0;
end;

procedure TSimulator.GetTemperatureThread(EventEnd:THandle);
begin
 GetDataThread(TemperMessage,EventEnd);
end;

function TSimulator.GetValue: double;
begin
 Result:=fValue;
end;


procedure TSimulator.Output(Value: double);
begin
 fOutputValue:=Value;
end;

procedure TSimulator.OutputCalibr(Value: double);
begin
  fOutputValue:=Value;
end;

procedure TSimulator.OutputInt(Kod: integer);
begin
  fOutputValue:=Kod;
end;

procedure TSimulator.Reset;
begin

end;




procedure TSimulator.SetNewData(Value: boolean);
begin
 fNewData:=Value;
end;

{ TDevice }

constructor TDevice.Create(DevCB: TComboBox);
begin
 inherited Create;
 DevicesComboBox:=DevCB;
 DevicesComboBox.Clear;
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

procedure TSettingDevice.SetValueCalibr(Value: double);
begin
ActiveInterface.OutputCalibr(Value);
end;

{ TDAC_Show }

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

{ TPID }

function TPID.ControlingSignal(CurrentValue: double): double;
begin
 if CurrentValue=ErResult then
    begin
     fOutputValue:=0;
    end                   else
    begin
     DeviationCalculation(CurrentValue);
     fOutputValue:=Kp*(Epsi[1]+Ki*Period*EpsSum+Kd/Period*(Epsi[1]-Epsi[0]));
    end;
 Result:=fOutputValue;
end;

constructor TPID.Create(Kpp, Kii, Kdd, T, NeededValue: double);
begin
  inherited Create;
  Kp:=Kpp;
  Ki:=Kii;
  Period:=T;
  Needed:=NeededValue;
  EpsSum:=0;
  Epsi[0]:=0;
  Epsi[1]:=0;
  Kd:=Kdd;
end;

procedure TPID.DeviationCalculation(CurrentValue: double);
 var eps:double;
begin
 eps:=FNeeded-CurrentValue;
 EpsSum:=EpsSum+eps;
 Epsi[0]:=Epsi[1];
 Epsi[1]:=eps;
end;

procedure TPID.SetKd(const Value: double);
begin
  FKd := Value;
end;

procedure TPID.SetKi(const Value: double);
begin
  FKi := Value;
end;

procedure TPID.SetKp(const Value: double);
begin
  FKp := Value;
end;

procedure TPID.SetNeeded(const Value: double);
begin
  FNeeded := Value;
end;

procedure TPID.SetPeriod(const Value: double);
begin
  if Value>0 then FPeriod := Value
             else fPeriod :=1;
end;

end.
