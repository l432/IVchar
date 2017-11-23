unit D30_06;

interface

uses
  SPIdevice, StdCtrls, Measurement, ExtCtrls, IniFiles;

const D30_06_MaxVoltage=28.75;
      D30_06_MaxCurrent=5.56;
      D30_06_MaxKod=16383;

      D30_06Command=$6;

      PinNamesD30_06:array[0..1]of string=
           ('Voltage','Current');

type

TD30_06=class(TArduinoDAC)
 private
  fCurrentMaxValue:double;
  FisVoltage: boolean;

 protected
  procedure CreateHook;override;
  procedure DataByteToSendFromInteger(IntData: Integer);override;
  function  VoltageToKod(Voltage:double):integer;override;
  procedure PinsToDataArray;override;
 public
  property isVoltage:boolean read FisVoltage write FisVoltage;
end;


TPins30_06Show=class(TPinsShow)
public
 Constructor Create(Ps:TPins;
                    ControlPinLabel,GatePinLabel:TLabel;
                    SetControlButton,SetGateButton:TButton;
                    PCB:TComboBox);
procedure NumberPinShow();override;
end;

TD30_06Show=class(TDAC_Show)
private
 VoltageOrCurrentRG:TRadioGroup;
 ValueDiapazonLabel:TLabel;
 fD30_06:TD30_06;
 procedure VoltageOrCurrentRGClick(Sender: TObject);
 procedure LabelFilling;
 procedure ReadFromIniFile(ConfigFile:TIniFile);
 public
 PinShow:TPins30_06Show;
 Constructor Create(DAC:TD30_06;
                      CPL,GPL,VL,KL,VDL:TLabel;
                      SCB,SGB,VCB,VSB,KCB,KSB,RB:TButton;
                      PCB:TComboBox;
                      VOCRG:TRadioGroup);
 Procedure Free;

 procedure ReadFromIniFileAndToForm(ConfigFile:TIniFile);
 Procedure WriteToIniFile(ConfigFile:TIniFile);
end;


implementation

uses
  SysUtils;

{ TD30_06 }

procedure TD30_06.CreateHook;
begin
  fVoltageMaxValue:=D30_06_MaxVoltage;
  fKodMaxValue:=D30_06_MaxKod;
  fCurrentMaxValue:=D30_06_MaxCurrent;
//  fMessageError:='Output is unsuccessful';
  fSetterKod:=D30_06Command;
  FisVoltage:=True;
end;


procedure TD30_06.DataByteToSendFromInteger(IntData: Integer);
begin
  IntData:=NormedKod(IntData);
  fData[3] := ((IntData shr 8) and $3F);
  fData[4] := (IntData and $FF);
end;

procedure TD30_06.PinsToDataArray;
begin
 if FisVoltage then
   begin
    fData[1] := Pins.PinControl;
    fData[2] := Pins.PinGate;
   end         else
   begin
    fData[2] := Pins.PinControl;
    fData[1] := Pins.PinGate;
   end;
end;

function TD30_06.VoltageToKod(Voltage: double): integer;
begin
 if (not(FisVoltage))and(Voltage<-3) then Voltage:=-3;

 fOutPutValue:=Voltage;
 Voltage:=abs(Voltage);
 if FisVoltage then
     if Voltage>fVoltageMaxValue
        then Result:=fKodMaxValue
        else Result:=round(Voltage/fVoltageMaxValue*fKodMaxValue)
               else
     if Voltage>fCurrentMaxValue
        then Result:=fKodMaxValue
        else Result:=round(Voltage/fCurrentMaxValue*fKodMaxValue)
end;

{ TD30_06Show }

constructor TD30_06Show.Create(DAC: TD30_06;
                               CPL, GPL, VL, KL, VDL: TLabel;
                               SCB, SGB, VCB, VSB, KCB, KSB, RB: TButton;
                               PCB: TComboBox;
                               VOCRG: TRadioGroup);
begin
 inherited Create(DAC,VL, KL, VCB, VSB, KCB, KSB, RB);
 PinShow:=TPins30_06Show.Create(DAC.Pins,CPL,GPL,SCB,SGB,PCB);
 PinShow.HookNumberPinShow:=DAC.PinsToDataArray;
 fD30_06:=DAC;
 ValueDiapazonLabel:=VDL;
 VoltageOrCurrentRG:=VOCRG;
 VoltageOrCurrentRG.OnClick:=VoltageOrCurrentRGClick;
end;

procedure TD30_06Show.ReadFromIniFileAndToForm(ConfigFile: TIniFile);
begin
 ReadFromIniFile(ConfigFile);
 PinShow.NumberPinShow;
end;

procedure TD30_06Show.Free;
begin
 PinShow.Free;
 inherited Free;
end;

procedure TD30_06Show.LabelFilling;
begin
  if fD30_06.isVoltage then
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

procedure TD30_06Show.ReadFromIniFile(ConfigFile: TIniFile);
 var TempItemIndex:integer;
begin
 PinShow.PinsReadFromIniFile(ConfigFile);
 if PinShow.Pins.Name='' then Exit;
 TempItemIndex := ConfigFile.ReadInteger(PinShow.Pins.Name, 'VorC', -1);
 if (TempItemIndex > -1) and (TempItemIndex < VoltageOrCurrentRG.Items.Count) then
  begin
   VoltageOrCurrentRG.ItemIndex:=TempItemIndex;
   VoltageOrCurrentRGClick(fD30_06);
  end;
end;

procedure TD30_06Show.VoltageOrCurrentRGClick(Sender: TObject);
begin
 if VoltageOrCurrentRG.ItemIndex<0 then Exit;
 fD30_06.isVoltage:=(VoltageOrCurrentRG.Items[VoltageOrCurrentRG.ItemIndex]=PinNamesD30_06[0]);
 fD30_06.PinsToDataArray;
 LabelFilling;
 
end;

procedure TD30_06Show.WriteToIniFile(ConfigFile: TIniFile);
begin
 PinShow.PinsWriteToIniFile(ConfigFile);
 if PinShow.Pins.Name='' then Exit;
 ConfigFile.WriteInteger(PinShow.Pins.Name, 'VorC', VoltageOrCurrentRG.ItemIndex);
end;

{ TPins30_06Show }

constructor TPins30_06Show.Create(Ps: TPins;
                                  ControlPinLabel, GatePinLabel: TLabel;
                                  SetControlButton, SetGateButton: TButton;
                                  PCB: TComboBox);
begin
 inherited Create(Ps,ControlPinLabel,GatePinLabel,SetControlButton, SetGateButton,PCB);
 SetPinButtons[0].Caption := 'set '+LowerCase(PinNamesD30_06[0])+' pin';
 SetPinButtons[1].Caption := 'set '+LowerCase(PinNamesD30_06[1])+' pin';
end;

procedure TPins30_06Show.NumberPinShow;
 var i:byte;
begin
 for I := 0 to High(PinLabels) do
  begin
   PinLabels[i].Caption:=PinNamesD30_06[i]+' pin is ';
   if Pins.fPins[i]=UndefinedPin then
    PinLabels[i].Caption:=PinLabels[i].Caption+'undefined'
                           else
    PinLabels[i].Caption:=PinLabels[i].Caption+IntToStr(Pins.fPins[i]);
  end;
 HookNumberPinShow; 
end;

end.
