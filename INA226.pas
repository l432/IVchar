unit INA226;


interface

uses
  ArduinoADC, ArduinoDevice, OlegShowTypes, ExtCtrls, StdCtrls, IniFiles;

type

 TΙΝΑ226_Mode=(ina_mShunt,
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
 ΙΝΑ226_Mode:array[TΙΝΑ226_Mode] of byte=
     (1,2,3);

 INA226_ConversionTime:array[TINA226_ConversionTime]of double=
    (0.14,0.204,0.332,0.588,1.1,2.116,4.156,8.244);
 INA226_Averages:array[TINA226_Averages] of word=
    (1,4,16,64,128,256,512,1024);

 INA226_ShuntLSB=2.5e-6;
 INA226_BusLSB=1.25e-3;

 INA226_StartAdress=$40;
 INA226_LastAdress=$4F;


//
// ADS1115_Gain_Data:array[TADS1115_Gain]of double=
//    (1.5,1,0.5,0.25,0.125,0.0625);
// ADS1115_Gain_Kod:array[TADS1115_Gain]of byte=
//    ($00,$02,$04,$06,$08,$0A);
// ADS1115_Diapazons:array[TADS1115_Gain]of string=
//    ('6.144','4.096','2.048','1.024','0.512','0.256');
// ADS1115_LSB_labels:array[TADS1115_Gain]of string=
//    ('200','125','63','32','16','8');
//
//
// ADS1115_DataRate_Kod:array[TADS1115_DataRate]of byte=
//    ($00,$20,$40,$60,$80,$A0,$C0,$E0);
// ADS1115_DataRate_Label:array[TADS1115_DataRate]of string=
//   (' 8 SPS','16 SPS','32 SPS','64 SPS',
//   '128 SPS','250 SPS','475 SPS','860 SPS');
//
// ADS1115_Chanel_Kod:array[TADS1115_ChanelNumber]of byte=
//    ($40,$50,$30);
//
// ADS1115_LSB=125e-6;
// ADS1115_StartAdress=$48;
// ADS1115_LastAdress=$4B;
//
//
type

//  TPins_INA226_Module=class(TPinsForCustomValues)
  TPins_INA226_Module=class(TPins)
    protected
     Function StrToPinValue(Str: string):integer;override;
     Function PinValueToStr(Index:integer):string;override;
    public
     Constructor Create(Nm:string);
    end;

  TINA226_Module=class(TArdADC_Mod_2ConfigByte)
  private
//   fAverages:TINA226_Averages;
   fShuntVoltageCT:TINA226_ConversionTime;
   fBusVoltageCT:TINA226_ConversionTime;
   fShuntVoltage:double;
   fBusVoltage:double;
   fRsh:double;
   procedure SetMode(const Value: TΙΝΑ226_Mode);
   procedure SetRsh(const Value: double);
   procedure SetAverages(const Value:TINA226_Averages);
   function GetMode:TΙΝΑ226_Mode;
   function GetAverages:TINA226_Averages;
   function MinDelayTimeDetermination:integer;
   function IncorrectData:boolean;
  protected
   procedure Configuration();override;
   procedure Intitiation(); override;
   procedure PinsCreate();override;
  public
   property Averages:TINA226_Averages read GetAverages write SetAverages;
   property ShuntConversionTime:TINA226_ConversionTime read fShuntVoltageCT write fShuntVoltageCT;
   property BusConversionTime:TINA226_ConversionTime read fBusVoltageCT write fBusVoltageCT;
   property Mode:TΙΝΑ226_Mode read GetMode write SetMode;
   property ShuntVoltage:double read fShuntVoltage;
   property BusVoltage:double read fBusVoltage;
   property Rsh:double read fRsh write SetRsh;

   procedure ConvertToValue();override;
 end;


 TINA226_ModuleShow=class(TPinsShowUniversal)
   private
    fModule:TINA226_Module;
    fRshShow: TDoubleParameterShow;
   protected
    procedure LabelsFilling;
   public
    Constructor Create(Module:TINA226_Module;
                       PanelAdress,PanelAverages:TPanel;
                       LabelRsh:TLabel;
                       STRsh:TStaticText);
    procedure PinsReadFromIniFile(ConfigFile:TIniFile);override;
    procedure PinsWriteToIniFile(ConfigFile:TIniFile);override;
    Procedure Free;
 end;

//
//TPins_ADS1115_Chanel=class(TPins)
//  protected
//   Function GetPinStr(Index:integer):string;override;
//   Function StrToPinValue(Str: string):integer;override;
//   Function PinValueToStr(Index:integer):string;override;
//  public
//   Constructor Create(Nm:string);
//  end;
//
// TADS1115_Channel=class(TArduinoADC_Channel)
// private
// protected
//  procedure SetModuleParameters;override;
//  procedure PinsCreate;override;
// public
//  Constructor Create(ChanelNumber: TADS1115_ChanelNumber;
//                      ADS1115_Module: TADS1115_Module);//override;
// end;
//
// TADS1115_ChannelShow=class(TPinsShowUniversal)
//   private
//    fChan:TADS1115_Channel;
//    MeasuringDeviceSimple:TMeasuringDeviceSimple;
//   protected
//    procedure LabelsFilling;
//   public
//    Constructor Create(Chan:TADS1115_Channel;
//                       LabelBit,LabelGain:TPanel;
//                       LabelMeas:TLabel;
//                       ButMeas:TButton);
//   Procedure Free;
// end;
//

implementation

uses
  Math, OlegType, PacketParameters, SysUtils;

//{ TPins_ADS1115_Chanel }
//
//constructor TPins_ADS1115_Chanel.Create(Nm: string);
//begin
//  inherited Create(Nm, ['Data rate', 'Diapazon']);
//  PinStrPart := '';
//  PinControl := $00;
//  // зберігатиметься Data rate
//  PinGate := $02;
//  // зберігатиметься Gain
//end;
//
//function TPins_ADS1115_Chanel.GetPinStr(Index: integer): string;
//begin
// if fPins[Index]=UndefinedPin then
//   Result:=PNames[Index] +' is undefined'
//                              else
//   Result:=PinValueToStr(Index);
//end;
//
//function TPins_ADS1115_Chanel.PinValueToStr(Index: integer): string;
// var i:TADS1115_Gain;
//     j:TADS1115_DataRate;
//begin
// if index=0 then
//  begin
//  for J := Low(TADS1115_DataRate) to High(TADS1115_DataRate) do
//    if fPins[Index]=ADS1115_DataRate_Kod[j] then
//     begin
//     Result:=ADS1115_DataRate_Label[j];
//     Exit;
//     end;
//  end      else
//  begin
//  for i := Low(TADS1115_Gain) to High(TADS1115_Gain) do
//    if fPins[Index]=ADS1115_Gain_Kod[i] then
//     begin
//     Result:='+/-'+ADS1115_Diapazons[i]+' V';
//     Exit;
//     end;
//  end;
//  Result:='u-u-ups';
//
//end;
//
//function TPins_ADS1115_Chanel.StrToPinValue(Str: string): integer;
// var i:TADS1115_Gain;
//     j:TADS1115_DataRate;
//begin
// for I := Low(TADS1115_Gain) to High(TADS1115_Gain) do
//  if AnsiPos( ADS1115_Diapazons[i],Str)>0 then
//   begin
//     Result:=ADS1115_Gain_Kod[i];
//     Exit;
//   end;
//
// for J := Low(TADS1115_DataRate) to High(TADS1115_DataRate) do
//  if AnsiPos( ADS1115_DataRate_Label[j],Str)>0 then
//   begin
//     Result:=ADS1115_DataRate_Kod[j];
//     Exit;
//   end;
//
// Result:=UndefinedPin;
//
//end;
//
//{ TADS1115_Channel }
//
//constructor TADS1115_Channel.Create(ChanelNumber: TADS1115_ChanelNumber;
//  ADS1115_Module: TADS1115_Module);
//begin
//  inherited Create(ChanelNumber,ADS1115_Module);
//end;
//
//procedure TADS1115_Channel.PinsCreate;
//begin
// Pins:=TPins_ADS1115_Chanel.Create(fName);
//end;
//
//procedure TADS1115_Channel.SetModuleParameters;
// var i:TADS1115_Gain;
//     j:TADS1115_DataRate;
//begin
//  inherited SetModuleParameters();
//  for J := Low(TADS1115_DataRate) to High(TADS1115_DataRate) do
//   if Pins.PinControl=ADS1115_DataRate_Kod[j] then
//     begin
//       (fParentModule as TADS1115_Module).DataRate :=
//          TADS1115_DataRate(j);
//       Break;
//     end;
// for I := Low(TADS1115_Gain) to High(TADS1115_Gain) do
//  if Pins.PinGate=ADS1115_Gain_Kod[i] then
//   begin
//     (fParentModule as TADS1115_Module).Gain :=
//        TADS1115_Gain(i);
//      Break;
//   end;
//end;
//
//{ TMCP3424_ChannelShow }
//
//constructor TADS1115_ChannelShow.Create(Chan: TADS1115_Channel;
//                   LabelBit, LabelGain: TPanel;
//                   LabelMeas: TLabel;
//                   ButMeas: TButton);
//begin
//  fChan:=Chan;
//  inherited Create(fChan.Pins,[LabelBit,LabelGain]);
//  LabelsFilling;
//
//  MeasuringDeviceSimple:=
//     TMeasuringDeviceSimple.Create(fChan,LabelMeas,srPreciseVoltage,ButMeas);
//end;
//
//procedure TADS1115_ChannelShow.Free;
//begin
//  MeasuringDeviceSimple.Free;
//  inherited Free;
//end;
//
//procedure TADS1115_ChannelShow.LabelsFilling;
// var
//  i: TADS1115_DataRate;
//  j: TADS1115_Gain;
//begin
//
//  fPinVariants[0].Clear;
//  fPinVariants[1].Clear;
//
//  for i := Low(TADS1115_DataRate) to High(TADS1115_DataRate) do
//    fPinVariants[0].Add(ADS1115_DataRate_Label[i]);
//
//  for j := Low(TADS1115_Gain) to High(TADS1115_Gain) do
//    fPinVariants[1].Add('+/-'+ADS1115_Diapazons[j]+' V, '+
//    ADS1115_LSB_labels[j]+' mkV');
//
//
//end;


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

function TINA226_Module.GetAverages: TINA226_Averages;
begin
 Result:=TINA226_Averages(Pins.PinGate)
end;

function TINA226_Module.GetMode: TΙΝΑ226_Mode;
begin
 Result:=TΙΝΑ226_Mode(FActiveChannel-1)
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
  inherited Intitiation;
//  fAverages:=ina_a1;
  fShuntVoltageCT:=ina_ct1100us;
  fBusVoltageCT:=ina_ct1100us;
  fShuntVoltage:=ErResult;
  fBusVoltage:=ErResult;
  fMetterKod := INA226Command;
  fRsh:=1;
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

procedure TINA226_Module.SetMode(const Value: TΙΝΑ226_Mode);
begin
  FActiveChannel:=ΙΝΑ226_Mode[Value];
end;

procedure TINA226_Module.SetRsh(const Value: double);
begin
 if Value<>0 then fRsh:=abs(Value);
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
                          LabelRsh: TLabel;
                          STRsh: TStaticText);
begin
  fModule:=Module;
  inherited Create(fModule.Pins,[PanelAdress,PanelAverages]);
  LabelsFilling;

  fRshShow:=
     TDoubleParameterShow.Create(STRsh,LabelRsh,'Rsh:',3.3,4);
  fRshShow.SetName(fModule.Name);
end;

procedure TINA226_ModuleShow.Free;
begin
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

procedure TINA226_ModuleShow.PinsReadFromIniFile(ConfigFile: TIniFile);
begin
  inherited PinsReadFromIniFile(ConfigFile);
  fRshShow.ReadFromIniFile(ConfigFile);
end;

procedure TINA226_ModuleShow.PinsWriteToIniFile(ConfigFile: TIniFile);
begin
  inherited PinsWriteToIniFile(ConfigFile);
  fRshShow.WriteToIniFile(ConfigFile);
end;

end.
