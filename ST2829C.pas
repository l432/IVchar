unit ST2829C;

interface

uses
  SCPI, CPort, RS232deviceNew, ST2829CConst, ExtCtrls, OlegTypePart2, IniFiles, 
  OlegVector;


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
   Constructor Create(SCPInew:TSCPInew;Nm:string);
 end;



  TST2829_MeterSecondary=class;
  TST2829_MeterPrimary=class;
  TST2829SweepParameters=class;
  TST2829Corrections=class;

  TST2829_MeasureParameters=class
   public
    FreqMeas:double;
   {частота на якій проводяться вимірювання,
   []=Hz}
   VrmsMeas:double;
   IrmsMeas:double;
   {діючі напруга та сила струму,
    на яких проводяться вимірювання,
    []=V, []=mA (!)}
   AutoLevelControlEnable:boolean;
   {якщо True, то прилад відслідковує
   реаліні значення на DUT, а не просто
   задає певні величини}
   OutputImpedance:TST2829C_OutputImpedance;
   MeasureType:TST2829C_MeasureType;
   MeasureRange:TST2829C_Range;
   MeasureSpeed:TST2829C_MeasureSpeed;
  end;

  TST2829C=class(TSCPInew)
  private
   fMPars:TST2829_MeasureParameters;
   fBiasEnable:boolean;
   fBiasVoltageValue:double;
   fBiasCurrentValue:double;
   fAverTimes:byte;
   {кількість усереднень при вимірюванні}
   fVrmsToMeasure:boolean;
   {чи буде вимірюватися напруга на DUT
   під час вимірювань}
   fIrmsToMeasure:boolean;
   fTrigSource:TST2829C_TrigerSource;
   {джерело трігерного сигналу}
   fDelayTime:integer;
   {час затримки між тригерною командою
   та початком вимірювання, []=ms}
   fPrimaryData:double;
   fSecondaryData:double;
   fVrmsData:double;
   fIrmsData:double;
   fMeterSec:TST2829_MeterSecondary;
   fMeterPrim:TST2829_MeterPrimary;
   fSweepParameters:TST2829SweepParameters;
   fCorrections:TST2829Corrections;

   Procedure SetFreqMeas(Value:Double);
   procedure SetIrmsMeas(const Value: double);
   procedure SetVrmsMeas(const Value: double);
   procedure StBiasVoltageValue(const Value: double);
   procedure StBiasCurrentValue(const Value: double);
   procedure StAverTimes(const Value: byte);
   procedure StDelayTime(const Value: integer);
   procedure StrToData(Str:string);
    function GtAutoLevelControlEnable: boolean;
    function GtFreqMeas: double;
    function GtIrmsMeas: double;
    function GtMeasureRange: TST2829C_Range;
    function GtMeasureSpeed: TST2829C_MeasureSpeed;
    function GtMeasureType: TST2829C_MeasureType;
    function GtOutputImpedance: TST2829C_OutputImpedance;
    function GtVrmsMeas: double;
    procedure StAutoLevelControl(const Value: boolean);
    procedure StMeasureRange(const Value: TST2829C_Range);
    procedure StMeasureSpeed(const Value: TST2829C_MeasureSpeed);
    procedure StMeasureType(const Value: TST2829C_MeasureType);
    procedure StOutputImpedance(const Value: TST2829C_OutputImpedance);
    function GtCorCable: TST2829C_CorCable;
    procedure StCorCable(const Value: TST2829C_CorCable);
    function GtCorOpenEnable: boolean;
    function GtCorShortEnable: boolean;
    procedure StCorOpenEnable(const Value: boolean);
    procedure StCorShortEnable(const Value: boolean);
  protected
   function GetRootNodeString():string;override;
   procedure DeviceCreate(Nm:string);override;
   procedure OnOffFromBool(toOn:boolean);
   function ValueToOrd(Value: double; Action:TST2829CAction): integer;
   {перетворення отриманого від приладу числа в номер значення
   в переліку, використовується для величин, що приймають дискретні значення}
   function EnumerateToString(Action:TST2829CAction):string;
   {повертає рядок, який потрібно надіслати залежно від
   величини параметру, що має тип перерахунок
   (приймає дискретні значення)}
   function GetRangePattern(Action:TST2829CAction):boolean;
   procedure SetMeasuringTiming(Action:TST2829CAction);
   function t_0():integer;
   function t_meas():integer;
   function N_meas():integer;

   procedure PrepareStringByRootNode;override;
   function ActionToRootNodeNumber(Action:TST2829CAction):byte;
   function ActionToFirstNode(Action:TST2829CAction):byte;
   function ActionToLeafNode(Action:TST2829CAction):byte;
   function ActionToSyffix(Action:TST2829CAction):boolean;
   function PermitedAction(Action:TST2829CAction):boolean;
   {визначає, чи дозволена операція за даних умов}
   function PermitedGetAction(Action:TST2829CAction):boolean;
   procedure SetPrepareAction(Ps:array of Pointer);
   {підготовчі операції перед викликом SetupOperation}
   procedure GetPrepareAction(Action:TST2829CAction);
   procedure ProcessingStringByRootNode(Str:string);override;
   procedure DefaultSettings;override;
   function HighForStrParsing:byte;override;
   function ItIsRequiredStr(Str:string;i:byte):boolean;override;
   function SuccessfulGet(Action:TST2829CAction):boolean;
   {визначає критерій успішного отримання даних}
   procedure GetActionProcedure(Action:TST2829CAction);
   {дії, що виконуються при успішному отриманні}

  public
   property FreqMeas:double read GtFreqMeas write SetFreqMeas;
   property VrmsMeas:double read GtVrmsMeas write SetVrmsMeas;
   property IrmsMeas:double read GtIrmsMeas write SetIrmsMeas;
   property AutoLevelControlEnable:boolean read GtAutoLevelControlEnable write StAutoLevelControl;
   property BiasEnable:boolean read fBiasEnable write fBiasEnable;
   property BiasVoltageValue:double read fBiasVoltageValue write StBiasVoltageValue;
   property BiasCurrentValue:double read fBiasCurrentValue write StBiasCurrentValue;
   property OutputImpedance:TST2829C_OutputImpedance read GtOutputImpedance write StOutputImpedance;
   property MeasureType:TST2829C_MeasureType read GtMeasureType write StMeasureType;
   property MeasureRange:TST2829C_Range read GtMeasureRange write StMeasureRange;
   property MeasureSpeed:TST2829C_MeasureSpeed read GtMeasureSpeed write StMeasureSpeed;

   property AverTimes:byte read fAverTimes write StAverTimes;
   property VrmsToMeasure:boolean read fVrmsToMeasure write fVrmsToMeasure;
   property IrmsToMeasure:boolean read fIrmsToMeasure write fIrmsToMeasure;
   property TrigSource:TST2829C_TrigerSource read fTrigSource write fTrigSource;
   property DelayTime:integer read fDelayTime write StDelayTime;
   property DataPrimary:double read fPrimaryData;
   property DataSecondary:double read fSecondaryData;
   property DataVrms:double read fVrmsData;
   property DataIrms:double read fIrmsData;
   property MeterPrim:TST2829_MeterPrimary read fMeterPrim;
   property MeterSecond:TST2829_MeterSecondary read fMeterSec;
   property SweepParameters:TST2829SweepParameters read fSweepParameters;
   property CorectionCable:TST2829C_CorCable read GtCorCable write StCorCable;
   property CorectionOpenEnable:boolean read GtCorOpenEnable write StCorOpenEnable;
   property CorectionShortEnable:boolean read GtCorShortEnable write StCorShortEnable;
   property Corrections:TST2829Corrections read fCorrections;

   Constructor Create();
   destructor Destroy; override;
   function GetPattern(Action:Pointer):boolean;override;
   procedure SetPattern(Ps: array of Pointer);override;
   procedure ResetSetting();
   procedure MyTraining();
   procedure Trig();
   {triggers the measurement and then sends the result to the output buffer.}
   procedure SetDisplayPage(Page:TST2829C_DisplayPage);
   function  GetDisplayPage():boolean;
   procedure SetDisplayFont(Font:TST2829C_Font);
   function  GetDisplayFont():boolean;
   procedure SaveSetup(RecordNumber:TST2829C_SetupMemoryRecord;RecordName:string='');
   procedure LoadSetup(RecordNumber:TST2829C_SetupMemoryRecord);

   procedure SetFrequancyMeasurement(Freq:double);
   function  GetFrequancyMeasurement():boolean;

   procedure SetAutoLevelEnable(toOn: boolean);
   {при toOn=True прилад буде контролювати, щоб
   значення падіння напруги/сили струму на DUT
   відповідало встановленому}
   function  GetAutoLevelEnable():boolean;

   procedure SetVoltageMeasurement(V:double);
   {встановлюються діючі значення напруги,
   при яких будуть проводитися вимірювання}
   function  GetVoltageMeasurement():boolean;

   procedure SetCurrentMeasurement(I:double);
   function  GetCurrentMeasurement():boolean;

   procedure SetBiasEnable(toOn: boolean);
   function  GetBiasEnable():boolean;

   procedure SetBiasVoltage(V:double);
   function  GetBiasVoltage():boolean;

   procedure SetBiasCurrent(I:double);
   function  GetBiasCurrent():boolean;

   procedure SetOutputImpedance(OI:TST2829C_OutputImpedance);
   function  GetOutputImpedance():boolean;

   procedure SetMeasureFunction(MF:TST2829C_MeasureType);
    {що саме буде вимірювати прилад}
   function  GetMeasureFunction():boolean;

   procedure SetRange(Range:TST2829C_Range);
   function  GetRange():boolean;

   procedure SetVrmsToMeasure(toOn: boolean);
    {чи буде вимірюватися  реальної напруги
     на DUT}
   function  GetVrmsToMeasure():boolean;

   procedure SetIrmsToMeasure(toOn: boolean);
    {чи буде вимірюватися реальна сили струму
     через DUT}
   function  GetIrmsToMeasure():boolean;

   procedure SetMeasureSpeed(Speed:TST2829C_MeasureSpeed);
   function  GetMeasureSpeed():boolean;

   procedure SetAverTime(AverTime:byte);
   {кількість разів для усереднення}
   function  GetAverTime():boolean;

   procedure Trigger();
   {надсилає команду для вимірювання}

   procedure SetTrigerSource(Source:TST2829C_TrigerSource);
   function  GetTrigerSource():boolean;

   procedure SetDelayTime(Time:Integer);
   function  GetDelayTime():boolean;

   function  GetData():boolean;
   function  GetDataVrms():boolean;
   function  GetDataIrms():boolean;

   procedure SetCorrectionCable(Cable:TST2829C_CorCable);
   {реально прилад  віддалено можна переключити
   лише в режим 0м; кнопками на панелі -
   або 0м або 1м (пише нема даних);
   чому дистанційно не можна переключити
   в 1м незрозуміло; як наслідок -
   не робив відповідних кнопок на вікнах,
   хоча Show елемент підготував }
   function  GetCorrectionCable():boolean;

   procedure SetCorrectionOpenMeasuring();
   {вимірювання Open-поправок в стандартному
   частотному діапазоні}

   procedure SetCorrectionShortMeasuring();
   {вимірювання Short-поправок в стандартному
   частотному діапазоні}

   procedure SetCorrectionOpenEnable(toOn: boolean);
   {встановлює, чи використовуються Open-поправки}
   function  GetCorrectionOpenEnable():boolean;

   procedure SetCorrectionShortEnable(toOn: boolean);
   {встановлює, чи використовуються Short-поправки}
   function  GetCorrectionShortEnable():boolean;

   procedure SetCorrectionSpotState(SpotNumber:byte;toOn: boolean);
   {встановлює використовуваність частотного слоту}
   function  GetCorrectionSpotState(SpotNumber:byte):boolean;

   procedure SetCorrectionSpotFreq(SpotNumber:byte;Freq: double);
   {встановлює частоту частотного слоту}
   function  GetCorrectionSpotFreq (SpotNumber:byte):boolean;

   procedure SetCorrectionSpotOpen(SpotNumber:byte);
   {індукує вимірювання коректувальних Open-коефіцієнтів
   для частотного слоту}

   procedure SetCorrectionSpotShort(SpotNumber:byte);
   {індукує вимірювання коректувальних Short-коефіцієнтів
   для частотного слоту}

 end;




TST2829_Measurement=class(TMeasurementSimple)
 private
 protected
  fParentModule: TST2829C;
  function GetValueFromDevice:double;virtual;
 public
  property ParentModule: TST2829C read fParentModule;
  constructor Create(ST2829C:TST2829C);
  function GetData:double;override;
end;

TST2829_MeterSecondary=class(TST2829_Measurement)
 protected
  function GetValueFromDevice:double;override;
 public
  constructor Create(ST2829C:TST2829C);
end;

TST2829_MeterPrimary=class(TST2829_Measurement)
 private
  fTimer:TTimer;
  fValue2:double;
 protected
  function GetValueFromDevice:double;override;
  function GetMeasureModeLabel():string;
  function GetMeasureModeLabelTwo():string;
 public
  property Timer:TTimer read fTimer;
  property ValueTwo:double read fValue2;
  property MeasureModeLabel:string read GetMeasureModeLabel;
  property MeasureModeLabelTwo:string read GetMeasureModeLabelTwo;
  constructor Create(ST2829C:TST2829C);
  destructor Destroy; override;
end;

TST2829Part=class
 private
  fParentModule: TST2829C;
 public
  constructor Create(ST2829C:TST2829C);
end;

TST2829SweepParameters=class(TST2829Part)
 private
  fDataVector:TVector;
  fSecondDataVector:TVector;
  fOldValue:double;
  fOldState:boolean;
  fStepValue:double;
  function GtMeasureType:TST2829C_MeasureType;
 public
  SweepType:TST2829C_SweepParametr;
  StartValue:double;
  FinishValue:double;
  PointCount:integer;
  LogStep:boolean;
  DataType:TST2829C_SweepData;
  property DataPrime:TVector read fDataVector;
  property DataSecond:TVector read fSecondDataVector;
  property MeasureType:TST2829C_MeasureType read GtMeasureType;
  constructor Create(ST2829C:TST2829C);
  destructor Destroy; override;
  function ToString():string;
  function Step:double;
  procedure SaveDataToFile(FileName:string);
  procedure BeforeMeasuring;
  procedure EndMeasuring;
  procedure ActionMeasurement(const Value:double);
  procedure SetValue(Value:double);
  procedure AddData;
  function GetXData:double;
  function GetXValueAtStep(StepNumber:integer):double;
  {повертає значення величини, залежність
  від якої вимірюється, на кроці з номером StepNumber;
  StepNumber має змінюватися від 0 до (PointCount-1)}
end;

TST2829Corrections=class(TST2829Part)
 private
  fSpotActiveNumber:byte;
  fSpotActiveFreq:double;
  procedure SetSpotActiveNumber(const Value: byte);
  procedure SetSpotActiveFreq(const Value: double);
 protected
 public
  fCable:TST2829C_CorCable;
  fOpenEnable:boolean;
  fShortEnable:boolean;
  fSpotActiveState:boolean;
  property SpotActiveNumber:byte read fSpotActiveNumber write SetSpotActiveNumber;
  property SpotActiveFreq:double read fSpotActiveFreq write SetSpotActiveFreq;
  constructor Create(ST2829C:TST2829C);
end;

var
  ST_2829C:TST2829C;
  CF_ST_2829C:TIniFile;

implementation

uses
  SysUtils, Dialogs, OlegType, Math, StrUtils, OlegFunction, Forms, OlegGraph,
  HighResolutionTimer;

{ T2829C }

function TST2829C.ActionToFirstNode(Action: TST2829CAction): byte;
begin
 case Action of
   st_aMemSave: Result:=1;
   st_aDispPage,st_aChangFont: Result:=ord(Action)-2;
   st_aBiasEn,
   st_aBiasVol,
   st_aSetMeasT:Result:=ord(Action)-5;
   st_aRange:Result:=8;
   st_aVrmsToMeas,
   st_aIrmsToMeas,
   st_aGetVrms,
   st_aGetIrms:Result:=11;
   st_aAverTimes:Result:=1;
   st_aBiasCur:Result:=7;
   st_aTrigSource,
   st_aTrigDelay:Result:=ord(Action)-7;
   st_aCorCable:Result:=16;
   st_aOpenMeas,
   st_aOpenState:Result:=17;
   st_aShortMeas,
   st_aShortState:Result:=18;
   st_aCorSpotState,
   st_aCorSpotFreq,
   st_aCorSpotShort,
   st_aCorSpotOpen:Result:=19;
   else Result:=0;
 end;
end;

function TST2829C.ActionToLeafNode(Action: TST2829CAction): byte;
begin
 Result:=0;
 case Action of
   st_aRange: case fMPars.MeasureRange of
               st_rAuto:Result:=1;
               else Result:=2;
              end;
   st_aVrmsToMeas,
   st_aGetVrms:Result:=12;
   st_aIrmsToMeas,
   st_aGetIrms:Result:=13;
   st_aShortState,
   st_aOpenState,
   st_aCorSpotState:Result:=5;
   st_aCorSpotFreq:Result:=100;
   st_aCorSpotShort:Result:=18;
   st_aCorSpotOpen:Result:=17;
 end;
end;

function TST2829C.ActionToRootNodeNumber(Action: TST2829CAction): byte;
begin
 case Action of
   st_aReset,st_aTrg,
   st_aMemLoad: Result:=ord(Action)+1;
   st_aMemSave: Result:=3;
   st_aDispPage,st_aChangFont:Result:=4;
   st_aFreqMeas,st_aALE,
   st_aVMeas,st_aIMeas:Result:=ord(Action)-1;
   st_aBiasEn,
   st_aBiasVol,
   st_aBiasCur:Result:=9;
   st_aOutImp:Result:=10;
   st_aSetMeasT,
   st_aRange,
   st_aVrmsToMeas,
   st_aIrmsToMeas:Result:=11;
   st_aSpeedMeas,
   st_aAverTimes:Result:=12;
   st_aTriger,
   st_aTrigSource,
   st_aTrigDelay:Result:=13;
   st_aGetMeasData,
   st_aGetVrms,
   st_aGetIrms:Result:=14;
   st_aCorCable,
   st_aOpenMeas,
   st_aOpenState,
   st_aShortMeas,
   st_aShortState,
   st_aCorSpotState,
   st_aCorSpotFreq,
   st_aCorSpotShort,
   st_aCorSpotOpen:Result:=15;
   else Result:=0;
 end;
end;

function TST2829C.ActionToSyffix(Action: TST2829CAction): boolean;
begin
 case Action of
   st_aReset,
   st_aTrg,
   st_aTriger,
   st_aOpenMeas,
   st_aShortMeas,
   st_aCorSpotShort,
   st_aCorSpotOpen: Result:=False;
   else Result:=True;
 end;
end;

constructor TST2829C.Create();
begin
 fMPars:=TST2829_MeasureParameters.Create;
 inherited Create('ST2829C');
 fMeterSec:=TST2829_MeterSecondary.Create(Self);
 fMeterPrim:=TST2829_MeterPrimary.Create(Self);
 fSweepParameters:=TST2829SweepParameters.Create(Self);
 fCorrections:=TST2829Corrections.Create(Self);
end;


procedure TST2829C.DefaultSettings;
begin
 fMPars.FreqMeas:=1000;
 fMPars.VrmsMeas:=0.01;
 fMPars.IrmsMeas:=0.1;
 fMPars.AutoLevelControlEnable:=False;
 fBiasEnable:=False;
 fBiasVoltageValue:=0;
 fBiasCurrentValue:=0;
 fMPars.OutputImpedance:=st_oi100;
 fMPars.MeasureType:=st_mtCpD;
 fMPars.MeasureRange:=st_rAuto;
 fMPars.MeasureSpeed:=st_msMed;
 fAverTimes:=1;
 fVrmsToMeasure:=False;
 fIrmsToMeasure:=False;
 fDelayTime:=0;
 fTrigSource:=st_tsInt;
 fPrimaryData:=0;
 fSecondaryData:=0;
 fVrmsData:=0;
 fIrmsData:=0;
end;

destructor TST2829C.Destroy;
begin
  FreeAndNil(fCorrections);
  FreeAndNil(fSweepParameters);
  FreeAndNil(fMeterSec);
  FreeAndNil(fMeterPrim);
  FreeAndNil(fMPars);
  inherited;
end;

procedure TST2829C.DeviceCreate(Nm: string);
begin
  fDevice:=TST2829CDevice.Create(Self,Nm);
end;

function TST2829C.EnumerateToString(Action: TST2829CAction): string;
begin
 case Action of
   st_aOutImp:Result:=Copy(ST2829C_OutputImpedanceLabels[fMPars.OutputImpedance],
                           1, Length(ST2829C_OutputImpedanceLabels[fMPars.OutputImpedance])-4);
   st_aRange:begin
               if odd(ord(MeasureRange))
                 then Result:=floattostr(Power(10,((ord(MeasureRange) Div 2)+1)))
                 else Result:=floattostr(3*Power(10,((ord(MeasureRange) Div 2))));
             end
   else Result:='';
 end;
end;

procedure TST2829C.GetActionProcedure(Action: TST2829CAction);
begin
  case Action of
    st_aFreqMeas:FreqMeas:=fDevice.Value;
    st_aALE:fMPars.AutoLevelControlEnable:=(fDevice.Value=1);
    st_aVMeas:VrmsMeas:=fDevice.Value;
    st_aIMeas:IrmsMeas:=fDevice.Value*1000;
    st_aBiasEn:BiasEnable:=(fDevice.Value=1);
    st_aBiasVol:BiasVoltageValue:=fDevice.Value;
    st_aBiasCur:BiasCurrentValue:=fDevice.Value*1000;
    st_aOutImp:OutputImpedance:=TST2829C_OutputImpedance(ValueToOrd(fDevice.Value,st_aOutImp));
    st_aSetMeasT:MeasureType:=TST2829C_MeasureType(round(fDevice.Value));
    st_aSpeedMeas:MeasureSpeed:=TST2829C_MeasureSpeed(round(fDevice.Value));
    st_aAverTimes:AverTimes:=round(fDevice.Value);
    st_aVrmsToMeas:VrmsToMeasure:=(fDevice.Value=1);
    st_aIrmsToMeas:IrmsToMeasure:=(fDevice.Value=1);
    st_aTrigSource:TrigSource:=TST2829C_TrigerSource(round(fDevice.Value));
    st_aTrigDelay:fDelayTime:=round(fDevice.Value*1000);
    st_aGetVrms:fVrmsData:=fDevice.Value;
    st_aGetIrms:fIrmsData:=fDevice.Value*1000;
    st_aCorCable:CorectionCable:=TST2829C_CorCable(round(fDevice.Value));
    st_aOpenState:CorectionOpenEnable:=(fDevice.Value=1);
    st_aShortState:CorectionShortEnable:=(fDevice.Value=1);
    st_aCorSpotState:fCorrections.fSpotActiveState:=(fDevice.Value=1);
    st_aCorSpotFreq:fCorrections.fSpotActiveFreq:=fDevice.Value;
  end;
end;

function TST2829C.GetAutoLevelEnable: boolean;
begin
 Result:=GetPattern(Pointer(st_aALE));
end;

function TST2829C.GetAverTime: boolean;
begin
 Result:=GetPattern(Pointer(st_aAverTimes));
end;

function TST2829C.GetBiasCurrent: boolean;
begin
 Result:=GetPattern(Pointer(st_aBiasCur));
end;

function TST2829C.GetBiasEnable: boolean;
begin
 Result:=GetPattern(Pointer(st_aBiasEn));
end;

function TST2829C.GetBiasVoltage: boolean;
begin
 Result:=GetPattern(Pointer(st_aBiasVol));
end;

function TST2829C.GetCorrectionCable: boolean;
begin
 Result:=GetPattern(Pointer(st_aCorCable));
end;

function TST2829C.GetCorrectionOpenEnable: boolean;
begin
 Result:=GetPattern(Pointer(st_aOpenState));
end;

function TST2829C.GetCorrectionShortEnable: boolean;
begin
  Result:=GetPattern(Pointer(st_aShortState));
end;

function TST2829C.GetCorrectionSpotFreq(SpotNumber: byte): boolean;
begin
 fCorrections.SpotActiveNumber:=SpotNumber;
 fCorrections.fSpotActiveFreq:=0;
 Result:=GetPattern(Pointer(st_aCorSpotFreq));
end;

function TST2829C.GetCorrectionSpotState(
  SpotNumber: byte): boolean;
begin
 fCorrections.SpotActiveNumber:=SpotNumber;
 Result:=GetPattern(Pointer(st_aCorSpotState));
end;

function TST2829C.GetCurrentMeasurement: boolean;
begin
 Result:=GetPattern(Pointer(st_aIMeas));
end;

function TST2829C.GetData: boolean;
begin
//FETC?
 Result:=GetPattern(Pointer(st_aGetMeasData));
end;

function TST2829C.GetDataIrms: boolean;
begin
//FETC:SMON:IAC?
 Result:=GetPattern(Pointer(st_aGetIrms));
end;

function TST2829C.GetDataVrms: boolean;
begin
//FETC:SMON:VAC?
 Result:=GetPattern(Pointer(st_aGetVrms));
end;

function TST2829C.GetDelayTime: boolean;
begin
 Result:=GetPattern(Pointer(st_aTrigDelay));
end;

function TST2829C.GetDisplayFont: boolean;
begin
 Result:=GetPattern(Pointer(st_aChangFont));
// QuireOperation(4,3);
// Result:=(fDevice.Value<>ErResult);
end;

function TST2829C.GetDisplayPage: boolean;
begin
 Result:=GetPattern(Pointer(st_aDispPage));
// QuireOperation(4,2);
// Result:=(fDevice.Value<>ErResult);
end;

function TST2829C.GetFrequancyMeasurement: boolean;
begin
 Result:=GetPattern(Pointer(st_aFreqMeas));
end;

function TST2829C.GetMeasureFunction: boolean;
begin
 Result:=GetPattern(Pointer(st_aSetMeasT));
end;

function TST2829C.GetMeasureSpeed: boolean;
begin
 Result:=GetPattern(Pointer(st_aSpeedMeas));
end;

function TST2829C.GetOutputImpedance: boolean;
begin
 Result:=GetPattern(Pointer(st_aOutImp));
end;

function TST2829C.GetRange: boolean;
begin
 Result:=GetPattern(Pointer(st_aRange));
end;

function TST2829C.GetRangePattern(Action: TST2829CAction): boolean;
begin

 QuireOperation(ActionToRootNodeNumber(Action),
                ActionToFirstNode(Action),1);
 Result:=SuccessfulGet(Action);

 if fDevice.Value=1
   then fMPars.MeasureRange:=st_rAuto
   else
    begin
      try
        QuireOperation(ActionToRootNodeNumber(Action),
                       ActionToFirstNode(Action),2);
        Result:=SuccessfulGet(Action);
        if Result then
              begin
               if ((round(fDevice.Value) mod 3) = 0 )
                 then fMPars.MeasureRange:=TST2829C_Range(round(Log10(fDevice.Value/3)*2))
                 else fMPars.MeasureRange:=TST2829C_Range(round(Log10(fDevice.Value)*2-1));
              end;
      except
       Result:=False;
      end;
    end;
end;

function TST2829C.GetRootNodeString: string;
begin
 Result:=RootNodeST2829C[fRootNode];
end;

function TST2829C.GetTrigerSource: boolean;
begin
  Result:=GetPattern(Pointer(st_aTrigSource));
end;

function TST2829C.GetIrmsToMeasure: boolean;
begin
 Result:=GetPattern(Pointer(st_aIrmsToMeas));
end;

function TST2829C.GetVrmsToMeasure: boolean;
begin
 Result:=GetPattern(Pointer(st_aVrmsToMeas));
end;

function TST2829C.GtAutoLevelControlEnable: boolean;
begin
 Result:=fMPars.AutoLevelControlEnable;
end;

function TST2829C.GtCorCable: TST2829C_CorCable;
begin
  Result:=fCorrections.fCable;
end;

function TST2829C.GtCorOpenEnable: boolean;
begin
 Result:=fCorrections.fOpenEnable;
end;

function TST2829C.GtCorShortEnable: boolean;
begin
 Result:=fCorrections.fShortEnable;
end;

function TST2829C.GtFreqMeas: double;
begin
 Result:=fMPars.FreqMeas;
end;

function TST2829C.GtIrmsMeas: double;
begin
 Result:=fMPars.IrmsMeas;
end;

function TST2829C.GtMeasureRange: TST2829C_Range;
begin
 Result:=fMPars.MeasureRange;
end;

function TST2829C.GtMeasureSpeed: TST2829C_MeasureSpeed;
begin
 Result:=fMPars.MeasureSpeed;
end;

function TST2829C.GtMeasureType: TST2829C_MeasureType;
begin
 Result:=fMPars.MeasureType;
end;

function TST2829C.GtOutputImpedance: TST2829C_OutputImpedance;
begin
 Result:=fMPars.OutputImpedance;
end;

function TST2829C.GtVrmsMeas: double;
begin
 Result:=fMPars.VrmsMeas;
end;

function TST2829C.GetPattern(Action: Pointer): boolean;
 var Act:TST2829CAction;
begin
  Act:=TST2829CAction(Action);
  SetMeasuringTiming(Act);

  Result:=False;
  if Act=st_aRange then
   begin
     Result:=GetRangePattern(Act);
     Exit;
   end;

  try
    GetPrepareAction(Act);
    if not(PermitedGetAction(Act)) then Exit;

    QuireOperation(ActionToRootNodeNumber(Act),
                   ActionToFirstNode(Act),
                   ActionToLeafNode(Act),
                   ActionToSyffix(Act));
    Result:=SuccessfulGet(Act);
    if Result
      then GetActionProcedure(Act);
  except
//   Result:=False;
  end;
end;

procedure TST2829C.GetPrepareAction(Action: TST2829CAction);
begin
 case Action of
   st_aTrg,
   st_aGetMeasData: begin
                    fPrimaryData:=ErResult;
                    fSecondaryData:=ErResult;
                    end;
   st_aGetVrms: fVrmsData:=ErResult;
   st_aGetIrms: fIrmsData:=ErResult;
 end;
end;

function TST2829C.GetVoltageMeasurement: boolean;
begin
 Result:=GetPattern(Pointer(st_aVMeas));
end;

function TST2829C.HighForStrParsing: byte;
begin
 Result:=0;
 case fRootNode of
  4:case fFirstLevelNode of
    2:Result:=ord(High(ST2829C_DisplayPageCommand));
    3:Result:=ord(High(TST2829C_Font));
    end;
  11:case fFirstLevelNode of
     8:Result:=ord(High(TST2829C_MeasureType));
     end;
  12:Result:=ord(High(TST2829C_MeasureSpeed));
  13:Result:=ord(High(TST2829C_TrigerSource));
  15:case fFirstLevelNode of
     16:Result:=ord(High(TST2829C_CorCable));
     end;
 end;
end;

function TST2829C.ItIsRequiredStr(Str: string; i: byte): boolean;
begin
 Result:=False;
 case fRootNode of
  4:case fFirstLevelNode of
    2:Result:=(Pos(ST2829C_DisplayPageResponce[TST2829C_DisplayPage(i)],Str)<>0);
    3:Result:=(Pos(ST2829C_FontCommand[TST2829C_Font(i)],Str)<>0);
    end;
  11:case fFirstLevelNode of
     8:Result:=(Pos(ST2829C_MeasureTypeCommands[TST2829C_MeasureType(i)],Str)<>0);
     end;
  12:if i<ord(st_msFastPlus)
        then Result:=(Pos(ST2829C_MeasureSpeedCommands[TST2829C_MeasureSpeed(i)]+' ',Str)<>0)
        else Result:=(Pos(ST2829C_MeasureSpeedCommands[TST2829C_MeasureSpeed(i)],Str)<>0);
  13:Result:=(Pos(ST2829C_TrigerSourceCommands[TST2829C_TrigerSource(i)],Str)<>0);
  15:case fFirstLevelNode of
     16:Result:=(Pos(ST2829C_CorCableCommands[TST2829C_CorCable(i)],Str)<>0);
     end;
 end;
end;

procedure TST2829C.LoadSetup(RecordNumber: TST2829C_SetupMemoryRecord);
begin
// *MMEM:LOAD:STAT <record number>
 SetPattern([Pointer(st_aMemLoad),Pointer(RecordNumber)]);
// fAdditionalString:=inttostr(RecordNumber);
// SetupOperation(3);
end;

procedure TST2829C.MyTraining;
 var i:Integer;
     tempDouble:double;
begin
// (fDevice as TST2829CDevice).SetStringToSend('BIAS:CURR -0.1');
// fDevice.Request;
// (fDevice as TST2829CDevice).SetStringToSend('CORR:SHOR');
// fDevice.GetData;

//showmessage(inttostr(Corrections.SpotActiveNumber));

//  SetCorrectionSpotState(1,True);
// if GetCorrectionSpotState(1) then
//   showmessage(booltostr(fCorrections.fSpotActiveState,True));
// SetCorrectionSpotState(202,False);
// if GetCorrectionSpotState(202) then
//   showmessage(booltostr(fCorrections.fSpotActiveState,True));
////
//
//  SetCorrectionSpotFreq(18,4.256e4);
// if GetCorrectionSpotFreq(18) then
//   showmessage(floattostr(fCorrections.fSpotActiveFreq));
// SetCorrectionSpotFreq(20,1e7);
// if GetCorrectionSpotFreq(20) then
//   showmessage(floattostr(fCorrections.fSpotActiveFreq));
//
//   SetCorrectionSpotOpen(2);
//   SetCorrectionSpotShort(3);



//  SetCorrectionOpenMeasuring();
//
//  SetCorrectionShortMeasuring();
//
//  SetCorrectionOpenEnable(True);
// if GetCorrectionOpenEnable() then
//   showmessage(booltostr(CorectionOpenEnable,True));
// SetCorrectionOpenEnable(False);
// if GetCorrectionOpenEnable() then
//   showmessage(booltostr(CorectionOpenEnable,True));
//
//  SetCorrectionShortEnable(True);
// if GetCorrectionShortEnable() then
//   showmessage(booltostr(CorectionShortEnable,True));
// SetCorrectionShortEnable(False);
// if GetCorrectionShortEnable() then
//   showmessage(booltostr(CorectionShortEnable,True));


showmessage('t_0='+inttostr(t_0())+#10#13
            +'t_m='+inttostr(t_meas())+#10#13
            +'N='+inttostr(N_meas()));

//showmessage(inttostr(fDevice.MinDelayTime)+#10#13
//            +inttostr(fDevice.DelayTimeStep)+#10#13
//            +inttostr(fDevice.DelayTimeMax));
//  fMinDelayTime:=0;
//  fDelayTimeStep:=10;
//  fDelayTimeMax:=130;
//  GetCorrectionCable();
//  SetCorrectionCable(st_cc1M);
//  GetCorrectionCable();
//  SetCorrectionCable(st_cc0M);

//  for I := 0 to ord(High(TST2829C_CorCable)) do
//   begin
//     SetCorrectionCable(TST2829C_CorCable(i));
//     if (GetCorrectionCable() and(i=ord(CorectionCable)))
//      then showmessage('Ura!!!');
//   end;

//----------------------------------------------------
//Trig();

//  GetData();
//  showmessage(floattostr(DataPrimary));
//  showmessage(floattostr(DataSecondary));

//  SetVrmsToMeasure(True);
//  GetDataVrms();
// showmessage(floattostr(DataVrms));
//  SetIrmsToMeasure(True);
//  GetDataIrms();
// showmessage(floattostr(DataIrms));
// tempDouble:=10;
// SetDelayTime(round(tempDouble));
// if GetDelayTime()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(DelayTime));
// tempDouble:=-10;
// SetDelayTime(round(tempDouble));
// if GetDelayTime()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(DelayTime));
// tempDouble:=12345;
// SetDelayTime(round(tempDouble));
// if GetDelayTime()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(DelayTime));

//  for I := 0 to ord(High(TST2829C_TrigerSource)) do
//   begin
//     SetTrigerSource(TST2829C_TrigerSource(i));
//     if (GetTrigerSource() and(i=ord(fTrigSource)))
//      then showmessage('Ura!!!');
//   end;


//Trigger();

// tempDouble:=1.2345678;
// SetBiasCurrent(tempDouble);
// if GetBiasCurrent()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasCurrentValue));

// tempDouble:=-150;
// SetBiasCurrent(tempDouble);
// if GetBiasCurrent()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasCurrentValue));

// if GetBiasVoltage()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasVoltageValue));

// tempDouble:=-11.987654321;
// SetBiasCurrent(tempDouble);
// if GetBiasCurrent()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasCurrentValue));

//--------------------------------------------------------

//GetMeasureSpeed();
//SetAverTime(5);
//GetAverTime();
//Showmessage(inttostr(AverTimes));
//
//SetAverTime(0);
//GetAverTime();
//Showmessage(inttostr(AverTimes));
//
//SetAverTime(115);
//GetAverTime();
//Showmessage(inttostr(AverTimes));



//  for I := 0 to ord(High(TST2829C_MeasureSpeed)) do
//   begin
//     SetMeasureSpeed(TST2829C_MeasureSpeed(i));
//     if (GetMeasureSpeed() and(i=ord(fMeasureSpeed)))
//      then showmessage('Ura!!!');
//   end;


// SetShowVrms(False);
// GetShowVrms();
// SetShowVrms(True);
// GetShowVrms();
//
// SetShowIrms(False);
// GetShowIrms();
// SetShowIrms(True);
// GetShowIrms();


//  for I := 0 to ord(High(TST2829C_Range)) do
//   begin
//     SetRange(TST2829C_Range(i));
//     if (GetRange() and(i=ord(fMeasureRange)))
//      then showmessage('Ura!!!');
//   end;



//  for I := 0 to ord(High(TST2829C_MeasureType)) do
//   begin
//     SetMeasureFunction(TST2829C_MeasureType(i));
//     if (GetMeasureFunction() and(i=round(fDevice.Value)))
//      then showmessage('Ura!!!');
//   end;



//  for I := 0 to ord(High(TST2829C_OutputImpedance)) do
//   begin
//     SetOutputImpedance(TST2829C_OutputImpedance(i));
//     if (GetOutputImpedance() and(TST2829C_OutputImpedance(i)=OutputImpedance))
//      then showmessage('Ura!!!');
//   end;



// tempDouble:=1.2345678;
// SetBiasVoltage(tempDouble);
// if GetBiasVoltage()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasVoltageValue));
//
// tempDouble:=-15;
// SetBiasVoltage(tempDouble);
// if GetBiasVoltage()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasVoltageValue));
//
// tempDouble:=-1.987654321;
// SetBiasVoltage(tempDouble);
// if GetBiasVoltage()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasVoltageValue));



// SetBiasEnable(True);
// if GetBiasEnable() then
//   showmessage(booltostr(BiasEnable,True));
// SetBiasEnable(False);
// if GetBiasEnable() then
//   showmessage(booltostr(BiasEnable,True));


// SetVoltageMeasurement(0.015);

//SetAutoLevelEnable(False);
//GetAutoLevelEnable();
//SetCurrentMeasurement(0.07);
//GetAutoLevelEnable();
//SetAutoLevelEnable(True);
//GetAutoLevelEnable();

// ST2829C_VmrsMeasLimits:TLimitValues=(0.005,10);
// ST2829C_ImrsMeasLimits:TLimitValues=(0.05,100);
// ST2829C_VmrsMeasLimitsForAL:TLimitValues=(0.01,5);
// ST2829C_ImrsMeasLimitsForAL:TLimitValues=(0.1,50);

// tempDouble:=1.2345678;
// SetCurrentMeasurement(tempDouble);
// if GetCurrentMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(IrmsMeas));

// tempDouble:=11.12345678;
// SetCurrentMeasurement(tempDouble);
// if GetCurrentMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(IrmsMeas));



// tempDouble:=0.1;
// SetVoltageMeasurement(tempDouble);
// if GetVoltageMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(VrmsMeas));
//
// tempDouble:=2.5;
// SetVoltageMeasurement(tempDouble);
// if GetVoltageMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(VrmsMeas));
// tempDouble:=0.12345678;
// SetVoltageMeasurement(tempDouble);
// if GetVoltageMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(VrmsMeas));


//----------------------------------------

// SetAutoLevelEnable(True);
// if GetAutoLevelEnable() then
//   showmessage(booltostr(AutoLevelControlEnable,True));
// SetAutoLevelEnable(False);
// if GetAutoLevelEnable() then
//   showmessage(booltostr(AutoLevelControlEnable,True));

// tempDouble:=4567;
// SetFrequancyMeasurement(tempDouble);
// if GetFrequancyMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(FreqMeas));
// tempDouble:=1.25e5;
// SetFrequancyMeasurement(tempDouble);
// if GetFrequancyMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(FreqMeas));
//  tempDouble:=1.25e6;
// SetFrequancyMeasurement(tempDouble);
// if GetFrequancyMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(FreqMeas));
//  tempDouble:=15;
// SetFrequancyMeasurement(tempDouble);
// if GetFrequancyMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(FreqMeas));
// tempDouble:=438.12345;
// SetFrequancyMeasurement(tempDouble);
// if GetFrequancyMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(FreqMeas));
//
//
// GetFrequancyMeasurement();
// SetFrequancyMeasurement(4567);
// SetFrequancyMeasurement(1.25e5);
// SetFrequancyMeasurement(1.25e6);
// SetFrequancyMeasurement(15);
// SetFrequancyMeasurement(438.12345);



//  QuireOperation(4,4);

//  for I := 0 to ord(High(TST2829C_Font)) do
//   begin
//     SetDisplayFont(TST2829C_Font(i));
//     if (GetDisplayFont() and(i=round(fDevice.Value)))
//      then showmessage('Ura!!!');
//   end;
// SetDisplayFont(st_lLarge);

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


function TST2829C.N_meas: integer;
begin
 if (AverTimes=1)
    and(MeasureSpeed in [st_msFast,st_msFastPlus])
    and(FreqMeas<10000)
   then Result:=0
   else Result:=AverTimes;
 if AutoLevelControlEnable then Result:=Result*2;
end;

procedure TST2829C.OnOffFromBool(toOn: boolean);
begin
 if toOn then fAdditionalString:=SuffixST2829C[0]
         else fAdditionalString:=SuffixST2829C[1];
end;

function TST2829C.PermitedAction(Action: TST2829CAction): boolean;
begin
 case Action of
   st_aALE: Result:=ValueInMap(fMPars.VrmsMeas,ST2829C_VmrsMeasLimitsForAL)
                     and ValueInMap(fMPars.IrmsMeas,ST2829C_ImrsMeasLimitsForAL);
   st_aOutImp:Result:=not(fBiasEnable);
   else Result:=true;
 end;
end;

function TST2829C.PermitedGetAction(Action: TST2829CAction): boolean;
begin
 case Action of
   st_aGetVrms:Result:=fVrmsToMeasure;
   st_aGetIrms:Result:=fIrmsToMeasure;
   else Result:=true;
 end;
end;

procedure TST2829C.PrepareStringByRootNode;
begin
 case fRootNode of
  3,4,9:JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
  11:case fFirstLevelNode of
      8:begin
        JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
        case fLeafNode of
          1:begin
             JoinToStringToSend(FirstNodeST2829C[9]);
             JoinToStringToSend(FirstNodeST2829C[10]);
            end;
          2:JoinToStringToSend(FirstNodeST2829C[9]);
        end;
        end;
      11:begin
          JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
          JoinToStringToSend(FirstNodeST2829C[fLeafNode]);
         end;
     end;
  13:case fFirstLevelNode of
//         0:
     14,15:JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
     end;
  14:case fLeafNode of
     12,13:begin
            JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
            JoinToStringToSend(FirstNodeST2829C[fLeafNode]);
           end;
     end;
  15:case fFirstLevelNode of
      16:JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
      17,18:case fLeafNode of
            0:JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
            5:begin
              JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
              JoinToStringToSend(FirstNodeST2829C[fLeafNode]);
              end;
            end;
      19:begin
          JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]
                            +IntTostr(fCorrections.SpotActiveNumber));
          if fLeafNode=100
            then JoinToStringToSend(':'+RootNodeST2829C[5])
            else JoinToStringToSend(FirstNodeST2829C[fLeafNode]);
         end;
     end;
  end;
end;


procedure TST2829C.ProcessingStringByRootNode(Str: string);
begin
 case fRootNode of
  0:if pos(ST2829C_Test,Str)<>0 then fDevice.Value:=314;
  2:StrToData(Str);
  4:StringToOrd(AnsiLowerCase(Str));
  5,7,
  8,10:fDevice.Value:=SCPI_StringToValue(Str);
  6:fDevice.Value:=StrToInt(Str);
  9:case fFirstLevelNode of
     5:fDevice.Value:=StrToInt(Str);
     6,7:fDevice.Value:=SCPI_StringToValue(Str);
    end;
  11:case fFirstLevelNode of
      8:case fLeafNode of
         0:StringToOrd(AnsiLowerCase(Str));
         1:fDevice.Value:=StrToInt(Str);
         2:fDevice.Value:=SCPI_StringToValue(Str);
        end;
      11:fDevice.Value:=StrToInt(Str);
     end;
  12:case fFirstLevelNode of
     0:StringToOrd(AnsiLowerCase(Str));
     1:fDevice.Value:=StrToInt(Copy(Str,Pos(',',Str)+1,Length(Str)));
     end;
  13:case fFirstLevelNode of
     14:StringToOrd(AnsiLowerCase(Str));
     15:fDevice.Value:=SCPI_StringToValue(Str);
     end;
  14:case fFirstLevelNode of
      0:StrToData(Str);
      11: fDevice.Value:=SCPI_StringToValue(Str);
     end;
   15:case fFirstLevelNode of
       16:StringToOrd(AnsiLowerCase(Str));
       17,18:fDevice.Value:=StrToInt(Str);
       19:case fLeafNode of
           5:fDevice.Value:=StrToInt(Str);
           100:fDevice.Value:=SCPI_StringToValue(Str);
          end;
      end;
 end;
end;

procedure TST2829C.ResetSetting;
begin
//  *RST
  SetPattern([Pointer(st_aReset)])
//  SetupOperation(1,0,0,False);
end;

procedure TST2829C.SaveSetup(RecordNumber: TST2829C_SetupMemoryRecord;RecordName:string='');
begin
// *MMEM:STOR:STAT <record number>,“<string>”
 SetPattern([Pointer(st_aMemSave),Pointer(RecordNumber),@RecordName]);
end;


procedure TST2829C.SetAutoLevelEnable(toOn: boolean);
begin
//AMPL:ALC ON|OFF
 SetPattern([Pointer(st_aALE),@toOn]);
end;

procedure TST2829C.SetAverTime(AverTime: byte);
begin
//APER <MeasSpeed>, <AverTime>
 SetPattern([Pointer(st_aAverTimes),@AverTime]);
end;

procedure TST2829C.SetBiasCurrent(I: double);
begin
//BIAS:CURR <I>
 SetPattern([Pointer(st_aBiasCur),@I]);
end;

procedure TST2829C.SetBiasEnable(toOn: boolean);
begin
//BIAS:STAT ON|OFF
 SetPattern([Pointer(st_aBiasEn),@toOn]);
end;

procedure TST2829C.SetBiasVoltage(V: double);
begin
//BIAS:VOLT <V>
 SetPattern([Pointer(st_aBiasVol),@V]);
end;

procedure TST2829C.SetCorrectionCable(Cable: TST2829C_CorCable);
begin
//“CORR:LENG <Cable>
 SetPattern([Pointer(st_aCorCable),Pointer(Cable)]);
end;

procedure TST2829C.SetCorrectionOpenEnable(toOn: boolean);
begin
//CORR:OPEN:STAT ON|OFF
 SetPattern([Pointer(st_aOpenState),@toOn]);
end;

procedure TST2829C.SetCorrectionOpenMeasuring;
begin
//“CORR:OPEN
 SetPattern([Pointer(st_aOpenMeas)]);
end;

procedure TST2829C.SetCorrectionShortEnable(toOn: boolean);
begin
//CORR:SHOT:STAT ON|OFF
 SetPattern([Pointer(st_aShortState),@toOn]);
end;

procedure TST2829C.SetCorrectionShortMeasuring;
begin
//“CORR:SHOR
 SetPattern([Pointer(st_aShortMeas)]);
end;

procedure TST2829C.SetCorrectionSpotFreq(SpotNumber: byte; Freq: double);
begin
//CORR:SPTO<SportNumber>:FREQ <Freq>
 SetPattern([Pointer(st_aCorSpotFreq),@SpotNumber,@Freq]);
end;

procedure TST2829C.SetCorrectionSpotOpen(SpotNumber: byte);
begin
//CORR:SPTO<SportNumber>:OPEN
 SetPattern([Pointer(st_aCorSpotOpen),@SpotNumber]);
end;

procedure TST2829C.SetCorrectionSpotShort(SpotNumber: byte);
begin
//CORR:SPTO<SportNumber>:SHOR
 SetPattern([Pointer(st_aCorSpotShort),@SpotNumber]);
end;

procedure TST2829C.SetCorrectionSpotState(SpotNumber: byte;
  toOn: boolean);
begin
//CORR:SPTO<SportNumber>:STAT ON|OFF
 SetPattern([Pointer(st_aCorSpotState),@SpotNumber,@toOn]);
end;

procedure TST2829C.SetCurrentMeasurement(I: double);
begin
//CURR <I>mA
 SetPattern([Pointer(st_aIMeas),@I]);
end;

procedure TST2829C.SetDelayTime(Time: Integer);
begin
//TRIG:DEL Time
 SetPattern([Pointer(st_aTrigDelay),@Time]);
end;

procedure TST2829C.SetDisplayFont(Font: TST2829C_Font);
begin
 //DISP:FRON <Font>
 SetPattern([Pointer(st_aChangFont),Pointer(Font)]);
// fAdditionalString:=TST2829C_FontCommand[Font];
// SetupOperation(4,3);
end;

procedure TST2829C.SetDisplayPage(Page: TST2829C_DisplayPage);
begin
//DISP:PAGE <Page>
 SetPattern([Pointer(st_aDispPage),Pointer(Page)]);
// fAdditionalString:=TST2829C_DisplayPageCommand[Page];
// SetupOperation(4,2);
end;

procedure TST2829C.SetFreqMeas(Value: Double);
begin
 fMPars.FreqMeas:=NumberMap(Value,ST2829C_FreqMeasLimits);
 fMPars.FreqMeas:=ValueWithMinResolution(fMPars.FreqMeas,1e-3);
end;

procedure TST2829C.SetFrequancyMeasurement(Freq: double);
begin
//FREQ <Freq>
 SetPattern([Pointer(st_aFreqMeas),@Freq]);
end;

procedure TST2829C.SetIrmsMeas(const Value: double);
begin
 fMPars.IrmsMeas:=NumberMap(Value,ST2829C_IrmsMeasLimits);
 if not(ValueInMap(fMPars.IrmsMeas,ST2829C_ImrsMeasLimitsForAL))
   then fMPars.AutoLevelControlEnable:=False;
 fMPars.IrmsMeas:=ValueWithMinResolution(fMPars.IrmsMeas,1e-4);
end;

procedure TST2829C.SetMeasureFunction(MF: TST2829C_MeasureType);
begin
//FUNC:IMP <MF>
 SetPattern([Pointer(st_aSetMeasT),Pointer(MF)]);
end;

procedure TST2829C.SetMeasureSpeed(Speed: TST2829C_MeasureSpeed);
begin
//APER <Speed>
 SetPattern([Pointer(st_aSpeedMeas),Pointer(Speed)]);
end;

procedure TST2829C.SetMeasuringTiming(Action: TST2829CAction);
begin
 case Action of
   st_aTrg: begin
             fDevice.MinDelayTime:=t_0()+t_meas()*N_meas();
             fDevice.DelayTimeStep:=max(5,round(fDevice.MinDelayTime*0.03));
            end;
   st_aGetVrms,
   st_aGetIrms:begin
                fDevice.MinDelayTime:=35;
                fDevice.DelayTimeStep:=5;
                end ;
   else begin
        fDevice.MinDelayTime:=0;
        fDevice.DelayTimeStep:=5;
        end;
 end;
  end;

procedure TST2829C.SetOutputImpedance(OI: TST2829C_OutputImpedance);
begin
//ORES <OI>
 SetPattern([Pointer(st_aOutImp),Pointer(OI)]);
end;

procedure TST2829C.SetPrepareAction(Ps: array of Pointer);
  var tempstr:string;
      Action: TST2829CAction;
begin
 Action:=TST2829CAction(Ps[0]);
 case Action of
   st_aMemLoad: fAdditionalString:=inttostr(TST2829C_SetupMemoryRecord(Ps[1]));
   st_aDispPage:fAdditionalString:=ST2829C_DisplayPageCommand[TST2829C_DisplayPage(Ps[1])] ;
   st_aChangFont:fAdditionalString:=ST2829C_FontCommand[TST2829C_Font(Ps[1])];
   st_aFreqMeas:begin
                FreqMeas:=PDouble(Ps[1])^;
                fAdditionalString:=FloatToStrF(FreqMeas,ffGeneral,7,0)+'Hz';
                end;
   st_aALE:begin
                AutoLevelControlEnable:=PBoolean(Ps[1])^;
                OnOffFromBool(AutoLevelControlEnable)
           end;
   st_aVMeas:begin
                VrmsMeas:=PDouble(Ps[1])^;
                fAdditionalString:=FloatToStrF(VrmsMeas,ffGeneral,7,0)+'V';
              end;
   st_aIMeas:begin
                IrmsMeas:=PDouble(Ps[1])^;
                fAdditionalString:=FloatToStrF(IrmsMeas,ffGeneral,7,0)+'mA';
             end;
   st_aMemSave:begin
               fAdditionalString:=inttostr(TST2829C_SetupMemoryRecord(Ps[1]));
               tempstr:=PString(Ps[2])^;
               if Length(tempstr)>0 then
                begin
                  if Length(tempstr)>ST2829C_MemFileMaxLength then SetLength(tempstr,ST2829C_MemFileMaxLength);
                  fAdditionalString:=fAdditionalString+', '+StringToInvertedCommas(tempstr);
                end;
               end;
   st_aBiasEn:begin
                BiasEnable:=PBoolean(Ps[1])^;
                if BiasEnable then OutputImpedance:=st_oi100;
                OnOffFromBool(BiasEnable);
              end;
   st_aBiasVol:begin
                BiasVoltageValue:=PDouble(Ps[1])^;
                fAdditionalString:=FloatToStrF(BiasVoltageValue,ffGeneral,7,0);
               end;
   st_aBiasCur:begin
                BiasCurrentValue:=PDouble(Ps[1])^;
                fAdditionalString:=FloatToStrF(BiasCurrentValue/1000,ffGeneral,7,0);
               end;
   st_aOutImp:begin
               OutputImpedance:=TST2829C_OutputImpedance(Ps[1]);
               fAdditionalString:=EnumerateToString(Action);
              end;
   st_aSetMeasT:begin
                 MeasureType:=TST2829C_MeasureType(Ps[1]);
                 fAdditionalString:=ST2829C_MeasureTypeCommands[TST2829C_MeasureType(Ps[1])];
                end;
    st_aRange:begin
                MeasureRange:=TST2829C_Range(Ps[1]);
                if MeasureRange=st_rAuto
                  then OnOffFromBool(True)
                  else fAdditionalString:=EnumerateToString(Action)+'Ohm';
              end;
    st_aVrmsToMeas:begin
                    VrmsToMeasure:=PBoolean(Ps[1])^;
                    OnOffFromBool(VrmsToMeasure);
                   end;
    st_aIrmsToMeas:begin
                    IrmsToMeasure:=PBoolean(Ps[1])^;
                    OnOffFromBool(IrmsToMeasure);
                   end;
    st_aSpeedMeas:begin
                  MeasureSpeed:=TST2829C_MeasureSpeed(Ps[1]);
                  fAdditionalString:=ST2829C_MeasureSpeedCommands[MeasureSpeed];
                  end;
    st_aAverTimes:begin
                  AverTimes:=PByte(Ps[1])^;
                  fAdditionalString:=ST2829C_MeasureSpeedCommands[MeasureSpeed]
                         +', '+Inttostr(AverTimes);
                  end;
    st_aTrigSource:begin
                   TrigSource:=TST2829C_TrigerSource(Ps[1]);
                   fAdditionalString:=ST2829C_TrigerSourceCommands[TrigSource];
                   end;
    st_aTrigDelay:begin
                   DelayTime:=PInteger(Ps[1])^;
                   fAdditionalString:=FloatToStrF(DelayTime/1000,ffGeneral,5,0);
                  end;
    st_aCorCable:begin
                   CorectionCable:=TST2829C_CorCable(Ps[1]);
                   fAdditionalString:=ST2829C_CorCableCommands[CorectionCable];
                  end;
    st_aOpenState:begin
                   CorectionOpenEnable:=PBoolean(Ps[1])^;
                   OnOffFromBool(CorectionOpenEnable);
                  end;
    st_aShortState:begin
                   CorectionShortEnable:=PBoolean(Ps[1])^;
                   OnOffFromBool(CorectionShortEnable);
                  end;
    st_aCorSpotState:begin
                   fCorrections.SpotActiveNumber:=PByte(Ps[1])^;
                   fCorrections.fSpotActiveState:=PBoolean(Ps[2])^;
                   OnOffFromBool(fCorrections.fSpotActiveState);
                  end;
    st_aCorSpotFreq:begin
                   fCorrections.SpotActiveNumber:=PByte(Ps[1])^;
                   fCorrections.SpotActiveFreq:=PDouble(Ps[2])^;
                   fAdditionalString:=FloatToStrF(fCorrections.SpotActiveFreq,ffGeneral,7,0)+'Hz';
                  end;
    st_aCorSpotShort:begin
                   fCorrections.SpotActiveNumber:=PByte(Ps[1])^;
                  end;
    st_aCorSpotOpen:begin
                   fCorrections.SpotActiveNumber:=PByte(Ps[1])^;
                  end;
  else;
 end;

end;

procedure TST2829C.SetRange(Range: TST2829C_Range);
begin
//FUNC:IMP:RANG <Range>
//FUNC:IMP:RANG:AUTO ON|OFF
 SetPattern([Pointer(st_aRange),Pointer(Range)]);
end;

procedure TST2829C.SetTrigerSource(Source: TST2829C_TrigerSource);
begin
//TRIG:SOUR <Source>
 SetPattern([Pointer(st_aTrigSource),Pointer(Source)]);
end;

procedure TST2829C.SetIrmsToMeasure(toOn: boolean);
begin
//FUNC:SMON:IAC ON|OFF
 SetPattern([Pointer(st_aIrmsToMeas),@toOn]);
end;

procedure TST2829C.SetVrmsToMeasure(toOn: boolean);
begin
//FUNC:SMON:VAC ON|OFF
 SetPattern([Pointer(st_aVrmsToMeas),@toOn]);
end;

procedure TST2829C.SetVoltageMeasurement(V: double);
begin
//VOLT <V>V
 SetPattern([Pointer(st_aVMeas),@V]);
end;

procedure TST2829C.SetVrmsMeas(const Value: double);
begin
 fMPars.VrmsMeas:=NumberMap(Value,ST2829C_VrmsMeasLimits);
 if not(ValueInMap(fMPars.VrmsMeas,ST2829C_VmrsMeasLimitsForAL))
   then fMPars.AutoLevelControlEnable:=False;
 fMPars.VrmsMeas:=ValueWithMinResolution(fMPars.VrmsMeas,1e-3);
end;

procedure TST2829C.StAutoLevelControl(const Value: boolean);
begin
  fMPars.AutoLevelControlEnable := Value and ValueInMap(fMPars.VrmsMeas,ST2829C_VmrsMeasLimitsForAL)
                                   and ValueInMap(fMPars.IrmsMeas,ST2829C_ImrsMeasLimitsForAL);
end;

procedure TST2829C.StAverTimes(const Value: byte);
begin
 fAverTimes:=NumberMap(Value,ST2829C_AverTimes);
end;

procedure TST2829C.StBiasCurrentValue(const Value: double);
begin
 fBiasCurrentValue:=NumberMap(Value,ST2829C_BiasCurrentLimits);
 fBiasCurrentValue:=ValueWithMinResolution(fBiasCurrentValue,5e-3);
end;

procedure TST2829C.StBiasVoltageValue(const Value: double);
begin
 fBiasVoltageValue:=NumberMap(Value,ST2829C_BiasVoltageLimits);
 fBiasVoltageValue:=ValueWithMinResolution(fBiasVoltageValue,5e-4);
end;

procedure TST2829C.StCorCable(const Value: TST2829C_CorCable);
begin
 fCorrections.fCable:=Value;
end;

procedure TST2829C.StCorOpenEnable(const Value: boolean);
begin
 fCorrections.fOpenEnable:=Value;
end;

procedure TST2829C.StCorShortEnable(const Value: boolean);
begin
 fCorrections.fShortEnable:=Value;
end;

procedure TST2829C.StDelayTime(const Value: integer);
begin
 fDelayTime:=NumberMap(Value,ST2829C_DelayTime);
end;

procedure TST2829C.StMeasureRange(const Value: TST2829C_Range);
begin
 fMPars.MeasureRange:=Value;
end;

procedure TST2829C.StMeasureSpeed(const Value: TST2829C_MeasureSpeed);
begin
  fMPars.MeasureSpeed:=Value;
end;

procedure TST2829C.StMeasureType(const Value: TST2829C_MeasureType);
begin
  fMPars.MeasureType:=Value;
end;

procedure TST2829C.StOutputImpedance(const Value: TST2829C_OutputImpedance);
begin
  fMPars.OutputImpedance:=Value;
end;

procedure TST2829C.StrToData(Str: string);
begin
  try
  Str:=SomeSpaceToOne(AnsiReplaceStr(Str,',',' '));
  fPrimaryData:=FloatDataFromRow(Str,1);
  if NumberOfSubstringInRow(Str)>1
    then fSecondaryData:=FloatDataFromRow(Str,2)
    else fSecondaryData:=ErResult;
  fDevice.Value:=fPrimaryData;
  except
  fPrimaryData:=ErResult;
  fSecondaryData:=ErResult;
  end;
end;

function TST2829C.SuccessfulGet(Action: TST2829CAction): boolean;
begin
  Result:=(fDevice.Value<>ErResult);
  case Action of
    st_aFreqMeas,
    st_aCorSpotFreq: Result:=((fDevice.Value<>ErResult)and(fDevice.isReceived));
  end;
end;

procedure TST2829C.SetPattern(Ps: array of Pointer);
 var  Action: TST2829CAction;
begin
 Action:=TST2829CAction(Ps[0]);
 if PermitedAction(Action) then
 begin
   SetPrepareAction(Ps);
   SetupOperation(ActionToRootNodeNumber(Action),ActionToFirstNode(Action),
                  ActionToLeafNode(Action),ActionToSyffix(Action));
 end;
end;

procedure TST2829C.Trig;
begin
//  *TRG
//  SetPattern([Pointer(st_aTrg)]);
  GetPattern(Pointer(st_aTrg));
end;

procedure TST2829C.Trigger;
begin
// TRIG
 SetPattern([Pointer(st_aTriger)]);
end;

function TST2829C.t_0: integer;
begin
 if FreqMeas<100
    then
     begin
      if AutoLevelControlEnable
          then Result:=1696
          else Result:=898;
     end
    else
     begin
     if FreqMeas<1000
      then
       begin
        if AutoLevelControlEnable
            then Result:=448
            else Result:=257;
       end
      else
       begin
         if FreqMeas<10000
          then
           begin
            if AutoLevelControlEnable
                then Result:=140
                else Result:=90;
           end
          else
           begin
            if MeasureSpeed=st_msFastPlus
              then
               begin
                if AutoLevelControlEnable
                    then Result:=90
                    else Result:=80;
               end
             else
               begin
                if AutoLevelControlEnable
                    then Result:=100
                    else Result:=90;
               end
           end
       end;
     end;
end;

function TST2829C.t_meas: integer;
begin
 if FreqMeas<100
  then
   begin
     if MeasureSpeed=st_msSlow
      then Result:=1600
      else Result:=800;
   end
  else
   begin
    if FreqMeas<1000
     then
      begin
       if MeasureSpeed=st_msSlow
        then Result:=840
        else Result:=180;
      end
     else
      begin
       if FreqMeas<10000
        then
         begin
          case MeasureSpeed of
           st_msSlow:Result:=670;
           st_msMed:Result:=97;
           else Result:=24;
          end;
         end
        else
         begin
          case MeasureSpeed of
           st_msSlow:Result:=650;
           st_msMed:Result:=85;
           st_msFast:Result:=14;
           else Result:=9;
          end;
         end;
      end;
   end;
end;

function TST2829C.ValueToOrd(Value: double; Action: TST2829CAction): integer;
begin
 case Action of
   st_aOutImp:case round(Value) of
//                 10:Result:=0;
                 30:Result:=0;
                 50:Result:=1;
                 100:Result:=2;
                 else Result:=-1;
              end ;
   else Result:=-1;
 end;
end;

{ T2829CDevice }


{ TST2829CDevice }

constructor TST2829CDevice.Create(SCPInew: TSCPInew; Nm: string);
begin
 inherited Create(SCPInew, Nm);
  fMinDelayTime:=0;
  fDelayTimeStep:=5;
  fDelayTimeMax:=100;
//   fMinDelayTime:=0;
//  fDelayTimeStep:=10;
//  fDelayTimeMax:=130;  
end;

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
end;


{ TST2829_Measurement }

constructor TST2829_Measurement.Create(ST2829C: TST2829C);
begin
 inherited Create;
 fParentModule:=ST2829C;
end;

function TST2829_Measurement.GetData: double;
begin
 fParentModule.Trig;
 fValue:=GetValueFromDevice;
 Result:=fValue;
 fNewData:=fParentModule.Device.NewData;
end;

function TST2829_Measurement.GetValueFromDevice: double;
begin
 Result:=fParentModule.DataPrimary;
end;

{ TST2829_MeterSecond }

constructor TST2829_MeterSecondary.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C);
 fName:='ST2829Secondary';
end;

function TST2829_MeterSecondary.GetValueFromDevice: double;
begin
 Result:=fParentModule.DataSecondary;
end;

{ TST2829_MeterPrimary }

constructor TST2829_MeterPrimary.Create(ST2829C: TST2829C);
begin
 fTimer:=TTimer.Create(nil);
 fTimer.Enabled:=False;
 fTimer.Interval:=2000;
 inherited Create(ST2829C);
 fName:='ST2829Primary';
end;

destructor TST2829_MeterPrimary.Destroy;
begin
  FreeAndNil(fTimer);
  inherited;
end;

function TST2829_MeterPrimary.GetMeasureModeLabel: string;
begin
 case fParentModule.MeasureType of
  st_mtCpD,
  st_mtCpQ,
  st_mtCpG,
  st_mtCpRp,
  st_mtCsD,
  st_mtCsQ,
  st_mtCsRs:Result:=' F';
  st_mtLpQ,
  st_mtLpD,
  st_mtLpG,
  st_mtLpRp,
  st_mLpZ,
  st_mtLsD,
  st_mtLsQ,
  st_mtLsRs,
  st_mLsZ:Result:=' H';
  st_mtDCR,
  st_mtRX,
  st_mRpQ,
  st_mRsQ,
  st_mtZTd,
  st_mtZTr,
  st_mZQ:Result:='Ohm';
  st_mtGB,
  st_mtYTd,
  st_mtYTr:Result:=' S';

 end;
end;

function TST2829_MeterPrimary.GetMeasureModeLabelTwo: string;
begin
// showmessage(ST2829C_MeasureTypeLabels[fParentModule.MeasureType]);
 case fParentModule.MeasureType of
  st_mtLsD,
  st_mtCpD,
  st_mtCsD,
  st_mtLpD,
  st_mtCpQ,
  st_mtCsQ,
  st_mtLpQ,
  st_mtLsQ,
  st_mRpQ,
  st_mRsQ,
  st_mZQ:Result:=' ';
  st_mtCpG,
  st_mtLpG:Result:=' S';
  st_mtCpRp,
  st_mtCsRs,
  st_mtLpRp,
  st_mtLsRs,
  st_mLpZ,
  st_mLsZ,
  st_mtRX:Result:='Ohm';
  st_mtZTd,
  st_mtYTd:Result:=' deg';
  st_mtZTr,
  st_mtYTr:Result:=' rad';
  st_mtGB:Result:=' S';
  st_mtDCR:Result:='---';
 end;
end;

function TST2829_MeterPrimary.GetValueFromDevice: double;
begin
 fValue2:=fParentModule.DataSecondary;
 Result:=fParentModule.DataPrimary;
end;

{ TST2829SweepParameters }

procedure TST2829SweepParameters.ActionMeasurement(const Value:double);
begin
  SetValue(Value);

// secondmeter.Start();

  fParentModule.Trig;

//    secondmeter.Finish();
//   Info:=Info+ floattostr(SecondMeter.Interval)+#13;

// secondmeter.Start();

  case  SweepType of
   st_spIrms:fParentModule.GetDataIrms();
   st_spVrms:fParentModule.GetDataVrms();
  end;

//    secondmeter.Finish();
//   Info:=Info+ floattostr(SecondMeter.Interval)+#13;
end;

procedure TST2829SweepParameters.AddData;
begin
  case DataType of
    st_sdPrim:fDataVector.Add(GetXData(),fParentModule.DataPrimary);
    st_sdSecon:fDataVector.Add(GetXData(),fParentModule.DataSecondary);
    st_sdBoth:begin
               fDataVector.Add(GetXData(),fParentModule.DataPrimary);
               fSecondDataVector.Add(GetXData(),fParentModule.DataSecondary);
              end;
  end;
end;

procedure TST2829SweepParameters.BeforeMeasuring;
begin
  fDataVector.Clear;
  fSecondDataVector.Clear;

  case SweepType of
   st_spBiasVolt:begin
                  fOldValue:=fParentModule.BiasVoltageValue;
                  fOldState:=fParentModule.BiasEnable;
                 end;
   st_spBiasCurr:begin
                  fOldValue:=fParentModule.BiasCurrentValue;
                  fOldState:=fParentModule.BiasEnable;
                 end;
   st_spFreq:fOldValue:=fParentModule.FreqMeas;
   st_spVrms:begin
              fOldValue:=fParentModule.VrmsMeas;
              fOldState:=fParentModule.VrmsToMeasure;
             end;
   st_spIrms:begin
              fOldValue:=fParentModule.IrmsMeas;
              fOldState:=fParentModule.IrmsToMeasure;
             end;
  end;


   case  SweepType of
   st_spBiasVolt,
   st_spBiasCurr: if not(fParentModule.BiasEnable)
                     then fParentModule.SetBiasEnable(True);
   st_spIrms:if not(fParentModule.IrmsToMeasure)
                     then fParentModule.SetIrmsToMeasure(True);
   st_spVrms:if not(fParentModule.VrmsToMeasure)
                     then fParentModule.SetVrmsToMeasure(True);
  end;

 fStepValue:=Step();
end;

constructor TST2829SweepParameters.Create(ST2829C:TST2829C);
begin
  inherited Create(ST2829C);
  SweepType:=st_spBiasVolt;
  StartValue:=0;
  FinishValue:=1;
  PointCount:=2;
  LogStep:=False;
  DataType:=st_sdPrim;
  fDataVector:=TVector.Create;
  fSecondDataVector:=TVector.Create;
end;

destructor TST2829SweepParameters.Destroy;
begin
  FreeAndNil(fDataVector);
  FreeAndNil(fSecondDataVector);
  inherited;
end;

procedure TST2829SweepParameters.EndMeasuring;
begin
  case  SweepType of
   st_spBiasVolt,
   st_spBiasCurr: if fParentModule.BiasEnable<>fOldState then
                      fParentModule.SetBiasEnable(fOldState);
   st_spIrms:if fParentModule.IrmsToMeasure<>fOldState then
                      fParentModule.SetIrmsToMeasure(fOldState);
   st_spVrms:if fParentModule.VrmsToMeasure<>fOldState then
                      fParentModule.SetVrmsToMeasure(False);
  end;
  SetValue(fOldValue);
end;

function TST2829SweepParameters.GetXData: double;
begin
 case SweepType of
    st_spBiasVolt:Result:=fParentModule.BiasVoltageValue;
    st_spBiasCurr:Result:=fParentModule.BiasCurrentValue;
    st_spFreq:Result:=fParentModule.FreqMeas;
    st_spVrms:Result:=fParentModule.DataVrms;
    else Result:=fParentModule.DataIrms;
  end;
end;

function TST2829SweepParameters.GetXValueAtStep(StepNumber: integer): double;
 var Mult:double;
begin
 Result:=0;
 if (StepNumber<0)or(StepNumber>(PointCount-1))
   then Exit;

 Mult:=fStepValue*StepNumber;

 if Mult=0 then
   begin
     Result:=StartValue;
     Exit;
   end;

 if LogStep
   then
    begin
     if FinishValue>=StartValue then
       begin
         if StartValue>0 then
              Result:=Power(10,log10(StartValue)+Mult);
         if StartValue=0 then
              Result:=Power(10,Mult);
         if StartValue<0 then
           begin
             if Mult<0 then Result:=-Power(10,log10(-StartValue)+Mult)
                       else
               begin
               if Mult=log10(-StartValue) then Result:=0;
               if Mult<log10(-StartValue)
                then Result:=-Power(10,log10(-StartValue)-Mult);
               if Mult>log10(-StartValue)
                then Result:=Power(10,-log10(-StartValue)+Mult);
               end;
           end;
       end                     else //FinishValue>=StartValue
       begin
         if FinishValue>=0 then
           begin
            if -Mult=log10(StartValue)
              then Result:=0
              else Result:=Power(10,log10(StartValue)+Mult);

           end             else   //FinishValue>=0
           begin
            if StartValue=0 then Result:=-Power(10,Mult);
            if StartValue>0 then
              begin
                if Mult=log10(StartValue) then Result:=0;
                if Mult<log10(StartValue)
                 then Result:=Power(10,log10(StartValue)-Mult);
                if Mult>log10(StartValue)
                 then Result:=-Power(10,-log10(StartValue)+Mult);
              end;
            if StartValue<0 then
                Result:=-Power(10,log10(-StartValue)+Mult)
           end;
       end;
    end
   else Result:=StartValue+Mult;

end;

function TST2829SweepParameters.GtMeasureType: TST2829C_MeasureType;
begin
 Result:=fParentModule.MeasureType;
end;

procedure TST2829SweepParameters.SaveDataToFile(FileName: string);
begin
 if DataType=st_sdBoth
   then ToFileFromTwoVector(FileName,fDataVector,fSecondDataVector,8)
   else fDataVector.WriteToFile(FileName,8);
end;

procedure TST2829SweepParameters.SetValue(Value: double);
begin
  case SweepType of
    st_spBiasVolt: fParentModule.SetBiasVoltage(Value);
    st_spBiasCurr: fParentModule.SetBiasCurrent(Value);
    st_spFreq: fParentModule.SetFrequancyMeasurement(Value);
    st_spVrms: fParentModule.SetVoltageMeasurement(Value);
    st_spIrms: fParentModule.SetCurrentMeasurement(Value);
  end;
end;

function TST2829SweepParameters.Step: double;
begin
 Result:=0;
 if (FinishValue=0)and(StartValue=0) then Exit;
 if LogStep
   then
    begin
     if FinishValue*StartValue>0
       then Result:=(log10(abs(FinishValue))-log10(abs(StartValue)))/(PointCount-1)
       else
        begin
          if FinishValue*StartValue<0 then Result:=(log10(abs(FinishValue))+log10(abs(StartValue)))/(PointCount-1);
          if FinishValue=0 then Result:=log10(abs(StartValue))/(PointCount-1);
          if StartValue=0 then Result:=log10(abs(FinishValue))/(PointCount-1);
        end;
    end
   else Result:=(FinishValue-StartValue)/(PointCount-1);
end;


function TST2829SweepParameters.ToString: string;
begin
 Result:=ST2829C_SweepParametrLabels[SweepType]+#10#13
        +ST2829C_SweepDataLabels[DataType]+#10#13
        +'Start='+floattostr(StartValue)+#10#13
        +'Finish='+floattostr(FinishValue)+#10#13
        +'Step Count='+inttostr(PointCount)+#10#13
        +'Log step='+booltostr(LogStep,True);
end;

{ TST2829Part }

constructor TST2829Part.Create(ST2829C: TST2829C);
begin
  inherited Create();
  fParentModule:=ST2829C;
end;

{ TST2829Corrections }

constructor TST2829Corrections.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C);
 fCable:=st_cc0M;
 fOpenEnable:=False;
 fShortEnable:=False;
 fSpotActiveNumber:=1;
 fSpotActiveFreq:=20;
 fSpotActiveState:=False;
end;

procedure TST2829Corrections.SetSpotActiveFreq(const Value: double);
begin
 fSpotActiveFreq:=TSCPInew.NumberMap(Value,ST2829C_FreqMeasLimits);
 fSpotActiveFreq:=TSCPInew.ValueWithMinResolution(fSpotActiveFreq,1e-3);

end;

procedure TST2829Corrections.SetSpotActiveNumber(const Value: byte);
begin
  fSpotActiveNumber := TSCPInew.NumberMap(Value,ST2829C_SpotNumber);
end;

initialization
  ST_2829C := TST2829C.Create();
  CF_ST_2829C:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'IVChar.ini');

finalization
  CF_ST_2829C.Free;
  ST_2829C.Free;

end.
