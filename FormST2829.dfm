object ST2829Form: TST2829Form
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'ST2829 Settings'
  ClientHeight = 454
  ClientWidth = 772
  Color = clSkyBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
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
  object GB_ST2829C_Com: TGroupBox
    Left = 557
    Top = -2
    Width = 215
    Height = 99
    Caption = 'COM parameters'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object B_MyTrain: TButton
    Left = 7
    Top = 45
    Width = 69
    Height = 25
    Caption = 'B_MyTrain'
    TabOrder = 2
  end
  object GB_Setting: TGroupBox
    Tag = 110
    Left = 625
    Top = 103
    Width = 139
    Height = 146
    Caption = 'Settings'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object PDM6500LoadSetup: TPanel
      Left = 25
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
      Left = 25
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
      Left = 7
      Top = 78
      Width = 124
      Height = 25
      Caption = 'Get'
      TabOrder = 2
    end
    object B_DM6500_Reset: TButton
      Left = 26
      Top = 111
      Width = 81
      Height = 25
      Caption = 'Reset'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
  end
end
