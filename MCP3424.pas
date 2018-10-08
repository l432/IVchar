unit MCP3424;

interface

uses
  SPIdevice, CPort;

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
    (5,18,70,270);
 MCP3424_Gain_Data:array[TMCP3424_Gain]of byte=
    (1,2,4,8);
 MCP3424IniSectionName='MCP3424';

type

  TMCP3424_Module=class(TArduinoMeter)
  private
    FActiveChannel: TMCP3424_ChanelNumber;
    FGain: TMCP3424_Gain;
    FResolution: TMCP3424_Resolution;
//    procedure SetActiveChannel(const Value: TMCP3424_ChanelNumber);
//    procedure SetGain(const Value: TMCP3424_Gain);
//    procedure SetResolution(const Value: TMCP3424_Resolution);
  public
   property  ActiveChannel:TMCP3424_ChanelNumber read FActiveChannel write FActiveChannel;
   property Gain: TMCP3424_Gain read FGain write FGain;
   property Resolution: TMCP3424_Resolution read FResolution write FResolution;

   constructor Create(CP:TComPort;Nm:string);override;
 end;

 MCP3424_Channel=class(TArduinoMeter)
 private
  fChanelNumber: TMCP3424_ChanelNumber;
  fParentModule:TMCP3424_Module;
 public
  Constructor Create(CP:TComPort;Nm:string;
                     ChanelNumber:TMCP3424_ChanelNumber;
                     MCP3424_Module:TMCP3424_Module);//override;
 end;

implementation

uses
  PacketParameters, SysUtils;

{ MCP3424_Module }

constructor TMCP3424_Module.Create (CP:TComPort;Nm:string);
begin
 inherited Create (CP,Nm);
 FActiveChannel:=0;
 FGain:=mcp_g1;
 FResolution:=mcp_r12b;
// SetActiveChannel(0);
// SetGain(mcp_g1);
// SetResolution(mcp_r12b);

 fMetterKod:=MCP3424Command;
 SetLength(Pins.fPins,1);
 fMinDelayTime:=MCP3424_ConversionTime[FResolution];

end;

//procedure TMCP3424_Module.SetActiveChannel(const Value: TMCP3424_ChanelNumber);
//begin
//  FActiveChannel := Value;
//end;
//
//procedure TMCP3424_Module.SetGain(const Value: TMCP3424_Gain);
//begin
//  FGain := Value;
//end;
//
//procedure TMCP3424_Module.SetResolution(const Value: TMCP3424_Resolution);
//begin
//  FResolution := Value;
//end;

{ MCP3424_Channel }

constructor MCP3424_Channel.Create(CP: TComPort; Nm: string;
                         ChanelNumber: TMCP3424_ChanelNumber;
                         MCP3424_Module: TMCP3424_Module);
begin
  inherited Create(CP,Nm);
  fMetterKod:=MCP3424Command;
  fChanelNumber:=ChanelNumber;
  fName:='Ch'+inttostr(ord(ChanelNumber)+1)+'_MCP3424';
  fParentModule:=MCP3424_Module;
  SetLength(Pins.fPins,1);
  fMinDelayTime:=30;
end;

end.
