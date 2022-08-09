unit DMM6500_MeasParamShow;

interface

uses
  OlegShowTypes, Classes, DMM6500, StdCtrls, Keitley2450Const;

type

TDMM6500_StringParameterShow=class(TStringParameterShow)
 private
  procedure CreateHeader(DMM6500: TDMM6500; ChanNumber: Byte);//virtual;
 protected
  fSettingsShowSL:TStringList;
  fDMM6500:TDMM6500;
  fChanNumber:byte;
//  fCaption:string;
  procedure OkClick();virtual;abstract;
  procedure SettingsShowSLFilling();virtual;abstract;
  procedure SomeAction();virtual;
 public
  Constructor Create(ST:TStaticText;ParametrCaption: string;
           DMM6500:TDMM6500;ChanNumber:byte=0);overload;
  Constructor Create(ST:TStaticText;LCap:TLabel;ParametrCaption: string;
           DMM6500:TDMM6500;ChanNumber:byte=0);overload;
  destructor Destroy;override;
  procedure ObjectToSetting;virtual;abstract;
end;

TDMM6500_MeasurementType=class(TDMM6500_StringParameterShow)
 private
  fPermitedMeasFunction:array of TKeitley_Measure;
//  procedure CreateHeader(DMM6500: TDMM6500; ChanNumber: Byte);override;
  procedure PermitedMeasFunctionFilling;
  function MeasureToOrd(FM: TKeitley_Measure):ShortInt;
 protected
  procedure OkClick();override;
  procedure SettingsShowSLFilling();override;
  procedure SomeAction();override;
 public
  Constructor Create(ST:TStaticText;
           DMM6500:TDMM6500;ChanNumber:byte=0);
  procedure ObjectToSetting;override;
end;

implementation

{ TDMM6500_StringParameterShow }

constructor TDMM6500_StringParameterShow.Create(ST: TStaticText;
  ParametrCaption: string; DMM6500: TDMM6500; ChanNumber: byte);
begin
  CreateHeader(DMM6500, ChanNumber);
  inherited Create(ST,ParametrCaption,fSettingsShowSL);
  HookParameterClick:=OkClick;
end;

destructor TDMM6500_StringParameterShow.Destroy;
begin
  fSettingsShowSL.Free;
  inherited;
end;

procedure TDMM6500_StringParameterShow.SomeAction;
begin
end;

constructor TDMM6500_StringParameterShow.Create(ST: TStaticText; LCap: TLabel;
  ParametrCaption: string; DMM6500: TDMM6500; ChanNumber: byte);
begin
  CreateHeader(DMM6500, ChanNumber);
  inherited Create(ST,LCap,ParametrCaption,fSettingsShowSL);
  HookParameterClick:=OkClick;
end;

procedure TDMM6500_StringParameterShow.CreateHeader(DMM6500: TDMM6500; ChanNumber: Byte);
begin
  fDMM6500 := DMM6500;
  fChanNumber := ChanNumber;
  SomeAction();
  fSettingsShowSL := TStringList.Create;
  SettingsShowSLFilling;
end;

{ TDMM6500_MeasurementType }

constructor TDMM6500_MeasurementType.Create(ST: TStaticText; DMM6500: TDMM6500;
  ChanNumber: byte);
begin
 inherited Create(ST,'MeasureType',DMM6500,ChanNumber);

// if ChanNumber=0
//  then SetMeasureFunction(MeasureFunc)
//  else
//    begin
//     if ChanelNumberIsCorrect(ChanNumber) and IsPermittedMeasureFuncForChan(MeasureFunc,ChanNumber) then
//       begin
//         fChanOperationString:=PartDelimiter+ChanelToString(ChanNumber);
//         fChanOperation:=True;
//         inherited SetMeasureFunction(MeasureFunc);
//         fChansMeasure[ChanNumber-fFirstChannelInSlot].MeasureFunction:=MeasureFunc;
//       end;
//    end;

//function TDMM6500.IsPermittedMeasureFuncForChan(MeasureFunc: TKeitley_Measure;
//  ChanNumber: byte): boolean;
//begin
// Result:=False;
// if MeasureFunc in [kt_mCurDC,kt_mCurAC,kt_mDigCur] then Exit;
// if (ChanNumber in [6..10])and(MeasureFunc in [kt_mRes4W,kt_mVoltRat]) then Exit;
// Result:=True;

end;


function TDMM6500_MeasurementType.MeasureToOrd(FM: TKeitley_Measure): ShortInt;
 var i:byte;
begin
 for I := 0 to High(fPermitedMeasFunction) do
  if fPermitedMeasFunction[i]=FM then
   begin
     Result:=i;
     Exit;
   end;
 Result:=-1;
end;

procedure TDMM6500_MeasurementType.ObjectToSetting;
begin
 if fChanNumber=0
   then Data:=MeasureToOrd(fDMM6500.MeasureFunction)
   else Data:=MeasureToOrd(fDMM6500.ChansMeasure[fChanNumber-1].MeasureFunction);
// Data:=ord(fKeitley.MeasureFunction);
end;

procedure TDMM6500_MeasurementType.OkClick;
begin
  fDMM6500.SetMeasureFunction(fPermitedMeasFunction[Data],fChanNumber);
end;

procedure TDMM6500_MeasurementType.PermitedMeasFunctionFilling;
 var i:TKeitley_Measure;
begin
 for I := Low(TKeitley_Measure) to High(TKeitley_Measure) do
  if fDMM6500.IsPermittedMeasureFuncForChan(i,fChanNumber) then
    begin
      SetLength(fPermitedMeasFunction,High(fPermitedMeasFunction)+2);
      fPermitedMeasFunction[High(fPermitedMeasFunction)]:=i;
    end;
end;

procedure TDMM6500_MeasurementType.SettingsShowSLFilling;
 var i:byte;
begin
 for I := 0 to High(fPermitedMeasFunction) do
    fSettingsShowSL.Add(Keitley_MeasureLabel[fPermitedMeasFunction[i]]);
end;

procedure TDMM6500_MeasurementType.SomeAction;
begin
  inherited;
  PermitedMeasFunctionFilling;
end;

end.
