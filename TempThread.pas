unit TempThread;

interface

uses
  Classes, Measurement;

type
  TTemperatureMeasuringThread = class(TThread)
  private
    procedure Doing;
  protected
    procedure Execute; override;
  public
   TemperatureMD:TTemperature_MD;
  end;

implementation

uses
  OlegType, Forms;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TTemperatureMeasuringThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TTemperatureMeasuringThread }

procedure TTemperatureMeasuringThread.Doing;
 var temp:double;
begin
  temp:=TemperatureMD.GetMeasurementResult(ErResult);
  if temp=ErResult then Terminate;

end;

procedure TTemperatureMeasuringThread.Execute;
begin
  while Terminated=False do
  begin
    Synchronize(Doing);
//    Application.ProcessMessages;
  end;
end;

end.
