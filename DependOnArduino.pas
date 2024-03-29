unit DependOnArduino;

interface

uses
  Dependence, ArduinoDeviceNew, PacketParameters, StdCtrls, Series, AD5752R, 
  ArduinoADC, INA226, ADS1115, MDevice;

const

 VoltageSourceNumber=2;

 VoltageSourceNames:array[1..VoltageSourceNumber]of string=
 ('AD5752chA','AD5753chB');

// VoltageSourceDevice:array[1..VoltageSourceNumber]of TAD5752_Chanel=
// (AD5752_chA,AD5752_chB);


 MeasurementDeviceNumber=9;

 MeasurementDeviceNames:array[1..MeasurementDeviceNumber]of string=
 ('INA226_Shunt','INA226_Bus',
 'ADS1115_Ch1','ADS1115_Ch2','ADS1115_Ch3',
 'MCP3424_Ch1','MCP3424_Ch2','MCP3424_Ch3','MCP3424_Ch4');

type

 TArdIVDepen=class(TArduinoMeter)
  private
   fFArdIVD:TFastIVDependence;

   procedure ClearData;
  protected
   procedure  PrepareData;override;
   function GetSecondDeviceKod:byte;override;
   procedure UpDate ();override;
  public
   Constructor Create(Nm:string;
                      FArdIVD:TFastIVDependence);
   Procedure ConvertToValue();override;
 end;

 TFastArduinoIVDependence=class (TFastIVDependence)
  private
   fVoltageMD:TArduinoADC_Channel;
   fCurrentMD:TArduinoADC_Channel;
   fArduinoCommunication:TArdIVDepen;
   fDAC:TAD5752_Chanel;
   function DataToSendPrepare:boolean;
   procedure DataToSendToStop;
   function BranchDataPrepare(IsForward:boolean):byte;
   {������� ������� ����������� � ����� ������}
   function VoltageValueToByte(Voltage:double; factor:byte=100):byte;
   {[Voltage]=�����,
    ������� �� ���������� - 1 ���� ����� ��'����;
    ������ 1 - [���������]=100 mV
           0 - [���������]=10 mV}
    function MDs_Determine:boolean;
    function MD_Determine(var MD:TArduinoADC_Channel;
                          TMD:TMeasuringDevice;
                          DeviceType:string=' '):boolean;
    function VS_Determine:boolean;
    function VoltageValuesDetermine:boolean;
    procedure LimitCurrentDetermine;
    procedure ConvertReceivedData(Data:TArrByte; var isError:boolean;
                                                 var IsEnd:boolean);
  public
   property ArduinoCommunication:TArdIVDepen read fArduinoCommunication;
   Constructor Create(
                     BS: TButton;
                     FLn,RLn,FLg,RLg:TPointSeries);

   procedure Measuring(SingleMeasurement:boolean=true;FilePrefix:string='');override;

 end;


var
 VoltageSourceDevice:array[1..VoltageSourceNumber]of TAD5752_Chanel;
 MeasurementDevice:array[1..MeasurementDeviceNumber]of TArduinoADC_Channel;

implementation

uses
  HighResolutionTimer, Dialogs, SysUtils, MCP3424u, OlegType;

{ TArdIVDepen }



procedure TArdIVDepen.ClearData;
begin
 CopyToData([ArduinoIVCommand,ArduinoIVCommand]);
end;

procedure TArdIVDepen.ConvertToValue;
 begin
 (fFArdIVD as TFastArduinoIVDependence).ConvertReceivedData(fData,fError,fIsReceived);

 if fIsReceived and not(fError) then  fValue:=0;

end;

constructor TArdIVDepen.Create(Nm: string;
                         FArdIVD: TFastIVDependence);
begin
  inherited Create(Nm);
  fFArdIVD:=FArdIVD;
  fDelayTimeMax:=1300;
  fMetterKod:=ArduinoIVCommand;
  ClearData;

end;

function TArdIVDepen.GetSecondDeviceKod: byte;
begin
 Result:=ArduinoIVCommand;
end;

//procedure TArdIVDepen.PacketCreateToSend;
//begin
// PacketCreate(fData);
//end;

procedure TArdIVDepen.PrepareData;
begin
end;

//procedure TArdIVDepen.SetTotalByteNumberInResult(const Value: integer);
//begin
//  FTotalByteNumberInResult := Value;
//end;

procedure TArdIVDepen.UpDate;
begin
  DataTransfer;
  ConvertToValue();
end;

{ TFastArduinoIVDependence }

function TFastArduinoIVDependence.BranchDataPrepare(IsForward: boolean):byte;
 var Finish,Step:double;
     StepByte,StepByteOld,CountStep:byte;
begin
 Result:=0;
 if IsForward then
     begin
     if not(CBForw.Checked) then  Exit
     end      else
     begin
     if not(CBRev.Checked) then  Exit
     end;

 CountStep:=0;
 StepByteOld:=0;
 if IsForward
  then
   begin
   fVoltageFactor:=fDiodOrientationVoltageFactor;
   fAbsVoltageValue:=RangeFor.LowValue;
   Finish:=RangeFor.HighValue;
   fArduinoCommunication.AddData(VoltageValueToByte(fAbsVoltageValue*fVoltageFactor));
   Step:=StepFromVector(ForwardDelV);

   end
  else
   begin
   fVoltageFactor:=-fDiodOrientationVoltageFactor;
   fAbsVoltageValue:=RangeRev.LowValue;
   Finish:=RangeRev.HighValue;
   Step:=StepFromVector(ReverseDelV);
   if (fAbsVoltageValue<>0)
      or(RangeFor.LowValue<>0)
      or(not(CBForw.Checked))
       then fArduinoCommunication.AddData(VoltageValueToByte(fAbsVoltageValue*fVoltageFactor))
       else fArduinoCommunication.AddData(VoltageValueToByte((fAbsVoltageValue+Step)*fVoltageFactor));
   end;

   StepByte:=VoltageValueToByte(Step*fVoltageFactor,100);
   fAbsVoltageValue:=fAbsVoltageValue+Step;

   while (round(fAbsVoltageValue*1000)<=round(Finish*1000)) do
     begin
      if StepByte<>StepByteOld then
        begin

         if CountStep>0
          then
          begin
           fArduinoCommunication.AddData(StepByteOld);
           fArduinoCommunication.AddData(CountStep);
           CountStep:=0;
           inc(Result);
          end;
         StepByteOld:=StepByte;
        end;
      inc(CountStep);
      if IsForward then Step:=StepFromVector(ForwardDelV)
                   else Step:=StepFromVector(ReverseDelV);
      StepByte:=VoltageValueToByte(Step*fVoltageFactor,100);
      fAbsVoltageValue:=fAbsVoltageValue+Step;
     end;
         if CountStep>0
          then
          begin
           fArduinoCommunication.AddData(StepByte);
           fArduinoCommunication.AddData(CountStep);
           inc(Result);
          end;
end;

procedure TFastArduinoIVDependence.ConvertReceivedData(Data: TArrByte;
                                 var isError, IsEnd: boolean);
 var TotalNumberByteInResult,i,k:integer;
begin
  if fMeasuringToStop then
   begin
    isError:=True;
    IsEnd:=True;
    DataToSendToStop;
    fArduinoCommunication.isNeededComPortState();
    Exit;
   end;


  k:=0;
  fVoltageMD.SetModuleParameters;
  fCurrentMD.SetModuleParameters;
  TotalNumberByteInResult:=fVoltageMD.ParentModule.NumberByteInResult
                          +fCurrentMD.ParentModule.NumberByteInResult;
 while((High(Data)-k)>=TotalNumberByteInResult) do
  begin
    fVoltageMD.ParentModule.HighDataIndex:=
    fVoltageMD.ParentModule.NumberByteInResult-1;
    for I := 0 to fVoltageMD.ParentModule.HighDataIndex do
       begin
        fVoltageMD.ParentModule.Data[i]:=Data[k];
        inc(k);
       end;
    fVoltageMD.ParentModule.ConvertToValue;
    fVoltageMeasured:=fVoltageMD.ParentModule.Value;

    fCurrentMD.ParentModule.HighDataIndex:=
        fCurrentMD.ParentModule.NumberByteInResult-1;
    for I := 0 to fCurrentMD.ParentModule.HighDataIndex do
       begin
        fCurrentMD.ParentModule.Data[i]:=Data[k];
        inc(k);
       end;
    fCurrentMD.ParentModule.ConvertToValue;
    fCurrentMeasured:=fCurrentMD.ParentModule.Value;

    if (fVoltageMeasured=ErResult)or(fCurrentMeasured=ErResult) then
      begin
       fMeasuringToStop:=true;
       isError:=True;
       IsEnd:=True;
       Exit;
      end;
    fVoltageMeasured:=fVoltageMeasured * fDiodOrientationVoltageFactor;
    fCurrentMeasured:=fCurrentMeasured * fDiodOrientationVoltageFactor;


    if FCurrentValueLimitEnable and (abs(fCurrentMeasured)<Imin)
        then  Continue;

    if Results.IsEmpty and CBForw.Checked then
         fItIsLightIV:=(fCurrentMeasured<-1e-5);


    Results.Add(fVoltageMeasured, fCurrentMeasured);

  end;

  if Data[k]=$EE
     then IsEnd:=True
     else if Data[k]=$BB
          then IsEnd:=False
          else begin
               IsEnd:=True;
               IsError:=True;
               end;
  

// NumberByteInResult:=

end;

constructor TFastArduinoIVDependence.Create(BS: TButton;
                         FLn, RLn, FLg, RLg: TPointSeries);
begin
 inherited Create(BS,FLn, RLn, FLg, RLg);
 fArduinoCommunication:=TArdIVDepen.Create('FastArduinoIV',Self);

 VoltageSourceDevice[1]:=AD5752_chA;
 VoltageSourceDevice[2]:=AD5752_chB;

 MeasurementDevice[1]:=INA226_Shunt;
 MeasurementDevice[2]:=INA226_Bus;
 MeasurementDevice[3]:=ADS11115_Channels[0];
 MeasurementDevice[4]:=ADS11115_Channels[1];
 MeasurementDevice[5]:=ADS11115_Channels[2];
 MeasurementDevice[6]:=MCP3424_Channels[0];
 MeasurementDevice[7]:=MCP3424_Channels[1];
 MeasurementDevice[8]:=MCP3424_Channels[2];
 MeasurementDevice[9]:=MCP3424_Channels[3];
end;

function TFastArduinoIVDependence.DataToSendPrepare:boolean;
 {1 ���� - ArduinoIVCommand
  2 ���� - ArduinoIVCommand
 3 - DragonBackTime []=ms
 ------------------------------
 ����, ���'������ � ���:
 �.1 - ������� ����, �� ������������� ��� ��� RESET
 ��� ���� ��������,
 ��� AD5752 ��
   AD5752Command, Pin, ����� ������ (0 �� 1),
   fDiapozon, 2 ����� �������� ������� (��� Reset $00 $00),
   �����  �.1 = 6
 ------------------------------------
 ���� ������� ������� �� ������� ����������
 �.1 - ������� ����������� � ����� ������
    ���� ������� ��� ���������� ����� ����
    (������ ������ ���, ����� ������� ����������� ��
    ����� 7) �� �������� (�������
    ������ ���)

  ��� ������� ����� ��� ����� ����, �� �����������
  ��.1 - ��������� �������� ������� (������ �� ��,
  ���������� - ����), []=10 mV,
  ��� ��������� ���� �����������, �� ����
  ��� ����� ���� ����� ��� 0 V, �� ��� �������� �� �����

   ��� ����� � ���� ����
   ������ - �������� ����� (������ �� ��,
   ���������� - ����), []=10 mV)
   ������ - ������� �����;

 �������� ��������� ������� �� ����� �����������
 � ����������� �������� ���� �� ���� ����,
 ����� � �������������� ������� ����� ����������� �������� �
 ���������� ���������� �� ���������
---------------------------------------------------------
  ����, ���'������ � ������������� ����������
  - �.1 - ������� ����� � ����� �� ���������� �
    Voltage Measure Device (������ ������ ���) ��
    � ������ � ������  (������� ������ ���)
  - �����  Voltage Measure Device

  - ������� ����� � ����� �� ���������� �
   Current Measure Device (������ ������ ���) ��
    � ������ � ������  (������� ������ ���)
  - �����  Current Measure Device

------------------------------------------
 ����, ���'������ � ����������� �� ������ (�������������)
 ���� �������� ���� - ���� ���������� ���� � $00
 ���� �:
   ������ ���� - ������� ���� � ������ Current Measure Device
   ��� - ��������� ������, ����   Current Measure Device
   ��������� ���� ������������� ������ ��� ����������
   ����� ���� �� ���������; ����� � ���� ����� ������
   ���������� �������� ����
 }
begin
 Result:=False;
 fArduinoCommunication.ClearData;
 fArduinoCommunication.AddData(byte(round(fDragonBackTime)));

 if not(VS_Determine) then Exit;


 if not(VoltageValuesDetermine) then Exit;

 if not(MDs_Determine) then Exit;

 LimitCurrentDetermine;




// fCurrentMD.ParentModule.ValueToByteArray(-1,BAr);

//  Showmessage(ByteArrayToString(BAr));

//  fCurrentMD.ParentModule.HighDataIndex:=High(BAr);
//  for I := 0 to High(BAr) do
//   fCurrentMD.ParentModule.Data[i]:=BAr[i];
//  fCurrentMD.ParentModule.ConvertToValue;
//  showmessage(floattostr(fCurrentMD.ParentModule.Value));

//  Showmessage(ByteArrayToString(fArduinoCommunication.fData));


  Result:=true;



end;

procedure TFastArduinoIVDependence.DataToSendToStop;
begin
 fArduinoCommunication.ClearData;
 fArduinoCommunication.AddData([$00,$00]);
end;

function TFastArduinoIVDependence.MDs_Determine: boolean;
 var i{,j}:integer;
begin
 Result:=False;

 if not(MD_Determine(fVoltageMD,Voltage_MD,'Voltage ')) then Exit;

 fArduinoCommunication.AddData(
   byte(byte(fVoltageMD.ParentModule.HighDataIndex+1) shl 4)
   + byte(fVoltageMD.ParentModule.NumberByteInResult and $0F));
// j:=fArduinoCommunication.HighDataIndex;

  for I := 0 to fVoltageMD.ParentModule.HighDataIndex do
   fArduinoCommunication.AddData(fVoltageMD.ParentModule.Data[i]);

// fArduinoCommunication.TotalByteNumberInResult:=fVoltageMD.ParentModule.HighDataIndex+1;

 if not(MD_Determine(fCurrentMD,Current_MD,'Current ')) then Exit;

 fArduinoCommunication.AddData(
   byte(byte(fCurrentMD.ParentModule.HighDataIndex+1) shl 4)
   + byte(fCurrentMD.ParentModule.NumberByteInResult and $0F));


 for I := 0 to fCurrentMD.ParentModule.HighDataIndex do
   fArduinoCommunication.AddData(fCurrentMD.ParentModule.Data[i]);

// fArduinoCommunication.Data[j]:=
//       fArduinoCommunication.Data[j]
//       +byte(fCurrentMD.ParentModule.HighDataIndex+1);

// fArduinoCommunication.TotalByteNumberInResult:=
//     fArduinoCommunication.TotalByteNumberInResult
//     +fCurrentMD.ParentModule.HighDataIndex+1;

 Result:=True;

end;

function TFastArduinoIVDependence.MD_Determine(var MD:TArduinoADC_Channel;
                  TMD:TMeasuringDevice;
                  DeviceType:string=' '): boolean;
 var i:byte;
begin
 Result:=False;

 MD:=nil;
 for i := 1 to MeasurementDeviceNumber do
  if TMD.ActiveInterface.Name=MeasurementDeviceNames[i]
   then
    begin
      MD:=MeasurementDevice[i];
      Break;
    end;

 if not(Assigned(MD)) then
  begin
   MessageDlg(DeviceType+'Measure Device is uncorrect',mtError, [mbOK], 0);
   Exit;
  end;

 MD.SetModuleParameters;
 MD.ParentModule.PrepareData;
 Result:=True;
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

  if fArduinoCommunication.GetData=0 then EndMeasuring();


end;

procedure TFastArduinoIVDependence.LimitCurrentDetermine;
var
  BAr: TArrByte;
begin
  if CurrentValueLimitEnable then
  begin
    fArduinoCommunication.AddData(fCurrentMD.ParentModule.NumberByteInResult);
    if CBForw.Checked then
    begin
      fCurrentMD.ParentModule.ValueToByteArray(abs(Imax) * fDiodOrientationVoltageFactor, BAr);
      fArduinoCommunication.AddData(BAr);
    end;
    if CBRev.Checked then
    begin
      fCurrentMD.ParentModule.ValueToByteArray(-abs(Imax) * fDiodOrientationVoltageFactor, BAr);
      fArduinoCommunication.AddData(BAr);
    end;
  end
  else
    fArduinoCommunication.AddData($0);
end;

function TFastArduinoIVDependence.VoltageValuesDetermine: boolean;
 var i:byte;
begin
 fArduinoCommunication.AddData(0);
 i:=fArduinoCommunication.HighDataIndex;
 fArduinoCommunication.fData[i]:=byte(BranchDataPrepare(True) shl 4)+
                                 byte(BranchDataPrepare(False));
 Result:=fArduinoCommunication.fData[i]<>0;
end;

function TFastArduinoIVDependence.VoltageValueToByte(Voltage:double; factor:byte=100): byte;
begin
  if abs(Voltage)>0.63
    then
     begin
     Result:=$3F and byte(round(abs(Voltage)*10));
     Result:=Result or $40;
     end
    else Result:=$3F and byte(round(abs(Voltage)*100));
  if Voltage<0 then Result:=Result or $80;
end;

function TFastArduinoIVDependence.VS_Determine: boolean;
 var i:integer;
begin
 Result:=False;
 fDAC:=nil;
 for i := 1 to VoltageSourceNumber do
  if SettingDevice.ActiveInterface.Name=VoltageSourceNames[i]
   then
    begin
      fDAC:=VoltageSourceDevice[i];
      Break;
    end;

 if not(Assigned(fDAC)) then
  begin
   MessageDlg('Voltage Source is uncorrect',mtError, [mbOK], 0);
   Exit;
  end;

 fDAC.DataToSendFromReset;
 fArduinoCommunication.AddData(fDAC.Modul.HighDataIndex+1);
 for I := 0 to fDAC.Modul.HighDataIndex do
     fArduinoCommunication.AddData(fDAC.Modul.Data[i]);

 Result:=True;
end;

end.
