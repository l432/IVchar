unit FormST2829;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPortCtl, ExtCtrls;

type
  TST2829Form = class(TForm)
    BClose: TButton;
    GB_ST2829C_Com: TGroupBox;
    B_MyTrain: TButton;
    GB_Setting: TGroupBox;
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
  IVchar_main, ST2829CShow, ST2829C, IniFiles;

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
 var CF:TIniFile;
begin
 ST2829C_Show := TST2829C_Show.Create(ST_2829C,
                                      [GB_ST2829C_Com,GB_Setting],
                                      B_MyTrain);

 CF:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'IVChar.ini');
 ST2829C_Show.ReadFromIniFile(CF);
 CF.Free;
end;

procedure TST2829Form.FormDestroy(Sender: TObject);
 var CF:TIniFile;
begin
 CF:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'IVChar.ini');
 ST2829C_Show.WriteToIniFile(CF);
 CF.Free;

 FreeAndNil(ST2829C_Show);
end;

end.
