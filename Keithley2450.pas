unit Keithley2450;

interface

uses
  StdCtrls, TelnetDevice, IdTelnet, ShowTypes, OlegTypePart2, Buttons;

const

  Kt_2450_Test='KEITHLEY INSTRUMENTS,MODEL 2450';

  RootNoodKt_2450:array[0..12]of string=
  ('*idn?','*rcl','*rst','*sav',':acq',':outp:stat',':chan',':meas',':refr',
//   0       1      2      3      4            5       6       7      8
  ':run',':stop','syst:unl',':tim:scal');
//  9       10     11           12

  SuffixKt_2450:array[0..1]of string=(' on',' off');

 ButtonNumberKt_2450 = 2;
type

  TMyGroupBox = class(TGroupBox)
    public
      property Canvas;
  end;

 TKt_2450=class(TTelnetMeterDeviceSingle)
  private
   fRootNode:byte;
   fFirstLevelNode:byte;
   fLeafNode:byte;
   fIsSuffix:boolean;
   procedure DefaultSettings;
   procedure QuireOperation(RootNode:byte;FirstLevelNode:byte=0;LeafNode:byte=0);
   procedure SetupOperation(RootNode:byte;FirstLevelNode:byte=0;LeafNode:byte=0;
                            isSyffix:boolean=False);
   procedure SetFlags(RootNode,FirstLevelNode,LeafNode:byte;
                  IsSuffix:boolean=False);
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
 end;

 TKt_2450_Show=class(TSimpleFreeAndAiniObject)
  private
   fKt_2450:TKt_2450;
   BTest:TButton;
   fOutPutOnOff:TSpeedButton;
   procedure TestButtonClick(Sender:TObject);
   procedure ResetButtonClick(Sender:TObject);
   procedure MyTrainButtonClick(Sender:TObject);
   procedure ButtonsTune(Buttons: array of TButton);
   procedure OutPutOnOffSpeedButtonClick(Sender: TObject);
  public
   Constructor Create(Kt_2450:TKt_2450;
                      Buttons:Array of TButton;
                      OutPutOnOff:TSpeedButton
                      );
 end;

var
  Kt_2450:TKt_2450;
  Kt_2450_Show:TKt_2450_Show;

implementation

uses
  Dialogs, Graphics, Classes, SysUtils, Forms;

{ TKt_2450 }

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
  SetupOperation(2);
end;

procedure TKt_2450.DefaultSettings;
begin

end;

procedure TKt_2450.MyTraining;
begin
  Self.SetStringToSend(':outp:stat on');
  Request();
//  GetData;
end;

procedure TKt_2450.OutPutChange(toOn: boolean);
begin
 SetupOperation(5,0,0,toOn);
end;

procedure TKt_2450.PrepareString;
 var StringToSend:string;
begin
 StringToSend:=RootNoodKt_2450[fRootNode];
 case fRootNode of
  5:begin
     if fIsSuffix then StringToSend:=StringToSend+SuffixKt_2450[0]
                  else StringToSend:=StringToSend+SuffixKt_2450[1];
     end;
  end;
 Self.SetStringToSend(StringToSend);
end;

procedure TKt_2450.QuireOperation(RootNode, FirstLevelNode, LeafNode: byte);
begin
 SetFlags(RootNode, FirstLevelNode, LeafNode);
 PrepareString();
 GetData;
end;

procedure TKt_2450.SetFlags(RootNode, FirstLevelNode, LeafNode: byte;
                  IsSuffix:boolean);
begin
 fRootNode:=RootNode;
 fFirstLevelNode:=FirstLevelNode;
 fLeafNode:=LeafNode;
 fIsSuffix:=IsSuffix;
end;

procedure TKt_2450.SetupOperation(RootNode, FirstLevelNode, LeafNode: byte;
                                 isSyffix:boolean);
begin
 SetFlags(RootNode, FirstLevelNode, LeafNode,isSyffix);
 PrepareString();
 Request();
end;

function TKt_2450.Test: boolean;
begin
 QuireOperation(0);
 Result:=(Value=314);
end;

procedure TKt_2450.UpDate;
 var STR:string;
begin
 Str:=fDataSubject.ReceivedString;
// showmessage(STR+Kt_2450_Test);
 case fRootNode of
  0:if pos(Kt_2450_Test,Str)<>0 then fValue:=314;
 end;
 fIsReceived:=True;
 if TestShowEthernet then showmessage('recived:  '+STR);
// showmessage(floattostr(fValue))
end;

{ TKt_2450_Show }

procedure TKt_2450_Show.ButtonsTune(Buttons: array of TButton);
const
  ButtonCaption: array[0..ButtonNumberKt_2450] of string =
  ('Connection Test ?','Reset','MyTrain');
var
  ButtonAction: array[0..ButtonNumberKt_2450] of TNotifyEvent;
  i: Integer;
begin
  ButtonAction[0] := TestButtonClick;
  ButtonAction[1] := ResetButtonClick;
//  ButtonAction[3] := SaveButtonClick;
//  ButtonAction[4] := LoadButtonClick;
//  ButtonAction[5] := AutoButtonClick;
//  ButtonAction[6] := DefaultButtonClick;
//  ButtonAction[7] := RefreshButtonClick;
//  ButtonAction[8] := RunButtonClick;
//  ButtonAction[9] := StopButtonClick;
//  ButtonAction[10] := UnlockButtonClick;
   ButtonAction[ButtonNumberKt_2450] := MyTrainButtonClick;
  for I := 0 to ButtonNumberKt_2450 do
  begin
    Buttons[i].Caption := ButtonCaption[i];
    Buttons[i].OnClick := ButtonAction[i];
  end;
  BTest := Buttons[0];

end;

constructor TKt_2450_Show.Create(Kt_2450: TKt_2450;
                                Buttons:Array of TButton;
                                OutPutOnOff:TSpeedButton
                                );
begin
  if (High(Buttons)<>ButtonNumberKt_2450)
   then
    begin
      showmessage('Kt_2450_Show is not created!');
      Exit;
    end;
  fKt_2450:=Kt_2450;
  ButtonsTune(Buttons);

  fOutPutOnOff:=OutPutOnOff;
  fOutPutOnOff.OnClick:=OutPutOnOffSpeedButtonClick;
  fOutPutOnOff.Caption:='Output';
end;

procedure TKt_2450_Show.MyTrainButtonClick(Sender: TObject);
begin
 fKt_2450.MyTraining();
end;

procedure TKt_2450_Show.OutPutOnOffSpeedButtonClick(Sender: TObject);
begin
 fKt_2450.OutPutChange(fOutPutOnOff.Down);
end;

procedure TKt_2450_Show.ResetButtonClick(Sender: TObject);
begin
 fKt_2450.ResetSetting();
end;

procedure TKt_2450_Show.TestButtonClick(Sender: TObject);
begin
   if fKt_2450.Test then
        begin
          BTest.Caption:='Connection Test - Ok';
          BTest.Font.Color:=clBlue;
        end        else
        begin
          BTest.Caption:='Connection Test - Failed';
          BTest.Font.Color:=clRed;
        end;
end;

end.
