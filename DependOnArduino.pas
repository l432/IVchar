unit DependOnArduino;

interface

uses
  Dependence, ArduinoDeviceNew, PacketParameters, StdCtrls, Series;


type

 TArdIVDepen=class(TArduinoMeter)
  private
   fFArdIVD:TFastIVDependence;
   procedure ClearData;
   procedure AddData(NewData:array of byte);overload;
   procedure AddData(NewByte:byte);overload;
  public
   Constructor Create(Nm:string;
                      FArdIVD:TFastIVDependence);
   procedure PacketCreateToSend();override;
   Procedure ConvertToValue();override;
 end;

 TFastArduinoIVDependence=class (TFastIVDependence)
  private
   fArduinoCommunication:TArdIVDepen;
   function DataToSendPrepare:boolean;
   function VoltageValueToByte(Voltage:double; factor:byte=10):byte;
   {[Voltage]=вольт,
   [результат]=100 mV якщо factor=10,
                10 mV якщо factor=100;
   перший біт вказує знак (1 - "-") }
  public
   Constructor Create(
                     BS: TButton;
                     FLn,RLn,FLg,RLg:TPointSeries);
   property ArduinoCommunication:TArdIVDepen read fArduinoCommunication;
   procedure Measuring(SingleMeasurement:boolean=true;FilePrefix:string='');override;

 end;





implementation

uses
  HighResolutionTimer, Dialogs, SysUtils;

{ TArdIVDepen }

procedure TArdIVDepen.AddData(NewData: array of byte);
 var i,j:integer;
begin
 j:=High(fData)+1;
 SetLength(fData,j+High(NewData)+1);
 for I := 0 to High(NewData) do
  fData[i+j]:= NewData [i];
end;

procedure TArdIVDepen.AddData(NewByte: byte);
begin
 AddData([NewByte]);
end;

procedure TArdIVDepen.ClearData;
begin
   SetLength(fData,1);
end;

procedure TArdIVDepen.ConvertToValue;
begin

end;

constructor TArdIVDepen.Create(Nm: string;
                         FArdIVD: TFastIVDependence);
begin
  inherited Create(Nm);
  fFArdIVD:=FArdIVD;
  fDelayTimeMax:=1300;
  fMetterKod:=ArduinoIVCommand;
  ClearData;
  fData[0]:=ArduinoIVCommand;
end;

procedure TArdIVDepen.PacketCreateToSend;
begin
 PacketCreate(fData);
end;

{ TFastArduinoIVDependence }

constructor TFastArduinoIVDependence.Create(BS: TButton;
                         FLn, RLn, FLg, RLg: TPointSeries);
begin
 inherited Create(BS,FLn, RLn, FLg, RLg);
 fArduinoCommunication:=TArdIVDepen.Create('FastArduinoIV',Self);
end;

function TFastArduinoIVDependence.DataToSendPrepare:boolean;
 var Finish,Step:double;
     StepByte,StepByteOld,CountStep:byte;
begin
 Result:=False;
 fArduinoCommunication.ClearData;
 fArduinoCommunication.AddData([byte(round(fDragonBackTime))]);
 fArduinoCommunication.AddData(SettingDevice.ActiveInterface.DeviceKod);

 if fArduinoCommunication.fData[2]=0 then
  begin
   MessageDlg('Voltage Source is uncorrect',mtError, [mbOK], 0);
   Exit;
  end;

 

 if CBForw.Checked then
  begin
    fAbsVoltageValue:=RangeFor.LowValue;
    fArduinoCommunication.AddData(VoltageValueToByte(fAbsVoltageValue*fDiodOrientationVoltageFactor));
    Finish:=RangeFor.HighValue;

    fItIsBranchBegining:=true;
    CountStep:=0;
    StepByteOld:=0;
    Step:=StepFromVector(ForwardDelV);
    fAbsVoltageValue:=fAbsVoltageValue+Step;


    while (round(fAbsVoltageValue*1000)<=round(Finish*1000)) do
     begin
      StepByte:=VoltageValueToByte(Step*fDiodOrientationVoltageFactor,100);
//      showmessage(inttostr(StepByte)+'  '+inttostr(StepByteOld));
      if StepByte<>StepByteOld then
        begin

         if CountStep>0
          then
          begin
           fArduinoCommunication.AddData(StepByteOld);
           fArduinoCommunication.AddData(CountStep);
           CountStep:=0;
          end;
         StepByteOld:=StepByte; 
        end;
      inc(CountStep);
      Step:=StepFromVector(ForwardDelV);
      fAbsVoltageValue:=fAbsVoltageValue+Step;
     end;
//       showmessage(floattostr(fAbsVoltageValue));
         if CountStep>0
          then
          begin
           fArduinoCommunication.AddData(StepByte);
           fArduinoCommunication.AddData(CountStep);
          end;

  end;

  Showmessage(ByteArrayToString(fArduinoCommunication.fData));
  Result:=true;
end;

procedure TFastArduinoIVDependence.Measuring(SingleMeasurement: boolean;
                                   FilePrefix: string);
begin
 if IVtiming then
  begin
   secondmeter.Start();
  end;

  fSingleMeasurement:=SingleMeasurement;
  PrefixToFileName:=FilePrefix;
  fVoc:=0;
  fIsc:=0;

  BeginMeasuring();

  if not(DataToSendPrepare) then Exit;

//  Cycle(True);
//  if fIVMeasuringToStop then Exit;
//  Cycle(False);
//  EndMeasuring();
end;

function TFastArduinoIVDependence.VoltageValueToByte(Voltage:double; factor:byte=10): byte;
begin
  Result:=$7F and byte(round(abs(Voltage)*factor));
  if Voltage<0 then Result:=Result or $80;
end;

end.
