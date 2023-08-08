unit ST2829C;

interface

uses
  SCPI, CPort, RS232deviceNew, ST2829CConst;

type

  TRS232_ST2829C=class(TRS232_SCPI)
    protected
    public
     Constructor Create(CP:TComPort);
    end;

  TDataSubject_ST2829C=class(TRS232DataSubjectSingle)
    protected
    procedure ComPortCreare(CP:TComPort);override;
  end;


 TST2829CDevice=class(TRS232DeviceNew)
  private
  protected
   procedure CreateDataSubject(CP:TComPort);override;
  public
 end;

  TST2829C=class(TSCPInew)
  private
//   fRS232:TRS232MeterDeviceSingle;
//   fComPort:TComPort;
//   fTerminal:TKeitley_OutputTerminals;
//   fDataVector:TVector;
//   {X - значення чогось (джерела, номера каналу); Y - результат виміру}
//   fDataTimeVector:TVector;
//   {X - час виміру (мілісекунди з початку доби); Y - результат виміру}
//   fBuffer:TKeitley_Buffer;
//
//   fDisplayState:TKeitley_DisplayState;
//   fTrigerState:TKeitley_TriggerState;
//
//   function StringToTerminals(Str:string):boolean;
//   function StringToBufferIndexies(Str:string):boolean;
//   function StringToDisplayBrightness(Str:string):boolean;
  protected
//   fTelnet:TIdTelnet;
//   fIPAdressShow: TIPAdressShow;
//   fMeasureFunction:TKeitley_Measure;
//   fTimeValue:double;
//   fTrigBlockNumber:word;
//   fCount:integer;
//   fMeter:TKeitley_Meter;
//   procedure MeterCreate;virtual;abstract;
//   procedure PrepareString;override;
   function GetRootNodeString():string;override;
   procedure PrepareStringByRootNode;override;
   procedure DeviceCreate(Nm:string);override;
   procedure ProcessingStringByRootNode(Str:string);override;
//   procedure DefaultSettings;override;
//   function StringToMeasureFunction(Str:string):boolean;//virtual;
//   function StringToDigMeasureFunction(Str:string):boolean;
//   function StringToTrigerState(Str:string):boolean;
//   function MeasureToRootNodeNumber(Measure:TKeitley_Measure):byte;
//   function MeasureToRootNodeStr(Measure:TKeitley_Measure):string;
//   function MeasureToFunctString(Measure:TKeitley_Measure):string;
//   procedure StringToMesuredData(Str:string;DataType:TKeitley_ReturnedData);
//   procedure AdditionalDataFromString(Str:string);virtual;abstract;
//   procedure StringToMesuredDataArray(Str:string;DataType:TKeitley_ReturnedData);
//   procedure AdditionalDataToArrayFromString;virtual;abstract;
//
//   function StringToMeasureTime(Str:string):double;
//   function GetMeasureFunctionValue:TKeitley_Measure;virtual;
//   procedure SetCountNumber(Value:integer);virtual;
//   procedure OnOffFromBool(toOn:boolean);
   function HighForStrParsing:byte;override;
   function ItIsRequiredStr(Str:string;i:byte):boolean;override;
  public
//   property DataVector:TVector read fDataVector;
//   property DataTimeVector:TVector read fDataTimeVector;
//   property MeasureFunction:TKeitley_Measure read GetMeasureFunctionValue;
//   property Terminal:TKeitley_OutputTerminals read fTerminal write fTerminal;
//   property Buffer:TKeitley_Buffer read fBuffer;
//   property Count:integer read fCount write SetCountNumber;
//   property TimeValue:double read fTimeValue;
//   property Meter:TKeitley_Meter read fMeter;
//   property DisplayState:TKeitley_DisplayState read fDisplayState;
//   property TrigerState:TKeitley_TriggerState read fTrigerState;
//     Constructor Create(CP:TComPort;Nm:string='ST2829C');
     Constructor Create();
//   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
//               Nm:string);
//   destructor Destroy; override;
////
//   function Test():boolean;override;
//   procedure ProcessingString(Str:string);override;
   procedure ResetSetting();
   procedure MyTraining();
   procedure Trig();
   {triggers the measurement and then sends the result to the output buffer.}
   procedure SetDisplayPage(Page:TST2829C_DisplayPage);
   function  GetDisplayPage():boolean;
   procedure SetDisplayFont(Font:TST2829C_Font);
   function  GetDisplayFont():boolean;
//   procedure ClearUserScreen();
//   procedure TextToUserScreen(top_text:string='';bottom_text:string='');
//
   procedure SaveSetup(RecordNumber:TST2829C_SetupMemoryRecord;RecordName:string='');
   procedure LoadSetup(RecordNumber:TST2829C_SetupMemoryRecord);
//   procedure LoadSetupPowerOn(SlotNumber:TKeitley_SetupMemorySlot);
//   procedure UnloadSetupPowerOn();
//   procedure RunningMacroScript(ScriptName:string);
//
//   function GetTerminal():boolean;
////   {вихід на передню чи задню панель}
////
//   procedure SetAzeroState(Measure:TKeitley_Measure;
//                              toOn:boolean);overload;
//   {чи перевіряються опорні значення перед кожним виміром}
//   procedure SetAzeroState(toOn:boolean);overload;virtual;
//   procedure AzeroOnce();
//   {примусова перевірка опорного значення}
//   procedure SetMeasureFunction(MeasureFunc:TKeitley_Measure=kt_mCurDC);virtual;
//   {що саме буде вимірювати прилад}
//   function GetMeasureFunction():boolean;virtual;
//    {повертає тип вимірювання, обробка залежить
//    від типу приладу}
//   procedure SetDisplayDigitsNumber(Measure:TKeitley_Measure; Number:TKeitleyDisplayDigitsNumber);overload;virtual;
//   {кількість цифр, що відображаються на екрані,
//     на точність самого вимірювання не впливає}
//   procedure SetDisplayDigitsNumber(Number:TKeitleyDisplayDigitsNumber);overload;virtual;
//   function GetDisplayDigitsNumber(Measure:TKeitley_Measure):boolean;overload;virtual;
//   function GetDisplayDigitsNumber():boolean;overload;virtual;
//   procedure BufferCreate();overload;
//   procedure BufferCreate(Name:string);overload;
//   procedure BufferCreate(Name:string;Size:integer);overload;
//   procedure BufferCreate(Name:string;Size:integer;Style:TKt2450_BufferStyle);overload;virtual;
//   procedure BufferCreate(Style:TKt2450_BufferStyle);overload;virtual;
//   procedure BufferDelete();overload;
//   procedure BufferDelete(Name:string);overload;
//   procedure BufferClear();overload;
//   procedure BufferClear(BufName:string);overload;
////
//   procedure BufferReSize(NewSize:integer);overload;
//   {змінює можливу кількість записів у буфері,
//   при цьому він очищується}
//   procedure BufferReSize(BufName:string;NewSize:integer);overload;
//   function BufferGetSize():integer;overload;
//   function BufferGetSize(BufName:string):integer;overload;
//   function BufferGetReadingsNumber(BufName:string=KeitleyDefBuffer):integer;
//   {повертає існуючу кількість записів у буфері}
//   function BufferGetStartEndIndex(BufName:string=KeitleyDefBuffer):boolean;
//   {повертає початковий та кінцевий індекси існуючих
//   в буфері записів, якщо все добре вони знаходяться
//   в Buffer.StartIndex та Buffer.EndIndex}
//
//   procedure BufferSetFillMode(FillMode:TKeitley_BufferFillMode);overload;
//   procedure BufferSetFillMode(BufName:string;FillMode:TKeitley_BufferFillMode);overload;
//   function BufferGetFillMode():boolean;overload;
//   function BufferGetFillMode(BufName:string):boolean;overload;
//
//   Procedure BufferLastDataSimple();overload;
//   {без вимірювання видобувається результат останнього
//   вимірювання, що зберігається у defbuffer1,
//   розміщується в fDevice.Value}
//   Procedure BufferLastDataSimple(BufName:string);overload;
//   {отримання останнього збереженого результату
//   вимірювань з буфера BufName}
//   Procedure BufferLastDataExtended(DataType:TKeitley_ReturnedData=kt_rd_MS;
//                            BufName:string=KeitleyDefBuffer);
//   {як попередні, проте повертає більше даних
//   (див. TKeitley_ReturnedData) щодо останнього виміру}
//   Procedure BufferDataArrayExtended(SIndex,EIndex:integer;
//                     DataType:TKeitley_ReturnedData=kt_rd_MS;
//                     BufName:string=KeitleyDefBuffer);
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
//   function GetCount:boolean;
//   procedure SetDisplayBrightness(State:TKeitley_DisplayState);
//   function GetDisplayBrightness():boolean;
////
//   procedure Beep(Freq:word=600;Duration:double=0.1);
//   {звук частотою Freq Гц протягом Duration секунд}
//
//   procedure ConfigMeasureCreate(ListName:string=MyMeasList);
//   procedure ConfigMeasureDelete(ListName:string=MyMeasList;ItemIndex:word=0);
//   {якщо ItemIndex=0, то видаляється весь список}
//   procedure ConfigMeasureRecall(ListName:string=MyMeasList;ItemIndex:word=1);
//   {завантаження налаштувань, записаних в ItemIndex;
//   якщо потрібно викликати налаштування і для джерела,
//   і для вимірювача - спочатку завантажувати треба для джерела}
//   procedure ConfigMeasureStore(ListName:string=MyMeasList;ItemIndex:word=0);
//   {запис налаштувань у список;
//   якщо ItemIndex=0, то записується у кінець списку}
//
//   Procedure GetParametersFromDevice;virtual;
////
//   Procedure MeasureSimple();overload;virtual;
//   {проводиться вимірювання стільки разів, скільки
//   вказано в Count, всі результати розміщуються
//   в defbuffer1, повертається результат останнього виміру;
//   вимірюється та функція, яка зараз встановлена на приладі,
//   можна зробити, щоб вимірювалося щось інше, але я не
//   схотів гратися з такою не дуже реальною на перший погляд
//   задачею}
//   Procedure MeasureSimple(BufName:string);overload;virtual;
//   {результати записуються у буфер BufName
//   і з нього ж зчитується останній результат}
//   Procedure MeasureExtended(DataType:TKeitley_ReturnedData=kt_rd_MS;
//                           BufName:string=KeitleyDefBuffer);
//   {як попередні, проте повертає більше даних
//   (див. TKt2450_ReturnedData) щодо останнього виміру}
////
////
//   Procedure Init;
//   Procedure Abort;
//   Procedure Wait;
//   Procedure TrigPause;
//   Procedure TrigResume;
//   Procedure InitWait;
//   Procedure TrigEventGenerate;
//   {generates a trigger event }
//
//   Procedure TrigNewCreate;
//   {any blocks that have been defined in the trigger model
//   are cleared so the trigger model has no blocks defined}
//   Procedure TrigBufferClear(BufName:string=KeitleyDefBuffer);
//   Procedure TrigConfigListRecall(ListName:string;Index:integer=1);
//   Procedure TrigConfigListNext(ListName:string);overload;
//   Procedure TrigConfigListNext(ListName1,ListName2:string);overload;
//   Procedure TrigAlwaysTransition(TransitionBlockNumber:word);
//   Procedure TrigDelay(DelayTime:double);
//   Procedure TrigMeasure(BufName:string=KeitleyDefBuffer;Count:word=1);
//   {при досягненні цього блоку прилад вимірює Count разів,
//   після чого виконується наступний блок;
//   Count=0 може використовуватися для зупинки нескінченних вимірювань
//   - див. далі;
//   результати заносяться в BufName}
//   Procedure TrigMeasureInf(BufName:string=KeitleyDefBuffer);
//   {при досягненні цього блоку прилад починає
//   виміри і виконується наступний блок; виміри продовжуються доти,
//   поки не зустрінеться новий вимірювальний блок чи не буде кінець моделі}
//   Procedure TrigMeasureCountDevice(BufName:string=KeitleyDefBuffer);
//   {при досягненні цього блоку прилад вимірює стільки разів, скільки
//   передбачено попередньо встановленою властивістю Count,
//   після чого виконується наступний блок}
//
//   Procedure TrigMeasureResultTransition(LimitType:TKeitley_TrigLimitType;
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
//                                 EventType:TKeitley_TriggerEvents=kt_te_comm;
//                                 EventNumber:word=1);
//   {якщо до того, як дійшли на цей блок, відбулася подія EventType,
//   то відбувається перехід на TransitionBlockNumber}
//   function GetTrigerState:boolean;
 end;

var
  ST_2829C:TST2829C;

implementation

uses
  SysUtils, Dialogs, OlegType;

{ T2829C }

constructor TST2829C.Create();
begin
// showmessage('TST2829C Create');
 inherited Create('ST2829C');
end;

//constructor TST2829C.Create(CP: TComPort; Nm: string);
//begin
// fComPort:=CP;
// inherited Create(Nm);
//// inherited Create;
//// fName:=Nm;
//// DeviceCreate(Nm);
//// DefaultSettings();
//// SetFlags(0,0,0);
//
//// fBuffer:=TKeitley_Buffer.Create;
//// fDataVector:=TVector.Create;
//// fDataTimeVector:=TVector.Create;
//// MeterCreate;
//
//
//end;

procedure TST2829C.DeviceCreate(Nm: string);
begin
//  fDevice:=TST2829CDevice.Create(Self,fComPort,Nm);
  fDevice:=TST2829CDevice.Create(Self,Nm);
end;

function TST2829C.GetDisplayFont: boolean;
begin
 QuireOperation(4,3);
 Result:=(fDevice.Value<>ErResult);
end;

function TST2829C.GetDisplayPage: boolean;
begin
 QuireOperation(4,2);
 Result:=(fDevice.Value<>ErResult);
end;

function TST2829C.GetRootNodeString: string;
begin
 Result:=RootNodeST2829C[fRootNode];
end;

function TST2829C.HighForStrParsing: byte;
begin
 Result:=0;
 case fRootNode of
  4:case fFirstLevelNode of
    2:Result:=ord(High(TST2829C_DisplayPageCommand));
    3:Result:=ord(High(TST2829C_Font));
    end;
 end;
end;

function TST2829C.ItIsRequiredStr(Str: string; i: byte): boolean;
begin
 Result:=False;
 case fRootNode of
  4:case fFirstLevelNode of
    2:Result:=(Pos(TST2829C_DisplayPageResponce[TST2829C_DisplayPage(i)],Str)<>0);
    3:Result:=(Pos(TST2829C_FontCommand[TST2829C_Font(i)],Str)<>0);
    end;
 end;
end;

procedure TST2829C.LoadSetup(RecordNumber: TST2829C_SetupMemoryRecord);
begin
// *MMEM:LOAD:STAT <record number>
 fAdditionalString:=inttostr(RecordNumber);
 SetupOperation(3);
end;

procedure TST2829C.MyTraining;
 var i:Integer;
begin

  for I := 0 to ord(High(TST2829C_Font)) do
   begin
     SetDisplayFont(TST2829C_Font(i));
     if (GetDisplayFont() and(i=round(fDevice.Value)))
      then showmessage('Ura!!!');
   end;
 SetDisplayFont(st_lLarge);

// SetDisplayFont(st_lTine);
// SetDisplayFont(st_lOff);
// SetDisplayFont(st_lLarge);


//  for I := 0 to ord(High(TST2829C_DisplayPage)) do
//   begin
//     SetDisplayPage(TST2829C_DisplayPage(i));
//     if (GetDisplayPage() and(i=round(fDevice.Value)))
//      then showmessage('Ura');
//   end;


//SaveSetup(0);
//SaveSetup(11,'Hi result');
//SaveSetup(25,'0123456789ABCDEFGH');
//
// LoadSetup(35);
// Trig();
// EnableComPortShow();

// ResetSetting();
end;

//procedure TST2829C.PrepareString;
//begin
// (fDevice as TST2829CDevice).ClearStringToSend;
// (fDevice as TST2829CDevice).SetStringToSend(RootNodeST2829C[fRootNode]);
//
// PrepareStringByRootNode;
//
// if fIsSuffix then JoinAddString;
//end;

procedure TST2829C.PrepareStringByRootNode;
begin
 case fRootNode of
  3:JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
  4:JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
  end;
end;

//procedure TST2829C.ProcessingString(Str: string);
//begin
// Str:=Trim(Str);
// ProcessingStringByRootNode(Str);
//end;

procedure TST2829C.ProcessingStringByRootNode(Str: string);
begin
 case fRootNode of
  0:if pos(ST2829C_Test,Str)<>0 then fDevice.Value:=314;
  4:case fFirstLevelNode of
    2,3:StringToOrd(AnsiLowerCase(Str));
    end;
 end;
end;

procedure TST2829C.ResetSetting;
begin
//  *RST
  SetupOperation(1,0,0,False);
end;

procedure TST2829C.SaveSetup(RecordNumber: TST2829C_SetupMemoryRecord;RecordName:string='');
begin
// *MMEM:STOR:STAT <record number>,“<string>”
 fAdditionalString:=inttostr(RecordNumber);
 if Length(RecordName)>0 then
  begin
    if Length(RecordName)>ST2829C_MemFileMaxLength then SetLength(RecordName,ST2829C_MemFileMaxLength);
    fAdditionalString:=fAdditionalString+', '+StringToInvertedCommas(RecordName);
  end;
 
 SetupOperation(3,1);
end;

procedure TST2829C.SetDisplayFont(Font: TST2829C_Font);
begin
 //DISP:FRON <Font>
 fAdditionalString:=TST2829C_FontCommand[Font];
 SetupOperation(4,3);
end;

procedure TST2829C.SetDisplayPage(Page: TST2829C_DisplayPage);
begin
//DISP:PAGE <Page>
 fAdditionalString:=TST2829C_DisplayPageCommand[Page];
 SetupOperation(4,2);
end;

procedure TST2829C.Trig;
begin
//  *TRG
  SetupOperation(2,0,0,False);
end;

{ T2829CDevice }


{ TST2829CDevice }

procedure TST2829CDevice.CreateDataSubject(CP: TComPort);
begin
 fDataSubject:=TDataSubject_ST2829C.Create(CP);
end;



{ TDataSubject_ST2829C }

procedure TDataSubject_ST2829C.ComPortCreare(CP: TComPort);
begin
 fRS232:=TRS232_ST2829C.Create(CP);
end;

{ TRS232_ST2829C }

constructor TRS232_ST2829C.Create(CP: TComPort);
begin
 inherited Create(CP,250052,250052);
// fComPort.DataBits:=dbEight;
// fComPort.StopBits:=sbOneStopBit;
// fComPort.Parity.Bits:=prNone;
end;


initialization
  ST_2829C := TST2829C.Create();

finalization
  ST_2829C.Free;

end.
