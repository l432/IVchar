unit SCPI;

interface

uses
  RS232deviceNew, CPort, OlegTypePart2;

const
//  TestShow=True;
  TestShow=False;

  SCPI_PacketBeginChar='';
  SCPI_PacketEndChar=#10;

type
 TLimits=(lvMin,lvMax);
 TLimitValues=array[TLimits] of double;

  TSCPInew=class(TNamedInterfacedObject)
   private
    procedure SetFlags(RootNode,FirstLevelNode,LeafNode:byte;
                  IsSuffix:boolean=True;isQuery:boolean=False);
   protected
    fDevice:TMeterDevice;
    fRootNode:byte;
    fFirstLevelNode:byte;
    fLeafNode:byte;
    fIsSuffix:boolean;
    fIsQuery:boolean;
    fAdditionalString:string;
    procedure QuireOperation(RootNode:byte;FirstLevelNode:byte=0;LeafNode:byte=0;
                            isSyffix:boolean=True{;isQuery:boolean=False});
    procedure SetupOperation(RootNode:byte;FirstLevelNode:byte=0;LeafNode:byte=0;
                            isSyffix:boolean=True;isQuery:boolean=False);
    procedure DeviceCreate(Nm:string='Device');virtual;abstract;
    procedure PrepareString;virtual;abstract;
    procedure JoinAddString();
    function StringToInvertedCommas(str:string):string;
    procedure DefaultSettings;virtual;
    function SCPI_StringToValue(Str:string):double;
    Function DeleteSubstring(Source:string;Substring: string=':'):string;
    Function FloatToStrLimited(Value:double;LimitValues:TLimitValues):string;
   public
    Constructor Create(Nm:string);
    destructor Destroy;override;
    procedure ProcessingString(Str:string);virtual;abstract;
    function Test():boolean;virtual;abstract;
  end;

  TRS232_SCPI=class(TRS232)
    protected
    public
     Constructor Create(CP:TComPort;BufferInputSize:Integer=1024;
                                    MaxBufferSize:Integer=1024);
    end;

  TDataRequest_SCPI=class(TCDDataRequest)
    protected
     function IsNoSuccessSend:Boolean;override;
    public
     procedure Request;override;
  end;

  TSCPI=class(TRS232MeterDeviceSingle)
    protected
     procedure CreateDataRequest;override;
  end;

var
  StringToSend:string;

implementation

uses
  Dialogs, SysUtils, OlegType, Math;

{ TRS232_SCPI }

constructor TRS232_SCPI.Create(CP: TComPort; BufferInputSize,
                               MaxBufferSize: Integer);
begin
 inherited Create(CP,SCPI_PacketBeginChar,SCPI_PacketEndChar);
 fComPacket.MaxBufferSize:=MaxBufferSize;
 fComPort.Buffer.InputSize:=BufferInputSize;
end;

{ TDataRequest_SCPI }

function TDataRequest_SCPI.IsNoSuccessSend: Boolean;
begin
// showmessage(inttostr(fRS232.ComPort.WriteStr(StringToSend+SCPI_PacketEndChar)));
// showmessage(inttostr(Length(StringToSend)+1));
 Result:=(fRS232.ComPort.WriteStr(StringToSend+SCPI_PacketEndChar)<>(Length(StringToSend)+1));
end;

procedure TDataRequest_SCPI.Request;
begin
 if TestShow then showmessage('send:  '+StringToSend);
 inherited Request;
end;

{ TSCPI }

procedure TSCPI.CreateDataRequest;
begin
 fDataRequest:=TDataRequest_SCPI.Create(Self.fDataSubject.RS232,Self);
end;

{ TSCPInew }

constructor TSCPInew.Create(Nm:string);
begin
 inherited Create;
 fName:=Nm;
 DeviceCreate(Nm);
 DefaultSettings();
 SetFlags(0,0,0);
end;

procedure TSCPInew.DefaultSettings;
begin
end;

function TSCPInew.DeleteSubstring(Source, Substring: string): string;
begin
 Result:=Source;
 if pos(Substring,Source)<>0 then
     Delete(Result,pos(Substring,Source),Length(Substring));
end;

destructor TSCPInew.Destroy;
begin
  FreeAndNil(fDevice);
  inherited;
end;

function TSCPInew.FloatToStrLimited(Value: double;
  LimitValues: TLimitValues): string;
begin
  Value:=min(Value,LimitValues[lvMax]);
  Value:=max(Value,LimitValues[lvMin]);
  Result:=FloatToStrF(Value,ffExponent,4,0);
end;

procedure TSCPInew.JoinAddString;
begin
 if fIsQuery then fDevice.JoinToStringToSend('?')
             else fDevice.JoinToStringToSend(' '+fAdditionalString);
end;

procedure TSCPInew.QuireOperation(RootNode, FirstLevelNode, LeafNode: byte;
  isSyffix{, isQuery}: boolean);
begin
 SetFlags(RootNode, FirstLevelNode, LeafNode,isSyffix,True);
 PrepareString();
 fDevice.GetData;
end;

function TSCPInew.SCPI_StringToValue(Str: string): double;
  function MultiplierIsPresent(MultiplierMark:char;Multiplier:double;var Value:double):boolean;
   begin
     result:=AnsiPos(MultiplierMark,Str)>0;
     if Result then Value:=Multiplier*StrToFloat(Copy(Str,1,AnsiPos(MultiplierMark, Str)-1));
   end;
begin
  try
    if MultiplierIsPresent('n',1e-9,Result) then Exit;
    if MultiplierIsPresent('m',1e-3,Result) then Exit;
    if MultiplierIsPresent('u',1e-6,Result) then Exit;
    if MultiplierIsPresent('k',1e3,Result) then Exit;
    if MultiplierIsPresent('M',1e6,Result) then Exit;
    if MultiplierIsPresent('V',1,Result) then Exit;
    Result:=StrToFloat(Str);
//    if AnsiPos('.', Str)>1 then  Result:=StrToFloat(Copy(Str,1,5))
//                          else  Result:=StrToFloat(Copy(Str,1,4));
  except
   Result:=ErResult;
  end;
end;

procedure TSCPInew.SetFlags(RootNode, FirstLevelNode, LeafNode: byte; IsSuffix,
  isQuery: boolean);
begin
 fRootNode:=RootNode;
 fFirstLevelNode:=FirstLevelNode;
 fLeafNode:=LeafNode;
 fIsSuffix:=IsSuffix;
 fIsQuery:=isQuery;
end;

procedure TSCPInew.SetupOperation(RootNode, FirstLevelNode, LeafNode: byte;
  isSyffix, isQuery: boolean);
begin
 SetFlags(RootNode, FirstLevelNode, LeafNode,isSyffix,isQuery);
 PrepareString();
 fDevice.Request();
end;

function TSCPInew.StringToInvertedCommas(str: string): string;
begin
 Result:='"'+str+'"';
end;

end.
