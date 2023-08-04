unit Keithley;

interface

uses
  TelnetDevice, SCPI, IdTelnet, ShowTypes, Keitley2450Const, Keitley2450Device, 
  OlegVector, ExtCtrls;

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

TKeitley_Meter=class;

 TKeitley=class(TSCPInew)
  private
   fTerminal:TKeitley_OutputTerminals;
   fDataVector:TVector;
   {X - значення чогось (джерела, номера каналу); Y - результат виміру}
   fDataTimeVector:TVector;
   {X - час виміру (мілісекунди з початку доби); Y - результат виміру}
   fBuffer:TKeitley_Buffer;

   fDisplayState:TKeitley_DisplayState;
   fTrigerState:TKeitley_TriggerState;

   function StringToTerminals(Str:string):boolean;
   function StringToBufferIndexies(Str:string):boolean;
   function StringToDisplayBrightness(Str:string):boolean;
  protected
   fTelnet:TIdTelnet;
   fIPAdressShow: TIPAdressShow;
   fMeasureFunction:TKeitley_Measure;
   fTimeValue:double;
   fTrigBlockNumber:word;
   fCount:integer;
   fMeter:TKeitley_Meter;
   procedure MeterCreate;virtual;abstract;
//   procedure PrepareString;override;
   function GetRootNodeString():string;override;
   procedure PrepareStringByRootNode;override;
   procedure DeviceCreate(Nm:string);override;
   procedure ProcessingStringByRootNode(Str:string);override;
   procedure DefaultSettings;override;
   function StringToMeasureFunction(Str:string):boolean;//virtual;
   function StringToDigMeasureFunction(Str:string):boolean;
   function StringToTrigerState(Str:string):boolean;
   function MeasureToRootNodeNumber(Measure:TKeitley_Measure):byte;
   function MeasureToRootNodeStr(Measure:TKeitley_Measure):string;
   function MeasureToFunctString(Measure:TKeitley_Measure):string;
   procedure StringToMesuredData(Str:string;DataType:TKeitley_ReturnedData);
   procedure AdditionalDataFromString(Str:string);virtual;abstract;
   procedure StringToMesuredDataArray(Str:string;DataType:TKeitley_ReturnedData);
   procedure AdditionalDataToArrayFromString;virtual;abstract;

   function StringToMeasureTime(Str:string):double;
   function GetMeasureFunctionValue:TKeitley_Measure;virtual;
   procedure SetCountNumber(Value:integer);virtual;
   procedure OnOffFromBool(toOn:boolean);
  public
   property DataVector:TVector read fDataVector;
   property DataTimeVector:TVector read fDataTimeVector;
   property MeasureFunction:TKeitley_Measure read GetMeasureFunctionValue;
   property Terminal:TKeitley_OutputTerminals read fTerminal write fTerminal;
   property Buffer:TKeitley_Buffer read fBuffer;
   property Count:integer read fCount write SetCountNumber;
   property TimeValue:double read fTimeValue;
   property Meter:TKeitley_Meter read fMeter;
   property DisplayState:TKeitley_DisplayState read fDisplayState;
   property TrigerState:TKeitley_TriggerState read fTrigerState;
   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string);
   destructor Destroy; override;
//
//   function Test():boolean;override;
//   procedure ProcessingString(Str:string);override;
   procedure ResetSetting();
   procedure MyTraining();virtual;
   procedure ClearUserScreen();
   procedure TextToUserScreen(top_text:string='';bottom_text:string='');

   procedure SaveSetup(SlotNumber:TKeitley_SetupMemorySlot);
   procedure LoadSetup(SlotNumber:TKeitley_SetupMemorySlot);
   procedure LoadSetupPowerOn(SlotNumber:TKeitley_SetupMemorySlot);
   procedure UnloadSetupPowerOn();
   procedure RunningMacroScript(ScriptName:string);

   function GetTerminal():boolean;
//   {вихід на передню чи задню панель}
//
   procedure SetAzeroState(Measure:TKeitley_Measure;
                              toOn:boolean);overload;
   {чи перевіряються опорні значення перед кожним виміром}
   procedure SetAzeroState(toOn:boolean);overload;virtual;
   procedure AzeroOnce();
   {примусова перевірка опорного значення}
   procedure SetMeasureFunction(MeasureFunc:TKeitley_Measure=kt_mCurDC);virtual;
   {що саме буде вимірювати прилад}
   function GetMeasureFunction():boolean;virtual;
    {повертає тип вимірювання, обробка залежить
    від типу приладу}
   procedure SetDisplayDigitsNumber(Measure:TKeitley_Measure; Number:TKeitleyDisplayDigitsNumber);overload;virtual;
   {кількість цифр, що відображаються на екрані,
     на точність самого вимірювання не впливає}
   procedure SetDisplayDigitsNumber(Number:TKeitleyDisplayDigitsNumber);overload;virtual;
   function GetDisplayDigitsNumber(Measure:TKeitley_Measure):boolean;overload;virtual;
   function GetDisplayDigitsNumber():boolean;overload;virtual;
   procedure BufferCreate();overload;
   procedure BufferCreate(Name:string);overload;
   procedure BufferCreate(Name:string;Size:integer);overload;
   procedure BufferCreate(Name:string;Size:integer;Style:TKt2450_BufferStyle);overload;virtual;
   procedure BufferCreate(Style:TKt2450_BufferStyle);overload;virtual;
   procedure BufferDelete();overload;
   procedure BufferDelete(Name:string);overload;
   procedure BufferClear();overload;
   procedure BufferClear(BufName:string);overload;
//
   procedure BufferReSize(NewSize:integer);overload;
   {змінює можливу кількість записів у буфері,
   при цьому він очищується}
   procedure BufferReSize(BufName:string;NewSize:integer);overload;
   function BufferGetSize():integer;overload;
   function BufferGetSize(BufName:string):integer;overload;
   function BufferGetReadingsNumber(BufName:string=KeitleyDefBuffer):integer;
   {повертає існуючу кількість записів у буфері}
   function BufferGetStartEndIndex(BufName:string=KeitleyDefBuffer):boolean;
   {повертає початковий та кінцевий індекси існуючих
   в буфері записів, якщо все добре вони знаходяться
   в Buffer.StartIndex та Buffer.EndIndex}

   procedure BufferSetFillMode(FillMode:TKeitley_BufferFillMode);overload;
   procedure BufferSetFillMode(BufName:string;FillMode:TKeitley_BufferFillMode);overload;
   function BufferGetFillMode():boolean;overload;
   function BufferGetFillMode(BufName:string):boolean;overload;

   Procedure BufferLastDataSimple();overload;
   {без вимірювання видобувається результат останнього
   вимірювання, що зберігається у defbuffer1,
   розміщується в fDevice.Value}
   Procedure BufferLastDataSimple(BufName:string);overload;
   {отримання останнього збереженого результату
   вимірювань з буфера BufName}
   Procedure BufferLastDataExtended(DataType:TKeitley_ReturnedData=kt_rd_MS;
                            BufName:string=KeitleyDefBuffer);
   {як попередні, проте повертає більше даних
   (див. TKeitley_ReturnedData) щодо останнього виміру}
   Procedure BufferDataArrayExtended(SIndex,EIndex:integer;
                     DataType:TKeitley_ReturnedData=kt_rd_MS;
                     BufName:string=KeitleyDefBuffer);
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
   function GetCount:boolean;
   procedure SetDisplayBrightness(State:TKeitley_DisplayState);
   function GetDisplayBrightness():boolean;
//
   procedure Beep(Freq:word=600;Duration:double=0.1);
   {звук частотою Freq Гц протягом Duration секунд}

   procedure ConfigMeasureCreate(ListName:string=MyMeasList);
   procedure ConfigMeasureDelete(ListName:string=MyMeasList;ItemIndex:word=0);
   {якщо ItemIndex=0, то видаляється весь список}
   procedure ConfigMeasureRecall(ListName:string=MyMeasList;ItemIndex:word=1);
   {завантаження налаштувань, записаних в ItemIndex;
   якщо потрібно викликати налаштування і для джерела,
   і для вимірювача - спочатку завантажувати треба для джерела}
   procedure ConfigMeasureStore(ListName:string=MyMeasList;ItemIndex:word=0);
   {запис налаштувань у список;
   якщо ItemIndex=0, то записується у кінець списку}

   Procedure GetParametersFromDevice;virtual;
//
   Procedure MeasureSimple();overload;virtual;
   {проводиться вимірювання стільки разів, скільки
   вказано в Count, всі результати розміщуються
   в defbuffer1, повертається результат останнього виміру;
   вимірюється та функція, яка зараз встановлена на приладі,
   можна зробити, щоб вимірювалося щось інше, але я не
   схотів гратися з такою не дуже реальною на перший погляд
   задачею}
   Procedure MeasureSimple(BufName:string);overload;virtual;
   {результати записуються у буфер BufName
   і з нього ж зчитується останній результат}
   Procedure MeasureExtended(DataType:TKeitley_ReturnedData=kt_rd_MS;
                           BufName:string=KeitleyDefBuffer);
   {як попередні, проте повертає більше даних
   (див. TKt2450_ReturnedData) щодо останнього виміру}
//
//
   Procedure Init;
   Procedure Abort;
   Procedure Wait;
   Procedure TrigPause;
   Procedure TrigResume;
   Procedure InitWait;
   Procedure TrigEventGenerate;
   {generates a trigger event }

   Procedure TrigNewCreate;
   {any blocks that have been defined in the trigger model
   are cleared so the trigger model has no blocks defined}
   Procedure TrigBufferClear(BufName:string=KeitleyDefBuffer);
   Procedure TrigConfigListRecall(ListName:string;Index:integer=1);
   Procedure TrigConfigListNext(ListName:string);overload;
   Procedure TrigConfigListNext(ListName1,ListName2:string);overload;
   Procedure TrigAlwaysTransition(TransitionBlockNumber:word);
   Procedure TrigDelay(DelayTime:double);
   Procedure TrigMeasure(BufName:string=KeitleyDefBuffer;Count:word=1);
   {при досягненні цього блоку прилад вимірює Count разів,
   після чого виконується наступний блок;
   Count=0 може використовуватися для зупинки нескінченних вимірювань
   - див. далі;
   результати заносяться в BufName}
   Procedure TrigMeasureInf(BufName:string=KeitleyDefBuffer);
   {при досягненні цього блоку прилад починає
   виміри і виконується наступний блок; виміри продовжуються доти,
   поки не зустрінеться новий вимірювальний блок чи не буде кінець моделі}
   Procedure TrigMeasureCountDevice(BufName:string=KeitleyDefBuffer);
   {при досягненні цього блоку прилад вимірює стільки разів, скільки
   передбачено попередньо встановленою властивістю Count,
   після чого виконується наступний блок}

   Procedure TrigMeasureResultTransition(LimitType:TKeitley_TrigLimitType;
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
                                 EventType:TKeitley_TriggerEvents=kt_te_comm;
                                 EventNumber:word=1);
   {якщо до того, як дійшли на цей блок, відбулася подія EventType,
   то відбувається перехід на TransitionBlockNumber}
   function GetTrigerState:boolean;
 end;

TKeitley_Measurement=class(TMeasurementSimple)
 private
//  fParentModule: TKeitley;
 protected
  fParentModule: TKeitley;
  procedure GetDataPreparationHeader;virtual;
  procedure GetDataPreparation;virtual;
 public
  property ParentModule: TKeitley read fParentModule;
  constructor Create(Keitley:TKeitley);
  function GetData:double;override;
  function GetValueFromDevice:double;virtual;
end;

TKeitley_Meter=class(TKeitley_Measurement)
 private
  fTimer:TTimer;
 protected
  function GetMeasureModeLabel():string;virtual;
 public
  property MeasureModeLabel:string read GetMeasureModeLabel;
  property Timer:TTimer read fTimer;
  constructor Create(Keitley:TKeitley);
  destructor Destroy; override;
end;

implementation

uses
  OlegType, Dialogs, SysUtils, StrUtils, OlegFunction, Math;

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
 fIsReceived:=True;
 fSCPI.ProcessingString(fDataSubject.ReceivedString);
// if fValue<>ErResult then
//     fIsReceived:=True;
 if TestShowEthernet then showmessage('recived:  '+fDataSubject.ReceivedString);

end;

{ TKeitley }

procedure TKeitley.Abort;
begin
//:ABOR
 SetupOperation(18,0,0,False);
end;

procedure TKeitley.AzeroOnce;
begin
//:AZERo:ONCE
 SetupOperation(16,0,0,False);
end;

procedure TKeitley.Beep(Freq: word; Duration: double);
begin
//:SYST:BEEP <frequency>, <duration>
fAdditionalString:=IntToStr(NumberMap(Freq,Keitley_BeepFrequancyLimits))
                   +PartDelimiter
                   +floattostr(NumberMap(Duration,Keitley_BeepDurationLimits));
 SetupOperation(7,34);
end;

procedure TKeitley.BufferCreate(Name: string);
begin
 Buffer.SetName(Name);
 BufferCreate;
end;

procedure TKeitley.BufferCreate;
begin
 fAdditionalString:=Buffer.CreateStr;
 SetupOperation(19,29);
end;

procedure TKeitley.BufferCreate(Name: string; Size: integer);
begin
 Buffer.CountMax:=Size;
 BufferCreate(Name);
end;

procedure TKeitley.BufferClear;
begin
  fAdditionalString:=Buffer.Name;
  SetupOperation(19,3);
end;

procedure TKeitley.BufferClear(BufName: string);
begin
//:TRAC:CLE "<bufferName>"
 Buffer.SetName(BufName);
 BufferClear;
// fAdditionalString:=Buffer.Name;
// SetupOperation(19,3);
end;

procedure TKeitley.BufferCreate(Style: TKt2450_BufferStyle);
begin
 Buffer.Style:=Style;
 BufferCreate();
end;

procedure TKeitley.BufferDelete;
begin
 fAdditionalString:=Buffer.Name;
 SetupOperation(19,21);
end;

procedure TKeitley.BufferDataArrayExtended(SIndex, EIndex: integer;
  DataType: TKeitley_ReturnedData; BufName: string);
begin
// :TRAC:DATA? <startIndex>, <endIndex>, "<bufferName>", <bufferElements>
 DataVector.Clear;
 DataTimeVector.Clear;
 Buffer.SetName(BufName);
 Buffer.StartIndex:=SIndex;
 Buffer.EndIndex:=EIndex;
 QuireOperation(19,33,ord(DataType),False);
end;

procedure TKeitley.BufferDelete(Name: string);
begin
// :TRAC:DEL "testData"
 Buffer.SetName(Name);
 BufferDelete();
end;

function TKeitley.BufferGetSize: integer;
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

function TKeitley.BufferGetFillMode: boolean;
begin
  QuireOperation(19,32,1,False);
  Result:=(fDevice.Value<>ErResult);
end;

function TKeitley.BufferGetFillMode(BufName: string): boolean;
begin
// :TRAC:FILL:MODE? "<bufferName>"
 Buffer.SetName(BufName);
 Result:=BufferGetFillMode();
end;

function TKeitley.BufferGetReadingsNumber(BufName: string): integer;
begin
// :TRAC:ACT? "<bufferName>"
 if BufName=KeitleyDefBuffer
      then QuireOperation(19,35)
      else begin
           Buffer.SetName(BufName);
           QuireOperation(19,35,1,False);
           end;
 if fDevice.isReceived
    then Result:=round(fDevice.Value)
    else Result:=-1;
end;

function TKeitley.BufferGetSize(BufName: string): integer;
begin
// :TRAC:POIN? "<bufferName>"
 Buffer.SetName(BufName);
 Result:=BufferGetSize();
end;

function TKeitley.BufferGetStartEndIndex(BufName: string): boolean;
begin
 Buffer.SetName(BufName);
 QuireOperation(19,35,2,False);
 Result:=(fDevice.Value=1);
end;

procedure TKeitley.BufferLastDataSimple;
begin
  QuireOperation(22);
end;

procedure TKeitley.BufferLastDataExtended(DataType: TKeitley_ReturnedData;
  BufName: string);
begin
 // :FETC? "<bufferName>", <bufferElements>
 Buffer.SetName(BufName);
 QuireOperation(22,ord(DataType)+2,0,False);
end;

procedure TKeitley.BufferLastDataSimple(BufName: string);
begin
 Buffer.SetName(BufName);
 QuireOperation(22,1,0,False);
end;

procedure TKeitley.BufferReSize(NewSize: integer);
begin
 Buffer.CountMax:=NewSize;
 SetupOperation(19,31);
end;

procedure TKeitley.BufferReSize(BufName: string; NewSize: integer);
begin
// :TRAC:POIN <newSize>, "<bufferName>"
 Buffer.SetName(BufName);
 BufferReSize(NewSize);
end;

procedure TKeitley.BufferSetFillMode(FillMode: TKeitley_BufferFillMode);
begin
 Buffer.FillMode:=FillMode;
 SetupOperation(19,32);
end;

procedure TKeitley.BufferSetFillMode(BufName: string;
  FillMode: TKeitley_BufferFillMode);
begin
// :TRACe:FILL:MODE ONCE|CONT, "<bufferName>"
 Buffer.SetName(BufName);
 BufferSetFillMode(FillMode);
end;

procedure TKeitley.BufferCreate(Name: string; Size: integer;
  Style: TKt2450_BufferStyle);
begin
// :TRAC:MAKE "<bufferName>", <bufferSize>, <bufferStyle>
 Buffer.Style:=Style;
 BufferCreate(Name,Size);
end;

procedure TKeitley.ClearUserScreen;
begin
// :DISP:CLE
 SetupOperation(6,3,0,false);
end;

procedure TKeitley.ConfigMeasureCreate(ListName: string);
begin
//:CONF:LIST:CRE "<name>"
 fAdditionalString:=StringToInvertedCommas(ListName);
 SetupOperation(24,23,0);
end;

procedure TKeitley.ConfigMeasureDelete(ListName: string; ItemIndex: word);
begin
//:CONF:LIST:DEL "<name>", <index>
 fAdditionalString:=StringToInvertedCommas(ListName);
 if ItemIndex<>0 then fAdditionalString:=fAdditionalString+PartDelimiter+
                                         IntToStr(ItemIndex);
 SetupOperation(24,23,1);
end;

procedure TKeitley.ConfigMeasureRecall(ListName: string; ItemIndex: word);
begin
//:CONF:LIST:REC "<name>", <index>
 fAdditionalString:=StringToInvertedCommas(ListName)+PartDelimiter
                    +IntToStr(max(ItemIndex,1));
 SetupOperation(24,23,2);
end;

procedure TKeitley.ConfigMeasureStore(ListName: string; ItemIndex: word);
begin
//:CONF:LIST:STOR "<name>", <index>
 fAdditionalString:=StringToInvertedCommas(ListName);
 if ItemIndex<>0 then fAdditionalString:=fAdditionalString+PartDelimiter+
                                         IntToStr(ItemIndex);
 SetupOperation(24,23,3);
end;

constructor TKeitley.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
 fTelnet:=Telnet;
 fIPAdressShow:=IPAdressShow;
 inherited Create(Nm);
 fBuffer:=TKeitley_Buffer.Create;
 fDataVector:=TVector.Create;
 fDataTimeVector:=TVector.Create;
 MeterCreate;
end;

procedure TKeitley.DefaultSettings;
// var i:integer;
begin
// fIsTripped:=False;
// fSourceType:=kt_sVolt;
//  fMeasureFunction:=kt_mVolDC;
// fVoltageProtection:=kt_vpnone;
// fVoltageLimit:=Kt_2450_VoltageLimDef;
// fCurrentLimit:=Kt_2450_CurrentLimDef;
 fTerminal:=kt_otFront;
// fOutPutOn:=False;
// for I := ord(Low(TKt2450_Measure)) to ord(High(TKt2450_Measure)) do
//   begin
//   fSences[TKt2450_Measure(i)]:=kt_s2wire;
//   fMeasureUnits[TKt2450_Measure(i)]:=kt_mu_amp;
//   fResistanceCompencateOn[TKt2450_Measure(i)]:=False;
//   fAzeroState[TKt2450_Measure(i)]:=True;
//   fMeasureTime[TKt2450_Measure(i)]:=1;
//   fDisplayDN[TKt2450_Measure(i)]:=5;
//   end;
// for I := ord(Low(TKt2450_Source)) to ord(High(TKt2450_Source)) do
//   begin
//   fReadBack[TKt2450_Source(i)]:=True;
//   fSourceDelay[TKt2450_Source(i)]:=0;
//   fSourceDelayAuto[TKt2450_Source(i)]:=True;
//   SweepParameters[TKt2450_Source(i)]:=TKt_2450_SweepParameters.Create(TKt2450_Source(i));
//   fSourceValue[TKt2450_Source(i)]:=0;
//   fHighCapacitance[TKt2450_Source(i)]:=False;
//   end;
// for I := ord(Low(TKt2450_Source)) to ord(High(TKt2450_Source)) do
//   fOutputOffState[TKt2450_Source(i)]:=kt_oos_norm;
// fMode:=ModeDetermination();
// fSourceVoltageRange:=kt_vrAuto;
// fSourceCurrentRange:=kt_crAuto;
// fMeasureVoltageRange:=kt_vrAuto;
// fMeasureCurrentRange:=kt_crAuto;
// fMeasureVoltageLowRange:=kt_vr20mV;
// fMeasureCurrentLowRange:=kt_cr10nA;
// fCount:=1;
//
// fDataVector:=TVector.Create;
// fDataTimeVector:=TVector.Create;
// fSourceMeasuredValue:=ErResult;
 fTimeValue:=ErResult;
//
// for I := Low(TKt2450_DigLines) to High(TKt2450_DigLines) do
//   begin
//   fDigitLineType[i]:=kt_dt_dig;
//   fDigitLineDirec[i]:=kt_dd_in;
//   end;
// fDLActive:=1;

 fDisplayState:=kt_ds_on25;
 fTrigBlockNumber:=1;
// fSweepWasCreated:=False;
 fTrigerState:=kt_ts_empty;

end;

destructor TKeitley.Destroy;
begin
  FreeAndNil(fMeter);
  FreeAndNil(fDataVector);
  FreeAndNil(fDataTimeVector);  
  FreeAndNil(fBuffer);
  inherited;
end;

procedure TKeitley.DeviceCreate(Nm: string);
begin
  fDevice:=TKeitleyDevice.Create(Self,fTelnet,fIPAdressShow,Nm);
end;

function TKeitley.GetCount: boolean;
begin
 QuireOperation(20);
 Result:=fDevice.isReceived;
 if Result then Count:=round(fDevice.Value);
end;

function TKeitley.GetDisplayBrightness: boolean;
begin
 QuireOperation(6,230);
 Result:=(fDevice.Value<>ErResult);
end;

function TKeitley.GetDisplayDigitsNumber(Measure: TKeitley_Measure): boolean;
begin
 QuireOperation(6,MeasureToRootNodeNumber(Measure),28);
 Result:=(round(fDevice.Value)>=Low(TKeitleyDisplayDigitsNumber))
         and(round(fDevice.Value)<=High(TKeitleyDisplayDigitsNumber));
//
//
// try
//  fDisplayDN[Measure]:=round(fDevice.Value);
//  result:=True;
// except
//  Result:=False;
// end;
end;

function TKeitley.GetDisplayDigitsNumber: boolean;
begin
  Result:=GetDisplayDigitsNumber(MeasureFunction);
end;

function TKeitley.GetMeasureFunction: boolean;
begin
// :FUNC?
 QuireOperation(15);
 if (fDevice.Value>ord(kt_mVoltRat))and(fDevice.Value<>ErResult)
   then QuireOperation(23,15);

 Result:=(fDevice.Value<>ErResult);
end;

function TKeitley.GetMeasureFunctionValue: TKeitley_Measure;
begin
 Result:=fMeasureFunction;
end;

procedure TKeitley.GetParametersFromDevice;
begin
// if not(GetVoltageProtection()) then Exit;
// if not(GetVoltageLimit()) then Exit;
// if not(GetCurrentLimit()) then Exit;
if not(GetMeasureFunction()) then Exit;
// if not(IsResistanceCompencateOn()) then Exit;  //має бути після GetMeasureFunction
//
 if not(GetTerminal()) then Exit;
// if not(IsOutPutOn()) then Exit;
// if not(GetSenses()) then Exit;
// if not(GetOutputOffStates()) then Exit;
// if not(GetMeasureUnits()) then Exit; //GetDeviceMode
// fMode:=ModeDetermination();
// if not(GetReadBacks()) then Exit;
// if not(GetSourceRanges()) then Exit;
// if not(GetMeasureRanges()) then Exit;
// if not(GetMeasureLowRanges()) then Exit;
// if not(GetAzeroStates()) then Exit;
// if not(GetSourceDelays()) then Exit;
// if not(GetSourceDelayAutoOns()) then Exit;
// if not(GetSourceValues()) then Exit;
// if not(GetMeasureTimes()) then Exit;
// if not(GetHighCapacitanceStates()) then Exit;
// if not(GetDisplayDNs()) then Exit;
 if not(GetCount()) then Exit;
 if not(GetDisplayBrightness()) then Exit;
end;

function TKeitley.GetRootNodeString: string;
begin
 Result:=RootNodeKeitley[fRootNode]
end;

function TKeitley.GetTerminal: boolean;
begin
 QuireOperation(9,6);
 Result:=(fDevice.Value<>ErResult);
end;

function TKeitley.GetTrigerState: boolean;
begin
//:TRIG:STAT?
 QuireOperation(26,3);
 Result:=(fDevice.Value<>ErResult);
end;

procedure TKeitley.Init;
begin
// INIT
 SetupOperation(17,0,0,False);
end;

procedure TKeitley.InitWait;
begin
// INIT; *WAI
 fAdditionalString:=CommandDelimiter+RootNodeKeitley[25];
 SetupOperation(17,1,0,False);
end;

procedure TKeitley.LoadSetup(SlotNumber: TKeitley_SetupMemorySlot);
begin
// *RCL <n>
 fAdditionalString:=inttostr(SlotNumber);
 SetupOperation(1);
end;

procedure TKeitley.LoadSetupPowerOn(SlotNumber: TKeitley_SetupMemorySlot);
begin
//  SYST:POS SAV1
  fAdditionalString:='sav'+inttostr(SlotNumber);
  SetupOperation(7,4);
end;

procedure TKeitley.MeasureSimple;
begin
// :READ?
 QuireOperation(21);
end;

procedure TKeitley.MeasureExtended(DataType: TKeitley_ReturnedData;
  BufName: string);
begin
// :READ? "<bufferName>", <bufferElements>
 Buffer.SetName(BufName);
 QuireOperation(21,ord(DataType)+2,0,False);
end;

procedure TKeitley.MeasureSimple(BufName: string);
begin
 Buffer.SetName(BufName);
 QuireOperation(21,1,0,False);
end;


function TKeitley.MeasureToFunctString(Measure: TKeitley_Measure): string;
begin
 if Measure<kt_mDigCur
   then Result:=StringToInvertedCommas(DeleteSubstring(MeasureToRootNodeStr(Measure)))
   else Result:=StringToInvertedCommas(DeleteSubstring(RootNodeKeitley[ord(Measure)-1]));
end;

function TKeitley.MeasureToRootNodeNumber(Measure: TKeitley_Measure): byte;
begin
 case Measure of
   kt_mCurDC..kt_mRes2W:Result:=ord(Measure)+12;
   else Result:=ord(Measure)+25;
 end;
end;

function TKeitley.MeasureToRootNodeStr(Measure: TKeitley_Measure): string;
begin
 Result:=RootNodeKeitley[MeasureToRootNodeNumber(Measure)];
end;

procedure TKeitley.MyTraining;
begin
end;

procedure TKeitley.OnOffFromBool(toOn: boolean);
begin
 if toOn then fAdditionalString:=SuffixKt_2450[0]
         else fAdditionalString:=SuffixKt_2450[1];
end;

//procedure TKeitley.PrepareString;
//begin
// (fDevice as TKeitleyDevice).ClearStringToSend;
// (fDevice as TKeitleyDevice).SetStringToSend(RootNodeKeitley[fRootNode]);
//
// PrepareStringByRootNode;
//
// if fIsSuffix then JoinAddString;
//end;

procedure TKeitley.PrepareStringByRootNode;
begin
 case fRootNode of
//  5:case fFirstLevelNode of
//     5: JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//     0..1:begin
//           JoinToStringToSend(RootNoodKt_2450[12+fFirstLevelNode]);
//           JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
//          end;
//    end;  // fRootNode=5
  6:case fFirstLevelNode of
     0..3:JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
     230: JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode-200]);
     12..14,28..39:
        begin
        JoinToStringToSend(RootNodeKeitley[fFirstLevelNode]);
        JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
        end;
      else JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
     end;  // fRootNode=6
  7,9:JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//  11:case fFirstLevelNode of
//       12..13:case fLeafNode of
//                0:JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
//                else
//                   begin
//                    JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
//                    JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
//                    if fIsTripped then JoinToStringToSend(FirstNodeKt_2450[11]);
//                   end;
//              end;
//       155:JoinToStringToSend(RootNoodKt_2450[15]);
//       23:case fLeafNode of
//             179,180:begin
//                   JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//                   JoinToStringToSend(RootNoodKt_2450[fLeafNode-79+12]);
//                   JoinToStringToSend(FirstNodeKt_2450[24]);
//                   end;
//             else
//                 begin
//                 JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//                 JoinToStringToSend(RootNoodKt_2450[fLeafNode]);
//                 end;
//          end;
//        24:begin
//            JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
//            JoinToStringToSend(FirstNodeKt_2450[23]);
//            JoinToStringToSend(ConfLeafNodeKt_2450[fLeafNode]);
//           end;
//        25:begin
//            JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//            case fLeafNode of
//              1:JoinToStringToSend(SweepParameters[fSourceType].Lin);
//              2:JoinToStringToSend(SweepParameters[fSourceType].LinStep);
//              3:JoinToStringToSend(SweepParameters[fSourceType].List);
//              4:JoinToStringToSend(SweepParameters[fSourceType].Log);
//            end;
//           end;
//     end;// fRootNode=11
  12..14,28..39:
//       begin
         JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//         case fLeafNode of
//          18,19:JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
//         end;
//       end; // fRootNode=12..14
  17:if fFirstLevelNode=1 then JoinToStringToSend(fAdditionalString);
  19:begin
       JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
       case fFirstLevelNode of
        31:if fLeafNode=1 then JoinToStringToSend(Buffer.Get)
                           else fAdditionalString:=Buffer.ReSize;
        32:if fLeafNode=1 then JoinToStringToSend(Buffer.Get)
                           else fAdditionalString:=Buffer.FillModeChange;
//        33:JoinToStringToSend(Buffer.DataDemandArray(TKeitley_ReturnedData(fLeafNode)));
        35:case fLeafNode of
            1:JoinToStringToSend(Buffer.Get);
            2:JoinToStringToSend(Buffer.LimitIndexies)
           end;
       end;
      end; // fRootNode=19
  21:case fFirstLevelNode of
       1:JoinToStringToSend(Buffer.Get);
//       2..5:JoinToStringToSend(Buffer.DataDemand(TKeitley_ReturnedData(fFirstLevelNode-2)))
     end; // fRootNode=21
  22:case fFirstLevelNode of
       1:JoinToStringToSend(Buffer.Get);
     end; // fRootNode=22
  23:case fFirstLevelNode of
          15,20:JoinToStringToSend (RootNodeKeitley[fFirstLevelNode]);
//        36,37:JoinToStringToSend(AnsiReplaceStr(FirstNodeKt_2450[fFirstLevelNode],'#',inttostr(fDLActive)));
     end; // fRootNode=23
  24:begin
        JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
        JoinToStringToSend(ConfLeafNodeKeitley[fLeafNode]);
     end; // fRootNode=24
  26:case fFirstLevelNode of
        3:JoinToStringToSend(TrigLeafNodeKeitley[fFirstLevelNode]);
        44,43,38:JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
        40,41,21:begin
            JoinToStringToSend(FirstNodeKt_2450[39]);
            JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
            JoinToStringToSend(TrigLeafNodeKeitley[fLeafNode]);
            fAdditionalString:=IntTostr(fTrigBlockNumber)+PartDelimiter+fAdditionalString;
            inc(fTrigBlockNumber);
           end;
        24,11:begin
            JoinToStringToSend(FirstNodeKt_2450[39]);
            JoinToStringToSend(RootNodeKeitley[fFirstLevelNode]);
            JoinToStringToSend(TrigLeafNodeKeitley[fLeafNode]);
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

end;

//procedure TKeitley.ProcessingString(Str: string);
//begin
// Str:=Trim(Str);
// ProcessingStringByRootNode(Str);
//end;

procedure TKeitley.ProcessingStringByRootNode(Str:string);
begin
 case fRootNode of
//  0:if pos(Kt_2450_Test,Str)<>0 then fDevice.Value:=314;
//  5:case fFirstLevelNode of
//     5,155:fDevice.Value:=StrToInt(Str);
//     0..1:begin
//          if StringToOutPutState(AnsiLowerCase(Str))
//            then fDevice.Value:=ord(fOutputOffState[TKt2450_Source(fFirstLevelNode)]);
//          end;
//    end; //fRootNode=5
  6:if fFirstLevelNode=230
       then
        begin
        if StringToDisplayBrightness(AnsiLowerCase(Str))
            then fDevice.Value:=ord(fDisplayState);

        end
       else fDevice.Value:=StrToInt(Str);
  9:case fFirstLevelNode of
    6:if StringToTerminals(AnsiLowerCase(Str))
          then fDevice.Value:=ord(fTerminal);
    end;
//  11:case fFirstLevelNode of
//        23:begin
//           StringToArray(Str);
//           if fDataVector.Count>0 then fDevice.Value:=1;
//           end;
//        else
//           case fLeafNode of
//            10:if StringToVoltageProtection(AnsiLowerCase(Str),fVoltageProtection)
//                then fDevice.Value:=ord(fVoltageProtection);
//            0,12..13,15,21:fDevice.Value:=SCPI_StringToValue(Str);
//            155:if StringToSourceType(AnsiLowerCase(Str)) then fDevice.Value:=ord(fSourceType);
//            16,17,22,27:fDevice.Value:=StrToInt(Str);
//           end;
//     end; //fRootNode=11
   12..14,
   28..39:case fFirstLevelNode of
             47,49:fDevice.Value:=StrToInt(Str);
             48,26,51:fDevice.Value:=SCPI_StringToValue(Str);
//             7: fDevice.Value:=StrToInt(Str);
//             14: if StringToMeasureUnit(AnsiLowerCase(Str))
//                    then fDevice.Value:=ord(fMeasureUnits[TKt2450_Measure(fFirstLevelNode-12)]);
//             {16,}15:fDevice.Value:=SCPI_StringToValue(Str);
          end;   //fRootNode=12..14,28..39
   15:StringToMeasureFunction(AnsiLowerCase(Str));
   19:case fFirstLevelNode of
          31: fDevice.Value:=StrToInt(Str);
          32:if Buffer.StringToFillMode(AnsiLowerCase(Str))
                then fDevice.Value:=ord(TKeitley_BufferFillMode(Buffer.FillMode));
          33:StringToMesuredDataArray(AnsiReplaceStr(Str,',',' '),TKeitley_ReturnedData(fLeafNode));
          35:case fLeafNode of
              0,1:fDevice.Value:=StrToInt(Str);
              2:if StringToBufferIndexies(Str) then fDevice.Value:=1;
             end;
      end; //fRootNode=19
   20:fDevice.Value:=StrToInt(Str);
   21:case fFirstLevelNode of
       0,1:fDevice.Value:=SCPI_StringToValue(Str);
       2..5:StringToMesuredData(AnsiReplaceStr(Str,',',' '),TKeitley_ReturnedData(fFirstLevelNode-2));
       end; //fRootNode=21
   22:case fFirstLevelNode of
       0,1:fDevice.Value:=SCPI_StringToValue(Str);
       2..5:StringToMesuredData(AnsiReplaceStr(Str,',',' '),TKeitley_ReturnedData(fFirstLevelNode-2));
      end;  //fRootNode=22
   23:case fFirstLevelNode of
        15:StringToDigMeasureFunction(AnsiLowerCase(Str));
        20:fDevice.Value:=StrToInt(Str);
//       36:StringToDigLineStatus(AnsiLowerCase(Str));
//       37:fDevice.Value:=StrToInt(Str);
      end;
   26:case fFirstLevelNode of
       3:StringToTrigerState(AnsiLowerCase(Str));
      end;
 end;
end;

procedure TKeitley.ResetSetting;
begin
//  *RST
  SetupOperation(2,0,0,False);
end;

procedure TKeitley.RunningMacroScript(ScriptName: string);
begin
//  SCR:RUN "ScriptName"
  fAdditionalString:=StringToInvertedCommas(ScriptName);
  SetupOperation(8);
end;

procedure TKeitley.SaveSetup(SlotNumber: TKeitley_SetupMemorySlot);
begin
// *SAV <n>
 fAdditionalString:=inttostr(SlotNumber);
 SetupOperation(3);
end;

procedure TKeitley.SetAzeroState(Measure: TKeitley_Measure; toOn: boolean);
begin
//<function>:AZER OFF ON|OFF
 if Measure in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
      kt_mRes4W,kt_mDiod,kt_mTemp,kt_mVoltRat] then
 begin
   OnOffFromBool(toOn);
   SetupOperation(MeasureToRootNodeNumber(Measure),20);
 end;
end;

procedure TKeitley.SetAzeroState(toOn: boolean);
begin
 SetAzeroState(fMeasureFunction,toOn);
end;

procedure TKeitley.SetCount(Cnt: integer);
begin
// :COUN <n>
 Count:=Cnt;
 fAdditionalString:=IntToStr(Count);
 SetupOperation(20);
end;


procedure TKeitley.SetCountNumber(Value: integer);
 const CountLimits:TLimitValues=(1,300000);
begin
 fCount:=NumberMap(Value,CountLimits);
end;

procedure TKeitley.SetDisplayBrightness(State: TKeitley_DisplayState);
begin
//:DISP:LIGH:STAT <brightness>
 fDisplayState:=State;
 fAdditionalString:=Keitley_DisplayStateCommand[State];
 SetupOperation(6,230)
end;

procedure TKeitley.SetDisplayDigitsNumber(Measure: TKeitley_Measure;
  Number: TKeitleyDisplayDigitsNumber);
begin
//:DISP:CURR|VOLT|RES:DIG n
 fAdditionalString:=inttostr(Number);
 SetupOperation(6,MeasureToRootNodeNumber(Measure),28);
// fDisplayDN[Measure]:=Number;
end;

procedure TKeitley.SetDisplayDigitsNumber(Number: TKeitleyDisplayDigitsNumber);
begin
 SetDisplayDigitsNumber(fMeasureFunction,Number);
end;

procedure TKeitley.SetMeasureFunction(MeasureFunc: TKeitley_Measure);
begin
 fAdditionalString:=MeasureToFunctString(MeasureFunc);
 if MeasureFunc>kt_mVoltRat
//:DIG:FUNC "VOLT"|"CURR"
   then SetupOperation(23,15)
// :FUNC "VOLT"|"CURR"
   else SetupOperation(15);
 fMeasureFunction:=MeasureFunc;
end;

function TKeitley.StringToBufferIndexies(Str: string): boolean;
begin
 Str:=AnsiReplaceStr(Str,';',' ');
 Buffer.StartIndex:=round(FloatDataFromRow(Str,1));
 Buffer.EndIndex:=round(FloatDataFromRow(Str,2));
 Result:=(Buffer.StartIndex<>ErResult)and(Buffer.EndIndex<>ErResult);
end;

function TKeitley.StringToDigMeasureFunction(Str: string): boolean;
  var i:TKeitley_Measure;
begin
// Result:=False;
 for I := kt_mDigCur to kt_mDigVolt do
   begin
    Result:=pos(DeleteSubstring(RootNodeKeitley[ord(i)-1]),Str)<>0;
    if Result then
      begin
       fMeasureFunction:=i;
       fDevice.Value:=ord(fMeasureFunction);
       Break;
      end;
   end;
end;

function TKeitley.StringToDisplayBrightness(Str: string): boolean;
  var i:TKeitley_DisplayState;
begin
 Result:=False;
 for I := Low(TKeitley_DisplayState) to High(TKeitley_DisplayState) do
  begin
   if Str=Keitley_DisplayStateCommand[i] then
     begin
       fDisplayState:=i;
       Result:=True;
       Break;
     end;
  end;
end;

function TKeitley.StringToMeasureFunction(Str: string): boolean;
  var i:TKeitley_Measure;
      dodanok:integer;
begin
 Result:=False;
 dodanok:=0;
 for I := High(TKeitley_Measure) downto Low(TKeitley_Measure) do
   begin
    case i of
      kt_mCurDC..
       kt_mVoltRat: Result:=pos(DeleteSubstring(MeasureToRootNodeStr(i)),Str)<>0;
      kt_mDigCur..
      kt_mDigVolt:begin
                   if (pos('none',Str)<>0) then Result:=True;
                   if (pos('curr:dig',Str)<>0)
                       or(pos('volt:dig',Str)<>0)  then
                         begin
                          Result:=True;
                          dodanok:=3;
                         end;
                  end;

//      kt_mDigCur:Result:=(pos('none',Str)<>0)
//                           or(pos(':curr:dig',Str)<>0);
//      kt_mDigVolt:Result:=(pos('none',Str)<>0)
//                           or(pos(':volt:dig',Str)<>0);
//        begin
//        showmessage(Str+'  '+DeleteSubstring(MeasureToRootNodeStr(i)));
//        Result:=(pos('none',Str)<>0)
//                           or(pos(DeleteSubstring(MeasureToRootNodeStr(i)),Str)<>0);
//        showmessage('Result='+booltostr(Result,True));
//        end;
    end;
    if Result then
      begin
       fMeasureFunction:=i;
       fDevice.Value:=ord(fMeasureFunction)-dodanok;
//       showmessage('jjj '+Keitley_MeasureLabel[fMeasureFunction]);
       Break;
      end;
   end;
end;

function TKeitley.StringToMeasureTime(Str: string): double;
begin
 Str:=AnsiReplaceStr(Str,':',' ');
 Result:=(FloatDataFromRow(Str,4)+FloatDataFromRow(Str,3)
         +60*FloatDataFromRow(Str,2)+3600*FloatDataFromRow(Str,1))*1e3;
end;

procedure TKeitley.StringToMesuredData(Str: string;
  DataType: TKeitley_ReturnedData);
begin
// showmessage(STR);
 fDevice.Value:=FloatDataFromRow(Str,1);
 if (fDevice.Value=ErResult)or(DataType=kt_rd_M) then Exit;
 case DataType of
//   kt_rd_MS,kt_rd_MST:fMeasureChanNumber:=round(FloatDataFromRow(Str,2));
   kt_rd_MS,kt_rd_MST:AdditionalDataFromString(Str);
   kt_rd_MT:fTimeValue:=StringToMeasureTime(DeleteStringDataFromRow(Str,1));
 end;
 if DataType=kt_rd_MST then fTimeValue:=StringToMeasureTime(DeleteStringDataFromRow(DeleteStringDataFromRow(Str,1),1));
end;

procedure TKeitley.StringToMesuredDataArray(Str: string;
  DataType: TKeitley_ReturnedData);
  var partStr:string;
      PartNumbers,i:integer;
      NumbersArray:TArrInteger;
begin
 DataVector.Clear;
 DataTimeVector.Clear;
 PartNumbers:=NumberOfSubstringInRow(Str);
 SetLength(NumbersArray,Keitley_PartInRespond[DataType]);
 for I := 0 to High(NumbersArray) do
  NumbersArray[i]:=i+1;

 while PartNumbers>=Keitley_PartInRespond[DataType] do
  begin
   partStr:=NewStringByNumbers(Str,NumbersArray);
   StringToMesuredData(partStr,DataType);
   case DataType of
//    kt_rd_MS:DataVector.Add(fSourceMeasuredValue,fDevice.Value);
    kt_rd_MS:AdditionalDataToArrayFromString;
    kt_rd_MT:begin
             DataTimeVector.Add(fTimeValue,fDevice.Value);
              DataVector.Add(fTimeValue,fDevice.Value);
             end;
    kt_rd_MST:begin
//               DataVector.Add(fSourceMeasuredValue,fDevice.Value);
               AdditionalDataToArrayFromString;
               DataTimeVector.Add(fTimeValue,fDevice.Value);
              end;
    kt_rd_M:DataVector.Add(fDevice.Value,fDevice.Value);
   end;
   PartNumbers:=PartNumbers-Keitley_PartInRespond[DataType];
   for I := 1 to Keitley_PartInRespond[DataType] do
    Str:=DeleteStringDataFromRow(Str,1);
  end;
 if DataVector.Count<>(Buffer.EndIndex-Buffer.StartIndex+1) then
    fDevice.Value:=ErResult;

end;

function TKeitley.StringToTerminals(Str: string): boolean;
  var i:TKeitley_OutputTerminals;
begin
 Result:=False;
 for I := Low(TKeitley_OutputTerminals) to High(TKeitley_OutputTerminals) do
   if Str=Keitley_TerminalsName[i] then
     begin
       fTerminal:=i;
       Result:=True;
       Break;
     end;
end;

function TKeitley.StringToTrigerState(Str: string): boolean;
  var i:TKeitley_TriggerState;
begin
 Result:=False;
 for I := Low(TKeitley_TriggerState) to High(TKeitley_TriggerState) do
   if Pos(Keitley_TriggerStateCommand[i],Str)<>0 then
     begin
       fTrigerState:=i;
       Result:=True;
       fDevice.Value:=ord(i);
       Break;
     end;
end;

//function TKeitley.Test: boolean;
//begin
//// *IDN?
// QuireOperation(0,0,0,False);
// Result:=(fDevice.Value=314);
//end;

procedure TKeitley.TextToUserScreen(top_text, bottom_text: string);
begin
//DISP:SCR SWIPE_USER
//DISP:USER1:TEXT "top_text"
//DISP:USER2:TEXT "bottom_text"
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

procedure TKeitley.TrigAlwaysTransition(TransitionBlockNumber: word);
begin
//:TRIG:BLOC:BRAN:ALW <blockNumber>, <branchToBlock>
 if TransitionBlockNumber=0 then exit;
 fAdditionalString:=IntToStr(TransitionBlockNumber);
 SetupOperation(26,41,4);
end;

procedure TKeitley.TrigBufferClear(BufName: string);
begin
//:TRIG:BLOC:BUFF:CLE <blockNumber>, "<bufferName>"
 fAdditionalString:=StringToInvertedCommas(BufName);
 SetupOperation(26,40,0);
end;

procedure TKeitley.TrigConfigListNext(ListName: string);
begin
//:TRIG:BLOC:CONF:NEXT <blockNumber>, "<configurationList>"
 fAdditionalString:=StringToInvertedCommas(ListName);
 SetupOperation(26,24,2);
end;

procedure TKeitley.TrigConfigListNext(ListName1, ListName2: string);
begin
//:TRIG:BLOC:CONF::NEXT <blockNumber>, "<configurationList>", "<configurationList2>"
 fAdditionalString:=StringToInvertedCommas(ListName1)+PartDelimiter
                    +StringToInvertedCommas(ListName2);
 SetupOperation(26,24,2);
end;

procedure TKeitley.TrigConfigListRecall(ListName: string; Index: integer);
begin
//:TRIG:BLOC:CONF:REC <blockNumber>, "<configurationList>", <index>
 fAdditionalString:=StringToInvertedCommas(ListName)+PartDelimiter+
                    inttostr(Index);
 SetupOperation(26,24,1);
end;

procedure TKeitley.TrigCounterTransition(TargetCount,
  TransitionBlockNumber: word);
begin
//:TRIG:BLOC:BRAN:COUN <blockNumber>, <targetCount>, <branchToBlock>
 if (TransitionBlockNumber=0)or(TargetCount=0) then Exit;
 fAdditionalString:=IntToStr(TargetCount)+PartDelimiter
                    + IntToStr(TransitionBlockNumber);
  SetupOperation(26,41,7);
end;

procedure TKeitley.TrigDelay(DelayTime: double);
begin
//:TRIG:BLOC:DEL:CONS <blockNumber>, <time>
 fAdditionalString:=floattostr(NumberMap(DelayTime,Keitley_TrigDelayLimits));
 SetupOperation(26,21,5);
end;

procedure TKeitley.TrigEventGenerate;
begin
// *TRG
 SetupOperation(27,0,0,False);
end;

procedure TKeitley.TrigEventTransition(TransitionBlockNumber: word;
  EventType: TKeitley_TriggerEvents; EventNumber: word);
begin
//:TRIG:BLOC:BRAN:EVEN <blockNumber>, <event>, <branchToBlock>
 if (TransitionBlockNumber=0)or(EventNumber=0) then Exit;
 if (EventType=kt_te_timer)and(EventNumber>4) then Exit;
 if (EventType=kt_te_notify)and(EventNumber>8) then Exit;
 if (EventType=kt_te_lan)and(EventNumber>8) then Exit;
 if (EventType=kt_te_dig)and(EventNumber>6) then Exit;
 if (EventType=kt_te_blend)and(EventNumber>2) then Exit;
 if (EventType=kt_te_tspl)and(EventNumber>3) then Exit;

 fAdditionalString:=Keitley_TriggerEventsCommand[EventType];
 if EventType in [kt_te_timer..kt_te_tspl] then
   fAdditionalString:=fAdditionalString + IntToStr(EventNumber);
 fAdditionalString:=fAdditionalString+PartDelimiter
                    + IntToStr(TransitionBlockNumber);
 SetupOperation(26,41,8);
end;

procedure TKeitley.TrigMeasure(BufName: string; Count: word);
begin
//:TRIG:BLOC:MDIG <blockNumber>, "<bufferName>", <count>
 fAdditionalString:=StringToInvertedCommas(BufName)+PartDelimiter
                    +IntToStr(Count);
 SetupOperation(26,42);
end;

procedure TKeitley.TrigMeasureCountDevice(BufName: string);
begin
//:TRIG:BLOC:MDIG <blockNumber>, "<bufferName>", AUTO
 fAdditionalString:=StringToInvertedCommas(BufName)+PartDelimiter
                    +'auto';
 SetupOperation(26,42);
end;

procedure TKeitley.TrigMeasureInf(BufName: string);
begin
//:TRIG:BLOC:MDIG <blockNumber>, "<bufferName>", INF
 fAdditionalString:=StringToInvertedCommas(BufName)+PartDelimiter
                    +'inf';
 SetupOperation(26,42);
end;

procedure TKeitley.TrigMeasureResultTransition(
  LimitType: TKeitley_TrigLimitType; LimA, LimB: double; TransitionBlockNumber,
  MeasureBlockNumber: word);
begin
//:TRIG:BLOC:BRAN:LIM:CONS <blockNumber>, <limitType>, <limitA>, <limitB>,
//<branchToBlock>, <measureDigitizeBlock>
 if TransitionBlockNumber=0 then Exit;
 fAdditionalString:=Kt2450_TrigLimitTypeCommand[LimitType]+PartDelimiter
                    +floattostr(LimA)+PartDelimiter
                    +floattostr(LimB)+PartDelimiter
                    +IntTostr(TransitionBlockNumber)+PartDelimiter
                    +IntTostr(MeasureBlockNumber);
 SetupOperation(26,41,6);
end;

procedure TKeitley.TrigNewCreate;
begin
//:TRIGger:LOAD "Empty"
 fTrigBlockNumber:=1;
 fAdditionalString:=StringToInvertedCommas('Empty');
 SetupOperation(26,38);
end;

procedure TKeitley.TrigPause;
begin
//:TRIG:PAUS
 SetupOperation(26,44,0,False);
end;

procedure TKeitley.TrigResume;
begin
//:TRIG:RES
 SetupOperation(26,43,0,False);
end;

procedure TKeitley.UnloadSetupPowerOn;
begin
//SYST:POS RST
  fAdditionalString:=DeleteSubstring(RootNodeKeitley[2],'*');
  SetupOperation(7,4);
end;

procedure TKeitley.Wait;
begin
// *WAI
 SetupOperation(25,0,0,False);
end;

{ TKeitle_Measurement }

constructor TKeitley_Measurement.Create(Keitley: TKeitley);
begin
 inherited Create;
 fParentModule:=Keitley;
end;

function TKeitley_Measurement.GetData: double;
begin
 GetDataPreparation;
 fValue:=GetValueFromDevice;
 Result:=fValue;
 fNewData:=fParentModule.Device.NewData;
end;

procedure TKeitley_Measurement.GetDataPreparation;
begin
  GetDataPreparationHeader;
  fParentModule.MeasureExtended(kt_rd_MS);
end;

procedure TKeitley_Measurement.GetDataPreparationHeader;
begin
end;

function TKeitley_Measurement.GetValueFromDevice: double;
begin
 Result:=fParentModule.Device.Value;
end;

{ TKeitley_Meter }

constructor TKeitley_Meter.Create(Keitley: TKeitley);
begin
 fTimer:=TTimer.Create(nil);
 fTimer.Enabled:=False;
 fTimer.Interval:=2000;
 inherited Create(Keitley);
end;

destructor TKeitley_Meter.Destroy;
begin
 FreeAndNil(fTimer);
 inherited;
end;

function TKeitley_Meter.GetMeasureModeLabel: string;
begin

end;

end.
