unit ET1255;

interface

uses
  RS232device, Measurement;

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
procedure ET_SetADCMode(AFrq: integer; APrgrmStart, AIntTackt, AMemEnable: boolean); stdcall;
external 'ET1255.dll';
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
AMemEnable – TRUE - режим работы с буферной памятью; FALSE – режим непосредственного
чтения.}
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

type

 TET1255_DAC_ChanelNumber=0..2;

 TET1255_DAC=class(TNamedDevice,IDAC)
 private
  fChanelNumber:TET1255_DAC_ChanelNumber;
//  fError:string;
  Procedure ShowError();
 public
   procedure Output(Value:double);virtual;
   procedure OutputInt(Kod:integer); virtual;
   Procedure Reset();     virtual;
   function CalibrationStep(Voltage:double):double;  virtual;
   procedure OutputCalibr(Value:double); virtual;
   Constructor Create(ChanelNumber:TET1255_DAC_ChanelNumber);
   procedure Free;
 end;

//var ET_Error:string;


implementation

uses
  Dialogs, SysUtils;

{ TET1255_DAC }

function TET1255_DAC.CalibrationStep(Voltage: double): double;
begin
 Result:=0.001;
end;

constructor TET1255_DAC.Create(ChanelNumber: TET1255_DAC_ChanelNumber);
begin
 inherited Create;
 fChanelNumber:=ChanelNumber;
 case ChanelNumber of
  0:fName:='Ch0_ET1255';
  1:fName:='Ch1_ET1255';
  2:fName:='Ch2_ET1255';
 end;
 // ShowError();
end;

procedure TET1255_DAC.Free;
begin

end;

procedure TET1255_DAC.Output(Value: double);
begin
 showmessage('ch'+inttostr(fChanelNumber)+' d='+floattostr(Value));

 if Value>ET1255_DAC_MAX
    then ET_WriteDAC(ET1255_DAC_MAX,fChanelNumber)
    else if Value<ET1255_DAC_MIN
            then ET_WriteDAC(ET1255_DAC_MIN,fChanelNumber)
            else ET_WriteDAC(Value,fChanelNumber);
// fError:=ET_ErrMsg;
 ShowError();
end;

procedure TET1255_DAC.OutputCalibr(Value: double);
begin
 Output(Value);
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
    Output(ET1255_DAC_MIN*(Kod-ET1255_DAC_CodeMIN)/(ET1255_DAC_CodeReset-ET1255_DAC_CodeMIN));
end;

procedure TET1255_DAC.Reset;
begin
//  ET_WriteDAC(0,fChanelNumber);
//  ShowError();
  Output(0);
end;


procedure TET1255_DAC.ShowError;
begin
 if ET_ErrMsg<>'' then
   showmessage(ET_ErrMsg);
end;

initialization

//  if ET_StartDrv()<>'' then
//   showmessage('ET1255 loading error'+#10#13+ET_ErrMsg);

finalization

end.
