unit IVchar_main;

interface

uses
//  FastMM4,
  Windows, Messages, SysUtils, Graphics, Forms,IniFiles,
  PacketParameters,
  OlegType, OlegMath,Measurement,
  TempThread, ShowTypes,OlegGraph, Dependence, V7_21,
  TemperatureSensor,
  DACR2Ru, ET1255, RS232_Mediator_Tread,
  CPortCtl, Grids, Chart, TeeProcs, Series,
  TeEngine, ExtCtrls, Buttons,
  ComCtrls, CPort, StdCtrls, Dialogs,
  Controls, Classes, D30_06u,Math, PID,
  MDevice,  Spin,
  HighResolutionTimer,
  MCP3424u,
  ADS1115,
  MLX90615u,
  OlegShowTypes,
  INA226,
  OlegTypePart2,
  OlegVector,
  OlegDigitalManipulation,
  OlegDevice,
  TMP102u,
  ADT74x0u,
  MCP9808u,
  ArduinoDeviceNew,
  AD9833u,
  GDS_806Su,
  UT70,
  RS232deviceNew,
  ArduinoDeviceShow, DependOnArduino;

const
  MeasIV='IV characteristic';
  MeasFastIV='Fast IV characteristic';
  MeasR2RCalib='R2R-DAC Calibration';
  MeasTimeD='Time dependence';
  MeasTwoTimeD='Time two dependence';
  MeasControlParametr='Controller on time';
  MeasTempOnTime='Temperature on time';
  MeasIscAndVocOnTime='Voc and Isc on time';
  MeasIVonTemper='IV char on temperature';
  MeasFastIVArd='Fast IV by Arduino';


  IscVocTimeToWait=500;

  FreeTest=False;
//  FreeTest=True;
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
    LADInputVoltage: TLabel;
    LADInputVoltageValue: TLabel;
    CBCurrentValue: TCheckBox;
    CBPC: TCheckBox;
    GBDS18B: TGroupBox;
    TS_Temper: TTabSheet;
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
    BOVset1255Ch0: TButton;
    BReset1255Ch0: TButton;
    BOKset1255Ch0: TButton;
    GBMeas1255Ch0: TGroupBox;
    LMeas1255Ch0: TLabel;
    BMeas1255Ch0: TButton;
    STMD1255Ch0: TStaticText;
    CBMeasET1255Ch0: TComboBox;
    GBET1255DACh1: TGroupBox;
    BOVset1255Ch1: TButton;
    BReset1255Ch1: TButton;
    BOKset1255Ch1: TButton;
    GBMeas1255Ch1: TGroupBox;
    LMeas1255Ch1: TLabel;
    BMeas1255Ch1: TButton;
    STMD1255Ch1: TStaticText;
    CBMeasET1255Ch1: TComboBox;
    GBET1255DACh2: TGroupBox;
    BOVset1255Ch2: TButton;
    BReset1255Ch2: TButton;
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
    LCodeRangeDACR2R: TLabel;
    LValueRangeDACR2R: TLabel;
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
    BOVset1255Ch3: TButton;
    BReset1255Ch3: TButton;
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
    LDBtime: TLabel;
    STDBtime: TStaticText;
    GBLEDCon: TGroupBox;
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
    Pads1115_adr: TPanel;
    GBR2R: TGroupBox;
    GBD3006: TGroupBox;
    LCodeRangeD30: TLabel;
    LValueRangeD30: TLabel;
    GBMeasD30: TGroupBox;
    LMeasD30: TLabel;
    BMeasD30: TButton;
    STMDD30: TStaticText;
    CBMeasD30: TComboBox;
    BD30Reset: TButton;
    BOKsetD30: TButton;
    BOVsetD30: TButton;
    PD30PinVol: TPanel;
    PD30PinCur: TPanel;
    RGD30: TRadioGroup;
    LOVD30: TLabel;
    STOVD30: TStaticText;
    LOKD30: TLabel;
    STOKD30: TStaticText;
    LOV1255ch0: TLabel;
    STOV1255ch0: TStaticText;
    LOK1255Ch0: TLabel;
    STOK1255Ch0: TStaticText;
    LOV1255ch1: TLabel;
    LOV1255ch2: TLabel;
    LOV1255ch3: TLabel;
    LOK1255Ch1: TLabel;
    LOK1255Ch2: TLabel;
    LOK1255Ch3: TLabel;
    STOV1255ch1: TStaticText;
    STOV1255ch2: TStaticText;
    STOV1255ch3: TStaticText;
    STOK1255Ch1: TStaticText;
    STOK1255Ch2: TStaticText;
    STOK1255Ch3: TStaticText;
    GBAD9866ch0: TGroupBox;
    LPhaseRangeAD9866: TLabel;
    L9833PhaseCh0: TLabel;
    L9833FreqCh0: TLabel;
    LFreqRangeAD9866: TLabel;
    PAD9833PinC: TPanel;
    ST9866PhaseCh0: TStaticText;
    ST9866FreqCh0: TStaticText;
    SBAD9833GenCh0: TSpeedButton;
    SBAD9833Stop: TSpeedButton;
    GBAD9866ch1: TGroupBox;
    L9833PhaseCh1: TLabel;
    L9833FreqCh1: TLabel;
    SBAD9833GenCh1: TSpeedButton;
    ST9866PhaseCh1: TStaticText;
    ST9866FreqCh1: TStaticText;
    RGAD9833Mode: TRadioGroup;
    TS_GDS: TTabSheet;
    GB_GDS_Com: TGroupBox;
    ComCBGDS_Port: TComComboBox;
    ComCBGDS_Baud: TComComboBox;
    ST_GDS_Rate: TStaticText;
    ST_GDS_StopBits: TStaticText;
    ComCBGDS_Stop: TComComboBox;
    ST_GDS_Parity: TStaticText;
    ComCBGDS_Parity: TComComboBox;
    LGDSPort: TLabel;
    GB_GDS_Set: TGroupBox;
    LGDS_Mode: TLabel;
    STGDS_Mode: TStaticText;
    B_GDS_SetSet: TButton;
    B_GDS_SetGet: TButton;
    B_GDS_Test: TButton;
    B_GDS_SetSav: TButton;
    B_GDS_SetLoad: TButton;
    B_GDS_SetAuto: TButton;
    B_GDS_SetDef: TButton;
    LGDS_RLength: TLabel;
    STGDS_RLength: TStaticText;
    LGDS_AveNum: TLabel;
    STGDS_AveNum: TStaticText;
    LGDS_Ch1: TLabel;
    LGDSU_Ch1: TLabel;
    ChGDS: TChart;
    GB_GDS_Ch1: TGroupBox;
    LGDS_OffsetCh1: TLabel;
    STGDS_OffsetCh1: TStaticText;
    B_GDS_MeasCh1: TButton;
    SB_GDS_AutoCh1: TSpeedButton;
    STGDS_MeasCh1: TStaticText;
    CBGDS_DisplayCh1: TCheckBox;
    CBGDS_InvertCh1: TCheckBox;
    STGDS_ProbCh1: TStaticText;
    STGDS_CoupleCh1: TStaticText;
    STGDS_ScaleCh1: TStaticText;
    GB_GDS_Show: TGroupBox;
    PGGDS_Show: TRadioGroup;
    B_GDS_MeasShow: TButton;
    SB_GDS_AutoShow: TSpeedButton;
    B_GDS_Refresh: TButton;
    B_GDS_Run: TButton;
    B_GDS_Stop: TButton;
    B_GDS_Unlock: TButton;
    STGDS_ScaleGoriz: TStaticText;
    GB_GDS_Ch2: TGroupBox;
    LGDS_OffsetCh2: TLabel;
    LGDS_Ch2: TLabel;
    LGDSU_Ch2: TLabel;
    SB_GDS_AutoCh2: TSpeedButton;
    STGDS_OffsetCh2: TStaticText;
    B_GDS_MeasCh2: TButton;
    STGDS_MeasCh2: TStaticText;
    CBGDS_DisplayCh2: TCheckBox;
    CBGDS_InvertCh2: TCheckBox;
    STGDS_ProbCh2: TStaticText;
    STGDS_CoupleCh2: TStaticText;
    STGDS_ScaleCh2: TStaticText;
    GDS_SeriesCh1: TLineSeries;
    GDS_SeriesCh2: TLineSeries;
    GBMLX615: TGroupBox;
    PMLX615: TPanel;
    GBMLX615_GC: TGroupBox;
    STMLX615_GC: TStaticText;
    BMLX615_GCread: TButton;
    BMLX615_GCwrite: TButton;
    BMLX615_Calib: TButton;
    GBina226: TGroupBox;
    GBina226_shunt: TGroupBox;
    Lina226_shuntmeas: TLabel;
    Bina226_shuntmeas: TButton;
    Pina226_shunttime: TPanel;
    Pina226_adr: TPanel;
    Pina226_aver: TPanel;
    Lina226_Rsh: TLabel;
    STina226_Rsh: TStaticText;
    GBina226_Bus: TGroupBox;
    Lina226_busmeas: TLabel;
    Bina226_busmeas: TButton;
    Pina226_bustime: TPanel;
    STina226_1: TStaticText;
    STina226_2: TStaticText;
    Lina226_TF: TLabel;
    STina226_TF: TStaticText;
    CBET1255_ASer: TCheckBox;
    CBET1255_AG: TCheckBox;
    RGIscVocMode: TRadioGroup;
    GBTempDepend: TGroupBox;
    STTemDepStart: TStaticText;
    LTemDepStart: TLabel;
    LTemDepFinish: TLabel;
    STTemDepFinish: TStaticText;
    LTemDepStep: TLabel;
    STTemDepStep: TStaticText;
    LTemDepIsoInterval: TLabel;
    STTemDepIsoInterval: TStaticText;
    STTemDepTolCoef: TStaticText;
    LTemDepTolCoef: TLabel;
    GBSTS21: TGroupBox;
    PSTS21: TPanel;
    TS_HandMade: TTabSheet;
    GB_oCur: TGroupBox;
    LoCur: TLabel;
    LUoCur: TLabel;
    B_oCur_Meas: TButton;
    SB_oCur_Auto: TSpeedButton;
    GB_oCurMeasVal: TGroupBox;
    L_oCurMeasVal: TLabel;
    B_oCurMeasVal: TButton;
    ST_oCurMeasVal: TStaticText;
    CB_oCurMeasVal: TComboBox;
    GB_oCurMeasDiap: TGroupBox;
    L_oCurMeasDiap: TLabel;
    B_oCurMeasDiap: TButton;
    ST_oCurMeasDiap: TStaticText;
    CB_oCurMeasDiap: TComboBox;
    ST_oCurBias: TStaticText;
    L_oCurBias: TLabel;
    ComPortGDS: TComPort;
    GBADT74: TGroupBox;
    PADT74Pin: TPanel;
    GBMCP9808: TGroupBox;
    PMCP9808Pin: TPanel;
    LTermostatOVmax: TLabel;
    STTermostatOVmax: TStaticText;
    LTermostatOVmin: TLabel;
    STTermostatOVmin: TStaticText;
    LControlOVmax: TLabel;
    STControlOVmax: TStaticText;
    LControlOVmin: TLabel;
    STControlOVmin: TStaticText;
    GB_oVol: TGroupBox;
    LoVol: TLabel;
    LUoVol: TLabel;
    SB_oVol_Auto: TSpeedButton;
    B_oVol_Meas: TButton;
    GB_oVolMeasVal: TGroupBox;
    L_oVolMeasVal: TLabel;
    B_oVolMeasVal: TButton;
    ST_oVolMeasVal: TStaticText;
    CB_oVolMeasVal: TComboBox;
    GBad9833: TGroupBox;
    GBad5752: TGroupBox;
    PAD5752Mod: TPanel;
    GBad5752ChA: TGroupBox;
    LKodRange5752chA: TLabel;
    LOK5752chA: TLabel;
    LOV5752chA: TLabel;
    LValueRange5752chA: TLabel;
    B5752ResetChA: TButton;
    BOKset5752chA: TButton;
    BOVset5752chA: TButton;
    STOK5752chA: TStaticText;
    STOV5752chA: TStaticText;
    GBMeas5752chA: TGroupBox;
    LMeas5752chA: TLabel;
    BMeas5752chA: TButton;
    STMD5752chA: TStaticText;
    CBMeas5752chA: TComboBox;
    RG5752chADiap: TRadioGroup;
    BPoff5752chA: TButton;
    GBad5752ChB: TGroupBox;
    LKodRange5752chB: TLabel;
    LOK5752chB: TLabel;
    LOV5752chB: TLabel;
    LValueRange5752chB: TLabel;
    B5752ResetChB: TButton;
    BOKset5752chB: TButton;
    BOVset5752chB: TButton;
    STOK5752chB: TStaticText;
    STOV5752chB: TStaticText;
    GBMeas5752chB: TGroupBox;
    LMeas5752chB: TLabel;
    BMeas5752chB: TButton;
    STMD5752chB: TStaticText;
    CBMeas5752chB: TComboBox;
    RG5752chBDiap: TRadioGroup;
    BPoff5752chB: TButton;
    PD30PinGate: TPanel;
    CBuseDBT: TCheckBox;
    SBLEDTurn: TSpeedButton;
    BTermostatLoad: TButton;
    SBIVPause: TSpeedButton;
    BWriteTM: TButton;
    CBtempIVdark: TCheckBox;
    CBtempIVillum: TCheckBox;
    LtempRepNum: TLabel;
    STtempRepNum: TStaticText;
    CBtimeDarkIV: TCheckBox;
    BComReload: TButton;

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
    procedure SBControlBeginClick(Sender: TObject);
    procedure BControlResetClick(Sender: TObject);
    procedure SBTermostatClick(Sender: TObject);
    procedure BTermostatResetClick(Sender: TObject);
    procedure CBMeasurementsChange(Sender: TObject);
    procedure CBFvsSClick(Sender: TObject);
    procedure TermostatWatchDogTimer(Sender: TObject);
    procedure ControlWatchDogTimer(Sender: TObject);
    procedure BET1255_show_saveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RGIscVocModeClick(Sender: TObject);
    procedure SBLEDTurnClick(Sender: TObject);
    procedure BWriteTMClick(Sender: TObject);
    procedure BComReloadClick(Sender: TObject);
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
    procedure RangesCreate;
    procedure StepReadFromIniFile (A:TVector; Ident:string);
    procedure StepsReadFromIniFile;
    procedure StepsWriteToIniFile;
    procedure ForwStepShow;
    procedure RevStepShow;
    procedure DelayTimeReadFromIniFile;
    procedure DelayTimeWriteToIniFile;
    procedure SettingWriteToIniFile;
    procedure VoltmetrsCreate;
    procedure ObjectsFree;
    procedure DACCreate;
//    procedure DACFree;
    procedure DACReadFromIniFileAndToForm;
//    procedure DACWriteToIniFile;
    procedure TestVarCreate;
    procedure TestVarFree;
    procedure DevicesCreate;
    procedure TemperatureThreadCreate;
    procedure ControllerThreadCreate;
    function StepDetermine(Voltage: Double; ItForward: Boolean):double;
    procedure BoxFromIniFile;
    procedure BoxToIniFile;
    procedure VectorsCreate;
    procedure VectorsDispose;
    { Private declarations }
    procedure ConstantShowCreate;
    procedure PIDShowCreateAndFromIniFile;
    procedure SaveCommentsFile(FileName: string);
    procedure DependenceMeasuringCreate;
    procedure IVCharHookCycle();
    procedure CalibrHookCycle();
    procedure IVCharHookStep();
    procedure CalibrationHookStep;
    procedure IVcharHookBegin;
    procedure IVcharOnTempHookBegin;
    procedure IVcharOnTempHookEnd;
    procedure IVcharOnTempHookFirstMeas;
    procedure IVcharOnTempHookSecondMeas;
    procedure DependenceHookEnd;
    procedure HookBegin;
    procedure FastIVHookBeginBase(FastIVDep:TFastIVDependence);
    procedure FastIVHookBegin;
    procedure FastArduinoIVHookBegin;
    procedure FastIVHookEndBase(FastIVDep:TFastIVDependence);
    procedure FastIVHookEnd;
    procedure FastArduinoIVHookEnd;
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
    procedure ActionInSaveButtonFastIV(Sender: TObject);
    function DiapazonIMeasurement(Measurement:IMeasurement):ShortInt;
    procedure CorrectionLimit(var NewCorrection: Double);
    procedure IVOldFactorDetermination(var Factor: Double);
    function IVNewFactorDetermination():double;
    procedure IVVoltageInputSignDetermine;
    procedure IVMR_Refresh;
    procedure MCP3424Create;
    procedure ADS1115Create;
    procedure INA226Create;
    procedure GDS_Create;
    procedure SaveIVMeasurementResults(FileName: string; DataVector:TVector);
    procedure DACReset;
    procedure FastIVMeasuringComplex(const FilePrefix: string);
    procedure LED_OpenIfCondition;
    procedure LEDCloseIfCondition;
    procedure LED_OnIfCondition(OrCondition:boolean=False);
    procedure LED_OffIfCondition(OrCondition:boolean=False);
    procedure IscVocPin_toVoc;
    procedure IscVocPin_toIsc;
    procedure ComPort1Reload;
  public
    TestVar2:TINA226_Channel;
//     TestVar:TINA226_Module;
     TestVar:TSimpleFreeAndAiniObject;
//    TestVar2:TSimpleFreeAndAiniObject;
    TestVar3:TSimpleFreeAndAiniObject;
    TestVar4:array of IMeasurement;
    ShowArray:TObjectArray;
    AnyObjectArray:TObjectArray;
    ArduinoMeters:TObjectArray;

    ArduinoDataSubject:TArduinoDataSubject;

//    V721A:TV721A;
//    V721_I,V721_II:TV721;
////    V721_I:TV721;
////    V721_II:TV721_Brak;
//    VoltmetrShows:array of TVoltmetrShow;

//    DS18B20:TDS18B20;
    DS18B20show:TOnePinsShow;
//    TMP102:TTMP102;
    TMP102show:TI2C_PinsShow;

//    ADT74x0:TADT74x0;
//    ADT74x0show:TI2C_PinsShow;
//    MCP9808:TMCP9808;
    MCP9808show:TI2C_PinsShow;
//    HTU21D:THTU21D;
//    STS21:TSTS21;
//    MLX90615:TMLX90615;
    MLX90615Show:TMLX90615Show;

//    ThermoCuple:TThermoCuple;
//    MCP3424:TMCP3424_Module;
    MCP3424show:TI2C_PinsShow;

//    MCP3424_Channels:array [TMCP3424_ChanelNumber] of TMCP3424_Channel;
//    MCP3424_ChannelShows:array [TMCP3424_ChanelNumber] of TMCP3424_ChannelShow;

//    ADS11115module:TADS1115_Module;
//    ADS11115show:TI2C_PinsShow;
//
//    ADS11115_Channels:array [TADS1115_ChanelNumber] of TADS1115_Channel;
//    ADS11115_ChannelShows:array [TADS1115_ChanelNumber] of TADS1115_ChannelShow;

//    INA226_Module:TINA226_Module;
//    INA226_ModuleShow:TINA226_ModuleShow;
//    INA226_Shunt,INA226_Bus:TINA226_Channel;
//    INA226_ShuntShow,INA226_BusShow:TINA226_ChannelShow;

//    GDS_806S:TGDS_806S;
//    GDS_806S_Channel:array[TGDS_Channel]of TGDS_806S_Channel;
//    GDS_806S_Show:TGDS_806S_Show;

//    OlegCurrent:TCurrent;
//    CurrentShow:TCurrentShow;

    IscVocPinChanger,LEDOpenPinChanger:TArduinoPinChanger;
    IscVocPinChangerShow,LEDOpenPinChangerShow:TArduinoPinChangerShow;
    ConfigFile:TIniFile;
    NumberPins:TStringList; // номери пінів, які використовуються як керуючі для SPI
    NumberPinsOneWire:TStringList; // номери пінів, які використовуються для OneWire
    NumberPinsInput:TStringList; // номери пінів, які можуть бути викристані для переривань
    ForwSteps,RevSteps,IVResult,VolCorrection,
    VolCorrectionNew,TemperData:TVector;

//    DACR2R:TDACR2R;
//    DACR2RShow:TDACR2RShow;

//    D30_06:TD30_06;
//    D30_06Show:TD30_06Show;

//   AD9833:TAD9833;
//   AD9833Show:TAD9833Show;

    Simulator:TSimulator;

//    UT70B:TUT70B;
//    UT70C:TUT70C;
//    UT70BShow:TUT70BShow;
//    UT70CShow:TUT70CShow;


    ET1255_DACs:array[TET1255_DAC_ChanelNumber] of TET1255_DAC;
    ET1255_DACsShow:array[TET1255_DAC_ChanelNumber] of TDAC_Show;
    ET1255isPresent:boolean;
    ET1255_ADCModule:TET1255_ModuleAndChan;
    ET1255_ADCShow:TET1255_ADCShow;


    TermoCoupleDevices,AllDevices,VandIDevices:TArrIMeas;
    SetingDevices:TArrIDAC;
    TemperMeasurDevices:TArrITempMeas;
//    Current_MDNew,VoltageIV_MDNew,DACR2R_MDNew,D30_MDNew,
//    TermoCouple_MDNew,TimeD_MDNew,Control_MDNew,TimeD_MD2New,
//    Isc_MDNew,Voc_MDNew:TMeasuringDeviceNew;
    Devices:array of IMeasurement;
//    PDevices:array of Pointer;
    DevicesSet:array of IDAC;
    Temperature_MD:TTemperature_MD;
    Current_MD,VoltageIV_MD,DACR2R_MD,D30_MD,
    TermoCouple_MD,TimeD_MD,Control_MD,TimeD_MD2,
    Isc_MD,Voc_MD:TMeasuringDevice;
        ET1255_DAC_MD:array[TET1255_DAC_ChanelNumber] of TMeasuringDevice;
    AD5752chA_MD,AD5752chB_MD:TMeasuringDevice;
    SettingDevice,SettingDeviceControl,SettingTermostat,
    SettingDeviceLED:TSettingDevice;
    ArduinoSenders:TArrIArduinoSender;
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
    LEDCurrentCS,Dragon_backTimeCS,
    RevVoltagePrecisionCS,ForVoltagePrecisionCS,
    MinCurrentCS,MaxCurrentCS,ParasiticResistanceCS:TDoubleParameterShow;
    ControlIntervalCS,MeasurementDurationCS,
    MeasurementIntervalCS, TemperatureMeasIntervalCS,
    TemperatureRepetitionNumber:TIntegerParameterShow;
    Imax,Imin:double;

    IVMeasuring,CalibrMeasuring:TIVDependence;
    CustomFastIVMeas,FastIVMeasuring:TFastIVDependence;
    FastArduinoIV:TFastArduinoIVDependence;
    TimeDependence:TTimeDependenceTimer;
    ControlParameterTime,TemperatureOnTime:TTimeDependence;
    IVcharOnTemperature:TTemperatureDependence;
    ShowTempDep:TShowTemperatureDependence;
    TimeTwoDependenceTimer,IscVocOnTime:TTimeTwoDependenceTimer;
    Dependencies:Array of TFastDependence;
    PID_Termostat,PID_Control:TPID;
    PID_Termostat_ParametersShow,PID_Control_ParametersShow:TPID_ParametersShow;
    IsPID_Termostat_Created,IscVocOnTimeModeIsFastIV,
    IscVocOnTimeIsRun:boolean;
    IVMeasResult,IVMRFirst,IVMRSecond:TIVMeasurementResult;
    Key:string;
  end;

const
  Undefined='NoData';
  Vmax=6.6;
  StepDefault=0.01;
  AtempNumbermax=3;

var
  IVchar: TIVchar;

implementation

uses
  ArduinoADC, OlegFunction, AD5752R;

{$R *.dfm}

procedure TIVchar.ConstantShowCreate;
begin
  ParasiticResistanceCS:=TDoubleParameterShow.Create(STPR,LPR,
        'Parasitic resistance',0,3);

  MaxCurrentCS:=TDoubleParameterShow.Create(STMC,LMC,
        'Maximum current',
        'Maximum current for I-V characteristic measurement is expected',2e-2,2);

  MinCurrentCS:=TDoubleParameterShow.Create(STMinC,LMinC,
        'Minimum current',
        'Minimum current for I-V characteristic measurement is expected',5e-11,2);

  ForVoltagePrecisionCS:=TDoubleParameterShow.Create(STFVP,LFVP,
        'Forward voltage precision',
        'Voltage precision for forward I-V characteristic is expected',0.001,4);

  RevVoltagePrecisionCS:=TDoubleParameterShow.Create(STRVP,LRVP,
        'Reverse voltage precision',
        'Voltage precision for reverse I-V characteristic is expected',0.005,4);

  MeasurementIntervalCS:=TIntegerParameterShow.Create(STTimeInterval,LTimeInterval,
        'Measurement interval, (s)',
        'Time dependence measurement interval',15);
  MeasurementIntervalCS.IsPositive:=True;

  TemperatureMeasIntervalCS:=TIntegerParameterShow.Create(STTMI,LTMI,
        'Temperature measurement interval (s)',5);
  TemperatureMeasIntervalCS.IsPositive:=True;


  MeasurementDurationCS:=TIntegerParameterShow.Create(STTimeDuration,LTimeDuration,
        'Measurement duration (s), 0 - infinite',
        'Full measurement duration',0);
  MeasurementDurationCS.IsPositive:=True;

 TemperatureRepetitionNumber:=TIntegerParameterShow.Create(STtempRepNum,LtempRepNum,
        'number of repetitions',
        'Number of repetitions at each temperature',1);
  TemperatureRepetitionNumber.IsPositive:=True;

  ControlIntervalCS:=TIntegerParameterShow.Create(STControlInterval,LControlInterval,
        'Controling interval (s)',
        'Controling measurement interval',15);
  ControlIntervalCS.IsPositive:=True;

  Dragon_backTimeCS:=TDoubleParameterShow.Create(STDBtime,LDBtime,
        'Dragon-back time (ms)',1,3);
  LEDCurrentCS:=TDoubleParameterShow.Create(STLED_onValue,LLED_onValue,
        'LED current (mA)',50);

  ShowArray.Add([LEDCurrentCS,Dragon_backTimeCS,ControlIntervalCS,
                MeasurementDurationCS,MeasurementIntervalCS,
//                TemperatureMeasIntervalCS,
                TemperatureRepetitionNumber,
                RevVoltagePrecisionCS,ForVoltagePrecisionCS,MinCurrentCS,
                MaxCurrentCS,ParasiticResistanceCS]);
end;

procedure TIVchar.ControllerThreadCreate;
begin
  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;

  ControllerThread:=
    TControllerThread.Create(Control_MD.ActiveInterface,
                             SettingDeviceControl.ActiveInterface,
                             ControlIntervalCS.Data,
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
  ControlWatchDog.Interval:=ControlIntervalCS.Data*2000;
  Control_MD.ActiveInterface.NewData:=False;
end;

procedure TIVchar.SaveCommentsFile(FileName: string);
 var SR : TSearchRec;
     FF:TextFile;
     name, temp:string;
begin
    AssignFile(FF,'comments.dat');
    if FindFirst('comments.dat',faAnyFile,SR)=0 then Append(FF) else ReWrite(FF);

    if FindFirst(FileName,faAnyFile,SR)<>0 then Exit;
    name:=SR.Name;
//    AssignFile(FF,'comments');
//    if FindFirst('comments',faAnyFile,SR)=0 then Append(FF) else ReWrite(FF);
    FindClose(SR);
    DateTimeToString(temp, 'd.m.yyyy', FileDateToDateTime(SR.Time));
    writeln(FF,Name,' - ',temp,'  :'+inttostr(SecondFromDayBegining(FileDateToDateTime(SR.Time))));

    //    writeln(FF,Name,' - ',DateTimeToStr(FileDateToDateTime(DT)));
    write(FF,'T=',LTLastValue.Caption);
    writeln(FF);
    writeln(FF);
    CloseFile(FF);
end;

procedure TIVchar.DependenceHookEnd;
begin

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
    if TemperData.Count>0 then
       Temperature:=TemperData.SumY/TemperData.Count;
  end;

  if Key=MeasIVonTemper then  IVcharOnTempHookEnd;


  if (Key=MeasIscAndVocOnTime)or
      (Key=MeasTimeD)or(Key=MeasTwoTimeD) then
        begin
        SBIVPause.Enabled:=False;
        SBIVPause.OnClick:=nil;
        end;

  if Key=MeasIscAndVocOnTime then
   begin
    RGIscVocMode.Enabled:=True;
    IscVocOnTimeIsRun:=False;
    LED_OffIfCondition(True);
   end;

 BIVSave.OnClick:=ActionInSaveButton;
end;

procedure TIVchar.DependenceMeasuringCreate;
 var i:byte;
begin
  IVMeasuring := TIVDependence.Create(CBForw,CBRev,PBIV,BIVStop,
                         IVResult,ForwLine,RevLine,ForwLg,RevLg);

  FastIVMeasuring:=TFastIVDependence.Create(BIVStop,ForwLine,RevLine,ForwLg,RevLg);
  FastArduinoIV:=TFastArduinoIVDependence.Create(BIVStop,ForwLine,RevLine,ForwLg,RevLg);

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
  IVcharOnTemperature:=TTemperatureDependence.Create(PBIV,BIVStop,IVResult,
                                       ForwLine,ForwLg);
  ShowTempDep:=TShowTemperatureDependence.Create(IVcharOnTemperature,'IVonTemp',
                                                 STTemDepStart,STTemDepFinish,
                                                 STTemDepStep,STTemDepIsoInterval,STTemDepTolCoef,
                                                 LTemDepStart,LTemDepFinish,
                                                 LTemDepStep,LTemDepIsoInterval,LTemDepTolCoef);
  ShowArray.Add(ShowTempDep);

  FastIVMeasuring.HookBeginMeasuring:=FastIVHookBegin;
  FastIVMeasuring.HookEndMeasuring:=FastIVHookEnd;
  FastIVMeasuring.RangeFor:=IVCharRangeFor;
  FastIVMeasuring.RangeRev:=IVCharRangeRev;
  FastIVMeasuring.ForwardDelV:=ForwSteps;
  FastIVMeasuring.ReverseDelV:=RevSteps;
  FastIVMeasuring.CBForw:=CBForw;
  FastIVMeasuring.CBRev:=CBRev;
  FastIVMeasuring.SettingDevice:=SettingDevice;
  FastIVMeasuring.RGDiodOrientation:=RGDO;
  FastIVMeasuring.Voltage_MD:=VoltageIV_MD;
  FastIVMeasuring.Current_MD:=Current_MD;

  FastArduinoIV.HookBeginMeasuring:=FastArduinoIVHookBegin;
  FastArduinoIV.HookEndMeasuring:=FastArduinoIVHookEnd;
  FastIVMeasuring.CopyDecorationTo(FastArduinoIV);
  ArduinoMeters.Add(FastArduinoIV.ArduinoCommunication);


  SetLength(Dependencies,8);
  Dependencies[0]:=IVMeasuring;
  Dependencies[1]:=CalibrMeasuring;
  Dependencies[2]:=TimeDependence;
  Dependencies[3]:=TimeTwoDependenceTimer;
  Dependencies[4]:=IscVocOnTime;
  Dependencies[5]:=ControlParameterTime;
  Dependencies[6]:=TemperatureOnTime;
  Dependencies[7]:=IVcharOnTemperature;


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


  IVMeasuring.HookSetVoltage:=IVCharHookSetVoltage;
  CalibrMeasuring.HookSetVoltage:=CalibrHookSetVoltage;

  IVcharOnTemperature.HookSecondMeas:=IVcharOnTempHookSecondMeas;
  IVMeasuring.HookSecondMeas:=IVCharCurrentMeasHook;
  CalibrMeasuring.HookSecondMeas:=CalibrHookSecondMeas;
  TimeDependence.HookSecondMeas:=TimeDHookSecondMeas;
  TimeTwoDependenceTimer.HookSecondMeas:=TimeTwoDHookSecondMeas;
  IscVocOnTime.HookSecondMeas:=IscVocOnTimeHookSecondMeas;
  ControlParameterTime.HookSecondMeas:=TimeDHookSecondMeas;
  TemperatureOnTime.HookSecondMeas:=TimeDHookSecondMeas;


  IVcharOnTemperature.HookFirstMeas:=IVcharOnTempHookFirstMeas;
  IVMeasuring.HookFirstMeas:=IVCharVoltageMeasHook;
  CalibrMeasuring.HookFirstMeas:=CalibrHookFirstMeas;
  TimeDependence.HookFirstMeas:=TimeDHookFirstMeas;
  TimeTwoDependenceTimer.HookFirstMeas:=TimeTwoDHookFirstMeas;
  IscVocOnTime.HookFirstMeas:=IscVocOnTimeHookFirstMeas;
  ControlParameterTime.HookFirstMeas:=ControlTimeFirstMeas;
  TemperatureOnTime.HookFirstMeas:=TemperatureOnTimeFirstMeas;

  IVcharOnTemperature.HookDataSave:=IVcharOnTempHookBegin;

  IVMeasuring.HookDataSave:=IVCharHookDataSave;
  CalibrMeasuring.HookDataSave:=CalibrHookDataSave;


  IVMeasResult:=TIVMeasurementResult.Create;
  IVMRFirst:=TIVMeasurementResult.Create;
  IVMRSecond:=TIVMeasurementResult.Create;
  AnyObjectArray.Add([IVMeasResult,IVMRFirst,IVMRSecond]);
end;


procedure TIVchar.IVCharHookCycle;
begin
  ItIsBegining:=True;
  try
  if TIVParameters.ItIsForward then
    TIVParameters.DelayTimeChange(StrToInt(LFBDelayValue.Caption))
  else
    TIVParameters.DelayTimeChange(StrToInt(LRBDelayValue.Caption));
  except
    TIVParameters.DelayTimeChange(0)
  end;
end;

procedure TIVchar.IVCharHookStep();
begin
  TIVParameters.VoltageStepChange(StepDetermine(TIVParameters.VoltageInput,TIVParameters.ItIsForward));
end;


procedure TIVchar.IVcharOnTempHookBegin;
begin
// if IscVocOnTimeModeIsFastIV then
//  begin
   IVcharOnTemperature.Results.WriteToFile('zapas.dat',6);
//  end;
 PID_Termostat_ParametersShow.NeededValue:=IVcharOnTemperature.ExpectedTemperature;
 IVcharOnTemperature.Tolerance:=IVcharOnTemperature.ToleranceCoficient*PID_Termostat_ParametersShow.Tolerance;
 if SBTermostat.Down then BTermostatResetClick(nil)
                     else
                     begin
                     SBTermostat.Down:=true;
                     SBTermostatClick(nil);
                     end;
// if SBTermostat.Down then BTermostatResetClick(nil)
//                     else SBTermostatClick(nil);

end;

procedure TIVchar.IVcharOnTempHookEnd;
begin

 if SBTermostat.Down then
                     begin
                     SBTermostat.Down:=false;
                     SBTermostatClick(nil);
                     end;
end;

procedure TIVchar.IVcharOnTempHookFirstMeas;
begin
  TDependence.tempIChange(Temperature_MD.ActiveInterface.Value);
//  LADInputVoltageValue.Enabled:=true;
  if IVcharOnTemperature.IsotermalBegan then
     LADInputVoltageValue.Caption:=inttostr(round(IVcharOnTemperature.TimeFromIsotermalBegin))
                                        else
     LADInputVoltageValue.Caption:='---';
end;

procedure TIVchar.IVcharOnTempHookSecondMeas;
 var //LEDWasOpened:bool;
     RepetNumber:integer;
     PauseBegin:integer;
begin
// LEDWasOpened:=false;
 RepetNumber:=TemperatureRepetitionNumber.Data;
repeat
    if IscVocOnTimeModeIsFastIV then
     begin

       if assigned(TemperatureMeasuringThread) then
                 TemperatureMeasuringThread.Terminate;


       if CBtempIVdark.Checked
           then FastIVMeasuringComplex('d');

       if CBtempIVillum.Checked then
         begin
           LED_OpenIfCondition();
           LED_OnIfCondition();

             FastIVMeasuringComplex('l');
             IVcharOnTemperature.SecondMeasurementTime:=FastIVMeasuring.Voc;

           LED_OffIfCondition();
           LEDCloseIfCondition();
         end;

      //______________________________________
         if not(assigned(TemperatureMeasuringThread)) then
               TemperatureThreadCreate();
      //----------------------------------------
     end    else
     begin
       LED_OpenIfCondition();
       LED_OnIfCondition;

       if Voc_MD.ActiveInterface.Name<>'Simulation' then
         begin
          IscVocPin_toVoc();
          TemperData.Add(Temperature_MD.ActiveInterface.Value,
                         Voc_MD.ActiveInterface.GetData);
          IscVocPin_toIsc();
         end;
       VolCorrectionNew.Add(Temperature_MD.ActiveInterface.Value,
                            abs(Isc_MD.ActiveInterface.GetData));

      if Voc_MD.ActiveInterface.Name='Simulation'
        then IVcharOnTemperature.SecondMeasurementTime:=abs(Isc_MD.ActiveInterface.Value)
        else IVcharOnTemperature.SecondMeasurementTime:=Voc_MD.ActiveInterface.Value;

       LED_OffIfCondition();
       LEDCloseIfCondition();
     end;

 LADCurrentValue.Caption:=FloatToStrF(TDependence.tempI,ffExponent, 4, 3);
 LADVoltageValue.Caption:=FloatToStrF(IVcharOnTemperature.SecondMeasurementTime,ffExponent, 4, 3);

 RepetNumber:=RepetNumber-1;
// helpforme(inttostr(RepetNumber));
 if RepetNumber<1
   then Break
   else
   begin
     PauseBegin:=SecondFromDayBegining(Now());
     repeat
       sleep(1000);
       Application.ProcessMessages;
     until (SecondFromDayBegining(Now())-PauseBegin)>MeasurementIntervalCS.Data;
   end;
//    sleep(MeasurementIntervalCS.Data*1000)
until False;
 if not(IscVocOnTimeModeIsFastIV) then
   ToFileFromTwoVector('VocIsconT.dat',TemperData,VolCorrectionNew,6);
end;

procedure TIVchar.CalibrationHookStep;
begin
  TIVParameters.VoltageStepChange(DACR2R.CalibrationStep(TIVParameters.VoltageInput));
//  TIVParameters.VoltageStepChange(DACR2Rnw.CalibrationStep(TIVParameters.VoltageInput));
end;

procedure TIVchar.IVcharHookBegin;
begin
  SBTAuto.Enabled := False;
  NumberOfTemperatureMeasuring := round(PBIV.Max / 2);
  Temperature := ErResult;
  Imax := MaxCurrentCS.Data;
  Imin := MinCurrentCS.Data;
  VolCorrectionNew.SetLenVector(0);
  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
  TemperData.Clear;
  if not(SBTAuto.Down) then
    begin
      Temperature:=Temperature_MD.GetMeasurementResult;
      TemperData.Add(0,Temperature);
    end;
 ItIsDarkIV:=False;
end;

procedure TIVchar.HookBegin;
 begin
  CBMeasurements.Enabled:=False;
  BIVStart.Enabled := False;
  BConnect.Enabled := False;
  BIVSave.Enabled:=False;
  BParamReceive.Enabled := False;

  if Key=MeasIV then  IVcharHookBegin;
  if Key=MeasFastIV then FastIVHookBegin;
  if Key=MeasFastIVArd then FastArduinoIVHookBegin;
  
  if Key=MeasTimeD then MeasurementTimeParameterDetermination(TimeDependence);
  if Key=MeasTwoTimeD then  MeasurementTimeParameterDetermination(TimeTwoDependenceTimer);
  if Key=MeasIscAndVocOnTime then
   begin
   MeasurementTimeParameterDetermination(IscVocOnTime);
   VolCorrectionNew.Clear;
   RGIscVocMode.Enabled:=False;
   IscVocOnTime.FastIVisUsed:=IscVocOnTimeModeIsFastIV;
   IscVocOnTimeIsRun:=True;
   end;
  if Key=MeasIVonTemper then
    begin
     TemperData.Clear;
     VolCorrectionNew.Clear;
     IVcharOnTempHookBegin;
    end;

end;

procedure TIVchar.IVCharHookSetVoltage;
begin

  LADInputVoltageValue.Caption:=FloatToStrF(TIVParameters.VoltageInput,ffFixed, 4, 3);
  if not(TIVParameters.ItIsForward) then
    LADInputVoltageValue.Caption:='-'+LADInputVoltageValue.Caption;
  LADInputVoltageValue.Caption:=LADInputVoltageValue.Caption+
                        ' '+FloatToStrF(TIVParameters.VoltageInputReal,ffFixed, 4, 3);


 if RGDO.ItemIndex=1 then SettingDevice.SetValue(-TIVParameters.VoltageInputReal)
                     else SettingDevice.SetValue(TIVParameters.VoltageInputReal);

end;

procedure TIVchar.INA226Create;
begin
//  INA226_Module:=TINA226_Module.Create('INA226');
  INA226_ModuleShow:=TINA226_ModuleShow.Create(INA226_Module,Pina226_adr,Pina226_aver,
                        Lina226_Rsh,Lina226_TF,STina226_Rsh,STina226_TF);

//  INA226_Shunt:=TINA226_Channel.Create(ina_mShunt,INA226_Module);
//  INA226_Bus:=TINA226_Channel.Create(ina_mBus,INA226_Module);

  INA226_ShuntShow:=TINA226_ChannelShow.Create(INA226_Shunt,Pina226_shunttime,Lina226_shuntmeas,Bina226_shuntmeas);
  INA226_BusShow:=TINA226_ChannelShow.Create(INA226_Bus,Pina226_bustime,Lina226_busmeas,Bina226_busmeas);

  ShowArray.Add([INA226_ModuleShow,INA226_ShuntShow,INA226_BusShow]);

//  AnyObjectArray.Add([INA226_Module,INA226_Shunt,INA226_Bus]);
  ArduinoMeters.Add(INA226_Module);
end;

procedure TIVchar.IscVocOnTimeHookFirstMeas;
begin
//відкриття заслонки
   LED_OpenIfCondition();
//запалювання діоду
   LED_OnIfCondition(ForwLine.Count=0);

if IscVocOnTimeModeIsFastIV then
  begin

//_________________________
   if assigned(TemperatureMeasuringThread) then
           TemperatureMeasuringThread.Terminate;
//--------------------------



//   if (CBLEDAuto.Checked)or(TFastDependence.PointNumber=1) then
//    begin
//    SettingDeviceLED.ActiveInterface.Output(IledToVdac(LEDCurrentCS.Data));
//    sleep(400)
//    end;

   FastIVMeasuringComplex('l');

   TDependence.tempIChange(FastIVMeasuring.Voc);

   //визначення часу
//   TFastDependence.tempVChange(SecondFromDayBegining(Now()));
//   IscVocOnTime.SecondMeasurementTime:=TFastDependence.tempV{+1e-6};


   TTimeTwoDependenceTimer.SecondValueChange(FastIVMeasuring.Isc);


//   VolCorrectionNew.Add(Temperature_MD.ActiveInterface.Value,
//                         FastIVMeasuring.Voc);

//   MeasurementTimeParameterDetermination(IscVocOnTime);

   LED_OffIfCondition();

//   LADInputVoltageValue.Caption:=FloatToStrF(TTimeTwoDependenceTimer.SecondValue,ffExponent, 4, 3);
//   LADVoltageValue.Caption:=FloatToStrF(TDependence.tempI,ffExponent, 4, 3);
//   LADCurrentValue.Caption:=FloatToStrF(TDependence.tempV,ffExponent, 4, 3);

//
//   if (CBLEDOpenAuto.Checked)or(CBLEDAuto.Checked)
//     then
//     begin
//     sleep(200);
//     FastIVMeasuringComplex('d');
//     end;


//
//   if LEDWasOpened then
//      begin
//      LEDOpenPinChanger.PinChangeToHigh;
//      sleep(500);
//      LEDOpenPinChanger.PinChangeToHigh;
//      end;


//______________________________________
//   if not(assigned(TemperatureMeasuringThread)) then
//         TemperatureThreadCreate();
//----------------------------------------


  end                        else    //  if IscVocOnTimeModeIsFastIV then
  begin

   if Voc_MD.ActiveInterface.Name<>'Simulation'
      then
        begin
         IscVocPin_toVoc();

         TDependence.tempIChange(Voc_MD.ActiveInterface.GetData);
          if ForwLine.Count>0 then
            if abs(TDependence.tempI- ForwLine.YValue[ForwLine.Count-1])>abs(0.1*ForwLine.YValue[ForwLine.Count-1])
           then  TDependence.tempIChange(Voc_MD.ActiveInterface.GetData);

//          TFastDependence.tempVChange(SecondFromDayBegining(Now()));
        end;

//   LADVoltageValue.Caption:=FloatToStrF(TDependence.tempI,ffExponent, 4, 3);
  end;

  TFastDependence.tempVChange(SecondFromDayBegining(Now()));
  LADCurrentValue.Caption:=FloatToStrF(TDependence.tempV,ffExponent, 4, 3);

  LADVoltageValue.Caption:=FloatToStrF(TDependence.tempI,ffExponent, 4, 3);

  VolCorrectionNew.Add(Temperature_MD.ActiveInterface.Value,
                         TDependence.tempI);

end;

procedure TIVchar.IscVocOnTimeHookSecondMeas;
begin

 if not(IscVocOnTimeModeIsFastIV) then
  begin
   if Voc_MD.ActiveInterface.Name<>'Simulation'
     then IscVocPin_toIsc();

     TTimeTwoDependenceTimer.SecondValueChange(abs(Isc_MD.ActiveInterface.GetData));
      if ForwLg.Count>0 then
        if abs(TTimeTwoDependenceTimer.SecondValue - ForwLg.YValue[ForwLg.Count-1])>abs(0.1*ForwLg.YValue[ForwLg.Count-1])
       then  TTimeTwoDependenceTimer.SecondValueChange(abs(Isc_MD.ActiveInterface.GetData));

//     LADInputVoltageValue.Caption:=FloatToStrF(TTimeTwoDependenceTimer.SecondValue,ffExponent, 4, 3);

    if Voc_MD.ActiveInterface.Name='Simulation'
        then TDependence.tempIChange(Temperature_MD.ActiveInterface.Value);
//        else VolCorrectionNew.Add(Temperature_MD.ActiveInterface.Value,
//                                  Voc_MD.ActiveInterface.Value);




     IscVocOnTime.SecondMeasurementTime:=SecondFromDayBegining(Now());



//     TimeDHookSecondMeas;
//     MeasurementTimeParameterDetermination(IscVocOnTime);


  end;

 LADInputVoltageValue.Caption:=FloatToStrF(TTimeTwoDependenceTimer.SecondValue,ffExponent, 4, 3);
 MeasurementTimeParameterDetermination(IscVocOnTime);
//гасимо діод
 LED_OffIfCondition();
//закриваємо заслонку
 LEDCloseIfCondition();


 if IscVocOnTimeModeIsFastIV then //Exit;
  begin
   IscVocOnTime.SecondMeasurementTime:=TFastDependence.tempV;

   if (CBtimeDarkIV.Checked)and((CBLEDOpenAuto.Checked)or(CBLEDAuto.Checked))
     then
     begin
     sleep(200);
     FastIVMeasuringComplex('d');
     end;

   if not(assigned(TemperatureMeasuringThread)) then
         TemperatureThreadCreate();
  end;

end;

procedure TIVchar.IVCharCurrentMeasHook;
 var
  AtempNumber:byte;
begin
  AtempNumber := 0;
  repeat
   if not(IVCharCurrentMeasuring()) then Exit;

   if (IVResult.IsEmpty) then Break;

   if (ItIsBegining)or(IVCurrentGrowth()) then Break;

   inc(AtempNumber);
  until (AtempNumber>AtempNumbermax);

  if (CBCurrentValue.Checked and (abs(IVMeasResult.CurrentMeasured)>=Imax)) then
   TIVParameters.VoltageInputChange(Vmax);
end;

function TIVchar.IVCharCurrentMeasuring(): boolean;
 var Current: double;
begin
 Result:=False;
 Application.ProcessMessages;
 if TIVParameters.IVMeasuringToStop then Exit;

 Current := Current_MD.GetMeasurementResult();

 if Current=ErResult then
  begin
   TDependence.tempIChange(Current);
   Exit;
  end;

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

 MaxDifCoeficient:=1;

 IVVoltageInputSignDetermine;

 IVMRFilling();

 newCorrection:=ErResult;

 if CBPC.Checked
   then newCorrection:=VolCorrection.Yvalue(VoltageInputSign);
 if (newCorrection=ErResult)
   then newCorrection:=IVForeseeCorrection;

 TIVParameters.VoltageCorrectionChange(newCorrection);

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
  if TIVParameters.IVMeasuringToStop then Exit;
  TDependence.tempIChange(DACR2R_MD.GetMeasurementResult());
//  if TDependence.tempI=ErResult then TDependence.tempIChange(0);

  LADCurrentValue.Caption:=FloatToStrF(TDependence.tempI,ffFixed, 6, 4);
end;

procedure TIVchar.CalibrHookSetVoltage;
begin
 LADInputVoltageValue.Caption:=FloatToStrF(TIVParameters.VoltageInputReal,ffFixed, 6, 4);
// SettingDevice.SetValueCalibr(TIVDependence.VoltageInputReal);
 DACR2R.OutputCalibr(TIVParameters.VoltageInputReal);
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
 Key:=CBMeasurements.Items[CBMeasurements.ItemIndex];
 RevLine.Clear;
 RevLg.Clear;

 if (Key=MeasR2RCalib)
     or(Key=MeasIV)
     or(Key=MeasFastIV)
     or(Key=MeasFastIVArd)
     then
      begin
       LADRange.Visible:=True;
       RangeShow(Sender);
       if (Key=MeasFastIV)or(Key=MeasFastIVArd) then
          MeasurementsLabelCaption(['Voltage', 'Current', ''])
                         else
          MeasurementsLabelCaptionDefault;
      end
     else LADRange.Visible:=False;


 if (Key=MeasTimeD)
    or(Key=MeasControlParametr)
     then MeasurementsLabelCaption(['Value', 'Time', '']);

 if Key=MeasTwoTimeD
     then
      if TimeTwoDependenceTimer.isTwoValueOnTime
        then MeasurementsLabelCaption(['1-st value', 'Time', '2-nd value'])
        else MeasurementsLabelCaption(['1-st value', '2-nd value', '']);

 if Key=MeasIscAndVocOnTime
     then MeasurementsLabelCaption(['Voc', 'Time', 'Isc']);

 if Key=MeasTempOnTime
     then MeasurementsLabelCaption(['T (K)', 'Time', '']);

 if Key=MeasIVonTemper
     then MeasurementsLabelCaption(['Voc', 'T (K)', 'isotermal time']);

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
//  ET1255isPresent:=true;
  if ET1255isPresent then
   begin
     for I := Low(TET1255_DAC_ChanelNumber) to High(TET1255_DAC_ChanelNumber) do
       begin
        ET1255_DACs[i]:=TET1255_DAC.Create(i);
        ET1255_DACs[i].Reset();
        AnyObjectArray.Add(ET1255_DACs[i]);
       end;
     ET1255_DACsShow[0]:=TDAC_Show.Create(ET1255_DACs[0],
                    STOV1255ch0,STOK1255Ch0,
                    LOV1255ch0,LOK1255Ch0,
                    BOVset1255Ch0,BOKset1255Ch0,BReset1255Ch0);
     ET1255_DACsShow[1]:=TDAC_Show.Create(ET1255_DACs[1],
                    STOV1255ch1,STOK1255Ch1,
                    LOV1255ch1,LOK1255Ch1,
                    BOVset1255Ch1,BOKset1255Ch1,BReset1255Ch1);
     ET1255_DACsShow[2]:=TDAC_Show.Create(ET1255_DACs[2],
                    STOV1255ch2,STOK1255Ch2,
                    LOV1255ch2,LOK1255Ch2,
                    BOVset1255Ch2,BOKset1255Ch2,BReset1255Ch2);
     ET1255_DACsShow[3]:=TDAC_Show.Create(ET1255_DACs[3],
                    STOV1255ch3,STOK1255Ch3,
                    LOV1255ch3,LOK1255Ch3,
                    BOVset1255Ch3,BOKset1255Ch3,BReset1255Ch3);

      ShowArray.Add([ET1255_DACsShow[0],ET1255_DACsShow[1],
                     ET1255_DACsShow[2],ET1255_DACsShow[3]]);


      ET1255_ADCModule:=TET1255_ModuleAndChan.Create;
      ET1255_ADCModule.ReadFromIniFile(ConfigFile);
      ET1255_ADCShow:=TET1255_ADCShow.Create(ET1255_ADCModule,
         RGET1255_MM, RGET1255Range, LET1255I, LET1255U, BET1255Meas,
         SBET1255Auto, Time, SEET1255_Gain, SEET1255_MN,
         CBET1255_SM, CBET1255_ASer,CBET1255_AG, PointET1255);

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
  if TIVParameters.ItIsForward then
    begin
      if TIVParameters.VoltageInput>1
        then Result:=10*ForVoltagePrecisionCS.Data
        else Result:=ForVoltagePrecisionCS.Data;
    end                               else
    begin
      if TIVParameters.VoltageInput>1
        then Result:=10*RevVoltagePrecisionCS.Data
        else Result:=RevVoltagePrecisionCS.Data;
    end;
  Result:=Result*MaxDifCoeficient;
end;


procedure TIVchar.IVCharVoltageMeasHook;
  var
    NewCorrection,Factor:double;
begin

  Application.ProcessMessages;
  if TIVParameters.IVMeasuringToStop then Exit;

  if not(IVCharVoltageMeasuring()) then Exit;


  if IVCorrecrionNeeded() then
   begin
    TIVParameters.SecondMeasIsDoneChange(False);


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
         TIVParameters.VoltageCorrectionChange(TIVParameters.VoltageCorrection+0.2);
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

    NewCorrection:=TIVParameters.VoltageCorrection-
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


   if (NewCorrection=ErResult)
      or(abs(NewCorrection-IVMeasResult.Correction)<1e-4)
      or(abs(NewCorrection)>3)
    then NewCorrection:=TIVParameters.VoltageCorrection-
                     Factor*IVMeasResult.DeltaToExpected;


    CorrectionLimit(NewCorrection);

    TIVParameters.VoltageCorrectionChange(NewCorrection);
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
   if TIVParameters.ItIsForward then
       Result:=IVMeasResult.CurrentMeasured>IVResult.Y[IVResult.HighNumber]
                                else
       Result:=IVMeasResult.CurrentMeasured<IVResult.Y[IVResult.HighNumber]
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

 if IVResult.IsEmpty then Exit;


 if (VoltageInputSign*IVResult.X[IVResult.HighNumber]<0) then Exit;
 IVMeasResult.isEmpty:=False;


 if (IVResult.Count<2) then Exit;
 if (VoltageInputSign*IVResult.X[IVResult.Count-2]<0) then Exit;

 IVMRFirst.VoltageMeasured:=IVResult.X[IVResult.Count-2];
 IVMRFirst.CurrentMeasured:=IVResult.Y[IVResult.Count-2];
 IVMRFirst.DeltaToExpected:=ErResult;
 try
 IVMRFirst.Correction:=VolCorrectionNew.Y[VolCorrectionNew.Count-2];
 finally

 end;
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
 Result:=IVMeasResult.Rpribor;
end;

procedure TIVchar.IVSavedCorrectionSet;
begin
 TIVParameters.VoltageCorrectionChange(VolCorrection.Yvalue(VoltageInputSign))
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
  TIVParameters.DelayTimeChange(800);
end;

procedure TIVchar.CalibrHookDataSave;
 var tempdir:string;
     tempVec:TVector;
begin
  if TDependence.PointNumber=0 then Exit;
  if (TDependence.PointNumber mod 1000)<>0 then Exit;
    tempVec:=TVector.Create;
    IVResult.CopyTo(tempVec);
    tempdir:=GetCurrentDir;
    ChDir(ExtractFilePath(Application.ExeName));
    DACR2R.SaveFileWithCalibrData(tempVec);
    ChDir(tempdir);
    tempVec.Free;
end;


procedure TIVchar.CalibrHookFirstMeas;
begin
  Application.ProcessMessages;;
  if TIVParameters.IVMeasuringToStop then Exit;

  TDependence.tempVChange(TIVParameters.VoltageInputReal);
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

  if (TIVParameters.VoltageInput=0)
   then  ItIsDarkIV:=(TDependence.tempI>-1e-5)
  else
   if TDependence.tempI>0 then  ItIsDarkIV:=True;



  if ItIsBegining then ItIsBegining:=not(ItIsBegining);
  VolCorrectionNew.Add(VoltageInputSign,TIVParameters.VoltageCorrection);

end;

procedure TIVchar.HookEnd;
begin
  DecimalSeparator:='.';

  CBMeasurements.Enabled:=True;
  BIVStart.Enabled := True;
  BConnect.Enabled := True;
  BParamReceive.Enabled := True;
  if IVResult.HighNumber > 0 then
  begin
    BIVSave.Enabled := True;
    BIVSave.Font.Style := BIVSave.Font.Style - [fsStrikeOut];
  end;

end;

procedure TIVchar.ActionInSaveButton(Sender: TObject);
begin

  if Key=MeasR2RCalib then
  begin
    CalibrSaveClick(Sender);
    Exit;
  end;

  if Key=MeasIV then
  begin
    VolCorrectionNew.Sorting;
    VolCorrectionNew.DeleteDuplicate;
    VolCorrectionNew.CopyTo(VolCorrection);
  end;

  SaveDialogPrepare;
  if SaveDialog.Execute then
   begin

    if (Key=MeasIV)
                 then SaveIVMeasurementResults(SaveDialog.FileName,IVResult);

    if (Key=MeasTimeD)or(Key=MeasControlParametr)
        or(Key=MeasTempOnTime)or(Key=MeasIVonTemper)
      then IVResult.WriteToFile(SaveDialog.FileName,9);

    if Key=MeasTwoTimeD then
     begin
       if TimeTwoDependenceTimer.isTwoValueOnTime
          then ToFileFromTwoSeries(SaveDialog.FileName,ForwLine,ForwLg,6)
          else IVResult.WriteToFile(SaveDialog.FileName,9);
     end;

    if (Key=MeasIscAndVocOnTime) then
      begin
      ToFileFromTwoSeries(SaveDialog.FileName,ForwLine,ForwLg,6);
      ToFileFromTwoVector(copy(SaveDialog.FileName,1,Length(SaveDialog.FileName)-4)+'a.dat',
         IVResult,VolCorrectionNew,9);
      end;

     BIVSave.Font.Style:=BIVSave.Font.Style+[fsStrikeOut];
   end;
end;

procedure TIVchar.ActionInSaveButtonFastIV(Sender: TObject);
begin
  SaveDialog.FileName:=CustomFastIVMeas.DatFileNameToSave;
  SaveDialog.Title := 'Last file - ' +
      LastDATFileName(CustomFastIVMeas.PrefixToFileName) + '.dat';
  SaveDialog.InitialDir := GetCurrentDir;

  if SaveDialog.Execute then
   begin
     SaveIVMeasurementResults(SaveDialog.FileName,CustomFastIVMeas.Results);
     BIVSave.Font.Style:=BIVSave.Font.Style+[fsStrikeOut];
   end;


//  SaveDialog.FileName:=FastIVMeasuring.DatFileNameToSave;
//  SaveDialog.Title := 'Last file - ' +
//      LastDATFileName(FastIVMeasuring.PrefixToFileName) + '.dat';
//  SaveDialog.InitialDir := GetCurrentDir;
//
//  if SaveDialog.Execute then
//   begin
//     SaveIVMeasurementResults(SaveDialog.FileName,FastIVMeasuring.Results);
//     BIVSave.Font.Style:=BIVSave.Font.Style+[fsStrikeOut];
//   end;
end;

procedure TIVchar.ADS1115Create;
// var i:TADS1115_ChanelNumber;
begin
//  ADS11115module := TADS1115_Module.Create;
  ADS11115show := TI2C_PinsShow.Create(ADS11115module.Pins, Pads1115_adr, ADS1115_StartAdress,ADS1115_LastAdress);

//  for I := Low(TADS1115_ChanelNumber) to High(TADS1115_ChanelNumber) do
//    ADS11115_Channels[i] := TADS1115_Channel.Create(i, ADS11115module);

  ADS11115_ChannelShows[0]:=
     TADS1115_ChannelShow.Create(ADS11115_Channels[0], Pads1115_Ch1dr, Pads1115_Ch1gain, Lads1115_Ch1meas, Bads1115_Ch1meas);
  ADS11115_ChannelShows[1]:=
     TADS1115_ChannelShow.Create(ADS11115_Channels[1], Pads1115_Ch2dr, Pads1115_Ch2gain, Lads1115_Ch2meas, Bads1115_Ch2meas);
  ADS11115_ChannelShows[2]:=
     TADS1115_ChannelShow.Create(ADS11115_Channels[2], Pads1115_Ch3dr, Pads1115_Ch3gain, Lads1115_Ch3meas,  Bads1115_Ch3meas);

  ShowArray.Add([ADS11115show,ADS11115_ChannelShows[0],ADS11115_ChannelShows[1],ADS11115_ChannelShows[2]]);
  ArduinoMeters.Add(ADS11115module);
//  AnyObjectArray.Add([ADS11115module, ADS11115_Channels[0],ADS11115_Channels[1],ADS11115_Channels[2]]);
end;

procedure TIVchar.GDS_Create;
 var i:TGDS_Channel;
begin
  GDS_806S := TGDS_806S.Create(ComPortGDS);
  for I := Low(TGDS_Channel) to High(TGDS_Channel) do
      GDS_806S_Channel[i]:=TGDS_806S_Channel.Create(i,GDS_806S);

  GDS_806S_Show := TGDS_806S_Show.Create(GDS_806S,
                      GDS_806S_Channel,
                     [STGDS_Mode, STGDS_RLength, STGDS_AveNum, STGDS_ScaleGoriz,
                     STGDS_CoupleCh1, STGDS_ProbCh1, STGDS_MeasCh1, STGDS_ScaleCh1,
                     STGDS_CoupleCh2, STGDS_ProbCh2, STGDS_MeasCh2, STGDS_ScaleCh2,
                     STGDS_OffsetCh1, STGDS_OffsetCh2],
                     [LGDS_Mode, LGDS_RLength, LGDS_AveNum,
                     LGDS_OffsetCh1, LGDS_OffsetCh2],
                     [B_GDS_SetSet, B_GDS_SetGet, B_GDS_Test,
                     B_GDS_SetSav, B_GDS_SetLoad, B_GDS_SetAuto,
                     B_GDS_SetDef, B_GDS_Refresh, B_GDS_Run,
                     B_GDS_Stop, B_GDS_Unlock],
                     [CBGDS_InvertCh1, CBGDS_InvertCh2],
                     [CBGDS_DisplayCh1, CBGDS_DisplayCh2],
                     [LGDS_Ch1,LGDSU_Ch1,LGDS_Ch2,LGDSU_Ch2],
                     [B_GDS_MeasCh1,B_GDS_MeasCh2,B_GDS_MeasShow],
                     [SB_GDS_AutoCh1,SB_GDS_AutoCh2,SB_GDS_AutoShow],
                     [GDS_SeriesCh1,GDS_SeriesCh2],
                     PGGDS_Show);

  ShowArray.Add([GDS_806S_Show]);
  AnyObjectArray.Add([GDS_806S,GDS_806S_Channel[1],
                      GDS_806S_Channel[2]]);

end;

procedure TIVchar.SaveIVMeasurementResults(FileName: string; DataVector:TVector);
begin
//  DataVector.Sorting;
//  DataVector.DeleteDuplicate;
  DataVector.WriteToFile(FileName,5);
  //       ToFileFromTwoVector(SaveDialog.FileName,IVResult,VolCorrectionNew);
  LTLastValue.Caption := FloatToStrF(Temperature, ffFixed, 5, 2);
  SaveCommentsFile(FileName);
end;

procedure TIVchar.DACReset;
begin

  if (ComPort1.Connected) and (DACR2R.OutputValue <> 0) then
    DACR2R.Reset;
  if (ComPort1.Connected) and (D30_06.OutputValue <> 0) then
    D30_06.Reset;
  if (ComPort1.Connected) and (AD5752_chB.OutputValue <> 0) then
    AD5752_chB.Reset;
  if (ComPort1.Connected) and (AD5752_chA.OutputValue <> 0) then
    AD5752_chA.Reset;
  if (ComPort1.Connected) and (AD9833.Mode <> ad9833_mode_off) then
    AD9833.Reset;
end;

procedure TIVchar.FastIVMeasuringComplex(const FilePrefix: string);
begin
  FastIVMeasuring.Measuring(False, FilePrefix);
  if IVisBad(FastIVMeasuring.Results) then
  begin
    sleep(400);
    DeleteFile(LastDATFileName(FilePrefix) + '.dat');
    FastIVMeasuring.Measuring(False, FilePrefix);
  end;
   if (FastIVMeasuring.Results.Count=0)or
      ((FastIVMeasuring.Results.MaxX<IVCharRangeFor.HighValue)
       and(FastIVMeasuring.Results.MaxY<MaxCurrentCS.Data))
    then  ComPort1Reload();
//   HelpForMe(floattostr(FastIVMeasuring.Results.Count));
//   HelpForMe(floattostr(FastIVMeasuring.Results.MaxX));
//   HelpForMe(floattostr(IVCharRangeFor.HighValue));
//   HelpForMe(floattostr(FastIVMeasuring.Results.MaxY));
//   HelpForMe(floattostr(MaxCurrentCS.Data));

end;

procedure TIVchar.LED_OpenIfCondition;
begin
  if CBLEDOpenAuto.Checked then
  begin
    LEDOpenPinChanger.PinChangeToLow;
    sleep(500);
  end;
end;

procedure TIVchar.LEDCloseIfCondition;
begin
  //закриваємо заслінку
  if CBLEDOpenAuto.Checked then
  begin
    LEDOpenPinChanger.PinChangeToHigh;
    sleep(500);
    LEDOpenPinChanger.PinChangeToHigh;
  end;
end;

procedure TIVchar.LED_OnIfCondition(OrCondition:boolean=False);
begin
  if CBLEDAuto.Checked or OrCondition then
  begin
    SettingDeviceLED.ActiveInterface.Output(IledToVdac(LEDCurrentCS.Data));
    sleep(300);
  end;
end;

procedure TIVchar.LED_OffIfCondition(OrCondition:boolean=False);
begin
  if CBLEDAuto.Checked or OrCondition then
    SettingDeviceLED.ActiveInterface.Reset;
end;

procedure TIVchar.IscVocPin_toVoc;
begin
  IscVocPinChanger.PinChangeToLow;
  sleep(IscVocTimeToWait);
end;

procedure TIVchar.IscVocPin_toIsc;
begin
  IscVocPinChanger.PinChangeToHigh;
  sleep(IscVocTimeToWait);
end;

procedure TIVchar.BComReloadClick(Sender: TObject);
begin
  ComPort1Reload()
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
 ForwSteps.DeletePoint(SGFBStep.Row-1);
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
 if Key=MeasR2RCalib then CalibrMeasuring.Measuring;
 if Key=MeasIV then IVMeasuring.Measuring;
 if Key=MeasFastIV then FastIVMeasuring.Measuring;
 if Key=MeasFastIVArd then FastArduinoIV.Measuring;
 if Key=MeasTimeD then TimeDependence.BeginMeasuring;
 if Key=MeasTwoTimeD then TimeTwoDependenceTimer.BeginMeasuring;
 if Key=MeasIscAndVocOnTime then IscVocOnTime.BeginMeasuring;

 if (Key=MeasControlParametr)and (SBControlBegin.Down)
     then  ControlParameterTime.BeginMeasuring;
 if (Key=MeasTempOnTime)and (SBTAuto.Down)
     then  TemperatureOnTime.BeginMeasuring;
 if Key=MeasIVonTemper then IVcharOnTemperature.BeginMeasuring;

end;

procedure TIVchar.BParamReceiveClick(Sender: TObject);
begin
 PacketCreate([ParameterReceiveCommand]);
 PacketIsSend(ComPort1,'Parameter receiving is unsuccessful');
end;

procedure TIVchar.BRBDeleteClick(Sender: TObject);
begin
 if (SGRBStep.Row=(SGRBStep.RowCount-1))or(SGRBStep.Row<1) then Exit;
 RevSteps.DeletePoint(SGRBStep.Row-1);
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
                                      TemperatureMeasIntervalCS.Data);
     if  SBTAuto.Down then
      begin
       if assigned(TemperatureMeasuringThread) then
           begin
            TemperatureMeasuringThread.Terminate;
            sleep(500);
           end;
       TemperatureThreadCreate();
      end             else
      begin
        SBTAuto.Down:=True;
        TemperatureThreadCreate();
      end;
    end;
end;


procedure TIVchar.Button1Click(Sender: TObject);
//  var ByteAr:TArrByte;
//   var Vax:TVector;
begin
showmessage(inttostr(ForwLine.Count));

//  Vax:=TVector.Create;
//  Vax.ReadFromFile('D:\Samples\DeepL\Project\SC116_A\2020_10_09\dark70.dat');
//  showmessage(booltostr(IVisBad(Vax))+' true='+booltostr(true));
//  Vax.Free;

//   MCP3424.ValueToByteArray(0,ByteAr);
//   showmessage(ByteArrayToString(ByteAr));
//   MCP3424.ValueToByteArray(-0.5,ByteAr);
//   showmessage(ByteArrayToString(ByteAr));
//   MCP3424.ValueToByteArray(-1,ByteAr);
//   showmessage(ByteArrayToString(ByteAr));
//   MCP3424.ValueToByteArray(-2,ByteAr);
//   showmessage(ByteArrayToString(ByteAr));


//FastArduinoIV.Measuring;

//  showmessage(FloatTostr(FastIVMeasuring.RangeRev.HighValue));
// showmessage('$'+inttohex(($7F and byte(round(abs(-1.2)*10)))or $80,2));

// showmessage(ForwSteps.XYtoString+RevSteps.XYtoString);
//showmessage(inttostr(ShowTempDep.fToleranceCoef.Data));
//showmessage(inttostr(IVcharOnTemperature.StartTemperature));

//showmessage(inttostr(IVcharOnTemperature.ToleranceCoficient));

//showmessage(inttostr(CalibrateA[2,2,2]));
end;



procedure TIVchar.BWriteTMClick(Sender: TObject);
 var SR : TSearchRec;
     FF:TextFile;
begin
    AssignFile(FF,'comments.dat');
    if FindFirst('comments.dat',faAnyFile,SR)=0 then Append(FF) else ReWrite(FF);
    write(FF,'Time mark : ',inttostr(SecondFromDayBegining(Now())));
    writeln(FF);
    writeln(FF);
    CloseFile(FF);
end;

procedure TIVchar.BControlResetClick(Sender: TObject);
begin
 if SBControlBegin.Down then
    begin
    PID_Control.SetParametr(PID_Control_ParametersShow,
                            ControlIntervalCS.Data);
    ControlWatchDog.Enabled:=False;
    LControlWatchDog.Visible:=False;
    ControlWatchDog.Interval:=ControlIntervalCS.Data*2000;
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
   NumberPinsInput.Clear;
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
           NumberPinsInput.Add(IntToStr(Data[i]));
    end;
  end;
end;

procedure TIVchar.FastArduinoIVHookBegin;
begin
   FastIVHookBeginBase(FastArduinoIV);
end;

procedure TIVchar.FastArduinoIVHookEnd;
begin
  FastIVHookEndBase(FastArduinoIV);
end;

procedure TIVchar.FastIVHookBegin;
begin
  FastIVHookBeginBase(FastIVMeasuring);

//  if FastIVMeasuring.SingleMeasurement then
//    begin
//      CBMeasurements.Enabled:=False;
//      BIVStart.Enabled := False;
//      BConnect.Enabled := False;
//      BIVSave.Enabled:=False;
//      BParamReceive.Enabled := False;
//    end;
//
// ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
// FastIVMeasuring.Imax := MaxCurrentCS.Data;
// FastIVMeasuring.Imin := MinCurrentCS.Data;
// FastIVMeasuring.CurrentValueLimitEnable:=CBCurrentValue.Checked;
// FastIVMeasuring.DragonBackTime:=Dragon_backTimeCS.Data;
end;

procedure TIVchar.FastIVHookBeginBase(FastIVDep: TFastIVDependence);
begin
  if FastIVDep.SingleMeasurement then
    begin
      CBMeasurements.Enabled:=False;
      BIVStart.Enabled := False;
      BConnect.Enabled := False;
      BIVSave.Enabled:=False;
      BParamReceive.Enabled := False;
    end;

 ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
 FastIVDep.Imax := MaxCurrentCS.Data;
 FastIVDep.Imin := MinCurrentCS.Data;
 FastIVDep.CurrentValueLimitEnable:=CBCurrentValue.Checked;
 FastIVDep.DragonBackTime:=Dragon_backTimeCS.Data;
 FastIVDep.ToUseDragonBackTime:=CBuseDBT.Checked;
end;

procedure TIVchar.FastIVHookEnd;
begin
 FastIVHookEndBase(FastIVMeasuring);

//  DecimalSeparator:='.';
// if FastIVMeasuring.SingleMeasurement then
//    begin
//      CBMeasurements.Enabled:=True;
//      BIVStart.Enabled := True;
//      BConnect.Enabled := True;
//      BParamReceive.Enabled := True;
//      if FastIVMeasuring.Results.HighNumber > 0 then
//      begin
//        BIVSave.Enabled := True;
//        BIVSave.Font.Style := BIVSave.Font.Style - [fsStrikeOut];
//      end;
//    end;
//
//  if (SBTAuto.Down)and
//     (Temperature_MD.ActiveInterface.NewData) then
//      begin
//       Temperature:=Temperature_MD.ActiveInterface.Value;
////       Temperature_MD.ActiveInterface.NewData:=False;
//      end                                     else
//       Temperature:=Temperature_MD.GetMeasurementResult();
//  if Temperature=ErResult
//    then  Temperature:=Temperature_MD.GetMeasurementResult();
//
//
// if FastIVMeasuring.SingleMeasurement
//    then BIVSave.OnClick:=ActionInSaveButtonFastIV
//    else SaveIVMeasurementResults(FastIVMeasuring.DatFileNameToSave,FastIVMeasuring.Results)

end;

procedure TIVchar.FastIVHookEndBase(FastIVDep: TFastIVDependence);
begin
  DecimalSeparator:='.';
 if FastIVDep.SingleMeasurement then
    begin
      CBMeasurements.Enabled:=True;
      BIVStart.Enabled := True;
      BConnect.Enabled := True;
      BParamReceive.Enabled := True;
      if FastIVDep.Results.HighNumber > 0 then
      begin
        BIVSave.Enabled := True;
        BIVSave.Font.Style := BIVSave.Font.Style - [fsStrikeOut];
      end;
    end;

  if (SBTAuto.Down)and
     (Temperature_MD.ActiveInterface.NewData) then
      begin
       Temperature:=Temperature_MD.ActiveInterface.Value;
      end                                     else
       Temperature:=Temperature_MD.GetMeasurementResult();
  if Temperature=ErResult
    then  Temperature:=Temperature_MD.GetMeasurementResult();

 CustomFastIVMeas:=FastIVDep;
 if FastIVDep.SingleMeasurement
    then BIVSave.OnClick:=ActionInSaveButtonFastIV
    else SaveIVMeasurementResults(FastIVDep.DatFileNameToSave,FastIVDep.Results)

end;

procedure TIVchar.FormCreate(Sender: TObject);
var
  I: Integer;
begin
 DecimalSeparator:='.';
 ComponentView();

 ConfigFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'IVChar.ini');
 ShowArray:=TObjectArray.Create;
 AnyObjectArray:=TObjectArray.Create;
 ArduinoMeters:=TObjectArray.Create;
 NumberPins:=TStringList.Create;
 NumberPinsOneWire:=TStringList.Create;
 NumberPinsInput:=TStringList.Create;
 PinsFromIniFile();

 VoltmetrsCreate();
 ET1255Create();
 VectorsCreate();

 ConstantShowCreate();

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
 ShowArray.ReadFromIniFile(ConfigFile);
 TemperatureMeasIntervalCS.ReadFromIniFile(ConfigFile);

 if FreeTest then TestVarCreate;


 ComPortsBegining;


// RS232_MediatorTread:=TRS232_MediatorTread.Create(ComPort1,
//                 [INA226_Module,ADS11115module,HTU21D,
//                 DACR2R,V721A,V721_I,V721_II,DS18B20,
//                 TMP102,
//                 MLX90615,
//                 D30_06,IscVocPinChanger,LEDOpenPinChanger,
//                 MCP3424,AD9833,STS21,ADT74x0,MCP9808]);
 ArduinoSenders:=TArrIArduinoSender.Create([INA226_Module,ADS11115module,HTU21D,
                 DACR2R,V721A,V721_I,V721_II,DS18B20,
                 TMP102,
                 MLX90615,
                 D30_06,IscVocPinChanger,LEDOpenPinChanger,
                 MCP3424,AD9833,STS21,ADT74x0,MCP9808,
                 AD5752_Modul,FastArduinoIV.ArduinoCommunication]);

 AnyObjectArray.Add(ArduinoSenders);
 RS232_MediatorTread:=TRS232_MediatorTread.Create(ComPort1,ArduinoSenders);

  ArduinoDataSubject:=TArduinoDataSubject.Create(ComPort1);

  for I := 0 to ArduinoMeters.HighIndex do
    (ArduinoMeters[i] as TArduinoMeter).AddDataSubject(ArduinoDataSubject);


 if (ComPort1.Connected)and(SettingDevice.ActiveInterface.Name=DACR2R.Name) then SettingDevice.Reset();

  if (ComPort1.Connected) then D30_06.Reset;

end;

procedure TIVchar.FormDestroy(Sender: TObject);
begin

 if SBTAuto.Down then TemperatureMeasuringThread.Terminate;
 if SBControlBegin.Down then ControllerThread.Terminate;

 if assigned(DependTimer) then DependTimer.Free;

 DACReset;

 ConfigFile.EraseSection(DoubleConstantSection);
 PinsWriteToIniFile;
 SettingWriteToIniFile();


 if FreeTest then TestVarFree
             else
             begin
 TemperatureMeasIntervalCS.WriteToIniFile(ConfigFile);
// TemperatureMeasIntervalCS.Free;
 ShowArray.WriteToIniFileAndFree(ConfigFile);



// DACFree();
 ObjectsFree();
             end;
  ConfigFile.Free;

 ShowArray.Free;
 AnyObjectArray.Free;
 ArduinoMeters.Free;

  if RS232_MediatorTread <> nil
   then RS232_MediatorTread.Terminate;

 VectorsDispose();

 NumberPins.Free;
 NumberPinsOneWire.Free;
 NumberPinsInput.Free;

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
           STTermostatKp,STTermostatKi,STTermostatKd,
           STTermostatNT,STTermostatTolerance,
           STTermostatOVmax,STTermostatOVmin,
           LTermostatKp,LTermostatKi,LTermostatKd,
           LTermostatNT,LTermostatTolerance,
           LTermostatOVmax,LTermostatOVmin,
           BTermostatLoad);

  PID_Control_ParametersShow:=
   TPID_ParametersShow.Create('PIDControl',
           STControlKp,STControlKi,STControlKd,
           STControlNV,STControlTolerance,
           STControlOVmax,STControlOVmin,
           LControlKp,LControlKi,LControlKd,
           LControlNV,LControlTolerance,
           LControlOVmax,LControlOVmin);

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
  Dependence.Duration := MeasurementDurationCS.Data;
  Dependence.Interval := MeasurementIntervalCS.Data;
  SBIVPause.Enabled:=True;
  SBIVPause.OnClick:=Dependence.SpBattonClick;
end;

procedure TIVchar.ComPort1Reload;
 var i:integer;
begin
// DACReset;
 ComPortsWriteSettings([ComPort1]);
 FreeAndNil(ArduinoDataSubject);
 if RS232_MediatorTread <> nil
   then RS232_MediatorTread.Terminate;
 ComPortsEnding([ComPort1]);
 FreeAndNil(ComPort1);

 ComPort1:=TComPort.Create(IVchar);
 ComPort1.Name:='ComPort1';
 ComPortsLoadSettings([ComPort1]);
 ComCBBR.ComPort:=ComPort1;
 ComCBPort.ComPort:=ComPort1;
 ComCBBR.UpdateSettings;
 ComCBPort.UpdateSettings;
 ComDPacket.ComPort := ComPort1;
 PortBeginAction(ComPort1, LConnected, BConnect);
 RS232_MediatorTread:=TRS232_MediatorTread.Create(ComPort1,ArduinoSenders);
 ArduinoDataSubject:=TArduinoDataSubject.Create(ComPort1);
  for I := 0 to ArduinoMeters.HighIndex do
    (ArduinoMeters[i] as TArduinoMeter).AddDataSubject(ArduinoDataSubject);

 if (ComPort1.Connected)and(SettingDevice.ActiveInterface.Name=DACR2R.Name) then SettingDevice.Reset();

end;

procedure TIVchar.ComPortsBegining;
begin
  ComPortsLoadSettings([ComPortUT70C,ComPortUT70B,ComPort1,ComPortGDS]);
  ComCBUT70CPort.UpdateSettings;
  ComCBUT70BPort.UpdateSettings;
  ComCBBR.UpdateSettings;
  ComCBPort.UpdateSettings;
  ComCBGDS_Port.UpdateSettings;
  ComCBGDS_Baud.UpdateSettings;
  ComCBGDS_Stop.UpdateSettings;
  ComCBGDS_Parity.UpdateSettings;

  ComDPacket.StartString := PacketBeginChar;
  ComDPacket.StopString := PacketEndChar;
  ComDPacket.ComPort := ComPort1;

//to comment on some PC
 if GetHDDSerialNumber=1576840464 then
  begin
  PortBeginAction(ComPortUT70B, LUT70BPort, nil);
  PortBeginAction(ComPortUT70C, LUT70CPort, nil);
  end;
//---------------

  PortBeginAction(ComPortGDS, LGDSPort, nil);

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
  VolCorrection.ReadFromIniFile(ConfigFile, 'Step', 'Correction');
  VolCorrection.DeleteErResult;
  VolCorrection.Sorting;
end;

function TIVchar.StepDetermine(Voltage: Double;
                              ItForward: Boolean): double;
var
  Steps: TVector;
  I: Integer;
begin
  Result := StepDefault;
  if ItForward then
    Steps := ForwSteps
  else
    Steps := RevSteps;
  for I := 0 to Steps.HighNumber do
    if abs(Voltage) < Steps.X[i] then
    begin
      Result := Steps.Y[i];
      Break;
    end;
end;

procedure TIVchar.StepReadFromIniFile(A:TVector; Ident:string);
begin
  A.ReadFromIniFile(ConfigFile, 'Step', Ident);
  A.DeleteErResult;
  A.DeleteDuplicate;
  A.Sorting;
  while (A.Count > 0) and (A.X[A.HighNumber] > Vmax) do
    A.DeletePoint(A.HighNumber);
  while (A.Count > 0) and (A.X[0] < 0) do
    A.DeletePoint(A.HighNumber);
  if (A.Count > 0) and not(IsEqual(A.X[A.HighNumber],Vmax))
   then A.Add(Vmax,StepDefault);
  if A.IsEmpty then  A.Add(Vmax,StepDefault);
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
  SGFBStep.RowCount := ForwSteps.Count + 1;
  for I := 0 to ForwSteps.HighNumber do
   begin
     SGFBStep.Cells[0,i+1]:=FloatToStrF(ForwSteps.X[i],ffGeneral,2,1);
     SGFBStep.Cells[1,i+1]:=FloatToStrF(ForwSteps.Y[i],ffGeneral,4,3);
   end;
end;

procedure TIVchar.RevStepShow;
 var
  I: Integer;
begin
  SGRBStep.RowCount := RevSteps.Count + 1;
  for I := 0 to RevSteps.HighNumber do
   begin
     SGRBStep.Cells[0,i+1]:=FloatToStrF(-RevSteps.X[i],ffGeneral,2,1);
     SGRBStep.Cells[1,i+1]:=FloatToStrF(RevSteps.Y[i],ffGeneral,3,2);
   end;
end;


procedure TIVchar.RGIscVocModeClick(Sender: TObject);
begin
  if Pos('IV', RGIscVocMode.Items[RGIscVocMode.ItemIndex])>0 then
   begin
     CBIscMD.Enabled:=False;
     CBVocMD.Enabled:=False;
     BIscMeasure.Enabled:=False;
     BVocMeasure.Enabled:=False;
     BIscVocPinChange.Enabled:=False;
     STControlIsc.Enabled:=False;
     IscVocOnTimeModeIsFastIV:=True;
   end                   else
   begin
     CBIscMD.Enabled:=True;
     CBVocMD.Enabled:=True;
     BIscMeasure.Enabled:=True;
     BVocMeasure.Enabled:=True;
     BIscVocPinChange.Enabled:=True;
     STControlIsc.Enabled:=True;
     IscVocOnTimeModeIsFastIV:=False;
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
  RGIscVocMode.ItemIndex:= ConfigFile.ReadInteger('Box', RGIscVocMode.Name,0);

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
  WriteIniDef(ConfigFile, 'Box', RGIscVocMode.Name, RGIscVocMode.ItemIndex);
end;


procedure TIVchar.VectorsCreate;
begin
  ForwSteps:=TVector.Create;
  RevSteps:=TVector.Create;
  IVResult:=TVector.Create;
  VolCorrection:=TVector.Create;
  VolCorrectionNew:=TVector.Create;
  TemperData:=TVector.Create;
end;

procedure TIVchar.VectorsDispose;
begin
  ForwSteps.Free;
  RevSteps.Free;
  IVResult.Free;
  VolCorrection.Free;
  VolCorrectionNew.Free;
  TemperData.Free;
end;


procedure TIVchar.SBControlBeginClick(Sender: TObject);
begin
 if SBControlBegin.Down then
    begin
    PID_Control:=TPID.Create(PID_Control_ParametersShow,
                             ControlIntervalCS.Data);
    ControllerThreadCreate();
    ControlWatchDog.Interval:=ControlIntervalCS.Data*2000;
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



procedure TIVchar.SBLEDTurnClick(Sender: TObject);
begin
 if SBLEDTurn.Down then
    begin
      SettingDeviceLED.ActiveInterface.Output(IledToVdac(LEDCurrentCS.Data));
      SBLEDTurn.Caption:='LED off';
    end            else
    begin
      SettingDeviceLED.ActiveInterface.Reset;
      SBLEDTurn.Caption:='LED on';
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
      SettingTermostat.ActiveInterface.Reset;
      end;
    IsPID_Termostat_Created:=False;
    end;
end;

procedure TIVchar.SettingWriteToIniFile;
begin
  StepsWriteToIniFile;
  DelayTimeWriteToIniFile;
  BoxToIniFile;
  ComPortsWriteSettings([ComPortUT70C,ComPortUT70B,ComPort1,ComPortGDS]);
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
                                       TemperatureMeasIntervalCS.Data,
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

    if IscVocOnTimeIsRun and IscVocOnTimeModeIsFastIV
    then
    else
     begin
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
     end;

    end
  else
    begin
    LTermostatWatchDog.Visible:=False;
    BTermostatResetClick(Sender);
    end;

//  TermostatWatchDog.Interval:=round(StrToFloat(STTMI.Caption))*2000;
  TermostatWatchDog.Interval:=TemperatureMeasIntervalCS.Data*2000;

  Temperature_MD.ActiveInterface.NewData:=False;
end;

procedure TIVchar.TestVarCreate;
begin
 TestVar:=TINA226_Module.Create('INA226');;
 TestVar2:=TINA226_Channel.Create(ina_mBus,(TestVar as TINA226_Module));
 SetLength(TestVar4,1);
// EnlargeIMeasArray(TestVar4,[TestVar2]);
 Pointer(TestVar4[0]):=Pointer(TestVar2);
// TestVar3:=TMeasuringDevice.Create(TestVar4, CBCMD,'Current', LADCurrentValue, srCurrent);

end;

procedure TIVchar.TestVarFree;
begin
 TestVar3.Free;

 TestVar2.Free;
 TestVar.Free;
end;

procedure TIVchar.VoltmetrsCreate;
begin
  INA226Create();
  ADS1115Create();

//  V721A := TV721A.Create('B7-21A');
//  V721_I := TV721.Create('B7-21 (1)');
//  V721_II := TV721.Create('B7-21 (2)');
////  V721_II := TV721_Brak.Create(ComPort1, 'B7-21 (2)');
  ArduinoMeters.Add([V721A,V721_I,V721_II]);
//  SetLength(VoltmetrShows,3);
  VoltmetrShows[0]:= TVoltmetrShow.Create(V721A, RGV721A_MM, RGV721ARange, LV721A, LV721AU, PV721APin, PV721APinG, {BV721ASet, BV721ASetGate, }BV721AMeas, SBV721AAuto, NumberPins{CBV721A}, Time);
  VoltmetrShows[1]:= TVoltmetrShow.Create(V721_I, RGV721I_MM, RGV721IRange, LV721I, LV721IU, PV721IPin, PV721IPinG, {BV721ISet, BV721ISetGate,} BV721IMeas, SBV721IAuto, NumberPins{CBV721I}, Time);
  VoltmetrShows[2]:= TVoltmetrShow.Create(V721_II, RGV721II_MM, RGV721IIRange, LV721II, LV721IIU, PV721IIPin, PV721IIPinG, {BV721IISet, BV721IISetGate,} BV721IIMeas, SBV721IIAuto, NumberPins, Time);

//  DS18B20:=TDS18B20.Create('DS18B20');
  DS18B20show:=TOnePinsShow.Create(DS18B20.Pins,PDS18BPin,NumberPinsOneWire);


//  TMP102:=TTMP102.Create;
  TMP102show:=TI2C_PinsShow.Create(TMP102.Pins,PTMP102Pin, TMP102_StartAdress,TMP102_LastAdress);

//  MLX90615:=TMLX90615.Create('MLX90615');

//  ADT74x0:=TADT74x0.Create;
  ADT74x0show:=TI2C_PinsShow.Create(ADT74x0.Pins,PADT74Pin, ADT74x0_StartAdress,ADT74x0_LastAdress);

//  MCP9808:=TMCP9808.Create;
  MCP9808show:=TI2C_PinsShow.Create(MCP9808.Pins,PMCP9808Pin, MCP9808_StartAdress,MCP9808_LastAdress);

//  HTU21D:=THTU21D.Create('HTU21D');
//  STS21:=TSTS21.Create('STS21');


//  ThermoCuple:=TThermoCuple.Create;
//  AnyObjectArray.Add(ThermoCuple);

  LEDOpenPinChanger:=TArduinoPinChanger.Create('LEDOpenPin');
  LEDOpenPinChangerShow:=TArduinoPinChangerShow.Create(LEDOpenPinChanger,PLEDOpenPin,BLEDOpenPinChange,NumberPins,'to close','to open');

  IscVocPinChanger:=TArduinoPinChanger.Create('IscVocPin');
  IscVocPinChangerShow:=TArduinoPinChangerShow.Create(IscVocPinChanger,PIscVocPin,BIscVocPinChange,NumberPins,'change to short current','change to open circuit');

  ShowArray.Add([VoltmetrShows[0],VoltmetrShows[1],VoltmetrShows[2]]);
  ShowArray.Add([DS18B20show,TMP102show, ADT74x0show,MCP9808Show,
                IscVocPinChangerShow,LEDOpenPinChangerShow]);

//  AnyObjectArray.Add([V721A,V721_I,V721_II]);
  AnyObjectArray.Add([{DS18B20,{TMP102,HTU21D,MLX90615,
                      {STS21,ADT74x0,
                      {MCP9808,}
                      IscVocPinChanger,LEDOpenPinChanger]);

  ArduinoMeters.Add([DS18B20,HTU21D,STS21,MLX90615,TMP102,
                     ADT74x0,MCP9808]);

  MCP3424Create();


  UT70B:=TUT70B.Create(ComPortUT70B);
  UT70BShow:= TUT70BShow.Create(UT70B, RGUT70B_MM, RGUT70B_Range, RGUT70B_RangeM, LUT70B, LUT70BU, BUT70BMeas, SBUT70BAuto, Time);
  UT70C:=TUT70C.Create(ComPortUT70C);
  UT70CShow:= TUT70CShow.Create(UT70C, RGUT70C_MM,
       RGUT70C_Range, RGUT70C_RangeM, LUT70C, LUT70CU,
       BUT70CMeas, SBUT70CAuto, Time,
       LUT70C_Hold,LUT70C_rec,LUT70C_AvTime,LUT70C_AVG);

  ShowArray.Add([UT70BShow,UT70CShow]);
  AnyObjectArray.Add([UT70B,UT70C]);

  GDS_Create();

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
                                         TemperatureMeasIntervalCS.Data
                                         );
              PID_Termostat.FileSave:='ts';
              IsPID_Termostat_Created:=True;
              TermostatWatchDog.Interval:=TemperatureMeasIntervalCS.Data*2000;
              TermostatWatchDog.Enabled:=True;
            end;
          SettingTermostat.ActiveInterface.Output(PID_Termostat.OutputValue);
          LTermostatOutputValue.Caption:=
              FloatToStrF(SettingTermostat.ActiveInterface.OutputValue,ffExponent,4,2);
        end;
      if TemperatureOnTime.isActive then
        TemperatureOnTime.PeriodicMeasuring;
      if IVcharOnTemperature.isActive then
        IVcharOnTemperature.ActionMeasurement;
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
  SaveDialog.FileName:=NextDATFileName(last);

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
 FreeAndNil(ArduinoDataSubject);
 AnyObjectArray.ObjectFree;
  for I := 0 to High(Dependencies) do
    Dependencies[i].Free;
 FastIVMeasuring.Free;
 FastArduinoIV.Free;
end;

procedure TIVchar.DACCreate;
begin
//  DACR2R:=TDACR2R.Create;

  DACR2RShow:=TDACR2RShow.Create(DACR2R,PDACR2RPinC,
                                 STOVDACR2R,STOKDACR2R,
                                 LOVDACR2R,LOKDACR2R,
                                 BOVsetDACR2R, BOKsetDACR2R,
                                 BDACR2RReset, NumberPins);

//  D30_06:=TD30_06.Create;
  D30_06Show:=TD30_06Show.Create(D30_06,PD30PinVol,PD30PinCur,PD30PinGate,
                                 LOVD30,LOKD30,LValueRangeD30,
                                 STOVD30,STOKD30,
                                 BOVsetD30, BOKsetD30,BD30Reset,
                                 NumberPins, RGD30);

//  AD9833:=TAD9833.Create;
  AD9833Show:=TAD9833Show.Create(AD9833,
                                 PAD9833PinC,NumberPins,
                                 ST9866FreqCh0,ST9866PhaseCh0,ST9866FreqCh1,ST9866PhaseCh1,
                                 L9833FreqCh0,L9833PhaseCh0,L9833FreqCh1,L9833PhaseCh1,
                                 SBAD9833GenCh0,SBAD9833GenCh1,SBAD9833Stop,
                                 RGAD9833Mode);
// AnyObjectArray.Add([AD9833{,D30_06{,DACR2R}]);

  AD5752_ModulShow:=TAD5752_ModulShow.Create(AD5752_Modul,
                                     PAD5752Mod,NumberPins);

  AD5752_ChanShowA:=TAD5752_ChanelShow.Create(AD5752_chA,
                       STOV5752chA,STOK5752chA,
                       LOV5752chA,LOK5752chA,LValueRange5752chA,LKodRange5752chA,
                       BOVset5752chA,BOKset5752chA,B5752ResetChA,BPoff5752chA,
                       RG5752chADiap);

  AD5752_ChanShowB:=TAD5752_ChanelShow.Create(AD5752_chB,
                       STOV5752chB,STOK5752chB,
                       LOV5752chB,LOK5752chB,LValueRange5752chB,LKodRange5752chB,
                       BOVset5752chB,BOKset5752chB,B5752ResetChB,BPoff5752chB,
                       RG5752chBDiap);


//  AD5752_ChanShowA:=TAD5752_ChanelShow.Create(AD5752_chA,
//                       PAD5752chA,
//                       STOV5752chA,STOK5752chA,
//                       LOV5752chA,LOK5752chA,LValueRange5752chA,LKodRange5752chA,
//                       BOVset5752chA,BOKset5752chA,B5752ResetChA,BPoff5752chA,
//                       NumberPins,RG5752chADiap);
//  AD5752_ChanShowB:=TAD5752_ChanelShow.Create(AD5752_chB,
//                       PAD5752chB,
//                       STOV5752chB,STOK5752chB,
//                       LOV5752chB,LOK5752chB,LValueRange5752chB,LKodRange5752chB,
//                       BOVset5752chB,BOKset5752chB,B5752ResetChB,BPoff5752chB,
//                       NumberPins,RG5752chBDiap);



 ShowArray.Add([DACR2RShow,D30_06Show,AD9833Show,
                AD5752_ModulShow,
                AD5752_ChanShowA,AD5752_ChanShowB]);
end;

//procedure TIVchar.DACFree;
//begin
////  if assigned(DACR2R) then
////    begin
////    DACR2R.Reset;
////    sleep(100);
////    DACR2R.Free;
////    end;
////
////  DACR2RShow.Free;
//
////  D30_06Show.Free;
////  if assigned(D30_06) then
////    begin
////    D30_06.Reset;
////    sleep(50);
////    D30_06.Free;
////    end;
//
////  AD9833Show.Free;
////  if assigned(AD9833) then
////    begin
////    AD9833.Reset;
////    sleep(50);
////    AD9833.Free;
////    end;
//
////  AD9833Shownew.Free;
////  if assigned(AD9833nw) then
////    begin
//////    AD9833nw.Reset;
//////    sleep(50);
////    AD9833nw.Free;
////    end;
//
//end;

procedure TIVchar.DACReadFromIniFileAndToForm;
begin

//  DACR2RShow.ReadFromIniFileAndToForm(ConfigFile);
  ParametersFileWork(DACR2R.CalibrationRead);

//  D30_06Show.ReadFromIniFileAndToForm(ConfigFile);
//  AD9833Show.ReadFromIniFileAndToForm(ConfigFile);
//  AD9833ShowNew.ReadFromIniFile(ConfigFile);

end;

//procedure TIVchar.DACWriteToIniFile;
//begin
////  DACR2RShow.WriteToIniFile(ConfigFile);
////  D30_06Show.WriteToIniFile(ConfigFile);
////  AD9833Show.WriteToIniFile(ConfigFile);
////  AD9833ShowNew.WriteToIniFile(ConfigFile);
//
//end;

procedure TIVchar.DevicesCreate;
begin
  Simulator:=TSimulator.Create;
  AnyObjectArray.Add(Simulator);

  TermoCoupleDevices:=TArrIMeas.Create([Simulator,V721A,V721_I,V721_II]);
  AllDevices:=TArrIMeas.Create([Simulator,V721A,V721_I,V721_II]);
  VandIDevices:=TArrIMeas.Create([Simulator,V721A,V721_I,V721_II]);

  AnyObjectArray.Add([TermoCoupleDevices,AllDevices,VandIDevices]);


//  SetLength(Devices,4);
//  Devices[0]:=Simulator;
//  Devices[1]:=V721A;
//  Devices[2]:=V721_I;
//  Devices[3]:=V721_II;


//  TermoCouple_MD:=TMeasuringDevice.Create(Devices, CBTcVMD, 'Thermocouple', LTRValue, srVoltge);
  TermoCouple_MD:=TMeasuringDevice.Create(TermoCoupleDevices,
               CBTcVMD, 'Thermocouple', LTRValue, srVoltge);

  TemperMeasurDevices:=TArrITempMeas.Create([Simulator,ThermoCuple,
                                  DS18B20,HTU21D,TMP102,ADT74x0,
                                  MLX90615,STS21,
                                  MCP9808]);
  AnyObjectArray.Add(TemperMeasurDevices);

//  Temperature_MD:=TTemperature_MD.Create([Simulator,ThermoCuple,
//                                  DS18B20,HTU21D,TMP102,ADT74x0,
//                                  MLX90615,STS21,
//                                  MCP9808],
//                                  CBTD,'Temperature',LTRValue);
  Temperature_MD:=TTemperature_MD.Create(TemperMeasurDevices,
                                  CBTD,'Temperature',LTRValue);

  MLX90615Show:=TMLX90615Show.Create(MLX90615,STMLX615_GC, BMLX615_GCread,
                          BMLX615_GCwrite,BMLX615_Calib,Temperature_MD);

  ShowArray.Add([TermoCouple_MD,Temperature_MD,MLX90615Show]);
//  ShowArray.Add([TermoCouple_MDNew,Temperature_MD,MLX90615Show]);

//  SetLength(Devices,High(Devices)+3);
//  Devices[High(Devices)-1]:=UT70B;
//  Devices[High(Devices)]:=UT70C;

  AllDevices.Add([UT70B,UT70C]);
  VandIDevices.Add([UT70B,UT70C]);


  if ET1255isPresent then
   begin
//    SetLength(Devices,High(Devices)+4);
//    Devices[High(Devices)-2]:=ET1255_ADCModule.Channels[0];
//    Devices[High(Devices)-1]:=ET1255_ADCModule.Channels[1];
//    Devices[High(Devices)]:=ET1255_ADCModule.Channels[2];
    AllDevices.Add([ET1255_ADCModule.Channels[0],
                    ET1255_ADCModule.Channels[1],
                    ET1255_ADCModule.Channels[2]]);
    VandIDevices.Add([ET1255_ADCModule.Channels[0],
                    ET1255_ADCModule.Channels[1],
                    ET1255_ADCModule.Channels[2]]);
   end;

//  SetLength(Devices,High(Devices)+5);
//  Devices[High(Devices)-3]:=MCP3424_Channels[0];
//  Devices[High(Devices)-2]:=MCP3424_Channels[1];
//  Devices[High(Devices)-1]:=MCP3424_Channels[2];
//  Devices[High(Devices)]:=MCP3424_Channels[3];
  AllDevices.Add([MCP3424_Channels[0],
                  MCP3424_Channels[1],
                  MCP3424_Channels[2],
                  MCP3424_Channels[3]]);
  VandIDevices.Add([MCP3424_Channels[0],
                    MCP3424_Channels[1],
                    MCP3424_Channels[2],
                    MCP3424_Channels[3]]);



//  SetLength(Devices,High(Devices)+4);
//  Devices[High(Devices)-2]:=ADS11115_Channels[0];
//  Devices[High(Devices)-1]:=ADS11115_Channels[1];
//  Devices[High(Devices)]:=ADS11115_Channels[2];
  AllDevices.Add([ADS11115_Channels[0],
                  ADS11115_Channels[1],
                  ADS11115_Channels[2]]);
  VandIDevices.Add([ADS11115_Channels[0],
                  ADS11115_Channels[1],
                  ADS11115_Channels[2]]);


//  SetLength(Devices,High(Devices)+3);
//  Devices[High(Devices)-1]:=GDS_806S_Channel[1];
//  Devices[High(Devices)]:=GDS_806S_Channel[2];
  AllDevices.Add([GDS_806S_Channel[1],
                  GDS_806S_Channel[2]]);
  VandIDevices.Add([GDS_806S_Channel[1],
                  GDS_806S_Channel[2]]);



//  SetLength(Devices,High(Devices)+3);
//  Devices[High(Devices)-1]:=INA226_Shunt;
//  Devices[High(Devices)]:=INA226_Bus;
//  Pointer(FInterfaceField) := Pointer(InterfaceVariable)

  AllDevices.Add([INA226_Shunt,
                  INA226_Bus]);
  VandIDevices.Add([INA226_Shunt,
                  INA226_Bus]);


//  OlegCurrent:=TCurrent.Create;
//  AnyObjectArray.Add(OlegCurrent);

  CurrentShow:=TCurrentShow.Create(OlegCurrent,ST_oCurBias,
                     L_oCurBias,LoCur,LUoCur,
                     L_oCurMeasDiap,L_oCurMeasVal,
                     B_oCur_Meas,B_oCurMeasDiap,B_oCurMeasVal,
//                     SB_oCur_Auto,Devices,
                     SB_oCur_Auto,VandIDevices,
                     CB_oCurMeasDiap,CB_oCurMeasVal);
  ShowArray.Add(CurrentShow);

   VoltageShow:=TVoltageShow.Create(OlegVoltage,
                     LoVol,LUoVol,
                     L_oVolMeasVal,
                     B_oVol_Meas,B_oVolMeasVal,
                     SB_oVol_Auto,VandIDevices,
                     CB_oVolMeasVal);
  ShowArray.Add(VoltageShow);

//  SetLength(Devices,High(Devices)+2);
//  Devices[High(Devices)]:=OlegCurrent;
  AllDevices.Add(OlegCurrent);
  VandIDevices.Add(OlegCurrent);
  AllDevices.Add(OlegVoltage);
  VandIDevices.Add(OlegVoltage);


//  Current_MD:=TMeasuringDevice.Create(Devices, CBCMD,'Current', LADCurrentValue, srCurrent);
//  VoltageIV_MD:=TMeasuringDevice.Create(Devices, CBVMD,'Voltage', LADVoltageValue, srVoltge);
//
//  DACR2R_MD:=TMeasuringDevice.Create(Devices, CBMeasDACR2R,'R2R', LMeasR2R, srPreciseVoltage);
//  DACR2R_MD.AddActionButton(BMeasR2R);
//  D30_MD:=TMeasuringDevice.Create(Devices, CBMeasD30,'D30', LMeasD30, srPreciseVoltage);
//  D30_MD.AddActionButton(BMeasD30);
//
//  Isc_MD:=TMeasuringDevice.Create(Devices, CBIscMD,'Isc' , LIscResult, srCurrent);
//  Isc_MD.AddActionButton(BIscMeasure);
//  Voc_MD:=TMeasuringDevice.Create(Devices, CBVocMD,'Voc' , LVocResult, srPreciseVoltage);
//  Voc_MD.AddActionButton(BVocMeasure);

  Current_MD:=TMeasuringDevice.Create(VandIDevices, CBCMD,'Current', LADCurrentValue, srCurrent);
  VoltageIV_MD:=TMeasuringDevice.Create(VandIDevices, CBVMD,'Voltage', LADVoltageValue, srVoltge);

  DACR2R_MD:=TMeasuringDevice.Create(VandIDevices, CBMeasDACR2R,'R2R', LMeasR2R, srPreciseVoltage);
  DACR2R_MD.AddActionButton(BMeasR2R);
  D30_MD:=TMeasuringDevice.Create(VandIDevices, CBMeasD30,'D30', LMeasD30, srPreciseVoltage);
  D30_MD.AddActionButton(BMeasD30);

  AD5752chA_MD:=TMeasuringDevice.Create(VandIDevices,CBMeas5752chA,
                             'AD5752A', LMeas5752chA, srPreciseVoltage);
  AD5752chA_MD.AddActionButton(BMeas5752chA);

  AD5752chB_MD:=TMeasuringDevice.Create(VandIDevices,CBMeas5752chB,
                             'AD5752B', LMeas5752chB, srPreciseVoltage);
  AD5752chB_MD.AddActionButton(BMeas5752chB);

  Isc_MD:=TMeasuringDevice.Create(VandIDevices, CBIscMD,'Isc' , LIscResult, srCurrent);
  Isc_MD.AddActionButton(BIscMeasure);
  Voc_MD:=TMeasuringDevice.Create(VandIDevices, CBVocMD,'Voc' , LVocResult, srPreciseVoltage);
  Voc_MD.AddActionButton(BVocMeasure);


  ShowArray.Add([Current_MD,VoltageIV_MD,DACR2R_MD,D30_MD,
                 Isc_MD,Voc_MD]);
//  ShowArray.Add([Current_MDNew,VoltageIV_MDNew,DACR2R_MDNew,D30_MDNew,Isc_MDNew,Voc_MDNew]);

//  SetLength(Devices,High(Devices)+9);
//  Devices[High(Devices)-7]:=ThermoCuple;
//  Devices[High(Devices)-6]:=DS18B20;
//  Devices[High(Devices)-5]:=HTU21D;
//  Devices[High(Devices)-4]:=TMP102;
//  Devices[High(Devices)-3]:=MLX90615;
//  Devices[High(Devices)-2]:=STS21;
//  Devices[High(Devices)-1]:=ADT74x0;
//  Devices[High(Devices)]:=MCP9808;
  AllDevices.Add([ThermoCuple,DS18B20,HTU21D,
                             TMP102,MLX90615,STS21,ADT74x0,MCP9808]);


//  TimeD_MD:=
//    TMeasuringDevice.Create(Devices, CBTimeMD,'Time Dependence', LADCurrentValue, srVoltge);
//  TimeD_MD2:=
//    TMeasuringDevice.Create(Devices, CBTimeMD2,'Time Dependence Two', LADInputVoltageValue, srVoltge);
//  Control_MD:=
//    TMeasuringDevice.Create(Devices, CBControlMD,'Control setup', LControlCVValue, srPreciseVoltage);
//  ShowArray.Add([TimeD_MD,TimeD_MD2,Control_MD]);

  TimeD_MD:=
    TMeasuringDevice.Create(AllDevices, CBTimeMD,'Time Dependence', LADCurrentValue, srVoltge);
  TimeD_MD2:=
    TMeasuringDevice.Create(AllDevices, CBTimeMD2,'Time Dependence Two', LADInputVoltageValue, srVoltge);
  Control_MD:=
    TMeasuringDevice.Create(AllDevices, CBControlMD,'Control setup', LControlCVValue, srPreciseVoltage);
  ShowArray.Add([TimeD_MD,TimeD_MD2,Control_MD]);


//  SetLength(DevicesSet,High(DevicesSet)+4);
////  EnlargeIDACArray(DevicesSet,[Simulator,DACR2R,D30_06]);
//  DevicesSet[0]:=Simulator;
//  DevicesSet[1]:=DACR2R;
//  DevicesSet[High(DevicesSet)]:=D30_06;

  SetingDevices:=TArrIDAC.Create([Simulator,DACR2R,D30_06,AD5752_chA,AD5752_chB]);
  AnyObjectArray.Add(SetingDevices);

  if ET1255isPresent then
   begin
//    SetLength(DevicesSet,High(DevicesSet)+4);
////    EnlargeIDACArray(DevicesSet,[ET1255_DACs[0],
////                     ET1255_DACs[1],ET1255_DACs[2]]);
//    DevicesSet[High(DevicesSet)-2]:=ET1255_DACs[0];
//    DevicesSet[High(DevicesSet)-1]:=ET1255_DACs[1];
//    DevicesSet[High(DevicesSet)]:=ET1255_DACs[2];

    SetingDevices.Add([ET1255_DACs[0],ET1255_DACs[1],ET1255_DACs[2]]);

    ET1255_DAC_MD[0]:=TMeasuringDevice.Create(VandIDevices,
                      CBMeasET1255Ch0,'ET1255_DAC_Ch0',LMeas1255Ch0,srPreciseVoltage);
    ET1255_DAC_MD[0].AddActionButton(BMeas1255Ch0);
    ET1255_DAC_MD[1]:=TMeasuringDevice.Create(VandIDevices,
                      CBMeasET1255Ch1,'ET1255_DAC_Ch1',LMeas1255Ch1,srPreciseVoltage);
    ET1255_DAC_MD[1].AddActionButton(BMeas1255Ch1);
    ET1255_DAC_MD[2]:=TMeasuringDevice.Create(VandIDevices,
                      CBMeasET1255Ch2,'ET1255_DAC_Ch2',LMeas1255Ch2,srPreciseVoltage);
    ET1255_DAC_MD[2].AddActionButton(BMeas1255Ch2);

//    ET1255_DAC_MD[0]:=TMeasuringDevice.Create(Devices,
//                      CBMeasET1255Ch0,'ET1255_DAC_Ch0',LMeas1255Ch0,srPreciseVoltage);
//    ET1255_DAC_MD[0].AddActionButton(BMeas1255Ch0);
//    ET1255_DAC_MD[1]:=TMeasuringDevice.Create(Devices,
//                      CBMeasET1255Ch1,'ET1255_DAC_Ch1',LMeas1255Ch1,srPreciseVoltage);
//    ET1255_DAC_MD[1].AddActionButton(BMeas1255Ch1);
//    ET1255_DAC_MD[2]:=TMeasuringDevice.Create(Devices,
//                      CBMeasET1255Ch2,'ET1255_DAC_Ch2',LMeas1255Ch2,srPreciseVoltage);
//    ET1255_DAC_MD[2].AddActionButton(BMeas1255Ch2);
    ShowArray.Add([ET1255_DAC_MD[0],ET1255_DAC_MD[1],ET1255_DAC_MD[2]]);
   end;


//  SettingDevice:=TSettingDevice.Create(DevicesSet,CBVS,'Input voltage');
//  SettingDeviceControl:=TSettingDevice.Create(DevicesSet,CBControlCD,'Control input');
//  SettingTermostat:=TSettingDevice.Create(DevicesSet,CBTermostatCD,'Termostat input');
//  SettingDeviceLED:=TSettingDevice.Create(DevicesSet,CBLED_onCD,'LED output');
  SettingDevice:=TSettingDevice.Create(SetingDevices,CBVS,'Input voltage');
  SettingDeviceControl:=TSettingDevice.Create(SetingDevices,CBControlCD,'Control input');
  SettingTermostat:=TSettingDevice.Create(SetingDevices,CBTermostatCD,'Termostat input');
  SettingDeviceLED:=TSettingDevice.Create(SetingDevices,CBLED_onCD,'LED output');
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
  if (abs(NewCorrection) > 0.3) and (TIVParameters.VoltageInput < 0.3) then
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
  if TIVParameters.ItIsForward then
    VoltageInputSign := TIVParameters.VoltageInput
  else
    VoltageInputSign := -TIVParameters.VoltageInput;
end;

procedure TIVchar.IVMR_Refresh;
begin
  if ((IVMeasResult.CurrentDiapazon = IVMRFirst.CurrentDiapazon)) and (abs(IVMeasResult.DeltaToExpected) < abs(IVMRFirst.DeltaToExpected)) then
    IVMeasResult.CopyTo(IVMRFirst);
  if ((IVMeasResult.CurrentDiapazon <> IVMRFirst.CurrentDiapazon)) and (abs(IVMeasResult.DeltaToExpected) < abs(IVMRSecond.DeltaToExpected)) then
    IVMeasResult.CopyTo(IVMRSecond);
end;

procedure TIVchar.MCP3424Create;
// var i:TMCP3424_ChanelNumber;
begin
//  MCP3424 := TMCP3424_Module.Create('MCP3424');
  MCP3424show := TI2C_PinsShow.Create(MCP3424.Pins, PMCP3424Pin, MCP3424_StartAdress, MCP3424_LastAdress);
//  for I := Low(TMCP3424_ChanelNumber) to High(TMCP3424_ChanelNumber) do
//    MCP3424_Channels[i] := TMCP3424_Channel.Create(i, MCP3424);

  MCP3424_ChannelShows[0]:=
     TMCP3424_ChannelShow.Create(MCP3424_Channels[0], PMCP3424_Ch1bits, PMCP3424_Ch1gain, LMCP3424_Ch1meas, {BtMCP3424_Ch1bits, BtMCP3424_Ch1gain,} BMCP3424_Ch1meas{, CBMCP3424_Ch1bits, CBMCP3424_Ch1gain});
  MCP3424_ChannelShows[1]:=
     TMCP3424_ChannelShow.Create(MCP3424_Channels[1], PMCP3424_Ch2bits, PMCP3424_Ch2gain, LMCP3424_Ch2meas, {BtMCP3424_Ch2bits, BtMCP3424_Ch2gain,} BMCP3424_Ch2meas{, CBMCP3424_Ch2bits, CBMCP3424_Ch2gain});
  MCP3424_ChannelShows[2]:=
     TMCP3424_ChannelShow.Create(MCP3424_Channels[2], PMCP3424_Ch3bits, PMCP3424_Ch3gain, LMCP3424_Ch3meas, {BtMCP3424_Ch3bits, BtMCP3424_Ch3gain,} BMCP3424_Ch3meas{, CBMCP3424_Ch3bits, CBMCP3424_Ch3gain});
  MCP3424_ChannelShows[3]:=
     TMCP3424_ChannelShow.Create(MCP3424_Channels[3], PMCP3424_Ch4bits, PMCP3424_Ch4gain, LMCP3424_Ch4meas, {BtMCP3424_Ch4bits, BtMCP3424_Ch4gain,} BMCP3424_Ch4meas{, CBMCP3424_Ch4bits, CBMCP3424_Ch4gain});

  ShowArray.Add([MCP3424show,
                 MCP3424_ChannelShows[0],MCP3424_ChannelShows[1],MCP3424_ChannelShows[2],MCP3424_ChannelShows[3]]);
//  AnyObjectArray.Add([MCP3424,MCP3424_Channels[0],MCP3424_Channels[1],
//                      MCP3424_Channels[2],MCP3424_Channels[3]]);
  ArduinoMeters.Add(MCP3424);
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

  ConfigFile.EraseSection('NumberPinsInput');
  ConfigFile.WriteInteger('NumberPinsInput', 'PinCount', NumberPinsInput.Count);
  for I := 0 to NumberPinsInput.Count - 1 do
    ConfigFile.WriteString('NumberPinsInput', 'Pin' + IntToStr(i), NumberPinsInput[i]);
end;

procedure TIVchar.PinsFromIniFile;
var
  i: Integer;
begin
  for I := 0 to ConfigFile.ReadInteger('PinNumbers', 'PinCount', 3) - 1 do
    NumberPins.Add(ConfigFile.ReadString('PinNumbers', 'Pin' + IntToStr(i), IntToStr(UndefinedPin)));
  for I := 0 to ConfigFile.ReadInteger('PinNumbersOneWire', 'PinCount', 1) - 1 do
    NumberPinsOneWire.Add(ConfigFile.ReadString('PinNumbersOneWire', 'Pin' + IntToStr(i), IntToStr(UndefinedPin)));
  for I := 0 to ConfigFile.ReadInteger('NumberPinsInput', 'PinCount', 1) - 1 do
    NumberPinsInput.Add(ConfigFile.ReadString('NumberPinsInput', 'Pin' + IntToStr(i), IntToStr(UndefinedPin)));
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
  CBMeasurements.Items.Add(MeasFastIV);
  CBMeasurements.Items.Add(MeasR2RCalib);
  CBMeasurements.Items.Add(MeasTimeD);
  CBMeasurements.Items.Add(MeasControlParametr);
  CBMeasurements.Items.Add(MeasTempOnTime);
  CBMeasurements.Items.Add(MeasTwoTimeD);
  CBMeasurements.Items.Add(MeasIscAndVocOnTime);
  CBMeasurements.Items.Add(MeasIVonTemper);
  CBMeasurements.Items.Add(MeasIV);
  CBMeasurements.Items.Add(MeasFastIVArd);
  CBMeasurements.ItemIndex:=0;
  Key:=CBMeasurements.Items[CBMeasurements.ItemIndex];


  IsWorkingTermostat:=False;
  IsPID_Termostat_Created:=False;
  IscVocOnTimeIsRun:=False;

end;

end.
