unit AD5752R;
//
interface

uses
  ShowTypes, ExtCtrls, Measurement, StdCtrls, IniFiles, ArduinoDeviceNew, 
  OlegType, Classes;
//
//uses
//  ArduinoDevice, IniFiles, StdCtrls, Buttons, ExtCtrls;
//
type
  T5752OutputRange=(p050,p100,p108,pm050,pm100,pm108,NA);
  T5752ChanNumber=(chA,chB);

const
  AD5752_OutputRangeLabels:array[T5752OutputRange]of string=
  ('0..5','0..10','0..10.8',
  '-5..5','-10..10','-10.8..10.8','Error');

  AD5752_ChanelNames:array[T5752ChanNumber]of string=
  ('AD5752chA','AD5753chB');

  AD5752_OutputRangeKodLabels:array[0..1] of string=
  ('0..65535','32768..65535,0..32767');

  AD5752_OutputRangeKod:array[T5752OutputRange] of byte=
  (0,1,2,3,4,5,6);

  AD5752_OutputRangeMaxVoltage:array[T5752OutputRange]of double=
  (5,10,10.8,5,10,10.8,ErResult);

  AD5752_OutputRangeMinVoltage:array[T5752OutputRange]of double=
  (0,0,0,-5,-10,-10.8,ErResult);

  AD5752_GainOutputRange:array[T5752OutputRange]of double=
  (2,4,4.32,4,8,8.64,1);



  AD5752_REFIN=2.5;
  AD5752_MaxKod=65535;

  {можливий відсоток напруги на виході від номінального діапазону}
//  AD5752_pVoltageLimit=0.99998; // 65535/65536
//  AD5752_pmVoltageLimit=0.99996; // 32767/32768




//  {константи операцій з ЦАП}
//  DAC_OR=1; //встановлення діапазону
//  DAC_Mode=2; //встановлення параметрів роботи
//  DAC_Power=3;//подача живлення
//  DAC_Reset=4;//встановлення нульової напруги на обох каналах
//  DAC_Output=5; //встановлення напруги
//  DAC_OutputSYN=6; //встановлення напруги одночасно на обох каналах
//  DAC_Overcurrent=7; // перевантаження на виході
//
//
type

 TAD5752_Chanel=class(TArduinoDACbase)
  private
   fChanNumber:T5752ChanNumber;
   fDiapazon:T5752OutputRange;
   fSettedDiapazon:T5752OutputRange;
   fGain:double;
   fPowerOn:boolean;
   fDacByte:byte;
   fRangeByte:byte;
   fPowerOnByte:byte;
   fPowerOffByte:byte;
//   fVoltageMinValue:double;
   procedure SetDiapazon(D:T5752OutputRange);
  protected
   procedure CreateHook;override;
   procedure PinsCreate();override;
   function NormedVoltage(Voltage:double):double;override;
   function  VoltageToKod(Voltage:double):integer;override;
   procedure PrepareAction(Voltage:double);override;
   procedure DataToSendFromKod(Kod:Integer);override;
   procedure DataToSendFromReset;override;
  public
   property Diapazon:T5752OutputRange read fDiapazon write SetDiapazon;
   property Power:boolean read fPowerOn;
   Constructor Create(ChanNumber:T5752ChanNumber);
   procedure PowerOff();
   procedure PowerOn();
   destructor Destroy; override;
//   procedure PinsToDataArray;override;
 end;

 TAD5752_ChanelShow=class(TArduinoDACShow)
   private
    fDiapazonRG:TRadioGroup;
    fValueDiapazonLabel:TLabel;
    fKodDiapazonLabel:TLabel;
    fPowerOff:TButton;
    procedure DiapazonChange(Sender: TObject);
    procedure PowerOffOn(Sender: TObject);
   protected
    procedure CreatePinShow(PinLs: array of TPanel;
                             PinVariant:TStringList);override;
   public
     Constructor Create(AD5752_Chanel:TAD5752_Chanel;
                         CPL:TPanel;
                         VData,KData:TStaticText;
                         VL,KL,VDL,KDL:TLabel;
                         VSB,KSB,RB,OffB:TButton;
                         PinVariant:TStringList;
                         DiapRG:TRadioGroup);
    Procedure HookReadFromIniFile(ConfigFile:TIniFile);override;
    Procedure WriteToIniFile(ConfigFile:TIniFile);override;
 end;


 //
//  TDACChannel=class
//   Range:TOutputRange;
//   Power:boolean;
//   Overcurrent:boolean;
//  end;
//
//  TChannelType=(A,B,Both,Error);
//
////  TSimpleEvent = procedure() of object;
//
//  TDAC=class(TArduinoDevice)
//  {базовий клас для ЦАП}
//  private
//    FChannelB: TDACChannel;
//    FChannelA: TDACChannel;
//    FBeginingIsDone: boolean;
//    fHookForGraphElementApdate:TSimpleEvent;
//    procedure SetChannelA(const Value: TDACChannel);
//    procedure SetChannelB(const Value: TDACChannel);
//    Procedure OutputRange(Channel: Byte; Range: TOutputRange; NotImperative: Boolean=True);
//    {якщо NotImperative=True, то встановлення вихідного діапазону не буде
//    відбуватися, якщо вже існуючий співпадає з тим, що намагаються встановити;
//    в протилежному випадку завжди буде відсилатися відповідний пакет -
//    потрібно, наприклад при початку роботи}
//    Procedure PowerOn(Channel: Byte; NotImperative: Boolean=True);
//    Procedure Output(Voltage:double;Channel: Byte);
//    Function ChannelTypeDetermine(Channel:byte):TChannelType;
//    procedure ChannelSetRange(Channel:byte;Range:TOutputRange);overload;
//    procedure ChannelSetRange(Channel:byte;Range:byte);overload;
//    procedure ChannelSetPower(ChannelType:TChannelType);
//    function ChannelRangeIsReady(Channel:byte;Range:TOutputRange):boolean;
//    {False якщо Range не співпадає з тим, що вже встановлено}
//    function ChannelPowerIsReady(ChannelType:TChannelType):boolean;
//    function IntVoltage(Voltage:double;Range:TOutputRange):integer;
//    function HighVoltage(Range:TOutputRange):double;
//    function LowVoltage(Range:TOutputRange):double;
//  protected
//    Procedure PacketReceiving(Sender: TObject; const Str: string);override;
//  public
//   {пін для оновлення напруги ЦАП}
////       function IntVoltage(Voltage:double;Range:TOutputRange):integer;
//   property PinLDAC:byte Index 2 read GetPin write SetPin;
//   property PinLDACStr:string Index 2 read GetPinStr;
//   {пін для встановлення нульової напруги ЦАП}
//   property PinCLR:byte Index 3 read GetPin write SetPin;
//   property PinCLRStr:string Index 3 read GetPinStr;
//   property ChannelA:TDACChannel read FChannelA write SetChannelA;
//   property ChannelB:TDACChannel read FChannelB write SetChannelB;
//   property BeginingIsDone:boolean read FBeginingIsDone;
//   property HookForGraphElementApdate:TSimpleEvent
//             read fHookForGraphElementApdate write fHookForGraphElementApdate;
//   {виконується в кінці PacketReceiving для оновлення
//   даних графічних елементів, пов'язаних з DAC.
//   В цьому класі порожня, треба причепити
//   за необхідності якусь дію десь інде}
//   Constructor Create();overload;override;
//   Procedure Free;
//   Procedure OutputRangeA(Range:TOutputRange; NotImperative: Boolean=True);
//   Procedure OutputRangeB(Range:TOutputRange; NotImperative: Boolean=True);
//   Procedure OutputRangeBoth(Range:TOutputRange; NotImperative: Boolean=True);
//   Procedure ChannelsReadFromIniFile(ConfigFile:TIniFile);
//   Procedure ChannelsWriteToIniFile(ConfigFile:TIniFile);
//   Procedure PowerOnA(NotImperative: Boolean=True);
//   Procedure PowerOnB(NotImperative: Boolean=True);
//   Procedure PowerOnBoth(NotImperative: Boolean=True);
//   Procedure PowerOffBoth(NotImperative: Boolean=True);
//   Procedure PowerOffB();
//   Procedure PowerOffA();
////   Procedure HookForGraphElementApdate();
//   {виконується в кінці PacketReceiving для оновлення
//   даних графічних елементів, пов'язаних з DAC.
//   В цьому класі порожня, треба причепити
//   за необхідності якусь дію десь інде}
//   Procedure SetMode();
//   {встановлюється режим роботи:
//   SDO Disable=0, CLR Seting =0, Clamp Enable=1
//   TSD enable = 0 - див Datasheet}
//   Procedure Begining();
//   Procedure Reset();
//   Procedure OutputA(Voltage:double);
//   Procedure OutputB(Voltage:double);
//   Procedure OutputBoth(Voltage:double);
//   Procedure OutputSyn(VoltageA,VoltageB:double);
//   {встановлення напруги на обох вихідних каналах одночасно}
//  end;
//
//  TDACChannelShow=class
//  private
//   DAC:TDAC;
//   ChannelIndex:integer;// 8 - ChannelA, 10 - ChannelB
//   Channel:TDACChannel;
//   RangesLabel,ValueLabel:TLabel;
//   RangesComboBox:TComboBox;
//   RangesSetButton,ValueChangeButton,ValueSetButton:TButton;
//   PowerLabel:TLabel;
//   PowerButton:TBitBtn;
//   procedure SetRangeButtomAction(Sender:TObject);
//   procedure PowerButtomAction(Sender:TObject);
//   procedure ValueChangeButtonAction(Sender:TObject);
//   procedure ValueSetButtonAction(Sender:TObject);
////   function ReadyTesting:boolean;
//  public
//   Constructor Create(DACC:TDAC;
//               CI:integer;
//               RL,VL:TLabel;
//               RCB:TComboBox;
//               RSB,VCB,VSB:TButton;
//               PL:TLabel;
//               PB:TBitBtn
//                      );
//   procedure DataShow;
//   procedure RangeShow;
//   procedure PowerShow;
//  end;
//
//  TDACShow=class(TPinsShow)
//  private
//   DACChannelShowA,DACChannelShowB:TDACChannelShow;
//   PanelA,PanelB:TPanel;
//   InitButton,ResetButton:TButton;
//   procedure ButtonEnable();
//   procedure InitButtonClick(Sender:TObject);
//   procedure ResetButtonClick(Sender:TObject);
//  public
//   Constructor Create(DAC:TDAC;
//                      DACCSA,DACCSB:TDACChannelShow;
//                      CPL,GPL,LDACPL,CLRPL:TLabel;
//                      SCB,SGB,SLDACB,SCLRB:TButton;
//                      PCB:TComboBox;
//                      PanA,PanB:TPanel;
//                      IB,RB:TButton
//                      );
//   procedure NumberPinShow();override;
//   procedure DataShow();
//  end;
//
//

 var
    AD5752_chA,AD5752_chB:TAD5752_Chanel;
    AD5752_ChanShowA,AD5752_ChanShowB:TAD5752_ChanelShow;
implementation

uses
  PacketParameters, Math, Graphics, Windows, ArduinoDeviceShow, Dialogs, 
  SysUtils;
//
//uses
//  SysUtils, OlegType, PacketParameters, Dialogs, Graphics;
//
//procedure TDAC.ChannelSetRange(Channel: byte; Range: TOutputRange);
//begin
//  case ChannelTypeDetermine(Channel) of
//   A:ChannelA.Range:=Range;
//   B:ChannelB.Range:=Range;
//   Both:begin
//         ChannelA.Range:=Range;
//         ChannelB.Range:=Range;
//        end;
//   Error:;
//  end;
//end;
//
//
//
//procedure TDAC.ChannelSetPower(ChannelType: TChannelType);
//begin
// case ChannelType of
//   A: begin
//       ChannelA.Power:=True;
//       ChannelB.Power:=False;
//      end;
//   B: begin
//       ChannelA.Power:=False;
//       ChannelB.Power:=True;
//      end;
//   Both:begin
//       ChannelA.Power:=True;
//       ChannelB.Power:=True;
//       end;
//   Error: begin
//         ChannelA.Power:=False;
//         ChannelB.Power:=False;
//        end;
// end;
//end;
//
//procedure TDAC.ChannelSetRange(Channel, Range: byte);
//begin
// ChannelSetRange(Channel, TOutputRange(Range));
//end;
//
//procedure TDAC.Begining;
//begin
// if not(fComPort.Connected) then Exit;
// if (ChannelA.Range=ChannelB.Range) then
//          OutputRangeBoth(ChannelA.Range,False)
//                                    else
//          begin
//           OutputRangeA(ChannelA.Range,False);
//           sleep(100);
//           OutputRangeB(ChannelB.Range,False);
//          end;
// sleep(100);
// if ChannelA.Power then
//    begin
//      if ChannelB.Power then PowerOnBoth(False)
//                        else PowerOnA(False);
//    end
//                   else
//    begin
//      if ChannelB.Power then PowerOnB(False)
//                        else PowerOffBoth(False);
//    end;
// sleep(100);
// SetMode();
// sleep(100);
// FBeginingIsDone:=True;
//end;
//
//function TDAC.ChannelPowerIsReady(ChannelType: TChannelType): boolean;
//begin
// case ChannelType of
//   A:Result:=ChannelA.Power;
//   B:Result:=ChannelB.Power;
//   Both:Result:=(ChannelA.Power)and(ChannelB.Power);
//   Error:Result:=(not(ChannelA.Power))and(not(ChannelB.Power))
//   else Result:=False;
// end;
//end;
//
//function TDAC.ChannelRangeIsReady(Channel: byte; Range: TOutputRange): boolean;
//begin
//  case ChannelTypeDetermine(Channel) of
//   A:Result:=(ChannelA.Range=Range);
//   B:Result:=(ChannelB.Range=Range);
//   Both:Result:=((ChannelA.Range=Range)and(ChannelB.Range=Range));
//   else Result:=False;
//  end;
//end;
//
//function TDAC.ChannelTypeDetermine(Channel: byte): TChannelType;
//begin
// Channel:=(Channel and $07);
// case Channel of
//   0:Result:=A;
//   2:Result:=B;
//   4:Result:=Both;
//   else  Result:=Error;
// end;
//end;
//
//Constructor TDAC.Create();
//begin
//  inherited Create();
//  SetLength(fPins,4);
//  PinLDAC:=UndefinedPin;
//  PinCLR:=UndefinedPin;
//  ChannelA:=TDACChannel.Create;
//  ChannelB:=TDACChannel.Create;
//  ChannelA.Overcurrent:=False;
//  ChannelB.Overcurrent:=False;
////  ChannelA.Range:=pm100;
//  FBeginingIsDone:=False;
////  FBeginingIsDone:=True;
//
//end;
//
//
//procedure TDAC.Free;
//begin
// ChannelA.Free;
// ChannelB.Free;
// inherited Free;
//end;
//
//function TDAC.HighVoltage(Range: TOutputRange): double;
//begin
// case Range of
//   p050: Result:=5*pVoltageLimit;
//   p100: Result:=10*pVoltageLimit;
//   p108: Result:=10.8*pVoltageLimit;
//   pm050: Result:=5*pmVoltageLimit;
//   pm100: Result:=10*pmVoltageLimit;
//   pm108: Result:=10.8*pmVoltageLimit;
//   else Result:=ErResult;
// end;
//end;
//
////procedure TDAC.HookForGraphElementApdate;
////begin
////
////end;
//
//function TDAC.IntVoltage(Voltage: double; Range: TOutputRange): integer;
//begin
// Result:=0;
// if Voltage=0 then Exit;
//
// if ord(Range)<3 then
//  begin
//    if Voltage>=HighVoltage(Range) then
//      begin
//      Result:=$FFFF;
//      Exit;
//      end;
//    if Voltage<=LowVoltage(Range) then
//      begin
//      Result:=$0;
//      Exit;
//      end;
//    Result:=(round(Voltage*65536/REFIN/GainValueOutputRange[Range]) and $FFFF);
//  end;
//
// if ord(Range)>2 then
//  begin
//    if Voltage>=HighVoltage(Range) then
//      begin
//      Result:=$7FFF;
//      Exit;
//      end;
//    if Voltage<=LowVoltage(Range) then
//      begin
//      Result:=$8000;
//      Exit;
//      end;
//    if Voltage>0 then
//      Result:=(round(Voltage*65536/REFIN/GainValueOutputRange[Range]) and $7FFF)
//                 else
//      begin
//      Result:=(32767-round(abs(Voltage)*65536/REFIN/GainValueOutputRange[Range]) and $7FFF);
//      Result:=Result+$8000;
//      end;
//  end;
//end;
//
//function TDAC.LowVoltage(Range: TOutputRange): double;
//begin
// case Range of
//   p050,p100,p108: Result:=0;
//   pm050: Result:=-5*pmVoltageLimit;
//   pm100: Result:=-10*pmVoltageLimit;
//   pm108: Result:=-10.8*pmVoltageLimit;
//   else Result:=ErResult;
// end;
//end;
//
//procedure TDAC.Output(Voltage: double; Channel: Byte);
// var IntData:integer;
//     Data2,Data3:byte;
//begin
// if ChannelTypeDetermine(Channel)=A then
//     IntData:=IntVoltage(Voltage,ChannelA.Range)
//                                    else
//     IntData:=IntVoltage(Voltage,ChannelB.Range);
// Data2:=((IntData shr 8) and $FF);
// Data3:=(IntData and $FF);
// PacketCreate([DACCommand,DAC_Output,PinControl,PinGate,Channel,Data2,Data3,PinLDAC]);
// PacketIsSend(fComPort,'DAC output value setting is unsuccessful');
//end;
//
//procedure TDAC.OutputA(Voltage: double);
//begin
//  Output(Voltage,0);
//end;
//
//procedure TDAC.OutputB(Voltage: double);
//begin
//  Output(Voltage,2);
//end;
//
//procedure TDAC.OutputBoth(Voltage: double);
//begin
//  Output(Voltage,4);
//end;
//
//procedure TDAC.OutputRange(Channel: Byte; Range: TOutputRange; NotImperative: Boolean=True);
//begin
//  if ChannelRangeIsReady(Channel,Range)and(NotImperative) then  Exit;
//
//  PacketCreate([DACCommand,DAC_OR,PinControl,PinGate,Channel,0,byte(ord(Range))]);
//  if PacketIsSend(fComPort,'DAC range setting is unsuccessful') then ChannelSetRange(Channel,Range);
//end;
//
//procedure TDAC.OutputRangeA(Range:TOutputRange; NotImperative: Boolean=True);
//begin
//  OutputRange(8, Range, NotImperative);
//end;
//
//procedure TDAC.OutputRangeB(Range: TOutputRange; NotImperative: Boolean=True);
//begin
//  OutputRange(10, Range, NotImperative);
//end;
//
//procedure TDAC.OutputRangeBoth(Range: TOutputRange; NotImperative: Boolean=True);
//begin
//  OutputRange(12, Range, NotImperative);
//end;
//
//procedure TDAC.OutputSyn(VoltageA, VoltageB: double);
// var IntData:integer;
//     DataAlo,DataAhi,DataBlo,DataBhi:byte;
//begin
// IntData:=IntVoltage(VoltageA,ChannelA.Range);
// DataAhi:=((IntData shr 8) and $FF);
// DataAlo:=(IntData and $FF);
// IntData:=IntVoltage(VoltageA,ChannelB.Range);
// DataBhi:=((IntData shr 8) and $FF);
// DataBlo:=(IntData and $FF);
//
// PacketCreate([DACCommand,DAC_OutputSyn,PinControl,PinGate,PinLDAC,DataAhi,DataAlo,DataBhi,DataBlo]);
// PacketIsSend(fComPort,'DAC synchronous output value setting is unsuccessful');
//end;
//
//procedure TDAC.ChannelsReadFromIniFile(ConfigFile: TIniFile);
//begin
//  if Name='' then Exit;
//  ChannelA.Range:=TOutputRange(ConfigFile.ReadInteger(Name, 'OutputRangeA', 0));
//  ChannelB.Range:=TOutputRange(ConfigFile.ReadInteger(Name, 'OutputRangeB', 0));
//  ChannelA.Power:=ConfigFile.ReadBool(Name, 'PowerA', False);
//  ChannelB.Power:=ConfigFile.ReadBool(Name, 'PowerB', False);
//end;
//
//procedure TDAC.ChannelsWriteToIniFile(ConfigFile: TIniFile);
//begin
//  if Name='' then Exit;
//  WriteIniDef(ConfigFile,Name,'OutputRangeA', ord(ChannelA.Range),0);
//  WriteIniDef(ConfigFile,Name,'OutputRangeB', ord(ChannelB.Range),0);
//  ConfigFile.WriteBool(Name,'PowerA',ChannelA.Power);
//  ConfigFile.WriteBool(Name,'PowerB',ChannelB.Power);
//end;
//
//procedure TDAC.PacketReceiving(Sender: TObject; const Str: string);
//// var i:integer;
//begin
// if not(PacketIsReceived(Str,fData,DACCommand)) then Exit;
//
// if fData[2]=DAC_OR then
//  begin
//    MessageDlg('DAC Output Range setting has trouble',mtError,[mbOK],0);
//    ChannelSetRange(fData[3],fData[4]);
//  end;
//
// if fData[2]=DAC_Mode then
//  begin
//    MessageDlg('DAC setting Mode has trouble',mtError,[mbOK],0);
//  end;
//
// if fData[2]=DAC_Power then
//  begin
//    MessageDlg('DAC power has trouble',mtError,[mbOK],0);
//    if ((fData[3] and $10)=0) then
//       MessageDlg('DAC  internal reference is not powered!!!',mtError,[mbOK],0)
//                              else
//      begin
//        MessageDlg('DAC power has trouble',mtError,[mbOK],0);
//        if (fData[3] and $01)=0 then ChannelA.Power:=False else ChannelA.Power:=True;
//        if (fData[3] and $04)=0 then ChannelB.Power:=False else ChannelB.Power:=True;
//      end;
//  end;
//
// if fData[2]=DAC_Output then
//  begin
//    MessageDlg('DAC output has trouble',mtError,[mbOK],0);
//  end;
//
// if fData[2]=DAC_Overcurrent then
//  begin
//    if (fData[3] and $02)>0 then ChannelB.Overcurrent:=False;
//    if (fData[4] and $80)>0 then ChannelA.Overcurrent:=False;
//  end;
//
//  HookForGraphElementApdate();
//
//end;
//
//
//
//
//
//procedure TDAC.PowerOn(Channel: Byte; NotImperative: Boolean=True);
// var ChannelType: TChannelType;
//begin
//  case Channel of
//   $11: ChannelType:=A;
//   $14: ChannelType:=B;
//   $15: ChannelType:=Both;
//   else ChannelType:=Error;
//  end;
//
//  if ChannelPowerIsReady(ChannelType)and(NotImperative) then  Exit;
//  PacketCreate([DACCommand,DAC_Power,PinControl,PinGate,$10,0,Channel]);
//  if PacketIsSend(fComPort,'DAC channel power setting is unsuccessful') then ChannelSetPower(ChannelType);
//end;
//
//procedure TDAC.PowerOnA(NotImperative: Boolean=True);
//begin
//  PowerOn($11,NotImperative)
//end;
//
//procedure TDAC.PowerOnB(NotImperative: Boolean=True);
//begin
//  PowerOn($14,NotImperative)
//end;
//
//procedure TDAC.PowerOnBoth(NotImperative: Boolean=True);
//begin
//  PowerOn($15,NotImperative)
//end;
//
//procedure TDAC.Reset;
//begin
//  PacketCreate([DACCommand,DAC_Reset,PinCLR,PinGate]);
//  if PacketIsSend(fComPort,'DAC reset is unsuccessful') then
//   begin
//    ChannelA.Overcurrent:=False;
//    ChannelB.Overcurrent:=False;
//   end;
//end;
//
//procedure TDAC.PowerOffA();
//begin
//  if (ChannelA.Power)and(ChannelB.Power) then PowerOnB(False);
//  if (ChannelA.Power)and(not(ChannelB.Power)) then PowerOffBoth(False);
//end;
//
//procedure TDAC.PowerOffB();
//begin
//  if (ChannelB.Power)and(ChannelA.Power) then PowerOnA(False);
//  if (ChannelB.Power)and(not(ChannelA.Power)) then PowerOffBoth(False);
//end;
//
//procedure TDAC.PowerOffBoth(NotImperative: Boolean);
//begin
// PowerOn($10,NotImperative)
//end;
//
//
//procedure TDAC.SetChannelA(const Value: TDACChannel);
//begin
//  FChannelA := Value;
//end;
//
//procedure TDAC.SetChannelB(const Value: TDACChannel);
//begin
//  FChannelB := Value;
//end;
//
//procedure TDAC.SetMode;
//begin
//  PacketCreate([DACCommand,DAC_Mode,PinControl,PinGate,$19,$00,$04]);
//  PacketIsSend(fComPort,'DAC mode setting is unsuccessful');
////  if not(PacketIsSend(fComPort)) then
//end;
//
//Constructor TDACChannelShow.Create(DACC:TDAC;
//                                   CI:integer;
//                                   RL,VL:TLabel;
//                                   RCB:TComboBox;
//                                   RSB,VCB,VSB:TButton;
//                                   PL:TLabel;
//                                   PB:TBitBtn
//                      );
// var i:TOutputRange;
//begin
//  inherited Create();
//  DAC:=DACC;
//  ChannelIndex:=CI;
//  case ChannelIndex of
//   10:Channel:=DAC.ChannelB;
//   else Channel:=DAC.ChannelA;
//  end;
////  Channel:=DACC;
//  RangesLabel:=RL;
//  RangesComboBox:=RCB;
//  RangesSetButton:=RSB;
//  RangesSetButton.OnClick:=SetRangeButtomAction;
//  RangesComboBox.Items.Clear;
//  for I := Low(TOutputRange) to High(TOutputRange) do
//      RangesComboBox.Items.Add(OutputRangeLabels[i]);
//  PowerLabel:=PL;
//  PowerButton:=PB;
//  PowerButton.OnClick:=PowerButtomAction;
//
//  ValueLabel:=VL;
//  ValueLabel.Caption:='0';
//  ValueLabel.Font.Color:=clBlack;
//  ValueChangeButton:=VCB;
//  ValueChangeButton.OnClick:=ValueChangeButtonAction;
//  ValueSetButton:=VSB;
//  ValueSetButton.OnClick:=ValueSetButtonAction;
//
//  //  DataShow();
//
////  OutputRanges.ItemIndex:=ord(Channel.Range);
////    OutputRanges.OnClick:=TAdapterRadioGroupClick.Create(ord(Channel.Range)).RadioGroupClick;
//
//end;
//
//procedure TDACChannelShow.DataShow;
//begin
//  RangeShow();
//  PowerShow();
//end;
//
//
//
//
//
//procedure TDACChannelShow.PowerShow;
//begin
//  if Channel.Power then
//    begin
//     PowerLabel.Caption:='Power on';
//     PowerLabel.Font.Color:=clRed;
//     PowerButton.Caption:='Off';
//     PowerButton.Font.Color:=clNavy;
//    end
//                   else
//    begin
//     PowerLabel.Caption:='Power off';
//     PowerLabel.Font.Color:=clNavy;
//     PowerButton.Caption:='On';
//     PowerButton.Font.Color:=clRed;
//    end
//end;
//
//procedure TDACChannelShow.RangeShow;
//begin
// RangesLabel.Caption := OutputRangeLabels[Channel.Range];
//end;
//
////function TDACChannelShow.ReadyTesting: boolean;
////begin
//// if (not(DAC.BeginingIsDone)) then
////    begin
////     DAC.Begining();
////     Result:=DAC.BeginingIsDone;
////    end
////                            else
////    Result:=False;
////end;
//
//procedure TDACChannelShow.SetRangeButtomAction(Sender: TObject);
//begin
////   if ReadyTesting then Exit;
//   if not(RangesLabel.Caption=RangesComboBox.Items[RangesComboBox.ItemIndex]) then
//    begin
//      DAC.OutputRange(ChannelIndex,TOutputRange(RangesComboBox.ItemIndex));
//      RangeShow();
//    end;
//end;
//
//procedure TDACChannelShow.ValueChangeButtonAction(Sender: TObject);
// var value:string;
//begin
// if InputQuery('Value', 'Output value is expect', value) then
//  begin
//    try
//      ValueLabel.Caption:=FloatToStrF(StrToFloat(value),ffFixed, 6, 4);
//      ValueLabel.Font.Color:=clBlack;
//    except
//
//    end;
//  end;
//end;
//
//procedure TDACChannelShow.ValueSetButtonAction(Sender: TObject);
//begin
//   case ChannelIndex of
//   10:   DAC.OutputB(Strtofloat(ValueLabel.Caption));
//   else  DAC.OutputA(Strtofloat(ValueLabel.Caption));
//   end;
//   ValueLabel.Font.Color:=clPurple;
//end;
//
//procedure TDACChannelShow.PowerButtomAction(Sender: TObject);
//begin
////  if ReadyTesting then Exit;
//  case ChannelIndex of
//   10:
//     if Channel.Power then DAC.PowerOffB()
//                      else
//                  begin
//                    if DAC.ChannelA.Power then DAC.PowerOnBoth()
//                                          else DAC.PowerOnB();
//                  end;
//   else
//     if Channel.Power then DAC.PowerOffA()
//                      else
//                  begin
//                    if DAC.ChannelB.Power then DAC.PowerOnBoth()
//                                          else DAC.PowerOnA();
//                  end;
//
//  end;
// PowerShow();
//end;
//
//{ TDACShow }
//
//procedure TDACShow.ButtonEnable;
// var PinDefined:boolean;
//begin
// PinDefined:=(ArduDevice.PinControl<>UndefinedPin)and
//             (ArduDevice.PinGate<>UndefinedPin)and
//             ((ArduDevice as TDAC).PinLDAC<>UndefinedPin)and
//             ((ArduDevice as TDAC).PinCLR<>UndefinedPin);
// PanelA.Enabled:=(PinDefined)and((ArduDevice as TDAC).BeginingIsDone);
// PanelB.Enabled:=(PinDefined)and((ArduDevice as TDAC).BeginingIsDone);
//end;
//
//constructor TDACShow.Create(DAC: TDAC;
//                            DACCSA,DACCSB:TDACChannelShow;
//                            CPL, GPL, LDACPL, CLRPL: TLabel;
//                            SCB, SGB, SLDACB, SCLRB: TButton;
//                            PCB: TComboBox;
//                            PanA,PanB:Tpanel;
//                            IB,RB:TButton);
//begin
// inherited Create(DAC,CPL,GPL,SCB,SGB,PCB);
// PinLabels[2]:=LDACPL;
// PinLabels[3]:=CLRPL;
// SetPinButtons[2]:=SLDACB;
// SetPinButtons[3]:=SCLRB;
// DACChannelShowA:=DACCSA;
// DACChannelShowB:=DACCSB;
// DAC.HookForGraphElementApdate:=DataShow;
// PanelA:=PanA;
// PanelB:=PanB;
// InitButton:=IB;
// InitButton.OnClick:=InitButtonClick;
// ResetButton:=RB;
// ResetButton.OnClick:=ResetButtonClick;
// CreateFooter();
//end;
//
//procedure TDACShow.DataShow;
//begin
// DACChannelShowA.DataShow;
// DACChannelShowB.DataShow;
//end;
//
//procedure TDACShow.InitButtonClick(Sender: TObject);
//begin
// (ArduDevice as TDAC).Begining();
//  ButtonEnable();
//end;
//
//procedure TDACShow.NumberPinShow;
//begin
//   inherited NumberPinShow();
//   PinLabels[2].Caption:=(ArduDevice as TDAC).PinLDACStr;
//   PinLabels[3].Caption:=(ArduDevice as TDAC).PinCLRStr;
//   ButtonEnable();
//end;
//
//procedure TDACShow.ResetButtonClick(Sender: TObject);
//begin
// (ArduDevice as TDAC).Reset();
//end;
//
//
{ TAD5752_Chanel }

constructor TAD5752_Chanel.Create(ChanNumber: T5752ChanNumber);
begin
 inherited Create(AD5752_ChanelNames[ChanNumber]);
 fChanNumber:=ChanNumber;
 case fChanNumber of
   chA:begin
        fDacByte:=$00;
        fRangeByte:=$08;
        fPowerOnByte:=$13;
        fPowerOffByte:=$12;
       end;
   chB:begin
        fDacByte:=$02;
        fRangeByte:=$A;
        fPowerOnByte:=$1C;
        fPowerOffByte:=$18;
       end;
 end;
end;

procedure TAD5752_Chanel.CreateHook;
begin
  inherited CreateHook;
  fSetterKod:=AD5752Command;
  fPowerOn:=False;
  fSettedDiapazon:=NA;
  SetLength(fData,2);
  Diapazon:=p050;
  fKodMaxValue:=AD5752_MaxKod;
  fOutputValue:=0;
end;

procedure TAD5752_Chanel.DataToSendFromKod(Kod: Integer);
begin
  SetLength(fData, High(fData) + 4);
  fData[High(fData) - 2] := fDacByte;
  fData[High(fData)- 1] := ((Kod shr 8) and $FF);
  fData[High(fData)]:=(Kod and $FF)
end;

procedure TAD5752_Chanel.DataToSendFromReset;
begin
//  SHOWmessage(inttostr(fData[1]));
  SetLength(fData,5);
  fData[2] := fDacByte;
  fData[3] := $00;
  fData[4] := $00;
end;

destructor TAD5752_Chanel.Destroy;
 var doSomething:boolean;
begin
 doSomething:=False;
 SetLength(fData,2);
 if fOutputValue<>0 then
   begin
    SetLength(fData, High(fData) + 4);
    fData[High(fData) - 2] := fDacByte;
    fData[High(fData)- 1] := $00;
    fData[High(fData)]:=$00;
    fOutputValue:=0;
    doSomething:=True;
   end;
 if fPowerOn then
   begin
    SetLength(fData, High(fData) + 3);
    fData[High(fData)- 1] := $10;
    fData[High(fData)]:= fPowerOffByte;
    fPowerOn:=False;
    doSomething:=True;
   end;
 if doSomething then
  begin
   isNeededComPortState();
   sleep(50);
  end;
 inherited;
end;

function TAD5752_Chanel.NormedVoltage(Voltage: double): double;
begin
 case fDiapazon of
   p050,p100,p108: Result :=  EnsureRange(Voltage,0,fVoltageMaxValue);
   else Result :=  EnsureRange(Voltage,-fVoltageMaxValue,fVoltageMaxValue)
 end;
end;

procedure TAD5752_Chanel.PinsCreate;
begin
  Pins := TPins.Create(Name,1);
//  Pins := TPins.Create(Name,['Control'],1);
end;


procedure TAD5752_Chanel.PowerOff;
begin
 SetLength(fData,4);
 fData[2] := $10;
 fData[3]:= fPowerOffByte;
 fPowerOn:=false;
 isNeededComPortState();
end;

procedure TAD5752_Chanel.PowerOn;
begin
 SetLength(fData,4);
 fData[2] := $10;
 fData[3]:= fPowerOnByte;
 fPowerOn:=True;
 isNeededComPortState();
end;

procedure TAD5752_Chanel.PrepareAction(Voltage: double);
begin
 SetLength(fData,2);
 if fSettedDiapazon<>fDiapazon then
   begin
    SetLength(fData, High(fData) + 3);
    fData[High(fData)- 1] := fRangeByte;
    fData[High(fData)]:= AD5752_OutputRangeKod[fDiapazon];
    fSettedDiapazon:=fDiapazon;
   end;
 if not(fPowerOn) then
   begin
    SetLength(fData, High(fData) + 3);
    fData[High(fData)- 1] := $10;
    fData[High(fData)]:= fPowerOnByte;
    fPowerOn:=True;
   end;

end;

procedure TAD5752_Chanel.SetDiapazon(D: T5752OutputRange);
begin
 fDiapazon:=D;
// fVoltageMinValue:=AD5752_OutputRangeMinVoltage[D];
 case fDiapazon of
   p050,p100,p108: fVoltageMaxValue:=AD5752_OutputRangeMaxVoltage[fDiapazon]*65535/65536;
   pm050,pm100,pm108: fVoltageMaxValue:=AD5752_OutputRangeMaxVoltage[fDiapazon]*32767/32768;
   NA: fVoltageMaxValue:=0;
 end;
 fGain:=AD5752_GainOutputRange[fDiapazon];
end;

function TAD5752_Chanel.VoltageToKod(Voltage: double): integer;
begin
 Result:=round(Voltage/AD5752_REFIN/fGain*(fKodMaxValue+1));
 if Result<0 then Result:=(not(abs(Result)))and $FFFF;
end;

{ TAD5752_ChanelShow }

constructor TAD5752_ChanelShow.Create(
                   AD5752_Chanel: TAD5752_Chanel;
                   CPL: TPanel;
                   VData, KData: TStaticText;
                   VL, KL, VDL, KDL: TLabel;
                   VSB, KSB, RB, OffB: TButton;
                   PinVariant: TStringList;
                   DiapRG: TRadioGroup);
 var i:T5752OutputRange;
begin
 inherited Create(AD5752_Chanel,[CPL],PinVariant,VData, KData, VL, KL, VSB, KSB, RB);

 fDiapazonRG:=DiapRG;
 fDiapazonRG.Columns:=2;
 fDiapazonRG.Items.Clear;
 for I :=p050 to pm108 do
    fDiapazonRG.Items.Add(AD5752_OutputRangeLabels[i]);
 fDiapazonRG.OnClick:=DiapazonChange;

 fValueDiapazonLabel:=VDL;
 fValueDiapazonLabel.Font.Color:=clGreen;
 fKodDiapazonLabel:=KDL;
 fKodDiapazonLabel.Font.Color:=clGreen;

 fPowerOff:=OffB;
 fPowerOff.Caption:='To power on';
 fPowerOff.OnClick:=PowerOffOn;
end;

procedure TAD5752_ChanelShow.CreatePinShow(PinLs: array of TPanel;
  PinVariant: TStringList);
begin
  PinShow:=TOnePinsShow.Create(fArduinoSetter.Pins,PinLs[0],PinVariant);
end;

procedure TAD5752_ChanelShow.DiapazonChange(Sender: TObject);
begin
 (fArduinoSetter as TAD5752_Chanel).Diapazon:=T5752OutputRange(fDiapazonRG.ItemIndex);
 fValueDiapazonLabel.Caption:=AD5752_OutputRangeLabels[(fArduinoSetter as TAD5752_Chanel).Diapazon];
 case (fArduinoSetter as TAD5752_Chanel).Diapazon of
   p050,p100,p108:fKodDiapazonLabel.Caption:=AD5752_OutputRangeKodLabels[0];
   else fKodDiapazonLabel.Caption:=AD5752_OutputRangeKodLabels[1];
 end;
 if (fArduinoSetter as TAD5752_Chanel).Power
  then
    fPowerOff.Caption:='To power on'
  else
     fPowerOff.Caption:='To power off';
end;

procedure TAD5752_ChanelShow.HookReadFromIniFile(ConfigFile: TIniFile);
 var TempItemIndex:integer;
begin
 inherited HookReadFromIniFile(ConfigFile);
 if PinShow.Pins.Name='' then Exit;
 TempItemIndex := ConfigFile.ReadInteger(PinShow.Pins.Name, 'Diap', -1);
 if (TempItemIndex > -1) and (TempItemIndex < fDiapazonRG.Items.Count) then
  begin
   fDiapazonRG.ItemIndex:=TempItemIndex;
   DiapazonChange(nil);
  end;
end;

procedure TAD5752_ChanelShow.PowerOffOn(Sender: TObject);
begin
  if (fArduinoSetter as TAD5752_Chanel).Power
  then
   begin
    (fArduinoSetter as TAD5752_Chanel).PowerOff;
    fPowerOff.Caption:='To power on';
   end
  else
   begin
    (fArduinoSetter as TAD5752_Chanel).PowerOn;
     fPowerOff.Caption:='To power off';
   end

end;

procedure TAD5752_ChanelShow.WriteToIniFile(ConfigFile: TIniFile);
begin
 inherited WriteToIniFile(ConfigFile);
 if PinShow.Pins.Name='' then Exit;
 ConfigFile.WriteInteger(PinShow.Pins.Name, 'Diap', fDiapazonRG.ItemIndex);
end;

initialization
   AD5752_chA:=TAD5752_Chanel.Create(chA);
   AD5752_chB:=TAD5752_Chanel.Create(chB);
finalization
  AD5752_chA.Free;
  AD5752_chB.Free;
end.
