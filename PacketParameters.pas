unit PacketParameters;

interface
uses CPort,Dialogs,SysUtils;

type
  TArrByte=array of byte;

const
  PacketBegin=10;
  PacketEnd=255;
//  PacketBeginChar=#10;
//  PacketEndChar=#255;

//  V7_21Command=$1;
  ParameterReceiveCommand=$2;
  DACCommand=$3;
//  DACR2RCommand=$4;
  DS18B20Command=$5;
//  D30_06Command=$6;
//  PinChangeCommand=$7;
  HTU21DCommand=$8;
  TMP102Command=$9;
  MCP3424Command=$A;
  ADS1115Command=$B;
  AD9833Command=$C;

var
  aPacket:array of byte;

Procedure PacketCreate(const Args: array of byte);
{створюється пакет (заповнюється масив aPacket), який окрім Args містить
PacketBegin - 0-й байт
Довжину пакету (PacketBegin та PacketEnd не враховуються) - 1-й байт
Контрольну суму - передостанній байт
PacketEnd - останній байт}
Function PacketIsSend(ComPort:TComPort; report:string):boolean;
{спроба відіслати aPacket через ComPort}
Function PacketIsReceived(const Str: string; var pData:TArrByte):boolean;overload;
{розмір pData встановлюється відповідно
до довжини Str і в його елементи заносяться
числа, які відповідають символам з Str;
повертається правда, якщо
- в 0-му елементі масиву знаходиться довжина
- правильне значення контрольної суми}
Function PacketIsReceived(const Str: string; var pData:TArrByte; Command:byte):boolean;overload;
{див. попередню +
- в першому елементі Command}

Function FCSCalculate(Data:array of byte):byte;
{розраховується інвертована
перша комплементарна сума}
Procedure ShowData(Data:array of byte);
{виводиться віконечко з числами, які містить Data}

implementation

Procedure PacketCreate(const Args: array of byte);
var i:byte;
begin
  SetLength(aPacket,Length(Args)+4);
  aPacket[0]:=0;
  aPacket[1]:=Length(Args)+2;
  aPacket[High(aPacket)]:=0;
  aPacket[High(aPacket)-1]:=0;
  for I :=Low(Args) to High(Args) do
        aPacket[i+2]:=Args[i];
  aPacket[High(aPacket)-1]:=FCSCalculate(aPacket);
  aPacket[0]:=PacketBegin;
  aPacket[High(aPacket)]:=PacketEnd;
end;

Function PacketIsSend(ComPort:TComPort; report:string):boolean;
begin
//  ShowData(aPacket);
  if ComPort.Connected then
   begin
    ComPort.ClearBuffer(True, True);
    Result:=(ComPort.Write(aPacket[0], High(aPacket)+1)=
                               (High(aPacket)+1));
   end
                       else
   Result:=False;
 if not(Result) then MessageDlg(report,mtError, [mbOK], 0);
end;

Function PacketIsReceived(const Str: string; var pData:TArrByte):boolean;
 var i:integer;
begin
 Result:=True;

 SetLength(pData,Length(Str));
 for I := 0 to High(pData) do
   pData[i]:=ord(str[i+1]);

 if pData[0]<>Length(Str) then Result:=False;
 if FCSCalculate(pData)<>0 then Result:=False;
end;

Function PacketIsReceived(const Str: string; var pData:TArrByte; Command:byte):boolean;overload;
begin
 Result:=False;
 if not(PacketIsReceived(Str,pData)) then Exit;
 if pData[1]=Command then Result:=True;
end;

Function FCSCalculate(Data:array of byte):byte;
{розраховується інвертована
перша комплементарна сума}
 var FCS,i:integer;
begin
 FCS:=0;
 for I := 0 to High(Data) do
   begin
     FCS:=FCS+Data[i];
     while(FCS>255) do
      begin
        FCS:=(FCS and $FF)+((FCS shr 8)and $FF);
      end;
   end;
 FCS:=not(FCS);
 Result:=byte(FCS and $FF);
end;

Procedure ShowData(Data:array of byte);
 var i:integer;
     temp:string;
begin
 temp:='';
 for I := 0 to High(Data) do temp:=temp+'$'+inttohex(Data[i],2)+' ';
 MessageDlg(temp,mtInformation,[mbOK], 0);
end;

end.
