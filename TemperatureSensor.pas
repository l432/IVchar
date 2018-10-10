unit TemperatureSensor;

interface

uses
  SPIdevice, CPort, Measurement, RS232device;

const
 TMP102_StartAdress=$48;
 TMP102_LastAdress=$4B;


type
  TTempSensor=class(TArduinoMeter,ITemperatureMeasurement)
  {базовий клас для датчиків температури}
  protected
  public
   function GetTemperature():double;
   procedure GetTemperatureThread(EventEnd:THandle);
  end;


//  TDS18B20=class(TArduinoMeter,ITemperatureMeasurement)
  TDS18B20=class(TTempSensor)
  {базовий клас для датчика DS18B20}
  protected
  public
   Constructor Create(CP:TComPort;Nm:string);override;
//   function GetTemperature():double;
   Procedure ConvertToValue();override;
//   procedure GetTemperatureThread(EventEnd:THandle);
  end;

  THTU21D=class(TTempSensor)
  {базовий клас для датчика HTU21D}
  protected
    Function CRCCorrect():boolean;
    Procedure PacketCreateToSend();override;
  public
   Constructor Create(CP:TComPort;Nm:string);override;
   Procedure ConvertToValue();override;
  end;

  TTMP102=class(TTempSensor)
  {базовий клас для датчика TMP102}
  protected
//   Procedure PacketCreateToSend();override;
  public
   Constructor Create(CP:TComPort;Nm:string);override;
   Procedure ConvertToValue();override;
  end;


  TThermoCuple=class(TNamedDevice,ITemperatureMeasurement,IMeasurement)
    protected
     function GetNewData:boolean;
     function GetValue:double;
     procedure SetNewData(value:boolean);
    public
     Measurement:IMeasurement;
     property NewData:boolean read GetNewData  write SetNewData;
     property Value:double read GetValue;
     class function T_CuKo(Voltage:double):double;
     {функция расчета температури по значениям напряжения
     согласно градуировке термопары медь-константан}
     function GetTemperature():double;
     Constructor Create();
     Procedure Free;
     function GetData:double;
     procedure GetDataThread(WPARAM: word;EventEnd:THandle);
     procedure GetTemperatureThread(EventEnd:THandle);
  end;

implementation

uses
  PacketParameters, OlegType, Dialogs;

{ TDS18B20 }

constructor TDS18B20.Create(CP:TComPort;Nm:string);
begin
  inherited Create(CP,Nm);

  fMetterKod:=DS18B20Command;
  SetLength(Pins.fPins,1);
  fMinDelayTime:=500;
end;



//function TDS18B20.GetTemperature: double;
//begin
// Result:=Measurement();
//end;


//procedure TDS18B20.GetTemperatureThread(EventEnd:THandle);
//begin
// GetDataThread(TemperMessage,EventEnd);
//end;

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
 fIsReady:=True;
end;

{ TThermoCuple }

constructor TThermoCuple.Create;
begin
 fName:='ThermoCouple';
end;

procedure TThermoCuple.Free;
begin

end;

function TThermoCuple.GetData: double;
begin
 Result:=GetTemperature;
end;

procedure TThermoCuple.GetDataThread(WPARAM: word;EventEnd:THandle);
begin
 Measurement.GetDataThread(WPARAM,EventEnd);
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
 fIsReady:=True;
end;

function THTU21D.CRCCorrect: boolean;
 var
     tempLongword,DivSor:Longword;
     i:byte;
begin
// showmessage('hi');
 DivSor:=$988000;
 tempLongWord:= ((((fData[0] shl 8) or  fData[1]) shl 8)or fData[2]);

 for I := 0 to 15 do
   begin
    if (tempLongWord and (1 shl (23-i)))<>0 then
      tempLongWord:=(tempLongWord xor DivSor);
    DivSor:=(DivSor shr 1);
   end;
 if tempLongWord=0 then Result:=True
                   else Result:=False;
end;

constructor THTU21D.Create(CP: TComPort; Nm: string);
begin
  inherited Create(CP,Nm);

  fMetterKod:=HTU21DCommand;
  SetLength(Pins.fPins,1);
  Pins.PinControl:=HTU21DCommand;
  fMinDelayTime:=55;
end;

procedure THTU21D.PacketCreateToSend;
begin
  PacketCreate([fMetterKod,fMetterKod]);
end;

{ TTMP102 }

procedure TTMP102.ConvertToValue;
 var temp:Smallint;
begin
 fValue:=ErResult;
 if High(fData)<>1 then Exit;

 temp:=smallint(fData[0] shl 4) or (fData[1] shr 4);
 if (temp > $7FF) then
   temp:=Smallint(temp or $F000);
  fValue:=temp*0.0625;
 if (fValue<-55)or(fValue>128) then fValue:=ErResult
                                else fValue:=fValue+273.16;
 fIsReady:=True;
end;

constructor TTMP102.Create(CP: TComPort; Nm: string);
begin
  inherited Create(CP,Nm);
  fMetterKod:=TMP102Command;
  SetLength(Pins.fPins,1);
  fMinDelayTime:=30;
end;



end.
