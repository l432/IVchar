unit DMM6500;

interface

uses
  Keithley, IdTelnet, ShowTypes,Keitley2450Const, DMM6500_Const, SCPI, 
  OlegTypePart2, DMM6500_MeasParam;

//const


type
 TDMM6500=class;
// TDMM6500MeasPar_Base=class;



 TDMM6500Channel=class
  private
   FNumber: byte;
   FMeasureFunction: TKeitley_Measure;
   fDMM6500:TDMM6500;
   fCount:integer;
   fCountDig:integer;
   fMeasParameters:array [TKeitley_Measure] of TDMM6500MeasPar_Base;
   procedure SetCountNumber(Value:integer);
   function GetMeasParameters:TDMM6500MeasPar_Base;
   Procedure MeasParametersDestroy;
   procedure SetCountDigNumber(Value:integer);
  public
   property Number:byte read FNumber;
   property MeasureFunction:TKeitley_Measure read FMeasureFunction write FMeasureFunction;
   property DMM6500:TDMM6500 read fDMM6500;
   property Count:integer read fCount write SetCountNumber;
   property MeasParameters:TDMM6500MeasPar_Base read GetMeasParameters;
   property CountDig:integer read fCountDig write SetCountDigNumber;
   constructor Create(ChanNumber:byte;DMM6500:TDMM6500);
   destructor Destroy; override;
 end;

 TTDMM6500ChannelArr=array of TDMM6500Channel;

 TDMM6500=class(TKeitley)
  private
   fMeasureChanNumber:byte;
   fFirstChannelInSlot:byte;
   fLastChannelInSlot:byte;
   fChannelMaxVoltage:double;
   fRealCardPresent:boolean;
//   fChansMeasureFunction:array of TKeitley_Measure;
   fChansMeasure:TTDMM6500ChannelArr;
//   fTerminalMeasureFunction:array [TKeitley_OutputTerminals] of TKeitley_Measure;
   fChanOperation:boolean;
   fChanOperationString:string;
   fCountDig:integer;
   fMeasParameters:array [TKeitley_Measure] of TDMM6500MeasPar_Base;
   function GetMeasParameters:TDMM6500MeasPar_Base;
   procedure MeasParameterCreate(Measure:TKeitley_Measure);
   function ChanelToString(ChanNumber:byte):string;overload;
   function ChanelToString(ChanNumberLow,ChanNumberHigh:byte):string;overload;
   function ChanelToString(ChanNumbers:array of byte):string;overload;
   function ChanelNumberIsCorrect(ChanNumber:byte):boolean;overload;
   function ChanelNumberIsCorrect(ChanNumberLow,ChanNumberHigh:byte):boolean;overload;
   function ChanelNumberIsCorrect(ChanNumbers:array of byte):boolean;overload;
   
   procedure ChansMeasureCreate;
   procedure ChansMeasureDestroy;

//   function GetShablon (QuireFunc:TQuireFunction;ChanNumber:byte):boolean;overload;
//   function GetShablon (QuireFunc:TQuireFunctionRTDType;WiType:TDMM6500_RTDPropertyNumber;ChanNumber:byte):boolean;overload;
//   function GetActionShablon(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base;
//                             PermitFunc:TPermittedMeasureFunction;GetActionProc:TGetActionProc;
//                             FirstLevelNode:byte;LeafNode:byte=0):boolean;overload;
   function GetActionShablon(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base;
                             MParam:TDMM6500_MeasParameters):boolean;
   function GetActionRangeShablon(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base;
                             MParam:TDMM6500_MeasParameters):boolean;
                             //overload;
//   function GetShablon(PermitFunc:TPermittedMeasureFunction;GetActionProc:TGetActionProc;
//                             FirstLevelNode,LeafNode,ChanNumber:byte):boolean;overload;
   function GetShablon(MParam:TDMM6500_MeasParameters;ChanNumber:byte):boolean;overload;
   function GetShablon(MParam:TDMM6500_MeasParameters;Measure:TKeitley_Measure):boolean;overload;

   procedure SetActionShablon(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base;
                              P:Pointer;MParam:TDMM6500_MeasParameters);
   procedure SetActionRangeShablon(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base;
                              P:Pointer;MParam:TDMM6500_MeasParameters);

   procedure SetShablon(MParam:TDMM6500_MeasParameters;P:Pointer;ChanNumber:byte);overload;
   procedure SetShablon(MParam:TDMM6500_MeasParameters;P:Pointer;Measure:TKeitley_Measure);overload;

//   procedure SetupShablon(SetProcedureBool:TSetProcedureBool;toOn:boolean;ChanNumber:byte);overload;
//   procedure SetupShablon(SetProcedureDouble:TSetProcedureDouble;Value:double;ChanNumber:byte);overload;
//   procedure SetupShablon(SetProcedureDoubleGeneral:TSetProcedureDoubleGeneral;Value:double;ChanNumber:byte);overload;
//   procedure SetupShablon(SetProcedureInteger:TSetProcedureInteger;Value:Integer;ChanNumber:byte);overload;
//   procedure SetupShablon(SetProcedure:TSetProcedureRTDType;RTDType:TDMM6500_RTDType;WiType:TDMM6500_RTDPropertyNumber;ChanNumber:byte);overload;
   function ChanSetupBegin(ChanNumber:byte):boolean;
   function ChanQuireBegin(ChanNumber:byte):boolean;
   Procedure MeasParametersDestroy;
//   procedure StrToTempUnit(Str:string);
//   procedure StrToVoltUnit(Str:string);
//   procedure StringToInputImpedance(Str:string);
//   procedure StringToVoltageRatioMethod(Str:string);
//   procedure StringToDetectorBW(Str:string);
//   procedure StringToOffsetComp(Str:string);
//   procedure StringToRTDType(Str:string);
//   procedure StringToCoupleRefJunct(Str:string);
//   procedure StringToTCoupleType(Str:string);
//   procedure StringToThermistorType(Str:string);
//   procedure StringToTempTransducer(Str:string);
   procedure StringToOrd(Str:string);
   function HighForStrParsing:byte;
   function ItIsRequiredStr(Str:string;i:byte):boolean;

//   function RangeToString(Range:TDMM6500_VoltageDCRange):string;overload;
//   function RangeToString(Range:TDMM6500_VoltageACRange):string;overload;
//   function RangeToString(Range:TDMM6500_CurrentDCRange):string;overload;
//   function RangeToString(Range:TDMM6500_CurrentACRange):string;overload;
//   function RangeToString(Range:TDMM6500_Resistance2WRange):string;overload;
//   function RangeToString(Range:TDMM6500_Resistance4WRange):string;overload;
//   function RangeToString(Range:TDMM6500_CapacitanceRange):string;overload;
   function RangeToString(P:pointer;MParam:TDMM6500_MeasParameters):string;//overload;
   function ApertValueToString(FM: TKeitley_Measure;ApertValue:double):string;
   function BiasLevelToString(BL:TDMM6500_DiodeBiasLevel):string;

//   function ValueToDCVoltageRange(Value:double):TDMM6500_VoltageDCRange;
//   function ValueToACVoltageRange(Value:double):TDMM6500_VoltageACRange;
//   function ValueToDCCurrentRange(Value:double):TDMM6500_CurrentDCRange;
//   function ValueToACCurrentRange(Value:double):TDMM6500_CurrentACRange;
//   function ValueToResistance2WRange(Value:double):TDMM6500_Resistance2WRange;
//   function ValueToResistance4WRange(Value:double):TDMM6500_Resistance4WRange;
//   function ValueToCapacitanceRange(Value:double):TDMM6500_CapacitanceRange;
//   function ValueToBiasLevel(Value:double):TDMM6500_DiodeBiasLevel;
   function ValueToOrd(Value:double;FM: TKeitley_Measure):integer;


   function PermitForParameter(FM: TKeitley_Measure; MParam: TDMM6500_MeasParameters;P:Pointer=nil;
                              PM: TDMM6500MeasPar_Base=nil):boolean;
   function PermitForRangeAuto(P:Pointer; MParam: TDMM6500_MeasParameters):boolean;
   function SuccessfulGet(MParam: TDMM6500_MeasParameters):boolean;
   function ParametrToFLNode(MParam:TDMM6500_MeasParameters):byte;
   function ParameterToLeafNode(MParam:TDMM6500_MeasParameters;FM: TKeitley_Measure):byte;
   procedure GetActionProcedureByMParam(FM: TKeitley_Measure;PM: TDMM6500MeasPar_Base;MParam:TDMM6500_MeasParameters);
   procedure GetActionRangeAutoProcedureByMParam(FM: TKeitley_Measure;PM: TDMM6500MeasPar_Base;MParam:TDMM6500_MeasParameters);
   procedure SetActionProcedureByMParam(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base;
                              P:Pointer;MParam:TDMM6500_MeasParameters);
  protected
   procedure ProcessingStringByRootNode(Str:string);override;
   procedure PrepareString;override;
   procedure PrepareStringByRootNode;override;
   procedure ProcessingStringChanOperation;
   procedure OffOnToValue(Str:string);
   procedure DefaultSettings;override;
//   procedure StringToMesuredData(Str:string;DataType:TKeitley_ReturnedData);override;
   procedure AdditionalDataFromString(Str:string);override;
   procedure AdditionalDataToArrayFromString;override;
//   function GetMeasureFunctionValue:TKeitley_Measure;override;
   procedure SetCountNumber(Value:integer);override;
   procedure SetCountDigNumber(Value:integer);
  public
   property MeasParameters:TDMM6500MeasPar_Base read GetMeasParameters;
   property CountDig:integer read fCountDig write SetCountDigNumber;
   property ChansMeasure:TTDMM6500ChannelArr read fChansMeasure;
   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string='DMM6500');
   destructor Destroy; override;
   function IsPermittedMeasureFuncForChan(MeasureFunc:TKeitley_Measure;
                                    ChanNumber:byte):boolean;
   function MeasParamByCN(ChanNumber:byte):TDMM6500MeasPar_Base;
   function MeasFuncByCN(ChanNumber:byte):TKeitley_Measure;
   function GetMeasPar_BaseVolt(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):IMeasPar_BaseVolt;
   function GetMeasPar_BaseVoltDC(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):IMeasPar_BaseVoltDC;
   procedure MyTraining();override;
   procedure ProcessingString(Str:string);override;

   procedure BufferCreate(Name:string;Size:integer;Style:TKt2450_BufferStyle);overload;override;
   procedure BufferCreate(Style:TKt2450_BufferStyle);overload;override;

   function TestRealCard_Presence:boolean;
   function TestPseudocard_Presence:boolean;
   procedure PseudocardInstall;
   procedure PseudocardUnInstall;

   Function  GetFirstChannelInSlot:boolean;
   Function  GetLastChannelInSlot:boolean;
   Function  GetChannelMaxVoltage:boolean;

   procedure SetMeasureFunction(MeasureFunc: TKeitley_Measure; ChanNumber: Byte);reintroduce;overload;
   procedure SetMeasureFunction(ChanNumberLow,ChanNumberHigh:byte;
                    MeasureFunc:TKeitley_Measure=kt_mVolDC);reintroduce;overload;
   procedure SetMeasureFunction(ChanNumbers:array of byte;
                    MeasureFunc:TKeitley_Measure=kt_mVolDC);reintroduce;overload;
   function GetMeasureFunction(ChanNumber:byte):boolean;reintroduce;overload;

   procedure SetCount(Cnt: Integer; ChanNumber: Byte);reintroduce;overload;
   function GetCount(ChanNumber:byte):boolean;reintroduce;overload;

   procedure SetCountDigAction(DeviceCountDig,NewCountDig:integer);
   procedure SetCountDig(Cnt: Integer; ChanNumber: Byte=0);//overload;
   function GetCountDigAction(DeviceCountDig:integer):boolean;
   function GetCountDig(ChanNumber:byte=0):boolean;//overload;



   procedure SetDisplayDigitsNumberAction(Measure:TKeitley_Measure;
                                PM: TDMM6500MeasPar_Base;
                                Number:TKeitleyDisplayDigitsNumber);
   procedure SetDisplayDigitsNumber(Measure:TKeitley_Measure; Number:TKeitleyDisplayDigitsNumber);override;
   procedure SetDisplayDigitsNumber(Number:TKeitleyDisplayDigitsNumber);override;
   procedure SetDisplayDigitsNumber(Number: TKeitleyDisplayDigitsNumber; ChanNumber: Byte);reintroduce;overload;

   function GetDisplayDigitsNumberAction(Measure:TKeitley_Measure;PM: TDMM6500MeasPar_Base):boolean;
   function GetDisplayDigitsNumber(Measure:TKeitley_Measure):boolean;override;
   function GetDisplayDigitsNumber():boolean;override;
   function GetDisplayDigitsNumber(ChanNumber:byte):boolean;reintroduce;overload;


//   procedure SetDelayAutoAction(Measure:TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                toOn:boolean);
   procedure SetDelayAuto(Measure:TKeitley_Measure;toOn:boolean);overload;
{   This command enables or disables the automatic delay that occurs before each measurement}
   procedure SetDelayAuto(toOn: Boolean; ChanNumber: Byte=0);overload;
//   function GetDelayAutoAction(Measure:TKeitley_Measure;PM: TDMM6500MeasPar_Base):boolean;
   function GetDelayAuto(Measure:TKeitley_Measure):boolean;overload;
   function GetDelayAuto(ChanNumber:byte=0):boolean;overload;


//   procedure SetSampleRateAction(Measure:TKeitley_Measure;
//                                 PM: TDMM6500MeasPar_Base;
//                                 SR:TDMM6500_DigSampleRate);
   procedure SetSampleRate(Measure:TKeitley_Measure;SR:TDMM6500_DigSampleRate);overload;
   procedure SetSampleRate(SR: TDMM6500_DigSampleRate; ChanNumber: Byte=0);overload;
//   function GetSampleRateAction(Measure:TKeitley_Measure;PM: TDMM6500MeasPar_Base):boolean;
   function GetSampleRate(Measure:TKeitley_Measure):boolean;overload;
   function GetSampleRate(ChanNumber:byte=0):boolean;overload;


//   procedure SetApertureAutoAction(Measure:TKeitley_Measure);
   procedure SetApertureAuto(ChanNumber:byte=0);

//   procedure SetApertureAction(FM: TKeitley_Measure;
//                              ApertValue:double);
   procedure SetAperture(ApertValue:double;ChanNumber:byte=0);
//   function GetApertureAction(FM: TKeitley_Measure):boolean;
   function GetAperture(ChanNumber:byte=0):boolean;
   {результат в fDevice.Value}

//   procedure SetNPLCAction(FM: TKeitley_Measure;
//                           NPLCvalue:double);
   procedure SetNPLC(NPLCvalue:double;ChanNumber:byte=0);
//   function GetNPLCAction(FM: TKeitley_Measure):boolean;
   function GetNPLC(ChanNumber:byte=0):boolean;
   {результат в fDevice.Value}

//   procedure SetMeasureTimeAction(FM: TKeitley_Measure;
//                                  PM: TDMM6500MeasPar_Base;
//                                  MT:double);
   procedure SetMeasureTime(MT:double;ChanNumber:byte=0);
//   function GetMeasureTimeAction(FM: TKeitley_Measure;
//                                  PM: TDMM6500MeasPar_Base):boolean;
   function GetMeasureTime(ChanNumber:byte=0):boolean;

//   procedure SetDecibelReferenceAction(FM: TKeitley_Measure;
//                                       PM: TDMM6500MeasPar_Base;
//                                       DBvalue:double);
   procedure SetDecibelReference(DBvalue:double;ChanNumber:byte=0);//overload;
//   function GetDecibelReferenceAction(FM: TKeitley_Measure;
//                                      PM: TDMM6500MeasPar_Base):boolean;
   function GetDecibelReference(ChanNumber:byte=0):boolean;//overload;


//   procedure SetDbmWReferenceAction(FM: TKeitley_Measure;
//                                       PM: TDMM6500MeasPar_Base;
//                                       DBMvalue:integer);
   procedure SetDbmWReference(DBMvalue: Integer; ChanNumber: Byte=0);//overload;
//   function GetDbmWReferenceAction(FM: TKeitley_Measure;
//                                   PM: TDMM6500MeasPar_Base):boolean;
   function GetDbmWReference(ChanNumber:byte=0):boolean;//overload;

//   procedure SetUnitsVoltAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Un:TDMM6500_VoltageUnits);
   procedure SetUnits(Un: TDMM6500_VoltageUnits; ChanNumber: Byte=0);overload;
//   procedure SetUnitsTempAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Un:TDMM6500_TempUnits);
   procedure SetUnits(Un: TDMM6500_TempUnits; ChanNumber: Byte=0);overload;
//   function GetUnitsAction(FM: TKeitley_Measure;
//                                   PM: TDMM6500MeasPar_Base):boolean;
   function GetUnits(ChanNumber:byte=0):boolean;//overload;

//   procedure SetInputImpedanceAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                InIm:TDMM6500_InputImpedance);
   procedure SetInputImpedance(InIm:TDMM6500_InputImpedance;ChanNumber: Byte=0);
//   function GetInputImpedanceAction(FM: TKeitley_Measure;
//                                      PM: TDMM6500MeasPar_Base):boolean;
   function GetInputImpedance(ChanNumber:byte=0):boolean;

//   procedure SetDetectorBWAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                DecBW:TDMM6500_DetectorBandwidth);
   procedure SetDetectorBW(DecBW:TDMM6500_DetectorBandwidth;ChanNumber: Byte=0);
//   function GetDetectorBWAction(FM: TKeitley_Measure;
//                                 PM: TDMM6500MeasPar_Base):boolean;
   function GetDetectorBW(ChanNumber:byte=0):boolean;

//   procedure SetAzeroStateAction(FM: TKeitley_Measure;
//                                 PM: TDMM6500MeasPar_Base;
//                                 toOn:boolean);
   procedure SetAzeroState(toOn:boolean);override;
   procedure SetAzeroState(toOn:boolean;ChanNumber: Byte);reintroduce;overload;
//   function GetAzeroStateAction(FM: TKeitley_Measure;
//                                      PM: TDMM6500MeasPar_Base):boolean;
   function GetAzeroState(ChanNumber:byte=0):boolean;


//   procedure SetLineSyncAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                toOn:boolean);
   procedure SetLineSync(toOn:boolean;ChanNumber: Byte=0);
//   function GetLineSyncAction(FM: TKeitley_Measure;PM: TDMM6500MeasPar_Base):boolean;
   function GetLineSync(ChanNumber:byte=0):boolean;

//   procedure SetOpenLDAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                toOn:boolean);
   procedure SetOpenLD(toOn:boolean;ChanNumber: Byte=0);
//   function GetOpenLDAction(FM: TKeitley_Measure;PM: TDMM6500MeasPar_Base):boolean;
   function GetOpenLD(ChanNumber:byte=0):boolean;

//   procedure SetOffsetCompAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                OC:TDMM6500_OffsetCompen);
   procedure SetOffsetComp(OC:TDMM6500_OffsetCompen;ChanNumber: Byte=0);
//   function GetOffsetCompAction(FM: TKeitley_Measure;
//                                      PM: TDMM6500MeasPar_Base):boolean;
   function GetOffsetComp(ChanNumber:byte=0):boolean;

//   procedure SetRangeAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Range:TDMM6500_VoltageDCRange);overload;
//   procedure SetRangeAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Range:TDMM6500_VoltageACRange);overload;
//   procedure SetRangeAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Range:TDMM6500_CurrentDCRange);overload;
//   procedure SetRangeAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Range:TDMM6500_CurrentACRange);overload;
//   procedure SetRangeAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Range:TDMM6500_Resistance2WRange);overload;
//   procedure SetRangeAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Range:TDMM6500_Resistance4WRange);overload;
//   procedure SetRangeAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Range:TDMM6500_CapacitanceRange);overload;
   procedure SetRange(Range:TDMM6500_VoltageDCRange;ChanNumber: Byte=0);overload;
   procedure SetRange(Range:TDMM6500_VoltageACRange;ChanNumber: Byte=0);overload;
   procedure SetRange(Range:TDMM6500_CurrentDCRange;ChanNumber: Byte=0);overload;
   procedure SetRange(Range:TDMM6500_CurrentACRange;ChanNumber: Byte=0);overload;
   procedure SetRange(Range:TDMM6500_Resistance2WRange;ChanNumber: Byte=0);overload;
   procedure SetRange(Range:TDMM6500_Resistance4WRange;ChanNumber: Byte=0);overload;
   procedure SetRange(Range:TDMM6500_CapacitanceRange;ChanNumber: Byte=0);overload;
//   function GetRangeAction(FM: TKeitley_Measure;
//                                      PM: TDMM6500MeasPar_Base):boolean;
   function GetRange(ChanNumber:byte=0):boolean;

//   procedure SetThresholdRangeAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Range:TDMM6500_VoltageACRange);
   procedure SetThresholdRange(Range:TDMM6500_VoltageACRange;ChanNumber: Byte=0);
//   function GetThresholdRangeAction(FM: TKeitley_Measure;
//                                      PM: TDMM6500MeasPar_Base):boolean;
   function GetThresholdRange(ChanNumber:byte=0):boolean;

//   procedure SetVRMethodAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                VRM:TDMM6500_VoltageRatioMethod);
   procedure SetVRMethod(VRM:TDMM6500_VoltageRatioMethod;ChanNumber: Byte=0);
//   function GetVRMethodAction(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):boolean;
   function GetVRMethod(ChanNumber:byte=0):boolean;

//   function PermitDiode(FM: TKeitley_Measure):boolean;
//   procedure SetBiasLevelAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                BL:TDMM6500_DiodeBiasLevel);
   procedure SetBiasLevel(BL:TDMM6500_DiodeBiasLevel;ChanNumber: Byte=0);
//   function GetBiasLevelAction(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):boolean;
//   procedure GetBiasLevelAction(PM:TDMM6500MeasPar_Base);
   function GetBiasLevel(ChanNumber:byte=0):boolean;

//   procedure SetRTDAlphaAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Value:Double);
   procedure SetRTDAlpha(Value:Double;ChanNumber: Byte=0);
//   function GetRTDAlphaAction(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):boolean;
   function GetRTDAlpha(ChanNumber:byte=0):boolean;

//   procedure SetRTDBetaAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Value:Double);
   procedure SetRTDBeta(Value:Double;ChanNumber: Byte=0);
//   function GetRTDBetaAction(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):boolean;
   function GetRTDBeta(ChanNumber:byte=0):boolean;

//   procedure SetRTDDeltaAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Value:Double);
   procedure SetRTDDelta(Value:Double;ChanNumber: Byte=0);
//   function GetRTDDeltaAction(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):boolean;
   function GetRTDDelta(ChanNumber:byte=0):boolean;

//   procedure SetRTDZeroAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Value:integer);
   procedure SetRTDZero(Value:integer;ChanNumber: Byte=0);
//   function GetRTDZeroAction(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):boolean;
   function GetRTDZero(ChanNumber:byte=0):boolean;

//   procedure SetRefTemperatureaAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Value:Double);
   procedure SetRefTemperature(Value:Double;ChanNumber: Byte=0);
//   function GetRefTemperatureAction(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):boolean;
   function GetRefTemperature(ChanNumber:byte=0):boolean;


//   procedure SetWiRTDTypeAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                RTDType:TDMM6500_RTDType;
//                                WiType:TDMM6500_RTDPropertyNumber);
   procedure SetW2RTDType(RTDType:TDMM6500_RTDType;ChanNumber: Byte=0);
   procedure SetW3RTDType(RTDType:TDMM6500_RTDType;ChanNumber: Byte=0);
   procedure SetW4RTDType(RTDType:TDMM6500_RTDType;ChanNumber: Byte=0);
//   function GetW2RTDTypeAction(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base;
//                               WiType:TDMM6500_RTDPropertyNumber):boolean;
   function GetW2RTDType(ChanNumber:byte=0):boolean;
   function GetW3RTDType(ChanNumber:byte=0):boolean;
   function GetW4RTDType(ChanNumber:byte=0):boolean;

//   procedure SetRefJunctionAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Value:TDMM6500_TCoupleRefJunct);
   procedure SetRefJunction(Value:TDMM6500_TCoupleRefJunct;ChanNumber: Byte=0);
//   function GetRefJunctionAction(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):boolean;
//   procedure GetRefJunctionAction(PM:TDMM6500MeasPar_Base);
   function GetRefJunction(ChanNumber:byte=0):boolean;

//   procedure SetTCoupleTypeAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Value:TDMM6500_TCoupleType);
   procedure SetTCoupleType(Value:TDMM6500_TCoupleType;ChanNumber: Byte=0);
//   function GetTCoupleTypeAction(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):boolean;
//   procedure GetTCoupleTypeAction(PM:TDMM6500MeasPar_Base);
   function GetTCoupleType(ChanNumber:byte=0):boolean;

//   procedure SetThermistorTypeAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Value:TDMM6500_ThermistorType);
   procedure SetThermistorType(Value:TDMM6500_ThermistorType;ChanNumber: Byte=0);
//   function GetThermistorTypeAction(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):boolean;
//   procedure GetThermistorTypeAction(PM:TDMM6500MeasPar_Base);
   function GetThermistorType(ChanNumber:byte=0):boolean;

//   procedure SetTransdTypeAction(FM: TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                Value:TDMM6500_TempTransducer);
   procedure SetTransdType(Value:TDMM6500_TempTransducer;ChanNumber: Byte=0);
//   function GetTransdTypeAction(FM:TKeitley_Measure;PM:TDMM6500MeasPar_Base):boolean;
//   procedure GetTransdTypeAction(PM:TDMM6500MeasPar_Base);
   function GetTransdType(ChanNumber:byte=0):boolean;



   Procedure GetParametersFromDevice;override;
   Procedure GetCardParametersFromDevice;
 end;

//-------------------------------------------------


var
  DMM_6500:TDMM6500;

implementation

uses
  Dialogs, SysUtils, Keitley2450Device, OlegFunction, OlegType, Math,
  TelnetDevice;




{ TKt_2450 }

procedure TDMM6500.BufferCreate(Name: string; Size: integer;
  Style: TKt2450_BufferStyle);
begin
  if Style=kt_bs_comp then Exit;
  inherited BufferCreate(Name,Size,Style);
end;

procedure TDMM6500.AdditionalDataFromString(Str: string);
begin
// showmessage(StringDataFromRow(Str,2));
 if (Pos('Front',StringDataFromRow(Str,2))<>0)
    or(Pos('Rear',StringDataFromRow(Str,2))<>0) then
    begin
     fMeasureChanNumber:=0;
     Exit;
    end;
 fMeasureChanNumber:=round(FloatDataFromRow(Str,2));
end;

procedure TDMM6500.AdditionalDataToArrayFromString;
begin
 DataVector.Add(fMeasureChanNumber,fDevice.Value);
end;

function TDMM6500.ApertValueToString(FM: TKeitley_Measure;
  ApertValue: double): string;
 const ApertLimits:TLimitValues=(1e-5,0.24);
       ApertLimitsPerFr:TLimitValues=(2e-3,0.273);
       ApertLimitsDig:TLimitValues=(1e-6,1e-3);
begin
case FM of
  kt_mCurDC,
  kt_mVolDC,
  kt_mRes2W,
  kt_mRes4W,
  kt_mDiod,
  kt_mTemp,
  kt_mVoltRat: Result:=NumberToStrLimited(ApertValue,ApertLimits);
  kt_mFreq,
  kt_mPer: Result:=NumberToStrLimited(ApertValue,ApertLimitsPerFr);
  kt_mDigCur,
  kt_mDigVolt: Result:=NumberToStrLimited(round(ApertValue*1e6)/1e6,ApertLimitsDig);
  else Result:='';
end;
end;

function TDMM6500.BiasLevelToString(BL: TDMM6500_DiodeBiasLevel): string;
begin
 Result:=floattostr(1e-5*Power(10,ord(BL)));
end;

procedure TDMM6500.BufferCreate(Style: TKt2450_BufferStyle);
begin
  if Style=kt_bs_comp then Exit;
  inherited BufferCreate(Style);
end;

function TDMM6500.ChanelToString(ChanNumber: byte): string;
begin
 Result:='(@'+inttostr(ChanNumber)+')';
end;

function TDMM6500.ChanelToString(ChanNumberLow, ChanNumberHigh: byte): string;
begin
 if ChanNumberLow=ChanNumberHigh
    then Result:=ChanelToString(ChanNumberLow)
    else Result:='(@'
        +inttostr(min(ChanNumberLow,ChanNumberHigh))
        +':'+inttostr(max(ChanNumberLow,ChanNumberHigh))+')';
end;

constructor TDMM6500.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
  inherited Create(Telnet,IPAdressShow,Nm);
end;

procedure TDMM6500.DefaultSettings;
begin
 inherited DefaultSettings;
 fMeasureChanNumber:=0;
 fFirstChannelInSlot:=1;
 fLastChannelInSlot:=10;
 fChannelMaxVoltage:=25;
 fRealCardPresent:=false;

 fMeasureFunction:=kt_mVolDC;
 ChansMeasureCreate();
// fTerminalMeasureFunction[kt_otFront]:=kt_mVolDC;
// fTerminalMeasureFunction[kt_otRear]:=kt_mVolDC;

 fChanOperation:=false;
 fChanOperationString:='';

 fCountDig:=1;

end;

destructor TDMM6500.Destroy;
begin
  MeasParametersDestroy;
  ChansMeasureDestroy;
  inherited;
end;

procedure TDMM6500.GetActionProcedureByMParam(FM: TKeitley_Measure;
                                          PM: TDMM6500MeasPar_Base;
                                  MParam: TDMM6500_MeasParameters);
begin
 case MParam of
   dm_tp_TransdType: (PM as TDMM6500MeasPar_Temper).TransdType:=TDMM6500_TempTransducer(round(fDevice.Value));
   dm_tp_RefJunction: (PM as TDMM6500MeasPar_Temper).RefJunction:=TDMM6500_TCoupleRefJunct(round(fDevice.Value));
   dm_tp_RTDAlpha: (PM as TDMM6500MeasPar_Temper).RTD_Alpha:=fDevice.Value;
   dm_tp_RTDBeta: (PM as TDMM6500MeasPar_Temper).RTD_Beta:=fDevice.Value;
   dm_tp_RTDDelta: (PM as TDMM6500MeasPar_Temper).RTD_Delta:=fDevice.Value;
   dm_tp_RTDZero: (PM as TDMM6500MeasPar_Temper).RTD_Zero:=round(fDevice.Value);
   dm_tp_W2RTDType: (PM as TDMM6500MeasPar_Temper).W2RTDType:=TDMM6500_RTDType(round(fDevice.Value));
   dm_tp_W3RTDType: (PM as TDMM6500MeasPar_Temper).W3RTDType:=TDMM6500_RTDType(round(fDevice.Value));
   dm_tp_W4RTDType: (PM as TDMM6500MeasPar_Temper).W4RTDType:=TDMM6500_RTDType(round(fDevice.Value));
   dm_tp_ThermistorType: (PM as TDMM6500MeasPar_Temper).ThermistorType:=TDMM6500_ThermistorType(round(fDevice.Value));
   dm_tp_TCoupleType: (PM as TDMM6500MeasPar_Temper).TCoupleType:=TDMM6500_TCoupleType(round(fDevice.Value));
   dm_tp_SimRefTemp: (PM as TDMM6500MeasPar_Temper).RefJunction:=TDMM6500_TCoupleRefJunct(round(fDevice.Value));
   dm_dp_BiasLevel:(PM as TDMM6500MeasPar_Diode).BiasLevel:=TDMM6500_DiodeBiasLevel(ValueToOrd(fDevice.Value,kt_mDiod));
   dm_vrp_VRMethod:(PM as TDMM6500MeasPar_VoltRat).VRMethod:=TDMM6500_VoltageRatioMethod(round(fDevice.Value));
   dm_pp_OffsetCompen:(PM as TDMM6500MeasPar_Base4WT).OffsetComp:=TDMM6500_OffsetCompen(round(fDevice.Value));
   dm_pp_OpenLeadDetector:(PM as TDMM6500MeasPar_Base4WT).OpenLeadDetector:=(fDevice.Value=1);
   dm_pp_LineSync:(PM as TDMM6500MeasPar_Continuity).LineSync:=(fDevice.Value=1);
   dm_pp_AzeroState: (PM as TDMM6500MeasPar_Continuity).AzeroState:=(fDevice.Value=1);
   dm_pp_DetectorBW: (PM as TDMM6500MeasPar_BaseAC).DetectorBW:=TDMM6500_DetectorBandwidth(round(fDevice.Value));
   dm_pp_InputImpedance: GetMeasPar_BaseVoltDC(FM,PM).InputImpedance:=TDMM6500_InputImpedance(round(fDevice.Value));
   dm_pp_Units:begin
                if FM=kt_mTemp then (PM as TDMM6500MeasPar_Temper).Units:=TDMM6500_TempUnits(round(fDevice.Value));
                if (FM in [kt_mVolDC,kt_mVolAC,kt_mDigVolt]) then
                    GetMeasPar_BaseVolt(FM,PM).Units:=TDMM6500_VoltageUnits(round(fDevice.Value));
               end;
   dm_pp_DbmWReference:GetMeasPar_BaseVolt(FM,PM).DBM:=round(fDevice.Value);
   dm_pp_DecibelReference:GetMeasPar_BaseVolt(FM,PM).DB:=fDevice.Value;
   dm_pp_MeasureTime:(PM as TDMM6500MeasPar_BaseDelayMT).MeaureTime:=fDevice.Value*1e3;
   dm_pp_SampleRate: (PM as TDMM6500MeasPar_BaseDig).SampleRate:=round(fDevice.Value);
   dm_pp_DelayAuto:(PM as TDMM6500MeasPar_BaseDelay).AutoDelay:=(fDevice.Value=1);
   dm_pp_ThresholdRange:(PM as TDMM6500MeasPar_FreqPeriod).ThresholdRange:=TDMM6500_VoltageACRange(ValueToOrd(fDevice.Value,FM));
   dm_pp_Range: case FM of
                   kt_mVolDC:(PM as TDMM6500MeasPar_VoltDC).Range:=TDMM6500_VoltageDCRange(ValueToOrd(fDevice.Value,FM));
                   kt_mVoltRat: (PM as TDMM6500MeasPar_VoltRat).Range:=TDMM6500_VoltageDCRange(ValueToOrd(fDevice.Value,FM));
                   kt_mVolAC: (PM as TDMM6500MeasPar_VoltAC).Range:=TDMM6500_VoltageACRange(ValueToOrd(fDevice.Value,FM));
                   kt_mCurDC: (PM as TDMM6500MeasPar_CurDC).Range:=TDMM6500_CurrentDCRange(ValueToOrd(fDevice.Value,FM));
                   kt_mCurAC: (PM as TDMM6500MeasPar_CurAC).Range:=TDMM6500_CurrentACRange(ValueToOrd(fDevice.Value,FM));
                   kt_mRes2W: (PM as TDMM6500MeasPar_Res2W).Range:=TDMM6500_Resistance2WRange(ValueToOrd(fDevice.Value,FM));
                   kt_mRes4W: (PM as TDMM6500MeasPar_Res4W).Range:=TDMM6500_Resistance4WRange(ValueToOrd(fDevice.Value,FM));
                   kt_mCap: (PM as TDMM6500MeasPar_Capac).Range:=TDMM6500_CapacitanceRange(ValueToOrd(fDevice.Value,FM));
                   kt_mDigCur:(PM as TDMM6500MeasPar_DigCur).Range:=TDMM6500_CurrentDCRange(ValueToOrd(fDevice.Value,FM));
                   kt_mDigVolt:(PM as TDMM6500MeasPar_DigVolt).Range:=TDMM6500_VoltageDCRange(ValueToOrd(fDevice.Value,FM));
                end;
 end;
end;

procedure TDMM6500.GetActionRangeAutoProcedureByMParam(FM: TKeitley_Measure;
  PM: TDMM6500MeasPar_Base; MParam: TDMM6500_MeasParameters);
begin
 case MParam of
  dm_pp_Range:  case FM of
                 kt_mVolDC:(PM as TDMM6500MeasPar_VoltDC).Range:=dm_vdrAuto;
                 kt_mVoltRat: (PM as TDMM6500MeasPar_VoltRat).Range:=dm_vdrAuto;
                 kt_mVolAC: (PM as TDMM6500MeasPar_VoltAC).Range:=dm_varAuto;
                 kt_mCurDC: (PM as TDMM6500MeasPar_CurDC).Range:=dm_cdrAuto;
                 kt_mCurAC: (PM as TDMM6500MeasPar_CurAC).Range:=dm_carAuto;
                 kt_mRes2W: (PM as TDMM6500MeasPar_Res2W).Range:=dm_r2rAuto;
                 kt_mRes4W: (PM as TDMM6500MeasPar_Res4W).Range:=dm_r4rAuto;
                 kt_mCap: (PM as TDMM6500MeasPar_Capac).Range:=dm_crAuto;
//                 else begin
//                       Result:=False;
//                       Exit;
//                      end;
                end;
  dm_pp_ThresholdRange:(PM as TDMM6500MeasPar_FreqPeriod).ThresholdRange:=dm_varAuto;
 end;
end;

function TDMM6500.GetActionRangeShablon(FM: TKeitley_Measure;
  PM: TDMM6500MeasPar_Base; MParam: TDMM6500_MeasParameters): boolean;
begin

 Result:=False;
 if not(PermitForParameter(FM,MParam)) then Exit;
 QuireOperation(MeasureToRootNodeNumber(FM),ParametrToFLNode(MParam),0);
 Result:=(fDevice.Value<>ErResult);
 if not(Result) then Exit;

 if fDevice.Value=1
   then GetActionRangeAutoProcedureByMParam(FM,PM,MParam)
   else
    begin
      try
        QuireOperation(MeasureToRootNodeNumber(FM),ParametrToFLNode(MParam),1);
        Result:=(fDevice.Value<>ErResult);
        if Result then GetActionProcedureByMParam(FM,PM,MParam);
      except
       Result:=False;
      end;
    end;
end;

function TDMM6500.GetActionShablon(FM: TKeitley_Measure;
  PM: TDMM6500MeasPar_Base; MParam: TDMM6500_MeasParameters): boolean;
begin
 if PermitForParameter(FM,MParam) then
  begin
    try
      QuireOperation(MeasureToRootNodeNumber(FM),ParametrToFLNode(MParam),ParameterToLeafNode(MParam,FM));
      Result:=SuccessfulGet(MParam);
      if Result then GetActionProcedureByMParam(FM,PM,MParam);
    except
     Result:=False;
    end;
  end           else
  Result:=False;
end;

//function TDMM6500.GetActionShablon(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; PermitFunc: TPermittedMeasureFunction;
//  GetActionProc: TGetActionProc; FirstLevelNode, LeafNode: byte): boolean;
//begin
// if PermitFunc(FM) then
//  begin
//    try
//      QuireOperation(MeasureToRootNodeNumber(FM),FirstLevelNode,LeafNode);
//      Result:=fDevice.isReceived;
//      if Result then GetActionProc(PM);
//    except
//     Result:=False;
//    end;
//  end           else
//  Result:=False;
//end;

function TDMM6500.GetAperture(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_pp_Aperture,ChanNumber);
// if ChanNumber=0
//    then Result:=GetApertureAction(fMeasureFunction)
//    else
//     begin
//       if ChanQuireBegin(ChanNumber) then
//        begin
//          Result:=GetApertureAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction);
//          fChanOperation:=False;
//        end                          else
//          Result:=False;
//     end;
end;

//function TDMM6500.GetApertureAction(FM: TKeitley_Measure): boolean;
//begin
// if FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
//                   kt_mRes4W,
//                   kt_mDiod,kt_mTemp,
//                   kt_mFreq,kt_mPer,
//                   kt_mVoltRat,kt_mDigCur,kt_mDigVolt] then
//  begin
//   QuireOperation(MeasureToRootNodeNumber(FM),51);
//   Result:=(fDevice.Value<>ErResult);
//  end                                       else
//  Result:=False;
//end;

function TDMM6500.GetAzeroState(ChanNumber: byte): boolean;
begin
  Result:=GetShablon(dm_pp_AzeroState,ChanNumber);
//  Result:=GetShablon(GetAzeroStateAction,ChanNumber);
end;

//function TDMM6500.GetAzeroStateAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
// if FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
//      kt_mRes4W,kt_mDiod,kt_mTemp,kt_mVoltRat] then
//  begin
//   QuireOperation(MeasureToRootNodeNumber(FM),20);
//   Result:=(fDevice.Value<>ErResult);
//   if Result then
//     (PM as TDMM6500MeasPar_Continuity).AzeroState:=(fDevice.Value=1);
//  end                   else
//   Result:=False;
//end;

function TDMM6500.GetBiasLevel(ChanNumber: byte): boolean;
begin
  Result:=GetShablon(dm_dp_BiasLevel,ChanNumber);
// Result:=GetShablon(PermitDiode,GetBiasLevelAction,58,0,ChanNumber);
// Result:=GetShablon(GetBiasLevelAction,ChanNumber);
end;

//function TDMM6500.GetBiasLevelAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//procedure TDMM6500.GetBiasLevelAction(PM: TDMM6500MeasPar_Base);
//begin
// if FM=kt_mDiod then
//  begin
//    try
//      QuireOperation(MeasureToRootNodeNumber(FM),58);
//      Result:=(fDevice.Value<>ErResult);
//      if Result then
//         (PM as TDMM6500MeasPar_Diode).BiasLevel:=ValueToBiasLevel(fDevice.Value);
//    except
//     Result:=False;
//    end;
//  end           else
//  Result:=False;
//end;

procedure TDMM6500.GetCardParametersFromDevice;
begin
  if TestRealCard_Presence then
  begin
    GetFirstChannelInSlot();
    GetLastChannelInSlot();
    GetChannelMaxVoltage();
    if High(fChansMeasure)<> fLastChannelInSlot-fFirstChannelInSlot
      then ChansMeasureCreate();
  end;
end;

function TDMM6500.GetChannelMaxVoltage: boolean;
begin
//:SYST:CARD1:VMAX?
 QuireOperation(7,45,3);
 Result:=fDevice.Value<>ErResult;
 if Result then fChannelMaxVoltage:=fDevice.Value;
end;

function TDMM6500.GetCount(ChanNumber: byte): boolean;
 var tempCount:integer;
begin
 if ChanNumber=0
   then Result:=GetCount()
   else
    begin
     tempCount:=Count;
     if ChanQuireBegin(ChanNumber) then
      begin
        Result := GetCount;
        fChanOperation:=False;
      end                          else
        Result:=False;
     if Result then fChansMeasure[ChanNumber-fFirstChannelInSlot].Count:=Count;
     Count:=tempCount;
    end;
end;

function TDMM6500.GetCountDig(ChanNumber: byte): boolean;
begin
 if ChanNumber=0
    then Result:=GetCountDigAction(CountDig)
    else
     begin
       if ChanQuireBegin(ChanNumber) then
        begin
          Result:=GetCountDigAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].CountDig);
          fChanOperation:=False;
        end                          else
          Result:=False;
     end;



// if ChanQuireBegin(ChanNumber) then
//  begin
//    QuireOperation(23,20);
//    Result:=fDevice.isReceived;
//    if Result then fChansMeasure[ChanNumber-fFirstChannelInSlot].CountDig:=round(fDevice.Value);
//    fChanOperation:=False;
//  end                          else
//    Result:=False;
end;

function TDMM6500.GetCountDigAction(DeviceCountDig: integer): boolean;
begin
 QuireOperation(23,20);
 Result:=fDevice.isReceived;
 if Result then DeviceCountDig:=round(fDevice.Value);
 sin(DeviceCountDig);
end;

//function TDMM6500.GetCountDig: boolean;
//begin
// QuireOperation(23,20);
// Result:=fDevice.isReceived;
// if Result then CountDig:=round(fDevice.Value);
//end;

//function TDMM6500.GetDecibelReference: boolean;
////  var BaseV:IMeasPar_BaseVolt;
//begin
// Result:=GetDecibelReferenceAction(fMeasureFunction,MeasParameters);
//
//// Result:=False;
////
//// BaseV:=GetMeasPar_BaseVolt(fMeasureFunction,MeasParameters);
//// if BaseV<>nil then
////  begin
////   QuireOperation(MeasureToRootNodeNumber(fMeasureFunction),48);
////   Result:=(fDevice.Value<>ErResult);
////   if Result then BaseV.DB:=fDevice.Value;
////  end;
//end;

//function TDMM6500.GetDbmWReference: boolean;
//  var BaseV:IMeasPar_BaseVolt;
//begin
//  Result:=False;
//
//  BaseV:=GetMeasPar_BaseVolt(fMeasureFunction,MeasParameters);
//  if BaseV=nil then Exit;
//  QuireOperation(MeasureToRootNodeNumber(fMeasureFunction),49);
//  Result:=fDevice.isReceived;
//  if Result then BaseV.DBM:=round(fDevice.Value);
//end;

function TDMM6500.GetDbmWReference(ChanNumber: byte): boolean;
//  var BaseV:IMeasPar_BaseVolt;
begin
 Result:=GetShablon(dm_pp_DbmWReference,ChanNumber);

// Result:=GetShablon(GetDbmWReferenceAction,ChanNumber);


// if ChanNumber=0
//    then Result:=GetDbmWReferenceAction(fMeasureFunction,MeasParameters)
//    else
//     begin
//       if ChanQuireBegin(ChanNumber) then
//        begin
//          Result:=GetDbmWReferenceAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                         fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters);
//          fChanOperation:=False;
//        end                          else
//          Result:=False;
//     end;



// if ChanQuireBegin(ChanNumber) then
//  begin
//    Result:=False;
//    BaseV:=GetMeasPar_BaseVolt(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                   fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters);
//    if BaseV<>nil then
//     begin
//      QuireOperation(MeasureToRootNodeNumber(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction),49);
//      Result:=fDevice.isReceived;
//      if Result then BaseV.DBM:=round(fDevice.Value);
//     end;
//    fChanOperation:=False;
//  end                          else
//    Result:=False;
end;

//function TDMM6500.GetDbmWReferenceAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//  var BaseV:IMeasPar_BaseVolt;
//begin
//  BaseV:=GetMeasPar_BaseVolt(FM,PM);
//  if BaseV<>nil then
//   begin
//    QuireOperation(MeasureToRootNodeNumber(FM),49);
//    Result:=fDevice.isReceived;
//    if Result then BaseV.DBM:=round(fDevice.Value);
//   end          else
//   Result:=False;
//end;

function TDMM6500.GetDecibelReference(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_pp_DecibelReference,ChanNumber);

// Result:=GetShablon(GetDecibelReferenceAction,ChanNumber);
// if ChanNumber=0
//    then Result:=GetDecibelReferenceAction(fMeasureFunction,MeasParameters)
//    else
//     begin
//       if ChanQuireBegin(ChanNumber) then
//        begin
//          Result:=GetDecibelReferenceAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                         fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters);
//          fChanOperation:=False;
//        end                          else
//          Result:=False;
//     end;
end;

//function TDMM6500.GetDecibelReferenceAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//  var BaseV:IMeasPar_BaseVolt;
//begin
// BaseV:=GetMeasPar_BaseVolt(FM,PM);
// if BaseV<>nil then
//  begin
//   QuireOperation(MeasureToRootNodeNumber(fMeasureFunction),48);
//   Result:=(fDevice.Value<>ErResult);
//   if Result then BaseV.DB:=fDevice.Value;
//  end          else
//  Result:=False;
//end;

//function TDMM6500.GetDelayAutoAction(Measure: TKeitley_Measure;PM: TDMM6500MeasPar_Base): boolean;
//begin
// if Measure<kt_mDigCur then
//  begin
//   QuireOperation(MeasureToRootNodeNumber(Measure),22);
//   Result:=(fDevice.Value<>ErResult);
//   if Result then
//     (PM as TDMM6500MeasPar_BaseDelay).AutoDelay:=(fDevice.Value=1);
//  end                   else
//   Result:=False;
//end;

function TDMM6500.GetDisplayDigitsNumber(ChanNumber: byte): boolean;
begin
 if ChanNumber=0
    then Result:=GetDisplayDigitsNumberAction(fMeasureFunction,MeasParameters)
    else
     begin
       if ChanQuireBegin(ChanNumber) then
        begin
          Result:=GetDisplayDigitsNumberAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
                         fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters);
          fChanOperation:=False;
        end                          else
          Result:=False;
     end;


//  Result:=GetShablon(GetDisplayDigitsNumberAction,ChanNumber);
// if ChanQuireBegin(ChanNumber) then
//  begin
//    Result := inherited GetDisplayDigitsNumber(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction);
//    fChanOperation:=False;
//  end                          else
//    Result:=False;
// if Result then fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters.DisplayDN:=round(fDevice.Value);
end;

function TDMM6500.GetDisplayDigitsNumberAction(Measure: TKeitley_Measure;
  PM: TDMM6500MeasPar_Base): boolean;
begin
 Result:=inherited GetDisplayDigitsNumber(Measure);
 if Result then
  PM.DisplayDN:=round(fDevice.Value);
end;

function TDMM6500.GetDisplayDigitsNumber: boolean;
begin
 MeasParameterCreate(fMeasureFunction);
 Result:=GetDisplayDigitsNumberAction(fMeasureFunction,MeasParameters);

// Result:=inherited GetDisplayDigitsNumber(MeasureFunction);
// if Result then
//  MeasParameters.DisplayDN:=round(fDevice.Value);
end;

function TDMM6500.GetDisplayDigitsNumber(Measure: TKeitley_Measure): boolean;
begin
 MeasParameterCreate(Measure);
 Result:=GetDisplayDigitsNumberAction(Measure,fMeasParameters[Measure]);

//  Result:=inherited GetDisplayDigitsNumber(Measure);
//  if Result then
//   begin
//    if not(assigned(fMeasParameters[Measure])) then
//     fMeasParameters[Measure]:=DMM6500MeasParFactory(Measure);
//    fMeasParameters[Measure].DisplayDN:=round(fDevice.Value);
//   end;
end;

function TDMM6500.GetFirstChannelInSlot: boolean;
begin
//:SYST:CARD1:VCH:STAR?
 QuireOperation(7,45,1);
 Result:=fDevice.Value<>ErResult;
 if Result then fFirstChannelInSlot:=round(fDevice.Value);
end;

function TDMM6500.GetInputImpedance(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_pp_InputImpedance,ChanNumber);
// Result:=GetShablon(GetInputImpedanceAction,ChanNumber);
end;

//function TDMM6500.GetInputImpedanceAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//  var BaseV:IMeasPar_BaseVoltDC;
//begin
//  BaseV:=GetMeasPar_BaseVoltDC(FM,PM);
//  if BaseV<>nil then
//   begin
//    QuireOperation(MeasureToRootNodeNumber(FM),52);
//    Result:=fDevice.Value<>ErResult;
//    if Result then BaseV.InputImpedance:=TDMM6500_InputImpedance(round(fDevice.Value));
//   end          else
//    Result:=False;
//end;

function TDMM6500.GetLastChannelInSlot: boolean;
begin
//:SYST:CARD1:VCH:END?
 QuireOperation(7,45,2);
 Result:=fDevice.Value<>ErResult;
 if Result then fLastChannelInSlot:=round(fDevice.Value);
end;

function TDMM6500.GetLineSync(ChanNumber: byte): boolean;
begin
  Result:=GetShablon(dm_pp_LineSync,ChanNumber);
//  Result:=GetShablon(GetLineSyncAction,ChanNumber);
end;

//function TDMM6500.GetLineSyncAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
//  if FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
//      kt_mRes4W,kt_mTemp,kt_mCont,kt_mVoltRat] then
//   begin
//    QuireOperation(MeasureToRootNodeNumber(FM),54);
//    Result:=(fDevice.Value<>ErResult);
//    if Result then
//      (PM as TDMM6500MeasPar_Continuity).LineSync:=(fDevice.Value=1);
//   end                           else
//    Result:=False;
//end;

//function TDMM6500.GetMeasureFunction: boolean;
//begin
// Result:= inherited GetMeasureFunction;
// if Result then fTerminalMeasureFunction[Terminal]:=MeasureFunction;
//end;


function TDMM6500.GetMeasParameters: TDMM6500MeasPar_Base;
begin
 MeasParameterCreate(FMeasureFunction);
// if not(Assigned(fMeasParameters[FMeasureFunction]))
//  then fMeasParameters[FMeasureFunction]:=DMM6500MeasParFactory(FMeasureFunction);
 Result:=fMeasParameters[FMeasureFunction];
end;

function TDMM6500.MeasFuncByCN(ChanNumber: byte): TKeitley_Measure;
begin
   if ChanNumber=0
   then result:=MeasureFunction
   else
     begin
      if ChanelNumberIsCorrect(ChanNumber)
       then Result:=fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction
       else Result:=MeasureFunction;
     end;
end;

function TDMM6500.MeasParamByCN(
  ChanNumber: byte): TDMM6500MeasPar_Base;
begin
   if ChanNumber=0
   then result:=MeasParameters
   else
     begin
      if ChanelNumberIsCorrect(ChanNumber)
       then Result:=fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters
       else Result:=nil;
     end;
end;

function TDMM6500.GetMeasPar_BaseVolt(FM: TKeitley_Measure;
  PM: TDMM6500MeasPar_Base): IMeasPar_BaseVolt;
begin
 case FM of
   kt_mVolDC:Result:=(PM as TDMM6500MeasPar_VoltDC);
   kt_mVolAC:Result:=(PM as TDMM6500MeasPar_VoltAC);
   kt_mDigVolt:Result:=(PM as TDMM6500MeasPar_DigVolt);
   else Result:=nil;
 end;
end;

function TDMM6500.GetMeasPar_BaseVoltDC(FM: TKeitley_Measure;
  PM: TDMM6500MeasPar_Base): IMeasPar_BaseVoltDC;
begin
 case FM of
   kt_mVolDC:Result:=(PM as TDMM6500MeasPar_VoltDC);
   kt_mDigVolt:Result:=(PM as TDMM6500MeasPar_DigVolt);
   else Result:=nil;
 end;
end;

function TDMM6500.GetMeasureFunction(ChanNumber: byte): boolean;
begin
 if ChanNumber=0
 then Result:=GetMeasureFunction()
 else
  begin
   if ChanelNumberIsCorrect(ChanNumber) then
     begin
       fMeasureChanNumber:=ChanNumber;
       fChanOperationString:=' '+ChanelToString(ChanNumber);
       fChanOperation:=True;
       Result := inherited GetMeasureFunction;
       fChanOperation:=False;
     end                                else
       Result:=False;
   if Result then fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction:=MeasureFunction;
  end;
end;



function TDMM6500.GetMeasureTime(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_pp_MeasureTime,ChanNumber);
// Result:=GetShablon(GetMeasureTimeAction,ChanNumber);
end;

//function TDMM6500.GetMeasureTimeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
// case FM of
//  kt_mCurDC,
//  kt_mVolDC,
//  kt_mRes2W,
//  kt_mRes4W,
//  kt_mDiod,
//  kt_mTemp,
//  kt_mVoltRat,
//  kt_mFreq,
//  kt_mPer:
//      begin
//       Result:=GetApertureAction(FM);
//       if Result then (PM as TDMM6500MeasPar_BaseDelayMT).MeaureTime:=fDevice.Value*1e-3;
//      end;
////  kt_mCont:
////      begin
////       Result:=GetNPLCAction(FM);
////       if Result then
////        (PM as TDMM6500MeasPar_BaseDelayMT).MeaureTime:=fDevice.Value*Keitley_MeaureTimeConvertConst;
////      end;
//  else Result:=False;
//end;
//end;

function TDMM6500.GetNPLC(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_pp_NPLC,ChanNumber);
// if ChanNumber=0
//    then Result:=GetNPLCAction(fMeasureFunction)
//    else
//     begin
//       if ChanQuireBegin(ChanNumber) then
//        begin
//          Result:=GetNPLCAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction);
//          fChanOperation:=False;
//        end                          else
//          Result:=False;
//     end;
end;

//function TDMM6500.GetNPLCAction(FM: TKeitley_Measure): boolean;
//begin
// if FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
//   kt_mRes4W,kt_mDiod,kt_mTemp,kt_mVoltRat] then
//  begin
//   QuireOperation(MeasureToRootNodeNumber(FM),26);
//   Result:=(fDevice.Value<>ErResult);
//  end                                       else
//  Result:=False;
//end;

function TDMM6500.GetOffsetComp(ChanNumber: byte): boolean;
begin
  Result:=GetShablon(dm_pp_OffsetCompen,ChanNumber);
// Result:=GetShablon(GetOffsetCompAction,ChanNumber);
end;

//function TDMM6500.GetOffsetCompAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
//  if FM in [kt_mRes4W,kt_mTemp] then
//   begin
//    QuireOperation(MeasureToRootNodeNumber(FM),9);
//    Result:=(fDevice.Value<>ErResult);
//    if Result then
//      (PM as TDMM6500MeasPar_Base4WT).OffsetComp:=TDMM6500_OffsetCompen(round(fDevice.Value));
//   end                           else
//    Result:=False;
//end;

function TDMM6500.GetOpenLD(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_pp_OpenLeadDetector,ChanNumber);
// Result:=GetShablon(GetOpenLDAction,ChanNumber);
end;

//function TDMM6500.GetOpenLDAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
//  if FM in [kt_mRes4W,kt_mTemp] then
//   begin
//    QuireOperation(MeasureToRootNodeNumber(FM),55);
//    Result:=(fDevice.Value<>ErResult);
//    if Result then
//      (PM as TDMM6500MeasPar_Base4WT).OpenLeadDetector:=(fDevice.Value=1);
//   end                           else
//    Result:=False;
//end;

procedure TDMM6500.GetParametersFromDevice;
begin
  inherited GetParametersFromDevice;
  GetCardParametersFromDevice;

end;

function TDMM6500.GetRange(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_pp_Range,ChanNumber);
// Result:=GetShablon(GetRangeAction,ChanNumber);
end;

//function TDMM6500.GetRangeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
// Result:=False;
// if not(FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
//     kt_mCurAC,kt_mVolAC,kt_mRes4W,kt_mCap,
//     kt_mVoltRat,kt_mDigCur,kt_mDigVolt]) then Exit;
//
// QuireOperation(MeasureToRootNodeNumber(FM),16);
// Result:=(fDevice.Value<>ErResult);
// if not(Result) then Exit;
//
// if fDevice.Value=1 then
//  case FM of
//     kt_mVolDC:(PM as TDMM6500MeasPar_VoltDC).Range:=dm_vdrAuto;
//     kt_mVoltRat: (PM as TDMM6500MeasPar_VoltRat).Range:=dm_vdrAuto;
//     kt_mVolAC: (PM as TDMM6500MeasPar_VoltAC).Range:=dm_varAuto;
//     kt_mCurDC: (PM as TDMM6500MeasPar_CurDC).Range:=dm_cdrAuto;
//     kt_mCurAC: (PM as TDMM6500MeasPar_CurAC).Range:=dm_carAuto;
//     kt_mRes2W: (PM as TDMM6500MeasPar_Res2W).Range:=dm_r2rAuto;
//     kt_mRes4W: (PM as TDMM6500MeasPar_Res4W).Range:=dm_r4rAuto;
//     kt_mCap: (PM as TDMM6500MeasPar_Capac).Range:=dm_crAuto;
//     else begin
//           Result:=False;
//           Exit;
//          end;
//  end              else
//  begin
//    try
//      QuireOperation(MeasureToRootNodeNumber(FM),15);
//      Result:=(fDevice.Value<>ErResult);
//      if Result then
//      case FM of
//         kt_mVolDC:(PM as TDMM6500MeasPar_VoltDC).Range:=ValueToDCVoltageRange(fDevice.Value);
//         kt_mVoltRat: (PM as TDMM6500MeasPar_VoltRat).Range:=ValueToDCVoltageRange(fDevice.Value);
//         kt_mVolAC: (PM as TDMM6500MeasPar_VoltAC).Range:=ValueToACVoltageRange(fDevice.Value);
//         kt_mCurDC: (PM as TDMM6500MeasPar_CurDC).Range:=ValueToDCCurrentRange(fDevice.Value);
//         kt_mCurAC: (PM as TDMM6500MeasPar_CurAC).Range:=ValueToACCurrentRange(fDevice.Value);
//         kt_mRes2W: (PM as TDMM6500MeasPar_Res2W).Range:=ValueToResistance2WRange(fDevice.Value);
//         kt_mRes4W: (PM as TDMM6500MeasPar_Res4W).Range:=ValueToResistance4WRange(fDevice.Value);
//         kt_mCap: (PM as TDMM6500MeasPar_Capac).Range:=ValueToCapacitanceRange(fDevice.Value);
//         kt_mDigCur:(PM as TDMM6500MeasPar_DigCur).Range:=ValueToDCCurrentRange(fDevice.Value);
//         kt_mDigVolt:(PM as TDMM6500MeasPar_DigVolt).Range:=ValueToDCVoltageRange(fDevice.Value);
//      end
//    except
//     Result:=False;
//    end;
//  end;
//end;

function TDMM6500.GetRefJunction(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_tp_RefJunction,ChanNumber);
// Result:=GetShablon(GetRefJunctionAction,ChanNumber);
end;

//function TDMM6500.GetRefJunctionAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//procedure TDMM6500.GetRefJunctionAction(PM: TDMM6500MeasPar_Base);
//begin
// if FM=kt_mTemp then
//  begin
//    try
//      QuireOperation(33,60,1);
//      Result:=(fDevice.Value<>ErResult);
//      if Result then
//        (PM as TDMM6500MeasPar_Temper).RefJunction:=TDMM6500_TCoupleRefJunct(round(fDevice.Value));
//    except
//     Result:=False;
//    end;
//  end           else
//  Result:=False;
//end;

function TDMM6500.GetRefTemperature(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_tp_SimRefTemp,ChanNumber);
// Result:=GetShablon(GetRefTemperatureAction,ChanNumber);
end;

//function TDMM6500.GetRefTemperatureAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
// if FM=kt_mTemp then
//  begin
//    try
//      QuireOperation(33,60,0);
//      Result:=(fDevice.Value<>ErResult);
//      if Result then
//         (PM as TDMM6500MeasPar_Temper).RefTemperature:=fDevice.Value;
//    except
//     Result:=False;
//    end;
//  end           else
//  Result:=False;
//end;

function TDMM6500.GetRTDAlpha(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_tp_RTDAlpha,ChanNumber);
// Result:=GetShablon(GetRTDAlphaAction,ChanNumber);
end;

//function TDMM6500.GetRTDAlphaAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
// if FM=kt_mTemp then
//  begin
//    try
//      QuireOperation(33,59,0);
//      Result:=(fDevice.Value<>ErResult);
//      if Result then
//         (PM as TDMM6500MeasPar_Temper).RTD_Alpha:=fDevice.Value;
//    except
//     Result:=False;
//    end;
//  end           else
//  Result:=False;
//end;

function TDMM6500.GetRTDBeta(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_tp_RTDBeta,ChanNumber);
// Result:=GetShablon(GetRTDBetaAction,ChanNumber);
end;

//function TDMM6500.GetRTDBetaAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
// if FM=kt_mTemp then
//  begin
//    try
//      QuireOperation(33,59,1);
//      Result:=(fDevice.Value<>ErResult);
//      if Result then
//         (PM as TDMM6500MeasPar_Temper).RTD_Beta:=fDevice.Value;
//    except
//     Result:=False;
//    end;
//  end           else
//  Result:=False;
//end;

function TDMM6500.GetRTDDelta(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_tp_RTDDelta,ChanNumber);
// Result:=GetShablon(GetRTDDeltaAction,ChanNumber);
end;

//function TDMM6500.GetRTDDeltaAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
// if FM=kt_mTemp then
//  begin
//    try
//      QuireOperation(33,59,2);
//      Result:=(fDevice.Value<>ErResult);
//      if Result then
//         (PM as TDMM6500MeasPar_Temper).RTD_Delta:=fDevice.Value;
//    except
//     Result:=False;
//    end;
//  end           else
//  Result:=False;
//end;

function TDMM6500.GetRTDZero(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_tp_RTDZero,ChanNumber);
// Result:=GetShablon(GetRTDZeroAction,ChanNumber);
end;

//function TDMM6500.GetRTDZeroAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
// if FM=kt_mTemp then
//  begin
//    try
//      QuireOperation(33,59,3);
//      Result:=fDevice.isReceived;
//      if Result then
//         (PM as TDMM6500MeasPar_Temper).RTD_Zero:=round(fDevice.Value);
//    except
//     Result:=False;
//    end;
//  end           else
//  Result:=False;
//end;

function TDMM6500.GetSampleRate(Measure: TKeitley_Measure): boolean;
begin
 Result:=GetShablon(dm_pp_SampleRate,Measure);
// MeasParameterCreate(Measure);
//// if not(assigned(fMeasParameters[Measure])) then
////      fMeasParameters[Measure]:=DMM6500MeasParFactory(Measure);
// Result:=GetSampleRateAction(Measure,fMeasParameters[Measure]);
end;

//function TDMM6500.GetSampleRate: boolean;
//begin
// Result:=GetSampleRateAction(fMeasureFunction);
// if Result then
//   (MeasParameters as TDMM6500MeasPar_BaseDig).SampleRate:=round(fDevice.Value);
//end;

function TDMM6500.GetSampleRate(ChanNumber: byte): boolean;
begin
  Result:=GetShablon(dm_pp_SampleRate,ChanNumber);
//  Result:=GetShablon(GetSampleRateAction,ChanNumber);
// if ChanQuireBegin(ChanNumber) then
//  begin
//    Result := GetSampleRateAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction);
//    fChanOperation:=False;
//  end                          else
//    Result:=False;
// if Result then
//  (fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters as TDMM6500MeasPar_BaseDig).SampleRate:=round(fDevice.Value);
end;

//function TDMM6500.GetSampleRateAction(Measure: TKeitley_Measure;PM: TDMM6500MeasPar_Base): boolean;
//begin
// if Measure>kt_mVoltRat then
//  begin
//   QuireOperation(MeasureToRootNodeNumber(Measure),47);
//   Result:=(fDevice.Value>=Low(TDMM6500_DigSampleRate))
//            and (fDevice.Value<=High(TDMM6500_DigSampleRate));
//   if Result then
//    (PM as TDMM6500MeasPar_BaseDig).SampleRate:=round(fDevice.Value);
//  end                   else
//   Result:=False;
//end;

//function TDMM6500.GetShablon(PermitFunc: TPermittedMeasureFunction;
//  GetActionProc: TGetActionProc; FirstLevelNode, LeafNode,
//  ChanNumber: byte): boolean;
//begin
// if ChanNumber=0
//    then Result:=GetActionShablon(fMeasureFunction,MeasParameters,
//                     PermitFunc,GetActionProc,FirstLevelNode,LeafNode)
//    else
//     begin
//       if ChanQuireBegin(ChanNumber) then
//        begin
//          Result:=GetActionShablon(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                         fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                         PermitFunc,GetActionProc,FirstLevelNode,LeafNode);
//          fChanOperation:=False;
//        end                          else
//          Result:=False;
//     end;
//end;

//function TDMM6500.GetShablon(QuireFunc: TQuireFunctionRTDType;
//  WiType: TDMM6500_RTDPropertyNumber; ChanNumber: byte): boolean;
//begin
// if ChanNumber=0
//    then Result:=QuireFunc(fMeasureFunction,MeasParameters,WiType)
//    else
//     begin
//       if ChanQuireBegin(ChanNumber) then
//        begin
//          Result:=QuireFunc(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                         fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,WiType);
//          fChanOperation:=False;
//        end                          else
//          Result:=False;
//     end;
//end;

//function TDMM6500.GetUnits: boolean;
//  var BaseV:IMeasPar_BaseVolt;
//begin
//  Result:=False;
//  if fMeasureFunction=kt_mTemp then
//   begin
//    QuireOperation(MeasureToRootNodeNumber(fMeasureFunction),50,1);
//    Result:=(fDevice.Value<>ErResult);
//    if Result then
//      (MeasParameters as TDMM6500MeasPar_Temper).Units:=TDMM6500_TempUnits(round(fDevice.Value));
//   end                         else
//   begin
//     BaseV:=GetMeasPar_BaseVolt(fMeasureFunction,MeasParameters);
//     if BaseV=nil then Exit;
//     QuireOperation(MeasureToRootNodeNumber(fMeasureFunction),50,2);
//     Result:=(fDevice.Value<>ErResult);
//     if Result then
//      BaseV.Units:=TDMM6500_VoltageUnits(round(fDevice.Value));
//   end;
//end;

function TDMM6500.GetUnits(ChanNumber: byte): boolean;
//  var BaseV:IMeasPar_BaseVolt;
begin
 Result:=GetShablon(dm_pp_Units,ChanNumber);
// Result:=GetShablon(GetUnitsAction,ChanNumber);

// if ChanQuireBegin(ChanNumber) then
//  begin
//    Result:=False;
//    if fMeasureFunction=kt_mTemp then
//         begin
//          QuireOperation(MeasureToRootNodeNumber(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction),50,1);
//          Result:=(fDevice.Value<>ErResult);
//          if Result then
//            (fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters as TDMM6500MeasPar_Temper).Units:=TDMM6500_TempUnits(round(fDevice.Value));
//         end                         else
//         begin
//           BaseV:=GetMeasPar_BaseVolt(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                   fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters);
//           if BaseV<>nil then
//            begin
//             QuireOperation(MeasureToRootNodeNumber(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction),50,2);
//             Result:=(fDevice.Value<>ErResult);
//             if Result then
//               BaseV.Units:=TDMM6500_VoltageUnits(round(fDevice.Value));
//            end;
//         end;
//    fChanOperation:=False;
//  end                          else
//    Result:=False;
end;

//function TDMM6500.GetUnitsAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//  var BaseV:IMeasPar_BaseVolt;
//begin
//  Result:=False;
//  if FM=kt_mTemp then
//   begin
//    QuireOperation(MeasureToRootNodeNumber(FM),50,1);
//    Result:=(fDevice.Value<>ErResult);
//    if Result then
//      (PM as TDMM6500MeasPar_Temper).Units:=TDMM6500_TempUnits(round(fDevice.Value));
//   end                         else
//   begin
//     BaseV:=GetMeasPar_BaseVolt(FM,PM);
//     if BaseV<>nil then
//       begin
//         QuireOperation(MeasureToRootNodeNumber(FM),50,2);
//         Result:=(fDevice.Value<>ErResult);
//         if Result then
//          BaseV.Units:=TDMM6500_VoltageUnits(round(fDevice.Value));
//       end;
//   end;
//end;

function TDMM6500.GetVRMethod(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_vrp_VRMethod,ChanNumber);
// Result:=GetShablon(GetVRMethodAction,ChanNumber);
end;

//function TDMM6500.GetVRMethodAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
//  if FM=kt_mVoltRat then
//   begin
//    QuireOperation(MeasureToRootNodeNumber(FM),57);
//    Result:=(fDevice.Value<>ErResult);
//    if Result then
//      (PM as TDMM6500MeasPar_VoltRat).VRMethod:=TDMM6500_VoltageRatioMethod(round(fDevice.Value));
//   end                           else
//    Result:=False;
//end;

function TDMM6500.GetW2RTDType(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_tp_W2RTDType,ChanNumber);
// Result:=GetShablon(GetW2RTDTypeAction,4,ChanNumber);
end;

//function TDMM6500.GetW2RTDTypeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; WiType:TDMM6500_RTDPropertyNumber): boolean;
//begin
// if FM=kt_mTemp then
//  begin
//    try
//      QuireOperation(33,59,WiType);
//      Result:=(fDevice.Value<>ErResult);
//      if Result then
//        begin
//         case WiType of
//           4:(PM as TDMM6500MeasPar_Temper).W2RTDType:=TDMM6500_RTDType(round(fDevice.Value));
//           5:(PM as TDMM6500MeasPar_Temper).W3RTDType:=TDMM6500_RTDType(round(fDevice.Value));
//           6:(PM as TDMM6500MeasPar_Temper).W4RTDType:=TDMM6500_RTDType(round(fDevice.Value));
//         end;
//        end;
//    except
//     Result:=False;
//    end;
//  end           else
//  Result:=False;
//end;

function TDMM6500.GetW3RTDType(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_tp_W3RTDType,ChanNumber);
// Result:=GetShablon(GetW2RTDTypeAction,5,ChanNumber);
end;

function TDMM6500.GetW4RTDType(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_tp_W4RTDType,ChanNumber);
// Result:=GetShablon(GetW2RTDTypeAction,6,ChanNumber);
end;

function TDMM6500.HighForStrParsing: byte;
begin
 Result:=0;
 case fRootNode of
  12..14,
   28..39:case fFirstLevelNode of
          9:Result:=ord(High(TDMM6500_OffsetCompen));
          50:case fLeafNode of
              1:Result:=ord(High(TDMM6500_TempUnits));
              2:Result:=ord(High(TDMM6500_VoltageUnits));
             end;
          52:Result:=ord(High(TDMM6500_InputImpedance));
          53:Result:=ord(High(TDMM6500_DetectorBandwidth));
          57:Result:=ord(High(TDMM6500_VoltageRatioMethod));
          59:case fLeafNode of
              4..6:Result:=ord(High(TDMM6500_RTDType));
             end;
          60:case fLeafNode of
              1:Result:=ord(High(TDMM6500_TCoupleRefJunct));
              2:Result:=ord(High(TDMM6500_TCoupleType));
             end;
          61:Result:=ord(High(TDMM6500_ThermistorType));
          62:Result:=ord(High(TDMM6500_TempTransducer));
         end;
 end;
end;

function TDMM6500.GetDelayAuto(Measure: TKeitley_Measure): boolean;
begin
 Result:=GetShablon(dm_pp_DelayAuto,Measure);
// MeasParameterCreate(Measure);
// Result:=GetDelayAutoAction(Measure,fMeasParameters[Measure]);

// Result:=GetDelayAutoAction(Measure);
// if Result then
//    if assigned(fMeasParameters[Measure]) then
//     (fMeasParameters[Measure] as TDMM6500MeasPar_BaseDelay).AutoDelay:=(fDevice.Value=1);
end;

//function TDMM6500.GetDelayAutoOn: boolean;
//begin
// Result:=GetDelayAutoAction(fMeasureFunction);
// if Result then
//   (MeasParameters as TDMM6500MeasPar_BaseDelay).AutoDelay:=(fDevice.Value=1);
//end;

function TDMM6500.GetDelayAuto(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_pp_DelayAuto,ChanNumber);
// Result:=GetShablon(GetDelayAutoAction,ChanNumber);

// if ChanQuireBegin(ChanNumber) then
//  begin
//    Result := GetDelayAutoAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction);
//    fChanOperation:=False;
//  end                          else
//    Result:=False;
// if Result then
//  (fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters as TDMM6500MeasPar_BaseDelay).AutoDelay:=(fDevice.Value=1);
end;

function TDMM6500.GetDetectorBW(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_pp_DetectorBW,ChanNumber);
// Result:=GetShablon(GetDetectorBWAction,ChanNumber);
end;

//function TDMM6500.GetDetectorBWAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
//  if FM in [kt_mCurAC,kt_mVolAC] then
//   begin
//    QuireOperation(MeasureToRootNodeNumber(FM),53);
//    Result:=(fDevice.Value<>ErResult);
//    if Result then
//      (PM as TDMM6500MeasPar_BaseAC).DetectorBW:=TDMM6500_DetectorBandwidth(round(fDevice.Value));
//   end                           else
//    Result:=False;
//end;

function TDMM6500.IsPermittedMeasureFuncForChan(MeasureFunc: TKeitley_Measure;
  ChanNumber: byte): boolean;
begin
 if ChanNumber=0 then
   begin
    Result:=True;
    Exit;
   end;

 Result:=False;
 if MeasureFunc in [kt_mCurDC,kt_mCurAC,kt_mDigCur] then Exit;
 if (ChanNumber in [6..10])and(MeasureFunc in [kt_mRes4W,kt_mVoltRat]) then Exit;
 Result:=True;

end;

function TDMM6500.ItIsRequiredStr(Str: string; i: byte): boolean;
begin
 Result:=False;
 case fRootNode of
  12..14,
   28..39:case fFirstLevelNode of
          9:Result:=(Str=AnsiLowerCase(DMM6500_OffsetCompenLabel[TDMM6500_OffsetCompen(i)]));
          50:case fLeafNode of
              1:Result:=(Pos(DMM6500_TempUnitsCommand[TDMM6500_TempUnits(i)],Str)<>0);
              2:Result:=(Pos(AnsiLowerCase(DMM6500_VoltageUnitsLabel[TDMM6500_VoltageUnits(i)]),Str)<>0);
             end;
          52:Result:=(Str=DMM6500_InputImpedanceCommand[TDMM6500_InputImpedance(i)]);
          53:Result:=(Str=IntToStr(DMM6500_DetectorBandwidthCommand[TDMM6500_DetectorBandwidth(i)]));
          57:Result:=(Pos(DMM6500_VoltageRatioMethodCommand[TDMM6500_VoltageRatioMethod(i)],Str)<>0);
          59:case fLeafNode of
              4..6:Result:=(Str=AnsiLowerCase(DMM6500_WiRTDTypeLabel[TDMM6500_RTDType(i)]));
             end;
          60:case fLeafNode of
              1:Result:=(Str=DMM6500_TCoupleRefJunctCommand[TDMM6500_TCoupleRefJunct(i)]);
              2:Result:=(Str=DMM6500_TCoupleTypeLabel[TDMM6500_TCoupleType(i)]);
             end;
          61:Result:=(Str=IntToStr(DMM6500_ThermistorTypeValues[TDMM6500_ThermistorType(i)]));
          62:Result:=(Str=DMM6500_TempTransducerCommand[TDMM6500_TempTransducer(i)]);
         end;
 end;
end;

procedure TDMM6500.MeasParameterCreate(Measure: TKeitley_Measure);
begin
if not(Assigned(fMeasParameters[Measure]))
  then fMeasParameters[Measure]:=DMM6500MeasParFactory(Measure);
end;

procedure TDMM6500.MeasParametersDestroy;
 var i:TKeitley_Measure;
begin
 for I := Low(TKeitley_Measure) to High(TKeitley_Measure) do
  if Assigned(fMeasParameters[i])then
    fMeasParameters[i].Free;
end;

procedure TDMM6500.MyTraining;
// var i:integer;
begin
//  (fDevice as TTelnetMeterDeviceSingle).SetStringToSend(':COUN?');
//  fDevice.Request();
//  fDevice.GetData;
//  (fDevice as TTelnetMeterDeviceSingle).SetStringToSend(':DIG:COUN?');
//  fDevice.GetData;

//SetMeasureFunction(kt_mTemp);
//if GetTransdType then
//  showmessage('ura!  TransdType='+DMM6500_TempTransducerLabel[(MeasParameters as TDMM6500MeasPar_Temper).TransdType]);
//SetTransdType(dm_tt2WRTD);
//if GetTransdType then
//  showmessage('ura!  TransdType='+DMM6500_TempTransducerLabel[(MeasParameters as TDMM6500MeasPar_Temper).TransdType]);
//SetMeasureFunction(kt_mTemp,2);
//SetTransdType(dm_ttTherm,2);
//if GetTransdType(2) then
//  showmessage('ura!  TransdType='+DMM6500_TempTransducerLabel[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Temper).TransdType]);


//SetMeasureFunction(kt_mTemp);
//if GetThermistorType then
//  showmessage('ura!  ThermistorType='+inttostr(DMM6500_ThermistorTypeValues[(MeasParameters as TDMM6500MeasPar_Temper).ThermistorType]));
//SetThermistorType(dm_tt2252);
//if GetThermistorType then
//  showmessage('ura!  ThermistorType='+inttostr(DMM6500_ThermistorTypeValues[(MeasParameters as TDMM6500MeasPar_Temper).ThermistorType]));
//SetMeasureFunction(kt_mTemp,2);
//SetThermistorType(dm_tt10000,2);
//if GetThermistorType(2) then
//  showmessage('ura!  ThermistorType='+inttostr(DMM6500_ThermistorTypeValues[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Temper).ThermistorType]));

//SetMeasureFunction(kt_mTemp);
//if GetTCoupleType then
//  showmessage('ura!  TCoupleType='+DMM6500_TCoupleTypeLabel[(MeasParameters as TDMM6500MeasPar_Temper).TCoupleType]);
//SetTCoupleType(dm_tctJ);
//if GetTCoupleType then
//  showmessage('ura!  TCoupleType='+DMM6500_TCoupleTypeLabel[(MeasParameters as TDMM6500MeasPar_Temper).TCoupleType]);
//SetMeasureFunction(kt_mTemp,2);
//SetTCoupleType(dm_tctN,2);
//if GetTCoupleType(2) then
//  showmessage('ura!  TCoupleType='+DMM6500_TCoupleTypeLabel[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Temper).TCoupleType]);


//SetMeasureFunction(kt_mTemp);
//if GetRefJunction then
//  showmessage('ura!  RefJunction='+DMM6500_TCoupleRefJunctLabel[(MeasParameters as TDMM6500MeasPar_Temper).RefJunction]);
//SetRefJunction(dm_trjExt);
//if GetRefJunction then
//  showmessage('ura!  RefJunction='+DMM6500_TCoupleRefJunctLabel[(MeasParameters as TDMM6500MeasPar_Temper).RefJunction]);
//SetMeasureFunction(kt_mTemp,2);
//SetRefJunction(dm_trjSim,2);
//if GetRefJunction(2) then
//  showmessage('ura!  RefJunction='+DMM6500_TCoupleRefJunctLabel[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Temper).RefJunction]);


//SetMeasureFunction(kt_mTemp);
//if GetW2RTDType then
//  showmessage('ura!  W2RTDType='+DMM6500_WiRTDTypeLabel[(MeasParameters as TDMM6500MeasPar_Temper).W2RTDType]);
//if GetW3RTDType then
//  showmessage('ura!  W3RTDType='+DMM6500_WiRTDTypeLabel[(MeasParameters as TDMM6500MeasPar_Temper).W3RTDType]);
//if GetW4RTDType then
//  showmessage('ura!  W2RTDType='+DMM6500_WiRTDTypeLabel[(MeasParameters as TDMM6500MeasPar_Temper).W4RTDType]);
//SetW2RTDType(dm_rtdPT385);
//if GetW2RTDType then
//  showmessage('ura!  W2RTDType='+DMM6500_WiRTDTypeLabel[(MeasParameters as TDMM6500MeasPar_Temper).W2RTDType]);
//SetW3RTDType(dm_rtdPT3916);
//if GetW3RTDType then
//  showmessage('ura!  W3RTDType='+DMM6500_WiRTDTypeLabel[(MeasParameters as TDMM6500MeasPar_Temper).W3RTDType]);
//SetW4RTDType(dm_rtdD100);
//if GetW4RTDType then
//  showmessage('ura!  W4RTDType='+DMM6500_WiRTDTypeLabel[(MeasParameters as TDMM6500MeasPar_Temper).W4RTDType]);
//SetMeasureFunction(kt_mTemp,2);
//SetW2RTDType(dm_rtdF100,2);
//if GetW2RTDType(2) then
//  showmessage('ura!  W2RTDType='+DMM6500_WiRTDTypeLabel[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Temper).W2RTDType]);
//SetW3RTDType(dm_rtdUser,2);
//if GetW3RTDType(2) then
//  showmessage('ura!  W2RTDType='+DMM6500_WiRTDTypeLabel[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Temper).W3RTDType]);
//SetW4RTDType(dm_rtdPT385,2);
//if GetW4RTDType(2) then
//  showmessage('ura!  W2RTDType='+DMM6500_WiRTDTypeLabel[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Temper).W4RTDType]);


//SetMeasureFunction(kt_mTemp);
//if GetRTDZero then
//  showmessage('ura!  RTDZero='+floattostr((MeasParameters as TDMM6500MeasPar_Temper).RTD_Zero));
//SetRTDZero(555);
//if GetRTDZero then
//  showmessage('ura!  RTDZero='+floattostr((MeasParameters as TDMM6500MeasPar_Temper).RTD_Zero));
//SetMeasureFunction(kt_mTemp,2);
//SetRTDZero(200,2);
//if GetRTDZero(2) then
//  showmessage('ura!  RTDZero='+floattostr((fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Temper).RTD_Zero));


//SetMeasureFunction(kt_mTemp);
//if GetRefTemperature then
//  showmessage('ura!  RefTemperature='+floattostr((MeasParameters as TDMM6500MeasPar_Temper).RefTemperature));
//SetRefTemperature(27.8);
//if GetRefTemperature then
//  showmessage('ura!  RefTemperature='+floattostr((MeasParameters as TDMM6500MeasPar_Temper).RefTemperature));
//SetMeasureFunction(kt_mTemp,2);
//SetRefTemperature(2.088,2);
//if GetRefTemperature(2) then
//  showmessage('ura!  RefTemperature='+floattostr((fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Temper).RefTemperature));

//SetMeasureFunction(kt_mTemp);
//if GetRTDDelta then
//  showmessage('ura!  RTD_Delta='+floattostr((MeasParameters as TDMM6500MeasPar_Temper).RTD_Delta));
//SetRTDDelta(0.5673);
//if GetRTDDelta then
//  showmessage('ura!  RTD_Delta='+floattostr((MeasParameters as TDMM6500MeasPar_Temper).RTD_Delta));
//SetMeasureFunction(kt_mTemp,2);
//SetRTDDelta(2.088,2);
//if GetRTDDelta(2) then
//  showmessage('ura!  RTD_Delta='+floattostr((fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Temper).RTD_Delta));

//SetMeasureFunction(kt_mTemp);
//if GetRTDBeta then
//  showmessage('ura!  RTD_Beta='+floattostr((MeasParameters as TDMM6500MeasPar_Temper).RTD_Beta));
//SetRTDBeta(0.03850);
//if GetRTDBeta then
//  showmessage('ura!  RTD_Beta='+floattostr((MeasParameters as TDMM6500MeasPar_Temper).RTD_Beta));
//SetMeasureFunction(kt_mTemp,2);
//SetRTDBeta(2.088,2);
//if GetRTDBeta(2) then
//  showmessage('ura!  RTD_Beta='+floattostr((fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Temper).RTD_Beta));


//SetMeasureFunction(kt_mTemp);
//if GetRTDAlpha then
//  showmessage('ura!  RTD_Alpha='+floattostr((MeasParameters as TDMM6500MeasPar_Temper).RTD_Alpha));
//SetRTDAlpha(0.00385088);
//if GetRTDAlpha then
//  showmessage('ura!  RTD_Alpha='+floattostr((MeasParameters as TDMM6500MeasPar_Temper).RTD_Alpha));
//SetMeasureFunction(kt_mTemp,2);
//SetRTDAlpha(2.00385088,2);
//if GetRTDAlpha(2) then
//  showmessage('ura!  RTD_Alpha='+floattostr((fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Temper).RTD_Alpha));

//SetMeasureFunction(kt_mDiod);
//if GetBiasLevel then
//  showmessage('ura!  '+DMM6500_DiodeBiasLevelLabel[(MeasParameters as TDMM6500MeasPar_Diode).BiasLevel]);
//SetBiasLevel(dm_dbl100uA);
//if GetBiasLevel then
//  showmessage('ura!  '+DMM6500_DiodeBiasLevelLabel[(MeasParameters as TDMM6500MeasPar_Diode).BiasLevel]);
//SetMeasureFunction(kt_mDiod,2);
//SetBiasLevel(dm_dbl10mA,2);
//if GetBiasLevel(2) then
//  showmessage('ura!  '+DMM6500_DiodeBiasLevelLabel[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Diode).BiasLevel]);
//SetBiasLevel(dm_dbl1mA,2);
//if GetBiasLevel(2) then
//  showmessage('ura!  '+DMM6500_DiodeBiasLevelLabel[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Diode).BiasLevel]);


//SetMeasureFunction(kt_mVoltRat);
//if GetVRMethod then
//  showmessage('ura!  '+DMM6500_VoltageRatioMethodLabel[(MeasParameters as TDMM6500MeasPar_VoltRat).VRMethod]);
//SetVRMethod(dm_vrmRes);
//if GetVRMethod then
//  showmessage('ura!  '+DMM6500_VoltageRatioMethodLabel[(MeasParameters as TDMM6500MeasPar_VoltRat).VRMethod]);
//SetMeasureFunction(kt_mVoltRat,2);
//SetVRMethod(dm_vrmRes,2);
//if GetVRMethod(2) then
//  showmessage('ura!  '+DMM6500_VoltageRatioMethodLabel[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_VoltRat).VRMethod]);
//SetVRMethod(dm_vrmPart,2);
//if GetVRMethod(2) then
//  showmessage('ura!  '+DMM6500_VoltageRatioMethodLabel[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_VoltRat).VRMethod]);


//SetMeasureFunction(kt_mPer);
//if GetThresholdRange then
//  showmessage('ura!  '+DMM6500_VoltageACRangeLabels[(MeasParameters as TDMM6500MeasPar_FreqPeriod).ThresholdRange]);
//SetThresholdRange(dm_var750V);
//if GetThresholdRange then
//  showmessage('ura!  '+DMM6500_VoltageACRangeLabels[(MeasParameters as TDMM6500MeasPar_FreqPeriod).ThresholdRange]);
//SetMeasureFunction(kt_mFreq,2);
//SetThresholdRange(dm_var1V,2);
//if GetThresholdRange(2) then
//  showmessage('ura!  '+DMM6500_VoltageACRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_FreqPeriod).ThresholdRange]);
//SetThresholdRange(dm_varAuto,2);
//if GetThresholdRange(2) then
//  showmessage('ura!  '+DMM6500_VoltageACRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_FreqPeriod).ThresholdRange]);


//SetMeasureFunction(kt_mVolDC);
//SetRange(dm_vdr100mV);
//if GetRange then
//  showmessage('ura!  '+DMM6500_VoltageDCRangeLabels[(MeasParameters as TDMM6500MeasPar_VoltDC).Range]);
//SetRange(dm_var100mV);
//if GetRange then
//  showmessage('ura!  '+DMM6500_VoltageDCRangeLabels[(MeasParameters as TDMM6500MeasPar_VoltDC).Range]);
//SetMeasureFunction(kt_mVolDC,2);
//SetRange(dm_vdr100V,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_VoltageDCRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_VoltDC).Range]);

//SetMeasureFunction(kt_mVoltRat);
//SetRange(dm_vdr100V);
//if GetRange then
//  showmessage('ura!  '+DMM6500_VoltageDCRangeLabels[(MeasParameters as TDMM6500MeasPar_VoltRat).Range]);
//SetRange(dm_vdrAuto);
//if GetRange then
//  showmessage('ura!  '+DMM6500_VoltageDCRangeLabels[(MeasParameters as TDMM6500MeasPar_VoltRat).Range]);
//SetRange(dm_car10A);
//SetMeasureFunction(kt_mVoltRat,2);
//SetRange(dm_vdr100V,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_VoltageDCRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_VoltRat).Range]);
//SetRange(dm_vdrAuto,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_VoltageDCRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_VoltRat).Range]);

//SetMeasureFunction(kt_mDigVolt);
//SetRange(dm_vdr10V);
//if GetRange then
//  showmessage('ura!  '+DMM6500_VoltageDCRangeLabels[(MeasParameters as TDMM6500MeasPar_DigVolt).Range]);
//SetRange(dm_vdrAuto);
//if GetRange then
//  showmessage('ura!  '+DMM6500_VoltageDCRangeLabels[(MeasParameters as TDMM6500MeasPar_DigVolt).Range]);
//SetRange(dm_crAuto);
//SetMeasureFunction(kt_mDigVolt,2);
//SetRange(dm_vdr100V,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_VoltageDCRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_DigVolt).Range]);
//SetRange(dm_vdrAuto,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_VoltageDCRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_DigVolt).Range]);

//SetMeasureFunction(kt_mVolAC);
//if GetRange then
//  showmessage('ura!  '+DMM6500_VoltageACRangeLabels[(MeasParameters as TDMM6500MeasPar_VoltAC).Range]);
//SetRange(dm_var750V);
//if GetRange then
//  showmessage('ura!  '+DMM6500_VoltageACRangeLabels[(MeasParameters as TDMM6500MeasPar_VoltAC).Range]);
//SetMeasureFunction(kt_mVolAC,2);
//SetRange(dm_var1V,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_VoltageACRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_VoltAC).Range]);
//SetRange(dm_varAuto,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_VoltageACRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_VoltAC).Range]);

//SetMeasureFunction(kt_mCurDC);
//SetRange(dm_cdr10uA);
//if GetRange then
//  showmessage('ura!  '+DMM6500_CurrentDCRangeLabels[(MeasParameters as TDMM6500MeasPar_CurDC).Range]);
//SetRange(dm_cdr3A);
//if GetRange then
//  showmessage('ura!  '+DMM6500_CurrentDCRangeLabels[(MeasParameters as TDMM6500MeasPar_CurDC).Range]);
//SetRange(dm_cdr1A);
//if GetRange then
//  showmessage('ura!  '+DMM6500_CurrentDCRangeLabels[(MeasParameters as TDMM6500MeasPar_CurDC).Range]);
//SetRange(dm_cdr10A);
//Terminal:=kt_otRear;
//SetRange(dm_cdr10A);
//if GetRange then
//  showmessage('ura!  '+DMM6500_CurrentDCRangeLabels[(MeasParameters as TDMM6500MeasPar_CurDC).Range]);
//SetRange(dm_cdrAuto);
//if GetRange then
//  showmessage('ura!  '+DMM6500_CurrentDCRangeLabels[(MeasParameters as TDMM6500MeasPar_CurDC).Range]);
//SetMeasureFunction(kt_mCurDC,2);
//SetRange(dm_cdr1A,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_CurrentDCRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_CurDC).Range]);
//SetRange(dm_cdrAuto,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_CurrentDCRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_CurDC).Range]);

//SetMeasureFunction(kt_mDigCur);
//SetRange(dm_cdr100uA);
//if GetRange then
//  showmessage('ura!  '+DMM6500_CurrentDCRangeLabels[(MeasParameters as TDMM6500MeasPar_DigCur).Range]);
//SetRange(dm_cdr10A);
//Terminal:=kt_otRear;
//SetRange(dm_cdr10A);
//if GetRange then
//  showmessage('ura!  '+DMM6500_CurrentDCRangeLabels[(MeasParameters as TDMM6500MeasPar_DigCur).Range]);
//SetMeasureFunction(kt_mDigCur,2);
//SetRange(dm_cdr1A,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_CurrentDCRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_DigCur).Range]);
//SetRange(dm_cdrAuto,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_CurrentDCRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_DigCur).Range]);


//SetMeasureFunction(kt_mCurAC);
//SetRange(dm_car100uA);
//if GetRange then
//  showmessage('ura!  '+DMM6500_CurrentACRangeLabels[(MeasParameters as TDMM6500MeasPar_CurAC).Range]);
//SetRange(dm_car10A);
//Terminal:=kt_otRear;
//SetRange(dm_car10A);
//if GetRange then
//  showmessage('ura!  '+DMM6500_CurrentACRangeLabels[(MeasParameters as TDMM6500MeasPar_CurAC).Range]);
//SetMeasureFunction(kt_mCurAC,2);
//SetRange(dm_car1A,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_CurrentACRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_CurAC).Range]);
//SetRange(dm_carAuto,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_CurrentACRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_CurAC).Range]);

//SetMeasureFunction(kt_mRes2W);
//SetRange(dm_r2r100);
//if GetRange then
//  showmessage('ura!  '+DMM6500_Resistance2WRangeLabels[(MeasParameters as TDMM6500MeasPar_Res2W).Range]);
//SetRange(dm_r2r1M);
//if GetRange then
//  showmessage('ura!  '+DMM6500_Resistance2WRangeLabels[(MeasParameters as TDMM6500MeasPar_Res2W).Range]);
//SetRange(dm_car10A);
//SetMeasureFunction(kt_mRes2W,2);
//SetRange(dm_r2rAuto,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_Resistance2WRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Res2W).Range]);
//SetRange(dm_r2r10k,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_Resistance2WRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Res2W).Range]);


//SetMeasureFunction(kt_mRes4W);
//SetRange(dm_r4r100);
//if GetRange then
//  showmessage('ura!  '+DMM6500_Resistance4WRangeLabels[(MeasParameters as TDMM6500MeasPar_Res4W).Range]);
//SetRange(dm_r4r1M);
//if GetRange then
//  showmessage('ura!  '+DMM6500_Resistance4WRangeLabels[(MeasParameters as TDMM6500MeasPar_Res4W).Range]);
//SetOffsetComp(dm_ocOn);
//SetRange(dm_r4r1M);
//if GetRange then
//  showmessage('ura!  '+DMM6500_Resistance4WRangeLabels[(MeasParameters as TDMM6500MeasPar_Res4W).Range]);
//SetMeasureFunction(kt_mRes4W,2);
//SetRange(dm_r4rAuto,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_Resistance4WRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Res4W).Range]);
//SetRange(dm_r4r10k,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_Resistance4WRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Res4W).Range]);


//SetMeasureFunction(kt_mCap);
//if GetRange then
//  showmessage('ura!  '+DMM6500_CapacitanceRangeRangeLabels[(MeasParameters as TDMM6500MeasPar_Capac).Range]);
//SetRange(dm_cr10nF);
//if GetRange then
//  showmessage('ura!  '+DMM6500_CapacitanceRangeRangeLabels[(MeasParameters as TDMM6500MeasPar_Capac).Range]);
//SetRange(dm_cr100uF);
//if GetRange then
//  showmessage('ura!  '+DMM6500_CapacitanceRangeRangeLabels[(MeasParameters as TDMM6500MeasPar_Capac).Range]);
//SetMeasureFunction(kt_mCap,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_CapacitanceRangeRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Capac).Range]);
//SetRange(dm_cr1uF,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_CapacitanceRangeRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Capac).Range]);
//SetRange(dm_crAuto,2);
//if GetRange(2) then
//  showmessage('ura!  '+DMM6500_CapacitanceRangeRangeLabels[(fChansMeasure[1].MeasParameters as TDMM6500MeasPar_Capac).Range]);

//SetOffsetComp(dm_ocOn);
//if GetOffsetComp then
// showmessage('ura! '+DMM6500_OffsetCompenLabel[(MeasParameters as TDMM6500MeasPar_Base4WT).OffsetComp]);
//SetMeasureFunction(kt_mRes4W);
//SetOffsetComp(dm_ocOn);
//if GetOffsetComp then
// showmessage('ura! '+DMM6500_OffsetCompenLabel[(MeasParameters as TDMM6500MeasPar_Base4WT).OffsetComp]);
//SetMeasureFunction(kt_mTemp,3);
//SetOffsetComp(dm_ocOff,3);
//if GetOffsetComp(3) then
// showmessage('ura! '+DMM6500_OffsetCompenLabel[(fChansMeasure[2].MeasParameters as TDMM6500MeasPar_Base4WT).OffsetComp]);

//SetOpenLD(True);
//if GetOpenLD then
// showmessage('ura! '+booltostr((MeasParameters as TDMM6500MeasPar_Base4WT).OpenLeadDetector,True));
//SetMeasureFunction(kt_mRes4W);
//SetOpenLD(True);
//if GetOpenLD then
// showmessage('ura! '+booltostr((MeasParameters as TDMM6500MeasPar_Base4WT).OpenLeadDetector,True));
//SetMeasureFunction(kt_mTemp,3);
//SetOpenLD(True,3);
//if GetOpenLD(3) then
// showmessage('ura! '+booltostr((fChansMeasure[2].MeasParameters as TDMM6500MeasPar_Base4WT).OpenLeadDetector,True));


//SetLineSync(True);
//if GetLineSync then
// showmessage('ura! '+booltostr((MeasParameters as TDMM6500MeasPar_Continuity).LineSync,True));
//SetMeasureFunction(kt_mCap);
//SetLineSync(True);
//if GetLineSync then
// showmessage('ura! '+booltostr((MeasParameters as TDMM6500MeasPar_Continuity).LineSync,True));
//SetMeasureFunction(kt_mRes2W,3);
//SetLineSync(True,3);
//if GetLineSync(3) then
// showmessage('ura! '+booltostr((fChansMeasure[2].MeasParameters as TDMM6500MeasPar_Continuity).LineSync,True));


//SetAzeroState(False);
//if GetAzeroState then
// showmessage('ura! '+booltostr((MeasParameters as TDMM6500MeasPar_Continuity).AzeroState,True));
//SetMeasureFunction(kt_mCap);
//SetAzeroState(False);
//if GetAzeroState then
// showmessage('ura! '+booltostr((MeasParameters as TDMM6500MeasPar_Continuity).AzeroState,True));
//SetMeasureFunction(kt_mRes2W,3);
//SetAzeroState(False,3);
//if GetAzeroState(3) then
// showmessage('ura! '+booltostr((fChansMeasure[2].MeasParameters as TDMM6500MeasPar_Continuity).AzeroState,True));


//AzeroOnce;

//SetMeasureTime(2);
//if GetMeasureTime then
// showmessage('ura! '+floattostr((MeasParameters as TDMM6500MeasPar_BaseDelayMT).MeaureTime));
//SetMeasureFunction(kt_mCont);
//SetMeasureTime(0.1);
//if GetMeasureTime then
// showmessage('ura! '+floattostr((MeasParameters as TDMM6500MeasPar_BaseDelayMT).MeaureTime));
//SetMeasureFunction(kt_mDiod,3);
//SetMeasureTime(10,3);
//if GetMeasureTime(3) then
// showmessage('ura! '+floattostr((fChansMeasure[2].MeasParameters as TDMM6500MeasPar_BaseDelayMT).MeaureTime));


//SetAperture(2);
//if GetAperture then
// showmessage(floattostr(fDevice.Value));
//SetMeasureFunction(kt_mCap);
//SetAperture(0.06);
//if GetAperture then
// showmessage(floattostr(fDevice.Value));
//SetMeasureFunction(kt_mTemp,3);
//SetAperture(0.004,3);
//if GetAperture(3) then
// showmessage(floattostr(fDevice.Value));


//SetNPLC(2);
//if GetNPLC then
// showmessage(floattostr(fDevice.Value));
//SetMeasureFunction(kt_mVolAC);
//SetNPLC(0.06);
//if GetNPLC then
// showmessage(floattostr(fDevice.Value));
//SetMeasureFunction(kt_mTemp,3);
//SetNPLC(0.004,3);
//if GetNPLC(3) then
// showmessage(floattostr(fDevice.Value));



//SetDetectorBW(dm_dbw30Hz);
//SetMeasureFunction(kt_mCurAC);
//SetDetectorBW(dm_dbw30Hz);
//if GetDetectorBW then
// showmessage('ura! '+ DMM6500_DetectorBandwidthLabel[(MeasParameters as TDMM6500MeasPar_BaseAC).DetectorBW]);
//SetMeasureFunction(kt_mVolAC,3);
//SetDetectorBW(dm_dbw300Hz,3);
//if GetDetectorBW(3) then
// showmessage('ura! '+ DMM6500_DetectorBandwidthLabel[(fChansMeasure[2].MeasParameters as TDMM6500MeasPar_BaseAC).DetectorBW]);


//SetMeasureFunction(kt_mVolDC);
//SetInputImpedance(dm_ii10M);
//if GetInputImpedance then
// showmessage('ura! '+ DMM6500_InputImpedanceLabel[(MeasParameters as TDMM6500MeasPar_VoltDC).InputImpedance]);
//SetMeasureFunction(kt_mDigVolt,3);
//SetInputImpedance(dm_ii10M,3);
//if GetInputImpedance(3) then
// showmessage('ura! '+ DMM6500_InputImpedanceLabel[(fChansMeasure[2].MeasParameters as TDMM6500MeasPar_DigVolt).InputImpedance]);


//SetMeasureFunction(kt_mVolAC);
//SetUnits(dm_vuDBM);
//if GetUnits then
// showmessage('ura! '+ DMM6500_VoltageUnitsLabel[(MeasParameters as TDMM6500MeasPar_VoltAC).Units]);
//SetMeasureFunction(kt_mTemp);
//SetUnits(dm_tuFahr);
//if GetUnits then
// showmessage('ura! '+ DMM6500_TempUnitsLabel[(MeasParameters as TDMM6500MeasPar_Temper).Units]);
//SetMeasureFunction(kt_mTemp,1);
//SetUnits(dm_tuKelv);
//if GetUnits(1) then
// showmessage('ura! '+ DMM6500_TempUnitsLabel[(fChansMeasure[0].MeasParameters as TDMM6500MeasPar_Temper).Units]);
//SetMeasureFunction(kt_mVolDC,3);
//SetUnits(dm_vuVolt);
//if GetUnits(3) then
// showmessage('ura! '+ DMM6500_VoltageUnitsLabel[(fChansMeasure[2].MeasParameters as TDMM6500MeasPar_VoltDC).Units]);



//SetMeasureFunction(kt_mVolAC);
//SetUnits(dm_vuDBM);
//SetUnits(dm_tuFahr);
//SetMeasureFunction(kt_mTemp);
//SetUnits(dm_tuFahr);
//SetMeasureFunction(kt_mDigVolt,1);
//SetUnits(dm_vuDB);
//SetMeasureFunction(kt_mTemp,2);
//SetUnits(dm_tuKelv,2);


// if GetDbmWReference() then
//  showmessage('ura! '+floattostr((MeasParameters as TDMM6500MeasPar_VoltDC).DBM));
// SetDbmWReference(-2);
// if GetDbmWReference() then
//  showmessage('ura! '+floattostr((MeasParameters as TDMM6500MeasPar_VoltDC).DBM));
// SetMeasureFunction(kt_mVolAC,2);
// if GetDbmWReference(2) then
//  showmessage('ura! '+floattostr((fChansMeasure[1].MeasParameters as TDMM6500MeasPar_VoltAC).DBM));


// SetDbmWReference(15);
// SetDbmWReference(-2);
// SetMeasureFunction(kt_mVolAC,2);
// SetDbmWReference(100,2);


// if GetDecibelReference() then
//  showmessage('ura! '+floattostr((MeasParameters as TDMM6500MeasPar_VoltDC).DB));
// SetDecibelReference(1e-9);
// if GetDecibelReference() then
//  showmessage('ura! '+floattostr((MeasParameters as TDMM6500MeasPar_VoltDC).DB));
// if GetDecibelReference(2) then
//  showmessage('ura! '+ floattostr((fChansMeasure[1].fMeasParameters as TDMM6500MeasPar_VoltDC).DB));
// SetMeasureFunction(kt_mVolAC,2);
// if GetDecibelReference(2) then
//  showmessage('ura! '+ floattostr((fChansMeasure[1].MeasParameters as TDMM6500MeasPar_VoltAC).DB))
//  else showmessage('no ura! ');

// SetDecibelReference(0.5);
// SetDecibelReference(1e-9);
// SetMeasureFunction(kt_mVolAC,2);
// SetDecibelReference(50,2);

// SetMeasureFunction(kt_mDigVolt);
// if GetSampleRate then
//  showmessage('ura! '+ inttostr((MeasParameters as TDMM6500MeasPar_BaseDig).SampleRate));
// GetSampleRate(kt_mDigCur);
// SetMeasureFunction(kt_mDigVolt,2);
// if GetSampleRate(2) then
//  showmessage('ura! '+ inttostr((fChansMeasure[1].MeasParameters as TDMM6500MeasPar_BaseDig).SampleRate));

//SetMeasureFunction(kt_mDigVolt);
//SetSampleRate(2000);
//SetSampleRate(kt_mDigCur,20000);
//SetMeasureFunction(kt_mDigVolt,2);
//SetSampleRate(200000,2);


//if GetDelayAuto()
// then showmessage('ura! '+ booltostr((MeasParameters as TDMM6500MeasPar_BaseDelay).AutoDelay,True));
//if GetDelayAuto(kt_mCurAC) then
// showmessage('ura! '+ booltostr((fMeasParameters[kt_mCurAC] as TDMM6500MeasPar_BaseDelay).AutoDelay,True));
//if GetDelayAuto(5) then
// showmessage('ura! '+ booltostr((fChansMeasure[4].MeasParameters as TDMM6500MeasPar_BaseDelay).AutoDelay,True));


//SetDelayAuto(kt_mDigCur,True);
//SetDelayAuto(kt_mCurAC,False);
//SetDelayAuto(False);
//SetDelayAuto(True,5);

//if GetDisplayDigitsNumber then
//  showmessage('ura! '+inttostr(MeasParameters.DisplayDN)+Kt2450DisplayDNLabel);
//SetDisplayDigitsNumber(kt_mCurAC,3);
//if GetDisplayDigitsNumber(kt_mCurAC) then
//  showmessage('ura! '+inttostr(fMeasParameters[kt_mCurAC].DisplayDN)+Kt2450DisplayDNLabel);
//SetDisplayDigitsNumber(4,3);
//if GetDisplayDigitsNumber(3) then
// showmessage('ura! '+inttostr(fChansMeasure[2].MeasParameters.DisplayDN)+Kt2450DisplayDNLabel);


// SetDisplayDigitsNumber(4,2);
// SetDisplayDigitsNumber(4);
// SetDisplayDigitsNumber(kt_mVolDC,3);
// SetDisplayDigitsNumber(kt_mTemp,6);
// SetDisplayDigitsNumber(kt_mDigVolt,5);

//SetCountDig(10000);
//if GetCountDig then
// showmessage('ura! '+inttostr(CountDig));
//SetCountDig(35000,1);
//if GetCountDig(1) then
// showmessage('ura! '+inttostr(fChansMeasure[0].CountDig));
//SetCountDig(30000,2);
//if GetCountDig(2) then
// showmessage('ura! '+inttostr(fChansMeasure[1].CountDig));

//SetCountDig(10000);
//SetCountDig(35000,1);
//SetCountDig(30000,2);

if GetCount(1) then showmessage('Chan 1, Count='+inttostr(fChansMeasure[0].Count));
SetCount(200,1);
if GetCount(1) then showmessage('Chan 1, Count='+inttostr(fChansMeasure[0].Count));
if GetCount(0) then showmessage('Count='+inttostr(Count));
SetCount(400000);
if GetCount() then showmessage('Count='+inttostr(Count));


//if GetMeasureFunction() then
//  showmessage ('ura  '+Keitley_MeasureLabel[FMeasureFunction])
//                         else
//  showmessage('ups :(');
//
//if GetMeasureFunction(2) then
//  showmessage (Keitley_MeasureLabel[fChansMeasure[1].MeasureFunction])
//                         else
//  showmessage('ups :(');
//
// SetMeasureFunction(kt_mDigVolt,3);
//
// if GetMeasureFunction(3) then
//  showmessage ('ura  '+ Keitley_MeasureLabel[fChansMeasure[2].MeasureFunction])
//                         else
//  showmessage('ups :(');                        

//SetMeasureFunction;
//SetMeasureFunction(kt_mVolDC,2);
//showmessage('uuu'+Keitley_MeasureLabel[MeasureFunction]);
//SetMeasureFunction(kt_mCurAC,1);
//SetMeasureFunction(kt_mTemp,11);
//SetMeasureFunction(kt_mTemp,5);
//showmessage('uuu'+Keitley_MeasureLabel[MeasureFunction]);
//SetMeasureFunction(2,4,kt_mRes4W);
//SetMeasureFunction(2,4,kt_mCurDC);
//SetMeasureFunction([9,3,5],kt_mFreq);
//SetMeasureFunction([9,3,5],kt_mVoltRat);
//------------------------------------------------------


// SetMeasureFunction(kt_mDigVolt);

// if GetDecibelReference() then
//  showmessage('ura! '+floattostr((fMeasParameters[FMeasureFunction] as TDMM6500MeasPar_VoltDC).DB));
// SetDecibelReference(1e-9);
// if GetDecibelReference() then
//  showmessage('ura! '+floattostr((fMeasParameters[FMeasureFunction] as TDMM6500MeasPar_VoltDC).DB));
// if GetDecibelReference(2) then
//  showmessage('ura! ');
// SetMeasureFunction(2,kt_mRes2W);
// if GetDecibelReference(2) then
//  showmessage('ura! ') else showmessage('no ura! ');

// if Assigned(fMeasParameters[FMeasureFunction]) then
//   showmessage('Ura!7777777777');

// ????????????????????????
// SetDecibelReference(0.5);
// SetDecibelReference(1e-9);
// SetDecibelReference(2,50);



//showmessage('kkk='+booltostr(TestShowEthernet,True));
// if  GetTrigerState then
//  showmessage('ura! '+Keitley_TriggerStateCommand[TrigerState]);

// if  GetFirstChannelInSlot then
//  showmessage('ura! '+inttostr(fFirstChannelInSlot));
// if  GetLastChannelInSlot then
//  showmessage('ura! '+inttostr(fLastChannelInSlot));
// if  GetChannelMaxVoltage then
//  showmessage('ura! '+floattostr(fChannelMaxVoltage));


//Beep;
//if TestPseudocard_Presence() then
// showmessage('ura!');
//PseudocardInstall;
//if TestPseudocard_Presence() then
// showmessage('ura!');
//PseudocardUnInstall;
//if TestPseudocard_Presence() then
// showmessage('ura!');


// if GetMeasureFunction then
//   showmessage('ura!!!'+Keitley_MeasureLabel[MeasureFunction]);


//for I := ord(Low(TKeitley_Measure)) to ord(High(TKeitley_Measure)) do
// SetMeasureFunction(TKeitley_Measure(i));

//BufferDataArrayExtended(2,10,kt_rd_M);
//showmessage(DataVector.XYtoString+#10+'Time'+#10+DataTimeVector.XYtoString);
//
//BufferDataArrayExtended(1,10,kt_rd_MST);
//showmessage(DataVector.XYtoString+#10+'Time'+#10+DataTimeVector.XYtoString);
//
//BufferDataArrayExtended(1,10,kt_rd_MT);
//showmessage(DataVector.XYtoString+#10+'Time'+#10+DataTimeVector.XYtoString);
//
//
//BufferDataArrayExtended(1,10,kt_rd_MS);
//showmessage(DataVector.XYtoString+#10+'Time'+#10+DataTimeVector.XYtoString);


//BufferLastDataExtended(kt_rd_MST,KeitleyDefBuffer);
//showmessage(floattostr(fDevice.Value)
//              +'  '+floattostr(fMeasureChanNumber)
//              +'  '+floattostr(TimeValue));

//BufferLastDataExtended(kt_rd_MT);
//showmessage(floattostr(fDevice.Value)+'  '+floattostr(fTimeValue));

//BufferLastDataExtended();
//showmessage(floattostr(fDevice.Value)+'  '+floattostr(fMeasureChanNumber));

// BufferLastDataSimple();
// showmessage(floattostr(fDevice.Value));

//if BufferGetFillMode() then
//  showmessage('ura! '+Keitley_BufferFillModeCommand[Buffer.FillMode]);
//
//if   BufferGetFillMode(KeitleyDefBuffer) then
//  showmessage('ura! '+Keitley_BufferFillModeCommand[Buffer.FillMode]);

//
//BufferSetFillMode(kt_fm_cont);
//BufferSetFillMode('TestBuffer',kt_fm_once);

//if BufferGetStartEndIndex()
//  then showmessage(inttostr(Buffer.StartIndex)+'  '+inttostr(Buffer.EndIndex))
//  else showmessage('ups :(');

//showmessage(inttostr(BufferGetReadingsNumber()));
//BufferCreate();
//showmessage(inttostr(BufferGetReadingsNumber(MyBuffer)));

//showmessage(inttostr(BufferGetSize));
//showmessage(inttostr(Buffer.CountMax));
//showmessage(inttostr(BufferGetSize(KeitleyDefBuffer)));

//BufferReSize(100);
//BufferReSize('TestBuffer',5);
//BufferClear(KeitleyDefBuffer);
//BufferDelete();
//BufferDelete('Test  Buffer ');
// BufferCreate();
// BufferCreate('Test  Buffer ',500,kt_bs_full);
// BufferCreate('Test  Buffer ',500,kt_bs_comp);
// BufferCreate(kt_bs_full);
// BufferCreate(kt_bs_comp);
//for I := ord(Low(TKeitley_Measure)) to ord(High(TKeitley_Measure)) do
// SetMeasureFunction(TKeitley_Measure(i));
// if GetMeasureFunction then
//   showmessage('ura!!!'+DMM65000_MeasureLabel[MeasureFunction]);
// TextToUserScreen('Hi, Oleg!','I am glad to see you');
// ClearUserScreen();
//showmessage(booltostr(GetTerminal(),True));
//Beep;
//SetDisplayBrightness(kt_ds_on75);
// GetDisplayBrightness;
// Test();
end;

procedure TDMM6500.OffOnToValue(Str: string);
begin
 if Str= SuffixKt_2450[0] then fDevice.Value:=1;
 if Str= SuffixKt_2450[1] then fDevice.Value:=0;
end;

//procedure TDMM6500.SetupShablon(SetProcedureBool: TSetProcedureBool;toOn:boolean;
//  ChanNumber: byte);
//begin
// if ChanNumber=0
// then  SetProcedureBool(fMeasureFunction,MeasParameters,toOn)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetProcedureBool(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     toOn);
//end;

//function TDMM6500.PermitDiode(FM: TKeitley_Measure): boolean;
//begin
// Result:=(FM=kt_mDiod);
//end;

function TDMM6500.PermitForParameter(FM: TKeitley_Measure; MParam: TDMM6500_MeasParameters;
             P:Pointer;PM: TDMM6500MeasPar_Base): boolean;
begin
  case MParam of
   dm_dp_BiasLevel: Result:=(FM=kt_mDiod);
   dm_vrp_VRMethod: Result:=(FM=kt_mVoltRat);
   dm_pp_OffsetCompen,
   dm_pp_OpenLeadDetector:Result:=(FM in [kt_mRes4W,kt_mTemp]);
   dm_pp_LineSync:Result:=(FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
                        kt_mRes4W,kt_mTemp,kt_mCont,kt_mVoltRat]);
   dm_pp_AzeroState:Result:=(FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
                         kt_mRes4W,kt_mDiod,kt_mTemp,kt_mVoltRat]);
   dm_pp_DetectorBW:Result:=(FM in [kt_mCurAC,kt_mVolAC]);
   dm_pp_InputImpedance:Result:=(FM in [kt_mVolDC,kt_mDigVolt]);
   dm_pp_Units:Result:=(FM in [kt_mTemp,kt_mVolDC,kt_mVolAC,kt_mDigVolt]);
   dm_pp_DecibelReference,
   dm_pp_DbmWReference:Result:=(FM in [kt_mVolDC,kt_mVolAC,kt_mDigVolt]);
   dm_pp_Aperture:Result:=(FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
                                  kt_mRes4W,kt_mDiod,kt_mTemp,
                                  kt_mFreq,kt_mPer,
                                  kt_mVoltRat,kt_mDigCur,kt_mDigVolt]);
   dm_pp_ApertureAuto:Result:=(FM>kt_mVoltRat);
   dm_pp_MeasureTime:Result:=(FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
                                  kt_mRes4W,kt_mDiod,kt_mTemp,
                                  kt_mFreq,kt_mPer,
                                  kt_mVoltRat]);
   dm_pp_NPLC:Result:=(FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
                          kt_mRes4W,kt_mDiod,kt_mTemp,kt_mVoltRat]);
   dm_pp_SampleRate:Result:=(FM>kt_mVoltRat);
   dm_pp_DelayAuto:Result:=(FM<kt_mDigCur);
   dm_pp_ThresholdRange:Result:=(FM in [kt_mFreq,kt_mPer]);
   dm_pp_Range:Result:=(FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
                        kt_mCurAC,kt_mVolAC,kt_mRes4W,kt_mCap,
                        kt_mVoltRat,kt_mDigCur,kt_mDigVolt]);
   dm_pp_RangeVoltDC:Result:=(FM in [kt_mVolDC,kt_mVoltRat,kt_mDigVolt])
                            and(not((FM=kt_mDigVolt)and(TDMM6500_VoltageDCRange(P)=dm_vdrAuto)));
   dm_pp_RangeVoltAC:Result:=(FM=kt_mVolAC);
   dm_pp_RangeCurrentDC:Result:=(FM in [kt_mCurDC,kt_mDigCur])
                     and(not((FM=kt_mDigCur)and(TDMM6500_CurrentDCRange(P)=dm_cdrAuto)))
                     and(not((Terminal=kt_otFront)and(TDMM6500_CurrentDCRange(P)=dm_cdr10A)));
   dm_pp_RangeCurrentAC:Result:=(FM=kt_mCurAC)
                        and(not((Terminal=kt_otFront)and(TDMM6500_CurrentACRange(P)=dm_car10A)));
   dm_pp_RangeResistance2W:Result:=(FM=kt_mRes2W);
   dm_pp_RangeResistance4W:Result:=(FM=kt_mRes4W)
                        and(not(((PM as TDMM6500MeasPar_Res4W).OffsetComp=dm_ocOn)
                                  and(TDMM6500_Resistance4WRange(P)>dm_r4r10k)));
   dm_pp_RangeCapacitance:Result:=(FM=kt_mCap);
   dm_tp_UnitsTemp:Result:=(FM=kt_mTemp);
   dm_pp_UnitsVolt:Result:=(FM in [kt_mVolDC,kt_mVolAC,kt_mDigVolt]);
   else  Result:=(FM=kt_mTemp);
 end;
end;

function TDMM6500.PermitForRangeAuto(P: Pointer;
  MParam: TDMM6500_MeasParameters): boolean;
begin
 case MParam of
   dm_pp_RangeVoltDC: Result:=(TDMM6500_VoltageDCRange(P)=dm_vdrAuto);
   dm_pp_ThresholdRange,
   dm_pp_RangeVoltAC: Result:=(TDMM6500_VoltageACRange(P)=dm_varAuto);
   dm_pp_RangeCurrentDC: Result:=(TDMM6500_CurrentDCRange(P)=dm_cdrAuto);
   dm_pp_RangeCurrentAC: Result:=(TDMM6500_CurrentACRange(P)=dm_carAuto);
   dm_pp_RangeResistance2W: Result:=(TDMM6500_Resistance2WRange(P)=dm_r2rAuto);
   dm_pp_RangeResistance4W: Result:=(TDMM6500_Resistance4WRange(P)=dm_r4rAuto);
   dm_pp_RangeCapacitance: Result:=(TDMM6500_CapacitanceRange(P)=dm_crAuto);
   else Result:=False;
 end;
end;

procedure TDMM6500.PrepareString;
begin
 inherited PrepareString;
 if fChanOperation then
   begin
    fDevice.JoinToStringToSend(fChanOperationString);
    fChanOperation:=(Pos('?',(fDevice  as TKeitleyDevice).StringToSendActual)<>0);
//    showmessage('fChanOperation='+booltostr(fChanOperation,True));
   end;
end;

procedure TDMM6500.PrepareStringByRootNode;
begin
 inherited;
 case fRootNode of
  7:case fLeafNode of
     1,2:begin
          JoinToStringToSend(CardLeafNodeDMM6500[0]);
          JoinToStringToSend(CardLeafNodeDMM6500[fLeafNode]);
         end;
     3:JoinToStringToSend(CardLeafNodeDMM6500[fLeafNode]);
     50..52:JoinToStringToSend(':'+DeleteSubstring(RootNodeKeitley[0],'*'));
    end;
  12..14,28..39:
     case fFirstLevelNode of
       15:if fLeafNode=0 then JoinToStringToSend(':'+SuffixKt_2450[8]);
       56: begin
           JoinToStringToSend(FirstNodeKt_2450[15]);
           if fLeafNode=0 then JoinToStringToSend(':'+SuffixKt_2450[8]);
           end;
       59: JoinToStringToSend(RTDLeafNode[fLeafNode]);
       60: JoinToStringToSend(TermoCoupleLeafNode[fLeafNode]);
     end;

  19:begin
       case fFirstLevelNode of
        33:JoinToStringToSend(Buffer.DataDemandDM6500Array(TKeitley_ReturnedData(fLeafNode)));
       end;
      end; // fRootNode=19
  22:case fFirstLevelNode of
       2..5:JoinToStringToSend(Buffer.DataDemandDM6500(TKeitley_ReturnedData(fFirstLevelNode-2)))
     end; // fRootNode=22
 end;
end;

procedure TDMM6500.ProcessingString(Str: string);
begin
 inherited ProcessingString(Str);
 if fChanOperation then ProcessingStringChanOperation;
end;

procedure TDMM6500.ProcessingStringByRootNode(Str: string);
begin
 inherited;
 case fRootNode of
  0:if pos(DMM6500_Test,Str)<>0 then fDevice.Value:=314;
  7:case fLeafNode of
     1,2:fDevice.Value:=StrToInt(Str);
     3:fDevice.Value:=SCPI_StringToValue(Str);
     50:if pos(SCAN2000_Test,Str)<>0 then fDevice.Value:=314;
//     51:if pos(TCSCAN2001_Test,Str)<>0 then fDevice.Value:=314;
     52:if pos(Pseudocard_Test,Str)<>0 then fDevice.Value:=314;
    end;
  12..14,
   28..39:case fFirstLevelNode of
          9:StringToOrd(AnsiLowerCase(Str));//StringToOffsetComp(Str);
          22,20,54,55,16:OffOnToValue(AnsiLowerCase(Str));
          50:case fLeafNode of
              1:StringToOrd(AnsiLowerCase(Str));//StrToTempUnit(AnsiLowerCase(Str));
              2:StringToOrd(AnsiLowerCase(Str));//StrToVoltUnit(AnsiLowerCase(Str));
             end;
          52:StringToOrd(AnsiLowerCase(Str));//StringToInputImpedance(AnsiLowerCase(Str));
          53:StringToOrd(Str);//StringToDetectorBW(Str);
          15,56:case fLeafNode of
              0:OffOnToValue(AnsiLowerCase(Str));
              1:fDevice.Value:=SCPI_StringToValue(Str);
             end;
          57:StringToOrd(AnsiLowerCase(Str));//StringToVoltageRatioMethod(AnsiLowerCase(Str));
          58:fDevice.Value:=SCPI_StringToValue(Str);
          59:case fLeafNode of
              0,1,2:fDevice.Value:=SCPI_StringToValue(Str);
              3:fDevice.Value:=StrToInt(Str);
              4..6:StringToOrd(AnsiLowerCase(Str));//StringToRTDType(AnsiLowerCase(Str));
             end;
          60:case fLeafNode of
              0:fDevice.Value:=SCPI_StringToValue(Str);
              1:StringToOrd(AnsiLowerCase(Str));//StringToCoupleRefJunct(AnsiLowerCase(Str));
              2:StringToOrd(Str);//StringToTCoupleType(Str);
             end;
          61:StringToOrd(Str);//StringToThermistorType(Str);
          62:StringToOrd(AnsiLowerCase(Str));//StringToTempTransducer(AnsiLowerCase(Str));
         end;
 end;

end;


procedure TDMM6500.ProcessingStringChanOperation;
begin
// fChanOperation:=False;
 if fDevice.Value=ErResult then Exit;

 case fRootNode of
  15:if fDevice.Value<=ord(kt_mVoltRat)
        then fChansMeasure[fMeasureChanNumber].MeasureFunction:=fMeasureFunction;
//       if fDevice.Value>ord(kt_mVoltRat)
//        then fChanOperation:=True
//        else fChansMeasureFunction[fMeasureChanNumber]:=fMeasureFunction;
  23:case fFirstLevelNode of
        15:fChansMeasure[fMeasureChanNumber].MeasureFunction:=fMeasureFunction;
      end;
 end;

end;

procedure TDMM6500.PseudocardInstall;
begin
// :SYST:PCAR 2000
 fAdditionalString:='2000';
 SetupOperation(7,46);
end;

procedure TDMM6500.PseudocardUnInstall;
begin
// :SYST:PCAR 0
 fAdditionalString:='0';
 SetupOperation(7,46);
end;

//function TDMM6500.RangeToString(Range: TDMM6500_Resistance2WRange): string;
//begin
// case Range of
//  dm_r2rAuto:Result:='';
//  else Result:=floattostr(10*Power(10,ord(Range)-1));
// end;
//end;

//function TDMM6500.RangeToString(Range: TDMM6500_CurrentDCRange): string;
//begin
// case Range of
//  dm_cdrAuto:Result:='';
//  dm_cdr3A:Result:='3';
//  dm_cdr10A:Result:='10';
//  else Result:=floattostr(1e-5*Power(10,ord(Range)-1));
// end;
//end;

//function TDMM6500.RangeToString(Range: TDMM6500_VoltageACRange): string;
//begin
// case Range of
//  dm_varAuto:Result:='';
//  dm_var750V:Result:='750';
//  else Result:=floattostr(0.1*Power(10,ord(Range)-1));
// end;
//end;

//procedure TDMM6500.SetMeasureFunction(MeasureFunc: TKeitley_Measure);
//begin
// inherited SetMeasureFunction(MeasureFunc);
// fTerminalMeasureFunction[Terminal]:=MeasureFunction;
//end;


//procedure TDMM6500.SetMeasureFunctionChan(ChanNumberLow, ChanNumberHigh: byte;
procedure TDMM6500.SetMeasureFunction(ChanNumberLow, ChanNumberHigh: byte;
  MeasureFunc: TKeitley_Measure);
 var i:byte;
     tempbool:boolean;
begin
 tempbool:=True;
 for I := ChanNumberLow to ChanNumberHigh do
    if not(IsPermittedMeasureFuncForChan(MeasureFunc,i)) then
     begin
      tempbool:=False;
      Break;
     end;
 if ChanelNumberIsCorrect(ChanNumberLow, ChanNumberHigh) and tempbool then
   begin
     fChanOperationString:=PartDelimiter+ChanelToString(ChanNumberLow, ChanNumberHigh);
     fChanOperation:=True;
     inherited SetMeasureFunction(MeasureFunc);
     for I := ChanNumberLow-1 to ChanNumberHigh-1 do
       fChansMeasure[i].MeasureFunction:=MeasureFunc;
   end;
end;

procedure TDMM6500.SetMeasureFunction(MeasureFunc: TKeitley_Measure; ChanNumber: Byte);
begin
 if ChanNumber=0
  then SetMeasureFunction(MeasureFunc)
  else
    begin
     if ChanelNumberIsCorrect(ChanNumber) and IsPermittedMeasureFuncForChan(MeasureFunc,ChanNumber) then
       begin
         fChanOperationString:=PartDelimiter+ChanelToString(ChanNumber);
         fChanOperation:=True;
         inherited SetMeasureFunction(MeasureFunc);
         fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction:=MeasureFunc;
       end;
    end;
end;

procedure TDMM6500.SetActionProcedureByMParam(FM: TKeitley_Measure;
  PM: TDMM6500MeasPar_Base; P: Pointer; MParam: TDMM6500_MeasParameters);
begin
 case MParam of
   dm_tp_TransdType: begin
       fAdditionalString:=DMM6500_TempTransducerCommand[TDMM6500_TempTransducer(P)];
       (PM as TDMM6500MeasPar_Temper).TransdType:=TDMM6500_TempTransducer(P);
                     end;
   dm_tp_RefJunction: begin
   fAdditionalString:=DMM6500_TCoupleRefJunctCommand[TDMM6500_TCoupleRefJunct(P)];
   (PM as TDMM6500MeasPar_Temper).RefJunction:=TDMM6500_TCoupleRefJunct(P);
                      end;
   dm_tp_RTDAlpha: begin
     (PM as TDMM6500MeasPar_Temper).RTD_Alpha:=PDouble(P)^;
     fAdditionalString:=FloatToStrF((PM as TDMM6500MeasPar_Temper).RTD_Alpha,ffExponent,9,0);
                   end;
   dm_tp_RTDBeta: begin
     (PM as TDMM6500MeasPar_Temper).RTD_Beta:=PDouble(P)^;
     fAdditionalString:=FloatToStrF((PM as TDMM6500MeasPar_Temper).RTD_Beta,ffExponent,9,0);
                  end;
   dm_tp_RTDDelta: begin
     (PM as TDMM6500MeasPar_Temper).RTD_Delta:=PDouble(P)^;
     fAdditionalString:=FloatToStrF((PM as TDMM6500MeasPar_Temper).RTD_Delta,ffExponent,5,0);;
                   end;
   dm_tp_RTDZero: begin
     (PM as TDMM6500MeasPar_Temper).RTD_Zero:=PInteger(P)^;
     fAdditionalString:=IntToStr((PM as TDMM6500MeasPar_Temper).RTD_Zero);
                  end;
   dm_tp_W2RTDType: begin
      fAdditionalString:=DMM6500_WiRTDTypeLabel[TDMM6500_RTDType(P)];
     (PM as TDMM6500MeasPar_Temper).W2RTDType:=TDMM6500_RTDType(P);
                    end;
   dm_tp_W3RTDType: begin
      fAdditionalString:=DMM6500_WiRTDTypeLabel[TDMM6500_RTDType(P)];
     (PM as TDMM6500MeasPar_Temper).W3RTDType:=TDMM6500_RTDType(P);
                    end;
   dm_tp_W4RTDType: begin
      fAdditionalString:=DMM6500_WiRTDTypeLabel[TDMM6500_RTDType(P)];
     (PM as TDMM6500MeasPar_Temper).W4RTDType:=TDMM6500_RTDType(P);
                    end;
   dm_tp_ThermistorType: begin
        fAdditionalString:=IntToStr(DMM6500_ThermistorTypeValues[TDMM6500_ThermistorType(P)]);
       (PM as TDMM6500MeasPar_Temper).ThermistorType:=TDMM6500_ThermistorType(P);
                         end;
   dm_tp_TCoupleType: begin
      fAdditionalString:=DMM6500_TCoupleTypeLabel[TDMM6500_TCoupleType(P)];
      (PM as TDMM6500MeasPar_Temper).TCoupleType:=TDMM6500_TCoupleType(P);
                      end;
   dm_tp_SimRefTemp: begin
     (PM as TDMM6500MeasPar_Temper).RefTemperature:=PDouble(P)^;
     fAdditionalString:=FloatToStrF((PM as TDMM6500MeasPar_Temper).RefTemperature,ffExponent,3,0);
                     end;
   dm_dp_BiasLevel: begin
     fAdditionalString:=BiasLevelToString(TDMM6500_DiodeBiasLevel(P));
     (PM as TDMM6500MeasPar_Diode).BiasLevel:=TDMM6500_DiodeBiasLevel(P);
                    end;
   dm_vrp_VRMethod: begin
     fAdditionalString:=DMM6500_VoltageRatioMethodCommand[TDMM6500_VoltageRatioMethod(P)];
     (PM as TDMM6500MeasPar_VoltRat).VRMethod:=TDMM6500_VoltageRatioMethod(P);
                    end;
   dm_pp_OffsetCompen: begin
     fAdditionalString:=DMM6500_OffsetCompenLabel[TDMM6500_OffsetCompen(P)];
     (PM as TDMM6500MeasPar_Base4WT).OffsetComp:=TDMM6500_OffsetCompen(P);
                       end;
   dm_pp_OpenLeadDetector: begin
    OnOffFromBool(PBoolean(P)^);
    (PM as TDMM6500MeasPar_Base4WT).OpenLeadDetector:=PBoolean(P)^;
                           end;
   dm_pp_LineSync: begin
    OnOffFromBool(PBoolean(P)^);
    (PM as TDMM6500MeasPar_Continuity).LineSync:=PBoolean(P)^;
                   end;
   dm_pp_AzeroState: begin
     OnOffFromBool(PBoolean(P)^);
     (PM as TDMM6500MeasPar_Continuity).AzeroState:=PBoolean(P)^;
                     end;
   dm_pp_DetectorBW: begin
     fAdditionalString:=inttostr(DMM6500_DetectorBandwidthCommand[TDMM6500_DetectorBandwidth(P)]);
     (PM as TDMM6500MeasPar_BaseAC).DetectorBW:=TDMM6500_DetectorBandwidth(P);
                     end;
   dm_pp_InputImpedance: begin
     fAdditionalString:=DMM6500_InputImpedanceCommand[TDMM6500_InputImpedance(P)];
     GetMeasPar_BaseVoltDC(FM,PM).InputImpedance:=TDMM6500_InputImpedance(P);
                         end;
   dm_pp_DbmWReference: begin
     GetMeasPar_BaseVolt(FM,PM).DBM:=PInteger(P)^;
     fAdditionalString:=Inttostr(GetMeasPar_BaseVolt(FM,PM).DBM);
                        end;
   dm_pp_DecibelReference: begin
     GetMeasPar_BaseVolt(FM,PM).DB:=PDouble(P)^;
     fAdditionalString:=FloatToStrF(GetMeasPar_BaseVolt(FM,PM).DB,ffExponent,4,0);
                           end;
   dm_pp_Aperture:fAdditionalString:=ApertValueToString(FM,PDouble(P)^);
   dm_pp_ApertureAuto:fAdditionalString:=SuffixKt_2450[8];
   dm_pp_MeasureTime: begin
       (PM as TDMM6500MeasPar_BaseDelayMT).MeaureTime:=PDouble(P)^;
       fAdditionalString:=ApertValueToString(FM,(PM as TDMM6500MeasPar_BaseDelayMT).MeaureTime*1e-3);
                      end;
   dm_pp_NPLC: fAdditionalString:=NumberToStrLimited(PDouble(P)^,DMM6500_NPLCLimits);
   dm_pp_SampleRate: begin
     fAdditionalString:=IntToStr(TDMM6500_DigSampleRate(P));
    (PM as TDMM6500MeasPar_BaseDig).SampleRate:=TDMM6500_DigSampleRate(P);
                     end;
   dm_pp_DelayAuto: begin
     OnOffFromBool(PBoolean(P)^);
     (PM as TDMM6500MeasPar_BaseDelay).AutoDelay:=PBoolean(P)^;
                    end;
   dm_pp_ThresholdRange:
    (PM as TDMM6500MeasPar_FreqPeriod).ThresholdRange:=TDMM6500_VoltageACRange(P);
   dm_pp_RangeVoltDC:
     case FM of
       kt_mVolDC: (PM as TDMM6500MeasPar_VoltDC).Range:=TDMM6500_VoltageDCRange(P);
       kt_mVoltRat: (PM as TDMM6500MeasPar_VoltRat).Range:=TDMM6500_VoltageDCRange(P);
       kt_mDigVolt: (PM as TDMM6500MeasPar_DigVolt).Range:=TDMM6500_VoltageDCRange(P);
     end;
   dm_pp_RangeVoltAC:
    (PM as TDMM6500MeasPar_VoltAC).Range:=TDMM6500_VoltageACRange(P);
   dm_pp_RangeCurrentDC:
     case FM of
       kt_mCurDC: (PM as TDMM6500MeasPar_CurDC).Range:=TDMM6500_CurrentDCRange(P);
       kt_mDigCur: (PM as TDMM6500MeasPar_DigCur).Range:=TDMM6500_CurrentDCRange(P);
     end;
   dm_pp_RangeCurrentAC:(PM as TDMM6500MeasPar_CurAC).Range:=TDMM6500_CurrentACRange(P);
   dm_pp_RangeResistance2W:(PM as TDMM6500MeasPar_Res2W).Range:=TDMM6500_Resistance2WRange(P);
   dm_pp_RangeResistance4W:(PM as TDMM6500MeasPar_Res4W).Range:=TDMM6500_Resistance4WRange(P);
   dm_pp_RangeCapacitance:(PM as TDMM6500MeasPar_Capac).Range:=TDMM6500_CapacitanceRange(P);
   dm_tp_UnitsTemp:begin
     fAdditionalString:=DMM6500_TempUnitsCommand[TDMM6500_TempUnits(P)];
     (PM as TDMM6500MeasPar_Temper).Units:=TDMM6500_TempUnits(P);
                   end;
   dm_pp_UnitsVolt:begin
     fAdditionalString:=DMM6500_VoltageUnitsLabel[TDMM6500_VoltageUnits(P)];
     GetMeasPar_BaseVolt(FM,PM).Units:=TDMM6500_VoltageUnits(P);
                   end;
 end;
end;

procedure TDMM6500.SetActionRangeShablon(FM: TKeitley_Measure;
  PM: TDMM6500MeasPar_Base; P: Pointer; MParam: TDMM6500_MeasParameters);
begin
 if PermitForParameter(FM,MParam,P,PM) then
  begin
   if PermitForRangeAuto(P,MParam) then
     begin
       OnOffFromBool(True);
       SetupOperation(MeasureToRootNodeNumber(FM),ParametrToFLNode(MParam),1);
     end                           else
     begin
       fAdditionalString:=RangeToString(P,MParam);
       SetupOperation(MeasureToRootNodeNumber(FM),ParametrToFLNode(MParam),0);
     end;
   SetActionProcedureByMParam(FM,PM,P,MParam);
  end

// if not(FM in [kt_mVolDC,kt_mVoltRat,kt_mDigVolt]) then Exit;
// if (FM=kt_mDigVolt)and(Range=dm_vdrAuto) then Exit;
// if Range=dm_vdrAuto then
//       begin
//        OnOffFromBool(True);
//        SetupOperation(MeasureToRootNodeNumber(FM),16);
//       end         else
//       begin
//         fAdditionalString:=RangeToString(Range);
//         SetupOperation(MeasureToRootNodeNumber(FM),15);
//       end;
// case FM of
//   kt_mVolDC: (PM as TDMM6500MeasPar_VoltDC).Range:=Range;
//   kt_mVoltRat: (PM as TDMM6500MeasPar_VoltRat).Range:=Range;
//   kt_mDigVolt: (PM as TDMM6500MeasPar_DigVolt).Range:=Range;
// end;

end;

procedure TDMM6500.SetActionShablon(FM: TKeitley_Measure;
  PM: TDMM6500MeasPar_Base; P: Pointer; MParam: TDMM6500_MeasParameters);
begin
 if PermitForParameter(FM,MParam) then
  begin
   SetActionProcedureByMParam(FM,PM,P,MParam);
   SetupOperation(MeasureToRootNodeNumber(FM),ParametrToFLNode(MParam),ParameterToLeafNode(MParam,FM));
  end
end;

procedure TDMM6500.SetAperture(ApertValue: double; ChanNumber: byte);
begin
//:<function>:APER <n>
 SetShablon(dm_pp_Aperture,@ApertValue,ChanNumber);
// SetupShablon(SetApertureAction,ApertValue,ChanNumber);
//  if ChanNumber=0
//   then  SetApertureAction(fMeasureFunction,ApertValue)
//   else
//     if ChanSetupBegin(ChanNumber) then
//     begin
//       SetApertureAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     ApertValue);
//     end;
end;

//procedure TDMM6500.SetApertureAction(FM: TKeitley_Measure; ApertValue: double);
//begin
////:<function>:APER <n>
// if FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
//                   kt_mRes4W,
//                   kt_mDiod,kt_mTemp,
//                   kt_mFreq,kt_mPer,
//                   kt_mVoltRat,kt_mDigCur,kt_mDigVolt] then
//  begin
//   fAdditionalString:=ApertValueToString(FM,ApertValue);
//   SetupOperation(MeasureToRootNodeNumber(FM),51);
//  end
//end;

procedure TDMM6500.SetApertureAuto(ChanNumber: byte);
begin
//:<function>:APER AUTO
 SetShablon(dm_pp_ApertureAuto,nil,ChanNumber);
//  if ChanNumber=0
//   then  SetApertureAutoAction(fMeasureFunction)
//   else
//     if ChanSetupBegin(ChanNumber) then
//     begin
//       SetApertureAutoAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction);
//     end;
end;

//procedure TDMM6500.SetApertureAutoAction(Measure: TKeitley_Measure);
//begin
////:<function>:APER AUTO
// if Measure>kt_mVoltRat then
//  begin
//   fAdditionalString:=SuffixKt_2450[8];
//   SetupOperation(MeasureToRootNodeNumber(Measure),51);
//  end
//end;

procedure TDMM6500.SetAzeroState(toOn: boolean; ChanNumber: Byte);
begin
 SetShablon(dm_pp_AzeroState,@toOn,ChanNumber);
// if ChanNumber=0
// then  SetAzeroStateAction(fMeasureFunction,MeasParameters,toOn)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetAzeroStateAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     toOn);
end;

procedure TDMM6500.SetAzeroState(toOn: boolean);
begin
  SetAzeroState(toOn,0);
end;

//procedure TDMM6500.SetAzeroStateAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; toOn: boolean);
//begin
// inherited  SetAzeroState(FM,toOn);
// if FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
//      kt_mRes4W,kt_mDiod,kt_mTemp,kt_mVoltRat] then
//    (PM as TDMM6500MeasPar_Continuity).AzeroState:=toOn;
//end;

procedure TDMM6500.SetBiasLevel(BL: TDMM6500_DiodeBiasLevel; ChanNumber: Byte);
begin
//:DIOD:BIAS:LEV <n>
 SetShablon(dm_dp_BiasLevel,Pointer(BL),ChanNumber);
// if ChanNumber=0
// then  SetBiasLevelAction(fMeasureFunction,MeasParameters,BL)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetBiasLevelAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     BL);
end;

//procedure TDMM6500.SetBiasLevelAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; BL: TDMM6500_DiodeBiasLevel);
//begin
////:DIOD:BIAS:LEV <n>
// if FM<>kt_mDiod then Exit;
// fAdditionalString:=BiasLevelToString(BL);
// SetupOperation(MeasureToRootNodeNumber(FM),58);
// (PM as TDMM6500MeasPar_Diode).BiasLevel:=BL;
//end;

procedure TDMM6500.SetCount(Cnt: Integer; ChanNumber: Byte);
 var tempCount:integer;
begin

 if ChanSetupBegin(ChanNumber) then
  begin
    tempCount:=Count;
    inherited SetCount(Cnt);
    fChansMeasure[ChanNumber-fFirstChannelInSlot].Count:=Self.Count;
    Count:=tempCount;
  end;


// if ChanelNumberIsCorrect(ChanNumber) then
//   begin
//     fChanOperationString:=PartDelimiter+ChanelToString(ChanNumber);
//     fChanOperation:=True;
//     inherited SetCount(Cnt);
//     fChansMeasure[ChanNumber-fFirstChannelInSlot].Count:=Self.Count;
//   end;
end;

//procedure TDMM6500.SetCountDig(Cnt: integer);
//begin
//// :DIG:COUN <n>
// CountDig:=Cnt;
// fAdditionalString:=IntToStr(CountDig);
// SetupOperation(23,20);
//end;

procedure TDMM6500.SetCountDig(Cnt: Integer; ChanNumber: Byte);
begin
  // :DIG:COUN <n>
   if ChanNumber=0
   then  SetCountDigAction(CountDig,Cnt)
   else
     if ChanSetupBegin(ChanNumber)
       then  SetCountDigAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].CountDig,Cnt);

// if ChanSetupBegin(ChanNumber) then
//  begin
//    fChansMeasure[ChanNumber-fFirstChannelInSlot].CountDig:=Cnt;
//    fAdditionalString:=IntToStr(fChansMeasure[ChanNumber-fFirstChannelInSlot].CountDig);
//    SetupOperation(23,20);
//  end;
end;

procedure TDMM6500.SetCountDigAction(DeviceCountDig, NewCountDig:integer);
begin
  DeviceCountDig:=NewCountDig;
  fAdditionalString:=IntToStr(DeviceCountDig);
  SetupOperation(23,20);
end;

procedure TDMM6500.SetCountDigNumber(Value: integer);
begin
 fCountDig:=TSCPInew.NumberMap(Value,DMM6500_CountDigLimits);
end;

procedure TDMM6500.SetCountNumber(Value: integer);
begin
 fCount:=TSCPInew.NumberMap(Value,DMM6500_CountLimits);
end;

procedure TDMM6500.SetDelayAuto(Measure: TKeitley_Measure; toOn: boolean);
begin
//:<function>:DEL:AUTO ON|OFF
 SetShablon(dm_pp_DelayAuto,@toOn,Measure);
// MeasParameterCreate(Measure);
// SetDelayAutoAction(Measure,fMeasParameters[Measure],toOn);
end;

//procedure TDMM6500.SetDelayAuto(toOn: boolean);
//begin
// if SetDelayAutoAction(fMeasureFunction,toOn) then
//  (MeasParameters as TDMM6500MeasPar_BaseDelay).AutoDelay:=toOn;
//end;

//procedure TDMM6500.SetDelayAutoAction(Measure:TKeitley_Measure;
//                                PM: TDMM6500MeasPar_Base;
//                                toOn:boolean);
//begin
////:<function>:DEL:AUTO ON|OFF
// if Measure<kt_mDigCur then
//  begin
//   OnOffFromBool(toOn);
//   SetupOperation(MeasureToRootNodeNumber(Measure),22);
//   (PM as TDMM6500MeasPar_BaseDelay).AutoDelay:=toOn;
//  end;
//end;

procedure TDMM6500.SetDetectorBW(DecBW: TDMM6500_DetectorBandwidth;
  ChanNumber: Byte);
begin
// :<function>:DET:BAND <n>
 SetShablon(dm_pp_DetectorBW,Pointer(DecBW),ChanNumber);
// if ChanNumber=0
// then  SetDetectorBWAction(fMeasureFunction,MeasParameters,DecBW)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetDetectorBWAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     DecBW);
end;

//procedure TDMM6500.SetDetectorBWAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; DecBW: TDMM6500_DetectorBandwidth);
//begin
//// :<function>:DET:BAND <n>
// if not(FM in [kt_mCurAC,kt_mVolAC]) then Exit;
// fAdditionalString:=inttostr(DMM6500_DetectorBandwidthCommand[DecBW]);
// SetupOperation(MeasureToRootNodeNumber(FM),53);
// (PM as TDMM6500MeasPar_BaseAC).DetectorBW:=DecBW;
//end;

procedure TDMM6500.SetDisplayDigitsNumber(Number: TKeitleyDisplayDigitsNumber; ChanNumber: Byte);
begin
   if ChanNumber=0
   then  SetDisplayDigitsNumberAction(fMeasureFunction,MeasParameters,Number)
   else
     if ChanSetupBegin(ChanNumber) then
//     begin
//       showmessage(inttostr(High(fChansMeasure)));
       SetDisplayDigitsNumberAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
                       fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
                       Number);
//     end;

// if ChanSetupBegin(ChanNumber) then
//  begin
//    inherited SetDisplayDigitsNumber(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,Number);
//    fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters.DisplayDN:=Number;
//  end;

end;

procedure TDMM6500.SetDisplayDigitsNumberAction(Measure: TKeitley_Measure;
  PM: TDMM6500MeasPar_Base; Number: TKeitleyDisplayDigitsNumber);
begin
 inherited SetDisplayDigitsNumber(Measure,Number);
 PM.DisplayDN:=Number;
end;

procedure TDMM6500.SetInputImpedance(InIm: TDMM6500_InputImpedance;
  ChanNumber: Byte);
begin
//:<function>:INP MOHM10|AUTO
 SetShablon(dm_pp_InputImpedance,Pointer(InIm),ChanNumber);
// if ChanNumber=0
//   then  SetInputImpedanceAction(fMeasureFunction,MeasParameters,InIm)
//   else
//     if ChanSetupBegin(ChanNumber) then
//       SetInputImpedanceAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                       fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                       InIm);
end;

//procedure TDMM6500.SetInputImpedanceAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; InIm: TDMM6500_InputImpedance);
//  var BaseV:IMeasPar_BaseVoltDC;
//begin
////:<function>:INP MOHM10|AUTO
// BaseV:=GetMeasPar_BaseVoltDC(FM,PM);
// if BaseV=nil then Exit;
// fAdditionalString:=DMM6500_InputImpedanceCommand[InIm];
// SetupOperation(MeasureToRootNodeNumber(FM),52);
// BaseV.InputImpedance:=InIm;
//end;

procedure TDMM6500.SetLineSync(toOn: boolean; ChanNumber: Byte);
begin
//:<function>:LINE:Y ON|OFF
 SetShablon(dm_pp_LineSync,@toOn,ChanNumber);
// SetupShablon(SetLineSyncAction,toOn,ChanNumber);
// if ChanNumber=0
// then  SetLineSyncAction(fMeasureFunction,MeasParameters,toOn)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetLineSyncAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     toOn);
end;

//procedure TDMM6500.SetLineSyncAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; toOn: boolean);
//begin
////:<function>:LINE:Y ON|OFF
// if FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
//      kt_mRes4W,kt_mTemp,kt_mCont,kt_mVoltRat] then
//   begin
//    OnOffFromBool(toOn);
//    SetupOperation(MeasureToRootNodeNumber(FM),54);
//    (PM as TDMM6500MeasPar_Continuity).LineSync:=toOn;
//   end;
//end;

procedure TDMM6500.SetDisplayDigitsNumber(Number: TKeitleyDisplayDigitsNumber);
begin
 SetDisplayDigitsNumberAction(fMeasureFunction,MeasParameters,Number);
// inherited SetDisplayDigitsNumber(fMeasureFunction,Number);
// MeasParameters.DisplayDN:=Number;
end;


procedure TDMM6500.SetDisplayDigitsNumber(Measure: TKeitley_Measure;
  Number: TKeitleyDisplayDigitsNumber);
begin
  MeasParameterCreate(Measure);
  SetDisplayDigitsNumberAction(Measure,fMeasParameters[Measure],Number);
//  inherited SetDisplayDigitsNumber(Measure,Number);
//  if assigned(fMeasParameters[Measure]) then
//    fMeasParameters[Measure].DisplayDN:=Number;

//  showmessage('ggg');
end;

procedure TDMM6500.SetMeasureFunction(ChanNumbers: array of byte;
  MeasureFunc: TKeitley_Measure);
 var i:byte;
     tempbool:boolean;
begin
 tempbool:=True;
 for I := 0 to High(ChanNumbers) do
    if not(IsPermittedMeasureFuncForChan(MeasureFunc,ChanNumbers[i])) then
     begin
      tempbool:=False;
      Break;
     end;

 if ChanelNumberIsCorrect(ChanNumbers) and tempbool then
   begin
     fChanOperationString:=PartDelimiter+ChanelToString(ChanNumbers);
     fChanOperation:=True;
     inherited SetMeasureFunction(MeasureFunc);
     for I := 0 to High(ChanNumbers) do
       fChansMeasure[ChanNumbers[i]-fFirstChannelInSlot].MeasureFunction:=MeasureFunc;
   end;
end;

procedure TDMM6500.SetMeasureTime(MT: double; ChanNumber: byte);
begin
 SetShablon(dm_pp_MeasureTime,@MT,ChanNumber);
// SetupShablon(SetMeasureTimeAction,MT,ChanNumber);
//
// if ChanNumber=0
//   then  SetMeasureTimeAction(fMeasureFunction,MeasParameters,MT)
//   else
//     if ChanSetupBegin(ChanNumber) then
//     begin
//       SetMeasureTimeAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                       fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                       MT);
//     end;
end;

//procedure TDMM6500.SetMeasureTimeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; MT: double);
//begin
// case FM of
//  kt_mCurDC,
//  kt_mVolDC,
//  kt_mRes2W,
//  kt_mRes4W,
//  kt_mDiod,
//  kt_mTemp,
//  kt_mVoltRat,
//  kt_mFreq,
//  kt_mPer:
//      begin
//       (PM as TDMM6500MeasPar_BaseDelayMT).MeaureTime:=MT;
//       SetApertureAction(FM,(PM as TDMM6500MeasPar_BaseDelayMT).MeaureTime*1e-3);
//      end;
////  kt_mCont:
////      begin
////       (PM as TDMM6500MeasPar_BaseDelayMT).MeaureTime:=MT;
////       SetNPLCAction(FM,(PM as TDMM6500MeasPar_BaseDelayMT).MeaureTime/Keitley_MeaureTimeConvertConst);
////      end;
//  else ;
//end;

//end;

procedure TDMM6500.SetNPLC(NPLCvalue: double;
  ChanNumber: byte);
begin
//:<function>:NPLC <n>
 SetShablon(dm_pp_NPLC,@NPLCvalue,ChanNumber);
//  SetupShablon(SetNPLCAction,NPLCvalue,ChanNumber);

//  if ChanNumber=0
//   then  SetNPLCAction(fMeasureFunction,NPLCvalue)
//   else
//     if ChanSetupBegin(ChanNumber) then
//     begin
//       SetNPLCAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     NPLCvalue);
//     end;
end;

//procedure TDMM6500.SetNPLCAction(FM: TKeitley_Measure;
//  NPLCvalue: double);
//begin
////:<function>:NPLC <n>
// if FM in [kt_mCurDC,kt_mVolDC,kt_mRes2W,
//   kt_mRes4W,kt_mDiod,kt_mTemp,kt_mVoltRat] then
//  begin
//   fAdditionalString:=NumberToStrLimited(NPLCvalue,DMM6500_NPLCLimits);
//   SetupOperation(MeasureToRootNodeNumber(FM),26);
//  end
//end;

procedure TDMM6500.SetOffsetComp(OC: TDMM6500_OffsetCompen; ChanNumber: Byte);
begin
//:<function>:OCOM OFF|ON|AUTO
 SetShablon(dm_pp_OffsetCompen,Pointer(OC),ChanNumber);
// if ChanNumber=0
// then  SetOffsetCompAction(fMeasureFunction,MeasParameters,OC)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetOffsetCompAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     OC);
end;

//procedure TDMM6500.SetOffsetCompAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; OC: TDMM6500_OffsetCompen);
//begin
////:<function>:OCOM OFF|ON|AUTO
// if FM in [kt_mRes4W,kt_mTemp] then
//  begin
//   fAdditionalString:=DMM6500_OffsetCompenLabel[OC];
//   SetupOperation(MeasureToRootNodeNumber(FM),9);
//   (PM as TDMM6500MeasPar_Base4WT).OffsetComp:=OC;
//  end;
//end;

procedure TDMM6500.SetOpenLD(toOn: boolean; ChanNumber: Byte);
begin
//:<function>:ODET ON|OFF
 SetShablon(dm_pp_OpenLeadDetector,@toOn,ChanNumber);
// SetupShablon(SetOpenLDAction,toOn,ChanNumber);
end;

//procedure TDMM6500.SetOpenLDAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; toOn: boolean);
//begin
////:<function>:ODET ON|OFF
// if FM in [kt_mRes4W,kt_mTemp] then
//   begin
//    OnOffFromBool(toOn);
//    SetupOperation(MeasureToRootNodeNumber(FM),55);
//    (PM as TDMM6500MeasPar_Base4WT).OpenLeadDetector:=toOn;
//   end;
//end;

//procedure TDMM6500.SetRangeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Range: TDMM6500_Resistance2WRange);
//begin
//// :<function>:RANG:AUTO ON
////:<function>:RANG <n>
// if (FM<>kt_mRes2W) then Exit;
// if Range=dm_r2rAuto then
//       begin
//        OnOffFromBool(True);
//        SetupOperation(MeasureToRootNodeNumber(FM),16);
//       end         else
//       begin
//         fAdditionalString:=RangeToString(Range);
//         SetupOperation(MeasureToRootNodeNumber(FM),15);
//       end;
// (PM as TDMM6500MeasPar_Res2W).Range:=Range;
//end;

//procedure TDMM6500.SetRangeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Range: TDMM6500_CurrentDCRange);
//begin
// if not(FM in [kt_mCurDC,kt_mDigCur]) then Exit;
// if (FM=kt_mDigCur)and(Range=dm_cdrAuto) then Exit;
// if (Terminal=kt_otFront)and(Range=dm_cdr10A) then Exit;
//
// if Range=dm_cdrAuto then
//       begin
//        OnOffFromBool(True);
//        SetupOperation(MeasureToRootNodeNumber(FM),16);
//       end         else
//       begin
//         fAdditionalString:=RangeToString(Range);
//         SetupOperation(MeasureToRootNodeNumber(FM),15);
//       end;
// case FM of
//   kt_mCurDC: (PM as TDMM6500MeasPar_CurDC).Range:=Range;
//   kt_mDigCur: (PM as TDMM6500MeasPar_DigCur).Range:=Range;
// end;
//end;

//procedure TDMM6500.SetRangeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Range: TDMM6500_VoltageACRange);
//begin
//// :<function>:RANG:AUTO ON
////:<function>:RANG <n>
// if (FM<>kt_mVolAC) then Exit;
// if Range=dm_varAuto then
//       begin
//        OnOffFromBool(True);
//        SetupOperation(MeasureToRootNodeNumber(FM),16);
//       end         else
//       begin
//         fAdditionalString:=RangeToString(Range);
//         SetupOperation(MeasureToRootNodeNumber(FM),15);
//       end;
// (PM as TDMM6500MeasPar_VoltAC).Range:=Range;
//end;

//procedure TDMM6500.SetRangeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Range: TDMM6500_VoltageDCRange);
//begin
//// :<function>:RANG:AUTO ON
////:<function>:RANG <n>
// if not(FM in [kt_mVolDC,kt_mVoltRat,kt_mDigVolt]) then Exit;
// if (FM=kt_mDigVolt)and(Range=dm_vdrAuto) then Exit;
// if Range=dm_vdrAuto then
//       begin
//        OnOffFromBool(True);
//        SetupOperation(MeasureToRootNodeNumber(FM),16);
//       end         else
//       begin
//         fAdditionalString:=RangeToString(Range);
//         SetupOperation(MeasureToRootNodeNumber(FM),15);
//       end;
// case FM of
//   kt_mVolDC: (PM as TDMM6500MeasPar_VoltDC).Range:=Range;
//   kt_mVoltRat: (PM as TDMM6500MeasPar_VoltRat).Range:=Range;
//   kt_mDigVolt: (PM as TDMM6500MeasPar_DigVolt).Range:=Range;
// end;
//end;

procedure TDMM6500.SetSampleRate(Measure: TKeitley_Measure;
  SR: TDMM6500_DigSampleRate);
begin
 SetShablon(dm_pp_SampleRate,Pointer(SR),Measure);
 SetShablon(dm_pp_ApertureAuto,nil,Measure);
//
// MeasParameterCreate(Measure);
// SetSampleRateAction(Measure,fMeasParameters[Measure],SR);
// SetApertureAutoAction(Measure);
end;

//procedure TDMM6500.SetSampleRate(SR: TDMM6500_DigSampleRate);
//begin
//
// if SetSampleRateAction(fMeasureFunction,SR) then
//  (MeasParameters as TDMM6500MeasPar_BaseDig).SampleRate:=SR;
//end;

procedure TDMM6500.SetSampleRate(SR: TDMM6500_DigSampleRate; ChanNumber: Byte);
begin
//:<function>:SRAT <n>
 SetShablon(dm_pp_SampleRate,Pointer(SR),ChanNumber);
//  if ChanNumber=0
//   then  SetSampleRateAction(fMeasureFunction,MeasParameters,SR)
//   else
//     if ChanSetupBegin(ChanNumber) then
//     begin
//       SetSampleRateAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                       fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                       SR);
//     end;
 SetApertureAuto(ChanNumber);
// if ChanSetupBegin(ChanNumber) then
//    if SetSampleRateAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,SR) then
//     (fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters as TDMM6500MeasPar_BaseDig).SampleRate:=SR;
end;

//procedure TDMM6500.SetSampleRateAction(Measure: TKeitley_Measure;
//                                       PM: TDMM6500MeasPar_Base;
//                                       SR: TDMM6500_DigSampleRate);
//begin
////:<function>:SRAT <n>
// if Measure>kt_mVoltRat then
//  begin
//   fAdditionalString:=IntToStr(SR);
//   SetupOperation(MeasureToRootNodeNumber(Measure),47);
//  (PM as TDMM6500MeasPar_BaseDig).SampleRate:=SR;
//  end
//end;

procedure TDMM6500.SetShablon(MParam: TDMM6500_MeasParameters; P: Pointer;
  Measure: TKeitley_Measure);
begin
 MeasParameterCreate(Measure);
 SetActionShablon(Measure,MeasParameters,P,MParam);
end;

procedure TDMM6500.SetShablon(MParam: TDMM6500_MeasParameters; P: Pointer;
  ChanNumber: byte);
begin
 if ChanNumber=0
 then
      case MParam of
        dm_pp_Range:;
        dm_pp_ThresholdRange,dm_pp_RangeVoltDC,dm_pp_RangeVoltAC,
        dm_pp_RangeCurrentDC,dm_pp_RangeCurrentAC,
        dm_pp_RangeResistance2W,dm_pp_RangeResistance4W,
        dm_pp_RangeCapacitance:SetActionRangeShablon(fMeasureFunction,MeasParameters,P,MParam);
        else SetActionShablon(fMeasureFunction,MeasParameters,P,MParam);
      end
 else
   if ChanSetupBegin(ChanNumber) then
      case MParam of
        dm_pp_Range:;
        dm_pp_ThresholdRange,dm_pp_RangeVoltDC,dm_pp_RangeVoltAC,
        dm_pp_RangeCurrentDC,dm_pp_RangeCurrentAC,
        dm_pp_RangeResistance2W,dm_pp_RangeResistance4W,
        dm_pp_RangeCapacitance:SetActionRangeShablon(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
                     P,MParam);
        else SetActionShablon(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
                     P,MParam);
      end;
end;

procedure TDMM6500.SetTCoupleType(Value: TDMM6500_TCoupleType;
  ChanNumber: Byte);
begin
 //:<function>:TC:RJUN:TYPE <identifier>
 SetShablon(dm_tp_TCoupleType,Pointer(Value),ChanNumber);
// if ChanNumber=0
// then  SetTCoupleTypeAction(fMeasureFunction,MeasParameters,Value)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetTCoupleTypeAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Value);
end;

//procedure TDMM6500.SetTCoupleTypeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Value: TDMM6500_TCoupleType);
//begin
////:<function>:TC:RJUN:TYPE <identifier>
// if FM=kt_mTemp then
//  begin
//   fAdditionalString:=DMM6500_TCoupleTypeLabel[Value];
//   SetupOperation(33,60,2);
//   (PM as TDMM6500MeasPar_Temper).TCoupleType:=Value;
//  end
//end;

procedure TDMM6500.SetThermistorType(Value: TDMM6500_ThermistorType;
  ChanNumber: Byte);
begin
//:<function>:THER <n>
  SetShablon(dm_tp_ThermistorType,Pointer(Value),ChanNumber);
// if ChanNumber=0
// then  SetThermistorTypeAction(fMeasureFunction,MeasParameters,Value)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetThermistorTypeAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Value);
end;

//procedure TDMM6500.SetThermistorTypeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Value: TDMM6500_ThermistorType);
//begin
////:<function>:THER <n>
// if FM=kt_mTemp then
//  begin
//   fAdditionalString:=IntToStr(DMM6500_ThermistorTypeValues[Value]);
//   SetupOperation(33,61);
//   (PM as TDMM6500MeasPar_Temper).ThermistorType:=Value;
//  end
//end;

procedure TDMM6500.SetThresholdRange(Range: TDMM6500_VoltageACRange;
  ChanNumber: Byte);
begin
// :<function>:THR:RANG:AUTO ON
//:<function>:THR:RANG <n>
 SetShablon(dm_pp_ThresholdRange,Pointer(Range),ChanNumber);
// if ChanNumber=0
// then  SetThresholdRangeAction(fMeasureFunction,MeasParameters,Range)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetThresholdRangeAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Range);
end;

//procedure TDMM6500.SetThresholdRangeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Range: TDMM6500_VoltageACRange);
//begin
//// :<function>:THR:RANG:AUTO ON
////:<function>:THR:RANG <n>
// if not(FM in [kt_mFreq,kt_mPer]) then Exit;
// if Range=dm_varAuto then
//       begin
//        OnOffFromBool(True);
//        SetupOperation(MeasureToRootNodeNumber(FM),56);
//       end         else
//       begin
//         fAdditionalString:=RangeToString(Range);
//         SetupOperation(MeasureToRootNodeNumber(FM),56,1);
//       end;
// (PM as TDMM6500MeasPar_FreqPeriod).ThresholdRange:=Range;
//end;

procedure TDMM6500.SetTransdType(Value: TDMM6500_TempTransducer;
  ChanNumber: Byte);
begin
//:<function>::TRAN <type>
 SetShablon(dm_tp_TransdType,Pointer(Value),ChanNumber);

// if ChanNumber=0
// then  SetTransdTypeAction(fMeasureFunction,MeasParameters,Value)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetTransdTypeAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Value);
end;

//procedure TDMM6500.SetTransdTypeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Value: TDMM6500_TempTransducer);
//begin
////:<function>::TRAN <type>
// if FM=kt_mTemp then
//  begin
//   fAdditionalString:=DMM6500_TempTransducerCommand[Value];
//   SetupOperation(33,62);
//   (PM as TDMM6500MeasPar_Temper).TransdType:=Value;
//  end
//end;

//procedure TDMM6500.SetUnits(Un: TDMM6500_VoltageUnits);
//  var BaseV:IMeasPar_BaseVolt;
//begin
////:<function>:UNIT <unitOfMeasure>
// BaseV:=GetMeasPar_BaseVolt(fMeasureFunction,MeasParameters);
// if BaseV=nil then Exit;
//
// fAdditionalString:=DMM6500_VoltageUnitsLabel[Un];
// SetupOperation(MeasureToRootNodeNumber(fMeasureFunction),50);
// BaseV.Units:=Un;
//end;

procedure TDMM6500.SetUnits(Un: TDMM6500_VoltageUnits; ChanNumber: Byte);
//   var BaseV:IMeasPar_BaseVolt;
begin
//:<function>:UNIT <unitOfMeasure>
 SetShablon(dm_pp_UnitsVolt,Pointer(Un),ChanNumber);
//  if ChanNumber=0
//   then  SetUnitsVoltAction(fMeasureFunction,MeasParameters,Un)
//   else
//     if ChanSetupBegin(ChanNumber) then
//     begin
//       SetUnitsVoltAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                       fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                       Un);
//     end;


// if ChanSetupBegin(ChanNumber) then
// begin
//   BaseV:=GetMeasPar_BaseVolt(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                   fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters);
//   if BaseV=nil then Exit;
//
//   fAdditionalString:=DMM6500_VoltageUnitsLabel[Un];
//   SetupOperation(MeasureToRootNodeNumber(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction),50);
//   BaseV.Units:=Un;
// end;

end;

//procedure TDMM6500.SetMeasureFunctionChan(ChanNumber: byte;
//  MeasureFunc: TKeitley_Measure);
//begin
// if ChanelNumberIsCorrect(ChanNumber) and IsPermittedMeasureFuncForChan(MeasureFunc,ChanNumber) then
//   begin
//     fChanOperationString:=PartDelimiter+ChanelToString(ChanNumber);
//     fChanOperation:=True;
//     inherited SetMeasureFunction(MeasureFunc);
//     fChansMeasureFunction[ChanNumber-fFirstChannelInSlot]:=MeasureFunc;
//   end;
//end;

function TDMM6500.TestRealCard_Presence: boolean;
begin
// :SYST:CARD1:IDN?
 QuireOperation(7,45,50,False);
 Result:=(fDevice.Value=314);
 fRealCardPresent:=Result;
end;


//function TDMM6500.ValueToACCurrentRange(Value: double): TDMM6500_CurrentACRange;
//begin
// if round(Value)=3 then
//   begin
//     Result:=dm_car3A;
//     Exit;
//   end;
// if round(Value)=10 then
//   begin
//     Result:=dm_car10A;
//     Exit;
//   end;
// Result:=TDMM6500_CurrentACRange(round(Log10(Value/1e-4))+1);
//end;

//function TDMM6500.ValueToACVoltageRange(Value: double): TDMM6500_VoltageACRange;
//begin
// if round(Value)=750 then
//   begin
//     Result:=dm_var750V;
//     Exit;
//   end;
// Result:=TDMM6500_VoltageACRange(round(Log10(Value/0.1))+1);
//end;

//function TDMM6500.ValueToBiasLevel(Value: double): TDMM6500_DiodeBiasLevel;
//begin
// Result:=TDMM6500_DiodeBiasLevel(round(Log10(Value/1e-5)));
//end;

//function TDMM6500.ValueToCapacitanceRange(
//  Value: double): TDMM6500_CapacitanceRange;
//begin
// Result:=TDMM6500_CapacitanceRange(round(Log10(Value/1e-9))+1);
//end;

//function TDMM6500.ValueToDCCurrentRange(Value: double): TDMM6500_CurrentDCRange;
//begin
// if round(Value)=3 then
//   begin
//     Result:=dm_cdr3A;
//     Exit;
//   end;
// if round(Value)=10 then
//   begin
//     Result:=dm_cdr10A;
//     Exit;
//   end;
// Result:=TDMM6500_CurrentDCRange(round(Log10(Value/1e-5))+1);
//end;

//function TDMM6500.ValueToDCVoltageRange(Value: double): TDMM6500_VoltageDCRange;
//begin
// Result:=TDMM6500_VoltageDCRange(round(Log10(Value/0.1))+1);
//end;

function TDMM6500.ValueToOrd(Value: double; FM: TKeitley_Measure): integer;
begin
  case FM of
   kt_mVolAC:if  round(Value)=750
              then Result:=5
              else Result:=round(Log10(Value/0.1))+1;
   kt_mDigCur,
   kt_mCurDC: begin
                if round(Value)=3 then
                 begin
                   Result:=7;
                   Exit;
                 end;
                if round(Value)=10
                  then Result:=8
                  else Result:=round(Log10(Value/1e-5))+1;
              end;
   kt_mCurAC: begin
                if round(Value)=3 then
                 begin
                   Result:=6;
                   Exit;
                 end;
                if round(Value)=10
                  then Result:=7
                  else Result:=round(Log10(Value/1e-4))+1;
              end;
   kt_mRes4W,
   kt_mRes2W: Result:=round(Log10(Value/10))+1;
   kt_mCap: Result:=round(Log10(Value/1e-9))+1;
   kt_mDiod: Result:=round(Log10(Value/1e-5));
   else Result:=round(Log10(Value/0.1))+1;
  end;
end;

//function TDMM6500.ValueToResistance2WRange(
//  Value: double): TDMM6500_Resistance2WRange;
//begin
// Result:=TDMM6500_Resistance2WRange(round(Log10(Value/10))+1);
//end;

//function TDMM6500.ValueToResistance4WRange(
//  Value: double): TDMM6500_Resistance4WRange;
//begin
// Result:=TDMM6500_Resistance4WRange(round(Log10(Value))+1);
//end;

//function TDMM6500.RangeToString(Range:TDMM6500_VoltageDCRange): string;
//begin
// case Range of
//  dm_vdrAuto:Result:='';
//  else Result:=floattostr(0.1*Power(10,ord(Range)-1));
// end;
//end;

function TDMM6500.ParametrToFLNode(MParam: TDMM6500_MeasParameters): byte;
begin
 case MParam of
   dm_tp_SimRefTemp,
   dm_tp_TCoupleType,
   dm_tp_RefJunction: Result:=60;
   dm_tp_RTDAlpha,
   dm_tp_RTDBeta,
   dm_tp_RTDDelta,
   dm_tp_RTDZero,
   dm_tp_W2RTDType,
   dm_tp_W3RTDType,
   dm_tp_W4RTDType: Result:=59;
   dm_tp_ThermistorType: Result:=61;
   dm_dp_BiasLevel:Result:=58;
   dm_vrp_VRMethod:Result:=57;
   dm_pp_OffsetCompen:Result:=9;
   dm_pp_OpenLeadDetector:Result:=55;
   dm_pp_LineSync:Result:=54;
   dm_pp_AzeroState:Result:=20;
   dm_pp_DetectorBW:Result:=53;
   dm_pp_InputImpedance:Result:=52;
   dm_tp_UnitsTemp,
   dm_pp_UnitsVolt,
   dm_pp_Units:Result:=50;
   dm_pp_DbmWReference:Result:=49;
   dm_pp_DecibelReference:Result:=48;
   dm_pp_ApertureAuto,
   dm_pp_MeasureTime,
   dm_pp_Aperture:Result:=51;
   dm_pp_NPLC:Result:=26;
   dm_pp_SampleRate:Result:=47;
   dm_pp_DelayAuto:Result:=22;
   dm_pp_RangeVoltDC,
   dm_pp_RangeVoltAC,
   dm_pp_RangeCurrentDC,
   dm_pp_RangeCurrentAC,
   dm_pp_RangeResistance2W,
   dm_pp_RangeResistance4W,
   dm_pp_RangeCapacitance,
   dm_pp_Range:Result:=15;
   dm_pp_ThresholdRange:Result:=56;
   else  Result:=62; // dm_tp_TransdType
 end;
end;

function TDMM6500.ParameterToLeafNode(MParam: TDMM6500_MeasParameters;
                                     FM: TKeitley_Measure): byte;
begin
 case MParam of
   dm_tp_RefJunction,
   dm_tp_RTDBeta: Result:=1;
   dm_tp_TCoupleType,
   dm_tp_RTDDelta: Result:=2;
   dm_tp_RTDZero: Result:=3;
   dm_tp_W2RTDType: Result:=4;
   dm_tp_W3RTDType: Result:=5;
   dm_tp_W4RTDType: Result:=6;
   dm_pp_Units: if FM=kt_mTemp then Result:=1
                               else Result:=2;
   else  Result:=0;
 end;
end;

function TDMM6500.TestPseudocard_Presence: boolean;
begin
 QuireOperation(7,45,52,False);
 Result:=(fDevice.Value=314);
end;

function TDMM6500.ChanelNumberIsCorrect(ChanNumber: byte): boolean;
begin
 Result:=(ChanNumber in [fFirstChannelInSlot..fLastChannelInSlot]){or(DeviceEthernetisAbsent)};
end;

function TDMM6500.ChanelNumberIsCorrect(ChanNumberLow,
  ChanNumberHigh: byte): boolean;
begin
 Result:=ChanelNumberIsCorrect(ChanNumberLow)
         and ChanelNumberIsCorrect(ChanNumberHigh);
end;

function TDMM6500.ChanelToString(ChanNumbers: array of byte): string;
 var i:byte;
begin
 Result:='(@';
 for I := Low(ChanNumbers) to High(ChanNumbers) do
   begin
   Result:=Result+inttostr(ChanNumbers[i]);
   if i<>High(ChanNumbers)
     then Result:=Result+PartDelimiter;
   end;
 Result:=Result+')';
end;

//function TDMM6500.GetShablon(QuireFunc:TQuireFunction;ChanNumber:byte): boolean;
//begin
// if ChanNumber=0
//    then Result:=QuireFunc(fMeasureFunction,MeasParameters)
//    else
//     begin
//       if ChanQuireBegin(ChanNumber) then
//        begin
//          Result:=QuireFunc(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                         fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters);
//          fChanOperation:=False;
//        end                          else
//          Result:=False;
//     end;
//end;

function TDMM6500.GetTCoupleType(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_tp_TCoupleType,ChanNumber);
// Result:=GetShablon(GetTCoupleTypeAction,ChanNumber);
end;

//function TDMM6500.GetTCoupleTypeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//procedure TDMM6500.GetTCoupleTypeAction(PM: TDMM6500MeasPar_Base);
//begin
// if FM=kt_mTemp then
//  begin
//    try
//      QuireOperation(33,60,2);
//      Result:=(fDevice.Value<>ErResult);
//      if Result then
//        (PM as TDMM6500MeasPar_Temper).TCoupleType:=TDMM6500_TCoupleType(round(fDevice.Value));
//    except
//     Result:=False;
//    end;
//  end           else
//  Result:=False;
//end;

function TDMM6500.GetThermistorType(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_tp_ThermistorType,ChanNumber);
// Result:=GetShablon(GetThermistorTypeAction,ChanNumber);
end;

//function TDMM6500.GetThermistorTypeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//procedure TDMM6500.GetThermistorTypeAction(PM: TDMM6500MeasPar_Base);
//begin
// if FM=kt_mTemp then
//  begin
//    try
//      QuireOperation(33,61);
//      Result:=(fDevice.Value<>ErResult);
//      if Result then
//        (PM as TDMM6500MeasPar_Temper).ThermistorType:=TDMM6500_ThermistorType(round(fDevice.Value));
//    except
//     Result:=False;
//    end;
//  end           else
//  Result:=False;
//end;

function TDMM6500.GetThresholdRange(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_pp_ThresholdRange,ChanNumber);
// Result:=GetShablon(GetThresholdRangeAction,ChanNumber);
end;

//function TDMM6500.GetThresholdRangeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
// Result:=False;
// if not(FM in [kt_mFreq,kt_mPer]) then Exit;
//
// QuireOperation(MeasureToRootNodeNumber(FM),56);
// Result:=(fDevice.Value<>ErResult);
// if not(Result) then Exit;
//
// if fDevice.Value=1 then
//  (PM as TDMM6500MeasPar_FreqPeriod).ThresholdRange:=dm_varAuto
//                    else
//  begin
//    try
//      QuireOperation(MeasureToRootNodeNumber(FM),56,1);
//      Result:=(fDevice.Value<>ErResult);
//      if Result then
//         (PM as TDMM6500MeasPar_FreqPeriod).ThresholdRange:=ValueToACVoltageRange(fDevice.Value);
//    except
//     Result:=False;
//    end;
//  end;
//end;

function TDMM6500.GetTransdType(ChanNumber: byte): boolean;
begin
 Result:=GetShablon(dm_tp_TransdType,ChanNumber);
// Result:=GetShablon(GetTransdTypeAction,ChanNumber);
end;

//function TDMM6500.GetTransdTypeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base): boolean;
//begin
// if FM=kt_mTemp then
//  begin
//    try
//      QuireOperation(33,62);
//      Result:=(fDevice.Value<>ErResult);
//      if Result then
//        (PM as TDMM6500MeasPar_Temper).TransdType:=TDMM6500_TempTransducer(round(fDevice.Value));
//    except
//     Result:=False;
//    end;
//  end           else
//  Result:=False;
//end;

//procedure TDMM6500.GetTransdTypeAction(PM: TDMM6500MeasPar_Base);
//begin
// (PM as TDMM6500MeasPar_Temper).TransdType:=TDMM6500_TempTransducer(round(fDevice.Value));
//end;

function TDMM6500.ChanQuireBegin(ChanNumber: byte): boolean;
begin
 if ChanelNumberIsCorrect(ChanNumber) then
   begin
     fMeasureChanNumber:=ChanNumber;
     fChanOperationString:=' '+ChanelToString(ChanNumber);
     fChanOperation:=True;
     Result:=True;
   end                                else
     Result:=False;
end;

function TDMM6500.ChanSetupBegin(ChanNumber: byte): boolean;
begin
 if ChanelNumberIsCorrect(ChanNumber) then
   begin
     fChanOperationString:=PartDelimiter+ChanelToString(ChanNumber);
     fChanOperation:=True;
     Result:=True;
   end                                else
     Result:=False;
end;

procedure TDMM6500.ChansMeasureCreate;
 var i:byte;
begin
 if High(fChansMeasure)>-1 then
  for I := 0 to High(fChansMeasure) do
    FreeAndNil(fChansMeasure[i]);
 if (fFirstChannelInSlot=0)or(fLastChannelInSlot=0)
   then SetLength(fChansMeasure,0)
   else SetLength(fChansMeasure,fLastChannelInSlot-fFirstChannelInSlot+1);
 for I := 0 to High(fChansMeasure) do
   fChansMeasure[i]:=TDMM6500Channel.Create(i+1,Self);
end;

procedure TDMM6500.ChansMeasureDestroy;
 var i:byte;
begin
 for I := 0 to High(fChansMeasure) do
   fChansMeasure[i].Free;
end;

function TDMM6500.ChanelNumberIsCorrect(ChanNumbers: array of byte): boolean;
 var i:byte;
begin
  Result:=True;
  for I := Low(ChanNumbers) to High(ChanNumbers) do
    if not(ChanelNumberIsCorrect(ChanNumbers[i]))
      then
       begin
         Result:=False;
         Exit;
       end;
end;


{ TDMM6500Channel }

constructor TDMM6500Channel.Create(ChanNumber: byte; DMM6500: TDMM6500);
begin
 inherited Create;
 FNumber:=ChanNumber;
 fDMM6500:=DMM6500;
 FMeasureFunction:=kt_mVolDC;
 fCount:=1;
 fCountDig:=1;
end;

destructor TDMM6500Channel.Destroy;
begin
  MeasParametersDestroy;
  inherited;
end;

function TDMM6500Channel.GetMeasParameters: TDMM6500MeasPar_Base;
begin
 if not(Assigned(fMeasParameters[FMeasureFunction]))
  then fMeasParameters[FMeasureFunction]:=DMM6500MeasParFactory(FMeasureFunction);
 Result:=fMeasParameters[FMeasureFunction];
end;

procedure TDMM6500Channel.MeasParametersDestroy;
 var i:TKeitley_Measure;
begin
 for I := Low(TKeitley_Measure) to High(TKeitley_Measure) do
  if Assigned(fMeasParameters[i]) then
    fMeasParameters[i].Free;
end;

procedure TDMM6500Channel.SetCountDigNumber(Value: integer);
begin
 fCountDig:=TSCPInew.NumberMap(Value,DMM6500_CountDigLimits);
end;

procedure TDMM6500Channel.SetCountNumber(Value: integer);
begin
 fCount:=TSCPInew.NumberMap(Value,DMM6500_CountLimits);
end;


//procedure TDMM6500.SetDecibelReference(DBvalue: double);
////  var BaseV:IMeasPar_BaseVolt;
//begin
////:<function>:DB:REF <n>
//
//// BaseV:=GetMeasPar_BaseVolt(fMeasureFunction,MeasParameters);
//// if BaseV<>nil then
////  begin
////   BaseV.DB:=DBvalue;
////   fAdditionalString:=FloatToStrF(BaseV.DB,ffExponent,4,0);
////   SetupOperation(MeasureToRootNodeNumber(fMeasureFunction),48);
////  end;
//  SetDecibelReferenceAction(fMeasureFunction,MeasParameters,DBvalue);
//
//end;

//procedure TDMM6500.SetDbmWReference(DBMvalue: integer);
//  var BaseV:IMeasPar_BaseVolt;
//begin
////:<function>:DBM:REF <n>
//
// BaseV:=GetMeasPar_BaseVolt(fMeasureFunction,MeasParameters);
// if BaseV=nil then Exit;
//
// BaseV.DBM:=DBMvalue;
// fAdditionalString:=Inttostr(BaseV.DBM);
// SetupOperation(MeasureToRootNodeNumber(fMeasureFunction),49);
//end;

procedure TDMM6500.SetDbmWReference(DBMvalue: Integer; ChanNumber: Byte);
//   var BaseV:IMeasPar_BaseVolt;
begin
//:<function>:DBM:REF <n>
 SetShablon(dm_pp_DbmWReference,@DBMValue,ChanNumber);
//  SetupShablon(SetDbmWReferenceAction,DBMvalue,ChanNumber);
// if ChanNumber=0
//   then  SetDbmWReferenceAction(fMeasureFunction,MeasParameters,DBMvalue)
//   else
//     if ChanSetupBegin(ChanNumber) then
//     begin
//       SetDbmWReferenceAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                       fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                       DBMvalue);
//     end;
end;

//procedure TDMM6500.SetDbmWReferenceAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; DBMvalue: integer);
//  var BaseV:IMeasPar_BaseVolt;
//begin
////:<function>:DBM:REF <n>
// BaseV:=GetMeasPar_BaseVolt(FM,PM);
// if BaseV=nil then Exit;
//
// BaseV.DBM:=DBMvalue;
// fAdditionalString:=Inttostr(BaseV.DBM);
// SetupOperation(MeasureToRootNodeNumber(FM),49);
//end;

procedure TDMM6500.SetDecibelReference(DBvalue: double;ChanNumber: byte);
begin
 SetShablon(dm_pp_DecibelReference,@DBValue,ChanNumber);
// SetupShablon(SetDecibelReferenceAction,DBvalue,ChanNumber);
// if ChanNumber=0
//   then  SetDecibelReferenceAction(fMeasureFunction,MeasParameters,DBvalue)
//   else
//     if ChanSetupBegin(ChanNumber) then
//     begin
//       SetDecibelReferenceAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                       fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                       DBvalue);
//     end;
end;

//procedure TDMM6500.SetDecibelReferenceAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; DBvalue: double);
//  var BaseV:IMeasPar_BaseVolt;
//begin
// BaseV:=GetMeasPar_BaseVolt(FM,PM);
// if BaseV<>nil then
//  begin
//   BaseV.DB:=DBvalue;
//   fAdditionalString:=FloatToStrF(BaseV.DB,ffExponent,4,0);
//   SetupOperation(MeasureToRootNodeNumber(FM),48);
//  end;
//end;

procedure TDMM6500.SetDelayAuto(toOn: Boolean; ChanNumber: Byte);
begin
  SetShablon(dm_pp_DelayAuto,@toOn,ChanNumber);
//  if ChanNumber=0
//   then  SetDelayAutoAction(fMeasureFunction,MeasParameters,toOn)
//   else
//     if ChanSetupBegin(ChanNumber) then
//     begin
//       SetDelayAutoAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                       fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                       toOn);
//     end;
//
// if ChanSetupBegin(ChanNumber) then
//    if SetDelayAutoAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,toOn) then
//     (fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters as TDMM6500MeasPar_BaseDelay).AutoDelay:=toOn;
end;

//procedure TDMM6500.SetUnits(Un: TDMM6500_TempUnits);
//begin
// if fMeasureFunction<>kt_mTemp then Exit;
//
// fAdditionalString:=DMM6500_TempUnitsCommand[Un];
// SetupOperation(MeasureToRootNodeNumber(fMeasureFunction),50);
// (MeasParameters as TDMM6500MeasPar_Temper).Units:=Un;
//end;

procedure TDMM6500.SetUnits(Un: TDMM6500_TempUnits; ChanNumber: Byte);
begin
  SetShablon(dm_tp_UnitsTemp,Pointer(Un),ChanNumber);
// if ChanNumber=0
// then  SetUnitsTempAction(fMeasureFunction,MeasParameters,Un)
// else
//   if ChanSetupBegin(ChanNumber) then
//   begin
//     SetUnitsTempAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Un);
//   end;

// if ChanSetupBegin(ChanNumber) then
// begin
//   if fChansMeasure[ChanNumber-fFirstChannelInSlot].fMeasureFunction<>kt_mTemp then Exit;
//   fAdditionalString:=DMM6500_TempUnitsCommand[Un];
//   SetupOperation(MeasureToRootNodeNumber(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction),50);
//   (fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters as TDMM6500MeasPar_Temper).Units:=Un;
// end;
end;

//procedure TDMM6500.SetUnitsTempAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Un: TDMM6500_TempUnits);
//begin
// if FM<>kt_mTemp then Exit;
//
// fAdditionalString:=DMM6500_TempUnitsCommand[Un];
// SetupOperation(MeasureToRootNodeNumber(FM),50);
// (PM as TDMM6500MeasPar_Temper).Units:=Un;
//end;

//procedure TDMM6500.SetUnitsVoltAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Un: TDMM6500_VoltageUnits);
//  var BaseV:IMeasPar_BaseVolt;
//begin
////:<function>:UNIT <unitOfMeasure>
// BaseV:=GetMeasPar_BaseVolt(FM,PM);
// if BaseV=nil then Exit;
//
// fAdditionalString:=DMM6500_VoltageUnitsLabel[Un];
// SetupOperation(MeasureToRootNodeNumber(FM),50);
// BaseV.Units:=Un;
//end;

//procedure TDMM6500.SetupShablon(
//  SetProcedureDoubleGeneral: TSetProcedureDoubleGeneral; Value: double;
//  ChanNumber: byte);
//begin
// if ChanNumber=0
//   then  SetProcedureDoubleGeneral(fMeasureFunction,Value)
//   else
//     if ChanSetupBegin(ChanNumber) then
//       SetProcedureDoubleGeneral(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                       Value);
//end;

//procedure TDMM6500.SetupShablon(SetProcedureDouble: TSetProcedureDouble;
//  Value: double; ChanNumber: byte);
//begin
// if ChanNumber=0
// then  SetProcedureDouble(fMeasureFunction,MeasParameters,Value)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetProcedureDouble(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Value);
//end;

procedure TDMM6500.SetVRMethod(VRM: TDMM6500_VoltageRatioMethod;
  ChanNumber: Byte);
begin
//:VOLT:RAT:REL:METH RES|PART
 SetShablon(dm_vrp_VRMethod,Pointer(VRM),ChanNumber);
//
// if ChanNumber=0
// then  SetVRMethodAction(fMeasureFunction,MeasParameters,VRM)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetVRMethodAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     VRM);
end;

//procedure TDMM6500.SetVRMethodAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; VRM: TDMM6500_VoltageRatioMethod);
//begin
////:VOLT:RAT:REL:METH RES|PART
// if FM=kt_mVoltRat then
//  begin
//   fAdditionalString:=DMM6500_VoltageRatioMethodCommand[VRM];
//   SetupOperation(MeasureToRootNodeNumber(FM),57);
//   (PM as TDMM6500MeasPar_VoltRat).VRMethod:=VRM;
//  end;
//end;

procedure TDMM6500.SetW2RTDType(RTDType: TDMM6500_RTDType; ChanNumber: Byte);
begin
//:<function>:RTD:TWO|THR|FOUR <type>
 SetShablon(dm_tp_W2RTDType,Pointer(RTDType),ChanNumber);
// SetupShablon(SetWiRTDTypeAction,RTDType,4,ChanNumber);
end;

procedure TDMM6500.SetW3RTDType(RTDType: TDMM6500_RTDType; ChanNumber: Byte);
begin
 SetShablon(dm_tp_W3RTDType,Pointer(RTDType),ChanNumber);
// SetupShablon(SetWiRTDTypeAction,RTDType,5,ChanNumber);
end;

procedure TDMM6500.SetW4RTDType(RTDType: TDMM6500_RTDType; ChanNumber: Byte);
begin
 SetShablon(dm_tp_W4RTDType,Pointer(RTDType),ChanNumber);
// SetupShablon(SetWiRTDTypeAction,RTDType,6,ChanNumber);
end;

//procedure TDMM6500.SetWiRTDTypeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; RTDType: TDMM6500_RTDType;
//  WiType: TDMM6500_RTDPropertyNumber);
//begin
////:<function>:RTD:TWO|THR|FOUR <type>
// if FM=kt_mTemp then
//  begin
//   fAdditionalString:=DMM6500_WiRTDTypeLabel[RTDType];
//   SetupOperation(33,59,WiType);
//   case WiType of
//     4:(PM as TDMM6500MeasPar_Temper).W2RTDType:=RTDType;
//     5:(PM as TDMM6500MeasPar_Temper).W3RTDType:=RTDType;
//     6:(PM as TDMM6500MeasPar_Temper).W4RTDType:=RTDType;
//   end;
//  end;
//end;

//procedure TDMM6500.StringToCoupleRefJunct(Str: string);
//  var i:TDMM6500_TCoupleRefJunct;
//begin
// for I := Low(TDMM6500_TCoupleRefJunct) to High(TDMM6500_TCoupleRefJunct) do
//  begin
//   if Str=DMM6500_TCoupleRefJunctCommand[i] then
//     begin
//       fDevice.Value:=ord(i);
//       Break;
//     end;
//  end;
//end;

//procedure TDMM6500.StringToDetectorBW(Str: string);
//  var i:TDMM6500_DetectorBandwidth;
//begin
// try
//  fDevice.Value:=StrToInt(Str);
//  for I := Low(TDMM6500_DetectorBandwidth) to High(TDMM6500_DetectorBandwidth) do
//   if fDevice.Value=DMM6500_DetectorBandwidthCommand[i] then
//     begin
//       fDevice.Value:=ord(i);
//       Break;
//     end;
// except
//  fDevice.Value:=ErResult;
// end;
//end;

//procedure TDMM6500.StringToInputImpedance(Str: string);
//  var i:TDMM6500_InputImpedance;
//begin
// for I := Low(TDMM6500_InputImpedance) to High(TDMM6500_InputImpedance) do
//  begin
//   if Str=DMM6500_InputImpedanceCommand[i] then
//     begin
//       fDevice.Value:=ord(i);
//       Break;
//     end;
//  end;
//end;

//procedure TDMM6500.StringToOffsetComp(Str: string);
//  var i:TDMM6500_OffsetCompen;
//begin
// for I := Low(TDMM6500_OffsetCompen) to High(TDMM6500_OffsetCompen) do
//  begin
//   if Str=DMM6500_OffsetCompenLabel[i] then
//     begin
//       fDevice.Value:=ord(i);
//       Break;
//     end;
//  end;
//end;

procedure TDMM6500.StringToOrd(Str: string);
  var i:byte;
begin
 try
   for I := 0 to HighForStrParsing do
     if ItIsRequiredStr(Str,i) then
       begin
         fDevice.Value:=i;
         Break;
       end;
 except
  fDevice.Value:=ErResult;
 end;
end;

//procedure TDMM6500.StringToRTDType(Str: string);
//  var i:TDMM6500_RTDType;
//begin
// for I := Low(TDMM6500_RTDType) to High(TDMM6500_RTDType) do
//  begin
//   if Str=AnsiLowerCase(DMM6500_WiRTDTypeLabel[i]) then
//     begin
//       fDevice.Value:=ord(i);
//       Break;
//     end;
//  end;
//end;

//procedure TDMM6500.StringToTCoupleType(Str: string);
//  var i:TDMM6500_TCoupleType;
//begin
// for I := Low(TDMM6500_TCoupleType) to High(TDMM6500_TCoupleType) do
//  begin
//   if Str=DMM6500_TCoupleTypeLabel[i] then
//     begin
//       fDevice.Value:=ord(i);
//       Break;
//     end;
//  end;
//end;

//procedure TDMM6500.StringToTempTransducer(Str: string);
//  var i:TDMM6500_TempTransducer;
//begin
// for I := Low(TDMM6500_TempTransducer) to High(TDMM6500_TempTransducer) do
//  begin
//   if Str=DMM6500_TempTransducerCommand[i] then
//     begin
//       fDevice.Value:=ord(i);
//       Break;
//     end;
//  end;
//end;

//procedure TDMM6500.StringToVoltageRatioMethod(Str: string);
//  var i:TDMM6500_VoltageRatioMethod;
//begin
// for I := Low(TDMM6500_VoltageRatioMethod) to High(TDMM6500_VoltageRatioMethod) do
//  begin
//   if Pos(DMM6500_VoltageRatioMethodCommand[i],Str)<>0 then
//     begin
//       fDevice.Value:=ord(i);
//       Break;
//     end;
//  end;
//end;

//procedure TDMM6500.StrToTempUnit(Str: string);
//  var i:TDMM6500_TempUnits;
//begin
// for I := Low(TDMM6500_TempUnits) to High(TDMM6500_TempUnits) do
//   if Pos(DMM6500_TempUnitsCommand[i],Str)<>0 then
//     begin
//       fDevice.Value:=ord(i);
//       Break;
//     end;
//end;

//procedure TDMM6500.StringToThermistorType(Str: string);
//  var i:TDMM6500_ThermistorType;
//      Val:integer;
//begin
// Val:=StrToInt(Str);
// for I := Low(TDMM6500_ThermistorType) to High(TDMM6500_ThermistorType) do
//  begin
//   if Val=DMM6500_ThermistorTypeValues[i] then
//     begin
//       fDevice.Value:=ord(i);
//       Break;
//     end;
//  end;
//end;

//procedure TDMM6500.StrToVoltUnit(Str: string);
//  var i:TDMM6500_VoltageUnits;
//begin
// for I := Low(TDMM6500_VoltageUnits) to High(TDMM6500_VoltageUnits) do
//   if Pos(AnsiLowerCase(DMM6500_VoltageUnitsLabel[i]),Str)<>0 then
//     begin
//       fDevice.Value:=ord(i);
//       Break;
//     end;
//end;


function TDMM6500.SuccessfulGet(MParam: TDMM6500_MeasParameters): boolean;
begin
 case MParam of
   dm_tp_RTDZero,
   dm_pp_DbmWReference:Result:=fDevice.isReceived;
   dm_pp_SampleRate:Result:=(fDevice.Value>=Low(TDMM6500_DigSampleRate))
                      and (fDevice.Value<=High(TDMM6500_DigSampleRate));
   else Result:=(fDevice.Value<>ErResult);
 end;
end;

//procedure TDMM6500.SetRangeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Range: TDMM6500_CurrentACRange);
//begin
//// :<function>:RANG:AUTO ON
////:<function>:RANG <n>
// if (FM<>kt_mCurAC) then Exit;
// if (Terminal=kt_otFront)and(Range=dm_car10A) then Exit;
// if Range=dm_carAuto then
//       begin
//        OnOffFromBool(True);
//        SetupOperation(MeasureToRootNodeNumber(FM),16);
//       end         else
//       begin
//         fAdditionalString:=RangeToString(Range);
//         SetupOperation(MeasureToRootNodeNumber(FM),15);
//       end;
// (PM as TDMM6500MeasPar_CurAC).Range:=Range;
//end;

//function TDMM6500.RangeToString(Range: TDMM6500_CurrentACRange): string;
//begin
// case Range of
//  dm_carAuto:Result:='';
//  dm_car3A:Result:='3';
//  dm_car10A:Result:='10';
//  else Result:=floattostr(1e-4*Power(10,ord(Range)-1));
// end;
//end;

//procedure TDMM6500.SetRangeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Range: TDMM6500_Resistance4WRange);
//begin
//// :<function>:RANG:AUTO ON
////:<function>:RANG <n>
// if (FM<>kt_mRes4W) then Exit;
// if ((PM as TDMM6500MeasPar_Res4W).OffsetComp=dm_ocOn)
//     and(Range>dm_r4r10k) then Exit;
//
// if Range=dm_r4rAuto then
//       begin
//        OnOffFromBool(True);
//        SetupOperation(MeasureToRootNodeNumber(FM),16);
//       end         else
//       begin
//         fAdditionalString:=RangeToString(Range);
//         SetupOperation(MeasureToRootNodeNumber(FM),15);
//       end;
// (PM as TDMM6500MeasPar_Res4W).Range:=Range;
//end;

//function TDMM6500.RangeToString(Range: TDMM6500_Resistance4WRange): string;
//begin
// case Range of
//  dm_r4rAuto:Result:='';
//  else Result:=floattostr(Power(10,ord(Range)-1));
// end;
//end;

procedure TDMM6500.SetRange(Range: TDMM6500_VoltageDCRange; ChanNumber: Byte);
begin
// :<function>:RANG:AUTO ON
//:<function>:RANG <n>
 SetShablon(dm_pp_RangeVoltDC,Pointer(Range),ChanNumber);
// if ChanNumber=0
// then  SetRangeAction(fMeasureFunction,MeasParameters,Range)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetRangeAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Range);
end;

procedure TDMM6500.SetRange(Range: TDMM6500_VoltageACRange; ChanNumber: Byte);
begin
 SetShablon(dm_pp_RangeVoltAC,Pointer(Range),ChanNumber);
// if ChanNumber=0
// then  SetRangeAction(fMeasureFunction,MeasParameters,Range)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetRangeAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Range);
end;

//procedure TDMM6500.SetRangeAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Range: TDMM6500_CapacitanceRange);
//begin
// if (FM<>kt_mCap) then Exit;
// if Range=dm_crAuto then
//       begin
//        OnOffFromBool(True);
//        SetupOperation(MeasureToRootNodeNumber(FM),16);
//       end         else
//       begin
//         fAdditionalString:=RangeToString(Range);
//         SetupOperation(MeasureToRootNodeNumber(FM),15);
//       end;
// (PM as TDMM6500MeasPar_Capac).Range:=Range;
//end;

procedure TDMM6500.SetRefJunction(Value: TDMM6500_TCoupleRefJunct;
  ChanNumber: Byte);
begin
//:<function>:TC:RJUN:RSEL <type>
 SetShablon(dm_tp_RefJunction,Pointer(Value),ChanNumber);
// if ChanNumber=0
// then  SetRefJunctionAction(fMeasureFunction,MeasParameters,Value)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetRefJunctionAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Value);
end;

//procedure TDMM6500.SetRefJunctionAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Value: TDMM6500_TCoupleRefJunct);
//begin
////:<function>:TC:RJUN:RSEL <type>
// if FM=kt_mTemp then
//  begin
//   fAdditionalString:=DMM6500_TCoupleRefJunctCommand[Value];
//   SetupOperation(33,60,1);
//   (PM as TDMM6500MeasPar_Temper).RefJunction:=Value;
//  end
//end;

procedure TDMM6500.SetRefTemperature(Value: Double; ChanNumber: Byte);
begin
//:<function>:TC:RJUN:SIM <tempValue>
 SetShablon(dm_tp_SimRefTemp,@Value,ChanNumber);
// SetupShablon(SetRefTemperatureaAction,Value,ChanNumber);
end;

//procedure TDMM6500.SetRefTemperatureaAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Value: Double);
//begin
////:<function>:TC:RJUN:SIM <tempValue>
// if FM=kt_mTemp then
//  begin
//   (PM as TDMM6500MeasPar_Temper).RefTemperature:=Value;
//   fAdditionalString:=FloatToStrF((PM as TDMM6500MeasPar_Temper).RefTemperature,ffExponent,3,0);
//   SetupOperation(33,60,0);
//  end
//end;

procedure TDMM6500.SetRTDAlpha(Value: Double; ChanNumber: Byte);
begin
//:<function>:RTD:ALPH <n>
 SetShablon(dm_tp_RTDAlpha,@Value,ChanNumber);
// SetupShablon(SetRTDAlphaAction,Value,ChanNumber);
end;

//procedure TDMM6500.SetRTDAlphaAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Value: Double);
//begin
////:<function>:RTD:ALPH <n>
// if FM=kt_mTemp then
//  begin
//   (PM as TDMM6500MeasPar_Temper).RTD_Alpha:=Value;
//   fAdditionalString:=FloatToStrF((PM as TDMM6500MeasPar_Temper).RTD_Alpha,ffExponent,9,0);
//   SetupOperation(33,59,0);
//  end
//end;

procedure TDMM6500.SetRTDBeta(Value: Double; ChanNumber: Byte);
begin
//:<function>:RTD:BETA <n>
 SetShablon(dm_tp_RTDBeta,@Value,ChanNumber);
// SetupShablon(SetRTDBetaAction,Value,ChanNumber);
end;

//procedure TDMM6500.SetRTDBetaAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Value: Double);
//begin
////:<function>:RTD:BETA <n>
// if FM=kt_mTemp then
//  begin
//   (PM as TDMM6500MeasPar_Temper).RTD_Beta:=Value;
//   fAdditionalString:=FloatToStrF((PM as TDMM6500MeasPar_Temper).RTD_Beta,ffExponent,9,0);
//   SetupOperation(33,59,1);
//  end
//end;

procedure TDMM6500.SetRTDDelta(Value: Double; ChanNumber: Byte);
begin
//:<function>:RTD:DELT <n>
 SetShablon(dm_tp_RTDDelta,@Value,ChanNumber);
// SetupShablon(SetRTDDeltaAction,Value,ChanNumber);
end;

//procedure TDMM6500.SetRTDDeltaAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Value: Double);
//begin
////:<function>:RTD:DELT <n>
// if FM=kt_mTemp then
//  begin
//   (PM as TDMM6500MeasPar_Temper).RTD_Delta:=Value;
//   fAdditionalString:=FloatToStrF((PM as TDMM6500MeasPar_Temper).RTD_Delta,ffExponent,5,0);;
//   SetupOperation(33,59,2);
//  end
//end;

procedure TDMM6500.SetRTDZero(Value: integer; ChanNumber: Byte);
begin
//:<function>:RTD:ZERO <n>
 SetShablon(dm_tp_RTDZero,@Value,ChanNumber);
//  SetupShablon(SetRTDZeroAction,Value,ChanNumber);
end;

//procedure TDMM6500.SetRTDZeroAction(FM: TKeitley_Measure;
//  PM: TDMM6500MeasPar_Base; Value: integer);
//begin
////:<function>:RTD:ZERO <n>
// if FM=kt_mTemp then
//  begin
//   (PM as TDMM6500MeasPar_Temper).RTD_Zero:=Value;
//   fAdditionalString:=IntToStr((PM as TDMM6500MeasPar_Temper).RTD_Zero);
//   SetupOperation(33,59,3);
//  end
//end;

//function TDMM6500.RangeToString(Range: TDMM6500_CapacitanceRange): string;
//begin
// case Range of
//  dm_crAuto:Result:='';
//  else Result:=floattostr(1e-9*Power(10,ord(Range)-1));
// end;
//end;

procedure TDMM6500.SetRange(Range: TDMM6500_CurrentACRange; ChanNumber: Byte);
begin
 SetShablon(dm_pp_RangeCurrentAC,Pointer(Range),ChanNumber);
// if ChanNumber=0
// then  SetRangeAction(fMeasureFunction,MeasParameters,Range)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetRangeAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Range);
end;

procedure TDMM6500.SetRange(Range: TDMM6500_CurrentDCRange; ChanNumber: Byte);
begin
 SetShablon(dm_pp_RangeCurrentDC,Pointer(Range),ChanNumber);
// if ChanNumber=0
// then  SetRangeAction(fMeasureFunction,MeasParameters,Range)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetRangeAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Range);
end;

procedure TDMM6500.SetRange(Range: TDMM6500_Resistance2WRange;
  ChanNumber: Byte);
begin
 SetShablon(dm_pp_RangeResistance2W,Pointer(Range),ChanNumber);
// if ChanNumber=0
// then  SetRangeAction(fMeasureFunction,MeasParameters,Range)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetRangeAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Range);
end;

procedure TDMM6500.SetRange(Range: TDMM6500_CapacitanceRange; ChanNumber: Byte);
begin
 SetShablon(dm_pp_RangeCapacitance,Pointer(Range),ChanNumber);
// if ChanNumber=0
// then  SetRangeAction(fMeasureFunction,MeasParameters,Range)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetRangeAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Range);
end;

procedure TDMM6500.SetRange(Range: TDMM6500_Resistance4WRange;
  ChanNumber: Byte);
begin
 SetShablon(dm_pp_RangeResistance4W,Pointer(Range),ChanNumber);
// if ChanNumber=0
// then  SetRangeAction(fMeasureFunction,MeasParameters,Range)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetRangeAction(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Range);
end;

//procedure TDMM6500.SetupShablon(SetProcedureInteger: TSetProcedureInteger;
//  Value: Integer; ChanNumber: byte);
//begin
// if ChanNumber=0
// then  SetProcedureInteger(fMeasureFunction,MeasParameters,Value)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetProcedureInteger(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     Value);
//end;

//procedure TDMM6500.SetupShablon(SetProcedure: TSetProcedureRTDType;
//  RTDType: TDMM6500_RTDType; WiType: TDMM6500_RTDPropertyNumber;
//  ChanNumber: byte);
//begin
// if ChanNumber=0
// then  SetProcedure(fMeasureFunction,MeasParameters,RTDType,WiType)
// else
//   if ChanSetupBegin(ChanNumber) then
//     SetProcedure(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
//                     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
//                     RTDType,WiType);
//end;

function TDMM6500.GetShablon(MParam: TDMM6500_MeasParameters;
  ChanNumber: byte): boolean;
begin


 if ChanNumber=0
    then
      case MParam of
        dm_pp_Range,
        dm_pp_ThresholdRange:Result:=GetActionRangeShablon(fMeasureFunction,MeasParameters,MParam);
        else Result:=GetActionShablon(fMeasureFunction,MeasParameters,MParam);
      end
    else
     begin
       if ChanQuireBegin(ChanNumber) then
        begin
         case MParam of
          dm_pp_Range,
          dm_pp_ThresholdRange:Result:=GetActionRangeShablon(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
                         fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
                         MParam);
          else Result:=GetActionShablon(fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction,
                         fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasParameters,
                         MParam);
         end;
         fChanOperation:=False;
        end                          else
          Result:=False;
     end;
end;

function TDMM6500.GetShablon(MParam:TDMM6500_MeasParameters;Measure: TKeitley_Measure): boolean;
begin
 MeasParameterCreate(Measure);
 Result:=GetActionShablon(Measure,fMeasParameters[Measure],MParam);
end;

function TDMM6500.RangeToString(P: pointer;
  MParam: TDMM6500_MeasParameters): string;
begin
 case MParam of
   dm_pp_RangeVoltDC:
       case TDMM6500_VoltageDCRange(P) of
        dm_vdrAuto:Result:='';
        else Result:=floattostr(0.1*Power(10,ord(TDMM6500_VoltageDCRange(P))-1));
       end;
   dm_pp_ThresholdRange,
   dm_pp_RangeVoltAC:
       case TDMM6500_VoltageACRange(P) of
        dm_varAuto:Result:='';
        dm_var750V:Result:='750';
        else Result:=floattostr(0.1*Power(10,ord(TDMM6500_VoltageACRange(P))-1));
       end;
   dm_pp_RangeCurrentDC:
       case TDMM6500_CurrentDCRange(P) of
        dm_cdrAuto:Result:='';
        dm_cdr3A:Result:='3';
        dm_cdr10A:Result:='10';
        else Result:=floattostr(1e-5*Power(10,ord(TDMM6500_CurrentDCRange(P))-1));
       end;
   dm_pp_RangeCurrentAC:
       case TDMM6500_CurrentACRange(P) of
        dm_carAuto:Result:='';
        dm_car3A:Result:='3';
        dm_car10A:Result:='10';
        else Result:=floattostr(1e-4*Power(10,ord(TDMM6500_CurrentACRange(P))-1));
       end;
   dm_pp_RangeResistance2W:
       case TDMM6500_Resistance2WRange(P) of
        dm_r2rAuto:Result:='';
        else Result:=floattostr(10*Power(10,ord(TDMM6500_Resistance2WRange(P))-1));
       end;
   dm_pp_RangeResistance4W:
       case TDMM6500_Resistance4WRange(P) of
        dm_r4rAuto:Result:='';
        else Result:=floattostr(Power(10,ord(TDMM6500_Resistance4WRange(P))-1));
       end;
   dm_pp_RangeCapacitance:
       case TDMM6500_CapacitanceRange(P) of
        dm_crAuto:Result:='';
        else Result:=floattostr(1e-9*Power(10,ord(TDMM6500_CapacitanceRange(P))-1));
       end;
   else Result:='';
 end;
end;

end.
