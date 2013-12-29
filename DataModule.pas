unit DataModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Wwtable;

type
  TPASDataModule = class(TDataModule)
    SalesTable: TwwTable;
    TYAssessmentTable: TwwTable;
    HistoryAssessmentTable: TwwTable;
    NYAssessmentTable: TwwTable;
    HistoryExemptionCodeTable: TwwTable;
    TYExemptionCodeTable: TwwTable;
    NYExemptionCodeTable: TwwTable;
    NYExemptionTable: TwwTable;
    TYExemptionTable: TwwTable;
    HistoryExemptionTable: TwwTable;
    TYSpecialDistrictTable: TwwTable;
    HistorySpecialDistrictTable: TwwTable;
    NYSpecialDistrictTable: TwwTable;
    HistoryClassTable: TwwTable;
    HistoryParcelTable: TwwTable;
    TYParcelTable: TwwTable;
    NYParcelTable: TwwTable;
    TYClassTable: TwwTable;
    HistorySwisCodeTable: TwwTable;
    TYSwisCodeTable: TwwTable;
    NYSwisCodeTable: TwwTable;
    HistoryAssessmentYearControlTable: TwwTable;
    TYAssessmentYearControlTable: TwwTable;
    NYAssessmentYearControlTable: TwwTable;
    NYClassTable: TwwTable;
    HistorySpecialDistrictCodeTable: TwwTable;
    HistoryResidentialSiteTable: TwwTable;
    TYResidentialSiteTable: TwwTable;
    NYResidentialSiteTable: TwwTable;
    TYSpecialDistrictCodeTable: TwwTable;
    HistoryCommercialSiteTable: TwwTable;
    TYCommercialSiteTable: TwwTable;
    NYCommercialSiteTable: TwwTable;
    NYSpecialDistrictCodeTable: TwwTable;
    PASDatabase: TDatabase;
    SalesResidentialSiteTable: TwwTable;
    HistoryResidentialBuildingTable: TwwTable;
    TYResidentialBuildingTable: TwwTable;
    NYResidentialBuildingTable: TwwTable;
    SalesResidentialBuildingTable: TwwTable;
    HistoryResidentialLandTable: TwwTable;
    TYResidentialLandTable: TwwTable;
    NYResidentialLandTable: TwwTable;
    SalesResidentialLandTable: TwwTable;
    HistoryResidentialImprovementTable: TwwTable;
    TYResidentialImprovementTable: TwwTable;
    SalesResidentialImprovementTable: TwwTable;
    NYResidentialImprovementTable: TwwTable;
    TYCommercialImprovementTable: TwwTable;
    HistoryCommercialIncomeExpenseTable: TwwTable;
    TYCommercialRentTable: TwwTable;
    SalesCommercialLandTable: TwwTable;
    NYCommercialImprovementTable: TwwTable;
    SalesCommercialIncomeExpenseTable: TwwTable;
    TYCommercialIncomeExpenseTable: TwwTable;
    HistoryCommercialBuildingTable: TwwTable;
    NYCommercialRentTable: TwwTable;
    NYCommercialLandTable: TwwTable;
    TYCommercialBuildingTable: TwwTable;
    NYCommercialIncomeExpenseTable: TwwTable;
    HistoryCommercialImprovementTable: TwwTable;
    SalesCommercialRentTable: TwwTable;
    HistoryCommercialLandTable: TwwTable;
    NYCommercialBuildingTable: TwwTable;
    SalesCommercialBuildingTable: TwwTable;
    TYCommercialLandTable: TwwTable;
    HistoryCommercialRentTable: TwwTable;
    SalesCommercialImprovementTable: TwwTable;
    HistorySchoolCodeTable: TwwTable;
    TYSchoolCodeTable: TwwTable;
    NYSchoolCodeTable: TwwTable;
    HistoryResidentialForestTable: TwwTable;
    TYResidentialForestTable: TwwTable;
    NYResidentialForestTable: TwwTable;
    SalesResidentialForestTable: TwwTable;
    SalesCommercialSiteTable: TwwTable;
    DocumentTable: TwwTable;
    PictureTable: TwwTable;
    SketchTable: TwwTable;
    PropertyCardTable: TwwTable;
    tb_CertiorariDocument: TTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PASDataModule: TPASDataModule;

implementation

{$R *.DFM}

{=========================================================================}
Procedure TPASDataModule.DataModuleCreate(Sender: TObject);

{CHG01022002-1: Allow for starting of PAS with different set of data.}

var
  TempDatabaseName : String;
  I, TempPos : Integer;

begin
  TempDatabaseName := '';

  For I := 1 to ParamCount do
    begin
      TempPos := Pos('ALIAS=', ParamStr(I));

      If (TempPos > 0)
        then TempDatabaseName := Copy(ParamStr(I), (TempPos + 6), 200);

    end;  {For I := 1 to ParamCount do}

  If (TempDatabaseName <> '')
    then
      with PASDatabase do
        try
          Connected := False;
          KeepConnection := False;
          AliasName := TempDatabaseName;
          Connected := True;
          KeepConnection := True;
        except
          MessageDlg('Error switching to database ' + TempDatabaseName + '.' + #13 +
                     'Please call SCA for help.',
                     mtError, [mbOK], 0);
          Application.Terminate;
        end;

end;  {DataModuleCreate}

end.
