unit ShowTypes;

interface

uses
  StdCtrls, IniFiles, Windows, ComCtrls, ArduinoDevice, OlegType, {Series,}
  Measurement, ExtCtrls, Classes, ArduinoDeviceShow, {TeCanvas,} OlegTypePart2, OlegShowTypes;


type


TLimitShow=class(TNamedInterfacedObject)
//TLimitShow=class
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
 procedure ReadFromIniFile(ConfigFile: TIniFile);override;
 procedure WriteToIniFile(ConfigFile: TIniFile);override;
end;

TLimitShowRev=class(TLimitShow)
private
  function GetHighValue():double;override;
  function GetLowValue():double;override;
  function GetValue(UpDown: TUpDown): double;override;
  function GetValueString(UpDown: TUpDown): string;override;
public
end;

TDAC_Show=class(TSimpleFreeAndAiniObject)
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
    procedure ReadFromIniFile(ConfigFile:TIniFile);override;//virtual;
    procedure WriteToIniFile(ConfigFile:TIniFile);override;//virtual;
    procedure Free;override;
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
{повертає назву (повну, з розширенням) останього файлу в
поточному каталозі, чия назва задовольняє маску Mask}

function LastDATFileName(prefix:string=''):string;
{повертає назву (коротку) останього 'prefix*.dat' файлу в
поточному каталозі}

function NextDATFileName(LastDatFileName:string):string;
{повертає повну назву (з .dat) файлу, який має бути
наступтим після  LastDatFileName}


Procedure MelodyShot();

Procedure MelodyLong();



implementation

uses
  {Dialogs,} SysUtils, Math, Dialogs, OlegFunction{, Controls, Graphics, Forms, OlegFunction};


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

function LastDATFileName(prefix:string=''):string;
begin
  Result:=LastFileName(prefix+'*.dat');
  if Result<>NoFile then
   Result:=Copy(Result,1,Length(Result)-4);
end;

function NextDATFileName(LastDatFileName:string):string;
 var prefix:string;
begin
  prefix:='';
  Result:='';
  if LastDatFileName <> NoFile then
   begin
    while (length(LastDatFileName)>0) do
     begin
       try
       Result:=IntToStr(StrToInt(LastDatFileName) + 1);
       Delete(LastDatFileName,1,length(LastDatFileName));
       except
        prefix:=prefix+Copy(LastDatFileName,1,1);
        Delete(LastDatFileName,1,1);
       end;
     end;
   end;
  if Result='' then Result:='1';
  Result:=prefix+Result+'.dat';
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
//  showmessage(Name);
//  temp:=ConfigFile.ReadInteger(RangeSection,fName+'Max',UpDownHigh.Max);
  temp:=ConfigFile.ReadInteger(fName,fName+'Max',UpDownHigh.Max);
  if (temp>UpDownHigh.Max)or(temp<0) then  temp:=UpDownHigh.Max;
  UpDownHigh.Position:=temp;

//  temp:=ConfigFile.ReadInteger(RangeSection,fName+'Min',0);
  temp:=ConfigFile.ReadInteger(fName,fName+'Min',0);
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
    WriteIniDef(ConfigFile,fName,fName+'Max',UpDownHigh.Position,UpDownHigh.Max);
    WriteIniDef(ConfigFile,fName,fName+'Min',UpDownLow.Position,0);
//    WriteIniDef(ConfigFile,RangeSection,fName+'Max',UpDownHigh.Position,UpDownHigh.Max);
//    WriteIniDef(ConfigFile,RangeSection,fName+'Min',UpDownLow.Position,0);
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



{ TDAC_ShowNew }

constructor TDAC_Show.Create(OI: IDAC;
                                VData, KData: TStaticText;
                                VL, KL: TLabel;
                                VSB, KSB, RB: TButton);
begin
  fOutputInterface:=OI;
  fValueShow:=TDoubleParameterShow.Create(VData,VL,'Output value',0,5);
  fValueShow.ForUseInShowObject(OI);

  ValueSetButton:=VSB;
  ValueSetButton.OnClick:=ValueSetButtonAction;
  ValueSetButton.Caption:='Set value';
  ResetButton:=RB;
  ResetButton.OnClick:=ResetButtonClick;
  ResetButton.Caption:='Reset';

  fKodShow:=TIntegerParameterShow.Create(KData,KL,'Output code',0);
  fKodShow.ForUseInShowObject(OI);

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
//   HelpForMe(fOutputInterface.Name);
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


//{ TStringParameterShow }
//
//constructor TStringParameterShow.Create(STD: TStaticText;
//                                        STC: TLabel;
//                                        ParametrCaption: string;
//                                        DataVariants: TStringList);
//begin
//  inherited Create(STD,STC,ParametrCaption,'');
//  CreateFooter(DataVariants);
//end;
//
//constructor TStringParameterShow.Create(STD: TStaticText;
//  ParametrCaption: string; DataVariants: TStringList);
//begin
//  inherited Create(STD,ParametrCaption,'');
//  CreateFooter(DataVariants);
//end;
//
//procedure TStringParameterShow.CreateFooter(DataVariants: TStringList);
//begin
//  fDataVariants := DataVariants;
//  STData.Caption := fDataVariants.Strings[0];
//end;
//
//function TStringParameterShow.GetData: ShortInt;
//begin
// Result:=fDataVariants.IndexOf(STData.Caption);
//end;
//
//procedure TStringParameterShow.ParameterClick(Sender: TObject);
//var
//    i:ShortInt;
//begin
//
// i:=SelectFromVariants(fDataVariants,Data,fWindowCaption);
// if i>-1 then
//   begin
//    STData.Caption:=fDataVariants.Strings[i];
//    if ColorChangeWithParameter then ColorToActive(false);
//    HookParameterClick;
//   end;
//
//end;
//
//function TStringParameterShow.ReadStringValueFromIniFile(ConfigFile: TIniFile;
//  NameIni: string): string;
// var i:ShortInt;
//begin
// i:=ConfigFile.ReadInteger(fName,NameIni,0);
// if (i<0) or (i>=fDataVariants.Count) then i:=0;
// Result:=fDataVariants.Strings[i];
//end;
//
//procedure TStringParameterShow.SetData(value: ShortInt);
//begin
// if (Value>-1) and (Value<fDataVariants.Count) then
//  STData.Caption:=fDataVariants.Strings[Value];
//end;
//
//function TStringParameterShow.StringToExpectedStringConvertion(
//  str: string): string;
//begin
// Result:=str;
//end;
//
//procedure TStringParameterShow.WriteNumberToIniFile(ConfigFile: TIniFile;
//  NameIni: string);
//begin
// WriteIniDef(ConfigFile, fName, NameIni, Data, -1);
//end;
//
//{ TParameterShowArray }
//
//procedure TParameterShowArray.ColorToActive(Value: boolean);
// var     I:byte;
//begin
// for I := 0 to High(fParameterShowArray) do
//   fParameterShowArray[i].ColorToActive(Value);
//end;
//
//constructor TParameterShowArray.Create(PSA: array of TParameterShowNew);
// var     i:byte;
//begin
// SetLength(fParameterShowArray,High(PSA)+1);
// for I := 0 to High(PSA) do
//   fParameterShowArray[i]:=PSA[i];
//end;
//
//
//procedure TParameterShowArray.ForUseInShowObject(
//       NamedObject: TNamedInterfacedObject);
// var     I:byte;
//begin
// for I := 0 to High(fParameterShowArray) do
//   fParameterShowArray[i].ForUseInShowObject(NamedObject);
//end;
//
//procedure TParameterShowArray.Free;
// var     I:byte;
//begin
// for I := 0 to High(fParameterShowArray) do
//   fParameterShowArray[i].Free;
// inherited Free;
//end;
//
//function TParameterShowArray.GetCount: integer;
//begin
// Result:=High(fParameterShowArray)+1;
//end;
//
//procedure TParameterShowArray.ReadFromIniFile(ConfigFile: TIniFile);
// var     I:byte;
//begin
// for I := 0 to High(fParameterShowArray) do
//   fParameterShowArray[i].ReadFromIniFile(ConfigFile);
//end;
//
//procedure TParameterShowArray.WriteToIniFile(ConfigFile: TIniFile);
// var     I:byte;
//begin
// for I := 0 to High(fParameterShowArray) do
//   fParameterShowArray[i].WriteToIniFile(ConfigFile);
//end;


end.
