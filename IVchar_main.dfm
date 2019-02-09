object IVchar: TIVchar
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'IVchar'
  ClientHeight = 702
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
    Top = 664
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
    Height = 649
    ActivePage = TS_Setting
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
        Top = 306
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
          ItemHeight = 0
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
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
      object PV721APinG: TPanel
        Left = 554
        Top = 458
        Width = 415
        Height = 42
        Cursor = crHandPoint
        BevelOuter = bvLowered
        Caption = 'Gate Pin is 26'
        Color = clSilver
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHotLight
        Font.Height = -22
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
      end
      object PV721APin: TPanel
        Left = 554
        Top = 398
        Width = 415
        Height = 41
        Cursor = crHandPoint
        BevelOuter = bvLowered
        Caption = 'Gate Pin is 26'
        Color = clSilver
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHotLight
        Font.Height = -22
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object PanelV721_I: TPanel
        Left = 0
        Top = 0
        Width = 1020
        Height = 263
        Align = alTop
        ParentBackground = False
        TabOrder = 0
        ExplicitWidth = 1017
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
          Top = 204
          Width = 127
          Height = 43
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
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
          TabOrder = 1
        end
        object BV721IMeas: TButton
          Left = 562
          Top = 127
          Width = 127
          Height = 51
          Caption = 'measure'
          TabOrder = 2
        end
        object PV721IPin: TPanel
          Left = 732
          Top = 129
          Width = 270
          Height = 42
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 3
        end
        object PV721IPinG: TPanel
          Left = 732
          Top = 204
          Width = 270
          Height = 42
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 4
        end
      end
      object PanelV721_II: TPanel
        Left = 0
        Top = 314
        Width = 1020
        Height = 263
        Align = alBottom
        TabOrder = 1
        ExplicitTop = 307
        ExplicitWidth = 1017
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
          TabOrder = 1
        end
        object BV721IIMeas: TButton
          Left = 327
          Top = 126
          Width = 127
          Height = 51
          Caption = 'measure'
          TabOrder = 2
        end
        object PV721IIPin: TPanel
          Left = 17
          Top = 132
          Width = 277
          Height = 42
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 3
        end
        object PV721IIPinG: TPanel
          Left = 17
          Top = 201
          Width = 277
          Height = 42
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 4
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
          ItemHeight = 0
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
            ItemHeight = 0
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
        ItemHeight = 0
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
          ItemHeight = 0
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
            ItemHeight = 0
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
      Caption = 'DACR-2R/D30_06'
      ImageIndex = 5
      object GBCalibrR2R: TGroupBox
        Left = 299
        Top = 72
        Width = 291
        Height = 337
        Caption = 'Calibration'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
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
          Left = 30
          Top = 275
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
      object GBR2R: TGroupBox
        Left = 4
        Top = 4
        Width = 288
        Height = 405
        Caption = 'DAC R-2R'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -28
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object LCodeRangeDACR2R: TLabel
          Left = 7
          Top = 179
          Width = 146
          Height = 20
          Caption = '-65535...65535'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LOKDACR2R: TLabel
          Left = 29
          Top = 205
          Width = 107
          Height = 19
          Caption = 'Output Code:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LOVDACR2R: TLabel
          Left = 13
          Top = 76
          Width = 109
          Height = 19
          Caption = 'Output Value:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LValueRangeDACR2R: TLabel
          Left = 20
          Top = 101
          Width = 98
          Height = 20
          Caption = '-6.6 ... 6.6'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object PDACR2RPinC: TPanel
          Left = 7
          Top = 26
          Width = 266
          Height = 42
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object BDACR2RReset: TButton
          Left = 7
          Top = 133
          Width = 137
          Height = 37
          Caption = 'Reset'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object BOKsetDACR2R: TButton
          Left = 163
          Top = 163
          Width = 108
          Height = 31
          Caption = 'set code'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object BOVsetDACR2R: TButton
          Left = 163
          Top = 114
          Width = 108
          Height = 30
          Caption = 'set value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object STOKDACR2R: TStaticText
          Left = 180
          Top = 203
          Width = 95
          Height = 30
          Caption = '-65000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STOVDACR2R: TStaticText
          Left = 163
          Top = 72
          Width = 103
          Height = 30
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object GBMeasR2R: TGroupBox
          Tag = 110
          Left = 7
          Top = 248
          Width = 274
          Height = 139
          Caption = 'Measurement'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          object LMeasR2R: TLabel
            Left = 169
            Top = 25
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
            Left = 12
            Top = 21
            Width = 137
            Height = 31
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
            Left = 31
            Top = 64
            Width = 127
            Height = 23
            Caption = 'Measure Device'
            TabOrder = 1
          end
          object CBMeasDACR2R: TComboBox
            Tag = 5
            Left = 33
            Top = 93
            Width = 174
            Height = 27
            Style = csDropDownList
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ItemHeight = 0
            ParentFont = False
            TabOrder = 2
          end
        end
      end
      object GBD3006: TGroupBox
        Left = 620
        Top = 0
        Width = 382
        Height = 493
        Caption = 'D30_06'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -28
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object LCodeRangeD30: TLabel
          Left = 67
          Top = 301
          Width = 218
          Height = 20
          Caption = 'Code: -16383 ... 16383'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LValueRangeD30: TLabel
          Left = 81
          Top = 143
          Width = 164
          Height = 20
          Caption = 'Value: -6.5 ... 6.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LOVD30: TLabel
          Left = 20
          Top = 174
          Width = 109
          Height = 19
          Caption = 'Output Value:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LOKD30: TLabel
          Left = 20
          Top = 265
          Width = 107
          Height = 19
          Caption = 'Output Code:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object GBMeasD30: TGroupBox
          Tag = 110
          Left = 69
          Top = 362
          Width = 253
          Height = 110
          Caption = 'Measurement'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object LMeasD30: TLabel
            Left = 149
            Top = 34
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
            Left = 4
            Top = 30
            Width = 137
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
            Left = 14
            Top = 76
            Width = 56
            Height = 23
            Caption = 'Device'
            TabOrder = 1
          end
          object CBMeasD30: TComboBox
            Tag = 5
            Left = 84
            Top = 68
            Width = 159
            Height = 27
            Style = csDropDownList
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ItemHeight = 0
            ParentFont = False
            TabOrder = 2
          end
        end
        object BD30Reset: TButton
          Left = 31
          Top = 209
          Width = 326
          Height = 42
          Caption = 'Reset'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object BOKsetD30: TButton
          Left = 262
          Top = 262
          Width = 105
          Height = 30
          Caption = 'set code'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object BOVsetD30: TButton
          Left = 262
          Top = 170
          Width = 108
          Height = 30
          Caption = 'set value'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object PD30PinC: TPanel
          Left = 16
          Top = 37
          Width = 208
          Height = 41
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 4
        end
        object PD30PinG: TPanel
          Left = 16
          Top = 88
          Width = 208
          Height = 41
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 5
        end
        object RGD30: TRadioGroup
          Left = 231
          Top = 12
          Width = 142
          Height = 123
          Caption = 'Mode'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
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
          Left = 145
          Top = 170
          Width = 103
          Height = 30
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object STOKD30: TStaticText
          Left = 149
          Top = 262
          Width = 95
          Height = 30
          Caption = '-65000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
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
          Left = 14
          Top = 52
          Width = 97
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
        Height = 193
        Caption = 'Device Selection'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        object LDBtime: TLabel
          Left = 10
          Top = 115
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
        object STDBtime: TStaticText
          Left = 65
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
        Left = 243
        Top = 145
        Width = 242
        Height = 76
        Caption = 'DS18B20,  OneWire'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clOlive
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object PDS18BPin: TPanel
          Left = 14
          Top = 25
          Width = 207
          Height = 42
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
      end
      object CBTD: TComboBox
        Tag = 5
        Left = 18
        Top = 84
        Width = 173
        Height = 27
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 0
        ParentFont = False
        TabOrder = 1
      end
      object STTD: TStaticText
        Left = 18
        Top = 50
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
        Left = 243
        Top = 4
        Width = 242
        Height = 120
        Caption = 'ThermoCouple'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clOlive
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
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
          ItemHeight = 0
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
        Left = 26
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
          Left = 190
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
          Left = 194
          Top = 116
          Width = 171
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
          Width = 29
          Height = 25
          Caption = 'Kp'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatKi: TLabel
          Left = 14
          Top = 150
          Width = 22
          Height = 25
          Caption = 'Ki'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LTermostatKd: TLabel
          Left = 14
          Top = 187
          Width = 29
          Height = 25
          Caption = 'Kd'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -20
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
          Left = 388
          Top = 124
          Width = 174
          Height = 27
          Style = csDropDownList
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 0
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
          Left = 190
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
          Top = 71
          Width = 112
          Height = 29
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
      end
      object GBTMP102: TGroupBox
        Left = 510
        Top = 7
        Width = 220
        Height = 75
        Caption = 'TMP102   I2C, 3.3V'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clOlive
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        object PTMP102Pin: TPanel
          Left = 7
          Top = 25
          Width = 206
          Height = 42
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBHTU21: TGroupBox
        Left = 510
        Top = 90
        Width = 220
        Height = 75
        Caption = 'HTU21D,  I2C, 3.3V'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clOlive
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        object PHTU21: TPanel
          Left = 7
          Top = 25
          Width = 206
          Height = 42
          BevelOuter = bvLowered
          Caption = 'Adress is $40'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBMLX615: TGroupBox
        Left = 782
        Top = 7
        Width = 220
        Height = 176
        Caption = 'MLX90615,  I2C, 3.3V'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clOlive
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        object PMLX615: TPanel
          Left = 7
          Top = 25
          Width = 206
          Height = 42
          BevelOuter = bvLowered
          Caption = 'Adress is $5B'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object GBMLX615_GC: TGroupBox
          Left = 3
          Top = 68
          Width = 214
          Height = 75
          Caption = 'Gray Coefficient'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -20
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object STMLX615_GC: TStaticText
            Left = 59
            Top = 20
            Width = 95
            Height = 29
            Caption = '1.00000'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clMaroon
            Font.Height = -20
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            ShowAccelChar = False
            TabOrder = 0
          end
          object BMLX615_GCread: TButton
            Left = 10
            Top = 44
            Width = 76
            Height = 25
            Caption = 'Read'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object BMLX615_GCwrite: TButton
            Left = 128
            Top = 44
            Width = 75
            Height = 25
            Caption = 'Write'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
        end
        object BMLX615_Calib: TButton
          Left = 16
          Top = 146
          Width = 185
          Height = 25
          Caption = 'Calibrate'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
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
          Font.Color = clMaroon
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object LOV1255ch0: TLabel
            Left = 124
            Top = 37
            Width = 109
            Height = 19
            Caption = 'Output Value:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LOK1255Ch0: TLabel
            Left = 124
            Top = 114
            Width = 107
            Height = 19
            Caption = 'Output Code:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BOVset1255Ch0: TButton
            Left = 10
            Top = 33
            Width = 108
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
            TabOrder = 1
          end
          object BOKset1255Ch0: TButton
            Left = 10
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
            TabOrder = 2
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
            TabOrder = 3
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
              ItemHeight = 0
              ParentFont = False
              TabOrder = 2
            end
          end
          object STOV1255ch0: TStaticText
            Left = 246
            Top = 34
            Width = 103
            Height = 30
            Caption = '-0.0008'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object STOK1255Ch0: TStaticText
            Left = 250
            Top = 111
            Width = 95
            Height = 30
            Caption = '-65000'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
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
          Font.Color = clMaroon
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 2
          object LOV1255ch1: TLabel
            Left = 124
            Top = 37
            Width = 109
            Height = 19
            Caption = 'Output Value:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LOK1255Ch1: TLabel
            Left = 124
            Top = 114
            Width = 107
            Height = 19
            Caption = 'Output Code:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BOVset1255Ch1: TButton
            Left = 10
            Top = 33
            Width = 108
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
            TabOrder = 1
          end
          object BOKset1255Ch1: TButton
            Left = 10
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
            TabOrder = 2
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
            TabOrder = 3
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
              ItemHeight = 0
              ParentFont = False
              TabOrder = 2
            end
          end
          object STOV1255ch1: TStaticText
            Left = 246
            Top = 34
            Width = 103
            Height = 30
            Caption = '-0.0008'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object STOK1255Ch1: TStaticText
            Left = 250
            Top = 111
            Width = 95
            Height = 30
            Caption = '-65000'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
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
          Font.Color = clMaroon
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          object LOV1255ch2: TLabel
            Left = 124
            Top = 37
            Width = 109
            Height = 19
            Caption = 'Output Value:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LOK1255Ch2: TLabel
            Left = 124
            Top = 114
            Width = 107
            Height = 19
            Caption = 'Output Code:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BOVset1255Ch2: TButton
            Left = 10
            Top = 33
            Width = 108
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
            TabOrder = 1
          end
          object BOKset1255Ch2: TButton
            Left = 10
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
            TabOrder = 2
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
            TabOrder = 3
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
              ItemHeight = 0
              ParentFont = False
              TabOrder = 2
            end
          end
          object STOV1255ch2: TStaticText
            Left = 246
            Top = 34
            Width = 103
            Height = 30
            Caption = '-0.0008'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object STOK1255Ch2: TStaticText
            Left = 250
            Top = 111
            Width = 95
            Height = 30
            Caption = '-65000'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
          end
        end
        object GBET1255DACh3: TGroupBox
          Tag = 110
          Left = 624
          Top = 59
          Width = 350
          Height = 152
          Caption = 'Channel 3'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          object LOV1255ch3: TLabel
            Left = 124
            Top = 37
            Width = 109
            Height = 19
            Caption = 'Output Value:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LOK1255Ch3: TLabel
            Left = 124
            Top = 114
            Width = 107
            Height = 19
            Caption = 'Output Code:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BOVset1255Ch3: TButton
            Left = 10
            Top = 33
            Width = 108
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
            TabOrder = 1
          end
          object BOKset1255Ch3: TButton
            Left = 10
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
            TabOrder = 2
          end
          object STOV1255ch3: TStaticText
            Left = 243
            Top = 34
            Width = 103
            Height = 30
            Caption = '-0.0008'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
          object STOK1255Ch3: TStaticText
            Left = 250
            Top = 111
            Width = 95
            Height = 30
            Caption = '-65000'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -22
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
        end
      end
    end
    object TS_ET1255ADC: TTabSheet
      Caption = 'ET1255_ADC'
      ImageIndex = 11
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object LET1255I: TLabel
        Left = 5
        Top = 378
        Width = 374
        Height = 68
        AutoSize = False
        Caption = '  ERROR'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -55
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object LET1255U: TLabel
        Left = 382
        Top = 378
        Width = 98
        Height = 68
        AutoSize = False
        Caption = 'a'
        Color = clInfoText
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -72
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object SBET1255Auto: TSpeedButton
        Left = 288
        Top = 467
        Width = 145
        Height = 43
        AllowAllUp = True
        GroupIndex = 2
        Caption = 'AUTO'
      end
      object SBGenerator: TSpeedButton
        Left = 693
        Top = 523
        Width = 145
        Height = 43
        AllowAllUp = True
        GroupIndex = 2
        Caption = 'ggg'
        OnClick = SBGeneratorClick
      end
      object ChET1255: TChart
        Left = 0
        Top = 0
        Width = 721
        Height = 336
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
        Left = 745
        Top = 207
        Width = 268
        Height = 130
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
        TabOrder = 1
      end
      object RGET1255Range: TRadioGroup
        Left = 745
        Top = 4
        Width = 268
        Height = 195
        Caption = 'Range'
        Color = clSkyBlue
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -30
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
        Left = 4
        Top = 467
        Width = 207
        Height = 43
        Caption = 'measurement'
        TabOrder = 3
      end
      object CBET1255_SM: TCheckBox
        Left = 518
        Top = 345
        Width = 226
        Height = 73
        Caption = 'Serial Measurement'
        TabOrder = 4
        WordWrap = True
      end
      object SEET1255_MN: TSpinEdit
        Left = 518
        Top = 471
        Width = 80
        Height = 30
        MaxValue = 0
        MinValue = 0
        TabOrder = 5
        Value = 0
      end
      object STET1255_4096: TStaticText
        Left = 605
        Top = 479
        Width = 118
        Height = 36
        Caption = 'x 4096'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -33
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
      end
      object STET1255_MN: TStaticText
        Left = 518
        Top = 441
        Width = 228
        Height = 30
        Caption = 'Measurement Number'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
      end
      object SEET1255_Gain: TSpinEdit
        Left = 900
        Top = 407
        Width = 74
        Height = 30
        MaxValue = 0
        MinValue = 0
        TabOrder = 8
        Value = 0
      end
      object STET122_Gain: TStaticText
        Left = 829
        Top = 416
        Width = 51
        Height = 30
        Caption = 'Gain'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
      end
      object BET1255_show_save: TButton
        Left = 5
        Top = 343
        Width = 117
        Height = 28
        Caption = 'save'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
        OnClick = BET1255_show_saveClick
      end
      object CBET1255_ASer: TCheckBox
        Left = 752
        Top = 345
        Width = 222
        Height = 54
        Caption = 'Average Serial'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 11
      end
      object CBET1255_AG: TCheckBox
        Left = 829
        Top = 454
        Width = 149
        Height = 53
        Caption = 'Auto Gain'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 12
      end
    end
    object TS_Time_Dependence: TTabSheet
      Caption = 'Time'
      ImageIndex = 9
      object LTimeInterval: TLabel
        Left = 13
        Top = 85
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
        Top = 144
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
        Top = 13
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
        Top = 39
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
        Top = 105
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
        Top = 170
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
          Left = 214
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
          Width = 66
          Height = 36
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
          Left = 214
          Top = 48
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
          Top = 58
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
          TabOrder = 3
        end
        object STControlNV: TStaticText
          Left = 214
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
          Width = 112
          Height = 29
          Caption = '1.34E+01'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 10
        end
      end
      object STTimeMD2: TStaticText
        Left = 13
        Top = 209
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
        Top = 235
        Width = 145
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
        Left = 196
        Top = 226
        Width = 118
        Height = 51
        Caption = 'First vs Second '
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        WordWrap = True
        OnClick = CBFvsSClick
      end
      object GBIscVoc: TGroupBox
        Left = 4
        Top = 302
        Width = 850
        Height = 264
        Caption = 'Isc Voc vs time'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        object LIscResult: TLabel
          Left = 132
          Top = 157
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
          Left = 131
          Top = 237
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
        object CBVocMD: TComboBox
          Tag = 5
          Left = 73
          Top = 197
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
        object CBIscMD: TComboBox
          Tag = 5
          Left = 75
          Top = 118
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
        object STControlIsc: TStaticText
          Left = 131
          Top = 89
          Width = 65
          Height = 23
          Caption = 'Devices'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object STIsc: TStaticText
          Left = 7
          Top = 118
          Width = 55
          Height = 30
          Caption = 'Isc'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object STVoc: TStaticText
          Left = 5
          Top = 197
          Width = 55
          Height = 30
          Caption = 'Voc'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object BIscMeasure: TButton
          Left = 8
          Top = 157
          Width = 116
          Height = 21
          Caption = 'to measure'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object BVocMeasure: TButton
          Left = 7
          Top = 237
          Width = 116
          Height = 22
          Caption = 'to measure'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object GBLEDCon: TGroupBox
          Left = 471
          Top = 26
          Width = 369
          Height = 205
          Caption = 'LED control'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Courier'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
          object LLED_onValue: TLabel
            Left = 21
            Top = 145
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
          object CBLEDAuto: TCheckBox
            Tag = 7
            Left = 21
            Top = 17
            Width = 116
            Height = 38
            Caption = 'auto on'
            TabOrder = 0
            WordWrap = True
          end
          object STLED_on_CD: TStaticText
            Left = 21
            Top = 63
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
          object CBLED_onCD: TComboBox
            Tag = 5
            Left = 21
            Top = 97
            Width = 127
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
          object STLED_onValue: TStaticText
            Left = 25
            Top = 170
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
          object CBLEDOpenAuto: TCheckBox
            Tag = 7
            Left = 209
            Top = 20
            Width = 138
            Height = 27
            Caption = 'auto open'
            TabOrder = 4
            WordWrap = True
          end
          object BLEDOpenPinChange: TButton
            Left = 199
            Top = 63
            Width = 155
            Height = 40
            Caption = 'Ups'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
          end
          object PLEDOpenPin: TPanel
            Left = 203
            Top = 120
            Width = 154
            Height = 42
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
            TabOrder = 6
          end
        end
        object BIscVocPinChange: TButton
          Left = 260
          Top = 133
          Width = 203
          Height = 54
          Caption = 'change to open circuit'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
          WordWrap = True
        end
        object PIscVocPin: TPanel
          Left = 260
          Top = 203
          Width = 203
          Height = 42
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
        object RGIscVocMode: TRadioGroup
          Left = 44
          Top = 29
          Width = 386
          Height = 52
          Caption = 'measurement mode'
          Columns = 2
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Items.Strings = (
            'Voc and Isc only'
            'Fast IV charact')
          ParentFont = False
          TabOrder = 10
          OnClick = RGIscVocModeClick
        end
      end
    end
    object TS_D30_06: TTabSheet
      Caption = 'AD9833'
      ImageIndex = 10
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object LFreqRangeAD9866: TLabel
        Left = 4
        Top = 65
        Width = 226
        Height = 25
        Caption = 'Freq: 0...12 500 000'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -20
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LPhaseRangeAD9866: TLabel
        Left = 4
        Top = 97
        Width = 159
        Height = 25
        Caption = 'Phase: 0...360'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -20
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SBAD9833Stop: TSpeedButton
        Left = 175
        Top = 290
        Width = 224
        Height = 43
        Caption = 'Stop'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SBAD9833GenCh1: TSpeedButton
        Left = 327
        Top = 239
        Width = 221
        Height = 43
        Caption = 'Generate'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SBAD9833GenCh0: TSpeedButton
        Left = 22
        Top = 239
        Width = 221
        Height = 43
        Caption = 'Generate'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GBAD9866ch0: TGroupBox
        Left = 4
        Top = 128
        Width = 267
        Height = 103
        Caption = 'channel I'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -28
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object L9833PhaseCh0: TLabel
          Left = 9
          Top = 71
          Width = 48
          Height = 19
          Caption = 'Phase'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object L9833FreqCh0: TLabel
          Left = 9
          Top = 34
          Width = 36
          Height = 19
          Caption = 'Freq'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ST9866PhaseCh0: TStaticText
          Left = 157
          Top = 67
          Width = 95
          Height = 30
          Caption = '-65000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object ST9866FreqCh0: TStaticText
          Left = 106
          Top = 30
          Width = 103
          Height = 30
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
      end
      object PAD9833PinC: TPanel
        Left = 4
        Top = 4
        Width = 267
        Height = 42
        Cursor = crHandPoint
        BevelOuter = bvLowered
        Caption = 'Control Pin is 26'
        Color = clSilver
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHotLight
        Font.Height = -22
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
      object GBAD9866ch1: TGroupBox
        Left = 297
        Top = 123
        Width = 267
        Height = 108
        Caption = 'channel II'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -28
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object L9833PhaseCh1: TLabel
          Left = 9
          Top = 71
          Width = 54
          Height = 19
          Caption = 'Phase:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object L9833FreqCh1: TLabel
          Left = 9
          Top = 34
          Width = 36
          Height = 19
          Caption = 'Freq'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ST9866PhaseCh1: TStaticText
          Left = 157
          Top = 67
          Width = 95
          Height = 30
          Caption = '-65000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object ST9866FreqCh1: TStaticText
          Left = 106
          Top = 30
          Width = 103
          Height = 30
          Caption = '-0.0008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
      end
      object RGAD9833Mode: TRadioGroup
        Left = 22
        Top = 356
        Width = 526
        Height = 95
        Caption = 'Mode'
        Columns = 4
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
    end
    object TS_ADC: TTabSheet
      Caption = 'ADC'
      ImageIndex = 12
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Button1: TButton
        Left = 687
        Top = 248
        Width = 98
        Height = 34
        Caption = 'Button1'
        TabOrder = 0
        OnClick = Button1Click
      end
      object GBMCP3424: TGroupBox
        Left = 3
        Top = 3
        Width = 438
        Height = 529
        Caption = 'MCP3424'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -28
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object GBMCP3424_Ch1: TGroupBox
          Left = 1
          Top = 126
          Width = 433
          Height = 98
          Caption = 'Channel 1'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object LMCP3424_Ch1meas: TLabel
            Left = 267
            Top = 27
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
          object BMCP3424_Ch1meas: TButton
            Left = 258
            Top = 63
            Width = 117
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
          object PMCP3424_Ch1bits: TPanel
            Left = 4
            Top = 27
            Width = 207
            Height = 31
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object PMCP3424_Ch1gain: TPanel
            Left = 4
            Top = 61
            Width = 207
            Height = 31
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object GBMCP3424_Ch2: TGroupBox
          Left = 1
          Top = 225
          Width = 433
          Height = 98
          Caption = 'Channel 2'
          Color = clMedGray
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGradientActiveCaption
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 1
          object LMCP3424_Ch2meas: TLabel
            Left = 24
            Top = 27
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
          object BMCP3424_Ch2meas: TButton
            Left = 14
            Top = 63
            Width = 118
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
          object PMCP3424_Ch2bits: TPanel
            Left = 212
            Top = 24
            Width = 206
            Height = 30
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object PMCP3424_Ch2gain: TPanel
            Left = 212
            Top = 60
            Width = 206
            Height = 30
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object GBMCP3424_Ch3: TGroupBox
          Left = 1
          Top = 327
          Width = 433
          Height = 98
          Caption = 'Channel 3'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          object LMCP3424_Ch3meas: TLabel
            Left = 267
            Top = 27
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
          object BMCP3424_Ch3meas: TButton
            Left = 258
            Top = 63
            Width = 117
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
          object PMCP3424_Ch3bits: TPanel
            Left = 4
            Top = 27
            Width = 207
            Height = 31
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object PMCP3424_Ch3gain: TPanel
            Left = 4
            Top = 61
            Width = 207
            Height = 31
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object GBMCP3424_Ch4: TGroupBox
          Left = 1
          Top = 425
          Width = 433
          Height = 98
          Caption = 'Channel 4'
          Color = clMedGray
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGradientActiveCaption
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 3
          object LMCP3424_Ch4meas: TLabel
            Left = 24
            Top = 27
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
          object BMCP3424_Ch4meas: TButton
            Left = 14
            Top = 63
            Width = 118
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
          object PMCP3424_Ch4bits: TPanel
            Left = 212
            Top = 24
            Width = 206
            Height = 30
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object PMCP3424_Ch4gain: TPanel
            Left = 212
            Top = 60
            Width = 206
            Height = 30
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object STMCP3424_1: TStaticText
          Left = 239
          Top = 26
          Width = 192
          Height = 28
          Caption = '-2.048 (dif)...2.048 V'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STMCP3424_2: TStaticText
          Left = 4
          Top = 26
          Width = 92
          Height = 22
          Caption = '12 bit - 1 mV '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object STMCP3424_5: TStaticText
          Left = 4
          Top = 93
          Width = 125
          Height = 22
          Caption = '18 bit - 15.625 uV '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object STMCP3424_3: TStaticText
          Left = 4
          Top = 48
          Width = 112
          Height = 22
          Caption = '14 bit - 0.25 mV '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object STMCP3424_4: TStaticText
          Left = 4
          Top = 71
          Width = 109
          Height = 22
          Caption = '16 bit - 62.5 uV '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
        object PMCP3424Pin: TPanel
          Left = 228
          Top = 76
          Width = 206
          Height = 42
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 9
        end
      end
      object GBads1115: TGroupBox
        Left = 456
        Top = 3
        Width = 567
        Height = 218
        Caption = 'ADS1115'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -28
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object GBads1115_Ch1: TGroupBox
          Left = 282
          Top = 14
          Width = 282
          Height = 98
          Caption = 'Channel 1'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object Lads1115_Ch1meas: TLabel
            Left = 171
            Top = 27
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
          object Bads1115_Ch1meas: TButton
            Left = 160
            Top = 63
            Width = 117
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
          object Pads1115_Ch1dr: TPanel
            Left = 4
            Top = 27
            Width = 150
            Height = 31
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object Pads1115_Ch1gain: TPanel
            Left = 4
            Top = 61
            Width = 150
            Height = 31
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object GBads1115_Ch2: TGroupBox
          Left = 1
          Top = 115
          Width = 280
          Height = 98
          Caption = 'Channel 2'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object Lads1115_Ch2meas: TLabel
            Left = 171
            Top = 27
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
          object Bads1115_Ch2meas: TButton
            Left = 160
            Top = 63
            Width = 119
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
          object Pads1115_Ch2dr: TPanel
            Left = 4
            Top = 24
            Width = 150
            Height = 30
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object Pads1115_Ch2gain: TPanel
            Left = 4
            Top = 60
            Width = 150
            Height = 30
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object GBads1115_Ch3: TGroupBox
          Left = 282
          Top = 115
          Width = 282
          Height = 98
          Caption = 'Channel 3'
          Color = clMedGray
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGradientActiveCaption
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 2
          object Lads1115_Ch3meas: TLabel
            Left = 171
            Top = 27
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
          object Bads1115_Ch3meas: TButton
            Left = 160
            Top = 63
            Width = 117
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
          object Pads1115_Ch3dr: TPanel
            Left = 4
            Top = 27
            Width = 150
            Height = 31
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
          object Pads1115_Ch3gain: TPanel
            Left = 4
            Top = 61
            Width = 150
            Height = 31
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Gate Pin is 26'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clHotLight
            Font.Height = -20
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
        end
        object Pads1115_adr: TPanel
          Left = 18
          Top = 30
          Width = 207
          Height = 42
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 3
        end
      end
      object GBina226: TGroupBox
        Left = 455
        Top = 313
        Width = 566
        Height = 196
        Caption = 'INA226'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -28
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object Lina226_Rsh: TLabel
          Left = 20
          Top = 82
          Width = 81
          Height = 24
          Caption = 'R shunt:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Lina226_TF: TLabel
          Left = 13
          Top = 163
          Width = 120
          Height = 24
          Caption = 'Time factor^'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object GBina226_shunt: TGroupBox
          Left = 209
          Top = 14
          Width = 353
          Height = 88
          Caption = 'Shunt current'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object Lina226_shuntmeas: TLabel
            Left = 163
            Top = 59
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
          object Bina226_shuntmeas: TButton
            Left = 5
            Top = 59
            Width = 132
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
          object Pina226_shunttime: TPanel
            Left = 4
            Top = 24
            Width = 345
            Height = 30
            Cursor = crHandPoint
            BevelOuter = bvLowered
            Caption = 'Conv. time is 1100 us'
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
          object STina226_1: TStaticText
            Left = 292
            Top = 59
            Width = 46
            Height = 22
            Caption = '2.5 uV'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clGreen
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
        end
        object Pina226_adr: TPanel
          Left = 7
          Top = 33
          Width = 177
          Height = 42
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 1
        end
        object Pina226_aver: TPanel
          Left = 7
          Top = 114
          Width = 187
          Height = 42
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = 'Gate Pin is 26'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object STina226_Rsh: TStaticText
          Left = 111
          Top = 80
          Width = 52
          Height = 30
          Caption = '256'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 3
        end
        object GBina226_Bus: TGroupBox
          Left = 209
          Top = 103
          Width = 353
          Height = 88
          Caption = 'Bus Voltage'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBackground
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          object Lina226_busmeas: TLabel
            Left = 163
            Top = 59
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
          object Bina226_busmeas: TButton
            Left = 5
            Top = 59
            Width = 132
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
          object Pina226_bustime: TPanel
            Left = 4
            Top = 24
            Width = 345
            Height = 30
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
          object STina226_2: TStaticText
            Left = 288
            Top = 60
            Width = 57
            Height = 22
            Caption = '1.25 mV'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clGreen
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
        end
        object STina226_TF: TStaticText
          Left = 132
          Top = 160
          Width = 52
          Height = 30
          Caption = '256'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 5
        end
      end
    end
    object TS_GDS: TTabSheet
      Caption = 'GDS-806S'
      ImageIndex = 13
      object GB_GDS_Com: TGroupBox
        Left = 752
        Top = 0
        Width = 269
        Height = 192
        Caption = 'COM parameters'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object LGDSPort: TLabel
          Left = 13
          Top = 16
          Width = 55
          Height = 25
          Caption = 'Port '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ComCBGDS_Port: TComComboBox
          Left = 13
          Top = 42
          Width = 97
          Height = 32
          ComPort = ComPortGDS
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
        object ComCBGDS_Baud: TComComboBox
          Left = 13
          Top = 111
          Width = 97
          Height = 32
          ComPort = ComPortGDS
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
        object ST_GDS_Rate: TStaticText
          Left = 13
          Top = 82
          Width = 118
          Height = 29
          Caption = 'Baud Rate'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object ST_GDS_StopBits: TStaticText
          Left = 157
          Top = 16
          Width = 105
          Height = 29
          Caption = 'Stop Bits'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object ComCBGDS_Stop: TComComboBox
          Left = 157
          Top = 42
          Width = 97
          Height = 32
          ComPort = ComPortGDS
          ComProperty = cpStopBits
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
          TabOrder = 4
        end
        object ST_GDS_Parity: TStaticText
          Left = 157
          Top = 82
          Width = 71
          Height = 29
          Caption = 'Parity'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object ComCBGDS_Parity: TComComboBox
          Left = 157
          Top = 111
          Width = 97
          Height = 32
          ComPort = ComPortGDS
          ComProperty = cpParity
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
          TabOrder = 6
        end
        object B_GDS_Test: TButton
          Left = 13
          Top = 150
          Width = 242
          Height = 33
          Caption = 'B_GDS_SetSet'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
      end
      object GB_GDS_Set: TGroupBox
        Left = 752
        Top = 194
        Width = 269
        Height = 230
        Caption = 'Settings'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        object LGDS_Mode: TLabel
          Left = 13
          Top = 24
          Width = 61
          Height = 19
          Caption = 'Output:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LGDS_RLength: TLabel
          Left = 13
          Top = 50
          Width = 61
          Height = 19
          Caption = 'Output:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LGDS_AveNum: TLabel
          Left = 13
          Top = 76
          Width = 61
          Height = 19
          Caption = 'Output:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object STGDS_Mode: TStaticText
          Left = 81
          Top = 20
          Width = 168
          Height = 31
          Caption = 'Peak detection'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 0
        end
        object B_GDS_SetSet: TButton
          Left = 21
          Top = 105
          Width = 98
          Height = 32
          Caption = 'B_GDS_SetSet'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object B_GDS_SetGet: TButton
          Left = 146
          Top = 105
          Width = 99
          Height = 32
          Caption = 'B_GDS_SetSet'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object B_GDS_SetSav: TButton
          Left = 21
          Top = 145
          Width = 98
          Height = 33
          Caption = 'B_GDS_SetSet'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object B_GDS_SetLoad: TButton
          Left = 146
          Top = 145
          Width = 99
          Height = 33
          Caption = 'B_GDS_SetSet'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object B_GDS_SetAuto: TButton
          Left = 21
          Top = 186
          Width = 98
          Height = 32
          Caption = 'B_GDS_SetSet'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object B_GDS_SetDef: TButton
          Left = 146
          Top = 186
          Width = 99
          Height = 32
          Caption = 'B_GDS_SetSet'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object STGDS_RLength: TStaticText
          Left = 153
          Top = 46
          Width = 100
          Height = 30
          Caption = '125000'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 7
        end
        object STGDS_AveNum: TStaticText
          Left = 165
          Top = 72
          Width = 52
          Height = 30
          Caption = '256'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 8
        end
      end
      object ChGDS: TChart
        Left = 3
        Top = 197
        Width = 744
        Height = 337
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
        Left = 4
        Top = 0
        Width = 290
        Height = 191
        Caption = 'CHANNEL 1'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object LGDS_OffsetCh1: TLabel
          Left = 124
          Top = 157
          Width = 74
          Height = 19
          Caption = 'Offset, V:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clTeal
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LGDS_Ch1: TLabel
          Left = 4
          Top = 18
          Width = 227
          Height = 41
          AutoSize = False
          Caption = '  ERROR'
          Color = clWhite
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LGDSU_Ch1: TLabel
          Left = 231
          Top = 18
          Width = 53
          Height = 41
          AutoSize = False
          Caption = 'a'
          Color = clInfoText
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWhite
          Font.Height = -35
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object SB_GDS_AutoCh1: TSpeedButton
          Left = 180
          Top = 92
          Width = 59
          Height = 24
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clDefault
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object STGDS_OffsetCh1: TStaticText
          Left = 209
          Top = 154
          Width = 77
          Height = 29
          Caption = '-0.008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clTeal
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 0
        end
        object B_GDS_MeasCh1: TButton
          Left = 30
          Top = 92
          Width = 103
          Height = 24
          Caption = 'measure'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object STGDS_MeasCh1: TStaticText
          Left = 30
          Top = 63
          Width = 244
          Height = 29
          Caption = 'Peak-to-peak voltage'
          Color = clBtnFace
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 2
        end
        object CBGDS_DisplayCh1: TCheckBox
          Left = 13
          Top = 165
          Width = 99
          Height = 23
          Caption = 'Display'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object CBGDS_InvertCh1: TCheckBox
          Left = 13
          Top = 146
          Width = 93
          Height = 23
          Caption = 'Invert'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STGDS_ProbCh1: TStaticText
          Left = 124
          Top = 118
          Width = 67
          Height = 30
          Caption = '100x'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 5
        end
        object STGDS_CoupleCh1: TStaticText
          Left = 214
          Top = 118
          Width = 58
          Height = 30
          Caption = 'GRN'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 6
        end
        object STGDS_ScaleCh1: TStaticText
          Left = 13
          Top = 118
          Width = 92
          Height = 30
          Caption = '500mV'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 7
        end
      end
      object GB_GDS_Show: TGroupBox
        Left = 752
        Top = 426
        Width = 269
        Height = 108
        Caption = 'Show'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 4
        object SB_GDS_AutoShow: TSpeedButton
          Left = 187
          Top = 20
          Width = 59
          Height = 28
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clDefault
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object PGGDS_Show: TRadioGroup
          Left = 2
          Top = 52
          Width = 265
          Height = 54
          Margins.Top = 0
          Align = alBottom
          Color = clSkyBlue
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
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
          ExplicitLeft = 3
          ExplicitTop = 51
          ExplicitWidth = 264
        end
        object B_GDS_MeasShow: TButton
          Left = 12
          Top = 20
          Width = 86
          Height = 28
          Caption = 'measure'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
      end
      object B_GDS_Refresh: TButton
        Left = 302
        Top = 12
        Width = 144
        Height = 27
        Caption = 'REFRESH'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
      object B_GDS_Run: TButton
        Left = 302
        Top = 46
        Width = 144
        Height = 27
        Caption = 'RUN'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
      end
      object B_GDS_Stop: TButton
        Left = 302
        Top = 81
        Width = 144
        Height = 28
        Caption = 'STOP'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
      end
      object B_GDS_Unlock: TButton
        Left = 302
        Top = 115
        Width = 144
        Height = 28
        Caption = 'UNLOCK'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
      end
      object STGDS_ScaleGoriz: TStaticText
        Left = 324
        Top = 158
        Width = 105
        Height = 30
        Caption = '100.0us'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBackground
        Font.Height = -22
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
        TabOrder = 9
      end
      object GB_GDS_Ch2: TGroupBox
        Left = 456
        Top = 0
        Width = 291
        Height = 191
        Caption = 'CHANNEL 2'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
        object LGDS_OffsetCh2: TLabel
          Left = 124
          Top = 157
          Width = 53
          Height = 19
          Caption = 'Offset:'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clTeal
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LGDS_Ch2: TLabel
          Left = 4
          Top = 18
          Width = 227
          Height = 41
          AutoSize = False
          Caption = '  ERROR'
          Color = clWhite
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LGDSU_Ch2: TLabel
          Left = 231
          Top = 18
          Width = 53
          Height = 41
          AutoSize = False
          Caption = 'a'
          Color = clInfoText
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWhite
          Font.Height = -35
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object SB_GDS_AutoCh2: TSpeedButton
          Left = 180
          Top = 92
          Width = 59
          Height = 24
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clDefault
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object STGDS_OffsetCh2: TStaticText
          Left = 209
          Top = 154
          Width = 77
          Height = 29
          Caption = '-0.008'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clTeal
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 0
        end
        object B_GDS_MeasCh2: TButton
          Left = 30
          Top = 92
          Width = 103
          Height = 24
          Caption = 'measure'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object STGDS_MeasCh2: TStaticText
          Left = 30
          Top = 63
          Width = 244
          Height = 29
          Caption = 'Peak-to-peak voltage'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clGreen
          Font.Height = -20
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 2
        end
        object CBGDS_DisplayCh2: TCheckBox
          Left = 13
          Top = 165
          Width = 99
          Height = 23
          Caption = 'Display'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object CBGDS_InvertCh2: TCheckBox
          Left = 13
          Top = 146
          Width = 93
          Height = 23
          Caption = 'Invert'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object STGDS_ProbCh2: TStaticText
          Left = 124
          Top = 118
          Width = 67
          Height = 30
          Caption = '100x'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 5
        end
        object STGDS_CoupleCh2: TStaticText
          Left = 214
          Top = 118
          Width = 58
          Height = 30
          Caption = 'GRN'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -22
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
          TabOrder = 6
        end
        object STGDS_ScaleCh2: TStaticText
          Left = 13
          Top = 118
          Width = 92
          Height = 30
          Caption = '500mV'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlue
          Font.Height = -22
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
    Left = 764
    Top = 664
    Width = 98
    Height = 33
    TabOrder = 1
    Kind = bkClose
  end
  object BConnect: TButton
    Left = 201
    Top = 664
    Width = 98
    Height = 33
    Caption = 'BConnect'
    TabOrder = 2
    OnClick = BConnectClick
  end
  object BParamReceive: TButton
    Left = 386
    Top = 664
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
