unit TemperatureSensor;

interface

uses
  SPIdevice, CPort, Measurement, RS232device;

type
  TDS18B20=class(TArduinoMeter,ITemperatureMeasurement)
  {базовий клас для датчика DS18B20}
  protected
   Procedure ConvertToValue(Data:array of byte);override;
  public
   Constructor Create(CP:TComPort;Nm:string);override;
   function GetTemperature():double;
  end;

  TThermoCuple=class(TNamedDevice,ITemperatureMeasurement)
    protected

    public
     Measurement:IMeasurement;
     class function T_CuKo(Voltage:double):double;
     {функция расчета температури по значениям напряжения
     согласно градуировке термопары медь-константан}
     function GetTemperature():double;
     Constructor Create();
     Procedure Free;
  end;

implementation

uses
  PacketParameters, OlegType;

{ TDS18B20 }

constructor TDS18B20.Create(CP:TComPort;Nm:string);
begin
  inherited Create(CP,Nm);

  fMetterKod:=DS18B20Command;
//  SetLength(fPins,1);
  SetLength(Pins.fPins,1);
  fMinDelayTime:=500;
end;



function TDS18B20.GetTemperature: double;
begin
 Result:=Measurement();
end;


procedure TDS18B20.ConvertToValue(Data: array of byte);
 var temp:integer;
     sign:byte;
begin
 if High(Data)<>1 then Exit;
 sign:=(Data[1] and $F8);
 if sign=$0 then
    begin
      temp:=(Data[1] and $7) Shl 8 + Data[0];
      fValue:=temp/16.0;
    end     else
      if sign=$F8 then
        begin
         temp:=(Data[1] and $7) Shl 8 + Data[0]-128;
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

function TThermoCuple.GetTemperature: double;
begin
 Result:=T_CuKo(Measurement.GetData);
end;

class function TThermoCuple.T_CuKo(Voltage: double): double;
begin
 Voltage:=Voltage*1e6;
 Result:=273.8+0.025*Voltage-1.006e-6*Voltage*Voltage+1.625e-10*Voltage*Voltage*Voltage;
end;

end.
