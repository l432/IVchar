object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 427
  ClientWidth = 545
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 545
    Height = 75
    Bands = <
      item
        Control = Button3
        HorizontalOnly = True
        ImageIndex = -1
        Width = 541
      end
      item
        Control = Button2
        ImageIndex = -1
        Width = 541
      end
      item
        Control = Button1
        ImageIndex = -1
        Width = 541
      end>
    object Button3: TButton
      Left = 9
      Top = 0
      Width = 528
      Height = 25
      Caption = 'Refresh'
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button2: TButton
      Left = 9
      Top = 27
      Width = 528
      Height = 25
      Caption = 'Web'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 9
      Top = 54
      Width = 528
      Height = 25
      Caption = 'Button1'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object EmbeddedWB1: TEmbeddedWB
    Left = 0
    Top = 75
    Width = 545
    Height = 352
    Align = alClient
    TabOrder = 1
    About = ' Embedded Web Browser from: http://bsalsa.com/'
    DownloadOptions = [DownloadImages, DownloadVideos, DownloadBGSounds]
    MessagesBoxes.InternalErrMsg = False
    UserInterfaceOptions = []
    PrintOptions.HTMLHeader.Strings = (
      '<HTML></HTML>')
    PrintOptions.Orientation = poPortrait
    UserAgent = ' Embedded Web Browser from: http://bsalsa.com/'
    ExplicitLeft = 66
    ExplicitTop = 96
    ExplicitWidth = 345
    ExplicitHeight = 173
    ControlData = {
      4C00000054380000612400000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object IdTelnet1: TIdTelnet
    OnDataAvailable = IdTelnet1DataAvailable
    Terminal = 'kt2450'
    Left = 392
    Top = 326
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 440
    Top = 324
  end
end
