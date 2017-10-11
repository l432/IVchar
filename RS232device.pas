unit RS232device;

interface

uses
  Measurement, CPort, PacketParameters, ExtCtrls, StdCtrls, Buttons, Windows,
  Classes,HighResolutionTimer;


const
 Error='Error';
 IA_Label='~I';
 ID_Label='=I';
 UA_Label='~U';
 UD_Label='=U';

var
//ComPortAlloved:boolean;
    EventComPortFree: THandle;
    EventMeasuringEnd: THandle;

type

TNamedDevice=class(TInterfacedObject)
  protected
   fName:string;
   function GetName:string;
  public
   property Name:string read GetName;
  end;

TRS232Device=class(TNamedDevice)
  {базовий клас для пристроїв, які керуються
  за допомогою COM-порту}
  protected
//   fName:string;
   fComPort:TComPort;
   fComPacket: TComDataPacket;
   fData:TArrByte;
   fisNeededComPort:boolean;
   fError:boolean;
   function PortConnected():boolean;
  public
   property isNeededComPort:boolean read fisNeededComPort write fisNeededComPort;
   property Error:boolean read fError;
   Constructor Create();overload;
   Constructor Create(CP:TComPort);overload;
   Constructor Create(CP:TComPort;Nm:string);overload;virtual;
   Procedure Free;
   procedure ComPortUsing();virtual;
   procedure isNeededComPortState();
  end;

TRS232Meter=class(TRS232Device,IMeasurement)
  {базовий клас для вимірювальних об'єктів,
  які використовують обмін даних з COM-портом}
  protected
   fValue:double;
   fIsReady:boolean;
   fIsReceived:boolean;
   fMinDelayTime:integer;
  {інтервал очікування перед початком перевірки
  вхідного буфера, []=мс}

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
//   Procedure ConvertToValue(Data:array of byte);virtual;
//   Function ResultProblem(Rez:double):boolean;virtual;
   Function MeasureModeLabelRead():string;virtual;
   Procedure PacketReceiving(Sender: TObject; const Str: string);virtual;
   Function Measurement():double;virtual;
//   Function MeasurementThread():double;virtual;
   Function GetValue():double;virtual;
   procedure SetNewData(Value:boolean);
  public
   property NewData:boolean read GetNewData write SetNewData;
   property Value:double read GetValue write fValue;
   property isReady:boolean read fIsReady write fIsReady;
   property isReceived:boolean read fIsReceived write fIsReceived;
   property MinDelayTime:integer read  fMinDelayTime;
   property MeasureModeLabel:string read MeasureModeLabelRead;
//   Constructor Create();override;
   Constructor Create(CP:TComPort;Nm:string);override;
   Procedure ConvertToValue();virtual;
   Function ResultProblem(Rez:double):boolean;virtual;
//   Function Request():boolean;virtual;
   Procedure Request();virtual;
   function GetData():double;virtual;
   procedure MeasurementBegin;
   procedure GetDataThread(WPARAM: word;EventEnd:THandle);virtual;
  end;



TRS232Setter=class(TRS232Device,IDAC)
 protected

 public
   procedure Output(Value:double);virtual;
   procedure OutputInt(Kod:integer); virtual;
   Procedure Reset();     virtual;
   function CalibrationStep(Voltage:double):double;  virtual;
   procedure OutputCalibr(Value:double); virtual;
 end;


TAdapterRadioGroupClick=class
    findexx:integer;
    Constructor Create(ind:integer);overload;
    procedure RadioGroupClick(Sender: TObject);
    procedure RadioGroupOnEnter(Sender: TObject);
  end;

TMetterShow=class
  protected
   RS232Meter:TRS232Meter;
   MeasureMode,Range:TRadioGroup;
   DataLabel,UnitLabel:TLabel;
   MeasurementButton:TButton;
   Time:TTimer;
   AdapterMeasureMode,AdapterRange:TAdapterRadioGroupClick;
   procedure MeasurementButtonClick(Sender: TObject);
   procedure AutoSpeedButtonClick(Sender: TObject);
   procedure DiapazonFill();
   procedure MeasureModeFill();
   procedure StringArrayToRadioGroup(SA:array of string;
                                     RG:TRadioGroup);
   procedure IndexToRadioGroup(Index:ShortInt;RG:TRadioGroup);
  public
   AutoSpeedButton:TSpeedButton;
   Constructor Create(Meter:TRS232Meter;
                      MM,R:TRadioGroup;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      TT:TTimer
                      );
   Procedure Free; virtual;
   procedure MetterDataShow();virtual;
end;


Function BCDtoDec(BCD:byte; isLow:boolean):byte;
{виділяє з ВCD, яке містить дві десяткові
цифри у двійково-десятковому представленні,
ці цифри;
якщо  isLow=true, то виділення із
молодшої частини байта}

Procedure PortStateToLabel(Port:TComPort;Lab:TLabel;Button: TButton);

implementation

uses
  OlegType, Dialogs, SysUtils, Forms, Graphics, RS232_Meas_Tread;

{ TRS232Device }

constructor TRS232Device.Create;
begin
  inherited Create();
//  fName:='';
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
// showmessage(Name);
end;

constructor TRS232Device.Create(CP: TComPort; Nm: string);
begin
 Create(CP);
 fName:=Nm;
end;

procedure TRS232Device.Free;
begin
 fComPacket.Free;
// inherited Free;
end;


procedure TRS232Device.isNeededComPortState;
begin
// while (not ComPortAlloved) do HRDelay(1);
// fisNeededComPort:=True;

 if WaitForSingleObject(EventComPortFree,1000)=WAIT_OBJECT_0
  then fisNeededComPort:=True;

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

//function TRS232Device.GetName: string;
//begin
// Result:=fName;
//end;

{ TRS232Meter }

//procedure TRS232Meter.ConvertToValue(Data: array of byte);
//begin
////   ShowData(Data);
//  MModeDetermination(Data);
//  if fMeasureMode=-1 then Exit;
//
////  showmessage(inttostr(fMeasureMode));
//  DiapazonDetermination(Data);
//  if fDiapazon=-1 then Exit;
////    ShowData(Data);
////  showmessage(inttostr(fDiapazon));
//
//  ValueDetermination(Data);
//  if Value=ErResult then Exit;
//
//  fIsready:=True;
//end;

procedure TRS232Meter.ConvertToValue();
begin
  MModeDetermination(fData);
  if fMeasureMode=-1 then Exit;
  DiapazonDetermination(fData);
  if fDiapazon=-1 then Exit;
//  ShowData(fData);

  ValueDetermination(fData);
//  if Value=ErResult then Exit;

  fIsready:=True;
end;

//constructor TRS232Meter.Create;
//begin
//  inherited Create();
//  fComPacket.OnPacket:=PacketReceiving;
//
//  fIsReady:=False;
//  fIsReceived:=False;
//  fMinDelayTime:=0;
//  fMeasureMode:=-1;
//  fDiapazon:=-1;
//  fValue:=ErResult;
//end;

constructor TRS232Meter.Create(CP:TComPort;Nm:string);
begin
  inherited Create(CP,Nm);
  fComPacket.OnPacket:=PacketReceiving;
               
  fIsReady:=False;
  fIsReceived:=False;
  fMinDelayTime:=0;
  fMeasureMode:=-1;
  fDiapazon:=-1;
  fValue:=ErResult;
  fNewData:=False;
  fError:=False;
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
//  if not(fComPort.Connected) then
//   begin
//    fError:=True;
//    showmessage('Port is not connected');
//    Exit;
//   end;
//  Result:=Measurement();
//  fNewData:=True;
end;

procedure TRS232Meter.GetDataThread(WPARAM: word;EventEnd:THandle);
begin
//  if not(fComPort.Connected) then
//   begin
//    fError:=True;
//    showmessage('Port is not connected');
//    Exit;
//   end;
 if PortConnected then
   fRS232MeasuringTread:=TRS232MeasuringTread.Create(Self,WPARAM,EventEnd);
end;

procedure TRS232Meter.MeasurementBegin;
begin
  fIsReady := False;
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

 Result:=ErResult;
// if not(fComPort.Connected) then
//   begin
//    showmessage('Port is not connected');
//    Exit;
//   end;

 isFirst:=True;
start:
  MeasurementBegin;

// if not(Request()) then Exit;
  Request();


 sleep(fMinDelayTime);
 i:=0;
 repeat
   sleep(10);
   inc(i);
 Application.ProcessMessages;
 until ((i>130)or(fIsReceived)or(fError));
// showmessage(inttostr((GetTickCount-i0)));
// if fIsReceived then ConvertToValue(fData);
//ShowData(fData);
 if fIsReceived then ConvertToValue();
 if fIsReady then Result:=fValue;

 if ((Result=ErResult)or(ResultProblem(Result)))and(isFirst) then
    begin
      isFirst:=false;
      goto start;
    end;
end;

//function TRS232Meter.Measurement: double;
//label start;
//var i:integer;
//    isFirst:boolean;
//begin
//
// Result:=ErResult;
// if not(fComPort.Connected) then
//   begin
//    showmessage('Port is not connected');
//    Exit;
//   end;
//
// fRS232MeasuringTread:=TRS232MeasuringTread.Create(Self);
// if fIsReady then Result:=fValue;
//
//end;


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

//function TRS232Meter.Request: boolean;
//begin
//  Result:=True;
//end;

procedure TRS232Meter.Request;
begin
  isNeededComPortState();
//  fisNeededComPort:=True;
end;


function TRS232Meter.ResultProblem(Rez: double): boolean;
begin
 Result:=False;
end;

procedure TRS232Meter.SetNewData(Value: boolean);
begin
 fNewData:=Value;
end;

procedure TRS232Meter.ValueDetermination(Data: array of byte);
begin

end;

{ TMetterVoltmetrShow }

procedure TMetterShow.AutoSpeedButtonClick(Sender: TObject);
begin
 MeasurementButton.Enabled:=not(AutoSpeedButton.Down);
 if AutoSpeedButton.Down then Time.OnTimer:=MeasurementButton.OnClick;
 Time.Enabled:=AutoSpeedButton.Down;
end;


constructor TMetterShow.Create(Meter: TRS232Meter;
                                       MM, R: TRadioGroup;
                                       DL, UL: TLabel;
                                       MB: TButton;
                                       AB: TSpeedButton;
                                       TT: TTimer);
begin
   RS232Meter:=Meter;
   MeasureMode:=MM;
   Range:=R;
//    MeasureMode.OnClick:=nil;
//    Range.OnClick:=nil;
   DataLabel:=DL;
   UnitLabel:=UL;
   MeasurementButton:=MB;
   AutoSpeedButton:=AB;
   Time:=TT;

   MeasureModeFill();

   IndexToRadioGroup(RS232Meter.fMeasureMode,MeasureMode);
//   MeasureModeIndex();
   DiapazonFill();
//   DiapazonIndex();
   UnitLabel.Caption := '';

   MeasurementButton.OnClick:=MeasurementButtonClick;
   AutoSpeedButton.OnClick:=AutoSpeedButtonClick;
//    AdapterMeasureMode:=TAdapterRadioGroupClick.Create(ord((ArduDevice as TVoltmetr).MeasureMode));
//    AdapterRange:=TAdapterRadioGroupClick.Create(DiapazonSelect((ArduDevice as TVoltmetr).MeasureMode,(ArduDevice as TVoltmetr).Diapazon));

//    AdapterMeasureMode:=TAdapterRadioGroupClick.Create(RS232Meter.MeasureModeIndex);
//    AdapterRange:=TAdapterRadioGroupClick.Create(RS232Meter.DiapazonIndex);
    AdapterMeasureMode:=TAdapterRadioGroupClick.Create(MeasureMode.Items.Count-1);
    AdapterRange:=TAdapterRadioGroupClick.Create(Range.Items.Count-1);
    MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
    Range.OnClick:=AdapterRange.RadioGroupClick;
    MeasureMode.onEnter:=AdapterMeasureMode.RadioGroupOnEnter;
    Range.onEnter:=AdapterRange.RadioGroupOnEnter;
end;


procedure TMetterShow.DiapazonFill;
begin
  Range.Items.Clear;
  if RS232Meter.fMeasureMode>-1
    then
      StringArrayToRadioGroup(RS232Meter.fDiapazonAll[RS232Meter.fMeasureMode],
                              Range);
  Range.Items.Add(Error);
  IndexToRadioGroup(RS232Meter.fDiapazon,Range);
end;

procedure TMetterShow.Free;
begin
 AdapterMeasureMode.Free;
 AdapterRange.Free;

 inherited Free;
end;

procedure TMetterShow.IndexToRadioGroup(Index: ShortInt; RG: TRadioGroup);
begin
  try
   RG.ItemIndex:=Index;
  except
   RG.ItemIndex:=RG.Items.Count-1;
  end;
end;

procedure TMetterShow.MeasurementButtonClick(Sender: TObject);
begin
//   if not((SPIDevice as TVoltmetr).fComPort.Connected) then Exit;
 RS232Meter.Measurement();
//showmessage('kkk');
 MetterDataShow


//  if RS232Meter.Measurement()<>ErResult then MetterDataShow();
end;

procedure TMetterShow.MeasureModeFill;
begin
    StringArrayToRadioGroup(RS232Meter.fMeasureModeAll,MeasureMode);
    MeasureMode.Items.Add(Error);
end;


procedure TMetterShow.MetterDataShow;
begin
  MeasureMode.OnClick:=nil;
  Range.OnClick:=nil;
  IndexToRadioGroup(RS232Meter.fMeasureMode,MeasureMode);
  DiapazonFill();

  MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
  Range.OnClick:=AdapterRange.RadioGroupClick;

//  if RS232Meter.isReady then
  if RS232Meter.Value<>ErResult then
     begin
       UnitLabel.Caption:=RS232Meter.MeasureModeLabel;
       DataLabel.Caption:=FloatToStrF(RS232Meter.Value,ffExponent,4,2)
     end
                        else
     begin
       UnitLabel.Caption:='';
       DataLabel.Caption:='    ERROR';
     end;
end;

procedure TMetterShow.StringArrayToRadioGroup(SA: array of string;
                                              RG: TRadioGroup);
 var i:byte;
begin
    RG.Items.Clear;
    for I := 0 to High(SA) do RG.Items.Add(SA[i]);
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
//showmessage('g1');
//showmessage(inttostr(BCD)+' '+inttostr(BCD Shl 4));

// if isLow then BCD:=BCD Shl 4;
 if isLow then Result:=BCD and $0F
          else Result:= BCD Shr 4;
// showmessage(inttostr(BCD)+' '+inttostr(BCD Shl 4));

 // showmessage('g2');
// Result:= BCD Shr 4;
end;


Procedure PortStateToLabel(Port:TComPort;Lab:TLabel;Button: TButton);
begin
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

{ TRS232Setter }

function TRS232Setter.CalibrationStep(Voltage: double): double;
begin
 Result:=0.01;
end;

procedure TRS232Setter.Output(Value: double);
begin

end;

procedure TRS232Setter.OutputCalibr(Value: double);
begin

end;

procedure TRS232Setter.OutputInt(Kod: integer);
begin

end;

procedure TRS232Setter.Reset;
begin

end;

{ TNamedDevice }

function TNamedDevice.GetName: string;
begin
   Result:=fName;
end;

initialization
//  ComPortAlloved:= True;
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
