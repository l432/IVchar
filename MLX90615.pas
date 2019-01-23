unit MLX90615;

interface

uses
  TemperatureSensor, CPort, IniFiles, StdCtrls, ShowTypes, MDevice, 
  Measurement, OlegShowTypes, OlegTypePart2;

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
   fNewGrCoef:Word;
  protected
   Function CRCCorrect():boolean;
   Procedure PacketCreateToSend();override;
  public
   function GetTemperature():double;override;
   Constructor Create(CP:TComPort;Nm:string);
   Procedure ConvertToValue();override;
   function GetTemperatureAmbient():double;
   function ReadGrayCoefficient():double;
   function WriteGrayCoefficient(NewCoef:double):boolean;overload;
   function WriteGrayCoefficient(NewCoef:word):boolean;overload;
   function GrayCoefToWord(const NewCoef:double):word;
   function GrayCoefToDouble(const NewCoef:word):double;
   function GetGrayCoefficient():double;
   procedure Calibration(TempSensor:ITemperatureMeasurement);
  end;

 TMLX90615Show=class(TSimpleFreeAndAiniObject)
  private
   fMLX90615:TMLX90615;
   fGrayScaleShow:TDoubleParameterShow;
   fTemperature_MD:TTemperature_MD;
   procedure RefreshData;
   procedure ReadButtonClick(Sender:TObject);
   procedure WriteButtonClick(Sender:TObject);
   procedure CalibrateButtonClick(Sender:TObject);
  public
   Constructor Create(MLX:TMLX90615;
                      STGrayC:TStaticText;
                      BRead,BWrite,Bcalibr:TButton;
                      TTemp_MD:TTemperature_MD);
   procedure Free;override;
   procedure ReadFromIniFile(ConfigFile:TIniFile);override;
   procedure WriteToIniFile(ConfigFile:TIniFile);override;
 end;

implementation

uses
  PacketParameters, OlegType, Math;

{ TMLX90615 }

procedure TMLX90615.Calibration(TempSensor: ITemperatureMeasurement);
 var SensorTemp,SelfTemp:double;
     limitA,limitB,NewGrayCoef:word;
begin
 SensorTemp:=TempSensor.GetTemperature;
 if SensorTemp=ErResult then Exit;

 SelfTemp:=Self.GetTemperature;
 limitA:=0;
 limitB:=MLX90615_GrayCoefficientMax;
 while (SelfTemp<>ErResult)and(abs(SensorTemp-SelfTemp)>0.03) do
  begin
    if SensorTemp>SelfTemp then
       begin
         if fGrayCoefficient=MLX90615_GrayCoefficientMax then Exit;
         NewGrayCoef:=min(word((limitB+fGrayCoefficient) shr 2),MLX90615_GrayCoefficientMax);
         limitA:=fGrayCoefficient;
       end                 else
//    if SensorTemp<SelfTemp then
       begin
         if fGrayCoefficient=0 then Exit;
         NewGrayCoef:=word((limitA+fGrayCoefficient) shr 2);
         limitB:=fGrayCoefficient;
       end;
    if abs(NewGrayCoef-fGrayCoefficient)<2 then Exit;
    if not(WriteGrayCoefficient(NewGrayCoef)) then Exit;
    SelfTemp:=Self.GetTemperature;
  end;
end;

procedure TMLX90615.ConvertToValue;
 var temp:word;
begin
// ShowData(fData);
// fValue:=ErResult;
 if High(fData)<>2 then Exit;
 if not(CRCCorrect()) then Exit;

 temp:=((fData[1] shl 8) or  fData[0]) and $7FFF;
 if (fstate in [mlx_tObject,mlx_tAmbient])and
     InRange(temp,$2D8A,$4BD0)
//     (temp>=$2D8A)and(temp<=$4BD0)
       then fValue:=temp*0.02;

 if (fstate in [mlx_gcRead,mlx_gcWrite])and(temp<=MLX90615_GrayCoefficientMax)
   then
    begin
      fValue:=GrayCoefToDouble(temp);
      fGrayCoefficient:=temp;
    end;
 fstate:=mlx_tObject;
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
//  fMinDelayTime:=350;
  fstate:=mlx_tObject;
  fGrayCoefficient:=MLX90615_GrayCoefficientMax;

end;

function TMLX90615.GetGrayCoefficient: double;
begin
 Result:=GrayCoefToDouble(fGrayCoefficient);
end;

function TMLX90615.GetTemperature: double;
begin
 fstate:=mlx_tObject;
 Result:=Measurement();
end;

function TMLX90615.GetTemperatureAmbient: double;
begin
 fstate:=mlx_tAmbient;
 Result:=Measurement();
end;

function TMLX90615.GrayCoefToDouble(const NewCoef: word): double;
begin
 Result:=min(NewCoef,MLX90615_GrayCoefficientMax)/MLX90615_GrayCoefficientMax;
end;

function TMLX90615.GrayCoefToWord(const NewCoef: double): word;
begin
  if Frac(NewCoef)=0 then Result:=MLX90615_GrayCoefficientMax
                     else Result:=round(abs(Frac(NewCoef))*MLX90615_GrayCoefficientMax);
end;

procedure TMLX90615.PacketCreateToSend;
begin
 if fstate in [mlx_tObject,mlx_tAmbient,mlx_gcRead]
  then  PacketCreate([fMetterKod,Pins.PinControl,MLX90615_OperationCod[fstate]])
  else  PacketCreate([fMetterKod,Pins.PinControl,MLX90615_OperationCod[fstate],
              Lo(fNewGrCoef),Hi(fNewGrCoef),
              CRC8([$b6,$13,Lo(fNewGrCoef),Hi(fNewGrCoef)])]);
end;

function TMLX90615.ReadGrayCoefficient: double;
begin
 fstate:=mlx_gcRead;
 Result:=Measurement();
end;

function TMLX90615.WriteGrayCoefficient(NewCoef: word): boolean;
begin
  fNewGrCoef:=min(NewCoef,MLX90615_GrayCoefficientMax);
  fstate:=mlx_gcWrite;
  Measurement();
  Result:=(fGrayCoefficient=fNewGrCoef);
end;

function TMLX90615.WriteGrayCoefficient(NewCoef: double): boolean;
begin
  Result:=WriteGrayCoefficient(GrayCoefToWord(NewCoef));
end;

{ TMLX90615Show }

procedure TMLX90615Show.CalibrateButtonClick(Sender: TObject);
begin
 fMLX90615.Calibration(fTemperature_MD.ActiveInterface);
 RefreshData();
end;

constructor TMLX90615Show.Create(MLX: TMLX90615;
                                STGrayC: TStaticText;
                                BRead, BWrite, Bcalibr: TButton;
                                TTemp_MD:TTemperature_MD);
begin
 fMLX90615:=MLX;
 fGrayScaleShow:=TDoubleParameterShow.Create(STGrayC,'GrayCoef',1,5);
 fGrayScaleShow.ForUseInShowObject(fMLX90615);
 BRead.OnClick:=ReadButtonClick;
 BWrite.OnClick:=WriteButtonClick;
 Bcalibr.OnClick:=CalibrateButtonClick;
 fTemperature_MD:=TTemp_MD;
end;

procedure TMLX90615Show.Free;
begin
 fGrayScaleShow.Free;
end;

procedure TMLX90615Show.ReadButtonClick(Sender: TObject);
begin
 fMLX90615.ReadGrayCoefficient();
 RefreshData();
end;

procedure TMLX90615Show.ReadFromIniFile(ConfigFile: TIniFile);
begin
 fGrayScaleShow.ReadFromIniFile(ConfigFile);
end;

procedure TMLX90615Show.RefreshData;
begin
 fGrayScaleShow.Data:=fMLX90615.GetGrayCoefficient();
 fGrayScaleShow.ColorToActive(true);
end;

procedure TMLX90615Show.WriteButtonClick(Sender: TObject);
begin
 fMLX90615.WriteGrayCoefficient(fGrayScaleShow.Data);
 RefreshData();
end;

procedure TMLX90615Show.WriteToIniFile(ConfigFile: TIniFile);
begin
 fGrayScaleShow.WriteToIniFile(ConfigFile);
end;

end.
