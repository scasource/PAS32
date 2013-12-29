program InquireOnly;

uses
  Forms,
  InquireOnlyUnit in 'InquireOnlyUnit.pas' {MainForm},
  DataModule in 'DataModule.pas' {PASDataModule: TDataModule},
  Prclocat in 'Prclocat.pas' {LocateParcelForm},
  Chostxyr in 'Chostxyr.pas' {ChooseTaxYearForm},
  Phistfrm in 'Phistfrm.pas' {HistorySummaryForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TPASDataModule, PASDataModule);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TLocateParcelForm, LocateParcelForm);
  Application.CreateForm(TChooseTaxYearForm, ChooseTaxYearForm);
  Application.CreateForm(THistorySummaryForm, HistorySummaryForm);
  Application.Run;
end.
