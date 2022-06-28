unit DMM6500;

interface

uses
  Keithley, IdTelnet, ShowTypes,Keitley2450Const;

const
 DMM6500_Test='KEITHLEY INSTRUMENTS,MODEL DMM6500';

type

 TDMM6500=class(TKeitley)
  private
  protected
   procedure ProcessingStringByRootNode(Str:string);override;
  public
   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string='DMM6500');
   procedure MyTraining();override;
 end;

var
  DMM_6500:TDMM6500;

implementation

{ TKt_2450 }

constructor TDMM6500.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
  inherited Create(Telnet,IPAdressShow,Nm);
end;

procedure TDMM6500.MyTraining;
begin
Beep;
//SetDisplayBrightness(kt_ds_on75);
// GetDisplayBrightness;
// Test();
end;

procedure TDMM6500.ProcessingStringByRootNode(Str: string);
begin
 case fRootNode of
  0:if pos(DMM6500_Test,Str)<>0 then fDevice.Value:=314;
 end;

end;

end.
