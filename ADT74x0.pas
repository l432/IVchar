unit ADT74x0;

interface

uses
  TemperatureSensor, CPort;

const
 ADT74x0_StartAdress=$48;
 ADT74x0_LastAdress=$4B;

type
 TADT74x0=class(TTempSensor_I2C)
  {базовий клас для датчиків ADT7420 та ADT7410}
  public
   Constructor Create();//override;
   Procedure ConvertToValue();override;
  end;

//var
//   ADT74x:TADT74x0;


implementation

uses
  PacketParameters, OlegType;

{ TADT74x0 }

procedure TADT74x0.ConvertToValue;
 var temp:integer;
begin
// ShowData(fData);
 fValue:=ErResult;
 if High(fData)<>1 then Exit;

 temp:=(fData[0] shl 8) or fData[1];
 if (temp and $8000)>0 then fValue:=(temp-65536)/128.0
                       else fValue:=temp/128.0;
 if (fValue<-40)or(fValue>150) then fValue:=ErResult
                               else fValue:=fValue+273.16;

end;

constructor TADT74x0.Create();
begin
  inherited Create('ADT74x0');
  fMetterKod:=ADT74x0Command;
  fMinDelayTime:=240;
end;

initialization
//   ADT74x:=TADT74x0.Create;
finalization
//   ADT74x.Free;
end.
