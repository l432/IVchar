unit ShowTypes;

interface

uses
  StdCtrls, IniFiles, Windows, ComCtrls, SPIdevice, OlegType, Series, 
  Measurement;

const DoubleConstantSection='DoubleConstant';
      NoFile='no file';

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

TLimitShow=class
private
  UpDownHigh,UpDownLow:TUpDown;
//  ValueLabelHigh,ValueLabelLow:TLabel;
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
  Constructor Create(MaxValue:double;
                     DigitNumber:byte;
                     UDH,UDL:TUpDown;
                     VLH,VLL:TLabel);overload;
  Constructor Create(MaxValue:double;
                     DigitNumber:byte;
                     UDH,UDL:TUpDown;
                     VLH,VLL:TLabel;
                     HookFunction:TSimpleEvent);overload;
 procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
 procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
end;

TLimitShowRev=class(TLimitShow)
private
  function GetHighValue():double;override;
  function GetLowValue():double;override;
  function GetValue(UpDown: TUpDown): double;override;
  function GetValueString(UpDown: TUpDown): string;override;
public
end;

//TDependenceMeasuring=class
//private
//  fItIsForward,fIVMeasuringToStop:boolean;
//  fVoltageInput:double;
//  fVoltageInputReal:double;
//  fPointNumber:integer;
//  fDelayTime:double;
//  fHookBeginMeasuring: TSimpleEvent;
//  fHookCycle:TBoolDoubleEvent;
//  fHookStep:TDoubleDoubleEvent;
//  fHookSetVoltage:TBoolDoubleEvent;
////  RangeFor:TLimitShow;
////  RangeRev:TLimitShowRev;
//  CBForw,CBRev: TCheckBox;
//  ProgressBar: TProgressBar;
//  ButtonStop: TButton;
//  Results:PVector;
//  ForwLine: TPointSeries;
//  RevLine: TPointSeries;
//  ForwLg: TPointSeries;
//  RevLg: TPointSeries;
//
//  procedure Cycle(ItIsForward: Boolean; Action: TSimpleEvent);
//  procedure FullCycle(Action: TSimpleEvent);
//  procedure BeginMeasuring();
//  function MeasurementNumberDetermine(): integer;
//  procedure ButtonStopClick(Sender: TObject);
//  procedure ActionMeasurement();
//  procedure SetVoltage();
//public
//  SettingDevice:TSettingDevice;
//  RangeFor:TLimitShow;
//  RangeRev:TLimitShowRev;
//  ButtonSave: TButton;
//  property HookBeginMeasuring:TSimpleEvent read FHookBeginMeasuring write FHookBeginMeasuring;
//  property HookCycle:TBoolDoubleEvent read fHookCycle write fHookCycle;
//  property HookStep:TDoubleDoubleEvent read fHookStep write fHookStep;
//  property HookSetVoltage:TBoolDoubleEvent read fHookSetVoltage write fHookSetVoltage;
//  Constructor Create({RF:TLimitShow;
//                     RR:TLimitShowRev;}
//                     CBF,CBR: TCheckBox;
//                     PB:TProgressBar;
//                     BS,BSave: TButton;
//                     Res:PVector;
//                     FLn,RLn,FLg,RLg:TPointSeries);
//  procedure Measuring();
//end;

function LastFileName(Mask:string):string;
{повертає назву (повну, з розширенням) останього файлу в
поточному каталозі, чия назва задовольняє маску Mask}

function LastDATFileName():string;
{повертає назву (коротку) останього .dat файлу в
поточному каталозі}

Procedure MelodyShot();

Procedure MelodyLong();

implementation

uses
  Dialogs, SysUtils, Math, Forms;

{ TDoubleConstantShow }

procedure TDoubleConstantShow.ButtonClick(Sender: TObject);
 var value:string;
begin
 if InputQuery(Caption, Hint, value) then
  begin
    try
      Lab.Caption:=FloatToStrF(StrToFloat(value),ffExponent, 3, 2);
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
                          ffExponent, 3, 2);
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

{ LimitShow }

constructor TLimitShow.Create(MaxValue:double;
                     DigitNumber:byte;
                     UDH,UDL:TUpDown;
                     VLH,VLL:TLabel);
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
end;

constructor TLimitShow.Create(MaxValue: double; DigitNumber: byte; UDH,
  UDL: TUpDown; VLH, VLL: TLabel; HookFunction: TSimpleEvent);
begin
 Create(MaxValue,DigitNumber,UDH,UDL,VLH, VLL);
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

procedure TLimitShow.ReadFromIniFile(ConfigFile: TIniFile; const Section,
  Ident: string);
  var temp:Smallint;
begin

  temp:=ConfigFile.ReadInteger(Section,Ident+'Max',UpDownHigh.Max);
  if (temp>UpDownHigh.Max)or(temp<0) then  temp:=UpDownHigh.Max;
  UpDownHigh.Position:=temp;

  temp:=ConfigFile.ReadInteger(Section,Ident+'Min',0);
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

procedure TLimitShow.WriteToIniFile(ConfigFile: TIniFile; const Section,
  Ident: string);
begin
//    ConfigFile.EraseSection(Section);
    WriteIniDef(ConfigFile,Section,Ident+'Max',UpDownHigh.Position,UpDownHigh.Max);
    WriteIniDef(ConfigFile,Section,Ident+'Min',UpDownLow.Position,0);
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
