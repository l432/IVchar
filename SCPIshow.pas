unit SCPIshow;

interface

uses
  OlegTypePart2, SCPI, StdCtrls, CPortCtl, Controls, IniFiles, ExtCtrls, 
  ArduinoDeviceNew, OlegType, OlegShowTypes, Classes, Forms;

const MarginLeft=10;
      MarginRight=10;
      Marginbetween=5;
      MarginBetweenLST=3;
      MarginTop=20;

type

TGBwithControlElements=class
 private
//  fWinElements:array of TControl;
  procedure ParentToElements;virtual;
 protected
  fWinElements:array of TControl;
  fParent:TGroupBox;
  procedure Add(WinElements:TControl);
  procedure CreateElements;virtual;//abstract;
  procedure CreateControls;virtual;abstract;
  procedure DestroyElements;
  procedure DestroyControls;virtual;
  procedure DesignElements;virtual;
 public
  Constructor Create(GB:TGroupBox);
  destructor Destroy;override;
  class procedure Resize(Control:TControl);
end;

TRS232minimal_Show=class(TGBwithControlElements)
 private
 protected
  procedure CreateElements;override;
  procedure DesignElements;override;
  procedure CreateControls;override;
 public
  fLPort: TLabel;
  fComCBPort: TComComboBox;
  fComCBBaud: TComComboBox;
  fSTRate: TStaticText;
  fBTest: TButton;
end;

TSCPI_SetupMemoryPins=class(TPins)
 protected
  Function GetPinStr(Index:integer):string;override;
 public
  Constructor Create(Name:string);
end;

TRS232DeviceNew_Show=class(TNamedInterfacedObject)
  private
   fRS232Device:TRS232DeviceNew;
   fRS232Show:TRS232minimal_Show;
   procedure TestButtonClick(Sender:TObject);
  protected
  public
   Constructor Create(Device:TRS232DeviceNew;
                      GB: TGroupBox);
  destructor Destroy;override;
  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
  procedure WriteToIniFile(ConfigFile:TIniFile);override;
//  procedure ObjectToSetting;virtual;
 end;

TSCPI_ParameterShowBase=class
{������� ������� ��� ��������� ��������
�������� ��'����}
 private
 protected
  fHookParameterClick: TSimpleEvent;
  {��������� �� ��� ���������� �� ������}
  fSCPInew:TSCPInew;
  fActionType:Pointer;
  {��, �� ��'����� � ���������,
  �� ������� ���� �� ������ TST2829CAction,
  ���� ��� ������� �������� ���� ��� ���}
 public
  property HookParameterClick:TSimpleEvent read fHookParameterClick write fHookParameterClick;
  Constructor Create(SCPInew:TSCPInew;ActionType:Pointer);
  procedure ObjectToSetting;virtual;abstract;
  procedure GetDataFromDevice;virtual;//abstract;
  procedure ParentToElements(Parent:TWinControl);virtual;abstract;
end;

TGBwithControlElementsAndParamShow=class(TGBwithControlElements)
 private
//  fShowElements:array of TSCPI_ParameterShowBase;
  procedure ParentToElements;override;
 protected
  fShowElements:array of TSCPI_ParameterShowBase;
  procedure Add(ShowElements:TSCPI_ParameterShowBase);overload;
  procedure DestroyControls();override;
  procedure DesignElements;override;
 public
  procedure ObjectToSetting;virtual;
  procedure GetDataFromDevice;//virtual;
  procedure GetDataFromDeviceAndToSetting;
end;

TGBwithControlElementsAndParamAndWindowCreate=class(TGBwithControlElementsAndParamShow)
 private
  fShowForm:TForm;
  fBOk:TButton;
  fGBInFormShow:TGroupBox;
//  procedure OptionButtonClick(Sender: TObject);virtual;abstract;
  procedure CreateFormHeader(const FormName:string);
  procedure CreateFormFooter(const bOkTop:integer);
  procedure FormShowFooter;
 protected
  GBcontent:TGBwithControlElementsAndParamShow;
  function FormCaption():string;virtual;
  procedure GBcontentCreate(GB:TGroupBox);virtual;abstract;
  procedure FormShow(Sender:TObject);
end;


TSCPI_BoolParameterShow=class(TSCPI_ParameterShowBase)
{��������� ��� ��������� ������� ����������
�� ��������� TCheckBox}
 private
  fCB:TCheckBox;

//  procedure SetValue(Value:Boolean);
 protected
  procedure Click(Sender:TObject);virtual;
  function FuncForObjectToSetting:boolean;virtual;abstract;
  {�� �������, ������� ��������� ����������
  ��'����-��������, ���'����� � ����������;
  �������������� ��� ������� �������� �������
  �� fActionType}
 public
  property CB:TCheckBox read fCB;
  Constructor Create(SCPInew:TSCPInew;ActionType:Pointer;
                     ParametrCaption: string);
  destructor Destroy;override;
  procedure ObjectToSetting;override;
  procedure ParentToElements(Parent:TWinControl);override;
end;


TSCPI_ParameterShow=class(TSCPI_ParameterShowBase)
{��������� ��� ������������ ����� TParameterShowNew}
 private
//  fParamShow:TParameterShowNew;
//  {�� ���������� � ��������}
  fST:TStaticText;
  fLab:TLabel;
 protected
  fParamShow:TParameterShowNew;
  {�� ���������� � ��������}
  procedure Click();virtual;
  procedure SetLimits(LimitV:TLimitValues);overload;
  procedure SetLimits(LowLimit:double=ErResult;HighLimit:double=ErResult);overload;
 public
  property STdata:TStaticText read fST;
  property LCaption:TLabel read fLab;
  Constructor Create(SCPInew:TSCPInew;ActionType:Pointer;LabelIsNeeded:boolean=True);
  destructor Destroy;override;
  procedure ParentToElements(Parent:TWinControl);override;
end;


TSCPI_StringParameterShow=class(TSCPI_ParameterShow)
 private
  procedure CreateHeader;
  function GetData: integer;
  procedure SetData(const Value: integer);
 protected
  fSettingsShowSL:TStringList;
  procedure SettingsShowSLFilling();virtual;
  procedure SomeAction();virtual;
  procedure Click();override;
  function HighForSLFilling:byte;virtual;abstract;
  function StrForSLFilling(i:byte):string;virtual;abstract;
  function FuncForObjectToSetting:byte;virtual;abstract;
 public
  property Data:integer read GetData write SetData;
  Constructor Create(SCPInew:TSCPInew;ActionType:Pointer;
                     ParametrCaption: string; LabelIsNeeded:boolean);
  destructor Destroy;override;
  procedure ObjectToSetting;override;
end;


TSCPI_IntegerParameterShow=class(TSCPI_ParameterShow)
 private
//  fSTD:TStaticText;
//  fSTC:TLabel;
  function GetData: integer;
  procedure SetData(const Value: integer);
 protected
  function FuncForObjectToSetting:integer;virtual;abstract;
  procedure Click();override;
 public
//  property STData:TStaticText read fSTD;
//  property LCaption:TLabel read fSTC;
  property Data:integer read GetData write SetData;
  Constructor Create(SCPInew:TSCPInew;ActionType:Pointer;
                      ParametrCaption:string;
                      InitValue:integer);overload;
  Constructor Create(SCPInew:TSCPInew;ActionType:Pointer;
                      ParametrCaption:string;
                      WindowText:string;
                      InitValue:integer);overload;
  destructor Destroy;override;
  procedure ObjectToSetting;override;
end;

TSCPI_DoubleParameterShow=class(TSCPI_ParameterShow)
 private
  function GetData: double;
  procedure SetData(const Value: double);
 protected
  function FuncForObjectToSetting:double;virtual;abstract;
  procedure Click();override;
 public
  property Data:double read GetData write SetData;
  Constructor Create(SCPInew:TSCPInew;ActionType:Pointer;
                      ParametrCaption:string;
                      InitValue:double;
                      DN:byte=3);
 procedure ObjectToSetting;override;
end;


{ TRS232DeviceNew_Show }


Procedure DesignSettingPanel(P:TPanel;Caption:string);

Function YesClicked(const quation:string):boolean;


implementation

uses
  SysUtils, CPort, RS232deviceNew, Dialogs, Graphics, OlegFunction, 
  Buttons;

constructor TRS232DeviceNew_Show.Create(Device: TRS232DeviceNew; GB: TGroupBox);
begin
 fRS232Device:=Device;
 fRS232Show:=TRS232minimal_Show.Create(GB);
 fRS232Show.fComCBPort.ComPort:=fRS232Device.ComPort;
 fRS232Show.fComCBBaud.ComPort:=fRS232Device.ComPort;
 fRS232Show.fBTest.OnClick := TestButtonClick;
 fName:=fRS232Device.Name;
end;

{ TGBwithControlElements }

procedure TGBwithControlElements.Add(WinElements: TControl);
begin
 SetLength(fWinElements,High(fWinElements)+2);
 fWinElements[High(fWinElements)]:=WinElements;
end;

constructor TGBwithControlElements.Create(GB: TGroupBox);
begin

 inherited Create;
 fParent:=GB;

 CreateElements;
 CreateControls;
 DesignElements;
end;

procedure TGBwithControlElements.CreateElements;
begin
 ParentToElements;
end;

procedure TGBwithControlElements.DesignElements;
begin
// ParentToElements;
end;

destructor TGBwithControlElements.Destroy;
begin
  DestroyControls;
  DestroyElements;
  inherited;
end;

procedure TGBwithControlElements.DestroyControls;
begin
end;

procedure TGBwithControlElements.DestroyElements;
 var i:Integer;
begin
 for i := 0 to High(fWinElements) do
  fWinElements[i].Free;
end;

procedure TGBwithControlElements.ParentToElements;
 var i:Integer;
begin
 for I := 0 to High(fWinElements)
   do fWinElements[i].Parent:=fParent;
end;

class procedure TGBwithControlElements.Resize(Control: TControl);
 var L:Tlabel;
begin
 if (Control is TStaticText) then
  begin
    L:=TLabel.Create(Control.Parent);
    L.Parent:=Control.Parent;
    Control.Width:=L.Canvas.TextWidth((Control as TStaticText).Caption);
    Control.Height:=L.Canvas.TextHeight((Control as TStaticText).Caption);
    FreeAndNil(L);
    Exit;
  end;

 if (Control is TLabel) then
  begin
    Control.Width:=(Control as TLabel).Canvas.TextWidth((Control as TLabel).Caption);
    Control.Height:=(Control as TLabel).Canvas.TextHeight((Control as TLabel).Caption);
    Exit;
  end;
 if (Control is TCheckBox) then
  begin
    L:=TLabel.Create(Control.Parent);
    L.Parent:=Control.Parent;
    Control.Width:=L.Canvas.TextWidth((Control as TCheckBox).Caption)+22;
//    Control.Height:=L.Canvas.TextHeight((Control as TCheckBox).Caption);
    FreeAndNil(L);
    Exit;
  end;
 if (Control is TButton) then
  begin
    L:=TLabel.Create(Control.Parent);
    L.Parent:=Control.Parent;
//    L.WordWrap:=(Control as TButton).WordWrap;
//    L.Caption:=(Control as TButton).Caption;
//    Control.Width:=L.Canvas.TextWidth(L.Caption)+17;
//    Control.Height:=L.Canvas.TextHeight(L.Caption)+10;

    Control.Width:=L.Canvas.TextWidth((Control as TButton).Caption)+17;
//    Control.Height:=L.Canvas.TextHeight((Control as TButton).Caption)+10;

    FreeAndNil(L);
    Exit;
  end;
 if (Control is TSpeedButton) then
  begin
    L:=TLabel.Create(Control.Parent);
    L.Parent:=Control.Parent;
    Control.Width:=L.Canvas.TextWidth((Control as TSpeedButton).Caption)+22;
    FreeAndNil(L);
    Exit;
  end;
 if (Control is TRadioGroup) then
  begin
    L:=TLabel.Create(Control.Parent);
    L.Parent:=Control.Parent;
    Control.Height:=L.Canvas.TextHeight((Control as TRadioGroup).Items[0])+20;
    FreeAndNil(L);
    Exit;
  end;
end;

{ TRS232minimal_Show }


procedure TRS232minimal_Show.CreateControls;
begin
  fComCBPort.AutoApply:=True;
  fComCBBaud.AutoApply:=True;
  fComCBPort.ComProperty:=cpPort;
  fComCBBaud.ComProperty:=cpBaudRate;
end;

procedure TRS232minimal_Show.CreateElements;
begin
  fLPort:=TLabel.Create(fParent);
  fSTRate:=TStaticText.Create(fParent);
  fComCBPort:=TComComboBox.Create(fParent);
  fComCBBaud:=TComComboBox.Create(fParent);
  fBTest:=TButton.Create(fParent);
  Add(fLPort);
  Add(fComCBPort);
  Add(fComCBBaud);
  Add(fSTRate);
  Add(fBTest);

  inherited CreateElements;
end;

procedure TRS232minimal_Show.DesignElements;
begin
 fLPort.ParentFont:=False;
 fSTRate.ParentFont:=False;
 fComCBPort.ParentFont:=False;
 fComCBBaud.ParentFont:=False;
 fBTest.ParentFont:=False;
 fLPort.Font.Style:=[fsBold];
 fSTRate.Font.Style:=[fsBold];
 fComCBPort.Font.Style:=[fsBold];
 fComCBBaud.Font.Style:=[fsBold];
 fBTest.Font.Style:=[fsBold];

 fLPort.Font.Name:='Verdana';
 fSTRate.Font.Name:='Verdana';
 fComCBPort.Font.Name:='Arial';
 fComCBBaud.Font.Name:='Arial';
 fBTest.Font.Name:='Arial';

 fLPort.Font.Height:=-15;
 fSTRate.Font.Height:=-15;
 fComCBPort.Font.Height:=-15;
 fComCBBaud.Font.Height:=-15;
 fBTest.Font.Height:=-15;

// inherited DesignElements;
 fLPort.Caption:='Port';
 fLPort.Top:=12;
 fLPort.Left:=10;
 fLPort.Height:=18;
 fLPort.Width:=40;

 fSTRate.Caption:='Baud Rate';
 fSTRate.Top:=12;
 fSTRate.Left:=116;
 fSTRate.Height:=22;
 fSTRate.Width:=89;

 fComCBPort.Top:=31;
 fComCBPort.Left:=8;
 fComCBPort.Height:=26;
 fComCBPort.Width:=74;

 fComCBBaud.Top:=31;
 fComCBBaud.Left:=116;
 fComCBBaud.Height:=26;
 fComCBBaud.Width:=93;
 fComCBBaud.BringToFront;

 fBTest.Caption := 'Connection Test ?';
 fBTest.Top:=63;
 fBTest.Left:=8;
 fBTest.Height:=31;
 fBTest.Width:=201;

 fParent.Caption:='COM parameters';
end;



destructor TRS232DeviceNew_Show.Destroy;
begin
 PortEndAction(fRS232Device.ComPort);
 FreeAndNil(fRS232Show);
  inherited;
end;

procedure TRS232DeviceNew_Show.ReadFromIniFile(ConfigFile: TIniFile);
begin
 fRS232Device.ComPort.LoadSettings(stIniFile, ExtractFilePath(Application.ExeName) + 'IVChar.ini');
 fRS232Show.fComCBPort.UpdateSettings;
 fRS232Show.fComCBBaud.UpdateSettings;
 PortBeginAction(fRS232Device.ComPort, fRS232Show.fLPort, nil);
end;

procedure TRS232DeviceNew_Show.TestButtonClick(Sender: TObject);
begin
 if fRS232Device.SCPI.Test
   then (Sender as TButton).Caption:='Connection Test - Ok'
   else (Sender as TButton).Caption:='Connection Test - Failed';

end;

procedure TRS232DeviceNew_Show.WriteToIniFile(ConfigFile: TIniFile);
begin
 fRS232Device.ComPort.StoreSettings(stIniFile,ExtractFilePath(Application.ExeName)+'IVChar.ini');
end;


Procedure DesignSettingPanel(P:TPanel;Caption:string);
begin
 P.Caption:=Caption;
 P.Height:=20;
 P.Width:=80;
 P.Font.Color:=clHotLight;
 P.Font.Size:=9;
 P.BevelOuter:=bvLowered;
 P.ParentColor:=False;
 P.Color:=clSilver;
 P.Cursor:=crHandPoint;
end;

Function YesClicked(const quation:string):boolean;
begin
  Result:=(mrYes = MessageDlg(quation, mtConfirmation, [mbYes, mbNo], 0));
end;

{ TSCPI_SetupMemoryPins }

constructor TSCPI_SetupMemoryPins.Create(Name: string);
begin
 inherited Create(Name,['SaveSlot','LoadSlot']);
 PinStrPart:='';
end;

function TSCPI_SetupMemoryPins.GetPinStr(Index: integer): string;
begin
 case Index of
  0:Result:='Save Setup';
  else Result:='Load Setup';
 end;
end;

{ TSCPI_ParameterShowBase }

constructor TSCPI_ParameterShowBase.Create(SCPInew: TSCPInew;
  ActionType: Pointer);
begin
 inherited Create;
 fSCPInew:=SCPInew;
 fActionType:=ActionType;
 fHookParameterClick:=TSimpleClass.EmptyProcedure;
end;

procedure TSCPI_ParameterShowBase.GetDataFromDevice;
begin
 fSCPInew.GetPattern(fActionType);
end;

//procedure TSCPI_ParameterShowBase.GetDataFromDeviceAndToSetting;
//begin
// GetDataFromDevice;
// ObjectToSetting;
//end;

{ TSCPI_BoolParameterShow }

procedure TSCPI_BoolParameterShow.Click(Sender: TObject);
   var temp:boolean;
begin
 temp:=fCB.Checked;
 fSCPInew.SetPattern([fActionType,@temp]);
 fHookParameterClick;
end;

constructor TSCPI_BoolParameterShow.Create(SCPInew: TSCPInew;
  ActionType: Pointer; ParametrCaption: string);
begin
 inherited Create(SCPInew,ActionType);
 fCB:=TCheckBox.Create(nil);
 fCB.OnClick:=Click;
 fCB.Caption:=ParametrCaption;
 fCB.WordWrap:=False;
end;

destructor TSCPI_BoolParameterShow.Destroy;
begin
  FreeAndNil(fCB);
  inherited;
end;

procedure TSCPI_BoolParameterShow.ObjectToSetting;
begin
  AccurateCheckBoxCheckedChange(fCB,FuncForObjectToSetting);
//  SetValue(FuncForObjectToSetting);
end;

procedure TSCPI_BoolParameterShow.ParentToElements(Parent: TWinControl);
begin
 fCB.Parent:=Parent;
end;

//procedure TSCPI_BoolParameterShow.SetValue(Value: Boolean);
//begin
//  AccurateCheckBoxCheckedChange(fCB,Value);
//end;

{ TDMM6500_ParameterShow }

constructor TSCPI_ParameterShow.Create(SCPInew:TSCPInew;ActionType:Pointer;
                                       LabelIsNeeded:boolean=True);
begin
  inherited Create(SCPInew,ActionType);
  fST:=TStaticText.Create(nil);
  if LabelIsNeeded then fLab:=TLabel.Create(nil);
end;

destructor TSCPI_ParameterShow.Destroy;
begin
  if Assigned(fLab) then FreeAndNil(fLab);
  FreeAndNil(fST);
  fParamShow.HookParameterClick:=nil;
  fParamShow.Free;
  inherited;
end;

procedure TSCPI_ParameterShow.ParentToElements(Parent: TWinControl);
begin
 fST.Parent:=Parent;
 if Assigned(fLab) then fLab.Parent:=Parent;
end;

procedure TSCPI_ParameterShow.Click;
begin
 fHookParameterClick;
end;

procedure TSCPI_ParameterShow.SetLimits(LowLimit, HighLimit: double);
begin
 try
 (fParamShow as TLimitedParameterShow).Limits.SetLimits(LowLimit,HighLimit);
 except
 end;
end;

procedure TSCPI_ParameterShow.SetLimits(LimitV: TLimitValues);
begin
 try
 (fParamShow as TLimitedParameterShow).Limits.SetLimits(LimitV[lvMin],LimitV[lvMax]);
 except
 end;
end;

{ TSCPI_IntegerParameterShow }

procedure TSCPI_IntegerParameterShow.Click;
 var temp:integer;
begin
 temp:=Data;
 fSCPInew.SetPattern([fActionType,@temp]);
 inherited Click;
end;

constructor TSCPI_IntegerParameterShow.Create(SCPInew: TSCPInew;
  ActionType: Pointer; ParametrCaption: string; InitValue: integer);
begin
  inherited Create(SCPInew,ActionType,True);
  fParamShow:=TIntegerParameterShow.Create(fST,fLab,ParametrCaption,InitValue);
  fParamShow.HookParameterClick:=Click;
end;

constructor TSCPI_IntegerParameterShow.Create(SCPInew: TSCPInew;
  ActionType: Pointer; ParametrCaption, WindowText: string; InitValue: integer);
begin
  inherited Create(SCPInew,ActionType,True);
  fParamShow:=TIntegerParameterShow.Create(fST,fLab,ParametrCaption,WindowText,InitValue);
  fParamShow.HookParameterClick:=Click;
end;

destructor TSCPI_IntegerParameterShow.Destroy;
begin
//  FreeAndNil(fSTD);
//  FreeAndNil(fSTC);
  inherited;
end;

function TSCPI_IntegerParameterShow.GetData: integer;
begin
  Result:=(fParamShow as TIntegerParameterShow).Data;
end;

procedure TSCPI_IntegerParameterShow.ObjectToSetting;
begin
 Data:=FuncForObjectToSetting();
end;

procedure TSCPI_IntegerParameterShow.SetData(const Value: integer);
begin
  (fParamShow as TIntegerParameterShow).Data:=Value;
end;

{ TSCPI_StringParameterShow }

procedure TSCPI_StringParameterShow.Click;
begin
 fSCPInew.SetPattern([fActionType,Pointer(Data)]);
 inherited Click;
end;

constructor TSCPI_StringParameterShow.Create(SCPInew: TSCPInew;
  ActionType: Pointer; ParametrCaption: string; LabelIsNeeded: boolean);
begin
  inherited Create(SCPInew,ActionType,LabelIsNeeded);
  CreateHeader;
  if LabelIsNeeded
   then fParamShow:=TStringParameterShow.Create(fST,fLab,ParametrCaption,fSettingsShowSL)
   else fParamShow:=TStringParameterShow.Create(fST,ParametrCaption,fSettingsShowSL);
  fParamShow.HookParameterClick:=Click;
end;

procedure TSCPI_StringParameterShow.CreateHeader;
begin
  SomeAction();
  fSettingsShowSL := TStringList.Create;
  SettingsShowSLFilling;
end;

destructor TSCPI_StringParameterShow.Destroy;
begin
  fSettingsShowSL.Free;
  inherited;
end;

function TSCPI_StringParameterShow.GetData: integer;
begin
 Result:=(fParamShow as TStringParameterShow).Data;
end;

procedure TSCPI_StringParameterShow.ObjectToSetting;
begin
 Data:=FuncForObjectToSetting;
end;

procedure TSCPI_StringParameterShow.SetData(const Value: integer);
begin
 (fParamShow as TStringParameterShow).Data:=Value;
end;

procedure TSCPI_StringParameterShow.SettingsShowSLFilling;
 var i:byte;
begin
 for I := 0 to HighForSLFilling do
    fSettingsShowSL.Add(StrForSLFilling(i));
end;

procedure TSCPI_StringParameterShow.SomeAction;
begin

end;

{ TSCPI_DoubleParameterShow }

procedure TSCPI_DoubleParameterShow.Click;
  var temp:double;
begin
 temp:=Data;
 fSCPInew.SetPattern([fActionType,@temp]);
 inherited Click;
end;

constructor TSCPI_DoubleParameterShow.Create(SCPInew: TSCPInew;
  ActionType: Pointer; ParametrCaption: string; InitValue: double; DN: byte);
begin
  inherited Create(SCPInew,ActionType);
  fParamShow:=TDoubleParameterShow.Create(fST,fLab,ParametrCaption,InitValue,DN);
  fParamShow.HookParameterClick:=Click;
end;

function TSCPI_DoubleParameterShow.GetData: double;
begin
 Result:=(fParamShow as TDoubleParameterShow).Data;
end;

procedure TSCPI_DoubleParameterShow.ObjectToSetting;
begin
  Data:=FuncForObjectToSetting;
end;

procedure TSCPI_DoubleParameterShow.SetData(const Value: double);
begin
 (fParamShow as TDoubleParameterShow).Data:=Value;
end;

{ TGBwithControlElementsAndParamShow }

procedure TGBwithControlElementsAndParamShow.Add(
  ShowElements: TSCPI_ParameterShowBase);
begin
 SetLength(fShowElements,High(fShowElements)+2);
 fShowElements[High(fShowElements)]:=ShowElements;
end;

procedure TGBwithControlElementsAndParamShow.DesignElements;
begin
 ParentToElements;
end;

procedure TGBwithControlElementsAndParamShow.DestroyControls;
 var i:integer;
begin
 for i := 0 to High(fShowElements) do
  if fShowElements[i]<>nil then
    FreeAndNil(fShowElements[i])
end;

procedure TGBwithControlElementsAndParamShow.GetDataFromDevice;
 var i:integer;
begin
 for i := 0 to High(fShowElements) do
   fShowElements[i].GetDataFromDevice;
end;

procedure TGBwithControlElementsAndParamShow.GetDataFromDeviceAndToSetting;
begin
  GetDataFromDevice;
  ObjectToSetting;
end;

procedure TGBwithControlElementsAndParamShow.ObjectToSetting;
 var i:integer;
begin

 for i := 0 to High(fShowElements) do
//   begin
   fShowElements[i].ObjectToSetting;
//   showmessage(inttostr(i));
//   end;
end;

procedure TGBwithControlElementsAndParamShow.ParentToElements;
 var i:integer;
begin
  inherited ParentToElements;
  for I := 0 to High(fShowElements)
   do  fShowElements[i].ParentToElements(fParent);
end;

{ TGBwithControlElementsAndParamAndWindowCreate }

procedure TGBwithControlElementsAndParamAndWindowCreate.CreateFormFooter(
  const bOkTop: integer);
begin
   fGBInFormShow.Top:=0;
   fGBInFormShow.Left:=0;

   fBOk.Parent:=fShowForm;
   fBOk.Left:=round((fGBInFormShow.Width-fBOk.Width)/2);
   fBOk.Top:=bOkTop;

   fShowForm.Width:=fGBInFormShow.Width+25;
   fShowForm.Height:=fBOk.Top+fBOk.Height+35;
end;

procedure TGBwithControlElementsAndParamAndWindowCreate.CreateFormHeader(
  const FormName: string);
begin
  fShowForm := TForm.Create(Application);
  fShowForm.Position := poMainFormCenter;
  fShowForm.AutoScroll := True;
  fShowForm.BorderIcons := [biSystemMenu];
  fShowForm.ParentFont := True;
  fShowForm.Font.Style := [fsBold];
  fShowForm.Caption := FormName;
  fShowForm.Color := clLtGray;

  fBOk:=TButton.Create(fShowForm);
  fBOk.ModalResult:=mrOK;
  fBOk.Caption:='OK';

  fGBInFormShow:=TGroupBox.Create(fShowForm);
  fGBInFormShow.Parent:=fShowForm;
end;

function TGBwithControlElementsAndParamAndWindowCreate.FormCaption: string;
begin
 Result:='Form Caption';
end;

procedure TGBwithControlElementsAndParamAndWindowCreate.FormShow(
  Sender: TObject);
begin
  CreateFormHeader(FormCaption());

  GBcontentCreate(fGBInFormShow);
  GBcontent.GetDataFromDeviceAndToSetting;

  CreateFormFooter(fGBInFormShow.Height+5+fGBInFormShow.Top);
  fShowForm.ShowModal;

  FreeAndNil(GBcontent);
  FormShowFooter;
end;

procedure TGBwithControlElementsAndParamAndWindowCreate.FormShowFooter;
begin
 fBOk.Parent:=nil;
 fBOk.Free;

 fGBInFormShow.Parent:=nil;
 fGBInFormShow.Free;

 fShowForm.Hide;
 fShowForm.Release;
end;

end.
