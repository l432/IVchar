unit Keithley;

interface

uses
  TelnetDevice, SCPI, IdTelnet, ShowTypes;

type

 TKeitleyDevice=class(TTelnetMeterDeviceSingle)
  private
   fSCPI:TSCPInew;
  protected
   procedure UpDate();override;
  public
   Constructor Create(SCPInew:TSCPInew;Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string);
 end;

 TKeitley=class(TSCPInew)
  private

//   fIsTripped:boolean;
//
//   fTerminal:TKt2450_OutputTerminals;
//   fOutPutOn:boolean;
//   fResistanceCompencateOn:TKt2450_MeasureBool;
//   fAzeroState:TKt2450_MeasureBool;
//   fReadBack:TKt2450_SourceBool;
//   fHighCapacitance:TKt2450_SourceBool;
//   fSences:TKt2450_Senses;
//   fMeasureUnits:TKt_2450_MeasureUnits;
//   fOutputOffState:TKt_2450_OutputOffStates;
//   fSourceType:TKt2450_Source;
//   fMeasureFunction:TKt2450_Measure;
//   fVoltageProtection:TKt_2450_VoltageProtection;
//   fVoltageLimit:double;
//   fCurrentLimit:double;
//   fMode:TKt_2450_Mode;
//   fSourceVoltageRange:TKt2450VoltageRange;
//   fSourceCurrentRange:TKt2450CurrentRange;
//   fMeasureVoltageRange:TKt2450VoltageRange;
//   fMeasureCurrentRange:TKt2450CurrentRange;
//   fMeasureVoltageLowRange:TKt2450VoltageRange;
//   fMeasureCurrentLowRange:TKt2450CurrentRange;
//   fSourceDelay:TKt2450_SourceDouble;
//   fSourceValue:TKt2450_SourceDouble;
//   fSourceDelayAuto:TKt2450_SourceBool;
//   fMeasureTime:TKt2450_MeasureDouble;
//   fDisplayDN:TKt2450_MeasureDisplayDN;
//   fDataVector:TVector;
//   {X - значення джерела; Y - результат виміру}
//   fDataTimeVector:TVector;
//   {X - час виміру (мілісекунди з початку доби); Y - результат виміру}
//   fBuffer:TKt2450_Buffer;
//   fCount:integer;
//   fSourceMeasuredValue:double;
//   fTimeValue:double;
//   {час виміру, в мілісекундах з початку доби}
//   fDigitLineType:TKt2450_DigLineTypes;
//   fDigitLineDirec:TKt2450_DigLineDirections;
//   fDLActive:TKt2450_DigLines;
//   fMeter:TKT2450_Meter;
//   fSourceMeter:TKT2450_SourceMeter;
//   fSourceDevice:TKT2450_SourceDevice;
//   fDisplayState:TKt2450_DisplayState;
//   fHookForTrigDataObtain: TSimpleEvent;
//   fTrigBlockNumber:word;
//   fDragonBackTime:double;
//   fToUseDragonBackTime:boolean;
//   fImax:double;
//   fImin:double;
//   FCurrentValueLimitEnable:boolean;
//   fSweepWasCreated:boolean;
//   procedure OnOffFromBool(toOn:boolean);
//   function StringToVoltageProtection(Str:string;var vp:TKt_2450_VoltageProtection):boolean;
//   function StringToSourceType(Str:string):boolean;
//   function StringToMeasureFunction(Str:string):boolean;
//   function StringToTerminals(Str:string):boolean;
//   function StringToOutPutState(Str:string):boolean;
//   function StringToMeasureUnit(Str:string):boolean;
//   function StringToBufferIndexies(Str:string):boolean;
//   function StringToDisplayBrightness(Str:string):boolean;
//   procedure StringToDigLineStatus(Str:string);
//   procedure StringToArray(Str:string);
//   procedure StringToMesuredData(Str:string;DataType:TKt2450_ReturnedData);
//   procedure StringToMesuredDataArray(Str:string;DataType:TKt2450_ReturnedData);
//   function StringToMeasureTime(Str:string):double;
//   function IsLimitExcided(FirstLevelNode,LeafNode:byte):boolean;
//   {типова функція для запиту, чи ввімкнув прилад певні захисти}
//   function ModeDetermination:TKt_2450_Mode;
//   function ValueToVoltageRange(Value:double):TKt2450VoltageRange;
//   function VoltageRangeToString(Range:TKt2450VoltageRange):string;
//   function ValueToCurrentRange(Value:double):TKt2450CurrentRange;
//   function CurrentRangeToString(Range:TKt2450CurrentRange):string;
//   procedure SetCountNumber(Value:integer);
//   procedure TrigIVLoop(i: Integer);
  protected
   fTelnet:TIdTelnet;
   fIPAdressShow: TIPAdressShow;
//   procedure PrepareString;override;
//   procedure DeviceCreate(Nm:string);override;
//   procedure DefaultSettings;override;
  public
//   SweepParameters:array[TKt2450_Source]of TKt_2450_SweepParameters;
//   property HookForTrigDataObtain:TSimpleEvent read fHookForTrigDataObtain write fHookForTrigDataObtain;
//   property DataVector:TVector read fDataVector;
//   property DataTimeVector:TVector read fDataTimeVector;
//   property SourceType:TKt2450_Source read fSourceType;
//   property MeasureFunction:TKt2450_Measure read fMeasureFunction;
//   property VoltageProtection:TKt_2450_VoltageProtection read fVoltageProtection;
//   property VoltageLimit:double read fVoltageLimit;
//   property CurrentLimit:double read fCurrentLimit;
//   property Terminal:TKt2450_OutputTerminals read fTerminal;
//   property OutPutOn:boolean read fOutPutOn write fOutPutOn;
//   property ResistanceCompencateOn:TKt2450_MeasureBool read fResistanceCompencateOn;
//   property ReadBack:TKt2450_SourceBool read fReadBack;
//   property HighCapacitance:TKt2450_SourceBool read fHighCapacitance;
//   property Sences:TKt2450_Senses read fSences;
//   property MeasureUnits:TKt_2450_MeasureUnits read fMeasureUnits;
//   property OutputOffState:TKt_2450_OutputOffStates read fOutputOffState;
//   property Mode:TKt_2450_Mode read fMode;
//   property SourceVoltageRange:TKt2450VoltageRange read fSourceVoltageRange;
//   property SourceCurrentRange:TKt2450CurrentRange read fSourceCurrentRange;
//   property MeasureVoltageRange:TKt2450VoltageRange read fMeasureVoltageRange;
//   property MeasureCurrentRange:TKt2450CurrentRange read fMeasureCurrentRange;
//   property MeasureVoltageLowRange:TKt2450VoltageRange read fMeasureVoltageLowRange;
//   property MeasureCurrentLowRange:TKt2450CurrentRange read fMeasureCurrentLowRange;
//   property AzeroState:TKt2450_MeasureBool read fAzeroState;
//   property SourceDelay:TKt2450_SourceDouble read fSourceDelay;
//   property SourceValue:TKt2450_SourceDouble read fSourceValue;
//   property SourceDelayAuto:TKt2450_SourceBool read fSourceDelayAuto;
//   property DisplayDN:TKt2450_MeasureDisplayDN read fDisplayDN;
//   property MeasureTime:TKt2450_MeasureDouble read fMeasureTime;
//   property Buffer:TKt2450_Buffer read fBuffer;
//   property Count:integer read fCount write SetCountNumber;
//   property SourceMeasuredValue:double read fSourceMeasuredValue;
//   property TimeValue:double read fTimeValue;
//   property DigitLineType:TKt2450_DigLineTypes read fDigitLineType;
//   property DigitLineTypeDirec:TKt2450_DigLineDirections read fDigitLineDirec;
//   property Meter:TKT2450_Meter read fMeter;
//   property SourceMeter:TKT2450_SourceMeter read fSourceMeter;
//   property SourceDevice:TKT2450_SourceDevice read fSourceDevice;
//   property DisplayState:TKt2450_DisplayState read fDisplayState;
//   property DragonBackTime:double read fDragonBackTime write fDragonBackTime;
//   property ToUseDragonBackTime:boolean read fToUseDragonBackTime write fToUseDragonBackTime;
//   property Imax:double read fImax write fImax;
//   property Imin:double read FImin write FImin;
//   property CurrentValueLimitEnable:boolean read FCurrentValueLimitEnable write FCurrentValueLimitEnable;
//   property SweepWasCreated:boolean read fSweepWasCreated write fSweepWasCreated;
   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string);
//   destructor Destroy; override;
//
//   function Test():boolean;override;
//   procedure ProcessingString(Str:string);override;
//   procedure ResetSetting();
//   procedure MyTraining();
//
//   procedure OutPutChange(toOn:boolean);
//   {вмикає/вимикає вихід приладу}
//   function  IsOutPutOn():boolean;
//
//   procedure SetInterlockStatus(toOn:boolean);
//   function IsInterlockOn():boolean;
//
//   procedure ClearUserScreen();
//   procedure TextToUserScreen(top_text:string='';bottom_text:string='');
//
//   procedure SaveSetup(SlotNumber:TKt2450_SetupMemorySlot);
//   procedure LoadSetup(SlotNumber:TKt2450_SetupMemorySlot);
//   procedure LoadSetupPowerOn(SlotNumber:TKt2450_SetupMemorySlot);
//   procedure UnloadSetupPowerOn();
//   procedure RunningMacroScript(ScriptName:string);
//
//   procedure SetTerminal(Terminal:TKt2450_OutputTerminals);
//   {вихід на передню чи задню панель}
//   function GetTerminal():boolean;
//   {вихід на передню чи задню панель}
//
//   procedure SetSense(MeasureType:TKt2450_Measure;Sense:TKt2450_Sense);
//   {2-зондовий чи 4-зондовий спосіб вимірювання}
//   function GetSense(MeasureType:TKt2450_Measure):boolean;
//   function GetSenses():boolean;
//
//
//   procedure SetOutputOffState(Source:TKt2450_Source;
//                           OutputOffState:TKt_2450_OutputOffState);
//   {перемикання типу виходу джерела,
//   коли воно не ввімкнене входу: нормальний, високоімпедансний тощо}
//   function GetOutputOffState(Source:TKt2450_Source):boolean;
//   function GetOutputOffStates():boolean;
//
//   procedure SetReadBackState(Source:TKt2450_Source;
//                              toOn:boolean);overload;
//   {чи вимірюється те значення, що подається з приладу;
//   якщо ні - то буде використовуватися (в розрахунках, тощо)
//   значення, яке заплановано}
//   procedure SetReadBackState(toOn:boolean);overload;
//   function IsReadBackOn(Source:TKt2450_Source):boolean;overload;
//   function IsReadBackOn():boolean;overload;
//   function GetReadBacks():boolean;
//
//   procedure SetHighCapacitanceState(Source:TKt2450_Source;
//                              toOn:boolean);overload;
//   {встановлюється високоємнісний стан виходу}
//   procedure SetHighCapacitanceState(toOn:boolean);overload;
//   function IsHighCapacitanceOn(Source:TKt2450_Source):boolean;overload;
//   function IsHighCapacitanceOn():boolean;overload;
//   function GetHighCapacitanceStates():boolean;
//
//
//   procedure SetAzeroState(Measure:TKt2450_Measure;
//                              toOn:boolean);overload;
//   {чи перевіряються опорні значення перед кожним виміром}
//   procedure SetAzeroState(toOn:boolean);overload;
//   function IsAzeroStateOn(Measure:TKt2450_Measure):boolean;overload;
//   function IsAzeroStateOn():boolean;overload;
//   function GetAzeroStates():boolean;
//   procedure AzeroOnce();
//   {примусова перевірка опорного значення}
//
//   procedure SetResistanceCompencate(toOn:boolean);
//   {ввімкнення/вимкнення компенсації опору}
//   function IsResistanceCompencateOn():boolean;
//
//   procedure SetVoltageProtection(Level:TKt_2450_VoltageProtection);
//   {встановлення значення захисту від перенапруги}
//   function  GetVoltageProtection():boolean;
//   {запит номеру режиму в TKt_2450_VoltageProtection}
//   function IsVoltageProtectionActive():boolean;
//   {перевірка, чи вімкнувся захист від перенапруги}
//
//   procedure SetVoltageLimit(Value:double=0);
//   {встановлення граничної напруги джерела}
//   procedure SetCurrentLimit(Value:double=0);
//   {встановлення граничного струму джерела}
//   function  GetVoltageLimit():boolean;
//   {запит величини граничної напруги джерела}
//   function  GetCurrentLimit():boolean;
//   {запит величини граничної напруги джерела}
//   function IsVoltageLimitExceeded():boolean;
//   {перевірка, чи була спроба перевищення напруги}
//   function IsCurrentLimitExceeded():boolean;
//   {перевірка, чи була спроба перевищення напруги}
//
//   procedure SetSourceType(SourseType:TKt2450_Source=kt_sVolt);
//   {прилад як джерело напруги чи струму;
//   при цьому вихід виключається OutPut=Off}
//   function GetSourceType():boolean;
//
//   procedure SetMeasureFunction(MeasureFunction:TKt2450_Measure=kt_mCurrent);
//   {прилад вимірює напругу чи струм}
//   function GetMeasureFunction():boolean;
//
//   procedure SetMeasureUnit(Measure:TKt2450_Measure; MeasureUnit:TKt_2450_MeasureUnit);
//   {що буде вимірювати (розраховувати) при реальних вимірах Measure}
//   function GetMeasureUnit(Measure:TKt2450_Measure):boolean;
//   function GetMeasureUnits():boolean;
//
//   procedure SetMeasureTime(Measure:TKt2450_Measure; Value:double);overload;
//   {час на вимірювння []=мс, можливий діапазон - (0,2-200)}
//   procedure SetMeasureTime(Value:double);overload;
//   function GetMeasureTime(Measure:TKt2450_Measure):boolean;overload;
//   function GetMeasureTime():boolean;overload;
//   function GetMeasureTimes():boolean;
//
//   procedure SetDisplayDigitsNumber(Measure:TKt2450_Measure; Number:Kt2450DisplayDigitsNumber);overload;
//   {кількість цифр, що відображаються на екрані,
//     на точність самого вимірювання не впливає}
//   procedure SetDisplayDigitsNumber(Number:Kt2450DisplayDigitsNumber);overload;
//   function GetDisplayDigitsNumber(Measure:TKt2450_Measure):boolean;overload;
//   function GetDisplayDigitsNumber():boolean;overload;
//   function GetDisplayDNs():boolean;
//
//
//   procedure SetMode(Mode:TKt_2450_Mode);
//   function GetDeviceMode():boolean;
//
//   procedure SetSourceVoltageRange(Range:TKt2450VoltageRange=kt_vrAuto);
//   function GetSourceVoltageRange():boolean;
//   procedure SetSourceCurrentRange(Range:TKt2450CurrentRange=kt_crAuto);
//   function GetSourceCurrentRange():boolean;
//   function GetSourceRanges():boolean;
//
//   procedure SetMeasureVoltageRange(Range:TKt2450VoltageRange=kt_vrAuto);
//   function GetMeasureVoltageRange():boolean;
//   procedure SetMeasureCurrentRange(Range:TKt2450CurrentRange=kt_crAuto);
//   function GetMeasureCurrentRange():boolean;
//   function GetMeasureRanges():boolean;
//
//   procedure SetMeasureVoltageLowRange(Range:TKt2450VoltageRange=kt_vr20mV);
//   {якщо встановлено автоматичний пошук діапазону для вимірювань,
//   можна встановити найнижчий діапазон, з якого починатиметься
//   пошук потрібного}
//   function GetMeasureVoltageLowRange():boolean;
//   procedure SetMeasureCurrentLowRange(Range:TKt2450CurrentRange=kt_cr10nA);
//   function GetMeasureCurrentLowRange():boolean;
//   function GetMeasureLowRanges():boolean;
//
//
//   procedure SetSourceValue(Source:TKt2450_Source;
//                            value:double);overload;
//   {значення джерела, воно реально з'явиться
//   лише після включення OutPut, якщо вже
//   включено - з'явиться миттєво}
//   procedure SetSourceValue(value:double);overload;
//   function GetSourceValue(Source:TKt2450_Source):boolean;overload;
//   function GetSourceValue():boolean;overload;
//   function GetSourceValues():boolean;
//
//   procedure SetSourceDelay(Source:TKt2450_Source;
//                            value:double);overload;
//   {час затримки між встановленням значення джерела
//   та початком вимірювання}
//   procedure SetSourceDelay(value:double);overload;
//   function GetSourceDelay(Source:TKt2450_Source):boolean;overload;
//   function GetSourceDelay():boolean;overload;
//   function GetSourceDelays():boolean;
//   procedure SetSourceDelayAuto(Source:TKt2450_Source;
//                            toOn:boolean);overload;
//   {час затримки між встановленням значення джерела
//   та початком вимірювання}
//   procedure SetSourceDelayAuto(toOn:boolean);overload;
//   function IsSourceDelayAutoOn(Source:TKt2450_Source):boolean;overload;
//   function IsSourceDelayAutoOn():boolean;overload;
//   function GetSourceDelayAutoOns():boolean;
//
//   procedure SourceListCreate(Source:TKt2450_Source;ListValues:TArrSingle);overload;
//   {створення списку значень джерела, які будуть використовуватися під час
//   послідовності вимірювань}
//   procedure SourceListCreate(ListValues:TArrSingle);overload;
//   function GetSourceList(Source:TKt2450_Source):boolean;overload;
//   {отримані значення розташовуються в DataVector.X та DataVector.Y}
//   function GetSourceList():boolean;overload;
//   procedure SourceListAppend(Source:TKt2450_Source;ListValues:TArrSingle);overload;
//   {значення додаються до списку значень джерела, які будуть використовуватися під час
//   послідовності вимірювань}
//   procedure SourceListAppend(ListValues:TArrSingle);overload;
//
//   procedure SwepLinearPointCreate();
//   procedure SwepLinearStepCreate();
//   procedure SwepListCreate(StartIndex:word=1);
//   procedure SwepLogStepCreate();
//
//   procedure BufferCreate();overload;
//   procedure BufferCreate(Name:string);overload;
//   procedure BufferCreate(Name:string;Size:integer);overload;
//   procedure BufferCreate(Name:string;Size:integer;Style:TKt2450_BufferStyle);overload;
//   procedure BufferCreate(Style:TKt2450_BufferStyle);overload;
//   procedure BufferDelete();overload;
//   procedure BufferDelete(Name:string);overload;
//   procedure BufferClear();overload;
//   procedure BufferClear(BufName:string);overload;
//
//   procedure BufferReSize(NewSize:integer);overload;
//   {змінює можливу кількість записів у буфері,
//   при цьому він очищується}
//   procedure BufferReSize(BufName:string;NewSize:integer);overload;
//   function BufferGetSize():integer;overload;
//   function BufferGetSize(BufName:string):integer;overload;
//   function BufferGetReadingNumber(BufName:string=Kt2450DefBuffer):integer;
//   {повертає існуючу кількість записів у буфері}
//   function BufferGetStartEndIndex(BufName:string=Kt2450DefBuffer):boolean;
//   {повертає початковий та кінцевий індекси існуючих
//   в буфері записів, якщо все добре вони знаходяться
//   в Buffer.StartIndex та Buffer.EndIndex}
//
//   procedure BufferSetFillMode(FillMode:TKt2450_BufferFillMode);overload;
//   procedure BufferSetFillMode(BufName:string;FillMode:TKt2450_BufferFillMode);overload;
//   function BufferGetFillMode():boolean;overload;
//   function BufferGetFillMode(BufName:string):boolean;overload;
//   Procedure BufferLastDataSimple();overload;
//   {без вимірювання видобувається результат останнього
//   вимірювання, що зберігається у defbuffer1,
//   розміщується в fDevice.Value}
//   Procedure BufferLastDataSimple(BufName:string);overload;
//   {отримання останнього збереженого результату
//   вимірювань з буфера BufName}
//   Procedure BufferLastDataExtended(DataType:TKt2450_ReturnedData=kt_rd_MS;
//                            BufName:string=Kt2450DefBuffer);
//   {як попередні, проте повертає більше даних
//   (див. TKt2450_ReturnedData) щодо останнього виміру}
//   Procedure BufferDataArrayExtended(SIndex,EIndex:integer;
//                     DataType:TKt2450_ReturnedData=kt_rd_MS;
//                     BufName:string=Kt2450DefBuffer);
//   {зчитування з буферу BufName результатів, збережених за
//   індексами в діапазоні від SIndex до EIndex,
//   що саме повертається залежить від DataType,
//   результати вимірювань в DataVector.Y,
//   значення джерела в DataVector.Х,
//   якщо берем час вимірювання, то він в  DataTimeVector.X,
//   а результат виміру в  DataTimeVector.Y,
//   якщо DataType=kt_rd_M, то вимір і в  DataVector.Х}
//   {треба оцінити час передачі}
//
//   procedure SetCount(Cnt:integer);
//   {кількість повторних вимірювань, коли прилад просять поміряти}
//   function GetCount():boolean;
//
//   procedure SetDigLineMode(LineNumber:TKt2450_DigLines;
//                            LineType:TKt2450_DigLineType;
//                            Direction:TKt2450_DigLineDirection);
//   function GetDigLineMode(LineNumber:TKt2450_DigLines):boolean;
//   procedure SetDidLinOut(LineNumber:TKt2450_DigLines;HighLevel:boolean=True);
//   {якщо лінія LineNumber має kt_dt_dig та kt_dd_out, то
//   для неї можна встановили високий чи низький рівні}
//   function GetDidLinOut(LineNumber:TKt2450_DigLines):integer;
//   {якщо лінія LineNumber має kt_dt_dig та kt_dd_in, то
//   для неї можна зчитати значення рівня;
//   Resul=1 якщо високий
//         0 якщо низький
//        -1 якщо не отримали відповідь}
//
//   procedure SetDisplayBrightness(State:TKt2450_DisplayState);
//   function GetDisplayBrightness():boolean;
//
//   procedure Beep(Freq:word=600;Duration:double=0.1);
//   {звук частотою Freq Гц протягом Duration секунд}
//
//   procedure ConfigMeasureCreate(ListName:string=MyMeasList);
//   procedure ConfigSourceCreate(ListName:string=MySourceList);
//   procedure ConfigMeasureDelete(ListName:string=MyMeasList;ItemIndex:word=0);
//   {якщо ItemIndex=0, то видаляється весь список}
//   procedure ConfigSourceDelete(ListName:string=MySourceList;ItemIndex:word=0);
//   procedure ConfigMeasureRecall(ListName:string=MyMeasList;ItemIndex:word=1);
//   {завантаження налаштувань, записаних в ItemIndex;
//   якщо потрібно викликати налаштування і для джерела,
//   і для вимірювача - спочатку завантажувати треба для джерела}
//   procedure ConfigSourceRecall(ListName:string=MySourceList;ItemIndex:word=1);
//   procedure ConfigBothRecall(SourceListName:string=MySourceList;
//                              MeasListName:string=MyMeasList;
//                              SourceItemIndex:word=1;
//                              MeasItemIndex:word=1);
//   procedure ConfigMeasureStore(ListName:string=MyMeasList;ItemIndex:word=0);
//   {запис налаштувань у список;
//   якщо ItemIndex=0, то записується у кінець списку}
//   procedure ConfigSourceStore(ListName:string=MySourceList;ItemIndex:word=0);
//
//   Procedure GetParametersFromDevice;
//
//   Procedure MeasureSimple();overload;
//   {проводиться вимірювання стільки разів, скільки
//   вказано в Count, всі результати розміщуються
//   в defbuffer1, повертається результат останнього виміру;
//   вимірюється та функція, яка зараз встановлена на приладі,
//   можна зробити, щоб вимірювалося щось інше, але я не
//   схотів гратися з такою не дуже реальною на перший погляд
//   задачею}
//   Procedure MeasureSimple(BufName:string);overload;
//   {результати записуються у буфер BufName
//   і з нього ж зчитується останній результат}
//   Procedure MeasureExtended(DataType:TKt2450_ReturnedData=kt_rd_MS;
//                           BufName:string=Kt2450DefBuffer);
//   {як попередні, проте повертає більше даних
//   (див. TKt2450_ReturnedData) щодо останнього виміру}
//
//
//   Procedure Init;
//   Procedure Abort;
//   Procedure Wait;
//   Procedure TrigPause;
//   Procedure TrigResume;
//   Procedure InitWait;
//   Procedure TrigEventGenerate;
//   {generates a trigger event }
//
//   Procedure TrigForIVCreate;
//   Procedure TrigNewCreate;
//   {any blocks that have been defined in the trigger model
//   are cleared so the trigger model has no blocks defined}
//   Procedure TrigBufferClear(BufName:string=Kt2450DefBuffer);
//   Procedure TrigConfigListRecall(ListName:string;Index:integer=1);
//   Procedure TrigConfigListNext(ListName:string);overload;
//   Procedure TrigConfigListNext(ListName1,ListName2:string);overload;
//   Procedure TrigOutPutChange(toOn:boolean);
//   Procedure TrigAlwaysTransition(TransitionBlockNumber:word);
//   Procedure TrigDelay(DelayTime:double);
//   Procedure TrigMeasure(BufName:string=Kt2450DefBuffer;Count:word=1);
//   {при досягненні цього блоку прилад вимірює Count разів,
//   після чого виконується наступний блок;
//   Count=0 може використовуватися для зупинки нескінченних вимірювань
//   - див. далі;
//   результати заносяться в BufName}
//   Procedure TrigMeasureInf(BufName:string=Kt2450DefBuffer);
//   {при досягненні цього блоку прилад починає
//   виміри і виконується наступний блок; виміри продовжуються доти,
//   поки не зустрінеться новий вимірювальний блок чи не буде кінець моделі}
//   Procedure TrigMeasureCountDevice(BufName:string=Kt2450DefBuffer);
//   {при досягненні цього блоку прилад вимірює стільки разів, скільки
//   передбачено попередньо встановленою властивістю Count,
//   після чого виконується наступний блок}
//
//   Procedure TrigMeasureResultTransition(LimitType:TK2450_TrigLimitType;
//                    LimA,LimB:double;TransitionBlockNumber:word;
//                    MeasureBlockNumber:word=0);
//   {якщо вимірювання задовольняє умові, яка передбачена в LimitType,
//   то відбувається перехід на блок TransitionBlockNumber;
//   при MeasureBlockNumber=0 береться до уваги останнє
//   вимірювання, інакше те, яке відбулося в блоці з номером MeasureBlockNumber;
//   якщо задати LimA>LimB, то прилад автоматично їх поміняє місцями
//   умова виконується, якщо результат (MeasureResult)
//   при kt_tlt_above: MeasureResult > LimB
//   kt_tlt_below: MeasureResult < LimA
//   kt_tlt_inside: LimA < MeasureResult < LimB  (про <= не знаю, треба експерементувати)
//   kt_tlt_outside:  MeasureResult не належить [LimA, LimB]
//   }
//   Procedure TrigCounterTransition(TargetCount,TransitionBlockNumber:word);
//   {якщо кількість приходів на цей блок менша TargetCount, то відбувається
//   перехід на блок TransitionBlockNumber}
//   Procedure TrigEventTransition(TransitionBlockNumber:word;
//                                 EventType:TK2450_TriggerEvents=kt_te_comm;
//                                 EventNumber:word=1);
//   {якщо до того, як дійшли на цей блок, відбулася подія EventType,
//   то відбувається перехід на TransitionBlockNumber}

 end;


implementation

uses
  OlegType, Dialogs;

{ TKeitleyDevice }

constructor TKeitleyDevice.Create(SCPInew: TSCPInew; Telnet: TIdTelnet;
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

procedure TKeitleyDevice.UpDate;
begin
// showmessage('recived');
 fSCPI.ProcessingString(fDataSubject.ReceivedString);
 if fValue<>ErResult then
     fIsReceived:=True;
 if TestShowEthernet then showmessage('recived:  '+fDataSubject.ReceivedString);

end;

{ TKeitley }

constructor TKeitley.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
 fTelnet:=Telnet;
 fIPAdressShow:=IPAdressShow;
 inherited Create(Nm);
end;

end.
