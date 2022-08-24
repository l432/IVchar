unit DMM6500_MeasParamShow;

interface

uses
  OlegShowTypes, Classes, DMM6500, StdCtrls, Keitley2450Const, OlegType, SCPI, 
  Controls, Windows, DMM6500_MeasParam, OApproxShow, DMM6500_Const, Forms;


const MarginLeft=10;
      MarginRight=10;
      Marginbetween=5;
      MarginBetweenLST=3;
      MarginTop=20;

type



TDMM6500_ParameterShowBase=class
 private
//  fParamShow:TParameterShowNew;
  fDMM6500:TDMM6500;
  fChanNumber:byte;
  fMeasP:TDMM6500_MeasParameters;
  fHookParameterClick: TSimpleEvent;
 protected
  procedure GetDataFromDevice;virtual;//abstract;
 public
  property HookParameterClick:TSimpleEvent read fHookParameterClick write fHookParameterClick;
  Constructor Create(MeasP:TDMM6500_MeasParameters;DMM6500:TDMM6500;ChanNumber:byte=0);//overload;
  procedure ObjectToSetting;virtual;abstract;
  procedure UpDate;
  function GetBaseVolt:IMeasPar_BaseVolt;
  function GetBaseVoltDC:IMeasPar_BaseVoltDC;
end;


TDMM6500_BoolParameterShow=class(TDMM6500_ParameterShowBase)
 private
  fCB:TCheckBox;
  procedure Click(Sender:TObject);virtual;
  procedure SetValue(Value:Boolean);
  function FuncForObjectToSetting:boolean;
 public
  Constructor Create(CB:TCheckBox;ParametrCaption: string;
           MeasP:TDMM6500_MeasParameters;DMM6500:TDMM6500;ChanNumber:byte=0);//overload;
 destructor Destroy;override;
 procedure ObjectToSetting;override;
end;

TDMM6500_ParameterShow=class(TDMM6500_ParameterShowBase)
 private
  fParamShow:TParameterShowNew;
 protected
  procedure OkClick();virtual;
  procedure SetLimits(LimitV:TLimitValues);overload;
  procedure SetLimits(LowLimit:double=ErResult;HighLimit:double=ErResult);overload;
 public
  destructor Destroy;override;
end;


TDMM6500_StringParameterShow=class(TDMM6500_ParameterShow)
 private
  procedure CreateHeader{(DMM6500: TDMM6500; ChanNumber: Byte)};
  function GetData: integer;
  procedure SetDat(const Value: integer);//virtual;
  function HighForSLFilling:byte;
  function StrForSLFilling(i:byte):string;
  function FuncForObjectToSetting:byte;
 protected
  fSettingsShowSL:TStringList;
  procedure SettingsShowSLFilling();virtual;//abstract;
  procedure SomeAction();virtual;
  procedure OkClick();override;
 public
  property Data:integer read GetData write SetDat;
  Constructor Create(ST:TStaticText;ParametrCaption: string;
           MeasP:TDMM6500_MeasParameters;DMM6500:TDMM6500;ChanNumber:byte=0);overload;
  Constructor Create(ST:TStaticText;LCap:TLabel;ParametrCaption: string;
           MeasP:TDMM6500_MeasParameters;DMM6500:TDMM6500;ChanNumber:byte=0);overload;
  destructor Destroy;override;
  procedure ObjectToSetting;override;
end;


TDMM6500_DoubleParameterShow=class(TDMM6500_ParameterShow)
 private
  function GetData: double;
  procedure SetDat(const Value: double);
  function FuncForObjectToSetting:double;
 protected
  procedure OkClick();override;
 public
  property Data:double read GetData write SetDat;
  Constructor Create(MeasP:TDMM6500_MeasParameters;DMM6500:TDMM6500;ChanNumber:byte;
                      STD:TStaticText;
                      STC:TLabel;
                      ParametrCaption:string;
                      InitValue:double;
                      DN:byte=3);
 procedure ObjectToSetting;override;
end;

TDMM6500_IntegerParameterShow=class(TDMM6500_ParameterShow)
 private
  function GetData: integer;
  procedure SetDat(const Value: integer);
  function FuncForObjectToSetting:integer;
 protected
  procedure OkClick();override;
 public
  property Data:integer read GetData write SetDat;
  Constructor Create(MeasP:TDMM6500_MeasParameters;DMM6500:TDMM6500;ChanNumber:byte;
                      STD:TStaticText;
                      STC:TLabel;
                      ParametrCaption:string;
                      InitValue:integer);
  procedure ObjectToSetting;override;
end;

TDMM6500_MeasurementTypeShow=class(TDMM6500_StringParameterShow)
 private
  fPermitedMeasFunction:array of TKeitley_Measure;
  procedure PermitedMeasFunctionFilling;
  function MeasureToOrd(FM: TKeitley_Measure):ShortInt;
 protected
  procedure OkClick();override;
  procedure SettingsShowSLFilling();override;
  procedure SomeAction();override;
  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;
           DMM6500:TDMM6500;ChanNumber:byte=0);
  procedure ObjectToSetting;override;
end;

TDMM6500_CountShow=class(TDMM6500_IntegerParameterShow)
 private
  fCountType:byte;
 protected
  procedure OkClick();override;
  procedure GetDataFromDevice;override;
  procedure SetCountType(Value:byte);
 public
  property CountType:byte write SetCountType;
  Constructor Create(STD:TStaticText;STC:TLabel;
              DMM6500:TDMM6500;ChanNumber:byte=0);
  {CountType = 0 - Count, else CountDig}
  procedure ObjectToSetting;override;
end;

TDMM6500_DisplayDNShow=class(TDMM6500_StringParameterShow)
 protected
  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
  procedure GetDataFromDevice;override;
//  procedure SomeAction();override;
 public
  Constructor Create(ST:TStaticText;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_AutoDelayShow=class(TDMM6500_BoolParameterShow)
 protected
//  procedure Click(Sender:TObject);override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(CB:TCheckBox;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_AzeroStateShow=class(TDMM6500_BoolParameterShow)
 protected
  procedure Click(Sender:TObject);override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(CB:TCheckBox;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_LineSyncShow=class(TDMM6500_BoolParameterShow)
 protected
//  procedure Click(Sender:TObject);override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(CB:TCheckBox;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_OpenLDShow=class(TDMM6500_BoolParameterShow)
 protected
//  procedure Click(Sender:TObject);override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(CB:TCheckBox;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;


TDMM6500_SampleRateShow=class(TDMM6500_IntegerParameterShow)
 private
 protected
  procedure OkClick();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_VoltageUnitShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure GetDataFromDevice;override;
//  procedure SomeAction();override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_TemperatureUnitShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_DecibelReferenceShow=class(TDMM6500_DoubleParameterShow)
 private
 protected
//  procedure OkClick();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_MeaureTimeShow=class(TDMM6500_DoubleParameterShow)
 private
 protected
//  procedure OkClick();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;


TDMM6500_SimRefTempShow=class(TDMM6500_DoubleParameterShow)
 private
 protected
//  procedure OkClick();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_RTDAlphaShow=class(TDMM6500_DoubleParameterShow)
 private
 protected
//  procedure OkClick();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_RTDBetaShow=class(TDMM6500_DoubleParameterShow)
 private
 protected
//  procedure OkClick();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_RTDDeltaShow=class(TDMM6500_DoubleParameterShow)
 private
 protected
//  procedure OkClick();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_DecibelmWReferenceShow=class(TDMM6500_IntegerParameterShow)
 private
 protected
//  procedure OkClick();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_RTDZeroShow=class(TDMM6500_IntegerParameterShow)
 private
 protected
//  procedure OkClick();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_InputImpedanceShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_ThresholdRangeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_BiasLevelShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_OffCompShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_VoltageRatioMethodShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_TempTransdTypeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

//TDMM6500_TempTypeShow=class(TDMM6500_StringParameterShow)
// protected
// public
//  Constructor Create(ST:TStaticText;L:Tlabel;
//           DMM6500:TDMM6500;ChanNumber:byte=0);
//end;

TDMM6500_TCoupleShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_ThermistorTypeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

//TDMM6500_RTDTypeShow=class(TDMM6500_StringParameterShow)
// protected
//  procedure SettingsShowSLFilling();override;
// public
//end;

TDMM6500_W2RTDTypeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_W3RTDTypeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_W4RTDTypeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_TCoupleRefJunctShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;


//TDMM6500_RangeShow=class(TDMM6500_StringParameterShow)
// protected
////  procedure GetDataFromDevice;override;
// public
//  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
//end;

TDMM6500_VoltageDigRangeShow=class(TDMM6500_StringParameterShow)
 protected
  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_CurrentDigRangeShow=class(TDMM6500_StringParameterShow)
 protected
  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_CapacitanceRangeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_CurrentACRangeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_VoltageACRangeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_CurrentDCRangeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_VoltageDCRangeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_Resistance2WRangeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_Resistance4WRangeShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

TDMM6500_DetectorBandwidthShow=class(TDMM6500_StringParameterShow)
 protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
//  procedure ObjectToSetting;override;
end;

//------------------------------------------------------------------------------

TControlElements=class
 private
  fDMM6500:TDMM6500;
  fParent:TGroupBox;
 protected
  procedure CreateElements;virtual;abstract;
  procedure CreateControls;virtual;abstract;
  procedure DestroyElements;virtual;abstract;
  procedure DestroyControls;virtual;abstract;
  procedure DesignElements;virtual;abstract;
 public
  Constructor Create(GB:TGroupBox;DMM6500:TDMM6500);
  destructor Destroy;override;
end;

TDMM6500_MeasParShow=class(TControlElements)
 private
  fChanNumber:byte;
  fShowElements:array of TDMM6500_ParameterShowBase;
  fWinElements:array of TControl;
  procedure Add(ShowElements:TDMM6500_ParameterShowBase);overload;
  procedure Add(WinElements:TControl);overload;
  procedure ParentToElements;
 protected
  procedure DestroyControls;override;
  procedure DestroyElements;override;
  procedure DesignElements;override;
 public
  Constructor Create(Parent:TGroupBox;DMM6500:TDMM6500;ChanNumber:byte=0);
//  destructor Destroy;override;
  procedure ObjectToSetting;virtual;
  procedure GetDataFromDevice;virtual;
end;

TDMM6500ControlChannels=class(TControlElements)
 private
  fLabels:array of TLabel;
  fST:array of TStaticText;
  fButtons:array of TButton;
  fMeasurementType:array of TDMM6500_MeasurementTypeShow;
  fMeasParChanShowForm:TForm;
  fBOk:TButton;
  fGBParametrChanShow:TGroupBox;
  fMeasParChanShow:TDMM6500_MeasParShow;
  function GetChanCount:byte;
  procedure CreateForm(MeasureType:TKeitley_Measure;ChanNumber:byte);
  procedure FormShow(MeasureType:TKeitley_Measure;ChanNumber:byte);
  procedure OptionButtonClick(Sender: TObject);
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
  procedure DestroyElements;override;
  procedure DestroyControls;override;
 public
  property ChanCount:byte read GetChanCount;
//  Constructor Create(GB:TGroupBox;DMM6500:TDMM6500);
//  destructor Destroy;override;
end;



TDMM6500MeasPar_BaseShow=class(TDMM6500_MeasParShow)
 private
  fCountShow:TDMM6500_CountShow;
  fDisplayDNShow:TDMM6500_DisplayDNShow;
  procedure HookParameterClickCount;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure CountShowCreate;virtual;
  procedure DesignElements;override;

  procedure Resize(Control:TControl);
  procedure ResizeElements;
//  procedure ParentToElements;
 public
  STCount:TStaticText;
  LCount:TLabel;
  STDisplayDN:TStaticText;
  STRange:TStaticText;
end;


TDMM6500MeasPar_BaseDelayShow=class(TDMM6500MeasPar_BaseShow)
 private
  fAutoDelayShow:TDMM6500_AutoDelayShow;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
  CBAutoDelay:TCheckBox;
end;



TDMM6500MeasPar_BaseDigShow=class(TDMM6500MeasPar_BaseShow)
 private
  fSampleRateShow:TDMM6500_SampleRateShow;
  procedure HookParameterClickSampleRate;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
//  STRange:TStaticText;
  STSampleRate:TStaticText;
  LSampleRate:TLabel;
end;

TDMM6500MeasPar_BaseVoltShow=class(TDMM6500_MeasParShow)
 private
  fVoltageUnitShow:TDMM6500_VoltageUnitShow;
  fDecibelReferenceShow:TDMM6500_DecibelReferenceShow;
  fDecibelmWReferenceShow:TDMM6500_DecibelmWReferenceShow;
  procedure CreateControlsVariate;
  procedure DestroyControlsVariant;
  procedure Hook;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
  procedure DestroyControls;override;
 public
  STVoltageUnit:TStaticText;
  LVoltageUnit:TLabel;
  STDB_DBM:TStaticText;
  LDB_DBM:TLabel;
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;


TDMM6500MeasPar_BaseVoltDCShow=class(TDMM6500MeasPar_BaseVoltShow)
 private
  fInputImpedanceShow:TDMM6500_InputImpedanceShow;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
//  procedure DesignElements;override;
 public
  STInputImpedance:TStaticText;
  LInputImpedance:TLabel;
end;

TDMM6500MeasPar_DigVoltShow=class(TDMM6500MeasPar_BaseDigShow)
 private
  fRangeShow:TDMM6500_VoltageDigRangeShow;
  fBaseVoltDCShow:TDMM6500MeasPar_BaseVoltDCShow;
 protected
//  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DestroyControls;override;
  procedure DesignElements;override;
 public
//  STRange:TStaticText;
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TDMM6500MeasPar_DigCurShow=class(TDMM6500MeasPar_BaseDigShow)
 private
  fRangeShow:TDMM6500_CurrentDigRangeShow;
 protected
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
end;

TDMM6500MeasPar_CapacShow=class(TDMM6500MeasPar_BaseDelayShow)
 private
  fRangeShow:TDMM6500_CapacitanceRangeShow;
 protected
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
end;

TDMM6500MeasPar_BaseACShow=class(TDMM6500MeasPar_BaseDelayShow)
 private
  fDetectorBWShow:TDMM6500_DetectorBandwidthShow;
  procedure HookParameterClickDetectorBW;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
  STDetectorBW:TStaticText;
  LDetectorBW:TLabel;
end;

TDMM6500MeasPar_CurACShow=class(TDMM6500MeasPar_BaseACShow)
 private
  fRangeShow:TDMM6500_CurrentACRangeShow;
 protected
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
end;

TDMM6500MeasPar_VoltACShow=class(TDMM6500MeasPar_BaseACShow)
 private
  fRangeShow:TDMM6500_VoltageACRangeShow;
  fBaseVoltShow:TDMM6500MeasPar_BaseVoltShow;
 protected
  procedure CreateControls;override;
  procedure DestroyControls;override;
  procedure DesignElements;override;
 public
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TDMM6500MeasPar_BaseDelayMTShow=class(TDMM6500MeasPar_BaseDelayShow)
 private
  fMeaureTimeShow:TDMM6500_MeaureTimeShow;
  procedure HookParameterClickMeaureTime;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
  STMeaureTime:TStaticText;
  LMeaureTime:TLabel;
end;

TDMM6500MeasPar_FreqPeriodShow=class(TDMM6500MeasPar_BaseDelayMTShow)
 private
  fThresholdRangeShow:TDMM6500_ThresholdRangeShow;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
  STThresholdRange:TStaticText;
  LThresholdRange:TLabel;
end;

TDMM6500MeasPar_ContinuityBaseShow=class(TDMM6500MeasPar_BaseDelayMTShow)
 private
  fLineSyncShow:TDMM6500_LineSyncShow;
  fAzeroShow:TDMM6500_AzeroStateShow;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
  CBAzero:TCheckBox;
  CBLineSync:TCheckBox;
end;

TDMM6500MeasPar_ContinuityShow=class(TDMM6500MeasPar_ContinuityBaseShow)
 protected
  procedure DesignElements;override;
 public
end;

TDMM6500MeasPar_DiodeShow=class(TDMM6500MeasPar_ContinuityBaseShow)
 private
  fBiasLevelShow:TDMM6500_BiasLevelShow;
  procedure HookParameterClickBiasLevel;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
  STBiasLevel:TStaticText;
  LBiasLevel:TLabel;
end;

TDMM6500MeasPar_CurDCShow=class(TDMM6500MeasPar_ContinuityBaseShow)
 private
  fRangeShow:TDMM6500_CurrentDCRangeShow;
 protected
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
end;

TDMM6500MeasPar_BaseVoltDCRangeShow=class(TDMM6500MeasPar_ContinuityBaseShow)
 private
  fRangeShow:TDMM6500_VoltageDCRangeShow;
 protected
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
end;

TDMM6500MeasPar_Res2WShow=class(TDMM6500MeasPar_ContinuityBaseShow)
 private
  fRangeShow:TDMM6500_Resistance2WRangeShow;
 protected
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
end;

TDMM6500MeasPar_Base4WTShow=class(TDMM6500MeasPar_ContinuityBaseShow)
 private
  fOffCompShow:TDMM6500_OffCompShow;
  fOpenLDShow:TDMM6500_OpenLDShow;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
  CBOpenLD:TCheckBox;
  STOffComp:TStaticText;
  LOffComp:TLabel;
end;

TDMM6500MeasPar_Res4WShow=class(TDMM6500MeasPar_Base4WTShow)
 private
  fRangeShow:TDMM6500_Resistance4WRangeShow;
 public
 protected
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
end;

TDMM6500MeasPar_VoltRatShow=class(TDMM6500MeasPar_BaseVoltDCRangeShow)
 private
  fMethodShow:TDMM6500_VoltageRatioMethodShow;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
  STVRMethod:TStaticText;
  LVRMethod:TLabel;
end;

TDMM6500MeasPar_VoltDCShow=class(TDMM6500MeasPar_BaseVoltDCRangeShow)
 private
  fBaseVoltDCShow:TDMM6500MeasPar_BaseVoltDCShow;
 protected
  procedure CreateControls;override;
  procedure DestroyControls;override;
  procedure DesignElements;override;
 public
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TDMM6500MeasPar_TemperShow=class(TDMM6500MeasPar_Base4WTShow)
 private
  fTransdTypeShow:TDMM6500_TempTransdTypeShow;
  fRefJunctionShow:TDMM6500_TCoupleRefJunctShow;
  fRTDAlphaShow:TDMM6500_RTDAlphaShow;
  fRTDBetaShow:TDMM6500_RTDBetaShow;
  fRTDDeltaShow:TDMM6500_RTDDeltaShow;
  fRTDZeroShow:TDMM6500_RTDZeroShow;
  fW2RTDTypeShow:TDMM6500_W2RTDTypeShow;
  fW3RTDTypeShow:TDMM6500_W3RTDTypeShow;
  fW4RTDTypeShow:TDMM6500_W4RTDTypeShow;
  fThermistorTypeShow:TDMM6500_ThermistorTypeShow;
  fTCoupleTypeShow:TDMM6500_TCoupleShow;
  fUnits:TDMM6500_TemperatureUnitShow;
  fSimRefTemp:TDMM6500_SimRefTempShow;
  procedure CreateControlsVariate;
  procedure DestroyControlsVariant;
  procedure Hook;
  procedure HookParameterClickZero;
  procedure HookParameterClickDelta;
  procedure HookParameterClickRefJun_Alpha;
  procedure HookParameterClickRefTemp_Beta;
  procedure HookParameterClickUnits;
  procedure HookParameterClickType;
  procedure SetTypeEnable(Value:boolean);
  procedure SetAlphaBetaEnable(Value:boolean);
  procedure SetDeltaZeroEnable(Value:boolean);
  procedure SetAllRTDEnable(Value:boolean);
  procedure HookParameterClickRTDType;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
  procedure DestroyControls;override;
 public
  STTransdType:TStaticText;
  LTransdType:TLabel;
  STType:TStaticText;
  LType:TLabel;
  STRefTemp_Beta:TStaticText;
  LRefTemp_Beta:TLabel;
  STRefJunc_Alpha:TStaticText;
  LRefJunc_Alpha:TLabel;
  STDelta:TStaticText;
  LDelta:TLabel;
  STZero:TStaticText;
  LZero:TLabel;
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

// 88888888888888888888888888888888888888888888888888888888888888888

function MeasParShowFactory(MeasureType:TKeitley_Measure;
                Parent:TGroupBox;DMM6500:TDMM6500;
                ChanNumber:byte=0):TDMM6500_MeasParShow;

implementation

uses
  SysUtils, Graphics, OlegFunction, FormDMM6500, Dialogs;

function MeasParShowFactory(MeasureType:TKeitley_Measure;
                Parent:TGroupBox;DMM6500:TDMM6500;
                ChanNumber:byte=0):TDMM6500_MeasParShow;
begin
 case MeasureType of
   kt_mCurDC: Result:=TDMM6500MeasPar_CurDCShow.Create(Parent,DMM6500,ChanNumber);
//   kt_mVolDC: Result:=TDMM6500MeasPar_ContinuityBaseShow.Create(Parent,DMM6500,ChanNumber);
   kt_mVolDC: Result:=TDMM6500MeasPar_VoltDCShow.Create(Parent,DMM6500,ChanNumber);
   kt_mRes2W: Result:=TDMM6500MeasPar_Res2WShow.Create(Parent,DMM6500,ChanNumber);
   kt_mCurAC: Result:=TDMM6500MeasPar_CurACShow.Create(Parent,DMM6500,ChanNumber);
   kt_mVolAC: Result:=TDMM6500MeasPar_VoltACShow.Create(Parent,DMM6500,ChanNumber);
   kt_mRes4W: Result:=TDMM6500MeasPar_Res4WShow.Create(Parent,DMM6500,ChanNumber);
   kt_mDiod: Result:=TDMM6500MeasPar_DiodeShow.Create(Parent,DMM6500,ChanNumber);
   kt_mCap: Result:=TDMM6500MeasPar_CapacShow.Create(Parent,DMM6500,ChanNumber);
   kt_mTemp: Result:=TDMM6500MeasPar_TemperShow.Create(Parent,DMM6500,ChanNumber);
   kt_mCont: Result:=TDMM6500MeasPar_ContinuityShow.Create(Parent,DMM6500,ChanNumber);
   kt_mFreq: Result:=TDMM6500MeasPar_FreqPeriodShow.Create(Parent,DMM6500,ChanNumber);
   kt_mPer: Result:=TDMM6500MeasPar_FreqPeriodShow.Create(Parent,DMM6500,ChanNumber);
   kt_mVoltRat: Result:=TDMM6500MeasPar_VoltRatShow.Create(Parent,DMM6500,ChanNumber);
   kt_mDigCur: Result:=TDMM6500MeasPar_DigCurShow.Create(Parent,DMM6500,ChanNumber);
   else Result:=TDMM6500MeasPar_DigVoltShow.Create(Parent,DMM6500,ChanNumber);
 end;
// Result.ObjectToSetting;
end;

{ TDMM6500_StringParameterShow }

constructor TDMM6500_StringParameterShow.Create(ST: TStaticText;
  ParametrCaption: string; MeasP:TDMM6500_MeasParameters;DMM6500: TDMM6500; ChanNumber: byte);
begin
  inherited Create(MeasP,DMM6500,ChanNumber);
  CreateHeader{(DMM6500, ChanNumber)};
  fParamShow:=TStringParameterShow.Create(ST,ParametrCaption,fSettingsShowSL);
//  inherited Create(ST,ParametrCaption,fSettingsShowSL);
  fParamShow.HookParameterClick:=OkClick;
end;

destructor TDMM6500_StringParameterShow.Destroy;
begin
//  fParamShow.HookParameterClick:=nil;
//  fParamShow.Free;
  fSettingsShowSL.Free;
  inherited;
end;

function TDMM6500_StringParameterShow.FuncForObjectToSetting: byte;
begin
 case fMeasP of
   dm_tp_TransdType: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).TransdType);
   dm_tp_RefJunction: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).RefJunction);
   dm_tp_W2RTDType: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).W2RTDType);
   dm_tp_W3RTDType: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).W3RTDType);
   dm_tp_W4RTDType: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).W4RTDType);
   dm_tp_ThermistorType: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).ThermistorType);
   dm_tp_TCoupleType: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).TCoupleType);
   dm_dp_BiasLevel: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Diode).BiasLevel);
   dm_vrp_VRMethod: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_VoltRat).VRMethod);
   dm_pp_OffsetCompen: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Base4WT).OffsetComp);
   dm_pp_DetectorBW: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseAC).DetectorBW);
   dm_pp_InputImpedance: Result:=ord(GetBaseVoltDC.InputImpedance);
   dm_pp_ThresholdRange: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_FreqPeriod).ThresholdRange);
   dm_pp_RangeVoltDC: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseVoltDCRange).Range);
   dm_pp_RangeVoltAC: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_VoltAC).Range);
   dm_pp_RangeCurrentDC: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_CurDC).Range);
   dm_pp_RangeCurrentAC: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_CurAC).Range);
   dm_pp_RangeResistance2W: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Res2W).Range);
   dm_pp_RangeResistance4W: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Res4W).Range);
   dm_pp_RangeCapacitance: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Capac).Range);
   dm_tp_UnitsTemp: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).Units);
   dm_pp_UnitsVolt: Result:=ord(GetBaseVolt.Units);
   dm_pp_ApertureAuto: Result:=fDMM6500.MeasParamByCN(fChanNumber).DisplayDN-3;
   dm_pp_RangeVoltDig: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_DigVolt).Range)-1;
   dm_pp_RangeCurrentDig: Result:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_DigCur).Range)-2;
   else Result:=0;
 end;
end;

function TDMM6500_StringParameterShow.GetData: integer;
begin
 Result:=(fParamShow as TStringParameterShow).Data;
end;

function TDMM6500_StringParameterShow.HighForSLFilling: byte;
begin
 case fMeasP of
   dm_tp_TransdType: Result:=ord(High(TDMM6500_TempTransducer));
   dm_tp_RefJunction: Result:=ord(High(TDMM6500_TCoupleRefJunct));
//   dm_tp_RTDAlpha: Result:=;
//   dm_tp_RTDBeta: Result:=;
//   dm_tp_RTDDelta: Result:=;
//   dm_tp_RTDZero: Result:=;
   dm_tp_W2RTDType,
   dm_tp_W3RTDType,
   dm_tp_W4RTDType: Result:=ord(High(TDMM6500_RTDType));
   dm_tp_ThermistorType: Result:=ord(High(TDMM6500_ThermistorType));
   dm_tp_TCoupleType: Result:=ord(High(TDMM6500_TCoupleType));
//   dm_tp_SimRefTemp: Result:=;
   dm_dp_BiasLevel: Result:=ord(High(TDMM6500_DiodeBiasLevel));
   dm_vrp_VRMethod: Result:=ord(High(TDMM6500_VoltageRatioMethod));
   dm_pp_OffsetCompen: Result:=ord(High(TDMM6500_OffsetCompen));
//   dm_pp_OpenLeadDetector: Result:=;
//   dm_pp_LineSync: Result:=;
//   dm_pp_AzeroState: Result:=;
   dm_pp_DetectorBW: Result:=ord(High(TDMM6500_DetectorBandwidth));
   dm_pp_InputImpedance: Result:=ord(High(TDMM6500_InputImpedance));
//   dm_pp_Units: Result:=;
//   dm_pp_DbmWReference: Result:=;
//   dm_pp_DecibelReference: Result:=;
//   dm_pp_Aperture: Result:=;
//   dm_pp_MeasureTime: Result:=;
//   dm_pp_NPLC: Result:=;
//   dm_pp_SampleRate: Result:=;
//   dm_pp_DelayAuto: Result:=;
//   dm_pp_Range: Result:=;
   dm_pp_ThresholdRange: Result:=ord(High(TDMM6500_VoltageACRange));
   dm_pp_RangeVoltDC: Result:=ord(High(TDMM6500_VoltageDCRange));
   dm_pp_RangeVoltAC: Result:=ord(High(TDMM6500_VoltageACRange));
   dm_pp_RangeCurrentDC: if (fDMM6500.Terminal=kt_otFront)
                           or (fChanNumber>0) then Result:=ord(dm_cdr3A)
                                              else Result:=ord(dm_cdr10A);
   dm_pp_RangeCurrentAC: if (fDMM6500.Terminal=kt_otFront)
                          or (fChanNumber>0) then Result:=ord(dm_car3A)
                                             else Result:=ord(dm_car10A);
   dm_pp_RangeResistance2W: Result:=ord(High(TDMM6500_Resistance2WRange));
   dm_pp_RangeResistance4W: Result:=ord(High(TDMM6500_Resistance4WRange));
   dm_pp_RangeCapacitance: Result:=ord(High(TDMM6500_CapacitanceRange));
   dm_pp_RangeVoltDig:Result:=ord(High(TDMM6500_VoltageDigRange))-1;
   dm_pp_RangeCurrentDig:Result:=ord(High(TDMM6500_CurrentDigRange))-2;
   dm_tp_UnitsTemp: Result:=ord(High(TDMM6500_TempUnits));
   dm_pp_UnitsVolt: Result:=ord(High(TDMM6500_VoltageUnits));
   dm_pp_ApertureAuto: Result:=High(TKeitleyDisplayDigitsNumber)-Low(TKeitleyDisplayDigitsNumber);
   else Result:=0;
 end;


end;

procedure TDMM6500_StringParameterShow.ObjectToSetting;
begin
 Data:=FuncForObjectToSetting;
end;

procedure TDMM6500_StringParameterShow.OkClick;
begin
 fDMM6500.SetShablon(fMeasP,Pointer(Data),fChanNumber);
 inherited;
// fHookParameterClick;
end;

procedure TDMM6500_StringParameterShow.SetDat(const Value: integer);
begin
 (fParamShow as TStringParameterShow).Data:=Value;
end;

procedure TDMM6500_StringParameterShow.SettingsShowSLFilling;
 var i:byte;
begin
 for I := 0 to HighForSLFilling do
    fSettingsShowSL.Add(StrForSLFilling(i));
end;

procedure TDMM6500_StringParameterShow.SomeAction;
begin
end;

function TDMM6500_StringParameterShow.StrForSLFilling(i: byte): string;
begin
 case fMeasP of
   dm_tp_TransdType: Result:=DMM6500_TempTransducerLabel[TDMM6500_TempTransducer(i)];
   dm_tp_RefJunction: Result:=DMM6500_TCoupleRefJunctLabel[TDMM6500_TCoupleRefJunct(i)];
//   dm_tp_RTDAlpha: Result:=;
//   dm_tp_RTDBeta: Result:=;
//   dm_tp_RTDDelta: Result:=;
//   dm_tp_RTDZero: Result:=;
   dm_tp_W2RTDType,
   dm_tp_W3RTDType,
   dm_tp_W4RTDType: Result:=DMM6500_WiRTDTypeLabel[TDMM6500_RTDType(i)];
   dm_tp_ThermistorType: Result:=inttostr(DMM6500_ThermistorTypeValues[TDMM6500_ThermistorType(i)])
                           +DMM6500_ThermistorTypeSyffix;
   dm_tp_TCoupleType: Result:=DMM6500_TCoupleTypeLabel[TDMM6500_TCoupleType(i)];
//   dm_tp_SimRefTemp: Result:=;
   dm_dp_BiasLevel: Result:=DMM6500_DiodeBiasLevelLabel[TDMM6500_DiodeBiasLevel(i)];
   dm_vrp_VRMethod: Result:=DMM6500_VoltageRatioMethodLabel[TDMM6500_VoltageRatioMethod(i)];
   dm_pp_OffsetCompen: Result:=DMM6500_OffsetCompenLabel[TDMM6500_OffsetCompen(i)];
//   dm_pp_OpenLeadDetector: Result:=;
//   dm_pp_LineSync: Result:=;
//   dm_pp_AzeroState: Result:=;
   dm_pp_DetectorBW: Result:=DMM6500_DetectorBandwidthLabel[TDMM6500_DetectorBandwidth(i)];
   dm_pp_InputImpedance: Result:=DMM6500_InputImpedanceLabel[TDMM6500_InputImpedance(i)];
//   dm_pp_Units: Result:=;
//   dm_pp_DbmWReference: Result:=;
//   dm_pp_DecibelReference: Result:=;
//   dm_pp_Aperture: Result:=;
//   dm_pp_MeasureTime: Result:=;
//   dm_pp_NPLC: Result:=;
//   dm_pp_SampleRate: Result:=;
//   dm_pp_DelayAuto: Result:=;
//   dm_pp_Range: Result:=;
   dm_pp_ThresholdRange: Result:=DMM6500_VoltageACRangeLabels[TDMM6500_VoltageACRange(i)];
   dm_pp_RangeVoltDC: Result:=DMM6500_VoltageDCRangeLabels[TDMM6500_VoltageDCRange(i)];
   dm_pp_RangeVoltAC: Result:=DMM6500_VoltageACRangeLabels[TDMM6500_VoltageACRange(i)];
   dm_pp_RangeCurrentDC: Result:=DMM6500_CurrentDCRangeLabels[TDMM6500_CurrentDCRange(i)];
   dm_pp_RangeCurrentAC: Result:=DMM6500_CurrentACRangeLabels[TDMM6500_CurrentACRange(i)];
   dm_pp_RangeResistance2W: Result:=DMM6500_Resistance2WRangeLabels[TDMM6500_Resistance2WRange(i)];
   dm_pp_RangeResistance4W: Result:=DMM6500_Resistance4WRangeLabels[TDMM6500_Resistance4WRange(i)];
   dm_pp_RangeCapacitance: Result:=DMM6500_CapacitanceRangeRangeLabels[TDMM6500_CapacitanceRange(i)];
   dm_pp_RangeVoltDig: Result:=DMM6500_VoltageDCRangeLabels[TDMM6500_VoltageDCRange(i+1)];
   dm_pp_RangeCurrentDig: Result:=DMM6500_CurrentDCRangeLabels[TDMM6500_CurrentDigRange(i+2)];
   dm_tp_UnitsTemp: Result:=DMM6500_TempUnitsLabel[TDMM6500_TempUnits(i)];
   dm_pp_UnitsVolt: Result:=DMM6500_VoltageUnitsLabel[TDMM6500_VoltageUnits(i)];
   dm_pp_ApertureAuto: Result:=inttostr(i+3)+KeitleyDisplayDNLabel;
   else Result:='';
 end;
end;

constructor TDMM6500_StringParameterShow.Create(ST: TStaticText; LCap: TLabel;
  ParametrCaption: string; MeasP:TDMM6500_MeasParameters; DMM6500: TDMM6500; ChanNumber: byte);
begin
  inherited Create(MeasP,DMM6500,ChanNumber);
  CreateHeader{(DMM6500, ChanNumber)};
  fParamShow:=TStringParameterShow.Create(ST,LCap,ParametrCaption,fSettingsShowSL);
//  inherited Create(ST,LCap,ParametrCaption,fSettingsShowSL);
  fParamShow.HookParameterClick:=OkClick;

end;

procedure TDMM6500_StringParameterShow.CreateHeader{DMM6500: TDMM6500; ChanNumber: Byte)};
begin
//  fDMM6500 := DMM6500;
//  fChanNumber := ChanNumber;
  SomeAction();
  fSettingsShowSL := TStringList.Create;
  SettingsShowSLFilling;
end;

{ TDMM6500_MeasurementType }

constructor TDMM6500_MeasurementTypeShow.Create(ST: TStaticText; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create(ST,'MeasureType',dm_pp_ApertureAuto,DMM6500,ChanNumber);
end;


procedure TDMM6500_MeasurementTypeShow.GetDataFromDevice;
begin
 fDMM6500.GetMeasureFunction(fChanNumber);
end;

function TDMM6500_MeasurementTypeShow.MeasureToOrd(FM: TKeitley_Measure): ShortInt;
 var i:byte;
begin
 for I := 0 to High(fPermitedMeasFunction) do
  if fPermitedMeasFunction[i]=FM then
   begin
     Result:=i;
     Exit;
   end;
 Result:=-1;
end;

procedure TDMM6500_MeasurementTypeShow.ObjectToSetting;
begin
 if fChanNumber=0
   then Data:=MeasureToOrd(fDMM6500.MeasureFunction)
   else Data:=MeasureToOrd(fDMM6500.ChansMeasure[fChanNumber-1].MeasureFunction);
end;

procedure TDMM6500_MeasurementTypeShow.OkClick;
begin
  fDMM6500.SetMeasureFunction(fPermitedMeasFunction[Data],fChanNumber);
  fHookParameterClick;
end;

procedure TDMM6500_MeasurementTypeShow.PermitedMeasFunctionFilling;
 var i:TKeitley_Measure;
begin
 for I := Low(TKeitley_Measure) to High(TKeitley_Measure) do
  if fDMM6500.IsPermittedMeasureFuncForChan(i,fChanNumber) then
    begin
      SetLength(fPermitedMeasFunction,High(fPermitedMeasFunction)+2);
      fPermitedMeasFunction[High(fPermitedMeasFunction)]:=i;
    end;
end;

procedure TDMM6500_MeasurementTypeShow.SettingsShowSLFilling;
 var i:byte;
begin
 for I := 0 to High(fPermitedMeasFunction) do
    fSettingsShowSL.Add(Keitley_MeasureLabel[fPermitedMeasFunction[i]]);
end;

procedure TDMM6500_MeasurementTypeShow.SomeAction;
begin
  inherited;
  PermitedMeasFunctionFilling;
end;

{ TControlPanel }

constructor TControlElements.Create(GB: TGroupBox;DMM6500:TDMM6500);
begin
 inherited Create;
 fParent:=GB;
 fDMM6500:=DMM6500;
 CreateElements;
 CreateControls;
// CreateElements;
// CreateControls;
 DesignElements;
end;

//destructor TControlElements.Destroy;
//begin
//  DestroyControls;
//  DestroyElements;
//  inherited;
//end;

{ TControlChannels }

//constructor TDMM6500ControlChannels.Create(GB: TGroupBox; DMM6500: TDMM6500);
//begin
//// fDMM6500:=DMM6500;
//// inherited Create(GB);
// inherited Create(GB,DMM6500);
// fParent.Caption:='Channels'
//end;

procedure TDMM6500ControlChannels.CreateControls;
 var i:Shortint;
begin
 SetLength(fMeasurementType,High(fST)+1);
 for I := 0 to High(fMeasurementType) do
  fMeasurementType[i]:=TDMM6500_MeasurementTypeShow.Create(fST[i],fDMM6500,i+1);
 for I := 0 to High(fButtons) do
  fButtons[i].OnClick:=OptionButtonClick;
end;

procedure TDMM6500ControlChannels.CreateElements;
 var i:Shortint;
begin
 SetLength(fLabels,High(fDMM6500.ChansMeasure)+1);
 SetLength(fST,High(fDMM6500.ChansMeasure)+1);
 SetLength(fButtons,High(fDMM6500.ChansMeasure)+1);
 for I := 0 to High(fLabels) do
  begin
    fLabels[i]:=TLabel.Create(fParent);
//    fLabels[i].Parent:=fParent;
    fST[i]:=TStaticText.Create(fParent);
//    fST[i].Parent:=fParent;
    fButtons[i]:=TButton.Create(fParent);
    fButtons[i].Tag:=i+1;
//    fButtons[i].Parent:=fParent;
//    fButtons[i].Top:=i*5;
//    fButtons[i].Left:=50;
//    fButtons[i].Caption:=(inttostr(i));
  end;
end;

procedure TDMM6500ControlChannels.CreateForm(MeasureType: TKeitley_Measure;
  ChanNumber: byte);
begin
  fMeasParChanShowForm := TForm.Create(Application);
  fMeasParChanShowForm.Position := poMainFormCenter;
  fMeasParChanShowForm.AutoScroll := True;
  fMeasParChanShowForm.BorderIcons := [biSystemMenu];
  fMeasParChanShowForm.ParentFont := True;
  fMeasParChanShowForm.Font.Style := [fsBold];
  fMeasParChanShowForm.Caption := 'Options of '+inttostr(ChanNumber)+' channel';
  fMeasParChanShowForm.Color := clLtGray;

   fBOk:=TButton.Create(fMeasParChanShowForm);
   fBOk.ModalResult:=mrOK;
   fBOk.Caption:='OK';

   fGBParametrChanShow:=TGroupBox.Create(fMeasParChanShowForm);
   fGBParametrChanShow.Width:=200;
   fGBParametrChanShow.Height:=200;
   fGBParametrChanShow.Parent:=fMeasParChanShowForm;

   fMeasParChanShow:=MeasParShowFactory(MeasureType,fGBParametrChanShow,fDMM6500,ChanNumber);
//   if fMeasParChanShow<>nil then fMeasParChanShow.GetDataFromDevice;


   fGBParametrChanShow.Top:=0;
   fGBParametrChanShow.Left:=0;

   fBOk.Parent:=fMeasParChanShowForm;
   fBOk.Left:=round((fGBParametrChanShow.Width-fBOk.Width)/2);
   fBOk.Top:=fGBParametrChanShow.Height+5;

   fMeasParChanShowForm.Width:=fGBParametrChanShow.Width+25;
   fMeasParChanShowForm.Height:=fBOk.Top+fBOk.Height+35;
end;

procedure TDMM6500ControlChannels.DesignElements;
 var i:Shortint;
     j:integer;
begin
 fParent.Caption:='Channels';
 for I := 0 to High(fLabels) do
  begin
   fLabels[i].Parent:=fParent;
   fLabels[i].Caption:='Chan'+IntToStr(i+1);
   fLabels[i].Top:=20+(fLabels[i].Canvas.TextHeight(fLabels[i].Caption)+10)*i;
   fLabels[i].Left:=5;
  end;
 j:=5+fLabels[High(fLabels)].Canvas.TextWidth(fLabels[High(fLabels)].Caption)+10;
 for I := 0 to High(fST) do
  begin
   fST[i].Parent:=fParent;
   fST[i].Top:=fLabels[i].Top;
   fST[i].Left:=j;
  end;
 j:=fST[High(fST)].Left+10+fLabels[High(fLabels)].Canvas.TextWidth('Resistance 4W');
 for I := 0 to High(fButtons) do
  begin
   fButtons[i].Parent:=fParent;
   fButtons[i].Caption:='Options';
   fButtons[i].Top:=fLabels[i].Top-3;
   fButtons[i].Left:=j;
   fButtons[i].Repaint;
  end;

 fParent.Width:=fButtons[High(fButtons)].Left+fButtons[High(fButtons)].Width+5;
 fParent.Height:=fButtons[High(fButtons)].Top+fButtons[High(fButtons)].Height+10;
// fParent.Refresh;
end;

procedure TDMM6500ControlChannels.DestroyControls;
 var i:Shortint;
begin
 for I := 0 to High(fMeasurementType) do
  FreeAndNil(fMeasurementType[i]);
 end;

procedure TDMM6500ControlChannels.DestroyElements;
 var i:Shortint;
begin
 for I := 0 to High(fLabels) do
  begin
    fLabels[i].Free;
    fST[i].Free;
    fButtons[i].Free;
  end;
end;

procedure TDMM6500ControlChannels.FormShow(MeasureType: TKeitley_Measure;
  ChanNumber: byte);
begin
 CreateForm(MeasureType,ChanNumber);

 fMeasParChanShowForm.ShowModal;

 fBOk.Parent:=nil;
 fBOk.Free;

 if fMeasParChanShow<> nil then FreeAndNil(fMeasParChanShow);

 fGBParametrChanShow.Parent:=nil;
 fGBParametrChanShow.Free;

 fMeasParChanShowForm.Hide;
 fMeasParChanShowForm.Release;
end;

function TDMM6500ControlChannels.GetChanCount: byte;
begin
 Result:=High(fLabels)+1;
end;

procedure TDMM6500ControlChannels.OptionButtonClick(Sender: TObject);
begin
 FormShow(fDMM6500.ChansMeasure[(Sender as TButton).Tag-1].MeasureFunction,(Sender as TButton).Tag);
end;

{ TDMM6500_ParameterShow }

//constructor TDMM6500_ParameterShow.Create(DMM6500: TDMM6500; ChanNumber: byte);
//begin
//  fDMM6500 := DMM6500;
//  fChanNumber := ChanNumber;
//end;

destructor TDMM6500_ParameterShow.Destroy;
begin
  fParamShow.HookParameterClick:=nil;
  fParamShow.Free;
  inherited;
end;

procedure TDMM6500_ParameterShow.SetLimits(LimitV: TLimitValues);
begin
 try
// (fParamShow as TLimitedParameterShow).Limits.SetLimits(LowLimit,HighLimit);
 (fParamShow as TLimitedParameterShow).Limits.SetLimits(LimitV[lvMin],LimitV[lvMax]);
 except
 end;
end;

//procedure TDMM6500_ParameterShow.UpDate;
//begin
// GetDataFromDevice;
// ObjectToSetting;
//end;

//{ TDMM6500_LimitedParameterShow }
//
//procedure TDMM6500_LimitedParameterShow.SetLimits(LimitV:TLimitValues);
//begin
//// (fParamShow as TLimitedParameterShow).Limits.SetLimits(LowLimit,HighLimit);
// (fParamShow as TLimitedParameterShow).Limits.SetLimits(LimitV[lvMin],LimitV[lvMax]);
//end;

{ TDMM6500_DoubleParameterShow }

constructor TDMM6500_DoubleParameterShow.Create(MeasP:TDMM6500_MeasParameters;DMM6500: TDMM6500;
  ChanNumber: byte; STD: TStaticText; STC: TLabel; ParametrCaption: string;
  InitValue: double; DN: byte);
begin
  inherited Create(MeasP,DMM6500,ChanNumber);
  fParamShow:=TDoubleParameterShow.Create(STD,STC,ParametrCaption,InitValue,DN);
  fParamShow.HookParameterClick:=OkClick;
end;

function TDMM6500_DoubleParameterShow.FuncForObjectToSetting: double;
begin
  case fMeasP of
    dm_tp_RTDAlpha: Result:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).RTD_Alpha;
    dm_tp_RTDBeta: Result:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).RTD_Beta;
    dm_tp_RTDDelta: Result:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).RTD_Delta;
    dm_tp_SimRefTemp: Result:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).RefTemperature;
    dm_pp_DecibelReference: Result:=GetBaseVolt.DB;
    dm_pp_MeasureTime: Result:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseDelayMT).MeaureTime;
    else Result:=-1;
  end;
end;

function TDMM6500_DoubleParameterShow.GetData: double;
begin
 Result:=(fParamShow as TDoubleParameterShow).Data;
end;

procedure TDMM6500_DoubleParameterShow.ObjectToSetting;
begin
 Data:=FuncForObjectToSetting;
end;

procedure TDMM6500_DoubleParameterShow.OkClick;
 var temp:double;
begin
 temp:=Data;
 fDMM6500.SetShablon(fMeasP,@temp,fChanNumber);
 inherited;
end;

procedure TDMM6500_DoubleParameterShow.SetDat(const Value: double);
begin
 (fParamShow as TDoubleParameterShow).Data:=Value;
end;

{ TDMM6500_IntegerParameterShow }

constructor TDMM6500_IntegerParameterShow.Create(MeasP:TDMM6500_MeasParameters;DMM6500: TDMM6500;
  ChanNumber: byte; STD: TStaticText; STC: TLabel; ParametrCaption: string;
  InitValue: integer);
begin
  inherited Create(MeasP,DMM6500,ChanNumber);
  fParamShow:=TIntegerParameterShow.Create(STD,STC,ParametrCaption,InitValue);
  fParamShow.HookParameterClick:=OkClick;
end;

function TDMM6500_IntegerParameterShow.FuncForObjectToSetting: integer;
begin
 case fMeasP of
   dm_tp_RTDZero: Result:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).RTD_Zero;
   dm_pp_DbmWReference: Result:=GetBaseVolt.DBM;
   dm_pp_SampleRate: Result:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseDig).SampleRate;
   else Result:=-1;
 end;
end;

function TDMM6500_IntegerParameterShow.GetData: integer;
begin
  Result:=(fParamShow as TIntegerParameterShow).Data;
end;

procedure TDMM6500_IntegerParameterShow.ObjectToSetting;
begin
 Data:=FuncForObjectToSetting();
end;

procedure TDMM6500_IntegerParameterShow.OkClick;
 var temp:integer;
begin
 temp:=Data;
 fDMM6500.SetShablon(fMeasP,@temp,fChanNumber);
 inherited;
end;

procedure TDMM6500_IntegerParameterShow.SetDat(const Value: integer);
begin
  (fParamShow as TIntegerParameterShow).Data:=Value;
end;

{ TDMM6500_Count }

constructor TDMM6500_CountShow.Create(STD:TStaticText;STC:TLabel;
              DMM6500:TDMM6500;ChanNumber:byte=0);
begin
 Inherited Create(dm_pp_ApertureAuto,DMM6500,ChanNumber,STD,STC,'Measure Count',1);
 SetCountType(0);
// fCountType:=CountType;
// if fCountType=0 then SetLimits(DMM6500_CountLimits)
//                 else SetLimits(DMM6500_CountDigLimits);

end;

procedure TDMM6500_CountShow.GetDataFromDevice;
begin
 if fCountType=0
  then fDMM6500.GetCount(fChanNumber)
  else fDMM6500.GetCountDig(fChanNumber);
end;

procedure TDMM6500_CountShow.ObjectToSetting;
begin
 if fCountType=0 then
   begin
     if fChanNumber=0
       then Data:=fDMM6500.Count
       else Data:=fDMM6500.ChansMeasure[fChanNumber-1].Count;
   end           else
   begin
     if fChanNumber=0
       then Data:=fDMM6500.CountDig
       else Data:=fDMM6500.ChansMeasure[fChanNumber-1].CountDig;
   end;
end;

procedure TDMM6500_CountShow.OkClick;
begin
// if fCountType=0
//  then fDMM6500.SetCount(Data,fChanNumber)
//  else fDMM6500.SetCountDig(Data,fChanNumber);

if fCountType=0 then
   begin
     if fChanNumber=0
       then fDMM6500.SetCount(Data)
       else fDMM6500.SetCount(Data,fChanNumber);
   end           else
   fDMM6500.SetCountDig(Data,fChanNumber);
//   begin
//     if fChanNumber=0
//       then Data:=fDMM6500.CountDig
//       else Data:=fDMM6500.ChansMeasure[fChanNumber-1].CountDig;
//   end;

 fHookParameterClick;
end;

procedure TDMM6500_CountShow.SetCountType(Value: byte);
begin
 fCountType:=Value;
 if fCountType=0 then SetLimits(DMM6500_CountLimits)
                 else SetLimits(DMM6500_CountDigLimits);
end;

{ TDMM6500_DisplayDNShow }

constructor TDMM6500_DisplayDNShow.Create(ST: TStaticText; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create(ST,'DisplayDN',dm_pp_ApertureAuto,DMM6500,ChanNumber);
end;

procedure TDMM6500_DisplayDNShow.GetDataFromDevice;
begin
 fDMM6500.GetDisplayDigitsNumber(fChanNumber);
end;

//procedure TDMM6500_DisplayDNShow.ObjectToSetting;
//begin
// Data:=fDMM6500.MeasParamByCN(fChanNumber).DisplayDN-3;
//end;

procedure TDMM6500_DisplayDNShow.OkClick;
begin
 fDMM6500.SetDisplayDigitsNumber(3+Data,fChanNumber);
 fHookParameterClick;
end;

//procedure TDMM6500_DisplayDNShow.SettingsShowSLFilling;
// var i:byte;
//begin
// for I := Low(TKeitleyDisplayDigitsNumber) to High(TKeitleyDisplayDigitsNumber) do
//    fSettingsShowSL.Add(inttostr(i)+KeitleyDisplayDNLabel);
//end;

{ TDMM6500_MeasParShow }

//constructor TDMM6500_MeasParShow.Create(Parent: TWinControl;DMM6500:TDMM6500);
//begin
// inherited Create;
// fParent:=Parent;
// fDMM6500:=DMM6500;
// CreateElements;
// CreateControls;
//end;

//destructor TDMM6500_MeasParShow.Destroy;
//begin
//  DestroyControls;
//  DestroyElements;
//  inherited;
//end;

{ TDMM6500MeasPar_BaseShow }

procedure TDMM6500MeasPar_BaseShow.CountShowCreate;
begin
 fCountShow:=TDMM6500_CountShow.Create(STCount,LCount,fDMM6500,fChanNumber);
end;

procedure TDMM6500MeasPar_BaseShow.CreateControls;
begin
 fDisplayDNShow:=TDMM6500_DisplayDNShow.Create(STDisplayDN,fDMM6500,fChanNumber);
 CountShowCreate;
 Add(fDisplayDNShow);
 Add(fCountShow);
 fCountShow.HookParameterClick:=HookParameterClickCount;
end;

procedure TDMM6500MeasPar_BaseShow.CreateElements;
begin
  STCount:=TStaticText.Create(fParent);
//  STCount.Parent:=fParent;
  Add(STCount);
  LCount:=TLabel.Create(fParent);
//  LCount.Parent:=fParent;
  Add(LCount);
  STDisplayDN:=TStaticText.Create(fParent);
//  STDisplayDN.Parent:=fParent;
  Add(STDisplayDN);
  STRange:=TStaticText.Create(fParent);
  Add(STRange);

//  STCount:=TStaticText.Create(fParent);
//  LCount:=TLabel.Create(fParent);
//  STDisplayDN:=TStaticText.Create(fParent);
//  STCount.Parent:=fParent;
//  LCount.Parent:=fParent;
//  STDisplayDN.Parent:=fParent;
//  Add(STCount);
//  Add(LCount);
//  Add(STDisplayDN);
end;

procedure TDMM6500MeasPar_BaseShow.DesignElements;
begin
  inherited DesignElements;
//  LCount.Parent:=fParent;
//  STDisplayDN.Parent:=fParent;
//  STCount.Parent:=fParent;
//  ParentToElements;
  ResizeElements;

  STCount.Font.Color:=clGreen;
  LCount.Font.Color:=clGreen;

 STDisplayDN.Top:=MarginTop;
 STDisplayDN.Left:=MarginLeft;
 RelativeLocation(STDisplayDN,LCount,oCol,Marginbetween);
 LCount.Left:=MarginLeft;
// RelativeLocation(LCount,STCount,oCol,MarginBetweenLST);
 HookParameterClickCount;

end;

procedure TDMM6500MeasPar_BaseShow.HookParameterClickCount;
begin
 RelativeLocation(LCount,STCount,oCol,MarginBetweenLST);
end;

//procedure TDMM6500MeasPar_BaseShow.ParentToElements;
// var i:integer;
//begin
// for I := 0 to High(fWinElements)
//   do fWinElements[i].Parent:=fParent;
//end;

procedure TDMM6500MeasPar_BaseShow.Resize(Control: TControl);
begin
 if (Control is TLabel) then
  begin
    Control.Width:=LCount.Canvas.TextWidth((Control as TLabel).Caption);
    Control.Height:=LCount.Canvas.TextHeight((Control as TLabel).Caption);
    Exit;
  end;
 if (Control is TCheckBox) then
  begin
    Control.Width:=LCount.Canvas.TextWidth((Control as TCheckBox).Caption)+17;
    Exit;
  end;
end;

procedure TDMM6500MeasPar_BaseShow.ResizeElements;
 var i:integer;
begin
 for I := 0 to High(fWinElements)
   do Resize(fWinElements[i]);
end;

{ TDMM6500_MeasParChanShow }

destructor TControlElements.Destroy;
begin
  DestroyControls;
  DestroyElements;
  inherited;
end;

{ TDMM6500_MeasParShow }

procedure TDMM6500_MeasParShow.Add(ShowElements: TDMM6500_ParameterShowBase);
begin
 SetLength(fShowElements,High(fShowElements)+2);
 fShowElements[High(fShowElements)]:=ShowElements;
end;

procedure TDMM6500_MeasParShow.Add(WinElements: TControl);
begin
 SetLength(fWinElements,High(fWinElements)+2);
 fWinElements[High(fWinElements)]:=WinElements;
end;

constructor TDMM6500_MeasParShow.Create(Parent: TGroupBox; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
  fChanNumber:=ChanNumber;
  inherited Create(Parent,DMM6500);
  ObjectToSetting;
end;

//procedure TDMM6500_MeasParShow.CreateAndAddElement(Element: TControl;ET:TDMM6500_ControlElementType);
//begin
//// case ET of
////   dm_cetST:Element:=TStaticText.Create(fParent);
////   dm_cetL:Element:=TLabel.Create(fParent);
////   dm_cetCB:Element:=TCheckBox.Create(fParent);
//// end;
//
//
//// if (Element is TStaticText) then
////     begin
////     Element:=TStaticText.Create(fParent);
////     (Element as TStaticText).Parent:=fParent;
////     end;
//// if (Element is TLabel) then
////     begin
////     Element:=TLabel.Create(fParent);
////     (Element as TLabel).Parent:=fParent;
////     end;
//// if (Element is TCheckBox) then
////   begin
////   Element:=TCheckBox.Create(fParent);
////   (Element as TCheckBox).Parent:=fParent;
////   end;
// Element.Parent:=fParent;
// Add(Element);
//end;

//procedure TDMM6500_MeasParShow.DesignElements;
// var i:integer;
//begin
// for i := 0 to High(fWinElements) do
//  fWinElements[i].Parent:=fParent;
//end;

procedure TDMM6500_MeasParShow.DesignElements;
begin
 ParentToElements;
end;

procedure TDMM6500_MeasParShow.DestroyControls;
 var i:integer;
begin
 for i := 0 to High(fShowElements) do
  if fShowElements[i]<>nil then
    FreeAndNil(fShowElements[i])
end;

procedure TDMM6500_MeasParShow.DestroyElements;
 var i:integer;
begin
 for i := 0 to High(fWinElements) do
  fWinElements[i].Free;
end;

procedure TDMM6500_MeasParShow.GetDataFromDevice;
 var i:integer;
begin
 for i := 0 to High(fShowElements) do
   fShowElements[i].GetDataFromDevice;
end;

procedure TDMM6500_MeasParShow.ObjectToSetting;
 var i:integer;
begin
 for i := 0 to High(fShowElements) do
   fShowElements[i].ObjectToSetting;
end;

procedure TDMM6500_MeasParShow.ParentToElements;
 var i:integer;
begin
 for I := 0 to High(fWinElements)
   do fWinElements[i].Parent:=fParent;
end;

{ TDMM6500_ParameterShowBase }

constructor TDMM6500_ParameterShowBase.Create(MeasP:TDMM6500_MeasParameters;DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create;
  fMeasP:=MeasP;
  fDMM6500 := DMM6500;
  fChanNumber := ChanNumber;
  fHookParameterClick:=TSimpleClass.EmptyProcedure;
end;

function TDMM6500_ParameterShowBase.GetBaseVolt: IMeasPar_BaseVolt;
begin
 Result:=fDMM6500.GetMeasPar_BaseVolt(fDMM6500.MeasFuncByCN(fChanNumber),
                        fDMM6500.MeasParamByCN(fChanNumber));
end;

function TDMM6500_ParameterShowBase.GetBaseVoltDC: IMeasPar_BaseVoltDC;
begin
 Result:=fDMM6500.GetMeasPar_BaseVoltDC(fDMM6500.MeasFuncByCN(fChanNumber),
                        fDMM6500.MeasParamByCN(fChanNumber));
end;

procedure TDMM6500_ParameterShowBase.GetDataFromDevice;
begin
 fDMM6500.GetShablon(fMeasP,fChanNumber);
end;

procedure TDMM6500_ParameterShowBase.UpDate;
begin
 GetDataFromDevice;
 ObjectToSetting;
end;

{ TDMM6500_BoolParameterShow }

procedure TDMM6500_BoolParameterShow.Click(Sender: TObject);
   var temp:bool;
begin
 temp:=fCB.Checked;
 fDMM6500.SetShablon(fMeasP,@temp,fChanNumber);
 fHookParameterClick;
end;

constructor TDMM6500_BoolParameterShow.Create(CB: TCheckBox;
  ParametrCaption: string; MeasP:TDMM6500_MeasParameters;DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(MeasP,DMM6500,ChanNumber);
 fCB:=CB;
 fCB.OnClick:=Click;
 fCB.Caption:=ParametrCaption;
 fCB.WordWrap:=False;
end;

destructor TDMM6500_BoolParameterShow.Destroy;
begin
  fCB.OnClick:=nil;
  inherited;
end;

function TDMM6500_BoolParameterShow.FuncForObjectToSetting: boolean;
begin
 case fMeasP of
   dm_pp_OpenLeadDetector: Result:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Base4WT).OpenLeadDetector;
   dm_pp_LineSync: Result:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Continuity).LineSync;
   dm_pp_DetectorBW: Result:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Continuity).AzeroState;
   dm_pp_DelayAuto: Result:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseDelay).AutoDelay;
   else Result:=False;
 end;
end;

procedure TDMM6500_BoolParameterShow.ObjectToSetting;
begin
 SetValue(FuncForObjectToSetting);
end;

procedure TDMM6500_BoolParameterShow.SetValue(Value: Boolean);
begin
 AccurateCheckBoxCheckedChange(fCB,Value);
end;

{ TDMM6500_AutoDelayShow }

//procedure TDMM6500_AutoDelayShow.Click(Sender: TObject);
//// var temp:bool;
//begin
//// temp:=fCB.Checked;
//// fDMM6500.SetShablon(dm_pp_DelayAuto,@temp,fChanNumber);
// fDMM6500.SetDelayAuto(fCB.Checked,fChanNumber);
// inherited;
//end;

constructor TDMM6500_AutoDelayShow.Create(CB: TCheckBox; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create(CB,'Auto Delay',dm_pp_DelayAuto,DMM6500,ChanNumber);
end;

//procedure TDMM6500_AutoDelayShow.GetDataFromDevice;
//begin
// fDMM6500.GetDelayAuto(fChanNumber);
//end;

//procedure TDMM6500_AutoDelayShow.ObjectToSetting;
//begin
// SetValue((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseDelay).AutoDelay);
//end;

{ TDMM6500MeasPar_BaseDelayShow }

procedure TDMM6500MeasPar_BaseDelayShow.CreateControls;
begin
  inherited CreateControls;
  fAutoDelayShow:=TDMM6500_AutoDelayShow.Create(CBAutoDelay,fDMM6500,fChanNumber);
  Add(fAutoDelayShow);
end;

procedure TDMM6500MeasPar_BaseDelayShow.CreateElements;
begin
  inherited CreateElements;
  CBAutoDelay:=TCheckBox.Create(fParent);
//  CBAutoDelay.Parent:=fParent;
  Add(CBAutoDelay);
//  CBAutoDelay:=TCheckBox.Create(fParent);
//  CBAutoDelay.Parent:=fParent;
//  Add(CBAutoDelay);
end;


procedure TDMM6500MeasPar_BaseDelayShow.DesignElements;
begin
 inherited DesignElements;
 RelativeLocation(STDisplayDN,CBAutoDelay,oRow,Marginbetween);
 RelativeLocation(CBAutoDelay,STRange,oRow,Marginbetween);
 CBAutoDelay.Top:=CBAutoDelay.Top-2;
 STRange.Font.Color:=clNavy;
end;

procedure TDMM6500_ParameterShow.OkClick;
begin
 fHookParameterClick;
end;

procedure TDMM6500_ParameterShow.SetLimits(LowLimit, HighLimit: double);
begin
 try
 (fParamShow as TLimitedParameterShow).Limits.SetLimits(LowLimit,HighLimit);
 except
 end;
end;

{ TDMM6500_SampleRate }

constructor TDMM6500_SampleRateShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_pp_SampleRate,DMM6500,ChanNumber,STD,STC,'Sample Rate',1000);
 SetLimits(1000,1000000);
end;

//procedure TDMM6500_SampleRateShow.GetDataFromDevice;
//begin
// fDMM6500.GetSampleRate(fChanNumber);
//end;

//procedure TDMM6500_SampleRateShow.ObjectToSetting;
//begin
// Data:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseDig).SampleRate;
//end;

procedure TDMM6500_SampleRateShow.OkClick;
begin
 fDMM6500.SetSampleRate(TDMM6500_DigSampleRate(Data),fChanNumber);
end;

{ TDMM6500MeasPar_BaseDigShow }

procedure TDMM6500MeasPar_BaseDigShow.CreateControls;
begin
  inherited CreateControls;
  fCountShow.CountType:=1;
  fSampleRateShow:=TDMM6500_SampleRateShow.Create(STSampleRate,LSampleRate,fDMM6500,fChanNumber);
  Add(fSampleRateShow);
  fSampleRateShow.HookParameterClick:=HookParameterClickSampleRate;
end;

procedure TDMM6500MeasPar_BaseDigShow.CreateElements;
begin
 inherited CreateElements;
  STSampleRate:=TStaticText.Create(fParent);
//  STSampleRate.Parent:=fParent;
  Add(STSampleRate);
  LSampleRate:=TLabel.Create(fParent);
//  LSampleRate.Parent:=fParent;
  Add(LSampleRate);
//  STRange:=TStaticText.Create(fParent);
//  Add(STRange);
end;

procedure TDMM6500MeasPar_BaseDigShow.DesignElements;
begin
  inherited DesignElements;
  STSampleRate.Font.Color:=clRed;
  LSampleRate.Font.Color:=clRed;
  RelativeLocation(LCount,LSampleRate,oRow,Marginbetween);
  HookParameterClickSampleRate;
//  RelativeLocation(LSampleRate,STSampleRate,oCol,MarginBetweenLST);
 RelativeLocation(STDisplayDN,STRange,oRow,Marginbetween);
 STRange.Font.Color:=clNavy;

end;

procedure TDMM6500MeasPar_BaseDigShow.HookParameterClickSampleRate;
begin
 RelativeLocation(LSampleRate,STSampleRate,oCol,MarginBetweenLST);
end;

{ TDMM6500_VoltageUnitShow }

constructor TDMM6500_VoltageUnitShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Unit:',dm_pp_UnitsVolt,DMM6500,ChanNumber);
end;

//procedure TDMM6500_VoltageUnitShow.GetDataFromDevice;
//begin
// fDMM6500.GetUnits(fChanNumber);
//end;

//procedure TDMM6500_VoltageUnitShow.ObjectToSetting;
//begin
// Data:=ord(GetBaseVolt.Units);
//end;

//procedure TDMM6500_VoltageUnitShow.OkClick;
//begin
// fDMM6500.SetUnits(TDMM6500_VoltageUnits(Data),fChanNumber);
// inherited;
//end;

//procedure TDMM6500_VoltageUnitShow.SettingsShowSLFilling;
// var i:TDMM6500_VoltageUnits;
//begin
// for I := Low(TDMM6500_VoltageUnits) to High(TDMM6500_VoltageUnits) do
//    fSettingsShowSL.Add(DMM6500_VoltageUnitsLabel[i]);
//end;

{ TDMM6500_DBShow }

constructor TDMM6500_DecibelReferenceShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_pp_DecibelReference,DMM6500,ChanNumber,STD,STC,'Ref. Value, V',1);
 STC.WordWrap:=False;
 SetLimits(GetBaseVolt.DBLimits);
end;

//procedure TDMM6500_DecibelReferenceShow.GetDataFromDevice;
//begin
// fDMM6500.GetDecibelReference(fChanNumber);
//end;

//procedure TDMM6500_DecibelReferenceShow.ObjectToSetting;
//begin
//  Data:=GetBaseVolt.DB;
//end;

//procedure TDMM6500_DecibelReferenceShow.OkClick;
//// var temp:double;
//begin
//// temp:=Data;
//// fDMM6500.SetShablon(dm_pp_DecibelReference,@temp,fChanNumber);
// fDMM6500.SetDecibelReference(Data,fChanNumber);
//end;

{ TDMM6500_DecibelmWReferenceShow }

constructor TDMM6500_DecibelmWReferenceShow.Create(STD: TStaticText;
  STC: TLabel; DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_pp_DbmWReference,DMM6500,ChanNumber,STD,STC,'Ref. Value',1);
 STC.WordWrap:=False;
 SetLimits(GetBaseVolt.DBMLimits);
end;

//procedure TDMM6500_DecibelmWReferenceShow.GetDataFromDevice;
//begin
//  fDMM6500.GetDbmWReference(fChanNumber);
//end;

//procedure TDMM6500_DecibelmWReferenceShow.ObjectToSetting;
//begin
//  Data:=GetBaseVolt.DBM;
//end;

//procedure TDMM6500_DecibelmWReferenceShow.OkClick;
//// var temp:integer;
//begin
//// temp:=Data;
//// fDMM6500.SetShablon(dm_pp_DbmWReference,@temp,fChanNumber);
// fDMM6500.SetDbmWReference(Data,fChanNumber);
//end;

{ TDMM6500MeasPar_BaseVoltShow }

procedure TDMM6500MeasPar_BaseVoltShow.CreateControls;
begin
 fVoltageUnitShow:=TDMM6500_VoltageUnitShow.Create(STVoltageUnit,LVoltageUnit,fDMM6500,fChanNumber);
 Add(fVoltageUnitShow);
 fVoltageUnitShow.HookParameterClick:=Hook;
 CreateControlsVariate;
end;

procedure TDMM6500MeasPar_BaseVoltShow.CreateElements;
begin
//  inherited CreateElements;
  STVoltageUnit:=TStaticText.Create(fParent);
//  STVoltageUnit.Parent:=fParent;
  Add(STVoltageUnit);
  LVoltageUnit:=TLabel.Create(fParent);
//  LVoltageUnit.Parent:=fParent;
  Add(LVoltageUnit);
  STDB_DBM:=TStaticText.Create(fParent);
//  STDB_DBM.Parent:=fParent;
  Add(STDB_DBM);
  LDB_DBM:=TLabel.Create(fParent);
//  LDB_DBM.Parent:=fParent;
//  LDB_DBM.WordWrap:=True;
  LDB_DBM.Caption:='Ref. Value, V';

  Add(LDB_DBM);
end;

procedure TDMM6500MeasPar_BaseVoltShow.DesignElements;
begin
  inherited DesignElements;
//  STDB_DBM.Visible:=True;
//  LDB_DBM.Visible:=True;

  case fVoltageUnitShow.GetBaseVolt.Units of
    dm_vuVolt:begin
               STDB_DBM.Enabled:=False;
               LDB_DBM.Enabled:=False;
              end;
    else      begin
               STDB_DBM.Enabled:=True;
               LDB_DBM.Enabled:=True;
              end;
  end;
end;

procedure TDMM6500MeasPar_BaseVoltShow.DestroyControls;
begin
  inherited DestroyControls;
  DestroyControlsVariant;
end;

procedure TDMM6500MeasPar_BaseVoltShow.DestroyControlsVariant;
begin
  if fDecibelReferenceShow <> nil then
    FreeAndNil(fDecibelReferenceShow);
  if fDecibelmWReferenceShow <> nil then
    FreeAndNil(fDecibelmWReferenceShow);
end;

procedure TDMM6500MeasPar_BaseVoltShow.GetDataFromDevice;
begin
 inherited;
 fDMM6500.GetDecibelReference(fChanNumber);
 fDMM6500.GetDbmWReference(fChanNumber);
//  if fDecibelReferenceShow <> nil then
//    fDecibelReferenceShow.GetDataFromDevice;
//  if fDecibelmWReferenceShow <> nil then
//    fDecibelmWReferenceShow.GetDataFromDevice;
end;

procedure TDMM6500MeasPar_BaseVoltShow.Hook;
begin
 CreateControlsVariate;
 DesignElements;
end;

procedure TDMM6500MeasPar_BaseVoltShow.ObjectToSetting;
begin
 inherited ObjectToSetting;
  if fDecibelReferenceShow <> nil then
    fDecibelReferenceShow.ObjectToSetting;
  if fDecibelmWReferenceShow <> nil then
    fDecibelmWReferenceShow.ObjectToSetting;
end;

procedure TDMM6500MeasPar_BaseVoltShow.CreateControlsVariate;
begin
  case fVoltageUnitShow.GetBaseVolt.Units of
    dm_vuVolt:DestroyControlsVariant;
    dm_vuDB:begin
            if fDecibelmWReferenceShow <> nil then
                FreeAndNil(fDecibelmWReferenceShow);
            if fDecibelReferenceShow=nil then
               begin
               fDecibelReferenceShow:=TDMM6500_DecibelReferenceShow.Create(STDB_DBM,LDB_DBM,fDMM6500,fChanNumber);
               fDecibelReferenceShow.ObjectToSetting;
               end;
            end;
    dm_vuDBM:begin
            if fDecibelReferenceShow <> nil then
                FreeAndNil(fDecibelReferenceShow);
            if fDecibelmWReferenceShow=nil then
               begin
               fDecibelmWReferenceShow:=TDMM6500_DecibelmWReferenceShow.Create(STDB_DBM,LDB_DBM,fDMM6500,fChanNumber);
               fDecibelmWReferenceShow.ObjectToSetting;
               end;
             end;
  end;
end;

{ TDMM6500_InputImpedanceShow }

constructor TDMM6500_InputImpedanceShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Input Impedance:',dm_pp_InputImpedance,DMM6500,ChanNumber);
end;

//procedure TDMM6500_InputImpedanceShow.GetDataFromDevice;
//begin
// fDMM6500.GetInputImpedance(fChanNumber);
//end;

//procedure TDMM6500_InputImpedanceShow.ObjectToSetting;
//begin
// Data:=ord(GetBaseVoltDC.InputImpedance);
//end;

//procedure TDMM6500_InputImpedanceShow.OkClick;
//begin
// fDMM6500.SetInputImpedance(TDMM6500_InputImpedance(Data),fChanNumber);
//end;

//procedure TDMM6500_InputImpedanceShow.SettingsShowSLFilling;
// var i:TDMM6500_InputImpedance;
//begin
// for I := Low(TDMM6500_InputImpedance) to High(TDMM6500_InputImpedance) do
//    fSettingsShowSL.Add(DMM6500_InputImpedanceLabel[i]);
//end;

{ TDMM6500MeasPar_BaseVoltDCShow }

procedure TDMM6500MeasPar_BaseVoltDCShow.CreateControls;
begin
 inherited;
 fInputImpedanceShow:=TDMM6500_InputImpedanceShow.Create(STInputImpedance,LInputImpedance,fDMM6500,fChanNumber);
 LInputImpedance.WordWrap:=False;
 Add(fInputImpedanceShow);
end;

procedure TDMM6500MeasPar_BaseVoltDCShow.CreateElements;
begin
 inherited CreateElements;
  STInputImpedance:=TStaticText.Create(fParent);
  Add(STInputImpedance);
  LInputImpedance:=TLabel.Create(fParent);
  Add(LInputImpedance);
end;

{ TDMM6500_RangeShow }

//constructor TDMM6500_RangeShow.Create(ST: TStaticText; DMM6500: TDMM6500;
//  ChanNumber: byte);
//begin
// inherited Create(St,'Range',dm_pp_Range,DMM6500,ChanNumber);
//end;

//procedure TDMM6500_RangeShow.GetDataFromDevice;
//begin
// fDMM6500.GetRange(fChanNumber);
//end;

{ TDMM6500_VoltageDigRangeShow }

constructor TDMM6500_VoltageDigRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeVoltDig,DMM6500,ChanNumber);
end;

//procedure TDMM6500_VoltageDigRangeShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_DigVolt).Range)-1;
//end;

procedure TDMM6500_VoltageDigRangeShow.OkClick;
begin
 fDMM6500.SetRange(TDMM6500_VoltageDigRange(Data+1),fChanNumber);
end;

//procedure TDMM6500_VoltageDigRangeShow.SettingsShowSLFilling;
// var i:TDMM6500_VoltageDigRange;
//begin
// for I := Low(TDMM6500_VoltageDigRange) to High(TDMM6500_VoltageDigRange) do
//    fSettingsShowSL.Add(DMM6500_VoltageDCRangeLabels[i]);
//end;

{ TDMM6500_CurrentDigRangeShow }

constructor TDMM6500_CurrentDigRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeCurrentDig,DMM6500,ChanNumber);
end;

//procedure TDMM6500_CurrentDigRangeShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_DigCur).Range)-2;
//end;

procedure TDMM6500_CurrentDigRangeShow.OkClick;
begin
 fDMM6500.SetRange(TDMM6500_CurrentDigRange(Data+2),fChanNumber);
end;

//procedure TDMM6500_CurrentDigRangeShow.SettingsShowSLFilling;
// var i:TDMM6500_CurrentDigRange;
//begin
// for I := Low(TDMM6500_CurrentDigRange) to High(TDMM6500_CurrentDigRange) do
//    fSettingsShowSL.Add(DMM6500_CurrentDCRangeLabels[i]);
//end;

{ TDMM6500_CapacitanceRangeShow }

constructor TDMM6500_CapacitanceRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeCapacitance,DMM6500,ChanNumber);
end;

//procedure TDMM6500_CapacitanceRangeShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Capac).Range);
//end;

//procedure TDMM6500_CapacitanceRangeShow.OkClick;
//begin
// fDMM6500.SetRange(TDMM6500_CapacitanceRange(Data),fChanNumber);
//end;

//procedure TDMM6500_CapacitanceRangeShow.SettingsShowSLFilling;
// var i:TDMM6500_CapacitanceRange;
//begin
// for I := Low(TDMM6500_CapacitanceRange) to High(TDMM6500_CapacitanceRange) do
//    fSettingsShowSL.Add(DMM6500_CapacitanceRangeRangeLabels[i]);
//end;

{ TDMM6500_CurrentACRangeShow }

constructor TDMM6500_CurrentACRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeCurrentAC,DMM6500,ChanNumber);
end;

//procedure TDMM6500_CurrentACRangeShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_CurAC).Range);
//end;

//procedure TDMM6500_CurrentACRangeShow.OkClick;
//begin
// fDMM6500.SetRange(TDMM6500_CurrentACRange(Data),fChanNumber);
//end;

//procedure TDMM6500_CurrentACRangeShow.SettingsShowSLFilling;
// var i,Maxi:TDMM6500_CurrentACRange;
//begin
// if (fDMM6500.Terminal=kt_otFront)
//     or (fChanNumber>0) then Maxi:=dm_car3A
//                        else Maxi:=dm_car10A;
// for I := dm_carAuto to Maxi do
//    fSettingsShowSL.Add(DMM6500_CurrentACRangeLabels[i]);
//end;

{ TDMM6500_VoltageACRangeShow }

constructor TDMM6500_VoltageACRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeVoltAC,DMM6500,ChanNumber);
end;

//procedure TDMM6500_VoltageACRangeShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_VoltAC).Range);
//end;

//procedure TDMM6500_VoltageACRangeShow.OkClick;
//begin
// fDMM6500.SetRange(TDMM6500_VoltageACRange(Data),fChanNumber);
//end;

//procedure TDMM6500_VoltageACRangeShow.SettingsShowSLFilling;
// var i:TDMM6500_VoltageACRange;
//begin
// for I := Low(TDMM6500_VoltageACRange) to High(TDMM6500_VoltageACRange) do
//    fSettingsShowSL.Add(DMM6500_VoltageACRangeLabels[i]);
//end;

{ TDMM6500_CurrentDCRangeShow }

constructor TDMM6500_CurrentDCRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeCurrentDC,DMM6500,ChanNumber);
end;

//procedure TDMM6500_CurrentDCRangeShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_CurDC).Range);
//end;

//procedure TDMM6500_CurrentDCRangeShow.OkClick;
//begin
// fDMM6500.SetRange(TDMM6500_CurrentDCRange(Data),fChanNumber);
//end;

//procedure TDMM6500_CurrentDCRangeShow.SettingsShowSLFilling;
// var i,Maxi:TDMM6500_CurrentDCRange;
//begin
// if (fDMM6500.Terminal=kt_otFront)
//     or (fChanNumber>0) then Maxi:=dm_cdr3A
//                        else Maxi:=dm_cdr10A;
// for I := dm_cdrAuto to Maxi do
//    fSettingsShowSL.Add(DMM6500_CurrentDCRangeLabels[i]);
//// for I := Low(TDMM6500_CurrentDCRange) to High(TDMM6500_CurrentDCRange) do
////    fSettingsShowSL.Add(DMM6500_CurrentDCRangeLabels[i]);
//end;

{ TDMM6500_VoltageDCRangeShow }

constructor TDMM6500_VoltageDCRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeVoltDC,DMM6500,ChanNumber);
end;

//procedure TDMM6500_VoltageDCRangeShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseVoltDCRange).Range);
//end;

//procedure TDMM6500_VoltageDCRangeShow.OkClick;
//begin
// fDMM6500.SetRange(TDMM6500_VoltageDCRange(Data),fChanNumber);
//end;

//procedure TDMM6500_VoltageDCRangeShow.SettingsShowSLFilling;
// var i:TDMM6500_VoltageDCRange;
//begin
// for I := Low(TDMM6500_VoltageDCRange) to High(TDMM6500_VoltageDCRange) do
//    fSettingsShowSL.Add(DMM6500_VoltageDCRangeLabels[i]);
//end;

{ TDMM6500_Resistance2WRangeShow }

constructor TDMM6500_Resistance2WRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeResistance2W,DMM6500,ChanNumber);
end;

//procedure TDMM6500_Resistance2WRangeShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Res2W).Range);
//end;

//procedure TDMM6500_Resistance2WRangeShow.OkClick;
//begin
// fDMM6500.SetRange(TDMM6500_Resistance2WRange(Data),fChanNumber);
//end;

//procedure TDMM6500_Resistance2WRangeShow.SettingsShowSLFilling;
// var i:TDMM6500_Resistance2WRange;
//begin
// for I := Low(TDMM6500_Resistance2WRange) to High(TDMM6500_Resistance2WRange) do
//    fSettingsShowSL.Add(DMM6500_Resistance2WRangeLabels[i]);
//end;

{ TDMM6500_Resistance4WRangeShow }

constructor TDMM6500_Resistance4WRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeResistance4W,DMM6500,ChanNumber);
end;

//procedure TDMM6500_Resistance4WRangeShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Res4W).Range);
//end;

//procedure TDMM6500_Resistance4WRangeShow.OkClick;
//begin
// fDMM6500.SetRange(TDMM6500_Resistance4WRange(Data),fChanNumber);
//end;

//procedure TDMM6500_Resistance4WRangeShow.SettingsShowSLFilling;
// var i:TDMM6500_Resistance4WRange;
//begin
// for I := Low(TDMM6500_Resistance4WRange) to High(TDMM6500_Resistance4WRange) do
//    fSettingsShowSL.Add(DMM6500_Resistance4WRangeLabels[i]);
//end;

{ TDMM6500MeasPar_DigVoltShow }

procedure TDMM6500MeasPar_DigVoltShow.CreateControls;
begin
  inherited;

  fRangeShow:=TDMM6500_VoltageDigRangeShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fRangeShow);
  fBaseVoltDCShow:=TDMM6500MeasPar_BaseVoltDCShow.Create(fParent,fDMM6500,fChanNumber);
end;

//procedure TDMM6500MeasPar_DigVoltShow.CreateElements;
//begin
// inherited CreateElements;
//  STRange:=TStaticText.Create(fParent);
////  STRange.Parent:=fParent;
//  Add(STRange);
//end;

procedure TDMM6500MeasPar_DigVoltShow.DesignElements;
begin
  inherited DesignElements;
  fBaseVoltDCShow.DesignElements;
//  RelativeLocation(STDisplayDN,STRange,oRow,Marginbetween);
//   STRange.Font.Color:=clNavy;

  Resize(fBaseVoltDCShow.LVoltageUnit);
  RelativeLocation(STRange,fBaseVoltDCShow.LVoltageUnit,oRow,Marginbetween);
//  fBaseVoltDCShow.LVoltageUnit.Left:=STRange.Left+Marginbetween+LCount.Canvas.TextWidth('1000 V');
  fBaseVoltDCShow.LVoltageUnit.Top:=STRange.Top-2;
  RelativeLocation(fBaseVoltDCShow.LVoltageUnit,fBaseVoltDCShow.STVoltageUnit,oRow,MarginBetweenLST);
  fBaseVoltDCShow.STVoltageUnit.Top:=STRange.Top;

//  RelativeLocation(LCount,STCount,oCol,MarginBetweenLST);
  RelativeLocation(STCount,fBaseVoltDCShow.LInputImpedance,oCol,MarginBetweenLST);
  fBaseVoltDCShow.LInputImpedance.Left:=MarginLeft;
  RelativeLocation(fBaseVoltDCShow.LInputImpedance,fBaseVoltDCShow.STInputImpedance,oRow,MarginBetweenLST);
  fBaseVoltDCShow.STInputImpedance.Top:=fBaseVoltDCShow.LInputImpedance.Top;

  Resize(fBaseVoltDCShow.LDB_DBM);
  RelativeLocation(LSampleRate,fBaseVoltDCShow.LDB_DBM,oRow,Marginbetween);
  RelativeLocation(fBaseVoltDCShow.LDB_DBM,fBaseVoltDCShow.STDB_DBM,oCol,MarginBetweenLST);

  fParent.Width:=MarginRight+fBaseVoltDCShow.LDB_DBM.Left+fBaseVoltDCShow.LDB_DBM.Width;
  fParent.Height:=MarginTop+fBaseVoltDCShow.LInputImpedance.Top+fBaseVoltDCShow.LInputImpedance.Height;


end;

procedure TDMM6500MeasPar_DigVoltShow.DestroyControls;
begin
  FreeAndNil(fBaseVoltDCShow);
  inherited;
end;

procedure TDMM6500MeasPar_DigVoltShow.GetDataFromDevice;
begin
  inherited;
  fBaseVoltDCShow.GetDataFromDevice;
end;

procedure TDMM6500MeasPar_DigVoltShow.ObjectToSetting;
begin
  inherited;
  fBaseVoltDCShow.ObjectToSetting;
end;

{ TDMM6500MeasPar_DigCurShow }

procedure TDMM6500MeasPar_DigCurShow.CreateControls;
begin
  inherited;
  fRangeShow:=TDMM6500_CurrentDigRangeShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fRangeShow);
end;

procedure TDMM6500MeasPar_DigCurShow.DesignElements;
begin
  inherited DesignElements;

  fParent.Width:=MarginRight+LSampleRate.Left+LSampleRate.Width;
  fParent.Height:=MarginTop+STSampleRate.Top+STSampleRate.Height;

end;


{ TDMM6500MeasPar_CapacShow }

procedure TDMM6500MeasPar_CapacShow.CreateControls;
begin
  inherited;
  fRangeShow:=TDMM6500_CapacitanceRangeShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fRangeShow);
end;

procedure TDMM6500MeasPar_CapacShow.DesignElements;
begin
  inherited DesignElements;

  fParent.Width:=MarginRight+STRange.Left+LCount.Canvas.TextWidth('100 mkF');
  fParent.Height:=MarginTop+STCount.Top+STCount.Height;
end;

{ TDMM6500_DetectorBandwidthShow }

constructor TDMM6500_DetectorBandwidthShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Detector Bandwidth:',dm_pp_DetectorBW,DMM6500,ChanNumber);
end;

//procedure TDMM6500_DetectorBandwidthShow.GetDataFromDevice;
//begin
//  fDMM6500.GetDetectorBW(fChanNumber);
//end;

//procedure TDMM6500_DetectorBandwidthShow.ObjectToSetting;
//begin
//  Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseAC).DetectorBW);
//end;

//procedure TDMM6500_DetectorBandwidthShow.OkClick;
//begin
//// fDMM6500.SetShablon(fMeasP,Pointer(Data),fChanNumber);
// fDMM6500.SetDetectorBW(TDMM6500_DetectorBandwidth(Data),fChanNumber);
//end;

//procedure TDMM6500_DetectorBandwidthShow.SettingsShowSLFilling;
// var i:TDMM6500_DetectorBandwidth;
//begin
// for I := Low(TDMM6500_DetectorBandwidth) to High(TDMM6500_DetectorBandwidth) do
//    fSettingsShowSL.Add(DMM6500_DetectorBandwidthLabel[i]);
//end;

{ TDMM6500MeasPar_BaseACShow }

procedure TDMM6500MeasPar_BaseACShow.CreateControls;
begin
  inherited;
  fDetectorBWShow:=TDMM6500_DetectorBandwidthShow.Create(STDetectorBW,LDetectorBW,fDMM6500,fChanNumber);
  Add(fDetectorBWShow);
  fDetectorBWShow.HookParameterClick:=HookParameterClickDetectorBW;
end;

procedure TDMM6500MeasPar_BaseACShow.CreateElements;
begin
  inherited CreateElements;
  STDetectorBW:=TStaticText.Create(fParent);
  Add(STDetectorBW);
  LDetectorBW:=TLabel.Create(fParent);
  Add(LDetectorBW);
end;

procedure TDMM6500MeasPar_BaseACShow.DesignElements;
begin
  inherited DesignElements;
  STDetectorBW.Font.Color:=clRed;
  LDetectorBW.Font.Color:=clRed;
  RelativeLocation(LCount,LDetectorBW,oRow,Marginbetween);
  HookParameterClickDetectorBW;
end;

procedure TDMM6500MeasPar_BaseACShow.HookParameterClickDetectorBW;
begin
 RelativeLocation(LDetectorBW,STDetectorBW,oCol,MarginBetweenLST);
end;

{ TDMM6500MeasPar_CurACShow }

procedure TDMM6500MeasPar_CurACShow.CreateControls;
begin
  inherited;
  fRangeShow:=TDMM6500_CurrentACRangeShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fRangeShow);
end;

procedure TDMM6500MeasPar_CurACShow.DesignElements;
begin
  inherited DesignElements;

  fParent.Width:=MarginRight+LDetectorBW.Left+LDetectorBW.Width;
  fParent.Height:=MarginTop+STDetectorBW.Top+STDetectorBW.Height;

end;

{ TDMM6500MeasPar_VoltACShow }

procedure TDMM6500MeasPar_VoltACShow.CreateControls;
begin
  inherited;
  fRangeShow:=TDMM6500_VoltageACRangeShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fRangeShow);
  fBaseVoltShow:=TDMM6500MeasPar_BaseVoltShow.Create(fParent,fDMM6500,fChanNumber);
end;

procedure TDMM6500MeasPar_VoltACShow.DesignElements;
begin
  inherited DesignElements;
  fBaseVoltShow.DesignElements;

  Resize(fBaseVoltShow.LVoltageUnit);

  RelativeLocation(STCount,fBaseVoltShow.LVoltageUnit,oCol,Marginbetween);
  fBaseVoltShow.LVoltageUnit.Left:=MarginLeft;
  RelativeLocation(fBaseVoltShow.LVoltageUnit,fBaseVoltShow.STVoltageUnit,oCol,MarginBetweenLST);

  Resize(fBaseVoltShow.LDB_DBM);
  RelativeLocation(fBaseVoltShow.LVoltageUnit,fBaseVoltShow.LDB_DBM,oRow,Marginbetween);
  RelativeLocation(fBaseVoltShow.LDB_DBM,fBaseVoltShow.STDB_DBM,oCol,MarginBetweenLST);

  fParent.Width:=MarginRight+LDetectorBW.Left+LDetectorBW.Width;
  fParent.Height:=MarginTop+fBaseVoltShow.STDB_DBM.Top+fBaseVoltShow.STDB_DBM.Height;
end;

procedure TDMM6500MeasPar_VoltACShow.DestroyControls;
begin
  FreeAndNil(fBaseVoltShow);
  inherited;
end;

procedure TDMM6500MeasPar_VoltACShow.GetDataFromDevice;
begin
  inherited;
  fBaseVoltShow.GetDataFromDevice;
end;

procedure TDMM6500MeasPar_VoltACShow.ObjectToSetting;
begin
  inherited;
  fBaseVoltShow.ObjectToSetting;
end;

{ TDMM6500_MeaureTimeShow }

constructor TDMM6500_MeaureTimeShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_pp_MeasureTime,DMM6500,ChanNumber,STD,STC,'Measure Time, ms',1);
 STC.WordWrap:=True;
 SetLimits((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseDelayMT).MTLimits);
end;

//procedure TDMM6500_MeaureTimeShow.GetDataFromDevice;
//begin
// fDMM6500.GetMeasureTime(fChanNumber);
//end;

//procedure TDMM6500_MeaureTimeShow.ObjectToSetting;
//begin
//  Data:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseDelayMT).MeaureTime;
//end;

//procedure TDMM6500_MeaureTimeShow.OkClick;
//begin
// fDMM6500.SetMeasureTime(Data,fChanNumber);
//end;

{ TDMM6500_AzeroStateShow }

procedure TDMM6500_AzeroStateShow.Click(Sender: TObject);
begin
 if fChanNumber=0 then fDMM6500.SetAzeroState(fCB.Checked)
                  else fDMM6500.SetAzeroState(fCB.Checked,fChanNumber);
 fHookParameterClick;
end;

constructor TDMM6500_AzeroStateShow.Create(CB: TCheckBox; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create(CB,'Auto Zero',dm_pp_AzeroState,DMM6500,ChanNumber);
end;

//procedure TDMM6500_AzeroStateShow.GetDataFromDevice;
//begin
// fDMM6500.GetAzeroState(fChanNumber);
//end;

//procedure TDMM6500_AzeroStateShow.ObjectToSetting;
//begin
// SetValue((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Continuity).AzeroState);
//end;

{ TDMM6500_LineSyncShow }

//procedure TDMM6500_LineSyncShow.Click(Sender: TObject);
//begin
// fDMM6500.SetLineSync(fCB.Checked,fChanNumber);
// inherited;
//end;

constructor TDMM6500_LineSyncShow.Create(CB: TCheckBox; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create(CB,'Line Sync',dm_pp_LineSync,DMM6500,ChanNumber);
end;

//procedure TDMM6500_LineSyncShow.GetDataFromDevice;
//begin
// fDMM6500.GetLineSync(fChanNumber);
//end;

//procedure TDMM6500_LineSyncShow.ObjectToSetting;
//begin
// SetValue((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Continuity).LineSync);
//end;

{ TDMM6500MeasPar_BaseDelayMTShow }

procedure TDMM6500MeasPar_BaseDelayMTShow.CreateControls;
begin
  inherited;
  fMeaureTimeShow:=TDMM6500_MeaureTimeShow.Create(STMeaureTime,LMeaureTime,fDMM6500,fChanNumber);
  Add(fMeaureTimeShow);
  fMeaureTimeShow.HookParameterClick:=HookParameterClickMeaureTime;
end;

procedure TDMM6500MeasPar_BaseDelayMTShow.CreateElements;
begin
  inherited CreateElements;
  STMeaureTime:=TStaticText.Create(fParent);
  Add(STMeaureTime);
  LMeaureTime:=TLabel.Create(fParent);
  Add(LMeaureTime);
end;

procedure TDMM6500MeasPar_BaseDelayMTShow.DesignElements;
begin
  inherited DesignElements;
  STMeaureTime.Font.Color:=clBlue;
  LMeaureTime.Font.Color:=clBlue;
  Resize(LMeaureTime);
  RelativeLocation(LCount,LMeaureTime,oRow,Marginbetween);
  HookParameterClickMeaureTime;
//  RelativeLocation(LSampleRate,STSampleRate,oCol,MarginBetweenLST);
end;

procedure TDMM6500MeasPar_BaseDelayMTShow.HookParameterClickMeaureTime;
begin
 RelativeLocation(LMeaureTime,STMeaureTime,oCol,MarginBetweenLST);
end;

{ TDMM6500_ThresholdRangeShow }

constructor TDMM6500_ThresholdRangeShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Threshold Range:',dm_pp_ThresholdRange,DMM6500,ChanNumber);
end;

//procedure TDMM6500_ThresholdRangeShow.GetDataFromDevice;
//begin
// fDMM6500.GetThresholdRange(fChanNumber);
//end;

//procedure TDMM6500_ThresholdRangeShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_FreqPeriod).ThresholdRange);
//end;

//procedure TDMM6500_ThresholdRangeShow.OkClick;
//begin
// fDMM6500.SetThresholdRange(TDMM6500_VoltageACRange(Data),fChanNumber);
//end;

//procedure TDMM6500_ThresholdRangeShow.SettingsShowSLFilling;
// var i:TDMM6500_VoltageACRange;
//begin
// for I := Low(TDMM6500_VoltageACRange) to High(TDMM6500_VoltageACRange) do
//    fSettingsShowSL.Add(DMM6500_VoltageACRangeLabels[i]);
//end;

{ TDMM6500MeasPar_FreqPeriodShow }

procedure TDMM6500MeasPar_FreqPeriodShow.CreateControls;
begin
  inherited;
  fThresholdRangeShow:=TDMM6500_ThresholdRangeShow.Create(STThresholdRange,LThresholdRange,fDMM6500,fChanNumber);
  Add(fThresholdRangeShow);
end;

procedure TDMM6500MeasPar_FreqPeriodShow.CreateElements;
begin
  inherited CreateElements;
  STThresholdRange:=TStaticText.Create(fParent);
  Add(STThresholdRange);
  LThresholdRange:=TLabel.Create(fParent);
  Add(LThresholdRange);
end;

procedure TDMM6500MeasPar_FreqPeriodShow.DesignElements;
begin
  inherited DesignElements;
  Resize(LThresholdRange);
  RelativeLocation(STCount,LThresholdRange,oCol,Marginbetween);
  LThresholdRange.Left:=MarginLeft;
  RelativeLocation(LThresholdRange,STThresholdRange,oRow,MarginBetweenLST);
  STThresholdRange.Top:=LThresholdRange.Top;

  fParent.Width:=MarginRight+LMeaureTime.Left+LMeaureTime.Width;
  fParent.Height:=MarginTop+STThresholdRange.Top+STThresholdRange.Height;
end;

{ TDMM6500MeasPar_ContinuityBaseShow }

procedure TDMM6500MeasPar_ContinuityBaseShow.CreateControls;
begin
  inherited;
  fLineSyncShow:=TDMM6500_LineSyncShow.Create(CBLineSync,fDMM6500,fChanNumber);
  add(fLineSyncShow);
  fAzeroShow:=TDMM6500_AzeroStateShow.Create(CBAzero,fDMM6500,fChanNumber);
  Add(fAzeroShow);
end;

procedure TDMM6500MeasPar_ContinuityBaseShow.CreateElements;
begin
  inherited;
  CBAzero:=TCheckBox.Create(fParent);
  Add(CBAzero);
  CBLineSync:=TCheckBox.Create(fParent);
  Add(CBLineSync);
end;

procedure TDMM6500MeasPar_ContinuityBaseShow.DesignElements;
begin
  inherited DesignElements;
  Resize(CBLineSync);
  RelativeLocation(STCount,CBLineSync,oCol,Marginbetween);
  CBLineSync.Left:=MarginLeft;
  RelativeLocation(CBLineSync,CBAzero,oRow,MarginBetween);

//  fParent.Width:=MarginRight+LMeaureTime.Left+LMeaureTime.Width;
//  fParent.Height:=MarginTop+STThresholdRange.Top+STThresholdRange.Height;

end;

{ TDMM6500MeasPar_ContinuityShow }

procedure TDMM6500MeasPar_ContinuityShow.DesignElements;
begin
  inherited DesignElements;
  CBAzero.Enabled:=False;
  RelativeLocation(CBAutoDelay,STRange,oRow,Marginbetween);
  STRange.Top:=STDisplayDN.Top;
  STRange.Caption:='1 kOhm';
  STRange.Enabled:=False;
 (fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseDelayMT).MeaureTime:=0.12;
  STMeaureTime.Enabled:=False;
  LMeaureTime.Enabled:=False;

  fParent.Width:=MarginRight+LMeaureTime.Left+LMeaureTime.Width;
  fParent.Height:=MarginTop+CBAzero.Top+CBAzero.Height;
end;

{ TDMM6500_BiasLevelShow }

constructor TDMM6500_BiasLevelShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Bias Level:',dm_dp_BiasLevel,DMM6500,ChanNumber);
end;

//procedure TDMM6500_BiasLevelShow.GetDataFromDevice;
//begin
// fDMM6500.GetBiasLevel(fChanNumber);
//end;

//procedure TDMM6500_BiasLevelShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Diode).BiasLevel);
//end;

//procedure TDMM6500_BiasLevelShow.OkClick;
//begin
// fDMM6500.SetBiasLevel(TDMM6500_DiodeBiasLevel(Data),fChanNumber);
// inherited;
//end;

//procedure TDMM6500_BiasLevelShow.SettingsShowSLFilling;
// var i:TDMM6500_DiodeBiasLevel;
//begin
// for I := Low(TDMM6500_DiodeBiasLevel) to High(TDMM6500_DiodeBiasLevel) do
//    fSettingsShowSL.Add(DMM6500_DiodeBiasLevelLabel[i]);
//end;

{ TDMM6500MeasPar_DiodeShow }

procedure TDMM6500MeasPar_DiodeShow.CreateControls;
begin
  inherited;
  fBiasLevelShow:=TDMM6500_BiasLevelShow.Create(STBiasLevel,LBiasLevel,fDMM6500,fChanNumber);
  Add(fBiasLevelShow);
  fBiasLevelShow.HookParameterClick:=HookParameterClickBiasLevel;
end;

procedure TDMM6500MeasPar_DiodeShow.CreateElements;
begin
  inherited;
  STBiasLevel:=TStaticText.Create(fParent);
  Add(STBiasLevel);
  LBiasLevel:=TLabel.Create(fParent);
  Add(LBiasLevel);
end;

procedure TDMM6500MeasPar_DiodeShow.DesignElements;
begin
  inherited DesignElements;
  CBLineSync.Enabled:=False;
  RelativeLocation(CBAutoDelay,STRange,oRow,Marginbetween);
  STRange.Top:=STDisplayDN.Top;
  STRange.Caption:='10 V';
  STRange.Enabled:=False;

  RelativeLocation(LMeaureTime,LBiasLevel,oRow,Marginbetween);
  HookParameterClickBiasLevel;
//  RelativeLocation(LBiasLevel,STBiasLevel,oRow,MarginBetween);

  fParent.Width:=MarginRight+LBiasLevel.Left+LBiasLevel.Width;
  fParent.Height:=MarginTop+CBAzero.Top+CBAzero.Height;
end;

procedure TDMM6500MeasPar_DiodeShow.HookParameterClickBiasLevel;
begin
 RelativeLocation(LBiasLevel,STBiasLevel,oCol,MarginBetween);
end;

{ TDMM6500MeasPar_CurDCShow }

procedure TDMM6500MeasPar_CurDCShow.CreateControls;
begin
  inherited;
  fRangeShow:=TDMM6500_CurrentDCRangeShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fRangeShow);
end;

procedure TDMM6500MeasPar_CurDCShow.DesignElements;
begin
  inherited DesignElements;

  fParent.Width:=MarginRight+STRange.Left+LCount.Canvas.TextWidth('100 mkA');;
  fParent.Height:=MarginTop+CBAzero.Top+CBAzero.Height;
end;

{ TDMM6500MeasPar_BaseVoltDCRangeShow }

procedure TDMM6500MeasPar_BaseVoltDCRangeShow.CreateControls;
begin
  inherited;
  fRangeShow:=TDMM6500_VoltageDCRangeShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fRangeShow);
end;

procedure TDMM6500MeasPar_BaseVoltDCRangeShow.DesignElements;
begin
  inherited DesignElements;

//  fParent.Width:=MarginRight+STRange.Left+LCount.Canvas.TextWidth('1000 V');
//  fParent.Height:=MarginTop+CBAzero.Top+CBAzero.Height;
end;

{ TDMM6500MeasPar_Res2WShow }

procedure TDMM6500MeasPar_Res2WShow.CreateControls;
begin
  inherited;
  fRangeShow:=TDMM6500_Resistance2WRangeShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fRangeShow);
end;

procedure TDMM6500MeasPar_Res2WShow.DesignElements;
begin
  inherited;
  fParent.Width:=MarginRight+STRange.Left+LCount.Canvas.TextWidth('100 kOhm');
  fParent.Height:=MarginTop+CBAzero.Top+CBAzero.Height;
end;

{ TDMM6500_OpenLDShow }

//procedure TDMM6500_OpenLDShow.Click(Sender: TObject);
//begin
//  fDMM6500.SetOpenLD(fCB.Checked,fChanNumber);
//  inherited;
//end;

constructor TDMM6500_OpenLDShow.Create(CB: TCheckBox; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
  inherited Create(CB,'Open Lead Detector',dm_pp_OpenLeadDetector,DMM6500,ChanNumber);
end;

//procedure TDMM6500_OpenLDShow.GetDataFromDevice;
//begin
// fDMM6500.GetOpenLD(fChanNumber);
//end;

//procedure TDMM6500_OpenLDShow.ObjectToSetting;
//begin
// SetValue((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Base4WT).OpenLeadDetector);
//end;

{ TDMM6500_OffCompShow }

constructor TDMM6500_OffCompShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Offset Compensation:',dm_pp_OffsetCompen,DMM6500,ChanNumber);
end;

//procedure TDMM6500_OffCompShow.GetDataFromDevice;
//begin
// fDMM6500.GetOffsetComp(fChanNumber);
//end;

//procedure TDMM6500_OffCompShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Base4WT).OffsetComp);
//end;

//procedure TDMM6500_OffCompShow.OkClick;
//begin
// fDMM6500.SetOffsetComp(TDMM6500_OffsetCompen(Data),fChanNumber);
// inherited;
//end;

//procedure TDMM6500_OffCompShow.SettingsShowSLFilling;
// var i:TDMM6500_OffsetCompen;
//begin
// for I := Low(TDMM6500_OffsetCompen) to High(TDMM6500_OffsetCompen) do
//    fSettingsShowSL.Add(DMM6500_OffsetCompenLabel[i]);
//end;

{ TDMM6500MeasPar_Base4WTShow }

procedure TDMM6500MeasPar_Base4WTShow.CreateControls;
begin
  inherited;
  fOffCompShow:=TDMM6500_OffCompShow.Create(STOffComp,LOffComp,fDMM6500,fChanNumber);
  Add(fOffCompShow);
  fOpenLDShow:=TDMM6500_OpenLDShow.Create(CBOpenLD,fDMM6500,fChanNumber);
  Add(fOpenLDShow);
end;

procedure TDMM6500MeasPar_Base4WTShow.CreateElements;
begin
  inherited CreateElements;
  CBOpenLD:=TCheckBox.Create(fParent);
  Add(CBOpenLD);
  STOffComp:=TStaticText.Create(fParent);
  Add(STOffComp);
  LOffComp:=TLabel.Create(fParent);
  Add(LOffComp);
end;

procedure TDMM6500MeasPar_Base4WTShow.DesignElements;
begin
  inherited DesignElements;
  RelativeLocation(CBAzero,CBOpenLD,oRow,Marginbetween);


  RelativeLocation(CBLineSync,LOffComp,oCol,MarginBetween);
  CBLineSync.Left:=MarginLeft;
  LOffComp.Left:=MarginLeft;
  RelativeLocation(LOffComp,STOffComp,oRow,MarginBetweenLST);
  STOffComp.Top:=LOffComp.Top+1;

  RelativeLocation(LOffComp,CBOpenLD,oCol,Marginbetween);
  CBOpenLD.Left:=MarginLeft;

//  fParent.Width:=MarginRight+LMeaureTime.Left+LMeaureTime.Width;
//  fParent.Height:=MarginTop+CBOpenLD.Top+CBOpenLD.Height;
end;

{ TDMM6500MeasPar_Res4WShow }

procedure TDMM6500MeasPar_Res4WShow.CreateControls;
begin
  inherited;
  fRangeShow:=TDMM6500_Resistance4WRangeShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fRangeShow);
end;

procedure TDMM6500MeasPar_Res4WShow.DesignElements;
begin
  inherited;
  fParent.Width:=MarginRight+STRange.Left+LCount.Canvas.TextWidth('100 kOhm');
fParent.Height:=MarginTop+CBOpenLD.Top+CBOpenLD.Height;
end;

{ TDMM6500_VoltageRatioMethodShow }

constructor TDMM6500_VoltageRatioMethodShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Method:',dm_vrp_VRMethod,DMM6500,ChanNumber);
end;

//procedure TDMM6500_VoltageRatioMethodShow.GetDataFromDevice;
//begin
// fDMM6500.GetVRMethod(fChanNumber);
//end;

//procedure TDMM6500_VoltageRatioMethodShow.ObjectToSetting;
//begin
//  Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_VoltRat).VRMethod);
//end;

//procedure TDMM6500_VoltageRatioMethodShow.OkClick;
//begin
// fDMM6500.SetVRMethod(TDMM6500_VoltageRatioMethod(Data),fChanNumber);
// inherited;
//end;

//procedure TDMM6500_VoltageRatioMethodShow.SettingsShowSLFilling;
// var i:TDMM6500_VoltageRatioMethod;
//begin
// for I := Low(TDMM6500_VoltageRatioMethod) to High(TDMM6500_VoltageRatioMethod) do
//    fSettingsShowSL.Add(DMM6500_VoltageRatioMethodLabel[i]);
//end;

{ TDMM6500MeasPar_VoltRatShow }

procedure TDMM6500MeasPar_VoltRatShow.CreateControls;
begin
  inherited;
  fMethodShow:=TDMM6500_VoltageRatioMethodShow.Create(STVRMethod,LVRMethod,fDMM6500,fChanNumber);
  Add(fMethodShow);
end;

procedure TDMM6500MeasPar_VoltRatShow.CreateElements;
begin
  inherited CreateElements;
  STVRMethod:=TStaticText.Create(fParent);
  Add(STVRMethod);
  LVRMethod:=TLabel.Create(fParent);
  Add(LVRMethod);
end;

procedure TDMM6500MeasPar_VoltRatShow.DesignElements;
begin
  inherited DesignElements;
  RelativeLocation(CBLineSync,LVRMethod,oCol,MarginBetween);
//  CBLineSync.Left:=MarginLeft;
  LVRMethod.Left:=MarginLeft;
  RelativeLocation(LVRMethod,STVRMethod,oRow,MarginBetweenLST);
  STVRMethod.Top:=LVRMethod.Top+1;

  fParent.Width:=MarginRight+STRange.Left+LCount.Canvas.TextWidth('1000 V');
  fParent.Height:=MarginTop+LVRMethod.Top+LVRMethod.Height;
end;

{ TDMM6500_TransdTypeShow }

constructor TDMM6500_TempTransdTypeShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Temperature Source:',dm_tp_TransdType,DMM6500,ChanNumber);
end;

//procedure TDMM6500_TempTransdTypeShow.GetDataFromDevice;
//begin
// fDMM6500.GetTransdType(fChanNumber);
//end;

//procedure TDMM6500_TempTransdTypeShow.ObjectToSetting;
//begin
//  Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).TransdType);
//end;

//procedure TDMM6500_TempTransdTypeShow.OkClick;
//begin
// fDMM6500.SetTransdType(TDMM6500_TempTransducer(Data),fChanNumber);
// inherited;
//end;

//procedure TDMM6500_TempTransdTypeShow.SettingsShowSLFilling;
// var i:TDMM6500_TempTransducer;
//begin
// for I := Low(TDMM6500_TempTransducer) to High(TDMM6500_TempTransducer) do
//    fSettingsShowSL.Add(DMM6500_TempTransducerLabel[i]);
//end;

{ TDMM6500_TempTypeShow }

//constructor TDMM6500_TempTypeShow.Create(ST: TStaticText; L: Tlabel;
//  DMM6500: TDMM6500; ChanNumber: byte);
//begin
// inherited Create(ST,L,'Type:',DMM6500,ChanNumber);
//end;

{ TDMM6500_TCoupleShow }

constructor TDMM6500_TCoupleShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Type:',dm_tp_TCoupleType,DMM6500,ChanNumber);
end;

//procedure TDMM6500_TCoupleShow.GetDataFromDevice;
//begin
// fDMM6500.GetTCoupleType(fChanNumber);
//end;

//procedure TDMM6500_TCoupleShow.ObjectToSetting;
//begin
//  Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).TCoupleType);
//end;

//procedure TDMM6500_TCoupleShow.OkClick;
//begin
// fDMM6500.SetTCoupleType(TDMM6500_TCoupleType(Data),fChanNumber);
// inherited;
//end;
//
//procedure TDMM6500_TCoupleShow.SettingsShowSLFilling;
// var i:TDMM6500_TCoupleType;
//begin
// for I := Low(TDMM6500_TCoupleType) to High(TDMM6500_TCoupleType) do
//    fSettingsShowSL.Add(DMM6500_TCoupleTypeLabel[i]);
//end;

{ TDMM6500_ThermistorTypeShow }

constructor TDMM6500_ThermistorTypeShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Type:',dm_tp_ThermistorType,DMM6500,ChanNumber);
end;

//procedure TDMM6500_ThermistorTypeShow.GetDataFromDevice;
//begin
// fDMM6500.GetThermistorType(fChanNumber);
//end;

//procedure TDMM6500_ThermistorTypeShow.ObjectToSetting;
//begin
//  Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).ThermistorType);
//end;

//procedure TDMM6500_ThermistorTypeShow.OkClick;
//begin
// fDMM6500.SetThermistorType(TDMM6500_ThermistorType(Data),fChanNumber);
// inherited;
//end;

//procedure TDMM6500_ThermistorTypeShow.SettingsShowSLFilling;
// var i:TDMM6500_ThermistorType;
//begin
// for I := Low(TDMM6500_ThermistorType) to High(TDMM6500_ThermistorType) do
//    fSettingsShowSL.Add(inttostr(DMM6500_ThermistorTypeValues[i])+DMM6500_ThermistorTypeSyffix);
//end;

{ TDMM6500_W2RTDTypeShow }

constructor TDMM6500_W2RTDTypeShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Type:',dm_tp_W2RTDType,DMM6500,ChanNumber);
end;

//procedure TDMM6500_W2RTDTypeShow.GetDataFromDevice;
//begin
// fDMM6500.GetW2RTDType(fChanNumber);
//end;

//procedure TDMM6500_W2RTDTypeShow.ObjectToSetting;
//begin
//  Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).W2RTDType);
//end;

//procedure TDMM6500_W2RTDTypeShow.OkClick;
//begin
// fDMM6500.SetW2RTDType(TDMM6500_RTDType(Data),fChanNumber);
// inherited;
//end;

{ TDMM6500_RTDTypeShow }

//procedure TDMM6500_RTDTypeShow.SettingsShowSLFilling;
// var i:TDMM6500_RTDType;
//begin
// for I := Low(TDMM6500_RTDType) to High(TDMM6500_RTDType) do
//    fSettingsShowSL.Add(DMM6500_WiRTDTypeLabel[i]);
//end;

{ TDMM6500_W3RTDTypeShow }

constructor TDMM6500_W3RTDTypeShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Type:',dm_tp_W3RTDType,DMM6500,ChanNumber);
end;

//procedure TDMM6500_W3RTDTypeShow.GetDataFromDevice;
//begin
// fDMM6500.GetW3RTDType(fChanNumber);
//end;

//procedure TDMM6500_W3RTDTypeShow.ObjectToSetting;
//begin
//  Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).W3RTDType);
//end;

//procedure TDMM6500_W3RTDTypeShow.OkClick;
//begin
// fDMM6500.SetW3RTDType(TDMM6500_RTDType(Data),fChanNumber);
// inherited;
//end;

{ TDMM6500_W4RTDTypeShow }

constructor TDMM6500_W4RTDTypeShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Type:',dm_tp_W4RTDType,DMM6500,ChanNumber);
end;

//procedure TDMM6500_W4RTDTypeShow.GetDataFromDevice;
//begin
// fDMM6500.GetW4RTDType(fChanNumber);
//end;

//procedure TDMM6500_W4RTDTypeShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).W4RTDType);
//end;

//procedure TDMM6500_W4RTDTypeShow.OkClick;
//begin
// fDMM6500.SetW4RTDType(TDMM6500_RTDType(Data),fChanNumber);
// inherited;
//end;

{ TDMM6500_TCoupleRefJunctShow }

constructor TDMM6500_TCoupleRefJunctShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Ref Junction:',dm_tp_RefJunction,DMM6500,ChanNumber);
end;

//procedure TDMM6500_TCoupleRefJunctShow.GetDataFromDevice;
//begin
// fDMM6500.GetRefJunction(fChanNumber);
//end;

//procedure TDMM6500_TCoupleRefJunctShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).RefJunction);
//end;

//procedure TDMM6500_TCoupleRefJunctShow.OkClick;
//begin
// fDMM6500.SetRefJunction(TDMM6500_TCoupleRefJunct(Data),fChanNumber);
// inherited;
//end;

//procedure TDMM6500_TCoupleRefJunctShow.SettingsShowSLFilling;
// var i:TDMM6500_TCoupleRefJunct;
//begin
// for I := Low(TDMM6500_TCoupleRefJunct) to High(TDMM6500_TCoupleRefJunct) do
//    fSettingsShowSL.Add(DMM6500_TCoupleRefJunctLabel[i]);
//end;

{ TDMM6500_TemperatureUnitShow }

constructor TDMM6500_TemperatureUnitShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,'TempUnit',dm_tp_UnitsTemp,DMM6500,ChanNumber);
end;

//procedure TDMM6500_TemperatureUnitShow.GetDataFromDevice;
//begin
// fDMM6500.GetUnits(fChanNumber);
//end;

//procedure TDMM6500_TemperatureUnitShow.ObjectToSetting;
//begin
// Data:=ord((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).Units);
//end;

//procedure TDMM6500_TemperatureUnitShow.OkClick;
//begin
// fDMM6500.SetUnits(TDMM6500_TempUnits(Data),fChanNumber);
// inherited;
//end;

//procedure TDMM6500_TemperatureUnitShow.SettingsShowSLFilling;
// var i:TDMM6500_TempUnits;
//begin
// for I := Low(TDMM6500_TempUnits) to High(TDMM6500_TempUnits) do
//    fSettingsShowSL.Add(DMM6500_TempUnitsLabel[i]);
//end;

{ TDMM6500_SimRefTempShow }

constructor TDMM6500_RTDZeroShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_tp_RTDZero,DMM6500,ChanNumber,STD,STC,'RTD Zero',100);
// STC.WordWrap:=False;
 SetLimits(DMM6500_RTDZeroLimits);
end;

//procedure TDMM6500_RTDZeroShow.GetDataFromDevice;
//begin
//  fDMM6500.GetRTDZero(fChanNumber);
//end;

//procedure TDMM6500_RTDZeroShow.ObjectToSetting;
//begin
//  Data:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).RTD_Zero;
//end;

//procedure TDMM6500_RTDZeroShow.OkClick;
//begin
//  fDMM6500.SetRTDZero(Data,fChanNumber);
//  inherited;
//end;

{ TDMM6500_SimRefTempShow }

constructor TDMM6500_SimRefTempShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_tp_SimRefTemp,DMM6500,ChanNumber,STD,STC,'Ref Temperature',
                DMM6500_RefTempInitValue[(DMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).Units]);
// STC.WordWrap:=True;
 SetLimits(DMM6500_RefTempLimits[(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).Units]);
end;

//procedure TDMM6500_SimRefTempShow.GetDataFromDevice;
//begin
// fDMM6500.GetRefTemperature(fChanNumber);
//end;

//procedure TDMM6500_SimRefTempShow.ObjectToSetting;
//begin
//  Data:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).RefTemperature;
//end;

//procedure TDMM6500_SimRefTempShow.OkClick;
//begin
//  fDMM6500.SetRefTemperature(Data,fChanNumber);
//  inherited;
//end;

{ TDMM6500_RTDAlphaShow }

constructor TDMM6500_RTDAlphaShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_tp_RTDAlpha,DMM6500,ChanNumber,STD,STC,'RTD Alpha:',
                0.00385055,8);
// STC.WordWrap:=True;
 SetLimits(DMM6500_RTDAlphaLimits);
end;

//procedure TDMM6500_RTDAlphaShow.GetDataFromDevice;
//begin
// fDMM6500.GetRTDAlpha(fChanNumber);
//end;

//procedure TDMM6500_RTDAlphaShow.ObjectToSetting;
//begin
//  Data:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).RTD_Alpha;
//end;

//procedure TDMM6500_RTDAlphaShow.OkClick;
//begin
//  fDMM6500.SetRTDAlpha(Data,fChanNumber);
//  inherited;
//end;

{ TDMM6500_RTDBetaShow }

constructor TDMM6500_RTDBetaShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_tp_RTDBeta,DMM6500,ChanNumber,STD,STC,'RTD Beta:',
                0.10863,5);
// STC.WordWrap:=True;
 SetLimits(DMM6500_RTDBetaLimits);
end;

//procedure TDMM6500_RTDBetaShow.GetDataFromDevice;
//begin
// fDMM6500.GetRTDBeta(fChanNumber);
//end;

//procedure TDMM6500_RTDBetaShow.ObjectToSetting;
//begin
//Data:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).RTD_Beta;
//end;

//procedure TDMM6500_RTDBetaShow.OkClick;
//begin
//  fDMM6500.SetRTDBeta(Data,fChanNumber);
//  inherited;
//end;

{ TDMM6500_RTDDeltaShow }

constructor TDMM6500_RTDDeltaShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_tp_RTDDelta,DMM6500,ChanNumber,STD,STC,'RTD Delta:',
                1.4999,4);
// STC.WordWrap:=True;
 SetLimits(DMM6500_RTDDeltaLimits);
end;

//procedure TDMM6500_RTDDeltaShow.GetDataFromDevice;
//begin
// fDMM6500.GetRTDDelta(fChanNumber);
//end;

//procedure TDMM6500_RTDDeltaShow.ObjectToSetting;
//begin
//Data:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).RTD_Delta;
//end;

//procedure TDMM6500_RTDDeltaShow.OkClick;
//begin
//  fDMM6500.SetRTDDelta(Data,fChanNumber);
//  inherited;
//end;

{ TDMM6500MeasPar_VoltDCShow }

procedure TDMM6500MeasPar_VoltDCShow.CreateControls;
begin
  inherited;
  fBaseVoltDCShow:=TDMM6500MeasPar_BaseVoltDCShow.Create(fParent,fDMM6500,fChanNumber);
end;

procedure TDMM6500MeasPar_VoltDCShow.DesignElements;
begin
  inherited DesignElements;
  fBaseVoltDCShow.DesignElements;

  Resize(fBaseVoltDCShow.LVoltageUnit);
  RelativeLocation(CBLineSync,fBaseVoltDCShow.LVoltageUnit,oCol,Marginbetween);
  fBaseVoltDCShow.LVoltageUnit.Left:=MarginLeft;
  RelativeLocation(fBaseVoltDCShow.LVoltageUnit,fBaseVoltDCShow.STVoltageUnit,oCol,MarginBetweenLST);

  Resize(fBaseVoltDCShow.LDB_DBM);
  RelativeLocation(fBaseVoltDCShow.LVoltageUnit,fBaseVoltDCShow.LDB_DBM,oRow,Marginbetween);
  RelativeLocation(fBaseVoltDCShow.LDB_DBM,fBaseVoltDCShow.STDB_DBM,oCol,MarginBetweenLST);
  fBaseVoltDCShow.LDB_DBM.Font.Color:=clTeal;
  fBaseVoltDCShow.STDB_DBM.Font.Color:=clTeal;

//  RelativeLocation(LCount,STCount,oCol,MarginBetweenLST);
  RelativeLocation(fBaseVoltDCShow.LDB_DBM,fBaseVoltDCShow.LInputImpedance,oRow,MarginBetweenLST);
//  fBaseVoltDCShow.LInputImpedance.Left:=MarginLeft;
  RelativeLocation(fBaseVoltDCShow.LInputImpedance,fBaseVoltDCShow.STInputImpedance,oCol,MarginBetweenLST);
//  fBaseVoltDCShow.STInputImpedance.Top:=fBaseVoltDCShow.LInputImpedance.Top;
  fBaseVoltDCShow.LInputImpedance.Font.Color:=clOlive;
  fBaseVoltDCShow.STInputImpedance.Font.Color:=clOlive;

  fParent.Width:=MarginRight+fBaseVoltDCShow.LInputImpedance.Left+fBaseVoltDCShow.LInputImpedance.Width;
  fParent.Height:=MarginTop+fBaseVoltDCShow.STDB_DBM.Top+fBaseVoltDCShow.STDB_DBM.Height;
end;

procedure TDMM6500MeasPar_VoltDCShow.DestroyControls;
begin
  FreeAndNil(fBaseVoltDCShow);
  inherited;
end;

procedure TDMM6500MeasPar_VoltDCShow.GetDataFromDevice;
begin
  inherited;
  fBaseVoltDCShow.GetDataFromDevice;
end;

procedure TDMM6500MeasPar_VoltDCShow.ObjectToSetting;
begin
  inherited;
  fBaseVoltDCShow.ObjectToSetting;
end;

{ TDMM6500MeasPar_TemperShow }

procedure TDMM6500MeasPar_TemperShow.CreateControls;
begin
  inherited;
  fTransdTypeShow:=TDMM6500_TempTransdTypeShow.Create(STTransdType,LTransdType,fDMM6500,fChanNumber);
  Add(fTransdTypeShow);
  fTransdTypeShow.HookParameterClick:=Hook;

  fRTDDeltaShow:=TDMM6500_RTDDeltaShow.Create(STDelta,LDelta,fDMM6500,fChanNumber);
  Add(fRTDDeltaShow);
  fRTDDeltaShow.HookParameterClick:=HookParameterClickDelta;

  fRTDZeroShow:=TDMM6500_RTDZeroShow.Create(STZero,LZero,fDMM6500,fChanNumber);
  Add(fRTDZeroShow);
  fRTDZeroShow.HookParameterClick:=HookParameterClickZero;

  fUnits:=TDMM6500_TemperatureUnitShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fUnits);
  fUnits.HookParameterClick:=HookParameterClickUnits;

  CreateControlsVariate;
end;

procedure TDMM6500MeasPar_TemperShow.CreateControlsVariate;
begin
  case (fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).TransdType of
   dm_ttCouple:begin
                if fW2RTDTypeShow <> nil then
                    FreeAndNil(fW2RTDTypeShow);
                if fW3RTDTypeShow <> nil then
                    FreeAndNil(fW3RTDTypeShow);
                if fW4RTDTypeShow <> nil then
                    FreeAndNil(fW4RTDTypeShow);
                if fThermistorTypeShow <> nil then
                    FreeAndNil(fThermistorTypeShow);
                if fTCoupleTypeShow=nil then
                   begin
                   fTCoupleTypeShow:=TDMM6500_TCoupleShow.Create(STType,LType,fDMM6500,fChanNumber);
                   fTCoupleTypeShow.ObjectToSetting;
                   fTCoupleTypeShow.HookParameterClick:=HookParameterClickType;
                   end;
               end;
   dm_ttTherm:begin
                if fW2RTDTypeShow <> nil then
                    FreeAndNil(fW2RTDTypeShow);
                if fW3RTDTypeShow <> nil then
                    FreeAndNil(fW3RTDTypeShow);
                if fW4RTDTypeShow <> nil then
                    FreeAndNil(fW4RTDTypeShow);
                if fTCoupleTypeShow <> nil then
                    FreeAndNil(fTCoupleTypeShow);
                if fThermistorTypeShow=nil then
                   begin
                   fThermistorTypeShow:=TDMM6500_ThermistorTypeShow.Create(STType,LType,fDMM6500,fChanNumber);
                   fThermistorTypeShow.ObjectToSetting;
                   fThermistorTypeShow.HookParameterClick:=HookParameterClickType;
                   end;
              end;
   dm_tt2WRTD:begin
                if fThermistorTypeShow <> nil then
                    FreeAndNil(fThermistorTypeShow);
                if fW3RTDTypeShow <> nil then
                    FreeAndNil(fW3RTDTypeShow);
                if fW4RTDTypeShow <> nil then
                    FreeAndNil(fW4RTDTypeShow);
                if fTCoupleTypeShow <> nil then
                    FreeAndNil(fTCoupleTypeShow);
                if fW2RTDTypeShow=nil then
                   begin
                   fW2RTDTypeShow:=TDMM6500_W2RTDTypeShow.Create(STType,LType,fDMM6500,fChanNumber);
                   fW2RTDTypeShow.ObjectToSetting;
                   fW2RTDTypeShow.HookParameterClick:=HookParameterClickRTDType;
                   end;
               end;
   dm_tt3WRTD:begin
                if fThermistorTypeShow <> nil then
                    FreeAndNil(fThermistorTypeShow);
                if fW2RTDTypeShow <> nil then
                    FreeAndNil(fW2RTDTypeShow);
                if fW4RTDTypeShow <> nil then
                    FreeAndNil(fW4RTDTypeShow);
                if fTCoupleTypeShow <> nil then
                    FreeAndNil(fTCoupleTypeShow);
                if fW3RTDTypeShow=nil then
                   begin
                   fW3RTDTypeShow:=TDMM6500_W3RTDTypeShow.Create(STType,LType,fDMM6500,fChanNumber);
                   fW3RTDTypeShow.ObjectToSetting;
                   fW3RTDTypeShow.HookParameterClick:=HookParameterClickRTDType;
                   end;
              end;
   dm_tt4WRTD:begin
                if fThermistorTypeShow <> nil then
                    FreeAndNil(fThermistorTypeShow);
                if fW2RTDTypeShow <> nil then
                    FreeAndNil(fW2RTDTypeShow);
                if fW3RTDTypeShow <> nil then
                    FreeAndNil(fW3RTDTypeShow);
                if fTCoupleTypeShow <> nil then
                    FreeAndNil(fTCoupleTypeShow);
                if fW4RTDTypeShow=nil then
                   begin
                   fW4RTDTypeShow:=TDMM6500_W4RTDTypeShow.Create(STType,LType,fDMM6500,fChanNumber);
                   fW4RTDTypeShow.ObjectToSetting;
                   fW4RTDTypeShow.HookParameterClick:=HookParameterClickRTDType;
                   end;
              end;
  end;

  case (fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).TransdType of
   dm_ttCouple:begin
                if fRTDAlphaShow <> nil then
                    FreeAndNil(fRTDAlphaShow);
                if fRTDBetaShow <> nil then
                    FreeAndNil(fRTDBetaShow);
                if fSimRefTemp=nil then
                   begin
                   fSimRefTemp:=TDMM6500_SimRefTempShow.Create(STRefTemp_Beta,LRefTemp_Beta,fDMM6500,fChanNumber);
                   fSimRefTemp.ObjectToSetting;
                   fSimRefTemp.HookParameterClick:=HookParameterClickRefTemp_Beta;
                   end;
                if fRefJunctionShow=nil then
                   begin
                   fRefJunctionShow:=TDMM6500_TCoupleRefJunctShow.Create(STRefJunc_Alpha,LRefJunc_Alpha,fDMM6500,fChanNumber);
                   fRefJunctionShow.ObjectToSetting;
                   fRefJunctionShow.HookParameterClick:=HookParameterClickRefJun_Alpha;
                   end;
               end;
   dm_tt2WRTD,
   dm_tt3WRTD,
   dm_tt4WRTD:begin
                if fSimRefTemp <> nil then
                    FreeAndNil(fSimRefTemp);
                if fRefJunctionShow <> nil then
                    FreeAndNil(fRefJunctionShow);
                if fRTDAlphaShow=nil then
                   begin
                   fRTDAlphaShow:=TDMM6500_RTDAlphaShow.Create(STRefJunc_Alpha,LRefJunc_Alpha,fDMM6500,fChanNumber);
                   fRTDAlphaShow.ObjectToSetting;
                   fRTDAlphaShow.HookParameterClick:=HookParameterClickRefTemp_Beta;
                   end;
                if fRTDBetaShow=nil then
                   begin
                   fRTDBetaShow:=TDMM6500_RTDBetaShow.Create(STRefTemp_Beta,LRefTemp_Beta,fDMM6500,fChanNumber);
                   fRTDBetaShow.ObjectToSetting;
                   fRTDBetaShow.HookParameterClick:=HookParameterClickRefJun_Alpha;
                   end;
              end;
  end;

end;

procedure TDMM6500MeasPar_TemperShow.CreateElements;
begin
  inherited CreateElements;
  STTransdType:=TStaticText.Create(fParent);
  Add(STTransdType);
  LTransdType:=TLabel.Create(fParent);
  Add(LTransdType);
  STType:=TStaticText.Create(fParent);
  Add(STType);
  LType:=TLabel.Create(fParent);
  Add(LType);
  STRefTemp_Beta:=TStaticText.Create(fParent);
  Add(STRefTemp_Beta);
  LRefTemp_Beta:=TLabel.Create(fParent);
  Add(LRefTemp_Beta);
  STRefJunc_Alpha:=TStaticText.Create(fParent);
  Add(STRefJunc_Alpha);
  LRefJunc_Alpha:=TLabel.Create(fParent);
  Add(LRefJunc_Alpha);
  STDelta:=TStaticText.Create(fParent);
  Add(STDelta);
  LDelta:=TLabel.Create(fParent);
  Add(LDelta);
  STZero:=TStaticText.Create(fParent);
  Add(STZero);
  LZero:=TLabel.Create(fParent);
  Add(LZero);
end;

procedure TDMM6500MeasPar_TemperShow.DesignElements;
begin
  inherited DesignElements;
  RelativeLocation(CBOpenLD,LTransdType,oCol,MarginBetween);
  LTransdType.Left:=MarginLeft;
  RelativeLocation(LTransdType,STTransdType,oCol,MarginBetweenLST);
  LTransdType.Font.Color:=clRed;
  STTransdType.Font.Color:=clRed;

  Resize(LType);
//  RelativeLocation(LTransdType,LType,oRow,MarginBetween);
  HookParameterClickType;

  LType.Font.Color:=clGreen;
  STType.Font.Color:=clGreen;

  Resize(LRefJunc_Alpha);
  RelativeLocation(LType,LRefJunc_Alpha,oRow,2*MarginBetween);
  HookParameterClickRefJun_Alpha;

  Resize(LRefTemp_Beta);
  RelativeLocation(STTransdType,LRefTemp_Beta,oCol,MarginBetween);
  LRefTemp_Beta.Left:=MarginLeft;
  HookParameterClickRefTemp_Beta;
  LRefTemp_Beta.Font.Color:=clNavy;
  STRefTemp_Beta.Font.Color:=clNavy;

  RelativeLocation(LRefTemp_Beta,LDelta,oRow,MarginBetween);
//  LDelta.Left:=MarginLeft;
  HookParameterClickDelta;

  RelativeLocation(LDelta,LZero,oRow,MarginBetween);
  HookParameterClickZero;
  LDelta.Font.Color:=clFuchsia;
  STDelta.Font.Color:=clFuchsia;

  SetTypeEnable((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).TransdType<>dm_ttCJC);
  CBOpenLD.Enabled:=((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).TransdType
                in [dm_ttTherm,dm_tt2WRTD,dm_tt3WRTD,dm_tt4WRTD]);
  HookParameterClickRTDType;


  fParent.Width:=MarginRight+LRefJunc_Alpha.Left+LRefJunc_Alpha.Width;
  fParent.Height:=MarginTop+STDelta.Top+STDelta.Height;

end;

procedure TDMM6500MeasPar_TemperShow.DestroyControls;
begin
  inherited DestroyControls;
  DestroyControlsVariant;
end;

procedure TDMM6500MeasPar_TemperShow.DestroyControlsVariant;
begin
  if fW2RTDTypeShow <> nil then
    FreeAndNil(fW2RTDTypeShow);
  if fW3RTDTypeShow <> nil then
    FreeAndNil(fW3RTDTypeShow);
  if fW4RTDTypeShow <> nil then
    FreeAndNil(fW4RTDTypeShow);
  if fThermistorTypeShow <> nil then
    FreeAndNil(fThermistorTypeShow);
  if fTCoupleTypeShow <> nil then
    FreeAndNil(fTCoupleTypeShow);
  if fRefJunctionShow <> nil then
    FreeAndNil(fRefJunctionShow);
  if fRTDAlphaShow <> nil then
    FreeAndNil(fRTDAlphaShow);
  if fRTDBetaShow <> nil then
    FreeAndNil(fRTDBetaShow);
  if fSimRefTemp <> nil then
    FreeAndNil(fSimRefTemp);
end;

procedure TDMM6500MeasPar_TemperShow.GetDataFromDevice;
begin
 inherited;
 fDMM6500.GetW2RTDType(fChanNumber);
 fDMM6500.GetW3RTDType(fChanNumber);
 fDMM6500.GetW4RTDType(fChanNumber);
 fDMM6500.GetThermistorType(fChanNumber);
 fDMM6500.GetTCoupleType(fChanNumber);
 fDMM6500.GetRefTemperature(fChanNumber);
 fDMM6500.GetRefJunction(fChanNumber);
 fDMM6500.GetRTDAlpha(fChanNumber);
 fDMM6500.GetRTDBeta(fChanNumber);
 fDMM6500.GetRTDDelta(fChanNumber);
 fDMM6500.GetRTDZero(fChanNumber);
end;

procedure TDMM6500MeasPar_TemperShow.HookParameterClickRTDType;
begin
  case (fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).TransdType of
    dm_ttCouple:
      begin
        SetAlphaBetaEnable(True);
        SetDeltaZeroEnable(False);
      end;
    dm_ttCJC, dm_ttTherm:
      SetAllRTDEnable(False);
    dm_tt2WRTD:
      SetAllRTDEnable((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).W2RTDType = dm_rtdUser);
    dm_tt3WRTD:
      SetAllRTDEnable((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).W3RTDType = dm_rtdUser);
    dm_tt4WRTD:
      SetAllRTDEnable((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).W4RTDType = dm_rtdUser);
  end;
  HookParameterClickType;
end;

procedure TDMM6500MeasPar_TemperShow.HookParameterClickType;
begin
 RelativeLocation(LTransdType,LType,oRow,MarginBetween);
 RelativeLocation(LType,STType,oCol,MarginBetweenLST);
end;

procedure TDMM6500MeasPar_TemperShow.HookParameterClickUnits;
begin
  if fSimRefTemp<>nil then
     begin
     FreeAndNil(fSimRefTemp);
     fSimRefTemp:=TDMM6500_SimRefTempShow.Create(STRefTemp_Beta,LRefTemp_Beta,fDMM6500,fChanNumber);
     fSimRefTemp.ObjectToSetting;
     HookParameterClickRefTemp_Beta;
     fSimRefTemp.HookParameterClick:=HookParameterClickRefTemp_Beta;
     end;
end;

procedure TDMM6500MeasPar_TemperShow.Hook;
begin
 CreateControlsVariate;
 DesignElements;
end;

procedure TDMM6500MeasPar_TemperShow.HookParameterClickDelta;
begin
 RelativeLocation(LDelta,STDelta,oCol,MarginBetweenLST);
end;

procedure TDMM6500MeasPar_TemperShow.HookParameterClickRefJun_Alpha;
begin
 RelativeLocation(LRefJunc_Alpha,STRefJunc_Alpha,oCol,MarginBetweenLST);
end;

procedure TDMM6500MeasPar_TemperShow.HookParameterClickRefTemp_Beta;
begin
 RelativeLocation(LRefTemp_Beta,STRefTemp_Beta,oCol,MarginBetweenLST);
end;

procedure TDMM6500MeasPar_TemperShow.HookParameterClickZero;
begin
  RelativeLocation(LZero,STZero,oCol,MarginBetweenLST);
end;

procedure TDMM6500MeasPar_TemperShow.ObjectToSetting;
begin
 inherited ObjectToSetting;
  if fW2RTDTypeShow <> nil then
    fW2RTDTypeShow.ObjectToSetting;
  if fW3RTDTypeShow <> nil then
    fW3RTDTypeShow.ObjectToSetting;
  if fW4RTDTypeShow <> nil then
    fW4RTDTypeShow.ObjectToSetting;
  if fThermistorTypeShow <> nil then
    fThermistorTypeShow.ObjectToSetting;
  if fTCoupleTypeShow <> nil then
    fTCoupleTypeShow.ObjectToSetting;
  if fRefJunctionShow <> nil then
    fRefJunctionShow.ObjectToSetting;
  if fRTDAlphaShow <> nil then
    fRTDAlphaShow.ObjectToSetting;
  if fRTDBetaShow <> nil then
    fRTDBetaShow.ObjectToSetting;
  if fSimRefTemp <> nil then
    fSimRefTemp.ObjectToSetting;
end;

procedure TDMM6500MeasPar_TemperShow.SetAllRTDEnable(Value: boolean);
begin
  SetAlphaBetaEnable(Value);
  SetDeltaZeroEnable(Value);
end;

procedure TDMM6500MeasPar_TemperShow.SetAlphaBetaEnable(Value: boolean);
begin
  STRefTemp_Beta.Enabled:=Value;
  LRefTemp_Beta.Enabled:=Value;
  STRefJunc_Alpha.Enabled:=Value;
  LRefJunc_Alpha.Enabled:=Value;
end;

procedure TDMM6500MeasPar_TemperShow.SetDeltaZeroEnable(Value: boolean);
begin
  STDelta.Enabled:=Value;
  LDelta.Enabled:=Value;
  STZero.Enabled:=Value;
  LZero.Enabled:=Value;
end;

procedure TDMM6500MeasPar_TemperShow.SetTypeEnable(Value: boolean);
begin
  STType.Enabled:=Value;
  LType.Enabled:=Value;
end;

end.
