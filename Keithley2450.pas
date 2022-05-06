unit Keithley2450;

interface

uses
  StdCtrls, TelnetDevice, IdTelnet, ShowTypes;

type

  TMyGroupBox = class(TGroupBox)
    public
      property Canvas;
  end;

 TKt_2450=class(TTelnetMeterDeviceSingle)
  private
   procedure DefaultSettings;
  protected
   procedure UpDate();override;
  public
   Constructor Create(Telnet:TIdTelnet;IPAdressShow: TIPAdressShow;
               Nm:string='Keitley2450');
 end;


implementation

uses
  Dialogs;

{ TKt_2450 }

constructor TKt_2450.Create(Telnet: TIdTelnet; IPAdressShow: TIPAdressShow;
  Nm: string);
begin
 inherited Create(Telnet,IPAdressShow,Nm);
 RepeatInErrorCase:=True;
 DefaultSettings();
// SetFlags(0,0,0,true);
end;

procedure TKt_2450.DefaultSettings;
begin

end;

procedure TKt_2450.UpDate;
 var STR:string;
begin
 Str:=fDataSubject.ReceivedString;
 fIsReceived:=True;
 if TestShowEthernet then showmessage('recived:  '+STR);
end;

end.
