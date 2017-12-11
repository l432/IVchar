unit ET1255;

interface

uses
  RS232device, Measurement, OlegType, Classes, OlegFunction;

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

    NumberOfMeasurement:Cardinal;


type

 TET1255_DAC_ChanelNumber=0..3;
 TET1255_ADC_ChanelNumber=0..7;
 TET1255_ADC_Gain=1..15;
 TET1255_Frequency_Tackt=(mhz833,mhz417,mhz208, mhz104);

 TET1255_Measuring_Thead = class(TThread)
  protected
  public
    constructor Create;
    procedure Execute; override;
  end;

 TET1255_Module=class
  private
    FStartByProgr: boolean;
    FActiveChannel: TET1255_ADC_ChanelNumber;
    FFrequency_Tackt: TET1255_Frequency_Tackt;
    FMemEnable: boolean;
    FGain: TET1255_ADC_Gain;
    FInternalTacktMode: boolean;
    FNoErrorOperation: boolean;
    fMeasThead:TET1255_Measuring_Thead;
//    procedure SetActiveChannel(const Value: TET1255_ADC_ChanelNumber);
//    procedure SetFrequency_Takt(const Value: TET1255_Frequency_Tackt);
//    procedure SetGain(const Value: TET1255_ADC_Gain);
//    procedure SetMemEnable(const Value: boolean);
//    procedure SetStartByProgr(const Value: boolean);
    function NoError():boolean;
//    procedure SetInternalTacktMode(const Value: boolean);
  public
  function SetGain(const Value: TET1255_ADC_Gain):boolean;
  function Gain:TET1255_ADC_Gain;
//  property Gain:TET1255_ADC_Gain read FGain write SetGain;
  function SetActiveChannel(const Value: TET1255_ADC_ChanelNumber):boolean;
  function ActiveChannel:TET1255_ADC_ChanelNumber;
//  property ActiveChannel:TET1255_ADC_ChanelNumber read FActiveChannel write SetActiveChannel;
  function SetFrequency_Takt(const Value: TET1255_Frequency_Tackt):boolean;
  function Frequency_Tackt:TET1255_Frequency_Tackt;
//  property Frequency_Tackt:TET1255_Frequency_Tackt read FFrequency_Tackt write SetFrequency_Takt;
  function SetMemEnable(const Value: boolean):boolean;
  function MemEnable:boolean;
//  property MemEnable:boolean read FMemEnable write SetMemEnable;
  function SetStartByProgr(const Value: boolean):boolean;
  function StartByProgr:boolean;
//  property StartByProgr:boolean read FStartByProgr write SetStartByProgr;
  function SetInternalTacktMode(const Value: boolean):boolean;
  function InternalTacktMode:boolean;
//  property InternalTacktMode:boolean read FInternalTacktMode write SetInternalTacktMode;
  property ErrorOperation:boolean read FNoErrorOperation;
  function SetADCMode(FrT: TET1255_Frequency_Tackt;StBPr, IntTMd, MemE: boolean): boolean;
  constructor Create();
  function MeasuringStart():boolean;
  procedure MeasuringStop();
  function SetAddr(Addr: word):boolean;
  function ReadADC():double;
  function ReadMem():double;
 end;

TET1255_ADCChannel=class(TNamedDevice{,IMeasurement})
 private
   fValue:double;

//   fRS232MeasuringTread:TThread;
  fNewData:boolean;
  fChanelNumber: TET1255_ADC_ChanelNumber;
  fParentModule:TET1255_Module;
  FSerialMeasurements: boolean;
  FSerialMeasurementNumber: byte;
  function GetNewData:boolean;
  function GetValue:double;
  procedure SetNewData(Value:boolean);
  Function Measurement():double;
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
end;

 TET1255_DAC=class(TNamedDevice,IDAC)
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
//   function CalibrationStep(Voltage:double):double;  virtual;
//   procedure OutputCalibr(Value:double); virtual;
   Constructor Create(ChanelNumber:TET1255_DAC_ChanelNumber);
   procedure Free;
 end;

implementation

uses
  Dialogs, SysUtils, Windows, Forms;

{ TET1255_DAC }

//function TET1255_DAC.CalibrationStep(Voltage: double): double;
//begin
// Result:=0.001;
//end;

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
 if Value>ET1255_DAC_MAX
    then tempValue:=ET1255_DAC_MAX
    else if Value<ET1255_DAC_MIN
            then tempValue:=ET1255_DAC_MIN
            else tempValue:=Value;
 fOutputValue:=tempValue;
 ET_WriteDAC(tempValue,fChanelNumber);
 ShowError();
end;

//procedure TET1255_DAC.OutputCalibr(Value: double);
//begin
// Output(Value);
//end;

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
 SetActiveChannel(0);
 SetGain(1);
 SetADCMode(mhz104,True,True,False);

// FStartByProgr:=True;
// FActiveChannel:=0;
// FFrequency_Tackt:=mhz104;
// FMemEnable:=False;
// FGain:=1;
// FInternalTacktMode:=True;
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
 ET_SetStrob;
 if not(NoError()) then  fMeasThead.Terminate;
 Result:=FNoErrorOperation;
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
 Result:=ET_ReadADC;
 if not(NoError()) then Result:=ErResult;
end;

function TET1255_Module.ReadMem: double;
begin
 Result:=ET_ReadMem;
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

function TET1255_Module.SetFrequency_Takt(const Value: TET1255_Frequency_Tackt):boolean;
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
 inherited;
end;

function TET1255_ADCChannel.GetData: double;
begin
 Result:=Measurement();
 fNewData:=True;
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
 var PointNumber,i:Cardinal;
begin
  Result:=ErResult;

  if not(fParentModule.SetActiveChannel(fChanelNumber))
   then Exit;

  if not(fParentModule.SetMemEnable(FSerialMeasurements))
   then Exit;

  if FSerialMeasurements
  then
   begin
    PointNumber:=(FSerialMeasurementNumber shl 12);
    NumberOfMeasurement:=PointNumber;
    if not(fParentModule.SetAddr($FF-FSerialMeasurementNumber))
     then Exit;

    SetLenVector(DataVector,PointNumber);
    if not(fParentModule.MeasuringStart()) then Exit;

    if WaitForSingleObject(EventComPortFree,1500)=WAIT_OBJECT_0
     then
      begin
       if not(fParentModule.SetAddr($FF-FSerialMeasurementNumber))
        then Exit;
       for I := 0 to PointNumber - 1 do
        DataVector^.Add(i,fParentModule.ReadMem);
       Result:=ImpulseNoiseSmoothingByNpoint(DataVector^.Y);
      end
     else fParentModule.MeasuringStop;
   end

  else
   begin
    NumberOfMeasurement:=1;
    if not(fParentModule.MeasuringStart()) then Exit;
    if WaitForSingleObject(EventComPortFree,1500)=WAIT_OBJECT_0
     then Result:=fParentModule.ReadADC
     else fParentModule.MeasuringStop;
   end;


end;

function TET1255_ADCChannel.SetFrequency_Takt(
  const Value: TET1255_Frequency_Tackt):boolean;
begin
 Result:=fParentModule.SetFrequency_Takt(Value);
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
  while (not Terminated) and (not Application.Terminated) do
  begin
    if ET_MeasEnd then NumberOfMeasurement:=NumberOfMeasurement-1;
    if NumberOfMeasurement<=0 then
     begin
       SetEvent(EventET1255Measurement_Done);
       Break;
     end;
  end;
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
