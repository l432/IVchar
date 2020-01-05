unit MCP9808;

interface

uses
  TemperatureSensor, CPort;

const
 MCP9808_StartAdress=$18;
 MCP9808_LastAdress=$1F;

type
 TMCP9808=class(TTempSensor_I2C)
  {базовий клас для датчика MCP9808}
  public
   Constructor Create(CP:TComPort;Nm:string);
   Procedure ConvertToValue();override;
  end;

implementation

uses
  PacketParameters, OlegType;

{ TADT74x0 }

procedure TMCP9808.ConvertToValue;
begin
 fValue:=ErResult;
 if High(fData)<>1 then Exit;

 fData[0]:=fData[0] and $1F; 
 if ((fData[0] and $10) = $10)
      then  fValue:=256-((fData[0] and $0F)*16+fData[1]/16.0)
      else  fValue:=fData[0]*16+fData[1]/16.0;
 if (fValue<-40)or(fValue>125) then fValue:=ErResult
                               else fValue:=fValue+273.16;

end;

constructor TMCP9808.Create(CP: TComPort; Nm: string);
begin
  inherited Create(CP,Nm);
  fMetterKod:=MCP9808Command;
//  SetLength(Pins.fPins,1);
  fMinDelayTime:=250;
//  RepeatInErrorCase:=True;
//  fDelayTimeStep:=2;
end;

end.
