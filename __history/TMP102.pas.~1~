unit TMP102;

interface

uses
  TemperatureSensor, CPort;

const
 TMP102_StartAdress=$48;
 TMP102_LastAdress=$4B;

type

 TTMP102=class(TTempSensor_I2C)
  {базовий клас для датчика TMP102}
  public
   Constructor Create(CP:TComPort;Nm:string);//override;
   Procedure ConvertToValue();override;
  end;


implementation

uses
  OlegType, PacketParameters, ArduinoDevice;

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
end;

constructor TTMP102.Create(CP: TComPort; Nm: string);
begin
  inherited Create(CP,Nm);
  fMetterKod:=TMP102Command;
//  SetLength(Pins.fPins,1);
  fMinDelayTime:=30;
//  RepeatInErrorCase:=True;
//  fDelayTimeStep:=2;
end;


end.
