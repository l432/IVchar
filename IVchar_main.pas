unit IVchar_main;

interface

uses
  Windows, Messages, SysUtils, Graphics, Forms,SPIdevice, IniFiles,PacketParameters,
  OlegType, OlegMath,Measurement,
  TempThread, ShowTypes,OlegGraph, Dependence, V7_21,
  TemperatureSensor, DACR2R, UT70, RS232device,ET1255, RS232_Mediator_Tread,
  CPortCtl, Grids, Chart, TeeProcs, Series, TeEngine, ExtCtrls, Buttons,
  ComCtrls, CPort, StdCtrls, Dialogs, Controls, Classes, D30_06;

const
  MeasIV='IV characteristic';
  MeasR2RCalib='R2R-DAC Calibration';
  MeasTimeD='Time dependence';
  MeasControlParametr='Controller on time';
  MeasTempOnTime='Temperature on time';

  MD_IniSection='Sources';


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
    CBV721A: TComboBox;
    LV721APin: TLabel;
    BV721ASet: TButton;
    PanelV721_II: TPanel;
    RGV721II_MM: TRadioGroup;
    CBV721I: TComboBox;
    CBV721II: TComboBox;
    LV721IPin: TLabel;
    LV721IIPin: TLabel;
    BV721IISet: TButton;
    BV721ISet: TButton;
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
    LV721IPinG: TLabel;
    LV721APinG: TLabel;
    BV721ASetGate: TButton;
    BV721ISetGate: TButton;
    LV721IIPinG: TLabel;
    BV721IISetGate: TButton;
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
    CBDACR2R: TComboBox;
    LDACR2RPinC: TLabel;
    BDACR2RSetC: TButton;
    LDACR2RPinG: TLabel;
    BDACR2RSetG: TButton;
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
    LDS18BPin: TLabel;
    GBDS18B: TGroupBox;
    BDS18B: TButton;
    CBDS18b20: TComboBox;
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
    STUT70Rort: TStaticText;
    ComCBUT70Port: TComComboBox;
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
    LPIDParam: TLabel;
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
    LTermostatPID: TLabel;
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
    CBD30: TComboBox;
    LD30PinC: TLabel;
    BD30SetC: TButton;
    LD30PinG: TLabel;
    BD30SetG: TButton;
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
    procedure Button1Click(Sender: TObject);
    procedure DependTimerTimer(Sender: TObject);
    procedure SBControlBeginClick(Sender: TObject);
    procedure BControlResetClick(Sender: TObject);
    procedure SBTermostatClick(Sender: TObject);
    procedure BTermostatResetClick(Sender: TObject);
  private
    procedure ComponentView;
    {��������� ������������ ����� ����������}
    procedure PinsFromIniFile;
    {���������� ������ ����, �� ���������������� �������}
    procedure PinsWriteToIniFile;
    Procedure NumberPinsShow();
    {������������ ���� NumberPins � ��
    ComboBox � Tag=1}
    procedure RangeShow(Sender: TObject);
    procedure RangeShowLimit();
    procedure RangeReadFromIniFile;
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
    procedure VoltmetrsReadFromIniFileAndToForm;
    procedure VoltmetrsWriteToIniFile;
    procedure VoltmetrsFree;
    procedure DACCreate;
    procedure DACFree;
    procedure DACReadFromIniFileAndToForm;
    procedure DACWriteToIniFile;
    procedure DevicesCreate;
    procedure DevicesFree;
    procedure DevicesReadFromIniAndToForm;
    procedure DevicesWriteToIniFile;
    procedure TemperatureThreadCreate;
    procedure ControllerThreadCreate;
    function StepDetermine(Voltage: Double; ItForward: Boolean):double;
    procedure BoxFromIniFile;
    procedure BoxToIniFile;
    procedure VectorsCreate;
    procedure VectorsDispose;
    { Private declarations }
    procedure RangeWriteToIniFile;
    procedure ConstantShowCreate;
    procedure ConstantShowFromIniFile;
    procedure ConstantShowToIniFile;
    procedure SaveCommentsFile(FileName: string);
    procedure DependenceMeasuringCreate;
    procedure DependenceMeasuringFree;
    procedure RangesFree;
    procedure IVCharHookCycle();
    procedure CalibrHookCycle();
    procedure IVCharHookStep();
    procedure CalibrationHookStep;
    procedure IVcharHookBegin;
    procedure IVcharHookEnd;
    procedure CalibrHookEnd;
    procedure HookBegin;
    procedure TimeDHookBegin;
    procedure ControlTimeHookBegin;
    procedure TemperatureOnTimeHookBegin;
    procedure TimeDHookEnd;
    procedure TimeDHookFirstMeas;
    procedure ControlTimeFirstMeas;
    procedure TemperatureOnTimeFirstMeas;
    procedure TimeDHookSecondMeas;
    procedure IVCharHookSetVoltage;
    procedure IVCharHookAction;
    procedure CalibrHookSetVoltage;
    procedure IVCharCurrentMeasHook;
    function IVCharCurrentMeasuring(var Current:double):boolean;
    procedure CalibrHookSecondMeas();
    procedure IVCharVoltageMeasHook;
    function  IVCharVoltageMaxDif:double;
    procedure CalibrHookFirstMeas;
    procedure IVCharHookDataSave;
    procedure CalibrHookDataSave;
    procedure HookEnd;
    procedure IVCharSaveClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure CalibrSaveClick(Sender: TObject);
    procedure ParametersFileWork(Action: TSimpleEvent);
    procedure ET1255Create;
    procedure ET1255Free;
    procedure WMMyMeasure (var Mes : TMessage); message WM_MyMeasure;
    procedure HookEndReset;
  public
    V721A:TV721A;
    V721_I,V721_II:TV721;
//    V721_I:TV721;
//    V721_II:TV721_Brak;
    VoltmetrShows:array of TVoltmetrShow;
    DS18B20:TDS18B20;
    DS18B20show:TPinsShow;
    ThermoCuple:TThermoCuple;
    ConfigFile:TIniFile;
    NumberPins:TStringList; // ������ ����, �� ���������������� �� ������� ��� SPI
    NumberPinsOneWire:TStringList; // ������ ����, �� ���������������� ��� OneWire
    ForwSteps,RevSteps,IVResult,VolCorrection,
    VolCorrectionNew,TemperData:PVector;
    DACR2R:TDACR2R;
    DACR2RShow:TDACR2RShow;
    D30_06:TD30_06;
    D30_06Show:TD30_06Show;
    Simulator:TSimulator;
    UT70B:TUT70B;
    UT70BShow:TUT70BShow;
    ET1255_DACs:array[TET1255_DAC_ChanelNumber] of TET1255_DAC;
    ET1255_DACsShow:array[TET1255_DAC_ChanelNumber] of TDAC_Show;
    Devices:array of IMeasurement;
    DevicesSet:array of IDAC;
    Temperature_MD:TTemperature_MD;
    Current_MD,VoltageIV_MD,DACR2R_MD,D30_MD,
    TermoCouple_MD,TimeD_MD,Control_MD:TMeasuringDevice;
    ET1255_DAC_MD:array[TET1255_DAC_ChanelNumber] of TMeasuringDevice;
    SettingDevice,SettingDeviceControl,SettingTermostat:TSettingDevice;
    RS232_MediatorTread:TRS232_MediatorTread;
    TemperatureMeasuringThread:TTemperatureMeasuringThread;
    ControllerThread:TControllerThread;
    IVCharRangeFor,CalibrRangeFor:TLimitShow;
    IVCharRangeRev,CalibrRangeRev:TLimitShowRev;
    NumberOfTemperatureMeasuring,IterationNumber: Integer;
    ItIsBegining,IsWorkingTermostat:boolean;
    Temperature
    ,VoltageInputCorrection,VoltageMeasured
    ,VoltageInputCorrectionN,VoltageMeasuredN:double;
    DoubleConstantShows:array of TParameterShow1;
    Imax,Imin,R_VtoI,Shift_VtoI:double;
    IVMeasuring,CalibrMeasuring:TIVDependence;
    TimeDependence:TTimeDependenceTimer;
    ControlParameterTime,TemperatureOnTime:TTimeDependence;
    PID_Termostat:TPID;
    IsPID_Termostat_Created:boolean;
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

procedure TIVchar.RangeWriteToIniFile;
 var Section:string;
begin
    Section:='Range';
    ConfigFile.EraseSection(Section);
    IVCharRangeFor.WriteToIniFile(ConfigFile,Section,'IV_Forv');
    IVCharRangeRev.WriteToIniFile(ConfigFile,Section,'IV_Rev');
    CalibrRangeFor.WriteToIniFile(ConfigFile,Section,'Calibr_Forv');
    CalibrRangeRev.WriteToIniFile(ConfigFile,Section,'Calibr_Rev');
end;

procedure TIVchar.ConstantShowCreate;
begin

  SetLength(DoubleConstantShows, 19);
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

  DoubleConstantShows[10]:=TParameterShow1.Create(STControlNV,LControlNV,
        'Needed Value',
        'Needed Value',0);
  DoubleConstantShows[11]:=TParameterShow1.Create(STControlInterval,LControlInterval,
        'Controling interval (s)',
        'Controling measurement interval',15,2);
  DoubleConstantShows[12]:=TParameterShow1.Create(STControlKp,LControlKp,
        'Kp',
        'Proportional term of controller',1);
  DoubleConstantShows[13]:=TParameterShow1.Create(STControlKi,LControlKi,
        'Ki',
        'Integral term of controller',0);
  DoubleConstantShows[14]:=TParameterShow1.Create(STControlKd,LControlKd,
        'Kd',
        'Derivative term of controller',0);

  DoubleConstantShows[15]:=TParameterShow1.Create(STTermostatNT,LTermostatNT,
        'Needed Temperature',
        'Needed Temperature',300);
  DoubleConstantShows[16]:=TParameterShow1.Create(STTermostatKp,LTermostatKp,
        'Proportional',
        'Proportional term of termostat',0.1);
  DoubleConstantShows[17]:=TParameterShow1.Create(STTermostatKi,LTermostatKi,
        'Integral',
        'Integral term of termostat',0);
  DoubleConstantShows[18]:=TParameterShow1.Create(STTermostatKd,LTermostatKd,
        'Derivative',
        'Derivative term of termostat',0);

end;

procedure TIVchar.ConstantShowFromIniFile;
 var i:integer;
begin
  for I := Low(DoubleConstantShows) to High(DoubleConstantShows) do
   DoubleConstantShows[i].ReadFromIniFile(ConfigFile);
end;

procedure TIVchar.ConstantShowToIniFile;
 var i:integer;
begin
  ConfigFile.EraseSection(DoubleConstantSection);
  for I := Low(DoubleConstantShows) to High(DoubleConstantShows) do
   DoubleConstantShows[i].WriteToIniFile(ConfigFile);
end;

procedure TIVchar.ControllerThreadCreate;
begin
  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;

  ControllerThread:=
    TControllerThread.Create(Control_MD.ActiveInterface,
                             SettingDeviceControl.ActiveInterface,
                             DoubleConstantShows[11].Data,
                             DoubleConstantShows[12].Data,
                             DoubleConstantShows[13].Data,
                             DoubleConstantShows[14].Data,
                             DoubleConstantShows[10].Data);

end;

procedure TIVchar.ControlTimeFirstMeas;
begin
 TDependence.tempIChange(Control_MD.ActiveInterface.Value);
 LADVoltageValue.Caption:=FloatToStrF(TDependence.tempI,ffFixed, 4, 3);
end;

procedure TIVchar.ControlTimeHookBegin;
begin
  HookBegin();

  LADInputVoltage.Visible:=False;
  LADInputVoltageValue.Visible:=False;
  LADRange.Visible:=False;
  LADVoltage.Caption:='Meauring:';
  LADCurrent.Caption:='Time:';
end;

procedure TIVchar.SaveClick(Sender: TObject);
 var last:string;
begin
  last:=LastDATFileName();
  if last<>NoFile  then
  begin
    try
      SaveDialog.FileName:=IntToStr(StrToInt(last)+1)+'.dat';
    except
      SaveDialog.FileName:=last+'1.dat';;
    end;
  end              else
  SaveDialog.FileName:='1.dat';
  SaveDialog.Title:='Last file - '+last+'.dat';
  SaveDialog.InitialDir:=GetCurrentDir;
  if SaveDialog.Execute then
   begin
     IVResult.Sorting;
     IVResult.DeleteDuplicate;
     Write_File(SaveDialog.FileName,IVResult);

     LTLastValue.Caption:=FloatToStrF(Temperature,ffFixed, 5, 2);

     BIVSave.Font.Style:=BIVSave.Font.Style+[fsStrikeOut];
     SaveCommentsFile(SaveDialog.FileName);
   end;
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

procedure TIVchar.DependenceMeasuringCreate;
begin
  IVMeasuring := TIVDependence.Create(CBForw,CBRev,PBIV,BIVStop,
                         IVResult,ForwLine,RevLine,ForwLg,RevLg);
  CalibrMeasuring:= TIVDependence.Create(CBForw,CBRev,PBIV,BIVStop,
                         IVResult,ForwLine,RevLine,ForwLg,RevLg);

  TimeDependence:=TTimeDependenceTimer.Create(PBIV,BIVStop,IVResult,
                                       ForwLine,ForwLg,DependTimer);

  ControlParameterTime:=TTimeDependence.Create(PBIV,BIVStop,IVResult,
                                       ForwLine,ForwLg);
  TemperatureOnTime:=TTimeDependence.Create(PBIV,BIVStop,IVResult,
                                       ForwLine,ForwLg);

  IVMeasuring.RangeFor:=IVCharRangeFor;
  IVMeasuring.RangeRev:=IVCharRangeRev;
  CalibrMeasuring.RangeFor:=CalibrRangeFor;
  CalibrMeasuring.RangeRev:=CalibrRangeRev;

  IVMeasuring.HookCycle:=IVCharHookCycle;
  CalibrMeasuring.HookCycle:=CalibrHookCycle;

  IVMeasuring.HookStep:=IVCharHookStep;
  CalibrMeasuring.HookStep:=CalibrationHookStep;

  IVMeasuring.HookAction:=IVCharHookAction;

  IVMeasuring.HookBeginMeasuring:=IVcharHookBegin;
  CalibrMeasuring.HookBeginMeasuring:=HookBegin;
  TimeDependence.HookBeginMeasuring:=TimeDHookBegin;
  ControlParameterTime.HookBeginMeasuring:=ControlTimeHookBegin;
  TemperatureOnTime.HookBeginMeasuring:=TemperatureOnTimeHookBegin;

  IVMeasuring.HookSetVoltage:=IVCharHookSetVoltage;
  CalibrMeasuring.HookSetVoltage:=CalibrHookSetVoltage;

  IVMeasuring.HookSecondMeas:=IVCharCurrentMeasHook;
  CalibrMeasuring.HookSecondMeas:=CalibrHookSecondMeas;
  TimeDependence.HookSecondMeas:=TimeDHookSecondMeas;
  ControlParameterTime.HookSecondMeas:=TimeDHookSecondMeas;
  TemperatureOnTime.HookSecondMeas:=TimeDHookSecondMeas;

  IVMeasuring.HookFirstMeas:=IVCharVoltageMeasHook;
  CalibrMeasuring.HookFirstMeas:=CalibrHookFirstMeas;
  TimeDependence.HookFirstMeas:=TimeDHookFirstMeas;
  ControlParameterTime.HookFirstMeas:=ControlTimeFirstMeas;
  TemperatureOnTime.HookFirstMeas:=TemperatureOnTimeFirstMeas;

  IVMeasuring.HookDataSave:=IVCharHookDataSave;
  CalibrMeasuring.HookDataSave:=CalibrHookDataSave;

  IVMeasuring.HookEndMeasuring:=IVcharHookEnd;
  CalibrMeasuring.HookEndMeasuring:=CalibrHookEnd;
  TimeDependence.HookEndMeasuring:=TimeDHookEnd;
  ControlParameterTime.HookEndMeasuring:=TimeDHookEnd;
  TemperatureOnTime.HookEndMeasuring:=TimeDHookEnd;
end;

procedure TIVchar.DependenceMeasuringFree;
begin
  IVMeasuring.Free;
  CalibrMeasuring.Free;
  TimeDependence.Free;
  ControlParameterTime.Free;
  TemperatureOnTime.Free;
end;

procedure TIVchar.RangesFree;
begin
  IVCharRangeFor.Free;
  IVCharRangeRev.Free;
  CalibrRangeFor.Free;
  CalibrRangeRev.Free;
end;

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

procedure TIVchar.IVCharSaveClick(Sender: TObject);
begin
  VolCorrectionNew.Sorting;
  VolCorrectionNew.DeleteDuplicate;
  VolCorrectionNew^.Copy(VolCorrection^);

  SaveClick(Sender);
end;

procedure TIVchar.CalibrationHookStep;
begin
//  TIVDependence.VoltageStepChange(SettingDevice.CalibrationStep(TIVDependence.VoltageInput));
  TIVDependence.VoltageStepChange(DACR2R.CalibrationStep(TIVDependence.VoltageInput));
end;

procedure TIVchar.IVcharHookBegin;
begin
  HookBegin();
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

end;

procedure TIVchar.HookBegin;
begin
   DecimalSeparator:='.';
  CBMeasurements.Enabled:=False;
  BIVStart.Enabled := False;
  BConnect.Enabled := False;
  BIVSave.Enabled:=False;
  BParamReceive.Enabled := False;
  SBTAuto.Enabled := False;
//  PC.OnChanging := PCChanging;

end;

procedure TIVchar.IVCharHookSetVoltage;
begin
  if TIVDependence.ItIsForward then
    LADInputVoltageValue.Caption:=FloatToStrF(TIVDependence.VoltageInput,ffFixed, 4, 3)+
    ' '+FloatToStrF(TIVDependence.VoltageInputReal,ffFixed, 4, 3)
                                       else
    LADInputVoltageValue.Caption:=FloatToStrF(-TIVDependence.VoltageInput,ffFixed, 4, 3)+
    ' '+FloatToStrF(TIVDependence.VoltageInputReal,ffFixed, 4, 3);

 if RGDO.ItemIndex=1 then TIVDependence.VoltageInputRealChange(-1*TIVDependence.VoltageInputReal);
 SettingDevice.SetValue(TIVDependence.VoltageInputReal);
end;

procedure TIVchar.IVCharCurrentMeasHook;
 var
  tmI: Double;
  AtempNumber:byte;
begin
  AtempNumber := 0;
  repeat
   if not(IVCharCurrentMeasuring(tmI)) then Exit;

   if (ItIsBegining)or(High(IVResult^.Y)<0)
       then AtempNumber:=AtempNumbermax
       else
     begin
     if (TIVDependence.ItIsForward and (tmI>IVResult^.Y[High(IVResult^.Y)])) then AtempNumber:=AtempNumbermax;
     if (not(TIVDependence.ItIsForward) and (tmI<IVResult^.Y[High(IVResult^.Y)])) then AtempNumber:=AtempNumbermax;
     end;
   inc(AtempNumber);
  until (AtempNumber>AtempNumbermax);

  if (CBCurrentValue.Checked and (abs(tmI)>=Imax)) then
   TIVDependence.VoltageInputChange(Vmax);
  TIVDependence.tempIChange(tmI);
end;

function TIVchar.IVCharCurrentMeasuring(var Current: double): boolean;
begin
 Result:=False;
 Application.ProcessMessages;
 if TIVDependence.IVMeasuringToStop then Exit;
 Current := Current_MD.GetMeasurementResult();
// ****************************
 if CBVtoI.Checked then
  begin
   Current:=(current-Shift_VtoI)/R_VtoI;
   LADCurrentValue.Caption:=FloatToStrF(Current,ffExponent, 4, 2);
  end;

//*********************************
 if Current=ErResult then
  begin
   TIVDependence.tempIChange(Current);
   Exit;
  end;
 if RGDO.ItemIndex=1 then
      begin
         Current:=-Current;
         LADCurrentValue.Caption:=FloatToStrF(Current,ffExponent, 4, 2);
      end;
 Result:=True;
end;

procedure TIVchar.IVCharHookAction;
 var Cor:double;
begin
 VoltageInputCorrection:=ErResult;
 VoltageMeasured:=ErResult;
 VoltageInputCorrectionN:=ErResult;
 VoltageMeasuredN:=ErResult;

 if CBPC.Checked then
 begin
   if TIVDependence.ItIsForward then
    Cor:=VolCorrection.Yvalue(TIVDependence.VoltageInput)
                                       else
    Cor:=VolCorrection.Yvalue(-TIVDependence.VoltageInput);
   if Cor<>ErResult then
     TIVDependence.VoltageCorrectionChange(Cor)
 end;
 IterationNumber:=0;
end;

procedure TIVchar.CalibrHookSecondMeas();
begin
  Application.ProcessMessages;
  if TIVDependence.IVMeasuringToStop then Exit;
  TIVDependence.tempIChange(DACR2R_MD.GetMeasurementResult());
  LADCurrentValue.Caption:=FloatToStrF(TIVDependence.tempI,ffFixed, 6, 4);
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
     for I := Low(TET1255_DAC_ChanelNumber) to High(TET1255_DAC_ChanelNumber) do
        ET1255_DACs[i]:=TET1255_DAC.Create(i);

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

  if ET_StartDrv <> '' then
    showmessage('ET1255 loading error' + ''#10''#13'' + ET_ErrMsg)
                       else
  for I := Low(TET1255_DAC_ChanelNumber) to High(TET1255_DAC_ChanelNumber) do
        ET1255_DACs[i].Reset();
end;

procedure TIVchar.ET1255Free;
 var I:TET1255_DAC_ChanelNumber;
begin
     for I := Low(TET1255_DAC_ChanelNumber) to High(TET1255_DAC_ChanelNumber) do
        if ET1255_DACs[i]<>nil then
           begin
            ET1255_DACsShow[i].Free;
            ET1255_DACs[i].Reset();
            ET1255_DACs[i].Free();
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
end;

procedure TIVchar.IVCharVoltageMeasHook;
  var
    tmV,MaxDif,NewCorrection,Factor{,V}:double;
  ItIsLarge,CorrectionIsNeeded: Boolean;
 label bbegin;

  function y3(x1,x2,x3,y1,y2:double):double;
  begin
    Result:=x3*(y1-y2)/(x1-x2)+(y2*x1-y1*x2)/(x1-x2);
  end;

begin
  MaxDif:=IVCharVoltageMaxDif();

bbegin:
  Application.ProcessMessages;
  if TIVDependence.IVMeasuringToStop then Exit;
  tmV := VoltageIV_MD.GetMeasurementResult();
  if tmV=ErResult then
    begin
     TIVDependence.tempVChange(tmV);
     Exit;
    end;

  if RGDO.ItemIndex=1 then
     begin
     tmV:=-tmV;
     LADVoltageValue.Caption:=FloatToStrF(tmV,ffFixed, 4, 3);
     end;


  if TIVDependence.ItIsForward then
   CorrectionIsNeeded:=(abs(tmV-TIVDependence.VoltageInput)>=MaxDif)
                                       else
  CorrectionIsNeeded:=(abs(abs(tmV)-TIVDependence.VoltageInput)>=MaxDif);

  if CorrectionIsNeeded then
   begin
    TIVDependence.SecondMeasIsDoneChange(False);

    if (not(TIVDependence.ItIsForward))and(TIVDependence.VoltageInput<>0) then
                  tmV:=abs(tmV);
    ItIsLarge:=(tmV>TIVDependence.VoltageInput);

    if (ItIsLarge)and(abs(-VoltageMeasuredN+tmV)<0.25*MaxDif) then
     begin
      Randomize;
      NewCorrection:=0.15*Random;
      VoltageMeasured:=ErResult;
      VoltageInputCorrection:=ErResult;
      TIVDependence.VoltageCorrectionChange(NewCorrection);
      Exit;
     end;

    if (not(ItIsLarge))and(abs(VoltageMeasured-tmV)<0.25*MaxDif) then
     begin
      Randomize;
      NewCorrection:=0.15*Random;
      VoltageMeasuredN:=ErResult;
      VoltageInputCorrectionN:=ErResult;
      TIVDependence.VoltageCorrectionChange(NewCorrection);
      Exit;
     end;

   if ItIsLarge then Factor:=1
                else Factor:=2.5;
   if tmV>(TIVDependence.VoltageInput+TIVDependence.VoltageCorrection)
     then
   if ItIsLarge then Factor:=1.2
                else Factor:=0.8;
   inc(IterationNumber);
   if (IterationNumber mod 7)=0 then
   begin
    Randomize;
    Factor:=Factor*Random;
   end;

   NewCorrection:=TIVDependence.VoltageCorrection+
                     Factor*(TIVDependence.VoltageInput-tmV);

    if abs(NewCorrection)>0.3 then NewCorrection:=0.1*NewCorrection/NewCorrection;

    TIVDependence.VoltageCorrectionChange(NewCorrection);
    Exit;
   end;
  TIVDependence.tempVChange(tmV);
end;

procedure TIVchar.CalibrHookCycle;
begin
  TIVDependence.DelayTimeChange(800);
end;

procedure TIVchar.CalibrHookDataSave;
 var tempdir:string;
     tempVec:PVector;
begin
  if TIVDependence.PointNumber=0 then Exit;
  if (TIVDependence.PointNumber mod 1000)<>0 then Exit;
    new(tempVec);
    IVResult^.Copy(tempVec^);
    tempdir:=GetCurrentDir;
    ChDir(ExtractFilePath(Application.ExeName));
    DACR2R.SaveFileWithCalibrData(tempVec);
    ChDir(tempdir);
    dispose(tempVec);
end;

procedure TIVchar.CalibrHookEnd;
begin
 HookEndReset();
 HookEnd();
 BIVSave.OnClick:=CalibrSaveClick;
end;

procedure TIVchar.CalibrHookFirstMeas;
begin
  Application.ProcessMessages;;
  if TIVDependence.IVMeasuringToStop then Exit;
  TIVDependence.tempVChange(VoltageIV_MD.GetMeasurementResult());
  LADVoltageValue.Caption:=FloatToStrF(TIVDependence.tempV,ffFixed, 6, 4);
end;

procedure TIVchar.IVCharHookDataSave;
begin
  if abs(TIVDependence.tempI)<=abs(Imin)
     then TIVDependence.tempIChange(ErResult);


  if (not(SBTAuto.Down))and
     (NumberOfTemperatureMeasuring=TIVDependence.PointNumber)
    then
    begin
      Temperature:=Temperature_MD.GetMeasurementResult();
      TemperData.Add(TIVDependence.PointNumber,Temperature);
    end;

  if (SBTAuto.Down)and
     (Temperature_MD.ActiveInterface.NewData) then
      begin
       TemperData.Add(TIVDependence.PointNumber,
                     Temperature_MD.ActiveInterface.Value);
       Temperature_MD.ActiveInterface.NewData:=False;
      end;


  if ItIsBegining then ItIsBegining:=not(ItIsBegining);
  if TIVDependence.ItIsForward then
     VolCorrectionNew.Add(TIVDependence.VoltageInput,TIVDependence.VoltageCorrection)
                                      else
     VolCorrectionNew.Add(-TIVDependence.VoltageInput,TIVDependence.VoltageCorrection);
end;

procedure TIVchar.IVcharHookEnd;
begin
 HookEndReset;
 HookEnd();

  if (not(SBTAuto.Down)) then
    begin
      Temperature:=Temperature_MD.GetMeasurementResult();
      TemperData.Add(TIVDependence.PointNumber,Temperature);
    end;

  TemperData.DeleteErResult;
  if TemperData.n>0 then
     Temperature:=TemperData.SumY/TemperData.n;

 BIVSave.OnClick:=IVCharSaveClick;
end;

procedure TIVchar.HookEnd;
begin
  DecimalSeparator:='.';

  CBMeasurements.Enabled:=True;
  BIVStart.Enabled := True;
  BConnect.Enabled := True;
  BParamReceive.Enabled := True;
  SBTAuto.Enabled := True;
//  PC.OnChanging := nil;
  if High(IVResult^.X) > 0 then
  begin
    BIVSave.Enabled := True;
    BIVSave.Font.Style := BIVSave.Font.Style - [fsStrikeOut];
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
 PortStateToLabel(ComPort1,LConnected,BConnect);
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
     if assigned(PID_Termostat) then PID_Termostat.Free;
     IsPID_Termostat_Created:=False;
    end;
end;

procedure TIVchar.Button1Click(Sender: TObject);
begin
 ET_WriteDAC(0,2);
 showmessage(ET_ErrMsg);

end;

procedure TIVchar.BControlResetClick(Sender: TObject);
begin
 if SBControlBegin.Down then
    begin
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

procedure TIVchar.ComDPacketPacket(Sender: TObject; const Str: string);
 var Data:TArrByte;
     i:integer;
begin
 if PacketIsReceived(Str,Data,ParameterReceiveCommand) then
  begin
   NumberPins.Clear;
   for I := 3 to High(Data)-1 do
    NumberPins.Add(IntToStr(Data[i]));
   NumberPinsShow();
  end;

end;

procedure TIVchar.FormCreate(Sender: TObject);
begin
 DecimalSeparator:='.';
 ComponentView();

 ConfigFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'IVChar.ini');


 VoltmetrsCreate();
 ET1255Create();

 NumberPins:=TStringList.Create;
 NumberPinsOneWire:=TStringList.Create;
 VectorsCreate();

 ConstantShowCreate();
 ConstantShowFromIniFile();

 BoxFromIniFile();

 PinsFromIniFile();
 NumberPinsShow();

 VoltmetrsReadFromIniFileAndToForm();

 RangesCreate();
 RangeReadFromIniFile();


 StepsReadFromIniFile();
 ForwStepShow();
 RevStepShow();

 DelayTimeReadFromIniFile();

 DACCreate();
 DACReadFromIniFileAndToForm;

  DevicesCreate();
 DevicesReadFromIniAndToForm();

  DependenceMeasuringCreate();


  ComPortUT70B.LoadSettings(stIniFile, ExtractFilePath(Application.ExeName) + 'IVChar.ini');
  ComCBUT70Port.UpdateSettings;

  try
    ComPortUT70B.Open;
    ComPortUT70B.AbortAllAsync;
    ComPortUT70B.ClearBuffer(True, True);
  finally
   PortStateToLabel(ComPortUT70B,LUT70BPort,nil);
  end;


  ComPort1.LoadSettings(stIniFile, ExtractFilePath(Application.ExeName) + 'IVChar.ini');
  ComCBBR.UpdateSettings;
  ComCBPort.UpdateSettings;
  ComDPacket.StartString := PacketBeginChar;
  ComDPacket.StopString := PacketEndChar;
  ComDPacket.ComPort := ComPort1;
  try
    ComPort1.Open;
    Comport1.AbortAllAsync;
    ComPort1.ClearBuffer(True, True);
  finally
   PortStateToLabel(ComPort1,LConnected,BConnect);
  end;


 RS232_MediatorTread:=TRS232_MediatorTread.Create(
                 [DACR2R,V721A,V721_I,V721_II,DS18B20,D30_06]);

 if (ComPort1.Connected)and(SettingDevice.ActiveInterface.Name=DACR2R.Name) then SettingDevice.Reset();

end;

procedure TIVchar.FormDestroy(Sender: TObject);
begin
 if RS232_MediatorTread <> nil
   then RS232_MediatorTread.Terminate;

 if SBTAuto.Down then TemperatureMeasuringThread.Terminate;
 if SBControlBegin.Down then ControllerThread.Terminate;

 if assigned(DependTimer) then DependTimer.Free;



 DACWriteToIniFile();
 VoltmetrsWriteToIniFile();
 PinsWriteToIniFile;
 SettingWriteToIniFile();
 ConfigFile.Free;



 DependenceMeasuringFree();

 DevicesFree();

 ET1255Free;
 VoltmetrsFree();
 DACFree();

 VectorsDispose();
 RangesFree();
 NumberPins.Free;
 NumberPinsOneWire.Free;


 try
  if ComPort1.Connected then
   begin
    Comport1.AbortAllAsync;
    ComPort1.ClearBuffer(True, True);
    ComPort1.Close;
   end;
 finally
 end;

 try
  if ComPortUT70B.Connected then
   begin
    ComPortUT70B.AbortAllAsync;
    ComPortUT70B.ClearBuffer(True, True);
    ComPortUT70B.Close;
   end;
 finally
 end;


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

Procedure TIVchar.NumberPinsShow();
 var i:integer;
begin
 try
 for i := IVchar.ComponentCount - 1 downto 0 do
   begin
   if IVchar.Components[i].Tag = 1 then
    (IVchar.Components[i] as TComboBox).Items:=NumberPins;
   if IVchar.Components[i].Tag = 11 then
    (IVchar.Components[i] as TComboBox).Items:=NumberPinsOneWire;
   end;
 finally
 end;
end;

procedure TIVchar.RangeShow(Sender: TObject);
 var Start,Finish:string;
    LimitShow:TLimitShow;
    LimitShowRev:TLimitShowRev;
 begin
  if CBMeasurements.Items[CBMeasurements.ItemIndex]
        =MeasR2RCalib then
    begin
      LimitShow:=CalibrRangeFor;
      LimitShowRev:=CalibrRangeRev;
    end               else
    begin
      LimitShow:=IVCharRangeFor;
      LimitShowRev:=IVCharRangeRev;
    end;

  if CBForw.Checked then Finish:=LimitShow.ValueLabelHigh.Caption
                    else Finish:=LimitShowRev.ValueLabelHigh.Caption;
  if CBRev.Checked then Start:=LimitShowRev.ValueLabelLow.Caption
                   else Start:=LimitShow.ValueLabelLow.Caption;

  if (not(CBForw.Checked))and(not(CBRev.Checked))
    then begin
         Finish:='0';
         Start:='0';
         end;
  LADRange.Caption := 'Range is [' + Start + ' .. '+ Finish + '] V';
end;

procedure TIVchar.RangeShowLimit;
begin
 RangeShow(Self);
end;

procedure TIVchar.RangeReadFromIniFile;
 var Section:string;
begin
  Section:='Range';
  IVCharRangeFor.ReadFromIniFile(ConfigFile,Section,'IV_Forv');
  IVCharRangeRev.ReadFromIniFile(ConfigFile,Section,'IV_Rev');
  CalibrRangeFor.ReadFromIniFile(ConfigFile,Section,'Calibr_Forv');
  CalibrRangeRev.ReadFromIniFile(ConfigFile,Section,'Calibr_Rev');
end;

procedure TIVchar.RangesCreate;
begin
  IVCharRangeFor:=TLimitShow.Create(Vmax,2,UDFBHighLimit,UDFBLowLimit,LFBHighlimitValue,LFBLowlimitValue,RangeShowLimit);
  IVCharRangeRev:=TLimitShowRev.Create(Vmax,1,UDRBHighLimit,UDRBLowLimit,LRBHighlimitValue,LRBLowlimitValue,RangeShowLimit);
  CalibrRangeFor:=TLimitShow.Create(Vmax,2,UDFBHighLimitR2R,UDFBLowLimitR2R,LFBHighlimitValueR2R,LFBLowlimitValueR2R,RangeShowLimit);
  CalibrRangeRev:=TLimitShowRev.Create(Vmax,2,UDRBHighLimitR2R,UDRBLowLimitR2R,LRBHighlimitValueR2R,LRBLowlimitValueR2R,RangeShowLimit);
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
  CBMeasurements.OnChange:=RangeShow;
 finally
 end;

  RGDO.ItemIndex:= ConfigFile.ReadInteger('Box', RGDO.Name,0);
  try
   ChDir(ConfigFile.ReadString('Box', 'Directory',ExtractFilePath(Application.ExeName)));
  except
   ChDir(ExtractFilePath(Application.ExeName));
  end;

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
    ControllerThreadCreate();
    SBControlBegin.Caption:='Stop Controling';
    end
                 else
    begin
    ControllerThread.Terminate;
    SBControlBegin.Caption:='Start Controling';
    end;
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
    SBControlBegin.Caption:='Stop Controling';
    if not(SBTAuto.Down) then
        begin
        SBTAuto.Down:=True;
        TemperatureThreadCreate()
        end;
    end
                 else
    begin
    IsWorkingTermostat:=False;
    SBControlBegin.Caption:='Start Controling';
    if assigned(PID_Termostat) then PID_Termostat.Free;
    IsPID_Termostat_Created:=False;
    end;
end;

procedure TIVchar.SettingWriteToIniFile;
begin
  RangeWriteToIniFile;
  StepsWriteToIniFile;
  DelayTimeWriteToIniFile;
  DevicesWriteToIniFile;
  BoxToIniFile;
  ConstantShowToIniFile();
  ComPort1.StoreSettings(stIniFile,ExtractFilePath(Application.ExeName)+'IVChar.ini');
  ComPortUT70B.StoreSettings(stIniFile,ExtractFilePath(Application.ExeName)+'IVChar.ini');
end;

procedure TIVchar.TemperatureOnTimeFirstMeas;
begin
 TDependence.tempIChange(Temperature_MD.ActiveInterface.Value);
 LADVoltageValue.Caption:=FloatToStrF(TDependence.tempI,ffFixed, 5, 2);
end;

procedure TIVchar.TemperatureOnTimeHookBegin;
begin
  ControlTimeHookBegin;
  LADVoltage.Caption:='Temperature:';
end;

procedure TIVchar.TemperatureThreadCreate;
begin
  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
  TemperatureMeasuringThread:=
    TTemperatureMeasuringThread.Create(Temperature_MD.ActiveInterface,
                                       round(StrToFloat(STTMI.Caption)),
                                       EventMeasuringEnd);
end;

procedure TIVchar.TimeDHookBegin;
begin
  ControlTimeHookBegin();

  TimeDependence.Interval:=round(StrToFloat(STTimeInterval.Caption));
  TimeDependence.Duration:=round(StrToFloat(STTimeDuration.Caption));
end;

procedure TIVchar.TimeDHookEnd;
begin
 HookEnd();
 LADInputVoltage.Visible:=True;
 LADInputVoltageValue.Visible:=True;
 LADRange.Visible:=True;
 LADVoltage.Caption:='Voltage:';
 LADCurrent.Caption:='Current:';

 BIVSave.OnClick:=SaveClick;
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

procedure TIVchar.DependTimerTimer(Sender: TObject);
begin
  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
  Temperature_MD.ActiveInterface.GetDataThread(TemperMessage,EventMeasuringEnd);
end;

procedure TIVchar.VoltmetrsCreate;
begin
  V721A := TV721A.Create(ComPort1, 'B7-21A');
  V721_I := TV721.Create(ComPort1, 'B7-21 (1)');
  V721_II := TV721.Create(ComPort1, 'B7-21 (2)');
//  V721_II := TV721_Brak.Create(ComPort1, 'B7-21 (2)');
  SetLength(VoltmetrShows,3);
  VoltmetrShows[0]:= TVoltmetrShow.Create(V721A, RGV721A_MM, RGV721ARange, LV721A, LV721AU, LV721APin, LV721APinG, BV721ASet, BV721ASetGate, BV721AMeas, SBV721AAuto, CBV721A, Time);
  VoltmetrShows[1]:= TVoltmetrShow.Create(V721_I, RGV721I_MM, RGV721IRange, LV721I, LV721IU, LV721IPin, LV721IPinG, BV721ISet, BV721ISetGate, BV721IMeas, SBV721IAuto, CBV721I, Time);
  VoltmetrShows[2]:= TVoltmetrShow.Create(V721_II, RGV721II_MM, RGV721IIRange, LV721II, LV721IIU, LV721IIPin, LV721IIPinG, BV721IISet, BV721IISetGate, BV721IIMeas, SBV721IIAuto, CBV721II, Time);

  DS18B20:=TDS18B20.Create(ComPort1, 'DS18B20');
  DS18B20show:=TPinsShow.Create(DS18B20.Pins,LDS18BPin,nil,BDS18B,nil,CBDS18b20);

  ThermoCuple:=TThermoCuple.Create;

  UT70B:=TUT70B.Create(ComPortUT70B, 'UT70B');
  UT70BShow:= TUT70BShow.Create(UT70B, RGUT70B_MM, RGUT70B_Range, RGUT70B_RangeM, LUT70B, LUT70BU, BUT70BMeas, SBUT70BAuto, Time);

end;

procedure TIVchar.VoltmetrsReadFromIniFileAndToForm;
 var i:integer;
begin
 for I := 0 to High(VoltmetrShows) do
  begin
  VoltmetrShows[i].PinShow.PinsReadFromIniFile(ConfigFile);
  VoltmetrShows[i].NumberPinShow;
  VoltmetrShows[i].ButtonEnabled;
  end;
 DS18B20show.PinsReadFromIniFile(ConfigFile);
 DS18B20show.NumberPinShow;
end;

procedure TIVchar.VoltmetrsWriteToIniFile;
  var i:integer;
begin
 for I := 0 to High(VoltmetrShows) do
  VoltmetrShows[i].PinShow.PinsWriteToIniFile(ConfigFile);
 DS18B20show.PinsWriteToIniFile(ConfigFile);
end;

procedure TIVchar.WMMyMeasure(var Mes: TMessage);
begin
  if Mes.WParam=TemperMessage then
    begin
      LTRValue.Caption:=FloatToStrF(Temperature_MD.ActiveInterface.Value,ffFixed, 5, 2);
      LTermostatCTValue.Caption:=FloatToStrF(Temperature_MD.ActiveInterface.Value,ffFixed, 5, 2);
      if IsWorkingTermostat then
        begin
          if IsPID_Termostat_Created then
              PID_Termostat.ControlingSignal(Temperature_MD.ActiveInterface.Value)
                                     else
            begin
              PID_Termostat:=TPID.Create(DoubleConstantShows[16].Data,
                                         DoubleConstantShows[17].Data,
                                         DoubleConstantShows[18].Data,
                                         DoubleConstantShows[7].Data,
                                         DoubleConstantShows[15].Data
                                         );
              IsPID_Termostat_Created:=True;
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
  SettingDevice.ActiveInterface.Reset;
//  if TIVDependence.IVMeasuringToStop then
//    showmessage('Procedure is stopped');
    showmessage('Measurement is done');
end;

procedure TIVchar.VoltmetrsFree;
 var i:integer;
begin
  for I := 0 to High(VoltmetrShows) do
        VoltmetrShows[i].Free;
  if assigned(V721A) then
    V721A.Free;
  if assigned(V721_I) then
    V721_I.Free;
  if assigned(V721_II) then
    V721_II.Free;

 DS18B20show.Free;
  if assigned(DS18B20) then
    DS18B20.Free;

 UT70BShow.Free;
  if assigned(UT70B) then
    UT70B.Free;

  ThermoCuple.Free;
  Simulator.Free;
end;

procedure TIVchar.DACCreate;
begin
  DACR2R:=TDACR2R.Create(ComPort1,'DAC R-2R');
  DACR2RShow:=TDACR2RShow.Create(DACR2R,LDACR2RPinC,LDACR2RPinG,LOVDACR2R,LOKDACR2R,
                                 BDACR2RSetC,BDACR2RSetG,BOVchangeDACR2R,
                                 BOVsetDACR2R, BOKchangeDACR2R, BOKsetDACR2R,
                                 BDACR2RReset, CBDACR2R);
  D30_06:=TD30_06.Create(ComPort1,'D30_06');
  D30_06Show:=TD30_06Show.Create(D30_06,LD30PinC,LD30PinG,LOVD30,LOKD30,LValueRangeD30,
                                 BD30SetC,BD30SetG,BOVchangeD30,
                                 BOVsetD30, BOKchangeD30, BOKsetD30,
                                 BD30Reset, CBD30, RGD30);

end;

procedure TIVchar.DACFree;
begin
  DACR2RShow.Free;
  if assigned(DACR2R) then DACR2R.Free;
  D30_06Show.Free;
  if assigned(D30_06) then D30_06.Free;
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

  TermoCouple_MD:=TMeasuringDevice.Create(Devices,CBTcVMD,LTRValue,srVoltge);
  Temperature_MD:=TTemperature_MD.Create([Simulator,ThermoCuple,DS18B20],CBTD,LTRValue);

  SetLength(Devices,5);
  Devices[4]:=UT70B;
  Current_MD:=TMeasuringDevice.Create(Devices,CBCMD,LADCurrentValue,srCurrent);
  VoltageIV_MD:=TMeasuringDevice.Create(Devices,CBVMD,LADVoltageValue,srVoltge);

  DACR2R_MD:=TMeasuringDevice.Create(Devices,CBMeasDACR2R,LMeasR2R,srPreciseVoltage);
  DACR2R_MD.AddActionButton(BMeasR2R);
  D30_MD:=TMeasuringDevice.Create(Devices,CBMeasD30,LMeasD30,srPreciseVoltage);
  D30_MD.AddActionButton(BMeasD30);

  SetLength(Devices,7);
  Devices[5]:=ThermoCuple;
  Devices[6]:=DS18B20;
  TimeD_MD:=
    TMeasuringDevice.Create(Devices,CBTimeMD,LADCurrentValue,srVoltge);
  Control_MD:=
    TMeasuringDevice.Create(Devices,CBControlMD,LControlCVValue,srPreciseVoltage);

  SetLength(DevicesSet,2);
  DevicesSet[0]:=Simulator;
  DevicesSet[1]:=DACR2R;

  if assigned(ET1255_DACs[0]) then
   begin
    SetLength(DevicesSet,5);
    DevicesSet[2]:=ET1255_DACs[0];
    DevicesSet[3]:=ET1255_DACs[1];
    DevicesSet[4]:=ET1255_DACs[2];
    ET1255_DAC_MD[0]:=TMeasuringDevice.Create(Devices,
                      CBMeasET1255Ch0,LMeas1255Ch0,srPreciseVoltage);
    ET1255_DAC_MD[0].AddActionButton(BMeas1255Ch0);
    ET1255_DAC_MD[1]:=TMeasuringDevice.Create(Devices,
                      CBMeasET1255Ch1,LMeas1255Ch1,srPreciseVoltage);
    ET1255_DAC_MD[1].AddActionButton(BMeas1255Ch1);
    ET1255_DAC_MD[2]:=TMeasuringDevice.Create(Devices,
                      CBMeasET1255Ch2,LMeas1255Ch2,srPreciseVoltage);
    ET1255_DAC_MD[2].AddActionButton(BMeas1255Ch2);
   end;

  SetLength(DevicesSet,High(DevicesSet)+2);
  DevicesSet[High(DevicesSet)]:=D30_06;

  SettingDevice:=TSettingDevice.Create(DevicesSet,CBVS);
  SettingDeviceControl:=TSettingDevice.Create(DevicesSet,CBControlCD);
  SettingTermostat:=TSettingDevice.Create(DevicesSet,CBTermostatCD);
end;

procedure TIVchar.DevicesFree;
begin
  SettingTermostat.Free;
  SettingDeviceControl.Free;
  SettingDevice.Free;
  Control_MD.Free;
  TimeD_MD.Free;
  Temperature_MD.Free;
  Current_MD.Free;
  VoltageIV_MD.Free;
  DACR2R_MD.Free;
  D30_MD.Free;
  TermoCouple_MD.Free;
  ET1255_DAC_MD[0].Free;
  ET1255_DAC_MD[1].Free;
  ET1255_DAC_MD[2].Free;
end;

procedure TIVchar.DevicesReadFromIniAndToForm;
begin
  SettingTermostat.ReadFromIniFile(ConfigFile,MD_IniSection,'Termostat input');
  SettingDeviceControl.ReadFromIniFile(ConfigFile,MD_IniSection,'Control input');
  SettingDevice.ReadFromIniFile(ConfigFile,MD_IniSection,'Input voltage');
  Temperature_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'Temperature');
  Current_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'Current');
  VoltageIV_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'Voltage');
  DACR2R_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'R2R');
  D30_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'D30');
  TermoCouple_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'Thermocouple');
  ET1255_DAC_MD[0].ReadFromIniFile(ConfigFile,MD_IniSection,'ET1255_DAC_Ch0');
  ET1255_DAC_MD[1].ReadFromIniFile(ConfigFile,MD_IniSection,'ET1255_DAC_Ch1');
  ET1255_DAC_MD[2].ReadFromIniFile(ConfigFile,MD_IniSection,'ET1255_DAC_Ch2');
  TimeD_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'Time Dependence');
  Control_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'Control setup');
end;

procedure TIVchar.DevicesWriteToIniFile;
begin
  ConfigFile.EraseSection(MD_IniSection);
  SettingDeviceControl.WriteToIniFile(ConfigFile,MD_IniSection,'Control input');
  SettingTermostat.WriteToIniFile(ConfigFile,MD_IniSection,'Termostat input');
  SettingDevice.WriteToIniFile(ConfigFile,MD_IniSection,'Input voltage');
  Temperature_MD.WriteToIniFile(ConfigFile,MD_IniSection,'Temperature');
  Current_MD.WriteToIniFile(ConfigFile,MD_IniSection,'Current');
  VoltageIV_MD.WriteToIniFile(ConfigFile,MD_IniSection,'Voltage');
  DACR2R_MD.WriteToIniFile(ConfigFile,MD_IniSection,'R2R');
  D30_MD.WriteToIniFile(ConfigFile,MD_IniSection,'D30');
  TermoCouple_MD.WriteToIniFile(ConfigFile,MD_IniSection,'Thermocouple');
  ET1255_DAC_MD[0].WriteToIniFile(ConfigFile,MD_IniSection,'ET1255_DAC_Ch0');
  ET1255_DAC_MD[1].WriteToIniFile(ConfigFile,MD_IniSection,'ET1255_DAC_Ch1');
  ET1255_DAC_MD[2].WriteToIniFile(ConfigFile,MD_IniSection,'ET1255_DAC_Ch2');
  TimeD_MD.WriteToIniFile(ConfigFile,MD_IniSection,'Time Dependence');
  Control_MD.WriteToIniFile(ConfigFile,MD_IniSection,'Control setup');
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
end;

procedure TIVchar.PinsFromIniFile;
var
  i: Integer;
begin
  for I := 0 to ConfigFile.ReadInteger('PinNumbers', 'PinCount', 3) - 1 do
    NumberPins.Add(ConfigFile.ReadString('PinNumbers', 'Pin' + IntToStr(i), IntToStr(UndefinedPin)));
  for I := 0 to ConfigFile.ReadInteger('PinNumbersOneWire', 'PinCount', 1) - 1 do
    NumberPinsOneWire.Add(ConfigFile.ReadString('PinNumbersOneWire', 'Pin' + IntToStr(i), IntToStr(UndefinedPin)));
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

  LADVoltageValue.Caption:=Undefined;
  LADCurrentValue.Caption:=Undefined;
  LADInputVoltageValue.Caption:=Undefined;
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
  CBMeasurements.ItemIndex:=0;

  IsWorkingTermostat:=False;
  IsPID_Termostat_Created:=False;

end;

end.
