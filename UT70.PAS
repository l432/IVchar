unit UT70;

interface

uses
  RS232device, ExtCtrls, StdCtrls, Buttons, CPort;


type
  TUT70_MeasurementType=(CUR,MAXX,MINN,AVE);
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

 TUT70C_MeasureMode=(UD_c,UA_c,ID_c,IA_c,R_c,P_c,D_c,C_c,F_c,M_c,S_c);
  {UD_c та UA_c - постійна та змінна напруга
   ID_c та IA_c - постійний та змінний струм
    R_c - опір
    P_c - прозвонювання опору
    D_c - перевірка діоду
    С_c - ємність
    F_c - частота
    M_c - duty cycle
    S_c - провідність
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
  TUT70C_Diapazons=
        (mV80,mV800,V8,V80,V800,V1000,
         mA80,mA800,A8,A10_c,
         O800,kO8,kO80,kO800,MO8,MO80,
         CT_c,DT_c,
         nF1,nF10,nF100,micF1,micF10,micF100,
         kHz1,kHz10,kHz100,MHz1,
         DC,nS80
         );

  TUT70_DiapazoneMode=(Manual,Auto);



const
  UT70_PacketBeginChar=#10;
  UT70_PacketEndChar=#13;

  UT70C_PacketBeginChar=#137;
  UT70C_PacketEndChar=#10;

   R_Label='Ohm';
   P_Label='*)))';
   D_Label='-|>|-';
   C_Label='-|(-';
   F_Label='Hz';


  UT70_MeasureModeLabels:array[TUT70_MeasureMode]of string=
   (UD_Label, UA_Label, ID_Label, IA_Label,R_Label,P_Label,
    D_Label,C_Label,F_Label,'RPM','C','F');

  UT70C_MeasureModeLabels:array[TUT70C_MeasureMode]of string=
   (UD_Label, UA_Label, ID_Label, IA_Label,R_Label,P_Label,
    D_Label,C_Label,F_Label,'%','Cond');

  UT70_DiapazonsLabels:array[TUT70_Diapazons]of string=
   ('400 mV', '4 V', '40 V', '400 V', '750 V',
    '400 micA','4 mA','40 mA', '400 mA','10 A',
    '400 Ohm','4 kOhm','40 kOhm','400 kOhm','4 MOhm','40 MOhm',
    'Continuity test','Diode test',
    '4 nF','40 nF','400 nF','4 micF','40 micF','400 micF','4 mF','40 mF',
    '4 kHz','40 kHz','400 kHz','4 MHz','40 MHz','400 MHz',
    '40 kRPM','-40~1000 C','-40~1832 F'
    );

  UT70C_DiapazonsLabels:array[TUT70C_Diapazons]of string=
   ('80 mV', '800 mV', '8 V', '80 V', '800 V', '1000 V',
    '80 mA', '800 mA','8 A', '10 A',
    '800 Ohm','8 kOhm','80 kOhm','800 kOhm','8 MOhm','80 MOhm',
    'Continuity test','Diode test',
    '1 nF','10 nF','100 nF','1 micF','10 micF','100 micF',
    '1 kHz','10 kHz','100 kHz','1 MHz',
    '1% ~ 99%','80 nS'
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
    fDiapazoneModeAll:array of string;
    procedure NamesFilling;virtual;
    procedure DiapazonFilling(DiapazonNumber:byte;
                              D_Begin, D_End:TUT70_Diapazons);overload;
    procedure MeasureModesFilling;virtual;
    procedure DiapazonsFilling;virtual;
    procedure DiapasonModesFilling;
   protected
     Procedure PacketReceiving(Sender: TObject; const Str: string);override;
     Procedure MModeDetermination(Data:array of byte);override;
     Procedure DiapazonDetermination(Data:array of byte);override;
     Procedure ValueDetermination(Data:array of byte);override;
     Function MeasureModeLabelRead():string;override;
   public
     Constructor Create(CP:TComPort;Nm:string);//override;
     procedure Request();override;
  end;

  TUT70C=class(TUT70B)
  private
    fHOLD:Boolean;
    {TRUE при натиснутій HOLD}
    fREC :Boolean;
    {TRUE при режимі MAX-MIN}
    fMeasurementType:TUT70_MeasurementType;
   {що саме показує мультиметр:
    поточне значення (CUR), максимальне(MAX),
    мінімальне (MIN) чи середнє(AVE)}
    fms1: Boolean;
    {TRUE при увімкненні пікового детектору
     (час накопичення 1 мс) та FALSE при
     часах накопичення 100 мс або 1 с --
     використовується в режимі REC}
    fMeasurementTypeAll:array of string;
    procedure MeasureModesFilling;override;
    procedure DiapazonsFilling;override;
    procedure MeasurementTypesFilling;
    procedure NamesFilling;override;
    procedure DiapazonFilling(DiapazonNumber:byte;
                              D_Begin, D_End:TUT70C_Diapazons);overload;
    procedure MeasurementTypeDetermination(Data: array of Byte);
    procedure PushButtom(ByteToSend: Byte);
   protected
     Procedure PacketReceiving(Sender: TObject; const Str: string);override;
     Procedure MModeDetermination(Data:array of byte);override;
     Procedure DiapazonDetermination(Data:array of byte);override;
     Procedure ValueDetermination(Data:array of byte);override;
     Function MeasureModeLabelRead():string;override;
   public
     Constructor Create(CP:TComPort;Nm:string);//override;
     procedure Request();override;
     procedure PushPeak;
     procedure PushHold;
     procedure PushMaxMin;
     procedure PushRange;
     procedure PushRel;
     procedure PushHz;
     procedure PushAcDc;
  end;


  TUT70BShow=class(TRS232MetterShow)
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

  TUT70CShow=class(TUT70BShow)
    protected
     HoldLabel,RecLabel,MeasTypeLabel,AvTimeLabel:TLabel;
    public
     Constructor Create(UT70C:TUT70C;
                        MM,R:TRadioGroup;
                        DM:TRadioGroup;
                        DL,UL:TLabel;
                        MB:TButton;
                        AB:TSpeedButton;
                        TT:TTimer;
                        HL,RL,MTL,ATL:TLabel
                        );
   procedure MetterDataShow();override;
  end;


var
  PacketToSend:array of byte;

implementation

uses
  OlegType, Dialogs, SysUtils;

{ UT70B }

constructor TUT70B.Create(CP:TComPort;Nm:string);
begin
 inherited Create(CP,Nm);
 RepeatInErrorCase:=True;
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

procedure TUT70B.Request;
begin
  if fComPort.Connected then
    begin
     fComPort.AbortAllAsync;
     fComPort.ClearBuffer(True, True);
     fComPort.SetDTR(True);
     fError:=False;
    end
                        else
     fError:=True;
end;

procedure TUT70B.DiapasonModesFilling;
var
  UT70_DM: TUT70_DiapazoneMode;
begin
  SetLength(fDiapazoneModeAll, ord(High(UT70_DiapazoneModeLabels)) + 1);
  for UT70_DM := Low(TUT70_DiapazoneMode) to High(TUT70_DiapazoneMode) do
    fDiapazoneModeAll[ord(UT70_DM)] := UT70_DiapazoneModeLabels[UT70_DM];
end;

procedure TUT70B.DiapazonsFilling;
begin
  SetLength(fDiapazonAll, High(fMeasureModeAll) + 1);
  {UD}
  DiapazonFilling(0, mV400, V750);
  {UA}
  DiapazonFilling(1, mV400, V750);
  {ID}
  DiapazonFilling(2, micA400, A10);
  {IA}
  DiapazonFilling(3, micA400, A10);
  {R}
  DiapazonFilling(4, O400, MO40);
  {P}
  DiapazonFilling(5, CT, CT);
  {D}
  DiapazonFilling(6, DT, DT);
  {C}
  DiapazonFilling(7, nF4, mF40);
  {F}
  DiapazonFilling(8, kHz4, MHz400);
  {O}
  DiapazonFilling(9, RMP, RMP);
  {T}
  DiapazonFilling(10, TemC, TemC);
  {G}
  DiapazonFilling(11, TemF, TemF);
end;

procedure TUT70B.MeasureModesFilling;
var
  UT70_MeasureMode: TUT70_MeasureMode;
begin
  SetLength(fMeasureModeAll, ord(High(UT70_MeasureModeLabels)) + 1);
  for UT70_MeasureMode := Low(TUT70_MeasureMode) to High(TUT70_MeasureMode) do
    fMeasureModeAll[ord(UT70_MeasureMode)] := UT70_MeasureModeLabels[UT70_MeasureMode];
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
          0:x:=x;
          1:x:=x*1e1;
          2:x:=x*1e2;
          3:x:=x*1e3;
          4:x:=x*1e4;
          5:x:=x*1e5;
          else Exit;
      end;


 if fMeasureMode=ord(O) then x:=x*0.01;

 if ((Data[6] and 4)>0) then fValue:=-1*x
                        else fValue:=x;

end;


procedure TUT70B.NamesFilling;
begin
  MeasureModesFilling;
  DiapazonsFilling;
  DiapasonModesFilling;
end;

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
      DataLabel.Caption:='     .OL';
     end;


end;

{ TUT70C }

constructor TUT70C.Create(CP: TComPort; Nm: string);
begin
  inherited Create(CP,Nm);
 fComPacket.StartString := UT70C_PacketBeginChar;
 fComPacket.StopString := UT70C_PacketEndChar;
end;

procedure TUT70C.DiapazonDetermination(Data: array of byte);
begin
  fDiapazon:=-1;
  fAUTO:=((Data[1] and $40)=0);
  fDiapazon:=((Data[1] shr 3) and $07);
  if fDiapazon>7 then fDiapazon:=-1;
  if (fMeasureMode=ord(S_c))or(fMeasureMode=ord(P_c))
                then fDiapazon:=0;
  if (Data[0] in [40,41,112]) then fDiapazon:=fDiapazon+2;
end;

procedure TUT70C.DiapazonFilling(DiapazonNumber: byte;
                                D_Begin,D_End: TUT70C_Diapazons);
 var D:TUT70C_Diapazons;
begin
  SetLength(fDiapazonAll[DiapazonNumber],ord(D_End)-ord(D_Begin)+1);
  for D := D_Begin to D_End
        do fDiapazonAll[DiapazonNumber][ord(D)-ord(D_Begin)]:=UT70C_DiapazonsLabels[D];
end;

procedure TUT70C.DiapazonsFilling;
begin
  SetLength(fDiapazonAll, High(fMeasureModeAll) + 1);
  {UD_c}
  DiapazonFilling(0, mV80, V1000);
  {UA_c}
  DiapazonFilling(1, mV800, V1000);
  {ID_c}
  DiapazonFilling(2, mA80, A10_c);
  {IA_c}
  DiapazonFilling(3, mA80, A10_c);
  {R_c}
  DiapazonFilling(4, O800, MO80);
  {P_c}
  DiapazonFilling(5, CT, CT);
  {D_c}
  DiapazonFilling(6, DT, DT);
  {C_c}
  DiapazonFilling(7, nF1, micF100);
  {F_c}
  DiapazonFilling(8, kHz1, MHz1);
  {M_c}
  DiapazonFilling(9, DC, DC);
  {S_c}
  DiapazonFilling(10, nS80, nS80);
end;

procedure TUT70C.MeasurementTypesFilling;
var
  MT: TUT70_MeasurementType;
begin
  SetLength(fMeasurementTypeAll, ord(High(UT70_MeasureTypeLabels)) + 1);
  for MT := Low(TUT70_MeasurementType) to High(TUT70_MeasurementType) do
    fMeasurementTypeAll[ord(MT)] := UT70_MeasureTypeLabels[MT];
end;

function TUT70C.MeasureModeLabelRead: string;
begin
 Result:='';
 if (fMeasureMode=ord(IA_c))or(fMeasureMode=ord(ID_c))
    then Result:=' A';
 if (fMeasureMode=ord(UA_c))or(fMeasureMode=ord(UD_c))
    then Result:=' V';
 if (fMeasureMode=ord(S_c)) then Result:='S';
 if (fMeasureMode=ord(F_c)) then Result:='Hz';
 if (fMeasureMode=ord(M_c)) then Result:=' %';
 if (fMeasureMode=ord(C_c)) then Result:=' F';
 if (fMeasureMode=ord(R_c)) then Result:=' R';
end;

procedure TUT70C.MeasureModesFilling;
var
  MM: TUT70C_MeasureMode;
begin
  SetLength(fMeasureModeAll, ord(High(UT70C_MeasureModeLabels)) + 1);
  for MM := Low(TUT70C_MeasureMode) to High(TUT70C_MeasureMode) do
    fMeasureModeAll[ord(MM)] := UT70C_MeasureModeLabels[MM];
end;

procedure TUT70C.MModeDetermination(Data: array of byte);
 var b,b2:byte;
begin
  fMeasureMode:=-1;
  b:=Data[1] and $07;
  if (b=0)and(Data[0]=97) then fMeasureMode:=ord(C_c);
  if (b=4)and(Data[0] in [120,112,104,40,41,48,49])
                          then fMeasureMode:=ord(F_c);
  if (b=5)and(Data[0] in [120,112,104,40,41,48,49])
                          then fMeasureMode:=ord(M_c);
  if (b=2) then
   case  Data[0] of
     120:fMeasureMode:=ord(UA_c);
     112,104:fMeasureMode:=ord(UD_c);
     96:begin
          b2:=(Data[2] and $04);
          if b2>0 then fMeasureMode:=ord(P_c)
                  else fMeasureMode:=ord(R_c);
          if (b2=0)and(((Data[1] shr 3) and $07)=6)
                  then fMeasureMode:=ord(S_c);
        end;
     88:fMeasureMode:=ord(D_c);
     40,48:fMeasureMode:=ord(ID_c);
     41,49:fMeasureMode:=ord(IA_c);
   end;
end;

procedure TUT70C.NamesFilling;
begin
  inherited NamesFilling;
  MeasurementTypesFilling;
end;

procedure TUT70C.PacketReceiving(Sender: TObject; const Str: string);
  var i:integer;
begin
  SetLength(fData,Length(Str));
  for I := 0 to High(fData) do
    fData[i]:=ord(str[i+1]);

  if High(fData)<>9 then Exit;
  for i := 0 to 9 do
    fData[i]:=(fData[i] and $7F);

  for I := 4 to 8 do
    fData[i]:=(fData[i] and $0F);

 fIsReceived:=True;
end;

procedure TUT70C.PushAcDc;
begin
 PushButtom(173);
end;

procedure TUT70C.PushButtom(ByteToSend: Byte);
begin
  if fComPort.Connected then
    begin
     fComPort.AbortAllAsync;
     fComPort.ClearBuffer(True, True);
     fComPort.SetDTR(True);
     SetLength(PacketToSend,1);
     PacketToSend[0]:=ByteToSend;
     fError:=(fComPort.Write(PacketToSend[0], 1)<>1);
    end
                        else
     fError:=True;
end;

procedure TUT70C.PushHold;
begin
  PushButtom(165);
end;

procedure TUT70C.PushHz;
begin
  PushButtom(163);
end;

procedure TUT70C.PushMaxMin;
begin
   PushButtom(169);
end;

procedure TUT70C.PushPeak;
begin
   PushButtom(171);
end;

procedure TUT70C.PushRange;
begin
  PushButtom(161);
end;

procedure TUT70C.PushRel;
begin
   PushButtom(167);
end;

procedure TUT70C.Request;
begin
 PushButtom(137);
end;

procedure TUT70C.MeasurementTypeDetermination(Data: array of Byte);
var
  b: Byte;
begin
  if fREC then
    begin
      b:=((Data[2] shr 3) and $03);
      if fms1 then
         case b of
          0:fMeasurementType:=MAXX;
          1:fMeasurementType:=MINN;
         end{case b of}
            else
         case b of
          0:fMeasurementType:=CUR;
          1:fMeasurementType:=MAXX;
          2:fMeasurementType:=MINN;
          3:fMeasurementType:=AVE;
         end;
    end   else fMeasurementType:=CUR;
end;

procedure TUT70C.ValueDetermination(Data: array of byte);
 var x:double;
begin
 fValue:=ErResult;

 fREC:=((Data[2] and $40)>0);


 fHOLD:=((Data[3] and $01)>0);
 fms1:=((Data[2] and $04)>0)and(fREC);

 MeasurementTypeDetermination(Data);

 fOUT:=((Data[3] and $08)>0);
 if fOUT then Exit;


 x:=Data[8]+10*Data[7]+100*Data[6]+1000*Data[5];
 if (fMeasureMode=ord(F_c))and(Data[4]<10)
                   then x:=x+10000*Data[4];

 if fMeasureMode=ord(UA_c) then
      case fDiapazon of
         0:x:=x*1e-4;
         1:x:=x*1e-3;
         2:x:=x*1e-2;
         3:x:=x*1e-1;
         4:;
         else Exit;
      end;

   if fMeasureMode=ord(UD_c) then
       case fDiapazon of
           0:x:=x*1e-5;
           1:x:=x*1e-4;
           2:x:=x*1e-3;
           3:x:=x*1e-2;
           4:x:=x*1e-1;
           5:;
           else Exit;
         end;

 if fMeasureMode=ord(R_c) then
      case fDiapazon of
         0:x:=x*1e-1;
         1:x:=x;
         2:x:=x*1e1;
         3:x:=x*1e2;
         4:x:=x*1e3;
         5:x:=x*1e4;
         else Exit;
      end;

 if fMeasureMode=ord(S_c) then
    if fDiapazon=0 then x:=x*1e-11
                   else Exit;

 if (fMeasureMode=ord(P_c))or(fMeasureMode=ord(D_c)) then
   if fDiapazon=0 then x:=x*1e-1 else Exit;

 if fMeasureMode=ord(C_c) then
      case fDiapazon of
          0:x:=x*1e-12;
          1:x:=x*1e-11;
          2:x:=x*1e-10;
          3:x:=x*1e-9;
          4:x:=x*1e-8;
          5:x:=x*1e-7;
          else Exit;
      end;

 if (fMeasureMode=ord(ID_c))or
    (fMeasureMode=ord(IA_c)) then
       case fDiapazon of
           0:x:=x*1e-5;
           1:x:=x*1e-4;
           2:x:=x*1e-3;
           3:x:=x*1e-2;
           else Exit;
         end;

 if fMeasureMode=ord(F_c) then
      case fDiapazon of
          0:x:=x*1e-2;
          1:x:=x*1e-1;
          2:;
          3:x:=x*1e1;
          else Exit;
      end;

 if fMeasureMode=ord(M_c) then x:=x*0.01;

 if ((Data[3] and $10)>0) then fValue:=-1*x
                         else fValue:=x;

end;

{ TUT70CShow }

constructor TUT70CShow.Create(UT70C: TUT70C;
                              MM, R, DM: TRadioGroup;
                              DL, UL: TLabel;
                              MB: TButton;
                              AB: TSpeedButton;
                              TT: TTimer;
                              HL, RL, MTL, ATL: TLabel);
begin
 inherited Create(UT70C, MM, R, DM, DL, UL, MB, AB, TT);
 HoldLabel:=HL;
 HoldLabel.Caption:='HOLD';
 HoldLabel.Enabled:=False;
 RecLabel:=RL;
 RecLabel.Caption:='REC';
 RecLabel.Enabled:=False;
 MeasTypeLabel:=MTL;
 MeasTypeLabel.Visible:=False;
 AvTimeLabel:=ATL;
 AvTimeLabel.Visible:=False;
end;

procedure TUT70CShow.MetterDataShow;
begin
  inherited MetterDataShow;

  HoldLabel.Enabled:=(RS232Meter as TUT70C).fHOLD;
  RecLabel.Enabled:=(RS232Meter as TUT70C).fREC;
  if (RS232Meter as TUT70C).fREC then
    begin
     if (RS232Meter as TUT70C).fms1
        then AvTimeLabel.Caption:=' 1 ms'
        else AvTimeLabel.Caption:='100 ms';

     MeasTypeLabel.Caption:=
        UT70_MeasureTypeLabels[(RS232Meter as TUT70C).fMeasurementType];

     AvTimeLabel.Visible:=True;
     MeasTypeLabel.Visible:=True;
    end                          else
    begin
     AvTimeLabel.Visible:=False;
     MeasTypeLabel.Visible:=False;
    end;


  if (RS232Meter as TUT70B).fOUT then
     begin
      DataLabel.Caption:='     .OL';
     end;


end;

end.
