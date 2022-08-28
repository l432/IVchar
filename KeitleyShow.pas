unit KeitleyShow;

interface

uses
  OlegTypePart2, Keithley, StdCtrls, OlegShowTypes, Classes, ArduinoDeviceNew, 
  ExtCtrls, IniFiles;

const
  ButtonNumberKeitley = 1;

type

TKeitley_Show=class;

TKeitley_SetupMemoryPins=class(TPins)
 protected
  Function GetPinStr(Index:integer):string;override;
 public
  Constructor Create(Name:string);
end;

TKeitley_SetupMemoryShow=class(TPinsShowUniversal)
 private
  fKeitley_Show:TKeitley_Show;
  fMemoryPins:TKeitley_SetupMemoryPins;
 protected
  procedure LabelsFilling;
  procedure CommandSend;
 public
  Constructor Create(Keitley_Show:TKeitley_Show;
                     PanelSave, PanelLoad:TPanel);
  destructor Destroy;override;
  procedure NumberPinShow(PinActiveNumber:integer=-1;ChooseNumber:integer=-1);override;
end;

TKeitley_StringParameterShow=class(TStringParameterShow)
 protected
  fSettingsShowSL:TStringList;
  fKeitley:TKeitley;
  fCaption:string;
  procedure OkClick();virtual;abstract;
  procedure SettingsShowSLFilling();virtual;abstract;
  procedure SomeAction();virtual;abstract;
 public
  Constructor Create(ST:TStaticText;Keitley:TKeitley);
  destructor Destroy;override;
  procedure ObjectToSetting;virtual;abstract;
end;

TKeitley_BrightnessShow=class(TKeitley_StringParameterShow)
 protected
  procedure OkClick();override;
  procedure SettingsShowSLFilling();override;
  procedure SomeAction();override;
 public
  procedure ObjectToSetting;override;
end;

TKeitley_MeasurementType=class(TKeitley_StringParameterShow)
 protected
  procedure OkClick();override;
  procedure SettingsShowSLFilling();override;
  procedure SomeAction();override;
 public
  procedure ObjectToSetting;override;
end;

 TKeitley_Show=class(TSimpleFreeAndAiniObject)
  private
   fKeitley:TKeitley;

//   fSettingsShow:array of TParameterShowNew;
//   fSettingsShowSL:array of TStringList;

//   fOutPutOnOff:TSpeedButton;
//   fTerminalsFrRe:TSpeedButton;
   fSetupMemoryShow:TKeitley_SetupMemoryShow;
//
//   fSourceShow:TKt_2450_SourceShow;
//   SourceShowStaticText:array[TKt2450_SourceSettings]of TStaticText;
//   SourceShowLabels:array[TKt2450_SourceSettings]of TLabel;
//   SourceValueShowLabel:TLabel;
//   SourceReadBackCB: TCheckBox;
//   fSourceDelayCB: TCheckBox;
//   fSourceHCapac: TCheckBox;
//   fSourceShowState:0..2;
//   {2 - не створювався, 0 - створено під kt_sVolt; 1 - kt_sCurr}
//
//   fMeasurementShow:TKt_2450_MeasurementShow;
//   fMeasurementShowStaticText:array[TKt2450_MeasureSettings]of TStaticText;
//   fMeasurementShowLabels:array[TKt2450_MeasureSettings]of TLabel;
//   fMeasurementShowGB:TGroupBox;
//   fMeasurementShowState:0..5;
//   {5 - не створювався, 0 - створено під струм; 1 - напругу,
//    3 - опір, 4 - потужність}
//   fAutoZeroCB: TCheckBox;
//   fZeroManualB:TButton;
//
//   fSweetShow:TKt_2450_SweetShow;
//   fSweetST:array of TStaticText;
//   fSweetLab:array of TLabel;
//   fSweetButtons:TKt2450_SweepButtonArray;
//   fSweetDualCB,fSweetAbortLimitCB:TCheckBox;
//   fSweetMode:TRadioGroup;
//   fSweetSelect:TRadioGroup;
//   fSweepGB:TGroupBox;
//   fSweetShowState:0..2;
//   {2 - не створювався, 0 - створено під kt_sVolt; 1 - kt_sCurr}
//
//   fMeterShow:TKt_2450_MeterShow;
//
//   fSourceMeterValueLab:TLabel;
//
   fBrightnessShow:TKeitley_BrightnessShow;

//   procedure SourceShowCreate();
//   procedure SourceShowFree();
//
//   procedure MeasureShowCreate();
//   procedure MeasureShowFree();
//
//   procedure SweetShowCreate();
//
   procedure TestButtonClick(Sender:TObject);


//   procedure RefreshZeroClick(Sender:TObject);
//   procedure SourceMeasureClick(Sender:TObject);
   procedure MyTrainButtonClick(Sender:TObject);
//   procedure AutoZeroClick(Sender:TObject);

//   procedure SpeedButtonsTune(SpeedButtons: array of TSpeedButton);
//   procedure SettingsShowSLCreate();
//   procedure SettingsShowCreate(STexts:array of TStaticText;
//                          Labels:array of TLabel);
//   procedure SettingsShowFree;
//   procedure OutPutOnOffSpeedButtonClick(Sender: TObject);
//
//   procedure TerminalsFrReSpeedButtonClick(Sender: TObject);
//   procedure TerminalsFromDevice();
//   procedure AZeroFromDevice();
//   procedure VoltageProtectionOkClick();
//   procedure ModeOkClick();
//   procedure CountOkClick();
//    procedure ReCreateElements;
  protected
//   BTest:TButton;
   procedure ButtonsTune(Buttons: array of TButton);virtual;
   procedure ResetButtonClick(Sender:TObject);virtual;
   procedure GetSettingButtonClick(Sender:TObject);virtual;
  public
//   property MeterShow:TKt_2450_MeterShow read fMeterShow;
   Constructor Create(Keitley:TKeitley;
                      Buttons:Array of TButton;
                      Panels:Array of TPanel;
                      STextsBrightness:TStaticText
                      );
//                      SpeedButtons:Array of TSpeedButton;
//                      
//                      STexts:array of TStaticText;
//                      Labels:array of TLabel;
//                      CheckBoxs:array of TCheckBox;
//                      GroupBox:TGroupBox;
//                      SweetST:array of TStaticText;
//                      SweetLab:array of TLabel;
//                      SweetButtons:Array of TButton;
//                      SweetDualCB,SweetAbortLimitCB:TCheckBox;
//                      SweetMode,SweetSelect:TRadioGroup;
//                      SweepGB:TGroupBox;
//                      DataMeterL,UnitMeterL:TLabel;
//                      MeasureMeterB:TButton;
//                      AutoMMeterB:TSpeedButton);
//
  destructor Destroy;override;
  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
  procedure WriteToIniFile(ConfigFile:TIniFile);override;
//  procedure SettingToObject;
  procedure ObjectToSetting;virtual;
//  procedure OutPutOnFromDevice();
 end;


implementation

uses
  Dialogs, Graphics, SysUtils, Keitley2450Const, TelnetDevice;

{ TKt_2450_Show }

procedure TKeitley_Show.ButtonsTune(Buttons: array of TButton);
begin
  Buttons[0].Caption := 'Connection Test ?';
  Buttons[0].OnClick := TestButtonClick;
//  BTest := Buttons[0];

  Buttons[1].Caption := 'Reset';
  Buttons[1].OnClick := ResetButtonClick;

  Buttons[2].Caption := 'Get from device';
  Buttons[2].OnClick := GetSettingButtonClick;

  Buttons[High(Buttons)].Caption := 'MyTrain';
  Buttons[High(Buttons)].OnClick := MyTrainButtonClick;
end;

constructor TKeitley_Show.Create(Keitley: TKeitley;
                      Buttons: array of TButton;
                      Panels:Array of TPanel;
                      STextsBrightness:TStaticText);
begin
//  if (High(Buttons)<>ButtonNumberKeitley)
//     or(High(SpeedButtons)<>SpeedButtonNumberKt2450)
//     or(High(Panels)<>PanelNumberKt2450)
//     or(High(STexts)<>((ord(High(TKt2450_Settings))+1+ord(High(TKt2450_SourceSettings))+1
//                        +ord(High(TKt2450_MeasureSettings))+1)))
//     or(High(Labels)<>(ord(High(TKt2450_Settings))+1
//                       +ord(kt_ss_limit)-ord(kt_ss_outputoff)+2
//                       +ord(kt_ms_rescomp)-ord(kt_ms_rescomp)+1+1+1))
//     or(High(CheckBoxs)<>CheckBoxNumberKt2450)
//     or(High(SweetST)<>ord(High(TKt2450_SweepSettings)))
//     or(High(SweetLab)<>ord(High(TKt2450_SweepSettings)))
//     or(High(SweetButtons)<>ord(High(TKt2450_SweepButtons)))
//   then
//    begin
//      showmessage('Keitley_Show is not created!');
//      Exit;
//    end;
  fKeitley:=Keitley;
  ButtonsTune(Buttons);

//  SpeedButtonsTune(SpeedButtons);
//
//  CBnumber:=0;
//
//  SettingsShowSLCreate();
//  SettingsShowCreate(STexts,Labels);
  fBrightnessShow:=TKeitley_BrightnessShow.Create(STextsBrightness,fKeitley);
//
//  fSourceShowState:=2;
//  for i:=0 to ord(High(TKt2450_SourceSettings)) do
//     SourceShowStaticText[TKt2450_SourceSettings(i)]:=STexts[ord(High(TKt2450_Settings))+2+i];
//  for i:=0 to ord(kt_ss_limit) do
//     SourceShowLabels[TKt2450_SourceSettings(i)]:=Labels[ord(High(TKt2450_Settings))+2+i];
//  SourceValueShowLabel:=Labels[ord(High(TKt2450_Settings))+2+ord(kt_ss_limit)+1];
//  SourceReadBackCB:=CheckBoxs[CBnumber];
//  inc(CBnumber);
//  fSourceDelayCB:=CheckBoxs[CBnumber];
//  inc(CBnumber);
//  fSourceHCapac:=CheckBoxs[CBnumber];
//  inc(CBnumber);
//
//  SourceShowCreate();
//
//  fMeasurementShowState:=5;
//  for i:=0 to ord(High(TKt2450_MeasureSettings)) do
//     fMeasurementShowStaticText[TKt2450_MeasureSettings(i)]:=STexts[ord(High(TKt2450_Settings))+2
//                                                           +ord(High(TKt2450_SourceSettings))+1+i];
// i:=ord(High(TKt2450_Settings))+2+ord(kt_ss_limit)-ord(kt_ss_outputoff)+2;
// fMeasurementShowLabels[kt_ms_rescomp]:=Labels[i];
// fMeasurementShowLabels[kt_ms_time]:=Labels[i+1];
// fMeasurementShowLabels[kt_ms_lrange]:=Labels[i+2];
//
//  fMeasurementShowGB:=GroupBox;
//  MeasureShowCreate();
//
//  fAutoZeroCB:=CheckBoxs[CBnumber];
//  fAutoZeroCB.OnClick:=AutoZeroClick;
//
//
//  fSweetShowState:=2;
//  SetLength(fSweetST,ord(High(TKt2450_SweepSettings))+1);
//  SetLength(fSweetLab,ord(High(TKt2450_SweepSettings))+1);
//  for I := 0 to ord(High(TKt2450_SweepSettings)) do
//   begin
//    fSweetST[i]:=SweetST[i];
//    fSweetLab[i]:=SweetLab[i];
//   end;
//  for I := 0 to ord(High(TKt2450_SweepButtons)) do
//    fSweetButtons[TKt2450_SweepButtons(i)]:=SweetButtons[i];
//  fSweetDualCB:=SweetDualCB;
//  fSweetAbortLimitCB:=SweetAbortLimitCB;
//  fSweetMode:=SweetMode;
//  fSweetSelect:=SweetSelect;
//  fSweepGB:=SweepGB;
//  SweetShowCreate();
//
//  fMeterShow:=TKt_2450_MeterShow.Create(fKt_2450.Meter,Self,
//                                 DataMeterL,UnitMeterL,
//                                MeasureMeterB,AutoMMeterB);
//  fMeterShow.DigitNumber:=6;
//
  fSetupMemoryShow:=TKeitley_SetupMemoryShow.Create(Self,Panels[0],Panels[1]);

//  ObjectToSetting();

end;

destructor TKeitley_Show.Destroy;
begin
  FreeAndNil(fSetupMemoryShow);
  FreeAndNil(fBrightnessShow);
  inherited;
end;

procedure TKeitley_Show.GetSettingButtonClick(Sender: TObject);
begin
  if not(DeviceEthernetisAbsent) then
    begin
    fKeitley.GetTerminal();
//    fKt_2450.IsOutPutOn();
//    fKt_2450.GetVoltageProtection;
//    fKt_2450.GetDeviceMode;
//    fKt_2450.IsResistanceCompencateOn();
//    fKt_2450.GetVoltageLimit();
//    fKt_2450.GetCurrentLimit();
//    fKt_2450.IsReadBackOn();
//    fKt_2450.GetSenses();
//    fKt_2450.GetOutputOffStates;
//    fKt_2450.GetSourceRanges();
//    fKt_2450.GetMeasureRanges();
//    fKt_2450.GetMeasureLowRanges();
//    fKt_2450.IsAzeroStateOn();
//    fKt_2450.IsSourceDelayAutoOn();
//    fKt_2450.GetSourceDelay();
//    fKt_2450.GetSourceValue();
//    fKt_2450.GetMeasureTime();
//    fKt_2450.IsHighCapacitanceOn();
//    fKt_2450.GetDisplayDigitsNumber();
//    fKeitley.GetCount();
    fKeitley.GetDisplayBrightness();
    end;

  ObjectToSetting();
end;

procedure TKeitley_Show.MyTrainButtonClick(Sender: TObject);
begin
 fKeitley.MyTraining();
end;

procedure TKeitley_Show.ObjectToSetting;
begin
 fBrightnessShow.ObjectToSetting;
end;

procedure TKeitley_Show.ReadFromIniFile(ConfigFile: TIniFile);
begin
 fSetupMemoryShow.ReadFromIniFile(ConfigFile);
end;

procedure TKeitley_Show.ResetButtonClick(Sender: TObject);
begin
 fKeitley.ResetSetting();
end;

procedure TKeitley_Show.TestButtonClick(Sender: TObject);
begin
   if fKeitley.Test
     then (Sender as TButton).Caption:='Connection Test - Ok'
     else (Sender as TButton).Caption:='Connection Test - Failed';
//
//   if fKeitley.Test then
//        begin
//          BTest.Caption:='Connection Test - Ok';
//          BTest.Font.Color:=clBlue;
//        end        else
//        begin
//          BTest.Caption:='Connection Test - Failed';
//          BTest.Font.Color:=clRed;
//        end;
end;

procedure TKeitley_Show.WriteToIniFile(ConfigFile: TIniFile);
begin
 fSetupMemoryShow.WriteToIniFile(ConfigFile);
end;

{ TKeitley_StringParameterShow }

constructor TKeitley_StringParameterShow.Create(ST: TStaticText;
  Keitley: TKeitley);
begin
  fKeitley:=Keitley;
  SomeAction();
  fSettingsShowSL:=TStringList.Create;
  SettingsShowSLFilling();
  inherited Create(ST,fCaption,fSettingsShowSL);
  HookParameterClick:=OkClick;
end;

destructor TKeitley_StringParameterShow.Destroy;
begin
  FreeAndNil(fSettingsShowSL);
  inherited;
end;

{ TKeitley_BrightnessShow }

procedure TKeitley_BrightnessShow.ObjectToSetting;
begin
 Data:=ord(fKeitley.DisplayState);
end;

procedure TKeitley_BrightnessShow.OkClick;
begin
 fKeitley.SetDisplayBrightness(TKeitley_DisplayState(Data));
end;

procedure TKeitley_BrightnessShow.SettingsShowSLFilling;
 var i:TKeitley_DisplayState;
begin
 for I := Low(TKeitley_DisplayState) to High(TKeitley_DisplayState) do
             fSettingsShowSL.Add(Keitley_DisplayStateLabel[i]);
end;

procedure TKeitley_BrightnessShow.SomeAction;
begin
 fCaption:='Brightness';
end;

{ TKeitley_SetupMemoryPins }

constructor TKeitley_SetupMemoryPins.Create(Name: string);
begin
 inherited Create(Name,['SaveSlot','LoadSlot']);
 PinStrPart:='';
end;

function TKeitley_SetupMemoryPins.GetPinStr(Index: integer): string;
begin
 case Index of
  0:Result:='Save Setup';
  else Result:='Load Setup';
 end;
end;

{ TKeitley_SetupMemoryShow }

procedure TKeitley_SetupMemoryShow.CommandSend;
begin
end;

constructor TKeitley_SetupMemoryShow.Create(Keitley_Show: TKeitley_Show;
  PanelSave, PanelLoad: TPanel);
begin
 fKeitley_Show:=Keitley_Show;
 fMemoryPins:=TKeitley_SetupMemoryPins.Create(fKeitley_Show.fKeitley.Name+'Pins');
 inherited Create(fMemoryPins,[PanelSave, PanelLoad]);
 LabelsFilling();
end;

destructor TKeitley_SetupMemoryShow.Destroy;
begin
  fKeitley_Show:=nil;
  FreeAndNil(fMemoryPins);
  inherited;
end;

procedure TKeitley_SetupMemoryShow.LabelsFilling;
 var i:TKeitley_SetupMemorySlot;
begin
 fPinVariants[0].Clear;
 fPinVariants[1].Clear;
 for I := Low(TKeitley_SetupMemorySlot) to High(TKeitley_SetupMemorySlot) do
   begin
     fPinVariants[0].Add(inttostr(I));
     fPinVariants[1].Add(inttostr(I));
   end;
end;

procedure TKeitley_SetupMemoryShow.NumberPinShow(PinActiveNumber,
  ChooseNumber: integer);
begin
 inherited;
 case PinActiveNumber of
  0:fKeitley_Show.fKeitley.SaveSetup(TKeitley_SetupMemorySlot(ChooseNumber));
  1:fKeitley_Show.fKeitley.LoadSetup(TKeitley_SetupMemorySlot(ChooseNumber));
 end;
end;

{ TKeitley_MeasurementType }

procedure TKeitley_MeasurementType.ObjectToSetting;
begin
 Data:=ord(fKeitley.MeasureFunction);
end;

procedure TKeitley_MeasurementType.OkClick;
begin
  fKeitley.SetMeasureFunction(TKeitley_Measure(Data));
end;

procedure TKeitley_MeasurementType.SettingsShowSLFilling;
 var i:TKeitley_Measure;
begin
 for I := Low(TKeitley_Measure) to High(TKeitley_Measure) do
             fSettingsShowSL.Add(Keitley_MeasureLabel[i]);
end;

procedure TKeitley_MeasurementType.SomeAction;
begin
 fCaption:='MeasureType';
end;

end.
