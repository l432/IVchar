unit TelnetDevice;

interface

uses
  IdTelnet, ShowTypes, OlegTypePart2, RS232deviceNew;

const
//  TestShowEthernet=False;
  TestShowEthernet=True;

type

TTelnet=class
  {початкові налаштування Telnet-порту}
  protected
   fIdTelnet:TIdTelnet;
   fIPAdressShow:TIPAdressShow;
   fStringToSend:string;
  public
   property Telnet:TIdTelnet read fIdTelnet;
   property IPAdressShow:TIPAdressShow read fIPAdressShow;
//   property StringToSend:string read fStringToSend;
   Constructor Create(IdTelnet:TIdTelnet; IPAdressShow:TIPAdressShow);
   destructor Destroy;override;
   Function IsSend(report:string):boolean;
   Function SendString:boolean;
  end;

TTelnetDataSubjectSingle=class(TDataSubjectSingle)
 protected
  fTelnet:TTelnet;
  Procedure PacketReceiving(Sender: TIdTelnet; const Str: string);
  function PortConnected():boolean;override;
 public
  property Telnet:TTelnet read fTelnet;
  Constructor Create(IdTelnet:TIdTelnet; IPAdressShow:TIPAdressShow);
  destructor Destroy;override;
end;

TDataRequestTelnet=class(TDataRequestNew{,IRS232DataRequest})
  protected
   fTelnet:TTelnet;
//   procedure PreparePort;override;
   function IsNoSuccessSend:Boolean;override;
   function Connected:boolean;override;
  public
   Constructor Create(Telnet:TTelnet;CustomDevice:TCustomDevice);
   procedure Request;override;
end;

TTelnetMeterDeviceSingle=class(TMeterDevice)
{вимірювальний пристрій для Eternet}
 protected
  fDataSubject:TTelnetDataSubjectSingle;
  fDataRequest:TDataRequestTelnet;
//  procedure CreateDataSubject(Telnet:TIdTelnet);virtual;abstract;
  procedure CreateDataRequest;
  function GetIPAdressShow:TIPAdressShow;
 public
  property IPAdressShow:TIPAdressShow read GetIPAdressShow;
  Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;Nm:string);
  destructor Destroy;override;
  Procedure Request();override;
end;

implementation

uses
  Dialogs, SCPI, SysUtils;

{ TTelnet }

constructor TTelnet.Create(IdTelnet: TIdTelnet; IPAdressShow: TIPAdressShow);
begin
  inherited Create();
  fIdTelnet:=IdTelnet;
  fIPAdressShow:=IPAdressShow;
  fIPAdressShow.IdTelnet:=fIdTelnet;
  fIPAdressShow.IPUpDate;
  fIdTelnet.ConnectTimeout:=1000;
  fIdTelnet.ReadTimeout:=1000
end;

destructor TTelnet.Destroy;
begin
  if fIdTelnet.Connected then fIdTelnet.Disconnect;
  inherited;
end;

function TTelnet.IsSend(report: string): boolean;
begin
 Result:=SendString();
 if not(Result) then MessageDlg(report,mtError, [mbOK], 0);
end;

function TTelnet.SendString: boolean;
 var i:integer;
begin
  Result:=False;
  try
   if fIdTelnet.Connected then fIdTelnet.Disconnect();
   fIdTelnet.Connect;
  except

  end;
  if fIdTelnet.Connected
   then
    begin
     Result:=True;
     for I := 1 to length(fStringToSend) do
       fIdTelnet.SendCh(char(fStringToSend[i]));
     fIdTelnet.SendCh(SCPI_PacketEndChar);
    end;
//   else Result:=False;
end;

constructor TTelnetDataSubjectSingle.Create(IdTelnet: TIdTelnet;
  IPAdressShow: TIPAdressShow);
begin
  fTelnet:=TTelnet.Create(IdTelnet,IPAdressShow);
  fTelnet.fIdTelnet.OnDataAvailable:=PacketReceiving;
  fObserver:=nil;
end;

destructor TTelnetDataSubjectSingle.Destroy;
begin
 FreeAndNil(fTelnet);
 inherited;
end;

procedure TTelnetDataSubjectSingle.PacketReceiving(Sender: TIdTelnet;
  const Str: string);
begin
  fReceivedString:=Str+SCPI_PacketEndChar;
  NotifyObservers();
end;

function TTelnetDataSubjectSingle.PortConnected: boolean;
begin
 try
   Result:=fTelnet.fIdTelnet.Connected;
 except
   Result:=False;
 end;
end;

{ TDataRequestTelnet }

function TDataRequestTelnet.Connected: boolean;
begin
 Result:=fTelnet.fIdTelnet.Connected;
end;

constructor TDataRequestTelnet.Create(Telnet: TTelnet;
  CustomDevice: TCustomDevice);
begin
 inherited Create(CustomDevice);
 fTelnet:=Telnet;
end;

function TDataRequestTelnet.IsNoSuccessSend: Boolean;
begin
 Result:=fTelnet.SendString();
end;

procedure TDataRequestTelnet.Request;
begin
 if TestShowEthernet then showmessage('send:  '+fTelnet.fStringToSend);
 inherited Request;
end;

{ TTelnetMeterDeviceSingle }

constructor TTelnetMeterDeviceSingle.Create(Telnet: TIdTelnet;
             IPAdressShow: TIPAdressShow; Nm: string);
begin
  fDataSubject:=TTelnetDataSubjectSingle.Create(Telnet,IPAdressShow);
//  CreateDataSubject(Telnet);
  inherited Create(Nm);
  Self.DataSubject:=fDataSubject;
  fDataSubject.RegisterObserver(Self);
  CreateDataRequest;
end;

procedure TTelnetMeterDeviceSingle.CreateDataRequest;
begin
 fDataRequest:=TDataRequestTelnet.Create(Self.fDataSubject.Telnet,Self);
end;

destructor TTelnetMeterDeviceSingle.Destroy;
begin
  FreeAndNil(fDataRequest);
  FreeAndNil(fDataSubject);
  inherited;
end;

function TTelnetMeterDeviceSingle.GetIPAdressShow: TIPAdressShow;
begin
 Result:=fDataSubject.Telnet.IPAdressShow;
end;

procedure TTelnetMeterDeviceSingle.Request;
begin
 fDataRequest.Request;
end;

end.
