unit MCP3424;

interface

uses
  SPIdevice, CPort, Measurement;

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
 MCP3424_LSB:array[TMCP3424_Resolution]of double=
    (1e-3,2.5e-4,6.25e-5,1.5625e-5);
// MCP3424IniSectionName='MCP3424';
 MCP3424_StartAdress=$68;
 MCP3424_LastAdress=$6F;

type

  first=class
   public
    procedure Free();
  end;

  second=class(first)
   public
    procedure Free();
  end;


  TMCP3424_Module=class(TArduinoMeter)
  private
    FActiveChannel: TMCP3424_ChanelNumber;
    FGain: TMCP3424_Gain;
    FResolution: TMCP3424_Resolution;
    fConfigByte:byte;

//    procedure SetActiveChannel(const Value: TMCP3424_ChanelNumber);
//    procedure SetGain(const Value: TMCP3424_Gain);
//    procedure SetResolution(const Value: TMCP3424_Resolution);
//    FChannels: array[TMCP3424_ChanelNumber] of MCP3424_Channel;
   procedure Configuration();
  protected
   procedure   PacketCreateToSend(); override;
  public
   property  ActiveChannel:TMCP3424_ChanelNumber read FActiveChannel write FActiveChannel;
   property Gain: TMCP3424_Gain read FGain write FGain;
   property Resolution: TMCP3424_Resolution read FResolution write FResolution;

   constructor Create(CP:TComPort;Nm:string);override;
   procedure ConvertToValue();override;
 end;

 MCP3424_Channel=class(TNamedInterfacedObject,IMeasurement)
 private
  fChanelNumber:TMCP3424_ChanelNumber;
  fParentModule:TMCP3424_Module;
//  FGain: TMCP3424_Gain;
//  FResolution: TMCP3424_Resolution;
 protected
  function GetNewData:boolean;
  function GetValue:double;
  procedure SetNewData(Value:boolean);
 public
  Pins:TPins;
//  property NewData:boolean read GetNewData write SetNewData;
  property Value:double read GetValue;
    Constructor Create(Nm:string;
                     ChanelNumber:TMCP3424_ChanelNumber;
                     MCP3424_Module:TMCP3424_Module);//override;
  Procedure Free;
  function GetData:double;
  procedure GetDataThread(WPARAM: word; EventEnd:THandle);
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
  fConfigByte:=fConfigByte or ($1 shl 4);
  fConfigByte:=fConfigByte or ((ord(FResolution) and $3)shl 2);
  fConfigByte:=fConfigByte or (byte(ord(FGain)) and $3);
end;

procedure TMCP3424_Module.ConvertToValue;
 var temp:Int64;
begin
 fValue:=ErResult;
 //---------???????????
// if fdata[High(fData)]<>fConfigByte then Exit;

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
     mcp_r12b: temp:=-((not(temp)+$1)and $fff);
     mcp_r14b: temp:=-((not(temp)+$1)and $3fff);
     mcp_r16b: temp:=-((not(temp)+$1)and $ffff);
     mcp_r18b: temp:=-((not(temp)+$1)and $3ffff);
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
// SetActiveChannel(0);
// SetGain(mcp_g1);
// SetResolution(mcp_r12b);

 fMetterKod:=MCP3424Command;
 SetLength(Pins.fPins,1);
 Configuration();
// fMinDelayTime:=MCP3424_ConversionTime[FResolution];

end;

procedure TMCP3424_Module.PacketCreateToSend;
begin
  Configuration();
  PacketCreate([fMetterKod,Pins.PinControl,fConfigByte]);
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

constructor MCP3424_Channel.Create(Nm: string;
                         ChanelNumber: TMCP3424_ChanelNumber;
                         MCP3424_Module: TMCP3424_Module);
begin
  inherited Create();
  fName:=Nm;


  fChanelNumber:=ChanelNumber;
  fName:='Ch'+inttostr(ord(ChanelNumber)+1)+'_MCP3424';
  fParentModule:=MCP3424_Module;

  Pins:=TPins.Create(Nm);
  Pins.PinControl:=0;// зберігатиметься Resolution
  Pins.PinGate:=0;  // зберігатиметься Gain

//  SetLength(Pins.fPins,1);
end;



procedure MCP3424_Channel.Free;
begin
 Pins.Free;
 inherited Free;
end;

function MCP3424_Channel.GetData: double;
begin
 fParentModule.ActiveChannel:=fChanelNumber;
 fParentModule.Resolution:=TMCP3424_Resolution(round((Pins.PinControl-12)/2) and $3);
 fParentModule.Gain:=TMCP3424_Gain((round( Log2(Pins.PinGate)) and $3));
 Result:=fParentModule.GetData;
end;

procedure MCP3424_Channel.GetDataThread(WPARAM: word; EventEnd: THandle);
begin
 fParentModule.GetDataThread(WPARAM,EventEnd);
end;

function MCP3424_Channel.GetNewData: boolean;
begin
 Result:=fParentModule.NewData;
end;

function MCP3424_Channel.GetValue: double;
begin
 Result:=fParentModule.Value;
end;

procedure MCP3424_Channel.SetNewData(Value: boolean);
begin
 fParentModule.NewData:=Value;
end;

{ first }

procedure first.Free;
begin
 showmessage('first');
 inherited;
end;

{ second }

procedure second.Free;
begin
  showmessage('second');
 inherited;
end;

end.
