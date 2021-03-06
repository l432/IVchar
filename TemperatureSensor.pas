unit TemperatureSensor;

interface

uses
  CPort, Measurement, OlegTypePart2, 
  ArduinoDeviceNew;


type
  TTempSensor=class(TArduinoMeter,ITemperatureMeasurement)
  {������� ���� ��� ������� �����������}
  protected
  public
   function GetTemperature():double;virtual;
   procedure GetTemperatureThread(EventEnd:THandle);
  end;

 TTempSensor_I2C=class(TTempSensor)
  {������� ���� ��� ������� �����������, �� �������������� I2C}
  protected
   procedure PinsCreate();override;
  public
   Constructor Create(Nm:string);//override;
  end;


  TDS18B20=class(TTempSensor)
  {������� ���� ��� ������� DS18B20}
  protected
   procedure PinsCreate();override;
  public
   Constructor Create(Nm:string);//override;
   Procedure ConvertToValue();override;
  end;

  THTU21D=class(TTempSensor)
  {������� ���� ��� ������� HTU21D}
  protected
   Function CRCCorrect():boolean;
   procedure  PrepareData;override;
  public
//   Procedure PacketCreateToSend();override;
   Constructor Create(Nm:string);//override;
   Procedure ConvertToValue();override;
  end;

  TSTS21=class(THTU21D)
  {������� ���� ��� ������� STS21}
  protected
  public
   Constructor Create(Nm:string);//override;
  end;


  TThermoCuple=class(TNamedInterfacedObject,ITemperatureMeasurement,IMeasurement)
    private
     fMeasurement:pointer;
     function  GetMeasurement:IMeasurement;
     procedure SetMeasurement(Value:IMeasurement);
    protected
     function GetNewData:boolean;
     function GetValue:double;
     procedure SetNewData(value:boolean);
     function GetDeviceKod:byte;
    public
     property Measurement:IMeasurement read GetMeasurement write SetMeasurement;
     property NewData:boolean read GetNewData  write SetNewData;
     property Value:double read GetValue;
     class function T_CuKo(Voltage:double):double;
     {������� ���������� ����������� �� ���������� �������
     �������� �� ����������� ��������� ���-����������}
     function GetTemperature():double;
     Constructor Create();
     function GetData:double;
     procedure GetDataThread(WPARAM: word;EventEnd:THandle);
     procedure GetTemperatureThread(EventEnd:THandle);
  end;

var
  DS18B20:TDS18B20;
  HTU21D:THTU21D;
  STS21:TSTS21;
  ThermoCuple:TThermoCuple;

implementation

uses
  PacketParameters, OlegType, OlegFunction, SysUtils;

{ TDS18B20 }

constructor TDS18B20.Create(Nm:string);
begin
  inherited Create(Nm);

  fMetterKod:=DS18B20Command;
  fMinDelayTime:=500;
end;



procedure TDS18B20.PinsCreate;
begin
  Pins := TPins.Create(Name,1);
end;

procedure TDS18B20.ConvertToValue();
 var temp:integer;
     sign:byte;
begin
 fValue:=ErResult;
 if High(fData)<>1 then Exit;
 sign:=(fData[1] and $F8);
 if sign=$0 then
    begin
      temp:=(fData[1] and $7) Shl 8 + fData[0];
      fValue:=temp/16.0;
    end     else
      if sign=$F8 then
        begin
         temp:=(fData[1] and $7) Shl 8 + fData[0]-128;
         fValue:=temp/16.0;
        end       else
         fValue:=ErResult;
  if (fValue<-55)or(fValue>125) then fValue:=ErResult
                                else fValue:=fValue+273.16;
end;

{ TThermoCuple }

constructor TThermoCuple.Create;
begin
 fName:='ThermoCouple';
end;

function TThermoCuple.GetData: double;
begin
 Result:=GetTemperature;
end;

procedure TThermoCuple.GetDataThread(WPARAM: word;EventEnd:THandle);
begin
 Measurement.GetDataThread(WPARAM,EventEnd);
end;


function TThermoCuple.GetDeviceKod: byte;
begin
 Result:=0;
end;

function TThermoCuple.GetMeasurement:IMeasurement;
begin
 Result:=IMeasurement(fMeasurement);
end;

function TThermoCuple.GetNewData: boolean;
begin
  Result:=Measurement.NewData;
end;

function TThermoCuple.GetTemperature: double;
begin
 Result:=Measurement.GetData;
 if Result<>ErResult then  Result:=T_CuKo(Result);
end;

procedure TThermoCuple.GetTemperatureThread(EventEnd:THandle);
begin
 Measurement.GetDataThread(TemperMessage,EventEnd);
end;

function TThermoCuple.GetValue: double;
begin
 if Measurement.Value<>ErResult then
                Result:=T_CuKo(Measurement.Value)
                                else
                Result:=Measurement.Value;
end;

procedure TThermoCuple.SetMeasurement(Value: IMeasurement);
begin
 fMeasurement:=Pointer(Value);
end;

procedure TThermoCuple.SetNewData(Value: boolean);
begin
  Measurement.NewData:=Value;
end;

class function TThermoCuple.T_CuKo(Voltage: double): double;
begin
 Voltage:=Voltage*1e6;
 Result:=273.8+0.025*Voltage-1.006e-6*Voltage*Voltage+1.625e-10*Voltage*Voltage*Voltage;
end;

{ TTempSensor }

function TTempSensor.GetTemperature: double;
begin
  Result:=Measurement();
end;

procedure TTempSensor.GetTemperatureThread(EventEnd: THandle);
begin
  GetDataThread(TemperMessage,EventEnd);
end;

{ THTU21D }

procedure THTU21D.ConvertToValue;
 var temp:word;
begin
 fValue:=ErResult;
 if High(fData)<>2 then Exit;
 if not(CRCCorrect()) then Exit;

 temp:=((fData[0] shl 8) or  fData[1]) and $FFFC;
 fValue:=-46.85+temp*(175.72/65536.0);

 if (fValue<-40)or(fValue>125) then fValue:=ErResult
                               else fValue:=fValue+273.16;
end;

function THTU21D.CRCCorrect: boolean;
begin
 Result:= (CRC8(fData,$31)=0);
end;

constructor THTU21D.Create(Nm: string);
begin
  inherited Create(Nm);

  fMetterKod:=HTU21DCommand;
  SetLength(Pins.fPins,1);
  Pins.PinControl:=HTU21DCommand;
  fMinDelayTime:=55;
  RepeatInErrorCase:=True;
  fDelayTimeStep:=2;
end;

//procedure THTU21D.PacketCreateToSend;
//begin
//  PacketCreate([fMetterKod,fMetterKod]);
//end;


procedure THTU21D.PrepareData;
begin
  CopyToData([fMetterKod,fMetterKod]);
end;

{ TSTS21 }

constructor TSTS21.Create(Nm: string);
begin
  inherited Create(Nm);

  fMetterKod:=STS21Command;
  Pins.PinControl:=STS21Command;
  fMinDelayTime:=85;
end;

{ TTempSensor_I2C }

constructor TTempSensor_I2C.Create(Nm: string);
begin
  inherited Create(Nm);
  SetLength(Pins.fPins,1);
  RepeatInErrorCase:=True;
  fDelayTimeStep:=2;
end;

procedure TTempSensor_I2C.PinsCreate;
begin
 Pins := TPins_I2C.Create(Name);
end;

initialization
   DS18B20:=TDS18B20.Create('DS18B20');
   HTU21D:=THTU21D.Create('HTU21D');
   STS21:=TSTS21.Create('STS21');
   ThermoCuple:=TThermoCuple.Create;

finalization
   DS18B20.Free;
   HTU21D.Free;
   STS21.Free;
   ThermoCuple.Free;
end.
