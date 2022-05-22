unit Keithley2450;

interface

uses
  TelnetDevice, IdTelnet, ShowTypes, Keitley2450Const, SCPI;


type

 TKt_2450Device=class(TTelnetMeterDeviceSingle)
  private
   fSCPI:TSCPInew;
  protected
   procedure UpDate();override;
  public
   Constructor Create(SCPInew:TSCPInew;Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string);
 end;


// TKt_2450=class(TTelnetMeterDeviceSingle)
 TKt_2450=class(TSCPInew)
  private
   fTelnet:TIdTelnet;
   fIPAdressShow: TIPAdressShow;
//   fRootNode:byte;
//   fFirstLevelNode:byte;
//   fLeafNode:byte;
//   fIsSuffix:boolean;
//   fIsQuery:boolean;
//   fAdditionalString:string;
   fVoltageProtection:TKt_2450_VoltageProtection;
   fVoltageLimit:double;
   fCurrentLimit:double;
//   procedure QuireOperation(RootNode:byte;FirstLevelNode:byte=0;LeafNode:byte=0;
//                            isSyffix:boolean=True;isQuery:boolean=False);
//   procedure SetupOperation(RootNode:byte;FirstLevelNode:byte=0;LeafNode:byte=0;
//                            isSyffix:boolean=True;isQuery:boolean=False);
//   procedure SetFlags(RootNode,FirstLevelNode,LeafNode:byte;
//                  IsSuffix:boolean=True;isQuery:boolean=False);
//   procedure JoinAddString();
//   function StringToInvertedCommas(str:string):string;
   procedure OnOffFromBool(toOn:boolean);
   function StringToVoltageProtection(Str:string;var vp:TKt_2450_VoltageProtection):boolean;
  protected
   procedure PrepareString;override;
//   procedure UpDate();override;
   procedure DeviceCreate(Nm:string);override;
   procedure DefaultSettings;override;
  public
   property VoltageProtection:TKt_2450_VoltageProtection read fVoltageProtection;
   property VoltageLimit:double read fVoltageLimit;
   property CurrentLimit:double read fCurrentLimit;
   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string='Keitley2450');
   function Test():boolean;override;
   procedure ProcessingString(Str:string);override;
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
   {����� �� ������� �� ����� ������}
   procedure SetSense(MeasureType:TKt2450_Measure;Sense:TKt2450_Sense);
   {2-�������� �� 4-�������� ����� ����������}
   procedure SetOutputOffState(OutputOffState:TKt_2450_OutputOffState);
   {����������� ���� �����: ����������, ���������������� ����}
   procedure SetResistanceCompencate(toOn:boolean);
   {���������/��������� ����������� �����}
   procedure SetVoltageProtection(Level:TKt_2450_VoltageProtection);
   {������������ �������� ������� �� �����������}
   function  GetVoltageProtection():boolean;
   {������� ����� ������ � TKt_2450_VoltageProtection}
   procedure SetVoltageLimit(Value:double=0);
   {������������ �������� ������� �������}
   procedure SetCurrentLimit(Value:double=0);
   {������������ ���������� ������ �������}

 end;

Procedure DeleteSubstring(var Source:string; Substring: string);

Function FloatToStrLimited(Value:double;LimitValues:TLimitValues):string;

var
  Kt_2450:TKt_2450;

implementation

uses
  Dialogs, SysUtils, OlegType, Math;

{ TKt_2450 }

procedure TKt_2450.ClearUserScreen;
begin
 SetupOperation(6,3,0,false);
end;

constructor TKt_2450.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
// inherited Create(Telnet,IPAdressShow,Nm);
// fMinDelayTime:=0;
// fDelayTimeStep:=10;
// fDelayTimeMax:=200;
//// RepeatInErrorCase:=True;
// DefaultSettings();
// SetFlags(0,0,0);
 fTelnet:=Telnet;
 fIPAdressShow:=IPAdressShow;
 inherited Create(Nm);

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
 fVoltageProtection:=kt_vpnone;
 fVoltageLimit:=Kt_2450_VoltageLimDef;
 fCurrentLimit:=Kt_2450_CurrentLimDef;
end;

procedure TKt_2450.DeviceCreate(Nm: string);
begin
 fDevice:=TKt_2450Device.Create(Self,fTelnet,fIPAdressShow,Nm);
end;

function TKt_2450.GetInterlockStatus: boolean;
begin
 QuireOperation(5,1,0,True);
// Result:=(Value=1);
 Result:=(fDevice.Value=1);
end;

function TKt_2450.GetVoltageProtection: boolean;
begin
 QuireOperation(11,1,0,True);
// Result:=(Value<>ErResult);
 Result:=(fDevice.Value<>ErResult);
end;

//procedure TKt_2450.JoinAddString;
//begin
// if fIsQuery then Self.JoinToStringToSend(SuffixKt_2450[3])
//             else Self.JoinToStringToSend(' '+fAdditionalString);
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
// var str:string;
begin
// SetVoltageLimit();
// SetVoltageLimit(-1);
// SetVoltageLimit(0.02354);

 SetCurrentLimit();
 SetCurrentLimit(2);
 SetCurrentLimit(1.578968e-6);


// if  GetVoltageProtection() then showmessage('Ok!');
//   SetVoltageProtection(kt_vpnone);

// SetResistanceCompencate(True);
// SetResistanceCompencate(False);

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
// Self.ClearStringToSend;
// Self.SetStringToSend(RootNoodKt_2450[fRootNode]);
 (fDevice as TKt_2450Device).ClearStringToSend;
 (fDevice as TKt_2450Device).SetStringToSend(RootNoodKt_2450[fRootNode]);
 case fRootNode of
  5:begin
//     JoinToStringToSend(FirstNodeKt_2450_5[fFirstLevelNode]);
     fDevice.JoinToStringToSend(FirstNodeKt_2450_5[fFirstLevelNode]);
     end;
  6:begin
//     JoinToStringToSend(FirstNodeKt_2450_6[fFirstLevelNode]);
     fDevice.JoinToStringToSend(FirstNodeKt_2450_6[fFirstLevelNode]);
    end;
   7:begin
      fDevice.JoinToStringToSend(FirstNodeKt_2450_7[fFirstLevelNode]);
     end;
   8:begin
      fDevice.JoinToStringToSend(FirstNodeKt_2450_8[fFirstLevelNode]);
     end;
   9:begin
      fDevice.JoinToStringToSend(FirstNodeKt_2450_9[fFirstLevelNode]);
     end;
   10:begin
      fDevice.JoinToStringToSend(Kt2450_MeasureName[TKt2450_Measure(fFirstLevelNode)]);
      fDevice.JoinToStringToSend(FirstNodeKt_2450_10_3[fLeafNode]);
     end;
   11:begin
      fDevice.JoinToStringToSend(Kt2450_MeasureName[TKt2450_Measure(fFirstLevelNode)]);
      fDevice.JoinToStringToSend(FirstNodeKt_2450_11_3[fLeafNode]);
     end;
  end;
 if fIsSuffix then JoinAddString;

end;

procedure TKt_2450.ProcessingString(Str: string);
begin
 Str:=Trim(Str);
 Str := AnsiLowerCase(Str);
 case fRootNode of
//  0:if pos(AnsiLowerCase(Kt_2450_Test),Str)<>0 then fValue:=314;
  0:if pos(AnsiLowerCase(Kt_2450_Test),Str)<>0 then fDevice.Value:=314;
  5:begin
    fDevice.Value:=StrToInt(Str);
    end;
  11:begin
//   QuireOperation(11,1,0,True,True);
     case fLeafNode of
      0:if StringToVoltageProtection(Str,fVoltageProtection)
          then fDevice.Value:=ord(fVoltageProtection);
      2..3:;    
     end;

     end;
 end;
// fIsReceived:=True;
// if TestShowEthernet then showmessage('recived:  '+STR);
end;

//procedure TKt_2450.QuireOperation(RootNode, FirstLevelNode, LeafNode: byte;
//                                 isSyffix:boolean;isQuery:boolean);
//begin
// SetFlags(RootNode, FirstLevelNode, LeafNode,isSyffix,isQuery);
// PrepareString();
// GetData;
//end;

procedure TKt_2450.SaveSetup(SlotNumber: TKt2450_SetupMemorySlot);
begin
 fAdditionalString:=inttostr(SlotNumber);
 SetupOperation(3);
end;

procedure TKt_2450.SetCurrentLimit(Value: double);
begin
if Value=0 then
     begin
//      fAdditionalString:=SuffixKt_2450[5];
      fAdditionalString:=SuffixKt_2450[4];
      fCurrentLimit:=Kt_2450_CurrentLimDef;
     end
           else
     begin
      fAdditionalString:=FloatToStrLimited(Value,Kt_2450_CurrentLimLimits);
      fCurrentLimit:=strtofloat(fAdditionalString);
     end;
 SetupOperation(11,1,3);
end;

//procedure TKt_2450.SetFlags(RootNode, FirstLevelNode, LeafNode: byte;
//                  IsSuffix:boolean; isQuery:boolean);
//begin
// fRootNode:=RootNode;
// fFirstLevelNode:=FirstLevelNode;
// fLeafNode:=LeafNode;
// fIsSuffix:=IsSuffix;
// fIsQuery:=isQuery;
//end;

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

procedure TKt_2450.SetResistanceCompencate(toOn: boolean);
begin
 OnOffFromBool(toOn);
 SetupOperation(10,ord(kt_mResistancet),1);
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

//procedure TKt_2450.SetupOperation(RootNode, FirstLevelNode, LeafNode: byte;
//                                 isSyffix:boolean;isQuery:boolean);
//begin
// SetFlags(RootNode, FirstLevelNode, LeafNode,isSyffix,isQuery);
// PrepareString();
// Request();
//end;

procedure TKt_2450.SetVoltageLimit(Value: double);
begin
if Value=0 then
     begin
//      fAdditionalString:=SuffixKt_2450[5];
      fAdditionalString:=SuffixKt_2450[4];
      fVoltageLimit:=Kt_2450_VoltageLimDef;
     end
           else
     begin
      fAdditionalString:=FloatToStrLimited(Value,Kt_2450_VoltageLimLimits);
      fVoltageLimit:=strtofloat(fAdditionalString);
     end;
 SetupOperation(11,0,2);
end;

procedure TKt_2450.SetVoltageProtection(Level: TKt_2450_VoltageProtection);
begin
 if Level in [kt_vp2..kt_vp180] then
//   fAdditionalString:=SuffixKt_2450[4]
   fAdditionalString:=SuffixKt_2450[3]
                     +Copy(Kt_2450_VoltageProtectionLabel[Level],1,
                           Length(Kt_2450_VoltageProtectionLabel[Level])-1)
                                else
   fAdditionalString:=Kt_2450_VoltageProtectionLabel[Level];
 fVoltageProtection:=Level;
 SetupOperation(11,1,0);
end;

//function TKt_2450.StringToInvertedCommas(str: string): string;
//begin
// Result:='"'+str+'"';
//end;

function TKt_2450.StringToVoltageProtection(Str: string;
    var vp: TKt_2450_VoltageProtection): boolean;
  var i:TKt_2450_VoltageProtection;
begin
 Result:=False;
// DeleteSubstring(Str,SuffixKt_2450[4]);
 DeleteSubstring(Str,SuffixKt_2450[3]);
 if pos(Str,Kt_2450_VoltageProtectionLabel[kt_vpnone])=0 then
     Str:=Str+'V';
 for I := Low(TKt_2450_VoltageProtection) to (High(TKt_2450_VoltageProtection)) do
   if Str=Kt_2450_VoltageProtectionLabel[i] then
     begin
       vp:=i;
       Result:=True;
       Break;
     end;
end;

function TKt_2450.Test: boolean;
begin
 QuireOperation(0,0,0,False);
// Result:=(Value=314);
 Result:=(fDevice.Value=314);
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

//procedure TKt_2450.UpDate;
// var STR:string;
//begin
// Str:=Trim(fDataSubject.ReceivedString);
// Str := AnsiLowerCase(Str);
// case fRootNode of
//  0:if pos(AnsiLowerCase(Kt_2450_Test),Str)<>0 then fValue:=314;
//  5:begin
//    fValue:=StrToInt(Str);
//    end;
//  11:begin
////   QuireOperation(11,1,0,True,True);
//     if StringToVoltageProtection(Str,fVoltageProtection)
//          then fValue:=ord(fVoltageProtection);
//     end;
// end;
// fIsReceived:=True;
// if TestShowEthernet then showmessage('recived:  '+STR);
//end;

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

Procedure DeleteSubstring(var Source:string; Substring: string);
begin
 if pos(Substring,Source)<>0 then
     Delete(Source,pos(Substring,Source),Length(Substring));
end;

Function FloatToStrLimited(Value:double;LimitValues:TLimitValues):string;
begin
  Value:=min(Value,LimitValues[lvMax]);
  Value:=max(Value,LimitValues[lvMin]);
  Result:=FloatToStrF(Value,ffExponent,4,0);
end;

{ TKt_2450Device }

constructor TKt_2450Device.Create(SCPInew:TSCPInew;Telnet: TIdTelnet;
  IPAdressShow: TIPAdressShow; Nm: string);
begin
 inherited Create(Telnet,IPAdressShow,Nm);
 fSCPI:=SCPInew;
 fMinDelayTime:=0;
 fDelayTimeStep:=10;
 fDelayTimeMax:=200;
end;

procedure TKt_2450Device.UpDate;
begin
 fSCPI.ProcessingString(fDataSubject.ReceivedString);
 fIsReceived:=True;
 if TestShowEthernet then showmessage('recived:  '+fDataSubject.ReceivedString);
end;

end.
