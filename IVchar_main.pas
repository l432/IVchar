unit IVchar_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPort, ComCtrls, Buttons, SPIdevice, ExtCtrls, IniFiles,PacketParameters,
  TeEngine, Series, TeeProcs, Chart, Spin, OlegType, Grids, OlegMath,Measurement, 
  TempThread;

type
  TIVchar = class(TForm)
    ComPort1: TComPort;
    PC: TPageControl;
    TS_Main: TTabSheet;
    TS_B7_21A: TTabSheet;
    BBClose: TBitBtn;
    LConnected: TLabel;
    BConnect: TButton;
    LV721A: TLabel;
    RGV721A_MM: TRadioGroup;
    RGV721ARange: TRadioGroup;
    BV721AMeas: TButton;
    SBV721AAuto: TSpeedButton;
    Time: TTimer;
    LV721AU: TLabel;
    TS_B7_21: TTabSheet;
    PanelV721_I: TPanel;
    RGV721I_MM: TRadioGroup;
    ComDPacket: TComDataPacket;
    BParamReceive: TButton;
    CBV721A: TComboBox;
    LV721APin: TLabel;
    BV721ASet: TButton;
    PanelV721_II: TPanel;
    RGV721II_MM: TRadioGroup;
    CBV721I: TComboBox;
    CBV721II: TComboBox;
    LV721IPin: TLabel;
    LV721IIPin: TLabel;
    BV721IISet: TButton;
    BV721ISet: TButton;
    RGV721IRange: TRadioGroup;
    RGV721IIRange: TRadioGroup;
    LV721I: TLabel;
    LV721IU: TLabel;
    LV721II: TLabel;
    LV721IIU: TLabel;
    BV721IMeas: TButton;
    BV721IIMeas: TButton;
    SBV721IAuto: TSpeedButton;
    SBV721IIAuto: TSpeedButton;
    TS_DAC: TTabSheet;
    TS_Setting: TTabSheet;
    ChLine: TChart;
    ForwLine: TPointSeries;
    RevLine: TPointSeries;
    ChLg: TChart;
    ForwLg: TPointSeries;
    RevLg: TPointSeries;
    GBIV: TGroupBox;
    CBForw: TCheckBox;
    CBRev: TCheckBox;
    BIVStart: TButton;
    BIVStop: TButton;
    GBAD: TGroupBox;
    CBSStep: TCheckBox;
    BIVSave: TButton;
    LADVoltage: TLabel;
    LADVoltageValue: TLabel;
    LADCurrent: TLabel;
    LADCurrentValue: TLabel;
    LADRange: TLabel;
    GBT: TGroupBox;
    SBTAuto: TSpeedButton;
    LTRunning: TLabel;
    LTRValue: TLabel;
    LTLast: TLabel;
    LTLastValue: TLabel;
    GBFB: TGroupBox;
    PBIV: TProgressBar;
    UDFBHighLimit: TUpDown;
    LFBHighlimitValue: TLabel;
    STFBhighlimit: TStaticText;
    UDFBLowLimit: TUpDown;
    LFBLowlimitValue: TLabel;
    STFBlowlimit: TStaticText;
    PanelSplit: TPanel;
    SGFBStep: TStringGrid;
    BFBEdit: TButton;
    BFBDelete: TButton;
    BFBAdd: TButton;
    STFBSteps: TStaticText;
    STFBDelay: TStaticText;
    LFBDelayValue: TLabel;
    BFBDelayInput: TButton;
    GBRB: TGroupBox;
    LRBHighlimitValue: TLabel;
    LRBLowlimitValue: TLabel;
    LRBDelayValue: TLabel;
    STRBSteps: TStaticText;
    UDRBHighLimit: TUpDown;
    STRBhighlimit: TStaticText;
    UDRBLowLimit: TUpDown;
    STRBlowlimit: TStaticText;
    SGRBStep: TStringGrid;
    BRBEdit: TButton;
    BRBDelete: TButton;
    BRBAdd: TButton;
    STRBDelay: TStaticText;
    BRBDelayInput: TButton;
    GBTS: TGroupBox;
    RBTSImitation: TRadioButton;
    RBTSTermocouple: TRadioButton;
    CBTSTC: TComboBox;
    GBVS: TGroupBox;
    RBVSSimulation: TRadioButton;
    RBVSMeasur: TRadioButton;
    CBVSMeas: TComboBox;
    GBCS: TGroupBox;
    RBCSSimulation: TRadioButton;
    RBCSMeasur: TRadioButton;
    CBCSMeas: TComboBox;
    BSaveSetting: TButton;
    LV721IPinG: TLabel;
    LV721APinG: TLabel;
    BV721ASetGate: TButton;
    BV721ISetGate: TButton;
    LV721IIPinG: TLabel;
    BV721IISetGate: TButton;
    PanelDACChA: TPanel;
    STChA: TStaticText;
    CBDAC: TComboBox;
    LDACPinC: TLabel;
    BDACSetC: TButton;
    LDACPinG: TLabel;
    BDACSetG: TButton;
    LDACPinLDAC: TLabel;
    BDACSetLDAC: TButton;
    LDACPinCLR: TLabel;
    BDACSetCLR: TButton;
    STORChA: TStaticText;
    LORChA: TLabel;
    CBORChA: TComboBox;
    BORChA: TButton;
    LPowChA: TLabel;
    BBPowChA: TBitBtn;
    BDACInit: TButton;
    BDACReset: TButton;
    LOVChA: TLabel;
    BOVchangeChA: TButton;
    BOVsetChA: TButton;
    PanelDACChB: TPanel;
    LORChB: TLabel;
    LPowChB: TLabel;
    LOVChB: TLabel;
    STChB: TStaticText;
    STORChB: TStaticText;
    CBORChB: TComboBox;
    BORChB: TButton;
    BBPowChB: TBitBtn;
    STOVChB: TStaticText;
    BOVchangeChB: TButton;
    BOVsetChB: TButton;
    STOVChA: TStaticText;
    GBMeasChA: TGroupBox;
    RBMeasSimChA: TRadioButton;
    RBMeasMeasChA: TRadioButton;
    CBMeasChA: TComboBox;
    LMeasChA: TLabel;
    BMeasChA: TButton;
    GBMeasChB: TGroupBox;
    LMeasChB: TLabel;
    RBMeasSimChB: TRadioButton;
    RBMeasMeasChB: TRadioButton;
    CBMeasChB: TComboBox;
    BMeasChB: TButton;
    RGInputVoltage: TRadioGroup;
    RGDO: TRadioGroup;
    GBPR: TGroupBox;
    LPR: TLabel;
    BPR: TButton;
    procedure FormCreate(Sender: TObject);
    procedure PortConnected();
    procedure BConnectClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PCChange(Sender: TObject);
    procedure BParamReceiveClick(Sender: TObject);
    procedure ComDPacketPacket(Sender: TObject; const Str: string);
    procedure UDFBHighLimitClick(Sender: TObject; Button: TUDBtnType);
    procedure CBForwClick(Sender: TObject);
    procedure SGFBStepDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SGFBStepSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BFBAddClick(Sender: TObject);
    procedure BFBDeleteClick(Sender: TObject);
    procedure BFBEditClick(Sender: TObject);
    procedure BFBDelayInputClick(Sender: TObject);
    procedure SGRBStepDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BRBDeleteClick(Sender: TObject);
    procedure BRBEditClick(Sender: TObject);
//    procedure RBTSImitationClick(Sender: TObject);
    procedure BSaveSettingClick(Sender: TObject);
    procedure SBTAutoClick(Sender: TObject);
    procedure BIVStartClick(Sender: TObject);
    procedure PCChanging(Sender: TObject; var AllowChange: Boolean);
    procedure BIVStopClick(Sender: TObject);
    procedure BPRClick(Sender: TObject);
//    procedure BOVsetChAClick(Sender: TObject);
//    procedure BORChAClick(Sender: TObject);
//    procedure RGORChAClick(Sender: TObject);
  private
    procedure ComponentView;
    {початкове налаштування різних компонентів}
    procedure PinsFromIniFile;
    {зчитування номерів пінів, які використовуються загалом}
    procedure PinsWriteToIniFile;
    Procedure NumberPinsShow();
    {відображується вміст NumberPins в усі
    ComboBox з Tag=1}
    procedure RangeShow;
    procedure RangeReadFromIniFile;
    procedure RangeToForm;
    procedure StepReadFromIniFile (A:PVector; Ident:string);
    procedure StepsReadFromIniFile;
    procedure StepsWriteToIniFile;
    procedure ForwStepShow;
    procedure RevStepShow;
    procedure DelayTimeReadFromIniFile;
    procedure DelayTimeShow;
    procedure DelayTimeWriteToIniFile;
    procedure MeasuringEquipmentRead;
    procedure MeasuringEquipmentShow;
//    procedure SourcesReadFromIniFileAndToForm;
//    procedure SourcesWriteToIniFile;
//    procedure RadioButtonSelect(GB:TGroupBox; Index:integer);
    procedure SettingWriteToIniFile;
    procedure VoltmetrsCreate;
    procedure VoltmetrsReadFromIniFileAndToForm;
    procedure VoltmetrsWriteToIniFile;
    procedure VoltmetrsFree;
    procedure DACCreate;
    procedure DACFree;
    procedure DACReadFromIniFileAndToForm;
    procedure DACWriteToIniFile;
    procedure DevicesCreate;
    procedure DevicesFree;
    procedure DevicesReadFromIniAndToForm;
    procedure DevicesWriteToIniFile;
    procedure SetVoltage(Value:double);
    procedure TemperatureThreadCreate;
    function StepDetermine(Voltage: Double):double;
    function MeasurementNumberDetermine():integer;
    procedure BoxFromIniFile;
    procedure BoxToIniFile;
    procedure IVCharBegin;
    procedure IVCharEnd;
    procedure VectorsCreate;
    procedure VectorsDispose;
    { Private declarations }
    procedure IVcharCycle(Action: TSimpleEvent);
    procedure IVcharFullCycle(Action: TSimpleEvent);
    procedure ActionEmpty();
    procedure ActionMeasurement();
//    procedure ActionReverse();
    procedure RangeWriteToIniFile;
    procedure IVVoltageMeas(var tempV: Double; tempI: Double);
    procedure IVCurrentMeas(var tempI: Double);
    procedure VoltageRealDetermination;
    procedure SleepReal;
    procedure IVDataSave(tempI: Double; tempV: Double);
    procedure IVSetVoltage;
  public
    V721A:TV721A;
    V721_I,V721_II:TV721;
    VoltmetrShows:array of TVoltmetrShow;
    ConfigFile:TIniFile;
    MeasuringEquipment,
    NumberPins:TStringList; // номери пінів, які використовуються як керуючі для SPI
    Xmin,Ymin,Xmax,Ymax:double;
    //    Range:TDiapazon;//межі вимірювань, Х - пряма гілка, Y - зворотня
    ForwSteps,RevSteps,IVResult:PVector;
    ForwDelay,RevDelay:Integer;
//    TemperatureSource,VoltageSource,CurrentSource:Integer;
    DAC:TDAC;
    DACChanelShows:array of TDACChannelShow;
    DACShow:TDACShow;
    Simulator:TSimulator;
    Devices:array of TInterfacedObject;
    Temperature_MD:TTemperature_MD;
    Current_MD:TCurrent_MD;
    VoltageIV_MD:TVoltageIV_MD;
    ChannelA_MD,ChannelB_MD:TVoltageChannel_MD;
    TemperatureMeasuringThread:TTemperatureMeasuringThread;
    NumberOfTemperatureMeasuring: Integer;
    {TemperatureIsMeasuring,}IVMeasuringToStop,ItIsForward:boolean;
    PointNumber:Integer;
    VoltageInput,VoltageInputCorrection,VoltageInputReal,Temperature:double;
  end;

const
  Undefined='NoData';
  Vmax=8;
  Imax=2e-2;
  Imin=5e-11;
  StepDefault=0.01;
  MeasuringEquipmentName:array[0..2]of string=
           ('B7-21A','B7-21 (1)','B7-21 (2)');


var
  IVchar: TIVchar;

implementation

{$R *.dfm}

procedure TIVchar.ActionEmpty;
begin

end;

procedure TIVchar.RangeWriteToIniFile;
 var Section,Ident:string;
begin
    Section:='Range';
    Ident:='Measure';
    ConfigFile.EraseSection(Section);
    WriteIniDef(ConfigFile,Section,Ident+'XMin',Xmin,0);
    WriteIniDef(ConfigFile,Section,Ident+'YMin',Ymin,0);
    WriteIniDef(ConfigFile,Section,Ident+'XMax',Xmax,Vmax);
    WriteIniDef(ConfigFile,Section,Ident+'Ymax',Ymax,Vmax);
end;

procedure TIVchar.IVVoltageMeas(var tempV: Double; tempI: Double);
var
  Rs: Double;
begin
  Rs:=StrToFloat(LPR.Caption);
  repeat
     Application.ProcessMessages;
     if IVMeasuringToStop then Exit;
     tempV := VoltageIV_MD.GetMeasurementResult(VoltageInputReal);
//     showmessage(floattostr(tempV)+' '+floattostr(VoltageInput));

    if abs(tempV*Rs)>0.0001 then
              if  tempV>0 then tempV:=tempV-abs(tempI)*Rs
                       else tempV:=tempV+abs(tempI)*Rs;


     if RGDO.ItemIndex=1 then
       begin
       tempV:=-tempV;
       LADVoltageValue.Caption:=FloatToStrF(tempV,ffFixed, 4, 3);
       end;

     if (not(CBSStep.Checked))or(not(ItIsForward)) then Break;
     if abs(tempV-VoltageInput)>0.0004 then
//       begin
       VoltageInputCorrection:=VoltageInputCorrection-(tempV-VoltageInput);
//       showmessage(floattostr(VoltageInput)+' '+floattostr(tempV)+' '+floattostr(VoltageInputCorrection) )
//       end;
     if abs(tempV-VoltageInput)>0.0009 then IVSetVoltage();
//      begin
//       VoltageRealDetermination;
//       SetVoltage(VoltageInputReal);
//       SleepReal;
//      end;
  until (abs(tempV-VoltageInput)<0.001) ;


//{}if not(Par^.SC_Reg)and(znak=1) then
// begin
// if i=0 then UUtemp:=U
//        else
//         begin
//               if U1>0 then UUtemp:=a^.x[i]+Delta(a^.x[i])
//                       else UUtemp:=-abs(a^.x[i])-abs(Delta(a^.x[i]));
//         end;
//
// if (abs(U1-UUtemp)>0.0008) then
//  begin
//  if (abs(U1-UUtemp)>0.001) then Upop:=Upop-(U1-UUtemp)
//      else
//  if (Par^.Kan1.Name=UTC)and(UNITC.Tp='v')and(znak=1) then
//                        Upop:=Upop-0.0005*(U1-UUtemp)/abs(U1-UUtemp)
//                                           else
//                        Upop:=Upop-0.001*(U1-UUtemp)/abs(U1-UUtemp);
//  end;
//
// if (abs(U1-UUtemp)>0.0014)and(i<>0) then Continue;
// if ((abs(U1-UUtemp)>0.0018){or(U1<0)})and(i=0) then Continue;
//
//
// end;{}

end;



procedure TIVchar.IVCurrentMeas(var tempI: Double);
 var
  Jump: Double;
  IncreaseVoltage: Boolean;
begin
  tempI := Current_MD.GetMeasurementResult(VoltageInputReal);
  if RGDO.ItemIndex=1 then
       begin
       tempI:=-tempI;
       LADVoltageValue.Caption:=FloatToStrF(tempI,ffExponent, 4, 2);
       end;

  if (abs(tempI)<=Imin)and(VoltageInput<>0) then
    begin
      if ItIsForward then Jump:=0.05 else Jump:=0.5;
      if Jump<StepDetermine(VoltageInput) then Jump:=StepDetermine(VoltageInput);

      IncreaseVoltage:=True;
      repeat
        Application.ProcessMessages;
        if IVMeasuringToStop then Exit;

        VoltageInput:=VoltageInput+Jump;
        IVSetVoltage();

        tempI := Current_MD.GetMeasurementResult(VoltageInputReal);
        if RGDO.ItemIndex=1 then
             begin
             tempI:=-tempI;
             LADVoltageValue.Caption:=FloatToStrF(tempI,ffExponent, 4, 2);
             end;
        if  (abs(tempI)>Imin)and(IncreaseVoltage) then
                       begin
                       Jump:=-Jump/5;
                       IncreaseVoltage:=False;
                       end;
       if  (abs(tempI)<=Imin)and(not(IncreaseVoltage)) then
                      begin
                      Jump:=-Jump/5;
                      IncreaseVoltage:=true;
                      end;
      until ((abs(tempI)<=Imin)and(Jump<StepDetermine(VoltageInput)))
    end;

//  if RGDO.ItemIndex=1 then
//       begin
//       tempI:=-tempI;
//       LADVoltageValue.Caption:=FloatToStrF(tempI,ffExponent, 4, 2);
//       end;


//begin
// if znak=1 then Ustep:=0.05 else Ustep:=0.5;
// Ustep:=Ustep*IVParam.delU[5]/abs(IVParam.delU[5]);
// ring2:=true;
// repeat
//  if (znak=2)and(abs(U)<0.09)and(abs(Ustep)>0.4) then U:=0.0001;
//  U:=U+Ustep;
//  if Par^.IV_Reg then Str(U:5:3,s1) else Str(-U:5:3,s1);
//  S1:=S1+' B';
//  outtextXY(400,200,s1);
//
//  NaprugaADA(U+Par^.UUpop[choic]+Upop);
//
//  delU:=Delta(U);
//
//  U2:=MeasureUI;
//  U2:=MeasureUI;
//  U2:=(U2-Par^.Upop[choic])/Ruse[choic];
//  if  (abs(U2)>Imin)and(ring2) then
//                       begin
//                       Ustep:=-Ustep/5;
//                       ring2:=False;
//                       end;
//  if  (abs(U2)<=Imin)and(not(ring2)) then
//                      begin
//                      Ustep:=-Ustep/5;
//                      ring2:=true;
//                      end;
//  Setcolor(GetBkColor);
//  outtextXY(400,200,s1);
//  SetColor(Ucolor[znak]);
// until ((abs(U2)<=Imin)and(abs(Ustep)<abs(delU)))or
//       (not(ring2)and(abs(U)<0.11)and(znak=2));
//end;

end;

procedure TIVchar.VoltageRealDetermination;
begin
 if ItIsForward then VoltageInputReal := VoltageInput + VoltageInputCorrection
                else VoltageInputReal := -VoltageInput;
end;

procedure TIVchar.SleepReal;
begin
  if ItIsForward then
    sleep(ForwDelay)
  else
    sleep(RevDelay);
end;

procedure TIVchar.IVDataSave(tempI: Double; tempV: Double);
begin
    if abs(tempI)<=Imin then Exit;
    IVResult.Add(tempV, tempI);
  if ItIsForward then
  begin
    ForwLine.AddXY(tempV, tempI);
    if abs(tempI) > 1E-11 then
      ForwLg.AddXY(tempV, abs(tempI));
  end            else
  begin
    RevLine.AddXY(-tempV, -tempI);
    if abs(tempI) > 1E-11 then
      RevLg.AddXY(-tempV, abs(tempI));
  end;

end;

procedure TIVchar.IVSetVoltage;
begin
  VoltageRealDetermination;
  SetVoltage(VoltageInputReal);
  SleepReal;
end;

procedure TIVchar.ActionMeasurement;
 var tempV,tempI:double;
begin
  IVSetVoltage();

 // showmessage(floattostr(VoltageInput+VoltageInputCorrection));

 IVCurrentMeas(tempI);

 if (tempI=ErResult)or(abs(tempI)>=Imax) then
  begin
   IVMeasuringToStop:=True;
   Exit;
  end;

//   showmessage(floattostr(tempI));

 IVVoltageMeas(tempV,tempI);
 if tempV=ErResult then
  begin
   IVMeasuringToStop:=True;
   Exit;
  end;

  IVDataSave(tempI, tempV);

  if NumberOfTemperatureMeasuring=PointNumber then
    Temperature:=Temperature_MD.GetMeasurementResult(VoltageInput);
  PBIV.Position := PointNumber;

end;


procedure TIVchar.BConnectClick(Sender: TObject);
begin
 try
  ComPort1.Connected:=not(ComPort1.Connected);
  if ComPort1.Connected then
   begin
    ComPort1.ClearBuffer(True, True);
    ComPort1.AbortAllAsync;
   end;
 finally
  PortConnected();
 end;
end;

procedure TIVchar.BFBAddClick(Sender: TObject);
 var temp:double;
begin
  if (Sender as TButton).Name='BFBAdd' then
   begin
      temp:=round(10*StrToFloat555(InputBox(
                                  'Voltage limit',
                                  'Input new voltage limit.'+
                                  #10+'The value must be greater 0 and less or equal '
                                  +FloatToStrF(Vmax,ffGeneral,2,1),
                                  '')))/10;
      if (temp>0)and(temp<=Vmax)and(temp<>ErResult) then
       begin
         ForwSteps.Add(temp,StepDefault);
         ForwSteps.DeleteDuplicate;
         ForwSteps.Sorting();
         ForwStepShow();
       end;
   end;
  if (Sender as TButton).Name='BRBAdd' then
   begin
      temp:=round(10*StrToFloat555(InputBox(
                                  'Voltage limit',
                                  'Input new voltage limit.'+
                                  #10+'The value must be less 0 and greater or equal '
                                  +FloatToStrF(-Vmax,ffGeneral,2,1),
                                  '')))/10;
      if (temp<0)and(temp>=(-Vmax))and(temp<>ErResult) then
       begin
         RevSteps.Add(abs(temp),StepDefault);
         RevSteps.DeleteDuplicate;
         RevSteps.Sorting();
         RevStepShow();
       end;
   end;
end;

procedure TIVchar.BFBDelayInputClick(Sender: TObject);
 var temp:integer;
     stTemp:string;
begin
 if (Sender as TButton).Name='BFBDelayInput'
            then stTemp:=IntToStr(ForwDelay)
            else stTemp:=IntToStr(RevDelay);
 temp:=round(StrToInt555(InputBox(
                                'Delay time',
                                'Input delay time.'+
                                #10+'The value must be greater 0 and less 10000',
                                stTemp)));
 if (temp>=0)and(temp<10000)and(temp<>ErResult)
    then
      begin
       if (Sender as TButton).Name='BFBDelayInput'
              then ForwDelay:=temp
              else RevDelay:=temp;
       DelayTimeShow;
      end;
end;

procedure TIVchar.BFBDeleteClick(Sender: TObject);
begin
 if (SGFBStep.Row=(SGFBStep.RowCount-1))or(SGFBStep.Row<1) then Exit;
 ForwSteps.Delete(SGFBStep.Row-1);
 ForwStepShow();
end;

procedure TIVchar.BFBEditClick(Sender: TObject);
 var st:string;
     temp:double;
begin
 if (SGFBStep.Row=0)or
   ((SGFBStep.Row>=SGFBStep.RowCount-1)and(SGFBStep.Col=0)) then Exit;
 if (SGFBStep.Col=0) then
    if InputQuery('Voltage limit',
                  'Edit voltage limit value.'+
                   #10+'The value must be greater 0 and less or equal '
                   +FloatToStrF(Vmax,ffGeneral,2,1),
                   st) then
       begin
        temp:=round(10*StrToFloat555(st))/10;
        if (temp>0)and(temp<=Vmax)and(temp<>ErResult) then
         begin
           ForwSteps.X[SGFBStep.Row-1]:=temp;
           ForwSteps.DeleteDuplicate;
           ForwSteps.Sorting();
           ForwStepShow();
         end;
       end;
 if (SGFBStep.Col=1) then
    if InputQuery('Step value',
                  'Edit step value.'+
                   #10+'The value must be greater than 0',
                   st) then
       begin
        temp:=round(1000*StrToFloat555(st))/1000;
        if (temp>0)and(temp<>ErResult) then
         begin
           ForwSteps.Y[SGFBStep.Row-1]:=temp;
           ForwStepShow();
         end;
       end;
 end;



procedure TIVchar.BIVStartClick(Sender: TObject);
begin
// showmessage(inttostr(MeasurementNumberDetermine));
  IVCharBegin();
 case RGInputVoltage.ItemIndex of
  1:DAC.OutputRangeA(pm100);
  2:DAC.OutputRangeB(pm100);
 end;

  IVcharFullCycle(ActionMeasurement);
//  ItIsForward:=True;
//  IVcharCycle(ActionMeasurement);
//  ItIsForward:=False;
//  IVcharCycle(ActionMeasurement);

//  IVcharCycle(ActionEmpty,False);
//  sleep(5000);

  IVCharEnd();
 case RGInputVoltage.ItemIndex of
  1,2:DAC.Reset;
 end;
  if Temperature=ErResult then
    Temperature:=Temperature_MD.GetMeasurementResult(VoltageInput);
end;

procedure TIVchar.BIVStopClick(Sender: TObject);
begin
 IVMeasuringToStop:=True;
end;

//procedure TIVchar.BOVsetChAClick(Sender: TObject);
// var d:double;
//     int:integer;
//begin
//  d:=Strtofloat(LOVChA.Caption);
//  DAC.ChannelB.Range:=pm100;
//  int:=Dac.IntVoltage(d,DAC.ChannelB.Range);
//  showmessage(IntToHex(int,4));
//end;

//procedure TIVchar.BORChAClick(Sender: TObject);
//begin
//   if not(LORChA.Caption=CBORChA.Items[CBORChA.ItemIndex]) then
//    begin
//      DAC.OutputRangeA(TOutputRange(CBORChA.ItemIndex));
//      LORChA.Caption:=OutputRangeLabels[DAC.ChannelA.Range];
//    end;
//end;

procedure TIVchar.BParamReceiveClick(Sender: TObject);
begin
 PacketCreate([ParameterReceiveCommand,0]);
 PacketIsSend(ComPort1,'Parameter receiving is unsuccessful');
end;

procedure TIVchar.BPRClick(Sender: TObject);
 var value:string;
begin
 if InputQuery('Resistance', 'Parasitic resistance value is expected', value) then
  begin
    try
      LPR.Caption:=FloatToStrF(StrToFloat(value),ffFixed, 5, 3);
    except

    end;
  end;
end;

procedure TIVchar.BRBDeleteClick(Sender: TObject);
begin
 if (SGRBStep.Row=(SGRBStep.RowCount-1))or(SGRBStep.Row<1) then Exit;
 RevSteps.Delete(SGRBStep.Row-1);
 RevStepShow();
end;

procedure TIVchar.BRBEditClick(Sender: TObject);
 var st:string;
     temp:double;
begin
 if (SGRBStep.Row=0)or
   ((SGRBStep.Row>=SGRBStep.RowCount-1)and(SGRBStep.Col=0)) then Exit;
 if (SGRBStep.Col=0) then
    if InputQuery('Voltage limit',
                  'Edit voltage limit value.'+
                  #10+'The value must be less 0 and greater or equal '
                  +FloatToStrF(-Vmax,ffGeneral,2,1),
                  st) then
       begin
        temp:=round(10*StrToFloat555(st))/10;
        if (temp<0)and(temp>=(-Vmax))and(temp<>ErResult) then
         begin
           RevSteps.X[SGRBStep.Row-1]:=abs(temp);
           RevSteps.DeleteDuplicate;
           RevSteps.Sorting();
           RevStepShow();
         end;
       end;
 if (SGRBStep.Col=1) then
    if InputQuery('Step value',
                  'Edit step value.'+
                   #10+'The value must be greater than 0',
                   st) then
       begin
        temp:=round(1000*StrToFloat555(st))/1000;
        if (temp>0)and(temp<>ErResult) then
         begin
           RevSteps.Y[SGRBStep.Row-1]:=temp;
           RevStepShow();
         end;
       end;
end;


procedure TIVchar.BSaveSettingClick(Sender: TObject);
begin
 SettingWriteToIniFile();
end;



procedure TIVchar.CBForwClick(Sender: TObject);
begin
 RangeShow();
end;


procedure TIVchar.ComDPacketPacket(Sender: TObject; const Str: string);
 var Data:TArrByte;
     i:integer;
begin
 if PacketIsReceived(Str,Data,ParameterReceiveCommand) then
  begin
   NumberPins.Clear;
   for I := 3 to High(Data)-1 do
    NumberPins.Add(IntToStr(Data[i]));
   NumberPinsShow();
  end;

end;

procedure TIVchar.FormCreate(Sender: TObject);
begin
 DecimalSeparator:='.';
 ComponentView();

 ConfigFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'IVChar.ini');

 VoltmetrsCreate();

 NumberPins:=TStringList.Create;
 MeasuringEquipment:=TStringList.Create;
// Range:=TDiapazon.Create;
 VectorsCreate();

 BoxFromIniFile();

 PinsFromIniFile();
 NumberPinsShow();

 VoltmetrsReadFromIniFileAndToForm();

 MeasuringEquipmentRead();
 MeasuringEquipmentShow();

 DevicesCreate();
 DevicesReadFromIniAndToForm();

 RangeReadFromIniFile();
 RangeToForm();

 StepsReadFromIniFile();
 ForwStepShow();
 RevStepShow();

 DelayTimeReadFromIniFile();
 DelayTimeShow();

 DACCreate();
 DACReadFromIniFileAndToForm;

// TemperatureThreadCreate();


 ComDPacket.StartString:=PacketBeginChar;
 ComDPacket.StopString:=PacketEndChar;
 ComDPacket.ComPort:=ComPort1;

 try
  ComPort1.Open;
  Comport1.AbortAllAsync;
  ComPort1.ClearBuffer(True, True);
 finally
  PortConnected();
 end;
end;

procedure TIVchar.FormDestroy(Sender: TObject);
begin
// TemperatureMeasuringThread.Terminate;

 DACWriteToIniFile();
 VoltmetrsWriteToIniFile();
 PinsWriteToIniFile;
 SettingWriteToIniFile();
 ConfigFile.Free;

 DevicesFree();

 DACFree();
 VectorsDispose();
// Range.Free;
 MeasuringEquipment.Free;
 NumberPins.Free;
 VoltmetrsFree();



 try
  if ComPort1.Connected then
   begin
    Comport1.AbortAllAsync;
    ComPort1.ClearBuffer(True, True);
    ComPort1.Close;
   end;
 finally
 end;
end;




procedure TIVchar.PCChange(Sender: TObject);
 var i:integer;
begin
// showmessage(inttostr(ord(V721A.MeasureMode)));
 for I := 0 to High(VoltmetrShows) do
   try
   if VoltmetrShows[i].AutoSpeedButton.Down then
     begin
       VoltmetrShows[i].AutoSpeedButton.Down:=False;
       VoltmetrShows[i].AutoSpeedButton.OnClick(Sender);
     end;
   except
   end;
end;

procedure TIVchar.PCChanging(Sender: TObject; var AllowChange: Boolean);
begin
 AllowChange:=False;
end;

procedure TIVchar.PortConnected();
begin
 if ComPort1.Connected then
  begin
   LConnected.Caption:='ComPort is open';
   LConnected.Font.Color:=clBlue;
   BConnect.Caption:='To close'
  end
                       else
  begin
   LConnected.Caption:='ComPort is close';
   LConnected.Font.Color:=clRed;
   BConnect.Caption:='To open'
  end
end;


//procedure TIVchar.SBV721AAutoClick(Sender: TObject);
//begin
// if  (Sender as TSpeedButton).Name='SBV721AAuto' then
//   begin
//     BV721AMeas.Enabled:=not(SBV721AAuto.Down);
//     if SBV721AAuto.Down then Time.OnTimer:=BV721AMeas.OnClick;
//     Time.Enabled:=SBV721AAuto.Down;
//   end;
//
// if  (Sender as TSpeedButton).Name='SBV721IAuto' then
//   begin
//     BV721IMeas.Enabled:=not(SBV721IAuto.Down);
//     if SBV721IIAuto.Down then
//       SBV721IIAuto.Down:=False;
//     if SBV721IAuto.Down then
//       begin
//       SBV721IIAuto.Enabled:=False;
//       BV721IIMeas.Enabled:=False;
//       end
//                         else
//       VotmetrToForm(V721_II);
//     if SBV721IAuto.Down then Time.OnTimer:=BV721IMeas.OnClick;
//     Time.Enabled:=SBV721IAuto.Down;
//   end;
//
// if  (Sender as TSpeedButton).Name='SBV721IIAuto' then
//   begin
//     BV721IIMeas.Enabled:=not(SBV721IIAuto.Down);
//     if SBV721IAuto.Down then
//       SBV721IAuto.Down:=False;
//     if SBV721IIAuto.Down then
//       begin
//       SBV721IAuto.Enabled:=False;
//       BV721IMeas.Enabled:=False;
//       end
//                         else
//       VotmetrToForm(V721_I);
//     if SBV721IIAuto.Down then Time.OnTimer:=BV721IIMeas.OnClick;
//     Time.Enabled:=SBV721IIAuto.Down;
//   end;
//end;



procedure TIVchar.SGFBStepDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
 if (ARow>1)and(not(odd(Arow))) then
  begin
     SGFBStep.Canvas.Brush.Color:=RGB(252,212,213);
     SGFBStep.Canvas.FillRect(Rect);
     SGFBStep.Canvas.TextOut(Rect.Left+2,Rect.Top+2,SGFBStep.Cells[Acol,Arow]);
  end
end;

procedure TIVchar.SGFBStepSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
 if (Sender as TStringGrid).Name='SGFBStep' then
  begin
    BFBEdit.Enabled:=True;
    BFBDelete.Enabled:=True;
  end;
 if (Sender as TStringGrid).Name='SGRBStep' then
  begin
    BRBEdit.Enabled:=True;
    BRBDelete.Enabled:=True;
  end;
end;

procedure TIVchar.SGRBStepDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
 if (ARow>1)and(not(odd(Arow))) then
  begin
     SGRBStep.Canvas.Brush.Color:=RGB(218,240,254);
     SGRBStep.Canvas.FillRect(Rect);
     SGRBStep.Canvas.TextOut(Rect.Left+2,Rect.Top+2,SGRBStep.Cells[Acol,Arow]);
  end
end;

procedure TIVchar.UDFBHighLimitClick(Sender: TObject; Button: TUDBtnType);
begin
 if (Sender as TUpDown).Name='UDFBHighLimit' then
  begin
  if (UDFBHighLimit.Position-UDFBLowLimit.Position)<0.5 then
   begin
    UDFBHighLimit.Position:=UDFBHighLimit.Position+UDFBHighLimit.Increment;
    Exit;
   end;
  LFBHighlimitValue.Caption:=FloatToStrF(UDFBHighLimit.Position/10,ffFixed, 1, 1);
  XMax:=UDFBHighLimit.Position/10;
//  Range.XMax:=UDFBHighLimit.Position/10;
  end;
 if (Sender as TUpDown).Name='UDFBLowLimit' then
  begin
  if (UDFBHighLimit.Position-UDFBLowLimit.Position)<0.5 then
   begin
    UDFBLowLimit.Position:=UDFBLowLimit.Position-UDFBLowLimit.Increment;
    Exit;
   end;
  LFBLowlimitValue.Caption:=FloatToStrF(UDFBLowLimit.Position/10,ffFixed, 1, 1);
  XMin:=UDFBLowLimit.Position/10;
//  Range.XMin:=UDFBLowLimit.Position/10;
  end;
 if (Sender as TUpDown).Name='UDRBHighLimit' then
  begin
//  showmessage(inttostr((UDRBLowLimit.Position-UDRBHighLimit.Position)));
  if UDRBLowLimit.Position-UDRBHighLimit.Position>-0.5 then
   begin
    UDRBHighLimit.Position:=UDRBHighLimit.Position+UDRBHighLimit.Increment;
    Exit;
   end;
  LRBHighlimitValue.Caption:=FloatToStrF(-(UDRBHighLimit.Max-UDRBHighLimit.Position)/10,ffFixed, 1, 1);
  YMin:=(UDRBHighLimit.Max-UDRBHighLimit.Position)/10;
//  Range.YMin:=(UDRBHighLimit.Max-UDRBHighLimit.Position)/10;
  end;
 if (Sender as TUpDown).Name='UDRBLowLimit' then
  begin
  if UDRBLowLimit.Position-UDRBHighLimit.Position>-0.5 then
   begin
    UDRBLowLimit.Position:=UDRBLowLimit.Position-UDRBLowLimit.Increment;
    Exit;
   end;
  LRBLowlimitValue.Caption:=FloatToStrF(-(UDRBLowLimit.Max-UDRBLowLimit.Position)/10,ffFixed, 1, 1);
  Ymax:=(UDRBLowLimit.Max-UDRBLowLimit.Position)/10;
//  Range.Ymax:=(UDRBLowLimit.Max-UDRBLowLimit.Position)/10;
  end;
 RangeShow;
end;


Procedure TIVchar.NumberPinsShow();
 var i:integer;
begin
 try
 for i := IVchar.ComponentCount - 1 downto 0 do
   if IVchar.Components[i].Tag = 1 then
    (IVchar.Components[i] as TComboBox).Items:=NumberPins;
 finally
 end;
end;

procedure TIVchar.RangeShow;
 var Start,Finish:double;
begin
//  if CBForw.Checked then Finish:=Range.XMax
//                    else Finish:=-Range.Ymin;
//  if CBRev.Checked then Start:=-Range.YMax
//                   else Start:=Range.Xmin;
  if CBForw.Checked then Finish:=XMax
                    else Finish:=-Ymin;
  if CBRev.Checked then Start:=-YMax
                   else Start:=Xmin;
  if (not(CBForw.Checked))and(not(CBRev.Checked))
    then begin
         Finish:=0;
         Start:=0;
         end;
  LADRange.Caption := 'Range is [' + FloattostrF(Start, ffFixed, 1, 1) + ' .. '
                                   + FloattostrF(Finish, ffFixed, 1, 1) + '] V';
end;

procedure TIVchar.RangeReadFromIniFile;
 var Section,Ident:string;
begin

//  Range.ReadFromIniFile(ConfigFile, 'Range', 'Measure');
//  if (Range.XMax = ErResult)or(Range.XMax >Vmax) then
//                   Range.XMax := Vmax;
//  if (Range.YMax = ErResult)or(Range.YMax >Vmax) then
//                   Range.YMax := Vmax;
//  if Range.XMin<0 then Range.XMin := 0;
//  if Range.YMin<0 then Range.YMin := 0;

  Section:='Range';
  Ident:='Measure';
  XMin:=ConfigFile.ReadFloat(Section,Ident+'XMin',0);
  YMin:=ConfigFile.ReadFloat(Section,Ident+'YMin',0);
  XMax:=ConfigFile.ReadFloat(Section,Ident+'XMax',Vmax);
  YMax:=ConfigFile.ReadFloat(Section,Ident+'Ymax',Vmax);
  if (XMax >Vmax)or(Xmin>=Xmax) then XMax := Vmax;
  if (YMax >Vmax)or(Ymin>=Ymax) then YMax := Vmax;
  if (XMin<0)or(Xmin>=Xmax) then XMin := 0;
  if (YMin<0)or(Ymin>=Ymax) then YMin := 0;
end;

procedure TIVchar.RangeToForm;
begin
  RangeShow;
//  UDFBHighLimit.Position := round(Range.XMax * 10);
//  UDFBLowLimit.Position := round(Range.XMin * 10);
  UDFBHighLimit.Position := round(XMax * 10);
  UDFBLowLimit.Position := round(XMin * 10);
  LFBHighlimitValue.Caption := FloatToStrF(UDFBHighLimit.Position / 10, ffFixed, 1, 1);
  LFBLowlimitValue.Caption := FloatToStrF(UDFBLowLimit.Position / 10, ffFixed, 1, 1);
  UDRBHighLimit.Position := UDRBHighLimit.Max-round(YMin * 10);
  UDRBLowLimit.Position := UDRBLowLimit.Max-round(YMax * 10);
//  UDRBHighLimit.Position := UDRBHighLimit.Max-round(Range.YMin * 10);
//  UDRBLowLimit.Position := UDRBLowLimit.Max-round(Range.YMax * 10);
  LRBHighlimitValue.Caption := FloatToStrF(-(UDRBHighLimit.Max-UDRBHighLimit.Position) / 10, ffFixed, 1, 1);
  LRBLowlimitValue.Caption := FloatToStrF(-(UDRBLowLimit.Max-UDRBLowLimit.Position)/ 10, ffFixed, 1, 1);
end;

//procedure TIVchar.RBTSImitationClick(Sender: TObject);
//begin
//  if (Sender as TRadioButton).Parent.Name='GBTS' then
//   begin
//     if RBTSImitation.Checked then
//       begin
//        TemperatureSource:=0;
//        CBTSTC.Enabled:=False;
//       end;
//     if RBTSTermocouple.Checked then
//       begin
//        TemperatureSource:=1;
//        CBTSTC.Enabled:=True;
//       end;
//   end;
//
//  if (Sender as TRadioButton).Parent.Name='GBVS' then
//   begin
//     if RBVSSimulation.Checked then
//       begin
//        VoltageSource:=0;
//        CBVSMeas.Enabled:=False;
//       end;
//     if RBVSMeasur.Checked then
//       begin
//        VoltageSource:=1;
//        CBVSMeas.Enabled:=True;
//       end;
//   end;
//
//  if (Sender as TRadioButton).Parent.Name='GBCS' then
//   begin
//     if RBCSSimulation.Checked then
//       begin
//        CurrentSource:=0;
//        CBCSMeas.Enabled:=False;
//       end;
//     if RBCSMeasur.Checked then
//       begin
//        CurrentSource:=1;
//        CBCSMeas.Enabled:=True;
//       end;
//   end;
//end;

procedure TIVchar.StepsReadFromIniFile;
begin
  StepReadFromIniFile(ForwSteps,'Forw');
  StepReadFromIniFile(RevSteps,'Rev');
end;

function TIVchar.StepDetermine(Voltage: Double): double;
var
  I: Integer;
  Steps:PVector;
begin
 Result:=StepDefault;
 if ItIsForward then Steps:=ForwSteps
                else Steps:=RevSteps;
 
 for I := 0 to High(Steps^.X) do
  if abs(Voltage)<Steps^.X[i] then
   begin
     Result:=Steps^.Y[i];
     Break;
   end;
end;

procedure TIVchar.StepReadFromIniFile(A:PVector; Ident:string);
begin
  A^.ReadFromIniFile(ConfigFile, 'Step', Ident);
  A^.DeleteErResult;
  A^.DeleteDuplicate;
  A^.Sorting;
  while (A^.n > 0) and (A^.X[High(A^.X)] > Vmax) do
    A^.Delete(A^.n - 1);
  while (A^.n > 0) and (A^.X[0] < 0) do
    A^.Delete(A^.n - 1);
  if (A^.n > 0) and (A^.X[High(A^.X)] <> Vmax) then
    begin
     A^.SetLenVector(A^.n+1);
     A^.X[High(A^.X)] := Vmax;
     A^.Y[High(A^.X)] := StepDefault;
    end;
  if A^.n < 1 then
    begin
      A^.SetLenVector(1);
      A^.X[0] := Vmax;
      A^.Y[0] := StepDefault;
    end;
end;

procedure TIVchar.StepsWriteToIniFile;
begin
  ConfigFile.EraseSection('Step');
  ForwSteps.WriteToIniFile(ConfigFile, 'Step', 'Forw');
  RevSteps.WriteToIniFile(ConfigFile, 'Step', 'Rev');
end;

procedure TIVchar.ForwStepShow;
 var
  I: Integer;
begin
  SGFBStep.RowCount := ForwSteps^.n + 1;
  for I := 0 to High(ForwSteps^.X) do
   begin
     SGFBStep.Cells[0,i+1]:=FloatToStrF(ForwSteps^.X[i],ffGeneral,2,1);
     SGFBStep.Cells[1,i+1]:=FloatToStrF(ForwSteps^.Y[i],ffGeneral,4,3);
   end;
end;

procedure TIVchar.RevStepShow;
 var
  I: Integer;
begin
  SGRBStep.RowCount := RevSteps^.n + 1;
  for I := 0 to High(RevSteps^.X) do
   begin
     SGRBStep.Cells[0,i+1]:=FloatToStrF(-RevSteps^.X[i],ffGeneral,2,1);
     SGRBStep.Cells[1,i+1]:=FloatToStrF(RevSteps^.Y[i],ffGeneral,3,2);
   end;
end;

//procedure TIVchar.RGORChAClick(Sender: TObject);
//begin
// DAC.OutputRangeA(TOutputRange((Sender as TRadioGroup).ItemIndex));
// (Sender as TRadioGroup).ItemIndex:=ord(DAC.ChannelA.Range);
//end;

procedure TIVchar.DelayTimeReadFromIniFile;
begin
  ForwDelay := ConfigFile.ReadInteger('Delay', 'ForwTime', 0);
  if (ForwDelay<0)or(ForwDelay>10000) then ForwDelay:=0;
  RevDelay := ConfigFile.ReadInteger('Delay', 'RevTime', 0);
  if (RevDelay<0)or(RevDelay>10000) then RevDelay:=0;
end;

procedure TIVchar.DelayTimeShow;
begin
  LFBDelayValue.Caption := IntToStr(ForwDelay);
  LRBDelayValue.Caption := IntToStr(RevDelay);
end;

procedure TIVchar.DelayTimeWriteToIniFile;
begin
  WriteIniDef(ConfigFile, 'Delay', 'ForwTime', ForwDelay, 0);
  WriteIniDef(ConfigFile, 'Delay', 'RevTime', RevDelay, 0);
end;

function TIVchar.MeasurementNumberDetermine(): integer;
// var Number:integer;
//     Voltage:double;
begin
 PointNumber:=0;
 IVcharFullCycle(ActionEmpty);
// ItIsForward:=True;
// IVcharCycle(ActionEmpty);
// ItIsForward:=False;
// IVcharCycle(ActionEmpty);
 Result:=PointNumber;

//number:=0;
// if CBForw.Checked then
//  begin
//   Voltage:=XMin;
//   repeat
//     inc(Number);
//     Voltage:=Voltage+StepDetermine(Voltage,ForwSteps);
//   until Voltage>XMax;
//  end;
// if CBRev.Checked then
//  begin
//   Voltage:=YMin;
//   repeat
//     inc(Number);
//     Voltage:=Voltage+StepDetermine(Voltage,RevSteps);
//   until Voltage>YMax;
//  end;
// Result:=Number;

end;

procedure TIVchar.BoxFromIniFile;
begin
  CBForw.Checked := ConfigFile.ReadBool('Box', CBForw.Name, False);
  CBRev.Checked := ConfigFile.ReadBool('Box', CBRev.Name, False);
  CBSStep.Checked := ConfigFile.ReadBool('Box', CBSStep.Name, False);
  RGDO.ItemIndex:= ConfigFile.ReadInteger('Box', RGDO.Name,0);
  LPR.Caption:=FloatToStrF(ConfigFile.ReadFloat('Box', 'Resistance',0),ffFixed, 5, 3);
end;

procedure TIVchar.BoxToIniFile;
begin
  ConfigFile.EraseSection('Box');
  WriteIniDef(ConfigFile, 'Box', CBForw.Name, CBForw.Checked);
  WriteIniDef(ConfigFile, 'Box', CBRev.Name, CBRev.Checked);
  WriteIniDef(ConfigFile, 'Box', CBSStep.Name, CBSStep.Checked);
  WriteIniDef(ConfigFile, 'Box', RGDO.Name, RGDO.ItemIndex);
  WriteIniDef(ConfigFile, 'Box', 'Resistance', StrToFloat(LPR.Caption),0)
end;

procedure TIVchar.IVCharBegin;

begin
  IVMeasuringToStop:=False;
  PBIV.Max := MeasurementNumberDetermine();
  NumberOfTemperatureMeasuring:=round(PBIV.Max/2);

  PBIV.Position := 0;
  BIVStop.Enabled:=True;
  CBForw.Enabled:=False;
  CBRev.Enabled:=False;
  CBSStep.Enabled:=False;
  BIVSave.Enabled:=False;
  BIVStart.Enabled:=False;
  BConnect.Enabled:=False;
  BParamReceive.Enabled:=False;
  SBTAuto.Enabled:=False;
  PC.OnChanging:=PCChanging;

//  TemperatureIsMeasuring:=SBTAuto.Down;
//  if TemperatureIsMeasuring then SBTAuto.Down:=False;
  if SBTAuto.Down then SBTAuto.Down:=False;

  PointNumber:=0;
  PBIV.Position := PointNumber;
  SetLenVector(IVResult,PointNumber);
  Temperature:=ErResult;
//  VoltageInputCorrection:=0;

  ForwLine.Clear;
  RevLine.Clear;
  ForwLg.Clear;
  RevLg.Clear;

end;

procedure TIVchar.IVcharCycle(Action: TSimpleEvent);
 var Start,Finish:double;
//     Steps:PVector;
     Condition:boolean;
begin
 if ItIsForward then
   begin
//     Start:=Range.XMin;
//     Finish:=Range.XMax;
     Start:=XMin;
     Finish:=XMax;
//     Steps:=ForwSteps;
     Condition:=CBForw.Checked;
   end          else
   begin
//     Start:=Range.YMin;
//     Finish:=Range.YMax;
     Start:=YMin;
     Finish:=YMax;
//     Steps:=RevSteps;
     Condition:=CBRev.Checked;
   end;

   VoltageInputCorrection:=0;

 if Condition then
  begin
   VoltageInput:=Start;
   repeat
     Application.ProcessMessages;
     if IVMeasuringToStop then Exit;
     inc(PointNumber);

     Action;
     VoltageInput:=VoltageInput+StepDetermine(VoltageInput);
   until VoltageInput>Finish;
  end;
end;

procedure TIVchar.IVCharEnd;
begin
  BIVStop.Enabled := False;
  CBForw.Enabled := True;
  CBRev.Enabled := True;
  CBSStep.Enabled := True;
  BIVStart.Enabled := True;
  BConnect.Enabled := True;
  BParamReceive.Enabled := True;
  SBTAuto.Enabled := True;
  PC.OnChanging := nil;
  if High(IVResult^.X)>0 then
   begin
   BIVSave.Enabled := True;
   IVResult.Sorting;
   IVResult.DeleteDuplicate;
   end;

  
//  if TemperatureIsMeasuring then SBTAuto.Down:=True;
end;

procedure TIVchar.IVcharFullCycle(Action: TSimpleEvent);
begin
  ItIsForward:=True;
  IVcharCycle(Action);
  ItIsForward:=False;
  IVcharCycle(Action);
end;

procedure TIVchar.VectorsCreate;
begin
  new(ForwSteps);
  new(RevSteps);
  new(IVResult);
end;

procedure TIVchar.VectorsDispose;
begin
  dispose(ForwSteps);
  dispose(RevSteps);
  dispose(IVResult);
end;

procedure TIVchar.MeasuringEquipmentRead;
 var i:integer;
begin
  MeasuringEquipment.Clear;
  for I := Low(MeasuringEquipmentName) to High(MeasuringEquipmentName) do
   MeasuringEquipment.Add(MeasuringEquipmentName[i]);
end;

procedure TIVchar.MeasuringEquipmentShow;
 var i:integer;
begin
 try
 for i := IVchar.ComponentCount - 1 downto 0 do
   if IVchar.Components[i].Tag = 5 then
    (IVchar.Components[i] as TComboBox).Items:=MeasuringEquipment;
 finally
 end;
end;


//procedure TIVchar.SourcesReadFromIniFileAndToForm;
//begin
// TemperatureSource := ConfigFile.ReadInteger('Sources', 'Temperature', 0);
// RadioButtonSelect(GBTS,TemperatureSource);
// try
//  CBTSTC.ItemIndex:=ConfigFile.ReadInteger('Sources', 'Termocouple', 0);
// except
//  CBTSTC.ItemIndex:=0;
// end;
//
// VoltageSource := ConfigFile.ReadInteger('Sources', 'Voltage', 0);
// RadioButtonSelect(GBVS,VoltageSource);
// try
//  CBVSMeas.ItemIndex:=ConfigFile.ReadInteger('Sources', 'Voltage_M', 0);
// except
//  CBVSMeas.ItemIndex:=0;
// end;
//
// CurrentSource := ConfigFile.ReadInteger('Sources', 'Current', 0);
// RadioButtonSelect(GBCS,CurrentSource);
// try
//  CBCSMeas.ItemIndex:=ConfigFile.ReadInteger('Sources', 'Current_M', 0);
// except
//  CBCSMeas.ItemIndex:=0;
// end;
//
//end;

//procedure TIVchar.SourcesWriteToIniFile;
//begin
//  ConfigFile.EraseSection('Sources');
//  WriteIniDef(ConfigFile, 'Sources', 'Temperature', TemperatureSource, 0);
//  WriteIniDef(ConfigFile, 'Sources', 'Termocouple', CBTSTC.ItemIndex, 0);
//  WriteIniDef(ConfigFile, 'Sources', 'Voltage', VoltageSource, 0);
//  WriteIniDef(ConfigFile, 'Sources', 'Voltage_M', CBVSMeas.ItemIndex, 0);
//  WriteIniDef(ConfigFile, 'Sources', 'Current', CurrentSource, 0);
//  WriteIniDef(ConfigFile, 'Sources', 'Current_M', CBCSMeas.ItemIndex, 0);
//end;

//procedure TIVchar.RadioButtonSelect(GB:TGroupBox; Index:integer);
// var i:integer;
//begin
// for I := 0 to Main.ComponentCount - 1 do
//    if (Main.Components[i] is TRadioButton)and
//     ((Main.Components[i] as TRadioButton).Parent.Name=GB.Name) then
//      (Main.Components[i] as TRadioButton).Checked:=
//        ((Main.Components[i] as TRadioButton).Tag=(GB.Tag+Index))
//end;

procedure TIVchar.SBTAutoClick(Sender: TObject);
begin
// if SBTAuto.Down then
//    Temperature_MD.GetMeasurementResult(ErResult)

// if SBTAuto.Down then
//    TemperatureMeasuringThread.Resume
//                 else
//    TemperatureMeasuringThread.Suspend;
 if SBTAuto.Down then
    TemperatureThreadCreate()
                 else
    TemperatureMeasuringThread.Terminate;
end;

procedure TIVchar.SettingWriteToIniFile;
begin
//    Range.WriteToIniFile(ConfigFile, 'Range', 'Measure');
  RangeWriteToIniFile;
  StepsWriteToIniFile;
  DelayTimeWriteToIniFile;
  DevicesWriteToIniFile;
  BoxToIniFile;
end;

procedure TIVchar.SetVoltage(Value: double);
begin
 if RGDO.ItemIndex=1 then Value:=-Value;
 case RGInputVoltage.ItemIndex of
  1:DAC.OutputA(Value);
  2:DAC.OutputB(Value);
 end;
end;

procedure TIVchar.TemperatureThreadCreate;
begin
  TemperatureMeasuringThread:=TTemperatureMeasuringThread.Create(True);
  TemperatureMeasuringThread.TemperatureMD:=Temperature_MD;
  TemperatureMeasuringThread.Priority:=tpLower;
  TemperatureMeasuringThread.FreeOnTerminate:=True;
  TemperatureMeasuringThread.Resume;
end;

procedure TIVchar.VoltmetrsCreate;
begin
  V721A := TV721A.Create(ComPort1, 'V721A');
  V721_I := TV721.Create(ComPort1, 'V721_I');
  V721_II := TV721.Create(ComPort1, 'V721_II');
  SetLength(VoltmetrShows,3);
  VoltmetrShows[0]:= TVoltmetrShow.Create(V721A, RGV721A_MM, RGV721ARange, LV721A, LV721AU, LV721APin, LV721APinG, BV721ASet, BV721ASetGate, BV721AMeas, SBV721AAuto, CBV721A, Time);
//  VoltmetrShows[0]:= TVoltmetrShow.Create(V721_I, RGV721A_MM, RGV721ARange, LV721A, LV721AU, LV721APin, LV721APinG, BV721ASet, BV721ASetGate, BV721AMeas, SBV721AAuto, CBV721A, Time);
  VoltmetrShows[1]:= TVoltmetrShow.Create(V721_I, RGV721I_MM, RGV721IRange, LV721I, LV721IU, LV721IPin, LV721IPinG, BV721ISet, BV721ISetGate, BV721IMeas, SBV721IAuto, CBV721I, Time);
  VoltmetrShows[2]:= TVoltmetrShow.Create(V721_II, RGV721II_MM, RGV721IIRange, LV721II, LV721IIU, LV721IIPin, LV721IIPinG, BV721IISet, BV721IISetGate, BV721IIMeas, SBV721IIAuto, CBV721II, Time);
end;

procedure TIVchar.VoltmetrsReadFromIniFileAndToForm;
 var i:integer;
begin
 for I := 0 to High(VoltmetrShows) do
  begin
  VoltmetrShows[i].PinsReadFromIniFile(ConfigFile);
  VoltmetrShows[i].NumberPinShow;
  VoltmetrShows[i].ButtonEnabled;
  end;
end;

procedure TIVchar.VoltmetrsWriteToIniFile;
  var i:integer;
begin
 for I := 0 to High(VoltmetrShows) do
  VoltmetrShows[i].PinsWriteToIniFile(ConfigFile);
end;

procedure TIVchar.VoltmetrsFree;
 var i:integer;
begin
  for I := 0 to High(VoltmetrShows) do
        VoltmetrShows[i].Free;
  if assigned(V721A) then
    V721A.Free;
  if assigned(V721_I) then
    V721_I.Free;
  if assigned(V721_II) then
    V721_II.Free;
end;

procedure TIVchar.DACCreate;
begin
  DAC := TDAC.Create(ComPort1, 'AD5752R');
  SetLength(DACChanelShows,2);
  DACChanelShows[0]:= TDACChannelShow.Create(DAC,8, LORChA,LOVChA,CBORChA,
                                      BORChA,BOVchangeChA,BOVsetChA,
                                      LPowChA,BBPowChA);
  DACChanelShows[1]:= TDACChannelShow.Create(DAC,10, LORChB,LOVChB,CBORChB,
                                      BORChB,BOVchangeChB,BOVsetChB,
                                      LPowChB,BBPowChB);
  DACShow:=TDACShow.Create(DAC,
                           DACChanelShows[0],DACChanelShows[1],
                           LDACPinC,LDACPinG,LDACPinLDAC,LDACPinCLR,
                           BDACSetC,BDACSetG,BDACSetLDAC,BDACSetCLR,CBDAC,
                           PanelDACChA,PanelDACChB,BDACInit,BDACReset);
end;

procedure TIVchar.DACFree;
   var i:integer;
begin
  DACShow.Free;
  for I := 0 to High(DACChanelShows) do
        DACChanelShows[i].Free;
  if assigned(DAC) then DAC.Free;
end;

procedure TIVchar.DACReadFromIniFileAndToForm;
begin
  DACShow.PinsReadFromIniFile(ConfigFile);
  DAC.ChannelsReadFromIniFile(ConfigFile);
  DAC.Begining();
  DACShow.NumberPinShow;
  DACShow.DataShow;
end;

procedure TIVchar.DACWriteToIniFile;
begin
  DACShow.PinsWriteToIniFile(ConfigFile);
  DAC.ChannelsWriteToIniFile(ConfigFile);
end;

procedure TIVchar.DevicesCreate;
begin
  Simulator:=TSimulator.Create;
  SetLength(Devices,High(MeasuringEquipmentName)+2);
  Devices[0]:=Simulator;
  Devices[1]:=V721A;
  Devices[2]:=V721_I;
  Devices[3]:=V721_II;
  Temperature_MD:=TTemperature_MD.Create(Devices,RBTSImitation,RBTSTermocouple,CBTSTC,LTRValue);
  Current_MD:=TCurrent_MD.Create(Devices,RBCSSimulation,RBCSMeasur,CBCSMeas,LADCurrentValue);
  VoltageIV_MD:=TVoltageIV_MD.Create(Devices,RBVSSimulation,RBVSMeasur,CBVSMeas,LADVoltageValue);
  ChannelA_MD:=TVoltageChannel_MD.Create(Devices,RBMeasSimChA,RBMeasMeasChA,CBMeasChA,LMeasChA);
  ChannelB_MD:=TVoltageChannel_MD.Create(Devices,RBMeasSimChB,RBMeasMeasChB,CBMeasChB,LMeasChB);
  ChannelA_MD.AddActionButton(BMeasChA,LOVChA);
  ChannelB_MD.AddActionButton(BMeasChB,LOVChB);
end;

procedure TIVchar.DevicesFree;
begin
  Temperature_MD.Free;
  Current_MD.Free;
  VoltageIV_MD.Free;
  ChannelA_MD.Free;
  ChannelB_MD.Free;
  Simulator.Free;
end;

procedure TIVchar.DevicesReadFromIniAndToForm;
begin
  Temperature_MD.ReadFromIniFile(ConfigFile,'Sources','Temperature');
  Current_MD.ReadFromIniFile(ConfigFile,'Sources','Current');
  VoltageIV_MD.ReadFromIniFile(ConfigFile,'Sources','Voltage');
  ChannelA_MD.ReadFromIniFile(ConfigFile,'Sources','ChannelA');
  ChannelB_MD.ReadFromIniFile(ConfigFile,'Sources','ChannelB');
  RGInputVoltage.ItemIndex:=ConfigFile.ReadInteger('Sources', 'Input voltage', 0);
end;

procedure TIVchar.DevicesWriteToIniFile;
begin
  ConfigFile.EraseSection('Sources');
  Temperature_MD.WriteToIniFile(ConfigFile,'Sources','Temperature');
  Current_MD.WriteToIniFile(ConfigFile,'Sources','Current');
  VoltageIV_MD.WriteToIniFile(ConfigFile,'Sources','Voltage');
  ChannelA_MD.WriteToIniFile(ConfigFile,'Sources','ChannelA');
  ChannelB_MD.WriteToIniFile(ConfigFile,'Sources','ChannelB');
  WriteIniDef(ConfigFile,'Sources', 'Input voltage',RGInputVoltage.ItemIndex,0);
end;

procedure TIVchar.PinsWriteToIniFile;
var
  i: Integer;
begin
  ConfigFile.EraseSection('PinNumbers');
  ConfigFile.WriteInteger('PinNumbers', 'PinCount', NumberPins.Count);
  for I := 0 to NumberPins.Count - 1 do
    ConfigFile.WriteString('PinNumbers', 'Pin' + IntToStr(i), NumberPins[i]);
end;

procedure TIVchar.PinsFromIniFile;
var
  i: Integer;
begin
  for I := 0 to ConfigFile.ReadInteger('PinNumbers', 'PinCount', 3) - 1 do
    NumberPins.Add(ConfigFile.ReadString('PinNumbers', 'Pin' + IntToStr(i), IntToStr(UndefinedPin)));
end;

procedure TIVchar.ComponentView;
 var i:integer;
begin
  PanelV721_I.Height := round(0.48*PanelV721_I.Parent.Height);
  PanelV721_II.Height := round(0.48*PanelV721_II.Parent.Height);
  ChLine.Top:=0;
  ChLine.Left:=0;
  ChLine.Height := round(ChLine.Parent.Height / 2);
  ChLine.Width:= round(0.7*ChLine.Parent.Width);
  ChLg.Top:=round(ChLg.Parent.Height / 2);
  ChLg.Left:=0;
  ChLg.Height := round(ChLg.Parent.Height / 2);
  ChLg.Width:= round(0.7*ChLg.Parent.Width);

  LADVoltageValue.Caption:=Undefined;
  LADCurrentValue.Caption:=Undefined;
  LTRValue.Caption:=Undefined;
  LTLastValue.Caption:=Undefined;

  PC.OnChanging:=nil;
  ChLg.LeftAxis.Logarithmic:=True;

  try
  for i := IVchar.ComponentCount - 1 downto 0 do
   begin
     if IVchar.Components[i].Tag = 1 then
      (IVchar.Components[i] as TComboBox).Sorted:=False;
     if IVchar.Components[i].Tag = 2 then
      (IVchar.Components[i] as TUpDown).Max:=round(10*Vmax);
     if IVchar.Components[i].Tag = 3 then
      begin
      (IVchar.Components[i] as TStringGrid).Cells[0,0]:='Limit';
      (IVchar.Components[i] as TStringGrid).Cells[1,0]:='Step';
      (IVchar.Components[i] as TStringGrid).ColWidths[0]:=(IVchar.Components[i] as TStringGrid).Canvas.TextWidth('Limit')+15;
      (IVchar.Components[i] as TStringGrid).ColWidths[1]:=(IVchar.Components[i] as TStringGrid).Canvas.TextWidth('0.005')+15;
      end;
     if IVchar.Components[i].Tag = 4 then
      (IVchar.Components[i] as TButton).Enabled:=False;
   end;
  finally
  end;

end;

end.
