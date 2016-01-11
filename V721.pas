unit V721;

interface
 uses OlegType,CPort,Dialogs,SysUtils,Classes,Windows,Forms,SyncObjs,PacketParameters,
     ExtCtrls,StdCtrls,Buttons,IniFiles;

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
//   fPacket:array of byte;
   fPinNumber:byte;
   fPinGateNumber:byte;
   fData:TArrByte;
   fName:string;

   Procedure MModeDetermination(Data:byte); virtual;
   Procedure DiapazonDetermination(Data:byte); virtual;
   Procedure ValueDetermination(Data:array of byte);virtual;
   Function GetPinNumberStr():string;
   Function PinGetGateNumberStr():string;
//   Procedure PacketCreate();
  public
//   fEvent:TEvent;
   ComPort:TComPort;
   fComPacket: TComDataPacket;
   property MeasureMode:TMeasureMode read FMeasureMode;
   property Value:double read fValue;
   property PinNumber:byte read fPinNumber write fPinNumber;
   property PinGateNumber:byte read fPinGateNumber write fPinGateNumber;
   property PinNumberStr:string read GetPinNumberStr;
   property PinGateNumberStr:string read PinGetGateNumberStr;
   property Diapazon:TDiapazons read fDiapazon;
   property isReady:boolean read fIsReady;
   property Name:string read fName;
   Procedure ConvertToValue(Data:array of byte);
   Constructor Create(NumberPin:byte);overload;
   Constructor Create(NumberPin,GateNumberPin:byte);overload;
   Constructor Create(NumberPin:byte;CP:TComPort);overload;
   Constructor Create(NumberPin,GateNumberPin:byte;CP:TComPort);overload;
   Constructor Create(CP:TComPort;Nm:string);overload;
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

  TVoltmetrShow=class
  private
   fIsReady:boolean;
   Voltmetr:TVoltmetr;
   MeasureMode,Range:TRadioGroup;
   DataLabel,UnitLabel,ControlPinLabel,GatePinLabel:TLabel;
   SetControlButton,SetGateButton,MeasurementButton:TButton;
   AutoSpeedButton:TSpeedButton;
   PinsComboBox:TComboBox;
   Time:TTimer;
  public
   Constructor Create(V:TVoltmetr;
                      MM,R:TRadioGroup;
                      DL,UL,CPL,GPL:TLabel;
                      SCB,SGB,MB:TButton;
                      AB:TSpeedButton;
                      PCB:TComboBox;
                      TT:TTimer);
   procedure PinsReadFromIniFile(ConfigFile:TIniFile);
   procedure PinsWriteToIniFile(ConfigFile:TIniFile);
   procedure NumberPinShow();
   procedure ButtonEnabled();
   procedure VoltmetrDataShow();
   procedure SetControlButtonClick(Sender: TObject);
   procedure SetGateButtonClick(Sender: TObject);
   procedure MeasurementButtonClick(Sender: TObject);
   procedure AutoSpeedButtonClick(Sender: TObject);
   procedure MeasureModeClick(Sender: TObject);
   procedure RangeClick(Sender: TObject);
  end;


const
  UndefinedPin=255;
  MeasureModeLabels:array[TMeasureMode]of string=
   ('~ I', '= I','~ U', '= U','Error');
  DiapazonsLabels:array[TDiapazons]of string=
   ('100 nA','1 micA','10 micA','100 micA',
    '1 mA','10 mA','100 mA','1000 mA',
     '10 mV','100 mV','1 V','10 V','100 V','1000 V','Error');

//  PacketBegin=10;
//  PacketEnd=255;
//  PacketBeginChar=#10;
//  PacketEndChar=#255;
//
//  V7_21Command=$1;

Function BCDtoDec(BCD:byte; isLow:boolean):byte;
{виділяє з ВCD, яке містить дві десяткові
цифри у двійково-десятковому представленні,
ці цифри;
якщо  isLow=true, то виділення із
молодшої частини байта}

//Function FCSCalculate(Data:array of byte):byte;
//{розраховується інвертована
//перша комплементарна сума}

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
  fPinNumber:=NumberPin;
  fPinGateNumber:=UndefinedPin;
  fIsReady:=False;
  fIsReceived:=False;
  fMeasureMode:=MMErr;
  fDiapazon:=DErr;
  fComPacket:=TComDataPacket.Create(fComPacket);
//  fComPacket:=TComDataPacket.Create(ComPort);
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

Constructor TVoltmetr.Create(NumberPin,GateNumberPin:byte);
begin
  Create(NumberPin);
  fPinGateNumber:=GateNumberPin;
end;


Constructor TVoltmetr.Create(NumberPin:byte;CP:TComPort);
begin
 Create(NumberPin);
 ComPort:=CP;
 fComPacket.ComPort:=CP;
end;

Constructor TVoltmetr.Create(NumberPin,GateNumberPin:byte;CP:TComPort);
begin
 Create(NumberPin,GateNumberPin);
 ComPort:=CP;
 fComPacket.ComPort:=CP;
end;


Constructor TVoltmetr.Create(CP:TComPort;Nm:string);
begin
 Create(UndefinedPin,CP);
 fName:=Nm;
end;

Procedure TVoltmetr.Free;
begin
 fComPacket.Free;
// fEvent.Free;
 inherited;
end;

Procedure TVoltmetr.MModeDetermination(Data:byte);
begin

end;

Procedure TVoltmetr.DiapazonDetermination(Data:byte);
begin

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

//Procedure TVoltmetr.PacketCreate();
//begin
//  SetLength(fPacket,6);
//  fPacket[0]:=0;
//  fPacket[5]:=0;
//  fPacket[4]:=0;
//  fPacket[1]:=4;
//  fPacket[2]:=V7_21Command;
//  fPacket[3]:=PinNumber;
//  fPacket[4]:=FCSCalculate(fPacket);
//  fPacket[0]:=PacketBegin;
//  fPacket[5]:=PacketEnd;
////  showmessage(inttostr(fPacket[0])+' '+
////              inttostr(fPacket[1])+' '+
////              inttostr(fPacket[2])+' '+
////              inttostr(fPacket[3])+' '+
////              inttostr(fPacket[4])+' '+
////              inttostr(fPacket[5])+' ');
//
//end;

Function TVoltmetr.Request():boolean;
begin
  PacketCreate([V7_21Command,PinNumber,PinGateNumber]);

//  ShowData(aPacket);
//  PacketIsReceived('gg1t',@aPacket[Low(aPacket)]);
//  ShowData(aPacket);
//  PacketCreate([V7_21Command,PinNumber]);
//  ShowData(aPacket);

    Result:=PacketIsSend(ComPort);

//  Result:=False;
//  if ComPort.Connected then
//   begin
//    ComPort.ClearBuffer(True, True);
//    Result:=(ComPort.Write(fPacket[0], High(fPacket)+1)=
//                               (High(fPacket)+1));
//   end;
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
//    tempstr:string;
begin
// if PacketIsReceived(Str,@fData[Low(fData)]) then Exit;

// if not(PacketIsReceived(Str,@fData[Low(fData)],V7_21Command)) then Exit;
 if not(PacketIsReceived(Str,fData,V7_21Command)) then Exit;

// SetLength(fData,Length(Str));
// tempstr:='';
// for I := 0 to High(fData) do
//   begin
//   fData[i]:=ord(str[i+1]);
//   tempstr:=tempstr+inttostr(fData[i])+' ';
//   end;
// showmessage(tempstr);

//  ShowData(fData);

// if fData[0]<>Length(Str) then Exit;
// if fData[1]<>V7_21Command then Exit;

 if fData[2]<>PinNumber then Exit;
// if FCSCalculate(fData)<>0 then Exit;

 for I := 0 to High(fData)-4 do
   fData[i]:=fData[i+3];
 SetLength(fData,High(fData)-3);
 fIsReceived:=True;
//// fEvent.SetEvent;
end;

Function TVoltmetr.GetPinNumberStr():string;
begin
  if PinNumber=UndefinedPin then
    Result:='Control pin is undefined'
                       else
    Result:='Control pin number is '+IntToStr(PinNumber);
end;


Function TVoltmetr.PinGetGateNumberStr():string;
begin
  if fPinGateNumber=UndefinedPin then
    Result:='Gate pin is undefined'
                       else
    Result:='Gate pin number is '+IntToStr(fPinGateNumber);
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

Constructor TVoltmetrShow.Create(V:TVoltmetr;
                      MM,R:TRadioGroup;
                      DL,UL,CPL,GPL:TLabel;
                      SCB,SGB,MB:TButton;
                      AB:TSpeedButton;
                      PCB:TComboBox;
                      TT:TTimer);
 var i:integer;
begin
  inherited Create();
   Voltmetr:=V;
   MeasureMode:=MM;
   Range:=R;
   DataLabel:=DL;
   UnitLabel:=UL;
   ControlPinLabel:=CPL;
   GatePinLabel:=GPL;
   MeasurementButton:=MB;
   AutoSpeedButton:=AB;
   SetControlButton:=SCB;
   SetGateButton:=SGB;
   PinsComboBox:=PCB;
   Time:=TT;
   fIsReady:=assigned(Voltmetr)and
             assigned(MeasureMode)and
             assigned(Range)and
             assigned(DataLabel)and
             assigned(ControlPinLabel)and
             assigned(GatePinLabel)and
             assigned(MeasurementButton)and
             assigned(AutoSpeedButton)and
             assigned(SetControlButton)and
             assigned(SetGateButton)and
             assigned(Time)and
             assigned(PinsComboBox);

  if fIsReady then
  begin
    MeasureMode.Items.Clear;
    for I := 0 to ord(MMErr) do
      MeasureMode.Items.Add(MeasureModeLabels[TMeasureMode(i)]);
    MeasureMode.ItemIndex := 4;
    UnitLabel.Caption := '';
    DiapazonFill(TMeasureMode(MeasureMode.ItemIndex), Range.Items);
    SetControlButton.OnClick:=SetControlButtonClick;
    SetGateButton.OnClick:=SetGateButtonClick;
    MeasurementButton.OnClick:=MeasurementButtonClick;
    AutoSpeedButton.OnClick:=AutoSpeedButtonClick;
    MeasureMode.OnClick:=MeasureModeClick;
    Range.OnClick:=RangeClick;
  end;
end;

Procedure TVoltmetrShow.PinsReadFromIniFile(ConfigFile:TIniFile);
 var TempPin:integer;
begin
  if not(fIsReady) then Exit;
  if Voltmetr.Name='' then Exit;
  TempPin := ConfigFile.ReadInteger(Voltmetr.Name, 'Control', -1);
  if (TempPin > -1) and (TempPin < PinsComboBox.Items.Count) then
    Voltmetr.PinNumber := StrToInt(PinsComboBox.Items[TempPin]);
  TempPin := ConfigFile.ReadInteger(Voltmetr.Name, 'Gate', -1);
  if (TempPin > -1) and (TempPin < PinsComboBox.Items.Count) then
    Voltmetr.PinGateNumber := StrToInt(PinsComboBox.Items[TempPin]);
end;

Procedure TVoltmetrShow.PinsWriteToIniFile(ConfigFile:TIniFile);
 var i:integer;
begin
  if not(fIsReady) then Exit;
  if Voltmetr.Name='' then Exit;
  ConfigFile.EraseSection(Voltmetr.Name);
  for I := 0 to PinsComboBox.Items.Count - 1 do
  begin
    if (IntToStr(Voltmetr.PinNumber) = PinsComboBox.Items[i]) then
      ConfigFile.WriteInteger(Voltmetr.Name, 'Control', i);
    if (IntToStr(Voltmetr.PinGateNumber) = PinsComboBox.Items[i]) then
      ConfigFile.WriteInteger(Voltmetr.Name, 'Gate', i);
  end;
end;

procedure TVoltmetrShow.NumberPinShow();
begin
 if fIsReady then
   begin
     ControlPinLabel.Caption:=Voltmetr.PinNumberStr;
     GatePinLabel.Caption:=Voltmetr.PinGateNumberStr;
   end;
end;

procedure TVoltmetrShow.ButtonEnabled();
begin
  if not(fIsReady) then Exit;
  MeasurementButton.Enabled:=(Voltmetr.PinNumber<>UndefinedPin)and
                             (Voltmetr.PinGateNumber<>UndefinedPin){and
                             (Voltmetr.ComPort.Connected)};
  AutoSpeedButton.Enabled:=MeasurementButton.Enabled;
end;

procedure TVoltmetrShow.VoltmetrDataShow();
begin
  if not(fIsReady) then Exit;
  MeasureMode.ItemIndex:=ord(Voltmetr.MeasureMode);
  DiapazonFill(TMeasureMode(MeasureMode.ItemIndex),
                Range.Items);

  Range.ItemIndex:=
     DiapazonSelect(Voltmetr.MeasureMode,Voltmetr.Diapazon);
  case Voltmetr.MeasureMode of
     IA,ID: UnitLabel.Caption:=' A';
     UA,UD: UnitLabel.Caption:=' V';
     MMErr: UnitLabel.Caption:='';
  end;
  if Voltmetr.isReady then
      DataLabel.Caption:=FloatToStrF(Voltmetr.Value,ffExponent,4,2)
                       else
      begin
       DataLabel.Caption:='    ERROR';
       UnitLabel.Caption:='';
      end;
end;

procedure TVoltmetrShow.SetControlButtonClick(Sender: TObject);
begin
  if PinsComboBox.ItemIndex<0 then Exit;
  if PinsComboBox.Items[PinsComboBox.ItemIndex]<>IntToStr(Voltmetr.PinNumber) then
    begin
     Voltmetr.PinNumber:=StrToInt(PinsComboBox.Items[PinsComboBox.ItemIndex]);
     NumberPinShow();
     ButtonEnabled();
    end;
end;

procedure TVoltmetrShow.SetGateButtonClick(Sender: TObject);
begin
  if PinsComboBox.ItemIndex<0 then Exit;
  if PinsComboBox.Items[PinsComboBox.ItemIndex]<>IntToStr(Voltmetr.PinGateNumber) then
    begin
     Voltmetr.PinGateNumber:=StrToInt(PinsComboBox.Items[PinsComboBox.ItemIndex]);
     NumberPinShow();
     ButtonEnabled();
    end;
end;

procedure TVoltmetrShow.MeasurementButtonClick(Sender: TObject);
begin
 if not(Voltmetr.ComPort.Connected) then Exit;
 Voltmetr.Measurement();
 VoltmetrDataShow();
end;

procedure TVoltmetrShow.AutoSpeedButtonClick(Sender: TObject);
begin
 MeasurementButton.Enabled:=not(AutoSpeedButton.Down);
 if AutoSpeedButton.Down then Time.OnTimer:=MeasurementButton.OnClick;
 Time.Enabled:=AutoSpeedButton.Down;
end;

procedure TVoltmetrShow.MeasureModeClick(Sender: TObject);
begin
  if fIsReady then MeasureMode.ItemIndex:=ord(Voltmetr.MeasureMode);
end;

procedure TVoltmetrShow.RangeClick(Sender: TObject);
begin
 if fIsReady then
  Range.ItemIndex:=DiapazonSelect(Voltmetr.MeasureMode,Voltmetr.Diapazon);
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

//Function FCSCalculate(Data:array of byte):byte;
//{розраховується інвертована
//перша комплементарна сума}
// var FCS,i:integer;
//begin
// FCS:=0;
// for I := 0 to High(Data) do
//   begin
//     FCS:=FCS+Data[i];
//     while(FCS>255) do
//      begin
//        FCS:=(FCS and $FF)+((FCS shr 8)and $FF);
//      end;
//   end;
// FCS:=not(FCS);
// Result:=byte(FCS and $FF);
//end;

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
