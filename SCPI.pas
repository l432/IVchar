unit SCPI;

interface

uses
  RS232deviceNew, CPort, OlegTypePart2, OlegType, StrUtils, Measurement;

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
//    function StringToInvertedCommas(str:string):string;
    procedure DefaultSettings;virtual;
    function SCPI_StringToValue(Str:string):double;
    Function DeleteSubstring(Source:string;Substring: string=':'):string;
    Function NumberToStrLimited(Value:double;LimitValues:TLimitValues):string;overload;
    Function NumberToStrLimited(Value:integer;LimitValues:TLimitValues):string;overload;
    Function NumbersArrayToStrLimited(Values:TArrSingle;LimitValues:TLimitValues):string;overload;
    Function NumbersArrayToStrLimited(Values:TArrInteger;LimitValues:TLimitValues):string;overload;
    procedure StrToNumberArray(var Values:TArrSingle; Str:string; Decimator:string=',');
    {������ � Values �����, ���������� � ����� Str � ������� �� ����� Decimator}
    procedure JoinToStringToSend(Str:string);
   public
    property Device:TMeterDevice read fDevice;
    Constructor Create(Nm:string);
    destructor Destroy;override;
    function Test():boolean;virtual;abstract;
    procedure ProcessingString(Str:string);virtual;abstract;
    class Function NumberMap(Value:double;LimitValues:TLimitValues):double;overload;
    {����������� �����. ��� ����������� � ����� LimitValues}
    class Function NumberMap(Value:integer;LimitValues:TLimitValues):integer;overload;
    class function StringToInvertedCommas(str:string):string;
    class function DeleteSubstringAll(Source:string;Substring: string=' '):string;
  end;

TMeasurementSimple=class(TNamedInterfacedObject,IMeasurement)
{��������� ��� ������� ���������� �� ������ ������ �����������
����� ��'���, ��� ����� ������ ���������� ��������� ����
���� ��������, � ��� ��������� ��������� ���������� ��������,
��� ����� ���� ���������, ���������, �� TMeasurementShowSimple}
 protected
  fValue:double;
  fNewData:boolean;
  function GetNewData:boolean;
  function GetValue:double;
  procedure SetNewData(Value:boolean);
  function GetDeviceKod:byte;
 public
 property NewData:boolean read GetNewData write SetNewData;
 property Value:double read GetValue;
 function GetData:double;virtual;abstract;
 procedure GetDataThread(WPARAM: word; EventEnd:THandle);
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
  Dialogs, SysUtils, Math, OlegFunction;

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
     Delete(Result,pos(Substring,Result),Length(Substring));
end;

class function TSCPInew.DeleteSubstringAll(Source, Substring: string): string;
begin
 Result:=Source;
 while pos(Substring,Result)<>0 do
   Delete(Result,pos(Substring,Result),Length(Substring));
end;

destructor TSCPInew.Destroy;
begin
  FreeAndNil(fDevice);
  inherited;
end;

function TSCPInew.NumberToStrLimited(Value: double;
  LimitValues: TLimitValues): string;
begin
//  Value:=min(Value,LimitValues[lvMax]);
//  Value:=max(Value,LimitValues[lvMin]);
  Result:=FloatToStrF(NumberMap(Value,LimitValues),ffExponent,4,0);
end;

procedure TSCPInew.JoinAddString;
begin
 if fIsQuery then fDevice.JoinToStringToSend('?')
             else fDevice.JoinToStringToSend(' '+fAdditionalString);
end;

procedure TSCPInew.JoinToStringToSend(Str: string);
begin
 fDevice.JoinToStringToSend(Str);
end;

function TSCPInew.NumbersArrayToStrLimited(Values: TArrSingle;
  LimitValues: TLimitValues): string;
 var i:integer;
begin
 Result:='';
 if High(Values)<0 then Exit;
 for I := Low(Values) to High(Values) do
   Result:=Result+NumberToStrLimited(Values[i],LimitValues)+', ';
 Delete(Result, Length(Result)-1, 2);
end;

class function TSCPInew.NumberMap(Value: double; LimitValues: TLimitValues): double;
begin
  Result:=max(min(Value,LimitValues[lvMax]),LimitValues[lvMin]);
end;

class function TSCPInew.NumberMap(Value: integer; LimitValues: TLimitValues): integer;
begin
  Result:=Ceil(max(Floor(min(Value,LimitValues[lvMax])),LimitValues[lvMin]));
end;

function TSCPInew.NumbersArrayToStrLimited(Values: TArrInteger;
  LimitValues: TLimitValues): string;
 var i:integer;
begin
 Result:='';
 if High(Values)<0 then Exit;
 for I := Low(Values) to High(Values) do
   Result:=Result+NumberToStrLimited(Values[i],LimitValues)+' ';
 Delete(Result, Length(Result)-1, 2);
end;

function TSCPInew.NumberToStrLimited(Value: integer;
  LimitValues: TLimitValues): string;
begin
//  Value:=Floor(min(Value,LimitValues[lvMax]));
//  Value:=Ceil(max(Value,LimitValues[lvMin]));
  Result:=IntToStr(NumberMap(Value,LimitValues));
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

class function TSCPInew.StringToInvertedCommas(str: string): string;
begin
 Result:='"'+str+'"';
end;

procedure TSCPInew.StrToNumberArray(var Values: TArrSingle; Str,
  Decimator: string);
  var i:integer;
begin
  Str:=AnsiReplaceStr(Str,Decimator,' ');
  Str:=SomeSpaceToOne(Str);
  SetLength(Values,NumberOfSubstringInRow(Str));
  for I := 0 to High(Values) do
   Values[i]:=FloatDataFromRow(Str,i+1);
end;

{ TMeasurementSimple }


procedure TMeasurementSimple.GetDataThread(WPARAM: word; EventEnd: THandle);
begin
  // �� ������
end;

function TMeasurementSimple.GetDeviceKod: byte;
begin
 Result:=0;
end;


function TMeasurementSimple.GetNewData: boolean;
begin
   Result:=fNewData;
end;

function TMeasurementSimple.GetValue: double;
begin
  Result:=fValue;
end;

procedure TMeasurementSimple.SetNewData(Value: boolean);
begin
   fNewData:=Value;
end;

end.
