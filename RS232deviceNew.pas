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
 ErrorMes=' connection with ComPort is unsuccessful';

var
    EventComPortFree: THandle;
    EventMeasuringEnd: THandle;

type

//  http://www.sql.ru/forum/681753/delegirovanie-realizacii-metodov-interfeysa-drugomu-klassu

IRS232DataObserver = interface
  ['{0DC1F3EC-1356-45CE-96F7-7287DB006F1B}']
  procedure UpDate ();
end;


IRS232DataSubject = interface
  ['{0C822EBE-BD63-4E40-8D8D-A20615DC2FE6}']
  procedure NotifyObservers;
  function PortConnected():boolean;
end;

IRS232DataSubjectSingle = interface //(IRS232DataSubject)
  ['{0C822EBE-BD63-4E40-8D8D-A20615DC2FE6}']
  procedure RegisterObserver(o:IRS232DataObserver);
  procedure RemoveObserver(o:IRS232DataObserver);
end;


TRS232=class
  {�������� ������������ COM-�����}
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
//  Procedure Free;
  destructor Destroy;override;
  procedure NotifyObservers;virtual;abstract;
end;


TRS232DataSubjectSingle=class(TRS232DataSubjectBase,IRS232DataSubjectSingle,IRS232DataSubject)
 protected
//  fObserver:IRS232DataObserver;
  fObserver:pointer;
  function GetObserver:IRS232DataObserver;
 public
  property Observer:IRS232DataObserver read GetObserver;
  Constructor Create(CP:TComPort);
  procedure RegisterObserver(o:IRS232DataObserver);
  procedure RemoveObserver(o:IRS232DataObserver);
  procedure NotifyObservers;override;
end;

TRS232CustomDevice=class(TNamedInterfacedObject)
//  {������� ���� ��� ��������, �� ���������
//  �� ��������� COM-�����}
  protected
   fError:boolean;
   fMessageError:string;
   fData:TArrByte;
   function GetMessageError:string;
   procedure SetError(const Value:boolean);
   procedure SetMessageError(const Value:string);
   function GetData(Index: Integer): Byte;
   procedure SetData(Index: integer; Value: byte);
   function  GetHighDataIndex:integer;
   procedure SetHighDataIndex(Value:integer);
  public
   property Data[Index: Integer]:byte read GetData write SetData;
   property HighDataIndex:integer read GetHighDataIndex write SetHighDataIndex;
   property Error:boolean read fError write SetError;
   property MessageError:string read GetMessageError write SetMessageError;
   Constructor Create(Nm:string);
   procedure AddData(NewData:array of byte);overload;
   procedure AddData(NewByte:byte);overload;
   procedure CopyToData(NewData:array of byte);
  end;


TRS232MeterDevice=class(TRS232CustomDevice,IMeasurement,IRS232DataObserver)
//  {������� ���� ��� ������������ ��'����,
//  �� �������������� ���� ����� � COM-������}
  protected
//   fIRS232DataSubject:IRS232DataSubject;
   fIRS232DataSubject:pointer;
   fValue:double;
   fIsReceived:boolean;
   fMinDelayTime:integer;
  {�������� ���������� ����� �������� ��������
  �������� ������, []=��, �� ������������� 0}
   fDelayTimeStep:integer;
   {������� ����, ����� ���� ������������
   ����������� �����, []=��, �� ������������� 10}
   fDelayTimeMax:integer;
   {����������� ������� ��������
   ����������� �����, []=����, �� ������������� 130,
   ����� �� ������������� �������� �����������
   ������ 0+10*130=1300 ��}
   fRS232MeasuringTread:TThread;
   fNewData:boolean;
   function GetNewData:boolean;
   function GetDeviceKod:byte;virtual;
   Function Measurement():double;virtual;
   Function GetValue():double;virtual;
   procedure SetNewData(Value:boolean);
   procedure UpDate ();virtual;
   function GetRS232DataSubject:IRS232DataSubject;
   procedure SetRS232DataSubject(Value:IRS232DataSubject);
  public
   RepeatInErrorCase:boolean;
   property RS232DataSubject:IRS232DataSubject read GetRS232DataSubject
                                                write SetRS232DataSubject;
   property NewData:boolean read GetNewData write SetNewData;
   property Value:double read GetValue write fValue;
   property isReceived:boolean read fIsReceived write fIsReceived;
   property MinDelayTime:integer read  fMinDelayTime;
   property DelayTimeStep:integer read  fDelayTimeStep;
   property DelayTimeMax:integer read  fDelayTimeMax;
   property DeviceKod:byte read GetDeviceKod;
   Constructor Create(Nm:string);
   Procedure Request();virtual;abstract;
   function GetData():double;virtual;
   procedure MeasurementBegin;
   procedure GetDataThread(WPARAM: word;EventEnd:THandle);virtual;
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
{������������ ������� ������ ��� ���-�����}
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
   fMD:TRS232MeterDevice;
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
   Constructor Create(MD:TRS232MeterDevice);
end;



TAdapterRadioGroupClick=class
    findexx:integer;
    Constructor Create(ind:integer);overload;
    procedure RadioGroupClick(Sender: TObject);
    procedure RadioGroupOnEnter(Sender: TObject);
  end;


TRS232MetterShow=class(TMeasurementShow)
  protected
   RS232Meter:TRS232MeterDevice;
   DeviceDataConverter:TComplexDeviceDataConverter;
   AdapterMeasureMode,AdapterRange:TAdapterRadioGroupClick;
   procedure DiapazonFill();
   procedure MeasureModeFill();
   function UnitModeLabel():string;override;
  public
   Constructor Create(Meter:TRS232MeterDevice;
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
{������ � �CD, ��� ������ �� ��������
����� � �������-����������� �������������,
�� �����;
����  isLow=true, �� �������� ��
������� ������� �����}

Procedure PortBeginAction(Port:TComPort;Lab:TLabel;Button: TButton);

Procedure PortEndAction(Port:TComPort);

implementation

uses
  OlegType, Dialogs, RS232_Meas_Tread, Windows, Forms, Graphics;

//procedure TRS232MeterDevice.DiapazonDetermination();
//begin
//
//end;


constructor TRS232MeterDevice.Create(Nm: string);
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

function TRS232MeterDevice.GetData: double;
begin
  Result:=ErResult;
  if RS232DataSubject.PortConnected then
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
 if RS232DataSubject.PortConnected then
   fRS232MeasuringTread:=TRS232MeasuringTread.Create(Self,WPARAM,EventEnd);
end;


function TRS232MeterDevice.GetDeviceKod: byte;
begin
 Result:=0;
end;

function TRS232MeterDevice.GetRS232DataSubject:IRS232DataSubject;
begin
 Result:=IRS232DataSubject(fIRS232DataSubject);
end;

procedure TRS232MeterDevice.MeasurementBegin;
begin
  fIsReceived:=False;
  fError:=False;
end;


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

//function TRS232MeterDevice.MeasureModeLabelRead: string;
//begin
// Result:='';
//end;


//procedure TRS232MeterDevice.MModeDetermination();
//begin
//
//end;


procedure TRS232MeterDevice.SetRS232DataSubject(Value: IRS232DataSubject);
begin
  fIRS232DataSubject:=pointer(Value);
end;

procedure TRS232MeterDevice.SetNewData(Value: boolean);
begin
 fNewData:=Value;
end;


procedure TRS232MeterDevice.UpDate();
begin
 fIsReceived:=True;
end;

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
{������ � �CD, ��� ������ �� ��������
����� � �������-����������� �������������,
�� �����;
����  isLow=true, �� �������� ��
������� ������� �����}
begin
 if isLow then Result:=BCD and $0F
          else Result:= BCD Shr 4;
end;


Procedure PortBeginAction(Port:TComPort;Lab:TLabel;Button: TButton);
begin
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


function TRS232DataSubjectSingle.GetObserver: IRS232DataObserver;
begin
 if fObserver=nil then Result:=nil
                  else Result:=IRS232DataObserver(fObserver);
end;

procedure TRS232DataSubjectSingle.NotifyObservers;
begin
//  if  fObserver<>nil then fObserver.UpDate();
  if  Observer<>nil then Observer.UpDate();
end;

procedure TRS232DataSubjectSingle.RegisterObserver(o: IRS232DataObserver);
begin
  fObserver:=pointer(o);
//  fObserver:=o;
end;

procedure TRS232DataSubjectSingle.RemoveObserver(o: IRS232DataObserver);
begin
 fObserver:=nil;
end;

{ TRS232CustomDevice }

procedure TRS232CustomDevice.AddData(NewData: array of byte);
 var i,j:integer;
begin
 j:=High(fData)+1;
 SetLength(fData,j+High(NewData)+1);
 for I := 0 to High(NewData) do
  fData[i+j]:= NewData [i];
end;

procedure TRS232CustomDevice.AddData(NewByte: byte);
begin
 AddData([NewByte]);
end;

constructor TRS232CustomDevice.Create(Nm: string);
begin
 fName:=Nm;
 fMessageError:=fName+ErrorMes;
end;

procedure TRS232CustomDevice.CopyToData(NewData: array of byte);
 var i:integer;
begin
 SetLength(fData,High(NewData)+1);
 for I := 0 to High(NewData) do
  fData[i]:= NewData [i];
end;

function TRS232CustomDevice.GetData(Index: Integer): byte;
begin
//  if Index>High(fData)
//    then Result:=ErResult
//    else
    Result:=fData[Index];
end;

function TRS232CustomDevice.GetHighDataIndex: integer;
begin
 Result:=High(fData);
end;

function TRS232CustomDevice.GetMessageError: string;
begin
 Result:=fMessageError;
end;

procedure TRS232CustomDevice.SetData(Index: integer; Value:byte);
begin
  if Index<=High(fData)
   then  fData[Index]:=Value;
  
end;

procedure TRS232CustomDevice.SetError(const Value: boolean);
begin
 fError:=Value;
end;

procedure TRS232CustomDevice.SetHighDataIndex(Value: integer);
begin
 SetLength(fData,Value+1);
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
  RS232DataSubject:=fDataSubject;
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

constructor TComplexDeviceDataConverter.Create(MD: TRS232MeterDevice);
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

constructor TRS232MetterShow.Create(Meter: TRS232MeterDevice;
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
  EventComPortFree := CreateEvent(nil,
                                 True, // ��� ������ TRUE - ������
                                 True, // ��������� ��������� TRUE - ����������
                                 nil);
  EventMeasuringEnd := CreateEvent(nil,
                                 True, // ��� ������ TRUE - ������
                                 True, // ��������� ��������� TRUE - ����������
                                 nil);


finalization

  SetEvent(EventComPortFree);
  CloseHandle(EventComPortFree);


  SetEvent(EventMeasuringEnd);
  CloseHandle(EventMeasuringEnd);
end.
