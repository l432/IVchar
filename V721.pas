unit V721;

interface
 uses OlegType,CPort,Dialogs,SysUtils,Classes,Windows,Forms,SyncObjs;

type
  TMeasureMode=(IA,ID,UA,UD,MMErr);
  TDiapazons=(nA100,micA1,micA10,micA100,mA1,mA10,mA100,mA1000,
              mV10,mV100,V1,V10,V100,V1000,DErr);

  TVoltmetr=class
  {базовий клас для вольтметрів серії В7-21}
  private
   fMeasureMode:TMeasureMode;
   fValue:double;
   fDiapazon:TDiapazons;
   fIsReady:boolean;
   fIsReceived:boolean;
//   fComPort:TComPort;
//   fComPacket: TComDataPacket;
   fPacket:array of byte;
   PinNumber:byte;
   fData:array of byte;

   Procedure MModeDetermination(Data:byte); virtual;abstract;
   Procedure DiapazonDetermination(Data:byte); virtual;abstract;
   Procedure ValueDetermination(Data:array of byte);virtual;
   Procedure PacketCreate();
  public
//   fEvent:TEvent;
   ComPort:TComPort;
   fComPacket: TComDataPacket;
   property MeasureMode:TMeasureMode read FMeasureMode;
   property Value:double read fValue;
   property Diapazon:TDiapazons read fDiapazon;
   property isReady:boolean read fIsReady;
   Procedure ConvertToValue(Data:array of byte);
   Constructor Create(NumberPin:byte);
   Procedure Free;
   Function Request():boolean;
   Procedure PacketReceiving(Sender: TObject; const Str: string);
   Function Measurement():double;
  end;

  TV721A=class(TVoltmetr)
  private
   Procedure MModeDetermination(Data:byte);override;
   Procedure DiapazonDetermination(Data:byte);override;
  public
  end;

  TV721=class(TVoltmetr)
  private
   Procedure MModeDetermination(Data:byte);override;
   Procedure DiapazonDetermination(Data:byte);override;
   Procedure ValueDetermination(Data:array of byte);override;
  public
  end;


const
  MeasureModeLabels:array[TMeasureMode]of string=
   ('~ I', '= I','~ U', '= U','Error');
  DiapazonsLabels:array[TDiapazons]of string=
   ('100 nA','1 micA','10 micA','100 micA',
    '1 mA','10 mA','100 mA','1000 mA',
     '10 mV','100 mV','1 V','10 V','100 V','1000 V','Error');

  PacketBegin=10;
  PacketEnd=255;
  PacketBeginChar=#10;
  PacketEndChar=#255;

  V7_21Command=$1;

Function BCDtoDec(BCD:byte; isLow:boolean):byte;
{виділяє з ВCD, яке містить дві десяткові
цифри у двійково-десятковому представленні,
ці цифри;
якщо  isLow=true, то виділення із
молодшої частини байта}

Function FCSCalculate(Data:array of byte):byte;
{розраховується інвертована
перша комплементарна сума}

Procedure DiapazonFill(Mode:TMeasureMode; Diapazons:TStrings);
{заповнює Diapazons можливими назвами діапазонів
з DiapazonsLabels залежно від Mode}

Function DiapazonSelect(Mode:TMeasureMode;Diapazon:TDiapazons):integer;
{визначається порядковий номер, який
відповідає Diapazon при даному Mode}

implementation

Constructor TVoltmetr.Create(NumberPin:byte);
begin
  inherited Create();
  PinNumber:=NumberPin;
  fIsReady:=False;
  fIsReceived:=False;
  fMeasureMode:=MMErr;
  fDiapazon:=DErr;
  fComPacket:=TComDataPacket.Create(ComPort);
  fComPacket.Size:=0;
  fComPacket.MaxBufferSize:=1024;
  fComPacket.IncludeStrings:=False;
  fComPacket.CaseInsensitive:=False;
  fComPacket.StartString:=PacketBeginChar;
  fComPacket.StopString:=PacketEndChar;
//  ComPort.TriggersOnRxChar:=False;
//  fComPacket.ComPort:=ComPort;
  fComPacket.OnPacket:=PacketReceiving;
//  fEvent:=TEvent.Create(nil,True,True,#0);
end;

Procedure TVoltmetr.Free;
begin
 fComPacket.Free;
// fEvent.Free;
 inherited;
end;



Procedure TVoltmetr.ValueDetermination(Data:array of byte);
 var temp:double;
begin
 temp:=BCDtoDec(Data[0],True);
 temp:=BCDtoDec(Data[0],False)*10+temp;
 temp:=temp+BCDtoDec(Data[1],True)*100;
 temp:=temp+BCDtoDec(Data[1],False)*1000;
 temp:=temp+BCDtoDec(Data[1],False)*1000;
 temp:=temp+((Data[2] shr 4)and$1)*10000;
 if (Data[2] shr 5)and$1>0 then temp:=-temp;
 case fDiapazon of
   nA100:   fValue:=temp*1e-11;
   micA1:   fValue:=temp*1e-10;
   micA10:  fValue:=temp*1e-9;
   micA100: fValue:=temp*1e-8;
   mA1:     fValue:=temp*1e-7;
   mA10:    fValue:=temp*1e-6;
   mA100:   fValue:=temp*1e-5;
   mA1000:  fValue:=temp*1e-4;
   mV10:    fValue:=temp*1e-6;
   mV100:   fValue:=temp*1e-5;
   V1:      fValue:=temp*1e-4;
   V10:     fValue:=temp*1e-3;
   V100:    fValue:=temp*1e-2;
   V1000:   fValue:=temp*1e-1;
   DErr:    fValue:=ErResult;
 end;
end;

Procedure TVoltmetr.PacketCreate();
begin
  SetLength(fPacket,6);
  fPacket[0]:=0;
  fPacket[5]:=0;
  fPacket[4]:=0;
  fPacket[1]:=4;
  fPacket[2]:=V7_21Command;
  fPacket[3]:=PinNumber;
  fPacket[4]:=FCSCalculate(fPacket);
  fPacket[0]:=PacketBegin;
  fPacket[5]:=PacketEnd;
//  showmessage(inttostr(fPacket[0])+' '+
//              inttostr(fPacket[1])+' '+
//              inttostr(fPacket[2])+' '+
//              inttostr(fPacket[3])+' '+
//              inttostr(fPacket[4])+' '+
//              inttostr(fPacket[5])+' ');

end;

Function TVoltmetr.Request():boolean;
begin
  PacketCreate();
  Result:=False;
  if ComPort.Connected then
   begin
    ComPort.ClearBuffer(True, True);
    Result:=(ComPort.Write(fPacket[0], High(fPacket)+1)=
                               (High(fPacket)+1));
   end;
end;

Function TVoltmetr.Measurement():double;
label start;
var {i0,}i:integer;
    isFirst:boolean;
begin
 Result:=ErResult;
 if not(ComPort.Connected) then
   begin
    showmessage('Port is not connected');
    Exit;
   end;

 isFirst:=True;
start:
 fIsReady:=False;
 fIsReceived:=False;
 if not(Request()) then Exit;
// fEvent.ResetEvent;
// fEvent.WaitFor(5000);
// i0:=GetTickCount;
 i:=0;
 repeat
   sleep(10);
   inc(i);
 Application.ProcessMessages;
 until ((i>130)or(fIsReceived));
// showmessage(inttostr((GetTickCount-i0)));
 if fIsReceived then ConvertToValue(fData);
 if fIsReady then Result:=fValue;
//      showmessage('ff '+booltostr(isFirst));

 if ((Result=ErResult)or(abs(Result)<1e-14))and(isFirst) then
    begin
//      showmessage('kkkk');
      isFirst:=false;
//      showmessage(booltostr(isFirst));
      goto start;
    end;
end;

procedure TVoltmetr.PacketReceiving(Sender: TObject; const Str: string);
 var i:integer;
//     Data:array of byte;
    tempstr:string;
begin
 SetLength(fData,Length(Str));

 tempstr:='';
 for I := 0 to High(fData) do
   begin
   fData[i]:=ord(str[i+1]);
   tempstr:=tempstr+inttostr(fData[i])+' ';
   end;
// showmessage(tempstr);
 if fData[0]<>Length(Str) then Exit;
 if fData[1]<>V7_21Command then Exit;
 if fData[2]<>PinNumber then Exit;
 if FCSCalculate(fData)<>0 then Exit;
 for I := 0 to High(fData)-4 do
   fData[i]:=fData[i+3];
 SetLength(fData,High(fData)-3);
 fIsReceived:=True;
//// fEvent.SetEvent;
end;

Procedure TVoltmetr.ConvertToValue(Data:array of byte);
begin
//  fIsready:=False;
  if High(Data)<>3 then Exit;
  MModeDetermination(Data[2]);
  if fMeasureMode=MMErr then Exit;
  DiapazonDetermination(Data[3]);
  if fDiapazon=DErr then Exit;
  ValueDetermination(Data);
  if Value=ErResult then Exit;
  fIsready:=True;
end;

Procedure TV721A.MModeDetermination(Data:byte);
begin
 Data:=Data and $0F;
  case Data of
   1: fMeasureMode:=UD;
   2: fMeasureMode:=UA;
   4: fMeasureMode:=ID;
   8: fMeasureMode:=IA;
   else fMeasureMode:=MMErr;
  end;
end;

Procedure TV721.MModeDetermination(Data:byte);
begin
 Data:=Data and $07;
  case Data of
   7: fMeasureMode:=UD;
   5: fMeasureMode:=UA;
   3: fMeasureMode:=ID;
   else fMeasureMode:=MMErr;
  end;
end;

Procedure TV721A.DiapazonDetermination(Data:byte);
begin
  fDiapazon:=DErr;
  case Data of
   128:if(fMeasureMode=IA)or(fMeasureMode=ID)
                      then fDiapazon:=mA1000
                      else fDiapazon:=V1000;
   64: if(fMeasureMode=IA)or(fMeasureMode=ID)
                      then fDiapazon:=mA100
                      else fDiapazon:=V100;
   32: if(fMeasureMode=IA)or(fMeasureMode=ID)
                      then fDiapazon:=mA10
                      else fDiapazon:=V10;
   16: if(fMeasureMode=IA)or(fMeasureMode=ID)
                      then fDiapazon:=mA1
                      else fDiapazon:=V1;
   8:  if(fMeasureMode=IA)or(fMeasureMode=ID)
                      then fDiapazon:=micA100
                      else fDiapazon:=mV100;
   4:  if(fMeasureMode=ID)then fDiapazon:=micA10
                          else
           if(fMeasureMode=UD) then  fDiapazon:=mV10
                               else Exit;
   2:  if(fMeasureMode=ID) then fDiapazon:=micA1
                           else Exit;
   1:  if(fMeasureMode=ID) then fDiapazon:=nA100
                           else Exit;
  end;
end;

Procedure TV721.DiapazonDetermination(Data:byte);
begin
  fDiapazon:=DErr;
  case Data of
   127:if fMeasureMode=ID
                      then fDiapazon:=mA1000
                      else fDiapazon:=V1000;
   191: if fMeasureMode=ID
                      then fDiapazon:=mA100
                      else fDiapazon:=V100;
   223: if fMeasureMode=ID
                      then fDiapazon:=mA10
                      else fDiapazon:=V10;
   239: if fMeasureMode=ID
                      then fDiapazon:=mA1
                      else fDiapazon:=V1;
   247: if fMeasureMode=ID
                      then fDiapazon:=micA100
                      else fDiapazon:=mV100;
   251: if(fMeasureMode=ID)then fDiapazon:=micA10
                           else
           if(fMeasureMode=UD) then  fDiapazon:=mV10
                               else Exit;
   253: if(fMeasureMode=ID) then fDiapazon:=micA1
                           else Exit;
   254: if(fMeasureMode=ID) then fDiapazon:=nA100
                           else Exit;
  end;
end;

Procedure TV721.ValueDetermination(Data:array of byte);
begin
  inherited ValueDetermination(Data);
  if fValue<>ErResult then fValue:=-fValue;
end;

Function BCDtoDec(BCD:byte; isLow:boolean):byte;
{виділяє з ВCD, яке містить дві десяткові
цифри у двійково-десятковому представленні,
ці цифри;
якщо  isLow=true, то виділення із
молодшої частини байта}
begin
 if isLow then BCD:=BCD Shl 4;
 Result:= BCD Shr 4;
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

Procedure DiapazonFill(Mode:TMeasureMode; Diapazons:TStrings);
{заповнює Diapazons можливими назвами діапазонів
з DiapazonsLabels залежно від Mode}
 var i,i0,i_end:TDiapazons;
begin
 Diapazons.Clear;
 i0:=DErr;
 i_end:=DErr;
 case Mode of
   IA: begin i0:=micA100; i_end:=mA1000; end;
   ID: begin i0:=nA100; i_end:=mA1000; end;
   UA: begin i0:=mV100; i_end:=V1000; end;
   UD: begin i0:=mV10; i_end:=V1000; end;
 end;
 for I := i0 to i_end do
  begin
   Diapazons.Add(DiapazonsLabels[i])
  end;
 if i0<>DErr then Diapazons.Add(DiapazonsLabels[DErr]);
end;

Function DiapazonSelect(Mode:TMeasureMode;Diapazon:TDiapazons):integer;
{визначається порядковий номер, який
відповідає Diapazon при даному Mode}
 var i0:TDiapazons;
begin
 if Mode=MMErr then
   begin
     Result:=0;
     Exit;
   end;
 i0:=DErr;
 case Mode of
   IA: i0:=micA100;
   ID: i0:=nA100;
   UA: i0:=mV100;
   UD: i0:=mV10;
  end;
 Result:=ord(Diapazon)-ord(i0);
end;

end.
