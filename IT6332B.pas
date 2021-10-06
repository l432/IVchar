unit IT6332B;

interface

uses
  RS232deviceNew, CPort, SCPI;

type
 TIT6332_Channel=1..3;

const

  IT_6332_Test='GW,GDS-806S,EF211754,V1.10';
type

  TDataSubject_IT6332=class(TRS232DataSubjectSingle)
    protected
    procedure ComPortCreare(CP:TComPort);override;
  end;

  TIT_6332=class(TSCPI)
  protected
//     procedure PrepareString;
     procedure UpDate();override;
     procedure CreateDataSubject(CP:TComPort);override;
   public
    Constructor Create(CP:TComPort;Nm:string);overload;
    Constructor Create(CP:TComPort);overload;
    function Test():boolean;
  end;

var
  IT_6332:TIT_6332;

implementation

uses
  Dialogs;

{ TDataSubject_GDS }

procedure TDataSubject_IT6332.ComPortCreare(CP: TComPort);
begin
 fRS232:=TRS232_SCPI.Create(CP);
end;

{ TIT_6332 }

constructor TIT_6332.Create(CP: TComPort; Nm: string);
begin
 inherited Create(CP,Nm);
 RepeatInErrorCase:=True;
// DefaultSettings();
// SetFlags(0,0,0,true);
end;

constructor TIT_6332.Create(CP: TComPort);
begin
 Create(CP,'IT6332B');
end;

procedure TIT_6332.CreateDataSubject(CP: TComPort);
begin
  fDataSubject:=TDataSubject_IT6332.Create(CP);
end;

function TIT_6332.Test: boolean;
begin
// SetFlags(RootNode, FirstLevelNode, LeafNode, True);
 StringToSend:='*idn?';
// PrepareString();
 GetData;
// Result:=(Value=314);
 Result:=True;
end;

procedure TIT_6332.UpDate;
var
//  I: TGDS_TimeScale;
//  j:TGDS_VoltageScale;
//  DataSize:Integer;
//  DataSizeDigit:byte;
//  DataOffset:integer;
//  SampleRate:single;
//  k:integer;
  Str:string;
begin
 Str:=fDataSubject.ReceivedString;

// case fRootNode of
//  0:if Str=GDS_806S_Test then fValue:=314;
//  4:begin
//     case fFirstLevelNode of
//        0..2:try
//            fValue:=StrToInt(Str);
//            except
//            end;
//        3:if Str[1]='#' then
//          begin
//           try
//           DataSizeDigit:=byte(StrToInt(Str[2]));
//           DataSize:=round((StrToInt(Copy(Str,3,DataSizeDigit))-8)/2);
//           DataOffset:=DataSizeDigit+3;
//           SampleRate:=FourByteToSingle(ord(Str[DataOffset+3]),ord(Str[DataOffset+2]),
//                       ord(Str[DataOffset+1]),ord(Str[DataOffset]));
//           fActiveChannel:=ord(Str[DataOffset+4]);
//           DataVectors[fActiveChannel].SetLenVector(DataSize);
//           DataOffset:=DataOffset+8;
//           for k := 0 to DataSize - 1 do
//             begin
//              DataVectors[fActiveChannel].X[k]:=k/SampleRate;
//              DataVectors[fActiveChannel].Y[k]:=TwoByteToData(ord(Str[DataOffset+2*k]),
//                                                    ord(Str[DataOffset+2*k+1]));
//             end;
//           fValue:=1;
//           except
//
//           end;
//          end;
//     end;
//    end; //fRootNode = 4;  acq
//  6:begin
//     case fFirstLevelNode of
//        0..2,4:try
//            fValue:=StrToInt(Str);
//            except
//            end;
//        3:Value:=GDS_StringToValue(Str);
//        5:begin
//           for j := Low(TGDS_VoltageScale) to High(TGDS_VoltageScale) do
//             if Str=GDS_VoltageScaleLabels[j] then
//               begin
//               fValue:=ord(j);
//               Break;
//               end;
//         end;
//     end;
//    end; //fRootNode = 6;     chan
//   7:Value:=GDS_StringToValue(Str);
//  12:begin
//     for I := Low(TGDS_TimeScale) to High(TGDS_TimeScale) do
//       if Str=GDS_TimeScaleLabels[i] then
//         begin
//         fValue:=ord(i);
//         Break;
//         end;
//    end; //fRootNode = 12; time scale
// end; //case fRootNode of

fIsReceived:=True;
if TestShow then showmessage('recived:  '+STR);

end;

end.
