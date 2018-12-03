unit ArduinoDeviceShow;

interface
 uses OlegType,SysUtils,Classes,
      StdCtrls, IniFiles,  ExtCtrls,  ArduinoDevice;

const
  UndefinedPin=255;
  PacketBeginChar=#10;
  PacketEndChar=#255;


  PinNames:array[0..3]of string=
   ('Control','Gate','LDAC','CLR');

  DAC_Pos=$0F; //додатня напруга
  DAC_Neg=$FF; //від'ємна напруга

  PinChangeCommand=$7;
  PinToHigh=$FF;
  PinToLow=$0F;


type



  TAdapterSetButton=class
  private
    FSimpleAction: TSimpleEvent;
    PinsComboBox:TComboBox;
    Pins:TPins;
    fi:integer;
  public
   property SimpleAction:TSimpleEvent read FSimpleAction write FSimpleAction;
   Constructor Create(PCB:TComboBox;Ps:TPins;i:integer;Action:TSimpleEvent);
   procedure SetButtonClick(Sender: TObject);
  end;

  TPinsShow=class(TPinsShowUniversal)
  protected
  public
   Constructor Create(Ps:TPins;
                      ControlPinLabel,GatePinLabel:TPanel;
                      PinVariants:TStringList);
  end;


  TOnePinsShow=class (TPinsShowUniversal)
  protected
  public
   Constructor Create(Ps:TPins;
                      ControlPinLabel:TPanel;
                      PinVariants:TStringList);overload;
   Constructor Create(Ps:TPins;
                      ControlPinLabel:TPanel);overload;
  end;

  TI2C_PinsShow=class (TOnePinsShow)
  protected
  public
   Constructor Create(Ps: TPins;
                      ControlPinLabel: TPanel;
                      StartAdress, LastAdress: Byte);
  end;


  TArduinoPinChangerShow=class(TOnePinsShow)
  protected
   ArduinoPinChanger:TArduinoPinChanger;
   ToChangeButton:TButton;
   procedure CaptionButtonSynhronize();
   procedure ToChangeButtonClick(Sender: TObject);
  public
   Constructor Create(APC:TArduinoPinChanger;
                      ControlPinLabel:TPanel;
                      TCBut:TButton;
                      PinVariant:TStringList
                      );

  end;

  TArduinoSetterShow=class
  protected
   fArduinoSetter:TArduinoSetter;
   PinShow:TPinsShowUniversal;
   procedure CreatePinShow(PinLs: array of TPanel;
                   PinVariant:TStringList);virtual;
   procedure  SetHookNumberPinShow();virtual;
  public
   Constructor Create(ArdSet:TArduinoSetter;
                       PinLs: array of TPanel;
                       PinVariant:TStringList);
   Procedure Free;
   procedure ReadFromIniFile(ConfigFile:TIniFile);virtual;
   procedure ReadFromIniFileAndToForm(ConfigFile:TIniFile);
   Procedure WriteToIniFile(ConfigFile:TIniFile);virtual;
  end;

implementation

uses
  Dialogs, D30_06;


Constructor TPinsShow.Create(Ps:TPins;
                      ControlPinLabel,GatePinLabel:TPanel;
                      PinVariants:TStringList);
begin
 inherited Create(Ps,[ControlPinLabel, GatePinLabel],
         [PinVariants]);
end;


{ TAdapterSetButton }

constructor TAdapterSetButton.Create(PCB: TComboBox;Ps:TPins;i:integer;
  Action: TSimpleEvent);
begin
  inherited Create;
  PinsComboBox:=PCB;
  Pins:=Ps;
  SimpleAction:=Action;
  fi:=i;
end;

procedure TAdapterSetButton.SetButtonClick(Sender: TObject);
begin
  if PinsComboBox.ItemIndex<0 then Exit;
  if PinsComboBox.Items[PinsComboBox.ItemIndex]<>IntToStr(Pins.fPins[fi]) then
    begin
     Pins.fPins[fi]:=StrToInt(PinsComboBox.Items[PinsComboBox.ItemIndex]);
     SimpleAction();
    end;
end;


{ TArduinoPinChangerShow }

procedure TArduinoPinChangerShow.CaptionButtonSynhronize;
begin
 if ArduinoPinChanger.PinUnderControl=PinToHigh
   then ToChangeButton.Caption:='To LOW'
   else if ArduinoPinChanger.PinUnderControl=PinToLow
          then  ToChangeButton.Caption:='To HIGH'
          else  ToChangeButton.Caption:='U-u-ps';
end;

constructor TArduinoPinChangerShow.Create(APC: TArduinoPinChanger;
                                          ControlPinLabel: TPanel;
                                          TCBut: TButton;
                                          PinVariant:TStringList);
begin
  inherited Create(APC.Pins,ControlPinLabel,PinVariant);
  ArduinoPinChanger:=APC;
  ToChangeButton:=TCBut;
  CaptionButtonSynhronize;
  ToChangeButton.OnClick:=ToChangeButtonClick;
end;

procedure TArduinoPinChangerShow.ToChangeButtonClick(Sender: TObject);
begin
  if ArduinoPinChanger.PinUnderControl=PinToHigh
    then ArduinoPinChanger.PinChangeToLow
    else ArduinoPinChanger.PinChangeToHigh;
  CaptionButtonSynhronize;
end;

{ TOnePinsShow }

constructor TOnePinsShow.Create(Ps: TPins;
                                ControlPinLabel: TPanel;
                                PinVariants:TStringList);
begin
 inherited Create(Ps,[ControlPinLabel],[PinVariants]);
end;

constructor TOnePinsShow.Create(Ps: TPins; ControlPinLabel: TPanel);
begin
 inherited Create(Ps,[ControlPinLabel]);
end;


{ TTMP102PinsShow }

constructor TI2C_PinsShow.Create(Ps: TPins;
                 ControlPinLabel: TPanel;
                 StartAdress, LastAdress: Byte);
 var adress:byte;
begin
 inherited Create(Ps,[ControlPinLabel]);

 fPinVariants[0].Clear;
 for adress := StartAdress to LastAdress do
   fPinVariants[0].Add('$'+IntToHex(adress,2));
end;



{ TArduinoSetterShow }

constructor TArduinoSetterShow.Create(ArdSet: TArduinoSetter;
                                     PinLs: array of TPanel;
                                     PinVariant:TStringList);
begin
 inherited Create();
 fArduinoSetter:=ArdSet;
 CreatePinShow(PinLs,PinVariant);
 SetHookNumberPinShow();

//if (fArduinoSetter is TD30_06) then   showmessage(fArduinoSetter.Name + ' jjj')
//                               else   showmessage(fArduinoSetter.Name);
// PinShow.HookNumberPinShow:=fArduinoSetter.PinsToDataArray;
end;

procedure TArduinoSetterShow.CreatePinShow(PinLs: array of TPanel;
                                        PinVariant:TStringList);
begin
 PinShow:=TPinsShowUniversal.Create(fArduinoSetter.Pins,PinLs,[PinVariant]);
end;

procedure TArduinoSetterShow.Free;
begin
 PinShow.Free;
 inherited Free;
end;

procedure TArduinoSetterShow.ReadFromIniFile(ConfigFile: TIniFile);
begin
// showmessage(PinShow.Pins.Name);
 showmessage(PinShow.Pins.Name+'ll');
 PinShow.PinsReadFromIniFile(ConfigFile);
end;

procedure TArduinoSetterShow.ReadFromIniFileAndToForm(ConfigFile: TIniFile);
begin
 ReadFromIniFile(ConfigFile);
 PinShow.NumberPinShow;
end;

procedure TArduinoSetterShow.SetHookNumberPinShow;
begin
 PinShow.HookNumberPinShow:=fArduinoSetter.PinsToDataArray;
end;

procedure TArduinoSetterShow.WriteToIniFile(ConfigFile: TIniFile);
begin
  PinShow.PinsWriteToIniFile(ConfigFile);
end;


end.
