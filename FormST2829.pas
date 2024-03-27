unit FormST2829;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPortCtl, ExtCtrls, Buttons;

type
  TST2829Form = class(TForm)
    BClose: TButton;
    GB_ST2829C_Com: TGroupBox;
    B_MyTrain: TButton;
    GB_Setting: TGroupBox;
    GBST2829C_Option: TGroupBox;
    GB_ST2829C_Mes: TGroupBox;
    LST2829CP_Meas: TLabel;
    LST2829CP_MeasU: TLabel;
    SB_ST2829C_MeasAuto: TSpeedButton;
    B_ST2829C_Meas: TButton;
    LST2829CS_Meas: TLabel;
    LST2829CS_MeasU: TLabel;
    GBST2829C_Bias: TGroupBox;
    GBST2829C_Setup: TGroupBox;
    GBST2829C_Sweep: TGroupBox;
    GBST2829C_Corrections: TGroupBox;
    GBST2829C_MultiMeas: TGroupBox;
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
begin
 ST2829C_Show := TST2829C_Show.Create(ST_2829C,
                                      [GB_ST2829C_Com,GB_Setting,
                                      GBST2829C_Option,
                                      GBST2829C_Bias,
                                      GBST2829C_Setup,
                                      GBST2829C_Sweep,
                                      GBST2829C_Corrections,
                                      GB_ST2829C_Mes,
                                      GBST2829C_MultiMeas],
                                      LST2829CP_Meas,
                                      LST2829CP_MeasU,
                                      B_ST2829C_Meas,
                                      SB_ST2829C_MeasAuto,
                                      LST2829CS_Meas,
                                      LST2829CS_MeasU,
                                      B_MyTrain);

 ST2829C_Show.ReadFromIniFile(CF_ST_2829C);
end;

procedure TST2829Form.FormDestroy(Sender: TObject);
begin
 ST2829C_Show.WriteToIniFile(CF_ST_2829C);

 FreeAndNil(ST2829C_Show);
end;

end.
