unit SPIdevice;

interface
 uses OlegType,CPort,Dialogs,SysUtils,Classes,Windows,Forms,SyncObjs,PacketParameters,
     ExtCtrls,StdCtrls,Buttons,IniFiles, Measurement,Math;

type
  TMeasureMode=(IA,ID,UA,UD,MMErr);
  TMeasureModeSet=set of TMeasureMode;
  TDiapazons=(nA100,micA1,micA10,micA100,mA1,mA10,mA100,mA1000,
              mV10,mV100,V1,V10,V100,V1000,DErr);

  TArduinoDevice=class(TInterfacedObject,IName)
  {������� ���� ��� ��������, �� ���������
  �� ��������� �rduino � ������������� ���� SPI}
  private
   fPins:TArrByte;
   {������ ���� Arduino;
   � ����� ���� ����� ������ 2 ��������,
   �� ����������� � �������� ����� ����� �����������
   [0] ��� ���� Slave Select ���� SPI
   [1] ��� ��������� ������� �� �rduino �� ��������}
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
   function GetName:string;
  end;

  TArduinoMeter=class(TArduinoDevice,IMeasurement)
  {������� ���� ��� ������������ ��'����,
  �� �������������� ���� ����� � Arduino}
  private
   fValue:double;
   fIsReady:boolean;
   fIsReceived:boolean;
   fMetterKod:byte;
   fMinDelayTime:integer;
   Procedure ConvertToValue(Data:array of byte);virtual;abstract;
   Procedure PacketReceiving(Sender: TObject; const Str: string);override;
   Function ResultProblem(Rez:double):boolean;virtual;
  public
   property Value:double read fValue;
   property isReady:boolean read fIsReady;
   Constructor Create();overload;override;
   Function Request():boolean;virtual;
   Function Measurement():double;virtual;
   function GetTemperature:double;virtual;
   function GetVoltage(Vin:double):double;virtual;
   function GetCurrent(Vin:double):double;virtual;
   function GetResist():double;virtual;
  end;


  TDS18B20=class(TArduinoMeter)
  {������� ���� ��� ������� DS18B20}
  private
//   fValue:double;
//   fIsReady:boolean;
//   fIsReceived:boolean;
   Procedure ConvertToValue(Data:array of byte);override;
//   Procedure PacketReceiving(Sender: TObject; const Str: string);override;
  public
//   property Value:double read fValue;
//   property isReady:boolean read fIsReady;
   Constructor Create();overload;override;
//   Function Request():boolean;override;
//   Function Measurement():double;override;
   function GetTemperature:double;override;
//   function GetVoltage(Vin:double):double;override;
//   function GetCurrent(Vin:double):double;override;
//   function GetResist():double;override;
  end;


  TVoltmetr=class(TArduinoMeter)
  {������� ���� ��� ���������� ��� �7-21}
  private
   fMeasureMode:TMeasureMode;
//   fValue:double;
   fDiapazon:TDiapazons;
//   fIsReady:boolean;
//   fIsReceived:boolean;
//   fData:TArrByte;
   Procedure MModeDetermination(Data:byte); virtual;
   Procedure DiapazonDetermination(Data:byte); virtual;
   Procedure ValueDetermination(Data:array of byte);virtual;
//   Procedure PacketReceiving(Sender: TObject; const Str: string);override;
   function GetData(LegalMeasureMode:TMeasureModeSet):double;
   function GetResistance():double;
   Function ResultProblem(Rez:double):boolean;override;
  public
   property MeasureMode:TMeasureMode read FMeasureMode;
//   property Value:double read fValue;
   property Diapazon:TDiapazons read fDiapazon;
//   property isReady:boolean read fIsReady;
   property Resistance:double read GetResistance;
   Procedure ConvertToValue(Data:array of byte);override;
   Constructor Create();overload;override;
   Function Request():boolean;override;
//   Function Measurement():double;override;
   function GetTemperature:double;override;
   function GetVoltage(Vin:double):double;override;
   function GetCurrent(Vin:double):double;override;
   function GetResist():double;override;
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

  TV721_Brak=class(TV721)
  {��������� �����, ��� ����� ����������� 2 ��������}
  private
   Procedure DiapazonDetermination(Data:byte);override;
  public
  end;

  TOutputRange=(p050,p100,p108,pm050,pm100,pm108);

  TDACChannel=class
   Range:TOutputRange;
   Power:boolean;
   Overcurrent:boolean;
  end;

  TChannelType=(A,B,Both,Error);

  TSimpleEvent = procedure() of object;

  TDAC=class(TArduinoDevice)
  {������� ���� ��� ���}
  private
    FChannelB: TDACChannel;
    FChannelA: TDACChannel;
    FBeginingIsDone: boolean;
    fHookForGraphElementApdate:TSimpleEvent;
    Procedure PacketReceiving(Sender: TObject; const Str: string);override;
    procedure SetChannelA(const Value: TDACChannel);
    procedure SetChannelB(const Value: TDACChannel);
    Procedure OutputRange(Channel: Byte; Range: TOutputRange; NotImperative: Boolean=True);
    {���� NotImperative=True, �� ������������ ��������� �������� �� ����
    ����������, ���� ��� �������� ������� � ���, �� ����������� ����������;
    � ������������ ������� ������ ���� ���������� ��������� ����� -
    �������, ��������� ��� ������� ������}
    Procedure PowerOn(Channel: Byte; NotImperative: Boolean=True);
    Procedure Output(Voltage:double;Channel: Byte);
    Function ChannelTypeDetermine(Channel:byte):TChannelType;
    procedure ChannelSetRange(Channel:byte;Range:TOutputRange);overload;
    procedure ChannelSetRange(Channel:byte;Range:byte);overload;
    procedure ChannelSetPower(ChannelType:TChannelType);
    function ChannelRangeIsReady(Channel:byte;Range:TOutputRange):boolean;
    {False ���� Range �� ������� � ���, �� ��� �����������}
    function ChannelPowerIsReady(ChannelType:TChannelType):boolean;
    function IntVoltage(Voltage:double;Range:TOutputRange):integer;
    function HighVoltage(Range:TOutputRange):double;
    function LowVoltage(Range:TOutputRange):double;
  public
   {�� ��� ��������� ������� ���}
//       function IntVoltage(Voltage:double;Range:TOutputRange):integer;
   property PinLDAC:byte Index 2 read GetPin write SetPin;
   property PinLDACStr:string Index 2 read GetPinStr;
   {�� ��� ������������ ������� ������� ���}
   property PinCLR:byte Index 3 read GetPin write SetPin;
   property PinCLRStr:string Index 3 read GetPinStr;
   property ChannelA:TDACChannel read FChannelA write SetChannelA;
   property ChannelB:TDACChannel read FChannelB write SetChannelB;
   property BeginingIsDone:boolean read FBeginingIsDone;
   property HookForGraphElementApdate:TSimpleEvent
             read fHookForGraphElementApdate write fHookForGraphElementApdate;
   {���������� � ���� PacketReceiving ��� ���������
   ����� ��������� ��������, ���'������ � DAC.
   � ����� ���� �������, ����� ���������
   �� ����������� ����� �� ���� ����}
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
//   Procedure HookForGraphElementApdate();
   {���������� � ���� PacketReceiving ��� ���������
   ����� ��������� ��������, ���'������ � DAC.
   � ����� ���� �������, ����� ���������
   �� ����������� ����� �� ���� ����}
   Procedure SetMode();
   {�������������� ����� ������:
   SDO Disable=0, CLR Seting =0, Clamp Enable=1
   TSD enable = 0 - ��� Datasheet}
   Procedure Begining();
   Procedure Reset();
   Procedure OutputA(Voltage:double);
   Procedure OutputB(Voltage:double);
   Procedure OutputBoth(Voltage:double);
   Procedure OutputSyn(VoltageA,VoltageB:double);
   {������������ ������� �� ���� �������� ������� ���������}
  end;

const DACR2R_MaxValue=65535;
      DACR2R_Factor=10000;

type

//TDACR2R_Calibr=record
//             pos01:array [1..10000]of word;
//             neg01:array [1..10000]of word;
//             pos16:array [1001..6500]of word;
//             neg16:array [1001..6500]of word;
//             end;
//PDACR2R_Calibr=^TDACR2R_Calibr;

 TArrWord=array of word;

TDACR2R_Calibr=class
private
 pos01:TArrWord;
 neg01:TArrWord;
 pos16:TArrWord;
 neg16:TArrWord;
 procedure WriteToFile(FileName:string;arr:TArrWord);
 procedure ReadFromFile(FileName:string;arr:TArrWord);
public
 Constructor Create();
class function VoltToKod(Volt:double):word;
 function VoltToKodIndex(Volt:double):word;
 function VoltToArray(Volt:double):TArrWord;
 procedure Add(RequiredVoltage,RealVoltage:double);
 procedure AddWord(Index,Kod:word;Arr:TArrWord);
 procedure VectorToCalibr(Vec:PVector);
 procedure WriteToFileData();
 procedure ReadFromFileData();
end;

TDACR2R=class(TArduinoDevice,IOutput)
  {������� ���� ��� ���}
private
 fCalibration:TDACR2R_Calibr;
 Procedure PacketReceiving(Sender: TObject; const Str: string);override;
 function  IntVoltage(Voltage:double):integer;
 procedure DataByteToSendPrepare(Voltage: Double);
 procedure PacketCreateAndSend(report: string);
 procedure DataByteToSendFromInteger(IntData: Integer);
public
 Constructor Create();overload;override;
 Procedure Free;
 Procedure Output(Voltage:double);
 Procedure Reset();
 Procedure CalibrationRead();
 Procedure CalibrationWrite();
 procedure CalibrationFileProcessing(filename:string);
 Procedure OutputInt(Kod:integer);
 function CalibrationStep(Voltage:double):double;
 procedure OutputCalibr(Voltage:double);
 procedure SaveFileWithCalibrData(DataVec:PVector);
end;


  TAdapterRadioGroupClick=class
    findexx:integer;
//    DAC:TDAC;
    Constructor Create(ind:integer);overload;
//    Constructor Create(ind:integer;DDAC:TDAC);overload;
    procedure RadioGroupClick(Sender: TObject);
//    procedure RadioGroupDACChannelClick(Sender: TObject);
  end;



  TAdapterSetButton=class
  private
    FSimpleAction: TSimpleEvent;
    PinsComboBox:TComboBox;
    SPIDevice:TArduinoDevice;
    fi:integer;
  public
   property SimpleAction:TSimpleEvent read FSimpleAction write FSimpleAction;
   Constructor Create(PCB:TComboBox;SPID:TArduinoDevice;i:integer;Action:TSimpleEvent);
   procedure SetButtonClick(Sender: TObject);
  end;


  TSPIDeviceShow=class
  private
   SPIDevice:TArduinoDevice;
   PinLabels:array of TLabel;
   SetPinButtons:array of TButton;
   PinsComboBox:TComboBox;
   procedure CreateFooter;
  public
   Constructor Create(SPID:TArduinoDevice;
                      ControlPinLabel,GatePinLabel:TLabel;
                      SetControlButton,SetGateButton:TButton;
                      PCB:TComboBox);
//   Procedure Free;
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
   AdapterMeasureMode,AdapterRange:TAdapterRadioGroupClick;
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
   Procedure Free;
   procedure NumberPinShow();override;
   procedure ButtonEnabled();
   procedure VoltmetrDataShow();
  end;


  TDACChannelShow=class
  private
   DAC:TDAC;
   ChannelIndex:integer;// 8 - ChannelA, 10 - ChannelB
   Channel:TDACChannel;
   RangesLabel,ValueLabel:TLabel;
   RangesComboBox:TComboBox;
   RangesSetButton,ValueChangeButton,ValueSetButton:TButton;
   PowerLabel:TLabel;
   PowerButton:TBitBtn;
   procedure SetRangeButtomAction(Sender:TObject);
   procedure PowerButtomAction(Sender:TObject);
   procedure ValueChangeButtonAction(Sender:TObject);
   procedure ValueSetButtonAction(Sender:TObject);
//   function ReadyTesting:boolean;
  public
   Constructor Create(DACC:TDAC;
               CI:integer;
               RL,VL:TLabel;
               RCB:TComboBox;
               RSB,VCB,VSB:TButton;
               PL:TLabel;
               PB:TBitBtn
                      );
   procedure DataShow;
   procedure RangeShow;
   procedure PowerShow;
  end;

  TDACShow=class(TSPIDeviceShow)
  private
   DACChannelShowA,DACChannelShowB:TDACChannelShow;
   PanelA,PanelB:TPanel;
   InitButton,ResetButton:TButton;
   procedure ButtonEnable();
   procedure InitButtonClick(Sender:TObject);
   procedure ResetButtonClick(Sender:TObject);
  public
   Constructor Create(DAC:TDAC;
                      DACCSA,DACCSB:TDACChannelShow;
                      CPL,GPL,LDACPL,CLRPL:TLabel;
                      SCB,SGB,SLDACB,SCLRB:TButton;
                      PCB:TComboBox;
                      PanA,PanB:TPanel;
                      IB,RB:TButton
                      );
   procedure NumberPinShow();override;
   procedure DataShow();
  end;

TDACR2RShow=class(TSPIDeviceShow)
private
 ValueChangeButton,ValueSetButton,
 KodChangeButton,KodSetButton,ResetButton:TButton;
 ValueLabel,KodLabel:TLabel;
 procedure ValueChangeButtonAction(Sender:TObject);
 procedure ValueSetButtonAction(Sender:TObject);
 procedure KodChangeButtonAction(Sender:TObject);
 procedure KodSetButtonAction(Sender:TObject);
 procedure ResetButtonClick(Sender:TObject);
public
 Constructor Create(DACR2R:TDACR2R;
                      CPL,GPL,VL,KL:TLabel;
                      SCB,SGB,VCB,VSB,KCB,KSB,RB:TButton;
                      PCB:TComboBox);
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

  GainValueOutputRange:array[TOutputRange]of double=
  (2,4,4.32,4,8,8.64);

  REFIN=2.5;

  {�������� ������� ������� �� ����� �� ����������� ��������}
  pVoltageLimit=0.99998; // 65535/65536
  pmVoltageLimit=0.99996; // 32767/32768


  {��������� �������� � ���}
  DAC_OR=1; //������������ ��������
  DAC_Mode=2; //������������ ��������� ������
  DAC_Power=3;//������ ��������
  DAC_Reset=4;//������������ ������� ������� �� ���� �������
  DAC_Output=5; //������������ �������
  DAC_OutputSYN=6; //������������ ������� ��������� �� ���� �������
  DAC_Overcurrent=7; // �������������� �� �����

  DACR2R_Pos=$00; //������� �������
  DACR2R_Neg=$FF; //��'���� �������
  DACR2R_Reset=$AA; //�������������� ������� �������

Function BCDtoDec(BCD:byte; isLow:boolean):byte;
{������ � �CD, ��� ������ �� ��������
����� � �������-����������� �������������,
�� �����;
����  isLow=true, �� �������� ��
������� ������� �����}

Procedure DiapazonFill(Mode:TMeasureMode; Diapazons:TStrings);
{�������� Diapazons ��������� ������� ���������
� DiapazonsLabels ������� �� Mode}

Function DiapazonSelect(Mode:TMeasureMode;Diapazon:TDiapazons):integer;
{����������� ���������� �����, ����
������� Diapazon ��� ������ Mode}

implementation

uses
  Graphics, OlegMath, OlegGraph;


Constructor TArduinoDevice.Create();
begin
  inherited Create();
  SetLength(fPins,2);
  PinControl:=UndefinedPin;
  PinGate:=UndefinedPin;
  fName:='';
  fComPacket:=TComDataPacket.Create(fComPort);
  fComPacket.Size:=0;
  fComPacket.MaxBufferSize:=1024;
  fComPacket.IncludeStrings:=False;
  fComPacket.CaseInsensitive:=False;
  fComPacket.StartString:=PacketBeginChar;
  fComPacket.StopString:=PacketEndChar;
  fComPacket.OnPacket:=PacketReceiving;
end;


Constructor TArduinoDevice.Create(CP:TComPort);
begin
 Create();
 fComPort:=CP;
 fComPacket.ComPort:=CP;
end;

Constructor TArduinoDevice.Create(CP:TComPort;Nm:string);
begin
 Create(CP);
 fName:=Nm;
end;


Procedure TArduinoDevice.Free;
begin
 fComPacket.Free;
 inherited;
end;

Function TArduinoDevice.GetPinStr(Index:integer):string;
begin
  Result:=PinNames[Index]+' pin is ';
  if fPins[Index]=UndefinedPin then
    Result:=Result+'undefined'
                               else
    Result:=Result+IntToStr(fPins[Index]);
end;

function TArduinoDevice.GetName: string;
begin
 Result:=Name;
end;

Function TArduinoDevice.GetPin(Index:integer):byte;
begin
  Result:=fPins[Index];
end;

Procedure TArduinoDevice.SetPin(Index:integer; value:byte);
begin
  fPins[Index]:=value;
end;

Procedure TArduinoDevice.PinsReadFromIniFile(ConfigFile:TIniFile);
 var i:integer;
begin
  if Name='' then Exit;
  for I := 0 to High(fPins) do
      fPins[i]:=ConfigFile.ReadInteger(Name, PinNames[i], UndefinedPin);
end;

Procedure TArduinoDevice.PinsReadFromIniFile(ConfigFile:TIniFile;Strings:TStrings);
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


Procedure TArduinoDevice.PinsWriteToIniFile(ConfigFile:TIniFile);
 var i:integer;
begin
  if Name='' then Exit;
  ConfigFile.EraseSection(Name);
  for I := 0 to High(fPins) do
     WriteIniDef(ConfigFile,Name,PinNames[i], UndefinedPin);
end;

Procedure TArduinoDevice.PinsWriteToIniFile(ConfigFile:TIniFile;Strings:TStrings);
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
  fMetterKod:=V7_21Command;

//  fIsReady:=False;
//  fIsReceived:=False;
  fMeasureMode:=MMErr;
  fDiapazon:=DErr;
end;


Procedure TVoltmetr.MModeDetermination(Data:byte);
begin

end;

Procedure TVoltmetr.DiapazonDetermination(Data:byte);
begin

end;

function TVoltmetr.GetCurrent(Vin: double): double;
// var temp:double;
begin
 Result:=GetData([ID,IA]);
// Result:=ErResult;
// temp:=Measurement();
// if temp<>ErResult then
//  begin
//    if (fMeasureMode<>ID)or(fMeasureMode<>IA) then
//         MessageDlg('Measure mode is wrong!!!',mtError, [mbOK], 0)
//                                              else
//         Result:=temp;
//  end;
end;

function TVoltmetr.GetData(LegalMeasureMode: TMeasureModeSet): double;
 function AditionMeasurement(a,b:double):double;
  var c:double;
  begin
    if abs(a-b)<1e-5*Max(abs(a),abs(b))
     then
      Result:=(a+b)/2
     else
      begin
        sleep(100);
        c:=Measurement();
        Result:=MedianFiltr(a,b,c);
      end;
  end;
 var a,b:double;

begin
 a:=Measurement();
 sleep(100);
 b:=Measurement();
 Result:=AditionMeasurement(a,b);
 if Result=0 then
   begin
     sleep(300);
     a:=Measurement();
     sleep(100);
     b:=Measurement();
     Result:=AditionMeasurement(a,b);
   end;
 

// if Result=ErResult then Exit;
// if not(fMeasureMode in LegalMeasureMode) then
//   begin
//    MessageDlg('Measure mode is wrong!!!',mtError, [mbOK], 0);
//    Result:=ErResult;
//   end
end;

function TVoltmetr.GetResist: double;
begin
  Result:=GetResistance();
end;

function TVoltmetr.GetResistance: double;
begin
 case fDiapazon of
   nA100: Result:=100000;
   micA1: Result:=100000;
   micA10: Result:=10000;
   micA100: Result:=1000;
   mA1: Result:=100;
   mA10: Result:=10;
   mA1000:Result:=1;
   else Result:=0;
 end;
end;

function TVoltmetr.GetTemperature: double;
// var temp:double;
begin
 Result:=GetData([UD]);
 if Result<>ErResult then Result:=T_CuKo(Result);

// Result:=ErResult;
// temp:=Measurement();
// if temp<>ErResult then
//  begin
//    if (fMeasureMode<>UD) then
//         MessageDlg('Measure mode is wrong!!!',mtError, [mbOK], 0)
//                                              else
//         Result:=T_CuKo(temp);
//  end;
end;

function TVoltmetr.GetVoltage(Vin: double): double;
// var temp:double;
begin
 Result:=GetData([UD,UA]);
// Result:=ErResult;
// temp:=Measurement();
// if temp<>ErResult then
//  begin
//    if (fMeasureMode<>UD)or(fMeasureMode<>UA) then
//         MessageDlg('Measure mode is wrong!!!',mtError, [mbOK], 0)
//                                              else
//         Result:=temp;
//  end;
end;

Procedure TVoltmetr.ValueDetermination(Data:array of byte);
 var temp:double;
begin
 temp:=BCDtoDec(Data[0],True);
 temp:=BCDtoDec(Data[0],False)*10+temp;
 temp:=temp+BCDtoDec(Data[1],True)*100;
 temp:=temp+BCDtoDec(Data[1],False)*1000;
// temp:=temp+BCDtoDec(Data[1],False)*1000;
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
  PacketCreate([fMetterKod,PinControl,PinGate]);
  Result:=PacketIsSend(fComPort,'Voltmetr '+Name+' measurement is unsuccessful');
end;

function TVoltmetr.ResultProblem(Rez: double): boolean;
begin
 Result:=(abs(Rez)<1e-14);
end;

//Function TVoltmetr.Measurement():double;
//label start;
//var {i0,}i:integer;
//    isFirst:boolean;
//begin
// Result:=ErResult;
// if not(fComPort.Connected) then
//   begin
//    showmessage('Port is not connected');
//    Exit;
//   end;
//
// isFirst:=True;
//start:
// fIsReady:=False;
// fIsReceived:=False;
// if not(Request()) then Exit;
//// i0:=GetTickCount;
// i:=0;
// repeat
//   sleep(10);
//   inc(i);
// Application.ProcessMessages;
// until ((i>130)or(fIsReceived));
//// showmessage(inttostr((GetTickCount-i0)));
// if fIsReceived then ConvertToValue(fData);
// if fIsReady then Result:=fValue;
//
// if ((Result=ErResult)or(abs(Result)<1e-14))and(isFirst) then
//    begin
//      isFirst:=false;
//      goto start;
//    end;
//end;

//procedure TVoltmetr.PacketReceiving(Sender: TObject; const Str: string);
// var i:integer;
//begin
// if not(PacketIsReceived(Str,fData,V7_21Command)) then Exit;
//// ShowData(fData);
// if fData[2]<>PinControl then Exit;
// for I := 0 to High(fData)-4 do
//   fData[i]:=fData[i+3];
// SetLength(fData,High(fData)-3);
// fIsReceived:=True;
//end;

Procedure TVoltmetr.ConvertToValue(Data:array of byte);
begin
  if High(Data)<>3 then Exit;
  MModeDetermination(Data[2]);
//  showmessage('jjj');
//  showmessage(inttostr(MeasureMode.ItemIndex));
//    showmessage(inttostr(ord(fMeasureMode)));
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
//    CreateFooter();
    MeasureMode.Items.Clear;
    for I := 0 to ord(MMErr) do
      MeasureMode.Items.Add(MeasureModeLabels[TMeasureMode(i)]);
    MeasureMode.ItemIndex := ord((SPIDevice as TVoltmetr).MeasureMode);
    UnitLabel.Caption := '';
    DiapazonFill((SPIDevice as TVoltmetr).MeasureMode, Range.Items);
    Range.ItemIndex:=DiapazonSelect((SPIDevice as TVoltmetr).MeasureMode,(SPIDevice as TVoltmetr).Diapazon);
    MeasurementButton.OnClick:=MeasurementButtonClick;
    AutoSpeedButton.OnClick:=AutoSpeedButtonClick;
    AdapterMeasureMode:=TAdapterRadioGroupClick.Create(ord((SPIDevice as TVoltmetr).MeasureMode));
    AdapterRange:=TAdapterRadioGroupClick.Create(DiapazonSelect((SPIDevice as TVoltmetr).MeasureMode,(SPIDevice as TVoltmetr).Diapazon));
    MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
    Range.OnClick:=AdapterRange.RadioGroupClick;
//    MeasureMode.OnClick:=TAdapterRadioGroupClick.Create(ord((SPIDevice as TVoltmetr).MeasureMode)).RadioGroupClick;
//    Range.OnClick:=TAdapterRadioGroupClick.Create(DiapazonSelect((SPIDevice as TVoltmetr).MeasureMode,(SPIDevice as TVoltmetr).Diapazon)).RadioGroupClick;
end;

procedure TVoltmetrShow.Free;
begin
 AdapterMeasureMode.Free;
 AdapterRange.Free;
// MeasureMode:=nil;
// Range:=nil;
// DataLabel:=nil;
// UnitLabel:=nil;
// MeasurementButton:=nil;
// AutoSpeedButton:=nil;
// Time:=nil;
 inherited Free;
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
  MeasureMode.OnClick:=nil;
  Range.OnClick:=nil;
  MeasureMode.ItemIndex:=ord((SPIDevice as TVoltmetr).MeasureMode);
  DiapazonFill(TMeasureMode(MeasureMode.ItemIndex),
                Range.Items);

  Range.ItemIndex:=
     DiapazonSelect((SPIDevice as TVoltmetr).MeasureMode,(SPIDevice as TVoltmetr).Diapazon);
  MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
  Range.OnClick:=AdapterRange.RadioGroupClick;
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
{������ � �CD, ��� ������ �� ��������
����� � �������-����������� �������������,
�� �����;
����  isLow=true, �� �������� ��
������� ������� �����}
begin
 if isLow then BCD:=BCD Shl 4;
 Result:= BCD Shr 4;
end;

Procedure DiapazonFill(Mode:TMeasureMode; Diapazons:TStrings);
{�������� Diapazons ��������� ������� ���������
� DiapazonsLabels ������� �� Mode}
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
{����������� ���������� �����, ����
������� Diapazon ��� ������ Mode}
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
 FBeginingIsDone:=True;
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
  ChannelA.Overcurrent:=False;
  ChannelB.Overcurrent:=False;
//  ChannelA.Range:=pm100;
  FBeginingIsDone:=False;
//  FBeginingIsDone:=True;

end;


procedure TDAC.Free;
begin
 ChannelA.Free;
 ChannelB.Free;
 inherited Free;
end;

function TDAC.HighVoltage(Range: TOutputRange): double;
begin
 case Range of
   p050: Result:=5*pVoltageLimit;
   p100: Result:=10*pVoltageLimit;
   p108: Result:=10.8*pVoltageLimit;
   pm050: Result:=5*pmVoltageLimit;
   pm100: Result:=10*pmVoltageLimit;
   pm108: Result:=10.8*pmVoltageLimit;
   else Result:=ErResult;
 end;
end;

//procedure TDAC.HookForGraphElementApdate;
//begin
//
//end;

function TDAC.IntVoltage(Voltage: double; Range: TOutputRange): integer;
begin
 Result:=0;
 if Voltage=0 then Exit;

 if ord(Range)<3 then
  begin
    if Voltage>=HighVoltage(Range) then
      begin
      Result:=$FFFF;
      Exit;
      end;
    if Voltage<=LowVoltage(Range) then
      begin
      Result:=$0;
      Exit;
      end;
    Result:=(round(Voltage*65536/REFIN/GainValueOutputRange[Range]) and $FFFF);
  end;

 if ord(Range)>2 then
  begin
    if Voltage>=HighVoltage(Range) then
      begin
      Result:=$7FFF;
      Exit;
      end;
    if Voltage<=LowVoltage(Range) then
      begin
      Result:=$8000;
      Exit;
      end;
    if Voltage>0 then
      Result:=(round(Voltage*65536/REFIN/GainValueOutputRange[Range]) and $7FFF)
                 else
      begin
      Result:=(32767-round(abs(Voltage)*65536/REFIN/GainValueOutputRange[Range]) and $7FFF);
      Result:=Result+$8000;
      end;
  end;
end;

function TDAC.LowVoltage(Range: TOutputRange): double;
begin
 case Range of
   p050,p100,p108: Result:=0;
   pm050: Result:=-5*pmVoltageLimit;
   pm100: Result:=-10*pmVoltageLimit;
   pm108: Result:=-10.8*pmVoltageLimit;
   else Result:=ErResult;
 end;
end;

procedure TDAC.Output(Voltage: double; Channel: Byte);
 var IntData:integer;
     Data2,Data3:byte;
begin
 if ChannelTypeDetermine(Channel)=A then
     IntData:=IntVoltage(Voltage,ChannelA.Range)
                                    else
     IntData:=IntVoltage(Voltage,ChannelB.Range);
 Data2:=((IntData shr 8) and $FF);
 Data3:=(IntData and $FF);
 PacketCreate([DACCommand,DAC_Output,PinControl,PinGate,Channel,Data2,Data3,PinLDAC]);
 PacketIsSend(fComPort,'DAC output value setting is unsuccessful');
end;

procedure TDAC.OutputA(Voltage: double);
begin
  Output(Voltage,0);
end;

procedure TDAC.OutputB(Voltage: double);
begin
  Output(Voltage,2);
end;

procedure TDAC.OutputBoth(Voltage: double);
begin
  Output(Voltage,4);
end;

procedure TDAC.OutputRange(Channel: Byte; Range: TOutputRange; NotImperative: Boolean=True);
begin
  if ChannelRangeIsReady(Channel,Range)and(NotImperative) then  Exit;

  PacketCreate([DACCommand,DAC_OR,PinControl,PinGate,Channel,0,byte(ord(Range))]);
  if PacketIsSend(fComPort,'DAC range setting is unsuccessful') then ChannelSetRange(Channel,Range);
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

procedure TDAC.OutputSyn(VoltageA, VoltageB: double);
 var IntData:integer;
     DataAlo,DataAhi,DataBlo,DataBhi:byte;
begin
 IntData:=IntVoltage(VoltageA,ChannelA.Range);
 DataAhi:=((IntData shr 8) and $FF);
 DataAlo:=(IntData and $FF);
 IntData:=IntVoltage(VoltageA,ChannelB.Range);
 DataBhi:=((IntData shr 8) and $FF);
 DataBlo:=(IntData and $FF);

 PacketCreate([DACCommand,DAC_OutputSyn,PinControl,PinGate,PinLDAC,DataAhi,DataAlo,DataBhi,DataBlo]);
 PacketIsSend(fComPort,'DAC synchronous output value setting is unsuccessful');
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

 if fData[2]=DAC_Output then
  begin
    MessageDlg('DAC output has trouble',mtError,[mbOK],0);
  end;

 if fData[2]=DAC_Overcurrent then
  begin
    if (fData[3] and $02)>0 then ChannelB.Overcurrent:=False;
    if (fData[4] and $80)>0 then ChannelA.Overcurrent:=False;
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
  if PacketIsSend(fComPort,'DAC channel power setting is unsuccessful') then ChannelSetPower(ChannelType);
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

procedure TDAC.Reset;
begin
  PacketCreate([DACCommand,DAC_Reset,PinCLR,PinGate]);
  if PacketIsSend(fComPort,'DAC reset is unsuccessful') then
   begin
    ChannelA.Overcurrent:=False;
    ChannelB.Overcurrent:=False;
   end;
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
  PacketIsSend(fComPort,'DAC mode setting is unsuccessful');
//  if not(PacketIsSend(fComPort)) then
end;

Constructor TDACChannelShow.Create(DACC:TDAC;
                                   CI:integer;
                                   RL,VL:TLabel;
                                   RCB:TComboBox;
                                   RSB,VCB,VSB:TButton;
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

  ValueLabel:=VL;
  ValueLabel.Caption:='0';
  ValueLabel.Font.Color:=clBlack;
  ValueChangeButton:=VCB;
  ValueChangeButton.OnClick:=ValueChangeButtonAction;
  ValueSetButton:=VSB;
  ValueSetButton.OnClick:=ValueSetButtonAction;

  //  DataShow();

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

//function TDACChannelShow.ReadyTesting: boolean;
//begin
// if (not(DAC.BeginingIsDone)) then
//    begin
//     DAC.Begining();
//     Result:=DAC.BeginingIsDone;
//    end
//                            else
//    Result:=False;
//end;

procedure TDACChannelShow.SetRangeButtomAction(Sender: TObject);
begin
//   if ReadyTesting then Exit;
   if not(RangesLabel.Caption=RangesComboBox.Items[RangesComboBox.ItemIndex]) then
    begin
      DAC.OutputRange(ChannelIndex,TOutputRange(RangesComboBox.ItemIndex));
      RangeShow();
    end;
end;

procedure TDACChannelShow.ValueChangeButtonAction(Sender: TObject);
 var value:string;
begin
 if InputQuery('Value', 'Output value is expect', value) then
  begin
    try
      ValueLabel.Caption:=FloatToStrF(StrToFloat(value),ffFixed, 6, 4);
      ValueLabel.Font.Color:=clBlack;
    except

    end;
  end;
end;

procedure TDACChannelShow.ValueSetButtonAction(Sender: TObject);
begin
   case ChannelIndex of
   10:   DAC.OutputB(Strtofloat(ValueLabel.Caption));
   else  DAC.OutputA(Strtofloat(ValueLabel.Caption));
   end;
   ValueLabel.Font.Color:=clPurple;
end;

procedure TDACChannelShow.PowerButtomAction(Sender: TObject);
begin
//  if ReadyTesting then Exit;
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

constructor TSPIdeviceShow.Create(SPID:TArduinoDevice;
                                  ControlPinLabel, GatePinLabel: TLabel;
                                  SetControlButton, SetGateButton: TButton; PCB: TComboBox);
begin
 inherited Create();
 SPIDevice:=SPID;
 SetLength(PinLabels,High(SPIDevice.fPins)+1);
 SetLength(SetPinButtons,High(SPIDevice.fPins)+1);
 PinLabels[0]:=ControlPinLabel;
 if High(PinLabels)>0 then
    PinLabels[1]:=GatePinLabel;
 SetPinButtons[0]:=SetControlButton;
 if High(SetPinButtons)>0 then
    SetPinButtons[1]:=SetGateButton;
 PinsComboBox:=PCB;

 CreateFooter();

end;

procedure TSPIDeviceShow.NumberPinShow;
begin
   PinLabels[0].Caption:=SPIDevice.PinControlStr;
   if High(PinLabels)>0 then
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

//procedure TSPIDeviceShow.Free;
//begin
// SPIDevice:=nil;
// PinLabels[0]:=nil;
// PinLabels[1]:=nil;
// SetPinButtons[0]:=nil;
// SetPinButtons[1]:=nil;
// PinsComboBox:=nil;
//end;

procedure TSPIDeviceShow.PinsReadFromIniFile(ConfigFile: TIniFile);
begin
  SPIDevice.PinsReadFromIniFile(ConfigFile,PinsComboBox.Items);
end;

procedure TSPIDeviceShow.PinsWriteToIniFile(ConfigFile: TIniFile);
begin
  SPIDevice.PinsWriteToIniFile(ConfigFile,PinsComboBox.Items);
end;

{ TAdapterSetButton }

constructor TAdapterSetButton.Create(PCB: TComboBox;SPID:TArduinoDevice;i:integer;
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

procedure TDACShow.ButtonEnable;
 var PinDefined:boolean;
begin
 PinDefined:=(SPIDevice.PinControl<>UndefinedPin)and
             (SPIDevice.PinGate<>UndefinedPin)and
             ((SPIDevice as TDAC).PinLDAC<>UndefinedPin)and
             ((SPIDevice as TDAC).PinCLR<>UndefinedPin);
 PanelA.Enabled:=(PinDefined)and((SPIDevice as TDAC).BeginingIsDone);
 PanelB.Enabled:=(PinDefined)and((SPIDevice as TDAC).BeginingIsDone);
end;

constructor TDACShow.Create(DAC: TDAC;
                            DACCSA,DACCSB:TDACChannelShow;
                            CPL, GPL, LDACPL, CLRPL: TLabel;
                            SCB, SGB, SLDACB, SCLRB: TButton;
                            PCB: TComboBox;
                            PanA,PanB:Tpanel;
                            IB,RB:TButton);
begin
 inherited Create(DAC,CPL,GPL,SCB,SGB,PCB);
 PinLabels[2]:=LDACPL;
 PinLabels[3]:=CLRPL;
 SetPinButtons[2]:=SLDACB;
 SetPinButtons[3]:=SCLRB;
 DACChannelShowA:=DACCSA;
 DACChannelShowB:=DACCSB;
 DAC.HookForGraphElementApdate:=DataShow;
 PanelA:=PanA;
 PanelB:=PanB;
 InitButton:=IB;
 InitButton.OnClick:=InitButtonClick;
 ResetButton:=RB;
 ResetButton.OnClick:=ResetButtonClick;
 CreateFooter();
end;

procedure TDACShow.DataShow;
begin
 DACChannelShowA.DataShow;
 DACChannelShowB.DataShow;
end;

procedure TDACShow.InitButtonClick(Sender: TObject);
begin
 (SPIDevice as TDAC).Begining();
  ButtonEnable();
end;

procedure TDACShow.NumberPinShow;
begin
   inherited NumberPinShow();
   PinLabels[2].Caption:=(SPIDevice as TDAC).PinLDACStr;
   PinLabels[3].Caption:=(SPIDevice as TDAC).PinCLRStr;
   ButtonEnable();
end;

procedure TDACShow.ResetButtonClick(Sender: TObject);
begin
 (SPIDevice as TDAC).Reset();
end;

{ TDACR2R }

function TDACR2R.IntVoltage(Voltage: double): integer;
 var tempArrWord:TArrWord;
     Index,AddIndex:integer;
begin
 Result:=0;
 if TDACR2R_Calibr.VoltToKod(Voltage)=0 then Exit;

 tempArrWord:=fCalibration.VoltToArray(Voltage);
 if tempArrWord=nil then Exit;
 Index:=fCalibration.VoltToKodIndex(Voltage);
 AddIndex:=1;
 repeat
   try
    Result:=tempArrWord[Index];
   except
    Break;
   end;
   Index:=Index-AddIndex;
   if AddIndex>0 then AddIndex:=AddIndex*(-1)
                 else AddIndex:=abs(AddIndex)+1;
 until ((Result<>0)or
        (Index<Low(tempArrWord))or
        (Index>High(tempArrWord)));
 if Result=0 then Result:=TDACR2R_Calibr.VoltToKod(Voltage);
end;


procedure TDACR2R.Output(Voltage: double);
begin
 if Voltage<0 then fData[2]:=DACR2R_Neg
              else fData[2]:=DACR2R_Pos;
 DataByteToSendPrepare(Voltage);
 PacketCreateAndSend('DAC R2R output value setting is unsuccessful');
end;

procedure TDACR2R.OutputCalibr(Voltage: double);
begin
 if Voltage<0 then fData[2]:=DACR2R_Neg
              else fData[2]:=DACR2R_Pos;
 DataByteToSendFromInteger(TDACR2R_Calibr.VoltToKod(Voltage));
 PacketCreateAndSend('DAC R2R output calibration value setting is unsuccessful');
end;

Procedure TDACR2R.OutputInt(Kod:integer);
begin
 if Kod<0 then fData[2]:=DACR2R_Neg
          else fData[2]:=DACR2R_Pos;
 DataByteToSendFromInteger(abs(Kod));
 PacketCreateAndSend('DAC R2R output kod setting is unsuccessful');
end;

procedure TDACR2R.DataByteToSendFromInteger(IntData: Integer);
begin
  fData[0] := ((IntData shr 8) and $FF);
  fData[1] := (IntData and $FF);
end;

procedure TDACR2R.PacketReceiving(Sender: TObject; const Str: string);
begin

end;

procedure TDACR2R.Reset;
begin
// Output(0);
 fData[2]:=DACR2R_Pos;
 fData[0] := $00;
 fData[1] := $00;
 PacketCreateAndSend('DAC R2R reset is unsuccessful');
end;


procedure TDACR2R.SaveFileWithCalibrData(DataVec: PVector);
 var FileName:string;
begin
  DataVec.Sorting;
  DataVec.DeleteDuplicate;
  FileName:='cal'+IntToStr(trunc(DataVec^.X[0]*100))+
            '_'+IntToStr(trunc(DataVec^.X[High(DataVec^.X)]*100))+
            '.dat';
  DataVec.Write_File(FileName,5);
end;

procedure TDACR2R.PacketCreateAndSend(report: string);
begin
  PacketCreate([DACR2RCommand, PinControl, PinGate, fData[0], fData[1], fData[2]]);
  PacketIsSend(fComPort, report);
end;

procedure TDACR2R.CalibrationFileProcessing(filename: string);
 var vec:PVector;
//     i:integer;
//     newfilename:string;
begin
 new(vec);
 Read_File (filename, vec);
 fCalibration.VectorToCalibr(vec);

// for I := 0 to High(Vec^.X) do
//   Vec^.Y[i]:=round(Vec^.Y[i]*10000)/10000;
//
// for I := 0 to High(Vec^.X)-2 do
//   if (abs(Vec^.Y[i+1])<0.95*abs(Vec^.Y[i]))and
//      (abs(Vec^.Y[i+1])<0.95*abs(Vec^.Y[i+2]))
//               then Vec^.Delete(i+1);
// Vec^.Sorting();
// Vec^.SwapXY();
// Vec^.DeleteDuplicate();
// newfilename:=filename;
// Insert('n',newfilename,AnsiPos(ExtractFileExt(filename),newfilename));
// Write_File(newfilename, vec);
// dispose(vec)
end;

procedure TDACR2R.CalibrationRead;
begin
 fCalibration.ReadFromFileData();
end;

function TDACR2R.CalibrationStep(Voltage: double): double;
begin
  if abs(Voltage)<=1 then Result:=1e-4
                     else Result:=3e-4;
end;

procedure TDACR2R.CalibrationWrite;
begin
 fCalibration.WriteToFileData();
end;

constructor TDACR2R.Create;
begin
  inherited Create();
  SetLength(fData,3);
  fCalibration:=TDACR2R_Calibr.Create;
//  new(fCalibration);
//  fCalibration^.SetLenVector(0);
end;

procedure TDACR2R.DataByteToSendPrepare(Voltage: Double);
var
  IntData: Integer;
begin
  IntData := IntVoltage(Voltage);
  DataByteToSendFromInteger(IntData);
end;

procedure TDACR2R.Free;
begin
// dispose(fCalibration);
 fCalibration.Free;
 inherited Free;
end;

{ TDACR2RShow }

constructor TDACR2RShow.Create(DACR2R: TDACR2R;
                               CPL,GPL,VL,KL:TLabel;
                               SCB,SGB,VCB,VSB,KCB,KSB,RB:TButton;
                               PCB: TComboBox);
begin
 inherited Create(DACR2R,CPL,GPL,SCB,SGB,PCB);
  ValueLabel:=VL;
  ValueLabel.Caption:='0';
  ValueLabel.Font.Color:=clBlack;
  ValueChangeButton:=VCB;
  ValueChangeButton.OnClick:=ValueChangeButtonAction;
  ValueSetButton:=VSB;
  ValueSetButton.OnClick:=ValueSetButtonAction;
  ResetButton:=RB;
  ResetButton.OnClick:=ResetButtonClick;
  KodLabel:=KL;
  KodLabel.Caption:='0';
  KodLabel.Font.Color:=clBlack;
  KodChangeButton:=KCB;
  KodChangeButton.OnClick:=KodChangeButtonAction;
  KodSetButton:=KSB;
  KodSetButton.OnClick:=KodSetButtonAction;

  CreateFooter();
end;

procedure TDACR2RShow.KodChangeButtonAction(Sender: TObject);
 var value:string;
begin
 if InputQuery('Value', 'Output kod is expect', value) then
  begin
    try
      KodLabel.Caption:=IntToStr(StrToInt(value));
      KodLabel.Font.Color:=clBlack;
    except

    end;
  end;
end;

procedure TDACR2RShow.KodSetButtonAction(Sender: TObject);
begin
   (SPIDevice as TDACR2R).OutputInt(StrToInt(KodLabel.Caption));
   KodLabel.Font.Color:=clPurple;
   ValueLabel.Font.Color:=clBlack;
end;

procedure TDACR2RShow.ResetButtonClick(Sender: TObject);
begin
 (SPIDevice as TDACR2R).Reset();
end;

procedure TDACR2RShow.ValueChangeButtonAction(Sender: TObject);
 var value:string;
begin
 if InputQuery('Value', 'Output value is expect', value) then
  begin
    try
      ValueLabel.Caption:=FloatToStrF(StrToFloat(value),ffFixed, 6, 4);
      ValueLabel.Font.Color:=clBlack;
    except

    end;
  end;
end;

procedure TDACR2RShow.ValueSetButtonAction(Sender: TObject);
begin
   (SPIDevice as TDACR2R).Output(Strtofloat(ValueLabel.Caption));
   ValueLabel.Font.Color:=clPurple;
   KodLabel.Font.Color:=clBlack;
end;

{ TV721_Brak }

procedure TV721_Brak.DiapazonDetermination(Data: byte);
begin
  fDiapazon:=DErr;
  case Data of
   127:if fMeasureMode=ID
                      then fDiapazon:=mA1000
                      else fDiapazon:=V1000;
   239: if fMeasureMode=ID
                      then fDiapazon:=mA100
                      else fDiapazon:=V100;
   223: if fMeasureMode=ID
                      then fDiapazon:=mA10
                      else fDiapazon:=V10;
   191: if fMeasureMode=ID
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

{ TDACR2R_Calibr }

procedure TDACR2R_Calibr.Add(RequiredVoltage, RealVoltage: double);
 var tempArrWord:TArrWord;
     Index:integer;
begin
 tempArrWord:=Self.VoltToArray(RealVoltage);
 if tempArrWord=nil then Exit;
 Index:=VoltToKodIndex(RealVoltage);
 if (Index>=Low(tempArrWord))and
    (Index<=High(tempArrWord)) then
        tempArrWord[Index]:=VoltToKod(RequiredVoltage);
// try
// Self.VoltToArray(RealVoltage)[VoltToKodIndex(RealVoltage)]:=VoltToKod(RequiredVoltage);
// except
// end;
end;

procedure TDACR2R_Calibr.AddWord(Index, Kod: word; Arr: TArrWord);
begin
 if (Index<=High(Arr)) then Arr[Index]:=Kod;
// try
//  Arr[Index]:=Kod;
// finally
// end;
end;

constructor TDACR2R_Calibr.Create;
 var i:integer;
begin
 inherited Create;
 SetLength(pos01,10000);
 SetLength(neg01,10000);
 SetLength(pos16,5500);
 SetLength(neg16,5500);
 for I := Low(pos01) to High(pos01) do pos01[i]:=0;
 for I := Low(pos16) to High(pos16) do pos01[i]:=0;
 for I := Low(neg01) to High(neg01) do pos01[i]:=0;
 for I := Low(neg16) to High(neg16) do pos01[i]:=0;
end;

procedure TDACR2R_Calibr.ReadFromFile(FileName: string; arr: TArrWord);
 var F:TextFile;
     Index,Kod:word;
begin
 if not(FileExists(FileName)) then Exit;
 AssignFile(f,FileName);
 Reset(f);
 while not(eof(f)) do
    begin
      readln(f,Index,Kod);
      try
        arr[Index]:=Kod;
      finally

      end;
    end;
 CloseFile(f);
end;

procedure TDACR2R_Calibr.ReadFromFileData;
begin
 ReadFromFile('pos01.cvt',pos01);
 ReadFromFile('pos16.cvt',pos16);
 ReadFromFile('neg01.cvt',neg01);
 ReadFromFile('neg16.cvt',neg16);
end;

procedure TDACR2R_Calibr.VectorToCalibr(Vec: PVector);
 var i:integer;
     tempVec:PVector;
begin
  for I := 0 to High(Vec^.X) do
   Vec^.Y[i]:=round(Vec^.Y[i]*10000)/10000;
 for I := 0 to High(Vec^.X)-2 do
   if (abs(Vec^.Y[i+1])<0.05*abs(Vec^.Y[i]))and
      (abs(Vec^.Y[i+1])<0.05*abs(Vec^.Y[i+2]))
               then Vec^.Delete(i+1);
 new(tempVec);
 SetLenVector(tempVec,0);
 for I := 0 to High(Vec^.X) do
   if Vec^.Y[i]>0 then tempVec^.Add(Vec^.X[i],Vec^.Y[i]);

 tempVec^.Sorting();
 tempVec^.SwapXY();
 tempVec^.DeleteDuplicate();
 for I := 0 to High(tempVec^.X) do
   Add(tempVec^.Y[i],tempVec^.X[i]);
 dispose(tempVec);

 new(tempVec);
 SetLenVector(tempVec,0);
 for I := 0 to High(Vec^.X) do
   if Vec^.Y[i]<0 then tempVec^.Add(Vec^.X[i],Vec^.Y[i]);
 tempVec^.Sorting(False);
 tempVec^.SwapXY();
 tempVec^.DeleteDuplicate();
 for I := 0 to High(tempVec^.X) do
   Add(tempVec^.Y[i],tempVec^.X[i]);
 dispose(tempVec);

end;

function TDACR2R_Calibr.VoltToArray(Volt: double): TArrWord;
begin
 Result:=nil;
 if VoltToKod(Volt)=0 then Exit;
 if (Volt>0)and(Volt<1.001) then Result:=Self.pos01;
 if (Volt<0)and(Volt>-1.001) then Result:=Self.neg01;
 if (Volt>=1.001) then Result:=Self.pos16;
 if (Volt<=-1.001) then Result:=Self.neg16;
end;

class function TDACR2R_Calibr.VoltToKod(Volt: double): word;
begin
 Result:=Min(Round(abs(Volt)*DACR2R_Factor),DACR2R_MaxValue);
end;

function TDACR2R_Calibr.VoltToKodIndex(Volt: double): word;
begin
  if abs(Volt)<1.001 then
           Result:=min(10000,VoltToKod(Volt))-1
                     else
           Result:=min(6500,Round(VoltToKod(Volt)/10))-1001;
end;

procedure TDACR2R_Calibr.WriteToFile(FileName: string; arr: TArrWord);
 var i:integer;
     Str:TStringList;
begin
  if High(arr)<0 then Exit;
  Str:=TStringList.Create;
  for I := 0 to High(arr) do
    if arr[i]<>0 then
      Str.Add(IntToStr(i)+' '+IntToStr(arr[i]));
  Str.SaveToFile(FileName);
  Str.Free;
end;

procedure TDACR2R_Calibr.WriteToFileData;
begin
 WriteToFile('pos01.cvt',pos01);
 WriteToFile('pos16.cvt',pos16);
 WriteToFile('neg01.cvt',neg01);
 WriteToFile('neg16.cvt',neg16);
end;

{ TDS18B20 }

constructor TDS18B20.Create;
begin
  inherited Create();
  fMetterKod:=DS18B20Command;
  SetLength(fPins,1);
  fMinDelayTime:=500;
//  fIsReady:=False;
//  fIsReceived:=False;
end;

//function TDS18B20.GetCurrent(Vin: double): double;
//begin
//   Result:=ErResult;
//end;

//function TDS18B20.GetResist: double;
//begin
//  Result:=ErResult;
//end;

function TDS18B20.GetTemperature: double;
begin
 Result:=Measurement();
end;

//function TDS18B20.GetVoltage(Vin: double): double;
//begin
// Result:=ErResult;
//end;

//function TDS18B20.Measurement: double;
//label start;
//var i:integer;
//    isFirst:boolean;
//begin
// Result:=ErResult;
// if not(fComPort.Connected) then
//   begin
//    showmessage('Port is not connected');
//    Exit;
//   end;
//
// isFirst:=True;
//start:
// fIsReady:=False;
// fIsReceived:=False;
// if not(Request()) then Exit;
// sleep(500);
// i:=0;
// repeat
//   sleep(10);
//   inc(i);
// Application.ProcessMessages;
// until ((i>130)or(fIsReceived));
// if fIsReceived then ConvertToValue(fData);
// if fIsReady then Result:=fValue;
//
// if (Result=ErResult)and(isFirst) then
//    begin
//      isFirst:=false;
//      goto start;
//    end;
//end;


//procedure TDS18B20.PacketReceiving(Sender: TObject; const Str: string);
// var i:integer;
//begin
// if not(PacketIsReceived(Str,fData,DS18B20Command)) then Exit;
// if fData[2]<>PinControl then Exit;
// for I := 0 to High(fData)-4 do
//   fData[i]:=fData[i+3];
// SetLength(fData,High(fData)-3);
// fIsReceived:=True;
//end;

//function TDS18B20.Request: boolean;
//begin
//  PacketCreate([DS18B20Command,PinControl]);
//  Result:=PacketIsSend(fComPort,'DS18B20 measurement is unsuccessful');
//end;

procedure TDS18B20.ConvertToValue(Data: array of byte);
 var temp:integer;
     sign:byte;
begin
 if High(Data)<>1 then Exit;
 sign:=(Data[1] and $F8);
 if sign=$0 then
    begin
      temp:=(Data[1] and $7) Shl 8 + Data[0];
      fValue:=temp/16.0;
    end     else
      if sign=$F8 then
        begin
         temp:=(Data[1] and $7) Shl 8 + Data[0]-128;
         fValue:=temp/16.0;
        end       else
         fValue:=ErResult;
  if (fValue<-55)or(fValue>125) then fValue:=ErResult
                                else fValue:=fValue+273.16;
 fIsready:=True;
end;

{ TArduinoMeter }

constructor TArduinoMeter.Create;
begin
  inherited Create();
  fIsReady:=False;
  fIsReceived:=False;
  fMinDelayTime:=0;
end;

function TArduinoMeter.GetCurrent(Vin: double): double;
begin
  Result:=ErResult;
end;

function TArduinoMeter.GetResist: double;
begin
  Result:=ErResult;
end;

function TArduinoMeter.GetTemperature: double;
begin
  Result:=ErResult;
end;

function TArduinoMeter.GetVoltage(Vin: double): double;
begin
  Result:=ErResult;
end;

function TArduinoMeter.Measurement: double;
label start;
var i:integer;
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
 sleep(fMinDelayTime);
 i:=0;
 repeat
   sleep(10);
   inc(i);
 Application.ProcessMessages;
 until ((i>130)or(fIsReceived));
// showmessage(inttostr((GetTickCount-i0)));
 if fIsReceived then ConvertToValue(fData);
 if fIsReady then Result:=fValue;

 if ((Result=ErResult)or(ResultProblem(Result)))and(isFirst) then
    begin
      isFirst:=false;
      goto start;
    end;
end;

procedure TArduinoMeter.PacketReceiving(Sender: TObject; const Str: string);
  var i:integer;
begin
 if not(PacketIsReceived(Str,fData,fMetterKod)) then Exit;
 if fData[2]<>PinControl then Exit;
 for I := 0 to High(fData)-4 do
   fData[i]:=fData[i+3];
 SetLength(fData,High(fData)-3);
 fIsReceived:=True;
end;

function TArduinoMeter.Request: boolean;
begin
  PacketCreate([fMetterKod,PinControl]);
  Result:=PacketIsSend(fComPort,Name+' measurement is unsuccessful');
end;

function TArduinoMeter.ResultProblem(Rez: double): boolean;
begin
 Result:=False;
end;

end.
