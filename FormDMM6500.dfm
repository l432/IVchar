object DMM6500Form: TDMM6500Form
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'DMM6500 Settings'
  ClientHeight = 454
  ClientWidth = 772
  Color = clMoneyGreen
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
    TabOrder = 0
    OnClick = BCloseClick
  end
  object B_MyTrain: TButton
    Left = 7
    Top = 45
    Width = 69
    Height = 25
    Caption = 'B_MyTrain'
    TabOrder = 1
  end
  object GB_DM6500IP: TGroupBox
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
    TabOrder = 2
    object E_DM6500Ip1: TEdit
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
    object UD_DM6500Ip1: TUpDown
      Left = 46
      Top = 28
      Width = 16
      Height = 24
      TabOrder = 1
    end
    object E_DM6500Ip2: TEdit
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
    object UD_DM6500Ip2: TUpDown
      Left = 108
      Top = 28
      Width = 16
      Height = 24
      TabOrder = 3
    end
    object E_DM6500Ip3: TEdit
      Left = 141
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
    object UD_DM6500Ip3: TUpDown
      Left = 171
      Top = 28
      Width = 16
      Height = 24
      TabOrder = 5
    end
    object E_DM6500Ip4: TEdit
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
    object UD_DM6500Ip4: TUpDown
      Left = 232
      Top = 28
      Width = 16
      Height = 24
      TabOrder = 7
    end
    object B_DM6500UpDate: TButton
      Left = 14
      Top = 58
      Width = 67
      Height = 25
      Caption = 'UpDate'
      TabOrder = 8
    end
    object B_DM6500Test: TButton
      Left = 87
      Top = 58
      Width = 161
      Height = 25
      Caption = 'DMM6500 Test'
      TabOrder = 9
    end
  end
  object GB_DM6500Setup: TGroupBox
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
    TabOrder = 3
    object L_DM6500_DispBr: TLabel
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
    object PDM6500LoadSetup: TPanel
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
    object PDM6500SaveSetup: TPanel
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
    object B_DM6500GetSetting: TButton
      Left = 3
      Top = 78
      Width = 124
      Height = 25
      Caption = 'Get'
      TabOrder = 2
    end
    object B_DM6500_Reset: TButton
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
    object ST_DM6500_DispBr: TStaticText
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
  object TelnetDMM6500: TIdTelnet
    Terminal = 'dumb'
    Left = 526
    Top = 530
  end
end
