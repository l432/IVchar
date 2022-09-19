unit FormGDS806;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart, StdCtrls, CPortCtl,
  Buttons;

type
  TForm_GDS806 = class(TForm)
    GB_GDS_Ch1: TGroupBox;
    LGDS_OffsetCh1: TLabel;
    LGDS_Ch1: TLabel;
    LGDSU_Ch1: TLabel;
    SB_GDS_AutoCh1: TSpeedButton;
    STGDS_OffsetCh1: TStaticText;
    B_GDS_MeasCh1: TButton;
    STGDS_MeasCh1: TStaticText;
    CBGDS_DisplayCh1: TCheckBox;
    CBGDS_InvertCh1: TCheckBox;
    STGDS_ProbCh1: TStaticText;
    STGDS_CoupleCh1: TStaticText;
    STGDS_ScaleCh1: TStaticText;
    STGDS_ScaleGoriz: TStaticText;
    B_GDS_Unlock: TButton;
    B_GDS_Stop: TButton;
    B_GDS_Run: TButton;
    B_GDS_Refresh: TButton;
    GB_GDS_Ch2: TGroupBox;
    LGDS_OffsetCh2: TLabel;
    LGDS_Ch2: TLabel;
    LGDSU_Ch2: TLabel;
    SB_GDS_AutoCh2: TSpeedButton;
    STGDS_OffsetCh2: TStaticText;
    B_GDS_MeasCh2: TButton;
    STGDS_MeasCh2: TStaticText;
    CBGDS_DisplayCh2: TCheckBox;
    CBGDS_InvertCh2: TCheckBox;
    STGDS_ProbCh2: TStaticText;
    STGDS_CoupleCh2: TStaticText;
    STGDS_ScaleCh2: TStaticText;
    GB_GDS_Com: TGroupBox;
    LGDSPort: TLabel;
    ComCBGDS_Port: TComComboBox;
    ComCBGDS_Baud: TComComboBox;
    ST_GDS_Rate: TStaticText;
    ST_GDS_StopBits: TStaticText;
    ComCBGDS_Stop: TComComboBox;
    ST_GDS_Parity: TStaticText;
    ComCBGDS_Parity: TComComboBox;
    B_GDS_Test: TButton;
    GB_GDS_Show: TGroupBox;
    SB_GDS_AutoShow: TSpeedButton;
    PGGDS_Show: TRadioGroup;
    B_GDS_MeasShow: TButton;
    ChGDS: TChart;
    GDS_SeriesCh1: TLineSeries;
    GDS_SeriesCh2: TLineSeries;
    GB_GDS_Set: TGroupBox;
    LGDS_Mode: TLabel;
    LGDS_RLength: TLabel;
    LGDS_AveNum: TLabel;
    STGDS_Mode: TStaticText;
    B_GDS_SetSet: TButton;
    B_GDS_SetGet: TButton;
    B_GDS_SetSav: TButton;
    B_GDS_SetLoad: TButton;
    B_GDS_SetAuto: TButton;
    B_GDS_SetDef: TButton;
    STGDS_RLength: TStaticText;
    STGDS_AveNum: TStaticText;
    BClose: TButton;
    procedure BCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_GDS806: TForm_GDS806;

implementation

uses
  IVchar_main;

{$R *.dfm}

procedure TForm_GDS806.BCloseClick(Sender: TObject);
begin
  if Parent=nil then IVchar.B_GDS806drive.Click
                else
   begin
    Align := alNone;
    BorderStyle:=bsSingle;
    Parent := nil;
    BClose.Caption:='Dock';
    Color:=clInfoBk;
    Position:=poScreenCenter;
    Height:=Height+20;
   end;
end;



end.
