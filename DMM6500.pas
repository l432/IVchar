unit DMM6500;

interface

uses
  Keithley, IdTelnet, ShowTypes,Keitley2450Const, DMM6500_Const, SCPI;

//const


type
 TDMM6500=class;

 TDMM6500Channel=class
  private
   FNumber: byte;
   FMeasureFunction: TKeitley_Measure;
   fDMM6500:TDMM6500;
   fCount:integer;
   procedure SetCountNumber(Value:integer);
  public
   property Number:byte read FNumber;
   property MeasureFunction:TKeitley_Measure read FMeasureFunction write FMeasureFunction;
   property DMM6500:TDMM6500 read fDMM6500;
   property Count:integer read fCount write SetCountNumber;
   constructor Create(ChanNumber:byte;DMM6500:TDMM6500);
 end;

 TDMM6500=class(TKeitley)
  private
   fMeasureChanNumber:byte;
   fFirstChannelInSlot:byte;
   fLastChannelInSlot:byte;
   fChannelMaxVoltage:double;
   fRealCardPresent:boolean;
//   fChansMeasureFunction:array of TKeitley_Measure;
   fChansMeasure:array of TDMM6500Channel;
   fTerminalMeasureFunction:array [TKeitley_OutputTerminals] of TKeitley_Measure;
   fChanOperation:boolean;
   fChanOperationString:string;
   function ChanelToString(ChanNumber:byte):string;overload;
   function ChanelToString(ChanNumberLow,ChanNumberHigh:byte):string;overload;
   function ChanelToString(ChanNumbers:array of byte):string;overload;
   function ChanelNumberIsCorrect(ChanNumber:byte):boolean;overload;
   function ChanelNumberIsCorrect(ChanNumberLow,ChanNumberHigh:byte):boolean;overload;
   function ChanelNumberIsCorrect(ChanNumbers:array of byte):boolean;overload;
   procedure ChansMeasureCreate;
   function IsPermittedMeasureFuncForChan(MeasureFunc:TKeitley_Measure;
                                    ChanNumber:byte):boolean;
   function ChanQuire (ChanNumber:byte;QuireFunc:TQuireFunction):boolean;
  protected
   procedure ProcessingStringByRootNode(Str:string);override;
   procedure PrepareString;override;
   procedure PrepareStringByRootNode;override;
   procedure ProcessingStringChanOperation;
   procedure DefaultSettings;override;
//   procedure StringToMesuredData(Str:string;DataType:TKeitley_ReturnedData);override;
   procedure AdditionalDataFromString(Str:string);override;
   procedure AdditionalDataToArrayFromString;override;
   function GetMeasureFunctionValue:TKeitley_Measure;override;
   procedure SetCountNumber(Value:integer);override;
  public
   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string='DMM6500');
   procedure MyTraining();override;
   procedure ProcessingString(Str:string);override;

   procedure BufferCreate(Name:string;Size:integer;Style:TKt2450_BufferStyle);overload;override;
   procedure BufferCreate(Style:TKt2450_BufferStyle);overload;override;

   function TestRealCard_Presence:boolean;
   function TestPseudocard_Presence:boolean;
   procedure PseudocardInstall;
   procedure PseudocardUnInstall;

   Function  GetFirstChannelInSlot:boolean;
   Function  GetLastChannelInSlot:boolean;
   Function  GetChannelMaxVoltage:boolean;

   procedure SetMeasureFunction(MeasureFunc:TKeitley_Measure=kt_mVolDC);overload;override;
   procedure SetMeasureFunction(ChanNumber:byte;MeasureFunc:TKeitley_Measure=kt_mVolDC);reintroduce;overload;
   procedure SetMeasureFunction(ChanNumberLow,ChanNumberHigh:byte;
                    MeasureFunc:TKeitley_Measure=kt_mVolDC);reintroduce;overload;
   procedure SetMeasureFunction(ChanNumbers:array of byte;
                    MeasureFunc:TKeitley_Measure=kt_mVolDC);reintroduce;overload;

//   procedure SetMeasureFunctionChan(ChanNumber:byte;
//                    MeasureFunc:TKeitley_Measure=kt_mVolDC);overload;
//   procedure SetMeasureFunctionChan(ChanNumberLow,ChanNumberHigh:byte;
//                    MeasureFunc:TKeitley_Measure=kt_mVolDC);overload;
//   procedure SetMeasureFunctionChan(ChanNumbers:array of byte;
//                    MeasureFunc:TKeitley_Measure=kt_mVolDC);overload;

   function GetMeasureFunction():boolean;overload;override;
   function GetMeasureFunction(ChanNumber:byte):boolean;reintroduce;overload;

   procedure SetCount(ChanNumber:byte;Cnt:integer);reintroduce;overload;
   function GetCount(ChanNumber:byte):boolean;reintroduce;overload;

   Procedure GetParametersFromDevice;override;
   Procedure GetCardParametersFromDevice;
 end;

//-------------------------------------------------

TDMM6500MeasPar_Base=class
 private
//  fCount:integer;
  fDisplayDN:KeitleyDisplayDigitsNumber;
//  procedure SetCountNumber(Value: integer);virtual;
 public
//  property Count:integer read fCount write SetCountNumber;
  property DisplayDN:KeitleyDisplayDigitsNumber read fDisplayDN write fDisplayDN;
  constructor Create;
end;

TDMM6500MeasPar_BaseDelay=class(TDMM6500MeasPar_Base)
 private
  fAutoDelay:boolean;
 public
  property AutoDelay: boolean read fAutoDelay write fAutoDelay;
  constructor Create;
end;

TDMM6500MeasPar_BaseDig=class(TDMM6500MeasPar_Base)
 private
  fSampleRate:TDMM6500_DigSampleRate;
  {кількість вимірів за секунду}
 public
  property SampleRate: TDMM6500_DigSampleRate read fSampleRate write fSampleRate;
  constructor Create;
end;

TDMM6500MeasPar_BaseVolt=class
 private
  fDBLimits:TLimitValues;
  fDBMLimits:TLimitValues;
  fUnits:TDMM6500_VoltageUnits;
  fDB:double;
  fDBM:integer;
  procedure SetDB(Value:double);
  procedure SetDBM(Value:integer);
 public
  property Units: TDMM6500_VoltageUnits read fUnits write fUnits;
  property DB:double read fDB write SetDB;
  property DBM:integer read fDBM write SetDBM;
  constructor Create;
end;

TDMM6500MeasPar_BaseVoltDC=class(TDMM6500MeasPar_BaseVolt)
 private
  fInputImpedance:TDMM6500_InputImpedance;
 public
  property InputImpedance: TDMM6500_InputImpedance read fInputImpedance write fInputImpedance;
  constructor Create;
end;

TDMM6500MeasPar_BaseAC=class(TDMM6500MeasPar_BaseDelay)
 private
  fDetectorBW:TDMM6500_DetectorBandwidth;
 public
  property DetectorBW: TDMM6500_DetectorBandwidth read fDetectorBW write fDetectorBW;
  constructor Create;
end;

TDMM6500MeasPar_BaseDelayMT=class(TDMM6500MeasPar_BaseDelay)
 private
  fMTLimits:TLimitValues;
  fMeaureTime:double;
  {час вимірювання, мс, для більшості 0,02-240}
  procedure SetMeaureTime(Value:double);
 public
  property MeaureTime: double read fMeaureTime write SetMeaureTime;
  constructor Create;
end;


TDMM6500MeasPar_BaseMajority=class(TDMM6500MeasPar_BaseDelayMT)
 private
  fAzeroState:boolean;
  fLineSync:boolean;
 public
  property AzeroState: boolean read fAzeroState write fAzeroState;
  property LineSync: boolean read fLineSync write fLineSync;
  constructor Create;
end;

TDMM6500MeasPar_Base4WT=class(TDMM6500MeasPar_BaseMajority)
 private
  fOffComp:TDMM6500_OffsetCompen;
  fOpenLD:boolean;
 public
  property OffsetComp: TDMM6500_OffsetCompen read fOffComp write fOffComp;
  property OpenLeadDetector: boolean read fOpenLD write fOpenLD;
  constructor Create;
end;

//*******************************************************

TDMM6500MeasPar_DigVolt=class(TDMM6500MeasPar_BaseDig)
 private
  fRange:TDMM6500_VoltageDigRange;
  fBaseVolt:TDMM6500MeasPar_BaseVoltDC;
  function GetInputImpedance: TDMM6500_InputImpedance;
  procedure SetInputImpedance(const Value: TDMM6500_InputImpedance);
  function GetUnits: TDMM6500_VoltageUnits;
  procedure SetUnits(const Value: TDMM6500_VoltageUnits);
  function GetDB: double;
  function GetDBM: integer;
  procedure SSetDB(const Value: double);
  procedure SSetDBM(const Value: integer);
 public
  property Range: TDMM6500_VoltageDigRange read fRange write fRange;
  property InputImpedance: TDMM6500_InputImpedance read GetInputImpedance write SetInputImpedance;
  property Units: TDMM6500_VoltageUnits read GetUnits write SetUnits;
  property DB:double read GetDB write SSetDB;
  property DBM:integer read GetDBM write SSetDBM;
  constructor Create;
  destructor Destroy; override;
end;


TDMM6500MeasPar_DigCur=class(TDMM6500MeasPar_BaseDig)
 private
  fRange:TDMM6500_CurrentDigRange;
 public
  property Range: TDMM6500_CurrentDigRange read fRange write fRange;
  constructor Create;
end;

TDMM6500MeasPar_Capac=class(TDMM6500MeasPar_BaseDelay)
 private
  fRange:TDMM6500_CapacitanceRange;
 public
  property Range: TDMM6500_CapacitanceRange read fRange write fRange;
  constructor Create;
end;

TDMM6500MeasPar_CurAC=class(TDMM6500MeasPar_BaseAC)
 private
  fRange:TDMM6500_CurrentACRange;
 public
  property Range: TDMM6500_CurrentACRange read fRange write fRange;
  constructor Create;
end;

TDMM6500MeasPar_VoltAC=class(TDMM6500MeasPar_BaseAC)
 private
  fRange:TDMM6500_VoltageACRange;
  fBaseVolt:TDMM6500MeasPar_BaseVolt;
  function GetUnits: TDMM6500_VoltageUnits;
  procedure SetUnits(const Value: TDMM6500_VoltageUnits);
  function GetDB: double;
  function GetDBM: integer;
  procedure SSetDB(const Value: double);
  procedure SSetDBM(const Value: integer);
 public
  property Range: TDMM6500_VoltageACRange read fRange write fRange;
  property Units: TDMM6500_VoltageUnits read GetUnits write SetUnits;
  property DB:double read GetDB write SSetDB;
  property DBM:integer read GetDBM write SSetDBM;
  constructor Create;
  destructor Destroy; override;
end;


TDMM6500MeasPar_FreqPeriod=class(TDMM6500MeasPar_BaseDelayMT)
 private
  fThresholdRange:TDMM6500_VoltageACRange;
 public
  property ThresholdRange: TDMM6500_VoltageACRange read fThresholdRange write fThresholdRange;
  constructor Create;
end;

TDMM6500MeasPar_CurDC=class(TDMM6500MeasPar_BaseMajority)
 private
  fRange:TDMM6500_CurrentDCRange;
 public
  property Range: TDMM6500_CurrentDCRange read fRange write fRange;
  constructor Create;
end;

TDMM6500MeasPar_VoltDC=class(TDMM6500MeasPar_BaseMajority)
 private
  fRange:TDMM6500_VoltageDCRange;
  fBaseVolt:TDMM6500MeasPar_BaseVoltDC;
  function GetInputImpedance: TDMM6500_InputImpedance;
  procedure SetInputImpedance(const Value: TDMM6500_InputImpedance);
  function GetUnits: TDMM6500_VoltageUnits;
  procedure SetUnits(const Value: TDMM6500_VoltageUnits);
  function GetDB: double;
  function GetDBM: integer;
  procedure SSetDB(const Value: double);
  procedure SSetDBM(const Value: integer);
 public
  property Range: TDMM6500_VoltageDCRange read fRange write fRange;
  property InputImpedance: TDMM6500_InputImpedance read GetInputImpedance write SetInputImpedance;
  property Units: TDMM6500_VoltageUnits read GetUnits write SetUnits;
  property DB:double read GetDB write SSetDB;
  property DBM:integer read GetDBM write SSetDBM;
  constructor Create;
  destructor Destroy; override;
end;

TDMM6500MeasPar_VoltRat=class(TDMM6500MeasPar_BaseMajority)
 private
  fRange:TDMM6500_VoltageDCRange;
  fMethod:TDMM6500_VoltageRatioMethod;
 public
  property Range: TDMM6500_VoltageDCRange read fRange write fRange;
  property VRMethod:TDMM6500_VoltageRatioMethod read fMethod write fMethod;
  constructor Create;
end;

TDMM6500MeasPar_Res2W=class(TDMM6500MeasPar_BaseMajority)
 private
  fRange:TDMM6500_Resistance2WRange;
 public
  property Range: TDMM6500_Resistance2WRange read fRange write fRange;
  constructor Create;
end;

TDMM6500MeasPar_Res4W=class(TDMM6500MeasPar_Base4WT)
 private
  fRange:TDMM6500_Resistance4WRange;
 public
  property Range: TDMM6500_Resistance4WRange read fRange write fRange;
  constructor Create;
end;


var
  DMM_6500:TDMM6500;

implementation

uses
  Dialogs, SysUtils, Keitley2450Device, OlegFunction, OlegType, Math, 
  TelnetDevice;

{ TKt_2450 }

procedure TDMM6500.BufferCreate(Name: string; Size: integer;
  Style: TKt2450_BufferStyle);
begin
  if Style=kt_bs_comp then Exit;
  inherited BufferCreate(Name,Size,Style);
end;

procedure TDMM6500.AdditionalDataFromString(Str: string);
begin
// showmessage(StringDataFromRow(Str,2));
 if (Pos('Front',StringDataFromRow(Str,2))<>0)
    or(Pos('Rear',StringDataFromRow(Str,2))<>0) then
    begin
     fMeasureChanNumber:=0;
     Exit;
    end;
 fMeasureChanNumber:=round(FloatDataFromRow(Str,2));
end;

procedure TDMM6500.AdditionalDataToArrayFromString;
begin
 DataVector.Add(fMeasureChanNumber,fDevice.Value);
end;

procedure TDMM6500.BufferCreate(Style: TKt2450_BufferStyle);
begin
  if Style=kt_bs_comp then Exit;
  inherited BufferCreate(Style);
end;

function TDMM6500.ChanelToString(ChanNumber: byte): string;
begin
 Result:='(@'+inttostr(ChanNumber)+')';
end;

function TDMM6500.ChanelToString(ChanNumberLow, ChanNumberHigh: byte): string;
begin
 if ChanNumberLow=ChanNumberHigh
    then Result:=ChanelToString(ChanNumberLow)
    else Result:='(@'
        +inttostr(min(ChanNumberLow,ChanNumberHigh))
        +':'+inttostr(max(ChanNumberLow,ChanNumberHigh))+')';
end;

constructor TDMM6500.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
  inherited Create(Telnet,IPAdressShow,Nm);
end;

procedure TDMM6500.DefaultSettings;
begin
 inherited DefaultSettings;
 fMeasureChanNumber:=0;
 fFirstChannelInSlot:=1;
 fLastChannelInSlot:=10;
 fChannelMaxVoltage:=25;
 fRealCardPresent:=false;

 fMeasureFunction:=kt_mVolDC;
 ChansMeasureCreate();
 fTerminalMeasureFunction[kt_otFront]:=kt_mVolDC;
 fTerminalMeasureFunction[kt_otRear]:=kt_mVolDC;

 fChanOperation:=false;
 fChanOperationString:='';

end;

procedure TDMM6500.GetCardParametersFromDevice;
begin
  if TestRealCard_Presence then
  begin
    GetFirstChannelInSlot();
    GetLastChannelInSlot();
    GetChannelMaxVoltage();
    if High(fChansMeasure)<> fLastChannelInSlot-fFirstChannelInSlot
      then ChansMeasureCreate();
  end;
end;

function TDMM6500.GetChannelMaxVoltage: boolean;
begin
//:SYST:CARD1:VMAX?
 QuireOperation(7,45,3);
 Result:=fDevice.Value<>ErResult;
 if Result then fChannelMaxVoltage:=fDevice.Value;
end;

function TDMM6500.GetCount(ChanNumber: byte): boolean;
 var tempCount:integer;
begin
 tempCount:=Count;
// Result:=ChanQuire(ChanNumber,GetCount);

 if ChanelNumberIsCorrect(ChanNumber) then
   begin
     fMeasureChanNumber:=ChanNumber;
     fChanOperationString:=' '+ChanelToString(ChanNumber);
     fChanOperation:=True;
     Result := GetCount;
     fChanOperation:=False;
   end                                else
     Result:=False;

 if Result then fChansMeasure[ChanNumber-fFirstChannelInSlot].Count:=Count;
 Count:=tempCount;
end;

function TDMM6500.GetFirstChannelInSlot: boolean;
begin
//:SYST:CARD1:VCH:STAR?
 QuireOperation(7,45,1);
 Result:=fDevice.Value<>ErResult;
 if Result then fFirstChannelInSlot:=round(fDevice.Value);
end;

function TDMM6500.GetLastChannelInSlot: boolean;
begin
//:SYST:CARD1:VCH:END?
 QuireOperation(7,45,2);
 Result:=fDevice.Value<>ErResult;
 if Result then fLastChannelInSlot:=round(fDevice.Value);
end;

function TDMM6500.GetMeasureFunction: boolean;
begin
 Result:= inherited GetMeasureFunction;
 if Result then fTerminalMeasureFunction[Terminal]:=MeasureFunction;
end;


function TDMM6500.GetMeasureFunction(ChanNumber: byte): boolean;
begin
 if ChanelNumberIsCorrect(ChanNumber) then
   begin
     fMeasureChanNumber:=ChanNumber;
     fChanOperationString:=' '+ChanelToString(ChanNumber);
     fChanOperation:=True;
     Result := inherited GetMeasureFunction;
     fChanOperation:=False;
   end                                else
     Result:=False;
 if Result then fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction:=MeasureFunction;
end;

function TDMM6500.GetMeasureFunctionValue: TKeitley_Measure;
begin
 Result:=fTerminalMeasureFunction[Terminal];
end;

procedure TDMM6500.GetParametersFromDevice;
begin
  inherited GetParametersFromDevice;
  GetCardParametersFromDevice;

end;

function TDMM6500.IsPermittedMeasureFuncForChan(MeasureFunc: TKeitley_Measure;
  ChanNumber: byte): boolean;
begin
 Result:=False;
 if MeasureFunc in [kt_mCurDC,kt_mCurAC,kt_DigCur] then Exit;
 if (ChanNumber in [6..10])and(MeasureFunc in [kt_mRes4W,kt_mVoltRat]) then Exit;
 Result:=True;

end;

procedure TDMM6500.MyTraining;
// var i:integer;
begin
//  (fDevice as TTelnetMeterDeviceSingle).SetStringToSend(':SYST:CARD1:IDN?');
//  fDevice.Request();
//  fDevice.GetData;


SetCount(1,200);
if GetCount(1) then showmessage('Chan 1, Count='+inttostr(fChansMeasure[0].Count));

if GetCount() then showmessage('Count='+inttostr(Count));

SetCount(400000);

//GetMeasureFunction();
//if GetMeasureFunction(2) then
//  showmessage (Keitley_MeasureLabel[fChansMeasure[2].MeasureFunction])
//                         else
//  showmessage('ups :(');                        ;
//SetMeasureFunction(3,kt_DigVolt);
//if GetMeasureFunction(3) then
//  showmessage (Keitley_MeasureLabel[fChansMeasure[3].MeasureFunction])
//                         else
//  showmessage('ups :(');                        ;

//SetMeasureFunction;
//SetMeasureFunction(2);
//showmessage('uuu'+Keitley_MeasureLabel[MeasureFunction]);
//SetMeasureFunction(1,kt_mCurAC);
//SetMeasureFunction(11,kt_mTemp);
//SetMeasureFunction(5,kt_mTemp);
//showmessage('uuu'+Keitley_MeasureLabel[MeasureFunction]);
//SetMeasureFunction(2,4,kt_mRes4W);
//SetMeasureFunction(2,4,kt_mCurDC);
//SetMeasureFunction([9,3,5],kt_mFreq);
//SetMeasureFunction([9,3,5],kt_mVoltRat);

//---------------------------------------------------------------------------

//showmessage('kkk='+booltostr(TestShowEthernet,True));
// if  GetTrigerState then
//  showmessage('ura! '+Keitley_TriggerStateCommand[TrigerState]);

// if  GetFirstChannelInSlot then
//  showmessage('ura! '+inttostr(fFirstChannelInSlot));
// if  GetLastChannelInSlot then
//  showmessage('ura! '+inttostr(fLastChannelInSlot));
// if  GetChannelMaxVoltage then
//  showmessage('ura! '+floattostr(fChannelMaxVoltage));


//Beep;
//if TestPseudocard_Presence() then
// showmessage('ura!');
//PseudocardInstall;
//if TestPseudocard_Presence() then
// showmessage('ura!');
//PseudocardUnInstall;
//if TestPseudocard_Presence() then
// showmessage('ura!');


// if GetMeasureFunction then
//   showmessage('ura!!!'+Keitley_MeasureLabel[MeasureFunction]);


//for I := ord(Low(TKeitley_Measure)) to ord(High(TKeitley_Measure)) do
// SetMeasureFunction(TKeitley_Measure(i));

//BufferDataArrayExtended(2,10,kt_rd_M);
//showmessage(DataVector.XYtoString+#10+'Time'+#10+DataTimeVector.XYtoString);
//
//BufferDataArrayExtended(1,10,kt_rd_MST);
//showmessage(DataVector.XYtoString+#10+'Time'+#10+DataTimeVector.XYtoString);
//
//BufferDataArrayExtended(1,10,kt_rd_MT);
//showmessage(DataVector.XYtoString+#10+'Time'+#10+DataTimeVector.XYtoString);
//
//
//BufferDataArrayExtended(1,10,kt_rd_MS);
//showmessage(DataVector.XYtoString+#10+'Time'+#10+DataTimeVector.XYtoString);


//BufferLastDataExtended(kt_rd_MST,KeitleyDefBuffer);
//showmessage(floattostr(fDevice.Value)
//              +'  '+floattostr(fMeasureChanNumber)
//              +'  '+floattostr(TimeValue));

//BufferLastDataExtended(kt_rd_MT);
//showmessage(floattostr(fDevice.Value)+'  '+floattostr(fTimeValue));

//BufferLastDataExtended();
//showmessage(floattostr(fDevice.Value)+'  '+floattostr(fMeasureChanNumber));

// BufferLastDataSimple();
// showmessage(floattostr(fDevice.Value));

//if BufferGetFillMode() then
//  showmessage('ura! '+Keitley_BufferFillModeCommand[Buffer.FillMode]);
//
//if   BufferGetFillMode(KeitleyDefBuffer) then
//  showmessage('ura! '+Keitley_BufferFillModeCommand[Buffer.FillMode]);

//
//BufferSetFillMode(kt_fm_cont);
//BufferSetFillMode('TestBuffer',kt_fm_once);

//if BufferGetStartEndIndex()
//  then showmessage(inttostr(Buffer.StartIndex)+'  '+inttostr(Buffer.EndIndex))
//  else showmessage('ups :(');

//showmessage(inttostr(BufferGetReadingsNumber()));
//BufferCreate();
//showmessage(inttostr(BufferGetReadingsNumber(MyBuffer)));

//showmessage(inttostr(BufferGetSize));
//showmessage(inttostr(Buffer.CountMax));
//showmessage(inttostr(BufferGetSize(KeitleyDefBuffer)));

//BufferReSize(100);
//BufferReSize('TestBuffer',5);
//BufferClear(KeitleyDefBuffer);
//BufferDelete();
//BufferDelete('Test  Buffer ');
// BufferCreate();
// BufferCreate('Test  Buffer ',500,kt_bs_full);
// BufferCreate('Test  Buffer ',500,kt_bs_comp);
// BufferCreate(kt_bs_full);
// BufferCreate(kt_bs_comp);
//for I := ord(Low(TKeitley_Measure)) to ord(High(TKeitley_Measure)) do
// SetMeasureFunction(TKeitley_Measure(i));
// if GetMeasureFunction then
//   showmessage('ura!!!'+DMM65000_MeasureLabel[MeasureFunction]);
// TextToUserScreen('Hi, Oleg!','I am glad to see you');
// ClearUserScreen();
//showmessage(booltostr(GetTerminal(),True));
//Beep;
//SetDisplayBrightness(kt_ds_on75);
// GetDisplayBrightness;
// Test();
end;

procedure TDMM6500.PrepareString;
begin
 inherited PrepareString;
 if fChanOperation then
   begin
    fDevice.JoinToStringToSend(fChanOperationString);
    fChanOperation:=(Pos('?',(fDevice  as TKeitleyDevice).StringToSendActual)<>0);
//    showmessage('fChanOperation='+booltostr(fChanOperation,True));
   end;
end;

procedure TDMM6500.PrepareStringByRootNode;
begin
 inherited;
 case fRootNode of
  7:case fLeafNode of
     1,2:begin
          JoinToStringToSend(CardeafNodeDMM6500[0]);
          JoinToStringToSend(CardeafNodeDMM6500[fLeafNode]);
         end;
     3:JoinToStringToSend(CardeafNodeDMM6500[fLeafNode]);
     50..52:JoinToStringToSend(':'+DeleteSubstring(RootNodeKeitley[0],'*'));
    end;
  19:begin
       case fFirstLevelNode of
        33:JoinToStringToSend(Buffer.DataDemandDM6500Array(TKeitley_ReturnedData(fLeafNode)));
       end;
      end; // fRootNode=19
  22:case fFirstLevelNode of
       2..5:JoinToStringToSend(Buffer.DataDemandDM6500(TKeitley_ReturnedData(fFirstLevelNode-2)))
     end; // fRootNode=22
 end;
end;

procedure TDMM6500.ProcessingString(Str: string);
begin
 inherited ProcessingString(Str);
 if fChanOperation then ProcessingStringChanOperation;
end;

procedure TDMM6500.ProcessingStringByRootNode(Str: string);
begin
 inherited;
 case fRootNode of
  0:if pos(DMM6500_Test,Str)<>0 then fDevice.Value:=314;
  7:case fLeafNode of
     1,2:fDevice.Value:=StrToInt(Str);
     3:fDevice.Value:=SCPI_StringToValue(Str);
     50:if pos(SCAN2000_Test,Str)<>0 then fDevice.Value:=314;
//     51:if pos(TCSCAN2001_Test,Str)<>0 then fDevice.Value:=314;
     52:if pos(Pseudocard_Test,Str)<>0 then fDevice.Value:=314;
    end;
 end;

end;


procedure TDMM6500.ProcessingStringChanOperation;
begin
// fChanOperation:=False;
 if fDevice.Value=ErResult then Exit;

 case fRootNode of
  15:if fDevice.Value<=ord(kt_mVoltRat)
        then fChansMeasure[fMeasureChanNumber].MeasureFunction:=fMeasureFunction;
//       if fDevice.Value>ord(kt_mVoltRat)
//        then fChanOperation:=True
//        else fChansMeasureFunction[fMeasureChanNumber]:=fMeasureFunction;
  23:case fFirstLevelNode of
        15:fChansMeasure[fMeasureChanNumber].MeasureFunction:=fMeasureFunction;
      end;
 end;

end;

procedure TDMM6500.PseudocardInstall;
begin
// :SYST:PCAR 2000
 fAdditionalString:='2000';
 SetupOperation(7,46);
end;

procedure TDMM6500.PseudocardUnInstall;
begin
// :SYST:PCAR 0
 fAdditionalString:='0';
 SetupOperation(7,46);
end;

procedure TDMM6500.SetMeasureFunction(MeasureFunc: TKeitley_Measure);
begin
 inherited SetMeasureFunction(MeasureFunc);
 fTerminalMeasureFunction[Terminal]:=MeasureFunction;
end;


//procedure TDMM6500.SetMeasureFunctionChan(ChanNumberLow, ChanNumberHigh: byte;
procedure TDMM6500.SetMeasureFunction(ChanNumberLow, ChanNumberHigh: byte;
  MeasureFunc: TKeitley_Measure);
 var i:byte;
     tempbool:boolean;
begin
 tempbool:=True;
 for I := ChanNumberLow to ChanNumberHigh do
    if not(IsPermittedMeasureFuncForChan(MeasureFunc,i)) then
     begin
      tempbool:=False;
      Break;
     end;
 if ChanelNumberIsCorrect(ChanNumberLow, ChanNumberHigh) and tempbool then
   begin
     fChanOperationString:=PartDelimiter+ChanelToString(ChanNumberLow, ChanNumberHigh);
     fChanOperation:=True;
     inherited SetMeasureFunction(MeasureFunc);
     for I := ChanNumberLow-1 to ChanNumberHigh-1 do
       fChansMeasure[i].MeasureFunction:=MeasureFunc;
   end;
end;

procedure TDMM6500.SetMeasureFunction(ChanNumber: byte;
  MeasureFunc: TKeitley_Measure);
begin
 if ChanelNumberIsCorrect(ChanNumber) and IsPermittedMeasureFuncForChan(MeasureFunc,ChanNumber) then
   begin
     fChanOperationString:=PartDelimiter+ChanelToString(ChanNumber);
     fChanOperation:=True;
     inherited SetMeasureFunction(MeasureFunc);
     fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction:=MeasureFunc;
   end;
end;

procedure TDMM6500.SetCount(ChanNumber: byte; Cnt: integer);
begin
 if ChanelNumberIsCorrect(ChanNumber) then
   begin
     fChanOperationString:=PartDelimiter+ChanelToString(ChanNumber);
     fChanOperation:=True;
     inherited SetCount(Cnt);
     fChansMeasure[ChanNumber-fFirstChannelInSlot].Count:=Self.Count;
   end;
end;

procedure TDMM6500.SetCountNumber(Value: integer);
 const CountLimits:TLimitValues=(1,1000000);
begin
 fCount:=TSCPInew.NumberMap(Value,CountLimits);
end;

procedure TDMM6500.SetMeasureFunction(ChanNumbers: array of byte;
  MeasureFunc: TKeitley_Measure);
 var i:byte;
     tempbool:boolean;
begin
 tempbool:=True;
 for I := 0 to High(ChanNumbers) do
    if not(IsPermittedMeasureFuncForChan(MeasureFunc,ChanNumbers[i])) then
     begin
      tempbool:=False;
      Break;
     end;

 if ChanelNumberIsCorrect(ChanNumbers) and tempbool then
   begin
     fChanOperationString:=PartDelimiter+ChanelToString(ChanNumbers);
     fChanOperation:=True;
     inherited SetMeasureFunction(MeasureFunc);
     for I := 0 to High(ChanNumbers) do
       fChansMeasure[ChanNumbers[i]-fFirstChannelInSlot].MeasureFunction:=MeasureFunc;
   end;
end;

//procedure TDMM6500.SetMeasureFunctionChan(ChanNumber: byte;
//  MeasureFunc: TKeitley_Measure);
//begin
// if ChanelNumberIsCorrect(ChanNumber) and IsPermittedMeasureFuncForChan(MeasureFunc,ChanNumber) then
//   begin
//     fChanOperationString:=PartDelimiter+ChanelToString(ChanNumber);
//     fChanOperation:=True;
//     inherited SetMeasureFunction(MeasureFunc);
//     fChansMeasureFunction[ChanNumber-fFirstChannelInSlot]:=MeasureFunc;
//   end;
//end;

function TDMM6500.TestRealCard_Presence: boolean;
begin
// :SYST:CARD1:IDN?
 QuireOperation(7,45,50,False);
 Result:=(fDevice.Value=314);
 fRealCardPresent:=Result;
end;


function TDMM6500.TestPseudocard_Presence: boolean;
begin
 QuireOperation(7,45,52,False);
 Result:=(fDevice.Value=314);
end;

function TDMM6500.ChanelNumberIsCorrect(ChanNumber: byte): boolean;
begin
 Result:=(ChanNumber in [fFirstChannelInSlot..fLastChannelInSlot]){or(DeviceEthernetisAbsent)};
end;

function TDMM6500.ChanelNumberIsCorrect(ChanNumberLow,
  ChanNumberHigh: byte): boolean;
begin
 Result:=ChanelNumberIsCorrect(ChanNumberLow)
         and ChanelNumberIsCorrect(ChanNumberHigh);
end;

function TDMM6500.ChanelToString(ChanNumbers: array of byte): string;
 var i:byte;
begin
 Result:='(@';
 for I := Low(ChanNumbers) to High(ChanNumbers) do
   begin
   Result:=Result+inttostr(ChanNumbers[i]);
   if i<>High(ChanNumbers)
     then Result:=Result+PartDelimiter;
   end;
 Result:=Result+')';
end;

function TDMM6500.ChanQuire(ChanNumber: byte;
  QuireFunc: TQuireFunction): boolean;
begin
 if ChanelNumberIsCorrect(ChanNumber) then
   begin
     fMeasureChanNumber:=ChanNumber;
     fChanOperationString:=' '+ChanelToString(ChanNumber);
     fChanOperation:=True;
     Result := QuireFunc;
     fChanOperation:=False;
   end                                else
     Result:=False;
end;

procedure TDMM6500.ChansMeasureCreate;
 var i:byte;
begin
 if High(fChansMeasure)>-1 then
  for I := 0 to High(fChansMeasure) do
    FreeAndNil(fChansMeasure[i]);
 if (fFirstChannelInSlot=0)or(fLastChannelInSlot=0)
   then SetLength(fChansMeasure,0)
   else SetLength(fChansMeasure,fLastChannelInSlot-fFirstChannelInSlot+1);
 for I := 0 to High(fChansMeasure) do
   fChansMeasure[i]:=TDMM6500Channel.Create(i+1,Self);
end;

function TDMM6500.ChanelNumberIsCorrect(ChanNumbers: array of byte): boolean;
 var i:byte;
begin
  Result:=True;
  for I := Low(ChanNumbers) to High(ChanNumbers) do
    if not(ChanelNumberIsCorrect(ChanNumbers[i]))
      then
       begin
         Result:=False;
         Exit;
       end;
end;

{ TDMM6500MeasPar_Base }

constructor TDMM6500MeasPar_Base.Create;
begin
 inherited;
// fCount:=1;
 fDisplayDN:=6;
end;

//procedure TDMM6500MeasPar_Base.SetCountNumber(Value: integer);
// const CountLimits:TLimitValues=(1,1000000);
//begin
// fCount:=TSCPInew.NumberMap(Value,CountLimits);
//end;

{ TDMM6500MeasPar_BaseDelay }

constructor TDMM6500MeasPar_BaseDelay.Create;
begin
 inherited;
 fAutoDelay:=true;
end;

{ TDMM6500Channel }

constructor TDMM6500Channel.Create(ChanNumber: byte; DMM6500: TDMM6500);
begin
 inherited Create;
 FNumber:=ChanNumber;
 fDMM6500:=DMM6500;
 FMeasureFunction:=kt_mVolDC;
 fCount:=1;
end;

procedure TDMM6500Channel.SetCountNumber(Value: integer);
 const CountLimits:TLimitValues=(1,1000000);
       CountLimitsDig:TLimitValues=(1,55000000);
begin
 if FMeasureFunction in [kt_DigCur,kt_DigVolt]
   then fCount:=TSCPInew.NumberMap(Value,CountLimitsDig)
   else fCount:=TSCPInew.NumberMap(Value,CountLimits);
end;

{ TDMM6500MeasPar_BaseDig }

constructor TDMM6500MeasPar_BaseDig.Create;
begin
 inherited Create;
 fSampleRate:=1000;
end;

{ TDMM6500MeasPar_DigCur }

constructor TDMM6500MeasPar_DigVolt.Create;
begin
 inherited Create;
 fRange:=dm_vdr1000V;
 fBaseVolt:=TDMM6500MeasPar_BaseVoltDC.Create;
end;

destructor TDMM6500MeasPar_DigVolt.Destroy;
begin
  fBaseVolt.Free;
  inherited;
end;

function TDMM6500MeasPar_DigVolt.GetDB: double;
begin
 Result:=fBaseVolt.DB;
end;

function TDMM6500MeasPar_DigVolt.GetDBM: integer;
begin
 Result:=fBaseVolt.DBM;
end;

function TDMM6500MeasPar_DigVolt.GetInputImpedance: TDMM6500_InputImpedance;
begin
  Result:=fBaseVolt.InputImpedance;
end;

function TDMM6500MeasPar_DigVolt.GetUnits: TDMM6500_VoltageUnits;
begin
   Result:=fBaseVolt.Units;
end;

procedure TDMM6500MeasPar_DigVolt.SetInputImpedance(
  const Value: TDMM6500_InputImpedance);
begin
  fBaseVolt.InputImpedance:=Value;
end;

procedure TDMM6500MeasPar_DigVolt.SetUnits(const Value: TDMM6500_VoltageUnits);
begin
 fBaseVolt.Units:=Value;
end;

procedure TDMM6500MeasPar_DigVolt.SSetDB(const Value: double);
begin
 fBaseVolt.DB:=Value;
end;

procedure TDMM6500MeasPar_DigVolt.SSetDBM(const Value: integer);
begin
 fBaseVolt.DBM:=Value;
end;

{ TDMM6500MeasPar_DigVolt }

constructor TDMM6500MeasPar_DigCur.Create;
begin
 inherited Create;
  fRange:=dm_cdr3A;
end;

{ TDMM6500MeasPar_BaseVolt }

constructor TDMM6500MeasPar_BaseVolt.Create;
begin
 inherited Create;
 fUnits:=dm_vuVolt;
 fDB:=1;
 fDBM:=1;
 fDBMLimits[lvMin]:=1;
 fDBMLimits[lvMax]:=9999;
 fDBLimits[lvMin]:=1e-7;
 fDBLimits[lvMax]:=1000;//750
end;

procedure TDMM6500MeasPar_BaseVolt.SetDB(Value: double);
begin
 fDB:=TSCPInew.NumberMap(Value,fDBLimits);
end;

procedure TDMM6500MeasPar_BaseVolt.SetDBM(Value: integer);
begin
 fDBM:=TSCPInew.NumberMap(Value,fDBMLimits);
end;

{ TDMM6500MeasPar_BaseVoltDC }

constructor TDMM6500MeasPar_BaseVoltDC.Create;
begin
 inherited Create;
 fInputImpedance:=dm_ii10M;
end;

{ TDMM6500MeasPar_Capac }

constructor TDMM6500MeasPar_Capac.Create;
begin
 inherited Create;
 fRange:=dm_crAuto;
end;

{ TDMM6500MeasPar_BaseAC }

constructor TDMM6500MeasPar_BaseAC.Create;
begin
 inherited Create;
 fDetectorBW:=dm_dbw3Hz;
end;

{ TDMM6500MeasPar_CurACc }

constructor TDMM6500MeasPar_CurAC.Create;
begin
 inherited Create;
 fRange:=dm_carAuto;
end;

{ TDMM6500MeasPar_VoltAC }

constructor TDMM6500MeasPar_VoltAC.Create;
begin
  inherited Create;
  fBaseVolt:=TDMM6500MeasPar_BaseVolt.Create;
  fBaseVolt.fDBLimits[lvMax]:=750;
end;

destructor TDMM6500MeasPar_VoltAC.Destroy;
begin
  fBaseVolt.Free;
  inherited;
end;

function TDMM6500MeasPar_VoltAC.GetDB: double;
begin
  Result:=fBaseVolt.DB;
end;

function TDMM6500MeasPar_VoltAC.GetDBM: integer;
begin
 Result:=fBaseVolt.DBM;
end;

function TDMM6500MeasPar_VoltAC.GetUnits: TDMM6500_VoltageUnits;
begin
 Result:=fBaseVolt.Units;
end;

procedure TDMM6500MeasPar_VoltAC.SetUnits(const Value: TDMM6500_VoltageUnits);
begin
  fBaseVolt.Units:=Value;
end;

procedure TDMM6500MeasPar_VoltAC.SSetDB(const Value: double);
begin
  fBaseVolt.DB:=Value;
end;

procedure TDMM6500MeasPar_VoltAC.SSetDBM(const Value: integer);
begin
  fBaseVolt.DBM:=Value;
end;

{ TDMM6500MeasPar_BaseDelayMT }

constructor TDMM6500MeasPar_BaseDelayMT.Create;
begin
 inherited Create;
 fMTLimits[lvMin]:=0.01;
 fMTLimits[lvMax]:=240;
end;

procedure TDMM6500MeasPar_BaseDelayMT.SetMeaureTime(Value: double);
begin
  fMeaureTime:=TSCPInew.NumberMap(Value,fMTLimits);
end;

{ TDMM6500MeasPar_BasePeriod }

constructor TDMM6500MeasPar_FreqPeriod.Create;
begin
 inherited Create;
 fThresholdRange:=dm_vcrAuto;
end;

{ TDMM6500MeasPar_BaseMajority }

constructor TDMM6500MeasPar_BaseMajority.Create;
begin
 inherited Create;
 fAzeroState:=True;
 fLineSync:=False;
end;

{ TDMM6500MeasPar_CurDC }

constructor TDMM6500MeasPar_CurDC.Create;
begin
 inherited Create;
 fRange:=dm_cdrAuto;
end;

{ TDMM6500MeasPar_VoltDC }

constructor TDMM6500MeasPar_VoltDC.Create;
begin
 inherited Create;
 fRange:=dm_vdrAuto;
 fBaseVolt:=TDMM6500MeasPar_BaseVoltDC.Create;
end;

destructor TDMM6500MeasPar_VoltDC.Destroy;
begin
 fBaseVolt.Free;
 inherited;
end;

function TDMM6500MeasPar_VoltDC.GetDB: double;
begin
 Result:=fBaseVolt.DB;
end;

function TDMM6500MeasPar_VoltDC.GetDBM: integer;
begin
 Result:=fBaseVolt.DBM;
end;

function TDMM6500MeasPar_VoltDC.GetInputImpedance: TDMM6500_InputImpedance;
begin
 Result:=fBaseVolt.InputImpedance;
end;

function TDMM6500MeasPar_VoltDC.GetUnits: TDMM6500_VoltageUnits;
begin
  Result:=fBaseVolt.Units;
end;

procedure TDMM6500MeasPar_VoltDC.SetInputImpedance(
  const Value: TDMM6500_InputImpedance);
begin
  fBaseVolt.InputImpedance:=Value;
end;

procedure TDMM6500MeasPar_VoltDC.SetUnits(const Value: TDMM6500_VoltageUnits);
begin
  fBaseVolt.Units:=Value;
end;

procedure TDMM6500MeasPar_VoltDC.SSetDB(const Value: double);
begin
  fBaseVolt.DB:=Value;
end;

procedure TDMM6500MeasPar_VoltDC.SSetDBM(const Value: integer);
begin
  fBaseVolt.DBM:=Value;
end;

{ TDMM6500MeasPar_VoltRat }

constructor TDMM6500MeasPar_VoltRat.Create;
begin
 inherited Create;
 fRange:=dm_vdrAuto;
 fMethod:=dm_vrmPart;
end;

{ TDMM6500MeasPar_Res2W }

constructor TDMM6500MeasPar_Res2W.Create;
begin
 inherited Create;
 fRange:=dm_r2rAuto;
end;

{ TDMM6500MeasPar_Base4WT }

constructor TDMM6500MeasPar_Base4WT.Create;
begin
 inherited Create;
 fOffComp:=dm_ocAuto;
 fOpenLD:=False;
end;

{ TDMM6500MeasPar_Res4W }

constructor TDMM6500MeasPar_Res4W.Create;
begin
 inherited Create;
 fRange:=dm_r4rAuto;
end;

end.
