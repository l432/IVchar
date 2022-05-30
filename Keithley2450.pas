unit Keithley2450;

interface

uses
  TelnetDevice, IdTelnet, ShowTypes, Keitley2450Const, SCPI, OlegType, 
  OlegVector, OlegTypePart2;


type

 TKt_2450Device=class(TTelnetMeterDeviceSingle)
  private
   fSCPI:TSCPInew;
  protected
   procedure UpDate();override;
  public
   Constructor Create(SCPInew:TSCPInew;Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string);
 end;

//TKt_2450=class;

TKt_2450_SweepParameters=class(TSimpleFreeAndAiniObject)
 private
  fSource:TKt2450_Source;
  fStart:double;
  fStop:double;
  fPoints:integer;//кількість точок у розгортці
  fStep:double;//крок при лінійній розгортці, має бути більше 0
  fDelay:double;{додаткова затримка перед вимірюванням;
            -1 - autodelay
            0 - нема затримки, інші можливі значення від 5е-5 до 1е3 с}
  fCount:integer;//кількість повторів розгортки
  fRangeType:TKt2450_SweepRangeType;
  {Auto для кожного значення джерела підбирається найкращий діапазон,
   але найповільніше;
   BEST - постійний діапазон, вибирається автоматично;
   FIXed - постійний, той що встановлений перед розгорткою}
  fFailAbort:boolean;
   {при True розгортка переривається при досягненні
    граничних значень для джерела}
  fDual:boolean;
   {при True розгортка буде не лише від Start до Stop, але й потім
   від Stop до Start}
  fStartIndex:word;
   {номер, з якого починаються зчитуватися записи при створенні
   розгортки за допомогою LIST}
  procedure SetStart(Value:double);
  procedure SetStop(Value:double);
  procedure SetStep(Value:double);
  procedure SetDelay(Value:double);
  procedure SetPoints(Value:integer);
  procedure SetCount(Value:integer);
  procedure SetStartIndex(Value:Word);
  function ParameterString(itIsStepType:boolean=False):string;
  function GetLin():string;
  function GetLinStep():string;
  function GetLog():string;
  function GetList():string;
 public
  property Start:double read fStart write SetStart;
  property Stop:double read fStop write SetStop;
  property Step:double read fStep write SetStep;
  property Points:integer read fPoints write SetPoints;
  property Delay:double read fDelay write SetDelay;
  property Count:integer read fCount write SetCount;
  property RangeType:TKt2450_SweepRangeType read fRangeType write fRangeType;
  property FailAbort:boolean read fFailAbort write fFailAbort;
  property Lin:string read GetLin;
  property LinStep:string read GetLinStep;
  property Log:string read GetLog;
  property List:string read GetList;
  property Dual:boolean read fDual write fDual;
  property StartIndex:word read fStartIndex write SetStartIndex;
  constructor Create(Source:TKt2450_Source);
  class function BoolToOnOffString(bool:boolean):string;
end;


 TKt_2450=class(TSCPInew)
  private
   fTelnet:TIdTelnet;
   fIPAdressShow: TIPAdressShow;
   fIsTripped:boolean;

   fTerminal:TKt2450_OutputTerminals;
   fOutPutOn:boolean;
   fResistanceCompencateOn:TKt2450_MeasureBool;
   fAzeroState:TKt2450_MeasureBool;
   fReadBack:TKt2450_SourceBool;
   fSences:TKt2450_Senses;
   fMeasureUnits:TKt_2450_MeasureUnits;
   fOutputOffState:TKt_2450_OutputOffStates;
   fSourceType:TKt2450_Source;
   fMeasureFunction:TKt2450_Measure;
   fVoltageProtection:TKt_2450_VoltageProtection;
   fVoltageLimit:double;
   fCurrentLimit:double;
   fMode:TKt_2450_Mode;
   fSourceVoltageRange:TKt2450VoltageRange;
   fSourceCurrentRange:TKt2450CurrentRange;
   fMeasureVoltageRange:TKt2450VoltageRange;
   fMeasureCurrentRange:TKt2450CurrentRange;
   fMeasureVoltageLowRange:TKt2450VoltageRange;
   fMeasureCurrentLowRange:TKt2450CurrentRange;
   fSourceDelay:TKt2450_SourceDouble;
   fSourceDelayAuto:TKt2450_SourceBool;
   fDataVector:TVector;
   procedure OnOffFromBool(toOn:boolean);
   function StringToVoltageProtection(Str:string;var vp:TKt_2450_VoltageProtection):boolean;
   function StringToSourceType(Str:string):boolean;
   function StringToMeasureFunction(Str:string):boolean;
   function StringToTerminals(Str:string):boolean;
   function StringToOutPutState(Str:string):boolean;
   function StringToMeasureUnit(Str:string):boolean;
   procedure StringToArray(Str:string);
   function IsLimitExcided(FirstLevelNode,LeafNode:byte):boolean;
   {типова функція для запиту, чи ввімкнув прилад певні захисти}
   function ModeDetermination:TKt_2450_Mode;
   function ValueToVoltageRange(Value:double):TKt2450VoltageRange;
   function VoltageRangeToString(Range:TKt2450VoltageRange):string;
   function ValueToCurrentRange(Value:double):TKt2450CurrentRange;
   function CurrentRangeToString(Range:TKt2450CurrentRange):string;
  protected
   procedure PrepareString;override;
   procedure DeviceCreate(Nm:string);override;
   procedure DefaultSettings;override;
  public
   SweepParameters:array[TKt2450_Source]of TKt_2450_SweepParameters;
   property DataVector:TVector read fDataVector;
   property SourceType:TKt2450_Source read fSourceType;
   property MeasureFunction:TKt2450_Measure read fMeasureFunction;
   property VoltageProtection:TKt_2450_VoltageProtection read fVoltageProtection;
   property VoltageLimit:double read fVoltageLimit;
   property CurrentLimit:double read fCurrentLimit;
   property Terminal:TKt2450_OutputTerminals read fTerminal;
   property OutPutOn:boolean read fOutPutOn;
   property ResistanceCompencateOn:TKt2450_MeasureBool read fResistanceCompencateOn;
   property ReadBack:TKt2450_SourceBool read fReadBack;
   property Sences:TKt2450_Senses read fSences;
   property MeasureUnits:TKt_2450_MeasureUnits read fMeasureUnits;
   property OutputOffState:TKt_2450_OutputOffStates read fOutputOffState;
   property Mode:TKt_2450_Mode read fMode;
   property SourceVoltageRange:TKt2450VoltageRange read fSourceVoltageRange;
   property SourceCurrentRange:TKt2450CurrentRange read fSourceCurrentRange;
   property MeasureVoltageRange:TKt2450VoltageRange read fMeasureVoltageRange;
   property MeasureCurrentRange:TKt2450CurrentRange read fMeasureCurrentRange;
   property MeasureVoltageLowRange:TKt2450VoltageRange read fMeasureVoltageLowRange;
   property MeasureCurrentLowRange:TKt2450CurrentRange read fMeasureCurrentLowRange;
   property AzeroState:TKt2450_MeasureBool read fAzeroState;
   property SourceDelay:TKt2450_SourceDouble read fSourceDelay;
   property SourceDelayAuto:TKt2450_SourceBool read fSourceDelayAuto;

   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string='Keitley2450');
   destructor Destroy; override;

   function Test():boolean;override;
   procedure ProcessingString(Str:string);override;
   procedure ResetSetting();
   procedure MyTraining();

   procedure OutPutChange(toOn:boolean);
   {вмикає/вимикає вихід приладу}
   function  IsOutPutOn():boolean;

   procedure SetInterlockStatus(toOn:boolean);
   function IsInterlockOn():boolean;

   procedure ClearUserScreen();
   procedure TextToUserScreen(top_text:string='';bottom_text:string='');

   procedure SaveSetup(SlotNumber:TKt2450_SetupMemorySlot);
   procedure LoadSetup(SlotNumber:TKt2450_SetupMemorySlot);
   procedure LoadSetupPowerOn(SlotNumber:TKt2450_SetupMemorySlot);
   procedure UnloadSetupPowerOn();
   procedure RunningMacroScript(ScriptName:string);

   procedure SetTerminal(Terminal:TKt2450_OutputTerminals);
   {вихід на передню чи задню панель}
   function GetTerminal():boolean;
   {вихід на передню чи задню панель}

   procedure SetSense(MeasureType:TKt2450_Measure;Sense:TKt2450_Sense);
   {2-зондовий чи 4-зондовий спосіб вимірювання}
   function GetSense(MeasureType:TKt2450_Measure):boolean;
   function GetSenses():boolean;


   procedure SetOutputOffState(Source:TKt2450_Source;
                           OutputOffState:TKt_2450_OutputOffState);
   {перемикання типу входу: нормальний, високоімпедансний тощо}
   function GetOutputOffState(Source:TKt2450_Source):boolean;
   function GetOutputOffStates():boolean;

   procedure SetReadBackState(Source:TKt2450_Source;
                              toOn:boolean);overload;
   {чи вимірюється те значення, що подається з приладу;
   якщо ні - то буде використовуватися (в розрахунках, тощо)
   значення, яке заплановано}
   procedure SetReadBackState(toOn:boolean);overload;
   function IsReadBackOn(Source:TKt2450_Source):boolean;overload;
   function IsReadBackOn():boolean;overload;
   function GetReadBacks():boolean;

   procedure SetAzeroState(Measure:TKt2450_Measure;
                              toOn:boolean);overload;
   {чи перевіряються опорні значення перед кожним виміром}
   procedure SetAzeroState(toOn:boolean);overload;
   function IsAzeroStateOn(Measure:TKt2450_Measure):boolean;overload;
   function IsAzeroStateOn():boolean;overload;
   function GetAzeroStates():boolean;
   procedure AzeroOnce();
   {примусова перевірка опорного значення}

   procedure SetResistanceCompencate(toOn:boolean);
   {ввімкнення/вимкнення компенсації опору}
   function IsResistanceCompencateOn():boolean;

   procedure SetVoltageProtection(Level:TKt_2450_VoltageProtection);
   {встановлення значення захисту від перенапруги}
   function  GetVoltageProtection():boolean;
   {запит номеру режиму в TKt_2450_VoltageProtection}
   function IsVoltageProtectionActive():boolean;
   {перевірка, чи вімкнувся захист від перенапруги}

   procedure SetVoltageLimit(Value:double=0);
   {встановлення граничної напруги джерела}
   procedure SetCurrentLimit(Value:double=0);
   {встановлення граничного струму джерела}
   function  GetVoltageLimit():boolean;
   {запит величини граничної напруги джерела}
   function  GetCurrentLimit():boolean;
   {запит величини граничної напруги джерела}
   function IsVoltageLimitExceeded():boolean;
   {перевірка, чи була спроба перевищення напруги}
   function IsCurrentLimitExceeded():boolean;
   {перевірка, чи була спроба перевищення напруги}

   procedure SetSourceType(SourseType:TKt2450_Source=kt_sVolt);
   {прилад як джерело напруги чи струму;
   при цьому вихід виключається OutPut=Off}
   function GetSourceType():boolean;

   procedure SetMeasureFunction(MeasureFunction:TKt2450_Measure=kt_mCurrent);
   {прилад вимірює напругу чи струм}
   function GetMeasureFunction():boolean;

   procedure SetMeasureUnit(Measure:TKt2450_Measure; MeasureUnit:TKt_2450_MeasureUnit);
   {що буде вимірювати (розраховувати) при реальних вимірах Measure}
   function GetMeasureUnit(Measure:TKt2450_Measure):boolean;
   function GetMeasureUnits():boolean;

   procedure SetMode(Mode:TKt_2450_Mode);
   function GetDeviceMode():boolean;

   procedure SetSourceVoltageRange(Range:TKt2450VoltageRange=kt_vrAuto);
   function GetSourceVoltageRange():boolean;
   procedure SetSourceCurrentRange(Range:TKt2450CurrentRange=kt_crAuto);
   function GetSourceCurrentRange():boolean;
   function GetSourceRanges():boolean;

   procedure SetMeasureVoltageRange(Range:TKt2450VoltageRange=kt_vrAuto);
   function GetMeasureVoltageRange():boolean;
   procedure SetMeasureCurrentRange(Range:TKt2450CurrentRange=kt_crAuto);
   function GetMeasureCurrentRange():boolean;
   function GetMeasureRanges():boolean;

   procedure SetMeasureVoltageLowRange(Range:TKt2450VoltageRange=kt_vr20mV);
   {якщо встановлено автоматичний пошук діапазону для вимірювань,
   можна встановити найнижчий діапазон, з якого починатиметься
   пошук потрібного}
   function GetMeasureVoltageLowRange():boolean;
   procedure SetMeasureCurrentLowRange(Range:TKt2450CurrentRange=kt_cr10nA);
   function GetMeasureCurrentLowRange():boolean;
   function GetMeasureLowRanges():boolean;

   procedure SetMeasureHighRange(Value:double);
   {встановлює максимальний діапазон (прив'язаний до Value)
   для вимірювань при автоматичному  режимі встановленого зараз способу вимірювання;
   не робив детальних як для попереднього, бо не виносив на керування}

   procedure SetSourceDelay(Source:TKt2450_Source;
                            value:double);overload;
   {час затримки між встановленням значення джерела
   та початком вимірювання}
   procedure SetSourceDelay(value:double);overload;
   function GetSourceDelay(Source:TKt2450_Source):boolean;overload;
   function GetSourceDelay():boolean;overload;
   function GetSourceDelays():boolean;
   procedure SetSourceDelayAuto(Source:TKt2450_Source;
                            toOn:boolean);overload;
   {час затримки між встановленням значення джерела
   та початком вимірювання}
   procedure SetSourceDelayAuto(toOn:boolean);overload;
   function IsSourceDelayAutoOn(Source:TKt2450_Source):boolean;overload;
   function IsSourceDelayAutoOn():boolean;overload;
   function GetSourceDelayAutoOns():boolean;

   procedure SourceListCreate(Source:TKt2450_Source;ListValues:TArrSingle);overload;
   {створення списку значень джерела, які будуть використовуватися під час
   послідовності вимірювань}
   procedure SourceListCreate(ListValues:TArrSingle);overload;
   function GetSourceList(Source:TKt2450_Source):boolean;overload;
   {отримані значення розташовуються в DataVector.X та DataVector.Y}
   function GetSourceList():boolean;overload;
   procedure SourceListAppend(Source:TKt2450_Source;ListValues:TArrSingle);overload;
   {значення додаються до списку значень джерела, які будуть використовуватися під час
   послідовності вимірювань}
   procedure SourceListAppend(ListValues:TArrSingle);overload;

   procedure SwepLinearPointCreate();
   procedure SwepLinearStepCreate();
   procedure SwepListCreate(StartIndex:word=1);
   procedure SwepLogStepCreate();

   Procedure GetParametersFromDevice;

   Procedure Init;
   Procedure Abort;
 end;


var
  Kt_2450:TKt_2450;

implementation

uses
  Dialogs, SysUtils, Math;

{ TKt_2450 }

procedure TKt_2450.Abort;
begin
//:ABOR
 SetupOperation(18,0,0,False);
end;

procedure TKt_2450.AzeroOnce;
begin
//:AZERo:ONCE
 SetupOperation(16,0,0,False);
end;

procedure TKt_2450.ClearUserScreen;
begin
// :DISP:CLE
 SetupOperation(6,3,0,false);
end;

constructor TKt_2450.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
 fTelnet:=Telnet;
 fIPAdressShow:=IPAdressShow;
 inherited Create(Nm);
end;

function TKt_2450.CurrentRangeToString(Range: TKt2450CurrentRange): string;
begin
 Result:=floattostr(1e-8*Power(10,ord(Range)-1));
end;

procedure TKt_2450.ResetSetting;
begin
//  *RST
  SetupOperation(2,0,0,False);
end;

procedure TKt_2450.RunningMacroScript(ScriptName: string);
begin
//  SCR:RUN "ScriptName"
  fAdditionalString:=StringToInvertedCommas(ScriptName);
  SetupOperation(8);
end;

procedure TKt_2450.DefaultSettings;
 var i:integer;
begin
 fIsTripped:=False;
 fSourceType:=kt_sVolt;
 fMeasureFunction:=kt_mCurrent;
 fVoltageProtection:=kt_vpnone;
 fVoltageLimit:=Kt_2450_VoltageLimDef;
 fCurrentLimit:=Kt_2450_CurrentLimDef;
 fTerminal:=kt_otFront;
 fOutPutOn:=False;
// fResistanceCompencateOn:=False;
 for I := ord(Low(TKt2450_Measure)) to ord(High(TKt2450_Measure)) do
   begin
   fSences[TKt2450_Measure(i)]:=kt_s2wire;
   fMeasureUnits[TKt2450_Measure(i)]:=kt_mu_amp;
   fResistanceCompencateOn[TKt2450_Measure(i)]:=False;
   fAzeroState[TKt2450_Measure(i)]:=True;
   end;
 for I := ord(Low(TKt2450_Source)) to ord(High(TKt2450_Source)) do
   begin
   fReadBack[TKt2450_Source(i)]:=True;
   fSourceDelay[TKt2450_Source(i)]:=0;
   fSourceDelayAuto[TKt2450_Source(i)]:=True;
   SweepParameters[TKt2450_Source(i)]:=TKt_2450_SweepParameters.Create(TKt2450_Source(i));
   end;
 for I := ord(Low(TKt2450_Source)) to ord(High(TKt2450_Source)) do
   fOutputOffState[TKt2450_Source(i)]:=kt_oos_norm;
 fMode:=ModeDetermination();
// fMode:=kt_md_sVmP;
 fSourceVoltageRange:=kt_vrAuto;
 fSourceCurrentRange:=kt_crAuto;
 fMeasureVoltageRange:=kt_vrAuto;
 fMeasureCurrentRange:=kt_crAuto;
 fMeasureVoltageLowRange:=kt_vr20mV;
 fMeasureCurrentLowRange:=kt_cr10nA;

 fDataVector:=TVector.Create;

end;

destructor TKt_2450.Destroy;
 var i:TKt2450_Source;
begin
  for I := Low(TKt2450_Source) to High(TKt2450_Source) do
   FreeAndNil(SweepParameters[i]);
  FreeAndNil(fDataVector);
  inherited;
end;

procedure TKt_2450.DeviceCreate(Nm: string);
begin
 fDevice:=TKt_2450Device.Create(Self,fTelnet,fIPAdressShow,Nm);
end;

function TKt_2450.GetAzeroStates: boolean;
 var i:TKt2450_Measure;
begin
 Result:=True;
 for I := Low(TKt2450_Measure) to High(TKt2450_Measure) do
   Result:=Result and IsAzeroStateOn(i);
end;

function TKt_2450.GetCurrentLimit: boolean;
begin
 QuireOperation(11,13,13);
 Result:=(fDevice.Value<>ErResult);
 if Result then fCurrentLimit:=fDevice.Value;
end;

function TKt_2450.GetDeviceMode: boolean;
begin
 Result:=True;
 Result:=Result and GetMeasureFunction();
 Result:=Result and GetMeasureUnit(fMeasureFunction);
 Result:=Result and GetSourceType();
 if Result then fMode:=ModeDetermination;
end;

function TKt_2450.IsInterlockOn: boolean;
begin
//:OUTP:INT:STAT?
 QuireOperation(5,5);
 Result:=(fDevice.Value=1);
end;

function TKt_2450.GetMeasureCurrentLowRange: boolean;
begin
  try
  QuireOperation(12,15,18);
  fMeasureCurrentRange:=ValueToCurrentRange(fDevice.Value);
  Result:=(fDevice.Value<>ErResult);
  except
  Result:=false
  end;
end;

function TKt_2450.GetMeasureCurrentRange: boolean;
begin
 QuireOperation(12,16);
 Result:=(fDevice.Value<>ErResult);
 if not(Result) then Exit;

 if fDevice.Value=1 then  fSourceCurrentRange:=kt_crAuto
                    else
   begin
    try
    QuireOperation(12,15);
    fMeasureCurrentRange:=ValueToCurrentRange(fDevice.Value);
    except
    Result:=false
    end;
   end;
end;

function TKt_2450.GetMeasureFunction: boolean;
begin
 QuireOperation(15);
 Result:=(fDevice.Value<>ErResult);
// showmessage('measure '+inttostr(ord(fMeasureFunction)))
end;

function TKt_2450.GetMeasureLowRanges: boolean;
begin
 Result:=GetMeasureVoltageLowRange() and GetMeasureCurrentLowRange();
end;

function TKt_2450.GetMeasureRanges: boolean;
begin
 Result:=GetMeasureVoltageRange() and GetMeasureCurrentRange();
end;

function TKt_2450.GetMeasureUnit(Measure: TKt2450_Measure): boolean;
begin
 Result:=False;
 if Measure>kt_mVoltage then Exit;
 QuireOperation(ord(Measure)+12,14);
 Result:=(fDevice.Value<>ErResult);
// showmessage('measure2 '+inttostr(ord(Measure)));
//  showmessage('unit '+inttostr(ord(fMeasureUnits[Measure])))

end;

function TKt_2450.GetMeasureUnits: boolean;
 var i:TKt2450_Measure;
begin
 Result:=True;
 for I := kt_mCurrent to kt_mVoltage do
   Result:=Result and GetMeasureUnit(i);
end;

function TKt_2450.GetMeasureVoltageLowRange: boolean;
begin
  try
  QuireOperation(13,15,18);
  fMeasureVoltageRange:=ValueToVoltageRange(fDevice.Value);
  Result:=(fDevice.Value<>ErResult);
  except
  result:=false
  end;
end;

function TKt_2450.GetMeasureVoltageRange: boolean;
begin
 QuireOperation(13,16);
 Result:=(fDevice.Value<>ErResult);
 if not(Result) then Exit;

 if fDevice.Value=1 then  fMeasureVoltageRange:=kt_vrAuto
                    else
   begin
    try
    QuireOperation(13,15);
    fMeasureVoltageRange:=ValueToVoltageRange(fDevice.Value);
    except
    result:=false
    end;
   end;
end;

function TKt_2450.GetOutputOffState(Source: TKt2450_Source): boolean;
begin
 QuireOperation(5,1-ord(Source),8);
 Result:=(fDevice.Value<>ErResult);
// fOutputOffState[Source]:=TKt_2450_OutputOffState(round(fDevice.Value));
end;

function TKt_2450.GetOutputOffStates: boolean;
 var i:TKt2450_Source;
begin
 Result:=True;
 for I := Low(TKt2450_Source) to High(TKt2450_Source) do
   Result:=Result and GetOutputOffState(i);
end;

procedure TKt_2450.GetParametersFromDevice;
begin
 if not(GetVoltageProtection()) then Exit;
 if not(GetVoltageLimit()) then Exit;
 if not(GetCurrentLimit()) then Exit;
 if not(GetSourceType()) then Exit;  //GetDeviceMode
 if not(GetMeasureFunction()) then Exit; //GetDeviceMode
 if not(IsResistanceCompencateOn()) then Exit;  //має бути після GetMeasureFunction

 if not(GetTerminal()) then Exit;
 if not(IsOutPutOn()) then Exit;
 if not(GetSenses()) then Exit;
 if not(GetOutputOffStates()) then Exit;
 if not(GetMeasureUnits()) then Exit; //GetDeviceMode
 fMode:=ModeDetermination();
 if not(GetReadBacks()) then Exit;
 if not(GetSourceRanges()) then Exit;
 if not(GetMeasureRanges()) then Exit;
 if not(GetMeasureLowRanges()) then Exit;
 if not(GetAzeroStates()) then Exit;
 if not(GetSourceDelays()) then Exit;
  if not(GetSourceDelayAutoOns()) then Exit;
end;

function TKt_2450.IsReadBackOn(Source: TKt2450_Source): boolean;
begin
 QuireOperation(11,1-ord(Source)+12,17);
 Result:=(fDevice.Value=1);
 fReadBack[Source]:=Result;
end;

function TKt_2450.GetReadBacks: boolean;
 var i:TKt2450_Source;
begin
 Result:=True;
 for I := Low(TKt2450_Source) to High(TKt2450_Source) do
   Result:=Result and IsReadBackOn(i);
end;

function TKt_2450.GetSense(MeasureType: TKt2450_Measure): boolean;
begin
 QuireOperation(12+ord(MeasureType),7);
 Result:=(fDevice.Value<>ErResult);
 fSences[MeasureType]:=TKt2450_Sense(1-round(fDevice.Value));
end;

function TKt_2450.GetSenses: boolean;
 var i:TKt2450_Measure;
begin
 Result:=True;
 for I := Low(TKt2450_Measure) to High(TKt2450_Measure) do
   Result:=Result and GetSense(i);
end;

function TKt_2450.GetSourceCurrentRange: boolean;
begin
 QuireOperation(11,12,16);
 Result:=(fDevice.Value<>ErResult);
 if not(Result) then Exit;

 if fDevice.Value=1 then  fSourceCurrentRange:=kt_crAuto
                    else
   begin
    try
    QuireOperation(11,12,15);
    fSourceCurrentRange:=ValueToCurrentRange(fDevice.Value);
    except
    Result:=false
    end;
   end;
end;

function TKt_2450.GetSourceDelay(Source: TKt2450_Source): boolean;
begin
 QuireOperation(11,1-ord(Source)+12,21);
 Result:=(fDevice.Value<>ErResult);
 if Result then fSourceDelay[Source]:=fDevice.Value;
end;

function TKt_2450.GetSourceDelay: boolean;
begin
 Result:=GetSourceDelay(fSourceType);
end;

function TKt_2450.GetSourceDelayAutoOns: boolean;
begin
 Result:=IsSourceDelayAutoOn(kt_sVolt)and IsSourceDelayAutoOn(kt_sCurr);
end;

function TKt_2450.GetSourceDelays: boolean;
begin
 Result:=GetSourceDelay(kt_sVolt) and GetSourceDelay(kt_sCurr);
end;

function TKt_2450.GetSourceList: boolean;
begin
 Result:=GetSourceList(fSourceType);
end;

function TKt_2450.GetSourceList(Source: TKt2450_Source): boolean;
begin
 QuireOperation(11,23,1-ord(Source)+12);
 Result:=(fDevice.Value=1);
end;

function TKt_2450.GetSourceRanges: boolean;
begin
 Result:=GetSourceVoltageRange() and GetSourceCurrentRange();
end;

function TKt_2450.GetSourceType: boolean;
begin
 QuireOperation(11,55,55);
 Result:=(fDevice.Value<>ErResult);
end;

function TKt_2450.GetSourceVoltageRange:boolean;
begin
 QuireOperation(11,13,16);
 Result:=(fDevice.Value<>ErResult);
 if not(Result) then Exit;

 if fDevice.Value=1 then  fSourceVoltageRange:=kt_vrAuto
                    else
   begin
    try
    QuireOperation(11,13,15);
    fSourceVoltageRange:=ValueToVoltageRange(fDevice.Value);
//    TKt2450VoltageRange(round(Log10(fDevice.Value/2e-2))+1);
    except
    result:=false
    end;
   end;
end;

function TKt_2450.GetTerminal: boolean;
begin
 QuireOperation(9,6);
 Result:=(fDevice.Value<>ErResult);
end;

function TKt_2450.GetVoltageLimit: boolean;
begin
 QuireOperation(11,12,12);
 Result:=(fDevice.Value<>ErResult);
 if Result then fVoltageLimit:=fDevice.Value;
end;

function TKt_2450.GetVoltageProtection: boolean;
begin
 QuireOperation(11,13,10);
 Result:=(fDevice.Value<>ErResult);
end;

function TKt_2450.IsAzeroStateOn(Measure: TKt2450_Measure): boolean;
begin
 QuireOperation(ord(Measure)+12,20);
 Result:=(fDevice.Value=1);
 fAzeroState[Measure]:=Result;
end;

procedure TKt_2450.Init;
begin
// INIT
 SetupOperation(17,0,0,False);
end;

function TKt_2450.IsAzeroStateOn: boolean;
begin
 Result:=IsAzeroStateOn(fMeasureFunction);
end;

function TKt_2450.IsCurrentLimitExceeded: boolean;
begin
 Result:=IsLimitExcided(13,13);
end;

function TKt_2450.IsLimitExcided(FirstLevelNode, LeafNode: byte): boolean;
begin
 fIsTripped:=True;
 QuireOperation(11,FirstLevelNode,LeafNode);
 Result:=(fDevice.Value=1);
 fIsTripped:=False;
end;

function TKt_2450.IsOutPutOn: boolean;
begin
 QuireOperation(5,55);
 Result:=(fDevice.Value=1);
 fOutPutOn:=Result;
end;

function TKt_2450.IsReadBackOn: boolean;
begin
 Result:=IsReadBackOn(fSourceType);
end;

function TKt_2450.IsResistanceCompencateOn: boolean;
begin
 case fMeasureFunction of
   kt_mCurrent: QuireOperation(12,9);
   kt_mVoltage: QuireOperation(13,9);
 end;
 Result:=(fDevice.Value=1);
 fResistanceCompencateOn[fMeasureFunction]:=Result;
end;

function TKt_2450.IsSourceDelayAutoOn(Source: TKt2450_Source): boolean;
begin
 QuireOperation(11,1-ord(Source)+12,22);
 Result:=(fDevice.Value=1);
 fSourceDelayAuto[Source]:=Result;
end;

function TKt_2450.IsSourceDelayAutoOn: boolean;
begin
 result:=IsSourceDelayAutoOn(fSourceType);
end;

function TKt_2450.IsVoltageLimitExceeded: boolean;
begin
 Result:=IsLimitExcided(12,12);
end;

function TKt_2450.IsVoltageProtectionActive: boolean;
begin
 Result:=IsLimitExcided(13,10);
end;

procedure TKt_2450.LoadSetup(SlotNumber: TKt2450_SetupMemorySlot);
begin
// *RCL <n>
 fAdditionalString:=inttostr(SlotNumber);
 SetupOperation(1);
end;

procedure TKt_2450.LoadSetupPowerOn(SlotNumber: TKt2450_SetupMemorySlot);
begin
//  SYST:POS SAV1
  fAdditionalString:='sav'+inttostr(SlotNumber);
  SetupOperation(7,4);
end;

function TKt_2450.ModeDetermination: TKt_2450_Mode;
begin
 Result:=kt_md_sVmC;
// case fSourceType of
//   kt_sVolt: case fMeasureFunction of
//             kt_mCurrent:Result:=TKt_2450_Mode(ord(fMeasureUnits[kt_mCurrent]));
//             kt_mVoltage:Result:=TKt_2450_Mode(ord(fMeasureUnits[kt_mVoltage]));
//             end;
//   kt_sCurr:case fMeasureFunction of
//             kt_mCurrent:Result:=TKt_2450_Mode(3+ord(fMeasureUnits[kt_mCurrent]));
//             kt_mVoltage:Result:=TKt_2450_Mode(3+ord(fMeasureUnits[kt_mCurrent]));
//             end;
// end;

// showmessage('mode '+inttostr(ord(fMeasureUnits[fMeasureFunction])));
 case fSourceType of
   kt_sVolt:Result:=TKt_2450_Mode(ord(fMeasureUnits[fMeasureFunction]));
   kt_sCurr:Result:=TKt_2450_Mode(4+ord(fMeasureUnits[fMeasureFunction]));
 end;

//       TKt_2450_MeasureUnit=(kt_mu_amp,kt_mu_volt, kt_mu_ohm, kt_mu_watt);
end;

procedure TKt_2450.MyTraining;
// var str:string;
  var ArrDouble: TArrSingle;
begin
//  (fDevice as TTelnetMeterDeviceSingle).SetStringToSend(':FORMat:ASCii:PRECision?');
//  (fDevice as TTelnetMeterDeviceSingle).SetStringToSend(':SOUR:VOLT:RANG:Auto?');
//  fDevice.Request();
//  fDevice.GetData;


//Init();
//Abort();

//SwepLinearPointCreate();
//SwepLinearStepCreate();
//SwepListCreate();
//SwepLogStepCreate();


//SetLength(ArrDouble,3);
//ArrDouble[0]:=1;
//ArrDouble[1]:=0.5;
//ArrDouble[2]:=0.75;
//SourceListCreate(kt_sVolt,ArrDouble);
//SourceListCreate(kt_sCurr,ArrDouble);
//if GetSourceList(kt_sCurr) then
//   showmessage(fDataVector.XYtoString);
//SourceListAppend(kt_sCurr,ArrDouble);
//if GetSourceList(kt_sCurr) then
//   showmessage(fDataVector.XYtoString);


// if IsSourceDelayAutoOn(kt_sCurr) then
//     showmessage(booltostr(fSourceDelayAuto[kt_sCurr],True));
// SetSourceDelayAuto(kt_sVolt,False);
// if IsSourceDelayAutoOn then
//     showmessage(booltostr(fSourceDelayAuto[kt_sVolt],True));

// SetSourceDelayAuto(kt_sVolt,False);
// SetSourceDelayAuto(True);

//if GetSourceDelay(kt_sVolt) then
//  showmessage('ura! '+floattostr(fSourceDelay[kt_sVolt]));
//if GetSourceDelay(kt_sCurr) then
//  showmessage('ura! '+floattostr(fSourceDelay[kt_sCurr]));

//SetSourceDelay(kt_sVolt,0.256);
//SetSourceDelay(kt_sCurr,1.25e-10);

//  AzeroOnce();

// showmessage(booltostr(IsAzeroStateOn(),True));
// SetAzeroState(False);
// showmessage(booltostr(IsAzeroStateOn(),True));

//SetAzeroState(False);
//SetAzeroState(True);
//SetAzeroState(kt_mCurrent,False);
//SetAzeroState(kt_mVoltage,True);

//SetMeasureHighRange(0.526);

//if GetMeasureVoltageLowRange() then
//  showmessage('ura! '+KT2450_VoltageRangeLabels[fMeasureVoltageLowRange]);
//if GetMeasureCurrentLowRange() then
//  showmessage('ura! '+KT2450_CurrentRangeLabels[fMeasureCurrentLowRange]);

//SetMeasureCurrentLowRange();
//SetMeasureCurrentLowRange(kt_cr10nA);
//SetMeasureCurrentLowRange(kt_cr100mA);

//SetMeasureVoltageLowRange();
//SetMeasureVoltageLowRange(kt_vr200mV);
//SetMeasureVoltageLowRange(kt_vr20V);

//if GetMeasureVoltageRange() then
//  showmessage('ura! '+KT2450_VoltageRangeLabels[fMeasureVoltageRange]);
//if GetMeasureCurrentRange() then
//  showmessage('ura! '+KT2450_CurrentRangeLabels[fMeasureCurrentRange]);

//SetMeasureCurrentRange();
//SetMeasureCurrentRange(kt_cr10nA);
//SetMeasureCurrentRange(kt_cr100mA);

//SetMeasureVoltageRange();
//SetMeasureVoltageRange(kt_vr200mV);
//SetMeasureVoltageRange(kt_vr20V);

//---------------------------------------------------------------------
//if GetSourceVoltageRange() then
//  showmessage('ura! '+KT2450_VoltageRangeLabels[fSourceVoltageRange]);
//if GetSourceCurrentRange() then
//  showmessage('ura! '+KT2450_CurrentRangeLabels[fSourceCurrentRange]);

//SetSourceVoltageRange();
//SetSourceVoltageRange(kt_vr200mV);
//SetSourceVoltageRange(kt_vr20V);

//SetSourceCurrentRange();
//SetSourceCurrentRange(kt_vr10nA);
//SetSourceCurrentRange(kt_vr100mA);

// showmessage(booltostr(IsReadBackOn(),True));
// SetReadBackState(False);
// showmessage(booltostr(IsReadBackOn(),True));

//SetReadBackState(kt_sVolt,False);
//SetReadBackState(kt_sVolt,True);
//SetReadBackState(True);

//SetMode(kt_md_sVmR);
//SetMode(kt_md_sImV);

//if GetMeasureUnit(kt_mCurrent) then
//  showmessage('ura! '+SuffixKt_2450[ord(fMeasureUnits[kt_mCurrent])+4]);
//SetMeasureUnit(kt_mCurrent,kt_mu_ohm);
//if GetMeasureUnit(kt_mCurrent) then
//  showmessage('ura! '+SuffixKt_2450[ord(fMeasureUnits[kt_mCurrent])+4]);
//SetMeasureUnit(kt_mVoltage,kt_mu_watt);
//if GetMeasureUnit(kt_mVoltage) then
//  showmessage('ura! '+SuffixKt_2450[ord(fMeasureUnits[kt_mVoltage])+4]);

//SetMeasureUnit(kt_mCurrent,kt_mu_amp);
//SetMeasureUnit(kt_mCurrent,kt_mu_volt);
//SetMeasureUnit(kt_mCurrent,kt_mu_ohm);
//SetMeasureUnit(kt_mCurrent,kt_mu_watt);
//SetMeasureUnit(kt_mVoltage,kt_mu_ohm);


// if GetMeasureFunction()
//    then showmessage('ura!'+RootNoodKt_2450[ord(fMeasureFunction)+12]);
// SetMeasureFunction(kt_mVoltage);
// if GetMeasureFunction()
//   then showmessage('ura!'+RootNoodKt_2450[ord(fMeasureFunction)+12]);

//SetMeasureFunction();
//SetMeasureFunction(kt_mVoltage);
//SetMeasureFunction(kt_mResistance);

// if GetSourceType() then showmessage(Kt2450_SourceName[fSourceType]);
// SetSourceType(kt_sCurr);
// if GetSourceType() then showmessage(Kt2450_SourceName[fSourceType]);

//SetSourceType();
//SetSourceType(kt_sCurr);

// showmessage(booltostr(IsCurrentLimitExceeded(),True));
// showmessage(booltostr(IsVoltageLimitExceeded(),True));

//  SetCurrentLimit(21e-9);
//  if GetCurrentLimit() then
//   showmessage('ura! '+floattostr(fCurrentLimit));
//  SetCurrentLimit(5.3681e-6);
//  if GetCurrentLimit() then
//   showmessage('ura! '+floattostr(fCurrentLimit));
//  SetCurrentLimit(0.05289);
//  if GetCurrentLimit() then
//   showmessage('ura! '+floattostr(fCurrentLimit));
//  SetCurrentLimit(0.502);
//  if GetCurrentLimit() then
//   showmessage('ura! '+floattostr(fCurrentLimit));
//  SetCurrentLimit();

// SetVoltageLimit();
// if GetVoltageLimit() then
//   showmessage('ura! '+floattostr(fVoltageLimit));
// SetVoltageLimit(300);
// if GetVoltageLimit() then
//   showmessage('ura! '+floattostr(fVoltageLimit));
// SetVoltageLimit(0.0211);
// if GetVoltageLimit() then
//   showmessage('ura! '+floattostr(fVoltageLimit));

// SetCurrentLimit();
// SetCurrentLimit(2);
// SetCurrentLimit(1.578968e-6);

// SetVoltageLimit();
// SetVoltageLimit(300);
// SetVoltageLimit(20.12345678);

// showmessage(booltostr(IsVoltageProtectionActive(),True));

// if  GetVoltageProtection() then
//   showmessage(Kt_2450_VoltageProtectionLabel[fVoltageProtection]);
//  SetVoltageProtection(kt_vpnone);

// fMeasureFunction:=kt_mCurrent;
// showmessage(booltostr(IsResistanceCompencateOn(),True));
//
// fMeasureFunction:=kt_mVoltage;
// showmessage(booltostr(IsResistanceCompencateOn(),True));

// fMeasureFunction:=kt_mCurrent;
// SetResistanceCompencate(True);
// SetResistanceCompencate(False);
//
// fMeasureFunction:=kt_mVoltage;
// SetResistanceCompencate(True);
// SetResistanceCompencate(False);


//SetOutputOffState(kt_sVolt,kt_oos_zero);
//if GetOutputOffState(kt_sVolt)
//   then showmessage('ura!! '+KT2450_OutputOffStateLabels[fOutputOffState[kt_sVolt]]);
//SetOutputOffState(kt_sVolt,kt_oos_himp);
//if GetOutputOffState(kt_sVolt)
//   then showmessage('ura!! '+KT2450_OutputOffStateLabels[fOutputOffState[kt_sVolt]]);
//SetOutputOffState(kt_sVolt,kt_oos_norm);
//if GetOutputOffState(kt_sVolt)
//   then showmessage('ura!! '+KT2450_OutputOffStateLabels[fOutputOffState[kt_sVolt]]);
//
//SetOutputOffState(kt_sCurr,kt_oos_guard);
//if GetOutputOffState(kt_sCurr)
//   then showmessage('ura!! '+KT2450_OutputOffStateLabels[fOutputOffState[kt_sCurr]]);
//SetOutputOffState(kt_sCurr,kt_oos_norm);
//if GetOutputOffState(kt_sCurr)
//   then showmessage('ura!! '+KT2450_OutputOffStateLabels[fOutputOffState[kt_sCurr]]);


//SetSense(kt_mCurrent,kt_s4wire);
//GetSense(kt_mCurrent);
//showmessage(inttostr(ord(fSences[kt_mCurrent])));
//SetSense(kt_mCurrent,kt_s2wire);
//showmessage(inttostr(ord(fSences[kt_mCurrent])));

//GetSense(kt_mVoltage);
//showmessage(inttostr(ord(fSences[kt_mVoltage])));

//SetSense(kt_mResistance,kt_s4wire);
//GetSense(kt_mResistance);
//showmessage(inttostr(ord(fSences[kt_mResistance])));
//SetSense(kt_mResistance,kt_s2wire);
//GetSense(kt_mResistance);
//showmessage(inttostr(ord(fSences[kt_mResistance])));

//showmessage(booltostr(IsOutPutOn(),True));

//showmessage(booltostr(GetTerminals(),True));


//LoadSetupPowerOn(1);
//UnloadSetupPowerOn();

// SetInterlockStatus(false);
// showmessage(booltostr(IsInterlockOn,True));

// TextToUserScreen('Hi, Oleg!','I am glad to see you');
// ClearUserScreen();

end;

procedure TKt_2450.OnOffFromBool(toOn: boolean);
begin
 fAdditionalString:=TKt_2450_SweepParameters.BoolToOnOffString(toOn);
// if toOn then fAdditionalString:=SuffixKt_2450[0]
//         else fAdditionalString:=SuffixKt_2450[1];
end;

procedure TKt_2450.OutPutChange(toOn: boolean);
begin
// :OUTP ON|Off
 OnOffFromBool(toOn);
 SetupOperation(5,55);
 fOutPutOn:=toOn;
end;

procedure TKt_2450.PrepareString;
begin
 (fDevice as TKt_2450Device).ClearStringToSend;
 (fDevice as TKt_2450Device).SetStringToSend(RootNoodKt_2450[fRootNode]);
 case fRootNode of
  5:begin
////     JoinToStringToSend(FirstNodeKt_2450_5[fFirstLevelNode]);
    case fFirstLevelNode of
     5: fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
     0..1:begin
//     SetupOperation(5,1-ord(Source),8);
           fDevice.JoinToStringToSend(RootNoodKt_2450[12+fFirstLevelNode]);
           fDevice.JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
          end;
    end;
    end;
  6:begin
//        SetupOperation(6,0);
//        SetupOperation(6,1);
//        SetupOperation(6,2);
     fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
    end;
   7:begin
//        SetupOperation(7,4);
      fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
     end;
   9:begin
//      SetupOperation(9,6);
      fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);

     end;

   11:begin
      case fFirstLevelNode of
       12..13:begin
//    SetupOperation(11,13,10)замість SetupOperation(11,1,0);
//    SetupOperation(11,12,12)замість SetupOperation(11,0,2);
//    SetupOperation(11,13,13);
//    SetupOperation(11,12|13,17);
//    SetupOperation(11,13,16);
//    SetupOperation(11,1-ord(Source)+12,21|22);
           fDevice.JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
           fDevice.JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
           if fIsTripped then fDevice.JoinToStringToSend(FirstNodeKt_2450[11]);
          end;
//        SetupOperation(11,55,14);
       55:fDevice.JoinToStringToSend(RootNoodKt_2450[15]);
//    SetupOperation(11,23,1-ord(Source)+12);
//    SetupOperation(11,23,24);
       23:begin
           case fLeafNode of
             79,80:begin
//                  SetupOperation(11,23,55+24+1-ord(Source));//79,80
                   fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
                   fDevice.JoinToStringToSend(RootNoodKt_2450[fLeafNode-79+12]);
                   fDevice.JoinToStringToSend(FirstNodeKt_2450[24]);
                   end;
             else
                 begin
                 fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
                 fDevice.JoinToStringToSend(RootNoodKt_2450[fLeafNode]);
                 end;
           end;
          end;
        25:begin
            fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//            SetupOperation(11,25,1,False);
            case fLeafNode of
              1:fDevice.JoinToStringToSend(SweepParameters[fSourceType].Lin);
              2:fDevice.JoinToStringToSend(SweepParameters[fSourceType].LinStep);
              3:fDevice.JoinToStringToSend(SweepParameters[fSourceType].List);
              4:fDevice.JoinToStringToSend(SweepParameters[fSourceType].Log);
            end;
           end;
//       fDevice.JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
      end;
      end;
     12..14:
       begin
//          SetupOperation(12+ord(MeasureType),7);
//          SetupOperation(ord(Measure)+12,14);
//        SetupOperation(12|13,16|15);
//        SetupOperation(12|13|14,20);
            fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//             SetupOperation(12|13,15|16,18|19);
         case fLeafNode of
          18,19:fDevice.JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
         end;
       end;

     end;

 if fIsSuffix then JoinAddString;

end;

procedure TKt_2450.ProcessingString(Str: string);
begin
 Str:=Trim(Str);
 case fRootNode of
  0:if pos(Kt_2450_Test,Str)<>0 then fDevice.Value:=314;
  5:begin
    case fFirstLevelNode of
     5,55:fDevice.Value:=StrToInt(Str);
     0..1:begin
//     QuireOperation(5,1-ord(Source),8);
        if StringToOutPutState(AnsiLowerCase(Str))
            then fDevice.Value:=ord(fOutputOffState[TKt2450_Source(fFirstLevelNode)]);
          end;
    end;
    end;
  9:begin
//     QuireOperation(9,6);
     if StringToTerminals(AnsiLowerCase(Str))
          then fDevice.Value:=ord(fTerminal);
    end;

  11:begin
//      QuireOperation(11,13,10);

// QuireOperation(11,12,12);

// QuireOperation(11,23,1-ord(Source)+12);
      case fFirstLevelNode of
        23:begin
           StringToArray(Str);
           if fDataVector.Count>0 then fDevice.Value:=1;
           end;
        else
           begin
           case fLeafNode of
            10:if StringToVoltageProtection(AnsiLowerCase(Str),fVoltageProtection)
                then fDevice.Value:=ord(fVoltageProtection);
        //      QuireOperation(11,13,15);
        // QuireOperation(11,1-ord(Source)+12,21);
            12..13,15,21:fDevice.Value:=SCPI_StringToValue(Str);
        //      2..3:fDevice.Value:=SCPI_StringToValue(Str);
        //          QuireOperation(11,55,55);
            55:if StringToSourceType(AnsiLowerCase(Str)) then fDevice.Value:=ord(fSourceType);
        // QuireOperation(11,1-ord(Source),17);
        //QuireOperation(11,13,16);
        //QuireOperation(11,12|13,22);
            16,17,22:fDevice.Value:=StrToInt(Str);
        //      QuireOperation(11,13,15);
        //      15:;
           end;
           end;
      end;
     end;
   12..14:begin
            case fFirstLevelNode of
//          QuireOperation(12+ord(MeasureType),7);
//          QuireOperation(12|13,9);
//          QuireOperation(12|13,16);
//          QuireOperation(ord(12|13|14,20);
             7,9,16,20: fDevice.Value:=StrToInt(Str);
 //          QuireOperation(12|13,14);
             14: if StringToMeasureUnit(AnsiLowerCase(Str))
                    then fDevice.Value:=ord(fMeasureUnits[TKt2450_Measure(fFirstLevelNode-12)]);
//    QuireOperation(12|13,15);
//  QuireOperation(12|13,15,18);
             15:fDevice.Value:=SCPI_StringToValue(Str);
            end;

         end;
   15:if StringToMeasureFunction(AnsiLowerCase(Str)) then fDevice.Value:=ord(fMeasureFunction);
 end;

end;

procedure TKt_2450.SaveSetup(SlotNumber: TKt2450_SetupMemorySlot);
begin
// *SAV <n>
 fAdditionalString:=inttostr(SlotNumber);
 SetupOperation(3);
end;

procedure TKt_2450.SetAzeroState(Measure: TKt2450_Measure; toOn: boolean);
begin
//CURR|VOLT|RES:AZER OFF ON|OFF
 OnOffFromBool(toOn);
 SetupOperation(ord(Measure)+12,20);
 fAzeroState[Measure]:=toOn;
end;

procedure TKt_2450.SetAzeroState(toOn: boolean);
begin
  SetAzeroState(fMeasureFunction,toOn);
end;

procedure TKt_2450.SetCurrentLimit(Value: double);
begin
// :SOUR:VOLT:ILIM <value>
if Value=0 then
     begin
      fAdditionalString:=SuffixKt_2450[3];
      fCurrentLimit:=Kt_2450_CurrentLimDef;
     end
           else
     begin
      fAdditionalString:=NumberToStrLimited(Value,Kt_2450_CurrentLimLimits);
      fCurrentLimit:=strtofloat(fAdditionalString);
     end;
 SetupOperation(11,13,13);
end;

procedure TKt_2450.SetInterlockStatus(toOn: boolean);
begin
// :OUTP:INT:STAT on|off
 OnOffFromBool(toOn);
 SetupOperation(5,5);
end;

procedure TKt_2450.SetMeasureCurrentLowRange(Range: TKt2450CurrentRange);
begin
//:CURR:RANG:LLIM  <value>
 fAdditionalString:=CurrentRangeToString(Range);;
 SetupOperation(12,15,18);
 fMeasureCurrentLowRange:=Range;
end;

procedure TKt_2450.SetMeasureCurrentRange(Range: TKt2450CurrentRange);
begin
//:CURR:RANG  <value>
//:CURR:RANG:AUTO ON
 if Range=kt_crAuto then
       begin
        OnOffFromBool(True);
        SetupOperation(12,16);
       end         else
       begin
         fAdditionalString:=CurrentRangeToString(Range);;
         SetupOperation(12,15);
       end;
 fMeasureCurrentRange:=Range;
end;

procedure TKt_2450.SetMeasureFunction(MeasureFunction: TKt2450_Measure);
begin
// :FUNC "VOLT"|"CURR"
 case MeasureFunction of
  kt_mCurrent:fAdditionalString:=StringToInvertedCommas(DeleteSubstring(RootNoodKt_2450[12]));
  kt_mVoltage:fAdditionalString:=StringToInvertedCommas(DeleteSubstring(RootNoodKt_2450[13]));
  kt_mResistance:Exit;
 end;

 SetupOperation(15);
 fMeasureFunction:=MeasureFunction;
end;

procedure TKt_2450.SetMeasureHighRange(Value: double);
begin
//:VOLT|CURR|RES:RANG:AUTO:ULIM <value>
 fAdditionalString:=NumberToStrLimited(Value, Kt_2450_RangesLimits[fMeasureFunction]);
 SetupOperation(ord(fMeasureFunction)+12,16,19);
end;

procedure TKt_2450.SetMeasureUnit(Measure: TKt2450_Measure;
     MeasureUnit: TKt_2450_MeasureUnit);
begin
// :VOLT|CURR:UNIT VOLT|AMP|OHM|WATT
  if Measure>kt_mVoltage then Exit;
  if (Measure=kt_mVoltage)and(MeasureUnit=kt_mu_amp)
                  then Exit;
  if (Measure=kt_mCurrent)and(MeasureUnit=kt_mu_volt)
                 then Exit;
  fAdditionalString:=SuffixKt_2450[ord(MeasureUnit)+4];
 SetupOperation(ord(Measure)+12,14);
 fMeasureUnits[Measure]:=MeasureUnit;
end;

procedure TKt_2450.SetMeasureVoltageLowRange(Range: TKt2450VoltageRange);
begin
//:VOLT:RANG:AUTO:LLIM  <value>

 fAdditionalString:=VoltageRangeToString(Range);
 SetupOperation(13,15,18);
 fMeasureVoltageLowRange:=Range;
end;

procedure TKt_2450.SetMeasureVoltageRange(Range: TKt2450VoltageRange);
begin
//VOLT:RANG  <value>
//VOLT:RANG:AUTO ON
 if Range=kt_vrAuto then
       begin
        OnOffFromBool(True);
        SetupOperation(13,16);
       end         else
       begin
         fAdditionalString:=VoltageRangeToString(Range);
         SetupOperation(13,15);
       end;
 fMeasureVoltageRange:=Range;
end;

procedure TKt_2450.SetMode(Mode: TKt_2450_Mode);
begin
 if Mode in [kt_md_sVmC,kt_md_sVmR,kt_md_sVmP,kt_md_sImC]
     then SetMeasureFunction()
     else SetMeasureFunction(kt_mVoltage);
 case Mode of
  kt_md_sVmC:SetMeasureUnit(kt_mCurrent,kt_mu_amp);
  kt_md_sVmV:SetMeasureUnit(kt_mVoltage,kt_mu_volt);
  kt_md_sVmR:SetMeasureUnit(kt_mCurrent,kt_mu_ohm);
  kt_md_sVmP:SetMeasureUnit(kt_mCurrent,kt_mu_watt);
  kt_md_sImC:SetMeasureUnit(kt_mCurrent,kt_mu_amp);
  kt_md_sImV:SetMeasureUnit(kt_mVoltage,kt_mu_volt);
  kt_md_sImR:SetMeasureUnit(kt_mVoltage,kt_mu_ohm);
  kt_md_sImP:SetMeasureUnit(kt_mVoltage,kt_mu_watt);
 end;
 if Mode in [kt_md_sVmC..kt_md_sVmP]
     then SetSourceType(kt_sVolt)
     else SetSourceType(kt_sCurr);
  fMode:=Mode;
end;

procedure TKt_2450.SetOutputOffState(Source:TKt2450_Source;
                           OutputOffState:TKt_2450_OutputOffState);
begin
//:OUTP:CURR|VOLT:SMOD  NORM|HIMP|ZERO|GUARd
 fAdditionalString:=Kt_2450_OutputOffStateName[OutputOffState];
 SetupOperation(5,1-ord(Source),8);
 fOutputOffState[Source]:=OutputOffState;
end;

procedure TKt_2450.SetReadBackState(Source: TKt2450_Source; toOn: boolean);
begin
//SOUR:VOLT|CURR:READ:BACK ON|OFF
 OnOffFromBool(toOn);
 SetupOperation(11,1-ord(Source)+12,17);
 fReadBack[Source]:=toOn;
end;

procedure TKt_2450.SetReadBackState(toOn: boolean);
begin
  SetReadBackState(fSourceType,toOn);
end;

procedure TKt_2450.SetResistanceCompencate(toOn: boolean);
begin
// RES:OCOM ON|OFF
 OnOffFromBool(toOn);
 case fMeasureFunction of
   kt_mCurrent: SetupOperation(12,9);
   kt_mVoltage: SetupOperation(13,9);
 end;
 fResistanceCompencateOn[fMeasureFunction]:=toOn;
end;

procedure TKt_2450.SetSense(MeasureType: TKt2450_Measure; Sense: TKt2450_Sense);
begin
// :CURR|VOLT|RES:RSEN ON(1)|OFF(0)
 fAdditionalString:=SuffixKt_2450[ord(Sense)];
 SetupOperation(12+ord(MeasureType),7);
 fSences[MeasureType]:=Sense;
end;

procedure TKt_2450.SetSourceCurrentRange(Range: TKt2450CurrentRange);
begin
//:SOUR:CURR:RANG  <value>
//:SOUR:CURR:RANG:AUTO ON
 if Range=kt_crAuto then
       begin
        OnOffFromBool(True);
        SetupOperation(11,12,16);
       end         else
       begin
         fAdditionalString:=CurrentRangeToString(Range);
         SetupOperation(11,12,15);
       end;
 fSourceCurrentRange:=Range;
end;

procedure TKt_2450.SetSourceDelay(Source: TKt2450_Source; value: double);
begin
//SOUR:VOLT|CURR:DEL <value>
 fAdditionalString:=NumberToStrLimited(Value,Kt_2450_SourceDelayLimits);
 SetupOperation(11,1-ord(Source)+12,21);
 fSourceDelay[Source]:=strtofloat(fAdditionalString);
end;

procedure TKt_2450.SetSourceDelay(value: double);
begin
 SetSourceDelay(fSourceType,value);
end;

procedure TKt_2450.SetSourceDelayAuto(Source: TKt2450_Source; toOn: boolean);
begin
//SOUR:VOLT|CURR:DEL:AUTO ON|OFF
 OnOffFromBool(toOn);
 SetupOperation(11,1-ord(Source)+12,22);
 fSourceDelayAuto[Source]:=toOn;
end;

procedure TKt_2450.SetSourceDelayAuto(toOn: boolean);
begin
  SetSourceDelayAuto(fSourceType,toOn);
end;

procedure TKt_2450.SetSourceType(SourseType: TKt2450_Source);
begin
// SOUR:FUNC CURR|VOLT
 fAdditionalString:=Kt2450_SourceName[SourseType];
 SetupOperation(11,55);
 fSourceType:=SourseType;
end;

procedure TKt_2450.SetSourceVoltageRange(Range: TKt2450VoltageRange);
begin
//:SOUR:VOLT:RANG  <value>
//:SOUR:VOLT:RANG:AUTO ON
if Range=kt_vrAuto then
       begin
        OnOffFromBool(True);
        SetupOperation(11,13,16);
       end         else
       begin
         fAdditionalString:=VoltageRangeToString(Range);
//         fAdditionalString:=floattostr(2e-2*Power(10,ord(Range)-1));
         SetupOperation(11,13,15);
       end;
fSourceVoltageRange:=Range;
end;

procedure TKt_2450.SetTerminal(Terminal: TKt2450_OutputTerminals);
begin
// :ROUT:TERM  FRON|REAR
 fAdditionalString:=Kt2450_TerminalsName[Terminal];
 SetupOperation(9,6);
 fTerminal:=Terminal;
end;

procedure TKt_2450.UnloadSetupPowerOn;
begin
//SYST:POS RST
  fAdditionalString:=DeleteSubstring(RootNoodKt_2450[2],'*');
  SetupOperation(7,4);
end;


function TKt_2450.ValueToCurrentRange(Value: double): TKt2450CurrentRange;
begin
// showmessage(floattostr(Value));
 Result:=TKt2450CurrentRange(round(Log10(Value/1e-8))+1);
end;

function TKt_2450.ValueToVoltageRange(Value: double): TKt2450VoltageRange;
begin
 Result:=TKt2450VoltageRange(round(Log10(Value/2e-2))+1);
end;

function TKt_2450.VoltageRangeToString(Range: TKt2450VoltageRange): string;
begin
  Result:=floattostr(2e-2*Power(10,ord(Range)-1));
end;

procedure TKt_2450.SetVoltageLimit(Value: double);
begin
// :SOUR:CURR:VLIM <value>
 if Value=0 then
     begin
      fAdditionalString:=SuffixKt_2450[3];
      fVoltageLimit:=Kt_2450_VoltageLimDef;
     end
           else
     begin
      fAdditionalString:=NumberToStrLimited(Value,Kt_2450_VoltageLimLimits);
      fVoltageLimit:=strtofloat(fAdditionalString);
     end;
 SetupOperation(11,12,12);
end;

procedure TKt_2450.SetVoltageProtection(Level: TKt_2450_VoltageProtection);
begin
// :SOUR:VOLT:PROT <n>
 if Level in [kt_vp2..kt_vp180] then
   fAdditionalString:=DeleteSubstring(FirstNodeKt_2450[10])
//   SuffixKt_2450[3]
                     +Copy(Kt_2450_VoltageProtectionLabel[Level],1,
                           Length(Kt_2450_VoltageProtectionLabel[Level])-1)
                                else
   fAdditionalString:=Kt_2450_VoltageProtectionLabel[Level];
 fVoltageProtection:=Level;
 SetupOperation(11,13,10);
end;

procedure TKt_2450.SourceListAppend(Source: TKt2450_Source;
  ListValues: TArrSingle);
begin
//   :SOUR:LIST:CURR|VOLT:APP <list>
 fAdditionalString:=NumbersArrayToStrLimited(ListValues,
                         Kt_2450_SourceSweepLimits[Source]);
 SetupOperation(11,23,55+24+1-ord(Source));//79,80
end;

procedure TKt_2450.SourceListAppend(ListValues: TArrSingle);
begin
 SourceListAppend(fSourceType,ListValues);
end;

procedure TKt_2450.SourceListCreate(ListValues: TArrSingle);
begin
 SourceListCreate(fSourceType,ListValues);
end;

procedure TKt_2450.SourceListCreate(Source: TKt2450_Source;
  ListValues: TArrSingle);
begin
//   :SOUR:LIST:CURR|VOLT <list>
 fAdditionalString:=NumbersArrayToStrLimited(ListValues,
                         Kt_2450_SourceSweepLimits[Source]);
 SetupOperation(11,23,1-ord(Source)+12);
end;

procedure TKt_2450.StringToArray(Str: string);
 var tempArray:TArrSingle;
begin
 fDataVector.Clear;
 StrToNumberArray(tempArray,Str);
 fDataVector.CopyFromXYArrays(tempArray,tempArray);
 fDataVector.DeleteErResult;
end;

function TKt_2450.StringToMeasureFunction(Str: string): boolean;
  var i:TKt2450_Measure;
begin
 Result:=False;
 for I := Low(TKt2450_Measure) to kt_mResistance do
   if pos(DeleteSubstring(RootNoodKt_2450[ord(i)+12]),Str)<>0 then
     begin
       fMeasureFunction:=i;
       Result:=True;
       Break;
     end;
end;

function TKt_2450.StringToMeasureUnit(Str: string): boolean;
  var i:TKt_2450_MeasureUnit;
begin
 Result:=False;
 for I := Low(TKt_2450_MeasureUnit) to High(TKt_2450_MeasureUnit) do
  begin
//   showmessage('StringToMeasureUnit '+Str+' '+SuffixKt_2450[ord(i)+4]);
//   showmessage(inttostr(fFirstLevelNode));
   if Str=SuffixKt_2450[ord(i)+4] then
     begin
       fMeasureUnits[TKt2450_Measure(fRootNode-12)]:=i;
       Result:=True;
       Break;
     end;
  end;
end;

function TKt_2450.StringToOutPutState(Str: string): boolean;
  var i:TKt_2450_OutputOffState;
begin
 Result:=False;
 for I := Low(TKt_2450_OutputOffState) to High(TKt_2450_OutputOffState) do
   begin
//   showmessage('StringToOutPutState  '+Str+' '+Kt_2450_OutputOffStateName[i]);
//   showmessage('source '+inttostr(1-fFirstLevelNode));
   if Str=Kt_2450_OutputOffStateName[i] then
     begin
       fOutputOffState[TKt2450_Source(1-fFirstLevelNode)]:=i;
       Result:=True;
//       showmessage('source type'+inttostr(ord(i)));
       Break;
     end;
   end;
// showmessage('curr '+inttostr(ord(fOutputOffState[kt_sCurr])));
end;

function TKt_2450.StringToSourceType(Str: string): boolean;
  var i:TKt2450_Source;
begin
 Result:=False;
 for I := Low(TKt2450_Source) to (High(TKt2450_Source)) do
   if Str=Kt2450_SourceName[i] then
     begin
       fSourceType:=i;
       Result:=True;
       Break;
     end;
end;

function TKt_2450.StringToTerminals(Str: string): boolean;
  var i:TKt2450_OutputTerminals;
begin
 Result:=False;
 for I := Low(TKt2450_OutputTerminals) to High(TKt2450_OutputTerminals) do
   if Str=Kt2450_TerminalsName[i] then
     begin
       fTerminal:=i;
       Result:=True;
       Break;
     end;
end;

function TKt_2450.StringToVoltageProtection(Str: string;
    var vp: TKt_2450_VoltageProtection): boolean;
  var i:TKt_2450_VoltageProtection;
begin
 Result:=False;
 Str:=DeleteSubstring(Str,DeleteSubstring(FirstNodeKt_2450[10]));
 if pos(Str,Kt_2450_VoltageProtectionLabel[kt_vpnone])=0 then
     Str:=Str+'V';
 for I := Low(TKt_2450_VoltageProtection) to (High(TKt_2450_VoltageProtection)) do
   if Str=Kt_2450_VoltageProtectionLabel[i] then
     begin
       vp:=i;
       Result:=True;
       Break;
     end;
end;

procedure TKt_2450.SwepLinearPointCreate;
begin
 SetupOperation(11,25,1,False);
end;

procedure TKt_2450.SwepLinearStepCreate;
begin
  SetupOperation(11,25,2,False);
end;

procedure TKt_2450.SwepListCreate(StartIndex: word);
begin
  SweepParameters[fSourceType].StartIndex:=StartIndex;
  SetupOperation(11,25,3,False);
end;

procedure TKt_2450.SwepLogStepCreate;
begin
  SetupOperation(11,25,4,False);
end;

function TKt_2450.Test: boolean;
begin
// *IDN?
 QuireOperation(0,0,0,False);
 Result:=(fDevice.Value=314);
end;

procedure TKt_2450.TextToUserScreen(top_text, bottom_text: string);
begin
//DISP:SCR SWIPE_USER
//DISP:USER1:TEXT "top_text"
//DISP:USER2:TEXT "Tbottom_text"
 fAdditionalString:='SWIPE_USER';
 SetupOperation(6,0);
 if top_text<>'' then
   begin
     if Length(top_text)>20 then SetLength(top_text,20);
     fAdditionalString:=StringToInvertedCommas(top_text);
     SetupOperation(6,1);
   end;
 if bottom_text<>'' then
   begin
     if Length(bottom_text)>32 then SetLength(bottom_text,32);
     fAdditionalString:=StringToInvertedCommas(bottom_text);
     SetupOperation(6,2);
   end;
end;

{ TKt_2450Device }

constructor TKt_2450Device.Create(SCPInew:TSCPInew;Telnet: TIdTelnet;
  IPAdressShow: TIPAdressShow; Nm: string);
begin
 inherited Create(Telnet,IPAdressShow,Nm);
 fSCPI:=SCPInew;
 fMinDelayTime:=0;
 fDelayTimeStep:=10;
 fDelayTimeMax:=200;
end;

procedure TKt_2450Device.UpDate;
begin
 fSCPI.ProcessingString(fDataSubject.ReceivedString);
 fIsReceived:=True;
 if TestShowEthernet then showmessage('recived:  '+fDataSubject.ReceivedString);
end;

{ TKt_2450_SweepParameters }

class function TKt_2450_SweepParameters.BoolToOnOffString(
  bool: boolean): string;
begin
  if bool then Result:=SuffixKt_2450[0]
          else Result:=SuffixKt_2450[1];
end;

constructor TKt_2450_SweepParameters.Create(Source:TKt2450_Source);
begin
 fSource:=Source;
 fStart:=0;
 fStop:=0.1;
 fPoints:=2;
 fStep:=0.05;
 fDelay:=0;
 fCount:=1;
 fRangeType:=kt_srt_Best;
 fDual:=False;
 fFailAbort:=True;
end;

function TKt_2450_SweepParameters.GetLin: string;
begin
 Result:=RootNoodKt_2450[1-ord(fSource)+12]+':lin '
         +ParameterString();
end;

function TKt_2450_SweepParameters.GetLinStep: string;
begin
 Result:=RootNoodKt_2450[1-ord(fSource)+12]+':lin:step '
         +ParameterString(True);
end;

function TKt_2450_SweepParameters.GetList: string;
begin
//LIST <startIndex>, <delay>, <count>, <failAbort>
 Result:=RootNoodKt_2450[1-ord(fSource)+12]+FirstNodeKt_2450[23]+' '
         +Inttostr(fStartIndex)+PartDelimiter
         +FloatToStrF(fDelay,ffExponent,4,0)+PartDelimiter
         +IntToStr(fCount)+PartDelimiter
         +BoolToOnOffString(fFailAbort);
end;

function TKt_2450_SweepParameters.GetLog: string;
begin
 Result:=RootNoodKt_2450[1-ord(fSource)+12]+':log '
         +ParameterString();
end;


function TKt_2450_SweepParameters.ParameterString(
  itIsStepType: boolean): string;
begin
//<start>, <stop>, <points>, <delay>, <count>,
//<rangeType>, <failAbort>, <dual>
 Result:=FloatToStrF(fStart,ffExponent,4,0)+PartDelimiter
         +FloatToStrF(fStop,ffExponent,4,0)+PartDelimiter;
 if itIsStepType
   then Result:=Result+FloatToStrF(fStep,ffExponent,4,0)+PartDelimiter
   else Result:=Result+IntToStr(fPoints)+PartDelimiter;
 Result:=Result+FloatToStrF(fDelay,ffExponent,4,0)+PartDelimiter
         +IntToStr(fCount)+PartDelimiter
         +KT2450_SweepRangeNames[fRangeType]+PartDelimiter
         +BoolToOnOffString(fFailAbort)+PartDelimiter
         +BoolToOnOffString(fDual);
end;

procedure TKt_2450_SweepParameters.SetCount(Value: integer);
begin
 fCount:=TSCPInew.NumberMap(Value,Kt_2450_SweepCountLimits);
end;

procedure TKt_2450_SweepParameters.SetDelay(Value: double);
begin
 if (Value=-1)or(Value=0)
    then fDelay:=Value
    else fDelay:=TSCPInew.NumberMap(Value,Kt_2450_SweepDelayLimits);
end;

procedure TKt_2450_SweepParameters.SetPoints(Value: integer);
begin
 fPoints:=TSCPInew.NumberMap(Value,Kt_2450_SweepPointsLimits);
end;

procedure TKt_2450_SweepParameters.SetStart(Value: double);
begin
 fStart:=TSCPInew.NumberMap(Value,Kt_2450_SourceSweepLimits[fSource]);
end;

procedure TKt_2450_SweepParameters.SetStartIndex(Value: Word);
begin
 fStartIndex:=max(1,Value);
end;

procedure TKt_2450_SweepParameters.SetStep(Value: double);
begin
 if Value=0 then Exit;
 fStep:=abs(Value);
end;

procedure TKt_2450_SweepParameters.SetStop(Value: double);
begin
 fStop:=TSCPInew.NumberMap(Value,Kt_2450_SourceSweepLimits[fSource]);
end;

end.
