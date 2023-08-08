unit DMM6500Show;

interface

uses
  OlegTypePart2, DMM6500, KeitleyShow, StdCtrls, ExtCtrls,
  DMM6500_MeasParamShow, Keitley2450Const, Keithley, Buttons;

type
TDMM6500_Show=class;

TDMM6500_MeterShow=class(TKeitley_MeterShow)
  private
   fDMM6500_Show:TDMM6500_Show;
  protected
  public
   Constructor Create(KT2450_Meter:TKeitley_Meter;
                      DMM6500_Show:TDMM6500_Show;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton
                      );
end;

 TDMM6500_Show=class(TKeitley_Show)
  private
   fDMM6500:TDMM6500;
   fTerminalState:TStaticText;
   fMeasureTypeShow:TDMM6500_MeasurementTypeShow;
   fControlChannels:TDMM6500ControlChannels;
   fGBControlChannels:TGroupBox;
   fGBParametrShow:TGroupBox;
   fGBScanParametrShow:TGroupBox;
   fMeasParShow:TDMM6500_MeasParShow;
   fMeterShow:TDMM6500_MeterShow;
   fScanParameters:TDMM6500ScanParameters;

    procedure   ControlChannelsCreate;
    procedure MeasureParamShowCreate;
    procedure MeasureParamShowDestroy;
  protected
    procedure GetSettingButtonClick(Sender:TObject);override;
  public
   property MeterShow:TDMM6500_MeterShow read fMeterShow;
   Constructor Create(DMM6500:TDMM6500;
                      ButtonsKeitley:Array of TButton;
                      PanelsSetting:Array of TPanel;
                      STexts:array of TStaticText;
                      GBs:array of TGroupBox;
                      DataMeterL,UnitMeterL:TLabel;
                      MeasureMeterB:TButton;
                      AutoMMeterB:TSpeedButton);
  destructor Destroy;override;
  procedure ObjectToSetting;override;
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
                  GBs:array of TGroupBox;
                  DataMeterL,UnitMeterL:TLabel;
                  MeasureMeterB:TButton;
                  AutoMMeterB:TSpeedButton);
begin

  inherited Create(DMM6500,ButtonsKeitley,
                   PanelsSetting,
                   STexts[0]);
  fDMM6500:=DMM6500;
  fTerminalState:=STexts[1];
  fGBControlChannels:=GBs[0];
  fGBParametrShow:=GBs[1];
  fGBScanParametrShow:=GBs[2];

  fScanParameters:=TDMM6500ScanParameters.Create(fGBScanParametrShow,fDMM6500);

  fMeasureTypeShow:=TDMM6500_MeasurementTypeShow.Create(STexts[2],fDMM6500);
  fMeasureTypeShow.HookParameterClick:=MeasureParamShowCreate;

  fMeterShow:=TDMM6500_MeterShow.Create(fDMM6500.Meter,Self,
                                 DataMeterL,UnitMeterL,
                                MeasureMeterB,AutoMMeterB);
  fMeterShow.DigitNumber:=6;

  ObjectToSetting();
end;


destructor TDMM6500_Show.Destroy;
begin
  MeasureParamShowDestroy;
  fMeasureTypeShow.Free;
  fScanParameters.Free;
  inherited;
end;

procedure TDMM6500_Show.GetSettingButtonClick(Sender: TObject);
begin
  if not(DeviceEthernetisAbsent) then
    begin
     fDMM6500.GetCardParametersFromDevice;
     fScanParameters.GetDataFromDeviceAndToSetting;
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


procedure TDMM6500_Show.ObjectToSetting;
begin
  inherited ObjectToSetting;
  fTerminalState.Caption:=Keitlay_TerminalsButtonName[fDMM6500.Terminal];
  fMeasureTypeShow.ObjectToSetting;
  ControlChannelsCreate;

  MeasureParamShowDestroy;
  fMeasParShow:=MeasParShowFactory(fDMM6500.MeasureFunction,
                fGBParametrShow,fDMM6500,0);
  fScanParameters.ObjectToSetting;
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

{ TDMM6500_MeterShow }

constructor TDMM6500_MeterShow.Create(KT2450_Meter: TKeitley_Meter;
  DMM6500_Show: TDMM6500_Show; DL, UL: TLabel; MB: TButton; AB: TSpeedButton);
begin
 inherited Create(KT2450_Meter,DL,UL,MB,AB);
 fDMM6500_Show:=DMM6500_Show;
end;

end.
