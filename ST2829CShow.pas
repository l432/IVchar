unit ST2829CShow;

interface

uses
  OlegTypePart2, ST2829C, StdCtrls, SCPIshow, ExtCtrls, ArduinoDeviceNew, 
  IniFiles, ST2829CParamShow;

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
  protected
   procedure CreateElements;override;
   procedure CreateControls;override;
   procedure DesignElements;override;
  public
   OutputImpedanceShow:TST2829C_OutputImpedanceShow;
   AutoLevelShow:TST2829C_AutoLevelShow;
   BiasEnableShow:TST2829C_BiasEnableShow;
   FreqMeasShow:TST2829C_FreqMeasShow;
   VMeasShow:TST2829C_VMeasShow;
   IMeasShow:TST2829C_IMeasShow;
   BiasVoltageShow:TST2829C_BiasVoltageShow;
   BiasCurrentShow:TST2829C_BiasCurrentShow;
   RangeShow:TST2829C_RangeShow;
   MeasureSpeedShow:TST2829C_MeasureSpeedShow;
   AverTimesShow:TST2829C_AverTimesShow;
   VrmsToMeasureShow:TST2829C_VrmsToMeasureShow;
   IrmsToMeasureShow:TST2829C_IrmsToMeasureShow;
   TrigerSourceShow:TST2829C_TrigerSourceShow;
   DelayTimeShow:TST2829C_DelayTimeShow;
//   destructor Destroy;override;
 end;


//  TST2829C_Show=class(TSimpleFreeAndAiniObject)
  TST2829C_Show=class(TRS232DeviceNew_Show)
  private
   fST2829C:TST2829C;
   fSettingShow:TST2829CSetting_Show;
//   fSetupMemoryShow:TKeitley_SetupMemoryShow;
//   fBrightnessShow:TKeitley_BrightnessShow;
//   procedure TestButtonClick(Sender:TObject);
   fMeasureTypeShow:TST2829C_MeasureTypeShow;
   fMeasureParamShow:TST2829CMeasureParamShow;
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
  OApproxShow, ST2829CConst, SysUtils, RS232deviceNew, Dialogs, Graphics;

{ TST2829C_Show }

//constructor TST2829C_Show.Create(ST2829C: TST2829C; ButTest: TButton);
constructor TST2829C_Show.Create(ST2829C:TST2829C;
                     GBs: array of TGroupBox;
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

end;

//procedure TST2829C_Show.TestButtonClick(Sender: TObject);
//begin
//   if fST2829C.Test
//     then (Sender as TButton).Caption:='Connection Test - Ok'
//     else (Sender as TButton).Caption:='Connection Test - Failed';
//end;

destructor TST2829C_Show.Destroy;
begin
  FreeAndNil(fMeasureParamShow);
  FreeAndNil(fMeasureTypeShow);
  FreeAndNil(fSettingShow);
  inherited;
end;

procedure TST2829C_Show.MyTrainButtonClick(Sender: TObject);
begin
 fST2829C.MyTraining();
end;

procedure TST2829C_Show.ObjectToSetting;
begin
 fMeasureTypeShow.ObjectToSetting;
 fMeasureParamShow.ObjectToSetting;
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
// OutputImpedanceShow:=TST2829C_OutputImpedanceShow.Create(fST2829C);
// Add(OutputImpedanceShow);

// AutoLevelShow:=TST2829C_AutoLevelShow.Create(fST2829C);
// Add(AutoLevelShow);

// BiasEnableShow:=TST2829C_BiasEnableShow.Create(fST2829C);
// Add(BiasEnableShow);

// FreqMeasShow:=TST2829C_FreqMeasShow.Create(fST2829C);
// Add(FreqMeasShow);

// VMeasShow:=TST2829C_VMeasShow.Create(fST2829C);;
// Add(VMeasShow);
//// VMeasShow.HookParameterClick:=

// IMeasShow:=TST2829C_IMeasShow.Create(fST2829C);
// Add(IMeasShow);
//// IMeasShow.HookParameterClick:=

// BiasVoltageShow:=TST2829C_BiasVoltageShow.Create(fST2829C);
// Add(BiasVoltageShow);

// RangeShow:=TST2829C_RangeShow.Create(fST2829C);
// Add(RangeShow);

// MeasureSpeedShow:=TST2829C_MeasureSpeedShow.Create(fST2829C);
// Add(MeasureSpeedShow);

// AverTimesShow:=TST2829C_AverTimesShow.Create(fST2829C);
// Add(AverTimesShow);

// VrmsToMeasureShow:=TST2829C_VrmsToMeasureShow.Create(fST2829C);
// Add(VrmsToMeasureShow);


// IrmsToMeasureShow:=TST2829C_IrmsToMeasureShow.Create(fST2829C);
// Add(IrmsToMeasureShow);

// BiasCurrentShow:=TST2829C_BiasCurrentShow.Create(fST2829C);
// Add(BiasCurrentShow);

// TrigerSourceShow:=TST2829C_TrigerSourceShow.Create(fST2829C);
// Add(TrigerSourceShow);


 DelayTimeShow:=TST2829C_DelayTimeShow.Create(fST2829C);
 Add(DelayTimeShow);


end;

procedure TST2829CMeasureParamShow.CreateElements;
begin

end;

procedure TST2829CMeasureParamShow.DesignElements;
begin
  inherited DesignElements;
  fParent.Caption:='Measure option';

//  OutputImpedanceShow.LCaption.WordWrap:=False;
//  OutputImpedanceShow.LCaption.Top:=MarginTop;
//  OutputImpedanceShow.LCaption.Left:=MarginLeft;
//  RelativeLocation(OutputImpedanceShow.LCaption,OutputImpedanceShow.STdata,oRow,Marginbetween);

//  AutoLevelShow.CB.Top:=MarginTop;
//  AutoLevelShow.CB.Left:=MarginLeft;
//  Resize(AutoLevelShow.CB);

//  BiasEnableShow.CB.Top:=MarginTop;
//  BiasEnableShow.CB.Left:=MarginLeft;

//  FreqMeasShow.LCaption.WordWrap:=False;
//  FreqMeasShow.LCaption.Top:=MarginTop;
//  FreqMeasShow.LCaption.Left:=MarginLeft;
//  RelativeLocation(FreqMeasShow.LCaption,FreqMeasShow.STdata,oRow,3);
//  FreqMeasShow.STdata.Top:=FreqMeasShow.STdata.Top+2;

//  VMeasShow.LCaption.WordWrap:=False;
//  VMeasShow.LCaption.Top:=MarginTop;
//  VMeasShow.LCaption.Left:=MarginLeft;
//  RelativeLocation(VMeasShow.LCaption,VMeasShow.STdata,oRow,3);
//  VMeasShow.STdata.Top:=VMeasShow.STdata.Top+2;

//  IMeasShow.LCaption.WordWrap:=False;
//  IMeasShow.LCaption.Top:=MarginTop;
//  IMeasShow.LCaption.Left:=MarginLeft;
//  RelativeLocation(IMeasShow.LCaption,IMeasShow.STdata,oRow,3);
//  IMeasShow.STdata.Top:=IMeasShow.STdata.Top+2;

//  BiasVoltageShow.LCaption.WordWrap:=False;
//  BiasVoltageShow.LCaption.Top:=MarginTop;
//  BiasVoltageShow.LCaption.Left:=MarginLeft;
//  RelativeLocation(BiasVoltageShow.LCaption,BiasVoltageShow.STdata,oRow,3);
//  BiasVoltageShow.STdata.Top:=BiasVoltageShow.STdata.Top+2;

//  RangeShow.LCaption.Top:=MarginTop;
//  RangeShow.LCaption.Left:=MarginLeft;
//  RelativeLocation(RangeShow.LCaption,RangeShow.STdata,oRow,3);
//  RangeShow.STdata.Top:=RangeShow.STdata.Top+2;

//  MeasureSpeedShow.LCaption.Top:=MarginTop;
//  MeasureSpeedShow.LCaption.Left:=MarginLeft;
//  RelativeLocation(MeasureSpeedShow.LCaption,MeasureSpeedShow.STdata,oRow,3);
//  MeasureSpeedShow.STdata.Top:=MeasureSpeedShow.STdata.Top+2;

//  AverTimesShow.LCaption.Top:=MarginTop;
//  AverTimesShow.LCaption.Left:=MarginLeft;
//  RelativeLocation(AverTimesShow.LCaption,AverTimesShow.STdata,oRow,3);
////  AverTimesShow.STdata.Top:=AverTimesShow.STdata.Top+2;

//  VrmsToMeasureShow.CB.Top:=MarginTop;
//  VrmsToMeasureShow.CB.Left:=MarginLeft;
//  Resize(VrmsToMeasureShow.CB);

//  IrmsToMeasureShow.CB.Top:=MarginTop;
//  IrmsToMeasureShow.CB.Left:=MarginLeft;
//  Resize(IrmsToMeasureShow.CB);

//  BiasCurrentShow.LCaption.WordWrap:=False;
//  BiasCurrentShow.LCaption.Top:=MarginTop;
//  BiasCurrentShow.LCaption.Left:=MarginLeft;
//  RelativeLocation(BiasCurrentShow.LCaption,BiasCurrentShow.STdata,oRow,3);
//  BiasCurrentShow.STdata.Top:=BiasCurrentShow.STdata.Top+2;

//  TrigerSourceShow.LCaption.WordWrap:=False;
//  TrigerSourceShow.LCaption.Top:=MarginTop;
//  TrigerSourceShow.LCaption.Left:=MarginLeft;
//  RelativeLocation(TrigerSourceShow.LCaption,TrigerSourceShow.STdata,oRow,3);
//  TrigerSourceShow.STdata.Top:=TrigerSourceShow.STdata.Top+2;

  DelayTimeShow.LCaption.WordWrap:=False;
  DelayTimeShow.LCaption.Top:=MarginTop;
  DelayTimeShow.LCaption.Left:=MarginLeft;
  RelativeLocation(DelayTimeShow.LCaption,DelayTimeShow.STdata,oRow,3);
  DelayTimeShow.STdata.Top:=DelayTimeShow.STdata.Top+2;

end;

//destructor TST2829CMeasureParamShow.Destroy;
//begin
//  FreeAndNil(OutputImpedanceShow);
//  inherited;
//end;

end.
