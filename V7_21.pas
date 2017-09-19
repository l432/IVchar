unit V7_21;

interface

uses
  SPIdevice, ExtCtrls, StdCtrls, Buttons, Classes, RS232device;



type
//  TMeasureMode=(IA,ID,UA,UD,MMErr);
  TV721_MeasureMode=(UD,UA,ID,IA);
//  TMeasureModeSet=set of TMeasureMode;
//  TDiapazons=(nA100,micA1,micA10,micA100,mA1,mA10,mA100,mA1000,
//              mV10,mV100,V1,V10,V100,V1000,DErr);
  TV721_Diapazons=
        (nA100,micA1,micA10,micA100,mA1,mA10,mA100,mA1000,
         mV10,mV100,V1,V10,V100,V1000);

const

//  MeasureModeLabels:array[TMeasureMode]of string=
//   ('~ I', '= I','~ U', '= U','Error');
  V721_MeasureModeLabels:array[TV721_MeasureMode]of string=
   (UD_Label, UA_Label, ID_Label, IA_Label);


//  V721_CurrentLabels:array[nA100..mA1000]of string=
//    ('100 nA','1 micA','10 micA','100 micA',
//    '1 mA','10 mA','100 mA','1000 mA');
//
//  V721_VoltageLabels:array[mV10..V1000]of string=
//    ('10 mV','100 mV','1 V','10 V','100 V','1000 V');

  V721_DiapazonsLabels:array[TV721_Diapazons]of string=
   ('100 nA','1 micA','10 micA','100 micA',
    '1 mA','10 mA','100 mA','1000 mA',
     '10 mV','100 mV','1 V','10 V','100 V','1000 V');



type
  TVoltmetr=class(TArduinoMeter)
  {базовий клас для вольтметрів серії В7-21}
  protected
//   fMeasureMode:TMeasureMode;
//   fDiapazon:TDiapazons;
//   Procedure MModeDetermination(Data:byte); virtual;
//   Procedure MModeDetermination(Data:array of byte); override;
//   Procedure DiapazonDetermination(Data:byte); virtual;
//   Procedure DiapazonDetermination(Data:array of byte); override;
   Procedure ValueDetermination(Data:array of byte);override;
//   function GetData(LegalMeasureMode:TMeasureModeSet):double;
   function GetData():double;
//   function GetResistance():double;
   Function ResultProblem(Rez:double):boolean;override;
   Procedure DiapazonFilling(DiapazonNumber:byte;
                             D_Begin, D_End:TV721_Diapazons);
   Function MeasureModeLabelRead():string;override;
  public
//   property MeasureMode:TMeasureMode read FMeasureMode;
//   property Diapazon:TDiapazons read fDiapazon;
//   property Resistance:double read GetResistance;
   Procedure ConvertToValue(Data:array of byte);override;
   Constructor Create();overload;override;
   Function Request():boolean;override;
   function GetTemperature:double;override;
   function GetVoltage(Vin:double):double;override;
   function GetCurrent(Vin:double):double;override;
//   function GetResist():double;override;
  end;

  TV721A=class(TVoltmetr)
  protected
   Procedure MModeDetermination(Data:array of byte);override;
   Procedure DiapazonDetermination(Data:array of byte);override;
//   Procedure MModeDetermination(Data:byte);override;
//   Procedure DiapazonDetermination(Data:byte);override;
  public
  end;

  TV721=class(TVoltmetr)
  protected
//   Procedure MModeDetermination(Data:byte);override;
//   Procedure DiapazonDetermination(Data:byte);override;
   Procedure MModeDetermination(Data:array of byte);override;
   Procedure DiapazonDetermination(Data:array of byte);override;
   Procedure ValueDetermination(Data:array of byte);override;
  public
   Constructor Create();overload;override;
  end;

  TV721_Brak=class(TV721)
  {коричнева банка, при пайці переплутано 2 контакти}
  protected
   Procedure DiapazonDetermination(Data:array of byte);override;
  public
  end;


//  TVoltmetrShow=class(TSPIDeviceShow)
//  private
//   MeasureMode,Range:TRadioGroup;
//   DataLabel,UnitLabel:TLabel;
//   MeasurementButton:TButton;
//   Time:TTimer;
//   AdapterMeasureMode,AdapterRange:TAdapterRadioGroupClick;
//   procedure MeasurementButtonClick(Sender: TObject);
//   procedure AutoSpeedButtonClick(Sender: TObject);
//  public
//   AutoSpeedButton:TSpeedButton;
//   Constructor Create(V:TVoltmetr;
//                      MM,R:TRadioGroup;
//                      DL,UL,CPL,GPL:TLabel;
//                      SCB,SGB,MB:TButton;
//                      AB:TSpeedButton;
//                      PCB:TComboBox;
//                      TT:TTimer);
//   Procedure Free;
//   procedure NumberPinShow();override;
//   procedure ButtonEnabled();
//   procedure VoltmetrDataShow();
//  end;

  TVoltmetrShow=class(TMetterShow)
  protected
//   AdapterMeasureMode,AdapterRange:TAdapterRadioGroupClick;
  public
   PinShow:TPinsShow;
   Constructor Create(V:TVoltmetr;
                      MM,R:TRadioGroup;
                      DL,UL,CPL,GPL:TLabel;
                      SCB,SGB,MB:TButton;
                      AB:TSpeedButton;
                      PCB:TComboBox;
                      TT:TTimer);
   Procedure Free;
   procedure NumberPinShow();
   procedure ButtonEnabled();
//   procedure VoltmetrDataShow();
  end;




//Procedure DiapazonFill(Mode:TMeasureMode; Diapazons:TStrings);
{заповнює Diapazons можливими назвами діапазонів
з DiapazonsLabels залежно від Mode}

//Function DiapazonSelect(Mode:TMeasureMode;Diapazon:TDiapazons):integer;
{визначається порядковий номер, який
відповідає Diapazon при даному Mode}

implementation

uses   PacketParameters, Measurement, Math, SysUtils, OlegMath, OlegType;


//Constructor TVoltmetr.Create();
//begin
//  inherited Create();
//  fMetterKod:=V7_21Command;
//  fMeasureMode:=MMErr;
//  fDiapazon:=DErr;
//end;

Constructor TVoltmetr.Create();
 var V721_MeasureMode:TV721_MeasureMode;
begin
  inherited Create();
  fMetterKod:=V7_21Command;
  SetLength(fMeasureModeAll,ord(High(V721_MeasureModeLabels))+1);
  for V721_MeasureMode := Low(TV721_MeasureMode)
      to High(TV721_MeasureMode)
        do fMeasureModeAll[ord(V721_MeasureMode)]:=V721_MeasureModeLabels[V721_MeasureMode];

  SetLength(fDiapazonAll,High(fMeasureModeAll)+1);

  {UD}
  DiapazonFilling(0,mV10,V100);
  {UA}
  DiapazonFilling(1,mV100,V100);
  {ID}
  DiapazonFilling(2,nA100,mA100);
  {IA}
  DiapazonFilling(3,micA100,mA100);
end;

//Procedure TVoltmetr.MModeDetermination(Data:byte);
//begin
//
//end;
//
//Procedure TVoltmetr.DiapazonDetermination(Data:byte);
//begin
//
//end;
//Procedure TVoltmetr.MModeDetermination(Data:array of byte);
//begin
//
//end;
//
//Procedure TVoltmetr.DiapazonDetermination(Data:array of byte);
//begin
//
//end;

procedure TVoltmetr.DiapazonFilling(DiapazonNumber:byte;
                              D_Begin, D_End: TV721_Diapazons);
 var V721_Diapazons:TV721_Diapazons;
begin
  SetLength(fDiapazonAll[DiapazonNumber],ord(D_End)-ord(D_Begin)+1);
  for V721_Diapazons := D_Begin to D_End
        do fDiapazonAll[DiapazonNumber][ord(V721_Diapazons)-ord(D_Begin)]:=V721_DiapazonsLabels[V721_Diapazons];
end;

function TVoltmetr.GetCurrent(Vin: double): double;
begin
// Result:=GetData([ID,IA]);
 Result:=GetData();
end;

//function TVoltmetr.GetData(LegalMeasureMode: TMeasureModeSet): double;
// function AditionMeasurement(a,b:double):double;
//  var c:double;
//  begin
//    if abs(a-b)<1e-5*Max(abs(a),abs(b))
//     then
//      Result:=(a+b)/2
//     else
//      begin
//        sleep(100);
//        c:=Measurement();
//        Result:=MedianFiltr(a,b,c);
//      end;
//  end;
// var a,b:double;
//
//begin
// a:=Measurement();
// sleep(100);
// b:=Measurement();
// Result:=AditionMeasurement(a,b);
// if Result=0 then
//   begin
//     sleep(300);
//     a:=Measurement();
//     sleep(100);
//     b:=Measurement();
//     Result:=AditionMeasurement(a,b);
//   end;
//end;

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
end;


//function TVoltmetr.GetResist: double;
//begin
//  Result:=GetResistance();
//end;

//function TVoltmetr.GetResistance: double;
//begin
// case fDiapazon of
//   nA100: Result:=100000;
//   micA1: Result:=100000;
//   micA10: Result:=10000;
//   micA100: Result:=1000;
//   mA1: Result:=100;
//   mA10: Result:=10;
//   mA1000:Result:=1;
//   else Result:=0;
// end;
//end;

function TVoltmetr.GetTemperature: double;
begin
// Result:=GetData([UD]);
 Result:=GetData();
 if Result<>ErResult then Result:=T_CuKo(Result);
end;

function TVoltmetr.GetVoltage(Vin: double): double;
begin
// Result:=GetData([UD,UA]);
 Result:=GetData();
end;

function TVoltmetr.MeasureModeLabelRead: string;
begin
 inherited MeasureModeLabelRead();
 if (fMeasureMode=ord(IA))or(fMeasureMode=ord(ID))
    then Result:=' A';
 if (fMeasureMode=ord(UA))or(fMeasureMode=ord(UD))
    then Result:=' V';
end;

//Procedure TVoltmetr.ValueDetermination(Data:array of byte);
// var temp:double;
//begin
// temp:=BCDtoDec(Data[0],True);
// temp:=BCDtoDec(Data[0],False)*10+temp;
// temp:=temp+BCDtoDec(Data[1],True)*100;
// temp:=temp+BCDtoDec(Data[1],False)*1000;
// temp:=temp+((Data[2] shr 4)and$1)*10000;
// if (Data[2] shr 5)and$1>0 then temp:=-temp;
// case fDiapazon of
//   nA100:   fValue:=temp*1e-11;
//   micA1:   fValue:=temp*1e-10;
//   micA10:  fValue:=temp*1e-9;
//   micA100: fValue:=temp*1e-8;
//   mA1:     fValue:=temp*1e-7;
//   mA10:    fValue:=temp*1e-6;
//   mA100:   fValue:=temp*1e-5;
//   mA1000:  fValue:=temp*1e-4;
//   mV10:    fValue:=temp*1e-6;
//   mV100:   fValue:=temp*1e-5;
//   V1:      fValue:=temp*1e-4;
//   V10:     fValue:=temp*1e-3;
//   V100:    fValue:=temp*1e-2;
//   V1000:   fValue:=temp*1e-1;
//   DErr:    fValue:=ErResult;
// end;
//end;

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

//Function TVoltmetr.Request():boolean;
//begin
//  PacketCreate([fMetterKod,PinControl,PinGate]);
//  Result:=PacketIsSend(fComPort,'Voltmetr '+Name+' measurement is unsuccessful');
//end;

Function TVoltmetr.Request():boolean;
begin
  PacketCreate([fMetterKod,Pins.PinControl,Pins.PinGate]);
  Result:=PacketIsSend(fComPort,'Voltmetr '+Name+' measurement is unsuccessful');
end;

function TVoltmetr.ResultProblem(Rez: double): boolean;
begin
 Result:=(abs(Rez)<1e-14);
end;


Procedure TVoltmetr.ConvertToValue(Data:array of byte);
begin
  if High(Data)<>3 then Exit;
  inherited ConvertToValue(Data);
//  MModeDetermination(Data[2]);
//  if fMeasureMode=MMErr then Exit;
//  DiapazonDetermination(Data[3]);
//  if fDiapazon=DErr then Exit;
//  ValueDetermination(Data);
//  if Value=ErResult then Exit;
//  fIsready:=True;
end;
//
//Procedure TV721A.MModeDetermination(Data:byte);
//begin
// Data:=Data and $0F;
//  case Data of
//   1: fMeasureMode:=UD;
//   2: fMeasureMode:=UA;
//   4: fMeasureMode:=ID;
//   8: fMeasureMode:=IA;
//   else fMeasureMode:=MMErr;
//  end;
//end;

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


//Procedure TV721.MModeDetermination(Data:byte);
//begin
// Data:=Data and $07;
//  case Data of
//   7: fMeasureMode:=UD;
//   5: fMeasureMode:=UA;
//   3: fMeasureMode:=ID;
//   else fMeasureMode:=MMErr;
//  end;
//end;

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

//Procedure TV721A.DiapazonDetermination(Data:byte);
//begin
//  fDiapazon:=DErr;
//  case Data of
//   128:if(fMeasureMode=IA)or(fMeasureMode=ID)
//                      then fDiapazon:=mA1000
//                      else fDiapazon:=V1000;
//   64: if(fMeasureMode=IA)or(fMeasureMode=ID)
//                      then fDiapazon:=mA100
//                      else fDiapazon:=V100;
//   32: if(fMeasureMode=IA)or(fMeasureMode=ID)
//                      then fDiapazon:=mA10
//                      else fDiapazon:=V10;
//   16: if(fMeasureMode=IA)or(fMeasureMode=ID)
//                      then fDiapazon:=mA1
//                      else fDiapazon:=V1;
//   8:  if(fMeasureMode=IA)or(fMeasureMode=ID)
//                      then fDiapazon:=micA100
//                      else fDiapazon:=mV100;
//   4:  if(fMeasureMode=ID)then fDiapazon:=micA10
//                          else
//           if(fMeasureMode=UD) then  fDiapazon:=mV10
//                               else Exit;
//   2:  if(fMeasureMode=ID) then fDiapazon:=micA1
//                           else Exit;
//   1:  if(fMeasureMode=ID) then fDiapazon:=nA100
//                           else Exit;
//  end;
//end;

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


constructor TV721.Create;
begin
  inherited Create();
  SetLength(fMeasureModeAll,High(fMeasureModeAll));
  fDiapazonAll[0][High(fDiapazonAll[0])]:='500 V';
  fDiapazonAll[1][High(fDiapazonAll[0])]:='500 V';
end;

//Procedure TV721.DiapazonDetermination(Data:byte);
//begin
//  fDiapazon:=DErr;
//  case Data of
//   127:if fMeasureMode=ID
//                      then fDiapazon:=mA1000
//                      else fDiapazon:=V1000;
//   191: if fMeasureMode=ID
//                      then fDiapazon:=mA100
//                      else fDiapazon:=V100;
//   223: if fMeasureMode=ID
//                      then fDiapazon:=mA10
//                      else fDiapazon:=V10;
//   239: if fMeasureMode=ID
//                      then fDiapazon:=mA1
//                      else fDiapazon:=V1;
//   247: if fMeasureMode=ID
//                      then fDiapazon:=micA100
//                      else fDiapazon:=mV100;
//   251: if(fMeasureMode=ID)then fDiapazon:=micA10
//                           else
//           if(fMeasureMode=UD) then  fDiapazon:=mV10
//                               else Exit;
//   253: if(fMeasureMode=ID) then fDiapazon:=micA1
//                           else Exit;
//   254: if(fMeasureMode=ID) then fDiapazon:=nA100
//                           else Exit;
//  end;
//end;

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

//Constructor TVoltmetrShow.Create(V:TVoltmetr;
//                      MM,R:TRadioGroup;
//                      DL,UL,CPL,GPL:TLabel;
//                      SCB,SGB,MB:TButton;
//                      AB:TSpeedButton;
//                      PCB:TComboBox;
//                      TT:TTimer);
// var i:integer;
//begin
//  inherited Create(V,CPL,GPL,SCB,SGB,PCB);
//   MeasureMode:=MM;
//   Range:=R;
//   DataLabel:=DL;
//   UnitLabel:=UL;
//   MeasurementButton:=MB;
//   AutoSpeedButton:=AB;
//   Time:=TT;
////    CreateFooter();
//    MeasureMode.Items.Clear;
//    for I := 0 to ord(MMErr) do
//      MeasureMode.Items.Add(MeasureModeLabels[TMeasureMode(i)]);
//    MeasureMode.ItemIndex := ord((ArduDevice as TVoltmetr).MeasureMode);
//    UnitLabel.Caption := '';
//    DiapazonFill((ArduDevice as TVoltmetr).MeasureMode, Range.Items);
//    Range.ItemIndex:=DiapazonSelect((ArduDevice as TVoltmetr).MeasureMode,(ArduDevice as TVoltmetr).Diapazon);
//    MeasurementButton.OnClick:=MeasurementButtonClick;
//    AutoSpeedButton.OnClick:=AutoSpeedButtonClick;
//    AdapterMeasureMode:=TAdapterRadioGroupClick.Create(ord((ArduDevice as TVoltmetr).MeasureMode));
//    AdapterRange:=TAdapterRadioGroupClick.Create(DiapazonSelect((ArduDevice as TVoltmetr).MeasureMode,(ArduDevice as TVoltmetr).Diapazon));
//    MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
//    Range.OnClick:=AdapterRange.RadioGroupClick;
//end;

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

//procedure TVoltmetrShow.Free;
//begin
// AdapterMeasureMode.Free;
// AdapterRange.Free;
//
// inherited Free;
//end;

procedure TVoltmetrShow.Free;
begin
 PinShow.Free;
 inherited Free;
end;

//procedure TVoltmetrShow.NumberPinShow();
//begin
// inherited NumberPinShow();
// ButtonEnabled()
//end;

procedure TVoltmetrShow.NumberPinShow();
begin
 PinShow.NumberPinShow();
 ButtonEnabled()
end;

//procedure TVoltmetrShow.ButtonEnabled();
//begin
//  MeasurementButton.Enabled:=(ArduDevice.PinControl<>UndefinedPin)and
//                             (ArduDevice.PinGate<>UndefinedPin);
//  AutoSpeedButton.Enabled:=MeasurementButton.Enabled;
//end;

procedure TVoltmetrShow.ButtonEnabled();
begin
  MeasurementButton.Enabled:=((RS232Meter as TVoltmetr).Pins.PinControl<>UndefinedPin)and
                             ((RS232Meter as TVoltmetr).Pins.PinGate<>UndefinedPin);
  AutoSpeedButton.Enabled:=MeasurementButton.Enabled;
end;

//procedure TVoltmetrShow.VoltmetrDataShow();
//begin
//  MeasureMode.OnClick:=nil;
//  Range.OnClick:=nil;
//  MeasureMode.ItemIndex:=ord((ArduDevice as TVoltmetr).MeasureMode);
//  DiapazonFill(TMeasureMode(MeasureMode.ItemIndex),
//                Range.Items);
//
//  Range.ItemIndex:=
//     DiapazonSelect((ArduDevice as TVoltmetr).MeasureMode,(ArduDevice as TVoltmetr).Diapazon);
//  MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
//  Range.OnClick:=AdapterRange.RadioGroupClick;
//  case (ArduDevice as TVoltmetr).MeasureMode of
//     IA,ID: UnitLabel.Caption:=' A';
//     UA,UD: UnitLabel.Caption:=' V';
//     MMErr: UnitLabel.Caption:='';
//  end;
//  if (ArduDevice as TVoltmetr).isReady then
//      DataLabel.Caption:=FloatToStrF((ArduDevice as TVoltmetr).Value,ffExponent,4,2)
//                       else
//      begin
//       DataLabel.Caption:='    ERROR';
//       UnitLabel.Caption:='';
//      end;
//end;

//procedure TVoltmetrShow.MeasurementButtonClick(Sender: TObject);
//begin
// if not((ArduDevice as TVoltmetr).fComPort.Connected) then Exit;
// (ArduDevice as TVoltmetr).Measurement();
// VoltmetrDataShow();
//end;

//procedure TVoltmetrShow.AutoSpeedButtonClick(Sender: TObject);
//begin
// MeasurementButton.Enabled:=not(AutoSpeedButton.Down);
// if AutoSpeedButton.Down then Time.OnTimer:=MeasurementButton.OnClick;
// Time.Enabled:=AutoSpeedButton.Down;
//end;



//Procedure DiapazonFill(Mode:TMeasureMode; Diapazons:TStrings);
//{заповнює Diapazons можливими назвами діапазонів
//з DiapazonsLabels залежно від Mode}
// var i,i0,i_end:TDiapazons;
//begin
// Diapazons.Clear;
// i0:=DErr;
// i_end:=DErr;
// case Mode of
//   IA: begin i0:=micA100; i_end:=mA1000; end;
//   ID: begin i0:=nA100; i_end:=mA1000; end;
//   UA: begin i0:=mV100; i_end:=V1000; end;
//   UD: begin i0:=mV10; i_end:=V1000; end;
// end;
// for I := i0 to i_end do
//  begin
//   Diapazons.Add(DiapazonsLabels[i])
//  end;
// if i0<>DErr then Diapazons.Add(DiapazonsLabels[DErr]);
//end;

//Function DiapazonSelect(Mode:TMeasureMode;Diapazon:TDiapazons):integer;
//{визначається порядковий номер, який
//відповідає Diapazon при даному Mode}
// var i0:TDiapazons;
//begin
// if Mode=MMErr then
//   begin
//     Result:=0;
//     Exit;
//   end;
// i0:=DErr;
// case Mode of
//   IA: i0:=micA100;
//   ID: i0:=nA100;
//   UA: i0:=mV100;
//   UD: i0:=mV10;
//  end;
// Result:=ord(Diapazon)-ord(i0);
//end;




{ TV721_Brak }

//procedure TV721_Brak.DiapazonDetermination(Data: byte);
//begin
//  fDiapazon:=DErr;
//  case Data of
//   127:if fMeasureMode=ID
//                      then fDiapazon:=mA1000
//                      else fDiapazon:=V1000;
//   239: if fMeasureMode=ID
//                      then fDiapazon:=mA100
//                      else fDiapazon:=V100;
//   223: if fMeasureMode=ID
//                      then fDiapazon:=mA10
//                      else fDiapazon:=V10;
//   191: if fMeasureMode=ID
//                      then fDiapazon:=mA1
//                      else fDiapazon:=V1;
//   247: if fMeasureMode=ID
//                      then fDiapazon:=micA100
//                      else fDiapazon:=mV100;
//   251: if(fMeasureMode=ID)then fDiapazon:=micA10
//                           else
//           if(fMeasureMode=UD) then  fDiapazon:=mV10
//                               else Exit;
//   253: if(fMeasureMode=ID) then fDiapazon:=micA1
//                           else Exit;
//   254: if(fMeasureMode=ID) then fDiapazon:=nA100
//                           else Exit;
//  end;
//
//
//end;

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
