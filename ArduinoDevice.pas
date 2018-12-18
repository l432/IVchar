unit ArduinoDevice;

interface
 uses OlegType,CPort,SysUtils,Classes,PacketParameters,
      StdCtrls, IniFiles, RS232device, ExtCtrls, Measurement;

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
   Function StrToPinValue(Str: string):integer;virtual;
   procedure SetStrToPinValue(Str: string;Index:integer);
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
   Constructor Create(Nm:string);overload;
   Constructor Create(Nm:string;PNm:array of string;PNumber:byte);overload;
   Constructor Create(Nm:string;PNm:array of string);overload;
   Constructor Create(Nm:string;PNumber:byte);overload;
   Procedure ReadFromIniFile(ConfigFile:TIniFile);overload;
   Procedure ReadFromIniFile(ConfigFile:TIniFile;Strings:TStrings);overload;
   Procedure ReadFromIniFile(ConfigFile:TIniFile;PinsStrings:array of TStringList);overload;
   Procedure WriteToIniFile(ConfigFile:TIniFile);overload;
   Procedure WriteToIniFile(ConfigFile:TIniFile;Strings:TStrings);overload;
   Procedure WriteToIniFile(ConfigFile:TIniFile;PinsStrings:array of TStringList);overload;
  end;


  TPins_I2C=class(TPins)
  protected
   Function PinValueToStr(Index:integer):string;override;
   public
   Constructor Create(Nm:string);
  end;


  TPinsShowUniversal=class
  protected
   fHookNumberPinShow: TSimpleEvent;
   PinLabels:array of TPanel;
   fPinVariants:array of TStringList;
   procedure CreateFooter;virtual;
    procedure SetVariants(Index: byte; const S: TStringList);
  public
//   fPinVariants:array of TStringList;
   Pins:TPins;
   property HookNumberPinShow:TSimpleEvent read fHookNumberPinShow write fHookNumberPinShow;
   property PinVariants[Index: byte]: TStringList write SetVariants;
   Constructor Create(Ps:TPins;
                      PinLs:array of TPanel);overload;
   Constructor Create(Ps:TPins;
                      PinLs:array of TPanel;
                      PinVar:array of TStringList);overload;
   Constructor Create(Ps:TPins;
                      PinLs:array of TPanel;
                      PinVarSingle: TStringList);overload;
   procedure PinsReadFromIniFile(ConfigFile:TIniFile);virtual;
   procedure PinsWriteToIniFile(ConfigFile:TIniFile);virtual;
   procedure NumberPinShow();virtual;
   procedure Free();
   procedure VariantsShowAndSelect(Sender: TObject);
  end;


  TArduinoRS232Device=class(TRS232Device)
  protected
   fDeviceKod:byte;
   procedure PinsCreate();virtual;
  public
   Pins:TPins;
   Constructor Create(CP:TComPort;Nm:string);//override;
   procedure Free;
  end;

 TArduinoPinChanger=class(TArduinoRS232Device)
  protected
   fPinUnderControl:byte;
   procedure   PacketCreateToSend(); override;
   procedure PinsCreate();override;
  public
   property PinUnderControl:byte read fPinUnderControl write fPinUnderControl;
   Constructor Create(CP:TComPort;Nm:string);//override;
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
   Constructor Create(CP:TComPort;Nm:string);//override;
   Procedure Free;
  end;


  TArduinoSetter=class(TRS232Device)
    {базовий клас для джерел сигналів, що керуються
    за допомогою Arduino    }
  protected
   fSetterKod:byte;
   procedure PinsCreate();virtual;
//   procedure PacketCreateAndSend();

   procedure CreateHook;virtual;
   procedure PacketCreateToSend(); override;
  public
   Pins:TPins;
   Constructor Create(CP:TComPort;Nm:string);//override;
   Procedure Free;
   procedure PinsToDataArray;virtual;   
  end;


  TArduinoDAC=class(TArduinoSetter,IDAC)
    {базовий клас для ЦАП, що керується
    за допомогою Arduino    }
  protected
   fOutputValue:double;
//   Pins:TPins;
   fVoltageMaxValue:double;
   fKodMaxValue:integer;
//   fSetterKod:byte;
//   procedure PinsCreate();virtual;
//   procedure PacketCreateAndSend();
   function  VoltageToKod(Voltage:double):integer;virtual;
   procedure DataByteToSendFromInteger(IntData: Integer);virtual;
//   procedure PinsToDataArray;virtual;
   procedure OutputDataSignDetermination(OutputData: Double);
   procedure CreateHook;override;
   function NormedKod(Kod: Integer):integer;
//   procedure   PacketCreateToSend(); override;
   function GetOutputValue:double;
  public
   property OutputValue:double read GetOutputValue;
//   Constructor Create(CP:TComPort;Nm:string);override;
//   Procedure Free;
   Procedure Output(Voltage:double);virtual;
   Procedure Reset();virtual;
   Procedure OutputInt(Kod:integer);virtual;
  end;




implementation

uses
  Math, Forms, Graphics, Controls, OlegFunction;


{ TArduinoMeter }

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

constructor TPins.Create(Nm: string);
begin
 Create(Nm,PinNames,2);
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
          SetStrToPinValue (PinsStrings[i].Strings[TempPin],i )
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


function TPins.StrToPinValue(Str: string): integer;
begin
 Result:=StrToInt(Str);
end;

procedure TPins.SetStrToPinValue(Str: string;Index:integer);
begin
 fPins[Index]:=StrToPinValue(Str);
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
           if (fPins[j] = StrToPinValue ( PinsStrings[j].Strings[i])) then
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
  inherited CreateHook;
  fVoltageMaxValue:=5;
  fKodMaxValue:=65535;
end;

procedure TArduinoDAC.OutputDataSignDetermination(OutputData: Double);
begin
  if OutputData < 0 then  fData[5] := DAC_Neg
                    else  fData[5] := DAC_Pos;
end;

//procedure TArduinoDAC.PinsToDataArray;
//begin
//  fData[1] := Pins.PinControl;
//  fData[2] := Pins.PinGate;
//end;

//constructor TArduinoDAC.Create(CP: TComPort; Nm: string);
//begin
//  inherited Create(CP,Nm);
//  PinsCreate();
//  fComPacket.StartString:=PacketBeginChar;
//  fComPacket.StopString:=PacketEndChar;
//
//  CreateHook;
//  SetLength(fData,6);
//  fData[0] := fSetterKod;
//  PinsToDataArray();
//end;

procedure TArduinoDAC.DataByteToSendFromInteger(IntData: Integer);
 var NormedIntData:integer;
begin
  NormedIntData:=NormedKod(IntData);
  fData[3] := ((NormedIntData shr 8) and $FF);
  fData[4] := (NormedIntData and $FF);
end;

//procedure TArduinoDAC.Free;
//begin
// Pins.Free;
// inherited Free;
//end;

function TArduinoDAC.GetOutputValue: double;
begin
  Result:=fOutputValue;
end;

procedure TArduinoDAC.Output(Voltage: double);
begin
 if Voltage=ErResult then Exit;
 OutputDataSignDetermination(Voltage);
 DataByteToSendFromInteger(VoltageToKod(Voltage));
 isNeededComPortState();
// PacketCreateAndSend();
end;

procedure TArduinoDAC.OutputInt(Kod: integer);
begin
// inherited OutputInt(Kod);
 fOutputValue:=Kod;
 OutputDataSignDetermination(Kod);
 DataByteToSendFromInteger(abs(Kod));
// PacketCreateAndSend();
 isNeededComPortState();
end;

//procedure TArduinoDAC.PinsCreate();
//begin
//  Pins := TPins.Create(Name);
//end;

//procedure TArduinoDAC.PacketCreateAndSend;
//begin
//  isNeededComPortState();
//end;

//procedure TArduinoDAC.PacketCreateToSend;
//begin
// PacketCreate(fData);
//end;

procedure TArduinoDAC.Reset;
begin
 fData[5]:=DAC_Pos;
 fData[3] := $00;
 fData[4] := $00;
// PacketCreateAndSend();
 isNeededComPortState();
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
 PinUnderControl:=PinToHigh;
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


{ TArduinoSetter }

constructor TArduinoSetter.Create(CP: TComPort; Nm: string);
begin
  inherited Create(CP,Nm);
  PinsCreate();
  fComPacket.StartString:=PacketBeginChar;
  fComPacket.StopString:=PacketEndChar;
  SetLength(fData,6);

  CreateHook;
  fData[0] := fSetterKod;
  PinsToDataArray();
//showmessage(Name);
end;

procedure TArduinoSetter.CreateHook;
begin
  fSetterKod:=$FF;
end;

procedure TArduinoSetter.Free;
begin
 Pins.Free;
 inherited Free;
end;

//procedure TArduinoSetter.PacketCreateAndSend;
//begin
//  isNeededComPortState();
//end;

procedure TArduinoSetter.PacketCreateToSend;
begin
 PacketCreate(fData);
end;

procedure TArduinoSetter.PinsCreate;
begin
  Pins := TPins.Create(Name);
end;

procedure TArduinoSetter.PinsToDataArray;
begin
  fData[1] := Pins.PinControl;
end;

{ TPinsShowShot }

constructor TPinsShowUniversal.Create(Ps: TPins;
                          PinLs: array of TPanel);
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

constructor TPinsShowUniversal.Create(Ps: TPins;
                      PinLs: array of TPanel;
                      PinVar: array of TStringList);
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

 SetLength(fPinVariants,High(PinLabels)+1);
 for I := 0 to High(fPinVariants) do
  begin
  fPinVariants[i]:=TStringList.Create;
  fPinVariants[i].Clear;
  if i<High(PinVar) then fPinVariants[i]:=PinVar[i]
                    else fPinVariants[i]:=PinVar[High(PinVar)];
  end;

 HookNumberPinShow:=TSimpleClass.EmptyProcedure;
 CreateFooter();

end;

constructor TPinsShowUniversal.Create(Ps: TPins;
                                      PinLs: array of TPanel;
                                      PinVarSingle: TStringList);
begin
 Create(Ps,PinLs,[PinVarSingle]);
end;

procedure TPinsShowUniversal.CreateFooter;
 var  i: Integer;
begin
  for I := 0 to High(PinLabels) do
    begin
    PinLabels[i].Caption:=Pins.GetPinStr(i);
    PinLabels[i].Cursor:=crHandPoint;
    PinLabels[i].Font.Color:=clActiveCaption;
    PinLabels[i].OnClick:=VariantsShowAndSelect;
    end;
end;

procedure TPinsShowUniversal.Free;
 var i:byte;
begin
 for I := 0 to High(fPinVariants) do
   begin
   fPinVariants[i]:=nil;
   fPinVariants[i].Free;
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
  Pins.ReadFromIniFile(ConfigFile,fPinVariants);
end;

procedure TPinsShowUniversal.PinsWriteToIniFile(ConfigFile: TIniFile);
begin
 Pins.WriteToIniFile(ConfigFile,fPinVariants);
end;

procedure TPinsShowUniversal.SetVariants(Index: byte; const S: TStringList);
begin
   if (Index <= High(fPinVariants)) then
     fPinVariants[Index]:=S;
end;

procedure TPinsShowUniversal.VariantsShowAndSelect(Sender: TObject);
var //Form:TForm;
//    ButOk,ButCancel: TButton;
//    RG:TRadioGroup;
    PinNumber:byte;
    index:shortint;
    i:integer;
begin
 if (Sender is TPanel) then
   PinNumber:=(Sender as TPanel).Tag
                       else
   PinNumber:=0;

 index:=-1;
 for I := 0 to fPinVariants[PinNumber].Count - 1 do
  if Pins.StrToPinValue(fPinVariants[PinNumber].Strings[i])=Pins.fPins[PinNumber] then
   begin
     index:=i;
     Break;
   end;


i:=SelectFromVariants(fPinVariants[PinNumber],index,
                   'Set ' + LowerCase(Pins.PNames[PinNumber]+Pins.PinStrPart));

if i>-1 then
  begin
    Pins.SetStrToPinValue(fPinVariants[PinNumber].Strings[i],PinNumber);
    NumberPinShow();
  end;

// if (Sender is TPanel) then
//   PinNumber:=(Sender as TPanel).Tag
//                       else
//   PinNumber:=0;
//
// Form:=TForm.Create(Application);
// Form.Position:=poMainFormCenter;
// Form.AutoScroll:=True;
// Form.BorderIcons:=[biSystemMenu];
// Form.ParentFont:=True;
// Form.Font.Style:=[fsBold];
// Form.Font.Height:=-16;
// Form.Caption:='Set ' + LowerCase(Pins.PNames[PinNumber]+Pins.PinStrPart);
// Form.Color:=clMoneyGreen;
// RG:=TRadioGroup.Create(Form);
// RG.Parent:=Form;
// RG.Items:=fPinVariants[PinNumber];
// for I := 0 to RG.Items.Count - 1 do
//  if Pins.StrToPinValue(RG.Items[i])=Pins.fPins[PinNumber] then
//   begin
//     RG.ItemIndex:=i;
//     Break;
//   end;
//
//
// if RG.Items.Count>8 then  RG.Columns:=3
//                     else  RG.Columns:=2;
// RG.Width:=RG.Columns*200+20;
// RG.Height:=Ceil(RG.Items.Count/RG.Columns)*50+20;
// Form.Width:=RG.Width;
// Form.Height:=RG.Height+100;
//  RG.Align:=alTop;
//
// ButOk:=TButton.Create(Form);
// ButOk.Parent:=Form;
// ButOk.ParentFont:=True;
// ButOk.Height:=30;
// ButOk.Width:=79;
// ButOk.Caption:='Ok';
// ButOk.ModalResult:=mrOk;
// ButOk.Top:=RG.Height+10;
// ButOk.Left:=round((Form.Width-2*ButOk.Width)/3.0);
//
// ButCancel:=TButton.Create(Form);
// ButCancel.Parent:=Form;
// ButCancel.ParentFont:=True;
// ButCancel.Height:=30;
// ButCancel.Width:=79;
// ButCancel.Caption:='Cancel';
// ButCancel.ModalResult:=mrCancel;
// ButCancel.Top:=RG.Height+10;
// ButCancel.Left:=2*ButOk.Left+ButOk.Width;
//
//  if Form.ShowModal=mrOk then
//   begin
//    Pins.SetStrToPinValue(RG.Items[RG.ItemIndex],PinNumber);
//    NumberPinShow();
//   end;
//
// for I := Form.ComponentCount-1 downto 0 do
//     Form.Components[i].Free;
// Form.Hide;
// Form.Release;

end;



end.
