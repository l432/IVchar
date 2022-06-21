unit Keithley2450;

interface

uses
  TelnetDevice, IdTelnet, ShowTypes, Keitley2450Const, SCPI, OlegType, 
  OlegVector, OlegTypePart2, Keitley2450Device, ExtCtrls, Measurement;


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

TKT2450_Meter=class;
TKT2450_SourceMeter=class;
TKT2450_SourceDevice=class;

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
   fHighCapacitance:TKt2450_SourceBool;
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
//   fSourceDelay2:TKt2450_SourceDouble;
   {це поле для шаманства...}
   fSourceValue:TKt2450_SourceDouble;
   fSourceDelayAuto:TKt2450_SourceBool;
   fMeasureTime:TKt2450_MeasureDouble;
   fDisplayDN:TKt2450_MeasureDisplayDN;
   fDataVector:TVector;
   {X - значення джерела; Y - результат виміру}
   fDataTimeVector:TVector;
   {X - час виміру (мілісекунди з початку доби); Y - результат виміру}
   fBuffer:TKt2450_Buffer;
   fCount:integer;
   fSourceMeasuredValue:double;
   fTimeValue:double;
   {час виміру, в мілісекундах з початку доби}
   fDigitLineType:TKt2450_DigLineTypes;
   fDigitLineDirec:TKt2450_DigLineDirections;
   fDLActive:TKt2450_DigLines;
   fMeter:TKT2450_Meter;
   fSourceMeter:TKT2450_SourceMeter;
   fSourceDevice:TKT2450_SourceDevice;
   fDisplayState:TKt2450_DisplayState;
   fHookForTrigDataObtain: TSimpleEvent;
   fTrigBlockNumber:word;
   fDragonBackTime:double;
   fToUseDragonBackTime:boolean;
   fImax:double;
   fImin:double;
   FCurrentValueLimitEnable:boolean;
   fSweepWasCreated:boolean;
   procedure OnOffFromBool(toOn:boolean);
   function StringToVoltageProtection(Str:string;var vp:TKt_2450_VoltageProtection):boolean;
   function StringToSourceType(Str:string):boolean;
   function StringToMeasureFunction(Str:string):boolean;
   function StringToTerminals(Str:string):boolean;
   function StringToOutPutState(Str:string):boolean;
   function StringToMeasureUnit(Str:string):boolean;
   function StringToBufferIndexies(Str:string):boolean;
   function StringToDisplayBrightness(Str:string):boolean;
   procedure StringToDigLineStatus(Str:string);
   procedure StringToArray(Str:string);
   procedure StringToMesuredData(Str:string;DataType:TKt2450_ReturnedData);
   procedure StringToMesuredDataArray(Str:string;DataType:TKt2450_ReturnedData);
   function StringToMeasureTime(Str:string):double;
   function IsLimitExcided(FirstLevelNode,LeafNode:byte):boolean;
   {типова функція для запиту, чи ввімкнув прилад певні захисти}
   function ModeDetermination:TKt_2450_Mode;
   function ValueToVoltageRange(Value:double):TKt2450VoltageRange;
   function VoltageRangeToString(Range:TKt2450VoltageRange):string;
   function ValueToCurrentRange(Value:double):TKt2450CurrentRange;
   function CurrentRangeToString(Range:TKt2450CurrentRange):string;
   procedure SetCountNumber(Value:integer);
   procedure TrigIVLoop(i: Integer);
  protected
   procedure PrepareString;override;
   procedure DeviceCreate(Nm:string);override;
   procedure DefaultSettings;override;
  public
   SweepParameters:array[TKt2450_Source]of TKt_2450_SweepParameters;
//   IVDependence:TFastIVDependence;
   property HookForTrigDataObtain:TSimpleEvent read fHookForTrigDataObtain write fHookForTrigDataObtain;
   property DataVector:TVector read fDataVector;
   property DataTimeVector:TVector read fDataTimeVector;
   property SourceType:TKt2450_Source read fSourceType;
   property MeasureFunction:TKt2450_Measure read fMeasureFunction;
   property VoltageProtection:TKt_2450_VoltageProtection read fVoltageProtection;
   property VoltageLimit:double read fVoltageLimit;
   property CurrentLimit:double read fCurrentLimit;
   property Terminal:TKt2450_OutputTerminals read fTerminal;
   property OutPutOn:boolean read fOutPutOn write fOutPutOn;
   property ResistanceCompencateOn:TKt2450_MeasureBool read fResistanceCompencateOn;
   property ReadBack:TKt2450_SourceBool read fReadBack;
   property HighCapacitance:TKt2450_SourceBool read fHighCapacitance;
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
   property SourceValue:TKt2450_SourceDouble read fSourceValue;
   property SourceDelayAuto:TKt2450_SourceBool read fSourceDelayAuto;
   property DisplayDN:TKt2450_MeasureDisplayDN read fDisplayDN;
   property MeasureTime:TKt2450_MeasureDouble read fMeasureTime;
   property Buffer:TKt2450_Buffer read fBuffer;
   property Count:integer read fCount write SetCountNumber;
   property SourceMeasuredValue:double read fSourceMeasuredValue;
   property TimeValue:double read fTimeValue;
   property DigitLineType:TKt2450_DigLineTypes read fDigitLineType;
   property DigitLineTypeDirec:TKt2450_DigLineDirections read fDigitLineDirec;
   property Meter:TKT2450_Meter read fMeter;
   property SourceMeter:TKT2450_SourceMeter read fSourceMeter;
   property SourceDevice:TKT2450_SourceDevice read fSourceDevice;
   property DisplayState:TKt2450_DisplayState read fDisplayState;
   property DragonBackTime:double read fDragonBackTime write fDragonBackTime;
   property ToUseDragonBackTime:boolean read fToUseDragonBackTime write fToUseDragonBackTime;
   property Imax:double read fImax write fImax;
   property Imin:double read FImin write FImin;
   property CurrentValueLimitEnable:boolean read FCurrentValueLimitEnable write FCurrentValueLimitEnable;
   property SweepWasCreated:boolean read fSweepWasCreated write fSweepWasCreated;
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
   {перемикання типу виходу джерела,
   коли воно не ввімкнене входу: нормальний, високоімпедансний тощо}
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

   procedure SetHighCapacitanceState(Source:TKt2450_Source;
                              toOn:boolean);overload;
   {встановлюється високоємнісний стан виходу}
   procedure SetHighCapacitanceState(toOn:boolean);overload;
   function IsHighCapacitanceOn(Source:TKt2450_Source):boolean;overload;
   function IsHighCapacitanceOn():boolean;overload;
   function GetHighCapacitanceStates():boolean;


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

   procedure SetMeasureTime(Measure:TKt2450_Measure; Value:double);overload;
   {час на вимірювння []=мс, можливий діапазон - (0,2-200)}
   procedure SetMeasureTime(Value:double);overload;
   function GetMeasureTime(Measure:TKt2450_Measure):boolean;overload;
   function GetMeasureTime():boolean;overload;
   function GetMeasureTimes():boolean;

   procedure SetDisplayDigitsNumber(Measure:TKt2450_Measure; Number:Kt2450DisplayDigitsNumber);overload;
   {кількість цифр, що відображаються на екрані,
     на точність самого вимірювання не впливає}
   procedure SetDisplayDigitsNumber(Number:Kt2450DisplayDigitsNumber);overload;
   function GetDisplayDigitsNumber(Measure:TKt2450_Measure):boolean;overload;
   function GetDisplayDigitsNumber():boolean;overload;
   function GetDisplayDNs():boolean;


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

//   procedure SetMeasureHighRange(Value:double);
   {встановлює максимальний діапазон (прив'язаний до Value)
   для вимірювань при автоматичному  режимі встановленого зараз способу вимірювання;
   не робив детальних як для попереднього, бо не виносив на керування;
   ВИДАЛИВ, бо дочитався в інструкції, що встановлення
   працює лише в режимі ом-метра, для інших - лише читання}


   procedure SetSourceValue(Source:TKt2450_Source;
                            value:double);overload;
   {значення джерела, воно реально з'явиться
   лише після включення OutPut, якщо вже
   включено - з'явиться миттєво}
   procedure SetSourceValue(value:double);overload;
   function GetSourceValue(Source:TKt2450_Source):boolean;overload;
   function GetSourceValue():boolean;overload;
   function GetSourceValues():boolean;

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

   procedure BufferCreate();overload;
   procedure BufferCreate(Name:string);overload;
   procedure BufferCreate(Name:string;Size:integer);overload;
   procedure BufferCreate(Name:string;Size:integer;Style:TKt2450_BufferStyle);overload;
   procedure BufferCreate(Style:TKt2450_BufferStyle);overload;
   procedure BufferDelete();overload;
   procedure BufferDelete(Name:string);overload;
   procedure BufferClear();overload;
   procedure BufferClear(BufName:string);overload;

   procedure BufferReSize(NewSize:integer);overload;
   {змінює можливу кількість записів у буфері,
   при цьому він очищується}
   procedure BufferReSize(BufName:string;NewSize:integer);overload;
   function BufferGetSize():integer;overload;
   function BufferGetSize(BufName:string):integer;overload;
   function BufferGetReadingNumber(BufName:string=Kt2450DefBuffer):integer;
   {повертає існуючу кількість записів у буфері}
   function BufferGetStartEndIndex(BufName:string=Kt2450DefBuffer):boolean;
   {повертає початковий та кінцевий індекси існуючих
   в буфері записів, якщо все добре вони знаходяться
   в Buffer.StartIndex та Buffer.EndIndex}

   procedure BufferSetFillMode(FillMode:TKt2450_BufferFillMode);overload;
   procedure BufferSetFillMode(BufName:string;FillMode:TKt2450_BufferFillMode);overload;
   function BufferGetFillMode():boolean;overload;
   function BufferGetFillMode(BufName:string):boolean;overload;
   Procedure BufferLastDataSimple();overload;
   {без вимірювання видобувається результат останнього
   вимірювання, що зберігається у defbuffer1,
   розміщується в fDevice.Value}
   Procedure BufferLastDataSimple(BufName:string);overload;
   {отримання останнього збереженого результату
   вимірювань з буфера BufName}
   Procedure BufferLastDataExtended(DataType:TKt2450_ReturnedData=kt_rd_MS;
                            BufName:string=Kt2450DefBuffer);
   {як попередні, проте повертає більше даних
   (див. TKt2450_ReturnedData) щодо останнього виміру}
   Procedure BufferDataArrayExtended(SIndex,EIndex:integer;
                     DataType:TKt2450_ReturnedData=kt_rd_MS;
                     BufName:string=Kt2450DefBuffer);
   {зчитування з буферу BufName результатів, збережених за
   індексами в діапазоні від SIndex до EIndex,
   що саме повертається залежить від DataType,
   результати вимірювань в DataVector.Y,
   значення джерела в DataVector.Х,
   якщо берем час вимірювання, то він в  DataTimeVector.X,
   а результат виміру в  DataTimeVector.Y,
   якщо DataType=kt_rd_M, то вимір і в  DataVector.Х}
   {треба оцінити час передачі}

   procedure SetCount(Cnt:integer);
   {кількість повторних вимірювань, коли прилад просять поміряти}
   function GetCount():boolean;

   procedure SetDigLineMode(LineNumber:TKt2450_DigLines;
                            LineType:TKt2450_DigLineType;
                            Direction:TKt2450_DigLineDirection);
   function GetDigLineMode(LineNumber:TKt2450_DigLines):boolean;
   procedure SetDidLinOut(LineNumber:TKt2450_DigLines;HighLevel:boolean=True);
   {якщо лінія LineNumber має kt_dt_dig та kt_dd_out, то
   для неї можна встановили високий чи низький рівні}
   function GetDidLinOut(LineNumber:TKt2450_DigLines):integer;
   {якщо лінія LineNumber має kt_dt_dig та kt_dd_in, то
   для неї можна зчитати значення рівня;
   Resul=1 якщо високий
         0 якщо низький
        -1 якщо не отримали відповідь}

   procedure SetDisplayBrightness(State:TKt2450_DisplayState);
   function GetDisplayBrightness():boolean;

   procedure Beep(Freq:word=600;Duration:double=0.1);
   {звук частотою Freq Гц протягом Duration секунд}

   procedure ConfigMeasureCreate(ListName:string=MyMeasList);
   procedure ConfigSourceCreate(ListName:string=MySourceList);
   procedure ConfigMeasureDelete(ListName:string=MyMeasList;ItemIndex:word=0);
   {якщо ItemIndex=0, то видаляється весь список}
   procedure ConfigSourceDelete(ListName:string=MySourceList;ItemIndex:word=0);
   procedure ConfigMeasureRecall(ListName:string=MyMeasList;ItemIndex:word=1);
   {завантаження налаштувань, записаних в ItemIndex;
   якщо потрібно викликати налаштування і для джерела,
   і для вимірювача - спочатку завантажувати треба для джерела}
   procedure ConfigSourceRecall(ListName:string=MySourceList;ItemIndex:word=1);
   procedure ConfigBothRecall(SourceListName:string=MySourceList;
                              MeasListName:string=MyMeasList;
                              SourceItemIndex:word=1;
                              MeasItemIndex:word=1);
   procedure ConfigMeasureStore(ListName:string=MyMeasList;ItemIndex:word=0);
   {запис налаштувань у список;
   якщо ItemIndex=0, то записується у кінець списку}
   procedure ConfigSourceStore(ListName:string=MySourceList;ItemIndex:word=0);

   Procedure GetParametersFromDevice;

   Procedure MeasureSimple();overload;
   {проводиться вимірювання стільки разів, скільки
   вказано в Count, всі результати розміщуються
   в defbuffer1, повертається результат останнього виміру;
   вимірюється та функція, яка зараз встановлена на приладі,
   можна зробити, щоб вимірювалося щось інше, але я не
   схотів гратися з такою не дуже реальною на перший погляд
   задачею}
   Procedure MeasureSimple(BufName:string);overload;
   {результати записуються у буфер BufName
   і з нього ж зчитується останній результат}
   Procedure MeasureExtended(DataType:TKt2450_ReturnedData=kt_rd_MS;
                           BufName:string=Kt2450DefBuffer);
   {як попередні, проте повертає більше даних
   (див. TKt2450_ReturnedData) щодо останнього виміру}


   Procedure Init;
   Procedure Abort;
   Procedure Wait;
   Procedure TrigPause;
   Procedure TrigResume;
   Procedure InitWait;
   Procedure TrigEventGenerate;
   {generates a trigger event }

   Procedure TrigForIVCreate;
   Procedure TrigNewCreate;
   {any blocks that have been defined in the trigger model
   are cleared so the trigger model has no blocks defined}
   Procedure TrigBufferClear(BufName:string=Kt2450DefBuffer);
   Procedure TrigConfigListRecall(ListName:string;Index:integer=1);
   Procedure TrigConfigListNext(ListName:string);overload;
   Procedure TrigConfigListNext(ListName1,ListName2:string);overload;
   Procedure TrigOutPutChange(toOn:boolean);
   Procedure TrigAlwaysTransition(TransitionBlockNumber:word);
   Procedure TrigDelay(DelayTime:double);
   Procedure TrigMeasure(BufName:string=Kt2450DefBuffer;Count:word=1);
   {при досягненні цього блоку прилад вимірює Count разів,
   після чого виконується наступний блок;
   Count=0 може використовуватися для зупинки нескінченних вимірювань
   - див. далі;
   результати заносяться в BufName}
   Procedure TrigMeasureInf(BufName:string=Kt2450DefBuffer);
   {при досягненні цього блоку прилад починає
   виміри і виконується наступний блок; виміри продовжуються доти,
   поки не зустрінеться новий вимірювальний блок чи не буде кінець моделі}
   Procedure TrigMeasureCountDevice(BufName:string=Kt2450DefBuffer);
   {при досягненні цього блоку прилад вимірює стільки разів, скільки
   передбачено попередньо встановленою властивістю Count,
   після чого виконується наступний блок}

   Procedure TrigMeasureResultTransition(LimitType:TK2450_TrigLimitType;
                    LimA,LimB:double;TransitionBlockNumber:word;
                    MeasureBlockNumber:word=0);
   {якщо вимірювання задовольняє умові, яка передбачена в LimitType,
   то відбувається перехід на блок TransitionBlockNumber;
   при MeasureBlockNumber=0 береться до уваги останнє
   вимірювання, інакше те, яке відбулося в блоці з номером MeasureBlockNumber;
   якщо задати LimA>LimB, то прилад автоматично їх поміняє місцями
   умова виконується, якщо результат (MeasureResult)
   при kt_tlt_above: MeasureResult > LimB
   kt_tlt_below: MeasureResult < LimA
   kt_tlt_inside: LimA < MeasureResult < LimB  (про <= не знаю, треба експерементувати)
   kt_tlt_outside:  MeasureResult не належить [LimA, LimB]
   }
   Procedure TrigCounterTransition(TargetCount,TransitionBlockNumber:word);
   {якщо кількість приходів на цей блок менша TargetCount, то відбувається
   перехід на блок TransitionBlockNumber}
   Procedure TrigEventTransition(TransitionBlockNumber:word;
                                 EventType:TK2450_TriggerEvents=kt_te_comm;
                                 EventNumber:word=1);
   {якщо до того, як дійшли на цей блок, відбулася подія EventType,
   то відбувається перехід на TransitionBlockNumber}

 end;

TKT2450_Measurement=class(TMeasurementSimple)
 private
  fParentModule: TKt_2450;
  procedure GetDataPreparation;
  function GetValueFromDevice:double;virtual;
 public
  constructor Create(Kt_2450:TKt_2450);
  function GetData:double;override;
end;


//TKT2450_Meter=class(TMeasurementSimple)
TKT2450_Meter=class(TKT2450_Measurement)
 private
  fTimer:TTimer;
  function GetMeasureModeLabel():string;
//  function GetValueFromDevice:double;override;
 public
  property MeasureModeLabel:string read GetMeasureModeLabel;
  property Timer:TTimer read fTimer;
  constructor Create(Kt_2450:TKt_2450);
  destructor Destroy; override;
  function GetValueFromDevice:double;override;
//  function GetData:double;override;
end;

TKT2450_SourceMeter=class(TKT2450_Measurement)
 private
  function GetValueFromDevice:double;override;
 public
  constructor Create(Kt_2450:TKt_2450);
end;

TKT2450_SourceDevice=class(TNamedInterfacedObject,ISource)
 private
  fParentModule: TKt_2450;
  fOutputValue:double;
  function GetOutputValue:double;
  procedure Output(Value:double);
 {встановлює на виході напругу Value}
  Procedure Reset();
 {встановлює на виході 0}
 public
  property OutputValue:double read GetOutputValue;
  constructor Create(Kt_2450:TKt_2450);
end;


var
  Kt_2450:TKt_2450;

implementation

uses
  Dialogs, SysUtils, Math, FormKT2450, OlegFunction, StrUtils;

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

procedure TKt_2450.BufferCreate(Name: string);
begin
 Buffer.SetName(Name);
 BufferCreate;
end;

procedure TKt_2450.BufferCreate;
begin
 fAdditionalString:=Buffer.CreateStr;
 SetupOperation(19,29);
end;

procedure TKt_2450.ClearUserScreen;
begin
// :DISP:CLE
 SetupOperation(6,3,0,false);
end;

procedure TKt_2450.ConfigBothRecall(SourceListName, MeasListName: string;
  SourceItemIndex, MeasItemIndex: word);
begin
//:SOUR:CONF:LIST:REC "<name>", <index>, "<measureListName>", <measureIndex>
 fAdditionalString:=StringToInvertedCommas(SourceListName)+PartDelimiter
                    +IntToStr(max(SourceItemIndex,1))+PartDelimiter
                    +StringToInvertedCommas(MeasListName)+PartDelimiter
                    +IntToStr(max(MeasItemIndex,1));
 SetupOperation(11,24,2);
end;

procedure TKt_2450.ConfigMeasureCreate(ListName: string);
begin
//:CONF:LIST:CRE "<name>"
 fAdditionalString:=StringToInvertedCommas(ListName);
 SetupOperation(24,23,0);
end;

procedure TKt_2450.ConfigMeasureDelete(ListName: string;ItemIndex:word);
begin
//:CONF:LIST:DEL "<name>", <index>
 fAdditionalString:=StringToInvertedCommas(ListName);
 if ItemIndex<>0 then fAdditionalString:=fAdditionalString+PartDelimiter+
                                         IntToStr(ItemIndex);
 SetupOperation(24,23,1);
end;

procedure TKt_2450.ConfigMeasureRecall(ListName: string; ItemIndex: word);
begin
//:CONF:LIST:REC "<name>", <index>
 fAdditionalString:=StringToInvertedCommas(ListName)+PartDelimiter
                    +IntToStr(max(ItemIndex,1));
 SetupOperation(24,23,2);
end;

procedure TKt_2450.ConfigMeasureStore(ListName: string; ItemIndex: word);
begin
//:CONF:LIST:STOR "<name>", <index>
 fAdditionalString:=StringToInvertedCommas(ListName);
 if ItemIndex<>0 then fAdditionalString:=fAdditionalString+PartDelimiter+
                                         IntToStr(ItemIndex);
 SetupOperation(24,23,3);
end;

procedure TKt_2450.ConfigSourceCreate(ListName: string);
begin
//:SOUR:CONF:LIST:CRE "<name>"
 fAdditionalString:=StringToInvertedCommas(ListName);
 SetupOperation(11,24,0);
end;

procedure TKt_2450.ConfigSourceDelete(ListName: string;ItemIndex:word);
begin
//:SOUR:CONF:LIST:DEL "<name>", <index>
 fAdditionalString:=StringToInvertedCommas(ListName);
 if ItemIndex<>0 then fAdditionalString:=fAdditionalString+PartDelimiter+
                                         IntToStr(ItemIndex);
 SetupOperation(11,24,1);
end;

procedure TKt_2450.ConfigSourceRecall(ListName: string; ItemIndex: word);
begin
//:SOUR:CONF:LIST:REC "<name>", <index>
 fAdditionalString:=StringToInvertedCommas(ListName)+PartDelimiter
                    +IntToStr(max(ItemIndex,1));
 SetupOperation(11,24,2);
end;

procedure TKt_2450.ConfigSourceStore(ListName: string; ItemIndex: word);
begin
//:SOUR:CONF:LIST:STOR "<name>", <index>
 fAdditionalString:=StringToInvertedCommas(ListName);
 if ItemIndex<>0 then fAdditionalString:=fAdditionalString+PartDelimiter+
                                         IntToStr(ItemIndex);
 SetupOperation(11,24,3);
end;

constructor TKt_2450.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
 fTelnet:=Telnet;
 fIPAdressShow:=IPAdressShow;
 inherited Create(Nm);
 fBuffer:=TKt2450_Buffer.Create;
 fMeter:=TKT2450_Meter.Create(Self);
 fSourceMeter:=TKT2450_SourceMeter.Create(Self);
 fSourceDevice:=TKT2450_SourceDevice.Create(Self);
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
   fMeasureTime[TKt2450_Measure(i)]:=1;
   fDisplayDN[TKt2450_Measure(i)]:=5;
   end;
 for I := ord(Low(TKt2450_Source)) to ord(High(TKt2450_Source)) do
   begin
   fReadBack[TKt2450_Source(i)]:=True;
   fSourceDelay[TKt2450_Source(i)]:=0;
   fSourceDelayAuto[TKt2450_Source(i)]:=True;
   SweepParameters[TKt2450_Source(i)]:=TKt_2450_SweepParameters.Create(TKt2450_Source(i));
   fSourceValue[TKt2450_Source(i)]:=0;
   fHighCapacitance[TKt2450_Source(i)]:=False;
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
 fCount:=1;

 fDataVector:=TVector.Create;
 fDataTimeVector:=TVector.Create;
 fSourceMeasuredValue:=ErResult;
 fTimeValue:=ErResult;

 for I := Low(TKt2450_DigLines) to High(TKt2450_DigLines) do
   begin
   fDigitLineType[i]:=kt_dt_dig;
   fDigitLineDirec[i]:=kt_dd_in;
   end;
 fDLActive:=1;

 fDisplayState:=kt_ds_on25;
 fTrigBlockNumber:=1;
 fSweepWasCreated:=False;
end;

destructor TKt_2450.Destroy;
 var i:TKt2450_Source;
begin
  FreeAndNil(fSourceDevice);
  FreeAndNil(fSourceMeter);
  FreeAndNil(fMeter);
  FreeAndNil(fBuffer);
  for I := Low(TKt2450_Source) to High(TKt2450_Source) do
   FreeAndNil(SweepParameters[i]);
  FreeAndNil(fDataTimeVector);
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

function TKt_2450.BufferGetSize(BufName: string): integer;
begin
// :TRAC:POIN? "<bufferName>"
 Buffer.SetName(BufName);
 Result:=BufferGetSize();
end;

function TKt_2450.BufferGetStartEndIndex(BufName: string): boolean;
begin
 Buffer.SetName(BufName);
 QuireOperation(19,35,2,False);
 Result:=(fDevice.Value=1);
end;

procedure TKt_2450.BufferLastDataExtended(DataType: TKt2450_ReturnedData;
  BufName: string);
begin
 // :FETC? "<bufferName>", <bufferElements>
 Buffer.SetName(BufName);
 QuireOperation(22,ord(DataType)+2,0,False);
end;

procedure TKt_2450.BufferLastDataSimple;
begin
  QuireOperation(22);
end;

procedure TKt_2450.BufferLastDataSimple(BufName: string);
begin
 Buffer.SetName(BufName);
 QuireOperation(22,1,0,False);
end;

function TKt_2450.BufferGetSize: integer;
begin
//  SetupOperation(19,31);
 QuireOperation(19,31,1,False);
 if fDevice.isReceived then
     begin
       Result:=round(fDevice.Value);
       Buffer.CountMax:=Result
     end       else
       Result:=-1;
end;

function TKt_2450.GetCount: boolean;
begin
 QuireOperation(20);
 Result:=fDevice.isReceived;
 if Result then Count:=round(fDevice.Value);
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

function TKt_2450.GetDisplayDNs: boolean;
begin
 Result:=GetDisplayDigitsNumber(kt_mCurrent) and GetDisplayDigitsNumber(kt_mVoltage);
end;

function TKt_2450.GetDidLinOut(LineNumber: TKt2450_DigLines): integer;
begin
 Result:=-1;
 if (fDigitLineType[LineNumber]<>kt_dt_dig)
    or(fDigitLineDirec[LineNumber]<>kt_dd_in) then Exit;
 fDLActive:=LineNumber;
 QuireOperation(23,37);
 if fDevice.isReceived then Result:=round(fDevice.Value);
end;

function TKt_2450.GetDigLineMode(LineNumber: TKt2450_DigLines): boolean;
begin
 fDLActive:=LineNumber;
 QuireOperation(23,36);
 Result:=(fDevice.Value=2);
end;

function TKt_2450.GetDisplayBrightness: boolean;
begin
 QuireOperation(6,30);
 Result:=(fDevice.Value<>ErResult);
// if Result then fSourceDelay[Source]:=fDevice.Value;
end;

function TKt_2450.GetDisplayDigitsNumber: boolean;
begin
 Result:=GetDisplayDigitsNumber(MeasureFunction);
end;

function TKt_2450.GetDisplayDigitsNumber(Measure: TKt2450_Measure): boolean;
begin
 QuireOperation(6,ord(Measure)+12,28);
 try
  fDisplayDN[Measure]:=round(fDevice.Value);
  result:=True;
 except
  Result:=False;
 end;
end;

function TKt_2450.GetHighCapacitanceStates: boolean;
begin
 Result:=IsHighCapacitanceOn(kt_sCurr) and IsHighCapacitanceOn(kt_sVolt);
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
  QuireOperation(12,16,18);
  fMeasureCurrentLowRange:=ValueToCurrentRange(fDevice.Value);
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

 if fDevice.Value=1 then  fMeasureCurrentRange:=kt_crAuto
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

function TKt_2450.GetMeasureTime(Measure: TKt2450_Measure): boolean;
begin
// SetupOperation(ord(Measure)+12,26);
 QuireOperation(ord(Measure)+12,26);
 Result:=(fDevice.Value<>ErResult);
 if Result then fMeasureTime[Measure]:=fDevice.Value*KT_2450_MeaureTimeConvertConst;
end;

function TKt_2450.GetMeasureTime: boolean;
begin
 Result:=GetMeasureTime(fMeasureFunction);
end;

function TKt_2450.GetMeasureTimes: boolean;
begin
 Result:= GetMeasureTime(kt_mCurrent)
         and GetMeasureTime(kt_mVoltage);
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
  QuireOperation(13,16,18);
  fMeasureVoltageLowRange:=ValueToVoltageRange(fDevice.Value);
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
 if not(GetSourceValues()) then Exit;
 if not(GetMeasureTimes()) then Exit;
 if not(GetHighCapacitanceStates()) then Exit;
 if not(GetDisplayDNs()) then Exit;
 if not(GetCount()) then Exit;
 if not(GetDisplayBrightness()) then Exit;
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

function TKt_2450.GetSourceValue: boolean;
begin
 Result:=GetSourceValue(fSourceType);
end;

function TKt_2450.GetSourceValues: boolean;
begin
 Result:=GetSourceValue(kt_sVolt) and GetSourceValue(kt_sCurr);
end;

function TKt_2450.GetSourceValue(Source: TKt2450_Source): boolean;
begin
 QuireOperation(11,1-ord(Source)+12);
 Result:=(fDevice.Value<>ErResult);
 if Result then fSourceValue[Source]:=fDevice.Value;
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

procedure TKt_2450.InitWait;
begin
// INIT; *WAI
 fAdditionalString:=CommandDelimiter+RootNoodKt_2450[25];
 SetupOperation(17,1,0,False);
end;

function TKt_2450.IsAzeroStateOn: boolean;
begin
 Result:=IsAzeroStateOn(fMeasureFunction);
end;

function TKt_2450.IsCurrentLimitExceeded: boolean;
begin
 Result:=IsLimitExcided(13,13);
end;

function TKt_2450.IsHighCapacitanceOn(Source: TKt2450_Source): boolean;
begin
 QuireOperation(11,1-ord(Source)+12,27);
 Result:=(fDevice.Value=1);
 fHighCapacitance[Source]:=Result;
end;

function TKt_2450.IsHighCapacitanceOn: boolean;
begin
  Result:=IsHighCapacitanceOn(fSourceType);
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

procedure TKt_2450.MeasureSimple;
begin
 QuireOperation(21);
end;

procedure TKt_2450.MeasureExtended(DataType: TKt2450_ReturnedData;
  BufName: string);
begin
// :READ? "<bufferName>", <bufferElements>
 Buffer.SetName(BufName);
 QuireOperation(21,ord(DataType)+2,0,False);
end;

procedure TKt_2450.MeasureSimple(BufName: string);
begin
 Buffer.SetName(BufName);
 QuireOperation(21,1,0,False);
end;

function TKt_2450.ModeDetermination: TKt_2450_Mode;
begin
 Result:=kt_md_sVmC;
 case fSourceType of
   kt_sVolt:Result:=TKt_2450_Mode(ord(fMeasureUnits[fMeasureFunction]));
   kt_sCurr:Result:=TKt_2450_Mode(4+ord(fMeasureUnits[fMeasureFunction]));
 end;
end;

procedure TKt_2450.MyTraining;
// var str:string;
//  var ArrDouble: TArrSingle;
begin
//  (fDevice as TTelnetMeterDeviceSingle).SetStringToSend(':VOLT:RANG:AUTO:LLIM 20');
//  (fDevice as TTelnetMeterDeviceSingle).SetStringToSend(':FORM:ASC:PREC DEF');
//  fDevice.Request();
//  fDevice.GetData;

TrigNewCreate;
//TrigBufferClear;
//TrigConfigListRecall(MyMeasList);
//TrigConfigListRecall(MySourceList);
//TrigConfigListNext(MySourceList);
//TrigOutPutChange(True);
//TrigOutPutChange(False);
//TrigAlwaysTransition(7);
//TrigDelay(5e-2);
//TrigMeasure;
//TrigMeasureResultTransition(kt_tlt_outside,-2e-3,0.01,8);
//TrigCounterTransition(3,4);

//Init;
//InitWait;
//Wait();

//-------------------------------------------
// ConfigMeasureDelete;
// ConfigSourceDelete;

// ConfigMeasureCreate;
// ConfigSourceCreate;
// ConfigMeasureStore;
// ConfigSourceStore;
// ConfigMeasureRecall;
// ConfigSourceRecall;
// ConfigBothRecall;


//Beep(600,0.1);

// SetDisplayBrightness(kt_ds_on75);
// if GetDisplayBrightness()
//  then showmessage(Kt2450_DisplayStateLabel[fDisplayState]);
// SetDisplayBrightness(kt_ds_off);
// if GetDisplayBrightness()
//  then showmessage(Kt2450_DisplayStateLabel[fDisplayState]);
// SetDisplayBrightness(kt_ds_black);
// if GetDisplayBrightness()
//  then showmessage(Kt2450_DisplayStateLabel[fDisplayState]);
// SetDisplayBrightness(kt_ds_on25);
// if GetDisplayBrightness()
//  then showmessage(Kt2450_DisplayStateLabel[fDisplayState]);


//  SetDigLineMode(1,kt_dt_trig,kt_dd_out);
//  SetDidLinOut(1);
//  SetDigLineMode(2,kt_dt_dig,kt_dd_out);
//  SetDidLinOut(2);
//  SetDigLineMode(3,kt_dt_dig,kt_dd_in);
// showmessage(inttostr(GetDidLinOut(3)));

//if GetDigLineMode(1) then
//  showmessage(Kt2450_DigLineTypeCommand[fDigitLineType[fDLActive]]+'  '
//              +Kt2450_DigLineDirectionCommand[fDigitLineDirec[fDLActive]]);

//SetDigLineMode(5,kt_dt_sync,kt_dd_in);
//SetDigLineMode(1,kt_dt_trig,kt_dd_out);


//if BufferGetStartEndIndex()
//  then showmessage(inttostr(Buffer.StartIndex)+'  '+inttostr(Buffer.EndIndex))
//  else showmessage('ups :(');


//showmessage(inttostr(BufferGetReadingNumber()));
//BufferCreate();
//showmessage(inttostr(BufferGetReadingNumber(MyBuffer)));

//BufferDataArrayExtended(1,5,kt_rd_MT);
//showmessage(fDataVector.XYtoString+#10#10+fDataTimeVector.XYtoString);
//BufferClear(Kt2450DefBuffer);
//BufferDataArrayExtended(1,5,kt_rd_MT);
//showmessage(fDataVector.XYtoString+#10#10+fDataTimeVector.XYtoString);


//BufferDataArrayExtended(2,5,kt_rd_M);
//showmessage(fDataVector.XYtoString+#10#10+fDataTimeVector.XYtoString);
//
//BufferDataArrayExtended(1,5,kt_rd_MST);
//showmessage(fDataVector.XYtoString+#10#10+fDataTimeVector.XYtoString);
//
//BufferDataArrayExtended(1,5,kt_rd_MT);
//showmessage(fDataVector.XYtoString+#10#10+fDataTimeVector.XYtoString);


//BufferDataArrayExtended(1,5,kt_rd_MS);
//showmessage(fDataVector.XYtoString+#10#10+fDataTimeVector.XYtoString);


//BufferLastDataExtended(kt_rd_MST,MyBuffer);
//showmessage(floattostr(fDevice.Value)
//              +'  '+floattostr(fSourceMeasuredValue)
//              +'  '+floattostr(fTimeValue));
//
//BufferLastDataExtended(kt_rd_MT);
//showmessage(floattostr(fDevice.Value)+'  '+floattostr(fTimeValue));
//
//BufferLastDataExtended();
//showmessage(floattostr(fDevice.Value)+'  '+floattostr(fSourceMeasuredValue));

// BufferLastDataSimple(MyBuffer);
// showmessage(floattostr(fDevice.Value));

// BufferLastDataSimple();
// showmessage(floattostr(fDevice.Value));


//MeasureExtended(kt_rd_MST,MyBuffer);
//showmessage(floattostr(fDevice.Value)
//              +'  '+floattostr(fSourceMeasuredValue)
//              +'  '+floattostr(fTimeValue));

//MeasureExtended(kt_rd_MT);
//showmessage(floattostr(fDevice.Value)+'  '+floattostr(fTimeValue));
//
//MeasureExtended();
//showmessage(floattostr(fDevice.Value)+'  '+floattostr(fSourceMeasuredValue));

// MeasureSimple(MyBuffer);
// showmessage(floattostr(fDevice.Value));

// BufferClear(Kt2450DefBuffer);
// MeasureSimple();
// showmessage(floattostr(fDevice.Value));

//if GetCount() then showmessage('Count='+inttostr(Count));

//SetCount(10);
//SetCount(-56);

//if BufferGetFillMode() then
//  showmessage('ura! '+Kt2450_BufferFillModeCommand[Buffer.FillMode]);
//if BufferGetFillMode('TestBuffer') then
//  showmessage('ura! '+Kt2450_BufferFillModeCommand[Buffer.FillMode]);

//BufferSetFillMode(kt_fm_cont);
//BufferSetFillMode('TestBuffer',kt_fm_once);

//showmessage(inttostr(BufferGetSize));
//showmessage(inttostr(Buffer.CountMax));
//showmessage(inttostr(BufferGetSize('TestBuffer')));


//BufferCreate();
//BufferCreate('Test  Buffer ',500,kt_bs_stan);
//BufferReSize(100);
//BufferReSize('TestBuffer',5);

//BufferDelete();
//BufferDelete('Test  Buffer ');

//BufferCreate();
//BufferCreate('Test  Buffer ',500,kt_bs_stan);



//if GetDisplayDigitsNumber then
//  showmessage(inttostr(fDisplayDN[fMeasureFunction])+Kt2450DisplayDNLabel);
//if GetDisplayDigitsNumber(kt_mCurrent) then
//  showmessage(inttostr(fDisplayDN[kt_mCurrent])+Kt2450DisplayDNLabel);

// SetDisplayDigitsNumber(4);
// SetDisplayDigitsNumber(kt_mVoltage,3);
// SetDisplayDigitsNumber(kt_mCurrent,6);

// showmessage(booltostr(IsHighCapacitanceOn(),True));
// SetHighCapacitanceState(False);
// showmessage(booltostr(IsHighCapacitanceOn(),True));

//SetHighCapacitanceState(kt_sVolt,False);
//SetHighCapacitanceState(kt_sCurr,True);
//SetHighCapacitanceState(True);

//if GetMeasureTime then
//  showmessage('ura! '+floattostr(fMeasureTime[fMeasureFunction]));
//if GetMeasureTime(kt_mCurrent) then
//  showmessage('ura! '+floattostr(fMeasureTime[kt_mCurrent]));

// SetMeasureTime(0.5);
// SetMeasureTime(kt_mVoltage,0.005);
// SetMeasureTime(kt_mCurrent,143);

//if GetSourceValue then
//  showmessage('ura! '+floattostr(fSourceValue[fSourceType]));
//if GetSourceValue(kt_sCurr) then
//  showmessage('ura! '+floattostr(fSourceValue[kt_sCurr]));

// SetSourceValue(0.5);
// SetSourceValue(kt_sVolt,0.25);
// SetSourceValue(kt_sCurr,-1e-6);

//   procedure SetSourceValue(Source:TKt2450_Source;
//                            value:double);overload;
//   procedure SetSourceValue(value:double);overload;
//   function GetSourceValue(Source:TKt2450_Source):boolean;overload;
//   function GetSourceValue():boolean;overload;
//   function GetSourceValues():boolean;


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
//SourceListCreate(kt_sCurr,ArrDouble);
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
//SetSourceDelay(kt_sCurr,1.25e-10);
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
  5:case fFirstLevelNode of
     5: JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
     0..1:begin
           JoinToStringToSend(RootNoodKt_2450[12+fFirstLevelNode]);
           JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
          end;
    end;  // fRootNode=5
  6:case fFirstLevelNode of
      12,13,14:
        begin
        JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
        JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
        end;
      else JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
     end;  // fRootNode=6
  7,9:JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
  11:case fFirstLevelNode of
       12..13:case fLeafNode of
                0:JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
                else
                   begin
                    JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
                    JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
                    if fIsTripped then JoinToStringToSend(FirstNodeKt_2450[11]);
                   end;
              end;
       55:JoinToStringToSend(RootNoodKt_2450[15]);
       23:case fLeafNode of
             79,80:begin
                   JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
                   JoinToStringToSend(RootNoodKt_2450[fLeafNode-79+12]);
                   JoinToStringToSend(FirstNodeKt_2450[24]);
                   end;
             else
                 begin
                 JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
                 JoinToStringToSend(RootNoodKt_2450[fLeafNode]);
                 end;
          end;
        24:begin
            JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
            JoinToStringToSend(FirstNodeKt_2450[23]);
            JoinToStringToSend(ConfLeafNodeKt_2450[fLeafNode]);
           end;
        25:begin
            JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
            case fLeafNode of
              1:JoinToStringToSend(SweepParameters[fSourceType].Lin);
              2:JoinToStringToSend(SweepParameters[fSourceType].LinStep);
              3:JoinToStringToSend(SweepParameters[fSourceType].List);
              4:JoinToStringToSend(SweepParameters[fSourceType].Log);
            end;
           end;
     end;// fRootNode=11
  12..14:
       begin
         JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
         case fLeafNode of
          18,19:JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
         end;
       end; // fRootNode=12..14
  17:if fFirstLevelNode=1 then JoinToStringToSend(fAdditionalString);
  19:begin
       JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
       case fFirstLevelNode of
        31:if fLeafNode=1 then JoinToStringToSend(Buffer.Get)
                           else fAdditionalString:=Buffer.ReSize;
        32:if fLeafNode=1 then JoinToStringToSend(Buffer.Get)
                           else fAdditionalString:=Buffer.FillModeChange;
        33:JoinToStringToSend(Buffer.DataDemandArray(TKt2450_ReturnedData(fLeafNode)));
        35:case fLeafNode of
            1:JoinToStringToSend(Buffer.Get);
            2:JoinToStringToSend(Buffer.LimitIndexies)
           end;
       end;
      end; // fRootNode=19
  21:case fFirstLevelNode of
       1:JoinToStringToSend(Buffer.Get);
       2..5:JoinToStringToSend(Buffer.DataDemand(TKt2450_ReturnedData(fFirstLevelNode-2)))
     end; // fRootNode=21
  22:case fFirstLevelNode of
       1:JoinToStringToSend(Buffer.Get);
       2..5:JoinToStringToSend(Buffer.DataDemand(TKt2450_ReturnedData(fFirstLevelNode-2)))
     end; // fRootNode=22
  23:case fFirstLevelNode of
        36,37:JoinToStringToSend(AnsiReplaceStr(FirstNodeKt_2450[fFirstLevelNode],'#',inttostr(fDLActive)));
     end; // fRootNode=23
  24:begin
        JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
        JoinToStringToSend(ConfLeafNodeKt_2450[fLeafNode]);
     end; // fRootNode=24
  26:case fFirstLevelNode of
        38,44,45:JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
        40,41,21,43:begin
            JoinToStringToSend(FirstNodeKt_2450[39]);
            JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
            JoinToStringToSend(TrigLeafNodeKt_2450[fLeafNode]);
            fAdditionalString:=IntTostr(fTrigBlockNumber)+PartDelimiter+fAdditionalString;
            inc(fTrigBlockNumber);
           end;
        24,11:begin
            JoinToStringToSend(FirstNodeKt_2450[39]);
            JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
            JoinToStringToSend(TrigLeafNodeKt_2450[fLeafNode]);
            fAdditionalString:=IntTostr(fTrigBlockNumber)+PartDelimiter+fAdditionalString;
            inc(fTrigBlockNumber);
           end;
         42:begin
             JoinToStringToSend(FirstNodeKt_2450[39]);
             JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
             fAdditionalString:=IntTostr(fTrigBlockNumber)+PartDelimiter+fAdditionalString;
             inc(fTrigBlockNumber);
            end;
     end;// fRootNode=26
 end;

 if fIsSuffix then JoinAddString;

end;

procedure TKt_2450.ProcessingString(Str: string);
begin
 Str:=Trim(Str);
 case fRootNode of
  0:if pos(Kt_2450_Test,Str)<>0 then fDevice.Value:=314;
  5:case fFirstLevelNode of
     5,55:fDevice.Value:=StrToInt(Str);
     0..1:begin
          if StringToOutPutState(AnsiLowerCase(Str))
            then fDevice.Value:=ord(fOutputOffState[TKt2450_Source(fFirstLevelNode)]);
          end;
    end; //fRootNode=5
  6:if fFirstLevelNode=30
       then
        begin
        if StringToDisplayBrightness(AnsiLowerCase(Str))
            then fDevice.Value:=ord(fDisplayState);

        end
       else fDevice.Value:=StrToInt(Str);
  9:if StringToTerminals(AnsiLowerCase(Str))
          then fDevice.Value:=ord(fTerminal);
  11:case fFirstLevelNode of
        23:begin
           StringToArray(Str);
           if fDataVector.Count>0 then fDevice.Value:=1;
           end;
        else
           case fLeafNode of
            10:if StringToVoltageProtection(AnsiLowerCase(Str),fVoltageProtection)
                then fDevice.Value:=ord(fVoltageProtection);
            0,12..13,15,21:fDevice.Value:=SCPI_StringToValue(Str);
            55:if StringToSourceType(AnsiLowerCase(Str)) then fDevice.Value:=ord(fSourceType);
            16,17,22,27:fDevice.Value:=StrToInt(Str);
           end;
     end; //fRootNode=11
   12..14:case fFirstLevelNode of
             7,9,20: fDevice.Value:=StrToInt(Str);
             14: if StringToMeasureUnit(AnsiLowerCase(Str))
                    then fDevice.Value:=ord(fMeasureUnits[TKt2450_Measure(fFirstLevelNode-12)]);
             16,15,26:fDevice.Value:=SCPI_StringToValue(Str);
          end;   //fRootNode=12..14
   15:if StringToMeasureFunction(AnsiLowerCase(Str)) then fDevice.Value:=ord(fMeasureFunction);
   19:case fFirstLevelNode of
          31: fDevice.Value:=StrToInt(Str);
          32:if Buffer.StringToFillMode(AnsiLowerCase(Str))
                then fDevice.Value:=ord(TKt2450_BufferFillMode(Buffer.FillMode));
          33:StringToMesuredDataArray(AnsiReplaceStr(Str,',',' '),TKt2450_ReturnedData(fLeafNode));
          35:case fLeafNode of
              0,1:fDevice.Value:=StrToInt(Str);
              2:if StringToBufferIndexies(Str) then fDevice.Value:=1;
             end;
      end; //fRootNode=19
   20:fDevice.Value:=StrToInt(Str);
   21:case fFirstLevelNode of
       0,1:fDevice.Value:=SCPI_StringToValue(Str);
       2..5:StringToMesuredData(AnsiReplaceStr(Str,',',' '),TKt2450_ReturnedData(fFirstLevelNode-2));
       end; //fRootNode=21
   22:case fFirstLevelNode of
       0,1:fDevice.Value:=SCPI_StringToValue(Str);
       2..5:StringToMesuredData(AnsiReplaceStr(Str,',',' '),TKt2450_ReturnedData(fFirstLevelNode-2));
      end;  //fRootNode=22
   23:case fFirstLevelNode of
       36:StringToDigLineStatus(AnsiLowerCase(Str));
       37:fDevice.Value:=StrToInt(Str);
      end;
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

procedure TKt_2450.SetCount(Cnt: integer);
begin
// :COUN <n>
 Count:=Cnt;
 fAdditionalString:=IntToStr(Count);
 SetupOperation(20);
end;

procedure TKt_2450.SetCountNumber(Value: integer);
 const CountLimits:TLimitValues=(1,300000);
begin
 fCount:=NumberMap(Value,CountLimits);
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

procedure TKt_2450.SetDisplayDigitsNumber(Measure: TKt2450_Measure;
  Number: Kt2450DisplayDigitsNumber);
begin
//:DISP:CURR|VOLT|RES:DIG n
 fAdditionalString:=inttostr(Number);
 SetupOperation(6,ord(Measure)+12,28);
 fDisplayDN[Measure]:=Number;
end;

procedure TKt_2450.SetDidLinOut(LineNumber: TKt2450_DigLines;
  HighLevel: boolean);
begin
 if (fDigitLineType[LineNumber]<>kt_dt_dig)
    or(fDigitLineDirec[LineNumber]<>kt_dd_out) then Exit;
 fDLActive:=LineNumber;
 if HighLevel then fAdditionalString:='1'
              else fAdditionalString:='0';
 SetupOperation(23,37);
end;

procedure TKt_2450.SetDigLineMode(LineNumber: TKt2450_DigLines;
  LineType: TKt2450_DigLineType; Direction: TKt2450_DigLineDirection);
begin
//:DIG:LINE<n>:MODE <lineType>, <lineDirection>
 if ((LineType=kt_dt_sync)and(Direction in [kt_dd_in..kt_dd_opdr]))
    or((LineType<>kt_dt_sync)and(Direction in [kt_dd_mas..kt_dd_ac])) then Exit;


 fDLActive:=LineNumber;
 fDigitLineType[fDLActive]:=LineType;
 fDigitLineDirec[fDLActive]:=Direction;
 fAdditionalString:=Kt2450_DigLineTypeCommand[LineType]+PartDelimiter
                    +Kt2450_DigLineDirectionCommand[Direction];

 SetupOperation(23,36);
end;

procedure TKt_2450.SetDisplayBrightness(State: TKt2450_DisplayState);
begin
//:DISP:LIGH:STAT <brightness>
 fDisplayState:=State;
 fAdditionalString:=Kt2450_DisplayStateCommand[State];
 SetupOperation(6,30);
end;

procedure TKt_2450.SetDisplayDigitsNumber(Number: Kt2450DisplayDigitsNumber);
begin
  SetDisplayDigitsNumber(fMeasureFunction,Number);
end;

procedure TKt_2450.SetHighCapacitanceState(Source: TKt2450_Source;
  toOn: boolean);
begin
//SOUR:VOLT|CURR:HIGH:CAP ON|OFF
 OnOffFromBool(toOn);
 SetupOperation(11,1-ord(Source)+12,27);
 fHighCapacitance[Source]:=toOn;
end;

procedure TKt_2450.SetHighCapacitanceState(toOn: boolean);
begin
  SetHighCapacitanceState(fSourceType,toOn);
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
 SetupOperation(12,16,18);
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

procedure TKt_2450.SetMeasureTime(Measure: TKt2450_Measure; Value: double);
begin
//CURR|VOLT|RES:NPLC value
 fAdditionalString:=NumberToStrLimited(Value/KT_2450_MeaureTimeConvertConst,Kt_2450_MeasureTimeLimits);
 SetupOperation(ord(Measure)+12,26);
 fMeasureTime[Measure]:=strtofloat(fAdditionalString)*KT_2450_MeaureTimeConvertConst;
end;

procedure TKt_2450.SetMeasureTime(Value: double);
begin
  SetMeasureTime(fMeasureFunction,Value);
end;

//procedure TKt_2450.SetMeasureHighRange(Value: double);
//begin
////:VOLT|CURR|RES:RANG:AUTO:ULIM <value>
// fAdditionalString:=NumberToStrLimited(Value, Kt_2450_RangesLimits[fMeasureFunction]);
// SetupOperation(ord(fMeasureFunction)+12,16,19);
//end;

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
 SetupOperation(13,16,18);
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

procedure TKt_2450.SetSourceValue(value: double);
begin
 SetSourceValue(fSourceType,value);
end;

procedure TKt_2450.SetSourceValue(Source: TKt2450_Source; value: double);
begin
// SOUR:VOLT|CURR <n>
 fAdditionalString:=NumberToStrLimited(Value,Kt_2450_SourceSweepLimits[Source]);
 SetupOperation(11,1-ord(Source)+12);
 fSourceValue[Source]:=strtofloat(fAdditionalString);
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

procedure TKt_2450.Wait;
begin
// *WAI
 SetupOperation(25,0,0,False);
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

function TKt_2450.StringToBufferIndexies(Str: string): boolean;
begin
 Str:=AnsiReplaceStr(Str,';',' ');
 Buffer.StartIndex:=round(FloatDataFromRow(Str,1));
 Buffer.EndIndex:=round(FloatDataFromRow(Str,2));
 Result:=(Buffer.StartIndex<>ErResult)and(Buffer.EndIndex<>ErResult);
end;

procedure TKt_2450.StringToDigLineStatus(Str: string);
 var i:integer;
     tempStr:string;
begin
 Str:=AnsiReplaceStr(Str,',',' ');
 TempStr:=StringDataFromRow(Str,1);
 for I := ord(Low(TKt2450_DigLineType)) to ord(High(TKt2450_DigLineType)) do
   if tempStr=Kt2450_DigLineTypeCommand[TKt2450_DigLineType(i)] then
     begin
       fDigitLineType[fDLActive]:=TKt2450_DigLineType(i);
       fDevice.Value:=1;
       Break;
     end;
 TempStr:=StringDataFromRow(Str,2);
 for I := ord(Low(TKt2450_DigLineDirection)) to ord(High(TKt2450_DigLineDirection)) do
   if tempStr=Kt2450_DigLineDirectionCommand[TKt2450_DigLineDirection(i)] then
     begin
       fDigitLineDirec[fDLActive]:=TKt2450_DigLineDirection(i);
       fDevice.Value:=fDevice.Value+1;
       Break;
     end;
end;

function TKt_2450.StringToDisplayBrightness(Str: string): boolean;
  var i:TKt2450_DisplayState;
begin
 Result:=False;
 for I := Low(TKt2450_DisplayState) to High(TKt2450_DisplayState) do
  begin
   if Str=Kt2450_DisplayStateCommand[i] then
     begin
       fDisplayState:=i;
       Result:=True;
       Break;
     end;
  end;
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

function TKt_2450.StringToMeasureTime(Str: string): double;
begin
 Str:=AnsiReplaceStr(Str,':',' ');
 Result:=(FloatDataFromRow(Str,4)+FloatDataFromRow(Str,3)
         +60*FloatDataFromRow(Str,2)+3600*FloatDataFromRow(Str,1))*1e3;
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

procedure TKt_2450.StringToMesuredData(Str: string;DataType:TKt2450_ReturnedData);
begin
// if NumberOfSubstringInRow(Str)<>Kt2450_PartInRespond[DataType] then Exit;
// Str:=DeleteSubstringAll(Str,',');
// showmessage(Str);
// Str:=AnsiReplaceStr(Str,',',' ');
 fDevice.Value:=FloatDataFromRow(Str,1);
 if (fDevice.Value=ErResult)or(DataType=kt_rd_M) then Exit;
 case DataType of
   kt_rd_MS,kt_rd_MST:fSourceMeasuredValue:=FloatDataFromRow(Str,2);
   kt_rd_MT:fTimeValue:=StringToMeasureTime(DeleteStringDataFromRow(Str,1));
 end;
 if DataType=kt_rd_MST then fTimeValue:=StringToMeasureTime(DeleteStringDataFromRow(DeleteStringDataFromRow(Str,1),1));
end;

procedure TKt_2450.StringToMesuredDataArray(Str: string;
  DataType: TKt2450_ReturnedData);
  var partStr:string;
      PartNumbers,i:integer;
      NumbersArray:TArrInteger;
begin

 PartNumbers:=NumberOfSubstringInRow(Str);
 SetLength(NumbersArray,Kt2450_PartInRespond[DataType]);
 for I := 0 to High(NumbersArray) do
  NumbersArray[i]:=i+1;

 while PartNumbers>=Kt2450_PartInRespond[DataType] do
  begin
   partStr:=NewStringByNumbers(Str,NumbersArray);
   StringToMesuredData(partStr,DataType);
   case DataType of
    kt_rd_MS:fDataVector.Add(fSourceMeasuredValue,fDevice.Value);
    kt_rd_MT:fDataTimeVector.Add(fTimeValue,fDevice.Value);
    kt_rd_MST:begin
               fDataVector.Add(fSourceMeasuredValue,fDevice.Value);
               fDataTimeVector.Add(fTimeValue,fDevice.Value);
              end;
    kt_rd_M:fDataVector.Add(fDevice.Value,fDevice.Value);
   end;
   PartNumbers:=PartNumbers-Kt2450_PartInRespond[DataType];
   for I := 1 to Kt2450_PartInRespond[DataType] do
    Str:=DeleteStringDataFromRow(Str,1);
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

procedure TKt_2450.TrigAlwaysTransition(TransitionBlockNumber: word);
begin
//:TRIG:BLOC:BRAN:ALW <blockNumber>, <branchToBlock>
 if TransitionBlockNumber=0 then exit;
 fAdditionalString:=IntToStr(TransitionBlockNumber);
 SetupOperation(26,41,4);
end;

procedure TKt_2450.TrigBufferClear(BufName: string);
begin
//:TRIG:BLOC:BUFF:CLE <blockNumber>, "<bufferName>"
 fAdditionalString:=StringToInvertedCommas(BufName);
 SetupOperation(26,40,0);
// inc(fTrigBranchNumber);
end;

procedure TKt_2450.TrigConfigListNext(ListName: string);
begin
//:TRIG:BLOC:CONF:NEXT <blockNumber>, "<configurationList>"
 fAdditionalString:=StringToInvertedCommas(ListName);
 SetupOperation(26,24,2);
end;

procedure TKt_2450.TrigConfigListNext(ListName1, ListName2: string);
begin
//:TRIG:BLOC:CONF::NEXT <blockNumber>, "<configurationList>", "<configurationList2>"
 fAdditionalString:=StringToInvertedCommas(ListName1)+PartDelimiter
                    +StringToInvertedCommas(ListName2);
 SetupOperation(26,24,2);
end;

procedure TKt_2450.TrigConfigListRecall(ListName: string; Index: integer);
begin
//:TRIG:BLOC:CONF:REC <blockNumber>, "<configurationList>", <index>
 fAdditionalString:=StringToInvertedCommas(ListName)+PartDelimiter+
                    inttostr(Index);
 SetupOperation(26,24,1);
end;

procedure TKt_2450.TrigCounterTransition(TargetCount,
  TransitionBlockNumber: word);
begin
//:TRIG:BLOC:BRAN:COUN <blockNumber>, <targetCount>, <branchToBlock>
 if (TransitionBlockNumber=0)or(TargetCount=0) then Exit;
 fAdditionalString:=IntToStr(TargetCount)+PartDelimiter
                    + IntToStr(TransitionBlockNumber);
  SetupOperation(26,43,7);
end;

procedure TKt_2450.TrigIVLoop(i: Integer);
var
  LoopTransitionNumber: Word;
begin
  TrigAlwaysTransition(fTrigBlockNumber + 2);
  LoopTransitionNumber := fTrigBlockNumber;
  TrigConfigListNext(MySourceList);
  TrigDelay(DragonBackTime);
  if ToUseDragonBackTime then
  begin
    TrigConfigListNext(MySourceList);
    TrigDelay(DragonBackTime);
  end;
  TrigMeasure;
  if CurrentValueLimitEnable then
    TrigMeasureResultTransition(kt_tlt_outside, -Imax, Imax, fTrigBlockNumber + 2);
  inc(fTrigBlockNumber);
  TrigCounterTransition(i, LoopTransitionNumber);
end;

procedure TKt_2450.TrigDelay(DelayTime: double);
begin
//:TRIG:BLOC:DEL:CONS <blockNumber>, <time>
 fAdditionalString:=floattostr(NumberMap(DelayTime,Kt_2450_TrigDelayLimits));
 SetupOperation(26,21,5);
end;

procedure TKt_2450.TrigEventGenerate;
begin
// *TRG
 SetupOperation(27,0,0,False);
end;

procedure TKt_2450.TrigEventTransition(TransitionBlockNumber: word;
  EventType: TK2450_TriggerEvents; EventNumber: word);
begin
//:TRIG:BLOC:BRAN:EVEN <blockNumber>, <event>, <branchToBlock>
 if (TransitionBlockNumber=0)or(EventNumber=0) then Exit;
 if (EventType=kt_te_timer)and(EventNumber>4) then Exit;
 if (EventType=kt_te_notify)and(EventNumber>8) then Exit;
 if (EventType=kt_te_lan)and(EventNumber>8) then Exit;
 if (EventType=kt_te_dig)and(EventNumber>6) then Exit;
 if (EventType=kt_te_blend)and(EventNumber>2) then Exit;
 if (EventType=kt_te_tspl)and(EventNumber>3) then Exit;

 fAdditionalString:=Kt2450_TriggerEventsCommand[EventType];
 if EventType in [kt_te_timer..kt_te_tspl] then
   fAdditionalString:=fAdditionalString + IntToStr(EventNumber);
 fAdditionalString:=fAdditionalString+PartDelimiter
                    + IntToStr(TransitionBlockNumber);
 SetupOperation(26,43,8);
end;

procedure TKt_2450.TrigForIVCreate;
 var SourceValueTemp:double;
     i,BranchesLimitIndex:integer;
     PlaceForTrigEvent1,PlaceForTrigEvent2:integer;
//     LoopTransitionNumber:word;
begin
 HookForTrigDataObtain();
// showmessage(DataVector.XYtoString);

 ConfigMeasureCreate;
 ConfigSourceCreate;
 SetMode(kt_md_sVmC);
 SourceValueTemp:=SourceValue[fSourceType];
 OutPutChange(False);
 ConfigMeasureStore();
 BranchesLimitIndex:=0;
 for I := 0 to DataVector.HighNumber do
   begin
     if DataVector.X[i]=ErResult then
      begin
        BranchesLimitIndex:=i+1;
        Continue;
      end;
     SetSourceValue(DataVector.X[i]);
     ConfigSourceStore();
   end;
 SetSourceValue(SourceValueTemp);

 TrigNewCreate();
 TrigBufferClear();
 TrigConfigListRecall(MyMeasList);
 TrigConfigListRecall(MySourceList);
 TrigOutPutChange(True);

 if  BranchesLimitIndex>0 then
   begin
     if ToUseDragonBackTime
        then i:=round((BranchesLimitIndex-1)/2)
        else i:=BranchesLimitIndex-1;
   end                    else
   begin
     if ToUseDragonBackTime
        then i:=round(DataVector.HighNumber/2)
        else i:=DataVector.HighNumber;
   end;
 TrigIVLoop(i);
 PlaceForTrigEvent1:=fTrigBlockNumber-2;
 PlaceForTrigEvent2:=fTrigBlockNumber-2;
{останній не треба, але кричало про можливу невизначеність PlaceForTrigEvent2}
 if  BranchesLimitIndex>0
   then
    begin
      TrigConfigListRecall(MySourceList,BranchesLimitIndex);

      if ToUseDragonBackTime
        then i:=round((DataVector.HighNumber-BranchesLimitIndex)/2)
        else i:=DataVector.HighNumber-BranchesLimitIndex;

      TrigIVLoop(i);
      PlaceForTrigEvent2:=fTrigBlockNumber-2;
    end;

 TrigConfigListNext(MySourceList);
 TrigOutPutChange(False);

 i:=fTrigBlockNumber-2;
 fTrigBlockNumber:=PlaceForTrigEvent1;
 TrigEventTransition(i);
 if BranchesLimitIndex>0 then
   begin
   fTrigBlockNumber:=PlaceForTrigEvent2;
   TrigEventTransition(i);
   end;

end;

procedure TKt_2450.TrigMeasure(BufName: string; Count: word);
begin
//:TRIG:BLOC:MDIG <blockNumber>, "<bufferName>", <count>
 fAdditionalString:=StringToInvertedCommas(BufName)+PartDelimiter
                    +IntToStr(Count);
 SetupOperation(26,42);
end;

procedure TKt_2450.TrigMeasureCountDevice(BufName: string);
begin
//:TRIG:BLOC:MDIG <blockNumber>, "<bufferName>", AUTO
 fAdditionalString:=StringToInvertedCommas(BufName)+PartDelimiter
                    +'auto';
 SetupOperation(26,42);
end;

procedure TKt_2450.TrigMeasureInf(BufName: string);
begin
//:TRIG:BLOC:MDIG <blockNumber>, "<bufferName>", INF
 fAdditionalString:=StringToInvertedCommas(BufName)+PartDelimiter
                    +'inf';
 SetupOperation(26,42);
end;

procedure TKt_2450.TrigMeasureResultTransition(LimitType: TK2450_TrigLimitType;
  LimA, LimB: double; TransitionBlockNumber, MeasureBlockNumber: word);
begin
//:TRIG:BLOC:BRAN:LIM:CONS <blockNumber>, <limitType>, <limitA>, <limitB>,
//<branchToBlock>, <measureDigitizeBlock>
 if TransitionBlockNumber=0 then Exit;
 fAdditionalString:=Kt2450_TrigLimitTypeCommand[LimitType]+PartDelimiter
                    +floattostr(LimA)+PartDelimiter
                    +floattostr(LimB)+PartDelimiter
                    +IntTostr(TransitionBlockNumber)+PartDelimiter
                    +IntTostr(MeasureBlockNumber);
 SetupOperation(26,43,6);
end;

procedure TKt_2450.TrigNewCreate;
begin
//:TRIGger:LOAD "Empty"
 fTrigBlockNumber:=1;
 fAdditionalString:=StringToInvertedCommas('Empty');
 SetupOperation(26,38);
end;

procedure TKt_2450.TrigOutPutChange(toOn: boolean);
begin
//:TRIG:BLOC:SOUR:STAT <blockNumber>, ON|OFF
 OnOffFromBool(toOn);
 SetupOperation(26,11,3);
end;

procedure TKt_2450.TrigPause;
begin
//:TRIG:PAUS
 SetupOperation(26,44,0,False);
end;

procedure TKt_2450.TrigResume;
begin
//:TRIG:RES
 SetupOperation(26,45,0,False);
end;

procedure TKt_2450.BufferCreate(Name: string; Size: integer);
begin
 Buffer.CountMax:=Size;
 BufferCreate(Name);
end;

procedure TKt_2450.BufferCreate(Name: string; Size: integer;
  Style: TKt2450_BufferStyle);
begin
// :TRAC:MAKE "<bufferName>", <bufferSize>, <bufferStyle>
 Buffer.Style:=Style;
 BufferCreate(Name,Size);
end;

procedure TKt_2450.BufferClear;
begin
  fAdditionalString:=Buffer.Name;
  SetupOperation(19,3);
end;

procedure TKt_2450.Beep(Freq: word; Duration: double);
begin
//:SYST:BEEP <frequency>, <duration>
fAdditionalString:=IntToStr(NumberMap(Freq,Kt_2450_BeepFrequancyLimits))
                   +PartDelimiter
                   +floattostr(NumberMap(Duration,Kt_2450_BeepDurationLimits));
 SetupOperation(7,34);
end;

procedure TKt_2450.BufferClear(BufName: string);
begin
//:TRAC:CLE "<bufferName>"
 Buffer.SetName(BufName);
 fAdditionalString:=Buffer.Name;
 SetupOperation(19,3);
end;

procedure TKt_2450.BufferCreate(Style: TKt2450_BufferStyle);
begin
 Buffer.Style:=Style;
 BufferCreate();
end;

procedure TKt_2450.BufferDelete;
begin
 fAdditionalString:=Buffer.Name;
 SetupOperation(19,21);
end;

procedure TKt_2450.BufferDataArrayExtended(SIndex, EIndex: integer;
  DataType: TKt2450_ReturnedData; BufName: string);
begin
// :TRAC:DATA? <startIndex>, <endIndex>, "<bufferName>", <bufferElements>
 fDataVector.Clear;
 fDataTimeVector.Clear;
 Buffer.SetName(BufName);
 Buffer.StartIndex:=SIndex;
 Buffer.EndIndex:=EIndex;
 QuireOperation(19,33,ord(DataType),False);
end;

procedure TKt_2450.BufferDelete(Name: string);
begin
// :TRAC:DEL "testData"
 Buffer.SetName(Name);
 BufferDelete();
end;

function TKt_2450.BufferGetFillMode: boolean;
begin
  QuireOperation(19,32,1,False);
  Result:=(fDevice.Value<>ErResult);
end;

function TKt_2450.BufferGetFillMode(BufName: string): boolean;
begin
// :TRAC:FILL:MODE? "<bufferName>"
 Buffer.SetName(BufName);
 Result:=BufferGetFillMode();
end;


function TKt_2450.BufferGetReadingNumber(BufName: string): integer;
begin
// :TRAC:ACT? "<bufferName>"
 if BufName=Kt2450DefBuffer
      then QuireOperation(19,35)
      else begin
           Buffer.SetName(BufName);
           QuireOperation(19,35,1,False);
           end;
 if fDevice.isReceived
    then Result:=round(fDevice.Value)
    else Result:=-1;
end;

procedure TKt_2450.BufferReSize(BufName: string; NewSize: integer);
begin
// :TRAC:POIN <newSize>, "<bufferName>"
 Buffer.SetName(BufName);
 BufferReSize(NewSize);
end;

procedure TKt_2450.BufferSetFillMode(BufName: string;
  FillMode: TKt2450_BufferFillMode);
begin
// :TRACe:FILL:MODE ONCE|CONT, "<bufferName>"
 Buffer.SetName(BufName);
 BufferSetFillMode(FillMode);
end;

procedure TKt_2450.BufferSetFillMode(FillMode: TKt2450_BufferFillMode);
begin
 Buffer.FillMode:=FillMode;
 SetupOperation(19,32);
end;

procedure TKt_2450.BufferReSize(NewSize: integer);
begin
 Buffer.CountMax:=NewSize;
 SetupOperation(19,31);
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

//   fMinDelayTime:integer;
//  {інтервал очікування перед початком перевірки
//  вхідного буфера, []=мс, за замовчуванням 0}
//   fDelayTimeStep:integer;
//   {проміжок часу, через який перевіряється
//   надходження даних, []=мс, за замовчуванням 10}
//   fDelayTimeMax:integer;
//   {максимальна кількість перевірок
//   надходження даних, []=штук, за замовчуванням 130,
//   тобто за замовчуванням інтервал очікуввання
//   складає 0+10*130=1300 мс}

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

{ TKT2450_Measurement }

constructor TKT2450_Meter.Create(Kt_2450: TKt_2450);
begin
 fTimer:=TTimer.Create(nil);
 fTimer.Enabled:=False;
 fTimer.Interval:=2000;
 inherited Create(Kt_2450);
 fName:='KT2450Meter';
// fParentModule:=Kt_2450;
end;

destructor TKT2450_Meter.Destroy;
begin
 FreeAndNil(fTimer);
 inherited;
end;

//function TKT2450_Meter.GetData: double;
//begin
// if (fParentModule.Sences[fParentModule.MeasureFunction]=kt_s4wire)
//    or(fParentModule.Mode in [kt_md_sVmR,kt_md_sImR])
//    or (fParentModule.OutputOffState[fParentModule.SourceType] =kt_oos_himp)
//     then fParentModule.OutPutChange(true);
// fParentModule.MeasureSimple;
// fValue:=fParentModule.Device.Value;
// Result:=fValue;
// fNewData:=fParentModule.Device.NewData;
//end;

function TKT2450_Meter.GetMeasureModeLabel: string;
begin
 case fParentModule.Mode of
  kt_md_sVmC,kt_md_sImC:Result:=' A';
  kt_md_sVmV,kt_md_sImV:Result:=' V';
  kt_md_sVmR,kt_md_sImR:Result:='Ohm';
  else Result:=' W';
 end;
end;

function TKT2450_Meter.GetValueFromDevice: double;
begin
 Result:=fParentModule.Device.Value;
end;

{ TKT2450_Measurement }

constructor TKT2450_Measurement.Create(Kt_2450: TKt_2450);
begin
 inherited Create;
 fParentModule:=Kt_2450;
end;

function TKT2450_Measurement.GetData: double;
begin
 GetDataPreparation;
 fValue:=GetValueFromDevice;
 Result:=fValue;
 fNewData:=fParentModule.Device.NewData;
end;

procedure TKT2450_Measurement.GetDataPreparation;
begin
  if (fParentModule.Sences[fParentModule.MeasureFunction] = kt_s4wire) or (fParentModule.Mode in [kt_md_sVmR, kt_md_sImR]) or (fParentModule.OutputOffState[fParentModule.SourceType] = kt_oos_himp) then
    fParentModule.OutPutChange(true);
  fParentModule.MeasureExtended(kt_rd_MS);
//  fParentModule.MeasureSimple;
end;

function TKT2450_Measurement.GetValueFromDevice: double;
begin
 Result:=ErResult;
end;

{ TKT2450_SourceMeter }

constructor TKT2450_SourceMeter.Create(Kt_2450: TKt_2450);
begin
 inherited Create(Kt_2450);
 fName:='KT2450SourceMeter';
end;

function TKT2450_SourceMeter.GetValueFromDevice: double;
begin
  Result:=fParentModule.SourceMeasuredValue;
end;

{ TKT2450_Source }

constructor TKT2450_SourceDevice.Create(Kt_2450: TKt_2450);
begin
 inherited Create;
 fParentModule:=Kt_2450;
 fName:='Kt2450Source'
end;

function TKT2450_SourceDevice.GetOutputValue: double;
begin
 Result:=fOutputValue;
end;

procedure TKT2450_SourceDevice.Output(Value: double);
begin
 fParentModule.SetSourceValue(Value);
 if not(fParentModule.OutPutOn) then
    fParentModule.OutPutChange(True);
end;

procedure TKT2450_SourceDevice.Reset;
begin
 fParentModule.SetSourceValue(0);
 fParentModule.OutPutChange(False);
end;

end.
