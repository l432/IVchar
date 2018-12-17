unit GDS_806S;

interface

uses
  RS232device, CPort, ShowTypes, StdCtrls, Classes, IniFiles;

type

 TGDS_Mode=(gds_msam,
            gds_mpd,
            gds_maver);
 TGDS_Channel=1..2;
 TGDS_MemoryAdress=1..15;

const
  GDS_806S_PacketBeginChar='';
  GDS_806S_PacketEndChar=#10;

  GDS_806S_Test='GW,GDS-806S,EF211754,V1.10';

  RootNood:array[0..5]of string=
  ('*idn','*rcl','*rst','*sav',':acq',':aut');
//   0       1      2      3      4      5

  FirstNode_4:array[0..3]of string=
  ('aver','leng','mod','mem');
//   0      1     2      3


  GDS_ModeLabels:array[TGDS_Mode]of string=
    ('Sample mode','Peak detection','Average mode');


type

  TGDS_806S=class(TRS232Meter)
  private
   fMode:TGDS_Mode;
   fActiveChannel:TGDS_Channel;

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
   protected
     Procedure PacketReceiving(Sender: TObject; const Str: string);override;
   public
    Constructor Create(CP:TComPort;Nm:string);override;
    procedure Request();override;
    procedure SetMode(mode:TGDS_Mode);
    function GetMode():boolean;
    function Test():boolean;
    procedure LoadSetting(MemoryAdress:TGDS_MemoryAdress);
    procedure SaveSetting(MemoryAdress:TGDS_MemoryAdress);
    procedure DefaultSetting();
    procedure AutoSetting();
  end;

 TGDS_806S_Show=class
   private
    fGDS_806S:TGDS_806S;
    fModeShow:TStringParameterShow;
    fModes:TStringList;
    BSetSetting:TButton;
    BGetSetting:TButton;
    BTest:TButton;
    fFirstSetting:boolean;
    procedure SetSettingButtonClick(Sender:TObject);
    procedure GetSettingButtonClick(Sender:TObject);
    procedure TestButtonClick(Sender:TObject);
   public
    Constructor Create(GDS_806S:TGDS_806S;
                       ST_Mode:TStaticText;
                       L_Mode:TLabel;
                       BSetSet,BGetSet,BT:TButton
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
  Dialogs, Controls, SysUtils, OlegType;

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

constructor TGDS_806S.Create(CP: TComPort; Nm: string);
begin
 inherited Create(CP,Nm);
 RepeatInErrorCase:=True;
 fComPacket.MaxBufferSize:=250052;
 fComPacket.StartString := GDS_806S_PacketBeginChar;
 fComPacket.StopString := GDS_806S_PacketEndChar;
 fMode:=gds_msam;
 fActiveChannel:=1;

 SetFlags(0,0,0,true);
end;

procedure TGDS_806S.DefaultSetting;
begin
 SetupOperation(2,0,0);
end;

function TGDS_806S.GetMode:boolean;
begin
 QuireOperation(4,2,0);
 Result:=(round(Value)in[0..2]);
 if Result then  fMode:=TGDS_Mode(round(Value));
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
//        3:StringToSend:=StringToSend+
//                        IntToStr(fActiveChannel)+
//                       ':'+FirstNode_4[fFirstLevelNode];
        2:try
           fValue:=StrToInt(Str);
          except
           fValue:=ErResult;
          end;
     end;
    end; //fRootNode = 4;
 end; //case fRootNode of

fIsReceived:=True;
//fValue:=0;
//showmessage('recived:'+STR);


end;

procedure TGDS_806S.PrepareString;
begin
 StringToSend:=RootNood[fRootNode];
 if fRootNode in [2,5] then Exit;

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

procedure TGDS_806S.Request;
begin
// StringToSend:=':acq:mod 0';
// StringToSend:='*idn?';
// StringToSend:=':meas:vpp?';
//showmessage('send:'+StringToSend);
 if fComPort.Connected then
  begin
   fComPort.AbortAllAsync;
   fComPort.ClearBuffer(True, True);
   fError:=(fComPort.WriteStr(StringToSend+GDS_806S_PacketEndChar)<>(Length(StringToSend)+1));
  end
                      else
   fError:=True;
end;

procedure TGDS_806S.SaveSetting(MemoryAdress: TGDS_MemoryAdress);
begin
 SetupOperation(3,0,MemoryAdress);
// SetFlags(3,0,MemoryAdress);
// PrepareString();
// Request();
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

procedure TGDS_806S.SetMode(mode:TGDS_Mode);
begin
// SetFlags(4,2,ord(mode));
// PrepareString();
// Request();
 SetupOperation(4,2,ord(mode));
 fMode:=mode;
end;

procedure TGDS_806S.SetupOperation(RootNode, FirstLevelNode, LeafNode: byte);
begin
 SetFlags(RootNode, FirstLevelNode, LeafNode);
 PrepareString();
 Request();
end;

function TGDS_806S.Test: boolean;
begin
 QuireOperation(0,0,0);
 Result:=(Value=314);
// SetFlags(0,0,0,true);
// PrepareString();
// Result:=(GetData=314);
end;

{ TGDS_806S_Show }

constructor TGDS_806S_Show.Create(GDS_806S: TGDS_806S;
                                  ST_Mode: TStaticText;
                                  L_Mode: TLabel;
                                  BSetSet,BGetSet,BT:TButton
                                  );
 var i1:TGDS_Mode;
begin
  fGDS_806S:=GDS_806S;
  fModes:=TStringList.Create();
  fModes.Clear;
  for I1 := Low(TGDS_Mode) to High(TGDS_Mode) do
    fModes.Add(GDS_ModeLabels[i1]);
  fModeShow:=TStringParameterShow.Create(ST_Mode,L_Mode,'Mode:',fModes);
  fModeShow.ForUseInShowObject(fGDS_806S);

  BSetSetting:=BSetSet;
  BSetSetting.Caption:='Set';
  BSetSetting.OnClick:=SetSettingButtonClick;

  BGetSetting:=BGetSet;
  BGetSetting.Caption:='Get';
  BGetSetting.OnClick:=GetSettingButtonClick;

  BTest:=BT;
  BTest.Caption:='Connection Test ?';
  BTest.OnClick:=TestButtonClick;

  fFirstSetting:=True;
end;

procedure TGDS_806S_Show.Free;
begin
 fModeShow.Free;
 fModes.Free;
end;

procedure TGDS_806S_Show.GetSettingButtonClick(Sender: TObject);
begin
 if not(fGDS_806S.GetMode) then Exit;

 fModeShow.ColorToActive(true);
 ObjectToSetting();
 fFirstSetting:=False;
end;

function TGDS_806S_Show.Help: shortint;
begin
 Result:=fModeShow.Data;
end;

procedure TGDS_806S_Show.ObjectToSetting;
begin
 fModeShow.Data:=ord(fGDS_806S.fMode);
end;

procedure TGDS_806S_Show.ReadFromIniFile(ConfigFile: TIniFile);
begin
 fModeShow.ReadFromIniFile(ConfigFile);
end;

procedure TGDS_806S_Show.SetSettingButtonClick(Sender: TObject);
begin
 if (fFirstSetting)or(TGDS_Mode(fModeShow.Data)<>fGDS_806S.fMode)
   then fGDS_806S.SetMode(TGDS_Mode(fModeShow.Data));
 fModeShow.ColorToActive(true);
 SettingToObject();
 fFirstSetting:=False;
end;

procedure TGDS_806S_Show.SettingToObject;
begin
 fGDS_806S.fMode:=TGDS_Mode(fModeShow.Data);
end;

procedure TGDS_806S_Show.TestButtonClick(Sender: TObject);
begin
 if fGDS_806S.Test then  BTest.Caption:='Connection Test - Ok'
                   else  BTest.Caption:='Connection Test - Failed';
end;

procedure TGDS_806S_Show.WriteToIniFile(ConfigFile: TIniFile);
begin
 fModeShow.WriteToIniFile(ConfigFile);
end;

end.
