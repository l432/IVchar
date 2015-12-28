unit PacketParameters;

interface
uses CPort,Dialogs,SysUtils;

type
  TArrByte=array of byte;
//  PTArrSingle=^TArrSingle;

const
  PacketBegin=10;
  PacketEnd=255;
  PacketBeginChar=#10;
  PacketEndChar=#255;

  V7_21Command=$1;
  ParameterReceiveCommand=$2;

var
  aPacket:array of byte;

Procedure PacketCreate(const Args: array of byte);
{����������� ����� (������������ ����� aPacket), ���� ���� Args ������
PacketBegin - 0-� ����
������� ������ (PacketBegin �� PacketEnd �� ������������) - 1-� ����
���������� ���� - ������������ ����
PacketEnd - ������� ����}
Function PacketIsSend(ComPort:TComPort):boolean;
{������ ������� aPacket ����� ComPort}
//Function PacketIsReceived(const Str: string; pData:Pointer):boolean;overload;
Function PacketIsReceived(const Str: string; var pData:TArrByte):boolean;overload;
{����� pData �������������� ��������
�� ������� Str � � ���� �������� ����������
�����, �� ���������� �������� � Str;
����������� ������, ����
- � 0-�� ������� ������ ����������� �������
- ��������� �������� ���������� ����}
//Function PacketIsReceived(const Str: string; pData:Pointer; Command:byte):boolean;overload;
Function PacketIsReceived(const Str: string; var pData:TArrByte; Command:byte):boolean;overload;
{���. ��������� +
- � ������� ������� Command}

Function FCSCalculate(Data:array of byte):byte;
{������������� �����������
����� �������������� ����}
Procedure ShowData(Data:array of byte);
{���������� �������� � �������, �� ������ Data}

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

//  ShowData(aPacket)
end;

Function PacketIsSend(ComPort:TComPort):boolean;
// var itsOkey:boolean;
begin
  if ComPort.Connected then
   begin
    ComPort.ClearBuffer(True, True);
    Result:=(ComPort.Write(aPacket[0], High(aPacket)+1)=
                               (High(aPacket)+1));
   end
                       else
   Result:=False;
 if not(Result) then MessageDlg('Packet is not send',mtError, [mbOK], 0);
end;

Function PacketIsReceived(const Str: string; var pData:TArrByte):boolean;
 var i:integer;
//     Dat:array of byte;
begin
 Result:=True;

 SetLength(pData,Length(Str));
 for I := 0 to High(pData) do
   pData[i]:=ord(str[i+1]);

// ShowData(pData);

 if pData[0]<>Length(Str) then Result:=False;
 if FCSCalculate(pData)<>0 then Result:=False;

// Result:=True;
// Pointer(Dat):=pData;
// SetLength(Dat,Length(Str));
// for I := 0 to High(Dat) do
//   Dat[i]:=ord(Str[i+1]);
//// ShowData(Dat);
//
// if Dat[0]<>Length(Str) then Result:=False;
// if FCSCalculate(Dat)<>0 then Result:=False;
// Pointer(Dat) := nil;

end;

//Function PacketIsReceived(const Str: string; pData:Pointer; Command:byte):boolean;
// var
//     i:integer;
//     Dat:array of byte;
//begin
// Result:=True;
// Pointer(Dat):=pData;
//
// SetLength(Dat,Length(Str));
// for I := 0 to High(Dat) do
//   Dat[i]:=ord(str[i+1]);
//
// ShowData(Dat);
//
// if Dat[0]<>Length(Str) then Result:=False;
// if FCSCalculate(Dat)<>0 then Result:=False;
// if Dat[1]<>Command then Result:=False;
//
//// Result:=False;
//// if not(PacketIsReceived(Str,pData)) then Exit;
//// Pointer(Dat):=pData;
//// if Dat[1]=Command then Result:=True;
////
//
//// pData:=Pointer(Dat);
//
// Pointer(Dat) := nil;
//end;

Function PacketIsReceived(const Str: string; var pData:TArrByte; Command:byte):boolean;overload;
// var
//     i:integer;
//     Dat:array of byte;
begin
// Result:=True;
//
// SetLength(pData,Length(Str));
// for I := 0 to High(pData) do
//   pData[i]:=ord(str[i+1]);
//
// ShowData(pData);
//
// if pData[0]<>Length(Str) then Result:=False;
// if FCSCalculate(pData)<>0 then Result:=False;
// if pData[1]<>Command then Result:=False;

 Result:=False;
 if not(PacketIsReceived(Str,pData)) then Exit;
// Pointer(Dat):=pData;
 if pData[1]=Command then Result:=True;
//
// Pointer(Dat) := nil;
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

Procedure ShowData(Data:array of byte);
 var i:integer;
     temp:string;
begin
 temp:='';
 for I := 0 to High(Data) do temp:=temp+inttostr(Data[i])+' ';
 MessageDlg(temp,mtInformation,[mbOK], 0);
end;

end.
