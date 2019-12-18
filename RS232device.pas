unit RS232device;

interface

uses
  Measurement, CPort, PacketParameters, ExtCtrls, StdCtrls, Buttons, Windows,
  Classes,OlegTypePart2;


const
 Error='Error';
 IA_Label='~I';
 ID_Label='=I';
 UA_Label='~U';
 UD_Label='=U';
 ErrorMes=' connection with ComPort is unsuccessful';

var
    EventComPortFree: THandle;
    EventMeasuringEnd: THandle;

type

//  http://www.sql.ru/forum/681753/delegirovanie-realizacii-metodov-interfeysa-drugomu-klassu

TRS232Device=class(TNamedInterfacedObject)
  {базовий клас для пристроїв, які керуються
  за допомогою COM-порту}
  protected
   fComPort:TComPort;
   fComPacket: TComDataPacket;
   fData:TArrByte;
   fisNeededComPort:boolean;
   fError:boolean;
   fMessageError:string;
   function PortConnected():boolean;
   procedure  PacketCreateToSend(); virtual;
  public
   property isNeededComPort:boolean read fisNeededComPort write fisNeededComPort;
   property Error:boolean read fError;
   Constructor Create();overload;
   Constructor Create(CP:TComPort);overload;
   Constructor Create(CP:TComPort;Nm:string);overload;//virtual;
   Procedure Free;override;//virtual;
   procedure ComPortUsing();virtual;
   procedure isNeededComPortState();
  end;

IConvertData = interface
['{C70AB96D-7E4F-4644-BF18-67C72F817EE0}']
 Function MeasureModeLabelRead():string;
 function GetDiapazon:Shortint;
 Procedure ConvertToValue();
 property MeasureModeLabel:string read MeasureModeLabelRead;
 property Diapazon:Shortint read GetDiapazon;
end;


TRS232ConvertData=class(TRS232Device)
  protected
   fValue:double;
   Function GetValue():double;
  public
   property Value:double read GetValue write fValue;
  end;

TRS232MeterConvertData=class(TInterfacedObject,IConvertData)
 protected
   fDiapazon:Shortint;
   fRS232ConvertData:TRS232ConvertData;
   Function MeasureModeLabelRead():string;virtual;
   function GetDiapazon:Shortint;
   Procedure ConvertToValue();virtual;
 public
   property MeasureModeLabel:string read MeasureModeLabelRead;
   property Diapazon:Shortint read fDiapazon;
   Constructor Create(RS232ConvertData:TRS232ConvertData);
end;

TComplexDeviceConvertData=class(TRS232MeterConvertData)
  protected
   fMeasureMode:Shortint;
   fMeasureModeAll:array of string;
   fDiapazonAll:array of array of string;
   fRS232MeterConvertData:TRS232MeterConvertData;
   Procedure MModeDetermination(Data:array of byte); virtual;abstract;
   Procedure DiapazonDetermination(Data:array of byte);virtual;abstract;
   Procedure ValueDetermination(Data:array of byte);virtual;abstract;
   Function MeasureModeLabelRead():string;override;
   Procedure ConvertToValue();override;
  public
   Constructor Create(RS232MeterConvertData:TRS232MeterConvertData);
end;

//TRS232Meter=class(TRS232Device,IMeasurement)
TRS232Meter=class(TRS232ConvertData,IMeasurement)
  {базовий клас для вимірювальних об'єктів,
  які використовують обмін даних з COM-портом}
  protected
   fValue:double;
//   fIsReady:boolean;
   fIsReceived:boolean;
   fMinDelayTime:integer;
  {інтервал очікування перед початком перевірки
  вхідного буфера, []=мс, за замовчуванням 0}
   fDelayTimeStep:integer;
   {проміжок часу, через який перевіряється
   надходження даних, []=мс, за замовчуванням 10}
   fDelayTimeMax:integer;
   {максимальна кількість перевірок
   надходження даних, []=штук, за замовчуванням 130,
   тобто за замовчуванням інтервал очікуввання
   складає 0+10*130=1300 мс}
   fMeasureMode:Shortint;
   fDiapazon:Shortint;
   fMeasureModeAll:array of string;
   fDiapazonAll:array of array of string;
   fRS232MeasuringTread:TThread;
   fNewData:boolean;
   function GetNewData:boolean;
   Procedure MModeDetermination(Data:array of byte); virtual;
   Procedure DiapazonDetermination(Data:array of byte); virtual;
   Procedure ValueDetermination(Data:array of byte);virtual;
   Function MeasureModeLabelRead():string;virtual;
   Procedure PacketReceiving(Sender: TObject; const Str: string);virtual;
   Function Measurement():double;virtual;
   Function GetValue():double;virtual;
   procedure SetNewData(Value:boolean);
  public
   RepeatInErrorCase:boolean;
   property NewData:boolean read GetNewData write SetNewData;
   property Value:double read GetValue write fValue;
//   property isReady:boolean read fIsReady write fIsReady;
   property isReceived:boolean read fIsReceived write fIsReceived;
   property MinDelayTime:integer read  fMinDelayTime;
   property DelayTimeStep:integer read  fDelayTimeStep;
   property DelayTimeMax:integer read  fDelayTimeMax;
   property MeasureModeLabel:string read MeasureModeLabelRead;
   property Diapazon:Shortint read fDiapazon;
   Constructor Create(CP:TComPort;Nm:string);//override;
   Procedure ConvertToValue();virtual;
//   Function ResultProblem(Rez:double):boolean;virtual;
   Procedure Request();virtual;
   function GetData():double;virtual;
   procedure MeasurementBegin;
   procedure GetDataThread(WPARAM: word;EventEnd:THandle);virtual;
  end;


// TRS232MeterComplexDevice=class(TInterfacedObject,IMeasurement)
//  {базовий клас для вимірювальних об'єктів,
//  які використовують обмін даних з COM-портом}
//   procedure ConvertAction;
//  protected
//   fMeasureMode:Shortint;
//   fDiapazon:Shortint;
//   fMeasureModeAll:array of string;
//   fDiapazonAll:array of array of string;
//   fRS232Meter:TRS232Meter;
//   Procedure MModeDetermination(Data:array of byte); virtual;abstract;
//   Procedure DiapazonDetermination(Data:array of byte);virtual;abstract;
//   Procedure ValueDetermination(Data:array of byte);virtual;abstract;
//   Function MeasureModeLabelRead():string;virtual;abstract;
//  public
//   property MeasureModeLabel:string read MeasureModeLabelRead;
//   property Diapazon:Shortint read fDiapazon;
//   property RS232Meter:TRS232Meter read fRS232Meter implements IMeasurement;
//   Constructor Create(RS232Meter:TRS232Meter);
//  end;



//TRS232Setter=class(TRS232Device,IDAC)
// private
//
// protected
//  fOutputValue:double;
//  function GetOutputValue:double;
// public
//   property OutputValue:double read GetOutputValue;
//   procedure Output(Value:double);virtual;
//   procedure OutputInt(Kod:integer); virtual;
//   Procedure Reset();     virtual;
// end;


TAdapterRadioGroupClick=class
    findexx:integer;
    Constructor Create(ind:integer);overload;
    procedure RadioGroupClick(Sender: TObject);
    procedure RadioGroupOnEnter(Sender: TObject);
  end;


TRS232MetterShow=class(TMeasurementShow)
  protected
   RS232Meter:TRS232Meter;
   AdapterMeasureMode,AdapterRange:TAdapterRadioGroupClick;
   procedure DiapazonFill();
   procedure MeasureModeFill();
   function UnitModeLabel():string;override;

  public
   Constructor Create(Meter:TRS232Meter;
                      MM,R:TRadioGroup;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      TT:TTimer
                      );
   Procedure Free; override;
   procedure MetterDataShow();override;
end;


Function BCDtoDec(BCD:byte; isLow:boolean):byte;
{виділяє з ВCD, яке містить дві десяткові
цифри у двійково-десятковому представленні,
ці цифри;
якщо  isLow=true, то виділення із
молодшої частини байта}

Procedure PortBeginAction(Port:TComPort;Lab:TLabel;Button: TButton);

Procedure PortEndAction(Port:TComPort);




implementation

uses
  OlegType, Dialogs, SysUtils, Forms, Graphics, RS232_Meas_Tread, 
  HighResolutionTimer, OlegFunction;

{ TRS232Device }

constructor TRS232Device.Create;
begin
  inherited Create();
  fComPacket:=TComDataPacket.Create(fComPort);
  fComPacket.Size:=0;
  fComPacket.MaxBufferSize:=1024;
  fComPacket.IncludeStrings:=False;
  fComPacket.CaseInsensitive:=False;

  fisNeededComPort:=False;
  fError:=False;
end;

constructor TRS232Device.Create(CP: TComPort);
begin
 Create();
 fComPort:=CP;
 fComPacket.ComPort:=CP;
end;

procedure TRS232Device.ComPortUsing;
begin
  PacketCreateToSend();
  fError:=not(PacketIsSend(fComPort,fMessageError));
end;

constructor TRS232Device.Create(CP: TComPort; Nm: string);
begin
 Create(CP);
 fName:=Nm;
 fMessageError:=fName+ErrorMes;
end;

procedure TRS232Device.Free;
begin
// HelpForMe(Name);
 fComPacket.Free;
end;


procedure TRS232Device.isNeededComPortState;
begin
 fisNeededComPort:=(WaitForSingleObject(EventComPortFree,1000)=WAIT_OBJECT_0);
end;

procedure TRS232Device.PacketCreateToSend;
begin

end;

function TRS232Device.PortConnected: boolean;
begin
 if fComPort.Connected then  Result:=True
                       else
        begin
          Result:=False;
          fError:=True;
          showmessage('Port is not connected');
        end;
end;

{ TRS232Meter }

procedure TRS232Meter.ConvertToValue();
begin
  MModeDetermination(fData);
  if fMeasureMode=-1 then Exit;
  DiapazonDetermination(fData);
  if fDiapazon=-1 then  Exit;

  ValueDetermination(fData);
end;

constructor TRS232Meter.Create(CP:TComPort;Nm:string);
begin
  inherited Create(CP,Nm);
  fComPacket.OnPacket:=PacketReceiving;

//  fIsReady:=False;
  fIsReceived:=False;
  fMinDelayTime:=0;
  fDelayTimeStep:=10;
  fDelayTimeMax:=130;
  fMeasureMode:=-1;
  fDiapazon:=-1;
  fValue:=ErResult;
  fNewData:=False;
  fError:=False;
  RepeatInErrorCase:=False;
end;


procedure TRS232Meter.DiapazonDetermination(Data: array of byte);
begin

end;


function TRS232Meter.GetData: double;
begin
  Result:=ErResult;
  if PortConnected then
   begin
    Result:=Measurement();
    fNewData:=True;
   end;
end;

procedure TRS232Meter.GetDataThread(WPARAM: word;EventEnd:THandle);
begin
 if PortConnected then
   fRS232MeasuringTread:=TRS232MeasuringTread.Create(Self,WPARAM,EventEnd);
end;

procedure TRS232Meter.MeasurementBegin;
begin
//  fIsReady := False;
  fIsReceived:=False;
  fError:=False;
end;

function TRS232Meter.GetNewData: boolean;
begin
 Result:=fNewData;
end;

function TRS232Meter.GetValue: double;
begin
 Result:=fValue;
end;

function TRS232Meter.Measurement: double;
label start;
var i:integer;
    isFirst:boolean;
begin
//   HelpForMe(inttostr(MilliSecond)+ByteArrayToString(fData));
// Result:=ErResult;
 fValue:=ErResult;
 isFirst:=True;
start:
  MeasurementBegin;
  Request();


 sleep(fMinDelayTime);
 i:=0;
while  not(((i>fDelayTimeMax)or(fIsReceived)or(fError))) do
begin
   sleep(fDelayTimeStep);
   inc(i);
 Application.ProcessMessages;
end;
// repeat
//   sleep(fDelayTimeStep);
//   inc(i);
// Application.ProcessMessages;
// until ((i>fDelayTimeMax)or(fIsReceived)or(fError));

// showmessage(inttostr((GetTickCount-i0)));

//ShowData(fData);


 if fIsReceived then ConvertToValue();
// if fIsReady then
 Result:=fValue;

// if ((Result=ErResult)or(ResultProblem(Result)))and(isFirst) then
 if (RepeatInErrorCase) and (Result=ErResult)and(isFirst) then
    begin
      isFirst:=false;
      goto start;
    end;
end;

function TRS232Meter.MeasureModeLabelRead: string;
begin
 Result:='';
end;


procedure TRS232Meter.MModeDetermination(Data: array of byte);
begin

end;

procedure TRS232Meter.PacketReceiving(Sender: TObject; const Str: string);
begin

end;

procedure TRS232Meter.Request;
begin
  isNeededComPortState();
end;


procedure TRS232Meter.SetNewData(Value: boolean);
begin
 fNewData:=Value;
end;

procedure TRS232Meter.ValueDetermination(Data: array of byte);
begin

end;

//******************************************************

//{ TRS232MeterVoltmeter }
//
//procedure TRS232MeterVoltmeter.ConvertToValue();
//begin
//  MModeDetermination(fData);
//  if fMeasureMode=-1 then Exit;
//  DiapazonDetermination(fData);
//  if fDiapazon=-1 then Exit;
//
//  ValueDetermination(fData);
//  fIsready:=True;
//end;
//
//procedure TRS232MeterVoltmeter.DiapazonDetermination(Data: array of byte);
//begin
//
//end;
//
//
//function TRS232MeterVoltmeter.MeasureModeLabelRead: string;
//begin
// Result:='';
//end;
//
//
//procedure TRS232MeterVoltmeter.MModeDetermination(Data: array of byte);
//begin
//
//end;
//
//procedure TRS232MeterVoltmeter.ValueDetermination(Data: array of byte);
//begin
//
//end;


procedure TRS232MetterShow.DiapazonFill;
begin
  Range.Items.Clear;
  if RS232Meter.fMeasureMode>-1
    then
      StringArrayToRadioGroup(RS232Meter.fDiapazonAll[RS232Meter.fMeasureMode],
                              Range);
  Range.Items.Add(Error);
  IndexToRadioGroup(RS232Meter.fDiapazon,Range);
end;

procedure TRS232MetterShow.Free;
begin
 AdapterMeasureMode.Free;
 AdapterRange.Free;

 inherited Free;
end;


procedure TRS232MetterShow.MeasureModeFill;
begin
    StringArrayToRadioGroup(RS232Meter.fMeasureModeAll,MeasureMode);
    MeasureMode.Items.Add(Error);
end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TRS232MetterShow.Create(Meter: TRS232Meter;
                                       MM, R: TRadioGroup;
                                       DL, UL: TLabel;
                                       MB: TButton;
                                       AB: TSpeedButton;
                                       TT: TTimer);
begin
   inherited Create(Meter, MM, R, DL, UL, MB, AB, TT);
   RS232Meter:=Meter;

   MeasureModeFill();
   IndexToRadioGroup(RS232Meter.fMeasureMode,MeasureMode);
   DiapazonFill();

   AdapterMeasureMode:=TAdapterRadioGroupClick.Create(MeasureMode.Items.Count-1);
   AdapterRange:=TAdapterRadioGroupClick.Create(Range.Items.Count-1);
   MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
   Range.OnClick:=AdapterRange.RadioGroupClick;
   MeasureMode.onEnter:=AdapterMeasureMode.RadioGroupOnEnter;
   Range.onEnter:=AdapterRange.RadioGroupOnEnter;
end;




procedure TRS232MetterShow.MetterDataShow;
begin
  MeasureMode.OnClick:=nil;
  Range.OnClick:=nil;

  IndexToRadioGroup(RS232Meter.fMeasureMode,MeasureMode);
  DiapazonFill();

  MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
  Range.OnClick:=AdapterRange.RadioGroupClick;

  inherited  MetterDataShow();
end;

function TRS232MetterShow.UnitModeLabel: string;
begin
 Result:=RS232Meter.MeasureModeLabel;
end;

{ TAdapterRadioGroupClick }

constructor TAdapterRadioGroupClick.Create(ind: integer);
begin
 inherited Create;
 findexx:=ind;
end;


procedure TAdapterRadioGroupClick.RadioGroupClick(Sender: TObject);
begin
 try
 (Sender as TRadioGroup).ItemIndex:=findexx;
 except
 end;
end;


procedure TAdapterRadioGroupClick.RadioGroupOnEnter(Sender: TObject);
begin
 try
  findexx:=(Sender as TRadioGroup).ItemIndex;
 except
 end;
end;

Function BCDtoDec(BCD:byte; isLow:boolean):byte;
{виділяє з ВCD, яке містить дві десяткові
цифри у двійково-десятковому представленні,
ці цифри;
якщо  isLow=true, то виділення із
молодшої частини байта}
begin
 if isLow then Result:=BCD and $0F
          else Result:= BCD Shr 4;
end;


Procedure PortBeginAction(Port:TComPort;Lab:TLabel;Button: TButton);
begin
  try
    Port.Open;
    Port.Open;
    Port.AbortAllAsync;
    Port.AbortAllAsync;
    Port.ClearBuffer(True, True);
    Port.ClearBuffer(True, True);
  finally
   if Port.Connected then
      begin
       Lab.Caption:='Port is open';
       Lab.Font.Color:=clBlue;
       if Button<>nil then Button.Caption:='To close'
      end
                           else
      begin
       Lab.Caption:='Port is close';
       Lab.Font.Color:=clRed;
       if Button<>nil then Button.Caption:='To open'
      end
  end;


end;

Procedure PortEndAction(Port:TComPort);
begin
   try
  if Port.Connected then
   begin
    Port.AbortAllAsync;
    Port.ClearBuffer(True, True);
    Port.Close;
   end;
 finally
 end;
end;

{ TRS232Setter }

//function TRS232Setter.GetOutputValue: double;
//begin
// Result:=fOutputValue;
//end;
//
//procedure TRS232Setter.Output(Value: double);
//begin
// if Value<>ErResult then
//      fOutputValue:=Value;
//end;
//
//procedure TRS232Setter.OutputInt(Kod: integer);
//begin
//  fOutputValue:=Kod;
//end;
//
//procedure TRS232Setter.Reset;
//begin
// Output(0);
//end;




//{ TRS232MeterComplexDevice }
//
//procedure TRS232MeterComplexDevice.ConvertAction;
//begin
//  fRS232Meter.fValue:=ErResult;
//  MModeDetermination(fRS232Meter.fData);
//  if fMeasureMode=-1 then Exit;
//  DiapazonDetermination(fRS232Meter.fData);
//  if fDiapazon=-1 then Exit;
//
//  ValueDetermination(fRS232Meter.fData);
//end;
//
//constructor TRS232MeterComplexDevice.Create(RS232Meter: TRS232Meter);
//begin
// fRS232Meter:=RS232Meter;
//// fRS232Meter.ConvertToValue:=ConvertAction;
//end;

{ TRS232MeterConvertData }

procedure TRS232MeterConvertData.ConvertToValue;
begin
 fRS232ConvertData.Value:=ErResult;
end;

constructor TRS232MeterConvertData.Create(RS232ConvertData:TRS232ConvertData);
begin
 inherited Create;
 fRS232ConvertData:=RS232ConvertData;
 fDiapazon:=-1;
end;

function TRS232MeterConvertData.GetDiapazon: Shortint;
begin
 Result:=fDiapazon;
end;

function TRS232MeterConvertData.MeasureModeLabelRead: string;
begin
 Result:='';
end;

{ TComplexDeviceConvertData }

procedure TComplexDeviceConvertData.ConvertToValue;
begin
  fRS232MeterConvertData.ConvertToValue();
  fRS232ConvertData.fValue:=ErResult;
  MModeDetermination(fRS232ConvertData.fData);
  if fMeasureMode=-1 then Exit;
  DiapazonDetermination(fRS232ConvertData.fData);
  if fDiapazon=-1 then Exit;

  ValueDetermination(fRS232ConvertData.fData);
end;

constructor TComplexDeviceConvertData.Create(
  RS232MeterConvertData: TRS232MeterConvertData);
begin
  fRS232MeterConvertData:=RS232MeterConvertData;
  fRS232ConvertData:=RS232MeterConvertData.fRS232ConvertData;
  fMeasureMode:=-1;
  fDiapazon:=-1;
end;

function TComplexDeviceConvertData.MeasureModeLabelRead: string;
begin
 Result:=fRS232MeterConvertData.MeasureModeLabelRead();
end;

{ TRS232ConvertData }

function TRS232ConvertData.GetValue: double;
begin
 Result:=fValue;
end;


initialization
  EventComPortFree := CreateEvent(nil,
                                 True, // тип сброса TRUE - ручной
                                 True, // начальное состояние TRUE - сигнальное
                                 nil);
  EventMeasuringEnd := CreateEvent(nil,
                                 True, // тип сброса TRUE - ручной
                                 True, // начальное состояние TRUE - сигнальное
                                 nil);


finalization

  SetEvent(EventComPortFree);
  CloseHandle(EventComPortFree);


  SetEvent(EventMeasuringEnd);
  CloseHandle(EventMeasuringEnd);
end.
