object IVchar: TIVchar
  Left = 0
  Top = 0
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
    Width = 71
    Height = 19
    Caption = 'ComPort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PC: TPageControl
    Left = 0
    Top = 0
    Width = 792
    Height = 441
    ActivePage = TabSheet1
    Align = alTop
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnChange = PCChange
    object TabSheet1: TTabSheet
      Caption = 'Main'
      object Label1: TLabel
        Left = 152
        Top = 80
        Width = 385
        Height = 65
        AutoSize = False
        Caption = 'L'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Edit1: TEdit
        Left = 48
        Top = 144
        Width = 65
        Height = 31
        TabOrder = 0
      end
      object Button1: TButton
        Left = 80
        Top = 192
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'B721A'
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
        GroupIndex = 1
        Caption = 'AUTO'
        OnClick = SBV721AAutoClick
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
        OnClick = RGV721A_MMClick
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
        OnClick = RGV721ARangeClick
      end
      object BV721AMeas: TButton
        Left = 424
        Top = 136
        Width = 158
        Height = 33
        Caption = 'measurement'
        TabOrder = 2
        OnClick = BV721AMeasClick
      end
    end
  end
  object BitBtn1: TBitBtn
    Left = 488
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
end
