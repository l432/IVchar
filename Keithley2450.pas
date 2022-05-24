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


// TKt_2450=class(TTelnetMeterDeviceSingle)
 TKt_2450=class(TSCPInew)
  private
   fTelnet:TIdTelnet;
   fIPAdressShow: TIPAdressShow;
//   fRootNode:byte;
//   fFirstLevelNode:byte;
//   fLeafNode:byte;
//   fIsSuffix:boolean;
//   fIsQuery:boolean;
//   fAdditionalString:string;
   fIsTripped:boolean;

   fTerminal:TKt2450_OutputTerminals;
   fOutPutOn:boolean;
   fResistanceCompencateOn:boolean;
   fSences:TKt2450_Senses;
   fOutputOffState:TKt_2450_OutputOffStates;
   fSourceType:TKt2450_Source;
   fMeasureFunction:TKt2450_Measure;
   fVoltageProtection:TKt_2450_VoltageProtection;
   fVoltageLimit:double;
   fCurrentLimit:double;
//   procedure QuireOperation(RootNode:byte;FirstLevelNode:byte=0;LeafNode:byte=0;
//                            isSyffix:boolean=True;isQuery:boolean=False);
//   procedure SetupOperation(RootNode:byte;FirstLevelNode:byte=0;LeafNode:byte=0;
//                            isSyffix:boolean=True;isQuery:boolean=False);
//   procedure SetFlags(RootNode,FirstLevelNode,LeafNode:byte;
//                  IsSuffix:boolean=True;isQuery:boolean=False);
//   procedure JoinAddString();
//   function StringToInvertedCommas(str:string):string;
   procedure OnOffFromBool(toOn:boolean);
   function StringToVoltageProtection(Str:string;var vp:TKt_2450_VoltageProtection):boolean;
   function StringToSourceType(Str:string):boolean;
   function StringToMeasureFunction(Str:string):boolean;
   function StringToTerminals(Str:string):boolean;
   function StringToOutPutState(Str:string):boolean;
   function IsLimitExcided(FirstLevelNode,LeafNode:byte):boolean;
   {типова функція для запиту, чи ввімкнув прилад певні захисти}
  protected
   procedure PrepareString;override;
//   procedure UpDate();override;
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
   property ResistanceCompencateOn:boolean read fResistanceCompencateOn;
   property Sences:TKt2450_Senses read fSences;
   property OutputOffState:TKt_2450_OutputOffStates read fOutputOffState;
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
   {прилад як джерело напруги чи струму}
   function GetSourceType():boolean;

   procedure SetMeasureFunction(MeasureFunction:TKt2450_Measure=kt_mCurrent);
   {прилад як джерело напруги чи струму}
   function GetMeasureFunction():boolean;

   Procedure GetParametersFromDevice;
 end;

//Function DeleteSubstring(Source,Substring: string):string;

//Function FloatToStrLimited(Value:double;LimitValues:TLimitValues):string;

var
  Kt_2450:TKt_2450;

implementation

uses
  Dialogs, SysUtils, OlegType;

{ TKt_2450 }

procedure TKt_2450.ClearUserScreen;
begin
// :DISP:CLE
 SetupOperation(6,3,0,false);
end;

constructor TKt_2450.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
// inherited Create(Telnet,IPAdressShow,Nm);
// fMinDelayTime:=0;
// fDelayTimeStep:=10;
// fDelayTimeMax:=200;
//// RepeatInErrorCase:=True;
// DefaultSettings();
// SetFlags(0,0,0);
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
 fResistanceCompencateOn:=False;
 for I := ord(Low(TKt2450_Measure)) to ord(High(TKt2450_Measure)) do
   fSences[TKt2450_Measure(i)]:=kt_s2wire;
 for I := ord(Low(TKt2450_Source)) to ord(High(TKt2450_Source)) do
   fOutputOffState[TKt2450_Source(i)]:=kt_oos_norm;


end;

procedure TKt_2450.DeviceCreate(Nm: string);
begin
 fDevice:=TKt_2450Device.Create(Self,fTelnet,fIPAdressShow,Nm);
end;

function TKt_2450.GetCurrentLimit: boolean;
begin
 QuireOperation(11,13,13);
// QuireOperation(11,1,3);
 Result:=(fDevice.Value<>ErResult);
 if Result then fCurrentLimit:=fDevice.Value;
end;

function TKt_2450.IsInterlockOn: boolean;
begin
//:OUTP:INT:STAT?
// QuireOperation(5,1,0,True);
// QuireOperation(5,1);
 QuireOperation(5,5);
// Result:=(Value=1);
 Result:=(fDevice.Value=1);
end;

function TKt_2450.GetMeasureFunction: boolean;
begin
 QuireOperation(10,11,2);
 Result:=(fDevice.Value<>ErResult);
end;

function TKt_2450.GetOutputOffState(Source: TKt2450_Source): boolean;
begin
 QuireOperation(5,1-ord(Source),8);
 Result:=(fDevice.Value<>ErResult);
 fOutputOffState[Source]:=TKt_2450_OutputOffState(round(fDevice.Value));
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
 GetVoltageProtection();
 GetVoltageLimit();
 GetCurrentLimit();
 GetSourceType();
 GetMeasureFunction();
 IsResistanceCompencateOn();//має бути після GetMeasureFunction

 GetTerminal();
 IsOutPutOn();
 GetSenses();
 GetOutputOffStates();
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

function TKt_2450.GetSourceType: boolean;
begin
 QuireOperation(11,11,2);
 Result:=(fDevice.Value<>ErResult);
end;

function TKt_2450.GetTerminal: boolean;
begin
 QuireOperation(9,6);
 Result:=(fDevice.Value<>ErResult);
// if Result then fTerminal:=TKt2450_OutputTerminals(fDevice.Value);
end;

function TKt_2450.GetVoltageLimit: boolean;
begin
 QuireOperation(11,12,12);
// QuireOperation(11,0,2);
 Result:=(fDevice.Value<>ErResult);
 if Result then fVoltageLimit:=fDevice.Value;
end;

function TKt_2450.GetVoltageProtection: boolean;
begin
 QuireOperation(11,13,10);
// QuireOperation(11,1,0,True);
// Result:=(Value<>ErResult);
 Result:=(fDevice.Value<>ErResult);
end;

function TKt_2450.IsCurrentLimitExceeded: boolean;
begin
 Result:=IsLimitExcided(13,13);
// fIsTripped:=True;
// QuireOperation(11,1,3);
// Result:=(fDevice.Value<>1);
// fIsTripped:=False;
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
 QuireOperation(5);
// Result:=(Value=1);
 Result:=(fDevice.Value=1);
 fOutPutOn:=Result;
end;

function TKt_2450.IsResistanceCompencateOn: boolean;
begin
 case fMeasureFunction of
   kt_mCurrent: QuireOperation(12,9);
   kt_mVoltage: QuireOperation(13,9);
 end;
 Result:=(fDevice.Value=1);
 fResistanceCompencateOn:=Result;
end;

function TKt_2450.IsVoltageLimitExceeded: boolean;
begin
 Result:=IsLimitExcided(12,12);
// fIsTripped:=True;
// QuireOperation(11,0,2);
// Result:=(fDevice.Value<>1);
// fIsTripped:=False;
end;

function TKt_2450.IsVoltageProtectionActive: boolean;
begin
 Result:=IsLimitExcided(13,10);
// fIsTripped:=True;
// QuireOperation(11,1,0);
// Result:=(fDevice.Value<>1);
// fIsTripped:=False;
end;

//procedure TKt_2450.JoinAddString;
//begin
// if fIsQuery then Self.JoinToStringToSend(SuffixKt_2450[3])
//             else Self.JoinToStringToSend(' '+fAdditionalString);
//end;


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
//  SetupOperation(7,0);
  SetupOperation(7,4);
end;

procedure TKt_2450.MyTraining;
// var str:string;
begin
//  (fDevice as TTelnetMeterDeviceSingle).SetStringToSend(':res:OCOM OFF');
//  fDevice.Request();
//  fDevice.GetData;



//SetSourceType();
//SetSourceType(kt_sCurr);
//GetSourceType();
//SetMeasureFunction();
//SetMeasureFunction(kt_mResistance);
//GetMeasureFunction();
//                    SetVoltageLimit();


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
// if toOn then fAdditionalString:=SuffixKt_2450[0]
//         else fAdditionalString:=SuffixKt_2450[1];
// SetupOperation(5,0);
 SetupOperation(5);
 fOutPutOn:=toOn;
end;

procedure TKt_2450.PrepareString;
begin
// Self.ClearStringToSend;
// Self.SetStringToSend(RootNoodKt_2450[fRootNode]);
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
//     JoinToStringToSend(FirstNodeKt_2450_6[fFirstLevelNode]);
//     fDevice.JoinToStringToSend(FirstNodeKt_2450_6[fFirstLevelNode]);
//      SetupOperation(6,3,0,false);
//        SetupOperation(6,0);
//        SetupOperation(6,1);
//        SetupOperation(6,2);
     fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
    end;
   7:begin
//        SetupOperation(7,0);
//      fDevice.JoinToStringToSend(FirstNodeKt_2450_7[fFirstLevelNode]);
//        SetupOperation(7,4);
      fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
     end;
//   8:begin
//      fDevice.JoinToStringToSend(FirstNodeKt_2450_8[fFirstLevelNode]);
//     end;
   9:begin
//      fDevice.JoinToStringToSend(FirstNodeKt_2450_9[fFirstLevelNode]);
//      SetupOperation(9,6);
      fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);

     end;
   10:begin
      case fFirstLevelNode of
//         SetupOperation(10,11,2);
        11:fDevice.JoinToStringToSend(FirstNodeKt_2450_10_3[fLeafNode]);
        0..3:
          begin
//      SetupOperation(10,ord(MeasureType),0);
          fDevice.JoinToStringToSend(Kt2450_MeasureName[TKt2450_Measure(fFirstLevelNode)]);
          fDevice.JoinToStringToSend(FirstNodeKt_2450_10_3[fLeafNode]);
          end;
      end;
     end;
   11:begin
      case fFirstLevelNode of
       12..13:begin
//    SetupOperation(11,13,10)замість SetupOperation(11,1,0);
//    SetupOperation(11,12,12)замість SetupOperation(11,0,2);
//    SetupOperation(11,13,13);
           fDevice.JoinToStringToSend(RootNoodKt_2450[fFirstLevelNode]);
           fDevice.JoinToStringToSend(FirstNodeKt_2450[fLeafNode]);
           if fIsTripped then fDevice.JoinToStringToSend(FirstNodeKt_2450[11]);
          end;
//       SetupOperation(11,11,2);
       11:fDevice.JoinToStringToSend(FirstNodeKt_2450_10_3[fLeafNode]);
      end;
      end;
     12..14:
       begin
//          SetupOperation(12+ord(MeasureType),7);
            fDevice.JoinToStringToSend(FirstNodeKt_2450[fFirstLevelNode]);
       end;

     end;

 if fIsSuffix then JoinAddString;

end;

procedure TKt_2450.ProcessingString(Str: string);
begin
 Str:=Trim(Str);
// Str := AnsiLowerCase(Str);
 case fRootNode of
//  0:if pos(AnsiLowerCase(Kt_2450_Test),Str)<>0 then fValue:=314;
  0:if pos(Kt_2450_Test,Str)<>0 then fDevice.Value:=314;
  5:begin
    case fFirstLevelNode of
     5:fDevice.Value:=StrToInt(Str);
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
          then fDevice.Value:=ord(fVoltageProtection);
    end;
  10:begin
//      QuireOperation(10,11,2);
      if StringToMeasureFunction(AnsiLowerCase(Str)) then fDevice.Value:=ord(fTerminal);
     end;
  11:begin
//      QuireOperation(11,13,10);

// QuireOperation(11,12,12);
     case fLeafNode of
      10:if StringToVoltageProtection(AnsiLowerCase(Str),fVoltageProtection)
          then fDevice.Value:=ord(fVoltageProtection);
      12..13:fDevice.Value:=SCPI_StringToValue(Str);
//      2..3:fDevice.Value:=SCPI_StringToValue(Str);
//         QuireOperation(11,11,2);
      11:if StringToSourceType(AnsiLowerCase(Str)) then fDevice.Value:=ord(fSourceType);
     end;
     end;
   12..14:begin
//          QuireOperation(12+ord(MeasureType),7);
//          QuireOperation(12|13,9);
          fDevice.Value:=StrToInt(Str);
         end;
 end;
// fIsReceived:=True;
// if TestShowEthernet then showmessage('recived:  '+STR);
end;

//procedure TKt_2450.QuireOperation(RootNode, FirstLevelNode, LeafNode: byte;
//                                 isSyffix:boolean;isQuery:boolean);
//begin
// SetFlags(RootNode, FirstLevelNode, LeafNode,isSyffix,isQuery);
// PrepareString();
// GetData;
//end;

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
      fAdditionalString:=SuffixKt_2450[4];
      fCurrentLimit:=Kt_2450_CurrentLimDef;
     end
           else
     begin
      fAdditionalString:=FloatToStrLimited(Value,Kt_2450_CurrentLimLimits);
      fCurrentLimit:=strtofloat(fAdditionalString);
     end;
// SetupOperation(11,1,3);
 SetupOperation(11,13,13);
end;

//procedure TKt_2450.SetFlags(RootNode, FirstLevelNode, LeafNode: byte;
//                  IsSuffix:boolean; isQuery:boolean);
//begin
// fRootNode:=RootNode;
// fFirstLevelNode:=FirstLevelNode;
// fLeafNode:=LeafNode;
// fIsSuffix:=IsSuffix;
// fIsQuery:=isQuery;
//end;

procedure TKt_2450.SetInterlockStatus(toOn: boolean);
begin
// :OUTP:INT:STAT on|off
 OnOffFromBool(toOn);
// SetupOperation(5,1);
 SetupOperation(5,5);
end;

procedure TKt_2450.SetMeasureFunction(MeasureFunction: TKt2450_Measure);
begin
// if MeasureFunction=kt_mPower then Exit;
// fAdditionalString:=Kt2450_MeasureName[MeasureFunction];
 fAdditionalString:=StringToInvertedCommas(DeleteSubstring(Kt2450_MeasureName[MeasureFunction],':'));
 SetupOperation(10,11,2);
 fMeasureFunction:=MeasureFunction;
end;

procedure TKt_2450.SetOutputOffState(Source:TKt2450_Source;
                           OutputOffState:TKt_2450_OutputOffState);
begin
//:OUTP:CURR|VOLT:SMOD  NORM|HIMP|ZERO|GUARd
 fAdditionalString:=Kt_2450_OutputOffStateName[OutputOffState];
// SetupOperation(5,2);
 SetupOperation(5,1-ord(Source),8);
 fOutputOffState[Source]:=OutputOffState;
end;

procedure TKt_2450.SetResistanceCompencate(toOn: boolean);
begin
// RES:OCOM ON|OFF
 OnOffFromBool(toOn);
// SetupOperation(10,ord(kt_mResistance),1);
 case fMeasureFunction of
   kt_mCurrent: SetupOperation(12,9);
   kt_mVoltage: SetupOperation(13,9);
 end;
 fResistanceCompencateOn:=toOn;
end;

procedure TKt_2450.SetSense(MeasureType: TKt2450_Measure; Sense: TKt2450_Sense);
begin
// :CURR|VOLT|RES:RSEN ON(1)|OFF(0)
 fAdditionalString:=SuffixKt_2450[ord(Sense)];
// SetupOperation(10,ord(MeasureType),0);
 SetupOperation(12+ord(MeasureType),7);
 fSences[MeasureType]:=Sense;
end;

procedure TKt_2450.SetSourceType(SourseType: TKt2450_Source);
begin
 fAdditionalString:=Kt2450_SourceName[SourseType];
 SetupOperation(11,11,2);
 fSourceType:=SourseType;
end;

procedure TKt_2450.SetTerminal(Terminal: TKt2450_OutputTerminals);
begin
// :ROUT:TERM  FRON|REAR
 fAdditionalString:=Kt2450_TerminalsName[Terminal];
// SetupOperation(9,0);
 SetupOperation(9,6);
 fTerminal:=Terminal;
end;

procedure TKt_2450.UnloadSetupPowerOn;
begin
//SYST:POS RST
//  fAdditionalString:=SuffixKt_2450[2];
//  SetupOperation(7,0);
  fAdditionalString:=DeleteSubstring(RootNoodKt_2450[2],'*');
  SetupOperation(7,4);
end;

//procedure TKt_2450.SetupOperation(RootNode, FirstLevelNode, LeafNode: byte;
//                                 isSyffix:boolean;isQuery:boolean);
//begin
// SetFlags(RootNode, FirstLevelNode, LeafNode,isSyffix,isQuery);
// PrepareString();
// Request();
//end;

procedure TKt_2450.SetVoltageLimit(Value: double);
begin
// :SOUR:CURR:VLIM <value>
 if Value=0 then
     begin
//      fAdditionalString:=SuffixKt_2450[5];
      fAdditionalString:=SuffixKt_2450[4];
      fVoltageLimit:=Kt_2450_VoltageLimDef;
     end
           else
     begin
      fAdditionalString:=FloatToStrLimited(Value,Kt_2450_VoltageLimLimits);
      fVoltageLimit:=strtofloat(fAdditionalString);
     end;
// SetupOperation(11,0,2);
 SetupOperation(11,12,12);
end;

procedure TKt_2450.SetVoltageProtection(Level: TKt_2450_VoltageProtection);
begin
// :SOUR:VOLT:PROT <n>
 if Level in [kt_vp2..kt_vp180] then
//   fAdditionalString:=SuffixKt_2450[4]
   fAdditionalString:=SuffixKt_2450[3]
                     +Copy(Kt_2450_VoltageProtectionLabel[Level],1,
                           Length(Kt_2450_VoltageProtectionLabel[Level])-1)
                                else
   fAdditionalString:=Kt_2450_VoltageProtectionLabel[Level];
 fVoltageProtection:=Level;
// SetupOperation(11,1,0);
 SetupOperation(11,13,10);
end;

//function TKt_2450.StringToInvertedCommas(str: string): string;
//begin
// Result:='"'+str+'"';
//end;

function TKt_2450.StringToMeasureFunction(Str: string): boolean;
  var i:TKt2450_Measure;
begin
 Result:=False;
 for I := Low(TKt2450_Measure) to kt_mResistance do
   if Str=DeleteSubstring(Kt2450_MeasureName[i],':') then
     begin
       fMeasureFunction:=i;
       Result:=True;
       Break;
     end;
end;

function TKt_2450.StringToOutPutState(Str: string): boolean;
  var i:TKt_2450_OutputOffState;
begin
 Result:=False;
 for I := Low(TKt_2450_OutputOffState) to High(TKt_2450_OutputOffState) do
   if Str=Kt_2450_OutputOffStateName[i] then
     begin
       fOutputOffState[TKt2450_Source(fFirstLevelNode)]:=i;
       Result:=True;
       Break;
     end;
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
// DeleteSubstring(Str,SuffixKt_2450[4]);
 Str:=DeleteSubstring(Str,SuffixKt_2450[3]);
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
// Result:=(Value=314);
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

//procedure TKt_2450.UpDate;
// var STR:string;
//begin
// Str:=Trim(fDataSubject.ReceivedString);
// Str := AnsiLowerCase(Str);
// case fRootNode of
//  0:if pos(AnsiLowerCase(Kt_2450_Test),Str)<>0 then fValue:=314;
//  5:begin
//    fValue:=StrToInt(Str);
//    end;
//  11:begin
////   QuireOperation(11,1,0,True,True);
//     if StringToVoltageProtection(Str,fVoltageProtection)
//          then fValue:=ord(fVoltageProtection);
//     end;
// end;
// fIsReceived:=True;
// if TestShowEthernet then showmessage('recived:  '+STR);
//end;

//{ TKt_2450_Show }
//
//procedure TKt_2450_Show.ButtonsTune(Buttons: array of TButton);
//const
//  ButtonCaption: array[0..ButtonNumberKt_2450] of string =
//  ('Connection Test ?','Reset','MyTrain');
//var
//  ButtonAction: array[0..ButtonNumberKt_2450] of TNotifyEvent;
//  i: Integer;
//begin
//  ButtonAction[0] := TestButtonClick;
//  ButtonAction[1] := ResetButtonClick;
////  ButtonAction[3] := SaveButtonClick;
////  ButtonAction[4] := LoadButtonClick;
////  ButtonAction[5] := AutoButtonClick;
////  ButtonAction[6] := DefaultButtonClick;
////  ButtonAction[7] := RefreshButtonClick;
////  ButtonAction[8] := RunButtonClick;
////  ButtonAction[9] := StopButtonClick;
////  ButtonAction[10] := UnlockButtonClick;
//   ButtonAction[ButtonNumberKt_2450] := MyTrainButtonClick;
//  for I := 0 to ButtonNumberKt_2450 do
//  begin
//    Buttons[i].Caption := ButtonCaption[i];
//    Buttons[i].OnClick := ButtonAction[i];
//  end;
//  BTest := Buttons[0];
//
//end;
//
//constructor TKt_2450_Show.Create(Kt_2450: TKt_2450;
//                                Buttons:Array of TButton;
//                                OutPutOnOff:TSpeedButton
//                                );
//begin
//  if (High(Buttons)<>ButtonNumberKt_2450)
//   then
//    begin
//      showmessage('Kt_2450_Show is not created!');
//      Exit;
//    end;
//  fKt_2450:=Kt_2450;
//  ButtonsTune(Buttons);
//
//  fOutPutOnOff:=OutPutOnOff;
//  fOutPutOnOff.OnClick:=OutPutOnOffSpeedButtonClick;
//  fOutPutOnOff.Caption:='Output';
//end;
//
//procedure TKt_2450_Show.MyTrainButtonClick(Sender: TObject);
//begin
// fKt_2450.MyTraining();
//end;
//
//procedure TKt_2450_Show.OutPutOnOffSpeedButtonClick(Sender: TObject);
//begin
// fKt_2450.OutPutChange(fOutPutOnOff.Down);
//end;
//
//procedure TKt_2450_Show.ResetButtonClick(Sender: TObject);
//begin
// fKt_2450.ResetSetting();
//end;
//
//procedure TKt_2450_Show.TestButtonClick(Sender: TObject);
//begin
//   if fKt_2450.Test then
//        begin
//          BTest.Caption:='Connection Test - Ok';
//          BTest.Font.Color:=clBlue;
//        end        else
//        begin
//          BTest.Caption:='Connection Test - Failed';
//          BTest.Font.Color:=clRed;
//        end;
//end;

//Function DeleteSubstring(Source,Substring: string):string;
//begin
// Result:=Source;
// if pos(Substring,Source)<>0 then
//     Delete(Result,pos(Substring,Source),Length(Substring));
//end;

//Function FloatToStrLimited(Value:double;LimitValues:TLimitValues):string;
//begin
//  Value:=min(Value,LimitValues[lvMax]);
//  Value:=max(Value,LimitValues[lvMin]);
//  Result:=FloatToStrF(Value,ffExponent,8,0);
//end;

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
