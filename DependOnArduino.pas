unit DependOnArduino;

interface

uses
  Dependence, ArduinoDeviceNew, PacketParameters;


type

 TFastArduinoIVDependence=class (TFastIVDependence)
  private
   fArduinoCommunication:TArduinoMeter;
  public
   property ArduinoCommunication:TArduinoMeter read fArduinoCommunication;
 end;


 TArdIVDepen=class(TArduinoMeter)
  private
   fFArdIVD:TFastArduinoIVDependence;
  public
   Constructor Create(Nm:string;
                      FArdIVD:TFastArduinoIVDependence);
   procedure PacketCreateToSend();override;                   
 end;


implementation

{ TArdIVDepen }

constructor TArdIVDepen.Create(Nm: string; FArdIVD: TFastArduinoIVDependence);
begin
  inherited Create(Nm);
  fFArdIVD:=FArdIVD;
  fDelayTimeMax:=1300;
end;

procedure TArdIVDepen.PacketCreateToSend;
begin
 PacketCreate(fData);
end;

end.
