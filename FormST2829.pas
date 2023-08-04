unit FormST2829;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPortCtl;

type
  TST2829Form = class(TForm)
    BClose: TButton;
    GB_ST2829C_Com: TGroupBox;
    B_MyTrain: TButton;
    procedure BCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ST2829Form: TST2829Form;

implementation

uses
  IVchar_main, ST2829CShow, ST2829C;

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

procedure TST2829Form.FormCreate(Sender: TObject);
begin
 ST2829C_Show := TST2829C_Show.Create(ST_2829C,
                                      GB_ST2829C_Com,
                                      B_MyTrain);

 ST2829C_Show.ReadFromIniFile(nil);
end;

procedure TST2829Form.FormDestroy(Sender: TObject);
begin
 ST2829C_Show.WriteToIniFile(nil);
 FreeAndNil(ST2829C_Show);
end;

end.
