unit ShowTypes;

interface

uses
  StdCtrls, IniFiles, Windows, ComCtrls, ArduinoDevice, OlegType, Series,
  Measurement, ExtCtrls, Classes, ArduinoDeviceShow, TeCanvas;

const DoubleConstantSection='DoubleConstant';
      NoFile='no file';
      RangeSection='Range';
      WindowCaptionFooter=' input';
      WindowTextFooter=' value is expected';

type

  TParameterShow=class (TNamedInterfacedObject)
{  ��� ����������� �� ����
  �) �������� ���������
  �) ���� �����
  ��� �� �������� ������� ����� ������ ��� ���� ����,
  ������� ����, ��� ���������� ��������� ����� ����
  ���. �������}
   private
    STData:TStaticText; //�������� ���������
    STCaption:TLabel; //����� ���������
    fWindowCaption:string; //����� ������ ���� ���������
    fWindowText:string;    //����� � ������ ���� ���������
    FColorChangeWithParameter: boolean;
    function StringToExpectedStringConvertion(str:string):string;virtual;abstract;
    {������������ str � �����, �� �����
    � ��������� ������,
    ������ ������� �� ������������, ���. ParameterClick}
    procedure ParameterClick(Sender: TObject);virtual;
   public
    property ColorChangeWithParameter:boolean read FColorChangeWithParameter write FColorChangeWithParameter;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WT:string);
    procedure ReadFromIniFile(ConfigFile:TIniFile);virtual;abstract;
    procedure WriteToIniFile(ConfigFile:TIniFile);virtual;abstract;
    procedure Free;
    procedure ColorToActive(Value:boolean);
    procedure SetName(Name:string);
    procedure ForUseInShowObject(NamedObject:IName;
                                 ColorChanging:boolean=true;
                                 ActiveColor:boolean=false);overload;
    procedure ForUseInShowObject(NamedObject:TNamedInterfacedObject;
                                 ColorChanging:boolean=true;
                                 ActiveColor:boolean=false);overload;
  end;  //   TParameterShow=class (TNamedInterfacedObject)

  TDoubleParameterShow=class (TParameterShow)
   private
    FDefaulValue:double;
    fDigitNumber:byte;
    function StringToExpectedStringConvertion(str:string):string;override;
    function GetData:double;
    procedure SetData(value:double);
    procedure SetDefaulValue(const Value: double);
    function ValueToString(Value:double):string;
   public
    property DefaulValue:double read FDefaulValue write SetDefaulValue;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WT:string;
                       InitValue:double;
                       DN:byte=3
    );overload;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       InitValue:double;
                       DN:byte=3
    );overload;
    property Data:double read GetData write SetData;
    procedure ReadFromIniFile(ConfigFile:TIniFile);override;
    procedure WriteToIniFile(ConfigFile:TIniFile);override;
  end;  //   TDoubleParameterShow=class (TParameterShow)

  TIntegerParameterShow=class (TParameterShow)
    FDefaulValue:integer;
    function StringToExpectedStringConvertion(str:string):string;override;
    function GetData:integer;
    procedure SetData(value:integer);
    procedure SetDefaulValue(const Value: integer);
   public
    property DefaulValue:integer read FDefaulValue write SetDefaulValue;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WT:string;
                       InitValue:integer
    );overload;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       InitValue:integer
    );overload;
    property Data:integer read GetData write SetData;
    procedure ReadFromIniFile(ConfigFile:TIniFile);override;
    procedure WriteToIniFile(ConfigFile:TIniFile);override;
  end;  //   TIntegerParameterShow=class (TParameterShow)


  TStringParameterShow=class (TParameterShow)
//    FDefaulValue:integer;
    fDataVariants:TStringList;
    function StringToExpectedStringConvertion(str:string):string;override;
    function GetData:ShortInt;
    procedure SetData(value:ShortInt);
//    procedure SetDefaulValue(const Value: integer);
    procedure ParameterClick(Sender: TObject);override;
   public
//    property DefaulValue:integer read FDefaulValue write SetDefaulValue;
//    Constructor Create(STD:TStaticText;
//                       STC:TLabel;
//                       ParametrCaption:string;
//                       WT:string;
//                       InitValue:integer
//    );overload;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       DataVariants: TStringList
    );
    property Data:ShortInt read GetData write SetData;
    procedure ReadFromIniFile(ConfigFile:TIniFile);override;
    procedure WriteToIniFile(ConfigFile:TIniFile);override;
  end;  //   TIntegerParameterShow=class (TParameterShow)


TLimitShow=class(TNamedInterfacedObject)
private
  UpDownHigh,UpDownLow:TUpDown;
  fDivisor:byte;
  fDigitNumber:byte;
  fHookForGraphElementApdate:TSimpleEvent;
  procedure UpDownBegin(MaxValue: Double; UpDown: TUpDown);
  function GetValue(UpDown: TUpDown): double;virtual;
  function GetValueString(UpDown: TUpDown): string;virtual;
  function PositionIsEqual():boolean;
  procedure UpDownHighClick(Sender: TObject; Button: TUDBtnType);
  procedure UpDownLowClick(Sender: TObject; Button: TUDBtnType);
  function GetHighValue():double;virtual;
  function GetLowValue():double;virtual;
public
  ValueLabelHigh,ValueLabelLow:TLabel;
  property HookForGraphElementApdate:TSimpleEvent
             read fHookForGraphElementApdate write fHookForGraphElementApdate;
  property HighValue:double read GetHighValue;
  property LowValue:double read GetLowValue;
  Constructor Create(Nm: string;
                     MaxValue: Double;
                     DigitNumber: Byte;
                     UDH, UDL: TUpDown;
                     VLH, VLL: TLabel);overload;
  Constructor Create(Nm: string;
                     MaxValue:double;
                     DigitNumber:byte;
                     UDH,UDL:TUpDown;
                     VLH,VLL:TLabel;
                     HookFunction:TSimpleEvent);overload;
 procedure ReadFromIniFile(ConfigFile: TIniFile);
 procedure WriteToIniFile(ConfigFile: TIniFile);
end;

TLimitShowRev=class(TLimitShow)
private
  function GetHighValue():double;override;
  function GetLowValue():double;override;
  function GetValue(UpDown: TUpDown): double;override;
  function GetValueString(UpDown: TUpDown): string;override;
public
end;

TDAC_Show=class
  private
   fOutputInterface: IDAC;
   fValueShow:TDoubleParameterShow;
   fKodShow:TIntegerParameterShow;
   ValueSetButton,KodSetButton,ResetButton:TButton;
   procedure ValueSetButtonAction(Sender:TObject);
   procedure KodSetButtonAction(Sender:TObject);
   procedure ResetButtonClick(Sender:TObject);
  public
   Constructor Create(OI: IDAC;
                      VData,KData:TStaticText;
                      VL, KL: TLabel;
                      VSB, KSB, RB: TButton);
    procedure ReadFromIniFile(ConfigFile:TIniFile);virtual;
    procedure WriteToIniFile(ConfigFile:TIniFile);virtual;
    procedure Free;
end;

  TArduinoDACShow=class(TArduinoSetterShow)
  private
   fDAC_Show:TDAC_Show;
  public
   Constructor Create(ArdDAC:TArduinoDAC;
                       PinLs: array of TPanel;
                       PinVariant:TStringList;
                       VData,KData:TStaticText;
                       VL, KL: TLabel;
                       VSB, KSB, RB: TButton);
   Procedure Free;
   procedure ReadFromIniFile(ConfigFile:TIniFile);override;
   Procedure WriteToIniFile(ConfigFile:TIniFile);override;
  end;

function LastFileName(Mask:string):string;
{������� ����� (�����, � �����������) ��������� ����� �
��������� �������, ��� ����� ����������� ����� Mask}

function LastDATFileName():string;
{������� ����� (�������) ��������� .dat ����� �
��������� �������}

Procedure MelodyShot();

Procedure MelodyLong();



implementation

uses
  Dialogs, SysUtils, Math, Controls, Graphics, Forms, OlegFunction;


function LastFileName(Mask:string):string;
 var SR : TSearchRec;
     tm:integer;
begin
 Result:=NoFile;
 if FindFirst(Mask, faAnyFile, SR) <> 0 then Exit;
 Result:=SR.name;
 tm:=SR.time;
 while FindNext(SR) = 0 do
   if tm<SR.time then
     begin
     Result:=SR.name;
     tm:=SR.time;
     end;
 FindClose(SR);
end;

function LastDATFileName():string;
begin
  Result:=LastFileName('*.dat');
  if Result<>NoFile then
   Result:=Copy(Result,1,Length(Result)-4);
end;

Procedure MelodyShot();
begin
  Windows.Beep(100,50);
end;

Procedure MelodyLong();
begin
 Windows.Beep(700,100);
 Windows.Beep(200,100);
 Windows.Beep(500,100);
end;


Constructor TDoubleParameterShow.Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WT:string;
                       InitValue:double;
                       DN:byte=3
                       );
begin
  inherited Create(STD,STC,ParametrCaption,WT);
  fDigitNumber:=DN;
  STData.Caption:=ValueToString(InitValue);
  DefaulValue:=InitValue;
end;

constructor TDoubleParameterShow.Create(STD: TStaticText;
                                        STC: TLabel;
                                        ParametrCaption: string;
                                        InitValue: double;
                                        DN: byte);
begin
 Create(STD,STC,ParametrCaption,ParametrCaption+WindowTextFooter,InitValue,DN);
end;

function TDoubleParameterShow.GetData:double;
begin
 Result:=StrToFloat(STData.Caption);
end;

procedure TDoubleParameterShow.SetData(value:double);
begin
  try
    STData.Caption:=ValueToString(value);
  finally

  end;
end;

procedure TDoubleParameterShow.ReadFromIniFile(ConfigFile:TIniFile);
begin
 STData.Caption:=ValueToString(ConfigFile.ReadFloat(fName,STCaption.Caption,DefaulValue));
end;

procedure TDoubleParameterShow.WriteToIniFile(ConfigFile:TIniFile);
begin
 WriteIniDef(ConfigFile, fName, STCaption.Caption, StrToFloat(STData.Caption),DefaulValue)
end;

procedure TDoubleParameterShow.SetDefaulValue(const Value: double);
begin
  FDefaulValue := Value;
end;

function TDoubleParameterShow.StringToExpectedStringConvertion(
  str: string): string;
begin
 Result:=ValueToString(StrToFloat(str));
end;

function TDoubleParameterShow.ValueToString(Value:double):string;
begin
//  if (Frac(Value)=0)and(Int(Value/Power(10,fDigitNumber+1))=0)
//    then Result:=FloatToStrF(Value,ffGeneral,fDigitNumber,fDigitNumber-1)
//    then
    Result:=FloatToStrF(Value,ffGeneral,fDigitNumber,fDigitNumber-1)
//    else Result:=FloatToStrF(Value,ffExponent,fDigitNumber,fDigitNumber-1);
end;


{ LimitShow }

constructor TLimitShow.Create(Nm: string;
                              MaxValue: Double;
                              DigitNumber: Byte;
                              UDH, UDL: TUpDown;
                              VLH, VLL: TLabel);
begin
 inherited Create;
 fDigitNumber:=DigitNumber;
 UpDownHigh:=UDH;
 UpDownLow:=UDL;
 ValueLabelHigh:=VLH;
 ValueLabelLow:=VLL;
 fDivisor:=round(Power(10,fDigitNumber));
 UpDownBegin(MaxValue,UpDownHigh);
 UpDownBegin(MaxValue,UpDownLow);
 UpDownHigh.OnClick:=UpDownHighClick;
 UpDownLow.OnClick:=UpDownLowClick;
 fName:=Nm;
end;

constructor TLimitShow.Create(Nm: string;
                              MaxValue: double;
                              DigitNumber: byte;
                              UDH,UDL: TUpDown;
                              VLH, VLL: TLabel;
                              HookFunction: TSimpleEvent);
begin
 Create(Nm, MaxValue, DigitNumber, UDH, UDL, VLH, VLL);
 HookForGraphElementApdate:=HookFunction;
end;

function TLimitShow.GetHighValue: double;
begin
  Result:=GetValue(UpDownHigh);
end;

function TLimitShow.GetLowValue: double;
begin
  Result:=GetValue(UpDownLow);
end;

function TLimitShow.GetValue(UpDown: TUpDown): double;
begin
 Result:=UpDown.Position/fDivisor;
end;

function TLimitShow.GetValueString(UpDown: TUpDown): string;
begin
 Result:=FloatToStrF(GetValue(UpDown),ffFixed, 4, fDigitNumber);
end;

function TLimitShow.PositionIsEqual: boolean;
begin
 Result:=(UpDownHigh.Position-UpDownLow.Position)<1;
end;

procedure TLimitShow.ReadFromIniFile(ConfigFile: TIniFile);
  var temp:Smallint;
begin

  temp:=ConfigFile.ReadInteger(RangeSection,fName+'Max',UpDownHigh.Max);
  if (temp>UpDownHigh.Max)or(temp<0) then  temp:=UpDownHigh.Max;
  UpDownHigh.Position:=temp;

  temp:=ConfigFile.ReadInteger(RangeSection,fName+'Min',0);
  if (temp>UpDownHigh.Max)or(temp<0) then  temp:=0;
  UpDownLow.Position:=temp;

  if UpDownHigh.Position<=UpDownLow.Position then
    begin
      UpDownHigh.Position:=UpDownHigh.Max;
      UpDownLow.Position:=0;
    end;
  ValueLabelHigh.Caption:=GetValueString(UpDownHigh);
  ValueLabelLow.Caption:=GetValueString(UpDownLow);
  HookForGraphElementApdate();
end;

procedure TLimitShow.UpDownBegin(MaxValue: Double; UpDown: TUpDown);
begin
 UpDown.Min:=0;
 UpDown.Max:=round(MaxValue*fDivisor);
 UpDown.Increment:=1;
end;

procedure TLimitShow.UpDownHighClick(Sender: TObject; Button: TUDBtnType);
begin
  if PositionIsEqual then
   begin
    UpDownHigh.Position:=UpDownHigh.Position+UpDownHigh.Increment;
    Exit;
   end;
  ValueLabelHigh.Caption:=GetValueString(UpDownHigh);
  HookForGraphElementApdate();
end;

procedure TLimitShow.UpDownLowClick(Sender: TObject; Button: TUDBtnType);
begin
  if PositionIsEqual then
   begin
    UpDownLow.Position:=UpDownLow.Position-UpDownLow.Increment;
    Exit;
   end;
  ValueLabelLow.Caption:=GetValueString(UpDownLow);
  HookForGraphElementApdate();
end;

procedure TLimitShow.WriteToIniFile(ConfigFile: TIniFile);
begin
    WriteIniDef(ConfigFile,RangeSection,fName+'Max',UpDownHigh.Position,UpDownHigh.Max);
    WriteIniDef(ConfigFile,RangeSection,fName+'Min',UpDownLow.Position,0);
end;

{ LimitShowRev }

function TLimitShowRev.GetHighValue: double;
begin
 Result:=GetValue(UpDownLow);
end;

function TLimitShowRev.GetLowValue: double;
begin
 Result:=GetValue(UpDownHigh);
end;

function TLimitShowRev.GetValue(UpDown: TUpDown): double;
begin
   Result:=(UpDown.Max-UpDown.Position)/fDivisor;
end;

function TLimitShowRev.GetValueString(UpDown: TUpDown): string;
begin
  Result:=FloatToStrF(-GetValue(UpDown),ffFixed, 4, fDigitNumber);
end;


{ TIntegerParameterShow }

constructor TIntegerParameterShow.Create(STD: TStaticText; STC: TLabel;
  ParametrCaption, WT: string; InitValue: integer);
begin
  inherited Create(STD,STC,ParametrCaption,WT);
  STData.Caption:=IntToStr(InitValue);
  DefaulValue:=InitValue;
end;

constructor TIntegerParameterShow.Create(STD: TStaticText; STC: TLabel;
  ParametrCaption: string; InitValue: integer);
begin
  Create(STD,STC,ParametrCaption,ParametrCaption+WindowTextFooter,InitValue);
end;

function TIntegerParameterShow.GetData: integer;
begin
  Result:=StrToInt(STData.Caption);
end;


procedure TIntegerParameterShow.ReadFromIniFile(ConfigFile: TIniFile);
begin
 STData.Caption:=IntToStr(ConfigFile.ReadInteger(fName,STCaption.Caption,DefaulValue));
end;

procedure TIntegerParameterShow.SetData(value: integer);
begin
  try
    STData.Caption:=IntToStr(value);
  finally

  end;
end;

procedure TIntegerParameterShow.SetDefaulValue(const Value: integer);
begin
 FDefaulValue := Value;
end;

function TIntegerParameterShow.StringToExpectedStringConvertion(str: string): string;
begin
 Result:=IntToStr(StrToInt(str));
end;

procedure TIntegerParameterShow.WriteToIniFile(ConfigFile: TIniFile);
begin
 WriteIniDef(ConfigFile, fName, STCaption.Caption, StrToInt(STData.Caption),DefaulValue)
end;

{ TParameterShow }

constructor TParameterShow.Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WT:string);
begin
  inherited Create;
  STData:=STD;
  STData.OnClick:=ParameterClick;
  STData.Cursor:=crHandPoint;
  STCaption:=STC;
  STCaption.Caption:=ParametrCaption;
  STCaption.WordWrap:=True;
  fWindowText:=WT;
  fWindowCaption:=ParametrCaption+WindowCaptionFooter;
  fName:=DoubleConstantSection;
//  HookParameterChange:=TSimpleClass.EmptyProcedure;
  fColorChangeWithParameter:=False;
end;


procedure TParameterShow.ForUseInShowObject(NamedObject: IName;
                                         ColorChanging:boolean=true;
                                         ActiveColor:boolean=false);
begin
 SetName(NamedObject.Name);
 ColorChangeWithParameter:=ColorChanging;
 ColorToActive(ActiveColor);
end;

procedure TParameterShow.ForUseInShowObject(NamedObject: TNamedInterfacedObject;
  ColorChanging, ActiveColor: boolean);
begin
 SetName(NamedObject.Name);
 ColorChangeWithParameter:=ColorChanging;
 ColorToActive(ActiveColor);
end;

procedure TParameterShow.Free;
begin

end;


procedure TParameterShow.ParameterClick(Sender: TObject);
begin
   try
    STData.Caption:=StringToExpectedStringConvertion(InputBox(fWindowCaption,fWindowText,STData.Caption));
    if ColorChangeWithParameter then ColorToActive(false);
  finally
  end;
end;


procedure TParameterShow.SetName(Name: string);
begin
 fName:=Name;
end;

procedure TParameterShow.ColorToActive(Value: boolean);
begin
  if Value then STData.Font.Color:=clPurple
           else STData.Font.Color:=clBlack;
end;

{ TDAC_ShowNew }

constructor TDAC_Show.Create(OI: IDAC;
                                VData, KData: TStaticText;
                                VL, KL: TLabel;
                                VSB, KSB, RB: TButton);
begin
  fOutputInterface:=OI;
  fValueShow:=TDoubleParameterShow.Create(VData,VL,'Output value',0,5);
  fValueShow.ForUseInShowObject(OI);
//  fValueShow.fName:=OI.Name;
//  fValueShow.ColorChangeWithParameter:=true;
//  fValueShow.ColorToActive(false);

  ValueSetButton:=VSB;
  ValueSetButton.OnClick:=ValueSetButtonAction;
  ValueSetButton.Caption:='Set value';
  ResetButton:=RB;
  ResetButton.OnClick:=ResetButtonClick;
  ResetButton.Caption:='Reset';

  fKodShow:=TIntegerParameterShow.Create(KData,KL,'Output code',0);
  fKodShow.ForUseInShowObject(OI);
//  fKodShow.fName:=OI.Name;
//  fKodShow.ColorChangeWithParameter:=true;
//  fKodShow.ColorToActive(false);

  KodSetButton:=KSB;
  KodSetButton.OnClick:=KodSetButtonAction;
  KodSetButton.Caption:='Set code';
end;


procedure TDAC_Show.Free;
begin
 fKodShow.Free;
 fValueShow.Free;
end;

procedure TDAC_Show.KodSetButtonAction(Sender: TObject);
begin
   fOutputInterface.OutputInt(fKodShow.Data);
   fKodShow.ColorToActive(true);
   fValueShow.ColorToActive(false);
end;

procedure TDAC_Show.ReadFromIniFile(ConfigFile: TIniFile);
begin
   fValueShow.ReadFromIniFile(ConfigFile);
   fKodShow.ReadFromIniFile(ConfigFile);
end;

procedure TDAC_Show.ResetButtonClick(Sender: TObject);
begin
 fOutputInterface.Reset();
 fKodShow.ColorToActive(false);
 fValueShow.ColorToActive(false);
end;


procedure TDAC_Show.ValueSetButtonAction(Sender: TObject);
begin
 fOutputInterface.Output(fValueShow.Data);
 fValueShow.ColorToActive(true);
 fKodShow.ColorToActive(false);
end;

procedure TDAC_Show.WriteToIniFile(ConfigFile: TIniFile);
begin
   fValueShow.WriteToIniFile(ConfigFile);
   fKodShow.WriteToIniFile(ConfigFile);
end;


{ TArduinoDACShow }

constructor TArduinoDACShow.Create(ArdDAC: TArduinoDAC;
                                  PinLs: array of TPanel;
                                  PinVariant:TStringList;
                                  VData, KData: TStaticText;
                                  VL, KL: TLabel;
                                  VSB, KSB, RB: TButton);
begin
 inherited Create(ArdDAC,PinLs,PinVariant);
 fDAC_Show:=TDAC_Show.Create(ArdDAC,VData, KData,VL, KL, VSB, KSB, RB);
end;

procedure TArduinoDACShow.Free;
begin
 fDAC_Show.Free;
 inherited Free;
end;

procedure TArduinoDACShow.ReadFromIniFile(ConfigFile: TIniFile);
begin
  inherited ReadFromIniFile(ConfigFile);
  fDAC_Show.ReadFromIniFile(ConfigFile);
end;

procedure TArduinoDACShow.WriteToIniFile(ConfigFile: TIniFile);
begin
  inherited WriteToIniFile(ConfigFile);
  fDAC_Show.WriteToIniFile(ConfigFile);
end;


{ TStringParameterShow }

constructor TStringParameterShow.Create(STD: TStaticText;
                                        STC: TLabel;
                                        ParametrCaption: string;
                                        DataVariants: TStringList);
begin
  inherited Create(STD,STC,ParametrCaption,'');
  fDataVariants:=DataVariants;
  STData.Caption:=fDataVariants.Strings[0];
end;

function TStringParameterShow.GetData: ShortInt;
begin
 Result:=fDataVariants.IndexOf(STData.Caption);
end;

procedure TStringParameterShow.ParameterClick(Sender: TObject);
var
//Form:TForm;
//    ButOk,ButCancel: TButton;
//    RG:TRadioGroup;
    i:ShortInt;
begin

 i:=SelectFromVariants(fDataVariants,Data,fWindowCaption);
 if i>-1 then
   begin
    STData.Caption:=fDataVariants.Strings[i];
    if ColorChangeWithParameter then ColorToActive(false);
   end;
//
//
// Form:=TForm.Create(Application);
// Form.Position:=poMainFormCenter;
// Form.AutoScroll:=True;
// Form.BorderIcons:=[biSystemMenu];
// Form.ParentFont:=True;
// Form.Font.Style:=[fsBold];
// Form.Font.Height:=-16;
//
// Form.Caption:=fWindowCaption;
//
// Form.Color:=clMoneyGreen;
// RG:=TRadioGroup.Create(Form);
// RG.Parent:=Form;
//
// RG.Items:=fDataVariants;
//
// RG.ItemIndex:=Data;
//
//
// if RG.Items.Count>8 then  RG.Columns:=3
//                     else  RG.Columns:=2;
// RG.Width:=RG.Columns*200+20;
// RG.Height:=Ceil(RG.Items.Count/RG.Columns)*50+20;
// Form.Width:=RG.Width;
// Form.Height:=RG.Height+100;
//  RG.Align:=alTop;
//
// ButOk:=TButton.Create(Form);
// ButOk.Parent:=Form;
// ButOk.ParentFont:=True;
// ButOk.Height:=30;
// ButOk.Width:=79;
// ButOk.Caption:='Ok';
// ButOk.ModalResult:=mrOk;
// ButOk.Top:=RG.Height+10;
// ButOk.Left:=round((Form.Width-2*ButOk.Width)/3.0);
//
// ButCancel:=TButton.Create(Form);
// ButCancel.Parent:=Form;
// ButCancel.ParentFont:=True;
// ButCancel.Height:=30;
// ButCancel.Width:=79;
// ButCancel.Caption:='Cancel';
// ButCancel.ModalResult:=mrCancel;
// ButCancel.Top:=RG.Height+10;
// ButCancel.Left:=2*ButOk.Left+ButOk.Width;
//
// if Form.ShowModal=mrOk then
//   begin
//    STData.Caption:=fDataVariants.Strings[RG.ItemIndex];
//    if ColorChangeWithParameter then ColorToActive(false);
//   end;
//
// for I := Form.ComponentCount-1 downto 0 do
//     Form.Components[i].Free;
// Form.Hide;
// Form.Release;
end;

procedure TStringParameterShow.ReadFromIniFile(ConfigFile: TIniFile);
 var i:ShortInt;
begin
 if Name='' then Exit;
 i:=ConfigFile.ReadInteger(fName,STCaption.Caption,0);
 if (i<0) or (i>=fDataVariants.Count) then i:=0;
 STData.Caption:=fDataVariants.Strings[i];
end;

procedure TStringParameterShow.SetData(value: ShortInt);
begin
 if (Value>-1) and (Value<fDataVariants.Count) then
  STData.Caption:=fDataVariants.Strings[Value];
end;

function TStringParameterShow.StringToExpectedStringConvertion(
  str: string): string;
begin
 Result:=str;
end;

procedure TStringParameterShow.WriteToIniFile(ConfigFile: TIniFile);
begin
 if Name='' then Exit;
// showmessage(inttostr(Data));
 WriteIniDef(ConfigFile, fName, STCaption.Caption, Data, -1);
end;

end.
