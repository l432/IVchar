unit PacketParameters;

interface
uses CPort,Dialogs,SysUtils;

type
  TArrByte=array of byte;

const
  PacketBegin=10;
  PacketEnd=15;
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
  MLX90615Command=$D;
  INA226Command=$E;
  STS21Command=$10;
  ADT74x0Command=$11;
  MCP9808Command=$12;
  AD5752Command=$13;
  ArduinoIVCommand=$14;

var
  aPacket:array of byte;

Procedure PacketCreate(Args: array of byte);
{����������� ����� (������������ ����� aPacket), ���� ���� Args ������
PacketBegin - 0-� ����
������� ������ (PacketBegin �� PacketEnd �� ������������) - 1-� ����
���������� ���� - ������������� ����
PacketEnd - �������� ����}
procedure StrToArrByte(const Str: string; var pData: TArrByte);

Function PacketIsSend(ComPort:TComPort; report:string):boolean;
{������ ������� aPacket ����� ComPort}
Function PacketIsReceived(const Str: string; var pData:TArrByte):boolean;overload;
{����� pData �������������� ��������
�� ������� Str � � ���� �������� ����������
�����, �� ���������� �������� � Str;
����������� ������, ����
- � 0-�� ������� ������ ����������� �������
- ��������� �������� ���������� ����}
Function PacketIsReceived(const Str: string; var pData:TArrByte; Command:byte):boolean;overload;
{���. ��������� +
- � ������� ������� Command}

Function FCSCalculate(Data:array of byte):byte;
{������������� �����������
����� �������������� ����}

Function ByteArrayToString(Data:array of byte):string;

Procedure ShowData(Data:array of byte);
{���������� �������� � �������, �� ������ Data}

Function CRC8(Data:array of byte;poly:byte=$07):byte;
{���������� CRC8, ����������� ������ poly ��������
��� ����������� (9-��) ���, ��� ������ �� ���� 1}

implementation

uses
  HighResolutionTimer,  OlegFunction, ArduinoDeviceNew;

Procedure PacketCreate( Args: array of byte);
var i,ProblemByteNumber,counter:byte;
begin
  ProblemByteNumber:= 0;
  for I := 0 to High(Args) do
   if Args[i]=PacketEnd then Inc(ProblemByteNumber);

   SetLength(aPacket,Length(Args)+5+ProblemByteNumber);
  aPacket[0]:=0;
  aPacket[1]:=Length(Args)+3+ProblemByteNumber;
  aPacket[2]:=ProblemByteNumber;
  counter:=3;
  for I := 0 to High(Args) do
   begin
    if Args[i]=PacketEnd then
      begin
       Args[i]:=Args[i]-1;
       aPacket[counter]:=i+2+ProblemByteNumber;
       inc(counter);
      end;
   end;
  aPacket[High(aPacket)]:=0;
  aPacket[High(aPacket)-1]:=0;
  for I :=Low(Args) to High(Args) do
        aPacket[i+counter]:=Args[i];
  aPacket[High(aPacket)-1]:=FCSCalculate(aPacket);
  aPacket[0]:=PacketBegin;
  aPacket[High(aPacket)]:=PacketEnd;

//  SetLength(aPacket,Length(Args)+4);
//  aPacket[0]:=0;
//  aPacket[1]:=Length(Args)+2;
//  aPacket[High(aPacket)]:=0;
//  aPacket[High(aPacket)-1]:=0;
//  for I :=Low(Args) to High(Args) do
//        aPacket[i+2]:=Args[i];
//  aPacket[High(aPacket)-1]:=FCSCalculate(aPacket);
//  aPacket[0]:=PacketBegin;
//  aPacket[High(aPacket)]:=PacketEnd;
end;

Function PacketIsSend(ComPort:TComPort; report:string):boolean;
begin
//  ShowData(aPacket);
//  HelpForMe(inttostr(MilliSecond)+ByteArrayToString(aPacket));
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

procedure StrToArrByte(const Str: string; var pData: TArrByte);
var
  i: Integer;
begin
  SetLength(pData, Length(Str));
  for I := 0 to High(pData) do
    pData[i] := ord(str[i + 1]);
end;

Function PacketIsReceived(const Str: string; var pData:TArrByte):boolean;
 var i:integer;
     WrongByteNumber:byte;
begin
 Result:=True;
 StrToArrByte(Str, pData);

 if pData[0]=Length(Str)+1 then
  begin
    SetLength(pData,High(pData)+2);
    pData[High(pData)]:=ord(PacketEndChar);
  end;
//  ShowData(pData);
//   HelpForMe(inttostr(MilliSecond)+ByteArrayToString(pData));

 if (pData[0]<>Length(Str))
    and(pData[0]<>Length(Str)+1) then Result:=False;


 if FCSCalculate(pData)<>0 then Result:=False;

     WrongByteNumber:=pData[1];
     for I := 1 to WrongByteNumber do
        pData[pData[i+1]]:=pData[pData[i+1]]+1;
     for i := 1 to High(pData)-(WrongByteNumber+1) do
         begin
         pData[i]:=pData[i+1+WrongByteNumber];
         end;
     SetLength(pData,High(pData)-WrongByteNumber);
//  HelpForMe(inttostr(MilliSecond)+ByteArrayToString(pData));
end;

Function PacketIsReceived(const Str: string; var pData:TArrByte; Command:byte):boolean;overload;
begin
 Result:=False;
 if not(PacketIsReceived(Str,pData)) then Exit;

 if pData[1]=Command then Result:=True;

// HelpForMe(inttostr(MilliSecond)+ByteArrayToString(pData));
end;

Function FCSCalculate(Data:array of byte):byte;
{������������� �����������
����� �������������� ����}
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


Function ByteArrayToString(Data:array of byte):string;
 var i:integer;
begin
 Result:='';
 for I := 0 to High(Data) do Result:=Result+'$'+inttohex(Data[i],2)+' ';
end;

Procedure ShowData(Data:array of byte);
// var i:integer;
//     temp:string;
begin
// temp:='';
// for I := 0 to High(Data) do temp:=temp+'$'+inttohex(Data[i],2)+' ';
// MessageDlg(temp,mtInformation,[mbOK], 0);
 MessageDlg(ByteArrayToString(Data),mtInformation,[mbOK], 0);

end;


Function CRC8(Data:array of byte;poly:byte=$07):byte;
{���������� CRC8, ����������� ������ poly ��������
��� ����������� (9-��) ���, ��� ������ �� ���� 1}
var  crc : byte;
    i,bit : integer;
begin
 crc:=$00;
 for i := Low(data) to High(data) do
   begin
     crc := crc xor data[i];
     for bit := 0 to 7 do
         if (crc and $80)>0  then crc:=(byte(crc shl 1)) xor poly
                             else crc:=byte(crc shl 1);
   end;
 Result:=crc;
end;


end.
