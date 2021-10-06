unit SCPI;

interface

uses
  RS232deviceNew, CPort;

const
  TestShow=True;

  SCPI_PacketBeginChar='';
  SCPI_PacketEndChar=#10;

type

  TRS232_SCPI=class(TRS232)
    protected
    public
     Constructor Create(CP:TComPort;BufferInputSize:Integer=1024;
                                    MaxBufferSize:Integer=1024);
    end;

  TDataRequest_SCPI=class(TCDDataRequest)
    protected
     function IsNoSuccessSend:Boolean;override;
    public
     procedure Request;override;
  end;

  TSCPI=class(TRS232MeterDeviceSingle)
    protected
     procedure CreateDataRequest;override;
  end;

var
  StringToSend:string;

implementation

uses
  Dialogs, SysUtils;

{ TRS232_SCPI }

constructor TRS232_SCPI.Create(CP: TComPort; BufferInputSize,
                               MaxBufferSize: Integer);
begin
 inherited Create(CP,SCPI_PacketBeginChar,SCPI_PacketEndChar);
 fComPacket.MaxBufferSize:=MaxBufferSize;
 fComPort.Buffer.InputSize:=BufferInputSize;
end;

{ TDataRequest_SCPI }

function TDataRequest_SCPI.IsNoSuccessSend: Boolean;
begin
// showmessage(inttostr(fRS232.ComPort.WriteStr(StringToSend+SCPI_PacketEndChar)));
// showmessage(inttostr(Length(StringToSend)+1));
 Result:=(fRS232.ComPort.WriteStr(StringToSend+SCPI_PacketEndChar)<>(Length(StringToSend)+1));
end;

procedure TDataRequest_SCPI.Request;
begin
 if TestShow then showmessage('send:  '+StringToSend);
 inherited Request;
end;

{ TSCPI }

procedure TSCPI.CreateDataRequest;
begin
 fDataRequest:=TDataRequest_SCPI.Create(Self.fDataSubject.RS232,Self);
end;

end.
