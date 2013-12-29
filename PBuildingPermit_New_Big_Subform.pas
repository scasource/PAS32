unit PBuildingPermit_New_Big_Subform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Wwdatsrc, DBTables, StdCtrls, ComCtrls, wwriched, Mask, DBCtrls,
  ExtCtrls, Buttons, wwrichedspell;

type
  TBigBuildingPermitSubform = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BuildingDepartmentInformationGroupBox: TGroupBox;
    Label3: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label11: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    ApplicationNoDBEdit: TDBEdit;
    PermitNoDBEdit: TDBEdit;
    PermitTypeEdit: TDBEdit;
    PermitDateEdit: TDBEdit;
    ProposedUseDBEdit: TDBEdit;
    ImproveTypeDBEdit: TDBEdit;
    ConstructionEndDateDBEdit: TDBEdit;
    TotalCostEdit: TDBEdit;
    ContstrStartDBEdit: TDBEdit;
    StatusDBEdit: TDBEdit;
    CCDateDBEdit: TDBEdit;
    CODateDBEdit: TDBEdit;
    ApplicationDateEdit: TDBEdit;
    DescriptionMemo: TwwDBRichEdit;
    BigBuildingPermitTable: TTable;
    BigBuildingDataSource: TwwDataSource;
    AssessorsInformationGroupBox: TGroupBox;
    Label17: TLabel;
    Label21: TLabel;
    Label18: TLabel;
    EditVisitDate2: TDBEdit;
    EditNextInspectionDate: TDBEdit;
    EditVisitDate1: TDBEdit;
    ClosedAssessmentCheckBox: TDBCheckBox;
    AssessorsNoteMemo: TwwDBRichEditMSWord;
    SaveButton: TBitBtn;
    procedure SaveButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AssessorsNoteMemoExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;  {For use with error dialog box.}
    Procedure InitializeForm(_PermitType : String;
                             _ApplicationNumber : String;
                             _EditMode : Char);

  end;

var
  BigBuildingPermitSubform: TBigBuildingPermitSubform;

implementation

{$R *.DFM}

uses GlblCnst, WinUtils, GlblVars, DataAccessUnit;

{=========================================================================}
Procedure TBigBuildingPermitSubform.InitializeForm(_PermitType : String;
                                                   _ApplicationNumber : String;
                                                   _EditMode : Char);

begin
  UnitName := 'PBuildingPermit_New_Big_Subform';

  If (_EditMode = emBrowse)
    then
      begin
        BigBuildingPermitTable.ReadOnly := True;
        SaveButton.Visible := False;
      end;

  BigBuildingPermitTable.Open;

  If not _Locate(BigBuildingPermitTable, [_PermitType, _ApplicationNumber], '', [])
    then SystemSupport(1, BigBuildingPermitTable, 'Error locating permit ' + _PermitType  + '\' + _ApplicationNumber + '.',
                       UnitName, GlblErrorDlgBox);

  Caption := 'Permit # ' + BigBuildingPermitTable.FieldByName('PermitNo').Text;

end;  {InitializeForm}

{=======================================================================}
Procedure TBigBuildingPermitSubform.FormKeyPress(    Sender: TObject;
                                                 var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{=======================================================================}
Procedure TBigBuildingPermitSubform.FormKeyDown(     Sender: TObject;
                                                 var Key: Word;
                                                     Shift: TShiftState);
begin
  If (Key = VK_Escape)
    then
      begin
        If not BigBuildingPermitTable.ReadOnly
          then
            try
              BigBuildingPermitTable.UpdateRecord;
            except
            end;

        If (BigBuildingPermitTable.ReadOnly or
            (not BigBuildingPermitTable.Modified))
          then Close
          else
            If (MessageDlg('Are you sure you want to cancel the changes?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
              then
                try
                  BigBuildingPermitTable.Cancel;
                  Close;
                except
                end;

        Key := 0;

      end;  {If (Key = VK_Escape)}

end;  {FormKeyDown}

{=======================================================================}
Procedure TBigBuildingPermitSubform.AssessorsNoteMemoExit(Sender: TObject);

begin
  If not BigBuildingPermitTable.ReadOnly
    then SaveButton.SetFocus;

end;  {AssessorsNoteMemoExit}

{=======================================================================}
Procedure TBigBuildingPermitSubform.SaveButtonClick(Sender: TObject);

begin
  with BigBuildingPermitTable do
    If Modified
      then
        try
          Post;
          BigBuildingPermitSubform.Close;
        except
          SystemSupport(001, BigBuildingPermitTable, 'Error saving permit record.',
                        UnitName, GlblErrorDlgBox);
        end;

end;  {SaveButtonClick}

{=======================================================================}
Procedure TBigBuildingPermitSubform.FormClose(    Sender: TObject;
                                              var Action: TCloseAction);
begin
  BigBuildingPermitTable.Close;
  Action := caFree;
end;

end.
