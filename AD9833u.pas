unit AD9833u;

interface

uses
  Buttons, ShowTypes, Classes, ExtCtrls,
  StdCtrls, IniFiles, OlegShowTypes, ArduinoDeviceNew,
  ArduinoDeviceShow;

const
     AD9833_MaxFreq=12.5e6;
     AD9833_Defaulf_Freq=1000;
     AD9833_Defaulf_Phase=0;

type


 TAD9833_ChanelNumber=0..1;
 TAD9833_Mode=(ad9833_mode_off,
               ad9833_mode_sine,
               ad9833_mode_triangle,
               ad9833_mode_square);

const
 AD9833_ModeLabel:array[TAD9833_Mode]of string=
  ('Off', 'Sine', 'Triangle','Square');

type

 TAD9833=class(TArduinoSetter)
  private
    procedure PrepareToPhaseChange;
    procedure PrepareToFreqChange;
    procedure PrepareToModeChange;
    procedure SetActiveChanel(const Value: TAD9833_ChanelNumber);
    procedure SetMode(const Value: TAD9833_Mode);
    procedure AddWordToSendArray;overload;
    procedure AddWordToSendArray(HighByte:byte;LowByte:byte=$00);overload;
    procedure AddFreqHalfKodToSendArray(FreqLow: Word);
  protected
   fMode:TAD9833_Mode;
   fFreq:array[TAD9833_ChanelNumber] of LongWord;
   fPhase:array[TAD9833_ChanelNumber] of word;
   fFreqLast:array[TAD9833_ChanelNumber] of LongWord;
   fPhaseLast:array[TAD9833_ChanelNumber] of word;
   fControlByteLow:byte;
   fControlByteHigh:byte;
   fActiveChanel:TAD9833_ChanelNumber;
   procedure PinsCreate();override;
   procedure CreateHook;override;
   function ConvertFreqValueToKod(Freq:double):LongWord;
   function ConvertPhaseValueToKod(Phase:double):word;
  public
   property ActiveChanel:TAD9833_ChanelNumber read FActiveChanel write SetActiveChanel;
   property Mode:TAD9833_Mode read FMode write SetMode;
   procedure SetFreq(chan:TAD9833_ChanelNumber; Freq:double);
   procedure SetPhase(chan:TAD9833_ChanelNumber; Phase:double);
   procedure Reset();
   procedure Generate();
   procedure Action();
   Constructor Create();
//   procedure Free;//override;
   destructor Destroy; override;
 end;

TAD9833Show=class(TArduinoSetterShow)
 private
   fSetterNname:string;
   fSBStop:TSpeedButton;
   fSBGenerateChan1:TSpeedButton;
   fSBGenerateChan2:TSpeedButton;
   fFreqCh1Show:TDoubleParameterShow;
   fFreqCh2Show:TDoubleParameterShow;
   fPhaseCh1Show:TDoubleParameterShow;
   fPhaseCh2Show:TDoubleParameterShow;
   fMode:TRadioGroup;
   procedure ResetButtonClick(Sender:TObject);
   procedure GenerateButtonClick(Sender:TObject);
   procedure SetParameters(ChanNumber: TAD9833_ChanelNumber);
 protected
   procedure CreatePinShow(PinLs: array of TPanel;
                   PinVariant:TStringList);override;
 public
  Constructor Create(AD9833:TAD9833;
                     CPL:TPanel;
                     PinVariant:TStringList;
                     Fr1Data,Ph1Data,Fr2Data,Ph2Data:TStaticText;
                     Fr1L,Ph1L,Fr2L,Ph2L:TLabel;
                     Gen1SB,Gen2SB,StopSB:TSpeedButton;
                     RGM:TRadioGroup);
//  Procedure Free;// override;
  destructor Destroy; override;
  Procedure WriteToIniFile(ConfigFile:TIniFile);override;
  Procedure HookReadFromIniFile(ConfigFile:TIniFile);override;
 end;

 var
  AD9833:TAD9833;
  AD9833Show:TAD9833Show;

implementation

uses
  PacketParameters, Math, OlegType, Windows,
  Dialogs, OlegFunction;

{ TAD9833new }

procedure TAD9833.AddWordToSendArray(HighByte:byte;LowByte:byte=$00);
begin
 fControlByteLow:=LowByte;
 fControlByteHigh:=HighByte;
 AddWordToSendArray();
end;

function TAD9833.ConvertFreqValueToKod(Freq: double): LongWord;
begin
 Result:=round(min(Freq,AD9833_MaxFreq)*$10000000/25.0e6)and $0FFFFFFF;
end;

function TAD9833.ConvertPhaseValueToKod(Phase: double): word;
begin
 Result:= round((round(Phase) mod 360)*$1000/360.0)and $0FFF;
end;

constructor TAD9833.Create;
begin
 inherited Create('AD9833');
end;

procedure TAD9833.CreateHook;
 var i:TAD9833_ChanelNumber;
begin
 inherited CreateHook;
 fSetterKod:=AD9833Command;
 MessageError:='AD9833 output is unsuccessful';
 fMode:=ad9833_mode_off;
 fActiveChanel:=0;
 for I := Low(TAD9833_ChanelNumber) to High(TAD9833_ChanelNumber) do
  begin
   SetFreq(i,AD9833_Defaulf_Freq);
   SetPhase(i,AD9833_Defaulf_Phase);
   fFreqLast[i]:=0;
   fPhaseLast[i]:=0;
  end;
 fControlByteLow:=0;
 fControlByteHigh:=0;
 SetLength(fData,2);
end;

destructor TAD9833.Destroy;
begin
   Reset;
  sleep(50);
  inherited;
end;

//procedure TAD9833.Free;
//begin
//  Reset;
//  sleep(50);
//  inherited Free;
//end;

procedure TAD9833.Generate;
begin
  Action();
end;

procedure TAD9833.Action;
begin
 SetLength(fData,2);
 if fMode<>ad9833_mode_off then
  begin
   PrepareToPhaseChange();
   PrepareToFreqChange();
  end;
 PrepareToModeChange();
 isNeededComPortState();
end;

procedure TAD9833.AddFreqHalfKodToSendArray(FreqLow: Word);
begin
  if fActiveChanel = 0 then
    fControlByteHigh := $40
  else
    fControlByteHigh := $80;
  fControlByteHigh := fControlByteHigh + (byte(FreqLow shr 8) and $3F);
  fControlByteLow := byte(FreqLow and $FF);
  AddWordToSendArray();
end;

procedure TAD9833.AddWordToSendArray;
begin
  SetLength(fData, High(fData) + 3);
  fData[High(fData) - 1] := fControlByteHigh;
  fData[High(fData)] := fControlByteLow;
end;

procedure TAD9833.PrepareToFreqChange;
 var FreqLow,FreqHigh,FreqLastLow,FreqLastHigh:word;
begin
 FreqLow:=word (fFreq[fActiveChanel] and $3FFF);
 FreqHigh:=word ((fFreq[fActiveChanel] shr 14)and $3FFF);
 FreqLastLow:=word (fFreqLast[fActiveChanel] and $3FFF);
 FreqLastHigh:=word ((fFreqLast[fActiveChanel] shr 14)and $3FFF);
 fFreqLast[fActiveChanel]:=fFreq[fActiveChanel];



 if ((FreqLow<>FreqLastLow)and((FreqHigh<>FreqLastHigh))) then
  begin
   AddWordToSendArray($20);   //(D15, D14 = 00), B28 (D13) = 1
   AddFreqHalfKodToSendArray(FreqLow);
   AddFreqHalfKodToSendArray(FreqHigh);
   Exit;
  end;

 if FreqLow<>FreqLastLow then
  begin
   AddWordToSendArray($00);//(D15, D14 = 00), B28 (D13) = 0, HLB (D12) = 0
   AddFreqHalfKodToSendArray(FreqLow);
   Exit;
  end;

 if FreqHigh<>FreqLastHigh then
  begin
   AddWordToSendArray($10); //(D15, D14 = 00), B28 (D13) = 0, HLB (D12) = 1
   AddFreqHalfKodToSendArray(FreqHigh);
   Exit;
  end;

end;

procedure TAD9833.PrepareToModeChange;
begin
 if fMode=ad9833_mode_off then
  begin
   fControlByteHigh := fControlByteHigh and $3F; // Control Bits (D15, D14) to 00
   fControlByteLow:=fControlByteLow or $C0;  // SLEEP1 (D7) and SLEEP12(D6) to 1
  end                     else
  begin
   fControlByteHigh := $00;
   fControlByteLow := $00;
   if fActiveChanel = 1 then
    fControlByteHigh :=fControlByteHigh +$0C;
   case fMode of
     ad9833_mode_triangle: fControlByteLow := fControlByteLow + $02;
     ad9833_mode_square: fControlByteLow := fControlByteLow + $28;
   end;
  end;
 AddWordToSendArray;
end;

procedure TAD9833.PrepareToPhaseChange;
begin
  if fPhase[fActiveChanel] <> fPhaseLast[fActiveChanel] then
    begin
      fControlByteHigh := $C0; // Control Bits (D15, D14) to 11, Phase Register
      if fActiveChanel = 1 then
        fControlByteHigh := fControlByteHigh + $20; // D13=1
      fControlByteHigh := (fControlByteHigh and $F0) + (byte((fPhase[fActiveChanel] shr 8)) and $0F);
      fControlByteLow := byte(fPhase[fActiveChanel] and $00FF);
      AddWordToSendArray;
      fPhaseLast[fActiveChanel]:=fPhase[fActiveChanel];
    end;
end;

procedure TAD9833.PinsCreate;
begin
  Pins := TPins.Create(Name,['Control'],1);
end;

procedure TAD9833.Reset;
begin
 fMode:=ad9833_mode_off;
 Action();
end;


procedure TAD9833.SetActiveChanel(const Value: TAD9833_ChanelNumber);
begin
  FActiveChanel := Value;
end;

procedure TAD9833.SetFreq(chan: TAD9833_ChanelNumber; Freq: double);
begin
 fFreq[chan]:=ConvertFreqValueToKod(Freq);
end;

procedure TAD9833.SetMode(const Value: TAD9833_Mode);
begin
  FMode := Value;
end;

procedure TAD9833.SetPhase(chan: TAD9833_ChanelNumber; Phase: double);
begin
 fPhase[chan]:=ConvertPhaseValueToKod(Phase);
end;

{ TAD9833Show }

constructor TAD9833Show.Create(AD9833: TAD9833;
                       CPL: TPanel;
                       PinVariant: TStringList;
                       Fr1Data, Ph1Data, Fr2Data, Ph2Data: TStaticText;
                       Fr1L, Ph1L, Fr2L, Ph2L: TLabel;
                       Gen1SB, Gen2SB, StopSB: TSpeedButton;
                       RGM:TRadioGroup);
var
  I: TAD9833_Mode;
begin
 inherited Create(AD9833,[CPL],PinVariant);
 fSetterNname:=fArduinoSetter.Name;
 fFreqCh1Show:=TDoubleParameterShow.Create(Fr1Data,Fr1L,'Freq I (Hz):',AD9833_Defaulf_Freq,9);
 fFreqCh1Show.ForUseInShowObject(fArduinoSetter);

 fFreqCh2Show:=TDoubleParameterShow.Create(Fr2Data,Fr2L,'Freq II (Hz):',AD9833_Defaulf_Freq,9);
 fFreqCh2Show.ForUseInShowObject(fArduinoSetter);

 fPhaseCh1Show:=TDoubleParameterShow.Create(Ph1Data,Ph1L,'Phase I (grad):',AD9833_Defaulf_Phase,4);
 fPhaseCh1Show.ForUseInShowObject(fArduinoSetter);

 fPhaseCh2Show:=TDoubleParameterShow.Create(Ph2Data,Ph2L,'Phase II (grad):',AD9833_Defaulf_Phase,4);
 fPhaseCh2Show.ForUseInShowObject(fArduinoSetter);

 fMode:=RGM;
 fMode.Items.Clear;
 for I :=Low(AD9833_ModeLabel) to High(AD9833_ModeLabel) do
    fMode.Items.Add(AD9833_ModeLabel[i]);

 fSBStop:=StopSB;
 fSBGenerateChan1:=Gen1SB;
 fSBGenerateChan2:=Gen2SB;
 fSBStop.Caption:='Stop';
 fSBGenerateChan1.Caption:='Generate, I chan';
 fSBGenerateChan2.Caption:='Generate, II chan';
 fSBStop.GroupIndex:=AD9833Command;
 fSBGenerateChan1.GroupIndex:=AD9833Command;
 fSBGenerateChan2.GroupIndex:=AD9833Command;

 fSBStop.AllowAllUp:=false;
 fSBGenerateChan1.AllowAllUp:=false;
 fSBGenerateChan2.AllowAllUp:=false;
 fSBStop.Down:=true;

 fSBStop.OnClick:=ResetButtonClick;
 fSBGenerateChan1.OnClick:=GenerateButtonClick;
 fSBGenerateChan2.OnClick:=GenerateButtonClick;
end;

procedure TAD9833Show.CreatePinShow(PinLs: array of TPanel;
                                    PinVariant: TStringList);
begin
  PinShow:=TOnePinsShow.Create(fArduinoSetter.Pins,PinLs[0],PinVariant);
end;

destructor TAD9833Show.Destroy;
begin
 fPhaseCh2Show.Free;
 fPhaseCh1Show.Free;
 fFreqCh2Show.Free;
 fFreqCh1Show.Free;
  inherited;
end;

//procedure TAD9833Show.Free;
//begin
// fPhaseCh2Show.Free;
// fPhaseCh1Show.Free;
// fFreqCh2Show.Free;
// fFreqCh1Show.Free;
// inherited Free;
//end;

procedure TAD9833Show.GenerateButtonClick(Sender: TObject);
begin
  if Sender=fSBGenerateChan1 then
    begin
     SetParameters(0);
     fPhaseCh2Show.ColorToActive(false);
     fPhaseCh1Show.ColorToActive(true);
     fFreqCh2Show.ColorToActive(false);
     fFreqCh1Show.ColorToActive(true);
    end                       else
    begin
     SetParameters(1);
     fPhaseCh2Show.ColorToActive(true);
     fPhaseCh1Show.ColorToActive(false);
     fFreqCh2Show.ColorToActive(true);
     fFreqCh1Show.ColorToActive(false);
    end;
 (fArduinoSetter as TAD9833).Generate();
end;

procedure TAD9833Show.HookReadFromIniFile(ConfigFile: TIniFile);
begin
  inherited HookReadFromIniFile(ConfigFile);
  fPhaseCh2Show.ReadFromIniFile(ConfigFile);
  fPhaseCh1Show.ReadFromIniFile(ConfigFile);
  fFreqCh2Show.ReadFromIniFile(ConfigFile);
  fFreqCh1Show.ReadFromIniFile(ConfigFile);
  fMode.ItemIndex:= ConfigFile.ReadInteger(fSetterNname, 'Mode',0);
end;


procedure TAD9833Show.ResetButtonClick(Sender: TObject);
begin
 (fArduinoSetter as TAD9833).Reset();
 fPhaseCh2Show.ColorToActive(false);
 fPhaseCh1Show.ColorToActive(false);
 fFreqCh2Show.ColorToActive(false);
 fFreqCh1Show.ColorToActive(false);
end;

procedure TAD9833Show.WriteToIniFile(ConfigFile: TIniFile);
begin
  inherited WriteToIniFile(ConfigFile);
  fPhaseCh2Show.WriteToIniFile(ConfigFile);
  fPhaseCh1Show.WriteToIniFile(ConfigFile);
  fFreqCh2Show.WriteToIniFile(ConfigFile);
  fFreqCh1Show.WriteToIniFile(ConfigFile);
  WriteIniDef(ConfigFile, fSetterNname, 'Mode', fMode.ItemIndex);
end;

procedure TAD9833Show.SetParameters(ChanNumber: TAD9833_ChanelNumber);
begin
  (fArduinoSetter as TAD9833).Mode:=TAD9833_Mode(fMode.ItemIndex);
  (fArduinoSetter as TAD9833).SetActiveChanel(ChanNumber);
  if ChanNumber=0 then
   begin
    (fArduinoSetter as TAD9833).SetFreq(ChanNumber, fFreqCh1Show.Data);
    (fArduinoSetter as TAD9833).SetPhase(ChanNumber, fPhaseCh1Show.Data);
   end            else
   begin
    (fArduinoSetter as TAD9833).SetFreq(ChanNumber, fFreqCh2Show.Data);
    (fArduinoSetter as TAD9833).SetPhase(ChanNumber, fPhaseCh2Show.Data);
   end;

end;

initialization
   AD9833:=TAD9833.Create;
finalization

   AD9833.Free;
end.
