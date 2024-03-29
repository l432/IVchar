unit Measurement;

interface

uses
  StdCtrls, IniFiles, Messages, Classes, ExtCtrls,
  Buttons, OlegTypePart2, Windows, SyncObjs;

Const
   WM_MyMeasure=WM_USER+1;
   {�����������, ��� ���������� ���� �����������
   ���������� � ������ ������}

   TemperMessage=1;
   {WPARAM ���������, ���� ����������� ��� ���������� �����������}
   ControlMessage=2;
   {WPARAM ���������, ���� ����������� ��� ����������
   ��������� � ���������� �������}
   ControlOutputMessage=3;
   {WPARAM ���������, ���� ����������� ��� ������������
   ��������� ��������� � ���������� �������}
   FastIVCurrentMeas=4;

type

//IMeasurement = interface (IName)
//['{B5C5EED8-FB2A-4FDA-96F4-59CE09C9E5F0}']
// function GetNewData:boolean;
// function GetValue:double;
// function GetData:double;
//// function GetDeviceKod:byte;
// procedure SetNewData(Value:boolean);
// procedure GetDataThread(WPARAM: word; EventEnd:THandle);
// property NewData:boolean read GetNewData write SetNewData;
// property Value:double read GetValue;
//// property DeviceKod:byte read GetDeviceKod;
//end;

IMeasurement = interface (IName)
  ['{7A6DCE4C-9A04-444A-B7FD-39B800BDE6A7}']
 function GetNewData:boolean;
 function GetValue:double;
 function GetData:double;
 function GetDeviceKod:byte;
 procedure SetNewData(Value:boolean);
 procedure GetDataThread(WPARAM: word; EventEnd:THandle);
 property NewData:boolean read GetNewData write SetNewData;
 property Value:double read GetValue;
 property DeviceKod:byte read GetDeviceKod;
end;

ISource = interface (IName)
  ['{3E3BA1FA-AA35-4998-BD6F-47FC04A869C4}']
 function GetOutputValue:double;
 procedure Output(Value:double);
 {���������� �� ����� ������� Value}
 Procedure Reset();
 {���������� �� ����� 0}
 property OutputValue:double read GetOutputValue;
end;


//IDAC = interface (IName)
IDAC = interface (ISource)
  ['{F729B2E9-AF49-4293-873B-83D53C258E0A}']
// function GetOutputValue:double;
 function GetDACKod:byte;
// procedure Output(Value:double);
 {���������� �� ����� ������� Value}
 procedure OutputInt(Kod:integer);
 {���������� �� ����� �������, ��� ������� Kod}
// Procedure Reset();
 {���������� �� ����� 0}
// property OutputValue:double read GetOutputValue;
 property DACKod:byte read GetDACKod;
end;

ICalibration = interface
  ['{88FD380C-1EA7-4EC5-B2C8-1C463E92A625}']
 function CalibrationStep(Voltage:double):double;
 {������� ���� ��� �������� ����������� ������� �� �������� ������� Voltage}
 procedure OutputCalibr(Value:double);
 {���������� �� ����� ������� Value �� ��� �����������}
end;

  TArrIMeas=array of IMeasurement;

ITemperatureMeasurement = interface (IMeasurement)
  ['{DDC24597-B316-4E8B-B246-1DDD0B4D5E5D}']
  function GetTemperature:double;
  procedure GetTemperatureThread(EventEnd:THandle);
end;



TSimulator = class (TNamedInterfacedObject,IMeasurement,ISource,IDAC,ITemperatureMeasurement)
private
 fValue:double;
 fNewData:boolean;
 fOutputValue:double;
 function GetNewData:boolean;
 function GetValue:double;
 function GetOutputValue:double;
 function GetDeviceKod:byte;
 function GetDACKod:byte;
 procedure SetNewData(Value:boolean);
public
 property Value:double read GetValue;
 property NewData:boolean read GetNewData write SetNewData;
 property OutputValue:double read GetOutputValue;
 property DeviceKod:byte read GetDeviceKod;
 property DACKod:byte read GetDACKod;

 Constructor Create(name:string);overload;
 Constructor Create();overload;
 function GetTemperature:double;
 function GetData:double;
 procedure Output(Value:double);
 Procedure Reset();
 procedure OutputInt(Kod:integer);
 procedure GetDataThread(WPARAM: word;EventEnd:THandle);
 procedure GetTemperatureThread(EventEnd:THandle);
end;


TMeasurementShowSimple=class(TSimpleFreeAndAiniObject)
  protected
//   fMeter:IMeasurement;
   fMeter:pointer;
   fDigitNumber:byte;
   DataLabel,UnitLabel:TLabel;
   MeasurementButton:TButton;
   Time:TTimer;
   procedure MeasurementButtonClick(Sender: TObject);virtual;
   procedure AutoSpeedButtonClick(Sender: TObject);
   function UnitModeLabel():string;virtual;
   function GetMeter:IMeasurement;
  public
   AutoSpeedButton:TSpeedButton;
   property Meter:IMeasurement read GetMeter;
   property DigitNumber:byte read fDigitNumber write fDigitNumber;
   Constructor Create(Meter:IMeasurement;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      TT:TTimer
                      );
   procedure MetterDataShow();virtual;
end;

TMeasurementShow=class  (TMeasurementShowSimple)
  protected
   MeasureMode,Range:TRadioGroup;
   procedure StringArrayToRadioGroup(SA:array of string;
                                     RG:TRadioGroup);
   procedure IndexToRadioGroup(Index:ShortInt;RG:TRadioGroup);
  public
   Constructor Create(Meter:IMeasurement;
                      MM,R:TRadioGroup;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      TT:TTimer
                      );
end;



 TTheadSleep = class(TThread)
  protected
    FEventTerminate: THandle;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Terminate;
    procedure _Sleep(AMilliSeconds: Cardinal);
  end;

 TTheadCycle = class(TTheadSleep)
  private
  protected
    fEventPaused: TEvent;
    fPaused: Boolean;
//---------------------
    fInterval:int64;
    procedure DoSomething;virtual;
    procedure SetPaused(const Value: Boolean);
  public
    property Paused: Boolean read fPaused write SetPaused;
    constructor Create(Interval:double);
    procedure Execute; override;
    destructor Destroy; override;
  end;

  TMeasuringTreadSleep=class(TTheadSleep)
  private
   fWPARAM: word;
   fEventEnd:THandle;
   procedure NewData();
  protected
   fMeasurement:IMeasurement;
   procedure ExuteBegin;virtual;abstract;
   procedure Execute; override;
  public
   constructor Create(Meter:IMeasurement;WPARAM: word; EventEnd: THandle);
  end;



implementation

uses
  SysUtils, OlegType,Dialogs, Graphics,
  Forms, DateUtils, OlegFunction;

{ Simulator }

constructor TSimulator.Create;
begin
  Create('Simulation');
end;


constructor TSimulator.Create(name: string);
begin
 inherited Create();
 fName:=name;
end;

function TSimulator.GetNewData: boolean;
begin
 Result:=fNewData;
end;

function TSimulator.GetOutputValue: double;
begin
 Result:=fOutputValue;
end;

function TSimulator.GetDACKod: byte;
begin
 Result:=0;
end;

function TSimulator.GetData: double;
begin
// Result:=GetTickCount/1e7;
 Result:=fOutputValue;
// if (round(Result*10)=-(22)) then Result:=ErResult;

end;

procedure TSimulator.GetDataThread(WPARAM: word;EventEnd:THandle);
begin
 fValue:=GetTickCount/1e7;
 fNewData:=True;
 PostMessage(FindWindow ('TIVchar', 'IVchar'), WM_MyMeasure,WPARAM,0);
 SetEvent(EventEnd);
end;

function TSimulator.GetDeviceKod: byte;
begin
 result:=0;
end;

function TSimulator.GetTemperature: double;
begin
 fValue:=333.00;
 Result:=333.00;
 // Result:=Random(4000)/10.0;
end;

procedure TSimulator.GetTemperatureThread(EventEnd:THandle);
begin
 GetDataThread(TemperMessage,EventEnd);
end;

function TSimulator.GetValue: double;
begin
 Result:=fValue;
end;


procedure TSimulator.Output(Value: double);
begin
 fOutputValue:=Value;
end;


procedure TSimulator.OutputInt(Kod: integer);
begin
  fOutputValue:=Kod;
end;

procedure TSimulator.Reset;
begin

end;




procedure TSimulator.SetNewData(Value: boolean);
begin
 fNewData:=Value;
end;


{ TTheadPeriodic }

constructor TTheadSleep.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  Self.Priority := tpNormal;

  FEventTerminate := CreateEvent(nil, False, False, nil);
end;

destructor TTheadSleep.Destroy;
begin
  CloseHandle(FEventTerminate);
//  HelpForMe('TheadSleepDestroy'+inttostr(MilliSecond));
  inherited;
end;


procedure TTheadSleep.Terminate;
begin
  SetEvent(FEventTerminate);
  inherited Terminate;
end;

procedure TTheadSleep._Sleep(AMilliSeconds: Cardinal);
begin
 WaitForSingleObject(FEventTerminate, AMilliSeconds);
end;

{ TTheadCycle }

constructor TTheadCycle.Create(Interval: double);
begin
 fPaused := False;
 fEventPaused := TEvent.Create(nil, true, not fPaused, '');

 inherited Create();
 fInterval:=abs(round(1000*Interval));
end;

destructor TTheadCycle.Destroy;
begin
  Terminate;
  fEventPaused.SetEvent;
//  fEventPaused.WaitFor;
//  while not Self.Finished do // ����, ���� �� ����������
  while not Self.Terminated do // ����, ���� �� ����������
    Sleep(0);
  FreeAndNil(fEventPaused);

  inherited;
end;

procedure TTheadCycle.DoSomething;
begin

end;

procedure TTheadCycle.Execute;
var
  t: TDateTime;
  k: Int64;
begin
  while (not Terminated) and (not Application.Terminated) do
  begin
    fEventPaused.WaitFor(INFINITE);

    if (not Terminated) and (not Application.Terminated) then
    begin
    t := Now();
    DoSomething;
    k := fInterval - Round(MilliSecondSpan(Now(), t));
//    HelpForMe(inttostr(k)+'_'+inttostr(MilliSecond));
    if k>0 then
      begin
//       HelpForMe(inttostr(k)+'_'+inttostr(MilliSecond));
      _Sleep(k);
      end;
    end;
  end;
end;

procedure TTheadCycle.SetPaused(const Value: Boolean);
begin
  if (not Terminated) and (fPaused <> Value) then
  begin
    fPaused := Value;
    if fPaused then fEventPaused.ResetEvent
               else fEventPaused.SetEvent;
  end;
end;

{ TMeasuringTread }

constructor TMeasuringTreadSleep.Create(Meter: IMeasurement; WPARAM: word;
  EventEnd: THandle);
begin
  inherited Create();
  fMeasurement := Meter;
  fWPARAM:=WPARAM;
  fEventEnd:=EventEnd;
  Resume;
end;

procedure TMeasuringTreadSleep.Execute;
begin
 ExuteBegin;
 Synchronize(NewData);
 PostMessage(FindWindow ('TIVchar', 'IVchar'), WM_MyMeasure,fWPARAM,0);
 SetEvent(fEventEnd);
end;

procedure TMeasuringTreadSleep.NewData;
begin
  fMeasurement.NewData:=True;
end;

{ TMeasurementShow }

constructor TMeasurementShow.Create(Meter: IMeasurement;
                                    MM, R: TRadioGroup;
                                    DL, UL: TLabel;
                                    MB: TButton;
                                    AB: TSpeedButton; TT: TTimer);
begin
   inherited Create(Meter, DL, UL, MB, AB, TT);
   MeasureMode:=MM;
   Range:=R;
end;

procedure TMeasurementShow.IndexToRadioGroup(Index: ShortInt; RG: TRadioGroup);
begin
  try
   RG.ItemIndex:=Index;
  except
   RG.ItemIndex:=RG.Items.Count-1;
  end;
end;

procedure TMeasurementShow.StringArrayToRadioGroup(SA: array of string;
                                                   RG: TRadioGroup);
 var i:byte;
begin
    RG.Items.Clear;
    for I := 0 to High(SA) do RG.Items.Add(SA[i]);
end;

{ TMeasurementShowSimple }

procedure TMeasurementShowSimple.AutoSpeedButtonClick(Sender: TObject);
begin
 MeasurementButton.Enabled:=not(AutoSpeedButton.Down);
 if AutoSpeedButton.Down then Time.OnTimer:=MeasurementButton.OnClick;
 Time.Enabled:=AutoSpeedButton.Down;
end;

constructor TMeasurementShowSimple.Create(Meter: IMeasurement;
                                          DL, UL: TLabel;
                                          MB: TButton;
                                          AB: TSpeedButton;
                                          TT: TTimer
                                           );
begin
   inherited Create;
//   fMeter:=Meter;
   fMeter:=pointer(Meter);
   DataLabel:=DL;
   UnitLabel:=UL;
   MeasurementButton:=MB;
   AutoSpeedButton:=AB;
   Time:=TT;
   UnitLabel.Caption := '';
   MeasurementButton.OnClick:=MeasurementButtonClick;
   AutoSpeedButton.OnClick:=AutoSpeedButtonClick;
   fDigitNumber:=4;
end;

function TMeasurementShowSimple.GetMeter: IMeasurement;
begin
 Result:=IMeasurement(fMeter);
end;

procedure TMeasurementShowSimple.MeasurementButtonClick(Sender: TObject);
begin
 Meter.GetData();
 MetterDataShow();
end;

procedure TMeasurementShowSimple.MetterDataShow;
begin
  if Meter.Value<>ErResult then
     begin
       UnitLabel.Caption:=UnitModeLabel();
       DataLabel.Caption:=FloatToStrF(Meter.Value,ffExponent,fDigitNumber,2)
     end
                        else
     begin
       UnitLabel.Caption:='';
       DataLabel.Caption:='    ERROR';
     end;
end;

function TMeasurementShowSimple.UnitModeLabel: string;
begin
  Result:='';
end;

end.
