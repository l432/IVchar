unit ST2829C;

interface

uses
  SCPI, CPort, RS232deviceNew, ST2829CConst;

type

  TRS232_ST2829C=class(TRS232_SCPI)
    protected
    public
     Constructor Create(CP:TComPort);
    end;

  TDataSubject_ST2829C=class(TRS232DataSubjectSingle)
    protected
    procedure ComPortCreare(CP:TComPort);override;
  end;


 TST2829CDevice=class(TRS232DeviceNew)
  private
  protected
   procedure CreateDataSubject(CP:TComPort);override;
  public
 end;

  TST2829C=class(TSCPInew)
  private
   fFreqMeas:double;
   {������� �� ��� ����������� ����������,
   []=Hz}
   fVrmsMeas:double;
   fIrmsMeas:double;
   {���� ������� �� ���� ������,
    �� ���� ����������� ����������,
    []=V, []=mA (!)}
   fAutoLevelControlEnable:boolean;
   {���� True, �� ������ ���������
   ����� �������� �� DUT, � �� ������
   ���� ���� ��������}
   fBiasEnable:boolean;
   fBiasVoltageValue:double;
   fBiasCurrentValue:double;
   fOutputImpedance:TST2829C_OutputImpedance;
   fMeasureType:TST2829C_MeasureType;
   fMeasureRange:TST2829C_Range;
   fMeasureSpeed:TST2829C_MeasureSpeed;
   fAverTimes:byte;
   {������� ���������� ��� ���������}
   fVrmsToMeasure:boolean;
   {�� ���� ����������� ������� �� DUT
   �� ��� ���������}
   fIrmsToMeasure:boolean;
   fTrigSource:TST2829C_TrigerSource;
   {������� ��������� �������}
   fDelayTime:integer;
   {��� �������� �� ��������� ��������
   �� �������� ����������, []=ms}
   fPrimaryData:double;
   fSecondaryData:double;
   fVrmsData:double;
   fIrmsData:double;

//   fRS232:TRS232MeterDeviceSingle;
//   fComPort:TComPort;
//   fTerminal:TKeitley_OutputTerminals;
//   fDataVector:TVector;
//   {X - �������� ������ (�������, ������ ������); Y - ��������� �����}
//   fDataTimeVector:TVector;
//   {X - ��� ����� (��������� � ������� ����); Y - ��������� �����}
//   fBuffer:TKeitley_Buffer;
//
//   fDisplayState:TKeitley_DisplayState;
//   fTrigerState:TKeitley_TriggerState;
//
//   function StringToTerminals(Str:string):boolean;
//   function StringToBufferIndexies(Str:string):boolean;
//   function StringToDisplayBrightness(Str:string):boolean;
   Procedure SetFreqMeas(Value:Double);
   procedure SetAutoLevelControl(const Value: boolean);
   procedure SetIrmsMeas(const Value: double);
   procedure SetVrmsMeas(const Value: double);
   procedure StBiasVoltageValue(const Value: double);
   procedure StBiasCurrentValue(const Value: double);
   procedure StAverTimes(const Value: byte);
   procedure StDelayTime(const Value: integer);
   procedure StrToData(Str:string);
  protected
//   fTelnet:TIdTelnet;
//   fIPAdressShow: TIPAdressShow;
//   fMeasureFunction:TKeitley_Measure;
//   fTimeValue:double;
//   fTrigBlockNumber:word;
//   fCount:integer;
//   fMeter:TKeitley_Meter;
//   procedure MeterCreate;virtual;abstract;
//   procedure PrepareString;override;
   function GetRootNodeString():string;override;
   procedure DeviceCreate(Nm:string);override;
   procedure OnOffFromBool(toOn:boolean);
   function ValueToOrd(Value: double; Action:TST2829CAction): integer;
   {������������ ���������� �� ������� ����� � ����� ��������
   � �������, ��������������� ��� �������, �� ��������� �������� ��������}
   function EnumerateToString(Action:TST2829CAction):string;
   {������� �����, ���� ������� �������� ������� ��
   �������� ���������, �� �� ��� �����������
   (������ �������� ��������)}
   function GetRangePattern(Action:TST2829CAction):boolean;

   procedure PrepareStringByRootNode;override;
   function ActionToRootNodeNumber(Action:TST2829CAction):byte;
   function ActionToFirstNode(Action:TST2829CAction):byte;
   function ActionToLeafNode(Action:TST2829CAction):byte;
   function ActionToSyffix(Action:TST2829CAction):boolean;
   function PermitedAction(Action:TST2829CAction):boolean;
   {�������, �� ��������� �������� �� ����� ����}
   function PermitedGetAction(Action:TST2829CAction):boolean;
   procedure SetPrepareAction(Ps:array of Pointer);
   {��������� �������� ����� �������� SetupOperation}
   procedure GetPrepareAction(Action:TST2829CAction);
   procedure ProcessingStringByRootNode(Str:string);override;
   procedure DefaultSettings;override;
   function HighForStrParsing:byte;override;
   function ItIsRequiredStr(Str:string;i:byte):boolean;override;
   function SuccessfulGet(Action:TST2829CAction):boolean;
   {������� ������� �������� ��������� �����}
   procedure GetActionProcedure(Action:TST2829CAction);
   {䳿, �� ����������� ��� �������� ��������}
//   procedure SetShablon(Action:TST2829CAction;P:Pointer=nil);overload;
//   procedure SetShablon(Action:TST2829CAction;Ps:array of Pointer);overload;
//   procedure SetPrepareAction(Action:TST2829CAction;P:Pointer=nil);overload;


  public
   property FreqMeas:double read fFreqMeas write SetFreqMeas;
   property VrmsMeas:double read fVrmsMeas write SetVrmsMeas;
   property IrmsMeas:double read fIrmsMeas write SetIrmsMeas;
   property AutoLevelControlEnable:boolean read fAutoLevelControlEnable write SetAutoLevelControl;
   property BiasEnable:boolean read fBiasEnable write fBiasEnable;
   property BiasVoltageValue:double read fBiasVoltageValue write StBiasVoltageValue;
   property BiasCurrentValue:double read fBiasCurrentValue write StBiasCurrentValue;
   property OutputImpedance:TST2829C_OutputImpedance read fOutputImpedance write fOutputImpedance;
   property MeasureType:TST2829C_MeasureType read fMeasureType write fMeasureType;
   property MeasureRange:TST2829C_Range read fMeasureRange write fMeasureRange;
   property MeasureSpeed:TST2829C_MeasureSpeed read fMeasureSpeed write fMeasureSpeed;
   property AverTimes:byte read fAverTimes write StAverTimes;
   property VrmsToMeasure:boolean read fVrmsToMeasure write fVrmsToMeasure;
   property IrmsToMeasure:boolean read fIrmsToMeasure write fIrmsToMeasure;
   property TrigSource:TST2829C_TrigerSource read fTrigSource write fTrigSource;
   property DelayTime:integer read fDelayTime write StDelayTime;
   property DataPrimary:double read fPrimaryData;
   property DataSecondary:double read fSecondaryData;
   property DataVrms:double read fVrmsData;
   property DataIrms:double read fIrmsData;


//   property DataVector:TVector read fDataVector;
//   property DataTimeVector:TVector read fDataTimeVector;
//   property MeasureFunction:TKeitley_Measure read GetMeasureFunctionValue;
//   property Terminal:TKeitley_OutputTerminals read fTerminal write fTerminal;
//   property Buffer:TKeitley_Buffer read fBuffer;
//   property Count:integer read fCount write SetCountNumber;
//   property TimeValue:double read fTimeValue;
//   property Meter:TKeitley_Meter read fMeter;
//   property DisplayState:TKeitley_DisplayState read fDisplayState;
//   property TrigerState:TKeitley_TriggerState read fTrigerState;
//     Constructor Create(CP:TComPort;Nm:string='ST2829C');

   Constructor Create();
   function GetPattern(Action:Pointer):boolean;override;
   procedure SetPattern(Ps: array of Pointer);override;
//   procedure SetPattern(Action:TST2829CAction;Ps:array of Pointer);overload;
   procedure ResetSetting();
   procedure MyTraining();
   procedure Trig();
   {triggers the measurement and then sends the result to the output buffer.}
   procedure SetDisplayPage(Page:TST2829C_DisplayPage);
   function  GetDisplayPage():boolean;
   procedure SetDisplayFont(Font:TST2829C_Font);
   function  GetDisplayFont():boolean;
   procedure SaveSetup(RecordNumber:TST2829C_SetupMemoryRecord;RecordName:string='');
   procedure LoadSetup(RecordNumber:TST2829C_SetupMemoryRecord);

   procedure SetFrequancyMeasurement(Freq:double);
   function  GetFrequancyMeasurement():boolean;

   procedure SetAutoLevelEnable(toOn: boolean);
   {��� toOn=True ������ ���� ������������, ���
   �������� ������ �������/���� ������ �� DUT
   ��������� �������������}
   function  GetAutoLevelEnable():boolean;

   procedure SetVoltageMeasurement(V:double);
   {�������������� ���� �������� �������,
   ��� ���� ������ ����������� ����������}
   function  GetVoltageMeasurement():boolean;

   procedure SetCurrentMeasurement(I:double);
   function  GetCurrentMeasurement():boolean;

   procedure SetBiasEnable(toOn: boolean);
   function  GetBiasEnable():boolean;

   procedure SetBiasVoltage(V:double);
   function  GetBiasVoltage():boolean;

   procedure SetBiasCurrent(I:double);
   function  GetBiasCurrent():boolean;

   procedure SetOutputImpedance(OI:TST2829C_OutputImpedance);
   function  GetOutputImpedance():boolean;

   procedure SetMeasureFunction(MF:TST2829C_MeasureType);
    {�� ���� ���� ��������� ������}
   function  GetMeasureFunction():boolean;

   procedure SetRange(Range:TST2829C_Range);
   function  GetRange():boolean;

   procedure SetVrmsToMeasure(toOn: boolean);
    {�� ���� �����������  ������� �������
     �� DUT}
   function  GetVrmsToMeasure():boolean;

   procedure SetIrmsToMeasure(toOn: boolean);
    {�� ���� ����������� ������� ���� ������
     ����� DUT}
   function  GetIrmsToMeasure():boolean;

   procedure SetMeasureSpeed(Speed:TST2829C_MeasureSpeed);
   function  GetMeasureSpeed():boolean;

   procedure SetAverTime(AverTime:byte);
   {������� ���� ��� �����������}
   function  GetAverTime():boolean;

   procedure Trigger();
   {������� ������� ��� ����������}

   procedure SetTrigerSource(Source:TST2829C_TrigerSource);
   function  GetTrigerSource():boolean;

   procedure SetDelayTime(Time:Integer);
   function  GetDelayTime():boolean;

   function  GetData():boolean;
   function  GetDataVrms():boolean;
   function  GetDataIrms():boolean;

//   procedure SetMeasureFunction(MeasureFunc:TKeitley_Measure=kt_mCurDC);virtual;
//
//   function GetMeasureFunction():boolean;virtual;
//    {������� ��� ����������, ������� ��������
//    �� ���� �������}
//   procedure SetDisplayDigitsNumber(Measure:TKeitley_Measure; Number:TKeitleyDisplayDigitsNumber);overload;virtual;
//   {������� ����, �� ������������� �� �����,
//     �� ������� ������ ���������� �� ������}
//   procedure SetDisplayDigitsNumber(Number:TKeitleyDisplayDigitsNumber);overload;virtual;
//   function GetDisplayDigitsNumber(Measure:TKeitley_Measure):boolean;overload;virtual;
//   function GetDisplayDigitsNumber():boolean;overload;virtual;
//   procedure BufferCreate();overload;
//   procedure BufferCreate(Name:string);overload;
//   procedure BufferCreate(Name:string;Size:integer);overload;
//   procedure BufferCreate(Name:string;Size:integer;Style:TKt2450_BufferStyle);overload;virtual;
//   procedure BufferCreate(Style:TKt2450_BufferStyle);overload;virtual;
//   procedure BufferDelete();overload;
//   procedure BufferDelete(Name:string);overload;
//   procedure BufferClear();overload;
//   procedure BufferClear(BufName:string);overload;
////
//   procedure BufferReSize(NewSize:integer);overload;
//   {����� ������� ������� ������ � �����,
//   ��� ����� �� ���������}
//   procedure BufferReSize(BufName:string;NewSize:integer);overload;
//   function BufferGetSize():integer;overload;
//   function BufferGetSize(BufName:string):integer;overload;
//   function BufferGetReadingsNumber(BufName:string=KeitleyDefBuffer):integer;
//   {������� ������� ������� ������ � �����}
//   function BufferGetStartEndIndex(BufName:string=KeitleyDefBuffer):boolean;
//   {������� ���������� �� ������� ������� ��������
//   � ����� ������, ���� ��� ����� ���� �����������
//   � Buffer.StartIndex �� Buffer.EndIndex}
//
//   procedure BufferSetFillMode(FillMode:TKeitley_BufferFillMode);overload;
//   procedure BufferSetFillMode(BufName:string;FillMode:TKeitley_BufferFillMode);overload;
//   function BufferGetFillMode():boolean;overload;
//   function BufferGetFillMode(BufName:string):boolean;overload;
//
//   Procedure BufferLastDataSimple();overload;
//   {��� ���������� ������������ ��������� ����������
//   ����������, �� ���������� � defbuffer1,
//   ���������� � fDevice.Value}
//   Procedure BufferLastDataSimple(BufName:string);overload;
//   {��������� ���������� ����������� ����������
//   ��������� � ������ BufName}
//   Procedure BufferLastDataExtended(DataType:TKeitley_ReturnedData=kt_rd_MS;
//                            BufName:string=KeitleyDefBuffer);
//   {�� ��������, ����� ������� ����� �����
//   (���. TKeitley_ReturnedData) ���� ���������� �����}
//   Procedure BufferDataArrayExtended(SIndex,EIndex:integer;
//                     DataType:TKeitley_ReturnedData=kt_rd_MS;
//                     BufName:string=KeitleyDefBuffer);
//   {���������� � ������ BufName ����������, ���������� ��
//   ��������� � ������� �� SIndex �� EIndex,
//   �� ���� ����������� �������� �� DataType,
//   ���������� ��������� � DataVector.Y,
//   �������� ������� � DataVector.�,
//   ���� ����� ��� ����������, �� �� �  DataTimeVector.X,
//   � ��������� ����� �  DataTimeVector.Y,
//   ���� DataType=kt_rd_M, �� ���� � �  DataVector.�}
//   {����� ������� ��� ��������}
//
//   procedure SetCount(Cnt:integer);
//   {������� ��������� ���������, ���� ������ ������� �������}
//   function GetCount:boolean;
//   procedure SetDisplayBrightness(State:TKeitley_DisplayState);
//   function GetDisplayBrightness():boolean;
////
//   procedure Beep(Freq:word=600;Duration:double=0.1);
//   {���� �������� Freq �� �������� Duration ������}
//
//   procedure ConfigMeasureCreate(ListName:string=MyMeasList);
//   procedure ConfigMeasureDelete(ListName:string=MyMeasList;ItemIndex:word=0);
//   {���� ItemIndex=0, �� ����������� ���� ������}
//   procedure ConfigMeasureRecall(ListName:string=MyMeasList;ItemIndex:word=1);
//   {������������ �����������, ��������� � ItemIndex;
//   ���� ������� ��������� ������������ � ��� �������,
//   � ��� ��������� - �������� ������������� ����� ��� �������}
//   procedure ConfigMeasureStore(ListName:string=MyMeasList;ItemIndex:word=0);
//   {����� ����������� � ������;
//   ���� ItemIndex=0, �� ���������� � ����� ������}
//
//   Procedure GetParametersFromDevice;virtual;
////
//   Procedure MeasureSimple();overload;virtual;
//   {����������� ���������� ������ ����, ������
//   ������� � Count, �� ���������� �����������
//   � defbuffer1, ����������� ��������� ���������� �����;
//   ���������� �� �������, ��� ����� ����������� �� ������,
//   ����� �������, ��� ����������� ���� ����, ��� � ��
//   ����� ������� � ����� �� ���� �������� �� ������ ������
//   �������}
//   Procedure MeasureSimple(BufName:string);overload;virtual;
//   {���������� ����������� � ����� BufName
//   � � ����� � ��������� ������� ���������}
//   Procedure MeasureExtended(DataType:TKeitley_ReturnedData=kt_rd_MS;
//                           BufName:string=KeitleyDefBuffer);
//   {�� ��������, ����� ������� ����� �����
//   (���. TKt2450_ReturnedData) ���� ���������� �����}
////
////
//   Procedure Init;
//   Procedure Abort;
//   Procedure Wait;
//   Procedure TrigPause;
//   Procedure TrigResume;
//   Procedure InitWait;
//   Procedure TrigEventGenerate;
//   {generates a trigger event }
//
//   Procedure TrigNewCreate;
//   {any blocks that have been defined in the trigger model
//   are cleared so the trigger model has no blocks defined}
//   Procedure TrigBufferClear(BufName:string=KeitleyDefBuffer);
//   Procedure TrigConfigListRecall(ListName:string;Index:integer=1);
//   Procedure TrigConfigListNext(ListName:string);overload;
//   Procedure TrigConfigListNext(ListName1,ListName2:string);overload;
//   Procedure TrigAlwaysTransition(TransitionBlockNumber:word);
//   Procedure TrigDelay(DelayTime:double);
//   Procedure TrigMeasure(BufName:string=KeitleyDefBuffer;Count:word=1);
//   {��� ��������� ����� ����� ������ ������ Count ����,
//   ���� ���� ���������� ��������� ����;
//   Count=0 ���� ����������������� ��� ������� ����������� ���������
//   - ���. ���;
//   ���������� ���������� � BufName}
//   Procedure TrigMeasureInf(BufName:string=KeitleyDefBuffer);
//   {��� ��������� ����� ����� ������ ������
//   ����� � ���������� ��������� ����; ����� ������������� ����,
//   ���� �� ����������� ����� ������������ ���� �� �� ���� ����� �����}
//   Procedure TrigMeasureCountDevice(BufName:string=KeitleyDefBuffer);
//   {��� ��������� ����� ����� ������ ������ ������ ����, ������
//   ����������� ���������� ������������ ���������� Count,
//   ���� ���� ���������� ��������� ����}
//
//   Procedure TrigMeasureResultTransition(LimitType:TKeitley_TrigLimitType;
//                    LimA,LimB:double;TransitionBlockNumber:word;
//                    MeasureBlockNumber:word=0);
//   {���� ���������� ����������� ����, ��� ����������� � LimitType,
//   �� ���������� ������� �� ���� TransitionBlockNumber;
//   ��� MeasureBlockNumber=0 �������� �� ����� ������
//   ����������, ������ ��, ��� �������� � ����� � ������� MeasureBlockNumber;
//   ���� ������ LimA>LimB, �� ������ ����������� �� ������ ������
//   ����� ����������, ���� ��������� (MeasureResult)
//   ��� kt_tlt_above: MeasureResult > LimB
//   kt_tlt_below: MeasureResult < LimA
//   kt_tlt_inside: LimA < MeasureResult < LimB  (��� <= �� ����, ����� ����������������)
//   kt_tlt_outside:  MeasureResult �� �������� [LimA, LimB]
//   }
//   Procedure TrigCounterTransition(TargetCount,TransitionBlockNumber:word);
//   {���� ������� ������� �� ��� ���� ����� TargetCount, �� ����������
//   ������� �� ���� TransitionBlockNumber}
//   Procedure TrigEventTransition(TransitionBlockNumber:word;
//                                 EventType:TKeitley_TriggerEvents=kt_te_comm;
//                                 EventNumber:word=1);
//   {���� �� ����, �� ����� �� ��� ����, �������� ���� EventType,
//   �� ���������� ������� �� TransitionBlockNumber}
//   function GetTrigerState:boolean;
 end;

var
  ST_2829C:TST2829C;

implementation

uses
  SysUtils, Dialogs, OlegType, Math, StrUtils, OlegFunction;

{ T2829C }

function TST2829C.ActionToFirstNode(Action: TST2829CAction): byte;
begin
 case Action of
   st_aMemSave: Result:=1;
   st_aDispPage,st_aChangFont: Result:=ord(Action)-2;
   st_aBiasEn,
   st_aBiasVol,
   st_aSetMeasT:Result:=ord(Action)-5;
   st_aRange:Result:=8;
   st_aVrmsToMeas,
   st_aIrmsToMeas,
   st_aGetVrms,
   st_aGetIrms:Result:=11;
   st_aAverTimes:Result:=1;
   st_aBiasCur:Result:=7;
   st_aTrigSource,
   st_aTrigDelay:Result:=ord(Action)-7;
   else Result:=0;
 end;
end;

function TST2829C.ActionToLeafNode(Action: TST2829CAction): byte;
begin
 Result:=0;
 case Action of
   st_aRange: case fMeasureRange of
               st_rAuto:Result:=1;
               else Result:=2;
              end;
   st_aVrmsToMeas,
   st_aGetVrms:Result:=12;
   st_aIrmsToMeas,
   st_aGetIrms:Result:=13;
//   else Result:=0;
 end;
end;

function TST2829C.ActionToRootNodeNumber(Action: TST2829CAction): byte;
begin
 case Action of
   st_aReset,st_aTrg,
   st_aMemLoad: Result:=ord(Action)+1;
   st_aMemSave: Result:=3;
   st_aDispPage,st_aChangFont:Result:=4;
   st_aFreqMeas,st_aALE,
   st_aVMeas,st_aIMeas:Result:=ord(Action)-1;
   st_aBiasEn,
   st_aBiasVol,
   st_aBiasCur:Result:=9;
   st_aOutImp:Result:=10;
   st_aSetMeasT,
   st_aRange,
   st_aVrmsToMeas,
   st_aIrmsToMeas:Result:=11;
   st_aSpeedMeas,
   st_aAverTimes:Result:=12;
   st_aTriger,
   st_aTrigSource,
   st_aTrigDelay:Result:=13;
   st_aGetMeasData,
   st_aGetVrms,
   st_aGetIrms:Result:=14;
   else Result:=0;
 end;
end;

function TST2829C.ActionToSyffix(Action: TST2829CAction): boolean;
begin
 case Action of
   st_aReset,st_aTrg: Result:=False;
   else Result:=True;
 end;
end;

constructor TST2829C.Create();
begin
// showmessage('TST2829C Create');
 inherited Create('ST2829C');
end;


procedure TST2829C.DefaultSettings;
begin
 fFreqMeas:=1000;
 fVrmsMeas:=0.01;
 fIrmsMeas:=0.1;
 fAutoLevelControlEnable:=False;
 fBiasEnable:=False;
 fBiasVoltageValue:=0;
 fBiasCurrentValue:=0;
 fOutputImpedance:=st_oi100;
 fMeasureType:=st_mtCpD;
 fMeasureRange:=st_rAuto;
 fMeasureSpeed:=st_msMed;
 fAverTimes:=1;
 fVrmsToMeasure:=False;
 fIrmsToMeasure:=False;
 fDelayTime:=0;
 fTrigSource:=st_tsInt;
 fPrimaryData:=0;
 fSecondaryData:=0;
 fVrmsData:=0;
 fIrmsData:=0;
end;

procedure TST2829C.DeviceCreate(Nm: string);
begin
//  fDevice:=TST2829CDevice.Create(Self,fComPort,Nm);
  fDevice:=TST2829CDevice.Create(Self,Nm);
end;

function TST2829C.EnumerateToString(Action: TST2829CAction): string;
begin
 case Action of
   st_aOutImp:Result:=Copy(ST2829C_OutputImpedanceLabels[fOutputImpedance],
                           1, Length(ST2829C_OutputImpedanceLabels[fOutputImpedance])-4);
   st_aRange:begin
               if odd(ord(MeasureRange))
                 then Result:=floattostr(Power(10,((ord(MeasureRange) Div 2)+1)))
                 else Result:=floattostr(3*Power(10,((ord(MeasureRange) Div 2))));
             end
   else Result:='';
 end;
end;

procedure TST2829C.GetActionProcedure(Action: TST2829CAction);
begin
  case Action of
    st_aFreqMeas:FreqMeas:=fDevice.Value;
    st_aALE:fAutoLevelControlEnable:=(fDevice.Value=1);
    st_aVMeas:VrmsMeas:=fDevice.Value;
    st_aIMeas:IrmsMeas:=fDevice.Value*1000;
    st_aBiasEn:BiasEnable:=(fDevice.Value=1);
    st_aBiasVol:VrmsMeas:=fDevice.Value;
    st_aBiasCur:IrmsMeas:=fDevice.Value*1000;
    st_aOutImp:OutputImpedance:=TST2829C_OutputImpedance(ValueToOrd(fDevice.Value,st_aOutImp));
    st_aSetMeasT:MeasureType:=TST2829C_MeasureType(round(fDevice.Value));
    st_aSpeedMeas:MeasureSpeed:=TST2829C_MeasureSpeed(round(fDevice.Value));
    st_aAverTimes:AverTimes:=round(fDevice.Value);
    st_aVrmsToMeas:VrmsToMeasure:=(fDevice.Value=1);
    st_aIrmsToMeas:IrmsToMeasure:=(fDevice.Value=1);
    st_aTrigSource:TrigSource:=TST2829C_TrigerSource(round(fDevice.Value));
    st_aTrigDelay:fDelayTime:=round(fDevice.Value*1000);
    st_aGetVrms:fVrmsData:=fDevice.Value;
    st_aGetIrms:fIrmsData:=fDevice.Value;
  end;
end;

function TST2829C.GetAutoLevelEnable: boolean;
begin
 Result:=GetPattern(Pointer(st_aALE));
end;

function TST2829C.GetAverTime: boolean;
begin
 Result:=GetPattern(Pointer(st_aAverTimes));
end;

function TST2829C.GetBiasCurrent: boolean;
begin
 Result:=GetPattern(Pointer(st_aBiasCur));
end;

function TST2829C.GetBiasEnable: boolean;
begin
 Result:=GetPattern(Pointer(st_aBiasEn));
end;

function TST2829C.GetBiasVoltage: boolean;
begin
 Result:=GetPattern(Pointer(st_aBiasVol));
end;

function TST2829C.GetCurrentMeasurement: boolean;
begin
 Result:=GetPattern(Pointer(st_aIMeas));
end;

function TST2829C.GetData: boolean;
begin
//FETC?
 Result:=GetPattern(Pointer(st_aGetMeasData));
end;

function TST2829C.GetDataIrms: boolean;
begin
//FETC:SMON:IAC?
 Result:=GetPattern(Pointer(st_aGetIrms));
end;

function TST2829C.GetDataVrms: boolean;
begin
//FETC:SMON:VAC?
 Result:=GetPattern(Pointer(st_aGetVrms));
end;

function TST2829C.GetDelayTime: boolean;
begin
 Result:=GetPattern(Pointer(st_aTrigDelay));
end;

function TST2829C.GetDisplayFont: boolean;
begin
 Result:=GetPattern(Pointer(st_aChangFont));
// QuireOperation(4,3);
// Result:=(fDevice.Value<>ErResult);
end;

function TST2829C.GetDisplayPage: boolean;
begin
 Result:=GetPattern(Pointer(st_aDispPage));
// QuireOperation(4,2);
// Result:=(fDevice.Value<>ErResult);
end;

function TST2829C.GetFrequancyMeasurement: boolean;
begin
 Result:=GetPattern(Pointer(st_aFreqMeas));
end;

function TST2829C.GetMeasureFunction: boolean;
begin
 Result:=GetPattern(Pointer(st_aSetMeasT));
end;

function TST2829C.GetMeasureSpeed: boolean;
begin
 Result:=GetPattern(Pointer(st_aSpeedMeas));
end;

function TST2829C.GetOutputImpedance: boolean;
begin
 Result:=GetPattern(Pointer(st_aOutImp));
end;

function TST2829C.GetRange: boolean;
begin
 Result:=GetPattern(Pointer(st_aRange));
end;

function TST2829C.GetRangePattern(Action: TST2829CAction): boolean;
begin

 QuireOperation(ActionToRootNodeNumber(Action),
                ActionToFirstNode(Action),1);
 Result:=SuccessfulGet(Action);
// if not(Result) then Exit;

 if fDevice.Value=1
   then fMeasureRange:=st_rAuto
   else
    begin
      try
        QuireOperation(ActionToRootNodeNumber(Action),
                       ActionToFirstNode(Action),2);
        Result:=SuccessfulGet(Action);
        if Result then
              begin
               if ((round(fDevice.Value) mod 3) = 0 )
                 then fMeasureRange:=TST2829C_Range(round(Log10(fDevice.Value/3)*2))
                 else fMeasureRange:=TST2829C_Range(round(Log10(fDevice.Value)*2-1));
              end;
      except
       Result:=False;
      end;
    end;
end;

function TST2829C.GetRootNodeString: string;
begin
 Result:=RootNodeST2829C[fRootNode];
end;

function TST2829C.GetTrigerSource: boolean;
begin
  Result:=GetPattern(Pointer(st_aTrigSource));
end;

function TST2829C.GetIrmsToMeasure: boolean;
begin
 Result:=GetPattern(Pointer(st_aIrmsToMeas));
end;

function TST2829C.GetVrmsToMeasure: boolean;
begin
 Result:=GetPattern(Pointer(st_aVrmsToMeas));
end;

function TST2829C.GetPattern(Action: Pointer): boolean;
 var Act:TST2829CAction;
begin
  Act:=TST2829CAction(Action);
  Result:=False;
  if Act=st_aRange then
   begin
     Result:=GetRangePattern(Act);
     Exit;
   end;

  try
    GetPrepareAction(Act);
    if not(PermitedGetAction(Act)) then Exit;
    
    QuireOperation(ActionToRootNodeNumber(Act),
                   ActionToFirstNode(Act),
                   ActionToLeafNode(Act),
                   ActionToSyffix(Act));
    Result:=SuccessfulGet(Act);
    if Result
      then GetActionProcedure(Act);
  except
//   Result:=False;
  end;
end;

procedure TST2829C.GetPrepareAction(Action: TST2829CAction);
begin
 case Action of
   st_aTrg,
   st_aGetMeasData: begin
                    fPrimaryData:=ErResult;
                    fSecondaryData:=ErResult;
                    end;
   st_aGetVrms: fVrmsData:=ErResult;
   st_aGetIrms: fIrmsData:=ErResult;
 end;
end;

function TST2829C.GetVoltageMeasurement: boolean;
begin
 Result:=GetPattern(Pointer(st_aVMeas));
end;

function TST2829C.HighForStrParsing: byte;
begin
 Result:=0;
 case fRootNode of
  4:case fFirstLevelNode of
    2:Result:=ord(High(ST2829C_DisplayPageCommand));
    3:Result:=ord(High(TST2829C_Font));
    end;
  11:case fFirstLevelNode of
     8:Result:=ord(High(TST2829C_MeasureType));
     end;
  12:Result:=ord(High(TST2829C_MeasureSpeed));
  13:Result:=ord(High(TST2829C_TrigerSource));
 end;
end;

function TST2829C.ItIsRequiredStr(Str: string; i: byte): boolean;
begin
 Result:=False;
 case fRootNode of
  4:case fFirstLevelNode of
    2:Result:=(Pos(ST2829C_DisplayPageResponce[TST2829C_DisplayPage(i)],Str)<>0);
    3:Result:=(Pos(ST2829C_FontCommand[TST2829C_Font(i)],Str)<>0);
    end;
  11:case fFirstLevelNode of
     8:Result:=(Pos(ST2829C_MeasureTypeCommands[TST2829C_MeasureType(i)],Str)<>0);
     end;
  12:if i<ord(st_msFastPlus)
        then Result:=(Pos(ST2829C_MeasureSpeedCommands[TST2829C_MeasureSpeed(i)]+' ',Str)<>0)
        else Result:=(Pos(ST2829C_MeasureSpeedCommands[TST2829C_MeasureSpeed(i)],Str)<>0);
  13:Result:=(Pos(ST2829C_TrigerSourceCommands[TST2829C_TrigerSource(i)],Str)<>0);
 end;
end;

procedure TST2829C.LoadSetup(RecordNumber: TST2829C_SetupMemoryRecord);
begin
// *MMEM:LOAD:STAT <record number>
 SetPattern([Pointer(st_aMemLoad),Pointer(RecordNumber)]);
// fAdditionalString:=inttostr(RecordNumber);
// SetupOperation(3);
end;

procedure TST2829C.MyTraining;
 var i:Integer;
     tempDouble:double;
begin
// (fDevice as TST2829CDevice).SetStringToSend('BIAS:CURR -0.1');
// fDevice.Request;
// (fDevice as TST2829CDevice).SetStringToSend('BIAS:CURR?');
// fDevice.GetData;

Trig();

//  GetData();
//  SetVrmsToMeasure(True);
//  GetDataVrms();
//  SetIrmsToMeasure(True);
//  GetDataIrms();

// tempDouble:=10;
// SetDelayTime(round(tempDouble));
// if GetDelayTime()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(DelayTime));
// tempDouble:=-10;
// SetDelayTime(round(tempDouble));
// if GetDelayTime()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(DelayTime));
// tempDouble:=12345;
// SetDelayTime(round(tempDouble));
// if GetDelayTime()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(DelayTime));

//  for I := 0 to ord(High(TST2829C_TrigerSource)) do
//   begin
//     SetTrigerSource(TST2829C_TrigerSource(i));
//     if (GetTrigerSource() and(i=ord(fTrigSource)))
//      then showmessage('Ura!!!');
//   end;


//Trigger();

// tempDouble:=1.2345678;
// SetBiasCurrent(tempDouble);
// if GetBiasCurrent()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasVoltageValue));
//
// tempDouble:=-150;
// SetBiasCurrent(tempDouble);
// if GetBiasCurrent()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasVoltageValue));
//
// tempDouble:=-11.987654321;
// SetBiasCurrent(tempDouble);
// if GetBiasCurrent()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasVoltageValue));

//--------------------------------------------------------

//GetMeasureSpeed();
//SetAverTime(5);
//GetAverTime();
//Showmessage(inttostr(AverTimes));
//
//SetAverTime(0);
//GetAverTime();
//Showmessage(inttostr(AverTimes));
//
//SetAverTime(115);
//GetAverTime();
//Showmessage(inttostr(AverTimes));



//  for I := 0 to ord(High(TST2829C_MeasureSpeed)) do
//   begin
//     SetMeasureSpeed(TST2829C_MeasureSpeed(i));
//     if (GetMeasureSpeed() and(i=ord(fMeasureSpeed)))
//      then showmessage('Ura!!!');
//   end;


// SetShowVrms(False);
// GetShowVrms();
// SetShowVrms(True);
// GetShowVrms();
//
// SetShowIrms(False);
// GetShowIrms();
// SetShowIrms(True);
// GetShowIrms();


//  for I := 0 to ord(High(TST2829C_Range)) do
//   begin
//     SetRange(TST2829C_Range(i));
//     if (GetRange() and(i=ord(fMeasureRange)))
//      then showmessage('Ura!!!');
//   end;



//  for I := 0 to ord(High(TST2829C_MeasureType)) do
//   begin
//     SetMeasureFunction(TST2829C_MeasureType(i));
//     if (GetMeasureFunction() and(i=round(fDevice.Value)))
//      then showmessage('Ura!!!');
//   end;



//  for I := 0 to ord(High(TST2829C_OutputImpedance)) do
//   begin
//     SetOutputImpedance(TST2829C_OutputImpedance(i));
//     if (GetOutputImpedance() and(TST2829C_OutputImpedance(i)=OutputImpedance))
//      then showmessage('Ura!!!');
//   end;



// tempDouble:=1.2345678;
// SetBiasVoltage(tempDouble);
// if GetBiasVoltage()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasVoltageValue));
//
// tempDouble:=-15;
// SetBiasVoltage(tempDouble);
// if GetBiasVoltage()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasVoltageValue));
//
// tempDouble:=-1.987654321;
// SetBiasVoltage(tempDouble);
// if GetBiasVoltage()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(BiasVoltageValue));



// SetBiasEnable(True);
// if GetBiasEnable() then
//   showmessage(booltostr(BiasEnable,True));
// SetBiasEnable(False);
// if GetBiasEnable() then
//   showmessage(booltostr(BiasEnable,True));


// SetVoltageMeasurement(0.015);

//SetAutoLevelEnable(False);
//GetAutoLevelEnable();
//SetCurrentMeasurement(0.07);
//GetAutoLevelEnable();
//SetAutoLevelEnable(True);
//GetAutoLevelEnable();

// ST2829C_VmrsMeasLimits:TLimitValues=(0.005,10);
// ST2829C_ImrsMeasLimits:TLimitValues=(0.05,100);
// ST2829C_VmrsMeasLimitsForAL:TLimitValues=(0.01,5);
// ST2829C_ImrsMeasLimitsForAL:TLimitValues=(0.1,50);

// tempDouble:=1.2345678;
// SetCurrentMeasurement(tempDouble);
// if GetCurrentMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(IrmsMeas));

// tempDouble:=11.12345678;
// SetCurrentMeasurement(tempDouble);
// if GetCurrentMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(IrmsMeas));



// tempDouble:=0.1;
// SetVoltageMeasurement(tempDouble);
// if GetVoltageMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(VrmsMeas));
//
// tempDouble:=2.5;
// SetVoltageMeasurement(tempDouble);
// if GetVoltageMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(VrmsMeas));
// tempDouble:=0.12345678;
// SetVoltageMeasurement(tempDouble);
// if GetVoltageMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(VrmsMeas));


//----------------------------------------

// SetAutoLevelEnable(True);
// if GetAutoLevelEnable() then
//   showmessage(booltostr(AutoLevelControlEnable,True));
// SetAutoLevelEnable(False);
// if GetAutoLevelEnable() then
//   showmessage(booltostr(AutoLevelControlEnable,True));

// tempDouble:=4567;
// SetFrequancyMeasurement(tempDouble);
// if GetFrequancyMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(FreqMeas));
// tempDouble:=1.25e5;
// SetFrequancyMeasurement(tempDouble);
// if GetFrequancyMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(FreqMeas));
//  tempDouble:=1.25e6;
// SetFrequancyMeasurement(tempDouble);
// if GetFrequancyMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(FreqMeas));
//  tempDouble:=15;
// SetFrequancyMeasurement(tempDouble);
// if GetFrequancyMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(FreqMeas));
// tempDouble:=438.12345;
// SetFrequancyMeasurement(tempDouble);
// if GetFrequancyMeasurement()  then
//  showmessage('send:'+floattostr(tempDouble)
//              +'  received:'+floattostr(FreqMeas));
//
//
// GetFrequancyMeasurement();
// SetFrequancyMeasurement(4567);
// SetFrequancyMeasurement(1.25e5);
// SetFrequancyMeasurement(1.25e6);
// SetFrequancyMeasurement(15);
// SetFrequancyMeasurement(438.12345);



//  QuireOperation(4,4);

//  for I := 0 to ord(High(TST2829C_Font)) do
//   begin
//     SetDisplayFont(TST2829C_Font(i));
//     if (GetDisplayFont() and(i=round(fDevice.Value)))
//      then showmessage('Ura!!!');
//   end;
// SetDisplayFont(st_lLarge);

// SetDisplayFont(st_lTine);
// SetDisplayFont(st_lOff);
// SetDisplayFont(st_lLarge);


//  for I := 0 to ord(High(TST2829C_DisplayPage)) do
//   begin
//     SetDisplayPage(TST2829C_DisplayPage(i));
//     if (GetDisplayPage() and(i=round(fDevice.Value)))
//      then showmessage('Ura');
//   end;


//SaveSetup(0);
//SaveSetup(11,'Hi result');
//SaveSetup(25,'0123456789ABCDEFGH');
//
// LoadSetup(35);
// Trig();
// EnableComPortShow();

// ResetSetting();
end;


procedure TST2829C.OnOffFromBool(toOn: boolean);
begin
 if toOn then fAdditionalString:=SuffixST2829C[0]
         else fAdditionalString:=SuffixST2829C[1];
end;

function TST2829C.PermitedAction(Action: TST2829CAction): boolean;
begin
 case Action of
   st_aALE: Result:=ValueInMap(fVrmsMeas,ST2829C_VmrsMeasLimitsForAL)
                     and ValueInMap(fIrmsMeas,ST2829C_ImrsMeasLimitsForAL);
   st_aOutImp:Result:=not(fBiasEnable);
   else Result:=true;
 end;
end;

function TST2829C.PermitedGetAction(Action: TST2829CAction): boolean;
begin
 case Action of
   st_aGetVrms:Result:=fVrmsToMeasure;
   st_aGetIrms:Result:=fIrmsToMeasure;
   else Result:=true;
 end;
end;

procedure TST2829C.PrepareStringByRootNode;
begin
 case fRootNode of
  3,4,9:JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
  11:case fFirstLevelNode of
      8:begin
        JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
        case fLeafNode of
          1:begin
             JoinToStringToSend(FirstNodeST2829C[9]);
             JoinToStringToSend(FirstNodeST2829C[10]);
            end;
          2:JoinToStringToSend(FirstNodeST2829C[9]);
        end;
        end;
      11:begin
          JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
          JoinToStringToSend(FirstNodeST2829C[fLeafNode]);
         end;
     end;
  13:case fFirstLevelNode of
     14,15:JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
     end;
  14:case fLeafNode of
     12,13:begin
            JoinToStringToSend(FirstNodeST2829C[fFirstLevelNode]);
            JoinToStringToSend(FirstNodeST2829C[fLeafNode]);
           end;
     end;
  end;
end;


procedure TST2829C.ProcessingStringByRootNode(Str: string);
begin
 case fRootNode of
  0:if pos(ST2829C_Test,Str)<>0 then fDevice.Value:=314;
  2:StrToData(Str);
  4:StringToOrd(AnsiLowerCase(Str));
  5,7,
  8,10:fDevice.Value:=SCPI_StringToValue(Str);
  6:fDevice.Value:=StrToInt(Str);
  9:case fFirstLevelNode of
     5:fDevice.Value:=StrToInt(Str);
     6,7:fDevice.Value:=SCPI_StringToValue(Str);
    end;
  11:case fFirstLevelNode of
      8:case fLeafNode of
         0:StringToOrd(AnsiLowerCase(Str));
         1:fDevice.Value:=StrToInt(Str);
         2:fDevice.Value:=SCPI_StringToValue(Str);
        end;
      11:fDevice.Value:=StrToInt(Str);
     end;
  12:case fFirstLevelNode of
     0:StringToOrd(AnsiLowerCase(Str));
     1:fDevice.Value:=StrToInt(Copy(Str,Pos(',',Str)+1,Length(Str)));
     end;
  13:case fFirstLevelNode of
     14:StringToOrd(AnsiLowerCase(Str));
     15:fDevice.Value:=SCPI_StringToValue(Str);
     end;
  14:case fFirstLevelNode of
      0:StrToData(Str);
      12,13:fDevice.Value:=SCPI_StringToValue(Str);
     end;
 end;
end;

procedure TST2829C.ResetSetting;
begin
//  *RST
  SetPattern([Pointer(st_aReset)])
//  SetupOperation(1,0,0,False);
end;

procedure TST2829C.SaveSetup(RecordNumber: TST2829C_SetupMemoryRecord;RecordName:string='');
begin
// *MMEM:STOR:STAT <record number>,�<string>�
 SetPattern([Pointer(st_aMemSave),Pointer(RecordNumber),@RecordName]);

// fAdditionalString:=inttostr(RecordNumber);
// if Length(RecordName)>0 then
//  begin
//    if Length(RecordName)>ST2829C_MemFileMaxLength then SetLength(RecordName,ST2829C_MemFileMaxLength);
//    fAdditionalString:=fAdditionalString+', '+StringToInvertedCommas(RecordName);
//  end;
//
// SetupOperation(3,1);
end;

procedure TST2829C.SetAutoLevelControl(const Value: boolean);
begin
  fAutoLevelControlEnable := Value and ValueInMap(fVrmsMeas,ST2829C_VmrsMeasLimitsForAL)
                                   and ValueInMap(fIrmsMeas,ST2829C_ImrsMeasLimitsForAL);
end;

procedure TST2829C.SetAutoLevelEnable(toOn: boolean);
begin
//AMPL:ALC ON|OFF
 SetPattern([Pointer(st_aALE),@toOn]);
end;

procedure TST2829C.SetAverTime(AverTime: byte);
begin
//APER <MeasSpeed>, <AverTime>
 SetPattern([Pointer(st_aAverTimes),@AverTime]);
end;

procedure TST2829C.SetBiasCurrent(I: double);
begin
//BIAS:CURR <I>
 SetPattern([Pointer(st_aBiasCur),@I]);
end;

procedure TST2829C.SetBiasEnable(toOn: boolean);
begin
//BIAS:STAT ON|OFF
 SetPattern([Pointer(st_aBiasEn),@toOn]);
end;

procedure TST2829C.SetBiasVoltage(V: double);
begin
//BIAS:VOLT <V>
 SetPattern([Pointer(st_aBiasVol),@V]);
end;

procedure TST2829C.SetCurrentMeasurement(I: double);
begin
//CURR <I>mA
 SetPattern([Pointer(st_aIMeas),@I]);
end;

procedure TST2829C.SetDelayTime(Time: Integer);
begin
//TRIG:DEL Time
 SetPattern([Pointer(st_aTrigDelay),@Time]);
end;

procedure TST2829C.SetDisplayFont(Font: TST2829C_Font);
begin
 //DISP:FRON <Font>
 SetPattern([Pointer(st_aChangFont),Pointer(Font)]);
// fAdditionalString:=TST2829C_FontCommand[Font];
// SetupOperation(4,3);
end;

procedure TST2829C.SetDisplayPage(Page: TST2829C_DisplayPage);
begin
//DISP:PAGE <Page>
 SetPattern([Pointer(st_aDispPage),Pointer(Page)]);
// fAdditionalString:=TST2829C_DisplayPageCommand[Page];
// SetupOperation(4,2);
end;

procedure TST2829C.SetFreqMeas(Value: Double);
begin
 fFreqMeas:=NumberMap(Value,ST2829C_FreqMeasLimits);
 fFreqMeas:=ValueWithMinResolution(fFreqMeas,1e-3);
end;

procedure TST2829C.SetFrequancyMeasurement(Freq: double);
begin
//FREQ <Freq>
 SetPattern([Pointer(st_aFreqMeas),@Freq]);
end;

procedure TST2829C.SetIrmsMeas(const Value: double);
begin
 fIrmsMeas:=NumberMap(Value,ST2829C_ImrsMeasLimits);
 if not(ValueInMap(fIrmsMeas,ST2829C_ImrsMeasLimitsForAL))
   then fAutoLevelControlEnable:=False;
 fIrmsMeas:=ValueWithMinResolution(fIrmsMeas,1e-4);
end;

procedure TST2829C.SetMeasureFunction(MF: TST2829C_MeasureType);
begin
//FUNC:IMP <MF>
 SetPattern([Pointer(st_aSetMeasT),Pointer(MF)]);
end;

procedure TST2829C.SetMeasureSpeed(Speed: TST2829C_MeasureSpeed);
begin
//APER <Speed>
 SetPattern([Pointer(st_aSpeedMeas),Pointer(Speed)]);
end;

procedure TST2829C.SetOutputImpedance(OI: TST2829C_OutputImpedance);
begin
//ORES <OI>
 SetPattern([Pointer(st_aOutImp),Pointer(OI)]);
end;

procedure TST2829C.SetPrepareAction(Ps: array of Pointer);
  var tempstr:string;
      Action: TST2829CAction;
begin
 Action:=TST2829CAction(Ps[0]);
 case Action of
   st_aMemLoad: fAdditionalString:=inttostr(TST2829C_SetupMemoryRecord(Ps[1]));
   st_aDispPage:fAdditionalString:=ST2829C_DisplayPageCommand[TST2829C_DisplayPage(Ps[1])] ;
   st_aChangFont:fAdditionalString:=ST2829C_FontCommand[TST2829C_Font(Ps[1])];
   st_aFreqMeas:begin
                FreqMeas:=PDouble(Ps[1])^;
                fAdditionalString:=FloatToStrF(FreqMeas,ffGeneral,7,0)+'Hz';
                end;
   st_aALE:begin
                AutoLevelControlEnable:=PBoolean(Ps[1])^;
                OnOffFromBool(AutoLevelControlEnable)
           end;
   st_aVMeas:begin
                VrmsMeas:=PDouble(Ps[1])^;
                fAdditionalString:=FloatToStrF(VrmsMeas,ffGeneral,7,0)+'V';
              end;
   st_aIMeas:begin
                IrmsMeas:=PDouble(Ps[1])^;
                fAdditionalString:=FloatToStrF(IrmsMeas,ffGeneral,7,0)+'mA';
             end;
   st_aMemSave:begin
               fAdditionalString:=inttostr(TST2829C_SetupMemoryRecord(Ps[1]));
               tempstr:=PString(Ps[2])^;
               if Length(tempstr)>0 then
                begin
                  if Length(tempstr)>ST2829C_MemFileMaxLength then SetLength(tempstr,ST2829C_MemFileMaxLength);
                  fAdditionalString:=fAdditionalString+', '+StringToInvertedCommas(tempstr);
                end;
               end;
   st_aBiasEn:begin
                BiasEnable:=PBoolean(Ps[1])^;
                if BiasEnable then OutputImpedance:=st_oi100;
                OnOffFromBool(BiasEnable);
              end;
   st_aBiasVol:begin
                BiasVoltageValue:=PDouble(Ps[1])^;
                fAdditionalString:=FloatToStrF(BiasVoltageValue,ffGeneral,7,0);
               end;
   st_aBiasCur:begin
                BiasCurrentValue:=PDouble(Ps[1])^;
                fAdditionalString:=FloatToStrF(BiasCurrentValue/1000,ffGeneral,7,0);
               end;
   st_aOutImp:begin
               OutputImpedance:=TST2829C_OutputImpedance(Ps[1]);
               fAdditionalString:=EnumerateToString(Action);
              end;
   st_aSetMeasT:begin
                 MeasureType:=TST2829C_MeasureType(Ps[1]);
                 fAdditionalString:=ST2829C_MeasureTypeCommands[TST2829C_MeasureType(Ps[1])];
                end;
    st_aRange:begin
                MeasureRange:=TST2829C_Range(Ps[1]);
                if MeasureRange=st_rAuto
                  then OnOffFromBool(True)
                  else fAdditionalString:=EnumerateToString(Action)+'Ohm';
              end;
    st_aVrmsToMeas:begin
                    VrmsToMeasure:=PBoolean(Ps[1])^;
                    OnOffFromBool(VrmsToMeasure);
                   end;
    st_aIrmsToMeas:begin
                    IrmsToMeasure:=PBoolean(Ps[1])^;
                    OnOffFromBool(VrmsToMeasure);
                   end;
    st_aSpeedMeas:begin
                  MeasureSpeed:=TST2829C_MeasureSpeed(Ps[1]);
                  fAdditionalString:=ST2829C_MeasureSpeedCommands[MeasureSpeed];
                  end;
    st_aAverTimes:begin
                  AverTimes:=PByte(Ps[1])^;
                  fAdditionalString:=ST2829C_MeasureSpeedCommands[MeasureSpeed]
                         +', '+Inttostr(AverTimes);
                  end;
    st_aTrigSource:begin
                   TrigSource:=TST2829C_TrigerSource(Ps[1]);
                   fAdditionalString:=ST2829C_TrigerSourceCommands[TrigSource];
                   end;
    st_aTrigDelay:begin
                   DelayTime:=PInteger(Ps[1])^;
                   fAdditionalString:=FloatToStrF(DelayTime/1000,ffGeneral,5,0);
                  end
   else;
 end;
//
//
//
//  case Action of
//   st_aMemSave:begin
//               fAdditionalString:=inttostr(TST2829C_SetupMemoryRecord(Ps[0]));
//               tempstr:=PString(Ps[1])^;
//               if Length(tempstr)>0 then
//                begin
//                  if Length(tempstr)>ST2829C_MemFileMaxLength then SetLength(tempstr,ST2829C_MemFileMaxLength);
//                  fAdditionalString:=fAdditionalString+', '+StringToInvertedCommas(tempstr);
//                end;
//               end;
//   st_aChangFont: ;
//   else;
// end;
end;

procedure TST2829C.SetRange(Range: TST2829C_Range);
begin
//FUNC:IMP:RANG <Range>
//FUNC:IMP:RANG:AUTO ON|OFF
 SetPattern([Pointer(st_aRange),Pointer(Range)]);
end;

procedure TST2829C.SetTrigerSource(Source: TST2829C_TrigerSource);
begin
//TRIG:SOUR <Source>
 SetPattern([Pointer(st_aTrigSource),Pointer(Source)]);
end;

procedure TST2829C.SetIrmsToMeasure(toOn: boolean);
begin
//FUNC:SMON:IAC ON|OFF
 SetPattern([Pointer(st_aIrmsToMeas),@toOn]);
end;

procedure TST2829C.SetVrmsToMeasure(toOn: boolean);
begin
//FUNC:SMON:VAC ON|OFF
 SetPattern([Pointer(st_aVrmsToMeas),@toOn]);
end;

//procedure TST2829C.SetPrepareAction(Action: TST2829CAction; P: Pointer);
//begin
//  case Action of
//   st_aMemLoad: fAdditionalString:=inttostr(TST2829C_SetupMemoryRecord(P));
//   st_aDispPage:fAdditionalString:=TST2829C_DisplayPageCommand[TST2829C_DisplayPage(P)] ;
//   st_aChangFont:fAdditionalString:=TST2829C_FontCommand[TST2829C_Font(P)];
//   st_aFreqMeas:begin
//                FreqMeas:=PDouble(P)^;
//                fAdditionalString:=FloatToStrF(FreqMeas,ffGeneral,7,0)+'Hz';
//                end;
//   st_aALE:begin
//                AutoLevelControlEnable:=PBoolean(P)^;
//                OnOffFromBool(AutoLevelControlEnable)
//                end;
//   st_aVMeas:begin
//                VrmsMeas:=PDouble(P)^;
//                fAdditionalString:=FloatToStrF(VrmsMeas,ffGeneral,7,0)+'V';
//                end;
//   st_aIMeas:begin
//                IrmsMeas:=PDouble(P)^;
//                fAdditionalString:=FloatToStrF(IrmsMeas,ffGeneral,7,0)+'mA';
//                end;
//   else;
// end;
//end;

//procedure TST2829C.SetPattern(Action: TST2829CAction; Ps: array of Pointer);
//begin
// SetPrepareAction(Action,Ps);
// SetupOperation(ActionToRootNodeNumber(Action),ActionToFirstNode(Action),
//                ActionToLeafNode(Action),ActionToSyffix(Action));
//end;

procedure TST2829C.SetVoltageMeasurement(V: double);
begin
//VOLT <V>V
 SetPattern([Pointer(st_aVMeas),@V]);
end;

procedure TST2829C.SetVrmsMeas(const Value: double);
begin
 fVrmsMeas:=NumberMap(Value,ST2829C_VmrsMeasLimits);
 if not(ValueInMap(fVrmsMeas,ST2829C_VmrsMeasLimitsForAL))
   then fAutoLevelControlEnable:=False;
 fVrmsMeas:=ValueWithMinResolution(fVrmsMeas,1e-3);
end;

procedure TST2829C.StAverTimes(const Value: byte);
begin
 fAverTimes:=NumberMap(Value,ST2829C_AverTimes);
end;

procedure TST2829C.StBiasCurrentValue(const Value: double);
begin
 fBiasCurrentValue:=NumberMap(Value,ST2829C_BiasCurrentLimits);
 fBiasCurrentValue:=ValueWithMinResolution(fBiasCurrentValue,5e-3);
end;

procedure TST2829C.StBiasVoltageValue(const Value: double);
begin
 fBiasVoltageValue:=NumberMap(Value,ST2829C_BiasVoltageLimits);
 fBiasVoltageValue:=ValueWithMinResolution(fBiasVoltageValue,5e-4);
end;

procedure TST2829C.StDelayTime(const Value: integer);
begin
 fDelayTime:=NumberMap(Value,ST2829C_DelayTime);
end;

procedure TST2829C.StrToData(Str: string);
begin
  try
  Str:=SomeSpaceToOne(AnsiReplaceStr(Str,',',' '));
  fPrimaryData:=FloatDataFromRow(Str,1);
  fSecondaryData:=FloatDataFromRow(Str,2);
  fDevice.Value:=fPrimaryData;
  except
  fPrimaryData:=ErResult;
  fSecondaryData:=ErResult;
  end;
end;

function TST2829C.SuccessfulGet(Action: TST2829CAction): boolean;
begin
  Result:=(fDevice.Value<>ErResult);
  case Action of
    st_aFreqMeas: Result:=((fDevice.Value<>ErResult)and(fDevice.isReceived));
//    st_aRange:Result:=(round(fDevice.Value) in [0,1,10,30,100,300]);
//                                        1000,3000]);
//                                        ,10000,30000,
//                                        100000,300000,1000000]);
  end;
end;

procedure TST2829C.SetPattern(Ps: array of Pointer);
 var  Action: TST2829CAction;
begin
 Action:=TST2829CAction(Ps[0]);
 if PermitedAction(Action) then
 begin
   SetPrepareAction(Ps);
   SetupOperation(ActionToRootNodeNumber(Action),ActionToFirstNode(Action),
                  ActionToLeafNode(Action),ActionToSyffix(Action));
 end;
end;

procedure TST2829C.Trig;
begin
//  *TRG
//  SetPattern([Pointer(st_aTrg)]);
  GetPattern(Pointer(st_aTrg));
end;

procedure TST2829C.Trigger;
begin
// TRIG
 SetPattern([Pointer(st_aTriger)]);
end;

function TST2829C.ValueToOrd(Value: double; Action: TST2829CAction): integer;
begin
 case Action of
   st_aOutImp:case round(Value) of
//                 10:Result:=0;
                 30:Result:=0;
                 50:Result:=1;
                 100:Result:=2;
                 else Result:=-1;
              end ;
   else Result:=-1;
 end;
end;

{ T2829CDevice }


{ TST2829CDevice }

procedure TST2829CDevice.CreateDataSubject(CP: TComPort);
begin
 fDataSubject:=TDataSubject_ST2829C.Create(CP);
end;



{ TDataSubject_ST2829C }

procedure TDataSubject_ST2829C.ComPortCreare(CP: TComPort);
begin
 fRS232:=TRS232_ST2829C.Create(CP);
end;

{ TRS232_ST2829C }

constructor TRS232_ST2829C.Create(CP: TComPort);
begin
 inherited Create(CP,250052,250052);
// fComPort.DataBits:=dbEight;
// fComPort.StopBits:=sbOneStopBit;
// fComPort.Parity.Bits:=prNone;
end;


initialization
  ST_2829C := TST2829C.Create();

finalization
  ST_2829C.Free;

end.
