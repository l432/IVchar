unit Keithley2450;

interface

uses
  TelnetDevice, IdTelnet, ShowTypes, Keitley2450Const, SCPI;


type

 TKt_2450Device=class(TTelnetMeterDeviceSingle)
  private
   fSCPI:TSCPInew;
  protected
   procedure UpDate();override;
  public
   Constructor Create(SCPInew:TSCPInew;Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string);
 end;

 TKt_2450=class(TSCPInew)
  private
   fTelnet:TIdTelnet;
   fIPAdressShow: TIPAdressShow;
   fIsTripped:boolean;

   fTerminal:TKt2450_OutputTerminals;
   fOutPutOn:boolean;
   fResistanceCompencateOn:TKt2450_MeasureBool;
   fReadBack:TKt2450_SourceBool;
   fSences:TKt2450_Senses;
   fMeasureUnits:TKt_2450_MeasureUnits;
   fOutputOffState:TKt_2450_OutputOffStates;
   fSourceType:TKt2450_Source;
   fMeasureFunction:TKt2450_Measure;
   fVoltageProtection:TKt_2450_VoltageProtection;
   fVoltageLimit:double;
   fCurrentLimit:double;
   fMode:TKt_2450_Mode;
   fSourceVoltageRange:TKt2450VoltageRange;
   fSourceCurrentRange:TKt2450CurrentRange;
   procedure OnOffFromBool(toOn:boolean);
   function StringToVoltageProtection(Str:string;var vp:TKt_2450_VoltageProtection):boolean;
   function StringToSourceType(Str:string):boolean;
   function StringToMeasureFunction(Str:string):boolean;
   function StringToTerminals(Str:string):boolean;
   function StringToOutPutState(Str:string):boolean;
   function StringToMeasureUnit(Str:string):boolean;
   function IsLimitExcided(FirstLevelNode,LeafNode:byte):boolean;
   {типова функція для запиту, чи ввімкнув прилад певні захисти}
   function ModeDetermination:TKt_2450_Mode;
   function ValueToVoltageRange(Value:double):TKt2450VoltageRange;
   function ValueToCurrentRange(Value:double):TKt2450CurrentRange;
  protected
   procedure PrepareString;override;
   procedure DeviceCreate(Nm:string);override;
   procedure DefaultSettings;override;
  public
   property SourceType:TKt2450_Source read fSourceType;
   property MeasureFunction:TKt2450_Measure read fMeasureFunction;
   property VoltageProtection:TKt_2450_VoltageProtection read fVoltageProtection;
   property VoltageLimit:double read fVoltageLimit;
   property CurrentLimit:double read fCurrentLimit;
   property Terminal:TKt2450_OutputTerminals read fTerminal;
   property OutPutOn:boolean read fOutPutOn;
   property ResistanceCompencateOn:TKt2450_MeasureBool read fResistanceCompencateOn;
   property ReadBack:TKt2450_SourceBool read fReadBack;
   property Sences:TKt2450_Senses read fSences;
   property MeasureUnits:TKt_2450_MeasureUnits read fMeasureUnits;
   property OutputOffState:TKt_2450_OutputOffStates read fOutputOffState;
   property Mode:TKt_2450_Mode read fMode;
   property SourceVoltageRange:TKt2450VoltageRange read fSourceVoltageRange;
   property SourceCurrentRange:TKt2450CurrentRange read fSourceCurrentRange;
   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string='Keitley2450');

   function Test():boolean;override;
   procedure ProcessingString(Str:string);override;
   procedure ResetSetting();
   procedure MyTraining();

   procedure OutPutChange(toOn:boolean);
   {вмикає/вимикає вихід приладу}
   function  IsOutPutOn():boolean;

   procedure SetInterlockStatus(toOn:boolean);
   function IsInterlockOn():boolean;

   procedure ClearUserScreen();
   procedure TextToUserScreen(top_text:string='';bottom_text:string='');

   procedure SaveSetup(SlotNumber:TKt2450_SetupMemorySlot);
   procedure LoadSetup(SlotNumber:TKt2450_SetupMemorySlot);
   procedure LoadSetupPowerOn(SlotNumber:TKt2450_SetupMemorySlot);
   procedure UnloadSetupPowerOn();
   procedure RunningMacroScript(ScriptName:string);

   procedure SetTerminal(Terminal:TKt2450_OutputTerminals);
   {вихід на передню чи задню панель}
   function GetTerminal():boolean;
   {вихід на передню чи задню панель}

   procedure SetSense(MeasureType:TKt2450_Measure;Sense:TKt2450_Sense);
   {2-зондовий чи 4-зондовий спосіб вимірювання}
   function GetSense(MeasureType:TKt2450_Measure):boolean;
   function GetSenses():boolean;


   procedure SetOutputOffState(Source:TKt2450_Source;
                           OutputOffState:TKt_2450_OutputOffState);
   {перемикання типу входу: нормальний, високоімпедансний тощо}
   function GetOutputOffState(Source:TKt2450_Source):boolean;
   function GetOutputOffStates():boolean;

   procedure SetReadBackState(Source:TKt2450_Source;
                              toOn:boolean);overload;
   {чи вимірюється те значення, що подається з приладу;
   якщо ні - то буде використовуватися (в розрахунках, тощо)
   значення, яке заплановано}
   procedure SetReadBackState(toOn:boolean);overload;
   function IsReadBackOn(Source:TKt2450_Source):boolean;overload;
   function IsReadBackOn():boolean;overload;
   function GetReadBacks():boolean;

   procedure SetResistanceCompencate(toOn:boolean);
   {ввімкнення/вимкнення компенсації опору}
   function IsResistanceCompencateOn():boolean;

   procedure SetVoltageProtection(Level:TKt_2450_VoltageProtection);
   {встановлення значення захисту від перенапруги}
   function  GetVoltageProtection():boolean;
   {запит номеру режиму в TKt_2450_VoltageProtection}
   function IsVoltageProtectionActive():boolean;
   {перевірка, чи вімкнувся захист від перенапруги}

   procedure SetVoltageLimit(Value:double=0);
   {встановлення граничної напруги джерела}
   procedure SetCurrentLimit(Value:double=0);
   {встановлення граничного струму джерела}
   function  GetVoltageLimit():boolean;
   {запит величини граничної напруги джерела}
   function  GetCurrentLimit():boolean;
   {запит величини граничної напруги джерела}
   function IsVoltageLimitExceeded():boolean;
   {перевірка, чи була спроба перевищення напруги}
   function IsCurrentLimitExceeded():boolean;
   {перевірка, чи була спроба перевищення напруги}

   procedure SetSourceType(SourseType:TKt2450_Source=kt_sVolt);
   {прилад як джерело напруги чи струму;
   при цьому вихід виключається OutPut=Off}
   function GetSourceType():boolean;

   procedure SetMeasureFunction(MeasureFunction:TKt2450_Measure=kt_mCurrent);
   {прилад вимірює напругу чи струм}
   function GetMeasureFunction():boolean;

   procedure SetMeasureUnit(Measure:TKt2450_Measure; MeasureUnit:TKt_2450_MeasureUnit);
   {що буде вимірювати (розраховувати) при реальних вимірах Measure}
   function GetMeasureUnit(Measure:TKt2450_Measure):boolean;
   function GetMeasureUnits():boolean;

   procedure SetMode(Mode:TKt_2450_Mode);
   function GetDeviceMode():boolean;

   procedure SetSourceVoltageRange(Range:TKt2450VoltageRange=kt_vrAuto);
   function GetSourceVoltageRange():boolean;
   procedure SetSourceCurrentRange(Range:TKt2450CurrentRange=kt_crAuto);
   function GetSourceCurrentRange():boolean;
   function GetSourceRanges():boolean;

   Procedure GetParametersFromDevice;
 end;


var
  Kt_2450:TKt_2450;

implementation

uses
  Dialogs, SysUtils, OlegType, Math;

{ TKt_2450 }

procedure TKt_2450.ClearUserScreen;
begin
// :DISP:CLE
 SetupOperation(6,3,0,false);
end;

constructor TKt_2450.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
 fTelnet:=Telnet;
 fIPAdressShow:=IPAdressShow;
 inherited Create(Nm);
end;

procedure TKt_2450.ResetSetting;
begin
//  *RST
  SetupOperation(2,0,0,False);
end;

procedure TKt_2450.RunningMacroScript(ScriptName: string);
begin
//  SCR:RUN "ScriptName"
  fAdditionalString:=StringToInvertedCommas(ScriptName);
  SetupOperation(8);
end;

procedure TKt_2450.DefaultSettings;
 var i:integer;
begin
 fIsTripped:=False;
 fSourceType:=kt_sVolt;
 fMeasureFunction:=kt_mCurrent;
 fVoltageProtection:=kt_vpnone;
 fVoltageLimit:=Kt_2450_VoltageLimDef;
 fCurrentLimit:=Kt_2450_CurrentLimDef;
 fTerminal:=kt_otFront;
 fOutPutOn:=False;
// fResistanceCompencateOn:=False;
 for I := ord(Low(TKt2450_Measure)) to ord(High(TKt2450_Measure)) do
   begin
   fSences[TKt2450_Measure(i)]:=kt_s2wire;
   fMeasureUnits[TKt2450_Measure(i)]:=kt_mu_amp;
   fResistanceCompencateOn[TKt2450_Measure(i)]:=False;
   end;
 for I := ord(Low(TKt2450_Source)) to ord(High(TKt2450_Source)) do
   begin
   fReadBack[TKt2450_Source(i)]:=True;
   end;
 for I := ord(Low(TKt2450_Source)) to ord(High(TKt2450_Source)) do
   fOutputOffState[TKt2450_Source(i)]:=kt_oos_norm;
 fMode:=ModeDetermination();
// fMode:=kt_md_sVmP;
 fSourceVoltageRange:=kt_vrAuto;
 fSourceCurrentRange:=kt_crAuto;
end;

procedure TKt_2450.DeviceCreate(Nm: string);
begin
 fDevice:=TKt_2450Device.Create(Self,fTelnet,fIPAdressShow,Nm);
end;

function TKt_2450.GetCurrentLimit: boolean;
begin
 QuireOperation(11,13,13);
 Result:=(fDevice.Value<>ErResult);
 if Result then fCurrentLimit:=fDevice.Value;
end;

function TKt_2450.GetDeviceMode: boolean;
begin
 Result:=True;
 Result:=Result and GetMeasureFunction();
 Result:=Result and GetMeasureUnit(fMeasureFunction);
 Result:=Result and GetSourceType();
 if Result then fMode:=ModeDetermination;
end;

function TKt_2450.IsInterlockOn: boolean;
begin
//:OUTP:INT:STAT?
 QuireOperation(5,5);
 Result:=(fDevice.Value=1);
end;

function TKt_2450.GetMeasureFunction: boolean;
begin
 QuireOperation(15);
 Result:=(fDevice.Value<>ErResult);
// showmessage('measure '+inttostr(ord(fMeasureFunction)))
end;

function TKt_2450.GetMeasureUnit(Measure: TKt2450_Measure): boolean;
begin
 Result:=False;
 if Measure>kt_mVoltage then Exit;
 QuireOperation(ord(Measure)+12,14);
 Result:=(fDevice.Value<>ErResult);
// showmessage('measure2 '+inttostr(ord(Measure)));
//  showmessage('unit '+inttostr(ord(fMeasureUnits[Measure])))

end;

function TKt_2450.GetMeasureUnits: boolean;
 var i:TKt2450_Measure;
begin
 Result:=True;
 for I := kt_mCurrent to kt_mVoltage do
   Result:=Result and GetMeasureUnit(i);
end;

function TKt_2450.GetOutputOffState(Source: TKt2450_Source): boolean;
begin
 QuireOperation(5,1-ord(Source),8);
 Result:=(fDevice.Value<>ErResult);
// fOutputOffState[Source]:=TKt_2450_OutputOffState(round(fDevice.Value));
end;

function TKt_2450.GetOutputOffStates: boolean;
 var i:TKt2450_Source;
begin
 Result:=True;
 for I := Low(TKt2450_Source) to High(TKt2450_Source) do
   Result:=Result and GetOutputOffState(i);
end;

procedure TKt_2450.GetParametersFromDevice;
begin
 if not(GetVoltageProtection()) then Exit;
 if not(GetVoltageLimit()) then Exit;
 if not(GetCurrentLimit()) then Exit;
 if not(GetSourceType()) then Exit;  //GetDeviceMode
 if not(GetMeasureFunction()) then Exit; //GetDeviceMode
 if not(IsResistanceCompencateOn()) then Exit;  //має бути після GetMeasureFunction

 if not(GetTerminal()) then Exit;
 if not(IsOutPutOn()) then Exit;
 if not(GetSenses()) then Exit;
 if not(GetOutputOffStates()) then Exit;
 if not(GetMeasureUnits()) then Exit; //GetDeviceMode
 fMode:=ModeDetermination();
 if not(GetReadBacks()) then Exit;
 if not(GetSourceRanges()) then Exit;

end;

function TKt_2450.IsReadBackOn(Source: TKt2450_Source): boolean;
begin
 QuireOperation(11,1-ord(Source)+12,17);
 Result:=(fDevice.Value=1);
 fReadBack[Source]:=Result;
end;

function TKt_2450.GetReadBacks: boolean;
 var i:TKt2450_Source;
begin
 Result:=True;
 for I := Low(TKt2450_Source) to High(TKt2450_Source) do
   Result:=Result and IsReadBackOn(i);
end;

function TKt_2450.GetSense(MeasureType: TKt2450_Measure): boolean;
begin
 QuireOperation(12+ord(MeasureType),7);
 Result:=(fDevice.Value<>ErResult);
 fSences[MeasureType]:=TKt2450_Sense(1-round(fDevice.Value));
end;

function TKt_2450.GetSenses: boolean;
 var i:TKt2450_Measure;
begin
 Result:=True;
 for I := Low(TKt2450_Measure) to High(TKt2450_Measure) do
   Result:=Result and GetSense(i);
end;

function TKt_2450.GetSourceCurrentRange: boolean;
begin
 Result:=True;
 QuireOperation(11,12,16);
 if fDevice.Value=1 then  fSourceVoltageRange:=kt_vrAuto
                    else
   begin
    try
    QuireOperation(11,12,15);
    fSourceCurrentRange:=ValueToCurrentRange(fDevice.Value);
//    TKt2450CurrentRange(round(Log10(fDevice.Value/1e-8))+1);
    except
    Result:=false
    end;
   end;
end;

function TKt_2450.GetSourceRanges: boolean;
begin
 Result:=GetSourceVoltageRange() and GetSourceCurrentRange();
end;

function TKt_2450.GetSourceType: boolean;
begin
 QuireOperation(11,55,55);
 Result:=(fDevice.Value<>ErResult);
end;

function TKt_2450.GetSourceVoltageRange:boolean;
// var value:double;
begin
 Result:=True;
 QuireOperation(11,13,16);
 if fDevice.Value=1 then  fSourceVoltageRange:=kt_vrAuto
                    else
   begin
    try
    QuireOperation(11,13,15);
    fSourceVoltageRange:=ValueToVoltageRange(fDevice.Value);
//    TKt2450VoltageRange(round(Log10(fDevice.Value/2e-2))+1);
    except
    result:=false
    end;
   end;
end;

function TKt_2450.GetTerminal: boolean;
begin
 QuireOperation(9,6);
 Result:=(fDevice.Value<>ErResult);
end;

function TKt_2450.GetVoltageLimit: boolean;
begin
 QuireOperation(11,12,12);
 Result:=(fDevice.Value<>ErResult);
 if Result then fVoltageLimit:=fDevice.Value;
end;

function TKt_2450.GetVoltageProtection: boolean;
begin
 QuireOperation(11,13,10);
 Result:=(fDevice.Value<>ErResult);
end;

function TKt_2450.IsCurrentLimitExceeded: boolean;
begin
 Result:=IsLimitExcided(13,13);
end;

function TKt_2450.IsLimitExcided(FirstLevelNode, LeafNode: byte): boolean;
begin
 fIsTripped:=True;
 QuireOperation(11,FirstLevelNode,LeafNode);
 Result:=(fDevice.Value=1);
 fIsTripped:=False;
end;

function TKt_2450.IsOutPutOn: boolean;
begin
 QuireOperation(5,55);
 Result:=(fDevice.Value=1);
 fOutPutOn:=Result;
end;

function TKt_2450.IsReadBackOn: boolean;
begin
 Result:=IsReadBackOn(fSourceType);
end;

function TKt_2450.IsResistanceCompencateOn: boolean;
begin
 case fMeasureFunction of
   kt_mCurrent: QuireOperation(12,9);
   kt_mVoltage: QuireOperation(13,9);
 end;
 Result:=(fDevice.Value=1);
 fResistanceCompencateOn[fMeasureFunction]:=Result;
end;

function TKt_2450.IsVoltageLimitExceeded: boolean;
begin
 Result:=IsLimitExcided(12,12);
end;

function TKt_2450.IsVoltageProtectionActive: boolean;
begin
 Result:=IsLimitExcided(13,10);
end;

procedure TKt_2450.LoadSetup(SlotNumber: TKt2450_SetupMemorySlot);
begin
// *RCL <n>
 fAdditionalString:=inttostr(SlotNumber);
 SetupOperation(1);
end;

procedure TKt_2450.LoadSetupPowerOn(SlotNumber: TKt2450_SetupMemorySlot);
begin
//  SYST:POS SAV1
  fAdditionalString:='sav'+inttostr(SlotNumber);
  SetupOperation(7,4);
end;

function TKt_2450.ModeDetermination: TKt_2450_Mode;
begin
 Result:=kt_md_sVmC;
// case fSourceType of
//   kt_sVolt: case fMeasureFunction of
//             kt_mCurrent:Result:=TKt_2450_Mode(ord(fMeasureUnits[kt_mCurrent]));
//             kt_mVoltage:Result:=TKt_2450_Mode(ord(fMeasureUnits[kt_mVoltage]));
//             end;
//   kt_sCurr:case fMeasureFunction of
//             kt_mCurrent:Result:=TKt_2450_Mode(3+ord(fMeasureUnits[kt_mCurrent]));
//             kt_mVoltage:Result:=TKt_2450_Mode(3+ord(fMeasureUnits[kt_mCurrent]));
//             end;
// end;

// showmessage('mode '+inttostr(ord(fMeasureUnits[fMeasureFunction])));
 case fSourceType of
   kt_sVolt:Result:=TKt_2450_Mode(ord(fMeasureUnits[fMeasureFunction]));
   kt_sCurr:Result:=TKt_2450_Mode(4+ord(fMeasureUnits[fMeasureFunction]));
 end;

//       TKt_2450_MeasureUnit=(kt_mu_amp,kt_mu_volt, kt_mu_ohm, kt_mu_watt);
end;

procedure TKt_2450.MyTraining;
// var str:string;
begin
//  (fDevice as TTelnetMeterDeviceSingle).SetStringToSend(':FORMat:ASCii:PRECision?');
//  (fDevice as TTelnetMeterDeviceSingle).SetStringToSend(':SOUR:VOLT:RANG:Auto?');
//  fDevice.Request();
//  fDevice.GetData;

//if GetSourceVoltageRange() then
//  showmessage('ura! '+KT2450_VoltageRangeLabels[fSourceVoltageRange]);
//if GetSourceCurrentRange() then
//  showmessage('ura! '+KT2450_CurrentRangeLabels[fSourceCurrentRange]);

//SetSourceVoltageRange();
//SetSourceVoltageRange(kt_vr200mV);
//SetSourceVoltageRange(kt_vr20V);

//SetSourceCurrentRange();
//SetSourceCurrentRange(kt_vr10nA);
//SetSourceCurrentRange(kt_vr100mA);

// showmessage(booltostr(IsReadBackOn(),True));
// SetReadBackState(False);
// showmessage(booltostr(IsReadBackOn(),True));

//SetReadBackState(kt_sVolt,False);
//SetReadBackState(kt_sVolt,True);
//SetReadBackState(True);

//SetMode(kt_md_sVmR);
//SetMode(kt_md_sImV);

//if GetMeasureUnit(kt_mCurrent) then
//  showmessage('ura! '+SuffixKt_2450[ord(fMeasureUnits[kt_mCurrent])+4]);
//SetMeasureUnit(kt_mCurrent,kt_mu_ohm);
//if GetMeasureUnit(kt_mCurrent) then
//  showmessage('ura! '+SuffixKt_2450[ord(fMeasureUnits[kt_mCurrent])+4]);
//SetMeasureUnit(kt_mVoltage,kt_mu_watt);
//if GetMeasureUnit(kt_mVoltage) then
//  showmessage('ura! '+SuffixKt_2450[ord(fMeasureUnits[kt_mVoltage])+4]);

//SetMeasureUnit(kt_mCurrent,kt_mu_amp);
//SetMeasureUnit(kt_mCurrent,kt_mu_volt);
//SetMeasureUnit(kt_mCurrent,kt_mu_ohm);
//SetMeasureUnit(kt_mCurrent,kt_mu_watt);
//SetMeasureUnit(kt_mVoltage,kt_mu_ohm);


// if GetMeasureFunction()
//    then showmessage('ura!'+RootNoodKt_2450[ord(fMeasureFunction)+12]);
// SetMeasureFunction(kt_mVoltage);
// if GetMeasureFunction()
//   then showmessage('ura!'+RootNoodKt_2450[ord(fMeasureFunction)+12]);

//SetMeasureFunction();
//SetMeasureFunction(kt_mVoltage);
//SetMeasureFunction(kt_mResistance);

// if GetSourceType() then showmessage(Kt2450_SourceName[fSourceType]);
// SetSourceType(kt_sCurr);
// if GetSourceType() then showmessage(Kt2450_SourceName[fSourceType]);

//SetSourceType();
//SetSourceType(kt_sCurr);

// showmessage(booltostr(IsCurrentLimitExceeded(),True));
// showmessage(booltostr(IsVoltageLimitExceeded(),True));

//  SetCurrentLimit(21e-9);
//  if GetCurrentLimit() then
//   showmessage('ura! '+floattostr(fCurrentLimit));
//  SetCurrentLimit(5.3681e-6);
//  if GetCurrentLimit() then
//   showmessage('ura! '+floattostr(fCurrentLimit));
//  SetCurrentLimit(0.05289);
//  if GetCurrentLimit() then
//   showmessage('ura! '+floattostr(fCurrentLimit));
//  SetCurrentLimit(0.502);
//  if GetCurrentLimit() then
//   showmessage('ura! '+floattostr(fCurrentLimit));
//  SetCurrentLimit();

// SetVoltageLimit();
// if GetVoltageLimit() then
//   showmessage('ura! '+floattostr(fVoltageLimit));
// SetVoltageLimit(300);
// if GetVoltageLimit() then
//   showmessage('ura! '+floattostr(fVoltageLimit));
// SetVoltageLimit(0.0211);
// if GetVoltageLimit() then
//   showmessage('ura! '+floattostr(fVoltageLimit));

// SetCurrentLimit();
// SetCurrentLimit(2);
// SetCurrentLimit(1.578968e-6);

// SetVoltageLimit();
// SetVoltageLimit(300);
// SetVoltageLimit(20.12345678);

// showmessage(booltostr(IsVoltageProtectionActive(),True));

// if  GetVoltageProtection() then
//   showmessage(Kt_2450_VoltageProtectionLabel[fVoltageProtection]);
//  SetVoltageProtection(kt_vpnone);

// fMeasureFunction:=kt_mCurrent;
// showmessage(booltostr(IsResistanceCompencateOn(),True));
//
// fMeasureFunction:=kt_mVoltage;
// showmessage(booltostr(IsResistanceCompencateOn(),True));

// fMeasureFunction:=kt_mCurrent;
// SetResistanceCompencate(True);
// SetResistanceCompencate(False);
//
// fMeasureFunction:=kt_mVoltage;
// SetResistanceCompencate(True);
// SetResistanceCompencate(False);


//SetOutputOffState(kt_sVolt,kt_oos_zero);
//if GetOutputOffState(kt_sVolt)
//   then showmessage('ura!! '+KT2450_OutputOffStateLabels[fOutputOffState[kt_sVolt]]);
//SetOutputOffState(kt_sVolt,kt_oos_himp);
//if GetOutputOffState(kt_sVolt)
//   then showmessage('ura!! '+KT2450_OutputOffStateLabels[fOutputOffState[kt_sVolt]]);
//SetOutputOffState(kt_sVolt,kt_oos_norm);
//if GetOutputOffState(kt_sVolt)
//   then showmessage('ura!! '+KT2450_OutputOffStateLabels[fOutputOffState[kt_sVolt]]);
//
//SetOutputOffState(kt_sCurr,kt_oos_guard);
//if GetOutputOffState(kt_sCurr)
//   then showmessage('ura!! '+KT2450_OutputOffStateLabels[fOutputOffState[kt_sCurr]]);
//SetOutputOffState(kt_sCurr,kt_oos_norm);
//if GetOutputOffState(kt_sCurr)
//   then showmessage('ura!! '+KT2450_OutputOffStateLabels[fOutputOffState[kt_sCurr]]);


//SetSense(kt_mCurrent,kt_s4wire);
//GetSense(kt_mCurrent);
//showmessage(inttostr(ord(fSences[kt_mCurrent])));
//SetSense(kt_mCurrent,kt_s2wire);
//showmessage(inttostr(ord(fSences[kt_mCurrent])));

//GetSense(kt_mVoltage);
//showmessage(inttostr(ord(fSences[kt_mVoltage])));

//SetSense(kt_mResistance,kt_s4wire);
//GetSense(kt_mResistance);
//showmessage(inttostr(ord(fSences[kt_mResistance])));
//SetSense(kt_mResistance,kt_s2wire);
//GetSense(kt_mResistance);
//showmessage(inttostr(ord(fSences[kt_mResistance])));

//showmessage(booltostr(IsOutPutOn(),True));

//showmessage(booltostr(GetTerminals(),True));


//LoadSetupPowerOn(1);
//UnloadSetupPowerOn();

// SetInterlockStatus(false);
// showmessage(booltostr(IsInterlockOn,True));

// TextToUserScreen('Hi, Oleg!','I am glad to see you');
// ClearUserScreen();

end;

procedure TKt_2450.OnOffFromBool(toOn: boolean);
begin
 if toOn then fAdditionalString:=SuffixKt_2450[0]
         else fAdditionalString:=SuffixKt_2450[1];
end;

procedure TKt_2450.OutPutChange(toOn: boolean);
begin
// :OUTP ON|Off
 OnOffFromBool(toOn);
 SetupOperation(5,55);
 fOutPutOn:=toOn;
end;

procedure TKt_2450.PrepareString;
begin
 (fDevice as TKt_2450Device).ClearStringToSend;
 (fDevice as TKt_2450Device).SetStringToSend(RootNoodKt_2450[fRootNode]);
 case fRootNode of
  5:begin
////     JoinToStringToSend(FirstNodeKt_2450_5[fFirstLevelNode]);
    case fFirstLevelNode of
     5: fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
     0..1:begin
//     SetupOperation(5,1-ord(Source),8);
           fDevice.JoinToStringToSend(RootNoodKt_2450[12+fFirstLevelNode]);
           fDevice.JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
          end;
    end;
    end;
  6:begin
//        SetupOperation(6,0);
//        SetupOperation(6,1);
//        SetupOperation(6,2);
     fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
    end;
   7:begin
//        SetupOperation(7,4);
      fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
     end;
   9:begin
//      SetupOperation(9,6);
      fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);

     end;

   11:begin
      case fFirstLevelNode of
       12..13:begin
//    SetupOperation(11,13,10)замість SetupOperation(11,1,0);
//    SetupOperation(11,12,12)замість SetupOperation(11,0,2);
//    SetupOperation(11,13,13);
//    SetupOperation(11,12|13,17);
//    SetupOperation(11,13,16);
           fDevice.JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
           fDevice.JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
           if fIsTripped then fDevice.JoinToStringToSend(FirstNodeKt_2450[11]);
          end;
//        SetupOperation(11,55,14);
       55:fDevice.JoinToStringToSend(RootNoodKt_2450[15]);
//       fDevice.JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
      end;
      end;
     12..14:
       begin
//          SetupOperation(12+ord(MeasureType),7);
//          SetupOperation(ord(Measure)+12,14);
            fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
       end;

     end;

 if fIsSuffix then JoinAddString;

end;

procedure TKt_2450.ProcessingString(Str: string);
begin
 Str:=Trim(Str);
 case fRootNode of
  0:if pos(Kt_2450_Test,Str)<>0 then fDevice.Value:=314;
  5:begin
    case fFirstLevelNode of
     5,55:fDevice.Value:=StrToInt(Str);
     0..1:begin
//     QuireOperation(5,1-ord(Source),8);
        if StringToOutPutState(AnsiLowerCase(Str))
            then fDevice.Value:=ord(fOutputOffState[TKt2450_Source(fFirstLevelNode)]);
          end;
    end;
    end;
  9:begin
//     QuireOperation(9,6);
     if StringToTerminals(AnsiLowerCase(Str))
          then fDevice.Value:=ord(fTerminal);
    end;

  11:begin
//      QuireOperation(11,13,10);

// QuireOperation(11,12,12);

     case fLeafNode of
      10:if StringToVoltageProtection(AnsiLowerCase(Str),fVoltageProtection)
          then fDevice.Value:=ord(fVoltageProtection);
//      QuireOperation(11,13,15);
      12..13,15:fDevice.Value:=SCPI_StringToValue(Str);
//      2..3:fDevice.Value:=SCPI_StringToValue(Str);
//          QuireOperation(11,55,14);
      55:if StringToSourceType(AnsiLowerCase(Str)) then fDevice.Value:=ord(fSourceType);
// QuireOperation(11,1-ord(Source),17);
//QuireOperation(11,13,16);
      16,17:fDevice.Value:=StrToInt(Str);
//      QuireOperation(11,13,15);
//      15:;
     end;
     end;
   12..14:begin
            case fFirstLevelNode of
//          QuireOperation(12+ord(MeasureType),7);
//          QuireOperation(12|13,9);
             7,9: fDevice.Value:=StrToInt(Str);
 //          QuireOperation(12|13,14);
             14: if StringToMeasureUnit(AnsiLowerCase(Str))
                    then fDevice.Value:=ord(fMeasureUnits[TKt2450_Measure(fFirstLevelNode-12)]);
            end;

         end;
   15:if StringToMeasureFunction(AnsiLowerCase(Str)) then fDevice.Value:=ord(fMeasureFunction);
 end;

end;

procedure TKt_2450.SaveSetup(SlotNumber: TKt2450_SetupMemorySlot);
begin
// *SAV <n>
 fAdditionalString:=inttostr(SlotNumber);
 SetupOperation(3);
end;

procedure TKt_2450.SetCurrentLimit(Value: double);
begin
// :SOUR:VOLT:ILIM <value>
if Value=0 then
     begin
      fAdditionalString:=SuffixKt_2450[3];
      fCurrentLimit:=Kt_2450_CurrentLimDef;
     end
           else
     begin
      fAdditionalString:=FloatToStrLimited(Value,Kt_2450_CurrentLimLimits);
      fCurrentLimit:=strtofloat(fAdditionalString);
     end;
 SetupOperation(11,13,13);
end;

procedure TKt_2450.SetInterlockStatus(toOn: boolean);
begin
// :OUTP:INT:STAT on|off
 OnOffFromBool(toOn);
 SetupOperation(5,5);
end;

procedure TKt_2450.SetMeasureFunction(MeasureFunction: TKt2450_Measure);
begin
// :FUNC "VOLT"|"CURR"
 case MeasureFunction of
  kt_mCurrent:fAdditionalString:=StringToInvertedCommas(DeleteSubstring(RootNoodKt_2450[12]));
  kt_mVoltage:fAdditionalString:=StringToInvertedCommas(DeleteSubstring(RootNoodKt_2450[13]));
  kt_mResistance:Exit;
 end;

 SetupOperation(15);
 fMeasureFunction:=MeasureFunction;
end;

procedure TKt_2450.SetMeasureUnit(Measure: TKt2450_Measure;
     MeasureUnit: TKt_2450_MeasureUnit);
begin
// :VOLT|CURR:UNIT VOLT|AMP|OHM|WATT
  if Measure>kt_mVoltage then Exit;
  if (Measure=kt_mVoltage)and(MeasureUnit=kt_mu_amp)
                  then Exit;
  if (Measure=kt_mCurrent)and(MeasureUnit=kt_mu_volt)
                 then Exit;
  fAdditionalString:=SuffixKt_2450[ord(MeasureUnit)+4];
 SetupOperation(ord(Measure)+12,14);
 fMeasureUnits[Measure]:=MeasureUnit;
end;

procedure TKt_2450.SetMode(Mode: TKt_2450_Mode);
begin
 if Mode in [kt_md_sVmC,kt_md_sVmR,kt_md_sVmP,kt_md_sImC]
     then SetMeasureFunction()
     else SetMeasureFunction(kt_mVoltage);
 case Mode of
  kt_md_sVmC:SetMeasureUnit(kt_mCurrent,kt_mu_amp);
  kt_md_sVmV:SetMeasureUnit(kt_mVoltage,kt_mu_volt);
  kt_md_sVmR:SetMeasureUnit(kt_mCurrent,kt_mu_ohm);
  kt_md_sVmP:SetMeasureUnit(kt_mCurrent,kt_mu_watt);
  kt_md_sImC:SetMeasureUnit(kt_mCurrent,kt_mu_amp);
  kt_md_sImV:SetMeasureUnit(kt_mVoltage,kt_mu_volt);
  kt_md_sImR:SetMeasureUnit(kt_mVoltage,kt_mu_ohm);
  kt_md_sImP:SetMeasureUnit(kt_mVoltage,kt_mu_watt);
 end;
 if Mode in [kt_md_sVmC..kt_md_sVmP]
     then SetSourceType(kt_sVolt)
     else SetSourceType(kt_sCurr);
  fMode:=Mode;
end;

procedure TKt_2450.SetOutputOffState(Source:TKt2450_Source;
                           OutputOffState:TKt_2450_OutputOffState);
begin
//:OUTP:CURR|VOLT:SMOD  NORM|HIMP|ZERO|GUARd
 fAdditionalString:=Kt_2450_OutputOffStateName[OutputOffState];
 SetupOperation(5,1-ord(Source),8);
 fOutputOffState[Source]:=OutputOffState;
end;

procedure TKt_2450.SetReadBackState(Source: TKt2450_Source; toOn: boolean);
begin
//SOUR:VOLT|CURR:READ:BACK ON|OFF
 OnOffFromBool(toOn);
 SetupOperation(11,1-ord(Source)+12,17);
 fReadBack[Source]:=toOn;
end;

procedure TKt_2450.SetReadBackState(toOn: boolean);
begin
  SetReadBackState(fSourceType,toOn);
end;

procedure TKt_2450.SetResistanceCompencate(toOn: boolean);
begin
// RES:OCOM ON|OFF
 OnOffFromBool(toOn);
 case fMeasureFunction of
   kt_mCurrent: SetupOperation(12,9);
   kt_mVoltage: SetupOperation(13,9);
 end;
 fResistanceCompencateOn[fMeasureFunction]:=toOn;
end;

procedure TKt_2450.SetSense(MeasureType: TKt2450_Measure; Sense: TKt2450_Sense);
begin
// :CURR|VOLT|RES:RSEN ON(1)|OFF(0)
 fAdditionalString:=SuffixKt_2450[ord(Sense)];
 SetupOperation(12+ord(MeasureType),7);
 fSences[MeasureType]:=Sense;
end;

procedure TKt_2450.SetSourceCurrentRange(Range: TKt2450CurrentRange);
begin
//:SOUR:CURR:RANG  <value>
//:SOUR:CURR:RANG:AUTO ON
 if Range=kt_crAuto then
       begin
        OnOffFromBool(True);
        SetupOperation(11,12,16);
       end         else
       begin
         fAdditionalString:=floattostr(1e-8*Power(10,ord(Range)-1));
         SetupOperation(11,12,15);
       end;
 fSourceCurrentRange:=Range;
end;

procedure TKt_2450.SetSourceType(SourseType: TKt2450_Source);
begin
// SOUR:FUNC CURR|VOLT
 fAdditionalString:=Kt2450_SourceName[SourseType];
 SetupOperation(11,55);
 fSourceType:=SourseType;
end;

procedure TKt_2450.SetSourceVoltageRange(Range: TKt2450VoltageRange);
begin
//:SOUR:VOLT:RANG  <value>
//:SOUR:VOLT:RANG:AUTO ON
if Range=kt_vrAuto then
       begin
        OnOffFromBool(True);
        SetupOperation(11,13,16);
       end         else
       begin
         fAdditionalString:=floattostr(2e-2*Power(10,ord(Range)-1));
         SetupOperation(11,13,15);
       end;
fSourceVoltageRange:=Range;
end;

procedure TKt_2450.SetTerminal(Terminal: TKt2450_OutputTerminals);
begin
// :ROUT:TERM  FRON|REAR
 fAdditionalString:=Kt2450_TerminalsName[Terminal];
 SetupOperation(9,6);
 fTerminal:=Terminal;
end;

procedure TKt_2450.UnloadSetupPowerOn;
begin
//SYST:POS RST
  fAdditionalString:=DeleteSubstring(RootNoodKt_2450[2],'*');
  SetupOperation(7,4);
end;


function TKt_2450.ValueToCurrentRange(Value: double): TKt2450CurrentRange;
begin
 Result:=TKt2450CurrentRange(round(Log10(fDevice.Value/1e-8))+1);
end;

function TKt_2450.ValueToVoltageRange(Value: double): TKt2450VoltageRange;
begin
 Result:=TKt2450VoltageRange(round(Log10(fDevice.Value/2e-2))+1);
end;

procedure TKt_2450.SetVoltageLimit(Value: double);
begin
// :SOUR:CURR:VLIM <value>
 if Value=0 then
     begin
      fAdditionalString:=SuffixKt_2450[3];
      fVoltageLimit:=Kt_2450_VoltageLimDef;
     end
           else
     begin
      fAdditionalString:=FloatToStrLimited(Value,Kt_2450_VoltageLimLimits);
      fVoltageLimit:=strtofloat(fAdditionalString);
     end;
 SetupOperation(11,12,12);
end;

procedure TKt_2450.SetVoltageProtection(Level: TKt_2450_VoltageProtection);
begin
// :SOUR:VOLT:PROT <n>
 if Level in [kt_vp2..kt_vp180] then
   fAdditionalString:=DeleteSubstring(FirstNodeKt_2450[10])
//   SuffixKt_2450[3]
                     +Copy(Kt_2450_VoltageProtectionLabel[Level],1,
                           Length(Kt_2450_VoltageProtectionLabel[Level])-1)
                                else
   fAdditionalString:=Kt_2450_VoltageProtectionLabel[Level];
 fVoltageProtection:=Level;
 SetupOperation(11,13,10);
end;

function TKt_2450.StringToMeasureFunction(Str: string): boolean;
  var i:TKt2450_Measure;
begin
 Result:=False;
 for I := Low(TKt2450_Measure) to kt_mResistance do
   if pos(DeleteSubstring(RootNoodKt_2450[ord(i)+12]),Str)<>0 then
     begin
       fMeasureFunction:=i;
       Result:=True;
       Break;
     end;
end;

function TKt_2450.StringToMeasureUnit(Str: string): boolean;
  var i:TKt_2450_MeasureUnit;
begin
 Result:=False;
 for I := Low(TKt_2450_MeasureUnit) to High(TKt_2450_MeasureUnit) do
  begin
//   showmessage('StringToMeasureUnit '+Str+' '+SuffixKt_2450[ord(i)+4]);
//   showmessage(inttostr(fFirstLevelNode));
   if Str=SuffixKt_2450[ord(i)+4] then
     begin
       fMeasureUnits[TKt2450_Measure(fRootNode-12)]:=i;
       Result:=True;
       Break;
     end;
  end;
end;

function TKt_2450.StringToOutPutState(Str: string): boolean;
  var i:TKt_2450_OutputOffState;
begin
 Result:=False;
 for I := Low(TKt_2450_OutputOffState) to High(TKt_2450_OutputOffState) do
   begin
//   showmessage('StringToOutPutState  '+Str+' '+Kt_2450_OutputOffStateName[i]);
//   showmessage('source '+inttostr(1-fFirstLevelNode));
   if Str=Kt_2450_OutputOffStateName[i] then
     begin
       fOutputOffState[TKt2450_Source(1-fFirstLevelNode)]:=i;
       Result:=True;
//       showmessage('source type'+inttostr(ord(i)));
       Break;
     end;
   end;
// showmessage('curr '+inttostr(ord(fOutputOffState[kt_sCurr])));
end;

function TKt_2450.StringToSourceType(Str: string): boolean;
  var i:TKt2450_Source;
begin
 Result:=False;
 for I := Low(TKt2450_Source) to (High(TKt2450_Source)) do
   if Str=Kt2450_SourceName[i] then
     begin
       fSourceType:=i;
       Result:=True;
       Break;
     end;
end;

function TKt_2450.StringToTerminals(Str: string): boolean;
  var i:TKt2450_OutputTerminals;
begin
 Result:=False;
 for I := Low(TKt2450_OutputTerminals) to High(TKt2450_OutputTerminals) do
   if Str=Kt2450_TerminalsName[i] then
     begin
       fTerminal:=i;
       Result:=True;
       Break;
     end;
end;

function TKt_2450.StringToVoltageProtection(Str: string;
    var vp: TKt_2450_VoltageProtection): boolean;
  var i:TKt_2450_VoltageProtection;
begin
 Result:=False;
 Str:=DeleteSubstring(Str,DeleteSubstring(FirstNodeKt_2450[10]));
 if pos(Str,Kt_2450_VoltageProtectionLabel[kt_vpnone])=0 then
     Str:=Str+'V';
 for I := Low(TKt_2450_VoltageProtection) to (High(TKt_2450_VoltageProtection)) do
   if Str=Kt_2450_VoltageProtectionLabel[i] then
     begin
       vp:=i;
       Result:=True;
       Break;
     end;
end;

function TKt_2450.Test: boolean;
begin
// *IDN?
 QuireOperation(0,0,0,False);
 Result:=(fDevice.Value=314);
end;

procedure TKt_2450.TextToUserScreen(top_text, bottom_text: string);
begin
//DISP:SCR SWIPE_USER
//DISP:USER1:TEXT "top_text"
//DISP:USER2:TEXT "Tbottom_text"
 fAdditionalString:='SWIPE_USER';
 SetupOperation(6,0);
 if top_text<>'' then
   begin
     if Length(top_text)>20 then SetLength(top_text,20);
     fAdditionalString:=StringToInvertedCommas(top_text);
     SetupOperation(6,1);
   end;
 if bottom_text<>'' then
   begin
     if Length(bottom_text)>32 then SetLength(bottom_text,32);
     fAdditionalString:=StringToInvertedCommas(bottom_text);
     SetupOperation(6,2);
   end;
end;

{ TKt_2450Device }

constructor TKt_2450Device.Create(SCPInew:TSCPInew;Telnet: TIdTelnet;
  IPAdressShow: TIPAdressShow; Nm: string);
begin
 inherited Create(Telnet,IPAdressShow,Nm);
 fSCPI:=SCPInew;
 fMinDelayTime:=0;
 fDelayTimeStep:=10;
 fDelayTimeMax:=200;
end;

procedure TKt_2450Device.UpDate;
begin
 fSCPI.ProcessingString(fDataSubject.ReceivedString);
 fIsReceived:=True;
 if TestShowEthernet then showmessage('recived:  '+fDataSubject.ReceivedString);
end;

end.
