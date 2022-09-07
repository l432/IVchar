unit DMM6500Show;

interface

uses
  OlegTypePart2, DMM6500, KeitleyShow, StdCtrls, ExtCtrls, 
  DMM6500_MeasParamShow, Keitley2450Const;

type

 TDMM6500_Show=class(TKeitley_Show)
  private
   fDMM6500:TDMM6500;
   fTerminalState:TStaticText;
   fMeasureTypeShow:TDMM6500_MeasurementTypeShow;
   fControlChannels:TDMM6500ControlChannels;
   fGBControlChannels:TGroupBox;
   fGBParametrShow:TGroupBox;
   fMeasParShow:TDMM6500_MeasParShow;



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
    procedure   ControlChannelsCreate;
//    function MeasParShowFactory(MeasureType:TKeitley_Measure;
//                Parent:TGroupBox;DMM6500:TDMM6500;
//                ChanNumber:byte=0):TDMM6500_MeasParShow;
    procedure MeasureParamShowCreate;
    procedure MeasureParamShowDestroy;
  protected
    procedure GetSettingButtonClick(Sender:TObject);override;
  public
//   property MeterShow:TKt_2450_MeterShow read fMeterShow;
   Constructor Create(DMM6500:TDMM6500;
                      ButtonsKeitley:Array of TButton;
                      PanelsSetting:Array of TPanel;
                      STexts:array of TStaticText;
                      GBs:array of TGroupBox);
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
  destructor Destroy;override;
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
  TelnetDevice, SysUtils, Dialogs, Graphics, Controls;

{ TDMM6500_Show }

procedure TDMM6500_Show.ControlChannelsCreate;
begin
 if fControlChannels=nil
   then fControlChannels:=TDMM6500ControlChannels.Create(fGBControlChannels,fDMM6500)
   else
    if fControlChannels.ChanCount<>High(fDMM6500.ChansMeasure)+1 then
      begin
        FreeAndNil(fControlChannels);
        fControlChannels:=TDMM6500ControlChannels.Create(fGBControlChannels,fDMM6500);
      end;

end;

constructor TDMM6500_Show.Create(DMM6500: TDMM6500;
                  ButtonsKeitley: array of TButton;
                  PanelsSetting:Array of TPanel;
                  STexts:array of TStaticText;
                  GBs:array of TGroupBox);
begin

  inherited Create(DMM6500,ButtonsKeitley,
                   PanelsSetting,
                   STexts[0]);
  fDMM6500:=DMM6500;
  fTerminalState:=STexts[1];
  fGBControlChannels:=GBs[0];
  fGBParametrShow:=GBs[1];

  fMeasureTypeShow:=TDMM6500_MeasurementTypeShow.Create(STexts[2],fDMM6500);
  fMeasureTypeShow.HookParameterClick:=MeasureParamShowCreate;


  ObjectToSetting();
end;


destructor TDMM6500_Show.Destroy;
begin
  MeasureParamShowDestroy;
  fMeasureTypeShow.Free;
  inherited;
end;

procedure TDMM6500_Show.GetSettingButtonClick(Sender: TObject);
begin
  if not(DeviceEthernetisAbsent) then
    begin
     fDMM6500.GetCardParametersFromDevice;
     fMeasureTypeShow.GetDataFromDevice;
    end;

  inherited GetSettingButtonClick(Sender);

  if not(DeviceEthernetisAbsent) then
    begin
     if fMeasParShow<>nil then
       fMeasParShow.GetDataFromDeviceAndToSetting;
     fControlChannels.GetDataFromDeviceAndToSetting;
    end;

end;

//function TDMM6500_Show.MeasParShowFactory(MeasureType: TKeitley_Measure;
//  Parent: TGroupBox; DMM6500: TDMM6500; ChanNumber: byte): TDMM6500_MeasParShow;
//begin
// case MeasureType of
//   kt_mCurDC: Result:=nil;
////   kt_mVolDC: Result:=nil;
//   kt_mVolDC: Result:=TDMM6500MeasPar_BaseShow.Create(Parent,DMM6500,ChanNumber);
//   kt_mRes2W: Result:=nil;
//   kt_mCurAC: Result:=nil;
//   kt_mVolAC: Result:=nil;
//   kt_mRes4W: Result:=nil;
//   kt_mDiod: Result:=nil;
//   kt_mCap: Result:=nil;
//   kt_mTemp: Result:=nil;
//   kt_mCont: Result:=nil;
//   kt_mFreq: Result:=nil;
//   kt_mPer: Result:=nil;
//   kt_mVoltRat: Result:=nil;
//   kt_mDigCur: Result:=nil;
////   else Result:=TDMM6500MeasPar_BaseShow.Create(Parent,DMM6500,ChanNumber);
//   else Result:=TDMM6500MeasPar_DigVoltShow.Create(Parent,DMM6500,ChanNumber);
// end;
//end;

procedure TDMM6500_Show.ObjectToSetting;
begin
  inherited ObjectToSetting;
  fTerminalState.Caption:=Keitlay_TerminalsButtonName[fDMM6500.Terminal];
  fMeasureTypeShow.ObjectToSetting;
  ControlChannelsCreate;
  MeasureParamShowDestroy;
  fMeasParShow:=MeasParShowFactory(fDMM6500.MeasureFunction,
                fGBParametrShow,fDMM6500,0);
//  MeasureParamShowCreate;
end;

procedure TDMM6500_Show.MeasureParamShowCreate;
begin
 MeasureParamShowDestroy;
 fMeasParShow:=MeasParShowFactory(fDMM6500.MeasureFunction,
                fGBParametrShow,fDMM6500,0);
 if not(DeviceEthernetisAbsent) then
   if fMeasParShow<>nil then
     fMeasParShow.GetDataFromDeviceAndToSetting;
end;

procedure TDMM6500_Show.MeasureParamShowDestroy;
begin
  if Assigned(fMeasParShow) then
    FreeAndNil(fMeasParShow);
end;

end.
