unit GDS_806S;

interface

uses
  RS232device, CPort;

const
  GDS_806S_PacketBeginChar='';
  GDS_806S_PacketEndChar=#10;

type

  TGDS_806S=class(TRS232Meter)
  private
//    fAUTO:Boolean;
//    {TRUE при автоматичному виборі діапазону вимірювань та FALSE при ручному}
//    fOUT: Boolean;
//    {TRUE при зашкалюванні}
//    fDiapazoneModeAll:array of string;
//    procedure NamesFilling;virtual;
//    procedure DiapazonFilling(DiapazonNumber:byte;
//                              D_Begin, D_End:TUT70_Diapazons);overload;
//    procedure MeasureModesFilling;virtual;
//    procedure DiapazonsFilling;virtual;
//    procedure DiapasonModesFilling;
   protected
     Procedure PacketReceiving(Sender: TObject; const Str: string);override;
//     Procedure MModeDetermination(Data:array of byte);override;
//     Procedure DiapazonDetermination(Data:array of byte);override;
//     Procedure ValueDetermination(Data:array of byte);override;
//     Function MeasureModeLabelRead():string;override;
//    Function Measurement():double;override;
   public
     Constructor Create(CP:TComPort;Nm:string);override;
     procedure Request();override;
  end;

var
  StringToSend:string;

implementation

uses
  Dialogs;

{ TGDS_806S }

constructor TGDS_806S.Create(CP: TComPort; Nm: string);
begin
 inherited Create(CP,Nm);
 RepeatInErrorCase:=True;
 fComPacket.MaxBufferSize:=250052;
 fComPacket.StartString := GDS_806S_PacketBeginChar;
 fComPacket.StopString := GDS_806S_PacketEndChar;
// NamesFilling;
end;

procedure TGDS_806S.PacketReceiving(Sender: TObject; const Str: string);
begin
showmessage(STR);
fIsReceived:=True;
//fIsReady:=True;
fValue:=0;

end;

procedure TGDS_806S.Request;
begin
// StringToSend:='lrn?';
 StringToSend:='*idn?';
// StringToSend:=':meas:vpp?';
 if fComPort.Connected then
  begin
   fComPort.AbortAllAsync;
   fComPort.ClearBuffer(True, True);
   fError:=(fComPort.WriteStr(StringToSend+GDS_806S_PacketEndChar)<>(Length(StringToSend)+1));
  end
                      else
   fError:=True;
end;

end.
