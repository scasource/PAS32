unit PBuildingPermit_New_Small_Subform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Wwdatsrc, DBTables, StdCtrls, ComCtrls, wwriched, Mask, DBCtrls,
  ExtCtrls, Buttons, wwrichedspell;

type
  TSmallBuildingPermitSubform = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BuildingDepartmentInformationGroupBox: TGroupBox;
    SmallBuildingPermitTable: TTable;
    SmallBuildingDataSource: TwwDataSource;
    AssessorsInformationGroupBox1: TGroupBox;
    Label17: TLabel;
    Label21: TLabel;
    Label18: TLabel;
    EditVisitDate2: TDBEdit;
    EditNextInspectionDate: TDBEdit;
    EditVisitDate1: TDBEdit;
    ClosedAssessmentCheckBox: TDBCheckBox;
    AssessorsNoteMemo: TwwDBRichEditMSWord;
    SaveButton: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label29: TLabel;
    Label31: TLabel;
    Label33: TLabel;
    Label27: TLabel;
    EditSmallApplicationNumber: TDBEdit;
    EditSmallPermitNumber: TDBEdit;
    EditSmallIssueDate: TDBEdit;
    EditSmallInspector: TDBEdit;
    EditSmallConstructionCode: TDBEdit;
    EditSmallCloseType: TDBEdit;
    EditConstructionCost: TDBEdit;
    EditSmallCloseDate: TDBEdit;
    EditCONumber: TDBEdit;
    EditSmallWorkDescription: TwwDBRichEdit;
    procedure SaveButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;  {For use with error dialog box.}
    EditMode : Char;  {A = Add; M = Modify; V = View}
    PermitNumber : String;
    Procedure InitializeForm(_PermitNumber : String;
                             _EditMode : Char);

  end;

var
  SmallBuildingPermitSubform: TSmallBuildingPermitSubform;

implementation

{$R *.DFM}

uses GlblCnst, WinUtils, GlblVars;

{=========================================================================}
Procedure TSmallBuildingPermitSubform.InitializeForm(_PermitNumber : String;
                                                     _EditMode : Char);

begin
  UnitName := 'PBuildingPermit_New_Small_Subform';
  _PermitNumber := PermitNumber;
  _EditMode := EditMode;

  If (_EditMode = emBrowse)
    then
      begin
        SmallBuildingPermitTable.ReadOnly := True;
        SaveButton.Enabled := False;
      end;

  SmallBuildingPermitTable.Open;

end;  {InitializeForm}

{=======================================================================}
Procedure TSmallBuildingPermitSubform.SaveButtonClick(Sender: TObject);

begin
  with SmallBuildingPermitTable do
    If Modified
      then
        try
          Post;
        except
          SystemSupport(001, SmallBuildingPermitTable, 'Error saving permit record.',
                        UnitName, GlblErrorDlgBox);
        end;

end;  {SaveButtonClick}

{=======================================================================}
Procedure TSmallBuildingPermitSubform.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);
begin
  SmallBuildingPermitTable.Close;
  Action := caFree;
end;

end.
