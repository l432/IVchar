object IVchar: TIVchar
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'IVchar'
  ClientHeight = 494
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LConnected: TLabel
    Left = 8
    Top = 461
    Width = 74
    Height = 21
    Caption = 'ComPort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PC: TPageControl
    Left = 0
    Top = 0
    Width = 792
    Height = 441
    ActivePage = TS_DAC
    Align = alTop
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnChange = PCChange
    OnChanging = PCChanging
    object TS_Main: TTabSheet
      Caption = 'Main'
      object ChLine: TChart
        Left = 0
        Top = 0
        Width = 551
        Height = 205
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
          'I-V linear')
        View3D = False
        View3DOptions.Orthogonal = False
        Align = alCustom
        TabOrder = 0
        PrintMargins = (
          15
          30
          15
          30)
        object ForwLine: TPointSeries
          Marks.Callout.Brush.Color = clBlack
          Marks.Visible = False
          ClickableLine = False
          Pointer.HorizSize = 3
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.VertSize = 3
          Pointer.Visible = True
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object RevLine: TPointSeries
          Marks.Callout.Brush.Color = clBlack
          Marks.Visible = False
          SeriesColor = clBlue
          ClickableLine = False
          Pointer.InflateMargins = True
          Pointer.Style = psCircle
          Pointer.Visible = True
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
      object ChLg: TChart
        Left = 0
        Top = 205
        Width = 551
        Height = 205
        Legend.Visible = False
        MarginBottom = 0
        MarginLeft = 0
        MarginRight = 0
        MarginTop = 0
        Title.Text.Strings = (
          'I-V log')
        LeftAxis.Logarithmic = True
        View3D = False
        View3DOptions.Orthogonal = False
        Align = alCustom
        TabOrder = 1
        Anchors = [akLeft, akBottom]
        PrintMargins = (
          15
          30
          15
          30)
        object ForwLg: TPointSeries
          Marks.Callout.Brush.Color = clBlack
          Marks.Visible = False
          ClickableLine = False
          Pointer.HorizSize = 3
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.VertSize = 3
          Pointer.Visible = True
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object RevLg: TPointSeries
          Marks.Callout.Brush.Color = clBlack
          Marks.Visible = False
          SeriesColor = clBlue
          ClickableLine = False
          Pointer.InflateMargins = True
          Pointer.Style = psCircle
          Pointer.Visible = True
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
      object GBIV: TGroupBox
        Left = 555
        Top = 12
        Width = 223
        Height = 136
        Caption = 'I-V measurements'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object CBForw: TCheckBox
          Left = 12
          Top = 23
          Width = 74
          Height = 13
          Caption = 'Forward'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = CBForwClick
        end
        object CBRev: TCheckBox
          Left = 12
          Top = 46
          Width = 74
          Height = 13
          Caption = 'Reverse'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = CBForwClick
        end
        object BIVStart: TButton
          Left = 128
          Top = 19
          Width = 64
          Height = 21
          Caption = 'Start'
          TabOrder = 2
          OnClick = BIVStartClick
        end
        object BIVStop: TButton
          Tag = 4
          Left = 128
          Top = 55
          Width = 64
          Height = 19
          Caption = 'Stop'
          TabOrder = 3
          OnClick = BIVStopClick
        end
        object CBSStep: TCheckBox
          Left = 12
          Top = 69
          Width = 87
          Height = 13
          Caption = 'Strict Step'
          TabOrder = 4
        end
        object BIVSave: TButton
          Tag = 4
          Left = 79
          Top = 107
          Width = 64
          Height = 19
          Caption = 'Save'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          OnClick = BIVSaveClick
        end
        object PBIV: TProgressBar
          Left = 18
          Top = 86
          Width = 172
          Height = 16
          Step = 1
          TabOrder = 6
        end
      end
      object GBAD: TGroupBox
        Left = 555
        Top = 153
        Width = 223
        Height = 105
        Caption = 'Actual Data'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object LADVoltage: TLabel
          Left = 12
          Top = 24
          Width = 53
          Height = 16
          Caption = 'Voltage:'
        end
        object LADVoltageValue: TLabel
          Left = 80
          Top = 18
          Width = 84
          Height = 27
          Caption = '-3.456'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LADCurrent: TLabel
          Left = 12
          Top = 55
          Width = 51
          Height = 16
          Caption = 'Current:'
        end
        object LADCurrentValue: TLabel
          Left = 80
          Top = 49
          Width = 140
          Height = 27
          Caption = '-1.856e-10'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LADRange: TLabel
          Left = 49
          Top = 86
          Width = 136
          Height = 16
          Caption = 'Range is [-7.8 .. 7.5] V'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object GBT: TGroupBox
        Left = 556
        Top = 281
        Width = 222
        Height = 105
        Caption = 'Temperature'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object SBTAuto: TSpeedButton
          Left = 159
          Top = 18
          Width = 50
          Height = 26
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'Auto'
          OnClick = SBTAutoClick
        end
        object LTRunning: TLabel
          Left = 12
          Top = 18
          Width = 53
          Height = 16
          Caption = 'running:'
        end
        object LTRValue: TLabel
          Left = 6
          Top = 32
          Width = 135
          Height = 52
          Caption = '298.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -45
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTLast: TLabel
          Left = 11
          Top = 83
          Width = 113
          Height = 16
          Caption = 'last mesurement: '
        end
        object LTLastValue: TLabel
          Left = 136
          Top = 80
          Width = 70
          Height = 27
          Caption = '300.1'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
    object TS_B7_21A: TTabSheet
      Caption = 'B7_21A'
      ImageIndex = 1
      object LV721A: TLabel
        Left = 269
        Top = 19
        Width = 428
        Height = 80
        AutoSize = False
        Caption = '    ERROR'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -67
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object SBV721AAuto: TSpeedButton
        Left = 630
        Top = 136
        Width = 111
        Height = 33
        AllowAllUp = True
        GroupIndex = 2
        Caption = 'AUTO'
      end
      object LV721AU: TLabel
        Left = 706
        Top = 19
        Width = 75
        Height = 80
        AutoSize = False
        Caption = 'a'
        Color = clInfoText
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -67
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object LV721APin: TLabel
        Left = 424
        Top = 196
        Width = 117
        Height = 23
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -21
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LV721APinG: TLabel
        Left = 424
        Top = 300
        Width = 117
        Height = 23
        Caption = 'LV721APin'
      end
      object RGV721A_MM: TRadioGroup
        Left = 0
        Top = 0
        Width = 249
        Height = 105
        Caption = 'Measure Mode'
        Color = clCream
        Columns = 3
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        Items.Strings = (
          '1')
        ParentBackground = False
        ParentColor = False
        ParentFont = False
        TabOrder = 0
      end
      object RGV721ARange: TRadioGroup
        Left = 0
        Top = 111
        Width = 401
        Height = 275
        Caption = 'Range'
        Color = clSkyBlue
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Items.Strings = (
          '1')
        ParentBackground = False
        ParentColor = False
        ParentFont = False
        TabOrder = 1
      end
      object BV721AMeas: TButton
        Left = 424
        Top = 136
        Width = 158
        Height = 33
        Caption = 'measurement'
        TabOrder = 2
      end
      object CBV721A: TComboBox
        Tag = 1
        Left = 424
        Top = 239
        Width = 92
        Height = 32
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 24
        ParentFont = False
        TabOrder = 3
      end
      object BV721ASet: TButton
        Left = 569
        Top = 227
        Width = 117
        Height = 29
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
      object BV721ASetGate: TButton
        Left = 569
        Top = 264
        Width = 117
        Height = 29
        Caption = 'set gate'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
    end
    object TS_B7_21: TTabSheet
      Caption = 'B7_21'
      ImageIndex = 2
      object PanelV721_I: TPanel
        Left = 0
        Top = 0
        Width = 784
        Height = 201
        Align = alTop
        TabOrder = 0
        object LV721IPin: TLabel
          Left = 540
          Top = 85
          Width = 240
          Height = 32
          AutoSize = False
          Caption = 'LV721APin'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object LV721I: TLabel
          Left = 263
          Top = 0
          Width = 428
          Height = 80
          AutoSize = False
          Caption = '    ERROR'
          Color = clWhite
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -67
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LV721IU: TLabel
          Left = 700
          Top = 0
          Width = 75
          Height = 80
          AutoSize = False
          Caption = 'a'
          Color = clInfoText
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWhite
          Font.Height = -67
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object SBV721IAuto: TSpeedButton
          Left = 430
          Top = 154
          Width = 97
          Height = 33
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
        end
        object LV721IPinG: TLabel
          Left = 540
          Top = 168
          Width = 210
          Height = 22
          AutoSize = False
          Caption = 'LV721APin'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object RGV721I_MM: TRadioGroup
          Left = 0
          Top = 0
          Width = 249
          Height = 80
          Caption = 'Measure Mode'
          Color = clCream
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          Items.Strings = (
            '1')
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 0
        end
        object CBV721I: TComboBox
          Tag = 1
          Left = 555
          Top = 122
          Width = 93
          Height = 32
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 24
          ParentFont = False
          TabOrder = 1
        end
        object BV721ISet: TButton
          Left = 662
          Top = 113
          Width = 115
          Height = 23
          Caption = 'set control'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object RGV721IRange: TRadioGroup
          Left = 0
          Top = 85
          Width = 423
          Height = 115
          Caption = 'Range'
          Color = clSkyBlue
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Items.Strings = (
            '1')
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 3
        end
        object BV721IMeas: TButton
          Left = 430
          Top = 97
          Width = 97
          Height = 39
          Caption = 'measure'
          TabOrder = 4
        end
        object BV721ISetGate: TButton
          Left = 662
          Top = 141
          Width = 115
          Height = 23
          Caption = 'set gate'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
      end
      object PanelV721_II: TPanel
        Left = 0
        Top = 202
        Width = 784
        Height = 201
        Align = alBottom
        TabOrder = 1
        object LV721IIPin: TLabel
          Left = 5
          Top = 90
          Width = 240
          Height = 33
          AutoSize = False
          Caption = 'LV721APin'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object LV721II: TLabel
          Left = 0
          Top = 0
          Width = 427
          Height = 80
          AutoSize = False
          Caption = '    ERROR'
          Color = clWhite
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -67
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LV721IIU: TLabel
          Left = 437
          Top = 0
          Width = 75
          Height = 80
          AutoSize = False
          Caption = 'a'
          Color = clInfoText
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWhite
          Font.Height = -67
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object SBV721IIAuto: TSpeedButton
          Left = 250
          Top = 154
          Width = 97
          Height = 33
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
        end
        object LV721IIPinG: TLabel
          Left = 5
          Top = 166
          Width = 240
          Height = 33
          AutoSize = False
          Caption = 'LV721APin'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object RGV721II_MM: TRadioGroup
          Left = 532
          Top = 0
          Width = 250
          Height = 80
          Caption = 'Measure Mode'
          Color = clCream
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          Items.Strings = (
            '1')
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 0
        end
        object CBV721II: TComboBox
          Tag = 1
          Left = 5
          Top = 122
          Width = 92
          Height = 32
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 24
          ParentFont = False
          TabOrder = 1
        end
        object BV721IISet: TButton
          Left = 110
          Top = 113
          Width = 115
          Height = 23
          Caption = 'set control'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object RGV721IIRange: TRadioGroup
          Left = 361
          Top = 85
          Width = 421
          Height = 115
          Caption = 'Range'
          Color = clSkyBlue
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Items.Strings = (
            '1')
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 3
        end
        object BV721IIMeas: TButton
          Left = 250
          Top = 96
          Width = 97
          Height = 39
          Caption = 'measure'
          TabOrder = 4
        end
        object BV721IISetGate: TButton
          Left = 110
          Top = 141
          Width = 115
          Height = 23
          Caption = 'set gate'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
      end
      object PanelSplit: TPanel
        Left = 0
        Top = 196
        Width = 784
        Height = 13
        Color = clTeal
        ParentBackground = False
        TabOrder = 2
      end
    end
    object TS_DAC: TTabSheet
      Caption = 'DAC'
      ImageIndex = 3
      object LDACPinC: TLabel
        Left = 544
        Top = 44
        Width = 240
        Height = 32
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object LDACPinG: TLabel
        Left = 544
        Top = 112
        Width = 240
        Height = 32
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object LDACPinLDAC: TLabel
        Left = 544
        Top = 179
        Width = 240
        Height = 32
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object LDACPinCLR: TLabel
        Left = 544
        Top = 246
        Width = 240
        Height = 32
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object PanelDACChA: TPanel
        Left = 2
        Top = 2
        Width = 226
        Height = 351
        BevelWidth = 3
        BorderStyle = bsSingle
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object LORChA: TLabel
          Left = 99
          Top = 80
          Width = 104
          Height = 20
          Caption = '-10.8..10.8'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LPowChA: TLabel
          Left = 111
          Top = 38
          Width = 77
          Height = 18
          Caption = 'Power on'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LOVChA: TLabel
          Left = 99
          Top = 141
          Width = 74
          Height = 20
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object STChA: TStaticText
          Left = 32
          Top = 0
          Width = 122
          Height = 29
          Caption = 'Channel A'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object STORChA: TStaticText
          Left = 2
          Top = 85
          Width = 95
          Height = 20
          Caption = 'Output Range:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object CBORChA: TComboBox
          Left = 8
          Top = 106
          Width = 109
          Height = 26
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ItemHeight = 18
          ParentFont = False
          TabOrder = 2
        end
        object BORChA: TButton
          Left = 135
          Top = 106
          Width = 82
          Height = 22
          Caption = 'set range'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object BBPowChA: TBitBtn
          Left = 19
          Top = 37
          Width = 75
          Height = 25
          Caption = 'Off'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object BOVchangeChA: TButton
          Left = 11
          Top = 168
          Width = 83
          Height = 23
          Caption = 'change'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object BOVsetChA: TButton
          Left = 122
          Top = 168
          Width = 83
          Height = 23
          Caption = 'set value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object STOVChA: TStaticText
          Left = 2
          Top = 146
          Width = 87
          Height = 20
          Caption = 'OutputValue:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object GBMeasChA: TGroupBox
          Tag = 110
          Left = 32
          Top = 200
          Width = 154
          Height = 133
          Caption = 'Measurement'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
          object LMeasChA: TLabel
            Left = 34
            Top = 15
            Width = 70
            Height = 20
            Caption = '-0.0008'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Courier'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object RBMeasSimChA: TRadioButton
            Tag = 110
            Left = 3
            Top = 68
            Width = 87
            Height = 13
            Caption = 'Simulation'
            TabOrder = 0
          end
          object RBMeasMeasChA: TRadioButton
            Tag = 111
            Left = 3
            Top = 87
            Width = 105
            Height = 13
            Caption = 'Measurement'
            TabOrder = 1
          end
          object CBMeasChA: TComboBox
            Tag = 5
            Left = 3
            Top = 103
            Width = 111
            Height = 24
            Style = csDropDownList
            ItemHeight = 16
            TabOrder = 2
          end
          object BMeasChA: TButton
            Left = 24
            Top = 39
            Width = 105
            Height = 23
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
        end
      end
      object CBDAC: TComboBox
        Tag = 1
        Left = 674
        Top = 8
        Width = 93
        Height = 32
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 24
        ParentFont = False
        TabOrder = 1
      end
      object BDACSetC: TButton
        Left = 669
        Top = 81
        Width = 115
        Height = 23
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object BDACSetG: TButton
        Left = 669
        Top = 148
        Width = 115
        Height = 23
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object BDACSetLDAC: TButton
        Left = 669
        Top = 216
        Width = 115
        Height = 23
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
      object BDACSetCLR: TButton
        Left = 669
        Top = 283
        Width = 115
        Height = 23
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
      object BDACInit: TButton
        Left = 68
        Top = 359
        Width = 123
        Height = 32
        Caption = 'Initialization'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
      end
      object BDACReset: TButton
        Left = 279
        Top = 359
        Width = 123
        Height = 32
        Caption = 'Reset'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
      end
      object PanelDACChB: TPanel
        Left = 241
        Top = 2
        Width = 225
        Height = 351
        BevelWidth = 3
        BorderStyle = bsSingle
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        object LORChB: TLabel
          Left = 99
          Top = 80
          Width = 104
          Height = 20
          Caption = '-10.8..10.8'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LPowChB: TLabel
          Left = 111
          Top = 38
          Width = 77
          Height = 18
          Caption = 'Power on'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LOVChB: TLabel
          Left = 99
          Top = 141
          Width = 74
          Height = 20
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object STChB: TStaticText
          Left = 32
          Top = 0
          Width = 122
          Height = 29
          Caption = 'Channel B'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object STORChB: TStaticText
          Left = 2
          Top = 85
          Width = 95
          Height = 20
          Caption = 'Output Range:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object CBORChB: TComboBox
          Left = 8
          Top = 106
          Width = 109
          Height = 26
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ItemHeight = 18
          ParentFont = False
          TabOrder = 2
        end
        object BORChB: TButton
          Left = 135
          Top = 106
          Width = 82
          Height = 22
          Caption = 'set range'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object BBPowChB: TBitBtn
          Left = 19
          Top = 37
          Width = 75
          Height = 25
          Caption = 'Off'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STOVChB: TStaticText
          Left = 2
          Top = 146
          Width = 87
          Height = 20
          Caption = 'OutputValue:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object BOVchangeChB: TButton
          Left = 11
          Top = 168
          Width = 83
          Height = 23
          Caption = 'change'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object BOVsetChB: TButton
          Left = 122
          Top = 167
          Width = 83
          Height = 23
          Caption = 'set value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object GBMeasChB: TGroupBox
          Tag = 110
          Left = 32
          Top = 200
          Width = 154
          Height = 133
          Caption = 'Measurement'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
          object LMeasChB: TLabel
            Left = 34
            Top = 15
            Width = 70
            Height = 20
            Caption = '-0.0008'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Courier'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object RBMeasSimChB: TRadioButton
            Tag = 110
            Left = 3
            Top = 68
            Width = 87
            Height = 13
            Caption = 'Simulation'
            TabOrder = 0
          end
          object RBMeasMeasChB: TRadioButton
            Tag = 111
            Left = 3
            Top = 87
            Width = 105
            Height = 13
            Caption = 'Measurement'
            TabOrder = 1
          end
          object CBMeasChB: TComboBox
            Tag = 5
            Left = 3
            Top = 103
            Width = 111
            Height = 24
            Style = csDropDownList
            ItemHeight = 16
            TabOrder = 2
          end
          object BMeasChB: TButton
            Left = 24
            Top = 39
            Width = 105
            Height = 23
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
        end
      end
    end
    object TS_DACR2R: TTabSheet
      Caption = 'DAC R-2R'
      ImageIndex = 5
      object LDACR2RPinC: TLabel
        Left = 13
        Top = 60
        Width = 240
        Height = 32
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object LDACR2RPinG: TLabel
        Left = 13
        Top = 128
        Width = 240
        Height = 32
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object LOVDACR2R: TLabel
        Left = 469
        Top = 23
        Width = 74
        Height = 20
        Caption = '-0.0008'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CBDACR2R: TComboBox
        Tag = 1
        Left = 10
        Top = 16
        Width = 93
        Height = 32
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 24
        ParentFont = False
        TabOrder = 0
      end
      object BDACR2RSetC: TButton
        Left = 10
        Top = 99
        Width = 115
        Height = 23
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object BDACR2RSetG: TButton
        Left = 10
        Top = 166
        Width = 115
        Height = 23
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object STOVDACR2R: TStaticText
        Left = 372
        Top = 28
        Width = 87
        Height = 20
        Caption = 'OutputValue:'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object BOVchangeDACR2R: TButton
        Left = 380
        Top = 50
        Width = 83
        Height = 23
        Caption = 'change'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
      object BOVsetDACR2R: TButton
        Left = 492
        Top = 50
        Width = 82
        Height = 23
        Caption = 'set value'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
      object GBMeasR2R: TGroupBox
        Tag = 110
        Left = 612
        Top = 11
        Width = 153
        Height = 133
        Caption = 'Measurement'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        object LMeasR2R: TLabel
          Left = 34
          Top = 15
          Width = 70
          Height = 20
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RBMeasSimR2R: TRadioButton
          Tag = 110
          Left = 3
          Top = 68
          Width = 87
          Height = 13
          Caption = 'Simulation'
          TabOrder = 0
        end
        object RBMeasMeasR2R: TRadioButton
          Tag = 111
          Left = 3
          Top = 87
          Width = 105
          Height = 13
          Caption = 'Measurement'
          TabOrder = 1
        end
        object CBMeasR2R: TComboBox
          Tag = 5
          Left = 3
          Top = 103
          Width = 111
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 2
        end
        object BMeasR2R: TButton
          Left = 24
          Top = 39
          Width = 105
          Height = 23
          Caption = 'to measure'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
      end
    end
    object TS_Setting: TTabSheet
      Caption = 'Setting'
      ImageIndex = 4
      object GBFB: TGroupBox
        Left = 17
        Top = 12
        Width = 186
        Height = 240
        Caption = 'Forward branch'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object LFBHighlimitValue: TLabel
          Left = 116
          Top = 18
          Width = 28
          Height = 24
          Caption = '7.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LFBLowlimitValue: TLabel
          Left = 116
          Top = 49
          Width = 28
          Height = 24
          Caption = '7.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LFBDelayValue: TLabel
          Left = 88
          Top = 210
          Width = 44
          Height = 24
          Caption = '5000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object STFBSteps: TStaticText
          Left = 21
          Top = 83
          Width = 147
          Height = 22
          Caption = 'measurement steps:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
        object UDFBHighLimit: TUpDown
          Tag = 2
          Left = 159
          Top = 18
          Width = 16
          Height = 23
          Max = 80
          Position = 40
          TabOrder = 0
          OnClick = UDFBHighLimitClick
        end
        object STFBhighlimit: TStaticText
          Left = 11
          Top = 21
          Width = 93
          Height = 22
          Caption = 'high limit, V :'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object UDFBLowLimit: TUpDown
          Tag = 2
          Left = 159
          Top = 48
          Width = 16
          Height = 24
          Max = 80
          Position = 40
          TabOrder = 2
          OnClick = UDFBHighLimitClick
        end
        object STFBlowlimit: TStaticText
          Left = 11
          Top = 51
          Width = 86
          Height = 22
          Caption = 'low limit, V :'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object SGFBStep: TStringGrid
          Tag = 3
          Left = 11
          Top = 102
          Width = 101
          Height = 88
          ColCount = 2
          FixedCols = 0
          RowCount = 4
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
          ScrollBars = ssVertical
          TabOrder = 4
          OnDrawCell = SGFBStepDrawCell
          OnSelectCell = SGFBStepSelectCell
          ColWidths = (
            53
            50)
        end
        object BFBEdit: TButton
          Tag = 4
          Left = 116
          Top = 128
          Width = 64
          Height = 20
          Caption = 'Edit'
          TabOrder = 5
          OnClick = BFBEditClick
        end
        object BFBDelete: TButton
          Tag = 4
          Left = 116
          Top = 153
          Width = 64
          Height = 21
          Caption = 'Delete'
          TabOrder = 6
          OnClick = BFBDeleteClick
        end
        object BFBAdd: TButton
          Left = 116
          Top = 102
          Width = 64
          Height = 21
          Caption = 'Add'
          TabOrder = 7
          OnClick = BFBAddClick
        end
        object STFBDelay: TStaticText
          Left = 11
          Top = 195
          Width = 75
          Height = 42
          AutoSize = False
          Caption = 'delay time, ms :'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
        end
        object BFBDelayInput: TButton
          Left = 138
          Top = 210
          Width = 46
          Height = 21
          Caption = 'Input'
          TabOrder = 10
          OnClick = BFBDelayInputClick
        end
      end
      object GBRB: TGroupBox
        Left = 231
        Top = 12
        Width = 186
        Height = 240
        Caption = 'Reverse branch'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object LRBHighlimitValue: TLabel
          Left = 116
          Top = 18
          Width = 28
          Height = 24
          Caption = '7.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LRBLowlimitValue: TLabel
          Left = 116
          Top = 49
          Width = 28
          Height = 24
          Caption = '7.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LRBDelayValue: TLabel
          Left = 88
          Top = 210
          Width = 44
          Height = 24
          Caption = '5000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object STRBSteps: TStaticText
          Left = 21
          Top = 83
          Width = 147
          Height = 22
          Caption = 'measurement steps:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
        object UDRBHighLimit: TUpDown
          Tag = 2
          Left = 159
          Top = 18
          Width = 16
          Height = 23
          Max = 80
          Position = 40
          TabOrder = 0
          OnClick = UDFBHighLimitClick
        end
        object STRBhighlimit: TStaticText
          Left = 11
          Top = 21
          Width = 93
          Height = 22
          Caption = 'high limit, V :'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object UDRBLowLimit: TUpDown
          Tag = 2
          Left = 159
          Top = 48
          Width = 16
          Height = 24
          Max = 80
          Position = 40
          TabOrder = 2
          OnClick = UDFBHighLimitClick
        end
        object STRBlowlimit: TStaticText
          Left = 11
          Top = 51
          Width = 86
          Height = 22
          Caption = 'low limit, V :'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object SGRBStep: TStringGrid
          Tag = 3
          Left = 11
          Top = 102
          Width = 101
          Height = 88
          ColCount = 2
          FixedCols = 0
          RowCount = 4
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
          ScrollBars = ssVertical
          TabOrder = 4
          OnDrawCell = SGRBStepDrawCell
          OnSelectCell = SGFBStepSelectCell
          ColWidths = (
            53
            50)
        end
        object BRBEdit: TButton
          Tag = 4
          Left = 116
          Top = 128
          Width = 64
          Height = 20
          Caption = 'Edit'
          TabOrder = 5
          OnClick = BRBEditClick
        end
        object BRBDelete: TButton
          Tag = 4
          Left = 116
          Top = 153
          Width = 64
          Height = 21
          Caption = 'Delete'
          TabOrder = 6
          OnClick = BRBDeleteClick
        end
        object BRBAdd: TButton
          Left = 116
          Top = 102
          Width = 64
          Height = 21
          Caption = 'Add'
          TabOrder = 7
          OnClick = BFBAddClick
        end
        object STRBDelay: TStaticText
          Left = 11
          Top = 195
          Width = 75
          Height = 42
          AutoSize = False
          Caption = 'delay time, ms :'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
        end
        object BRBDelayInput: TButton
          Left = 138
          Top = 210
          Width = 46
          Height = 21
          Caption = 'Input'
          TabOrder = 10
          OnClick = BFBDelayInputClick
        end
      end
      object GBTS: TGroupBox
        Tag = 100
        Left = 447
        Top = 12
        Width = 135
        Height = 111
        Caption = 'Temperature source'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object RBTSImitation: TRadioButton
          Tag = 100
          Left = 12
          Top = 18
          Width = 87
          Height = 13
          Caption = 'Simulation'
          TabOrder = 0
        end
        object RBTSTermocouple: TRadioButton
          Tag = 101
          Left = 12
          Top = 48
          Width = 105
          Height = 13
          Caption = 'Thermocouple'
          TabOrder = 1
        end
        object CBTSTC: TComboBox
          Tag = 5
          Left = 12
          Top = 69
          Width = 111
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 2
        end
      end
      object GBVS: TGroupBox
        Tag = 110
        Left = 447
        Top = 138
        Width = 135
        Height = 111
        Caption = 'Voltage source'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object RBVSSimulation: TRadioButton
          Tag = 110
          Left = 12
          Top = 18
          Width = 87
          Height = 13
          Caption = 'Simulation'
          TabOrder = 0
        end
        object RBVSMeasur: TRadioButton
          Tag = 111
          Left = 12
          Top = 48
          Width = 105
          Height = 13
          Caption = 'Measurement'
          TabOrder = 1
        end
        object CBVSMeas: TComboBox
          Tag = 5
          Left = 12
          Top = 69
          Width = 111
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 2
        end
      end
      object GBCS: TGroupBox
        Tag = 120
        Left = 618
        Top = 140
        Width = 135
        Height = 111
        Caption = 'Current source'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object RBCSSimulation: TRadioButton
          Tag = 120
          Left = 12
          Top = 18
          Width = 87
          Height = 13
          Caption = 'Simulation'
          TabOrder = 0
        end
        object RBCSMeasur: TRadioButton
          Tag = 121
          Left = 12
          Top = 48
          Width = 105
          Height = 13
          Caption = 'Measurement'
          TabOrder = 1
        end
        object CBCSMeas: TComboBox
          Tag = 5
          Left = 12
          Top = 69
          Width = 111
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 2
        end
      end
      object BSaveSetting: TButton
        Left = 642
        Top = 12
        Width = 111
        Height = 25
        Caption = 'Save Setting'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        OnClick = BSaveSettingClick
      end
      object RGInputVoltage: TRadioGroup
        Left = 618
        Top = 41
        Width = 135
        Height = 94
        Caption = 'Input voltage'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Items.Strings = (
          'Simulation'
          'DAC Channel A'
          'DAC Channel B'
          'DAC R2R')
        ParentFont = False
        TabOrder = 6
      end
      object RGDO: TRadioGroup
        Left = 17
        Top = 252
        Width = 123
        Height = 74
        Caption = 'Diod orientation'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Items.Strings = (
          'Normal'
          'Inverse')
        ParentFont = False
        TabOrder = 7
      end
      object GBPR: TGroupBox
        Left = 17
        Top = 327
        Width = 175
        Height = 74
        Caption = 'Parasitic resistance'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        object LPR: TLabel
          Left = 8
          Top = 15
          Width = 93
          Height = 20
          Caption = '1.26E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object BPR: TButton
          Left = 2
          Top = 43
          Width = 102
          Height = 23
          Caption = 'input value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = BPRClick
        end
      end
      object GBMC: TGroupBox
        Left = 198
        Top = 253
        Width = 137
        Height = 74
        Caption = 'Maximum current'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
        object LMC: TLabel
          Left = 11
          Top = 17
          Width = 93
          Height = 20
          Caption = '1.26E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object BMC: TButton
          Left = 2
          Top = 43
          Width = 102
          Height = 23
          Caption = 'input value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = BPRClick
        end
      end
      object GBMinC: TGroupBox
        Left = 198
        Top = 327
        Width = 137
        Height = 74
        Caption = 'Minimum current'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
        object LMinC: TLabel
          Left = 8
          Top = 15
          Width = 93
          Height = 20
          Caption = '1.26E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object BMinC: TButton
          Left = 2
          Top = 43
          Width = 102
          Height = 23
          Caption = 'input value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = BPRClick
        end
      end
      object GBCOM: TGroupBox
        Left = 520
        Top = 255
        Width = 233
        Height = 82
        Caption = 'COM parameters'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 11
        object ComCBPort: TComComboBox
          Left = 12
          Top = 40
          Width = 74
          Height = 26
          ComPort = ComPort1
          ComProperty = cpPort
          AutoApply = True
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 18
          ItemIndex = -1
          ParentFont = False
          TabOrder = 0
        end
        object ComCBBR: TComComboBox
          Left = 122
          Top = 40
          Width = 93
          Height = 26
          ComPort = ComPort1
          ComProperty = cpBaudRate
          AutoApply = True
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 18
          ItemIndex = -1
          ParentFont = False
          TabOrder = 1
        end
        object STCOMP: TStaticText
          Left = 31
          Top = 15
          Width = 39
          Height = 22
          Caption = 'Port'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object StaticText1: TStaticText
          Left = 132
          Top = 15
          Width = 89
          Height = 22
          Caption = 'Baud Rate'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
      end
    end
  end
  object BBClose: TBitBtn
    Left = 586
    Top = 461
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkClose
  end
  object BConnect: TButton
    Left = 156
    Top = 461
    Width = 75
    Height = 25
    Caption = 'BConnect'
    TabOrder = 2
    OnClick = BConnectClick
  end
  object BParamReceive: TButton
    Left = 297
    Top = 461
    Width = 75
    Height = 25
    Caption = 'Receive pin numbers'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    WordWrap = True
    OnClick = BParamReceiveClick
  end
  object ComPort1: TComPort
    BaudRate = br115200
    Port = 'COM3'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    Timeouts.WriteTotalMultiplier = 10
    Timeouts.WriteTotalConstant = 100
    StoredProps = [spBasic, spBuffer, spTimeouts]
    TriggersOnRxChar = False
    Left = 976
    Top = 576
  end
  object Time: TTimer
    Interval = 3000
    Left = 1008
    Top = 576
  end
  object ComDPacket: TComDataPacket
    OnPacket = ComDPacketPacket
    Left = 944
    Top = 576
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.dat'
    Filter = 'data files (*.dat)|*.dat|all files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoValidate, ofPathMustExist, ofShareAware, ofNoTestFileCreate, ofNoNetworkButton, ofNoLongNames, ofNoDereferenceLinks, ofEnableSizing, ofDontAddToRecent]
    OptionsEx = [ofExNoPlacesBar]
    Left = 912
    Top = 576
  end
end
