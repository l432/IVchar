unit ST2829CShow;

interface

uses
  OlegTypePart2, ST2829C, StdCtrls, SCPIshow, ExtCtrls, ArduinoDeviceNew, 
  IniFiles, ST2829CParamShow, Buttons, Measurement, OlegShowTypes, Classes, 
  Controls;

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

 TST2829CElementParamWindow=class(TGBwithControlElementsAndParamAndWindowCreate)
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


//TST2829C_GroupBoxSpotTuning=class(TGroupBox)
TST2829C_GroupBoxSpotTun=class(TST2829CElementAndParamShow)
 {�� ��������� ������, �� ��� ���������� ��;
 � ������, � ���-���� ����������� � TGroupBox}
 private
//  fST2829C:TST2829C;
  fButton:TButton;
  fGB:TGroupBox;
 protected
  procedure DesignElements();override;
  procedure CreateElements;override;
  procedure CreateControls;override;
 public
  fActiveSpotShow:TST2829C_ActiveSpotShow;
  property Button:TButton read fButton;
  property GroupBox:TGroupBox read fGB;
// Constructor Create(ST2829C:TST2829C;
//                      GB: TGroupBox);
//  Constructor Create({AOwner: TComponent;}
//                     ST2829C:TST2829C;
//                     Parent:TWinControl);//reintroduce;
  destructor Destroy;override;
end;


 TST2829C_SpotParameterShow=class;


// TST2829CCorrectionShow=class(TST2829CElementAndParamShow)
 TST2829CCorrectionShow=class(TST2829CElementParamWindow)
  private
   fButton:TButton;
   procedure ButtonClick(Sender:TObject);
  protected
   procedure CreateElements;override;
   procedure CreateControls;override;
   procedure DesignElements;override;
//   procedure CreateForm();
//   procedure FormShow();
   function FormCaption():string;override;
   procedure GBcontentCreate(GB:TGroupBox);override;
  public
   OpenShow:TST2829C_OpenShow;
   ShortShow:TST2829C_ShortShow;
//   GroupBoxSpotTuning:TST2829C_GroupBoxSpotTuning;
   GroupBoxSpotTuning:TST2829C_GroupBoxSpotTun;
//   SpotParameterShow:TST2829C_SpotParameterShow;
   destructor Destroy;override;
//   procedure ObjectToSetting;override;
 end;

  TST2829C_SweepParameterShow=class;

  TST2829C_Show=class(TRS232DeviceNew_Show)
  private
   fST2829C:TST2829C;
   fSettingShow:TST2829CSetting_Show;
   fMeasureTypeShow:TST2829C_MeasureTypeShow;
   fMeasureParamShow:TST2829CMeasureParamShow;
   fBiasParamShow:TST2829CBiasParamShow;
   fSetupParamShow:TST2829CSetupParamShow;
   fMeterShow:TST2829C_MeterShow;
   fSweepParameterShow:TST2829C_SweepParameterShow;
   fCorrectionShow:TST2829CCorrectionShow;
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


//  TST2829C_SweepParameterShow=class(TGBwithControlElements)
  TST2829C_SweepParameterShow=class(TST2829CElement_Show)
   private
    fRGDataUsed:TRadioGroup;
//    fST2829C:TST2829C;
    fLType:TLabel;
    fSTType:TStaticText;
    fTypeShowSL:TStringList;
    fTypeShow:TStringParameterShow;
    fLStart:TLabel;
    fSTStart:TStaticText;
    fStartShow:TDoubleParameterShow;

    fLFinish:TLabel;
    fSTFinish:TStaticText;
    fFinishShow:TDoubleParameterShow;

    fLSteps:TLabel;
    fSTSteps:TStaticText;
    fStepsShow:TIntegerParameterShow;

    fCBLogStep:TCheckBox;

    procedure DestroyShows;
    procedure CreateShows;
   protected
    procedure CreateElements;override;
    procedure CreateControls;override;
//    procedure DestroyElements;
    procedure DestroyControls;override;
    procedure DesignElements;override;
    procedure DataUsedClick(Sender:TObject);
    procedure StartClick;
    procedure FinishClick;
    procedure StepClick;
    procedure LogStepClick(Sender:TObject);
   public
//    constructor Create(ST2829C:TST2829C;GB:TGroupBox);
  end;


  TST2829C_SpotParameterShow=class(TST2829CElementAndParamShow)
  private
   fSpotNumber:byte;
   fBOpenMeasure:TButton;
   fBShortMeasure:TButton;
//   procedure OnOffSpeedButtonClick(Sender: TObject);
  protected
   procedure CreateElements;override;
   procedure CreateControls;override;
   procedure DesignElements;override;
   procedure OpenMeasureClick(Sender:TObject);
   procedure ShortMeasureClick(Sender:TObject);
   procedure StateShowClick();
  public
   StateShow:TST2829C_SpotStateShow;
   FreqShow:TST2829C_SpotFreqShow;
   Constructor Create(ST2829C:TST2829C;
                      GB: TGroupBox;
                      SpotNumber:byte);
   procedure ObjectToSetting;override;
  end;

var
  ST2829C_Show:TST2829C_Show;

implementation

uses
  OApproxShow, ST2829CConst, SysUtils, RS232deviceNew, Dialogs, Graphics, OlegType,
  SCPI, OlegFunction;

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
 fMeasureTypeShow.STdata.Top:=140;
 fMeasureTypeShow.STdata.Left:=220;
 fMeasureTypeShow.STdata.Font.Name:='Verdana';
 fMeasureTypeShow.STdata.Font.Height:=-23;
 fMeasureTypeShow.STdata.Font.Color:=clFuchsia;
 fMeasureTypeShow.STdata.Font.Style:=[fsBold];

 fMeasureParamShow:=TST2829CMeasureParamShow.Create(fST2829C,GBs[2]);

 fBiasParamShow:=TST2829CBiasParamShow.Create(fST2829C,GBs[3]);

 fSetupParamShow:=TST2829CSetupParamShow.Create(fST2829C,GBs[4]);

 fMeterShow:=TST2829C_MeterShow.Create(fST2829C.MeterPrim,DL,UL,MB,AB,DL2,UL2);

 fSweepParameterShow:=TST2829C_SweepParameterShow.Create(fST2829C,GBs[5]);
 fCorrectionShow:=TST2829CCorrectionShow.Create(fST2829C,GBs[6]);

end;

//procedure TST2829C_Show.TestButtonClick(Sender: TObject);
//begin
//   if fST2829C.Test
//     then (Sender as TButton).Caption:='Connection Test - Ok'
//     else (Sender as TButton).Caption:='Connection Test - Failed';
//end;

destructor TST2829C_Show.Destroy;
begin
  FreeAndNil(fCorrectionShow);
  FreeAndNil(fSweepParameterShow);
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
//showmessage(fST2829C.SweepParameters.ToString);
 fST2829C.MyTraining();
end;

procedure TST2829C_Show.ObjectToSetting;
begin
 fMeasureTypeShow.ObjectToSetting;
 fMeasureParamShow.ObjectToSetting;
 fBiasParamShow.ObjectToSetting;
 fSetupParamShow.ObjectToSetting;
 fCorrectionShow.ObjectToSetting;
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

//     fST2829C.GetCorrectionCable();
     fST2829C.GetCorrectionOpenEnable();
     fST2829C.GetCorrectionShortEnable();
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
//  fSBOnOff.Left:=BiasCurrentShow.LCaption.Left+BiasCurrentShow.LCaption.Width+10;
//  fSBOnOff.Top:=BiasCurrentShow.LCaption.Top+15;
  fSBOnOff.Left:=BiasVoltageShow.LCaption.Left+10;
  fSBOnOff.Top:=BiasCurrentShow.STdata.Top+BiasCurrentShow.STdata.Height+5;

//  fParent.Width:=fSBOnOff.Left+fSBOnOff.Width+5;
//  fParent.Height:=BiasCurrentShow.STdata.Top+BiasCurrentShow.STdata.Height+5;
  fParent.Width:=BiasCurrentShow.LCaption.Left+BiasCurrentShow.LCaption.Width+5;
  fParent.Height:=fSBOnOff.Top+fSBOnOff.Height+5;

//  showmessage(inttostr(fParent.Height));
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
  inherited MetterDataShow;
//  if Meter.Value<>ErResult then
  if fST2829_MeterPrimary.ValueTwo<>ErResult then
     begin
       fUnitLabel2.Caption:=fST2829_MeterPrimary.MeasureModeLabelTwo;
       fDataLabel2.Caption:=FloatToStrF(fST2829_MeterPrimary.ValueTwo,ffExponent,fDigitNumber,2)
     end
                        else
     begin
       fUnitLabel2.Caption:='---';
       fDataLabel2.Caption:='---';
     end;
end;

function TST2829C_MeterShow.UnitModeLabel: string;
begin
 Result:=fST2829_MeterPrimary.MeasureModeLabel;
end;

{ TST2829C_SweepParameterShow }

//constructor TST2829C_SweepParameterShow.Create(ST2829C:TST2829C;
//  GB: TGroupBox);
//begin
// fST2829C:=ST2829C;
// inherited Create(GB);
//end;

procedure TST2829C_SweepParameterShow.CreateShows;
begin
  fST2829C.SweepParameters.SweepType := TST2829C_SweepParametr(fTypeShow.Data);

  DestroyShows();

  case TST2829C_SweepParametr(fTypeShow.Data) of
    st_spBiasVolt:
      begin
        fStartShow := TDoubleParameterShow.Create(fSTStart, fLStart, 'Start Vbias, V:', 0, 5);
        fStartShow.Limits.SetLimits(ST2829C_BiasVoltageLimits[lvMin], ST2829C_BiasVoltageLimits[lvMax]);
        fFinishShow := TDoubleParameterShow.Create(fSTFinish, fLFinish, 'Finish Vbias, V:', 1, 5);
        fFinishShow.Limits.SetLimits(ST2829C_BiasVoltageLimits[lvMin], ST2829C_BiasVoltageLimits[lvMax]);
      end;
    st_spBiasCurr:
      begin
        fStartShow := TDoubleParameterShow.Create(fSTStart, fLStart, 'Start Ibias, mA:', 0, 5);
        fStartShow.Limits.SetLimits(ST2829C_BiasCurrentLimits[lvMin], ST2829C_BiasCurrentLimits[lvMax]);
        fFinishShow := TDoubleParameterShow.Create(fSTFinish, fLFinish, 'Finish Ibias, mA:', 10, 5);
        fFinishShow.Limits.SetLimits(ST2829C_BiasCurrentLimits[lvMin], ST2829C_BiasCurrentLimits[lvMax]);
      end;
    st_spFreq:
      begin
        fStartShow := TDoubleParameterShow.Create(fSTStart, fLStart, 'Start Freq, Hz:', 20, 7);
        fStartShow.Limits.SetLimits(ST2829C_FreqMeasLimits[lvMin], ST2829C_FreqMeasLimits[lvMax]);
        fFinishShow := TDoubleParameterShow.Create(fSTFinish, fLFinish, 'Finish Freq, Hz:', 10000, 7);
        fFinishShow.Limits.SetLimits(ST2829C_FreqMeasLimits[lvMin], ST2829C_FreqMeasLimits[lvMax]);
      end;
    st_spVrms:
      begin
        fStartShow := TDoubleParameterShow.Create(fSTStart, fLStart, 'Start Vrms, V:', 0.01, 5);
        fStartShow.Limits.SetLimits(ST2829C_VrmsMeasLimits[lvMin], ST2829C_VrmsMeasLimits[lvMax]);
        fFinishShow := TDoubleParameterShow.Create(fSTFinish, fLFinish, 'Finish Vrms, V:', 1, 5);
        fFinishShow.Limits.SetLimits(ST2829C_VrmsMeasLimits[lvMin], ST2829C_VrmsMeasLimits[lvMax]);
      end;
    st_spIrms:
      begin
        fStartShow := TDoubleParameterShow.Create(fSTStart, fLStart, 'Start Irms, mA:', 0.1, 5);
        fStartShow.Limits.SetLimits(ST2829C_IrmsMeasLimits[lvMin], ST2829C_IrmsMeasLimits[lvMax]);
        fFinishShow := TDoubleParameterShow.Create(fSTFinish, fLFinish, 'Finish Irms, mA:', 10, 5);
        fFinishShow.Limits.SetLimits(ST2829C_IrmsMeasLimits[lvMin], ST2829C_IrmsMeasLimits[lvMax]);
      end;
  end;
  fStartShow.ForUseInShowObject(fST2829C, False);
  fStartShow.ReadFromIniFile(CF_ST_2829C);
  fStartShow.HookParameterClick := StartClick;
  StartClick;

  fFinishShow.ForUseInShowObject(fST2829C, False);
  fFinishShow.ReadFromIniFile(CF_ST_2829C);
  fFinishShow.HookParameterClick := FinishClick;
  FinishClick;

  fStepsShow:=TIntegerParameterShow.Create(fSTSteps,fLSteps,'Step Count:',2);
//  fStepsShow.SetName(fST2829C.Name);
  fStepsShow.Limits.SetLimits(2, 5000);
  fStepsShow.IniNameSalt:=ST2829C_SweepParametrSalt[TST2829C_SweepParametr(fTypeShow.Data)];
//  fStepsShow.ReadFromIniFile(CF_ST_2829C);
  fStepsShow.Data:=CF_ST_2829C.ReadInteger(fST2829C.Name,fStepsShow.ParametrCaption+fStepsShow.IniNameSalt,2);
   {�������� ������ ����� � ������, �� ���� �� ��������
   �� ����� �� ���������� fStepsShow.SetName,
   �� fStepsShow.ForUseInShowObject}

  fStepsShow.HookParameterClick := StepClick;
  StepClick;

  fCBLogStep.Name:='LogStep'+ST2829C_SweepParametrSalt[TST2829C_SweepParametr(fTypeShow.Data)];
//  AccurateCheckBoxCheckedChange(fCBLogStep,
//   CF_ST_2829C.ReadBool(fST2829C.Name,fCBLogStep.Name,False));

  fCBLogStep.Checked:=
   CF_ST_2829C.ReadBool(fST2829C.Name,fCBLogStep.Name,False);
end;

procedure TST2829C_SweepParameterShow.DestroyShows;
begin

  if (fCBLogStep <> nil)and(fCBLogStep.Name<>'') then
   CF_ST_2829C.WriteBool(fST2829C.Name,fCBLogStep.Name,fCBLogStep.Checked);

  if fStartShow <> nil then
  begin
    CF_ST_2829C.WriteFloat(fStartShow.Name,fStartShow.ParametrCaption+fStartShow.IniNameSalt,fStartShow.Data);
//    fStartShow.WriteToIniFile(CF_ST_2829C);
    FreeAndNil(fStartShow);
  end;
  if fFinishShow <> nil then
  begin
    CF_ST_2829C.WriteFloat(fFinishShow.Name,fFinishShow.ParametrCaption+fFinishShow.IniNameSalt,fFinishShow.Data);
//    fFinishShow.WriteToIniFile(CF_ST_2829C);
    FreeAndNil(fFinishShow);
  end;
  if fStepsShow <> nil then
  begin
    CF_ST_2829C.WriteInteger(fST2829C.Name,fStepsShow.ParametrCaption+fStepsShow.IniNameSalt,fStepsShow.Data);
//    fStepsShow.WriteToIniFile(CF_ST_2829C);
    FreeAndNil(fStepsShow);
  end;
end;

procedure TST2829C_SweepParameterShow.FinishClick;
begin
 fLFinish.WordWrap:=False;
 RelativeLocation(fLFinish,fSTFinish,oCol,2);
 fST2829C.SweepParameters.FinishValue:=fFinishShow.Data;
end;

procedure TST2829C_SweepParameterShow.LogStepClick(Sender: TObject);
begin
 fST2829C.SweepParameters.LogStep:=fCBLogStep.Checked;
end;

procedure TST2829C_SweepParameterShow.CreateControls;
 var i:integer;
begin
 fRGDataUsed.Items.Add('Primary');
 fRGDataUsed.Items.Add('Secondary');
 fRGDataUsed.Items.Add('Both');
 fRGDataUsed.ItemIndex:=
   CF_ST_2829C.ReadInteger(fST2829C.Name,'Data used',0);
 fRGDataUsed.OnClick:=DataUsedClick;
 DataUsedClick(nil);

 fTypeShowSL:=TStringList.Create;
 for I := 0 to ord(High(TST2829C_SweepParametr)) do
    fTypeShowSL.Add(ST2829C_SweepParametrLabels[TST2829C_SweepParametr(i)]);
 fTypeShow:=TStringParameterShow.Create(fSTType,fLType,'Parameter to change:',fTypeShowSL);
 fTypeShow.ForUseInShowObject(fST2829C,False);
 fTypeShow.ReadFromIniFile(CF_ST_2829C);
 fTypeShow.HookParameterClick:=CreateShows;

 fCBLogStep.OnClick:=LogStepClick;

 CreateShows;

end;

procedure TST2829C_SweepParameterShow.CreateElements;
begin
  fLType:=TLabel.Create(fParent);
  Add(fLType);
  fSTType:=TStaticText.Create(fParent);
  Add(fSTType);

  fRGDataUsed:=TRadioGroup.Create(fParent);
  Add(fRGDataUsed);

  fLStart:=TLabel.Create(fParent);
  Add(fLStart);
  fSTStart:=TStaticText.Create(fParent);
  Add(fSTStart);

  fLSteps:=TLabel.Create(fParent);
  Add(fLSteps);
  fSTSteps:=TStaticText.Create(fParent);
  Add(fSTSteps);

  fLFinish:=TLabel.Create(fParent);
  Add(fLFinish);
  fSTFinish:=TStaticText.Create(fParent);
  Add(fSTFinish);

  fCBLogStep:=TCheckBox.Create(fParent);;
  Add(fCBLogStep);
  inherited CreateElements;
end;

procedure TST2829C_SweepParameterShow.DataUsedClick(Sender: TObject);
begin
 fST2829C.SweepParameters.DataType:=TST2829C_SweepData(fRGDataUsed.ItemIndex);
end;

procedure TST2829C_SweepParameterShow.DesignElements;
begin
 fParent.Caption:='Sweep tuning';

 fLType.WordWrap:=False;
 fLType.Left:=MarginLeft;
 fLType.Top:=MarginTop;
 RelativeLocation(fLType,fSTType,oRow,5);
 fSTType.Top:=fSTType.Top+2;

 fRGDataUsed.Caption:='Data used';
 fRGDataUsed.Columns:=3;
 Resize(fRGDataUsed);
 fRGDataUsed.Width:=round(1.5*fRGDataUsed.Width);
 fRGDataUsed.Left:=10;
 fRGDataUsed.Top:=fLType.Top+fLType.Height+5;

 fLStart.WordWrap:=False;
 fLStart.Left:=MarginLeft;
 fLStart.Top:=fRGDataUsed.Top+fRGDataUsed.Height+5;
 RelativeLocation(fLStart,fSTStart,oCol,2);
 fLStart.Font.Color:=clBlue;
 fSTStart.Font.Color:=clBlue;

 fLFinish.WordWrap:=False;
// RelativeLocation(fLStart,fLFinish,oRow,8);
 fLFinish.Left:=fLStart.Left+fLStart.Width+15;
 fLFinish.Top:=fLStart.Top;
 RelativeLocation(fLFinish,fSTFinish,oCol,2);
 fLFinish.Font.Color:=clNavy;
 fSTFinish.Font.Color:=clNavy;

 fLSteps.WordWrap:=False;
 fLSteps.Left:=MarginLeft;
 fLSteps.Top:=fSTStart.Top+fSTStart.Height+5;
 fSTSteps.Top:=fLSteps.Top;
 fSTSteps.Left:=fLSteps.Left+fLSteps.Width+5;
 fLSteps.Font.Color:=clGreen;
 fSTSteps.Font.Color:=clGreen;

 fCBLogStep.Caption:='Log step';
 fCBLogStep.Top:=fLSteps.Top;
 fCBLogStep.Left:=fSTSteps.Left+fSTSteps.Width+25;

 fParent.Width:=fRGDataUsed.Left+fRGDataUsed.Width+5;
 fParent.Height:=fLSteps.Top+fLSteps.Height+MarginTop;

//  showmessage(inttostr(fParent.Height));
//  showmessage(inttostr(fParent.Width));
end;

procedure TST2829C_SweepParameterShow.DestroyControls;
begin

 DestroyShows;

 CF_ST_2829C.WriteInteger(fST2829C.Name,'Data used',
                  fRGDataUsed.ItemIndex);

 fTypeShow.WriteToIniFile(CF_ST_2829C);
 FreeAndNil(fTypeShow);
 FreeAndNil(fTypeShowSL);
end;

procedure TST2829C_SweepParameterShow.StartClick;
begin
 fLStart.WordWrap:=False;
 RelativeLocation(fLStart,fSTStart,oCol,2);
 fST2829C.SweepParameters.StartValue:=fStartShow.Data;
end;

procedure TST2829C_SweepParameterShow.StepClick;
begin
// fLSteps.WordWrap:=False;
 fST2829C.SweepParameters.PointCount:=fStepsShow.Data;
end;

{ TST2829CCorrectionShow }

procedure TST2829CCorrectionShow.ButtonClick(Sender: TObject);
 var //Response: Integer;
     SpotNumber,CurrentSpotNumber:byte;
     mess:string;
begin
//  Response := MessageDlg('Are you sure?', mtConfirmation, [mbYes, mbNo], 0);

  if YesClicked('Are you sure?') then
    begin
     mess:='';
     CurrentSpotNumber:=fST2829C.Corrections.SpotActiveNumber;
     for SpotNumber := round(ST2829C_SpotNumber[lvMin]) to round(ST2829C_SpotNumber[lvMax]) do
//     for SpotNumber := round(ST2829C_SpotNumber[lvMin]) to 3 do
      begin
        if (fST2829C.GetCorrectionSpotState(SpotNumber))
           and (fST2829C.Corrections.fSpotActiveState)
           then
           begin
            fST2829C.GetCorrectionSpotFreq(SpotNumber);
            mess:=mess+inttostr(SpotNumber)
               +' ('+floattostr(fST2829C.Corrections.SpotActiveFreq)
               +' Hz)'+#10#13;
           end;
      end;
     if mess='' then showmessage('No used spot')
                else Showmessage('The used spots:'+#10#13+mess);
     fST2829C.Corrections.SpotActiveNumber:=CurrentSpotNumber;
    end;

end;

procedure TST2829CCorrectionShow.CreateControls;
begin
  OpenShow:=TST2829C_OpenShow.Create(fST2829C,fParent);
  Add(OpenShow);
//
  ShortShow:=TST2829C_ShortShow.Create(fST2829C,fParent);
  Add(ShortShow);

  fButton.OnClick:=ButtonClick;
  GroupBoxSpotTuning.Button.OnClick:=FormShow;
end;

procedure TST2829CCorrectionShow.CreateElements;
begin
//  inherited CreateElements;

// GroupBoxSpotTuning:=TST2829C_GroupBoxSpotTuning.Create({nil,}fST2829C,fParent);
 GroupBoxSpotTuning:=TST2829C_GroupBoxSpotTun.Create(fST2829C,fParent);

 fButton:=TButton.Create(fParent);
 Add(fButton);
end;


procedure TST2829CCorrectionShow.DesignElements;
begin
  inherited DesignElements;
  fParent.Caption:='Corrections';

  OpenShow.GroupBox.Left:=15;
  OpenShow.GroupBox.Top:=15;

  RelativeLocation(OpenShow.GroupBox,ShortShow.GroupBox,oCol,3);

//  GroupBoxSpotTuning.Left:=5;
//  GroupBoxSpotTuning.Top:=ShortShow.GroupBox.Top+ShortShow.GroupBox.Height+5;
  GroupBoxSpotTuning.GroupBox.Left:=5;
  GroupBoxSpotTuning.GroupBox.Top:=ShortShow.GroupBox.Top+ShortShow.GroupBox.Height+5;


  fButton.Caption:='Show used spots';
  Resize(fButton);
  fButton.Left:=25;
//  fButton.Top:=GroupBoxSpotTuning.Top+GroupBoxSpotTuning.Height+10;
  fButton.Top:=GroupBoxSpotTuning.GroupBox.Top+GroupBoxSpotTuning.GroupBox.Height+10;

//  fParent.Width:=GroupBoxSpotTuning.Left+GroupBoxSpotTuning.Width+5;
  fParent.Width:=GroupBoxSpotTuning.GroupBox.Left+GroupBoxSpotTuning.GroupBox.Width+5;
  fParent.Height:=fButton.Top+fButton.Height+10;

//  showmessage(inttostr(fParent.Height));
//  showmessage(inttostr(fParent.Width));

end;

destructor TST2829CCorrectionShow.Destroy;
begin
  FreeAndNil(GroupBoxSpotTuning);
  inherited Destroy;
end;


function TST2829CCorrectionShow.FormCaption: string;
begin
 Result:='Parameters of spon number '+inttostr(GroupBoxSpotTuning.fActiveSpotShow.Data);
end;

procedure TST2829CCorrectionShow.GBcontentCreate(GB: TGroupBox);
begin
 GBcontent:=TST2829C_SpotParameterShow.Create(fST2829C,GB,GroupBoxSpotTuning.fActiveSpotShow.Data);
end;

{ TST2829CElementParamWindow }

constructor TST2829CElementParamWindow.Create(ST2829C: TST2829C;
                      GB: TGroupBox);
begin
 fST2829C:=ST2829C;
 inherited Create(GB);
end;

{ TST2829C_SpotParameterShow }

constructor TST2829C_SpotParameterShow.Create(ST2829C: TST2829C; GB: TGroupBox;
  SpotNumber: byte);
begin
 fSpotNumber:=SpotNumber;
 inherited Create(ST2829C,GB);
end;

procedure TST2829C_SpotParameterShow.CreateControls;
begin
 StateShow:=TST2829C_SpotStateShow.Create(fST2829C,fSpotNumber);
 Add(StateShow);
 StateShow.HookParameterClick:=StateShowClick;
 FreqShow:=TST2829C_SpotFreqShow.Create(fST2829C,fSpotNumber);
 Add(FreqShow);
 fBOpenMeasure.OnClick:=OpenMeasureClick;
 fBShortMeasure.OnClick:=ShortMeasureClick;
end;

procedure TST2829C_SpotParameterShow.CreateElements;
begin
  fBOpenMeasure:=TButton.Create(nil);
  Add(fBOpenMeasure);
  fBShortMeasure:=TButton.Create(nil);
  Add(fBShortMeasure);
end;

procedure TST2829C_SpotParameterShow.DesignElements;
begin
 inherited DesignElements;

 StateShow.CB.Left:=MarginLeft;
 StateShow.CB.Top:=MarginTop;

 FreqShow.LCaption.WordWrap:=False;
// FreqShow.LCaption.Left:=MarginLeft;
// FreqShow.LCaption.Top:=StateShow.CB.Top+StateShow.CB.Height+10;
 FreqShow.LCaption.Left:=StateShow.CB.Left+StateShow.CB.Width+5;
 FreqShow.LCaption.Top:=StateShow.CB.Top;
 RelativeLocation(FreqShow.LCaption,FreqShow.STdata,oRow,3);
 FreqShow.STdata.Top:=FreqShow.STdata.Top+2;

 fBOpenMeasure.Caption:='to measure open';
 Resize(fBOpenMeasure);
 fBOpenMeasure.Left:=MarginLeft;
 fBOpenMeasure.Top:=FreqShow.LCaption.Top+FreqShow.LCaption.Height+10;

 fBShortMeasure.Caption:='to measure short';
 Resize(fBShortMeasure);
 RelativeLocation(fBOpenMeasure,fBShortMeasure,oRow,5);

 fParent.Width:=fBShortMeasure.Left+fBShortMeasure.Width+MarginLeft;
 fParent.Height:=fBShortMeasure.Top+fBShortMeasure.Height+MarginTop;

end;

procedure TST2829C_SpotParameterShow.ObjectToSetting;
begin
  inherited ObjectToSetting;
  StateShowClick;
end;

procedure TST2829C_SpotParameterShow.OpenMeasureClick(Sender: TObject);
begin
  if YesClicked('Correction coefficient in open-circut will be mesured. Continue?')
    then fST2829C.SetCorrectionSpotOpen(fSpotNumber);
end;

procedure TST2829C_SpotParameterShow.ShortMeasureClick(Sender: TObject);
begin
  if YesClicked('Correction coefficient in short-circut will be mesured. Continue?')
    then fST2829C.SetCorrectionSpotShort(fSpotNumber);
end;

procedure TST2829C_SpotParameterShow.StateShowClick;
begin
  FreqShow.STdata.Enabled:=StateShow.CB.Checked;
end;

{ TST2829C_GroupBoxSpotTun }

//constructor TST2829C_GroupBoxSpotTun.Create(ST2829C: TST2829C; GB: TGroupBox);
//begin
//
//end;

procedure TST2829C_GroupBoxSpotTun.CreateControls;
begin

  fActiveSpotShow:=TST2829C_ActiveSpotShow.Create(fST2829C);
//  Add(fActiveSpotShow);
  fActiveSpotShow.ParentToElements(fGB);

end;

procedure TST2829C_GroupBoxSpotTun.CreateElements;
begin




  fGB:=TGroupBox.Create(fParent);
//  fGB.Parent:=fParent;
  add(fGB);

  fButton:=TButton.Create(fGB);
//  Add(fButton);

  fButton.Parent:=fGB;


//  fActiveSpotShow:=TST2829C_ActiveSpotShow.Create(fST2829C);
//  fActiveSpotShow.ParentToElements(fGB);

end;

procedure TST2829C_GroupBoxSpotTun.DesignElements;
begin
  inherited DesignElements;
//fGB.Parent:=fParent;
  fGB.Caption:='Spot control';
  fButton.Caption:='Tuning';
  fActiveSpotShow.LCaption.Left:=5;
  fActiveSpotShow.LCaption.Top:=15;
  RelativeLocation(fActiveSpotShow.LCaption,fActiveSpotShow.STdata,oRow,3);
  RelativeLocation(fActiveSpotShow.STdata,fButton,oRow,10);
  fGB.Height:=fButton.Top+fButton.Height+5;
  fGB.Width:=fButton.Left+fButton.Width+5;
end;


destructor TST2829C_GroupBoxSpotTun.Destroy;
begin
//  fGB.Parent:=nil;
  fButton.Parent:=nil;
  fButton.Free;
  fActiveSpotShow.ParentToElements(nil);
  fActiveSpotShow.Free;
//  fGB.Free;
  inherited;
end;

//destructor TST2829C_GroupBoxSpotTun.Destroy;
//begin
//
//  inherited Destroy;
//end;

end.
