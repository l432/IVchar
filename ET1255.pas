unit ET1255;

interface

uses
  Measurement, OlegType, Classes, OlegFunction, Spin, StdCtrls, 
  ExtCtrls, Buttons, Series, IniFiles, OlegTypePart2,
  OlegVector,OlegDigitalManipulation, ShowTypes;

const
 ET1255_DAC_MAX=2.5;
 ET1255_DAC_MIN=-2.5;
 ET1255_DAC_CodeMAX=4096;
 ET1255_DAC_CodeMIN=0;
 ET1255_DAC_CodeReset=2048;




function  ET_StartDrv: string; stdcall; external 'ET1255.dll';
{������� �������������� ��������� � ������ � ���������.
�����: ��������� �� ������. ���� ��� ���������, ������������ ������ ������.}
procedure ET_SetADCChnl(Chnl: word); stdcall; external 'ET1255.dll';
{��������� ������ �������� ������ ��� ������ ��� ����������� ������������ �������
Chnl - ����� ������.}
function  ET_ReadADC: single; stdcall; external 'ET1255.dll';
{������ ������ ��� � ������ ����������������� ������
�����:  ��������� ��������� � V.  }
procedure ET_SetScanMode(AChCount: integer; AScanEnable: boolean); stdcall; external 'ET1255.dll';
{��������� ������ ������������ 
 AChCount � ���������� ������� ������������;
 AScanEnable � ����� ������������: TRUE � ������������ ���������, FALSE - ���������}
function  ET_ReadMem: single; stdcall; external 'ET1255.dll';
{������ ������ ��� �� ��������� ���
�����:  ��������� ��������� � V. }
procedure ET_SetADCMode(AFrq: integer; APrgrmStart,
                 AIntTackt, AMemEnable: boolean); stdcall; external 'ET1255.dll';
{������� ������ ������ ��� 
AFrq � ��� ������� ������������, ������������ ��������� �������:
���  �������
������������, ���
0 8,33
1 4,17
2 2,08
3 1,04
APrgrmStart � ����� �������: TRUE � ���������������, FALSE � ����������;
AIntTackt � ����� ������������: TRUE � ����������, FALSE � �������;
AMemEnable � TRUE - ����� ������ � �������� �������;
             FALSE � ����� ����������������� ������.}
function  ET_MeasEnd: boolean; stdcall; external 'ET1255.dll';
{������ �������� ��������� ��������������
�����: TRUE � �������������� ���������, FALSE � �� ���������.}
procedure ET_SetStrob; stdcall; external 'ET1255.dll';
{������ ��� - ������������ ����� ������������ ������� ���. }
procedure ET_SetAddr(Addr: word); stdcall; external 'ET1255.dll';
{��������� ���������� ������ ������ ������ ��� � �������� ������
����: Addr � ���������� ������ ������ ������ ��� � �������� ������. }
procedure ET_SetAmplif(Value: word); stdcall; external 'ET1255.dll';
{��������� ������������ �������� �������� ���������
Value � ����������� �������� (����� � ��������� 1..15).}
procedure ET_WriteDAC(Value: single; Chnl: integer); stdcall; external 'ET1255.dll';
{����: Value � ����������� � ��� ��������;
 Chnl � ����� ������ ���.}
procedure ET_WriteDGT(Data: word); stdcall; external 'ET1255.dll';
{������ � �������� ����
 Data � ������������ ������. }
function  ET_ReadDGT: word; stdcall; external 'ET1255.dll';
{������ ��������� �����
�����:  ����������� ������. }
function  ET_WaitADC(AWait: integer): boolean; stdcall; external 'ET1255.dll';
function  ET_GetADCData: word; stdcall; external 'ET1255.dll';
function  ET_ErrMsg: string; stdcall; external 'ET1255.dll';
{�����:  ��������� �� ������. ��� ������ ���, ������������ ������ ������.
��������� ����� ���: �Error in <��� �������> = ��� ������. ������������� ��������� ��������� ��
������ ����� ������� ��������� � ���������� � �������� ����������. }


{���� � ���������� ����������� ���� ����� ET1255, ��� ��������� ��������� ������������ �� �����, ��
��������� ��������� ���� ������������� �� ������ � ����� ������. }
procedure ET_SetDeviceCount(ADevCount: integer); stdcall; external 'ET1255.dll';
{����: ADevCount � ���������� ���� ET1255, ������������� �� ����� ����������.
� �������� ������ ���������� ��������� ����� �����, � ������� �� �����������, ��� ����� �����������
���������: ET_SetDeviceNumber}
procedure ET_SetDeviceNumber(ADevn: integer); stdcall; external 'ET1255.dll';
{����: ADevn � ���������� ����� ����� � ������ ����������, ��������� ���������� � 0}

var
    EventET1255Measurement_Done: THandle;


type

 TET1255_DAC_ChanelNumber=0..3;
 TET1255_ADC_ChanelNumber=0..7;
 TET1255_ADC_Gain=1..15;
 TET1255_Frequency_Tackt=(mhz833,mhz417,mhz208, mhz104);

const
 TET1255_Frequency_Tackt_Label:array[TET1255_Frequency_Tackt]of string=
   ('8.33','4.17','2.08', '1.04');

 ET1255IniSectionName='ET1255ADC';


type
 TET1255_Measuring_Thead = class(TThread)
  protected
  public
    constructor Create;
    procedure Execute; override;
  end;

 TET1255_Module=class(TSimpleFreeAndAiniObject)
  private
    FStartByProgr: boolean;
    FActiveChannel: TET1255_ADC_ChanelNumber;
    FFrequency_Tackt: TET1255_Frequency_Tackt;
    FMemEnable: boolean;
    FGain: TET1255_ADC_Gain;
    FInternalTacktMode: boolean;
    FNoErrorOperation: boolean;
    fMeasThead:TET1255_Measuring_Thead;
    fToAverageSerialResults:boolean;
    fAutoGain:boolean;
    function NoError():boolean;
  public
  property ErrorOperation:boolean read FNoErrorOperation;
  function SetGain(const Value: TET1255_ADC_Gain;const ToCheck:boolean=True):boolean;
  function Gain:TET1255_ADC_Gain;
  function SetActiveChannel(const Value: TET1255_ADC_ChanelNumber;const ToCheck:boolean=True):boolean;
  function ActiveChannel:TET1255_ADC_ChanelNumber;
  function SetFrequency_Tackt(const Value: TET1255_Frequency_Tackt;const ToCheck:boolean=True):boolean;
  function Frequency_Tackt:TET1255_Frequency_Tackt;
  function SetMemEnable(const Value: boolean;const ToCheck:boolean=True):boolean;
  function MemEnable:boolean;
  function SetStartByProgr(const Value: boolean;const ToCheck:boolean=True):boolean;
  function StartByProgr:boolean;
  function SetInternalTacktMode(const Value: boolean;const ToCheck:boolean=True):boolean;
  function InternalTacktMode:boolean;
  function SetADCMode(FrT: TET1255_Frequency_Tackt;StBPr, IntTMd, MemE: boolean;
                               const ToCheck:boolean=True): boolean;
  constructor Create();
  function MeasuringStart():boolean;
  procedure MeasuringStop();
  function SetAddr(Addr: word):boolean;
  function ReadADC():double;
  function ReadMem():double;
 end;

TET1255_ADCChannel=class(TNamedInterfacedObject,IMeasurement)
 private
  fValue:double;
  fET1255MeasuringTread:TThread;
  fNewData:boolean;
  fChanelNumber: TET1255_ADC_ChanelNumber;
  fParentModule:TET1255_Module;
  FSerialMeasurements: boolean;
  FSerialMeasurementNumber: byte;
  fToAverageSerialResults:boolean;
  fAutoGain:boolean;
  fMeasuringIsDone:boolean;
  fAveraveNumber:byte;
  fHelpDataVector:TVector;
  fReadyToMeasurement:boolean;
  function GetNewData:boolean;
  function GetValue:double;
  procedure SetNewData(Value:boolean);
  function Measurement():double;
  procedure SetSerialMeasurements(const Value: boolean);
  procedure SetSerialMeasurementNumber(const Value: byte);
  procedure AverageValueCalculation;
  function DataCalibration(DataMeasured:double):double;
  function GetDeviceKod:byte;
 public
  DataVector:TVector;
  property NewData:boolean read GetNewData write SetNewData;
  property Value:double read GetValue;
  property SerialMeasurements:boolean read FSerialMeasurements write SetSerialMeasurements;
  property SerialMeasurementNumber:byte read FSerialMeasurementNumber write SetSerialMeasurementNumber;
  function GetData:double;
  constructor Create(ChanelNumber:TET1255_ADC_ChanelNumber;
                     ET1255_Module:TET1255_Module);
//  procedure Free;//override;
  destructor Destroy; override;
  function SetGain(Value: TET1255_ADC_Gain):boolean;
  function SetFrequency_Takt(const Value: TET1255_Frequency_Tackt):boolean;
  function MeasuringStart():boolean;
  procedure MeasuringStop;
  procedure ValueInitialization;
  procedure PrepareToMeasurementPart1;
  procedure PrepareToMeasurementPart2;
  procedure ResultRead();
  procedure GetDataThread(WPARAM: word;EventEnd:THandle);
  procedure WriteToIniFile(ConfigFile: TIniFile);override;
  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
end;

  TET1255_Chanel_MeasuringTread = class(TMeasuringTreadSleep)
  private
   fET1255_Chan:TET1255_ADCChannel;
   procedure ValueInitialization;
   procedure ResultRead;
  protected
   procedure ExuteBegin;override;
  public
   constructor Create(ET1255_Chan:TET1255_ADCChannel;WPARAM: word; EventEnd: THandle);
  end;

 TET1255_ModuleAndChan=class(TET1255_Module,IMeasurement)
  private
   function GetNewData:boolean;
   function GetValue:double;
   procedure SetNewData(Value:boolean);
   function GetName:string;
   function GetDeviceKod:byte;
  public
   Channels:array[TET1255_ADC_ChanelNumber] of TET1255_ADCChannel;
   property NewData:boolean read GetNewData write SetNewData;
   property Value:double read GetValue;
   property Name:string read GetName;
   constructor Create();
   function GetData:double;
   procedure GetDataThread(WPARAM: word; EventEnd:THandle);
//   procedure Free;//override;
   destructor Destroy; override;
   procedure WriteToIniFile(ConfigFile: TIniFile);override;
   procedure ReadFromIniFile(ConfigFile:TIniFile);override;
 end;

 TET1255_ADCShow=class(TMeasurementShow)
  private
   ET1255_ModuleAndChan:TET1255_ModuleAndChan;
   SEGain:TSpinEdit;
   SEMeasurementNumber:TSpinEdit;
   CBSerial:TCheckBox;
   CBAverageSerial:TCheckBox;
   CBAutoGain:TCheckBox;
   Graph: TCustomSeries;
   procedure ElementFill();
   procedure GroupChannelsClick(Sender: TObject);
   procedure GroupFrequencyClick(Sender: TObject);
   procedure CBSerialClick(Sender: TObject);
   procedure CBAverageSerialClick(Sender: TObject);
   procedure CBAutoGainClick(Sender: TObject);
   procedure SEMNChange(Sender: TObject);
   procedure SEGainChange(Sender: TObject);
   procedure FromActiveChannelToVisualElement;
   procedure FromET1255ToVisualElement;
 protected
   function UnitModeLabel():string;override;
  public
   Constructor Create(ET1255:TET1255_ModuleAndChan;
                      MM,R:TRadioGroup;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      TT:TTimer;
                      SEG,SEMN:TSpinEdit;
                      CBSer,CBToAv,CBAuG:TCheckBox;
                      Gr: TCustomSeries
                      );
    procedure MetterDataShow();override;
 end;

 TET1255_DAC=class(TNamedInterfacedObject,IDAC,ISource)
 private
  fChanelNumber:TET1255_DAC_ChanelNumber;
  fOutputValue:double;
  Procedure ShowError();
  function GetOutputValue:double;
  function GetDACKod:byte;
 public
   property OutputValue:double read GetOutputValue;
   procedure Output(Value:double);//virtual;
   procedure OutputInt(Kod:integer); //virtual;
   Procedure Reset();    // virtual;
   Constructor Create(ChanelNumber:TET1255_DAC_ChanelNumber);
   procedure Free;//override;
 end;

//var
//    ET1255_DACs:array[TET1255_DAC_ChanelNumber] of TET1255_DAC;
//    ET1255_DACsShow:array[TET1255_DAC_ChanelNumber] of TDAC_Show;
//    ET1255isPresent:boolean;
//    ET1255_ADCModule:TET1255_ModuleAndChan;
//    ET1255_ADCShow:TET1255_ADCShow;

implementation

uses
  Dialogs, SysUtils, Windows, Forms, OlegGraph, OlegMath,
  HighResolutionTimer;

{ TET1255_DAC }


constructor TET1255_DAC.Create(ChanelNumber: TET1255_DAC_ChanelNumber);
begin
 inherited Create;
 fChanelNumber:=ChanelNumber;
 fName:='ET1255_Ch'+inttostr(ord(ChanelNumber))+'DAC';
end;


procedure TET1255_DAC.Free;
begin
  Reset();
end;

function TET1255_DAC.GetDACKod: byte;
begin
 Result:=0;
end;

function TET1255_DAC.GetOutputValue: double;
begin
 Result:=fOutputValue;
end;

procedure TET1255_DAC.Output(Value: double);
 var tempValue:double;
begin
 if Value=ErResult then Exit;

 if Value>ET1255_DAC_MAX
    then tempValue:=ET1255_DAC_MAX
    else if Value<ET1255_DAC_MIN
            then tempValue:=ET1255_DAC_MIN
            else tempValue:=Value;
 fOutputValue:=tempValue;
 ET_WriteDAC(tempValue,fChanelNumber);
 ShowError();
end;


procedure TET1255_DAC.OutputInt(Kod: integer);
begin
 if Kod=ET1255_DAC_CodeReset then
   begin
    Reset();
    Exit;
   end;
 if Kod>ET1255_DAC_CodeMAX then Kod:=ET1255_DAC_CodeMAX;
 if Kod<ET1255_DAC_CodeMIN then Kod:=ET1255_DAC_CodeMIN;

 if Kod>ET1255_DAC_CodeReset then
    Output(ET1255_DAC_MAX*(Kod-ET1255_DAC_CodeReset)/(ET1255_DAC_CodeMAX-ET1255_DAC_CodeReset))
                             else
    Output(ET1255_DAC_MIN*(ET1255_DAC_CodeReset-Kod)/(ET1255_DAC_CodeReset-ET1255_DAC_CodeMIN));
end;

procedure TET1255_DAC.Reset;
begin
  Output(0);
end;

procedure TET1255_DAC.ShowError;
 var str:string;
begin
 str:=ET_ErrMsg;
 if str<>'' then
   showmessage(str);
end;

{ TET1255_Module }

function TET1255_Module.ActiveChannel: TET1255_ADC_ChanelNumber;
begin
 Result:=FActiveChannel;
end;

constructor TET1255_Module.Create;
begin
 inherited Create;
 FNoErrorOperation:=False;
// ++++++++++++++++++++++++++
 if (not(SetActiveChannel(0,False)))
    or (not(SetGain(1,False)))
    or (not(SetADCMode(mhz104,True,True,False,False)))
     then showmessage('ET1255 initial parameters are NOT setted');

//++++++++++++++++++++++++++++
 fToAverageSerialResults:=False;
 fAutoGain:=False;
end;

function TET1255_Module.Frequency_Tackt: TET1255_Frequency_Tackt;
begin
 Result:=FFrequency_Tackt;
end;

function TET1255_Module.Gain: TET1255_ADC_Gain;
begin
 Result:=FGain;
end;

function TET1255_Module.InternalTacktMode: boolean;
begin
 Result:=FInternalTacktMode;
end;

function TET1255_Module.MeasuringStart;
begin
 ResetEvent(EventET1255Measurement_Done);
 fMeasThead:=TET1255_Measuring_Thead.Create();

 result:=true;
end;

procedure TET1255_Module.MeasuringStop;
begin
 if assigned(fMeasThead) then   fMeasThead.Terminate;
end;

function TET1255_Module.MemEnable: boolean;
begin
 Result:=FMemEnable;
end;

function TET1255_Module.NoError: boolean;
 var str:string;
begin
  str:=ET_ErrMsg;
  if str<>''
   then
    begin
    showmessage(str);
    Result:=False;
    end
   else
    Result:=True;
 FNoErrorOperation:=Result;
end;

function TET1255_Module.ReadADC(): double;
begin
 Result:=ET_ReadADC+2.5;
 if not(NoError()) then Result:=ErResult;
end;

function TET1255_Module.ReadMem: double;
begin
 Result:=ET_ReadMem+2.5;
 if not(NoError()) then Result:=ErResult;
end;

function TET1255_Module.SetActiveChannel(
             const Value: TET1255_ADC_ChanelNumber;
             const ToCheck:boolean=True):boolean;
begin
  if ToCheck and (Value=FActiveChannel) then  Result:=True
                                        else
    begin
      ET_SetADCChnl(Value);
      if NoError() then FActiveChannel := Value;
      Result:=FNoErrorOperation;
    end;
end;

function TET1255_Module.SetADCMode(FrT: TET1255_Frequency_Tackt;StBPr, IntTMd, MemE: boolean;
                 const ToCheck:boolean=True): boolean;
begin
  if ToCheck and (FFrequency_Tackt=FrT)
     and (FStartByProgr=StBPr) and (FInternalTacktMode=IntTMd)
     and(FMemEnable=MemE) then Result:=True
                          else
   begin
      ET_SetADCMode(ord(FrT), StBPr, IntTMd, MemE);
      if NoError() then
        begin
         FFrequency_Tackt := FrT;
         FStartByProgr:=StBPr;
         FInternalTacktMode:=IntTMd;
         FMemEnable:=MemE;
        end;
      Result:=FNoErrorOperation;
   end;
end;

function TET1255_Module.SetAddr(Addr: word): boolean;
begin
 ET_SetAddr(Addr);
 Result:=NoError();
end;

function TET1255_Module.SetFrequency_Tackt(const Value: TET1255_Frequency_Tackt;
                                           const ToCheck:boolean=True):boolean;
begin
  if ToCheck and (Value=FFrequency_Tackt) then Result:=True
                                          else
    begin
      ET_SetADCMode(ord(Value), FStartByProgr, FInternalTacktMode, FMemEnable);
      if NoError() then FFrequency_Tackt := Value;
      Result:=FNoErrorOperation;
    end;
end;

function TET1255_Module.SetGain(const Value: TET1255_ADC_Gain;const ToCheck:boolean=True):boolean;
begin
  if ToCheck and (Value=FGain) then Result:=True
                               else
    begin
      ET_SetAmplif(Value);
      if NoError() then FGain := Value;
      Result:=FNoErrorOperation;
    end;
end;

function TET1255_Module.SetMemEnable(const Value: boolean;
                                     const ToCheck:boolean=True):boolean;
begin
  if ToCheck and (Value=FMemEnable) then Result:=True
                                    else
    begin
      ET_SetADCMode(ord(FFrequency_Tackt), FStartByProgr, FInternalTacktMode, Value);
      if NoError() then FMemEnable := Value;
      Result:=FNoErrorOperation;
    end;
end;

function TET1255_Module.SetStartByProgr(const Value: boolean;
                                        const ToCheck:boolean=True): boolean;
begin
  if ToCheck and (Value=FStartByProgr) then Result:=True
                                    else
    begin
      ET_SetADCMode(ord(FFrequency_Tackt), Value, FInternalTacktMode, FMemEnable);
      if NoError() then FStartByProgr := Value;
      Result:=FNoErrorOperation;
    end;
end;

function TET1255_Module.StartByProgr: boolean;
begin
 Result:=FStartByProgr;
end;

function TET1255_Module.SetInternalTacktMode(const Value: boolean;
                                             const ToCheck:boolean=True): boolean;
begin
  if ToCheck and (Value=FInternalTacktMode) then Result:=True
                                            else
    begin
      ET_SetADCMode(ord(FFrequency_Tackt), FStartByProgr, Value, FMemEnable);
      if NoError() then FInternalTacktMode := Value;
      Result:=FNoErrorOperation;
    end;
end;



{ TET1255_ADCChannel }

constructor TET1255_ADCChannel.Create(ChanelNumber: TET1255_ADC_ChanelNumber;
                                      ET1255_Module: TET1255_Module);
begin
 inherited Create;
 fChanelNumber:=ChanelNumber;
 fName:='ET1255_Ch'+inttostr(ord(ChanelNumber))+'ADC';
 fParentModule:=ET1255_Module;
 DataVector:=TVector.Create;
 FSerialMeasurements:=False;
 FSerialMeasurementNumber:=0;
end;

function TET1255_ADCChannel.DataCalibration(DataMeasured: double): double;
 const
  Single_CalibrA:array[TET1255_ADC_Gain]of double=
    (0,-9.1E-4,-0.001308,-0.00163,
    -0.00163,-0.00163,-0.00163,-0.00163,
    -0.00163,-0.00163,-0.00163,-0.00163,
    -0.00163,-0.00163,-0.00163);
  Single_CalibrB:array[TET1255_ADC_Gain]of double=
    (1.00761,1.0128,1.01225,1.012654,
    1.012654,1.012654,1.012654,1.012654,
    1.012654,1.012654,1.012654,1.012654,
    1.012654,1.012654,1.012654);
  Serial_CalibrA:array[TET1255_ADC_Gain]of double=
    (0,0,-2.44E-4,-4.778E-4,
    -4.778E-4,-4.778E-4,-4.778E-4,-4.778E-4,
    -4.778E-4,-4.778E-4,-4.778E-4,-4.778E-4,
    -4.778E-4,-4.778E-4,-4.778E-4);
  Serial_CalibrB:array[TET1255_ADC_Gain]of double=
    (1.010206,1.01409,1.01234,1.01256,
    1.01256,1.01256,1.01256,1.01256,
    1.01256,1.01256,1.01256,1.01256,
    1.01256,1.01256,1.01256);
  SerialLong_CalibrA:array[TET1255_ADC_Gain]of double=
    (0,0,-5.66E-4,-7.95E-4,
    -7.95E-4,-7.95E-4,-7.95E-4,-7.95E-4,
    -7.95E-4,-7.95E-4,-7.95E-4,-7.95E-4,
    -7.95E-4,-7.95E-4,-7.95E-4);
  SerialLong_CalibrB:array[TET1255_ADC_Gain]of double=
    (1.0096,1.01359,1.01225,1.01253,
    1.01253,1.01253,1.01253,1.01253,
    1.01253,1.01253,1.01253,1.01253,
    1.01253,1.01253,1.01253);
begin
 if FSerialMeasurements then
   begin
    if FSerialMeasurementNumber>1
      then Result:=Linear(SerialLong_CalibrA[fParentModule.Gain],
                          SerialLong_CalibrB[fParentModule.Gain],
                          DataMeasured)
      else Result:=Linear(Serial_CalibrA[fParentModule.Gain],
                          Serial_CalibrB[fParentModule.Gain],
                          DataMeasured)
   end                  else
   Result:=Linear(Single_CalibrA[fParentModule.Gain],
                  Single_CalibrB[fParentModule.Gain],
                  DataMeasured);
end;

destructor TET1255_ADCChannel.Destroy;
begin
  DataVector.Free;
  inherited;
end;

//procedure TET1255_ADCChannel.Free;
//begin
// DataVector.Free;
// inherited Free;
//end;

function TET1255_ADCChannel.GetData: double;
begin
 Result:=Measurement();
 fNewData:=True;
end;

procedure TET1255_ADCChannel.GetDataThread(WPARAM: word; EventEnd: THandle);
begin
 fET1255MeasuringTread:=
   TET1255_Chanel_MeasuringTread.Create(Self,WPARAM,EventEnd);
end;


function TET1255_ADCChannel.GetDeviceKod: byte;
begin
 Result:=0;
end;

function TET1255_ADCChannel.GetNewData: boolean;
begin
  Result:=fNewData;
end;

function TET1255_ADCChannel.GetValue: double;
begin
  Result:=fValue;
end;

function TET1255_ADCChannel.Measurement: double;
begin


 PrepareToMeasurementPart1();
 ValueInitialization();
 Result:=fValue;

 fMeasuringIsDone:=False;
 fAveraveNumber:=0;
 if not(fReadyToMeasurement) then Exit;


 repeat
   PrepareToMeasurementPart2();
   if not(fReadyToMeasurement) then Exit;

   if MeasuringStart() then
    if WaitForSingleObject(EventET1255Measurement_Done,1500)=WAIT_OBJECT_0
     then
     begin
           ResultRead();
     end
     else  MeasuringStop;
  until fMeasuringIsDone;
 Result:=fValue;
end;

function TET1255_ADCChannel.MeasuringStart: boolean;
begin
 Result:=fParentModule.MeasuringStart;
end;

procedure TET1255_ADCChannel.MeasuringStop;
begin
  fParentModule.MeasuringStop;
  fMeasuringIsDone:=True;
  if fAveraveNumber>0 then fHelpDataVector.Free;
end;

procedure TET1255_ADCChannel.PrepareToMeasurementPart1;
begin
  fReadyToMeasurement:=false;
  if not(fParentModule.SetActiveChannel(fChanelNumber))
   then Exit;
  if not(fParentModule.SetMemEnable(FSerialMeasurements))
   then Exit;

  fParentModule.fAutoGain:=fAutoGain;
  fReadyToMeasurement:=true;
end;

procedure TET1255_ADCChannel.PrepareToMeasurementPart2;
begin
  fReadyToMeasurement:=false;
  if FSerialMeasurements then
   begin
    if not(fParentModule.SetAddr($FF-FSerialMeasurementNumber))
     then Exit;
    fParentModule.fToAverageSerialResults:=fToAverageSerialResults;
   end;
  fReadyToMeasurement:=true;
end;

procedure TET1255_ADCChannel.ReadFromIniFile(ConfigFile: TIniFile);
begin
  SerialMeasurements:=ConfigFile.ReadBool(Name, 'SerialMeasurements', False);
  SerialMeasurementNumber:=ConfigFile.ReadInteger(Name, 'SerialMeasurementsNum', 1);
  fToAverageSerialResults:=ConfigFile.ReadBool(Name, 'ToAverageSerialResults', False);
  fAutoGain:=ConfigFile.ReadBool(Name, 'AutoGain', False);
end;

procedure TET1255_ADCChannel.AverageValueCalculation;
 var Filtr:TVDigitalManipulation;
begin
  if (abs(DataVector.MeanY-DataVector.MaxY)>=0.004)or
     (abs(DataVector.MeanY-DataVector.MinY)>=0.004)
         then
       begin
         inc(fAveraveNumber);
         if fAveraveNumber=1 then
           begin
             fHelpDataVector:=TVector.Create;
             DataVector.CopyTo(fHelpDataVector);
             Exit;
           end;
         if (fAveraveNumber>1)and(fAveraveNumber<10)  then
           begin
             DataVector.MultiplyY(-1);
             fHelpDataVector.DeltaY(DataVector);
             Exit;
           end;
          DataVector.MultiplyY(-1);
          fHelpDataVector.DeltaY(DataVector);
          fHelpDataVector.MultiplyY(1/fAveraveNumber);
          Filtr:=TVDigitalManipulation.Create(fHelpDataVector);

       end
         else Filtr:=TVDigitalManipulation.Create(DataVector);


//   Filtr.DataVector.Write_File(inttostr(Millisecond)+'.dat');


//  Filtr.Decimation(50);
//  Filtr.MovingAverageFilter(50,true);
//  _____________________
//  Filtr.Decimation(20);
////  Filtr.LP_UniformIIRfilter4k(0.025,true);
//  Filtr.LP_IIR_Chebyshev0025p2(true);
  Filtr.Decimation(10);
  Filtr.LP_IIR_Chebyshev0025p2(true);


//_________________________


  fValue := ImpulseNoiseSmoothing(Filtr);
  fMeasuringIsDone:=true;
  Filtr.Free;
  if fAveraveNumber>0 then fHelpDataVector.Free;
end;

procedure TET1255_ADCChannel.ResultRead;
 var i:Cardinal;
begin
 if FSerialMeasurements
  then
   begin
    if not(fParentModule.SetAddr($FF-FSerialMeasurementNumber))
      then Exit;
     for I := 0 to DataVector.HighNumber do
      begin
       DataVector.X[i]:=i;
//       DataVector^.Y[i]:=fParentModule.ReadMem/fParentModule.Gain;
       DataVector.Y[i]:=DataCalibration(fParentModule.ReadMem/fParentModule.Gain);
      end;
    if fToAverageSerialResults then AverageValueCalculation
                               else
         begin
           fValue:=DataVector.Y[0];
           fMeasuringIsDone:=True;
         end;

   end
  else
   begin
//    fValue:=fParentModule.ReadADC;
//    fValue:=fValue/fParentModule.Gain;
    fValue:=DataCalibration(fParentModule.ReadADC/fParentModule.Gain);
    DataVector.X[0]:=0;
    DataVector.Y[0]:=fValue;
    fMeasuringIsDone:=True;
   end;
end;

function TET1255_ADCChannel.SetFrequency_Takt(
  const Value: TET1255_Frequency_Tackt):boolean;
begin
 Result:=fParentModule.SetFrequency_Tackt(Value);
end;

function TET1255_ADCChannel.SetGain(Value: TET1255_ADC_Gain):boolean;
begin
 Result:=fParentModule.SetGain(Value);
end;


procedure TET1255_ADCChannel.SetNewData(Value: boolean);
begin
  fNewData:=Value;
end;

procedure TET1255_ADCChannel.SetSerialMeasurementNumber(const Value: byte);
begin
  FSerialMeasurementNumber := Value;
end;

procedure TET1255_ADCChannel.SetSerialMeasurements(const Value: boolean);
begin
  FSerialMeasurements := Value;
end;

procedure TET1255_ADCChannel.ValueInitialization;
begin
  fValue:=ErResult;
  if FSerialMeasurements
//   then  SetLenVector(DataVector,(FSerialMeasurementNumber shl 12))
   then  DataVector.SetLenVector((FSerialMeasurementNumber shl 11))
   else DataVector.SetLenVector(1);
end;

procedure TET1255_ADCChannel.WriteToIniFile(ConfigFile: TIniFile);
begin
  ConfigFile.EraseSection(Name);
  WriteIniDef(ConfigFile,Name,'SerialMeasurements', SerialMeasurements);
  WriteIniDef(ConfigFile,Name,'SerialMeasurementsNum',  SerialMeasurementNumber);
  WriteIniDef(ConfigFile,Name,'ToAverageSerialResults', fToAverageSerialResults);
  WriteIniDef(ConfigFile,Name,'AutoGain',  fAutoGain);
end;

{ TET1255_Measuring_Thead }

constructor TET1255_Measuring_Thead.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  Self.Priority := tpNormal;
  Resume;
end;

procedure TET1255_Measuring_Thead.Execute;
begin
  ET_SetStrob;

  repeat
  until Terminated or Application.Terminated or ET_MeasEnd;
  SetEvent(EventET1255Measurement_Done);

end;

{ TET1255_MeasuringTread }

constructor TET1255_Chanel_MeasuringTread.Create(ET1255_Chan: TET1255_ADCChannel;
  WPARAM: word; EventEnd: THandle);
begin
  inherited Create(ET1255_Chan,WPARAM,EventEnd);
  fET1255_Chan := ET1255_Chan;
  fMeasurement:=fET1255_Chan;
  Resume;
end;

procedure TET1255_Chanel_MeasuringTread.ExuteBegin;
begin
 fET1255_Chan.PrepareToMeasurementPart1();
 Synchronize(ValueInitialization);
 if fET1255_Chan.MeasuringStart() then
//  if WaitForSingleObject(EventComPortFree,1500)=WAIT_OBJECT_0
  if WaitForSingleObject(EventET1255Measurement_Done,1500)=WAIT_OBJECT_0
   then  Synchronize(ResultRead)
   else  fET1255_Chan.MeasuringStop;
end;

procedure TET1255_Chanel_MeasuringTread.ResultRead;
begin
 fET1255_Chan.ResultRead
end;

procedure TET1255_Chanel_MeasuringTread.ValueInitialization;
begin
 fET1255_Chan.ValueInitialization();
end;

{ TET1255_ModuleAndChan }

constructor TET1255_ModuleAndChan.Create;
 var i:TET1255_ADC_ChanelNumber;
begin
  inherited Create();
  for I := Low(TET1255_ADC_ChanelNumber) to High(TET1255_ADC_ChanelNumber) do
    Channels[i]:=TET1255_ADCChannel.Create(i,Self);
end;

destructor TET1255_ModuleAndChan.Destroy;
 var i:TET1255_ADC_ChanelNumber;
begin
  for I := Low(TET1255_ADC_ChanelNumber) to High(TET1255_ADC_ChanelNumber)
     do Channels[i].Free;
  inherited;
end;

//procedure TET1255_ModuleAndChan.Free;
// var i:TET1255_ADC_ChanelNumber;
//begin
//  for I := Low(TET1255_ADC_ChanelNumber) to High(TET1255_ADC_ChanelNumber)
//     do Channels[i].Free;
//end;

function TET1255_ModuleAndChan.GetData: double;
begin
 Result:=Channels[ActiveChannel].GetData;
end;

procedure TET1255_ModuleAndChan.GetDataThread(WPARAM: word; EventEnd: THandle);
begin
 Channels[ActiveChannel].GetDataThread(WPARAM,EventEnd);
end;

function TET1255_ModuleAndChan.GetDeviceKod: byte;
begin
 Result:=0;
end;

function TET1255_ModuleAndChan.GetName: string;
begin
 Result:=Channels[ActiveChannel].Name;
end;

function TET1255_ModuleAndChan.GetNewData: boolean;
begin
  Result:=Channels[ActiveChannel].GetNewData;
end;

function TET1255_ModuleAndChan.GetValue: double;
begin
  Result:=Channels[ActiveChannel].GetValue;
end;

procedure TET1255_ModuleAndChan.ReadFromIniFile(ConfigFile: TIniFile);
 var i:TET1255_ADC_ChanelNumber;
begin
  for I := Low(TET1255_ADC_ChanelNumber) to High(TET1255_ADC_ChanelNumber) do
    Channels[i].ReadFromIniFile(ConfigFile);

  SetActiveChannel(TET1255_ADC_ChanelNumber(
                    ConfigFile.ReadInteger(ET1255IniSectionName, 'ActiveChannel', 0)));
  SetGain(TET1255_ADC_Gain(
                   ConfigFile.ReadInteger(ET1255IniSectionName, 'Gain', 1)));

  SetADCMode(TET1255_Frequency_Tackt(
              ConfigFile.ReadInteger(ET1255IniSectionName, 'Frequency_Tackt', 0)),
              ConfigFile.ReadBool(ET1255IniSectionName, 'StartByProgr', True),
              ConfigFile.ReadBool(ET1255IniSectionName, 'InternalTacktMode', True),
              MemEnable);
  fToAverageSerialResults:=ConfigFile.ReadBool(Name, 'ToAverageSerialResults', False);
  fAutoGain:=ConfigFile.ReadBool(Name, 'AutoGain', False);
end;

procedure TET1255_ModuleAndChan.SetNewData(Value: boolean);
begin
 Channels[ActiveChannel].NewData:=Value;
end;

procedure TET1255_ModuleAndChan.WriteToIniFile(ConfigFile: TIniFile);
 var i:TET1255_ADC_ChanelNumber;
begin
  for I := Low(TET1255_ADC_ChanelNumber) to High(TET1255_ADC_ChanelNumber) do
    Channels[i].WriteToIniFile(ConfigFile);

  ConfigFile.EraseSection(ET1255IniSectionName);
  WriteIniDef(ConfigFile,ET1255IniSectionName,'ActiveChannel', ord(ActiveChannel));
  WriteIniDef(ConfigFile,ET1255IniSectionName,'Gain',  Gain);
  WriteIniDef(ConfigFile,ET1255IniSectionName,'Frequency_Tackt', ord(Frequency_Tackt));
  WriteIniDef(ConfigFile,ET1255IniSectionName,'StartByProgr', StartByProgr);
  WriteIniDef(ConfigFile,ET1255IniSectionName,'InternalTacktMode', InternalTacktMode);
  WriteIniDef(ConfigFile,Name,'ToAverageSerialResults', fToAverageSerialResults);
  WriteIniDef(ConfigFile,Name,'AutoGain',  fAutoGain);
end;

{ TET1255_ADCShow }

procedure TET1255_ADCShow.CBAutoGainClick(Sender: TObject);
begin
 ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].fAutoGain:=CBAutoGain.Checked;
end;

procedure TET1255_ADCShow.CBAverageSerialClick(Sender: TObject);
begin
 ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].fToAverageSerialResults:=CBAverageSerial.Checked;
end;

procedure TET1255_ADCShow.CBSerialClick(Sender: TObject);
begin
 ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].SerialMeasurements:=CBSerial.Checked;
 SEMeasurementNumber.Enabled:=CBSerial.Checked;
end;

constructor TET1255_ADCShow.Create(ET1255: TET1255_ModuleAndChan;
                                   MM, R: TRadioGroup;
                                   DL, UL: TLabel;
                                   MB: TButton;
                                   AB: TSpeedButton;
                                   TT: TTimer;
                                   SEG, SEMN: TSpinEdit;
                                   CBSer,CBToAv,CBAuG:TCheckBox;
                                   Gr: TCustomSeries);
begin
 inherited Create(ET1255, MM, R, DL, UL, MB, AB, TT);
 ET1255_ModuleAndChan:=ET1255;
 SEGain:=SEG;
 SEMeasurementNumber:=SEMN;
 CBSerial:=CBSer;
 CBAverageSerial:=CBToAv;
 CBAutoGain:=CBAuG;
 Graph:=Gr;

 ElementFill();
 FromET1255ToVisualElement;
end;

procedure TET1255_ADCShow.ElementFill;
 var i:TET1255_ADC_ChanelNumber;
     j:TET1255_Frequency_Tackt;
begin
  Range.Caption:='Active Channel';
  Range.Columns:=2;
  Range.Items.Clear;
    for I := Low(TET1255_ADC_ChanelNumber) to High(TET1255_ADC_ChanelNumber)
      do Range.Items.Add(inttostr(ord(i)));
  Range.ItemIndex:=Low(TET1255_ADC_ChanelNumber);

  MeasureMode.Caption:='Frequancy (MHz)';
  MeasureMode.Columns:=2;
  MeasureMode.Items.Clear;
    for j := Low(TET1255_Frequency_Tackt) to High(TET1255_Frequency_Tackt)
      do  MeasureMode.Items.Add(TET1255_Frequency_Tackt_Label[j]);
  MeasureMode.ItemIndex:=ord(Low(TET1255_Frequency_Tackt));

  SEGain.Increment:=1;
  SEGain.MinValue:=Low(TET1255_ADC_Gain);
  SEGain.MaxValue:=High(TET1255_ADC_Gain);
  SEGain.Value:=SEGain.MinValue;
  SEGain.EditorEnabled:=False;

  SEMeasurementNumber.Increment:=1;
  SEMeasurementNumber.MinValue:=Low(byte)+1;
  SEMeasurementNumber.MaxValue:=High(byte);
  SEMeasurementNumber.Value:=SEGain.MinValue;
end;

procedure TET1255_ADCShow.FromActiveChannelToVisualElement;
begin
  CBSerial.OnClick:=nil;
  SEMeasurementNumber.OnChange:=nil;
  CBAverageSerial.OnClick:=nil;
  CBAutoGain.OnClick:=nil;

  CBSerial.Checked:=ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].SerialMeasurements;
  SEMeasurementNumber.Enabled:=CBSerial.Checked;
  SEMeasurementNumber.Value:= ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].SerialMeasurementNumber;
  CBAverageSerial.Checked:=ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].fToAverageSerialResults;
  CBAutoGain.Checked:=ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].fAutoGain;

  CBSerial.OnClick:=CBSerialClick;
  SEMeasurementNumber.OnChange:=SEMNChange;
  CBAverageSerial.OnClick:=CBAverageSerialClick;
  CBAutoGain.OnClick:=CBAutoGainClick;
end;

procedure TET1255_ADCShow.FromET1255ToVisualElement;
begin
  Range.OnClick:=nil;
  MeasureMode.OnClick:=nil;
  SEGain.OnChange:=nil;

  Range.ItemIndex:=ord(ET1255_ModuleAndChan.ActiveChannel);
  MeasureMode.ItemIndex:=ord(ET1255_ModuleAndChan.FFrequency_Tackt);
  SEGain.Value:=byte(ET1255_ModuleAndChan.Gain);
  FromActiveChannelToVisualElement;

  Range.OnClick:=GroupChannelsClick;
  MeasureMode.OnClick:=GroupFrequencyClick;
  SEGain.OnChange:=SEGainChange;
end;

procedure TET1255_ADCShow.GroupChannelsClick(Sender: TObject);
begin
 if ET1255_ModuleAndChan.SetActiveChannel(
         TET1255_ADC_ChanelNumber(
           Low(TET1255_ADC_ChanelNumber)+Range.ItemIndex))
   then
     FromActiveChannelToVisualElement
   else
    begin
     Range.OnClick:=nil;
     Range.ItemIndex:=ord(ET1255_ModuleAndChan.ActiveChannel);
     Range.OnClick:=GroupChannelsClick;
    end;
end;

procedure TET1255_ADCShow.GroupFrequencyClick(Sender: TObject);
begin
 if ET1255_ModuleAndChan.SetFrequency_Tackt(
         TET1255_Frequency_Tackt(MeasureMode.ItemIndex))
   then
   else
    begin
     MeasureMode.OnClick:=nil;
     MeasureMode.ItemIndex:=ord(ET1255_ModuleAndChan.FFrequency_Tackt);
     MeasureMode.OnClick:=GroupFrequencyClick;
    end;
end;

procedure TET1255_ADCShow.MetterDataShow;
begin
  inherited MetterDataShow;
  Graph.Clear;
    if Meter.Value<>ErResult then
//     begin
      ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].DataVector.WriteToGraph(Graph);
//      VectorToGraph(ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].DataVector,Graph);
//     end;
end;

procedure TET1255_ADCShow.SEGainChange(Sender: TObject);
begin
if ET1255_ModuleAndChan.SetGain(
         TET1255_ADC_Gain(SEGain.Value))
   then
   else
    begin
     SEGain.OnChange:=nil;
     SEGain.Value:=byte(ET1255_ModuleAndChan.Gain);
     SEGain.OnChange:=SEGainChange;
    end;

end;

procedure TET1255_ADCShow.SEMNChange(Sender: TObject);
begin
 ET1255_ModuleAndChan.Channels[ET1255_ModuleAndChan.ActiveChannel].SerialMeasurementNumber:=SEMeasurementNumber.Value;
end;

function TET1255_ADCShow.UnitModeLabel: string;
begin
 Result:='V';
end;

//procedure  ET1255_DAC_ChanelsCreate;
// var I:TET1255_DAC_ChanelNumber;
//begin
// for I := Low(TET1255_DAC_ChanelNumber) to High(TET1255_DAC_ChanelNumber) do
//   begin
//    ET1255_DACs[i]:=TET1255_DAC.Create(i);
//    ET1255_DACs[i].Reset();
//   end;
//end;
//
//procedure  ET1255_DAC_ChanelsFree;
// var I:TET1255_DAC_ChanelNumber;
//begin
// for I := Low(TET1255_DAC_ChanelNumber) to High(TET1255_DAC_ChanelNumber) do
//    ET1255_DACs[i].Free;
//end;




initialization
  EventET1255Measurement_Done := CreateEvent(nil,
                                 True, // ��� ������ TRUE - ������
                                 True, // ��������� ��������� TRUE - ����������
                                 nil);
//  ET1255isPresent:=(ET_StartDrv = '');
//  if ET1255isPresent then  ET1255_DAC_ChanelsCreate;

finalization

//  if ET1255isPresent then  ET1255_DAC_ChanelsFree;
  SetEvent(EventET1255Measurement_Done);
  CloseHandle(EventET1255Measurement_Done);

end.
