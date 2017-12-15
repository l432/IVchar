unit SPIdevice;

interface
 uses OlegType,CPort,SysUtils,Classes,PacketParameters,
      StdCtrls, IniFiles, RS232device;

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

  TPins=class
  {клас для опису пінів, які використовуються
   при взаємодії з Аrduino}
  protected
   fName:string;
   Function GetPinStr(Index:integer):string;virtual;
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

  TArduinoRS232Device=class(TRS232Device)
  protected
   fDeviceKod:byte;

  public
   Pins:TPins;
   Constructor Create(CP:TComPort;Nm:string);override;
   procedure Free;
  end;

 TArduinoPinChanger=class(TArduinoRS232Device)
  protected
   fPinUnderControl:byte;
   procedure   PacketCreateToSend(); override;
  public
   property PinUnderControl:byte read fPinUnderControl write fPinUnderControl;
   Constructor Create(CP:TComPort;Nm:string);override;
   procedure PinChangeToHigh();
   procedure PinChangeToLow();
  end;

  TArduinoMeter=class(TRS232Meter)
  {базовий клас для вимірювальних об'єктів,
  які використовують обмін даних з Arduino}
  protected
   fMetterKod:byte;
   Procedure PacketReceiving(Sender: TObject; const Str: string);override;
   procedure   PacketCreateToSend(); override;
  public
   Pins:TPins;
   Constructor Create(CP:TComPort;Nm:string);override;
   Procedure Free;
//   procedure ComPortUsing();override;
  end;


  TArduinoDAC=class(TRS232Setter)
    {базовий клас для ЦАП, що керується
    за допомогою Arduino    }
  private
//   procedure DataByteToSendPrepare(Voltage: Double);

  protected
   Pins:TPins;
   fVoltageMaxValue:double;
   fKodMaxValue:integer;
//   fMessageError:string;
   fSetterKod:byte;
   procedure PacketCreateAndSend();
   function  VoltageToKod(Voltage:double):integer;virtual;
   procedure DataByteToSendFromInteger(IntData: Integer);virtual;
   procedure PinsToDataArray;virtual;
   procedure OutputDataSignDetermination(OutputData: Double);
   procedure CreateHook;virtual;
   function NormedKod(Kod: Integer):integer;
   procedure   PacketCreateToSend(); override;
  public
   Constructor Create(CP:TComPort;Nm:string);override;
   Procedure Free;
   Procedure Output(Voltage:double);override;
   Procedure Reset();override;
   Procedure OutputInt(Kod:integer);override;
//   procedure ComPortUsing();override;
  end;



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
   fHookNumberPinShow: TSimpleEvent;
   PinLabels:array of TLabel;
   SetPinButtons:array of TButton;
   PinsComboBox:TComboBox;
   procedure CreateFooter;
//   procedure AEmpty;
  public
   Pins:TPins;
   property HookNumberPinShow:TSimpleEvent read fHookNumberPinShow write fHookNumberPinShow;
   Constructor Create(Ps:TPins;
                      ControlPinLabel,GatePinLabel:TLabel;
                      SetControlButton,SetGateButton:TButton;
                      PCB:TComboBox);
   procedure PinsReadFromIniFile(ConfigFile:TIniFile);
   procedure PinsWriteToIniFile(ConfigFile:TIniFile);
   procedure NumberPinShow();virtual;
  end;

  TArduinoPinChangerShow=class(TPinsShow)
  protected
   ArduinoPinChanger:TArduinoPinChanger;
   ToChangeButton:TButton;
   procedure CaptionButtonSynhronize();
   procedure ToChangeButtonClick(Sender: TObject);
  public
   Constructor Create(APC:TArduinoPinChanger;
                      ControlPinLabel:TLabel;
                      SetControlButton,TCBut:TButton;
                      PCB:TComboBox
                      );

  end;


implementation

uses
  Math;

//procedure TPinsShow.AEmpty;
//begin
//
//end;

constructor TPinsShow.Create(Ps:TPins;
                             ControlPinLabel, GatePinLabel: TLabel;
                             SetControlButton, SetGateButton: TButton;
                             PCB: TComboBox);
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
// HookNumberPinShow:=AEmpty;
 HookNumberPinShow:=TSimpleClass.EmptyProcedure;
 CreateFooter();
end;

procedure TPinsShow.NumberPinShow;
begin
   PinLabels[0].Caption:=Pins.PinControlStr;
   if High(PinLabels)>0 then
    PinLabels[1].Caption:=Pins.PinGateStr;
   HookNumberPinShow; 
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

//procedure TArduinoMeter.ComPortUsing;
//begin
//  PacketCreate([fMetterKod,Pins.PinControl]);
//  fError:=not(PacketIsSend(fComPort,fMessageError));
//end;

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

procedure TArduinoMeter.PacketCreateToSend;
begin
 PacketCreate([fMetterKod,Pins.PinControl]);
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

{ TArduinoDAC }

//procedure TArduinoDAC.ComPortUsing;
//begin
// PacketCreate(fData);
//// PacketCreate([DACR2RCommand, Pins.PinControl, Pins.PinGate, fData[0], fData[1], fData[2]]);
// PacketIsSend(fComPort, fMessageError);
//end;

function TArduinoDAC.NormedKod(Kod: Integer):integer;
begin
  Result := min(abs(Kod), fKodMaxValue);
end;

procedure TArduinoDAC.CreateHook;
begin
//  Pins:=TPins.Create;
//  Pins.Name:=self.Name;

  fVoltageMaxValue:=5;
  fKodMaxValue:=65535;
//  fMessageError:='Output is unsuccessful';
  fSetterKod:=$FF;

end;

procedure TArduinoDAC.OutputDataSignDetermination(OutputData: Double);
begin
  // if Voltage<0 then fData[2]:=DAC_Neg
  //              else fData[2]:=DAC_Pos;
  if OutputData < 0 then  fData[5] := DAC_Neg
                    else  fData[5] := DAC_Pos;
end;

procedure TArduinoDAC.PinsToDataArray;
begin
//  fData[0] := fCommandByte;
  fData[1] := Pins.PinControl;
  fData[2] := Pins.PinGate;
end;

constructor TArduinoDAC.Create(CP: TComPort; Nm: string);
begin
  inherited Create(CP,Nm);
  Pins:=TPins.Create;
  Pins.Name:=Nm;
  fComPacket.StartString:=PacketBeginChar;
  fComPacket.StopString:=PacketEndChar;

  CreateHook;
//  SetLength(fData,3);
  SetLength(fData,6);
  fData[0] := fSetterKod;
  PinsToDataArray();
end;

procedure TArduinoDAC.DataByteToSendFromInteger(IntData: Integer);
 var NormedIntData:integer;
begin
  NormedIntData:=NormedKod(IntData);
//  fData[0] := ((IntData shr 8) and $FF);
//  fData[1] := (IntData and $FF);
  fData[3] := ((NormedIntData shr 8) and $FF);
  fData[4] := (NormedIntData and $FF);
end;

//procedure TArduinoDAC.DataByteToSendPrepare(Voltage: Double);
//begin
//  DataByteToSendFromInteger(VoltageToKod(Voltage));
//end;

procedure TArduinoDAC.Free;
begin
 Pins.Free;
 inherited Free;
end;

procedure TArduinoDAC.Output(Voltage: double);
begin
 if Voltage=ErResult then Exit;
 OutputDataSignDetermination(Voltage);
// DataByteToSendPrepare(Voltage);
 DataByteToSendFromInteger(VoltageToKod(Voltage));
 PacketCreateAndSend();
end;

procedure TArduinoDAC.OutputInt(Kod: integer);
begin
 inherited OutputInt(Kod);
// if Kod<0 then fData[2]:=DAC_Neg
//          else fData[2]:=DAC_Pos;
 OutputDataSignDetermination(Kod);
// if Kod<0 then fData[5]:=DAC_Neg
//          else fData[5]:=DAC_Pos;
 DataByteToSendFromInteger(abs(Kod));
 PacketCreateAndSend();
end;

procedure TArduinoDAC.PacketCreateAndSend;
begin
  isNeededComPortState();
end;

procedure TArduinoDAC.PacketCreateToSend;
begin
 PacketCreate(fData);
end;

procedure TArduinoDAC.Reset;
begin
// fData[2]:=DAC_Pos;
// fData[0] := $00;
// fData[1] := $00;
 fData[5]:=DAC_Pos;
 fData[3] := $00;
 fData[4] := $00;
 PacketCreateAndSend();
end;

function TArduinoDAC.VoltageToKod(Voltage: double): integer;
begin
 fOutPutValue:=Voltage;
 Voltage:=abs(Voltage);
 if Voltage>fVoltageMaxValue
    then Result:=fKodMaxValue
    else Result:=round(Voltage/fVoltageMaxValue*fKodMaxValue);
end;

{ TArduinoRS232Device }

constructor TArduinoRS232Device.Create(CP: TComPort; Nm: string);
begin
  inherited Create(CP,Nm);
  Pins:=TPins.Create;
  Pins.Name:=Nm;
  fComPacket.StartString:=PacketBeginChar;
  fComPacket.StopString:=PacketEndChar;
end;

procedure TArduinoRS232Device.Free;
begin
 Pins.Free;
 inherited Free;
end;

{ TArduinoPinChanger }

constructor TArduinoPinChanger.Create(CP: TComPort; Nm: string);
begin
 inherited Create(CP,Nm);
 fDeviceKod:=PinChangeCommand;
 SetLength(Pins.fPins,1);
 PinUnderControl:=PinToHigh;
// SetLength(fData,3);
end;


procedure TArduinoPinChanger.PacketCreateToSend;
begin
 PacketCreate([fDeviceKod,Pins.PinControl,PinUnderControl]);
end;

procedure TArduinoPinChanger.PinChangeToHigh;
begin
 PinUnderControl:=PinToHigh;
 isNeededComPortState();
end;

procedure TArduinoPinChanger.PinChangeToLow;
begin
 PinUnderControl:=PinToLow;
 isNeededComPortState();
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
                                          ControlPinLabel: TLabel;
                                          SetControlButton, TCBut: TButton;
                                          PCB: TComboBox);
begin
  inherited Create(APC.Pins,ControlPinLabel,nil,SetControlButton,nil,PCB);
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

end.
