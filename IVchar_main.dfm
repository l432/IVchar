object IVchar: TIVchar
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'IVchar'
  ClientHeight = 537
  ClientWidth = 789
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
    Left = 6
    Top = 508
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
    Width = 789
    Height = 496
    ActivePage = TS_ADC
    Align = alTop
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    MultiLine = True
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
        Top = 209
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
        Left = 557
        Top = 3
        Width = 223
        Height = 169
        Caption = 'Measurements'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object CBForw: TCheckBox
          Tag = 7
          Left = 12
          Top = 48
          Width = 74
          Height = 13
          Caption = 'Forward'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object CBRev: TCheckBox
          Tag = 7
          Left = 12
          Top = 73
          Width = 74
          Height = 13
          Caption = 'Reverse'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object BIVStart: TButton
          Left = 138
          Top = 44
          Width = 65
          Height = 22
          Caption = 'Start'
          TabOrder = 2
          OnClick = BIVStartClick
        end
        object BIVStop: TButton
          Tag = 4
          Left = 140
          Top = 70
          Width = 64
          Height = 19
          Caption = 'Stop'
          TabOrder = 3
        end
        object BIVSave: TButton
          Tag = 4
          Left = 73
          Top = 143
          Width = 64
          Height = 19
          Caption = 'Save'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object PBIV: TProgressBar
          Left = 18
          Top = 122
          Width = 172
          Height = 16
          Step = 1
          TabOrder = 5
        end
        object CBPC: TCheckBox
          Tag = 6
          Left = 12
          Top = 88
          Width = 208
          Height = 29
          Caption = 'Previous correction is used'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          WordWrap = True
        end
        object CBMeasurements: TComboBox
          Left = 9
          Top = 18
          Width = 194
          Height = 24
          ItemHeight = 16
          TabOrder = 7
          OnChange = CBMeasurementsChange
        end
      end
      object GBAD: TGroupBox
        Left = 556
        Top = 177
        Width = 222
        Height = 120
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
          Top = 46
          Width = 53
          Height = 16
          Caption = 'Voltage:'
        end
        object LADVoltageValue: TLabel
          Left = 80
          Top = 41
          Width = 79
          Height = 20
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
          Top = 77
          Width = 51
          Height = 16
          Caption = 'Current:'
        end
        object LADCurrentValue: TLabel
          Left = 80
          Top = 71
          Width = 131
          Height = 20
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
          Top = 99
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
        object LADInputVoltage: TLabel
          Left = 21
          Top = 19
          Width = 86
          Height = 16
          Caption = 'Input Voltage:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsItalic]
          ParentFont = False
        end
        object LADInputVoltageValue: TLabel
          Left = 113
          Top = 18
          Width = 41
          Height = 18
          Caption = '-3.456'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object GBT: TGroupBox
        Left = 556
        Top = 301
        Width = 222
        Height = 107
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
          Left = 5
          Top = 37
          Width = 151
          Height = 40
          Caption = '298.51'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -41
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
          Width = 79
          Height = 20
          Caption = '300.10'
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
        Font.Height = -63
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
      object PV721APinG: TPanel
        Left = 424
        Top = 350
        Width = 317
        Height = 32
        Cursor = crHandPoint
        BevelOuter = bvLowered
        Caption = 'Gate Pin is 26'
        Color = clSilver
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHotLight
        Font.Height = -17
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
      end
      object PV721APin: TPanel
        Left = 424
        Top = 304
        Width = 317
        Height = 32
        Cursor = crHandPoint
        BevelOuter = bvLowered
        Caption = 'Gate Pin is 26'
        Color = clSilver
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHotLight
        Font.Height = -17
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 4
      end
    end
    object TS_B7_21: TTabSheet
      Caption = 'B7_21'
      ImageIndex = 2
      object PanelV721_I: TPanel
        Left = 0
        Top = 0
        Width = 781
        Height = 201
        Align = alTop
        ParentBackground = False
        TabOrder = 0
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
          Font.Height = -63
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
          Top = 156
          Width = 97
          Height = 33
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
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
          TabOrder = 1
        end
        object BV721IMeas: TButton
          Left = 430
          Top = 97
          Width = 97
          Height = 39
          Caption = 'measure'
          TabOrder = 2
        end
        object PV721IPin: TPanel
          Left = 560
          Top = 99
          Width = 206
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 3
        end
        object PV721IPinG: TPanel
          Left = 560
          Top = 156
          Width = 206
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 4
        end
      end
      object PanelV721_II: TPanel
        Left = 0
        Top = 210
        Width = 781
        Height = 201
        Align = alBottom
        TabOrder = 1
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
          Font.Height = -63
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
          TabOrder = 1
        end
        object BV721IIMeas: TButton
          Left = 250
          Top = 96
          Width = 97
          Height = 39
          Caption = 'measure'
          TabOrder = 2
        end
        object PV721IIPin: TPanel
          Left = 13
          Top = 101
          Width = 212
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 3
        end
        object PV721IIPinG: TPanel
          Left = 13
          Top = 154
          Width = 212
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 4
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
      TabVisible = False
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
      Caption = 'DACR-2R/D30_06'
      ImageIndex = 5
      object GBCalibrR2R: TGroupBox
        Left = 229
        Top = 55
        Width = 222
        Height = 258
        Caption = 'Calibration'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object GBCalibrR2RPV: TGroupBox
          Left = 12
          Top = 18
          Width = 197
          Height = 81
          Caption = 'Positive Voltage'
          TabOrder = 0
          object LFBHighlimitValueR2R: TLabel
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
          object LFBLowlimitValueR2R: TLabel
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
          object STFBhighlimitR2R: TStaticText
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
            TabOrder = 0
          end
          object STFBlowlimitR2R: TStaticText
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
            TabOrder = 1
          end
          object UDFBHighLimitR2R: TUpDown
            Tag = 2
            Left = 164
            Top = 21
            Width = 16
            Height = 23
            Max = 80
            Position = 40
            TabOrder = 2
          end
          object UDFBLowLimitR2R: TUpDown
            Tag = 2
            Left = 164
            Top = 48
            Width = 16
            Height = 24
            Max = 80
            Position = 40
            TabOrder = 3
          end
        end
        object GBCalibrR2RNV: TGroupBox
          Left = 12
          Top = 109
          Width = 197
          Height = 80
          Caption = 'Negative Voltage'
          TabOrder = 1
          object LRBHighlimitValueR2R: TLabel
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
          object LRBLowlimitValueR2R: TLabel
            Left = 116
            Top = 47
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
          object STRBhighlimitR2R: TStaticText
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
            TabOrder = 0
          end
          object STRBlowlimitR2R: TStaticText
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
            TabOrder = 1
          end
          object UDRBHighLimitR2R: TUpDown
            Tag = 2
            Left = 168
            Top = 18
            Width = 16
            Height = 23
            Max = 80
            Position = 40
            TabOrder = 2
          end
          object UDRBLowLimitR2R: TUpDown
            Tag = 2
            Left = 168
            Top = 48
            Width = 16
            Height = 24
            Max = 80
            Position = 40
            TabOrder = 3
          end
        end
        object BDFFA_R2R: TButton
          Left = 23
          Top = 210
          Width = 162
          Height = 31
          Caption = 'data from file add'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = BDFFA_R2RClick
        end
      end
      object GBR2R: TGroupBox
        Left = 3
        Top = 3
        Width = 220
        Height = 310
        Caption = 'DAC R-2R'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -21
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object LCodeRangeDACR2R: TLabel
          Left = 5
          Top = 137
          Width = 112
          Height = 16
          Caption = '-65535...65535'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LOKDACR2R: TLabel
          Left = 22
          Top = 157
          Width = 83
          Height = 16
          Caption = 'Output Code:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LOVDACR2R: TLabel
          Left = 10
          Top = 58
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
        object LValueRangeDACR2R: TLabel
          Left = 15
          Top = 77
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
        object PDACR2RPinC: TPanel
          Left = 5
          Top = 20
          Width = 204
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object BDACR2RReset: TButton
          Left = 5
          Top = 102
          Width = 105
          Height = 28
          Caption = 'Reset'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object BOKsetDACR2R: TButton
          Left = 125
          Top = 125
          Width = 82
          Height = 23
          Caption = 'set code'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object BOVsetDACR2R: TButton
          Left = 125
          Top = 87
          Width = 82
          Height = 23
          Caption = 'set value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object STOKDACR2R: TStaticText
          Left = 138
          Top = 155
          Width = 72
          Height = 24
          Caption = '-65000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STOVDACR2R: TStaticText
          Left = 125
          Top = 55
          Width = 78
          Height = 24
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object GBMeasR2R: TGroupBox
          Tag = 110
          Left = 5
          Top = 190
          Width = 210
          Height = 106
          Caption = 'Measurement'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          object LMeasR2R: TLabel
            Left = 129
            Top = 19
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
          object BMeasR2R: TButton
            Left = 9
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
          object STMDR2R: TStaticText
            Left = 24
            Top = 49
            Width = 105
            Height = 20
            Caption = 'Measure Device'
            TabOrder = 1
          end
          object CBMeasDACR2R: TComboBox
            Tag = 5
            Left = 25
            Top = 71
            Width = 133
            Height = 24
            Style = csDropDownList
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ItemHeight = 16
            ParentFont = False
            TabOrder = 2
          end
        end
      end
      object GBD3006: TGroupBox
        Left = 474
        Top = 0
        Width = 292
        Height = 377
        Caption = 'D30_06'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -21
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object LCodeRangeD30: TLabel
          Left = 51
          Top = 230
          Width = 166
          Height = 16
          Caption = 'Code: -16383 ... 16383'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LValueRangeD30: TLabel
          Left = 62
          Top = 109
          Width = 126
          Height = 16
          Caption = 'Value: -6.5 ... 6.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LOVD30: TLabel
          Left = 15
          Top = 133
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
        object LOKD30: TLabel
          Left = 15
          Top = 203
          Width = 83
          Height = 16
          Caption = 'Output Code:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object GBMeasD30: TGroupBox
          Tag = 110
          Left = 53
          Top = 277
          Width = 193
          Height = 84
          Caption = 'Measurement'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object LMeasD30: TLabel
            Left = 114
            Top = 26
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
          object BMeasD30: TButton
            Left = 3
            Top = 23
            Width = 105
            Height = 23
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object STMDD30: TStaticText
            Left = 11
            Top = 58
            Width = 47
            Height = 20
            Caption = 'Device'
            TabOrder = 1
          end
          object CBMeasD30: TComboBox
            Tag = 5
            Left = 64
            Top = 52
            Width = 122
            Height = 24
            Style = csDropDownList
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ItemHeight = 16
            ParentFont = False
            TabOrder = 2
          end
        end
        object BD30Reset: TButton
          Left = 24
          Top = 160
          Width = 249
          Height = 32
          Caption = 'Reset'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object BOKsetD30: TButton
          Left = 200
          Top = 200
          Width = 81
          Height = 23
          Caption = 'set code'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object BOVsetD30: TButton
          Left = 200
          Top = 130
          Width = 83
          Height = 23
          Caption = 'set value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object PD30PinC: TPanel
          Left = 12
          Top = 28
          Width = 159
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 4
        end
        object PD30PinG: TPanel
          Left = 12
          Top = 67
          Width = 159
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 5
        end
        object RGD30: TRadioGroup
          Left = 177
          Top = 9
          Width = 108
          Height = 94
          Caption = 'Mode'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = []
          ItemIndex = 0
          Items.Strings = (
            'Voltage'
            'Current')
          ParentFont = False
          TabOrder = 6
        end
        object STOVD30: TStaticText
          Left = 111
          Top = 130
          Width = 78
          Height = 24
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object STOKD30: TStaticText
          Left = 114
          Top = 200
          Width = 72
          Height = 24
          Caption = '-65000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
      end
    end
    object TS_Setting: TTabSheet
      Caption = 'Setting'
      ImageIndex = 4
      object LPR: TLabel
        Left = 17
        Top = 340
        Width = 23
        Height = 13
        Caption = 'LPR'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LMC: TLabel
        Left = 164
        Top = 260
        Width = 31
        Height = 13
        Caption = 'L1PR'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LMinC: TLabel
        Left = 164
        Top = 309
        Width = 31
        Height = 13
        Caption = 'L1PR'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LFVP: TLabel
        Left = 330
        Top = 260
        Width = 31
        Height = 13
        Caption = 'L1PR'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LRVP: TLabel
        Left = 330
        Top = 309
        Width = 31
        Height = 13
        Caption = 'L1PR'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
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
          Top = 20
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
      object BSaveSetting: TButton
        Left = 330
        Top = 380
        Width = 111
        Height = 25
        Caption = 'Save Setting'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = BSaveSettingClick
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
        TabOrder = 3
      end
      object GBCOM: TGroupBox
        Left = 649
        Top = 260
        Width = 123
        Height = 163
        Caption = 'COM parameters'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object ComCBPort: TComComboBox
          Left = 11
          Top = 40
          Width = 74
          Height = 26
          ComPort = ComPort1
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
        object ComCBBR: TComComboBox
          Left = 12
          Top = 107
          Width = 93
          Height = 26
          ComPort = ComPort1
          ComProperty = cpBaudRate
          AutoApply = True
          Text = '115200'
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 18
          ItemIndex = 13
          ParentFont = False
          TabOrder = 1
        end
        object STCOMP: TStaticText
          Left = 30
          Top = 12
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
        object STComBR: TStaticText
          Left = 16
          Top = 80
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
      object GBDS: TGroupBox
        Left = 421
        Top = 12
        Width = 332
        Height = 240
        Caption = 'Device Selection'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        object LRVtoI: TLabel
          Left = 10
          Top = 87
          Width = 31
          Height = 13
          Caption = 'L1PR'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LVVtoI: TLabel
          Left = 10
          Top = 167
          Width = 31
          Height = 13
          Caption = 'L1PR'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LDBtime: TLabel
          Left = 160
          Top = 167
          Width = 31
          Height = 13
          Caption = 'L1PR'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CBVS: TComboBox
          Tag = 5
          Left = 9
          Top = 41
          Width = 132
          Height = 24
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 0
        end
        object STVMD: TStaticText
          Left = 175
          Top = 18
          Width = 158
          Height = 20
          Caption = 'Voltage Measure Device'
          TabOrder = 1
        end
        object STVS: TStaticText
          Left = 10
          Top = 18
          Width = 102
          Height = 20
          Caption = 'Voltage Source'
          TabOrder = 2
        end
        object STCMD: TStaticText
          Left = 181
          Top = 83
          Width = 156
          Height = 20
          Caption = 'Current Measure Device'
          TabOrder = 3
        end
        object CBVMD: TComboBox
          Tag = 5
          Left = 180
          Top = 41
          Width = 132
          Height = 24
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 4
        end
        object CBCMD: TComboBox
          Tag = 5
          Left = 180
          Top = 106
          Width = 132
          Height = 24
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 5
        end
        object CBVtoI: TCheckBox
          Tag = 6
          Left = 8
          Top = 129
          Width = 140
          Height = 29
          Caption = 'Resistance used'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
          WordWrap = True
        end
        object STRVtoI: TStaticText
          Left = 10
          Top = 106
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object STVVtoI: TStaticText
          Left = 10
          Top = 185
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
        object STDBtime: TStaticText
          Left = 202
          Top = 185
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
        end
      end
      object CBCurrentValue: TCheckBox
        Tag = 6
        Left = 164
        Top = 355
        Width = 140
        Height = 29
        Caption = 'Current controlled'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        WordWrap = True
      end
      object STPR: TStaticText
        Left = 17
        Top = 358
        Width = 97
        Height = 24
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
      end
      object STMC: TStaticText
        Left = 164
        Top = 278
        Width = 97
        Height = 24
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
      end
      object STMinC: TStaticText
        Left = 164
        Top = 327
        Width = 97
        Height = 24
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
      end
      object STFVP: TStaticText
        Left = 330
        Top = 278
        Width = 97
        Height = 24
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
      end
      object STRVP: TStaticText
        Left = 330
        Top = 327
        Width = 97
        Height = 24
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 11
      end
    end
    object TS_Temper: TTabSheet
      Caption = 'Temperature'
      ImageIndex = 6
      object LTMI: TLabel
        Left = 14
        Top = 119
        Width = 31
        Height = 13
        Caption = 'L1PR'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object GBDS18B: TGroupBox
        Left = 186
        Top = 111
        Width = 185
        Height = 58
        Caption = 'DS18B20,  OneWire'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clOlive
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object PDS18BPin: TPanel
          Left = 11
          Top = 19
          Width = 158
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
      end
      object CBTD: TComboBox
        Tag = 5
        Left = 14
        Top = 64
        Width = 132
        Height = 24
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 16
        ParentFont = False
        TabOrder = 1
      end
      object STTD: TStaticText
        Left = 14
        Top = 38
        Width = 133
        Height = 20
        Caption = 'Temperature Device'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object STTMI: TStaticText
        Left = 14
        Top = 161
        Width = 97
        Height = 24
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object GBThermocouple: TGroupBox
        Left = 186
        Top = 3
        Width = 185
        Height = 92
        Caption = 'ThermoCouple'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clOlive
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object STTCV: TStaticText
          Left = 27
          Top = 19
          Width = 139
          Height = 20
          Caption = 'Termocouple voltage'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object CBTcVMD: TComboBox
          Tag = 5
          Left = 26
          Top = 56
          Width = 132
          Height = 24
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 1
        end
        object STMD: TStaticText
          Left = 40
          Top = 34
          Width = 117
          Height = 20
          Caption = 'measuring device'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
      end
      object GBTermostat: TGroupBox
        Left = 20
        Top = 210
        Width = 450
        Height = 167
        Caption = 'Thermostat Setup'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        object LTermostatNT: TLabel
          Left = 145
          Top = 32
          Width = 49
          Height = 13
          Caption = 'Needed'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object LTermostatCT: TLabel
          Left = 11
          Top = 16
          Width = 85
          Height = 26
          Caption = 'Current Temperature'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object SBTermostat: TSpeedButton
          Left = 148
          Top = 89
          Width = 131
          Height = 26
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'Start Control'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = SBTermostatClick
        end
        object LTermostatCTValue: TLabel
          Left = 11
          Top = 52
          Width = 93
          Height = 20
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatTolerance: TLabel
          Left = 253
          Top = 35
          Width = 65
          Height = 13
          Caption = 'Tolerance'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatKp: TLabel
          Left = 11
          Top = 88
          Width = 22
          Height = 18
          Caption = 'Kp'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatKi: TLabel
          Left = 11
          Top = 115
          Width = 16
          Height = 18
          Caption = 'Ki'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatKd: TLabel
          Left = 11
          Top = 143
          Width = 22
          Height = 18
          Caption = 'Kd'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatOutputValue: TLabel
          Left = 311
          Top = 132
          Width = 93
          Height = 20
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clPurple
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatWatchDog: TLabel
          Left = 2
          Top = 48
          Width = 10
          Height = 13
          Caption = 'o'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clLime
          Font.Height = -13
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object CBTermostatCD: TComboBox
          Tag = 5
          Left = 297
          Top = 95
          Width = 133
          Height = 24
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 0
        end
        object STTermostatCD: TStaticText
          Left = 315
          Top = 75
          Width = 96
          Height = 20
          Caption = 'Driving Device'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object STTermostatNT: TStaticText
          Left = 145
          Top = 52
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object STTermostatKi: TStaticText
          Left = 47
          Top = 113
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object STTermostatKp: TStaticText
          Left = 47
          Top = 86
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STTermostatKd: TStaticText
          Left = 47
          Top = 141
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object BTermostatReset: TButton
          Left = 166
          Top = 132
          Width = 75
          Height = 25
          Caption = 'Reset'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          OnClick = BTermostatResetClick
        end
        object STTermostatTolerance: TStaticText
          Left = 253
          Top = 54
          Width = 87
          Height = 22
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
      end
      object GBTMP102: TGroupBox
        Left = 390
        Top = 5
        Width = 168
        Height = 58
        Caption = 'TMP102   I2C, 3.3V'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clOlive
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        object PTMP102Pin: TPanel
          Left = 5
          Top = 19
          Width = 158
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBHTU21: TGroupBox
        Left = 390
        Top = 69
        Width = 168
        Height = 57
        Caption = 'HTU21D,  I2C, 3.3V'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clOlive
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        object PHTU21: TPanel
          Left = 5
          Top = 19
          Width = 158
          Height = 32
          BevelOuter = bvLowered
          Caption = 'Adress is $40'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBMLX615: TGroupBox
        Left = 598
        Top = 5
        Width = 168
        Height = 135
        Caption = 'MLX90615,  I2C, 3.3V'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clOlive
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        object PMLX615: TPanel
          Left = 5
          Top = 19
          Width = 158
          Height = 32
          BevelOuter = bvLowered
          Caption = 'Adress is $5B'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object GBMLX615_GC: TGroupBox
          Left = 2
          Top = 52
          Width = 164
          Height = 57
          Caption = 'Gray Coefficient'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object STMLX615_GC: TStaticText
            Left = 45
            Top = 15
            Width = 75
            Height = 22
            Caption = '1.00000'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clMaroon
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            ShowAccelChar = False
            TabOrder = 0
          end
          object BMLX615_GCread: TButton
            Left = 8
            Top = 34
            Width = 58
            Height = 19
            Caption = 'Read'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object BMLX615_GCwrite: TButton
            Left = 98
            Top = 34
            Width = 57
            Height = 19
            Caption = 'Write'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
        end
        object BMLX615_Calib: TButton
          Left = 12
          Top = 112
          Width = 142
          Height = 19
          Caption = 'Calibrate'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
      end
    end
    object TS_UT70: TTabSheet
      Caption = 'UT70'
      ImageIndex = 7
      object PanelUT70B: TPanel
        Left = 0
        Top = 0
        Width = 781
        Height = 201
        Align = alTop
        TabOrder = 0
        object LUT70B: TLabel
          Left = 212
          Top = 0
          Width = 428
          Height = 80
          AutoSize = False
          Caption = '    ERROR'
          Color = clWhite
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -63
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LUT70BU: TLabel
          Left = 646
          Top = 0
          Width = 129
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
        object SBUT70BAuto: TSpeedButton
          Left = 560
          Top = 167
          Width = 80
          Height = 25
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
        end
        object LUT70BPort: TLabel
          Left = 650
          Top = 177
          Width = 46
          Height = 13
          Caption = 'Port '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RGUT70B_MM: TRadioGroup
          Left = 0
          Top = 0
          Width = 213
          Height = 196
          Caption = 'UT 70B'
          Color = clCream
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          Items.Strings = (
            '1')
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 0
        end
        object RGUT70B_Range: TRadioGroup
          Left = 212
          Top = 80
          Width = 342
          Height = 115
          Caption = 'Range'
          Color = clSkyBlue
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Items.Strings = (
            '1')
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
        object BUT70BMeas: TButton
          Left = 560
          Top = 127
          Width = 107
          Height = 27
          Caption = 'measure'
          TabOrder = 2
        end
        object RGUT70B_RangeM: TRadioGroup
          Left = 560
          Top = 80
          Width = 215
          Height = 41
          Color = clInfoBk
          Columns = 2
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Items.Strings = (
            '1')
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 3
        end
        object STUT70BRort: TStaticText
          Left = 707
          Top = 122
          Width = 39
          Height = 22
          Caption = 'Port'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object ComCBUT70BPort: TComComboBox
          Left = 691
          Top = 145
          Width = 74
          Height = 26
          ComPort = ComPortUT70B
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
          TabOrder = 5
        end
      end
      object PanelUT70C: TPanel
        Left = 0
        Top = 201
        Width = 781
        Height = 201
        Align = alTop
        TabOrder = 1
        object LUT70C: TLabel
          Left = 212
          Top = 0
          Width = 428
          Height = 65
          AutoSize = False
          Caption = '    ERROR'
          Color = clWhite
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -59
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LUT70CU: TLabel
          Left = 646
          Top = 0
          Width = 129
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
        object SBUT70CAuto: TSpeedButton
          Left = 560
          Top = 167
          Width = 80
          Height = 25
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
        end
        object LUT70CPort: TLabel
          Left = 650
          Top = 177
          Width = 46
          Height = 13
          Caption = 'Port '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LUT70C_rec: TLabel
          Left = 307
          Top = 71
          Width = 39
          Height = 23
          Caption = 'REC'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LUT70C_Hold: TLabel
          Left = 475
          Top = 71
          Width = 52
          Height = 23
          Caption = 'HOLD'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LUT70C_AVG: TLabel
          Left = 387
          Top = 71
          Width = 39
          Height = 23
          Caption = 'AVG'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LUT70C_AvTime: TLabel
          Left = 225
          Top = 72
          Width = 55
          Height = 19
          Caption = '100 ms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RGUT70C_MM: TRadioGroup
          Left = 0
          Top = 0
          Width = 213
          Height = 196
          Caption = 'UT 70C'
          Color = clCream
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          Items.Strings = (
            '1')
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 0
        end
        object RGUT70C_Range: TRadioGroup
          Left = 212
          Top = 96
          Width = 342
          Height = 99
          Caption = 'Range'
          Color = clSkyBlue
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Items.Strings = (
            '1')
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
        object BUT70CMeas: TButton
          Left = 560
          Top = 127
          Width = 107
          Height = 27
          Caption = 'measure'
          TabOrder = 2
        end
        object RGUT70C_RangeM: TRadioGroup
          Left = 560
          Top = 80
          Width = 215
          Height = 41
          Color = clInfoBk
          Columns = 2
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Items.Strings = (
            '1')
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 3
        end
        object STUT70CRort: TStaticText
          Left = 707
          Top = 122
          Width = 39
          Height = 22
          Caption = 'Port'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object ComCBUT70CPort: TComComboBox
          Left = 691
          Top = 145
          Width = 74
          Height = 26
          ComPort = ComPortUT70C
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
          TabOrder = 5
        end
      end
    end
    object TS_ET1255: TTabSheet
      Caption = 'ET1255_DAC'
      ImageIndex = 8
      object PET1255DAC: TPanel
        Left = 3
        Top = 3
        Width = 775
        Height = 400
        BevelWidth = 3
        BorderStyle = bsSingle
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object LValueRangeDAC1255: TLabel
          Left = 170
          Top = 5
          Width = 142
          Height = 18
          Caption = 'Value: -2.5 ... 2.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LCodeRangeDAC1255: TLabel
          Left = 170
          Top = 26
          Width = 201
          Height = 18
          Caption = 'Code: 0 ... 2048 ... 4096'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object SBGenerator: TSpeedButton
          Left = 572
          Top = 275
          Width = 111
          Height = 33
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
          OnClick = SBGeneratorClick
        end
        object STDAC: TStaticText
          Left = 32
          Top = 0
          Width = 52
          Height = 29
          Caption = 'DAC'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object GBET1255DACh0: TGroupBox
          Tag = 110
          Left = 13
          Top = 45
          Width = 425
          Height = 113
          Caption = 'Channel 0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object LOV1255ch0: TLabel
            Left = 95
            Top = 28
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
          object LOK1255Ch0: TLabel
            Left = 95
            Top = 87
            Width = 83
            Height = 16
            Caption = 'Output Code:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BOVset1255Ch0: TButton
            Left = 8
            Top = 25
            Width = 82
            Height = 23
            Caption = 'set value'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object BReset1255Ch0: TButton
            Left = 8
            Top = 55
            Width = 123
            Height = 23
            Caption = 'Reset'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object BOKset1255Ch0: TButton
            Left = 8
            Top = 84
            Width = 81
            Height = 23
            Caption = 'set code'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object GBMeas1255Ch0: TGroupBox
            Tag = 110
            Left = 269
            Top = 9
            Width = 147
            Height = 98
            Caption = 'Measurement'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            object LMeas1255Ch0: TLabel
              Left = 37
              Top = 15
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
            object BMeas1255Ch0: TButton
              Left = 21
              Top = 32
              Width = 105
              Height = 17
              Caption = 'to measure'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object STMD1255Ch0: TStaticText
              Left = 24
              Top = 51
              Width = 105
              Height = 20
              Caption = 'Measure Device'
              TabOrder = 1
            end
            object CBMeasET1255Ch0: TComboBox
              Tag = 5
              Left = 8
              Top = 67
              Width = 132
              Height = 24
              Style = csDropDownList
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ItemHeight = 16
              ParentFont = False
              TabOrder = 2
            end
          end
          object STOV1255ch0: TStaticText
            Left = 188
            Top = 26
            Width = 78
            Height = 24
            Caption = '-0.0008'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object STOK1255Ch0: TStaticText
            Left = 191
            Top = 85
            Width = 72
            Height = 24
            Caption = '-65000'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
          end
        end
        object GBET1255DACh1: TGroupBox
          Tag = 110
          Left = 13
          Top = 160
          Width = 425
          Height = 113
          Caption = 'Channel 1'
          Color = clSilver
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 2
          object LOV1255ch1: TLabel
            Left = 95
            Top = 28
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
          object LOK1255Ch1: TLabel
            Left = 95
            Top = 87
            Width = 83
            Height = 16
            Caption = 'Output Code:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BOVset1255Ch1: TButton
            Left = 8
            Top = 25
            Width = 82
            Height = 23
            Caption = 'set value'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object BReset1255Ch1: TButton
            Left = 8
            Top = 55
            Width = 123
            Height = 23
            Caption = 'Reset'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object BOKset1255Ch1: TButton
            Left = 8
            Top = 84
            Width = 81
            Height = 23
            Caption = 'set code'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object GBMeas1255Ch1: TGroupBox
            Tag = 110
            Left = 269
            Top = 11
            Width = 147
            Height = 98
            Caption = 'Measurement'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            object LMeas1255Ch1: TLabel
              Left = 36
              Top = 15
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
            object BMeas1255Ch1: TButton
              Left = 21
              Top = 32
              Width = 105
              Height = 17
              Caption = 'to measure'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object STMD1255Ch1: TStaticText
              Left = 24
              Top = 51
              Width = 105
              Height = 20
              Caption = 'Measure Device'
              TabOrder = 1
            end
            object CBMeasET1255Ch1: TComboBox
              Tag = 5
              Left = 8
              Top = 67
              Width = 132
              Height = 24
              Style = csDropDownList
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ItemHeight = 16
              ParentFont = False
              TabOrder = 2
            end
          end
          object STOV1255ch1: TStaticText
            Left = 188
            Top = 26
            Width = 78
            Height = 24
            Caption = '-0.0008'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object STOK1255Ch1: TStaticText
            Left = 191
            Top = 85
            Width = 72
            Height = 24
            Caption = '-65000'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
          end
        end
        object GBET1255DACh2: TGroupBox
          Tag = 110
          Left = 13
          Top = 275
          Width = 425
          Height = 113
          Caption = 'Channel 2'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          object LOV1255ch2: TLabel
            Left = 95
            Top = 28
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
          object LOK1255Ch2: TLabel
            Left = 95
            Top = 87
            Width = 83
            Height = 16
            Caption = 'Output Code:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BOVset1255Ch2: TButton
            Left = 8
            Top = 25
            Width = 82
            Height = 23
            Caption = 'set value'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object BReset1255Ch2: TButton
            Left = 8
            Top = 55
            Width = 123
            Height = 23
            Caption = 'Reset'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object BOKset1255Ch2: TButton
            Left = 8
            Top = 84
            Width = 81
            Height = 23
            Caption = 'set code'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object GBMeas1255Ch2: TGroupBox
            Tag = 110
            Left = 269
            Top = 9
            Width = 147
            Height = 98
            Caption = 'Measurement'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            object LMeas1255Ch2: TLabel
              Left = 36
              Top = 15
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
            object BMeas1255Ch2: TButton
              Left = 21
              Top = 32
              Width = 105
              Height = 17
              Caption = 'to measure'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object STMD1255Ch2: TStaticText
              Left = 24
              Top = 51
              Width = 105
              Height = 20
              Caption = 'Measure Device'
              TabOrder = 1
            end
            object CBMeasET1255Ch2: TComboBox
              Tag = 5
              Left = 8
              Top = 67
              Width = 132
              Height = 24
              Style = csDropDownList
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ItemHeight = 16
              ParentFont = False
              TabOrder = 2
            end
          end
          object STOV1255ch2: TStaticText
            Left = 188
            Top = 26
            Width = 78
            Height = 24
            Caption = '-0.0008'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object STOK1255Ch2: TStaticText
            Left = 191
            Top = 85
            Width = 72
            Height = 24
            Caption = '-65000'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
          end
        end
        object GBET1255DACh3: TGroupBox
          Tag = 110
          Left = 477
          Top = 45
          Width = 268
          Height = 116
          Caption = 'Channel 3'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          object LOV1255ch3: TLabel
            Left = 95
            Top = 28
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
          object LOK1255Ch3: TLabel
            Left = 95
            Top = 87
            Width = 83
            Height = 16
            Caption = 'Output Code:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BOVset1255Ch3: TButton
            Left = 8
            Top = 25
            Width = 82
            Height = 23
            Caption = 'set value'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object BReset1255Ch3: TButton
            Left = 8
            Top = 55
            Width = 123
            Height = 23
            Caption = 'Reset'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object BOKset1255Ch3: TButton
            Left = 8
            Top = 84
            Width = 81
            Height = 23
            Caption = 'set code'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object STOV1255ch3: TStaticText
            Left = 186
            Top = 26
            Width = 78
            Height = 24
            Caption = '-0.0008'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
          object STOK1255Ch3: TStaticText
            Left = 191
            Top = 85
            Width = 72
            Height = 24
            Caption = '-65000'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
        end
      end
    end
    object TS_ET1255ADC: TTabSheet
      Caption = 'TS_ET1255_ADC'
      ImageIndex = 11
      object LET1255I: TLabel
        Left = 4
        Top = 289
        Width = 286
        Height = 52
        AutoSize = False
        Caption = '  ERROR'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -41
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object LET1255U: TLabel
        Left = 292
        Top = 289
        Width = 75
        Height = 52
        AutoSize = False
        Caption = 'a'
        Color = clInfoText
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -55
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object SBET1255Auto: TSpeedButton
        Left = 220
        Top = 357
        Width = 111
        Height = 33
        AllowAllUp = True
        GroupIndex = 2
        Caption = 'AUTO'
      end
      object ChET1255: TChart
        Left = 0
        Top = 0
        Width = 551
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
          'Voltage on time')
        View3D = False
        View3DOptions.Orthogonal = False
        Align = alCustom
        TabOrder = 0
        PrintMargins = (
          15
          30
          15
          30)
        object PointET1255: TPointSeries
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
      end
      object RGET1255_MM: TRadioGroup
        Left = 570
        Top = 158
        Width = 205
        Height = 100
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
        TabOrder = 1
      end
      object RGET1255Range: TRadioGroup
        Left = 570
        Top = 3
        Width = 205
        Height = 149
        Caption = 'Range'
        Color = clSkyBlue
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Items.Strings = (
          '1')
        ParentBackground = False
        ParentColor = False
        ParentFont = False
        TabOrder = 2
      end
      object BET1255Meas: TButton
        Left = 3
        Top = 357
        Width = 158
        Height = 33
        Caption = 'measurement'
        TabOrder = 3
      end
      object CBET1255_SM: TCheckBox
        Left = 396
        Top = 264
        Width = 173
        Height = 56
        Caption = 'Serial Measurement'
        TabOrder = 4
        WordWrap = True
      end
      object SEET1255_MN: TSpinEdit
        Left = 396
        Top = 360
        Width = 61
        Height = 30
        MaxValue = 0
        MinValue = 0
        TabOrder = 5
        Value = 0
      end
      object STET1255_4096: TStaticText
        Left = 463
        Top = 366
        Width = 82
        Height = 24
        Caption = 'x 4096'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -25
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
      end
      object STET1255_MN: TStaticText
        Left = 396
        Top = 337
        Width = 176
        Height = 23
        Caption = 'Measurement Number'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
      end
      object SEET1255_Gain: TSpinEdit
        Left = 688
        Top = 311
        Width = 57
        Height = 30
        MaxValue = 0
        MinValue = 0
        TabOrder = 8
        Value = 0
      end
      object STET122_Gain: TStaticText
        Left = 634
        Top = 318
        Width = 40
        Height = 23
        Caption = 'Gain'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
      end
      object BET1255_show_save: TButton
        Left = 4
        Top = 262
        Width = 89
        Height = 22
        Caption = 'save'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
        OnClick = BET1255_show_saveClick
      end
    end
    object TS_Time_Dependence: TTabSheet
      Caption = 'Time'
      ImageIndex = 9
      object LTimeInterval: TLabel
        Left = 10
        Top = 65
        Width = 76
        Height = 13
        Caption = 'Interval (s)'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LTimeDuration: TLabel
        Left = 10
        Top = 110
        Width = 79
        Height = 13
        Caption = 'Duration (s)'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object STTimeMD: TStaticText
        Left = 15
        Top = 10
        Width = 117
        Height = 20
        Caption = 'Measurind Device'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object CBTimeMD: TComboBox
        Tag = 5
        Left = 15
        Top = 30
        Width = 132
        Height = 24
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 16
        ParentFont = False
        TabOrder = 1
      end
      object STTimeInterval: TStaticText
        Left = 10
        Top = 80
        Width = 97
        Height = 24
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object STTimeDuration: TStaticText
        Left = 10
        Top = 130
        Width = 97
        Height = 24
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object GBCSetup: TGroupBox
        Left = 246
        Top = 10
        Width = 521
        Height = 215
        Caption = 'Controller Setup'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object LControlNV: TLabel
          Left = 164
          Top = 62
          Width = 89
          Height = 13
          Caption = 'Needed Value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlCV: TLabel
          Left = 166
          Top = 18
          Width = 89
          Height = 13
          Caption = 'Current Value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlInterval: TLabel
          Left = 418
          Top = 18
          Width = 53
          Height = 26
          Caption = 'Interval (s)'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object SBControlBegin: TSpeedButton
          Left = 207
          Top = 175
          Width = 170
          Height = 26
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'Start Controling'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = SBControlBeginClick
        end
        object LControlCVValue: TLabel
          Left = 164
          Top = 37
          Width = 12
          Height = 20
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlTolerance: TLabel
          Left = 297
          Top = 62
          Width = 65
          Height = 13
          Caption = 'Tolerance'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlKp: TLabel
          Left = 155
          Top = 119
          Width = 16
          Height = 13
          Caption = 'Kp'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlKi: TLabel
          Left = 270
          Top = 119
          Width = 12
          Height = 13
          Caption = 'Ki'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlKd: TLabel
          Left = 385
          Top = 119
          Width = 16
          Height = 13
          Caption = 'Kd'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlCCV: TLabel
          Left = 9
          Top = 161
          Width = 140
          Height = 13
          Caption = 'Current Control Value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlCCValue: TLabel
          Left = 12
          Top = 180
          Width = 12
          Height = 20
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlWatchDog: TLabel
          Left = 153
          Top = 37
          Width = 10
          Height = 13
          Caption = 'o'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clLime
          Font.Height = -13
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object CBControlCD: TComboBox
          Tag = 5
          Left = 8
          Top = 114
          Width = 132
          Height = 24
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 0
        end
        object STControl_CD: TStaticText
          Left = 8
          Top = 88
          Width = 96
          Height = 20
          Caption = 'Driving Device'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object CBControlMD: TComboBox
          Tag = 5
          Left = 8
          Top = 44
          Width = 132
          Height = 24
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 2
        end
        object STControl_MD: TStaticText
          Left = 8
          Top = 18
          Width = 117
          Height = 20
          Caption = 'Measurind Device'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object STControlNV: TStaticText
          Left = 164
          Top = 81
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STControlKi: TStaticText
          Left = 270
          Top = 138
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object STControlKp: TStaticText
          Left = 155
          Top = 138
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object STControlInterval: TStaticText
          Left = 418
          Top = 52
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object STControlKd: TStaticText
          Left = 385
          Top = 138
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
        object BControlReset: TButton
          Left = 408
          Top = 176
          Width = 75
          Height = 25
          Caption = 'Reset'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
          OnClick = BControlResetClick
        end
        object STControlTolerance: TStaticText
          Left = 287
          Top = 80
          Width = 87
          Height = 22
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 10
        end
      end
      object STTimeMD2: TStaticText
        Left = 10
        Top = 160
        Width = 169
        Height = 20
        Caption = 'Second Measurind Device'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
      object CBTimeMD2: TComboBox
        Tag = 5
        Left = 10
        Top = 180
        Width = 111
        Height = 24
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 16
        ParentFont = False
        TabOrder = 6
      end
      object CBFvsS: TCheckBox
        Left = 150
        Top = 173
        Width = 90
        Height = 39
        Caption = 'First vs Second '
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        WordWrap = True
        OnClick = CBFvsSClick
      end
      object GBIscVoc: TGroupBox
        Left = 5
        Top = 231
        Width = 220
        Height = 172
        Caption = 'Isc Voc vs time'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        object LIscResult: TLabel
          Left = 108
          Top = 64
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
        object LVocResult: TLabel
          Left = 108
          Top = 141
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
        object CBVocMD: TComboBox
          Tag = 5
          Left = 64
          Top = 111
          Width = 133
          Height = 24
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 0
        end
        object CBIscMD: TComboBox
          Tag = 5
          Left = 64
          Top = 34
          Width = 133
          Height = 24
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 1
        end
        object STControlIsc: TStaticText
          Left = 107
          Top = 12
          Width = 47
          Height = 20
          Caption = 'Device'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object STIsc: TStaticText
          Left = 12
          Top = 34
          Width = 43
          Height = 24
          Caption = 'Isc'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object STVoc: TStaticText
          Left = 12
          Top = 111
          Width = 43
          Height = 24
          Caption = 'Voc'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object BIscMeasure: TButton
          Left = 13
          Top = 64
          Width = 89
          Height = 16
          Caption = 'to measure'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object BVocMeasure: TButton
          Left = 13
          Top = 141
          Width = 89
          Height = 17
          Caption = 'to measure'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
      end
      object GBLEDCon: TGroupBox
        Left = 246
        Top = 231
        Width = 282
        Height = 172
        Caption = 'LED control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
        object LLED_onValue: TLabel
          Left = 162
          Top = 78
          Width = 79
          Height = 13
          Caption = 'Duration (s)'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CBLEDAuto: TCheckBox
          Tag = 7
          Left = 16
          Top = 13
          Width = 89
          Height = 29
          Caption = 'LED auto on'
          TabOrder = 0
          WordWrap = True
        end
        object BIscVocPinChange: TButton
          Left = 16
          Top = 64
          Width = 85
          Height = 36
          Caption = 'Ups'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object STLED_on_CD: TStaticText
          Left = 135
          Top = 16
          Width = 96
          Height = 20
          Caption = 'Driving Device'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object CBLED_onCD: TComboBox
          Tag = 5
          Left = 135
          Top = 42
          Width = 132
          Height = 24
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 3
        end
        object STLED_onValue: TStaticText
          Left = 130
          Top = 98
          Width = 97
          Height = 24
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object PIscVocPin: TPanel
          Left = 19
          Top = 128
          Width = 246
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 5
        end
      end
      object GBLEDOpen: TGroupBox
        Left = 635
        Top = 231
        Width = 132
        Height = 105
        Caption = 'LED open'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
        object BLEDOpenPinChange: TButton
          Left = 25
          Top = 40
          Width = 85
          Height = 20
          Caption = 'Ups'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object CBLEDOpenAuto: TCheckBox
          Tag = 7
          Left = 32
          Top = 15
          Width = 89
          Height = 21
          Caption = 'auto'
          TabOrder = 1
          WordWrap = True
        end
        object PLEDOpenPin: TPanel
          Left = 5
          Top = 66
          Width = 124
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
      end
    end
    object TS_D30_06: TTabSheet
      Caption = 'AD9833'
      ImageIndex = 10
      object LFreqRangeAD9866: TLabel
        Left = 3
        Top = 50
        Width = 172
        Height = 18
        Caption = 'Freq: 0...12 500 000'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LPhaseRangeAD9866: TLabel
        Left = 3
        Top = 74
        Width = 120
        Height = 18
        Caption = 'Phase: 0...360'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SBAD9833Stop: TSpeedButton
        Left = 134
        Top = 222
        Width = 171
        Height = 33
        Caption = 'Stop'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SBAD9833GenCh1: TSpeedButton
        Left = 250
        Top = 183
        Width = 169
        Height = 33
        Caption = 'Generate'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SBAD9833GenCh0: TSpeedButton
        Left = 17
        Top = 183
        Width = 169
        Height = 33
        Caption = 'Generate'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GBAD9866ch0: TGroupBox
        Left = 3
        Top = 98
        Width = 204
        Height = 79
        Caption = 'channel I'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -21
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object L9833PhaseCh0: TLabel
          Left = 7
          Top = 54
          Width = 39
          Height = 16
          Caption = 'Phase'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object L9833FreqCh0: TLabel
          Left = 7
          Top = 26
          Width = 29
          Height = 16
          Caption = 'Freq'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ST9866PhaseCh0: TStaticText
          Left = 120
          Top = 51
          Width = 72
          Height = 24
          Caption = '-65000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object ST9866FreqCh0: TStaticText
          Left = 81
          Top = 23
          Width = 78
          Height = 24
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
      end
      object PAD9833PinC: TPanel
        Left = 3
        Top = 3
        Width = 204
        Height = 32
        Cursor = crHandPoint
        BevelOuter = bvLowered
        Caption = 'Control Pin is 26'
        Color = clSilver
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHotLight
        Font.Height = -17
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
      object GBAD9866ch1: TGroupBox
        Left = 227
        Top = 94
        Width = 204
        Height = 83
        Caption = 'channel II'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -21
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object L9833PhaseCh1: TLabel
          Left = 7
          Top = 54
          Width = 43
          Height = 16
          Caption = 'Phase:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object L9833FreqCh1: TLabel
          Left = 7
          Top = 26
          Width = 29
          Height = 16
          Caption = 'Freq'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ST9866PhaseCh1: TStaticText
          Left = 120
          Top = 51
          Width = 72
          Height = 24
          Caption = '-65000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object ST9866FreqCh1: TStaticText
          Left = 81
          Top = 23
          Width = 78
          Height = 24
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
      end
      object RGAD9833Mode: TRadioGroup
        Left = 17
        Top = 272
        Width = 402
        Height = 73
        Caption = 'Mode'
        Columns = 4
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
    end
    object TS_ADC: TTabSheet
      Caption = 'ADC'
      ImageIndex = 12
      object Button1: TButton
        Left = 525
        Top = 190
        Width = 75
        Height = 26
        Caption = 'Button1'
        TabOrder = 0
        OnClick = Button1Click
      end
      object GBMCP3424: TGroupBox
        Left = 2
        Top = 2
        Width = 335
        Height = 405
        Caption = 'MCP3424'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -21
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object GBMCP3424_Ch1: TGroupBox
          Left = 1
          Top = 96
          Width = 331
          Height = 75
          Caption = 'Channel 1'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object LMCP3424_Ch1meas: TLabel
            Left = 204
            Top = 21
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
          object BMCP3424_Ch1meas: TButton
            Left = 197
            Top = 48
            Width = 90
            Height = 17
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object PMCP3424_Ch1bits: TPanel
            Left = 3
            Top = 21
            Width = 158
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object PMCP3424_Ch1gain: TPanel
            Left = 3
            Top = 47
            Width = 158
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object GBMCP3424_Ch2: TGroupBox
          Left = 1
          Top = 172
          Width = 331
          Height = 75
          Caption = 'Channel 2'
          Color = clMedGray
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGradientActiveCaption
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 1
          object LMCP3424_Ch2meas: TLabel
            Left = 18
            Top = 21
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
          object BMCP3424_Ch2meas: TButton
            Left = 11
            Top = 48
            Width = 90
            Height = 17
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object PMCP3424_Ch2bits: TPanel
            Left = 162
            Top = 18
            Width = 158
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object PMCP3424_Ch2gain: TPanel
            Left = 162
            Top = 46
            Width = 158
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object GBMCP3424_Ch3: TGroupBox
          Left = 1
          Top = 250
          Width = 331
          Height = 75
          Caption = 'Channel 3'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          object LMCP3424_Ch3meas: TLabel
            Left = 204
            Top = 21
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
          object BMCP3424_Ch3meas: TButton
            Left = 197
            Top = 48
            Width = 90
            Height = 17
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object PMCP3424_Ch3bits: TPanel
            Left = 3
            Top = 21
            Width = 158
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object PMCP3424_Ch3gain: TPanel
            Left = 3
            Top = 47
            Width = 158
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object GBMCP3424_Ch4: TGroupBox
          Left = 1
          Top = 325
          Width = 331
          Height = 75
          Caption = 'Channel 4'
          Color = clMedGray
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGradientActiveCaption
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 3
          object LMCP3424_Ch4meas: TLabel
            Left = 18
            Top = 21
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
          object BMCP3424_Ch4meas: TButton
            Left = 11
            Top = 48
            Width = 90
            Height = 17
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object PMCP3424_Ch4bits: TPanel
            Left = 162
            Top = 18
            Width = 158
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object PMCP3424_Ch4gain: TPanel
            Left = 162
            Top = 46
            Width = 158
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object STMCP3424_1: TStaticText
          Left = 183
          Top = 20
          Width = 138
          Height = 22
          Caption = '-2.048 (dif)...2.048 V'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STMCP3424_2: TStaticText
          Left = 3
          Top = 20
          Width = 74
          Height = 18
          Caption = '12 bit - 1 mV '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object STMCP3424_5: TStaticText
          Left = 3
          Top = 71
          Width = 97
          Height = 18
          Caption = '18 bit - 15.625 uV '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object STMCP3424_3: TStaticText
          Left = 3
          Top = 37
          Width = 89
          Height = 18
          Caption = '14 bit - 0.25 mV '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object STMCP3424_4: TStaticText
          Left = 3
          Top = 54
          Width = 85
          Height = 18
          Caption = '16 bit - 62.5 uV '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
        object PMCP3424Pin: TPanel
          Left = 174
          Top = 58
          Width = 158
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 9
        end
      end
      object GBads1115: TGroupBox
        Left = 349
        Top = 2
        Width = 433
        Height = 167
        Caption = 'ADS1115'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -21
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object GBads1115_Ch1: TGroupBox
          Left = 216
          Top = 11
          Width = 215
          Height = 75
          Caption = 'Channel 1'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object Lads1115_Ch1meas: TLabel
            Left = 131
            Top = 21
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
          object Bads1115_Ch1meas: TButton
            Left = 122
            Top = 48
            Width = 90
            Height = 17
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object Pads1115_Ch1dr: TPanel
            Left = 3
            Top = 21
            Width = 115
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object Pads1115_Ch1gain: TPanel
            Left = 3
            Top = 47
            Width = 115
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object GBads1115_Ch2: TGroupBox
          Left = 1
          Top = 88
          Width = 214
          Height = 75
          Caption = 'Channel 2'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object Lads1115_Ch2meas: TLabel
            Left = 131
            Top = 21
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
          object Bads1115_Ch2meas: TButton
            Left = 122
            Top = 48
            Width = 91
            Height = 17
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object Pads1115_Ch2dr: TPanel
            Left = 3
            Top = 18
            Width = 115
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object Pads1115_Ch2gain: TPanel
            Left = 3
            Top = 46
            Width = 115
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object GBads1115_Ch3: TGroupBox
          Left = 216
          Top = 88
          Width = 215
          Height = 75
          Caption = 'Channel 3'
          Color = clMedGray
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGradientActiveCaption
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 2
          object Lads1115_Ch3meas: TLabel
            Left = 131
            Top = 21
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
          object Bads1115_Ch3meas: TButton
            Left = 122
            Top = 48
            Width = 90
            Height = 17
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object Pads1115_Ch3dr: TPanel
            Left = 3
            Top = 21
            Width = 115
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object Pads1115_Ch3gain: TPanel
            Left = 3
            Top = 47
            Width = 115
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object Pads1115_adr: TPanel
          Left = 14
          Top = 23
          Width = 158
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 3
        end
      end
      object GBina226: TGroupBox
        Left = 348
        Top = 239
        Width = 433
        Height = 150
        Caption = 'INA226'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -21
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object Lina226_Rsh: TLabel
          Left = 15
          Top = 75
          Width = 59
          Height = 18
          Caption = 'R shunt:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object GBina226_shunt: TGroupBox
          Left = 160
          Top = 11
          Width = 270
          Height = 67
          Caption = 'Shunt current'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object Lina226_shuntmeas: TLabel
            Left = 125
            Top = 45
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
          object Bina226_shuntmeas: TButton
            Left = 4
            Top = 45
            Width = 101
            Height = 17
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object Pina226_shunttime: TPanel
            Left = 3
            Top = 18
            Width = 264
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Conv. time is 1100 us'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object STina226_1: TStaticText
            Left = 223
            Top = 45
            Width = 37
            Height = 18
            Caption = '2.5 uV'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clGreen
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
        end
        object Pina226_adr: TPanel
          Left = 5
          Top = 25
          Width = 136
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 1
        end
        object Pina226_aver: TPanel
          Left = 5
          Top = 110
          Width = 143
          Height = 32
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object STina226_Rsh: TStaticText
          Left = 85
          Top = 73
          Width = 43
          Height = 26
          Caption = '256'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -18
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 3
        end
        object GBina226_Bus: TGroupBox
          Left = 160
          Top = 79
          Width = 270
          Height = 67
          Caption = 'Bus Voltage'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          object Lina226_busmeas: TLabel
            Left = 125
            Top = 45
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
          object Bina226_busmeas: TButton
            Left = 4
            Top = 45
            Width = 101
            Height = 17
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object Pina226_bustime: TPanel
            Left = 3
            Top = 18
            Width = 264
            Height = 23
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object STina226_2: TStaticText
            Left = 220
            Top = 46
            Width = 47
            Height = 18
            Caption = '1.25 mV'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clGreen
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
        end
      end
    end
    object TS_GDS: TTabSheet
      Caption = 'GDS-806S'
      ImageIndex = 13
      object GB_GDS_Com: TGroupBox
        Left = 575
        Top = 0
        Width = 206
        Height = 147
        Caption = 'COM parameters'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
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
          Left = 10
          Top = 32
          Width = 74
          Height = 26
          ComPort = ComPortGDS
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
          ComPort = ComPortGDS
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
          ComPort = ComPortGDS
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
          ComPort = ComPortGDS
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
          Top = 115
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
      object GB_GDS_Set: TGroupBox
        Left = 575
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
        TabOrder = 1
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
      object ChGDS: TChart
        Left = 2
        Top = 151
        Width = 569
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
        View3D = False
        View3DOptions.Orthogonal = False
        Align = alCustom
        TabOrder = 2
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
        TabOrder = 3
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
      object GB_GDS_Show: TGroupBox
        Left = 575
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
        TabOrder = 4
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
        TabOrder = 6
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
        TabOrder = 7
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
        TabOrder = 8
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
        TabOrder = 9
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
        TabOrder = 10
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
    end
  end
  object BBClose: TBitBtn
    Left = 584
    Top = 508
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkClose
  end
  object BConnect: TButton
    Left = 154
    Top = 508
    Width = 75
    Height = 25
    Caption = 'BConnect'
    TabOrder = 2
    OnClick = BConnectClick
  end
  object BParamReceive: TButton
    Left = 295
    Top = 508
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
    Left = 952
    Top = 664
  end
  object Time: TTimer
    Interval = 3000
    Left = 984
    Top = 648
  end
  object ComDPacket: TComDataPacket
    OnPacket = ComDPacketPacket
    Left = 928
    Top = 648
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.dat'
    Filter = 'data files (*.dat)|*.dat|all files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoValidate, ofPathMustExist, ofShareAware, ofNoTestFileCreate, ofNoNetworkButton, ofNoLongNames, ofNoDereferenceLinks, ofEnableSizing, ofDontAddToRecent]
    OptionsEx = [ofExNoPlacesBar]
    Left = 896
    Top = 648
  end
  object OpenDialog: TOpenDialog
    Left = 992
    Top = 672
  end
  object ComPortUT70B: TComPort
    BaudRate = br2400
    Port = 'COM1'
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
    StoredProps = [spBasic, spBuffer, spTimeouts, spParity]
    TriggersOnRxChar = True
    Left = 868
    Top = 652
  end
  object DependTimer: TTimer
    Enabled = False
    Interval = 5000
    Left = 956
    Top = 648
  end
  object ComPortUT70C: TComPort
    BaudRate = br9600
    Port = 'COM1'
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
    StoredProps = [spBasic, spBuffer, spTimeouts, spParity]
    TriggersOnRxChar = True
    Left = 732
    Top = 648
  end
  object TermostatWatchDog: TTimer
    Enabled = False
    OnTimer = TermostatWatchDogTimer
    Left = 704
    Top = 648
  end
  object ControlWatchDog: TTimer
    Enabled = False
    OnTimer = ControlWatchDogTimer
    Left = 664
    Top = 656
  end
  object ComPortGDS: TComPort
    BaudRate = br9600
    Port = 'COM1'
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
    StoredProps = [spBasic]
    TriggersOnRxChar = True
    Left = 624
    Top = 656
  end
end
