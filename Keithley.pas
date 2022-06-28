unit Keithley;

interface

uses
  TelnetDevice, SCPI, IdTelnet, ShowTypes, Keitley2450Const;

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
   fDisplayState:TKeitley_DisplayState;
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
   function StringToDisplayBrightness(Str:string):boolean;
//   procedure StringToDigLineStatus(Str:string);
//   procedure StringToArray(Str:string);
//   procedure StringToMesuredData(Str:string;DataType:TKt2450_ReturnedData);
//   procedure StringToMesuredDataArray(Str:string;DataType:TKt2450_ReturnedData);
//   function StringToMeasureTime(Str:string):double;
//   function IsLimitExcided(FirstLevelNode,LeafNode:byte):boolean;
//   {������ ������� ��� ������, �� ������� ������ ����� �������}
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
   procedure PrepareString;override;
   procedure PrepareStringByRootNode;virtual;
   procedure DeviceCreate(Nm:string);override;
   procedure ProcessingStringByRootNode(Str:string);virtual;
   procedure DefaultSettings;override;
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
   property DisplayState:TKeitley_DisplayState read fDisplayState;
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
   function Test():boolean;override;
   procedure ProcessingString(Str:string);override;
   procedure ResetSetting();
   procedure MyTraining();virtual;
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
   procedure SaveSetup(SlotNumber:TKeitley_SetupMemorySlot);
//   procedure LoadSetup(SlotNumber:TKt2450_SetupMemorySlot);
//   procedure LoadSetupPowerOn(SlotNumber:TKt2450_SetupMemorySlot);
//   procedure UnloadSetupPowerOn();
   procedure RunningMacroScript(ScriptName:string);
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
//   ���� �� - �� ���� ����������������� (� �����������, ����)
//   ��������, ��� �����������}
//   procedure SetReadBackState(toOn:boolean);overload;
//   function IsReadBackOn(Source:TKt2450_Source):boolean;overload;
//   function IsReadBackOn():boolean;overload;
//   function GetReadBacks():boolean;
//
//   procedure SetHighCapacitanceState(Source:TKt2450_Source;
//                              toOn:boolean);overload;
//   {�������������� ������������� ���� ������}
//   procedure SetHighCapacitanceState(toOn:boolean);overload;
//   function IsHighCapacitanceOn(Source:TKt2450_Source):boolean;overload;
//   function IsHighCapacitanceOn():boolean;overload;
//   function GetHighCapacitanceStates():boolean;
//
//
//   procedure SetAzeroState(Measure:TKt2450_Measure;
//                              toOn:boolean);overload;
//   {�� ������������ ������ �������� ����� ������ ������}
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
//   {������� ����, �� ������������� �� ������,
//     �� �������� ������ ���������� �� ������}
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
//   {�������� �������� �������������� � DataVector.X �� DataVector.Y}
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
//   {�� ���������, ����� ������� ����� �����
//   (���. TKt2450_ReturnedData) ���� ���������� �����}
//   Procedure BufferDataArrayExtended(SIndex,EIndex:integer;
//                     DataType:TKt2450_ReturnedData=kt_rd_MS;
//                     BufName:string=Kt2450DefBuffer);
//   {���������� � ������ BufName ����������, ���������� ��
//   ��������� � �������� �� SIndex �� EIndex,
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
//   {���� ���� LineNumber �� kt_dt_dig �� kt_dd_out, ��
//   ��� �� ����� ���������� ������� �� ������� ����}
//   function GetDidLinOut(LineNumber:TKt2450_DigLines):integer;
//   {���� ���� LineNumber �� kt_dt_dig �� kt_dd_in, ��
//   ��� �� ����� ������� �������� ����;
//   Resul=1 ���� �������
//         0 ���� �������
//        -1 ���� �� �������� �������}
//
   procedure SetDisplayBrightness(State:TKeitley_DisplayState);
   function GetDisplayBrightness():boolean;
//
   procedure Beep(Freq:word=600;Duration:double=0.1);
   {���� �������� Freq �� �������� Duration ������}

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
   Procedure GetParametersFromDevice;virtual;
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
//   � � ����� � ��������� �������� ���������}
//   Procedure MeasureExtended(DataType:TKt2450_ReturnedData=kt_rd_MS;
//                           BufName:string=Kt2450DefBuffer);
//   {�� ���������, ����� ������� ����� �����
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
//   {��� ���������� ����� ����� ������ ������ Count ����,
//   ���� ���� ���������� ��������� ����;
//   Count=0 ���� ����������������� ��� ������� ����������� ���������
//   - ���. ���;
//   ���������� ���������� � BufName}
//   Procedure TrigMeasureInf(BufName:string=Kt2450DefBuffer);
//   {��� ���������� ����� ����� ������ ������
//   ����� � ���������� ��������� ����; ����� ������������� ����,
//   ���� �� ����������� ����� ������������ ���� �� �� ���� ����� �����}
//   Procedure TrigMeasureCountDevice(BufName:string=Kt2450DefBuffer);
//   {��� ���������� ����� ����� ������ ������ ������ ����, ������
//   ����������� ���������� ������������ ���������� Count,
//   ���� ���� ���������� ��������� ����}
//
//   Procedure TrigMeasureResultTransition(LimitType:TK2450_TrigLimitType;
//                    LimA,LimB:double;TransitionBlockNumber:word;
//                    MeasureBlockNumber:word=0);
//   {���� ���������� ����������� ����, ��� ����������� � LimitType,
//   �� ���������� ������� �� ���� TransitionBlockNumber;
//   ��� MeasureBlockNumber=0 �������� �� ����� �������
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
  OlegType, Dialogs, SysUtils;

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

procedure TKeitley.Beep(Freq: word; Duration: double);
begin
//:SYST:BEEP <frequency>, <duration>
fAdditionalString:=IntToStr(NumberMap(Freq,Keitley_BeepFrequancyLimits))
                   +PartDelimiter
                   +floattostr(NumberMap(Duration,Keitley_BeepDurationLimits));
 SetupOperation(7,34);
end;

constructor TKeitley.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
 fTelnet:=Telnet;
 fIPAdressShow:=IPAdressShow;
 inherited Create(Nm);
end;

procedure TKeitley.DefaultSettings;
// var i:integer;
begin
// fIsTripped:=False;
// fSourceType:=kt_sVolt;
// fMeasureFunction:=kt_mCurrent;
// fVoltageProtection:=kt_vpnone;
// fVoltageLimit:=Kt_2450_VoltageLimDef;
// fCurrentLimit:=Kt_2450_CurrentLimDef;
// fTerminal:=kt_otFront;
// fOutPutOn:=False;
// for I := ord(Low(TKt2450_Measure)) to ord(High(TKt2450_Measure)) do
//   begin
//   fSences[TKt2450_Measure(i)]:=kt_s2wire;
//   fMeasureUnits[TKt2450_Measure(i)]:=kt_mu_amp;
//   fResistanceCompencateOn[TKt2450_Measure(i)]:=False;
//   fAzeroState[TKt2450_Measure(i)]:=True;
//   fMeasureTime[TKt2450_Measure(i)]:=1;
//   fDisplayDN[TKt2450_Measure(i)]:=5;
//   end;
// for I := ord(Low(TKt2450_Source)) to ord(High(TKt2450_Source)) do
//   begin
//   fReadBack[TKt2450_Source(i)]:=True;
//   fSourceDelay[TKt2450_Source(i)]:=0;
//   fSourceDelayAuto[TKt2450_Source(i)]:=True;
//   SweepParameters[TKt2450_Source(i)]:=TKt_2450_SweepParameters.Create(TKt2450_Source(i));
//   fSourceValue[TKt2450_Source(i)]:=0;
//   fHighCapacitance[TKt2450_Source(i)]:=False;
//   end;
// for I := ord(Low(TKt2450_Source)) to ord(High(TKt2450_Source)) do
//   fOutputOffState[TKt2450_Source(i)]:=kt_oos_norm;
// fMode:=ModeDetermination();
// fSourceVoltageRange:=kt_vrAuto;
// fSourceCurrentRange:=kt_crAuto;
// fMeasureVoltageRange:=kt_vrAuto;
// fMeasureCurrentRange:=kt_crAuto;
// fMeasureVoltageLowRange:=kt_vr20mV;
// fMeasureCurrentLowRange:=kt_cr10nA;
// fCount:=1;
//
// fDataVector:=TVector.Create;
// fDataTimeVector:=TVector.Create;
// fSourceMeasuredValue:=ErResult;
// fTimeValue:=ErResult;
//
// for I := Low(TKt2450_DigLines) to High(TKt2450_DigLines) do
//   begin
//   fDigitLineType[i]:=kt_dt_dig;
//   fDigitLineDirec[i]:=kt_dd_in;
//   end;
// fDLActive:=1;

 fDisplayState:=kt_ds_on25;
// fTrigBlockNumber:=1;
// fSweepWasCreated:=False;


end;

procedure TKeitley.DeviceCreate(Nm: string);
begin
  fDevice:=TKeitleyDevice.Create(Self,fTelnet,fIPAdressShow,Nm);
end;

function TKeitley.GetDisplayBrightness: boolean;
begin
 QuireOperation(6,30);
 Result:=(fDevice.Value<>ErResult);
end;

procedure TKeitley.GetParametersFromDevice;
begin
// if not(GetVoltageProtection()) then Exit;
// if not(GetVoltageLimit()) then Exit;
// if not(GetCurrentLimit()) then Exit;
// if not(GetSourceType()) then Exit;  //GetDeviceMode
// if not(GetMeasureFunction()) then Exit; //GetDeviceMode
// if not(IsResistanceCompencateOn()) then Exit;  //�� ���� ���� GetMeasureFunction
//
// if not(GetTerminal()) then Exit;
// if not(IsOutPutOn()) then Exit;
// if not(GetSenses()) then Exit;
// if not(GetOutputOffStates()) then Exit;
// if not(GetMeasureUnits()) then Exit; //GetDeviceMode
// fMode:=ModeDetermination();
// if not(GetReadBacks()) then Exit;
// if not(GetSourceRanges()) then Exit;
// if not(GetMeasureRanges()) then Exit;
// if not(GetMeasureLowRanges()) then Exit;
// if not(GetAzeroStates()) then Exit;
// if not(GetSourceDelays()) then Exit;
// if not(GetSourceDelayAutoOns()) then Exit;
// if not(GetSourceValues()) then Exit;
// if not(GetMeasureTimes()) then Exit;
// if not(GetHighCapacitanceStates()) then Exit;
// if not(GetDisplayDNs()) then Exit;
// if not(GetCount()) then Exit;
 if not(GetDisplayBrightness()) then Exit;
end;

procedure TKeitley.MyTraining;
begin

end;

procedure TKeitley.PrepareString;
begin
 (fDevice as TKeitleyDevice).ClearStringToSend;
 (fDevice as TKeitleyDevice).SetStringToSend(RootNoodKeitley[fRootNode]);

 case fRootNode of
//  5:case fFirstLevelNode of
//     5: JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//     0..1:begin
//           JoinToStringToSend(RootNoodKt_2450[12+fFirstLevelNode]);
//           JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
//          end;
//    end;  // fRootNode=5
  6:case fFirstLevelNode of
      30:JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//      12,13,14:
//        begin
//        JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
//        JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
//        end;
//      else JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
     end;  // fRootNode=6
  7:JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//  7,9:JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//  11:case fFirstLevelNode of
//       12..13:case fLeafNode of
//                0:JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
//                else
//                   begin
//                    JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
//                    JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
//                    if fIsTripped then JoinToStringToSend(FirstNodeKt_2450[11]);
//                   end;
//              end;
//       55:JoinToStringToSend(RootNoodKt_2450[15]);
//       23:case fLeafNode of
//             79,80:begin
//                   JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//                   JoinToStringToSend(RootNoodKt_2450[fLeafNode-79+12]);
//                   JoinToStringToSend(FirstNodeKt_2450[24]);
//                   end;
//             else
//                 begin
//                 JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//                 JoinToStringToSend(RootNoodKt_2450[fLeafNode]);
//                 end;
//          end;
//        24:begin
//            JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
//            JoinToStringToSend(FirstNodeKt_2450[23]);
//            JoinToStringToSend(ConfLeafNodeKt_2450[fLeafNode]);
//           end;
//        25:begin
//            JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//            case fLeafNode of
//              1:JoinToStringToSend(SweepParameters[fSourceType].Lin);
//              2:JoinToStringToSend(SweepParameters[fSourceType].LinStep);
//              3:JoinToStringToSend(SweepParameters[fSourceType].List);
//              4:JoinToStringToSend(SweepParameters[fSourceType].Log);
//            end;
//           end;
//     end;// fRootNode=11
//  12..14:
//       begin
//         JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//         case fLeafNode of
//          18,19:JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
//         end;
//       end; // fRootNode=12..14
//  17:if fFirstLevelNode=1 then JoinToStringToSend(fAdditionalString);
//  19:begin
//       JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//       case fFirstLevelNode of
//        31:if fLeafNode=1 then JoinToStringToSend(Buffer.Get)
//                           else fAdditionalString:=Buffer.ReSize;
//        32:if fLeafNode=1 then JoinToStringToSend(Buffer.Get)
//                           else fAdditionalString:=Buffer.FillModeChange;
//        33:JoinToStringToSend(Buffer.DataDemandArray(TKt2450_ReturnedData(fLeafNode)));
//        35:case fLeafNode of
//            1:JoinToStringToSend(Buffer.Get);
//            2:JoinToStringToSend(Buffer.LimitIndexies)
//           end;
//       end;
//      end; // fRootNode=19
//  21:case fFirstLevelNode of
//       1:JoinToStringToSend(Buffer.Get);
//       2..5:JoinToStringToSend(Buffer.DataDemand(TKt2450_ReturnedData(fFirstLevelNode-2)))
//     end; // fRootNode=21
//  22:case fFirstLevelNode of
//       1:JoinToStringToSend(Buffer.Get);
//       2..5:JoinToStringToSend(Buffer.DataDemand(TKt2450_ReturnedData(fFirstLevelNode-2)))
//     end; // fRootNode=22
//  23:case fFirstLevelNode of
//        36,37:JoinToStringToSend(AnsiReplaceStr(FirstNodeKt_2450[fFirstLevelNode],'#',inttostr(fDLActive)));
//     end; // fRootNode=23
//  24:begin
//        JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//        JoinToStringToSend(ConfLeafNodeKt_2450[fLeafNode]);
//     end; // fRootNode=24
//  26:case fFirstLevelNode of
//        38,44,43:JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//        40,41,21:begin
//            JoinToStringToSend(FirstNodeKt_2450[39]);
//            JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//            JoinToStringToSend(TrigLeafNodeKt_2450[fLeafNode]);
//            fAdditionalString:=IntTostr(fTrigBlockNumber)+PartDelimiter+fAdditionalString;
//            inc(fTrigBlockNumber);
//           end;
//        24,11:begin
//            JoinToStringToSend(FirstNodeKt_2450[39]);
//            JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
//            JoinToStringToSend(TrigLeafNodeKt_2450[fLeafNode]);
//            fAdditionalString:=IntTostr(fTrigBlockNumber)+PartDelimiter+fAdditionalString;
//            inc(fTrigBlockNumber);
//           end;
//         42:begin
//             JoinToStringToSend(FirstNodeKt_2450[39]);
//             JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
//             fAdditionalString:=IntTostr(fTrigBlockNumber)+PartDelimiter+fAdditionalString;
//             inc(fTrigBlockNumber);
//            end;
//     end;// fRootNode=26
 end;
 PrepareStringByRootNode;

 if fIsSuffix then JoinAddString;
end;

procedure TKeitley.PrepareStringByRootNode;
begin

end;

procedure TKeitley.ProcessingString(Str: string);
begin
 Str:=Trim(Str);

 case fRootNode of
//  0:if pos(Kt_2450_Test,Str)<>0 then fDevice.Value:=314;
//  5:case fFirstLevelNode of
//     5,55:fDevice.Value:=StrToInt(Str);
//     0..1:begin
//          if StringToOutPutState(AnsiLowerCase(Str))
//            then fDevice.Value:=ord(fOutputOffState[TKt2450_Source(fFirstLevelNode)]);
//          end;
//    end; //fRootNode=5
  6:if fFirstLevelNode=30
       then
        begin
        if StringToDisplayBrightness(AnsiLowerCase(Str))
            then fDevice.Value:=ord(fDisplayState);

        end
       else fDevice.Value:=StrToInt(Str);
//  9:if StringToTerminals(AnsiLowerCase(Str))
//          then fDevice.Value:=ord(fTerminal);
//  11:case fFirstLevelNode of
//        23:begin
//           StringToArray(Str);
//           if fDataVector.Count>0 then fDevice.Value:=1;
//           end;
//        else
//           case fLeafNode of
//            10:if StringToVoltageProtection(AnsiLowerCase(Str),fVoltageProtection)
//                then fDevice.Value:=ord(fVoltageProtection);
//            0,12..13,15,21:fDevice.Value:=SCPI_StringToValue(Str);
//            55:if StringToSourceType(AnsiLowerCase(Str)) then fDevice.Value:=ord(fSourceType);
//            16,17,22,27:fDevice.Value:=StrToInt(Str);
//           end;
//     end; //fRootNode=11
//   12..14:case fFirstLevelNode of
//             7,9,20: fDevice.Value:=StrToInt(Str);
//             14: if StringToMeasureUnit(AnsiLowerCase(Str))
//                    then fDevice.Value:=ord(fMeasureUnits[TKt2450_Measure(fFirstLevelNode-12)]);
//             16,15,26:fDevice.Value:=SCPI_StringToValue(Str);
//          end;   //fRootNode=12..14
//   15:if StringToMeasureFunction(AnsiLowerCase(Str)) then fDevice.Value:=ord(fMeasureFunction);
//   19:case fFirstLevelNode of
//          31: fDevice.Value:=StrToInt(Str);
//          32:if Buffer.StringToFillMode(AnsiLowerCase(Str))
//                then fDevice.Value:=ord(TKt2450_BufferFillMode(Buffer.FillMode));
//          33:StringToMesuredDataArray(AnsiReplaceStr(Str,',',' '),TKt2450_ReturnedData(fLeafNode));
//          35:case fLeafNode of
//              0,1:fDevice.Value:=StrToInt(Str);
//              2:if StringToBufferIndexies(Str) then fDevice.Value:=1;
//             end;
//      end; //fRootNode=19
//   20:fDevice.Value:=StrToInt(Str);
//   21:case fFirstLevelNode of
//       0,1:fDevice.Value:=SCPI_StringToValue(Str);
//       2..5:StringToMesuredData(AnsiReplaceStr(Str,',',' '),TKt2450_ReturnedData(fFirstLevelNode-2));
//       end; //fRootNode=21
//   22:case fFirstLevelNode of
//       0,1:fDevice.Value:=SCPI_StringToValue(Str);
//       2..5:StringToMesuredData(AnsiReplaceStr(Str,',',' '),TKt2450_ReturnedData(fFirstLevelNode-2));
//      end;  //fRootNode=22
//   23:case fFirstLevelNode of
//       36:StringToDigLineStatus(AnsiLowerCase(Str));
//       37:fDevice.Value:=StrToInt(Str);
//      end;
 end;

 ProcessingStringByRootNode(Str);
end;

procedure TKeitley.ProcessingStringByRootNode(Str:string);
begin

end;

procedure TKeitley.ResetSetting;
begin
//  *RST
  SetupOperation(2,0,0,False);
end;

procedure TKeitley.RunningMacroScript(ScriptName: string);
begin
//  SCR:RUN "ScriptName"
  fAdditionalString:=StringToInvertedCommas(ScriptName);
  SetupOperation(8);
end;

procedure TKeitley.SaveSetup(SlotNumber: TKeitley_SetupMemorySlot);
begin
// *SAV <n>
 fAdditionalString:=inttostr(SlotNumber);
 SetupOperation(3);
end;

procedure TKeitley.SetDisplayBrightness(State: TKeitley_DisplayState);
begin
//:DISP:LIGH:STAT <brightness>
 fDisplayState:=State;
 fAdditionalString:=Keitley_DisplayStateCommand[State];
 SetupOperation(6,30)
end;

function TKeitley.StringToDisplayBrightness(Str: string): boolean;
  var i:TKeitley_DisplayState;
begin
 Result:=False;
 for I := Low(TKeitley_DisplayState) to High(TKeitley_DisplayState) do
  begin
   if Str=Keitley_DisplayStateCommand[i] then
     begin
       fDisplayState:=i;
       Result:=True;
       Break;
     end;
  end;
end;

function TKeitley.Test: boolean;
begin
// *IDN?
 QuireOperation(0,0,0,False);
 Result:=(fDevice.Value=314);
end;

end.
