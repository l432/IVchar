unit GDS_806S;

interface

uses
  RS232device, CPort, ShowTypes, StdCtrls, Classes, IniFiles, OlegType;

type

 TGDS_Settings=(gds_mode,gds_rl,gds_an,gds_ts,
                gds_ch1_coup,gds_ch2_coup);

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
{gds_ch2_coup}     (   6,         0,           3));



  GDS_MeasureTypeLabels:array[0..14]of string=
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

     fRootNode:byte;
     fFirstLevelNode:byte;
     fLeafNode:byte;
     fIsQuery:boolean;
     procedure SetFlags(RootNode,FirstLevelNode,LeafNode:byte;
                  IsQuery:boolean=False);
     procedure SetupOperation(RootNode,FirstLevelNode,LeafNode:byte);overload;
     procedure SetupOperation(Value:byte;Param:TGDS_Settings);overload;
     procedure QuireOperation(RootNode,FirstLevelNode,LeafNode:byte);
  //    procedure CombiningCommands;
     procedure DefaultSettings;
    procedure SetSettingActionCreate;
    procedure SetSettingAbsolut(Data:ArrByteGDS);
    procedure SetSettingOnOption(Data:ArrByteGDS);
    procedure SetCouplingChan1(Coupl:byte);
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
    procedure SetActiveChanelCoupling(Coupl:byte);overload;
    procedure SetActiveChanelCoupling(Coupl:TGDS_ChanCouplSym);overload;
    function GetActiveChanelCoupling():boolean;
    function GetCoupling(Chan:TGDS_Channel):boolean;

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
    procedure TimeScaleClick();
   public
    Constructor Create(GDS_806S:TGDS_806S;
                       STexts:array of TStaticText;
                       Labels:array of TLabel;
//                       ST_Mode,ST_RL:TStaticText;
//                       L_Mode,L_RL:TLabel;
                       Buttons:Array of TButton
//                       BSetSet,BGetSet,
//                       BT,BSav,BLoad,BAu,BDef:TButton
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
  fSetSettingAction[gds_ch2_coup] := SetCouplingChan1;  
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
begin
 fActiveChannel:=1;
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
  fSettings[i]:=0;
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

function TGDS_806S.GetActiveChanelCoupling: boolean;
begin
 QuireOperation(6,0,0);
 Result:=(round(Value)in[0..2]);
 if Result then  fSettings[gds_ch1_coup]:=(round(Value));
end;

function TGDS_806S.GetCoupling(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetActiveChanelCoupling();
end;

function TGDS_806S.GetMode:boolean;
begin
 QuireOperation(4,2,0);
 Result:=(round(Value)in[0..2]);
 if Result then  fSettings[gds_mode]:=(round(Value));
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

function TGDS_806S.GetSetting: boolean;
begin
 Result:=False;
 if not(GetMode) then Exit;
 if not(GetRecordLength) then Exit;
 if not(GetAverageNumber) then Exit;
 if not(GetTimeBase) then Exit;
 if not(GetCoupling(1)) then Exit;
 Result:=True;
end;

function TGDS_806S.GetTimeBase: boolean;
begin
 QuireOperation(12,0,0);
 Result:=(round(Value)in[0..30]);
 if Result then  fSettings[gds_ts]:=(round(Value));
end;

procedure TGDS_806S.LoadSetting(MemoryAdress: TGDS_MemoryAdress);
begin
 SetupOperation(1,0,MemoryAdress);
// SetFlags(1,0,MemoryAdress);
// PrepareString();
// Request();
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
        0:try
            fValue:=StrToInt(Str);
            except
             fValue:=ErResult;
            end;
     end;
    end; //fRootNode = 6;     chan
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
        0:StringToSend:=StringToSend+
                          FirstNode_6[fFirstLevelNode];
     end;
    end; //fRootNode = 6;     chan
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
  begin
  fSettings[gds_an]:=AV mod 9;
  SetupOperation(4,0,fSettings[gds_an]);
  end;
end;

procedure TGDS_806S.SetAverageNumber(AV: TGDS_AverageNumberSym);
begin
 SetAverageNumber(ord(AV));
end;

procedure TGDS_806S.SetCoupling(Chan:TGDS_Channel;Coupl:byte);
begin
 fActiveChannel:=Chan;
 SetActiveChanelCoupling(Coupl);
end;

procedure TGDS_806S.SetCouplingChan1(Coupl: byte);
begin
 SetCoupling(1,Coupl);
end;

procedure TGDS_806S.SetActiveChanelCoupling(Coupl: byte);
begin
 case fActiveChannel of
  1:begin
     fSettings[gds_ch1_coup]:=Coupl mod 3;
     SetupOperation(6,0,fSettings[gds_ch1_coup]);
    end;
  2:begin
     fSettings[gds_ch2_coup]:=Coupl mod 3;
     SetupOperation(6,0,fSettings[gds_ch2_coup]);
    end;
 end;
end;

procedure TGDS_806S.SetActiveChanelCoupling(Coupl: TGDS_ChanCouplSym);
begin
 SetActiveChanelCoupling(ord(Coupl));
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

procedure TGDS_806S.SetMode(mode: TGDS_ModeSym);
begin
 SetMode(ord(mode));
end;

procedure TGDS_806S.SetMode(mode: Byte);
begin
// SetupOperation(mode,gds_mode);

 fSettings[gds_mode]:=mode mod 3;
 SetupOperation(4,2,fSettings[gds_mode]);
end;

procedure TGDS_806S.SetRecordLength(RL: TGDS_RecordLengthSym);
begin
 SetRecordLength(ord(RL));
end;

procedure TGDS_806S.SetRecordLength(RL: Byte);
begin
 fSettings[gds_rl]:=RL mod 8;
 SetupOperation(4,1,fSettings[gds_rl]);
end;

procedure TGDS_806S.SetSettingAbsolut(Data:ArrByteGDS);
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
   fSetSettingAction[i](Data[i]);
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

procedure TGDS_806S.SetupOperation(Value:byte;Param: TGDS_Settings);
begin
 fSettings[Param]:=Value mod OperationKod[Param][2];
 SetupOperation(OperationKod[Param][0],OperationKod[Param][1],fSettings[gds_mode]);
end;

procedure TGDS_806S.SetTimeBase(TimeScale: byte);
begin
 fSettings[gds_ts]:=TimeScale mod 31;
 SetupOperation(12,0,fSettings[gds_ts]);
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

constructor TGDS_806S_Show.Create(GDS_806S: TGDS_806S;
                       STexts:array of TStaticText;
                       Labels:array of TLabel;
//                       ST_Mode,ST_RL:TStaticText;
//                       L_Mode,L_RL:TLabel;
                       Buttons:Array of TButton
//                       BSetSet,BGetSet,
//                       BT,BSav,BLoad,BAu,BDef:TButton
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
  //  fModes:=TStringList.Create();
  //  fModes.Clear;
  //  for I1 := Low(TGDS_Mode) to High(TGDS_Mode) do
  //    fModes.Add(GDS_ModeLabels[i1]);
  //  fModeShow:=TStringParameterShow.Create(ST_Mode,L_Mode,'Mode:',fModes);
  ////  fModeShow.ForUseInShowObject(fGDS_806S);
  //
  //  fRecordLengths:=TStringList.Create();
  //  fRecordLengths.Clear;
  //  for I2 := Low(TGDS_RecordLength) to High(TGDS_RecordLength) do
  //    fRecordLengths.Add(IntToStr(GDS_RecordLengthData[i2]));
  //  fRecordLengthShow:=TStringParameterShow.Create(ST_RL,L_RL,'Record length:',fRecordLengths);
  ////  fRecordLengthShow.ForUseInShowObject(fGDS_806S);

  SettingsShowCreate(STexts, Labels);
  ButtonsTune(Buttons);

//  BSetSet.Caption:='Set';
//  BSetSet.OnClick:=SetSettingButtonClick;
//
//  BGetSet.Caption:='Get';
//  BGetSet.OnClick:=GetSettingButtonClick;
//
//  BTest:=BT;
//  BTest.Caption:='Connection Test ?';
//  BTest.OnClick:=TestButtonClick;
//
//  BSav.Caption:='Save';
//  BSav.OnClick:=SaveButtonClick;
//
//  BLoad.Caption:='Load';
//  BLoad.OnClick:=LoadButtonClick;
//
//  BAu.Caption:='Auto';
//  BAu.OnClick:=AutoButtonClick;
//
//  BDef.Caption:='Default';
//  BDef.OnClick:=DefaultButtonClick;


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
      'CouplCh1','CouplCh2');
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
  fSettingsShow[gds_ts].HookParameterClick:=TimeScaleClick;
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

procedure TGDS_806S_Show.ObjectToSetting;
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
   fSettingsShow[i].Data:=fGDS_806S.fSettings[i];
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
 for I := Low(TGDS_Settings) to gds_an do
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
begin
// for I := Low(TGDS_Settings) to High(TGDS_Settings) do
 for I := Low(TGDS_Settings) to gds_ch1_coup do
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
end;

procedure TGDS_806S_Show.SettingsShowSLFree;
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to gds_ch1_coup do
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

procedure TGDS_806S_Show.TimeScaleClick;
begin
 fGDS_806S.SetTimeBase(fSettingsShow[gds_ts].Data);
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
