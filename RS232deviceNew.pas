unit RS232deviceNew;

interface

uses
  PacketParameters, CPort, OlegTypePart2, Measurement,
  Classes, ExtCtrls,
  StdCtrls, Buttons;


const
 ErrorL='Error';
 IA_Label='~I';
 ID_Label='=I';
 UA_Label='~U';
 UD_Label='=U';
 ErrorMes=' connection is unsuccessful';

var
    EventComPortFree: THandle;
    EventMeasuringEnd: THandle;

type

//  http://www.sql.ru/forum/681753/delegirovanie-realizacii-metodov-interfeysa-drugomu-klassu

IDataObserver = interface
  ['{0DC1F3EC-1356-45CE-96F7-7287DB006F1B}']
  procedure UpDate ();
end;


IDataSubject = interface
  ['{0C822EBE-BD63-4E40-8D8D-A20615DC2FE6}']
  procedure NotifyObservers;
  function PortConnected():boolean;
end;

IDataSubjectSingle = interface //(IRS232DataSubject)
  ['{0C822EBE-BD63-4E40-8D8D-A20615DC2FE6}']
  procedure RegisterObserver(o:IDataObserver);
  procedure RemoveObserver(o:IDataObserver);
end;


TRS232=class
  {початкові налаштування COM-порту}
  protected
   fComPort:TComPort;
   fComPacket: TComDataPacket;
  public
   property ComPort:TComPort read fComPort;
   property ComPacket:TComDataPacket read fComPacket;
   Constructor Create(CP:TComPort; StartString,StopString:string);
//   Procedure Free;//virtual;
   destructor Destroy;override;
   Function IsSend(report:string):boolean;
  end;


TDataSubjectBase=class(TNamedInterfacedObject)
 protected
  fReceivedString:string;
  function PortConnected():boolean;virtual;abstract;
 public
  property ReceivedString:string read fReceivedString;
  procedure NotifyObservers;virtual;abstract;
end;


TDataSubjectSingle=class(TDataSubjectBase,IDataSubjectSingle,IDataSubject)
 protected
  fObserver:pointer;
  function GetObserver:IDataObserver;
 public
  property Observer:IDataObserver read GetObserver;
  procedure RegisterObserver(o:IDataObserver);
  procedure RemoveObserver(o:IDataObserver);
  procedure NotifyObservers;override;
end;


TRS232DataSubjectBase=class(TDataSubjectBase)
 protected
  fRS232:TRS232;
  procedure ComPortCreare(CP:TComPort);virtual;abstract;
  Procedure PacketReceiving(Sender: TObject; const Str: string);
  function PortConnected():boolean;override;
 public
  property RS232:TRS232 read fRS232;
  Constructor Create(CP:TComPort);
  destructor Destroy;override;
end;



TRS232DataSubjectSingle=class(TRS232DataSubjectBase,IDataSubjectSingle,IDataSubject)
 protected
  fObserver:pointer;
  function GetObserver:IDataObserver;
 public
  property Observer:IDataObserver read GetObserver;
  Constructor Create(CP:TComPort);
  procedure RegisterObserver(o:IDataObserver);
  procedure RemoveObserver(o:IDataObserver);
  procedure NotifyObservers;override;
end;

TCustomDevice=class(TNamedInterfacedObject)
  {базовий клас для пристроїв, які керуються
  віддалено}
  protected
   fError:boolean;
   fMessageError:string;
   fData:TArrByte;
   function GetMessageError:string;virtual;
   procedure SetError(const Value:boolean);
   procedure SetMessageError(const Value:string);
   function GetDataI(Index: Integer): Byte;
   procedure SetData(Index: integer; Value: byte);
   function  GetHighDataIndex:integer;
   procedure SetHighDataIndex(Value:integer);
  public
   property Data[Index: Integer]:byte read GetDataI write SetData;
   property HighDataIndex:integer read GetHighDataIndex write SetHighDataIndex;
   property Error:boolean read fError write SetError;
   property MessageError:string read GetMessageError write SetMessageError;
   Constructor Create(Nm:string);
   procedure AddData(NewData:array of byte);overload;
   procedure AddData(NewByte:byte);overload;
   procedure CopyToData(NewData:array of byte);
  end;

TMeterDevice=class(TCustomDevice,IMeasurement,IDataObserver)
//  {базовий клас для вимірювальних об'єктів, які керуються
//  віддалено}
  protected
   fIDataSubject:pointer;
   fValue:double;
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
   fRS232MeasuringTread:TThread;
   fNewData:boolean;
   function GetNewData:boolean;
   function GetDeviceKod:byte;virtual;
   Function Measurement():double;virtual;
   Function GetValue():double;virtual;
   procedure SetNewData(Value:boolean);
   procedure UpDate ();virtual;
   function GetDataSubject:IDataSubject;
   procedure SetDataSubject(const Value: IDataSubject);
  public
   RepeatInErrorCase:boolean;
   property DataSubject:IDataSubject read GetDataSubject
                                                write SetDataSubject;
   property NewData:boolean read GetNewData write SetNewData;
   property Value:double read GetValue write fValue;
   property isReceived:boolean read fIsReceived write fIsReceived;
   property MinDelayTime:integer read  fMinDelayTime;
   property DelayTimeStep:integer read  fDelayTimeStep write fDelayTimeStep;
   property DelayTimeMax:integer read  fDelayTimeMax;
   property DeviceKod:byte read GetDeviceKod;
   Constructor Create(Nm:string);
   Procedure Request();virtual;abstract;
   function GetData():double;virtual;
   procedure MeasurementBegin;
   procedure GetDataThread(WPARAM: word;EventEnd:THandle);virtual;
   procedure JoinToStringToSend(AdditionalString:string);virtual;
   procedure ClearStringToSend;virtual;
   Procedure SetStringToSend(StringToSend:string);virtual;
  end;

//TRS232MeterDevice=class(TMeterDevice,IMeasurement,IDataObserver)
////  {базовий клас для вимірювальних об'єктів,
////  які використовують обмін даних з COM-портом}
//  protected
////   fIDataSubject:pointer;
////   fValue:double;
////   fIsReceived:boolean;
////   fMinDelayTime:integer;
////  {інтервал очікування перед початком перевірки
////  вхідного буфера, []=мс, за замовчуванням 0}
////   fDelayTimeStep:integer;
////   {проміжок часу, через який перевіряється
////   надходження даних, []=мс, за замовчуванням 10}
////   fDelayTimeMax:integer;
////   {максимальна кількість перевірок
////   надходження даних, []=штук, за замовчуванням 130,
////   тобто за замовчуванням інтервал очікуввання
////   складає 0+10*130=1300 мс}
////   fRS232MeasuringTread:TThread;
////   fNewData:boolean;
////   function GetNewData:boolean;
////   function GetDeviceKod:byte;virtual;
////   Function Measurement():double;virtual;
////   Function GetValue():double;virtual;
////   procedure SetNewData(Value:boolean);
////   procedure UpDate ();virtual;
////   function GetDataSubject:IDataSubject;
////   procedure SetDataSubject(Value:IDataSubject);
//  public
////   RepeatInErrorCase:boolean;
////   property DataSubject:IDataSubject read GetDataSubject
////                                                write SetDataSubject;
////   property NewData:boolean read GetNewData write SetNewData;
////   property Value:double read GetValue write fValue;
////   property isReceived:boolean read fIsReceived write fIsReceived;
////   property MinDelayTime:integer read  fMinDelayTime;
////   property DelayTimeStep:integer read  fDelayTimeStep;
////   property DelayTimeMax:integer read  fDelayTimeMax;
//   property DeviceKod:byte read GetDeviceKod;
////   Constructor Create(Nm:string);
////   Procedure Request();virtual;abstract;
////   function GetData():double;virtual;
////   procedure MeasurementBegin;
////   procedure GetDataThread(WPARAM: word;EventEnd:THandle);virtual;
//  end;


TDataRequestNew=class(TInterfacedObject)
  protected
   fCustomDevice:TCustomDevice;
   procedure PreparePort;virtual;
   function IsNoSuccessSend:Boolean;virtual;
   function Connected:boolean;virtual;abstract;
  public
   Constructor Create(CustomDevice:TCustomDevice);
   procedure Request;virtual;
end;

//TCDDataRequest=class(TInterfacedObject{,IRS232DataRequest})
TCDDataRequest=class(TDataRequestNew{,IRS232DataRequest})
  protected
   fRS232:TRS232;
//   fCustomDevice:TCustomDevice;
   procedure PreparePort;override;
//   function IsNoSuccessSend:Boolean;virtual;
   function Connected:boolean;override;
  public
   Constructor Create(ComPort:TRS232;CustomDevice:TCustomDevice);
//   procedure Request;virtual;
end;

TRS232MeterDeviceSingle=class(TMeterDevice)
{вимірювальний пристрій єдиний для СОМ-порту}
 protected
  fDataSubject:TRS232DataSubjectSingle;
  fDataRequest:TCDDataRequest;
  procedure CreateDataSubject(CP:TComPort);virtual;abstract;
  procedure CreateDataRequest;virtual;abstract;
 public
  Constructor Create(CP:TComPort;Nm:string);
//  procedure Free;
  destructor Destroy;override;
  Procedure Request();override;
end;

TComplexDeviceDataConverter=class(TInterfacedObject)
  protected
   fMD:TMeterDevice;
   fMeasureMode:Shortint;
   fDiapazon:Shortint;
   fMeasureModeAll:array of string;
   fDiapazonAll:array of array of string;
   Procedure MModeDetermination(); virtual;abstract;
   Procedure DiapazonDetermination(); virtual;abstract;
   Procedure ValueDetermination();virtual;abstract;
   Function MeasureModeLabelRead():string;virtual;
  public
   property MeasureModeLabel:string read MeasureModeLabelRead;
//   property Diapazon:Shortint read fDiapazon;
   procedure DataConvert();
   Constructor Create(MD:TMeterDevice);
end;



TAdapterRadioGroupClick=class
    findexx:integer;
    Constructor Create(ind:integer);overload;
    procedure RadioGroupClick(Sender: TObject);
    procedure RadioGroupOnEnter(Sender: TObject);
  end;


TRS232MetterShow=class(TMeasurementShow)
  protected
   RS232Meter:TMeterDevice;
   DeviceDataConverter:TComplexDeviceDataConverter;
   AdapterMeasureMode,AdapterRange:TAdapterRadioGroupClick;
   procedure DiapazonFill();
   procedure MeasureModeFill();
   function UnitModeLabel():string;override;
  public
   Constructor Create(Meter:TMeterDevice;
                      DDataConverter:TComplexDeviceDataConverter;
                      MM,R:TRadioGroup;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      TT:TTimer
                      );
//   Procedure Free;
   destructor Destroy;override;
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

Procedure EnableComPort(Ports:TStringList);

Procedure EnableComPortShow();

procedure StringListShow(StrL:TStringList);


var
 TestShowRS232,DeviceRS232isAbsent:boolean;
 ComPorts:TStringList;

implementation

uses
  OlegType, Dialogs, RS232_Meas_Tread, Windows, Forms, Graphics, SysUtils,
  OlegFunction;

//procedure TRS232MeterDevice.DiapazonDetermination();
//begin
//
//end;


//constructor TRS232MeterDevice.Create(Nm: string);
//begin
// inherited Create(Nm);
//
//  fIsReceived:=False;
//  fMinDelayTime:=0;
//  fDelayTimeStep:=10;
//  fDelayTimeMax:=130;
//  fValue:=ErResult;
//  fNewData:=False;
//  fError:=False;
//  RepeatInErrorCase:=False;
//end;

//function TRS232MeterDevice.GetData: double;
//begin
//  Result:=ErResult;
//
//  if DataSubject.PortConnected then
//   begin
//    Result:=Measurement();
//    fNewData:=True;
//   end
//                                      else
//   begin
//     fError:=True;
//     showmessage(fMessageError);
//   end;
//end;

//procedure TRS232MeterDevice.GetDataThread(WPARAM: word;EventEnd:THandle);
//begin
// if DataSubject.PortConnected then
//   fRS232MeasuringTread:=TRS232MeasuringTread.Create(Self,WPARAM,EventEnd);
//end;


//function TRS232MeterDevice.GetDeviceKod: byte;
//begin
// Result:=0;
//end;

//function TRS232MeterDevice.GetDataSubject:IDataSubject;
//begin
// Result:=IDataSubject(fIDataSubject);
//end;

//procedure TRS232MeterDevice.MeasurementBegin;
//begin
//  fIsReceived:=False;
//  fError:=False;
//end;


//function TRS232MeterDevice.GetNewData: boolean;
//begin
// Result:=fNewData;
//end;

//function TRS232MeterDevice.GetValue: double;
//begin
// Result:=fValue;
//end;

//function TRS232MeterDevice.Measurement: double;
//label start;
//var i:integer;
//    isFirst:boolean;
//begin
// fValue:=ErResult;
// isFirst:=True;
//start:
//  MeasurementBegin;
//  Request();
//
//
// sleep(fMinDelayTime);
// i:=0;
//while  not(((i>fDelayTimeMax)or(fIsReceived)or(fError))) do
//begin
//   sleep(fDelayTimeStep);
//   inc(i);
// Application.ProcessMessages;
//end;
//// repeat
////   sleep(fDelayTimeStep);
////   inc(i);
//// Application.ProcessMessages;
//// until ((i>fDelayTimeMax)or(fIsReceived)or(fError));
//
//// showmessage(inttostr((GetTickCount-i0)));
//
////ShowData(fData);
//
//
// Result:=fValue;
//
// if (RepeatInErrorCase) and (Result=ErResult)and(isFirst) then
//    begin
//      isFirst:=false;
//      goto start;
//    end;
//end;

//function TRS232MeterDevice.MeasureModeLabelRead: string;
//begin
// Result:='';
//end;


//procedure TRS232MeterDevice.MModeDetermination();
//begin
//
//end;


//procedure TRS232MeterDevice.SetDataSubject(Value: IDataSubject);
//begin
//  fIDataSubject:=pointer(Value);
//end;

//procedure TRS232MeterDevice.SetNewData(Value: boolean);
//begin
// fNewData:=Value;
//end;

//
//procedure TRS232MeterDevice.UpDate();
//begin
// fIsReceived:=True;
//end;

//procedure TRS232MeterDevice.ValueDetermination();
//begin
//
//end;


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
// showmessage('!!!'+Port.Name);
  if ComPorts.IndexOf(Port.Port)=-1
    then
    begin
//      showmessage('Port '+Port.Port+' is absent');
      Exit;
    end;


  try
  try
    Port.Open;
    Port.Open;
    Port.AbortAllAsync;
    Port.AbortAllAsync;
    Port.ClearBuffer(True, True);
    Port.ClearBuffer(True, True);
  except
    showmessage('Port '+Port.Name+' is absent');
  end;
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
  if ComPorts.IndexOf(Port.Port)=-1
    then Exit;

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

Procedure EnableComPort(Ports:TStringList);
var
  I: Integer;
  PortName:string;
  PortHandle:THandle;
  temp:TStringList;
begin
//  temp:=TStringList.Create;
//  try
//    // Використовуємо цикл для перевірки портів в діапазоні від COM1 до COM256
//    for I := 1 to 256 do
//    begin
//      // Створюємо ім'я порту у відповідності до діапазону
//      // Наприклад, "COM1", "COM2" і т. д.
//      PortName := 'COM' + IntToStr(I);
//
//      // Відкриваємо порт з правом читання та запису
//      PortHandle := CreateFile(PChar('\\.\' + PortName), GENERIC_READ or GENERIC_WRITE,
//        0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
//
//      if PortHandle <> INVALID_HANDLE_VALUE then
//      begin
//        showmessage(PortName);
//        temp.Add(PortName);
//        CloseHandle(PortHandle);
//      end;
//    end;
//  except
////     Якщо сталася помилка, звільнимо пам'ять і повернемо порожній список
//    temp.Free;
//    temp := TStringList.Create;
//  end;
//  Ports.Assign(temp);
  EnumComPorts(Ports);
end;


Procedure EnableComPortShow();
var
  PortList: TStringList;
begin
  PortList := TStringList.Create;
  EnableComPort(PortList);
  StringListShow(PortList);
  PortList.Free;
end;

procedure StringListShow(StrL:TStringList);
 var temp:string;
   i:integer;
begin
 temp:='';
 if StrL.Count>0
   then
     for I := 0 to StrL.Count-1 do
       temp:=temp+ StrL[i]+#10
   else
    temp:='is empty';
 showmessage(temp);
end;

{ TRS232 }

constructor TRS232.Create(CP: TComPort; StartString, StopString: string);
begin
  inherited Create();
  fComPacket:=TComDataPacket.Create(fComPort);
  fComPacket.Size:=0;
  fComPacket.MaxBufferSize:=1024;
  fComPacket.IncludeStrings:=False;
  fComPacket.CaseInsensitive:=False;
  fComPort:=CP;
  fComPacket.ComPort:=CP;
  fComPacket.StartString:=StartString;
  fComPacket.StopString:=StopString;
end;

//procedure TRS232.Free;
//begin
//  fComPacket.Free;
//end;

destructor TRS232.Destroy;
begin
  fComPacket.Free;
  inherited;
end;

function TRS232.IsSend(report: string): boolean;
begin
 Result:=PacketIsSend(fComPort,report);
end;


{ TRS232DataSubject }

constructor TRS232DataSubjectSingle.Create(CP: TComPort);
begin
  inherited Create(CP);
  fObserver:=nil;
end;


function TRS232DataSubjectSingle.GetObserver: IDataObserver;
begin
 if fObserver=nil then Result:=nil
                  else Result:=IDataObserver(fObserver);
end;

procedure TRS232DataSubjectSingle.NotifyObservers;
begin
//  if  fObserver<>nil then fObserver.UpDate();
  if  Observer<>nil then Observer.UpDate();
end;

procedure TRS232DataSubjectSingle.RegisterObserver(o: IDataObserver);
begin
  fObserver:=pointer(o);
//  fObserver:=o;
end;

procedure TRS232DataSubjectSingle.RemoveObserver(o: IDataObserver);
begin
 fObserver:=nil;
end;

{ TRS232CustomDevice }

procedure TCustomDevice.AddData(NewData: array of byte);
 var i,j:integer;
begin
 j:=High(fData)+1;
 SetLength(fData,j+High(NewData)+1);
 for I := 0 to High(NewData) do
  fData[i+j]:= NewData [i];
end;

procedure TCustomDevice.AddData(NewByte: byte);
begin
 AddData([NewByte]);
end;

constructor TCustomDevice.Create(Nm: string);
begin
 fName:=Nm;
 fMessageError:=fName+ErrorMes;
end;

procedure TCustomDevice.CopyToData(NewData: array of byte);
 var i:integer;
begin
 SetLength(fData,High(NewData)+1);
 for I := 0 to High(NewData) do
  fData[i]:= NewData [i];
end;

function TCustomDevice.GetDataI(Index: Integer): byte;
begin
  Result:=fData[Index];
end;

function TCustomDevice.GetHighDataIndex: integer;
begin
 Result:=High(fData);
end;

function TCustomDevice.GetMessageError: string;
begin
 Result:=fMessageError;
end;

procedure TCustomDevice.SetData(Index: integer; Value:byte);
begin
  if Index<=High(fData)
   then  fData[Index]:=Value;
end;

procedure TCustomDevice.SetError(const Value: boolean);
begin
 fError:=Value;
end;

procedure TCustomDevice.SetHighDataIndex(Value: integer);
begin
 SetLength(fData,Value+1);
end;

procedure TCustomDevice.SetMessageError(const Value: string);
begin
 fMessageError:=Value;
end;

{ TRS232MeterDeviceSingle }

constructor TRS232MeterDeviceSingle.Create(CP: TComPort; Nm: string);
begin
  CreateDataSubject(CP);
  inherited Create(Nm);
  Self.DataSubject:=fDataSubject;
  fDataSubject.RegisterObserver(Self);
  CreateDataRequest;
end;

//procedure TRS232MeterDeviceSingle.Free;
//begin
//  fDataRequest.Free;
//  fDataSubject.Free;
//  inherited Free;
//end;


destructor TRS232MeterDeviceSingle.Destroy;
begin
  fDataRequest.Free;
  fDataSubject.Free;
  inherited;
end;

procedure TRS232MeterDeviceSingle.Request;
begin
 fDataRequest.Request;
end;

{ TComplexDeviceDataConverter }

constructor TComplexDeviceDataConverter.Create(MD: TMeterDevice);
begin
  fMD:=MD;
  fMeasureMode:=-1;
  fDiapazon:=-1;
end;

procedure TComplexDeviceDataConverter.DataConvert();
begin
//  with fMD do
//  begin
  MModeDetermination();
  if fMeasureMode=-1 then Exit;
  DiapazonDetermination();
  if fDiapazon=-1 then  Exit;
  ValueDetermination();
//  end;
end;

function TComplexDeviceDataConverter.MeasureModeLabelRead: string;
begin
 Result:='';
end;

{ TRS232MetterShowNew }

constructor TRS232MetterShow.Create(Meter: TMeterDevice;
                                    DDataConverter:TComplexDeviceDataConverter;
                                       MM, R: TRadioGroup;
                                       DL, UL: TLabel;
                                       MB: TButton;
                                       AB: TSpeedButton;
                                       TT: TTimer);
begin
   inherited Create(Meter, MM, R, DL, UL, MB, AB, TT);
   RS232Meter:=Meter;
   DeviceDataConverter:=DDataConverter;
   MeasureModeFill();
//   IndexToRadioGroup(RS232Meter.fMeasureMode,MeasureMode);
   IndexToRadioGroup(DeviceDataConverter.fMeasureMode,MeasureMode);
   DiapazonFill();

   AdapterMeasureMode:=TAdapterRadioGroupClick.Create(MeasureMode.Items.Count-1);
   AdapterRange:=TAdapterRadioGroupClick.Create(Range.Items.Count-1);
   MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
   Range.OnClick:=AdapterRange.RadioGroupClick;
   MeasureMode.onEnter:=AdapterMeasureMode.RadioGroupOnEnter;
   Range.onEnter:=AdapterRange.RadioGroupOnEnter;
end;


destructor TRS232MetterShow.Destroy;
begin
 AdapterMeasureMode.Free;
 AdapterRange.Free;
 inherited;
end;

procedure TRS232MetterShow.DiapazonFill;
begin
  Range.Items.Clear;
//  if RS232Meter.fMeasureMode>-1
  if DeviceDataConverter.fMeasureMode>-1
    then
//      StringArrayToRadioGroup(RS232Meter.fDiapazonAll[RS232Meter.fMeasureMode],
//                              Range);
      StringArrayToRadioGroup(DeviceDataConverter.fDiapazonAll[DeviceDataConverter.fMeasureMode],
                              Range);
  Range.Items.Add(ErrorL);
//  IndexToRadioGroup(RS232Meter.fDiapazon,Range);
  IndexToRadioGroup(DeviceDataConverter.fDiapazon,Range);
end;

//procedure TRS232MetterShowNew.Free;
//begin
// AdapterMeasureMode.Free;
// AdapterRange.Free;
// inherited Free;
//end;

procedure TRS232MetterShow.MeasureModeFill;
begin
//    StringArrayToRadioGroup(RS232Meter.fMeasureModeAll,MeasureMode);
    StringArrayToRadioGroup(DeviceDataConverter.fMeasureModeAll,MeasureMode);
    MeasureMode.Items.Add(ErrorL);
end;

function TRS232MetterShow.UnitModeLabel: string;
begin
// Result:=RS232Meter.MeasureModeLabel;
 Result:=DeviceDataConverter.MeasureModeLabel;
end;

procedure TRS232MetterShow.MetterDataShow;
begin
  MeasureMode.OnClick:=nil;
  Range.OnClick:=nil;

//  IndexToRadioGroup(RS232Meter.fMeasureMode,MeasureMode);
  IndexToRadioGroup(DeviceDataConverter.fMeasureMode,MeasureMode);
  DiapazonFill();

  MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
  Range.OnClick:=AdapterRange.RadioGroupClick;

  inherited  MetterDataShow();
end;



{ TCDDataRequest }

function TCDDataRequest.Connected: boolean;
begin
 Result:=fRS232.ComPort.Connected;
end;

constructor TCDDataRequest.Create(ComPort: TRS232;
                                CustomDevice: TCustomDevice);
begin
 inherited Create(CustomDevice);
 fRS232:=ComPort;
// fCustomDevice:=CustomDevice;
end;

//function TCDDataRequest.IsNoSuccessSend: Boolean;
//begin
// Result:=False;
//end;

procedure TCDDataRequest.PreparePort;
begin
  fRS232.ComPort.AbortAllAsync;
  fRS232.ComPort.ClearBuffer(True, True);
end;

//procedure TCDDataRequest.Request;
//begin
//  if fRS232.ComPort.Connected then
//    begin
//     PreparePort;
//     fCustomDevice.Error:=IsNoSuccessSend;
////     showmessage('False='+booltostr(False)+' :'+booltostr(fRS232CustomDevice.Error));
//    end
//                        else
//     fCustomDevice.Error:=True;
//end;

{ TRS232DataSubjectBase }

constructor TRS232DataSubjectBase.Create(CP: TComPort);
begin
  ComPortCreare(CP);
  fRS232.fComPacket.OnPacket:=PacketReceiving;
end;

//procedure TRS232DataSubjectBase.Free;
//begin
// fRS232.Free;
// inherited Free;
//end;

destructor TRS232DataSubjectBase.Destroy;
begin
 fRS232.Free;
 inherited;
end;

procedure TRS232DataSubjectBase.PacketReceiving(Sender: TObject;
                                            const Str: string);
begin
//  showmessage('Receiving');
  fReceivedString:=Str;
  NotifyObservers();
end;

function TRS232DataSubjectBase.PortConnected: boolean;
begin
 try
   Result:=fRS232.fComPort.Connected;
 except
   Result:=False;
 end;
end;

{ TDataSubjectSingle }

function TDataSubjectSingle.GetObserver: IDataObserver;
begin
 if fObserver=nil then Result:=nil
                  else Result:=IDataObserver(fObserver);
end;

procedure TDataSubjectSingle.NotifyObservers;
begin
  if  Observer<>nil then Observer.UpDate();
end;

procedure TDataSubjectSingle.RegisterObserver(o: IDataObserver);
begin
  fObserver:=pointer(o);
end;

procedure TDataSubjectSingle.RemoveObserver(o: IDataObserver);
begin
 fObserver:=nil;
end;

{ TMeterDevice }

procedure TMeterDevice.ClearStringToSend;
begin

end;

constructor TMeterDevice.Create(Nm: string);
begin
 inherited Create(Nm);

  fIsReceived:=False;
  fMinDelayTime:=0;
  fDelayTimeStep:=10;
  fDelayTimeMax:=130;
  fValue:=ErResult;
  fNewData:=False;
  fError:=False;
  RepeatInErrorCase:=False;
end;

function TMeterDevice.GetData: double;
begin
  Result:=ErResult;

  if DataSubject.PortConnected then
   begin
    Result:=Measurement();
    fNewData:=True;
   end
                                      else
   begin
     fError:=True;
     showmessage(MessageError);
   end;
end;

function TMeterDevice.GetDataSubject: IDataSubject;
begin
 Result:=IDataSubject(fIDataSubject);
end;

procedure TMeterDevice.GetDataThread(WPARAM: word; EventEnd: THandle);
begin
 if DataSubject.PortConnected then
   begin
   fRS232MeasuringTread:=TRS232MeasuringTread.Create(Self,WPARAM,EventEnd);

   end;
end;

function TMeterDevice.GetDeviceKod: byte;
begin
 Result:=0;
end;

function TMeterDevice.GetNewData: boolean;
begin
 Result:=fNewData;
end;

function TMeterDevice.GetValue: double;
begin
 Result:=fValue;
end;

procedure TMeterDevice.JoinToStringToSend(AdditionalString: string);
begin
end;

function TMeterDevice.Measurement: double;
label start;
var i:integer;
    isFirst:boolean;
begin
 fValue:=ErResult;
 isFirst:=True;
start:
  MeasurementBegin();
  Request();

//   showmessage(booltostr(fError,true));
 sleep(fMinDelayTime);
 i:=0;
while  not(((i>fDelayTimeMax)or(fIsReceived)or(fError))) do
begin
   sleep(fDelayTimeStep);
   inc(i);
 Application.ProcessMessages;
end;

//   showmessage(inttostr(i));
//  showmessage(booltostr(fError,true));
// showmessage(inttostr((GetTickCount-i0)));

//ShowData(fData);


 Result:=fValue;

 if (RepeatInErrorCase) and (Result=ErResult)and(isFirst) then
    begin
      isFirst:=false;
      goto start;
    end;

end;

procedure TMeterDevice.MeasurementBegin;
begin
  fIsReceived:=False;
  fError:=False;
end;

procedure TMeterDevice.SetDataSubject(const Value: IDataSubject);
begin
  fIDataSubject:=pointer(Value);
end;

procedure TMeterDevice.SetNewData(Value: boolean);
begin
  fNewData:=Value;
end;

procedure TMeterDevice.SetStringToSend(StringToSend: string);
begin
end;

procedure TMeterDevice.UpDate;
begin
 fIsReceived:=True;
end;

{ TDataRequestNew }

constructor TDataRequestNew.Create(CustomDevice: TCustomDevice);
begin
 fCustomDevice:=CustomDevice;
end;

function TDataRequestNew.IsNoSuccessSend: Boolean;
begin
 Result:=False;
end;

procedure TDataRequestNew.PreparePort;
begin
end;

procedure TDataRequestNew.Request;
begin
  if Connected() then
    begin
     PreparePort;
     fCustomDevice.Error:=IsNoSuccessSend();
//     showmessage('False='+booltostr(False)+' :'+booltostr(fRS232CustomDevice.Error));
    end
                        else
     fCustomDevice.Error:=True;
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

   ComPorts:=TStringList.Create;
   EnableComPort(ComPorts);
finalization

  SetEvent(EventComPortFree);
  CloseHandle(EventComPortFree);


  SetEvent(EventMeasuringEnd);
  CloseHandle(EventMeasuringEnd);

  FreeAndNil(ComPorts);
end.
