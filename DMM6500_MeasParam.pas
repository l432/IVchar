unit DMM6500_MeasParam;

interface

uses
   DMM6500_Const,Keitley2450Const,OlegTypePart2, SCPI;

type
IMeasPar_BaseVolt = interface
['{35862619-CBAB-450E-B22C-1F1CBC82516A}']
 function GetUnits:TDMM6500_VoltageUnits;
 function GetDB:double;
 function GetDBM:integer;
 function GetDBLimits:TLimitValues;
 function GetDBMLimits:TLimitValues;
 procedure SetUnits(const Value:TDMM6500_VoltageUnits);
 procedure SetDB(const Value:double);
 procedure SetDBM(const Value:integer);
 property Units: TDMM6500_VoltageUnits read GetUnits write SetUnits;
 property DB:double read GetDB write SetDB;
 property DBM:integer read GetDBM write SetDBM;
 property DBLimits:TLimitValues read GetDBLimits;
 property DBMLimits:TLimitValues read GetDBMLimits;
end;

IMeasPar_BaseVoltDC = interface
  ['{103051CD-4585-45BF-9D0D-D4C60A31FDAD}']
 function GetInputImpedance:TDMM6500_InputImpedance;
 procedure SetInputImpedance(const Value:TDMM6500_InputImpedance);
 property InputImpedance: TDMM6500_InputImpedance read GetInputImpedance write SetInputImpedance;
end;

TDMM6500MeasPar_Base=class(TSimpleFreeAndAiniObject)
//TDMM6500MeasPar_Base=class(TInterfacedObject)
 private
//  fCount:integer;
  fDisplayDN:TKeitleyDisplayDigitsNumber;
//  procedure SetCountNumber(Value: integer);virtual;
 public
//  property Count:integer read fCount write SetCountNumber;
  property DisplayDN:TKeitleyDisplayDigitsNumber read fDisplayDN write fDisplayDN;
  constructor Create;
end;

TDMM6500MeasPar_BaseDelay=class(TDMM6500MeasPar_Base)
 private
  fAutoDelay:boolean;
 public
  property AutoDelay: boolean read fAutoDelay write fAutoDelay;
  constructor Create;
end;

TDMM6500MeasPar_BaseDig=class(TDMM6500MeasPar_Base)
 private
  fSampleRate:TDMM6500_DigSampleRate;
  {кількість вимірів за секунду}
 public
  property SampleRate: TDMM6500_DigSampleRate read fSampleRate write fSampleRate;
  constructor Create;
end;


TDMM6500MeasPar_BaseVolt=class
 private
  fDBLimits:TLimitValues;
  fDBMLimits:TLimitValues;
  fUnits:TDMM6500_VoltageUnits;
  fDB:double;
  fDBM:integer;
  procedure SetDB(Value:double);
  procedure SetDBM(Value:integer);
 public
  property Units: TDMM6500_VoltageUnits read fUnits write fUnits;
  property DB:double read fDB write SetDB;
  property DBM:integer read fDBM write SetDBM;
  property DBLimits:TLimitValues read fDBLimits;
  property DBMLimits:TLimitValues read fDBMLimits;
  constructor Create;
end;

TDMM6500MeasPar_BaseVoltDC=class(TDMM6500MeasPar_BaseVolt)
 private
  fInputImpedance:TDMM6500_InputImpedance;
 public
  property InputImpedance: TDMM6500_InputImpedance read fInputImpedance write fInputImpedance;
  constructor Create;
end;

TDMM6500MeasPar_BaseAC=class(TDMM6500MeasPar_BaseDelay)
 private
  fDetectorBW:TDMM6500_DetectorBandwidth;
 public
  property DetectorBW: TDMM6500_DetectorBandwidth read fDetectorBW write fDetectorBW;
  constructor Create;
end;

//TDMM6500MeasPar_Continuity=class(TDMM6500MeasPar_BaseDelayMT)
TDMM6500MeasPar_Continuity=class(TDMM6500MeasPar_BaseDelay)
 private
  fAzeroState:boolean;
  fLineSync:boolean;
 public
  property AzeroState: boolean read fAzeroState write fAzeroState;
  property LineSync: boolean read fLineSync write fLineSync;
  constructor Create;
end;

TDMM6500MeasPar_BaseVoltDCRange=class(TDMM6500MeasPar_Continuity)
 private
  fRange:TDMM6500_VoltageDCRange;
 public
  property Range: TDMM6500_VoltageDCRange read fRange write fRange;
  constructor Create;
end;

//TDMM6500MeasPar_BaseDelayMT=class(TDMM6500MeasPar_BaseDelay)
TDMM6500MeasPar_BaseDelayMT=class(TDMM6500MeasPar_Continuity)
 private
  fMTLimits:TLimitValues;
  fMeaureTime:double;
  {час вимірювання, []=мс, для більшості 0,02-240}
//  fOffComp:TDMM6500_OffsetCompen;
//  fOpenLD:boolean;
  procedure SetMeaureTime(Value:double);
 public
  property MeaureTime: double read fMeaureTime write SetMeaureTime;
//  property OffsetComp: TDMM6500_OffsetCompen read fOffComp write fOffComp;
//  property OpenLeadDetector: boolean read fOpenLD write fOpenLD;
  constructor Create;
end;


//TDMM6500MeasPar_Base4WT=class(TDMM6500MeasPar_Continuity)
TDMM6500MeasPar_Base4WT=class(TDMM6500MeasPar_BaseDelayMT)
 private
  fOffComp:TDMM6500_OffsetCompen;
  fOpenLD:boolean;
 public
  property OffsetComp: TDMM6500_OffsetCompen read fOffComp write fOffComp;
  property OpenLeadDetector: boolean read fOpenLD write fOpenLD;
  constructor Create;
end;

//*******************************************************

TDMM6500MeasPar_DigVolt=class(TDMM6500MeasPar_BaseDig,IMeasPar_BaseVolt,IMeasPar_BaseVoltDC)
 private
  fRange:TDMM6500_VoltageDigRange;
  fBaseVolt:TDMM6500MeasPar_BaseVoltDC;
  function GetInputImpedance: TDMM6500_InputImpedance;
  procedure SetInputImpedance(const Value: TDMM6500_InputImpedance);
  function GetUnits: TDMM6500_VoltageUnits;
  procedure SetUnits(const Value: TDMM6500_VoltageUnits);
  function GetDB: double;
  function GetDBM: integer;
  function GetDBLimits:TLimitValues;
  function GetDBMLimits:TLimitValues;
  procedure SetDB(const Value: double);
  procedure SetDBM(const Value: integer);
 public
  property Range: TDMM6500_VoltageDigRange read fRange write fRange;
  property InputImpedance: TDMM6500_InputImpedance read GetInputImpedance write SetInputImpedance;
  property Units: TDMM6500_VoltageUnits read GetUnits write SetUnits;
  property DB:double read GetDB write SetDB;
  property DBM:integer read GetDBM write SetDBM;
  property DBLimits:TLimitValues read GetDBLimits;
  property DBMLimits:TLimitValues read GetDBMLimits;
  constructor Create;
  destructor Destroy; override;
end;


TDMM6500MeasPar_DigCur=class(TDMM6500MeasPar_BaseDig)
 private
  fRange:TDMM6500_CurrentDigRange;
 public
  property Range: TDMM6500_CurrentDigRange read fRange write fRange;
  constructor Create;
end;

TDMM6500MeasPar_Capac=class(TDMM6500MeasPar_BaseDelay)
 private
  fRange:TDMM6500_CapacitanceRange;
 public
  property Range: TDMM6500_CapacitanceRange read fRange write fRange;
  constructor Create;
end;

TDMM6500MeasPar_CurAC=class(TDMM6500MeasPar_BaseAC)
 private
  fRange:TDMM6500_CurrentACRange;
 public
  property Range: TDMM6500_CurrentACRange read fRange write fRange;
  constructor Create;
end;

TDMM6500MeasPar_VoltAC=class(TDMM6500MeasPar_BaseAC,IMeasPar_BaseVolt)
 private
  fRange:TDMM6500_VoltageACRange;
  fBaseVolt:TDMM6500MeasPar_BaseVolt;
  function GetUnits: TDMM6500_VoltageUnits;
  procedure SetUnits(const Value: TDMM6500_VoltageUnits);
  function GetDB: double;
  function GetDBM: integer;
  procedure SetDB(const Value: double);
  procedure SetDBM(const Value: integer);
  function GetDBLimits:TLimitValues;
  function GetDBMLimits:TLimitValues;
 public
  property Range: TDMM6500_VoltageACRange read fRange write fRange;
  property Units: TDMM6500_VoltageUnits read GetUnits write SetUnits;
  property DB:double read GetDB write SetDB;
  property DBM:integer read GetDBM write SetDBM;
  property DBLimits:TLimitValues read GetDBLimits;
  property DBMLimits:TLimitValues read GetDBMLimits;
  constructor Create;
  destructor Destroy; override;
end;


TDMM6500MeasPar_FreqPeriod=class(TDMM6500MeasPar_BaseDelayMT)
 private
  fThresholdRange:TDMM6500_VoltageACRange;
 public
  property ThresholdRange: TDMM6500_VoltageACRange read fThresholdRange write fThresholdRange;
  constructor Create;
end;

TDMM6500MeasPar_CurDC=class(TDMM6500MeasPar_Continuity)
 private
  fRange:TDMM6500_CurrentDCRange;
 public
  property Range: TDMM6500_CurrentDCRange read fRange write fRange;
  constructor Create;
end;

TDMM6500MeasPar_VoltDC=class(TDMM6500MeasPar_BaseVoltDCRange,IMeasPar_BaseVolt,IMeasPar_BaseVoltDC)
 private
//  fRange:TDMM6500_VoltageDCRange;
  fBaseVolt:TDMM6500MeasPar_BaseVoltDC;
  function GetInputImpedance: TDMM6500_InputImpedance;
  procedure SetInputImpedance(const Value: TDMM6500_InputImpedance);
  function GetUnits: TDMM6500_VoltageUnits;
  procedure SetUnits(const Value: TDMM6500_VoltageUnits);
  function GetDB: double;
  function GetDBM: integer;
  function GetDBLimits:TLimitValues;
  function GetDBMLimits:TLimitValues;
  procedure SetDB(const Value: double);
  procedure SetDBM(const Value: integer);
 public
//  property Range: TDMM6500_VoltageDCRange read fRange write fRange;
  property InputImpedance: TDMM6500_InputImpedance read GetInputImpedance write SetInputImpedance;
  property Units: TDMM6500_VoltageUnits read GetUnits write SetUnits;
  property DB:double read GetDB write SetDB;
  property DBM:integer read GetDBM write SetDBM;
  property DBLimits:TLimitValues read GetDBLimits;
  property DBMLimits:TLimitValues read GetDBMLimits;
  constructor Create;
  destructor Destroy; override;
end;

TDMM6500MeasPar_VoltRat=class(TDMM6500MeasPar_BaseVoltDCRange)
 private
//  fRange:TDMM6500_VoltageDCRange;
  fMethod:TDMM6500_VoltageRatioMethod;
 public
//  property Range: TDMM6500_VoltageDCRange read fRange write fRange;
  property VRMethod:TDMM6500_VoltageRatioMethod read fMethod write fMethod;
  constructor Create;
end;

TDMM6500MeasPar_Res2W=class(TDMM6500MeasPar_Continuity)
 private
  fRange:TDMM6500_Resistance2WRange;
 public
  property Range: TDMM6500_Resistance2WRange read fRange write fRange;
  constructor Create;
end;

TDMM6500MeasPar_Res4W=class(TDMM6500MeasPar_Base4WT)
 private
  fRange:TDMM6500_Resistance4WRange;
 public
  property Range: TDMM6500_Resistance4WRange read fRange write fRange;
  constructor Create;
end;

TDMM6500MeasPar_Temper=class(TDMM6500MeasPar_Base4WT)
 private
  fTransdType:TDMM6500_TempTransducer;
  fRefJunction:TDMM6500_TCoupleRefJunct;
  fRTDAlpha:double;
  fRTDBeta:double;
  fRTDDelta:double;
  fRTDZero:integer;
  fW2RTDType:TDMM6500_RTDType;
  fW3RTDType:TDMM6500_RTDType;
  fW4RTDType:TDMM6500_RTDType;
  fThermistorType:TDMM6500_ThermistorType;
  fTCoupleType:TDMM6500_TCoupleType;
  fUnits:TDMM6500_TempUnits;
  fSimRefTemp:double;
  Procedure SetRTDAlpha(Value:Double);
  Procedure SetRTDBeta(Value:Double);
  Procedure SetRTDDelta(Value:Double);
  Procedure SetRTDZero(Value:integer);
  Procedure SetRefTemperature(Value:Double);
 public
  property TransdType: TDMM6500_TempTransducer read fTransdType write fTransdType;
  property RefJunction:TDMM6500_TCoupleRefJunct read fRefJunction write fRefJunction;
  property RTD_Alpha:double read fRTDAlpha write SetRTDAlpha;
  property RTD_Beta:double read fRTDBeta write SetRTDBeta;
  property RTD_Delta:double read fRTDDelta write SetRTDDelta;
  property RTD_Zero:integer read fRTDZero write SetRTDZero;
  property W2RTDType:TDMM6500_RTDType read fW2RTDType write fW2RTDType;
  property W3RTDType:TDMM6500_RTDType read fW3RTDType write fW3RTDType;
  property W4RTDType:TDMM6500_RTDType read fW4RTDType write fW4RTDType;
  property ThermistorType:TDMM6500_ThermistorType read fThermistorType write fThermistorType;
  property TCoupleType:TDMM6500_TCoupleType read fTCoupleType write fTCoupleType;
  property Units: TDMM6500_TempUnits read fUnits write fUnits;
  property RefTemperature:double read fSimRefTemp write SetRefTemperature;
  constructor Create;
end;

TDMM6500MeasPar_Diode=class(TDMM6500MeasPar_Continuity)
 private
  fBiasLevel:TDMM6500_DiodeBiasLevel;
 public
  property BiasLevel: TDMM6500_DiodeBiasLevel read fBiasLevel write fBiasLevel;
  constructor Create;
end;

//TQuireFunction=Function(FM: TKeitley_Measure;PM: TDMM6500MeasPar_Base):boolean of object;
//TQuireFunctionRTDType=Function(FM: TKeitley_Measure;PM: TDMM6500MeasPar_Base;
//                               WiType:TDMM6500_RTDPropertyNumber):boolean of object;
//TPermittedMeasureFunction=Function(FM: TKeitley_Measure):boolean of object;
//TGetActionProc=Procedure(PM: TDMM6500MeasPar_Base)of object;


//TSetProcedureBool=Procedure(FM: TKeitley_Measure;PM: TDMM6500MeasPar_Base;toOn:boolean) of object;
//TSetProcedureDouble=Procedure(FM: TKeitley_Measure;PM: TDMM6500MeasPar_Base;Value:double) of object;
//TSetProcedureDoubleGeneral=Procedure(FM: TKeitley_Measure;Value:double) of object;
//TSetProcedureInteger=Procedure(FM: TKeitley_Measure;PM: TDMM6500MeasPar_Base;Value:integer) of object;
//TSetProcedureRTDType=Procedure(FM: TKeitley_Measure;PM: TDMM6500MeasPar_Base;RTDType:TDMM6500_RTDType;
//                                WiType:TDMM6500_RTDPropertyNumber) of object;

 function  DMM6500MeasParFactory(MeasureType:TKeitley_Measure):TDMM6500MeasPar_Base;



implementation

function  DMM6500MeasParFactory(MeasureType:TKeitley_Measure):TDMM6500MeasPar_Base;
begin
 case MeasureType of
   kt_mCurDC: Result:=TDMM6500MeasPar_CurDC.Create;
   kt_mVolDC: Result:=TDMM6500MeasPar_VoltDC.Create;
   kt_mRes2W: Result:=TDMM6500MeasPar_Res2W.Create;
   kt_mCurAC: Result:=TDMM6500MeasPar_CurAC.Create;
   kt_mVolAC: Result:=TDMM6500MeasPar_VoltAC.Create;
   kt_mRes4W: Result:=TDMM6500MeasPar_Res4W.Create;
   kt_mDiod: Result:=TDMM6500MeasPar_Diode.Create;
   kt_mCap: Result:=TDMM6500MeasPar_Capac.Create;
   kt_mTemp: Result:=TDMM6500MeasPar_Temper.Create;
   kt_mCont: Result:=TDMM6500MeasPar_Diode.Create;
   kt_mFreq: Result:=TDMM6500MeasPar_FreqPeriod.Create;
   kt_mPer: Result:=TDMM6500MeasPar_FreqPeriod.Create;
   kt_mVoltRat: Result:=TDMM6500MeasPar_VoltRat.Create;
   kt_mDigCur: Result:=TDMM6500MeasPar_DigCur.Create;
   else Result:=TDMM6500MeasPar_DigVolt.Create;
 end;
end;

{ TDMM6500MeasPar_Base }

constructor TDMM6500MeasPar_Base.Create;
begin
 inherited;
// fCount:=1;
 fDisplayDN:=6;
end;

//procedure TDMM6500MeasPar_Base.SetCountNumber(Value: integer);
// const CountLimits:TLimitValues=(1,1000000);
//begin
// fCount:=TSCPInew.NumberMap(Value,CountLimits);
//end;

{ TDMM6500MeasPar_BaseDelay }

constructor TDMM6500MeasPar_BaseDelay.Create;
begin
 inherited;
 fAutoDelay:=true;
end;

{ TDMM6500MeasPar_BaseDig }

constructor TDMM6500MeasPar_BaseDig.Create;
begin
 inherited Create;
 fSampleRate:=1000;
end;

{ TDMM6500MeasPar_DigCur }

constructor TDMM6500MeasPar_DigVolt.Create;
begin
 inherited Create;
 fRange:=dm_vdr1000V;
 fBaseVolt:=TDMM6500MeasPar_BaseVoltDC.Create;
end;

destructor TDMM6500MeasPar_DigVolt.Destroy;
begin
  fBaseVolt.Free;
  inherited;
end;

function TDMM6500MeasPar_DigVolt.GetDB: double;
begin
 Result:=fBaseVolt.DB;
end;

function TDMM6500MeasPar_DigVolt.GetDBLimits: TLimitValues;
begin
 Result:=fBaseVolt.DBLimits;
end;

function TDMM6500MeasPar_DigVolt.GetDBM: integer;
begin
 Result:=fBaseVolt.DBM;
end;

function TDMM6500MeasPar_DigVolt.GetDBMLimits: TLimitValues;
begin
 Result:=fBaseVolt.DBMLimits;
end;

function TDMM6500MeasPar_DigVolt.GetInputImpedance: TDMM6500_InputImpedance;
begin
  Result:=fBaseVolt.InputImpedance;
end;

function TDMM6500MeasPar_DigVolt.GetUnits: TDMM6500_VoltageUnits;
begin
   Result:=fBaseVolt.Units;
end;

procedure TDMM6500MeasPar_DigVolt.SetInputImpedance(
  const Value: TDMM6500_InputImpedance);
begin
  fBaseVolt.InputImpedance:=Value;
end;

procedure TDMM6500MeasPar_DigVolt.SetUnits(const Value: TDMM6500_VoltageUnits);
begin
 fBaseVolt.Units:=Value;
end;

procedure TDMM6500MeasPar_DigVolt.SetDB(const Value: double);
begin
 fBaseVolt.DB:=Value;
end;

procedure TDMM6500MeasPar_DigVolt.SetDBM(const Value: integer);
begin
 fBaseVolt.DBM:=Value;
end;

{ TDMM6500MeasPar_DigVolt }

constructor TDMM6500MeasPar_DigCur.Create;
begin
 inherited Create;
  fRange:=dm_cdr3A;
end;

{ TDMM6500MeasPar_BaseVolt }

constructor TDMM6500MeasPar_BaseVolt.Create;
begin
 inherited Create;
// fUnits:=dm_vuVolt;
 fUnits:=dm_vuDB;
 fDB:=1;
 fDBM:=1;
 fDBMLimits[lvMin]:=1;
 fDBMLimits[lvMax]:=9999;
 fDBLimits[lvMin]:=1e-7;
 fDBLimits[lvMax]:=1000;//750
end;

procedure TDMM6500MeasPar_BaseVolt.SetDB(Value: double);
begin
 fDB:=TSCPInew.NumberMap(Value,fDBLimits);
end;

procedure TDMM6500MeasPar_BaseVolt.SetDBM(Value: integer);
begin
 fDBM:=TSCPInew.NumberMap(Value,fDBMLimits);
end;

{ TDMM6500MeasPar_BaseVoltDC }

constructor TDMM6500MeasPar_BaseVoltDC.Create;
begin
 inherited Create;
 fInputImpedance:=dm_ii10M;
end;

{ TDMM6500MeasPar_Capac }

constructor TDMM6500MeasPar_Capac.Create;
begin
 inherited Create;
 fRange:=dm_crAuto;
end;

{ TDMM6500MeasPar_BaseAC }

constructor TDMM6500MeasPar_BaseAC.Create;
begin
 inherited Create;
 fDetectorBW:=dm_dbw3Hz;
end;

{ TDMM6500MeasPar_CurACc }

constructor TDMM6500MeasPar_CurAC.Create;
begin
 inherited Create;
 fRange:=dm_carAuto;
end;

{ TDMM6500MeasPar_VoltAC }

constructor TDMM6500MeasPar_VoltAC.Create;
begin
  inherited Create;
  fBaseVolt:=TDMM6500MeasPar_BaseVolt.Create;
  fBaseVolt.fDBLimits[lvMax]:=750;
end;

destructor TDMM6500MeasPar_VoltAC.Destroy;
begin
  fBaseVolt.Free;
  inherited;
end;

function TDMM6500MeasPar_VoltAC.GetDB: double;
begin
  Result:=fBaseVolt.DB;
end;

function TDMM6500MeasPar_VoltAC.GetDBLimits: TLimitValues;
begin
   Result:=fBaseVolt.DBLimits;
end;

function TDMM6500MeasPar_VoltAC.GetDBM: integer;
begin
 Result:=fBaseVolt.DBM;
end;

function TDMM6500MeasPar_VoltAC.GetDBMLimits: TLimitValues;
begin
  Result:=fBaseVolt.DBMLimits;
end;

function TDMM6500MeasPar_VoltAC.GetUnits: TDMM6500_VoltageUnits;
begin
 Result:=fBaseVolt.Units;
end;

procedure TDMM6500MeasPar_VoltAC.SetUnits(const Value: TDMM6500_VoltageUnits);
begin
  fBaseVolt.Units:=Value;
end;

procedure TDMM6500MeasPar_VoltAC.SetDB(const Value: double);
begin
  fBaseVolt.DB:=Value;
end;

procedure TDMM6500MeasPar_VoltAC.SetDBM(const Value: integer);
begin
  fBaseVolt.DBM:=Value;
end;

{ TDMM6500MeasPar_BaseDelayMT }

constructor TDMM6500MeasPar_BaseDelayMT.Create;
begin
 inherited Create;
 fMTLimits[lvMin]:=0.01;
 fMTLimits[lvMax]:=240;
// fOffComp:=dm_ocAuto;
// fOpenLD:=False;
end;

procedure TDMM6500MeasPar_BaseDelayMT.SetMeaureTime(Value: double);
begin
  fMeaureTime:=TSCPInew.NumberMap(Value,fMTLimits);
end;

{ TDMM6500MeasPar_BasePeriod }

constructor TDMM6500MeasPar_FreqPeriod.Create;
begin
 inherited Create;
 fThresholdRange:=dm_varAuto;
 fMTLimits[lvMin]:=2;
 fMTLimits[lvMax]:=273;
end;

{ TDMM6500MeasPar_BaseMajority }

constructor TDMM6500MeasPar_Continuity.Create;
begin
 inherited Create;
 fAzeroState:=True;
 fLineSync:=False;
end;

{ TDMM6500MeasPar_CurDC }

constructor TDMM6500MeasPar_CurDC.Create;
begin
 inherited Create;
 fRange:=dm_cdrAuto;
end;

{ TDMM6500MeasPar_VoltDC }

constructor TDMM6500MeasPar_VoltDC.Create;
begin
 inherited Create;
// fRange:=dm_vdrAuto;
 fBaseVolt:=TDMM6500MeasPar_BaseVoltDC.Create;
end;

destructor TDMM6500MeasPar_VoltDC.Destroy;
begin
 fBaseVolt.Free;
 inherited;
end;

function TDMM6500MeasPar_VoltDC.GetDB: double;
begin
 Result:=fBaseVolt.DB;
end;

function TDMM6500MeasPar_VoltDC.GetDBLimits: TLimitValues;
begin
 Result:=fBaseVolt.DBLimits;
end;

function TDMM6500MeasPar_VoltDC.GetDBM: integer;
begin
 Result:=fBaseVolt.DBM;
end;

function TDMM6500MeasPar_VoltDC.GetDBMLimits: TLimitValues;
begin
 Result:=fBaseVolt.DBMLimits;
end;

function TDMM6500MeasPar_VoltDC.GetInputImpedance: TDMM6500_InputImpedance;
begin
 Result:=fBaseVolt.InputImpedance;
end;

function TDMM6500MeasPar_VoltDC.GetUnits: TDMM6500_VoltageUnits;
begin
  Result:=fBaseVolt.Units;
end;

procedure TDMM6500MeasPar_VoltDC.SetInputImpedance(
  const Value: TDMM6500_InputImpedance);
begin
  fBaseVolt.InputImpedance:=Value;
end;

procedure TDMM6500MeasPar_VoltDC.SetUnits(const Value: TDMM6500_VoltageUnits);
begin
  fBaseVolt.Units:=Value;
end;

procedure TDMM6500MeasPar_VoltDC.SetDB(const Value: double);
begin
  fBaseVolt.DB:=Value;
end;

procedure TDMM6500MeasPar_VoltDC.SetDBM(const Value: integer);
begin
  fBaseVolt.DBM:=Value;
end;

{ TDMM6500MeasPar_VoltRat }

constructor TDMM6500MeasPar_VoltRat.Create;
begin
 inherited Create;
// fRange:=dm_vdrAuto;
 fMethod:=dm_vrmPart;
end;

{ TDMM6500MeasPar_Res2W }

constructor TDMM6500MeasPar_Res2W.Create;
begin
 inherited Create;
 fRange:=dm_r2rAuto;
end;

{ TDMM6500MeasPar_Base4WT }

constructor TDMM6500MeasPar_Base4WT.Create;
begin
 inherited Create;
 fOffComp:=dm_ocAuto;
 fOpenLD:=False;
end;

{ TDMM6500MeasPar_Res4W }

constructor TDMM6500MeasPar_Res4W.Create;
begin
 inherited Create;
 fRange:=dm_r4rAuto;
end;

{ TDMM6500MeasPar_Temper }

constructor TDMM6500MeasPar_Temper.Create;
begin
 inherited Create;
 fTransdType:=dm_ttCouple;
 fRefJunction:=dm_trjSim;
 fRTDAlpha:=0.00385055;
 fRTDBeta:=0.10863;
 fRTDDelta:=1.4999;
 fRTDZero:=100;
 fW2RTDType:=dm_rtdPT100;
 fW3RTDType:=dm_rtdPT100;
 fW4RTDType:=dm_rtdPT100;
 fThermistorType:=dm_tt5000;
 fTCoupleType:=dm_tctK;
 fUnits:=dm_tuCels;
 fSimRefTemp:=23;
 fOpenLD:=True;
end;

procedure TDMM6500MeasPar_Temper.SetRefTemperature(Value: Double);
begin
 fSimRefTemp:=TSCPInew.NumberMap(Value,DMM6500_RefTempLimits[fUnits]);
end;

procedure TDMM6500MeasPar_Temper.SetRTDAlpha(Value: Double);
begin
 fRTDAlpha:=TSCPInew.NumberMap(Value,DMM6500_RTDAlphaLimits);
end;

procedure TDMM6500MeasPar_Temper.SetRTDBeta(Value: Double);
begin
 fRTDBeta:=TSCPInew.NumberMap(Value,DMM6500_RTDBetaLimits);
end;

procedure TDMM6500MeasPar_Temper.SetRTDDelta(Value: Double);
begin
 fRTDDelta:=TSCPInew.NumberMap(Value,DMM6500_RTDDeltaLimits);
end;

procedure TDMM6500MeasPar_Temper.SetRTDZero(Value: integer);
begin
 fRTDZero:=TSCPInew.NumberMap(Value,DMM6500_RTDZeroLimits);
end;

{ TDMM6500MeasPar_Diode }

constructor TDMM6500MeasPar_Diode.Create;
begin
 inherited Create;
 fBiasLevel:=dm_dbl1mA;
end;



{ TDMM6500MeasPar_BaseVoltDCRange }

constructor TDMM6500MeasPar_BaseVoltDCRange.Create;
begin
 inherited Create;
 fRange:=dm_vdrAuto;
end;

end.
