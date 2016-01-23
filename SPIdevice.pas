unit SPIdevice;

interface
 uses OlegType,CPort,Dialogs,SysUtils,Classes,Windows,Forms,SyncObjs,PacketParameters,
     ExtCtrls,StdCtrls,Buttons,IniFiles;

type
  TMeasureMode=(IA,ID,UA,UD,MMErr);
  TDiapazons=(nA100,micA1,micA10,micA100,mA1,mA10,mA100,mA1000,
              mV10,mV100,V1,V10,V100,V1000,DErr);

  TSPIdevice=class
  {базовий клас для пристроїв, які керуються
  за допомогою Аrduino з використанням шини SPI}
  private
   fPins:TArrByte;
   {номери пінів Arduino;
   в цьому класі масив містить 2 елементи,
   за необхідності в нащадках треба міняти конструктор
   [0] для лінії Slave Select шини SPI
   [1] для керування буфером між Аrduino та приладом}
   fName:string;
   fComPort:TComPort;
   fComPacket: TComDataPacket;
   fData:TArrByte;
   Procedure PacketReceiving(Sender: TObject; const Str: string);virtual;abstract;
  protected
   Function GetPinStr(Index:integer):string;
   Function GetPin(Index:integer):byte;
   Procedure SetPin(Index:integer; value:byte);
  public
   property PinControl:byte Index 0 read GetPin write SetPin;
   property PinGate:byte Index 1 read GetPin write SetPin;
   property PinControlStr:string Index 0 read GetPinStr;
   property PinGateStr:string Index 1 read GetPinStr;
   property Name:string read fName;
   Constructor Create();overload;virtual;
   Constructor Create(CP:TComPort);overload;
   Constructor Create(CP:TComPort;Nm:string);overload;
   Procedure Free;
   Procedure PinsReadFromIniFile(ConfigFile:TIniFile);overload;
   Procedure PinsReadFromIniFile(ConfigFile:TIniFile;Strings:TStrings);overload;
   Procedure PinsWriteToIniFile(ConfigFile:TIniFile);overload;
   Procedure PinsWriteToIniFile(ConfigFile:TIniFile;Strings:TStrings);overload;
  end;


  TVoltmetr=class(TSPIdevice)
  {базовий клас для вольтметрів серії В7-21}
  private
   fMeasureMode:TMeasureMode;
   fValue:double;
   fDiapazon:TDiapazons;
   fIsReady:boolean;
   fIsReceived:boolean;
//   fData:TArrByte;
   Procedure MModeDetermination(Data:byte); virtual;
   Procedure DiapazonDetermination(Data:byte); virtual;
   Procedure ValueDetermination(Data:array of byte);virtual;
   Procedure PacketReceiving(Sender: TObject; const Str: string);override;
  public
   property MeasureMode:TMeasureMode read FMeasureMode;
   property Value:double read fValue;
   property Diapazon:TDiapazons read fDiapazon;
   property isReady:boolean read fIsReady;
   Procedure ConvertToValue(Data:array of byte);
   Constructor Create();overload;override;
   Function Request():boolean;
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

  TOutputRange=(p050,p100,p108,pm050,pm100,pm108);

  TDACChannel=class
   Range:TOutputRange;
   Power:boolean;
//   Overcurrent:boolean;
  end;

  TChannelType=(A,B,Both,Error);

  TDAC=class(TSPIdevice)
  {базовий клас для ЦАП}
  private
    FChannelB: TDACChannel;
    FChannelA: TDACChannel;
    FBeginingDoesNotDone: boolean;
    Procedure PacketReceiving(Sender: TObject; const Str: string);override;
    procedure SetChannelA(const Value: TDACChannel);
    procedure SetChannelB(const Value: TDACChannel);
    Procedure OutputRange(Channel: Byte; Range: TOutputRange; NotImperative: Boolean=True);
    {якщо NotImperative=True, то встановлення вихідного діапазону не буде
    відбуватися, якщо вже існуючий співпадає з тим, що намагаються встановити;
    в протилежному випадку завжди буде відсилатися відповідний пакет -
    потрібно, наприклад при початку роботи}
    Procedure PowerOn(Channel: Byte; NotImperative: Boolean=True);
    Function ChannelTypeDetermine(Channel:byte):TChannelType;
    procedure ChannelSetRange(Channel:byte;Range:TOutputRange);overload;
    procedure ChannelSetRange(Channel:byte;Range:byte);overload;
    procedure ChannelSetPower(ChannelType:TChannelType);
    function ChannelRangeIsReady(Channel:byte;Range:TOutputRange):boolean;
    {False якщо Range не співпадає з тим, що вже встановлено}
    function ChannelPowerIsReady(ChannelType:TChannelType):boolean;
  public
   {пін для оновлення напруги ЦАП}
   property PinLDAC:byte Index 2 read GetPin write SetPin;
   property PinLDACStr:string Index 2 read GetPinStr;
   {пін для встановлення нульової напруги ЦАП}
   property PinCLR:byte Index 3 read GetPin write SetPin;
   property PinCLRStr:string Index 3 read GetPinStr;
   property ChannelA:TDACChannel read FChannelA write SetChannelA;
   property ChannelB:TDACChannel read FChannelB write SetChannelB;
   property BeginingDoesNotDone:boolean read FBeginingDoesNotDone;
   Constructor Create();overload;override;
   Procedure Free;
   Procedure OutputRangeA(Range:TOutputRange; NotImperative: Boolean=True);
   Procedure OutputRangeB(Range:TOutputRange; NotImperative: Boolean=True);
   Procedure OutputRangeBoth(Range:TOutputRange; NotImperative: Boolean=True);
   Procedure ChannelsReadFromIniFile(ConfigFile:TIniFile);
   Procedure ChannelsWriteToIniFile(ConfigFile:TIniFile);
   Procedure PowerOnA(NotImperative: Boolean=True);
   Procedure PowerOnB(NotImperative: Boolean=True);
   Procedure PowerOnBoth(NotImperative: Boolean=True);
   Procedure PowerOffBoth(NotImperative: Boolean=True);
   Procedure PowerOffB();
   Procedure PowerOffA();
   Procedure HookForGraphElementApdate();
   {виконується в кінці PacketReceiving для оновлення
   даних графічних елементів, пов'язаних з DAC.
   В цьому класі порожня, треба причепити
   за необхідності якусь дію десь інде}
   Procedure SetMode();
   {встановлюється режим роботи:
   SDO Disable=0, CLR Seting =0, Clamp Enable=1
   TSD enable = 0 - див Datasheet}
   Procedure Begining();
  end;


  TAdapterRadioGroupClick=class
    findexx:integer;
//    DAC:TDAC;
    Constructor Create(ind:integer);overload;
//    Constructor Create(ind:integer;DDAC:TDAC);overload;
    procedure RadioGroupClick(Sender: TObject);
//    procedure RadioGroupDACChannelClick(Sender: TObject);
  end;

  TSimpleEvent = procedure() of object;

  TAdapterSetButton=class
  private
    FSimpleAction: TSimpleEvent;
    PinsComboBox:TComboBox;
    SPIDevice:TSPIdevice;
    fi:integer;
  public
   property SimpleAction:TSimpleEvent read FSimpleAction write FSimpleAction;
   Constructor Create(PCB:TComboBox;SPID:TSPIdevice;i:integer;Action:TSimpleEvent);
   procedure SetButtonClick(Sender: TObject);
  end;


  TSPIDeviceShow=class
  private
   SPIDevice:TSPIdevice;
   PinLabels:array of TLabel;
   SetPinButtons:array of TButton;
   PinsComboBox:TComboBox;
   procedure CreateFooter;
  public
   Constructor Create(SPID:TSPIdevice;
                      ControlPinLabel,GatePinLabel:TLabel;
                      SetControlButton,SetGateButton:TButton;
                      PCB:TComboBox);
   procedure PinsReadFromIniFile(ConfigFile:TIniFile);
   procedure PinsWriteToIniFile(ConfigFile:TIniFile);
   procedure NumberPinShow();virtual;
  end;


  TVoltmetrShow=class(TSPIDeviceShow)
  private
   MeasureMode,Range:TRadioGroup;
   DataLabel,UnitLabel:TLabel;
   MeasurementButton:TButton;
   Time:TTimer;
   procedure MeasurementButtonClick(Sender: TObject);
   procedure AutoSpeedButtonClick(Sender: TObject);
  public
   AutoSpeedButton:TSpeedButton;
   Constructor Create(V:TVoltmetr;
                      MM,R:TRadioGroup;
                      DL,UL,CPL,GPL:TLabel;
                      SCB,SGB,MB:TButton;
                      AB:TSpeedButton;
                      PCB:TComboBox;
                      TT:TTimer);
   procedure NumberPinShow();override;
   procedure ButtonEnabled();
   procedure VoltmetrDataShow();
  end;


  TDACChannelShow=class
  private
   DAC:TDAC;
   ChannelIndex:integer;// 8 - ChannelA, 10 - ChannelB
   Channel:TDACChannel;
   RangesLabel:TLabel;
   RangesComboBox:TComboBox;
   RangesSetButton:TButton;
   PowerLabel:TLabel;
   PowerButton:TBitBtn;
   procedure SetRangeButtomAction(Sender:TObject);
   procedure PowerButtomAction(Sender:TObject);
   function ReadyTesting:boolean;
  public
   Constructor Create(DACC:TDAC;
               CI:integer;
               RL:TLabel;
               RCB:TComboBox;
               RSB:TButton;
               PL:TLabel;
               PB:TBitBtn
                      );
   procedure DataShow;
   procedure RangeShow;
   procedure PowerShow;
  end;

  TDACShow=class(TSPIDeviceShow)
  private
  public
   Constructor Create(DAC:TDAC;
                      CPL,GPL,LDACPL,CLRPL:TLabel;
                      SCB,SGB,SLDACB,SCLRB:TButton;
                      PCB:TComboBox
                      );
   procedure NumberPinShow();override;
  end;

const
  UndefinedPin=255;

  MeasureModeLabels:array[TMeasureMode]of string=
   ('~ I', '= I','~ U', '= U','Error');

  DiapazonsLabels:array[TDiapazons]of string=
   ('100 nA','1 micA','10 micA','100 micA',
    '1 mA','10 mA','100 mA','1000 mA',
     '10 mV','100 mV','1 V','10 V','100 V','1000 V','Error');

  PinNames:array[0..3]of string=
   ('Control','Gate','LDAC','CLR');

  OutputRangeLabels:array[TOutputRange]of string=
  ('0..5','0..10','0..10.8',
  '-5..5','-10..10','-10.8..10.8');

  GainValueOutputRangeLabels:array[TOutputRange]of double=
  (2,4,4.32,4,8,8.64);

  REFIN=2.5;

  {константи операцій з ЦАП}
  DAC_OR=1; //встановлення діапазону
  DAC_Mode=2; //встановлення параметрів роботи
  DAC_Power=3;//подача живлення

Function BCDtoDec(BCD:byte; isLow:boolean):byte;
{виділяє з ВCD, яке містить дві десяткові
цифри у двійково-десятковому представленні,
ці цифри;
якщо  isLow=true, то виділення із
молодшої частини байта}

Procedure DiapazonFill(Mode:TMeasureMode; Diapazons:TStrings);
{заповнює Diapazons можливими назвами діапазонів
з DiapazonsLabels залежно від Mode}

Function DiapazonSelect(Mode:TMeasureMode;Diapazon:TDiapazons):integer;
{визначається порядковий номер, який
відповідає Diapazon при даному Mode}

implementation

uses
  Graphics;


Constructor TSPIdevice.Create();
begin
  inherited Create();
  SetLength(fPins,2);
  PinControl:=UndefinedPin;
  PinGate:=UndefinedPin;
  fName:='';
  fComPacket:=TComDataPacket.Create(fComPacket);
  fComPacket.Size:=0;
  fComPacket.MaxBufferSize:=1024;
  fComPacket.IncludeStrings:=False;
  fComPacket.CaseInsensitive:=False;
  fComPacket.StartString:=PacketBeginChar;
  fComPacket.StopString:=PacketEndChar;
  fComPacket.OnPacket:=PacketReceiving;
end;


Constructor TSPIdevice.Create(CP:TComPort);
begin
 Create();
 fComPort:=CP;
 fComPacket.ComPort:=CP;
end;

Constructor TSPIdevice.Create(CP:TComPort;Nm:string);
begin
 Create(CP);
 fName:=Nm;
end;


Procedure TSPIdevice.Free;
begin
 fComPacket.Free;
 inherited;
end;

Function TSPIdevice.GetPinStr(Index:integer):string;
begin
  Result:=PinNames[Index]+' pin is ';
  if fPins[Index]=UndefinedPin then
    Result:=Result+'undefined'
                               else
    Result:=Result+IntToStr(fPins[Index]);
end;

Function TSPIdevice.GetPin(Index:integer):byte;
begin
  Result:=fPins[Index];
end;

Procedure TSPIdevice.SetPin(Index:integer; value:byte);
begin
  fPins[Index]:=value;
end;

Procedure TSPIdevice.PinsReadFromIniFile(ConfigFile:TIniFile);
 var i:integer;
begin
  if Name='' then Exit;
  for I := 0 to High(fPins) do
      fPins[i]:=ConfigFile.ReadInteger(Name, PinNames[i], UndefinedPin);
end;

Procedure TSPIdevice.PinsReadFromIniFile(ConfigFile:TIniFile;Strings:TStrings);
 var i,TempPin:integer;
begin
  if Name='' then Exit;
  for I := 0 to High(fPins) do
   begin
    TempPin := ConfigFile.ReadInteger(Name, PinNames[i], -1);
    if (TempPin > -1) and (TempPin < Strings.Count) then
      fPins[i] := StrToInt(Strings[TempPin]);
   end;
end;


Procedure TSPIdevice.PinsWriteToIniFile(ConfigFile:TIniFile);
 var i:integer;
begin
  if Name='' then Exit;
  ConfigFile.EraseSection(Name);
  for I := 0 to High(fPins) do
     WriteIniDef(ConfigFile,Name,PinNames[i], UndefinedPin);
end;

Procedure TSPIdevice.PinsWriteToIniFile(ConfigFile:TIniFile;Strings:TStrings);
 var i,j:integer;
begin
  if Name='' then Exit;
  ConfigFile.EraseSection(Name);
  for I := 0 to Strings.Count - 1 do
    for j := 0 to High(fPins) do
      if (IntToStr(fPins[j]) = Strings[i]) then
        ConfigFile.WriteInteger(Name, PinNames[j], i);
end;


Constructor TVoltmetr.Create();
begin
  inherited Create();
  fIsReady:=False;
  fIsReceived:=False;
  fMeasureMode:=MMErr;
  fDiapazon:=DErr;
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


Function TVoltmetr.Request():boolean;
begin
  PacketCreate([V7_21Command,PinControl,PinGate]);
  Result:=PacketIsSend(fComPort);
end;

Function TVoltmetr.Measurement():double;
label start;
var {i0,}i:integer;
    isFirst:boolean;
begin
 Result:=ErResult;
 if not(fComPort.Connected) then
   begin
    showmessage('Port is not connected');
    Exit;
   end;

 isFirst:=True;
start:
 fIsReady:=False;
 fIsReceived:=False;
 if not(Request()) then Exit;
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

 if ((Result=ErResult)or(abs(Result)<1e-14))and(isFirst) then
    begin
      isFirst:=false;
      goto start;
    end;
end;

procedure TVoltmetr.PacketReceiving(Sender: TObject; const Str: string);
 var i:integer;
begin
 if not(PacketIsReceived(Str,fData,V7_21Command)) then Exit;
 if fData[2]<>PinControl then Exit;

 for I := 0 to High(fData)-4 do
   fData[i]:=fData[i+3];
 SetLength(fData,High(fData)-3);
 fIsReceived:=True;
end;

Procedure TVoltmetr.ConvertToValue(Data:array of byte);
begin
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
  inherited Create(V,CPL,GPL,SCB,SGB,PCB);
   MeasureMode:=MM;
   Range:=R;
   DataLabel:=DL;
   UnitLabel:=UL;
   MeasurementButton:=MB;
   AutoSpeedButton:=AB;
   Time:=TT;
    CreateFooter();
    MeasureMode.Items.Clear;
    for I := 0 to ord(MMErr) do
      MeasureMode.Items.Add(MeasureModeLabels[TMeasureMode(i)]);
    MeasureMode.ItemIndex := ord((SPIDevice as TVoltmetr).MeasureMode);
    UnitLabel.Caption := '';
    DiapazonFill((SPIDevice as TVoltmetr).MeasureMode, Range.Items);
    Range.ItemIndex:=DiapazonSelect((SPIDevice as TVoltmetr).MeasureMode,(SPIDevice as TVoltmetr).Diapazon);
    MeasurementButton.OnClick:=MeasurementButtonClick;
    AutoSpeedButton.OnClick:=AutoSpeedButtonClick;
    MeasureMode.OnClick:=TAdapterRadioGroupClick.Create(ord((SPIDevice as TVoltmetr).MeasureMode)).RadioGroupClick;
    Range.OnClick:=TAdapterRadioGroupClick.Create(DiapazonSelect((SPIDevice as TVoltmetr).MeasureMode,(SPIDevice as TVoltmetr).Diapazon)).RadioGroupClick;
end;

procedure TVoltmetrShow.NumberPinShow();
begin
 inherited NumberPinShow();
 ButtonEnabled()
end;

procedure TVoltmetrShow.ButtonEnabled();
begin
  MeasurementButton.Enabled:=(SPIDevice.PinControl<>UndefinedPin)and
                             (SPIDevice.PinGate<>UndefinedPin);
  AutoSpeedButton.Enabled:=MeasurementButton.Enabled;
end;

procedure TVoltmetrShow.VoltmetrDataShow();
begin
  MeasureMode.ItemIndex:=ord((SPIDevice as TVoltmetr).MeasureMode);
//  showmessage(inttostr(MeasureMode.ItemIndex));
  DiapazonFill(TMeasureMode(MeasureMode.ItemIndex),
                Range.Items);

  Range.ItemIndex:=
     DiapazonSelect((SPIDevice as TVoltmetr).MeasureMode,(SPIDevice as TVoltmetr).Diapazon);
  case (SPIDevice as TVoltmetr).MeasureMode of
     IA,ID: UnitLabel.Caption:=' A';
     UA,UD: UnitLabel.Caption:=' V';
     MMErr: UnitLabel.Caption:='';
  end;
  if (SPIDevice as TVoltmetr).isReady then
      DataLabel.Caption:=FloatToStrF((SPIDevice as TVoltmetr).Value,ffExponent,4,2)
                       else
      begin
       DataLabel.Caption:='    ERROR';
       UnitLabel.Caption:='';
      end;
end;

procedure TVoltmetrShow.MeasurementButtonClick(Sender: TObject);
begin
 if not((SPIDevice as TVoltmetr).fComPort.Connected) then Exit;
 (SPIDevice as TVoltmetr).Measurement();
 VoltmetrDataShow();
end;

procedure TVoltmetrShow.AutoSpeedButtonClick(Sender: TObject);
begin
 MeasurementButton.Enabled:=not(AutoSpeedButton.Down);
 if AutoSpeedButton.Down then Time.OnTimer:=MeasurementButton.OnClick;
 Time.Enabled:=AutoSpeedButton.Down;
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


procedure TDAC.ChannelSetRange(Channel: byte; Range: TOutputRange);
begin
  case ChannelTypeDetermine(Channel) of
   A:ChannelA.Range:=Range;
   B:ChannelB.Range:=Range;
   Both:begin
         ChannelA.Range:=Range;
         ChannelB.Range:=Range;
        end;
   Error:;
  end;
end;



procedure TDAC.ChannelSetPower(ChannelType: TChannelType);
begin
 case ChannelType of
   A: begin
       ChannelA.Power:=True;
       ChannelB.Power:=False;
      end;
   B: begin
       ChannelA.Power:=False;
       ChannelB.Power:=True;
      end;
   Both:begin
       ChannelA.Power:=True;
       ChannelB.Power:=True;
       end;
   Error: begin
         ChannelA.Power:=False;
         ChannelB.Power:=False;
        end;
 end;
end;

procedure TDAC.ChannelSetRange(Channel, Range: byte);
begin
 ChannelSetRange(Channel, TOutputRange(Range));
end;

procedure TDAC.Begining;
begin
 if not(fComPort.Connected) then Exit;
 if (ChannelA.Range=ChannelB.Range) then
          OutputRangeBoth(ChannelA.Range,False)
                                    else
          begin
           OutputRangeA(ChannelA.Range,False);
           sleep(100);
           OutputRangeB(ChannelB.Range,False);
          end;
 sleep(100);
 if ChannelA.Power then
    begin
      if ChannelB.Power then PowerOnBoth(False)
                        else PowerOnA(False);
    end
                   else
    begin
      if ChannelB.Power then PowerOnB(False)
                        else PowerOffBoth(False);
    end;
 sleep(100);
 SetMode();
 sleep(100);
 FBeginingDoesNotDone:=False;
end;

function TDAC.ChannelPowerIsReady(ChannelType: TChannelType): boolean;
begin
 case ChannelType of
   A:Result:=ChannelA.Power;
   B:Result:=ChannelB.Power;
   Both:Result:=(ChannelA.Power)and(ChannelB.Power);
   Error:Result:=(not(ChannelA.Power))and(not(ChannelB.Power))
   else Result:=False;
 end;
end;

function TDAC.ChannelRangeIsReady(Channel: byte; Range: TOutputRange): boolean;
begin
  case ChannelTypeDetermine(Channel) of
   A:Result:=(ChannelA.Range=Range);
   B:Result:=(ChannelB.Range=Range);
   Both:Result:=((ChannelA.Range=Range)and(ChannelB.Range=Range));
   else Result:=False;
  end;
end;

function TDAC.ChannelTypeDetermine(Channel: byte): TChannelType;
begin
 Channel:=(Channel and $07);
 case Channel of
   0:Result:=A;
   2:Result:=B;
   4:Result:=Both;
   else  Result:=Error;
 end;
end;

Constructor TDAC.Create();
begin
  inherited Create();
  SetLength(fPins,4);
  PinLDAC:=UndefinedPin;
  PinCLR:=UndefinedPin;
  ChannelA:=TDACChannel.Create;
  ChannelB:=TDACChannel.Create;
//  ChannelA.Range:=pm100;
  FBeginingDoesNotDone:=True;
end;


procedure TDAC.Free;
begin
 ChannelA.Free;
 ChannelB.Free;
 inherited Free;
end;

procedure TDAC.HookForGraphElementApdate;
begin

end;

procedure TDAC.OutputRange(Channel: Byte; Range: TOutputRange; NotImperative: Boolean=True);
begin
  if ChannelRangeIsReady(Channel,Range)and(NotImperative) then  Exit;

  PacketCreate([DACCommand,DAC_OR,PinControl,PinGate,Channel,0,byte(ord(Range))]);
  if PacketIsSend(fComPort) then ChannelSetRange(Channel,Range);
end;

procedure TDAC.OutputRangeA(Range:TOutputRange; NotImperative: Boolean=True);
begin
  OutputRange(8, Range, NotImperative);
end;

procedure TDAC.OutputRangeB(Range: TOutputRange; NotImperative: Boolean=True);
begin
  OutputRange(10, Range, NotImperative);
end;

procedure TDAC.OutputRangeBoth(Range: TOutputRange; NotImperative: Boolean=True);
begin
  OutputRange(12, Range, NotImperative);
end;

procedure TDAC.ChannelsReadFromIniFile(ConfigFile: TIniFile);
begin
  if Name='' then Exit;
  ChannelA.Range:=TOutputRange(ConfigFile.ReadInteger(Name, 'OutputRangeA', 0));
  ChannelB.Range:=TOutputRange(ConfigFile.ReadInteger(Name, 'OutputRangeB', 0));
  ChannelA.Power:=ConfigFile.ReadBool(Name, 'PowerA', False);
  ChannelB.Power:=ConfigFile.ReadBool(Name, 'PowerB', False);
end;

procedure TDAC.ChannelsWriteToIniFile(ConfigFile: TIniFile);
begin
  if Name='' then Exit;
  WriteIniDef(ConfigFile,Name,'OutputRangeA', ord(ChannelA.Range),0);
  WriteIniDef(ConfigFile,Name,'OutputRangeB', ord(ChannelB.Range),0);
  ConfigFile.WriteBool(Name,'PowerA',ChannelA.Power);
  ConfigFile.WriteBool(Name,'PowerB',ChannelB.Power);
end;

procedure TDAC.PacketReceiving(Sender: TObject; const Str: string);
// var i:integer;
begin
 if not(PacketIsReceived(Str,fData,DACCommand)) then Exit;
 if fData[2]=DAC_OR then
  begin
    MessageDlg('DAC Output Range setting has trouble',mtError,[mbOK],0);
    ChannelSetRange(fData[3],fData[4]);
  end;
 if fData[2]=DAC_Mode then
  begin
    MessageDlg('DAC setting Mode has trouble',mtError,[mbOK],0);
  end;
 if fData[2]=DAC_Power then
  begin
    MessageDlg('DAC power has trouble',mtError,[mbOK],0);
    if ((fData[3] and $10)=0) then
       MessageDlg('DAC  internal reference is not powered!!!',mtError,[mbOK],0)
                              else
      begin
        MessageDlg('DAC power has trouble',mtError,[mbOK],0);
        if (fData[3] and $01)=0 then ChannelA.Power:=False else ChannelA.Power:=True;
        if (fData[3] and $04)=0 then ChannelB.Power:=False else ChannelB.Power:=True;
      end;
  end;


  HookForGraphElementApdate();

end;





procedure TDAC.PowerOn(Channel: Byte; NotImperative: Boolean=True);
 var ChannelType: TChannelType;
begin
  case Channel of
   $11: ChannelType:=A;
   $14: ChannelType:=B;
   $15: ChannelType:=Both;
   else ChannelType:=Error;
  end;

  if ChannelPowerIsReady(ChannelType)and(NotImperative) then  Exit;
  PacketCreate([DACCommand,DAC_Power,PinControl,PinGate,$10,0,Channel]);
  if PacketIsSend(fComPort) then ChannelSetPower(ChannelType);
end;

procedure TDAC.PowerOnA(NotImperative: Boolean=True);
begin
  PowerOn($11,NotImperative)
end;

procedure TDAC.PowerOnB(NotImperative: Boolean=True);
begin
  PowerOn($14,NotImperative)
end;

procedure TDAC.PowerOnBoth(NotImperative: Boolean=True);
begin
  PowerOn($15,NotImperative)
end;

procedure TDAC.PowerOffA();
begin
  if (ChannelA.Power)and(ChannelB.Power) then PowerOnB(False);
  if (ChannelA.Power)and(not(ChannelB.Power)) then PowerOffBoth(False);
end;

procedure TDAC.PowerOffB();
begin
  if (ChannelB.Power)and(ChannelA.Power) then PowerOnA(False);
  if (ChannelB.Power)and(not(ChannelA.Power)) then PowerOffBoth(False);
end;

procedure TDAC.PowerOffBoth(NotImperative: Boolean);
begin
 PowerOn($10,NotImperative)
end;


procedure TDAC.SetChannelA(const Value: TDACChannel);
begin
  FChannelA := Value;
end;

procedure TDAC.SetChannelB(const Value: TDACChannel);
begin
  FChannelB := Value;
end;

procedure TDAC.SetMode;
begin
  PacketCreate([DACCommand,DAC_Mode,PinControl,PinGate,$19,$00,$04]);
  PacketIsSend(fComPort);
//  if not(PacketIsSend(fComPort)) then
end;

Constructor TDACChannelShow.Create(DACC:TDAC;
                                   CI:integer;
                                   RL:TLabel;
                                   RCB:TComboBox;
                                   RSB:TButton;
                                   PL:TLabel;
                                   PB:TBitBtn
                      );
 var i:TOutputRange;
begin
  inherited Create();
  DAC:=DACC;
  ChannelIndex:=CI;
  case ChannelIndex of
   10:Channel:=DAC.ChannelB;
   else Channel:=DAC.ChannelA;
  end;
//  Channel:=DACC;
  RangesLabel:=RL;
  RangesComboBox:=RCB;
  RangesSetButton:=RSB;
  RangesSetButton.OnClick:=SetRangeButtomAction;
  RangesComboBox.Items.Clear;
  for I := Low(TOutputRange) to High(TOutputRange) do
      RangesComboBox.Items.Add(OutputRangeLabels[i]);
  PowerLabel:=PL;
  PowerButton:=PB;
  PowerButton.OnClick:=PowerButtomAction;    
  DataShow();

//  OutputRanges.ItemIndex:=ord(Channel.Range);
//    OutputRanges.OnClick:=TAdapterRadioGroupClick.Create(ord(Channel.Range)).RadioGroupClick;

end;

procedure TDACChannelShow.DataShow;
begin
  RangeShow();
  PowerShow();
end;





procedure TDACChannelShow.PowerShow;
begin
  if Channel.Power then
    begin
     PowerLabel.Caption:='Power on';
     PowerLabel.Font.Color:=clRed;
     PowerButton.Caption:='Off';
     PowerButton.Font.Color:=clNavy;
    end
                   else
    begin
     PowerLabel.Caption:='Power off';
     PowerLabel.Font.Color:=clNavy;
     PowerButton.Caption:='On';
     PowerButton.Font.Color:=clRed;
    end
end;

procedure TDACChannelShow.RangeShow;
begin
 RangesLabel.Caption := OutputRangeLabels[Channel.Range];
end;

function TDACChannelShow.ReadyTesting: boolean;
begin
 if DAC.BeginingDoesNotDone then
    begin
     DAC.Begining();
     Result:=DAC.BeginingDoesNotDone;
    end
                            else
    Result:=False;
end;

procedure TDACChannelShow.SetRangeButtomAction(Sender: TObject);
begin
   if ReadyTesting then Exit;
   if not(RangesLabel.Caption=RangesComboBox.Items[RangesComboBox.ItemIndex]) then
    begin
      DAC.OutputRange(ChannelIndex,TOutputRange(RangesComboBox.ItemIndex));
      RangeShow();
    end;
end;

procedure TDACChannelShow.PowerButtomAction(Sender: TObject);
begin
  if ReadyTesting then Exit;
  case ChannelIndex of
   10:
     if Channel.Power then DAC.PowerOffB()
                      else
                  begin
                    if DAC.ChannelA.Power then DAC.PowerOnBoth()
                                          else DAC.PowerOnB();
                  end;
   else
     if Channel.Power then DAC.PowerOffA()
                      else
                  begin
                    if DAC.ChannelB.Power then DAC.PowerOnBoth()
                                          else DAC.PowerOnA();
                  end;

  end;
 PowerShow(); 
end;

{ TAdapter }

constructor TAdapterRadioGroupClick.Create(ind: integer);
begin
 inherited Create;
 findexx:=ind;
end;

//constructor TAdapterRadioGroupClick.Create(ind: integer; DDAC: TDAC);
//begin
//  Create(ind);
//  DAC:=DDAC;
//end;

procedure TAdapterRadioGroupClick.RadioGroupClick(Sender: TObject);
begin
 try
 (Sender as TRadioGroup).ItemIndex:=findexx;
 except
 end;
end;

//procedure TAdapterRadioGroupClick.RadioGroupDACChannelClick(Sender: TObject);
//begin
//  if findexx=0 then
//   begin
//     DAC.OutputRangeA(TOutputRange((Sender as TRadioGroup).ItemIndex));
//     (Sender as TRadioGroup).ItemIndex:=ord(DAC.ChannelA.Range);
//   end;
//  if findexx=1 then
//   begin
//     DAC.OutputRangeB(TOutputRange((Sender as TRadioGroup).ItemIndex));
//     (Sender as TRadioGroup).ItemIndex:=ord(DAC.ChannelB.Range);
//   end;
//end;

{ TSPIdeviceShow }

constructor TSPIdeviceShow.Create(SPID:TSPIdevice;
                                  ControlPinLabel, GatePinLabel: TLabel;
                                  SetControlButton, SetGateButton: TButton; PCB: TComboBox);
begin
 inherited Create();
 SPIDevice:=SPID;
 SetLength(PinLabels,High(SPIDevice.fPins)+1);
 SetLength(SetPinButtons,High(SPIDevice.fPins)+1);
 PinLabels[0]:=ControlPinLabel;
 PinLabels[1]:=GatePinLabel;
 SetPinButtons[0]:=SetControlButton;
 SetPinButtons[1]:=SetGateButton;
 PinsComboBox:=PCB;
end;

procedure TSPIDeviceShow.NumberPinShow;
begin
   PinLabels[0].Caption:=SPIDevice.PinControlStr;
   PinLabels[1].Caption:=SPIDevice.PinGateStr;
end;

procedure TSPIDeviceShow.CreateFooter;
var
  i: Integer;
begin
  for I := 0 to High(SetPinButtons) do
    begin
    SetPinButtons[i].OnClick := TAdapterSetButton.Create(PinsComboBox, SPIDevice, i, NumberPinShow).SetButtonClick;
    SetPinButtons[i].Caption := 'set ' + LowerCase(PinNames[i]);
    end;
end;

procedure TSPIDeviceShow.PinsReadFromIniFile(ConfigFile: TIniFile);
begin
  SPIDevice.PinsReadFromIniFile(ConfigFile,PinsComboBox.Items);
end;

procedure TSPIDeviceShow.PinsWriteToIniFile(ConfigFile: TIniFile);
begin
  SPIDevice.PinsWriteToIniFile(ConfigFile,PinsComboBox.Items);
end;

{ TAdapterSetButton }

constructor TAdapterSetButton.Create(PCB: TComboBox;SPID:TSPIdevice;i:integer;
  Action: TSimpleEvent);
begin
  inherited Create;
  PinsComboBox:=PCB;
  SPIDevice:=SPID;
  SimpleAction:=Action;
  fi:=i;
end;

procedure TAdapterSetButton.SetButtonClick(Sender: TObject);
begin
  if PinsComboBox.ItemIndex<0 then Exit;
  if PinsComboBox.Items[PinsComboBox.ItemIndex]<>IntToStr(SPIDevice.fPins[fi]) then
    begin
     SPIDevice.fPins[fi]:=StrToInt(PinsComboBox.Items[PinsComboBox.ItemIndex]);
     SimpleAction();
    end;
end;

{ TDACShow }

constructor TDACShow.Create(DAC: TDAC;
                            CPL, GPL, LDACPL, CLRPL: TLabel;
                            SCB, SGB, SLDACB, SCLRB: TButton;
                            PCB: TComboBox);
begin
 inherited Create(DAC,CPL,GPL,SCB,SGB,PCB);
 PinLabels[2]:=LDACPL;
 PinLabels[3]:=CLRPL;
 SetPinButtons[2]:=SLDACB;
 SetPinButtons[3]:=SCLRB;
 CreateFooter()
end;

procedure TDACShow.NumberPinShow;
begin
   inherited NumberPinShow();
   PinLabels[2].Caption:=(SPIDevice as TDAC).PinLDACStr;
   PinLabels[3].Caption:=(SPIDevice as TDAC).PinCLRStr;
end;

end.
