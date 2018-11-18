unit ADS1115;

interface

uses
  SPIdevice, StdCtrls, ExtCtrls, ArduinoADC;

type

 TADS1115_ChanelNumber=0..2;
 TADS1115_Gain=(ads_g2_3, // +/-6.144V range = Gain 2/3
                ads_g1,   // +/-4.096V range = Gain 1
                ads_g2,  // +/-2.048V range = Gain 2
                ads_g4,  // +/-1.024V range = Gain 4
                ads_g8,  // +/-0.512V range = Gain 8
                ads_g16);  // +/-0.256V range = Gain 16
// TADS1115_Gain=(ads_g2_3=$00, // +/-6.144V range = Gain 2/3
//                ads_g1=$02,   // +/-4.096V range = Gain 1
//                ads_g2=$04,  // +/-2.048V range = Gain 2
//                ads_g4=$06,  // +/-1.024V range = Gain 4
//                ads_g8=$08,  // +/-0.512V range = Gain 8
//                ads_g16=$0A);  // +/-0.256V range = Gain 16
 TADS1115_DataRate=(ads_dr8, // 8 samples per second
                    ads_dr16,  // 16 samples per second
                    ads_dr32,  // 32 samples per second
                    ads_dr64,  // 64 samples per second
                    ads_dr128, // 128 samples per second
                    ads_dr250, // 250 samples per second
                    ads_dr475,// 475 samples per second
                    ads_dr860);// 860 samples per second
// TADS1115_DataRate=(ads_dr8=$00, // 8 samples per second
//                    ads_dr16=$20,  // 16 samples per second
//                    ads_dr32=$40,  // 32 samples per second
//                    ads_dr64=$60,  // 64 samples per second
//                    ads_dr128=$80, // 128 samples per second
//                    ads_dr250=$A0, // 250 samples per second
//                    ads_dr475=$C0,// 475 samples per second
//                    ads_dr860=$E0);// 860 samples per second

const

 ADS1115_ConversionTime:array[TADS1115_DataRate]of integer=
    (120,58,28,14,7,4,2,1);
 ADS1115_DelayTimeStep:array[TADS1115_DataRate]of integer=
    (5,2,2,1,1,1,1,1);
 ADS1115_DelayTimeMax:array[TADS1115_DataRate]of integer=
    (5,10,10,20,20,20,20,20);

 ADS1115_Gain_Data:array[TADS1115_Gain]of double=
    (1.5,1,0.5,0.25,0.125,0.0625);
 ADS1115_Gain_Kod:array[TADS1115_Gain]of byte=
    ($00,$02,$04,$06,$08,$0A);
 ADS1115_DataRate_Kod:array[TADS1115_DataRate]of byte=
    ($00,$20,$40,$60,$80,$A0,$C0,$E0);
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
  protected
   procedure Configuration();override;
   procedure Intitiation(); override;
   procedure PinsCreate();override;
   procedure FinalPacketCreateToSend();override;
  public
   property Gain: TADS1115_Gain read FGain write FGain;
   property DataRate: TADS1115_DataRate read FDataRate write FDataRate;
   procedure ConvertToValue();override;
 end;

// TADS1115_Channel=class(TArduinoADC_Channel)
// private
// protected
//  procedure PinsCreate;override;
//  procedure SetModuleParameters;override;
// public
//  Pins:TPins;
//  property Value:double read GetValue;
//   Constructor Create(ChanelNumber: TADS1115_ChanelNumber;
//                      MCP3424_Module: TADS1115_Module);//override;
// end;
//
// TADS1115_ChannelShow=class(TArduinoADC_ChannelShow)
//   private
//   protected
//    procedure LabelsFilling;override;
//   public
//    Constructor Create(Chan:TADS1115_Channel;
//                       LabelBit,LabelGain:TPanel;
//                       LabelMeas:TLabel;
//                       ButMeas:TButton);
// end;


implementation

uses
  PacketParameters, SysUtils, OlegType, Math;

{ ADS1115_Module }

procedure TADS1115_Module.Configuration;
begin
  fMinDelayTime:=ADS1115_ConversionTime[FDataRate];
  fDelayTimeStep:=ADS1115_DelayTimeStep[FDataRate];
  fDelayTimeMax:=ADS1115_DelayTimeMax[FDataRate];

  fConfigByte:=$81;
  fConfigByte:=fConfigByte or ADS1115_Gain_Kod[FGain];
  fConfigByte:=fConfigByte or ADS1115_Chanel_Kod[FActiveChannel];

  fConfigByteTwo:=$8C;
  fConfigByteTwo:=fConfigByteTwo or ADS1115_DataRate_Kod[FDataRate]

end;

procedure TADS1115_Module.ConvertToValue;
 var temp:Int64;
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
 temp:=fData[1]+((fData[0] and $7F) shl 8);
 if (fData[0] and $80)>0 then
    temp:=-((not(temp)+$1)and $7fff);

  fValue:=temp*ADS1115_LSB*ADS1115_Gain_Data[FGain];
  fIsReady:=True;
end;

procedure TADS1115_Module.FinalPacketCreateToSend;
begin
  PacketCreate([fMetterKod, Pins.PinControl, Pins.PinGate, fConfigByte, fConfigByteTwo]);
end;

procedure TADS1115_Module.Intitiation;
begin
  FGain := ads_g1;
  FDataRate:=ads_dr128;
  fMetterKod := ADS1115Command;
end;


procedure TADS1115_Module.PinsCreate;
begin
  Pins := TPins.Create(Name,['Adress','Ready pin']);
  Pins.PinStrPart:='';
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

end.
