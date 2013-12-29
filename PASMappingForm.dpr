program PASMappingForm;

uses
  Forms,
  MappingFormUnit in 'MappingFormUnit.pas' {MappingForm},
  DataModule in 'DataModule.pas' {PASDataModule: TDataModule},
  MapSetupObjectType in 'MapSetupObjectType.pas',
  Prcllist in 'Prcllist.pas' {ParcelListDialog},
  Prclocat in 'Prclocat.pas' {LocateParcelForm},
  MapSetFieldValueBasedOnLayerValueUnit in 'MapSetFieldValueBasedOnLayerValueUnit.pas' {SetFieldValueFromMapLayerDialog},
  ParcelToolbar in 'ParcelToolbar.pas' {ParcelToolbarForm},
  MapPrintTypeDialogUnit in 'MapPrintTypeDialogUnit.pas' {MapPrintTypeDialog},
  MapLabelOptionsDialogUnit in 'MapLabelOptionsDialogUnit.pas' {MapLabelOptionsDialog},
  MapPrintDialogUnit in 'MapPrintDialogUnit.pas' {MapPrintDialog},
  MapCriteriaSearchDialogUnit in 'MapCriteriaSearchDialogUnit.pas' {MapCriteriaSearchDialog},
  MapRangeEditItemDialogUnit in 'MapRangeEditItemDialogUnit.pas' {MapRangeEditItemDialog},
  GrievanceNotesFrameUnit in 'Frames\GrievanceNotesFrameUnit.pas' {GrievanceNotesFrame: TFrame},
  Prog in 'PROG.PAS' {ProgressDialog};

(*  MemCheck in '..\Utilitys\MemCheck\MemCheck.pas';*)

{$R *.RES}

begin
  (*MemChk;*)
  Application.Initialize;
  Application.Title := 'PAS Maps';
  Application.CreateForm(TPASDataModule, PASDataModule);
  Application.CreateForm(TMappingForm, MappingForm);
  Application.CreateForm(TParcelListDialog, ParcelListDialog);
  Application.CreateForm(TLocateParcelForm, LocateParcelForm);
  Application.CreateForm(TProgressDialog, ProgressDialog);
  Application.Run;
end.
