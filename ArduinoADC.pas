unit ArduinoADC;

interface

uses
  CPort, Measurement, StdCtrls, MDevice, ExtCtrls,
  OlegTypePart2, ArduinoDeviceNew, PacketParameters;


type


  TArduinoADC_Module=class(TArduinoMeter)
  private
   
  protected
    FActiveChannel: byte;
    fConfigByte:byte;
   procedure Configuration();virtual;
   procedure Intitiation();virtual;
   procedure FinalPacketCreateToSend();virtual;
   procedure PinsCreate();override;
   function  GetNumberByteInResult:byte;virtual;abstract;
 public
//   procedure PacketCreateToSend(); override;
   property  ActiveChannel:byte read FActiveChannel write FActiveChannel;
   property NumberByteInResult:byte read GetNumberByteInResult;
   {кількість байтів, що мають надійти у результаті}
   constructor Create(Nm:string);//override;
   procedure PrepareData;override;
   function ValueToByteArray(Value:double;var ByteAr:TArrByte):boolean;virtual;abstract;
 end;

  TArdADC_Mod_2ConfigByte=class(TArduinoADC_Module)
   protected
    fConfigByteTwo:byte;
    procedure FinalPacketCreateToSend();override;
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

  function GetDeviceKod:byte;
 public
  Pins:TPins;
  property Value:double read GetValue;
  property ParentModule:TArduinoADC_Module read fParentModule;
  Constructor Create(ChanelNumber: byte; Module: TArduinoADC_Module);//override;
//  Procedure Free;//override;
  function GetData:double;
  procedure GetDataThread(WPARAM: word; EventEnd:THandle);
  destructor Destroy; override;
  procedure SetModuleParameters;virtual;
 end;

Function TwosComplementToDouble(HiByte,LowByte:byte;LSB:double;
                                A:double=0;B:double=1):double;
{перетворення 16-бітного цілого, записаного
в комплементарному форматі в дійсне;
LSB - ціна найменшого розряду;
можливе врахування калібровки
Ureal = A + B * Umeasured;
A та В в одиницях LSB}

function IntToBin(Value: integer; Digits: integer=16): string;
{представлення цілого у вигляді двійкового рядка,
Digits - кількість цифр}


implementation

uses
  SysUtils, OlegMath;


{ TArduinoADC_Module }

procedure TArduinoADC_Module.Configuration;
begin

end;

constructor TArduinoADC_Module.Create(Nm: string);
begin
 inherited Create (Nm);
 FActiveChannel:=0;
 Intitiation();
end;

procedure TArduinoADC_Module.FinalPacketCreateToSend;
begin
  CopyToData([fMetterKod, Pins.PinControl, fConfigByte]);
//  PacketCreate([fMetterKod, Pins.PinControl, fConfigByte]);
end;

procedure TArduinoADC_Module.Intitiation;
begin
  fDelayTimeMax:=20;
end;

//procedure TArduinoADC_Module.PacketCreateToSend;
//begin
//  Configuration();
//  FinalPacketCreateToSend();
//end;


procedure TArduinoADC_Module.PinsCreate;
begin
  Pins := TPins_I2C.Create(Name);
end;

procedure TArduinoADC_Module.PrepareData;
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
  fName:=Module.Name+'_Ch'+inttostr(ChanelNumber+1);
  PinsCreate();
end;

//procedure TArduinoADC_Channel.Free;
//begin
//  Pins.Free;
//  inherited;
//end;

destructor TArduinoADC_Channel.Destroy;
begin
  Pins.Free;
  inherited;
end;

function TArduinoADC_Channel.GetData: double;
begin
 SetModuleParameters();
 Result:=fParentModule.GetData;
end;

procedure TArduinoADC_Channel.GetDataThread(WPARAM: word; EventEnd: THandle);
begin
 SetModuleParameters();
 fParentModule.GetDataThread(WPARAM,EventEnd);
end;

function TArduinoADC_Channel.GetDeviceKod: byte;
begin
 Result:=fParentModule.DeviceKod;
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


{ TArdADC_Mod_2ConfigByte }

procedure TArdADC_Mod_2ConfigByte.FinalPacketCreateToSend;
begin
  CopyToData([fMetterKod, Pins.PinControl, fConfigByte, fConfigByteTwo]);
//  PacketCreate([fMetterKod, Pins.PinControl, fConfigByte, fConfigByteTwo]);
end;

Function TwosComplementToDouble(HiByte,LowByte:byte;LSB:double;
                                A:double=0;B:double=1):double;
{перетворення 16-бітного цілого, записаного
в комплементарному форматі в дійсне;
LSB - ціна найменшого розряду;
можливе врахування калібровки
Ureal = A + B * Umeasured;
A та В в одиницях LSB}
 var temp:Int64;
begin
 temp:=LowByte+((HiByte and $7F) shl 8);
 if (HiByte and $80)>0 then
    temp:=-((not(temp)+$1)and $7fff);
 Result:=Linear(A,B,temp)*LSB;
end;


function IntToBin(Value: integer; Digits: integer=16): string;
{представлення цілого у вигляді двійкового рядка,
Digits - кількість цифр}
var
  i: integer;
begin
  result := '';
  for i := 0 to Digits - 1 do
    begin
    if Value and (1 shl i) > 0 then
      result := '1' + result
    else
      result := '0' + result;
     if (((i+1) mod 4)=0) then Result:=' '+Result;

    end;
end;

end.
