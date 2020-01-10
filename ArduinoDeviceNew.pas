unit ArduinoDeviceNew;

interface
 uses OlegType,CPort,SysUtils,Classes,PacketParameters,
      StdCtrls, IniFiles, ExtCtrls, Measurement,
      OlegTypePart2, RS232deviceNew;

const
  UndefinedPin=255;
  PacketBeginChar=#10;
  PacketEndChar=#15;


  PinNames:array[0..3]of string=
   ('Control','Gate','LDAC','CLR');

  DAC_Pos=$0F; //додатня напруга
  DAC_Neg=$FF; //від'ємна напруга

  PinChangeCommand=$7;
  PinToHigh=$F0;
  PinToLow=$0F;


type
  IArduinoSender = interface
   ['{4E78ACBE-DD15-483D-8493-4B08E3E94454}']
    function GetisNeededComPort:boolean;
    procedure SetisNeededComPort(const Value:boolean);
    procedure  PacketCreateToSend();
    procedure SetError(const Value:boolean);
    function GetMessageError:string;
    property isNeededComPort:boolean read GetisNeededComPort write SetisNeededComPort;
    property Error:boolean write SetError;
    property MessageError:string read GetMessageError;
  end;


  IArduinoDevice = interface (IRS232DataObserver)
    ['{2FE4C890-9B48-4605-8593-EA54EF1A5742}']
    function GetDeviceKod:byte;
    function GetSecondDeviceKod:byte;
    property DeviceKod:byte read GetDeviceKod;
    property SecondDeviceKod:byte read GetSecondDeviceKod;
  end;

  IArduinoDataSubject = interface
     ['{F65EA0F8-5554-49E4-A5AB-5EDE666FE72B}']
    procedure RegisterObserver(o:IArduinoDevice);
    procedure RemoveObserver(o:IArduinoDevice);
  end;


  TRS232_Arduino=class(TRS232)
    {початкові налаштування COM-порту}
    protected
    public
     Constructor Create(CP:TComPort);
    end;

  TArduinoDataSubject=class(TRS232DataSubjectBase,IArduinoDataSubject,IRS232DataSubject)
   private
    function ObserverIsRegistered(o:IArduinoDevice):boolean;
   protected
    Observers:array of IArduinoDevice;
    procedure ComPortCreare(CP:TComPort);override;
   public
    ReceivedData:TArrByte;
    procedure RegisterObserver(o:IArduinoDevice);
    procedure RemoveObserver(o:IArduinoDevice);
    procedure NotifyObservers;override;
  end;



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

  TPinsForCustomValues=class(TPins)
   protected
    Function GetPinStr(Index:integer):string;override;
   public
    Constructor Create(Nm:string;PNm:array of string);
  end;


  TPinsShowUniversal=class(TSimpleFreeAndAiniObject)
  protected
   fHookNumberPinShow: TSimpleEvent;
   PinLabels:array of TPanel;
   fPinVariants:array of TStringList;
   procedure CreateFooter;virtual;
   procedure SetVariants(Index: byte; const S: TStringList);
  public
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
   procedure ReadFromIniFile(ConfigFile:TIniFile);override;//virtual;
   procedure WriteToIniFile(ConfigFile:TIniFile);override;//virtual;
   procedure NumberPinShow();virtual;
   procedure Free();//override;//virtual;
   procedure VariantsShowAndSelect(Sender: TObject);
  end;

  TArduinoSetter=class(TRS232CustomDevice,IArduinoSender)
    {базовий клас для джерел сигналів, що керуються
    за допомогою Arduino    }
  protected
   fSetterKod:byte;
   fisNeededComPort:boolean;
   procedure PinsCreate();virtual;
   procedure CreateHook;virtual;
   function GetisNeededComPort:boolean;
   procedure SetisNeededComPort(const Value:boolean);
  public
   Pins:TPins;
   property isNeededComPort:boolean read GetisNeededComPort write SetisNeededComPort;
   procedure PacketCreateToSend(); virtual;
   Constructor Create(Nm:string);//override;
   Procedure Free;//virtual;//override;
   procedure PinsToDataArray;virtual;
   procedure isNeededComPortState();
  end;

 TArduinoPinChanger=class(TArduinoSetter)
  protected
   fPinUnderControl:byte;
   procedure PinsCreate();override;
  public
   procedure   PacketCreateToSend(); override;
   property PinUnderControl:byte read fPinUnderControl write fPinUnderControl;
   Constructor Create(Nm:string);//override;
   procedure PinChangeToHigh();
   procedure PinChangeToLow();
  end;

 TArduinoDataRequest = class
  public
  procedure Request;virtual;abstract;
 end;

  TArduinoMeter=class(TRS232MeterDevice,IArduinoSender,IArduinoDevice)
  {базовий клас для вимірювальних об'єктів,
  які використовують обмін даних з Arduino}
  protected
   fMetterKod:byte;
   fisNeededComPort:boolean;
   fArduinoDataSubject:TArduinoDataSubject;
   fRequestState:TArduinoDataRequest;
   fInitRequestState:TArduinoDataRequest;
   fAddedRequestState:TArduinoDataRequest;
   fWorkRequestState:TArduinoDataRequest;
   procedure PinsCreate();virtual;
   function GetisNeededComPort:boolean;
   procedure SetisNeededComPort(const Value:boolean);
   procedure UpDate ();override;
   function GetDeviceKod:byte;
   function GetSecondDeviceKod:byte;
  public
   Pins:TPins;
   property isNeededComPort:boolean read GetisNeededComPort write SetisNeededComPort;
   property DeviceKod:byte read GetDeviceKod;
   property SecondDeviceKod:byte read GetSecondDeviceKod;
   procedure   PacketCreateToSend(); virtual;
   Constructor Create(Nm:string);//override;
   Procedure Free;//override;
   procedure isNeededComPortState();
   procedure Request();override;
   Procedure ConvertToValue();virtual;abstract;
   procedure AddDataSubject(DataSubject:TArduinoDataSubject);
  end;

 TInitRequestState = class(TArduinoDataRequest)
  public
  procedure Request;override;
 end;

 TWorkRequestState = class(TArduinoDataRequest)
  private
   fArduinoMeter:TArduinoMeter;
  public
   procedure Request;override;
   Constructor Create(ArduinoMeter:TArduinoMeter);
 end;

 TAddedRequestState= class(TWorkRequestState)
  public
   procedure Request;override;
 end;

  TArduinoDAC=class(TArduinoSetter,IDAC)
    {базовий клас для ЦАП, що керується
    за допомогою Arduino    }
  protected
   fOutputValue:double;
   fVoltageMaxValue:double;
   fKodMaxValue:integer;
   function  VoltageToKod(Voltage:double):integer;virtual;
   procedure DataByteToSendFromInteger(IntData: Integer);virtual;
   procedure OutputDataSignDetermination(OutputData: Double);
   procedure CreateHook;override;
   function NormedKod(Kod: Integer):integer;
   function GetOutputValue:double;
  public
   property OutputValue:double read GetOutputValue;
   Procedure Output(Voltage:double);virtual;
   Procedure Reset();virtual;
   Procedure OutputInt(Kod:integer);virtual;
  end;

//var
// ArduinoDataSubject:TArduinoDataSubject;

implementation

uses
  Math, Forms, Graphics, Controls, OlegFunction,
  HighResolutionTimer, Dialogs,
  Windows;

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


{ TArduinoDACnew }


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

procedure TArduinoDAC.DataByteToSendFromInteger(IntData: Integer);
 var NormedIntData:integer;
begin
  NormedIntData:=NormedKod(IntData);
  fData[3] := ((NormedIntData shr 8) and $FF);
  fData[4] := (NormedIntData and $FF);
end;

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
end;

procedure TArduinoDAC.OutputInt(Kod: integer);
begin
 fOutputValue:=Kod;
 OutputDataSignDetermination(Kod);
 DataByteToSendFromInteger(abs(Kod));
 isNeededComPortState();
end;


procedure TArduinoDAC.Reset;
begin
 fData[5]:=DAC_Pos;
 fData[3] := $00;
 fData[4] := $00;
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

{ TArduinoPinChangerNew }

constructor TArduinoPinChanger.Create(Nm: string);
begin
 inherited Create(Nm);
 fSetterKod:=PinChangeCommand;
 PinUnderControl:=PinToHigh;
end;


procedure TArduinoPinChanger.PacketCreateToSend;
begin
 PacketCreate([fSetterKod,Pins.PinControl,PinUnderControl]);
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
 for I := 0 to High(PinLabels) do PinLabels[i]:=nil;
 fHookNumberPinShow:=nil;

 for I := 0 to High(fPinVariants) do
   begin
   fPinVariants[i]:=nil;
   fPinVariants[i].Free;
   end;
  inherited;
end;


procedure TPinsShowUniversal.NumberPinShow;
 var i:byte;
begin
  for I := 0 to High(PinLabels) do
   PinLabels[i].Caption:=Pins.GetPinStr(i);
   HookNumberPinShow;
end;

procedure TPinsShowUniversal.ReadFromIniFile(ConfigFile: TIniFile);
begin
  Pins.ReadFromIniFile(ConfigFile,fPinVariants);
  NumberPinShow();
end;

procedure TPinsShowUniversal.WriteToIniFile(ConfigFile: TIniFile);
begin
 Pins.WriteToIniFile(ConfigFile,fPinVariants);
end;

procedure TPinsShowUniversal.SetVariants(Index: byte; const S: TStringList);
begin
   if (Index <= High(fPinVariants)) then
     fPinVariants[Index]:=S;
end;

procedure TPinsShowUniversal.VariantsShowAndSelect(Sender: TObject);
var
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

end;



{ TPinsForCustomValues }

constructor TPinsForCustomValues.Create(Nm: string; PNm: array of string);
begin
 inherited Create(Nm, PNm);
 PinStrPart := '';
end;

function TPinsForCustomValues.GetPinStr(Index: integer): string;
begin
 if fPins[Index]=UndefinedPin then
   Result:=PNames[Index] +' is undefined'
                              else
   Result:=PinValueToStr(Index);
end;


{ TRS232_Arduino }

constructor TRS232_Arduino.Create(CP: TComPort);
begin
 inherited Create(CP,PacketBeginChar,PacketEndChar);
end;

{ TArduinoDataSubject }

procedure TArduinoDataSubject.ComPortCreare(CP: TComPort);
begin
 fRS232:=TRS232_Arduino.Create(CP);
end;

procedure TArduinoDataSubject.NotifyObservers;
 var Kod,SecondKod:byte;
     i:integer;
begin
 if not(PacketIsReceived(ReceivedString,ReceivedData)) then Exit;
 Kod:=ReceivedData[1];
 SecondKod:=ReceivedData[2];
 RS232.ComPort.ClearBuffer(True, False);
 for I := 0 to High(ReceivedData)-4 do
   ReceivedData[i]:=ReceivedData[i+3];
 SetLength(ReceivedData,High(ReceivedData)-3);
 for I := 0 to High(Observers) do
  if (Observers[i].DeviceKod=Kod)
      and(Observers[i].SecondDeviceKod=SecondKod) then
      begin
       Observers[i].UpDate;
       Break;
      end;
end;

function TArduinoDataSubject.ObserverIsRegistered(o:IArduinoDevice): boolean;
 var i:integer;
begin
 Result:=False;
 for i:=0 to High(Observers)
   do Result:=(Result or ((Observers[i].DeviceKod=o.DeviceKod)
                            and(Observers[i].SecondDeviceKod=o.SecondDeviceKod)));
end;

procedure TArduinoDataSubject.RegisterObserver(o: IArduinoDevice);

begin
 if (not ObserverIsRegistered(o)) then
   begin
    SetLength(Observers,High(Observers)+2);
    Observers[High(Observers)]:=o;
   end;
end;

procedure TArduinoDataSubject.RemoveObserver(o: IArduinoDevice);
  var i,j:integer;
begin
 for i:=0 to High(Observers) do
   if (Observers[i].DeviceKod=o.DeviceKod)
      and (Observers[i].SecondDeviceKod=o.SecondDeviceKod) then
     begin
       for j := i to High(Observers)-1 do Observers[j]:=Observers[j+1];
       SetLength(Observers,High(Observers)-1);
       Break;
     end;
end;


{ TArduinoSetterNew }

constructor TArduinoSetter.Create(Nm: string);
begin
  inherited Create(Nm);
  PinsCreate();
  SetLength(fData,6);
  CreateHook;
  fData[0] := fSetterKod;
  PinsToDataArray();
end;

procedure TArduinoSetter.CreateHook;
begin
  fSetterKod:=$FF;
end;

procedure TArduinoSetter.Free;
begin
// HelpForMe(Pins.Name);
 Pins.Free;
// inherited Free;
end;

function TArduinoSetter.GetisNeededComPort: boolean;
begin
 Result:=fisNeededComPort;
end;

procedure TArduinoSetter.isNeededComPortState;
begin
  fisNeededComPort:=(WaitForSingleObject(EventComPortFree,1000)=WAIT_OBJECT_0);
end;

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

procedure TArduinoSetter.SetisNeededComPort(const Value: boolean);
begin
 fisNeededComPort:=Value;
end;

{ TArduinoMeterNew }

procedure TArduinoMeter.AddDataSubject(DataSubject: TArduinoDataSubject);
begin
 fArduinoDataSubject:=DataSubject;
 fIRS232DataSubject:=fArduinoDataSubject;
 fRequestState:=fAddedRequestState;
end;


constructor TArduinoMeter.Create(Nm: string);
begin
  inherited Create(Nm);
  PinsCreate();
  fInitRequestState:=TInitRequestState.Create;
  fRequestState:=fInitRequestState;
  fWorkRequestState:=TWorkRequestState.Create(Self);
  fAddedRequestState:=TAddedRequestState.Create(Self);
end;

procedure TArduinoMeter.Free;
begin
 Pins.Free;
 fInitRequestState.Free;
 inherited;
end;

function TArduinoMeter.GetDeviceKod: byte;
begin
  Result:=fMetterKod;
end;

function TArduinoMeter.GetisNeededComPort: boolean;
begin
 Result:=fisNeededComPort;
end;

function TArduinoMeter.GetSecondDeviceKod: byte;
begin
 Result:=Pins.PinControl;
end;

procedure TArduinoMeter.isNeededComPortState;
begin
  fisNeededComPort:=(WaitForSingleObject(EventComPortFree,1000)=WAIT_OBJECT_0);
end;

procedure TArduinoMeter.PacketCreateToSend;
begin
  PacketCreate([fMetterKod,Pins.PinControl]);
end;

procedure TArduinoMeter.PinsCreate;
begin
   Pins := TPins.Create(Name);
end;

procedure TArduinoMeter.Request;
begin
 fRequestState.Request;
end;

procedure TArduinoMeter.SetisNeededComPort(const Value: boolean);
begin
 fisNeededComPort:=Value;
end;

procedure TArduinoMeter.UpDate;
 var i:integer;
begin
  inherited UpDate;
  SetLength(fData,High(fArduinoDataSubject.ReceivedData)+1);
  for I := 0 to High(fData)
     do  fData[i]:=fArduinoDataSubject.ReceivedData[i];
  ConvertToValue();
end;

{ TInitRequestState }

procedure TInitRequestState.Request;
begin

end;

{ TWorkRequestState }

constructor TWorkRequestState.Create(ArduinoMeter: TArduinoMeter);
begin
 fArduinoMeter:=ArduinoMeter;
end;

procedure TWorkRequestState.Request;
begin
 fArduinoMeter.isNeededComPortState();
end;

{ TAddedRequestState }

procedure TAddedRequestState.Request;
begin
  fArduinoMeter.fArduinoDataSubject.RegisterObserver(fArduinoMeter);
  fArduinoMeter.fRequestState:=fArduinoMeter.fWorkRequestState;
end;

end.
