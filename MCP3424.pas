unit MCP3424;

interface

uses
  SPIdevice, CPort, Measurement, StdCtrls, MDevice;

type

 TMCP3424_ChanelNumber=0..3;
 TMCP3424_Gain=(mcp_g1,mcp_g2,mcp_g4,mcp_g8);
 TMCP3424_Resolution=(mcp_r12b,mcp_r14b,mcp_r16b,mcp_r18b);
// TET1255_Frequency_Tackt=(mhz833,mhz417,mhz208, mhz104);

const
 MCP3424_Resolution_Label:array[TMCP3424_Resolution]of string=
   ('12 bits, 240 SPS','14 bits, 60 SPS',
   '16 bits, 15 SPS', '18 bits, 3.75 SPS');
 MCP3424_ConversionTime:array[TMCP3424_Resolution]of integer=
    (5,17,67,270);
//    (10,35,140,550);
 MCP3424_Gain_Data:array[TMCP3424_Gain]of byte=
    (1,2,4,8);
 MCP3424_Resolution_Data:array[TMCP3424_Resolution]of byte=
    (12,14,16,18);
 MCP3424_LSB:array[TMCP3424_Resolution]of double=
    (1e-3,2.5e-4,6.25e-5,1.5625e-5);
// MCP3424IniSectionName='MCP3424';
 MCP3424_StartAdress=$68;
 MCP3424_LastAdress=$6F;


type


  TMCP3424_Module=class(TArduinoMeter)
  private
    FActiveChannel: TMCP3424_ChanelNumber;
    FGain: TMCP3424_Gain;
    FResolution: TMCP3424_Resolution;
    fConfigByte:byte;
   procedure Configuration();
  protected
   procedure   PacketCreateToSend(); override;
   procedure PinsCreate();override;
  public
   property  ActiveChannel:TMCP3424_ChanelNumber read FActiveChannel write FActiveChannel;
   property Gain: TMCP3424_Gain read FGain write FGain;
   property Resolution: TMCP3424_Resolution read FResolution write FResolution;

   constructor Create(CP:TComPort;Nm:string);override;
   procedure ConvertToValue();override;
 end;



 TMCP3424_Channel=class(TNamedInterfacedObject,IMeasurement)
 private
  fChanelNumber:TMCP3424_ChanelNumber;
  fParentModule:TMCP3424_Module;
 protected
  function GetNewData:boolean;
  function GetValue:double;
  procedure SetNewData(Value:boolean);
 public
  Pins:TPins;
  property Value:double read GetValue;
    Constructor Create(ChanelNumber: TMCP3424_ChanelNumber; MCP3424_Module: TMCP3424_Module);//override;
  Procedure Free;
  function GetData:double;
  procedure GetDataThread(WPARAM: word; EventEnd:THandle);
 end;

 TMCP3424_ChannelShow=class(TPinsShowUniversal)
   private
    fChan:TMCP3424_Channel;
    MeasuringDeviceSimple:TMeasuringDeviceSimple;
   public
    Constructor Create(Chan:TMCP3424_Channel;
                       LabelBit,LabelGain,LabelMeas:TLabel;
                       ButBit,ButGain,ButMeas:TButton;
                       CBBit,CBGain:TComboBox);
   Procedure Free;
 end;


implementation

uses
  PacketParameters, SysUtils, OlegType, Math, Dialogs;

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
// ShowData(fData);
 fValue:=ErResult;

 case FResolution of
   mcp_r18b: if High(fData)<>3 then Exit;
   mcp_r12b,
   mcp_r14b,
   mcp_r16b: if High(fData)<>2 then Exit;
 end;

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
  fIsReady:=True;
end;

constructor TMCP3424_Module.Create (CP:TComPort;Nm:string);
begin
 inherited Create (CP,Nm);
 FActiveChannel:=0;
 FGain:=mcp_g1;
 FResolution:=mcp_r12b;
 fMetterKod:=MCP3424Command;
 Configuration();
end;


procedure TMCP3424_Module.PacketCreateToSend;
begin
  Configuration();
//  showmessage(inttohex(fConfigByte,2));
  PacketCreate([fMetterKod,Pins.PinControl,fConfigByte]);
end;

procedure TMCP3424_Module.PinsCreate;
begin
  Pins := TPins_I2C.Create(Name);
end;


{ MCP3424_Channel }

constructor TMCP3424_Channel.Create(ChanelNumber: TMCP3424_ChanelNumber;
                                  MCP3424_Module: TMCP3424_Module);
begin
  inherited Create();

  fChanelNumber:=ChanelNumber;
  fName:='Ch'+inttostr(ord(ChanelNumber)+1)+'_MCP3424';
  fParentModule:=MCP3424_Module;

  Pins:=TPins.Create(fName,['Bits mode','Gain']);
  Pins.PinStrPart:='';
  Pins.PinControl:=12;// зберігатиметься Resolution
  Pins.PinGate:=1;  // зберігатиметься Gain

end;



procedure TMCP3424_Channel.Free;
begin
 Pins.Free;
// inherited Free;
end;

function TMCP3424_Channel.GetData: double;
begin
 fParentModule.ActiveChannel:=fChanelNumber;
 fParentModule.Resolution:=TMCP3424_Resolution(round((Pins.PinControl-12)/2) and $3);
 fParentModule.Gain:=TMCP3424_Gain((round( Log2(Pins.PinGate)) and $3));
 Result:=fParentModule.GetData;
end;

procedure TMCP3424_Channel.GetDataThread(WPARAM: word; EventEnd: THandle);
begin
 fParentModule.GetDataThread(WPARAM,EventEnd);
end;

function TMCP3424_Channel.GetNewData: boolean;
begin
 Result:=fParentModule.NewData;
end;

function TMCP3424_Channel.GetValue: double;
begin
 Result:=fParentModule.Value;
end;

procedure TMCP3424_Channel.SetNewData(Value: boolean);
begin
 fParentModule.NewData:=Value;
end;


{ TMCP3424_ChannelShow }


{ TMCP3424_ChannelShow }

constructor TMCP3424_ChannelShow.Create(Chan: TMCP3424_Channel;
                         LabelBit,LabelGain, LabelMeas: TLabel;
                         ButBit, ButGain, ButMeas: TButton;
                         CBBit,CBGain: TComboBox);
 var i:TMCP3424_Resolution;
     j:TMCP3424_Gain;
begin
  fChan:=Chan;
  inherited Create(fChan.Pins,[LabelBit,LabelGain],[ButBit, ButGain],[CBBit,CBGain]);
  PinsComboBoxs[0].Items.Clear;
  for i := Low(TMCP3424_Resolution) to High(TMCP3424_Resolution) do
   PinsComboBoxs[0].Items.Add(inttostr(MCP3424_Resolution_Data[i]));

  PinsComboBoxs[1].Items.Clear;
  for j := Low(TMCP3424_Gain) to High(TMCP3424_Gain) do
   PinsComboBoxs[1].Items.Add(inttostr(MCP3424_Gain_Data[j]));

  MeasuringDeviceSimple:=
     TMeasuringDeviceSimple.Create(fChan,LabelMeas,srPreciseVoltage,ButMeas);

end;

procedure TMCP3424_ChannelShow.Free;
begin
  MeasuringDeviceSimple.Free;
  inherited Free;
end;

end.
