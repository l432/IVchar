unit ET1255;

interface

uses
  RS232device, Measurement, OlegType, Classes, OlegFunction, Spin, StdCtrls, 
  ExtCtrls, Buttons, Series, IniFiles;

const
 ET1255_DAC_MAX=2.5;
 ET1255_DAC_MIN=-2.5;
 ET1255_DAC_CodeMAX=4096;
 ET1255_DAC_CodeMIN=0;
 ET1255_DAC_CodeReset=2048;




function  ET_StartDrv: string; stdcall; external 'ET1255.dll';
{функция подготавливает программу к работе с драйвером.
Выход: сообщение об ошибке. Если все нормально, возвращается пустая строка.}
procedure ET_SetADCChnl(Chnl: word); stdcall; external 'ET1255.dll';
{Установка номера входного канала для режима без аппаратного сканирования каналов
Chnl - номер канала.}
function  ET_ReadADC: single; stdcall; external 'ET1255.dll';
{Ч тение данных АЦП в режиме непосредственного чтения
Выход:  результат измерения в V.  }
procedure ET_SetScanMode(AChCount: integer; AScanEnable: boolean); stdcall; external 'ET1255.dll';
{Установка режима сканирования 
 AChCount – количество каналов сканирования;
 AScanEnable – режим сканирования: TRUE – сканирование разрешено, FALSE - запрещено}
function  ET_ReadMem: single; stdcall; external 'ET1255.dll';
{Чтение данных АЦП из буферного ОЗУ
Выход:  результат измерения в V. }
procedure ET_SetADCMode(AFrq: integer; APrgrmStart,
                 AIntTackt, AMemEnable: boolean); stdcall; external 'ET1255.dll';
{Задание режима работы АЦП 
AFrq – код частоты тактирования, определяется следующим образом:
код  частота
тактирования, МГц
0 8,33
1 4,17
2 2,08
3 1,04
APrgrmStart – режим запуска: TRUE – программируемый, FALSE – аппаратный;
AIntTackt – режим тактирования: TRUE – внутреннее, FALSE – внешнее;
AMemEnable – TRUE - режим работы с буферной памятью;
             FALSE – режим непосредственного чтения.}
function  ET_MeasEnd: boolean; stdcall; external 'ET1255.dll';
{Чтение признака окончания преобразования
Выход: TRUE – преобразование завершено, FALSE – не завершено.}
procedure ET_SetStrob; stdcall; external 'ET1255.dll';
{Запуск АЦП - генерируется строб программного запуска АЦП. }
procedure ET_SetAddr(Addr: word); stdcall; external 'ET1255.dll';
{Установка начального адреса записи данных АЦП в буферную память
Вход: Addr – начального адреса записи данных АЦП в буферную память. }
procedure ET_SetAmplif(Value: word); stdcall; external 'ET1255.dll';
{Установка коэффициента усиления входного усилителя
Value – коэффициент усиления (число в диапазоне 1..15).}
procedure ET_WriteDAC(Value: single; Chnl: integer); stdcall; external 'ET1255.dll';
{Вход: Value – записывемая в ЦАП величина;
 Chnl – номер канала ЦАП.}
procedure ET_WriteDGT(Data: word); stdcall; external 'ET1255.dll';
{Запись в цифровой порт
 Data – записываемые данные. }
function  ET_ReadDGT: word; stdcall; external 'ET1255.dll';
{Чтение цифрового порта
Выход:  прочитанные данные. }
function  ET_WaitADC(AWait: integer): boolean; stdcall; external 'ET1255.dll';
function  ET_GetADCData: word; stdcall; external 'ET1255.dll';
function  ET_ErrMsg: string; stdcall; external 'ET1255.dll';
{Выход:  сообщение об ошибке. Ели ошибок нет, возвращается пустая строка.
Сообщение имеет вид: «Error in <имя функции> = код ошибки». Рекомендуется проверять сообщение об
ошибке после каждого обращения к процедурам и функциям библиотеки. }


{Если в компьютере установлена одна плата ET1255, две следующие процедуры использовать не нужно, по
умолчанию программа сама настраивается на работу с одной платой. }
procedure ET_SetDeviceCount(ADevCount: integer); stdcall; external 'ET1255.dll';
{Вход: ADevCount – количество плат ET1255, установленных на вашем компьютере.
В процессе работы необходимо указывать номер платы, к которой вы обращаетесь, для этого используйте
процедуру: ET_SetDeviceNumber}
procedure ET_SetDeviceNumber(ADevn: integer); stdcall; external 'ET1255.dll';
{Вход: ADevn – порядковый номер платы в памяти компьютера, нумерация начинается с 0}

var
    EventET1255Measurement_Done: THandle;

//    NumberOfMeasurement:Cardinal;
//    NoM:cardinal;

type

 TET1255_DAC_ChanelNumber=0..3;
 TET1255_ADC_ChanelNumber=0..7;
 TET1255_ADC_Gain=1..15;
 TET1255_Frequency_Tackt=(mhz833,mhz417,mhz208, mhz104);

const
 TET1255_Frequency_Tackt_Label:array[TET1255_Frequency_Tackt]of string=
   ('8.33','4.17','2.08', '1.04');

 ET1255IniSectionName='ET1255ADC';


type
 TET1255_Measuring_Thead = class(TThread)
  protected
  public
    constructor Create;
    procedure Execute; override;
  end;

 TET1255_Module=class(TInterfacedObject)
  private
    FStartByProgr: boolean;
    FActiveChannel: TET1255_ADC_ChanelNumber;
    FFrequency_Tackt: TET1255_Frequency_Tackt;
    FMemEnable: boolean;
    FGain: TET1255_ADC_Gain;
    FInternalTacktMode: boolean;
    FNoErrorOperation: boolean;
    fMeasThead:TET1255_Measuring_Thead;
    function NoError():boolean;
  public
  function SetGain(const Value: TET1255_ADC_Gain):boolean;
  function Gain:TET1255_ADC_Gain;
  function SetActiveChannel(const Value: TET1255_ADC_ChanelNumber):boolean;
  function ActiveChannel:TET1255_ADC_ChanelNumber;
  function SetFrequency_Tackt(const Value: TET1255_Frequency_Tackt):boolean;
  function Frequency_Tackt:TET1255_Frequency_Tackt;
  function SetMemEnable(const Value: boolean):boolean;
  function MemEnable:boolean;
  function SetStartByProgr(const Value: boolean):boolean;
  function StartByProgr:boolean;
  function SetInternalTacktMode(const Value: boolean):boolean;
  function InternalTacktMode:boolean;
  property ErrorOperation:boolean read FNoErrorOperation;
  function SetADCMode(FrT: TET1255_Frequency_Tackt;StBPr, IntTMd, MemE: boolean): boolean;
  constructor Create();
  function MeasuringStart():boolean;
  procedure MeasuringStop();
  function SetAddr(Addr: word):boolean;
  function ReadADC():double;
  function ReadMem():double;
 end;

TET1255_ADCChannel=class(TNamedInterfacedObject,IMeasurement)
 private
  fValue:double;
  fET1255MeasuringTread:TThread;
  fNewData:boolean;
  fChanelNumber: TET1255_ADC_ChanelNumber;
  fParentModule:TET1255_Module;
  FSerialMeasurements: boolean;
  FSerialMeasurementNumber: byte;
  function GetNewData:boolean;
  function GetValue:double;
  procedure SetNewData(Value:boolean);
  function Measurement():double;
  procedure SetSerialMeasurements(const Value: boolean);
  procedure SetSerialMeasurementNumber(const Value: byte);
 public
  DataVector:PVector;
  property NewData:boolean read GetNewData write SetNewData;
  property Value:double read GetValue;
  property SerialMeasurements:boolean read FSerialMeasurements write SetSerialMeasurements;
  property SerialMeasurementNumber:byte read FSerialMeasurementNumber write SetSerialMeasurementNumber;
  function GetData:double;
  constructor Create(ChanelNumber:TET1255_ADC_ChanelNumber;
                     ET1255_Module:TET1255_Module);
  procedure Free;
  function SetGain(Value: TET1255_ADC_Gain):boolean;
  function SetFrequency_Takt(const Value: TET1255_Frequency_Tackt):boolean;
  function MeasuringStart():boolean;
  procedure MeasuringStop;
  procedure ValueInitialization;
  procedure PrepareToMeasurement;
  procedure ResultRead();
  procedure GetDataThread(WPARAM: word;EventEnd:THandle);
  procedure WriteToIniFile(ConfigFile: TIniFile);
  procedure ReadFromIniFile(ConfigFile:TIniFile);
end;

  TET1255_Chanel_MeasuringTread = class(TMeasuringTread)
  private
   fET1255_Chan:TET1255_ADCChannel;
   procedure ValueInitialization;
   procedure ResultRead;
  protected
   procedure ExuteBegin;override;
  public
   constructor Create(ET1255_Chan:TET1255_ADCChannel;WPARAM: word; EventEnd: THandle);
  end;

 TET1255_ModuleAndChan=class(TET1255_Module,IMeasurement)
  private
//   Channels:array[TET1255_ADC_ChanelNumber] of TET1255_ADCChannel;
   function GetNewData:boolean;
   function GetValue:double;
   procedure SetNewData(Value:boolean);
   function GetName:string;
  public
   Channels:array[TET1255_ADC_ChanelNumber] of TET1255_ADCChannel;
   property NewData:boolean read GetNewData write SetNewData;
   property Value:double read GetValue;
   property Name:string read GetName;
   constructor Create();
   function GetData:double;
   procedure GetDataThread(WPARAM: word; EventEnd:THandle);
   procedure Free;
   procedure WriteToIniFile(ConfigFile: TIniFile);
   procedure ReadFromIniFile(ConfigFile:TIniFile);
 end;

 TET1255_ADCShow=class(TMeasurementShow)
  private
   ET1255_ModuleAndChan:TET1255_ModuleAndChan;
   SEGain:TSpinEdit;
   SEMeasurementNumber:TSpinEdit;
   CBSerial:TCheckBox;
   Graph: TCustomSeries;
   procedure ElementFill();
//   procedure ElementAction();
//   procedure ElementActionNil();
   procedure GroupChannelsClick(Sender: TObject);
   procedure GroupFrequencyClick(Sender: TObject);
   procedure CBSerialClick(Sender: TObject);
   procedure SEMNChange(Sender: TObject);
   procedure SEGainChange(Sender: TObject);
   procedure FromActiveChannelToVisualElement;
   procedure FromET1255ToVisualElement;
 protected
   function UnitModeLabel():string;override;
  public
   Constructor Create(ET1255:TET1255_ModuleAndChan;
                      MM,R:TRadioGroup;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      TT:TTimer;
                      SEG,SEMN:TSpinEdit;
                      CBSer:TCheckBox;
                      Gr: TCustomSeries
                      );
    procedure Free;
    procedure MetterDataShow();override;
 end;

 TET1255_DAC=class(TNamedInterfacedObject,IDAC)
 private
  fChanelNumber:TET1255_DAC_ChanelNumber;
  fOutputValue:double;
  Procedure ShowError();
  function GetOutputValue:double;
 public
   property OutputValue:double read GetOutputValue;
   procedure Output(Value:double);virtual;
   procedure OutputInt(Kod:integer); virtual;
   Procedure Reset();     virtual;
   Constructor Create(ChanelNumber:TET1255_DAC_ChanelNumber);
   procedure Free;
 end;

implementation

uses
  Dialogs, SysUtils, Windows, Forms, OlegGraph;

{ TET1255_DAC }


constructor TET1255_DAC.Create(ChanelNumber: TET1255_DAC_ChanelNumber);
begin
 inherited Create;
 fChanelNumber:=ChanelNumber;
 case ChanelNumber of
  0:fName:='Ch0_ET1255';
  1:fName:='Ch1_ET1255';
  2:fName:='Ch2_ET1255';
  3:fName:='Ch3_ET1255';
 end;
end;

procedure TET1255_DAC.Free;
begin

end;

function TET1255_DAC.GetOutputValue: double;
begin
 Result:=fOutputValue;
end;

procedure TET1255_DAC.Output(Value: double);
 var tempValue:double;
begin
 if Value=ErResult then Exit;

 if Value>ET1255_DAC_MAX
    then tempValue:=ET1255_DAC_MAX
    else if Value<ET1255_DAC_MIN
            then tempValue:=ET1255_DAC_MIN
            else tempValue:=Value;
 fOutputValue:=tempValue;
 ET_WriteDAC(tempValue,fChanelNumber);
 ShowError();
end;


procedure TET1255_DAC.OutputInt(Kod: integer);
begin
 if Kod=ET1255_DAC_CodeReset then
   begin
    Reset();
    Exit;
   end;
 if Kod>ET1255_DAC_CodeMAX then Kod:=ET1255_DAC_CodeMAX;
 if Kod<ET1255_DAC_CodeMIN then Kod:=ET1255_DAC_CodeMIN;

 if Kod>ET1255_DAC_CodeReset then
    Output(ET1255_DAC_MAX*(Kod-ET1255_DAC_CodeReset)/(ET1255_DAC_CodeMAX-ET1255_DAC_CodeReset))
                             else
    Output(ET1255_DAC_MIN*(ET1255_DAC_CodeReset-Kod)/(ET1255_DAC_CodeReset-ET1255_DAC_CodeMIN));
end;

procedure TET1255_DAC.Reset;
begin
  Output(0);
end;

procedure TET1255_DAC.ShowError;
 var str:string;
begin
 str:=ET_ErrMsg;
 if str<>'' then
   showmessage(str);
end;

{ TET1255_Module }

function TET1255_Module.ActiveChannel: TET1255_ADC_ChanelNumber;
begin
 Result:=FActiveChannel;
end;

constructor TET1255_Module.Create;
begin
 inherited Create;
 FNoErrorOperation:=False;
// ++++++++++++++++++++++++++
  SetActiveChannel(0);
 SetGain(1);
 SetADCMode(mhz104,True,True,False);

//++++++++++++++++++++++++++++
end;

function TET1255_Module.Frequency_Tackt: TET1255_Frequency_Tackt;
begin
 Result:=FFrequency_Tackt;
end;

function TET1255_Module.Gain: TET1255_ADC_Gain;
begin
 Result:=FGain;
end;

function TET1255_Module.InternalTacktMode: boolean;
begin
 Result:=FInternalTacktMode;
end;

function TET1255_Module.MeasuringStart;
begin
 ResetEvent(EventET1255Measurement_Done);
 fMeasThead:=TET1255_Measuring_Thead.Create();

 result:=true;
end;

procedure TET1255_Module.MeasuringStop;
begin
 if assigned(fMeasThead) then   fMeasThead.Terminate;
end;

function TET1255_Module.MemEnable: boolean;
begin
 Result:=FMemEnable;
end;

function TET1255_Module.NoError: boolean;
 var str:string;
begin
  str:=ET_ErrMsg;
  if str<>''
   then
    begin
    showmessage(str);
    Result:=False;
    end
   else
    Result:=True;
 FNoErrorOperation:=Result;
end;

function TET1255_Module.ReadADC(): double;
begin
 Result:=ET_ReadADC+2.5;
 if not(NoError()) then Result:=ErResult;
end;

function TET1255_Module.ReadMem: double;
begin
 Result:=ET_ReadMem+2.5;
 if not(NoError()) then Result:=ErResult;
end;

function TET1255_Module.SetActiveChannel(
   const Value: TET1255_ADC_ChanelNumber):boolean;
begin
  ET_SetADCChnl(Value);
  if NoError() then FActiveChannel := Value;
  Result:=FNoErrorOperation;
end;

function TET1255_Module.SetADCMode(FrT: TET1255_Frequency_Tackt;StBPr, IntTMd, MemE: boolean): boolean;
begin
  ET_SetADCMode(ord(FrT), StBPr, IntTMd, MemE);
  if NoError() then
    begin
     FFrequency_Tackt := FrT;
     FStartByProgr:=StBPr;
     FInternalTacktMode:=IntTMd;
     FMemEnable:=MemE;
    end;
  Result:=FNoErrorOperation;
end;

function TET1255_Module.SetAddr(Addr: word): boolean;
begin
 ET_SetAddr(Addr);
 Result:=NoError();
end;

function TET1255_Module.SetFrequency_Tackt(const Value: TET1255_Frequency_Tackt):boolean;
begin
  ET_SetADCMode(ord(Value), FStartByProgr, FInternalTacktMode, FMemEnable);
  if NoError() then FFrequency_Tackt := Value;
  Result:=FNoErrorOperation;
end;

function TET1255_Module.SetGain(const Value: TET1255_ADC_Gain):boolean;
begin
  ET_SetAmplif(Value);
  if NoError() then FGain := Value;
  Result:=FNoErrorOperation;
end;

function TET1255_Module.SetMemEnable(const Value: boolean):boolean;
begin
  ET_SetADCMode(ord(FFrequency_Tackt), FStartByProgr, FInternalTacktMode, Value);
  if NoError() then FMemEnable := Value;
  Result:=FNoErrorOperation;
end;

function TET1255_Module.SetStartByProgr(const Value: boolean): boolean;
begin
  ET_SetADCMode(ord(FFrequency_Tackt), Value, FInternalTacktMode, FMemEnable);
  if NoError() then FStartByProgr := Value;
  Result:=FNoErrorOperation;
end;

function TET1255_Module.StartByProgr: boolean;
begin
 Result:=FStartByProgr;
end;

function TET1255_Module.SetInternalTacktMode(const Value: boolean): boolean;
begin
  ET_SetADCMode(ord(FFrequency_Tackt), FStartByProgr, Value, FMemEnable);
  if NoError() then FInternalTacktMode := Value;
  Result:=FNoErrorOperation;
end;



{ TET1255_ADCChannel }

constructor TET1255_ADCChannel.Create(ChanelNumber: TET1255_ADC_ChanelNumber;
                                      ET1255_Module: TET1255_Module);
begin
 inherited Create;
 fChanelNumber:=ChanelNumber;
 fName:='ADC'+inttostr(ord(ChanelNumber))+'_ET1255';
 fParentModule:=ET1255_Module;
 new(DataVector);
 FSerialMeasurements:=False;
 FSerialMeasurementNumber:=0;
end;

procedure TET1255_ADCChannel.Free;
begin
 dispose(DataVector);
// inherited Free;
end;

function TET1255_ADCChannel.GetData: double;
begin
 Result:=Measurement();
 fNewData:=True;
end;

procedure TET1255_ADCChannel.GetDataThread(WPARAM: word; EventEnd: THandle);
begin
 fET1255MeasuringTread:=
   TET1255_Chanel_MeasuringTread.Create(Self,WPARAM,EventEnd);
end;

function TET1255_ADCChannel.GetNewData: boolean;
begin
  Result:=fNewData;
end;

function TET1255_ADCChannel.GetValue: double;
begin
  Result:=fValue;
end;

function TET1255_ADCChannel.Measurement: double;
begin
 PrepareToMeasurement();
 ValueInitialization();
 if MeasuringStart() then
  if WaitForSingleObject(EventET1255Measurement_Done,1500)=WAIT_OBJECT_0
   then
   begin
//    showmessage(' Nom='+inttostr(NoM));
   ResultRead()
   end
   else  MeasuringStop;
// showmessage(' Nom='+inttostr(NoM));

 Result:=fValue;
end;

function TET1255_ADCChannel.MeasuringStart: boolean;
begin
 Result:=fParentModule.MeasuringStart;
end;

procedure TET1255_ADCChannel.MeasuringStop;
begin
  fParentModule.MeasuringStop;
end;

procedure TET1255_ADCChannel.PrepareToMeasurement;
begin
  if not(fParentModule.SetActiveChannel(fChanelNumber))
   then Exit;
  if not(fParentModule.SetMemEnable(FSerialMeasurements))
   then Exit;

  if FSerialMeasurements then
    if not(fParentModule.SetAddr($FF-FSerialMeasurementNumber))
     then Exit;
end;

procedure TET1255_ADCChannel.ReadFromIniFile(ConfigFile: TIniFile);
begin
  SerialMeasurements:=ConfigFile.ReadBool(Name, 'SerialMeasurements', False);
  SerialMeasurementNumber:=ConfigFile.ReadInteger(Name, 'SerialMeasurementsNum', 1);
end;

procedure TET1255_ADCChannel.ResultRead;
 var i:Cardinal;
begin
 if FSerialMeasurements
  then
   begin
    if not(fParentModule.SetAddr($FF-FSerialMeasurementNumber))
      then Exit;
     for I := 0 to High(DataVector^.X) do
      begin
       DataVector^.X[i]:=i;
       DataVector^.Y[i]:=fParentModule.ReadMem;
      end;
     fValue:=ImpulseNoiseSmoothingByNpoint(DataVector);
     fValue:=fValue/fParentModule.Gain;
   end
  else
   begin
    fValue:=fParentModule.ReadADC;
    fValue:=fValue/fParentModule.Gain;
    DataVector^.X[0]:=0;
    DataVector^.Y[0]:=fValue;
   end;
end;

function TET1255_ADCChannel.SetFrequency_Takt(
  const Value: TET1255_Frequency_Tackt):boolean;
begin
 Result:=fParentModule.SetFrequency_Tackt(Value);
end;

function TET1255_ADCChannel.SetGain(Value: TET1255_ADC_Gain):boolean;
begin
 Result:=fParentModule.SetGain(Value);
end;


procedure TET1255_ADCChannel.SetNewData(Value: boolean);
begin
  fNewData:=Value;
end;

procedure TET1255_ADCChannel.SetSerialMeasurementNumber(const Value: byte);
begin
  FSerialMeasurementNumber := Value;
end;

procedure TET1255_ADCChannel.SetSerialMeasurements(const Value: boolean);
begin
  FSerialMeasurements := Value;
end;

procedure TET1255_ADCChannel.ValueInitialization;
begin
  fValue:=ErResult;
  if FSerialMeasurements
   then  SetLenVector(DataVector,(FSerialMeasurementNumber shl 12))
   else SetLenVector(DataVector,1);
end;

procedure TET1255_ADCChannel.WriteToIniFile(ConfigFile: TIniFile);
begin
  ConfigFile.EraseSection(Name);
  WriteIniDef(ConfigFile,Name,'SerialMeasurements', SerialMeasurements);
  WriteIniDef(ConfigFile,Name,'SerialMeasurementsNum',  SerialMeasurementNumber);
end;

{ TET1255_Measuring_Thead }

constructor TET1255_Measuring_Thead.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  Self.Priority := tpNormal;
  Resume;
end;

procedure TET1255_Measuring_Thead.Execute;
begin
  ET_SetStrob;

  repeat
  until Terminated or Application.Terminated or ET_MeasEnd;
  SetEvent(EventET1255Measurement_Done);

end;

{ TET1255_MeasuringTread }

constructor TET1255_Chanel_MeasuringTread.Create(ET1255_Chan: TET1255_ADCChannel;
  WPARAM: word; EventEnd: THandle);
begin
  inherited Create(ET1255_Chan,WPARAM,EventEnd);
  fET1255_Chan := ET1255_Chan;
  fMeasurement:=fET1255_Chan;
  Resume;
end;

procedure TET1255_Chanel_MeasuringTread.ExuteBegin;
begin
 fET1255_Chan.PrepareToMeasurement();
 Synchronize(ValueInitialization);
 if fET1255_Chan.MeasuringStart() then
  if WaitForSingleObject(EventComPortFree,1500)=WAIT_OBJECT_0
   then  Synchronize(ResultRead)
   else  fET1255_Chan.MeasuringStop;
end;

procedure TET1255_Chanel_MeasuringTread.ResultRead;
begin
 fET1255_Chan.ResultRead
end;

procedure TET1255_Chanel_MeasuringTread.ValueInitialization;
begin
 fET1255_Chan.ValueInitialization();
end;

{ TET1255_ModuleAndChan }

constructor TET1255_ModuleAndChan.Create;
 var i:TET1255_ADC_ChanelNumber;
begin
  inherited Create();
  for I := Low(TET1255_ADC_ChanelNumber) to High(TET1255_ADC_ChanelNumber) do
    Channels[i]:=TET1255_ADCChannel.Create(i,Self);
end;

procedure TET1255_ModuleAndChan.Free;
 var i:TET1255_ADC_ChanelNumber;
begin
  for I := Low(TET1255_ADC_ChanelNumber) to High(TET1255_ADC_ChanelNumber)
     do Channels[i].Free;
//  inherited Free;
end;

function TET1255_ModuleAndChan.GetData: double;
begin
 Result:=Channels[ActiveChannel].GetData;
end;

procedure TET1255_ModuleAndChan.GetDataThread(WPARAM: word; EventEnd: THandle);
begin
 Channels[ActiveChannel].GetDataThread(WPARAM,EventEnd);
end;

function TET1255_ModuleAndChan.GetName: string;
begin
 Result:=Channels[ActiveChannel].Name;
end;

function TET1255_ModuleAndChan.GetNewData: boolean;
begin
  Result:=Channels[ActiveChannel].GetNewData;
end;

function TET1255_ModuleAndChan.GetValue: double;
begin
  Result:=Channels[ActiveChannel].GetValue;
end;

procedure TET1255_ModuleAndChan.ReadFromIniFile(ConfigFile: TIniFile);
 var i:TET1255_ADC_ChanelNumber;
begin
  for I := Low(TET1255_ADC_ChanelNumber) to High(TET1255_ADC_ChanelNumber) do
    Channels[i].ReadFromIniFile(ConfigFile);

  SetActiveChannel(TET1255_ADC_ChanelNumber(
                    ConfigFile.ReadInteger(ET1255IniSectionName, 'ActiveChannel', 0)));
  SetGain(TET1255_ADC_Gain(
                   ConfigFile.ReadInteger(ET1255IniSectionName, 'Gain', 1)));

  SetADCMode(TET1255_Frequency_Tackt(
              ConfigFile.ReadInteger(ET1255IniSectionName, 'Frequency_Tackt', 0)),
              ConfigFile.ReadBool(ET1255IniSectionName, 'StartByProgr', True),
              ConfigFile.ReadBool(ET1255IniSectionName, 'InternalTacktMode', True),
              MemEnable);
end;

procedure TET1255_ModuleAndChan.SetNewData(Value: boolean);
begin
 Channels[ActiveChannel].NewData:=Value;
end;

procedure TET1255_ModuleAndChan.WriteToIniFile(ConfigFile: TIniFile);
 var i:TET1255_ADC_ChanelNumber;
begin
  for I := Low(TET1255_ADC_ChanelNumber) to High(TET1255_ADC_ChanelNumber) do
    Channels[i].WriteToIniFile(ConfigFile);

  ConfigFile.EraseSection(ET1255IniSectionName);
  WriteIniDef(ConfigFile,ET1255IniSectionName,'ActiveChannel', ord(ActiveChannel));
  WriteIniDef(ConfigFile,ET1255IniSectionName,'Gain',  Gain);
  WriteIniDef(ConfigFile,ET1255IniSectionName,'Frequency_Tackt', ord(Frequency_Tackt));
  WriteIniDef(ConfigFile,ET1255IniSectionName,'StartByProgr', StartByProgr);
  WriteIniDef(ConfigFile,ET1255IniSectionName,'InternalTacktMode', InternalTacktMode);
end;

{ TET1255_ADCShow }

procedure TET1255_ADCShow.CBSerialClick(Sender: TObject);
begin
 ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].SerialMeasurements:=CBSerial.Checked;
 SEMeasurementNumber.Enabled:=CBSerial.Checked;
end;

constructor TET1255_ADCShow.Create(ET1255: TET1255_ModuleAndChan;
                                   MM, R: TRadioGroup;
                                   DL, UL: TLabel;
                                   MB: TButton;
                                   AB: TSpeedButton;
                                   TT: TTimer;
                                   SEG, SEMN: TSpinEdit;
                                   CBSer: TCheckBox;
                                   Gr: TCustomSeries);
begin
 inherited Create(ET1255, MM, R, DL, UL, MB, AB, TT);
 ET1255_ModuleAndChan:=ET1255;
 SEGain:=SEG;
 SEMeasurementNumber:=SEMN;
 CBSerial:=CBSer;
 Graph:=Gr;

 ElementFill();
 FromET1255ToVisualElement;
end;

procedure TET1255_ADCShow.ElementFill;
 var i:TET1255_ADC_ChanelNumber;
     j:TET1255_Frequency_Tackt;
begin
  Range.Caption:='Active Channel';
  Range.Columns:=2;
  Range.Items.Clear;
    for I := Low(TET1255_ADC_ChanelNumber) to High(TET1255_ADC_ChanelNumber)
      do Range.Items.Add(inttostr(ord(i)));
  Range.ItemIndex:=Low(TET1255_ADC_ChanelNumber);

  MeasureMode.Caption:='Frequancy (MHz)';
  MeasureMode.Columns:=2;
  MeasureMode.Items.Clear;
    for j := Low(TET1255_Frequency_Tackt) to High(TET1255_Frequency_Tackt)
      do  MeasureMode.Items.Add(TET1255_Frequency_Tackt_Label[j]);
  MeasureMode.ItemIndex:=ord(Low(TET1255_Frequency_Tackt));

  SEGain.Increment:=1;
  SEGain.MinValue:=Low(TET1255_ADC_Gain);
  SEGain.MaxValue:=High(TET1255_ADC_Gain);
  SEGain.Value:=SEGain.MinValue;
  SEGain.EditorEnabled:=False;

  SEMeasurementNumber.Increment:=1;
  SEMeasurementNumber.MinValue:=Low(byte)+1;
  SEMeasurementNumber.MaxValue:=High(byte);
  SEMeasurementNumber.Value:=SEGain.MinValue;
end;

procedure TET1255_ADCShow.Free;
begin

end;

procedure TET1255_ADCShow.FromActiveChannelToVisualElement;
begin
  CBSerial.OnClick:=nil;
  SEMeasurementNumber.OnChange:=nil;

  CBSerial.Checked:=ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].SerialMeasurements;
  SEMeasurementNumber.Enabled:=CBSerial.Checked;
  SEMeasurementNumber.Value:= ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].SerialMeasurementNumber;

  CBSerial.OnClick:=CBSerialClick;
  SEMeasurementNumber.OnChange:=SEMNChange;
end;

procedure TET1255_ADCShow.FromET1255ToVisualElement;
begin
  Range.OnClick:=nil;
  MeasureMode.OnClick:=nil;
  SEGain.OnChange:=nil;

  Range.ItemIndex:=ord(ET1255_ModuleAndChan.ActiveChannel);
  MeasureMode.ItemIndex:=ord(ET1255_ModuleAndChan.FFrequency_Tackt);
  SEGain.Value:=byte(ET1255_ModuleAndChan.Gain);
  FromActiveChannelToVisualElement;

  Range.OnClick:=GroupChannelsClick;
  MeasureMode.OnClick:=GroupFrequencyClick;
  SEGain.OnChange:=SEGainChange;
end;

procedure TET1255_ADCShow.GroupChannelsClick(Sender: TObject);
begin
 if ET1255_ModuleAndChan.SetActiveChannel(
         TET1255_ADC_ChanelNumber(
           Low(TET1255_ADC_ChanelNumber)+Range.ItemIndex))
   then
     FromActiveChannelToVisualElement
   else
    begin
     Range.OnClick:=nil;
     Range.ItemIndex:=ord(ET1255_ModuleAndChan.ActiveChannel);
     Range.OnClick:=GroupChannelsClick;
    end;
end;

procedure TET1255_ADCShow.GroupFrequencyClick(Sender: TObject);
begin
 if ET1255_ModuleAndChan.SetFrequency_Tackt(
         TET1255_Frequency_Tackt(MeasureMode.ItemIndex))
   then
   else
    begin
     MeasureMode.OnClick:=nil;
     MeasureMode.ItemIndex:=ord(ET1255_ModuleAndChan.FFrequency_Tackt);
     MeasureMode.OnClick:=GroupFrequencyClick;
    end;
end;

procedure TET1255_ADCShow.MetterDataShow;
begin
  inherited MetterDataShow;
  Graph.Clear;
    if fMeter.Value<>ErResult then
     begin
      VectorToGraph(ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].DataVector,Graph);
     end;
end;

procedure TET1255_ADCShow.SEGainChange(Sender: TObject);
begin
if ET1255_ModuleAndChan.SetGain(
         TET1255_ADC_Gain(SEGain.Value))
   then
   else
    begin
     SEGain.OnChange:=nil;
     SEGain.Value:=byte(ET1255_ModuleAndChan.Gain);
     SEGain.OnChange:=SEGainChange;
    end;

end;

procedure TET1255_ADCShow.SEMNChange(Sender: TObject);
begin
 ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].SerialMeasurementNumber:=SEMeasurementNumber.Value;
end;

function TET1255_ADCShow.UnitModeLabel: string;
begin
 Result:='V';
end;

initialization
  EventET1255Measurement_Done := CreateEvent(nil,
                                 True, // тип сброса TRUE - ручной
                                 True, // начальное состояние TRUE - сигнальное
                                 nil);

finalization
  SetEvent(EventET1255Measurement_Done);
  CloseHandle(EventET1255Measurement_Done);
end.
