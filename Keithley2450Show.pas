unit Keithley2450Show;

interface

uses
  OlegTypePart2, Keithley2450, StdCtrls, Buttons,
  ArduinoDeviceNew, ExtCtrls, IniFiles, OlegShowTypes, Classes, 
  Keitley2450Const;

const
  ButtonNumberKt2450 = 3;
  SpeedButtonNumberKt2450 = 1;
  PanelNumberKt2450 = 1;


type

 TKt_2450_Show=class;

 TKT2450_SetupMemoryPins=class(TPins)
  protected
   Function GetPinStr(Index:integer):string;override;
  public
   Constructor Create(Name:string);
 end;


 TKT2450_SetupMemoryShow=class(TPinsShowUniversal)
   private
    fKT2450_Show:TKt_2450_Show;
    fMemoryPins:TKT2450_SetupMemoryPins;
   protected
    procedure LabelsFilling;
    procedure CommandSend;
   public
    Constructor Create(KT2450_Show:TKt_2450_Show;
                       PanelSave, PanelLoad:TPanel);
    destructor Destroy;override;
    procedure NumberPinShow(PinActiveNumber:integer=-1;ChooseNumber:integer=-1);override;
 end;

TKt_2450_AbstractElementShow=class(TSimpleFreeAndAiniObject)
 private
  fKt_2450:TKt_2450;
  procedure SettingsShowSLCreate();virtual;abstract;
  procedure SettingsShowSLFree();virtual;abstract;
  procedure SettingsShowCreate(STexts:array of TStaticText;
                          Labels:array of TLabel);virtual;abstract;
  procedure SettingsShowFree;virtual;abstract;
  procedure CreateFooter();virtual;abstract;
 public
  Constructor Create(Kt_2450:TKt_2450;
                      STexts:array of TStaticText;
                      Labels:array of TLabel
                      );
  destructor Destroy;override;
  procedure ObjectToSetting;virtual;abstract;
 end;


TKt_2450_SourceShow=class(TKt_2450_AbstractElementShow)
 private
  fSettingsShow:array[TKt2450_SourceSettings]of TStringParameterShow;
  fSettingsShowSL:array[TKt2450_SourceSettings]of TStringList;
 public
//  procedure ObjectToSetting;override;
 end;

 TKt_2450_Show=class(TSimpleFreeAndAiniObject)
  private
   fKt_2450:TKt_2450;
   fSettingsShow:array[TKt2450_Settings]of TStringParameterShow;
   fSettingsShowSL:array[TKt2450_Settings]of TStringList;
   BTest:TButton;
   fOutPutOnOff:TSpeedButton;
   fTerminalsFrRe:TSpeedButton;
   fSetupMemoryShow:TKT2450_SetupMemoryShow;
//   fSetupMemoryPins:TKT2450_SetupMemoryPins;
   procedure TestButtonClick(Sender:TObject);
   procedure ResetButtonClick(Sender:TObject);
   procedure GetSettingButtonClick(Sender:TObject);
   procedure MyTrainButtonClick(Sender:TObject);
   procedure ButtonsTune(Buttons: array of TButton);
   procedure SpeedButtonsTune(SpeedButtons: array of TSpeedButton);
   procedure SettingsShowSLCreate();
   procedure SettingsShowSLFree();
   procedure SettingsShowCreate(STexts:array of TStaticText;
                          Labels:array of TLabel);
   procedure SettingsShowFree;
   procedure OutPutOnOffSpeedButtonClick(Sender: TObject);
   procedure OutPutOnFromDevice();
   procedure TerminalsFrReSpeedButtonClick(Sender: TObject);
   procedure TerminalsFromDevice();
   procedure SenseCurOkClick();
   procedure SenseVoltOkClick();
   procedure SenseResOkClick();
   procedure OutputOffOkClick();
   procedure ResCompOkClick();
   procedure VoltageProtectionOkClick();
   procedure ModeOkClick();
  public
   Constructor Create(Kt_2450:TKt_2450;
                      Buttons:Array of TButton;
                      SpeedButtons:Array of TSpeedButton;
                      Panels:Array of TPanel;
                      STexts:array of TStaticText;
                      Labels:array of TLabel
                      );
  destructor Destroy;override;
  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
  procedure WriteToIniFile(ConfigFile:TIniFile);override;
  procedure SettingToObject;
  procedure ObjectToSetting;
 end;



var
  Kt_2450_Show:TKt_2450_Show;

implementation

uses
  Dialogs, Graphics, SysUtils, TelnetDevice;

{ TKt_2450_Show }

procedure TKt_2450_Show.ButtonsTune(Buttons: array of TButton);
const
  ButtonCaption: array[0..ButtonNumberKt2450] of string =
  ('Connection Test ?','Reset','Get','MyTrain');
var
  ButtonAction: array[0..ButtonNumberKt2450] of TNotifyEvent;
  i: Integer;
begin
  ButtonAction[0] := TestButtonClick;
  ButtonAction[1] := ResetButtonClick;
  ButtonAction[2] := GetSettingButtonClick;
   ButtonAction[ButtonNumberKt2450] := MyTrainButtonClick;
  for I := 0 to ButtonNumberKt2450 do
  begin
    Buttons[i].Caption := ButtonCaption[i];
    Buttons[i].OnClick := ButtonAction[i];
  end;
  BTest := Buttons[0];

end;

constructor TKt_2450_Show.Create(Kt_2450: TKt_2450;
                                Buttons:Array of TButton;
                                SpeedButtons:Array of TSpeedButton;
                                Panels:Array of TPanel;
                                STexts:array of TStaticText;
                                Labels:array of TLabel
                                );
begin
  if (High(Buttons)<>ButtonNumberKt2450)
     or(High(SpeedButtons)<>SpeedButtonNumberKt2450)
     or(High(Panels)<>PanelNumberKt2450)
     or(High(STexts)<>(ord(High(TKt2450_Settings))))
     or(High(Labels)<>(ord(High(TKt2450_Settings))-ord(kt_outputoff)))
   then
    begin
      showmessage('Kt_2450_Show is not created!');
      Exit;
    end;
  fKt_2450:=Kt_2450;
  ButtonsTune(Buttons);
  SpeedButtonsTune(SpeedButtons);

  SettingsShowSLCreate();
  SettingsShowCreate(STexts,Labels);

  fSetupMemoryShow:=TKT2450_SetupMemoryShow.Create(Self,Panels[0],Panels[1]);

  ObjectToSetting();
end;

destructor TKt_2450_Show.Destroy;
begin
  FreeAndNil(fSetupMemoryShow);
  SettingsShowFree;
  SettingsShowSLFree;
  inherited;
end;

procedure TKt_2450_Show.GetSettingButtonClick(Sender: TObject);
begin
  if not(DeviceEthernetisAbsent) then
    begin
  fKt_2450.GetTerminal();
  fKt_2450.IsOutPutOn();
//  fKt_2450.GetSenses(); toDo ObjectToSetting
// fKt_2450.GetOutputOffStates;

// fKt_2450.GetMeasureFunction();
// fKt_2450.IsResistanceCompencateOn();//має бути після GetMeasureFunction
   fKt_2450.GetVoltageProtection;
    end;

  ObjectToSetting();
// if fKt_2450.GetVoltageProtection then
//   fSettingsShow[kt_voltprot].Data:=ord(fKt_2450.VoltageProtection);

end;

procedure TKt_2450_Show.ModeOkClick;
begin
 fKt_2450.SetMode(TKt_2450_Mode(fSettingsShow[kt_mode].Data));
end;

procedure TKt_2450_Show.MyTrainButtonClick(Sender: TObject);
begin
 fKt_2450.MyTraining();
end;

procedure TKt_2450_Show.ObjectToSetting;
begin
 TerminalsFromDevice();
 OutPutOnFromDevice();
 fSettingsShow[kt_voltprot].Data:=ord(fKt_2450.VoltageProtection);
 fSettingsShow[kt_mode].Data:=ord(fKt_2450.Mode);

end;

procedure TKt_2450_Show.OutputOffOkClick;
begin
// fKt_2450.SetOutputOffState(TKt_2450_OutputOffState(fSettingsShow[kt_outputoff].Data));
end;

procedure TKt_2450_Show.OutPutOnFromDevice;
begin
  fOutPutOnOff.OnClick:=nil;
  fOutPutOnOff.Caption:=Kt2450_OutPutOnOffButtonName[fKt_2450.OutPutOn];
  fOutPutOnOff.Down:=fKt_2450.OutPutOn;
  fOutPutOnOff.OnClick:=OutPutOnOffSpeedButtonClick;
end;

procedure TKt_2450_Show.OutPutOnOffSpeedButtonClick(Sender: TObject);
begin
 fKt_2450.OutPutChange(fOutPutOnOff.Down);
 fOutPutOnOff.Caption:=Kt2450_OutPutOnOffButtonName[fOutPutOnOff.Down];
// if fOutPutOnOff.Down then fOutPutOnOff.Caption:='OutPut on'
//                      else fOutPutOnOff.Caption:='OutPut off'
end;

procedure TKt_2450_Show.ReadFromIniFile(ConfigFile: TIniFile);
// var i:integer;
begin
//   for I := 0 to ord(High(TKt2450_Settings)) do
//    fSettingsShow[TKt2450_Settings(i)].ReadFromIniFile(ConfigFile);

  fSetupMemoryShow.ReadFromIniFile(ConfigFile);
//  SettingToObject();
end;

procedure TKt_2450_Show.ResCompOkClick;
begin
 if fSettingsShow[kt_rescomp].Data=0
    then fKt_2450.SetResistanceCompencate(True)
    else fKt_2450.SetResistanceCompencate(False)
end;

procedure TKt_2450_Show.ResetButtonClick(Sender: TObject);
begin
 fKt_2450.ResetSetting();
end;

procedure TKt_2450_Show.SenseCurOkClick;
begin
 fKt_2450.SetSense(kt_mCurrent,TKt2450_Sense(fSettingsShow[kt_curr_sense].Data));
end;

procedure TKt_2450_Show.SenseResOkClick;
begin
 fKt_2450.SetSense(kt_mResistance,TKt2450_Sense(fSettingsShow[kt_res_sense].Data));
end;

procedure TKt_2450_Show.SenseVoltOkClick;
begin
 fKt_2450.SetSense(kt_mVoltage,TKt2450_Sense(fSettingsShow[kt_volt_sense].Data));
end;

procedure TKt_2450_Show.SettingsShowCreate(STexts: array of TStaticText;
                                           Labels:array of TLabel);
 const
      SettingsCaption:array[TKt2450_Settings]of string=
      ('CurrentSense','VoltageSense','Resistance',
      'OutputOff State','ResistComp','Overvoltage Protection','Device Mode');
 var i:TKt2450_Settings;
begin

 for I := Low(TKt2450_Settings) to kt_res_sense do
   begin
   fSettingsShow[i]:=TStringParameterShow.Create(STexts[ord(i)],
                        SettingsCaption[i], fSettingsShowSL[i]);
   fSettingsShow[i].ForUseInShowObject(fKt_2450,False,False);
   fSettingsShow[i].SetName(fKt_2450.Name+'Sense');
   end;

  fSettingsShow[kt_curr_sense].HookParameterClick:=SenseCurOkClick;
  fSettingsShow[kt_volt_sense].HookParameterClick:=SenseVoltOkClick;
  fSettingsShow[kt_res_sense].HookParameterClick:=SenseResOkClick;
//  fSettingsShow[gds_ch2_scale].HookParameterClick:=ScaleCh2OkClick;

 for I := kt_outputoff to High(TKt2450_Settings) do
   begin
//   showmessage(fSettingsShowSL[i].Text);
//   if i= kt_mode then STexts[ord(i)].AutoSize:=False;
   fSettingsShow[i]:=TStringParameterShow.Create(STexts[ord(i)],
                        Labels[ord(i)-ord(kt_outputoff)], SettingsCaption[i], fSettingsShowSL[i]);
   fSettingsShow[i].ForUseInShowObject(fKt_2450,False,False);

   
   end;

  fSettingsShow[kt_outputoff].HookParameterClick:=OutputOffOkClick;
  fSettingsShow[kt_outputoff].SetName(fKt_2450.Name+'OutputOff');
  fSettingsShow[kt_rescomp].HookParameterClick:=ResCompOkClick;
  fSettingsShow[kt_rescomp].SetName(fKt_2450.Name+'ResComp');
  fSettingsShow[kt_voltprot].HookParameterClick:=VoltageProtectionOkClick;
  fSettingsShow[kt_voltprot].SetName(fKt_2450.Name+'VoltProt');

  fSettingsShow[kt_mode].HookParameterClick:=ModeOkClick;
  fSettingsShow[kt_mode].SetName(fKt_2450.Name+'Mode');
//  fSettingsShow[kt_mode].
end;

procedure TKt_2450_Show.SettingsShowFree;
 var i:TKt2450_Settings;
begin
 for I := Low(TKt2450_Settings) to High(TKt2450_Settings) do
   FreeAndNil(fSettingsShow[i]);
end;

procedure TKt_2450_Show.SettingsShowSLCreate;
 var i:integer;
begin
 for I := 0 to ord(kt_curr_sense) do
  begin
  fSettingsShowSL[TKt2450_Settings(i)]:=TStringList.Create();
  fSettingsShowSL[TKt2450_Settings(i)].Clear;
  end;

  for I := 0 to ord(High(TKt2450_Sense)) do
    fSettingsShowSL[kt_curr_sense].Add(KT2450_SenseLabels[TKt2450_Sense(i)]);

  fSettingsShowSL[kt_volt_sense]:=fSettingsShowSL[kt_curr_sense];
  fSettingsShowSL[kt_res_sense]:=fSettingsShowSL[kt_curr_sense];

  for I := ord(kt_outputoff) to ord(High(TKt2450_Settings)) do
   begin
   fSettingsShowSL[TKt2450_Settings(i)]:=TStringList.Create();
   fSettingsShowSL[TKt2450_Settings(i)].Clear;
   end;

 for I := 0 to ord(High(TKt_2450_OutputOffState)) do
  fSettingsShowSL[kt_outputoff].Add(KT2450_OutputOffStateLabels[TKt_2450_OutputOffState(i)]);
 for I := 0 to 1 do
  fSettingsShowSL[kt_rescomp].Add(SuffixKt_2450[i]);
 for I := 0 to ord(High(TKt_2450_VoltageProtection)) do
  fSettingsShowSL[kt_voltprot].Add(Kt_2450_VoltageProtectionLabel[TKt_2450_VoltageProtection(i)]);

 for I := 0 to ord(High(TKt_2450_Mode)) do
  fSettingsShowSL[kt_mode].Add(KT2450_ModeLabels[TKt_2450_Mode(i)]);
end;

procedure TKt_2450_Show.SettingsShowSLFree;
 var i:integer;
begin
 for I := 0 to ord(kt_curr_sense) do
  fSettingsShowSL[TKt2450_Settings(i)].Free;

 for I := ord(kt_outputoff) to ord(High(TKt2450_Settings)) do
  fSettingsShowSL[TKt2450_Settings(i)].Free;
end;

procedure TKt_2450_Show.SettingToObject;
begin

end;

procedure TKt_2450_Show.SpeedButtonsTune(SpeedButtons: array of TSpeedButton);
begin
  fOutPutOnOff:=SpeedButtons[0];
  fOutPutOnOff.OnClick:=OutPutOnOffSpeedButtonClick;
  fOutPutOnOff.Caption:='Output';
  fTerminalsFrRe:=SpeedButtons[1];
//  fTerminalsFrRe.OnClick:=TerminalsFrReSpeedButtonClick;
//  fTerminalsFrRe.Caption:='Terminals';

end;

procedure TKt_2450_Show.TerminalsFromDevice;
begin
  fTerminalsFrRe.OnClick:=nil;
  fTerminalsFrRe.Caption:=Kt2450_TerminalsButtonName[fKt_2450.Terminal];
  fTerminalsFrRe.Down:=(fKt_2450.Terminal=kt_otRear);
  fTerminalsFrRe.OnClick:=TerminalsFrReSpeedButtonClick;
end;

procedure TKt_2450_Show.TerminalsFrReSpeedButtonClick(Sender: TObject);
begin
 if fTerminalsFrRe.Down then
      begin
       fKt_2450.SetTerminal(kt_otRear);
       fTerminalsFrRe.Caption:=Kt2450_TerminalsButtonName[kt_otRear];
      end             else
      begin
       fKt_2450.SetTerminal(kt_otFront);
       fTerminalsFrRe.Caption:=Kt2450_TerminalsButtonName[kt_otFront];
      end;
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


procedure TKt_2450_Show.VoltageProtectionOkClick;
begin
 fKt_2450.SetVoltageProtection(TKt_2450_VoltageProtection
                          (fSettingsShow[kt_voltprot].Data));
end;

procedure TKt_2450_Show.WriteToIniFile(ConfigFile: TIniFile);
// var i:integer;
begin
// for I := 0 to ord(High(TKt2450_Settings)) do
//  fSettingsShow[TKt2450_Settings(i)].WriteToIniFile(ConfigFile);
 fSetupMemoryShow.WriteToIniFile(ConfigFile);
end;

{ TKT2450_SetupMemory }

procedure TKT2450_SetupMemoryShow.CommandSend;
begin

end;

constructor TKT2450_SetupMemoryShow.Create(KT2450_Show:TKt_2450_Show;
                              PanelSave, PanelLoad: TPanel);
begin
 fKT2450_Show:=KT2450_Show;
 fMemoryPins:=TKT2450_SetupMemoryPins.Create(fKT2450_Show.fKt_2450.Name);
 inherited Create(fMemoryPins,[PanelSave, PanelLoad]);
 LabelsFilling();
end;

{ TKT2450_SetupMemoryPins }

constructor TKT2450_SetupMemoryPins.Create(Name: string);
begin
 inherited Create(Name,['SaveSlot','LoadSlot']);
 PinStrPart:='';
end;

destructor TKT2450_SetupMemoryShow.Destroy;
begin
  fKT2450_Show:=nil;
  FreeAndNil(fMemoryPins);
  inherited;
end;

procedure TKT2450_SetupMemoryShow.LabelsFilling;
 var i:TKt2450_SetupMemorySlot;
begin
 fPinVariants[0].Clear;
 fPinVariants[1].Clear;
 for I := Low(TKt2450_SetupMemorySlot) to High(TKt2450_SetupMemorySlot) do
   begin
     fPinVariants[0].Add(inttostr(I));
     fPinVariants[1].Add(inttostr(I));
   end;
end;

procedure TKT2450_SetupMemoryShow.NumberPinShow(PinActiveNumber: integer;ChooseNumber:integer);
begin
 inherited;
 case PinActiveNumber of
  0:fKT2450_Show.fKt_2450.SaveSetup(TKt2450_SetupMemorySlot(ChooseNumber));
  1:fKT2450_Show.fKt_2450.LoadSetup(TKt2450_SetupMemorySlot(ChooseNumber));
 end;
end;

function TKT2450_SetupMemoryPins.GetPinStr(Index: integer): string;
begin
 case Index of
  0:Result:='Save Setup';
  else Result:='Load Setup';
 end;
end;

{ TKt_2450_AbstractElementShow }

constructor TKt_2450_AbstractElementShow.Create(Kt_2450: TKt_2450;
             STexts: array of TStaticText; Labels: array of TLabel);
begin
  fKt_2450:=Kt_2450;
  SettingsShowSLCreate();
  SettingsShowCreate(STexts,Labels);
  CreateFooter();
  ObjectToSetting();
end;

destructor TKt_2450_AbstractElementShow.Destroy;
begin
  SettingsShowFree;
  SettingsShowSLFree;
  inherited;
end;

end.
