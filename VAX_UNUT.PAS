{$S+}
unit VAX_UnUT;
interface
uses Oleg,Crt,Graph,Dos,ADA1292,UT70B,RS232Dos,UT70;

Type  TSingle5=array[1..5] of single;
      {всего сопротивлени 5, поэтому
      разные величины, характерные для измерений
      при разных подключенных сопротивлениях удобно
      хранить именно в таких массивах}

      TVaxParam = record {тип для сохранения параметров
                          измерения ВАХ}
                delU:Tsingle5; {модуль шага по напряжению,
зависит от величины напряжения, вообще-то количество поддиапазонов
на оси напряжений, где шаг разный не обязательно должно было быть равным
пяти, но так уж выбрали; границы диапазонов см. в константах DiapFor и DiapRev}
                U0:single;     {начальное напряжение, от которого
                                начинается измерение ВАХ}
                Um:single;     {конечное напряжение при измерении ВАХ}
                time:word;     {время между соседними измерениями}
                end;

      TUT = record
           Name:TUTType;   {тип мультиметра}
           Port:TComIndex; {номер порта, к которому он подключен}
           end;

      TSerPar=record {тип для хранения параметров серийного измерения}
          time   :boolean;  {TRUE - критерий время, FALSE - температура}
          delTime:byte;   {шаг по времени между соседними измерениями, мин}
          delT   :single;   {шаг по температуре между соседними измерениями, К}
          end;

      TAllParam = record {тип для сохранения всех параметров
                          измерений}
                Forw   :TVaxParam;{параметры измерения прямой ВАХ}
                Rev    :TVaxParam;{параметры измерения обратной ВАХ}
                Upop   :TSingle5; {поправочные коэффициенты для измерения
                                   напряжения, связанного с током через
                                   образец зависят от
                                   подключенного сопротивления}
                UUpop  :TSingle5; {поправочные коэффициенты для задания
                                   напряжения на образце, зависят от
                                   подключенного сопротивления}
                Kan1   :TUT;      {параметры мультиметра, подключенного
                                   к каналу измерения напряжения}
                Kan2   :TUT;      {параметры мультиметра, подключенного
                                   к каналу измерения тока}
                SC_Reg :Boolean;  {TRUE - режим измерения ВАХ для диода
Шотки, когда поправочные коэффициенты считаются при каждом изменение
подключенного сопротивления;
                                   FALSE - использываются поправочные
коэффициенты из поля Upop}
                IV_Reg :Boolean;  {TRUE - аналог режима ВАХ,
                                   FALSE - аналог режима ВАХ-2}
                Tem_Reg:Word;     {способ измерения температуры,
возможные значения: 1 -  вольтметр В7-21, ручной ввод показаний
                    2 - термопара с усилителем
                    3 - мультиметр UT70B
                    4 - термодатчик AD22100
                    5 - вольтметр В7-21А, автоматическое
                        считывание показаний
                    6 - не измеряется}
                 SerPar:TSerPar;{параметры серийного измерения}
                end;
      PAllParam=^TAllParam;

      MenuDraw = object {помогает рисовать меню,
                 работает при включенном графическом режиме}
          Row: Word;{координата, где будет выводится следующая строка}
          dRow:Word; {расстояние между соседними строчками}
          procedure Init;
          {некоторые исходные операции, в том числе очистка екрана}
          procedure Title(s:string);
          {выводит s как заголовок меню}
          procedure AddItem(s:string);
          {добавляет на екран еще один пункт меню с текстом s}
          procedure LineMenu;
          {проводит горизонтальную линию}
          procedure AddSubTitle(s:string);
          {выводит s красным, более смещенным к центру}
          end;

      PtSngl=array[1..5] of single;
      Vax_parA=record
                U0,delU:PtSngl;
                Up,Um:single;
                popr:Kalb;
                time:word;
                end;
       PVax_parA=^Vax_parA;

VAR     Par:PAllParam;
        SR:SearchRec;
        MD:MenuDraw;
        UNITC:TUT70C;
        UNITB:TUT70B;
        Popr:PKalb;
        Tsample:single;
        Tvymir:integer;

CONST
        Katalog='d:\oleg\bp\exe\temp\';
        {каталог для хранения файлов с параметрами}
        parfile='vax_UT.dat';
        {имя файла для хранения параметров}
        Ruse:Ptsngl=(10450000,994000,101100,995,100.5);
        {значения сопротивлений}
        DiapFor:TSingle5=(0.5,1,2,3,5);
        {правые границы диапазонов, в которых
        значение шага по напряжению может менятся при
        измерении прямых ВАХ}
        DiapRev:TSingle5=(-0.15,-1,-2,-3,-5);
        {левые границы диапазонов, в которых
        значение шага по напряжению может менятся при
        измерении обратных ВАХ}
        color:array [1..2] of word=
             (lightblue,lightcyan);
        {цвета, которые используются для различия
        прямой и обратной характеристик}

        Imin=4e-10;
        Rs=0.8;{2.6 - z katushkami}

Procedure Initialization;
{запускается в самом начале, включает различные инициализации,
считывание значений параметров}

Procedure Final;
{выполняется в конце программы измерения ВАХ,
сборщик всякого мусора}

Function MeasureUU:Single;
{измерение напряжения на образце,
если результат 555, то ошибка}

Function MeasureUI:Single;
{измерение напряжения, связанного с током
через образец,
если результат 555, то ошибка}

Function B721AVym:single;
{считывание показаний с вольтметр В7-21А, в микровольтах}

Function TempDeterm(a:single):Single;
{измерение температуры,
а - напряжение на термопаре Cu-Ko,
необходимо если выбран режим ручного ввода
значений и вольтметра, для остальных
режимов может быть любым}

Function ErrorUT70(UT:TUT):string;
{проверка правильности включения
мультиметра, а именно того, что
данные с него читаются, что установлен
режим измерения постоянного напряжения,
что диапазон выбирается автоматически;
при ошибках возвращается соответствующая
строка, если все хорошо, то строка пустая}

Procedure ParWrite(fname:string; a:TAllParam);
{запись в файл с именем fname данных из а}

Procedure ParRead(fname:string; var a:TAllParam);
{чтение из файл с именем fname данных в а;
если файл отсутствует заполняется параметрами по умолчанию;
если файл имеет неправильный формат никаких проверок
не проводится}

Function FunReadKey:byte;
{возвращает код нажатой клавищи, причем
если нажат ESC возвратится 27,
если функциональная клавиша F1, F2, F3...,
то возвратится              59, 60, 61...,
для не функциональных клавиш визвратится 0}

Procedure MenuSetup;

Procedure MenuDiodPosition;

Procedure MenuTypeMeasur;

Procedure MenuMeasurPar(znak:byte);

Procedure MenuTemper;

Procedure Popravka(mode:byte;a0:single);
{производится определение поправочных
коефициентов - значений Par^.Upop[mode] и
Par^.UUpop[mode];
а0 - начальное приближение для Par^.UUpop[mode]}

Procedure ReferPoint;

Procedure IVMeasure;

Procedure MenuADC;

Procedure MenuSerial;

Function MTime:longint;
{возвращает число секунд текущего времени}

Procedure TimeLabel;
{процедура запису у файл 'comments'
вiдмiтки про час цього запису}

{====================================}

Procedure Kalibrovka;

Procedure Progrev;

Procedure Opir (i:byte);

Procedure VaxParam(a:Pvector;sfile:string;T:single);


{Procedure Melody;{}

implementation

Procedure Melody;
begin
sound(700);
delay(100);
nosound;
sound(200);
delay(100);
nosound;
sound(500);
delay(100);
nosound
end;

Procedure Mel;
begin
sound(100);
delay(50);
nosound;
end;

Procedure ErrorWindow(Comment:string);
{виводит окно с мигающей надписью "Error",
и неподвижной Comment, пищит, убирается нажатием
любой клавиши}
const s='ERROR';
var i0:byte;
begin
MD.Init;
i0:=1;
{MD.Row:=350;
MD.AddItem('      press any key');}
MD.Row:=180;
SetColor(yellow);
MD.AddItem(Comment);
repeat
   setcolor(LightRed);
   OutTextXY(250,50,s);
   sound(700);
   delay(200);
   setcolor(GetBkColor);
   OutTextXY(250,50,s);
   nosound;
   delay(200);
   Inc(i0);
until (i0>5);
{i0:=ord(ReadKey);
if i0=0 then i0:=ord(ReadKey);}
end;
{----------------------------------------------------------------------}

Procedure MenuDraw.Init;
begin
Row:=50;
dRoW:=50;
ClearDevice;
setcolor(green);
end;
{----------------------------------------------------------------------}

procedure MenuDraw.Title(s:string);
          {выводит s как заголовок меню}
begin
SetTextStyle(DefaultFont,HorizDir,3);
setcolor(magenta);
OutTextXY(100,Row,s);
SetTextStyle(DefaultFont,HorizDir,2);
setcolor(green);
Row:=Row+dRow;
end;
{----------------------------------------------------------------------}

procedure MenuDraw.AddItem(s:string);
          {добавляет на екран еще один пункт меню с текстом s}
begin
OutTextXY(50,Row,s);
Row:=Row+dRow;
end;
{----------------------------------------------------------------------}

procedure MenuDraw.LineMenu;
      {проводит горизонтальную линию}
begin
  Row:=Row-30;
  Line(0,Row,GetMaxX,Row);
  Row:=Row+30;
end;
{----------------------------------------------------------------------}
Procedure MenuDraw.AddSubTitle(s:string);
         {выводит s красным, более смещенным к центру}
begin
   SetColor(lightred);
   OutTextXY(100,Row,s);
   setcolor(green);
   Row:=Row+dRow;
end;
{----------------------------------------------------------------------}

Procedure Initialization;
{запускается в самом начале, включает различные инициализации,
считывание значений параметров}
begin
BeginingADA;
NaprugaADA(0);
Opir(1);
new(Par);
new(Popr);
ParRead(parfile,Par^);
ReadKalbr(Popr);
Tsample:=0;
Tvymir:=0;
if Par^.Kan1.Name=UTB then UNITB.Create(Par^.Kan1.Port)
                      else UNITC.Create(Par^.Kan1.Port);
if Par^.Kan2.Name=UTB then UNITB.Create(Par^.Kan2.Port)
                      else UNITC.Create(Par^.Kan2.Port);
MyInitGraph;
SetTextStyle(DefaultFont,HorizDir,2);
SetTextJustify(LeftText,CenterText);
SetLineStyle(0,0,3);
end;
{----------------------------------------------------------------------}

Procedure Final;
{выполняется в конце программы измерения ВАХ,
сборщик всякого мусора}
begin
{ParWrite(parfile,Par^);}
dispose(Par);
dispose(Popr);
CloseGraph;
end;
{----------------------------------------------------------------------}

Function MeasureUU:Single;
{измерение напряжения на образце,
если результат 555, то ошибка}
begin
if Par^.Kan1.Name=UTB then MeasureUU:=UNITB.VymirData
                      else MeasureUU:=UNITC.VymirData;
{if MeasureUU=555 then
 begin
 if Par^.Kan1.Name=UTB then MeasureUU:=UNITB.VymirData
                       else MeasureUU:=UNITC.VymirData;
 end;}
end;
{----------------------------------------------------------------------}

Function MeasureUI:Single;
{измерение напряжения, связанного с током
через образец,
если результат 555, то ошибка}
begin
if Par^.Kan2.Name=UTB then MeasureUI:=UNITB.VymirData
                      else MeasureUI:=UNITC.VymirData;
{if MeasureUI=555 then
 begin
 if Par^.Kan2.Name=UTB then MeasureUI:=UNITB.VymirData
                       else MeasureUI:=UNITC.VymirData;
 end;{}
end;
{----------------------------------------------------------------------}

Function B721A:integer;
const min=0.2;
var c1:array[1..4] of single;
    c2:array[1..4] of byte;
    i:byte;
    bool:boolean;
    a:integer;
begin
repeat
 for i:=1 to 4 do c2[i]:=55;
 c1[1]:=VumirADA (1,6);
 c1[2]:=VumirADA (1,12);
 c1[3]:=VumirADA (1,14);
 c1[4]:=VumirADA (1,11);
 bool:=true;
 for i:=1 to 4 do bool:=(bool and (abs(c1[i])<min));
 if bool then
  begin
   delay(500);
   c1[1]:=VumirADA (1,6);
   c1[2]:=VumirADA (1,12);
   c1[3]:=VumirADA (1,14);
   c1[4]:=VumirADA (1,11);
  end;

bool:=false;
if (abs(c1[1])<min) then              c2[1]:=0;
if (c1[1]>-0.58)and(c1[1]<-0.42) then  c2[1]:=1;
if (c1[1]>-0.95)and(c1[1]<-0.75) then    c2[1]:=2;
if (c1[1]>-1.3)and(c1[1]<-1.12) then  c2[1]:=3;
if (c1[1]>-1.6)and(c1[1]<-1.45) then   c2[1]:=4;
if (c1[1]>-2.05)and(c1[1]<-1.8) then  c2[1]:=5;
if (c1[1]>-2.35)and(c1[1]<-2.18) then  c2[1]:=6;
if (c1[1]>-2.69)and(c1[1]<-2.5) then    c2[1]:=7;
if (c1[1]>-3.30)and(c1[1]<-3.1) then   c2[1]:=8;
if (c1[1]>-3.65)and(c1[1]<-3.4) then   c2[1]:=9;
if c2[1]=55  then Continue;

if (abs(c1[2])<min) then             c2[2]:=0;
if (c1[2]>-0.5)and(c1[2]<-0.4) then   c2[2]:=1;
if (c1[2]>-0.85)and(c1[2]<-0.65) then  c2[2]:=2;
if (c1[2]>-1.14)and(c1[2]<-1.05) then c2[2]:=3;
if (c1[2]>-1.33)and(c1[2]<-1.17) then c2[2]:=4;
if (c1[2]>-1.60)and(c1[2]<-1.45) then c2[2]:=5;
if (c1[2]>-1.84)and(c1[2]<-1.7) then  c2[2]:=6;
if (c1[2]>-2.2)and(c1[2]<-2.05) then  c2[2]:=7;
if (c1[2]>-2.68)and(c1[2]<-2.5) then  c2[2]:=8;
if (c1[2]>-3.05)and(c1[2]<-2.85) then c2[2]:=9;
if c2[2]=55  then Continue;

if (abs(c1[3])<min) then             c2[3]:=0;
if (c1[3]>-0.51)and(c1[3]<-0.4) then   c2[3]:=1;
if (c1[3]>-0.8)and(c1[3]<-0.68) then  c2[3]:=2;
if (c1[3]>-1.108)and(c1[3]<-1.03) then c2[3]:=3;
if (c1[3]>-1.23)and(c1[3]<-1.12) then c2[3]:=4;
if (c1[3]>-1.58)and(c1[3]<-1.40) then c2[3]:=5;
if (c1[3]>-1.84)and(c1[3]<-1.65) then  c2[3]:=6;
if (c1[3]>-2.2)and(c1[3]<-2.05) then  c2[3]:=7;
if (c1[3]>-2.59)and(c1[3]<-2.35) then c2[3]:=8;
if (c1[3]>-3)and(c1[3]<-2.7) then   c2[3]:=9;
if c2[3]=55  then Continue;

if (abs(c1[4])<min) then              c2[4]:=0;
if (c1[4]>-0.5)and(c1[4]<-0.35) then   c2[4]:=1;
if (c1[4]>-0.82)and(c1[4]<-0.68) then  c2[4]:=2;
if (c1[4]>-1.12)and(c1[4]<-1.0) then   c2[4]:=3;
if (c1[4]>-1.22)and(c1[4]<-1.15) then  c2[4]:=4;
if (c1[4]>-1.56)and(c1[4]<-1.4) then   c2[4]:=5;
if (c1[4]>-1.8)and(c1[4]<-1.65) then   c2[4]:=6;
if (c1[4]>-2.15)and(c1[4]<-2.0) then   c2[4]:=7;
if (c1[4]>-2.55)and(c1[4]<-2.35) then  c2[4]:=8;
if (c1[4]>-2.9)and(c1[4]<-2.7) then    c2[4]:=9;
if c2[4]=55  then Continue;

bool:=true;
until bool;


 a:=c2[1]+10*c2[2]+100*c2[3]+1000*c2[4];
  if abs(VumirADA (1,3))>3 then B721A:=-a else B721A:=a;
end;
{----------------------------------------------------------------------}


Function B721AVym:single;
{считывание показаний с вольтметр В7-21А, в микровольтах
фактически эта функция обрабатывает случайные неправильные измерения,
а само однократное считывание реализовано в
предыдущей функции B721A}
var a,b,max:integer;
begin
repeat
a:=B721A;
b:=B721A;
if abs(a)>abs(b) then max:=abs(a) else max:=abs(b);
if max=0 then Break;
until abs((a-b)/max)<0.05;
Tvymir:=round((a+b)/2);
B721AVym:=(a+b)/2;
end;
{----------------------------------------------------------------------}


Function TempDeterm(a:single):Single;
{измерение температуры,
а - напряжение на термопаре Cu-Ko,
необходимо если выбран режим ручного ввода
значений и вольтметра, для остальных
режимов может быть любым}
var i:byte;
    T:single;
    UT:TUT70B;
begin
case Par^.Tem_Reg of
  1:TempDeterm:=T_CuKo(a);
  2:begin
    T:=0;
    UmVumirADA(10);
    for i:=1 to 10 do T:=T+KalibPerevod(UmVumirADA(10),Popr^);
    T:=T/i;
    T:=(T+0.002)/(1+100/1.034)*1e6;
    TempDeterm:=T_CuKo(T);
    end;
  3,4,6:TempDeterm:=273.16;
  5:TempDeterm:=T_CuKo(B721AVym);
 end;

end;
{----------------------------------------------------------------------}

Function ErrorUT70(UT:TUT):string;
{проверка правильности включения
мультиметра, а именно того, что
данные с него читаются, что установлен
режим измерения постоянного напряжения,
что диапазон выбирается автоматически;
при ошибках возвращается соответствующая
строка, если все хорошо, то строка пустая}
var bool:boolean;
begin
case UT.Name of
   UTB:
      begin
      bool:=UNITB.Vymir;
      if (not(bool))or(UNITB.X=555) then
                         begin
                         ErrorUT70:='Data reading mistake';
                         Exit;
                         end;
      if UNITB.Tp<>'V' then
                         begin
                         ErrorUT70:='Choose voltage measurements';
                         Exit;
                         end;
      if UNITB.AC then
                         begin
                         ErrorUT70:='Choose direct voltage measurements';
                         Exit;
                         end;
      if not(UNITB.Auto) then
                         begin
                         ErrorUT70:='Choose AUTO range';
                         Exit;
                         end;
      end;
   UTC:
      begin
      bool:=UNITC.Vymir;
      if (not(bool))or(UNITC.X=555) then
                         begin
                         ErrorUT70:='Data reading mistake';
                         Exit;
                         end;
      if not( UNITC.Tp in ['V','v']) then
                         begin
                         ErrorUT70:='Choose direct voltage measurements';
                         Exit;
                         end;
      {if not(UNITC.Auto) then
                         begin
                         ErrorUT70:='Choose AUTO range';
                         Exit;
                         end;}
      end;
 end;
ErrorUT70:='';
end;
{----------------------------------------------------------------------}

Procedure Single5Write(var f:text;a:Tsingle5);
{подпрограмка записи в файл, связанный с f,
данных из а в одну строчку через пробел}
var i:byte;
begin
for i:=1 to 5 do write(f,a[i]:6:4,' ');
end;
{----------------------------------------------------------------------}


Procedure ParWrite(fname:string; a:TAllParam);
{запись в файл с именем fname данных из а}
var f:text;
begin
assign(f,Katalog+fname);
rewrite(f);
Single5Write(f,a.Forw.delU);
writeln(f,a.Forw.U0:5:3,' ',a.Forw.Um:5:3,' ',a.Forw.time);

Single5Write(f,a.Rev.delU);
writeln(f,a.Rev.U0:5:3,' ',a.Rev.Um:5:3,' ',a.Rev.time);

Single5Write(f,a.Upop);
writeln(f);
Single5Write(f,a.UUpop);
writeln(f);

writeln(f,ord(a.Kan1.Name),' ',a.Kan1.Port);

writeln(f,ord(a.Kan2.Name),' ',a.Kan2.Port);

writeln(f,ord(a.SC_reg),' ',ord(a.IV_Reg),' ',a.Tem_Reg);

writeln(f,ord(a.SerPar.time),' ',a.SerPar.delTime,' ',a.SerPar.delT:3:1);

Close(f);
end;
{----------------------------------------------------------------------}

Procedure Single5Set(var a:TSingle5;b:single);
{всапомогательная процедура, заполняющая
все элементы массива а значением b}
var i:byte;
begin
for i:=1 to 5 do a[i]:=b;
end;
{----------------------------------------------------------------------}

Procedure Single5Read(var f:text;var a:Tsingle5);
{подпрограмка считывания из в файла, связанного с f,
данных в а; предполагается, что данные
записаны в одну строчку через пробел}
var i:byte;
begin
for i:=1 to 5 do read(f,a[i]);
end;
{----------------------------------------------------------------------}


Procedure ParRead(fname:string; var a:TAllParam);
{чтение из файл с именем fname данных в а;
если файл отсутствует заполняется параметрами по умолчанию;
если файл имеет неправильный формат никаких проверок
не проводится}
var f:text;
    i:byte;
begin
FindFirst(Katalog+fname,AnyFile,SR);
if DosError<>0 then
   begin
   Single5Set(a.Forw.delU,0.01);
   Single5Set(a.Rev.delU,0.01);
   Single5Set(a.Upop,0);
   Single5Set(a.UUpop,0);
   a.Forw.U0:=0;a.Forw.Um:=5;a.Forw.time:=50;
   a.Rev.U0:=0;a.Rev.Um:=-5;a.Rev.time:=50;
   a.Kan1.Name:=UTC;a.Kan1.Port:=2;
   a.Kan2.Name:=UTB;a.Kan2.Port:=1;
   a.SC_Reg:=True;
   a.IV_Reg:=True;
   a.Tem_Reg:=2;
   a.SerPar.time:=True;
   a.SerPar.delTime:=2;
   a.SerPar.delT:=2;
   end
               else
   begin
   assign(f,Katalog+fname);
   reset(f);
   Single5Read(f,a.Forw.delU);
   readln(f,a.Forw.U0,a.Forw.Um,a.Forw.time);
   Single5Read(f,a.Rev.delU);
   readln(f,a.Rev.U0,a.Rev.Um,a.Rev.time);
   Single5Read(f,a.Upop);
   readln(f);
   Single5Read(f,a.UUpop);
   readln(f);
   read(f,i);
   if i=0 then a.Kan1.Name:=UTB else a.Kan1.Name:=UTC;
   readln(f,a.Kan1.Port);
   read(f,i);
   if i=0 then a.Kan2.Name:=UTB else a.Kan2.Name:=UTC;
   readln(f,a.Kan2.Port);
   read(f,i);
   if i=0 then a.SC_reg:=False else a.SC_reg:=True;
   read(f,i);
   if i=0 then a.IV_reg:=False else a.IV_reg:=True;
   readln(f,a.Tem_Reg);
   read(f,i);
   if i=0 then a.SerPar.time:=False else a.SerPar.time:=True;
   readln(f,a.SerPar.delTime,a.SerPar.delT);
  Close(f);
  end;

end;
{----------------------------------------------------------------------}

Function FunReadKey:byte;
{возвращает код нажатой клавищи, причем
если нажат ESC возвратится 27,
если функциональная клавиша F1, F2, F3...,
то возвратится              59, 60, 61...,
для не функциональных клавиш визвратится 0}
var i:byte;
begin
i:=ord(ReadKey);
FunReadKey:=i;
if i=27 then Exit;
if i=0 then FunReadKey:=ord(ReadKey)
                else FunReadKey:=0;
end;
{----------------------------------------------------------------------}
Procedure ChosenSetup(i:word;k:TUT);
{выводит желтым цветом строку, составленную
на основании параметров k, положение
по горизонтали - 400, по вертикали -
задается i}
var str:string;
begin
case k.name of
    UTB:str:='UT70B, ';
    UTC:str:='UT70C, ';
    end;
case k.port of
    1:str:=str+'COM1';
    2:str:=str+'COM2';
    end;
SetColor(yellow);
OutTextXY(400,i,str);
end;
{----------------------------------------------------------------------}

Procedure MenuSetup;
var i0:byte;
    p1,p2:word;
    k1,k2:TUT;
begin
k1:=Par^.Kan1;
k2:=Par^.Kan2;

repeat
MD.Init;
MD.Title('SETUP');
MD.LineMenu;
MD.dRow:=MD.dRow-20;
MD.Row:=MD.Row-10;
MD.AddSubTitle('Setup for voltage measuring');
MD.AddItem('F1  - UT70B, COM1');
MD.AddItem('F2  - UT70B, COM2        Chosen');
p1:=MD.Row;
MD.AddItem('F3  - UT70C, COM1');
MD.AddItem('F4  - UT70C, COM2');
MD.Row:=MD.Row+15;
MD.LineMenu;
MD.Row:=MD.Row-10;
MD.AddSubTitle('Setup for current measuring');
MD.AddItem('F5  - UT70B, COM1');
MD.AddItem('F6  - UT70B, COM2        Chosen');
p2:=MD.Row;
MD.AddItem('F7  - UT70C, COM1');
MD.AddItem('F8  - UT70C, COM2');
MD.Row:=MD.Row+15;
MD.LineMenu;
MD.AddItem('ESC - SAVE and EXIT');
MD.AddItem('F10 - EXIT without saving');

ChosenSetup(p1,k1);
ChosenSetup(p2,k2);

i0:=FunReadKey;
case i0 of
     59:begin k1.name:=UTB; k1.port:=1; end;
     60:begin k1.name:=UTB; k1.port:=2; end;
     61:begin k1.name:=UTC; k1.port:=1; end;
     62:begin k1.name:=UTC; k1.port:=2; end;
     63:begin k2.name:=UTB; k2.port:=1; end;
     64:begin k2.name:=UTB; k2.port:=2; end;
     65:begin k2.name:=UTC; k2.port:=1; end;
     66:begin k2.name:=UTC; k2.port:=2; end;
   end;
until (i0=27)or(i0=68);
if i0=27 then
  begin
  Par^.Kan1:=k1;
  Par^.Kan2:=k2;
  ParWrite(parfile,Par^);
  if Par^.Kan1.Name=UTB then UNITB.Create(Par^.Kan1.Port)
                       else UNITC.Create(Par^.Kan1.Port);
  if Par^.Kan2.Name=UTB then UNITB.Create(Par^.Kan2.Port)
                       else UNITC.Create(Par^.Kan2.Port);
  end;
end;
{----------------------------------------------------------------------}

Procedure MenuDiodPosition;
const str1='positive voltage - forward bias';
      str2='positive voltage - reverse bias';
var i0:byte;
    p1:word;
    reg:boolean;
begin
reg:=Par^.IV_reg;
repeat
MD.Init;
MD.Title('DIOD POSITION');
MD.LineMenu;
MD.AddItem('F1:  '+str1);
MD.AddItem('F2:  '+str2);
MD.Row:=MD.Row+MD.dRow;
OutTextXY(250,MD.Row,'Chosen');
p1:=MD.Row+MD.dRow-10;
MD.Row:=MD.Row+3*MD.dRow;
MD.AddItem('ESC - SAVE and EXIT');
MD.AddItem('F10 - EXIT without saving');
SetColor(Yellow);
if reg then OutTextXY(130,p1,str1)
       else OutTextXY(130,p1,str2);

i0:=FunReadKey;
case i0 of
     59:reg:=true;
     60:reg:=false;
   end;
until (i0=27)or(i0=68);
if i0=27 then
  begin
  Par^.IV_reg:=reg;
  ParWrite(parfile,Par^);
  end;
end;
{----------------------------------------------------------------------}

Procedure MenuTypeMeasur;
const str1='Shottky diod mode';
      str2='Solar Cell mode';
var i0:byte;
    p1:word;
    reg:boolean;
begin
reg:=Par^.SC_Reg;
repeat
MD.Init;
MD.Title('TYPE OF MEASUREMENT');
MD.LineMenu;
MD.AddItem('F1:  '+str1);
MD.AddItem('F2:  '+str2);
MD.Row:=MD.Row+MD.dRow;
OutTextXY(250,MD.Row,'Chosen');
p1:=MD.Row+MD.dRow-10;
MD.Row:=MD.Row+3*MD.dRow;
MD.AddItem('ESC - SAVE and EXIT');
MD.AddItem('F10 - EXIT without saving');
SetColor(Yellow);
if reg then OutTextXY(170,p1,str1)
       else OutTextXY(170,p1,str2);

i0:=FunReadKey;
case i0 of
     59:reg:=true;
     60:reg:=false;
   end;
until (i0=27)or(i0=68);
if i0=27 then
  begin
  Par^.SC_Reg:=reg;
  ParWrite(parfile,Par^);
  end;
end;
{----------------------------------------------------------------------}

Procedure MenuMeasurPar(znak:byte);
{znak=1 - для прямой ВАХ
 znak=2 - для обратной ВАХ}
const title:array [1..2] of string=
           ('FORWARD MEASUREMENT',
           'REVERSE MEASUREMENT');

var i0,i,mode:byte;
    j:integer;
    st1,st2:string;
    VaxParam:TVaxParam;
    Diap:TSingle5;
    ch:char;
    num:single;


begin
case znak of
  1:begin
    VaxParam:=Par^.Forw;
    Diap:=DiapFor;
    end;
  2:begin
    VaxParam:=Par^.Rev;
    Diap:=DiapRev;
    end;
  end;

i0:=59;

repeat
MD.Init;
MD.Title(title[znak]);
MD.LineMenu;
MD.Row:=400;
MD.AddItem('ESC - SAVE and EXIT');
MD.AddItem('F10 - EXIT without saving');


SetTextStyle(DefaultFont,HorizDir,1);
SetColor(color[znak]);
i:=90;
OutTextXY(20,i,'DIAPAZON, V');
OutTextXY(20,i+30,'STEP, V');
Str(Diap[1]:3:2,st1);
OutTextXY(150,i,'0..'+st1);
Str(Diap[2]:1:0,st2);
OutTextXY(240,i,st1+'..'+st2);
Str(Diap[3]:1:0,st1);
OutTextXY(340,i,st2+'..'+st1);
Str(Diap[4]:1:0,st2);
OutTextXY(430,i,st1+'..'+st2);
Str(Diap[5]:1:0,st1);
OutTextXY(520,i,st2+'..'+st1);
OutTextXY(20,i+80,'MIN VOLTAGE, V');
OutTextXY(20,i+120,'MAX VOLTAGE, V');
OutTextXY(20,i+160,'INTERVAL, MS');



Setcolor(lightred);
 for j:=1 to 5 do
     begin
       Str(VaxParam.delU[j]:5:3,st1);
       outtextXY(160+(j-1)*90,i+30,st1);
      end;
Str(VaxParam.U0:4:2,st1);
outtextXY(160,i+80,st1);
Str(VaxParam.Um:4:2,st1);
outtextXY(160,i+120,st1);
Str(VaxParam.time,st1);
outtextXY(165,i+160,st1);

 setcolor(green);
   for j:=1 to 5 do
        begin
        Str(j,st1);
        OutTextXY(170+(j-1)*90,i+15,'F'+st1)
        end;
   OutTextXY(168,155,'F6');
   OutTextXY(168,195,'F7');
   OutTextXY(168,235,'F8');

   setcolor(yellow);
   case i0 of
    59,60,61,62,63: Rectangle(155+(i0-59)*90,97,205+(i0-59)*90,127);
    64,65,66:Rectangle(155,145+(i0-64)*40,205,180+(i0-64)*40);
    end;

   OutTextXY(365,155,'INPUT NEW VALUE');
   Rectangle(330,170,530,250);

   OutTextXY(70,280,'PUSH FUNCTIONAL KEY (F1..F7) AND INPUT NEW VALUE FOR SELECTED PARAMETER.');
   OutTextXY(70,295,'POSSIBLE DIAPAZONES:  [-5..5] FOR MIN VOLTAGE;   [0.001..1] FOR STEP;  ');
   case znak of
     1:st1:='(0..5]';
     2:st1:='[-5..0)';
    end;
   OutTextXY(70,310,st1+' FOR MAX VOLTAGE;   [1..30 000] FOR INTERVAL.');
   OutTextXY(70,325,'TO PUSH "ENTER" KEY FOR END OF INPUT.');

   SetTextStyle(DefaultFont,HorizDir,2);


   st1:='';
 repeat
   ch:=ReadKey;
   mode:=ord(ch);
   case mode of
     8,45,46,48..57:
        begin
          setcolor(GetBkColor);
          OutTextXY(380,210,st1);
          if mode=8 then delete(st1,length(st1),1)
                    else
                     begin
                     Val(st1+ch,num,j);
                     if (j=0)or(st1+ch='-') then st1:=st1+ch;
                     end;
          SetColor(white);
          OutTextXY(380,210,st1);
        end;
      13:begin
         Val(st1,num,j);
         num:=round(num*1000)/1000;
         case i0 of
          59..63: if (num<=1)and(num>=0.001) then VaxParam.delU[i0-58]:=num;
          64:     if (abs(num)<=5) then VaxParam.U0:=num;
          65:     case znak of
                   1:if (num<=5)and(num>0) then VaxParam.Um:=num;
                   2:if (num>=-5)and(num<0) then VaxParam.Um:=num;
                   end;
          66:     if (num>=1)and(num<=30000) then  VaxParam.time:=round(num);
          end;
         st1:='';
         end;
      0: begin
          mode:=ord(ReadKey);
          case mode of
            59..66,68: i0:=mode;
                77,80: if i0<66 then i0:=i0+1;
                72,75: if i0>59 then i0:=i0-1;
            end;
           st1:='';
         end;
       27:
       begin
       i0:=mode;
       st1:='';
       end;
     end;
  until (st1='');

until (i0=27)or(i0=68);
if i0=27 then
  begin
  case znak of
    1:Par^.Forw:=VaxParam;
    2:Par^.Rev:=VaxParam;
    end;
  ParWrite(parfile,Par^);
  end;

end;
{----------------------------------------------------------------------}

Procedure MenuTemper;
const title:array [1..6] of string=
           ('B7-21, manual input',
           'Termocuple and amplifier',
           'UT70B',
           'Sensor AD22100',
           'B7-21A, auto-input',
           'No measurements');
var i0:byte;
    st:string;
    p1:word;
    reg:word;
begin
reg:=Par^.Tem_Reg;
repeat
MD.Init;
MD.Title('TEMPERATURE DEFINITION');
MD.LineMenu;
for i0:=1 to 6 do
 begin
 Str(i0,st);
 MD.Row:=MD.Row-10;
 MD.AddItem('F'+st+':  '+title[i0]);
 end;
p1:=MD.Row;
MD.AddItem('    Chosen');
MD.AddItem('ESC - SAVE and EXIT');
MD.AddItem('F10 - EXIT without saving');{}
SetColor(Yellow);
 OutTextXY(240,p1,title[reg]);

i0:=FunReadKey;
if i0 in [59..64] then reg:=i0-58;

until (i0=27)or(i0=68);
if i0=27 then
  begin
  Par^.Tem_Reg:=reg;
  ParWrite(parfile,Par^);
  end;
end;
{----------------------------------------------------------------------}

Procedure Popravka(mode:byte;a0:single);
{производится определение поправочных
коефициентов - значений Par^.Upop[mode] и
Par^.UUpop[mode];
а0 - начальное приближение для Par^.UUpop[mode]}
var a,v,err:single;
    i:integer;

begin
Opir(mode);
delay(500);
err:=9e-4;
{if Par^.Kan1.Name=UTC then
   begin
    a:=UNITC.VymirData;
    if UNITC.Tp='v' then err:=2e-4;
   end;
}

a:=a0;
v:=0;
i:=0;

if mode=1 then i:=-10;
repeat
   a:=a-v;
  NaprugaADA(a);
  delay(500);
  v:=MeasureUU;
  Inc(i);
until (abs(v)<err)or(i>35);

 v:=MeasureUI;

  if abs(a)>0.2 then
                 begin
                 Par^.UUpop[mode]:=0;
                 NaprugaADA(0);
                 delay(500);
                 v:=MeasureUI;
                 end
              else Par^.UUpop[mode]:=a;
  if abs(v)>2 then Par^.Upop[mode]:=555
              else Par^.Upop[mode]:=v;
 end;
{----------------------------------------------------------------------}

Procedure ReferPoint;
var i0:byte;
    a:single;
    st,st1:string;
begin

MD.Init;
MD.Title('REFER POINT');


st:=ErrorUT70(Par^.Kan2);
if st<>'' then
           begin
           ErrorWindow(st);
           Exit;
           end;
st:=ErrorUT70(Par^.Kan1);
if st<>'' then
           begin
           ErrorWindow(st);
           Exit;
           end;

NaprugaADA(0);


setcolor(yellow);
OutTextXY(50,100,'voltage      current');

{for i0:=1 to 5 do
  begin
  Opir(i0);
  delay(1000);
  a:=MeasureUI;
  delay(5);
  a:=MeasureUI;
   Str(a:6:4,st1);
   OutTextXY(50,100+30*i0,st1);
  end;}

a:=0;
for i0:=1 to 5 do
  begin
   Popravka(i0,a);
   Str(Par^.Upop[i0]:6:4,st);
   Str(Par^.UUpop[i0]:6:4,st1);
   a:=Par^.UUpop[i0];
   OutTextXY(50,110+30*i0,st+'    '+st1);
  end;
Opir(1);
NaprugaADA(0);

setcolor(green);
OutTextXY(100,350,'press any key');
Waiting;
ParWrite(parfile,Par^);
Melody;
end;
{----------------------------------------------------------------------}

Procedure IVMeasure;
const title:array [1..2] of string=
           ('FORWARD CHARCTERISTIC',
            'REVERSE CHARCTERISTIC');
      Ucolor:array [1..2] of word=
           (yellow,lightmagenta);

var f:text;
    choic,TemReg,FileNum,j:byte;
    sf,st,s1,s2,st_t:string;
    a,b:Pvector;
    U,U1,U2,T,Ustep,delU,U1t,U2t,Utemp,Ia,Ib,Upop,UUtemp:single;
    i,c0,n:word;
    V:UT_date;
    DT:DateTime;
    znak,argval:integer;
    Diap:TSingle5;
    IVParam:TVaxParam;
    chois5,ring2,VocBool,IscBool:boolean;

label 1,2{,a1};

{функция определения значения шага по напряжению}
Function Delta (U:single):single;
  begin
  if (abs(U)>abs(Diap[4])) then Delta:=IVParam.delU[5];
  if (abs(U)>abs(Diap[3]))and(abs(U)<=abs(Diap[4])) then Delta:=IVParam.delU[4];
  if (abs(U)>abs(Diap[2]))and(abs(U)<=abs(Diap[3])) then Delta:=IVParam.delU[3];
  if (abs(U)>abs(Diap[1]))and(abs(U)<=abs(Diap[2])) then Delta:=IVParam.delU[2];
  if abs(U)<=abs(Diap[1]) then  Delta:=IVParam.delU[1];
  end;

begin

znak:=1;

2:

if znak=1 then
             begin
             Diap:=DiapFor;
             IVParam:=Par^.Forw;
             end
           else
             begin
             Diap:=DiapRev;
             IVParam:=Par^.Rev;
             end;

chois5:=false;
VocBool:=False;
IscBool:=False;
Utemp:=0;
Upop:=0;
{ring2:=false;
ring3:=false;}

MD.Init;

MD.Title(title[znak]);
MD.LineMenu;
MD.Row:=300;
MD.AddItem('ESC for stop');


SetTextStyle(DefaultFont,HorizDir,1);
SetColor(color[znak]);
i:=90;
OutTextXY(20,i,'DIAPAZON, V');
OutTextXY(20,i+30,'STEP, V');
Str(IVParam.U0:2:1,s2);
Str(Diap[1]:3:2,s1);
OutTextXY(150,i,s2+'..'+s1);
Str(Diap[2]:1:0,s2);
OutTextXY(250,i,s1+'..'+s2);
Str(Diap[3]:1:0,s1);
OutTextXY(350,i,s2+'..'+s1);
Str(Diap[4]:1:0,s2);
OutTextXY(440,i,s1+'..'+s2);
Str(Diap[5]:1:0,s1);
OutTextXY(530,i,s2+'..'+s1);

Setcolor(lightred);
 for j:=1 to 5 do
     begin
       Str(IVParam.delU[j]:5:3,s1);
       outtextXY(170+(j-1)*90,i+30,s1);
      end;

SetTextStyle(DefaultFont,HorizDir,3);
SetColor(Ucolor[znak]);
outtextXY(350,200,'U=');

if znak=2 then  dispose(a);

if ((Par^.IV_Reg)and(znak=2))or((not(Par^.IV_Reg))and(znak=1)) then
             for j:=1 to 5 do IVParam.delU[j]:=-IVParam.delU[j];

if znak=1 then
 begin
s1:=ErrorUT70(Par^.Kan2);
if s1<>'' then
           begin
           ErrorWindow(s1);
           Exit;
           end;
s1:=ErrorUT70(Par^.Kan1);
if s1<>'' then
           begin
           ErrorWindow(s1);
           Exit;
           end;
 end;

choic:=0;

repeat
 Inc(choic);

 Setcolor(GetBkColor);
 outtextXY(100,350,s2);
 Str(choic,s2);
 Setcolor(yellow);
 outtextXY(100,350,s2);

 if choic>5 then Exit;
 Opir(choic);
 delay(100);
 if Par^.Sc_Reg then
 begin
 Popravka(choic,Par^.UUpop[choic]);

 if (choic=2)and(abs(Par^.Upop[choic])<0.05) then
   begin
     choic:=1;
     Setcolor(GetBkColor);
    outtextXY(100,350,s2);
    Str(choic,s2);
    Setcolor(yellow);
    outtextXY(100,350,s2);
    Opir(choic);
    delay(100);
     Popravka(choic,Par^.UUpop[choic]);
   end;
 end;

until(Par^.Upop[choic]<>555);

 if Par^.IV_Reg then U:=IVParam.U0
                else U:=-IVParam.U0;

i:=0;
new(a);
c0:=0;


repeat

if KeyPressed then
              begin
              c0:=ord(ReadKey);
              if c0=27 then begin
                            dispose(a);
                            NaprugaADA(0);
                            Opir(1);
                            exit;
                            end
              end;

if Par^.IV_Reg then Str(U:5:3,s1) else Str(-U:5:3,s1);
S1:=S1+' B';
outtextXY(400,200,s1);

1:

NaprugaADA(U+Par^.UUpop[choic]+Upop);

if chois5 then
            begin
            delay(1000);
            chois5:=false;
            end;

delay(IVParam.time);

U2:=MeasureUI;
U2:=MeasureUI;

case choic of
 1,4:if (abs(U2)>3.8) then chois5:=true;
 3:  if (abs(U2)>6) then chois5:=true;
 2:  if (abs(U2)>2.1) then chois5:=true;
 end;
{if ((abs(U2)>3.8)and(choic<5)) then}
if chois5  then

         begin
{         if (znak=2)and(choic=3) then goto a1;}

         Inc(choic);
         Setcolor(GetBkColor);
         outtextXY(100,350,s2);
         Str(choic,s2);
         Setcolor(yellow);
         outtextXY(100,350,s2);

         if choic>5 then break;
         Opir(choic);
         delay(1000);
         if Par^.SC_Reg then
          repeat
           Popravka(choic,Par^.UUpop[choic-1]);
          until(Par^.Upop[choic]<>555);

{         chois5:=true;}
         goto 1
         end;
{a1:}
if (abs(U2)>10) then break;

U1:=MeasureUU;

{if not(Par^.SC_Reg)and(znak=1)and(U<>0) then
 begin
 if i=0 then UUtemp:=U
        else
         begin

         if abs(a^.y[i]*Rs)<0.0001 then
              begin
               if U1>0 then UUtemp:=a^.x[i]+Delta(a^.x[i])
                       else UUtemp:=-abs(a^.x[i])-abs(Delta(a^.x[i]));
              end
                                    else
               begin
               if U1>0 then UUtemp:=a^.x[i]+Delta(a^.x[i])+abs(a^.y[i]*Rs)
                       else UUtemp:=-abs(a^.x[i])-abs(Delta(a^.x[i]))-abs(a^.y[i]*Rs)
               end;
         end;

 if (abs(abs(U1)-UUtemp)>0.0008) then
  begin
    if (abs(U1-UUtemp)>0.001) then Upop:=Upop-(U1-UUtemp)
      else
   if (Par^.Kan1.Name=UTC)and(UNITC.Tp='v')and(znak=1) then
                        Upop:=Upop-0.0005*(U1-UUtemp)/abs(U1-UUtemp)
                                           else
                        Upop:=Upop-0.001*(U1-UUtemp)/abs(U1-UUtemp);
  end;

 if (abs(U1-UUtemp)>0.001) then Continue;
 end;{}

{if (Par^.SC_Reg=False)and(abs(U1-U)>0.0009) then
  begin
  if (Par^.Kan1.Name=UTC)and(UNITC.Tp='v')and(znak=1) then
                        Upop:=Upop-0.0005*(U1-U)/abs(U1-U)
                                           else
                        Upop:=Upop-0.001*(U1-U)/abs(U1-U);
  end;

if (Par^.SC_Reg=False)and(abs(U1-U)>0.0020) then Continue;
{if (abs(U1-U)>0.0028)and(abs(U)<=0.477)and(abs(U)>=0.471) then Continue;}


U2:=(U2-Par^.Upop[choic]);
if(abs(U)<=0.0001)and(abs(U2)<0.1*abs(Par^.Upop[choic]))
  then U2:=0
  else U2:=U2/Ruse[choic];

if abs(U2)>2e-2 then break;

case znak of
   1:if Par^.IV_Reg then U2:=-U2 else U1:=-U1;
   2:begin
      if Par^.IV_Reg then U1:=-U1 else U2:=-U2;
    end
   end;

{}if abs(U2*Rs)>0.0001 then
              if  U1>0 then U1:=U1-abs(U2)*Rs
                       else U1:=U1+abs(U2)*Rs;
{vrahovuetsja opir vumirjuvalnoi sistemy}

if abs(U1)<0.0001 then U1:=0;

{}if not(Par^.SC_Reg)and(znak=1) then
 begin
 if i=0 then UUtemp:=U
        else
         begin
               if U1>0 then UUtemp:=a^.x[i]+Delta(a^.x[i])
                       else UUtemp:=-abs(a^.x[i])-abs(Delta(a^.x[i]));
         end;

 if (abs(U1-UUtemp)>0.0008) then
  begin
  if (abs(U1-UUtemp)>0.001) then Upop:=Upop-(U1-UUtemp)
      else
  if (Par^.Kan1.Name=UTC)and(UNITC.Tp='v')and(znak=1) then
                        Upop:=Upop-0.0005*(U1-UUtemp)/abs(U1-UUtemp)
                                           else
                        Upop:=Upop-0.001*(U1-UUtemp)/abs(U1-UUtemp);
  end;

 if (abs(U1-UUtemp)>0.0014)and(i<>0) then Continue;
 if ((abs(U1-UUtemp)>0.0018){or(U1<0)})and(i=0) then Continue;


 end;{}



{if (Par^.SC_Reg=False)and(abs(U1-U)>0.0009) then
  begin
  if (Par^.Kan1.Name=UTC)and(UNITC.Tp='v')and(znak=1) then
                        Upop:=Upop-0.0005*(U1-U)/abs(U1-U)
                                           else
                        Upop:=Upop-0.001*(U1-U)/abs(U1-U);
  end;

if (Par^.SC_Reg=False)and(abs(U1-U)>0.0020) then Continue;
{if (abs(U1-U)>0.0028)and(abs(U)<=0.477)and(abs(U)>=0.471) then Continue;}




Setcolor(GetBkColor);
outtextXY(400,200,s1);
SetColor(Ucolor[znak]);


{для определения напряжения холостого хода}
{if (Par^.SC_Reg=False)and(abs(U1)>0.02)
    and(znak=1)and(i>0)and(U2*a^.y[i]<0)and(not(VocBool))
    and(abs(U2)>Imin)and(abs(a^.y[i])>Imin)and(Utemp<>555) then

  begin
   Utemp:=U;
   U1t:=U;
   U2t:=U-delU;
   Ia:=U2;
   Ib:=a^.y[i];
   repeat
     Ustep:=(U1t+U2t)/2;
     NaprugaADA(Ustep+Par^.UUpop[choic]+Upop);
     U:=MeasureUI;
     U:=MeasureUI;
     U:=(U-Par^.Upop[choic])/Ruse[choic];
     if Par^.IV_Reg then U:=-U;
     if (U*Ia<=0) then
           begin
           Ib:=U;
           U2t:=Ustep;
           end
                 else
           begin
           Ia:=U;
           U1t:=Ustep;
           end

   until (abs(U)<Imin)or(abs(U2t-U1t)<0.0002);
   U:=Ustep;
   VocBool:=True;
   Mel;
   Continue;
  end;}


if (abs(U2)>Imin)or(i>0) then
begin
  Inc(i);
  {if abs(U1)<0.0001 then a^.x[i]:=0
                    else} a^.x[i]:=U1;
  a^.y[i]:=U2;
  if (i>1)and(a^.x[i]<a^.x[i-1]) then
      begin
      Swap(a^.x[i],a^.x[i-1]);
      Swap(a^.y[i],a^.y[i-1]);
      end;

  if abs(a^.y[i])>2e-2 then break;
end;



{для определения тока короткого замыкания}
{if (Par^.SC_Reg=False)and(U=0)and(U1<>0)and(znak=1)and(abs(U2)>Imin) then
  begin
    repeat
    U:=U-0.001*round(U1/abs(U1)*IVParam.delU[5]/abs(IVParam.delU[5]));
    NaprugaADA(U+Par^.UUpop[choic]+Upop);
    U2t:=MeasureUI;
    U1t:=MeasureUU;

    U2t:=(U2t-Par^.Upop[choic])/Ruse[choic];
   case znak of
    1:if Par^.IV_Reg then U2t:=-U2t else U1t:=-U1t;
    2:if Par^.IV_Reg then U1:=-U1t else U2:=-U2t;
    end;

    if abs(U2t*Rs)>0.0001 then
               if  U1t>0 then U1t:=U1t-abs(U2t)*Rs
                       else U1t:=U1t+abs(U2t)*Rs;

   if abs(U1t)<0.0001 then U1t:=0;
   until(U1t*U1<=0);
   IscBool:=True;
   Mel;
   Continue;
  end;
 }

if (abs(U2)<=Imin)and(abs(U)>0)and(i<1) then
begin
 if znak=1 then Ustep:=0.05 else Ustep:=0.5;
 Ustep:=Ustep*IVParam.delU[5]/abs(IVParam.delU[5]);
 ring2:=true;
 repeat
  if (znak=2)and(abs(U)<0.09)and(abs(Ustep)>0.4) then U:=0.0001;
  U:=U+Ustep;
  if Par^.IV_Reg then Str(U:5:3,s1) else Str(-U:5:3,s1);
  S1:=S1+' B';
  outtextXY(400,200,s1);

  NaprugaADA(U+Par^.UUpop[choic]+Upop);

  delU:=Delta(U);

  U2:=MeasureUI;
  U2:=MeasureUI;
  U2:=(U2-Par^.Upop[choic])/Ruse[choic];
  if  (abs(U2)>Imin)and(ring2) then
                       begin
                       Ustep:=-Ustep/5;
                       ring2:=False;
                       end;
  if  (abs(U2)<=Imin)and(not(ring2)) then
                      begin
                      Ustep:=-Ustep/5;
                      ring2:=true;
                      end;
  Setcolor(GetBkColor);
  outtextXY(400,200,s1);
  SetColor(Ucolor[znak]);
 until ((abs(U2)<=Imin)and(abs(Ustep)<abs(delU)))or
       (not(ring2)and(abs(U)<0.11)and(znak=2));
end;

{if IscBool then
    begin
    U:=0;
    IscBool:=False;
    end;}

delU:=Delta(U);
U:=U+delU;

{if VocBool then
    begin
    U:=Utemp;
    VocBool:=False;
    Utemp:=555;
    end;}

Mel;
until(abs(U)>abs(IVParam.Um));

NaprugaADA(0);
Melody;
Opir(1);
a^.n:=i;
if a^.n=0 then begin
               dispose(a);
               Exit
               end;

SetTextStyle(DefaultFont,HorizDir,2);
grafic_a(a);
delay(1000);
{будуї графiк у логарифмiчному масштабi}
new(b);
Lognat(a,b);
{a^:=b^;
dispose(b);}
grafic_a(b);

if znak=1 then
 begin
 SetColor(lightred);
 SetTextStyle(DefaultFont,HorizDir,2);
 outtextXY(20,30,'Введiть назву файлу:');
 setcolor(red);
 outtextXY(80,60,'(останнiй файл -');
 Last('*.dat',s1);
 outtextXY(370,60,s1+')');

 if (Copy(s1,length(s1)-4,1)<>'n')and(Copy(s1,length(s1)-4,1)<>'N')
    then delete(s1,length(s1)-3,4)
    else delete(s1,length(s1)-4,5);

 val(s1,FileNum,argval);
 if argval=0 then
              begin
               FileNum:=FileNum+1;
               Str(FileNum,s1);
               SetColor(lightcyan);
               moveto(370,30);
               outtext(s1+'.dat');
               delay(2000);
               if keypressed then
                              begin
                              SetColor(GetBkColor);
                              moveto(370,30);
                              outtext(s1+'.dat');
                              SetColor(lightcyan);
                              moveto(370,30);
                              GrRead(s1);
                              end

              end {then}
             else
              begin
                SetColor(lightcyan);
                moveto(370,30);
                GrRead(s1);
              end; {else}

if s1='' then begin
                 dispose(a);
                 Exit
                 end;

if length(s1)>7 then delete(s1,8,length(s1)-7);

if Par^.Tem_Reg=1 then
   begin
   SetTextJustify(LeftText,CenterText);
   SetColor(green);
   moveto(5,80);
   outtext('Покази термопари (мкВ) -');
   MoveTo(450,80);
   SetColor(yellow);
   GrRead(st);
   val(st,T, argval);
   end;
T:=TempDeterm(T);
{T:=273.16;}
 Tsample:=T;
 Str(T:4:1,st);

 setcolor(lightred);
 moveto(50,120);
 Str(TVymir,st_t);
 outtext('T= '+st+' K        ('+st_t+')');
 delay(1000);
 end;

if znak=2 then begin delay(1000); s1:=sf; end;

assign(f,s1+'.dat');

dispose(b);

if znak=2 then
 begin
 new(b);
 b^:=a^;
 for i:=1 to a^.n do
                  begin
                  a^.y[i]:=-(b^.y[a^.n-i+1]);
                  {if abs(a^.x[i])<0.0001 then a^.x[i]:=0
                                         else} a^.x[i]:=-b^.x[a^.n-i+1];
{                  a^.y[i]:=-exp(b^.y[a^.n-i+1]);
                  a^.x[i]:=-b^.x[a^.n-i+1];
                  if abs(a^.x[i])<0.0001 then a^.x[i]:=0;}
                  end;
 dispose(b);
 reset(f);
 i:=a^.n;
 while not(eof(f)) do
    begin
    a^.n:=a^.n+1;
    readln(f,a^.x[a^.n],a^.y[a^.n]);
    {if abs(a^.x[a^.n])<0.0001 then a^.x[a^.n]:=0;}
    end;
  close(f);
  VaxParam(a,s1,T);
  s1:=s1+'n';
  assign(f,s1+'.dat');
 end;

rewrite(f);

{case znak of
 1: for i:=1 to  a^.n do if a^.x[i]>0.0001 then writeln(f,a^.x[i]:5:3,' ',exp(a^.y[i]):13);
 2: for i:=1 to  a^.n do writeln(f,a^.x[i]:5:3,' ',a^.y[i]:13);
 end;}

if (Par^.Kan1.Name=UTC)and(UNITC.Tp='v') then
       for i:=1 to  a^.n do writeln(f,a^.x[i]:6:4,' ',a^.y[i]:13)
                                         else
       for i:=1 to  a^.n do writeln(f,a^.x[i]:5:3,' ',a^.y[i]:13);

{for i:=1 to  a^.n do writeln(f,a^.x[i]:5:3,' ',a^.y[i]:13);}

close(f);

FindFirst(s1+'.dat',AnyFile,SR);
UnpackTime(SR.time,DT);
assign(f,'comments');
FindFirst('comments',AnyFile,SR);
if DosError<>0 then rewrite(f) else append(f);
writeln(f,s1,'.dat',' - ',DT.Day,'.',DT.Month,'.',DT.Year,' ',DT.Hour,':',DT.Min);
write(f,'T=',T:4:1);
writeln(f);
writeln(f);
close(f);

{if znak=1 then begin znak:=2; sf:=s1; goto 2 end;}


dispose(a);


end;
{----------------------------------------------------------------------}

Procedure MenuADC;
var i0:byte;
begin
repeat
MD.Init;
MD.Title('ADC CALIBRATION');
MD.LineMenu;
MD.AddItem('F1 - WARMING UP');
MD.AddItem('F2 - CALIBRATION');
MD.AddItem('ESC - EXIT');
i0:=FunReadKey;
case i0 of
     59:Progrev;
     60:Kalibrovka;
   end;
until (i0=27);
end;
{----------------------------------------------------------------------}

Procedure MenuSerialPar;
var i0,mode:byte;
    st:string;
    SP:TSerPar;
    ch:char;
    j:integer;
    num:single;
begin
SP:=Par^.SerPar;
repeat
MD.Init;
MD.Title('SER. MEAS. PARAMETERS');
MD.LineMenu;
MD.AddSubTitle('Measurement criteria');
MD.AddItem('F1  - Time');
MD.AddItem('F2  - Temperature');
mode:=MD.Row;
MD.AddItem('Choosen ');
MD.AddItem('Interval');
MD.AddItem('ESC - SAVE and EXIT');
MD.AddItem('F10 - EXIT without saving');
SetColor(lightred);
if SP.time then
           begin
           OutTextXY(200,mode,'Time');
           Str(SP.delTime,st);
           st:=st+' min';
           end
           else
           begin
           OutTextXY(200,mode,'Temperature');
           Str(SP.delT:3:1,st);
           st:=st+' K';
           end;
OutTextXY(200,mode+MD.dRow,st);

SetTextStyle(DefaultFont,HorizDir,1);
SetColor(yellow);
OutTextXY(415,190,'INPUT NEW INTERVAL VALUE');
if SP.time then
           begin
OutTextXY(395,200,'POSSIBLE DIAPAZONE: 1-50 MIN');
OutTextXY(395,210,'              STEP:   1  MIN');
           end
           else
           begin
OutTextXY(395,200,'POSSIBLE DIAPAZONE: 0.5-20 K');
OutTextXY(395,210,'              STEP:   0.5  K');
           end;
OutTextXY(395,220,' PUSH "ENTER" FOR INPUT END.');

  Rectangle(410,230,610,290);
  SetTextStyle(DefaultFont,HorizDir,2);

  st:='';
 repeat
   ch:=ReadKey;
   mode:=ord(ch);
   case mode of
     8,45,46,48..57:
        begin
          setcolor(GetBkColor);
          OutTextXY(480,260,st);
          if mode=8 then delete(st,length(st),1)
                    else
                     begin
                     Val(st+ch,num,j);
                     if (j=0)or(st+ch='-') then st:=st+ch;
                     end;
          SetColor(white);
          OutTextXY(480,260,st);
        end;
      13:begin
         Val(st,num,j);
         if SP.time then
            begin
            SP.delTime:=round(num);
            if SP.delTime>50 then SP.delTime:=50;
            if SP.delTime<1 then SP.delTime:=1;
            end
                     else
            begin
            SP.delT:=round(num*2)/2;
            if SP.delT>20 then SP.delT:=20;
            if SP.delT<0.5 then SP.delT:=0.5;
            end;
         st:='';
         end;
      0: begin
          mode:=ord(ReadKey);
          st:='';
         end;
       27: st:='';
     end;
  until (st='');

case mode of
     59:SP.time:=True;
     60:SP.time:=False;
   end;
until (mode=27)or(mode=68);
if mode=27 then
  begin
  Par^.SerPar:=SP;
  ParWrite(parfile,Par^);
  end;
end;
{----------------------------------------------------------------------}

Procedure TimeLabel;
{процедура запису у файл 'comments'
    вiдмiтки про час цього запису}
var Hour,Min,sec,sec100:word;
     f:text;
begin
      Melody;
      GetTime(Hour,Min,sec,sec100);
      assign(f,'comments');
      append(f);
      writeln(f,'Time Label - ',Hour,':',Min,':',sec);
      writeln(f);
     close(f);
end;
{----------------------------------------------------------------------}


Procedure SerIVMeasure;
var i0,ir:byte;
    st,st_t:string;
    T,Ts:single;
    time0,time1:longint;
begin
Tsample:=0;
time0:=MTime;
IVmeasure;
i0:=1;
repeat
T:=TempDeterm(0);
time1:=MTime;
Ts:=Tsample;
MD.Init;
MD.Title('Serial I-V Measurements');
MD.LineMenu;
if Par^.SerPar.time then
      begin
      MD.AddItem('Type - time dependence');
      Str(Par^.SerPar.delTime,st);
      MD.Row:=MD.Row-15;
      MD.AddItem('Interval - '+st+' min');

      end
                    else
      begin
      MD.AddItem('Type - temperature dependence');
      Str(Par^.SerPar.delT:3:1,st);
      MD.Row:=MD.Row-15;
      MD.AddItem('Interval - '+st+' K');
      end;
MD.LineMenu;
SetColor(lightred);
ir:=MD.Row;
MD.AddItem('Sample current temperature, K:');
MD.Row:=MD.Row-15;
MD.AddItem('Last measurement temperature, K:');
MD.Row:=MD.Row-15;
MD.AddItem('Time from last measuremet, min:');
SetColor(green);
MD.LineMenu;
MD.AddItem('F1 - extraordinary measurement');
MD.Row:=MD.Row-15;
MD.AddItem('F2 - serial parameters');
MD.Row:=MD.Row-15;
MD.AddItem('F3 - time label writing');
MD.Row:=MD.Row-15;
MD.AddItem('ESC - Exit');

SetColor(yellow);
Str(T:3:1,st);
Str(Tvymir,st_t);
OutTextXY(560,ir,st);
OutTextXY(540,ir-50,st_t);
Str(trunc((time1-time0)/60),st);
OutTextXY(560,ir+2*MD.dRow-30,st);
SetColor(lightblue);
if Tsample=0 then st:='non' else Str(Tsample:3:1,st);
OutTextXY(560,ir+MD.dRow-15,st);
Mel;
if Par^.SerPar.time then
       if (((time1-time0)/60) >Par^.SerPar.delTime) then
              begin
              time0:=time1;
              IVmeasure;
              end;
if not(Par^.SerPar.time) then
       if (abs(T-Tsample)>Par^.SerPar.delT)and(Tsample<>0) then
              begin
              time0:=time1;
              IVmeasure;
              end;

delay(5000);
if keypressed then
  begin
  i0:=ord(ReadKey);
  if i0=0 then
    begin
    i0:=ord(ReadKey);
    case i0 of
      59:begin
           time0:=time1;
           IVmeasure;
         end;
      60: MenuSerialPar;
      61: TimeLabel;
      end; {case}
    end; {begin}
  end;

until(i0=27);

end;
{----------------------------------------------------------------------}

Procedure MenuSerial;
var i0:byte;
begin
repeat
MD.Init;
MD.Title('SERIAL I-V MEASUREMENT');
MD.LineMenu;
MD.AddItem('F1 - PARAMETERS OF SERIAL MEASUREMENT');
MD.AddItem('F2 - BEGINNING');
MD.AddItem('ESC - EXIT');
i0:=FunReadKey;
case i0 of
     59:MenuSerialPar;
     60:SerIVMeasure;
   end;
until (i0=27);
end;
{----------------------------------------------------------------------}

Procedure Kalibrovka;
var f:text;
    U:Pkalb;
    i:byte;
    brk:boolean;
label 1;

Procedure Kalibr(U1,U2,delU:real;g:integer; var a,b,c:single; var brk:boolean);
var i,j:word;
    x:Pvector;
    u,r:real;
    Xmax:integer;
    s,sU:string;
    napr:single;

begin
napr:=UNITB.VymirData;

if (UNITB.Tp<>'V')or(UNITB.AUTO)or(UNITB.AC)or(UNITB.diap<>1)
                          then begin
                               Pomulka('to turn on voltmetr correctly');
                               brk:=true;
                               exit
                               end;
new(x);j:=0;
U:=U1;
Setcolor(yellow);
Rectangle(round(0.1*GetMaxX),100,round(0.9*GetmaxX),120);
xmax:=trunc((u2-u1)/delU)+1;
SetFillStyle(1,yellow);
brk:=false;

repeat

j:=j+1;
NaprugaADA(U);

setcolor(yellow);
Str(U:5:3,s);
outtextXY(400,250,s);

r:=0;
for i:=1 to 10 do
    begin
    x^.x[j]:=VumirADA(g,0);
    r:=r+x^.x[j];
    end;
x^.x[j]:=round(r*10000)/100000;

Str(x^.x[j]:5:3,s);
outtextXY(400,300,s);

delay(1000);

setcolor(GetBkColor);
Str(napr:5:3,s);
outtextXY(400,350,s);


napr:=UNITB.VymirData;

setcolor(yellow);
Str(napr:5:3,s);
outtextXY(400,350,s);

x^.y[j]:=x^.x[j]-round(napr*1000)/1000;

bar(round(0.1*GetMaxX),100,round(0.1*GetMaxX+0.8*GetmaxX/xmax*j),120);

setcolor(GetBkColor);
Str(U:5:3,s);
outtextXY(400,250,s);
Str(x^.x[j]:5:3,s);
outtextXY(400,300,s);


U:=U+delU;
Mel;


if KeyPressed then i:=ord(ReadKey);

until(U>U2)or(i=27);

x^.n:=j;
ParabAprox(x,a,b,c);

SetFillStyle(1,GetBkColor);
Bar(round(0.1*GetMaxX),100,GetmaxX,120);

dispose(x);
brk:=(i=27);
end;


BEGIN
new(U);

ClearDevice;
setcolor(lightcyan);
SetTextJustify(LeftText,CenterText);
SetTextStyle(DefaultFont,HorizDir,2);
OutTextXY(150,50,'DO NOT FORGET!!!');
setcolor(green);
OutTextXY(50,100,'1.join voltmetr');
OutTextXY(50,130,'2.push  RS232C');
OutTextXY(50,160,'3.select required range');
readln;
ClearDevice;

SetColor(magenta);
SetTextStyle(DefaultFont,HorizDir,2);
MoveTo(200,50);
outtext('CALIBRATION');

SetColor(green);
OutTextXY(200,450,'Esc to Exit');
Ellipse(300,250,0,360,70,70);

Kalibr(0.95,3.5,0.05,1,U^[3,1],U^[3,2],U^[3,3],brk);
if brk then goto 1;

setcolor(green);
SetFillStyle(1,green);
Sector(300,250,0,90,70,70);

Kalibr(-3.5,-0.95,0.05,1,U^[4,1],U^[4,2],U^[4,3],brk);
if brk then goto 1;

setcolor(green);
SetFillStyle(1,green);
Sector(300,250,0,180,70,70);

Kalibr(0.002,0.94,0.02,2,U^[1,1],U^[1,2],U^[1,3],brk);
if brk then goto 1;

setcolor(green);
SetFillStyle(1,green);
Sector(300,250,0,270,70,70);

Kalibr(-0.94,-0.002,0.02,2,U^[2,1],U^[2,2],U^[2,3],brk);
if brk then goto 1;

setcolor(green);
SetFillStyle(1,green);
Sector(300,250,0,359,70,70);

assign(f,Katalog+'kalibr.dat');
rewrite(f);
for i:=1 to 4 do writeln(f,U^[i,1]:8,' ',U^[i,2]:8,' ',U^[i,3]:8);
close(f);

1:
Melody;
NaprugaADA(0);
dispose(U);
end;{Kalibrovka}
{____________________________________________________}

Function MTime:longint;
{возвращает число секунд текущего времени}
var Hour,Minute,Second,Sec100:word;
begin
   GetTime(Hour,Minute,Second,Sec100);
   MTime:=3600*Hour+60*Minute+Second;
end;
{____________________________________________________}


Procedure PROGREV;
var i:integer;
    sMinute,sSecond:string;
    Minute,Second:word;
    U:single;
    a,a1:longint;

BEGIN
a1:=MTime+5*60;
NaprugaADA(0);

MD.Init;
OutTextXY(210,300,'Esc - Exit');

SetColor(lightblue);
SetTextStyle(DefaultFont,HorizDir,3);
OutTextXY(190,100,'WARMING UP');

repeat
U:=UmVumirADA(0);

setcolor(GetBkColor);
outtextXY(240,200,sMinute+':'+sSecond);

a:=Mtime;
Minute:=trunc((a1-a)/60);
Second:=round(a1-a-Minute*60);
setcolor(yellow);
Str(Minute,sMinute);
Str(Second,sSecond);
outtextXY(240,200,sMinute+':'+sSecond);

if KeyPressed then i:=ord(ReadKey);
Mel;
until (a>a1)or(i=27);
Melody;
end; {PROGREV}
{_________________________________________________________}

Procedure VaxParam(a:Pvector;sfile:string;T:single);
var i,c0:integer;
    Isc,Voc,Kf,Pm,U,U1,U2,x,x1:single;
    f:text;
    s1:string;
    SR:SearchRec;
    bool,boolV,boolI:boolean;

   Function Y_X0 (X1,Y1,X2,Y2:single):single;
    begin
    Y_X0:=(Y2*X1-Y1*X2)/(X1-X2);
    end;

   Function X_Y0 (X1,Y1,X2,Y2:single):single;
    begin
    X_Y0:=(Y2*X1-Y1*X2)/(Y2-Y1);
    end;

BEGIN

if a^.n<2 then exit;

boolV:=false;boolI:=false;
i:=2;
repeat
 if ((a^.x[i]>0)or(a^.x[i]=0))and(a^.x[i-1]<0) then
   begin
   Isc:=-Y_X0(a^.x[i],a^.y[i],a^.x[i-1],a^.y[i-1]);
   boolI:=true;
   end;
 if (a^.y[i]>0)and(a^.y[i-1]<0) then
   begin
   Voc:=X_Y0(a^.x[i],a^.y[i],a^.x[i-1],a^.y[i-1]);
   boolV:=true;
   end;
 i:=i+1;
until ((boolI)and(boolV)) or (i>a^.n);

if (not(boolI))or(Voc<0.02) then exit;

Pm:=a^.x[1]*a^.y[1];
for i:=2 to a^.n do if Pm>a^.x[i]*a^.y[i] then Pm:=a^.x[i]*a^.y[i];
Pm:=-Pm;
Kf:=Pm/Isc/Voc;



SetTextJustify(LeftText,CenterText);
SetTextStyle(DefaultFont,HorizDir,2);
setcolor(white);
Str(T:4:1,s1);
outtextXY(70,70,'T='+s1+' K');
Numstring(Isc,s1);
outtextXY(70,110,'Isc='+s1+' A');
Str(Voc:4:3,s1);
outtextXY(70,90,'Voc='+s1+' B');
Numstring(Pm,s1);
outtextXY(70,130,'Pm='+s1+' W');
Str(Kf:4:3,s1);
outtextXY(70,150,'Kf='+s1);

setcolor(green);
outtextxy(220,410,'ESC - вихiд');
Melody;

 repeat
 c0:=ord(ReadKey);
 if c0=0 then c0:=ord(ReadKey);
 until (c0=27);

if c0=27 then
     begin
     assign(f,'rez');
     FindFirst('rez',AnyFile,SR);
     if DosError<>0 then rewrite(f) else append(f);
     writeln(f,sfile,' ',T:4:1,' ',Voc:4:3,' ',Isc:12,' ',Pm:12,' ',Kf:4:3);
     close(f);
     end;

end;
{------------------------------------------------}


Procedure Opir (i:byte);
begin
case i of
 0:TTLOutADA (0,0,0,0,0,0,0,0);
 1:TTLOutADA (0,0,0,0,0,0,0,1);
 2:TTLOutADA (0,0,0,0,0,0,1,0);
 3:TTLOutADA (0,0,0,0,0,1,0,0);
 4:TTLOutADA (0,0,0,0,1,0,0,0);
 5:TTLOutADA (0,0,0,1,0,0,0,0);
  end;
end;

begin
SetCBreak(True);

end .

