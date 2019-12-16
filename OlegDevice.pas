unit OlegDevice;

interface

uses
  OlegTypePart2, Measurement;

type

 TOCurrent_Mode=(oc_m3,
                 oc_m2,
                 oc_m1,
                 oc_m0,
                 oc_merror);


  TCurrent=class(TNamedInterfacedObject,IMeasurement)
    protected
     fValue:double;
     fBias:double;
     fNewData:boolean;
     fMode:TOCurrent_Mode;
     fDiapazonMeas:IMeasurement;
     fValueMeas:IMeasurement;
     function GetNewData:boolean;
     function GetValue:double;
     procedure SetNewData(value:boolean);
     procedure ModeDetermine;
     function ValueCalculate(Voltage:double):double;
     procedure ValueMeasOptimize;
    public
     property NewData:boolean read GetNewData  write SetNewData;
     property Value:double read GetValue;
     Constructor Create();
     function GetData:double;
     procedure GetDataThread(WPARAM: word;EventEnd:THandle);
  end;


implementation

uses
  OlegType, ArduinoADC, SysUtils;

{ TCurrent }

constructor TCurrent.Create;
begin
  fName:='OlegCurrent';
  fMode:=oc_merror;
  fValue:=ErResult;
  fNewData:=False;
  fBias:=0;
end;

function TCurrent.GetData: double;
begin
 ModeDetermine();
 if fMode=oc_merror
   then fValue:=ErResult
   else
    begin
     fValue:=ValueCalculate(fValueMeas.GetData);
    end;
 Result:=fValue;
 fNewData:=True;
end;

procedure TCurrent.GetDataThread(WPARAM: word; EventEnd: THandle);
begin

end;

function TCurrent.GetNewData: boolean;
begin
  Result:=fNewData;
end;

function TCurrent.GetValue: double;
begin
 Result:=fValue;
end;

procedure TCurrent.ModeDetermine;
 var DiapVoltage:double;
     attemptCount:byte;
 label start;
begin
  attemptCount:=0;
start:
  DiapVoltage:=fDiapazonMeas.GetData;
  if abs(DiapVoltage)<0.02
   then fMode:=oc_m0
   else
   if (DiapVoltage>0.21)and(DiapVoltage<0.25)
      then fMode:=oc_m1
      else
      if (DiapVoltage>0.44)and(DiapVoltage<0.48)
         then fMode:=oc_m2
         else
          if (DiapVoltage>0.68)and(DiapVoltage<0.72)
            then fMode:=oc_m3
            else fMode:=oc_merror;
   inc(attemptCount);
   if (DiapVoltage=ErResult)and(attemptCount=1) then goto start;
end;


procedure TCurrent.SetNewData(value: boolean);
begin
 fNewData:=value;
end;

function TCurrent.ValueCalculate(Voltage: double): double;
begin
 if Voltage=ErResult then
    begin
      Result:=ErResult;
      Exit;
    end;
  case fMode of
    oc_m3: Result:=2.40593e-8-1.003795e-8*Voltage-fBias;
    oc_m2: Result:=2.506122e-6-9.98987e-7*Voltage-fBias;
    oc_m1: Result:=2.500326e-4-9.948939e-5*Voltage;
    oc_m0: Result:=0.002497837-0.009940625*Voltage;
    else Result:=ErResult;
  end;
end;

procedure TCurrent.ValueMeasOptimize;
begin
 if AnsiPos('ADS1115',fValueMeas.Name)>0  then Exit;

end;

end.
