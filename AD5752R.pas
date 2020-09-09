unit AD5752R;
//
interface

uses
  ShowTypes, ExtCtrls, Measurement, StdCtrls, IniFiles, ArduinoDeviceNew,
  OlegType, Classes, OlegTypePart2, ArduinoDeviceShow;

type
  T5752OutputRange=(p050,p100,p108,pm050,pm100,pm108{,NA});
  T5752ChanNumber=(chA,chB);

const
   AD5752_PowerOnByte=$11;
   AD5752_PowerOffByte=$00;

  AD5752_OutputRangeLabels:array[T5752OutputRange]of string=
  ('0..5','0..10','0..10.8',
  '-5..5','-10..10','-10.8..10.8'{,'Error'});

  AD5752_ChanelNames:array[T5752ChanNumber]of string=
  ('AD5752chA','AD5753chB');

  AD5752_OutputRangeKodLabels:array[0..1] of string=
  ('0..65535','32768..65535,0..32767');

//  AD5752_OutputRangeKod:array[T5752OutputRange] of byte=
//  (0,1,2,3,4,5,6);

  AD5752_OutputRangeMaxVoltage:array[T5752OutputRange]of double=
  (5,10,10.8,5,10,10.8{,ErResult});

  AD5752_OutputRangeMinVoltage:array[T5752OutputRange]of double=
  (0,0,0,-5,-10,-10.8{,ErResult});

  AD5752_GainOutputRange:array[T5752OutputRange]of double=
  (2,4,4.32,4,8,8.64{,1});



  AD5752_REFIN=2.5;
  AD5752_MaxKod=65535;

  {можливий відсоток напруги на виході від номінального діапазону}
//  AD5752_pVoltageLimit=0.99998; // 65535/65536
//  AD5752_pmVoltageLimit=0.99996; // 32767/32768


type

 TAD5752_Modul=class(TArduinoSetter)
  private
  protected
   procedure CreateHook;override;
   procedure PinsCreate();override;
  public
   procedure SetDataLength(Length:byte);
//   function HighNumberData:integer;
   procedure ClearData;
   procedure AddData(NewData:array of byte);
 end;


 TAD5752_ModulShow=class(TArduinoSetterShow)
  protected
   procedure CreatePinShow(PinLs: array of TPanel;
                             PinVariant:TStringList);override;
  public
   Constructor Create(AD5752_Modul:TAD5752_Modul;
                      CPL:TPanel;
                      PinVariant:TStringList);
 end;

  TAD5752_Chanel=class(TNamedInterfacedObject,IDAC)
    {базовий клас для ЦАП, що керується
    за допомогою Arduino    }
  private
   fModul:TAD5752_Modul;
   fOutputValue:double;
   fVoltageMaxValue:double;
   fKodMaxValue:integer;
   fChanNumber:T5752ChanNumber;
   fDiapazon:T5752OutputRange;
//   fSettedDiapazon:T5752OutputRange;
   fGain:double;
   fPowerOn:boolean;
//   fChanByte:byte;
//   fDacByte:byte;
//   fRangeByte:byte;
//   fPowerOnByte:byte;
//   fPowerOffByte:byte;
   function GetOutputValue:double;
   function GetDACKod:byte;
  protected
   function  VoltageToKod(Voltage:double):integer;
   procedure PrepareAction;
   procedure DataToSendFromKod(Kod:Integer);

   function NormedKod(Kod: Integer):integer;
   function NormedVoltage(Voltage:double):double;virtual;
   procedure SetDiapazon(D:T5752OutputRange);
  public
   property Modul:TAD5752_Modul read fModul;
   property OutputValue:double read GetOutputValue;
   property Diapazon:T5752OutputRange read fDiapazon write SetDiapazon;
   property Power:boolean read fPowerOn;
   property DACKod:byte read GetDACKod;
   Constructor Create(Modul:TAD5752_Modul;ChanNumber:T5752ChanNumber);
   Procedure Output(Voltage:double);
   Procedure Reset();
   Procedure OutputInt(Kod:integer);
   procedure PowerOff();
   procedure PowerOn();
   procedure DataToSendFromReset;
//   destructor Destroy; override;
  end;



 TAD5752_ChanelShow=class(TDAC_Show)
   private
    fChanel:TAD5752_Chanel;
    fDiapazonRG:TRadioGroup;
    fValueDiapazonLabel:TLabel;
    fKodDiapazonLabel:TLabel;
    fPowerOff:TButton;
    procedure DiapazonChange(Sender: TObject);
    procedure PowerOffOn(Sender: TObject);
   protected
   public
    Constructor Create(AD5752_Chanel:TAD5752_Chanel;
                         VData,KData:TStaticText;
                         VL,KL,VDL,KDL:TLabel;
                         VSB,KSB,RB,OffB:TButton;
                         DiapRG:TRadioGroup);
    procedure ReadFromIniFile(ConfigFile:TIniFile);override;
    Procedure WriteToIniFile(ConfigFile:TIniFile);override;
 end;



 var
    AD5752_Modul:TAD5752_Modul;
    AD5752_chA,AD5752_chB:TAD5752_Chanel;
    AD5752_ModulShow:TAD5752_ModulShow;
    AD5752_ChanShowA,AD5752_ChanShowB:TAD5752_ChanelShow;

implementation

uses
  PacketParameters, Math, Graphics, Windows, Dialogs,
  SysUtils, OlegFunction;


{ TAD5752_Modul }

procedure TAD5752_Modul.AddData(NewData: array of byte);
 var i,j:integer;
begin
 j:=High(fData)+1;
 SetLength(fData,j+High(NewData)+1);
 for I := 0 to High(NewData) do
  fData[i+j]:= NewData [i];
end;

procedure TAD5752_Modul.ClearData;
begin
 SetDataLength(2);
end;

procedure TAD5752_Modul.CreateHook;
begin
  inherited CreateHook;
  fSetterKod:=AD5752Command;
  SetLength(fData,2);
end;

//function TAD5752_Modul.HighNumberData: integer;
//begin
// Result:=High(fData);
//end;

procedure TAD5752_Modul.PinsCreate;
begin
  Pins := TPins.Create(Name,1);
end;

procedure TAD5752_Modul.SetDataLength(Length: byte);
begin
  SetLength(fData,Length);
end;

{ TAD5752_ChanelNew }

constructor TAD5752_Chanel.Create(Modul: TAD5752_Modul;
  ChanNumber: T5752ChanNumber);
begin
 inherited Create;
 fModul:=Modul;
 fChanNumber:=ChanNumber;
 fName:=AD5752_ChanelNames[ChanNumber];
// case fChanNumber of
//   chA:begin
//        fChanByte:=$00;
//        fDacByte:=$00;
//        fRangeByte:=$08;
//        fPowerOnByte:=$13;
//        fPowerOffByte:=$12;
//       end;
//   chB:begin
//        fChanByte:=$01;
//        fDacByte:=$02;
//        fRangeByte:=$A;
//        fPowerOnByte:=$1C;
//        fPowerOffByte:=$18;
//       end;
// end;

  fPowerOn:=False;
//  fSettedDiapazon:=NA;
  Diapazon:=p050;
  fKodMaxValue:=AD5752_MaxKod;
  fOutputValue:=0;
end;

procedure TAD5752_Chanel.DataToSendFromKod(Kod: Integer);
begin
  fModul.AddData([{fDacByte,}
                  ((Kod shr 8) and $FF),
                  (Kod and $FF)]);
end;

procedure TAD5752_Chanel.DataToSendFromReset;
begin
  fOutputValue:=0;
//  fModul.ClearData;
  PrepareAction;
  fModul.AddData([{fDacByte,}$00,$00]);
end;

//destructor TAD5752_Chanel.Destroy;
// var doSomething:boolean;
//begin
// doSomething:=False;
// fModul.ClearData;
// if fOutputValue<>0 then
//   begin
//    fModul.AddData([fDacByte,$00,$00]);
//    fOutputValue:=0;
//    doSomething:=True;
//   end;
// if fPowerOn then
//   begin
//    fModul.AddData([$10,fPowerOffByte]);
//    fPowerOn:=False;
//    doSomething:=True;
//   end;
// if doSomething then
//  begin
//   fModul.isNeededComPortState();
//   sleep(50);
//  end;
// inherited;
//end;

function TAD5752_Chanel.GetDACKod: byte;
begin
 Result:=fModul.DACKod;
end;

function TAD5752_Chanel.GetOutputValue: double;
begin
   Result:=fOutputValue;
end;

function TAD5752_Chanel.NormedKod(Kod: Integer): integer;
begin
 Result :=  EnsureRange(Kod,0,fKodMaxValue);
end;

function TAD5752_Chanel.NormedVoltage(Voltage: double): double;
begin
 case fDiapazon of
   p050,p100,p108: Result :=  EnsureRange(Voltage,0,fVoltageMaxValue);
   else Result :=  EnsureRange(Voltage,-fVoltageMaxValue,fVoltageMaxValue)
 end;
end;

procedure TAD5752_Chanel.Output(Voltage: double);
begin
  if Voltage=ErResult then Exit;
 fOutputValue:=NormedVoltage(Voltage);
 PrepareAction;
 DataToSendFromKod(VoltageToKod(fOutputValue));
 fModul.isNeededComPortState();
end;

procedure TAD5752_Chanel.OutputInt(Kod: integer);
 var NKod:integer;
begin
 Nkod:=NormedKod(Kod);
 fOutputValue:=Nkod;
 PrepareAction;
 DataToSendFromKod(abs(Nkod));
 fModul.isNeededComPortState();
end;

procedure TAD5752_Chanel.PowerOff;
begin
 fModul.ClearData;
// fModul.AddData([$10,fPowerOffByte]);
 fModul.AddData([ord(fChanNumber),$10,AD5752_PowerOffByte]);
 fPowerOn:=false;
 fModul.isNeededComPortState();
end;

procedure TAD5752_Chanel.PowerOn;
begin
 fModul.ClearData;
// fModul.AddData([$10,fPowerOnByte]);
 fModul.AddData([ord(fChanNumber),$10,AD5752_PowerOnByte]);
 fPowerOn:=True;
 fModul.isNeededComPortState();
end;

procedure TAD5752_Chanel.PrepareAction;
begin
 fModul.ClearData;
 fModul.AddData([ord(fChanNumber),byte(fDiapazon)]);
 fPowerOn:=True;

// if fSettedDiapazon<>fDiapazon then
//   begin
//    fModul.AddData([fRangeByte,
//                    AD5752_OutputRangeKod[fDiapazon]]);
//    fSettedDiapazon:=fDiapazon;
//   end;
// if not(fPowerOn) then
//   begin
//    fModul.AddData([$10,fPowerOnByte]);
//    fPowerOn:=True;
//   end;
end;

procedure TAD5752_Chanel.Reset;
begin
 DataToSendFromReset();
 fModul.isNeededComPortState();
end;

procedure TAD5752_Chanel.SetDiapazon(D: T5752OutputRange);
begin
 fDiapazon:=D;
 case fDiapazon of
   p050,p100,p108: fVoltageMaxValue:=AD5752_OutputRangeMaxVoltage[fDiapazon]*65535/65536;
   pm050,pm100,pm108: fVoltageMaxValue:=AD5752_OutputRangeMaxVoltage[fDiapazon]*32767/32768;
//   NA: fVoltageMaxValue:=0;
 end;
 fGain:=AD5752_GainOutputRange[fDiapazon];
end;

function TAD5752_Chanel.VoltageToKod(Voltage: double): integer;
begin
 Result:=round(Voltage/AD5752_REFIN/fGain*(fKodMaxValue+1));
 if Result<0 then Result:=(not(abs(Result)))and $FFFF;
end;

{ TAD5752_ModulShow }

constructor TAD5752_ModulShow.Create(AD5752_Modul: TAD5752_Modul; CPL: TPanel;
  PinVariant: TStringList);
begin
 inherited Create(AD5752_Modul,[CPL],PinVariant);
end;

procedure TAD5752_ModulShow.CreatePinShow(PinLs: array of TPanel;
                                          PinVariant: TStringList);
begin
 PinShow:=TOnePinsShow.Create(fArduinoSetter.Pins,PinLs[0],PinVariant);
end;

{ TAD5752_ChanelShowNew }

constructor TAD5752_ChanelShow.Create(
              AD5752_Chanel: TAD5752_Chanel;
              VData, KData: TStaticText;
              VL, KL, VDL, KDL: TLabel;
              VSB, KSB, RB, OffB: TButton;
              DiapRG: TRadioGroup);
 var i:T5752OutputRange;
begin
  inherited Create(AD5752_Chanel,VData, KData,VL, KL, VSB, KSB, RB);

 fChanel:=AD5752_Chanel;
 fDiapazonRG:=DiapRG;
 fDiapazonRG.Columns:=2;
 fDiapazonRG.Items.Clear;
 for I :=p050 to pm108 do
    fDiapazonRG.Items.Add(AD5752_OutputRangeLabels[i]);
 fDiapazonRG.OnClick:=DiapazonChange;

 fValueDiapazonLabel:=VDL;
 fValueDiapazonLabel.Font.Color:=clGreen;
 fKodDiapazonLabel:=KDL;
 fKodDiapazonLabel.Font.Color:=clGreen;

 fPowerOff:=OffB;
 fPowerOff.OnClick:=PowerOffOn;

end;

procedure TAD5752_ChanelShow.DiapazonChange(Sender: TObject);
begin
 fChanel.Diapazon:=T5752OutputRange(fDiapazonRG.ItemIndex);
 fValueDiapazonLabel.Caption:=AD5752_OutputRangeLabels[fChanel.Diapazon];
 case fChanel.Diapazon of
   p050,p100,p108:fKodDiapazonLabel.Caption:=AD5752_OutputRangeKodLabels[0];
   else fKodDiapazonLabel.Caption:=AD5752_OutputRangeKodLabels[1];
 end;

 if fChanel.Power
  then fPowerOff.Caption:='To power off'
  else fPowerOff.Caption:='To power on';
end;

procedure TAD5752_ChanelShow.PowerOffOn(Sender: TObject);
begin
  if fChanel.Power
  then
   begin
    fChanel.PowerOff;
    fPowerOff.Caption:='To power on';
   end
  else
   begin
    fChanel.PowerOn;
    fPowerOff.Caption:='To power off';
   end
end;

procedure TAD5752_ChanelShow.ReadFromIniFile(ConfigFile: TIniFile);
  var TempItemIndex:integer;
begin
 inherited ReadFromIniFile(ConfigFile);
 TempItemIndex := ConfigFile.ReadInteger(fChanel.Name, 'Diap', -1);
 if (TempItemIndex > -1) and (TempItemIndex < fDiapazonRG.Items.Count) then
  begin
   fDiapazonRG.ItemIndex:=TempItemIndex;
   DiapazonChange(nil);
  end;
end;

procedure TAD5752_ChanelShow.WriteToIniFile(ConfigFile: TIniFile);
begin
 inherited WriteToIniFile(ConfigFile);
 if fChanel.Name='' then Exit;
 ConfigFile.WriteInteger(fChanel.Name, 'Diap', fDiapazonRG.ItemIndex);
end;

initialization
   AD5752_Modul:=TAD5752_Modul.Create('AD5752');
   AD5752_chA:=TAD5752_Chanel.Create(AD5752_Modul,chA);
   AD5752_chB:=TAD5752_Chanel.Create(AD5752_Modul,chB);

finalization
  AD5752_chA.Free;
  AD5752_chB.Free;
  AD5752_Modul.Free;
end.
