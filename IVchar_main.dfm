object IVchar: TIVchar
  Left = 0
  Top = 0
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
        GroupIndex = 1
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
        object RGV721_I: TRadioGroup
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
    Left = 472
    Top = 40
  end
end
