unit FormDMM6500;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdTelnet, ExtCtrls;

type
  TDMM6500Form = class(TForm)
    BClose: TButton;
    B_MyTrain: TButton;
    GB_DM6500IP: TGroupBox;
    E_DM6500Ip1: TEdit;
    UD_DM6500Ip1: TUpDown;
    E_DM6500Ip2: TEdit;
    UD_DM6500Ip2: TUpDown;
    E_DM6500Ip3: TEdit;
    UD_DM6500Ip3: TUpDown;
    E_DM6500Ip4: TEdit;
    UD_DM6500Ip4: TUpDown;
    B_DM6500UpDate: TButton;
    B_DM6500Test: TButton;
    TelnetDMM6500: TIdTelnet;
    GB_DM6500Setup: TGroupBox;
    L_DM6500_DispBr: TLabel;
    PDM6500LoadSetup: TPanel;
    PDM6500SaveSetup: TPanel;
    B_DM6500GetSetting: TButton;
    B_DM6500_Reset: TButton;
    ST_DM6500_DispBr: TStaticText;
    procedure BCloseClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMM6500Form: TDMM6500Form;

implementation

uses
  IVchar_main, ShowTypes;

{$R *.dfm}

procedure TDMM6500Form.BCloseClick(Sender: TObject);
begin
  if Parent=nil then IVchar.B_DM6500drive.Click
                else
   begin
    Align := alNone;
    BorderStyle:=bsSingle;
    Parent := nil;
    BClose.Caption:='Dock';
    Color:=clMoneyGreen;
    Position:=poScreenCenter;
    Height:=Height+20;
   end;
end;

procedure TDMM6500Form.FormPaint(Sender: TObject);
begin
 TMyGroupBox(GB_DM6500IP).Canvas.Brush.Color:=clBlack;
 TMyGroupBox(GB_DM6500IP).Canvas.Ellipse(67,45,72,50);
 TMyGroupBox(GB_DM6500IP).Canvas.Ellipse(129,45,134,50);
 TMyGroupBox(GB_DM6500IP).Canvas.Ellipse(191,45,196,50);
end;

end.
