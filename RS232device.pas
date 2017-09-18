unit RS232device;

interface

uses
  Measurement, CPort, PacketParameters, ExtCtrls, StdCtrls, Buttons;

const
 Error='Error';
 IA_Label='~ I';
 ID_Label='= I';
 UA_Label='~ U';
 UD_Label='= U';

type

  TRS232Device=class(TInterfacedObject,IName)
  {базовий клас для пристроїв, які керуються
  за допомогою COM-порту}
  protected
   fName:string;
   fComPort:TComPort;
   fComPacket: TComDataPacket;
   fData:TArrByte;
   Procedure PacketReceiving(Sender: TObject; const Str: string);virtual;abstract;
  public
   property Name:string read fName;
   Constructor Create();overload;virtual;
   Constructor Create(CP:TComPort);overload;
   Constructor Create(CP:TComPort;Nm:string);overload;virtual;
   Procedure Free;
   function GetName:string;
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
   Procedure MModeDetermination(Data:array of byte); virtual;
   Procedure DiapazonDetermination(Data:array of byte); virtual;
   Procedure ValueDetermination(Data:array of byte);virtual;
   Procedure ConvertToValue(Data:array of byte);virtual;
   Function ResultProblem(Rez:double):boolean;virtual;
   Function MeasureModeRead():string;
   Function DiapazonRead():string;
  public
   property Value:double read fValue;
   property isReady:boolean read fIsReady;
   property MeasureMode:string read MeasureModeRead;
   property MeasureModeIndex:ShortInt read fDiapazon;
   property DiapazonIndex:ShortInt read fMeasureMode;
   property Diapazon:string read DiapazonRead;
   Constructor Create();overload;override;
   Function Request():boolean;virtual;
   Function Measurement():double;virtual;
   function GetTemperature:double;virtual;
   function GetVoltage(Vin:double):double;virtual;
   function GetCurrent(Vin:double):double;virtual;
   function GetResist():double;virtual;
  end;

  TAdapterRadioGroupClick=class
    findexx:integer;
    Constructor Create(ind:integer);overload;
    procedure RadioGroupClick(Sender: TObject);
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
   procedure MeasureModeIndex();
   procedure DiapazonIndex();
  public
   AutoSpeedButton:TSpeedButton;
   Constructor Create(Meter:TRS232Meter;
                      MM,R:TRadioGroup;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      TT:TTimer
                      );
   Procedure Free;
//   procedure ButtonEnabled();
   procedure MetterDataShow();
  end;




implementation

uses
  OlegType, Dialogs, SysUtils, Forms;

{ TRS232Device }

constructor TRS232Device.Create;
begin
  inherited Create();
  fName:='';
  fComPacket:=TComDataPacket.Create(fComPort);
  fComPacket.Size:=0;
  fComPacket.MaxBufferSize:=1024;
  fComPacket.IncludeStrings:=False;
  fComPacket.CaseInsensitive:=False;
//  fComPacket.StartString:=PacketBeginChar;
//  fComPacket.StopString:=PacketEndChar;
  fComPacket.OnPacket:=PacketReceiving;
end;

constructor TRS232Device.Create(CP: TComPort);
begin
 Create();
 fComPort:=CP;
 fComPacket.ComPort:=CP;
end;

constructor TRS232Device.Create(CP: TComPort; Nm: string);
begin
 Create(CP);
 fName:=Nm;
end;

procedure TRS232Device.Free;
begin
 fComPacket.Free;
 inherited;
end;

function TRS232Device.GetName: string;
begin
 Result:=Name;
end;

{ TRS232Meter }

procedure TRS232Meter.ConvertToValue(Data: array of byte);
begin
  MModeDetermination(Data);
  if fMeasureMode=-1 then Exit;
  DiapazonDetermination(Data);
  if fDiapazon=-1 then Exit;
  ValueDetermination(Data);
  if Value=ErResult then Exit;
  fIsready:=True;
end;

constructor TRS232Meter.Create;
begin
  inherited Create();
  fIsReady:=False;
  fIsReceived:=False;
  fMinDelayTime:=0;
  fMeasureMode:=-1;
  fDiapazon:=-1;
  fValue:=ErResult;
end;

procedure TRS232Meter.DiapazonDetermination(Data: array of byte);
begin

end;

function TRS232Meter.DiapazonRead: string;
begin
 Result:=fDiapazonAll[fMeasureMode,fDiapazon];
end;

function TRS232Meter.GetCurrent(Vin: double): double;
begin
  Result:=ErResult;
end;

function TRS232Meter.GetResist: double;
begin
  Result:=ErResult;
end;

function TRS232Meter.GetTemperature: double;
begin
  Result:=ErResult;
end;

function TRS232Meter.GetVoltage(Vin: double): double;
begin
  Result:=ErResult;
end;

function TRS232Meter.Measurement: double;
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



function TRS232Meter.MeasureModeRead: string;
begin
 Result:=fMeasureModeAll[fMeasureMode]
end;

procedure TRS232Meter.MModeDetermination(Data: array of byte);
begin

end;

function TRS232Meter.Request: boolean;
begin
  Result:=True;
end;

function TRS232Meter.ResultProblem(Rez: double): boolean;
begin
 Result:=False;
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
   MeasureModeIndex();
   DiapazonFill();
   DiapazonIndex();
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
end;

procedure TMetterShow.DiapazonIndex;
begin
  if RS232Meter.fDiapazon>-1
    then Range.ItemIndex := RS232Meter.fDiapazon
    else Range.ItemIndex :=Range.Items.Count-1;

end;

procedure TMetterShow.DiapazonFill;
 var i:byte;
begin
  Range.Items.Clear;
  if RS232Meter.fMeasureMode>-1
    then
       for I := 0 to High(RS232Meter.fDiapazonAll[RS232Meter.fMeasureMode]) do
           Range.Items.Add(RS232Meter.fDiapazonAll[RS232Meter.fMeasureMode,i]);
  Range.Items.Add(Error);
end;

procedure TMetterShow.Free;
begin
 AdapterMeasureMode.Free;
 AdapterRange.Free;

 inherited Free;
end;

procedure TMetterShow.MeasurementButtonClick(Sender: TObject);
begin
  if not(RS232Meter.fComPort.Connected) then Exit;
  RS232Meter.Measurement();
  MetterDataShow();
end;

procedure TMetterShow.MeasureModeFill;
 var i:byte;
begin
    MeasureMode.Items.Clear;
    for I := 0 to High(RS232Meter.fMeasureModeAll) do
      MeasureMode.Items.Add(RS232Meter.fMeasureModeAll[i]);
    MeasureMode.Items.Add(Error);
end;

procedure TMetterShow.MeasureModeIndex;
begin
  if RS232Meter.fMeasureMode>-1
    then MeasureMode.ItemIndex := RS232Meter.fMeasureMode
    else MeasureMode.ItemIndex :=MeasureMode.Items.Count-1;
end;

procedure TMetterShow.MetterDataShow;
begin
  MeasureMode.OnClick:=nil;
  Range.OnClick:=nil;
  MeasureModeIndex();
  DiapazonFill();
  DiapazonIndex();

  MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
  Range.OnClick:=AdapterRange.RadioGroupClick;

  if RS232Meter.isReady then
     begin
//       UnitLabel.Caption:=RS232Meter.fMeasureModeLabelAll[RS232Meter.fMeasureMode];
       UnitLabel.Caption:=RS232Meter.MeasureMode;
       DataLabel.Caption:=FloatToStrF(RS232Meter.Value,ffExponent,4,2)
     end
                        else
     begin
       UnitLabel.Caption:='';
       DataLabel.Caption:='    ERROR';
     end;
//  case (ArduDevice as TVoltmetr).MeasureMode of
//     IA,ID: UnitLabel.Caption:=' A';
//     UA,UD: UnitLabel.Caption:=' V';
//     MMErr: UnitLabel.Caption:='';
//  end;
//  if (ArduDevice as TVoltmetr).isReady then
//      DataLabel.Caption:=FloatToStrF((ArduDevice as TVoltmetr).Value,ffExponent,4,2)
//                       else
//      begin
//       DataLabel.Caption:='    ERROR';
//       UnitLabel.Caption:='';
//      end;

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

end.
