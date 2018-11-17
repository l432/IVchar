unit ADS1115;

interface

uses
  SPIdevice, StdCtrls, ExtCtrls, ArduinoADC;

type

 TADS1115_ChanelNumber=0..2;
 TADS1115_Gain=(ads_g2_3=$00, // +/-6.144V range = Gain 2/3
                ads_g1=$02,   // +/-4.096V range = Gain 1
                ads_g2=$04,  // +/-2.048V range = Gain 2
                ads_g4=$06,  // +/-1.024V range = Gain 4
                ads_g8=$08,  // +/-0.512V range = Gain 8
                ads_g16=$0A);  // +/-0.256V range = Gain 16
 TADS1115_DataRate=(ads_dr8=$00, // 8 samples per second
                    ads_dr16=$20,  // 16 samples per second
                    ads_dr32=$40,  // 32 samples per second
                    ads_dr64=$60,  // 64 samples per second
                    ads_dr128=$80, // 128 samples per second
                    ads_dr250=$A0, // 250 samples per second
                    ads_dr475=$C0,// 475 samples per second
                    ads_dr860=$E0);// 860 samples per second

const

 ADS1115_ConversionTime:array[TADS1115_DataRate]of integer=
    (120,58,28,14,7,4,2,1);
 ADS1115_DelayTimeStep:array[TADS1115_DataRate]of integer=
    (5,2,2,1,1,1,1,1);
 ADS1115_DelayTimeMax:array[TADS1115_DataRate]of integer=
    (5,10,10,10,10,5,3,3);
 ADS1115_Gain_Data:array[TADS1115_Gain]of byte=
    (1,2,4,8);
 ADS1115_Resolution_Data:array[TADS1115_Resolution]of byte=
    (12,14,16,18);
 ADS1115_LSB=125e-6;
 ADS1115_StartAdress=$48;
 ADS1115_LastAdress=$4B;


type


  TADS1115_Module=class(TArduinoADC_Module)
  private
    FGain: TADS1115_Gain;
    FResolution: TADS1115_Resolution;
  protected
   procedure Configuration();override;
   procedure Intitiation; override;
  public
   property Gain: TADS1115_Gain read FGain write FGain;
   property Resolution: TADS1115_Resolution read FResolution write FResolution;
   procedure ConvertToValue();override;
 end;

 TADS1115_Channel=class(TArduinoADC_Channel)
 private
 protected
  procedure PinsCreate;override;
  procedure SetModuleParameters;override;
 public
  Pins:TPins;
  property Value:double read GetValue;
   Constructor Create(ChanelNumber: TADS1115_ChanelNumber;
                      MCP3424_Module: TADS1115_Module);//override;
 end;

 TADS1115_ChannelShow=class(TArduinoADC_ChannelShow)
   private
   protected
    procedure LabelsFilling;override;
   public
    Constructor Create(Chan:TADS1115_Channel;
                       LabelBit,LabelGain:TPanel;
                       LabelMeas:TLabel;
                       ButMeas:TButton);
 end;


implementation

uses
  PacketParameters, SysUtils, OlegType, Math;

{ ADS1115_Module }

procedure TADS1115_Module.Configuration;
begin
  fMinDelayTime:=ADS1115_ConversionTime[FResolution];
  fDelayTimeStep:=ADS1115_DelayTimeStep[FResolution];
  fDelayTimeMax:=ADS1115_DelayTimeMax[FResolution];
  fConfigByte:=0;
  fConfigByte:=fConfigByte or ((FActiveChannel and $3)shl 5);
  fConfigByte:=fConfigByte or ($0 shl 4);
  fConfigByte:=fConfigByte or ((ord(FResolution) and $3)shl 2);
  fConfigByte:=fConfigByte or (byte(ord(FGain)) and $3);
  fConfigByte:=fConfigByte or $80;
end;

procedure TADS1115_Module.ConvertToValue;
 var temp:Int64;
begin
// ShowData(fData);
 fValue:=ErResult;

 case FResolution of
   mcp_r18b: if High(fData)<>3 then Exit;
   mcp_r12b,
   mcp_r14b,
   mcp_r16b: if High(fData)<>2 then Exit;
 end;

   FGain:=TADS1115_Gain(High(fData)and $3);

   temp:=0;
   temp:=temp+fData[High(fData)-1];

  case FResolution of
   mcp_r12b: temp:=temp+((fData[High(fData)-2] and $7) shl 8);
   mcp_r14b: temp:=temp+((fData[High(fData)-2] and $1F) shl 8);
   mcp_r16b: temp:=temp+((fData[High(fData)-2] and $7F) shl 8);
   mcp_r18b: temp:=temp+(fData[High(fData)-2] shl 8)+
                   ((fData[0] and $1) shl 16);
  end;


  if (fData[0] and $80)>0 then
    case FResolution of
     mcp_r12b: temp:=-((not(temp)+$01)and $7ff);
     mcp_r14b: temp:=-((not(temp)+$1)and $1fff);
     mcp_r16b: temp:=-((not(temp)+$1)and $7fff);
     mcp_r18b: temp:=-((not(temp)+$1)and $1ffff);
    end;

  fValue:=temp*ADS1115_LSB[FResolution]/ADS1115_Gain_Data[FGain];
  fIsReady:=True;
end;

procedure TADS1115_Module.Intitiation;
begin
  FGain := ads_g1;
  FResolution := mcp_r12b;
  fMetterKod := ADS1115Command;
end;


{ ADS1115_Channel }

constructor TADS1115_Channel.Create(ChanelNumber: TADS1115_ChanelNumber;
                                  ADS1115_Module: TADS1115_Module);
begin
  inherited Create(ChanelNumber,ADS1115_Module);
end;


procedure TADS1115_Channel.SetModuleParameters;
begin
  inherited SetModuleParameters();
  (fParentModule as TADS1115_Module).Resolution := TADS1115_Resolution(round((Pins.PinControl - 12) / 2) and $3);
  (fParentModule as TADS1115_Module).Gain := TADS1115_Gain((round(Log2(Pins.PinGate)) and $3));

end;

procedure TADS1115_Channel.PinsCreate;
begin
  Pins := TPins.Create(fName, ['Bits mode', 'Gain']);
  Pins.PinStrPart := '';
  Pins.PinControl := 12;
  // зберігатиметься Resolution
  Pins.PinGate := 1;
  // зберігатиметься Gain
end;

{ TADS1115_ChannelShow }

constructor TADS1115_ChannelShow.Create(Chan: TADS1115_Channel;
                         LabelBit,LabelGain:TPanel;
                         LabelMeas: TLabel;
                         ButMeas: TButton);
begin
 inherited Create(Chan,[LabelBit,LabelGain],LabelMeas,ButMeas);
end;

procedure TADS1115_ChannelShow.LabelsFilling;
var
  i: TADS1115_Resolution;
  j: TADS1115_Gain;
begin
  fPinVariants[0].Clear;
  for i := Low(TADS1115_Resolution) to High(TADS1115_Resolution) do
    fPinVariants[0].Add(inttostr(ADS1115_Resolution_Data[i]));
  fPinVariants[1].Clear;
  for j := Low(TADS1115_Gain) to High(TADS1115_Gain) do
    fPinVariants[1].Add(inttostr(MADS1115_Gain_Data[j]));
end;

end.
