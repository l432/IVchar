unit TemperatureSensor;

interface

uses
  SPIdevice;

type
  TDS18B20=class(TArduinoMeter)
  {базовий клас для датчика DS18B20}
  protected
   Procedure ConvertToValue(Data:array of byte);override;
  public
   Constructor Create();overload;override;
   function GetTemperature:double;override;
  end;

implementation

uses
  PacketParameters, OlegType;

{ TDS18B20 }

constructor TDS18B20.Create;
begin
  inherited Create();
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


end.
