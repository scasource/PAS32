unit SeniorLimitMaintenanceAddNewLimitDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, wwdblook, Db, DBTables, Wwtable, Buttons;

type
  TAddNewLimitSetDialog = class(TForm)
    Label1: TLabel;
    SwisCodeTable: TwwTable;
    Table1: TTable;
    Panel1: TPanel;
    PreviousButton: TBitBtn;
    NextButton: TBitBtn;
    Notebook: TNotebook;
    ApplyToMunicipalityRadioGroup: TRadioGroup;
    SwisCodeListBox: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    SchoolCodeListBox: TListBox;
    SchoolCodeTable: TTable;
    procedure FormCreate(Sender: TObject);
    procedure ApplyToMunicipalityRadioGroupClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure PreviousButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MunicipalityTypeSelected : Integer;
  end;

var
  AddNewLimitSetDialog: TAddNewLimitSetDialog;

implementation

{$R *.DFM}

uses WinUtils, GlblCnst, GlblVars;

{===========================================================}
Procedure TAddNewLimitSetDialog.FormCreate(Sender: TObject);

begin
  FillOneListBox(SwisCodeListBox, SwisCodeTable,
                 'SwisCode', 'MunicipalityName', 15, True, True,
                 NextYear, GlblNextYear);
  FillOneListBox(SchoolCodeListBox, SwisCodeTable,
                 'SchoolCode', 'SchoolName', 15, True, True,
                 NextYear, GlblNextYear);

end;  {FormCreate}

{===========================================================}
Procedure TAddNewLimitSetDialog.ApplyToMunicipalityRadioGroupClick(Sender: TObject);

begin
  case ApplyToMunicipalityRadioGroup.ItemIndex of
    lsAll,
    lsCounty :
      begin
        NextButton.Enabled := True;
        NextButton.Caption := 'Add Set';
      end;

    lsCountyTown,
    lsTown,
    lsSchoolTown :
      begin
        NextButton.Enabled := True;
        PreviousButton.Enabled := True;
        Notebook.PageIndex := 1;  {Swis code page}

        If (ApplyToMunicipalityRadioGroup.ItemIndex in [lsTown, lsCountyTown])
          then NextButton.Caption := 'Add Set';

      end;  {lsCountyTown ...}

    lsCountySchool,
    lsSchool:
      begin
        NextButton.Enabled := True;
        PreviousButton.Enabled := True;
        Notebook.PageIndex := 1;  {Swis code page}
        NextButton.Caption := 'Add Set';

      end;  {lsCountySchool...}

  end;  {case ApplyToMunicipalityRadioGroup.ItemIndex of}

  MunicipalityTypeSelected := ApplyToMunicipalityRadioGroup.ItemIndex;

end;  {ApplyToMunicipalityRadioGroupClick}

{===========================================================}
Procedure TAddNewLimitSetDialog.NextButtonClick(Sender: TObject);

begin
  If (MunicipalityTypeSelected = lsSchoolTown)
    then
      begin
        Notebook.PageIndex := 2;  {School code page}
        NextButton.Caption := 'Add Set';
      end
    else Close;

end;  {NextButtonClick}

{===========================================================}
Procedure TAddNewLimitSetDialog.PreviousButtonClick(Sender: TObject);

begin
  If ((MunicipalityTypeSelected = lsSchoolTown) and
      (Notebook.PageIndex = 2))
    then
      begin
        Notebook.PageIndex := 1;
        NextButton.Caption := 'Next';
      end
    else
      begin
        Notebook.PageIndex := 0;
        PreviousButton.Enabled := False;
        NextButton.Caption := 'Next';

      end;  {else of If ((MunicipalityTypeSelected = lsSchoolTown) and ...}

end;  {PreviousButtonClick}

end.
