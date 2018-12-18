unit DACR2R;

interface

uses
  ArduinoDevice, Measurement, OlegType, StdCtrls, RS232device, CPort, Classes, 
  ExtCtrls, ShowTypes, IniFiles;

const DACR2R_MaxValue=65535;
      DACR2R_Factor=10000;

      DACR2RCommand=$4;

//      DACR2R_Pos=$0F; //������� �������
//      DACR2R_Neg=$FF; //��'���� �������
//      DACR2R_Reset=$AA; //�������������� ������� �������

//      DACR2R_Report='DAC R2R output is unsuccessful';

type

TDACR2R_Calibr=class
private
// pos01:TArrWord;
// neg01:TArrWord;
// pos16:TArrWord;
// neg16:TArrWord;
// pos01:PArrWord;
// neg01:PArrWord;
// pos16:PArrWord;
// neg16:PArrWord;
 pos01:TStringList;
 neg01:TStringList;
 pos16:TStringList;
 neg16:TStringList;
// procedure WriteToFile(FileName:string;arr:TArrWord);
// procedure ReadFromFile(FileName:string;arr:TArrWord);
 procedure WriteToFile(FileName:string;arr:TStringList);
 procedure ReadFromFile(FileName:string;arr:TStringList);
public
 Constructor Create();
class function VoltToKod(Volt:double):word;
 function VoltToKodIndex(Volt:double):word;
// function VoltToArray(Volt:double):TArrWord;
 function VoltToArray(Volt:double):TStringList;
 procedure Add(RequiredVoltage,RealVoltage:double);
// procedure AddWord(Index,Kod:word;Arr:TArrWord);
 procedure VectorToCalibr(Vec:PVector);
 procedure WriteToFileData();
 procedure ReadFromFileData();
 Procedure Free;
end;



TDACR2R=class(TArduinoDAC,ICalibration)
private
 fCalibration:TDACR2R_Calibr;
protected
 function  VoltageToKod(Voltage:double):integer;override;
 procedure CreateHook;override;
 procedure PinsCreate();override;
public
 Constructor Create(CP:TComPort;Nm:string);//override;
 Procedure Free;
 Procedure CalibrationRead();
 Procedure CalibrationWrite();
 procedure CalibrationFileProcessing(filename:string);
 function CalibrationStep(Voltage:double):double;
 procedure OutputCalibr(Voltage:double);
 procedure SaveFileWithCalibrData(DataVec:PVector);
 procedure PinsToDataArray;override;
end;

TDACR2RShow=class(TArduinoDACShow)
protected
   procedure CreatePinShow(PinLs: array of TPanel;
                             PinVariant:TStringList);override;
public
 Constructor Create(DAC:TDACR2R;
                     CPL:TPanel;
                     VData,KData:TStaticText;
                     VL,KL:TLabel;
                     VSB,KSB,RB:TButton;
                     PinVariant:TStringList);
end;


implementation

uses
  SysUtils, PacketParameters, OlegGraph, Math, Dialogs, ArduinoDeviceShow;


{ TDACR2R }

//function TDACR2R.VoltageToKod(Voltage: double): integer;
// var tempArrWord:TArrWord;
//     Index,AddIndex:integer;
//begin
// Result:=0;
// fOutPutValue:=Voltage;
// if TDACR2R_Calibr.VoltToKod(Voltage)=0 then Exit;
//
// tempArrWord:=fCalibration.VoltToArray(Voltage);
// if tempArrWord=nil then Exit;
// Index:=fCalibration.VoltToKodIndex(Voltage);
// AddIndex:=1;
// repeat
//   try
//    Result:=tempArrWord[Index];
//   except
//    Break;
//   end;
//   Index:=Index-AddIndex;
//   if AddIndex>0 then AddIndex:=AddIndex*(-1)
//                 else AddIndex:=abs(AddIndex)+1;
// until ((Result<>0)or
//        (Index<Low(tempArrWord))or
//        (Index>High(tempArrWord)));
// if Result=0 then Result:=TDACR2R_Calibr.VoltToKod(Voltage);
//end;


function TDACR2R.VoltageToKod(Voltage: double): integer;
 var tempArrWord:TStringList;
     Index,AddIndex:integer;
begin
 Result:=0;
 fOutPutValue:=Voltage;
 if TDACR2R_Calibr.VoltToKod(Voltage)=0 then Exit;

 tempArrWord:=fCalibration.VoltToArray(Voltage);
 if tempArrWord=nil then Exit;
 Index:=fCalibration.VoltToKodIndex(Voltage);
 AddIndex:=1;
 repeat
   try
    Result:=StrToInt(tempArrWord.Strings[Index]);
   except
    Break;
   end;
   Index:=Index-AddIndex;
   if AddIndex>0 then AddIndex:=AddIndex*(-1)
                 else AddIndex:=abs(AddIndex)+1;
 until ((Result<>0)or
        (Index<0)or
        (Index>=tempArrWord.Count));
 if Result=0 then Result:=TDACR2R_Calibr.VoltToKod(Voltage);
end;

procedure TDACR2R.OutputCalibr(Voltage: double);
begin
 OutputDataSignDetermination(Voltage);
 fOutputValue:=Voltage;
 DataByteToSendFromInteger(TDACR2R_Calibr.VoltToKod(Voltage));
 isNeededComPortState();
end;

procedure TDACR2R.PinsCreate;
begin
 Pins := TPins.Create(Name,1);
end;

procedure TDACR2R.PinsToDataArray;
begin
  fData[1] := Pins.PinControl;
  fData[2] := Pins.PinControl;
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


constructor TDACR2R.Create(CP:TComPort;Nm:string);
begin
  inherited Create(CP,Nm);
  fCalibration:=TDACR2R_Calibr.Create;
end;

procedure TDACR2R.CreateHook;
begin

  fVoltageMaxValue:=5;
  fKodMaxValue:=DACR2R_MaxValue;
  fMessageError:='DAC R2R output is unsuccessful';
  fSetterKod:=DACR2RCommand;
end;


procedure TDACR2R.Free;
begin
 fCalibration.Free;
 inherited Free;
end;

{ TDACR2RShow }

Constructor TDACR2RShow.Create(DAC:TDACR2R;
                     CPL:TPanel;
                     VData,KData:TStaticText;
                     VL,KL:TLabel;
                     VSB,KSB,RB:TButton;
                     PinVariant:TStringList);
begin
 inherited Create(DAC,[CPL],PinVariant,VData, KData, VL, KL, VSB, KSB, RB)
end;

//procedure TDACR2R_Calibr.Add(RequiredVoltage, RealVoltage: double);
// var tempArrWord:TArrWord;
//     Index:integer;
//begin
// tempArrWord:=Self.VoltToArray(RealVoltage);
// if tempArrWord=nil then Exit;
// Index:=VoltToKodIndex(RealVoltage);
// if (Index>=Low(tempArrWord))and
//    (Index<=High(tempArrWord)) then
//        tempArrWord[Index]:=VoltToKod(RequiredVoltage);
//end;

procedure TDACR2R_Calibr.Add(RequiredVoltage, RealVoltage: double);
 var tempArrWord:TStringList;
     Index:integer;
begin
 tempArrWord:=Self.VoltToArray(RealVoltage);
 if tempArrWord=nil then Exit;
 Index:=VoltToKodIndex(RealVoltage);
 if (Index>=0)and
    (Index<tempArrWord.Count) then
        tempArrWord.Strings[Index]:=IntToStr(VoltToKod(RequiredVoltage));
end;

//procedure TDACR2R_Calibr.AddWord(Index, Kod: word; Arr: TArrWord);
//begin
// if (Index<=High(Arr)) then Arr[Index]:=Kod;
//end;


constructor TDACR2R_Calibr.Create;
 var i:integer;
begin
 inherited Create;
// SetLength(pos01,10000);
// SetLength(neg01,10000);
// SetLength(pos16,5500);
// SetLength(neg16,5500);

// for I := Low(pos01) to High(pos01) do pos01[i]:=0;
// for I := Low(pos16) to High(pos16) do pos16[i]:=0;
// for I := Low(neg01) to High(neg01) do neg01[i]:=0;
// for I := Low(neg16) to High(neg16) do neg16[i]:=0;

// new(pos01);
// new(neg01);
// new(pos16);
// new(neg16);
//
// SetLength(pos01^,10000);
// SetLength(neg01^,10000);
// SetLength(pos16^,5500);
// SetLength(neg16^,5500);
//
// for I := Low(pos01^) to High(pos01^) do pos01^[i]:=0;
// for I := Low(pos16^) to High(pos16^) do pos16^[i]:=0;
// for I := Low(neg01^) to High(neg01^) do neg01^[i]:=0;
// for I := Low(neg16^) to High(neg16^) do neg16^[i]:=0;

 pos01:=TStringList.Create;
 neg01:=TStringList.Create;
 pos16:=TStringList.Create;;
 neg16:=TStringList.Create;;

 for I := 0 to 9999 do
   begin
    pos01.Add('0');
    neg01.Add('0');
   end;
 for I := 0 to 5499 do
   begin
    pos16.Add('0');
    neg16.Add('0');
   end;
end;

procedure TDACR2R_Calibr.Free;
begin
// dispose(pos01);
// dispose(neg01);
// dispose(pos16);
// dispose(neg16);
 pos01.Free;
 neg01.Free;
 pos16.Free;
 neg16.Free;
 end;

//procedure TDACR2R_Calibr.ReadFromFile(FileName: string; arr: TArrWord);
// var F:TextFile;
//     Index,Kod:word;
//begin
// if not(FileExists(FileName)) then Exit;
// AssignFile(f,FileName);
// Reset(f);
// while not(eof(f)) do
//    begin
//      readln(f,Index,Kod);
//      try
//        arr[Index]:=Kod;
//      finally
//
//      end;
//    end;
// CloseFile(f);
//end;

procedure TDACR2R_Calibr.ReadFromFile(FileName: string; arr: TStringList);
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
        arr.Strings[Index]:=IntToStr(Kod);
      finally

      end;
    end;
 CloseFile(f);
end;

procedure TDACR2R_Calibr.ReadFromFileData;
begin
// ReadFromFile('pos01.cvt',pos01);
// ReadFromFile('pos16.cvt',pos16);
// ReadFromFile('neg01.cvt',neg01);
// ReadFromFile('neg16.cvt',neg16);
// ReadFromFile('pos01.cvt',pos01^);
// ReadFromFile('pos16.cvt',pos16^);
// ReadFromFile('neg01.cvt',neg01^);
// ReadFromFile('neg16.cvt',neg16^);
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

//function TDACR2R_Calibr.VoltToArray(Volt: double): TArrWord;
//begin
// Result:=nil;
// if VoltToKod(Volt)=0 then Exit;
//// if (Volt>0)and(Volt<1.001) then Result:=Self.pos01;
//// if (Volt<0)and(Volt>-1.001) then Result:=Self.neg01;
//// if (Volt>=1.001) then Result:=Self.pos16;
//// if (Volt<=-1.001) then Result:=Self.neg16;
// if (Volt>0)and(Volt<1.001) then Result:=Self.pos01^;
// if (Volt<0)and(Volt>-1.001) then Result:=Self.neg01^;
// if (Volt>=1.001) then Result:=Self.pos16^;
// if (Volt<=-1.001) then Result:=Self.neg16^;
//end;

function TDACR2R_Calibr.VoltToArray(Volt: double): TStringList;
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

//procedure TDACR2R_Calibr.WriteToFile(FileName: string; arr: TArrWord);
// var i:integer;
//     Str:TStringList;
//begin
//  if High(arr)<0 then Exit;
//  Str:=TStringList.Create;
//  for I := 0 to High(arr) do
//    if arr[i]<>0 then
//      Str.Add(IntToStr(i)+' '+IntToStr(arr[i]));
//  Str.SaveToFile(FileName);
//  Str.Free;
//end;

procedure TDACR2R_Calibr.WriteToFile(FileName: string; arr: TStringList);
 var i:integer;
     Str:TStringList;
begin
  if arr.Count<0 then Exit;
  Str:=TStringList.Create;
  for I := 0 to arr.Count-1 do
    if arr.Strings[i]<>'0' then
      Str.Add(IntToStr(i)+' '+arr.Strings[i]);
  Str.SaveToFile(FileName);
  Str.Free;
end;

procedure TDACR2R_Calibr.WriteToFileData;
begin
// WriteToFile('pos01.cvt',pos01);
// WriteToFile('pos16.cvt',pos16);
// WriteToFile('neg01.cvt',neg01);
// WriteToFile('neg16.cvt',neg16);
// WriteToFile('pos01.cvt',pos01^);
// WriteToFile('pos16.cvt',pos16^);
// WriteToFile('neg01.cvt',neg01^);
// WriteToFile('neg16.cvt',neg16^);
 WriteToFile('pos01.cvt',pos01);
 WriteToFile('pos16.cvt',pos16);
 WriteToFile('neg01.cvt',neg01);
 WriteToFile('neg16.cvt',neg16);
end;


procedure TDACR2RShow.CreatePinShow(PinLs: array of TPanel;
                        PinVariant: TStringList);
begin
  PinShow:=TOnePinsShow.Create(fArduinoSetter.Pins,PinLs[0],PinVariant);
end;

end.
