unit SCPIshow;

interface

uses
  OlegTypePart2, SCPI, StdCtrls, CPortCtl, Controls, IniFiles;

type

TGBwithControlElements=class
 private
  fWinElements:array of TControl;
  procedure ParentToElements;
 protected
  fParent:TGroupBox;
  procedure Add(WinElements:TControl);
  procedure CreateElements;virtual;abstract;
  procedure CreateControls;virtual;abstract;
  procedure DestroyElements;
  procedure DesignElements;virtual;
 public
  Constructor Create(GB:TGroupBox);
  destructor Destroy;override;
end;

TRS232minimal_Show=class(TGBwithControlElements)
 private
 protected
  procedure CreateElements;override;
  procedure DesignElements;override;
  procedure CreateControls;override;
 public
  fLPort: TLabel;
  fComCBPort: TComComboBox;
  fComCBBaud: TComComboBox;
  fSTRate: TStaticText;
  fBTest: TButton;
end;

TRS232DeviceNew_Show=class(TSimpleFreeAndAiniObject)
  private
   fRS232Device:TRS232DeviceNew;
   fRS232Show:TRS232minimal_Show;
   procedure TestButtonClick(Sender:TObject);
  protected
  public
   Constructor Create(Device:TRS232DeviceNew;
                      GB: TGroupBox);
  destructor Destroy;override;
  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
  procedure WriteToIniFile(ConfigFile:TIniFile);override;
//  procedure ObjectToSetting;virtual;
 end;

{ TRS232DeviceNew_Show }





implementation

uses
  SysUtils, CPort, Forms, RS232deviceNew, Dialogs, Graphics;

constructor TRS232DeviceNew_Show.Create(Device: TRS232DeviceNew; GB: TGroupBox);
begin
 fRS232Device:=Device;
 fRS232Show:=TRS232minimal_Show.Create(GB);
 fRS232Show.fComCBPort.ComPort:=fRS232Device.ComPort;
 fRS232Show.fComCBBaud.ComPort:=fRS232Device.ComPort;
 fRS232Show.fBTest.OnClick := TestButtonClick;

end;

{ TGBwithControlElements }

procedure TGBwithControlElements.Add(WinElements: TControl);
begin
 SetLength(fWinElements,High(fWinElements)+2);
 fWinElements[High(fWinElements)]:=WinElements;
end;

constructor TGBwithControlElements.Create(GB: TGroupBox);
begin

 inherited Create;
 fParent:=GB;

 CreateElements;
 DesignElements;
 CreateControls;

end;

procedure TGBwithControlElements.DesignElements;
begin
 ParentToElements;
end;

destructor TGBwithControlElements.Destroy;
begin
//  DestroyControls;
  DestroyElements;
  inherited;
end;

procedure TGBwithControlElements.DestroyElements;
 var i:Integer;
begin
 for i := 0 to High(fWinElements) do
  fWinElements[i].Free;
end;

procedure TGBwithControlElements.ParentToElements;
 var i:Integer;
begin
 for I := 0 to High(fWinElements)
   do fWinElements[i].Parent:=fParent;
end;

{ TRS232minimal_Show }


procedure TRS232minimal_Show.CreateControls;
begin
  fComCBPort.AutoApply:=True;
  fComCBBaud.AutoApply:=True;
  fComCBPort.ComProperty:=cpPort;
  fComCBBaud.ComProperty:=cpBaudRate;
end;

procedure TRS232minimal_Show.CreateElements;
begin
  fLPort:=TLabel.Create(fParent);
  fSTRate:=TStaticText.Create(fParent);
  fComCBPort:=TComComboBox.Create(fParent);
  fComCBBaud:=TComComboBox.Create(fParent);
  fBTest:=TButton.Create(fParent);
  Add(fLPort);
  Add(fComCBPort);
  Add(fComCBBaud);
  Add(fSTRate);
  Add(fBTest);
end;

procedure TRS232minimal_Show.DesignElements;
begin
 fLPort.ParentFont:=False;
 fSTRate.ParentFont:=False;
 fComCBPort.ParentFont:=False;
 fComCBBaud.ParentFont:=False;
 fBTest.ParentFont:=False;
 fLPort.Font.Style:=[fsBold];
 fSTRate.Font.Style:=[fsBold];
 fComCBPort.Font.Style:=[fsBold];
 fComCBBaud.Font.Style:=[fsBold];
 fBTest.Font.Style:=[fsBold];

 fLPort.Font.Name:='Verdana';
 fSTRate.Font.Name:='Verdana';
 fComCBPort.Font.Name:='Arial';
 fComCBBaud.Font.Name:='Arial';
 fBTest.Font.Name:='Arial';

 fLPort.Font.Height:=-15;
 fSTRate.Font.Height:=-15;
 fComCBPort.Font.Height:=-15;
 fComCBBaud.Font.Height:=-15;
 fBTest.Font.Height:=-15;


 inherited DesignElements;
 fLPort.Caption:='Port';
 fLPort.Top:=12;
 fLPort.Left:=10;
 fLPort.Height:=18;
 fLPort.Width:=40;

 fSTRate.Caption:='Baud Rate';
 fSTRate.Top:=12;
 fSTRate.Left:=116;
 fSTRate.Height:=22;
 fSTRate.Width:=89;

 fComCBPort.Top:=31;
 fComCBPort.Left:=8;
 fComCBPort.Height:=26;
 fComCBPort.Width:=74;

 fComCBBaud.Top:=31;
 fComCBBaud.Left:=116;
 fComCBBaud.Height:=26;
 fComCBBaud.Width:=93;
 fComCBBaud.BringToFront;

 fBTest.Caption := 'Connection Test ?';
 fBTest.Top:=63;
 fBTest.Left:=8;
 fBTest.Height:=31;
 fBTest.Width:=201;

 fParent.Caption:='COM parameters';
end;



destructor TRS232DeviceNew_Show.Destroy;
begin
 PortEndAction(fRS232Device.ComPort);
 FreeAndNil(fRS232Show);
  inherited;
end;

procedure TRS232DeviceNew_Show.ReadFromIniFile(ConfigFile: TIniFile);
begin
 fRS232Device.ComPort.LoadSettings(stIniFile, ExtractFilePath(Application.ExeName) + 'IVChar.ini');
 fRS232Show.fComCBPort.UpdateSettings;
 fRS232Show.fComCBBaud.UpdateSettings;
 PortBeginAction(fRS232Device.ComPort, fRS232Show.fLPort, nil);
end;

procedure TRS232DeviceNew_Show.TestButtonClick(Sender: TObject);
begin
 if fRS232Device.SCPI.Test
   then (Sender as TButton).Caption:='Connection Test - Ok'
   else (Sender as TButton).Caption:='Connection Test - Failed';

end;

procedure TRS232DeviceNew_Show.WriteToIniFile(ConfigFile: TIniFile);
begin
 fRS232Device.ComPort.StoreSettings(stIniFile,ExtractFilePath(Application.ExeName)+'IVChar.ini');
end;

end.
