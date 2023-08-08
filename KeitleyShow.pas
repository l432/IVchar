unit KeitleyShow;

interface

uses
  OlegTypePart2, Keithley, StdCtrls, OlegShowTypes, Classes, ArduinoDeviceNew, 
  ExtCtrls, IniFiles, Measurement, Buttons, SCPIshow;

const
  ButtonNumberKeitley = 1;

type

TKeitley_Show=class;

//TKeitley_SetupMemoryPins=class(TPins)
// protected
//  Function GetPinStr(Index:integer):string;override;
// public
//  Constructor Create(Name:string);
//end;

TKeitley_SetupMemoryShow=class(TPinsShowUniversal)
 private
  fKeitley_Show:TKeitley_Show;
//  fMemoryPins:TKeitley_SetupMemoryPins;
  fMemoryPins:TSCPI_SetupMemoryPins;
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

TKeitley_MeterShow=class(TMeasurementShowSimple)
  private
   fKeitley_Meter:TKeitley_Meter;
  protected
   function UnitModeLabel():string;override;
  public
   Constructor Create(Keitley_Meter:TKeitley_Meter;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton
                      );
end;

 TKeitley_Show=class(TSimpleFreeAndAiniObject)
  private
   fKeitley:TKeitley;
   fSetupMemoryShow:TKeitley_SetupMemoryShow;
   fBrightnessShow:TKeitley_BrightnessShow;
   procedure TestButtonClick(Sender:TObject);
   procedure MyTrainButtonClick(Sender:TObject);
  protected
   procedure ButtonsTune(Buttons: array of TButton);virtual;
   procedure ResetButtonClick(Sender:TObject);virtual;
   procedure GetSettingButtonClick(Sender:TObject);virtual;
  public
   Constructor Create(Keitley:TKeitley;
                      Buttons:Array of TButton;
                      Panels:Array of TPanel;
                      STextsBrightness:TStaticText
                      );
  destructor Destroy;override;
  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
  procedure WriteToIniFile(ConfigFile:TIniFile);override;
  procedure ObjectToSetting;virtual;
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
  fKeitley:=Keitley;
  ButtonsTune(Buttons);

  fBrightnessShow:=TKeitley_BrightnessShow.Create(STextsBrightness,fKeitley);
  fSetupMemoryShow:=TKeitley_SetupMemoryShow.Create(Self,Panels[0],Panels[1]);


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

//constructor TKeitley_SetupMemoryPins.Create(Name: string);
//begin
// inherited Create(Name,['SaveSlot','LoadSlot']);
// PinStrPart:='';
//end;
//
//function TKeitley_SetupMemoryPins.GetPinStr(Index: integer): string;
//begin
// case Index of
//  0:Result:='Save Setup';
//  else Result:='Load Setup';
// end;
//end;

{ TKeitley_SetupMemoryShow }

procedure TKeitley_SetupMemoryShow.CommandSend;
begin
end;

constructor TKeitley_SetupMemoryShow.Create(Keitley_Show: TKeitley_Show;
  PanelSave, PanelLoad: TPanel);
begin
 fKeitley_Show:=Keitley_Show;
// fMemoryPins:=TKeitley_SetupMemoryPins.Create(fKeitley_Show.fKeitley.Name+'Pins');
 fMemoryPins:=TSCPI_SetupMemoryPins.Create(fKeitley_Show.fKeitley.Name+'Pins');
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

{ TKeitley_MeterShow }

constructor TKeitley_MeterShow.Create(Keitley_Meter: TKeitley_Meter; DL,
  UL: TLabel; MB: TButton; AB: TSpeedButton);
begin
 inherited Create(Keitley_Meter,DL,UL,MB,AB,Keitley_Meter.Timer);
 fKeitley_Meter:=Keitley_Meter;
end;

function TKeitley_MeterShow.UnitModeLabel: string;
begin
 Result:=fKeitley_Meter.MeasureModeLabel;
end;

end.
