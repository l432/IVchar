object IVchar: TIVchar
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'IVchar'
  ClientHeight = 666
  ClientWidth = 1028
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 17
  object LConnected: TLabel
    Left = 8
    Top = 625
    Width = 97
    Height = 27
    Caption = 'ComPort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -22
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PC: TPageControl
    Left = 0
    Top = 0
    Width = 1028
    Height = 609
    ActivePage = TS_ET1255
    Align = alTop
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -28
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
        Width = 721
        Height = 268
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
        Top = 267
        Width = 721
        Height = 268
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
        Left = 728
        Top = 4
        Width = 292
        Height = 221
        Caption = 'Measurements'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object CBForw: TCheckBox
          Tag = 7
          Left = 16
          Top = 63
          Width = 96
          Height = 17
          Caption = 'Forward'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object CBRev: TCheckBox
          Tag = 7
          Left = 16
          Top = 95
          Width = 96
          Height = 17
          Caption = 'Reverse'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object BIVStart: TButton
          Left = 180
          Top = 58
          Width = 85
          Height = 28
          Caption = 'Start'
          TabOrder = 2
          OnClick = BIVStartClick
        end
        object BIVStop: TButton
          Tag = 4
          Left = 183
          Top = 92
          Width = 84
          Height = 24
          Caption = 'Stop'
          TabOrder = 3
        end
        object BIVSave: TButton
          Tag = 4
          Left = 95
          Top = 187
          Width = 84
          Height = 25
          Caption = 'Save'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object PBIV: TProgressBar
          Left = 24
          Top = 160
          Width = 224
          Height = 20
          Step = 1
          TabOrder = 5
        end
        object CBPC: TCheckBox
          Tag = 6
          Left = 16
          Top = 115
          Width = 272
          Height = 38
          Caption = 'Previous correction is used'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          WordWrap = True
        end
        object CBMeasurements: TComboBox
          Left = 12
          Top = 24
          Width = 253
          Height = 27
          ItemHeight = 19
          TabOrder = 7
          OnChange = CBMeasurementsChange
        end
      end
      object GBAD: TGroupBox
        Left = 727
        Top = 231
        Width = 290
        Height = 157
        Caption = 'Actual Data'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object LADVoltage: TLabel
          Left = 16
          Top = 60
          Width = 65
          Height = 19
          Caption = 'Voltage:'
        end
        object LADVoltageValue: TLabel
          Left = 105
          Top = 54
          Width = 103
          Height = 26
          Caption = '-3.456'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -30
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LADCurrent: TLabel
          Left = 16
          Top = 101
          Width = 67
          Height = 19
          Caption = 'Current:'
        end
        object LADCurrentValue: TLabel
          Left = 105
          Top = 93
          Width = 171
          Height = 26
          Caption = '-1.856e-10'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -30
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LADRange: TLabel
          Left = 64
          Top = 129
          Width = 173
          Height = 19
          Caption = 'Range is [-7.8 .. 7.5] V'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LADInputVoltage: TLabel
          Left = 27
          Top = 25
          Width = 106
          Height = 19
          Caption = 'Input Voltage:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsItalic]
          ParentFont = False
        end
        object LADInputVoltageValue: TLabel
          Left = 148
          Top = 24
          Width = 57
          Height = 24
          Caption = '-3.456'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object GBT: TGroupBox
        Left = 727
        Top = 394
        Width = 290
        Height = 140
        Caption = 'Temperature'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object SBTAuto: TSpeedButton
          Left = 208
          Top = 24
          Width = 65
          Height = 34
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'Auto'
          OnClick = SBTAutoClick
        end
        object LTRunning: TLabel
          Left = 16
          Top = 24
          Width = 67
          Height = 19
          Caption = 'running:'
        end
        object LTRValue: TLabel
          Left = 7
          Top = 48
          Width = 199
          Height = 52
          Caption = '298.51'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -55
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTLast: TLabel
          Left = 14
          Top = 109
          Width = 141
          Height = 19
          Caption = 'last mesurement: '
        end
        object LTLastValue: TLabel
          Left = 178
          Top = 105
          Width = 103
          Height = 26
          Caption = '300.10'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -30
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
        Left = 352
        Top = 25
        Width = 559
        Height = 104
        AutoSize = False
        Caption = '    ERROR'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -83
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object SBV721AAuto: TSpeedButton
        Left = 824
        Top = 178
        Width = 145
        Height = 43
        AllowAllUp = True
        GroupIndex = 2
        Caption = 'AUTO'
      end
      object LV721AU: TLabel
        Left = 923
        Top = 25
        Width = 98
        Height = 104
        AutoSize = False
        Caption = 'a'
        Color = clInfoText
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -87
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object LV721APin: TLabel
        Left = 554
        Top = 256
        Width = 154
        Height = 26
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -28
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LV721APinG: TLabel
        Left = 554
        Top = 392
        Width = 154
        Height = 26
        Caption = 'LV721APin'
      end
      object RGV721A_MM: TRadioGroup
        Left = 0
        Top = 0
        Width = 326
        Height = 137
        Caption = 'Measure Mode'
        Color = clCream
        Columns = 3
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
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
        Top = 145
        Width = 524
        Height = 360
        Caption = 'Range'
        Color = clSkyBlue
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -35
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
        Left = 554
        Top = 178
        Width = 207
        Height = 43
        Caption = 'measurement'
        TabOrder = 2
      end
      object CBV721A: TComboBox
        Tag = 1
        Left = 554
        Top = 313
        Width = 121
        Height = 41
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 33
        ParentFont = False
        TabOrder = 3
      end
      object BV721ASet: TButton
        Left = 744
        Top = 297
        Width = 153
        Height = 38
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -28
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
      object BV721ASetGate: TButton
        Left = 744
        Top = 345
        Width = 153
        Height = 38
        Caption = 'set gate'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
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
        Width = 1020
        Height = 263
        Align = alTop
        TabOrder = 0
        object LV721IPin: TLabel
          Left = 706
          Top = 111
          Width = 314
          Height = 42
          AutoSize = False
          Caption = 'LV721APin'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object LV721I: TLabel
          Left = 344
          Top = 0
          Width = 560
          Height = 105
          AutoSize = False
          Caption = '    ERROR'
          Color = clWhite
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -83
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LV721IU: TLabel
          Left = 915
          Top = 0
          Width = 98
          Height = 105
          AutoSize = False
          Caption = 'a'
          Color = clInfoText
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWhite
          Font.Height = -87
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object SBV721IAuto: TSpeedButton
          Left = 562
          Top = 201
          Width = 127
          Height = 44
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
        end
        object LV721IPinG: TLabel
          Left = 706
          Top = 220
          Width = 275
          Height = 28
          AutoSize = False
          Caption = 'LV721APin'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object RGV721I_MM: TRadioGroup
          Left = 0
          Top = 0
          Width = 326
          Height = 105
          Caption = 'Measure Mode'
          Color = clCream
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
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
          Left = 726
          Top = 160
          Width = 121
          Height = 41
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 33
          ParentFont = False
          TabOrder = 1
        end
        object BV721ISet: TButton
          Left = 866
          Top = 148
          Width = 150
          Height = 30
          Caption = 'set control'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object RGV721IRange: TRadioGroup
          Left = 0
          Top = 111
          Width = 553
          Height = 151
          Caption = 'Range'
          Color = clSkyBlue
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -35
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
          Left = 562
          Top = 127
          Width = 127
          Height = 51
          Caption = 'measure'
          TabOrder = 4
        end
        object BV721ISetGate: TButton
          Left = 866
          Top = 184
          Width = 150
          Height = 30
          Caption = 'set gate'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
      end
      object PanelV721_II: TPanel
        Left = 0
        Top = 274
        Width = 1020
        Height = 263
        Align = alBottom
        TabOrder = 1
        object LV721IIPin: TLabel
          Left = 7
          Top = 118
          Width = 313
          Height = 43
          AutoSize = False
          Caption = 'LV721APin'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object LV721II: TLabel
          Left = 0
          Top = 0
          Width = 558
          Height = 105
          AutoSize = False
          Caption = '    ERROR'
          Color = clWhite
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -83
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LV721IIU: TLabel
          Left = 571
          Top = 0
          Width = 99
          Height = 105
          AutoSize = False
          Caption = 'a'
          Color = clInfoText
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWhite
          Font.Height = -87
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object SBV721IIAuto: TSpeedButton
          Left = 327
          Top = 201
          Width = 127
          Height = 44
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
        end
        object LV721IIPinG: TLabel
          Left = 7
          Top = 217
          Width = 313
          Height = 43
          AutoSize = False
          Caption = 'LV721APin'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object RGV721II_MM: TRadioGroup
          Left = 696
          Top = 0
          Width = 327
          Height = 105
          Caption = 'Measure Mode'
          Color = clCream
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
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
          Left = 7
          Top = 160
          Width = 120
          Height = 41
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 33
          ParentFont = False
          TabOrder = 1
        end
        object BV721IISet: TButton
          Left = 144
          Top = 148
          Width = 150
          Height = 30
          Caption = 'set control'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object RGV721IIRange: TRadioGroup
          Left = 472
          Top = 111
          Width = 551
          Height = 151
          Caption = 'Range'
          Color = clSkyBlue
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -35
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
          Left = 327
          Top = 126
          Width = 127
          Height = 51
          Caption = 'measure'
          TabOrder = 4
        end
        object BV721IISetGate: TButton
          Left = 144
          Top = 184
          Width = 150
          Height = 30
          Caption = 'set gate'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
      end
      object PanelSplit: TPanel
        Left = 0
        Top = 256
        Width = 1025
        Height = 17
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
        Left = 711
        Top = 58
        Width = 314
        Height = 41
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object LDACPinG: TLabel
        Left = 711
        Top = 146
        Width = 314
        Height = 42
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object LDACPinLDAC: TLabel
        Left = 711
        Top = 234
        Width = 314
        Height = 42
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object LDACPinCLR: TLabel
        Left = 711
        Top = 322
        Width = 314
        Height = 42
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object PanelDACChA: TPanel
        Left = 3
        Top = 3
        Width = 295
        Height = 459
        BevelWidth = 3
        BorderStyle = bsSingle
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object LORChA: TLabel
          Left = 129
          Top = 105
          Width = 139
          Height = 26
          Caption = '-10.8..10.8'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LPowChA: TLabel
          Left = 145
          Top = 50
          Width = 107
          Height = 25
          Caption = 'Power on'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LOVChA: TLabel
          Left = 129
          Top = 184
          Width = 99
          Height = 26
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object STChA: TStaticText
          Left = 42
          Top = 0
          Width = 164
          Height = 38
          Caption = 'Channel A'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -28
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object STORChA: TStaticText
          Left = 3
          Top = 111
          Width = 120
          Height = 23
          Caption = 'Output Range:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object CBORChA: TComboBox
          Left = 10
          Top = 139
          Width = 143
          Height = 33
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ItemHeight = 25
          ParentFont = False
          TabOrder = 2
        end
        object BORChA: TButton
          Left = 177
          Top = 139
          Width = 107
          Height = 28
          Caption = 'set range'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object BBPowChA: TBitBtn
          Left = 25
          Top = 48
          Width = 98
          Height = 33
          Caption = 'Off'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object BOVchangeChA: TButton
          Left = 14
          Top = 220
          Width = 109
          Height = 30
          Caption = 'change'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object BOVsetChA: TButton
          Left = 160
          Top = 220
          Width = 108
          Height = 30
          Caption = 'set value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object STOVChA: TStaticText
          Left = 3
          Top = 191
          Width = 108
          Height = 23
          Caption = 'OutputValue:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object GBMeasChA: TGroupBox
          Tag = 110
          Left = 42
          Top = 262
          Width = 201
          Height = 173
          Caption = 'Measurement'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
          object LMeasChA: TLabel
            Left = 44
            Top = 20
            Width = 92
            Height = 20
            Caption = '-0.0008'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Courier'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object RBMeasSimChA: TRadioButton
            Tag = 110
            Left = 4
            Top = 89
            Width = 114
            Height = 17
            Caption = 'Simulation'
            TabOrder = 0
          end
          object RBMeasMeasChA: TRadioButton
            Tag = 111
            Left = 4
            Top = 114
            Width = 137
            Height = 17
            Caption = 'Measurement'
            TabOrder = 1
          end
          object CBMeasChA: TComboBox
            Tag = 5
            Left = 4
            Top = 135
            Width = 145
            Height = 27
            Style = csDropDownList
            ItemHeight = 19
            TabOrder = 2
          end
          object BMeasChA: TButton
            Left = 31
            Top = 51
            Width = 138
            Height = 30
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
        end
      end
      object CBDAC: TComboBox
        Tag = 1
        Left = 881
        Top = 10
        Width = 122
        Height = 41
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 33
        ParentFont = False
        TabOrder = 1
      end
      object BDACSetC: TButton
        Left = 875
        Top = 106
        Width = 150
        Height = 30
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object BDACSetG: TButton
        Left = 875
        Top = 194
        Width = 150
        Height = 30
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object BDACSetLDAC: TButton
        Left = 875
        Top = 282
        Width = 150
        Height = 31
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
      object BDACSetCLR: TButton
        Left = 875
        Top = 370
        Width = 150
        Height = 30
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
      object BDACInit: TButton
        Left = 89
        Top = 469
        Width = 161
        Height = 42
        Caption = 'Initialization'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
      end
      object BDACReset: TButton
        Left = 365
        Top = 469
        Width = 161
        Height = 42
        Caption = 'Reset'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
      end
      object PanelDACChB: TPanel
        Left = 315
        Top = 3
        Width = 294
        Height = 459
        BevelWidth = 3
        BorderStyle = bsSingle
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        object LORChB: TLabel
          Left = 129
          Top = 105
          Width = 139
          Height = 26
          Caption = '-10.8..10.8'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LPowChB: TLabel
          Left = 145
          Top = 50
          Width = 107
          Height = 25
          Caption = 'Power on'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LOVChB: TLabel
          Left = 129
          Top = 184
          Width = 99
          Height = 26
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object STChB: TStaticText
          Left = 42
          Top = 0
          Width = 163
          Height = 38
          Caption = 'Channel B'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -28
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object STORChB: TStaticText
          Left = 3
          Top = 111
          Width = 120
          Height = 23
          Caption = 'Output Range:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object CBORChB: TComboBox
          Left = 10
          Top = 139
          Width = 143
          Height = 33
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ItemHeight = 25
          ParentFont = False
          TabOrder = 2
        end
        object BORChB: TButton
          Left = 177
          Top = 139
          Width = 107
          Height = 28
          Caption = 'set range'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object BBPowChB: TBitBtn
          Left = 25
          Top = 48
          Width = 98
          Height = 33
          Caption = 'Off'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STOVChB: TStaticText
          Left = 3
          Top = 191
          Width = 108
          Height = 23
          Caption = 'OutputValue:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object BOVchangeChB: TButton
          Left = 14
          Top = 220
          Width = 109
          Height = 30
          Caption = 'change'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object BOVsetChB: TButton
          Left = 160
          Top = 218
          Width = 108
          Height = 30
          Caption = 'set value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object GBMeasChB: TGroupBox
          Tag = 110
          Left = 42
          Top = 262
          Width = 201
          Height = 173
          Caption = 'Measurement'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
          object LMeasChB: TLabel
            Left = 44
            Top = 20
            Width = 92
            Height = 20
            Caption = '-0.0008'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Courier'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object RBMeasSimChB: TRadioButton
            Tag = 110
            Left = 4
            Top = 89
            Width = 114
            Height = 17
            Caption = 'Simulation'
            TabOrder = 0
          end
          object RBMeasMeasChB: TRadioButton
            Tag = 111
            Left = 4
            Top = 114
            Width = 137
            Height = 17
            Caption = 'Measurement'
            TabOrder = 1
          end
          object CBMeasChB: TComboBox
            Tag = 5
            Left = 4
            Top = 135
            Width = 145
            Height = 27
            Style = csDropDownList
            ItemHeight = 19
            TabOrder = 2
          end
          object BMeasChB: TButton
            Left = 31
            Top = 51
            Width = 138
            Height = 30
            Caption = 'to measure'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
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
        Left = 17
        Top = 78
        Width = 314
        Height = 42
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object LDACR2RPinG: TLabel
        Left = 17
        Top = 167
        Width = 314
        Height = 42
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object LOVDACR2R: TLabel
        Left = 613
        Top = 30
        Width = 99
        Height = 26
        Caption = '-0.0008'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LOKDACR2R: TLabel
        Left = 613
        Top = 150
        Width = 91
        Height = 26
        Caption = '-65000'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LCodeRangeDACR2R: TLabel
        Left = 471
        Top = 234
        Width = 304
        Height = 25
        Caption = 'Code: -65535 ... 0 ... 65535'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -20
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LValueRangeDACR2R: TLabel
        Left = 540
        Top = 4
        Width = 192
        Height = 25
        Caption = 'Value: -6.6 ... 6.6'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -20
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CBDACR2R: TComboBox
        Tag = 1
        Left = 13
        Top = 21
        Width = 122
        Height = 41
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 33
        ParentFont = False
        TabOrder = 0
      end
      object BDACR2RSetC: TButton
        Left = 13
        Top = 129
        Width = 150
        Height = 31
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object BDACR2RSetG: TButton
        Left = 13
        Top = 217
        Width = 150
        Height = 30
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object STOVDACR2R: TStaticText
        Left = 486
        Top = 37
        Width = 113
        Height = 23
        Caption = 'Output Value:'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object BOVchangeDACR2R: TButton
        Left = 497
        Top = 65
        Width = 108
        Height = 30
        Caption = 'change'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
      object BOVsetDACR2R: TButton
        Left = 643
        Top = 65
        Width = 108
        Height = 30
        Caption = 'set value'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
      object GBMeasR2R: TGroupBox
        Tag = 110
        Left = 800
        Top = 14
        Width = 200
        Height = 217
        Caption = 'Measurement'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        object LMeasR2R: TLabel
          Left = 44
          Top = 20
          Width = 92
          Height = 20
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object BMeasR2R: TButton
          Left = 31
          Top = 51
          Width = 138
          Height = 30
          Caption = 'to measure'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object STMDR2R: TStaticText
          Left = 35
          Top = 118
          Width = 127
          Height = 23
          Caption = 'Measure Device'
          TabOrder = 1
        end
        object CBMeasDACR2R: TComboBox
          Tag = 5
          Left = 13
          Top = 153
          Width = 173
          Height = 27
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 19
          ParentFont = False
          TabOrder = 2
        end
      end
      object BDACR2RReset: TButton
        Left = 497
        Top = 106
        Width = 161
        Height = 42
        Caption = 'Reset'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
      end
      object BOKsetDACR2R: TButton
        Left = 645
        Top = 187
        Width = 106
        Height = 30
        Caption = 'set code'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
      end
      object GBCalibrR2R: TGroupBox
        Left = 17
        Top = 271
        Width = 513
        Height = 263
        Caption = 'Calibration'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
        object GBCalibrR2RPV: TGroupBox
          Left = 16
          Top = 24
          Width = 257
          Height = 105
          Caption = 'Positive Voltage'
          TabOrder = 0
          object LFBHighlimitValueR2R: TLabel
            Left = 152
            Top = 24
            Width = 38
            Height = 32
            Caption = '7.5'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clRed
            Font.Height = -27
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LFBLowlimitValueR2R: TLabel
            Left = 152
            Top = 64
            Width = 38
            Height = 32
            Caption = '7.5'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clRed
            Font.Height = -27
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object STFBhighlimitR2R: TStaticText
            Left = 14
            Top = 27
            Width = 128
            Height = 28
            Caption = 'high limit, V :'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -20
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object STFBlowlimitR2R: TStaticText
            Left = 14
            Top = 67
            Width = 119
            Height = 28
            Caption = 'low limit, V :'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -20
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object UDFBHighLimitR2R: TUpDown
            Tag = 2
            Left = 214
            Top = 27
            Width = 21
            Height = 31
            Max = 80
            Position = 40
            TabOrder = 2
          end
          object UDFBLowLimitR2R: TUpDown
            Tag = 2
            Left = 214
            Top = 63
            Width = 21
            Height = 31
            Max = 80
            Position = 40
            TabOrder = 3
          end
        end
        object GBCalibrR2RNV: TGroupBox
          Left = 16
          Top = 143
          Width = 257
          Height = 104
          Caption = 'Negative Voltage'
          TabOrder = 1
          object LRBHighlimitValueR2R: TLabel
            Left = 152
            Top = 24
            Width = 38
            Height = 32
            Caption = '7.5'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlue
            Font.Height = -27
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LRBLowlimitValueR2R: TLabel
            Left = 152
            Top = 61
            Width = 38
            Height = 32
            Caption = '7.5'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlue
            Font.Height = -27
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object STRBhighlimitR2R: TStaticText
            Left = 14
            Top = 27
            Width = 128
            Height = 28
            Caption = 'high limit, V :'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -20
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object STRBlowlimitR2R: TStaticText
            Left = 14
            Top = 67
            Width = 119
            Height = 28
            Caption = 'low limit, V :'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -20
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object UDRBHighLimitR2R: TUpDown
            Tag = 2
            Left = 220
            Top = 24
            Width = 21
            Height = 30
            Max = 80
            Position = 40
            TabOrder = 2
          end
          object UDRBLowLimitR2R: TUpDown
            Tag = 2
            Left = 220
            Top = 63
            Width = 21
            Height = 31
            Max = 80
            Position = 40
            TabOrder = 3
          end
        end
        object BDFFA_R2R: TButton
          Left = 285
          Top = 118
          Width = 212
          Height = 40
          Caption = 'data from file add'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = BDFFA_R2RClick
        end
      end
      object STOKDACR2R: TStaticText
        Left = 486
        Top = 157
        Width = 111
        Height = 23
        Caption = 'Output Code:'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
      end
      object BOKchangeDACR2R: TButton
        Left = 497
        Top = 187
        Width = 108
        Height = 30
        Caption = 'change'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 11
      end
    end
    object TS_Setting: TTabSheet
      Caption = 'Setting'
      ImageIndex = 4
      object LPR: TLabel
        Left = 22
        Top = 445
        Width = 33
        Height = 18
        Caption = 'LPR'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LMC: TLabel
        Left = 214
        Top = 340
        Width = 44
        Height = 18
        Caption = 'L1PR'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LMinC: TLabel
        Left = 214
        Top = 404
        Width = 44
        Height = 18
        Caption = 'L1PR'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LFVP: TLabel
        Left = 432
        Top = 340
        Width = 44
        Height = 18
        Caption = 'L1PR'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LRVP: TLabel
        Left = 432
        Top = 404
        Width = 44
        Height = 18
        Caption = 'L1PR'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GBFB: TGroupBox
        Left = 22
        Top = 16
        Width = 243
        Height = 314
        Caption = 'Forward branch'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object LFBHighlimitValue: TLabel
          Left = 152
          Top = 24
          Width = 38
          Height = 32
          Caption = '7.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LFBLowlimitValue: TLabel
          Left = 152
          Top = 64
          Width = 38
          Height = 32
          Caption = '7.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LFBDelayValue: TLabel
          Left = 115
          Top = 275
          Width = 60
          Height = 32
          Caption = '5000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object STFBSteps: TStaticText
          Left = 27
          Top = 109
          Width = 197
          Height = 28
          Caption = 'measurement steps:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
        object UDFBHighLimit: TUpDown
          Tag = 2
          Left = 208
          Top = 24
          Width = 21
          Height = 30
          Max = 80
          Position = 40
          TabOrder = 0
        end
        object STFBhighlimit: TStaticText
          Left = 14
          Top = 27
          Width = 128
          Height = 28
          Caption = 'high limit, V :'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object UDFBLowLimit: TUpDown
          Tag = 2
          Left = 208
          Top = 63
          Width = 21
          Height = 31
          Max = 80
          Position = 40
          TabOrder = 2
        end
        object STFBlowlimit: TStaticText
          Left = 14
          Top = 67
          Width = 119
          Height = 28
          Caption = 'low limit, V :'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object SGFBStep: TStringGrid
          Tag = 3
          Left = 14
          Top = 133
          Width = 132
          Height = 115
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
          Left = 152
          Top = 167
          Width = 83
          Height = 27
          Caption = 'Edit'
          TabOrder = 5
          OnClick = BFBEditClick
        end
        object BFBDelete: TButton
          Tag = 4
          Left = 152
          Top = 200
          Width = 83
          Height = 28
          Caption = 'Delete'
          TabOrder = 6
          OnClick = BFBDeleteClick
        end
        object BFBAdd: TButton
          Left = 152
          Top = 133
          Width = 83
          Height = 28
          Caption = 'Add'
          TabOrder = 7
          OnClick = BFBAddClick
        end
        object STFBDelay: TStaticText
          Left = 14
          Top = 255
          Width = 98
          Height = 55
          AutoSize = False
          Caption = 'delay time, ms :'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
        end
        object BFBDelayInput: TButton
          Left = 180
          Top = 275
          Width = 61
          Height = 27
          Caption = 'Input'
          TabOrder = 10
          OnClick = BFBDelayInputClick
        end
      end
      object GBRB: TGroupBox
        Left = 302
        Top = 16
        Width = 243
        Height = 314
        Caption = 'Reverse branch'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object LRBHighlimitValue: TLabel
          Left = 152
          Top = 26
          Width = 38
          Height = 32
          Caption = '7.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LRBLowlimitValue: TLabel
          Left = 152
          Top = 64
          Width = 38
          Height = 32
          Caption = '7.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LRBDelayValue: TLabel
          Left = 115
          Top = 275
          Width = 60
          Height = 32
          Caption = '5000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object STRBSteps: TStaticText
          Left = 27
          Top = 109
          Width = 197
          Height = 28
          Caption = 'measurement steps:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
        object UDRBHighLimit: TUpDown
          Tag = 2
          Left = 208
          Top = 24
          Width = 21
          Height = 30
          Max = 80
          Position = 40
          TabOrder = 0
        end
        object STRBhighlimit: TStaticText
          Left = 14
          Top = 27
          Width = 128
          Height = 28
          Caption = 'high limit, V :'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object UDRBLowLimit: TUpDown
          Tag = 2
          Left = 208
          Top = 63
          Width = 21
          Height = 31
          Max = 80
          Position = 40
          TabOrder = 2
        end
        object STRBlowlimit: TStaticText
          Left = 14
          Top = 67
          Width = 119
          Height = 28
          Caption = 'low limit, V :'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object SGRBStep: TStringGrid
          Tag = 3
          Left = 14
          Top = 133
          Width = 132
          Height = 115
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
          Left = 152
          Top = 167
          Width = 83
          Height = 27
          Caption = 'Edit'
          TabOrder = 5
          OnClick = BRBEditClick
        end
        object BRBDelete: TButton
          Tag = 4
          Left = 152
          Top = 200
          Width = 83
          Height = 28
          Caption = 'Delete'
          TabOrder = 6
          OnClick = BRBDeleteClick
        end
        object BRBAdd: TButton
          Left = 152
          Top = 133
          Width = 83
          Height = 28
          Caption = 'Add'
          TabOrder = 7
          OnClick = BFBAddClick
        end
        object STRBDelay: TStaticText
          Left = 14
          Top = 255
          Width = 98
          Height = 55
          AutoSize = False
          Caption = 'delay time, ms :'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
        end
        object BRBDelayInput: TButton
          Left = 180
          Top = 275
          Width = 61
          Height = 27
          Caption = 'Input'
          TabOrder = 10
          OnClick = BFBDelayInputClick
        end
      end
      object BSaveSetting: TButton
        Left = 432
        Top = 497
        Width = 145
        Height = 33
        Caption = 'Save Setting'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = BSaveSettingClick
      end
      object RGDO: TRadioGroup
        Left = 22
        Top = 330
        Width = 161
        Height = 96
        Caption = 'Diod orientation'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Items.Strings = (
          'Normal'
          'Inverse')
        ParentFont = False
        TabOrder = 3
      end
      object GBCOM: TGroupBox
        Left = 849
        Top = 340
        Width = 161
        Height = 213
        Caption = 'COM parameters'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object ComCBPort: TComComboBox
          Left = 16
          Top = 52
          Width = 96
          Height = 32
          ComPort = ComPort1
          ComProperty = cpPort
          AutoApply = True
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 24
          ItemIndex = -1
          ParentFont = False
          TabOrder = 0
        end
        object ComCBBR: TComComboBox
          Left = 16
          Top = 140
          Width = 121
          Height = 32
          ComPort = ComPort1
          ComProperty = cpBaudRate
          AutoApply = True
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 24
          ItemIndex = -1
          ParentFont = False
          TabOrder = 1
        end
        object STCOMP: TStaticText
          Left = 39
          Top = 16
          Width = 52
          Height = 29
          Caption = 'Port'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object STComBR: TStaticText
          Left = 21
          Top = 105
          Width = 118
          Height = 29
          Caption = 'Baud Rate'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
      end
      object GBDS: TGroupBox
        Left = 551
        Top = 16
        Width = 434
        Height = 314
        Caption = 'Device Selection'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        object LRVtoI: TLabel
          Left = 13
          Top = 114
          Width = 44
          Height = 18
          Caption = 'L1PR'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LVVtoI: TLabel
          Left = 13
          Top = 218
          Width = 44
          Height = 18
          Caption = 'L1PR'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CBVS: TComboBox
          Tag = 5
          Left = 12
          Top = 54
          Width = 172
          Height = 27
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 19
          ParentFont = False
          TabOrder = 0
        end
        object STVMD: TStaticText
          Left = 229
          Top = 24
          Width = 191
          Height = 23
          Caption = 'Voltage Measure Device'
          TabOrder = 1
        end
        object STVS: TStaticText
          Left = 13
          Top = 24
          Width = 124
          Height = 23
          Caption = 'Voltage Source'
          TabOrder = 2
        end
        object STCMD: TStaticText
          Left = 237
          Top = 109
          Width = 193
          Height = 23
          Caption = 'Current Measure Device'
          TabOrder = 3
        end
        object CBVMD: TComboBox
          Tag = 5
          Left = 235
          Top = 54
          Width = 173
          Height = 27
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 19
          ParentFont = False
          TabOrder = 4
        end
        object CBCMD: TComboBox
          Tag = 5
          Left = 235
          Top = 139
          Width = 173
          Height = 27
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 19
          ParentFont = False
          TabOrder = 5
        end
        object CBVtoI: TCheckBox
          Tag = 6
          Left = 10
          Top = 169
          Width = 184
          Height = 38
          Caption = 'Resistance used'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
          WordWrap = True
        end
        object STRVtoI: TStaticText
          Left = 13
          Top = 139
          Width = 126
          Height = 30
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object STVVtoI: TStaticText
          Left = 13
          Top = 242
          Width = 126
          Height = 30
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
      end
      object CBCurrentValue: TCheckBox
        Tag = 6
        Left = 214
        Top = 464
        Width = 184
        Height = 38
        Caption = 'Current controlled'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        WordWrap = True
      end
      object STPR: TStaticText
        Left = 22
        Top = 468
        Width = 126
        Height = 30
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
      end
      object STMC: TStaticText
        Left = 214
        Top = 364
        Width = 126
        Height = 30
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
      end
      object STMinC: TStaticText
        Left = 214
        Top = 428
        Width = 126
        Height = 30
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
      end
      object STFVP: TStaticText
        Left = 432
        Top = 364
        Width = 126
        Height = 30
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
      end
      object STRVP: TStaticText
        Left = 432
        Top = 428
        Width = 126
        Height = 30
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
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
        Left = 18
        Top = 156
        Width = 44
        Height = 18
        Caption = 'L1PR'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object GBDS18B: TGroupBox
        Left = 292
        Top = 25
        Width = 242
        Height = 155
        Caption = 'DS18B20'
        TabOrder = 0
        object LDS18BPin: TLabel
          Left = 3
          Top = 25
          Width = 234
          Height = 42
          AutoSize = False
          Caption = 'LV721APin'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object BDS18B: TButton
          Left = 56
          Top = 122
          Width = 151
          Height = 30
          Caption = 'set control'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object CBDS18b20: TComboBox
          Tag = 11
          Left = 68
          Top = 73
          Width = 122
          Height = 41
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 33
          ParentFont = False
          TabOrder = 1
        end
      end
      object CBTD: TComboBox
        Tag = 5
        Left = 18
        Top = 54
        Width = 173
        Height = 27
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 19
        ParentFont = False
        TabOrder = 1
      end
      object STTD: TStaticText
        Left = 18
        Top = 25
        Width = 161
        Height = 23
        Caption = 'Temperature Device'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object STTMI: TStaticText
        Left = 18
        Top = 211
        Width = 126
        Height = 30
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object GBThermocouple: TGroupBox
        Left = 556
        Top = 25
        Width = 242
        Height = 155
        Caption = 'ThermoCouple'
        TabOrder = 4
        object STTCV: TStaticText
          Left = 35
          Top = 25
          Width = 168
          Height = 23
          Caption = 'Termocouple voltage'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object CBTcVMD: TComboBox
          Tag = 5
          Left = 34
          Top = 73
          Width = 173
          Height = 27
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 19
          ParentFont = False
          TabOrder = 1
        end
        object STMD: TStaticText
          Left = 52
          Top = 44
          Width = 141
          Height = 23
          Caption = 'measuring device'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
      end
      object GBTermostat: TGroupBox
        Left = 4
        Top = 275
        Width = 589
        Height = 218
        Caption = 'Thermostat Setup'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        object LTermostatNT: TLabel
          Left = 189
          Top = 42
          Width = 62
          Height = 18
          Caption = 'Needed'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object LTermostatCT: TLabel
          Left = 14
          Top = 21
          Width = 107
          Height = 36
          Caption = 'Current Temperature'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object SBTermostat: TSpeedButton
          Left = 193
          Top = 117
          Width = 172
          Height = 34
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'Start Control'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = SBTermostatClick
        end
        object LTermostatCTValue: TLabel
          Left = 14
          Top = 68
          Width = 122
          Height = 26
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatTolerance: TLabel
          Left = 331
          Top = 46
          Width = 79
          Height = 18
          Caption = 'Tolerance'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatKp: TLabel
          Left = 14
          Top = 115
          Width = 27
          Height = 22
          Caption = 'Kp'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -18
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatKi: TLabel
          Left = 14
          Top = 151
          Width = 20
          Height = 22
          Caption = 'Ki'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -18
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatKd: TLabel
          Left = 14
          Top = 187
          Width = 27
          Height = 22
          Caption = 'Kd'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -18
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatOutputValue: TLabel
          Left = 407
          Top = 173
          Width = 122
          Height = 26
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clPurple
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatWatchDog: TLabel
          Left = 3
          Top = 63
          Width = 11
          Height = 16
          Caption = 'o'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clLime
          Font.Height = -17
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object CBTermostatCD: TComboBox
          Tag = 5
          Left = 389
          Top = 124
          Width = 173
          Height = 27
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 19
          ParentFont = False
          TabOrder = 0
        end
        object STTermostatCD: TStaticText
          Left = 412
          Top = 98
          Width = 117
          Height = 23
          Caption = 'Driving Device'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object STTermostatNT: TStaticText
          Left = 189
          Top = 68
          Width = 126
          Height = 30
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object STTermostatKi: TStaticText
          Left = 61
          Top = 148
          Width = 126
          Height = 30
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object STTermostatKp: TStaticText
          Left = 61
          Top = 112
          Width = 126
          Height = 30
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STTermostatKd: TStaticText
          Left = 61
          Top = 184
          Width = 126
          Height = 30
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object BTermostatReset: TButton
          Left = 217
          Top = 173
          Width = 98
          Height = 32
          Caption = 'Reset'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          OnClick = BTermostatResetClick
        end
        object STTermostatTolerance: TStaticText
          Left = 331
          Top = 70
          Width = 104
          Height = 26
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
      end
    end
    object TS_UT70: TTabSheet
      Caption = 'UT70'
      ImageIndex = 7
      object PanelUT70B: TPanel
        Left = 0
        Top = 0
        Width = 1020
        Height = 263
        Align = alTop
        TabOrder = 0
        object LUT70B: TLabel
          Left = 277
          Top = 0
          Width = 560
          Height = 105
          AutoSize = False
          Caption = '    ERROR'
          Color = clWhite
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -83
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LUT70BU: TLabel
          Left = 845
          Top = 0
          Width = 168
          Height = 105
          AutoSize = False
          Caption = 'a'
          Color = clInfoText
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWhite
          Font.Height = -87
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object SBUT70BAuto: TSpeedButton
          Left = 732
          Top = 218
          Width = 105
          Height = 33
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
        end
        object LUT70BPort: TLabel
          Left = 850
          Top = 231
          Width = 66
          Height = 20
          Caption = 'Port '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RGUT70B_MM: TRadioGroup
          Left = 0
          Top = 0
          Width = 279
          Height = 256
          Caption = 'UT 70B'
          Color = clCream
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
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
          Left = 277
          Top = 105
          Width = 447
          Height = 150
          Caption = 'Range'
          Color = clSkyBlue
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
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
          Left = 732
          Top = 166
          Width = 140
          Height = 35
          Caption = 'measure'
          TabOrder = 2
        end
        object RGUT70B_RangeM: TRadioGroup
          Left = 732
          Top = 105
          Width = 281
          Height = 53
          Color = clInfoBk
          Columns = 2
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
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
          Left = 925
          Top = 160
          Width = 52
          Height = 29
          Caption = 'Port'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object ComCBUT70BPort: TComComboBox
          Left = 904
          Top = 190
          Width = 96
          Height = 32
          ComPort = ComPortUT70B
          ComProperty = cpPort
          AutoApply = True
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 24
          ItemIndex = -1
          ParentFont = False
          TabOrder = 5
        end
      end
      object PanelUT70C: TPanel
        Left = 0
        Top = 263
        Width = 1020
        Height = 263
        Align = alTop
        TabOrder = 1
        object LUT70C: TLabel
          Left = 277
          Top = 0
          Width = 560
          Height = 85
          AutoSize = False
          Caption = '    ERROR'
          Color = clWhite
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -77
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LUT70CU: TLabel
          Left = 845
          Top = 0
          Width = 168
          Height = 105
          AutoSize = False
          Caption = 'a'
          Color = clInfoText
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWhite
          Font.Height = -87
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object SBUT70CAuto: TSpeedButton
          Left = 732
          Top = 218
          Width = 105
          Height = 33
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
        end
        object LUT70CPort: TLabel
          Left = 850
          Top = 231
          Width = 66
          Height = 20
          Caption = 'Port '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LUT70C_rec: TLabel
          Left = 401
          Top = 93
          Width = 51
          Height = 31
          Caption = 'REC'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LUT70C_Hold: TLabel
          Left = 621
          Top = 93
          Width = 68
          Height = 31
          Caption = 'HOLD'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LUT70C_AVG: TLabel
          Left = 506
          Top = 93
          Width = 51
          Height = 31
          Caption = 'AVG'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LUT70C_AvTime: TLabel
          Left = 294
          Top = 94
          Width = 73
          Height = 26
          Caption = '100 ms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RGUT70C_MM: TRadioGroup
          Left = 0
          Top = 0
          Width = 279
          Height = 256
          Caption = 'UT 70C'
          Color = clCream
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
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
          Left = 277
          Top = 126
          Width = 447
          Height = 129
          Caption = 'Range'
          Color = clSkyBlue
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
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
          Left = 732
          Top = 166
          Width = 140
          Height = 35
          Caption = 'measure'
          TabOrder = 2
        end
        object RGUT70C_RangeM: TRadioGroup
          Left = 732
          Top = 105
          Width = 281
          Height = 53
          Color = clInfoBk
          Columns = 2
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
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
          Left = 925
          Top = 160
          Width = 52
          Height = 29
          Caption = 'Port'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object ComCBUT70CPort: TComComboBox
          Left = 904
          Top = 190
          Width = 96
          Height = 32
          ComPort = ComPortUT70C
          ComProperty = cpPort
          AutoApply = True
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 24
          ItemIndex = -1
          ParentFont = False
          TabOrder = 5
        end
      end
    end
    object TS_ET1255: TTabSheet
      Caption = 'ET1255_DAC'
      ImageIndex = 8
      object PET1255DAC: TPanel
        Left = 4
        Top = 4
        Width = 1013
        Height = 523
        BevelWidth = 3
        BorderStyle = bsSingle
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object LValueRangeDAC1255: TLabel
          Left = 222
          Top = 7
          Width = 192
          Height = 25
          Caption = 'Value: -2.5 ... 2.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LCodeRangeDAC1255: TLabel
          Left = 222
          Top = 34
          Width = 266
          Height = 25
          Caption = 'Code: 0 ... 2048 ... 4096'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object STDAC: TStaticText
          Left = 42
          Top = 0
          Width = 69
          Height = 38
          Caption = 'DAC'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -28
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object GBET1255DACh0: TGroupBox
          Tag = 110
          Left = 17
          Top = 59
          Width = 556
          Height = 148
          Caption = 'Channel 0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object LOV1255ch0: TLabel
            Left = 238
            Top = 33
            Width = 83
            Height = 26
            Caption = '-2.547'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LOK1255Ch0: TLabel
            Left = 255
            Top = 110
            Width = 64
            Height = 26
            Caption = '4096'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BOVset1255Ch0: TButton
            Left = 124
            Top = 33
            Width = 107
            Height = 30
            Caption = 'set value'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object BOVchange1255Ch0: TButton
            Left = 10
            Top = 33
            Width = 109
            Height = 30
            Caption = 'change'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object BReset1255Ch0: TButton
            Left = 10
            Top = 72
            Width = 161
            Height = 30
            Caption = 'Reset'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -20
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object BOKchange1255Ch0: TButton
            Left = 8
            Top = 110
            Width = 108
            Height = 30
            Caption = 'change'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
          object BOKset1255Ch0: TButton
            Left = 124
            Top = 110
            Width = 106
            Height = 30
            Caption = 'set code'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object GBMeas1255Ch0: TGroupBox
            Tag = 110
            Left = 352
            Top = 12
            Width = 192
            Height = 128
            Caption = 'Measurement'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
            object LMeas1255Ch0: TLabel
              Left = 48
              Top = 20
              Width = 92
              Height = 20
              Caption = '-0.0008'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -22
              Font.Name = 'Courier'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object BMeas1255Ch0: TButton
              Left = 27
              Top = 42
              Width = 138
              Height = 22
              Caption = 'to measure'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -22
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object STMD1255Ch0: TStaticText
              Left = 31
              Top = 67
              Width = 127
              Height = 23
              Caption = 'Measure Device'
              TabOrder = 1
            end
            object CBMeasET1255Ch0: TComboBox
              Tag = 5
              Left = 10
              Top = 88
              Width = 173
              Height = 27
              Style = csDropDownList
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ItemHeight = 19
              ParentFont = False
              TabOrder = 2
            end
          end
        end
        object GBET1255DACh1: TGroupBox
          Tag = 110
          Left = 17
          Top = 209
          Width = 556
          Height = 148
          Caption = 'Channel 1'
          Color = clSilver
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 2
          object LOV1255ch1: TLabel
            Left = 238
            Top = 33
            Width = 83
            Height = 26
            Caption = '-2.547'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LOK1255Ch1: TLabel
            Left = 255
            Top = 110
            Width = 64
            Height = 26
            Caption = '4096'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BOVset1255Ch1: TButton
            Left = 124
            Top = 33
            Width = 107
            Height = 30
            Caption = 'set value'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object BOVchange1255Ch1: TButton
            Left = 10
            Top = 33
            Width = 109
            Height = 30
            Caption = 'change'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object BReset1255Ch1: TButton
            Left = 10
            Top = 72
            Width = 161
            Height = 30
            Caption = 'Reset'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -20
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object BOKchange1255Ch1: TButton
            Left = 10
            Top = 110
            Width = 109
            Height = 30
            Caption = 'change'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
          object BOKset1255Ch1: TButton
            Left = 124
            Top = 110
            Width = 106
            Height = 30
            Caption = 'set code'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object GBMeas1255Ch1: TGroupBox
            Tag = 110
            Left = 352
            Top = 14
            Width = 192
            Height = 129
            Caption = 'Measurement'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
            object LMeas1255Ch1: TLabel
              Left = 47
              Top = 20
              Width = 92
              Height = 20
              Caption = '-0.0008'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -22
              Font.Name = 'Courier'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object BMeas1255Ch1: TButton
              Left = 27
              Top = 42
              Width = 138
              Height = 22
              Caption = 'to measure'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -22
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object STMD1255Ch1: TStaticText
              Left = 31
              Top = 67
              Width = 127
              Height = 23
              Caption = 'Measure Device'
              TabOrder = 1
            end
            object CBMeasET1255Ch1: TComboBox
              Tag = 5
              Left = 10
              Top = 88
              Width = 173
              Height = 27
              Style = csDropDownList
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ItemHeight = 19
              ParentFont = False
              TabOrder = 2
            end
          end
        end
        object GBET1255DACh2: TGroupBox
          Tag = 110
          Left = 17
          Top = 360
          Width = 556
          Height = 147
          Caption = 'Channel 2'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          object LOV1255ch2: TLabel
            Left = 238
            Top = 33
            Width = 83
            Height = 26
            Caption = '-2.547'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LOK1255Ch2: TLabel
            Left = 256
            Top = 110
            Width = 64
            Height = 26
            Caption = '4096'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BOVset1255Ch2: TButton
            Left = 124
            Top = 33
            Width = 107
            Height = 30
            Caption = 'set value'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object BOVchange1255Ch2: TButton
            Left = 10
            Top = 33
            Width = 109
            Height = 30
            Caption = 'change'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object BReset1255Ch2: TButton
            Left = 10
            Top = 72
            Width = 161
            Height = 30
            Caption = 'Reset'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -20
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object BOKchange1255Ch2: TButton
            Left = 10
            Top = 110
            Width = 109
            Height = 30
            Caption = 'change'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
          object BOKset1255Ch2: TButton
            Left = 124
            Top = 110
            Width = 106
            Height = 30
            Caption = 'set code'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object GBMeas1255Ch2: TGroupBox
            Tag = 110
            Left = 352
            Top = 12
            Width = 192
            Height = 128
            Caption = 'Measurement'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
            object LMeas1255Ch2: TLabel
              Left = 47
              Top = 20
              Width = 92
              Height = 20
              Caption = '-0.0008'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -22
              Font.Name = 'Courier'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object BMeas1255Ch2: TButton
              Left = 27
              Top = 42
              Width = 138
              Height = 22
              Caption = 'to measure'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -22
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object STMD1255Ch2: TStaticText
              Left = 31
              Top = 67
              Width = 127
              Height = 23
              Caption = 'Measure Device'
              TabOrder = 1
            end
            object CBMeasET1255Ch2: TComboBox
              Tag = 5
              Left = 10
              Top = 88
              Width = 173
              Height = 27
              Style = csDropDownList
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ItemHeight = 19
              ParentFont = False
              TabOrder = 2
            end
          end
        end
        object GBET1255DACh3: TGroupBox
          Tag = 110
          Left = 624
          Top = 59
          Width = 345
          Height = 152
          Caption = 'Channel 3'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          object LOV1255ch3: TLabel
            Left = 238
            Top = 33
            Width = 83
            Height = 26
            Caption = '-2.547'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LOK1255Ch3: TLabel
            Left = 256
            Top = 110
            Width = 64
            Height = 26
            Caption = '4096'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BOVset1255Ch3: TButton
            Left = 124
            Top = 33
            Width = 107
            Height = 30
            Caption = 'set value'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object BOVchange1255Ch3: TButton
            Left = 10
            Top = 33
            Width = 109
            Height = 30
            Caption = 'change'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object BReset1255Ch3: TButton
            Left = 10
            Top = 72
            Width = 161
            Height = 30
            Caption = 'Reset'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -20
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object BOKchange1255Ch3: TButton
            Left = 10
            Top = 110
            Width = 109
            Height = 30
            Caption = 'change'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
          object BOKset1255Ch3: TButton
            Left = 124
            Top = 110
            Width = 106
            Height = 30
            Caption = 'set code'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
        end
      end
    end
    object TS_Time_Dependence: TTabSheet
      Caption = 'Time'
      ImageIndex = 9
      object LTimeInterval: TLabel
        Left = 13
        Top = 114
        Width = 96
        Height = 18
        Caption = 'Interval (s)'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LTimeDuration: TLabel
        Left = 13
        Top = 187
        Width = 100
        Height = 18
        Caption = 'Duration (s)'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object STTimeMD: TStaticText
        Left = 20
        Top = 24
        Width = 142
        Height = 23
        Caption = 'Measurind Device'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object CBTimeMD: TComboBox
        Tag = 5
        Left = 20
        Top = 58
        Width = 172
        Height = 27
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 19
        ParentFont = False
        TabOrder = 1
      end
      object STTimeInterval: TStaticText
        Left = 13
        Top = 139
        Width = 126
        Height = 30
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object STTimeDuration: TStaticText
        Left = 13
        Top = 212
        Width = 126
        Height = 30
        Caption = '1.34E+01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object GBCSetup: TGroupBox
        Left = 322
        Top = 13
        Width = 681
        Height = 281
        Caption = 'Controller Setup'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object LControlNV: TLabel
          Left = 215
          Top = 81
          Width = 112
          Height = 18
          Caption = 'Needed Value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlCV: TLabel
          Left = 217
          Top = 24
          Width = 112
          Height = 18
          Caption = 'Current Value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlInterval: TLabel
          Left = 547
          Top = 24
          Width = 96
          Height = 18
          Caption = 'Interval (s)'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object SBControlBegin: TSpeedButton
          Left = 271
          Top = 229
          Width = 222
          Height = 34
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'Start Controling'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = SBControlBeginClick
        end
        object LControlCVValue: TLabel
          Left = 215
          Top = 49
          Width = 16
          Height = 26
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlTolerance: TLabel
          Left = 388
          Top = 81
          Width = 79
          Height = 18
          Caption = 'Tolerance'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlKp: TLabel
          Left = 203
          Top = 156
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
        object LControlKi: TLabel
          Left = 353
          Top = 156
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
        object LControlKd: TLabel
          Left = 503
          Top = 156
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
        object LControlCCV: TLabel
          Left = 12
          Top = 211
          Width = 176
          Height = 18
          Caption = 'Current Control Value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlCCValue: TLabel
          Left = 16
          Top = 235
          Width = 16
          Height = 26
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LControlWatchDog: TLabel
          Left = 200
          Top = 48
          Width = 11
          Height = 16
          Caption = 'o'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clLime
          Font.Height = -17
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object CBControlCD: TComboBox
          Tag = 5
          Left = 10
          Top = 149
          Width = 173
          Height = 27
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 19
          ParentFont = False
          TabOrder = 0
        end
        object STControl_CD: TStaticText
          Left = 10
          Top = 115
          Width = 117
          Height = 23
          Caption = 'Driving Device'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object CBControlMD: TComboBox
          Tag = 5
          Left = 10
          Top = 57
          Width = 173
          Height = 27
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 19
          ParentFont = False
          TabOrder = 2
        end
        object STControl_MD: TStaticText
          Left = 10
          Top = 23
          Width = 142
          Height = 23
          Caption = 'Measurind Device'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object STControlNV: TStaticText
          Left = 215
          Top = 106
          Width = 126
          Height = 30
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STControlKi: TStaticText
          Left = 353
          Top = 180
          Width = 126
          Height = 30
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object STControlKp: TStaticText
          Left = 203
          Top = 180
          Width = 126
          Height = 30
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object STControlInterval: TStaticText
          Left = 547
          Top = 68
          Width = 126
          Height = 30
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object STControlKd: TStaticText
          Left = 503
          Top = 180
          Width = 126
          Height = 30
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
        object BControlReset: TButton
          Left = 534
          Top = 230
          Width = 98
          Height = 33
          Caption = 'Reset'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
          OnClick = BControlResetClick
        end
        object STControlTolerance: TStaticText
          Left = 375
          Top = 105
          Width = 104
          Height = 26
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 10
        end
      end
      object STTimeMD2: TStaticText
        Left = 13
        Top = 282
        Width = 206
        Height = 23
        Caption = 'Second Measurind Device'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
      object CBTimeMD2: TComboBox
        Tag = 5
        Left = 13
        Top = 316
        Width = 171
        Height = 27
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 19
        ParentFont = False
        TabOrder = 6
      end
      object CBFvsS: TCheckBox
        Left = 13
        Top = 367
        Width = 171
        Height = 17
        Caption = 'First vs Second '
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        OnClick = CBFvsSClick
      end
      object GBIscVoc: TGroupBox
        Left = 322
        Top = 302
        Width = 536
        Height = 218
        Caption = 'Isc Voc vs time'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        object LIscResult: TLabel
          Left = 263
          Top = 44
          Width = 92
          Height = 20
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LVocResult: TLabel
          Left = 263
          Top = 93
          Width = 92
          Height = 20
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LIscVocPin: TLabel
          Left = 16
          Top = 137
          Width = 353
          Height = 42
          AutoSize = False
          Caption = 'LV721APin'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object CBVocMD: TComboBox
          Tag = 5
          Left = 84
          Top = 93
          Width = 174
          Height = 27
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 19
          ParentFont = False
          TabOrder = 0
        end
        object STResultIsc: TStaticText
          Left = 299
          Top = 16
          Width = 54
          Height = 23
          Caption = 'Result'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object CBIscMD: TComboBox
          Tag = 5
          Left = 84
          Top = 44
          Width = 174
          Height = 27
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 19
          ParentFont = False
          TabOrder = 2
        end
        object STControlIsc: TStaticText
          Left = 140
          Top = 16
          Width = 56
          Height = 23
          Caption = 'Device'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object STIsc: TStaticText
          Left = 16
          Top = 44
          Width = 55
          Height = 30
          Caption = 'Isc'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STVoc: TStaticText
          Left = 16
          Top = 93
          Width = 55
          Height = 30
          Caption = 'Voc'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object BIscMeasure: TButton
          Left = 408
          Top = 44
          Width = 116
          Height = 21
          Caption = 'to measure'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object BVocMeasure: TButton
          Left = 408
          Top = 92
          Width = 116
          Height = 22
          Caption = 'to measure'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object CBIscVocPin: TComboBox
          Tag = 1
          Left = 16
          Top = 169
          Width = 123
          Height = 41
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 33
          ParentFont = False
          TabOrder = 8
        end
        object BIscVocPin: TButton
          Left = 153
          Top = 178
          Width = 150
          Height = 30
          Caption = 'set control'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
        end
        object BIscVocPinChange: TButton
          Left = 401
          Top = 146
          Width = 112
          Height = 48
          Caption = 'Ups'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 10
        end
        object CBLEDAuto: TCheckBox
          Left = 240
          Top = 144
          Width = 145
          Height = 17
          Caption = 'LED auto on'
          TabOrder = 11
        end
      end
    end
    object TS_D30_06: TTabSheet
      Caption = 'D30_06'
      ImageIndex = 10
      object LD30PinC: TLabel
        Left = 25
        Top = 246
        Width = 314
        Height = 42
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object LD30PinG: TLabel
        Left = 25
        Top = 335
        Width = 314
        Height = 42
        AutoSize = False
        Caption = 'LV721APin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object LOVD30: TLabel
        Left = 573
        Top = 68
        Width = 99
        Height = 26
        Caption = '-0.0008'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LOKD30: TLabel
        Left = 573
        Top = 188
        Width = 91
        Height = 26
        Caption = '-65000'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LCodeRangeD30: TLabel
        Left = 439
        Top = 272
        Width = 304
        Height = 25
        Caption = 'Code: -16383 ... 0 ... 16383'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -20
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LValueRangeD30: TLabel
        Left = 500
        Top = 42
        Width = 192
        Height = 25
        Caption = 'Value: -6.5 ... 6.5'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -20
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RGD30: TRadioGroup
        Left = 21
        Top = 31
        Width = 367
        Height = 106
        Caption = 'Output Value'
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'Voltage'
          'Current')
        ParentFont = False
        TabOrder = 0
      end
      object CBD30: TComboBox
        Tag = 1
        Left = 21
        Top = 177
        Width = 120
        Height = 41
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 33
        ParentFont = False
        TabOrder = 1
      end
      object BD30SetC: TButton
        Left = 21
        Top = 297
        Width = 260
        Height = 31
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object BD30SetG: TButton
        Left = 21
        Top = 384
        Width = 260
        Height = 31
        Caption = 'set control'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object GBMeasD30: TGroupBox
        Tag = 110
        Left = 800
        Top = 54
        Width = 200
        Height = 217
        Caption = 'Measurement'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object LMeasD30: TLabel
          Left = 44
          Top = 20
          Width = 92
          Height = 20
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object BMeasD30: TButton
          Left = 31
          Top = 51
          Width = 138
          Height = 30
          Caption = 'to measure'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object STMDD30: TStaticText
          Left = 35
          Top = 118
          Width = 127
          Height = 23
          Caption = 'Measure Device'
          TabOrder = 1
        end
        object CBMeasD30: TComboBox
          Tag = 5
          Left = 13
          Top = 153
          Width = 173
          Height = 27
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 19
          ParentFont = False
          TabOrder = 2
        end
      end
      object STOVD30: TStaticText
        Left = 446
        Top = 75
        Width = 113
        Height = 23
        Caption = 'Output Value:'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
      object BOVchangeD30: TButton
        Left = 456
        Top = 103
        Width = 109
        Height = 30
        Caption = 'change'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
      end
      object BOVsetD30: TButton
        Left = 603
        Top = 103
        Width = 108
        Height = 30
        Caption = 'set value'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
      end
      object BD30Reset: TButton
        Left = 456
        Top = 145
        Width = 163
        Height = 42
        Caption = 'Reset'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
      end
      object STOKD30: TStaticText
        Left = 446
        Top = 195
        Width = 111
        Height = 23
        Caption = 'Output Code:'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
      end
      object BOKchangeD30: TButton
        Left = 456
        Top = 225
        Width = 109
        Height = 30
        Caption = 'change'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
      end
      object BOKsetD30: TButton
        Left = 605
        Top = 225
        Width = 106
        Height = 30
        Caption = 'set code'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 11
      end
    end
  end
  object BBClose: TBitBtn
    Left = 764
    Top = 625
    Width = 98
    Height = 33
    TabOrder = 1
    Kind = bkClose
  end
  object BConnect: TButton
    Left = 201
    Top = 625
    Width = 98
    Height = 33
    Caption = 'BConnect'
    TabOrder = 2
    OnClick = BConnectClick
  end
  object BParamReceive: TButton
    Left = 386
    Top = 625
    Width = 98
    Height = 33
    Caption = 'Receive pin numbers'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
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
    Top = 608
  end
  object Time: TTimer
    Interval = 3000
    Left = 1000
    Top = 624
  end
  object ComDPacket: TComDataPacket
    OnPacket = ComDPacketPacket
    Left = 944
    Top = 608
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.dat'
    Filter = 'data files (*.dat)|*.dat|all files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoValidate, ofPathMustExist, ofShareAware, ofNoTestFileCreate, ofNoNetworkButton, ofNoLongNames, ofNoDereferenceLinks, ofEnableSizing, ofDontAddToRecent]
    OptionsEx = [ofExNoPlacesBar]
    Left = 912
    Top = 608
  end
  object OpenDialog: TOpenDialog
    Left = 1008
    Top = 600
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
    Left = 876
    Top = 612
  end
  object DependTimer: TTimer
    Enabled = False
    Interval = 5000
    Left = 972
    Top = 640
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
    Left = 724
    Top = 612
  end
  object TermostatWatchDog: TTimer
    Enabled = False
    OnTimer = TermostatWatchDogTimer
    Left = 512
    Top = 568
  end
  object ControlWatchDog: TTimer
    Enabled = False
    OnTimer = ControlWatchDogTimer
    Left = 592
    Top = 560
  end
end
