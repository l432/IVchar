unit SPIdevice;

interface
 uses OlegType,CPort,SysUtils,Classes,PacketParameters,
      StdCtrls, IniFiles, RS232device;

const
  UndefinedPin=255;


  PinNames:array[0..3]of string=
   ('Control','Gate','LDAC','CLR');


type

  TPins=class
  {клас для опису пінів, які використовуються
   при взаємодії з Аrduino}
  protected
   fName:string;
   Function GetPinStr(Index:integer):string;
   Function GetPin(Index:integer):byte;
   Procedure SetPin(Index:integer; value:byte);
  public
   fPins:TArrByte;
   {номери пінів Arduino;
   в цьому класі масив містить 2 елементи,
   за необхідності в нащадках треба міняти конструктор
   [0] для лінії Slave Select шини SPI
   [1] для керування буфером між Аrduino та приладом}
   property PinControl:byte Index 0 read GetPin write SetPin;
   property PinGate:byte Index 1 read GetPin write SetPin;
   property PinControlStr:string Index 0 read GetPinStr;
   property PinGateStr:string Index 1 read GetPinStr;
   property Name:string read fName write fName;
   Constructor Create();
   Procedure ReadFromIniFile(ConfigFile:TIniFile);overload;
   Procedure ReadFromIniFile(ConfigFile:TIniFile;Strings:TStrings);overload;
   Procedure WriteToIniFile(ConfigFile:TIniFile);overload;
   Procedure WriteToIniFile(ConfigFile:TIniFile;Strings:TStrings);overload;
  end;

  TArduinoMeter=class(TRS232Meter)
  {базовий клас для вимірювальних об'єктів,
  які використовують обмін даних з Arduino}
  protected
   fMetterKod:byte;
   Procedure PacketReceiving(Sender: TObject; const Str: string);override;
  public
   Pins:TPins;
   Constructor Create(CP:TComPort;Nm:string);override;
   Procedure Free;
   procedure ComPortUsing();override;
  end;

  TSimpleEvent = procedure() of object;


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

  TPinsShow=class
  protected
   Pins:TPins;
   PinLabels:array of TLabel;
   SetPinButtons:array of TButton;
   PinsComboBox:TComboBox;
   procedure CreateFooter;
  public
   Constructor Create(Ps:TPins;
                      ControlPinLabel,GatePinLabel:TLabel;
                      SetControlButton,SetGateButton:TButton;
                      PCB:TComboBox);
   procedure PinsReadFromIniFile(ConfigFile:TIniFile);
   procedure PinsWriteToIniFile(ConfigFile:TIniFile);
   procedure NumberPinShow();virtual;
  end;



implementation

constructor TPinsShow.Create(Ps:TPins;
                                  ControlPinLabel, GatePinLabel: TLabel;
                                  SetControlButton, SetGateButton: TButton; PCB: TComboBox);
begin
 inherited Create();
 Pins:=Ps;
 SetLength(PinLabels,High(Pins.fPins)+1);
 SetLength(SetPinButtons,High(Pins.fPins)+1);
 PinLabels[0]:=ControlPinLabel;
 if High(PinLabels)>0 then
    PinLabels[1]:=GatePinLabel;
 SetPinButtons[0]:=SetControlButton;
 if High(SetPinButtons)>0 then
    SetPinButtons[1]:=SetGateButton;
 PinsComboBox:=PCB;

 CreateFooter();
end;

procedure TPinsShow.NumberPinShow;
begin
   PinLabels[0].Caption:=Pins.PinControlStr;
   if High(PinLabels)>0 then
    PinLabels[1].Caption:=Pins.PinGateStr;
end;

procedure TPinsShow.CreateFooter;
var
  i: Integer;
begin
  for I := 0 to High(SetPinButtons) do
    begin
    SetPinButtons[i].OnClick := TAdapterSetButton.Create(PinsComboBox, Pins, i, NumberPinShow).SetButtonClick;
    SetPinButtons[i].Caption := 'set ' + LowerCase(PinNames[i]);
    end;
end;

procedure TPinsShow.PinsReadFromIniFile(ConfigFile: TIniFile);
begin
  Pins.ReadFromIniFile(ConfigFile,PinsComboBox.Items);
end;

procedure TPinsShow.PinsWriteToIniFile(ConfigFile: TIniFile);
begin
  Pins.WriteToIniFile(ConfigFile,PinsComboBox.Items);
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

{ TArduinoMeter }

procedure TArduinoMeter.ComPortUsing;
begin
  PacketCreate([fMetterKod,Pins.PinControl]);
  fError:=not(PacketIsSend(fComPort,Name+' measurement is unsuccessful'));
end;

Constructor TArduinoMeter.Create(CP:TComPort;Nm:string);
begin
  inherited Create(CP,Nm);

  Pins:=TPins.Create;
  Pins.fName:=Nm;

  fComPacket.StartString:=PacketBeginChar;
  fComPacket.StopString:=PacketEndChar;
end;


procedure TArduinoMeter.Free;
begin
 Pins.Free;
 inherited Free;
end;

procedure TArduinoMeter.PacketReceiving(Sender: TObject; const Str: string);
  var i:integer;
begin
 if not(PacketIsReceived(Str,fData,fMetterKod)) then Exit;
 if fData[2]<>Pins.PinControl then Exit;
 for I := 0 to High(fData)-4 do
   fData[i]:=fData[i+3];
 SetLength(fData,High(fData)-3);
 fIsReceived:=True;
end;

{ TPins }

constructor TPins.Create;
begin
  inherited;
  SetLength(fPins,2);
  PinControl:=UndefinedPin;
  PinGate:=UndefinedPin;
  fName:='';
end;

function TPins.GetPin(Index: integer): byte;
begin
  Result:=fPins[Index];
end;

function TPins.GetPinStr(Index: integer): string;
begin
  Result:=PinNames[Index]+' pin is ';
  if fPins[Index]=UndefinedPin then
    Result:=Result+'undefined'
                               else
    Result:=Result+IntToStr(fPins[Index]);
end;

procedure TPins.ReadFromIniFile(ConfigFile: TIniFile);
 var i:integer;
begin
  if Name='' then Exit;
  for I := 0 to High(fPins) do
      fPins[i]:=ConfigFile.ReadInteger(Name, PinNames[i], UndefinedPin);
end;

procedure TPins.ReadFromIniFile(ConfigFile: TIniFile; Strings: TStrings);
 var i,TempPin:integer;
begin
  if Name='' then Exit;
  for I := 0 to High(fPins) do
   begin
    TempPin := ConfigFile.ReadInteger(Name, PinNames[i], -1);
    if (TempPin > -1) and (TempPin < Strings.Count) then
      fPins[i] := StrToInt(Strings[TempPin]);
   end;
end;

procedure TPins.WriteToIniFile(ConfigFile: TIniFile; Strings: TStrings);
 var i,j:integer;
begin
  if Name='' then Exit;
  ConfigFile.EraseSection(Name);
  for I := 0 to Strings.Count - 1 do
    for j := 0 to High(fPins) do
      if (IntToStr(fPins[j]) = Strings[i]) then
        ConfigFile.WriteInteger(Name, PinNames[j], i);
end;

procedure TPins.WriteToIniFile(ConfigFile: TIniFile);
 var i:integer;
begin
  if Name='' then Exit;
  ConfigFile.EraseSection(Name);
  for I := 0 to High(fPins) do
     WriteIniDef(ConfigFile,Name,PinNames[i], UndefinedPin);
end;

procedure TPins.SetPin(Index: integer; value: byte);
begin
  fPins[Index]:=value;
end;

end.
