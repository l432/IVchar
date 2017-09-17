unit V7_21;

interface

uses
  SPIdevice, ExtCtrls, StdCtrls, Buttons, Classes;



type
  TMeasureMode=(IA,ID,UA,UD,MMErr);
  TMeasureModeSet=set of TMeasureMode;
  TDiapazons=(nA100,micA1,micA10,micA100,mA1,mA10,mA100,mA1000,
              mV10,mV100,V1,V10,V100,V1000,DErr);

const

  MeasureModeLabels:array[TMeasureMode]of string=
   ('~ I', '= I','~ U', '= U','Error');

  DiapazonsLabels:array[TDiapazons]of string=
   ('100 nA','1 micA','10 micA','100 micA',
    '1 mA','10 mA','100 mA','1000 mA',
     '10 mV','100 mV','1 V','10 V','100 V','1000 V','Error');

type
  TVoltmetr=class(TArduinoMeter)
  {базовий клас для вольтметрів серії В7-21}
  protected
//   fMeasureMode:TMeasureMode;
//   fDiapazon:TDiapazons;
//   Procedure MModeDetermination(Data:byte); virtual;
//   Procedure DiapazonDetermination(Data:byte); virtual;
//   Procedure ValueDetermination(Data:array of byte);virtual;
   function GetData(LegalMeasureMode:TMeasureModeSet):double;
   function GetResistance():double;
   Function ResultProblem(Rez:double):boolean;override;
  public
//   property MeasureMode:TMeasureMode read FMeasureMode;
//   property Diapazon:TDiapazons read fDiapazon;
   property Resistance:double read GetResistance;
   Procedure ConvertToValue(Data:array of byte);override;
   Constructor Create();overload;override;
   Function Request():boolean;override;
   function GetTemperature:double;override;
   function GetVoltage(Vin:double):double;override;
   function GetCurrent(Vin:double):double;override;
   function GetResist():double;override;
  end;

  TV721A=class(TVoltmetr)
  protected
   Procedure MModeDetermination(Data:byte);override;
   Procedure DiapazonDetermination(Data:byte);override;
  public
  end;

  TV721=class(TVoltmetr)
  protected
   Procedure MModeDetermination(Data:byte);override;
   Procedure DiapazonDetermination(Data:byte);override;
   Procedure ValueDetermination(Data:array of byte);override;
  public
  end;

  TV721_Brak=class(TV721)
  {коричнева банка, при пайці переплутано 2 контакти}
  protected
   Procedure DiapazonDetermination(Data:byte);override;
  public
  end;


  TVoltmetrShow=class(TSPIDeviceShow)
  private
   MeasureMode,Range:TRadioGroup;
   DataLabel,UnitLabel:TLabel;
   MeasurementButton:TButton;
   Time:TTimer;
   AdapterMeasureMode,AdapterRange:TAdapterRadioGroupClick;
   procedure MeasurementButtonClick(Sender: TObject);
   procedure AutoSpeedButtonClick(Sender: TObject);
  public
   AutoSpeedButton:TSpeedButton;
   Constructor Create(V:TVoltmetr;
                      MM,R:TRadioGroup;
                      DL,UL,CPL,GPL:TLabel;
                      SCB,SGB,MB:TButton;
                      AB:TSpeedButton;
                      PCB:TComboBox;
                      TT:TTimer);
   Procedure Free;
   procedure NumberPinShow();override;
   procedure ButtonEnabled();
   procedure VoltmetrDataShow();
  end;


Function BCDtoDec(BCD:byte; isLow:boolean):byte;
{виділяє з ВCD, яке містить дві десяткові
цифри у двійково-десятковому представленні,
ці цифри;
якщо  isLow=true, то виділення із
молодшої частини байта}

Procedure DiapazonFill(Mode:TMeasureMode; Diapazons:TStrings);
{заповнює Diapazons можливими назвами діапазонів
з DiapazonsLabels залежно від Mode}

Function DiapazonSelect(Mode:TMeasureMode;Diapazon:TDiapazons):integer;
{визначається порядковий номер, який
відповідає Diapazon при даному Mode}

implementation

uses   PacketParameters, Measurement, Math, SysUtils, OlegMath, OlegType;


Constructor TVoltmetr.Create();
begin
  inherited Create();
  fMetterKod:=V7_21Command;
  fMeasureMode:=MMErr;
  fDiapazon:=DErr;
end;


Procedure TVoltmetr.MModeDetermination(Data:byte);
begin

end;

Procedure TVoltmetr.DiapazonDetermination(Data:byte);
begin

end;

function TVoltmetr.GetCurrent(Vin: double): double;
begin
 Result:=GetData([ID,IA]);
// Result:=ErResult;
// temp:=Measurement();
// if temp<>ErResult then
//  begin
//    if (fMeasureMode<>ID)or(fMeasureMode<>IA) then
//         MessageDlg('Measure mode is wrong!!!',mtError, [mbOK], 0)
//                                              else
//         Result:=temp;
//  end;
end;

function TVoltmetr.GetData(LegalMeasureMode: TMeasureModeSet): double;
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


// if Result=ErResult then Exit;
// if not(fMeasureMode in LegalMeasureMode) then
//   begin
//    MessageDlg('Measure mode is wrong!!!',mtError, [mbOK], 0);
//    Result:=ErResult;
//   end
end;

function TVoltmetr.GetResist: double;
begin
  Result:=GetResistance();
end;

function TVoltmetr.GetResistance: double;
begin
 case fDiapazon of
   nA100: Result:=100000;
   micA1: Result:=100000;
   micA10: Result:=10000;
   micA100: Result:=1000;
   mA1: Result:=100;
   mA10: Result:=10;
   mA1000:Result:=1;
   else Result:=0;
 end;
end;

function TVoltmetr.GetTemperature: double;
// var temp:double;
begin
 Result:=GetData([UD]);
 if Result<>ErResult then Result:=T_CuKo(Result);

// Result:=ErResult;
// temp:=Measurement();
// if temp<>ErResult then
//  begin
//    if (fMeasureMode<>UD) then
//         MessageDlg('Measure mode is wrong!!!',mtError, [mbOK], 0)
//                                              else
//         Result:=T_CuKo(temp);
//  end;
end;

function TVoltmetr.GetVoltage(Vin: double): double;
// var temp:double;
begin
 Result:=GetData([UD,UA]);
// Result:=ErResult;
// temp:=Measurement();
// if temp<>ErResult then
//  begin
//    if (fMeasureMode<>UD)or(fMeasureMode<>UA) then
//         MessageDlg('Measure mode is wrong!!!',mtError, [mbOK], 0)
//                                              else
//         Result:=temp;
//  end;
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
 case fDiapazon of
   nA100:   fValue:=temp*1e-11;
   micA1:   fValue:=temp*1e-10;
   micA10:  fValue:=temp*1e-9;
   micA100: fValue:=temp*1e-8;
   mA1:     fValue:=temp*1e-7;
   mA10:    fValue:=temp*1e-6;
   mA100:   fValue:=temp*1e-5;
   mA1000:  fValue:=temp*1e-4;
   mV10:    fValue:=temp*1e-6;
   mV100:   fValue:=temp*1e-5;
   V1:      fValue:=temp*1e-4;
   V10:     fValue:=temp*1e-3;
   V100:    fValue:=temp*1e-2;
   V1000:   fValue:=temp*1e-1;
   DErr:    fValue:=ErResult;
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

Procedure TV721A.MModeDetermination(Data:byte);
begin
 Data:=Data and $0F;
  case Data of
   1: fMeasureMode:=UD;
   2: fMeasureMode:=UA;
   4: fMeasureMode:=ID;
   8: fMeasureMode:=IA;
   else fMeasureMode:=MMErr;
  end;
end;

Procedure TV721.MModeDetermination(Data:byte);
begin
 Data:=Data and $07;
  case Data of
   7: fMeasureMode:=UD;
   5: fMeasureMode:=UA;
   3: fMeasureMode:=ID;
   else fMeasureMode:=MMErr;
  end;
end;

Procedure TV721A.DiapazonDetermination(Data:byte);
begin
  fDiapazon:=DErr;
  case Data of
   128:if(fMeasureMode=IA)or(fMeasureMode=ID)
                      then fDiapazon:=mA1000
                      else fDiapazon:=V1000;
   64: if(fMeasureMode=IA)or(fMeasureMode=ID)
                      then fDiapazon:=mA100
                      else fDiapazon:=V100;
   32: if(fMeasureMode=IA)or(fMeasureMode=ID)
                      then fDiapazon:=mA10
                      else fDiapazon:=V10;
   16: if(fMeasureMode=IA)or(fMeasureMode=ID)
                      then fDiapazon:=mA1
                      else fDiapazon:=V1;
   8:  if(fMeasureMode=IA)or(fMeasureMode=ID)
                      then fDiapazon:=micA100
                      else fDiapazon:=mV100;
   4:  if(fMeasureMode=ID)then fDiapazon:=micA10
                          else
           if(fMeasureMode=UD) then  fDiapazon:=mV10
                               else Exit;
   2:  if(fMeasureMode=ID) then fDiapazon:=micA1
                           else Exit;
   1:  if(fMeasureMode=ID) then fDiapazon:=nA100
                           else Exit;
  end;
end;

Procedure TV721.DiapazonDetermination(Data:byte);
begin
  fDiapazon:=DErr;
  case Data of
   127:if fMeasureMode=ID
                      then fDiapazon:=mA1000
                      else fDiapazon:=V1000;
   191: if fMeasureMode=ID
                      then fDiapazon:=mA100
                      else fDiapazon:=V100;
   223: if fMeasureMode=ID
                      then fDiapazon:=mA10
                      else fDiapazon:=V10;
   239: if fMeasureMode=ID
                      then fDiapazon:=mA1
                      else fDiapazon:=V1;
   247: if fMeasureMode=ID
                      then fDiapazon:=micA100
                      else fDiapazon:=mV100;
   251: if(fMeasureMode=ID)then fDiapazon:=micA10
                           else
           if(fMeasureMode=UD) then  fDiapazon:=mV10
                               else Exit;
   253: if(fMeasureMode=ID) then fDiapazon:=micA1
                           else Exit;
   254: if(fMeasureMode=ID) then fDiapazon:=nA100
                           else Exit;
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
 var i:integer;
begin
  inherited Create(V,CPL,GPL,SCB,SGB,PCB);
   MeasureMode:=MM;
   Range:=R;
   DataLabel:=DL;
   UnitLabel:=UL;
   MeasurementButton:=MB;
   AutoSpeedButton:=AB;
   Time:=TT;
//    CreateFooter();
    MeasureMode.Items.Clear;
    for I := 0 to ord(MMErr) do
      MeasureMode.Items.Add(MeasureModeLabels[TMeasureMode(i)]);
    MeasureMode.ItemIndex := ord((ArduDevice as TVoltmetr).MeasureMode);
    UnitLabel.Caption := '';
    DiapazonFill((ArduDevice as TVoltmetr).MeasureMode, Range.Items);
    Range.ItemIndex:=DiapazonSelect((ArduDevice as TVoltmetr).MeasureMode,(ArduDevice as TVoltmetr).Diapazon);
    MeasurementButton.OnClick:=MeasurementButtonClick;
    AutoSpeedButton.OnClick:=AutoSpeedButtonClick;
    AdapterMeasureMode:=TAdapterRadioGroupClick.Create(ord((ArduDevice as TVoltmetr).MeasureMode));
    AdapterRange:=TAdapterRadioGroupClick.Create(DiapazonSelect((ArduDevice as TVoltmetr).MeasureMode,(ArduDevice as TVoltmetr).Diapazon));
    MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
    Range.OnClick:=AdapterRange.RadioGroupClick;
end;

procedure TVoltmetrShow.Free;
begin
 AdapterMeasureMode.Free;
 AdapterRange.Free;

 inherited Free;
end;

procedure TVoltmetrShow.NumberPinShow();
begin
 inherited NumberPinShow();
 ButtonEnabled()
end;

procedure TVoltmetrShow.ButtonEnabled();
begin
  MeasurementButton.Enabled:=(ArduDevice.PinControl<>UndefinedPin)and
                             (ArduDevice.PinGate<>UndefinedPin);
  AutoSpeedButton.Enabled:=MeasurementButton.Enabled;
end;

procedure TVoltmetrShow.VoltmetrDataShow();
begin
  MeasureMode.OnClick:=nil;
  Range.OnClick:=nil;
  MeasureMode.ItemIndex:=ord((ArduDevice as TVoltmetr).MeasureMode);
  DiapazonFill(TMeasureMode(MeasureMode.ItemIndex),
                Range.Items);

  Range.ItemIndex:=
     DiapazonSelect((ArduDevice as TVoltmetr).MeasureMode,(ArduDevice as TVoltmetr).Diapazon);
  MeasureMode.OnClick:=AdapterMeasureMode.RadioGroupClick;
  Range.OnClick:=AdapterRange.RadioGroupClick;
  case (ArduDevice as TVoltmetr).MeasureMode of
     IA,ID: UnitLabel.Caption:=' A';
     UA,UD: UnitLabel.Caption:=' V';
     MMErr: UnitLabel.Caption:='';
  end;
  if (ArduDevice as TVoltmetr).isReady then
      DataLabel.Caption:=FloatToStrF((ArduDevice as TVoltmetr).Value,ffExponent,4,2)
                       else
      begin
       DataLabel.Caption:='    ERROR';
       UnitLabel.Caption:='';
      end;
end;

procedure TVoltmetrShow.MeasurementButtonClick(Sender: TObject);
begin
 if not((ArduDevice as TVoltmetr).fComPort.Connected) then Exit;
 (ArduDevice as TVoltmetr).Measurement();
 VoltmetrDataShow();
end;

procedure TVoltmetrShow.AutoSpeedButtonClick(Sender: TObject);
begin
 MeasurementButton.Enabled:=not(AutoSpeedButton.Down);
 if AutoSpeedButton.Down then Time.OnTimer:=MeasurementButton.OnClick;
 Time.Enabled:=AutoSpeedButton.Down;
end;


Function BCDtoDec(BCD:byte; isLow:boolean):byte;
{виділяє з ВCD, яке містить дві десяткові
цифри у двійково-десятковому представленні,
ці цифри;
якщо  isLow=true, то виділення із
молодшої частини байта}
begin
 if isLow then BCD:=BCD Shl 4;
 Result:= BCD Shr 4;
end;

Procedure DiapazonFill(Mode:TMeasureMode; Diapazons:TStrings);
{заповнює Diapazons можливими назвами діапазонів
з DiapazonsLabels залежно від Mode}
 var i,i0,i_end:TDiapazons;
begin
 Diapazons.Clear;
 i0:=DErr;
 i_end:=DErr;
 case Mode of
   IA: begin i0:=micA100; i_end:=mA1000; end;
   ID: begin i0:=nA100; i_end:=mA1000; end;
   UA: begin i0:=mV100; i_end:=V1000; end;
   UD: begin i0:=mV10; i_end:=V1000; end;
 end;
 for I := i0 to i_end do
  begin
   Diapazons.Add(DiapazonsLabels[i])
  end;
 if i0<>DErr then Diapazons.Add(DiapazonsLabels[DErr]);
end;

Function DiapazonSelect(Mode:TMeasureMode;Diapazon:TDiapazons):integer;
{визначається порядковий номер, який
відповідає Diapazon при даному Mode}
 var i0:TDiapazons;
begin
 if Mode=MMErr then
   begin
     Result:=0;
     Exit;
   end;
 i0:=DErr;
 case Mode of
   IA: i0:=micA100;
   ID: i0:=nA100;
   UA: i0:=mV100;
   UD: i0:=mV10;
  end;
 Result:=ord(Diapazon)-ord(i0);
end;




{ TV721_Brak }

procedure TV721_Brak.DiapazonDetermination(Data: byte);
begin
  fDiapazon:=DErr;
  case Data of
   127:if fMeasureMode=ID
                      then fDiapazon:=mA1000
                      else fDiapazon:=V1000;
   239: if fMeasureMode=ID
                      then fDiapazon:=mA100
                      else fDiapazon:=V100;
   223: if fMeasureMode=ID
                      then fDiapazon:=mA10
                      else fDiapazon:=V10;
   191: if fMeasureMode=ID
                      then fDiapazon:=mA1
                      else fDiapazon:=V1;
   247: if fMeasureMode=ID
                      then fDiapazon:=micA100
                      else fDiapazon:=mV100;
   251: if(fMeasureMode=ID)then fDiapazon:=micA10
                           else
           if(fMeasureMode=UD) then  fDiapazon:=mV10
                               else Exit;
   253: if(fMeasureMode=ID) then fDiapazon:=micA1
                           else Exit;
   254: if(fMeasureMode=ID) then fDiapazon:=nA100
                           else Exit;
  end;


end;


end.
