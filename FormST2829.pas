unit FormST2829;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPortCtl;

type
  TST2829Form = class(TForm)
    BClose: TButton;
    GB_ST2829_Com: TGroupBox;
    LST2829Port: TLabel;
    ComCBST2829_Port: TComComboBox;
    ComCBST2829_Baud: TComComboBox;
    ST_ST2829_Rate: TStaticText;
    B_ST2829C_Test: TButton;
    procedure BCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ST2829Form: TST2829Form;

implementation

uses
  IVchar_main;

{$R *.dfm}

procedure TST2829Form.BCloseClick(Sender: TObject);
begin
  FormDockUnDock(Self,clSkyBlue);

//  if Parent=nil then IVchar.B_ST2829drive.Click
//                else
//   begin
//    Align := alNone;
//    BorderStyle:=bsSingle;
//    Parent := nil;
//    BClose.Caption:='Dock';
//    Color:=clSkyBlue;
//    Position:=poScreenCenter;
//    Height:=Height+20;
//   end;
end;

end.
