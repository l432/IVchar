unit ST2829C;

interface

uses
  SCPI, CPort, RS232deviceNew;

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
//   fRS232:TRS232MeterDeviceSingle;
   fComPort:TComPort;
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
  protected
//   fTelnet:TIdTelnet;
//   fIPAdressShow: TIPAdressShow;
//   fMeasureFunction:TKeitley_Measure;
//   fTimeValue:double;
//   fTrigBlockNumber:word;
//   fCount:integer;
//   fMeter:TKeitley_Meter;
//   procedure MeterCreate;virtual;abstract;
   procedure PrepareString;override;
   procedure PrepareStringByRootNode;
   procedure DeviceCreate(Nm:string);override;
   procedure ProcessingStringByRootNode(Str:string);
//   procedure DefaultSettings;override;
//   function StringToMeasureFunction(Str:string):boolean;//virtual;
//   function StringToDigMeasureFunction(Str:string):boolean;
//   function StringToTrigerState(Str:string):boolean;
//   function MeasureToRootNodeNumber(Measure:TKeitley_Measure):byte;
//   function MeasureToRootNodeStr(Measure:TKeitley_Measure):string;
//   function MeasureToFunctString(Measure:TKeitley_Measure):string;
//   procedure StringToMesuredData(Str:string;DataType:TKeitley_ReturnedData);
//   procedure AdditionalDataFromString(Str:string);virtual;abstract;
//   procedure StringToMesuredDataArray(Str:string;DataType:TKeitley_ReturnedData);
//   procedure AdditionalDataToArrayFromString;virtual;abstract;
//
//   function StringToMeasureTime(Str:string):double;
//   function GetMeasureFunctionValue:TKeitley_Measure;virtual;
//   procedure SetCountNumber(Value:integer);virtual;
//   procedure OnOffFromBool(toOn:boolean);
  public
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
     Constructor Create(CP:TComPort;Nm:string='ST2829C');
//   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
//               Nm:string);
//   destructor Destroy; override;
////
//   function Test():boolean;override;
   procedure ProcessingString(Str:string);override;
//   procedure ResetSetting();
//   procedure MyTraining();virtual;
//   procedure ClearUserScreen();
//   procedure TextToUserScreen(top_text:string='';bottom_text:string='');
//
//   procedure SaveSetup(SlotNumber:TKeitley_SetupMemorySlot);
//   procedure LoadSetup(SlotNumber:TKeitley_SetupMemorySlot);
//   procedure LoadSetupPowerOn(SlotNumber:TKeitley_SetupMemorySlot);
//   procedure UnloadSetupPowerOn();
//   procedure RunningMacroScript(ScriptName:string);
//
//   function GetTerminal():boolean;
////   {����� �� ������� �� ����� ������}
////
//   procedure SetAzeroState(Measure:TKeitley_Measure;
//                              toOn:boolean);overload;
//   {�� ������������ ����� �������� ����� ������ ������}
//   procedure SetAzeroState(toOn:boolean);overload;virtual;
//   procedure AzeroOnce();
//   {��������� �������� �������� ��������}
//   procedure SetMeasureFunction(MeasureFunc:TKeitley_Measure=kt_mCurDC);virtual;
//   {�� ���� ���� ��������� ������}
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
  SysUtils, ST2829CConst;

{ T2829C }

constructor TST2829C.Create(CP: TComPort; Nm: string);
begin
 fComPort:=CP;
 inherited Create(Nm);
// inherited Create;
// fName:=Nm;
// DeviceCreate(Nm);
// DefaultSettings();
// SetFlags(0,0,0);

// fBuffer:=TKeitley_Buffer.Create;
// fDataVector:=TVector.Create;
// fDataTimeVector:=TVector.Create;
// MeterCreate;


end;

procedure TST2829C.DeviceCreate(Nm: string);
begin
  fDevice:=TST2829CDevice.Create(Self,fComPort,Nm);
end;

procedure TST2829C.PrepareString;
begin
// (fDevice as TKeitleyDevice).ClearStringToSend;
 (fDevice as TST2829CDevice).SetStringToSend(RootNodeST2829C[fRootNode]);

 PrepareStringByRootNode;

// if fIsSuffix then JoinAddString;
end;

procedure TST2829C.PrepareStringByRootNode;
begin

end;

procedure TST2829C.ProcessingString(Str: string);
begin
 Str:=Trim(Str);
 ProcessingStringByRootNode(Str);
end;

procedure TST2829C.ProcessingStringByRootNode(Str: string);
begin
 case fRootNode of
  0:if pos(ST2829C_Test,Str)<>0 then fDevice.Value:=314;
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
 fComPort.DataBits:=dbEight;
 fComPort.StopBits:=sbOneStopBit;
 fComPort.Parity.Bits:=prNone;
end;

end.
