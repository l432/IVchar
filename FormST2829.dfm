object ST2829Form: TST2829Form
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'ST2629 Settings'
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
  object GB_ST2829_Com: TGroupBox
    Left = 566
    Top = -2
    Width = 206
    Height = 97
    Caption = 'COM parameters'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object LST2829Port: TLabel
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
    object ComCBST2829_Port: TComComboBox
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
    object ST_ST2829_Rate: TStaticText
      Left = 102
      Top = 12
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
    object B_GDS_Test: TButton
      Left = 12
      Top = 63
      Width = 185
      Height = 25
      Caption = 'B_ST2829_SetSet'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object ComCBST2829_Baud: TComComboBox
      Left = 100
      Top = 31
      Width = 93
      Height = 26
      ComProperty = cpBaudRate
      AutoApply = True
      Text = 'Custom'
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 18
      ItemIndex = 0
      ParentFont = False
      TabOrder = 1
    end
  end
end
