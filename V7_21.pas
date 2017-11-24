unit V7_21;

interface

uses
  SPIdevice, ExtCtrls, StdCtrls, Buttons, RS232device, CPort;



type
  TV721_MeasureMode=(UD,UA,ID,IA);

  TV721_Diapazons=
        (nA100,micA1,micA10,micA100,mA1,mA10,mA100,mA1000,
         mV10,mV100,V1,V10,V100,V1000);

const
  V7_21Command=$1;

  V721_MeasureModeLabels:array[TV721_MeasureMode]of string=
   (UD_Label, UA_Label, ID_Label, IA_Label);



  V721_DiapazonsLabels:array[TV721_Diapazons]of string=
   ('100 nA','1 micA','10 micA','100 micA',
    '1 mA','10 mA','100 mA','1000 mA',
     '10 mV','100 mV','1 V','10 V','100 V','1000 V');



type
  TVoltmetr=class(TArduinoMeter)
  {базовий клас для вольтметрів серії В7-21}
  protected
   Procedure ValueDetermination(Data:array of byte);override;
   Procedure DiapazonFilling(DiapazonNumber:byte;
                             D_Begin, D_End:TV721_Diapazons);
   Function MeasureModeLabelRead():string;override;
   procedure   PacketCreateToSend(); override;
  public
   Procedure ConvertToValue();override;
   Function ResultProblem(Rez:double):boolean;override;
   Constructor Create(CP:TComPort;Nm:string);override;
//   procedure ComPortUsing();override;
   function GetData():double;override;
   procedure GetDataThread(WPARAM: word;EventEnd:THandle);override;
  end;

  TV721A=class(TVoltmetr)
  protected
   Procedure MModeDetermination(Data:array of byte);override;
   Procedure DiapazonDetermination(Data:array of byte);override;
  public
  end;

  TV721=class(TVoltmetr)
  protected
   Procedure MModeDetermination(Data:array of byte);override;
   Procedure DiapazonDetermination(Data:array of byte);override;
   Procedure ValueDetermination(Data:array of byte);override;
  public
   Constructor Create(CP:TComPort;Nm:string);override;
  end;

  TV721_Brak=class(TV721)
  {коричнева банка, при пайці переплутано 2 контакти}
  protected
   Procedure DiapazonDetermination(Data:array of byte);override;
  public
  end;

  TVoltmetrShow=class(TMetterShow)
  protected
  public
   PinShow:TPinsShow;
   Constructor Create(V:TVoltmetr;
                      MM,R:TRadioGroup;
                      DL,UL,CPL,GPL:TLabel;
                      SCB,SGB,MB:TButton;
                      AB:TSpeedButton;
                      PCB:TComboBox;
                      TT:TTimer);
   Procedure Free; override;
   procedure NumberPinShow();
   procedure ButtonEnabled();
  end;

implementation

uses   PacketParameters, Math, SysUtils, OlegMath, OlegType, RS232_Meas_Tread;

Constructor TVoltmetr.Create(CP:TComPort;Nm:string);
 var V721_MeasureMode:TV721_MeasureMode;
begin
  inherited Create(CP,Nm);
  fMetterKod:=V7_21Command;

  SetLength(fMeasureModeAll,ord(High(V721_MeasureModeLabels))+1);
  for V721_MeasureMode := Low(TV721_MeasureMode)
      to High(TV721_MeasureMode)
        do fMeasureModeAll[ord(V721_MeasureMode)]:=V721_MeasureModeLabels[V721_MeasureMode];

  SetLength(fDiapazonAll,High(fMeasureModeAll)+1);

  {UD}
  DiapazonFilling(0,mV10,V1000);
  {UA}
  DiapazonFilling(1,mV100,V1000);
  {ID}
  DiapazonFilling(2,nA100,mA1000);
  {IA}
  DiapazonFilling(3,micA100,mA1000);
end;

procedure TVoltmetr.DiapazonFilling(DiapazonNumber:byte;
                              D_Begin, D_End: TV721_Diapazons);
 var V721_Diapazons:TV721_Diapazons;
begin
  SetLength(fDiapazonAll[DiapazonNumber],ord(D_End)-ord(D_Begin)+1);
  for V721_Diapazons := D_Begin to D_End
        do fDiapazonAll[DiapazonNumber][ord(V721_Diapazons)-ord(D_Begin)]:=V721_DiapazonsLabels[V721_Diapazons];
end;

function TVoltmetr.GetData(): double;
 function AditionMeasurement(a,b:double):double;
  var c:double;
  begin
    if abs(a-b)<1e-5*Max(abs(a),abs(b))
     then
      Result:=(a+b)/2
     else
      begin
        sleep(100);
        c:=Measurement();
        Result:=MedianFiltr(a,b,c);
      end;
  end;
 var a,b:double;

begin
  Result:=ErResult;
  if not(PortConnected) then Exit;

 a:=Measurement();
 sleep(100);
 b:=Measurement();
 Result:=AditionMeasurement(a,b);
 if Result=0 then
   begin
     sleep(300);
     a:=Measurement();
     sleep(100);
     b:=Measurement();
     Result:=AditionMeasurement(a,b);
   end;
 fNewData:=True;
end;


procedure TVoltmetr.GetDataThread(WPARAM: word;EventEnd:THandle);
begin
  if PortConnected then
   fRS232MeasuringTread:=TV721_MeasuringTread.Create(Self,WPARAM,EventEnd);
end;

function TVoltmetr.MeasureModeLabelRead: string;
begin
 inherited MeasureModeLabelRead();
 if (fMeasureMode=ord(IA))or(fMeasureMode=ord(ID))
    then Result:=' A';
 if (fMeasureMode=ord(UA))or(fMeasureMode=ord(UD))
    then Result:=' V';
end;

procedure TVoltmetr.PacketCreateToSend;
begin
  PacketCreate([fMetterKod,Pins.PinControl,Pins.PinGate]);
end;

Procedure TVoltmetr.ValueDetermination(Data:array of byte);
 var temp:double;
begin
 temp:=BCDtoDec(Data[0],True);

 temp:=BCDtoDec(Data[0],False)*10+temp;
 temp:=temp+BCDtoDec(Data[1],True)*100;
 temp:=temp+BCDtoDec(Data[1],False)*1000;
 temp:=temp+((Data[2] shr 4)and$1)*10000;
 if (Data[2] shr 5)and$1>0 then temp:=-temp;

 fValue:=ErResult;
 if fMeasureMode=ord(IA) then
        case fDiapazon of
         {micA100}0: fValue:=temp*1e-8;
         {mA1}    1: fValue:=temp*1e-7;
         {mA10}   2: fValue:=temp*1e-6;
         {mA100}  3: fValue:=temp*1e-5;
         {mA1000} 4: fValue:=temp*1e-4;
        end;
 if fMeasureMode=ord(ID) then
        case fDiapazon of
         {nA100}  0: fValue:=temp*1e-11;
         {micA1}  1: fValue:=temp*1e-10;
         {micA10} 2: fValue:=temp*1e-9;
         {micA100}3: fValue:=temp*1e-8;
         {mA1}    4: fValue:=temp*1e-7;
         {mA10}   5: fValue:=temp*1e-6;
         {mA100}  6: fValue:=temp*1e-5;
         {mA1000} 7: fValue:=temp*1e-4;
        end;
 if fMeasureMode=ord(UA) then
        case fDiapazon of
         {mV100} 0: fValue:=temp*1e-5;
         {V1}    1: fValue:=temp*1e-4;
         {V10}   2: fValue:=temp*1e-3;
         {V100}  3: fValue:=temp*1e-2;
         {V1000} 4: fValue:=temp*1e-1;
        end;
 if fMeasureMode=ord(UD) then
        case fDiapazon of
         {mV10}  0: fValue:=temp*1e-6;
         {mV100} 1: fValue:=temp*1e-5;
         {V1}    2: fValue:=temp*1e-4;
         {V10}   3: fValue:=temp*1e-3;
         {V100}  4: fValue:=temp*1e-2;
         {V1000} 5: fValue:=temp*1e-1;
        end;
end;

function TVoltmetr.ResultProblem(Rez: double): boolean;
begin
 Result:=(abs(Rez)<1e-14);
end;

//procedure TVoltmetr.ComPortUsing;
//begin
//  PacketCreate([fMetterKod,Pins.PinControl,Pins.PinGate]);
//  fError:=not(PacketIsSend(fComPort,'Voltmetr '+Name+' measurement is unsuccessful'));
//end;

Procedure TVoltmetr.ConvertToValue();
begin
  if High(fData)<>3 then Exit;
  inherited ConvertToValue();
end;

Procedure TV721A.MModeDetermination(Data:array of byte);
 var temp:byte;
begin
 temp:=Data[2] and $0F;
  case temp of
   1: fMeasureMode:=ord(UD);
   2: fMeasureMode:=ord(UA);
   4: fMeasureMode:=ord(ID);
   8: fMeasureMode:=ord(IA);
   else fMeasureMode:=-1;
  end;
end;

Procedure TV721.MModeDetermination(Data:array of byte);
 var temp:byte;
begin
 temp:=Data[2] and $0F;
  case temp of
   7: fMeasureMode:=ord(UD);
   5: fMeasureMode:=ord(UA);
   3: fMeasureMode:=ord(ID);
   else fMeasureMode:=-1;
  end;
end;

Procedure TV721A.DiapazonDetermination(Data:array of byte);
begin
  fDiapazon:=-1;
  if Frac(Log2( Data[3]))=0 then
   begin
    if fMeasureMode=ord(ID) then
       fDiapazon:= round(Log2( Data[3]));
    if (fMeasureMode=ord(IA))or(fMeasureMode=ord(UA)) then
       fDiapazon:= round(Log2( Data[3]))-3;
    if fMeasureMode=ord(UD) then
       fDiapazon:= round(Log2( Data[3]))-2;
   end;
  if fDiapazon<-1 then fDiapazon:=-1;

//  if fMeasureMode=ord(ID) then
//   case Data[3] of
//   128:fDiapazon:=7;  // mA1000
//   64: fDiapazon:=6;  // mA100
//   32: fDiapazon:=5;  // mA10
//   16: fDiapazon:=4;  // mA1
//   8:  fDiapazon:=3;  // micA100
//   4:  fDiapazon:=2;  // micA10
//   2:  fDiapazon:=1;  // micA1
//   1:  fDiapazon:=0;  // nA100
//   end;
//
//  if fMeasureMode=ord(IA) then
//   case Data[3] of
//   128:fDiapazon:=4;  // mA1000
//   64: fDiapazon:=3;  // mA100
//   32: fDiapazon:=2;  // mA10
//   16: fDiapazon:=1;  // mA1
//   8:  fDiapazon:=0;  // micA100
//   end;
//
//  if fMeasureMode=ord(UD) then
//   case Data[3] of
//   128:fDiapazon:=5;  // V1000
//   64: fDiapazon:=4;  // V100
//   32: fDiapazon:=3;  // V10
//   16: fDiapazon:=2;  // V1
//   8:  fDiapazon:=1;  // mV100
//   4:  fDiapazon:=0;  // mV10
//   end;
//
//  if fMeasureMode=ord(UA) then
//   case Data[3] of
//   128:fDiapazon:=4;  // V1000
//   64: fDiapazon:=3;  // V100
//   32: fDiapazon:=2;  // V10
//   16: fDiapazon:=1;  // V1
//   8:  fDiapazon:=0;  // mV100
//   end;


end;


constructor TV721.Create(CP:TComPort;Nm:string);
begin
  inherited Create(CP,Nm);
  SetLength(fMeasureModeAll,High(fMeasureModeAll));
  fDiapazonAll[0][High(fDiapazonAll[0])]:='500 V';
  fDiapazonAll[1][High(fDiapazonAll[1])]:='500 V';
end;

Procedure TV721.DiapazonDetermination(Data:array of byte);
begin
  fDiapazon:=-1;
  if fMeasureMode=ord(ID) then
   case Data[3] of
   127:fDiapazon:=7;  // mA1000
   191: fDiapazon:=6;  // mA100
   223: fDiapazon:=5;  // mA10
   239: fDiapazon:=4;  // mA1
   247: fDiapazon:=3;  // micA100
   251: fDiapazon:=2;  // micA10
   253: fDiapazon:=1;  // micA1
   254: fDiapazon:=0;  // nA100
   end;


  if fMeasureMode=ord(UD) then
   case Data[3] of
   127:fDiapazon:=5;  // V1000
   191:fDiapazon:=4;  // V100
   223:fDiapazon:=3;  // V10
   239:fDiapazon:=2;  // V1
   247:fDiapazon:=1;  // mV100
   251:fDiapazon:=0;  // mV10
   end;


  if fMeasureMode=ord(UA) then
   case Data[3] of
   127:fDiapazon:=4;  // V1000
   191:fDiapazon:=3;  // V100
   223:fDiapazon:=2;  // V10
   239:fDiapazon:=1;  // V1
   247:fDiapazon:=0;  // mV100
   end;
end;


Procedure TV721.ValueDetermination(Data:array of byte);
begin
  inherited ValueDetermination(Data);
  if fValue<>ErResult then fValue:=-fValue;
end;

Constructor TVoltmetrShow.Create(V:TVoltmetr;
                      MM,R:TRadioGroup;
                      DL,UL,CPL,GPL:TLabel;
                      SCB,SGB,MB:TButton;
                      AB:TSpeedButton;
                      PCB:TComboBox;
                      TT:TTimer);
begin
  inherited Create(V,MM,R,DL,UL,MB,AB,TT);
  PinShow:=TPinsShow.Create(V.Pins,CPL,GPL,SCB,SGB,PCB);
end;

procedure TVoltmetrShow.Free;
begin
 PinShow.Free;
 inherited Free;
end;

procedure TVoltmetrShow.NumberPinShow();
begin
 PinShow.NumberPinShow();
 ButtonEnabled()
end;

procedure TVoltmetrShow.ButtonEnabled();
begin
  MeasurementButton.Enabled:=((RS232Meter as TVoltmetr).Pins.PinControl<>UndefinedPin)and
                             ((RS232Meter as TVoltmetr).Pins.PinGate<>UndefinedPin);
  AutoSpeedButton.Enabled:=MeasurementButton.Enabled;
end;

{ TV721_Brak }

procedure TV721_Brak.DiapazonDetermination(Data:array of byte);
begin
  fDiapazon:=-1;
  if fMeasureMode=ord(ID) then
   case Data[3] of
   127:fDiapazon:=7;  // mA1000
   239: fDiapazon:=6;  // mA100
   223: fDiapazon:=5;  // mA10
   191: fDiapazon:=4;  // mA1
   247: fDiapazon:=3;  // micA100
   251: fDiapazon:=2;  // micA10
   253: fDiapazon:=1;  // micA1
   254: fDiapazon:=0;  // nA100
   end;

  if fMeasureMode=ord(UD) then
   case Data[3] of
   127:fDiapazon:=5;  // V1000
   239:fDiapazon:=4;  // V100
   223:fDiapazon:=3;  // V10
   191:fDiapazon:=2;  // V1
   247:fDiapazon:=1;  // mV100
   251:fDiapazon:=0;  // mV10
   end;

  if fMeasureMode=ord(UA) then
   case Data[3] of
   127:fDiapazon:=4;  // V1000
   239:fDiapazon:=3;  // V100
   223:fDiapazon:=2;  // V10
   191:fDiapazon:=1;  // V1
   247:fDiapazon:=0;  // mV100
   end;
end;

end.
