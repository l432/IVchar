unit Keithley2450Show;

interface

uses
  OlegTypePart2, Keithley2450, StdCtrls, Buttons,
  ArduinoDeviceNew, ExtCtrls, IniFiles;

const
  ButtonNumberKt2450 = 2;
  PanelNumberKt2450 = 1;


type

 TKt_2450_Show=class;

 TKT2450_SetupMemoryPins=class(TPins)
  protected
   Function GetPinStr(Index:integer):string;override;
  public
   Constructor Create(Name:string);
 end;

 TKT2450_SetupMemoryShow=class(TPinsShowUniversal)
   private
    fKT2450_Show:TKt_2450_Show;
    fMemoryPins:TKT2450_SetupMemoryPins;
   protected
    procedure LabelsFilling;
    procedure CommandSend;
   public
    Constructor Create(KT2450_Show:TKt_2450_Show;
                       PanelSave, PanelLoad:TPanel);
    destructor Destroy;override;
    procedure NumberPinShow(PinActiveNumber:integer=-1;ChooseNumber:integer=-1);override;
 end;


 TKt_2450_Show=class(TSimpleFreeAndAiniObject)
  private
   fKt_2450:TKt_2450;
   BTest:TButton;
   fOutPutOnOff:TSpeedButton;
   fSetupMemoryShow:TKT2450_SetupMemoryShow;
//   fSetupMemoryPins:TKT2450_SetupMemoryPins;
   procedure TestButtonClick(Sender:TObject);
   procedure ResetButtonClick(Sender:TObject);
   procedure MyTrainButtonClick(Sender:TObject);
   procedure ButtonsTune(Buttons: array of TButton);
   procedure OutPutOnOffSpeedButtonClick(Sender: TObject);
  public
   Constructor Create(Kt_2450:TKt_2450;
                      Buttons:Array of TButton;
                      OutPutOnOff:TSpeedButton;
                      Panels:Array of TPanel
                      );
  destructor Destroy;override;
  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
  procedure WriteToIniFile(ConfigFile:TIniFile);override;
 end;



var
  Kt_2450_Show:TKt_2450_Show;

implementation

uses
  Dialogs, Graphics, Classes, SysUtils;

{ TKt_2450_Show }

procedure TKt_2450_Show.ButtonsTune(Buttons: array of TButton);
const
  ButtonCaption: array[0..ButtonNumberKt2450] of string =
  ('Connection Test ?','Reset','MyTrain');
var
  ButtonAction: array[0..ButtonNumberKt2450] of TNotifyEvent;
  i: Integer;
begin
  ButtonAction[0] := TestButtonClick;
  ButtonAction[1] := ResetButtonClick;
//  ButtonAction[3] := SaveButtonClick;
//  ButtonAction[4] := LoadButtonClick;
//  ButtonAction[5] := AutoButtonClick;
//  ButtonAction[6] := DefaultButtonClick;
//  ButtonAction[7] := RefreshButtonClick;
//  ButtonAction[8] := RunButtonClick;
//  ButtonAction[9] := StopButtonClick;
//  ButtonAction[10] := UnlockButtonClick;
   ButtonAction[ButtonNumberKt2450] := MyTrainButtonClick;
  for I := 0 to ButtonNumberKt2450 do
  begin
    Buttons[i].Caption := ButtonCaption[i];
    Buttons[i].OnClick := ButtonAction[i];
  end;
  BTest := Buttons[0];

end;

constructor TKt_2450_Show.Create(Kt_2450: TKt_2450;
                                Buttons:Array of TButton;
                                OutPutOnOff:TSpeedButton;
                                Panels:Array of TPanel
                                );
begin
  if (High(Buttons)<>ButtonNumberKt2450)
     or(High(Panels)<>PanelNumberKt2450)
   then
    begin
      showmessage('Kt_2450_Show is not created!');
      Exit;
    end;
  fKt_2450:=Kt_2450;
  ButtonsTune(Buttons);

  fOutPutOnOff:=OutPutOnOff;
  fOutPutOnOff.OnClick:=OutPutOnOffSpeedButtonClick;
  fOutPutOnOff.Caption:='Output';

  fSetupMemoryShow:=TKT2450_SetupMemoryShow.Create(Self,Panels[0],Panels[1]);
end;

destructor TKt_2450_Show.Destroy;
begin
  FreeAndNil(fSetupMemoryShow);
  inherited;
end;

procedure TKt_2450_Show.MyTrainButtonClick(Sender: TObject);
begin
 fKt_2450.MyTraining();
end;

procedure TKt_2450_Show.OutPutOnOffSpeedButtonClick(Sender: TObject);
begin
 fKt_2450.OutPutChange(fOutPutOnOff.Down);
end;

procedure TKt_2450_Show.ReadFromIniFile(ConfigFile: TIniFile);
begin
  fSetupMemoryShow.ReadFromIniFile(ConfigFile);
end;

procedure TKt_2450_Show.ResetButtonClick(Sender: TObject);
begin
 fKt_2450.ResetSetting();
end;

procedure TKt_2450_Show.TestButtonClick(Sender: TObject);
begin
   if fKt_2450.Test then
        begin
          BTest.Caption:='Connection Test - Ok';
          BTest.Font.Color:=clBlue;
        end        else
        begin
          BTest.Caption:='Connection Test - Failed';
          BTest.Font.Color:=clRed;
        end;
end;


procedure TKt_2450_Show.WriteToIniFile(ConfigFile: TIniFile);
begin
 fSetupMemoryShow.WriteToIniFile(ConfigFile);
end;

{ TKT2450_SetupMemory }

procedure TKT2450_SetupMemoryShow.CommandSend;
begin

end;

constructor TKT2450_SetupMemoryShow.Create(KT2450_Show:TKt_2450_Show;
                              PanelSave, PanelLoad: TPanel);
begin
 fKT2450_Show:=KT2450_Show;
 fMemoryPins:=TKT2450_SetupMemoryPins.Create(fKT2450_Show.fKt_2450.Name);
 inherited Create(fMemoryPins,[PanelSave, PanelLoad]);
 LabelsFilling();
end;

{ TKT2450_SetupMemoryPins }

constructor TKT2450_SetupMemoryPins.Create(Name: string);
begin
 inherited Create(Name,['SaveSlot','LoadSlot']);
 PinStrPart:='';
end;

destructor TKT2450_SetupMemoryShow.Destroy;
begin
  fKT2450_Show:=nil;
  FreeAndNil(fMemoryPins);
  inherited;
end;

procedure TKT2450_SetupMemoryShow.LabelsFilling;
 var i:TKt2450_SetupMemorySlot;
begin
 fPinVariants[0].Clear;
 fPinVariants[1].Clear;
 for I := Low(TKt2450_SetupMemorySlot) to High(TKt2450_SetupMemorySlot) do
   begin
     fPinVariants[0].Add(inttostr(I));
     fPinVariants[1].Add(inttostr(I));
   end;
end;

procedure TKT2450_SetupMemoryShow.NumberPinShow(PinActiveNumber: integer;ChooseNumber:integer);
begin
 inherited;
 case PinActiveNumber of
  0:fKT2450_Show.fKt_2450.SaveSetup(TKt2450_SetupMemorySlot(ChooseNumber));
  1:fKT2450_Show.fKt_2450.LoadSetup(TKt2450_SetupMemorySlot(ChooseNumber));
 end;
end;

function TKT2450_SetupMemoryPins.GetPinStr(Index: integer): string;
begin
 case Index of
  0:Result:='Save Setup';
  else Result:='Load Setup';
 end;
end;

end.
