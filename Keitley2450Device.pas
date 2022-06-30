unit Keitley2450Device;

interface

uses
  Keitley2450Const, OlegTypePart2, SCPI;


const
 Kt2450_BufferStyleCommand:array [TKt2450_BufferStyle]
            of string=('comp', 'stan', 'full', 'writ','fullwrit');
 Keitley_BufferFillModeCommand:array [TKeitley_BufferFillMode]
            of string=('cont', 'once');
 Kt2450_DataRequestCommand:array[TKeitley_ReturnedData] of string=
               ('read, sour',
//                'read, time',
                'read, time, frac',
                'read, sour, time, frac',
                'read');
 DMM6500_DataRequestCommand:array[TKeitley_ReturnedData] of string=
               ('read, chan',
                'read, time, frac',
                'read, chan, time, frac',
                'read');

type

TKeitley_Buffer=class(TNamedInterfacedObject)
 private
  fSize:integer;
  {загалом ємність всіх буферів - 4,500,000 стандартних
  записів або 20,000,000 компактних}
  fStyle:TKt2450_BufferStyle;
  fFillMode:TKeitley_BufferFillMode;
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
  function DataDemandArrayPrefix:string;
 public
  property CountMax:integer read fSize write SetCountMax;
  property Style:TKt2450_BufferStyle read fStyle write fStyle;
  property FillMode:TKeitley_BufferFillMode read fFillMode write fFillMode;
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
  function DataDemand(DataType:TKeitley_ReturnedData):string;
  function DataDemandDM6500(DataType:TKeitley_ReturnedData):string;

  function DataDemandArray(DataType:TKeitley_ReturnedData):string;
  function DataDemandDM6500Array(DataType:TKeitley_ReturnedData):string;
end;


implementation

uses
  SysUtils, Math;

{ TKt2450_Buffer }

constructor TKeitley_Buffer.Create(Nm: string);
begin
 inherited Create;
 SetName(Nm);
 fSize:=10000;
 fStyle:=kt_bs_stan;
 fFillMode:=kt_fm_cont;
 fStartIndex:=1;
 fEndIndex:=1;
end;

function TKeitley_Buffer.DataDemand(DataType: TKeitley_ReturnedData): string;
begin
 Result:=GetGet+PartDelimiter+Kt2450_DataRequestCommand[DataType];
end;

function TKeitley_Buffer.DataDemandArray(DataType: TKeitley_ReturnedData): string;
begin
// Result:='? '+intToStr(fStartIndex)+PartDelimiter
//         +intToStr(fEndIndex)+PartDelimiter
//         +Name+PartDelimiter+Kt2450_DataRequestCommand[DataType];
Result:=DataDemandArrayPrefix+Kt2450_DataRequestCommand[DataType];
end;

function TKeitley_Buffer.DataDemandArrayPrefix: string;
begin
 Result:='? '+intToStr(fStartIndex)+PartDelimiter
         +intToStr(fEndIndex)+PartDelimiter
         +Name+PartDelimiter;
end;

function TKeitley_Buffer.DataDemandDM6500(
  DataType: TKeitley_ReturnedData): string;
begin
 Result:=GetGet+PartDelimiter+DMM6500_DataRequestCommand[DataType];
end;

function TKeitley_Buffer.DataDemandDM6500Array(
  DataType: TKeitley_ReturnedData): string;
begin
Result:=DataDemandArrayPrefix+DMM6500_DataRequestCommand[DataType];
end;

function TKeitley_Buffer.GetCreateStr: string;
begin
 Result:=Name+PartDelimiter
        +inttostr(fSize)+PartDelimiter
        +Kt2450_BufferStyleCommand[Style];
end;

function TKeitley_Buffer.GetFillMode: string;
begin
 Result:=Keitley_BufferFillModeCommand[fFillMode]
         +PartDelimiter+Name;
end;

function TKeitley_Buffer.GetGet: string;
begin
 Result:='? '+Name;
end;

function TKeitley_Buffer.GetLimitIndexies: string;
begin
 Result:=':star? '+Name+' ; end? '+Name;
end;

function TKeitley_Buffer.GetReSize: string;
begin
 Result:=inttostr(fSize)+PartDelimiter+Name;
end;

procedure TKeitley_Buffer.SetCountMax(Value: integer);
begin
 fSize:=TSCPInew.NumberMap(Value,Kt_2450_BufferSizeLimits)
end;

procedure TKeitley_Buffer.SetEndIndex(Value: integer);
begin
 fEndIndex:=max(Value,fStartIndex)
end;

procedure TKeitley_Buffer.SetName(Name: string);
 var temp:string;
begin
 temp:=TSCPInew.DeleteSubstringAll(Name);
 temp:=TSCPInew.DeleteSubstringAll(temp,'_');
 temp:=TSCPInew.DeleteSubstringAll(temp,'.');
 temp:=TSCPInew.DeleteSubstringAll(temp,',');
 if Length(temp)>31 then SetLength(temp,31);
 fName:='"'+temp+'"';
end;

procedure TKeitley_Buffer.SetStartIndex(Value: integer);
begin
 fStartIndex:=max(1,Value);
end;

function TKeitley_Buffer.StringToFillMode(Str: string): boolean;
  var i:TKeitley_BufferFillMode;
begin
 Result:=False;
 for I := Low(TKeitley_BufferFillMode) to high(TKeitley_BufferFillMode) do
   if pos(Keitley_BufferFillModeCommand[i],Str)<>0 then
     begin
       fFillMode:=i;
       Result:=True;
       Break;
     end;
end;

end.
