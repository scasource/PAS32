program SaberDataCompare;

uses
  Forms,
  SaberCompareUnit in 'SaberCompareUnit.pas' {Form1},
  GrievanceNotesFrameUnit in 'Frames\GrievanceNotesFrameUnit.pas' {GrievanceNotesFrame: TFrame};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
