unit ST2829CParamShow;

interface

uses
  SCPIshow, ST2829C, StdCtrls, Controls, Classes;

type

TST2829C_DoubleParameterShow=class(TSCPI_DoubleParameterShow)
 private
 protected
  function FuncForObjectToSetting:double;override;
 public
end;

TST2829C_IntegerParameterShow=class(TSCPI_IntegerParameterShow)
 private
 protected
  function FuncForObjectToSetting:integer;override;
 public
end;

TST2829C_BoolParameterShow=class(TSCPI_BoolParameterShow)
 private
 protected
  function FuncForObjectToSetting:boolean;override;
 public
end;

TST2829C_BoolParameterAndButtonShow=class(TST2829C_BoolParameterShow)
 {ще додаткова кнопка, на яку чіпляється дія;
 і кнопка, і чек-бокс розміщуються у TGroupBox}
 private
  fButton:TButton;
  fGB:TGroupBox;
  fLabel:Tlabel;
 protected
  procedure DesignElements();
  procedure ClickButton(Sender:TObject);
  procedure RealAction();virtual;abstract;
 public
  property Button:TButton read fButton;
  property GroupBox:TGroupBox read fGB;
  Constructor Create(ST2829C:TST2829C;ActionType:Pointer;
                     ParametrCaption: string; ButtonCaption:string;
                     GroupBoxCaption:string;
                     Parent:TWinControl);
  destructor Destroy;override;
  procedure ParentToElements(Parent:TWinControl);override;
end;

TST2829C_StringParameterShow=class(TSCPI_StringParameterShow)
 private
 protected
  function HighForSLFilling:byte;override;
  function StrForSLFilling(i:byte):string;override;
  function FuncForObjectToSetting:byte;override;
 public
end;

//---------------------------------------------------------

TST2829C_OutputImpedanceShow=class(TST2829C_StringParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;


TST2829C_MeasureTypeShow=class(TST2829C_StringParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_RangeShow=class(TST2829C_StringParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_MeasureSpeedShow=class(TST2829C_StringParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_TrigerSourceShow=class(TST2829C_StringParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_CorrectionCabelShow=class(TST2829C_StringParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

//------------------------------------------------------------------

TST2829C_AutoLevelShow=class(TST2829C_BoolParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_BiasEnableShow=class(TST2829C_BoolParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_VrmsToMeasureShow=class(TST2829C_BoolParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_IrmsToMeasureShow=class(TST2829C_BoolParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_CorrectionOpenStateShow=class(TST2829C_BoolParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_CorrectionShotStateShow=class(TST2829C_BoolParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

 TST2829C_SpotStateShow=class(TST2829C_BoolParameterShow)
  private
   fSpotNumber:byte;
  protected
   procedure Click(Sender:TObject);override;
  public
   Constructor Create(ST2829C:TST2829C;SpotNumber:byte);
   procedure GetDataFromDevice;override;
 end;

//----------------------------------------------------

 TST2829C_OpenShow=class(TST2829C_BoolParameterAndButtonShow)
 protected
  procedure RealAction();override;
 public
  Constructor Create(ST2829C:TST2829C;
                     Parent:TWinControl);
 end;

 TST2829C_ShortShow=class(TST2829C_BoolParameterAndButtonShow)
 protected
  procedure RealAction();override;
 public
  Constructor Create(ST2829C:TST2829C;
                     Parent:TWinControl);
 end;



//----------------------------------------------------

TST2829C_FreqMeasShow=class(TST2829C_DoubleParameterShow)
 protected
//  procedure HookParameterClickFreqMeas;
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_SpotFreqShow=class(TST2829C_DoubleParameterShow)
  private
   fSpotNumber:byte;
  protected
   procedure Click();override;
  public
   Constructor Create(ST2829C:TST2829C;SpotNumber:byte);
//   procedure GetDataFromDevice;override;
end;

TST2829C_VMeasShow=class(TST2829C_DoubleParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_IMeasShow=class(TST2829C_DoubleParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_BiasVoltageShow=class(TST2829C_DoubleParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_BiasCurrentShow=class(TST2829C_DoubleParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

//----------------------------------------------------------------
TST2829C_AverTimesShow=class(TST2829C_IntegerParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);
end;

TST2829C_DelayTimeShow=class(TST2829C_IntegerParameterShow)
 protected
 public
  Constructor Create(ST2829C:TST2829C);

end;

TST2829C_ActiveSpotShow=class(TST2829C_IntegerParameterShow)
 protected
  procedure Click();override;
 public
  Constructor Create(ST2829C:TST2829C);
  procedure ObjectToSetting;override;
end;

TST2829C_GroupBoxSpotTuning=class(TGroupBox)
 {ще додаткова кнопка, на яку чіпляється дія;
 і кнопка, і чек-бокс розміщуються у TGroupBox}
 private
  fST2829C:TST2829C;
  fButton:TButton;
//  fGB:TGroupBox;
//  fLabel:Tlabel;
 protected
  procedure DesignElements();
//  procedure ClickButton(Sender:TObject);
//  procedure RealAction();virtual;abstract;
 public
  fActiveSpotShow:TST2829C_ActiveSpotShow;
  property Button:TButton read fButton;
//  property GroupBox:TGroupBox read fGB;
  Constructor Create({AOwner: TComponent;}
                     ST2829C:TST2829C;
                     Parent:TWinControl);reintroduce;
  destructor Destroy;override;
//  procedure ParentToElements(Parent:TWinControl);override;
end;



implementation

uses
  ST2829CConst, SysUtils, Dialogs, OApproxShow;

{ TST2829C_DoubleParameterShow }

function TST2829C_DoubleParameterShow.FuncForObjectToSetting: double;
begin
  case TST2829CAction(fActionType) of
    st_aFreqMeas:Result:=(fSCPInew as TST2829C).FreqMeas;
    st_aVMeas:Result:=(fSCPInew as TST2829C).VrmsMeas;
    st_aIMeas:Result:=(fSCPInew as TST2829C).IrmsMeas;
    st_aBiasVol:Result:=(fSCPInew as TST2829C).BiasVoltageValue;
    st_aBiasCur:Result:=(fSCPInew as TST2829C).BiasCurrentValue;
    st_aCorSpotFreq:Result:=(fSCPInew as TST2829C).Corrections.SpotActiveFreq;
    else Result:=-1;
  end;
end;

{ TST2829C_BoolParameterShow }


function TST2829C_BoolParameterShow.FuncForObjectToSetting: boolean;
begin
  case TST2829CAction(fActionType) of
    st_aALE:Result:=(fSCPInew as TST2829C).AutoLevelControlEnable;
    st_aBiasEn:Result:=(fSCPInew as TST2829C).BiasEnable;
    st_aVrmsToMeas:Result:=(fSCPInew as TST2829C).VrmsToMeasure;
    st_aIrmsToMeas:Result:=(fSCPInew as TST2829C).IrmsToMeasure;
    st_aOpenState:Result:=(fSCPInew as TST2829C).CorectionOpenEnable;
    st_aShortState:Result:=(fSCPInew as TST2829C).CorectionShortEnable;
    st_aCorSpotState:Result:=(fSCPInew as TST2829C).Corrections.fSpotActiveState;
    else Result:=False;
  end;
end;

{ TST2829C_AutoDelayShow }

constructor TST2829C_AutoLevelShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aALE),'Auto Level Control');
 HookParameterClick:=ObjectToSetting;
end;

{ TST2829C_FreqMeasShow }

constructor TST2829C_FreqMeasShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aFreqMeas),
                 'Freq, Hz:',1000,10);
 SetLimits(ST2829C_FreqMeasLimits);
 HookParameterClick:=ObjectToSetting;
end;

//procedure TST2829C_FreqMeasShow.HookParameterClickFreqMeas;
//begin
//  ObjectToSetting;
//end;

{ TST2829C_VMeasShow }

constructor TST2829C_VMeasShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aVMeas),
                 'Vrms, V:',0.01,8);
 SetLimits(ST2829C_VrmsMeasLimits);
// HookParameterClick:=ObjectToSetting;
end;

{ TST2829C_IMeasShow }

constructor TST2829C_IMeasShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aIMeas),
                 'Irms, mA:',0.1,7);
 SetLimits(ST2829C_IrmsMeasLimits);
// HookParameterClick:=ObjectToSetting;
end;

{ TST2829C_BiasEnableShow }

constructor TST2829C_BiasEnableShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aBiasEn),'Bias Enable');
end;

{ TST2829C_BiasVoltageShow }

constructor TST2829C_BiasVoltageShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aBiasVol),
                 'Bias, V:',0,7);
 SetLimits(ST2829C_BiasVoltageLimits);
// HookParameterClick:=ObjectToSetting;
end;

{ TST2829C_StringParameterShow }

function TST2829C_StringParameterShow.FuncForObjectToSetting: byte;
begin
  case TST2829CAction(fActionType) of
    st_aOutImp:Result:=ord((fSCPInew as TST2829C).OutputImpedance);
    st_aSetMeasT:Result:=ord((fSCPInew as TST2829C).MeasureType);
    st_aSpeedMeas:Result:=ord((fSCPInew as TST2829C).MeasureSpeed);
    st_aTrigSource:Result:=ord((fSCPInew as TST2829C).TrigSource);
    st_aRange:Result:=ord((fSCPInew as TST2829C).MeasureRange);
    st_aCorCable:Result:=ord((fSCPInew as TST2829C).CorectionCable);
    else Result:=255;
  end;
end;

function TST2829C_StringParameterShow.HighForSLFilling: byte;
begin
 case TST2829CAction(fActionType) of
  st_aOutImp:Result:=ord(High(TST2829C_OutputImpedance));
  st_aSetMeasT:Result:=ord(High(TST2829C_MeasureType));
  st_aRange:Result:=ord(High(TST2829C_Range));
  st_aSpeedMeas:Result:=ord(High(TST2829C_MeasureSpeed));
  st_aTrigSource:Result:=ord(High(TST2829C_TrigerSource));
  st_aCorCable:Result:=ord(High(TST2829C_CorCable));
  else Result:=0;
 end;
end;

function TST2829C_StringParameterShow.StrForSLFilling(i: byte): string;
begin
 case TST2829CAction(fActionType) of
  st_aOutImp:Result:=ST2829C_OutputImpedanceLabels[TST2829C_OutputImpedance(i)];
  st_aSetMeasT:Result:=ST2829C_MeasureTypeLabels[TST2829C_MeasureType(i)];
  st_aRange:Result:=ST2829C_RangeLabels[TST2829C_Range(i)];
  st_aSpeedMeas:Result:=ST2829C_MeasureSpeedLabels[TST2829C_MeasureSpeed(i)];
  st_aTrigSource:Result:=ST2829C_TrigerSourceLabels[TST2829C_TrigerSource(i)];
  st_aCorCable:Result:=ST2829C_CorCableCommands[TST2829C_CorCable(i)];
  else Result:='';
 end;
end;

{ TST2829C_OutputImpedanceShow }

constructor TST2829C_OutputImpedanceShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aOutImp),
                     'Input Impedance:', True);
end;

{ TST2829C_MeasureTypeShow }

constructor TST2829C_MeasureTypeShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aSetMeasT),
                     'MeasType', False);
end;

{ TST2829C_RangeShow }

constructor TST2829C_RangeShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aRange),
                     'Range:', True);
end;

{ TST2829C_MeasureSpeedShow }

constructor TST2829C_MeasureSpeedShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aSpeedMeas),
                     'Speed:', True);
end;

{ TST2829C_IntegerParameterShow }

function TST2829C_IntegerParameterShow.FuncForObjectToSetting: integer;
begin
  case TST2829CAction(fActionType) of
    st_aAverTimes:Result:=(fSCPInew as TST2829C).AverTimes;
    st_aTrigDelay:Result:=(fSCPInew as TST2829C).DelayTime;
    else Result:=-1;
  end;
end;

{ TST2829C_AverTimesShow }

constructor TST2829C_AverTimesShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aAverTimes),
                 'Average Count:',1);
 SetLimits(ST2829C_AverTimes);
end;

{ TST2829C_VrmsToMeasureShow }

constructor TST2829C_VrmsToMeasureShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aVrmsToMeas),'Enable Vrms measuring');
end;

{ TST2829C_IrmsToMeasureShow }

constructor TST2829C_IrmsToMeasureShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aIrmsToMeas),'Enable Irms measuring');
end;

{ TST2829C_BiasCurrentShow }

constructor TST2829C_BiasCurrentShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aBiasCur),
                 'Bias, mA:',0,7);
 SetLimits(ST2829C_BiasCurrentLimits);
// HookParameterClick:=ObjectToSetting;
end;

{ TST2829C_TrigerSourceShow }

constructor TST2829C_TrigerSourceShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aTrigSource),
                     'Triger Source:', True);
end;

{ TST2829C_DelayTimeShow }


constructor TST2829C_DelayTimeShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aTrigDelay),
                 'Delay, ms:','Lazy time bewbeen trigering and measuring, []=ms',0);
 SetLimits(ST2829C_DelayTime);
end;

{ TST2829C_CorrectionCabel }

constructor TST2829C_CorrectionCabelShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aCorCable),
                     'Cable:', True);
end;

{ TST2829C_CorrectionOpenStateShow }

constructor TST2829C_CorrectionOpenStateShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aOpenState),'Enable');
end;

{ TST2829C_CorrectionShotStateShow }

constructor TST2829C_CorrectionShotStateShow.Create(ST2829C: TST2829C);
begin
  inherited Create(ST2829C,Pointer(st_aShortState),'Enable');
end;

{ TST2829C_BoolParameterAndButtonShow }

procedure TST2829C_BoolParameterAndButtonShow.ClickButton(Sender: TObject);
// var Response: Integer;
begin
  if YesClicked('Are you sure?') then RealAction();

//  Response := MessageDlg('Are you sure?', mtConfirmation, [mbYes, mbNo], 0);
//
//  if Response = mrYes then
//    RealAction()
end;

constructor TST2829C_BoolParameterAndButtonShow.Create(ST2829C: TST2829C;
  ActionType: Pointer; ParametrCaption, ButtonCaption, GroupBoxCaption: string;
                     Parent:TWinControl);
begin
 inherited Create(ST2829C,ActionType,ParametrCaption);
  fButton:=TButton.Create(nil);

  fGB:=TGroupBox.Create(nil);
  fGB.Caption:=GroupBoxCaption;
  fGB.Parent:=Parent;
  fButton.Caption:=ButtonCaption;
  CB.Parent:=fGB;
  fButton.Parent:=fGB;
  fButton.OnClick:=ClickButton;
  DesignElements();
end;

procedure TST2829C_BoolParameterAndButtonShow.DesignElements;
begin
  fLabel:=Tlabel.Create(fGB);
  fLabel.Parent:=fGB;
  CB.Left:=5;
  CB.Top:=18;
  CB.Width:=fLabel.Canvas.TextWidth(CB.Caption)+17;
  fButton.Top:=CB.Top-3;
  fButton.Left:=CB.Left+CB.Width;
  fGB.Width:=fButton.Left+fButton.Width+5;
  fGB.Height:=fButton.Top+fButton.Height+10;
  fLabel.Parent:=nil;
  FreeAndNil(fLabel);
end;

destructor TST2829C_BoolParameterAndButtonShow.Destroy;
begin
  CB.Parent:=nil;
  fButton:=Nil;
  fGB.Parent:=nil;
  FreeAndNil(fButton);
  FreeAndNil(fGB);
  inherited;
end;

procedure TST2829C_BoolParameterAndButtonShow.ParentToElements(
  Parent: TWinControl);
begin
// fGB.Parent:=Parent;
end;

{ TST2829C_OpenShow }

constructor TST2829C_OpenShow.Create(ST2829C: TST2829C;
                     Parent:TWinControl);
begin
 inherited Create(ST2829C,Pointer(st_aOpenState),'Enable',
           'Measure','Open',Parent);
end;

procedure TST2829C_OpenShow.RealAction;
begin
  (fSCPInew as TST2829C).SetCorrectionOpenMeasuring;
end;

{ TST2829C_ShortShow }

constructor TST2829C_ShortShow.Create(ST2829C: TST2829C;
                     Parent:TWinControl);
begin
 inherited Create(ST2829C,Pointer(st_aShortState),'Enable',
           'Measure','Short',Parent);
end;

procedure TST2829C_ShortShow.RealAction;
begin
 (fSCPInew as TST2829C).SetCorrectionShortMeasuring;
end;

{ TST2829C_ActiveSpotShow }

procedure TST2829C_ActiveSpotShow.Click;
begin
 (fSCPInew as TST2829C).Corrections.SpotActiveNumber:=Data;
 fHookParameterClick;
end;

constructor TST2829C_ActiveSpotShow.Create(ST2829C: TST2829C);
begin
 inherited Create(ST2829C,Pointer(st_aCorSpotShort),
                 'Number:',1);
 SetLimits(ST2829C_SpotNumber);
end;


procedure TST2829C_ActiveSpotShow.ObjectToSetting;
begin
end;

{ TST2829C_GroupBoxSpotTuning }

//procedure TST2829C_GroupBoxSpotTuning.ClickButton(Sender: TObject);
//begin
//
//end;

constructor TST2829C_GroupBoxSpotTuning.Create({AOwner: TComponent;}
                            ST2829C: TST2829C;
                            Parent: TWinControl);
begin
  inherited Create(nil);
  fST2829C:=ST2829C;
  fButton:=TButton.Create(nil);
  Self.Parent:=Parent;

  fButton.Parent:=Self;
  fActiveSpotShow:=TST2829C_ActiveSpotShow.Create(ST2829C);
  fActiveSpotShow.ParentToElements(Self);
//  fButton.OnClick:=ClickButton;
  DesignElements();
end;

procedure TST2829C_GroupBoxSpotTuning.DesignElements;
begin
  Self.Caption:='Spot control';
  fButton.Caption:='Tuning';
  fActiveSpotShow.LCaption.Left:=5;
  fActiveSpotShow.LCaption.Top:=15;
  RelativeLocation(fActiveSpotShow.LCaption,fActiveSpotShow.STdata,oRow,3);
  RelativeLocation(fActiveSpotShow.STdata,fButton,oRow,10);
  Height:=fButton.Top+fButton.Height+5;
  Width:=fButton.Left+fButton.Width+5;
end;

destructor TST2829C_GroupBoxSpotTuning.Destroy;
begin
//  Self.Parent:=nil;
//  fButton.Parent:=nil;
//  fActiveSpotShow.ParentToElements(nil);
  FreeAndNil(fActiveSpotShow);
  FreeAndNil(fButton);
  inherited;
end;

{ TST2829C_SpotStateShow }

procedure TST2829C_SpotStateShow.Click(Sender: TObject);
begin
 (fSCPInew as TST2829C).SetCorrectionSpotState(fSpotNumber,CB.Checked);
 fHookParameterClick;
end;

constructor TST2829C_SpotStateShow.Create(ST2829C: TST2829C; SpotNumber: byte);
begin
 fSpotNumber:=SpotNumber;
 inherited Create(ST2829C,Pointer(st_aCorSpotState),'Used');
end;

procedure TST2829C_SpotStateShow.GetDataFromDevice;
begin
 (fSCPInew as TST2829C).GetCorrectionSpotState(fSpotNumber);
end;

{ TST2829C_SpotFreqShow }

procedure TST2829C_SpotFreqShow.Click;
begin
  (fSCPInew as TST2829C).SetCorrectionSpotFreq(fSpotNumber,Data);
  fHookParameterClick;
end;

constructor TST2829C_SpotFreqShow.Create(ST2829C: TST2829C; SpotNumber: byte);
begin
 fSpotNumber:=SpotNumber;
 inherited Create(ST2829C,Pointer(st_aCorSpotFreq),
                 'Freq, Hz:',1000,10);
 SetLimits(ST2829C_FreqMeasLimits);
end;

//procedure TST2829C_SpotFreqShow.GetDataFromDevice;
//begin
//  inherited GetDataFromDevice;
//  (fSCPInew as TST2829C).GetCorrectionSpotFreq(fSpotNumber);
//end;

end.
