unit Unit1;

interface

uses
  Classes;

type
  RS232Measuring = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  public
  end;

implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure RS232Measuring.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ RS232Measuring }

procedure RS232Measuring.Execute;
begin
  { Place thread code here }
end;

end.
