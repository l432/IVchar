unit AD9833;

interface

uses
  ArduinoDevice;

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
 end;

implementation

uses
  PacketParameters, Math;

{ TAD9833 }

procedure TAD9833.AddWordToSendArray(HighByte:byte;LowByte:byte=$00);
begin
 fControlByteLow:=LowByte;
 fControlByteHigh:=HighByte;
 AddWordToSendArray();
end;

function TAD9833.ConvertFreqValueToKod(Freq: double): LongWord;
begin
 Result:=round(min(Freq,AD9833_MaxFreq)*$10000000/25e6)and $0FFFFFFF;
end;

function TAD9833.ConvertPhaseValueToKod(Phase: double): word;
begin
 Result:= round((round(Phase) mod 360)*$1000/360.0)and $0FFF;
end;

procedure TAD9833.CreateHook;
 var i:TAD9833_ChanelNumber;
begin
 fSetterKod:=AD9833Command;
 fMessageError:='AD9833 output is unsuccessful';
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

procedure TAD9833.Generate;
begin
  Action();
// if fMode=ad9833_mode_off then
//  begin
//   Reset();
//   Exit;
//  end;
// SetLength(fData,2);
//
// PrepareToPhaseChange();
// PrepareToFreqChange();
// PrepareToModeChange();
//
// isNeededComPortState();
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
// fMode:=ad9833_mode_off;
//  fControlByteHigh := fControlByteHigh and $3F; // Control Bits (D15, D14) to 00
// fControlByteLow:=fControlByteLow or $C0;  // SLEEP1 (D7) and SLEEP12(D6) to 1
// SetLength(fData,4);
// fData[2] := fControlByteHigh;
// fData[3] := fControlByteLow;
// isNeededComPortState();
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

end.
