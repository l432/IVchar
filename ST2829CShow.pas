unit ST2829CShow;

interface

uses
  OlegTypePart2, ST2829C, StdCtrls, SCPIshow, ExtCtrls, ArduinoDeviceNew, 
  IniFiles, ST2829CParamShow, Buttons, Measurement;

type
 TST2829C_Show=class;


 TST2829CElement_Show=class(TGBwithControlElements)
  private
   fST2829C:TST2829C;
  public
   Constructor Create(ST2829C:TST2829C;
                      GB: TGroupBox);
 end;

TST2829C_SetupMemoryShow=class(TPinsShowUniversal)
 private
  fST2829CElement_Show:TST2829CElement_Show;
  fMemoryPins:TSCPI_SetupMemoryPins;
 protected
  procedure LabelsFilling;
  procedure CommandSend;
 public
  Constructor Create(ST2829CElement_Show:TST2829CElement_Show;
                     PanelSave, PanelLoad:TPanel);
  destructor Destroy;override;
  procedure NumberPinShow(PinActiveNumber:integer=-1;ChooseNumber:integer=-1);override;
end;

  TST2829CSetting_Show=class(TST2829CElement_Show)
   private
    fPSave:TPanel;
    fPLoad:TPanel;
    fBReset:TButton;
    fBGetParam:TButton;
    fSetupMemoryShow:TST2829C_SetupMemoryShow;
    fST2829C_Show:TST2829C_Show;
   protected
    procedure CreateElements;override;
    procedure DesignElements;override;
    procedure CreateControls;override;
    procedure DestroyControls;override;
    procedure ResetButtonClick(Sender:TObject);
    procedure GetSettingButtonClick(Sender:TObject);
   public
    Constructor Create(ST2829C_Show:TST2829C_Show;
                      GB: TGroupBox);
    procedure ReadFromIniFile(ConfigFile:TIniFile);//override;//virtual;
    procedure WriteToIniFile(ConfigFile:TIniFile);//override;//virtual;
  end;


 TST2829CElementAndParamShow=class(TGBwithControlElementsAndParamShow)
  private
   fST2829C:TST2829C;
  public
   Constructor Create(ST2829C:TST2829C;
                      GB: TGroupBox);
 end;

 TST2829CMeasureParamShow=class(TST2829CElementAndParamShow)
  private
   fBVrmsNeasuring:TButton;
   fBIrmsNeasuring:TButton;
   fLVrmsData:TLabel;
   fLIrmsData:TLabel;
   procedure VrmsDataToLabel;
   procedure IrmsDataToLabel;
  protected
   procedure CreateElements;override;
   procedure CreateControls;override;
   procedure DesignElements;override;
   procedure VMeasShowClick;
   procedure IMeasShowClick;
   procedure VrmsToMeasureClick;
   procedure IrmsToMeasureClick;
   procedure rmsMeasuringClick(Sender:TObject);
  public
   AutoLevelShow:TST2829C_AutoLevelShow;
   FreqMeasShow:TST2829C_FreqMeasShow;
   VMeasShow:TST2829C_VMeasShow;
   IMeasShow:TST2829C_IMeasShow;
   VrmsToMeasureShow:TST2829C_VrmsToMeasureShow;
   IrmsToMeasureShow:TST2829C_IrmsToMeasureShow;
   procedure ObjectToSetting;override;
 end;

 TST2829CBiasParamShow=class(TST2829CElementAndParamShow)
  private
   fSBOnOff:TSpeedButton;
   procedure OnOffSpeedButtonClick(Sender: TObject);
  protected
   procedure CreateElements;override;
   procedure CreateControls;override;
   procedure DesignElements;override;
   procedure BiasVoltageShowClick;
   procedure BiasCurrentShowClick;
  public
   BiasVoltageShow:TST2829C_BiasVoltageShow;
   BiasCurrentShow:TST2829C_BiasCurrentShow;
   procedure ObjectToSetting;override;
   procedure BiasOutPutFromDevice();
 end;

 TST2829CSetupParamShow=class(TST2829CElementAndParamShow)
  private
   fBTrig:TButton;
   procedure BTrigClick(Sender:TObject);
  protected
   procedure CreateElements;override;
   procedure CreateControls;override;
   procedure DesignElements;override;
  public
   OutputImpedanceShow:TST2829C_OutputImpedanceShow;
   RangeShow:TST2829C_RangeShow;
   MeasureSpeedShow:TST2829C_MeasureSpeedShow;
   AverTimesShow:TST2829C_AverTimesShow;
   TrigerSourceShow:TST2829C_TrigerSourceShow;
   DelayTimeShow:TST2829C_DelayTimeShow;
//   procedure ObjectToSetting;override;
 end;


TST2829C_MeterShow=class(TMeasurementShowSimple)
  private
   fST2829_MeterPrimary:TST2829_MeterPrimary;
   fDataLabel2,fUnitLabel2:TLabel;
  protected
   function UnitModeLabel():string;override;
  public
   Constructor Create(ST2829_MeterPrimary:TST2829_MeterPrimary;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      DL2,UL2:TLabel
                      );
  procedure MetterDataShow();override;
end;

  TST2829C_Show=class(TRS232DeviceNew_Show)
  private
   fST2829C:TST2829C;
   fSettingShow:TST2829CSetting_Show;
//   fSetupMemoryShow:TKeitley_SetupMemoryShow;
//   fBrightnessShow:TKeitley_BrightnessShow;
//   procedure TestButtonClick(Sender:TObject);
   fMeasureTypeShow:TST2829C_MeasureTypeShow;
   fMeasureParamShow:TST2829CMeasureParamShow;
   fBiasParamShow:TST2829CBiasParamShow;
   fSetupParamShow:TST2829CSetupParamShow;
   fMeterShow:TST2829C_MeterShow;
   procedure MyTrainButtonClick(Sender:TObject);
  protected
//   procedure ButtonsTune(Buttons: array of TButton);virtual;
//   procedure ResetButtonClick(Sender:TObject);virtual;
//   procedure GetSettingButtonClick(Sender:TObject);virtual;
  public
//   Constructor Create(ST2829C:TST2829C;
//                      ButTest:TButton);
   property ST2829C:TST2829C read fST2829C;
   Constructor Create(ST2829C:TST2829C;
                      GBs: array of TGroupBox;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      DL2,UL2:TLabel;
                      B_MyTrain:TButton);
//                      Buttons:Array of TButton;
//                      Panels:Array of TPanel;
//                      STextsBrightness:TStaticText
//                      );
  destructor Destroy;override;
  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
  procedure WriteToIniFile(ConfigFile:TIniFile);override;
  procedure ObjectToSetting;virtual;
 end;

var
  ST2829C_Show:TST2829C_Show;

implementation

uses
  OApproxShow, ST2829CConst, SysUtils, RS232deviceNew, Dialogs, Graphics, 
  Classes, OlegType;

{ TST2829C_Show }

//constructor TST2829C_Show.Create(ST2829C: TST2829C; ButTest: TButton);
constructor TST2829C_Show.Create(ST2829C:TST2829C;
                     GBs: array of TGroupBox;
                     DL,UL:TLabel;
                     MB:TButton;
                     AB:TSpeedButton;
                     DL2,UL2:TLabel;
                     B_MyTrain:TButton);
begin
 fST2829C:=ST2829C;
 DecimalSeparator:='.';
 inherited Create((ST2829C.Device as TST2829CDevice),GBs[0]);
// showmessage('TST2829C_Show Create');
// showmessage(fST2829C.Name);
// showmessage(Self.fST2829C.Name);
 fSettingShow:=TST2829CSetting_Show.Create(Self,GBs[1]);
 B_MyTrain.OnClick:=MyTrainButtonClick;

 fMeasureTypeShow:=TST2829C_MeasureTypeShow.Create(fST2829C);
 fMeasureTypeShow.ParentToElements(GBs[0].Parent);
 fMeasureTypeShow.STdata.Top:=15;
 fMeasureTypeShow.STdata.Left:=220;
 fMeasureTypeShow.STdata.Font.Name:='Verdana';
 fMeasureTypeShow.STdata.Font.Height:=-23;
 fMeasureTypeShow.STdata.Font.Style:=[fsBold];

 fMeasureParamShow:=TST2829CMeasureParamShow.Create(fST2829C,GBs[2]);

 fBiasParamShow:=TST2829CBiasParamShow.Create(fST2829C,GBs[3]);

 fSetupParamShow:=TST2829CSetupParamShow.Create(fST2829C,GBs[4]);

 fMeterShow:=TST2829C_MeterShow.Create(fST2829C.MeterPrim,DL,UL,MB,AB,DL2,UL2);

end;

//procedure TST2829C_Show.TestButtonClick(Sender: TObject);
//begin
//   if fST2829C.Test
//     then (Sender as TButton).Caption:='Connection Test - Ok'
//     else (Sender as TButton).Caption:='Connection Test - Failed';
//end;

destructor TST2829C_Show.Destroy;
begin
  FreeAndNil(fMeterShow);
  FreeAndNil(fSetupParamShow);
  FreeAndNil(fBiasParamShow);
  FreeAndNil(fMeasureParamShow);
  FreeAndNil(fMeasureTypeShow);
  FreeAndNil(fSettingShow);
  inherited;
end;

procedure TST2829C_Show.MyTrainButtonClick(Sender: TObject);
begin
 //  showmessage(inttostr(fParent.Height));
//  showmessage(inttostr(fParent.Width));
 fST2829C.MyTraining();
end;

procedure TST2829C_Show.ObjectToSetting;
begin
 fMeasureTypeShow.ObjectToSetting;
 fMeasureParamShow.ObjectToSetting;
 fBiasParamShow.ObjectToSetting;
 fSetupParamShow.ObjectToSetting;
end;

procedure TST2829C_Show.ReadFromIniFile(ConfigFile: TIniFile);
begin
  inherited ReadFromIniFile(ConfigFile);
  fSettingShow.ReadFromIniFile(ConfigFile);
end;

procedure TST2829C_Show.WriteToIniFile(ConfigFile: TIniFile);
begin
  inherited WriteToIniFile(ConfigFile);
  fSettingShow.WriteToIniFile(ConfigFile);
end;

{ TST2829CElement_Show }

constructor TST2829CElement_Show.Create(ST2829C: TST2829C; GB: TGroupBox);
begin
 fST2829C:=ST2829C;
 inherited Create(GB);
end;

{ TST2829CSetting_Show }

constructor TST2829CSetting_Show.Create(ST2829C_Show: TST2829C_Show;
  GB: TGroupBox);
begin
 fST2829C_Show:=ST2829C_Show;
 inherited Create(fST2829C_Show.ST2829C,GB);
end;

procedure TST2829CSetting_Show.CreateControls;
begin
// showmessage('kk');
// showmessage(fST2829C_Show.ST2829C.Name);
// showmessage('kk1');
 fSetupMemoryShow:=TST2829C_SetupMemoryShow.Create(Self,fPSave,fPLoad);
 fBReset.OnClick := ResetButtonClick;
 fBGetParam.OnClick := GetSettingButtonClick;
end;

procedure TST2829CSetting_Show.CreateElements;
begin
 fPSave:=TPanel.Create(fParent);
 fPLoad:=TPanel.Create(fParent);
 fBReset:=TButton.Create(fParent);
 fBGetParam:=TButton.Create(fParent);
 Add(fPSave);
 Add(fPLoad);
 Add(fBReset);
 Add(fBGetParam);
 inherited CreateElements;
end;

procedure TST2829CSetting_Show.DesignElements;
begin
// inherited DesignElements;
 fParent.Caption:='Setting';
 DesignSettingPanel(fPSave,'Save Setup');
 DesignSettingPanel(fPLoad,'Load Setup');
 fPSave.Top:=MarginTop;
 fPSave.Left:=5;
 RelativeLocation(fPSave,fPLoad,oCol,3);
// fBGetParam.Left:=3;
 fBGetParam.Caption:='Get from device';
 Resize(fBGetParam);
 fBReset.Caption:='Reset';
 RelativeLocation(fPLoad,fBGetParam,oCol,3);
 fPSave.Left:=fPLoad.Left;
 RelativeLocation(fBGetParam,fBReset,oCol,3);
 fParent.Width:=fBGetParam.Left+fBGetParam.Width+5;
 fParent.Height:=fBReset.Top+fBReset.Height+5;


end;

procedure TST2829CSetting_Show.DestroyControls;
begin
 FreeAndNil(fSetupMemoryShow);
end;

procedure TST2829CSetting_Show.GetSettingButtonClick(Sender: TObject);
begin
  if not(DeviceRS232isAbsent) then
    begin
     fST2829C.GetFrequancyMeasurement();
     fST2829C.GetAutoLevelEnable();
     fST2829C.GetVoltageMeasurement();
     fST2829C.GetCurrentMeasurement();
     fST2829C.GetBiasEnable();
     fST2829C.GetBiasVoltage();
     fST2829C.GetBiasCurrent();
     fST2829C.GetOutputImpedance();
     fST2829C.GetMeasureFunction();
     fST2829C.GetRange();
     fST2829C.GetMeasureSpeed();
     fST2829C.GetAverTime();
     fST2829C.GetVrmsToMeasure();
     fST2829C.GetIrmsToMeasure();
     fST2829C.GetTrigerSource();
     fST2829C.GetDelayTime();
    end;

  fST2829C_Show.ObjectToSetting();

end;

procedure TST2829CSetting_Show.ReadFromIniFile(ConfigFile: TIniFile);
begin
 fSetupMemoryShow.ReadFromIniFile(ConfigFile);
end;

procedure TST2829CSetting_Show.ResetButtonClick(Sender: TObject);
begin
 fST2829C.ResetSetting();
end;

procedure TST2829CSetting_Show.WriteToIniFile(ConfigFile: TIniFile);
begin
 fSetupMemoryShow.WriteToIniFile(ConfigFile);
end;

{ TST2829C_SetupMemoryShow }

procedure TST2829C_SetupMemoryShow.CommandSend;
begin

end;

constructor TST2829C_SetupMemoryShow.Create(
      ST2829CElement_Show: TST2829CElement_Show;
      PanelSave, PanelLoad: TPanel);
begin
 fST2829CElement_Show:=ST2829CElement_Show;
// fMemoryPins:=TKeitley_SetupMemoryPins.Create(fKeitley_Show.fKeitley.Name+'Pins');
// showmessage(ST2829CElement_Show.fST2829C.Name);
 fMemoryPins:=TSCPI_SetupMemoryPins.Create(fST2829CElement_Show.fST2829C.Name+'Pins');

 inherited Create(fMemoryPins,[PanelSave, PanelLoad]);
 LabelsFilling();
end;

destructor TST2829C_SetupMemoryShow.Destroy;
begin
  fST2829CElement_Show:=nil;
  FreeAndNil(fMemoryPins);
  inherited;
end;

procedure TST2829C_SetupMemoryShow.LabelsFilling;
 var i:byte;
begin
 fPinVariants[0].Clear;
 fPinVariants[1].Clear;
 for I := Low(TST2829C_SetupMemoryRecord) to High(TST2829C_SetupMemoryRecord)-10 do
   begin
     fPinVariants[0].Add(inttostr(I));
     fPinVariants[1].Add(inttostr(I));
   end;
end;

procedure TST2829C_SetupMemoryShow.NumberPinShow(PinActiveNumber,
  ChooseNumber: integer);
 var RecordName:string;
begin
 inherited;
 case PinActiveNumber of
  0:begin
    RecordName := InputBox('Record Name', 'Input name for save if device memory', '');
    fST2829CElement_Show.fST2829C.SaveSetup(TST2829C_SetupMemoryRecord(ChooseNumber),RecordName);
    end;
  1:fST2829CElement_Show.fST2829C.LoadSetup(TST2829C_SetupMemoryRecord(ChooseNumber));
 end;
end;

{ TST2829CElementAndParamShow }

constructor TST2829CElementAndParamShow.Create(ST2829C: TST2829C;
  GB: TGroupBox);
begin
 fST2829C:=ST2829C;
 inherited Create(GB);
end;

{ TST2829CMeasureParamShow }

procedure TST2829CMeasureParamShow.CreateControls;
begin

 FreqMeasShow:=TST2829C_FreqMeasShow.Create(fST2829C);
 Add(FreqMeasShow);

 VMeasShow:=TST2829C_VMeasShow.Create(fST2829C);;
 Add(VMeasShow);
 VMeasShow.HookParameterClick:=VMeasShowClick;

 IMeasShow:=TST2829C_IMeasShow.Create(fST2829C);
 Add(IMeasShow);
 IMeasShow.HookParameterClick:=IMeasShowClick;

 AutoLevelShow:=TST2829C_AutoLevelShow.Create(fST2829C);
 Add(AutoLevelShow);

 VrmsToMeasureShow:=TST2829C_VrmsToMeasureShow.Create(fST2829C);
 Add(VrmsToMeasureShow);

 IrmsToMeasureShow:=TST2829C_IrmsToMeasureShow.Create(fST2829C);
 Add(IrmsToMeasureShow);

 fBVrmsNeasuring.Tag:=1;
 fBVrmsNeasuring.OnClick:=rmsMeasuringClick;

 fBIrmsNeasuring.Tag:=2;
 fBIrmsNeasuring.OnClick:=rmsMeasuringClick;

end;

procedure TST2829CMeasureParamShow.CreateElements;
begin
 fBVrmsNeasuring:=TButton.Create(fParent);
 Add(fBVrmsNeasuring);
 fBIrmsNeasuring:=TButton.Create(fParent);
 Add(fBIrmsNeasuring);
 fLVrmsData:=TLabel.Create(fParent);
 Add(fLVrmsData);
 fLIrmsData:=TLabel.Create(fParent);
 Add(fLIrmsData);
end;

procedure TST2829CMeasureParamShow.DesignElements;
begin
  inherited DesignElements;
  fParent.Caption:='Measuring option';

  FreqMeasShow.LCaption.WordWrap:=False;
  FreqMeasShow.LCaption.Top:=MarginTop;
  FreqMeasShow.LCaption.Left:=10;
  RelativeLocation(FreqMeasShow.LCaption,FreqMeasShow.STdata,oRow,3);
  FreqMeasShow.STdata.Top:=FreqMeasShow.STdata.Top+2;

  VMeasShow.LCaption.WordWrap:=False;
  RelativeLocation(FreqMeasShow.LCaption,VMeasShow.LCaption,oCol,5);
  RelativeLocation(VMeasShow.LCaption,VMeasShow.STdata,oCol,3);
  VMeasShow.LCaption.Font.Color:=clRed;
  VMeasShow.STdata.Font.Color:=clRed;

  IMeasShow.LCaption.WordWrap:=False;
  RelativeLocation(VMeasShow.LCaption,IMeasShow.LCaption,oRow,8);
  RelativeLocation(IMeasShow.LCaption,IMeasShow.STdata,oCol,3);
  IMeasShow.LCaption.Font.Color:=clBlue;
  IMeasShow.STdata.Font.Color:=clBlue;

  Resize(AutoLevelShow.CB);
  AutoLevelShow.CB.Left:=10;
  AutoLevelShow.CB.Top:=VMeasShow.STdata.Top+VMeasShow.STdata.Height+3;

  Resize(VrmsToMeasureShow.CB);
  VrmsToMeasureShow.CB.Left:=10;
  VrmsToMeasureShow.CB.Top:=AutoLevelShow.CB.Top+AutoLevelShow.CB.Height+5;
  VrmsToMeasureShow.CB.Alignment:=taLeftJustify;
  VrmsToMeasureShow.CB.Font.Color:=clGreen;

  Resize(IrmsToMeasureShow.CB);
  IrmsToMeasureShow.CB.Left:=10;
  IrmsToMeasureShow.CB.Top:=VrmsToMeasureShow.CB.Top+VrmsToMeasureShow.CB.Height+3;
  IrmsToMeasureShow.CB.Font.Color:=clOlive;

  fBVrmsNeasuring.Caption:='Get real Vrms';
  fBVrmsNeasuring.WordWrap:=True;
  fBVrmsNeasuring.Height:=round(1.5*fBVrmsNeasuring.Height);
  fBVrmsNeasuring.Left:=10;
  fBVrmsNeasuring.Top:=IrmsToMeasureShow.CB.Top+IrmsToMeasureShow.CB.Height+5;

  fBIrmsNeasuring.Caption:='Get real Irms';
  fBIrmsNeasuring.WordWrap:=True;
  fBIrmsNeasuring.Height:=fBVrmsNeasuring.Height;
  RelativeLocation(fBVrmsNeasuring,fBIrmsNeasuring,oRow,10);

  VrmsToMeasureClick;
  IrmsToMeasureClick;
  VrmsToMeasureShow.HookParameterClick:=VrmsToMeasureClick;
  IrmsToMeasureShow.HookParameterClick:=IrmsToMeasureClick;

  fLVrmsData.Enabled:=False;
  VrmsDataToLabel;

  fLIrmsData.Enabled:=False;
  IrmsDataToLabel;
  
  fParent.Height:=fLVrmsData.Top+fLVrmsData.Height+10;
  fParent.Width:=fBIrmsNeasuring.Left+ fBIrmsNeasuring.Width+10;
end;

procedure TST2829CMeasureParamShow.IMeasShowClick;
begin
 IMeasShow.ObjectToSetting;
 RelativeLocation(IMeasShow.LCaption,IMeasShow.STdata,oCol,3);
 AutoLevelShow.ObjectToSetting;
 IMeasShow.LCaption.Font.Color:=clRed;
 IMeasShow.STdata.Font.Color:=clRed;
 VMeasShow.LCaption.Font.Color:=clBlue;
 VMeasShow.STdata.Font.Color:=clBlue;
end;

procedure TST2829CMeasureParamShow.IrmsDataToLabel;
begin
  if fST2829C.DataIrms = ErResult
    then fLIrmsData.Caption := 'ERROR'
    else fLIrmsData.Caption := FloatToStrF(fST2829C.DataIrms, ffGeneral, 5, 0)+' mA';
 RelativeLocation(fBIrmsNeasuring,fLIrmsData,oCol,5);    
end;

procedure TST2829CMeasureParamShow.IrmsToMeasureClick;
begin
  fBIrmsNeasuring.Enabled:=IrmsToMeasureShow.CB.Checked;
end;

procedure TST2829CMeasureParamShow.ObjectToSetting;
begin
  inherited ObjectToSetting;
  VrmsToMeasureClick;
  IrmsToMeasureClick;
end;

procedure TST2829CMeasureParamShow.VrmsDataToLabel;
begin
  if fST2829C.DataVrms = ErResult
    then fLVrmsData.Caption := 'ERROR'
    else fLVrmsData.Caption := FloatToStrF(fST2829C.DataVrms, ffGeneral, 5, 0)+' V';
 RelativeLocation(fBVrmsNeasuring,fLVrmsData,oCol,5);
end;

procedure TST2829CMeasureParamShow.rmsMeasuringClick(Sender: TObject);
begin
 if (Sender as TButton).Tag=1 then
   begin
    fST2829C.GetDataVrms();
    VrmsDataToLabel();
   end;
 if (Sender as TButton).Tag=2 then
   begin
    fST2829C.GetDataIrms();
    IrmsDataToLabel();
   end;
end;

procedure TST2829CMeasureParamShow.VMeasShowClick;
begin
 VMeasShow.ObjectToSetting;
 RelativeLocation(VMeasShow.LCaption,VMeasShow.STdata,oCol,3);
 AutoLevelShow.ObjectToSetting;
 VMeasShow.LCaption.Font.Color:=clRed;
 VMeasShow.STdata.Font.Color:=clRed;
 IMeasShow.LCaption.Font.Color:=clBlue;
 IMeasShow.STdata.Font.Color:=clBlue;

end;

procedure TST2829CMeasureParamShow.VrmsToMeasureClick;
begin
 fBVrmsNeasuring.Enabled:=VrmsToMeasureShow.CB.Checked;
end;

//destructor TST2829CMeasureParamShow.Destroy;
//begin
//  FreeAndNil(OutputImpedanceShow);
//  inherited;
//end;

{ TST2829CBiasParamShow }

procedure TST2829CBiasParamShow.BiasCurrentShowClick;
begin
 BiasCurrentShow.ObjectToSetting;
 RelativeLocation(BiasCurrentShow.LCaption,BiasCurrentShow.STdata,oCol,3);
 BiasCurrentShow.LCaption.Font.Color:=clRed;
 BiasCurrentShow.STdata.Font.Color:=clRed;
 BiasVoltageShow.LCaption.Font.Color:=clBlue;
 BiasVoltageShow.STdata.Font.Color:=clBlue;
end;

procedure TST2829CBiasParamShow.BiasOutPutFromDevice;
begin
  fSBOnOff.OnClick:=nil;
  fSBOnOff.Caption:=ST2829C_BiasOnOffButtonCaption[fST2829C.BiasEnable];
  fSBOnOff.Down:=fST2829C.BiasEnable;
  fSBOnOff.OnClick:=OnOffSpeedButtonClick;
end;

procedure TST2829CBiasParamShow.BiasVoltageShowClick;
begin
 BiasVoltageShow.ObjectToSetting;
 RelativeLocation(BiasVoltageShow.LCaption,BiasVoltageShow.STdata,oCol,3);
 BiasVoltageShow.LCaption.Font.Color:=clRed;
 BiasVoltageShow.STdata.Font.Color:=clRed;
 BiasCurrentShow.LCaption.Font.Color:=clBlue;
 BiasCurrentShow.STdata.Font.Color:=clBlue;
end;

procedure TST2829CBiasParamShow.CreateControls;
begin
 BiasCurrentShow:=TST2829C_BiasCurrentShow.Create(fST2829C);
 Add(BiasCurrentShow);
 BiasCurrentShow.HookParameterClick:=BiasCurrentShowClick;

 BiasVoltageShow:=TST2829C_BiasVoltageShow.Create(fST2829C);
 Add(BiasVoltageShow);
 BiasVoltageShow.HookParameterClick:=BiasVoltageShowClick;

 fSBOnOff.AllowAllUp:=True;
 fSBOnOff.GroupIndex:=3;
 fSBOnOff.OnClick:=OnOffSpeedButtonClick;
end;

procedure TST2829CBiasParamShow.CreateElements;
begin
 fSBOnOff:=TSpeedButton.Create(fParent);
 Add(fSBOnOff);
end;

procedure TST2829CBiasParamShow.DesignElements;
begin
  inherited DesignElements;
  fParent.Caption:='Bias option';

  BiasVoltageShow.LCaption.WordWrap:=False;
  BiasVoltageShow.LCaption.Top:=MarginTop;
  BiasVoltageShow.LCaption.Left:=10;
  RelativeLocation(BiasVoltageShow.LCaption,BiasVoltageShow.STdata,oCol,3);
  BiasVoltageShow.LCaption.Font.Color:=clRed;
  BiasVoltageShow.STdata.Font.Color:=clRed;

  BiasCurrentShow.LCaption.WordWrap:=False;
  RelativeLocation(BiasVoltageShow.LCaption,BiasCurrentShow.LCaption,oRow,8);
  RelativeLocation(BiasCurrentShow.LCaption,BiasCurrentShow.STdata,oCol,3);
  BiasCurrentShow.LCaption.Font.Color:=clBlue;
  BiasCurrentShow.STdata.Font.Color:=clBlue;

  fSBOnOff.Caption:='Bias Output';
  Resize(fSBOnOff);
  fSBOnOff.Left:=BiasVoltageShow.STdata.Left;
  fSBOnOff.Top:=BiasCurrentShow.STdata.Top+BiasCurrentShow.STdata.Height+3;

  fParent.Width:=BiasCurrentShow.LCaption.Left+BiasCurrentShow.LCaption.Width+10;
  fParent.Height:=fSBOnOff.Top+fSBOnOff.Height+10;

//    showmessage(inttostr(fParent.Height));
//  showmessage(inttostr(fParent.Width));
end;

procedure TST2829CBiasParamShow.ObjectToSetting;
begin
  inherited ObjectToSetting;
  BiasOutPutFromDevice()
end;

procedure TST2829CBiasParamShow.OnOffSpeedButtonClick(Sender: TObject);
begin
 fST2829C.SetBiasEnable(fSBOnOff.Down);
 fSBOnOff.Caption:=ST2829C_BiasOnOffButtonCaption[fSBOnOff.Down];
// fSourceShow.GetSourceValueShow.ColorToActive(fOutPutOnOff.Down);
end;

{ TST2829CSetupParamShow }

procedure TST2829CSetupParamShow.BTrigClick(Sender: TObject);
begin
 fST2829C.Trigger();
end;

procedure TST2829CSetupParamShow.CreateControls;
begin
 MeasureSpeedShow:=TST2829C_MeasureSpeedShow.Create(fST2829C);
 Add(MeasureSpeedShow);

 AverTimesShow:=TST2829C_AverTimesShow.Create(fST2829C);
 Add(AverTimesShow);

 RangeShow:=TST2829C_RangeShow.Create(fST2829C);
 Add(RangeShow);

 OutputImpedanceShow:=TST2829C_OutputImpedanceShow.Create(fST2829C);
 Add(OutputImpedanceShow);

 TrigerSourceShow:=TST2829C_TrigerSourceShow.Create(fST2829C);
 Add(TrigerSourceShow);


 DelayTimeShow:=TST2829C_DelayTimeShow.Create(fST2829C);
 Add(DelayTimeShow);

 fBTrig.OnClick:=BTrigClick;

end;

procedure TST2829CSetupParamShow.CreateElements;
begin
 fBTrig:=TButton.Create(fParent);
 Add(fBTrig);
end;

procedure TST2829CSetupParamShow.DesignElements;
begin
  inherited DesignElements;
  fParent.Caption:='Setup';

  MeasureSpeedShow.LCaption.Top:=MarginTop;
  MeasureSpeedShow.LCaption.Left:=10;
  RelativeLocation(MeasureSpeedShow.LCaption,MeasureSpeedShow.STdata,oCol,2);
  MeasureSpeedShow.STdata.Top:=MeasureSpeedShow.STdata.Top+2;

  AverTimesShow.LCaption.WordWrap:=False;
  RelativeLocation(MeasureSpeedShow.LCaption,AverTimesShow.LCaption,oRow,5);
  RelativeLocation(AverTimesShow.LCaption,AverTimesShow.STdata,oCol,2);
//  AverTimesShow.STdata.Top:=AverTimesShow.STdata.Top+2;
  AverTimesShow.LCaption.Font.Color:=clNavy;
  AverTimesShow.STdata.Font.Color:=clNavy;

  DelayTimeShow.LCaption.WordWrap:=False;
  RelativeLocation(AverTimesShow.LCaption,DelayTimeShow.LCaption,oRow,5);
  RelativeLocation(DelayTimeShow.LCaption,DelayTimeShow.STdata,oCol,2);
  DelayTimeShow.LCaption.Font.Color:=clPurple;
  DelayTimeShow.STdata.Font.Color:=clPurple;

  RangeShow.LCaption.Left:=35;
  RangeShow.LCaption.Top:=MeasureSpeedShow.STdata.Top+MeasureSpeedShow.STdata.Height+5;
  RelativeLocation(RangeShow.LCaption,RangeShow.STdata,oCol,2);
  RangeShow.LCaption.Font.Color:=clGreen;
  RangeShow.STdata.Font.Color:=clGreen;


  OutputImpedanceShow.LCaption.WordWrap:=False;
  RelativeLocation(RangeShow.LCaption,OutputImpedanceShow.LCaption,oRow,20);
  RelativeLocation(OutputImpedanceShow.LCaption,OutputImpedanceShow.STdata,oCol,2);
  OutputImpedanceShow.LCaption.Font.Color:=clOlive;
  OutputImpedanceShow.STdata.Font.Color:=clOlive;

  TrigerSourceShow.LCaption.WordWrap:=False;
  TrigerSourceShow.LCaption.Left:=10;
  TrigerSourceShow.LCaption.Top:=RangeShow.STdata.Top+RangeShow.STdata.Height+5;
  RelativeLocation(TrigerSourceShow.LCaption,TrigerSourceShow.STdata,oCol,2);
  TrigerSourceShow.LCaption.Font.Color:=clTeal;
  TrigerSourceShow.STdata.Font.Color:=clTeal;

  fBTrig.Caption:='TRIGGER';
  fBTrig.Top:=TrigerSourceShow.LCaption.Top+5;
  fBTrig.Left:=TrigerSourceShow.LCaption.Left+TrigerSourceShow.LCaption.Width+25;


  fParent.Height:=TrigerSourceShow.STdata.Top+TrigerSourceShow.STdata.Height+10;
  fParent.Width:=DelayTimeShow.LCaption.Left+ DelayTimeShow.LCaption.Width+10;

//  showmessage(inttostr(fParent.Height));
//  showmessage(inttostr(fParent.Width));

end;

{ TST2829C_MeterShow }

constructor TST2829C_MeterShow.Create(ST2829_MeterPrimary: TST2829_MeterPrimary;
             DL, UL: TLabel; MB: TButton; AB: TSpeedButton; DL2,UL2:TLabel);
begin
 inherited Create(ST2829_MeterPrimary,DL,UL,MB,AB,ST2829_MeterPrimary.Timer);
 fST2829_MeterPrimary:=ST2829_MeterPrimary;
 fDataLabel2:=DL2;
 fUnitLabel2:=UL2;
 DigitNumber:=6;
end;

procedure TST2829C_MeterShow.MetterDataShow;
begin
  inherited;
  if Meter.Value<>ErResult then
     begin
       fUnitLabel2.Caption:=fST2829_MeterPrimary.MeasureModeLabelTwo;
       fDataLabel2.Caption:=FloatToStrF(fST2829_MeterPrimary.ValueTwo,ffExponent,fDigitNumber,2)
     end
                        else
     begin
       fUnitLabel2.Caption:='';
       fDataLabel2.Caption:='    ERROR';
     end;
end;

function TST2829C_MeterShow.UnitModeLabel: string;
begin
 Result:=fST2829_MeterPrimary.MeasureModeLabel;
end;

end.
