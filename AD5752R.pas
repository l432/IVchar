unit AD5752R;
//
interface

uses
  ShowTypes, ExtCtrls, Measurement, StdCtrls, IniFiles, ArduinoDeviceNew,
  OlegType, Classes, OlegTypePart2, ArduinoDeviceShow;

type
  T5752OutputRange=(p050,p100,p108,pm050,pm100,pm108,NA);
  T5752ChanNumber=(chA,chB);

const
  AD5752_OutputRangeLabels:array[T5752OutputRange]of string=
  ('0..5','0..10','0..10.8',
  '-5..5','-10..10','-10.8..10.8','Error');

  AD5752_ChanelNames:array[T5752ChanNumber]of string=
  ('AD5752chA','AD5753chB');

  AD5752_OutputRangeKodLabels:array[0..1] of string=
  ('0..65535','32768..65535,0..32767');

  AD5752_OutputRangeKod:array[T5752OutputRange] of byte=
  (0,1,2,3,4,5,6);

  AD5752_OutputRangeMaxVoltage:array[T5752OutputRange]of double=
  (5,10,10.8,5,10,10.8,ErResult);

  AD5752_OutputRangeMinVoltage:array[T5752OutputRange]of double=
  (0,0,0,-5,-10,-10.8,ErResult);

  AD5752_GainOutputRange:array[T5752OutputRange]of double=
  (2,4,4.32,4,8,8.64,1);



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
   function HighNumberData:integer;
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

  TAD5752_ChanelNew=class(TNamedInterfacedObject,IDAC)
    {базовий клас для ЦАП, що керується
    за допомогою Arduino    }
  private
   fModul:TAD5752_Modul;
   fOutputValue:double;
   fVoltageMaxValue:double;
   fKodMaxValue:integer;
   fChanNumber:T5752ChanNumber;
   fDiapazon:T5752OutputRange;
   fSettedDiapazon:T5752OutputRange;
   fGain:double;
   fPowerOn:boolean;
   fDacByte:byte;
   fRangeByte:byte;
   fPowerOnByte:byte;
   fPowerOffByte:byte;
   function GetOutputValue:double;
  protected
   function  VoltageToKod(Voltage:double):integer;
   procedure PrepareAction(Voltage:double);
   procedure DataToSendFromKod(Kod:Integer);
   procedure DataToSendFromReset;
   function NormedKod(Kod: Integer):integer;
   function NormedVoltage(Voltage:double):double;virtual;
   procedure SetDiapazon(D:T5752OutputRange);
  public
   property OutputValue:double read GetOutputValue;
   property Diapazon:T5752OutputRange read fDiapazon write SetDiapazon;
   property Power:boolean read fPowerOn;
   Constructor Create(Modul:TAD5752_Modul;ChanNumber:T5752ChanNumber);
   Procedure Output(Voltage:double);
   Procedure Reset();
   Procedure OutputInt(Kod:integer);
   procedure PowerOff();
   procedure PowerOn();
   destructor Destroy; override;
  end;


 TAD5752_Chanel=class(TArduinoDACbase)
  private
   fChanNumber:T5752ChanNumber;
   fDiapazon:T5752OutputRange;
   fSettedDiapazon:T5752OutputRange;
   fGain:double;
   fPowerOn:boolean;
   fDacByte:byte;
   fRangeByte:byte;
   fPowerOnByte:byte;
   fPowerOffByte:byte;
   procedure SetDiapazon(D:T5752OutputRange);
  protected
   procedure CreateHook;override;
   procedure PinsCreate();override;
   function NormedVoltage(Voltage:double):double;override;
   function  VoltageToKod(Voltage:double):integer;override;
   procedure PrepareAction(Voltage:double);override;
   procedure DataToSendFromKod(Kod:Integer);override;
   procedure DataToSendFromReset;override;
  public
   property Diapazon:T5752OutputRange read fDiapazon write SetDiapazon;
   property Power:boolean read fPowerOn;
   Constructor Create(ChanNumber:T5752ChanNumber);
   procedure PowerOff();
   procedure PowerOn();
   destructor Destroy; override;
 end;

 TAD5752_ChanelShowNew=class(TDAC_Show)
   private
    fChanel:TAD5752_ChanelNew;
    fDiapazonRG:TRadioGroup;
    fValueDiapazonLabel:TLabel;
    fKodDiapazonLabel:TLabel;
    fPowerOff:TButton;
    procedure DiapazonChange(Sender: TObject);
    procedure PowerOffOn(Sender: TObject);
   protected
   public
    Constructor Create(AD5752_Chanel:TAD5752_ChanelNew;
                         VData,KData:TStaticText;
                         VL,KL,VDL,KDL:TLabel;
                         VSB,KSB,RB,OffB:TButton;
                         DiapRG:TRadioGroup);
    procedure ReadFromIniFile(ConfigFile:TIniFile);override;
    Procedure WriteToIniFile(ConfigFile:TIniFile);override;
 end;

 TAD5752_ChanelShow=class(TArduinoDACShow)
   private
    fDiapazonRG:TRadioGroup;
    fValueDiapazonLabel:TLabel;
    fKodDiapazonLabel:TLabel;
    fPowerOff:TButton;
    procedure DiapazonChange(Sender: TObject);
    procedure PowerOffOn(Sender: TObject);
   protected
    procedure CreatePinShow(PinLs: array of TPanel;
                             PinVariant:TStringList);override;
   public
     Constructor Create(AD5752_Chanel:TAD5752_Chanel;
                         CPL:TPanel;
                         VData,KData:TStaticText;
                         VL,KL,VDL,KDL:TLabel;
                         VSB,KSB,RB,OffB:TButton;
                         PinVariant:TStringList;
                         DiapRG:TRadioGroup);
    Procedure HookReadFromIniFile(ConfigFile:TIniFile);override;
    Procedure WriteToIniFile(ConfigFile:TIniFile);override;
 end;



 var
    AD5752_Modul:TAD5752_Modul;
    AD5752_chA,AD5752_chB:TAD5752_ChanelNew;
    AD5752_ModulShow:TAD5752_ModulShow;
    AD5752_ChanShowA,AD5752_ChanShowB:TAD5752_ChanelShowNew;

//    AD5752_chA,AD5752_chB:TAD5752_Chanel;
//    AD5752_ChanShowA,AD5752_ChanShowB:TAD5752_ChanelShow;
implementation

uses
  PacketParameters, Math, Graphics, Windows, Dialogs,
  SysUtils;

{ TAD5752_Chanel }

constructor TAD5752_Chanel.Create(ChanNumber: T5752ChanNumber);
begin
 inherited Create(AD5752_ChanelNames[ChanNumber]);
 fChanNumber:=ChanNumber;
 case fChanNumber of
   chA:begin
        fDacByte:=$00;
        fRangeByte:=$08;
        fPowerOnByte:=$13;
        fPowerOffByte:=$12;
       end;
   chB:begin
        fDacByte:=$02;
        fRangeByte:=$A;
        fPowerOnByte:=$1C;
        fPowerOffByte:=$18;
       end;
 end;
end;

procedure TAD5752_Chanel.CreateHook;
begin
  inherited CreateHook;
  fSetterKod:=AD5752Command;
  fPowerOn:=False;
  fSettedDiapazon:=NA;
  SetLength(fData,2);
  Diapazon:=p050;
  fKodMaxValue:=AD5752_MaxKod;
  fOutputValue:=0;
end;

procedure TAD5752_Chanel.DataToSendFromKod(Kod: Integer);
begin
  SetLength(fData, High(fData) + 4);
  fData[High(fData) - 2] := fDacByte;
  fData[High(fData)- 1] := ((Kod shr 8) and $FF);
  fData[High(fData)]:=(Kod and $FF)
end;

procedure TAD5752_Chanel.DataToSendFromReset;
begin
//  SHOWmessage(inttostr(fData[1]));
  SetLength(fData,5);
  fData[2] := fDacByte;
  fData[3] := $00;
  fData[4] := $00;
end;

destructor TAD5752_Chanel.Destroy;
 var doSomething:boolean;
begin
 doSomething:=False;
 SetLength(fData,2);
 if fOutputValue<>0 then
   begin
    SetLength(fData, High(fData) + 4);
    fData[High(fData) - 2] := fDacByte;
    fData[High(fData)- 1] := $00;
    fData[High(fData)]:=$00;
    fOutputValue:=0;
    doSomething:=True;
   end;
 if fPowerOn then
   begin
    SetLength(fData, High(fData) + 3);
    fData[High(fData)- 1] := $10;
    fData[High(fData)]:= fPowerOffByte;
    fPowerOn:=False;
    doSomething:=True;
   end;
 if doSomething then
  begin
   isNeededComPortState();
   sleep(50);
  end;
 inherited;
end;

function TAD5752_Chanel.NormedVoltage(Voltage: double): double;
begin
 case fDiapazon of
   p050,p100,p108: Result :=  EnsureRange(Voltage,0,fVoltageMaxValue);
   else Result :=  EnsureRange(Voltage,-fVoltageMaxValue,fVoltageMaxValue)
 end;
end;

procedure TAD5752_Chanel.PinsCreate;
begin
  Pins := TPins.Create(Name,1);
//  Pins := TPins.Create(Name,['Control'],1);
end;


procedure TAD5752_Chanel.PowerOff;
begin
 SetLength(fData,4);
 fData[2] := $10;
 fData[3]:= fPowerOffByte;
 fPowerOn:=false;
 isNeededComPortState();
end;

procedure TAD5752_Chanel.PowerOn;
begin
 SetLength(fData,4);
 fData[2] := $10;
 fData[3]:= fPowerOnByte;
 fPowerOn:=True;
 isNeededComPortState();
end;

procedure TAD5752_Chanel.PrepareAction(Voltage: double);
begin
 SetLength(fData,2);
 if fSettedDiapazon<>fDiapazon then
   begin
    SetLength(fData, High(fData) + 3);
    fData[High(fData)- 1] := fRangeByte;
    fData[High(fData)]:= AD5752_OutputRangeKod[fDiapazon];
    fSettedDiapazon:=fDiapazon;
   end;
 if not(fPowerOn) then
   begin
    SetLength(fData, High(fData) + 3);
    fData[High(fData)- 1] := $10;
    fData[High(fData)]:= fPowerOnByte;
    fPowerOn:=True;
   end;

end;

procedure TAD5752_Chanel.SetDiapazon(D: T5752OutputRange);
begin
 fDiapazon:=D;
 case fDiapazon of
   p050,p100,p108: fVoltageMaxValue:=AD5752_OutputRangeMaxVoltage[fDiapazon]*65535/65536;
   pm050,pm100,pm108: fVoltageMaxValue:=AD5752_OutputRangeMaxVoltage[fDiapazon]*32767/32768;
   NA: fVoltageMaxValue:=0;
 end;
 fGain:=AD5752_GainOutputRange[fDiapazon];
end;

function TAD5752_Chanel.VoltageToKod(Voltage: double): integer;
begin
 Result:=round(Voltage/AD5752_REFIN/fGain*(fKodMaxValue+1));
 if Result<0 then Result:=(not(abs(Result)))and $FFFF;
end;

{ TAD5752_ChanelShow }

constructor TAD5752_ChanelShow.Create(
                   AD5752_Chanel: TAD5752_Chanel;
                   CPL: TPanel;
                   VData, KData: TStaticText;
                   VL, KL, VDL, KDL: TLabel;
                   VSB, KSB, RB, OffB: TButton;
                   PinVariant: TStringList;
                   DiapRG: TRadioGroup);
 var i:T5752OutputRange;
begin
 inherited Create(AD5752_Chanel,[CPL],PinVariant,VData, KData, VL, KL, VSB, KSB, RB);

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
 fPowerOff.Caption:='To power on';
 fPowerOff.OnClick:=PowerOffOn;
end;

procedure TAD5752_ChanelShow.CreatePinShow(PinLs: array of TPanel;
  PinVariant: TStringList);
begin
  PinShow:=TOnePinsShow.Create(fArduinoSetter.Pins,PinLs[0],PinVariant);
end;

procedure TAD5752_ChanelShow.DiapazonChange(Sender: TObject);
begin
 (fArduinoSetter as TAD5752_Chanel).Diapazon:=T5752OutputRange(fDiapazonRG.ItemIndex);
 fValueDiapazonLabel.Caption:=AD5752_OutputRangeLabels[(fArduinoSetter as TAD5752_Chanel).Diapazon];
 case (fArduinoSetter as TAD5752_Chanel).Diapazon of
   p050,p100,p108:fKodDiapazonLabel.Caption:=AD5752_OutputRangeKodLabels[0];
   else fKodDiapazonLabel.Caption:=AD5752_OutputRangeKodLabels[1];
 end;
 if (fArduinoSetter as TAD5752_Chanel).Power
  then
    fPowerOff.Caption:='To power on'
  else
     fPowerOff.Caption:='To power off';
end;

procedure TAD5752_ChanelShow.HookReadFromIniFile(ConfigFile: TIniFile);
 var TempItemIndex:integer;
begin
 inherited HookReadFromIniFile(ConfigFile);
 if PinShow.Pins.Name='' then Exit;
 TempItemIndex := ConfigFile.ReadInteger(PinShow.Pins.Name, 'Diap', -1);
 if (TempItemIndex > -1) and (TempItemIndex < fDiapazonRG.Items.Count) then
  begin
   fDiapazonRG.ItemIndex:=TempItemIndex;
   DiapazonChange(nil);
  end;
end;

procedure TAD5752_ChanelShow.PowerOffOn(Sender: TObject);
begin
  if (fArduinoSetter as TAD5752_Chanel).Power
  then
   begin
    (fArduinoSetter as TAD5752_Chanel).PowerOff;
    fPowerOff.Caption:='To power on';
   end
  else
   begin
    (fArduinoSetter as TAD5752_Chanel).PowerOn;
     fPowerOff.Caption:='To power off';
   end

end;

procedure TAD5752_ChanelShow.WriteToIniFile(ConfigFile: TIniFile);
begin
 inherited WriteToIniFile(ConfigFile);
 if PinShow.Pins.Name='' then Exit;
 ConfigFile.WriteInteger(PinShow.Pins.Name, 'Diap', fDiapazonRG.ItemIndex);
end;

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

function TAD5752_Modul.HighNumberData: integer;
begin
 Result:=High(fData);
end;

procedure TAD5752_Modul.PinsCreate;
begin
  Pins := TPins.Create(Name,1);
end;

procedure TAD5752_Modul.SetDataLength(Length: byte);
begin
  SetLength(fData,Length);
end;

{ TAD5752_ChanelNew }

constructor TAD5752_ChanelNew.Create(Modul: TAD5752_Modul;
  ChanNumber: T5752ChanNumber);
begin
 inherited Create;
 fModul:=Modul;
 fChanNumber:=ChanNumber;
 fName:=AD5752_ChanelNames[ChanNumber];
 case fChanNumber of
   chA:begin
        fDacByte:=$00;
        fRangeByte:=$08;
        fPowerOnByte:=$13;
        fPowerOffByte:=$12;
       end;
   chB:begin
        fDacByte:=$02;
        fRangeByte:=$A;
        fPowerOnByte:=$1C;
        fPowerOffByte:=$18;
       end;
 end;

  fPowerOn:=False;
  fSettedDiapazon:=NA;
  Diapazon:=p050;
  fKodMaxValue:=AD5752_MaxKod;
  fOutputValue:=0;
end;

procedure TAD5752_ChanelNew.DataToSendFromKod(Kod: Integer);
begin
  fModul.AddData([fDacByte,
                  ((Kod shr 8) and $FF),
                  (Kod and $FF)]);
end;

procedure TAD5752_ChanelNew.DataToSendFromReset;
begin
  fModul.ClearData;
  fModul.AddData([fDacByte,$00,$00]);
end;

destructor TAD5752_ChanelNew.Destroy;
 var doSomething:boolean;
begin
 doSomething:=False;
 fModul.ClearData;
 if fOutputValue<>0 then
   begin
    fModul.AddData([fDacByte,$00,$00]);
    fOutputValue:=0;
    doSomething:=True;
   end;
 if fPowerOn then
   begin
    fModul.AddData([$10,fPowerOffByte]);
    fPowerOn:=False;
    doSomething:=True;
   end;
 if doSomething then
  begin
   fModul.isNeededComPortState();
   sleep(50);
  end;
 inherited;
end;

function TAD5752_ChanelNew.GetOutputValue: double;
begin
   Result:=fOutputValue;
end;

function TAD5752_ChanelNew.NormedKod(Kod: Integer): integer;
begin
 Result :=  EnsureRange(Kod,0,fKodMaxValue);
end;

function TAD5752_ChanelNew.NormedVoltage(Voltage: double): double;
begin
 case fDiapazon of
   p050,p100,p108: Result :=  EnsureRange(Voltage,0,fVoltageMaxValue);
   else Result :=  EnsureRange(Voltage,-fVoltageMaxValue,fVoltageMaxValue)
 end;
end;

procedure TAD5752_ChanelNew.Output(Voltage: double);
begin
  if Voltage=ErResult then Exit;
 fOutputValue:=NormedVoltage(Voltage);
 PrepareAction(fOutputValue);
 DataToSendFromKod(VoltageToKod(fOutputValue));
 fModul.isNeededComPortState();
end;

procedure TAD5752_ChanelNew.OutputInt(Kod: integer);
 var NKod:integer;
begin
 Nkod:=NormedKod(Kod);
 fOutputValue:=Nkod;
 PrepareAction(fOutputValue);
 DataToSendFromKod(abs(Nkod));
 fModul.isNeededComPortState();
end;

procedure TAD5752_ChanelNew.PowerOff;
begin
 fModul.ClearData;
 fModul.AddData([$10,fPowerOffByte]);
 fPowerOn:=false;
 fModul.isNeededComPortState();
end;

procedure TAD5752_ChanelNew.PowerOn;
begin
 fModul.ClearData;
 fModul.AddData([$10,fPowerOnByte]);
 fPowerOn:=false;
 fModul.isNeededComPortState();
end;

procedure TAD5752_ChanelNew.PrepareAction(Voltage: double);
begin
 fModul.ClearData;
 if fSettedDiapazon<>fDiapazon then
   begin
    fModul.AddData([fRangeByte,
                    AD5752_OutputRangeKod[fDiapazon]]);
    fSettedDiapazon:=fDiapazon;
   end;
 if not(fPowerOn) then
   begin
    fModul.AddData([$10,fPowerOnByte]);
    fPowerOn:=True;
   end;
end;

procedure TAD5752_ChanelNew.Reset;
begin
 DataToSendFromReset();
 fModul.isNeededComPortState();
end;

procedure TAD5752_ChanelNew.SetDiapazon(D: T5752OutputRange);
begin
 fDiapazon:=D;
 case fDiapazon of
   p050,p100,p108: fVoltageMaxValue:=AD5752_OutputRangeMaxVoltage[fDiapazon]*65535/65536;
   pm050,pm100,pm108: fVoltageMaxValue:=AD5752_OutputRangeMaxVoltage[fDiapazon]*32767/32768;
   NA: fVoltageMaxValue:=0;
 end;
 fGain:=AD5752_GainOutputRange[fDiapazon];
end;

function TAD5752_ChanelNew.VoltageToKod(Voltage: double): integer;
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

constructor TAD5752_ChanelShowNew.Create(
              AD5752_Chanel: TAD5752_ChanelNew;
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

procedure TAD5752_ChanelShowNew.DiapazonChange(Sender: TObject);
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

procedure TAD5752_ChanelShowNew.PowerOffOn(Sender: TObject);
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

procedure TAD5752_ChanelShowNew.ReadFromIniFile(ConfigFile: TIniFile);
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

procedure TAD5752_ChanelShowNew.WriteToIniFile(ConfigFile: TIniFile);
begin
 inherited WriteToIniFile(ConfigFile);
 if fChanel.Name='' then Exit;
 ConfigFile.WriteInteger(fChanel.Name, 'Diap', fDiapazonRG.ItemIndex);
end;

initialization
   AD5752_Modul:=TAD5752_Modul.Create('AD5752');
   AD5752_chA:=TAD5752_ChanelNew.Create(AD5752_Modul,chA);
   AD5752_chB:=TAD5752_ChanelNew.Create(AD5752_Modul,chB);

//   AD5752_chA:=TAD5752_Chanel.Create(chA);
//   AD5752_chB:=TAD5752_Chanel.Create(chB);
finalization
  AD5752_chA.Free;
  AD5752_chB.Free;
  AD5752_Modul.Free;
end.
