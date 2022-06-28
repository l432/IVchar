unit KeitleyShow;

interface

uses
  OlegTypePart2, Keithley, StdCtrls;

const
  ButtonNumberKeitley = 1;

type

 TKeitley_Show=class(TSimpleFreeAndAiniObject)
  private
   fKeitley:TKeitley;

//   fSettingsShow:array of TParameterShowNew;
//   fSettingsShowSL:array of TStringList;

//   fOutPutOnOff:TSpeedButton;
//   fTerminalsFrRe:TSpeedButton;
//   fSetupMemoryShow:TKT2450_SetupMemoryShow;
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
//   fBrightnessShow:TKt2450_BrightnessShow;
//
//   procedure SourceShowCreate();
//   procedure SourceShowFree();
//
//   procedure MeasureShowCreate();
//   procedure MeasureShowFree();
//
//   procedure SweetShowCreate();
//
   procedure TestButtonClick(Sender:TObject);
//   procedure ResetButtonClick(Sender:TObject);
//   procedure GetSettingButtonClick(Sender:TObject);
//   procedure RefreshZeroClick(Sender:TObject);
//   procedure SourceMeasureClick(Sender:TObject);
   procedure MyTrainButtonClick(Sender:TObject);
//   procedure AutoZeroClick(Sender:TObject);
   procedure ButtonsTune(Buttons: array of TButton);
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
   BTest:TButton;
  public
//   property MeterShow:TKt_2450_MeterShow read fMeterShow;
   Constructor Create(Keitley:TKeitley;
                      Buttons:Array of TButton);
//                      SpeedButtons:Array of TSpeedButton;
//                      Panels:Array of TPanel;
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
//  destructor Destroy;override;
//  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
//  procedure WriteToIniFile(ConfigFile:TIniFile);override;
//  procedure SettingToObject;
//  procedure ObjectToSetting;virtual;
//  procedure OutPutOnFromDevice();
 end;


implementation

uses
  Dialogs, Graphics;

{ TKt_2450_Show }

procedure TKeitley_Show.ButtonsTune(Buttons: array of TButton);
begin
  Buttons[0].Caption := 'Connection Test ?';
  Buttons[0].OnClick := TestButtonClick;
  BTest := Buttons[0];

  Buttons[1].Caption := 'MyTrain';
  Buttons[1].OnClick := MyTrainButtonClick;
end;

constructor TKeitley_Show.Create(Keitley: TKeitley; Buttons: array of TButton);
begin
  if (High(Buttons)<>ButtonNumberKeitley)
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
   then
    begin
      showmessage('Keitley_Show is not created!');
      Exit;
    end;
  fKeitley:=Keitley;
  ButtonsTune(Buttons);

//  SpeedButtonsTune(SpeedButtons);
//
//  CBnumber:=0;
//
//  SettingsShowSLCreate();
//  SettingsShowCreate(STexts,Labels);
//  fBrightnessShow:=TKt2450_BrightnessShow.Create(STexts[ord(High(TKt2450_Settings))+1],fKt_2450);
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
//  fSetupMemoryShow:=TKT2450_SetupMemoryShow.Create(Self,Panels[0],Panels[1]);

//  ObjectToSetting();

end;

procedure TKeitley_Show.MyTrainButtonClick(Sender: TObject);
begin
 fKeitley.MyTraining();
end;

//procedure TKeitley_Show.ObjectToSetting;
//begin
//
//end;

procedure TKeitley_Show.TestButtonClick(Sender: TObject);
begin
   if fKeitley.Test then
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
