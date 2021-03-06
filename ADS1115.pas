unit ADS1115;

interface

uses
  StdCtrls, ExtCtrls, ArduinoADC, Classes, MDevice, 
  ArduinoDeviceShow, ArduinoDeviceNew, PacketParameters;

type

 TADS1115_ChanelNumber=0..2;
 TADS1115_Gain=(ads_g2_3, // +/-6.144V range = Gain 2/3
                ads_g1,   // +/-4.096V range = Gain 1
                ads_g2,  // +/-2.048V range = Gain 2
                ads_g4,  // +/-1.024V range = Gain 4
                ads_g8,  // +/-0.512V range = Gain 8
                ads_g16);  // +/-0.256V range = Gain 16

 TADS1115_DataRate=(ads_dr8, // 8 samples per second
                    ads_dr16,  // 16 samples per second
                    ads_dr32,  // 32 samples per second
                    ads_dr64,  // 64 samples per second
                    ads_dr128, // 128 samples per second
                    ads_dr250, // 250 samples per second
                    ads_dr475,// 475 samples per second
                    ads_dr860);// 860 samples per second

const

 ADS1115_ConversionTime:array[TADS1115_DataRate]of integer=
    (120,58,28,14,7,4,2,1);

 ADS1115_Gain_Data:array[TADS1115_Gain]of double=
    (1.5,1,0.5,0.25,0.125,0.0625);
 ADS1115_Gain_Kod:array[TADS1115_Gain]of byte=
    ($00,$02,$04,$06,$08,$0A);
 ADS1115_Diapazons:array[TADS1115_Gain]of string=
    ('6.144','4.096','2.048','1.024','0.512','0.256');
 ADS1115_LSB_labels:array[TADS1115_Gain]of string=
    ('200','125','63','32','16','8');


 ADS1115_DataRate_Kod:array[TADS1115_DataRate]of byte=
    ($00,$20,$40,$60,$80,$A0,$C0,$E0);
 ADS1115_DataRate_Label:array[TADS1115_DataRate]of string=
   (' 8 SPS','16 SPS','32 SPS','64 SPS',
   '128 SPS','250 SPS','475 SPS','860 SPS');

 ADS1115_Chanel_Kod:array[TADS1115_ChanelNumber]of byte=
    ($40,$50,$30);

 ADS1115_LSB=125e-6;
 ADS1115_StartAdress=$48;
 ADS1115_LastAdress=$4B;

  ADS1115_CalibrateB:array[TADS1115_ChanelNumber]
            of array[TADS1115_Gain]
            of array[TADS1115_DataRate] of double=
            (
        {ads_dr8, ads_dr16, ads_dr32, ads_dr64,
        ads_dr128, ads_dr250, ads_dr475, ads_dr860}
  {Chanel 0}
          (
{ads_g2_3}(1.00026,1.00031,1.00032,1.00034,
           1.00036,1.00038,1.00034,1.00038),
{ads_g1}  (1.00026,1.00031,1.00032,1.00034,
           1.00036,1.00038,1.00034,1.00038),
{ads_g2}  (1.00037, 1.00039,1.00045,1.00047,
           1.00046,1.0005,1.00046,1.00047),
{ads_g4}  (1.00057,1.00061,1.00064,1.00064,
           1.0006, 1.00068,1.00059,1.00059),
{ads_g8}  (1.00057,1.00061,1.00064,1.00064,
           1.0006, 1.00068,1.00059,1.00059),
{ads_g16} (1.00057,1.00061,1.00064,1.00064,
           1.0006, 1.00068,1.00059,1.00059)),

  {Chanel 1}
          (
{ads_g2_3}(1.00035,1.00033,1.00027,1.00025,
           1.00019,1.00022,1.00028,1.00029),
{ads_g1}  (1.00035,1.00033,1.00027,1.00025,
           1.00019,1.00022,1.00028,1.00029),
{ads_g2}  (1.00035,1.00033,1.00027,1.00025,
           1.00019,1.00022,1.00028,1.00029),
{ads_g4}  (1.00035,1.00033,1.00027,1.00025,
           1.00019,1.00022,1.00028,1.00029),
{ads_g8}  (1.00035,1.00033,1.00027,1.00025,
           1.00019,1.00022,1.00028,1.00029),
{ads_g16} (1.00035,1.00033,1.00027,1.00025,
           1.00019,1.00022,1.00028,1.00029)),

  {Chanel 2}
          (
{ads_g2_3}(1.00026,1.00031,1.00032,1.00034,
           1.00036,1.00038,1.00034,1.00038),
{ads_g1}  (1.00026,1.00031,1.00032,1.00034,
           1.00036,1.00038,1.00034,1.00038),
{ads_g2}  (1.00037, 1.00039,1.00045,1.00047,
           1.00046,1.0005,1.00046,1.00047),
{ads_g4}  (1.00057,1.00061,1.00064,1.00064,
           1.0006, 1.00068,1.00059,1.00059),
{ads_g8}  (1.00057,1.00061,1.00064,1.00064,
           1.0006, 1.00068,1.00059,1.00059),
{ads_g16} (1.00057,1.00061,1.00064,1.00064,
           1.0006, 1.00068,1.00059,1.00059))
               );

  ADS1115_CalibrateA:array[TADS1115_ChanelNumber]
            of array[TADS1115_Gain] of double=
            (
  {Chanel 0}
          (
{ads_g2_3}1,
{ads_g1}  1,
{ads_g2}  2,
{ads_g4}  3,
{ads_g8}  7,
{ads_g16} 14),

  {Chanel 1}
          (
{ads_g2_3}1,
{ads_g1}  1,
{ads_g2}  2,
{ads_g4}  4,
{ads_g8}  8,
{ads_g16} 16),

  {Chanel 2}
          (
{ads_g2_3}1,
{ads_g1}  1,
{ads_g2}  2,
{ads_g4}  3,
{ads_g8}  7,
{ads_g16} 14)
               );

type


  TADS1115_Module=class(TArdADC_Mod_2ConfigByte)
  private
    FGain: TADS1115_Gain;
    FDataRate: TADS1115_DataRate;
  protected
   procedure Configuration();override;
   procedure Intitiation(); override;
   function  GetNumberByteInResult:byte;override;
  public
   property Gain: TADS1115_Gain read FGain write FGain;
   property DataRate: TADS1115_DataRate read FDataRate write FDataRate;
   procedure ConvertToValue();override;
   constructor Create();
   function ValueToByteArray(Value:double;var ByteAr:TArrByte):boolean;override;
 end;

//--------------------------------------------------
{�������� ��� ����� ���� �������, ���� ��������
��������������� AlertPin. ��� �����������
�� ����� ������� �� �������,
���������� ����������� � ��� �������������
���, ������������ ��� ���� ���������, ��� ���������
�������� gain. ���� ���������� ��������� �����������
�� ���� � ���������������� ���� � �� ��� ����� ����� ���������.
����� ���������� �������������� �� � ��, �� ������� ����
��� ������������ AlertPin.

  TPins_ADS1115_Module=class(TPins)
  protected
   Function PinValueToStr(Index:integer):string;override;
   public
   Constructor Create(Nm:string);
  end;

 TDS1115_ModuleShow=class(TPinsShowUniversal)
   private
   protected
   public
    Constructor Create(Ps:TPins;
                      AdressPanel, ReadyPinPanel: TPanel;
                      DataForReadyPinPanel: TStringList);
 end;
}

TPins_ADS1115_Chanel=class(TPinsForCustomValues)
  protected
   Function StrToPinValue(Str: string):integer;override;
   Function PinValueToStr(Index:integer):string;override;
  public
   Constructor Create(Nm:string);
  end;

 TADS1115_Channel=class(TArduinoADC_Channel)
 private
 protected

  procedure PinsCreate;override;
 public
//  Constructor Create(ChanelNumber: TADS1115_ChanelNumber;
//                      ADS1115_Module: TADS1115_Module);//override;
  procedure SetModuleParameters;override;
 end;

 TADS1115_ChannelShow=class(TPinsShowUniversal)
   private
    fChan:TADS1115_Channel;
    MeasuringDeviceSimple:TMeasuringDeviceSimple;
   protected
    procedure CreateFooter;override;
   public
    Constructor Create(Chan:TADS1115_Channel;
                       LabelBit,LabelGain:TPanel;
                       LabelMeas:TLabel;
                       ButMeas:TButton);
   Procedure Free;//override;
 end;

var
    ADS11115module:TADS1115_Module;
    ADS11115show:TI2C_PinsShow;

    ADS11115_Channels:array [TADS1115_ChanelNumber] of TADS1115_Channel;
    ADS11115_ChannelShows:array [TADS1115_ChanelNumber] of TADS1115_ChannelShow;
//    iADS1115_CN:TADS1115_ChanelNumber;

procedure  ADS11115_ChannelsCreate;
procedure  ADS11115_ChannelsFree;

implementation

uses
  SysUtils, OlegType, Math;

{ ADS1115_Module }

procedure TADS1115_Module.Configuration;
begin
  fMinDelayTime:=ADS1115_ConversionTime[FDataRate];

  fConfigByte:=$81;
  fConfigByte:=fConfigByte or ADS1115_Gain_Kod[FGain];
  fConfigByte:=fConfigByte or ADS1115_Chanel_Kod[FActiveChannel];

  fConfigByteTwo:=$03;
  fConfigByteTwo:=fConfigByteTwo or ADS1115_DataRate_Kod[FDataRate];
end;

procedure TADS1115_Module.ConvertToValue;
begin
 fValue:=ErResult;
 if High(fData)<>2 then Exit;
 case (fData[High(fData)]and $0E) of
   $00:FGain:=ads_g2_3;
   $02:FGain:=ads_g1;
   $04:FGain:=ads_g2;
   $06:FGain:=ads_g4;
   $08:FGain:=ads_g8;
   $0A:FGain:=ads_g16;
 end;
//  fValue:=TwosComplementToDouble(fData[0],fData[1],ADS1115_LSB)*ADS1115_Gain_Data[FGain];
  fValue:=TwosComplementToDouble(fData[0],fData[1],ADS1115_LSB,
                    ADS1115_CalibrateA[FActiveChannel,FGain],
                    ADS1115_CalibrateB[FActiveChannel,FGain,FDataRate])
                    *ADS1115_Gain_Data[FGain];
end;

constructor TADS1115_Module.Create;
begin
 inherited Create('ADS1115');
 RepeatInErrorCase:=True;
end;

function TADS1115_Module.GetNumberByteInResult: byte;
begin
 Result:=3;
end;

procedure TADS1115_Module.Intitiation;
begin
  inherited Intitiation;
  FGain := ads_g1;
  FDataRate:=ads_dr128;
  fMetterKod := ADS1115Command;
  fDelayTimeMax:=30;
  fDelayTimeStep:=1;
end;



function TADS1115_Module.ValueToByteArray(Value: double;
               var ByteAr: TArrByte): boolean;
  var temp:integer;
begin
 SetLength(ByteAr,NumberByteInResult);

 temp:=round((Value/ADS1115_Gain_Data[FGain]/ADS1115_LSB
                            -ADS1115_CalibrateA[FActiveChannel,FGain])
                            /ADS1115_CalibrateB[FActiveChannel,FGain,FDataRate]);
 if temp<0 then temp:=((not(abs(temp)))+1)and $FFFF;
 ByteAr[0]:=(temp shr 8) and $FF;
 ByteAr[1]:=temp and $FF;
 case FGain of
  ads_g2_3: ByteAr[2]:=$00;
  ads_g1  : ByteAr[2]:=$02;
  ads_g2  : ByteAr[2]:=$04;
  ads_g4  : ByteAr[2]:=$06;
  ads_g8  : ByteAr[2]:=$08;
  ads_g16 : ByteAr[2]:=$0A;
 end;
 Result:=True;
end;

//procedure TADS1115_Module.PinsCreate;
//begin
//  Pins := TPins_I2C.Create(Name);
////  Pins :=TPins_ADS1115_Module.Create(Name);
//end;

{ ADS1115_Channel }

{ TDS1115_ModuleShow }

//constructor TDS1115_ModuleShow.Create(Ps: TPins;
//                                 AdressPanel,ReadyPinPanel: TPanel;
//                                 DataForReadyPinPanel: TStringList);
// var adress:byte;
//begin
// inherited Create(Ps, [AdressPanel,ReadyPinPanel]);
// fPinVariants[1]:=DataForReadyPinPanel;
// for adress := ADS1115_StartAdress to ADS1115_LastAdress do
//   fPinVariants[0].Add('$'+IntToHex(adress,2));
//end;

{ TPins_ADS1115_Module }

//constructor TPins_ADS1115_Module.Create(Nm: string);
//begin
// inherited Create(Nm,['Adress','Ready pin']);
// PinStrPart:=''
//end;
//
//function TPins_ADS1115_Module.PinValueToStr(Index: integer): string;
//begin
// if index=0 then Result:='$'+IntToHex(fPins[Index],2)
//            else Result:=inherited PinValueToStr(Index);
//
//end;

{ TPins_ADS1115_Chanel }

constructor TPins_ADS1115_Chanel.Create(Nm: string);
begin
  inherited Create(Nm, ['Data rate', 'Diapazon']);
  PinControl := $00;
  // �������������� Data rate
  PinGate := $02;
  // �������������� Gain
end;


function TPins_ADS1115_Chanel.PinValueToStr(Index: integer): string;
 var i:TADS1115_Gain;
     j:TADS1115_DataRate;
begin
 if index=0 then
  begin
  for J := Low(TADS1115_DataRate) to High(TADS1115_DataRate) do
    if fPins[Index]=ADS1115_DataRate_Kod[j] then
     begin
     Result:=ADS1115_DataRate_Label[j];
     Exit;
     end;
  end      else
  begin
  for i := Low(TADS1115_Gain) to High(TADS1115_Gain) do
    if fPins[Index]=ADS1115_Gain_Kod[i] then
     begin
     Result:='+/-'+ADS1115_Diapazons[i]+' V';
     Exit;
     end;
  end;
  Result:='u-u-ups';

end;

function TPins_ADS1115_Chanel.StrToPinValue(Str: string): integer;
 var i:TADS1115_Gain;
     j:TADS1115_DataRate;
begin
 for I := Low(TADS1115_Gain) to High(TADS1115_Gain) do
  if AnsiPos( ADS1115_Diapazons[i],Str)>0 then
   begin
     Result:=ADS1115_Gain_Kod[i];
     Exit;
   end;

 for J := Low(TADS1115_DataRate) to High(TADS1115_DataRate) do
  if AnsiPos( ADS1115_DataRate_Label[j],Str)>0 then
   begin
     Result:=ADS1115_DataRate_Kod[j];
     Exit;
   end;

 Result:=UndefinedPin;

end;

{ TADS1115_Channel }

//constructor TADS1115_Channel.Create(ChanelNumber: TADS1115_ChanelNumber;
//  ADS1115_Module: TADS1115_Module);
//begin
//  inherited Create(ChanelNumber,ADS1115_Module);
//end;

procedure TADS1115_Channel.PinsCreate;
begin
 Pins:=TPins_ADS1115_Chanel.Create(fName);
end;

procedure TADS1115_Channel.SetModuleParameters;
 var i:TADS1115_Gain;
     j:TADS1115_DataRate;
begin
  inherited SetModuleParameters();
  for J := Low(TADS1115_DataRate) to High(TADS1115_DataRate) do
   if Pins.PinControl=ADS1115_DataRate_Kod[j] then
     begin
       (fParentModule as TADS1115_Module).DataRate :=
          TADS1115_DataRate(j);
       Break;
     end;
 for I := Low(TADS1115_Gain) to High(TADS1115_Gain) do
  if Pins.PinGate=ADS1115_Gain_Kod[i] then
   begin
     (fParentModule as TADS1115_Module).Gain :=
        TADS1115_Gain(i);
      Break;
   end;
end;

{ TADS1115_ChannelShow }

constructor TADS1115_ChannelShow.Create(Chan: TADS1115_Channel;
                   LabelBit, LabelGain: TPanel;
                   LabelMeas: TLabel;
                   ButMeas: TButton);
begin
  fChan:=Chan;
  inherited Create(fChan.Pins,[LabelBit,LabelGain]);

  MeasuringDeviceSimple:=
     TMeasuringDeviceSimple.Create(fChan,LabelMeas,srPreciseVoltage,ButMeas);
end;

procedure TADS1115_ChannelShow.CreateFooter;
 var
  i: TADS1115_DataRate;
  j: TADS1115_Gain;
begin
  inherited CreateFooter;

  for i := Low(TADS1115_DataRate) to High(TADS1115_DataRate) do
    fPinVariants[0].Add(ADS1115_DataRate_Label[i]);

  for j := Low(TADS1115_Gain) to High(TADS1115_Gain) do
    fPinVariants[1].Add('+/-'+ADS1115_Diapazons[j]+' V, '+
    ADS1115_LSB_labels[j]+' uV');
end;

procedure TADS1115_ChannelShow.Free;
begin
  MeasuringDeviceSimple.Free;
  inherited Free;
end;

procedure  ADS11115_ChannelsCreate;
 var i:TADS1115_ChanelNumber;
begin
  for i := Low(TADS1115_ChanelNumber) to High(TADS1115_ChanelNumber) do
    ADS11115_Channels[i] := TADS1115_Channel.Create(i, ADS11115module);
end;

procedure  ADS11115_ChannelsFree;
 var i:TADS1115_ChanelNumber;
begin
  for i := Low(TADS1115_ChanelNumber) to High(TADS1115_ChanelNumber) do
    ADS11115_Channels[i].Free;
end;


initialization
  ADS11115module := TADS1115_Module.Create;
  ADS11115_ChannelsCreate;

//  ADS11115_Channels[0] := TADS1115_Channel.Create(0, ADS11115module);
//  ADS11115_Channels[1] := TADS1115_Channel.Create(1, ADS11115module);
//  ADS11115_Channels[2] := TADS1115_Channel.Create(2, ADS11115module);

finalization
//   for iADS1115_CN:=Low(TADS1115_ChanelNumber) to High(TADS1115_ChanelNumber) do
//    ADS11115_Channels[iADS1115_CN].Free;
//  ADS11115_Channels[0].Free;
//  ADS11115_Channels[1].Free;
//  ADS11115_Channels[2].Free;
  ADS11115_ChannelsFree;
  ADS11115module.Free;

end.
