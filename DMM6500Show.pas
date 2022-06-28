unit DMM6500Show;

interface

uses
  OlegTypePart2, DMM6500, KeitleyShow, StdCtrls;

type

 TDMM6500_Show=class(TKeitley_Show)
  private
   fDMM6500:TDMM6500;

//   fSettingsShow:array of TParameterShowNew;
//   fSettingsShowSL:array of TStringList;
//   BTest:TButton;
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
//   procedure ResetButtonClick(Sender:TObject);
//   procedure GetSettingButtonClick(Sender:TObject);
//   procedure RefreshZeroClick(Sender:TObject);
//   procedure SourceMeasureClick(Sender:TObject);
//   procedure AutoZeroClick(Sender:TObject);
//   procedure ButtonsTune(Buttons: array of TButton);
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
  public
//   property MeterShow:TKt_2450_MeterShow read fMeterShow;
   Constructor Create(DMM6500:TDMM6500;
                      ButtonsKeitley:Array of TButton);
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
//  procedure ObjectToSetting;
//  procedure OutPutOnFromDevice();
 end;



var
  DMM6500_Show:TDMM6500_Show;



implementation

{ TDMM6500_Show }

constructor TDMM6500_Show.Create(DMM6500: TDMM6500; ButtonsKeitley: array of TButton);
begin
  inherited Create(DMM6500,ButtonsKeitley);
  fDMM6500:=DMM6500;
end;

end.
