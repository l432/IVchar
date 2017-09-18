unit SPIdevice;

interface
 uses OlegType,CPort,Dialogs,SysUtils,Classes,Windows,Forms,SyncObjs,PacketParameters,
     ExtCtrls,StdCtrls,Buttons,IniFiles, Measurement,Math, RS232device;

const
  UndefinedPin=255;


  PinNames:array[0..3]of string=
   ('Control','Gate','LDAC','CLR');


type

//  TArduinoDevice=class(TInterfacedObject,IName)
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
   property Name:string read fName;
   Constructor Create();
   Procedure ReadFromIniFile(ConfigFile:TIniFile);overload;
   Procedure ReadFromIniFile(ConfigFile:TIniFile;Strings:TStrings);overload;
   Procedure WriteToIniFile(ConfigFile:TIniFile);overload;
   Procedure WriteToIniFile(ConfigFile:TIniFile;Strings:TStrings);overload;
  end;


////  TArduinoDevice=class(TInterfacedObject,IName)
//  TArduinoDevice=class(TRS232Device)
//  {базовий клас для пристроїв, які керуються
//  за допомогою Аrduino з використанням шини SPI}
//  protected
//   fPins:TArrByte;
//   {номери пінів Arduino;
//   в цьому класі масив містить 2 елементи,
//   за необхідності в нащадках треба міняти конструктор
//   [0] для лінії Slave Select шини SPI
//   [1] для керування буфером між Аrduino та приладом}
////   fName:string;
////   fComPort:TComPort;
////   fComPacket: TComDataPacket;
////   fData:TArrByte;
////   Procedure PacketReceiving(Sender: TObject; const Str: string);virtual;abstract;
//   Function GetPinStr(Index:integer):string;
//   Function GetPin(Index:integer):byte;
//   Procedure SetPin(Index:integer; value:byte);
//  public
//   property PinControl:byte Index 0 read GetPin write SetPin;
//   property PinGate:byte Index 1 read GetPin write SetPin;
//   property PinControlStr:string Index 0 read GetPinStr;
//   property PinGateStr:string Index 1 read GetPinStr;
////   property Name:string read fName;
////   Constructor Create();overload;virtual;
//   Constructor Create();overload;override;
////   Constructor Create(CP:TComPort);overload;
////   Constructor Create(CP:TComPort;Nm:string);overload;
////   Procedure Free;
//   Procedure PinsReadFromIniFile(ConfigFile:TIniFile);overload;
//   Procedure PinsReadFromIniFile(ConfigFile:TIniFile;Strings:TStrings);overload;
//   Procedure PinsWriteToIniFile(ConfigFile:TIniFile);overload;
//   Procedure PinsWriteToIniFile(ConfigFile:TIniFile;Strings:TStrings);overload;
////   function GetName:string;
//  end;

  TArduinoDevice=class(TRS232Device)
  {базовий клас для пристроїв, які керуються
  за допомогою Аrduino з використанням шини SPI}
  protected

  public
   Pins:TPins;
   Constructor Create();overload;override;
   Constructor Create(CP:TComPort;Nm:string);overload;override;
   Procedure Free;
  end;


//  TArduinoMeter=class(TArduinoDevice,IMeasurement)
//  {базовий клас для вимірювальних об'єктів,
//  які використовують обмін даних з Arduino}
//  protected
//   fIsReady:boolean;
//   fIsReceived:boolean;
//   fMinDelayTime:integer;
//   fValue:double;
//   fMetterKod:byte;
//   Procedure PacketReceiving(Sender: TObject; const Str: string);override;
//   Function ResultProblem(Rez:double):boolean;virtual;
//   Procedure ConvertToValue(Data:array of byte);virtual;abstract;
//  public
//   property Value:double read fValue;
//   property isReady:boolean read fIsReady;
//   Constructor Create();overload;override;
//   Function Request():boolean;virtual;
//   Function Measurement():double;virtual;
//   function GetTemperature:double;virtual;
//   function GetVoltage(Vin:double):double;virtual;
//   function GetCurrent(Vin:double):double;virtual;
//   function GetResist():double;virtual;
//  end;


  TArduinoMeter=class(TRS232Meter)
  {базовий клас для вимірювальних об'єктів,
  які використовують обмін даних з Arduino}
  protected
   fMetterKod:byte;
   Procedure PacketReceiving(Sender: TObject; const Str: string);override;
  public
   Pins:TPins;
   Constructor Create();overload;override;
   Constructor Create(CP:TComPort;Nm:string);overload;override;
   Procedure Free;
   Function Request():boolean;override;
  end;

  TSimpleEvent = procedure() of object;
//
// TArrWord=array of word;


//  TAdapterRadioGroupClick=class
//    findexx:integer;
//    Constructor Create(ind:integer);overload;
//    procedure RadioGroupClick(Sender: TObject);
//  end;



//  TAdapterSetButton=class
//  private
//    FSimpleAction: TSimpleEvent;
//    PinsComboBox:TComboBox;
//    SPIDevice:TArduinoDevice;
//    fi:integer;
//  public
//   property SimpleAction:TSimpleEvent read FSimpleAction write FSimpleAction;
//   Constructor Create(PCB:TComboBox;SPID:TArduinoDevice;i:integer;Action:TSimpleEvent);
//   procedure SetButtonClick(Sender: TObject);
//  end;

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

//  TSPIDeviceShow=class
//  protected
//   ArduDevice:TArduinoDevice;
//   PinLabels:array of TLabel;
//   SetPinButtons:array of TButton;
//   PinsComboBox:TComboBox;
//   procedure CreateFooter;
//  public
//   Constructor Create(SPID:TArduinoDevice;
//                      ControlPinLabel,GatePinLabel:TLabel;
//                      SetControlButton,SetGateButton:TButton;
//                      PCB:TComboBox);
//   procedure PinsReadFromIniFile(ConfigFile:TIniFile);
//   procedure PinsWriteToIniFile(ConfigFile:TIniFile);
//   procedure NumberPinShow();virtual;
//  end;

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

uses
  Graphics, OlegMath, OlegGraph;


//Constructor TArduinoDevice.Create();
//begin
//  inherited Create();
//  SetLength(fPins,2);
//  PinControl:=UndefinedPin;
//  PinGate:=UndefinedPin;
////  fName:='';
////  fComPacket:=TComDataPacket.Create(fComPort);
////  fComPacket.Size:=0;
////  fComPacket.MaxBufferSize:=1024;
////  fComPacket.IncludeStrings:=False;
////  fComPacket.CaseInsensitive:=False;
//  fComPacket.StartString:=PacketBeginChar;
//  fComPacket.StopString:=PacketEndChar;
////  fComPacket.OnPacket:=PacketReceiving;
//end;
//
//
////Constructor TArduinoDevice.Create(CP:TComPort);
////begin
//// Create();
//// fComPort:=CP;
//// fComPacket.ComPort:=CP;
////end;
////
////Constructor TArduinoDevice.Create(CP:TComPort;Nm:string);
////begin
//// Create(CP);
//// fName:=Nm;
////end;
//
//
////Procedure TArduinoDevice.Free;
////begin
//// fComPacket.Free;
//// inherited;
////end;
//
//Function TArduinoDevice.GetPinStr(Index:integer):string;
//begin
//  Result:=PinNames[Index]+' pin is ';
//  if fPins[Index]=UndefinedPin then
//    Result:=Result+'undefined'
//                               else
//    Result:=Result+IntToStr(fPins[Index]);
//end;
//
////function TArduinoDevice.GetName: string;
////begin
//// Result:=Name;
////end;
//
//Function TArduinoDevice.GetPin(Index:integer):byte;
//begin
//  Result:=fPins[Index];
//end;
//
//Procedure TArduinoDevice.SetPin(Index:integer; value:byte);
//begin
//  fPins[Index]:=value;
//end;
//
//Procedure TArduinoDevice.PinsReadFromIniFile(ConfigFile:TIniFile);
// var i:integer;
//begin
//  if Name='' then Exit;
//  for I := 0 to High(fPins) do
//      fPins[i]:=ConfigFile.ReadInteger(Name, PinNames[i], UndefinedPin);
//end;
//
//Procedure TArduinoDevice.PinsReadFromIniFile(ConfigFile:TIniFile;Strings:TStrings);
// var i,TempPin:integer;
//begin
//  if Name='' then Exit;
//  for I := 0 to High(fPins) do
//   begin
//    TempPin := ConfigFile.ReadInteger(Name, PinNames[i], -1);
//    if (TempPin > -1) and (TempPin < Strings.Count) then
//      fPins[i] := StrToInt(Strings[TempPin]);
//   end;
//end;
//
//
//Procedure TArduinoDevice.PinsWriteToIniFile(ConfigFile:TIniFile);
// var i:integer;
//begin
//  if Name='' then Exit;
//  ConfigFile.EraseSection(Name);
//  for I := 0 to High(fPins) do
//     WriteIniDef(ConfigFile,Name,PinNames[i], UndefinedPin);
//end;
//
//Procedure TArduinoDevice.PinsWriteToIniFile(ConfigFile:TIniFile;Strings:TStrings);
// var i,j:integer;
//begin
//  if Name='' then Exit;
//  ConfigFile.EraseSection(Name);
//  for I := 0 to Strings.Count - 1 do
//    for j := 0 to High(fPins) do
//      if (IntToStr(fPins[j]) = Strings[i]) then
//        ConfigFile.WriteInteger(Name, PinNames[j], i);
//end;
//


{ TAdapter }

//constructor TAdapterRadioGroupClick.Create(ind: integer);
//begin
// inherited Create;
// findexx:=ind;
//end;
//
//
//procedure TAdapterRadioGroupClick.RadioGroupClick(Sender: TObject);
//begin
// try
// (Sender as TRadioGroup).ItemIndex:=findexx;
// except
// end;
//end;


{ TSPIdeviceShow }

//constructor TSPIdeviceShow.Create(SPID:TArduinoDevice;
//                                  ControlPinLabel, GatePinLabel: TLabel;
//                                  SetControlButton, SetGateButton: TButton; PCB: TComboBox);
//begin
// inherited Create();
// ArduDevice:=SPID;
// SetLength(PinLabels,High(ArduDevice.fPins)+1);
// SetLength(SetPinButtons,High(ArduDevice.fPins)+1);
// PinLabels[0]:=ControlPinLabel;
// if High(PinLabels)>0 then
//    PinLabels[1]:=GatePinLabel;
// SetPinButtons[0]:=SetControlButton;
// if High(SetPinButtons)>0 then
//    SetPinButtons[1]:=SetGateButton;
// PinsComboBox:=PCB;
//
// CreateFooter();
//end;

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

//procedure TSPIDeviceShow.NumberPinShow;
//begin
//   PinLabels[0].Caption:=ArduDevice.PinControlStr;
//   if High(PinLabels)>0 then
//    PinLabels[1].Caption:=ArduDevice.PinGateStr;
//end;

procedure TPinsShow.NumberPinShow;
begin
   PinLabels[0].Caption:=Pins.PinControlStr;
   if High(PinLabels)>0 then
    PinLabels[1].Caption:=Pins.PinGateStr;
end;

//procedure TSPIDeviceShow.CreateFooter;
//var
//  i: Integer;
//begin
//  for I := 0 to High(SetPinButtons) do
//    begin
//    SetPinButtons[i].OnClick := TAdapterSetButton.Create(PinsComboBox, ArduDevice, i, NumberPinShow).SetButtonClick;
//    SetPinButtons[i].Caption := 'set ' + LowerCase(PinNames[i]);
//    end;
//end;

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

//procedure TSPIDeviceShow.PinsReadFromIniFile(ConfigFile: TIniFile);
//begin
//  ArduDevice.PinsReadFromIniFile(ConfigFile,PinsComboBox.Items);
//end;
//
//procedure TSPIDeviceShow.PinsWriteToIniFile(ConfigFile: TIniFile);
//begin
//  ArduDevice.PinsWriteToIniFile(ConfigFile,PinsComboBox.Items);
//end;


procedure TPinsShow.PinsReadFromIniFile(ConfigFile: TIniFile);
begin
  Pins.ReadFromIniFile(ConfigFile,PinsComboBox.Items);
end;

procedure TPinsShow.PinsWriteToIniFile(ConfigFile: TIniFile);
begin
  Pins.WriteToIniFile(ConfigFile,PinsComboBox.Items);
end;

{ TAdapterSetButton }

//constructor TAdapterSetButton.Create(PCB: TComboBox;SPID:TArduinoDevice;i:integer;
//  Action: TSimpleEvent);
//begin
//  inherited Create;
//  PinsComboBox:=PCB;
//  SPIDevice:=SPID;
//  SimpleAction:=Action;
//  fi:=i;
//end;

//procedure TAdapterSetButton.SetButtonClick(Sender: TObject);
//begin
//  if PinsComboBox.ItemIndex<0 then Exit;
//  if PinsComboBox.Items[PinsComboBox.ItemIndex]<>IntToStr(SPIDevice.fPins[fi]) then
//    begin
//     SPIDevice.fPins[fi]:=StrToInt(PinsComboBox.Items[PinsComboBox.ItemIndex]);
//     SimpleAction();
//    end;
//end;

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

//constructor TArduinoMeter.Create;
//begin
//  inherited Create();
//  fIsReady:=False;
//  fIsReceived:=False;
//  fMinDelayTime:=0;
//end;

constructor TArduinoMeter.Create;
begin
  inherited Create();
  Pins:=TPins.Create;
end;

Constructor TArduinoMeter.Create(CP:TComPort;Nm:string);
begin
  inherited Create(CP,Nm);
  Pins.fName:=Nm;
end;


procedure TArduinoMeter.Free;
begin
 Pins.Free;
 inherited Free;
end;

//function TArduinoMeter.GetCurrent(Vin: double): double;
//begin
//  Result:=ErResult;
//end;
//
//function TArduinoMeter.GetResist: double;
//begin
//  Result:=ErResult;
//end;
//
//function TArduinoMeter.GetTemperature: double;
//begin
//  Result:=ErResult;
//end;
//
//function TArduinoMeter.GetVoltage(Vin: double): double;
//begin
//  Result:=ErResult;
//end;

//function TArduinoMeter.Measurement: double;
//label start;
//var i:integer;
//    isFirst:boolean;
//begin
// Result:=ErResult;
// if not(fComPort.Connected) then
//   begin
//    showmessage('Port is not connected');
//    Exit;
//   end;
//
// isFirst:=True;
//start:
// fIsReady:=False;
// fIsReceived:=False;
// if not(Request()) then Exit;
// // i0:=GetTickCount;
// sleep(fMinDelayTime);
// i:=0;
// repeat
//   sleep(10);
//   inc(i);
// Application.ProcessMessages;
// until ((i>130)or(fIsReceived));
//// showmessage(inttostr((GetTickCount-i0)));
// if fIsReceived then ConvertToValue(fData);
// if fIsReady then Result:=fValue;
//
// if ((Result=ErResult)or(ResultProblem(Result)))and(isFirst) then
//    begin
//      isFirst:=false;
//      goto start;
//    end;
//end;

//procedure TArduinoMeter.PacketReceiving(Sender: TObject; const Str: string);
//  var i:integer;
//begin
// if not(PacketIsReceived(Str,fData,fMetterKod)) then Exit;
// if fData[2]<>PinControl then Exit;
// for I := 0 to High(fData)-4 do
//   fData[i]:=fData[i+3];
// SetLength(fData,High(fData)-3);
// fIsReceived:=True;
//end;
//
//function TArduinoMeter.Request: boolean;
//begin
//  PacketCreate([fMetterKod,PinControl]);
//  Result:=PacketIsSend(fComPort,Name+' measurement is unsuccessful');
//end;

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

function TArduinoMeter.Request: boolean;
begin
  PacketCreate([fMetterKod,Pins.PinControl]);
  Result:=PacketIsSend(fComPort,Name+' measurement is unsuccessful');
end;

//function TArduinoMeter.ResultProblem(Rez: double): boolean;
//begin
// Result:=False;
//end;

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

{ TArduinoDevice }

constructor TArduinoDevice.Create;
begin
  inherited Create;
  Pins:=TPins.Create;
  fComPacket.StartString:=PacketBeginChar;
  fComPacket.StopString:=PacketEndChar;
end;

constructor TArduinoDevice.Create(CP: TComPort; Nm: string);
begin
 inherited Create(CP,Nm);
 Pins.fName:=Nm;
end;

procedure TArduinoDevice.Free;
begin
 Pins.Free;
 inherited Free;
end;

end.
