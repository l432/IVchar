unit TelnetDevice;

interface

uses
  IdTelnet, ShowTypes;

type

TTelnet=class
  {початкові налаштування COM-порту}
  protected
   fIdTelnet:TIdTelnet;
   fIPAdressShow:TIPAdressShow;
//   fComPacket: TComDataPacket;
  public
//   property ComPort:TComPort read fComPort;
//   property ComPacket:TComDataPacket read fComPacket;
   Constructor Create(IdTelnet:TIdTelnet; IPAdressShow:TIPAdressShow);
//   destructor Destroy;override;
//   Function IsSend(report:string):boolean;
  end;

implementation

{ TTelnet }

constructor TTelnet.Create(IdTelnet: TIdTelnet; IPAdressShow: TIPAdressShow);
begin
  inherited Create();
  fIdTelnet:=IdTelnet;
  fIPAdressShow:=IPAdressShow;
  fIPAdressShow.IdTelnet:=fIdTelnet;
  fIPAdressShow.IPUpDate;
end;

end.
