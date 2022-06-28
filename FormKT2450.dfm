object KT2450Form: TKT2450Form
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'KT2450 Settings'
  ClientHeight = 454
  ClientWidth = 772
  Color = clCream
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object GB_K2450IP: TGroupBox
    Tag = 110
    Left = 82
    Top = 3
    Width = 259
    Height = 92
    Caption = 'IP adress'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object E_Kt2450Ip1: TEdit
      Left = 14
      Top = 28
      Width = 33
      Height = 24
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = '5'
    end
    object UD_Kt2450Ip1: TUpDown
      Left = 46
      Top = 28
      Width = 16
      Height = 24
      TabOrder = 1
    end
    object E_Kt2450Ip2: TEdit
      Left = 76
      Top = 28
      Width = 33
      Height = 24
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Text = '5'
    end
    object UD_Kt2450Ip2: TUpDown
      Left = 108
      Top = 28
      Width = 16
      Height = 24
      TabOrder = 3
    end
    object E_Kt2450Ip3: TEdit
      Left = 139
      Top = 28
      Width = 33
      Height = 24
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Text = '5'
    end
    object UD_Kt2450Ip3: TUpDown
      Left = 171
      Top = 28
      Width = 16
      Height = 24
      TabOrder = 5
    end
    object E_Kt2450Ip4: TEdit
      Left = 200
      Top = 28
      Width = 33
      Height = 24
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      Text = '5'
    end
    object UD_Kt2450Ip4: TUpDown
      Left = 232
      Top = 28
      Width = 16
      Height = 24
      TabOrder = 7
    end
    object B_Kt2450UpDate: TButton
      Left = 14
      Top = 58
      Width = 67
      Height = 25
      Caption = 'UpDate'
      TabOrder = 8
    end
    object BKt2450Test: TButton
      Left = 87
      Top = 58
      Width = 161
      Height = 25
      Caption = 'Kt2450Test'
      TabOrder = 9
    end
  end
  object BClose: TButton
    Left = 5
    Top = 3
    Width = 71
    Height = 25
    Caption = 'UnDock'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = BCloseClick
  end
  object B_MyTrain: TButton
    Left = 7
    Top = 45
    Width = 69
    Height = 25
    Caption = 'B_MyTrain'
    TabOrder = 2
  end
  object GB_Kt2450_Source: TGroupBox
    Left = 5
    Top = 195
    Width = 316
    Height = 246
    Caption = 'Source'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object SB_Kt2450_Termin: TSpeedButton
      Left = 7
      Top = 22
      Width = 118
      Height = 29
      AllowAllUp = True
      GroupIndex = 3
      Caption = 'Terminals'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clDefault
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object L_Kt2450_OutPut: TLabel
      Left = 190
      Top = 136
      Width = 77
      Height = 16
      Caption = 'Output Type'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clTeal
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object L_KT2450VolProt: TLabel
      Left = 3
      Top = 136
      Width = 77
      Height = 32
      Caption = 'Overvoltage Protection'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object L_KT2450LimitSource: TLabel
      Left = 96
      Top = 136
      Width = 73
      Height = 16
      Caption = 'Limit Value'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clOlive
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object L_KT2450DelaySource: TLabel
      Left = 3
      Top = 200
      Width = 151
      Height = 16
      Caption = 'Delay after source set, s'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object L_KT2450SourceValue: TLabel
      Left = 136
      Top = 17
      Width = 87
      Height = 16
      Caption = 'Output Value:'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LKT2450_SourceValueRange: TLabel
      Left = 151
      Top = 39
      Width = 76
      Height = 16
      Caption = '-6.6 ... 6.6'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SB_Kt2450_OutPut: TSpeedButton
      Left = 6
      Top = 61
      Width = 79
      Height = 25
      AllowAllUp = True
      GroupIndex = 3
      Caption = 'Output'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clDefault
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ST_Kt2450_OutPut: TStaticText
      Left = 190
      Top = 174
      Width = 115
      Height = 22
      Caption = 'H-Impedance'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clTeal
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 0
    end
    object ST_KT2450VolProt: TStaticText
      Left = 12
      Top = 172
      Width = 46
      Height = 22
      Caption = 'None'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 1
    end
    object ST_KT2450LimitSource: TStaticText
      Left = 95
      Top = 172
      Width = 37
      Height = 22
      Caption = '210'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clOlive
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 2
    end
    object CB_KT2450ReadBack: TCheckBox
      Left = 84
      Top = 102
      Width = 99
      Height = 17
      Caption = 'Read Back'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object ST_KT2450SouceRange: TStaticText
      Left = 110
      Top = 65
      Width = 59
      Height = 24
      Caption = '200 V'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 4
    end
    object CB_KT2450DelaySource: TCheckBox
      Left = 7
      Top = 220
      Width = 54
      Height = 17
      Caption = 'Auto'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
    end
    object ST_KT2450DelaySource: TStaticText
      Left = 73
      Top = 217
      Width = 58
      Height = 24
      Caption = '0.055'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clOlive
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 6
    end
    object ST_KT2450SourceValue: TStaticText
      Left = 229
      Top = 14
      Width = 58
      Height = 24
      Caption = '0.025'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 7
    end
    object CB_KT2450SourHCap: TCheckBox
      Left = 181
      Top = 218
      Width = 129
      Height = 17
      Caption = 'H-capacitance'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
    end
    object GBKT2450MeasSource: TGroupBox
      Tag = 110
      Left = 185
      Top = 55
      Width = 119
      Height = 66
      Caption = 'Measurement'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      object LKT2450_SourceMeasure: TLabel
        Left = 9
        Top = 43
        Width = 71
        Height = 16
        Caption = '-0.0008'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BKT2450_SourceMeasure: TButton
        Left = 7
        Top = 16
        Width = 105
        Height = 24
        Caption = 'to measure'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object GB_Kt2450_Mes: TGroupBox
    Left = 349
    Top = 3
    Width = 277
    Height = 223
    Caption = 'Resistance'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    object LKT2450_ResComp: TLabel
      Left = 12
      Top = 199
      Width = 79
      Height = 16
      Caption = 'Compensate'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clTeal
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object L_KT2450MeasureLowRange: TLabel
      Left = 14
      Top = 108
      Width = 60
      Height = 32
      Caption = 'Low Auto Limit'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clOlive
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object L_KT2450MeasTime: TLabel
      Left = 164
      Top = 85
      Width = 54
      Height = 32
      Caption = 'Measure time, ms'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object LKT2450_Meas: TLabel
      Left = 3
      Top = 14
      Width = 208
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
    object LKT2450_MeasU: TLabel
      Left = 207
      Top = 14
      Width = 47
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
    object B_KT2450_MeasAuto: TSpeedButton
      Left = 146
      Top = 56
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
    object L_KT2450MCount: TLabel
      Left = 105
      Top = 123
      Width = 58
      Height = 32
      Caption = 'Measure Count'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object ST_KT2450_Sense: TStaticText
      Left = 88
      Top = 85
      Width = 68
      Height = 24
      Caption = '2-Wire'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 0
    end
    object STKT2450_ResComp: TStaticText
      Left = 97
      Top = 196
      Width = 32
      Height = 24
      Caption = 'Off'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clTeal
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 1
    end
    object ST_KT2450MeasureRange: TStaticText
      Left = 15
      Top = 81
      Width = 49
      Height = 24
      Caption = 'Auto'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 2
    end
    object ST_KT2450MeasureLowRange: TStaticText
      Left = 12
      Top = 138
      Width = 59
      Height = 24
      Caption = '10 nA'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clOlive
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 3
    end
    object CB_KT2450Azero: TCheckBox
      Left = 12
      Top = 173
      Width = 97
      Height = 17
      Caption = 'Auto Zero'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
    object B_KT2450Azero: TButton
      Left = 119
      Top = 164
      Width = 98
      Height = 25
      Caption = 'Manual Zero'
      TabOrder = 5
    end
    object ST_KT2450MeasTime: TStaticText
      Left = 228
      Top = 92
      Width = 40
      Height = 24
      Caption = '143'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 6
    end
    object ST_KT2450DisplDN: TStaticText
      Left = 145
      Top = 196
      Width = 84
      Height = 24
      Caption = '5.5 digit'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clPurple
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 7
    end
    object B_KT2450_Meas: TButton
      Left = 31
      Top = 56
      Width = 79
      Height = 19
      Caption = 'measure'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
    end
    object ST_KT2450MCount: TStaticText
      Left = 175
      Top = 130
      Width = 40
      Height = 24
      Caption = '210'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 9
    end
  end
  object GB_FT2450Setup: TGroupBox
    Tag = 110
    Left = 632
    Top = 4
    Width = 139
    Height = 201
    Caption = 'Settings'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    object L_KT2450_DispBr: TLabel
      Left = 24
      Top = 153
      Width = 83
      Height = 16
      Caption = 'Display State'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object PKt2450LoadSetup: TPanel
      Left = 21
      Top = 49
      Width = 85
      Height = 23
      Cursor = crHandPoint
      BevelOuter = bvLowered
      Caption = 'Load Setup'
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
    object PKt2450SaveSetup: TPanel
      Left = 19
      Top = 20
      Width = 85
      Height = 23
      Cursor = crHandPoint
      BevelOuter = bvLowered
      Caption = 'Save Setup'
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
    end
    object B_KT2450GetSetting: TButton
      Left = 3
      Top = 78
      Width = 124
      Height = 25
      Caption = 'Get'
      TabOrder = 2
    end
    object B_Kt2450_Reset: TButton
      Left = 24
      Top = 111
      Width = 81
      Height = 25
      Caption = 'B_Kt2450_SetSet'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object ST_KT2450_DispBr: TStaticText
      Left = 3
      Top = 172
      Width = 136
      Height = 20
      Caption = 'sourceV measR(I)'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 4
    end
  end
  object GBKT2450Mode: TGroupBox
    Tag = 110
    Left = 5
    Top = 101
    Width = 336
    Height = 58
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    object L_KT2450Mode: TLabel
      Left = 19
      Top = 15
      Width = 43
      Height = 32
      Caption = 'Device Mode'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object ST_KT2450Mode: TStaticText
      Left = 111
      Top = 18
      Width = 199
      Height = 27
      Caption = 'sourceV measR(I)'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 0
    end
  end
  object GBKT2450_IVMeasur: TGroupBox
    Left = 349
    Top = 232
    Width = 396
    Height = 214
    Caption = 'IV measuring'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    object RG_KT2450SweepSelect: TRadioGroup
      Left = 95
      Top = 11
      Width = 248
      Height = 39
      Columns = 2
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemIndex = 0
      Items.Strings = (
        'From Setting'
        'From Sweep')
      ParentFont = False
      TabOrder = 0
    end
    object B_KT2450SweepCreate: TButton
      Left = 10
      Top = 56
      Width = 68
      Height = 25
      Caption = 'Create'
      TabOrder = 1
    end
    object B_KT2450SweepInit: TButton
      Left = 85
      Top = 56
      Width = 68
      Height = 25
      Caption = 'Init'
      TabOrder = 2
    end
    object B_KT2450SweepStop: TButton
      Left = 160
      Top = 56
      Width = 68
      Height = 25
      Caption = 'Abort'
      TabOrder = 3
    end
    object GB_KT2450Sweep: TGroupBox
      Left = 21
      Top = 81
      Width = 359
      Height = 130
      Caption = 'Sweep'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      object L_KT2450SweepStart: TLabel
        Left = 122
        Top = 20
        Width = 50
        Height = 16
        Caption = 'From, V'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object L_KT2450SweepStop: TLabel
        Left = 122
        Top = 47
        Width = 33
        Height = 16
        Caption = 'To, V'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBackground
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object L_KT2450SweepStepPoint: TLabel
        Left = 122
        Top = 74
        Width = 46
        Height = 16
        Caption = 'Step, V'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object L_KT2450SweepDelay: TLabel
        Left = 292
        Top = 20
        Width = 50
        Height = 16
        Caption = 'Delay, s'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object L_KT2450SweepCount: TLabel
        Left = 275
        Top = 62
        Width = 79
        Height = 16
        Caption = 'Times to run'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object L_KT2450SweepRange: TLabel
        Left = 215
        Top = 104
        Width = 72
        Height = 16
        Caption = 'Used range'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clOlive
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RG_KT2450SweepMode: TRadioGroup
        Left = 5
        Top = 15
        Width = 111
        Height = 78
        Caption = 'Mode'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'Linear Step'
          'Linear Point'
          'Log')
        ParentFont = False
        TabOrder = 0
      end
      object ST_KT2450SweepStart: TStaticText
        Left = 186
        Top = 19
        Width = 40
        Height = 24
        Caption = '210'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
        TabOrder = 1
      end
      object ST_KT2450SweepStop: TStaticText
        Left = 186
        Top = 44
        Width = 40
        Height = 24
        Caption = '210'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBackground
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
        TabOrder = 2
      end
      object ST_KT2450SweepStepPoint: TStaticText
        Left = 186
        Top = 71
        Width = 40
        Height = 24
        Caption = '210'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
        TabOrder = 3
      end
      object ST_KT2450SweepDelay: TStaticText
        Left = 300
        Top = 39
        Width = 40
        Height = 24
        Caption = '210'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
        TabOrder = 4
      end
      object ST_KT2450SweepCount: TStaticText
        Left = 313
        Top = 81
        Width = 16
        Height = 24
        Caption = '1'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clTeal
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
        TabOrder = 5
      end
      object ST_KT2450SweepRange: TStaticText
        Left = 302
        Top = 101
        Width = 53
        Height = 24
        Caption = 'BEST'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clOlive
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
        TabOrder = 6
      end
      object CB_KT2450SweepDual: TCheckBox
        Left = 149
        Top = 106
        Width = 60
        Height = 17
        Caption = 'Dual'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
      end
      object CB_KT2450SweepAbortLim: TCheckBox
        Left = 6
        Top = 105
        Width = 126
        Height = 17
        Caption = 'Abort on Limit'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
      end
    end
    object B_KT2450SweepPause: TButton
      Left = 235
      Top = 56
      Width = 68
      Height = 25
      Caption = 'Pause'
      TabOrder = 5
    end
    object B_KT2450SweepResume: TButton
      Left = 310
      Top = 56
      Width = 68
      Height = 25
      Caption = 'Resume'
      TabOrder = 6
    end
  end
end
