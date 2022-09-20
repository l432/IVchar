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
  fDMM6500:TDMM6500;
  fChanNumber:byte;
  fMeasP:TDMM6500_MeasParameters;
  fHookParameterClick: TSimpleEvent;
 protected
 public
  property HookParameterClick:TSimpleEvent read fHookParameterClick write fHookParameterClick;
  Constructor Create(MeasP:TDMM6500_MeasParameters;DMM6500:TDMM6500;ChanNumber:byte=0);//overload;
  procedure ObjectToSetting;virtual;abstract;
  procedure GetDataFromDevice;virtual;//abstract;
  procedure GetDataFromDeviceAndToSetting;
//  procedure UpDate;
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
  procedure CreateHeader;
  function GetData: integer;
  procedure SetDat(const Value: integer);
  function HighForSLFilling:byte;
  function StrForSLFilling(i:byte):string;
  function FuncForObjectToSetting:byte;
 protected
  fSettingsShowSL:TStringList;
  procedure SettingsShowSLFilling();virtual;
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
 public
  Constructor Create(ST:TStaticText;
           DMM6500:TDMM6500;ChanNumber:byte=0);
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TDMM6500_CountShow=class(TDMM6500_IntegerParameterShow)
 private
  fCountType:byte;
 protected
  procedure OkClick();override;

  procedure SetCountType(Value:byte);
 public
  property CountType:byte write SetCountType;
  Constructor Create(STD:TStaticText;STC:TLabel;
              DMM6500:TDMM6500;ChanNumber:byte=0);
  {CountType = 0 - Count, else CountDig}
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TDMM6500_DisplayDNShow=class(TDMM6500_StringParameterShow)
 protected
  procedure OkClick();override;
 public
  Constructor Create(ST:TStaticText;
           DMM6500:TDMM6500;ChanNumber:byte=0);
  procedure GetDataFromDevice;override;
end;

TDMM6500_AutoDelayShow=class(TDMM6500_BoolParameterShow)
 protected
 public
  Constructor Create(CB:TCheckBox;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_AzeroStateShow=class(TDMM6500_BoolParameterShow)
 protected
  procedure Click(Sender:TObject);override;
 public
  Constructor Create(CB:TCheckBox;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_LineSyncShow=class(TDMM6500_BoolParameterShow)
 protected
 public
  Constructor Create(CB:TCheckBox;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_OpenLDShow=class(TDMM6500_BoolParameterShow)
 protected
 public
  Constructor Create(CB:TCheckBox;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_ChannelCloseShow=class(TDMM6500_BoolParameterShow)
 protected
  procedure Click(Sender:TObject);override;
 public
  Constructor Create(CB:TCheckBox;
           DMM6500:TDMM6500;ChanNumber:byte);
  procedure GetDataFromDevice;override;
  procedure ObjectToSetting;override;
end;


TDMM6500_SampleRateShow=class(TDMM6500_IntegerParameterShow)
 protected
  procedure OkClick();override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_ScanCountShow=class(TDMM6500_IntegerParameterShow)
 protected
  procedure OkClick();override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500);
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TDMM6500_ScanMonitorChanShow=class(TDMM6500_IntegerParameterShow)
 protected
  procedure OkClick();override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500);
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TDMM6500_VoltageUnitShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_TemperatureUnitShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_DecibelReferenceShow=class(TDMM6500_DoubleParameterShow)
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_MeaureTimeShow=class(TDMM6500_DoubleParameterShow)
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_SimRefTempShow=class(TDMM6500_DoubleParameterShow)
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_RTDAlphaShow=class(TDMM6500_DoubleParameterShow)
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_RTDBetaShow=class(TDMM6500_DoubleParameterShow)
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_RTDDeltaShow=class(TDMM6500_DoubleParameterShow)
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_DelayAfterCloseShow=class(TDMM6500_DoubleParameterShow)
 protected
  procedure OkClick();override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte);
  procedure GetDataFromDevice;override;
  procedure ObjectToSetting;override;
end;

TDMM6500_ScanIntervalShow=class(TDMM6500_DoubleParameterShow)
 protected
  procedure OkClick();override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500);
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TDMM6500_ScanMeasIntervalShow=class(TDMM6500_DoubleParameterShow)
 protected
  procedure OkClick();override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500);
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TDMM6500_ScanMonitorLimitLower=class(TDMM6500_DoubleParameterShow)
 protected
  procedure OkClick();override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500);
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TDMM6500_ScanMonitorLimitUpper=class(TDMM6500_DoubleParameterShow)
 protected
  procedure OkClick();override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500);
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TDMM6500_DecibelmWReferenceShow=class(TDMM6500_IntegerParameterShow)
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_RTDZeroShow=class(TDMM6500_IntegerParameterShow)
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_InputImpedanceShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_ThresholdRangeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_BiasLevelShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_OffCompShow=class(TDMM6500_StringParameterShow)
 protected
  procedure OkClick();override;
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_VoltageRatioMethodShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_TempTransdTypeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_TCoupleShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_ThermistorTypeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_W2RTDTypeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_W3RTDTypeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_W4RTDTypeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_TCoupleRefJunctShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_VoltageDigRangeShow=class(TDMM6500_StringParameterShow)
 protected
  procedure OkClick();override;
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_CurrentDigRangeShow=class(TDMM6500_StringParameterShow)
 protected
  procedure OkClick();override;
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_CapacitanceRangeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_CurrentACRangeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_VoltageACRangeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_CurrentDCRangeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_VoltageDCRangeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_Resistance2WRangeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_Resistance4WRangeShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_DetectorBandwidthShow=class(TDMM6500_StringParameterShow)
 public
  Constructor Create(ST:TStaticText;L:Tlabel;
           DMM6500:TDMM6500;ChanNumber:byte=0);
end;

TDMM6500_ScanMonitorModeShow=class(TDMM6500_StringParameterShow)
 protected
  procedure OkClick();override;
  procedure SettingsShowSLFilling();override;
 public
  Constructor Create(STD:TStaticText;
                     STC:TLabel;
                     DMM6500:TDMM6500);
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
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
  procedure ObjectToSetting;virtual;abstract;
  procedure GetDataFromDevice;virtual;abstract;
  procedure GetDataFromDeviceAndToSetting;
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
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TControlElementsWithWindowCreate=class(TControlElements)
 private
  fShowForm:TForm;
  fBOk:TButton;
  fGBInFormShow:TGroupBox;
  procedure OptionButtonClick(Sender: TObject);virtual;abstract;
  procedure CreateFormHeader(const FormName:string);
  procedure CreateFormFooter(const bOkTot:integer);
  procedure FormShowFooter;
end;

TDMM6500ScanParametrWindowShow=class;

TDMM6500ScanParameters=class(TControlElementsWithWindowCreate)
 private
  fBInit:TButton;
  fBAbort:TButton;
  fBAdd:TButton;
  fBClear:TButton;
  fBOption:TButton;
  fMemo:TMemo;
  fST:TStringList;
  fScanParametrWindowShow:TDMM6500ScanParametrWindowShow;
  procedure OptionButtonClick(Sender: TObject);override;
  procedure FormShow();
  procedure MemoFilling;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DestroyElements;override;
  procedure DestroyControls;override;
  procedure DesignElements;override;
 public
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;


//TDMM6500ControlChannels=class(TControlElements)
TDMM6500ControlChannels=class(TControlElementsWithWindowCreate)
 private
  fLabels:array of TLabel;
  fST:array of TStaticText;
  fButtons:array of TButton;
  fBOpenAll:TButton;
  fMeasurementType:array of TDMM6500_MeasurementTypeShow;
//  fShowForm:TForm;
//  fBOk:TButton;
//  fGBInFormShow:TGroupBox;
  fSTDelayAfterClose:TStaticText;
  fLDelayAfterClose:TLabel;
  fCBChannelClose:TCheckBox;
  fDelayAfterCloseShow:TDMM6500_DelayAfterCloseShow;
  fChannelCloseShow:TDMM6500_ChannelCloseShow;
  fMeasParChanShow:TDMM6500_MeasParShow;
  function GetChanCount:byte;
  procedure CreateForm(MeasureType:TKeitley_Measure;ChanNumber:byte);
  procedure FormShow(MeasureType:TKeitley_Measure;ChanNumber:byte);
  procedure OptionButtonClick(Sender: TObject);override;
  procedure ButtonAllOpenClick(Sender: TObject);
  procedure ClosedChannelHighlight;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
  procedure DestroyElements;override;
  procedure DestroyControls;override;
 public
  property ChanCount:byte read GetChanCount;
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;



TDMM6500ScanParametrWindowShow=class(TDMM6500_MeasParShow)
 private
  fScanParameters:TDMM6500ScanParameters;
  fMonitorChanShow:TDMM6500_ScanMonitorChanShow;
  fCountShow:TDMM6500_ScanCountShow;
  fMonitorModeShow:TDMM6500_ScanMonitorModeShow;
  fIntervalShow:TDMM6500_ScanIntervalShow;
  fMonitorLimitUpperShow:TDMM6500_ScanMonitorLimitUpper;
  fMonitorLimitLowerShow:TDMM6500_ScanMonitorLimitLower;
  fMeasIntervalShow:TDMM6500_ScanMeasIntervalShow;
  procedure HookParameterMonitorMode;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
//  procedure Resize(Control:TControl);
//  procedure ResizeElements;
 public
  
  STCount:TStaticText;
  LCount:TLabel;
  STMonitorChan:TStaticText;
  LMonitorChan:TLabel;
  STMonitorMode:TStaticText;
  LMonitorMode:TLabel;
  STInterval:TStaticText;
  LInterval:TLabel;
  STMeasInterval:TStaticText;
  LMeasInterval:TLabel;
  STMonitorLimitUpper:TStaticText;
  LMonitorLimitUpper:TLabel;
  STMonitorLimitLower:TStaticText;
  LMonitorLimitLower:TLabel;
  BAdd:TButton;
  BClear:TButton;
  Memo:TMemo;
  Constructor Create(Parent:TGroupBox;DMM6500:TDMM6500;ScanParameters:TDMM6500ScanParameters);
end;

TDMM6500MeasPar_BaseShow=class(TDMM6500_MeasParShow)
 private
  fCountShow:TDMM6500_CountShow;
  fDisplayDNShow:TDMM6500_DisplayDNShow;
  procedure HookParameterClickCount;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
  procedure Resize(Control:TControl);
  procedure ResizeElements;
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
 public
  STInputImpedance:TStaticText;
  LInputImpedance:TLabel;
end;

TDMM6500MeasPar_DigVoltShow=class(TDMM6500MeasPar_BaseDigShow)
 private
  fRangeShow:TDMM6500_VoltageDigRangeShow;
  fBaseVoltDCShow:TDMM6500MeasPar_BaseVoltDCShow;
 protected
  procedure CreateControls;override;
  procedure DestroyControls;override;
  procedure DesignElements;override;
 public
  procedure ObjectToSetting;override;
  procedure GetDataFromDevice;override;
end;

TDMM6500MeasPar_DigCurShow=class(TDMM6500MeasPar_BaseDigShow)
 private
  fRangeShow:TDMM6500_CurrentDigRangeShow;
 protected
  procedure CreateControls;override;
  procedure DesignElements;override;
end;

TDMM6500MeasPar_CapacShow=class(TDMM6500MeasPar_BaseDelayShow)
 private
  fRangeShow:TDMM6500_CapacitanceRangeShow;
 protected
  procedure CreateControls;override;
  procedure DesignElements;override;
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
  procedure RefreshZeroClick(Sender:TObject);
  procedure HookAzeroShow;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
 public
  CBAzero:TCheckBox;
  CBLineSync:TCheckBox;
  BAzeroAuto:TButton;
  procedure ObjectToSetting;override;
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
end;

TDMM6500MeasPar_BaseVoltDCRangeShow=class(TDMM6500MeasPar_ContinuityBaseShow)
 private
  fRangeShow:TDMM6500_VoltageDCRangeShow;
 protected
  procedure CreateControls;override;
end;

TDMM6500MeasPar_Res2WShow=class(TDMM6500MeasPar_ContinuityBaseShow)
 private
  fRangeShow:TDMM6500_Resistance2WRangeShow;
 protected
  procedure CreateControls;override;
  procedure DesignElements;override;
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
 protected
  procedure CreateControls;override;
  procedure DesignElements;override;
  procedure HookForOffComp;
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
  procedure OpenLeadOffsetCompState;
  procedure DestroyControlsVariant;
  procedure Hook;
  procedure HookParameterClickZero;
  procedure HookParameterClickDelta;
  procedure HookParameterClickRefJun_Alpha;
  procedure HookParameterClickRefTemp_Beta;
  procedure HookParameterClickUnits;
  procedure HookParameterClickType;
  procedure SetTypeEnable(Value:boolean);
  procedure SetOffCompEnable(Value:boolean);
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
end;

{ TDMM6500_StringParameterShow }

constructor TDMM6500_StringParameterShow.Create(ST: TStaticText;
  ParametrCaption: string; MeasP:TDMM6500_MeasParameters;DMM6500: TDMM6500; ChanNumber: byte);
begin
  inherited Create(MeasP,DMM6500,ChanNumber);
  CreateHeader;
  fParamShow:=TStringParameterShow.Create(ST,ParametrCaption,fSettingsShowSL);
  fParamShow.HookParameterClick:=OkClick;
end;

destructor TDMM6500_StringParameterShow.Destroy;
begin
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
   dm_tp_W2RTDType,
   dm_tp_W3RTDType,
   dm_tp_W4RTDType: Result:=ord(High(TDMM6500_RTDType));
   dm_tp_ThermistorType: Result:=ord(High(TDMM6500_ThermistorType));
   dm_tp_TCoupleType: Result:=ord(High(TDMM6500_TCoupleType));
   dm_dp_BiasLevel: Result:=ord(High(TDMM6500_DiodeBiasLevel));
   dm_vrp_VRMethod: Result:=ord(High(TDMM6500_VoltageRatioMethod));
   dm_pp_OffsetCompen: Result:=ord(High(TDMM6500_OffsetCompen));
   dm_pp_DetectorBW: Result:=ord(High(TDMM6500_DetectorBandwidth));
   dm_pp_InputImpedance: Result:=ord(High(TDMM6500_InputImpedance));
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
 inherited OkClick;
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
   dm_tp_W2RTDType,
   dm_tp_W3RTDType,
   dm_tp_W4RTDType: Result:=DMM6500_WiRTDTypeLabel[TDMM6500_RTDType(i)];
   dm_tp_ThermistorType: Result:=inttostr(DMM6500_ThermistorTypeValues[TDMM6500_ThermistorType(i)])
                           +DMM6500_ThermistorTypeSyffix;
   dm_tp_TCoupleType: Result:=DMM6500_TCoupleTypeLabel[TDMM6500_TCoupleType(i)];
   dm_dp_BiasLevel: Result:=DMM6500_DiodeBiasLevelLabel[TDMM6500_DiodeBiasLevel(i)];
   dm_vrp_VRMethod: Result:=DMM6500_VoltageRatioMethodLabel[TDMM6500_VoltageRatioMethod(i)];
   dm_pp_OffsetCompen: Result:=DMM6500_OffsetCompenLabel[TDMM6500_OffsetCompen(i)];
   dm_pp_DetectorBW: Result:=DMM6500_DetectorBandwidthLabel[TDMM6500_DetectorBandwidth(i)];
   dm_pp_InputImpedance: Result:=DMM6500_InputImpedanceLabel[TDMM6500_InputImpedance(i)];
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
  CreateHeader;
  fParamShow:=TStringParameterShow.Create(ST,LCap,ParametrCaption,fSettingsShowSL);
  fParamShow.HookParameterClick:=OkClick;
end;

procedure TDMM6500_StringParameterShow.CreateHeader;
begin
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
 if not(fDMM6500.GetMeasureFunction(fChanNumber))
     and (fChanNumber>0)
     then fDMM6500.SetMeasureFunction(kt_mVolDC,fChanNumber);
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
 DesignElements;
end;

{ TControlChannels }

procedure TDMM6500ControlChannels.ButtonAllOpenClick(Sender: TObject);
begin
 fDMM6500.SetChannelOpenAll;
 ClosedChannelHighlight;
end;

procedure TDMM6500ControlChannels.ClosedChannelHighlight;
 var i:Shortint;
begin
 for I := 0 to High(fButtons) do
  if fDMM6500.ChansMeasure[i].IsClosed
    then fST[i].Font.Color:=clRed
    else fST[i].ParentFont:=True;
end;

procedure TDMM6500ControlChannels.CreateControls;
 var i:Shortint;
begin
 SetLength(fMeasurementType,High(fST)+1);
 for I := 0 to High(fMeasurementType) do
  fMeasurementType[i]:=TDMM6500_MeasurementTypeShow.Create(fST[i],fDMM6500,i+1);
 for I := 0 to High(fButtons) do
  fButtons[i].OnClick:=OptionButtonClick;
 fBOpenAll.OnClick:=ButtonAllOpenClick;
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
    fST[i]:=TStaticText.Create(fParent);
    fButtons[i]:=TButton.Create(fParent);
    fButtons[i].Tag:=i+1;
  end;
 fBOpenAll:=TButton.Create(fParent);
end;

procedure TDMM6500ControlChannels.CreateForm(MeasureType: TKeitley_Measure;
  ChanNumber: byte);
begin

  CreateFormHeader('Options of '+inttostr(ChanNumber)+' channel');
//  fShowForm := TForm.Create(Application);
//  fShowForm.Position := poMainFormCenter;
//  fShowForm.AutoScroll := True;
//  fShowForm.BorderIcons := [biSystemMenu];
//  fShowForm.ParentFont := True;
//  fShowForm.Font.Style := [fsBold];
//  fShowForm.Caption := 'Options of '+inttostr(ChanNumber)+' channel';
//  fShowForm.Color := clLtGray;
//
//  fBOk:=TButton.Create(fShowForm);
//  fBOk.ModalResult:=mrOK;
//  fBOk.Caption:='OK';
//
//  fGBInFormShow:=TGroupBox.Create(fShowForm);
//  fGBInFormShow.Parent:=fShowForm;

   fSTDelayAfterClose:=TStaticText.Create(fShowForm);
   fLDelayAfterClose:=TLabel.Create(fShowForm);
   fCBChannelClose:=TCheckBox.Create(fShowForm);
   fSTDelayAfterClose.Parent:=fShowForm;
   fLDelayAfterClose.Parent:=fShowForm;
   fCBChannelClose.Parent:=fShowForm;




   fMeasParChanShow:=MeasParShowFactory(MeasureType,fGBInFormShow,fDMM6500,ChanNumber);
   if fMeasParChanShow<>nil then fMeasParChanShow.GetDataFromDeviceAndToSetting;

   fDelayAfterCloseShow:=TDMM6500_DelayAfterCloseShow.Create(fSTDelayAfterClose,fLDelayAfterClose,fDMM6500,ChanNumber);
   fChannelCloseShow:=TDMM6500_ChannelCloseShow.Create(fCBChannelClose,fDMM6500,ChanNumber);
   fDelayAfterCloseShow.GetDataFromDeviceAndToSetting;
   fChannelCloseShow.GetDataFromDeviceAndToSetting;
   fChannelCloseShow.HookParameterClick:=ClosedChannelHighlight;

   fCBChannelClose.Left:=MarginLeft;
   fCBChannelClose.Top:=fGBInFormShow.Height+5;
   RelativeLocation(fCBChannelClose,fLDelayAfterClose,oRow,Marginbetween);
   RelativeLocation(fLDelayAfterClose,fSTDelayAfterClose,oRow,MarginBetweenLST);

   CreateFormFooter(fSTDelayAfterClose.Height+5+fSTDelayAfterClose.Top);
//   fGBInFormShow.Top:=0;
//   fGBInFormShow.Left:=0;
//
//   fBOk.Parent:=fShowForm;
//   fBOk.Left:=round((fGBInFormShow.Width-fBOk.Width)/2);
//   fBOk.Top:=fSTDelayAfterClose.Height+5+fSTDelayAfterClose.Top;
//
//   fShowForm.Width:=fGBInFormShow.Width+25;
//   fShowForm.Height:=fBOk.Top+fBOk.Height+35;
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
  end;

fParent.Width:=fButtons[High(fButtons)].Left+fButtons[High(fButtons)].Width+5;

  fBOpenAll.Parent:=fParent;
  fBOpenAll.Caption:='Open All';
  fBOpenAll.Top:=fButtons[High(fButtons)].Top+fButtons[High(fButtons)].Height+5;
  fBOpenAll.Left:=round((fParent.Width-fBOpenAll.Width)/2);

 fParent.Height:=fBOpenAll.Top+fBOpenAll.Height+10;
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
 fBOpenAll.Free;
end;

procedure TDMM6500ControlChannels.FormShow(MeasureType: TKeitley_Measure;
  ChanNumber: byte);
begin
 CreateForm(MeasureType,ChanNumber);

 fShowForm.ShowModal;


 if fMeasParChanShow<> nil then FreeAndNil(fMeasParChanShow);
 FreeAndNil(fDelayAfterCloseShow);
 fChannelCloseShow.HookParameterClick:=nil;
 FreeAndNil(fChannelCloseShow);

 fSTDelayAfterClose.Parent:=nil;
 fLDelayAfterClose.Parent:=nil;
 fCBChannelClose.Parent:=nil;
 fSTDelayAfterClose.Free;
 fLDelayAfterClose.Free;
 fCBChannelClose.Free;

 FormShowFooter;
// fBOk.Parent:=nil;
// fBOk.Free;
//
// fGBInFormShow.Parent:=nil;
// fGBInFormShow.Free;
//
// fShowForm.Hide;
// fShowForm.Release;
end;

function TDMM6500ControlChannels.GetChanCount: byte;
begin
 Result:=High(fLabels)+1;
end;

procedure TDMM6500ControlChannels.GetDataFromDevice;
 var i:Shortint;
begin
 for I := 0 to High(fMeasurementType) do
  begin
   fMeasurementType[i].GetDataFromDevice;
   fDMM6500.GetChannelState(i+1);
  end;

end;

procedure TDMM6500ControlChannels.ObjectToSetting;
 var i:Shortint;
begin
 for I := 0 to High(fMeasurementType) do
  fMeasurementType[i].ObjectToSetting;
 ClosedChannelHighlight;
end;

procedure TDMM6500ControlChannels.OptionButtonClick(Sender: TObject);
begin
 FormShow(fDMM6500.ChansMeasure[(Sender as TButton).Tag-1].MeasureFunction,(Sender as TButton).Tag);
end;

{ TDMM6500_ParameterShow }

destructor TDMM6500_ParameterShow.Destroy;
begin
  fParamShow.HookParameterClick:=nil;
  fParamShow.Free;
  inherited;
end;

procedure TDMM6500_ParameterShow.SetLimits(LimitV: TLimitValues);
begin
 try
 (fParamShow as TLimitedParameterShow).Limits.SetLimits(LimitV[lvMin],LimitV[lvMax]);
 except
 end;
end;

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
if fCountType=0 then
   begin
     if fChanNumber=0
       then fDMM6500.SetCount(Data)
       else fDMM6500.SetCount(Data,fChanNumber);
   end           else
   fDMM6500.SetCountDig(Data,fChanNumber);
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

procedure TDMM6500_DisplayDNShow.OkClick;
begin
 fDMM6500.SetDisplayDigitsNumber(3+Data,fChanNumber);
 fHookParameterClick;
end;

{ TDMM6500MeasPar_BaseShow }

procedure TDMM6500MeasPar_BaseShow.CreateControls;
begin
 fDisplayDNShow:=TDMM6500_DisplayDNShow.Create(STDisplayDN,fDMM6500,fChanNumber);
 fCountShow:=TDMM6500_CountShow.Create(STCount,LCount,fDMM6500,fChanNumber);
 Add(fDisplayDNShow);
 Add(fCountShow);
 fCountShow.HookParameterClick:=HookParameterClickCount;
end;

procedure TDMM6500MeasPar_BaseShow.CreateElements;
begin
  STCount:=TStaticText.Create(fParent);
  Add(STCount);
  LCount:=TLabel.Create(fParent);
  Add(LCount);
  STDisplayDN:=TStaticText.Create(fParent);
  Add(STDisplayDN);
  STRange:=TStaticText.Create(fParent);
  Add(STRange);
end;

procedure TDMM6500MeasPar_BaseShow.DesignElements;
begin
  inherited DesignElements;
  ResizeElements;

  STCount.Font.Color:=clGreen;
  LCount.Font.Color:=clGreen;

 STDisplayDN.Top:=MarginTop;
 STDisplayDN.Left:=MarginLeft;
 RelativeLocation(STDisplayDN,LCount,oCol,Marginbetween);
 LCount.Left:=MarginLeft;
 HookParameterClickCount;
end;

procedure TDMM6500MeasPar_BaseShow.HookParameterClickCount;
begin
 RelativeLocation(LCount,STCount,oCol,MarginBetweenLST);
end;

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

procedure TControlElements.GetDataFromDeviceAndToSetting;
begin
  GetDataFromDevice;
  ObjectToSetting;
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

procedure TDMM6500_ParameterShowBase.GetDataFromDeviceAndToSetting;
begin
 GetDataFromDevice;
 ObjectToSetting;
end;

//procedure TDMM6500_ParameterShowBase.UpDate;
//begin
// GetDataFromDevice;
// ObjectToSetting;
//end;

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
   dm_pp_AzeroState: Result:=(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Continuity).AzeroState;
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

constructor TDMM6500_AutoDelayShow.Create(CB: TCheckBox; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create(CB,'Auto Delay',dm_pp_DelayAuto,DMM6500,ChanNumber);
end;

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
  Add(CBAutoDelay);
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
  Add(STSampleRate);
  LSampleRate:=TLabel.Create(fParent);
  Add(LSampleRate);
end;

procedure TDMM6500MeasPar_BaseDigShow.DesignElements;
begin
  inherited DesignElements;
  STSampleRate.Font.Color:=clRed;
  LSampleRate.Font.Color:=clRed;
  RelativeLocation(LCount,LSampleRate,oRow,Marginbetween);
  HookParameterClickSampleRate;
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

{ TDMM6500_DBShow }

constructor TDMM6500_DecibelReferenceShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_pp_DecibelReference,DMM6500,ChanNumber,STD,STC,'Ref. Value, V',1);
 STC.WordWrap:=False;
 SetLimits(GetBaseVolt.DBLimits);
end;

{ TDMM6500_DecibelmWReferenceShow }

constructor TDMM6500_DecibelmWReferenceShow.Create(STD: TStaticText;
  STC: TLabel; DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_pp_DbmWReference,DMM6500,ChanNumber,STD,STC,'Ref. Value, Ohm',1);
 STC.WordWrap:=False;
 SetLimits(GetBaseVolt.DBMLimits);
end;

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
  STVoltageUnit:=TStaticText.Create(fParent);
  Add(STVoltageUnit);
  LVoltageUnit:=TLabel.Create(fParent);
  Add(LVoltageUnit);
  STDB_DBM:=TStaticText.Create(fParent);
  Add(STDB_DBM);
  LDB_DBM:=TLabel.Create(fParent);
  LDB_DBM.Caption:='Ref. Value, Ohm';
  Add(LDB_DBM);
end;

procedure TDMM6500MeasPar_BaseVoltShow.DesignElements;
begin
  inherited DesignElements;

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
end;

procedure TDMM6500MeasPar_BaseVoltShow.Hook;
begin
 CreateControlsVariate;
 DesignElements;
end;

procedure TDMM6500MeasPar_BaseVoltShow.ObjectToSetting;
begin
 inherited ObjectToSetting;
 Hook;
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

{ TDMM6500_VoltageDigRangeShow }

constructor TDMM6500_VoltageDigRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeVoltDig,DMM6500,ChanNumber);
end;

procedure TDMM6500_VoltageDigRangeShow.OkClick;
begin
 fDMM6500.SetRange(TDMM6500_VoltageDigRange(Data+1),fChanNumber);
end;

{ TDMM6500_CurrentDigRangeShow }

constructor TDMM6500_CurrentDigRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeCurrentDig,DMM6500,ChanNumber);
end;

procedure TDMM6500_CurrentDigRangeShow.OkClick;
begin
 fDMM6500.SetRange(TDMM6500_CurrentDigRange(Data+2),fChanNumber);
end;

{ TDMM6500_CapacitanceRangeShow }

constructor TDMM6500_CapacitanceRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeCapacitance,DMM6500,ChanNumber);
end;

{ TDMM6500_CurrentACRangeShow }

constructor TDMM6500_CurrentACRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeCurrentAC,DMM6500,ChanNumber);
end;

{ TDMM6500_VoltageACRangeShow }

constructor TDMM6500_VoltageACRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeVoltAC,DMM6500,ChanNumber);
end;

{ TDMM6500_CurrentDCRangeShow }

constructor TDMM6500_CurrentDCRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeCurrentDC,DMM6500,ChanNumber);
end;

{ TDMM6500_VoltageDCRangeShow }

constructor TDMM6500_VoltageDCRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeVoltDC,DMM6500,ChanNumber);
end;

{ TDMM6500_Resistance2WRangeShow }

constructor TDMM6500_Resistance2WRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeResistance2W,DMM6500,ChanNumber);
end;

{ TDMM6500_Resistance4WRangeShow }

constructor TDMM6500_Resistance4WRangeShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(St,'Range',dm_pp_RangeResistance4W,DMM6500,ChanNumber);
end;

{ TDMM6500MeasPar_DigVoltShow }

procedure TDMM6500MeasPar_DigVoltShow.CreateControls;
begin
  inherited;

  fRangeShow:=TDMM6500_VoltageDigRangeShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fRangeShow);
  fBaseVoltDCShow:=TDMM6500MeasPar_BaseVoltDCShow.Create(fParent,fDMM6500,fChanNumber);
end;

procedure TDMM6500MeasPar_DigVoltShow.DesignElements;
begin
  inherited DesignElements;
  fBaseVoltDCShow.DesignElements;

  Resize(fBaseVoltDCShow.LVoltageUnit);
  RelativeLocation(STRange,fBaseVoltDCShow.LVoltageUnit,oRow,Marginbetween);
  fBaseVoltDCShow.LVoltageUnit.Top:=STRange.Top-2;
  RelativeLocation(fBaseVoltDCShow.LVoltageUnit,fBaseVoltDCShow.STVoltageUnit,oRow,MarginBetweenLST);
  fBaseVoltDCShow.STVoltageUnit.Top:=STRange.Top;

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

  fBaseVoltShow.LDB_DBM.Font.Color:=clTeal;
  fBaseVoltShow.STDB_DBM.Font.Color:=clTeal;

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

{ TDMM6500_LineSyncShow }

constructor TDMM6500_LineSyncShow.Create(CB: TCheckBox; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create(CB,'Line Sync',dm_pp_LineSync,DMM6500,ChanNumber);
end;

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
  fAzeroShow.HookParameterClick:=HookAzeroShow;
  BAzeroAuto.Caption := 'Refresh';
  BAzeroAuto.OnClick := RefreshZeroClick;
end;

procedure TDMM6500MeasPar_ContinuityBaseShow.CreateElements;
begin
  inherited;
  CBAzero:=TCheckBox.Create(fParent);
  Add(CBAzero);
  CBLineSync:=TCheckBox.Create(fParent);
  Add(CBLineSync);
  BAzeroAuto:=TButton.Create(fParent);
  Add(BAzeroAuto);
end;

procedure TDMM6500MeasPar_ContinuityBaseShow.DesignElements;
begin
  inherited DesignElements;
  Resize(CBLineSync);
  RelativeLocation(STCount,CBLineSync,oCol,Marginbetween);
  CBLineSync.Left:=MarginLeft;
  RelativeLocation(CBLineSync,CBAzero,oRow,MarginBetween);
//  Resize(BAzeroAuto);
//  BAzeroAuto.Width:=BAzeroAuto.Width+9;
  RelativeLocation(CBAzero,BAzeroAuto,oRow,MarginBetween);
  HookAzeroShow;
end;

procedure TDMM6500MeasPar_ContinuityBaseShow.HookAzeroShow;
begin
 BAzeroAuto.Enabled:=(not(CBAzero.Checked)) and CBAzero.Enabled;
end;

procedure TDMM6500MeasPar_ContinuityBaseShow.ObjectToSetting;
begin
  inherited;
  HookAzeroShow;
end;

procedure TDMM6500MeasPar_ContinuityBaseShow.RefreshZeroClick(Sender: TObject);
begin
 fDMM6500.AzeroOnce();
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

//  fParent.Width:=MarginRight+LMeaureTime.Left+LMeaureTime.Width;
  fParent.Width:=MarginRight+BAzeroAuto.Left+BAzeroAuto.Width;
  fParent.Height:=MarginTop+CBAzero.Top+CBAzero.Height;
end;

{ TDMM6500_BiasLevelShow }

constructor TDMM6500_BiasLevelShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Bias Level:',dm_dp_BiasLevel,DMM6500,ChanNumber);
end;

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

//  fParent.Width:=MarginRight+STRange.Left+LCount.Canvas.TextWidth('100 mkA');;
  fParent.Width:=MarginRight+BAzeroAuto.Left+BAzeroAuto.Width;

  fParent.Height:=MarginTop+CBAzero.Top+CBAzero.Height;
end;

{ TDMM6500MeasPar_BaseVoltDCRangeShow }

procedure TDMM6500MeasPar_BaseVoltDCRangeShow.CreateControls;
begin
  inherited;
  fRangeShow:=TDMM6500_VoltageDCRangeShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fRangeShow);
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
//  fParent.Width:=MarginRight+STRange.Left+LCount.Canvas.TextWidth('100 kOhm');
  fParent.Width:=MarginRight+BAzeroAuto.Left+BAzeroAuto.Width;
  fParent.Height:=MarginTop+CBAzero.Top+CBAzero.Height;
end;

{ TDMM6500_OpenLDShow }

constructor TDMM6500_OpenLDShow.Create(CB: TCheckBox; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
  inherited Create(CB,'Open Lead Detector',dm_pp_OpenLeadDetector,DMM6500,ChanNumber);
end;

{ TDMM6500_OffCompShow }

constructor TDMM6500_OffCompShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Offset Compensation:',dm_pp_OffsetCompen,DMM6500,ChanNumber);
end;

procedure TDMM6500_OffCompShow.OkClick;
begin
 fDMM6500.SetOffsetComp(TDMM6500_OffsetCompen(Data),fChanNumber);
 fHookParameterClick;
end;

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
  LOffComp.Font.Color:=clPurple;
  STOffComp.Font.Color:=clPurple;

  RelativeLocation(LOffComp,CBOpenLD,oCol,Marginbetween);
  CBOpenLD.Left:=MarginLeft;
end;

{ TDMM6500MeasPar_Res4WShow }

procedure TDMM6500MeasPar_Res4WShow.CreateControls;
begin
  inherited;
  fRangeShow:=TDMM6500_Resistance4WRangeShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fRangeShow);
  fOffCompShow.HookParameterClick:=HookForOffComp;
  fRangeShow.HookParameterClick:=HookForOffComp;
end;

procedure TDMM6500MeasPar_Res4WShow.DesignElements;
begin
  inherited;
//  fParent.Width:=MarginRight+STRange.Left+LCount.Canvas.TextWidth('100 kOhm');
  fParent.Width:=MarginRight+BAzeroAuto.Left+BAzeroAuto.Width;
fParent.Height:=MarginTop+CBOpenLD.Top+CBOpenLD.Height;
end;

procedure TDMM6500MeasPar_Res4WShow.HookForOffComp;
begin
 fRangeShow.ObjectToSetting;
end;

{ TDMM6500_VoltageRatioMethodShow }

constructor TDMM6500_VoltageRatioMethodShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Method:',dm_vrp_VRMethod,DMM6500,ChanNumber);
end;

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
  LVRMethod.Left:=MarginLeft;
  RelativeLocation(LVRMethod,STVRMethod,oRow,MarginBetweenLST);
  STVRMethod.Top:=LVRMethod.Top+1;

//  fParent.Width:=MarginRight+STRange.Left+LCount.Canvas.TextWidth('1000 V');
  fParent.Width:=MarginRight+BAzeroAuto.Left+BAzeroAuto.Width;
  fParent.Height:=MarginTop+LVRMethod.Top+LVRMethod.Height;
end;

{ TDMM6500_TransdTypeShow }

constructor TDMM6500_TempTransdTypeShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Temperature Source:',dm_tp_TransdType,DMM6500,ChanNumber);
end;

{ TDMM6500_TCoupleShow }

constructor TDMM6500_TCoupleShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Type:',dm_tp_TCoupleType,DMM6500,ChanNumber);
end;

{ TDMM6500_ThermistorTypeShow }

constructor TDMM6500_ThermistorTypeShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Type:',dm_tp_ThermistorType,DMM6500,ChanNumber);
end;

{ TDMM6500_W2RTDTypeShow }

constructor TDMM6500_W2RTDTypeShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Type:',dm_tp_W2RTDType,DMM6500,ChanNumber);
end;

{ TDMM6500_W3RTDTypeShow }

constructor TDMM6500_W3RTDTypeShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Type:',dm_tp_W3RTDType,DMM6500,ChanNumber);
end;

{ TDMM6500_W4RTDTypeShow }

constructor TDMM6500_W4RTDTypeShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Type:',dm_tp_W4RTDType,DMM6500,ChanNumber);
end;

{ TDMM6500_TCoupleRefJunctShow }

constructor TDMM6500_TCoupleRefJunctShow.Create(ST: TStaticText; L: Tlabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,L,'Ref Junction:',dm_tp_RefJunction,DMM6500,ChanNumber);
end;

{ TDMM6500_TemperatureUnitShow }

constructor TDMM6500_TemperatureUnitShow.Create(ST: TStaticText;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(ST,'TempUnit',dm_tp_UnitsTemp,DMM6500,ChanNumber);
end;

{ TDMM6500_SimRefTempShow }

constructor TDMM6500_RTDZeroShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_tp_RTDZero,DMM6500,ChanNumber,STD,STC,'RTD Zero',100);
 SetLimits(DMM6500_RTDZeroLimits);
end;

{ TDMM6500_SimRefTempShow }

constructor TDMM6500_SimRefTempShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_tp_SimRefTemp,DMM6500,ChanNumber,STD,STC,'Ref Temperature',
                DMM6500_RefTempInitValue[(DMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).Units],4);
 SetLimits(DMM6500_RefTempLimits[(fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).Units]);
end;

{ TDMM6500_RTDAlphaShow }

constructor TDMM6500_RTDAlphaShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_tp_RTDAlpha,DMM6500,ChanNumber,STD,STC,'RTD Alpha:',
                0.00385055,8);
 SetLimits(DMM6500_RTDAlphaLimits);
end;

{ TDMM6500_RTDBetaShow }

constructor TDMM6500_RTDBetaShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_tp_RTDBeta,DMM6500,ChanNumber,STD,STC,'RTD Beta:',
                0.10863,5);
 SetLimits(DMM6500_RTDBetaLimits);
end;

{ TDMM6500_RTDDeltaShow }

constructor TDMM6500_RTDDeltaShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_tp_RTDDelta,DMM6500,ChanNumber,STD,STC,'RTD Delta:',
                1.4999,4);
 SetLimits(DMM6500_RTDDeltaLimits);
end;

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

  RelativeLocation(fBaseVoltDCShow.LDB_DBM,fBaseVoltDCShow.LInputImpedance,oRow,MarginBetweenLST);
  RelativeLocation(fBaseVoltDCShow.LInputImpedance,fBaseVoltDCShow.STInputImpedance,oCol,MarginBetweenLST);
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
  inherited GetDataFromDevice;
  fBaseVoltDCShow.GetDataFromDevice;
end;

procedure TDMM6500MeasPar_VoltDCShow.ObjectToSetting;
begin
  inherited ObjectToSetting;
  fBaseVoltDCShow.ObjectToSetting;
end;

{ TDMM6500MeasPar_TemperShow }

procedure TDMM6500MeasPar_TemperShow.CreateControls;
begin
  inherited;
  fUnits:=TDMM6500_TemperatureUnitShow.Create(STRange,fDMM6500,fChanNumber);
  Add(fUnits);
  fUnits.HookParameterClick:=HookParameterClickUnits;


  fTransdTypeShow:=TDMM6500_TempTransdTypeShow.Create(STTransdType,LTransdType,fDMM6500,fChanNumber);
  Add(fTransdTypeShow);
  fTransdTypeShow.HookParameterClick:=Hook;

  fRTDDeltaShow:=TDMM6500_RTDDeltaShow.Create(STDelta,LDelta,fDMM6500,fChanNumber);
  Add(fRTDDeltaShow);
  fRTDDeltaShow.HookParameterClick:=HookParameterClickDelta;

  fRTDZeroShow:=TDMM6500_RTDZeroShow.Create(STZero,LZero,fDMM6500,fChanNumber);
  Add(fRTDZeroShow);
  fRTDZeroShow.HookParameterClick:=HookParameterClickZero;


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
   dm_ttCJC:begin
                if fW2RTDTypeShow <> nil then
                    FreeAndNil(fW2RTDTypeShow);
                if fW3RTDTypeShow <> nil then
                    FreeAndNil(fW3RTDTypeShow);
                if fW4RTDTypeShow <> nil then
                    FreeAndNil(fW4RTDTypeShow);
                if fTCoupleTypeShow <> nil then
                    FreeAndNil(fTCoupleTypeShow);
                if fThermistorTypeShow <> nil then
                    FreeAndNil(fThermistorTypeShow);
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
   dm_ttCJC:begin
                if fSimRefTemp <> nil then
                    FreeAndNil(fSimRefTemp);
                if fRefJunctionShow <> nil then
                    FreeAndNil(fRefJunctionShow);
                if fRTDAlphaShow <> nil then
                    FreeAndNil(fRTDAlphaShow);
                if fRTDBetaShow <> nil then
                    FreeAndNil(fRTDBetaShow);
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
 OpenLeadOffsetCompState;
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
  Hook;
end;

procedure TDMM6500MeasPar_TemperShow.OpenLeadOffsetCompState;
begin
  case (fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).TransdType of
   dm_ttCouple:begin
                 CBOpenLD.Enabled:=True;
                 SetOffCompEnable(False);
               end;
   dm_ttTherm,
   dm_ttCJC :begin
                 CBOpenLD.Enabled:=False;
                 SetOffCompEnable(False);
              end;
   dm_tt2WRTD:begin
                 CBOpenLD.Enabled:=False;
                 SetOffCompEnable(False);
                 (fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).OffsetComp:=dm_ocOff;
                 fOffCompShow.ObjectToSetting;
                 (fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_Temper).OpenLeadDetector:=false;
                 fOpenLDShow.ObjectToSetting;
               end;
   dm_tt3WRTD,
   dm_tt4WRTD:begin
                CBOpenLD.Enabled:=True;
                SetOffCompEnable(True);
              end;
  end;

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

procedure TDMM6500MeasPar_TemperShow.SetOffCompEnable(Value: boolean);
begin
  STOffComp.Enabled:=Value;
  LOffComp.Enabled:=Value;
end;

procedure TDMM6500MeasPar_TemperShow.SetTypeEnable(Value: boolean);
begin
  STType.Enabled:=Value;
  LType.Enabled:=Value;
end;

{ TDMM6500_ChannelClose }

procedure TDMM6500_ChannelCloseShow.Click(Sender: TObject);
begin
 if fCB.Checked then fDMM6500.SetChannelCloseHard(fChanNumber)
                else fDMM6500.SetChannelOpenHard(fChanNumber);
 fHookParameterClick;
end;

constructor TDMM6500_ChannelCloseShow.Create(CB: TCheckBox; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
  inherited Create(CB,'Closed',dm_pp_OpenLeadDetector,DMM6500,ChanNumber);
end;

procedure TDMM6500_ChannelCloseShow.GetDataFromDevice;
begin
 fDMM6500.GetChannelState(fChanNumber);
end;

procedure TDMM6500_ChannelCloseShow.ObjectToSetting;
begin
 SetValue(fDMM6500.ChansMeasure[fChanNumber-1].IsClosed);
end;

{ TDMM6500_DelayAfterCloseShow }

constructor TDMM6500_DelayAfterCloseShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(dm_tp_RTDDelta,DMM6500,ChanNumber,STD,STC,'Delay After Close:',
                0,5);
 SetLimits(DMM6500_DelayAfterCloseLimits);
end;

procedure TDMM6500_DelayAfterCloseShow.GetDataFromDevice;
begin
  fDMM6500.GetDelayAfterClose(fChanNumber);
end;

procedure TDMM6500_DelayAfterCloseShow.ObjectToSetting;
begin
  Data:=fDMM6500.ChansMeasure[fChanNumber-1].DelayAfterClose;
end;

procedure TDMM6500_DelayAfterCloseShow.OkClick;
begin
  fDMM6500.SetDelayAfterClose(Data,fChanNumber);
  fHookParameterClick;
end;

{ TControlElementsWithWindowCreate }

procedure TControlElementsWithWindowCreate.CreateFormFooter(
  const bOkTot: integer);
begin
   fGBInFormShow.Top:=0;
   fGBInFormShow.Left:=0;

   fBOk.Parent:=fShowForm;
   fBOk.Left:=round((fGBInFormShow.Width-fBOk.Width)/2);
   fBOk.Top:=bOkTot;

   fShowForm.Width:=fGBInFormShow.Width+25;
   fShowForm.Height:=fBOk.Top+fBOk.Height+35;
end;

procedure TControlElementsWithWindowCreate.CreateFormHeader(
  const FormName: string);
begin
  fShowForm := TForm.Create(Application);
  fShowForm.Position := poMainFormCenter;
  fShowForm.AutoScroll := True;
  fShowForm.BorderIcons := [biSystemMenu];
  fShowForm.ParentFont := True;
  fShowForm.Font.Style := [fsBold];
  fShowForm.Caption := FormName;
  fShowForm.Color := clLtGray;

  fBOk:=TButton.Create(fShowForm);
  fBOk.ModalResult:=mrOK;
  fBOk.Caption:='OK';

  fGBInFormShow:=TGroupBox.Create(fShowForm);
  fGBInFormShow.Parent:=fShowForm;
end;

procedure TControlElementsWithWindowCreate.FormShowFooter;
begin
 fBOk.Parent:=nil;
 fBOk.Free;

 fGBInFormShow.Parent:=nil;
 fGBInFormShow.Free;

 fShowForm.Hide;
 fShowForm.Release;
end;

{ TDMM6500ScanParameters }

procedure TDMM6500ScanParameters.CreateControls;
begin
  fBInit.OnClick:=OptionButtonClick;
  fBAbort.OnClick:=OptionButtonClick;
  fBAdd.OnClick:=OptionButtonClick;
  fBClear.OnClick:=OptionButtonClick;
  fBOption.OnClick:=OptionButtonClick;
end;

procedure TDMM6500ScanParameters.CreateElements;
begin
  fBInit:=TButton.Create(fParent);
  fBAbort:=TButton.Create(fParent);
  fBAdd:=TButton.Create(fParent);
  fBClear:=TButton.Create(fParent);
  fBOption:=TButton.Create(fParent);
  fMemo:=TMemo.Create(fParent);
  fBInit.Name:='Init';
  fBAbort.Name:='Abort';
  fBClear.Name:='Clear';
  fBAdd.Name:='Add';
  fBOption.Name:='Option';
  fST:=TStringList.Create;
end;

procedure TDMM6500ScanParameters.DesignElements;
begin
  fBInit.Parent:=fParent;
  fBInit.Caption:=fBInit.Name;
  fBInit.Top:=MarginTop;
  fBInit.Left:=MarginLeft;
  fBInit.Width:=round(0.7*fBInit.Width);

  fBAbort.Parent:=fParent;
  fBAbort.Width:=fBInit.Width;
  RelativeLocation(fBInit,fBAbort,oRow,Marginbetween);

  fBAdd.Parent:=fParent;
  fBAdd.Width:=fBInit.Width;
  RelativeLocation(fBInit,fBAdd,oCol,Marginbetween);

  fBClear.Parent:=fParent;
  fBClear.Width:=fBInit.Width;
  RelativeLocation(fBAdd,fBClear,oRow,Marginbetween);

  fBOption.Parent:=fParent;
  RelativeLocation(fBAdd,fBOption,oCol,Marginbetween);
  fBAdd.Left:=fBInit.Left;

  fMemo.Parent:=fParent;
  fMemo.ScrollBars:=ssVertical;
  fMemo.Width:=round(1.5*fBOption.Width);
  fMemo.Height:=round(1.5*fBOption.Height);
  RelativeLocation(fBOption,fMemo,oCol,Marginbetween);

  fParent.Width:=MarginRight+fBAbort.Left+fBAbort.Width;
  fParent.Height:=MarginTop+fMemo.Top+fMemo.Height;

end;

procedure TDMM6500ScanParameters.DestroyControls;
begin

end;

procedure TDMM6500ScanParameters.DestroyElements;
begin
////  fBCreate.Free;
  fBInit.Free;
  fBAbort.Free;
  fBAdd.Free;
  fBClear.Free;
  fBOption.Free;
  fMemo.Free;
  fST.Free;
end;

procedure TDMM6500ScanParameters.FormShow;
begin

end;

procedure TDMM6500ScanParameters.GetDataFromDevice;
begin
 fDMM6500.ScanGetChannels;
end;

procedure TDMM6500ScanParameters.MemoFilling;
begin
  fMemo.Text := fDMM6500.Scan.ChannelsToString;
  if assigned(fScanParametrWindowShow) then
    fScanParametrWindowShow.Memo.Text := fDMM6500.Scan.ChannelsToString;
end;

procedure TDMM6500ScanParameters.ObjectToSetting;
 var i:byte;
begin
 fST.Clear;
 for I := fDMM6500.FirstChannelInSlot to fDMM6500.LastChannelInSlot do
   fST.Add(inttostr(i));
 MemoFilling;
end;

procedure TDMM6500ScanParameters.OptionButtonClick(Sender: TObject);
 var i:integer;
begin
 if (Sender as TButton).Name='Init'
    then fDMM6500.Init;

 if (Sender as TButton).Name='Abort'
    then fDMM6500.Abort;

 if (Sender as TButton).Name='Clear'
     then
      begin
      fDMM6500.ScanClear;
      MemoFilling;
      end;


 if (Sender as TButton).Name='Add'
    then begin
          i:=SelectFromVariants(fST,-1,'Choose channel to add');
          if i>-1 then
            begin
             fDMM6500.ScanAddChan(i+1);
             MemoFilling;
            end;
         end;

 if (Sender as TButton).Name='Option'
    then FormShow;

end;

{ TDMM6500_ScanCountShow }

constructor TDMM6500_ScanCountShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500);
begin
 inherited Create(dm_pp_SampleRate,DMM6500,0,STD,STC,'Scan Count',1);
 SetLimits(DMM6500_ScanCountLimits);
end;

procedure TDMM6500_ScanCountShow.GetDataFromDevice;
begin
 fDMM6500.ScanGetCount;
end;

procedure TDMM6500_ScanCountShow.ObjectToSetting;
begin
 Data:=fDMM6500.Scan.Count;
end;

procedure TDMM6500_ScanCountShow.OkClick;
begin
 fDMM6500.ScanSetCount(Data);
end;

{ TDMM6500_ScanIntervalShow }

constructor TDMM6500_ScanIntervalShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500);
begin
 inherited Create(dm_tp_RTDDelta,DMM6500,0,STD,STC,'Scans Interval, s:',
                0,5);
 SetLimits(DMM6500_ScanIntervalLimits);
end;

procedure TDMM6500_ScanIntervalShow.GetDataFromDevice;
begin
 fDMM6500.ScanGetInterval;
end;

procedure TDMM6500_ScanIntervalShow.ObjectToSetting;
begin
 Data:=fDMM6500.Scan.Interval;
end;

procedure TDMM6500_ScanIntervalShow.OkClick;
begin
 fDMM6500.ScanSetInterval(Data);
 fHookParameterClick;
end;

{ TDMM6500_ScanMeasIntervalShow }

constructor TDMM6500_ScanMeasIntervalShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500);
begin
 inherited Create(dm_tp_RTDDelta,DMM6500,0,STD,STC,'Measures in Scan Interval, s:',
                0,5);
 SetLimits(DMM6500_ScanIntervalLimits);
end;

procedure TDMM6500_ScanMeasIntervalShow.GetDataFromDevice;
begin
 fDMM6500.ScanGetMeasInterval;
end;

procedure TDMM6500_ScanMeasIntervalShow.ObjectToSetting;
begin
 Data:=fDMM6500.Scan.MeasInterval;
end;

procedure TDMM6500_ScanMeasIntervalShow.OkClick;
begin
 fDMM6500.ScanSetMeasInterval(Data);
 fHookParameterClick;
end;

{ TDMM6500_ScanMonitorLimitLower }

constructor TDMM6500_ScanMonitorLimitLower.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500);
begin
 inherited Create(dm_tp_RTDDelta,DMM6500,0,STD,STC,'Monitor Lower Limit:',
                0,5);
end;

procedure TDMM6500_ScanMonitorLimitLower.GetDataFromDevice;
begin
 fDMM6500.ScanMonitorGetLimitLower;
end;

procedure TDMM6500_ScanMonitorLimitLower.ObjectToSetting;
begin
 Data:=fDMM6500.Scan.MonitorLimitLower;
end;

procedure TDMM6500_ScanMonitorLimitLower.OkClick;
begin
 fDMM6500.ScanMonitorSetLimitLower(Data);
 ObjectToSetting;
 fHookParameterClick;
end;

{ TDMM6500_ScanMonitorLimitUpper }

constructor TDMM6500_ScanMonitorLimitUpper.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500);
begin
 inherited Create(dm_tp_RTDDelta,DMM6500,0,STD,STC,'Monitor Upper Limit:',
                0,5);
end;

procedure TDMM6500_ScanMonitorLimitUpper.GetDataFromDevice;
begin
 fDMM6500.ScanMonitorGetLimitUpper;
end;

procedure TDMM6500_ScanMonitorLimitUpper.ObjectToSetting;
begin
 Data:=fDMM6500.Scan.MonitorLimitUpper;
end;

procedure TDMM6500_ScanMonitorLimitUpper.OkClick;
begin
 fDMM6500.ScanMonitorSetLimitUpper(Data);
 ObjectToSetting;
 fHookParameterClick;
end;

{ TDMM6500_ScanMonitorChanShow }

constructor TDMM6500_ScanMonitorChanShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500);
begin
 inherited Create(dm_pp_SampleRate,DMM6500,0,STD,STC,'Monitor Channel:',1);
 SetLimits(fDMM6500.FirstChannelInSlot,fDMM6500.LastChannelInSlot);
end;

procedure TDMM6500_ScanMonitorChanShow.GetDataFromDevice;
begin
 fDMM6500.ScanMonitorGetChan;
end;

procedure TDMM6500_ScanMonitorChanShow.ObjectToSetting;
begin
 Data:=fDMM6500.Scan.MonitorChannel;
end;

procedure TDMM6500_ScanMonitorChanShow.OkClick;
begin
 fDMM6500.ScanMonitorSetChan(Data);
 fHookParameterClick;
end;

{ TDMM6500_ScanMonitorModeShow }

constructor TDMM6500_ScanMonitorModeShow.Create(STD: TStaticText; STC: TLabel;
  DMM6500: TDMM6500);
begin

end;

procedure TDMM6500_ScanMonitorModeShow.GetDataFromDevice;
begin
 fDMM6500.ScanMonitorGetMode;
end;

procedure TDMM6500_ScanMonitorModeShow.ObjectToSetting;
begin
  Data:=ord(fDMM6500.Scan.MonitorMode);
end;

procedure TDMM6500_ScanMonitorModeShow.OkClick;
begin
 fDMM6500.ScanMonitorSetMode(TKeitley_ScanLimitType(Data));
 fHookParameterClick;
end;

procedure TDMM6500_ScanMonitorModeShow.SettingsShowSLFilling;
 var i:TKeitley_ScanLimitType;
begin
 for I := Low(TKeitley_ScanLimitType) to High(TKeitley_ScanLimitType) do
    fSettingsShowSL.Add(DMM6500_ScanMonitorModeLabel[i]);
end;

{ TDMM6500ScanParametrWindowShow }

constructor TDMM6500ScanParametrWindowShow.Create(Parent: TGroupBox;
  DMM6500: TDMM6500; ScanParameters: TDMM6500ScanParameters);
begin
 inherited Create(Parent,DMM6500);
 fScanParameters:=ScanParameters;
end;

procedure TDMM6500ScanParametrWindowShow.CreateControls;
begin
  BAdd.OnClick:=fScanParameters.OptionButtonClick;
  BClear.OnClick:=fScanParameters.OptionButtonClick;

  fMonitorChanShow:=TDMM6500_ScanMonitorChanShow.Create(STMonitorChan,LMonitorChan,fDMM6500);
  fCountShow:=TDMM6500_ScanCountShow.Create(STCount,LCount,fDMM6500);;
  fMonitorModeShow:=TDMM6500_ScanMonitorModeShow.Create(STMonitorMode,LMonitorMode,fDMM6500);;
  fIntervalShow:=TDMM6500_ScanIntervalShow.Create(STInterval,LInterval,fDMM6500);;
  fMonitorLimitUpperShow:=TDMM6500_ScanMonitorLimitUpper.Create(STMonitorLimitUpper,LMonitorLimitUpper,fDMM6500);;
  fMonitorLimitLowerShow:=TDMM6500_ScanMonitorLimitLower.Create(STMonitorLimitLower,LMonitorLimitLower,fDMM6500);;
  fMeasIntervalShow:=TDMM6500_ScanMeasIntervalShow.Create(STMeasInterval,LMeasInterval,fDMM6500);;
  Add(fMonitorChanShow);
  Add(fCountShow);
  Add(fMonitorModeShow);
  Add(fIntervalShow);
  Add(fMonitorLimitUpperShow);
  Add(fMonitorLimitLowerShow);
  Add(fMeasIntervalShow);
  fMonitorModeShow.HookParameterClick:=HookParameterMonitorMode;
end;

procedure TDMM6500ScanParametrWindowShow.CreateElements;
begin
  STCount:=TStaticText.Create(fParent);
  Add(STCount);
  LCount:=TLabel.Create(fParent);
  Add(LCount);
  STMonitorChan:=TStaticText.Create(fParent);
  Add(STMonitorChan);
  LMonitorChan:=TLabel.Create(fParent);
  Add(LMonitorChan);
  STMonitorMode:=TStaticText.Create(fParent);
  Add(STMonitorMode);
  LMonitorMode:=TLabel.Create(fParent);
  Add(LMonitorMode);
  STInterval:=TStaticText.Create(fParent);
  Add(STInterval);
  LInterval:=TLabel.Create(fParent);
  Add(LInterval);
  STMeasInterval:=TStaticText.Create(fParent);
  Add(STMeasInterval);
  LMeasInterval:=TLabel.Create(fParent);
  Add(LMeasInterval);
  STMonitorLimitUpper:=TStaticText.Create(fParent);
  Add(STMonitorLimitUpper);
  LMonitorLimitUpper:=TLabel.Create(fParent);
  Add(LMonitorLimitUpper);
  STMonitorLimitLower:=TStaticText.Create(fParent);
  Add(STMonitorLimitLower);
  LMonitorLimitLower:=TLabel.Create(fParent);
  Add(LMonitorLimitLower);
  BAdd:=TButton.Create(fParent);
  Add(BAdd);
  BClear:=TButton.Create(fParent);
  Add(BClear);
  BClear.Name:='Clear';
  BAdd.Name:='Add';
  Memo:=TMemo.Create(fParent);
  Add(Memo);
end;

procedure TDMM6500ScanParametrWindowShow.DesignElements;
begin
 inherited DesignElements;

 BAdd.Top:=MarginTop;
 BAdd.Left:=MarginLeft;
 RelativeLocation(BClear,BAdd,oRow,Marginbetween);

 Memo.ScrollBars:=ssVertical;
 Memo.Width:=round(1.5*BAdd.Width);
 Memo.Height:=round(1.5*BAdd.Height);
 RelativeLocation(BAdd,Memo,oCol,Marginbetween);

 STCount.Font.Color:=clGreen;
 LCount.Font.Color:=clGreen;
 RelativeLocation(Memo,LCount,oCol,Marginbetween);
 RelativeLocation(LCount,STCount,oRow,Marginbetween);
 STCount.Top:=LCount.Top;

 STInterval.Font.Color:=clRed;
 LInterval.Font.Color:=clRed;
 RelativeLocation(LCount,LInterval,oCol,Marginbetween);
 RelativeLocation(LInterval,STInterval,oRow,Marginbetween);
 STInterval.Top:=LInterval.Top;

 STMeasInterval.Font.Color:=clBlue;
 LMeasInterval.Font.Color:=clRed;
 RelativeLocation(LInterval,LMeasInterval,oCol,Marginbetween);
 RelativeLocation(LMeasInterval,STMeasInterval,oRow,Marginbetween);
 STMeasInterval.Top:=LMeasInterval.Top

// STMeasInterval.Font.Color:=clBlue;
// LMeasInterval.Font.Color:=clRed;
// RelativeLocation(LInterval,LMeasInterval,oCol,Marginbetween);
// RelativeLocation(LMeasInterval,STMeasInterval,oRow,Marginbetween);
// STMeasInterval.Top:=LMeasInterval.Top
//
//
//  STMonitorChan:TStaticText;
//  LMonitorChan:TLabel;
//  STMonitorMode:TStaticText;
//  LMonitorMode:TLabel;
//  STMonitorLimitUpper:TStaticText;
//  LMonitorLimitUpper:TLabel;
//  STMonitorLimitLower:TStaticText;
//  LMonitorLimitLower:TLabel;


 HookParameterMonitorMode;
end;

procedure TDMM6500ScanParametrWindowShow.HookParameterMonitorMode;
begin
  STMonitorChan.Enabled:=(fDMM6500.Scan.MonitorMode<>kt_tlt_off);
  LMonitorChan.Enabled:=STMonitorChan.Enabled;
  STMonitorLimitUpper.Enabled:=STMonitorChan.Enabled;
  LMonitorLimitUpper.Enabled:=STMonitorChan.Enabled;
  STMonitorLimitLower.Enabled:=STMonitorChan.Enabled;
  LMonitorLimitLower.Enabled:=STMonitorChan.Enabled;
end;

end.
