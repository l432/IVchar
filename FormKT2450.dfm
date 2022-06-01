object KT2450Form: TKT2450Form
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'KT2450 Settings'
  ClientHeight = 454
  ClientWidth = 735
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
  object SB_Kt2450_OutPut: TSpeedButton
    Left = 360
    Top = 8
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
  object L_KT2450Mode: TLabel
    Left = 11
    Top = 111
    Width = 43
    Height = 32
    Caption = 'Device Mode'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object GB_K2450IP: TGroupBox
    Tag = 110
    Left = 88
    Top = 4
    Width = 268
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
      Left = 96
      Top = 58
      Width = 161
      Height = 25
      Caption = 'Kt2450Test'
      TabOrder = 9
    end
  end
  object BClose: TButton
    Left = 5
    Top = 4
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
  object GB_KT2450Sweep: TGroupBox
    Left = 464
    Top = 8
    Width = 263
    Height = 199
    Caption = 'Sweep'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object L_KT2450SweepStart: TLabel
      Left = 127
      Top = 56
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
      Left = 127
      Top = 83
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
      Left = 127
      Top = 110
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
      Left = 15
      Top = 156
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
      Left = 82
      Top = 156
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
      Left = 178
      Top = 156
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
    object B_KT2450SweepCreate: TButton
      Left = 13
      Top = 20
      Width = 68
      Height = 25
      Caption = 'Create'
      TabOrder = 0
    end
    object B_KT2450SweepInit: TButton
      Left = 87
      Top = 20
      Width = 68
      Height = 25
      Caption = 'Init'
      TabOrder = 1
    end
    object B_KT2450SweepStop: TButton
      Left = 161
      Top = 20
      Width = 68
      Height = 25
      Caption = 'Abort'
      TabOrder = 2
    end
    object RG_KT2450SweepMode: TRadioGroup
      Left = 10
      Top = 51
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
      TabOrder = 3
    end
    object ST_KT2450SweepStart: TStaticText
      Left = 183
      Top = 53
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
      TabOrder = 4
    end
    object ST_KT2450SweepStop: TStaticText
      Left = 183
      Top = 80
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
      TabOrder = 5
    end
    object ST_KT2450SweepStepPoint: TStaticText
      Left = 183
      Top = 107
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
      TabOrder = 6
    end
    object ST_KT2450SweepDelay: TStaticText
      Left = 15
      Top = 169
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
      TabOrder = 7
    end
    object ST_KT2450SweepCount: TStaticText
      Left = 111
      Top = 169
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
      TabOrder = 8
    end
    object ST_KT2450SweepRange: TStaticText
      Left = 191
      Top = 169
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
      TabOrder = 9
    end
    object CB_KT2450SweepDual: TCheckBox
      Left = 16
      Top = 135
      Width = 60
      Height = 17
      Caption = 'Dual'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
    end
    object CB_KT2450SweepAbortLim: TCheckBox
      Left = 107
      Top = 133
      Width = 126
      Height = 17
      Caption = 'Abort on Limit'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
    end
  end
  object B_Kt2450_Reset: TButton
    Left = 362
    Top = 39
    Width = 75
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
  object B_MyTrain: TButton
    Left = 372
    Top = 143
    Width = 75
    Height = 25
    Caption = 'B_MyTrain'
    TabOrder = 4
  end
  object ST_KT2450Mode: TStaticText
    Left = 73
    Top = 117
    Width = 176
    Height = 24
    Caption = 'sourceV measR(I)'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clGreen
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    TabOrder = 5
  end
  object GB_Kt2450_Source: TGroupBox
    Left = 5
    Top = 165
    Width = 336
    Height = 274
    Caption = 'Source'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    object SB_Kt2450_Termin: TSpeedButton
      Left = 7
      Top = 22
      Width = 121
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
      Left = 3
      Top = 109
      Width = 46
      Height = 32
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
      Top = 162
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
      Top = 162
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
      Top = 230
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
      Left = 205
      Top = 109
      Width = 100
      Height = 16
      Caption = 'Output Value, V'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ST_Kt2450_OutPut: TStaticText
      Left = 68
      Top = 115
      Width = 73
      Height = 24
      Caption = 'Normal'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clTeal
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 0
    end
    object ST_KT2450VolProt: TStaticText
      Left = 12
      Top = 200
      Width = 53
      Height = 24
      Caption = 'None'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 1
    end
    object ST_KT2450LimitSource: TStaticText
      Left = 95
      Top = 200
      Width = 40
      Height = 24
      Caption = '210'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clOlive
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 2
    end
    object CB_KT2450ReadBack: TCheckBox
      Left = 194
      Top = 202
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
      Left = 205
      Top = 172
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
      TabOrder = 4
    end
    object CB_KT2450DelaySource: TCheckBox
      Left = 7
      Top = 250
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
      Top = 247
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
      Left = 205
      Top = 127
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
      Left = 194
      Top = 240
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
  end
  object GB_Kt2450_Mes: TGroupBox
    Left = 356
    Top = 216
    Width = 235
    Height = 223
    Caption = 'Resistance'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
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
      Left = 88
      Top = 58
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
      Left = 14
      Top = 101
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
    object ST_KT2450_Sense: TStaticText
      Left = 10
      Top = 18
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
      Left = 11
      Top = 71
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
      Left = 154
      Top = 66
      Width = 59
      Height = 24
      Caption = '10 nA'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 3
    end
    object CB_KT2450Azero: TCheckBox
      Left = 16
      Top = 167
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
      Top = 160
      Width = 98
      Height = 25
      Caption = 'Manual Zero'
      TabOrder = 5
    end
    object ST_KT2450MeasTime: TStaticText
      Left = 14
      Top = 134
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
  end
  object GB_FT2450Setup: TGroupBox
    Tag = 110
    Left = 622
    Top = 226
    Width = 108
    Height = 122
    Caption = 'Settings'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    object PKt2450LoadSetup: TPanel
      Left = 11
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
      Left = 11
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
      Left = 13
      Top = 78
      Width = 84
      Height = 25
      Caption = 'Get'
      TabOrder = 2
    end
  end
end
