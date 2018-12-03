unit ShowTypes;

interface

uses
  StdCtrls, IniFiles, Windows, ComCtrls, SPIdevice, OlegType, Series,
  Measurement, ExtCtrls, Classes;

const DoubleConstantSection='DoubleConstant';
      NoFile='no file';
      RangeSection='Range';
      WindowCaptionFooter=' input';
      WindowTextFooter=' value is expected';

type

  TParameterShow=class (TNamedInterfacedObject)
{  дл€ в≥дображенн€ на форм≥
  а) значенн€ параметру
  б) його назви
  кл≥к на значенн≥ викликаЇ по€ву в≥конц€ дл€ його зм≥ни,
  базовий клас, дл€ збереженн€ параметр≥в р≥зних тип≥в
  див. нащадк≥в}
   private
//    STData:TStaticText; //величина параметру
    fHookParameterChange: TSimpleEvent;
    fWindowCaption:string; //назва в≥конц€ зм≥ни параметра
    fWindowText:string;  //текст у в≥конц≥ зм≥ни параметру
    function StringToExpectedStringConvertion(str:string):string;virtual;abstract;
    {перетворенн€ str в р€док, де число
    у потр≥бному формат≥,
    можлив≥ помилки не в≥дловлюютьс€, див. ParameterClick}
    procedure ParameterClick(Sender: TObject);
   public
    STData:TStaticText; //величина параметру
    STCaption:TLabel; //назва параметру
    property HookParameterChange:TSimpleEvent read FHookParameterChange write FHookParameterChange;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WT:string);//overload;
    procedure ReadFromIniFile(ConfigFile:TIniFile);virtual;abstract;
    procedure WriteToIniFile(ConfigFile:TIniFile);virtual;abstract;
    procedure Free;
  end;  //   TParameterShow=object

//  TDoubleParameterShow=class (TNamedInterfacedObject)
  TDoubleParameterShow=class (TParameterShow)
   private
//    STData:TStaticText; //величина параметру
//    fWindowCaption:string; //назва в≥конц€ зм≥ни параметра
//    fWindowText:string;  //текст у в≥конц≥ зм≥ни параметру
    FDefaulValue:double;
    fDigitNumber:byte;
    function StringToExpectedStringConvertion(str:string):string;override;
//    procedure ParameterClick(Sender: TObject);
    function GetData:double;
    procedure SetData(value:double);
    procedure SetDefaulValue(const Value: double);
    function ValueToString(Value:double):string;
   public
//    STCaption:TLabel;
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
//    procedure Free;
  end;  //   TDoubleParameterShow=object

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
//    procedure Free;
  end;  //   TIntegerParameterShow=object


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

TDAC_ShowNew=class
  private
   fOutputInterface: IDAC;
   fValueShow:TDoubleParameterShow;
   fKodShow:TIntegerParameterShow;
   ValueSetButton,KodSetButton,ResetButton:TButton;
//   procedure ValueChangeButtonAction(Sender:TObject);
   procedure ValueSetButtonAction(Sender:TObject);
//   procedure KodChangeButtonAction(Sender:TObject);
   procedure KodSetButtonAction(Sender:TObject);
   procedure ResetButtonClick(Sender:TObject);
   procedure ValueColorToNonActive();
   procedure KodColorToNonActive();
   procedure ValueColorToActive();
   procedure KodColorToActive();
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
//   procedure CreatePinShow(PinLs: array of TPanel);
   fDAC_Show:TDAC_ShowNew;
  public
   Constructor Create(ArdDAC:TArduinoDAC;
                       PinLs: array of TPanel;
                       PinVariant:TStringList;
                       VData,KData:TStaticText;
                       VL, KL: TLabel;
                       VSB, KSB, RB: TButton);
   Procedure Free;
   procedure ReadFromIniFile(ConfigFile:TIniFile);override;
//   procedure ReadFromIniFileAndToForm(ConfigFile:TIniFile);
   Procedure WriteToIniFile(ConfigFile:TIniFile);override;
  end;

function LastFileName(Mask:string):string;
{повертаЇ назву (повну, з розширенн€м) останього файлу в
поточному каталоз≥, чи€ назва задовольн€Ї маску Mask}

function LastDATFileName():string;
{повертаЇ назву (коротку) останього .dat файлу в
поточному каталоз≥}

Procedure MelodyShot();

Procedure MelodyLong();



implementation

uses
  Dialogs, SysUtils, Math, Controls, Graphics;


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


//  inherited Create;
//  fDigitNumber:=DN;
//
//  STData:=STD;
//  STData.Caption:=ValueToString(InitValue);
//  STData.OnClick:=ParameterClick;
//  STData.Cursor:=crHandPoint;
//  STCaption:=STC;
//  STCaption.Caption:=ParametrCaption;
//  STCaption.WordWrap:=True;
//  fWindowText:=WT;
//  fWindowCaption:=ParametrCaption+WindowCaptionFooter;
//  DefaulValue:=InitValue;
//  fName:=DoubleConstantSection;
end;

constructor TDoubleParameterShow.Create(STD: TStaticText;
                                        STC: TLabel;
                                        ParametrCaption: string;
                                        InitValue: double;
                                        DN: byte);
begin
 Create(STD,STC,ParametrCaption,ParametrCaption+WindowTextFooter,InitValue,DN);
end;

//procedure TDoubleParameterShow.Free;
//begin
//
//end;

//procedure TDoubleParameterShow.ParameterClick(Sender: TObject);
//// var temp:double;
////     st:string;
//begin
////  st:=InputBox(fWindowCaption,
////               fWindowText,STData.Caption);
//  try
////    temp:=StrToFloat(st);
////    STData.Caption:=ValueToString(temp);
//    STData.Caption:=ValueToString(StrToFloat
//        (InputBox(fWindowCaption,fWindowText,STData.Caption)));
//  finally
//  end;
//end;

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
//  STData.Caption:=ValueToString(InitValue);
  STData.OnClick:=ParameterClick;
  STData.Cursor:=crHandPoint;
  STCaption:=STC;
  STCaption.Caption:=ParametrCaption;
  STCaption.WordWrap:=True;
  fWindowText:=WT;
  fWindowCaption:=ParametrCaption+WindowCaptionFooter;
//  DefaulValue:=InitValue;
  fName:=DoubleConstantSection;
  HookParameterChange:=TSimpleClass.EmptyProcedure;
end;


procedure TParameterShow.Free;
begin

end;


procedure TParameterShow.ParameterClick(Sender: TObject);
begin
   try
    STData.Caption:=StringToExpectedStringConvertion(InputBox(fWindowCaption,fWindowText,STData.Caption));
    HookParameterChange;
  finally
  end;
end;


{ TDAC_ShowNew }

constructor TDAC_ShowNew.Create(OI: IDAC;
                                VData, KData: TStaticText;
                                VL, KL: TLabel;
                                VSB, KSB, RB: TButton);
begin
  fOutputInterface:=OI;
  fValueShow:=TDoubleParameterShow.Create(VData,VL,'Output value',0,5);
  fValueShow.fName:=OI.Name;
  ValueColorToNonActive();
//  fValueShow.STData.Font.Color:=clBlack;
  fValueShow.HookParameterChange:=ValueColorToNonActive;

//  ValueChangeButton:=VCB;
//  ValueChangeButton.OnClick:=ValueChangeButtonAction;
  ValueSetButton:=VSB;
  ValueSetButton.OnClick:=ValueSetButtonAction;
  ValueSetButton.Caption:='Set value';
  ResetButton:=RB;
  ResetButton.OnClick:=ResetButtonClick;
  ResetButton.Caption:='Reset';

  fKodShow:=TIntegerParameterShow.Create(KData,KL,'Output code',0);
  fKodShow.fName:=OI.Name;
  KodColorToNonActive();
//  fKodShow.STData.Font.Color:=clBlack;
  fKodShow.HookParameterChange:=KodColorToNonActive;

//  KodChangeButton:=KCB;
//  KodChangeButton.OnClick:=KodChangeButtonAction;
  KodSetButton:=KSB;
  KodSetButton.OnClick:=KodSetButtonAction;
  KodSetButton.Caption:='Set code';
end;

//procedure TDAC_ShowNew.KodChangeButtonAction(Sender: TObject);
//begin
//
//end;

procedure TDAC_ShowNew.Free;
begin
 fKodShow.Free;
 fValueShow.Free;
end;

procedure TDAC_ShowNew.KodColorToActive;
begin
 fKodShow.STData.Font.Color:=clPurple;
end;

procedure TDAC_ShowNew.KodColorToNonActive;
begin
 fKodShow.STData.Font.Color:=clBlack;
end;

procedure TDAC_ShowNew.KodSetButtonAction(Sender: TObject);
begin
   fOutputInterface.OutputInt(fKodShow.Data);
   KodColorToActive();
   ValueColorToNonActive();
end;

procedure TDAC_ShowNew.ReadFromIniFile(ConfigFile: TIniFile);
begin
   fValueShow.ReadFromIniFile(ConfigFile);
   fKodShow.ReadFromIniFile(ConfigFile);
end;

procedure TDAC_ShowNew.ResetButtonClick(Sender: TObject);
begin
 fOutputInterface.Reset();
 KodColorToNonActive();
 ValueColorToNonActive();
end;

//procedure TDAC_ShowNew.ValueChangeButtonAction(Sender: TObject);
//begin
//
//end;

procedure TDAC_ShowNew.ValueColorToActive;
begin
 fValueShow.STData.Font.Color:=clPurple;
end;

procedure TDAC_ShowNew.ValueColorToNonActive;
begin
 fValueShow.STData.Font.Color:=clBlack;
end;

procedure TDAC_ShowNew.ValueSetButtonAction(Sender: TObject);
begin
 fOutputInterface.Output(fValueShow.Data);
 ValueColorToActive();
 KodColorToNonActive();
end;

procedure TDAC_ShowNew.WriteToIniFile(ConfigFile: TIniFile);
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
// PinShow.HookNumberPinShow:=ArdDAC.PinsToDataArray;
 fDAC_Show:=TDAC_ShowNew.Create(ArdDAC,VData, KData,VL, KL, VSB, KSB, RB);
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


end.
