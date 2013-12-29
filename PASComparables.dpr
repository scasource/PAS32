program PASComparables;

uses
  Forms,
  ComparablesMainForm in 'ComparablesMainForm.pas' {ComparativesDisplayForm},
  DataModule in 'DataModule.pas' {PASDataModule: TDataModule},
  Prclocat in 'Prclocat.pas' {LocateParcelForm},
  GrievanceNotesFrameUnit in 'Frames\GrievanceNotesFrameUnit.pas' {GrievanceNotesFrame: TFrame};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PAS - Find Comparable Parcels';

  try
    Application.Icon.LoadFromFile('PASComparables.ico');
  except
  end;

  Application.CreateForm(TPASDataModule, PASDataModule);
  Application.CreateForm(TComparativesDisplayForm, ComparativesDisplayForm);
  Application.CreateForm(TLocateParcelForm, LocateParcelForm);
  Application.Run;
end.
