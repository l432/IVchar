unit IVchar_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPort, ComCtrls, Buttons, V721, ExtCtrls, IniFiles,PacketParameters;

type
  TIVchar = class(TForm)
    ComPort1: TComPort;
    Label1: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    PC: TPageControl;
    TS_Main: TTabSheet;
    TS_B7_21A: TTabSheet;
    BitBtn1: TBitBtn;
    LConnected: TLabel;
    BConnect: TButton;
    LV721A: TLabel;
    RGV721A_MM: TRadioGroup;
    RGV721ARange: TRadioGroup;
    BV721AMeas: TButton;
    SBV721AAuto: TSpeedButton;
    Time: TTimer;
    LV721AU: TLabel;
    TS_B7_21: TTabSheet;
    PanelV721_I: TPanel;
    RGV721_I: TRadioGroup;
    ComDPacket: TComDataPacket;
    BParamReceive: TButton;
    procedure Button1Click(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure ComPort1RxBuf(Sender: TObject; const Buffer; Count: Integer);
    procedure FormCreate(Sender: TObject);
    procedure PortConnected();
    procedure BConnectClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComDataPacket1Packet(Sender: TObject; const Str: string);
    procedure ComDataPacket1Discard(Sender: TObject; const Str: string);
    procedure BV721AMeasClick(Sender: TObject);
    procedure SBV721AAutoClick(Sender: TObject);
    procedure PCChange(Sender: TObject);
    procedure RGV721ARangeClick(Sender: TObject);
    procedure RGV721A_MMClick(Sender: TObject);
  private
    { Private declarations }
//   fPacket:array of byte;
  public
    V721A:TV721A;
    V721_I,V721_II:TV721;
    procedure VoltmetrConnect(Voltmetr:TVoltmetr;PinNumber:byte);
    Procedure VotmetrToForm({Voltmetr:TVoltmetr});
  end;

//const
//  PacketBegin=10;
//  PacketEnd=13;

var
  Main: TIVchar;
//  V721A:TV721A;
//  V721_I,V721_II:TV721;
  NumberPins:Array of byte; // номери пінів, які використовуються як керуючі для SPIE

//Procedure VotmetrToForm(Voltmetr:TVoltmetr;Form: TIVchar);

implementation

{$R *.dfm}

procedure TIVchar.BConnectClick(Sender: TObject);
begin
 try
  ComPort1.Connected:=not(ComPort1.Connected);
  if ComPort1.Connected then
   begin
    ComPort1.ClearBuffer(True, True);
    ComPort1.AbortAllAsync;
   end;
 finally
  PortConnected();
 end;
end;

procedure TIVchar.Button1Click(Sender: TObject);
//var Str:string;
var B:byte;
begin
V721A.Request();
//showmessage(booltostr(V721A.Request()));
//b:=strtoint(Edit1.Text);
//ComPort1.Write(b,1);

//b:=15;
//Label1.Caption:=inttostr(BCDtoDec(b,True))
//               +inttostr(BCDtoDec(b,False));
end;



procedure TIVchar.BV721AMeasClick(Sender: TObject);
begin
 if not(ComPort1.Connected) then
    begin
      PortConnected();
      Exit;
    end;
 V721A.Measurement();
 VotmetrToForm({V721A});
end;

procedure TIVchar.ComDataPacket1Discard(Sender: TObject; const Str: string);
begin
 showmessage('Noooo');
end;

procedure TIVchar.ComDataPacket1Packet(Sender: TObject; const Str: string);
 var tempstr:string;
     i:integer;

begin
 showmessage('Hi '+inttostr(Length(Str)));
  tempstr:='';
 for I := 1 to Length(Str) do
  tempstr:=tempstr+' '+inttostr(ord(str[i]));
  showmessage(tempstr);
end;

procedure TIVchar.ComPort1RxBuf(Sender: TObject; const Buffer; Count: Integer);
var Str:string;
begin
//showmessage('Hi2');
//ComPort1.ReadStr(Str, 2);
//
//Label1.Caption:=inttostr(byte(Length(Str)));
//Label1.Caption:=Str;
end;

procedure TIVchar.ComPort1RxChar(Sender: TObject; Count: Integer);
var Str:string;
    B,i:byte;
begin
//for I := 0 to Count - 1 do
// begin
//   ComPort1.Read(B,1);
//   Label1.Caption:=Label1.Caption+' '+inttostr(B);
// end;

end;

procedure TIVchar.FormCreate(Sender: TObject);
 var i,TempPin:integer;
     ConfigFile:TIniFile;
begin
 DecimalSeparator:='.';
 RGV721A_MM.Items.Clear;
 for I := 0 to ord(MMErr) do
  begin
   RGV721A_MM.Items.Add(MeasureModeLabels[TMeasureMode(i)])
  end;
 RGV721A_MM.ItemIndex:=4;
 LV721AU.Caption:='';
 DiapazonFill(TMeasureMode(RGV721A_MM.ItemIndex),
               RGV721ARange.Items);

 ConfigFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'IVChar.ini');
 SetLength(NumberPins,ConfigFile.ReadInteger('PinNumbers','PinCount',3));
 for I := 0 to High(NumberPins) do
    NumberPins[i]:=ConfigFile.ReadInteger('PinNumbers','Pin'+IntToStr(i),100);

 TempPin:=ConfigFile.ReadInteger('PinNumbers','V721A',-1);
 if (TempPin>-1)and(TempPin<High(NumberPins)) then
     VoltmetrConnect(V721A,NumberPins[TempPin]);
 TempPin:=ConfigFile.ReadInteger('PinNumbers','V721_I',-1);
 if (TempPin>-1)and(TempPin<High(NumberPins)) then
     VoltmetrConnect(V721_I,NumberPins[TempPin]);
 TempPin:=ConfigFile.ReadInteger('PinNumbers','V721_II',-1);
 if (TempPin>-1)and(TempPin<High(NumberPins)) then
     VoltmetrConnect(V721_II,NumberPins[TempPin]);
 ConfigFile.Free;

// V721A:= TV721A.Create(26);
// V721A.ComPort:=ComPort1;
// V721A.fComPacket.ComPort:=ComPort1;

 VotmetrToForm();


// if not(assigned(V721A)) then
//    begin
//      BV721AMeas.Enabled:=False;
//    end;




 ComDPacket.StartString:=PacketBeginChar;
 ComDPacket.StopString:=PacketEndChar;
 ComDPacket.ComPort:=ComPort1;
 try
//  ComPort1.ClearBuffer(True, True);
  ComPort1.Open;
  Comport1.AbortAllAsync;
  ComPort1.ClearBuffer(True, True);
 finally
  PortConnected();
 end;
end;

procedure TIVchar.FormDestroy(Sender: TObject);
 var  ConfigFile:TIniFile;
      i:integer;
begin
 ConfigFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'IVChar.ini');
 ConfigFile.EraseSection('PinNumbers');
 ConfigFile.WriteInteger('PinNumbers','PinCount',High(NumberPins)+1);
 for I := 0 to High(NumberPins) do
   begin
    ConfigFile.WriteInteger('PinNumbers','Pin'+IntToStr(i),NumberPins[i]);
    if assigned(V721A)and(V721A.PinNumber=NumberPins[i]) then
         ConfigFile.WriteInteger('PinNumbers','V721A',i);
    if assigned(V721_I)and(V721_I.PinNumber=NumberPins[i]) then
         ConfigFile.WriteInteger('PinNumbers','V721_I',i);
    if assigned(V721_II)and(V721_II.PinNumber=NumberPins[i]) then
         ConfigFile.WriteInteger('PinNumbers','V721_II',i);
   end;


 ConfigFile.Free;

 if assigned(V721A) then V721A.Free;
 if assigned(V721_I) then V721_I.Free;
 if assigned(V721_II) then V721_II.Free;

 try
  if ComPort1.Connected then
   begin
    Comport1.AbortAllAsync;
    ComPort1.ClearBuffer(True, True);
    ComPort1.Close;
   end;
 finally
//  ComPort1.Free;
 end;
end;



procedure TIVchar.PCChange(Sender: TObject);
begin
 if SBV721AAuto.Down then
     begin
       SBV721AAuto.Down:=False;
       SBV721AAuto.OnClick(Sender);
     end;
end;

procedure TIVchar.PortConnected();
begin
// showmessage('PortConnected');
 if ComPort1.Connected then
  begin
   LConnected.Caption:='ComPort is open';
   LConnected.Font.Color:=clBlue;
   BConnect.Caption:='To close'
  end
                       else
  begin
   LConnected.Caption:='ComPort is close';
   LConnected.Font.Color:=clRed;
   BConnect.Caption:='To open'
  end
end;



procedure TIVchar.RGV721ARangeClick(Sender: TObject);
begin
 RGV721ARange.ItemIndex:=
    DiapazonSelect(V721A.MeasureMode,V721A.Diapazon);
end;

procedure TIVchar.RGV721A_MMClick(Sender: TObject);
begin
  if Assigned(V721A) then
  RGV721A_MM.ItemIndex:=ord(V721A.MeasureMode);
end;

procedure TIVchar.SBV721AAutoClick(Sender: TObject);
begin
 BV721AMeas.Enabled:=not(SBV721AAuto.Down);
 if SBV721AAuto.Down then Time.OnTimer:=BV721AMeas.OnClick;

 Time.Enabled:=SBV721AAuto.Down;
end;

Procedure TIVchar.VoltmetrConnect(Voltmetr:TVoltmetr;PinNumber:byte);
begin
 if assigned(Voltmetr) then Voltmetr.Free;
 try
  if ComPort1.Connected then
   begin
    Comport1.AbortAllAsync;
    ComPort1.ClearBuffer(True, True);
    ComPort1.Close;
    Voltmetr:= TVoltmetr.Create(PinNumber);
    Voltmetr.ComPort:=ComPort1;
    Voltmetr.fComPacket.ComPort:=ComPort1;
    ComPort1.Open;
    Comport1.AbortAllAsync;
    ComPort1.ClearBuffer(True, True);
   end
                        else
   begin
    Voltmetr:= TVoltmetr.Create(PinNumber);
    Voltmetr.ComPort:=ComPort1;
    Voltmetr.fComPacket.ComPort:=ComPort1;
   end
 finally
 end;
end;


Procedure TIVchar.VotmetrToForm({Voltmetr:TVoltmetr});
begin
 BV721AMeas.Enabled:=assigned(V721A);
 SBV721AAuto.Enabled:= assigned(V721A);

 if assigned(V721A) then
 begin
   RGV721A_MM.ItemIndex:=ord(V721A.MeasureMode);
   DiapazonFill(TMeasureMode(RGV721A_MM.ItemIndex),
                 RGV721ARange.Items);

   RGV721ARange.ItemIndex:=
      DiapazonSelect(V721A.MeasureMode,V721A.Diapazon);
   case V721A.MeasureMode of
     IA,ID: LV721AU.Caption:=' A';
     UA,UD: LV721AU.Caption:=' V';
     MMErr: LV721AU.Caption:='';
   end;
   if V721A.isReady then
      LV721A.Caption:=FloatToStrF(V721A.Value,ffExponent,4,2)
                       else
      begin
       LV721A.Caption:='    ERROR';
       LV721AU.Caption:='';
      end;
 end;
end;

end.
