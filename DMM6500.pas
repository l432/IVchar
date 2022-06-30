unit DMM6500;

interface

uses
  Keithley, IdTelnet, ShowTypes,Keitley2450Const, DMM6500_Const;

//const


type

 TDMM6500=class(TKeitley)
  private
   fMeasureChanNumber:byte;
  protected
   procedure ProcessingStringByRootNode(Str:string);override;
   procedure PrepareStringByRootNode;override;
   procedure DefaultSettings;override;
//   procedure StringToMesuredData(Str:string;DataType:TKeitley_ReturnedData);override;
   procedure AdditionalDataFromString(Str:string);override;
   procedure AdditionalDataToArrayFromString;override;
  public
   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string='DMM6500');
   procedure MyTraining();override;

   procedure BufferCreate(Name:string;Size:integer;Style:TKt2450_BufferStyle);overload;override;
   procedure BufferCreate(Style:TKt2450_BufferStyle);overload;override;

   Procedure GetParametersFromDevice;override;
 end;

var
  DMM_6500:TDMM6500;

implementation

uses
  Dialogs, SysUtils, Keitley2450Device, OlegFunction, OlegType;

{ TKt_2450 }

procedure TDMM6500.BufferCreate(Name: string; Size: integer;
  Style: TKt2450_BufferStyle);
begin
  if Style=kt_bs_comp then Exit;
  inherited BufferCreate(Name,Size,Style);
end;

procedure TDMM6500.AdditionalDataFromString(Str: string);
begin
 fMeasureChanNumber:=round(FloatDataFromRow(Str,2));
end;

procedure TDMM6500.AdditionalDataToArrayFromString;
begin
 DataVector.Add(fMeasureChanNumber,fDevice.Value);
end;

procedure TDMM6500.BufferCreate(Style: TKt2450_BufferStyle);
begin
  if Style=kt_bs_comp then Exit;
  inherited BufferCreate(Style);
end;

constructor TDMM6500.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
  inherited Create(Telnet,IPAdressShow,Nm);
end;

procedure TDMM6500.DefaultSettings;
begin
 inherited;
 fMeasureChanNumber:=0;
// fMeasureFunction:=dm_mVolDC;

end;

procedure TDMM6500.GetParametersFromDevice;
begin
  inherited;
  if not(GetMeasureFunction()) then Exit;
end;

procedure TDMM6500.MyTraining;
// var i:integer;
begin

BufferDataArrayExtended(2,5,kt_rd_M);
showmessage(DataVector.XYtoString+#10#10+DataTimeVector.XYtoString);

BufferDataArrayExtended(1,5,kt_rd_MST);
showmessage(DataVector.XYtoString+#10#10+DataTimeVector.XYtoString);

BufferDataArrayExtended(1,5,kt_rd_MT);
showmessage(DataVector.XYtoString+#10#10+DataTimeVector.XYtoString);
//
//
BufferDataArrayExtended(1,5,kt_rd_MS);
showmessage(DataVector.XYtoString+#10#10+DataTimeVector.XYtoString);


//BufferLastDataExtended(kt_rd_MST,KeitleyDefBuffer);
//showmessage(floattostr(fDevice.Value)
//              +'  '+floattostr(fMeasureChanNumber)
//              +'  '+floattostr(TimeValue));
//
//BufferLastDataExtended(kt_rd_MT);
//showmessage(floattostr(fDevice.Value)+'  '+floattostr(fTimeValue));
//
//BufferLastDataExtended();
//showmessage(floattostr(fDevice.Value)+'  '+floattostr(fMeasureChanNumber));

// BufferLastDataSimple();
// showmessage(floattostr(fDevice.Value));

//if BufferGetFillMode() then
//  showmessage('ura! '+Keitley_BufferFillModeCommand[Buffer.FillMode]);
//
//BufferSetFillMode(kt_fm_cont);
//BufferSetFillMode('TestBuffer',kt_fm_once);

//if BufferGetStartEndIndex()
//  then showmessage(inttostr(Buffer.StartIndex)+'  '+inttostr(Buffer.EndIndex))
//  else showmessage('ups :(');

//showmessage(inttostr(BufferGetReadingsNumber()));
//BufferCreate();
//showmessage(inttostr(BufferGetReadingsNumber(MyBuffer)));

//showmessage(inttostr(BufferGetSize));
//showmessage(inttostr(Buffer.CountMax));
//showmessage(inttostr(BufferGetSize(KeitleyDefBuffer)));
//-----------------------------------------
//BufferReSize(100);
//BufferReSize('TestBuffer',5);
//BufferClear(KeitleyDefBuffer);
//BufferDelete();
//BufferDelete('Test  Buffer ');
// BufferCreate();
// BufferCreate('Test  Buffer ',500,kt_bs_full);
// BufferCreate('Test  Buffer ',500,kt_bs_comp);
// BufferCreate(kt_bs_full);
// BufferCreate(kt_bs_comp);
//for I := ord(Low(TKeitley_Measure)) to ord(High(TKeitley_Measure)) do
// SetMeasureFunction(TKeitley_Measure(i));
// if GetMeasureFunction then
//   showmessage('ura!!!'+DMM65000_MeasureLabel[MeasureFunction]);
// TextToUserScreen('Hi, Oleg!','I am glad to see you');
// ClearUserScreen();
//showmessage(booltostr(GetTerminal(),True));
//Beep;
//SetDisplayBrightness(kt_ds_on75);
// GetDisplayBrightness;
// Test();
end;

procedure TDMM6500.PrepareStringByRootNode;
begin
 inherited;
 case fRootNode of
  19:begin
       case fFirstLevelNode of
        33:JoinToStringToSend(Buffer.DataDemandDM6500Array(TKeitley_ReturnedData(fLeafNode)));
       end;
      end; // fRootNode=19
  22:case fFirstLevelNode of
       2..5:JoinToStringToSend(Buffer.DataDemandDM6500(TKeitley_ReturnedData(fFirstLevelNode-2)))
     end; // fRootNode=22
 end;
end;

procedure TDMM6500.ProcessingStringByRootNode(Str: string);
begin
 inherited;
 case fRootNode of
  0:if pos(DMM6500_Test,Str)<>0 then fDevice.Value:=314;
 end;

end;

//procedure TDMM6500.StringToMesuredData(Str: string;
//  DataType: TKeitley_ReturnedData);
//begin
// fDevice.Value:=FloatDataFromRow(Str,1);
// if (fDevice.Value=ErResult)or(DataType=kt_rd_M) then Exit;
// case DataType of
//   kt_rd_MS,kt_rd_MST:fMeasureChanNumber:=round(FloatDataFromRow(Str,2));
//   kt_rd_MT:fTimeValue:=StringToMeasureTime(DeleteStringDataFromRow(Str,1));
// end;
// if DataType=kt_rd_MST then fTimeValue:=StringToMeasureTime(DeleteStringDataFromRow(DeleteStringDataFromRow(Str,1),1));
//end;

//function TDMM6500.StringToMeasureFunction(Str: string): boolean;
//  var i:TKeitley_Measure;
//begin
// Result:=False;
// for I := High(TKeitley_Measure) downto Low(TKeitley_Measure) do
//   begin
//    case i of
//      dm_mCurDC..
//       dm_mRes2W:
//        Result:=pos(DeleteSubstring(RootNoodKeitley[ord(i)+12]),Str)<>0;
//      dm_mCurAC..
//       dm_mVoltRat: Result:=pos(DeleteSubstring(RootNoodKeitley[ord(i)+25]),Str)<>0;
//      dm_DigVolt..
//      dm_DigCur:  Result:=pos('none',Str)<>0;
//    end;
//    if Result then
//      begin
//       fMeasureFunction:=i;
//       fDevice.Value:=ord(fMeasureFunction);
//       Break;
//      end;
//   end;
//end;

end.
