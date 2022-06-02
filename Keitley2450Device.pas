unit Keitley2450Device;

interface

uses
  Keitley2450Const, OlegTypePart2;


const
 TKt2450_BufferStyleCommand:array [TKt2450_BufferStyle]
            of string=('comp', 'stan', 'full', 'writ','fullwrit');

type

TKt2450_Buffer=class(TNamedInterfacedObject)
 private
  fSize:integer;
  {загалом ємність всіх буферів - 4,500,000 стандартних
  записів або 20,000,000 компактних}
  fStyle:TKt2450_BufferStyle;
  function GetCreateStr:string;
  function GetReSize:string;
  function GetGetSize:string;
  procedure SetCount(Value:integer);
 public
  property Count:integer read fSize write SetCount;
  property Style:TKt2450_BufferStyle read fStyle write fStyle;
  property CreateStr:string read GetCreateStr;
  property ReSize:string read GetReSize;
  property GetSize:string read GetGetSize;
  constructor Create(Nm:string=MyBuffer);
  procedure SetName(Name:string);
end;

implementation

uses
  SysUtils, SCPI;

{ TKt2450_Buffer }

constructor TKt2450_Buffer.Create(Nm: string);
begin
 inherited Create;
 SetName(Nm);
 fSize:=10000;
 fStyle:=kt_bs_comp;
end;

function TKt2450_Buffer.GetCreateStr: string;
begin
 Result:=Name+PartDelimiter
        +inttostr(fSize)+PartDelimiter
        +TKt2450_BufferStyleCommand[Style];
end;

function TKt2450_Buffer.GetGetSize: string;
begin
 Result:='? '+Name;
end;

function TKt2450_Buffer.GetReSize: string;
begin
 Result:=inttostr(fSize)+PartDelimiter+Name;
end;

procedure TKt2450_Buffer.SetCount(Value: integer);
begin
 fSize:=TSCPInew.NumberMap(Value,Kt_2450_BufferSizeLimits)
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

end.
