unit DACR2R;

interface

uses
  SPIdevice, Measurement, OlegType, StdCtrls;

const DACR2R_MaxValue=65535;
      DACR2R_Factor=10000;

      DACR2R_Pos=$00; //������� �������
      DACR2R_Neg=$FF; //��'���� �������
      DACR2R_Reset=$AA; //�������������� ������� �������


type

TDACR2R_Calibr=class
private
 pos01:TArrWord;
 neg01:TArrWord;
 pos16:TArrWord;
 neg16:TArrWord;
 procedure WriteToFile(FileName:string;arr:TArrWord);
 procedure ReadFromFile(FileName:string;arr:TArrWord);
public
 Constructor Create();
class function VoltToKod(Volt:double):word;
 function VoltToKodIndex(Volt:double):word;
 function VoltToArray(Volt:double):TArrWord;
 procedure Add(RequiredVoltage,RealVoltage:double);
 procedure AddWord(Index,Kod:word;Arr:TArrWord);
 procedure VectorToCalibr(Vec:PVector);
 procedure WriteToFileData();
 procedure ReadFromFileData();
end;

TDACR2R=class(TArduinoDevice,IOutput)
  {������� ���� ��� ���}
private
 fCalibration:TDACR2R_Calibr;
 function  IntVoltage(Voltage:double):integer;
 procedure DataByteToSendPrepare(Voltage: Double);
 procedure PacketCreateAndSend(report: string);
 procedure DataByteToSendFromInteger(IntData: Integer);
protected
 Procedure PacketReceiving(Sender: TObject; const Str: string);override;
public
 Constructor Create();overload;override;
 Procedure Free;
 Procedure Output(Voltage:double);
 Procedure Reset();
 Procedure CalibrationRead();
 Procedure CalibrationWrite();
 procedure CalibrationFileProcessing(filename:string);
 Procedure OutputInt(Kod:integer);
 function CalibrationStep(Voltage:double):double;
 procedure OutputCalibr(Voltage:double);
 procedure SaveFileWithCalibrData(DataVec:PVector);
end;

//TDACR2RShow=class(TSPIDeviceShow)
//private
// ValueChangeButton,ValueSetButton,
// KodChangeButton,KodSetButton,ResetButton:TButton;
// ValueLabel,KodLabel:TLabel;
// procedure ValueChangeButtonAction(Sender:TObject);
// procedure ValueSetButtonAction(Sender:TObject);
// procedure KodChangeButtonAction(Sender:TObject);
// procedure KodSetButtonAction(Sender:TObject);
// procedure ResetButtonClick(Sender:TObject);
//public
// Constructor Create(DACR2R:TDACR2R;
//                      CPL,GPL,VL,KL:TLabel;
//                      SCB,SGB,VCB,VSB,KCB,KSB,RB:TButton;
//                      PCB:TComboBox);
//end;

TDACR2RShow=class(TSPIDeviceShow)
private
 DACR2R:TDACR2R;
 ValueChangeButton,ValueSetButton,
 KodChangeButton,KodSetButton,ResetButton:TButton;
 ValueLabel,KodLabel:TLabel;
 procedure ValueChangeButtonAction(Sender:TObject);
 procedure ValueSetButtonAction(Sender:TObject);
 procedure KodChangeButtonAction(Sender:TObject);
 procedure KodSetButtonAction(Sender:TObject);
 procedure ResetButtonClick(Sender:TObject);
public
 Constructor Create(DAC:TDACR2R;
                      CPL,GPL,VL,KL:TLabel;
                      SCB,SGB,VCB,VSB,KCB,KSB,RB:TButton;
                      PCB:TComboBox);
end;



implementation

uses
  SysUtils, PacketParameters, OlegGraph, Graphics, Dialogs, Math, Classes;


{ TDACR2R }

function TDACR2R.IntVoltage(Voltage: double): integer;
 var tempArrWord:TArrWord;
     Index,AddIndex:integer;
begin
 Result:=0;
 if TDACR2R_Calibr.VoltToKod(Voltage)=0 then Exit;

 tempArrWord:=fCalibration.VoltToArray(Voltage);
 if tempArrWord=nil then Exit;
 Index:=fCalibration.VoltToKodIndex(Voltage);
 AddIndex:=1;
 repeat
   try
    Result:=tempArrWord[Index];
   except
    Break;
   end;
   Index:=Index-AddIndex;
   if AddIndex>0 then AddIndex:=AddIndex*(-1)
                 else AddIndex:=abs(AddIndex)+1;
 until ((Result<>0)or
        (Index<Low(tempArrWord))or
        (Index>High(tempArrWord)));
 if Result=0 then Result:=TDACR2R_Calibr.VoltToKod(Voltage);
end;


procedure TDACR2R.Output(Voltage: double);
begin
 if Voltage<0 then fData[2]:=DACR2R_Neg
              else fData[2]:=DACR2R_Pos;
 DataByteToSendPrepare(Voltage);
 PacketCreateAndSend('DAC R2R output value setting is unsuccessful');
end;

procedure TDACR2R.OutputCalibr(Voltage: double);
begin
 if Voltage<0 then fData[2]:=DACR2R_Neg
              else fData[2]:=DACR2R_Pos;
 DataByteToSendFromInteger(TDACR2R_Calibr.VoltToKod(Voltage));
 PacketCreateAndSend('DAC R2R output calibration value setting is unsuccessful');
end;

Procedure TDACR2R.OutputInt(Kod:integer);
begin
 if Kod<0 then fData[2]:=DACR2R_Neg
          else fData[2]:=DACR2R_Pos;
 DataByteToSendFromInteger(abs(Kod));
 PacketCreateAndSend('DAC R2R output kod setting is unsuccessful');
end;

procedure TDACR2R.DataByteToSendFromInteger(IntData: Integer);
begin
  fData[0] := ((IntData shr 8) and $FF);
  fData[1] := (IntData and $FF);
end;

procedure TDACR2R.PacketReceiving(Sender: TObject; const Str: string);
begin

end;

procedure TDACR2R.Reset;
begin
// Output(0);
 fData[2]:=DACR2R_Pos;
 fData[0] := $00;
 fData[1] := $00;
 PacketCreateAndSend('DAC R2R reset is unsuccessful');
end;


procedure TDACR2R.SaveFileWithCalibrData(DataVec: PVector);
 var FileName:string;
begin
  DataVec.Sorting;
  DataVec.DeleteDuplicate;
  FileName:='cal'+IntToStr(trunc(DataVec^.X[0]*100))+
            '_'+IntToStr(trunc(DataVec^.X[High(DataVec^.X)]*100))+
            '.dat';
  DataVec.Write_File(FileName,5);
end;

//procedure TDACR2R.PacketCreateAndSend(report: string);
//begin
//  PacketCreate([DACR2RCommand, PinControl, PinGate, fData[0], fData[1], fData[2]]);
//  PacketIsSend(fComPort, report);
//end;

procedure TDACR2R.PacketCreateAndSend(report: string);
begin
  PacketCreate([DACR2RCommand, Pins.PinControl, Pins.PinGate, fData[0], fData[1], fData[2]]);
  PacketIsSend(fComPort, report);
end;

procedure TDACR2R.CalibrationFileProcessing(filename: string);
 var vec:PVector;
begin
 new(vec);
 Read_File (filename, vec);
 fCalibration.VectorToCalibr(vec);
end;

procedure TDACR2R.CalibrationRead;
begin
 fCalibration.ReadFromFileData();
end;

function TDACR2R.CalibrationStep(Voltage: double): double;
begin
  if abs(Voltage)<=1 then Result:=1e-4
                     else Result:=3e-4;
end;

procedure TDACR2R.CalibrationWrite;
begin
 fCalibration.WriteToFileData();
end;

constructor TDACR2R.Create;
begin
  inherited Create();
  SetLength(fData,3);
  fCalibration:=TDACR2R_Calibr.Create;
end;

procedure TDACR2R.DataByteToSendPrepare(Voltage: Double);
var
  IntData: Integer;
begin
  IntData := IntVoltage(Voltage);
  DataByteToSendFromInteger(IntData);
end;

procedure TDACR2R.Free;
begin
 fCalibration.Free;
 inherited Free;
end;

{ TDACR2RShow }

//constructor TDACR2RShow.Create(DACR2R: TDACR2R;
//                               CPL,GPL,VL,KL:TLabel;
//                               SCB,SGB,VCB,VSB,KCB,KSB,RB:TButton;
//                               PCB: TComboBox);
//begin
// inherited Create(DACR2R,CPL,GPL,SCB,SGB,PCB);
//  ValueLabel:=VL;
//  ValueLabel.Caption:='0';
//  ValueLabel.Font.Color:=clBlack;
//  ValueChangeButton:=VCB;
//  ValueChangeButton.OnClick:=ValueChangeButtonAction;
//  ValueSetButton:=VSB;
//  ValueSetButton.OnClick:=ValueSetButtonAction;
//  ResetButton:=RB;
//  ResetButton.OnClick:=ResetButtonClick;
//  KodLabel:=KL;
//  KodLabel.Caption:='0';
//  KodLabel.Font.Color:=clBlack;
//  KodChangeButton:=KCB;
//  KodChangeButton.OnClick:=KodChangeButtonAction;
//  KodSetButton:=KSB;
//  KodSetButton.OnClick:=KodSetButtonAction;
//
//  CreateFooter();
//end;

constructor TDACR2RShow.Create(DAC: TDACR2R;
                               CPL,GPL,VL,KL:TLabel;
                               SCB,SGB,VCB,VSB,KCB,KSB,RB:TButton;
                               PCB: TComboBox);
begin
 inherited Create(DAC.Pins,CPL,GPL,SCB,SGB,PCB);
  DACR2R:=DAC;
  ValueLabel:=VL;
  ValueLabel.Caption:='0';
  ValueLabel.Font.Color:=clBlack;
  ValueChangeButton:=VCB;
  ValueChangeButton.OnClick:=ValueChangeButtonAction;
  ValueSetButton:=VSB;
  ValueSetButton.OnClick:=ValueSetButtonAction;
  ResetButton:=RB;
  ResetButton.OnClick:=ResetButtonClick;
  KodLabel:=KL;
  KodLabel.Caption:='0';
  KodLabel.Font.Color:=clBlack;
  KodChangeButton:=KCB;
  KodChangeButton.OnClick:=KodChangeButtonAction;
  KodSetButton:=KSB;
  KodSetButton.OnClick:=KodSetButtonAction;

  CreateFooter();
end;


procedure TDACR2RShow.KodChangeButtonAction(Sender: TObject);
 var value:string;
begin
 if InputQuery('Value', 'Output kod is expect', value) then
  begin
    try
      KodLabel.Caption:=IntToStr(StrToInt(value));
      KodLabel.Font.Color:=clBlack;
    except

    end;
  end;
end;

//procedure TDACR2RShow.KodSetButtonAction(Sender: TObject);
//begin
//   (ArduDevice as TDACR2R).OutputInt(StrToInt(KodLabel.Caption));
//   KodLabel.Font.Color:=clPurple;
//   ValueLabel.Font.Color:=clBlack;
//end;
//
//procedure TDACR2RShow.ResetButtonClick(Sender: TObject);
//begin
// (ArduDevice as TDACR2R).Reset();
//end;

procedure TDACR2RShow.KodSetButtonAction(Sender: TObject);
begin
   DACR2R.OutputInt(StrToInt(KodLabel.Caption));
   KodLabel.Font.Color:=clPurple;
   ValueLabel.Font.Color:=clBlack;
end;

procedure TDACR2RShow.ResetButtonClick(Sender: TObject);
begin
 DACR2R.Reset();
end;

procedure TDACR2RShow.ValueChangeButtonAction(Sender: TObject);
 var value:string;
begin
 if InputQuery('Value', 'Output value is expect', value) then
  begin
    try
      ValueLabel.Caption:=FloatToStrF(StrToFloat(value),ffFixed, 6, 4);
      ValueLabel.Font.Color:=clBlack;
    except

    end;
  end;
end;

//procedure TDACR2RShow.ValueSetButtonAction(Sender: TObject);
//begin
//   (ArduDevice as TDACR2R).Output(Strtofloat(ValueLabel.Caption));
//   ValueLabel.Font.Color:=clPurple;
//   KodLabel.Font.Color:=clBlack;
//end;

procedure TDACR2RShow.ValueSetButtonAction(Sender: TObject);
begin
   DACR2R.Output(Strtofloat(ValueLabel.Caption));
   ValueLabel.Font.Color:=clPurple;
   KodLabel.Font.Color:=clBlack;
end;

procedure TDACR2R_Calibr.Add(RequiredVoltage, RealVoltage: double);
 var tempArrWord:TArrWord;
     Index:integer;
begin
 tempArrWord:=Self.VoltToArray(RealVoltage);
 if tempArrWord=nil then Exit;
 Index:=VoltToKodIndex(RealVoltage);
 if (Index>=Low(tempArrWord))and
    (Index<=High(tempArrWord)) then
        tempArrWord[Index]:=VoltToKod(RequiredVoltage);
end;

procedure TDACR2R_Calibr.AddWord(Index, Kod: word; Arr: TArrWord);
begin
 if (Index<=High(Arr)) then Arr[Index]:=Kod;
end;

constructor TDACR2R_Calibr.Create;
 var i:integer;
begin
 inherited Create;
 SetLength(pos01,10000);
 SetLength(neg01,10000);
 SetLength(pos16,5500);
 SetLength(neg16,5500);
 for I := Low(pos01) to High(pos01) do pos01[i]:=0;
 for I := Low(pos16) to High(pos16) do pos01[i]:=0;
 for I := Low(neg01) to High(neg01) do pos01[i]:=0;
 for I := Low(neg16) to High(neg16) do pos01[i]:=0;
end;

procedure TDACR2R_Calibr.ReadFromFile(FileName: string; arr: TArrWord);
 var F:TextFile;
     Index,Kod:word;
begin
 if not(FileExists(FileName)) then Exit;
 AssignFile(f,FileName);
 Reset(f);
 while not(eof(f)) do
    begin
      readln(f,Index,Kod);
      try
        arr[Index]:=Kod;
      finally

      end;
    end;
 CloseFile(f);
end;

procedure TDACR2R_Calibr.ReadFromFileData;
begin
 ReadFromFile('pos01.cvt',pos01);
 ReadFromFile('pos16.cvt',pos16);
 ReadFromFile('neg01.cvt',neg01);
 ReadFromFile('neg16.cvt',neg16);
end;

procedure TDACR2R_Calibr.VectorToCalibr(Vec: PVector);
 var i:integer;
     tempVec:PVector;
begin
  for I := 0 to High(Vec^.X) do
   Vec^.Y[i]:=round(Vec^.Y[i]*10000)/10000;
 for I := 0 to High(Vec^.X)-2 do
   if (abs(Vec^.Y[i+1])<0.05*abs(Vec^.Y[i]))and
      (abs(Vec^.Y[i+1])<0.05*abs(Vec^.Y[i+2]))
               then Vec^.Delete(i+1);
 new(tempVec);
 SetLenVector(tempVec,0);
 for I := 0 to High(Vec^.X) do
   if Vec^.Y[i]>0 then tempVec^.Add(Vec^.X[i],Vec^.Y[i]);

 tempVec^.Sorting();
 tempVec^.SwapXY();
 tempVec^.DeleteDuplicate();
 for I := 0 to High(tempVec^.X) do
   Add(tempVec^.Y[i],tempVec^.X[i]);
 dispose(tempVec);

 new(tempVec);
 SetLenVector(tempVec,0);
 for I := 0 to High(Vec^.X) do
   if Vec^.Y[i]<0 then tempVec^.Add(Vec^.X[i],Vec^.Y[i]);
 tempVec^.Sorting(False);
 tempVec^.SwapXY();
 tempVec^.DeleteDuplicate();
 for I := 0 to High(tempVec^.X) do
   Add(tempVec^.Y[i],tempVec^.X[i]);
 dispose(tempVec);

end;

function TDACR2R_Calibr.VoltToArray(Volt: double): TArrWord;
begin
 Result:=nil;
 if VoltToKod(Volt)=0 then Exit;
 if (Volt>0)and(Volt<1.001) then Result:=Self.pos01;
 if (Volt<0)and(Volt>-1.001) then Result:=Self.neg01;
 if (Volt>=1.001) then Result:=Self.pos16;
 if (Volt<=-1.001) then Result:=Self.neg16;
end;

class function TDACR2R_Calibr.VoltToKod(Volt: double): word;
begin
 Result:=Min(Round(abs(Volt)*DACR2R_Factor),DACR2R_MaxValue);
end;

function TDACR2R_Calibr.VoltToKodIndex(Volt: double): word;
begin
  if abs(Volt)<1.001 then
           Result:=min(10000,VoltToKod(Volt))-1
                     else
           Result:=min(6500,Round(VoltToKod(Volt)/10))-1001;
end;

procedure TDACR2R_Calibr.WriteToFile(FileName: string; arr: TArrWord);
 var i:integer;
     Str:TStringList;
begin
  if High(arr)<0 then Exit;
  Str:=TStringList.Create;
  for I := 0 to High(arr) do
    if arr[i]<>0 then
      Str.Add(IntToStr(i)+' '+IntToStr(arr[i]));
  Str.SaveToFile(FileName);
  Str.Free;
end;

procedure TDACR2R_Calibr.WriteToFileData;
begin
 WriteToFile('pos01.cvt',pos01);
 WriteToFile('pos16.cvt',pos16);
 WriteToFile('neg01.cvt',neg01);
 WriteToFile('neg16.cvt',neg16);
end;


end.