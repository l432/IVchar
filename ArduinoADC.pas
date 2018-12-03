unit ArduinoADC;

interface

uses
  ArduinoDevice, CPort, Measurement, StdCtrls, MDevice, ExtCtrls;


type


  TArduinoADC_Module=class(TArduinoMeter)
  private

  protected
    FActiveChannel: byte;
    fConfigByte:byte;
   procedure PacketCreateToSend(); override;
   procedure Configuration();virtual;
   procedure Intitiation();virtual;
   procedure FinalPacketCreateToSend();virtual;
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

procedure TArduinoADC_Module.FinalPacketCreateToSend;
begin
  PacketCreate([fMetterKod, Pins.PinControl, fConfigByte]);
end;

procedure TArduinoADC_Module.Intitiation;
begin
   fDelayTimeMax:=20;
end;

procedure TArduinoADC_Module.PacketCreateToSend;
begin
  Configuration();
  FinalPacketCreateToSend();
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


end.
