unit HighResolutionTimer;
{стягнув з http://expert.delphi.int.ru/question/5313/}

interface
 
uses Windows;
 
type
  // --------------------- Класс - высокоточный таймер -------------------------
  THRTimer = class(TObject)
    constructor Create;
    function StartTimer: Boolean; // Обнуление таймера
    function ReadTimer: Double;   // Чтение значения таймера в миллисекундах
  private
    StartTime: Double;
    ClockRate: Double;
  public
    Exists: Boolean;    // Флаг успешного создания таймера
  end;

  TSecondMeter= class
    private
     fInterval:double;
     fStartValue,fEndValue,fFreq:Int64;
     constructor Create;
    public
     property Interval:double read fInterval;
     procedure Start();
     function Finish:double;
  end;


function MilliSecondFromDayBegining:Int64;overload;
{повертає кількість мілісекунд з початку доби}

function MilliSecondFromDayBegining(ttime: TDateTime):Int64;overload;


var
  Timer: THRTimer; // Глобальая переменная. Создаётся при запуске программы
  SecondMeter:TSecondMeter;
  Info:string;


{ Фукнция высокоточной задержки.
 Delphi:
   Синтаксис: function HRDelay(const Milliseconds: Double): Double;
   Milliseconds: Double - задержка в миллисекундах (может быть дробной)
   Результат функции - фактически произошедшая задержка с погрешностью.
   Пример вызова функции: X:= HRDelay(100.0); или HRDelay(100.0);
}
function HRDelay(const Milliseconds: Double): Double;
 
implementation

uses
  SysUtils;
 
function HRDelay(const Milliseconds: Double): Double;
begin
  Timer.StartTimer();
  repeat
    Result:= Timer.ReadTimer();
  until Result >= Milliseconds;
end;
 
{ THRTimer }
 
constructor THRTimer.Create;
var
  QW: LARGE_INTEGER;
begin
  inherited Create;
  Exists := QueryPerformanceFrequency(Int64(QW));
  ClockRate := QW.QuadPart;
end;
 
function THRTimer.StartTimer: Boolean;
var
  QW: LARGE_INTEGER;
begin
  Result := QueryPerformanceCounter(Int64(QW));
  StartTime := QW.QuadPart;
end;
 
function THRTimer.ReadTimer: Double;
var
  ET: LARGE_INTEGER;
begin
  QueryPerformanceCounter(Int64(ET));
  Result := 1000.0 * (ET.QuadPart - StartTime) / ClockRate;
end;
 
{ TSecondMeter }

constructor TSecondMeter.Create;
begin
 inherited Create;
 QueryPerformanceFrequency(fFreq);
 fInterval:=0;
end;

function TSecondMeter.Finish: double;
begin
 QueryPerformanceCounter(fEndValue);
 fInterval:=(fEndValue-fStartValue)/fFreq;
 Result:=fInterval;
end;

procedure TSecondMeter.Start;
begin
 QueryPerformanceCounter(fStartValue);
end;


function MilliSecondFromDayBegining:Int64;overload;
{повертає кількість мілісекунд з початку доби}
begin
 Result:=MilliSecondFromDayBegining(Time);
end;

function MilliSecondFromDayBegining(ttime: TDateTime):Int64;overload;
 var Hour,Min,Sec,MSec:word;
begin
 DecodeTime(ttime,Hour,Min,Sec,MSec);
 Result:=MSec+1000*(Sec+60*(Min+60*Hour));
end;

initialization
  Timer:= THRTimer.Create();
  SecondMeter:=TSecondMeter.Create();
 
finalization
  Timer.Free();
  SecondMeter.Free;
end.
