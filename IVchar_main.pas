unit IVchar_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPort, ComCtrls, Buttons, V721, ExtCtrls, IniFiles,PacketParameters,
  TeEngine, Series, TeeProcs, Chart;

type
  TIVchar = class(TForm)
    ComPort1: TComPort;
    Button1: TButton;
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
    RGV721I_MM: TRadioGroup;
    ComDPacket: TComDataPacket;
    BParamReceive: TButton;
    CBV721A: TComboBox;
    LV721APin: TLabel;
    BV721ASet: TButton;
    PanelV721_II: TPanel;
    RGV721II_MM: TRadioGroup;
    CBV721I: TComboBox;
    CBV721II: TComboBox;
    LV721IPin: TLabel;
    LV721IIPin: TLabel;
    BV721IISet: TButton;
    BV721ISet: TButton;
    RGV721IRange: TRadioGroup;
    RGV721IIRange: TRadioGroup;
    LV721I: TLabel;
    LV721IU: TLabel;
    LV721II: TLabel;
    LV721IIU: TLabel;
    BV721IMeas: TButton;
    BV721IIMeas: TButton;
    SBV721IAuto: TSpeedButton;
    SBV721IIAuto: TSpeedButton;
    TS_DAC: TTabSheet;
    TS_Setting: TTabSheet;
    ChLine: TChart;
    ForwLine: TPointSeries;
    RevLine: TPointSeries;
    ChLg: TChart;
    ForwLg: TPointSeries;
    RevLg: TPointSeries;
    GBIV: TGroupBox;
    CBForw: TCheckBox;
    CBRev: TCheckBox;
    BIVStart: TButton;
    BIVStop: TButton;
    GroupBox1: TGroupBox;
    procedure Button1Click(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure ComPort1RxBuf(Sender: TObject; const Buffer; Count: Integer);
    procedure FormCreate(Sender: TObject);
    procedure PortConnected();
    procedure BConnectClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
//    procedure ComDataPacket1Packet(Sender: TObject; const Str: string);
//    procedure ComDataPacket1Discard(Sender: TObject; const Str: string);
    procedure BV721AMeasClick(Sender: TObject);
    procedure SBV721AAutoClick(Sender: TObject);
    procedure PCChange(Sender: TObject);
    procedure RGV721ARangeClick(Sender: TObject);
    procedure RGV721A_MMClick(Sender: TObject);
    procedure BParamReceiveClick(Sender: TObject);
    procedure ComDPacketPacket(Sender: TObject; const Str: string);
    procedure BV721ASetClick(Sender: TObject);
    procedure BV721IMeasClick(Sender: TObject);
    procedure BV721IIMeasClick(Sender: TObject);
  private
    procedure DiapazonsBegin();
    procedure ComponentView;
    { Private declarations }
//   fPacket:array of byte;
  public
    V721A:TV721A;
    V721_I,V721_II:TV721;
//    procedure VoltmetrConnect(var Voltmetr:TVoltmetr;PinNumber:byte);
    Procedure VotmetrToForm(Voltmetr:TVoltmetr);
    Procedure NumberPinsShow();
    Procedure VoltmetrNumberPinShow();
  end;

//const
//  PacketBegin=10;
//  PacketEnd=13;

var
  Main: TIVchar;
//  V721A:TV721A;
//  V721_I,V721_II:TV721;
//  NumberPins:Array of byte; // номери пінів, які використовуються як керуючі для SPI
  NumberPins:TStringList; // номери пінів, які використовуються як керуючі для SPI

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

procedure TIVchar.BParamReceiveClick(Sender: TObject);
begin
 PacketCreate([ParameterReceiveCommand]);
 PacketIsSend(ComPort1);
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
 VotmetrToForm(V721A);
end;

procedure TIVchar.BV721ASetClick(Sender: TObject);
begin
 if (Sender as TButton).Name='BV721ASet' then
  begin
  if CBV721A.ItemIndex<0 then Exit;
  if CBV721A.Items[CBV721A.ItemIndex]<>IntToStr(V721A.PinNumber) then
    begin
     V721A.PinNumber:=StrToInt(NumberPins[CBV721A.ItemIndex]);
     VoltmetrNumberPinShow();
     VotmetrToForm(V721A);
    end;
  end;
 if (Sender as TButton).Name='BV721ISet' then
  begin
  if CBV721I.ItemIndex<0 then Exit;
  if CBV721I.Items[CBV721I.ItemIndex]<>IntToStr(V721_I.PinNumber) then
    begin
     V721_I.PinNumber:=StrToInt(NumberPins[CBV721I.ItemIndex]);
     VoltmetrNumberPinShow();
     VotmetrToForm(V721_I);
    end;
  end;
 if (Sender as TButton).Name='BV721IISet' then
  begin
  if CBV721II.ItemIndex<0 then Exit;
  if CBV721II.Items[CBV721II.ItemIndex]<>IntToStr(V721_II.PinNumber) then
    begin
     V721_II.PinNumber:=StrToInt(NumberPins[CBV721II.ItemIndex]);
     VoltmetrNumberPinShow();
     VotmetrToForm(V721_II);
    end;
  end;
end;

procedure TIVchar.BV721IIMeasClick(Sender: TObject);
begin
 if not(ComPort1.Connected) then
    begin
      PortConnected();
      Exit;
    end;
 V721_II.Measurement();
 VotmetrToForm(V721_II);
end;

procedure TIVchar.BV721IMeasClick(Sender: TObject);
begin
 if not(ComPort1.Connected) then
    begin
      PortConnected();
      Exit;
    end;
 V721_I.Measurement();
 VotmetrToForm(V721_I);
end;

//procedure TIVchar.ComDataPacket1Discard(Sender: TObject; const Str: string);
//begin
// showmessage('Noooo');
//end;

//procedure TIVchar.ComDataPacket1Packet(Sender: TObject; const Str: string);
// var tempstr:string;
//     i:integer;
//
//begin
// showmessage('Hi '+inttostr(Length(Str)));
//  tempstr:='';
// for I := 1 to Length(Str) do
//  tempstr:=tempstr+' '+inttostr(ord(str[i]));
//  showmessage(tempstr);
//end;

procedure TIVchar.ComDPacketPacket(Sender: TObject; const Str: string);
 var Data:array of byte;
     i:integer;
begin
 if PacketIsReceived(Str,@Data[Low(Data)],ParameterReceiveCommand) then
  begin
   NumberPins.Clear;
   for I := 2 to High(Data)-1 do
    NumberPins.Add(IntToStr(Data[i]));
   NumberPinsShow(); 
//   SetLength(NumberPins,High(Data)-2);
//   for I := 0 to High(NumberPins) do
//    NumberPins[i]:=Data[i+2];
  end;

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
 DiapazonsBegin();
 ComponentView();

 V721A:= TV721A.Create(ComPort1);
 V721_I:= TV721.Create(ComPort1);
 V721_II:= TV721.Create(ComPort1);

 NumberPins:=TStringList.Create;

 ConfigFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'IVChar.ini');
// SetLength(NumberPins,ConfigFile.ReadInteger('PinNumbers','PinCount',3));
// for I := 0 to High(NumberPins) do
//    NumberPins[i]:=ConfigFile.ReadInteger('PinNumbers','Pin'+IntToStr(i),100);

 for I := 0 to ConfigFile.ReadInteger('PinNumbers','PinCount',3)-1 do
    NumberPins.Add(ConfigFile.ReadString('PinNumbers','Pin'+IntToStr(i),IntTostr(UndefinedPin)));

// TempPin:=ConfigFile.ReadInteger('PinNumbers','V721A',-1);
// if (TempPin>-1)and(TempPin<=High(NumberPins)) then
//     V721A.PinNumber:=NumberPins[TempPin];
// //     VoltmetrConnect(V721A,NumberPins[TempPin]);
// TempPin:=ConfigFile.ReadInteger('PinNumbers','V721_I',-1);
// if (TempPin>-1)and(TempPin<=High(NumberPins)) then
//      V721_I.PinNumber:=NumberPins[TempPin];
////     VoltmetrConnect(V721_I,NumberPins[TempPin]);
// TempPin:=ConfigFile.ReadInteger('PinNumbers','V721_II',-1);
// if (TempPin>-1)and(TempPin<=High(NumberPins)) then
//     V721_II.PinNumber:=NumberPins[TempPin];
////     VoltmetrConnect(V721_II,NumberPins[TempPin]);


 TempPin:=ConfigFile.ReadInteger('PinNumbers','V721A',-1);
 if (TempPin>-1)and(TempPin<NumberPins.Count) then
     V721A.PinNumber:=StrToInt(NumberPins[TempPin]);
 TempPin:=ConfigFile.ReadInteger('PinNumbers','V721_I',-1);
 if (TempPin>-1)and(TempPin<NumberPins.Count) then
     V721_I.PinNumber:=StrToInt(NumberPins[TempPin]);
 TempPin:=ConfigFile.ReadInteger('PinNumbers','V721_II',-1);
 if (TempPin>-1)and(TempPin<NumberPins.Count) then
     V721_II.PinNumber:=StrToInt(NumberPins[TempPin]);

 ConfigFile.Free;

 CBV721A.Sorted:=False;
 CBV721I.Sorted:=False;
 CBV721II.Sorted:=False;
 NumberPinsShow();
// CBV721A.Items:=NumberPins;

 VoltmetrNumberPinShow();
// V721A.PinNumber:=26;

// V721A:= TV721A.Create(26,ComPort1);

 // V721A:= TV721A.Create(26);
// V721A.ComPort:=ComPort1;
// V721A.fComPacket.ComPort:=ComPort1;

 VotmetrToForm(V721A);
 VotmetrToForm(V721_I);
 VotmetrToForm(V721_II);

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
// ConfigFile.WriteInteger('PinNumbers','PinCount',High(NumberPins)+1);
 ConfigFile.WriteInteger('PinNumbers','PinCount',NumberPins.Count);
// for I := 0 to High(NumberPins) do
 for I := 0 to NumberPins.Count-1 do
   begin
//    ConfigFile.WriteInteger('PinNumbers','Pin'+IntToStr(i),NumberPins[i]);
//    if assigned(V721A)and(V721A.PinNumber=NumberPins[i]) then
//         ConfigFile.WriteInteger('PinNumbers','V721A',i);
//    if assigned(V721_I)and(V721_I.PinNumber=NumberPins[i]) then
//         ConfigFile.WriteInteger('PinNumbers','V721_I',i);
//    if assigned(V721_II)and(V721_II.PinNumber=NumberPins[i]) then
//         ConfigFile.WriteInteger('PinNumbers','V721_II',i);
    ConfigFile.WriteString('PinNumbers','Pin'+IntToStr(i),NumberPins[i]);
    if assigned(V721A)and(IntToStr(V721A.PinNumber)=NumberPins[i]) then
         ConfigFile.WriteInteger('PinNumbers','V721A',i);
    if assigned(V721_I)and(IntToStr(V721_I.PinNumber)=NumberPins[i]) then
         ConfigFile.WriteInteger('PinNumbers','V721_I',i);
    if assigned(V721_II)and(IntToStr(V721_II.PinNumber)=NumberPins[i]) then
         ConfigFile.WriteInteger('PinNumbers','V721_II',i);

   end;


 ConfigFile.Free;

 NumberPins.Free;

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
       SBV721AAuto.OnClick(SBV721AAuto);
     end;
 if SBV721IAuto.Down then
     begin
       SBV721IAuto.Down:=False;
       SBV721AAuto.OnClick(SBV721IAuto);
     end;
 if SBV721IIAuto.Down then
     begin
       SBV721IIAuto.Down:=False;
       SBV721AAuto.OnClick(SBV721IIAuto);
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
 if  (Sender as TRadiogroup).Name='RGV721ARange' then
  RGV721ARange.ItemIndex:=
    DiapazonSelect(V721A.MeasureMode,V721A.Diapazon);
 if  (Sender as TRadiogroup).Name='RGV721IRange' then
  RGV721IRange.ItemIndex:=
    DiapazonSelect(V721_I.MeasureMode,V721_I.Diapazon);
 if  (Sender as TRadiogroup).Name='RGV721IIRange' then
  RGV721IIRange.ItemIndex:=
    DiapazonSelect(V721_II.MeasureMode,V721A.Diapazon);
end;

procedure TIVchar.RGV721A_MMClick(Sender: TObject);
begin
 if  (Sender as TRadiogroup).Name='RGV721A_MM' then
  if Assigned(V721A) then
   RGV721A_MM.ItemIndex:=ord(V721A.MeasureMode);
 if  (Sender as TRadiogroup).Name='RGV721I_MM' then
  if Assigned(V721_I) then
   RGV721I_MM.ItemIndex:=ord(V721_I.MeasureMode);
 if  (Sender as TRadiogroup).Name='RGV721II_MM' then
  if Assigned(V721_II) then
   RGV721II_MM.ItemIndex:=ord(V721_II.MeasureMode);
end;

procedure TIVchar.SBV721AAutoClick(Sender: TObject);
begin
 if  (Sender as TSpeedButton).Name='SBV721AAuto' then
   begin
     BV721AMeas.Enabled:=not(SBV721AAuto.Down);
     if SBV721AAuto.Down then Time.OnTimer:=BV721AMeas.OnClick;
     Time.Enabled:=SBV721AAuto.Down;
   end;

 if  (Sender as TSpeedButton).Name='SBV721IAuto' then
   begin
     BV721IMeas.Enabled:=not(SBV721IAuto.Down);
     if SBV721IIAuto.Down then
       SBV721IIAuto.Down:=False;
     if SBV721IAuto.Down then
       begin
       SBV721IIAuto.Enabled:=False;
       BV721IIMeas.Enabled:=False;
       end
                         else
       VotmetrToForm(V721_II);
     if SBV721IAuto.Down then Time.OnTimer:=BV721IMeas.OnClick;
     Time.Enabled:=SBV721IAuto.Down;
   end;

 if  (Sender as TSpeedButton).Name='SBV721IIAuto' then
   begin
     BV721IIMeas.Enabled:=not(SBV721IIAuto.Down);
     if SBV721IAuto.Down then
       SBV721IAuto.Down:=False;
     if SBV721IIAuto.Down then
       begin
       SBV721IAuto.Enabled:=False;
       BV721IMeas.Enabled:=False;
       end
                         else
       VotmetrToForm(V721_I);
     if SBV721IIAuto.Down then Time.OnTimer:=BV721IIMeas.OnClick;
     Time.Enabled:=SBV721IIAuto.Down;
   end;
end;

//Procedure TIVchar.VoltmetrConnect(var Voltmetr:TVoltmetr;PinNumber:byte);
//begin
// if assigned(Voltmetr) then Voltmetr.Free;
// try
//  if ComPort1.Connected then
//   begin
//    Comport1.AbortAllAsync;
//    ComPort1.ClearBuffer(True, True);
//    ComPort1.Close;
//    
//    Voltmetr:=TVoltmetr.Create(PinNumber,ComPort1);
////    Voltmetr:= TVoltmetr.Create(PinNumber);
////    Voltmetr.ComPort:=ComPort1;
////    Voltmetr.fComPacket.ComPort:=ComPort1;
//    ComPort1.Open;
//    Comport1.AbortAllAsync;
//    ComPort1.ClearBuffer(True, True);
//   end
//                        else
//   Voltmetr:=TVoltmetr.Create(PinNumber,ComPort1);
////   begin
////    Voltmetr:= TVoltmetr.Create(PinNumber);
////    Voltmetr.ComPort:=ComPort1;
////    Voltmetr.fComPacket.ComPort:=ComPort1;
////   end
// finally
// end;
//end;


Procedure TIVchar.VotmetrToForm(Voltmetr:TVoltmetr);
begin
 if Voltmetr=V721A then
  begin
   BV721AMeas.Enabled:=assigned(V721A);
   SBV721AAuto.Enabled:= assigned(V721A);

   if assigned(V721A) then
   begin
     BV721AMeas.Enabled:=(V721A.PinNumber<>UndefinedPin);
     SBV721AAuto.Enabled:=(V721A.PinNumber<>UndefinedPin);
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

 if Voltmetr=V721_I then
  begin
   BV721IMeas.Enabled:=assigned(V721_I);
   SBV721IAuto.Enabled:= assigned(V721_I);

   if assigned(V721_I) then
   begin
     BV721IMeas.Enabled:=(V721_I.PinNumber<>UndefinedPin);
     SBV721IAuto.Enabled:=(V721_I.PinNumber<>UndefinedPin);
     RGV721I_MM.ItemIndex:=ord(V721_I.MeasureMode);
     DiapazonFill(TMeasureMode(RGV721I_MM.ItemIndex),
                   RGV721IRange.Items);

     RGV721IRange.ItemIndex:=
        DiapazonSelect(V721_I.MeasureMode,V721_I.Diapazon);
     case V721_I.MeasureMode of
       IA,ID: LV721IU.Caption:=' A';
       UA,UD: LV721IU.Caption:=' V';
       MMErr: LV721IU.Caption:='';
     end;
     if V721_I.isReady then
        LV721I.Caption:=FloatToStrF(V721_I.Value,ffExponent,4,2)
                         else
        begin
         LV721I.Caption:='    ERROR';
         LV721IU.Caption:='';
        end;
   end;
  end;

 if Voltmetr=V721_II then
  begin
   BV721IIMeas.Enabled:=assigned(V721_II);
   SBV721IIAuto.Enabled:= assigned(V721_II);

   if assigned(V721_II) then
   begin
     BV721IIMeas.Enabled:=(V721_II.PinNumber<>UndefinedPin);
     SBV721IIAuto.Enabled:=(V721_II.PinNumber<>UndefinedPin);
     RGV721II_MM.ItemIndex:=ord(V721_II.MeasureMode);
     DiapazonFill(TMeasureMode(RGV721II_MM.ItemIndex),
                   RGV721IIRange.Items);

     RGV721IIRange.ItemIndex:=
        DiapazonSelect(V721_II.MeasureMode,V721_II.Diapazon);
     case V721_II.MeasureMode of
       IA,ID: LV721IIU.Caption:=' A';
       UA,UD: LV721IIU.Caption:=' V';
       MMErr: LV721IIU.Caption:='';
     end;
     if V721_II.isReady then
        LV721II.Caption:=FloatToStrF(V721_II.Value,ffExponent,4,2)
                         else
        begin
         LV721II.Caption:='    ERROR';
         LV721IIU.Caption:='';
        end;
   end;
  end;

end;

Procedure TIVchar.NumberPinsShow();
 var i:integer;
begin
 try
 for i := Main.ComponentCount - 1 downto 0 do
   if Main.Components[i].Tag = 1 then
    (Main.Components[i] as TComboBox).Items:=NumberPins;
 finally
 end;
// CBV721A.Items:=NumberPins;
end;

Procedure TIVchar.VoltmetrNumberPinShow();
begin
 LV721APin.Caption:=V721A.PinNumberStr;
 LV721IPin.Caption:=V721_I.PinNumberStr;
 LV721IIPin.Caption:=V721_II.PinNumberStr;
// if V721A.PinNumber=255 then
//    LV721APin.Caption:='Control pin is undefined'
//                       else
//    LV721APin.Caption:='Control pin number is '+IntToStr(V721A.PinNumber);
end;

procedure TIVchar.ComponentView;
begin
  PanelV721_I.Height := round(PanelV721_I.Parent.Height / 2);
  PanelV721_II.Height := round(PanelV721_II.Parent.Height / 2);
  ChLine.Top:=0;
  ChLine.Left:=0;
  ChLine.Height := round(ChLine.Parent.Height / 2);
  ChLine.Width:= round(0.7*ChLine.Parent.Width);
  ChLg.Top:=round(ChLg.Parent.Height / 2);
  ChLg.Left:=0;
  ChLg.Height := round(ChLg.Parent.Height / 2);
  ChLg.Width:= round(0.7*ChLg.Parent.Width);
  end;

procedure TIVchar.DiapazonsBegin;
var
  i: Integer;
begin
  RGV721A_MM.Items.Clear;
  RGV721I_MM.Items.Clear;
  RGV721II_MM.Items.Clear;
  for I := 0 to ord(MMErr) do
   begin
    RGV721A_MM.Items.Add(MeasureModeLabels[TMeasureMode(i)]);
    RGV721I_MM.Items.Add(MeasureModeLabels[TMeasureMode(i)]);
    RGV721II_MM.Items.Add(MeasureModeLabels[TMeasureMode(i)]);
   end;
  RGV721A_MM.ItemIndex := 4;
  RGV721I_MM.ItemIndex := 3;
  RGV721II_MM.ItemIndex := 3;
  LV721AU.Caption := '';
  LV721IU.Caption := '';
  LV721IIU.Caption := '';
  DiapazonFill(TMeasureMode(RGV721A_MM.ItemIndex), RGV721ARange.Items);
  DiapazonFill(TMeasureMode(RGV721I_MM.ItemIndex), RGV721IRange.Items);
  DiapazonFill(TMeasureMode(RGV721II_MM.ItemIndex), RGV721IIRange.Items);
end;

end.
