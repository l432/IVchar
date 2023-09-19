unit TelnetDevice;

interface

uses
  IdTelnet, ShowTypes, OlegTypePart2, RS232deviceNew;

//const
//  TestShowEthernet=False;
//  TestShowEthernet=True;
//  DeviceEthernetisAbsent=False;
//  DeviceEthernetisAbsent=True;

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
  procedure CreateDataSubject(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow);virtual;
  procedure CreateDataRequest;
  function GetIPAdressShow:TIPAdressShow;
  function GetMessageError:string;override;
  function GetStringToSendActual:string;
 public
  property IPAdressShow:TIPAdressShow read GetIPAdressShow;
  property StringToSendActual:string read GetStringToSendActual;
  Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;Nm:string);
  destructor Destroy;override;
  Procedure Request();override;
  Procedure SetStringToSend(StringToSend:string);override;
  procedure ClearStringToSend;override;
  procedure JoinToStringToSend(AdditionalString:string);override;
  function GetData():double;override;
//  procedure GetDataThread(WPARAM: word;EventEnd:THandle);override;

end;

var
 TestShowEthernet,DeviceEthernetisAbsent:boolean;

implementation

uses
  Dialogs, SCPI, SysUtils, OlegType, OlegFunction, StrUtils;

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
//  try
//   if fIdTelnet.Connected then fIdTelnet.Disconnect();
//   fIdTelnet.Connect;
//  except
//
//  end;
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
//  fReceivedString:=Str{+SCPI_PacketEndChar};
  fReceivedString:=fReceivedString+Str;
  NotifyObservers();

//  HelpForMe(Str,'s'+inttostr(MilliSecond));
//  HelpForMe(fReceivedString,'s'+inttostr(MilliSecond));
//  HelpForMe(AnsiReplaceStr(fReceivedString,',',#10#13),'s'+inttostr(MilliSecond));
end;

function TTelnetDataSubjectSingle.PortConnected: boolean;
begin
//showmessage(fTelnet.fIdTelnet.Host);
 try
//  if fTelnet.fIdTelnet.Connected then fTelnet.fIdTelnet.Disconnect();
//  fTelnet.fIdTelnet.Connect;
  if not(fTelnet.fIdTelnet.Connected)
   then fTelnet.fIdTelnet.Connect;


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
 Result:=not(fTelnet.SendString());
end;

procedure TDataRequestTelnet.Request;
begin
 if DeviceEthernetisAbsent
    then showmessage('Virtual send:  '+fTelnet.fStringToSend)
    else
      begin
      if TestShowEthernet then showmessage('send:  '+fTelnet.fStringToSend);
      inherited Request;
      end;
end;

{ TTelnetMeterDeviceSingle }

procedure TTelnetMeterDeviceSingle.ClearStringToSend;
begin
 fDataRequest.fTelnet.fStringToSend:='';
end;

constructor TTelnetMeterDeviceSingle.Create(Telnet: TIdTelnet;
             IPAdressShow: TIPAdressShow; Nm: string);
begin

//  fDataSubject:=TTelnetDataSubjectSingle.Create(Telnet,IPAdressShow);
  CreateDataSubject(Telnet,IPAdressShow);
  inherited Create(Nm);
  SetDataSubject(fDataSubject);
//  fIDataSubject:=fDataSubject;
  fDataSubject.RegisterObserver(Self);
  CreateDataRequest;
//  fMessageError:=fName+' on '+fDataSubject.fTelnet.Telnet.Host+ErrorMes;
end;

procedure TTelnetMeterDeviceSingle.CreateDataRequest;
begin
 fDataRequest:=TDataRequestTelnet.Create(Self.fDataSubject.Telnet,Self);
end;

procedure TTelnetMeterDeviceSingle.CreateDataSubject(Telnet: TIdTelnet;
                        IPAdressShow: TIPAdressShow);
begin
 fDataSubject:=TTelnetDataSubjectSingle.Create(Telnet,IPAdressShow);
end;

destructor TTelnetMeterDeviceSingle.Destroy;
begin
  FreeAndNil(fDataRequest);
  FreeAndNil(fDataSubject);
  inherited;
end;

function TTelnetMeterDeviceSingle.GetData: double;
begin
  Result:=ErResult;

// if DeviceEthernetisAbsent
//    then
//     begin
//     showmessage('Virtual send:  '+fDataRequest.fTelnet.fStringToSend);
//     Exit;
//     end;

  fDataSubject.fReceivedString:='';

  if DeviceEthernetisAbsent or fDataSubject.PortConnected then
   begin
    Result:=Measurement();
    fNewData:=True;
   end
                                      else
   begin
     fError:=True;
     showmessage(MessageError);
   end;
end;

//procedure TTelnetMeterDeviceSingle.GetDataThread(WPARAM: word;
//  EventEnd: THandle);
//begin
// if DataSubject.PortConnected then
//   begin
//   fRS232MeasuringTread:=TRS232MeasuringTread.Create(Self,WPARAM,EventEnd);
//
//   end;
//end;

function TTelnetMeterDeviceSingle.GetIPAdressShow: TIPAdressShow;
begin
 Result:=fDataSubject.Telnet.IPAdressShow;
end;

function TTelnetMeterDeviceSingle.GetMessageError: string;
begin
 Result:=fName+' on '+fDataSubject.fTelnet.Telnet.Host+ErrorMes;
end;

function TTelnetMeterDeviceSingle.GetStringToSendActual: string;
begin
 Result:=fDataRequest.fTelnet.fStringToSend;
end;

procedure TTelnetMeterDeviceSingle.JoinToStringToSend(AdditionalString: string);
begin
 fDataRequest.fTelnet.fStringToSend:=fDataRequest.fTelnet.fStringToSend+AdditionalString;
end;

procedure TTelnetMeterDeviceSingle.Request;
begin
 fDataRequest.Request;
end;

procedure TTelnetMeterDeviceSingle.SetStringToSend(StringToSend: string);
begin
 fDataRequest.fTelnet.fStringToSend:=StringToSend;
end;

end.
