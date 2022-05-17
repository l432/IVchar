unit Keithley2450;

interface

uses
  TelnetDevice, IdTelnet, ShowTypes;

const

  Kt_2450_Test='KEITHLEY INSTRUMENTS,MODEL 2450';

  RootNoodKt_2450:array[0..12]of string=
  ('*idn?','*rcl ','*rst','*sav',':acq',':outp','disp:',':syst','scr',
//   0       1      2      3      4        5       6        7       8
  'rout',':sens',':meas:syst',':tim:scal');
//  9       10     11           12

//:OUTPut:SMODe NORMal

  SuffixKt_2450:array[0..3]of string=('on','off', 'rst', '?');

  FirstNodeKt_2450_5:array[0..2]of string=
  (':stat',':int:stat',':smod');
//   0       1             2         3

  FirstNodeKt_2450_6:array[0..3]of string=
  ('scr','user1:text','user2:text','cle');
//   0       1             2         3

  FirstNodeKt_2450_7:array[0..1]of string=
  (':pos','???');

  FirstNodeKt_2450_8:array[0..1]of string=
  (':run','???');

  FirstNodeKt_2450_9:array[0..1]of string=
  (':term','???');

  FirstNodeKt_2450_10_3:array[0..1]of string=
  (':rsen','???');



type
 TKt2450_SetupMemorySlot=0..4;
 TKt2450_OutputTerminals=(kt_otFront, kt_otRear);
 TKt2450_Measure=(kt_mCurrent,kt_mVoltage,kt_mResistancet,kt_mPower);
 TKt2450_Sense=(kt_s4wire,kt_s2wire);
 TKt2450_Settings=(kt_curr_sense,kt_volt_sense,kt_res_sense,
                   kt_outputoff);
 TKt_2450_OutputOffState=(kt_oos_norm,kt_oos_zero,kt_oos_himp,kt_oos_guard);

const
 Kt2450_TerminalsName:array [TKt2450_OutputTerminals] of string=('fron', 'rear');
 Kt2450_MeasureName:array [TKt2450_Measure] of string=
           (':curr', ':volt', ':res', ':pow??');
 Kt_2450_OutputOffStateName:array[TKt_2450_OutputOffState]of string=
          ('norm','zero', 'himp', 'guard');

  OperationKod:array [TKt2450_Settings] of array[0..2] of byte=
//                  RootNood  FirstNode  LeafNode
{kt_curr_sense}   ((  10,         0,           0),
{kt_volt_sense}    (  10,         1,           0),
{kt_res_sense}     (  10,         2,           0),
                   (   5,         2,           0)
                  );

type


 TKt_2450=class(TTelnetMeterDeviceSingle)
  private
   fRootNode:byte;
   fFirstLevelNode:byte;
   fLeafNode:byte;
   fIsSuffix:boolean;
   fIsQuery:boolean;
   fAdditionalString:string;
   procedure DefaultSettings;
   procedure QuireOperation(RootNode:byte;FirstLevelNode:byte=0;LeafNode:byte=0;
                            isSyffix:boolean=True;isQuery:boolean=False);
   procedure SetupOperation(RootNode:byte;FirstLevelNode:byte=0;LeafNode:byte=0;
                            isSyffix:boolean=True;isQuery:boolean=False);
   procedure SetFlags(RootNode,FirstLevelNode,LeafNode:byte;
                  IsSuffix:boolean=True;isQuery:boolean=False);
   procedure JoinAddString();
//   procedure JoinQuery();
   function StringToInvertedCommas(str:string):string;
   procedure OnOffFromBool(toOn:boolean);
  protected
   procedure PrepareString;
   procedure UpDate();override;

  public
   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string='Keitley2450');
   function Test():boolean;
   procedure ResetSetting();
   procedure MyTraining();
   procedure OutPutChange(toOn:boolean);
   procedure ClearUserScreen();
   procedure TextToUserScreen(top_text:string='';bottom_text:string='');
   procedure SaveSetup(SlotNumber:TKt2450_SetupMemorySlot);
   procedure LoadSetup(SlotNumber:TKt2450_SetupMemorySlot);
   procedure LoadSetupPowerOn(SlotNumber:TKt2450_SetupMemorySlot);
   procedure UnloadSetupPowerOn();
   procedure RunningMacroScript(ScriptName:string);
   procedure SetInterlockStatus(toOn:boolean);
   function GetInterlockStatus():boolean;
   procedure SetTerminals(Terminal:TKt2450_OutputTerminals);
   procedure SetSense(MeasureType:TKt2450_Measure;Sense:TKt2450_Sense);
   procedure SetOutputOffState(OutputOffState:TKt_2450_OutputOffState);
 end;


var
  Kt_2450:TKt_2450;

implementation

uses
  Dialogs, SysUtils;

{ TKt_2450 }

procedure TKt_2450.ClearUserScreen;
begin
 SetupOperation(6,3,0,false);
end;

constructor TKt_2450.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
 inherited Create(Telnet,IPAdressShow,Nm);
 fMinDelayTime:=0;
 fDelayTimeStep:=10;
 fDelayTimeMax:=200;
// RepeatInErrorCase:=True;
 DefaultSettings();
 SetFlags(0,0,0);
end;

procedure TKt_2450.ResetSetting;
begin
  SetupOperation(2,0,0,False);
end;

procedure TKt_2450.RunningMacroScript(ScriptName: string);
begin
  fAdditionalString:=StringToInvertedCommas(ScriptName);
  SetupOperation(8,1);
end;

procedure TKt_2450.DefaultSettings;
begin

end;

function TKt_2450.GetInterlockStatus: boolean;
begin
 QuireOperation(5,1,0,True,True);
 Result:=(Value=1);
end;

procedure TKt_2450.JoinAddString;
begin
 if fIsQuery then Self.JoinToStringToSend(SuffixKt_2450[3])
             else Self.JoinToStringToSend(' '+fAdditionalString);
end;

//procedure TKt_2450.JoinQuery;
//begin
// Self.JoinToStringToSend(SuffixKt_2450[3]);
//end;

procedure TKt_2450.LoadSetup(SlotNumber: TKt2450_SetupMemorySlot);
begin
 fAdditionalString:=inttostr(SlotNumber);
 SetupOperation(1);
end;

procedure TKt_2450.LoadSetupPowerOn(SlotNumber: TKt2450_SetupMemorySlot);
begin
  fAdditionalString:='sav'+inttostr(SlotNumber);
  SetupOperation(7,0);
end;

procedure TKt_2450.MyTraining;
begin
 SetOutputOffState(kt_oos_norm);

// SetInterlockStatus(false);
// showmessage(booltostr(GetInterlockStatus,True));

// TextToUserScreen('Hi, Oleg!','I am glad to see you');
//  Self.SetStringToSend(':OUTP:INT:STAT?');
//  Request();
//  GetData;
end;

procedure TKt_2450.OnOffFromBool(toOn: boolean);
begin
 if toOn then fAdditionalString:=SuffixKt_2450[0]
         else fAdditionalString:=SuffixKt_2450[1];
end;

procedure TKt_2450.OutPutChange(toOn: boolean);
begin
 OnOffFromBool(toOn);
// if toOn then fAdditionalString:=SuffixKt_2450[0]
//         else fAdditionalString:=SuffixKt_2450[1];
 SetupOperation(5,0);
end;

procedure TKt_2450.PrepareString;
begin
 Self.ClearStringToSend;
 Self.SetStringToSend(RootNoodKt_2450[fRootNode]);
 case fRootNode of
  5:begin
    JoinToStringToSend(FirstNodeKt_2450_5[fFirstLevelNode]);
//     JoinAddString;
//     if fIsSuffix then JoinToStringToSend(SuffixKt_2450[0])
//                  else JoinToStringToSend(SuffixKt_2450[1]);
     end;
  6:begin
     JoinToStringToSend(FirstNodeKt_2450_6[fFirstLevelNode]);
//     if fFirstLevelNode in [0..2]
//        then  JoinAddString;
    end;
   7:begin
      JoinToStringToSend(FirstNodeKt_2450_7[fFirstLevelNode]);
//      JoinAddString;
     end;
   8:begin
      JoinToStringToSend(FirstNodeKt_2450_8[fFirstLevelNode]);
//      JoinAddString;
     end;
   9:begin
      JoinToStringToSend(FirstNodeKt_2450_9[fFirstLevelNode]);
     end;
   10:begin
      JoinToStringToSend(Kt2450_MeasureName[TKt2450_Measure(fFirstLevelNode)]);
      JoinToStringToSend(FirstNodeKt_2450_10_3[fLeafNode]);
     end;


  end;
 if fIsSuffix then JoinAddString;

end;

procedure TKt_2450.QuireOperation(RootNode, FirstLevelNode, LeafNode: byte;
                                 isSyffix:boolean;isQuery:boolean);
begin
 SetFlags(RootNode, FirstLevelNode, LeafNode,isSyffix,isQuery);
 PrepareString();
 GetData;
end;

procedure TKt_2450.SaveSetup(SlotNumber: TKt2450_SetupMemorySlot);
begin
 fAdditionalString:=inttostr(SlotNumber);
 SetupOperation(3);
end;

procedure TKt_2450.SetFlags(RootNode, FirstLevelNode, LeafNode: byte;
                  IsSuffix:boolean; isQuery:boolean);
begin
 fRootNode:=RootNode;
 fFirstLevelNode:=FirstLevelNode;
 fLeafNode:=LeafNode;
 fIsSuffix:=IsSuffix;
 fIsQuery:=isQuery;
end;

procedure TKt_2450.SetInterlockStatus(toOn: boolean);
begin
 OnOffFromBool(toOn);
 SetupOperation(5,1);
end;

procedure TKt_2450.SetOutputOffState(OutputOffState: TKt_2450_OutputOffState);
begin
 fAdditionalString:=Kt_2450_OutputOffStateName[OutputOffState];
 SetupOperation(5,2);
end;

procedure TKt_2450.SetSense(MeasureType: TKt2450_Measure; Sense: TKt2450_Sense);
begin
 fAdditionalString:=SuffixKt_2450[ord(Sense)];
 SetupOperation(10,ord(MeasureType),0);
end;

procedure TKt_2450.SetTerminals(Terminal: TKt2450_OutputTerminals);
begin
 fAdditionalString:=Kt2450_TerminalsName[Terminal];
 SetupOperation(9,0);
end;

procedure TKt_2450.UnloadSetupPowerOn;
begin
  fAdditionalString:=SuffixKt_2450[2];
  SetupOperation(7,0);
end;

procedure TKt_2450.SetupOperation(RootNode, FirstLevelNode, LeafNode: byte;
                                 isSyffix:boolean;isQuery:boolean);
begin
 SetFlags(RootNode, FirstLevelNode, LeafNode,isSyffix,isQuery);
 PrepareString();
 Request();
end;

function TKt_2450.StringToInvertedCommas(str: string): string;
begin
 Result:='"'+str+'"';
end;

function TKt_2450.Test: boolean;
begin
 QuireOperation(0,0,0,False);
 Result:=(Value=314);
end;

procedure TKt_2450.TextToUserScreen(top_text, bottom_text: string);
begin
 fAdditionalString:='SWIPE_USER';
 SetupOperation(6,0);
 if top_text<>'' then
   begin
     if Length(top_text)>20 then SetLength(top_text,20);
     fAdditionalString:=StringToInvertedCommas(top_text);
     SetupOperation(6,1);
   end;
 if bottom_text<>'' then
   begin
     if Length(bottom_text)>32 then SetLength(bottom_text,32);
     fAdditionalString:=StringToInvertedCommas(bottom_text);
     SetupOperation(6,2);
   end;


end;

procedure TKt_2450.UpDate;
 var STR:string;
begin
 Str:=Trim(fDataSubject.ReceivedString);
// showmessage(STR+Kt_2450_Test);
 case fRootNode of
  0:if pos(Kt_2450_Test,Str)<>0 then fValue:=314;
  5:begin
    fValue:=StrToInt(Str);
    end;
 end;
 fIsReceived:=True;
 if TestShowEthernet then showmessage('recived:  '+STR);
// showmessage(floattostr(fValue))
end;

//{ TKt_2450_Show }
//
//procedure TKt_2450_Show.ButtonsTune(Buttons: array of TButton);
//const
//  ButtonCaption: array[0..ButtonNumberKt_2450] of string =
//  ('Connection Test ?','Reset','MyTrain');
//var
//  ButtonAction: array[0..ButtonNumberKt_2450] of TNotifyEvent;
//  i: Integer;
//begin
//  ButtonAction[0] := TestButtonClick;
//  ButtonAction[1] := ResetButtonClick;
////  ButtonAction[3] := SaveButtonClick;
////  ButtonAction[4] := LoadButtonClick;
////  ButtonAction[5] := AutoButtonClick;
////  ButtonAction[6] := DefaultButtonClick;
////  ButtonAction[7] := RefreshButtonClick;
////  ButtonAction[8] := RunButtonClick;
////  ButtonAction[9] := StopButtonClick;
////  ButtonAction[10] := UnlockButtonClick;
//   ButtonAction[ButtonNumberKt_2450] := MyTrainButtonClick;
//  for I := 0 to ButtonNumberKt_2450 do
//  begin
//    Buttons[i].Caption := ButtonCaption[i];
//    Buttons[i].OnClick := ButtonAction[i];
//  end;
//  BTest := Buttons[0];
//
//end;
//
//constructor TKt_2450_Show.Create(Kt_2450: TKt_2450;
//                                Buttons:Array of TButton;
//                                OutPutOnOff:TSpeedButton
//                                );
//begin
//  if (High(Buttons)<>ButtonNumberKt_2450)
//   then
//    begin
//      showmessage('Kt_2450_Show is not created!');
//      Exit;
//    end;
//  fKt_2450:=Kt_2450;
//  ButtonsTune(Buttons);
//
//  fOutPutOnOff:=OutPutOnOff;
//  fOutPutOnOff.OnClick:=OutPutOnOffSpeedButtonClick;
//  fOutPutOnOff.Caption:='Output';
//end;
//
//procedure TKt_2450_Show.MyTrainButtonClick(Sender: TObject);
//begin
// fKt_2450.MyTraining();
//end;
//
//procedure TKt_2450_Show.OutPutOnOffSpeedButtonClick(Sender: TObject);
//begin
// fKt_2450.OutPutChange(fOutPutOnOff.Down);
//end;
//
//procedure TKt_2450_Show.ResetButtonClick(Sender: TObject);
//begin
// fKt_2450.ResetSetting();
//end;
//
//procedure TKt_2450_Show.TestButtonClick(Sender: TObject);
//begin
//   if fKt_2450.Test then
//        begin
//          BTest.Caption:='Connection Test - Ok';
//          BTest.Font.Color:=clBlue;
//        end        else
//        begin
//          BTest.Caption:='Connection Test - Failed';
//          BTest.Font.Color:=clRed;
//        end;
//end;

end.
