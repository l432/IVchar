unit IVchar_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPort, ComCtrls, Buttons, SPIdevice, ExtCtrls, IniFiles,PacketParameters,
  TeEngine, Series, TeeProcs, Chart, Spin, OlegType, Grids, OlegMath,Measurement, 
  TempThread, ShowTypes,OlegGraph, CPortCtl, Dependence, V7_21, 
  TemperatureSensor, DACR2R, UT70, RS232device,ET1255, RS232_Mediator_Tread,
  mmsystem;

const
  MeasIV='IV characteristic';
  MeasR2RCalib='R2R-DAC Calibration';
  MeasTimeD='Time dependence';

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
    STValueRangeDAC1255: TStaticText;
    STCodeRangeDAC1255: TStaticText;
    STValueRangeDACR2R: TStaticText;
    STCodeRangeDACR2R: TStaticText;
    DependTimer: TTimer;
    CBMeasurements: TComboBox;
    Time_Dependence: TTabSheet;
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
    STControlCV: TStaticText;
    LControlCV: TLabel;
    STControlInterval: TStaticText;
    LControlInterval: TLabel;
    SBControlBegin: TSpeedButton;

    procedure FormCreate(Sender: TObject);
    procedure PortConnected();
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
//    procedure BIVStopClick(Sender: TObject);
//    procedure BIVSaveClick(Sender: TObject);
    procedure BDFFA_R2RClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DependTimerTimer(Sender: TObject);
//    procedure BOKsetDACR2RClick(Sender: TObject);
//    procedure BOVsetChAClick(Sender: TObject);
//    procedure BORChAClick(Sender: TObject);
//    procedure RGORChAClick(Sender: TObject);
  private
    procedure ComponentView;
    {початкове налаштування різних компонентів}
    procedure PinsFromIniFile;
    {зчитування номерів пінів, які використовуються загалом}
    procedure PinsWriteToIniFile;
    Procedure NumberPinsShow();
    {відображується вміст NumberPins в усі
    ComboBox з Tag=1}
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
//    procedure SetVoltage(Value:double);
    procedure TemperatureThreadCreate;
    function StepDetermine(Voltage: Double; ItForward: Boolean):double;
//    function MeasurementNumberDetermine():integer;
    procedure BoxFromIniFile;
    procedure BoxToIniFile;
//    procedure IVCharBegin;
//    procedure IVCharEnd;
    procedure VectorsCreate;
    procedure VectorsDispose;
    { Private declarations }
//    procedure IVcharCycle(Action: TSimpleEvent);
//    procedure IVcharFullCycle(Action: TSimpleEvent);
//    procedure ActionEmpty();
//    procedure ActionMeasurement();
    procedure RangeWriteToIniFile;
//    procedure IVVoltageMeas(var tempV: Double; tempI: Double);
//    procedure IVCurrentMeas(var tempI: Double);
//    procedure VoltageRealDetermination;
//    procedure SleepReal;
//    procedure IVDataSave(tempI: Double; tempV: Double);
//    procedure IVSetVoltage;
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
    procedure TimeDHookEnd;
    procedure TimeDHookFirstMeas;
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
    procedure TemperatureTimerOnTime(Sender: TObject);
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
    NumberPins:TStringList; // номери пінів, які використовуються як керуючі для SPI
    NumberPinsOneWire:TStringList; // номери пінів, які використовуються для OneWire
    ForwSteps,RevSteps,IVResult,VolCorrection,
    VolCorrectionNew,TemperData:PVector;
    DACR2R:TDACR2R;
    DACR2RShow:TDACR2RShow;
    Simulator:TSimulator;
    UT70B:TUT70B;
    UT70BShow:TUT70BShow;
    ET1255_DACs:array[TET1255_DAC_ChanelNumber] of TET1255_DAC;
    ET1255_DACsShow:array[TET1255_DAC_ChanelNumber] of TDAC_Show;
//    Devices,DevicesSet:array of TInterfacedObject;
    Devices:array of IMeasurement;
    DevicesSet:array of IDAC;
//    TemperatureDevices:array of ITemperatureMeasurement;
    Temperature_MD:TTemperature_MD;
//    Current_MD:TCurrent_MD;
//    VoltageIV_MD:TVoltageIV_MD;
//    DACR2R_MD:TVoltageChannel_MD;
    Current_MD,VoltageIV_MD,DACR2R_MD,
    TermoCouple_MD,TimeD_MD:TMeasuringDevice;
    ET1255_DAC_MD:array[TET1255_DAC_ChanelNumber] of TMeasuringDevice;
    SettingDevice:TSettingDevice;
    RS232_MediatorTread:TRS232_MediatorTread;
    TemperatureMeasuringThread:TTemperatureMeasuringThread;
    IVCharRangeFor,CalibrRangeFor:TLimitShow;
    IVCharRangeRev,CalibrRangeRev:TLimitShowRev;
    NumberOfTemperatureMeasuring,IterationNumber: Integer;
    ItIsBegining:boolean;
    Temperature
    ,VoltageInputCorrection,VoltageMeasured
    ,VoltageInputCorrectionN,VoltageMeasuredN:double;
//    DoubleConstantShows:array of TDoubleConstantShow;
    DoubleConstantShows:array of TParameterShow1;
    Imax,Imin,R_VtoI,Shift_VtoI:double;
    IVMeasuring,CalibrMeasuring:TIVDependence;
    TimeDependence:TTimeDependence;
//    TemperatueTimer : integer; // Код мультимедийного таймера для виміру температури
//    TemperatureTimer : TTimer; // таймер для виміру температури
  end;

const
  Undefined='NoData';
  Vmax=6.5;
  StepDefault=0.01;
  AtempNumbermax=3;
//  Rmeas=19.5886;

var
  IVchar: TIVchar;

implementation

{$R *.dfm}

//procedure TemperatureTimerCallBackProg(uTimerID, uMessage: UINT; dwUser,
//  dw1, dw2: DWORD);
//begin
////  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
//  IVchar.Temperature_MD.GetMeasurementResult();
//end;



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

//procedure TIVchar.IVVoltageMeas(var tempV: Double; tempI: Double);
//  var AtempNumber:byte;
//begin
//  AtempNumber:=0;
//  repeat
//
//    repeat
//      Application.ProcessMessages;
//       if IVMeasuringToStop then Exit;
//       tempV := VoltageIV_MD.GetMeasurementResult(VoltageInputReal);
//
//      if abs(tempV*Rs)>0.0001 then
//                if  tempV>0 then tempV:=tempV-abs(tempI)*Rs
//                         else tempV:=tempV+abs(tempI)*Rs;
//
//
//       if RGDO.ItemIndex=1 then
//         begin
//         tempV:=-tempV;
//         LADVoltageValue.Caption:=FloatToStrF(tempV,ffFixed, 4, 3);
//         end;
//
//       if (not(CBSStep.Checked))or(not(ItIsForward)) then Break;
//       if abs(tempV-VoltageInput)>0.0004 then
//         VoltageInputCorrection:=VoltageInputCorrection-(tempV-VoltageInput);
//       if abs(tempV-VoltageInput)>0.0009 then IVSetVoltage();
//    until (abs(tempV-VoltageInput)<0.001) ;
//
//   if (ItIsBegining)or(High(IVResult^.X)<0) then AtempNumber:=AtempNumbermax
//                                             else
//     begin
//       if (ItIsForward and (tempV>IVResult^.X[High(IVResult^.X)])) then AtempNumber:=AtempNumbermax;
//       if (not(ItIsForward) and (tempI<IVResult^.X[High(IVResult^.X)])) then AtempNumber:=AtempNumbermax;
//     end;
//   inc(AtempNumber);
//  until (AtempNumber>AtempNumbermax);
//
//
////{}if not(Par^.SC_Reg)and(znak=1) then
//// begin
//// if i=0 then UUtemp:=U
////        else
////         begin
////               if U1>0 then UUtemp:=a^.x[i]+Delta(a^.x[i])
////                       else UUtemp:=-abs(a^.x[i])-abs(Delta(a^.x[i]));
////         end;
////
//// if (abs(U1-UUtemp)>0.0008) then
////  begin
////  if (abs(U1-UUtemp)>0.001) then Upop:=Upop-(U1-UUtemp)
////      else
////  if (Par^.Kan1.Name=UTC)and(UNITC.Tp='v')and(znak=1) then
////                        Upop:=Upop-0.0005*(U1-UUtemp)/abs(U1-UUtemp)
////                                           else
////                        Upop:=Upop-0.001*(U1-UUtemp)/abs(U1-UUtemp);
////  end;
////
//// if (abs(U1-UUtemp)>0.0014)and(i<>0) then Continue;
//// if ((abs(U1-UUtemp)>0.0018){or(U1<0)})and(i=0) then Continue;
////
////
//// end;{}
//
//end;



//procedure TIVchar.IVCurrentMeas(var tempI: Double);
// var
//  Jump: Double;
//  IncreaseVoltage: Boolean;
//  AtempNumber:byte;
//begin
//   AtempNumber := 0;
//  repeat
//    Application.ProcessMessages;
//    if IVMeasuringToStop then Exit;
//    tempI := Current_MD.GetMeasurementResult(VoltageInputReal);
//    if RGDO.ItemIndex=1 then
//         begin
//         tempI:=-tempI;
//         LADVoltageValue.Caption:=FloatToStrF(tempI,ffExponent, 4, 2);
//         end;
//
//    if (abs(tempI)<=Imin)and(VoltageInput<>0) then
//      begin
//        if ItIsForward then Jump:=0.05 else Jump:=0.5;
//        if Jump<StepDetermine(VoltageInput,ItIsForward) then Jump:=StepDetermine(VoltageInput,ItIsForward);
//
//        IncreaseVoltage:=True;
//        repeat
//          Application.ProcessMessages;
//          if IVMeasuringToStop then Exit;
//
//          VoltageInput:=VoltageInput+Jump;
//          IVSetVoltage();
//
//          tempI := Current_MD.GetMeasurementResult(VoltageInputReal);
//          if RGDO.ItemIndex=1 then
//               begin
//               tempI:=-tempI;
//               LADVoltageValue.Caption:=FloatToStrF(tempI,ffExponent, 4, 2);
//               end;
//          if  (abs(tempI)>Imin)and(IncreaseVoltage) then
//                         begin
//                         Jump:=-Jump/5;
//                         IncreaseVoltage:=False;
//                         end;
//         if  (abs(tempI)<=Imin)and(not(IncreaseVoltage)) then
//                        begin
//                        Jump:=-Jump/5;
//                        IncreaseVoltage:=true;
//                        end;
//        until ((abs(tempI)<=Imin)and(Jump<StepDetermine(VoltageInput,ItIsForward)))
//      end;
//
//   if (ItIsBegining)or(High(IVResult^.Y)<0) then AtempNumber:=AtempNumbermax
//                                             else
//     begin
//     if (ItIsForward and (tempI>IVResult^.Y[High(IVResult^.Y)])) then AtempNumber:=AtempNumbermax;
//     if (not(ItIsForward) and (tempI<IVResult^.Y[High(IVResult^.Y)])) then AtempNumber:=AtempNumbermax;
//     end;
//   inc(AtempNumber);
//  until (AtempNumber>AtempNumbermax);
//end;

//procedure TIVchar.VoltageRealDetermination;
//begin
//  if ItIsForward then
//    VoltageInputReal := VoltageInput + VoltageInputCorrection
//  else
//    VoltageInputReal := -VoltageInput;
//end;

//procedure TIVchar.SleepReal;
//begin
////  if ItIsForward then
////    sleep(ForwDelay)
////  else
////    sleep(RevDelay);
//end;

//procedure TIVchar.IVDataSave(tempI: Double; tempV: Double);
//begin
//   Application.ProcessMessages;
//   if IVMeasuringToStop then Exit;
//    if abs(tempI)<=Imin then Exit;
//    IVResult.Add(tempV, tempI);
//  if ItIsForward then
//  begin
//    ForwLine.AddXY(tempV, tempI);
//    if abs(tempI) > 1E-11 then
//      ForwLg.AddXY(tempV, abs(tempI));
//  end            else
//  begin
//    RevLine.AddXY(-tempV, -tempI);
//    if abs(tempI) > 1E-11 then
//      RevLg.AddXY(-tempV, abs(tempI));
//  end;
//
//end;

//procedure TIVchar.IVSetVoltage;
//begin
//  VoltageRealDetermination;
//  SetVoltage(VoltageInputReal);
//  SleepReal;
//end;

procedure TIVchar.ConstantShowCreate;
begin

  SetLength(DoubleConstantShows, 12);
  DoubleConstantShows[0]:=TParameterShow1.Create(STPR,LPR,
        'Parasitic resistance',
//        'Resistance input',
        'Parasitic resistance value is expected',0,3);
  DoubleConstantShows[1]:=TParameterShow1.Create(STMC,LMC,
        'Maximum current',
//        'Maximum currente input',
        'Maximum current for I-V characteristic measurement is expected',2e-2,2);
  DoubleConstantShows[2]:=TParameterShow1.Create(STMinC,LMinC,
        'Minimum current',
//        'Minimum currente input',
        'Minimum current for I-V characteristic measurement is expected',5e-11,2);
  DoubleConstantShows[3]:=TParameterShow1.Create(STFVP,LFVP,
        'Forward voltage precision',
//         'Forward voltage precision input',
        'Voltage precision for forward I-V characteristic is expected',0.001,4);
  DoubleConstantShows[4]:=TParameterShow1.Create(STRVP,LRVP,
        'Reverse voltage precision',
//        'Reverse voltage precision input',
        'Reverse precision for forward I-V characteristic is expected',0.005,4);
  DoubleConstantShows[5]:=TParameterShow1.Create(STRVtoI,LRVtoI,
        'Resistance V -> I',
//        'Resistance V -> I input',
        'Resistance for V to I transformation is expected',10,4);
  DoubleConstantShows[6]:=TParameterShow1.Create(STVVtoI,LVVtoI,
        'Shift Voltage for V -> I',
//        'Shift Voltage for V -> I input',
        'Shift Voltage for V to I transformation is expected',-0.503,4);
  DoubleConstantShows[7]:=TParameterShow1.Create(STTMI,LTMI,
        'Temperature measurement interval (s)',
        'Temperature measurement interval',5,2);
  DoubleConstantShows[8]:=TParameterShow1.Create(STTimeInterval,LTimeInterval,
        'Measurement interval (s)',
        'Time dependence measurement interval',15,2);
  DoubleConstantShows[9]:=TParameterShow1.Create(STTimeDuration,LTimeDuration,
        'Measurement duration (s)',
        'Full measurement duration',0,2);
  DoubleConstantShows[10]:=TParameterShow1.Create(STControlNV,LControlNV,
        'Needed Value',
        'Needed Value',0);
  DoubleConstantShows[11]:=TParameterShow1.Create(STControlInterval,LControlInterval,
        'Controling interval (s)',
        'Controling measurement interval',15,2);




end;

procedure TIVchar.ConstantShowFromIniFile;
 var i:integer;
begin
//  for I := Low(DoubleConstantShows) to High(DoubleConstantShows) do
//   DoubleConstantShows[i].ReadFromIniFile(ConfigFile);
  for I := Low(DoubleConstantShows) to High(DoubleConstantShows) do
   DoubleConstantShows[i].ReadFromIniFile(ConfigFile);
end;

procedure TIVchar.ConstantShowToIniFile;
 var i:integer;
begin
  ConfigFile.EraseSection(DoubleConstantSection);
//  for I := Low(DoubleConstantShows) to High(DoubleConstantShows) do
//   DoubleConstantShows[i].WriteToIniFile(ConfigFile);
  for I := Low(DoubleConstantShows) to High(DoubleConstantShows) do
   DoubleConstantShows[i].WriteToIniFile(ConfigFile);
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

  TimeDependence:=TTimeDependence.Create(PBIV,BIVStop,IVResult,
                                       ForwLine,ForwLg,DependTimer);

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

  IVMeasuring.HookSetVoltage:=IVCharHookSetVoltage;
  CalibrMeasuring.HookSetVoltage:=CalibrHookSetVoltage;

  IVMeasuring.HookSecondMeas:=IVCharCurrentMeasHook;
  CalibrMeasuring.HookSecondMeas:=CalibrHookSecondMeas;
  TimeDependence.HookSecondMeas:=TimeDHookSecondMeas;

  IVMeasuring.HookFirstMeas:=IVCharVoltageMeasHook;
  CalibrMeasuring.HookFirstMeas:=CalibrHookFirstMeas;
  TimeDependence.HookFirstMeas:=TimeDHookFirstMeas;

  IVMeasuring.HookDataSave:=IVCharHookDataSave;
  CalibrMeasuring.HookDataSave:=CalibrHookDataSave;

  IVMeasuring.HookEndMeasuring:=IVcharHookEnd;
  CalibrMeasuring.HookEndMeasuring:=CalibrHookEnd;
  TimeDependence.HookEndMeasuring:=TimeDHookEnd;

end;

procedure TIVchar.DependenceMeasuringFree;
begin
  IVMeasuring.Free;
  CalibrMeasuring.Free;
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
//  VoltageInputCorrection := 0;
//  CurrentCorrection:=0;
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
// var last:string;
begin
  VolCorrectionNew.Sorting;
  VolCorrectionNew.DeleteDuplicate;
  VolCorrectionNew^.Copy(VolCorrection^);

  SaveClick(Sender);
//  last:=LastDATFileName();
//  if last<>NoFile  then
//  begin
//    try
//      SaveDialog.FileName:=IntToStr(StrToInt(last)+1)+'.dat';
//    except
//      SaveDialog.FileName:=last+'1.dat';;
//    end;
//  end              else
//  SaveDialog.FileName:='1.dat';
//  SaveDialog.Title:='Last file - '+last+'.dat';
//  SaveDialog.InitialDir:=GetCurrentDir;
//  if SaveDialog.Execute then
//   begin
//     IVResult.Sorting;
//     IVResult.DeleteDuplicate;
//     Write_File(SaveDialog.FileName,IVResult);
//     LTLastValue.Caption:=LTRValue.Caption;
//     BIVSave.Font.Style:=BIVSave.Font.Style+[fsStrikeOut];
//     SaveCommentsFile(SaveDialog.FileName);
//   end;
end;

procedure TIVchar.CalibrationHookStep;
begin
  TIVDependence.VoltageStepChange(SettingDevice.CalibrationStep(TIVDependence.VoltageInput));
end;

procedure TIVchar.IVcharHookBegin;
begin
  HookBegin();
  NumberOfTemperatureMeasuring := round(PBIV.Max / 2);
  Temperature := ErResult;
//  Rs := DoubleConstantShows[0].GetValue;
//  Imax := DoubleConstantShows[1].GetValue;
//  Imin := DoubleConstantShows[2].GetValue;
//  R_VtoI:=DoubleConstantShows[5].GetValue;
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
//  CBCalibr.Enabled := False;
//  CBCurrentValue.Enabled := False;
  BIVStart.Enabled := False;
  BConnect.Enabled := False;
  BIVSave.Enabled:=False;
  BParamReceive.Enabled := False;
  SBTAuto.Enabled := False;
//  PC.OnChanging := PCChanging;

//  if SBTAuto.Down then
//    begin
//    SBTAuto.Down := False;
//    TemperatureMeasuringThread.Terminate;
//    end;

//  if not(SBTAuto.Down) then
//    begin
//     SBTAuto.Down := True;
//     TemperatureTimer.Interval:=round(1000*StrToFloat(STTMI.Caption));
//     TemperatureTimer.Enabled:=True;
//    end;


//  if not(SBTAuto.Down) then
//    begin
//    SBTAuto.Down := True;
//    ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
//    TemperatueTimer := timeSetEvent(
//                   round(1000*StrToFloat(STTMI.Caption)),
//                   1,@TemperatureTimerCallBackProg,100,TIME_PERIODIC);
//    end;

end;

procedure TIVchar.IVCharHookSetVoltage;
begin
  if TIVDependence.ItIsForward then
    LADInputVoltageValue.Caption:=FloatToStrF(TIVDependence.VoltageInput,ffFixed, 4, 3)+
    ' '+FloatToStrF(TIVDependence.VoltageInputReal,ffFixed, 4, 3)
                                       else
    LADInputVoltageValue.Caption:=FloatToStrF(-TIVDependence.VoltageInput,ffFixed, 4, 3)+
    ' '+FloatToStrF(TIVDependence.VoltageInputReal,ffFixed, 4, 3);

//showmessage('volt='+floattostr(VoltageMeasured)+
//            ' voltN='+floattostr(VoltageMeasuredN)+#10+
//            'Cal='+floattostr(VoltageInputCorrection)+
//            ' calN='+floattostr(VoltageInputCorrectionN));

 if RGDO.ItemIndex=1 then TIVDependence.VoltageInputRealChange(-1*TIVDependence.VoltageInputReal);
 SettingDevice.SetValue(TIVDependence.VoltageInputReal);
end;

procedure TIVchar.IVCharCurrentMeasHook;
 var
  {Jump,}tmI: Double;
//  IncreaseVoltage: Boolean;
  AtempNumber:byte;
//  Ua,Ux,NewCurrentCorrection:double;
//  ItIsEnd:boolean;
begin
  AtempNumber := 0;
  repeat

//    repeat
//      Application.ProcessMessages;
//      if TDependenceMeasuring.IVMeasuringToStop then Exit;
//      tmI := Current_MD.GetMeasurementResult(TDependenceMeasuring.VoltageInputReal);
//      ItIsEnd:=True;
//      if tmI=ErResult then Break;
//
//      Ua:=abs(tmI)*Current_MD.GetResist;
//      if  TDependenceMeasuring.VoltageInputReal>0
//         then Ux:=TDependenceMeasuring.VoltageInputReal-Ua
//         else Ux:=TDependenceMeasuring.VoltageInputReal+Ua;
//
//     NewCurrentCorrection:=TDependenceMeasuring.VoltageInput*(TDependenceMeasuring.VoltageInputReal/Ux-1);
//     if (abs(NewCurrentCorrection-CurrentCorrection)>0.1*TDependenceMeasuring.VoltageStep)
//       then
//       begin
//         TDependenceMeasuring.VoltageCorrectionChange(
//            TDependenceMeasuring.VoltageCorrection-
//            CurrentCorrection+
//            NewCurrentCorrection);
//         IVMeasuring.SetVoltage();
//         ItIsEnd:=False;
//       end;
//
//      CurrentCorrection:=NewCurrentCorrection;
//    until ItIsEnd;
//    if tmI=ErResult then Break;

   if not(IVCharCurrentMeasuring(tmI)) then Exit;

//      Application.ProcessMessages;
//      if TDependenceMeasuring.IVMeasuringToStop then Exit;
//      tmI := Current_MD.GetMeasurementResult(TDependenceMeasuring.VoltageInputReal);
//      if tmI=ErResult then Break;
//
//    if RGDO.ItemIndex=1 then
//         begin
//         tmI:=-tmI;
//         LADCurrentValue.Caption:=FloatToStrF(tmI,ffExponent, 4, 2);
//         end;

//    if (abs(tmI)<=Imin)and(TDependenceMeasuring.VoltageInput<>0) then
//      begin
//        if TDependenceMeasuring.ItIsForward then Jump:=0.05 else Jump:=0.5;
//        if Jump<StepDetermine(TDependenceMeasuring.VoltageInput,TDependenceMeasuring.ItIsForward)
//           then Jump:=StepDetermine(TDependenceMeasuring.VoltageInput,TDependenceMeasuring.ItIsForward);
//
//        IncreaseVoltage:=True;
//        TDependenceMeasuring.SecondMeasIsDoneChange(False);
//        repeat
//
//          TDependenceMeasuring.VoltageInputChange(TDependenceMeasuring.VoltageInput+Jump);
//          IVMeasuring.SetVoltage();
//
//          if not(IVCharCurrentMeasuring(tmI)) then Exit;
////          Application.ProcessMessages;
////          if TDependenceMeasuring.IVMeasuringToStop then Exit;
////          tmI := Current_MD.GetMeasurementResult(TDependenceMeasuring.VoltageInputReal);
////          if tmI=ErResult then Break;
////          if RGDO.ItemIndex=1 then
////               begin
////               tmI:=-tmI;
////               LADCurrentValue.Caption:=FloatToStrF(tmI,ffExponent, 4, 2);
////               end;
//          if  (abs(tmI)>Imin)and(IncreaseVoltage) then
//                         begin
//                         Jump:=-Jump/5;
//                         IncreaseVoltage:=False;
//                         end;
//         if  (abs(tmI)<=Imin)and(not(IncreaseVoltage)) then
//                        begin
//                        Jump:=-Jump/5;
//                        IncreaseVoltage:=true;
//                        end;
//        until ((abs(tmI)<=Imin)and(Jump<StepDetermine(TDependenceMeasuring.VoltageInput,TDependenceMeasuring.ItIsForward)));
//      end;

//   if tmI=ErResult then Break;
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
// Current := Current_MD.GetMeasurementResult(TDependenceMeasuring.VoltageInputReal);
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

// Cor1:=0;
// if (not(ItIsBegining))and(VolCorrectionNew^.X[High(VolCorrectionNew^.X)]<>0) then
//  Cor1:=TDependenceMeasuring.VoltageInput*
//            ((VolCorrectionNew^.X[High(VolCorrectionNew^.X)]+VolCorrectionNew^.X[High(VolCorrectionNew^.Y)])/VolCorrectionNew^.X[High(VolCorrectionNew^.X)]-1);
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
//                  else
//   TDependenceMeasuring.VoltageCorrectionChange(Cor1);
end;

procedure TIVchar.CalibrHookSecondMeas();
begin
  Application.ProcessMessages;
  if TIVDependence.IVMeasuringToStop then Exit;
//  TDependenceMeasuring.tempIChange(DACR2R_MD.GetMeasurementResult(TDependenceMeasuring.VoltageInputReal));
  TIVDependence.tempIChange(DACR2R_MD.GetMeasurementResult());
  LADCurrentValue.Caption:=FloatToStrF(TIVDependence.tempI,ffFixed, 6, 4);
end;

procedure TIVchar.CalibrHookSetVoltage;
begin
 LADInputVoltageValue.Caption:=FloatToStrF(TIVDependence.VoltageInputReal,ffFixed, 6, 4);
 SettingDevice.SetValueCalibr(TIVDependence.VoltageInputReal);
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
//  if ET_StartDrv <> '' then
//    showmessage('ET1255 loading error' + ''#10''#13'' + ET_ErrMsg)
//    ;
    //                       else
//     begin

     for I := Low(TET1255_DAC_ChanelNumber) to High(TET1255_DAC_ChanelNumber) do
       begin
        ET1255_DACs[i]:=TET1255_DAC.Create(i);
//        ET1255_DACs[i].Reset();
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
//     end;

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
//        then Result:=10*DoubleConstantShows[3].GetValue
//        else Result:=DoubleConstantShows[3].GetValue;
        then Result:=10*DoubleConstantShows[3].Data
        else Result:=DoubleConstantShows[3].Data;
    end                               else
    begin
      if TIVDependence.VoltageInput>1
//        then Result:=10*DoubleConstantShows[4].GetValue
//        else Result:=DoubleConstantShows[4].GetValue;
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
//  tmV := VoltageIV_MD.GetMeasurementResult(TDependenceMeasuring.VoltageInputReal);
  tmV := VoltageIV_MD.GetMeasurementResult();
  if tmV=ErResult then
    begin
     TIVDependence.tempVChange(tmV);
     Exit;
    end;
//************************************
//  IVCharCurrentMeasuring(Factor);
//  tmV :=tmV-Rmeas*abs(Factor);
//  LADVoltageValue.Caption:=FloatToStrF(tmV,ffFixed, 4, 3);

  //  tmV := VoltageIV_MD.GetMeasurementResult(TDependenceMeasuring.VoltageInputReal);

//******************************

  if RGDO.ItemIndex=1 then
     begin
     tmV:=-tmV;
     LADVoltageValue.Caption:=FloatToStrF(tmV,ffFixed, 4, 3);
     end;


  if TIVDependence.ItIsForward then
   CorrectionIsNeeded:=(abs(tmV-TIVDependence.VoltageInput)>=MaxDif)
                                       else
  CorrectionIsNeeded:=(abs(abs(tmV)-TIVDependence.VoltageInput)>=MaxDif);

//  if (CorrectionIsNeeded)and(CBPC.Checked)and(IterationNumber=0) then
//   begin
//     sleep(1500);
//     inc(IterationNumber);
//     goto bbegin;
//   end;


  if CorrectionIsNeeded then
   begin
    TIVDependence.SecondMeasIsDoneChange(False);

//    if TDependenceMeasuring.ItIsForward then V:=TDependenceMeasuring.VoltageInput
//                    else V:=-TDependenceMeasuring.VoltageInput;
    if (not(TIVDependence.ItIsForward))and(TIVDependence.VoltageInput<>0) then
                  tmV:=abs(tmV);
//    tmV:=abs(tmV);

    ItIsLarge:=(tmV>TIVDependence.VoltageInput);
//    ItIsLarge:=(abs(tmV)>abs(V));

    if (ItIsLarge)and(abs(-VoltageMeasuredN+tmV)<0.25*MaxDif) then
     begin
      Randomize;
      NewCorrection:=0.15*Random;
//      VoltageMeasuredN:=ErResult;
      VoltageMeasured:=ErResult;
      VoltageInputCorrection:=ErResult;
//      VoltageInputCorrectionN:=ErResult;
      TIVDependence.VoltageCorrectionChange(NewCorrection);
      Exit;
     end;

    if (not(ItIsLarge))and(abs(VoltageMeasured-tmV)<0.25*MaxDif) then
     begin
      Randomize;
      NewCorrection:=0.15*Random;
      VoltageMeasuredN:=ErResult;
//      VoltageMeasured:=ErResult;
//      VoltageInputCorrection:=ErResult;
      VoltageInputCorrectionN:=ErResult;
      TIVDependence.VoltageCorrectionChange(NewCorrection);
      Exit;
     end;

//    if ItIsLarge then
//       begin
//        VoltageInputCorrectionN:=TDependenceMeasuring.VoltageCorrection;
//        VoltageMeasuredN:=tmV;
//       end       else
//       begin
//        VoltageInputCorrection:=TDependenceMeasuring.VoltageCorrection;
//        VoltageMeasured:=tmV;
//       end;
//
//    if (VoltageMeasured<>ErResult)and(VoltageMeasuredN<>ErResult)
//     then
//       NewCorrection:=y3(VoltageMeasured,VoltageMeasuredN,TDependenceMeasuring.VoltageInput,
//                          VoltageInputCorrection,VoltageInputCorrectionN)
//
//    else


   if ItIsLarge then Factor:=1
                else Factor:=2.5;
   if tmV>(TIVDependence.VoltageInput+TIVDependence.VoltageCorrection)
//   if abs(tmV)>abs(V+TDependenceMeasuring.VoltageCorrection)
     then
   if ItIsLarge then Factor:=1.2
                else Factor:=0.8;
   inc(IterationNumber);
   if (IterationNumber mod 7)=0 then
   begin
//    IterationNumber:=0;
    Randomize;
    Factor:=Factor*Random;
   end;


//   if ItIsLarge then Factor:=0.8
//                else Factor:=1.2;
//
//
//    if tmV>(TDependenceMeasuring.VoltageInput+TDependenceMeasuring.VoltageCorrection)
//     then
//   if ItIsLarge then Factor:=0.9
//                else Factor:=0.5;

   NewCorrection:=TIVDependence.VoltageCorrection+
                     Factor*(TIVDependence.VoltageInput-tmV);
//   NewCorrection:=TDependenceMeasuring.VoltageCorrection+
//                     Factor*(V-tmV);

//    if tmV>(TDependenceMeasuring.VoltageInput+TDependenceMeasuring.VoltageCorrection)
//     then
//     begin
//      if (VoltageMeasuredN=ErResult)and(VoltageMeasured=ErResult)
//          then
//          NewCorrection:=TDependenceMeasuring.VoltageInput-tmV
//          else
//          NewCorrection:=TDependenceMeasuring.VoltageCorrection+
//                     0.5*(TDependenceMeasuring.VoltageInput-tmV);
//
//
//
//
////      if VoltageMeasured<>ErResult then
////         NewCorrection:=y3(VoltageMeasured,tmV,TDependenceMeasuring.VoltageInput,
////                            VoltageInputCorrection,TDependenceMeasuring.VoltageInput-tmV);
////
////      if (VoltageMeasured=ErResult)and(VoltageMeasuredN<>ErResult)
////       then
////         begin
////         showmessage('jjjj');
////          NewCorrection:=(TDependenceMeasuring.VoltageInput-tmV);
//////          NewCorrection:=VoltageInputCorrectionN-TDependenceMeasuring.VoltageInput+tmV;
////
//////          NewCorrection:=y3(VoltageMeasuredN,tmV,TDependenceMeasuring.VoltageInput,
//////                            VoltageInputCorrectionN,TDependenceMeasuring.VoltageInput-tmV);
////
////         end;
//     end;
//
//
//    if ItIsLarge then
//       begin
//        VoltageInputCorrectionN:=TDependenceMeasuring.VoltageCorrection;
//        VoltageMeasuredN:=tmV;
//       end       else
//       begin
//        VoltageInputCorrection:=TDependenceMeasuring.VoltageCorrection;
//        VoltageMeasured:=tmV;
//       end;
//
//
//
//    if not(tmV>(TDependenceMeasuring.VoltageInput+TDependenceMeasuring.VoltageCorrection))
//    then
//    begin
////     showmessage('hi-2');
//    if (VoltageMeasured<>ErResult)and(VoltageMeasuredN<>ErResult)
//     then
////       NewCorrection:=y3(VoltageMeasured,tmV,TDependenceMeasuring.VoltageInput,
////                          VoltageInputCorrection,TDependenceMeasuring.VoltageCorrection)
//       NewCorrection:=y3(VoltageMeasured,VoltageMeasuredN,TDependenceMeasuring.VoltageInput,
//                          VoltageInputCorrection,VoltageInputCorrectionN)
//
//     else
//       NewCorrection:=TDependenceMeasuring.VoltageInput*
//            ((TDependenceMeasuring.VoltageInput+TDependenceMeasuring.VoltageCorrection)/tmV-1);
//    end;

    if abs(NewCorrection)>0.3 then NewCorrection:=0.1*NewCorrection/NewCorrection;

    TIVDependence.VoltageCorrectionChange(NewCorrection);
    Exit;
   end;
  TIVDependence.tempVChange(tmV);


//    repeat
//      Application.ProcessMessages;;
//      if TDependenceMeasuring.IVMeasuringToStop then Exit;
//      tmV := VoltageIV_MD.GetMeasurementResult(TDependenceMeasuring.VoltageInputReal);
//      if tmV=ErResult then Break;
//
//
//      if abs(tmV*Rs)>0.0001 then
//                if  tmV>0 then tmV:=tmV-abs(TDependenceMeasuring.tempI)*Rs
//                          else tmV:=tmV+abs(TDependenceMeasuring.tempI)*Rs;
//
//
//       if RGDO.ItemIndex=1 then
//         begin
//         tmV:=-tmV;
//         LADVoltageValue.Caption:=FloatToStrF(tmV,ffFixed, 4, 3);
//         end;
//
//       if (not(CBSStep.Checked))or(not(TDependenceMeasuring.ItIsForward)) then Break;
//       if abs(tmV-TDependenceMeasuring.VoltageInput)>0.0004 then
//         VoltageInputCorrection:=VoltageInputCorrection-(tmV-TDependenceMeasuring.VoltageInput);
//       if abs(tmV-TDependenceMeasuring.VoltageInput)>0.0009 then
//          begin
//           IVMeasuring.SetVoltage();
//           TDependenceMeasuring.SecondMeasIsDoneChange(False);
//          end;
//    until (abs(tmV-TDependenceMeasuring.VoltageInput)<0.001) ;

//  TDependenceMeasuring.tempVChange(tmV);

//{}if not(Par^.SC_Reg)and(znak=1) then
// begin
// if i=0 then UUtemp:=U
//        else
//         begin
//               if U1>0 then UUtemp:=a^.x[i]+Delta(a^.x[i])
//                       else UUtemp:=-abs(a^.x[i])-abs(Delta(a^.x[i]));
//         end;
//
// if (abs(U1-UUtemp)>0.0008) then
//  begin
//  if (abs(U1-UUtemp)>0.001) then Upop:=Upop-(U1-UUtemp)
//      else
//  if (Par^.Kan1.Name=UTC)and(UNITC.Tp='v')and(znak=1) then
//                        Upop:=Upop-0.0005*(U1-UUtemp)/abs(U1-UUtemp)
//                                           else
//                        Upop:=Upop-0.001*(U1-UUtemp)/abs(U1-UUtemp);
//  end;
//
// if (abs(U1-UUtemp)>0.0014)and(i<>0) then Continue;
// if ((abs(U1-UUtemp)>0.0018){or(U1<0)})and(i=0) then Continue;
//
//
// end;{}
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
//  TDependenceMeasuring.tempVChange(VoltageIV_MD.GetMeasurementResult(TDependenceMeasuring.VoltageInputReal));
  TIVDependence.tempVChange(VoltageIV_MD.GetMeasurementResult());
  LADVoltageValue.Caption:=FloatToStrF(TIVDependence.tempV,ffFixed, 6, 4);
end;

procedure TIVchar.IVCharHookDataSave;
begin
  if abs(TIVDependence.tempI)<=abs(Imin)
//     then TDependenceMeasuring.tempIChange(0);
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

// if Temperature=ErResult then
//    Temperature:=Temperature_MD.GetMeasurementResult();

 BIVSave.OnClick:=IVCharSaveClick;
end;

procedure TIVchar.HookEnd;
begin
  DecimalSeparator:='.';

  CBMeasurements.Enabled:=True;
//  CBCurrentValue.Enabled := True;
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



//procedure TIVchar.ActionMeasurement;
// var tempV,tempI:double;
//begin
//
//  IVSetVoltage();
//
// IVCurrentMeas(tempI);
//
// if (tempI=ErResult)or(CBCurrentValue.Checked and (abs(tempI)>=Imax)) then
//  begin
//   IVMeasuringToStop:=True;
//   Exit;
//  end;
//
//
// IVVoltageMeas(tempV,tempI);
//
// if tempV=ErResult then
//  begin
//   IVMeasuringToStop:=True;
//   Exit;
//  end;
//
//  IVDataSave(tempI, tempV);
//
//  if NumberOfTemperatureMeasuring=PointNumber then
//    Temperature:=Temperature_MD.GetMeasurementResult(VoltageInput);
//  PBIV.Position := PointNumber;
//
//  if ItIsBegining then ItIsBegining:=not(ItIsBegining);
//
//  MelodyShot();
//
//end;


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
//  PortConnected();
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



//procedure TIVchar.BIVSaveClick(Sender: TObject);
// var last:string;
//begin
//  last:=LastDATFileName();
//  if last<>NoFile  then
//  begin
//    try
//      SaveDialog.FileName:=IntToStr(StrToInt(last)+1)+'.dat';
//    except
//      SaveDialog.FileName:=last+'1.dat';;
//    end;
//  end              else
//  SaveDialog.FileName:='1.dat';
//  SaveDialog.Title:='Last file - '+last+'.dat';
//  SaveDialog.InitialDir:=GetCurrentDir;
//  if SaveDialog.Execute then
//   begin
//     IVResult.Sorting;
//     IVResult.DeleteDuplicate;
//     Write_File(SaveDialog.FileName,IVResult,5);
//     LTLastValue.Caption:=LTRValue.Caption;
//     BIVSave.Font.Style:=BIVSave.Font.Style+[fsStrikeOut];
//     SaveCommentsFile(SaveDialog.FileName);
//   end;
//end;

procedure TIVchar.BIVStartClick(Sender: TObject);
begin
 if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasR2RCalib
     then CalibrMeasuring.Measuring;
 if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasIV
     then IVMeasuring.Measuring;
 if CBMeasurements.Items[CBMeasurements.ItemIndex]=MeasTimeD
     then TimeDependence.BeginMeasuring;

//if CBCalibr.Checked then CalibrMeasuring.Measuring
//                    else IVMeasuring.Measuring;
end;


//procedure TIVchar.BIVStopClick(Sender: TObject);
//begin
// IVMeasuringToStop:=True;
//end;

//procedure TIVchar.BOVsetChAClick(Sender: TObject);
// var d:double;
//     int:integer;
//begin
//  d:=Strtofloat(LOVChA.Caption);
//  DAC.ChannelB.Range:=pm100;
//  int:=Dac.IntVoltage(d,DAC.ChannelB.Range);
//  showmessage(IntToHex(int,4));
//end;

//procedure TIVchar.BORChAClick(Sender: TObject);
//begin
//   if not(LORChA.Caption=CBORChA.Items[CBORChA.ItemIndex]) then
//    begin
//      DAC.OutputRangeA(TOutputRange(CBORChA.ItemIndex));
//      LORChA.Caption:=OutputRangeLabels[DAC.ChannelA.Range];
//    end;
//end;

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

procedure TIVchar.Button1Click(Sender: TObject);
begin
 ET_WriteDAC(0,2);
 showmessage(ET_ErrMsg);

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

//procedure TIVchar.BOKsetDACR2RClick(Sender: TObject);
// var value:string;
//     Kod:integer;
//begin
// if InputQuery('Value', 'Output value is expect', value) then
//  begin
//    try
//      Kod:=StrToInt(value);
//      DACR2R.OutputInt(Kod);
//    except
//
//    end;
//  end;
//end;

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
//  ComPortBegining;



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



//   PortConnected;

 if ComPort1.Connected then SettingDevice.Reset();

// TemperatureTimer:=TTimer.Create(IVchar);
// TemperatureTimer.OnTimer:=TemperatureTimerOnTime;
// TemperatureTimer.Enabled:=False;
// if TemperatureTimer=nil then showmessage('pppp');


 RS232_MediatorTread:=TRS232_MediatorTread.Create(
                 [DACR2R,V721A,V721_I,V721_II,DS18B20]);
end;

procedure TIVchar.FormDestroy(Sender: TObject);
begin
 if RS232_MediatorTread <> nil
   then RS232_MediatorTread.Terminate;

 if SBTAuto.Down then TemperatureMeasuringThread.Terminate;

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

procedure TIVchar.PortConnected();
begin
// PortStateToLabel(ComPort1,LConnected);
// PortStateToLabel(ComPortUT70B,LUT70BPort);

// if ComPort1.Connected then
//  begin
//   LConnected.Caption:='ComPort is open';
//   LConnected.Font.Color:=clBlue;
//   BConnect.Caption:='To close'
//  end
//                       else
//  begin
//   LConnected.Caption:='ComPort is close';
//   LConnected.Font.Color:=clRed;
//   BConnect.Caption:='To open'
//  end
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
//  if CBCalibr.Checked then
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


//procedure TIVchar.RGORChAClick(Sender: TObject);
//begin
// DAC.OutputRangeA(TOutputRange((Sender as TRadioGroup).ItemIndex));
// (Sender as TRadioGroup).ItemIndex:=ord(DAC.ChannelA.Range);
//end;

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

//procedure TIVchar.DelayTimeShow;
//begin
//  LFBDelayValue.Caption := IntToStr(ForwDelay);
//  LRBDelayValue.Caption := IntToStr(RevDelay);
//end;

procedure TIVchar.DelayTimeWriteToIniFile;
begin
  WriteIniDef(ConfigFile, 'Delay', 'ForwTime', StrToInt(LFBDelayValue.Caption), 0);
  WriteIniDef(ConfigFile, 'Delay', 'RevTime', StrToInt(LRBDelayValue.Caption), 0);
end;

//function TIVchar.MeasurementNumberDetermine(): integer;
//begin
// PointNumber:=0;
// IVcharFullCycle(ActionEmpty);
// Result:=PointNumber;
//end;

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

//procedure TIVchar.IVCharBegin;
//begin
//  IVMeasuringToStop := False;
//  PBIV.Max := MeasurementNumberDetermine;
//  NumberOfTemperatureMeasuring := round(PBIV.Max / 2);
//  DecimalSeparator := '.';
//  PBIV.Position := 0;
//  BIVStop.Enabled := True;
//  CBForw.Enabled := False;
//  CBRev.Enabled := False;
//  CBSStep.Enabled := False;
//  CBCurrentValue.Enabled := False;
//  BIVSave.Enabled := False;
//  BIVStart.Enabled := False;
//  BConnect.Enabled := False;
//  BParamReceive.Enabled := False;
//  SBTAuto.Enabled := False;
//  PC.OnChanging := PCChanging;
//  if SBTAuto.Down then
//    SBTAuto.Down := False;
//  PointNumber := 0;
//  PBIV.Position := PointNumber;
//  SetLenVector(IVResult, PointNumber);
//  Temperature := ErResult;
//  ForwLine.Clear;
//  RevLine.Clear;
//  ForwLg.Clear;
//  RevLg.Clear;
//  Rs := DoubleConstantShows[0].GetValue;
//  Imax := DoubleConstantShows[1].GetValue;
//  Imin := DoubleConstantShows[2].GetValue
//end;

//procedure TIVchar.IVcharCycle(Action: TSimpleEvent);
// var Start,Finish:double;
////     Steps:PVector;
//     Condition:boolean;
//begin
// if ItIsForward then
//   begin
//     Start:=IVCharRangeFor.LowValue;
//     Finish:=IVCharRangeFor.HighValue;
//     Condition:=CBForw.Checked;
//   end          else
//   begin
//     Start:=IVCharRangeRev.LowValue;;
//     Finish:=IVCharRangeRev.HighValue;;
//     Condition:=CBRev.Checked;
//   end;
//  IVCharHookCycle();
//
// if Condition then
//  begin
//   VoltageInput:=Start;
//   repeat
//     Application.ProcessMessages;
//     if IVMeasuringToStop then Exit;
//     inc(PointNumber);
//
//     Action;
//
//     VoltageInput:=VoltageInput+StepDetermine(VoltageInput,ItIsForward);
//   until VoltageInput>Finish;
//  end;
//end;

//procedure TIVchar.IVCharEnd;
//begin
//  BIVStop.Enabled := False;
//  CBForw.Enabled := True;
//  CBRev.Enabled := True;
//  CBSStep.Enabled := True;
//  CBCurrentValue.Enabled := True;
//  BIVStart.Enabled := True;
//  BConnect.Enabled := True;
//  BParamReceive.Enabled := True;
//  SBTAuto.Enabled := True;
//  PC.OnChanging := nil;
//  if High(IVResult^.X) > 0 then
//  begin
//    BIVSave.Enabled := True;
//    BIVSave.Font.Style := BIVSave.Font.Style - [fsStrikeOut];
//    IVResult.Sorting;
//    IVResult.DeleteDuplicate;
//  end;
//  MelodyLong;
////  if TemperatureIsMeasuring then SBTAuto.Down:=True;
//end;

//procedure TIVchar.IVcharFullCycle(Action: TSimpleEvent);
//begin
//  ItIsForward:=True;
//  ItIsBegining:=True;
//  IVcharCycle(Action);
//  ItIsForward:=False;
//  ItIsBegining:=True;
//  IVcharCycle(Action);
//end;

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


procedure TIVchar.SBTAutoClick(Sender: TObject);
begin
 if SBTAuto.Down then
    TemperatureThreadCreate()
                 else
    TemperatureMeasuringThread.Terminate;

// if SBTAuto.Down then
//     begin
//       TemperatureTimer.Interval:=round(1000*StrToFloat(STTMI.Caption));
//       TemperatureTimer.Enabled:=True;
//     end
//                 else
//       TemperatureTimer.Enabled:=False;


// if SBTAuto.Down then
//    begin
//     ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
//     TemperatueTimer := timeSetEvent(
//                   round(1000*StrToFloat(STTMI.Caption)),
//                   1,@TemperatureTimerCallBackProg,100,TIME_PERIODIC);
//    end
//                 else
//     timeKillEvent(TemperatueTimer);
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

//procedure TIVchar.SetVoltage(Value: double);
//begin
// if RGDO.ItemIndex=1 then Value:=-Value;
// SettingDevice.SetValue(Value);
// sleep(1000);
//end;

procedure TIVchar.TemperatureThreadCreate;
begin
  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
  TemperatureMeasuringThread:=
    TTemperatureMeasuringThread.Create(Temperature_MD,round(1000*StrToFloat(STTMI.Caption)));

//  TemperatureMeasuringThread:=TTemperatureMeasuringThread.Create(True);
//  TemperatureMeasuringThread.TemperatureMD:=Temperature_MD;
//  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
//
//  TemperatureMeasuringThread.Priority:=tpLower;
//  TemperatureMeasuringThread.FreeOnTerminate:=True;
//  TemperatureMeasuringThread.Resume;
end;



procedure TIVchar.TemperatureTimerOnTime(Sender: TObject);
begin
  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
  Temperature_MD.GetMeasurementResult();
end;


procedure TIVchar.TimeDHookBegin;
begin
  HookBegin();
//  TimeDependence.Interval:=round(StrToFloatDef(STTimeInterval.Caption,15));
//  TimeDependence.Duration:=round(StrToFloatDef(STTimeDuration.Caption,0));
//  showmessage(floattostr(round(StrToFloat(STTimeInterval.Caption))));
//  temp:=round(StrToFloat(STTimeInterval.Caption));
  TimeDependence.Interval:=round(StrToFloat(STTimeInterval.Caption));
//  TimeDependence.Interval:=temp;
//  showmessage(floattostr(TimeDependence.Interval));

  TimeDependence.Duration:=round(StrToFloat(STTimeDuration.Caption));
//  showmessage(floattostr(TimeDependence.Duration));

  LADInputVoltage.Visible:=False;
  LADInputVoltageValue.Visible:=False;
  LADRange.Visible:=False;
  LADVoltage.Caption:='Meauring:';
  LADCurrent.Caption:='Time:';
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
 LADVoltageValue.Caption:=FloatToStrF(TDependence.tempI,ffFixed, 4, 3);
end;

procedure TIVchar.TimeDHookSecondMeas;
begin
 LADCurrentValue.Caption:=FloatToStrF(TDependence.tempV,ffExponent, 4, 3);
end;

procedure TIVchar.DependTimerTimer(Sender: TObject);
begin
  ThermoCuple.Measurement:=TermoCouple_MD.ActiveInterface;
//  Temperature_MD.GetMeasurementResult();
  Temperature_MD.ActiveInterface.GetDataThread(TemperMessage);
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
//  DS18B20show:=TPinsShow.Create(DS18B20,LDS18BPin,nil,BDS18B,nil,CBDS18b20);
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
//  VoltmetrShows[i].PinsReadFromIniFile(ConfigFile);
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
//  VoltmetrShows[i].PinsWriteToIniFile(ConfigFile);
  VoltmetrShows[i].PinShow.PinsWriteToIniFile(ConfigFile);
 DS18B20show.PinsWriteToIniFile(ConfigFile);
end;

procedure TIVchar.WMMyMeasure(var Mes: TMessage);
begin
  if Mes.WParam=TemperMessage then
    begin
      LTRValue.Caption:=FloatToStrF(Temperature_MD.ActiveInterface.Value,ffFixed, 5, 2);
    end;
  
end;

procedure TIVchar.HookEndReset;
begin
  SettingDevice.Reset;
  if TIVDependence.IVMeasuringToStop then
    showmessage('Procedure ia stopped');
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
//  DAC := TDAC.Create(ComPort1, 'AD5752R');
//  SetLength(DACChanelShows,2);
//  DACChanelShows[0]:= TDACChannelShow.Create(DAC,8, LORChA,LOVChA,CBORChA,
//                                      BORChA,BOVchangeChA,BOVsetChA,
//                                      LPowChA,BBPowChA);
//  DACChanelShows[1]:= TDACChannelShow.Create(DAC,10, LORChB,LOVChB,CBORChB,
//                                      BORChB,BOVchangeChB,BOVsetChB,
//                                      LPowChB,BBPowChB);
//  DACShow:=TDACShow.Create(DAC,
//                           DACChanelShows[0],DACChanelShows[1],
//                           LDACPinC,LDACPinG,LDACPinLDAC,LDACPinCLR,
//                           BDACSetC,BDACSetG,BDACSetLDAC,BDACSetCLR,CBDAC,
//                           PanelDACChA,PanelDACChB,BDACInit,BDACReset);
  DACR2R:=TDACR2R.Create(ComPort1,'DAC R-2R');
  DACR2RShow:=TDACR2RShow.Create(DACR2R,LDACR2RPinC,LDACR2RPinG,LOVDACR2R,LOKDACR2R,
                                 BDACR2RSetC,BDACR2RSetG,BOVchangeDACR2R,
                                 BOVsetDACR2R, BOKchangeDACR2R, BOKsetDACR2R,
                                 BDACR2RReset, CBDACR2R);

end;

procedure TIVchar.DACFree;
//   var i:integer;
begin
  DACR2RShow.Free;
  if assigned(DACR2R) then DACR2R.Free;
end;

procedure TIVchar.DACReadFromIniFileAndToForm;
//  var tempdir:string;
begin
//  DACShow.PinsReadFromIniFile(ConfigFile);
//  DAC.ChannelsReadFromIniFile(ConfigFile);
//  DAC.Begining();
//  DACShow.NumberPinShow;
//  DACShow.DataShow;
  DACR2RShow.PinShow.PinsReadFromIniFile(ConfigFile);
  DACR2RShow.PinShow.NumberPinShow;
  ParametersFileWork(DACR2R.CalibrationRead);
//  tempdir := GetCurrentDir;
//  ChDir(ExtractFilePath(Application.ExeName));
//  DACR2R.CalibrationRead();
//  ChDir(tempdir);
end;

procedure TIVchar.DACWriteToIniFile;
begin
//  DACShow.PinsWriteToIniFile(ConfigFile);
//  DAC.ChannelsWriteToIniFile(ConfigFile);
  DACR2RShow.PinShow.PinsWriteToIniFile(ConfigFile);
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

//  Temperature_MD:=TTemperature_MD.Create(Devices,CBTD,LTRValue,srVoltge);
//  Temperature_MD.Add(DS18B20);
  Temperature_MD:=TTemperature_MD.Create([Simulator,ThermoCuple,DS18B20],CBTD,LTRValue);

  SetLength(Devices,5);
  Devices[4]:=UT70B;
//  Current_MD:=TCurrent_MD.Create(Devices,{RBCSSimulation,RBCSMeasur,CBCSMeas}CBCMD,LADCurrentValue);
//  VoltageIV_MD:=TVoltageIV_MD.Create(Devices,{RBVSSimulation,RBVSMeasur,CBVSMeas}CBVMD,LADVoltageValue);
  Current_MD:=TMeasuringDevice.Create(Devices,CBCMD,LADCurrentValue,srCurrent);
  VoltageIV_MD:=TMeasuringDevice.Create(Devices,CBVMD,LADVoltageValue,srVoltge);

//  DACR2R_MD:=TVoltageChannel_MD.Create(Devices,{RBMeasSimR2R,RBMeasMeasR2R,CBMeasR2R}CBMeasDACR2R,LMeasR2R);
//  DACR2R_MD.AddActionButton(BMeasR2R,LOVDACR2R);
  DACR2R_MD:=TMeasuringDevice.Create(Devices,CBMeasDACR2R,LMeasR2R,srPreciseVoltage);
  DACR2R_MD.AddActionButton(BMeasR2R);

//  SetLength(Devices,7);
//  Devices[5]:=ThermoCuple;
  TimeD_MD:=TMeasuringDevice.Create(Devices,CBTimeMD,LADCurrentValue,srVoltge);
  TimeD_MD.Add(ThermoCuple);
  TimeD_MD.Add(DS18B20);

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


  SettingDevice:=TSettingDevice.Create(DevicesSet,CBVS);
end;

procedure TIVchar.DevicesFree;
begin
  SettingDevice.Free;
  TimeD_MD.Free;
  Temperature_MD.Free;
  Current_MD.Free;
  VoltageIV_MD.Free;
  DACR2R_MD.Free;
  TermoCouple_MD.Free;
  ET1255_DAC_MD[0].Free;
  ET1255_DAC_MD[1].Free;
  ET1255_DAC_MD[2].Free;
end;

procedure TIVchar.DevicesReadFromIniAndToForm;
begin
  SettingDevice.ReadFromIniFile(ConfigFile,MD_IniSection,'Input voltage');
  Temperature_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'Temperature');
  Current_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'Current');
  VoltageIV_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'Voltage');
  DACR2R_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'R2R');
  TermoCouple_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'Thermocouple');
  ET1255_DAC_MD[0].ReadFromIniFile(ConfigFile,MD_IniSection,'ET1255_DAC_Ch0');
  ET1255_DAC_MD[1].ReadFromIniFile(ConfigFile,MD_IniSection,'ET1255_DAC_Ch1');
  ET1255_DAC_MD[2].ReadFromIniFile(ConfigFile,MD_IniSection,'ET1255_DAC_Ch2');
  TimeD_MD.ReadFromIniFile(ConfigFile,MD_IniSection,'Time Dependence');
//  ChannelA_MD.ReadFromIniFile(ConfigFile,'Sources','ChannelA');
//  ChannelB_MD.ReadFromIniFile(ConfigFile,'Sources','ChannelB');
end;

procedure TIVchar.DevicesWriteToIniFile;
begin
  ConfigFile.EraseSection(MD_IniSection);
  SettingDevice.WriteToIniFile(ConfigFile,MD_IniSection,'Input voltage');
  Temperature_MD.WriteToIniFile(ConfigFile,MD_IniSection,'Temperature');
  Current_MD.WriteToIniFile(ConfigFile,MD_IniSection,'Current');
  VoltageIV_MD.WriteToIniFile(ConfigFile,MD_IniSection,'Voltage');
  DACR2R_MD.WriteToIniFile(ConfigFile,MD_IniSection,'R2R');
  TermoCouple_MD.WriteToIniFile(ConfigFile,MD_IniSection,'Thermocouple');
  ET1255_DAC_MD[0].WriteToIniFile(ConfigFile,MD_IniSection,'ET1255_DAC_Ch0');
  ET1255_DAC_MD[1].WriteToIniFile(ConfigFile,MD_IniSection,'ET1255_DAC_Ch1');
  ET1255_DAC_MD[2].WriteToIniFile(ConfigFile,MD_IniSection,'ET1255_DAC_Ch2');
  TimeD_MD.WriteToIniFile(ConfigFile,MD_IniSection,'Time Dependence');

//  ChannelA_MD.WriteToIniFile(ConfigFile,'Sources','ChannelA');
//  ChannelB_MD.WriteToIniFile(ConfigFile,'Sources','ChannelB');
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
  CBMeasurements.ItemIndex:=0;

end;

end.
