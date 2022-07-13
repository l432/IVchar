unit DMM6500Show;

interface

uses
  OlegTypePart2, DMM6500, KeitleyShow, StdCtrls, ExtCtrls;

type

 TDMM6500_Show=class(TKeitley_Show)
  private
   fDMM6500:TDMM6500;
   fTerminalState:TStaticText;
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
//   procedure SourceShowCreate();
//   procedure SourceShowFree();
//
//   procedure MeasureShowCreate();
//   procedure MeasureShowFree();
//
//   procedure SweetShowCreate();
//
//   procedure ResetButtonClick(Sender:TObject);

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
  protected
    procedure GetSettingButtonClick(Sender:TObject);override;
  public
//   property MeterShow:TKt_2450_MeterShow read fMeterShow;
   Constructor Create(DMM6500:TDMM6500;
                      ButtonsKeitley:Array of TButton;
                      PanelsSetting:Array of TPanel;
                      STexts:array of TStaticText);
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
  procedure ObjectToSetting;override;
//  procedure OutPutOnFromDevice();
 end;



var
  DMM6500_Show:TDMM6500_Show;



implementation

uses
  Keitley2450Const, TelnetDevice;

{ TDMM6500_Show }

constructor TDMM6500_Show.Create(DMM6500: TDMM6500;
                  ButtonsKeitley: array of TButton;
                  PanelsSetting:Array of TPanel;
                  STexts:array of TStaticText);
begin

  inherited Create(DMM6500,ButtonsKeitley,
                   PanelsSetting,
                   STexts[0]);
  fDMM6500:=DMM6500;
  fTerminalState:=STexts[1];

  ObjectToSetting();
end;

procedure TDMM6500_Show.GetSettingButtonClick(Sender: TObject);
begin
  if not(DeviceEthernetisAbsent) then
    begin
     fDMM6500.GetCardParametersFromDevice;


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
//    fKt_2450.GetCount();
    end;

  inherited GetSettingButtonClick(Sender);
end;

procedure TDMM6500_Show.ObjectToSetting;
begin
  inherited ObjectToSetting;
  fTerminalState.Caption:=Keitlay_TerminalsButtonName[fDMM6500.Terminal];
end;

end.
