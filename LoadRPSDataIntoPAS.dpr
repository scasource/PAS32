program LoadRPSDataIntoPAS;

uses
  Forms,
  Dataconv in 'dataconv.pas' {DataConvertForm},
  DataModule in 'DataModule.pas' {PASDataModule: TDataModule},
  GrievanceNotesFrameUnit in 'Frames\GrievanceNotesFrameUnit.pas' {GrievanceNotesFrame: TFrame},
  Prog in 'PROG.PAS' {ProgressDialog};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TPASDataModule, PASDataModule);
  Application.CreateForm(TDataConvertForm, DataConvertForm);
  Application.CreateForm(TProgressDialog, ProgressDialog);
  Application.Run;
end.
