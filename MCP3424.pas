unit MCP3424;


interface

uses
  ArduinoDevice, CPort, Measurement, StdCtrls, MDevice, ExtCtrls, ArduinoADC, 
  IniFiles;

type

 TMCP3424_ChanelNumber=0..3;
 TMCP3424_Gain=(mcp_g1,mcp_g2,mcp_g4,mcp_g8);
 TMCP3424_Resolution=(mcp_r12b,mcp_r14b,mcp_r16b,mcp_r18b);

const
 MCP3424_Resolution_Label:array[TMCP3424_Resolution]of string=
   ('12 bits, 240 SPS','14 bits, 60 SPS',
   '16 bits, 15 SPS', '18 bits, 3.75 SPS');

 MCP3424_ConversionTime:array[TMCP3424_Resolution]of integer=
    (5,17,67,270);

 MCP3424_Gain_Data:array[TMCP3424_Gain]of byte=
    (1,2,4,8);
 MCP3424_Diapazons:array[TMCP3424_Gain]of string=
    ('2.048','1.024','0.512','0.256');
 MCP3424_Resolution_Data:array[TMCP3424_Resolution]of byte=
    (12,14,16,18);
 MCP3424_LSB:array[TMCP3424_Resolution]of double=
    (1e-3,2.5e-4,6.25e-5,1.5625e-5);
 MCP3424_StartAdress=$68;
 MCP3424_LastAdress=$6F;


type


  TMCP3424_Module=class(TArduinoADC_Module)
  private
    FGain: TMCP3424_Gain;
    FResolution: TMCP3424_Resolution;
  protected
   procedure Configuration();override;
   procedure Intitiation; override;
  public
   property Gain: TMCP3424_Gain read FGain write FGain;
   property Resolution: TMCP3424_Resolution read FResolution write FResolution;
   procedure ConvertToValue();override;
 end;

TPins_MCP3424=class(TPinsForCustomValues)
  protected
   Function StrToPinValue(Str: string):integer;override;
   Function PinValueToStr(Index:integer):string;override;
  public
   Constructor Create(Nm:string);
  end;

 TMCP3424_Channel=class(TArduinoADC_Channel)
 private
 protected
  procedure PinsCreate;override;
  procedure SetModuleParameters;override;
 public
   Constructor Create(ChanelNumber: TMCP3424_ChanelNumber;
                      MCP3424_Module: TMCP3424_Module);//override;
 end;


 TMCP3424_ChannelShow=class(TPinsShowUniversal)
   private
    fChan:TMCP3424_Channel;
    MeasuringDeviceSimple:TMeasuringDeviceSimple;
   protected
    procedure CreateFooter;override;
   public
    Constructor Create(Chan:TMCP3424_Channel;
                       LabelBit,LabelGain:TPanel;
                       LabelMeas:TLabel;
                       ButMeas:TButton);
   Procedure Free;override;
 end;


implementation

uses
  PacketParameters, SysUtils, OlegType, Math, Dialogs, OlegFunction{, Dialogs};

{ MCP3424_Module }

procedure TMCP3424_Module.Configuration;
begin
  fMinDelayTime:=MCP3424_ConversionTime[FResolution];
  fConfigByte:=0;
  fConfigByte:=fConfigByte or ((FActiveChannel and $3)shl 5);
  fConfigByte:=fConfigByte or ($0 shl 4);
  fConfigByte:=fConfigByte or ((ord(FResolution) and $3)shl 2);
  fConfigByte:=fConfigByte or (byte(ord(FGain)) and $3);
  fConfigByte:=fConfigByte or $80;
end;

procedure TMCP3424_Module.ConvertToValue;
 var temp:Int64;
begin
 fValue:=ErResult;

 case FResolution of
   mcp_r18b: if High(fData)<>3 then Exit;
   mcp_r12b,
   mcp_r14b,
   mcp_r16b: if High(fData)<>2 then Exit;
 end;

   FGain:=TMCP3424_Gain(fData[High(fData)]and $03);

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

  fValue:=temp*MCP3424_LSB[FResolution]/MCP3424_Gain_Data[FGain];
end;

procedure TMCP3424_Module.Intitiation;
begin
  FGain := mcp_g1;
  FResolution := mcp_r12b;
  fMetterKod := MCP3424Command;
end;


{ MCP3424_Channel }

constructor TMCP3424_Channel.Create(ChanelNumber: TMCP3424_ChanelNumber;
                                  MCP3424_Module: TMCP3424_Module);
begin
  inherited Create(ChanelNumber,MCP3424_Module);
end;




procedure TMCP3424_Channel.SetModuleParameters;
begin
  inherited SetModuleParameters();
  (fParentModule as TMCP3424_Module).Resolution := TMCP3424_Resolution(round((Pins.PinControl - 12) / 2) and $3);
  (fParentModule as TMCP3424_Module).Gain := TMCP3424_Gain((round(Log2(Pins.PinGate)) and $3));

end;

procedure TMCP3424_Channel.PinsCreate;
begin
  Pins:=TPins_MCP3424.Create(fName);
end;


{ TMCP3424_ChannelShow }

constructor TMCP3424_ChannelShow.Create(Chan: TMCP3424_Channel;
                         LabelBit,LabelGain:TPanel;
                         LabelMeas: TLabel;
                         ButMeas: TButton);
begin
  fChan:=Chan;
  inherited Create(fChan.Pins,[LabelBit,LabelGain]);
  MeasuringDeviceSimple:=
     TMeasuringDeviceSimple.Create(fChan,LabelMeas,srPreciseVoltage,ButMeas);
end;

procedure TMCP3424_ChannelShow.CreateFooter;
var
  i: TMCP3424_Resolution;
  j: TMCP3424_Gain;
begin
  inherited CreateFooter;
  for i := Low(TMCP3424_Resolution) to High(TMCP3424_Resolution) do
    fPinVariants[0].Add(MCP3424_Resolution_Label[i]);
  for j := Low(TMCP3424_Gain) to High(TMCP3424_Gain) do
    fPinVariants[1].Add('+/-'+MCP3424_Diapazons[j]+' V');
end;

procedure TMCP3424_ChannelShow.Free;
begin
  MeasuringDeviceSimple.Free;
  inherited Free;
end;

{ TPins_MCP3424 }

constructor TPins_MCP3424.Create(Nm: string);
begin
  inherited Create(Nm, ['Bits mode', 'Diapazon']);
  PinControl := 12;
  // �������������� Resolution
  PinGate := 1;
  // �������������� Gain
end;


function TPins_MCP3424.PinValueToStr(Index: integer): string;
 var i:TMCP3424_Gain;
     j:TMCP3424_Resolution;
begin
 if index=0 then
  begin
  for J := Low(TMCP3424_Resolution) to High(TMCP3424_Resolution) do
    if fPins[Index]=MCP3424_Resolution_Data[j] then
     begin
     Result:=MCP3424_Resolution_Label[j];
     Exit;
     end;
  end      else
  begin
  for i := Low(TMCP3424_Gain) to High(TMCP3424_Gain) do
    if fPins[Index]=MCP3424_Gain_Data[i] then
     begin
     Result:='+/-'+MCP3424_Diapazons[i]+' V';
     Exit;
     end;
  end;
  Result:='u-u-ups';
end;

function TPins_MCP3424.StrToPinValue(Str: string): integer;
 var i:TMCP3424_Gain;
     j:TMCP3424_Resolution;
begin
 for I := Low(TMCP3424_Gain) to High(TMCP3424_Gain) do
  if AnsiPos( MCP3424_Diapazons[i],Str)>0 then
   begin
     Result:=MCP3424_Gain_Data[i];
     Exit;
   end;

 for J := Low(TMCP3424_Resolution) to High(TMCP3424_Resolution) do
  if AnsiPos( MCP3424_Resolution_Label[j],Str)>0 then
   begin
     Result:=MCP3424_Resolution_Data[j];
     Exit;
   end;

 Result:=UndefinedPin;
end;

end.
