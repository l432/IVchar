unit K2450;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdTelnet,OlegFunction, IdAntiFreezeBase,
  IdAntiFreeze, OleCtrls, SHDocVw, Registry, ToolWin, ComCtrls, SHDocVw_EWB,
  EmbeddedWB;

type
  TForm1 = class(TForm)
    Button1: TButton;
    IdTelnet1: TIdTelnet;
    IdAntiFreeze1: TIdAntiFreeze;
    Button2: TButton;
    Button3: TButton;
    CoolBar1: TCoolBar;
    EmbeddedWB1: TEmbeddedWB;
    procedure Button1Click(Sender: TObject);
    procedure IdTelnet1DataAvailable(Sender: TIdTelnet; const Buffer: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

Procedure StringToIdTelnet(str:string;TN: TIdTelnet);

implementation

{$R *.dfm}

Procedure StringToIdTelnet(str:string;TN: TIdTelnet);
 var i:integer;
begin
  if not(TN.Connected) then Exit;
  for I := 1 to length(str) do
     TN.SendCh(char(str[i]));
  TN.SendCh(#10);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
showmessage('Hi '+INTTOSTR(IdTelnet1.Port));
//IdTelnet1.Terminal;
IdTelnet1.Host:='192.168.2.5';
IdTelnet1.ConnectTimeout:=1000;
try
 if IdTelnet1.Connected then IdTelnet1.Disconnect();

IdTelnet1.Connect;
except

end;
//DelaySleep(1000);
if IdTelnet1.Connected then showmessage('Yes')
                       else showmessage('No');
IdTelnet1.ReadTimeout:=1000;
//StringToIdTelnet('sour:volt:ilim 0.5',IdTelnet1);

StringToIdTelnet('*idn?',IdTelnet1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
//  WebBrowser1.Navigate('192.168.2.5');
  EmbeddedWB1.Navigate('192.168.2.6');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    EmbeddedWB1.Refresh;
//     WebBrowser1.Refresh2;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if IdTelnet1.Connected then  IdTelnet1.Disconnect;
end;


procedure TForm1.FormCreate(Sender: TObject);
//var
//  Reg: TRegistry;
begin
//  WebBrowser1.Silent := True;
//  Reg := TRegistry.Create;
//  try
//    Reg.OpenKey('\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION\', True);
//    Reg.WriteInteger(ExtractFileName(Application.ExeName), 11000);
//  finally
//    Reg.Free;
//  end;
 EmbeddedWB1.Silent := True;
end;

procedure TForm1.IdTelnet1DataAvailable(Sender: TIdTelnet;
  const Buffer: string);
 var i:integer;
  temp:string;
begin
 temp:=Buffer+#10;
 for I := 1 to Length(Buffer) do
   temp:=temp+Format('$%x ',[ord(Buffer[i])]);
 showmessage(temp);
end;

end.
