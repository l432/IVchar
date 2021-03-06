unit ShowTypes;

interface

uses
  StdCtrls, IniFiles, Windows, ComCtrls,  OlegType,
  Measurement, ExtCtrls, Classes, OlegTypePart2, OlegShowTypes,
  ArduinoDeviceShow, ArduinoDeviceNew;


type


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
//   fOutputInterface: IDAC;
   fOutputInterface: pointer;
   fValueShow:TDoubleParameterShow;
   fKodShow:TIntegerParameterShow;
   ValueSetButton,KodSetButton,ResetButton:TButton;
   procedure ValueSetButtonAction(Sender:TObject);
   procedure KodSetButtonAction(Sender:TObject);
   procedure ResetButtonClick(Sender:TObject);
   function GetDAC:IDAC;
  public
   property DAC:IDAC read GetDAC;
   Constructor Create(const OI: IDAC;
                      VData,KData:TStaticText;
                      VL, KL: TLabel;
                      VSB, KSB, RB: TButton);
   procedure ReadFromIniFile(ConfigFile:TIniFile);override;//virtual;
   procedure WriteToIniFile(ConfigFile:TIniFile);override;//virtual;
//    procedure Free;//override;
   destructor Destroy;override;
end;


  TArduinoDACShow=class(TArduinoSetterShow)
  private
   fDAC_Show:TDAC_Show;
  public
   Constructor Create(ArdDAC:TArduinoDACbase;
                       PinLs: array of TPanel;
                       PinVariant:TStringList;
                       VData,KData:TStaticText;
                       VL, KL: TLabel;
                       VSB, KSB, RB: TButton);
//   Procedure Free;//override;
   destructor Destroy;override;
   Procedure HookReadFromIniFile(ConfigFile:TIniFile);override;
   Procedure WriteToIniFile(ConfigFile:TIniFile);override;
  end;

function LastFileName(Mask:string):string;
{������� ����� (�����, � �����������) ��������� ����� �
��������� �������, ��� ����� ����������� ����� Mask}

function LastDATFileName(prefix:string=''):string;
{������� ����� (�������) ��������� 'prefix*.dat' ����� �
��������� �������}

function NextDATFileName(LastDatFileName:string):string;
{������� ����� ����� (� .dat) �����, ���� �� ����
��������� ����  LastDatFileName}


Procedure MelodyShot();

Procedure MelodyLong();



implementation

uses
  SysUtils, Math;


function LastFileName(Mask:string):string;
 var SR : TSearchRec;
     tm:integer;
begin
 Result:=NoFile;
 if FindFirst(Mask, faAnyFile, SR) <> 0 then Exit;
 if AnsiPos('comments',SR.name)<>0 then
    if FindNext(SR) <> 0 then Exit;


 Result:=SR.name;
 tm:=SR.time;
 while FindNext(SR) = 0 do
   begin
   if AnsiPos('comments',SR.name)<>0 then Continue;
   if tm<SR.time then
     begin
     Result:=SR.name;
     tm:=SR.time;
     end;
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
  temp:=ConfigFile.ReadInteger(fName,fName+'Max',UpDownHigh.Max);
  if (temp>UpDownHigh.Max)or(temp<0) then  temp:=UpDownHigh.Max;
  UpDownHigh.Position:=temp;

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
    ConfigFile.EraseSection(fName);
    WriteIniDef(ConfigFile,fName,fName+'Max',UpDownHigh.Position,UpDownHigh.Max);
    WriteIniDef(ConfigFile,fName,fName+'Min',UpDownLow.Position,0);
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

constructor TDAC_Show.Create(const OI: IDAC;
                                VData, KData: TStaticText;
                                VL, KL: TLabel;
                                VSB, KSB, RB: TButton);
begin
//  fOutputInterface:=OI;
  fOutputInterface:=pointer(OI);
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


//procedure TDAC_Show.Free;
//begin
// fKodShow.Free;
// fValueShow.Free;
//end;

destructor TDAC_Show.Destroy;
begin
 fKodShow.Free;
 fValueShow.Free;
 inherited;
end;

function TDAC_Show.GetDAC: IDAC;
begin
 Result:=IDAC(fOutputInterface);
end;

procedure TDAC_Show.KodSetButtonAction(Sender: TObject);
begin
//   fOutputInterface.OutputInt(fKodShow.Data);
   DAC.OutputInt(fKodShow.Data);
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
// fOutputInterface.Reset();
 DAC.Reset();
 fKodShow.ColorToActive(false);
 fValueShow.ColorToActive(false);
end;


procedure TDAC_Show.ValueSetButtonAction(Sender: TObject);
begin
// fOutputInterface.Output(fValueShow.Data);
 DAC.Output(fValueShow.Data);
 fValueShow.ColorToActive(true);
 fKodShow.ColorToActive(false);
end;

procedure TDAC_Show.WriteToIniFile(ConfigFile: TIniFile);
begin
   fValueShow.WriteToIniFile(ConfigFile);
   fKodShow.WriteToIniFile(ConfigFile);
end;



{ TArduinoDACShowNew }

constructor TArduinoDACShow.Create(ArdDAC: TArduinoDACbase;
                                      PinLs: array of TPanel;
                                      PinVariant: TStringList;
                                      VData, KData: TStaticText;
                                      VL, KL: TLabel;
                                      VSB, KSB, RB: TButton);
begin
 inherited Create(ArdDAC,PinLs,PinVariant);
 fDAC_Show:=TDAC_Show.Create(ArdDAC,VData, KData,VL, KL, VSB, KSB, RB);
end;

//procedure TArduinoDACShow.Free;
//begin
// fDAC_Show.Free;
// inherited Free;
//end;

destructor TArduinoDACShow.Destroy;
begin
 fDAC_Show.Free;
 inherited;
end;

procedure TArduinoDACShow.HookReadFromIniFile(ConfigFile: TIniFile);
begin
  inherited HookReadFromIniFile(ConfigFile);
  fDAC_Show.ReadFromIniFile(ConfigFile);
end;

procedure TArduinoDACShow.WriteToIniFile(ConfigFile: TIniFile);
begin
  inherited WriteToIniFile(ConfigFile);
  fDAC_Show.WriteToIniFile(ConfigFile);
end;

end.
