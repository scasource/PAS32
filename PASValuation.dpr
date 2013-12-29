program PASValuation;

uses
  Forms,
  ValuationMainForm in 'ValuationMainForm.pas' {ValuationForm},
  DataModule in 'DataModule.pas' {PASDataModule: TDataModule},
  Prclocat in 'Prclocat.pas' {LocateParcelForm},
  GrievanceNotesFrameUnit in 'Frames\GrievanceNotesFrameUnit.pas' {GrievanceNotesFrame: TFrame},
  ValuationTypes in 'ValuationTypes.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PAS Valuation';

  Application.CreateForm(TPASDataModule, PASDataModule);
  Application.CreateForm(TValuationForm, ValuationForm);
  Application.CreateForm(TLocateParcelForm, LocateParcelForm);
  Application.Run;
end.
