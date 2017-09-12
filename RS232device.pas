unit RS232device;

interface

uses
  Measurement, CPort, PacketParameters;

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
   Constructor Create(CP:TComPort;Nm:string);overload;
   Procedure Free;
   function GetName:string;
  end;

  TRS232Meter=class(TRS232Device,IMeasurement)
  {базовий клас для вимірювальних об'єктів,
  які використовують обмін даних з COM-портом}
  private
   fValue:double;
   fIsReady:boolean;
   fIsReceived:boolean;
   fMinDelayTime:integer;
  {інтервал очікування перед початком перевірки
  вхідного буфера, []=мс}
   Procedure ConvertToValue(Data:array of byte);virtual;abstract;
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

constructor TRS232Meter.Create;
begin
  inherited Create();
  fIsReady:=False;
  fIsReceived:=False;
  fMinDelayTime:=0;
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


function TRS232Meter.Request: boolean;
begin
  Result:=True;
end;

function TRS232Meter.ResultProblem(Rez: double): boolean;
begin
 Result:=False;
end;

end.
