unit FormKT2450;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls;

type
  TKT2450Form = class(TForm)
    GB_K2450IP: TGroupBox;
    E_Kt2450Ip1: TEdit;
    UD_Kt2450Ip1: TUpDown;
    E_Kt2450Ip2: TEdit;
    UD_Kt2450Ip2: TUpDown;
    E_Kt2450Ip3: TEdit;
    UD_Kt2450Ip3: TUpDown;
    E_Kt2450Ip4: TEdit;
    UD_Kt2450Ip4: TUpDown;
    B_Kt2450UpDate: TButton;
    BKt2450Test: TButton;
    BClose: TButton;
    GB_KT2450Sweep: TGroupBox;
    L_KT2450SweepStart: TLabel;
    L_KT2450SweepStop: TLabel;
    L_KT2450SweepStepPoint: TLabel;
    L_KT2450SweepDelay: TLabel;
    L_KT2450SweepCount: TLabel;
    L_KT2450SweepRange: TLabel;
    RG_KT2450SweepMode: TRadioGroup;
    ST_KT2450SweepStart: TStaticText;
    ST_KT2450SweepStop: TStaticText;
    ST_KT2450SweepStepPoint: TStaticText;
    ST_KT2450SweepDelay: TStaticText;
    ST_KT2450SweepCount: TStaticText;
    ST_KT2450SweepRange: TStaticText;
    CB_KT2450SweepDual: TCheckBox;
    CB_KT2450SweepAbortLim: TCheckBox;
    B_Kt2450_Reset: TButton;
    SB_Kt2450_OutPut: TSpeedButton;
    B_MyTrain: TButton;
    ST_KT2450Mode: TStaticText;
    L_KT2450Mode: TLabel;
    GB_Kt2450_Source: TGroupBox;
    SB_Kt2450_Termin: TSpeedButton;
    L_Kt2450_OutPut: TLabel;
    L_KT2450VolProt: TLabel;
    L_KT2450LimitSource: TLabel;
    L_KT2450DelaySource: TLabel;
    ST_Kt2450_OutPut: TStaticText;
    ST_KT2450VolProt: TStaticText;
    ST_KT2450LimitSource: TStaticText;
    CB_KT2450ReadBack: TCheckBox;
    ST_KT2450SouceRange: TStaticText;
    CB_KT2450DelaySource: TCheckBox;
    ST_KT2450DelaySource: TStaticText;
    GB_Kt2450_Mes: TGroupBox;
    LKT2450_ResComp: TLabel;
    L_KT2450MeasureLowRange: TLabel;
    ST_KT2450_Sense: TStaticText;
    STKT2450_ResComp: TStaticText;
    ST_KT2450MeasureRange: TStaticText;
    ST_KT2450MeasureLowRange: TStaticText;
    CB_KT2450Azero: TCheckBox;
    B_KT2450Azero: TButton;
    GB_FT2450Setup: TGroupBox;
    PKt2450LoadSetup: TPanel;
    PKt2450SaveSetup: TPanel;
    B_KT2450GetSetting: TButton;
    L_KT2450SourceValue: TLabel;
    ST_KT2450SourceValue: TStaticText;
    L_KT2450MeasTime: TLabel;
    ST_KT2450MeasTime: TStaticText;
    CB_KT2450SourHCap: TCheckBox;
    ST_KT2450DisplDN: TStaticText;
    L_KT2450MCount: TLabel;
    ST_KT2450MCount: TStaticText;
    LKT2450_Meas: TLabel;
    LKT2450_MeasU: TLabel;
    B_KT2450_Meas: TButton;
    B_KT2450_MeasAuto: TSpeedButton;
    LKT2450_SourceValueRange: TLabel;
    GBKT2450MeasSource: TGroupBox;
    LKT2450_SourceMeasure: TLabel;
    BKT2450_SourceMeasure: TButton;
    L_KT2450_DispBr: TLabel;
    ST_KT2450_DispBr: TStaticText;
    GBKT2450Mode: TGroupBox;
    RG_KT2450SweepSelect: TRadioGroup;
    GBKT2450_IVMeasur: TGroupBox;
    B_KT2450SweepCreate: TButton;
    B_KT2450SweepInit: TButton;
    B_KT2450SweepStop: TButton;
    B_KT2450SweepPause: TButton;
    B_KT2450SweepResume: TButton;
    procedure BCloseClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  KT2450Form: TKT2450Form;

implementation

uses
  ShowTypes, IVchar_main;

{$R *.dfm}

procedure TKT2450Form.BCloseClick(Sender: TObject);
begin
//  KT2450Form.Hide;
  FormDockUnDock(Self,clCream);

//  if Parent=nil then IVchar.B_Kt2450drive.Click
//                else
//   begin
//    Align := alNone;
//    BorderStyle:=bsSingle;
//    Parent := nil;
//    BClose.Caption:='Dock';
//    Color:=clCream;
//    Position:=poScreenCenter;
//    Height:=Height+20;
//   end;
end;



procedure TKT2450Form.FormPaint(Sender: TObject);
begin
 TMyGroupBox(GB_K2450IP).Canvas.Brush.Color:=clBlack;
 TMyGroupBox(GB_K2450IP).Canvas.Ellipse(67,45,72,50);
 TMyGroupBox(GB_K2450IP).Canvas.Ellipse(129,45,134,50);
 TMyGroupBox(GB_K2450IP).Canvas.Ellipse(191,45,196,50);
end;


end.
