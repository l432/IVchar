unit ShowTypes;

interface

uses
  StdCtrls, IniFiles, Windows, ComCtrls, SPIdevice, OlegType, Series, 
  Measurement;

const DoubleConstantSection='DoubleConstant';
      NoFile='no file';
      RangeSection='Range';

type
TDoubleConstantShow=class
private
    FHint: string;
    FCaption: string;
    Lab:TLabel;
    Button:TButton;
    FDefaulValue: double;
    procedure SetCaption(const Value: string);
    procedure SetHint(const Value: string);
    procedure ButtonClick(Sender: TObject);
    procedure SetDefaulValue(const Value: double);
public
 property Caption:string read FCaption write SetCaption;
 property Hint:string read FHint write SetHint;
 property DefaulValue:double read FDefaulValue write SetDefaulValue;
 Constructor Create(L:TLabel;
                    B:TButton;
                    Cap,H:string;
                    DV:double);
 procedure ReadFromIniFile(ConfigFile:TIniFile);
 procedure WriteToIniFile(ConfigFile:TIniFile);
 function GetValue:double;
end;

  TParameterShow1=class
//  дл€ в≥дображенн€ на форм≥
//  а) значенн€ параметру
//  б) його назви
//кл≥к на значенн≥ викликаЇ по€ву в≥конц€ дл€ його зм≥ни
   private
    STData:TStaticText; //величина параметру
    fWindowCaption:string; //назва в≥конц€ зм≥ни параметра
    fWindowText:string;  //текст у цьому в≥конц≥
    FDefaulValue:double;
    fDigitNumber:byte;
    procedure ButtonClick(Sender: TObject);
    function GetData:double;
    procedure SetData(value:double);
    procedure SetDefaulValue(const Value: double);
    function ValueToString(Value:double):string;
   public
    STCaption:TLabel;
    property DefaulValue:double read FDefaulValue write SetDefaulValue;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       {WC,}WT:string;
                       InitValue:double;
                       DN:byte=3
    );
    property Data:double read GetData write SetData;
    procedure ReadFromIniFile(ConfigFile:TIniFile);
    procedure WriteToIniFile(ConfigFile:TIniFile);
    procedure Free;
  end;  //   TParameterShow=object


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
  Dialogs, SysUtils, Math, Controls;

{ TDoubleConstantShow }

procedure TDoubleConstantShow.ButtonClick(Sender: TObject);
 var value:string;
begin
 if InputQuery(Caption, Hint, value) then
  begin
    try
      Lab.Caption:=FloatToStrF(StrToFloat(value),ffExponent, 4, 3);
    except

    end;
  end;
end;

constructor TDoubleConstantShow.Create(L: TLabel; B: TButton;
  Cap, H: string;DV:double);
begin
  Lab:=L;
  Button:=B;
  FCaption:=Cap;
  FHint:=H;
  Button.OnClick:=ButtonClick;
  DefaulValue:=DV;
end;

function TDoubleConstantShow.GetValue: double;
begin
 try
  Result:=StrToFloat(Lab.Caption);
 except
  Result:=DefaulValue;
 end;
end;

procedure TDoubleConstantShow.ReadFromIniFile(ConfigFile: TIniFile);
begin
 Lab.Caption:=FloatToStrF(ConfigFile.ReadFloat(DoubleConstantSection, Caption,DefaulValue),
                          ffExponent, 4, 3);
end;

procedure TDoubleConstantShow.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TDoubleConstantShow.SetDefaulValue(const Value: double);
begin
  FDefaulValue := Value;
end;

procedure TDoubleConstantShow.SetHint(const Value: string);
begin
  FHint := Value;
end;

procedure TDoubleConstantShow.WriteToIniFile(ConfigFile: TIniFile);
begin
 WriteIniDef(ConfigFile, DoubleConstantSection, Caption, StrToFloat(Lab.Caption),DefaulValue)
end;

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


Constructor TParameterShow1.Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WT:string;
                       InitValue:double;
                       DN:byte=3
                       );
begin
  inherited Create;
  fDigitNumber:=DN;

  STData:=STD;
  STData.Caption:=ValueToString(InitValue);
  STData.OnClick:=ButtonClick;
  STData.Cursor:=crHandPoint;
  STCaption:=STC;
  STCaption.Caption:=ParametrCaption;
  STCaption.WordWrap:=True;
  fWindowCaption:=ParametrCaption+' input';
  fWindowText:=WT;
  DefaulValue:=InitValue;
end;

procedure TParameterShow1.Free;
begin

end;

procedure TParameterShow1.ButtonClick(Sender: TObject);
 var temp:double;
     st:string;
begin
  st:=InputBox(fWindowCaption,fWindowText,STData.Caption);
  try
    temp:=StrToFloat(st);
    STData.Caption:=ValueToString(temp);
  finally
  end;
end;

function TParameterShow1.GetData:double;
begin
 Result:=StrToFloat(STData.Caption);
end;

procedure TParameterShow1.SetData(value:double);
begin
  try
    STData.Caption:=ValueToString(value);
  finally

  end;
end;

procedure TParameterShow1.ReadFromIniFile(ConfigFile:TIniFile);
begin
 STData.Caption:=ValueToString(ConfigFile.ReadFloat(DoubleConstantSection,STCaption.Caption,DefaulValue));
end;

procedure TParameterShow1.WriteToIniFile(ConfigFile:TIniFile);
begin
 WriteIniDef(ConfigFile, DoubleConstantSection, STCaption.Caption, StrToFloat(STData.Caption),DefaulValue)
end;

procedure TParameterShow1.SetDefaulValue(const Value: double);
begin
  FDefaulValue := Value;
end;

function TParameterShow1.ValueToString(Value:double):string;
begin
  if (Frac(Value)=0)and(Int(Value/Power(10,fDigitNumber+1))=0)
    then Result:=FloatToStrF(Value,ffGeneral,fDigitNumber,fDigitNumber-1)
    else Result:=FloatToStrF(Value,ffExponent,fDigitNumber,fDigitNumber-1);
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

 
end.
