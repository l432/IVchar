unit ST2829CShow;

interface

uses
  OlegTypePart2, ST2829C, StdCtrls, SCPIshow;

type

//  TST2829C_Show=class(TSimpleFreeAndAiniObject)
  TST2829C_Show=class(TRS232DeviceNew_Show)
  private
   fST2829C:TST2829C;
//   fSetupMemoryShow:TKeitley_SetupMemoryShow;
//   fBrightnessShow:TKeitley_BrightnessShow;
//   procedure TestButtonClick(Sender:TObject);
   procedure MyTrainButtonClick(Sender:TObject);
  protected
//   procedure ButtonsTune(Buttons: array of TButton);virtual;
//   procedure ResetButtonClick(Sender:TObject);virtual;
//   procedure GetSettingButtonClick(Sender:TObject);virtual;
  public
//   Constructor Create(ST2829C:TST2829C;
//                      ButTest:TButton);
   Constructor Create(ST2829C:TST2829C;
                      GB: TGroupBox;
                      B_MyTrain:TButton);
//                      Buttons:Array of TButton;
//                      Panels:Array of TPanel;
//                      STextsBrightness:TStaticText
//                      );
//  destructor Destroy;override;
//  procedure ReadFromIniFile(ConfigFile:TIniFile);override;
//  procedure WriteToIniFile(ConfigFile:TIniFile);override;
//  procedure ObjectToSetting;virtual;
 end;

var
  ST2829C_Show:TST2829C_Show;

implementation

{ TST2829C_Show }

//constructor TST2829C_Show.Create(ST2829C: TST2829C; ButTest: TButton);
constructor TST2829C_Show.Create(ST2829C:TST2829C;
                     GB : TGroupBox;
                     B_MyTrain:TButton);
begin
 fST2829C:=ST2829C;
 inherited Create((ST2829C.Device as TST2829CDevice),GB);
// ButTest.Caption := 'Connection Test ?';
// ButTest.OnClick := TestButtonClick;
 B_MyTrain.OnClick:=MyTrainButtonClick;
end;

//procedure TST2829C_Show.TestButtonClick(Sender: TObject);
//begin
//   if fST2829C.Test
//     then (Sender as TButton).Caption:='Connection Test - Ok'
//     else (Sender as TButton).Caption:='Connection Test - Failed';
//end;

procedure TST2829C_Show.MyTrainButtonClick(Sender: TObject);
begin
 fST2829C.MyTraining();
end;

end.
