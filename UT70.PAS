unit UT70;

interface

uses
  RS232device, ExtCtrls, StdCtrls, Buttons,PacketParameters, CPort;


type
  TUT70_MeasurementType=(CUR,MAX,MIN,AVE);
  {що саме показує мультиметр:
  поточне значення (CUR), максимальне(MAX),
  мінімальне (MIN) чи середнє(AVE)}

  TUT70_MeasureMode=(UD,UA,ID,IA,R,P,D,C,F,O,T,G);
  {UD та UA - постійна та змінна напруга
   ID та IA - постійний та змінний струм
    R - опір
    P - прозвонювання опору
    D - перевірка діоду
    С - ємність
    F - частота
    О - обороти
    Т - температура в градусах Цельсію
    G - температура в Фаренгейтах
  }
  TUT70_Diapazons=
        (mV400,V4,V40,V400,V750,
         micA400,mA4,mA40,mA400,A10,
         O400,kO4,kO40,kO400,MO4,MO40,
         CT,DT,
         nF4,nF40,nF400,micF4,micF40,micF400,mF4,mF40,
         kHz4,kHz40,kHz400,MHz4,MHz40,MHz400,
         RMP,TemC,TemF
         );

  TUT70_DiapazoneMode=(Manual,Auto);



const
  UT70_PacketBeginChar=#10;
  UT70_PacketEndChar=#13;

  UT70_MeasureModeLabels:array[TUT70_MeasureMode]of string=
   (UD_Label, UA_Label, ID_Label, IA_Label,'Ohm','*)))','-|>|-','-|(-',
    'Hz','RPM','C','F');

  UT70_DiapazonsLabels:array[TUT70_Diapazons]of string=
   ('400 mV', '4 V', '40 V', '400 V', '750 V',
    '400 micA','4 mA','40 mA', '400 mA','10 A',
    '400 Ohm','4 kOhm','40 kOhm','400 kOhm','4 MOhm','40 MOhm',
    'Continuity test','Diode test',
    '4 nF','40 nF','400 nF','4 micF','40 micF','400 micF','4 mF','40 mF',
    '4 kHz','40 kHz','400 kHz','4 MHz','40 MHz','400 MHz',
    '40 kRPM','-40~1000 C','-40~1832 F'
    );

   UT70_MeasureTypeLabels:array[TUT70_MeasurementType] of string=
   ('ORD','MAX','MIN','AVE');

   UT70_DiapazoneModeLabels:array[TUT70_DiapazoneMode] of string=
   ('Manual','AUTO');

type

  TUT70B=class(TRS232Meter)
  private
    fAUTO:Boolean;
    {TRUE при автоматичному виборі діапазону вимірювань та FALSE при ручному}
    fOUT: Boolean;
    {TRUE при зашкалюванні}
//    fMeasureTypeAll:array of string;
    fDiapazoneModeAll:array of string;
//    procedure ComPortSetup;
    procedure NamesFilling;
    procedure DiapazonFilling(DiapazonNumber:byte;
                              D_Begin, D_End:TUT70_Diapazons);
   protected
     Procedure PacketReceiving(Sender: TObject; const Str: string);override;
     Procedure MModeDetermination(Data:array of byte);override;
     Procedure DiapazonDetermination(Data:array of byte);override;
     Procedure ValueDetermination(Data:array of byte);override;
     Function MeasureModeLabelRead():string;override;
   public
     Constructor Create(CP:TComPort;Nm:string);override;
     Function Request():boolean;override;
  end;

  TUT70BShow=class(TMetterShow)
    protected
     DiapazoneMode:TRadioGroup;
     AdapterDiapazoneMode:TAdapterRadioGroupClick;
    public
     Constructor Create(UT70B:TUT70B;
                        MM,R:TRadioGroup;
                        DM:TRadioGroup;
                        DL,UL:TLabel;
                        MB:TButton;
                        AB:TSpeedButton;
                        TT:TTimer
                        );
   procedure MetterDataShow();override;
   Procedure Free;override;
  end;

implementation

uses
  OlegType, Dialogs;

{ UT70B }

//procedure TUT70B.ConvertToValue(Data: array of byte);
//var
//  i: Integer;
//begin
//  if High(Data)<>8 then Exit;
//  if Data[7]<>48 then Exit;
//  for i := 0 to 8 do
//   if (Data[i] shr 4)=3 then Exit;
//   
//  inherited ConvertToValue(Data);
//end;

constructor TUT70B.Create(CP:TComPort;Nm:string);
begin
 inherited Create(CP,Nm);
 fComPacket.StartString := UT70_PacketBeginChar;
 fComPacket.StopString := UT70_PacketEndChar;
 NamesFilling;
end;

procedure TUT70B.DiapazonDetermination(Data: array of byte);
begin
  fDiapazon:=-1;
  fAUTO:=((Data[8] and 2)>0);
  fDiapazon:=Data[0];
  if fDiapazon>7 then fDiapazon:=-1;
end;

procedure TUT70B.DiapazonFilling(DiapazonNumber: byte;
                                 D_Begin,D_End: TUT70_Diapazons);
 var UT70_D:TUT70_Diapazons;
begin
  SetLength(fDiapazonAll[DiapazonNumber],ord(D_End)-ord(D_Begin)+1);
  for UT70_D := D_Begin to D_End
        do fDiapazonAll[DiapazonNumber][ord(UT70_D)-ord(D_Begin)]:=UT70_DiapazonsLabels[UT70_D];
end;


function TUT70B.MeasureModeLabelRead: string;
begin
 inherited MeasureModeLabelRead();
 if (fMeasureMode=ord(IA))or(fMeasureMode=ord(ID))
    then Result:=' A';
 if (fMeasureMode=ord(UA))or(fMeasureMode=ord(UD))
    then Result:=' V';
 if (fMeasureMode=ord(O)) then Result:='RP';
 if (fMeasureMode=ord(F)) then Result:='Hz';
 if (fMeasureMode=ord(T)) then Result:=' C';
 if (fMeasureMode=ord(G)) then Result:=' f';
 if (fMeasureMode=ord(C)) then Result:=' F';
 if (fMeasureMode=ord(R)) then Result:=' R';
end;


procedure TUT70B.MModeDetermination(Data: array of byte);
begin
  case Data[5] of
   1: fMeasureMode:=ord(D);
   2: if (Data[6] and $08)>0 then fMeasureMode:=ord(O)
                             else fMeasureMode:=ord(F);
   3: fMeasureMode:=ord(R);
   4: if (Data[6] and $08)>0 then fMeasureMode:=ord(T)
                             else fMeasureMode:=ord(G);
   5: fMeasureMode:=ord(P);
   6: fMeasureMode:=ord(C);
   9,13,15: if (Data[8] and $08)>0 then fMeasureMode:=ord(ID)
                                   else fMeasureMode:=ord(IA);
   11:      if (Data[8] and $08)>0 then fMeasureMode:=ord(UD)
                                   else fMeasureMode:=ord(UA);
   else fMeasureMode:=-1;
  end;
end;

procedure TUT70B.PacketReceiving(Sender: TObject; const Str: string);
  var i:integer;
begin

  SetLength(fData,Length(Str));
  for I := 0 to High(fData) do
    fData[i]:=ord(str[i+1]);

  if High(fData)<>8 then Exit;
  if fData[7]<>48 then Exit;
  for i := 0 to 8 do
   begin
    if (fData[i] shr 4)<>3 then Exit;
    fData[i]:=(fData[i] and $0F)
   end;

 fIsReceived:=True;
end;

function TUT70B.Request: boolean;
begin
  if fComPort.Connected then
    begin
     fComPort.AbortAllAsync;
     fComPort.ClearBuffer(True, True);
     fComPort.SetDTR(True);
     Result:=True;
    end
                        else
     Result:=False;
end;

procedure TUT70B.ValueDetermination(Data: array of byte);
 var x:double;
begin
 fValue:=ErResult;
 fOUT:=((Data[6] and 1)>0);
 if fOUT then Exit;

 x:=Data[4]+10*Data[3]+100*Data[2]+1000*Data[1];

 if (fMeasureMode=ord(IA))or(fMeasureMode=ord(ID)) then
       case fDiapazon of
         0:case Data[5] of
           15:x:=x*1e-2;
            9:x:=x*1e-5;
           13:x:=x*1e-7;
           else Exit;
           end;
         1:case Data[5] of
            9:x:=x*1e-4;
           13:x:=x*1e-6;
           else Exit;
           end;
         else Exit;
       end;
 //-------??????????????????
 if fMeasureMode=ord(UA) then
      case fDiapazon of
         0:x:=x*1e-4;
         1:x:=x*1e-3;
         2:x:=x*1e-2;
         3:x:=x*1e-1;
         4:;
         else Exit;
      end;

 if fMeasureMode=ord(UD) then
      case fDiapazon of
         0:x:=x*1e-4;
         1:x:=x*1e-3;
         2:x:=x*1e-2;
         3:x:=x*1e-1;
         4:;
         else Exit;
      end;

 if fMeasureMode=ord(R) then
      case fDiapazon of
         0:x:=x*1e-1;
         1:x:=x;
         2:x:=x*1e1;
         3:x:=x*1e2;
         4:x:=x*1e3;
         5:x:=x*1e4;
         else Exit;
      end;

 if (fMeasureMode=ord(P))or(fMeasureMode=ord(D)) then
   if fDiapazon=0 then x:=x*1e-1 else Exit;

 if fMeasureMode=ord(C) then
      case fDiapazon of
          0:x:=x*1e-12;
          1:x:=x*1e-11;
          2:x:=x*1e-10;
          3:x:=x*1e-9;
          4:x:=x*1e-8;
          5:x:=x*1e-7;
          6:x:=x*1e-6;
          7:x:=x*1e-5
          else Exit;
      end;

 if fMeasureMode=ord(F) then
      case fDiapazon of
          0:;
          1:x:=x*1;
          2:x:=x*2;
          3:x:=x*3;
          4:x:=x*4;
          5:x:=x*5;
          else Exit;
      end;


 if fMeasureMode=ord(O) then x:=x*0.01;

 if ((Data[6] and 4)>0) then fValue:=-1*x
                        else fValue:=x;

end;


procedure TUT70B.NamesFilling;
var
  UT70_MeasureMode: TUT70_MeasureMode;
//  UT70_MT:TUT70_MeasurementType;
  UT70_DM:TUT70_DiapazoneMode;
begin
  SetLength(fMeasureModeAll, ord(High(UT70_MeasureModeLabels)) + 1);
  for UT70_MeasureMode := Low(TUT70_MeasureMode) to High(UT70_MeasureMode) do
    fMeasureModeAll[ord(UT70_MeasureMode)] := UT70_MeasureModeLabels[UT70_MeasureMode];
  SetLength(fDiapazonAll, High(fMeasureModeAll) + 1);

  {UD}
  DiapazonFilling(0,mV400,V750);
  {UA}
  DiapazonFilling(1,mV400,V750);
  {ID}
  DiapazonFilling(2,micA400,A10);
  {IA}
  DiapazonFilling(3,micA400,A10);
   {R}
  DiapazonFilling(4,O400,MO40);
  {P}
  DiapazonFilling(5,CT,CT);
  {D}
  DiapazonFilling(6,DT,DT);
  {C}
  DiapazonFilling(7,nF4,mF40);
   {F}
  DiapazonFilling(8,kHz4,MHz400);
  {O}
  DiapazonFilling(9,RMP,RMP);
  {T}
  DiapazonFilling(10,TemC,TemC);
  {G}
  DiapazonFilling(11,TemF,TemF);

//  SetLength(fMeasureTypeAll, ord(High(UT70_MeasureTypeLabels)) + 1);
//  for UT70_MT := Low(TUT70_MeasurementType) to High(TUT70_MeasurementType) do
//    fMeasureTypeAll[ord(UT70_MT)] := UT70_MeasureTypeLabels[UT70_MT];


    SetLength(fDiapazoneModeAll, ord(High(UT70_DiapazoneModeLabels)) + 1);
  for UT70_DM := Low(TUT70_DiapazoneMode) to High(TUT70_DiapazoneMode) do
    fDiapazoneModeAll[ord(UT70_DM)] := UT70_DiapazoneModeLabels[UT70_DM];

end;

//procedure TUT70B.ComPortSetup;
//begin
//  fComPacket.StartString := UT70_PacketBeginChar;
//  fComPacket.StopString := UT70_PacketEndChar;
//
////  fComPort.BaudRate := br2400;
////  fComPort.StopBits := sbOneStopBit;
////  fComPort.DataBits := dbSeven;
////  fComPort.DataBits := dbEight;
////  fComPort.Parity.Bits := prOdd;
//end;

{ TUT70BShow }

constructor TUT70BShow.Create(UT70B: TUT70B;
                              MM, R, DM: TRadioGroup;
                              DL, UL: TLabel;
                              MB: TButton;
                              AB: TSpeedButton;
                              TT: TTimer);
begin
 inherited Create(UT70B,MM,R,DL,UL,MB,AB,TT);
 DiapazoneMode:=DM;
 StringArrayToRadioGroup(UT70B.fDiapazoneModeAll,DiapazoneMode);
 IndexToRadioGroup(1,DiapazoneMode);

  AdapterDiapazoneMode:=TAdapterRadioGroupClick.Create(DiapazoneMode.Items.Count-1);
  DiapazoneMode.OnClick:=AdapterDiapazoneMode.RadioGroupClick;
  DiapazoneMode.onEnter:=AdapterDiapazoneMode.RadioGroupOnEnter;
end;

procedure TUT70BShow.Free;
begin
  AdapterDiapazoneMode.Free;
  inherited Free;
end;

procedure TUT70BShow.MetterDataShow;
begin
  inherited MetterDataShow;

  DiapazoneMode.OnClick:=nil;
  IndexToRadioGroup(ord((RS232Meter as TUT70B).fAUTO),DiapazoneMode);
  DiapazoneMode.OnClick:=AdapterDiapazoneMode.RadioGroupClick;

  if (RS232Meter as TUT70B).fOUT then
     begin
      DataLabel.Caption:='  OL  ';
      UnitLabel.Caption:='';
     end;
end;

end.
