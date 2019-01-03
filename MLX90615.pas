unit MLX90615;

interface

uses
  TemperatureSensor, CPort;

type

 TMLX_States=(mlx_tObject,mlx_tAmbient,mlx_gcRead,mlx_gcWrite);


const
  MLX90615_Adress=$5B;
  MLX90615_GrayCoefficientMax=$4000;
  MLX90615_OperationCod:array [TMLX_States]  of byte=
  ($27,$26,$13,$43);

type

 TMLX90615=class(TTempSensor)
  {базовий клас для датчика MLX90615}
  private
   fstate:TMLX_States;
   fGrayCoefficient:Word;
  protected
   Function CRCCorrect():boolean;
   Procedure PacketCreateToSend();override;
  public
   function GetTemperature():double;override;
   Constructor Create(CP:TComPort;Nm:string);
   Procedure ConvertToValue();override;
  end;

implementation

uses
  PacketParameters;

{ TMLX90615 }

procedure TMLX90615.ConvertToValue;
begin
  inherited;

end;

function TMLX90615.CRCCorrect: boolean;
begin
 if fstate=mlx_gcWrite then
    Result:= (CRC8([$B6,$13,$B7,fData[0],fData[1],fData[2]])=0)
                       else
    Result:= (CRC8([$B6,MLX90615_OperationCod[fstate],$B7,fData[0],fData[1],fData[2]])=0);
end;

constructor TMLX90615.Create(CP: TComPort; Nm: string);
begin
  inherited Create(CP,Nm);

  fMetterKod:=MLX90615Command;
  SetLength(Pins.fPins,1);
  Pins.PinControl:=MLX90615_Adress;
  fMinDelayTime:=350;
  fstate:=mlx_tObject;
  fGrayCoefficient:=MLX90615_GrayCoefficientMax;
end;

function TMLX90615.GetTemperature: double;
begin
 fstate:=mlx_tObject;
// fMinDelayTime:=350;
 Result:=Measurement();
end;

procedure TMLX90615.PacketCreateToSend;
begin
 case fstate of
   mlx_tObject:  PacketCreate([fMetterKod,Pins.PinControl,MLX90615_OperationCod[fstate]]);
   mlx_tAmbient: ;
   mlx_gcRead: ;
   mlx_gcWrite: ;
 end;

end;

end.
