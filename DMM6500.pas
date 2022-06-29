unit DMM6500;

interface

uses
  Keithley, IdTelnet, ShowTypes,Keitley2450Const, DMM6500_Const;

//const


type

 TDMM6500=class(TKeitley)
  private
//   fMeasureFunction:TKeitley_Measure;
  protected
   procedure ProcessingStringByRootNode(Str:string);override;
//   function StringToMeasureFunction(Str:string):boolean;override;
   procedure DefaultSettings;override;
  public
//   property MeasureFunction:TKeitley_Measure read fMeasureFunction;
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
  Dialogs, SysUtils;

{ TKt_2450 }

procedure TDMM6500.BufferCreate(Name: string; Size: integer;
  Style: TKt2450_BufferStyle);
begin
  if Style=kt_bs_comp then Exit;
  inherited BufferCreate(Name,Size,Style);
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
BufferReSize(100);
BufferReSize('TestBuffer',5);
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

procedure TDMM6500.ProcessingStringByRootNode(Str: string);
begin
 inherited;
 case fRootNode of
  0:if pos(DMM6500_Test,Str)<>0 then fDevice.Value:=314;
 end;

end;

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
