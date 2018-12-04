unit Measurement;

interface

uses
  StdCtrls, IniFiles, Messages, Classes, ExtCtrls, Buttons;

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

type

IName = interface
  ['{5B51E68D-11D9-4410-8396-05DB50F07F35}']
  function GetName:string;
  property Name:string read GetName;
end;

TNamedInterfacedObject=class(TInterfacedObject)
  protected
   fName:string;
   function GetName:string;
  public
   property Name:string read GetName;
  end;

IMeasurement = interface (IName)
  ['{7A6DCE4C-9A04-444A-B7FD-39B800BDE6A7}']
 function GetNewData:boolean;
 function GetValue:double;
 function GetData:double;
 procedure SetNewData(Value:boolean);
 procedure GetDataThread(WPARAM: word; EventEnd:THandle);
 property NewData:boolean read GetNewData write SetNewData;
 property Value:double read GetValue;
end;

IDAC = interface (IName)
  ['{F729B2E9-AF49-4293-873B-83D53C258E0A}']
 function GetOutputValue:double;
 procedure Output(Value:double);
 {���������� �� ����� ������� Value}
 procedure OutputInt(Kod:integer);
 {���������� �� ����� �������, ��� ������� Kod}
 Procedure Reset();
 {���������� �� ����� 0}
 property OutputValue:double read GetOutputValue;
end;

ICalibration = interface
  ['{88FD380C-1EA7-4EC5-B2C8-1C463E92A625}']
 function CalibrationStep(Voltage:double):double;
 {������� ���� ��� �������� ����������� ������� �� �������� ������� Voltage}
 procedure OutputCalibr(Value:double);
 {���������� �� ����� ������� Value �� ��� �����������}
end;


ITemperatureMeasurement = interface (IMeasurement)
  ['{DDC24597-B316-4E8B-B246-1DDD0B4D5E5D}']
  function GetTemperature:double;
  procedure GetTemperatureThread(EventEnd:THandle);
end;



TSimulator = class (TInterfacedObject,IMeasurement,IDAC,ITemperatureMeasurement)
private
 FName: string;
 fValue:double;
 fNewData:boolean;
 fOutputValue:double;
 function GetName:string;
 function GetNewData:boolean;
 function GetValue:double;
 function GetOutputValue:double;
 procedure SetNewData(Value:boolean);
public
 property Name:string read GetName;
 property Value:double read GetValue;
 property NewData:boolean read GetNewData write SetNewData;
 property OutputValue:double read GetOutputValue;
 Constructor Create();overload;
 Constructor Create(name:string);overload;
 function GetTemperature:double;
 function GetData:double;
 procedure Output(Value:double);
 Procedure Reset();
 procedure OutputInt(Kod:integer);
 procedure GetDataThread(WPARAM: word;EventEnd:THandle);
 procedure GetTemperatureThread(EventEnd:THandle);
 procedure Free;
end;


TMeasurementShow=class
  protected
   fMeter:IMeasurement;
   MeasureMode,Range:TRadioGroup;
   DataLabel,UnitLabel:TLabel;
   MeasurementButton:TButton;
   Time:TTimer;
   procedure MeasurementButtonClick(Sender: TObject);
   procedure AutoSpeedButtonClick(Sender: TObject);
   procedure StringArrayToRadioGroup(SA:array of string;
                                     RG:TRadioGroup);
   procedure IndexToRadioGroup(Index:ShortInt;RG:TRadioGroup);
   function UnitModeLabel():string;virtual;
  public
   AutoSpeedButton:TSpeedButton;
   Constructor Create(Meter:IMeasurement;
                      MM,R:TRadioGroup;
                      DL,UL:TLabel;
                      MB:TButton;
                      AB:TSpeedButton;
                      TT:TTimer
                      );
   procedure MetterDataShow();virtual;
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
    fInterval:int64;
    procedure DoSomething;virtual;
  public
    constructor Create(Interval:double);
    procedure Execute; override;
  end;

  TMeasuringTread=class(TTheadSleep)
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
  SysUtils, OlegType,Dialogs, Graphics, Windows, Forms, DateUtils;

{ Simulator }

constructor TSimulator.Create;
begin
  inherited Create;
  fName:='Simulation';
end;


constructor TSimulator.Create(name: string);
begin
 inherited Create();
 fName:=name;
end;

procedure TSimulator.Free;
begin

end;

function TSimulator.GetName: string;
begin
  Result:=fName;
end;

function TSimulator.GetNewData: boolean;
begin
 Result:=fNewData;
end;

function TSimulator.GetOutputValue: double;
begin
 Result:=fOutputValue;
end;

function TSimulator.GetData: double;
begin
 Result:=GetTickCount/1e7;
end;

procedure TSimulator.GetDataThread(WPARAM: word;EventEnd:THandle);
begin
 fValue:=GetTickCount/1e7;
 fNewData:=True;
 PostMessage(FindWindow ('TIVchar', 'IVchar'), WM_MyMeasure,WPARAM,0);
 SetEvent(EventEnd);
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


{ TNamedDevice }

function TNamedInterfacedObject.GetName: string;
begin
   Result:=fName;
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
 inherited Create();
 fInterval:=abs(round(1000*Interval));
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
    t := Now();
    DoSomething;
    k := fInterval - Round(MilliSecondSpan(Now(), t));
    if k>0 then
      _Sleep(k);
  end;
end;

{ TMeasuringTread }

constructor TMeasuringTread.Create(Meter: IMeasurement; WPARAM: word;
  EventEnd: THandle);
begin
  inherited Create();
  fMeasurement := Meter;
  fWPARAM:=WPARAM;
  fEventEnd:=EventEnd;
  Resume;
end;

procedure TMeasuringTread.Execute;
begin
 ExuteBegin;
 Synchronize(NewData);
 PostMessage(FindWindow ('TIVchar', 'IVchar'), WM_MyMeasure,fWPARAM,0);
 SetEvent(fEventEnd);
end;

procedure TMeasuringTread.NewData;
begin
  fMeasurement.NewData:=True;
end;

{ TMeasurementShow }

procedure TMeasurementShow.AutoSpeedButtonClick(Sender: TObject);
begin
 MeasurementButton.Enabled:=not(AutoSpeedButton.Down);
 if AutoSpeedButton.Down then Time.OnTimer:=MeasurementButton.OnClick;
 Time.Enabled:=AutoSpeedButton.Down;
end;

constructor TMeasurementShow.Create(Meter: IMeasurement;
                                    MM, R: TRadioGroup;
                                    DL, UL: TLabel;
                                    MB: TButton;
                                    AB: TSpeedButton; TT: TTimer);
begin
   inherited Create;
   fMeter:=Meter;
   MeasureMode:=MM;
   Range:=R;
   DataLabel:=DL;
   UnitLabel:=UL;
   MeasurementButton:=MB;
   AutoSpeedButton:=AB;
   Time:=TT;
   UnitLabel.Caption := '';
   MeasurementButton.OnClick:=MeasurementButtonClick;
   AutoSpeedButton.OnClick:=AutoSpeedButtonClick;
end;

procedure TMeasurementShow.IndexToRadioGroup(Index: ShortInt; RG: TRadioGroup);
begin
  try
   RG.ItemIndex:=Index;
  except
   RG.ItemIndex:=RG.Items.Count-1;
  end;
end;

procedure TMeasurementShow.MeasurementButtonClick(Sender: TObject);
begin
 fMeter.GetData();
 MetterDataShow();
end;

procedure TMeasurementShow.MetterDataShow;
begin

  if fMeter.Value<>ErResult then
     begin
       UnitLabel.Caption:=UnitModeLabel();
       DataLabel.Caption:=FloatToStrF(fMeter.Value,ffExponent,4,2)
     end
                        else
     begin
       UnitLabel.Caption:='';
       DataLabel.Caption:='    ERROR';
     end;

end;

procedure TMeasurementShow.StringArrayToRadioGroup(SA: array of string;
                                                   RG: TRadioGroup);
 var i:byte;
begin
    RG.Items.Clear;
    for I := 0 to High(SA) do RG.Items.Add(SA[i]);
end;

function TMeasurementShow.UnitModeLabel: string;
begin
 Result:='';
end;

end.
