unit MCP3424;


interface

uses
  SPIdevice, CPort, Measurement, StdCtrls, MDevice, ExtCtrls, ArduinoADC, 
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
//    (10,35,140,550);
 MCP3424_DelayTimeStep:array[TMCP3424_Resolution]of integer=
    (1,1,2,5);
 MCP3424_DelayTimeMax:array[TMCP3424_Resolution]of integer=
    (15,15,20,25);

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
//    FActiveChannel: TMCP3424_ChanelNumber;
    FGain: TMCP3424_Gain;
    FResolution: TMCP3424_Resolution;
//    fConfigByte:byte;
  protected
//   procedure Configuration();override;
   procedure Intitiation; override;

   procedure   PacketCreateToSend(); override;
   procedure PinsCreate();override;
  public
//   property  ActiveChannel:TMCP3424_ChanelNumber read FActiveChannel write FActiveChannel;
   property Gain: TMCP3424_Gain read FGain write FGain;
   property Resolution: TMCP3424_Resolution read FResolution write FResolution;

//   constructor Create(CP:TComPort;Nm:string);override;
   procedure ConvertToValue();override;
 end;

//  TMCP3424_Module=class(TArduinoMeter)
//  private
//    FActiveChannel: TMCP3424_ChanelNumber;
//    FGain: TMCP3424_Gain;
//    FResolution: TMCP3424_Resolution;
//    fConfigByte:byte;
//   procedure Configuration();
//   procedure Intitiation;
//  protected
//   procedure   PacketCreateToSend(); override;
//   procedure PinsCreate();override;
//  public
//   property  ActiveChannel:TMCP3424_ChanelNumber read FActiveChannel write FActiveChannel;
//   property Gain: TMCP3424_Gain read FGain write FGain;
//   property Resolution: TMCP3424_Resolution read FResolution write FResolution;
//
//   constructor Create(CP:TComPort;Nm:string);override;
//   procedure ConvertToValue();override;
// end;


TPins_MCP3424=class(TPins)
  protected
   Function GetPinStr(Index:integer):string;override;
   Function StrToPinValue(Str: string):integer;override;
   Function PinValueToStr(Index:integer):string;override;
  public
   Constructor Create(Nm:string);
  end;

 TMCP3424_Channel=class(TArduinoADC_Channel)
 private
//  fChanelNumber:TMCP3424_ChanelNumber;
//  fParentModule:TMCP3424_Module;
 protected
//  function GetNewData:boolean;
//  function GetValue:double;
//  procedure SetNewData(Value:boolean);
  procedure PinsCreate;override;
  procedure SetModuleParameters;override;
 public
//  Pins:TPins_MCP3424;
//  property Value:double read GetValue;
   Constructor Create(ChanelNumber: TMCP3424_ChanelNumber;
                      MCP3424_Module: TMCP3424_Module);//override;
//  Procedure Free;
//  function GetData:double;
//  procedure GetDataThread(WPARAM: word; EventEnd:THandle);
 end;

// TMCP3424_Channel=class(TNamedInterfacedObject,IMeasurement)
// private
//  fChanelNumber:TMCP3424_ChanelNumber;
//  fParentModule:TMCP3424_Module;
// protected
//  function GetNewData:boolean;
//  function GetValue:double;
//  procedure SetNewData(Value:boolean);
//  procedure PinsCreate;
//  procedure SetModuleParameters;
// public
//  Pins:TPins;
//  property Value:double read GetValue;
//    Constructor Create(ChanelNumber: TMCP3424_ChanelNumber; MCP3424_Module: TMCP3424_Module);//override;
//  Procedure Free;
//  function GetData:double;
//  procedure GetDataThread(WPARAM: word; EventEnd:THandle);
// end;

// TMCP3424_ChannelShow=class(TArduinoADC_ChannelShow)
//   private
////    fChan:TMCP3424_Channel;
////    MeasuringDeviceSimple:TMeasuringDeviceSimple;
//   protected
//    procedure LabelsFilling;override;
//   public
//   Constructor Create(Chan:TMCP3424_Channel;
//                       LabelBit,LabelGain:TPanel;
//                       LabelMeas:TLabel;
//                       ButMeas:TButton);
////   Procedure Free;
// end;

 TMCP3424_ChannelShow=class(TPinsShowUniversal)
   private
    fChan:TMCP3424_Channel;
    MeasuringDeviceSimple:TMeasuringDeviceSimple;
   protected
    procedure LabelsFilling;
   public
    Constructor Create(Chan:TMCP3424_Channel;
                       LabelBit,LabelGain:TPanel;
                       LabelMeas:TLabel;
                       ButMeas:TButton);
//   procedure PinsReadFromIniFile(ConfigFile:TIniFile);override;
//   procedure PinsWriteToIniFile(ConfigFile:TIniFile);override;
   Procedure Free;
 end;


implementation

uses
  PacketParameters, SysUtils, OlegType, Math, Dialogs{, Dialogs};

{ MCP3424_Module }

//procedure TMCP3424_Module.Configuration;
//begin
//  fMinDelayTime:=MCP3424_ConversionTime[FResolution];
//  fDelayTimeStep:=MCP3424_DelayTimeStep[FResolution];
//  fDelayTimeMax:=MCP3424_DelayTimeMax[FResolution];
//  fConfigByte:=0;
//  fConfigByte:=fConfigByte or ((FActiveChannel and $3)shl 5);
//  fConfigByte:=fConfigByte or ($0 shl 4);
//  fConfigByte:=fConfigByte or ((ord(FResolution) and $3)shl 2);
//  fConfigByte:=fConfigByte or (byte(ord(FGain)) and $3);
//  fConfigByte:=fConfigByte or $80;
//end;

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

   FGain:=TMCP3424_Gain(High(fData)and $3);

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

procedure TMCP3424_Module.Intitiation;
begin
  FGain := mcp_g1;
  FResolution := mcp_r12b;
  fMetterKod := MCP3424Command;
end;

//constructor TMCP3424_Module.Create (CP:TComPort;Nm:string);
//begin
// inherited Create (CP,Nm);
// FActiveChannel:=0;
// Intitiation();
//// Configuration();
//end;
//
//
procedure TMCP3424_Module.PacketCreateToSend;
begin
  fMinDelayTime:=MCP3424_ConversionTime[FResolution];
  fDelayTimeStep:=MCP3424_DelayTimeStep[FResolution];
  fDelayTimeMax:=MCP3424_DelayTimeMax[FResolution];
  fConfigByte:=0;
  fConfigByte:=fConfigByte or ((FActiveChannel and $3)shl 5);
  fConfigByte:=fConfigByte or ($0 shl 4);
  fConfigByte:=fConfigByte or ((ord(FResolution) and $3)shl 2);
  fConfigByte:=fConfigByte or (byte(ord(FGain)) and $3);
  fConfigByte:=fConfigByte or $80;
//  Configuration();
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
  inherited Create(ChanelNumber,MCP3424_Module);
//  Pins:=TPins_MCP3424.Create(fName);

//  fChanelNumber:=ChanelNumber;
//  fName:='Ch'+inttostr(ord(ChanelNumber)+1)+'_MCP3424';
//  fParentModule:=MCP3424_Module;
//  PinsCreate();

end;



//procedure TMCP3424_Channel.Free;
//begin
// Pins.Free;
//end;
//
//function TMCP3424_Channel.GetData: double;
//begin
// SetModuleParameters();
// Result:=fParentModule.GetData;
//end;
//
//procedure TMCP3424_Channel.GetDataThread(WPARAM: word; EventEnd: THandle);
//begin
// SetModuleParameters();
// fParentModule.GetDataThread(WPARAM,EventEnd);
//end;

procedure TMCP3424_Channel.SetModuleParameters;
begin
  inherited SetModuleParameters();
  (fParentModule as TMCP3424_Module).Resolution := TMCP3424_Resolution(round((Pins.PinControl - 12) / 2) and $3);
  (fParentModule as TMCP3424_Module).Gain := TMCP3424_Gain((round(Log2(Pins.PinGate)) and $3));

//  fParentModule.ActiveChannel := fChanelNumber;
//  fParentModule.Resolution := TMCP3424_Resolution(round((Pins.PinControl - 12) / 2) and $3);
//  fParentModule.Gain := TMCP3424_Gain((round(Log2(Pins.PinGate)) and $3));
end;

procedure TMCP3424_Channel.PinsCreate;
begin
  Pins:=TPins_MCP3424.Create(fName);
//  Pins := TPins.Create(fName, ['Bits mode', 'Gain']);
//  Pins.PinStrPart := '';
//  Pins.PinControl := 12;
//  // зберігатиметься Resolution
//  Pins.PinGate := 1;
//  // зберігатиметься Gain
end;

//function TMCP3424_Channel.GetNewData: boolean;
//begin
// Result:=fParentModule.NewData;
//end;
//
//function TMCP3424_Channel.GetValue: double;
//begin
// Result:=fParentModule.Value;
//end;
//
//procedure TMCP3424_Channel.SetNewData(Value: boolean);
//begin
// fParentModule.NewData:=Value;
//end;



{ TMCP3424_ChannelShow }

constructor TMCP3424_ChannelShow.Create(Chan: TMCP3424_Channel;
                         LabelBit,LabelGain:TPanel;
                         LabelMeas: TLabel;
                         ButMeas: TButton);
begin
// inherited Create(Chan,[LabelBit,LabelGain],LabelMeas,ButMeas);

  fChan:=Chan;
  inherited Create(fChan.Pins,[LabelBit,LabelGain]);
  LabelsFilling;

  MeasuringDeviceSimple:=
     TMeasuringDeviceSimple.Create(fChan,LabelMeas,srPreciseVoltage,ButMeas);
end;

procedure TMCP3424_ChannelShow.Free;
begin
  MeasuringDeviceSimple.Free;
  inherited Free;
end;

procedure TMCP3424_ChannelShow.LabelsFilling;
var
  i: TMCP3424_Resolution;
  j: TMCP3424_Gain;
begin
//  inherited LabelsFilling;

  fPinVariants[0].Clear;
  fPinVariants[1].Clear;
  for i := Low(TMCP3424_Resolution) to High(TMCP3424_Resolution) do
//    fPinVariants[0].Add(inttostr(MCP3424_Resolution_Data[i]));
    fPinVariants[0].Add(MCP3424_Resolution_Label[i]);
  for j := Low(TMCP3424_Gain) to High(TMCP3424_Gain) do
//    fPinVariants[1].Add(inttostr(MCP3424_Gain_Data[j]));
    fPinVariants[1].Add('+/-'+MCP3424_Diapazons[j]+' V');
end;

//procedure TMCP3424_ChannelShow.PinsReadFromIniFile(ConfigFile: TIniFile);
//begin
// showmessage('jj');
//  inherited PinsReadFromIniFile(ConfigFile);
//
//end;

{ TPins_MCP3424 }

constructor TPins_MCP3424.Create(Nm: string);
begin
  inherited Create(Nm, ['Bits mode', 'Diapazon']);
  PinStrPart := '';
  PinControl := 12;
  // зберігатиметься Resolution
  PinGate := 1;
  // зберігатиметься Gain
end;

function TPins_MCP3424.GetPinStr(Index: integer): string;
begin
 if fPins[Index]=UndefinedPin then
   Result:=PNames[Index] +' is undefined'
                              else
   Result:=PinValueToStr(Index);
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
// showmessage(Str);
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
