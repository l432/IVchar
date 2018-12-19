unit GDS_806S;

interface

uses
  RS232device, CPort, ShowTypes, StdCtrls, Classes, IniFiles, OlegType;

type

 TGDS_Settings=(gds_mode,gds_rl,gds_an,gds_ch1_coup);

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

 TGDS_TimeScale=(gds_ts1ns,gds_ts2_5ns,gds_ts5ns,gds_ts10ns,gds_ts25ns,
                 gds_ts50ns,gds_ts100ns,gds_ts250ns,gds_ts500ns,gds_ts1us,
                 gds_ts2_5us,gds_ts5us,gds_ts10us,gds_ts25us,gds_ts50us,
                 gds_ts100us,gds_ts250us,gds_ts500us,gds_ts1ms,gds_ts2_5ms,
                 gds_ts5ms,gds_ts10ms,gds_ts25ms,gds_ts50ms,gds_ts100ms,
                 gds_ts250ms,gds_ts500ms,gds_ts1s,gds_ts2_5s,gds_ts5s,gds_ts10s);

 TGDS_VoltageScale=(gds_vs2mV,gds_vs5mV,gds_vs10mV,gds_vs20mV,gds_vs50mV,
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
   ('1ns','2.5ns','5ns','10ns','25ns','50ns','100ns','250ns',
   '500ns','1us','2.5us','5us','10us','25us','50us','100us',
   '250us','500us','1ms','2.5ms','5ms','10ms','25ms','50ms',
   '100ms','250ms','500ms','1s','2.5s','5s','10s');

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
     procedure SetupOperation(RootNode,FirstLevelNode,LeafNode:byte);
     procedure QuireOperation(RootNode,FirstLevelNode,LeafNode:byte);
     procedure PrepareString;
  //    procedure CombiningCommands;
     procedure DefaultSettings;
    procedure SetSettingActionCreate;
    procedure SetSettingAbsolut(Data:ArrByteGDS);
    procedure SetSettingOnOption(Data:ArrByteGDS);
   protected
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
    procedure SetCoupling(Chan:TGDS_Channel;Coupl:byte);overload;
    procedure SetCoupling(Coupl:byte);overload;
    procedure SetCoupling(Coupl:TGDS_ChanCouplSym);overload;
    function GetCoupling():boolean;overload;
    function GetCoupling(Chan:TGDS_Channel):boolean;overload;
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

function TGDS_806S.GetCoupling: boolean;
begin
 QuireOperation(6,0,0);
 Result:=(round(Value)in[0..2]);
 if Result then  fSettings[gds_ch1_coup]:=(round(Value));
end;

function TGDS_806S.GetCoupling(Chan: TGDS_Channel): boolean;
begin
 fActiveChannel:=Chan;
 Result:=GetCoupling();
end;

function TGDS_806S.GetMode:boolean;
begin
 QuireOperation(4,2,0);
 Result:=(round(Value)in[0..2]);
// if Result then  fParam.Mode:=TGDS_Mode(round(Value));
 if Result then  fSettings[gds_mode]:=(round(Value));
end;

function TGDS_806S.GetRecordLength: boolean;
 var i:TGDS_RecordLength;
begin
// if fMode<>gds_maver then
//   begin
//     fRecordLength:=gds_rl500;
//     Result:=True;
//     Exit;
//   end;

 QuireOperation(4,1,0);
 Result:=False;
 if Value=ErResult then Exit;
 for i := Low(TGDS_RecordLength) to High(TGDS_RecordLength) do
  if (round(Value)=GDS_RecordLengthData[i]) then
    begin
//     fParam.RecordLength:=TGDS_RecordLength(i);
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
 if not(GetCoupling(1)) then Exit;
 Result:=True;
end;

procedure TGDS_806S.LoadSetting(MemoryAdress: TGDS_MemoryAdress);
begin
 SetupOperation(1,0,MemoryAdress);
// SetFlags(1,0,MemoryAdress);
// PrepareString();
// Request();
end;

procedure TGDS_806S.PacketReceiving(Sender: TObject; const Str: string);
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
    end; //fRootNode = 4;
  6:begin
     case fFirstLevelNode of
        0:try
            fValue:=StrToInt(Str);
            except
             fValue:=ErResult;
            end;
     end;
    end; //fRootNode = 6;
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
    end; //fRootNode = 4;
  6:begin
     StringToSend:=StringToSend+IntToStr(fActiveChannel)+':';
     case fFirstLevelNode of
        0:StringToSend:=StringToSend+
                          FirstNode_6[fFirstLevelNode];
     end;
    end; //fRootNode = 6;
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
 var temp:byte;
begin
 if fSettings[gds_mode]=2 then
  begin
  temp:=AV mod 9;
  SetupOperation(4,0,temp);
  fSettings[gds_an]:=temp;
  end;
end;

procedure TGDS_806S.SetAverageNumber(AV: TGDS_AverageNumberSym);
begin
 SetAverageNumber(ord(AV));
end;

procedure TGDS_806S.SetCoupling(Chan:TGDS_Channel;Coupl:byte);
begin
 fActiveChannel:=Chan;
 SetCoupling(Coupl);
end;

procedure TGDS_806S.SetCoupling(Coupl: byte);
 var temp:byte;
begin
 temp:=Coupl mod 3;
 SetupOperation(6,0,temp);
 fSettings[gds_ch1_coup]:=temp;
end;

procedure TGDS_806S.SetCoupling(Coupl: TGDS_ChanCouplSym);
begin
 SetCoupling(ord(Coupl));
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
 var temp:byte;
begin
 temp:=mode mod 3;
 SetupOperation(4,2,temp);
 fSettings[gds_mode]:=temp;
end;

procedure TGDS_806S.SetRecordLength(RL: TGDS_RecordLengthSym);
begin
 SetRecordLength(ord(RL));
end;

procedure TGDS_806S.SetRecordLength(RL: Byte);
 var temp:byte;
begin
 temp:=RL mod 8;
 SetupOperation(4,1,temp);
 fSettings[gds_rl]:=temp;
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
     (High(Labels)<>ord(High(TGDS_Settings)))or
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
 fGDS_806S.QuireOperation(4,0,0);
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
      ('Mode:','Record length:','Average Number:','');
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
   begin
   fSettingsShow[i]:=TStringParameterShow.Create(STexts[ord(i)],
                        Labels[ord(i)], SettingsCaption[i], fSettingsShowSL[i]);
   fSettingsShow[i].ForUseInShowObject(fGDS_806S);
   end;
  fSettingsShow[gds_ch1_coup].IniNameSalt:='_ch1';
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
// fModeShow.Data:=ord(fGDS_806S.fParam.Mode);
// fRecordLengthShow.Data:=ord(fGDS_806S.fParam.RecordLength);
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
//     fGDS_806S.SetSettingAbsolut(fModeShow.Data,fRecordLengthShow.Data);
     fGDS_806S.SetSettingAbsolut(data);
     fFirstSetting:=False;
   end             else
//     fGDS_806S.SetSettingOnOption(fModeShow.Data,fRecordLengthShow.Data);
     fGDS_806S.SetSettingOnOption(data);

// if (fFirstSetting)or(TGDS_Mode(fModeShow.Data)<>fGDS_806S.fMode)
//   then fGDS_806S.SetMode(TGDS_Mode(fModeShow.Data));
// if (fFirstSetting)or(TGDS_RecordLength(fRecordLengthShow.Data)<>fGDS_806S.fRecordLength)
//   then fGDS_806S.SetRecordLength(TGDS_RecordLength(fRecordLengthShow.Data));

 ColorToActive(true);
// fModeShow.ColorToActive(true);
// fRecordLengthShow.ColorToActive(true);
 SettingToObject();

end;

procedure TGDS_806S_Show.SettingToObject;
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
 fGDS_806S.fSettings[i]:=fSettingsShow[i].Data;

 if fGDS_806S.fSettings[gds_mode]<>2 then
  begin
   fGDS_806S.fSettings[gds_an]:=0;
   fSettingsShow[gds_an].ColorToActive(false);
  end;
 

// fGDS_806S.fParam.SetDataShort(fModeShow.Data,fRecordLengthShow.Data);
// fGDS_806S.fMode:=TGDS_Mode(fModeShow.Data);
// fGDS_806S.fRecordLength:=TGDS_RecordLength(fRecordLengthShow.Data);
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
    i4:TGDS_ChanCoupl;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
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
 for I4 := Low(TGDS_ChanCoupl) to High(TGDS_ChanCoupl) do
    fSettingsShowSL[gds_ch1_coup].Add(GDS_ChanCouplLabels[i4]);
end;

procedure TGDS_806S_Show.SettingsShowSLFree;
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
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

procedure TGDS_806S_Show.UnlockButtonClick(Sender: TObject);
begin
  fGDS_806S.Unlock();
end;

procedure TGDS_806S_Show.WriteToIniFile(ConfigFile: TIniFile);
 var i:TGDS_Settings;
begin
 for I := Low(TGDS_Settings) to High(TGDS_Settings) do
  fSettingsShow[i].WriteToIniFile(ConfigFile);
// fModeShow.WriteToIniFile(ConfigFile);
// fRecordLengthShow.WriteToIniFile(ConfigFile);
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
