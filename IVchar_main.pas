unit IVchar_main;

interface

uses
  Windows, Messages, SysUtils, Graphics, Forms,SPIdevice, IniFiles,PacketParameters,
  OlegType, OlegMath,Measurement,
  TempThread, ShowTypes,OlegGraph, Dependence, V7_21,
  TemperatureSensor, DACR2R, UT70, RS232device,ET1255, RS232_Mediator_Tread,
  CPortCtl, Grids, Chart, TeeProcs, Series, TeEngine, ExtCtrls, Buttons,
  ComCtrls, CPort, StdCtrls, Dialogs, Controls, Classes, D30_06,Math, PID, 
  MDevice, Spin,HighResolutionTimer, MCP3424;

const
  MeasIV='IV characteristic';
  MeasR2RCalib='R2R-DAC Calibration';
  MeasTimeD='Time dependence';
  MeasTwoTimeD='Time two dependence';
  MeasControlParametr='Controller on time';
  MeasTempOnTime='Temperature on time';
  MeasIscAndVocOnTime='Voc and Isc on time';

  MD_IniSection='Sources';

  IscVocTimeToWait=1000;


type
  TIVchar = class(TForm)
    ComPort1: TComPort;
    PC: TPageControl;
    TS_Main: TTabSheet;
    TS_B7_21A: TTabSheet;
    BBClose: TBitBtn;
    LConnected: TLabel;
    BConnect: TButton;
    LV721A: TLabel;
    RGV721A_MM: TRadioGroup;
    RGV721ARange: TRadioGroup;
    BV721AMeas: TButton;
    SBV721AAuto: TSpeedButton;
    Time: TTimer;
    LV721AU: TLabel;
    TS_B7_21: TTabSheet;
    PanelV721_I: TPanel;
    RGV721I_MM: TRadioGroup;
    ComDPacket: TComDataPacket;
    BParamReceive: TButton;
    PanelV721_II: TPanel;
    RGV721II_MM: TRadioGroup;
    RGV721IRange: TRadioGroup;
    RGV721IIRange: TRadioGroup;
    LV721I: TLabel;
    LV721IU: TLabel;
    LV721II: TLabel;
    LV721IIU: TLabel;
    BV721IMeas: TButton;
    BV721IIMeas: TButton;
    SBV721IAuto: TSpeedButton;
    SBV721IIAuto: TSpeedButton;
    TS_DAC: TTabSheet;
    TS_Setting: TTabSheet;
    ChLine: TChart;
    ForwLine: TPointSeries;
    RevLine: TPointSeries;
    ChLg: TChart;
    ForwLg: TPointSeries;
    RevLg: TPointSeries;
    GBIV: TGroupBox;
    CBForw: TCheckBox;
    CBRev: TCheckBox;
    BIVStart: TButton;
    BIVStop: TButton;
    GBAD: TGroupBox;
    BIVSave: TButton;
    LADVoltage: TLabel;
    LADVoltageValue: TLabel;
    LADCurrent: TLabel;
    LADCurrentValue: TLabel;
    LADRange: TLabel;
    GBT: TGroupBox;
    SBTAuto: TSpeedButton;
    LTRunning: TLabel;
    LTRValue: TLabel;
    LTLast: TLabel;
    LTLastValue: TLabel;
    GBFB: TGroupBox;
    PBIV: TProgressBar;
    UDFBHighLimit: TUpDown;
    LFBHighlimitValue: TLabel;
    STFBhighlimit: TStaticText;
    UDFBLowLimit: TUpDown;
    LFBLowlimitValue: TLabel;
    STFBlowlimit: TStaticText;
    PanelSplit: TPanel;
    SGFBStep: TStringGrid;
    BFBEdit: TButton;
    BFBDelete: TButton;
    BFBAdd: TButton;
    STFBSteps: TStaticText;
    STFBDelay: TStaticText;
    LFBDelayValue: TLabel;
    BFBDelayInput: TButton;
    GBRB: TGroupBox;
    LRBHighlimitValue: TLabel;
    LRBLowlimitValue: TLabel;
    LRBDelayValue: TLabel;
    STRBSteps: TStaticText;
    UDRBHighLimit: TUpDown;
    STRBhighlimit: TStaticText;
    UDRBLowLimit: TUpDown;
    STRBlowlimit: TStaticText;
    SGRBStep: TStringGrid;
    BRBEdit: TButton;
    BRBDelete: TButton;
    BRBAdd: TButton;
    STRBDelay: TStaticText;
    BRBDelayInput: TButton;
    BSaveSetting: TButton;
    PanelDACChA: TPanel;
    STChA: TStaticText;
    CBDAC: TComboBox;
    LDACPinC: TLabel;
    BDACSetC: TButton;
    LDACPinG: TLabel;
    BDACSetG: TButton;
    LDACPinLDAC: TLabel;
    BDACSetLDAC: TButton;
    LDACPinCLR: TLabel;
    BDACSetCLR: TButton;
    STORChA: TStaticText;
    LORChA: TLabel;
    CBORChA: TComboBox;
    BORChA: TButton;
    LPowChA: TLabel;
    BBPowChA: TBitBtn;
    BDACInit: TButton;
    BDACReset: TButton;
    LOVChA: TLabel;
    BOVchangeChA: TButton;
    BOVsetChA: TButton;
    PanelDACChB: TPanel;
    LORChB: TLabel;
    LPowChB: TLabel;
    LOVChB: TLabel;
    STChB: TStaticText;
    STORChB: TStaticText;
    CBORChB: TComboBox;
    BORChB: TButton;
    BBPowChB: TBitBtn;
    STOVChB: TStaticText;
    BOVchangeChB: TButton;
    BOVsetChB: TButton;
    STOVChA: TStaticText;
    GBMeasChA: TGroupBox;
    RBMeasSimChA: TRadioButton;
    RBMeasMeasChA: TRadioButton;
    CBMeasChA: TComboBox;
    LMeasChA: TLabel;
    BMeasChA: TButton;
    GBMeasChB: TGroupBox;
    LMeasChB: TLabel;
    RBMeasSimChB: TRadioButton;
    RBMeasMeasChB: TRadioButton;
    CBMeasChB: TComboBox;
    BMeasChB: TButton;
    RGDO: TRadioGroup;
    SaveDialog: TSaveDialog;
    GBCOM: TGroupBox;
    ComCBPort: TComComboBox;
    ComCBBR: TComComboBox;
    STCOMP: TStaticText;
    STComBR: TStaticText;
    TS_DACR2R: TTabSheet;
    STOVDACR2R: TStaticText;
    LOVDACR2R: TLabel;
    BOVchangeDACR2R: TButton;
    BOVsetDACR2R: TButton;
    GBMeasR2R: TGroupBox;
    LMeasR2R: TLabel;
    BMeasR2R: TButton;
    BDACR2RReset: TButton;
    BDFFA_R2R: TButton;
    OpenDialog: TOpenDialog;
    BOKsetDACR2R: TButton;
    STTD: TStaticText;
    CBVS: TComboBox;
    GBDS: TGroupBox;
    STVMD: TStaticText;
    STVS: TStaticText;
    STCMD: TStaticText;
    STMDR2R: TStaticText;
    CBTD: TComboBox;
    CBVMD: TComboBox;
    CBCMD: TComboBox;
    CBMeasDACR2R: TComboBox;
    GBCalibrR2R: TGroupBox;
    STFBhighlimitR2R: TStaticText;
    LFBHighlimitValueR2R: TLabel;
    UDFBHighLimitR2R: TUpDown;
    STFBlowlimitR2R: TStaticText;
    LFBLowlimitValueR2R: TLabel;
    UDFBLowLimitR2R: TUpDown;
    GBCalibrR2RPV: TGroupBox;
    GBCalibrR2RNV: TGroupBox;
    LRBHighlimitValueR2R: TLabel;
    LRBLowlimitValueR2R: TLabel;
    STRBhighlimitR2R: TStaticText;
    STRBlowlimitR2R: TStaticText;
    UDRBHighLimitR2R: TUpDown;
    UDRBLowLimitR2R: TUpDown;
    STOKDACR2R: TStaticText;
    LOKDACR2R: TLabel;
    BOKchangeDACR2R: TButton;
    LADInputVoltage: TLabel;
    LADInputVoltageValue: TLabel;
    CBCurrentValue: TCheckBox;
    CBPC: TCheckBox;
    GBDS18B: TGroupBox;
    TS_Temper: TTabSheet;
    CBVtoI: TCheckBox;
    TS_UT70: TTabSheet;
    PanelUT70B: TPanel;
    LUT70B: TLabel;
    LUT70BU: TLabel;
    SBUT70BAuto: TSpeedButton;
    RGUT70B_MM: TRadioGroup;
    RGUT70B_Range: TRadioGroup;
    BUT70BMeas: TButton;
    RGUT70B_RangeM: TRadioGroup;
    STUT70BRort: TStaticText;
    ComCBUT70BPort: TComComboBox;
    ComPortUT70B: TComPort;
    LUT70BPort: TLabel;
    LPR: TLabel;
    STPR: TStaticText;
    STMC: TStaticText;
    LMC: TLabel;
    LMinC: TLabel;
    STMinC: TStaticText;
    STFVP: TStaticText;
    LFVP: TLabel;
    STRVP: TStaticText;
    LRVP: TLabel;
    STRVtoI: TStaticText;
    LRVtoI: TLabel;
    LVVtoI: TLabel;
    STVVtoI: TStaticText;
    LTMI: TLabel;
    STTMI: TStaticText;
    GBThermocouple: TGroupBox;
    STTCV: TStaticText;
    CBTcVMD: TComboBox;
    STMD: TStaticText;
    TS_ET1255: TTabSheet;
    PET1255DAC: TPanel;
    STDAC: TStaticText;
    GBET1255DACh0: TGroupBox;
    LOV1255ch0: TLabel;
    BOVset1255Ch0: TButton;
    BOVchange1255Ch0: TButton;
    BReset1255Ch0: TButton;
    LOK1255Ch0: TLabel;
    BOKchange1255Ch0: TButton;
    BOKset1255Ch0: TButton;
    GBMeas1255Ch0: TGroupBox;
    LMeas1255Ch0: TLabel;
    BMeas1255Ch0: TButton;
    STMD1255Ch0: TStaticText;
    CBMeasET1255Ch0: TComboBox;
    GBET1255DACh1: TGroupBox;
    LOV1255ch1: TLabel;
    LOK1255Ch1: TLabel;
    BOVset1255Ch1: TButton;
    BOVchange1255Ch1: TButton;
    BReset1255Ch1: TButton;
    BOKchange1255Ch1: TButton;
    BOKset1255Ch1: TButton;
    GBMeas1255Ch1: TGroupBox;
    LMeas1255Ch1: TLabel;
    BMeas1255Ch1: TButton;
    STMD1255Ch1: TStaticText;
    CBMeasET1255Ch1: TComboBox;
    GBET1255DACh2: TGroupBox;
    LOV1255ch2: TLabel;
    LOK1255Ch2: TLabel;
    BOVset1255Ch2: TButton;
    BOVchange1255Ch2: TButton;
    BReset1255Ch2: TButton;
    BOKchange1255Ch2: TButton;
    BOKset1255Ch2: TButton;
    GBMeas1255Ch2: TGroupBox;
    LMeas1255Ch2: TLabel;
    BMeas1255Ch2: TButton;
    STMD1255Ch2: TStaticText;
    CBMeasET1255Ch2: TComboBox;
    DependTimer: TTimer;
    CBMeasurements: TComboBox;
    TS_Time_Dependence: TTabSheet;
    STTimeMD: TStaticText;
    CBTimeMD: TComboBox;
    LTimeInterval: TLabel;
    STTimeInterval: TStaticText;
    LTimeDuration: TLabel;
    STTimeDuration: TStaticText;
    GBCSetup: TGroupBox;
    CBControlCD: TComboBox;
    STControl_CD: TStaticText;
    CBControlMD: TComboBox;
    STControl_MD: TStaticText;
    STControlNV: TStaticText;
    LControlNV: TLabel;
    LControlCV: TLabel;
    STControlKi: TStaticText;
    LControlInterval: TLabel;
    SBControlBegin: TSpeedButton;
    LControlCVValue: TLabel;
    LControlTolerance: TLabel;
    STControlKp: TStaticText;
    LControlKp: TLabel;
    STControlInterval: TStaticText;
    LControlKi: TLabel;
    STControlKd: TStaticText;
    LControlKd: TLabel;
    BControlReset: TButton;
    GBTermostat: TGroupBox;
    LTermostatNT: TLabel;
    LTermostatCT: TLabel;
    SBTermostat: TSpeedButton;
    LTermostatCTValue: TLabel;
    LTermostatTolerance: TLabel;
    LTermostatKp: TLabel;
    LTermostatKi: TLabel;
    LTermostatKd: TLabel;
    CBTermostatCD: TComboBox;
    STTermostatCD: TStaticText;
    STTermostatNT: TStaticText;
    STTermostatKi: TStaticText;
    STTermostatKp: TStaticText;
    STTermostatKd: TStaticText;
    BTermostatReset: TButton;
    LControlCCV: TLabel;
    LControlCCValue: TLabel;
    LTermostatOutputValue: TLabel;
    TS_D30_06: TTabSheet;
    RGD30: TRadioGroup;
    GBMeasD30: TGroupBox;
    LMeasD30: TLabel;
    BMeasD30: TButton;
    STMDD30: TStaticText;
    CBMeasD30: TComboBox;
    LOVD30: TLabel;
    STOVD30: TStaticText;
    BOVchangeD30: TButton;
    BOVsetD30: TButton;
    BD30Reset: TButton;
    STOKD30: TStaticText;
    LOKD30: TLabel;
    BOKchangeD30: TButton;
    BOKsetD30: TButton;
    LCodeRangeDACR2R: TLabel;
    LValueRangeDACR2R: TLabel;
    LCodeRangeD30: TLabel;
    LValueRangeD30: TLabel;
    LValueRangeDAC1255: TLabel;
    LCodeRangeDAC1255: TLabel;
    STTimeMD2: TStaticText;
    CBTimeMD2: TComboBox;
    CBFvsS: TCheckBox;
    ComPortUT70C: TComPort;
    PanelUT70C: TPanel;
    LUT70C: TLabel;
    LUT70CU: TLabel;
    SBUT70CAuto: TSpeedButton;
    LUT70CPort: TLabel;
    RGUT70C_MM: TRadioGroup;
    RGUT70C_Range: TRadioGroup;
    BUT70CMeas: TButton;
    RGUT70C_RangeM: TRadioGroup;
    STUT70CRort: TStaticText;
    ComCBUT70CPort: TComComboBox;
    LUT70C_rec: TLabel;
    LUT70C_Hold: TLabel;
    LUT70C_AVG: TLabel;
    LUT70C_AvTime: TLabel;
    GBIscVoc: TGroupBox;
    CBVocMD: TComboBox;
    CBIscMD: TComboBox;
    STControlIsc: TStaticText;
    STIsc: TStaticText;
    STVoc: TStaticText;
    BIscMeasure: TButton;
    LIscResult: TLabel;
    LVocResult: TLabel;
    BVocMeasure: TButton;
    BIscVocPinChange: TButton;
    GBET1255DACh3: TGroupBox;
    LOV1255ch3: TLabel;
    LOK1255Ch3: TLabel;
    BOVset1255Ch3: TButton;
    BOVchange1255Ch3: TButton;
    BReset1255Ch3: TButton;
    BOKchange1255Ch3: TButton;
    BOKset1255Ch3: TButton;
    LTermostatWatchDog: TLabel;
    TermostatWatchDog: TTimer;
    LControlWatchDog: TLabel;
    ControlWatchDog: TTimer;
    STTermostatTolerance: TStaticText;
    STControlTolerance: TStaticText;
    CBLEDAuto: TCheckBox;
    TS_ET1255ADC: TTabSheet;
    ChET1255: TChart;
    PointET1255: TPointSeries;
    RGET1255_MM: TRadioGroup;
    RGET1255Range: TRadioGroup;
    LET1255I: TLabel;
    LET1255U: TLabel;
    SBET1255Auto: TSpeedButton;
    BET1255Meas: TButton;
    CBET1255_SM: TCheckBox;
    SEET1255_MN: TSpinEdit;
    STET1255_4096: TStaticText;
    STET1255_MN: TStaticText;
    SEET1255_Gain: TSpinEdit;
    STET122_Gain: TStaticText;
    BET1255_show_save: TButton;
    GBTMP102: TGroupBox;
    SBGenerator: TSpeedButton;
    LDBtime: TLabel;
    STDBtime: TStaticText;
    GBLEDCon: TGroupBox;
    GBLEDOpen: TGroupBox;
    BLEDOpenPinChange: TButton;
    CBLEDOpenAuto: TCheckBox;
    STLED_on_CD: TStaticText;
    CBLED_onCD: TComboBox;
    STLED_onValue: TStaticText;
    LLED_onValue: TLabel;
    TS_ADC: TTabSheet;
    Button1: TButton;
    GBMCP3424: TGroupBox;
    GBMCP3424_Ch1: TGroupBox;
    BMCP3424_Ch1meas: TButton;
    LMCP3424_Ch1meas: TLabel;
    GBMCP3424_Ch2: TGroupBox;
    LMCP3424_Ch2meas: TLabel;
    BMCP3424_Ch2meas: TButton;
    GBMCP3424_Ch3: TGroupBox;
    LMCP3424_Ch3meas: TLabel;
    BMCP3424_Ch3meas: TButton;
    GBMCP3424_Ch4: TGroupBox;
    LMCP3424_Ch4meas: TLabel;
    BMCP3424_Ch4meas: TButton;
    STMCP3424_1: TStaticText;
    STMCP3424_2: TStaticText;
    STMCP3424_5: TStaticText;
    STMCP3424_3: TStaticText;
    STMCP3424_4: TStaticText;
    PV721IPin: TPanel;
    PV721IPinG: TPanel;
    PV721IIPin: TPanel;
    PV721IIPinG: TPanel;
    PV721APinG: TPanel;
    PV721APin: TPanel;
    PDACR2RPinC: TPanel;
    PTMP102Pin: TPanel;
    PDS18BPin: TPanel;
    PMCP3424Pin: TPanel;
    PMCP3424_Ch1bits: TPanel;
    PMCP3424_Ch1gain: TPanel;
    PMCP3424_Ch2bits: TPanel;
    PMCP3424_Ch2gain: TPanel;
    PMCP3424_Ch3bits: TPanel;
    PMCP3424_Ch3gain: TPanel;
    PMCP3424_Ch4bits: TPanel;
    PMCP3424_Ch4gain: TPanel;
    PD30PinC: TPanel;
    PD30PinG: TPanel;
    PLEDOpenPin: TPanel;
    PIscVocPin: TPanel;
    GBHTU21: TGroupBox;
    PHTU21: TPanel;
    GBads1115: TGroupBox;
    GBads1115_Ch1: TGroupBox;
    Lads1115_Ch1meas: TLabel;
    Bads1115_Ch1meas: TButton;
    Pads1115_Ch1dr: TPanel;
    Pads1115_Ch1gain: TPanel;
    GBads1115_Ch2: TGroupBox;
    Lads1115_Ch2meas: TLabel;
    Bads1115_Ch2meas: TButton;
    Pads1115_Ch2dr: TPanel;
    Pads1115_Ch2gain: TPanel;
    GBads1115_Ch3: TGroupBox;
    Lads1115_Ch3meas: TLabel;
    Bads1115_Ch3meas: TButton;
    Pads1115_Ch3dr: TPanel;
    Pads1115_Ch3gain: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    Panel9: TPanel;

    procedure FormCreate(Sender: TObject);
    procedure BConnectClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PCChange(Sender: TObject);
    procedure BParamReceiveClick(Sender: TObject);
    procedure ComDPacketPacket(Sender: TObject; const Str: string);
    procedure SGFBStepDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SGFBStepSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BFBAddClick(Sender: TObject);
    procedure BFBDeleteClick(Sender: TObject);
    procedure BFBEditClick(Sender: TObject);
    procedure BFBDelayInputClick(Sender: TObject);
    procedure SGRBStepDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BRBDeleteClick(Sender: TObject);
    procedure BRBEditClick(Sender: TObject);
    procedure BSaveSettingClick(Sender: TObject);
    procedure SBTAutoClick(Sender: TObject);
    procedure BIVStartClick(Sender: TObject);
    procedure PCChanging(Sender: TObject; var AllowChange: Boolean);
    procedure BDFFA_R2RClick(Sender: TObject);
//    procedure DependTimerTimer(Sender: TObject);
    procedure SBControlBeginClick(Sender: TObject);
    procedure BControlResetClick(Sender: TObject);
    procedure SBTermostatClick(Sender: TObject);
    procedure BTermostatResetClick(Sender: TObject);
    procedure CBMeasurementsChange(Sender: TObject);
    procedure CBFvsSClick(Sender: TObject);
    procedure TermostatWatchDogTimer(Sender: TObject);
    procedure ControlWatchDogTimer(Sender: TObject);
    procedure BET1255_show_saveClick(Sender: TObject);
    procedure SBGeneratorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure ComponentView;
    {початкове налаштування різних компонентів}
    procedure PinsFromIniFile;
    {зчитування номерів пінів, які використовуються загалом}
    procedure PinsWriteToIniFile;
//    Procedure NumberPinsShow();
    {відображується вміст NumberPins в усі
    ComboBox з Tag=1}
    procedure RangeShow(Sender: TObject);
    procedure LimitsToLabel(LimitShow,LimitShowRev:TLimitShow);
    procedure RangeShowLimit();
//    procedure RangeReadFromIniFile;
    procedure RangesCreate;
    procedure StepReadFromIniFile (A:PVector; Ident:string);
    procedure StepsReadFromIniFile;
    procedure StepsWriteToIniFile;
    procedure ForwStepShow;
    procedure RevStepShow;
    procedure DelayTimeReadFromIniFile;
    procedure DelayTimeWriteToIniFile;
    procedure SettingWriteToIniFile;
    procedure VoltmetrsCreate;
    procedure ShowObjectsReadFromIniFileAndToForm;
    procedure ShowObjectsWriteToIniFileAndFree;
    procedure ObjectsFree;
    procedure DACCreate;
    procedure DACFree;
    procedure DACReadFromIniFileAndToForm;
    procedure DACWriteToIniFile;
    procedure DevicesCreate;
//    procedure DevicesFree;
//    procedure DevicesReadFromIniAndToForm;
//    procedure DevicesWriteToIniFile;
    procedure TemperatureThreadCreate;
    procedure ControllerThreadCreate;
    function StepDetermine(Voltage: Double; ItForward: Boolean):double;
    procedure BoxFromIniFile;
    procedure BoxToIniFile;
    procedure VectorsCreate;
    procedure VectorsDispose;
    { Private declarations }
//    procedure RangeWriteToIniFile;
    procedure ConstantShowCreate;
    procedure PIDShowCreateAndFromIniFile;
    procedure ConstantShowFromIniFile;
    procedure ConstantShowToIniFileAndFree;
//    procedure PIDShowToIniFileAndFree;
    procedure SaveCommentsFile(FileName: string);
    procedure DependenceMeasuringCreate;
//    procedure DependenceMeasuringFree;
//    procedure RangesFree;
    procedure IVCharHookCycle();
    procedure CalibrHookCycle();
    procedure IVCharHookStep();
    procedure CalibrationHookStep;
    procedure IVcharHookBegin;
    procedure DependenceHookEnd;
//    procedure IVcharHookEnd;
//    procedure CalibrHookEnd;
    procedure HookBegin;
//    procedure TimeDHookBegin;
//    procedure TimeTwoDHookBegin;
//    procedure ControlTimeHookBegin;
//    procedure TemperatureOnTimeHookBegin;
//    procedure TimeDHookEnd;
//    procedure TimeTwoDHookEnd;
    procedure TimeDHookFirstMeas;
    procedure TimeTwoDHookFirstMeas;
    procedure IscVocOnTimeHookFirstMeas;
    procedure ControlTimeFirstMeas;
    procedure TemperatureOnTimeFirstMeas;
    procedure TimeDHookSecondMeas;
    procedure TimeTwoDHookSecondMeas;
    procedure IscVocOnTimeHookSecondMeas;
    procedure IVCharHookSetVoltage;
    procedure IVCharHookAction;
    procedure IVSavedCorrectionSet;
    function IVForeseeCorrection():double;
//    function IVSavedCorrectionSet:double;
//    procedure IVCorrectionSet(Rpr,Iprognoz:double);
    function IVprognozI:double;
    function IVprognozCor:double;
    procedure IVMRFilling;
    function IVRpribor():double;
    procedure CalibrHookSetVoltage;
    procedure IVCharCurrentMeasHook;
    function IVCharCurrentMeasuring():boolean;
    function IVCharVoltageMeasuring():boolean;
    procedure CalibrHookSecondMeas();
    procedure IVCharVoltageMeasHook;
    function  IVCorrecrionNeeded():boolean;
    function IVCurrentGrowth:boolean;
    function  IVCharVoltageMaxDif:double;
    procedure CalibrHookFirstMeas;
    procedure IVCharHookDataSave;
    procedure CalibrHookDataSave;
    procedure HookEnd;
    procedure CalibrSaveClick(Sender: TObject);
    procedure ParametersFileWork(Action: TSimpleEvent);
    procedure ET1255Create;
//    procedure ET1255Free;
    procedure WMMyMeasure (var Mes : TMessage); message WM_MyMeasure;
    procedure HookEndReset;
    procedure SaveDialogPrepare;
    procedure MeasurementsLabelCaption(LabelNames:array of string);
    procedure NameToLabel(LabelName:string; Name,NameValue:TLabel);
    procedure MeasurementsLabelCaptionDefault;
    procedure MeasurementTimeParameterDetermination(Dependence:TTimeDependenceTimer);
    procedure ComPortsBegining;
    procedure ComPortsEnding(ComPorts:array of TComPort);
    procedure ComPortsLoadSettings(ComPorts:array of TComPort);
    procedure ComPortsWriteSettings(ComPorts:array of TComPort);
    procedure ActionInSaveButton(Sender: TObject);
    function DiapazonIMeasurement(Measurement:IMeasurement):ShortInt;
    procedure CorrectionLimit(var NewCorrection: Double);
    procedure IVOldFactorDetermination(var Factor: Double);
    function IVNewFactorDetermination():double;
    procedure IVVoltageInputSignDetermine;
    procedure IVMR_Refresh;
    procedure MCP3424Create;
  public
    ShowArray:TObjectArray;
    AnyObjectArray:TObjectArray;
    V721A:TV721A;
    V721_I,V721_II:TV721;
//    V721_I:TV721;
//    V721_II:TV721_Brak;
    VoltmetrShows:array of TVoltmetrShow;

    DS18B20:TDS18B20;
//    DS18B20show:TPinsShow;
    DS18B20show:TOnePinsShow;
    TMP102:TTMP102;
    TMP102show:TI2C_PinsShow;
    HTU21D:THTU21D;
    ThermoCuple:TThermoCuple;
    MCP3424:TMCP3424_Module;
    MCP3424show:TI2C_PinsShow;

    MCP3424_Channel:array [TMCP3424_ChanelNumber] of TMCP3424_Channel;
    MCP3424_ChannelShow:array [TMCP3424_ChanelNumber] of TMCP3424_ChannelShow;

    IscVocPinChanger,LEDOpenPinChanger:TArduinoPinChanger;
    IscVocPinChangerShow,LEDOpenPinChangerShow:TArduinoPinChangerShow;
    ConfigFile:TIniFile;
    NumberPins:TStringList; // номери пінів, які використовуються як керуючі для SPI
    NumberPinsOneWire:TStringList; // номери пінів, які використовуються для OneWire
    NumberPinsInterrupt:TStringList; // номери пінів, які можуть бути викристані для переривань
    ForwSteps,RevSteps,IVResult,VolCorrection,
    VolCorrectionNew,TemperData:PVector;

    DACR2R:TDACR2R;
    DACR2RShow:TDACR2RShow;

    D30_06:TD30_06;
    D30_06Show:TD30_06Show;

    Simulator:TSimulator;

    UT70B:TUT70B;
    UT70BShow:TUT70BShow;
    UT70C:TUT70C;
    UT70CShow:TUT70CShow;

    ET1255_DACs:array[TET1255_DAC_ChanelNumber] of TET1255_DAC;
    ET1255_DACsShow:array[TET1255_DAC_ChanelNumber] of TDAC_Show;
    ET1255isPresent:boolean;
    ET1255_ADCModule:TET1255_ModuleAndChan;
    ET1255_ADCShow:TET1255_ADCShow;

    Devices:array of IMeasurement;
    DevicesSet:array of IDAC;
    Temperature_MD:TTemperature_MD;
    Current_MD,VoltageIV_MD,DACR2R_MD,D30_MD,
    TermoCouple_MD,TimeD_MD,Control_MD,TimeD_MD2,
    Isc_MD,Voc_MD:TMeasuringDevice;
        ET1255_DAC_MD:array[TET1255_DAC_ChanelNumber] of TMeasuringDevice;
    SettingDevice,SettingDeviceControl,SettingTermostat,
    SettingDeviceLED:TSettingDevice;
    RS232_MediatorTread:TRS232_MediatorTread;

    TemperatureMeasuringThread:TTemperatureMeasuringThread;
    ControllerThread:TControllerThread;
    IVCharRangeFor,CalibrRangeFor:TLimitShow;
    IVCharRangeRev,CalibrRangeRev:TLimitShowRev;
    NumberOfTemperatureMeasuring,IterationNumber: Integer;
    ItIsBegining,IsWorkingTermostat,ItIsDarkIV:boolean;
    Temperature,VoltageInputSign
    ,VoltageMeasured
    ,VoltageInputCorrection
    ,MaxDifCoeficient
       :double;
    VoltageLimit:boolean;
    DoubleConstantShows:array of TParameterShow1;
    Imax,Imin,R_VtoI,Shift_VtoI:double;

    IVMeasuring,CalibrMeasuring:TIVDependence;
    TimeDependence:TTimeDependenceTimer;
    ControlParameterTime,TemperatureOnTime:TTimeDependence;
    TimeTwoDependenceTimer,IscVocOnTime:TTimeTwoDependenceTimer;
    Dependencies:Array of TFastDependence;
    PID_Termostat,PID_Control:TPID;
    PID_Termostat_ParametersShow,PID_Control_ParametersShow:TPID_ParametersShow;
    IsPID_Termostat_Created:boolean;
    IVMeasResult,IVMRFirst,IVMRSecond:TIVMeasurementResult;
  end;

const
  Undefined='NoData';
  Vmax=6.5;
  StepDefault=0.01;
  AtempNumbermax=3;

var
  IVchar: TIVchar;

implementation

{$R *.dfm}

//procedure TIVchar.RangeWriteToIniFile;
// var Section:string;
//begin
//    Section:='Range';
//    ConfigFile.EraseSection(Section);
//    IVCharRangeFor.WriteToIniFile(ConfigFile);
//    IVCharRangeRev.WriteToIniFile(ConfigFile);
//    CalibrRangeFor.WriteToIniFile(ConfigFile);
//    CalibrRangeRev.WriteToIniFile(ConfigFile);
//end;

procedure TIVchar.ConstantShowCreate;
begin

  SetLength(DoubleConstantShows, 13);
  DoubleConstantShows[0]:=TParameterShow1.Create(STPR,LPR,
        'Parasitic resistance',
        'Parasitic resistance value is expected',0,3);
  DoubleConstantShows[1]:=TParameterShow1.Create(STMC,LMC,
        'Maximum current',
        'Maximum current for I-V characteristic measurement is expected',2e-2,2);
  DoubleConstantShows[2]:=TParameterShow1.Create(STMinC,LMinC,
        'Minimum current',
        'Minimum current for I-V characteristic measurement is expected',5e-11,2);
  DoubleConstantShows[3]:=TParameterShow1.Create(STFVP,LFVP,
        'Forward voltage precision',
        'Voltage precision for forward I-V characteristic is expected',0.001,4);
  DoubleConstantShows[4]:=TParameterShow1.Create(STRVP,LRVP,
        'Reverse voltage precision',
        'Reverse precision for forward I-V characteristic is expected',0.005,4);
  DoubleConstantShows[5]:=TParameterShow1.Create(STRVtoI,LRVtoI,
        'Resistance V -> I',
        'Resistance for V to I transformation is expected',10,4);
  DoubleConstantShows[6]:=TParameterShow1.Create(STVVtoI,LVVtoI,
        'Shift Voltage for V -> I',
        'Shift Voltage for V to I transformation is expected',-0.503,4);
  DoubleConstantShows[7]:=TParameterShow1.Create(STTMI,LTMI,
        'Temperature measurement interval (s)',
        'Temperature measurement interval',5,2);
  DoubleConstantShows[8]:=TParameterShow1.Create(STTimeInterval,LTimeInterval,
        'Measurement interval, (s)',
        'Time dependence measurement interval',15,2);
  DoubleConstantShows[9]:=TParameterShow1.Create(STTimeDuration,LTimeDuration,
        'Measurement duration (s), 0 - infinite',
        'Full measurement duration',0,2);

//  DoubleConstantShows[10]:=TParameterShow1.Create(STControlNV,LControlNV,
//        'Needed Value',
//        'Needed Value',0);
  DoubleConstantShows[10]:=TParameterShow1.Create(STControlInterval,LControlInterval,
        'Controling interval (s)',
        'Controling measurement interval',15,2);
  DoubleConstantShows[11]:=TParameterShow1.Create(STDBtime,LDBtime,
        'Dragon-back time (ms)',
        'Dragon-back time (ms)',1,3);
  DoubleConstantShows[12]:=TParameterShow1.Create(STLED_onValue,LLED_onValue,
        'LED voltage (V)',
        'LED voltage (V)',0.79,5);
//  DoubleConstantShows[12]:=TParameterShow1.Create(STControlKp,LControlKp,
//        'Kp',
//        'Proportional term of controller',1);
//  DoubleConstantShows[13]:=TParameterShow1.Create(STControlKi,LControlKi,
//        'Ki',
//        'Integral term of controller',0);
//  DoubleConstantShows[14]:=TParameterShow1.Create(STControlKd,LControlKd,
//        'Kd',
//        'Derivative term of controller',0);

//  DoubleConstantShows[15]:=TParameterShow1.Create(STTermostatNT,LTermostatNT,
//        'Needed Temperature',
//        'Needed Temperature',300);
//  DoubleConstantShows[16]:=TParameterShow1.Create(STTermostatKp,LTermostatKp,
//        'Proportional',
//        'Proportional term of termostat',0.1);
//  DoubleConstantShows[17]:=TParameterShow1.Create(STTermostatKi,LTermostatKi,
//        'Integral',
//        'Integral term of termostat',0);
//  DoubleConstantShows[18]:=TParameterShow1.Create(STTermostatKd,LTermostatKd,
//        'Derivative',
//        'Derivative term of termostat',0);

end;

procedure TIVchar.ConstantShowFromIniFile;
 var i:integer;
begin
  for I := Low(DoubleConstantShows) to High(DoubleConstantShows) do
   DoubleConstantShows[i].ReadFromIniFile(ConfigFile);
end;

procedure TIVchar.ConstantShowToIniFileAndFree;
 var i:integer;
begin
  ConfigFile.EraseSection(DoubleConstantSection);
  for I := Low(DoubleConstantShows) to High(DoubleConstantShows) do
   begin
   DoubleConstantShows[i].WriteToIniFile(ConfigFile);
   DoubleConstantShows[i].Free;
   end;
end;

procedure TIVchar.ControllerThreadCreate;
begin
  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;

  ControllerThread:=
    TControllerThread.Create(Control_MD.ActiveInterface,
                             SettingDeviceControl.ActiveInterface,
                             DoubleConstantShows[10].Data,
                             PID_Control);

end;

procedure TIVchar.ControlTimeFirstMeas;
begin
 TDependence.tempIChange(Control_MD.ActiveInterface.Value);
 LADVoltageValue.Caption:=FloatToStrF(TDependence.tempI,ffFixed, 4, 3);
end;


procedure TIVchar.ControlWatchDogTimer(Sender: TObject);
begin
 if (Control_MD.ActiveInterface.NewData)
   and(Control_MD.ActiveInterface.Value<>ErResult)
  then
    begin
    LControlWatchDog.Visible:=True;
    end
  else
    begin
    LControlWatchDog.Visible:=False;
    BControlResetClick(Sender);
    end;
  ControlWatchDog.Interval:=round(StrToFloat(STControlInterval.Caption))*2000;
  Control_MD.ActiveInterface.NewData:=False;
end;

procedure TIVchar.SaveCommentsFile(FileName: string);
 var SR : TSearchRec;
     DT:integer;
     FF:TextFile;
     name:string;
begin
    if FindFirst(FileName,faAnyFile,SR)<>0 then Exit;
    DT:=SR.Time;
    name:=SR.Name;
    AssignFile(FF,'comments');
    if FindFirst('comments',faAnyFile,SR)=0 then Append(FF) else ReWrite(FF);
    FindClose(SR);
    writeln(FF,Name,' - ',DateTimeToStr(FileDateToDateTime(DT)));
    write(FF,'T=',LTLastValue.Caption);
    writeln(FF);
    writeln(FF);
    CloseFile(FF);
end;

procedure TIVchar.DependenceHookEnd;
 var Key:string;
begin
 Key:=CBMeasurements.Items[CBMeasurements.ItemIndex];

 if (Key=MeasIV)or(Key=MeasR2RCalib) then HookEndReset;

 HookEnd();

 if (Key=MeasIV) then
  begin
    if (not(SBTAuto.Down)) then
      begin
        Temperature:=Temperature_MD.GetMeasurementResult();
        TemperData.Add(TDependence.PointNumber,Temperature);
      end;

    TemperData.DeleteErResult;
    if TemperData.n>0 then
       Temperature:=TemperData.SumY/TemperData.n;
//    IVMeasResult.Free;
//    IVMRFirst.Free;
//    IVMRSecond.Free;
  end;

 BIVSave.OnClick:=ActionInSaveButton;
end;

procedure TIVchar.DependenceMeasuringCreate;
 var i:byte;
begin
  IVMeasuring := TIVDependence.Create(CBForw,CBRev,PBIV,BIVStop,
                         IVResult,ForwLine,RevLine,ForwLg,RevLg);
  CalibrMeasuring:= TIVDependence.Create(CBForw,CBRev,PBIV,BIVStop,
                         IVResult,ForwLine,RevLine,ForwLg,RevLg);

  TimeDependence:=TTimeDependenceTimer.Create(PBIV,BIVStop,IVResult,
                                       ForwLine,ForwLg,DependTimer);
  TimeTwoDependenceTimer:=TTimeTwoDependenceTimer.Create(PBIV,BIVStop,IVResult,
                                       ForwLine,ForwLg,DependTimer);
  TimeTwoDependenceTimer.isTwoValueOnTime:=not(CBFvsS.Checked);

  IscVocOnTime:=TTimeTwoDependenceTimer.Create(PBIV,BIVStop,IVResult,
                                       ForwLine,ForwLg,DependTimer);

  ControlParameterTime:=TTimeDependence.Create(PBIV,BIVStop,IVResult,
                                       ForwLine,ForwLg);
  TemperatureOnTime:=TTimeDependence.Create(PBIV,BIVStop,IVResult,
                                       ForwLine,ForwLg);

  SetLength(Dependencies,7);
  Dependencies[0]:=IVMeasuring;
  Dependencies[1]:=CalibrMeasuring;
  Dependencies[2]:=TimeDependence;
  Dependencies[3]:=TimeTwoDependenceTimer;
  Dependencies[4]:=IscVocOnTime;
  Dependencies[5]:=ControlParameterTime;
  Dependencies[6]:=TemperatureOnTime;

  IVMeasuring.RangeFor:=IVCharRangeFor;
  IVMeasuring.RangeRev:=IVCharRangeRev;
  CalibrMeasuring.RangeFor:=CalibrRangeFor;
  CalibrMeasuring.RangeRev:=CalibrRangeRev;

  IVMeasuring.HookCycle:=IVCharHookCycle;
  CalibrMeasuring.HookCycle:=CalibrHookCycle;

  IVMeasuring.HookStep:=IVCharHookStep;
  CalibrMeasuring.HookStep:=CalibrationHookStep;

  IVMeasuring.HookAction:=IVCharHookAction;

  for I := 0 to High(Dependencies) do
    begin
    Dependencies[i].HookBeginMeasuring:=HookBegin;
    Dependencies[i].HookEndMeasuring:=DependenceHookEnd;
    end;

//  IVMeasuring.HookBeginMeasuring:=HookBegin;
//  TimeDependence.HookBeginMeasuring:=HookBegin;
//  TimeTwoDependenceTimer.HookBeginMeasuring:=HookBegin;
//  IscVocOnTime.HookBeginMeasuring:=HookBegin;
//  CalibrMeasuring.HookBeginMeasuring:=HookBegin;
//  ControlParameterTime.HookBeginMeasuring:=HookBegin;
//  TemperatureOnTime.HookBeginMeasuring:=HookBegin;

  IVMeasuring.HookSetVoltage:=IVCharHookSetVoltage;
  CalibrMeasuring.HookSetVoltage:=CalibrHookSetVoltage;

  IVMeasuring.HookSecondMeas:=IVCharCurrentMeasHook;
  CalibrMeasuring.HookSecondMeas:=CalibrHookSecondMeas;
  TimeDependence.HookSecondMeas:=TimeDHookSecondMeas;
  TimeTwoDependenceTimer.HookSecondMeas:=TimeTwoDHookSecondMeas;
  IscVocOnTime.HookSecondMeas:=IscVocOnTimeHookSecondMeas;
  ControlParameterTime.HookSecondMeas:=TimeDHookSecondMeas;
  TemperatureOnTime.HookSecondMeas:=TimeDHookSecondMeas;


  IVMeasuring.HookFirstMeas:=IVCharVoltageMeasHook;
  CalibrMeasuring.HookFirstMeas:=CalibrHookFirstMeas;
  TimeDependence.HookFirstMeas:=TimeDHookFirstMeas;
  TimeTwoDependenceTimer.HookFirstMeas:=TimeTwoDHookFirstMeas;
  IscVocOnTime.HookFirstMeas:=IscVocOnTimeHookFirstMeas;
  ControlParameterTime.HookFirstMeas:=ControlTimeFirstMeas;
  TemperatureOnTime.HookFirstMeas:=TemperatureOnTimeFirstMeas;

  IVMeasuring.HookDataSave:=IVCharHookDataSave;
  CalibrMeasuring.HookDataSave:=CalibrHookDataSave;

//  IVMeasuring.HookEndMeasuring:=DependenceHookEnd;
//  CalibrMeasuring.HookEndMeasuring:=DependenceHookEnd;
//  TimeDependence.HookEndMeasuring:=DependenceHookEnd;
//  TimeTwoDependenceTimer.HookEndMeasuring:=DependenceHookEnd;
//  IscVocOnTime.HookEndMeasuring:=DependenceHookEnd;
//  ControlParameterTime.HookEndMeasuring:=DependenceHookEnd;
//  TemperatureOnTime.HookEndMeasuring:=DependenceHookEnd;


  IVMeasResult:=TIVMeasurementResult.Create;
  IVMRFirst:=TIVMeasurementResult.Create;
  IVMRSecond:=TIVMeasurementResult.Create;
  AnyObjectArray.Add([IVMeasResult,IVMRFirst,IVMRSecond]);
end;

//procedure TIVchar.DependenceMeasuringFree;
//begin
//  IVMeasuring.Free;
//  CalibrMeasuring.Free;
//  TimeDependence.Free;
//  TimeTwoDependenceTimer.Free;
//  IscVocOnTime.Free;
//  ControlParameterTime.Free;
//  TemperatureOnTime.Free;
//    IVMeasResult.Free;
//    IVMRFirst.Free;
//    IVMRSecond.Free;
//end;

//procedure TIVchar.RangesFree;
//begin
//  IVCharRangeFor.Free;
//  IVCharRangeRev.Free;
//  CalibrRangeFor.Free;
//  CalibrRangeRev.Free;
//end;

procedure TIVchar.IVCharHookCycle;
begin
  ItIsBegining:=True;
  try
  if TIVDependence.ItIsForward then
    TIVDependence.DelayTimeChange(StrToInt(LFBDelayValue.Caption))
  else
    TIVDependence.DelayTimeChange(StrToInt(LRBDelayValue.Caption));
  except
    TIVDependence.DelayTimeChange(0)
  end;
end;

procedure TIVchar.IVCharHookStep();
begin
  TIVDependence.VoltageStepChange(StepDetermine(TIVDependence.VoltageInput,TIVDependence.ItIsForward));
end;


procedure TIVchar.CalibrationHookStep;
begin
  TIVDependence.VoltageStepChange(DACR2R.CalibrationStep(TIVDependence.VoltageInput));
end;

procedure TIVchar.IVcharHookBegin;
begin
  SBTAuto.Enabled := False;
  NumberOfTemperatureMeasuring := round(PBIV.Max / 2);
  Temperature := ErResult;
  Imax := DoubleConstantShows[1].Data;
  Imin := DoubleConstantShows[2].Data;
  R_VtoI:=DoubleConstantShows[5].Data;
  Shift_VtoI:= DoubleConstantShows[6].Data;
  SetLenVector(VolCorrectionNew,0);
  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
  TemperData.Clear;
  if not(SBTAuto.Down) then
    begin
      Temperature:=Temperature_MD.GetMeasurementResult;
      TemperData.Add(0,Temperature);
    end;
//  IVMeasResult:=TIVMeasurementResult.Create;
//  IVMRFirst:=TIVMeasurementResult.Create;
//  IVMRSecond:=TIVMeasurementResult.Create;
ItIsDarkIV:=False;
end;

procedure TIVchar.HookBegin;
begin
  DecimalSeparator:='.';
  CBMeasurements.Enabled:=False;
  BIVStart.Enabled := False;
  BConnect.Enabled := False;
  BIVSave.Enabled:=False;
  BParamReceive.Enabled := False;
//  SBTAuto.Enabled := False;

  if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasIV
   then  IVcharHookBegin;
  if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasTimeD
   then  MeasurementTimeParameterDetermination(TimeDependence);
  if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasTwoTimeD
   then  MeasurementTimeParameterDetermination(TimeTwoDependenceTimer);
  if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasIscAndVocOnTime
   then
   begin
   MeasurementTimeParameterDetermination(IscVocOnTime);
   VolCorrectionNew.Clear;
   end;
end;

procedure TIVchar.IVCharHookSetVoltage;
begin

  LADInputVoltageValue.Caption:=FloatToStrF(TIVDependence.VoltageInput,ffFixed, 4, 3);
  if not(TIVDependence.ItIsForward) then
    LADInputVoltageValue.Caption:='-'+LADInputVoltageValue.Caption;
  LADInputVoltageValue.Caption:=LADInputVoltageValue.Caption+
                        ' '+FloatToStrF(TIVDependence.VoltageInputReal,ffFixed, 4, 3);


 if RGDO.ItemIndex=1 then SettingDevice.SetValue(-TIVDependence.VoltageInputReal)
                     else SettingDevice.SetValue(TIVDependence.VoltageInputReal);

end;

procedure TIVchar.IscVocOnTimeHookFirstMeas;
begin
 if CBLEDOpenAuto.Checked then
   begin
//       showmessage('kk');
       LEDOpenPinChanger.PinChangeToLow;
   end;
 if CBLEDAuto.Checked then
  begin
//    BOVset1255Ch2.OnClick(nil);
  SettingDeviceLED.ActiveInterface.Output(DoubleConstantShows[12].Data);
//  sleep(2000);
  end;

  if (CBLEDOpenAuto.Checked)or(CBLEDAuto.Checked)
  then    sleep(2000);
  


 IscVocPinChanger.PinChangeToLow;
 sleep(IscVocTimeToWait);
 TDependence.tempIChange(Voc_MD.ActiveInterface.GetData);
  if ForwLine.Count>0 then
    if abs(TDependence.tempI- ForwLine.YValue[ForwLine.Count-1])>abs(0.1*ForwLine.YValue[ForwLine.Count-1])
   then  TDependence.tempIChange(Voc_MD.ActiveInterface.GetData);
// if TDependence.tempI<1e-5
//   then  TDependence.tempIChange(Voc_MD.ActiveInterface.GetData);

 LADVoltageValue.Caption:=FloatToStrF(TDependence.tempI,ffExponent, 4, 3);
end;

procedure TIVchar.IscVocOnTimeHookSecondMeas;
begin
 sleep(IscVocTimeToWait);
 IscVocPinChanger.PinChangeToHigh;
 sleep(IscVocTimeToWait);
 TTimeTwoDependenceTimer.SecondValueChange(abs(Isc_MD.ActiveInterface.GetData));
  if ForwLg.Count>0 then
    if abs(TTimeTwoDependenceTimer.SecondValue - ForwLg.YValue[ForwLg.Count-1])>abs(0.1*ForwLg.YValue[ForwLg.Count-1])
   then  TTimeTwoDependenceTimer.SecondValueChange(abs(Isc_MD.ActiveInterface.GetData));

// if TTimeTwoDependenceTimer.SecondValue<1e-7
//   then  TTimeTwoDependenceTimer.SecondValueChange(abs(Isc_MD.ActiveInterface.GetData));

 LADInputVoltageValue.Caption:=FloatToStrF(TTimeTwoDependenceTimer.SecondValue,ffExponent, 4, 3);
// VolCorrectionNew^.Add(TTimeTwoDependenceTimer.tempV,
//                       Voc_MD.ActiveInterface.GetData);
 VolCorrectionNew^.Add(Temperature_MD.ActiveInterface.Value,
                       Voc_MD.ActiveInterface.GetData);

 if CBLEDOpenAuto.Checked then
       LEDOpenPinChanger.PinChangeToHigh;
 if CBLEDAuto.Checked then
  begin
//    BReset1255Ch2.OnClick(nil);
   SettingDeviceLED.ActiveInterface.Reset;
  end;

 TimeDHookSecondMeas;
 MeasurementTimeParameterDetermination(IscVocOnTime);

  if CBLEDOpenAuto.Checked then
     begin
       sleep(500);
       LEDOpenPinChanger.PinChangeToHigh;

     end;
end;

procedure TIVchar.IVCharCurrentMeasHook;
 var
  AtempNumber:byte;
begin
  AtempNumber := 0;
  repeat
   if not(IVCharCurrentMeasuring()) then Exit;

   if (High(IVResult^.Y)<0) then Break;

   if (ItIsBegining)or(IVCurrentGrowth()) then Break;

   inc(AtempNumber);
  until (AtempNumber>AtempNumbermax);

  if (CBCurrentValue.Checked and (abs(IVMeasResult.CurrentMeasured)>=Imax)) then
   TIVDependence.VoltageInputChange(Vmax);
end;

function TIVchar.IVCharCurrentMeasuring(): boolean;
 var Current: double;
begin
 Result:=False;
 Application.ProcessMessages;
 if TIVDependence.IVMeasuringToStop then Exit;

 Current := Current_MD.GetMeasurementResult();

 if Current=ErResult then
  begin
   TDependence.tempIChange(Current);
   Exit;
  end;

 // ****************************
 if CBVtoI.Checked then
  begin
   Current:=(Current-Shift_VtoI)/R_VtoI;
   LADCurrentValue.Caption:=FloatToStrF(Current,ffExponent, 4, 2);
  end;

//*********************************

 if RGDO.ItemIndex=1 then
      begin
         Current:=-Current;
         LADCurrentValue.Caption:=FloatToStrF(Current,ffExponent, 4, 2);
      end;

 TDependence.tempIChange(Current);
 IVMeasResult.FromCurrentMeasurement();
 IVMeasResult.CurrentDiapazon:=DiapazonIMeasurement(Current_MD.ActiveInterface);

 Result:=True;
end;


procedure TIVchar.IVCharHookAction;
  var newCorrection:double;
begin
 VoltageInputCorrection:=0;
 VoltageMeasured:=0;
 VoltageLimit:=False;
// VoltageInputCorrectionN:=ErResult;
// VoltageMeasuredN:=ErResult;

// Cor:=ErResult;
 VoltageLimit:=False;

 MaxDifCoeficient:=1;

 IVVoltageInputSignDetermine;

 IVMRFilling();

 newCorrection:=ErResult;

 if CBPC.Checked
   then newCorrection:=VolCorrection.Yvalue(VoltageInputSign);
 if (newCorrection=ErResult)
   then newCorrection:=IVForeseeCorrection;

 TIVDependence.VoltageCorrectionChange(newCorrection);
//   if ItIsDarkIV then
//      begin
//        Iprognoz:=IVprognozI();
//        Rpr:=IVRpribor();
////        IVCorrectionSet(Rpr,Iprognoz);
//        if (Iprognoz<>ErResult)and
//           (Rpr<>ErResult) then
//             TIVDependence.VoltageCorrectionChange(abs(Iprognoz*Rpr));
//      end;
 if not(IVMeasResult.isEmpty) then
 begin
 IVMeasResult.CopyTo(IVMRFirst);
 IVMRFirst.DeltaToExpected:=ErResult;
 end;


 IterationNumber:=0;

end;



procedure TIVchar.CalibrHookSecondMeas();
begin
  Application.ProcessMessages;
  if TIVDependence.IVMeasuringToStop then Exit;
  TDependence.tempIChange(DACR2R_MD.GetMeasurementResult());
  LADCurrentValue.Caption:=FloatToStrF(TDependence.tempI,ffFixed, 6, 4);
end;

procedure TIVchar.CalibrHookSetVoltage;
begin
 LADInputVoltageValue.Caption:=FloatToStrF(TIVDependence.VoltageInputReal,ffFixed, 6, 4);
// SettingDevice.SetValueCalibr(TIVDependence.VoltageInputReal);
 DACR2R.OutputCalibr(TIVDependence.VoltageInputReal);
end;

procedure TIVchar.CalibrSaveClick(Sender: TObject);
 var tempdir:string;
begin
  tempdir:=GetCurrentDir;
  ChDir(ExtractFilePath(Application.ExeName));
  DACR2R.SaveFileWithCalibrData(IVResult);
  ChDir(tempdir);
  BIVSave.Font.Style:=BIVSave.Font.Style+[fsStrikeOut];
end;

procedure TIVchar.CBFvsSClick(Sender: TObject);
begin
 TimeTwoDependenceTimer.isTwoValueOnTime:=not(CBFvsS.Checked);
 CBMeasurementsChange(Sender);
end;

procedure TIVchar.CBMeasurementsChange(Sender: TObject);
begin
 RevLine.Clear;
 RevLg.Clear;

 if (CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasR2RCalib)
     or(CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasIV)
     then
      begin
       LADRange.Visible:=True;
       RangeShow(Sender);
       MeasurementsLabelCaptionDefault;
      end
     else LADRange.Visible:=False;

 if (CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasTimeD)
    or(CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasControlParametr)
     then MeasurementsLabelCaption(['Value', 'Time', '']);

 if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasTwoTimeD
     then
      if TimeTwoDependenceTimer.isTwoValueOnTime
        then MeasurementsLabelCaption(['1-st value', 'Time', '2-nd value'])
        else MeasurementsLabelCaption(['1-st value', '2-nd value', '']);

 if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasIscAndVocOnTime
     then MeasurementsLabelCaption(['Voc', 'Time', 'Isc']);

 if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasTempOnTime
     then MeasurementsLabelCaption(['Temp-ture', 'Time', '']);

//     ControlParameterTime.BeginMeasuring;
//     TimeTwoDependenceTimer.BeginMeasuring;
//     TimeDependence.BeginMeasuring;
//
// if (CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasControlParametr)
//    and (SBControlBegin.Down)
//     then  ControlParameterTime.BeginMeasuring;
// if (CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasTempOnTime)
//    and (SBTAuto.Down)
//     then  TemperatureOnTime.BeginMeasuring;


end;

procedure TIVchar.ParametersFileWork(Action: TSimpleEvent);
 var tempdir: string;
begin
  tempdir := GetCurrentDir;
  ChDir(ExtractFilePath(Application.ExeName));
  Action;
  ChDir(tempdir);
end;

procedure TIVchar.ET1255Create;
 var I:TET1255_DAC_ChanelNumber;
begin
  ET1255isPresent:=(ET_StartDrv = '');
  if ET1255isPresent then
   begin
     for I := Low(TET1255_DAC_ChanelNumber) to High(TET1255_DAC_ChanelNumber) do
       begin
        ET1255_DACs[i]:=TET1255_DAC.Create(i);
        ET1255_DACs[i].Reset();
        AnyObjectArray.Add([ET1255_DACs[i]]);
       end;
     ET1255_DACsShow[0]:=TDAC_Show.Create(ET1255_DACs[0],
                    LOV1255ch0,LOK1255Ch0,BOVchange1255Ch0,
                    BOVset1255Ch0,BOKchange1255Ch0,
                    BOKset1255Ch0,BReset1255Ch0);
     ET1255_DACsShow[1]:=TDAC_Show.Create(ET1255_DACs[1],
                    LOV1255ch1,LOK1255Ch1,BOVchange1255Ch1,
                    BOVset1255Ch1,BOKchange1255Ch1,
                    BOKset1255Ch1,BReset1255Ch1);
     ET1255_DACsShow[2]:=TDAC_Show.Create(ET1255_DACs[2],
                    LOV1255ch2,LOK1255Ch2,BOVchange1255Ch2,
                    BOVset1255Ch2,BOKchange1255Ch2,
                    BOKset1255Ch2,BReset1255Ch2);
     ET1255_DACsShow[3]:=TDAC_Show.Create(ET1255_DACs[3],
                    LOV1255ch3,LOK1255Ch3,BOVchange1255Ch3,
                    BOVset1255Ch3,BOKchange1255Ch3,
                    BOKset1255Ch3,BReset1255Ch3);

      ShowArray.Add([ET1255_DACsShow[0],ET1255_DACsShow[1],
                     ET1255_DACsShow[2],ET1255_DACsShow[3]]);

      ET1255_ADCModule:=TET1255_ModuleAndChan.Create;
      ET1255_ADCModule.ReadFromIniFile(ConfigFile);
      ET1255_ADCShow:=TET1255_ADCShow.Create(ET1255_ADCModule,
         RGET1255_MM, RGET1255Range, LET1255I, LET1255U, BET1255Meas,
         SBET1255Auto, Time, SEET1255_Gain, SEET1255_MN,CBET1255_SM, PointET1255);

      ShowArray.Add([ET1255_ADCModule,ET1255_ADCShow]);

   end
                    else
   begin
   PC.Pages[8].TabVisible:=False;
   PC.Pages[9].TabVisible:=False;
   end;


end;


function TIVchar.IVCharVoltageMaxDif: double;
begin
  if TIVDependence.ItIsForward then
    begin
      if TIVDependence.VoltageInput>1
        then Result:=10*DoubleConstantShows[3].Data
        else Result:=DoubleConstantShows[3].Data;
    end                               else
    begin
      if TIVDependence.VoltageInput>1
        then Result:=10*DoubleConstantShows[4].Data
        else Result:=DoubleConstantShows[4].Data;
    end;
  Result:=Result*MaxDifCoeficient;
end;


procedure TIVchar.IVCharVoltageMeasHook;
  var
    NewCorrection,Factor:double;
begin

  Application.ProcessMessages;
  if TIVDependence.IVMeasuringToStop then Exit;

  if not(IVCharVoltageMeasuring()) then Exit;


  if IVCorrecrionNeeded() then
   begin
    TIVDependence.SecondMeasIsDoneChange(False);


    if VoltageLimit then
      begin
       VoltageLimit:=False;
       IVSavedCorrectionSet();
       Exit;
      end;

    inc(IterationNumber);
    if (CBPC.Checked)and(IterationNumber=1)
     then
      begin
       if abs(IVMeasResult.DeltaToExpected)>0.02 then
        begin
         TIVDependence.VoltageCorrectionChange(TIVDependence.VoltageCorrection+0.2);
         VoltageLimit:=True;
        end;
       Exit;
      end;


   IVOldFactorDetermination(Factor);


   if (IterationNumber mod 13)=0 then
   begin
    Randomize;
    Factor:=Factor*Random;
    VoltageInputCorrection:=VoltageInputCorrection*Random;
    IVMeasResult.Correction:=IVMeasResult.Correction*Random;
    MaxDifCoeficient:=MaxDifCoeficient*1.2;
   end;

    NewCorrection:=TIVDependence.VoltageCorrection-
                     Factor*IVMeasResult.DeltaToExpected;

//++++++++++++++++++++++++++++++++++++++++++

   if not(ItIsBegining) then
    begin
      if (abs(IVMeasResult.DeltaToExpected)>0.01)
       then
         NewCorrection:=IVMeasResult.Correction*IVNewFactorDetermination
       else
         if IVCharCurrentMeasuring()
          then
           begin
           NewCorrection:=IVForeseeCorrection();
           IVMR_Refresh();
          end;
    end;



//++++++++++++++++++++++++++++++++++++++++++++


//**********************************************
//   if (IterationNumber>1)and(VoltageInputCorrection<>0) then
//     if IVMeasResult.isLarge then
//      begin
//       if abs(VoltageMeasured-TIVDependence.VoltageInput)>abs(IVMeasResult.DeltaToExpected)
//        then  NewCorrection:=VoltageInputCorrection+
//              0.7*(TIVDependence.VoltageCorrection-VoltageInputCorrection)
//        else
//           NewCorrection:=VoltageInputCorrection+
//             0.2*(TIVDependence.VoltageCorrection-VoltageInputCorrection);
//      end;
//*************************************************

   if (NewCorrection=ErResult)
      or(abs(NewCorrection-IVMeasResult.Correction)<1e-4)
      or(abs(NewCorrection)>3)
    then NewCorrection:=TIVDependence.VoltageCorrection-
                     Factor*IVMeasResult.DeltaToExpected;


    CorrectionLimit(NewCorrection);

    TIVDependence.VoltageCorrectionChange(NewCorrection);
   end;

end;

function TIVchar.IVCharVoltageMeasuring(): boolean;
 var Voltage: double;
begin
  Result:=False;

  Voltage := VoltageIV_MD.GetMeasurementResult();
  if Voltage=ErResult then
    begin
     TDependence.tempVChange(Voltage);
     Exit;
    end;

  if RGDO.ItemIndex=1 then
     begin
     Voltage:=-Voltage;
     LADVoltageValue.Caption:=FloatToStrF(Voltage,ffFixed, 4, 3);
     end;

  TDependence.tempVChange(Voltage);
  IVMeasResult.FromVoltageMeasurement;
  Result:=True;
end;

function TIVchar.IVCorrecrionNeeded(): boolean;
begin
  Result:=abs(IVMeasResult.DeltaToExpected)>=IVCharVoltageMaxDif();
end;

function TIVchar.IVCurrentGrowth: boolean;
begin
   if TIVDependence.ItIsForward then
       Result:=IVMeasResult.CurrentMeasured>IVResult^.Y[High(IVResult^.Y)]
                                else
       Result:=IVMeasResult.CurrentMeasured<IVResult^.Y[High(IVResult^.Y)]
end;

function TIVchar.IVForeseeCorrection(): double;
 var Iprognoz,Rprib:double;
begin
 Result:=ErResult;

 if IVMeasResult.isEmpty then Exit;
   if ItIsDarkIV then
      begin

        Iprognoz:=IVprognozI();
        Rprib:=IVRpribor();
        if (Iprognoz<>ErResult)and (Rprib<>ErResult) then
             Result:=abs(Iprognoz*Rprib);

      end        else
      begin
       Result:=IVprognozCor();
      end;
end;

procedure TIVchar.IVMRFilling;
begin
 IVMRSecond.isEmpty:=True;
 IVMRSecond.DeltaToExpected:=ErResult;
 IVMRFirst.isEmpty:=True;
 IVMeasResult.isEmpty:=True;
 IVMeasResult.DeltaToExpected:=ErResult;

 if (IVResult^.n<1) then Exit;


 if (VoltageInputSign*IVResult^.X[IVResult^.n-1]<0) then Exit;
 IVMeasResult.isEmpty:=False;


 if (IVResult^.n<2) then Exit;
 if (VoltageInputSign*IVResult^.X[IVResult^.n-2]<0) then Exit;

 IVMRFirst.VoltageMeasured:=IVResult^.X[IVResult^.n-2];
 IVMRFirst.CurrentMeasured:=IVResult^.Y[IVResult^.n-2];
 IVMRFirst.DeltaToExpected:=ErResult;
 IVMRFirst.Correction:=VolCorrectionNew^.Y[VolCorrectionNew^.n-2];
 IVMRFirst.CurrentDiapazon:= IVMeasResult.CurrentDiapazon;
 IVMRFirst.isEmpty:=False;


end;


function TIVchar.IVprognozCor: double;
begin
 Result:=ErResult;
 if IVMeasResult.isEmpty then Exit;

 if (IVMeasResult.CurrentDiapazon=IVMRFirst.CurrentDiapazon)and
    (not(IVMRFirst.isEmpty)) then
   begin
     Result:=Y_X0(IVMeasResult.CurrentMeasured,
                  IVMeasResult.Correction,
                  IVMRFirst.CurrentMeasured,
                  IVMRFirst.Correction,
                  IVprognozI());
     Exit;
   end;

 if (IVMeasResult.CurrentDiapazon=IVMRSecond.CurrentDiapazon)and
    (not(IVMRSecond.isEmpty)) then
   begin
     Result:=Y_X0(IVMeasResult.CurrentMeasured,
                  IVMeasResult.Correction,
                  IVMRSecond.CurrentMeasured,
                  IVMRSecond.Correction,
                  IVprognozI());
   end;

  if abs(Result)<Imin then Result:=0;

//  Imax := DoubleConstantShows[1].Data;
end;

function TIVchar.IVprognozI: double;
 var
   i,j:byte;
begin
 Result:=ErResult;
 i:=0;j:=0;
 if IVMeasResult.isEmpty then inc(j)
                         else i:=i+1;
 if IVMRFirst.isEmpty then inc(j)
                      else i:=i+2;
 if IVMRSecond.isEmpty then inc(j)
                      else i:=i+4;

 if j>1 then Exit;
 if j=1 then
   begin
     if (i and $1)=0 then
       Result:=Y_X0(IVMRFirst.VoltageMeasured,
                    IVMRFirst.CurrentMeasured,
                    IVMRSecond.VoltageMeasured,
                    IVMRSecond.CurrentMeasured,
                    VoltageInputSign);
     if (i and $2)=0 then
       Result:=Y_X0(IVMeasResult.VoltageMeasured,
                    IVMeasResult.CurrentMeasured,
                    IVMRSecond.VoltageMeasured,
                    IVMRSecond.CurrentMeasured,
                    VoltageInputSign);
     if (i and $4)=0 then
       Result:=Y_X0(IVMeasResult.VoltageMeasured,
                    IVMeasResult.CurrentMeasured,
                    IVMRFirst.VoltageMeasured,
                    IVMRFirst.CurrentMeasured,
                    VoltageInputSign);
   end;

  if j=0 then
   begin
    if abs(IVMeasResult.DeltaToExpected)<abs(IVMRFirst.DeltaToExpected)
    then if abs(IVMRFirst.DeltaToExpected)<abs(IVMRSecond.DeltaToExpected)
         then Result:=Y_X0(IVMeasResult.VoltageMeasured,
                           IVMeasResult.CurrentMeasured,
                           IVMRFirst.VoltageMeasured,
                           IVMRFirst.CurrentMeasured,
                           VoltageInputSign)
         else Result:=Y_X0(IVMeasResult.VoltageMeasured,
                           IVMeasResult.CurrentMeasured,
                           IVMRSecond.VoltageMeasured,
                           IVMRSecond.CurrentMeasured,
                           VoltageInputSign)
    else if abs(IVMeasResult.DeltaToExpected)<abs(IVMRSecond.DeltaToExpected)
         then Result:=Y_X0(IVMeasResult.VoltageMeasured,
                           IVMeasResult.CurrentMeasured,
                           IVMRFirst.VoltageMeasured,
                           IVMRFirst.CurrentMeasured,
                           VoltageInputSign)
         else Result:=Y_X0(IVMRFirst.VoltageMeasured,
                           IVMRFirst.CurrentMeasured,
                           IVMRSecond.VoltageMeasured,
                           IVMRSecond.CurrentMeasured,
                           VoltageInputSign)
   end;
 end;


function TIVchar.IVRpribor(): double;
begin
  if CBVtoI.Checked
     then Result:=R_VtoI
     else Result:=IVMeasResult.Rpribor;
end;

procedure TIVchar.IVSavedCorrectionSet;
begin
 TIVDependence.VoltageCorrectionChange(VolCorrection.Yvalue(VoltageInputSign))
end;


procedure TIVchar.LimitsToLabel(LimitShow,LimitShowRev:TLimitShow);
 var Start,Finish:string;
 begin
  if CBForw.Checked then Finish:=LimitShow.ValueLabelHigh.Caption
                    else Finish:=LimitShowRev.ValueLabelHigh.Caption;
  if CBRev.Checked then Start:=LimitShowRev.ValueLabelLow.Caption
                   else Start:=LimitShow.ValueLabelLow.Caption;

  if (not(CBForw.Checked))and(not(CBRev.Checked))
    then begin
         Finish:='0';
         Start:='0';
         end;
  LADRange.Caption := 'Range is [' + Start + ' .. '+ Finish + '] V'
end;

procedure TIVchar.CalibrHookCycle;
begin
  TIVDependence.DelayTimeChange(800);
end;

procedure TIVchar.CalibrHookDataSave;
 var tempdir:string;
     tempVec:PVector;
begin
  if TDependence.PointNumber=0 then Exit;
  if (TDependence.PointNumber mod 1000)<>0 then Exit;
    new(tempVec);
    IVResult^.Copy(tempVec^);
    tempdir:=GetCurrentDir;
    ChDir(ExtractFilePath(Application.ExeName));
    DACR2R.SaveFileWithCalibrData(tempVec);
    ChDir(tempdir);
    dispose(tempVec);
end;


procedure TIVchar.CalibrHookFirstMeas;
begin
  Application.ProcessMessages;;
  if TIVDependence.IVMeasuringToStop then Exit;

  TDependence.tempVChange(TIVDependence.VoltageInputReal);
  LADVoltageValue.Caption:=FloatToStrF(TDependence.tempV,ffFixed, 6, 4);
end;

procedure TIVchar.IVCharHookDataSave;
begin
  if abs(TDependence.tempI)<=abs(Imin)
     then TDependence.tempIChange(ErResult);


  if (not(SBTAuto.Down))and
     (NumberOfTemperatureMeasuring=TDependence.PointNumber)
    then
    begin
      Temperature:=Temperature_MD.GetMeasurementResult();
      TemperData.Add(TDependence.PointNumber,Temperature);
    end;

  if (SBTAuto.Down)and
     (Temperature_MD.ActiveInterface.NewData) then
      begin
       TemperData.Add(TDependence.PointNumber,
                     Temperature_MD.ActiveInterface.Value);
       Temperature_MD.ActiveInterface.NewData:=False;
      end;

  if (TIVDependence.VoltageInput=0)
   then  ItIsDarkIV:=(TDependence.tempI>-1e-5)
  else
   if TDependence.tempI>0 then  ItIsDarkIV:=True;



  if ItIsBegining then ItIsBegining:=not(ItIsBegining);
  VolCorrectionNew.Add(VoltageInputSign,TIVDependence.VoltageCorrection);

end;

procedure TIVchar.HookEnd;
begin
  DecimalSeparator:='.';

  CBMeasurements.Enabled:=True;
  BIVStart.Enabled := True;
  BConnect.Enabled := True;
  BParamReceive.Enabled := True;
  SBTAuto.Enabled := True;
  if High(IVResult^.X) > 0 then
  begin
    BIVSave.Enabled := True;
    BIVSave.Font.Style := BIVSave.Font.Style - [fsStrikeOut];
  end;

end;

procedure TIVchar.ActionInSaveButton(Sender: TObject);
 var Key:string;
begin
 Key:=CBMeasurements.Items[CBMeasurements.ItemIndex];

  if Key=MeasR2RCalib then
  begin
    CalibrSaveClick(Sender);
    Exit;
  end;

  if Key=MeasIV then
  begin
    VolCorrectionNew.Sorting;
    VolCorrectionNew.DeleteDuplicate;
    VolCorrectionNew^.Copy(VolCorrection^);
  end;

  SaveDialogPrepare;
  if SaveDialog.Execute then
   begin

    if Key=MeasIV then
      begin
       IVResult.Sorting;
       IVResult.DeleteDuplicate;
       Write_File(SaveDialog.FileName,IVResult);
//       ToFileFromTwoVector(SaveDialog.FileName,IVResult,VolCorrectionNew);
       LTLastValue.Caption:=FloatToStrF(Temperature,ffFixed, 5, 2);
       SaveCommentsFile(SaveDialog.FileName);
      end;

    if (Key=MeasTimeD)or(Key=MeasControlParametr)or(Key=MeasTempOnTime)
      then Write_File(SaveDialog.FileName,IVResult,6);

    if Key=MeasTwoTimeD then
     begin
       if TimeTwoDependenceTimer.isTwoValueOnTime
          then ToFileFromTwoSeries(SaveDialog.FileName,ForwLine,ForwLg,6)
          else Write_File(SaveDialog.FileName,IVResult,6);
     end;

    if (Key=MeasIscAndVocOnTime) then
      begin
      ToFileFromTwoSeries(SaveDialog.FileName,ForwLine,ForwLg,6);
      ToFileFromTwoVector(copy(SaveDialog.FileName,1,Length(SaveDialog.FileName)-4)+'a.dat',
         IVResult,VolCorrectionNew,6);
      end;
     BIVSave.Font.Style:=BIVSave.Font.Style+[fsStrikeOut];
   end;
end;

procedure TIVchar.BConnectClick(Sender: TObject);
begin
 try
  ComPort1.Connected:=not(ComPort1.Connected);
  if ComPort1.Connected then
   begin
    ComPort1.ClearBuffer(True, True);
    ComPort1.AbortAllAsync;
   end;
 finally
 PortBeginAction(ComPort1,LConnected,BConnect);

 end;
end;

procedure TIVchar.BFBAddClick(Sender: TObject);
 var temp:double;
begin
  if (Sender as TButton).Name='BFBAdd' then
   begin
      temp:=round(10*StrToFloat555(InputBox(
                                  'Voltage limit',
                                  'Input new voltage limit.'+
                                  #10+'The value must be greater 0 and less or equal '
                                  +FloatToStrF(Vmax,ffGeneral,2,1),
                                  '')))/10;
      if (temp>0)and(temp<=Vmax)and(temp<>ErResult) then
       begin
         ForwSteps.Add(temp,StepDefault);
         ForwSteps.DeleteDuplicate;
         ForwSteps.Sorting();
         ForwStepShow();
       end;
   end;
  if (Sender as TButton).Name='BRBAdd' then
   begin
      temp:=round(10*StrToFloat555(InputBox(
                                  'Voltage limit',
                                  'Input new voltage limit.'+
                                  #10+'The value must be less 0 and greater or equal '
                                  +FloatToStrF(-Vmax,ffGeneral,2,1),
                                  '')))/10;
      if (temp<0)and(temp>=(-Vmax))and(temp<>ErResult) then
       begin
         RevSteps.Add(abs(temp),StepDefault);
         RevSteps.DeleteDuplicate;
         RevSteps.Sorting();
         RevStepShow();
       end;
   end;
end;

procedure TIVchar.BFBDelayInputClick(Sender: TObject);
 var temp:integer;
     stTemp:string;
begin
 if (Sender as TButton).Name='BFBDelayInput'
            then stTemp:=LFBDelayValue.Caption
            else stTemp:=LRBDelayValue.Caption;
 temp:=round(StrToInt555(InputBox(
                                'Delay time',
                                'Input delay time.'+
                                #10+'The value must be greater 0 and less 10000',
                                stTemp)));
 if (temp>=0)and(temp<10000)and(temp<>ErResult)
    then
      begin
       if (Sender as TButton).Name='BFBDelayInput'
              then LFBDelayValue.Caption:=IntToStr(temp)
              else LRBDelayValue.Caption := IntToStr(temp);
      end;
end;

procedure TIVchar.BFBDeleteClick(Sender: TObject);
begin
 if (SGFBStep.Row=(SGFBStep.RowCount-1))or(SGFBStep.Row<1) then Exit;
 ForwSteps.Delete(SGFBStep.Row-1);
 ForwStepShow();
end;

procedure TIVchar.BFBEditClick(Sender: TObject);
 var st:string;
     temp:double;
begin
 if (SGFBStep.Row=0)or
   ((SGFBStep.Row>=SGFBStep.RowCount-1)and(SGFBStep.Col=0)) then Exit;
 if (SGFBStep.Col=0) then
    if InputQuery('Voltage limit',
                  'Edit voltage limit value.'+
                   #10+'The value must be greater 0 and less or equal '
                   +FloatToStrF(Vmax,ffGeneral,2,1),
                   st) then
       begin
        temp:=round(10*StrToFloat555(st))/10;
        if (temp>0)and(temp<=Vmax)and(temp<>ErResult) then
         begin
           ForwSteps.X[SGFBStep.Row-1]:=temp;
           ForwSteps.DeleteDuplicate;
           ForwSteps.Sorting();
           ForwStepShow();
         end;
       end;
 if (SGFBStep.Col=1) then
    if InputQuery('Step value',
                  'Edit step value.'+
                   #10+'The value must be greater than 0',
                   st) then
       begin
        temp:=round(1000*StrToFloat555(st))/1000;
        if (temp>0)and(temp<>ErResult) then
         begin
           ForwSteps.Y[SGFBStep.Row-1]:=temp;
           ForwStepShow();
         end;
       end;
 end;

procedure TIVchar.BIVStartClick(Sender: TObject);
begin
 if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasR2RCalib
     then CalibrMeasuring.Measuring;
 if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasIV
     then IVMeasuring.Measuring;
 if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasTimeD
     then TimeDependence.BeginMeasuring;
  if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasTwoTimeD
     then TimeTwoDependenceTimer.BeginMeasuring;
  if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasIscAndVocOnTime
     then IscVocOnTime.BeginMeasuring;

 if (CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasControlParametr)
    and (SBControlBegin.Down)
     then  ControlParameterTime.BeginMeasuring;
 if (CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasTempOnTime)
    and (SBTAuto.Down)
     then  TemperatureOnTime.BeginMeasuring;
end;

procedure TIVchar.BParamReceiveClick(Sender: TObject);
begin
 PacketCreate([ParameterReceiveCommand]);
 PacketIsSend(ComPort1,'Parameter receiving is unsuccessful');
end;

procedure TIVchar.BRBDeleteClick(Sender: TObject);
begin
 if (SGRBStep.Row=(SGRBStep.RowCount-1))or(SGRBStep.Row<1) then Exit;
 RevSteps.Delete(SGRBStep.Row-1);
 RevStepShow();
end;

procedure TIVchar.BRBEditClick(Sender: TObject);
 var st:string;
     temp:double;
begin
 if (SGRBStep.Row=0)or
   ((SGRBStep.Row>=SGRBStep.RowCount-1)and(SGRBStep.Col=0)) then Exit;
 if (SGRBStep.Col=0) then
    if InputQuery('Voltage limit',
                  'Edit voltage limit value.'+
                  #10+'The value must be less 0 and greater or equal '
                  +FloatToStrF(-Vmax,ffGeneral,2,1),
                  st) then
       begin
        temp:=round(10*StrToFloat555(st))/10;
        if (temp<0)and(temp>=(-Vmax))and(temp<>ErResult) then
         begin
           RevSteps.X[SGRBStep.Row-1]:=abs(temp);
           RevSteps.DeleteDuplicate;
           RevSteps.Sorting();
           RevStepShow();
         end;
       end;
 if (SGRBStep.Col=1) then
    if InputQuery('Step value',
                  'Edit step value.'+
                   #10+'The value must be greater than 0',
                   st) then
       begin
        temp:=round(1000*StrToFloat555(st))/1000;
        if (temp>0)and(temp<>ErResult) then
         begin
           RevSteps.Y[SGRBStep.Row-1]:=temp;
           RevStepShow();
         end;
       end;
end;


procedure TIVchar.BSaveSettingClick(Sender: TObject);
begin
 DecimalSeparator:='.';
 SettingWriteToIniFile();
end;

procedure TIVchar.BTermostatResetClick(Sender: TObject);
begin
 if SBTermostat.Down then
    begin
     if assigned(PID_Termostat)
       then PID_Termostat.SetParametr(PID_Termostat_ParametersShow,
                                      DoubleConstantShows[7].Data);
     if  SBTAuto.Down then
      begin
       TemperatureMeasuringThread.Terminate;
       sleep(500);
       TemperatureThreadCreate();
      end             else
      begin
        SBTAuto.Down:=True;
        TemperatureThreadCreate();
      end;
    end;
end;


procedure TIVchar.Button1Click(Sender: TObject);
begin
// showmessage(inttostr(MCP3424_Channel[0].Pins.PinControl)+ '  '+MCP3424_Channel[0].Pins.PNames[0]);
// showmessage(inttostr(MCP3424_Channel[0].Pins.PinControl)+
// '  '+MCP3424_ChannelShow[0].fPinVariants[0].Strings[0]);
end;

procedure TIVchar.BControlResetClick(Sender: TObject);
begin
 if SBControlBegin.Down then
    begin
    PID_Control.SetParametr(PID_Control_ParametersShow,
                            DoubleConstantShows[10].Data);
    ControlWatchDog.Enabled:=False;
    LControlWatchDog.Visible:=False;
    ControlWatchDog.Interval:=round(StrToFloat(STControlInterval.Caption))*2000;
    ControlWatchDog.Enabled:=True;
    ControllerThread.Terminate;
    ControllerThreadCreate()
    end;
end;

procedure TIVchar.BDFFA_R2RClick(Sender: TObject);
begin
  if OpenDialog.Execute()
     then
       begin
         DACR2R.CalibrationFileProcessing(OpenDialog.FileName);
         ParametersFileWork(DACR2R.CalibrationWrite);
       end;
end;

procedure TIVchar.BET1255_show_saveClick(Sender: TObject);
begin
  SaveDialogPrepare;
  if SaveDialog.Execute then
    Write_File_Series(SaveDialog.FileName,PointET1255,6);
end;

procedure TIVchar.ComDPacketPacket(Sender: TObject; const Str: string);
 var Data:TArrByte;
     i:integer;
     ToNumberPins,ToNumberPinsOneWire:boolean;
begin
 if PacketIsReceived(Str,Data,ParameterReceiveCommand) then
  begin
   NumberPins.Clear;
   ToNumberPins:=True;
   NumberPinsOneWire.Clear;
   ToNumberPinsOneWire:=True;
   NumberPinsInterrupt.Clear;
   for I := 3 to High(Data)-1 do
    begin

    if Data[i]=100 then
      begin
      ToNumberPins:=False;
      Continue;
      end;
    if Data[i]=200 then
      begin
      ToNumberPinsOneWire:=False;
      Continue;
      end;

    if ToNumberPins then
        NumberPins.Add(IntToStr(Data[i]))
                    else
        if ToNumberPinsOneWire then
           NumberPinsOneWire.Add(IntToStr(Data[i]))
                               else
           NumberPinsInterrupt.Add(IntToStr(Data[i]));
    end;
  end;
end;

procedure TIVchar.FormCreate(Sender: TObject);
begin
 DecimalSeparator:='.';
 ComponentView();

 ConfigFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'IVChar.ini');
 ShowArray:=TObjectArray.Create;
 AnyObjectArray:=TObjectArray.Create;
 NumberPins:=TStringList.Create;
 NumberPinsOneWire:=TStringList.Create;
 NumberPinsInterrupt:=TStringList.Create;
 PinsFromIniFile();

 VoltmetrsCreate();
 ET1255Create();
 VectorsCreate();

 ConstantShowCreate();
 ConstantShowFromIniFile();

 PIDShowCreateAndFromIniFile();
 BoxFromIniFile();


 RangesCreate();
 StepsReadFromIniFile();
 ForwStepShow();
 RevStepShow();

 DelayTimeReadFromIniFile();

 DACCreate();
 DACReadFromIniFileAndToForm;

 DevicesCreate();
 DependenceMeasuringCreate();
 ShowObjectsReadFromIniFileAndToForm();

 ComPortsBegining;


 RS232_MediatorTread:=TRS232_MediatorTread.Create(
                 [DACR2R,V721A,V721_I,V721_II,DS18B20,
                 TMP102,
                 HTU21D,
                 D30_06,IscVocPinChanger,LEDOpenPinChanger,
                 MCP3424]);

 if (ComPort1.Connected)and(SettingDevice.ActiveInterface.Name=DACR2R.Name) then SettingDevice.Reset();
 if (ComPort1.Connected) then D30_06.Reset;
end;

procedure TIVchar.FormDestroy(Sender: TObject);
begin

 if SBTAuto.Down then TemperatureMeasuringThread.Terminate;
 if SBControlBegin.Down then ControllerThread.Terminate;

 if assigned(DependTimer) then DependTimer.Free;

 DACWriteToIniFile();
 ShowObjectsWriteToIniFileAndFree();
 PinsWriteToIniFile;
 SettingWriteToIniFile();
 ConfigFile.Free;

 ObjectsFree();
 DACFree();

 ShowArray.Free;
 AnyObjectArray.Free;

  if RS232_MediatorTread <> nil
   then RS232_MediatorTread.Terminate;

 VectorsDispose();

 NumberPins.Free;
 NumberPinsOneWire.Free;
 NumberPinsInterrupt.Free;

 ComPortsEnding([ComPortUT70C,ComPortUT70B,ComPort1]);
end;


procedure TIVchar.PCChange(Sender: TObject);
 var i:integer;
begin
 for I := 0 to High(VoltmetrShows) do
   try
   if VoltmetrShows[i].AutoSpeedButton.Down then
     begin
       VoltmetrShows[i].AutoSpeedButton.Down:=False;
       VoltmetrShows[i].AutoSpeedButton.OnClick(Sender);
     end;
   except
   end;
end;

procedure TIVchar.PCChanging(Sender: TObject; var AllowChange: Boolean);
begin
 AllowChange:=False;
end;

procedure TIVchar.PIDShowCreateAndFromIniFile;
begin
  PID_Termostat_ParametersShow:=
   TPID_ParametersShow.Create('PIDTermostat',
           STTermostatKp,STTermostatKi,STTermostatKd,STTermostatNT,STTermostatTolerance,
           LTermostatKp,LTermostatKi,LTermostatKd,LTermostatNT,LTermostatTolerance);

  PID_Control_ParametersShow:=
   TPID_ParametersShow.Create('PIDControl',
           STControlKp,STControlKi,STControlKd,STControlNV,STControlTolerance,
           LControlKp,LControlKi,LControlKd,LControlNV,LControlTolerance);

  ShowArray.Add([PID_Termostat_ParametersShow,PID_Control_ParametersShow]);

end;

procedure TIVchar.SGFBStepDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
 if (ARow>1)and(not(odd(Arow))) then
  begin
     SGFBStep.Canvas.Brush.Color:=RGB(252,212,213);
     SGFBStep.Canvas.FillRect(Rect);
     SGFBStep.Canvas.TextOut(Rect.Left+2,Rect.Top+2,SGFBStep.Cells[Acol,Arow]);
  end
end;

procedure TIVchar.SGFBStepSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
 if (Sender as TStringGrid).Name='SGFBStep' then
  begin
    BFBEdit.Enabled:=True;
    BFBDelete.Enabled:=True;
  end;
 if (Sender as TStringGrid).Name='SGRBStep' then
  begin
    BRBEdit.Enabled:=True;
    BRBDelete.Enabled:=True;
  end;
end;

procedure TIVchar.SGRBStepDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
 if (ARow>1)and(not(odd(Arow))) then
  begin
     SGRBStep.Canvas.Brush.Color:=RGB(218,240,254);
     SGRBStep.Canvas.FillRect(Rect);
     SGRBStep.Canvas.TextOut(Rect.Left+2,Rect.Top+2,SGRBStep.Cells[Acol,Arow]);
  end
end;

procedure TIVchar.NameToLabel(LabelName: string; Name, NameValue: TLabel);
begin
if LabelName='' then
    begin
     NameValue.Visible:=False;
     Name.Visible:=False;
    end               else
    begin
     NameValue.Visible:=True;
     Name.Visible:=True;
     NameValue.Caption := Undefined;
     Name.Caption := LabelName+':';
    end;
end;

procedure TIVchar.MeasurementsLabelCaptionDefault;
begin
  MeasurementsLabelCaption(['Voltage', 'Current', 'Input Voltage']);
end;

procedure TIVchar.MeasurementTimeParameterDetermination(Dependence:TTimeDependenceTimer);
begin
  Dependence.Interval := round(StrToFloat(STTimeInterval.Caption));
  Dependence.Duration := round(StrToFloat(STTimeDuration.Caption));
end;

procedure TIVchar.ComPortsBegining;
begin
  ComPortsLoadSettings([ComPortUT70C,ComPortUT70B,ComPort1]);
  ComCBUT70CPort.UpdateSettings;
  ComCBUT70BPort.UpdateSettings;
  ComCBBR.UpdateSettings;
  ComCBPort.UpdateSettings;
  ComDPacket.StartString := PacketBeginChar;
  ComDPacket.StopString := PacketEndChar;
  ComDPacket.ComPort := ComPort1;

//to comment on some PC

//  PortBeginAction(ComPortUT70B, LUT70BPort, nil);
//  PortBeginAction(ComPortUT70C, LUT70CPort, nil);


  PortBeginAction(ComPort1, LConnected, BConnect);
end;

procedure TIVchar.ComPortsEnding(ComPorts: array of TComPort);
var
  I: Integer;
begin
  for I := 0 to High(ComPorts) do PortEndAction(ComPorts[i]);
end;

procedure TIVchar.ComPortsLoadSettings(ComPorts:array of TComPort);
var
  I: Integer;
begin
  for I := 0 to High(ComPorts) do
   ComPorts[i].LoadSettings(stIniFile, ExtractFilePath(Application.ExeName) + 'IVChar.ini');
end;

procedure TIVchar.ComPortsWriteSettings(ComPorts: array of TComPort);
var
  I: Integer;
begin
  for I := 0 to High(ComPorts) do
   ComPorts[i].StoreSettings(stIniFile,ExtractFilePath(Application.ExeName)+'IVChar.ini');
end;

procedure TIVchar.RangeShow(Sender: TObject);
 begin
  if CBMeasurements.Items[CBMeasurements.ItemIndex]
        =MeasR2RCalib
        then  LimitsToLabel(CalibrRangeFor,CalibrRangeRev)
        else  LimitsToLabel(IVCharRangeFor,IVCharRangeRev);
end;

procedure TIVchar.RangeShowLimit;
begin
 RangeShow(Self);
end;

procedure TIVchar.RangesCreate;
begin
  IVCharRangeFor:=TLimitShow.Create('IV_Forv',Vmax,2,UDFBHighLimit,UDFBLowLimit,LFBHighlimitValue,LFBLowlimitValue,RangeShowLimit);
  IVCharRangeRev:=TLimitShowRev.Create('IV_Rev',Vmax,1,UDRBHighLimit,UDRBLowLimit,LRBHighlimitValue,LRBLowlimitValue,RangeShowLimit);
  CalibrRangeFor:=TLimitShow.Create('Calibr_Forv',Vmax,2,UDFBHighLimitR2R,UDFBLowLimitR2R,LFBHighlimitValueR2R,LFBLowlimitValueR2R,RangeShowLimit);
  CalibrRangeRev:=TLimitShowRev.Create('Calibr_Rev',Vmax,2,UDRBHighLimitR2R,UDRBLowLimitR2R,LRBHighlimitValueR2R,LRBLowlimitValueR2R,RangeShowLimit);
  ShowArray.Add([IVCharRangeFor,IVCharRangeRev,CalibrRangeFor,CalibrRangeRev]);
end;


procedure TIVchar.StepsReadFromIniFile;
begin
  StepReadFromIniFile(ForwSteps,'Forw');
  StepReadFromIniFile(RevSteps,'Rev');
  VolCorrection^.ReadFromIniFile(ConfigFile, 'Step', 'Correction');
  VolCorrection^.DeleteErResult;
  VolCorrection^.Sorting;
end;

function TIVchar.StepDetermine(Voltage: Double; ItForward: Boolean): double;
var
  Steps: PVector;
  I: Integer;
begin
  Result := StepDefault;
  if ItForward then
    Steps := ForwSteps
  else
    Steps := RevSteps;
  for I := 0 to High(Steps^.X) do
    if abs(Voltage) < Steps^.X[i] then
    begin
      Result := Steps^.Y[i];
      Break;
    end;
end;

procedure TIVchar.StepReadFromIniFile(A:PVector; Ident:string);
begin
  A^.ReadFromIniFile(ConfigFile, 'Step', Ident);
  A^.DeleteErResult;
  A^.DeleteDuplicate;
  A^.Sorting;
  while (A^.n > 0) and (A^.X[High(A^.X)] > Vmax) do
    A^.Delete(A^.n - 1);
  while (A^.n > 0) and (A^.X[0] < 0) do
    A^.Delete(A^.n - 1);
  if (A^.n > 0) and (A^.X[High(A^.X)] <> Vmax) then
    begin
     A^.SetLenVector(A^.n+1);
     A^.X[High(A^.X)] := Vmax;
     A^.Y[High(A^.X)] := StepDefault;
    end;
  if A^.n < 1 then
    begin
      A^.SetLenVector(1);
      A^.X[0] := Vmax;
      A^.Y[0] := StepDefault;
    end;
end;

procedure TIVchar.StepsWriteToIniFile;
begin
  ConfigFile.EraseSection('Step');
  ForwSteps.WriteToIniFile(ConfigFile, 'Step', 'Forw');
  RevSteps.WriteToIniFile(ConfigFile, 'Step', 'Rev');
  VolCorrection.WriteToIniFile(ConfigFile, 'Step', 'Correction');
end;

procedure TIVchar.ForwStepShow;
 var
  I: Integer;
begin
  SGFBStep.RowCount := ForwSteps^.n + 1;
  for I := 0 to High(ForwSteps^.X) do
   begin
     SGFBStep.Cells[0,i+1]:=FloatToStrF(ForwSteps^.X[i],ffGeneral,2,1);
     SGFBStep.Cells[1,i+1]:=FloatToStrF(ForwSteps^.Y[i],ffGeneral,4,3);
   end;
end;

procedure TIVchar.RevStepShow;
 var
  I: Integer;
begin
  SGRBStep.RowCount := RevSteps^.n + 1;
  for I := 0 to High(RevSteps^.X) do
   begin
     SGRBStep.Cells[0,i+1]:=FloatToStrF(-RevSteps^.X[i],ffGeneral,2,1);
     SGRBStep.Cells[1,i+1]:=FloatToStrF(RevSteps^.Y[i],ffGeneral,3,2);
   end;
end;


procedure TIVchar.DelayTimeReadFromIniFile;
 var temp:integer;
begin
  temp:=ConfigFile.ReadInteger('Delay', 'ForwTime', 0);
  if (temp<0)or(temp>10000) then temp:=0;
  LFBDelayValue.Caption := IntToStr(temp);
  temp:=ConfigFile.ReadInteger('Delay', 'RevTime', 0);
  if (temp<0)or(temp>10000) then temp:=0;
  LRBDelayValue.Caption := IntToStr(temp);
end;

procedure TIVchar.DelayTimeWriteToIniFile;
begin
  WriteIniDef(ConfigFile, 'Delay', 'ForwTime', StrToInt(LFBDelayValue.Caption), 0);
  WriteIniDef(ConfigFile, 'Delay', 'RevTime', StrToInt(LRBDelayValue.Caption), 0);
end;

procedure TIVchar.BoxFromIniFile;
 var
  i: Integer;
begin
 try
   for i := IVchar.ComponentCount - 1 downto 0 do
    begin
     if IVchar.Components[i].Tag in [6,7] then
     (IVchar.Components[i] as TCheckBox).Checked:=
       ConfigFile.ReadBool('Box', (IVchar.Components[i] as TCheckBox).Name, False);
      if IVchar.Components[i].Tag=7 then
     (IVchar.Components[i] as TCheckBox).OnClick:=RangeShow;
    end;
 finally
 end;

  RGDO.ItemIndex:= ConfigFile.ReadInteger('Box', RGDO.Name,0);
  try
   ChDir(ConfigFile.ReadString('Box', 'Directory',ExtractFilePath(Application.ExeName)));
  except
   ChDir(ExtractFilePath(Application.ExeName));
  end;

  CBFvsS.Checked:=ConfigFile.ReadBool('Box', CBFvsS.Name,False);

end;

procedure TIVchar.BoxToIniFile;
 var
  i: Integer;
begin
 ConfigFile.EraseSection('Box');
 try
   for i := IVchar.ComponentCount - 1 downto 0 do
    if IVchar.Components[i].Tag in [6,7] then
     WriteIniDef(ConfigFile, 'Box', (IVchar.Components[i] as TCheckBox).Name,
       (IVchar.Components[i] as TCheckBox).Checked);
 finally
 end;
  WriteIniDef(ConfigFile, 'Box', RGDO.Name, RGDO.ItemIndex);
  WriteIniDef(ConfigFile, 'Box','Directory',GetCurrentDir,ExtractFilePath(Application.ExeName));
  WriteIniDef(ConfigFile, 'Box', CBFvsS.Name, CBFvsS.Checked);

end;


procedure TIVchar.VectorsCreate;
begin
  new(ForwSteps);
  new(RevSteps);
  new(IVResult);
  new(VolCorrection);
  new(VolCorrectionNew);
  new(TemperData);
end;

procedure TIVchar.VectorsDispose;
begin
  dispose(ForwSteps);
  dispose(RevSteps);
  dispose(IVResult);
  dispose(VolCorrection);
  dispose(VolCorrectionNew);
  dispose(TemperData);
end;


procedure TIVchar.SBControlBeginClick(Sender: TObject);
begin
 if SBControlBegin.Down then
    begin
    PID_Control:=TPID.Create(PID_Control_ParametersShow,
                             DoubleConstantShows[10].Data);
    ControllerThreadCreate();
    ControlWatchDog.Interval:=round(StrToFloat(STControlInterval.Caption))*2000;
    ControlWatchDog.Enabled:=True;
    SBControlBegin.Caption:='Stop Controling';
    end
                 else
    begin
    ControllerThread.Terminate;
    ControlWatchDog.Enabled:=False;
    LControlWatchDog.Visible:=False;
    SBControlBegin.Caption:='Start Controling';
    PID_Control.Free;
    end;
end;

procedure TIVchar.SBGeneratorClick(Sender: TObject);
 var i:byte;
begin
 if SBGenerator.Down then
  begin
    repeat
     for I := 0 to 20 do
       begin
         ET1255_DACs[0].Output(i*0.1+0.01*i);
         HRDelay(1);
         ET1255_DACs[0].Output(i*0.1);
         HRDelay(5);
       end;
      Application.ProcessMessages;
    until not(SBGenerator.Down);
  end
                     else
   ET1255_DACs[0].Reset();

end;

procedure TIVchar.SBTAutoClick(Sender: TObject);
begin
 if SBTAuto.Down then
    TemperatureThreadCreate()
                 else
    TemperatureMeasuringThread.Terminate;
end;

procedure TIVchar.SBTermostatClick(Sender: TObject);
begin
 if SBTermostat.Down then
    begin
    IsWorkingTermostat:=True;
    IsPID_Termostat_Created:=False;
    SBTermostat.Caption:='Stop PID Control';
    if not(SBTAuto.Down) then
        begin
        SBTAuto.Down:=True;
        TemperatureThreadCreate()
        end;
    end
                 else
    begin
    IsWorkingTermostat:=False;
    SBTermostat.Caption:='Start PID Control';
    if assigned(PID_Termostat) then
      begin
      PID_Termostat.Free;
      TermostatWatchDog.Enabled:=False;
      LTermostatWatchDog.Visible:=False;
      end;
    IsPID_Termostat_Created:=False;
    end;
end;

procedure TIVchar.SettingWriteToIniFile;
begin
  StepsWriteToIniFile;
  DelayTimeWriteToIniFile;
  BoxToIniFile;
  ConstantShowToIniFileAndFree();
  ComPortsWriteSettings([ComPortUT70C,ComPortUT70B,ComPort1]);
end;

procedure TIVchar.TemperatureOnTimeFirstMeas;
begin
 TDependence.tempIChange(Temperature_MD.ActiveInterface.Value);
 LADVoltageValue.Caption:=FloatToStrF(TDependence.tempI,ffFixed, 5, 2);
end;


procedure TIVchar.TemperatureThreadCreate;
begin
  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
  TemperatureMeasuringThread:=
    TTemperatureMeasuringThread.Create(Temperature_MD.ActiveInterface,
                                       round(StrToFloat(STTMI.Caption)),
                                       EventMeasuringEnd);
end;


procedure TIVchar.TimeDHookFirstMeas;
begin
 TDependence.tempIChange(TimeD_MD.ActiveInterface.GetData);
 LADVoltageValue.Caption:=FloatToStrF(TDependence.tempI,ffExponent, 4, 3);
end;

procedure TIVchar.TimeDHookSecondMeas;
begin
 LADCurrentValue.Caption:=FloatToStrF(TDependence.tempV,ffExponent, 4, 3);
end;


procedure TIVchar.TimeTwoDHookFirstMeas;
begin
 TimeDHookFirstMeas;

end;

procedure TIVchar.TimeTwoDHookSecondMeas;
begin
 TTimeTwoDependenceTimer.SecondValueChange(TimeD_MD2.ActiveInterface.GetData);
 if TimeTwoDependenceTimer.isTwoValueOnTime then
    begin
    LADInputVoltageValue.Caption:=FloatToStrF(TTimeTwoDependenceTimer.SecondValue,ffExponent, 4, 3);
    TimeDHookSecondMeas;
    end
                                            else
    LADCurrentValue.Caption:=FloatToStrF(TTimeTwoDependenceTimer.SecondValue,ffExponent, 4, 3);

end;

procedure TIVchar.TermostatWatchDogTimer(Sender: TObject);
begin
 if (Temperature_MD.ActiveInterface.NewData)
    and(Temperature_MD.ActiveInterface.Value<>ErResult)
  then
    begin
    LTermostatWatchDog.Visible:=True;
    if ((TDependence.PointNumber mod 10)=0)or
       ((TDependence.PointNumber mod 10)=1)
     then
       begin
       if assigned(TemperatureMeasuringThread) then
        begin
         TemperatureMeasuringThread.Terminate;
         sleep(1000);
        end;
       TemperatureThreadCreate();
       end;
    end
  else
    begin
    LTermostatWatchDog.Visible:=False;
    BTermostatResetClick(Sender);
    end;

  TermostatWatchDog.Interval:=round(StrToFloat(STTMI.Caption))*2000;
  Temperature_MD.ActiveInterface.NewData:=False;
end;

procedure TIVchar.VoltmetrsCreate;
begin
  V721A := TV721A.Create(ComPort1, 'B7-21A');
  V721_I := TV721.Create(ComPort1, 'B7-21 (1)');
  V721_II := TV721.Create(ComPort1, 'B7-21 (2)');
//  V721_II := TV721_Brak.Create(ComPort1, 'B7-21 (2)');
  SetLength(VoltmetrShows,3);
  VoltmetrShows[0]:= TVoltmetrShow.Create(V721A, RGV721A_MM, RGV721ARange, LV721A, LV721AU, PV721APin, PV721APinG, {BV721ASet, BV721ASetGate, }BV721AMeas, SBV721AAuto, NumberPins{CBV721A}, Time);
  VoltmetrShows[1]:= TVoltmetrShow.Create(V721_I, RGV721I_MM, RGV721IRange, LV721I, LV721IU, PV721IPin, PV721IPinG, {BV721ISet, BV721ISetGate,} BV721IMeas, SBV721IAuto, NumberPins{CBV721I}, Time);
  VoltmetrShows[2]:= TVoltmetrShow.Create(V721_II, RGV721II_MM, RGV721IIRange, LV721II, LV721IIU, PV721IIPin, PV721IIPinG, {BV721IISet, BV721IISetGate,} BV721IIMeas, SBV721IIAuto, NumberPins{CBV721II}, Time);

  DS18B20:=TDS18B20.Create(ComPort1, 'DS18B20');
  DS18B20show:=TOnePinsShow.Create(DS18B20.Pins,PDS18BPin,NumberPinsOneWire);


  TMP102:=TTMP102.Create(ComPort1, 'TMP102');
  TMP102show:=TI2C_PinsShow.Create(TMP102.Pins,PTMP102Pin, TMP102_StartAdress,TMP102_LastAdress);


  HTU21D:=THTU21D.Create(ComPort1, 'HTU21D');

  ThermoCuple:=TThermoCuple.Create;

  IscVocPinChanger:=TArduinoPinChanger.Create(ComPort1,'IscVocPin');
  IscVocPinChangerShow:=TArduinoPinChangerShow.Create(IscVocPinChanger,PIscVocPin,{BIscVocPin,}BIscVocPinChange,{CBIscVocPin}NumberPins);
  LEDOpenPinChanger:=TArduinoPinChanger.Create(ComPort1,'LEDOpenPin');
  LEDOpenPinChangerShow:=TArduinoPinChangerShow.Create(LEDOpenPinChanger,PLEDOpenPin,{BLEDOpenPin,}BLEDOpenPinChange,{CBLEDOpenPin}NumberPins);

  ShowArray.Add([VoltmetrShows[0],VoltmetrShows[1],VoltmetrShows[2]]);
  ShowArray.Add([DS18B20show,TMP102show,
                IscVocPinChangerShow,LEDOpenPinChangerShow]);
  AnyObjectArray.Add([V721A,V721_I,V721_II]);
  AnyObjectArray.Add([DS18B20,TMP102,HTU21D,
                      IscVocPinChanger,LEDOpenPinChanger]);

  MCP3424Create();

  UT70B:=TUT70B.Create(ComPortUT70B, 'UT70B');
  UT70BShow:= TUT70BShow.Create(UT70B, RGUT70B_MM, RGUT70B_Range, RGUT70B_RangeM, LUT70B, LUT70BU, BUT70BMeas, SBUT70BAuto, Time);
  UT70C:=TUT70C.Create(ComPortUT70C, 'UT70C');
  UT70CShow:= TUT70CShow.Create(UT70C, RGUT70C_MM,
       RGUT70C_Range, RGUT70C_RangeM, LUT70C, LUT70CU,
       BUT70CMeas, SBUT70CAuto, Time,
       LUT70C_Hold,LUT70C_rec,LUT70C_AvTime,LUT70C_AVG);

  ShowArray.Add([UT70BShow,UT70CShow]);
  AnyObjectArray.Add([UT70B,UT70C]);
end;

procedure TIVchar.ShowObjectsReadFromIniFileAndToForm;
 var i:integer;
begin
 for i:=0 to High(ShowArray.ObjectArray) do
  begin
   if (ShowArray.ObjectArray[i] is TLimitShow) then
     begin
      (ShowArray.ObjectArray[i] as TLimitShow).ReadFromIniFile(ConfigFile);
      Continue;
     end;

   if (ShowArray.ObjectArray[i] is  TMCP3424_ChannelShow) then
     begin
      (ShowArray.ObjectArray[i] as  TMCP3424_ChannelShow).PinsReadFromIniFile(ConfigFile);
      (ShowArray.ObjectArray[i] as  TMCP3424_ChannelShow).NumberPinShow;
      Continue;
     end;


   if (ShowArray.ObjectArray[i] is TPinsShowUniversal) then
     begin
      (ShowArray.ObjectArray[i] as TPinsShowUniversal).PinsReadFromIniFile(ConfigFile);
      (ShowArray.ObjectArray[i] as TPinsShowUniversal).NumberPinShow;
      Continue;
     end;

   if (ShowArray.ObjectArray[i] is TVoltmetrShow) then
     begin
      (ShowArray.ObjectArray[i] as TVoltmetrShow).PinShow.PinsReadFromIniFile(ConfigFile);
      (ShowArray.ObjectArray[i] as TVoltmetrShow).PinShow.NumberPinShow;
      Continue;
     end;
   if (ShowArray.ObjectArray[i] is TPID_ParametersShow) then
     begin
      (ShowArray.ObjectArray[i] as TPID_ParametersShow).ReadFromIniFile(ConfigFile);
      Continue;
     end;

   if (ShowArray.ObjectArray[i] is TDevice) then
     begin
      (ShowArray.ObjectArray[i] as TDevice).ReadFromIniFile(ConfigFile,MD_IniSection);
      Continue;
     end;
  end;

end;

procedure TIVchar.ShowObjectsWriteToIniFileAndFree;
  var i:integer;
begin
  ConfigFile.EraseSection(PID_Param);
  ConfigFile.EraseSection(MD_IniSection);
  ConfigFile.EraseSection(RangeSection);

 for i:=0 to High(ShowArray.ObjectArray) do
  begin
   if (ShowArray.ObjectArray[i] is TLimitShow) then
    begin
    (ShowArray.ObjectArray[i] as TLimitShow).WriteToIniFile(ConfigFile);
    (ShowArray.ObjectArray[i] as TLimitShow).Free;
    Continue;
    end;

   if (ShowArray.ObjectArray[i] is TDevice) then
    begin
    (ShowArray.ObjectArray[i] as TDevice).WriteToIniFile(ConfigFile,MD_IniSection);
    (ShowArray.ObjectArray[i] as TDevice).Free;
    Continue;
    end;

   if (ShowArray.ObjectArray[i] is TPID_ParametersShow) then
    begin
    (ShowArray.ObjectArray[i] as TPID_ParametersShow).WriteToIniFile(ConfigFile);
    (ShowArray.ObjectArray[i] as TPID_ParametersShow).Free;
    Continue;
    end;

   if (ShowArray.ObjectArray[i] is TMCP3424_ChannelShow) then
    begin
    (ShowArray.ObjectArray[i] as TMCP3424_ChannelShow).PinsWriteToIniFile(ConfigFile);
    (ShowArray.ObjectArray[i] as TMCP3424_ChannelShow).Free;
    Continue;
    end;

   if (ShowArray.ObjectArray[i] is TPinsShowUniversal) then
    begin
    (ShowArray.ObjectArray[i] as TPinsShowUniversal).PinsWriteToIniFile(ConfigFile);
    (ShowArray.ObjectArray[i] as TPinsShowUniversal).Free;
    Continue;
    end;

   if (ShowArray.ObjectArray[i] is TVoltmetrShow) then
     begin
      (ShowArray.ObjectArray[i] as TVoltmetrShow).PinShow.PinsWriteToIniFile(ConfigFile);
      (ShowArray.ObjectArray[i] as TVoltmetrShow).Free;
      Continue;
     end;

   if (ShowArray.ObjectArray[i] is TUT70BShow) then
    begin
     (ShowArray.ObjectArray[i] as TUT70BShow).Free;
     Continue;
    end;


   if (ShowArray.ObjectArray[i] is TET1255_ModuleAndChan) then
    begin
    (ShowArray.ObjectArray[i] as TET1255_ModuleAndChan).WriteToIniFile(ConfigFile);
    (ShowArray.ObjectArray[i] as TET1255_ModuleAndChan).Free;
    Continue;
    end;

   if (ShowArray.ObjectArray[i] is TET1255_ADCShow) then
     begin
      (ShowArray.ObjectArray[i] as TET1255_ADCShow).Free;
      Continue;
     end;

   ShowArray.ObjectArray[i].Free;
  end;

// if ET1255isPresent then
//  ET1255_ADCModule.WriteToIniFile(ConfigFile);
end;

procedure TIVchar.WMMyMeasure(var Mes: TMessage);
begin
  if Mes.WParam=TemperMessage then
    begin
      LTRValue.Caption:=FloatToStrF(Temperature_MD.ActiveInterface.Value,ffFixed, 5, 2);
      LTermostatCTValue.Caption:=FloatToStrF(Temperature_MD.ActiveInterface.Value,ffFixed, 5, 2);
      if LTermostatCTValue.Font.Color=clBlue
        then LTermostatCTValue.Font.Color:=clRed
        else LTermostatCTValue.Font.Color:=clBlue;

      if IsWorkingTermostat then
        begin
          if IsPID_Termostat_Created then
              PID_Termostat.ControlingSignal(Temperature_MD.ActiveInterface.Value)
                                     else
            begin
              PID_Termostat:=TPID.Create(PID_Termostat_ParametersShow,
                                         DoubleConstantShows[7].Data
                                         );
              IsPID_Termostat_Created:=True;
              TermostatWatchDog.Interval:=round(StrToFloat(STTMI.Caption))*2000;
              TermostatWatchDog.Enabled:=True;
            end;
          SettingTermostat.ActiveInterface.Output(PID_Termostat.OutputValue);
          LTermostatOutputValue.Caption:=
              FloatToStrF(SettingTermostat.ActiveInterface.OutputValue,ffExponent,4,2);
        end;
      if TemperatureOnTime.isActive then
        TemperatureOnTime.PeriodicMeasuring;
    end;


  if Mes.WParam=ControlMessage then
    begin
      LControlCVValue.Caption:=FloatToStrF(Control_MD.ActiveInterface.Value,ffExponent, 4, 2);
      if ControlParameterTime.isActive then
        ControlParameterTime.PeriodicMeasuring;
    end;

  if Mes.WParam=ControlOutputMessage then
    begin
      LControlCCValue.Caption:=FloatToStrF(SettingDeviceControl.ActiveInterface.OutputValue,ffExponent,5,1);
    end;
end;

procedure TIVchar.HookEndReset;
begin
  SettingDevice.ActiveInterface.Reset();
  sleep(1000);
end;

procedure TIVchar.SaveDialogPrepare;
var
  last: string;
begin
  last := LastDATFileName;
  if last <> NoFile then
  begin
    try
      SaveDialog.FileName := IntToStr(StrToInt(last) + 1) + '.dat';
    except
      SaveDialog.FileName := last + '1.dat';
    end;
  end
                     else
  SaveDialog.FileName := '1.dat';

  SaveDialog.Title := 'Last file - ' + last + '.dat';
  SaveDialog.InitialDir := GetCurrentDir;
end;

procedure TIVchar.MeasurementsLabelCaption(LabelNames:array of string);
begin
  if High(LabelNames)<2 then Exit;
  NameToLabel(LabelNames[0],LADVoltage,LADVoltageValue);
  NameToLabel(LabelNames[1],LADCurrent,LADCurrentValue);
  NameToLabel(LabelNames[2],LADInputVoltage,LADInputVoltageValue);
end;

procedure TIVchar.ObjectsFree;
 var i:integer;
begin

//вносимо типи, для яких процедура Free переозначена
//якщо переозначена у нащадка, то він має в цьому циклі зустрітися раніше предка
  for i:=0 to High(AnyObjectArray.ObjectArray) do
  begin

   if (AnyObjectArray.ObjectArray[i] is TET1255_DAC) then
    begin
    (AnyObjectArray.ObjectArray[i] as TET1255_DAC).Reset();
    (AnyObjectArray.ObjectArray[i] as TET1255_DAC).Free();
     Continue;
    end;


   if (AnyObjectArray.ObjectArray[i] is TArduinoMeter) then
    begin
    (AnyObjectArray.ObjectArray[i] as TArduinoMeter).Free;
    Continue;
    end;

   if (AnyObjectArray.ObjectArray[i] is TArduinoRS232Device) then
    begin
    (AnyObjectArray.ObjectArray[i] as TArduinoRS232Device).Free;
    Continue;
    end;

   if (AnyObjectArray.ObjectArray[i] is TRS232Device) then
    begin
     (AnyObjectArray.ObjectArray[i] as TRS232Device).Free;
     Continue;
    end;


   if (AnyObjectArray.ObjectArray[i] is TMCP3424_Channel) then
    begin
     (AnyObjectArray.ObjectArray[i] as TMCP3424_Channel).Free;
     Continue;
    end;

    AnyObjectArray.ObjectArray[i].Free;
  end;

  for I := 0 to High(Dependencies) do
    Dependencies[i].Free;

  ThermoCuple.Free;
  Simulator.Free;
end;

procedure TIVchar.DACCreate;
begin
  DACR2R:=TDACR2R.Create(ComPort1,'DAC R-2R');
  DACR2RShow:=TDACR2RShow.Create(DACR2R,PDACR2RPinC,LOVDACR2R,LOKDACR2R,
                                 BOVchangeDACR2R,
                                 BOVsetDACR2R, BOKchangeDACR2R, BOKsetDACR2R,
                                 BDACR2RReset, NumberPins);
  D30_06:=TD30_06.Create(ComPort1,'D30_06');
  D30_06Show:=TD30_06Show.Create(D30_06,PD30PinC,PD30PinG,LOVD30,LOKD30,LValueRangeD30,
                                 BOVchangeD30,
                                 BOVsetD30, BOKchangeD30, BOKsetD30,
                                 BD30Reset, NumberPins, RGD30);
end;

procedure TIVchar.DACFree;
begin
  if assigned(DACR2R) then
    begin
    DACR2R.Reset;
    sleep(100);
    DACR2R.Free;
    end;

  DACR2RShow.Free;

  D30_06Show.Free;
  if assigned(D30_06) then
    begin
    D30_06.Reset;
    sleep(50);
    D30_06.Free;
    end;

end;

procedure TIVchar.DACReadFromIniFileAndToForm;
begin
  DACR2RShow.PinShow.PinsReadFromIniFile(ConfigFile);
  DACR2RShow.PinShow.NumberPinShow;
  ParametersFileWork(DACR2R.CalibrationRead);

  D30_06Show.ReadFromIniFileAndToForm(ConfigFile);
end;

procedure TIVchar.DACWriteToIniFile;
begin
  DACR2RShow.PinShow.PinsWriteToIniFile(ConfigFile);
  D30_06Show.WriteToIniFile(ConfigFile);
end;

procedure TIVchar.DevicesCreate;
begin
  Simulator:=TSimulator.Create;
  SetLength(Devices,4);
  Devices[0]:=Simulator;
  Devices[1]:=V721A;
  Devices[2]:=V721_I;
  Devices[3]:=V721_II;

  TermoCouple_MD:=TMeasuringDevice.Create(Devices, CBTcVMD, 'Thermocouple', LTRValue, srVoltge);
  Temperature_MD:=TTemperature_MD.Create([Simulator,ThermoCuple,DS18B20,HTU21D,TMP102],CBTD,'Temperature',LTRValue);
  ShowArray.Add([TermoCouple_MD,Temperature_MD]);

  SetLength(Devices,High(Devices)+3);
  Devices[High(Devices)-1]:=UT70B;
  Devices[High(Devices)]:=UT70C;

  if ET1255isPresent then
   begin
    SetLength(Devices,High(Devices)+4);
    Devices[High(Devices)-2]:=ET1255_ADCModule.Channels[0];
    Devices[High(Devices)-1]:=ET1255_ADCModule.Channels[1];
    Devices[High(Devices)]:=ET1255_ADCModule.Channels[2];
   end;

  SetLength(Devices,High(Devices)+5);
  Devices[High(Devices)-3]:=MCP3424_Channel[0];
  Devices[High(Devices)-2]:=MCP3424_Channel[1];
  Devices[High(Devices)-1]:=MCP3424_Channel[2];
  Devices[High(Devices)]:=MCP3424_Channel[3];

  Current_MD:=TMeasuringDevice.Create(Devices, CBCMD,'Current', LADCurrentValue, srCurrent);
  VoltageIV_MD:=TMeasuringDevice.Create(Devices, CBVMD,'Voltage', LADVoltageValue, srVoltge);

  DACR2R_MD:=TMeasuringDevice.Create(Devices, CBMeasDACR2R,'R2R', LMeasR2R, srPreciseVoltage);
  DACR2R_MD.AddActionButton(BMeasR2R);
  D30_MD:=TMeasuringDevice.Create(Devices, CBMeasD30,'D30', LMeasD30, srPreciseVoltage);
  D30_MD.AddActionButton(BMeasD30);

  Isc_MD:=TMeasuringDevice.Create(Devices, CBIscMD,'Isc' , LIscResult, srCurrent);
  Isc_MD.AddActionButton(BIscMeasure);
  Voc_MD:=TMeasuringDevice.Create(Devices, CBVocMD,'Voc' , LVocResult, srPreciseVoltage);
  Voc_MD.AddActionButton(BVocMeasure);

  ShowArray.Add([Current_MD,VoltageIV_MD,DACR2R_MD,D30_MD,Isc_MD,Voc_MD]);

  SetLength(Devices,High(Devices)+5);
  Devices[High(Devices)-3]:=ThermoCuple;
  Devices[High(Devices)-2]:=DS18B20;
  Devices[High(Devices)-1]:=HTU21D;
  Devices[High(Devices)]:=TMP102;

  TimeD_MD:=
    TMeasuringDevice.Create(Devices, CBTimeMD,'Time Dependence', LADCurrentValue, srVoltge);
  TimeD_MD2:=
    TMeasuringDevice.Create(Devices, CBTimeMD2,'Time Dependence Two', LADInputVoltageValue, srVoltge);
  Control_MD:=
    TMeasuringDevice.Create(Devices, CBControlMD,'Control setup', LControlCVValue, srPreciseVoltage);
  ShowArray.Add([TimeD_MD,TimeD_MD2,Control_MD]);

  SetLength(DevicesSet,2);
  DevicesSet[0]:=Simulator;
  DevicesSet[1]:=DACR2R;

  if ET1255isPresent then
   begin
    SetLength(DevicesSet,High(DevicesSet)+4);
    DevicesSet[High(DevicesSet)-2]:=ET1255_DACs[0];
    DevicesSet[High(DevicesSet)-1]:=ET1255_DACs[1];
    DevicesSet[High(DevicesSet)]:=ET1255_DACs[2];

    ET1255_DAC_MD[0]:=TMeasuringDevice.Create(Devices,
                      CBMeasET1255Ch0,'ET1255_DAC_Ch0',LMeas1255Ch0,srPreciseVoltage);
    ET1255_DAC_MD[0].AddActionButton(BMeas1255Ch0);
    ET1255_DAC_MD[1]:=TMeasuringDevice.Create(Devices,
                      CBMeasET1255Ch1,'ET1255_DAC_Ch1',LMeas1255Ch1,srPreciseVoltage);
    ET1255_DAC_MD[1].AddActionButton(BMeas1255Ch1);
    ET1255_DAC_MD[2]:=TMeasuringDevice.Create(Devices,
                      CBMeasET1255Ch2,'ET1255_DAC_Ch2',LMeas1255Ch2,srPreciseVoltage);
    ET1255_DAC_MD[2].AddActionButton(BMeas1255Ch2);
    ShowArray.Add([ET1255_DAC_MD[0],ET1255_DAC_MD[1],ET1255_DAC_MD[2]]);
   end;

  SetLength(DevicesSet,High(DevicesSet)+2);
  DevicesSet[High(DevicesSet)]:=D30_06;

  SettingDevice:=TSettingDevice.Create(DevicesSet,CBVS,'Input voltage');
  SettingDeviceControl:=TSettingDevice.Create(DevicesSet,CBControlCD,'Control input');
  SettingTermostat:=TSettingDevice.Create(DevicesSet,CBTermostatCD,'Termostat input');
  SettingDeviceLED:=TSettingDevice.Create(DevicesSet,CBLED_onCD,'LED output');
  ShowArray.Add([SettingDevice,SettingDeviceControl,SettingTermostat,SettingDeviceLED]);
 end;

function TIVchar.DiapazonIMeasurement(Measurement:IMeasurement):ShortInt;
begin
 Result:=0;
 if Measurement.Name= 'B7-21A' then Result:=V721A.Diapazon;
 if Measurement.Name= 'B7-21 (1)' then Result:=V721_I.Diapazon;
 if Measurement.Name= 'B7-21 (2)' then Result:=V721_II.Diapazon;
 if Measurement.Name= 'UT70B' then Result:=UT70B.Diapazon;
 if Measurement.Name= 'UT70C' then Result:=UT70C.Diapazon;
end;

procedure TIVchar.CorrectionLimit(var NewCorrection: Double);
begin
  if (abs(NewCorrection) > 0.3) and (TIVDependence.VoltageInput < 0.3) then
    NewCorrection := 0.1 * NewCorrection / NewCorrection;
  if (abs(NewCorrection) > 3)
    then NewCorrection := 0.1 * NewCorrection / NewCorrection;

  if ItIsDarkIV then  NewCorrection:=Max(NewCorrection,-0.2)
end;

procedure TIVchar.IVOldFactorDetermination(var Factor: Double);
begin
  if IVMeasResult.isLarge
  then Factor := 1
  else Factor := 2;

  if IVMeasResult.isLargeToApplied
  then if IVMeasResult.isLarge
       then Factor := 1.2
       else Factor := 0.8;
end;

procedure TIVchar.IVVoltageInputSignDetermine;
begin
  if TIVDependence.ItIsForward then
    VoltageInputSign := TIVDependence.VoltageInput
  else
    VoltageInputSign := -TIVDependence.VoltageInput;
end;

procedure TIVchar.IVMR_Refresh;
begin
  if ((IVMeasResult.CurrentDiapazon = IVMRFirst.CurrentDiapazon)) and (abs(IVMeasResult.DeltaToExpected) < abs(IVMRFirst.DeltaToExpected)) then
    IVMeasResult.CopyTo(IVMRFirst);
  if ((IVMeasResult.CurrentDiapazon <> IVMRFirst.CurrentDiapazon)) and (abs(IVMeasResult.DeltaToExpected) < abs(IVMRSecond.DeltaToExpected)) then
    IVMeasResult.CopyTo(IVMRSecond);
end;

procedure TIVchar.MCP3424Create;
 var i:TMCP3424_ChanelNumber;
begin
  MCP3424 := TMCP3424_Module.Create(ComPort1, 'MCP3424');
  MCP3424show := TI2C_PinsShow.Create(MCP3424.Pins, PMCP3424Pin, MCP3424_StartAdress, MCP3424_LastAdress);
  for I := Low(TMCP3424_ChanelNumber) to High(TMCP3424_ChanelNumber) do
    MCP3424_Channel[i] := TMCP3424_Channel.Create(i, MCP3424);

  MCP3424_ChannelShow[0]:=
     TMCP3424_ChannelShow.Create(MCP3424_Channel[0], PMCP3424_Ch1bits, PMCP3424_Ch1gain, LMCP3424_Ch1meas, {BtMCP3424_Ch1bits, BtMCP3424_Ch1gain,} BMCP3424_Ch1meas{, CBMCP3424_Ch1bits, CBMCP3424_Ch1gain});
  MCP3424_ChannelShow[1]:=
     TMCP3424_ChannelShow.Create(MCP3424_Channel[1], PMCP3424_Ch2bits, PMCP3424_Ch2gain, LMCP3424_Ch2meas, {BtMCP3424_Ch2bits, BtMCP3424_Ch2gain,} BMCP3424_Ch2meas{, CBMCP3424_Ch2bits, CBMCP3424_Ch2gain});
  MCP3424_ChannelShow[2]:=
     TMCP3424_ChannelShow.Create(MCP3424_Channel[2], PMCP3424_Ch3bits, PMCP3424_Ch3gain, LMCP3424_Ch3meas, {BtMCP3424_Ch3bits, BtMCP3424_Ch3gain,} BMCP3424_Ch3meas{, CBMCP3424_Ch3bits, CBMCP3424_Ch3gain});
  MCP3424_ChannelShow[3]:=
     TMCP3424_ChannelShow.Create(MCP3424_Channel[3], PMCP3424_Ch4bits, PMCP3424_Ch4gain, LMCP3424_Ch4meas, {BtMCP3424_Ch4bits, BtMCP3424_Ch4gain,} BMCP3424_Ch4meas{, CBMCP3424_Ch4bits, CBMCP3424_Ch4gain});

  ShowArray.Add([MCP3424show,
                 MCP3424_ChannelShow[0],MCP3424_ChannelShow[1],MCP3424_ChannelShow[2],MCP3424_ChannelShow[3]]);
  AnyObjectArray.Add([MCP3424,MCP3424_Channel[0],MCP3424_Channel[1],
                      MCP3424_Channel[2],MCP3424_Channel[3]]);

end;

function TIVchar.IVNewFactorDetermination: double;
begin
 Result:=1;
 if IVMeasResult.Correction>0
   then if IVMeasResult.isLarge
          then Result:=0.3
          else Result:=2;

 if IVMeasResult.Correction<0
   then if IVMeasResult.isLarge
          then Result:=2
          else Result:=0.3;
end;

procedure TIVchar.PinsWriteToIniFile;
var
  i: Integer;
begin
  ConfigFile.EraseSection('PinNumbers');
  ConfigFile.WriteInteger('PinNumbers', 'PinCount', NumberPins.Count);
  for I := 0 to NumberPins.Count - 1 do
    ConfigFile.WriteString('PinNumbers', 'Pin' + IntToStr(i), NumberPins[i]);

  ConfigFile.EraseSection('PinNumbersOneWire');
  ConfigFile.WriteInteger('PinNumbersOneWire', 'PinCount', NumberPinsOneWire.Count);
  for I := 0 to NumberPinsOneWire.Count - 1 do
    ConfigFile.WriteString('PinNumbersOneWire', 'Pin' + IntToStr(i), NumberPinsOneWire[i]);

  ConfigFile.EraseSection('NumberPinsInterrupt');
  ConfigFile.WriteInteger('NumberPinsInterrupt', 'PinCount', NumberPinsInterrupt.Count);
  for I := 0 to NumberPinsInterrupt.Count - 1 do
    ConfigFile.WriteString('NumberPinsInterrupt', 'Pin' + IntToStr(i), NumberPinsInterrupt[i]);
end;

procedure TIVchar.PinsFromIniFile;
var
  i: Integer;
begin
  for I := 0 to ConfigFile.ReadInteger('PinNumbers', 'PinCount', 3) - 1 do
    NumberPins.Add(ConfigFile.ReadString('PinNumbers', 'Pin' + IntToStr(i), IntToStr(UndefinedPin)));
  for I := 0 to ConfigFile.ReadInteger('PinNumbersOneWire', 'PinCount', 1) - 1 do
    NumberPinsOneWire.Add(ConfigFile.ReadString('PinNumbersOneWire', 'Pin' + IntToStr(i), IntToStr(UndefinedPin)));
  for I := 0 to ConfigFile.ReadInteger('NumberPinsInterrupt', 'PinCount', 3) - 1 do
    NumberPinsInterrupt.Add(ConfigFile.ReadString('NumberPinsInterrupt', 'Pin' + IntToStr(i), IntToStr(UndefinedPin)));
end;

procedure TIVchar.ComponentView;
 var i:integer;
begin
  PanelV721_I.Height := round(0.48*PanelV721_I.Parent.Height);
  PanelV721_II.Height := round(0.48*PanelV721_II.Parent.Height);
  ChLine.Top:=0;
  ChLine.Left:=0;
  ChLine.Height := round(ChLine.Parent.Height / 2);
  ChLine.Width:= round(0.7*ChLine.Parent.Width);
  ChLg.Top:=round(ChLg.Parent.Height / 2);
  ChLg.Left:=0;
  ChLg.Height := round(ChLg.Parent.Height / 2);
  ChLg.Width:= round(0.7*ChLg.Parent.Width);
  MeasurementsLabelCaptionDefault;
  LTRValue.Caption:=Undefined;
  LTermostatCTValue.Caption:=Undefined;
  LTLastValue.Caption:=Undefined;

  PC.OnChanging:=nil;
  ChLg.LeftAxis.Logarithmic:=True;

  try
  for i := IVchar.ComponentCount - 1 downto 0 do
   begin
     if IVchar.Components[i].Tag = 1 then
      (IVchar.Components[i] as TComboBox).Sorted:=False;
     if IVchar.Components[i].Tag = 3 then
      begin
      (IVchar.Components[i] as TStringGrid).Cells[0,0]:='Limit';
      (IVchar.Components[i] as TStringGrid).Cells[1,0]:='Step';
      (IVchar.Components[i] as TStringGrid).ColWidths[0]:=(IVchar.Components[i] as TStringGrid).Canvas.TextWidth('Limit')+15;
      (IVchar.Components[i] as TStringGrid).ColWidths[1]:=(IVchar.Components[i] as TStringGrid).Canvas.TextWidth('0.005')+15;
      end;
     if IVchar.Components[i].Tag = 4 then
      (IVchar.Components[i] as TButton).Enabled:=False;
   end;
  finally
  end;

  CBMeasurements.Items.Clear;
  CBMeasurements.Items.Add(MeasIV);
  CBMeasurements.Items.Add(MeasR2RCalib);
  CBMeasurements.Items.Add(MeasTimeD);
  CBMeasurements.Items.Add(MeasControlParametr);
  CBMeasurements.Items.Add(MeasTempOnTime);
  CBMeasurements.Items.Add(MeasTwoTimeD);
  CBMeasurements.Items.Add(MeasIscAndVocOnTime);
  CBMeasurements.ItemIndex:=0;

  IsWorkingTermostat:=False;
  IsPID_Termostat_Created:=False;

end;

end.
