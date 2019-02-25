unit INA226;


interface

uses
  ArduinoADC, ArduinoDevice, OlegShowTypes, ExtCtrls, StdCtrls, IniFiles, 
  ArduinoDeviceShow, MDevice;

type

 TINA226_Mode=(ina_mShunt,
               ina_mBus,
               ina_mShuntAndBus);

 TINA226_ConversionTime=(ina_ct140us,
                         ina_ct204us,
                         ina_ct332us,
                         ina_ct588us,
                         ina_ct1100us,
                         ina_ct2116us,
                         ina_ct4156us,
                         ina_ct8244us);

 TINA226_Averages=(ina_a1,
                   ina_a4,
                   ina_a16,
                   ina_a64,
                   ina_a128,
                   ina_a256,
                   ina_a512,
                   ina_a1024);


const
 ΙΝΑ226_Mode:array[TINA226_Mode] of byte=
     (1,2,3);

 INA226_ConversionTime:array[TINA226_ConversionTime]of double=
    (0.14,0.204,0.332,0.588,1.1,2.116,4.156,8.244);
 INA226_ConversionTimeLabels:array[TINA226_ConversionTime]of string=
    ('140 us','204 us','332 us','588 us','1.1 ms','2.116 ms',
     '4.156 ms','8.244 ms');
 INA226_Averages:array[TINA226_Averages] of word=
    (1,4,16,64,128,256,512,1024);

 INA226_ShuntLSB=2.5e-6;
 INA226_BusLSB=1.25e-3;

 INA226_StartAdress=$40;
 INA226_LastAdress=$4F;


type

  TPins_INA226_Module=class(TPins)
    protected
     Function StrToPinValue(Str: string):integer;override;
     Function PinValueToStr(Index:integer):string;override;
    public
     Constructor Create(Nm:string);
    end;

  TINA226_Module=class(TArdADC_Mod_2ConfigByte)
  private
   fShuntVoltageCT:TINA226_ConversionTime;
   fBusVoltageCT:TINA226_ConversionTime;
   fShuntVoltage:double;
   fBusVoltage:double;
   fRsh:double;
   fTimeFactor:byte;
   {при великих кількостях усереднень платі потрібно більше
   часу, ніж описано в datasheet; ця змінна - множник часу
   очікування результату Arduino-ю}
   procedure SetMode(const Value: TINA226_Mode);
   procedure SetRsh(const Value: double);
   procedure SetTimeF(const Value: byte);
   procedure SetAverages(const Value:TINA226_Averages);
   function GetMode:TINA226_Mode;
   function GetAverages:TINA226_Averages;
   function MinDelayTimeDetermination:integer;
   function IncorrectData:boolean;
  protected
   procedure Configuration();override;
   procedure Intitiation(); override;
   procedure PinsCreate();override;
   procedure FinalPacketCreateToSend();override;
  public
   property Averages:TINA226_Averages read GetAverages write SetAverages;
   property ShuntConversionTime:TINA226_ConversionTime read fShuntVoltageCT write fShuntVoltageCT;
   property BusConversionTime:TINA226_ConversionTime read fBusVoltageCT write fBusVoltageCT;
   property Mode:TINA226_Mode read GetMode write SetMode;
   property ShuntVoltage:double read fShuntVoltage;
   property BusVoltage:double read fBusVoltage;
   property Rsh:double read fRsh write SetRsh;
   property TimeFactor:byte read fTimeFactor write SetTimeF;
   procedure ConvertToValue();override;
 end;


 TINA226_ModuleShow=class(TPinsShowUniversal)
   private
    fModule:TINA226_Module;
    fRshShow: TDoubleParameterShow;
    fTimeFactorShow: TIntegerParameterShow;
   protected
    procedure LabelsFilling;
    procedure ModuleUpDate();
   public
    Constructor Create(Module:TINA226_Module;
                       PanelAdress,PanelAverages:TPanel;
                       LabelRsh,LabelTimeF:TLabel;
                       STRsh,STTimeF:TStaticText);
    procedure ReadFromIniFile(ConfigFile:TIniFile);override;
    procedure WriteToIniFile(ConfigFile:TIniFile);override;
    Procedure Free;override;
 end;

  TPins_INA226_Chanel=class(TPins)
  protected
   Function StrToPinValue(Str: string):integer;override;
   Function PinValueToStr(Index:integer):string;override;
   public
   Constructor Create(Nm:string);
  end;



 TINA226_Channel=class(TArduinoADC_Channel)
 private
  fMode: TINA226_Mode;
 protected
  procedure SetModuleParameters;override;
  procedure PinsCreate;override;
 public
  Constructor Create(Mode:TINA226_Mode;
                      INA: TINA226_Module);
 end;

 TINA226_ChannelShow=class(TOnePinsShow)
   private
    fChan:TINA226_Channel;
    MeasuringDeviceSimple:TMeasuringDeviceSimple;
   protected
    procedure CreateFooter;override;   
   public
    Constructor Create(Chan:TINA226_Channel;
                       PanelConvTime:TPanel;
                       LabelMeas:TLabel;
                       ButMeas:TButton);
   Procedure Free;override;
 end;


implementation

uses
  Math, OlegType, PacketParameters, SysUtils, Dialogs;


{ TINA226_Module }

procedure TINA226_Module.Configuration;
begin
  fMinDelayTime:=MinDelayTimeDetermination();
  fConfigByte:=$40;
  fConfigByte:=fConfigByte or byte(byte(ord(Averages)) shl 1);
  fConfigByte:=fConfigByte or (byte(ord(fBusVoltageCT)) shr 2);

  fConfigByteTwo:=$00;
  fConfigByteTwo:=fConfigByteTwo or byte(byte(ord(fBusVoltageCT)) shl 6);
  fConfigByteTwo:=fConfigByteTwo or byte(byte(ord(fShuntVoltageCT)) shl 3);
  fConfigByteTwo:=fConfigByteTwo or ΙΝΑ226_Mode[Mode];
end;

procedure TINA226_Module.ConvertToValue;
begin
 fValue:=ErResult;
 if IncorrectData() then Exit;
 case Mode of
   ina_mShunt: begin
                fValue:=TwosComplementToDouble(fData[0],fData[1],INA226_ShuntLSB)/fRsh;
                fShuntVoltage:=fValue;
                fBusVoltage:=ErResult;
               end;
   ina_mBus: begin
                fValue:=TwosComplementToDouble(fData[0],fData[1],INA226_BusLSB);
                fShuntVoltage:=ErResult;
                fBusVoltage:=fValue;
               end;
   else      begin
                fValue:=TwosComplementToDouble(fData[0],fData[1],INA226_BusLSB)/fRsh;
                fShuntVoltage:=fValue;
                fBusVoltage:=TwosComplementToDouble(fData[2],fData[3],INA226_BusLSB);
               end;
 end;
end;

procedure TINA226_Module.FinalPacketCreateToSend;
begin
 PacketCreate([fMetterKod, Pins.PinControl,
      fConfigByte, fConfigByteTwo, fTimeFactor]);
end;

function TINA226_Module.GetAverages: TINA226_Averages;
begin
 Result:=TINA226_Averages(Pins.PinGate)
end;

function TINA226_Module.GetMode: TINA226_Mode;
begin
 Result:=TINA226_Mode(FActiveChannel)
end;

function TINA226_Module.IncorrectData: boolean;
begin
 case Mode of
  ina_mShunt,ina_mBus: Result:=High(fData)<>1;
   else   Result:=High(fData)<>3;
 end;
end;

procedure TINA226_Module.Intitiation;
begin
  fDelayTimeMax:=150;
  fDelayTimeStep:=1;
  fShuntVoltageCT:=ina_ct1100us;
  fBusVoltageCT:=ina_ct1100us;
  fShuntVoltage:=ErResult;
  fBusVoltage:=ErResult;
  fMetterKod := INA226Command;
  fRsh:=1;
  fTimeFactor:=1;
  RepeatInErrorCase:=True;
end;

function TINA226_Module.MinDelayTimeDetermination: integer;
begin
 case Mode of
   ina_mShunt: Result:=max(2,Ceil(INA226_Averages[Averages]*INA226_ConversionTime[fShuntVoltageCT]));
   ina_mBus: Result:=max(2,Ceil(INA226_Averages[Averages]*INA226_ConversionTime[fBusVoltageCT]));
   else
    Result:=max(2,Ceil(INA226_Averages[Averages]*
                          (INA226_ConversionTime[fShuntVoltageCT]+INA226_ConversionTime[fBusVoltageCT])));
 end;
end;

procedure TINA226_Module.PinsCreate;
begin
  Pins := TPins_INA226_Module.Create(Name);
end;

procedure TINA226_Module.SetAverages(const Value: TINA226_Averages);
begin
 Pins.PinGate:=ord(Value);
end;

procedure TINA226_Module.SetMode(const Value: TINA226_Mode);
begin
  FActiveChannel:=ΙΝΑ226_Mode[Value];
end;

procedure TINA226_Module.SetRsh(const Value: double);
begin
 if Value<>0 then fRsh:=abs(Value);
end;

procedure TINA226_Module.SetTimeF(const Value: byte);
begin
 if Value>0 then fTimeFactor:=Value;
end;

{ TPins_INA226_Module }

constructor TPins_INA226_Module.Create(Nm: string);
begin
  inherited Create(Nm, ['Adress', 'Average']);
  PinStrPart:='';
  PinControl := $45;
  // зберігатиметься I2C адреса
  PinGate := $00;
  // зберігатиметься кількість усереднень
end;


function TPins_INA226_Module.PinValueToStr(Index: integer): string;
begin
  if Index=0 then  Result:='$'+IntToHex(fPins[Index],2)
             else  Result:=IntToStr(INA226_Averages[TINA226_Averages(fPins[Index])]);
end;

function TPins_INA226_Module.StrToPinValue(Str: string): integer;
begin
  try
    Result:=StrToInt(Str);
  except
    Result:=UndefinedPin;
    Exit;
  end;
  if AnsiPos('$',Str)=0 then
    begin
     Result:=round(Log2(Result));
     if Result>0 then Result:=Result-1;
     if Result>2 then Result:=Result-1;
     if Result>2 then Result:=Result-1;
    end;
end;

{ TINA226_ModuleShow }

constructor TINA226_ModuleShow.Create(Module: TINA226_Module;
                          PanelAdress,PanelAverages: TPanel;
                          LabelRsh,LabelTimeF:TLabel;
                          STRsh,STTimeF:TStaticText);
begin
  fModule:=Module;
  inherited Create(fModule.Pins,[PanelAdress,PanelAverages]);
  LabelsFilling;

  fRshShow:=
     TDoubleParameterShow.Create(STRsh,LabelRsh,'Rsh:',3.3,4);
  fRshShow.SetName(fModule.Name);
  fRshShow.HookParameterClick:=ModuleUpDate;
  fTimeFactorShow:=
     TIntegerParameterShow.Create(STTimeF,LabelTimeF,'Time factor:',1);
  fTimeFactorShow.SetName(fModule.Name);
  fTimeFactorShow.HookParameterClick:=ModuleUpDate;
end;

procedure TINA226_ModuleShow.Free;
begin
  fTimeFactorShow.Free;
  fRshShow.Free;
  inherited Free;
end;

procedure TINA226_ModuleShow.LabelsFilling;
 var adress:byte;
     i:TINA226_Averages;
begin
 fPinVariants[0].Clear;
 for adress := INA226_StartAdress to INA226_LastAdress do
   fPinVariants[0].Add('$'+IntToHex(adress,2));

  fPinVariants[1].Clear;
  for i := Low(TINA226_Averages) to High(TINA226_Averages) do
    fPinVariants[1].Add(Inttostr(INA226_Averages[i]));

end;

procedure TINA226_ModuleShow.ModuleUpDate;
begin
  fModule.Rsh:=fRshShow.Data;
  fModule.TimeFactor:=byte(fTimeFactorShow.Data);
  fRshShow.Data:=fModule.Rsh;
  fTimeFactorShow.Data:= fModule.TimeFactor;
end;

procedure TINA226_ModuleShow.ReadFromIniFile(ConfigFile: TIniFile);
begin
  inherited ReadFromIniFile(ConfigFile);
  fRshShow.ReadFromIniFile(ConfigFile);
  fTimeFactorShow.ReadFromIniFile(ConfigFile);
  ModuleUpDate;
end;

procedure TINA226_ModuleShow.WriteToIniFile(ConfigFile: TIniFile);
begin
  inherited WriteToIniFile(ConfigFile);
  fRshShow.WriteToIniFile(ConfigFile);
  fTimeFactorShow.WriteToIniFile(ConfigFile);
//  HelpForMe(Pins.Name+Pins.Name);
end;

{ TINA226_ADS1115_Chanel }

constructor TPins_INA226_Chanel.Create(Nm: string);
begin
  inherited Create(Nm,['Conv. time'],1);
  PinStrPart:=''
end;

function TPins_INA226_Chanel.PinValueToStr(Index: integer): string;
begin
 Result:=INA226_ConversionTimeLabels[TINA226_ConversionTime(fPins[Index])];
end;

function TPins_INA226_Chanel.StrToPinValue(Str: string): integer;
 var i:TINA226_ConversionTime;
begin
 for I := Low(TINA226_ConversionTime) to High(TINA226_ConversionTime) do
  if Str=INA226_ConversionTimeLabels[I] then
   begin
    Result:=ord(i);
    Exit;
   end;

  Result:=UndefinedPin;
end;

{ TINA226_Channel }

constructor TINA226_Channel.Create(Mode: TINA226_Mode;
                                  INA: TINA226_Module);
begin
 fMode:=Mode;
 inherited Create(ord(Mode),INA);
 case fMode of
   ina_mShunt: fName:=INA.Name+'_Shunt';
   ina_mBus: fName:=INA.Name+'_Bus';
 end;
end;

procedure TINA226_Channel.PinsCreate;
begin
 Pins:=TPins_INA226_Chanel.Create(fName);
end;

procedure TINA226_Channel.SetModuleParameters;
begin
  inherited SetModuleParameters();
  (fParentModule as TINA226_Module).fShuntVoltageCT:=
             TINA226_ConversionTime(Pins.PinControl);
 case fMode of
   ina_mShunt: (fParentModule as TINA226_Module).fShuntVoltageCT:=
             TINA226_ConversionTime(Pins.PinControl);
   ina_mBus: (fParentModule as TINA226_Module).fBusVoltageCT:=
             TINA226_ConversionTime(Pins.PinControl);
 end;
end;

{ TINA226_ChannelShow }

constructor TINA226_ChannelShow.Create(Chan: TINA226_Channel;
                                       PanelConvTime: TPanel;
                                       LabelMeas: TLabel;
                                       ButMeas: TButton);
begin
  fChan:=Chan;
  inherited Create(fChan.Pins,PanelConvTime);
  MeasuringDeviceSimple:=
     TMeasuringDeviceSimple.Create(fChan,LabelMeas,srCurrent,ButMeas);
end;

procedure TINA226_ChannelShow.CreateFooter;
 var i:TINA226_ConversionTime;
begin
  inherited CreateFooter;
 for I := Low(TINA226_ConversionTime) to High(TINA226_ConversionTime) do
    fPinVariants[0].Add(INA226_ConversionTimeLabels[i]);
end;

procedure TINA226_ChannelShow.Free;
begin
  MeasuringDeviceSimple.Free;
  inherited Free;
end;

end.
