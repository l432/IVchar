unit DMM6500_MeasParamShow;

interface

uses
  OlegShowTypes, Classes, DMM6500, StdCtrls, Keitley2450Const, OlegType, SCPI, 
  Controls, Windows;

type


TDMM6500_ParameterShowBase=class
 private
//  fParamShow:TParameterShowNew;
  fDMM6500:TDMM6500;
  fChanNumber:byte;
 protected
  procedure GetDataFromDevice;virtual;abstract;
 public
  Constructor Create(DMM6500:TDMM6500;ChanNumber:byte=0);overload;
  procedure ObjectToSetting;virtual;abstract;
  procedure UpDate;
end;

TDMM6500_BoolParameterShow=class(TDMM6500_ParameterShowBase)
 private
  fCB:TCheckBox;
  procedure Click(Sender:TObject);virtual;abstract;
  procedure SetValue(Value:Boolean);
 public
  Constructor Create(CB:TCheckBox;ParametrCaption: string;
           DMM6500:TDMM6500;ChanNumber:byte=0);overload;
 destructor Destroy;override;
end;

TDMM6500_ParameterShow=class(TDMM6500_ParameterShowBase)
 private
  fParamShow:TParameterShowNew;
//  fDMM6500:TDMM6500;
//  fChanNumber:byte;
//  procedure CreateHeader(DMM6500: TDMM6500; ChanNumber: Byte);//virtual;
 protected
//  fSettingsShowSL:TStringList;

//  procedure OkClick();virtual;abstract;
//  procedure GetDataFromDevice;virtual;abstract;
//  procedure SettingsShowSLFilling();virtual;abstract;
//  procedure SomeAction();virtual;
  procedure OkClick();virtual;abstract;
  procedure SetLimits(LimitV:TLimitValues);
 public
//  Constructor Create(DMM6500:TDMM6500;ChanNumber:byte=0);overload;
//  Constructor Create(ST:TStaticText;LCap:TLabel;ParametrCaption: string;
//           DMM6500:TDMM6500;ChanNumber:byte=0);overload;
  destructor Destroy;override;
//  procedure ObjectToSetting;virtual;abstract;
//  procedure UpDate;
end;


//TDMM6500_StringParameterShow=class(TStringParameterShow)
TDMM6500_StringParameterShow=class(TDMM6500_ParameterShow)
 private
  procedure CreateHeader{(DMM6500: TDMM6500; ChanNumber: Byte)};
    function GetData: integer;
    procedure SetDat(const Value: integer);//virtual;
 protected
  fSettingsShowSL:TStringList;
//  fDMM6500:TDMM6500;
//  fChanNumber:byte;
//  procedure OkClick();virtual;abstract;
  procedure SettingsShowSLFilling();virtual;abstract;
  procedure SomeAction();virtual;
 public
  property Data:integer read GetData write SetDat;
  Constructor Create(ST:TStaticText;ParametrCaption: string;
           DMM6500:TDMM6500;ChanNumber:byte=0);overload;
  Constructor Create(ST:TStaticText;LCap:TLabel;ParametrCaption: string;
           DMM6500:TDMM6500;ChanNumber:byte=0);overload;
  destructor Destroy;override;
//  procedure ObjectToSetting;virtual;abstract;
end;

//TDMM6500_LimitedParameterShow=class(TDMM6500_ParameterShow)
// private
//  procedure SetLimits(LimitV:TLimitValues);
//end;

TDMM6500_DoubleParameterShow=class(TDMM6500_ParameterShow)
 private
  function GetData: double;
  procedure SetDat(const Value: double);
 public
  property Data:double read GetData write SetDat;
  Constructor Create(DMM6500:TDMM6500;ChanNumber:byte;
                      STD:TStaticText;
                      STC:TLabel;
                      ParametrCaption:string;
                      InitValue:double;
                      DN:byte=3);
end;

TDMM6500_IntegerParameterShow=class(TDMM6500_ParameterShow)
  private
    function GetData: integer;
    procedure SetDat(const Value: integer);
 public
  property Data:integer read GetData write SetDat;
  Constructor Create(DMM6500:TDMM6500;ChanNumber:byte;
                      STD:TStaticText;
                      STC:TLabel;
                      ParametrCaption:string;
                      InitValue:integer);
end;

TDMM6500_MeasurementTypeShow=class(TDMM6500_StringParameterShow)
 private
  fPermitedMeasFunction:array of TKeitley_Measure;
  procedure PermitedMeasFunctionFilling;
  function MeasureToOrd(FM: TKeitley_Measure):ShortInt;
 protected
  procedure OkClick();override;
  procedure SettingsShowSLFilling();override;
  procedure SomeAction();override;
  procedure GetDataFromDevice;override;
 public
  Constructor Create(ST:TStaticText;
           DMM6500:TDMM6500;ChanNumber:byte=0);
  procedure ObjectToSetting;override;
end;

TDMM6500_CountShow=class(TDMM6500_IntegerParameterShow)
 private
  fCountType:byte;
 protected
  procedure OkClick();override;
  procedure GetDataFromDevice;override;
 public
  Constructor Create(DMM6500:TDMM6500;ChanNumber:byte;
                      STD:TStaticText;
                      STC:TLabel;
                      CountType:byte);
  {CountType = 0 - Count, else CountDig}
  procedure ObjectToSetting;override;
end;

TDMM6500_DisplayDNShow=class(TDMM6500_StringParameterShow)
 protected
  procedure OkClick();override;
  procedure SettingsShowSLFilling();override;
  procedure GetDataFromDevice;override;
//  procedure SomeAction();override;
 public
  Constructor Create(ST:TStaticText;
           DMM6500:TDMM6500;ChanNumber:byte=0);
  procedure ObjectToSetting;override;
end;


TControlElements=class
 private
  fDMM6500:TDMM6500;
  fParent:TGroupBox;
 protected
  procedure CreateElements;virtual;abstract;
  procedure CreateControls;virtual;abstract;
  procedure DesignElements;virtual;abstract;
  procedure DestroyElements;virtual;abstract;
  procedure DestroyControls;virtual;abstract;
 public
  Constructor Create(GB:TGroupBox;DMM6500:TDMM6500);
  destructor Destroy;override;
end;

TDMM6500_MeasParShow=class(TControlElements)
 private
  fChanNumber:byte;
//  fDMM6500:TDMM6500;
//  fParent:TWinControl;
 protected
//  procedure CreateElements;virtual;abstract;
//  procedure CreateControls;virtual;abstract;
//  procedure DestroyElements;virtual;abstract;
//  procedure DestroyControls;virtual;abstract;
  procedure GetDataFromDevice;virtual;abstract;
 public
  Constructor Create(Parent:TGroupBox;DMM6500:TDMM6500;ChanNumber:byte=0);
//  destructor Destroy;override;
  procedure ObjectToSetting;virtual;abstract;
end;

TDMM6500MeasPar_BaseShow=class(TDMM6500_MeasParShow)
 private
  fCountShow:TDMM6500_CountShow;
  fDisplayDNShow:TDMM6500_DisplayDNShow;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DestroyElements;override;
  procedure DestroyControls;override;
  procedure CountShowCreate;virtual;
  procedure GetDataFromDevice;override;
  procedure DesignElements;override;
 public
  STCount:TStaticText;
  LCount:TLabel;
  STDisplayDN:TStaticText;
  procedure ObjectToSetting;override;
end;

TDMM6500_AutoDelayShow=class(TDMM6500_BoolParameterShow)
 protected
  procedure Click(Sender:TObject);override;
  procedure GetDataFromDevice;override;
 public
  Constructor Create(CB:TCheckBox;
           DMM6500:TDMM6500;ChanNumber:byte=0);
  procedure ObjectToSetting;override;
end;


TDMM6500ControlChannels=class(TControlElements)
 private
  fLabels:array of TLabel;
  fST:array of TStaticText;
  fButtons:array of TButton;
  fMeasurementType:array of TDMM6500_MeasurementTypeShow;
  function GetChanCount:byte;
 protected
  procedure CreateElements;override;
  procedure CreateControls;override;
  procedure DesignElements;override;
  procedure DestroyElements;override;
  procedure DestroyControls;override;
 public
  property ChanCount:byte read GetChanCount;
//  Constructor Create(GB:TGroupBox;DMM6500:TDMM6500);
//  destructor Destroy;override;
end;

implementation

uses
  SysUtils, DMM6500_Const, Graphics, OlegFunction, DMM6500_MeasParam;

{ TDMM6500_StringParameterShow }

constructor TDMM6500_StringParameterShow.Create(ST: TStaticText;
  ParametrCaption: string; DMM6500: TDMM6500; ChanNumber: byte);
begin
  inherited Create(DMM6500,ChanNumber);
  CreateHeader{(DMM6500, ChanNumber)};
  fParamShow:=TStringParameterShow.Create(ST,ParametrCaption,fSettingsShowSL);
//  inherited Create(ST,ParametrCaption,fSettingsShowSL);
  fParamShow.HookParameterClick:=OkClick;
end;

destructor TDMM6500_StringParameterShow.Destroy;
begin
//  fParamShow.HookParameterClick:=nil;
//  fParamShow.Free;
  fSettingsShowSL.Free;
  inherited;
end;

function TDMM6500_StringParameterShow.GetData: integer;
begin
 Result:=(fParamShow as TStringParameterShow).Data;
end;

procedure TDMM6500_StringParameterShow.SetDat(const Value: integer);
begin
 (fParamShow as TStringParameterShow).Data:=Value;
end;

procedure TDMM6500_StringParameterShow.SomeAction;
begin
end;

constructor TDMM6500_StringParameterShow.Create(ST: TStaticText; LCap: TLabel;
  ParametrCaption: string; DMM6500: TDMM6500; ChanNumber: byte);
begin
  inherited Create(DMM6500,ChanNumber);
  CreateHeader{(DMM6500, ChanNumber)};
  fParamShow:=TStringParameterShow.Create(ST,LCap,ParametrCaption,fSettingsShowSL);
//  inherited Create(ST,LCap,ParametrCaption,fSettingsShowSL);
  fParamShow.HookParameterClick:=OkClick;

end;

procedure TDMM6500_StringParameterShow.CreateHeader{DMM6500: TDMM6500; ChanNumber: Byte)};
begin
//  fDMM6500 := DMM6500;
//  fChanNumber := ChanNumber;
  SomeAction();
  fSettingsShowSL := TStringList.Create;
  SettingsShowSLFilling;
end;

{ TDMM6500_MeasurementType }

constructor TDMM6500_MeasurementTypeShow.Create(ST: TStaticText; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create(ST,'MeasureType',DMM6500,ChanNumber);
end;


procedure TDMM6500_MeasurementTypeShow.GetDataFromDevice;
begin
 fDMM6500.GetMeasureFunction(fChanNumber);
end;

function TDMM6500_MeasurementTypeShow.MeasureToOrd(FM: TKeitley_Measure): ShortInt;
 var i:byte;
begin
 for I := 0 to High(fPermitedMeasFunction) do
  if fPermitedMeasFunction[i]=FM then
   begin
     Result:=i;
     Exit;
   end;
 Result:=-1;
end;

procedure TDMM6500_MeasurementTypeShow.ObjectToSetting;
begin
 if fChanNumber=0
   then Data:=MeasureToOrd(fDMM6500.MeasureFunction)
   else Data:=MeasureToOrd(fDMM6500.ChansMeasure[fChanNumber-1].MeasureFunction);
end;

procedure TDMM6500_MeasurementTypeShow.OkClick;
begin
  fDMM6500.SetMeasureFunction(fPermitedMeasFunction[Data],fChanNumber);
end;

procedure TDMM6500_MeasurementTypeShow.PermitedMeasFunctionFilling;
 var i:TKeitley_Measure;
begin
 for I := Low(TKeitley_Measure) to High(TKeitley_Measure) do
  if fDMM6500.IsPermittedMeasureFuncForChan(i,fChanNumber) then
    begin
      SetLength(fPermitedMeasFunction,High(fPermitedMeasFunction)+2);
      fPermitedMeasFunction[High(fPermitedMeasFunction)]:=i;
    end;
end;

procedure TDMM6500_MeasurementTypeShow.SettingsShowSLFilling;
 var i:byte;
begin
 for I := 0 to High(fPermitedMeasFunction) do
    fSettingsShowSL.Add(Keitley_MeasureLabel[fPermitedMeasFunction[i]]);
end;

procedure TDMM6500_MeasurementTypeShow.SomeAction;
begin
  inherited;
  PermitedMeasFunctionFilling;
end;

{ TControlPanel }

constructor TControlElements.Create(GB: TGroupBox;DMM6500:TDMM6500);
begin
 inherited Create;
 fParent:=GB;
 fDMM6500:=DMM6500;
 CreateElements;
 CreateControls;
 CreateElements;
 CreateControls;
 DesignElements;
end;

//destructor TControlElements.Destroy;
//begin
//  DestroyControls;
//  DestroyElements;
//  inherited;
//end;

{ TControlChannels }

//constructor TDMM6500ControlChannels.Create(GB: TGroupBox; DMM6500: TDMM6500);
//begin
//// fDMM6500:=DMM6500;
//// inherited Create(GB);
// inherited Create(GB,DMM6500);
// fParent.Caption:='Channels'
//end;

procedure TDMM6500ControlChannels.CreateControls;
 var i:Shortint;
begin
 SetLength(fMeasurementType,High(fST)+1);
 for I := 0 to High(fMeasurementType) do
  fMeasurementType[i]:=TDMM6500_MeasurementTypeShow.Create(fST[i],fDMM6500,i+1);
end;

procedure TDMM6500ControlChannels.CreateElements;
 var i:Shortint;
begin
 SetLength(fLabels,High(fDMM6500.ChansMeasure)+1);
 SetLength(fST,High(fDMM6500.ChansMeasure)+1);
 SetLength(fButtons,High(fDMM6500.ChansMeasure)+1);
 for I := 0 to High(fLabels) do
  begin
    fLabels[i]:=TLabel.Create(fParent);
    fLabels[i].Parent:=fParent;
    fST[i]:=TStaticText.Create(fParent);
    fST[i].Parent:=fParent;
    fButtons[i]:=TButton.Create(fParent);
    fButtons[i].Parent:=fParent;
  end;
end;

procedure TDMM6500ControlChannels.DesignElements;
 var i:Shortint;
     j:integer;
begin
 fParent.Caption:='Channels';
 for I := 0 to High(fLabels) do
  begin
   fLabels[i].Caption:='Chan'+IntToStr(i+1);
   fLabels[i].Top:=20+(fLabels[i].Canvas.TextHeight(fLabels[i].Caption)+10)*i;
   fLabels[i].Left:=5;
  end;
 j:=5+fLabels[High(fLabels)].Canvas.TextWidth(fLabels[High(fLabels)].Caption)+10;
 for I := 0 to High(fST) do
  begin
   fST[i].Top:=fLabels[i].Top;
   fST[i].Left:=j;
  end;
 j:=fST[High(fST)].Left+10+fLabels[High(fLabels)].Canvas.TextWidth('Resistance 4W');
 for I := 0 to High(fButtons) do
  begin
   fButtons[i].Caption:='Options';
   fButtons[i].Top:=fLabels[i].Top-3;
   fButtons[i].Left:=j;
  end;

 fParent.Width:=fButtons[High(fButtons)].Left+fButtons[High(fButtons)].Width+5;
 fParent.Height:=fButtons[High(fButtons)].Top+fButtons[High(fButtons)].Height+10;

end;

procedure TDMM6500ControlChannels.DestroyControls;
 var i:Shortint;
begin
 for I := 0 to High(fMeasurementType) do
  FreeAndNil(fMeasurementType[i]);
 end;

procedure TDMM6500ControlChannels.DestroyElements;
 var i:Shortint;
begin
 for I := 0 to High(fLabels) do
  begin
    fLabels[i].Free;
    fST[i].Free;
    fButtons[i].Free;
  end;
end;

function TDMM6500ControlChannels.GetChanCount: byte;
begin
 Result:=High(fLabels)+1;
end;

{ TDMM6500_ParameterShow }

//constructor TDMM6500_ParameterShow.Create(DMM6500: TDMM6500; ChanNumber: byte);
//begin
//  fDMM6500 := DMM6500;
//  fChanNumber := ChanNumber;
//end;

destructor TDMM6500_ParameterShow.Destroy;
begin
  fParamShow.HookParameterClick:=nil;
  fParamShow.Free;
  inherited;
end;

procedure TDMM6500_ParameterShow.SetLimits(LimitV: TLimitValues);
begin
 try
// (fParamShow as TLimitedParameterShow).Limits.SetLimits(LowLimit,HighLimit);
 (fParamShow as TLimitedParameterShow).Limits.SetLimits(LimitV[lvMin],LimitV[lvMax]);
 except
 end;
end;

//procedure TDMM6500_ParameterShow.UpDate;
//begin
// GetDataFromDevice;
// ObjectToSetting;
//end;

//{ TDMM6500_LimitedParameterShow }
//
//procedure TDMM6500_LimitedParameterShow.SetLimits(LimitV:TLimitValues);
//begin
//// (fParamShow as TLimitedParameterShow).Limits.SetLimits(LowLimit,HighLimit);
// (fParamShow as TLimitedParameterShow).Limits.SetLimits(LimitV[lvMin],LimitV[lvMax]);
//end;

{ TDMM6500_DoubleParameterShow }

constructor TDMM6500_DoubleParameterShow.Create(DMM6500: TDMM6500;
  ChanNumber: byte; STD: TStaticText; STC: TLabel; ParametrCaption: string;
  InitValue: double; DN: byte);
begin
  inherited Create(DMM6500,ChanNumber);
  fParamShow:=TDoubleParameterShow.Create(STD,STC,ParametrCaption,InitValue,DN);
  fParamShow.HookParameterClick:=OkClick;
end;

function TDMM6500_DoubleParameterShow.GetData: double;
begin
 Result:=(fParamShow as TDoubleParameterShow).Data;
end;

procedure TDMM6500_DoubleParameterShow.SetDat(const Value: double);
begin
 (fParamShow as TDoubleParameterShow).Data:=Value;
end;

{ TDMM6500_IntegerParameterShow }

constructor TDMM6500_IntegerParameterShow.Create(DMM6500: TDMM6500;
  ChanNumber: byte; STD: TStaticText; STC: TLabel; ParametrCaption: string;
  InitValue: integer);
begin
  inherited Create(DMM6500,ChanNumber);
  fParamShow:=TIntegerParameterShow.Create(STD,STC,ParametrCaption,InitValue);
  fParamShow.HookParameterClick:=OkClick;
end;

function TDMM6500_IntegerParameterShow.GetData: integer;
begin
  Result:=(fParamShow as TIntegerParameterShow).Data;
end;

procedure TDMM6500_IntegerParameterShow.SetDat(const Value: integer);
begin
  (fParamShow as TIntegerParameterShow).Data:=Value;
end;

{ TDMM6500_Count }

constructor TDMM6500_CountShow.Create(DMM6500: TDMM6500; ChanNumber: byte;
  STD: TStaticText; STC: TLabel; CountType: byte);
begin
 Inherited Create(DMM6500,ChanNumber,STD,STC,'Measure Count',1);
 fCountType:=CountType;
 if fCountType=0 then SetLimits(DMM6500_CountLimits)
                 else SetLimits(DMM6500_CountDigLimits);
 
end;

procedure TDMM6500_CountShow.GetDataFromDevice;
begin
 if fCountType=0
  then fDMM6500.GetCount(fChanNumber)
  else fDMM6500.GetCountDig(fChanNumber);
end;

procedure TDMM6500_CountShow.ObjectToSetting;
begin
 if fCountType=0 then
   begin
     if fChanNumber=0
       then Data:=fDMM6500.Count
       else Data:=fDMM6500.ChansMeasure[fChanNumber-1].Count;
   end           else
   begin
     if fChanNumber=0
       then Data:=fDMM6500.CountDig
       else Data:=fDMM6500.ChansMeasure[fChanNumber-1].CountDig;
   end;
end;

procedure TDMM6500_CountShow.OkClick;
begin
 if fCountType=0
  then fDMM6500.SetCount(Data,fChanNumber)
  else fDMM6500.SetCountDig(Data,fChanNumber);
end;

{ TDMM6500_DisplayDNShow }

constructor TDMM6500_DisplayDNShow.Create(ST: TStaticText; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create(ST,'DisplayDN',DMM6500,ChanNumber);
end;

procedure TDMM6500_DisplayDNShow.GetDataFromDevice;
begin
 fDMM6500.GetDisplayDigitsNumber(fChanNumber)
end;

procedure TDMM6500_DisplayDNShow.ObjectToSetting;
begin
 Data:=fDMM6500.MeasParamByCN(fChanNumber).DisplayDN-3;
end;

procedure TDMM6500_DisplayDNShow.OkClick;
begin
 fDMM6500.SetDisplayDigitsNumber(3+Data,fChanNumber)
end;

procedure TDMM6500_DisplayDNShow.SettingsShowSLFilling;
 var i:byte;
begin
 for I := Low(TKeitleyDisplayDigitsNumber) to High(TKeitleyDisplayDigitsNumber) do
    fSettingsShowSL.Add(inttostr(i)+KeitleyDisplayDNLabel);
end;

{ TDMM6500_MeasParShow }

//constructor TDMM6500_MeasParShow.Create(Parent: TWinControl;DMM6500:TDMM6500);
//begin
// inherited Create;
// fParent:=Parent;
// fDMM6500:=DMM6500;
// CreateElements;
// CreateControls;
//end;

//destructor TDMM6500_MeasParShow.Destroy;
//begin
//  DestroyControls;
//  DestroyElements;
//  inherited;
//end;

{ TDMM6500MeasPar_BaseShow }

procedure TDMM6500MeasPar_BaseShow.CountShowCreate;
begin
 fCountShow:=TDMM6500_CountShow.Create(fDMM6500,fChanNumber,STCount,LCount,0);
end;

procedure TDMM6500MeasPar_BaseShow.CreateControls;
begin
 fDisplayDNShow:=TDMM6500_DisplayDNShow.Create(STDisplayDN,fDMM6500,fChanNumber);
 CountShowCreate;
end;

procedure TDMM6500MeasPar_BaseShow.CreateElements;
begin
  STCount:=TStaticText.Create(fParent);
  LCount:=TLabel.Create(fParent);
  STDisplayDN:=TStaticText.Create(fParent);
  STCount.Parent:=fParent;
  LCount.Parent:=fParent;
  STDisplayDN.Parent:=fParent;
end;

procedure TDMM6500MeasPar_BaseShow.DesignElements;
begin
  STCount.Font.Color:=clGreen;
  LCount.Font.Color:=clGreen;
end;

procedure TDMM6500MeasPar_BaseShow.DestroyControls;
begin
 FreeAndNil(fDisplayDNShow);
 FreeAndNil(fCountShow);
end;

procedure TDMM6500MeasPar_BaseShow.DestroyElements;
begin
  STCount.Free;
  LCount.Free;
  STDisplayDN.Free;
end;

procedure TDMM6500MeasPar_BaseShow.GetDataFromDevice;
begin
 fCountShow.GetDataFromDevice;
 fDisplayDNShow.GetDataFromDevice;
end;

procedure TDMM6500MeasPar_BaseShow.ObjectToSetting;
begin
 fCountShow.ObjectToSetting;
 fDisplayDNShow.ObjectToSetting;
end;

{ TDMM6500_MeasParChanShow }

destructor TControlElements.Destroy;
begin
  DestroyControls;
  DestroyElements;
  inherited;
end;

{ TDMM6500_MeasParShow }

constructor TDMM6500_MeasParShow.Create(Parent: TGroupBox; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
  fChanNumber:=ChanNumber;
  inherited Create(Parent,DMM6500);
end;

{ TDMM6500_ParameterShowBase }

constructor TDMM6500_ParameterShowBase.Create(DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create;
  fDMM6500 := DMM6500;
  fChanNumber := ChanNumber;
end;

procedure TDMM6500_ParameterShowBase.UpDate;
begin
 GetDataFromDevice;
 ObjectToSetting;
end;

{ TDMM6500_BoolParameterShow }

constructor TDMM6500_BoolParameterShow.Create(CB: TCheckBox;
  ParametrCaption: string; DMM6500: TDMM6500; ChanNumber: byte);
begin
 inherited Create(DMM6500,ChanNumber);
 fCB:=CB;
 fCB.OnClick:=Click;
 fCB.Caption:=ParametrCaption;
 fCB.WordWrap:=False;
end;

destructor TDMM6500_BoolParameterShow.Destroy;
begin
  fCB.OnClick:=nil;
  inherited;
end;

procedure TDMM6500_BoolParameterShow.SetValue(Value: Boolean);
begin
 AccurateCheckBoxCheckedChange(fCB,Value);
end;

{ TDMM6500_AutoDelayShow }

procedure TDMM6500_AutoDelayShow.Click(Sender: TObject);
begin
 fDMM6500.SetDelayAuto(fCB.Checked,fChanNumber)
end;

constructor TDMM6500_AutoDelayShow.Create(CB: TCheckBox; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create(CB,'Auto Delay',DMM6500,ChanNumber);
end;

procedure TDMM6500_AutoDelayShow.GetDataFromDevice;
begin
 fDMM6500.GetDelayAuto(fChanNumber)
end;

procedure TDMM6500_AutoDelayShow.ObjectToSetting;
begin
 SetValue((fDMM6500.MeasParamByCN(fChanNumber) as TDMM6500MeasPar_BaseDelay).AutoDelay);
end;

end.
