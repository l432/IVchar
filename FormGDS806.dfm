object Form_GDS806: TForm_GDS806
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'GDS806 Settings'
  ClientHeight = 456
  ClientWidth = 774
  Color = clInfoBk
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GB_GDS_Ch1: TGroupBox
    Left = 3
    Top = 0
    Width = 222
    Height = 146
    Caption = 'CHANNEL 1'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object LGDS_OffsetCh1: TLabel
      Left = 95
      Top = 120
      Width = 57
      Height = 16
      Caption = 'Offset, V:'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clTeal
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LGDS_Ch1: TLabel
      Left = 3
      Top = 14
      Width = 174
      Height = 31
      AutoSize = False
      Caption = '  ERROR'
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -25
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object LGDSU_Ch1: TLabel
      Left = 177
      Top = 14
      Width = 40
      Height = 31
      AutoSize = False
      Caption = 'a'
      Color = clInfoText
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWhite
      Font.Height = -27
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object SB_GDS_AutoCh1: TSpeedButton
      Left = 138
      Top = 70
      Width = 45
      Height = 19
      AllowAllUp = True
      GroupIndex = 2
      Caption = 'AUTO'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clDefault
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object STGDS_OffsetCh1: TStaticText
      Left = 160
      Top = 118
      Width = 60
      Height = 22
      Caption = '-0.008'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clTeal
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 0
    end
    object B_GDS_MeasCh1: TButton
      Left = 23
      Top = 70
      Width = 79
      Height = 19
      Caption = 'measure'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object STGDS_MeasCh1: TStaticText
      Left = 23
      Top = 48
      Width = 182
      Height = 22
      Caption = 'Peak-to-peak voltage'
      Color = clBtnFace
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 2
    end
    object CBGDS_DisplayCh1: TCheckBox
      Left = 10
      Top = 126
      Width = 76
      Height = 18
      Caption = 'Display'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object CBGDS_InvertCh1: TCheckBox
      Left = 10
      Top = 112
      Width = 71
      Height = 17
      Caption = 'Invert'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
    object STGDS_ProbCh1: TStaticText
      Left = 95
      Top = 90
      Width = 51
      Height = 24
      Caption = '100x'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 5
    end
    object STGDS_CoupleCh1: TStaticText
      Left = 164
      Top = 90
      Width = 45
      Height = 24
      Caption = 'GRN'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 6
    end
    object STGDS_ScaleCh1: TStaticText
      Left = 10
      Top = 90
      Width = 71
      Height = 24
      Caption = '500mV'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 7
    end
  end
  object STGDS_ScaleGoriz: TStaticText
    Left = 248
    Top = 121
    Width = 80
    Height = 24
    Caption = '100.0us'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBackground
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    TabOrder = 1
  end
  object B_GDS_Unlock: TButton
    Left = 231
    Top = 88
    Width = 110
    Height = 21
    Caption = 'UNLOCK'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object B_GDS_Stop: TButton
    Left = 231
    Top = 62
    Width = 110
    Height = 21
    Caption = 'STOP'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object B_GDS_Run: TButton
    Left = 231
    Top = 35
    Width = 110
    Height = 21
    Caption = 'RUN'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object B_GDS_Refresh: TButton
    Left = 231
    Top = 9
    Width = 110
    Height = 21
    Caption = 'REFRESH'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object GB_GDS_Ch2: TGroupBox
    Left = 349
    Top = 0
    Width = 222
    Height = 146
    Caption = 'CHANNEL 2'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    object LGDS_OffsetCh2: TLabel
      Left = 95
      Top = 120
      Width = 40
      Height = 16
      Caption = 'Offset:'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clTeal
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LGDS_Ch2: TLabel
      Left = 3
      Top = 14
      Width = 174
      Height = 31
      AutoSize = False
      Caption = '  ERROR'
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -25
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object LGDSU_Ch2: TLabel
      Left = 177
      Top = 14
      Width = 40
      Height = 31
      AutoSize = False
      Caption = 'a'
      Color = clInfoText
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWhite
      Font.Height = -27
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object SB_GDS_AutoCh2: TSpeedButton
      Left = 138
      Top = 70
      Width = 45
      Height = 19
      AllowAllUp = True
      GroupIndex = 2
      Caption = 'AUTO'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clDefault
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object STGDS_OffsetCh2: TStaticText
      Left = 160
      Top = 118
      Width = 60
      Height = 22
      Caption = '-0.008'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clTeal
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 0
    end
    object B_GDS_MeasCh2: TButton
      Left = 23
      Top = 70
      Width = 79
      Height = 19
      Caption = 'measure'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object STGDS_MeasCh2: TStaticText
      Left = 23
      Top = 48
      Width = 182
      Height = 22
      Caption = 'Peak-to-peak voltage'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 2
    end
    object CBGDS_DisplayCh2: TCheckBox
      Left = 10
      Top = 126
      Width = 76
      Height = 18
      Caption = 'Display'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object CBGDS_InvertCh2: TCheckBox
      Left = 10
      Top = 112
      Width = 71
      Height = 17
      Caption = 'Invert'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
    object STGDS_ProbCh2: TStaticText
      Left = 95
      Top = 90
      Width = 51
      Height = 24
      Caption = '100x'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 5
    end
    object STGDS_CoupleCh2: TStaticText
      Left = 164
      Top = 90
      Width = 45
      Height = 24
      Caption = 'GRN'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 6
    end
    object STGDS_ScaleCh2: TStaticText
      Left = 10
      Top = 90
      Width = 71
      Height = 24
      Caption = '500mV'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 7
    end
  end
  object GB_GDS_Com: TGroupBox
    Left = 566
    Top = -2
    Width = 206
    Height = 147
    Caption = 'COM parameters'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    object LGDSPort: TLabel
      Left = 10
      Top = 12
      Width = 40
      Height = 18
      Caption = 'Port '
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ComCBGDS_Port: TComComboBox
      Left = 8
      Top = 31
      Width = 74
      Height = 26
      ComProperty = cpPort
      AutoApply = True
      Text = 'COM1'
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 18
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
    end
    object ComCBGDS_Baud: TComComboBox
      Left = 10
      Top = 85
      Width = 74
      Height = 26
      ComPort = IVchar.ComPortGDS
      ComProperty = cpBaudRate
      AutoApply = True
      Text = '9600'
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 18
      ItemIndex = 7
      ParentFont = False
      TabOrder = 1
    end
    object ST_GDS_Rate: TStaticText
      Left = 10
      Top = 63
      Width = 89
      Height = 22
      Caption = 'Baud Rate'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object ST_GDS_StopBits: TStaticText
      Left = 120
      Top = 12
      Width = 78
      Height = 22
      Caption = 'Stop Bits'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object ComCBGDS_Stop: TComComboBox
      Left = 120
      Top = 32
      Width = 74
      Height = 26
      ComPort = IVchar.ComPortGDS
      ComProperty = cpStopBits
      AutoApply = True
      Text = '1'
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 18
      ItemIndex = 0
      ParentFont = False
      TabOrder = 4
    end
    object ST_GDS_Parity: TStaticText
      Left = 120
      Top = 63
      Width = 53
      Height = 22
      Caption = 'Parity'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
    end
    object ComCBGDS_Parity: TComComboBox
      Left = 120
      Top = 85
      Width = 74
      Height = 26
      ComPort = IVchar.ComPortGDS
      ComProperty = cpParity
      AutoApply = True
      Text = 'None'
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 18
      ItemIndex = 0
      ParentFont = False
      TabOrder = 6
    end
    object B_GDS_Test: TButton
      Left = 10
      Top = 117
      Width = 185
      Height = 25
      Caption = 'B_GDS_SetSet'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
    end
  end
  object GB_GDS_Show: TGroupBox
    Left = 566
    Top = 326
    Width = 206
    Height = 82
    Caption = 'Show'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 8
    object SB_GDS_AutoShow: TSpeedButton
      Left = 143
      Top = 15
      Width = 45
      Height = 22
      AllowAllUp = True
      GroupIndex = 2
      Caption = 'AUTO'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clDefault
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object PGGDS_Show: TRadioGroup
      Left = 2
      Top = 39
      Width = 202
      Height = 41
      Margins.Top = 0
      Align = alBottom
      Color = clSkyBlue
      Columns = 3
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Items.Strings = (
        'ch1'
        'ch2'
        'ch 1/2')
      ParentBackground = False
      ParentColor = False
      ParentFont = False
      TabOrder = 0
    end
    object B_GDS_MeasShow: TButton
      Left = 9
      Top = 15
      Width = 66
      Height = 22
      Caption = 'measure'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
  end
  object ChGDS: TChart
    Left = 2
    Top = 151
    Width = 564
    Height = 257
    Legend.Alignment = laTop
    Legend.CheckBoxes = True
    Legend.FontSeriesColor = True
    Legend.HorizMargin = 10
    Legend.LegendStyle = lsSeries
    Legend.ResizeChart = False
    Legend.Visible = False
    MarginBottom = 0
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 0
    Title.Text.Strings = (
      '')
    BottomAxis.AxisValuesFormat = '00e-0'
    DepthAxis.Automatic = False
    DepthAxis.AutomaticMaximum = False
    DepthAxis.AutomaticMinimum = False
    DepthAxis.Maximum = -1.989999999999998000
    DepthAxis.Minimum = -2.989999999999995000
    DepthTopAxis.Automatic = False
    DepthTopAxis.AutomaticMaximum = False
    DepthTopAxis.AutomaticMinimum = False
    DepthTopAxis.Maximum = -1.989999999999998000
    DepthTopAxis.Minimum = -2.989999999999995000
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.Maximum = 341.584999999993500000
    LeftAxis.Minimum = 58.084999999991740000
    RightAxis.Automatic = False
    RightAxis.AutomaticMaximum = False
    RightAxis.AutomaticMinimum = False
    View3D = False
    View3DOptions.Orthogonal = False
    Align = alCustom
    TabOrder = 9
    PrintMargins = (
      15
      30
      15
      30)
    object GDS_SeriesCh1: TLineSeries
      Depth = 0
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      Title = 'GDS_SeriesCh1'
      ValueFormat = '#.# x10E-#'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object GDS_SeriesCh2: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clBlue
      Title = 'GDS_SeriesCh2'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object GB_GDS_Set: TGroupBox
    Left = 566
    Top = 148
    Width = 206
    Height = 176
    Caption = 'Settings'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 10
    object LGDS_Mode: TLabel
      Left = 10
      Top = 18
      Width = 46
      Height = 16
      Caption = 'Output:'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LGDS_RLength: TLabel
      Left = 10
      Top = 38
      Width = 46
      Height = 16
      Caption = 'Output:'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LGDS_AveNum: TLabel
      Left = 10
      Top = 58
      Width = 46
      Height = 16
      Caption = 'Output:'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object STGDS_Mode: TStaticText
      Left = 62
      Top = 15
      Width = 131
      Height = 25
      Caption = 'Peak detection'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 0
    end
    object B_GDS_SetSet: TButton
      Left = 16
      Top = 80
      Width = 75
      Height = 25
      Caption = 'B_GDS_SetSet'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object B_GDS_SetGet: TButton
      Left = 112
      Top = 80
      Width = 75
      Height = 25
      Caption = 'B_GDS_SetSet'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object B_GDS_SetSav: TButton
      Left = 16
      Top = 111
      Width = 75
      Height = 25
      Caption = 'B_GDS_SetSet'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object B_GDS_SetLoad: TButton
      Left = 112
      Top = 111
      Width = 75
      Height = 25
      Caption = 'B_GDS_SetSet'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
    object B_GDS_SetAuto: TButton
      Left = 16
      Top = 142
      Width = 75
      Height = 25
      Caption = 'B_GDS_SetSet'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
    end
    object B_GDS_SetDef: TButton
      Left = 112
      Top = 142
      Width = 75
      Height = 25
      Caption = 'B_GDS_SetSet'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
    end
    object STGDS_RLength: TStaticText
      Left = 117
      Top = 35
      Width = 76
      Height = 24
      Caption = '125000'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 7
    end
    object STGDS_AveNum: TStaticText
      Left = 126
      Top = 55
      Width = 40
      Height = 24
      Caption = '256'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 8
    end
  end
  object BClose: TButton
    Left = 3
    Top = 417
    Width = 71
    Height = 25
    Caption = 'UnDock'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    OnClick = BCloseClick
  end
end