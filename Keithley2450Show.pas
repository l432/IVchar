unit Keithley2450Show;

interface

uses
  OlegTypePart2, Keithley2450, StdCtrls, Buttons,
  ArduinoDeviceNew, ExtCtrls, IniFiles, OlegShowTypes, Classes, 
  Keitley2450Const, OlegType;

const
  ButtonNumberKt2450 = 4;
  SpeedButtonNumberKt2450 = 1;
  PanelNumberKt2450 = 1;
  CheckBoxNumberKt2450 = 2;

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
  procedure SettingsShowFree();virtual;abstract;
  procedure SettingsShowCreate(STexts:array of TStaticText;
                          Labels:array of TLabel);virtual;abstract;
  procedure CreateFooter();
 public
  Constructor Create(Kt_2450:TKt_2450;
                      STexts:array of TStaticText;
                      Labels:array of TLabel
                      );
  destructor Destroy;override;
  procedure ObjectToSetting;virtual;abstract;
 end;

TKt_RangeShow=class(TStringParameterShow)
 private
  fSettingsShowSL:TStringList;
  fType:TKt2450_Source;
  fKt_2450:TKt_2450;
  procedure RangeOkClick();virtual;abstract;
  procedure SettingsShowSLFilling();virtual;
  procedure TypeDetermination();virtual;abstract;
  procedure SetEnabled(Value:boolean);virtual;
  function GetEnable():boolean;
 public
  property Enabled:boolean read GetEnable write SetEnabled;
  Constructor Create(ST:TStaticText;{Source:TKt2450_Source;}Kt_2450:TKt_2450);
  destructor Destroy;override;
  procedure ObjectToSetting;virtual;abstract;
end;

TKt_RangeMeasureShow=class(TKt_RangeShow)
 private
  fHookHookParameterClick: TSimpleEvent;
  procedure RangeOkClick();override;
  procedure TypeDetermination();override;
 public
  property HookHookParameterClick:TSimpleEvent read fHookHookParameterClick write fHookHookParameterClick;
  Constructor Create(ST:TStaticText;Kt_2450:TKt_2450);
  procedure ObjectToSetting;override;
end;

TKt_RangeSourceShow=class(TKt_RangeShow)
 private
  procedure RangeOkClick();override;
  procedure TypeDetermination();override;
 public
  procedure ObjectToSetting;override;
end;


TKt_RangeLimitedShow=class(TKt_RangeMeasureShow)
 private
  fLabel:TLabel;
  procedure SettingsShowSLFilling();override;
  procedure SetEnabled(Value:boolean);override;
  procedure RangeOkClick();override;
 public
  Constructor Create(ST:TStaticText;Kt_2450:TKt_2450;Lab:TLabel);
  procedure ObjectToSetting;override;
end;



TKt_2450_SourceShow=class(TKt_2450_AbstractElementShow)
 private
//  fSourceType:TKt2450_Source;
  fSettingsShow:array[kt_ss_outputoff..kt_ss_limit]of TParameterShowNew;
  fSettingsShowSL:array[kt_ss_outputoff..kt_ss_outputoff]of TStringList;
  fLimitLabelNames:array[TKt2450_Source]of string;
  fCBReadBack: TCheckBox;
  fCBDelay:TCheckBox;
  STDelay:TStaticText;

  fRangeShow:TKt_RangeSourceShow;

  procedure SettingsShowSLCreate();override;
  procedure SettingsShowFree();override;
  procedure SettingsShowCreate(STexts:array of TStaticText;
                          Labels:array of TLabel);override;
//  procedure SettingsShowFree;override;
  procedure OutputOffOkClick();
  procedure LimitClick();
  procedure DelayClick();
  procedure ReadBackClick(Sender:TObject);
 public
  Constructor Create(Kt_2450:TKt_2450;
                      STexts:array of TStaticText;
                      Labels:array of TLabel;
                      CBoxs:array of TCheckBox{;
                      SourceType:TKt2450_Source}
                      );
  destructor Destroy;override;
  procedure ObjectToSetting;override;
 end;

TKt_2450_MeasurementShow=class(TKt_2450_AbstractElementShow)
 private
  fSettingsShow:array[kt_ms_rescomp..kt_ms_sense]of TStringParameterShow;
  fSettingsShowSL:array[kt_ms_rescomp..kt_ms_sense]of TStringList;

  fRangeShow:TKt_RangeMeasureShow;
  fRangeLimitedShow:TKt_RangeLimitedShow;

  procedure SettingsShowSLCreate();override;
  procedure SettingsShowFree();override;
  procedure SettingsShowCreate(STexts:array of TStaticText;
                          Labels:array of TLabel);override;
  procedure ResCompOkClick();
  procedure SenseOkClick();
 public
  property RangeShow:TKt_RangeMeasureShow read fRangeShow;
  Constructor Create(Kt_2450:TKt_2450;
                      STexts:array of TStaticText;
                      Labels:array of TLabel;
                      GroupBox:TGroupBox;
                      ShowType:TKt2450_MeasureShowType
                      );
  destructor Destroy;override;
  procedure ObjectToSetting;override;
  procedure ChangeRange();
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

   fSourceShow:TKt_2450_SourceShow;
   SourceShowStaticText:array[TKt2450_SourceSettings]of TStaticText;
   SourceShowLabels:array[TKt2450_SourceSettings]of TLabel;
   SourceReadBackCB: TCheckBox;
   fSourceDelayCB: TCheckBox;
   fSourceShowState:0..2;
   {2 - не створювався, 0 - створено під kt_sVolt; 1 - kt_sCurr}

   fMeasurementShow:TKt_2450_MeasurementShow;
   fMeasurementShowStaticText:array[TKt2450_MeasureSettings]of TStaticText;
   fMeasurementShowLabels:array[TKt2450_MeasureSettings]of TLabel;
   fMeasurementShowGB:TGroupBox;
   fMeasurementShowState:0..5;
   {5 - не створювався, 0 - створено під струм; 1 - напругу,
    3 - опір, 4 - потужність}
   fAutoZeroCB: TCheckBox;
   fZeroManualB:TButton;

   procedure SourceShowCreate();
   procedure SourceShowFree();

   procedure MeasureShowCreate();
   procedure MeasureShowFree();

   procedure TestButtonClick(Sender:TObject);
   procedure ResetButtonClick(Sender:TObject);
   procedure GetSettingButtonClick(Sender:TObject);
   procedure RefreshZeroClick(Sender:TObject);
   procedure MyTrainButtonClick(Sender:TObject);
   procedure AutoZeroClick(Sender:TObject);
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
   procedure AZeroFromDevice();
   procedure VoltageProtectionOkClick();
   procedure ModeOkClick();
    procedure ReCreateElements;
  public
   Constructor Create(Kt_2450:TKt_2450;
                      Buttons:Array of TButton;
                      SpeedButtons:Array of TSpeedButton;
                      Panels:Array of TPanel;
                      STexts:array of TStaticText;
                      Labels:array of TLabel;
                      CheckBoxs:array of TCheckBox;
                      GroupBox:TGroupBox);
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

procedure TKt_2450_Show.AutoZeroClick(Sender: TObject);
begin
 fKt_2450.SetAzeroState(fAutoZeroCB.Checked);
 fZeroManualB.Enabled:=not(fAutoZeroCB.Checked);
end;

procedure TKt_2450_Show.AZeroFromDevice;
begin
 if fAutoZeroCB.Checked<>fKt_2450.AzeroState[fKt_2450.MeasureFunction] then
  begin
    fAutoZeroCB.OnClick:=nil;
    fAutoZeroCB.Checked:=not(fAutoZeroCB.Checked);
    fAutoZeroCB.OnClick:=AutoZeroClick;
    fZeroManualB.Enabled:=not(fAutoZeroCB.Checked);
  end;
end;

procedure TKt_2450_Show.ButtonsTune(Buttons: array of TButton);
const
  ButtonCaption: array[0..ButtonNumberKt2450] of string =
  ('Connection Test ?','Reset','Get','Refresh Zero','MyTrain');
var
  ButtonAction: array[0..ButtonNumberKt2450] of TNotifyEvent;
  i: Integer;
begin
  ButtonAction[0] := TestButtonClick;
  ButtonAction[1] := ResetButtonClick;
  ButtonAction[2] := GetSettingButtonClick;
  ButtonAction[3] := RefreshZeroClick;

   ButtonAction[ButtonNumberKt2450] := MyTrainButtonClick;
  for I := 0 to ButtonNumberKt2450 do
  begin
    Buttons[i].Caption := ButtonCaption[i];
    Buttons[i].OnClick := ButtonAction[i];
  end;
  BTest := Buttons[0];
  fZeroManualB:= Buttons[3];
end;

constructor TKt_2450_Show.Create(Kt_2450: TKt_2450;
                                Buttons:Array of TButton;
                                SpeedButtons:Array of TSpeedButton;
                                Panels:Array of TPanel;
                                STexts:array of TStaticText;
                                Labels:array of TLabel;
                                CheckBoxs:array of TCheckBox;
                                GroupBox:TGroupBox
                                );
 var i,CBnumber:integer;

begin
  if (High(Buttons)<>ButtonNumberKt2450)
     or(High(SpeedButtons)<>SpeedButtonNumberKt2450)
     or(High(Panels)<>PanelNumberKt2450)
     or(High(STexts)<>((ord(High(TKt2450_Settings))+ord(High(TKt2450_SourceSettings))+1
                        +ord(High(TKt2450_MeasureSettings))+1)))
     or(High(Labels)<>(ord(High(TKt2450_Settings))
                       +ord(kt_ss_limit)-ord(kt_ss_outputoff)+1
                       +ord(kt_ms_rescomp)-ord(kt_ms_rescomp)+1+1))
     or(High(CheckBoxs)<>CheckBoxNumberKt2450)
   then
    begin
      showmessage('Kt_2450_Show is not created!');
      Exit;
    end;
  fKt_2450:=Kt_2450;
  ButtonsTune(Buttons);
  SpeedButtonsTune(SpeedButtons);

  CBnumber:=0;

  SettingsShowSLCreate();
  SettingsShowCreate(STexts,Labels);

  fSourceShowState:=2;
  for i:=0 to ord(High(TKt2450_SourceSettings)) do
     SourceShowStaticText[TKt2450_SourceSettings(i)]:=STexts[ord(High(TKt2450_Settings))+1+i];
  for i:=0 to ord(kt_ss_limit) do
     SourceShowLabels[TKt2450_SourceSettings(i)]:=Labels[ord(High(TKt2450_Settings))+1+i];
  SourceReadBackCB:=CheckBoxs[CBnumber];
  inc(CBnumber);
  fSourceDelayCB:=CheckBoxs[CBnumber];
  inc(CBnumber);
  SourceShowCreate();

  fMeasurementShowState:=5;
  for i:=0 to ord(High(TKt2450_MeasureSettings)) do
     fMeasurementShowStaticText[TKt2450_MeasureSettings(i)]:=STexts[ord(High(TKt2450_Settings))+1
                                                           +ord(High(TKt2450_SourceSettings))+1+i];
 i:=ord(High(TKt2450_Settings))+1+ord(kt_ss_limit)-ord(kt_ss_outputoff)+1;
 fMeasurementShowLabels[kt_ms_rescomp]:=Labels[i];
 fMeasurementShowLabels[kt_ms_lrange]:=Labels[i+1];
//   for i:=ord(kt_ms_rescomp) to ord(kt_ms_rescomp) do
//       fMeasurementShowLabels[TKt2450_MeasureSettings(ord(kt_ms_rescomp)+i)]:=
//                            Labels[ord(High(TKt2450_Settings))+1
//                                   +ord(kt_ss_limit)-ord(kt_ss_outputoff)+1+i];

  fMeasurementShowGB:=GroupBox;
  MeasureShowCreate();

  fAutoZeroCB:=CheckBoxs[CBnumber];
//  inc(CBnumber);

  fSetupMemoryShow:=TKT2450_SetupMemoryShow.Create(Self,Panels[0],Panels[1]);

  ObjectToSetting();
end;

destructor TKt_2450_Show.Destroy;
begin
  FreeAndNil(fSetupMemoryShow);
  MeasureShowFree();
  SourceShowFree();
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
    fKt_2450.GetVoltageProtection;
    fKt_2450.GetDeviceMode;
    fKt_2450.IsResistanceCompencateOn();
    fKt_2450.GetVoltageLimit();
    fKt_2450.GetCurrentLimit();
    fKt_2450.GetReadBacks();
    fKt_2450.GetSenses();
    fKt_2450.GetOutputOffStates;
    fKt_2450.GetSourceRanges();
//    fKt_2450.GetMeasureRange();
//      fKt_2450.GetMeasureLowRange();
//      fKt_2450.IsAzeroStateOn();
//   fKt_2450.GetSourceDelay();
//     fKt_2450.IsSourceDelayAutoOn();
    end;

  ObjectToSetting();
end;

procedure TKt_2450_Show.MeasureShowCreate;
 var MeasureShowType:TKt2450_MeasureShowType;
begin
  case fKt_2450.Mode of
    kt_md_sVmC,
    kt_md_sImC:MeasureShowType:=kt_mst_cur;
    kt_md_sVmV,
    kt_md_sImV:MeasureShowType:=kt_mst_volt;
    kt_md_sVmR,
    kt_md_sImR:MeasureShowType:=kt_mst_res;
    else MeasureShowType:=kt_mst_pow;
  end;

 if fMeasurementShowState=ord(MeasureShowType) then Exit;
 MeasureShowFree();
 fMeasurementShow:=TKt_2450_MeasurementShow.Create(fKt_2450,
                 [fMeasurementShowStaticText[kt_ms_rescomp],
                  fMeasurementShowStaticText[kt_ms_sense],
                  fMeasurementShowStaticText[kt_ms_range],
                  fMeasurementShowStaticText[kt_ms_lrange]],
                 [fMeasurementShowLabels[kt_ms_rescomp],
                  fMeasurementShowLabels[kt_ms_lrange]],
                  fMeasurementShowGB,
                  MeasureShowType
                  );
end;

procedure TKt_2450_Show.MeasureShowFree;
begin
 if fMeasurementShowState<>5 then FreeAndNil(fMeasurementShow);
end;

procedure TKt_2450_Show.ModeOkClick;
begin
 fKt_2450.SetMode(TKt_2450_Mode(fSettingsShow[kt_mode].Data));
 ReCreateElements();
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
 ReCreateElements();


end;

procedure TKt_2450_Show.ReCreateElements;
begin
  SourceShowCreate;
  MeasureShowCreate;
  if fKt_2450.Mode in [kt_md_sVmV, kt_md_sImC] then
    fMeasurementShow.RangeShow.Enabled := False
  else
    fMeasurementShow.RangeShow.Enabled := True;
  fMeasurementShow.ChangeRange();
  AZeroFromDevice();
end;

procedure TKt_2450_Show.RefreshZeroClick(Sender: TObject);
begin
 fKt_2450.AzeroOnce();
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
end;

procedure TKt_2450_Show.ReadFromIniFile(ConfigFile: TIniFile);
begin
  fSetupMemoryShow.ReadFromIniFile(ConfigFile);
end;

procedure TKt_2450_Show.ResetButtonClick(Sender: TObject);
begin
 fKt_2450.ResetSetting();
end;

procedure TKt_2450_Show.SettingsShowCreate(STexts: array of TStaticText;
                                           Labels:array of TLabel);
 const
      SettingsCaption:array[TKt2450_Settings]of string=
      ('Overvoltage Protection','Device Mode');
 var i:TKt2450_Settings;
begin

 for I := Low(TKt2450_Settings) to High(TKt2450_Settings) do
   begin
   fSettingsShow[i]:=TStringParameterShow.Create(STexts[ord(i)],
                        Labels[ord(i)], SettingsCaption[i], fSettingsShowSL[i]);
   fSettingsShow[i].ForUseInShowObject(fKt_2450,False,False);
   end;

  fSettingsShow[kt_voltprot].HookParameterClick:=VoltageProtectionOkClick;

  fSettingsShow[kt_mode].HookParameterClick:=ModeOkClick;
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
  for I := 0 to ord(High(TKt2450_Settings)) do
   begin
   fSettingsShowSL[TKt2450_Settings(i)]:=TStringList.Create();
   fSettingsShowSL[TKt2450_Settings(i)].Clear;
   end;

 for I := 0 to ord(High(TKt_2450_VoltageProtection)) do
  fSettingsShowSL[kt_voltprot].Add(Kt_2450_VoltageProtectionLabel[TKt_2450_VoltageProtection(i)]);

 for I := 0 to ord(High(TKt_2450_Mode)) do
  fSettingsShowSL[kt_mode].Add(KT2450_ModeLabels[TKt_2450_Mode(i)]);

end;

procedure TKt_2450_Show.SettingsShowSLFree;
 var i:integer;
begin
 for I := 0 to ord(High(TKt2450_Settings)) do
  fSettingsShowSL[TKt2450_Settings(i)].Free;
end;

procedure TKt_2450_Show.SettingToObject;
begin

end;

procedure TKt_2450_Show.SourceShowCreate;
begin
 if fSourceShowState=ord(fKt_2450.SourceType) then Exit;
 SourceShowFree();
 fSourceShow:=TKt_2450_SourceShow.Create(fKt_2450,
                 [SourceShowStaticText[kt_ss_outputoff],
                  SourceShowStaticText[kt_ss_delay],
                  SourceShowStaticText[kt_ss_limit],
                  SourceShowStaticText[kt_ss_range]],
                 [SourceShowLabels[kt_ss_outputoff],
                  SourceShowLabels[kt_ss_delay],
                  SourceShowLabels[kt_ss_limit]],
                  [SourceReadBackCB,fSourceDelayCB]
                  );
// fSourceShow.ObjectToSetting;
end;

procedure TKt_2450_Show.SourceShowFree;
begin
 if fSourceShowState<>2 then FreeAndNil(fSourceShow);
end;

procedure TKt_2450_Show.SpeedButtonsTune(SpeedButtons: array of TSpeedButton);
begin
  fOutPutOnOff:=SpeedButtons[0];
  fOutPutOnOff.OnClick:=OutPutOnOffSpeedButtonClick;
  fOutPutOnOff.Caption:='Output';
  fTerminalsFrRe:=SpeedButtons[1];
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
begin
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
  inherited Create;
  fKt_2450:=Kt_2450;
  SettingsShowSLCreate();
  SettingsShowCreate(STexts,Labels);
  CreateFooter();
  ObjectToSetting();
end;

procedure TKt_2450_AbstractElementShow.CreateFooter;
begin
end;

destructor TKt_2450_AbstractElementShow.Destroy;
begin
  SettingsShowFree;
  inherited;
end;

{ TKt_2450_SourceShow }

constructor TKt_2450_SourceShow.Create(Kt_2450: TKt_2450;
  STexts: array of TStaticText; Labels: array of TLabel;
  CBoxs:array of TCheckBox);
begin
// fSourceType:=Kt_2450.SourceType;
 fCBReadBack:=CBoxs[0];
 fCBReadBack.Checked:=True;
 fCBReadBack.OnClick:=ReadBackClick;
 fCBDelay:=CBoxs[1];
 fCBDelay.OnClick:=ReadBackClick;
 fRangeShow:=TKt_RangeSourceShow.Create(STexts[ord(kt_ss_range)],Kt_2450);
 inherited Create(Kt_2450,STexts,Labels);

end;

procedure TKt_2450_SourceShow.DelayClick;
begin
 fKt_2450.SetSourceDelay((fSettingsShow[kt_ss_delay] as TDoubleParameterShow).Data);
 (fSettingsShow[kt_ss_delay] as TDoubleParameterShow).Data:=fKt_2450.SourceDelay[fKt_2450.SourceType];
end;

destructor TKt_2450_SourceShow.Destroy;
begin
  FreeAndNil(fRangeShow);
  inherited;
end;

procedure TKt_2450_SourceShow.LimitClick;
begin
// case fSourceType of
 case fKt_2450.SourceType of
   kt_sVolt: fKt_2450.SetCurrentLimit((fSettingsShow[kt_ss_limit] as TDoubleParameterShow).Data);
   kt_sCurr: fKt_2450.SetVoltageLimit((fSettingsShow[kt_ss_limit] as TDoubleParameterShow).Data);
 end;
// case fSourceType of
 case fKt_2450.SourceType of
   kt_sVolt: (fSettingsShow[kt_ss_limit] as TDoubleParameterShow).Data:=fKt_2450.CurrentLimit;
   kt_sCurr: (fSettingsShow[kt_ss_limit] as TDoubleParameterShow).Data:=fKt_2450.VoltageLimit;
 end;
end;

procedure TKt_2450_SourceShow.ObjectToSetting;
begin
 (fSettingsShow[kt_ss_outputoff] as TStringParameterShow).Data:=
//    ord(fKt_2450.OutputOffState[fSourceType]);
    ord(fKt_2450.OutputOffState[fKt_2450.SourceType]);
// case fSourceType of
 case fKt_2450.SourceType of
   kt_sVolt: (fSettingsShow[kt_ss_limit] as TDoubleParameterShow).Data:=fKt_2450.CurrentLimit;
   kt_sCurr: (fSettingsShow[kt_ss_limit] as TDoubleParameterShow).Data:=fKt_2450.VoltageLimit;
 end;
 (fSettingsShow[kt_ss_delay] as TDoubleParameterShow).Data:=fKt_2450.SourceDelay[fKt_2450.SourceType];
// if fKt_2450.ReadBack[fSourceType]<>fCBReadBack.Checked then
 if fKt_2450.ReadBack[fKt_2450.SourceType]<>fCBReadBack.Checked then
  begin
   fCBReadBack.OnClick:=nil;
//   fCBReadBack.Checked:=fKt_2450.ReadBack[fSourceType];
   fCBReadBack.Checked:=fKt_2450.ReadBack[fKt_2450.SourceType];
   fCBReadBack.OnClick:=ReadBackClick;
  end;

 if fKt_2450.SourceDelayAuto[fKt_2450.SourceType]<>fCBDelay.Checked then
  begin
   fCBDelay.OnClick:=nil;
   fCBDelay.Checked:=fKt_2450.SourceDelayAuto[fKt_2450.SourceType];
   fCBDelay.OnClick:=ReadBackClick;
  end;
 STDelay.Enabled:=not(fCBDelay.Checked);

 fRangeShow.ObjectToSetting;
// case fSourceType of
//   kt_sVolt: fRangeShow.Data:=ord(fKt_2450.SourceVoltageRange);
//   kt_sCurr: fRangeShow.Data:=ord(fKt_2450.SourceCurrentRange);
// end;


end;

procedure TKt_2450_SourceShow.OutputOffOkClick;
begin
// fKt_2450.SetOutputOffState(fSourceType,
 fKt_2450.SetOutputOffState(fKt_2450.SourceType,
    TKt_2450_OutputOffState((fSettingsShow[kt_ss_outputoff] as TStringParameterShow).Data));
end;

procedure TKt_2450_SourceShow.ReadBackClick(Sender: TObject);
begin
 if (Sender=fCBReadBack) then fKt_2450.SetReadBackState(fCBReadBack.Checked);
 if (Sender=fCBDelay) then
    begin
     fKt_2450.SetSourceDelayAuto(fCBDelay.Checked);
     STDelay.Enabled:=not(fCBDelay.Checked);
    end;
end;

procedure TKt_2450_SourceShow.SettingsShowCreate(STexts: array of TStaticText;
  Labels: array of TLabel);
 const
      SettingsCaption:array[kt_ss_outputoff..kt_ss_outputoff]of string=
      ('OutputOff Type');
 var i:TKt2450_SourceSettings;
     LimitValueDef:double;
begin

 for I := kt_ss_outputoff to kt_ss_outputoff do
   begin
   fSettingsShow[i]:=TStringParameterShow.Create(STexts[ord(i)],
                         Labels[ord(i)],SettingsCaption[i], fSettingsShowSL[i]);
//   fSettingsShow[i].ForUseInShowObject(fKt_2450,False,False);
   end;
  fSettingsShow[kt_ss_outputoff].HookParameterClick:=OutputOffOkClick;

//  if fSourceType=kt_sVolt
  if fKt_2450.SourceType=kt_sVolt
      then LimitValueDef:=Kt_2450_CurrentLimDef
      else LimitValueDef:=Kt_2450_VoltageLimDef;


  fSettingsShow[kt_ss_limit]:=TDoubleParameterShow.Create(STexts[ord(kt_ss_limit)],
                                Labels[ord(kt_ss_limit)],
                                fLimitLabelNames[fKt_2450.SourceType],
                                LimitValueDef);
 fSettingsShow[kt_ss_limit].HookParameterClick:=LimitClick;
 Labels[ord(kt_ss_limit)].WordWrap:=False;

  fSettingsShow[kt_ss_delay]:=TDoubleParameterShow.Create(STexts[ord(kt_ss_delay)],
                                Labels[ord(kt_ss_delay)],
                                'Delay after source set, s',
                                0,5);
 fSettingsShow[kt_ss_delay].HookParameterClick:=DelayClick;
 Labels[ord(kt_ss_delay)].WordWrap:=False;
 STDelay:=STexts[ord(kt_ss_delay)];
end;


procedure TKt_2450_SourceShow.SettingsShowFree;
 var i:TKt2450_SourceSettings;
begin
 for I := low(fSettingsShowSL) to High(fSettingsShowSL) do
  FreeAndNil(fSettingsShowSL[i]);
 for i := Low(fSettingsShow) to High(fSettingsShow) do
  FreeAndNil(fSettingsShow[i]);
end;

procedure TKt_2450_SourceShow.SettingsShowSLCreate;
 var i:integer;
begin

 for I := ord(kt_ss_outputoff) to ord(kt_ss_outputoff) do
  begin
  fSettingsShowSL[TKt2450_SourceSettings(i)]:=TStringList.Create();
  fSettingsShowSL[TKt2450_SourceSettings(i)].Clear;
  end;

 for I := 0 to ord(High(TKt_2450_OutputOffState)) do
   fSettingsShowSL[kt_ss_outputoff].Add(KT2450_OutputOffStateLabels[TKt_2450_OutputOffState(i)]);

 fLimitLabelNames[kt_sVolt]:='Limit'#10'Current, A';
 fLimitLabelNames[kt_sCurr]:='Limit'#10'Voltage, V';
end;

{ TKt_2450_MeasurementShow }

procedure TKt_2450_MeasurementShow.ChangeRange;
begin
 fRangeLimitedShow.Enabled:=fRangeShow.Enabled and (fRangeShow.Data=0);
end;

constructor TKt_2450_MeasurementShow.Create(Kt_2450: TKt_2450;
  STexts: array of TStaticText; Labels: array of TLabel; GroupBox: TGroupBox;
  ShowType:TKt2450_MeasureShowType);
begin
 fRangeShow:=TKt_RangeMeasureShow.Create(STexts[ord(kt_ms_range)],{Kt_2450.SourceType,}Kt_2450);
 fRangeLimitedShow:=TKt_RangeLimitedShow.Create(STexts[ord(kt_ms_lrange)],Kt_2450,Labels[High(Labels)]);
 fRangeShow.HookHookParameterClick:=ChangeRange;
 inherited Create(Kt_2450,STexts,Labels);
 case ShowType of
  kt_mst_cur:GroupBox.Caption:='Current';
  kt_mst_volt:GroupBox.Caption:='Voltage';
  kt_mst_res:GroupBox.Caption:='Resistance';
  kt_mst_pow:GroupBox.Caption:='Power';
 end;
  Labels[ord(kt_ms_rescomp)].Enabled:=(ShowType=kt_mst_res);
  STexts[ord(kt_ms_rescomp)].Enabled:=(ShowType=kt_mst_res);
end;

destructor TKt_2450_MeasurementShow.Destroy;
begin
  FreeAndNil(fRangeLimitedShow);
  FreeAndNil(fRangeShow);
  inherited;
end;

procedure TKt_2450_MeasurementShow.ObjectToSetting;
begin
if fKt_2450.ResistanceCompencateOn[fKt_2450.MeasureFunction]
   then fSettingsShow[kt_ms_rescomp].Data:=0
   else fSettingsShow[kt_ms_rescomp].Data:=1;

  case fKt_2450.Mode of
    kt_md_sVmC,
    kt_md_sVmR,
    kt_md_sVmP,
    kt_md_sImC:fSettingsShow[kt_ms_sense].Data:=ord(fKt_2450.Sences[kt_mCurrent]);
    kt_md_sVmV,
    kt_md_sImV,
    kt_md_sImR,
    kt_md_sImP:fSettingsShow[kt_ms_sense].Data:=ord(fKt_2450.Sences[kt_mVoltage]);
  end;

  fRangeShow.ObjectToSetting;
// case fKt_2450.SourceType of
//   kt_sVolt: fRangeShow.Data:=ord(fKt_2450.MeasureVoltageRange);
//   kt_sCurr: fRangeShow.Data:=ord(fKt_2450.MeasureCurrentRange);
// end;

end;

procedure TKt_2450_MeasurementShow.ResCompOkClick;
begin
 if fSettingsShow[kt_ms_rescomp].Data=0
    then fKt_2450.SetResistanceCompencate(True)
    else fKt_2450.SetResistanceCompencate(False)
end;

procedure TKt_2450_MeasurementShow.SenseOkClick;
begin
  case fKt_2450.Mode of
    kt_md_sVmC,
    kt_md_sVmR,
    kt_md_sVmP,
    kt_md_sImC:fKt_2450.SetSense(kt_mCurrent,TKt2450_Sense(fSettingsShow[kt_ms_sense].Data));
    kt_md_sVmV,
    kt_md_sImV,
    kt_md_sImR,
    kt_md_sImP:fKt_2450.SetSense(kt_mVoltage,TKt2450_Sense(fSettingsShow[kt_ms_sense].Data));
  end;

end;

procedure TKt_2450_MeasurementShow.SettingsShowCreate(
     STexts: array of TStaticText; Labels: array of TLabel);
 const
     SettingsCaption:array[kt_ms_rescomp..kt_ms_sense]of string=
      ('ResistComp','Sense');
 var i:TKt2450_MeasureSettings;
begin
 for I := Low(TKt2450_MeasureSettings) to kt_ms_rescomp do
   fSettingsShow[i]:=TStringParameterShow.Create(STexts[ord(i)],
                        Labels[ord(i)], SettingsCaption[i], fSettingsShowSL[i]);
 fSettingsShow[kt_ms_rescomp].HookParameterClick:=ResCompOkClick;

 for I := kt_ms_sense to kt_ms_sense do
   fSettingsShow[i]:=TStringParameterShow.Create(STexts[ord(i)],
                        SettingsCaption[i], fSettingsShowSL[i]);
 fSettingsShow[kt_ms_sense].HookParameterClick:=SenseOkClick;

end;


procedure TKt_2450_MeasurementShow.SettingsShowSLCreate;
 var i:integer;
begin
  for I := ord(low(fSettingsShowSL)) to ord(High(fSettingsShowSL)) do
   begin
   fSettingsShowSL[TKt2450_MeasureSettings(i)]:=TStringList.Create();
   fSettingsShowSL[TKt2450_MeasureSettings(i)].Clear;
   end;

 for I := 0 to 1 do
  fSettingsShowSL[kt_ms_rescomp].Add(SuffixKt_2450[i]);
 for I := 0 to ord(High(TKt2450_Sense)) do
    fSettingsShowSL[kt_ms_sense].Add(KT2450_SenseLabels[TKt2450_Sense(i)]);

end;

procedure TKt_2450_MeasurementShow.SettingsShowFree;
 var i:TKt2450_MeasureSettings;
begin
 for I := low(fSettingsShowSL) to High(fSettingsShowSL) do
  FreeAndNil(fSettingsShowSL[i]);
 for i := Low(fSettingsShow) to High(fSettingsShow) do
  FreeAndNil(fSettingsShow[i]);
end;

{ TKt_RangeShow }

constructor TKt_RangeShow.Create(ST: TStaticText; {Source: TKt2450_Source;}
  Kt_2450: TKt_2450);
begin
  fKt_2450:=Kt_2450;
  TypeDetermination();
  fSettingsShowSL:=TStringList.Create;
  SettingsShowSLFilling();
  case fType of
    kt_sVolt:
         inherited Create(ST,'Voltage Range',fSettingsShowSL);
    kt_sCurr:
         inherited Create(ST,'Current Range',fSettingsShowSL);
  end;
  HookParameterClick:=RangeOkClick;
end;

destructor TKt_RangeShow.Destroy;
begin
  FreeAndNil(fSettingsShowSL);
  inherited;
end;

function TKt_RangeShow.GetEnable: boolean;
begin
  Result:=STData.Enabled;
end;

procedure TKt_RangeShow.SetEnabled(Value: boolean);
begin
 STData.Enabled:=Value;
end;

procedure TKt_RangeShow.SettingsShowSLFilling;
 var i:integer;
begin
 case fType of
  kt_sVolt:for I := 0 to ord(High(TKt2450VoltageRange)) do
             fSettingsShowSL.Add(KT2450_VoltageRangeLabels[TKt2450VoltageRange(i)]);
  kt_sCurr:for I := 0 to ord(High(TKt2450CurrentRange)) do
            fSettingsShowSL.Add(KT2450_CurrentRangeLabels[TKt2450CurrentRange(i)]);
 end;
end;

{ TKt_RangeMeasureShow }

constructor TKt_RangeMeasureShow.Create(ST: TStaticText; Kt_2450: TKt_2450);
begin
 inherited Create(ST,Kt_2450);
 HookHookParameterClick:=TSimpleClass.EmptyProcedure;
end;

procedure TKt_RangeMeasureShow.ObjectToSetting;
begin
 case fType of
  kt_sVolt:Data:=ord(fKt_2450.MeasureVoltageRange);
  kt_sCurr:Data:=ord(fKt_2450.MeasureCurrentRange);
 end;
end;

procedure TKt_RangeMeasureShow.RangeOkClick;
begin
 case fType of
  kt_sVolt:fKt_2450.SetMeasureVoltageRange(TKt2450VoltageRange(Data));
  kt_sCurr:fKt_2450.SetMeasureCurrentRange(TKt2450CurrentRange(Data));
 end;
 HookHookParameterClick;
end;

procedure TKt_RangeMeasureShow.TypeDetermination;
begin
 if fKt_2450.MeasureFunction=kt_mCurrent
      then fType:=kt_sCurr
      else fType:=kt_sVolt;
end;

{ TKt_RangeSourceShow }

procedure TKt_RangeSourceShow.ObjectToSetting;
begin
 case fType of
  kt_sVolt:Data:=ord(fKt_2450.SourceVoltageRange);
  kt_sCurr:Data:=ord(fKt_2450.SourceCurrentRange);
 end;
end;

procedure TKt_RangeSourceShow.RangeOkClick;
begin
 case fType of
  kt_sVolt:fKt_2450.SetSourceVoltageRange(TKt2450VoltageRange(Data));
  kt_sCurr:fKt_2450.SetSourceCurrentRange(TKt2450CurrentRange(Data));
 end;
end;

procedure TKt_RangeSourceShow.TypeDetermination;
begin
 fType:=fKt_2450.SourceType;
end;

{ TKt_RangeLimitedShow }

constructor TKt_RangeLimitedShow.Create(ST: TStaticText; Kt_2450: TKt_2450;
  Lab: TLabel);
begin
  inherited Create(ST,Kt_2450);
  fLabel:=Lab;
  fLabel.Caption:='Low Auto'#10'Limit';
end;

procedure TKt_RangeLimitedShow.ObjectToSetting;
begin
 case fType of
  kt_sVolt:Data:=ord(fKt_2450.MeasureVoltageLowRange)-1;
  kt_sCurr:Data:=ord(fKt_2450.MeasureCurrentLowRange)-1;
 end;
end;

procedure TKt_RangeLimitedShow.RangeOkClick;
begin
 case fType of
  kt_sVolt:fKt_2450.SetMeasureVoltageLowRange(TKt2450VoltageRange(Data+1));
  kt_sCurr:fKt_2450.SetMeasureCurrentLowRange(TKt2450CurrentRange(Data+1));
 end;
end;

procedure TKt_RangeLimitedShow.SetEnabled(Value: boolean);
begin
 inherited SetEnabled(Value);
 fLabel.Enabled:=Value;
end;

procedure TKt_RangeLimitedShow.SettingsShowSLFilling;
 var i:integer;
begin
 case fType of
  kt_sVolt:for I := 1 to ord(High(TKt2450VoltageRange)) do
             fSettingsShowSL.Add(KT2450_VoltageRangeLabels[TKt2450VoltageRange(i)]);
  kt_sCurr:for I := 1 to ord(High(TKt2450CurrentRange)) do
            fSettingsShowSL.Add(KT2450_CurrentRangeLabels[TKt2450CurrentRange(i)]);
 end;
end;

end.
