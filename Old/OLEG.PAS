{$S+}
unit Oleg;
interface
uses Crt,Graph,Dos;
type Vector=record                     {змўнна для побудови графўкўв}
            X:array[1..2000] of single; {n - кўлькўсть точок графўку}
            Y:array[1..2000] of single{real};
            n:1..1000;
            end;
       Pvector=^vector;
       dva=0..1;
       CHvector=array[1..4] of Pvector;
       CHvkaz=array[1..4] of dva;
       CHSngl=array[1..4] of single;

CONST WmaxX=511; {константы для границ, которые занимает график}
      WmaxY=383;
      WX0=64;
      WY0=431;

procedure Swap (var a:single{real}; var b:single{real});
{обмўн знўченяями мўж А ў В}

procedure SwapInt (var a:integer; var b:integer);

procedure MyInitGraph;
{ўнўцўалўзацўя графўчного режиму; при цьому графўчний
 драйвер повинен знаходитись у директорў∙ D:\oleg\BP\BGI}

procedure Max_Min (a:pvector; var XMax,XMin,YMax,YMin:single{real});
{визначення максимально∙ ў мўнўмально∙ величини координат x i y}

procedure Waiting;
{машина чекаї поки буде натиснута будь-яка клавўша}

procedure NumString (N:real; var S:string);
{процедура перетворення числа в string: X.XXX в 'X.XX'
 використовуються три значущў цифри}

procedure GrafPar (a:pvector;var Xmax,Xmin,Ymax,Ymin:single);
{обчислюються максимальнў величини майбутнього графўка}

procedure GrafPar2 (a,b:pvector;var Xmax,Xmin,Ymax,Ymin:single{real});

procedure GrafPar4 (a:CHvector;b:CHvkaz;var Xmax,Xmin,Ymax,Ymin:single);
{вўдмўна вўд попереднўх - можливе майбутнї
вўдображення вўд одного до чотирьох графўкўв}

Procedure Osi(Xmax,Xmin,Ymax,Ymin:single; var err:byte);
{будуються осў майбутнього графўка та пўдписи на них}

Procedure GPixel (a:Pvector;Xmin,Ymin,Xmax,Ymax:single;color:word);
{ставить точки графўка у виглядў точечок}
Procedure GCircle (a:Pvector;Xmin,Ymin,Xmax,Ymax:single;color:word);
{ставить точки графўка у виглядў замальованих кружечкўв}
Procedure GPoint (a:Pvector;Xmin,Ymin,Xmax,Ymax:single;color:word);
{ставить точки графўка у виглядў кружечкўв}
Procedure GLine (a:Pvector;Xmin,Ymin,Xmax,Ymax:single;color:word);
{будуї графўк у виглядў лўнўi}

procedure Grafic (A:pvector);
{будуїться графўк по заданим точкам, маї бути ўнўцўйований
графўчний режим, щоб зображення втрималось на екранў
потрўбно додавати щось типу readln}

procedure Grafic_a (A:pvector);
{будуїться графўк по заданим точкам, вўдмўннўсть вўд попередньо∙ в тому,
що графўк зображуїться не точками а кружечками}

Procedure Graf4_a(a:CHvector;b:CHvkaz);
{вўдмўна вўд попереднўх - можливе майбутнї
вўдображення вўд одного до чотирьох графўкўв}

procedure Grafic2 (A,B:pvector);
{будуїться два графўки по двом заданим масивам точок}

procedure Grafic2_a (A,B:pvector);
{будуїться два графўки по двом заданим масивам точок, вўдмўннўсть вўд
попередньо∙ в тому, що графўки зображуїться не точками а кружечками}

Procedure GrObr (a:pvector;var x1,x2:integer;var x11:real);
{будуїться графўк по заданим точкам ў можливий його аналўз
за домомогою маркера
натискуїш '6' - рух вправо до наступн∙ точки
натискуїш '4' - рух влўво до наступн∙ точки
натискуїш '8' - рух вправо на десять точок
натискуїш '2' - рух влўво на десять точок
натискуїш 'L' - графўк в лўнўях
натискуїш 'C' - графўк в кружечках
натискуїш пробўл - порядковий номер точки
                   де знаходиться маркер
                   записуїться в х1 (х2)
                   координата точки в х11}
Procedure GrObr1 (a:pvector;var x1:integer);
Procedure GrObr2 (a:pvector;var x11:real);

Procedure PointLine(x,y,Xmax,Xmin,Ymax,Ymin:single;col,col1:word);
{будуї зафарбований кольором col кружечок всерединў експериментально∙
точки (х,у) та проводить лўнўю через цю точку кольором col1,
використовуїться в процедурах обробки графўкўв}




function Kod(a1,a2,a3,a4,a5,a6,a7,a8:dva):integer;
{пўдраховуї число, необхўдне для передачў на ТТЛ виходи}

procedure GrRead(var s:string);
{процедура зчитування слова в графўчному режимў з його
одночасним виведенням на екран, можна стирати BackSpase-ом;
але необхўдно, щоб був включений графўчний режим а також
потрўбно за допомогою MoveTo поставити курсор в потрўбну точку}

procedure GrReadLong(var s:string);
{процедура, подўбна до попередньо∙, тўльки вона дозволяї вводити
довгў речення, розташовуючи у одному рядку по 30 знакўв}

procedure POMULKA (s:string);
{виводить на їкран червоний мигаючий напис 's'
Маї бутиўнўцўйований графўчний режим}

procedure Pauza;
{виводить в нижнўй частинў екрану мигаючий напис 'П А У З А ! ! !'
до тих пўр, доки не буде натиснутий Enter. Маї бути
ўнўцўйований графўчний режим}

function min(a,b:real):real;
{визначаї найменше з двох чисел}

procedure Last(s:string; var title:string);
{процедура, що визначаї ўм'я останнього за часом створення
файлу в каталозў s (в s крўм шляху потрўбно помўстити маску
типу *.dat для пошуку файлўв певних типўв) ў помўщаї його в title}

procedure myline(x:integer);
{процедура проводить вертикальну лўнўю в точцў з координатою х}

Procedure lognat (a:Pvector; var b:Pvector);
{Логарифмування масиву а, результат записуїться в b}

Procedure LinAprox (v:Pvector; var a,b:single);
{апроксимацўя масиву значень лўнўйною залежнўстю
y=a+b*x}

Procedure ParabAprox (v:Pvector; var a,b,c:single);
{априксимацўя масиву a*x2+b*x+c}

function T_CuKo(a:real):real;
{функция расчета температури по значениям напряжения
согласно градуировке термопары медь-константан}


implementation

procedure Swap;
  var C:real;
begin
  C:=A; A:=B; B:=C;
end;

procedure SwapInt;
  var C:integer;
begin
  C:=A; A:=B; B:=C;
end;


 procedure MyInitGraph;
  var
    GraphDriver : integer;
    GraphMode   : integer;
    ErrorCode   : integer;
   begin
    GraphDriver := Detect;
    InitGraph (GraphDriver,GraphMode,'D:\oleg\BP\BGI');
    ErrorCode:=GraphResult;
     if ErrorCode <> 0 then
     begin
      Writeln ('Ошибка графики: ',GraphErrorMsg(ErrorCode));
      Writeln ('Программа завершена');
      Halt (1);
     end;
     end;

procedure Max_Min;
var i:1..2000;
begin
  XMax:=A^.X[1]; XMin:=A^.X[1];
  YMax:=A^.Y[1]; YMin:=A^.Y[1];
  for i:=1 to A^.n do
     begin
       If A^.X[i]>XMax then XMax:=A^.X[i];
       If A^.X[i]<XMin then XMin:=A^.X[i];
       If A^.Y[i]>YMax then YMax:=A^.Y[i];
       If A^.Y[i]<YMin then YMin:=A^.Y[i];
     end;

end;


procedure Waiting;
begin
IF ReadKey=#0 then ReadKey;
end;


procedure NumString;
var s1:string;
BEGIN
if (abs(N)<10)and(abs(N)>=0.1) then Str(N:4:2,s);
if (abs(N)<100)and(abs(N)>=10) then Str(N:4:1,s);
if (abs(N)>100)or(abs(N)<0.1) then
 begin
 Str(N:11,s);
 s1:=copy(s,pos('E',s),length(s)-pos('E',s)+1);
 delete(s,pos('E',s),length(s)-pos('E',s)+1);
 while Pos('0',s1)>0 do delete(s1,Pos('0',s1),1);
 s1[Pos('E',s1)]:='e';
 if Pos('+',s1)>0 then delete(s1,Pos('+',s1),1);
 s:=s+s1;
 if Pos(' ',s)>0 then delete(s,Pos(' ',s),1);
 end;
if N=0 then S:='0';
END;

Procedure Osi(Xmax,Xmin,Ymax,Ymin:single; var err:byte);
var WdX,WdY,i:integer;
    s1:string;
BEGIN
 err:=0;
 if ((Xmax=Xmin)) then
                 begin
                 err:=1;
                 Pomulka('ЦЕ НЕ ГРАФIК');
                 exit;
                 end;

  if (Ymax=Ymin) then begin Ymax:=Ymax+0.1*Ymax;
                            Ymin:=Ymin-0.1*Ymin;
                            if Ymax=0 then begin Ymax:=0.1;
                                                 Ymin:=-0.1;
                                            end;
                      end;

  ClearDevice;
  SetColor(green);
  line(WX0,WY0,WX0,WY0-WmaxY);
  line(WX0,WY0,WX0+WmaxX,WY0);
  line(WX0+WmaxX,WY0-WmaxY,WX0,WY0-WmaxY);
  line(WX0+WmaxX,WY0,WX0+WmaxX,WY0-WmaxY);
  WdX:=round(WmaxX/4);WdY:=round(WmaxY/4);
  for i:=1 to 4 do
    begin
      line(WX0,(WY0-i*WdY),(WX0+5),(WY0-i*WdY));
      myline(WX0+i*WdX);
      line((WX0+i*WdX),WY0,(WX0+i*WdX),(WY0-5));
    end;
  SetColor(magenta);
  SetTextStyle(GothicFont,HorizDir,1);

  for i:=0 to 4 do
    begin
      NumString((Xmin+i*(Xmax-Xmin)/4),s1);
      SetTextJustify(CenterText,CenterText);
      OutTextXY((WX0+i*WdX),round(0.95*GetMaxY),s1);
      NumString((Ymin+i*(Ymax-Ymin)/4),s1);
      SetTextJustify(0,1);
      OutTextXY(0,(WY0-i*WdY),s1);
    end;
END;

Procedure GPixel (a:Pvector;Xmin,Ymin,Xmax,Ymax:single;color:word);
var i:integer;
begin
for i:=1 to A^.n do
       PutPixel(WX0+round(WmaxX*(A^.X[i]-Xmin)/(Xmax-Xmin)),
               WY0-round(WmaxY*(A^.Y[i]-Ymin)/(Ymax-Ymin)),color);
end;


Procedure GCircle (a:Pvector;Xmin,Ymin,Xmax,Ymax:single;color:word);
var i:integer;
begin
setcolor(color);
setfillstyle(1,color);
for i:=1 to A^.n do
       pieslice(WX0+round(WmaxX*(A^.X[i]-Xmin)/(Xmax-Xmin)),
               WY0-round(WmaxY*(A^.Y[i]-Ymin)/(Ymax-Ymin)),0,360,2);
end;

Procedure GPoint (a:Pvector;Xmin,Ymin,Xmax,Ymax:single;color:word);
var i:integer;
begin
setcolor(color);
for i:=1 to A^.n do
       ellipse(WX0+round(WmaxX*(A^.X[i]-Xmin)/(Xmax-Xmin)),
               WY0-round(WmaxY*(A^.Y[i]-Ymin)/(Ymax-Ymin)),0,360,3,3);
end;

Procedure GLine (a:Pvector;Xmin,Ymin,Xmax,Ymax:single;color:word);
var i:integer;
begin
setcolor(color);
for i:=1 to (A^.n-1) do
       line(WX0+round(WmaxX*(A^.X[i]-Xmin)/(Xmax-Xmin)),
            WY0-round(WmaxY*(A^.Y[i]-Ymin)/(Ymax-Ymin)),
            WX0+round(WmaxX*(A^.X[i+1]-Xmin)/(Xmax-Xmin)),
            WY0-round(WmaxY*(A^.Y[i+1]-Ymin)/(Ymax-Ymin)))

end;


Procedure GrafPar;
BEGIN
  MAX_MIN(A,Xmax,Xmin,Ymax,Ymin);
END;


Procedure Grafic;
var Xmax,Xmin,Ymax,Ymin:single{real};
    err:byte;

BEGIN
GrafPar (a,Xmax,Xmin,Ymax,Ymin);
Osi(Xmax,Xmin,Ymax,Ymin,err);
if err<>0 then exit;
GPixel(a,Xmin,Ymin,Xmax,Ymax,lightcyan)
END;

Procedure Grafic_a;
var Xmax,Xmin,Ymax,Ymin:single{real};
    err:byte;
BEGIN
GrafPar (a,Xmax,Xmin,Ymax,Ymin);
Osi(Xmax,Xmin,Ymax,Ymin,err);
if err<>0 then exit;
GCircle(A,Xmin,Ymin,Xmax,Ymax,yellow);
END;

Procedure GrafPar2;
var Xmax1,Xmin1,Ymax1,Ymin1:single{real};
BEGIN
  MAX_MIN(A,Xmax,Xmin,Ymax,Ymin);
  MAX_MIN(B,Xmax1,Xmin1,Ymax1,Ymin1);
  if Xmax1>Xmax then Xmax:=Xmax1;
  if Ymax1>Ymax then Ymax:=Ymax1;
  if Xmin1<Xmin then Xmin:=Xmin1;
  if Ymin1<Ymin then Ymin:=Ymin1;
END;

procedure GrafPar4;
var l:integer;
    Xma,Xmi,Yma,Ymi:array[1..4] of single{real};
BEGIN
  for l:=1 to 4 do
        if b[l]=1 then MAX_MIN(A[l],Xma[l],Xmi[l],Yma[l],Ymi[l]);
  for l:=1 to 4 do begin
   if b[l]=1 then begin
                 Xmax:=Xma[l];
                 Xmin:=Xmi[l];
                 Ymax:=Yma[l];
                 Ymin:=Ymi[l];
                 end;
                   end;
  for l:=1 to 4 do
    begin
     if (b[l]=1) and (Xma[l]>Xmax) then Xmax:=Xma[l];
     if (b[l]=1) and (Xmi[l]<Xmin) then Xmin:=Xmi[l];
     if (b[l]=1) and (Yma[l]>Ymax) then Ymax:=Yma[l];
     if (b[l]=1) and (Ymi[l]<Ymin) then Ymin:=Ymi[l];
   end;
END;


Procedure Grafic2;
var Xmax,Xmin,Ymax,Ymin:single{real};
    err:byte;

BEGIN
GrafPar2 (a,b,Xmax,Xmin,Ymax,Ymin);
Osi(Xmax,Xmin,Ymax,Ymin,err);
if err<>0 then exit;
GPixel(A,Xmin,Ymin,Xmax,Ymax,lightcyan);
GPixel(B,Xmin,Ymin,Xmax,Ymax,lightblue)
END;


Procedure Graf4_a;
var Xmax,Xmin,Ymax,Ymin:single{real};
    col:array[1..4] of word;
    l,err:byte;
BEGIN
GrafPar4(a,b,Xmax,Xmin,Ymax,Ymin);
Osi(Xmax,Xmin,Ymax,Ymin,err);
if err<>0 then exit;

col[1]:=yellow;
col[2]:=red;
col[3]:=lightblue;
col[4]:=lightgreen;

for l:=1 to 4 do
  if b[l]=1 then GCircle(A[l],Xmin,Ymin,Xmax,Ymax,col[l]);
END;


Procedure Grafic2_a;
var Xmax,Xmin,Ymax,Ymin:single{real};
    err:byte;

BEGIN
GrafPar2 (a,b,Xmax,Xmin,Ymax,Ymin);
Osi(Xmax,Xmin,Ymax,Ymin,err);
if err<>0 then exit;
GCircle(A,Xmin,Ymin,Xmax,Ymax,yellow);
GCircle(B,Xmin,Ymin,Xmax,Ymax,red);
END;



Function Kod;
const c1=1;
      c2=2;
      c3=4;
      c4=8;
      c5=16;
      c6=32;
      c7=64;
      c8=128;
begin
 Kod:=a1*c1+a2*c2+a3*c3+a4*c4+a5*c5+a6*c6+a7*c7+a8*c8;
end;

Procedure GrRead;
var ch:char;
    a,x,y:integer;
    col:word;
begin
  s:='';
  SetTextStyle(DefaultFont,HorizDir,2);
  SetTextJustify(LeftText,CenterText);
  col:=GetColor;
  x:=GetX;
  y:=GetY;
  repeat
  ch:=ReadKey;
  a:=ord(ch);
  if a in [8,45,48..57,65..90,97..122] then
     begin
     setcolor(GetBkColor);
     OutTextXY(x,y,s);
     case a of
       45,48..57,65..90,97..122:s:=s+ch;
       8:if length(s)>0 then delete(s,length(s),1);
       end;
     setcolor(col);
     OutTextXY(x,y,s);
     end;
  if a=27 then begin s:=''; exit end;
until (a=13);
end;

procedure GrReadLong;
var ch:char;
    a,len,x,y,l1,len1:integer;
    s1:string;

  procedure del(var s:string);
    var s1:string;
        col:word;
        len:integer;


  begin
    len:=length(s);
    s1:=copy(s,len,1);
    delete(s,len,1);
    MoveRel(-16,0);
    col:=GetColor;
    SetColor(GetBkColor);
    OutText(s1);
    MoveRel(-16,0);
    SetColor(col);
  end;


begin
  s:='';
  x:=GetX;y:=GetY;
  l1:=0;
  SetTextStyle(DefaultFont,HorizDir,2);
  SetTextJustify(LeftText,CenterText);
  ch:=ReadKey;
  a:=ord(ch);
  while a<>13 do
  begin
    len:=length(s)-l1*30;
    if len>29 then
      begin
      l1:=l1+1;
      moveto(0,y+20*l1);
      end;
    if a=8 then
      begin
        len:=length(s);
        if len>0 then
        begin
          len1:=len-l1*30;
          if (l1=1) and (len1=0) then
            begin
              moveto(x+30*16,y);
              l1:=l1-1;
              del(s);
            end;
           if (l1>1) and (len1=0) then
            begin
              moveto(30*16,y+(l1-1)*20);
              l1:=l1-1;
              del(s);
            end;
          if (len1>0) then del(s);
        end;
      end
           else
       begin
         s:=s+ch;
         OutText(ch);
       end;
   ch:=ReadKey;
   a:=ord(ch);
  end;
end;



Procedure Pomulka;
var i:integer;
    color:word;
begin
ClearDevice;
    color:=GetColor;
    SetTextStyle(DefaultFont,HorizDir,2);
    for i:=1 to 5 do
      begin
        setcolor(LightRed);
        OutTextXY(150,200,s);
        sound(700);
        delay(200);
        setcolor(GetBkColor);
        OutTextXY(150,200,s);
        nosound;
        delay(200);
      end;
SetColor(color);
ClearDevice;
end;

procedure Pauza;
var i,x1,y1:integer;
    color:word;
begin
  x1:=GetX;y1:=GetY;
  color:=GetColor;
  SetTextJustify(LeftText,CenterText);
  SetTextStyle(DefaultFont,HorizDir,2);
  repeat
    setcolor(LightRed);
    OutTextXY(150,400,'П А У З А ! ! !');
    delay(200);
    setcolor(GetBkColor);
    OutTextXY(150,400,'П А У З А ! ! !');
    delay(200);
  if keypressed then i:=ord(ReadKey);

  until (i=13);
  SetColor(color);Moveto(x1,y1);
end;


Procedure GrObr;
var WX,WY,i,lx,li,c:integer;
    Xmax,Xmin,Ymax,Ymin:single{real};
    s1,s2,s3,s4:string;
    err:byte;
    ch:char;
    dv:1..2;
BEGIN
  GrafPar (a,Xmax,Xmin,Ymax,Ymin);
  Osi(Xmax,Xmin,Ymax,Ymin,err);
  if err<>0 then  exit;
  GPoint(A,Xmin,Ymin,Xmax,Ymax,white);

  li:=round(A^.n/2);
    WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
    WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
    setcolor(yellow);
    setfillstyle(1,yellow);
    pieslice(WX0+WX,WY0-WY,0,360,2);
  lx:=WX0+round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
  setcolor(red);
  myline(lx);
   s3:='';
   s4:='';
   SetColor(cyan);
 SetTextJustify(LeftText,CenterText);
 SetTextStyle(DefaultFont,HorizDir,1);
 outtextXY(50,20,'X1=');
 outtextXY(50,35,'X2=');
  SetColor(green);
 SetTextStyle(DefaultFont,HorizDir,2);
 dv:=1;
 outtextXY(400,80,'X1=');
 Str(li,s1);
 outtextXY(450,80,s1);
 outtextXY(400,100,'X2=');

  repeat
  ch:=ReadKey;
  c:=ord(ch);
  case c of
  108:begin
        GPoint(A,Xmin,Ymin,Xmax,Ymax,GetBkColor);
        GLine (A,Xmin,Ymin,Xmax,Ymax,white);
      end;
  99: begin
       GLine (A,Xmin,Ymin,Xmax,Ymax,GetBkColor);
       GPoint(A,Xmin,Ymin,Xmax,Ymax,white);
      end;
  54: begin SetColor(GetBkColor);myline(lx);
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setfillstyle(1,GetBkColor);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            case dv of
            1: begin
               MoveTo(450,80);
               outtext(s1);
               end;
            2: begin
               MoveTo(450,100);
               outtext(s2);
               end;
            end;
            setcolor(white);
            ellipse(WX0+WX,WY0-WY,0,360,3,3);
            li:=li+1;if li>a^.n then li:=1;
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setcolor(yellow);
            setfillstyle(1,yellow);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            lx:=WX0+round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            setcolor(red);
            myline(lx);
            SetColor(green);
            case dv of
            1: begin
               MoveTo(450,80);
               Str(li,s1);
               outtext(s1);
               end;
            2: begin
               MoveTo(450,100);
               Str(li,s2);
               outtext(s2);
               end;
            end;
       end;
  52: begin SetColor(GetBkColor);myline(lx);
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setfillstyle(1,GetBkColor);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            case dv of
            1: begin
               MoveTo(450,80);
               outtext(s1);
               end;
            2: begin
               MoveTo(450,100);
               outtext(s2);
               end;
            end;
            setcolor(white);
            ellipse(WX0+WX,WY0-WY,0,360,3,3);
            li:=li-1;if li<1 then li:=a^.n;
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setcolor(yellow);
            setfillstyle(1,yellow);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            lx:=WX0+round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            setcolor(red);
            myline(lx);
            SetColor(green);
            case dv of
            1: begin
               MoveTo(450,80);
               Str(li,s1);
               outtext(s1);
               end;
            2: begin
               MoveTo(450,100);
               Str(li,s2);
               outtext(s2);
               end;
            end;
       end;
  56: begin SetColor(GetBkColor);myline(lx);
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setfillstyle(1,GetBkColor);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            case dv of
            1: begin
               MoveTo(450,80);
               outtext(s1);
               end;
            2: begin
               MoveTo(450,100);
               outtext(s2);
               end;
            end;
            setcolor(white);
            ellipse(WX0+WX,WY0-WY,0,360,3,3);
            li:=li+10;if li>a^.n then li:=1;
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setcolor(yellow);
            setfillstyle(1,yellow);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            lx:=WX0+round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            setcolor(red);
            myline(lx);
            SetColor(green);
            case dv of
            1: begin
               MoveTo(450,80);
               Str(li,s1);
               outtext(s1);
               end;
            2: begin
               MoveTo(450,100);
               Str(li,s2);
               outtext(s2);
               end;
            end;
       end;
  50: begin SetColor(GetBkColor);myline(lx);
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setfillstyle(1,GetBkColor);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            MoveTo(450,80);
            outtext(s1);
            case dv of
            1: begin
               MoveTo(450,80);
               outtext(s1);
               end;
            2: begin
               MoveTo(450,100);
               outtext(s2);
               end;
            end;
            setcolor(white);
            ellipse(WX0+WX,WY0-WY,0,360,3,3);
            li:=li-10;if li<1 then li:=a^.n;
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setcolor(yellow);
            setfillstyle(1,yellow);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            lx:=WX0+round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            setcolor(red);
            myline(lx);
            SetColor(green);
            case dv of
            1: begin
               MoveTo(450,80);
               Str(li,s1);
               outtext(s1);
               end;
            2: begin
               MoveTo(450,100);
               Str(li,s2);
               outtext(s2);
               end;
            end;
       end;
  9: begin closegraph;halt(1);end;
  32:  begin
            case dv of
            1: begin
               x1:=li;x11:=a^.y[x1];
               SetTextStyle(DefaultFont,HorizDir,1);
               SetColor(GetBkColor);
               MoveTo(80,20);
               outtext(s3);
               SetColor(cyan);
               Str(x1,s3);
               MoveTo(80,20);
               outtext(s3);
               SetTextStyle(DefaultFont,HorizDir,2);
               SetColor(green);
               MoveTo(500,80);
               outtext('*');
               SetColor(GetBkColor);
               MoveTo(500,100);
               outtext('*');
               dv:=2;
               end;
            2: begin
               x2:=li;
               SetTextStyle(DefaultFont,HorizDir,1);
               SetColor(GetBkColor);
               MoveTo(80,35);
               outtext(s4);
               SetColor(cyan);
               Str(x2,s4);
               MoveTo(80,35);
               outtext(s4);
               SetTextStyle(DefaultFont,HorizDir,2);
               SetColor(green);
               MoveTo(500,100);
               outtext('*');
               SetColor(GetBkColor);
               MoveTo(500,80);
               outtext('*');
               dv:=1;
               end;
            end;
       end;
  end;
until (c=27);
  CloseGraph;
END;

Procedure PointLine(x,y,Xmax,Xmin,Ymax,Ymin:single;col,col1:word);
{будуї зафарбований кольором col кружечок всерединў експериментально∙
точки (х,у) та проводить лўнўю через цю точку кольором col1}
var WX,WY:integer;
begin
WX:=WX0+round(WmaxX*(x-Xmin)/(Xmax-Xmin));
WY:=WY0-round(WmaxY*(y-Ymin)/(Ymax-Ymin));
SetColor(col1);
myline(WX);
SetColor(col);
setfillstyle(1,col);
pieslice(WX,WY,0,360,2);
end;




Procedure GrObr1;
var WX,WY,i,lx,li,c:integer;
    Xmax,Xmin,Ymax,Ymin:single{real};
    s1,s3:string;
    ch:char;
    err:byte;

BEGIN
 GrafPar (a,Xmax,Xmin,Ymax,Ymin);
 Osi(Xmax,Xmin,Ymax,Ymin,err);
 if err<>0 then  exit;
 GPoint(A,Xmin,Ymin,Xmax,Ymax,white);

  li:=round(A^.n/2);
    WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
    WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
    setcolor(yellow);
    setfillstyle(1,yellow);
    pieslice(WX0+WX,WY0-WY,0,360,2);
  lx:=WX0+round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
  setcolor(red);
  myline(lx);
  s3:='';
   SetColor(cyan);
 SetTextJustify(LeftText,CenterText);
 SetTextStyle(DefaultFont,HorizDir,1);
 MoveTo(50,20);
 outtext('X1=');
  SetColor(green);
 SetTextStyle(DefaultFont,HorizDir,2);
 MoveTo(400,80);
 outtext('X1=');
 MoveTo(450,80);
 Str(li,s1);
 outtext(s1);
 x1:=a^.n;
 SetColor(lightgray);
 MoveTo(300,30);
 outtext('Будемо обрўзати? (n)');

  repeat
  ch:=ReadKey;
  c:=ord(ch);
  case c of
  110:begin c:=27;x1:=a^.n;end;
  108:begin
        GPoint(A,Xmin,Ymin,Xmax,Ymax,GetBkColor);
        GLine (A,Xmin,Ymin,Xmax,Ymax,white);
      end;
  99: begin
       GLine (A,Xmin,Ymin,Xmax,Ymax,GetBkColor);
       GPoint(A,Xmin,Ymin,Xmax,Ymax,white);
      end;
  54: begin SetColor(GetBkColor);myline(lx);
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setfillstyle(1,GetBkColor);
            pieslice(WX0+WX,WY0-WY,0,360,3);
               MoveTo(450,80);
               outtext(s1);

            setcolor(white);
            ellipse(WX0+WX,WY0-WY,0,360,3,3);
            li:=li+1;if li>a^.n then li:=1;
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setcolor(yellow);
            setfillstyle(1,yellow);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            lx:=WX0+round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            setcolor(red);
            myline(lx);
            SetColor(green);
               MoveTo(450,80);
               Str(li,s1);
               outtext(s1);
       end;
  52: begin SetColor(GetBkColor);myline(lx);
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setfillstyle(1,GetBkColor);
            pieslice(WX0+WX,WY0-WY,0,360,3);
               MoveTo(450,80);
               outtext(s1);
            setcolor(white);
            ellipse(WX0+WX,WY0-WY,0,360,3,3);
            li:=li-1;if li<1 then li:=a^.n;
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setcolor(yellow);
            setfillstyle(1,yellow);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            lx:=WX0+round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            setcolor(red);
            myline(lx);
            SetColor(green);
               MoveTo(450,80);
               Str(li,s1);
               outtext(s1);
       end;
  56: begin SetColor(GetBkColor);myline(lx);
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setfillstyle(1,GetBkColor);
            pieslice(WX0+WX,WY0-WY,0,360,3);
               MoveTo(450,80);
               outtext(s1);
            setcolor(white);
            ellipse(WX0+WX,WY0-WY,0,360,3,3);
            li:=li+10;if li>a^.n then li:=1;
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setcolor(yellow);
            setfillstyle(1,yellow);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            lx:=WX0+round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            setcolor(red);
            myline(lx);
            SetColor(green);
               MoveTo(450,80);
               Str(li,s1);
               outtext(s1);
       end;
  50: begin SetColor(GetBkColor);myline(lx);
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setfillstyle(1,GetBkColor);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            MoveTo(450,80);
            outtext(s1);
               MoveTo(450,80);
               outtext(s1);
            setcolor(white);
            ellipse(WX0+WX,WY0-WY,0,360,3,3);
            li:=li-10;if li<1 then li:=a^.n;
            WX:=round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            WY:=round(WmaxY*(A^.Y[li]-Ymin)/(Ymax-Ymin));
            setcolor(yellow);
            setfillstyle(1,yellow);
            pieslice(WX0+WX,WY0-WY,0,360,3);
            lx:=WX0+round(WmaxX*(A^.X[li]-Xmin)/(Xmax-Xmin));
            setcolor(red);
            myline(lx);
            SetColor(green);
               MoveTo(450,80);
               Str(li,s1);
               outtext(s1);
       end;
   9:  begin closegraph;halt(1);end;
  32:  begin
               x1:=li;
               SetTextStyle(DefaultFont,HorizDir,1);
               SetColor(GetBkColor);
               MoveTo(80,20);
               outtext(s3);
               SetColor(cyan);
               Str(x1,s3);
               MoveTo(80,20);
               outtext(s3);
               SetTextStyle(DefaultFont,HorizDir,2);
       end;
  end;
until (c=27);
  CloseGraph;
END;

Procedure GrObr2;
var i,c:integer;
    Xmax,Xmin,Ymax,Ymin,x:single{real};
    s1:string;
    ch:char;
    err:byte;
    f:text;
label 1;

BEGIN
1:
GrafPar (a,Xmax,Xmin,Ymax,Ymin);
Osi(Xmax,Xmin,Ymax,Ymin,err);
if err<>0 then exit;
GPoint(A,Xmin,Ymin,Xmax,Ymax,white);

  repeat
  c:=ord(ReadKey);
  case c of
  108:begin
        GPoint(A,Xmin,Ymin,Xmax,Ymax,GetBkColor);
        GLine (A,Xmin,Ymin,Xmax,Ymax,white);
      end;
  99: begin
       GLine (A,Xmin,Ymin,Xmax,Ymax,GetBkColor);
       GPoint(A,Xmin,Ymin,Xmax,Ymax,white);
      end;
   9: begin closegraph;halt(1);end;
  end;
until (c=27);
 SetColor(yellow);
SetTextJustify(LeftText,CenterText);
SetTextStyle(DefaultFont,HorizDir,2);
x:=x11;
outtextXY(20,300,'Вўднўмали');
setcolor(lightgreen);

assign(f,'d:\oleg\bp\exe\my');
reset(f);
read(f,s1);
close(f);

outtextXY(180,300,s1);
setcolor(red);
outtextXY(20,320,'тепер');
setcolor(lightgreen);
MoveTo(110,320);
GrRead(s1);
val(s1,x,i);
setcolor(lightred);
outtextXY(5,320,'*');
if x=0 then begin
              setcolor(lightgray);
              outtextXY(350,50,'Закўнчуїмо? (n)');
              ch:=readkey;
              end;
if ch='n' then goto 1;
x11:=x;
  CloseGraph;
END;



Function min;
begin
if a<b then min:=a
       else min:=b;
end;

Procedure Last;
var s1:SearchRec;
    t:longint;
label 10;
begin
title:='no file';
FindFirst(s,$3F,s1);
if Doserror<>0 then goto 10;
title:=s1.name;
t:=s1.time;
repeat
  FindNext(s1);
  if DosError=0 then
    if t<s1.time then
     begin
     title:=s1.name;
     t:=s1.time;
     end;
until(DosError<>0);
10:
end;

procedure myline;
begin
line(x,WY0-1,x,WY0-WmaxY+1);
end;

Procedure lognat;
var i{,n,j}:integer;
{label 13;}
begin
b^.n:=1;
for i:=1 to a^.n do
  if a^.y[i]>0 then
  begin
  b^.x[b^.n]:=a^.x[i];
  b^.y[b^.n]:=ln(a^.y[i]);
  b^.n:=b^.n+1;
  end;
b^.n:=b^.n-1;


{b^.n:=a^.n;
for i:=1 to a^.n do
           begin
           b^.x[i]:=a^.x[i];
           b^.y[i]:=a^.y[i];
           end;
 repeat
 n:=b^.n;
 for i:=1 to b^.n-1 do
    begin
    if (b^.y[i]=0)or(b^.y[i]<0) then
     begin  for j:=0 to b^.n-1 do  begin
                                     b^.x[i+j]:=b^.x[i+j+1];
                                     b^.y[i+j]:=b^.y[i+j+1];
                                end;
      b^.n:=b^.n-1;goto 13;
     end;
    end;
 if (b^.y[b^.n]=0)or(b^.y[b^.n]<0) then b^.n:=b^.n-1;
 13:
 until (n=b^.n);

for i:=1 to b^.n do b^.y[i]:=ln(b^.y[i]);}

end;

Procedure LinAprox;
var Sx,Sy,Sxy,Sx2:real;
    i:integer;
begin
Sx:=0;Sy:=0;Sxy:=0;Sx2:=0;
for i:=1 to v^.n do
   begin
   Sx:=Sx+v^.x[i];
   Sy:=Sy+v^.y[i];
   Sxy:=Sxy+v^.x[i]*v^.y[i];
   Sx2:=Sx2+v^.x[i]*v^.x[i];
   end;
a:=(Sx2*Sy-Sxy*Sx)/(v^.n*Sx2-Sx*Sx);
b:=(v^.n*Sxy-Sy*Sx)/(v^.n*Sx2-Sx*Sx);
end;

Procedure ParabAprox;
var Sx,Sy,Sxy,Sx2,Sx3,Sx4,Syx2,pr:single;
    i:integer;

begin
Sx:=0;Sy:=0;Sxy:=0;Sx2:=0;Sx3:=0;Sx4:=0;Syx2:=0;
 with V^ do begin
  for i:=1 to n do
   begin
   Sx:=Sx+x[i];
   Sy:=Sy+y[i];
   Sxy:=Sxy+x[i]*y[i];
   Sx2:=Sx2+sqr(x[i]);
   Sx3:=Sx3+sqr(x[i])*x[i];
   Sx4:=Sx4+sqr(sqr(x[i]));
   Syx2:=Syx2+sqr(x[i])*y[i];
   end;

pr:=Sx4*(n*Sx2-Sx*Sx)-Sx3*(n*Sx3-Sx*Sx2)+Sx2*(Sx3*Sx-Sx2*Sx2);
a:=(Syx2*(n*Sx2-Sx*Sx)-Sx3*(n*Sxy-Sx*Sy)+Sx2*(Sxy*Sx-Sx2*Sy))/pr;
b:=(Sx4*(n*Sxy-Sx*Sy)-Syx2*(n*Sx3-Sx*Sx2)+Sx2*(Sx3*Sy-Sx2*Sxy))/pr;
c:=(Sx4*(Sy*Sx2-Sx*Sxy)-Sx3*(Sy*Sx3-Sxy*Sx2)+Syx2*(Sx3*Sx-Sx2*Sx2))/pr;

 end;
end;

function T_CuKo(a:real):real;
{функция расчета температури по значениям напряжения
согласно градуировке термопары медь-константан}
begin
T_CuKo:=273.8+0.025*a-1.006e-6*a*a+1.625e-10*a*a*a;
end;



END.







