unit TMP102u;

interface

uses
  TemperatureSensor, CPort;

const
 TMP102_StartAdress=$48;
 TMP102_LastAdress=$4B;

type

 TTMP102=class(TTempSensor_I2C)
  {������� ���� ��� ������� TMP102}
  public
   Constructor Create();//override;
   Procedure ConvertToValue();override;
  end;

var
       TMP102:TTMP102;


implementation

uses
  OlegType, PacketParameters;

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

constructor TTMP102.Create();
begin
  inherited Create('TMP102');
  fMetterKod:=TMP102Command;
  fMinDelayTime:=30;
end;

initialization
   TMP102:=TTMP102.Create;
finalization
   TMP102.Free;
end.
