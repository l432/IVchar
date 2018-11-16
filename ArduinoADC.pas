unit ArduinoADC;

interface

uses
  SPIdevice, CPort, Measurement, StdCtrls, MDevice, ExtCtrls;


type


  TArduinoADC_Module=class(TArduinoMeter)
  private
  protected
    FActiveChannel: byte;
    fConfigByte:byte;
   procedure PacketCreateToSend(); override;
   procedure PinsCreate();override;
   procedure Configuration();virtual;
   procedure Intitiation();virtual;
 public
   property  ActiveChannel:byte read FActiveChannel write FActiveChannel;
   constructor Create(CP:TComPort;Nm:string);override;
 end;


  TArduinoADC_Channel=class(TNamedInterfacedObject,IMeasurement)
 private
  fChanelNumber:byte;
 protected
  fParentModule:TArduinoADC_Module;
  function GetNewData:boolean;
  function GetValue:double;
  procedure SetNewData(Value:boolean);
  procedure PinsCreate();virtual;abstract;
  procedure SetModuleParameters;virtual;
 public
  Pins:TPins;
  property Value:double read GetValue;
  Constructor Create(ChanelNumber: byte; Module: TArduinoADC_Module);//override;
  Procedure Free;
  function GetData:double;
  procedure GetDataThread(WPARAM: word; EventEnd:THandle);
 end;



 TArduinoADC_ChannelShow=class(TPinsShowUniversal)
   private
    fChan:TArduinoADC_Channel;
    MeasuringDeviceSimple:TMeasuringDeviceSimple;
   protected
    procedure LabelsFilling;virtual;
   public
    Constructor Create(Chan:TArduinoADC_Channel;
                       Labels:Array of TPanel;
                       LabelMeas:TLabel;
                       ButMeas:TButton);
    Procedure Free;
 end;




implementation

uses
  PacketParameters, SysUtils;


{ TArduinoADC_Module }

procedure TArduinoADC_Module.Configuration;
begin

end;

constructor TArduinoADC_Module.Create(CP: TComPort; Nm: string);
begin
 inherited Create (CP,Nm);
 FActiveChannel:=0;
 Intitiation();
end;

procedure TArduinoADC_Module.Intitiation;
begin

end;

procedure TArduinoADC_Module.PacketCreateToSend;
begin
  Configuration();
  PacketCreate([fMetterKod,Pins.PinControl,fConfigByte]);
end;

procedure TArduinoADC_Module.PinsCreate;
begin
  Pins := TPins_I2C.Create(Name);
end;

{ TArduinoADC_Channel }

constructor TArduinoADC_Channel.Create(ChanelNumber: byte;
                   Module: TArduinoADC_Module);
begin
  inherited Create();
  fChanelNumber:=ChanelNumber;
  fParentModule:=Module;
  fName:='Ch'+inttostr(ChanelNumber+1)+'_'+Module.Name;
  PinsCreate();
end;

procedure TArduinoADC_Channel.Free;
begin
  Pins.Free;
end;

function TArduinoADC_Channel.GetData: double;
begin
 fParentModule.ActiveChannel := fChanelNumber;
 SetModuleParameters();
 Result:=fParentModule.GetData;
end;

procedure TArduinoADC_Channel.GetDataThread(WPARAM: word; EventEnd: THandle);
begin
 SetModuleParameters();
 fParentModule.GetDataThread(WPARAM,EventEnd);
end;

function TArduinoADC_Channel.GetNewData: boolean;
begin
   Result:=fParentModule.NewData;
end;

function TArduinoADC_Channel.GetValue: double;
begin
  Result:=fParentModule.Value;
end;


procedure TArduinoADC_Channel.SetModuleParameters;
begin
  fParentModule.ActiveChannel := fChanelNumber;
end;

procedure TArduinoADC_Channel.SetNewData(Value: boolean);
begin
 fParentModule.NewData:=Value;
end;

{ TArduinoADC_ChannelShow }

constructor TArduinoADC_ChannelShow.Create(Chan: TArduinoADC_Channel;
                  Labels: array of TPanel;
                  LabelMeas: TLabel;
                  ButMeas: TButton);
begin
   fChan:=Chan;
  inherited Create(fChan.Pins,Labels);
  LabelsFilling;

  MeasuringDeviceSimple:=
     TMeasuringDeviceSimple.Create(fChan,LabelMeas,srPreciseVoltage,ButMeas);

end;

procedure TArduinoADC_ChannelShow.Free;
begin
  MeasuringDeviceSimple.Free;
  inherited Free;
end;

procedure TArduinoADC_ChannelShow.LabelsFilling;
begin

end;

end.
