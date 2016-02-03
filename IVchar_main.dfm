object IVchar: TIVchar
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'IVchar'
  ClientHeight = 646
  ClientWidth = 1036
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
    Left = 10
    Top = 603
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
    Width = 1036
    Height = 577
    ActivePage = TS_Main
    Align = alTop
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -28
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnChange = PCChange
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
        Top = 268
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
        Left = 726
        Top = 16
        Width = 291
        Height = 178
        Caption = 'I-V measurements'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object CBForw: TCheckBox
          Left = 16
          Top = 30
          Width = 96
          Height = 17
          Caption = 'Forward'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = CBForwClick
        end
        object CBRev: TCheckBox
          Left = 16
          Top = 60
          Width = 96
          Height = 17
          Caption = 'Reverse'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = CBForwClick
        end
        object BIVStart: TButton
          Left = 167
          Top = 27
          Width = 84
          Height = 27
          Caption = 'Start'
          TabOrder = 2
          OnClick = BIVStartClick
        end
        object BIVStop: TButton
          Tag = 4
          Left = 167
          Top = 72
          Width = 84
          Height = 25
          Caption = 'Stop'
          TabOrder = 3
        end
        object CBSStep: TCheckBox
          Left = 16
          Top = 90
          Width = 113
          Height = 17
          Caption = 'Strict Step'
          TabOrder = 4
        end
        object BIVSave: TButton
          Tag = 4
          Left = 103
          Top = 140
          Width = 84
          Height = 25
          Caption = 'Save'
          TabOrder = 5
        end
        object PBIV: TProgressBar
          Left = 24
          Top = 112
          Width = 224
          Height = 21
          Step = 1
          TabOrder = 6
        end
      end
      object GBAD: TGroupBox
        Left = 726
        Top = 200
        Width = 291
        Height = 137
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
          Top = 31
          Width = 65
          Height = 19
          Caption = 'Voltage:'
        end
        object LADVoltageValue: TLabel
          Left = 105
          Top = 24
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
          Top = 72
          Width = 67
          Height = 19
          Caption = 'Current:'
        end
        object LADCurrentValue: TLabel
          Left = 105
          Top = 64
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
          Top = 112
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
      end
      object GBT: TGroupBox
        Left = 727
        Top = 367
        Width = 290
        Height = 138
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
          Left = 8
          Top = 42
          Width = 186
          Height = 60
          Caption = '298.5'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -58
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
          Width = 86
          Height = 26
          Caption = '300.1'
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
        Font.Height = -87
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
        Width = 1028
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
          Font.Height = -87
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
        Top = 273
        Width = 1028
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
          Font.Height = -87
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
            OnClick = RBTSImitationClick
          end
          object RBMeasMeasChA: TRadioButton
            Tag = 111
            Left = 4
            Top = 114
            Width = 137
            Height = 17
            Caption = 'Measurement'
            TabOrder = 1
            OnClick = RBTSImitationClick
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
            OnClick = RBTSImitationClick
          end
          object RBMeasMeasChB: TRadioButton
            Tag = 111
            Left = 4
            Top = 114
            Width = 137
            Height = 17
            Caption = 'Measurement'
            TabOrder = 1
            OnClick = RBTSImitationClick
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
    object TS_Setting: TTabSheet
      Caption = 'Setting'
      ImageIndex = 4
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
          OnClick = UDFBHighLimitClick
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
          OnClick = UDFBHighLimitClick
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
          OnClick = UDFBHighLimitClick
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
          OnClick = UDFBHighLimitClick
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
      object GBTS: TGroupBox
        Tag = 100
        Left = 585
        Top = 16
        Width = 176
        Height = 145
        Caption = 'Temperature source'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object RBTSImitation: TRadioButton
          Tag = 100
          Left = 16
          Top = 24
          Width = 113
          Height = 17
          Caption = 'Simulation'
          TabOrder = 0
          OnClick = RBTSImitationClick
        end
        object RBTSTermocouple: TRadioButton
          Tag = 101
          Left = 16
          Top = 63
          Width = 137
          Height = 17
          Caption = 'Thermocouple'
          TabOrder = 1
          OnClick = RBTSImitationClick
        end
        object CBTSTC: TComboBox
          Tag = 5
          Left = 16
          Top = 90
          Width = 145
          Height = 27
          Style = csDropDownList
          ItemHeight = 19
          TabOrder = 2
        end
      end
      object GBVS: TGroupBox
        Tag = 110
        Left = 585
        Top = 180
        Width = 176
        Height = 146
        Caption = 'Voltage source'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object RBVSSimulation: TRadioButton
          Tag = 110
          Left = 16
          Top = 24
          Width = 113
          Height = 17
          Caption = 'Simulation'
          TabOrder = 0
          OnClick = RBTSImitationClick
        end
        object RBVSMeasur: TRadioButton
          Tag = 111
          Left = 16
          Top = 63
          Width = 137
          Height = 17
          Caption = 'Measurement'
          TabOrder = 1
          OnClick = RBTSImitationClick
        end
        object CBVSMeas: TComboBox
          Tag = 5
          Left = 16
          Top = 90
          Width = 145
          Height = 27
          Style = csDropDownList
          ItemHeight = 19
          TabOrder = 2
        end
      end
      object GBCS: TGroupBox
        Tag = 120
        Left = 808
        Top = 183
        Width = 177
        Height = 145
        Caption = 'Current source'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object RBCSSimulation: TRadioButton
          Tag = 120
          Left = 16
          Top = 24
          Width = 113
          Height = 17
          Caption = 'Simulation'
          TabOrder = 0
          OnClick = RBTSImitationClick
        end
        object RBCSMeasur: TRadioButton
          Tag = 121
          Left = 16
          Top = 63
          Width = 137
          Height = 17
          Caption = 'Measurement'
          TabOrder = 1
          OnClick = RBTSImitationClick
        end
        object CBCSMeas: TComboBox
          Tag = 5
          Left = 16
          Top = 90
          Width = 145
          Height = 27
          Style = csDropDownList
          ItemHeight = 19
          TabOrder = 2
        end
      end
      object BSaveSetting: TButton
        Left = 840
        Top = 16
        Width = 145
        Height = 32
        Caption = 'Save Setting'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        OnClick = BSaveSettingClick
      end
      object RGInputVoltage: TRadioGroup
        Left = 808
        Top = 72
        Width = 177
        Height = 87
        Caption = 'Input voltage'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Items.Strings = (
          'Simulation'
          'DAC Channel A'
          'DAC Channel B')
        ParentFont = False
        TabOrder = 6
      end
      object RGDO: TRadioGroup
        Left = 22
        Top = 360
        Width = 123
        Height = 97
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
        TabOrder = 7
      end
    end
  end
  object BBClose: TBitBtn
    Left = 766
    Top = 603
    Width = 98
    Height = 33
    TabOrder = 1
    Kind = bkClose
  end
  object BConnect: TButton
    Left = 204
    Top = 603
    Width = 98
    Height = 33
    Caption = 'BConnect'
    TabOrder = 2
    OnClick = BConnectClick
  end
  object BParamReceive: TButton
    Left = 388
    Top = 603
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
    StoredProps = [spBasic]
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
end
