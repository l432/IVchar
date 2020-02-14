unit RS232deviceNew;

interface

uses
  PacketParameters, CPort, OlegTypePart2, Measurement, Classes, ExtCtrls, 
  StdCtrls, Buttons, RS232device;

//uses
//  Measurement, CPort, PacketParameters, ExtCtrls, StdCtrls, Buttons, Windows,
//  Classes,OlegTypePart2;
//
//
const
 ErrorL='Error';
// IA_Label='~I';
// ID_Label='=I';
// UA_Label='~U';
// UD_Label='=U';
 ErrorMesNew=' connection with ComPort is unsuccessful';
//
//var
//    EventComPortFree: THandle;
//    EventMeasuringEnd: THandle;

type

//  http://www.sql.ru/forum/681753/delegirovanie-realizacii-metodov-interfeysa-drugomu-klassu

IRS232DataObserver = interface
  ['{0DC1F3EC-1356-45CE-96F7-7287DB006F1B}']
//  function GetDeviceKod:byte;
//  property DeviceKod:byte read GetDeviceKod;
  procedure UpDate ();
end;


IRS232DataSubject = interface
  ['{0C822EBE-BD63-4E40-8D8D-A20615DC2FE6}']
//  procedure RegisterObserver(o:IRS232DataObserver);
//  procedure RemoveObserver(o:IRS232DataObserver);
  procedure NotifyObservers;
  function PortConnected():boolean;
end;

IRS232DataSubjectSingle = interface //(IRS232DataSubject)
  ['{0C822EBE-BD63-4E40-8D8D-A20615DC2FE6}']
  procedure RegisterObserver(o:IRS232DataObserver);
  procedure RemoveObserver(o:IRS232DataObserver);
//  procedure NotifyObservers;
//  function PortConnected():boolean;
end;

//IRS232DataConverter = interface
//  ['{33D47FFF-2FE4-41E4-8034-824CCD1FFE01}']
//  procedure DataConvert ();
//end;

//IRS232DataRequest = interface
//  ['{7F51C268-A9C2-475D-9D94-CF04DD226552}']
//  procedure Request;
//end;



TRS232=class
  {початкові налаштування COM-порту}
  protected
   fComPort:TComPort;
   fComPacket: TComDataPacket;
  public
   property ComPort:TComPort read fComPort;
   property ComPacket:TComDataPacket read fComPacket;
   Constructor Create(CP:TComPort; StartString,StopString:string);
   Procedure Free;//virtual;
   Function IsSend(report:string):boolean;
  end;


TRS232DataSubjectBase=class(TNamedInterfacedObject)
 protected
  fReceivedString:string;
  fRS232:TRS232;
  procedure ComPortCreare(CP:TComPort);virtual;abstract;
  Procedure PacketReceiving(Sender: TObject; const Str: string);
  function PortConnected():boolean;
 public
  property ReceivedString:string read fReceivedString;
  property RS232:TRS232 read fRS232;
  Constructor Create(CP:TComPort);
  Procedure Free;override;
//  procedure RegisterObserver(o:IRS232DataObserver);virtual;abstract;
//  procedure RemoveObserver(o:IRS232DataObserver);virtual;abstract;
  procedure NotifyObservers;virtual;abstract;
end;


TRS232DataSubjectSingle=class(TRS232DataSubjectBase,IRS232DataSubjectSingle,IRS232DataSubject)
 protected
  fObserver:IRS232DataObserver;
 public
  Constructor Create(CP:TComPort);
  procedure RegisterObserver(o:IRS232DataObserver);//override;
  procedure RemoveObserver(o:IRS232DataObserver);//override;
  procedure NotifyObservers;override;
end;

TRS232CustomDevice=class(TNamedInterfacedObject)
//  {базовий клас для пристроїв, які керуються
//  за допомогою COM-порту}
  protected
   fError:boolean;
   fMessageError:string;
//   fComPort:TComPort;
//   fComPacket: TComDataPacket;
   fData:TArrByte;
//   fisNeededComPort:boolean;
//   function PortConnected():boolean;
   function GetMessageError:string;
   procedure SetError(const Value:boolean);
   procedure SetMessageError(const Value:string);
  public
//   procedure  PacketCreateToSend(); virtual;
//   property isNeededComPort:boolean read fisNeededComPort write fisNeededComPort;
   property Error:boolean read fError write SetError;
   property MessageError:string read GetMessageError write SetMessageError;
   Constructor Create(Nm:string);
//   Constructor Create();overload;
//   Constructor Create(CP:TComPort);overload;
//   Constructor Create(CP:TComPort;Nm:string);overload;//virtual;
//   Procedure Free;override;//virtual;
//   procedure isNeededComPortState();
  end;


TRS232MeterDevice=class(TRS232CustomDevice,IMeasurement,IRS232DataObserver)
//  {базовий клас для вимірювальних об'єктів,
//  які використовують обмін даних з COM-портом}
  protected
   fIRS232DataSubject:IRS232DataSubject;
//   fRS232DataConverter:IRS232DataConverter;
//   fRS232DataRequest:IRS232DataRequest;
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
   fMeasureMode:Shortint;
   fDiapazon:Shortint;
   fMeasureModeAll:array of string;
   fDiapazonAll:array of array of string;
   fRS232MeasuringTread:TThread;
   fNewData:boolean;
   function GetNewData:boolean;
   Procedure MModeDetermination(); virtual;
   Procedure DiapazonDetermination(); virtual;
   Procedure ValueDetermination();virtual;
   Function MeasureModeLabelRead():string;virtual;
//   Procedure PacketReceiving(Sender: TObject; const Str: string);virtual;
   Function Measurement():double;virtual;
   Function GetValue():double;virtual;
   procedure SetNewData(Value:boolean);
   procedure UpDate ();virtual;
//   procedure DataTransform(const Str: string);virtual;
//   procedure CreateDataConverter;virtual;abstract;
//   procedure CreateDataRequest;virtual;abstract;
//   procedure FreeDataConverter;virtual;abstract;
//   procedure FreeDataRequest;virtual;abstract;
  public
   RepeatInErrorCase:boolean;
   property NewData:boolean read GetNewData write SetNewData;
   property Value:double read GetValue write fValue;
   property isReceived:boolean read fIsReceived write fIsReceived;
   property MinDelayTime:integer read  fMinDelayTime;
   property DelayTimeStep:integer read  fDelayTimeStep;
   property DelayTimeMax:integer read  fDelayTimeMax;
   property MeasureModeLabel:string read MeasureModeLabelRead;
   property Diapazon:Shortint read fDiapazon;
   Constructor Create(Nm:string);
//   Procedure ConvertToValue();virtual;
   Procedure Request();virtual;abstract;
   function GetData():double;virtual;
   procedure MeasurementBegin;
   procedure GetDataThread(WPARAM: word;EventEnd:THandle);virtual;
   procedure AddDataSubject(DataSubject:IRS232DataSubject);
//   procedure Free;override;
  end;


TCDDataRequest=class(TInterfacedObject{,IRS232DataRequest})
  protected
   fRS232:TRS232;
   fRS232CustomDevice:TRS232CustomDevice;
   procedure PreparePort;
   function IsNoSuccessSend:Boolean;virtual;
  public
   Constructor Create(ComPort:TRS232;CustomDevice:TRS232CustomDevice);
   procedure Request;virtual;
end;

TRS232MeterDeviceSingle=class(TRS232MeterDevice)
{вимірювальний пристрій єдиний для СОМ-порту}
 protected
  fDataSubject:TRS232DataSubjectSingle;
  fDataRequest:TCDDataRequest;
  procedure CreateDataSubject(CP:TComPort);virtual;abstract;
  procedure CreateDataRequest;virtual;abstract;
//  procedure FreeDataRequest;override;
 public
  Constructor Create(CP:TComPort;Nm:string);
  procedure Free;override;
  Procedure Request();override;
end;

TComplexDeviceDataConverter=class(TInterfacedObject{,IRS232DataConverter})
  private
   fMeterDevice:TRS232MeterDevice;
  public
   procedure DataConvert();
   Constructor Create(MD:TRS232MeterDevice);
end;




//
//TAdapterRadioGroupClick=class
//    findexx:integer;
//    Constructor Create(ind:integer);overload;
//    procedure RadioGroupClick(Sender: TObject);
//    procedure RadioGroupOnEnter(Sender: TObject);
//  end;
//

TRS232MetterShowNew=class(TMeasurementShow)
  protected
   RS232Meter:TRS232MeterDevice;
   AdapterMeasureMode,AdapterRange:TAdapterRadioGroupClick;
   procedure DiapazonFill();
   procedure MeasureModeFill();
   function UnitModeLabel():string;override;
  public
   Constructor Create(Meter:TRS232MeterDevice;
                      MM,R:TRadioGroup;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      TT:TTimer
                      );
   Procedure Free; override;
   procedure MetterDataShow();override;
end;
//
//
//Function BCDtoDec(BCD:byte; isLow:boolean):byte;
//{виділяє з ВCD, яке містить дві десяткові
//цифри у двійково-десятковому представленні,
//ці цифри;
//якщо  isLow=true, то виділення із
//молодшої частини байта}
//
//Procedure PortBeginAction(Port:TComPort;Lab:TLabel;Button: TButton);
//
//Procedure PortEndAction(Port:TComPort);
//
//
//

implementation

uses
  OlegType, Dialogs, RS232_Meas_Tread, Windows, Forms;

//uses
//  OlegType, Dialogs, SysUtils, Forms, Graphics, RS232_Meas_Tread,
//  HighResolutionTimer, OlegFunction;

//{ TRS232Device }
//
//constructor TRS232Device.Create;
//begin
//  inherited Create();
//  fComPacket:=TComDataPacket.Create(fComPort);
//  fComPacket.Size:=0;
//  fComPacket.MaxBufferSize:=1024;
//  fComPacket.IncludeStrings:=False;
//  fComPacket.CaseInsensitive:=False;
//
//  fisNeededComPort:=False;
//  fError:=False;
//end;
//
//constructor TRS232Device.Create(CP: TComPort);
//begin
// Create();
// fComPort:=CP;
// fComPacket.ComPort:=CP;
//end;
//
//
//constructor TRS232Device.Create(CP: TComPort; Nm: string);
//begin
// Create(CP);
// fName:=Nm;
// fMessageError:=fName+ErrorMes;
//end;
//
//procedure TRS232Device.Free;
//begin
//// HelpForMe(Name);
// fComPacket.Free;
//end;
//
//
//procedure TRS232Device.isNeededComPortState;
//begin
// fisNeededComPort:=(WaitForSingleObject(EventComPortFree,1000)=WAIT_OBJECT_0);
//end;
//
//procedure TRS232Device.PacketCreateToSend;
//begin
//
//end;
//
//function TRS232Device.PortConnected: boolean;
//begin
// if fComPort.Connected then  Result:=True
//                       else
//        begin
//          Result:=False;
//          fError:=True;
//          showmessage('Port is not connected');
//        end;
//end;
//
//{ TRS232Meter }
//
//procedure TRS232MeterDevice.ConvertToValue();
//begin
////  MModeDetermination(fData);
////  if fMeasureMode=-1 then Exit;
////  DiapazonDetermination(fData);
////  if fDiapazon=-1 then  Exit;
////
////  ValueDetermination(fData);
//end;

//constructor TRS232Meter.Create(CP:TComPort;Nm:string);
//begin
//  inherited Create(CP,Nm);
//  fComPacket.OnPacket:=PacketReceiving;
//
//  fIsReceived:=False;
//  fMinDelayTime:=0;
//  fDelayTimeStep:=10;
//  fDelayTimeMax:=130;
//  fMeasureMode:=-1;
//  fDiapazon:=-1;
//  fValue:=ErResult;
//  fNewData:=False;
//  fError:=False;
//  RepeatInErrorCase:=False;
//end;
//
//
procedure TRS232MeterDevice.DiapazonDetermination();
begin

end;




//procedure TRS232MeterDevice.Free;
//begin
////  FreeDataConverter;
////  FreeDataRequest;
//  inherited Free;
//end;

procedure TRS232MeterDevice.AddDataSubject(DataSubject: IRS232DataSubject);
begin
  fIRS232DataSubject:=DataSubject;
end;

constructor TRS232MeterDevice.Create(Nm: string);
begin
 inherited Create(Nm);

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

// CreateDataConverter;
// CreateDataRequest;
end;

function TRS232MeterDevice.GetData: double;
begin
  Result:=ErResult;
  if fIRS232DataSubject.PortConnected then
   begin
    Result:=Measurement();
    fNewData:=True;
   end
                                      else
   begin
     fError:=True;
     showmessage(fMessageError);
   end;
end;

procedure TRS232MeterDevice.GetDataThread(WPARAM: word;EventEnd:THandle);
begin
 if fIRS232DataSubject.PortConnected then
   fRS232MeasuringTread:=TRS232MeasuringTreadNew.Create(Self,WPARAM,EventEnd);
end;

procedure TRS232MeterDevice.MeasurementBegin;
begin
  fIsReceived:=False;
  fError:=False;
end;


//procedure TRS232MeterDevice.Request;
//begin
//  fRS232DataRequest.Request;
//end;

function TRS232MeterDevice.GetNewData: boolean;
begin
 Result:=fNewData;
end;

function TRS232MeterDevice.GetValue: double;
begin
 Result:=fValue;
end;

function TRS232MeterDevice.Measurement: double;
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


 Result:=fValue;

 if (RepeatInErrorCase) and (Result=ErResult)and(isFirst) then
    begin
      isFirst:=false;
      goto start;
    end;
end;

function TRS232MeterDevice.MeasureModeLabelRead: string;
begin
 Result:='';
end;


procedure TRS232MeterDevice.MModeDetermination();
begin

end;

//procedure TRS232MeterDevice.PacketReceiving(Sender: TObject; const Str: string);
//begin
//
//end;

//procedure TRS232MeterDevice.Request;
//begin
////  isNeededComPortState();
//end;


procedure TRS232MeterDevice.SetNewData(Value: boolean);
begin
 fNewData:=Value;
end;

procedure TRS232MeterDevice.UpDate();
begin
 fIsReceived:=True;
// fRS232DataConverter.DataConvert();
end;

procedure TRS232MeterDevice.ValueDetermination();
begin

end;


//{ TAdapterRadioGroupClick }
//
//constructor TAdapterRadioGroupClick.Create(ind: integer);
//begin
// inherited Create;
// findexx:=ind;
//end;
//
//
//procedure TAdapterRadioGroupClick.RadioGroupClick(Sender: TObject);
//begin
// try
// (Sender as TRadioGroup).ItemIndex:=findexx;
// except
// end;
//end;
//
//
//procedure TAdapterRadioGroupClick.RadioGroupOnEnter(Sender: TObject);
//begin
// try
//  findexx:=(Sender as TRadioGroup).ItemIndex;
// except
// end;
//end;
//
//Function BCDtoDec(BCD:byte; isLow:boolean):byte;
//{виділяє з ВCD, яке містить дві десяткові
//цифри у двійково-десятковому представленні,
//ці цифри;
//якщо  isLow=true, то виділення із
//молодшої частини байта}
//begin
// if isLow then Result:=BCD and $0F
//          else Result:= BCD Shr 4;
//end;
//
//
//Procedure PortBeginAction(Port:TComPort;Lab:TLabel;Button: TButton);
//begin
//  try
//    Port.Open;
//    Port.Open;
//    Port.AbortAllAsync;
//    Port.AbortAllAsync;
//    Port.ClearBuffer(True, True);
//    Port.ClearBuffer(True, True);
//  finally
//   if Port.Connected then
//      begin
//       Lab.Caption:='Port is open';
//       Lab.Font.Color:=clBlue;
//       if Button<>nil then Button.Caption:='To close'
//      end
//                           else
//      begin
//       Lab.Caption:='Port is close';
//       Lab.Font.Color:=clRed;
//       if Button<>nil then Button.Caption:='To open'
//      end
//  end;
//
//
//end;
//
//Procedure PortEndAction(Port:TComPort);
//begin
//   try
//  if Port.Connected then
//   begin
//    Port.AbortAllAsync;
//    Port.ClearBuffer(True, True);
//    Port.Close;
//   end;
// finally
// end;
//end;
//
//
//{ TRS232MeterConvertData }
//
//procedure TRS232MeterConvertData.ConvertToValue;
//begin
// fRS232ConvertData.Value:=ErResult;
//end;
//
//constructor TRS232MeterConvertData.Create(RS232ConvertData:TRS232ConvertData);
//begin
// inherited Create;
// fRS232ConvertData:=RS232ConvertData;
// fDiapazon:=-1;
//end;
//
//function TRS232MeterConvertData.GetDiapazon: Shortint;
//begin
// Result:=fDiapazon;
//end;
//
//function TRS232MeterConvertData.MeasureModeLabelRead: string;
//begin
// Result:='';
//end;
//
//{ TComplexDeviceConvertData }
//
//procedure TComplexDeviceConvertData.ConvertToValue;
//begin
//  fRS232MeterConvertData.ConvertToValue();
//  fRS232ConvertData.fValue:=ErResult;
//  MModeDetermination(fRS232ConvertData.fData);
//  if fMeasureMode=-1 then Exit;
//  DiapazonDetermination(fRS232ConvertData.fData);
//  if fDiapazon=-1 then Exit;
//
//  ValueDetermination(fRS232ConvertData.fData);
//end;
//
//constructor TComplexDeviceConvertData.Create(
//  RS232MeterConvertData: TRS232MeterConvertData);
//begin
//  fRS232MeterConvertData:=RS232MeterConvertData;
//  fRS232ConvertData:=RS232MeterConvertData.fRS232ConvertData;
//  fMeasureMode:=-1;
//  fDiapazon:=-1;
//end;
//
//function TComplexDeviceConvertData.MeasureModeLabelRead: string;
//begin
// Result:=fRS232MeterConvertData.MeasureModeLabelRead();
//end;
//
//{ TRS232ConvertData }
//
//function TRS232ConvertData.GetValue: double;
//begin
// Result:=fValue;
//end;
//

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

procedure TRS232.Free;
begin
  fComPacket.Free;
end;

function TRS232.IsSend(report: string): boolean;
begin
 Result:=PacketIsSend(fComPort,report);
end;


{ TRS232DataSubject }

constructor TRS232DataSubjectSingle.Create(CP: TComPort);
begin
  inherited Create(CP);
//  ComPortCreare(CP);
  fObserver:=nil;
//  fRS232.fComPacket.OnPacket:=PacketReceiving;
end;

//procedure TRS232DataSubject.DataTransform(const Str: string;
//  var pData: TArrByte);
//begin
// StrToArrByte(Str,pData);
//end;

//procedure TRS232DataSubjectSingle.Free;
//begin
// fRS232.Free;
// inherited Free;
//end;

procedure TRS232DataSubjectSingle.NotifyObservers;
begin
  if  fObserver<>nil then fObserver.UpDate();
end;

//procedure TRS232DataSubjectSingle.PacketReceiving(Sender: TObject; const Str: string);
//begin
//  fReceivedString:=Str;
//  NotifyObservers();
//end;

//function TRS232DataSubjectSingle.PortConnected: boolean;
//begin
// try
//   Result:=fRS232.fComPort.Connected;
// except
//   Result:=False;
// end;
//end;

procedure TRS232DataSubjectSingle.RegisterObserver(o: IRS232DataObserver);
begin
  fObserver:=o;
end;

procedure TRS232DataSubjectSingle.RemoveObserver(o: IRS232DataObserver);
begin
 fObserver:=nil;
end;

{ TRS232CustomDevice }

constructor TRS232CustomDevice.Create(Nm: string);
begin
 fName:=Nm;
 fMessageError:=fName+ErrorMesNew;
end;

function TRS232CustomDevice.GetMessageError: string;
begin
 Result:=fMessageError;
end;

procedure TRS232CustomDevice.SetError(const Value: boolean);
begin
 fError:=Value;
end;

procedure TRS232CustomDevice.SetMessageError(const Value: string);
begin
 fMessageError:=Value;
end;

{ TRS232MeterDeviceSingle }

constructor TRS232MeterDeviceSingle.Create(CP: TComPort; Nm: string);
begin
  CreateDataSubject(CP);
  inherited Create(Nm);
  fIRS232DataSubject:=fDataSubject;
  fDataSubject.RegisterObserver(Self);
//  fIRS232DataSubject.RegisterObserver(Self);
  CreateDataRequest;
end;

procedure TRS232MeterDeviceSingle.Free;
begin
  fDataRequest.Free;
  fDataSubject.Free;
  inherited Free;
end;

//procedure TRS232MeterDeviceSingle.FreeDataRequest;
//begin
// fDataRequest.Free;
//end;

procedure TRS232MeterDeviceSingle.Request;
begin
 fDataRequest.Request;
end;

{ TComplexDeviceDataConverter }

constructor TComplexDeviceDataConverter.Create(MD: TRS232MeterDevice);
begin
  fMeterDevice:=MD;
end;

procedure TComplexDeviceDataConverter.DataConvert();
begin
  with fMeterDevice do
  begin
  MModeDetermination();
  if fMeasureMode=-1 then Exit;
  DiapazonDetermination();
  if fDiapazon=-1 then  Exit;
  ValueDetermination();
  end;
end;

{ TRS232MetterShowNew }

constructor TRS232MetterShowNew.Create(Meter: TRS232MeterDevice;
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


procedure TRS232MetterShowNew.DiapazonFill;
begin
  Range.Items.Clear;
  if RS232Meter.fMeasureMode>-1
    then
      StringArrayToRadioGroup(RS232Meter.fDiapazonAll[RS232Meter.fMeasureMode],
                              Range);
  Range.Items.Add(ErrorL);
  IndexToRadioGroup(RS232Meter.fDiapazon,Range);
end;

procedure TRS232MetterShowNew.Free;
begin
 AdapterMeasureMode.Free;
 AdapterRange.Free;
 inherited Free;
end;

procedure TRS232MetterShowNew.MeasureModeFill;
begin
    StringArrayToRadioGroup(RS232Meter.fMeasureModeAll,MeasureMode);
    MeasureMode.Items.Add(ErrorL);
end;

function TRS232MetterShowNew.UnitModeLabel: string;
begin
 Result:=RS232Meter.MeasureModeLabel;
end;

procedure TRS232MetterShowNew.MetterDataShow;
begin
  MeasureMode.OnClick:=nil;
  Range.OnClick:=nil;

  IndexToRadioGroup(RS232Meter.fMeasureMode,MeasureMode);
  DiapazonFill();

  MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
  Range.OnClick:=AdapterRange.RadioGroupClick;

  inherited  MetterDataShow();
end;





{ TCDDataRequest_UT70 }

constructor TCDDataRequest.Create(ComPort: TRS232;
                                CustomDevice: TRS232CustomDevice);
begin
 fRS232:=ComPort;
 fRS232CustomDevice:=CustomDevice;
end;

function TCDDataRequest.IsNoSuccessSend: Boolean;
begin
 Result:=False;
end;

procedure TCDDataRequest.PreparePort;
begin
  fRS232.ComPort.AbortAllAsync;
  fRS232.ComPort.ClearBuffer(True, True);
end;

procedure TCDDataRequest.Request;
begin
  if fRS232.ComPort.Connected then
    begin
     PreparePort;
     fRS232CustomDevice.Error:=IsNoSuccessSend;
    end
                        else
     fRS232CustomDevice.Error:=True;
end;

{ TRS232DataSubjectBase }

constructor TRS232DataSubjectBase.Create(CP: TComPort);
begin
  ComPortCreare(CP);
  fRS232.fComPacket.OnPacket:=PacketReceiving;
end;

procedure TRS232DataSubjectBase.Free;
begin
 fRS232.Free;
 inherited Free;
end;

procedure TRS232DataSubjectBase.PacketReceiving(Sender: TObject;
                                            const Str: string);
begin
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

initialization
//  EventComPortFree := CreateEvent(nil,
//                                 True, // тип сброса TRUE - ручной
//                                 True, // начальное состояние TRUE - сигнальное
//                                 nil);
//  EventMeasuringEnd := CreateEvent(nil,
//                                 True, // тип сброса TRUE - ручной
//                                 True, // начальное состояние TRUE - сигнальное
//                                 nil);
//

finalization

//  SetEvent(EventComPortFree);
//  CloseHandle(EventComPortFree);
//
//
//  SetEvent(EventMeasuringEnd);
//  CloseHandle(EventMeasuringEnd);
end.
