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
    ActivePage = TS_B7_21A
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
      object Label1: TLabel
        Left = 199
        Top = 105
        Width = 503
        Height = 85
        AutoSize = False
        Caption = 'L'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Edit1: TEdit
        Left = 63
        Top = 188
        Width = 85
        Height = 34
        TabOrder = 0
      end
      object Button1: TButton
        Left = 105
        Top = 251
        Width = 98
        Height = 33
        Caption = 'Button1'
        TabOrder = 1
        OnClick = Button1Click
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
        OnClick = SBV721AAutoClick
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
        Top = 272
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
        OnClick = RGV721A_MMClick
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
        OnClick = RGV721ARangeClick
      end
      object BV721AMeas: TButton
        Left = 554
        Top = 178
        Width = 207
        Height = 43
        Caption = 'measurement'
        TabOrder = 2
        OnClick = BV721AMeasClick
      end
      object CBV721A: TComboBox
        Tag = 1
        Left = 554
        Top = 312
        Width = 121
        Height = 41
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 33
        ParentFont = False
        TabOrder = 3
        Text = 'Pins'
        Items.Strings = (
          '1'
          '2'
          '3')
      end
      object BV721ASet: TButton
        Left = 696
        Top = 312
        Width = 89
        Height = 34
        Caption = 'set'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -28
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = BV721ASetClick
      end
    end
    object TS_B7_21: TTabSheet
      Caption = 'B7_21'
      ImageIndex = 2
      object PanelV721_I: TPanel
        Left = 0
        Top = 0
        Width = 1028
        Height = 268
        Align = alTop
        TabOrder = 0
        object LV721IPin: TLabel
          Left = 731
          Top = 110
          Width = 282
          Height = 68
          AutoSize = False
          Caption = 'LV721APin'
          WordWrap = True
        end
        object LV721I: TLabel
          Left = 344
          Top = 0
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
        object LV721IU: TLabel
          Left = 915
          Top = 0
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
        object SBV721IAuto: TSpeedButton
          Left = 571
          Top = 202
          Width = 127
          Height = 43
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
          OnClick = SBV721AAutoClick
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
          Font.Height = -23
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          Items.Strings = (
            '1')
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          OnClick = RGV721A_MMClick
        end
        object CBV721I: TComboBox
          Tag = 1
          Left = 739
          Top = 184
          Width = 121
          Height = 41
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 33
          ParentFont = False
          TabOrder = 1
          Text = 'Pins'
          Items.Strings = (
            '1'
            '2'
            '3')
        end
        object BV721ISet: TButton
          Left = 880
          Top = 184
          Width = 89
          Height = 34
          Caption = 'set'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = BV721ASetClick
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
          OnClick = RGV721ARangeClick
        end
        object BV721IMeas: TButton
          Left = 571
          Top = 127
          Width = 127
          Height = 51
          Caption = 'measure'
          TabOrder = 4
          OnClick = BV721IMeasClick
        end
      end
      object PanelV721_II: TPanel
        Left = 0
        Top = 268
        Width = 1028
        Height = 268
        Align = alTop
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 1
        object LV721IIPin: TLabel
          Left = 6
          Top = 118
          Width = 307
          Height = 62
          AutoSize = False
          Caption = 'LV721APin'
          WordWrap = True
        end
        object LV721II: TLabel
          Left = 0
          Top = 0
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
        object LV721IIU: TLabel
          Left = 571
          Top = 0
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
        object SBV721IIAuto: TSpeedButton
          Left = 323
          Top = 202
          Width = 127
          Height = 43
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'AUTO'
          OnClick = SBV721AAutoClick
        end
        object RGV721II_MM: TRadioGroup
          Left = 696
          Top = 0
          Width = 326
          Height = 105
          Caption = 'Measure Mode'
          Color = clCream
          Columns = 3
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -23
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          Items.Strings = (
            '1')
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          OnClick = RGV721A_MMClick
        end
        object CBV721II: TComboBox
          Tag = 1
          Left = 6
          Top = 187
          Width = 121
          Height = 41
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 33
          ParentFont = False
          TabOrder = 1
          Text = 'Pins'
          Items.Strings = (
            '1'
            '2'
            '3')
        end
        object BV721IISet: TButton
          Left = 144
          Top = 186
          Width = 89
          Height = 34
          Caption = 'set'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = BV721ASetClick
        end
        object RGV721IIRange: TRadioGroup
          Left = 472
          Top = 111
          Width = 550
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
          OnClick = RGV721ARangeClick
        end
        object BV721IIMeas: TButton
          Left = 323
          Top = 126
          Width = 127
          Height = 51
          Caption = 'measure'
          TabOrder = 4
          OnClick = BV721IIMeasClick
        end
      end
    end
  end
  object BitBtn1: TBitBtn
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
    OnRxChar = ComPort1RxChar
    OnRxBuf = ComPort1RxBuf
    Left = 536
    Top = 40
  end
  object Time: TTimer
    Interval = 3000
    Left = 608
    Top = 8
  end
  object ComDPacket: TComDataPacket
    OnPacket = ComDPacketPacket
    Left = 472
    Top = 40
  end
end
