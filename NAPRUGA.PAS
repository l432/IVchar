program UT_demo;
uses ada1292,VAX_UN2N,Oleg,Crt,Graph;
var {a:UT_date;
    b:UT_kod;}
    f:text;
    s1,s2:string;
    color:word;
    i:integer;
    b1:byte;
    U1:single;
    param:PVax_parA;

BEGIN

BeginingADA;

new(param);

VaxParRead('UprA.dat',param);

MyInitGraph;
ClearDevice;
SetTextJustify(LeftText,CenterText);
SetTextStyle(DefaultFont,HorizDir,4);


repeat

setcolor(lightred);
moveto(100,150);

U1:=UmVumirADA(0);
U1:=KalibPerevod(U1,param^.popr);

      Str(-U1:5:3,s1);
      outtext(s1);
      delay(500);
      color:=GetBkColor;
      Setcolor(color);
      moveto(100,150);
      outtext(s1);
until(keypressed);

CloseGraph;
dispose(param);

END.