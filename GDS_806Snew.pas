unit GDS_806Snew;

interface

uses
  RS232device, CPort, ShowTypes, StdCtrls, Classes, IniFiles, OlegType,
  Measurement, Buttons, ExtCtrls, Series, PacketParameters, OlegTypePart2,
  OlegShowTypes, OlegVector, RS232deviceNew;

type

 TGDS_Settings=(gds_mode,gds_rl,gds_an,gds_ts,
                gds_ch1_coup,gds_ch1_prob,gds_ch1_mtype,gds_ch1_scale,
                gds_ch2_coup,gds_ch2_prob,gds_ch2_mtype,gds_ch2_scale);

 TGDS_ModeSym=(gds_msam,gds_mpd,gds_maver);
 TGDS_Mode=0..2;

 TGDS_Channel=1..2;
 TGDS_MemoryAdress=1..15;

 TGDS_RecordLengthSym=(gds_rl500,gds_rl1250,gds_rl2500,
                    gds_r5000,gds_rl12500,gds_rl25000,
                    gds_rl50000,gds_rl125000);
 TGDS_RecordLength=0..7;

 TGDS_AverageNumber=0..8;
 TGDS_AverageNumberSym=(gds_an1,
                    gds_an2,
                    gds_an4,
                    gds_an8,
                    gds_an16,
                    gds_an32,
                    gds_an64,
                    gds_an128,
                    gds_an256);

 TGDS_ChanCoupl=0..2;
 TGDS_ChanCouplSym=(gds_ccAC, gds_ccDC, gds_ccGRN);

 TGDS_TimeScale=0..30;
 TGDS_TimeScaleSym=(gds_ts1ns,gds_ts2_5ns,gds_ts5ns,gds_ts10ns,gds_ts25ns,
                 gds_ts50ns,gds_ts100ns,gds_ts250ns,gds_ts500ns,gds_ts1us,
                 gds_ts2_5us,gds_ts5us,gds_ts10us,gds_ts25us,gds_ts50us,
                 gds_ts100us,gds_ts250us,gds_ts500us,gds_ts1ms,gds_ts2_5ms,
                 gds_ts5ms,gds_ts10ms,gds_ts25ms,gds_ts50ms,gds_ts100ms,
                 gds_ts250ms,gds_ts500ms,gds_ts1s,gds_ts2_5s,gds_ts5s,gds_ts10s);

 TGDS_VoltageScale=0..16;
 TGDS_VoltageScaleSym=(gds_vs2mV,gds_vs5mV,gds_vs10mV,gds_vs20mV,gds_vs50mV,
                 gds_vs100mV,gds_vs200mV,gds_vs500mV,gds_vs1V,
                 gds_vs2V,gds_vs5V,gds_vs10V,gds_vs20V,gds_vs50V,
                 gds_vs100V,gds_vs200V,gds_vs500V);

 TGDS_Probe=0..2;
 TGDS_ProbeSym=(gds_p1X,gds_p10X,gds_p100X);

 TGDS_MeasureType=0..14;
 TGDS_MeasureTypeSym=(gds_m_ft,gds_m_fr,gds_m_npt,gds_m_dr,gds_m_pr,
              gds_m_ppt,gds_m_rt,gds_m_vamp,gds_m_avv,gds_m_hv,
              gds_m_lv,gds_m_maxamp,gds_m_minamp,gds_m_vpp,gds_m_rms);



const
  TestShow=False;

  GDS_806S_PacketBeginChar='';
  GDS_806S_PacketEndChar=#10;

  GDS_806S_Test='GW,GDS-806S,EF211754,V1.10';

  RootNood:array[0..12]of string=
  ('*idn?','*rcl','*rst','*sav',':acq',':aut',':chan',':meas',':refr',
//   0       1      2      3      4      5       6       7      8
  ':run',':stop','syst:unl',':tim:scal');
//  9       10     11           12

  FirstNode_4:array[0..3]of string=
  ('aver','leng','mod','mem');
//   0      1     2      3

  FirstNode_6:array[0..5]of string=
  ('coup','disp','inv','offs','prob','scal');
//   0      1     2      3       4      5

  FirstNode_7:array[0..15]of string=
  ('fall','freq','nwid','pdut','per','pwid','ris',
//   0      1     2      3       4      5     6
   'vamp','vav','vhi','vlo','vmax','vmin','vpp','vrms','sour');
//   7      8     9     10    11     12     13    14     15

  OperationKod:array [TGDS_Settings] of array[0..2] of byte=
//                  RootNood  FirstNode  VariantsNumber
{gds_mode}        ((   4,         2,           3),
{gds_rl}           (   4,         1,           8),
{gds_an}           (   4,         0,           9),
{gds_ts}           (   12,        0,           31),
{gds_ch1_coup}     (   6,         0,           3),
{gds_ch1_prob}     (   6,         4,           3),
{gds_ch1_mtype}    (   7,         0,           15),
{gds_ch1_scale}    (   6,         5,           17),
{gds_ch2_coup}     (   6,         0,           3),
{gds_ch2_prob}     (   6,         4,           3),
{gds_ch2_mtype}    (   7,         0,           15),
{gds_ch2_scale}    (   6,         5,           17));



  GDS_MeasureTypeLabels:array[TGDS_MeasureType]of string=
   ('Falling time','Frequency','Negative pulse timing',
   'Duty ratio','Period','Positive pulse timing','Rising time',
   'Voltage amplitude','Average voltage','High voltage',
   'Low voltage','Maximum amplitude','Minimum amplitude',
   'Peak-to-peak voltage','Root mean square');

  GDS_ModeLabels:array[TGDS_Mode]of string=
    ('Sample','Peak detection','Average');

  GDS_RecordLengthData:array[TGDS_RecordLength]of integer=
    (500,1250,2500,5000,12500,25000,50000,125000);

  GDS_ChanCouplLabels:array[TGDS_ChanCoupl]of string=
   ('AC','DC','GRN');

  GDS_ProbeLabels:array[TGDS_Probe]of string=
   ('1X','10X','100X');

  GDS_TimeScaleLabels:array[TGDS_TimeScale]of string=
   ('1.000ns','2.500ns','5.000ns','10.00ns',
   '25.00ns','50.00ns','100.0ns','250.0ns',
   '500.0ns','1.000us','2.500us','5.000us',
   '10.00us','25.00us','50.00us','100.0us',
   '250.0us','500.0us','1.000ms','2.500ms',
   '5.000ms','10.00ms','25.00ms','50.00ms',
   '100.0ms','250.0ms','500.0ms','1.000s',
   '2.500s','5.000s','10.00s');

  GDS_TimeScaleData:array[TGDS_TimeScale]of string=
   ('1e-9','2.5e-9','5e-9','10e-9','25e-9','50e-9','100e-9','250e-9',
   '500e-9','1e-6','2.5e-6','5e-6','10e-6','25e-6','50e-6','100e-6',
   '250e-6','500e-6','1e-3','2.5e-3','5e-3','10e-3','25e-3','50e-3',
   '100e-3','250e-3','500e-3','1','2.5','5','10');

 GDS_VoltageScaleLabels:array[TGDS_VoltageScale]of string=
 ('2.00mV','5.00mV','10.0mV','20.0mV','50.0mV','100mV',
 '200mV','500mV','1.00V','2.00V','5.00V',
 '10.0V','20.0V','50.0V','100V','200V','500V');

 GDS_VoltageScaleData:array[TGDS_VoltageScale]of string=
 ('0.002','0.005','0.01','0.02','0.05','0.1','0.2',
 '0.5','1','2','5','10','20','50','100','200','500');



  ButtonNumber = 10;

type

  TRS232_GDS=class(TRS232)
    protected
    public
     Constructor Create(CP:TComPort);
    end;

  TDataSubject_GDS=class(TRS232DataSubjectSingle)
    protected
    procedure ComPortCreare(CP:TComPort);override;
  end;

  TDataRequest_GDS=class(TCDDataRequest)
    protected
     function IsNoSuccessSend:Boolean;override;
    public
     procedure Request;override;
  end;


  TGDS_806Snew=class(TRS232MeterDeviceSingle)
   private
     fSettings:array[TGDS_Settings]of byte;
     fActiveChannel:TGDS_Channel;

     fInvert:array[TGDS_Channel]of Boolean;
     fDisplay:array[TGDS_Channel]of Boolean;
     fOffset:array[TGDS_Channel]of double;
     fRootNode:byte;
     fFirstLevelNode:byte;
     fLeafNode:byte;
     fIsQuery:boolean;
     fTimeTransfer:integer;
     fLSB:double;
//     fDataRequest:TCDDataRequest;
     procedure SetFlags(RootNode,FirstLevelNode,LeafNode:byte;
                  IsQuery:boolean=False);
     procedure SetupOperation(RootNode,FirstLevelNode,LeafNode:byte);overload;
     procedure SetupOperation(Value:byte;Param:TGDS_Settings);overload;
     procedure SetupOperation(Value:byte;ParamCh1,ParamCh2:TGDS_Settings);overload;
     procedure QuireOperation(RootNode,FirstLevelNode,LeafNode:byte);
     function GetParam(Param:TGDS_Settings):boolean;overload;
     function GetParam(ParamCh1,ParamCh2:TGDS_Settings):boolean;overload;
     procedure DefaultSettings;
    function IncorrectScale(Chan: TGDS_Channel; Scale: byte):boolean;
    function GDS_StringToValue(Str:string):double;
    function MTypeToMeasureModeLabel(MType:byte):string;
    function CurrentBaudRate():integer;
    function TimeForDataTransfer():integer;
    function FourByteToSingle(byte_low,byte_1,byte_2,byte_high:byte):single;
    function TwoByteToData(byte_High,byte_Low:byte):double;
  protected
     procedure PrepareString;
     procedure UpDate();override;
     procedure CreateDataSubject(CP:TComPort);override;
     procedure CreateDataRequest;override;
//     procedure FreeDataRequest;override;
//     procedure CreateDataConverter;override;
//     procedure FreeDataConverter;override;
//     Procedure PacketReceiving(Sender: TObject; const Str: string);override;
   public
    DataVectors:array[TGDS_Channel]of TVector;
    property ActiveChannel:TGDS_Channel read FActiveChannel write FActiveChannel;
    Constructor Create(CP:TComPort;Nm:string);overload;
    Constructor Create(CP:TComPort);overload;
    procedure Free;override;
//    procedure Request();override;

    procedure SetMode(mode: Byte);overload;
    procedure SetMode(mode: TGDS_ModeSym);overload;
    function GetMode():boolean;

    procedure SetRecordLength(RL: Byte);overload;
    procedure SetRecordLength(RL: TGDS_RecordLengthSym);overload;
    function GetRecordLength():boolean;

    procedure SetAverageNumber(AV: Byte);overload;
    procedure SetAverageNumber(AV: TGDS_AverageNumberSym);overload;
    function GetAverageNumber():boolean;

    procedure SetTimeBase(TimeScale:byte);overload;
    procedure SetTimeBase(TimeScale:TGDS_TimeScaleSym);overload;
    function GetTimeBase():boolean;

    procedure SetCoupling(Chan:TGDS_Channel;Coupl:byte);
    procedure SetActiveChannelCoupling(Coupl:byte);overload;
    procedure SetActiveChannelCoupling(Coupl:TGDS_ChanCouplSym);overload;
    function GetActiveChanelCoupling():boolean;
    function GetCoupling(Chan:TGDS_Channel):boolean;

    procedure SetProb(Chan:TGDS_Channel;Prob:byte);
    function GetActiveChannelProb():boolean;
    function GetProb(Chan:TGDS_Channel):boolean;

    procedure SetScale(Chan:TGDS_Channel;Scale:byte);
    function GetActiveChannelScale():boolean;
    function GetScale(Chan:TGDS_Channel):boolean;

    procedure SetMeasType(Chan:TGDS_Channel;MType:byte);overload;
    procedure SetMeasType(Chan:TGDS_Channel;MType:TGDS_MeasureTypeSym);overload;

    procedure DisplayOn(Chan:TGDS_Channel);
    procedure DisplayOff(Chan:TGDS_Channel);
    function GetActiveChannelDisplay():boolean;
    function GetDisplay(Chan:TGDS_Channel):boolean;
    procedure InvertOn(Chan:TGDS_Channel);
    procedure InvertOff(Chan:TGDS_Channel);
    function GetActiveChannelInvert():boolean;
    function GetInvert(Chan:TGDS_Channel):boolean;

    procedure SetOffset(Chan:TGDS_Channel;Offset:double);
    function GetActiveChannelOffset():boolean;
    function GetOffset(Chan:TGDS_Channel):boolean;

    function GetSetting():boolean;
    function Test():boolean;
    procedure LoadSetting(MemoryAdress:TGDS_MemoryAdress);
    procedure SaveSetting(MemoryAdress:TGDS_MemoryAdress);
    procedure DefaultSetting();
    procedure AutoSetting();
    procedure Refresh();
    procedure Run();
    procedure Stop();
    procedure Unlock();
    function GetMeasuringData(Chan:TGDS_Channel):double;
    procedure GetMeasuringDataVectors(Chan:TGDS_Channel);
  end;

TGDS_806Snew_Channel=class(TNamedInterfacedObject,IMeasurement)
 private
  fValue:double;
  fNewData:boolean;
  fChanelNumber: TGDS_Channel;
  fParentModule:TGDS_806Snew;
  function GetNewData:boolean;
  function GetValue:double;
  procedure SetNewData(Value:boolean);
  function GetMeasureModeLabel():string;
 public
 property NewData:boolean read GetNewData write SetNewData;
 property Value:double read GetValue;
 property MeasureModeLabel:string read GetMeasureModeLabel;
 constructor Create(ChanelNumber:TGDS_Channel;
                     GDS_806S:TGDS_806Snew);
 function GetData:double;
 procedure GetDataThread(WPARAM: word; EventEnd:THandle);
 procedure SetMeasType(MType:byte);overload;
 procedure SetMeasType(MType:TGDS_MeasureTypeSym);overload;
end;

TGDSnew_Chan_Show=class(TMeasurementShowSimple)
  private
   fGDSChan:TGDS_806Snew_Channel;
  protected
   function UnitModeLabel():string;override;
  public
   Constructor Create(GDSChan:TGDS_806Snew_Channel;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      TT:TTimer
                      );
end;


 TGDS_806Snew_Show=class(TSimpleFreeAndAiniObject)
   private
    fGDS_806S:TGDS_806Snew;
    fSettingsShow:array[TGDS_Settings]of TStringParameterShow;
    fSettingsShowSL:array[TGDS_Settings]of TStringList;
    BTest:TButton;

    fInvertCheckBox:array[TGDS_Channel]of TCheckBox;
    fDisplayCheckBox:array[TGDS_Channel]of TCheckBox;
    fOffsetShow:array[TGDS_Channel]of TDoubleParameterShow;

    TTChan,TTShow:TTimer;
    fGDS_Chan_Show:array[TGDS_Channel]of TGDSnew_Chan_Show;
    fVectors_RG:TRadioGroup;
    fVectorMeas:TButton;
    fVectorAuto:TSpeedButton;
    fGraphs:array[TGDS_Channel]of TCustomSeries;
    fFirstSetting:boolean;

    procedure SetSetting();
    procedure SetSettingButtonClick(Sender:TObject);
    procedure GetSettingButtonClick(Sender:TObject);
    procedure TestButtonClick(Sender:TObject);
    procedure SaveButtonClick(Sender:TObject);
    procedure LoadButtonClick(Sender:TObject);
    procedure AutoButtonClick(Sender:TObject);
    procedure DefaultButtonClick(Sender:TObject);
    procedure RefreshButtonClick(Sender:TObject);
    procedure RunButtonClick(Sender:TObject);
    procedure StopButtonClick(Sender:TObject);
    procedure UnlockButtonClick(Sender:TObject);
    procedure DisplayInvertClick(Sender:TObject);
    procedure MeasButtonShowClick(Sender: TObject);
    procedure AutoSpeedButtonShowClick(Sender: TObject);
    procedure SettingsShowSLCreate();
    procedure SettingsShowSLFree();
    procedure SettingsShowCreate(STexts:array of TStaticText;
                        Labels: array of TLabel);
    procedure SettingsShowFree();
    procedure OffsetShowCreate(STexts:array of TStaticText;
                        Labels: array of TLabel);
    procedure OffsetShowFree();
    procedure ShowCreate(GDS_806S_Channel:array of TGDS_806Snew_Channel;
                        MeasLabels:array of TLabel;
                       MeasButtons:Array of TButton;
                       MeasSpeedButtons:array of TSpeedButton);
    procedure ShowFree();
    procedure CanalCheckBoxCreate(InvCB,DisCB:array of TCheckBox);
    procedure ColorToActive(Value:boolean);
    procedure ButtonsTune(Buttons: array of TButton);
    procedure TimeScaleOkClick();
    procedure CoupleCh1OkClick();
    procedure CoupleCh2OkClick();
    procedure ProbeCh1OkClick();
    procedure ProbeCh2OkClick();
    procedure ScaleCh1OkClick();
    procedure ScaleCh2OkClick();
    procedure MeasTypeCh1OkClick();
    procedure MeasTypeCh2OkClick();
    procedure OffsetCh1Click();
    procedure OffsetCh2Click();
   public
    Constructor Create(GDS_806S:TGDS_806Snew;
                       GDS_806S_Channel:array of TGDS_806Snew_Channel;
                       STexts:array of TStaticText;
                       Labels:array of TLabel;
                       Buttons:Array of TButton;
                       InvCB:array of TCheckBox;
                       DisCB:array of TCheckBox;
                       MeasLabels:array of TLabel;
                       MeasButtons:Array of TButton;
                       MeasSpeedButtons:array of TSpeedButton;
                       Gr:array of TCustomSeries;
                       VecRG:TRadioGroup
                       );
    Procedure Free;override;
    procedure ReadFromIniFile(ConfigFile:TIniFile);override;
    procedure WriteToIniFile(ConfigFile:TIniFile);override;
    procedure SettingToObject;
    procedure ObjectToSetting;
 end;

var
  StringToSend:string;
  GDS_806Snw:TGDS_806Snew;
  GDS_806Snew_Channel:array[TGDS_Channel]of TGDS_806Snew_Channel;
//  GDS_806Snew_Show:TGDS_806Snew_Show;

implementation

uses
  Dialogs, Controls, SysUtils, Graphics, OlegFunction, OlegGraph, Math;

{ TGDS_806Snew }

procedure TGDS_806Snew.AutoSetting;
begin
 SetupOperation(5,0,0);
end;

constructor TGDS_806Snew.Create(CP: TComPort; Nm: string);
begin
 inherited Create(CP,Nm);
 RepeatInErrorCase:=True;
// fComPacket.MaxBufferSize:=250052;
// fComPacket.StartString := GDS_806S_PacketBeginChar;
// fComPacket.StopString := GDS_806S_PacketEndChar;
// fComPort.Buffer.InputSize:=250052;
 DefaultSettings();
 SetFlags(0,0,0,true);
end;

constructor TGDS_806Snew.Create(CP: TComPort);
begin
 Create(CP,'GDS-806'); 
end;

//procedure TGDS_806Snew.CreateDataConverter;
//begin
//
//end;

procedure TGDS_806Snew.CreateDataRequest;
begin
 fDataRequest:=TDataRequest_GDS.Create(Self.fDataSubject.RS232,Self);
// fRS232DataRequest:=fDataRequest;
end;

procedure TGDS_806Snew.CreateDataSubject(CP: TComPort);
begin
  fDataSubject:=TDataSubject_GDS.Create(CP);
end;

function TGDS_806Snew.CurrentBaudRate: integer;
begin
 case fDataSubject.RS232.ComPort.BaudRate of
  br110:Result:=110;
  br300:Result:=300;
  br600:Result:=600;
  br1200:Result:=1200;
  br2400:Result:=2400;
  br4800:Result:=4800;
  br9600:Result:=9600;
  br14400:Result:=14400;
  br19200:Result:=19200;
  br38400:Result:=38400;
  br56000:Result:=56000;
  br57600:Result:=57600;
  br115200:Result:=115200;
  else Result:=100;
 end;
end;

procedure TGDS_806Snew.DefaultSetting;
begin
 SetupOperation(2,0,0);
end;

procedure TGDS_806Snew.DefaultSettings;
 var i:TGDS_Settings;
     j:TGDS_Channel;
begin
 fActiveChannel:=1;
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
  fSettings[i]:=0;
 for j := Low(TGDS_Channel) to High(TGDS_Channel) do
   begin
     fInvert[j]:=False;
     fDisplay[j]:=True;
     fOffset[j]:=0;
     DataVectors[j]:=TVector.Create;
   end;
end;

procedure TGDS_806Snew.DisplayOff(Chan: TGDS_Channel);
begin
 fActiveChannel:=Chan;
 fDisplay[fActiveChannel]:=False;
 SetupOperation(6,1,0);
end;

procedure TGDS_806Snew.DisplayOn(Chan: TGDS_Channel);
begin
 fActiveChannel:=Chan;
 fDisplay[fActiveChannel]:=True;
 SetupOperation(6,1,1);
end;

function TGDS_806Snew.FourByteToSingle(byte_low, byte_1, byte_2, byte_high: byte): single;
 var c:array[0..3] of byte;
     a:single absolute c;
begin
 c[3]:=byte_high;
 c[2]:=byte_2;
 c[1]:=byte_1;
 c[0]:=byte_low;
 Result:=a;
end;

procedure TGDS_806Snew.Free;
 var j:TGDS_Channel;
begin
// HelpForMe(Name+Name);
 for j := Low(TGDS_Channel) to High(TGDS_Channel) do
     DataVectors[j].Free;
 inherited Free;
end;

//procedure TGDS_806Snew.FreeDataConverter;
//begin
//  inherited;
//
//end;

//procedure TGDS_806Snew.FreeDataRequest;
//begin
// fDataRequest.Free;
//end;

function TGDS_806Snew.GetAverageNumber: boolean;
 var i:TGDS_AverageNumber;
begin
 if fSettings[gds_mode]<>2 then
   begin
     fSettings[gds_an]:=0;
     Result:=True;
     Exit;
   end;

 QuireOperation(4,0,0);
 Result:=False;
 if Value=ErResult then Exit;
 for i := Low(TGDS_AverageNumber) to High(TGDS_AverageNumber) do
  if (round(Value)=$01 shl ord(i)) then
    begin
     fSettings[gds_an]:=i;
     Result:=True;
     Break;
    end;
end;

function TGDS_806Snew.GDS_StringToValue(Str: string): double;
begin
  try
    if (Str='?') or (Str='chan off!') then
      begin
        Result:=ErResult;
        Exit;
      end;
    if AnsiPos('n', Str)>1 then
     begin
     Result:=1e-9*StrToFloat(Copy(Str,1,AnsiPos('n', Str)-1));
     Exit;
     end;
    if AnsiPos('m', Str)>1 then
     begin
     Result:=1e-3*StrToFloat(Copy(Str,1,AnsiPos('m', Str)-1));
     Exit;
     end;
    if AnsiPos('u', Str)>1 then
     begin
     Result:=1e-6*StrToFloat(Copy(Str,1,AnsiPos('u', Str)-1));
     Exit;
     end;
    if AnsiPos('k', Str)>1 then
     begin
     Result:=1e3*StrToFloat(Copy(Str,1,AnsiPos('k', Str)-1));
     Exit;
     end;
    if AnsiPos('M', Str)>1 then
     begin
     Result:=1e6*StrToFloat(Copy(Str,1,AnsiPos('M', Str)-1));
     Exit;
     end;
    if AnsiPos('V', Str)>1 then
     begin
     Result:=StrToFloat(Copy(Str,1,AnsiPos('V', Str)-1));
     Exit;
     end;
   if AnsiPos('.', Str)>1 then  Result:=StrToFloat(Copy(Str,1,5))
                          else  Result:=StrToFloat(Copy(Str,1,4));
  except
   Result:=ErResult;
  end;
end;

function TGDS_806Snew.GetActiveChanelCoupling: boolean;
begin
 Result:=GetParam(gds_ch1_coup,gds_ch2_coup);
end;

function TGDS_806Snew.GetActiveChannelProb: boolean;
begin
 Result:=GetParam(gds_ch1_prob,gds_ch2_prob);
end;

function TGDS_806Snew.GetActiveChannelScale: boolean;
begin
 Result:=GetParam(gds_ch1_scale,gds_ch2_scale);
end;

function TGDS_806Snew.GetActiveChannelDisplay: boolean;
begin
 QuireOperation(6,1,0);
 Result:=round(Value)in[0..1];
 fDisplay[fActiveChannel]:=(round(Value)=1)
end;

function TGDS_806Snew.GetActiveChannelInvert: boolean;
begin
 QuireOperation(6,2,0);
 Result:=round(Value)in[0..1];
 fInvert[fActiveChannel]:=(round(Value)=1)
end;

function TGDS_806Snew.GetActiveChannelOffset: boolean;
begin
 QuireOperation(6,3,0);
 Result:=(Value<>ErResult);
 if Result then fOffset[fActiveChannel]:=Value;
end;

function TGDS_806Snew.GetParam(Param: TGDS_Settings): boolean;
begin
 QuireOperation(OperationKod[Param,0],OperationKod[Param,1],0);
 Result:=(round(Value)<OperationKod[Param,2]);
 if Result then  fSettings[Param]:=(round(Value));
end;

function TGDS_806Snew.GetCoupling(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetActiveChanelCoupling();
end;

function TGDS_806Snew.GetDisplay(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetActiveChannelDisplay();
end;

function TGDS_806Snew.GetInvert(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetActiveChannelInvert();
end;

function TGDS_806Snew.GetMeasuringData(Chan:TGDS_Channel): double;
begin
 Value:=ErResult;
  case Chan of
  1:QuireOperation(7,fSettings[gds_ch1_mtype],1);
  2:QuireOperation(7,fSettings[gds_ch2_mtype],2);
 end;
 Result:=Value;
end;

procedure TGDS_806Snew.GetMeasuringDataVectors(Chan: TGDS_Channel);
begin
 fActiveChannel:=Chan;
 fMinDelayTime:=TimeForDataTransfer();
 GetActiveChannelScale();
 fDataSubject.RS232.ComPacket.StopString :='';
 if fActiveChannel=1 then
   fLSB:=StrtoFloat(GDS_VoltageScaleData[fSettings[gds_ch1_scale]])/25
                      else
   fLSB:=StrtoFloat(GDS_VoltageScaleData[fSettings[gds_ch2_scale]])/25;
 QuireOperation(4,3,0);
 fMinDelayTime:=0;
 fDataSubject.RS232.ComPacket.StopString := GDS_806S_PacketEndChar;
end;

function TGDS_806Snew.GetMode:boolean;
begin
 Result:=GetParam(gds_mode);
end;

function TGDS_806Snew.GetOffset(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetActiveChannelOffset;
end;

function TGDS_806Snew.GetParam(ParamCh1, ParamCh2: TGDS_Settings): boolean;
begin
 case fActiveChannel of
  1:Result:=GetParam(ParamCh1);
  else Result:=GetParam(ParamCh2);
 end;
end;

function TGDS_806Snew.GetProb(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetActiveChannelProb();
end;

function TGDS_806Snew.GetRecordLength: boolean;
 var i:TGDS_RecordLength;
begin
 QuireOperation(4,1,0);
 Result:=False;
 if Value=ErResult then Exit;
 for i := Low(TGDS_RecordLength) to High(TGDS_RecordLength) do
  if (round(Value)=GDS_RecordLengthData[i]) then
    begin
     fSettings[gds_rl]:=i;
     Result:=True;
     Break;
    end;
end;

function TGDS_806Snew.GetScale(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetActiveChannelScale();
end;

function TGDS_806Snew.GetSetting: boolean;
begin
 Result:=False;
 if not(GetMode) then Exit;
 if not(GetRecordLength) then Exit;
 if not(GetAverageNumber) then Exit;
 if not(GetTimeBase) then Exit;
 fActiveChannel:=2;
 if not(GetParam(gds_ch2_coup)) then Exit;
 if not(GetParam(gds_ch2_prob)) then Exit;
 if not(GetActiveChannelScale()) then Exit;
 if not(GetActiveChannelDisplay()) then Exit;
 if not(GetActiveChannelInvert()) then Exit;
 if not(GetActiveChannelOffset()) then Exit;
 fActiveChannel:=1;
 if not(GetParam(gds_ch1_coup)) then Exit;
 if not(GetParam(gds_ch1_prob)) then Exit;
 if not(GetActiveChannelScale()) then Exit;
 if not(GetActiveChannelDisplay()) then Exit;
 if not(GetActiveChannelInvert()) then Exit;
 if not(GetActiveChannelOffset()) then Exit;
 Result:=True;
end;

function TGDS_806Snew.GetTimeBase: boolean;
begin
 Result:=GetParam(gds_ts);
end;

function TGDS_806Snew.IncorrectScale(Chan: TGDS_Channel; Scale: byte): boolean;
 var temp:byte;
begin
if Chan=1 then temp:=fSettings[gds_ch1_prob]
          else temp:=fSettings[gds_ch2_prob];
 Result:=((temp=0)and(Scale>10))or
         ((temp=1)and((Scale>13)or(Scale<3)))or
         ((temp=2)and((Scale>16)or(Scale<6)));
end;

procedure TGDS_806Snew.InvertOff(Chan: TGDS_Channel);
begin
 fActiveChannel:=Chan;
 fInvert[fActiveChannel]:=False;
 SetupOperation(6,2,0);
end;

procedure TGDS_806Snew.InvertOn(Chan: TGDS_Channel);
begin
 fActiveChannel:=Chan;
 fInvert[fActiveChannel]:=True;
 SetupOperation(6,2,1);
end;

procedure TGDS_806Snew.LoadSetting(MemoryAdress: TGDS_MemoryAdress);
begin
 SetupOperation(1,0,MemoryAdress);
end;

function TGDS_806Snew.MTypeToMeasureModeLabel(MType: byte): string;
begin
 case Mtype of
  0,2,4..6:Result:='s';
  1:Result:='Hz';
  3:Result:='%';
  7..14:Result:='V';
  else Result:='';
 end;
end;

procedure TGDS_806Snew.UpDate;
var
  I: TGDS_TimeScale;
  j:TGDS_VoltageScale;
  DataSize:Integer;
  DataSizeDigit:byte;
  DataOffset:integer;
  SampleRate:single;
  k:integer;
  Str:string;
begin
 Str:=fDataSubject.ReceivedString;

 case fRootNode of
  0:if Str=GDS_806S_Test then fValue:=314;
  4:begin
     case fFirstLevelNode of
        0..2:try
            fValue:=StrToInt(Str);
            except
            end;
        3:if Str[1]='#' then
          begin
           try
           DataSizeDigit:=byte(StrToInt(Str[2]));
           DataSize:=round((StrToInt(Copy(Str,3,DataSizeDigit))-8)/2);
           DataOffset:=DataSizeDigit+3;
           SampleRate:=FourByteToSingle(ord(Str[DataOffset+3]),ord(Str[DataOffset+2]),
                       ord(Str[DataOffset+1]),ord(Str[DataOffset]));
           fActiveChannel:=ord(Str[DataOffset+4]);
           DataVectors[fActiveChannel].SetLenVector(DataSize);
           DataOffset:=DataOffset+8;
           for k := 0 to DataSize - 1 do
             begin
              DataVectors[fActiveChannel].X[k]:=k/SampleRate;
              DataVectors[fActiveChannel].Y[k]:=TwoByteToData(ord(Str[DataOffset+2*k]),
                                                    ord(Str[DataOffset+2*k+1]));
             end;
           fValue:=1;
           except

           end;
          end;
     end;
    end; //fRootNode = 4;  acq
  6:begin
     case fFirstLevelNode of
        0..2,4:try
            fValue:=StrToInt(Str);
            except
            end;
        3:Value:=GDS_StringToValue(Str);
        5:begin
           for j := Low(TGDS_VoltageScale) to High(TGDS_VoltageScale) do
             if Str=GDS_VoltageScaleLabels[j] then
               begin
               fValue:=ord(j);
               Break;
               end;
         end;
     end;
    end; //fRootNode = 6;     chan
   7:Value:=GDS_StringToValue(Str);
  12:begin
     for I := Low(TGDS_TimeScale) to High(TGDS_TimeScale) do
       if Str=GDS_TimeScaleLabels[i] then
         begin
         fValue:=ord(i);
         Break;
         end;
    end; //fRootNode = 12; time scale
 end; //case fRootNode of

fIsReceived:=True;
if TestShow then showmessage('recived:  '+STR);


end;

procedure TGDS_806Snew.PrepareString;
begin
 StringToSend:=RootNood[fRootNode];
 if fRootNode in [2,5,8..11] then Exit;

 case fRootNode of
  4:begin
     case fFirstLevelNode of
        3:StringToSend:=StringToSend+
                        IntToStr(fActiveChannel)+
                       ':'+FirstNode_4[fFirstLevelNode];
        0..2:StringToSend:=StringToSend+
                          ':'+FirstNode_4[fFirstLevelNode];
     end;
     if fIsQuery then StringToSend:=StringToSend+'?'
                 else StringToSend:=StringToSend+' '+IntToStr(fLeafNode);
    end; //fRootNode = 4;  acq
  6:begin
     StringToSend:=StringToSend+IntToStr(fActiveChannel)+':'+
                          FirstNode_6[fFirstLevelNode];
     if fIsQuery then StringToSend:=StringToSend+'?'
                 else
        case fFirstLevelNode of
         3:StringToSend:=StringToSend+' '+
                         FloatToStrF(fOffset[fActiveChannel],ffGeneral,3,2);
         5:if fActiveChannel=1 then
              StringToSend:=StringToSend+' '+
               GDS_VoltageScaleData[TGDS_VoltageScale(fSettings[gds_ch1_scale])]
                               else
              StringToSend:=StringToSend+' '+
                GDS_VoltageScaleData[TGDS_VoltageScale(fSettings[gds_ch2_scale])];
         else StringToSend:=StringToSend+' '+IntToStr(fLeafNode);
        end;
//     Exit;
    end; //fRootNode = 6;     chan
   7:begin
      StringToSend:=StringToSend+':'+FirstNode_7[15]+' '+Inttostr(fLeafNode)+
      ';'+RootNood[fRootNode]+':'+FirstNode_7[fFirstLevelNode]+'?';
     end;
  12:begin
     if fIsQuery then
       StringToSend:=StringToSend+'?'
                 else
       StringToSend:=StringToSend+' '+
        GDS_TimeScaleData[TGDS_TimeScale(fSettings[gds_ts])];
    end; //fRootNode = 12; time scale
 end; //case fRootNode of
end;

procedure TGDS_806Snew.QuireOperation(RootNode, FirstLevelNode, LeafNode: byte);
begin
 SetFlags(RootNode, FirstLevelNode, LeafNode, True);
 PrepareString();
 GetData;
end;

procedure TGDS_806Snew.Refresh;
begin
  SetupOperation(8,0,0);
end;

//procedure TGDS_806Snew.Request;
//begin
//if TestShow then showmessage('send:  '+StringToSend);
// if fComPort.Connected then
//  begin
//   fComPort.AbortAllAsync;
//   fComPort.ClearBuffer(True, True);
//   fError:=(fComPort.WriteStr(StringToSend+GDS_806S_PacketEndChar)<>(Length(StringToSend)+1));
//  end
//                      else
//   fError:=True;
//end;

procedure TGDS_806Snew.Run;
begin
  SetupOperation(9,0,0);
end;

procedure TGDS_806Snew.SaveSetting(MemoryAdress: TGDS_MemoryAdress);
begin
 SetupOperation(3,0,MemoryAdress);
end;

procedure TGDS_806Snew.SetAverageNumber(AV: Byte);
begin
 if fSettings[gds_mode]=2 then
  SetupOperation(AV,gds_an);
end;

procedure TGDS_806Snew.SetAverageNumber(AV: TGDS_AverageNumberSym);
begin
 SetAverageNumber(ord(AV));
end;

procedure TGDS_806Snew.SetCoupling(Chan:TGDS_Channel;Coupl:byte);
begin
 fActiveChannel:=Chan;
 SetupOperation(Coupl,gds_ch1_coup,gds_ch2_coup)
end;

procedure TGDS_806Snew.SetActiveChannelCoupling(Coupl: byte);
begin
 SetupOperation(Coupl,gds_ch1_coup,gds_ch2_coup);
end;

procedure TGDS_806Snew.SetActiveChannelCoupling(Coupl: TGDS_ChanCouplSym);
begin
 SetActiveChannelCoupling(ord(Coupl));
end;


procedure TGDS_806Snew.SetFlags(RootNode, FirstLevelNode,
                            LeafNode: byte;
                            IsQuery: boolean);
begin
 fRootNode:=RootNode;
 fFirstLevelNode:=FirstLevelNode;
 fLeafNode:=LeafNode;
 fIsQuery:=IsQuery;
end;

procedure TGDS_806Snew.SetMeasType(Chan: TGDS_Channel; MType: byte);
begin
 fActiveChannel:=Chan;
 case fActiveChannel of
  1:fSettings[gds_ch1_mtype]:=MType mod OperationKod[gds_ch1_mtype,2];
  2:fSettings[gds_ch2_mtype]:=MType mod OperationKod[gds_ch2_mtype,2];
 end;
end;

procedure TGDS_806Snew.SetMeasType(Chan: TGDS_Channel; MType: TGDS_MeasureTypeSym);
begin
 SetMeasType(Chan,ord(MType));
end;

procedure TGDS_806Snew.SetMode(mode: TGDS_ModeSym);
begin
 SetMode(ord(mode));
end;

procedure TGDS_806Snew.SetOffset(Chan: TGDS_Channel; Offset: double);
begin
 fActiveChannel:=Chan;
 fOffset[fActiveChannel]:=Offset;
 SetupOperation(6,3,0);
end;

procedure TGDS_806Snew.SetProb(Chan: TGDS_Channel; Prob: byte);
begin
 fActiveChannel:=Chan;
 SetupOperation(Prob,gds_ch1_prob,gds_ch2_prob);
 GetActiveChannelScale;
end;

procedure TGDS_806Snew.SetMode(mode: Byte);
begin
 SetupOperation(mode,gds_mode);
end;

procedure TGDS_806Snew.SetRecordLength(RL: TGDS_RecordLengthSym);
begin
 SetRecordLength(ord(RL));
end;

procedure TGDS_806Snew.SetRecordLength(RL: Byte);
begin
 SetupOperation(RL,gds_rl);
end;

procedure TGDS_806Snew.SetScale(Chan: TGDS_Channel; Scale: byte);
begin
 if IncorrectScale(Chan, Scale) then Exit;

 fActiveChannel:=Chan;
 SetupOperation(Scale,gds_ch1_scale,gds_ch2_scale);
end;

procedure TGDS_806Snew.SetTimeBase(TimeScale: TGDS_TimeScaleSym);
begin
 SetTimeBase(ord(TimeScale));
end;

procedure TGDS_806Snew.SetupOperation(Value: byte;
                              ParamCh1,ParamCh2: TGDS_Settings);
begin
 case fActiveChannel of
  1:SetupOperation(Value,ParamCh1);
  2:SetupOperation(Value,ParamCh2);
 end;
end;

procedure TGDS_806Snew.SetupOperation(Value:byte;Param: TGDS_Settings);
begin
 fSettings[Param]:=Value mod OperationKod[Param,2];
 SetupOperation(OperationKod[Param,0],OperationKod[Param,1],fSettings[Param]);
end;

procedure TGDS_806Snew.SetTimeBase(TimeScale: byte);
begin
 SetupOperation(TimeScale,gds_ts);
end;

procedure TGDS_806Snew.SetupOperation(RootNode, FirstLevelNode, LeafNode: byte);
begin
 SetFlags(RootNode, FirstLevelNode, LeafNode);
 PrepareString();
 Request();
end;

procedure TGDS_806Snew.Stop;
begin
  SetupOperation(10,0,0);
end;

function TGDS_806Snew.Test: boolean;
begin
 QuireOperation(0,0,0);
 Result:=(Value=314);
end;

function TGDS_806Snew.TimeForDataTransfer: integer;
begin
 fDataSubject.RS232.ComPacket.Size:=GDS_RecordLengthData[fSettings[gds_rl]]*2;
 case fSettings[gds_rl] of
  0..2:fDataSubject.RS232.ComPacket.Size:=fDataSubject.RS232.ComPacket.Size+14;
  3..5:fDataSubject.RS232.ComPacket.Size:=fDataSubject.RS232.ComPacket.Size+15;
  6..7:fDataSubject.RS232.ComPacket.Size:=fDataSubject.RS232.ComPacket.Size+16;
 end;
 Result:=round(1.1*fDataSubject.RS232.ComPacket.Size*8000/CurrentBaudRate());
 fTimeTransfer:=Result;
end;

function TGDS_806Snew.TwoByteToData(byte_High, byte_Low:byte): double;
 var c:array[0..1] of byte;
     a:smallint absolute c;
begin
 c[1]:=byte_high;
 c[0]:=byte_low;
 Result:=a*fLSB;
end;

procedure TGDS_806Snew.Unlock;
begin
   SetupOperation(11,0,0);
end;

{ TGDS_806Snew_Show }

procedure TGDS_806Snew_Show.AutoButtonClick(Sender: TObject);
begin
 fGDS_806S.AutoSetting();
end;

procedure TGDS_806Snew_Show.CanalCheckBoxCreate(InvCB, DisCB: array of TCheckBox);
 var i:TGDS_Channel;
begin
 for I := Low(TGDS_Channel) to High(TGDS_Channel) do
  begin
   fInvertCheckBox[i]:=InvCB[i-1];
   fInvertCheckBox[i].Caption:='Invert';
   fInvertCheckBox[i].OnClick:=DisplayInvertClick;
   fDisplayCheckBox[i]:=DisCB[i-1];
   fDisplayCheckBox[i].Caption:='Display';
   fDisplayCheckBox[i].OnClick:=DisplayInvertClick;
  end;
end;

procedure TGDS_806Snew_Show.ColorToActive(Value: boolean);
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
   fSettingsShow[i].ColorToActive(Value);
end;

procedure TGDS_806Snew_Show.CoupleCh1OkClick;
begin
 fGDS_806S.SetCoupling(1,fSettingsShow[gds_ch1_coup].Data);
end;

procedure TGDS_806Snew_Show.CoupleCh2OkClick;
begin
 fGDS_806S.SetCoupling(2,fSettingsShow[gds_ch2_coup].Data);
end;

constructor TGDS_806Snew_Show.Create(GDS_806S: TGDS_806Snew;
                       GDS_806S_Channel:array of TGDS_806Snew_Channel;
                       STexts:array of TStaticText;
                       Labels:array of TLabel;
                       Buttons:Array of TButton;
                       InvCB:array of TCheckBox;
                       DisCB:array of TCheckBox;
                       MeasLabels:array of TLabel;
                       MeasButtons:Array of TButton;
                       MeasSpeedButtons:array of TSpeedButton;
                       Gr:array of TCustomSeries;
                       VecRG:TRadioGroup
                                  );
  var i:TGDS_Channel;
begin
  if (High(STexts)<>(ord(High(TGDS_Settings))+2))or
     (High(GDS_806S_Channel)<>1)or
     (High(Labels)<>(ord(gds_an)+2))or
     (High(Buttons)<>ButtonNumber)or
     (High(InvCB)<>1)or
     (High(DisCB)<>1)or
     (High(MeasLabels)<>3)or
     (High(MeasButtons)<>2)or
     (High(MeasSpeedButtons)<>2)or
     (High(Gr)<>1)
   then
    begin
      showmessage('GDS_806S_Show is not created!');
      Exit;
    end;


  fGDS_806S:=GDS_806S;

  SettingsShowSLCreate();

  SettingsShowCreate(STexts, Labels);
  ButtonsTune(Buttons);

  CanalCheckBoxCreate(InvCB,DisCB);
  OffsetShowCreate(STexts, Labels);

  ShowCreate(GDS_806S_Channel,MeasLabels,MeasButtons,MeasSpeedButtons);

  fVectors_RG:=VecRG;
  fVectors_RG.Items.Clear;
  fVectors_RG.Items.Add('ch1');
  fVectors_RG.Items.Add('ch2');
  fVectors_RG.Items.Add('ch1/2');

 TTShow:=TTimer.Create(nil);
 TTShow.Enabled:=False;
 for I := Low(TGDS_Channel) to High(TGDS_Channel) do
  fGraphs[i]:=Gr[i-1];
 fVectorMeas:=MeasButtons[High(MeasButtons)];
 fVectorMeas.OnClick:=MeasButtonShowClick;
 TTShow.OnTimer:=MeasButtonShowClick;

 fVectorAuto:=MeasSpeedButtons[High(MeasSpeedButtons)];
 fVectorAuto.OnClick:=AutoSpeedButtonShowClick;

  fFirstSetting:=True;


end;

procedure TGDS_806Snew_Show.DefaultButtonClick(Sender: TObject);
begin
 fGDS_806S.DefaultSetting();
end;

procedure TGDS_806Snew_Show.DisplayInvertClick(Sender: TObject);
begin
 if (Sender=fDisplayCheckBox[1]) then
   if fDisplayCheckBox[1].Checked then fGDS_806S.DisplayOn(1)
                                  else fGDS_806S.DisplayOff(1);
 if (Sender=fInvertCheckBox[1]) then
   if fInvertCheckBox[1].Checked then fGDS_806S.InvertOn(1)
                                  else fGDS_806S.InvertOff(1);
 if (Sender=fDisplayCheckBox[2]) then
   if fDisplayCheckBox[2].Checked then fGDS_806S.DisplayOn(2)
                                  else fGDS_806S.DisplayOff(2);
 if (Sender=fInvertCheckBox[2]) then
   if fInvertCheckBox[2].Checked then fGDS_806S.InvertOn(2)
                                  else fGDS_806S.InvertOff(2);
end;

procedure TGDS_806Snew_Show.Free;
begin
 TTShow.Free;
 ShowFree;
 SettingsShowFree;
 SettingsShowSLFree;
 OffsetShowFree;
end;

procedure TGDS_806Snew_Show.GetSettingButtonClick(Sender: TObject);
begin
 if not(fGDS_806S.GetSetting) then Exit;

 ColorToActive(true);
 ObjectToSetting();
 fFirstSetting:=False;
end;

procedure TGDS_806Snew_Show.AutoSpeedButtonShowClick(Sender: TObject);
begin
 fVectorMeas.Enabled:=not(fVectorAuto.Down);
 if fVectorAuto.Down then TTShow.OnTimer:=fVectorMeas.OnClick;
 TTShow.Enabled:=fVectorAuto.Down;
end;

procedure TGDS_806Snew_Show.ButtonsTune(Buttons: array of TButton);
const
  ButtonCaption: array[0..ButtonNumber] of string =
  ('Set', 'Get', 'Connection Test ?', 'Save', 'Load', 'Auto', 'Default',
  'REFRESH','RUN','STOP','UNLOCK');
var
  ButtonAction: array[0..ButtonNumber] of TNotifyEvent;
  i: Integer;
begin
  ButtonAction[0] := SetSettingButtonClick;
  ButtonAction[1] := GetSettingButtonClick;
  ButtonAction[2] := TestButtonClick;
  ButtonAction[3] := SaveButtonClick;
  ButtonAction[4] := LoadButtonClick;
  ButtonAction[5] := AutoButtonClick;
  ButtonAction[6] := DefaultButtonClick;
  ButtonAction[7] := RefreshButtonClick;
  ButtonAction[8] := RunButtonClick;
  ButtonAction[9] := StopButtonClick;
  ButtonAction[10] := UnlockButtonClick;
  for I := 0 to ButtonNumber do
  begin
    Buttons[i].Caption := ButtonCaption[i];
    Buttons[i].OnClick := ButtonAction[i];
  end;
  BTest := Buttons[2];
end;

procedure TGDS_806Snew_Show.SettingsShowCreate(STexts:array of TStaticText;
                        Labels: array of TLabel);
  const
      SettingsCaption:array[TGDS_Settings]of string=
      ('Mode:','Record length:','Average Number:','TimBase',
      'CouplCh1','ProbCh1','MeasTypeCh1','ScaleCh1',
      'CouplCh2','ProbCh2','MeasTypeCh2','ScaleCh2');
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to gds_an do
   begin
   fSettingsShow[i]:=TStringParameterShow.Create(STexts[ord(i)],
                        Labels[ord(i)], SettingsCaption[i], fSettingsShowSL[i]);
   fSettingsShow[i].ForUseInShowObject(fGDS_806S);
   end;

 for I := Succ(gds_an) to High(TGDS_Settings) do
   begin
   fSettingsShow[i]:=TStringParameterShow.Create(STexts[ord(i)],
                        SettingsCaption[i], fSettingsShowSL[i]);
   fSettingsShow[i].ForUseInShowObject(fGDS_806S,False,False);
   end;
  fSettingsShow[gds_ts].HookParameterClick:=TimeScaleOkClick;
  fSettingsShow[gds_ch1_coup].HookParameterClick:=CoupleCh1OkClick;
  fSettingsShow[gds_ch2_coup].HookParameterClick:=CoupleCh2OkClick;
  fSettingsShow[gds_ch1_prob].HookParameterClick:=ProbeCh1OkClick;
  fSettingsShow[gds_ch2_prob].HookParameterClick:=ProbeCh2OkClick;
  fSettingsShow[gds_ch1_scale].HookParameterClick:=ScaleCh1OkClick;
  fSettingsShow[gds_ch2_scale].HookParameterClick:=ScaleCh2OkClick;
  fSettingsShow[gds_ch1_mtype].HookParameterClick:=MeasTypeCh1OkClick;
  fSettingsShow[gds_ch2_mtype].HookParameterClick:=MeasTypeCh2OkClick;

end;

procedure TGDS_806Snew_Show.SettingsShowFree;
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
   fSettingsShow[i].Free;
end;

procedure TGDS_806Snew_Show.LoadButtonClick(Sender: TObject);
begin
  fGDS_806S.LoadSetting(10);
  GetSettingButtonClick(Sender);
end;

procedure TGDS_806Snew_Show.MeasButtonShowClick(Sender: TObject);
begin
 case fVectors_RG.ItemIndex of
  0:begin
     TTShow.Interval:=max(2000,2*fGDS_806S.fTimeTransfer);
     fGDS_806S.GetMeasuringDataVectors(1);
     fGraphs[2].Clear;
     fGDS_806S.DataVectors[1].WriteToGraph(fGraphs[1]);
    end;
  1:begin
     TTShow.Interval:=max(2000,2*fGDS_806S.fTimeTransfer);
     fGDS_806S.GetMeasuringDataVectors(2);
     fGraphs[1].Clear;
     fGDS_806S.DataVectors[2].WriteToGraph(fGraphs[2]);
    end;
  2:begin
     TTShow.Interval:=max(2000,4*fGDS_806S.fTimeTransfer);
     fGDS_806S.GetMeasuringDataVectors(1);
     fGDS_806S.DataVectors[1].WriteToGraph(fGraphs[1]);
     fGDS_806S.GetMeasuringDataVectors(2);
     fGDS_806S.DataVectors[2].WriteToGraph(fGraphs[2]);
    end;
 end;
end;

procedure TGDS_806Snew_Show.MeasTypeCh1OkClick;
begin
 fGDS_806S.fSettings[gds_ch1_mtype]:=fSettingsShow[gds_ch1_mtype].Data;
end;

procedure TGDS_806Snew_Show.MeasTypeCh2OkClick;
begin
 fGDS_806S.fSettings[gds_ch2_mtype]:=fSettingsShow[gds_ch2_mtype].Data;
end;

procedure TGDS_806Snew_Show.ObjectToSetting;
 var i:TGDS_Settings;
     j:TGDS_Channel;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
   fSettingsShow[i].Data:=fGDS_806S.fSettings[i];

 for j := Low(TGDS_Channel) to High(TGDS_Channel) do
  begin
    AccurateCheckBoxCheckedChange(fDisplayCheckBox[j],fGDS_806S.fDisplay[j]);
    AccurateCheckBoxCheckedChange(fInvertCheckBox[j],fGDS_806S.fInvert[j]);
    fOffsetShow[j].Data:=fGDS_806S.fOffset[j];
  end;
end;

procedure TGDS_806Snew_Show.OffsetCh1Click();
begin
 fGDS_806S.SetOffset(1,fOffsetShow[1].Data);
end;

procedure TGDS_806Snew_Show.OffsetCh2Click();
begin
 fGDS_806S.SetOffset(2,fOffsetShow[2].Data);
end;

procedure TGDS_806Snew_Show.OffsetShowCreate(STexts: array of TStaticText;
                    Labels: array of TLabel);
 var i:TGDS_Channel;
begin
 for I := Low(TGDS_Channel) to High(TGDS_Channel) do
  begin
    fOffsetShow[i]:=TDoubleParameterShow.Create(STexts[High(STexts)-2+i],
                                Labels[High(Labels)-2+i],'Offset,V:',0);
    fOffsetShow[i].IniNameSalt:='Ch'+IntToStr(i);
    fOffsetShow[i].ForUseInShowObject(fGDS_806S);
  end;
 fOffsetShow[1].HookParameterClick:=OffsetCh1Click;
 fOffsetShow[2].HookParameterClick:=OffsetCh2Click;
end;

procedure TGDS_806Snew_Show.OffsetShowFree;
 var i:TGDS_Channel;
begin
 for I := Low(TGDS_Channel) to High(TGDS_Channel) do
  fOffsetShow[i].Free;
end;

procedure TGDS_806Snew_Show.ProbeCh1OkClick;
begin
 fGDS_806S.SetProb(1,fSettingsShow[gds_ch1_prob].Data);
 fSettingsShow[gds_ch1_scale].Data:=fGDS_806S.fSettings[gds_ch1_scale];
end;

procedure TGDS_806Snew_Show.ProbeCh2OkClick;
begin
  fGDS_806S.SetProb(2,fSettingsShow[gds_ch2_prob].Data);
  fSettingsShow[gds_ch2_scale].Data:=fGDS_806S.fSettings[gds_ch2_scale];
end;

procedure TGDS_806Snew_Show.ReadFromIniFile(ConfigFile: TIniFile);
 var i:TGDS_Settings;
     j:TGDS_Channel;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
  fSettingsShow[i].ReadFromIniFile(ConfigFile);


 for j := Low(TGDS_Channel) to High(TGDS_Channel) do
  begin
    AccurateCheckBoxCheckedChange(fDisplayCheckBox[j],
          ConfigFile.ReadBool(fGDS_806S.Name, 'Display'+IntTostr(j), False));
    AccurateCheckBoxCheckedChange(fInvertCheckBox[j],
          ConfigFile.ReadBool(fGDS_806S.Name, 'Invert'+IntTostr(j), False));
    fOffsetShow[j].ReadFromIniFile(ConfigFile);
  end;

  fVectors_RG.ItemIndex:= ConfigFile.ReadInteger(fGDS_806S.Name, 'ChanShow',0);
  SettingToObject();
end;

procedure TGDS_806Snew_Show.RefreshButtonClick(Sender: TObject);
begin
  fGDS_806S.Refresh();
end;

procedure TGDS_806Snew_Show.RunButtonClick(Sender: TObject);
begin
  fGDS_806S.Run();
end;

procedure TGDS_806Snew_Show.SaveButtonClick(Sender: TObject);
begin
 fGDS_806S.SaveSetting(10);
end;

procedure TGDS_806Snew_Show.ScaleCh1OkClick;
begin
 fGDS_806S.SetScale(1,fSettingsShow[gds_ch1_scale].Data);
 fSettingsShow[gds_ch1_scale].Data:=fGDS_806S.fSettings[gds_ch1_scale];
end;

procedure TGDS_806Snew_Show.ScaleCh2OkClick;
begin
 fGDS_806S.SetScale(2,fSettingsShow[gds_ch2_scale].Data);
 fSettingsShow[gds_ch2_scale].Data:=fGDS_806S.fSettings[gds_ch2_scale];
end;

procedure TGDS_806Snew_Show.SetSetting;
 function NewValue(b1,b2:byte):boolean;overload;
  begin
    Result:=(fFirstSetting)or(b1<>b2);
  end;
 var j:TGDS_Channel;
begin
 if NewValue(fGDS_806S.fSettings[gds_mode],
              fSettingsShow[gds_mode].Data) then fGDS_806S.SetMode(fSettingsShow[gds_mode].Data);
 if NewValue(fGDS_806S.fSettings[gds_rl],
              fSettingsShow[gds_rl].Data) then fGDS_806S.SetRecordLength(fSettingsShow[gds_rl].Data);
 if NewValue(fGDS_806S.fSettings[gds_an],
              fSettingsShow[gds_an].Data) then fGDS_806S.SetAverageNumber(fSettingsShow[gds_an].Data);
 if NewValue(fGDS_806S.fSettings[gds_ts],
              fSettingsShow[gds_ts].Data) then fGDS_806S.SetTimeBase(fSettingsShow[gds_ts].Data);
  if fFirstSetting then
   begin
    CoupleCh1OkClick;
    CoupleCh2OkClick;
    ProbeCh1OkClick;
    ProbeCh2OkClick;
    ScaleCh1OkClick;
    ScaleCh2OkClick;
    MeasTypeCh1OkClick();
    MeasTypeCh2OkClick();
    for j := Low(TGDS_Channel) to High(TGDS_Channel) do
     begin
      DisplayInvertClick(fDisplayCheckBox[j]);
      DisplayInvertClick(fInvertCheckBox[j]);
     end;
    OffsetCh1Click;
    OffsetCh2Click;
    fFirstSetting:=False;
   end;
end;

procedure TGDS_806Snew_Show.SetSettingButtonClick(Sender: TObject);
begin

 SetSetting();

 ColorToActive(true);
 if fGDS_806S.fSettings[gds_mode]<>2 then
   fSettingsShow[gds_an].ColorToActive(false);
end;

procedure TGDS_806Snew_Show.SettingToObject;
 var i:TGDS_Settings;
     j:TGDS_Channel;
begin
 for I := Low(TGDS_Settings) to  High(TGDS_Settings) do
 fGDS_806S.fSettings[i]:=fSettingsShow[i].Data;

 if fGDS_806S.fSettings[gds_mode]<>2 then
  begin
   fGDS_806S.fSettings[gds_an]:=0;
   fSettingsShow[gds_an].ColorToActive(false);
  end;

 for j := Low(TGDS_Channel) to High(TGDS_Channel) do
   begin
    fGDS_806S.fDisplay[j]:=fDisplayCheckBox[j].Checked;
    fGDS_806S.fInvert[j]:=fInvertCheckBox[j].Checked;
    fGDS_806S.fOffset[j]:=fOffsetShow[j].Data;
   end;
end;

procedure TGDS_806Snew_Show.StopButtonClick(Sender: TObject);
begin
  fGDS_806S.Stop();
end;

procedure TGDS_806Snew_Show.SettingsShowSLCreate();
 var i:TGDS_Settings;
    i1:TGDS_Mode;
    i2:TGDS_RecordLength;
    i3:TGDS_AverageNumber;
    i5:TGDS_TimeScale;
    i4:TGDS_ChanCoupl;
    i6:TGDS_Probe;
    i7:TGDS_VoltageScale;
    i8:TGDS_MeasureType;
begin
 for I := Low(TGDS_Settings) to gds_ch1_scale do
  begin
  fSettingsShowSL[i]:=TStringList.Create();
  fSettingsShowSL[i].Clear;
  end;
 for I1 := Low(TGDS_Mode) to High(TGDS_Mode) do
    fSettingsShowSL[gds_mode].Add(GDS_ModeLabels[i1]);
  for I2 := Low(TGDS_RecordLength) to High(TGDS_RecordLength) do
    fSettingsShowSL[gds_rl].Add(IntToStr(GDS_RecordLengthData[i2]));
  for I3 := Low(TGDS_AverageNumber) to High(TGDS_AverageNumber) do
    fSettingsShowSL[gds_an].Add(IntToStr($01 shl ord(i3)));
  for I5 := Low(TGDS_TimeScale) to High(TGDS_TimeScale) do
    fSettingsShowSL[gds_ts].Add(GDS_TimeScaleLabels[i5]);
 for I4 := Low(TGDS_ChanCoupl) to High(TGDS_ChanCoupl) do
    fSettingsShowSL[gds_ch1_coup].Add(GDS_ChanCouplLabels[i4]);
 fSettingsShowSL[gds_ch2_coup]:=fSettingsShowSL[gds_ch1_coup];

 for I6 := Low(TGDS_Probe) to High(TGDS_Probe) do
    fSettingsShowSL[gds_ch1_prob].Add(GDS_ProbeLabels[i6]);
 fSettingsShowSL[gds_ch2_prob]:=fSettingsShowSL[gds_ch1_prob];

 for I7 := Low(TGDS_VoltageScale) to High(TGDS_VoltageScale) do
    fSettingsShowSL[gds_ch1_scale].Add(GDS_VoltageScaleLabels[i7]);
 fSettingsShowSL[gds_ch2_scale]:=fSettingsShowSL[gds_ch1_scale];

 for I8 := Low(TGDS_MeasureType) to High(TGDS_MeasureType) do
    fSettingsShowSL[gds_ch1_mtype].Add(GDS_MeasureTypeLabels[i8]);
 fSettingsShowSL[gds_ch2_mtype]:=fSettingsShowSL[gds_ch1_mtype];

end;

procedure TGDS_806Snew_Show.SettingsShowSLFree;
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to gds_ch1_scale do
  fSettingsShowSL[i].Free;
end;

procedure TGDS_806Snew_Show.ShowCreate(GDS_806S_Channel:array of TGDS_806Snew_Channel;
                         MeasLabels: array of TLabel;
                         MeasButtons: array of TButton;
                         MeasSpeedButtons: array of TSpeedButton);
 var i:TGDS_Channel;
begin
 TTChan:=TTimer.Create(nil);
 TTChan.Enabled:=False;
 TTChan.Interval:=2000;
 for I := Low(TGDS_Channel) to High(TGDS_Channel) do
    fGDS_Chan_Show[i]:=TGDSnew_Chan_Show.Create(GDS_806S_Channel[i-1],
                                 MeasLabels[2*i-2],
                                 MeasLabels[2*i-1],
                                 MeasButtons[i-1],
                                 MeasSpeedButtons[i-1],
                                 TTChan);
end;

procedure TGDS_806Snew_Show.ShowFree;
 var i:TGDS_Channel;
begin
 for I := Low(TGDS_Channel) to High(TGDS_Channel) do
    fGDS_Chan_Show[i].Free;
 TTChan.Free;
end;

procedure TGDS_806Snew_Show.TestButtonClick(Sender: TObject);
begin
 if fGDS_806S.Test then
        begin
          BTest.Caption:='Connection Test - Ok';
          BTest.Font.Color:=clBlue;
        end        else
        begin
          BTest.Caption:='Connection Test - Failed';
          BTest.Font.Color:=clRed;
        end;

end;

procedure TGDS_806Snew_Show.TimeScaleOkClick;
begin
 fGDS_806S.SetTimeBase(fSettingsShow[gds_ts].Data);
end;

procedure TGDS_806Snew_Show.UnlockButtonClick(Sender: TObject);
begin
  fGDS_806S.Unlock();
end;

procedure TGDS_806Snew_Show.WriteToIniFile(ConfigFile: TIniFile);
 var i:TGDS_Settings;
     j:TGDS_Channel;
begin
  ConfigFile.EraseSection(fGDS_806S.Name);
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
  fSettingsShow[i].WriteToIniFile(ConfigFile);

 for j := Low(TGDS_Channel) to High(TGDS_Channel) do
  begin
     WriteIniDef(ConfigFile, fGDS_806S.Name, 'Invert'+IntTostr(j),
          fInvertCheckBox[j].Checked);
     WriteIniDef(ConfigFile, fGDS_806S.Name, 'Display'+IntTostr(j),
          fDisplayCheckBox[j].Checked);
     fOffsetShow[j].WriteToIniFile(ConfigFile);
  end;

 WriteIniDef(ConfigFile, fGDS_806S.Name, 'ChanShow', fVectors_RG.ItemIndex);

end;

{ TDGS_806S_Channel }

constructor TGDS_806Snew_Channel.Create(ChanelNumber: TGDS_Channel;
                        GDS_806S: TGDS_806Snew);
begin
 inherited Create;
 fChanelNumber:=ChanelNumber;
 fName:='GDS806_Ch'+inttostr(ChanelNumber);
 fParentModule:=GDS_806S;
end;

//procedure TGDS_806Snew_Channel.Free;
//begin
//
//end;

function TGDS_806Snew_Channel.GetData: double;
begin
 fValue:=fParentModule.GetMeasuringData(fChanelNumber);
 Result:=fValue;
 fNewData:=True;
end;

procedure TGDS_806Snew_Channel.GetDataThread(WPARAM: word; EventEnd: THandle);
begin
// не зробив
end;

function TGDS_806Snew_Channel.GetMeasureModeLabel: string;
begin
 if fChanelNumber=1 then
    Result:=fParentModule.MTypeToMeasureModeLabel(fParentModule.fSettings[gds_ch1_mtype])
                    else
    Result:=fParentModule.MTypeToMeasureModeLabel(fParentModule.fSettings[gds_ch2_mtype])
end;

function TGDS_806Snew_Channel.GetNewData: boolean;
begin
  Result:=fNewData;
end;

function TGDS_806Snew_Channel.GetValue: double;
begin
  Result:=fValue;
end;

procedure TGDS_806Snew_Channel.SetMeasType(MType: byte);
begin
 fParentModule.SetMeasType(fChanelNumber,MType);
end;

procedure TGDS_806Snew_Channel.SetMeasType(MType: TGDS_MeasureTypeSym);
begin
 fParentModule.SetMeasType(fChanelNumber,MType);
end;

procedure TGDS_806Snew_Channel.SetNewData(Value: boolean);
begin
  fNewData:=Value;
end;

{ TGDSnew_Chan_Show }

constructor TGDSnew_Chan_Show.Create(GDSChan: TGDS_806Snew_Channel;
                                  DL, UL: TLabel;
                                  MB: TButton;
                                  AB: TSpeedButton;
                                  TT: TTimer);
begin
 inherited Create(GDSChan,DL,UL,MB,AB,TT);
 fGDSChan:=GDSChan;
end;

function TGDSnew_Chan_Show.UnitModeLabel: string;
begin
 Result:=fGDSChan.MeasureModeLabel;
end;

{ TRS232_GDS }

constructor TRS232_GDS.Create(CP: TComPort);
begin
 inherited Create(CP,GDS_806S_PacketBeginChar,GDS_806S_PacketEndChar);
 fComPacket.MaxBufferSize:=250052;
 fComPort.Buffer.InputSize:=250052;
end;

{ TDataSubject_GDS }

procedure TDataSubject_GDS.ComPortCreare(CP: TComPort);
begin
 fRS232:=TRS232_GDS.Create(CP);
end;

{ TDataRequest_GDS }

function TDataRequest_GDS.IsNoSuccessSend: Boolean;
begin
 Result:=(fRS232.ComPort.WriteStr(StringToSend+GDS_806S_PacketEndChar)<>(Length(StringToSend)+1));
end;

procedure TDataRequest_GDS.Request;
begin
 if TestShow then showmessage('send:  '+StringToSend);
 inherited Request;
end;

end.
