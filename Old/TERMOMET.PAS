Program Termometr;
uses CRt,ADA1292,Oleg,Graph;
var
    a:real;
    s,s1:string;

Function B721A:integer;
const min=0.2;
var c1:array[1..4] of single;
    c2:array[1..4] of byte;
    i:byte;
    bool:boolean;
    a:integer;
begin
repeat

{writeln;
write(c2[1]:4);
write(' ');
write(c2[2]:4);
write(' ');
write(c2[3]:4);
write(' ');
write(c2[4]:4);
write(' ');{}


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

{
write(c1[1]:4:3);
write(' ');
write(c1[2]:4:3);
write(' ');
write(c1[3]:4:3);
write(' ');
write(c1[4]:4:3);
write(' ');{}


{sound(200);
delay(50);
nosound;}


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
B721AVym:=(a+b)/2;
end;
{----------------------------------------------------------------------}



begin
{repeat
write(VumirADA (1,14));
Write(' ');
delay(200);
until (keypressed);

end.}

{}MyInitGraph;
SetTextStyle(DefaultFont,HorizDir,4);
SetTextJustify(LeftText,CenterText);{}

repeat
 a:=B721AVym;
{} setcolor(getbkcolor);
  OutTextXY(150,100,s);
  OutTextXY(150,200,s1);
 Str(a:4:0,s);
 s:=s+' mkV';
 setcolor(yellow);
 OutTextXY(150,100,s);
 setcolor(lightred);
 Str(T_CuKo(a):4:1,s1);
 s1:=s1+' K';
 OutTextXY(150,200,s1);{}
{ write(' ');
 write(a:4:1);{}

 sound(100);
delay(50);
nosound;
until keypressed;
{}CloseGraph;{}
ReadKey;

end.

