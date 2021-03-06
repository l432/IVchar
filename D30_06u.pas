unit D30_06u;

interface

uses
   StdCtrls, Measurement, ExtCtrls, IniFiles, Classes, ShowTypes, 
   ArduinoDeviceNew;

const D30_06_MaxVoltage=28.75;
      D30_06_MaxCurrent=5.56;
      D30_06_MaxKod=16383;

      D30_06Command=$6;

      PinNamesD30_06:array[0..2]of string=
           ('Voltage','Current', 'Gate');

type

TD30_06=class(TArduinoDAC)
 private
  fCurrentMaxValue:double;
  FisVoltage: boolean;
 protected
  procedure PinsCreate();override;
  procedure CreateHook;override;
//  procedure DataByteToSendFromInteger(IntData: Integer);override;
  procedure DataToSendFromKod(Kod:Integer);override;
  function  VoltageToKod(Voltage:double):integer;override;
  function NormedVoltage(Voltage:double):double;override;
 public
  procedure PinsToDataArray;override;
  property isVoltage:boolean read FisVoltage write FisVoltage;
  constructor Create();
//  procedure Free;//override;
  destructor Destroy; override;
end;


TD30_06Show=class(TArduinoDACShow)
private
 VoltageOrCurrentRG:TRadioGroup;
 ValueDiapazonLabel:TLabel;
 procedure VoltageOrCurrentRGClick(Sender: TObject);
 procedure LabelFilling;
 protected
  procedure CreatePinShow(PinLs: array of TPanel;
                             PinVariant:TStringList);override;
 public
 Constructor Create(DAC: TD30_06;
                     VolPL, CouPL, GatePL:TPanel;
//                     CPL, GPL:TPanel;
                     VL, KL, VDL: TLabel;
                     VData,KData:TStaticText;
                     VSB, KSB, RB: TButton;
                     PinVariants:TStringList;
                     VOCRG: TRadioGroup);
 Procedure HookReadFromIniFile(ConfigFile:TIniFile);override;
 Procedure WriteToIniFile(ConfigFile:TIniFile);override;
end;

var
    D30_06:TD30_06;
    D30_06Show:TD30_06Show;

implementation

uses
  SysUtils, Dialogs, ArduinoDeviceShow, Math;

{ TD30_06 }

constructor TD30_06.Create;
begin
 inherited Create('D30_06');
end;

procedure TD30_06.CreateHook;
begin
  inherited CreateHook;
  fVoltageMaxValue:=D30_06_MaxVoltage;
  fKodMaxValue:=D30_06_MaxKod;
  fCurrentMaxValue:=D30_06_MaxCurrent;
  fSetterKod:=D30_06Command;
  FisVoltage:=True;
end;


//procedure TD30_06.DataByteToSendFromInteger(IntData: Integer);
//begin
//  IntData:=NormedKod(IntData);
//  fData[3] := ((IntData shr 8) and $3F);
//  fData[4] := (IntData and $FF);
//end;

procedure TD30_06.DataToSendFromKod(Kod: Integer);
begin
  fData[3] := ((Kod shr 8) and $3F);
  fData[4] := (Kod and $FF);
end;

destructor TD30_06.Destroy;
begin
 Reset;
 sleep(50);
 inherited;
end;

function TD30_06.NormedVoltage(Voltage: double): double;
begin
 if FisVoltage
  then Result:= EnsureRange(Voltage,-fVoltageMaxValue,fVoltageMaxValue)
  else Result:= EnsureRange(Voltage,-fCurrentMaxValue,fCurrentMaxValue);
end;

//procedure TD30_06.Free;
//begin
// Reset;
// sleep(50);
// inherited Free;
//end;

procedure TD30_06.PinsCreate;
begin
  Pins := TPins.Create(Name,PinNamesD30_06,3);
end;

procedure TD30_06.PinsToDataArray;
begin
 if FisVoltage then
   begin
    fData[1] := Pins.PinControl;
    fData[2] := Pins.fPins[2];
   end         else
   begin
    fData[1] := Pins.PinGate;
    fData[2] := Pins.fPins[2];
   end;


// if FisVoltage then
//   begin
//    fData[1] := Pins.PinControl;
//    fData[2] := Pins.PinGate;
//   end         else
//   begin
//    fData[2] := Pins.PinControl;
//    fData[1] := Pins.PinGate;
//   end;
end;

function TD30_06.VoltageToKod(Voltage: double): integer;
begin
 if FisVoltage
   then Result:=round(abs(Voltage)/fVoltageMaxValue*fKodMaxValue)
   else Result:=round(abs(Voltage)/fCurrentMaxValue*fKodMaxValue);


// if (not(FisVoltage))and(Voltage<-3) then Voltage:=-3;

// fOutPutValue:=Voltage;
// Voltage:=abs(Voltage);
// if FisVoltage then
//     if Voltage>fVoltageMaxValue
//        then Result:=fKodMaxValue
//        else Result:=round(Voltage/fVoltageMaxValue*fKodMaxValue)
//               else
//     if Voltage>fCurrentMaxValue
//        then Result:=fKodMaxValue
//        else Result:=round(Voltage/fCurrentMaxValue*fKodMaxValue)
end;

{ TD30_06Show }

constructor TD30_06Show.Create(DAC: TD30_06;
                              VolPL, CouPL, GatePL:TPanel;
//                     CPL, GPL:TPanel;
                               VL, KL, VDL: TLabel;
                               VData,KData:TStaticText;
                               VSB, KSB, RB: TButton;
                               PinVariants:TStringList;
                               VOCRG: TRadioGroup);

begin
 inherited Create(DAC,{[CPL, GPL]}[VolPL, CouPL, GatePL], PinVariants, VData, KData, VL, KL, VSB, KSB, RB);
 ValueDiapazonLabel:=VDL;
 VoltageOrCurrentRG:=VOCRG;
 VoltageOrCurrentRG.OnClick:=VoltageOrCurrentRGClick;
end;

procedure TD30_06Show.CreatePinShow(PinLs: array of TPanel;
  PinVariant: TStringList);
begin
  PinShow:=TPinsShowUniversal.Create (fArduinoSetter.Pins,PinLs,
         [PinVariant]);

//  PinShow:=TPinsShow.Create(fArduinoSetter.Pins,PinLs[0],PinLs[1],
//  PinVariant);
end;

procedure TD30_06Show.HookReadFromIniFile(ConfigFile: TIniFile);
 var TempItemIndex:integer;
begin
 inherited HookReadFromIniFile(ConfigFile);
 if PinShow.Pins.Name='' then Exit;
 TempItemIndex := ConfigFile.ReadInteger(PinShow.Pins.Name, 'VorC', -1);
 if (TempItemIndex > -1) and (TempItemIndex < VoltageOrCurrentRG.Items.Count) then
  begin
   VoltageOrCurrentRG.ItemIndex:=TempItemIndex;
   VoltageOrCurrentRGClick(fArduinoSetter);
  end;
end;

procedure TD30_06Show.LabelFilling;
begin
  if (fArduinoSetter as TD30_06).isVoltage then
    ValueDiapazonLabel.Caption := 'Value: -'
                                 + FloatToStrF(D30_06_MaxVoltage, ffFixed, 4, 2)
                                 + ' ... '
                                 + FloatToStrF(D30_06_MaxVoltage, ffFixed, 4, 2)
                       else
    ValueDiapazonLabel.Caption := 'Value: -'
                                 + FloatToStrF(D30_06_MaxCurrent, ffFixed, 3, 2)
                                 + ' ... '
                                 + FloatToStrF(D30_06_MaxCurrent, ffFixed, 3, 2);
end;

//procedure TD30_06Show.ReadFromIniFile(ConfigFile: TIniFile);
// var TempItemIndex:integer;
//begin
// inherited ReadFromIniFile(ConfigFile);
// if PinShow.Pins.Name='' then Exit;
// TempItemIndex := ConfigFile.ReadInteger(PinShow.Pins.Name, 'VorC', -1);
// if (TempItemIndex > -1) and (TempItemIndex < VoltageOrCurrentRG.Items.Count) then
//  begin
//   VoltageOrCurrentRG.ItemIndex:=TempItemIndex;
//   VoltageOrCurrentRGClick(fArduinoSetter);
//  end;
//end;


procedure TD30_06Show.VoltageOrCurrentRGClick(Sender: TObject);
begin
 if VoltageOrCurrentRG.ItemIndex<0 then Exit;
 (fArduinoSetter as TD30_06).isVoltage:=(VoltageOrCurrentRG.Items[VoltageOrCurrentRG.ItemIndex]=PinNamesD30_06[0]);
 fArduinoSetter.PinsToDataArray;
 LabelFilling;

end;

procedure TD30_06Show.WriteToIniFile(ConfigFile: TIniFile);
begin
 inherited WriteToIniFile(ConfigFile);
 if PinShow.Pins.Name='' then Exit;
 ConfigFile.WriteInteger(PinShow.Pins.Name, 'VorC', VoltageOrCurrentRG.ItemIndex);
end;


initialization
   D30_06:=TD30_06.Create;
finalization
   D30_06.Free;
end.
