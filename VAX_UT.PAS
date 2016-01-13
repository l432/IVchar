{$S+}
program Begining;
uses Graph,Crt,Vax_UnUT;
var progr:byte;

Procedure MainMenu;
begin
MD.Init;
MD.Title('MAIN MENU');
MD.AddItem('F1  - PARAMETERS');
MD.AddItem('F2  - REFER POINT MEASUREMENT');
MD.AddItem('F3  - I-V MEASUREMENT');
MD.AddItem('F4  - SERIAL I-V MEASUREMENT');
MD.AddItem('F5  - ADC CALIBRATION');
MD.AddItem('ESC - EXIT');
end;




Procedure MenuParameters;
var i0:byte;
begin
repeat
MD.Init;
MD.Title('PARAMETERS');
MD.AddItem('F1  - SETUP');
MD.AddItem('F2  - DIOD POSITION');
MD.AddItem('F3  - TYPE OF MEASUREMENT');
MD.AddItem('F4  - FORWARD MEASUREMENT');
MD.AddItem('F5  - REVERSE MEASUREMENT');
MD.AddItem('F6  - TEMPERATURE DEFINITION');
MD.AddItem('ESC - EXIT');
i0:=FunReadKey;
case i0 of
     59:MenuSetup;
     60:MenuDiodPosition;
     61:MenuTypeMeasur;
     62:MenuMeasurPar(1);
     63:MenuMeasurPar(2);
     64:MenuTemper;
    end;
until (i0=27);
end;


 BEGIN
Initialization;
repeat
MainMenu;
progr:=FunReadKey;

case progr of
     59:MenuParameters;
     60:ReferPoint;
     61:IVmeasure;
     62:MenuSerial;
     63:MenuADC;
   end;

until (progr=27);
Final;
end.