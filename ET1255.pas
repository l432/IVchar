unit ET1255;

interface

uses
  RS232device, Measurement;

const
 ET1255_DAC_MAX=2.5;
 ET1255_DAC_MIN=-2.5;
 ET1255_DAC_CodeMAX=4096;
 ET1255_DAC_CodeMIN=0;
 ET1255_DAC_CodeReset=2048;



function  ET_StartDrv: string; stdcall; external 'ET1255.dll';
{������� �������������� ��������� � ������ � ���������.
�����: ��������� �� ������. ���� ��� ���������, ������������ ������ ������.}
procedure ET_SetADCChnl(Chnl: word); stdcall; external 'ET1255.dll';
{��������� ������ �������� ������ ��� ������ ��� ����������� ������������ ������� 
Chnl - ����� ������.}
function  ET_ReadADC: single; stdcall; external 'ET1255.dll';
{� ����� ������ ��� � ������ ����������������� ������ 
�����:  ��������� ��������� � V.  }
procedure ET_SetScanMode(AChCount: integer; AScanEnable: boolean); stdcall; external 'ET1255.dll';
{��������� ������ ������������ 
 AChCount � ���������� ������� ������������;
 AScanEnable � ����� ������������: TRUE � ������������ ���������, FALSE - ���������}
function  ET_ReadMem: single; stdcall; external 'ET1255.dll';
{������ ������ ��� �� ��������� ��� 
�����:  ��������� ��������� � V. }
procedure ET_SetADCMode(AFrq: integer; APrgrmStart, AIntTackt, AMemEnable: boolean); stdcall;
external 'ET1255.dll';
{������� ������ ������ ��� 
AFrq � ��� ������� ������������, ������������ ��������� �������:
���  �������
������������, ���
0 8,33
1 4,17
2 2,08
3 1,04
APrgrmStart � ����� �������: TRUE � ���������������, FALSE � ����������;
AIntTackt � ����� ������������: TRUE � ����������, FALSE � �������;
AMemEnable � TRUE - ����� ������ � �������� �������; FALSE � ����� �����������������
������.}
function  ET_MeasEnd: boolean; stdcall; external 'ET1255.dll';
{������ �������� ��������� �������������� 
�����: TRUE � �������������� ���������, FALSE � �� ���������.}
procedure ET_SetStrob; stdcall; external 'ET1255.dll';
{������ ��� - ������������ ����� ������������ ������� ���. }
procedure ET_SetAddr(Addr: word); stdcall; external 'ET1255.dll';
{��������� ���������� ������ ������ ������ ��� � �������� ������
����: Addr � ���������� ������ ������ ������ ��� � �������� ������. }
procedure ET_SetAmplif(Value: word); stdcall; external 'ET1255.dll';
{��������� ������������ �������� �������� ��������� 
Value � ����������� �������� (����� � ��������� 1..15).}
procedure ET_WriteDAC(Value: single; Chnl: integer); stdcall; external 'ET1255.dll';
{����: Value � ����������� � ��� ��������;
 Chnl � ����� ������ ���.}
procedure ET_WriteDGT(Data: word); stdcall; external 'ET1255.dll';
{������ � �������� ���� 
 Data � ������������ ������. }
function  ET_ReadDGT: word; stdcall; external 'ET1255.dll';
{������ ��������� ����� 
�����:  ����������� ������. }
function  ET_WaitADC(AWait: integer): boolean; stdcall; external 'ET1255.dll';
function  ET_GetADCData: word; stdcall; external 'ET1255.dll';
function  ET_ErrMsg: string; stdcall; external 'ET1255.dll';
{�����:  ��������� �� ������. ��� ������ ���, ������������ ������ ������.
��������� ����� ���: �Error in <��� �������> = ��� ������. ������������� ��������� ��������� ��
������ ����� ������� ��������� � ���������� � �������� ����������. }


{���� � ���������� ����������� ���� ����� ET1255, ��� ��������� ��������� ������������ �� �����, �� 
��������� ��������� ���� ������������� �� ������ � ����� ������. }
procedure ET_SetDeviceCount(ADevCount: integer); stdcall; external 'ET1255.dll';
{����: ADevCount � ���������� ���� ET1255, ������������� �� ����� ����������.
� �������� ������ ���������� ��������� ����� �����, � ������� �� �����������, ��� ����� �����������
���������: ET_SetDeviceNumber}
procedure ET_SetDeviceNumber(ADevn: integer); stdcall; external 'ET1255.dll';
{����: ADevn � ���������� ����� ����� � ������ ����������, ��������� ���������� � 0}

type

 TET1255_DAC_ChanelNumber=0..2;

 TET1255_DAC=class(TNamedDevice,IDAC)
 private
  fChanelNumber:TET1255_DAC_ChanelNumber;
//  fError:string;
  Procedure ShowError();
 public
   procedure Output(Value:double);virtual;
   procedure OutputInt(Kod:integer); virtual;
   Procedure Reset();     virtual;
   function CalibrationStep(Voltage:double):double;  virtual;
   procedure OutputCalibr(Value:double); virtual;
   Constructor Create(ChanelNumber:TET1255_DAC_ChanelNumber);
   procedure Free;
 end;

//var ET_Error:string;


implementation

uses
  Dialogs, SysUtils;

{ TET1255_DAC }

function TET1255_DAC.CalibrationStep(Voltage: double): double;
begin
 Result:=0.001;
end;

constructor TET1255_DAC.Create(ChanelNumber: TET1255_DAC_ChanelNumber);
begin
 inherited Create;
 fChanelNumber:=ChanelNumber;
 case ChanelNumber of
  0:fName:='Ch0_ET1255';
  1:fName:='Ch1_ET1255';
  2:fName:='Ch2_ET1255';
 end;
 // ShowError();
end;

procedure TET1255_DAC.Free;
begin

end;

procedure TET1255_DAC.Output(Value: double);
begin
 showmessage('ch'+inttostr(fChanelNumber)+' d='+floattostr(Value));

 if Value>ET1255_DAC_MAX
    then ET_WriteDAC(ET1255_DAC_MAX,fChanelNumber)
    else if Value<ET1255_DAC_MIN
            then ET_WriteDAC(ET1255_DAC_MIN,fChanelNumber)
            else ET_WriteDAC(Value,fChanelNumber);
// fError:=ET_ErrMsg;
 ShowError();
end;

procedure TET1255_DAC.OutputCalibr(Value: double);
begin
 Output(Value);
end;

procedure TET1255_DAC.OutputInt(Kod: integer);
begin
 if Kod=ET1255_DAC_CodeReset then
   begin
    Reset();
    Exit;
   end;
 if Kod>ET1255_DAC_CodeMAX then Kod:=ET1255_DAC_CodeMAX;
 if Kod<ET1255_DAC_CodeMIN then Kod:=ET1255_DAC_CodeMIN;

 if Kod>ET1255_DAC_CodeReset then
    Output(ET1255_DAC_MAX*(Kod-ET1255_DAC_CodeReset)/(ET1255_DAC_CodeMAX-ET1255_DAC_CodeReset))
                             else
    Output(ET1255_DAC_MIN*(Kod-ET1255_DAC_CodeMIN)/(ET1255_DAC_CodeReset-ET1255_DAC_CodeMIN));
end;

procedure TET1255_DAC.Reset;
begin
//  ET_WriteDAC(0,fChanelNumber);
//  ShowError();
  Output(0);
end;


procedure TET1255_DAC.ShowError;
begin
 if ET_ErrMsg<>'' then
   showmessage(ET_ErrMsg);
end;

initialization

//  if ET_StartDrv()<>'' then
//   showmessage('ET1255 loading error'+#10#13+ET_ErrMsg);

finalization

end.
