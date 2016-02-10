unit ShowTypes;

interface

uses
  StdCtrls, IniFiles;

const DoubleConstantSection='DoubleConstant';
      NoFile='no file';

type
TDoubleConstantShow=class
private
    FHint: string;
    FCaption: string;
    Lab:TLabel;
    Button:TButton;
    FDefaulValue: double;
    procedure SetCaption(const Value: string);
    procedure SetHint(const Value: string);
    procedure ButtonClick(Sender: TObject);
    procedure SetDefaulValue(const Value: double);
public
 property Caption:string read FCaption write SetCaption;
 property Hint:string read FHint write SetHint;
 property DefaulValue:double read FDefaulValue write SetDefaulValue;
 Constructor Create(L:TLabel;
                    B:TButton;
                    Cap,H:string;
                    DV:double);
 procedure ReadFromIniFile(ConfigFile:TIniFile);
 procedure WriteToIniFile(ConfigFile:TIniFile);
 function GetValue:double;
end;

function LastFileName(Mask:string):string;
{повертає назву (повну, з розширенням) останього файлу в
поточному каталозі, чия назва задовольняє маску Mask}

function LastDATFileName():string;
{повертає назву (коротку) останього .dat файлу в
поточному каталозі}

implementation

uses
  Dialogs, SysUtils, OlegType;

{ TDoubleConstantShow }

procedure TDoubleConstantShow.ButtonClick(Sender: TObject);
 var value:string;
begin
 if InputQuery(Caption, Hint, value) then
  begin
    try
      Lab.Caption:=FloatToStrF(StrToFloat(value),ffExponent, 3, 2);
    except

    end;
  end;
end;

constructor TDoubleConstantShow.Create(L: TLabel; B: TButton;
  Cap, H: string;DV:double);
begin
  Lab:=L;
  Button:=B;
  FCaption:=Cap;
  FHint:=H;
  Button.OnClick:=ButtonClick;
  DefaulValue:=DV;
end;

function TDoubleConstantShow.GetValue: double;
begin
 try
  Result:=StrToFloat(Lab.Caption);
 except
  Result:=DefaulValue;
 end;
end;

procedure TDoubleConstantShow.ReadFromIniFile(ConfigFile: TIniFile);
begin
 Lab.Caption:=FloatToStrF(ConfigFile.ReadFloat(DoubleConstantSection, Caption,DefaulValue),
                          ffExponent, 3, 2);
end;

procedure TDoubleConstantShow.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TDoubleConstantShow.SetDefaulValue(const Value: double);
begin
  FDefaulValue := Value;
end;

procedure TDoubleConstantShow.SetHint(const Value: string);
begin
  FHint := Value;
end;

procedure TDoubleConstantShow.WriteToIniFile(ConfigFile: TIniFile);
begin
 WriteIniDef(ConfigFile, DoubleConstantSection, Caption, StrToFloat(Lab.Caption),DefaulValue)
end;

function LastFileName(Mask:string):string;
 var SR : TSearchRec;
     tm:integer;
begin
 Result:=NoFile;
 if FindFirst(Mask, faAnyFile, SR) <> 0 then Exit;
 Result:=SR.name;
 tm:=SR.time;
 while FindNext(SR) = 0 do
   if tm<SR.time then
     begin
     Result:=SR.name;
     tm:=SR.time;
     end;
 FindClose(SR);
end;

function LastDATFileName():string;
begin
  Result:=LastFileName('*.dat');
  if Result<>NoFile then
   Result:=Copy(Result,1,Length(Result)-4);
end;

end.
