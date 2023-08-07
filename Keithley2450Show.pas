unit Keithley2450Show;

interface

uses
  OlegTypePart2, Keithley2450, StdCtrls, Buttons,
  ArduinoDeviceNew, ExtCtrls, IniFiles, OlegShowTypes, Classes, 
  Keitley2450Const, OlegType, Measurement, KeitleyShow, Keithley;

const
  ButtonNumberKt2450 = 5;
  SpeedButtonNumberKt2450 = 1;
  PanelNumberKt2450 = 1;
  CheckBoxNumberKt2450 = 3;

type

 TKt_2450_Show=class;

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

//TKeitley_StringParameterShow=class(TStringParameterShow)
// private
//  fSettingsShowSL:TStringList;
//  fKt_2450:TKt_2450;
//  fCaption:string;
//  procedure OkClick();virtual;abstract;
//  procedure SettingsShowSLFilling();virtual;abstract;
//  procedure SomeAction();virtual;abstract;
// public
//  Constructor Create(ST:TStaticText;Kt_2450:TKt_2450);
//  destructor Destroy;override;
//  procedure ObjectToSetting;virtual;abstract;
//end;

//TKeitley_BrightnessShow=class(TKeitley_StringParameterShow)
// protected
//  procedure OkClick();override;
//  procedure SettingsShowSLFilling();override;
//  procedure SomeAction();override;
// public
//  procedure ObjectToSetting;override;
//end;

//TKt_RangeShow=class(TStringParameterShow)
TKt_RangeShow=class(TKeitley_StringParameterShow)
 private
//  fSettingsShowSL:TStringList;
  fType:TKt2450_Source;
  fKt_2450:TKt_2450;
//  procedure RangeOkClick();virtual;abstract;

  procedure TypeDetermination();virtual;abstract;
  procedure SetEnabled(Value:boolean);virtual;
  function GetEnable():boolean;
 protected
  procedure SettingsShowSLFilling();override;
  procedure SomeAction();override;
 public
  property Enabled:boolean read GetEnable write SetEnabled;
  Constructor Create(ST:TStaticText;Kt_2450:TKt_2450);
//  destructor Destroy;override;
//  procedure ObjectToSetting;virtual;abstract;
end;

TKt_RangeMeasureShow=class(TKt_RangeShow)
 private
  fHookHookParameterClick: TSimpleEvent;
//  procedure RangeOkClick();override;

  procedure TypeDetermination();override;
 protected
  procedure OkClick();override;
 public
  property HookHookParameterClick:TSimpleEvent read fHookHookParameterClick write fHookHookParameterClick;
  Constructor Create(ST:TStaticText;Kt_2450:TKt_2450);
  procedure ObjectToSetting;override;
end;

TKt_RangeSourceShow=class(TKt_RangeShow)
 private
//  procedure RangeOkClick();override;
//  procedure OkClick();override;
  procedure TypeDetermination();override;
 protected
  procedure OkClick();override;
 public
  procedure ObjectToSetting;override;
end;


TKt_RangeLimitedShow=class(TKt_RangeMeasureShow)
 private
  fLabel:TLabel;
//  procedure SettingsShowSLFilling();override;
  procedure SetEnabled(Value:boolean);override;
//  procedure RangeOkClick();override;
//  procedure OkClick();override;
 protected
  procedure OkClick();override;
  procedure SettingsShowSLFilling();override;
 public
  Constructor Create(ST:TStaticText;Kt_2450:TKt_2450;Lab:TLabel);
  procedure ObjectToSetting;override;
end;



TKt_2450_SourceShow=class(TKt_2450_AbstractElementShow)
 private
  fSettingsShow:array[kt_ss_outputoff..kt_ss_limit]of TParameterShowNew;
  fSettingsShowSL:array[kt_ss_outputoff..kt_ss_outputoff]of TStringList;
  fLimitLabelNames:array[TKt2450_Source]of string;
  fCBReadBack: TCheckBox;
  fCBDelay:TCheckBox;
  fCBHighCapacitance:TCheckBox;
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
  procedure ValueClick();
  procedure ReadBackClick(Sender:TObject);
  function GetSourceValueShow:TDoubleParameterShow;
 public
  property SourceValueShow:TDoubleParameterShow read GetSourceValueShow;
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
  fKt_2450_Show:TKt_2450_Show;
  fSettingsShow:array[kt_ms_rescomp..kt_ms_sense]of TStringParameterShow;
  fSettingsShowSL:array[kt_ms_rescomp..kt_ms_sense]of TStringList;

  fRangeShow:TKt_RangeMeasureShow;
  fRangeLimitedShow:TKt_RangeLimitedShow;
  fTimeShow:TDoubleParameterShow;

  procedure SettingsShowSLCreate();override;
  procedure SettingsShowFree();override;
  procedure SettingsShowCreate(STexts:array of TStaticText;
                          Labels:array of TLabel);override;
  procedure ResCompOkClick();
  procedure SenseOkClick();
  procedure DisplayDNOkClick();
  procedure TimeOkClick();
 public
  property RangeShow:TKt_RangeMeasureShow read fRangeShow;
  Constructor Create(Kt_2450:TKt_2450;
                     Kt_2450_Show:TKt_2450_Show;
                      STexts:array of TStaticText;
                      Labels:array of TLabel;
                      GroupBox:TGroupBox;
                      ShowType:TKt2450_MeasureShowType
                      );
  destructor Destroy;override;
  procedure ObjectToSetting;override;
  procedure ChangeRange();
end;

TKt_2450_SweetShow=class(TKt_2450_AbstractElementShow)
 private
  fKt_2450_SweepParameters:TKt_2450_SweepParameters;
  fSettingsShow:array[TKt2450_SweepSettings]of TParameterShowNew;
  fRangeTypeSettingsShow:TStringList;
  fDualCB:TCheckBox;
  fAbortLimitCB:TCheckBox;
  fMode:TRadioGroup;
  fSelect:TRadioGroup;
//  CF:TIniFile;
  fStepPointST:TStaticText;
  fStepPointLab:TLabel;
  fSweepGB:TGroupBox;

  procedure SettingsShowSLCreate();override;
  procedure SettingsShowFree();override;
  procedure SettingsShowCreate(STexts:array of TStaticText;
                          Labels:array of TLabel);override;
  procedure ButtonCreateClick(Sender:TObject);
  procedure ButtonInitClick(Sender:TObject);
  procedure ButtonStopClick(Sender:TObject);
  procedure ButtonPauseClick(Sender:TObject);
  procedure ButtonResumeClick(Sender:TObject);
  procedure ModeClick(Sender:TObject);
  procedure SelectClick(Sender:TObject);
  procedure CheckBoxClick(Sender:TObject);
  procedure CreateStepPointShow;
  procedure UpDateObject();
  procedure SettingTunning(i: TKt2450_SweepSettings);
  procedure ButtonsTunning(Buttons:TKt2450_SweepButtonArray);
  procedure CheckBoxTunning(DualCB,AbortLimitCB:TCheckBox);
 public
  Constructor Create(Kt_2450:TKt_2450;
                      STexts:array of TStaticText;
                      Labels:array of TLabel;
                      Buttons:TKt2450_SweepButtonArray;
                      DualCB,AbortLimitCB:TCheckBox;
                      Mode,Select:TRadioGroup;
                      SweepGB:TGroupBox
                      );
  destructor Destroy;override;
  procedure ObjectToSetting;override;
  procedure ReadFromIniFile(ConfigFile: TIniFile);override;
  procedure WriteToIniFile(ConfigFile: TIniFile);override;
end;

//TKt_2450_MeterShow=class(TMeasurementShowSimple)
TKt_2450_MeterShow=class(TKeitley_MeterShow)
  private
   fKt_2450_Show:TKt_2450_Show;
//   fKT2450_Meter:TKT2450_Meter;
//   fKT2450_Meter:TKeitley_Meter;
  protected
//   function UnitModeLabel():string;override;
   procedure MeasurementButtonClick(Sender: TObject);override;
  public
   Constructor Create(KT2450_Meter:TKeitley_Meter;
                      Kt_2450_Show:TKt_2450_Show;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton
                      );
end;


// TKt_2450_Show=class(TSimpleFreeAndAiniObject)
 TKt_2450_Show=class(TKeitley_Show)
  private
   fKt_2450:TKt_2450;

//   fSettingsShow:array[TKt2450_Settings]of TStringParameterShow;
//   fSettingsShowSL:array[TKt2450_Settings]of TStringList;
   fSettingsShow:array of TParameterShowNew;
   fSettingsShowSL:array of TStringList;
//   BTest:TButton;
   fOutPutOnOff:TSpeedButton;
   fTerminalsFrRe:TSpeedButton;
//   fSetupMemoryShow:TKeitley_SetupMemoryShow;

   fSourceShow:TKt_2450_SourceShow;
   SourceShowStaticText:array[TKt2450_SourceSettings]of TStaticText;
   SourceShowLabels:array[TKt2450_SourceSettings]of TLabel;
   SourceValueShowLabel:TLabel;
   SourceReadBackCB: TCheckBox;
   fSourceDelayCB: TCheckBox;
   fSourceHCapac: TCheckBox;
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

   fSweetShow:TKt_2450_SweetShow;
   fSweetST:array of TStaticText;
   fSweetLab:array of TLabel;
   fSweetButtons:TKt2450_SweepButtonArray;
   fSweetDualCB,fSweetAbortLimitCB:TCheckBox;
   fSweetMode:TRadioGroup;
   fSweetSelect:TRadioGroup;
   fSweepGB:TGroupBox;
   fSweetShowState:0..2;
   {2 - не створювався, 0 - створено під kt_sVolt; 1 - kt_sCurr}

   fMeterShow:TKt_2450_MeterShow;

   fSourceMeterValueLab:TLabel;

//   fBrightnessShow:TKeitley_BrightnessShow;

   procedure SourceShowCreate();
   procedure SourceShowFree();

   procedure MeasureShowCreate();
   procedure MeasureShowFree();

   procedure SweetShowCreate();
//   procedure SweetShowFree();

//   procedure TestButtonClick(Sender:TObject);
//   procedure ResetButtonClick(Sender:TObject);override;
//   procedure GetSettingButtonClick(Sender:TObject);
   procedure RefreshZeroClick(Sender:TObject);
   procedure SourceMeasureClick(Sender:TObject);
//   procedure MyTrainButtonClick(Sender:TObject);
   procedure AutoZeroClick(Sender:TObject);
//   procedure ButtonsTune(Buttons: array of TButton);override;
   procedure SpeedButtonsTune(SpeedButtons: array of TSpeedButton);
   procedure SettingsShowSLCreate();
//   procedure SettingsShowSLFree();
   procedure SettingsShowCreate(STexts:array of TStaticText;
                          Labels:array of TLabel);
   procedure SettingsShowFree;
   procedure OutPutOnOffSpeedButtonClick(Sender: TObject);

   procedure TerminalsFrReSpeedButtonClick(Sender: TObject);
   procedure TerminalsFromDevice();
   procedure AZeroFromDevice();
   procedure VoltageProtectionOkClick();
   procedure ModeOkClick();
   procedure CountOkClick();
   procedure ReCreateElements;
  protected
   procedure ButtonsTune(Buttons: array of TButton);override;
   procedure ResetButtonClick(Sender:TObject);override;
   procedure GetSettingButtonClick(Sender:TObject);override;
  public
   property MeterShow:TKt_2450_MeterShow read fMeterShow;
   Constructor Create(Kt_2450:TKt_2450;
                      Buttons:Array of TButton;
                      SpeedButtons:Array of TSpeedButton;
                      Panels:Array of TPanel;
                      STexts:array of TStaticText;
                      Labels:array of TLabel;
                      CheckBoxs:array of TCheckBox;
                      GroupBox:TGroupBox;
                      SweetST:array of TStaticText;
                      SweetLab:array of TLabel;
                      SweetButtons:Array of TButton;
                      SweetDualCB,SweetAbortLimitCB:TCheckBox;
                      SweetMode,SweetSelect:TRadioGroup;
                      SweepGB:TGroupBox;
                      DataMeterL,UnitMeterL:TLabel;
                      MeasureMeterB:TButton;
                      AutoMMeterB:TSpeedButton);

  destructor Destroy;override;
  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
  procedure WriteToIniFile(ConfigFile:TIniFile);override;
  procedure SettingToObject;
  procedure ObjectToSetting; override;
  procedure OutPutOnFromDevice();
 end;



var
  Kt_2450_Show:TKt_2450_Show;

implementation

uses
  Dialogs, Graphics, SysUtils, TelnetDevice, OlegFunction, Forms, SCPI, 
  IVchar_main;

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
    AccurateCheckBoxCheckedChange(fAutoZeroCB,fKt_2450.AzeroState[fKt_2450.MeasureFunction]);
//    fAutoZeroCB.OnClick:=nil;
//    fAutoZeroCB.Checked:=not(fAutoZeroCB.Checked);
//    fAutoZeroCB.OnClick:=AutoZeroClick;
    fZeroManualB.Enabled:=not(fAutoZeroCB.Checked);
  end;
end;

procedure TKt_2450_Show.ButtonsTune(Buttons: array of TButton);
//const
//  ButtonCaption: array[0..ButtonNumberKt2450] of string =
//  ('Connection Test ?','Reset','Get from device','Refresh Zero','to measure',
//  'MyTrain');
//var
//  ButtonAction: array[0..ButtonNumberKt2450] of TNotifyEvent;
//  i: Integer;
begin
  inherited;

  Buttons[3].Caption := 'Refresh Zero';
  Buttons[3].OnClick := RefreshZeroClick;
  fZeroManualB:= Buttons[3];

  Buttons[4].Caption := 'to measure';
  Buttons[4].OnClick := SourceMeasureClick;


//  ButtonAction[0] := TestButtonClick;
//  ButtonAction[1] := ResetButtonClick;
//  ButtonAction[2] := GetSettingButtonClick;
//  ButtonAction[3] := RefreshZeroClick;
//  ButtonAction[4] := SourceMeasureClick;
//
//  ButtonAction[ButtonNumberKt2450] := MyTrainButtonClick;
//  for I := 0 to ButtonNumberKt2450 do
//  begin
//    Buttons[i].Caption := ButtonCaption[i];
//    Buttons[i].OnClick := ButtonAction[i];
//  end;
//  BTest := Buttons[0];
//  fZeroManualB:= Buttons[3];
end;

procedure TKt_2450_Show.CountOkClick;
begin
 fKt_2450.SetCount((fSettingsShow[ord(kt_meascount)] as TIntegerParameterShow).Data);
end;

constructor TKt_2450_Show.Create(Kt_2450: TKt_2450;
                                Buttons:Array of TButton;
                                SpeedButtons:Array of TSpeedButton;
                                Panels:Array of TPanel;
                                STexts:array of TStaticText;
                                Labels:array of TLabel;
                                CheckBoxs:array of TCheckBox;
                                GroupBox:TGroupBox;
                                SweetST:array of TStaticText;
                                SweetLab:array of TLabel;
                                SweetButtons:Array of TButton;
                                SweetDualCB,SweetAbortLimitCB:TCheckBox;
                                SweetMode,SweetSelect:TRadioGroup;
                                SweepGB:TGroupBox;
                                DataMeterL,UnitMeterL:TLabel;
                                MeasureMeterB:TButton;
                                AutoMMeterB:TSpeedButton);
 var i,CBnumber:integer;

begin
  if (High(Buttons)<>ButtonNumberKt2450)
     or(High(SpeedButtons)<>SpeedButtonNumberKt2450)
     or(High(Panels)<>PanelNumberKt2450)
     or(High(STexts)<>((ord(High(TKt2450_Settings))+1+ord(High(TKt2450_SourceSettings))+1
                        +ord(High(TKt2450_MeasureSettings))+1)))
     or(High(Labels)<>(ord(High(TKt2450_Settings))+1
                       +ord(kt_ss_limit)-ord(kt_ss_outputoff)+2
                       +ord(kt_ms_rescomp)-ord(kt_ms_rescomp)+1+1+1))
     or(High(CheckBoxs)<>CheckBoxNumberKt2450)
     or(High(SweetST)<>ord(High(TKt2450_SweepSettings)))
     or(High(SweetLab)<>ord(High(TKt2450_SweepSettings)))
     or(High(SweetButtons)<>ord(High(TKt2450_SweepButtons)))
   then
    begin
      showmessage('Kt_2450_Show is not created!');
      Exit;
    end;

//  inherited Create(Kt_2450,[Buttons[0],Buttons[5]]);
  inherited Create(Kt_2450,Buttons,
                   Panels,
                   STexts[ord(High(TKt2450_Settings))+1]);
  fKt_2450:=Kt_2450;

//  ButtonsTune(Buttons);
  SpeedButtonsTune(SpeedButtons);

  CBnumber:=0;

  SettingsShowSLCreate();
  SettingsShowCreate(STexts,Labels);
//  fBrightnessShow:=TKeitley_BrightnessShow.Create(STexts[ord(High(TKt2450_Settings))+1],fKt_2450);

  fSourceShowState:=2;
  for i:=0 to ord(High(TKt2450_SourceSettings)) do
     SourceShowStaticText[TKt2450_SourceSettings(i)]:=STexts[ord(High(TKt2450_Settings))+2+i];
  for i:=0 to ord(kt_ss_limit) do
     SourceShowLabels[TKt2450_SourceSettings(i)]:=Labels[ord(High(TKt2450_Settings))+2+i];
  SourceValueShowLabel:=Labels[ord(High(TKt2450_Settings))+2+ord(kt_ss_limit)+1];
  SourceReadBackCB:=CheckBoxs[CBnumber];
  inc(CBnumber);
  fSourceDelayCB:=CheckBoxs[CBnumber];
  inc(CBnumber);
  fSourceHCapac:=CheckBoxs[CBnumber];
  inc(CBnumber);

  SourceShowCreate();

  fMeasurementShowState:=5;
  for i:=0 to ord(High(TKt2450_MeasureSettings)) do
     fMeasurementShowStaticText[TKt2450_MeasureSettings(i)]:=STexts[ord(High(TKt2450_Settings))+2
                                                           +ord(High(TKt2450_SourceSettings))+1+i];
 i:=ord(High(TKt2450_Settings))+2+ord(kt_ss_limit)-ord(kt_ss_outputoff)+2;
 fMeasurementShowLabels[kt_ms_rescomp]:=Labels[i];
 fMeasurementShowLabels[kt_ms_time]:=Labels[i+1];
 fMeasurementShowLabels[kt_ms_lrange]:=Labels[i+2];
//   for i:=ord(kt_ms_rescomp) to ord(kt_ms_rescomp) do
//       fMeasurementShowLabels[TKt2450_MeasureSettings(ord(kt_ms_rescomp)+i)]:=
//                            Labels[ord(High(TKt2450_Settings))+1
//                                   +ord(kt_ss_limit)-ord(kt_ss_outputoff)+1+i];

  fMeasurementShowGB:=GroupBox;
  MeasureShowCreate();

  fAutoZeroCB:=CheckBoxs[CBnumber];
//  inc(CBnumber);
  fAutoZeroCB.OnClick:=AutoZeroClick;


  fSweetShowState:=2;
  SetLength(fSweetST,ord(High(TKt2450_SweepSettings))+1);
  SetLength(fSweetLab,ord(High(TKt2450_SweepSettings))+1);
  for I := 0 to ord(High(TKt2450_SweepSettings)) do
   begin
    fSweetST[i]:=SweetST[i];
    fSweetLab[i]:=SweetLab[i];
   end;
  for I := 0 to ord(High(TKt2450_SweepButtons)) do
    fSweetButtons[TKt2450_SweepButtons(i)]:=SweetButtons[i];
  fSweetDualCB:=SweetDualCB;
  fSweetAbortLimitCB:=SweetAbortLimitCB;
  fSweetMode:=SweetMode;
  fSweetSelect:=SweetSelect;
  fSweepGB:=SweepGB;
  SweetShowCreate();

  fMeterShow:=TKt_2450_MeterShow.Create(fKt_2450.Meter,Self,
                                 DataMeterL,UnitMeterL,
                                MeasureMeterB,AutoMMeterB);
  fMeterShow.DigitNumber:=6;

//  fSetupMemoryShow:=TKeitley_SetupMemoryShow.Create(Self,Panels[0],Panels[1]);

  ObjectToSetting();
end;

destructor TKt_2450_Show.Destroy;
begin
//  FreeAndNil(fSetupMemoryShow);
  FreeAndNil(fMeterShow);
  FreeAndNil(fSweetShow);
  MeasureShowFree();
  SourceShowFree();
  SettingsShowFree;
//  FreeAndNil(fBrightnessShow);
  inherited;
end;

procedure TKt_2450_Show.GetSettingButtonClick(Sender: TObject);
begin
  if not(DeviceEthernetisAbsent) then
    begin
//    fKt_2450.GetTerminal();
    fKt_2450.IsOutPutOn();
    fKt_2450.GetVoltageProtection;
    fKt_2450.GetDeviceMode;
    fKt_2450.IsResistanceCompencateOn();
    fKt_2450.GetVoltageLimit();
    fKt_2450.GetCurrentLimit();
    fKt_2450.IsReadBackOn();
    fKt_2450.GetSenses();
    fKt_2450.GetOutputOffStates;
    fKt_2450.GetSourceRanges();
    fKt_2450.GetMeasureRanges();
    fKt_2450.GetMeasureLowRanges();
    fKt_2450.IsAzeroStateOn();
    fKt_2450.IsSourceDelayAutoOn();
    fKt_2450.GetSourceDelay();
    fKt_2450.GetSourceValue();
    fKt_2450.GetMeasureTime();
    fKt_2450.IsHighCapacitanceOn();
    fKt_2450.GetDisplayDigitsNumber();
    fKt_2450.GetCount();
//    fKt_2450.GetDisplayBrightness();
    end;

//  ObjectToSetting();
  inherited;
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

 if fMeasurementShowState=ord(MeasureShowType) then
  begin
  fMeasurementShow.ObjectToSetting();
  Exit;
  end;
 MeasureShowFree();
 fMeasurementShow:=TKt_2450_MeasurementShow.Create(fKt_2450,
                  Self,
                 [fMeasurementShowStaticText[kt_ms_rescomp],
                  fMeasurementShowStaticText[kt_ms_displaydn],
                  fMeasurementShowStaticText[kt_ms_sense],
                  fMeasurementShowStaticText[kt_ms_range],
                  fMeasurementShowStaticText[kt_ms_time],
                  fMeasurementShowStaticText[kt_ms_lrange]],
                 [fMeasurementShowLabels[kt_ms_rescomp],
                  fMeasurementShowLabels[kt_ms_time],
                  fMeasurementShowLabels[kt_ms_lrange]],
                  fMeasurementShowGB,
                  MeasureShowType
                  );
 fMeasurementShowState:=ord(MeasureShowType);
end;

procedure TKt_2450_Show.MeasureShowFree;
begin
 if fMeasurementShowState<>5 then FreeAndNil(fMeasurementShow);
end;

procedure TKt_2450_Show.ModeOkClick;
begin
 fKt_2450.SetMode(TKt_2450_Mode((fSettingsShow[ord(kt_mode)] as TStringParameterShow).Data));

 ReCreateElements();
end;

//procedure TKt_2450_Show.MyTrainButtonClick(Sender: TObject);
//begin
// fKt_2450.MyTraining();
//end;

procedure TKt_2450_Show.ObjectToSetting;
begin
 inherited;
 TerminalsFromDevice();
 OutPutOnFromDevice();
 (fSettingsShow[ord(kt_voltprot)] as TStringParameterShow).Data:=ord(fKt_2450.VoltageProtection);
 (fSettingsShow[ord(kt_mode)] as TStringParameterShow).Data:=ord(fKt_2450.Mode);
 (fSettingsShow[ord(kt_meascount)] as TIntegerParameterShow).Data:=fKt_2450.Count;

 ReCreateElements();
// fBrightnessShow.ObjectToSetting;

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
  SweetShowCreate();
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
 fSourceShow.GetSourceValueShow.ColorToActive(fOutPutOnOff.Down);
end;

procedure TKt_2450_Show.ReadFromIniFile(ConfigFile: TIniFile);
begin
  inherited;
  fSweetShow.ReadFromIniFile(ConfigFile);
//  fSetupMemoryShow.ReadFromIniFile(ConfigFile);
end;

procedure TKt_2450_Show.ResetButtonClick(Sender: TObject);
begin
// fKt_2450.ResetSetting();
 inherited;
 if fKt_2450.OutPutOn then
   begin
     fKt_2450.OutPutOn:=False;
     OutPutOnFromDevice;
   end;
end;

procedure TKt_2450_Show.SettingsShowCreate(STexts: array of TStaticText;
                                           Labels:array of TLabel);
 const
      SettingsCaption:array[TKt2450_Settings]of string=
      ('Overvoltage Protection','Device Mode','Measure Count');
// var i:TKt2450_Settings;
 var i:integer;
begin
 SetLength(fSettingsShow,ord(High(TKt2450_Settings))+1);

// for I := Low(TKt2450_Settings) to High(TKt2450_Settings) do
//   begin
//   fSettingsShow[i]:=TStringParameterShow.Create(STexts[ord(i)],
//                        Labels[ord(i)], SettingsCaption[i], fSettingsShowSL[i]);
////   fSettingsShow[i].ForUseInShowObject(fKt_2450,False,False);
//   end;

// fSettingsShow[ord(kt_voltprot)]:=

 for I := 0 to ord(kt_mode) do
   begin
   fSettingsShow[i]:=TStringParameterShow.Create(STexts[i],
                        Labels[i], SettingsCaption[TKt2450_Settings(i)],
                        fSettingsShowSL[i]);
   end;

  fSettingsShow[ord(kt_voltprot)].HookParameterClick:=VoltageProtectionOkClick;
  fSettingsShow[ord(kt_mode)].HookParameterClick:=ModeOkClick;

  fSettingsShow[ord(kt_meascount)]:=TIntegerParameterShow.Create(STexts[ord(kt_meascount)],
                        Labels[ord(kt_meascount)], SettingsCaption[kt_meascount],1);
  (fSettingsShow[ord(kt_meascount)] as TIntegerParameterShow).Limits.SetLimits(1,300000);
  fSettingsShow[ord(kt_meascount)].HookParameterClick:=CountOkClick;

  fSourceMeterValueLab:=Labels[ord(kt_meascount)+1];
end;

procedure TKt_2450_Show.SettingsShowFree;
// var i:TKt2450_Settings;
 var i:integer;
begin
// for I := Low(TKt2450_Settings) to High(TKt2450_Settings) do
//   FreeAndNil(fSettingsShow[i]);
 for I := Low(fSettingsShow) to High(fSettingsShow) do
   FreeAndNil(fSettingsShow[i]);
 for I := Low(fSettingsShowSL) to High(fSettingsShowSL) do
   FreeAndNil(fSettingsShowSL[i]);

end;

procedure TKt_2450_Show.SettingsShowSLCreate;
 var i:integer;
begin
  SetLength(fSettingsShowSL,ord(kt_mode)-ord(kt_voltprot)+1);

//  for I := 0 to ord(High(TKt2450_Settings)) do
  for I := 0 to High(fSettingsShowSL) do
   begin
//   fSettingsShowSL[TKt2450_Settings(i)]:=TStringList.Create();
//   fSettingsShowSL[TKt2450_Settings(i)].Clear;
   fSettingsShowSL[i]:=TStringList.Create();
   fSettingsShowSL[i].Clear;
   end;

// for I := 0 to ord(High(TKt_2450_VoltageProtection)) do
//  fSettingsShowSL[kt_voltprot].Add(Kt_2450_VoltageProtectionLabel[TKt_2450_VoltageProtection(i)]);
//
// for I := 0 to ord(High(TKt_2450_Mode)) do
//  fSettingsShowSL[kt_mode].Add(KT2450_ModeLabels[TKt_2450_Mode(i)]);

 for I := 0 to ord(High(TKt_2450_VoltageProtection)) do
  fSettingsShowSL[ord(kt_voltprot)].Add(Kt_2450_VoltageProtectionLabel[TKt_2450_VoltageProtection(i)]);

 for I := 0 to ord(High(TKt_2450_Mode)) do
  fSettingsShowSL[ord(kt_mode)].Add(KT2450_ModeLabels[TKt_2450_Mode(i)]);


end;

//procedure TKt_2450_Show.SettingsShowSLFree;
// var i:integer;
//begin
// for I := 0 to ord(High(TKt2450_Settings)) do
//  fSettingsShowSL[TKt2450_Settings(i)].Free;
//end;

procedure TKt_2450_Show.SettingToObject;
begin

end;

procedure TKt_2450_Show.SourceMeasureClick(Sender: TObject);
begin
 fKt_2450.SourceMeter.GetData;
 if fKt_2450.SourceType=kt_sVolt then
  fSourceMeterValueLab.Caption:=FloatToStrF(fKt_2450.SourceMeter.Value,ffFixed, 7, 5)
                                 else
  fSourceMeterValueLab.Caption:=FloatToStrF(fKt_2450.SourceMeter.Value,ffExponent, 6, 2);
OutPutOnFromDevice;
end;

procedure TKt_2450_Show.SourceShowCreate;
begin
 if fSourceShowState=ord(fKt_2450.SourceType) then
  begin
  fSourceShow.ObjectToSetting();
  Exit;
  end;
 SourceShowFree();
 fSourceShow:=TKt_2450_SourceShow.Create(fKt_2450,
                 [SourceShowStaticText[kt_ss_outputoff],
                  SourceShowStaticText[kt_ss_delay],
                  SourceShowStaticText[kt_ss_value],
                  SourceShowStaticText[kt_ss_limit],
                  SourceShowStaticText[kt_ss_range]],
                 [SourceShowLabels[kt_ss_outputoff],
                  SourceShowLabels[kt_ss_delay],
                  SourceShowLabels[kt_ss_value],
                  SourceShowLabels[kt_ss_limit],
                  SourceValueShowLabel],
                  [SourceReadBackCB,fSourceDelayCB,
                  fSourceHCapac]
                  );
  fSourceShowState:=ord(fKt_2450.SourceType);
  fKt_2450.OutPutOn:=False;
  OutPutOnFromDevice;
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

procedure TKt_2450_Show.SweetShowCreate;
begin
 if fSweetShowState=ord(fKt_2450.SourceType) then
  begin
  fSWeetShow.UpDateObject();
  Exit;
  end;
 if fSweetShowState<>2 then
  begin
   fSweetShow.WriteToIniFile(ConfigFile);
   FreeAndNil(fSweetShow);
  end;
 
// SweetShowFree();
 fSweetShow:=TKt_2450_SweetShow.Create(fKt_2450,
                     fSweetST,fSweetLab,fSweetButtons,
                     fSweetDualCB,fSweetAbortLimitCB,
                     fSweetMode,fSweetSelect,fSweepGB);
 if fSweetShowState<>2 then fSweetShow.ReadFromIniFile(ConfigFile);
 fSweetShowState:=ord(fKt_2450.SourceType);
end;

//procedure TKt_2450_Show.SweetShowFree;
//begin
// if fSweetShowState<>2 then FreeAndNil(fSweetShow);
//end;

procedure TKt_2450_Show.TerminalsFromDevice;
begin
  fTerminalsFrRe.OnClick:=nil;
  fTerminalsFrRe.Caption:=Keitlay_TerminalsButtonName[fKt_2450.Terminal];
  fTerminalsFrRe.Down:=(fKt_2450.Terminal=kt_otRear);
  fTerminalsFrRe.OnClick:=TerminalsFrReSpeedButtonClick;
end;

procedure TKt_2450_Show.TerminalsFrReSpeedButtonClick(Sender: TObject);
begin
 if fTerminalsFrRe.Down then
      begin
       fKt_2450.SetTerminal(kt_otRear);
       fTerminalsFrRe.Caption:=Keitlay_TerminalsButtonName[kt_otRear];
      end             else
      begin
       fKt_2450.SetTerminal(kt_otFront);
       fTerminalsFrRe.Caption:=Keitlay_TerminalsButtonName[kt_otFront];
      end;
end;

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


procedure TKt_2450_Show.VoltageProtectionOkClick;
begin
 fKt_2450.SetVoltageProtection(TKt_2450_VoltageProtection
                          ((fSettingsShow[ord(kt_voltprot)] as TStringParameterShow).Data));
end;

procedure TKt_2450_Show.WriteToIniFile(ConfigFile: TIniFile);
begin
 inherited;
 fSweetShow.WriteToIniFile(ConfigFile);
// fSetupMemoryShow.WriteToIniFile(ConfigFile);
end;

{ TKT2450_SetupMemory }

//procedure TKeitley_SetupMemoryShow.CommandSend;
//begin
//
//end;

//constructor TKeitley_SetupMemoryShow.Create(KT2450_Show:TKt_2450_Show;
//                              PanelSave, PanelLoad: TPanel);
//begin
// fKT2450_Show:=KT2450_Show;
// fMemoryPins:=TKeitley_SetupMemoryPins.Create(fKT2450_Show.fKt_2450.Name+'Pins');
// inherited Create(fMemoryPins,[PanelSave, PanelLoad]);
// LabelsFilling();
//end;

{ TKT2450_SetupMemoryPins }

//constructor TKeitley_SetupMemoryPins.Create(Name: string);
//begin
// inherited Create(Name,['SaveSlot','LoadSlot']);
// PinStrPart:='';
//end;

//destructor TKeitley_SetupMemoryShow.Destroy;
//begin
//  fKT2450_Show:=nil;
//  FreeAndNil(fMemoryPins);
//  inherited;
//end;

//procedure TKeitley_SetupMemoryShow.LabelsFilling;
// var i:TKeitley_SetupMemorySlot;
//begin
// fPinVariants[0].Clear;
// fPinVariants[1].Clear;
// for I := Low(TKeitley_SetupMemorySlot) to High(TKeitley_SetupMemorySlot) do
//   begin
//     fPinVariants[0].Add(inttostr(I));
//     fPinVariants[1].Add(inttostr(I));
//   end;
//end;

//procedure TKeitley_SetupMemoryShow.NumberPinShow(PinActiveNumber: integer;ChooseNumber:integer);
//begin
// inherited;
// case PinActiveNumber of
//  0:fKT2450_Show.fKt_2450.SaveSetup(TKeitley_SetupMemorySlot(ChooseNumber));
//  1:fKT2450_Show.fKt_2450.LoadSetup(TKeitley_SetupMemorySlot(ChooseNumber));
// end;
//end;

//function TKeitley_SetupMemoryPins.GetPinStr(Index: integer): string;
//begin
// case Index of
//  0:Result:='Save Setup';
//  else Result:='Load Setup';
// end;
//end;

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
 AccurateCheckBoxCheckedChange(fCBReadBack,True);
 fCBReadBack.OnClick:=ReadBackClick;
 fCBDelay:=CBoxs[1];
 fCBDelay.OnClick:=ReadBackClick;
 fRangeShow:=TKt_RangeSourceShow.Create(STexts[ord(kt_ss_range)],Kt_2450);
 fCBHighCapacitance:=CBoxs[2];
 AccurateCheckBoxCheckedChange(fCBHighCapacitance,False);
 fCBHighCapacitance.OnClick:=ReadBackClick;
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

function TKt_2450_SourceShow.GetSourceValueShow: TDoubleParameterShow;
begin
 result:=(fSettingsShow[kt_ss_value] as TDoubleParameterShow);
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
    ord(fKt_2450.OutputOffState[fKt_2450.SourceType]);

 case fKt_2450.SourceType of
   kt_sVolt: (fSettingsShow[kt_ss_limit] as TDoubleParameterShow).Data:=fKt_2450.CurrentLimit;
   kt_sCurr: (fSettingsShow[kt_ss_limit] as TDoubleParameterShow).Data:=fKt_2450.VoltageLimit;
 end;
 (fSettingsShow[kt_ss_delay] as TDoubleParameterShow).Data:=fKt_2450.SourceDelay[fKt_2450.SourceType];

 if fKt_2450.ReadBack[fKt_2450.SourceType]<>fCBReadBack.Checked then
  AccurateCheckBoxCheckedChange(fCBReadBack,fKt_2450.ReadBack[fKt_2450.SourceType]);

 if fKt_2450.SourceDelayAuto[fKt_2450.SourceType]<>fCBDelay.Checked then
  AccurateCheckBoxCheckedChange(fCBDelay,fKt_2450.SourceDelayAuto[fKt_2450.SourceType]);

 if fKt_2450.HighCapacitance[fKt_2450.SourceType]<>fCBHighCapacitance.Checked then
  AccurateCheckBoxCheckedChange(fCBHighCapacitance,fKt_2450.HighCapacitance[fKt_2450.SourceType]);


 STDelay.Enabled:=not(fCBDelay.Checked);

 fRangeShow.ObjectToSetting;

 (fSettingsShow[kt_ss_value] as TDoubleParameterShow).Data:=fKt_2450.SourceValue[fKt_2450.SourceType];

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
 if (Sender=fCBHighCapacitance) then fKt_2450.SetHighCapacitanceState(fCBHighCapacitance.Checked);

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

 fSettingsShow[kt_ss_value]:=TDoubleParameterShow.Create(STexts[ord(kt_ss_value)],
                                Labels[ord(kt_ss_value)],
                                'Output Value: ',
                                0,4);
 fSettingsShow[kt_ss_value].ForUseInShowObject(fKt_2450);
 fSettingsShow[kt_ss_value].HookParameterClick:=ValueClick;
 Labels[ord(kt_ss_value)].WordWrap:=False;

 Labels[ord(kt_ss_limit)+1].Caption:=
  FloattostrF(Kt_2450_SourceSweepLimits[fKt_2450.SourceType,lvMin],ffFixed, 5, 2)
  +'...'+
  FloattostrF(Kt_2450_SourceSweepLimits[fKt_2450.SourceType,lvMax],ffFixed, 5, 2);

 if fKt_2450.SourceType=kt_sVolt then
    Labels[ord(kt_ss_limit)+1].Caption:=Labels[ord(kt_ss_limit)+1].Caption+' V'
                                  else
    Labels[ord(kt_ss_limit)+1].Caption:=Labels[ord(kt_ss_limit)+1].Caption+' A';

// if fKt_2450.SourceType=kt_sVolt then
//    Labels[ord(kt_ss_value)].Caption:=Labels[ord(kt_ss_value)].Caption+'V'
//                                  else
//    Labels[ord(kt_ss_value)].Caption:=Labels[ord(kt_ss_value)].Caption+'A';

 (fSettingsShow[kt_ss_value] as TDoubleParameterShow).Limits.SetLimits(
                        Kt_2450_SourceSweepLimits[fKt_2450.SourceType,lvMin],
                        Kt_2450_SourceSweepLimits[fKt_2450.SourceType,lvMax]);


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

procedure TKt_2450_SourceShow.ValueClick;
begin
 fKt_2450.SetSourceValue((fSettingsShow[kt_ss_value] as TDoubleParameterShow).Data);
 (fSettingsShow[kt_ss_value] as TDoubleParameterShow).Data:=fKt_2450.SourceValue[fKt_2450.SourceType];
 fSettingsShow[kt_ss_value].ColorToActive(fKt_2450.OutPutOn);
end;

{ TKt_2450_MeasurementShow }

procedure TKt_2450_MeasurementShow.ChangeRange;
begin
 fRangeLimitedShow.Enabled:=fRangeShow.Enabled and (fRangeShow.Data=0);
end;

constructor TKt_2450_MeasurementShow.Create(Kt_2450: TKt_2450;Kt_2450_Show:TKt_2450_Show;
  STexts: array of TStaticText; Labels: array of TLabel; GroupBox: TGroupBox;
  ShowType:TKt2450_MeasureShowType);
begin
 fKt_2450_Show:=Kt_2450_Show;
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

procedure TKt_2450_MeasurementShow.DisplayDNOkClick;
begin
 fKt_2450.SetDisplayDigitsNumber(3+fSettingsShow[kt_ms_displaydn].Data);
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
//    kt_md_sImC:fSettingsShow[kt_ms_sense].Data:=ord(fKt_2450.Sences[kt_mCurrent]);
    kt_md_sImC:fSettingsShow[kt_ms_sense].Data:=ord(fKt_2450.Sences[kt_mCurDC]);
    kt_md_sVmV,
    kt_md_sImV,
    kt_md_sImR,
//    kt_md_sImP:fSettingsShow[kt_ms_sense].Data:=ord(fKt_2450.Sences[kt_mVoltage]);
    kt_md_sImP:fSettingsShow[kt_ms_sense].Data:=ord(fKt_2450.Sences[kt_mVolDC]);
  end;

  fRangeShow.ObjectToSetting;
  fRangeLimitedShow.ObjectToSetting;
  fTimeShow.Data:=fKt_2450.MeasureTime[fKt_2450.MeasureFunction];
  fSettingsShow[kt_ms_displaydn].Data:=fKt_2450.DisplayDN[fKt_2450.MeasureFunction]-3;

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
//    kt_md_sImC:fKt_2450.SetSense(kt_mCurrent,TKt2450_Sense(fSettingsShow[kt_ms_sense].Data));
    kt_md_sImC:fKt_2450.SetSense(kt_mCurDC,TKt2450_Sense(fSettingsShow[kt_ms_sense].Data));
    kt_md_sVmV,
    kt_md_sImV,
    kt_md_sImR,
//    kt_md_sImP:fKt_2450.SetSense(kt_mVoltage,TKt2450_Sense(fSettingsShow[kt_ms_sense].Data));
    kt_md_sImP:fKt_2450.SetSense(kt_mVolDC,TKt2450_Sense(fSettingsShow[kt_ms_sense].Data));
  end;
 if fKt_2450.OutPutOn then
   begin
     fKt_2450.OutPutOn:=False;
     fKt_2450_Show.OutPutOnFromDevice;
   end;
end;

procedure TKt_2450_MeasurementShow.SettingsShowCreate(
     STexts: array of TStaticText; Labels: array of TLabel);
 const
     SettingsCaption:array[kt_ms_rescomp..kt_ms_sense]of string=
      ('ResistComp','DisplayDN','Sense');
 var i:TKt2450_MeasureSettings;
begin
 for I := Low(TKt2450_MeasureSettings) to kt_ms_rescomp do
   fSettingsShow[i]:=TStringParameterShow.Create(STexts[ord(i)],
                        Labels[ord(i)], SettingsCaption[i], fSettingsShowSL[i]);
 fSettingsShow[kt_ms_rescomp].HookParameterClick:=ResCompOkClick;

 for I := kt_ms_displaydn to kt_ms_sense do
   fSettingsShow[i]:=TStringParameterShow.Create(STexts[ord(i)],
                        SettingsCaption[i], fSettingsShowSL[i]);
 fSettingsShow[kt_ms_sense].HookParameterClick:=SenseOkClick;
 fSettingsShow[kt_ms_displaydn].HookParameterClick:=DisplayDNOkClick;
 fSettingsShow[kt_ms_displaydn].Data:=2;

 fTimeShow:=TDoubleParameterShow.Create(STexts[ord(kt_ms_time)],
                                        Labels[High(Labels)-1],
                                        'Measure time, ms',
                                        1);
 fTimeShow.Limits.SetLimits(
                        Kt_2450_MeasureTimeLimits[lvMin]*Keitley_MeaureTimeConvertConst,
                        Kt_2450_MeasureTimeLimits[lvMax]*Keitley_MeaureTimeConvertConst);
 fTimeShow.HookParameterClick:=TimeOkClick;

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
 for I := Low(TKeitleyDisplayDigitsNumber) to High(TKeitleyDisplayDigitsNumber) do
    fSettingsShowSL[kt_ms_displaydn].Add(inttostr(i)+KeitleyDisplayDNLabel);
end;

procedure TKt_2450_MeasurementShow.TimeOkClick;
begin
 fKt_2450.SetMeasureTime(fTimeShow.Data);
end;

procedure TKt_2450_MeasurementShow.SettingsShowFree;
 var i:TKt2450_MeasureSettings;
begin
 for I := low(fSettingsShowSL) to High(fSettingsShowSL) do
  FreeAndNil(fSettingsShowSL[i]);
 for i := Low(fSettingsShow) to High(fSettingsShow) do
  FreeAndNil(fSettingsShow[i]);
FreeAndNil(fTimeShow);
end;

{ TKt_RangeShow }

//constructor TKt_RangeShow.Create(ST: TStaticText; {Source: TKt2450_Source;}
//  Kt_2450: TKt_2450);
//begin
//  fKt_2450:=Kt_2450;
//  TypeDetermination();
//  fSettingsShowSL:=TStringList.Create;
//  SettingsShowSLFilling();
//  case fType of
//    kt_sVolt:
//         inherited Create(ST,'Voltage Range',fSettingsShowSL);
//    kt_sCurr:
//         inherited Create(ST,'Current Range',fSettingsShowSL);
//  end;
//  HookParameterClick:=RangeOkClick;
//end;

//destructor TKt_RangeShow.Destroy;
//begin
//  FreeAndNil(fSettingsShowSL);
//  inherited;
//end;

constructor TKt_RangeShow.Create(ST: TStaticText; Kt_2450: TKt_2450);
begin
 fKt_2450:=Kt_2450;
 inherited Create(ST,Kt_2450);
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

procedure TKt_RangeShow.SomeAction;
begin
 TypeDetermination();
  case fType of
    kt_sVolt: fCaption:='Voltage Range';
    kt_sCurr: fCaption:='Current Range';
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

//procedure TKt_RangeMeasureShow.RangeOkClick;
procedure TKt_RangeMeasureShow.OkClick;
begin
 case fType of
  kt_sVolt:fKt_2450.SetMeasureVoltageRange(TKt2450VoltageRange(Data));
  kt_sCurr:fKt_2450.SetMeasureCurrentRange(TKt2450CurrentRange(Data));
 end;
 HookHookParameterClick;
end;

procedure TKt_RangeMeasureShow.TypeDetermination;
begin
// if fKt_2450.MeasureFunction=kt_mCurrent
 if fKt_2450.MeasureFunction=kt_mCurDC
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

//procedure TKt_RangeSourceShow.RangeOkClick;
procedure TKt_RangeSourceShow.OkClick;
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

//procedure TKt_RangeLimitedShow.RangeOkClick;
procedure TKt_RangeLimitedShow.OkClick;
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

{ TKt_2450_SweetShow }

procedure TKt_2450_SweetShow.ButtonCreateClick(Sender: TObject);
begin
 if fSelect.ItemIndex=1 then
 begin
   UpDateObject();
   case fMode.ItemIndex of
     0:fKt_2450.SwepLinearStepCreate;
     1:fKt_2450.SwepLinearPointCreate;
     2:fKt_2450.SwepLogStepCreate;
   end;
 end                    else
  fKt_2450.TrigForIVCreate;
 fKt_2450.SweepWasCreated:=True;
end;

procedure TKt_2450_SweetShow.ButtonInitClick(Sender: TObject);
begin
 fKt_2450.Init;
// fKt_2450.InitWait;
end;

procedure TKt_2450_SweetShow.ButtonPauseClick(Sender: TObject);
begin
  fKt_2450.TrigPause;
end;

procedure TKt_2450_SweetShow.ButtonResumeClick(Sender: TObject);
begin
  fKt_2450.TrigResume;
end;

procedure TKt_2450_SweetShow.ButtonStopClick(Sender: TObject);
begin
 fKt_2450.Abort;
end;

procedure TKt_2450_SweetShow.ButtonsTunning(Buttons: TKt2450_SweepButtonArray);
 var i:TKt2450_SweepButtons;
begin
 for I := low(TKt2450_SweepButtons) to High(TKt2450_SweepButtons) do
   Buttons[i].Caption:=Kt2450_SweepButtonNames[i];
 Buttons[kt_swb_create].OnClick:=ButtonCreateClick;
 Buttons[kt_swb_init].OnClick:=ButtonInitClick;
 Buttons[kt_swb_stop].OnClick:=ButtonStopClick;
 Buttons[kt_swb_pause].OnClick:=ButtonPauseClick;
 Buttons[kt_swb_resume].OnClick:=ButtonResumeClick;
end;

procedure TKt_2450_SweetShow.CheckBoxClick(Sender: TObject);
begin
 if Sender=fDualCB
   then fKt_2450_SweepParameters.Dual:=fDualCB.Checked;
 if Sender=fAbortLimitCB
   then fKt_2450_SweepParameters.FailAbort:=fAbortLimitCB.Checked;


end;

procedure TKt_2450_SweetShow.CheckBoxTunning(DualCB, AbortLimitCB: TCheckBox);
begin
 fDualCB:=DualCB;
 fDualCB.Caption:='Dual';
 fDualCB.OnClick:=CheckBoxClick;
 fDualCB.Checked:=False;
// fDualCB.Name:=fKt_2450.Name;

 fAbortLimitCB:=AbortLimitCB;
 fAbortLimitCB.Caption:='Abort on Limit';
 fAbortLimitCB.OnClick:=CheckBoxClick;
 fAbortLimitCB.Checked:=True;
// fAbortLimitCB.Name:=fKt_2450.Name;
end;

constructor TKt_2450_SweetShow.Create(Kt_2450: TKt_2450;
                                 STexts: array of TStaticText;
                                 Labels: array of TLabel;
                                 Buttons: TKt2450_SweepButtonArray;
                                 DualCB, AbortLimitCB: TCheckBox;
                                 Mode,Select: TRadioGroup;
                                 SweepGB:TGroupBox);
begin
 fKt_2450_SweepParameters:=Kt_2450.SweepParameters[Kt_2450.SourceType];
 fMode:=Mode;
 fMode.Items.Clear;
 fMode.Items.Add('Linear Step');
 fMode.Items.Add('Linear Point');
 fMode.Items.Add('Log Point');
 fMode.OnClick:=nil;
 fMode.ItemIndex:=0;
 fMode.OnClick:=ModeClick;

 fSelect:=Select;
 fSelect.Items.Clear;
 fSelect.Items.Add('From Setting');
 fSelect.Items.Add('From Sweep');
 fSelect.OnClick:=nil;
 fSelect.ItemIndex:=0;
 fSelect.OnClick:=SelectClick;

 fSweepGB:=SweepGB;

// fMode.Name:=Kt_2450.Name;
 inherited Create(Kt_2450,STexts,Labels);
// CF:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'IVChar.ini');

 ButtonsTunning(Buttons);
 CheckBoxTunning(DualCB, AbortLimitCB);

end;


procedure TKt_2450_SweetShow.CreateStepPointShow;
begin
// if (fMode.ItemIndex=0)and(fSettingsShow[kt_sws_stpo] is TIntegerParameterShow) then
//  begin
//    fSettingsShow[kt_sws_stpo].WriteToIniFile(CF);
//    FreeAndNil(fSettingsShow[kt_sws_stpo]);
//    fSettingsShow[kt_sws_stpo]:=TDoubleParameterShow.Create(
//                                    fStepPointST,fStepPointLab,'SW_Step',
//                                    0.05,5);
//   (fSettingsShow[kt_sws_stpo] as TDoubleParameterShow).Limits.SetLimits(1e-6);
//   SettingTunning(kt_sws_stpo);
//   fSettingsShow[kt_sws_stpo].ReadFromIniFile(CF);
//  end;
// if (fMode.ItemIndex<>0)and(fSettingsShow[kt_sws_stpo] is TDoubleParameterShow) then
//  begin
//    fSettingsShow[kt_sws_stpo].WriteToIniFile(CF);
//    FreeAndNil(fSettingsShow[kt_sws_stpo]);
//     fSettingsShow[kt_sws_stpo]:=TIntegerParameterShow.Create(
//                                fStepPointST,fStepPointLab,'SW_Points',2);
//   (fSettingsShow[kt_sws_stpo] as TIntegerParameterShow).Limits.SetLimits(
//                        Kt_2450_SweepCountLimits[lvMin],
//                        Kt_2450_SweepCountLimits[lvMax]);
//    SettingTunning(kt_sws_stpo);
//    fSettingsShow[kt_sws_stpo].ReadFromIniFile(CF);
//  end;

 if ((fMode.ItemIndex=0)and(fSettingsShow[kt_sws_stpo] is TIntegerParameterShow))
    or((fMode.ItemIndex<>0)and(fSettingsShow[kt_sws_stpo] is TDoubleParameterShow))
 then
  begin
    fSettingsShow[kt_sws_stpo].WriteToIniFile(ConfigFile);
    FreeAndNil(fSettingsShow[kt_sws_stpo]);
    case fMode.ItemIndex of
     0:begin
       fSettingsShow[kt_sws_stpo]:=TDoubleParameterShow.Create(
                                    fStepPointST,fStepPointLab,'SW_Step',
                                    0.05,5);
       (fSettingsShow[kt_sws_stpo] as TDoubleParameterShow).Limits.SetLimits(1e-6);
       fStepPointLab.Caption:=Kt2450_SweepLabelNames[kt_sws_stpo];
       if fKt_2450.SourceType=kt_sVolt
             then fStepPointLab.Caption:=fStepPointLab.Caption+'V'
             else fStepPointLab.Caption:=fStepPointLab.Caption+'A'

       end;
     else begin
          fSettingsShow[kt_sws_stpo]:=TIntegerParameterShow.Create(
                                fStepPointST,fStepPointLab,'SW_Points',2);
         (fSettingsShow[kt_sws_stpo] as TIntegerParameterShow).Limits.SetLimits(
                        Kt_2450_SweepCountLimits[lvMin],
                        Kt_2450_SweepCountLimits[lvMax]);
          fStepPointLab.Caption:='Points';
          end;
    end;
    SettingTunning(kt_sws_stpo);
    fStepPointLab.WordWrap:=False;
//    fStepPointLab.Caption:=Kt2450_SweepLabelNames[kt_sws_stpo];
    fSettingsShow[kt_sws_stpo].ReadFromIniFile(ConfigFile);
  end;

end;

//procedure TKt_2450_SweetShow.DelayOkClick;
//begin
// fKt_2450_SweepParameters.Delay:=(fSettingsShow[kt_sws_delay] as TDoubleParameterShow).Data;
//end;

destructor TKt_2450_SweetShow.Destroy;
begin
//  FreeAndNil(CF);
  inherited;
end;

procedure TKt_2450_SweetShow.ModeClick(Sender: TObject);
begin
 CreateStepPointShow();
end;

procedure TKt_2450_SweetShow.ObjectToSetting;
begin

end;

procedure TKt_2450_SweetShow.ReadFromIniFile(ConfigFile: TIniFile);
 var i:TKt2450_SweepSettings;
begin
 for i := Low(fSettingsShow) to High(fSettingsShow) do
   fSettingsShow[i].ReadFromIniFile(ConfigFile);
 fMode.ItemIndex:= ConfigFile.ReadInteger(fKt_2450.Name,
           'SW_Mode'+Kt2450_SourceName[fKt_2450.SourceType],0);
 fSelect.ItemIndex:= ConfigFile.ReadInteger(fKt_2450.Name,
           'SW_Select',0);
 fDualCB.Checked:= ConfigFile.ReadBool(fKt_2450.Name,
           'SW_Dual'+Kt2450_SourceName[fKt_2450.SourceType],False);
 fAbortLimitCB.Checked:= ConfigFile.ReadBool(fKt_2450.Name,
           'SW_FailAbort'+Kt2450_SourceName[fKt_2450.SourceType],True);

 UpDateObject();

end;

procedure TKt_2450_SweetShow.SelectClick(Sender: TObject);
begin
 fSweepGB.Enabled:=(fSelect.ItemIndex=1);
 fSweepGB.Visible:=(fSelect.ItemIndex=1);
end;

procedure TKt_2450_SweetShow.SettingsShowCreate(STexts: array of TStaticText;
  Labels: array of TLabel);

  var i:TKt2450_SweepSettings;
begin


 fSettingsShow[kt_sws_start]:=TDoubleParameterShow.Create(
                                    STexts[0],Labels[0],'SW_Start',
                                    0,4);
(fSettingsShow[kt_sws_start] as TDoubleParameterShow).Limits.SetLimits(
                        Kt_2450_SourceSweepLimits[fKt_2450.SourceType,lvMin],
                        Kt_2450_SourceSweepLimits[fKt_2450.SourceType,lvMax]);


 fSettingsShow[kt_sws_stop]:=TDoubleParameterShow.Create(
                                    STexts[1],Labels[1],'SW_Stop',
                                    0.1,4);
(fSettingsShow[kt_sws_stop] as TDoubleParameterShow).Limits.SetLimits(
                        Kt_2450_SourceSweepLimits[fKt_2450.SourceType,lvMin],
                        Kt_2450_SourceSweepLimits[fKt_2450.SourceType,lvMax]);

 fSettingsShow[kt_sws_delay]:=TDoubleParameterShow.Create(
                                    STexts[2],Labels[2],'SW_Delay',
                                    0,4);
(fSettingsShow[kt_sws_delay] as TDoubleParameterShow).Limits.SetLimits(
            0,Kt_2450_SweepDelayLimits[lvMax]);


 fStepPointST:=STexts[3];
 fStepPointLab:=Labels[3];
 fSettingsShow[kt_sws_stpo]:=TDoubleParameterShow.Create(
                                    fStepPointST,fStepPointLab,'SW_Step',
                                    0.05,5);
(fSettingsShow[kt_sws_stpo] as TDoubleParameterShow).Limits.SetLimits(1e-6);

// CreateStepPointShow();
 fSettingsShow[kt_sws_count]:=TIntegerParameterShow.Create(
                                    STexts[4],Labels[4],'SW_Count',
                                    1);
(fSettingsShow[kt_sws_count] as TIntegerParameterShow).Limits.SetLimits(
                        Kt_2450_SweepCountLimits[lvMin],
                        Kt_2450_SweepCountLimits[lvMax]);

 fSettingsShow[kt_sws_ranget]:=TStringParameterShow.Create(
                                    STexts[5],Labels[5],'SW_RangeT',
                                    fRangeTypeSettingsShow);


 for i := Low(TKt2450_SweepSettings) to High(TKt2450_SweepSettings) do
  begin
   Labels[ord(i)].WordWrap:=False;
   Labels[ord(i)].Caption:=Kt2450_SweepLabelNames[i];
   if i in [kt_sws_start,kt_sws_stop,kt_sws_stpo] then
      if fKt_2450.SourceType=kt_sVolt
          then Labels[ord(i)].Caption:=Labels[ord(i)].Caption+'V'
          else Labels[ord(i)].Caption:=Labels[ord(i)].Caption+'A';
   SettingTunning(i);
  end;


// for i := Low(TKt2450_SweepSettings) to High(TKt2450_SweepSettings) do
//    SettingTunning(i);


end;

procedure TKt_2450_SweetShow.SettingsShowFree;
 var i:TKt2450_SweepSettings;
begin
 FreeAndNil(fRangeTypeSettingsShow);
 for i := Low(fSettingsShow) to High(fSettingsShow) do
  FreeAndNil(fSettingsShow[i]);
end;

procedure TKt_2450_SweetShow.SettingsShowSLCreate;
 var i:TKt2450_SweepRangeType;
begin
  fRangeTypeSettingsShow:=TStringList.Create();
  fRangeTypeSettingsShow.Clear;

 for I := Low(TKt2450_SweepRangeType) to High(TKt2450_SweepRangeType) do
  fRangeTypeSettingsShow.Add(KT2450_SweepRangeLabels[i]);
end;

//procedure TKt_2450_SweetShow.StartOkClick;
//begin
//  fKt_2450_SweepParameters.Start:=(fSettingsShow[kt_sws_start] as TDoubleParameterShow).Data;
//end;

//procedure TKt_2450_SweetShow.StepOkClick;
//begin
// fKt_2450_SweepParameters.Step:=(fSettingsShow[kt_sws_stpo] as TDoubleParameterShow).Data;
//end;

//procedure TKt_2450_SweetShow.StopOkClick;
//begin
//  fKt_2450_SweepParameters.Stop:=(fSettingsShow[kt_sws_stop] as TDoubleParameterShow).Data;
//end;

procedure TKt_2450_SweetShow.UpDateObject;
begin
 fKt_2450_SweepParameters.Stop:=(fSettingsShow[kt_sws_stop] as TDoubleParameterShow).Data;
 fKt_2450_SweepParameters.Start:=(fSettingsShow[kt_sws_start] as TDoubleParameterShow).Data;
 case fMode.ItemIndex of
   0:fKt_2450_SweepParameters.Step:=(fSettingsShow[kt_sws_stpo] as TDoubleParameterShow).Data;
   else fKt_2450_SweepParameters.Points:=(fSettingsShow[kt_sws_stpo] as TIntegerParameterShow).Data;
 end;
// showmessage(inttostr((fSettingsShow[kt_sws_count] as TIntegerParameterShow).Data));
 fKt_2450_SweepParameters.Delay:=(fSettingsShow[kt_sws_delay] as TDoubleParameterShow).Data;
 fKt_2450_SweepParameters.Count:=(fSettingsShow[kt_sws_count] as TIntegerParameterShow).Data;
 fKt_2450_SweepParameters.RangeType:=TKt2450_SweepRangeType((fSettingsShow[kt_sws_ranget] as TStringParameterShow).Data);
 fKt_2450_SweepParameters.Dual:=fDualCB.Checked;
 fKt_2450_SweepParameters.FailAbort:=fAbortLimitCB.Checked;

 SelectClick(nil);
end;

procedure TKt_2450_SweetShow.WriteToIniFile(ConfigFile: TIniFile);
 var i:TKt2450_SweepSettings;
begin
 for i := Low(fSettingsShow) to High(fSettingsShow) do
   fSettingsShow[i].WriteToIniFile(ConfigFile);

 WriteIniDef(ConfigFile, fKt_2450.Name, 'SW_Mode'+Kt2450_SourceName[fKt_2450.SourceType], fMode.ItemIndex, 0);
 ConfigFile.WriteInteger(fKt_2450.Name, 'SW_Select', fSelect.ItemIndex);
// WriteIniDef(ConfigFile, fKt_2450.Name, 'SW_Select', fSelect.ItemIndex, 0);
// WriteIniDef(ConfigFile, fKt_2450.Name, 'SW_Dual'+Kt2450_SourceName[fKt_2450.SourceType], fDualCB.Checked, False);
// WriteIniDef(ConfigFile, fKt_2450.Name, 'SW_FailAbort'+Kt2450_SourceName[fKt_2450.SourceType], fAbortLimitCB.Checked);
 ConfigFile.WriteBool(fKt_2450.Name,'SW_Dual'+Kt2450_SourceName[fKt_2450.SourceType], fDualCB.Checked);
 ConfigFile.WriteBool(fKt_2450.Name,'SW_FailAbort'+Kt2450_SourceName[fKt_2450.SourceType], fAbortLimitCB.Checked);
end;

procedure TKt_2450_SweetShow.SettingTunning(i: TKt2450_SweepSettings);
begin
  fSettingsShow[i].SetName(fKt_2450.Name);
  fSettingsShow[i].IniNameSalt := Kt2450_SourceName[fKt_2450.SourceType];
  fSettingsShow[i].HookParameterClick := UpDateObject;
end;

{ TKt_2450_MeterShow }

constructor TKt_2450_MeterShow.Create(KT2450_Meter: TKeitley_Meter;
                                      Kt_2450_Show:TKt_2450_Show;
                                      DL,UL: TLabel;
                                      MB: TButton; AB: TSpeedButton);
begin
// inherited Create(KT2450_Meter,DL,UL,MB,AB,KT2450_Meter.Timer);
// fKT2450_Meter:=KT2450_Meter;
 inherited Create(KT2450_Meter,DL,UL,MB,AB);
 fKt_2450_Show:=Kt_2450_Show;
end;

procedure TKt_2450_MeterShow.MeasurementButtonClick(Sender: TObject);
begin
 inherited;
 fKt_2450_Show.OutPutOnFromDevice;
end;

//function TKt_2450_MeterShow.UnitModeLabel: string;
//begin
// Result:=fKT2450_Meter.MeasureModeLabel;
//end;

{ TKt_StringParameterShow }

//constructor TKeitley_StringParameterShow.Create(ST: TStaticText; Kt_2450: TKt_2450);
//begin
//  fKt_2450:=Kt_2450;
//  SomeAction();
//  fSettingsShowSL:=TStringList.Create;
//  SettingsShowSLFilling();
//  inherited Create(ST,fCaption,fSettingsShowSL);
//  HookParameterClick:=OkClick;
//end;

//destructor TKeitley_StringParameterShow.Destroy;
//begin
//  FreeAndNil(fSettingsShowSL);
//  inherited;
//end;

{ TKt_BrightnessShow }

//procedure TKeitley_BrightnessShow.ObjectToSetting;
//begin
//// showmessage(inttostr(ord(fKt_2450.DisplayState)));
// Data:=ord(fKt_2450.DisplayState);
//end;
//
//procedure TKeitley_BrightnessShow.OkClick;
//begin
// fKt_2450.SetDisplayBrightness(TKeitley_DisplayState(Data));
//end;
//
//procedure TKeitley_BrightnessShow.SettingsShowSLFilling;
// var i:TKeitley_DisplayState;
//begin
// for I := Low(TKeitley_DisplayState) to High(TKeitley_DisplayState) do
//             fSettingsShowSL.Add(Keitley_DisplayStateLabel[i]);
//end;
//
//procedure TKeitley_BrightnessShow.SomeAction;
//begin
// fCaption:='Brightness';
//end;

end.
