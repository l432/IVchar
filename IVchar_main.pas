unit IVchar_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPort, ComCtrls, Buttons, V721, ExtCtrls, IniFiles,PacketParameters,
  TeEngine, Series, TeeProcs, Chart, Spin, OlegType, Grids, OlegMath;

type
  TIVchar = class(TForm)
    ComPort1: TComPort;
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
    GBAD: TGroupBox;
    CBSStep: TCheckBox;
    BIVSave: TButton;
    LADVoltage: TLabel;
    LADVoltageValue: TLabel;
    LADCurrent: TLabel;
    LADCurrentValue: TLabel;
    LADRange: TLabel;
    GBT: TGroupBox;
    SBTAuto: TSpeedButton;
    LTRunning: TLabel;
    LTRValue: TLabel;
    LTLast: TLabel;
    LTLastValue: TLabel;
    GBFB: TGroupBox;
    ProgressBar1: TProgressBar;
    UDFBHighLimit: TUpDown;
    LFBHighlimitValue: TLabel;
    STFBhighlimit: TStaticText;
    UDFBLowLimit: TUpDown;
    LFBLowlimitValue: TLabel;
    STFBlowlimit: TStaticText;
    PanelSplit: TPanel;
    SGFBStep: TStringGrid;
    BFBEdit: TButton;
    BFBDelete: TButton;
    BFBAdd: TButton;
    STFBSteps: TStaticText;
    STFBDelay: TStaticText;
    LFBDelayValue: TLabel;
    BFBDelayInput: TButton;
    GBRB: TGroupBox;
    LRBHighlimitValue: TLabel;
    LRBLowlimitValue: TLabel;
    LRBDelayValue: TLabel;
    STRBSteps: TStaticText;
    UDRBHighLimit: TUpDown;
    STRBhighlimit: TStaticText;
    UDRBLowLimit: TUpDown;
    STRBlowlimit: TStaticText;
    SGRBStep: TStringGrid;
    BRBEdit: TButton;
    BRBDelete: TButton;
    BRBAdd: TButton;
    STRBDelay: TStaticText;
    BRBDelayInput: TButton;
//    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
//    procedure ComPort1RxBuf(Sender: TObject; const Buffer; Count: Integer);
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
    procedure UDFBHighLimitClick(Sender: TObject; Button: TUDBtnType);
    procedure CBForwClick(Sender: TObject);
    procedure SGFBStepDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SGFBStepSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BFBAddClick(Sender: TObject);
    procedure BFBDeleteClick(Sender: TObject);
    procedure BFBEditClick(Sender: TObject);
    procedure BFBDelayInputClick(Sender: TObject);
    procedure SGRBStepDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BRBDeleteClick(Sender: TObject);
    procedure BRBEditClick(Sender: TObject);
  private
    procedure DiapazonsBegin();
    {налаштування компонентів, пов'язаних
    з відображенням даних від вольтметрів}
    Procedure VotmetrToForm(Voltmetr:TVoltmetr);
    {виведення на форму результату виміра вольтметра}    
    procedure ComponentView;
    {початкове налаштування різних компонентів}
    procedure PinsFromIniFile;
    {зчитування номерів пінів, які використовуються загалом і
    для керування вольтметрами зокрема}
    procedure PinsWriteToIniFile;
    Procedure NumberPinsShow();
    {відображується вміст NumberPins в усі
    ComboBox з Tag=1}
    Procedure VoltmetrNumberPinShow();
    {відображуються номери керуючих пінів
    всіх вольтметрів у відповідні мітки на формі}
    procedure RangeShow;
    procedure RangeReadFromIniFile;
    procedure RangeToForm;
    procedure StepReadFromIniFile (A:PVector; Ident:string);
    procedure StepsReadFromIniFile;
    procedure StepsWriteToIniFile;
    procedure ForwStepShow;
    procedure RevStepShow;
    procedure DelayTimeReadFromIniFile;
    procedure DelayTimeShow;
    procedure DelayTimeWriteToIniFile;
    { Private declarations }
  public
    V721A:TV721A;
    V721_I,V721_II:TV721;
    ConfigFile:TIniFile;
    NumberPins:TStringList; // номери пінів, які використовуються як керуючі для SPI
    Range:TDiapazon;//межі вимірювань, Х - пряма гілка, Y - зворотня
    ForwSteps,RevSteps:PVector;
    ForwDelay,RevDelay:Integer;
  end;

const
  Undefined='NoData';
  Vmax=8;
  Imax=2e-2;
  StepDefault=0.01;


var
  Main: TIVchar;

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

procedure TIVchar.BFBAddClick(Sender: TObject);
 var temp:double;
begin
  if (Sender as TButton).Name='BFBAdd' then
   begin
      temp:=round(10*StrToFloat555(InputBox(
                                  'Voltage limit',
                                  'Input new voltage limit.'+
                                  #10+'The value must be greater 0 and less or equal '
                                  +FloatToStrF(Vmax,ffGeneral,2,1),
                                  '')))/10;
      if (temp>0)and(temp<=Vmax)and(temp<>ErResult) then
       begin
         ForwSteps.Add(temp,StepDefault);
         ForwSteps.DeleteDuplicate;
         ForwSteps.Sorting();
         ForwStepShow();
       end;
   end;
  if (Sender as TButton).Name='BRBAdd' then
   begin
      temp:=round(10*StrToFloat555(InputBox(
                                  'Voltage limit',
                                  'Input new voltage limit.'+
                                  #10+'The value must be less 0 and greater or equal '
                                  +FloatToStrF(-Vmax,ffGeneral,2,1),
                                  '')))/10;
      if (temp<0)and(temp>=(-Vmax))and(temp<>ErResult) then
       begin
         RevSteps.Add(abs(temp),StepDefault);
         RevSteps.DeleteDuplicate;
         RevSteps.Sorting();
         RevStepShow();
       end;
   end;
end;

procedure TIVchar.BFBDelayInputClick(Sender: TObject);
 var temp:integer;
     stTemp:string;
begin
 if (Sender as TButton).Name='BFBDelayInput'
            then stTemp:=IntToStr(ForwDelay)
            else stTemp:=IntToStr(RevDelay);
 temp:=round(StrToInt555(InputBox(
                                'Delay time',
                                'Input delay time.'+
                                #10+'The value must be greater 0 and less 10000',
                                stTemp)));
 if (temp>=0)and(temp<10000)and(temp<>ErResult)
    then
      begin
       if (Sender as TButton).Name='BFBDelayInput'
              then ForwDelay:=temp
              else RevDelay:=temp;
       DelayTimeShow;
      end;
end;

procedure TIVchar.BFBDeleteClick(Sender: TObject);
begin
 if (SGFBStep.Row=(SGFBStep.RowCount-1))or(SGFBStep.Row<1) then Exit;
 ForwSteps.Delete(SGFBStep.Row-1);
 ForwStepShow();
end;

procedure TIVchar.BFBEditClick(Sender: TObject);
 var st:string;
     temp:double;
begin
 if (SGFBStep.Row=0)or(SGFBStep.Row>=SGFBStep.RowCount-1) then Exit;
 if (SGFBStep.Col=0) then
    if InputQuery('Voltage limit',
                  'Edit voltage limit value.'+
                   #10+'The value must be greater 0 and less or equal '
                   +FloatToStrF(Vmax,ffGeneral,2,1),
                   st) then
       begin
        temp:=round(10*StrToFloat555(st))/10;
        if (temp>0)and(temp<=Vmax)and(temp<>ErResult) then
         begin
           ForwSteps.X[SGFBStep.Row-1]:=temp;
           ForwSteps.DeleteDuplicate;
           ForwSteps.Sorting();
           ForwStepShow();
         end;
       end;
 if (SGFBStep.Col=1) then
    if InputQuery('Step value',
                  'Edit step value.'+
                   #10+'The value must be greater than 0',
                   st) then
       begin
        temp:=round(1000*StrToFloat555(st))/1000;
        if (temp>0)and(temp<>ErResult) then
         begin
           ForwSteps.Y[SGFBStep.Row-1]:=temp;
           ForwStepShow();
         end;
       end;
 end;

procedure TIVchar.BParamReceiveClick(Sender: TObject);
begin
 PacketCreate([ParameterReceiveCommand]);
// showmessage(booltostr(False)+' '+booltostr(PacketIsSend(ComPort1)));
 PacketIsSend(ComPort1);
end;




procedure TIVchar.BRBDeleteClick(Sender: TObject);
begin
 if (SGRBStep.Row=(SGRBStep.RowCount-1))or(SGRBStep.Row<1) then Exit;
 RevSteps.Delete(SGRBStep.Row-1);
 RevStepShow();
end;

procedure TIVchar.BRBEditClick(Sender: TObject);
 var st:string;
     temp:double;
begin
 if (SGRBStep.Row=0)or(SGRBStep.Row>=SGRBStep.RowCount-1) then Exit;
 if (SGRBStep.Col=0) then
    if InputQuery('Voltage limit',
                  'Edit voltage limit value.'+
                  #10+'The value must be less 0 and greater or equal '
                  +FloatToStrF(-Vmax,ffGeneral,2,1),
                  st) then
       begin
        temp:=round(10*StrToFloat555(st))/10;
        if (temp<0)and(temp>=(-Vmax))and(temp<>ErResult) then
         begin
           RevSteps.X[SGFBStep.Row-1]:=abs(temp);
           RevSteps.DeleteDuplicate;
           RevSteps.Sorting();
           RevStepShow();
         end;
       end;
 if (SGRBStep.Col=1) then
    if InputQuery('Step value',
                  'Edit step value.'+
                   #10+'The value must be greater than 0',
                   st) then
       begin
        temp:=round(1000*StrToFloat555(st))/1000;
        if (temp>0)and(temp<>ErResult) then
         begin
           RevSteps.Y[SGFBStep.Row-1]:=temp;
           RevStepShow();
         end;
       end;
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

procedure TIVchar.CBForwClick(Sender: TObject);
begin
 RangeShow();
end;

procedure TIVchar.ComDPacketPacket(Sender: TObject; const Str: string);
 var Data:TArrByte;
//     Data:array of byte;
     i:integer;
begin
// if PacketIsReceived(Str,@Data[Low(Data)],ParameterReceiveCommand) then
 if PacketIsReceived(Str,Data,ParameterReceiveCommand) then

// ShowData(Data);
// showmessage(inttostr(High(Data)));
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

//procedure TIVchar.ComPort1RxBuf(Sender: TObject; const Buffer; Count: Integer);
//var Str:string;
//begin
////showmessage('Hi2');
////ComPort1.ReadStr(Str, 2);
////
////Label1.Caption:=inttostr(byte(Length(Str)));
////Label1.Caption:=Str;
//end;
//
//procedure TIVchar.ComPort1RxChar(Sender: TObject; Count: Integer);
//var Str:string;
//    B,i:byte;
//begin
////for I := 0 to Count - 1 do
//// begin
////   ComPort1.Read(B,1);
////   Label1.Caption:=Label1.Caption+' '+inttostr(B);
//// end;
//
//end;

procedure TIVchar.FormCreate(Sender: TObject);
//     ConfigFile:TIniFile;
begin
 DecimalSeparator:='.';
 DiapazonsBegin();
 ComponentView();

 V721A:= TV721A.Create(ComPort1);
 V721_I:= TV721.Create(ComPort1);
 V721_II:= TV721.Create(ComPort1);

 NumberPins:=TStringList.Create;
 Range:=TDiapazon.Create;
 new(ForwSteps);
 new(RevSteps);

 ConfigFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'IVChar.ini');

 PinsFromIniFile();
 NumberPinsShow();
 VoltmetrNumberPinShow();

 VotmetrToForm(V721A);
 VotmetrToForm(V721_I);
 VotmetrToForm(V721_II);

 RangeReadFromIniFile();
 RangeToForm();

 StepsReadFromIniFile();
 ForwStepShow();
 RevStepShow();

 DelayTimeReadFromIniFile();
 DelayTimeShow();


 ComDPacket.StartString:=PacketBeginChar;
 ComDPacket.StopString:=PacketEndChar;
 ComDPacket.ComPort:=ComPort1;

 try
  ComPort1.Open;
  Comport1.AbortAllAsync;
  ComPort1.ClearBuffer(True, True);
 finally
  PortConnected();
 end;
end;

procedure TIVchar.FormDestroy(Sender: TObject);
begin

 PinsWriteToIniFile();
 Range.WriteToIniFile(ConfigFile,'Range','Measure');
 StepsWriteToIniFile();
 DelayTimeWriteToIniFile();

 ConfigFile.Free;

 dispose(ForwSteps);
 dispose(RevSteps);
 Range.Free;
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



procedure TIVchar.SGFBStepDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
 if (ARow>1)and(not(odd(Arow))) then
  begin
     SGFBStep.Canvas.Brush.Color:=RGB(252,212,213);
//     SGFBStep.Canvas.Brush.Color:=RGB(218,240,254);
     SGFBStep.Canvas.FillRect(Rect);
     SGFBStep.Canvas.TextOut(Rect.Left+2,Rect.Top+2,SGFBStep.Cells[Acol,Arow]);
  end
end;

procedure TIVchar.SGFBStepSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
 if (Sender as TStringGrid).Name='SGFBStep' then
  begin
    BFBEdit.Enabled:=True;
    BFBDelete.Enabled:=True;
  end;
 if (Sender as TStringGrid).Name='SGRBStep' then
  begin
    BRBEdit.Enabled:=True;
    BRBDelete.Enabled:=True;
  end;
end;

procedure TIVchar.SGRBStepDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
 if (ARow>1)and(not(odd(Arow))) then
  begin
     SGRBStep.Canvas.Brush.Color:=RGB(218,240,254);
     SGRBStep.Canvas.FillRect(Rect);
     SGRBStep.Canvas.TextOut(Rect.Left+2,Rect.Top+2,SGRBStep.Cells[Acol,Arow]);
  end
end;

procedure TIVchar.UDFBHighLimitClick(Sender: TObject; Button: TUDBtnType);
begin
 if (Sender as TUpDown).Name='UDFBHighLimit' then
  begin
  LFBHighlimitValue.Caption:=FloatToStrF(UDFBHighLimit.Position/10,ffFixed, 1, 1);
  Range.XMax:=UDFBHighLimit.Position/10;
//  showmessage(Inttostr(UDFBHighLimit.Position));
  end;
 if (Sender as TUpDown).Name='UDFBLowLimit' then
  begin
  LFBLowlimitValue.Caption:=FloatToStrF(UDFBLowLimit.Position/10,ffFixed, 1, 1);
  Range.XMin:=UDFBLowLimit.Position/10;
  end;
 if (Sender as TUpDown).Name='UDRBHighLimit' then
  begin
  LRBHighlimitValue.Caption:=FloatToStrF(-(UDRBHighLimit.Max-UDRBHighLimit.Position)/10,ffFixed, 1, 1);
  Range.YMin:=(UDRBHighLimit.Max-UDRBHighLimit.Position)/10;
//  showmessage(Inttostr(UDFBHighLimit.Position));
  end;
 if (Sender as TUpDown).Name='UDRBLowLimit' then
  begin
  LRBLowlimitValue.Caption:=FloatToStrF(-(UDRBLowLimit.Max-UDRBLowLimit.Position)/10,ffFixed, 1, 1);
  Range.Ymax:=(UDRBLowLimit.Max-UDRBLowLimit.Position)/10;
  end;
 RangeShow;
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
end;

Procedure TIVchar.VoltmetrNumberPinShow();
begin
 if assigned(V721A) then
   LV721APin.Caption:=V721A.PinNumberStr;
 if assigned(V721_I) then
   LV721IPin.Caption:=V721_I.PinNumberStr;
 if assigned(V721_II) then
   LV721IIPin.Caption:=V721_II.PinNumberStr;
end;

procedure TIVchar.RangeShow;
 var Start,Finish:double;
begin
  if CBForw.Checked then Finish:=Range.XMax
                    else Finish:=-Range.Ymin;
  if CBRev.Checked then Start:=-Range.YMax
                   else Start:=Range.Xmin;
  if (not(CBForw.Checked))and(not(CBRev.Checked))
    then begin
         Finish:=0;
         Start:=0;
         end;
  LADRange.Caption := 'Range is [' + FloattostrF(Start, ffFixed, 1, 1) + ' .. '
                                   + FloattostrF(Finish, ffFixed, 1, 1) + '] V';
end;

procedure TIVchar.RangeReadFromIniFile;
begin
  Range.ReadFromIniFile(ConfigFile, 'Range', 'Measure');
  if (Range.XMax = ErResult)or(Range.XMax >Vmax) then
                   Range.XMax := Vmax;
  if (Range.YMax = ErResult)or(Range.YMax >Vmax) then
                   Range.YMax := Vmax;
  if Range.XMin<0 then Range.XMin := 0;
  if Range.YMin<0 then Range.YMin := 0;
end;

procedure TIVchar.RangeToForm;
begin
  RangeShow;
  UDFBHighLimit.Position := round(Range.XMax * 10);
  UDFBLowLimit.Position := round(Range.XMin * 10);
  LFBHighlimitValue.Caption := FloatToStrF(UDFBHighLimit.Position / 10, ffFixed, 1, 1);
  LFBLowlimitValue.Caption := FloatToStrF(UDFBLowLimit.Position / 10, ffFixed, 1, 1);
  UDRBHighLimit.Position := UDRBHighLimit.Max-round(Range.YMin * 10);
  UDRBLowLimit.Position := UDRBLowLimit.Max-round(Range.YMax * 10);
  LRBHighlimitValue.Caption := FloatToStrF(-(UDRBHighLimit.Max-UDRBHighLimit.Position) / 10, ffFixed, 1, 1);
  LRBLowlimitValue.Caption := FloatToStrF(-(UDRBLowLimit.Max-UDRBLowLimit.Position)/ 10, ffFixed, 1, 1);
end;

procedure TIVchar.StepsReadFromIniFile;
begin
  StepReadFromIniFile(ForwSteps,'Forw');
  StepReadFromIniFile(RevSteps,'Rev');
end;

procedure TIVchar.StepReadFromIniFile(A:PVector; Ident:string);
begin
  A^.ReadFromIniFile(ConfigFile, 'Step', Ident);
  A^.DeleteErResult;
  A^.DeleteDuplicate;
  A^.Sorting;
  while (A^.n > 0) and (A^.X[High(A^.X)] > Vmax) do
    A^.Delete(A^.n - 1);
  while (A^.n > 0) and (A^.X[0] < 0) do
    A^.Delete(A^.n - 1);
  if (A^.n > 0) and (A^.X[High(A^.X)] <> Vmax) then
    begin
     A^.SetLenVector(A^.n+1);
     A^.X[High(A^.X)] := Vmax;
     A^.Y[High(A^.X)] := StepDefault;
    end;
  if A^.n < 1 then
    begin
      A^.SetLenVector(1);
      A^.X[0] := Vmax;
      A^.Y[0] := StepDefault;
    end;
end;

procedure TIVchar.StepsWriteToIniFile;
begin
  ConfigFile.EraseSection('Step');
  ForwSteps.WriteToIniFile(ConfigFile, 'Step', 'Forw');
  RevSteps.WriteToIniFile(ConfigFile, 'Step', 'Rev');
end;

procedure TIVchar.ForwStepShow;
 var
  I: Integer;
begin
  SGFBStep.RowCount := ForwSteps^.n + 1;
  for I := 0 to High(ForwSteps^.X) do
   begin
     SGFBStep.Cells[0,i+1]:=FloatToStrF(ForwSteps^.X[i],ffGeneral,2,1);
     SGFBStep.Cells[1,i+1]:=FloatToStrF(ForwSteps^.Y[i],ffGeneral,4,3);
   end;
end;

procedure TIVchar.RevStepShow;
 var
  I: Integer;
begin
  SGRBStep.RowCount := RevSteps^.n + 1;
  for I := 0 to High(RevSteps^.X) do
   begin
     SGRBStep.Cells[0,i+1]:=FloatToStrF(-RevSteps^.X[i],ffGeneral,2,1);
     SGRBStep.Cells[1,i+1]:=FloatToStrF(RevSteps^.Y[i],ffGeneral,3,2);
   end;
end;

procedure TIVchar.DelayTimeReadFromIniFile;
begin
  ForwDelay := ConfigFile.ReadInteger('Delay', 'ForwTime', 0);
  if (ForwDelay<0)or(ForwDelay>10000) then ForwDelay:=0;
  RevDelay := ConfigFile.ReadInteger('Delay', 'RevTime', 0);
  if (RevDelay<0)or(RevDelay>10000) then RevDelay:=0;
end;

procedure TIVchar.DelayTimeShow;
begin
  LFBDelayValue.Caption := IntToStr(ForwDelay);
  LRBDelayValue.Caption := IntToStr(RevDelay);
end;

procedure TIVchar.DelayTimeWriteToIniFile;
begin
  WriteIniDef(ConfigFile, 'Delay', 'ForwTime', ForwDelay, 0);
  WriteIniDef(ConfigFile, 'Delay', 'RevTime', RevDelay, 0);
end;


procedure TIVchar.PinsWriteToIniFile;
var
  i: Integer;
begin
  ConfigFile.EraseSection('PinNumbers');
  ConfigFile.WriteInteger('PinNumbers', 'PinCount', NumberPins.Count);
  for I := 0 to NumberPins.Count - 1 do
  begin
    ConfigFile.WriteString('PinNumbers', 'Pin' + IntToStr(i), NumberPins[i]);
    if assigned(V721A) and (IntToStr(V721A.PinNumber) = NumberPins[i]) then
      ConfigFile.WriteInteger('PinNumbers', 'V721A', i);
    if assigned(V721_I) and (IntToStr(V721_I.PinNumber) = NumberPins[i]) then
      ConfigFile.WriteInteger('PinNumbers', 'V721_I', i);
    if assigned(V721_II) and (IntToStr(V721_II.PinNumber) = NumberPins[i]) then
      ConfigFile.WriteInteger('PinNumbers', 'V721_II', i);
  end;
end;

procedure TIVchar.PinsFromIniFile;
var
  i,TempPin: Integer;
begin
  for I := 0 to ConfigFile.ReadInteger('PinNumbers', 'PinCount', 3) - 1 do
    NumberPins.Add(ConfigFile.ReadString('PinNumbers', 'Pin' + IntToStr(i), IntToStr(UndefinedPin)));

  TempPin := ConfigFile.ReadInteger('PinNumbers', 'V721A', -1);
  if (TempPin > -1) and (TempPin < NumberPins.Count) then
    V721A.PinNumber := StrToInt(NumberPins[TempPin]);
  TempPin := ConfigFile.ReadInteger('PinNumbers', 'V721_I', -1);
  if (TempPin > -1) and (TempPin < NumberPins.Count) then
    V721_I.PinNumber := StrToInt(NumberPins[TempPin]);
  TempPin := ConfigFile.ReadInteger('PinNumbers', 'V721_II', -1);
  if (TempPin > -1) and (TempPin < NumberPins.Count) then
    V721_II.PinNumber := StrToInt(NumberPins[TempPin]);
end;

procedure TIVchar.ComponentView;
 var i:integer;
begin
  PanelV721_I.Height := round(0.48*PanelV721_I.Parent.Height);
  PanelV721_II.Height := round(0.48*PanelV721_II.Parent.Height);
  ChLine.Top:=0;
  ChLine.Left:=0;
  ChLine.Height := round(ChLine.Parent.Height / 2);
  ChLine.Width:= round(0.7*ChLine.Parent.Width);
  ChLg.Top:=round(ChLg.Parent.Height / 2);
  ChLg.Left:=0;
  ChLg.Height := round(ChLg.Parent.Height / 2);
  ChLg.Width:= round(0.7*ChLg.Parent.Width);

//  BIVStop.Enabled:=False;
//  BIVSave.Enabled:=False;
  LADVoltageValue.Caption:=Undefined;
  LADCurrentValue.Caption:=Undefined;
  LTRValue.Caption:=Undefined;
  LTLastValue.Caption:=Undefined;

  try
  for i := Main.ComponentCount - 1 downto 0 do
   begin
     if Main.Components[i].Tag = 1 then
      (Main.Components[i] as TComboBox).Sorted:=False;
     if Main.Components[i].Tag = 2 then
      (Main.Components[i] as TUpDown).Max:=round(10*Vmax);
     if Main.Components[i].Tag = 3 then
      begin
      (Main.Components[i] as TStringGrid).Cells[0,0]:='Limit';
      (Main.Components[i] as TStringGrid).Cells[1,0]:='Step';
      (Main.Components[i] as TStringGrid).ColWidths[0]:=(Main.Components[i] as TStringGrid).Canvas.TextWidth('Limit')+15;
      (Main.Components[i] as TStringGrid).ColWidths[1]:=(Main.Components[i] as TStringGrid).Canvas.TextWidth('0.005')+15;
      end;
     if Main.Components[i].Tag = 4 then
      (Main.Components[i] as TButton).Enabled:=False;
   end;
  finally
  end;

//  SGFBStep.Cells[0,0]:='Limit';
//  SGFBStep.Cells[1,0]:='Step';

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
