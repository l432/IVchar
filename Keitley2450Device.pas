unit Keitley2450Device;

interface

uses
  Keitley2450Const, OlegTypePart2;


const
 Kt2450_BufferStyleCommand:array [TKt2450_BufferStyle]
            of string=('comp', 'stan', 'full', 'writ','fullwrit');
 Kt2450_BufferFillModeCommand:array [TKt2450_BufferFillMode]
            of string=('cont', 'once');
 Kt2450_DataRequestCommand:array[TKt2450_ReturnedData] of string=
               ('read, sour',
//                'read, time',
                'read, time, frac',
                'read, sour, time, frac',
                'read');

type

TKt2450_Buffer=class(TNamedInterfacedObject)
 private
  fSize:integer;
  {загалом ємність всіх буферів - 4,500,000 стандартних
  записів або 20,000,000 компактних}
  fStyle:TKt2450_BufferStyle;
  fFillMode:TKt2450_BufferFillMode;
  fStartIndex:integer;
  fEndIndex:integer;
  function GetCreateStr:string;
  function GetReSize:string;
  function GetGet:string;
  function GetFillMode:string;
  function GetLimitIndexies:string;
  procedure SetCountMax(Value:integer);
  procedure SetStartIndex(Value:integer);
  procedure SetEndIndex(Value:integer);
 public
  property CountMax:integer read fSize write SetCountMax;
  property Style:TKt2450_BufferStyle read fStyle write fStyle;
  property FillMode:TKt2450_BufferFillMode read fFillMode write fFillMode;
  property CreateStr:string read GetCreateStr;
  property ReSize:string read GetReSize;
  property LimitIndexies:string read GetLimitIndexies;
  property Get:string read GetGet;
  property FillModeChange:string read GetFillMode;
  property StartIndex:integer read fStartIndex write SetStartIndex;
  property EndIndex:integer read fEndIndex write SetEndIndex;
  constructor Create(Nm:string=MyBuffer);
  procedure SetName(Name:string);
  function StringToFillMode(Str:string):boolean;
  function DataDemand(DataType:TKt2450_ReturnedData):string;
  function DataDemandArray(DataType:TKt2450_ReturnedData):string;
end;

implementation

uses
  SysUtils, SCPI, Math;

{ TKt2450_Buffer }

constructor TKt2450_Buffer.Create(Nm: string);
begin
 inherited Create;
 SetName(Nm);
 fSize:=10000;
 fStyle:=kt_bs_comp;
 fFillMode:=kt_fm_cont;
 fStartIndex:=1;
 fEndIndex:=1;
end;

function TKt2450_Buffer.DataDemand(DataType: TKt2450_ReturnedData): string;
begin
 Result:=GetGet+PartDelimiter+Kt2450_DataRequestCommand[DataType];
end;

function TKt2450_Buffer.DataDemandArray(DataType: TKt2450_ReturnedData): string;
begin
 Result:='? '+intToStr(fStartIndex)+PartDelimiter
         +intToStr(fEndIndex)+PartDelimiter
         +Name+PartDelimiter+Kt2450_DataRequestCommand[DataType];
end;

function TKt2450_Buffer.GetCreateStr: string;
begin
 Result:=Name+PartDelimiter
        +inttostr(fSize)+PartDelimiter
        +Kt2450_BufferStyleCommand[Style];
end;

function TKt2450_Buffer.GetFillMode: string;
begin
 Result:=Kt2450_BufferFillModeCommand[fFillMode]
         +PartDelimiter+Name;
end;

function TKt2450_Buffer.GetGet: string;
begin
 Result:='? '+Name;
end;

function TKt2450_Buffer.GetLimitIndexies: string;
begin
 Result:=':star? '+Name+' ; end? '+Name;
end;

function TKt2450_Buffer.GetReSize: string;
begin
 Result:=inttostr(fSize)+PartDelimiter+Name;
end;

procedure TKt2450_Buffer.SetCountMax(Value: integer);
begin
 fSize:=TSCPInew.NumberMap(Value,Kt_2450_BufferSizeLimits)
end;

procedure TKt2450_Buffer.SetEndIndex(Value: integer);
begin
 fEndIndex:=max(Value,fStartIndex)
end;

procedure TKt2450_Buffer.SetName(Name: string);
 var temp:string;
begin
 temp:=TSCPInew.DeleteSubstringAll(Name);
 temp:=TSCPInew.DeleteSubstringAll(temp,'_');
 temp:=TSCPInew.DeleteSubstringAll(temp,'.');
 temp:=TSCPInew.DeleteSubstringAll(temp,',');
 if Length(temp)>31 then SetLength(temp,31);
 fName:='"'+temp+'"';
end;

procedure TKt2450_Buffer.SetStartIndex(Value: integer);
begin
 fStartIndex:=max(1,Value);
end;

function TKt2450_Buffer.StringToFillMode(Str: string): boolean;
  var i:TKt2450_BufferFillMode;
begin
 Result:=False;
 for I := Low(TKt2450_BufferFillMode) to high(TKt2450_BufferFillMode) do
   if pos(Kt2450_BufferFillModeCommand[i],Str)<>0 then
     begin
       fFillMode:=i;
       Result:=True;
       Break;
     end;
end;

end.
