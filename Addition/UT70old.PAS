unit UT70;
                                 INTERFACE

Type
TComIndex=1..4;
TValue=(CUR,MAX,MIN,AVE); {тип для оценки того, что именно показывает
                           мультиметр: текущее значение (CUR), максимальное(MAX),
                           минимальное (MIN) или среднее(AVE)}
TUTType=(UTB, UTC);{возможные варианты мультиметров}

TCOMport = object
      BaseAdr : Word;
      Normal : Boolean;

      constructor Create(ComIndex : TComIndex; Speed : Longint; Params : Byte);
      {Инициализация порта с номером ComIndex                     }
      { ComIndex - номер порта                                    }
      { Speed     - скорость в бод                                }
      { Params   - конфигурация порта, согласно формату битов LCR }
      {Возвращает Normal=False, если порт не обнаружен            }

      Function ReadCOM : Byte;
      {Чтение байта с порта - чтение с базового адреса}

      Procedure WriteCOM(B : Byte);
      {Передача байта в порт - запись байта в базовый адрес}

      Function WriteData(B : Byte): Boolean;
     {Передает байт в порт с ожиданием готовности,
      ожидание происходит пока или флаг готовности
      приемника будет установлен, или пока не нажмется
      ESCAPE; во втором случае возвращается False}

      Function GetSR : Boolean;
      {Определение готовности передатчика -
      проверка состояния бита 5 по адресу BaseAdr+5}

      Function GetDR : Boolean;
      {Определение наличия принятых данных -
      проверка состояния бита 0 по адресу BaseAdr+5}

      Function GetErr : Byte;
      {Проверка наличия ошибок,
      проверяются состояние битов по адресу BaseAdr+5
      Бит 4 - обрыв линии
      Бит 3 - ошибка кадра (неверный стоп-бит)
      Бит 2 - ошибка четности
      Бит 1 - переполнение (потеря символа)
      возвращается байт, где скопировано состояние
      битов 1-4 из регистра, остальные - нулевые}

     Function ReadData(var B : Byte): Boolean;
    {Чтение байта с порта с ожиданием готовности порта,
    про ожидание см. WriteData}

      end;


TUT70C = object (TCOMport)
    kod:array [1..12] of byte;{информационная строка, которую
                               выдает мультиметр}
    X:single;  {чисельный результат измерений}
    Tp:char;   {тип измеряемой величины
              V - постоянное напряжение, больший диапазон
              v - постоянное напряжение, меньший диапазон
              W - переменное напряжение
              R - сопротивление
              S - проводимость
              P - прозвон сопротивления
              D - проверка диода
              С - емкость
              I - постоянный ток, большой диапазон
              i - постоянный ток, меньший диапазон
              J - переменный ток, больший диапазон
              j - переменный ток, меньший диапазон
              F - частота
              M - duty cycle}
    diap:0..7; {номер поддиапазона измерений}
    AUTO:Boolean;{True при автоматическом выборе диапазона
                измерений и FALSE при ручном}
    HOLD:Boolean; {TRUE при нажатой кнопке HOLD}
    REC :Boolean; {TRUE при выбраном режиме MAX-MIN}
    Value:TValue; {что именно сейчас на екране мультиметра,
                   см. описание типа TValue}
    ms1: Boolean; {TRUE при включении пикового детектора
                   (время накопления 1 мс) и FALSE при
                   времени накопления 100 мс или 1 с}
    OUT: Boolean; {TRUE при зашкаливании}
    NEG: Boolean; {TRUE при негативном значении на шкале}
    constructor Create(ComIndex : TComIndex);

    Procedure WriteState;
    {процедура вывода на экран полей объекта}

    Function ReadKod:Boolean;
    {заполнение поля kod новой информацией,
    с проверкой того, что первый байт равен коду команды,
    последний - 10, а число прочитаных байт 12}

    Function Vymir:Boolean;
    {получение даных от мультиметра и заполнение
    соответствующих полей}

    Function VymirData:single;
    {почти как предыдущая, только возвращается значение
    поля Х, а в случае неудачного измерения по какой-либо причине,
    в том числе и зашкала, издаются звуки}

    Function VymirDataPrec:single;
    {почти как предыдущая, только
    если выбран диапазон mV, то измерение проводится
    в режиме усреднения}

    Function PushButtom(B:byte):Boolean;
    {посылается байт В, считывается байт ответа,
    возвращается TRUE в случае когда байт принят
    успешно и его младшие 7 бит совпадают
    с битами посланого; рассматриваются 7 бит
    с учетом того, что можна ставить в настройках порта
    как 7 информационных бит, так и 8}

    Function PushPeak:Boolean;
    {нажатие кнопки Peak}

    Function PushHold:Boolean;
    {нажатие кнопки Hold}

     Function PushMaxMin:Boolean;
    {нажатие кнопки MaxMin}

    Function PushRange:Boolean;
    {нажатие кнопки Range}

    Function PushRel:Boolean;
    {нажатие кнопки Hold}

    Function PushHz:Boolean;
    {нажатие кнопки Hz}

    Function PushAcDc:Boolean;
    {нажатие кнопки AcDc}

    end;

TUT70B = object (TCOMport)
    kod:array [1..11] of byte;{информационная строка, которую
                               выдает мультиметр}
    X:single;  {чисельный результат измерений}
    Tp:char;   {тип измеряемой величины
              V - напряжение
              R - сопротивление
              P - прозвон сопротивления
              D - проверка диода
              С - емкость
              I - ток
              F - частота
              О - обороты
              Т - температура в градусах Цельсия
              G - температура в Фаренгейтах}
    diap:0..7; {номер поддиапазона измерений}
    AUTO:Boolean;{True при автоматическом выборе диапазона
                измерений и FALSE при ручном}
    AC  :Boolean; {TRUE при измерении переменного тока/напряжения,
                   FALSE при измерении постоянных величин,
                   а также тех, где нет такого деления}
    OUT: Boolean; {TRUE при зашкаливании}
    NEG: Boolean; {TRUE при негативном значении на шкале}
    constructor Create(ComIndex : TComIndex);

    Procedure WriteState;
    {процедура вывода на экран полей объекта}

    Function ReadKod:Boolean;
    {заполнение поля kod новой информацией,
    с разнообразными проверками правильности полученных
    данных}

    Function Vymir:Boolean;
    {получение даных от мультиметра и заполнение
    соответствующих полей}

    Function VymirData:single;
    {почти как предыдущая, только возвращается значение
    поля Х, а в случае неудачного измерения по какой-либо причине,
    в том числе и зашкала, издаются звуки}

    end;

                               IMPLEMENTATION
Uses Crt;

constructor TCOMport.Create(Comindex:TComIndex; Speed:Longint; Params:Byte);
      {Инициализация порта с номером ComIndex                     }
      { ComIndex - номер порта                                    }
      { Speed     - скорость в бод                                }
      { Params   - конфигурация порта, согласно формату битов LCR }
      {Возвращает Normal=False, если порт не обнаружен            }
var Freq,LowAdr : Word; FreqH, FreqL : Byte;
 begin
  Normal:=True;

  { вычисляем младшую часть адреса в таблице }
  LowAdr := (Comindex-1)*2;
  { получаем базовый адрес порта из таблицы }
  BaseAdr:= MemW[$0040:LowAdr];
  If BaseAdr = 0 then begin
   Normal:= False; {вернем ошибку}
   Exit;
  End;

  Freq := 115200 div Speed;
  FreqH:= Freq shr 8;
  FreqL:= Freq and $00FF;

  {Адресуем делитель порта с помощью установки DLAB=1}
  Port[BaseAdr+3]:= $80;
  {Устанавливаем младшую часть делителя}
  Port[BaseAdr+0]:= FreqL;
  {Устанавливаем старшую часть делителя}
  Port[BaseAdr+1]:= FreqH;
  {Сбрасываем DLAB и прописываем конфигурацию}
  Port[BaseAdr+3]:= Params;
end;

Function TComPort.ReadCOM : Byte; {assembler;
{Чтение байта с порта}
 begin
 ReadCom:=Port[BaseAdr]
{ Asm
  Mov Dx, BaseAdr
  In  Al, Dx}
 End;

Procedure TComPort.WriteCOM(B : Byte);
{Передача байта в порт}
 begin
 Port[BaseAdr]:=b;
 End;

 Function TComPort.WriteData(B : Byte): Boolean;
 {Передает байт в порт с ожиданием готовности,
 ожидание происходит пока или флаг готовности
 приемника будет установлен, или пока не нажмется
 ESCAPE; во втором случае возвращается False}
 Var Result,ESC : Boolean;
     i0:word;
 Begin
  Result:= False;ESC:=False;
  i0:=0;
   repeat
{   if KeyPressed then
       begin
       i0:=ord(ReadKey);
       if i0=0 then i0:=ord(ReadKey);
       if i0=27 then ESC:= True;
       end;}
    Inc(i0);
    if i0>4000 then ESC:= True;

   If GetSR then  {передатчик готов?}
   begin
    WriteCOM(B); {передаем байт}
    Result:= True;
   End;
   until (Result or ESC);
  WriteData:= Result;
 End;

Function TComPort.GetSR : Boolean; {assembler;
      {Определение готовности передатчика -
      проверка состояния бита 5 по адресу BaseAdr+5}
var b:byte;
begin
b:=Port[BaseAdr+5];
b:=b and $20;
GetSR:=(b>0);
{ Asm
  Mov Dx, BaseAdr
  Add Dx, 5
  In  Al, Dx
  And Al, 20H  {0010 0000b}
End;

Function TComPort.GetDR : Boolean; {assembler;
      {Определение наличия принятых данных -
      проверка состояния бита 0 по адресу BaseAdr+5}
var b:byte;
begin
b:=Port[BaseAdr+5];
b:=b and $01;
GetDR:=(b>0);
{ Asm
  Mov Dx, BaseAdr
  Add Dx, 5
  In  Al, Dx
  And Al, 1}
 End;

Function TComPort.GetErr : Byte; {assembler;
      {Проверка наличия ошибок,
      проверяются состояние битов по адресу BaseAdr+5
      Бит 4 - обрыв линии
      Бит 3 - ошибка кадра (неверный стоп-бит)
      Бит 2 - ошибка четности
      Бит 1 - переполнение (потеря символа)
      возвращается байт, где скопировано состояние
      битов 1-4 из регистра, остальные - нулевые}
var b:byte;
begin
b:=Port[BaseAdr+5];
GetErr:=b and $1E;

{ Asm
  Mov Dx, BaseAdr
  Add Dx, 5
  In  Al, Dx
  And Al, 1EH {0001 1110b}
 End;

Function TComPort.ReadData(var B : Byte): Boolean;
{Чтение байта с порта с ожиданием готовности порта,
про ожидание см. WriteData}
 Var Result, ESC : Boolean;
     i0:  integer;
 Begin
  Result:= False; ESC:= False;
  i0:=0;
   repeat
{ if KeyPressed then
       begin
       i0:=ord(ReadKey);
       if i0=0 then i0:=ord(ReadKey);
       if i0=27 then ESC:= True;
       end;}
{}    Inc(i0);
    if i0>40000 then ESC:= True;{}

   If GetDR then {проверяем доступность данных }
      begin
      B:= ReadCOM; {читаем байт с порта}
{      writeln(B);}
      Result:= (GetErr = 0); {проверяем код ошибки}
      End;

   until (Result or ESC);
ReadData:=Result;
{writeln(Esc);}
End;


constructor TUT70C.Create(ComIndex : TComIndex);
begin
TComPort.Create(ComIndex,9600,2);
  {установка сигнала DTR - показываем, что мы чего-то от
    внешнего устройства будем хотеть}
if Normal then  Port[BaseAdr+4]:= $01;
ReadCom; {удаляем то, что может находится
         в приемнике, например, при включении мультиметр
         передает нулевой байт}
end;

Procedure TUT70C.WriteState;
begin
writeln('value = ',x);
writeln('type of measuring - ',Tp);
write('current value - ');
case Value of
  CUR:writeln('Current');
  MAX:writeln('MAX');
  MIN:writeln('MIN');
  AVE:writeln('Average');
  end;
writeln('diapazon number - ',diap);
writeln('OUT = ',OUT);
writeln('NEG = ',NEG);
writeln('AUTO = ',AUTO);
writeln('HOLD = ',HOLD);
writeln('MAX-MIN = ',REC);
writeln('PEAK MIN-MAX = ',ms1);
end;

Function TUT70C.ReadKod:Boolean;
    {заполнение члена kod новой информацией,
    с проверкой того, что первый байт равен коду команды,
    последний - 10, а число прочитаных байт 12}
var bool:boolean;
    i:byte;
begin
ReadKod:=False;
repeat
ReadCom;
until not(GetDR);

bool:=WriteData(137);

if not(bool) then Exit;

for i:=1 to 12 do
  begin

  bool:=bool and ReadData(kod[i]);

  if not(bool) then Break;
  end;
bool:=bool and (i=12);
bool:=bool and (kod[12]=10);

for i:=1 to 5 do kod[i]:=(kod[i] and $7F);
bool:=bool and (kod[1]=9);
ReadKod:=bool;
end;

Function TUT70C.Vymir:Boolean;
    {получение даных от мультиметра и заполнение
    соответствующих полей}
var b:byte;
begin
Vymir:=False;
x:=555;

if not(ReadKod) then Exit;

b:=kod[3] and $07; {выделяем три последних бита}
case b of
    2:case kod[2] of
          120:Tp:='W';
          112:Tp:='V';
          104:Tp:='v';
           96:Tp:='R';
           88:Tp:='D';
           40:Tp:='I';
           41:Tp:='J';
           48:Tp:='i';
           49:Tp:='j';
         else Exit;
         end; {case kod[2]}
     0: if kod[2]=97 then Tp:='C' else Exit;
     4: if (kod[2] in [120,112,104,40,41,48,49])
            then Tp:='F' else Exit;
     5: if (kod[2] in [120,112,104,40,41,48,49])
            then Tp:='M' else Exit;
     else Exit;
     end {case b of};

REC:=((kod[4] and $40)>0);
AUTO:= ((kod[3] and $40)=0);
NEG:=((kod[5] and $10)>0);
OUT:=((kod[5] and $08)>0);
HOLD:=((kod[5] and $01)>0);

b:=(kod[4] and $04); {выделяем бит 2}
if (b>0) and (Tp='R') then Tp:='P';
ms1:=((b>0) and REC);


b:=kod[3];
diap:=((b shr 3) and $07);

if (diap=6)and(Tp='R') then Tp:='S';

if REC then
  begin
    b:=kod[4];
    b:=((b shr 3) and $03);
    if ms1 then
       case b of
        0:Value:=MAX;
        1:Value:=MIN;
        end{case b of}
          else
       case b of
        0:Value:=CUR;
        1:Value:=MAX;
        2:Value:=MIN;
        3:Value:=AVE;
        end;
  end
      else Value:=CUR;

if OUT then Exit;

x:=(kod[10]and$0F)+10*(kod[9]and$0F)+100*(kod[8]and$0F)+1000*(kod[7]and$0F);
if (Tp='F')and((kod[6]and$0F)<10) then x:=x+10000*(kod[6]and$0F);

case Tp of
 'W':case diap of
     0:x:=x*1e-4;
     1:x:=x*1e-3;
     2:x:=x*1e-2;
     3:x:=x*1e-1;
     4:;
     else Exit;
     end;
  'V':case diap of
     0:x:=x*1e-3;
     1:x:=x*1e-2;
     2:x:=x*1e-1;
     3:;
     else Exit;
     end;
  'v':case diap of
     0:x:=x*1e-5;
     1:x:=x*1e-4;
     2:;
     else Exit;
     end;
  'R':case diap of
     0:x:=x*1e-1;
     1:;
     2:x:=x*1e1;
     3:x:=x*1e2;
     4:x:=x*1e3;
     5:x:=x*1e4;
     else Exit;
     end;
  'S':case diap of
     6:x:=x*1e-11;
     else Exit;
     end;
  'C':case diap of
     0:x:=x*1e-12;
     1:x:=x*1e-11;
     2:x:=x*1e-10;
     3:x:=x*1e-9;
     4:x:=x*1e-8;
     5:x:=x*1e-7;
     else Exit;
     end;
  'I':case diap of
     0:x:=x*1e-3;
     1:x:=x*1e-2;
     else Exit;
     end;
  'J':case diap of
     0:x:=x*1e-3;
     1:x:=x*1e-2;
     else Exit;
     end;
  'i':case diap of
     0:x:=x*1e-5;
     1:x:=x*1e-4;
     else Exit;
     end;
  'j':case diap of
     0:x:=x*1e-5;
     1:x:=x*1e-4;
     else Exit;
     end;
  'F':case diap of
     0:x:=x*1e-2;
     1:x:=x*1e-1;
     2:;
     3:x:=x*1e1;
     else Exit;
     end;
  'M':x:=x*1e-2;
 end;{case Tp of}
if NEG then x:=-1*x;
Vymir:=true;
end;

Function TUT70C.VymirData:single;
    {почти как предыдущая, только возвращается значение
    поля Х, а в случае неудачного измерения по какой-либо причине,
    в том числе и зашкала, издаются звуки}
begin
if not(Vymir) then
  begin
  sound(300);
  delay(500);
  nosound;
  end;
VymirData:=X;
end;

Function TUT70C.VymirDataPrec:single;
    {почти как предыдущая, только
    если выбран диапазон mV, то измерение проводится
    в режиме усреднения}
begin
Vymir;
if Tp<>'v' then {проверка режима}
  begin
  delay(20);
 VymirDataPrec:=VymirData;
 Exit;
  end;

PushRange; {сброс данных с памяти}
Vymir;
while diap<>1 do {перевод в диапазон до 800мВ}
 begin;
 PushRange;
 Vymir;
 end;
PushMaxMin;
while Value<>Ave do {перевод в режим индикации среднего}
 begin
 PushMaxMin;
 Vymir;
 end;
delay(3000); {накопление измерений}
VymirDataPrec:=VymirData;
end;


Function TUT70C.PushButtom(B:byte):Boolean;
    {посылается байт В, считывается байт ответа,
    возвращается TRUE в случае когда байт принят
    успешно и его младшие 7 бит совпадают
    с битами посланого; рассматриваются 7 бит
    с учетом того, что можна ставить в настройках порта
    как 7 информационных бит, так и 8}
var bt:byte;
    bool:boolean;
begin
delay(30);
bool:=WriteData(b);
bool:=bool and ReadData(bt);
PushButtom:=((bt and $7F)=(b and $7F)) and bool;
delay(30);
end;

Function TUT70C.PushPeak:Boolean;
    {нажатие кнопки Peak}
begin
PushPeak:=PushButtom(171);
end;

Function TUT70C.PushHold:Boolean;
    {нажатие кнопки Hold}
begin
PushHold:=PushButtom(165);
end;

Function TUT70C.PushMaxMin:Boolean;
    {нажатие кнопки MaxMin}
begin
PushMaxMin:=PushButtom(169);
end;

Function TUT70C.PushRange:Boolean;
    {нажатие кнопки Range}
begin
PushRange:=PushButtom(161);
end;

Function TUT70C.PushRel:Boolean;
    {нажатие кнопки Hold}
begin
PushRel:=PushButtom(167);
end;

Function TUT70C.PushHz:Boolean;
    {нажатие кнопки Hz}
begin
PushHz:=PushButtom(163);
end;

Function TUT70C.PushAcDc:Boolean;
    {нажатие кнопки AcDc}
begin
PushAcDc:=PushButtom(173);
end;

constructor TUT70B.Create(ComIndex : TComIndex);
begin
TComPort.Create(ComIndex,2400,10);
ReadCom; {удаляем то, что может находится
         в приемнике, например, при включении мультиметр
         передает нулевой байт}
{  Port[BaseAdr+4]:= $01;{}
end;

Procedure TUT70B.WriteState;
begin
writeln('value = ',x);
writeln('type of measuring - ',Tp);
writeln('diapazon number - ',diap);
writeln('OUT = ',OUT);
writeln('NEG = ',NEG);
writeln('AUTO = ',AUTO);
writeln('AC = ',AC);
end;

Function TUT70B.ReadKod:Boolean;
    {заполнение члена kod новой информацией,
    с разнообразными проверками}
var bool:boolean;
    i,j:byte;
    temp:array [1..22] of byte;
begin
ReadKod:=False;
j:=0;

   bool:=True;
   ReadCom;

Port[BaseAdr+4]:= $01;
   for i:=1 to 22 do
    begin
{     writeln(bool);}
     bool:=bool and ReadData(temp[i]);
     if not(bool) then Break;
    end;
{} Port[BaseAdr+4]:= $00;{}
bool:=bool and (i=22);
if not(bool) then Exit;


bool:=false;
for i:=1 to 10 do
  if temp[i]=13 then
     begin
     bool:=true;
     for j:=1 to 11 do kod[j]:=temp[i+1+j];
     break;
     end;

if not(bool) then Exit;

bool:=bool and (kod[11]=10) and (kod[10]=13) and (kod[8]=48);

for i:=1 to 9 do bool:=bool and ((kod[i] shr 4)=3);
{в первых 9 байтах старшие 4 бита всегда должны быть 0011}
for i:=1 to 9 do kod[i]:=(kod[i] and $0F);
{зануляем старшие 4 бита, все равно вся полезная информация
в младших}
{for i:=1 to 11 do write(kod[i],' ');
writeln;}
ReadKod:=bool;
end;

Function TUT70B.Vymir:Boolean;
    {получение даных от мультиметра и заполнение
    соответствующих полей}
var b:byte;
begin
Vymir:=False;
x:=555;

if not(ReadKod) then Exit;

b:=(kod[7] shr 3)and $01; {выделяем бит 3}

case kod[6] of
    15,9,13:Tp:='I';
          4:if (b=1) then Tp:='T' else Tp:='G';
          2:if (b=1) then Tp:='O' else Tp:='F';
          6:Tp:='C';
          1:Tp:='D';
          3:Tp:='R';
          5:Tp:='P';
         11:Tp:='V';
     else Exit;
     end {case b of};

AC:=((kod[9] and 4)>0);
AUTO:= ((kod[9] and 2)>0);
NEG:=((kod[7] and 4)>0);
OUT:=((kod[7] and 1)>0);


diap:=(kod[1] and 7);

if OUT then Exit;

x:=(kod[5]and$0F)+10*(kod[4]and$0F)+100*(kod[3]and$0F)+1000*(kod[2]and$0F);

case Tp of
 'V':case diap of
     0:x:=x*1e-4;
     1:x:=x*1e-3;
     2:x:=x*1e-2;
     3:x:=x*1e-1;
     4:;
     else Exit;
     end;
  'R':case diap of
     0:x:=x*1e-1;
     1:x:=x;
     2:x:=x*1e1;
     3:x:=x*1e2;
     4:x:=x*1e3;
     5:x:=x*1e4;
     else Exit;
     end;
  'P','D':if diap=0 then x:=x*1e-1 else Exit;
  'C':case diap of
     0:x:=x*1e-12;
     1:x:=x*1e-11;
     2:x:=x*1e-10;
     3:x:=x*1e-9;
     4:x:=x*1e-8;
     5:x:=x*1e-7;
     6:x:=x*1e-6;
     7:x:=x*1e-5
     else Exit;
     end;
  'F':case diap of
     0:;
     1:x:=x*1;
     2:x:=x*2;
     3:x:=x*3;
     4:x:=x*4;
     5:x:=x*5;
     else Exit;
     end;
  'O':x:=x*0.01;
  'T','F':;
  'I':case diap of
     0:case kod[6] of
       15:x:=x*1e-2;
        9:x:=x*1e-5;
       13:x:=x*1e-7;
       else Exit;
       end; {case kod[6] of}
     1:case kod[6] of
        9:x:=x*1e-4;
       13:x:=x*1e-6;
       else Exit;
       end; {case kod[6] of}
     else Exit;
     end; {case diap}
 end;{case Tp of}
if NEG then x:=-1*x;
Vymir:=true;
end;

Function TUT70B.VymirData:single;
    {почти как предыдущая, только возвращается значение
    поля Х, а в случае неудачного измерения по какой-либо причине,
    в том числе и зашкала, издаются звуки}
begin
if not(Vymir) then
  begin
{  sound(300);
  delay(500);
  nosound;}
  end;
VymirData:=X;
end;

END.
