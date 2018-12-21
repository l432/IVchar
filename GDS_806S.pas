unit GDS_806S;

interface

uses
  RS232device, CPort, ShowTypes, StdCtrls, Classes, IniFiles, OlegType;

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

 TGDS_VoltageScale=0..10;
 TGDS_VoltageScaleSym=(gds_vs2mV,gds_vs5mV,gds_vs10mV,gds_vs20mV,gds_vs50mV,
                 gds_vs100mV,gds_vs200mV,gds_vs500mV,gds_vs1V,
                 gds_vs2V,gds_vs5V);

 TGDS_Probe=0..2;
 TGDS_ProbeSym=(gds_p1X,gds_p10X,gds_p100X);

 TGDS_MeasureType=0..14;
 TGDS_MeasureTypeSym=(gds_m_ft,gds_m_fr,gds_m_npt,gds_m_dr,gds_m_pr,
              gds_m_ppt,gds_m_rt,gds_m_vamp,gds_m_avv,gds_m_hv,
              gds_m_lv,gds_m_maxamp,gds_m_minamp,gds_m_vpp,gds_m_rms);


 ArrByteGDS=array[TGDS_Settings]of byte;

const
  GDS_806S_PacketBeginChar='';
  GDS_806S_PacketEndChar=#10;

  GDS_806S_Test='GW,GDS-806S,EF211754,V1.10';

  RootNood:array[0..12]of string=
  ('*idn','*rcl','*rst','*sav',':acq',':aut',':chan',':meas',':refr',
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
{gds_ch2_coup}     (   6,         0,           3),
{gds_ch1_coup}     (   6,         4,           3),
{gds_ch2_coup}     (   6,         4,           3),
{gds_ch1_scale}    (   6,         5,           11),
{gds_ch2_scale}    (   6,         5,           11),
{gds_ch1_mtype}    (   7,         0,           15),
{gds_ch2_mtype}    (   7,         0,           15));

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
 ('2mV','5mV','10mV','20mV','50mV','100mV','200mV','500mV',
  '1V','2V','5V');

 GDS_VoltageScaleData:array[TGDS_VoltageScale]of string=
 ('0.002','0.005','0.01','0.02','0.05','0.1','0.2','0.5','1','2','5');



  ButtonNumber = 10;

type
//  TGDS_806S_Parameters=class
//  private
//  public
//   Mode:TGDS_Mode;
//   ActiveChannel:TGDS_Channel;
//   RecordLength:TGDS_RecordLength;
//   procedure SetDataShort(Mode,RecordLength:byte);
//   procedure SetData(Mode,Channel,RecordLength:byte);
//  end;

  TGDS_806S=class(TRS232Meter)
   private
     fSettings:ArrByteGDS;
     fSetSettingAction:array[TGDS_Settings]of TByteEvent;
  //   fParam:TGDS_806S_Parameters;
  //   fMode:TGDS_Mode;
     fActiveChannel:TGDS_Channel;
  //   fRecordLength:TGDS_RecordLength;

     fInvert:array[TGDS_Channel]of Boolean;
     fDisplay:array[TGDS_Channel]of Boolean;
     fRootNode:byte;
     fFirstLevelNode:byte;
     fLeafNode:byte;
     fIsQuery:boolean;
     procedure SetFlags(RootNode,FirstLevelNode,LeafNode:byte;
                  IsQuery:boolean=False);
     procedure SetupOperation(RootNode,FirstLevelNode,LeafNode:byte);overload;
     procedure SetupOperation(Value:byte;Param:TGDS_Settings);overload;
     procedure SetupOperation(Value:byte;ParamCh1,ParamCh2:TGDS_Settings);overload;
     procedure QuireOperation(RootNode,FirstLevelNode,LeafNode:byte);
     function GetParam(Param:TGDS_Settings):boolean;overload;
     function GetParam(ParamCh1,ParamCh2:TGDS_Settings):boolean;overload;
  //    procedure CombiningCommands;
     procedure DefaultSettings;
    procedure SetSettingActionCreate;
    procedure SetSettingAbsolut(Data:ArrByteGDS);
    procedure SetSettingOnOption(Data:ArrByteGDS);
    procedure SetCouplingChan1(Coupl:byte);
    procedure SetCouplingChan2(Coupl:byte);
    procedure SetProbChan1(Prob:byte);
    procedure SetProbChan2(Prob:byte);
    procedure SetScaleChan1(Scale:byte);
    procedure SetScaleChan2(Scale:byte);
    procedure SetMeasTypeChan1(MType:byte);
    procedure SetMeasTypeChan2(MType:byte);
    function GDS_StringToValue(Str:string):double;
    function MTypeToMeasureModeLabel(MType:byte):string;
  protected
     procedure PrepareString;
     Procedure PacketReceiving(Sender: TObject; const Str: string);override;
   public
    property ActiveChannel:TGDS_Channel read FActiveChannel write FActiveChannel;
    Constructor Create(CP:TComPort;Nm:string);
//    procedure Free;
    procedure Request();override;

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
  end;

 TGDS_806S_Show=class
   private
    fGDS_806S:TGDS_806S;
    fSettingsShow:array[TGDS_Settings]of TStringParameterShow;
    fSettingsShowSL:array[TGDS_Settings]of TStringList;
//    fModeShow:TStringParameterShow;
//    fModes:TStringList;
//    fRecordLengthShow:TStringParameterShow;
//    fRecordLengths:TStringList;
//    BSetSetting:TButton;
//    BGetSetting:TButton;
    BTest:TButton;

    fInvertCheckBox:array[TGDS_Channel]of TCheckBox;
    fDisplayCheckBox:array[TGDS_Channel]of TCheckBox;

//    if IVchar.Components[i].Tag in [6,7] then
//     WriteIniDef(ConfigFile, 'Box', (IVchar.Components[i] as TCheckBox).Name,
//       (IVchar.Components[i] as TCheckBox).Checked);

//     (IVchar.Components[i] as TCheckBox).Checked:=
//       ConfigFile.ReadBool('Box', (IVchar.Components[i] as TCheckBox).Name, False);
    fFirstSetting:boolean;
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
    procedure SettingsShowSLCreate();
    procedure SettingsShowSLFree();
    procedure SettingsShowCreate(STexts:array of TStaticText;
                        Labels: array of TLabel);
    procedure SettingsShowFree();
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
   public
    Constructor Create(GDS_806S:TGDS_806S;
                       STexts:array of TStaticText;
                       Labels:array of TLabel;
                       Buttons:Array of TButton;
                       InvertCBCh1,InvertCBCh2,
                       DisplayCBCh1,DisplayCBCh2: TCheckBox
                       );
    Procedure Free;
    procedure ReadFromIniFile(ConfigFile:TIniFile);
    procedure WriteToIniFile(ConfigFile:TIniFile);
    procedure SettingToObject;
    procedure ObjectToSetting;
    function Help():shortint;

 end;

var
  StringToSend:string;

implementation

uses
  Dialogs, Controls, SysUtils, Graphics;

{ TGDS_806S }

//procedure TGDS_806S.CombiningCommands;
//begin
// if StringToSend<>'' then
//  StringToSend:=StringToSend+';';
//end;

procedure TGDS_806S.AutoSetting;
begin
 SetupOperation(5,0,0);
end;

procedure TGDS_806S.SetSettingActionCreate;
begin
  fSetSettingAction[gds_mode] := SetMode;
  fSetSettingAction[gds_rl] := SetRecordLength;
  fSetSettingAction[gds_an] := SetAverageNumber;
  fSetSettingAction[gds_ts] := SetTimeBase;
  fSetSettingAction[gds_ch1_coup] := SetCouplingChan1;
  fSetSettingAction[gds_ch2_coup] := SetCouplingChan2;
  fSetSettingAction[gds_ch1_prob] := SetProbChan1;
  fSetSettingAction[gds_ch2_prob] := SetProbChan2;
  fSetSettingAction[gds_ch1_scale] := SetScaleChan1;
  fSetSettingAction[gds_ch2_scale] := SetScaleChan2;
  fSetSettingAction[gds_ch1_mtype] := SetMeasTypeChan1;
  fSetSettingAction[gds_ch2_mtype] := SetMeasTypeChan2;
end;

constructor TGDS_806S.Create(CP: TComPort; Nm: string);
begin
 inherited Create(CP,Nm);
// fParam:=TGDS_806S_Parameters.Create;
 RepeatInErrorCase:=True;
 fComPacket.MaxBufferSize:=250052;
 fComPacket.StartString := GDS_806S_PacketBeginChar;
 fComPacket.StopString := GDS_806S_PacketEndChar;
 DefaultSettings();
 SetSettingActionCreate;

// fMode:=gds_msam;
// fActiveChannel:=1;
// fRecordLength:=gds_rl500;

 SetFlags(0,0,0,true);
end;

procedure TGDS_806S.DefaultSetting;
begin
 SetupOperation(2,0,0);
end;

procedure TGDS_806S.DefaultSettings;
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
   end;
end;

procedure TGDS_806S.DisplayOff(Chan: TGDS_Channel);
begin
 fActiveChannel:=Chan;
 fDisplay[fActiveChannel]:=False;
 SetupOperation(6,1,0);
end;

procedure TGDS_806S.DisplayOn(Chan: TGDS_Channel);
begin
 fActiveChannel:=Chan;
 fDisplay[fActiveChannel]:=True;
 SetupOperation(6,1,1);
end;

//procedure TGDS_806S.Free;
//begin
// fParam.Free;
//end;

function TGDS_806S.GetAverageNumber: boolean;
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

function TGDS_806S.GDS_StringToValue(Str: string): double;
begin
  try
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
   Result:=StrToFloat(Copy(Str,1,4));
  except
   Result:=ErResult;
  end;
end;

function TGDS_806S.GetActiveChanelCoupling: boolean;
begin
 Result:=GetParam(gds_ch1_coup,gds_ch2_coup);
// QuireOperation(6,0,0);
// Result:=(round(Value)in[0..2]);
// if Result then  fSettings[gds_ch1_coup]:=(round(Value));
end;

function TGDS_806S.GetActiveChannelProb: boolean;
begin
 Result:=GetParam(gds_ch1_prob,gds_ch2_prob);
// QuireOperation(6,4,0);
// Result:=(round(Value)in[0..2]);
// if Result then  fSettings[gds_ch1_coup]:=(round(Value));
end;

function TGDS_806S.GetActiveChannelScale: boolean;
begin
 Result:=GetParam(gds_ch1_scale,gds_ch2_scale);
end;

function TGDS_806S.GetActiveChannelDisplay: boolean;
begin
 QuireOperation(6,1,0);
 Result:=round(Value)in[0..1];
 fDisplay[fActiveChannel]:=(round(Value)=1)
end;

function TGDS_806S.GetActiveChannelInvert: boolean;
begin
 QuireOperation(6,2,0);
 Result:=round(Value)in[0..1];
 fInvert[fActiveChannel]:=(round(Value)=1)
end;

function TGDS_806S.GetParam(Param: TGDS_Settings): boolean;
begin
 QuireOperation(OperationKod[Param,0],OperationKod[Param,1],0);
 Result:=(round(Value)<OperationKod[Param,2]);
 if Result then  fSettings[Param]:=(round(Value));
end;

function TGDS_806S.GetCoupling(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetActiveChanelCoupling();
end;

function TGDS_806S.GetDisplay(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetActiveChannelDisplay();
end;

function TGDS_806S.GetInvert(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetActiveChannelInvert();
end;

function TGDS_806S.GetMeasuringData(Chan:TGDS_Channel): double;
begin
  case Chan of
  1:QuireOperation(7,fSettings[gds_ch1_mtype],1);
  2:QuireOperation(7,fSettings[gds_ch2_mtype],2);
 end;
 Result:=Value;
end;

function TGDS_806S.GetMode:boolean;
begin
 Result:=GetParam(gds_mode);
// QuireOperation(4,2,0);
// Result:=(round(Value)in[0..2]);
// if Result then  fSettings[gds_mode]:=(round(Value));
end;

function TGDS_806S.GetParam(ParamCh1, ParamCh2: TGDS_Settings): boolean;
begin
 case fActiveChannel of
  1:Result:=GetParam(ParamCh1);
  else Result:=GetParam(ParamCh2);
 end;
end;

function TGDS_806S.GetProb(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetActiveChannelProb();
end;

function TGDS_806S.GetRecordLength: boolean;
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

function TGDS_806S.GetScale(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetActiveChannelScale();
end;

function TGDS_806S.GetSetting: boolean;
begin
 Result:=False;
 if not(GetMode) then Exit;
 if not(GetRecordLength) then Exit;
 if not(GetAverageNumber) then Exit;
 if not(GetTimeBase) then Exit;
 fActiveChannel:=2;
 if not(GetParam(gds_ch2_coup)) then Exit;
 if not(GetParam(gds_ch2_prob)) then Exit;
 if not(GetActiveChannelDisplay()) then Exit;
 if not(GetActiveChannelInvert()) then Exit;
// if not(GetCoupling(1)) then Exit;
 fActiveChannel:=1;
 if not(GetParam(gds_ch1_coup)) then Exit;
 if not(GetParam(gds_ch1_prob)) then Exit;
 if not(GetActiveChannelDisplay()) then Exit;
 if not(GetActiveChannelInvert()) then Exit;
 Result:=True;
end;

function TGDS_806S.GetTimeBase: boolean;
begin
 Result:=GetParam(gds_ts);
// QuireOperation(12,0,0);
// Result:=(round(Value)in[0..30]);
// if Result then  fSettings[gds_ts]:=(round(Value));
end;

procedure TGDS_806S.InvertOff(Chan: TGDS_Channel);
begin
 fActiveChannel:=Chan;
 fInvert[fActiveChannel]:=False;
 SetupOperation(6,2,0);
end;

procedure TGDS_806S.InvertOn(Chan: TGDS_Channel);
begin
 fActiveChannel:=Chan;
 fInvert[fActiveChannel]:=True;
 SetupOperation(6,2,1);
end;

procedure TGDS_806S.LoadSetting(MemoryAdress: TGDS_MemoryAdress);
begin
 SetupOperation(1,0,MemoryAdress);
// SetFlags(1,0,MemoryAdress);
// PrepareString();
// Request();
end;

function TGDS_806S.MTypeToMeasureModeLabel(MType: byte): string;
begin
 case Mtype of
  0,2,4..6:Result:='s';
  1:Result:='Hz';
  7..14:Result:='V';
  else Result:='';
 end;
end;

procedure TGDS_806S.PacketReceiving(Sender: TObject; const Str: string);
var
  I: TGDS_TimeScale;
begin
 case fRootNode of
  0:if Str=GDS_806S_Test then fValue:=314;
  4:begin
     case fFirstLevelNode of
        0..2:try
            fValue:=StrToInt(Str);
            except
             fValue:=ErResult;
            end;
     end;
    end; //fRootNode = 4;  acq
  6:begin
     case fFirstLevelNode of
        0..2,4:try
            fValue:=StrToInt(Str);
            except
             fValue:=ErResult;
            end;
        5:begin
           fValue:=ErResult;
           for I := Low(TGDS_VoltageScale) to High(TGDS_VoltageScale) do
             if Str=GDS_VoltageScaleLabels[i] then
               begin
               fValue:=ord(i);
               Break;
               end;
         end;
     end;
    end; //fRootNode = 6;     chan
   7:Value:=GDS_StringToValue(Str);
  12:begin
     fValue:=ErResult;
     for I := Low(TGDS_TimeScale) to High(TGDS_TimeScale) do
       if Str=GDS_TimeScaleLabels[i] then
         begin
         fValue:=ord(i);
         Break;
         end;
    end; //fRootNode = 12; time scale
 end; //case fRootNode of

fIsReceived:=True;
//fValue:=0;
//showmessage('recived:  '+STR);


end;

procedure TGDS_806S.PrepareString;
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
    end; //fRootNode = 4;  acq
  6:begin
     StringToSend:=StringToSend+IntToStr(fActiveChannel)+':';
     case fFirstLevelNode of
        0..2,4:StringToSend:=StringToSend+
                          FirstNode_6[fFirstLevelNode];
        5:begin
           StringToSend:=StringToSend+
                          FirstNode_6[fFirstLevelNode];
           if fIsQuery then
             StringToSend:=StringToSend+'?'
                       else
                 begin
                   if fActiveChannel=1 then
                      StringToSend:=StringToSend+' '+
                         GDS_VoltageScaleData[TGDS_VoltageScale(fSettings[gds_ch1_scale])]
                                       else
                      StringToSend:=StringToSend+' '+
                         GDS_VoltageScaleData[TGDS_VoltageScale(fSettings[gds_ch2_scale])];
                 end;
           Exit;
          end;
     end;
    end; //fRootNode = 6;     chan
   7:begin
      StringToSend:=StringToSend+':'+FirstNode_7[15]+' '+Inttostr(fLeafNode)+
      ';'+RootNood[fRootNode]+':'+FirstNode_7[fFirstLevelNode]+'?';
      Exit;
     end;
  12:begin
     if fIsQuery then
       StringToSend:=StringToSend+'?'
                 else
       StringToSend:=StringToSend+' '+
       GDS_TimeScaleData[TGDS_TimeScale(fSettings[gds_ts])];
     Exit;
    end; //fRootNode = 12; time scale
 end; //case fRootNode of
 if fIsQuery then StringToSend:=StringToSend+'?'
             else StringToSend:=StringToSend+' '+IntToStr(fLeafNode);

end;

procedure TGDS_806S.QuireOperation(RootNode, FirstLevelNode, LeafNode: byte);
begin
 SetFlags(RootNode, FirstLevelNode, LeafNode, True);
 PrepareString();
 GetData;
end;

procedure TGDS_806S.Refresh;
begin
  SetupOperation(8,0,0);
end;

procedure TGDS_806S.Request;
begin
// StringToSend:=':acq:mod 0';
// StringToSend:='*idn?';
// StringToSend:=':meas:vpp?';
//showmessage('send:  '+StringToSend);
 if fComPort.Connected then
  begin
   fComPort.AbortAllAsync;
   fComPort.ClearBuffer(True, True);
   fError:=(fComPort.WriteStr(StringToSend+GDS_806S_PacketEndChar)<>(Length(StringToSend)+1));
  end
                      else
   fError:=True;
end;

procedure TGDS_806S.Run;
begin
  SetupOperation(9,0,0);
end;

procedure TGDS_806S.SaveSetting(MemoryAdress: TGDS_MemoryAdress);
begin
 SetupOperation(3,0,MemoryAdress);
// SetFlags(3,0,MemoryAdress);
// PrepareString();
// Request();
end;

procedure TGDS_806S.SetAverageNumber(AV: Byte);
begin
 if fSettings[gds_mode]=2 then
  SetupOperation(AV,gds_an);
//  begin
//  fSettings[gds_an]:=AV mod 9;
//  SetupOperation(4,0,fSettings[gds_an]);
//  end;
end;

procedure TGDS_806S.SetAverageNumber(AV: TGDS_AverageNumberSym);
begin
 SetAverageNumber(ord(AV));
end;

procedure TGDS_806S.SetCoupling(Chan:TGDS_Channel;Coupl:byte);
begin
 fActiveChannel:=Chan;
 SetupOperation(Coupl,gds_ch1_coup,gds_ch2_coup)
// SetActiveChanelCoupling(Coupl);
end;

procedure TGDS_806S.SetCouplingChan1(Coupl: byte);
begin
 SetCoupling(1,Coupl);
end;

procedure TGDS_806S.SetCouplingChan2(Coupl: byte);
begin
 SetCoupling(2,Coupl);
end;

procedure TGDS_806S.SetActiveChannelCoupling(Coupl: byte);
begin
 SetupOperation(Coupl,gds_ch1_coup,gds_ch2_coup);
// case fActiveChannel of
//  1:begin
//     fSettings[gds_ch1_coup]:=Coupl mod 3;
//     SetupOperation(6,0,fSettings[gds_ch1_coup]);
//    end;
//  2:begin
//     fSettings[gds_ch2_coup]:=Coupl mod 3;
//     SetupOperation(6,0,fSettings[gds_ch2_coup]);
//    end;
// end;
end;

procedure TGDS_806S.SetActiveChannelCoupling(Coupl: TGDS_ChanCouplSym);
begin
 SetActiveChannelCoupling(ord(Coupl));
end;


procedure TGDS_806S.SetFlags(RootNode, FirstLevelNode,
                            LeafNode: byte;
                            IsQuery: boolean);
begin
 fRootNode:=RootNode;
 fFirstLevelNode:=FirstLevelNode;
 fLeafNode:=LeafNode;
 fIsQuery:=IsQuery;
end;

procedure TGDS_806S.SetMeasType(Chan: TGDS_Channel; MType: byte);
begin
 fActiveChannel:=Chan;
 case fActiveChannel of
  1:fSettings[gds_ch1_mtype]:=MType mod OperationKod[gds_ch1_mtype,2];
  2:fSettings[gds_ch2_mtype]:=MType mod OperationKod[gds_ch2_mtype,2];
 end;
end;

procedure TGDS_806S.SetMeasType(Chan: TGDS_Channel; MType: TGDS_MeasureTypeSym);
begin
 SetMeasType(Chan,ord(MType));
end;

procedure TGDS_806S.SetMeasTypeChan1(MType: byte);
begin
 fSettings[gds_ch1_mtype]:=MType mod OperationKod[gds_ch1_mtype,2];
// SetMeasType(1,MType);
end;

procedure TGDS_806S.SetMeasTypeChan2(MType: byte);
begin
 fSettings[gds_ch2_mtype]:=MType mod OperationKod[gds_ch2_mtype,2];
//  SetMeasType(2,MType);
end;

procedure TGDS_806S.SetMode(mode: TGDS_ModeSym);
begin
 SetMode(ord(mode));
end;

procedure TGDS_806S.SetProb(Chan: TGDS_Channel; Prob: byte);
begin
 fActiveChannel:=Chan;
 SetupOperation(Prob,gds_ch1_prob,gds_ch2_prob);
end;

procedure TGDS_806S.SetProbChan1(Prob: byte);
begin
  SetProb(1,Prob);
end;

procedure TGDS_806S.SetProbChan2(Prob: byte);
begin
  SetProb(2,Prob);
end;

procedure TGDS_806S.SetMode(mode: Byte);
begin
 SetupOperation(mode,gds_mode);
// fSettings[gds_mode]:=mode mod 3;
// SetupOperation(4,2,fSettings[gds_mode]);
end;

procedure TGDS_806S.SetRecordLength(RL: TGDS_RecordLengthSym);
begin
 SetRecordLength(ord(RL));
end;

procedure TGDS_806S.SetRecordLength(RL: Byte);
begin
 SetupOperation(RL,gds_rl);
// fSettings[gds_rl]:=RL mod 8;
// SetupOperation(4,1,fSettings[gds_rl]);
end;

procedure TGDS_806S.SetScale(Chan: TGDS_Channel; Scale: byte);
begin
 fActiveChannel:=Chan;
 SetupOperation(Scale,gds_ch1_scale,gds_ch2_scale);
end;

procedure TGDS_806S.SetScaleChan1(Scale: byte);
begin
 SetScale(1,Scale);
end;

procedure TGDS_806S.SetScaleChan2(Scale: byte);
begin
 SetScale(2,Scale);
end;

procedure TGDS_806S.SetSettingAbsolut(Data:ArrByteGDS);
 var i:TGDS_Settings;
     j:TGDS_Channel;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
   fSetSettingAction[i](Data[i]);
 for j := Low(TGDS_Channel) to High(TGDS_Channel) do
  begin
    if fDisplay[j] then DisplayOn(j)
                   else DisplayOff(j);
    if fInvert[j] then InvertOn(j)
                  else InvertOff(j);
  end;
end;

procedure TGDS_806S.SetSettingOnOption(Data:ArrByteGDS);
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
   if (Data[i]<>fSettings[i])
     then fSetSettingAction[i](Data[i]);
end;

procedure TGDS_806S.SetTimeBase(TimeScale: TGDS_TimeScaleSym);
begin
 SetTimeBase(ord(TimeScale));
end;

procedure TGDS_806S.SetupOperation(Value: byte;
                              ParamCh1,ParamCh2: TGDS_Settings);
begin
 case fActiveChannel of
  1:SetupOperation(Value,ParamCh1);
  2:SetupOperation(Value,ParamCh2);
 end;
end;

procedure TGDS_806S.SetupOperation(Value:byte;Param: TGDS_Settings);
begin
 fSettings[Param]:=Value mod OperationKod[Param,2];
 SetupOperation(OperationKod[Param,0],OperationKod[Param,1],fSettings[Param]);
end;

procedure TGDS_806S.SetTimeBase(TimeScale: byte);
begin
 SetupOperation(TimeScale,gds_ts);
// fSettings[gds_ts]:=TimeScale mod 31;
// SetupOperation(12,0,fSettings[gds_ts]);
end;

procedure TGDS_806S.SetupOperation(RootNode, FirstLevelNode, LeafNode: byte);
begin
 SetFlags(RootNode, FirstLevelNode, LeafNode);
 PrepareString();
 Request();
end;

procedure TGDS_806S.Stop;
begin
  SetupOperation(10,0,0);
end;

function TGDS_806S.Test: boolean;
begin
 QuireOperation(0,0,0);
 Result:=(Value=314);
// SetFlags(0,0,0,true);
// PrepareString();
// Result:=(GetData=314);
end;

procedure TGDS_806S.Unlock;
begin
   SetupOperation(11,0,0);
end;

{ TGDS_806S_Show }

procedure TGDS_806S_Show.AutoButtonClick(Sender: TObject);
begin
 fGDS_806S.AutoSetting();
end;

procedure TGDS_806S_Show.ColorToActive(Value: boolean);
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
   fSettingsShow[i].ColorToActive(Value);
end;

procedure TGDS_806S_Show.CoupleCh1OkClick;
begin
 fGDS_806S.SetCouplingChan1(fSettingsShow[gds_ch1_coup].Data);
end;

procedure TGDS_806S_Show.CoupleCh2OkClick;
begin
 fGDS_806S.SetCouplingChan2(fSettingsShow[gds_ch2_coup].Data);
end;

constructor TGDS_806S_Show.Create(GDS_806S: TGDS_806S;
                       STexts:array of TStaticText;
                       Labels:array of TLabel;
                       Buttons:Array of TButton;
                       InvertCBCh1,InvertCBCh2,
                       DisplayCBCh1,DisplayCBCh2: TCheckBox
                                  );
begin
  if (High(STexts)<>ord(High(TGDS_Settings)))or
     (High(Labels)<>ord(gds_an))or
     (High(Buttons)<>ButtonNumber)
   then
    begin
      showmessage('GDS_806S_Show is not created!');
      Exit;
    end;
  

  fGDS_806S:=GDS_806S;

  SettingsShowSLCreate();

  SettingsShowCreate(STexts, Labels);
  ButtonsTune(Buttons);

  fFirstSetting:=True;


end;

procedure TGDS_806S_Show.DefaultButtonClick(Sender: TObject);
begin
 fGDS_806S.DefaultSetting();
end;

procedure TGDS_806S_Show.Free;
// var i:byte;
begin
 SettingsShowFree;
 SettingsShowSLFree;
// for I := 0 to High(fParamVariants) do
//   fParamVariants[i].Free;
// fRecordLengthShow.Free;
// fRecordLengths.Free;
// fModeShow.Free;
// fModes.Free;
end;

procedure TGDS_806S_Show.GetSettingButtonClick(Sender: TObject);
begin
 if not(fGDS_806S.GetSetting) then Exit;

 ColorToActive(true);
// fModeShow.ColorToActive(true);
// fRecordLengthShow.ColorToActive(true);
 ObjectToSetting();
 fFirstSetting:=False;
end;

function TGDS_806S_Show.Help: shortint;
begin
// fGDS_806S.QuireOperation(4,0,0);
 Result:=1;
// fGDS_806S.fMode:=TGDS_Mode(15);
//fGDS_806S.SetMode(fGDS_806S.fMode);
// Result:=fModeShow.Data;
end;

procedure TGDS_806S_Show.ButtonsTune(Buttons: array of TButton);
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

//procedure TGDS_806S_Show.SettingsShowCreate(STexts:ArrSTSet;
//                       Labels: ArrLabSet);
procedure TGDS_806S_Show.SettingsShowCreate(STexts:array of TStaticText;
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

//  ForUseInShowObject(fGDS_806S);
//  fSettingsShow[gds_ch1_coup].ForUseInShowObject(fGDS_806S,False,False);

//  fSettingsShow[gds_ch1_coup].IniNameSalt:='_ch1';
//  fSettingsShow[gds_ch1_coup].ColorChangeWithParameter:=False;
end;

procedure TGDS_806S_Show.SettingsShowFree;
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
   fSettingsShow[i].Free;
end;

procedure TGDS_806S_Show.LoadButtonClick(Sender: TObject);
begin
  fGDS_806S.LoadSetting(10);
  GetSettingButtonClick(Sender);
end;

procedure TGDS_806S_Show.MeasTypeCh1OkClick;
begin
  fGDS_806S.SetMeasTypeChan1(fSettingsShow[gds_ch1_scale].Data);
end;

procedure TGDS_806S_Show.MeasTypeCh2OkClick;
begin
  fGDS_806S.SetMeasTypeChan2(fSettingsShow[gds_ch2_scale].Data);
end;

procedure TGDS_806S_Show.ObjectToSetting;
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
   fSettingsShow[i].Data:=fGDS_806S.fSettings[i];
end;

procedure TGDS_806S_Show.ProbeCh1OkClick;
begin
  fGDS_806S.SetProbChan1(fSettingsShow[gds_ch1_prob].Data);
end;

procedure TGDS_806S_Show.ProbeCh2OkClick;
begin
  fGDS_806S.SetProbChan2(fSettingsShow[gds_ch2_prob].Data);
end;

procedure TGDS_806S_Show.ReadFromIniFile(ConfigFile: TIniFile);
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
  fSettingsShow[i].ReadFromIniFile(ConfigFile);
// fModeShow.ReadFromIniFile(ConfigFile);
// fRecordLengthShow.ReadFromIniFile(ConfigFile);
end;

procedure TGDS_806S_Show.RefreshButtonClick(Sender: TObject);
begin
  fGDS_806S.Refresh();
end;

procedure TGDS_806S_Show.RunButtonClick(Sender: TObject);
begin
  fGDS_806S.Run();
end;

procedure TGDS_806S_Show.SaveButtonClick(Sender: TObject);
begin
 fGDS_806S.SaveSetting(10);
end;

procedure TGDS_806S_Show.ScaleCh1OkClick;
begin
 fGDS_806S.SetScaleChan1(fSettingsShow[gds_ch1_scale].Data);
end;

procedure TGDS_806S_Show.ScaleCh2OkClick;
begin
 fGDS_806S.SetScaleChan2(fSettingsShow[gds_ch2_scale].Data);
end;

procedure TGDS_806S_Show.SetSettingButtonClick(Sender: TObject);
 var data:ArrByteGDS;
     i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
   data[i]:=fSettingsShow[i].Data;
 if fFirstSetting then
   begin
     fGDS_806S.SetSettingAbsolut(data);
     fFirstSetting:=False;
   end
               else
     fGDS_806S.SetSettingOnOption(data);


 ColorToActive(true);
// fModeShow.ColorToActive(true);
// fRecordLengthShow.ColorToActive(true);
 SettingToObject();

end;

procedure TGDS_806S_Show.SettingToObject;
 var i:TGDS_Settings;
begin
// for I := Low(TGDS_Settings) to gds_an do
 for I := Low(TGDS_Settings) to  High(TGDS_Settings) do
 fGDS_806S.fSettings[i]:=fSettingsShow[i].Data;

 if fGDS_806S.fSettings[gds_mode]<>2 then
  begin
   fGDS_806S.fSettings[gds_an]:=0;
   fSettingsShow[gds_an].ColorToActive(false);
  end;

end;

procedure TGDS_806S_Show.StopButtonClick(Sender: TObject);
begin
  fGDS_806S.Stop();
end;

procedure TGDS_806S_Show.SettingsShowSLCreate();
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
// for I := Low(TGDS_Settings) to High(TGDS_Settings) do
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

procedure TGDS_806S_Show.SettingsShowSLFree;
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to gds_ch1_scale do
// for I := Low(TGDS_Settings) to High(TGDS_Settings) do
  fSettingsShowSL[i].Free;
end;

procedure TGDS_806S_Show.TestButtonClick(Sender: TObject);
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

procedure TGDS_806S_Show.TimeScaleOkClick;
begin
 fGDS_806S.SetTimeBase(fSettingsShow[gds_ts].Data);
// fGDS_806S.SetupOperation(fSettingsShow[gds_ts].Data,gds_ts)
end;

procedure TGDS_806S_Show.UnlockButtonClick(Sender: TObject);
begin
  fGDS_806S.Unlock();
end;

procedure TGDS_806S_Show.WriteToIniFile(ConfigFile: TIniFile);
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
  fSettingsShow[i].WriteToIniFile(ConfigFile);
end;

//{ TGDS_806S_Parameters }
//
//procedure TGDS_806S_Parameters.SetData(Mode, Channel, RecordLength: byte);
//begin
//  SetDataShort(Mode, RecordLength);
//  Self.ActiveChannel:=TGDS_Channel(Channel);
//end;
//
//procedure TGDS_806S_Parameters.SetDataShort(Mode, RecordLength: byte);
//begin
// Self.Mode:=TGDS_Mode(Mode);
// Self.RecordLength:=TGDS_RecordLength(RecordLength);
//end;

end.
