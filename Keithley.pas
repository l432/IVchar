unit Keithley;

interface

uses
  TelnetDevice, SCPI, IdTelnet, ShowTypes;

type

 TKeitleyDevice=class(TTelnetMeterDeviceSingle)
  private
   fSCPI:TSCPInew;
  protected
   procedure UpDate();override;
  public
   Constructor Create(SCPInew:TSCPInew;Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string);
 end;

 TKeitley=class(TSCPInew)
  private

//   fIsTripped:boolean;
//
//   fTerminal:TKt2450_OutputTerminals;
//   fOutPutOn:boolean;
//   fResistanceCompencateOn:TKt2450_MeasureBool;
//   fAzeroState:TKt2450_MeasureBool;
//   fReadBack:TKt2450_SourceBool;
//   fHighCapacitance:TKt2450_SourceBool;
//   fSences:TKt2450_Senses;
//   fMeasureUnits:TKt_2450_MeasureUnits;
//   fOutputOffState:TKt_2450_OutputOffStates;
//   fSourceType:TKt2450_Source;
//   fMeasureFunction:TKt2450_Measure;
//   fVoltageProtection:TKt_2450_VoltageProtection;
//   fVoltageLimit:double;
//   fCurrentLimit:double;
//   fMode:TKt_2450_Mode;
//   fSourceVoltageRange:TKt2450VoltageRange;
//   fSourceCurrentRange:TKt2450CurrentRange;
//   fMeasureVoltageRange:TKt2450VoltageRange;
//   fMeasureCurrentRange:TKt2450CurrentRange;
//   fMeasureVoltageLowRange:TKt2450VoltageRange;
//   fMeasureCurrentLowRange:TKt2450CurrentRange;
//   fSourceDelay:TKt2450_SourceDouble;
//   fSourceValue:TKt2450_SourceDouble;
//   fSourceDelayAuto:TKt2450_SourceBool;
//   fMeasureTime:TKt2450_MeasureDouble;
//   fDisplayDN:TKt2450_MeasureDisplayDN;
//   fDataVector:TVector;
//   {X - �������� �������; Y - ��������� �����}
//   fDataTimeVector:TVector;
//   {X - ��� ����� (��������� � ������� ����); Y - ��������� �����}
//   fBuffer:TKt2450_Buffer;
//   fCount:integer;
//   fSourceMeasuredValue:double;
//   fTimeValue:double;
//   {��� �����, � ���������� � ������� ����}
//   fDigitLineType:TKt2450_DigLineTypes;
//   fDigitLineDirec:TKt2450_DigLineDirections;
//   fDLActive:TKt2450_DigLines;
//   fMeter:TKT2450_Meter;
//   fSourceMeter:TKT2450_SourceMeter;
//   fSourceDevice:TKT2450_SourceDevice;
//   fDisplayState:TKt2450_DisplayState;
//   fHookForTrigDataObtain: TSimpleEvent;
//   fTrigBlockNumber:word;
//   fDragonBackTime:double;
//   fToUseDragonBackTime:boolean;
//   fImax:double;
//   fImin:double;
//   FCurrentValueLimitEnable:boolean;
//   fSweepWasCreated:boolean;
//   procedure OnOffFromBool(toOn:boolean);
//   function StringToVoltageProtection(Str:string;var vp:TKt_2450_VoltageProtection):boolean;
//   function StringToSourceType(Str:string):boolean;
//   function StringToMeasureFunction(Str:string):boolean;
//   function StringToTerminals(Str:string):boolean;
//   function StringToOutPutState(Str:string):boolean;
//   function StringToMeasureUnit(Str:string):boolean;
//   function StringToBufferIndexies(Str:string):boolean;
//   function StringToDisplayBrightness(Str:string):boolean;
//   procedure StringToDigLineStatus(Str:string);
//   procedure StringToArray(Str:string);
//   procedure StringToMesuredData(Str:string;DataType:TKt2450_ReturnedData);
//   procedure StringToMesuredDataArray(Str:string;DataType:TKt2450_ReturnedData);
//   function StringToMeasureTime(Str:string):double;
//   function IsLimitExcided(FirstLevelNode,LeafNode:byte):boolean;
//   {������ ������� ��� ������, �� ������� ������ ���� �������}
//   function ModeDetermination:TKt_2450_Mode;
//   function ValueToVoltageRange(Value:double):TKt2450VoltageRange;
//   function VoltageRangeToString(Range:TKt2450VoltageRange):string;
//   function ValueToCurrentRange(Value:double):TKt2450CurrentRange;
//   function CurrentRangeToString(Range:TKt2450CurrentRange):string;
//   procedure SetCountNumber(Value:integer);
//   procedure TrigIVLoop(i: Integer);
  protected
   fTelnet:TIdTelnet;
   fIPAdressShow: TIPAdressShow;
//   procedure PrepareString;override;
//   procedure DeviceCreate(Nm:string);override;
//   procedure DefaultSettings;override;
  public
//   SweepParameters:array[TKt2450_Source]of TKt_2450_SweepParameters;
//   property HookForTrigDataObtain:TSimpleEvent read fHookForTrigDataObtain write fHookForTrigDataObtain;
//   property DataVector:TVector read fDataVector;
//   property DataTimeVector:TVector read fDataTimeVector;
//   property SourceType:TKt2450_Source read fSourceType;
//   property MeasureFunction:TKt2450_Measure read fMeasureFunction;
//   property VoltageProtection:TKt_2450_VoltageProtection read fVoltageProtection;
//   property VoltageLimit:double read fVoltageLimit;
//   property CurrentLimit:double read fCurrentLimit;
//   property Terminal:TKt2450_OutputTerminals read fTerminal;
//   property OutPutOn:boolean read fOutPutOn write fOutPutOn;
//   property ResistanceCompencateOn:TKt2450_MeasureBool read fResistanceCompencateOn;
//   property ReadBack:TKt2450_SourceBool read fReadBack;
//   property HighCapacitance:TKt2450_SourceBool read fHighCapacitance;
//   property Sences:TKt2450_Senses read fSences;
//   property MeasureUnits:TKt_2450_MeasureUnits read fMeasureUnits;
//   property OutputOffState:TKt_2450_OutputOffStates read fOutputOffState;
//   property Mode:TKt_2450_Mode read fMode;
//   property SourceVoltageRange:TKt2450VoltageRange read fSourceVoltageRange;
//   property SourceCurrentRange:TKt2450CurrentRange read fSourceCurrentRange;
//   property MeasureVoltageRange:TKt2450VoltageRange read fMeasureVoltageRange;
//   property MeasureCurrentRange:TKt2450CurrentRange read fMeasureCurrentRange;
//   property MeasureVoltageLowRange:TKt2450VoltageRange read fMeasureVoltageLowRange;
//   property MeasureCurrentLowRange:TKt2450CurrentRange read fMeasureCurrentLowRange;
//   property AzeroState:TKt2450_MeasureBool read fAzeroState;
//   property SourceDelay:TKt2450_SourceDouble read fSourceDelay;
//   property SourceValue:TKt2450_SourceDouble read fSourceValue;
//   property SourceDelayAuto:TKt2450_SourceBool read fSourceDelayAuto;
//   property DisplayDN:TKt2450_MeasureDisplayDN read fDisplayDN;
//   property MeasureTime:TKt2450_MeasureDouble read fMeasureTime;
//   property Buffer:TKt2450_Buffer read fBuffer;
//   property Count:integer read fCount write SetCountNumber;
//   property SourceMeasuredValue:double read fSourceMeasuredValue;
//   property TimeValue:double read fTimeValue;
//   property DigitLineType:TKt2450_DigLineTypes read fDigitLineType;
//   property DigitLineTypeDirec:TKt2450_DigLineDirections read fDigitLineDirec;
//   property Meter:TKT2450_Meter read fMeter;
//   property SourceMeter:TKT2450_SourceMeter read fSourceMeter;
//   property SourceDevice:TKT2450_SourceDevice read fSourceDevice;
//   property DisplayState:TKt2450_DisplayState read fDisplayState;
//   property DragonBackTime:double read fDragonBackTime write fDragonBackTime;
//   property ToUseDragonBackTime:boolean read fToUseDragonBackTime write fToUseDragonBackTime;
//   property Imax:double read fImax write fImax;
//   property Imin:double read FImin write FImin;
//   property CurrentValueLimitEnable:boolean read FCurrentValueLimitEnable write FCurrentValueLimitEnable;
//   property SweepWasCreated:boolean read fSweepWasCreated write fSweepWasCreated;
   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string);
//   destructor Destroy; override;
//
//   function Test():boolean;override;
//   procedure ProcessingString(Str:string);override;
//   procedure ResetSetting();
//   procedure MyTraining();
//
//   procedure OutPutChange(toOn:boolean);
//   {�����/������ ����� �������}
//   function  IsOutPutOn():boolean;
//
//   procedure SetInterlockStatus(toOn:boolean);
//   function IsInterlockOn():boolean;
//
//   procedure ClearUserScreen();
//   procedure TextToUserScreen(top_text:string='';bottom_text:string='');
//
//   procedure SaveSetup(SlotNumber:TKt2450_SetupMemorySlot);
//   procedure LoadSetup(SlotNumber:TKt2450_SetupMemorySlot);
//   procedure LoadSetupPowerOn(SlotNumber:TKt2450_SetupMemorySlot);
//   procedure UnloadSetupPowerOn();
//   procedure RunningMacroScript(ScriptName:string);
//
//   procedure SetTerminal(Terminal:TKt2450_OutputTerminals);
//   {����� �� ������� �� ����� ������}
//   function GetTerminal():boolean;
//   {����� �� ������� �� ����� ������}
//
//   procedure SetSense(MeasureType:TKt2450_Measure;Sense:TKt2450_Sense);
//   {2-�������� �� 4-�������� ����� ����������}
//   function GetSense(MeasureType:TKt2450_Measure):boolean;
//   function GetSenses():boolean;
//
//
//   procedure SetOutputOffState(Source:TKt2450_Source;
//                           OutputOffState:TKt_2450_OutputOffState);
//   {����������� ���� ������ �������,
//   ���� ���� �� �������� �����: ����������, ���������������� ����}
//   function GetOutputOffState(Source:TKt2450_Source):boolean;
//   function GetOutputOffStates():boolean;
//
//   procedure SetReadBackState(Source:TKt2450_Source;
//                              toOn:boolean);overload;
//   {�� ���������� �� ��������, �� �������� � �������;
//   ���� � - �� ���� ����������������� (� �����������, ����)
//   ��������, ��� �����������}
//   procedure SetReadBackState(toOn:boolean);overload;
//   function IsReadBackOn(Source:TKt2450_Source):boolean;overload;
//   function IsReadBackOn():boolean;overload;
//   function GetReadBacks():boolean;
//
//   procedure SetHighCapacitanceState(Source:TKt2450_Source;
//                              toOn:boolean);overload;
//   {�������������� ������������ ���� ������}
//   procedure SetHighCapacitanceState(toOn:boolean);overload;
//   function IsHighCapacitanceOn(Source:TKt2450_Source):boolean;overload;
//   function IsHighCapacitanceOn():boolean;overload;
//   function GetHighCapacitanceStates():boolean;
//
//
//   procedure SetAzeroState(Measure:TKt2450_Measure;
//                              toOn:boolean);overload;
//   {�� ������������ ����� �������� ����� ������ ������}
//   procedure SetAzeroState(toOn:boolean);overload;
//   function IsAzeroStateOn(Measure:TKt2450_Measure):boolean;overload;
//   function IsAzeroStateOn():boolean;overload;
//   function GetAzeroStates():boolean;
//   procedure AzeroOnce();
//   {��������� �������� �������� ��������}
//
//   procedure SetResistanceCompencate(toOn:boolean);
//   {���������/��������� ����������� �����}
//   function IsResistanceCompencateOn():boolean;
//
//   procedure SetVoltageProtection(Level:TKt_2450_VoltageProtection);
//   {������������ �������� ������� �� �����������}
//   function  GetVoltageProtection():boolean;
//   {����� ������ ������ � TKt_2450_VoltageProtection}
//   function IsVoltageProtectionActive():boolean;
//   {��������, �� �������� ������ �� �����������}
//
//   procedure SetVoltageLimit(Value:double=0);
//   {������������ �������� ������� �������}
//   procedure SetCurrentLimit(Value:double=0);
//   {������������ ���������� ������ �������}
//   function  GetVoltageLimit():boolean;
//   {����� �������� �������� ������� �������}
//   function  GetCurrentLimit():boolean;
//   {����� �������� �������� ������� �������}
//   function IsVoltageLimitExceeded():boolean;
//   {��������, �� ���� ������ ����������� �������}
//   function IsCurrentLimitExceeded():boolean;
//   {��������, �� ���� ������ ����������� �������}
//
//   procedure SetSourceType(SourseType:TKt2450_Source=kt_sVolt);
//   {������ �� ������� ������� �� ������;
//   ��� ����� ����� ����������� OutPut=Off}
//   function GetSourceType():boolean;
//
//   procedure SetMeasureFunction(MeasureFunction:TKt2450_Measure=kt_mCurrent);
//   {������ ������ ������� �� �����}
//   function GetMeasureFunction():boolean;
//
//   procedure SetMeasureUnit(Measure:TKt2450_Measure; MeasureUnit:TKt_2450_MeasureUnit);
//   {�� ���� ��������� (�������������) ��� �������� ������ Measure}
//   function GetMeasureUnit(Measure:TKt2450_Measure):boolean;
//   function GetMeasureUnits():boolean;
//
//   procedure SetMeasureTime(Measure:TKt2450_Measure; Value:double);overload;
//   {��� �� ��������� []=��, �������� ������� - (0,2-200)}
//   procedure SetMeasureTime(Value:double);overload;
//   function GetMeasureTime(Measure:TKt2450_Measure):boolean;overload;
//   function GetMeasureTime():boolean;overload;
//   function GetMeasureTimes():boolean;
//
//   procedure SetDisplayDigitsNumber(Measure:TKt2450_Measure; Number:Kt2450DisplayDigitsNumber);overload;
//   {������� ����, �� ������������� �� �����,
//     �� ������� ������ ���������� �� ������}
//   procedure SetDisplayDigitsNumber(Number:Kt2450DisplayDigitsNumber);overload;
//   function GetDisplayDigitsNumber(Measure:TKt2450_Measure):boolean;overload;
//   function GetDisplayDigitsNumber():boolean;overload;
//   function GetDisplayDNs():boolean;
//
//
//   procedure SetMode(Mode:TKt_2450_Mode);
//   function GetDeviceMode():boolean;
//
//   procedure SetSourceVoltageRange(Range:TKt2450VoltageRange=kt_vrAuto);
//   function GetSourceVoltageRange():boolean;
//   procedure SetSourceCurrentRange(Range:TKt2450CurrentRange=kt_crAuto);
//   function GetSourceCurrentRange():boolean;
//   function GetSourceRanges():boolean;
//
//   procedure SetMeasureVoltageRange(Range:TKt2450VoltageRange=kt_vrAuto);
//   function GetMeasureVoltageRange():boolean;
//   procedure SetMeasureCurrentRange(Range:TKt2450CurrentRange=kt_crAuto);
//   function GetMeasureCurrentRange():boolean;
//   function GetMeasureRanges():boolean;
//
//   procedure SetMeasureVoltageLowRange(Range:TKt2450VoltageRange=kt_vr20mV);
//   {���� ����������� ������������ ����� �������� ��� ���������,
//   ����� ���������� ��������� �������, � ����� ��������������
//   ����� ���������}
//   function GetMeasureVoltageLowRange():boolean;
//   procedure SetMeasureCurrentLowRange(Range:TKt2450CurrentRange=kt_cr10nA);
//   function GetMeasureCurrentLowRange():boolean;
//   function GetMeasureLowRanges():boolean;
//
//
//   procedure SetSourceValue(Source:TKt2450_Source;
//                            value:double);overload;
//   {�������� �������, ���� ������� �'�������
//   ���� ���� ��������� OutPut, ���� ���
//   �������� - �'������� ������}
//   procedure SetSourceValue(value:double);overload;
//   function GetSourceValue(Source:TKt2450_Source):boolean;overload;
//   function GetSourceValue():boolean;overload;
//   function GetSourceValues():boolean;
//
//   procedure SetSourceDelay(Source:TKt2450_Source;
//                            value:double);overload;
//   {��� �������� �� ������������� �������� �������
//   �� �������� ����������}
//   procedure SetSourceDelay(value:double);overload;
//   function GetSourceDelay(Source:TKt2450_Source):boolean;overload;
//   function GetSourceDelay():boolean;overload;
//   function GetSourceDelays():boolean;
//   procedure SetSourceDelayAuto(Source:TKt2450_Source;
//                            toOn:boolean);overload;
//   {��� �������� �� ������������� �������� �������
//   �� �������� ����������}
//   procedure SetSourceDelayAuto(toOn:boolean);overload;
//   function IsSourceDelayAutoOn(Source:TKt2450_Source):boolean;overload;
//   function IsSourceDelayAutoOn():boolean;overload;
//   function GetSourceDelayAutoOns():boolean;
//
//   procedure SourceListCreate(Source:TKt2450_Source;ListValues:TArrSingle);overload;
//   {��������� ������ ������� �������, �� ������ ����������������� �� ���
//   ����������� ���������}
//   procedure SourceListCreate(ListValues:TArrSingle);overload;
//   function GetSourceList(Source:TKt2450_Source):boolean;overload;
//   {������� �������� �������������� � DataVector.X �� DataVector.Y}
//   function GetSourceList():boolean;overload;
//   procedure SourceListAppend(Source:TKt2450_Source;ListValues:TArrSingle);overload;
//   {�������� ��������� �� ������ ������� �������, �� ������ ����������������� �� ���
//   ����������� ���������}
//   procedure SourceListAppend(ListValues:TArrSingle);overload;
//
//   procedure SwepLinearPointCreate();
//   procedure SwepLinearStepCreate();
//   procedure SwepListCreate(StartIndex:word=1);
//   procedure SwepLogStepCreate();
//
//   procedure BufferCreate();overload;
//   procedure BufferCreate(Name:string);overload;
//   procedure BufferCreate(Name:string;Size:integer);overload;
//   procedure BufferCreate(Name:string;Size:integer;Style:TKt2450_BufferStyle);overload;
//   procedure BufferCreate(Style:TKt2450_BufferStyle);overload;
//   procedure BufferDelete();overload;
//   procedure BufferDelete(Name:string);overload;
//   procedure BufferClear();overload;
//   procedure BufferClear(BufName:string);overload;
//
//   procedure BufferReSize(NewSize:integer);overload;
//   {����� ������� ������� ������ � �����,
//   ��� ����� �� ���������}
//   procedure BufferReSize(BufName:string;NewSize:integer);overload;
//   function BufferGetSize():integer;overload;
//   function BufferGetSize(BufName:string):integer;overload;
//   function BufferGetReadingNumber(BufName:string=Kt2450DefBuffer):integer;
//   {������� ������� ������� ������ � �����}
//   function BufferGetStartEndIndex(BufName:string=Kt2450DefBuffer):boolean;
//   {������� ���������� �� ������� ������� ��������
//   � ����� ������, ���� ��� ����� ���� �����������
//   � Buffer.StartIndex �� Buffer.EndIndex}
//
//   procedure BufferSetFillMode(FillMode:TKt2450_BufferFillMode);overload;
//   procedure BufferSetFillMode(BufName:string;FillMode:TKt2450_BufferFillMode);overload;
//   function BufferGetFillMode():boolean;overload;
//   function BufferGetFillMode(BufName:string):boolean;overload;
//   Procedure BufferLastDataSimple();overload;
//   {��� ���������� ������������ ��������� ����������
//   ����������, �� ���������� � defbuffer1,
//   ���������� � fDevice.Value}
//   Procedure BufferLastDataSimple(BufName:string);overload;
//   {��������� ���������� ����������� ����������
//   ��������� � ������ BufName}
//   Procedure BufferLastDataExtended(DataType:TKt2450_ReturnedData=kt_rd_MS;
//                            BufName:string=Kt2450DefBuffer);
//   {�� ��������, ����� ������� ����� �����
//   (���. TKt2450_ReturnedData) ���� ���������� �����}
//   Procedure BufferDataArrayExtended(SIndex,EIndex:integer;
//                     DataType:TKt2450_ReturnedData=kt_rd_MS;
//                     BufName:string=Kt2450DefBuffer);
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
//   function GetCount():boolean;
//
//   procedure SetDigLineMode(LineNumber:TKt2450_DigLines;
//                            LineType:TKt2450_DigLineType;
//                            Direction:TKt2450_DigLineDirection);
//   function GetDigLineMode(LineNumber:TKt2450_DigLines):boolean;
//   procedure SetDidLinOut(LineNumber:TKt2450_DigLines;HighLevel:boolean=True);
//   {���� ��� LineNumber �� kt_dt_dig �� kt_dd_out, ��
//   ��� �� ����� ���������� ������� �� ������� ���}
//   function GetDidLinOut(LineNumber:TKt2450_DigLines):integer;
//   {���� ��� LineNumber �� kt_dt_dig �� kt_dd_in, ��
//   ��� �� ����� ������� �������� ����;
//   Resul=1 ���� �������
//         0 ���� �������
//        -1 ���� �� �������� �������}
//
//   procedure SetDisplayBrightness(State:TKt2450_DisplayState);
//   function GetDisplayBrightness():boolean;
//
//   procedure Beep(Freq:word=600;Duration:double=0.1);
//   {���� �������� Freq �� �������� Duration ������}
//
//   procedure ConfigMeasureCreate(ListName:string=MyMeasList);
//   procedure ConfigSourceCreate(ListName:string=MySourceList);
//   procedure ConfigMeasureDelete(ListName:string=MyMeasList;ItemIndex:word=0);
//   {���� ItemIndex=0, �� ����������� ���� ������}
//   procedure ConfigSourceDelete(ListName:string=MySourceList;ItemIndex:word=0);
//   procedure ConfigMeasureRecall(ListName:string=MyMeasList;ItemIndex:word=1);
//   {������������ �����������, ��������� � ItemIndex;
//   ���� ������� ��������� ������������ � ��� �������,
//   � ��� ��������� - �������� ������������� ����� ��� �������}
//   procedure ConfigSourceRecall(ListName:string=MySourceList;ItemIndex:word=1);
//   procedure ConfigBothRecall(SourceListName:string=MySourceList;
//                              MeasListName:string=MyMeasList;
//                              SourceItemIndex:word=1;
//                              MeasItemIndex:word=1);
//   procedure ConfigMeasureStore(ListName:string=MyMeasList;ItemIndex:word=0);
//   {����� ����������� � ������;
//   ���� ItemIndex=0, �� ���������� � ����� ������}
//   procedure ConfigSourceStore(ListName:string=MySourceList;ItemIndex:word=0);
//
//   Procedure GetParametersFromDevice;
//
//   Procedure MeasureSimple();overload;
//   {����������� ���������� ������ ����, ������
//   ������� � Count, �� ���������� �����������
//   � defbuffer1, ����������� ��������� ���������� �����;
//   ���������� �� �������, ��� ����� ����������� �� ������,
//   ����� �������, ��� ����������� ���� ����, ��� � ��
//   ����� ������� � ����� �� ���� �������� �� ������ ������
//   �������}
//   Procedure MeasureSimple(BufName:string);overload;
//   {���������� ����������� � ����� BufName
//   � � ����� � ��������� ������� ���������}
//   Procedure MeasureExtended(DataType:TKt2450_ReturnedData=kt_rd_MS;
//                           BufName:string=Kt2450DefBuffer);
//   {�� ��������, ����� ������� ����� �����
//   (���. TKt2450_ReturnedData) ���� ���������� �����}
//
//
//   Procedure Init;
//   Procedure Abort;
//   Procedure Wait;
//   Procedure TrigPause;
//   Procedure TrigResume;
//   Procedure InitWait;
//   Procedure TrigEventGenerate;
//   {generates a trigger event }
//
//   Procedure TrigForIVCreate;
//   Procedure TrigNewCreate;
//   {any blocks that have been defined in the trigger model
//   are cleared so the trigger model has no blocks defined}
//   Procedure TrigBufferClear(BufName:string=Kt2450DefBuffer);
//   Procedure TrigConfigListRecall(ListName:string;Index:integer=1);
//   Procedure TrigConfigListNext(ListName:string);overload;
//   Procedure TrigConfigListNext(ListName1,ListName2:string);overload;
//   Procedure TrigOutPutChange(toOn:boolean);
//   Procedure TrigAlwaysTransition(TransitionBlockNumber:word);
//   Procedure TrigDelay(DelayTime:double);
//   Procedure TrigMeasure(BufName:string=Kt2450DefBuffer;Count:word=1);
//   {��� ��������� ����� ����� ������ ������ Count ����,
//   ���� ���� ���������� ��������� ����;
//   Count=0 ���� ����������������� ��� ������� ����������� ���������
//   - ���. ���;
//   ���������� ���������� � BufName}
//   Procedure TrigMeasureInf(BufName:string=Kt2450DefBuffer);
//   {��� ��������� ����� ����� ������ ������
//   ����� � ���������� ��������� ����; ����� ������������� ����,
//   ���� �� ����������� ����� ������������ ���� �� �� ���� ����� �����}
//   Procedure TrigMeasureCountDevice(BufName:string=Kt2450DefBuffer);
//   {��� ��������� ����� ����� ������ ������ ������ ����, ������
//   ����������� ���������� ������������ ���������� Count,
//   ���� ���� ���������� ��������� ����}
//
//   Procedure TrigMeasureResultTransition(LimitType:TK2450_TrigLimitType;
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
//                                 EventType:TK2450_TriggerEvents=kt_te_comm;
//                                 EventNumber:word=1);
//   {���� �� ����, �� ����� �� ��� ����, �������� ���� EventType,
//   �� ���������� ������� �� TransitionBlockNumber}

 end;


implementation

uses
  OlegType, Dialogs;

{ TKeitleyDevice }

constructor TKeitleyDevice.Create(SCPInew: TSCPInew; Telnet: TIdTelnet;
  IPAdressShow: TIPAdressShow; Nm: string);
begin
 inherited Create(Telnet,IPAdressShow,Nm);
 fSCPI:=SCPInew;
 fMinDelayTime:=0;
 fDelayTimeStep:=10;
 fDelayTimeMax:=200;

//   fMinDelayTime:integer;
//  {�������� ���������� ����� �������� ��������
//  �������� ������, []=��, �� ������������� 0}
//   fDelayTimeStep:integer;
//   {������� ����, ����� ���� ������������
//   ����������� �����, []=��, �� ������������� 10}
//   fDelayTimeMax:integer;
//   {����������� ������� ��������
//   ����������� �����, []=����, �� ������������� 130,
//   ����� �� ������������� �������� �����������
//   ������ 0+10*130=1300 ��}
end;

procedure TKeitleyDevice.UpDate;
begin
// showmessage('recived');
 fSCPI.ProcessingString(fDataSubject.ReceivedString);
 if fValue<>ErResult then
     fIsReceived:=True;
 if TestShowEthernet then showmessage('recived:  '+fDataSubject.ReceivedString);

end;

{ TKeitley }

constructor TKeitley.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
 fTelnet:=Telnet;
 fIPAdressShow:=IPAdressShow;
 inherited Create(Nm);
end;

end.
