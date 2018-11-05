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
   Function PinValueToStr(Index:integer):string;virtual;
   Function GetPin(Index:integer):byte;
   Procedure SetPin(Index:integer; value:byte);

  public
   fPins:TArrByte;
   PNames:array of string;
   PinStrPart:string;
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
//   Constructor Create();overload;
   Constructor Create(Nm:string);overload;
   Constructor Create(Nm:string;PNm:array of string;PNumber:byte);overload;
   Constructor Create(Nm:string;PNm:array of string);overload;
   Constructor Create(Nm:string;PNumber:byte);overload;
   Procedure ReadFromIniFile(ConfigFile:TIniFile);overload;
   Procedure ReadFromIniFile(ConfigFile:TIniFile;Strings:TStrings);overload;
   Procedure ReadFromIniFile(ConfigFile:TIniFile;PinsComboBoxs:array of TComboBox);overload;
   Procedure ReadFromIniFile(ConfigFile:TIniFile;PinsStrings:array of TStringList);overload;
   Procedure WriteToIniFile(ConfigFile:TIniFile);overload;
   Procedure WriteToIniFile(ConfigFile:TIniFile;Strings:TStrings);overload;
   Procedure WriteToIniFile(ConfigFile:TIniFile;PinsComboBoxs:array of TComboBox);overload;
   Procedure WriteToIniFile(ConfigFile:TIniFile;PinsStrings:array of TStringList);overload;
  end;

  TPins_I2C=class(TPins)
  protected
   Function PinValueToStr(Index:integer):string;override;
   public
   Constructor Create(Nm:string);
  end;

  TArduinoRS232Device=class(TRS232Device)
  protected
   fDeviceKod:byte;
   procedure PinsCreate();virtual;
  public
   Pins:TPins;
   Constructor Create(CP:TComPort;Nm:string);override;
   procedure Free;
  end;

 TArduinoPinChanger=class(TArduinoRS232Device)
  protected
   fPinUnderControl:byte;
   procedure   PacketCreateToSend(); override;
   procedure PinsCreate();override;
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
   procedure PinsCreate();virtual;
  public
   Pins:TPins;
   Constructor Create(CP:TComPort;Nm:string);override;
   Procedure Free;
//   procedure ComPortUsing();override;
  end;


  TArduinoDAC=class(TRS232Setter)
    {базовий клас для ЦАП, що керується
    за допомогою Arduino    }
//  private
//   procedure DataByteToSendPrepare(Voltage: Double);
  protected
   Pins:TPins;
   fVoltageMaxValue:double;
   fKodMaxValue:integer;
//   fMessageError:string;
   fSetterKod:byte;
   procedure PinsCreate();virtual;
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

  TPinsShowShot=class
  protected
   fHookNumberPinShow: TSimpleEvent;
   PinLabels:array of TLabel;
   fPinVariants:array of TStringList;
   procedure CreateFooter;
//    function GetVariants(Index: byte): TStringList;
    procedure SetVariants(Index: byte; const S: TStringList);
  public
   Pins:TPins;
   property HookNumberPinShow:TSimpleEvent read fHookNumberPinShow write fHookNumberPinShow;
//   property PinVariants[Index: byte]: TStringList read GetVariants write SetVariants;
   property PinVariants[Index: byte]: TStringList write SetVariants;
   Constructor Create(Ps:TPins;
                      PinLs:array of TLabel);
   procedure PinsReadFromIniFile(ConfigFile:TIniFile);virtual;
   procedure PinsWriteToIniFile(ConfigFile:TIniFile);virtual;
   procedure NumberPinShow();virtual;
   procedure Free();
   procedure VariantsShowAndSelect(Sender: TObject);
  end;



  TPinsShowUniversal=class
  protected
   fHookNumberPinShow: TSimpleEvent;
   PinLabels:array of TLabel;
   SetPinButtons:array of TButton;
   PinsComboBoxs:array of TComboBox;
   procedure CreateFooter;
  public
   Pins:TPins;
   property HookNumberPinShow:TSimpleEvent read fHookNumberPinShow write fHookNumberPinShow;
   Constructor Create(Ps:TPins;
                      PinLs:array of TLabel;
                      SetPBs:array of TButton;
                      PinCBs:array of TComboBox);
   procedure PinsReadFromIniFile(ConfigFile:TIniFile);virtual;
   procedure PinsWriteToIniFile(ConfigFile:TIniFile);virtual;
   procedure NumberPinShow();virtual;
  end;


  TPinsShow=class(TPinsShowUniversal)
  protected
  public
   Constructor Create(Ps:TPins;
                      ControlPinLabel,GatePinLabel:TLabel;
                      SetControlButton,SetGateButton:TButton;
                      PCB:TComboBox);
  end;


  TOnePinsShow=class (TPinsShowUniversal)
  protected
  public
   Constructor Create(Ps:TPins;
                      ControlPinLabel:TLabel;
                      SetControlButton:TButton;
                      PCB:TComboBox);
  end;

  TI2C_PinsShow=class (TOnePinsShow)
  protected
  public
   Constructor Create(Ps: TPins;
                      ControlPinLabel: TLabel;
                      SetControlButton: TButton;
                      PCB: TComboBox; StartAdress, LastAdress: Byte);
  end;


  TArduinoPinChangerShow=class(TOnePinsShow)
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
  Math, Forms, Graphics, ExtCtrls, Controls, Dialogs;

constructor TPinsShow.Create(Ps:TPins;
                             ControlPinLabel, GatePinLabel: TLabel;
                             SetControlButton, SetGateButton: TButton;
                             PCB: TComboBox);
begin
 inherited Create(Ps,[ControlPinLabel, GatePinLabel],
         [SetControlButton, SetGateButton],[PCB,PCB]);
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
  PinsCreate();

  fComPacket.StartString:=PacketBeginChar;
  fComPacket.StopString:=PacketEndChar;
end;


procedure TArduinoMeter.Free;
begin
 Pins.Free;
 inherited Free;
end;

procedure TArduinoMeter.PinsCreate();
begin
  Pins := TPins.Create(Name);
end;

procedure TArduinoMeter.PacketCreateToSend;
begin
 PacketCreate([fMetterKod,Pins.PinControl]);
end;

procedure TArduinoMeter.PacketReceiving(Sender: TObject; const Str: string);
  var i:integer;
begin
// ShowData(fData);
 if not(PacketIsReceived(Str,fData,fMetterKod)) then Exit;
 if fData[2]<>Pins.PinControl then Exit;
 for I := 0 to High(fData)-4 do
   fData[i]:=fData[i+3];
 SetLength(fData,High(fData)-3);
 fIsReceived:=True;
end;

{ TPins }

//constructor TPins.Create;
// var i:integer;
//begin
//  inherited;
//  SetLength(fPins,2);
//  SetLength(PNames,2);
//  for I := 0 to High(fPins) do
//   begin
//    PNames[i]:=PinNames[i];
//    fPins[i]:=UndefinedPin;
//   end;
//  fName:='';
//end;

constructor TPins.Create(Nm: string);
begin
 Create(Nm,PinNames,2);
// fName:=Nm;
end;

constructor TPins.Create(Nm: string; PNm: array of string; PNumber: byte);
  var i:integer;
begin
  inherited Create;
  fName:=Nm;
  SetLength(fPins,PNumber);
  SetLength(PNames,PNumber);
  for I := 0 to High(fPins) do
   begin
    if i<=High(PNm) then PNames[i]:=PNm[i]
                    else PNames[i]:='';
    fPins[i]:=UndefinedPin;
   end;
   PinStrPart:=' pin'
end;

constructor TPins.Create(Nm: string; PNm: array of string);
begin
  Create(Nm,PNm,2);
end;

constructor TPins.Create(Nm: string; PNumber: byte);
begin
 Create(Nm,PinNames,PNumber);
end;

function TPins.GetPin(Index: integer): byte;
begin
  Result:=fPins[Index];
end;

function TPins.GetPinStr(Index: integer): string;
begin
  Result:=PNames[Index]+PinStrPart+' is ';
  if fPins[Index]=UndefinedPin then
    Result:=Result+'undefined'
                               else
    Result:=Result+PinValueToStr(Index);
end;

function TPins.PinValueToStr(Index: integer): string;
begin
 Result:=IntToStr(fPins[Index]);
end;

procedure TPins.ReadFromIniFile(ConfigFile: TIniFile;
          PinsComboBoxs: array of TComboBox);
  var i,TempPin:integer;
begin
  if Name='' then Exit;
  for I := 0 to High(fPins) do
   begin
    TempPin := ConfigFile.ReadInteger(Name, PNames[i], -1);
    if (i<=High(PinsComboBoxs))
        and (TempPin > -1)
        and (TempPin < PinsComboBoxs[i].Items.Count) then
          fPins[i] := StrToInt(PinsComboBoxs[i].Items[TempPin])
                                                     else
          fPins[i]:=ConfigFile.ReadInteger(Name, PNames[i], UndefinedPin);
   end;
end;

procedure TPins.ReadFromIniFile(ConfigFile: TIniFile;
  PinsStrings: array of TStringList);
  var i,TempPin:integer;
begin
  if Name='' then Exit;
  for I := 0 to High(fPins) do
   begin
    TempPin := ConfigFile.ReadInteger(Name, PNames[i], -1);
    if (i<=High(PinsStrings))
        and (TempPin > -1)
        and (TempPin < PinsStrings[i].Count) then
          fPins[i] := StrToInt(PinsStrings[i].Strings[TempPin])
                                                     else
          fPins[i]:=ConfigFile.ReadInteger(Name, PNames[i], UndefinedPin);
   end;
end;

procedure TPins.ReadFromIniFile(ConfigFile: TIniFile);
 var i:integer;
begin
  if Name='' then Exit;
  for I := 0 to High(fPins) do
      fPins[i]:=ConfigFile.ReadInteger(Name, PNames[i], UndefinedPin);
end;

procedure TPins.ReadFromIniFile(ConfigFile: TIniFile; Strings: TStrings);
 var i,TempPin:integer;
begin
  if Name='' then Exit;
  for I := 0 to High(fPins) do
   begin
    TempPin := ConfigFile.ReadInteger(Name, PNames[i], -1);
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
        ConfigFile.WriteInteger(Name, PNames[j], i);
end;

procedure TPins.WriteToIniFile(ConfigFile: TIniFile);
 var i:integer;
begin
  if Name='' then Exit;
  ConfigFile.EraseSection(Name);
  for I := 0 to High(fPins) do
     WriteIniDef(ConfigFile,Name,PNames[i], UndefinedPin);
end;

procedure TPins.SetPin(Index: integer; value: byte);
begin
  fPins[Index]:=value;
end;

procedure TPins.WriteToIniFile(ConfigFile: TIniFile;
                PinsComboBoxs: array of TComboBox);
  var i,j:integer;
begin
  if Name='' then Exit;
  ConfigFile.EraseSection(Name);

   for j := 0 to High(fPins) do
     begin
     if j<=High(PinsComboBoxs) then
        begin
          for I := 0 to PinsComboBoxs[j].Items.Count - 1 do
           if (fPins[j] = strtoint( PinsComboBoxs[j].Items[i])) then
                ConfigFile.WriteInteger(Name, PNames[j], i);
        end;
     end;
end;

procedure TPins.WriteToIniFile(ConfigFile: TIniFile;
  PinsStrings: array of TStringList);
  var i,j:integer;
begin
  if Name='' then Exit;
  ConfigFile.EraseSection(Name);

   for j := 0 to High(fPins) do
     begin
     if j<=High(PinsStrings) then
        begin
          for I := 0 to PinsStrings[j].Count - 1 do
           if (fPins[j] = strtoint( PinsStrings[j].Strings[i])) then
                ConfigFile.WriteInteger(Name, PNames[j], i);
        end;
     end;

end;


{ TArduinoDAC }


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
  PinsCreate();
//  Pins.Name:=Nm;
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

procedure TArduinoDAC.PinsCreate();
begin
  Pins := TPins.Create(Name);
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
  PinsCreate();
  fComPacket.StartString:=PacketBeginChar;
  fComPacket.StopString:=PacketEndChar;
end;

procedure TArduinoRS232Device.Free;
begin
 Pins.Free;
 inherited Free;
end;

procedure TArduinoRS232Device.PinsCreate();
begin
  Pins := TPins.Create(Name);
end;

{ TArduinoPinChanger }

constructor TArduinoPinChanger.Create(CP: TComPort; Nm: string);
begin
 inherited Create(CP,Nm);
 fDeviceKod:=PinChangeCommand;
// SetLength(Pins.fPins,1);
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

procedure TArduinoPinChanger.PinsCreate;
begin
 Pins := TPins.Create(Name,1);
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
//  inherited Create(APC.Pins,ControlPinLabel,nil,SetControlButton,nil,PCB);
  inherited Create(APC.Pins,ControlPinLabel,SetControlButton,PCB);
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
                                ControlPinLabel: TLabel;
                                SetControlButton: TButton;
                                PCB: TComboBox);
begin
 inherited Create(Ps,[ControlPinLabel],[SetControlButton],[PCB]);
// inherited Create(Ps,ControlPinLabel,nil,SetControlButton,nil,PCB);
end;

{ TTMP102PinsShow }

constructor TI2C_PinsShow.Create(Ps: TPins;
                 ControlPinLabel: TLabel; SetControlButton: TButton;
                 PCB: TComboBox; StartAdress, LastAdress: Byte);
 var adress:byte;
begin
 inherited Create(Ps,ControlPinLabel,SetControlButton,PCB);
 PCB.Items.Clear;
 for adress := StartAdress to LastAdress do
   PCB.Items.Add('$'+IntToHex(adress,2));

// PCB.Items.Add('$48');
// PCB.Items.Add('$49');
// PCB.Items.Add('$4A');
// PCB.Items.Add('$4B');
// SetControlButton.Caption:=('set adress');
end;

//procedure TI2C_PinsShow.NumberPinShow;
//begin
//
//   PinLabels[0].Caption:='Adress is ';
//   if Pins.fPins[0]=UndefinedPin then
//       PinLabels[0].Caption:=
//          PinLabels[0].Caption+'undefined'
//                            else
//       PinLabels[0].Caption:=
//          PinLabels[0].Caption+'$'+IntToHex(Pins.fPins[0],2);
//end;

//procedure TI2C_PinsShow.PinsReadFromIniFile(ConfigFile: TIniFile);
// var TempPin:integer;
//begin
//  Pins.ReadFromIniFile(ConfigFile,PinsComboBoxs);
//
////  Pins.ReadFromIniFile(ConfigFile,PinsComboBoxs[0].Items);
//  if Pins.Name='' then Exit;
//  TempPin := ConfigFile.ReadInteger(Pins.Name, 'Adress', -1);
//    if (TempPin > -1) and (TempPin < PinsComboBoxs[0].Items.Count) then
//      Pins.fPins[0] := StrToInt(PinsComboBoxs[0].Items[TempPin]);
//end;
//
//procedure TI2C_PinsShow.PinsWriteToIniFile(ConfigFile: TIniFile);
// var i:byte;
//begin
//    Pins.WriteToIniFile(ConfigFile,PinsComboBoxs);
//
////    Pins.WriteToIniFile(ConfigFile,PinsComboBox.Items);
//  if Pins.Name='' then Exit;
//  ConfigFile.EraseSection(Pins.Name);
//  for I := 0 to PinsComboBoxs[0].Items.Count - 1 do
//    if (Pins.fPins[0] = strtoint(PinsComboBoxs[0].Items[i])) then
//        ConfigFile.WriteInteger(Pins.Name, 'Adress', i);
//end;


//  if Name='' then Exit;
//  ConfigFile.EraseSection(Name);
//
//   for j := 0 to High(fPins) do
//     begin
//     if j<=High(PinsComboBoxs) then
//        begin
//          for I := 0 to PinsComboBoxs[j].Items.Count - 1 do
//           if (IntToStr(fPins[j]) = PinsComboBoxs[j].Items[i]) then
//                ConfigFile.WriteInteger(Name, PNames[j], i);
//        end;
//     end;

{ TPinsShowUniversal }

constructor TPinsShowUniversal.Create(Ps: TPins; PinLs: array of TLabel;
      SetPBs: array of TButton; PinCBs: array of TComboBox);
 var i:byte;
begin
 inherited Create();
 Pins:=Ps;
 SetLength(PinLabels,High(PinLs)+1);
 for I := 0 to High(PinLabels) do
  PinLabels[i]:=PinLs[i];

 SetLength(SetPinButtons,High(SetPBs)+1);
 for I := 0 to High(SetPinButtons) do
  SetPinButtons[i]:=SetPBs[i];

 SetLength(PinsComboBoxs,High(PinCBs)+1);
 for I := 0 to High(PinsComboBoxs) do
  PinsComboBoxs[i]:=PinCBs[i];

 HookNumberPinShow:=TSimpleClass.EmptyProcedure;
 CreateFooter();
end;

procedure TPinsShowUniversal.CreateFooter;
 var  i: Integer;
begin
  for I := 0 to High(SetPinButtons) do
    begin
    SetPinButtons[i].OnClick := TAdapterSetButton.Create(PinsComboBoxs[i], Pins, i, NumberPinShow).SetButtonClick;
    SetPinButtons[i].Caption := 'set ' + LowerCase(Pins.PNames[i]);
    end;
end;

procedure TPinsShowUniversal.NumberPinShow;
  var i:byte;
begin
  for I := 0 to High(PinLabels) do
   PinLabels[i].Caption:=Pins.GetPinStr(i);
   HookNumberPinShow;
end;

procedure TPinsShowUniversal.PinsReadFromIniFile(ConfigFile: TIniFile);
begin
  Pins.ReadFromIniFile(ConfigFile,PinsComboBoxs);
end;

procedure TPinsShowUniversal.PinsWriteToIniFile(ConfigFile: TIniFile);
begin
 Pins.WriteToIniFile(ConfigFile,PinsComboBoxs);
end;



{ TPins_I2C }

constructor TPins_I2C.Create(Nm: string);
begin
  inherited Create(Nm,['Adress'],1);
  PinStrPart:=''
end;

function TPins_I2C.PinValueToStr(Index: integer): string;
begin
 Result:='$'+IntToHex(fPins[Index],2);
end;

{ TPinsShowShot }

constructor TPinsShowShot.Create(Ps: TPins; PinLs: array of TLabel);
 var i:byte;
begin
  inherited Create();
 Pins:=Ps;
 SetLength(PinLabels,High(PinLs)+1);
 for I := 0 to High(PinLabels) do
  begin
  PinLabels[i]:=PinLs[i];
  PinLabels[i].Tag:=i;
  end;
 SetLength(fPinVariants,High(PinLs)+1);
 for I := 0 to High(fPinVariants) do
  begin
  fPinVariants[i]:=TStringList.Create;
  fPinVariants[i].Clear;
  end;

 HookNumberPinShow:=TSimpleClass.EmptyProcedure;
 CreateFooter();
end;

procedure TPinsShowShot.CreateFooter;
 var  i: Integer;
begin
  for I := 0 to High(PinLabels) do
    begin
    PinLabels[i].Caption:=Pins.GetPinStr(i);
    PinLabels[i].Cursor:=crHandPoint;
    PinLabels[i].OnClick:=VariantsShowAndSelect;
    end;
end;

procedure TPinsShowShot.Free;
 var i:byte;
begin
 for I := 0 to High(fPinVariants) do
   begin
   fPinVariants[i]:=nil;
   fPinVariants[i].Free;
   end;
// inherited Free;
end;

//function TPinsShowShot.GetVariants(Index: byte): TStringList;
//begin
//  if (Index > High(fPinVariants)) then
//          Result:=nil
//                                  else
//          Result := fPinVariants[Index];
//end;

procedure TPinsShowShot.NumberPinShow;
 var i:byte;
begin
  for I := 0 to High(PinLabels) do
   PinLabels[i].Caption:=Pins.GetPinStr(i);
   HookNumberPinShow;
end;

procedure TPinsShowShot.PinsReadFromIniFile(ConfigFile: TIniFile);
begin
  Pins.ReadFromIniFile(ConfigFile,fPinVariants);
end;

procedure TPinsShowShot.PinsWriteToIniFile(ConfigFile: TIniFile);
begin
 Pins.WriteToIniFile(ConfigFile,fPinVariants);
end;

procedure TPinsShowShot.SetVariants(Index: byte; const S: TStringList);
begin
   if (Index <= High(fPinVariants)) then
     fPinVariants[Index]:=S;
end;

procedure TPinsShowShot.VariantsShowAndSelect(Sender: TObject);
var Form:TForm;
    ButOk,ButCancel: TButton;
    RG:TRadioGroup;
    PinNumber:byte;
    i:integer;
begin
 if (Sender is TLabel) then
   PinNumber:=(Sender as TLabel).Tag
                       else
   PinNumber:=0;

 Form:=TForm.Create(Application);
 Form.Position:=poMainFormCenter;
 Form.AutoScroll:=True;
 Form.BorderIcons:=[biSystemMenu];
 Form.ParentFont:=True;
 Form.Font.Style:=[fsBold];
 Form.Font.Height:=-16;
 Form.Caption:='Set ' + LowerCase(Pins.PNames[PinNumber]);
 RG:=TRadioGroup.Create(Form);
 RG.Parent:=Form;
 RG.Items:=fPinVariants[PinNumber];
 for I := 0 to RG.Items.Count - 1 do
  if StrToInt(RG.Items[i])=Pins.fPins[PinNumber] then
   begin
     RG.ItemIndex:=i;
     Break;
   end;


 if RG.Items.Count>8 then  RG.Columns:=3
                     else  RG.Columns:=2;
 RG.Width:=RG.Columns*120+20;
 RG.Height:=Ceil(RG.Items.Count/RG.Columns)*40+20;
 Form.Width:=RG.Width;
 Form.Height:=RG.Height+70;
  RG.Align:=alTop;

 ButOk:=TButton.Create(Form);
 ButOk.Parent:=Form;
 ButOk.ParentFont:=True;
 ButOk.Height:=30;
 ButOk.Width:=79;
 ButOk.Caption:='Ok';
 ButOk.ModalResult:=mrOk;
 ButOk.Top:=RG.Height+10;
 ButOk.Left:=round((Form.Width-2*ButOk.Width)/3.0);

 ButCancel:=TButton.Create(Form);
 ButCancel.Parent:=Form;
 ButCancel.ParentFont:=True;
 ButCancel.Height:=30;
 ButCancel.Width:=79;
 ButCancel.Caption:='Cancel';
 ButCancel.ModalResult:=mrCancel;
 ButCancel.Top:=RG.Height+10;
 ButCancel.Left:=2*ButOk.Left+ButOk.Width;

  if Form.ShowModal=mrOk then
   begin
    Pins.fPins[PinNumber]:=StrToInt(RG.Items[RG.ItemIndex]);
    NumberPinShow();
   end;

// RG.Items:=nil;
 for I := Form.ComponentCount-1 downto 0 do
     Form.Components[i].Free;
 Form.Hide;
 Form.Release;

end;





end.
