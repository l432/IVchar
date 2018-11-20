unit ADS1115;

interface

uses
  SPIdevice, StdCtrls, ExtCtrls, ArduinoADC, Classes, MDevice;

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
    (120,58,28,14,7,4,2,20);
 ADS1115_DelayTimeStep:array[TADS1115_DataRate]of integer=
    (5,2,5,5,1,1,1,1);
 ADS1115_DelayTimeMax:array[TADS1115_DataRate]of integer=
    (5,5,5,5,20,20,20,20);

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


type


  TADS1115_Module=class(TArduinoADC_Module)
  private
    fConfigByteTwo:byte;
    FGain: TADS1115_Gain;
    FDataRate: TADS1115_DataRate;
//    procedure FinalPacketCreateToSend;
  protected
//   procedure Configuration();override;
   procedure Intitiation(); override;
   procedure PinsCreate();override;
   procedure PacketCreateToSend();override;
//   procedure FinalPacketCreateToSend();override;
  public
   property Gain: TADS1115_Gain read FGain write FGain;
   property DataRate: TADS1115_DataRate read FDataRate write FDataRate;
   procedure ConvertToValue();override;
 end;

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

TPins_ADS1115_Chanel=class(TPins)
  protected
   Function GetPinStr(Index:integer):string;override;
   Function StrToPinValue(Str: string):integer;override;
   Function PinValueToStr(Index:integer):string;override;
  public
   Constructor Create(Nm:string);
  end;

 TADS1115_Channel=class(TArduinoADC_Channel)
 private
 protected
  procedure SetModuleParameters;override;
  procedure PinsCreate;override;
 public
  Constructor Create(ChanelNumber: TADS1115_ChanelNumber;
                      ADS1115_Module: TADS1115_Module);//override;
 end;

 TADS1115_ChannelShow=class(TPinsShowUniversal)
   private
    fChan:TADS1115_Channel;
    MeasuringDeviceSimple:TMeasuringDeviceSimple;
   protected
    procedure LabelsFilling;
   public
    Constructor Create(Chan:TADS1115_Channel;
                       LabelBit,LabelGain:TPanel;
                       LabelMeas:TLabel;
                       ButMeas:TButton);
   Procedure Free;
 end;


implementation

uses
  PacketParameters, SysUtils, OlegType, Math, Dialogs;

{ ADS1115_Module }

//procedure TADS1115_Module.Configuration;
//begin
//  fMinDelayTime:=ADS1115_ConversionTime[FDataRate];
//  fDelayTimeStep:=ADS1115_DelayTimeStep[FDataRate];
//  fDelayTimeMax:=ADS1115_DelayTimeMax[FDataRate];
//
//  fConfigByte:=$81;
//  fConfigByte:=fConfigByte or ADS1115_Gain_Kod[FGain];
//  fConfigByte:=fConfigByte or ADS1115_Chanel_Kod[FActiveChannel];
//
//  fConfigByteTwo:=$08;
//  fConfigByteTwo:=fConfigByteTwo or ADS1115_DataRate_Kod[FDataRate];
////   ShowData([fConfigByte,fConfigByteTwo]);
//end;

procedure TADS1115_Module.ConvertToValue;
 var temp:Int64;
begin
 fValue:=ErResult;
  ShowData(fData);
 if High(fData)<>2 then Exit;
 case (fData[High(fData)]and $0E) of
   $00:FGain:=ads_g2_3;
   $02:FGain:=ads_g1;
   $04:FGain:=ads_g2;
   $06:FGain:=ads_g4;
   $08:FGain:=ads_g8;
   $0A:FGain:=ads_g16;
 end;
 temp:=fData[1]+((fData[0] and $7F) shl 8);
 if (fData[0] and $80)>0 then
    temp:=-((not(temp)+$1)and $7fff);

  fValue:=temp*ADS1115_LSB*ADS1115_Gain_Data[FGain];
  fIsReady:=True;
end;

//procedure TADS1115_Module.FinalPacketCreateToSend;
//begin
//  PacketCreate([fMetterKod, Pins.PinControl, Pins.PinGate, fConfigByte, fConfigByteTwo]);
////  ShowData(aPacket);
//end;

procedure TADS1115_Module.Intitiation;
begin
  FGain := ads_g1;
  FDataRate:=ads_dr128;
  fMetterKod := ADS1115Command;
end;


procedure TADS1115_Module.PacketCreateToSend;
begin
  fMinDelayTime:=ADS1115_ConversionTime[FDataRate];
  fDelayTimeStep:=ADS1115_DelayTimeStep[FDataRate];
  fDelayTimeMax:=ADS1115_DelayTimeMax[FDataRate];

  fConfigByte:=$81;
  fConfigByte:=fConfigByte or ADS1115_Gain_Kod[FGain];
  fConfigByte:=fConfigByte or ADS1115_Chanel_Kod[FActiveChannel];

  fConfigByteTwo:=$08;
  fConfigByteTwo:=fConfigByteTwo or ADS1115_DataRate_Kod[FDataRate];

//  Configuration();
//  showmessage(inttostr(Pins.PinControl)+' '+inttostr(Pins.PinGate));

  PacketCreate([fMetterKod, Pins.PinControl, Pins.PinGate, fConfigByte, fConfigByteTwo]);
end;

procedure TADS1115_Module.PinsCreate;
begin
  Pins :=TPins_ADS1115_Module.Create(Name);
end;

{ ADS1115_Channel }

//constructor TADS1115_Channel.Create(ChanelNumber: TADS1115_ChanelNumber;
//                                  ADS1115_Module: TADS1115_Module);
//begin
//  inherited Create(ChanelNumber,ADS1115_Module);
//end;
//
//
//procedure TADS1115_Channel.SetModuleParameters;
//begin
//  inherited SetModuleParameters();
//  (fParentModule as TADS1115_Module).Resolution := TADS1115_Resolution(round((Pins.PinControl - 12) / 2) and $3);
//  (fParentModule as TADS1115_Module).Gain := TADS1115_Gain((round(Log2(Pins.PinGate)) and $3));
//
//end;
//
//procedure TADS1115_Channel.PinsCreate;
//begin
//  Pins := TPins.Create(fName, ['Bits mode', 'Gain']);
//  Pins.PinStrPart := '';
//  Pins.PinControl := 12;
//  // зберігатиметься Resolution
//  Pins.PinGate := 1;
//  // зберігатиметься Gain
//end;
//
//{ TADS1115_ChannelShow }
//
//constructor TADS1115_ChannelShow.Create(Chan: TADS1115_Channel;
//                         LabelBit,LabelGain:TPanel;
//                         LabelMeas: TLabel;
//                         ButMeas: TButton);
//begin
// inherited Create(Chan,[LabelBit,LabelGain],LabelMeas,ButMeas);
//end;
//
//procedure TADS1115_ChannelShow.LabelsFilling;
//var
//  i: TADS1115_Resolution;
//  j: TADS1115_Gain;
//begin
//  fPinVariants[0].Clear;
//  for i := Low(TADS1115_Resolution) to High(TADS1115_Resolution) do
//    fPinVariants[0].Add(inttostr(ADS1115_Resolution_Data[i]));
//  fPinVariants[1].Clear;
//  for j := Low(TADS1115_Gain) to High(TADS1115_Gain) do
//    fPinVariants[1].Add(inttostr(MADS1115_Gain_Data[j]));
//end;

{ TDS1115_ModuleShow }

constructor TDS1115_ModuleShow.Create(Ps: TPins;
                                 AdressPanel,ReadyPinPanel: TPanel;
                                 DataForReadyPinPanel: TStringList);
 var adress:byte;
begin
 inherited Create(Ps, [AdressPanel,ReadyPinPanel]);
// fPinVariants[1].Clear;
 fPinVariants[1]:=DataForReadyPinPanel;
 for adress := ADS1115_StartAdress to ADS1115_LastAdress do
   fPinVariants[0].Add('$'+IntToHex(adress,2));
end;

{ TPins_ADS1115_Module }

constructor TPins_ADS1115_Module.Create(Nm: string);
begin
 inherited Create(Nm,['Adress','Ready pin']);
 PinStrPart:=''
end;

function TPins_ADS1115_Module.PinValueToStr(Index: integer): string;
begin
 if index=0 then Result:='$'+IntToHex(fPins[Index],2)
            else Result:=inherited PinValueToStr(Index);

end;

{ TPins_ADS1115_Chanel }

constructor TPins_ADS1115_Chanel.Create(Nm: string);
begin
  inherited Create(Nm, ['Data rate', 'Diapazon']);
  PinStrPart := '';
  PinControl := $00;
  // зберігатиметься Data rate
  PinGate := $02;
  // зберігатиметься Gain
end;

function TPins_ADS1115_Chanel.GetPinStr(Index: integer): string;
begin
 if fPins[Index]=UndefinedPin then
   Result:=PNames[Index] +' is undefined'
                              else
   Result:=PinValueToStr(Index);
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

constructor TADS1115_Channel.Create(ChanelNumber: TADS1115_ChanelNumber;
  ADS1115_Module: TADS1115_Module);
begin
  inherited Create(ChanelNumber,ADS1115_Module);
//  Pins:=TPins_ADS1115_Chanel.Create(fName);
end;

//procedure TADS1115_Channel.Free;
//begin
// Pins.Free;
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

{ TMCP3424_ChannelShow }

constructor TADS1115_ChannelShow.Create(Chan: TADS1115_Channel;
                   LabelBit, LabelGain: TPanel;
                   LabelMeas: TLabel;
                   ButMeas: TButton);
begin
  fChan:=Chan;
  inherited Create(fChan.Pins,[LabelBit,LabelGain]);
  LabelsFilling;

  MeasuringDeviceSimple:=
     TMeasuringDeviceSimple.Create(fChan,LabelMeas,srPreciseVoltage,ButMeas);
end;

procedure TADS1115_ChannelShow.Free;
begin
  MeasuringDeviceSimple.Free;
  inherited Free;
end;

procedure TADS1115_ChannelShow.LabelsFilling;
 var
  i: TADS1115_DataRate;
  j: TADS1115_Gain;
begin

  fPinVariants[0].Clear;
  fPinVariants[1].Clear;

  for i := Low(TADS1115_DataRate) to High(TADS1115_DataRate) do
    fPinVariants[0].Add(ADS1115_DataRate_Label[i]);

  for j := Low(TADS1115_Gain) to High(TADS1115_Gain) do
    fPinVariants[1].Add('+/-'+ADS1115_Diapazons[j]+' V, '+
    ADS1115_LSB_labels[j]+' mkV');


end;

end.
