unit Phistfrm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Types, DB, DBTables, Grids, ComCtrls,
  ExtCtrls;

type
  THistorySummaryForm = class(TForm)
    AssessmentNotesTable: TTable;
    Panel1: TPanel;
    HistoryPageControl: TPageControl;
    SummaryTabSheet: TTabSheet;
    HistoryStringGrid: TStringGrid;
    AssessmentTabSheet: TTabSheet;
    AssessmentStringGrid: TStringGrid;
    Panel2: TPanel;
    SchoolCodeLabel: TLabel;
    ParcelCreateLabel: TLabel;
    SplitMergeInfoLabel1: TLabel;
    SplitMergeInfoLabel2: TLabel;
    CloseButton: TBitBtn;
    procedure CloseButtonClick(Sender: TObject);
    procedure HistoryStringGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure AssessmentStringGridDrawCell(Sender: TObject; Col,
      Row: Integer; Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    ParcelTable, AssessmentTable,
    ParcelExemptionTable, ExemptionCodeTable : TTable;
    { Public declarations }

    Procedure InitializeForm(SwisSBLKey : String);

    Procedure FillInYearInfo(    SwisSBLKey : String;
                                 ProcessingType : Integer;
                                 TaxRollYr,
                                 TaxRollYrToDisplay : String;
                                 UsePriorFields : Boolean;
                             var SplitMergeNo,
                                 SplitMergeYear,
                                 SplitMergeRelationship,
                                 SplitMergeRelatedParcelID : String;
                             var RowIndex : Integer);

    Procedure FillInSummaryGrid(    SwisSBLKey : String;
                                var SplitMergeNo : String;
                                var SplitMergeYear : String;
                                var SplitMergeRelationship : String;
                                var SplitMergeRelatedParcelID : String);

    Procedure FillInSplitMergeInformation(SplitMergeNo : String;
                                          SplitMergeYear : String;
                                          SplitMergeRelationship : String;
                                          SplitMergeRelatedParcelID : String);

    Procedure FillInAssessmentInformationForOneYear(SwisSBLKey : String;
                                                    AssessmentYear : String;
                                                    ProcessingType : Integer;
                                                    CurrentRow : Integer);

    Procedure FillInAssessmentGrid(SwisSBLKey : String);

  end;

var
  HistorySummaryForm: THistorySummaryForm;

implementation

{$R *.DFM}

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     DataModule, Math,
     GlblCnst;

const
  smYearColumn = 0;
  smOwnerColumn = 1;
  smHomesteadColumn = 2;
  smAVColumn = 3;
  smTAVColumn = 4;
  smRSColumn = 5;
  smPropertyClassColumn = 6;
  smBasicSTARColumn = 7;
  smEnhancedSTARColumn = 8;
  smSeniorColumn = 9;
  smAlternateVetColumn = 10;
  smOtherExemptionColumn = 11;

  avYearColumn = 0;
  avLandAssessmentColumn = 1;
  avTotalAssessmentColumn = 2;
  avUniformPercentOrRARColumn = 3;
  avFullMarketColumn = 4;
  avDifferenceColumn = 5;
  avAssessmentNotesColumn = 6;
  avPhysicalIncreaseColumn = 6;
  avEqualizationIncreaseColumn = 7;
  avPhysicalDecreaseColumn = 8;
  avEqualizationDecreaseColumn = 9;

{=================================================================}
Procedure THistorySummaryForm.FillInYearInfo(    SwisSBLKey : String;
                                                 ProcessingType : Integer;
                                                 TaxRollYr,
                                                 TaxRollYrToDisplay : String;
                                                 UsePriorFields : Boolean;
                                             var SplitMergeNo,
                                                 SplitMergeYear,
                                                 SplitMergeRelationship,
                                                 SplitMergeRelatedParcelID : String;
                                             var RowIndex : Integer);

var
  BasicSTARAmount, EnhancedSTARAmount,
  AssessedVal, TaxableVal,
  SeniorAmount, AlternateVetAmount, OtherExemptionAmount : Comp;
  ExemptionTotaled, ParcelFound : Boolean;
  ExemptArray : ExemptionTotalsArrayType;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  PropertyClass : String;
  BankCode : String;
  _Name : String;
  OwnershipCode, RollSection, HomesteadCode : String;
  SchoolCode : String;
  AssessedValStr, TaxableValStr : String;
  SBLRec : SBLRecord;
  I : Integer;

begin
    {CHG11231999-1: Add columns for senior, alt vet, other ex.}

  PropertyClass := '';
  BankCode := '';
  _Name := '';
  OwnershipCode := '';
  RollSection := '';
  HomesteadCode := '';
  SchoolCode := '';
  AssessedValStr := '';
  TaxableValStr := '';
  BasicSTARAmount := 0;
  EnhancedSTARAmount := 0;
  SeniorAmount := 0;
  AlternateVetAmount := 0;
  OtherExemptionAmount := 0;

  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  ParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                        ProcessingType);
  AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                            ProcessingType);
  ParcelExemptionTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                 ProcessingType);
  ExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                               ProcessingType);

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    ParcelFound := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot',
                               'Suffix'],
                              [TaxRollYr, SwisCode, Section, Subsection,
                               Block, Lot, Sublot, Suffix]);

  FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                              [TaxRollYr, SwisSBLKey]);

  with HistoryStringGrid do
    begin
      ColWidths[smYearColumn] := 20;
      ColWidths[smOwnerColumn] := 78;
      ColWidths[smAVColumn] := 70;
      ColWidths[smHomesteadColumn] := 20;
      ColWidths[smTAVColumn] := 70;
      ColWidths[smRSColumn] := 20;
      ColWidths[smPropertyClassColumn] := 33;
      ColWidths[smBasicSTARColumn] := 60;
      ColWidths[smEnhancedSTARColumn] := 60;
      ColWidths[smSeniorColumn] := 48;
      ColWidths[smAlternateVetColumn] := 48;
      ColWidths[smOtherExemptionColumn] := 64;

    end;  {with HistoryStringGrid do}

  with ParcelTable do
    If ParcelFound
      then
        If UsePriorFields
          then
            begin
              AssessedVal := AssessmentTable.FieldByName('PriorTotalValue').AsFloat;
              AssessedValStr := FormatFloat(CurrencyDisplayNoDollarSign, AssessedVal);
              TaxableValStr := 'Not on file';

              PropertyClass := FieldByName('PriorPropertyClass').Text;
              OwnershipCode := FieldByName('PriorOwnershipCode').Text;
              SchoolCode := FieldByName('PriorSchoolDistrict').Text;
              _Name := 'Not on file';
              RollSection := FieldByName('PriorRollSection').Text;
              HomesteadCode := FieldByName('PriorHomesteadCode').Text;
            end
          else
            begin
              AssessedVal := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;

              ExemptArray := TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
                                                      ParcelExemptionTable,
                                                      ExemptionCodeTable,
                                                      ParcelTable.FieldByName('HomesteadCode').Text,
                                                      'A',
                                                      ExemptionCodes,
                                                      ExemptionHomesteadCodes,
                                                      ResidentialTypes,
                                                      CountyExemptionAmounts,
                                                      TownExemptionAmounts,
                                                      SchoolExemptionAmounts,
                                                      VillageExemptionAmounts,
                                                      BasicSTARAmount,
                                                      EnhancedSTARAmount);

              For I := 0 to (ExemptionCodes.Count - 1) do
                begin
                  ExemptionTotaled := False;

                  If ((Take(4, ExemptionCodes[I]) = '4112') or
                      (Take(4, ExemptionCodes[I]) = '4113') or
                      (Take(4, ExemptionCodes[I]) = '4114'))
                    then
                      begin
                        AlternateVetAmount := AlternateVetAmount + StrToFloat(TownExemptionAmounts[I]);
                        ExemptionTotaled := True;
                      end;

                  If (Take(4, ExemptionCodes[I]) = '4180')
                    then
                      begin
                        SeniorAmount := SeniorAmount + StrToFloat(TownExemptionAmounts[I]);
                        ExemptionTotaled := True;
                      end;

                  If not ExemptionTotaled
                    then OtherExemptionAmount := OtherExemptionAmount + StrToFloat(TownExemptionAmounts[I]);

                end;  {For I := 0 to (ExemptionCodes.Count - 1) do}

              TaxableVal := Max((AssessedVal - ExemptArray[EXTown]), 0);

              AssessedValStr := FormatFloat(CurrencyDisplayNoDollarSign, AssessedVal);
              TaxableValStr := FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal);

              PropertyClass := FieldByName('PropertyClassCode').Text;
              OwnershipCode := FieldByName('OwnershipCode').Text;
              SchoolCode := FieldByName('SchoolCode').Text;
              _Name := FieldByName('Name1').Text;
              RollSection := FieldByName('RollSection').Text;
              HomesteadCode := FieldByName('HomesteadCode').Text;

            end;  {else of If UsePriorFields}

  If ParcelFound
    then
      begin
        with HistoryStringGrid do
          begin
            Cells[smYearColumn, RowIndex] := Copy(TaxRollYrToDisplay, 3, 2);
            Cells[smOwnerColumn, RowIndex] := Take(11, _Name);
            Cells[smAVColumn, RowIndex] := AssessedValStr;
            Cells[smHomesteadColumn, RowIndex] := HomesteadCode;

             {FXX05012000-8: If the parcel is inactive, then say so.}

            If ParcelIsActive(ParcelTable)
              then
                begin
                  Cells[smTAVColumn, RowIndex] := TaxableValStr;
                  Cells[smRSColumn, RowIndex] := RollSection;
                  Cells[smPropertyClassColumn, RowIndex] := PropertyClass + OwnershipCode;
                  Cells[smBasicSTARColumn, RowIndex] := FormatFloat(NoDecimalDisplay_BlankZero, BasicSTARAmount);
                  Cells[smEnhancedSTARColumn, RowIndex] := FormatFloat(NoDecimalDisplay_BlankZero, EnhancedSTARAmount);
                  Cells[smSeniorColumn, RowIndex] := FormatFloat(NoDecimalDisplay_BlankZero, SeniorAmount);
                  Cells[smAlternateVetColumn, RowIndex] := FormatFloat(NoDecimalDisplay_BlankZero, AlternateVetAmount);
                  Cells[smOtherExemptionColumn, RowIndex] := FormatFloat(NoDecimalDisplay_BlankZero, OtherExemptionAmount);
                end
              else Cells[smTAVColumn, RowIndex] := InactiveLabelText;

            RowIndex := RowIndex + 1;

          end;  {with HistoryStringGrid do}

        ParcelCreateLabel.Caption := 'Parcel Created: ' +
                                     ParcelTable.FieldByName('ParcelCreatedDate').Text;

        SchoolCodeLabel.Caption := 'School Code: ' +
                                   ParcelTable.FieldByName('SchoolCode').Text;

          {CHG03302000-3: Show split\merge information - display most recent.}
          {If there is split merge info, fill it in.  Note that we do not
           fill it in if there is already info - we want to show the most
           recent and we are working backwards through the years.}

        If ((Deblank(SplitMergeNo) = '') and
            (Deblank(ParcelTable.FieldByName('SplitMergeNo').Text) <> ''))
          then
            begin
              SplitMergeNo := ParcelTable.FieldByName('SplitMergeNo').Text;
              SplitMergeYear := TaxRollYr;
              SplitMergeRelatedParcelID := ParcelTable.FieldByName('RelatedSBL').Text;

              If (Deblank(SplitMergeRelatedParcelID) = '')
                then
                  begin
                    SplitMergeRelatedParcelID := 'unknown';
                    SplitMergeRelationship := 'unknown';
                  end
                else
                  begin
                    SplitMergeRelationship := ParcelTable.FieldByName('SBLRelationship').Text;
                    SplitMergeRelationship := Take(1, SplitMergeRelationship);

                    case SplitMergeRelationship[1] of
                      'C' : SplitMergeRelationship := 'Parent';
                      'P' : SplitMergeRelationship := 'Child';
                    end;

                  end;  {else of If (Deblank(SplitMergeRelatedParcelID) = '')}

            end;  {If ((Deblank(SplitMergeNo) = '') and ...}

      end;  {If ParcelFound}

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {FillInYearInfo}

{=================================================================}
Procedure THistorySummaryForm.FillInSummaryGrid(    SwisSBLKey : String;
                                                var SplitMergeNo : String;
                                                var SplitMergeYear : String;
                                                var SplitMergeRelationship : String;
                                                var SplitMergeRelatedParcelID : String);

var
  Index, TempTaxYear : Integer;
  TaxRollYear, PriorTaxYear : String;
  TaxYearFound : Boolean;
  TempStr : String;

begin
  Index := 1;
  If ((not GlblUserIsSearcher) or
      SearcherCanSeeNYValues)
    then FillInYearInfo(SwisSBLKey, NextYear, GlblNextYear, GlblNextYear, False,
                        SplitMergeNo, SplitMergeYear,
                        SplitMergeRelationship,
                        SplitMergeRelatedParcelID, Index);

  FillInYearInfo(SwisSBLKey, ThisYear, GlblThisYear, GlblThisYear, False,
                 SplitMergeNo, SplitMergeYear,
                 SplitMergeRelationship,
                 SplitMergeRelatedParcelID, Index);

  TempTaxYear := StrToInt(GlblThisYear);
  PriorTaxYear := IntToStr(TempTaxYear - 1);

  ParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                        History);

  If HistoryExists
    then
      begin
        repeat
          FillInYearInfo(SwisSBLKey, History, PriorTaxYear, PriorTaxYear, False,
                         SplitMergeNo, SplitMergeYear,
                         SplitMergeRelationship,
                         SplitMergeRelatedParcelID, Index);

            {Now try back one more year.}

          TempTaxYear := StrToInt(PriorTaxYear);
          PriorTaxYear := IntToStr(TempTaxYear - 1);

          FindNearestOld(ParcelTable,
                         ['TaxRollYr', 'SwisCode', 'Section',
                          'Subsection', 'Block', 'Lot', 'Sublot',
                          'Suffix'],
                         [PriorTaxYear, '      ', '   ', '   ', '    ',
                          '   ', '   ', '    ']);

          TaxYearFound := (ParcelTable.FieldByName('TaxRollYr').Text = PriorTaxYear);
          TempStr := ParcelTable.FieldByName('TaxRollYr').Text;

            {Now do the prior in history.}

          If not TaxYearFound
            then
              begin
                TaxRollYear := IntToStr(TempTaxYear);
                FillInYearInfo(SwisSBLKey, History, TaxRollYear,
                               PriorTaxYear, True,
                               SplitMergeNo, SplitMergeYear,
                               SplitMergeRelationship,
                               SplitMergeRelatedParcelID, Index);

              end;  {If not TaxYearFound}

        until (not TaxYearFound);
      end
    else FillInYearInfo(SwisSBLKey, ThisYear, GlblThisYear, PriorTaxYear, True,
                        SplitMergeNo, SplitMergeYear,
                        SplitMergeRelationship,
                        SplitMergeRelatedParcelID, Index);

  with HistoryStringGrid do
    begin
      Cells[smYearColumn, 0] := 'Yr';
      Cells[smOwnerColumn, 0] := 'Owner';
      Cells[smAVColumn, 0] := 'Assessed';
      Cells[smHomesteadColumn, 0] := 'HC';
      Cells[smTAVColumn, 0] := 'Taxable';
      Cells[smRSColumn, 0] := 'RS';
      Cells[smPropertyClassColumn, 0] := 'Class';
      Cells[smBasicSTARColumn, 0] := 'Res STAR';
      Cells[smEnhancedSTARColumn, 0] := 'Enh STAR';
      Cells[smSeniorColumn, 0] := 'Senior';
      Cells[smAlternateVetColumn, 0] := 'Alt Vet';
      Cells[smOtherExemptionColumn, 0] := 'Other EX';

    end;  {with HistoryStringGrid do}

end;  {FillInSummaryGrid}

{=================================================================}
Procedure THistorySummaryForm.FillInSplitMergeInformation(SplitMergeNo : String;
                                                          SplitMergeYear : String;
                                                          SplitMergeRelationship : String;
                                                          SplitMergeRelatedParcelID : String);

begin
  SplitMergeInfoLabel1.Visible := True;
  SplitMergeInfoLabel2.Visible := True;

  SplitMergeInfoLabel1.Caption := 'S\M #: ' + SplitMergeNo + ' (' +
                                  SplitMergeYear + ')';
  SplitMergeInfoLabel2.Caption := 'Related Parcel: ' + SplitMergeRelatedParcelID +
                                  ' (' + SplitMergeRelationship + ')';

end;  {FillInSplitMergeInformation}

{=================================================================}
Procedure THistorySummaryForm.FillInAssessmentInformationForOneYear(SwisSBLKey : String;
                                                                    AssessmentYear : String;
                                                                    ProcessingType : Integer;
                                                                    CurrentRow : Integer);

var
  ParcelTable, AssessmentTable, SwisCodeTable : TTable;
  FoundAssessment, IsUniformPercent, Quit : Boolean;
  SBLRec : SBLRecord;
  TempPercent, FullMarketValue : Double;

begin
  AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                            ProcessingType);
  SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                          ProcessingType);
  ParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                        ProcessingType);

  OpenTableForProcessingType(AssessmentNotesTable, AssessmentNotesTableName,
                             ProcessingType, Quit);

  If (ProcessingType = History)
    then
      begin
        SwisCodeTable.Filter := 'TaxRollYr=' + AssessmentYear;
        SwisCodeTable.Filtered := True;
      end
    else SwisCodeTable.Filtered := False;

  FoundAssessment := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                                [AssessmentYear, SwisSBLKey]);

  If FoundAssessment
    then
      begin
        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          FindKeyOld(ParcelTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                     [AssessmentYear, SwisCode, Section, Subsection,
                      Block, Lot, Sublot, Suffix]);

        FindKeyOld(SwisCodeTable, ['SwisCode'], [Copy(SwisSBLKey, 1, 6)]);

        with AssessmentStringGrid, AssessmentTable do
          begin
            FullMarketValue := ComputeFullValue(FieldByName('TotalAssessedVal').AsFloat,
                                                SwisCodeTable,
                                                ParcelTable.FieldByName('PropertyClassCode').Text,
                                                ParcelTable.FieldByname('OwnershipCode').Text,
                                                False);

              {CHG10162004-1(2.8.0.14): If this is a parcel that uses the RAR, show it.}

            with ParcelTable do
              TempPercent := GetUniformPercentOrRAR(SwisCodeTable,
                                                    FieldByName('PropertyClassCode').Text,
                                                    FieldByName('OwnershipCode').Text,
                                                    False, IsUniformPercent);

            Cells[avYearColumn, CurrentRow] := Copy(AssessmentYear, 3, 2);
            Cells[avLandAssessmentColumn, CurrentRow] := FormatFloat(CurrencyDisplayNoDollarSign,
                                                                     FieldByName('LandAssessedVal').AsFloat);
            Cells[avTotalAssessmentColumn, CurrentRow] := FormatFloat(CurrencyDisplayNoDollarSign,
                                                                      FieldByName('TotalAssessedVal').AsInteger);

              {CHG10162004-1(2.8.0.14): If this is a parcel that uses the RAR, show it.}

            Cells[avUniformPercentOrRARColumn, CurrentRow] := FormatFloat(DecimalEditDisplay, TempPercent);
            Cells[avFullMarketColumn, CurrentRow] := FormatFloat(CurrencyDisplayNoDollarSign,
                                                                 FullMarketValue);

              {CHG10162004-3(2.8.0.14): Option to show the AV notes on the history screen.}

            If GlblShowAssessmentNotesOnAVHistoryScreen
              then
                begin
                  If FindKeyOld(AssessmentNotesTable, ['TaxRollYr', 'SwisSBLKey'],
                                [AssessmentYear, SwisSBLKey])
                    then Cells[avAssessmentNotesColumn, CurrentRow] := AssessmentNotesTable.FieldByName('Note').AsString
                    else Cells[avAssessmentNotesColumn, CurrentRow] := '';
                end
              else
                begin
                  Cells[avPhysicalIncreaseColumn, CurrentRow] := FormatFloat(CurrencyDisplayNoDollarSign,
                                                                             FieldByName('PhysicalQtyIncrease').AsFloat);
                  Cells[avEqualizationIncreaseColumn, CurrentRow] := FormatFloat(CurrencyDisplayNoDollarSign,
                                                                                 FieldByName('IncreaseForEqual').AsFloat);
                  Cells[avPhysicalDecreaseColumn, CurrentRow] := FormatFloat(CurrencyDisplayNoDollarSign,
                                                                             FieldByName('PhysicalQtyDecrease').AsFloat);
                  Cells[avEqualizationDecreaseColumn, CurrentRow] := FormatFloat(CurrencyDisplayNoDollarSign,
                                                                                 FieldByName('DecreaseForEqual').AsFloat);

                end;  {else of If GlblShowAssessmentNotesOnAVHistoryScreen}

          end;  {with AssessmentStringGrid do}

      end;  {If FoundAssessment}

  SwisCodeTable.Filtered := False;

end;  {FillInAssessmentInformationForOneYear}

{=================================================================}
Procedure THistorySummaryForm.FillInAssessmentGrid(SwisSBLKey : String);

var
  Done, FirstTimeThrough, FirstYearFound : Boolean;
  AssessmentYearControlTable : TTable;
  I, CurrentRow : Integer;
  PriorAssessedValue, CurrentAssessedValue : LongInt;

begin
    {First fill in the column headers.}

  with AssessmentStringGrid do
    begin
      Cells[avYearColumn, 0] := 'Yr';
      Cells[avLandAssessmentColumn, 0] := 'Land AV';
      Cells[avTotalAssessmentColumn, 0] := 'Total AV';

        {CHG10162004-1(2.8.0.14): If this is a parcel that uses the RAR, show it.}

      If GlblUseRAR
        then Cells[avUniformPercentOrRARColumn, 0] := 'Unf%\RAR'
        else Cells[avUniformPercentOrRARColumn, 0] := 'Unif %';

      Cells[avFullMarketColumn, 0] := 'Full Mkt Val';
      Cells[avDifferenceColumn, 0] := 'AV Diff';

        {CHG10162004-3(2.8.0.14): Option to show the AV notes on the history screen.}

      If GlblShowAssessmentNotesOnAVHistoryScreen
        then
          begin
            ColWidths[6] := ColWidths[avPhysicalIncreaseColumn] +
                            ColWidths[avEqualizationIncreaseColumn] +
                            ColWidths[avPhysicalDecreaseColumn] +
                            ColWidths[avEqualizationDecreaseColumn] + 3;

            ColCount := 7;

            Cells[avAssessmentNotesColumn, 0] := 'Assessment Notes';
          end
        else
          begin
            Cells[avPhysicalIncreaseColumn, 0] := 'Phys Inc';
            Cells[avEqualizationIncreaseColumn, 0] := 'Eq Inc';
            Cells[avPhysicalDecreaseColumn, 0] := 'Phys Dec';
            Cells[avEqualizationDecreaseColumn, 0] := 'Eq Dec';

          end;  {If GlblShowAssessmentNotesOnAVHistoryScreen}

    end;  {with AssessmentStringGrid do}

  FillInAssessmentInformationForOneYear(SwisSBLKey, GlblNextYear, NextYear, 1);
  FillInAssessmentInformationForOneYear(SwisSBLKey, GlblThisYear, ThisYear, 2);

  AssessmentYearControlTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName,
                                                                       History);

  AssessmentYearControlTable.IndexName := 'BYTAXROLLYR';
  AssessmentYearControlTable.Last;

  Done := False;
  FirstTimeThrough := True;
  CurrentRow := 3;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else AssessmentYearControlTable.Prior;

    If AssessmentYearControlTable.BOF
      then Done := True;

    If not Done
      then
        begin
          FillInAssessmentInformationForOneYear(SwisSBLKey,
                                                AssessmentYearControlTable.FieldByName('TaxRollYr').Text,
                                                History, CurrentRow);

          CurrentRow := CurrentRow + 1;

        end;  {If not Done}

  until Done;

    {CHG10162004-2(2.8.0.14): Instead of equalization rate, show the difference in AV between years.}

  PriorAssessedValue := 0;
  CurrentAssessedValue := 0;
  FirstYearFound := True;

  with AssessmentStringGrid do
    For I := (RowCount - 1) downto 1 do
      If (Trim(Cells[avYearColumn, I]) <> '')
        then
          begin
            If FirstYearFound
              then
                begin
                  Cells[avDifferenceColumn, I] := 'Unknown';
                  FirstYearFound := False;
                end
              else
                begin
                  try
                    CurrentAssessedValue := StrToInt(StringReplace(Cells[avTotalAssessmentColumn, I], ',', '', [rfReplaceAll]))
                  except
                  end;

                  Cells[avDifferenceColumn, I] := FormatFloat(CurrencyDisplayNoDollarSign,
                                                              (CurrentAssessedValue - PriorAssessedValue));

                end;  {else of If (I = 0)}

            try
              PriorAssessedValue := StrToInt(StringReplace(Cells[avTotalAssessmentColumn, I], ',', '', [rfReplaceAll]));
            except
            end;

          end;  {I (Trim(Cells[avYearColumn]) <> '')}

end;  {FillInAssessmentGrid}

{=================================================================}
Procedure THistorySummaryForm.InitializeForm(SwisSBLKey : String);

var
  SplitMergeNo, SplitMergeYear,
  SplitMergeRelationship,
  SplitMergeRelatedParcelID : String;

begin
    {CHG09142004-1(2.8.0.11): Include the parcel ID in the caption.}

  Caption := 'Parcel History for ' + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

  GlblDialogBoxShowing := True;

  HistoryPageControl.ActivePage := SummaryTabSheet;
  SplitMergeNo := '';
  SplitMergeYear := '';
  SplitMergeRelationship := '';
  SplitMergeRelatedParcelID := '';
  SplitMergeInfoLabel1.Caption := '';
  SplitMergeInfoLabel2.Caption := '';

    {FXX03302000-4: Clear the string grid 1st.}

  ClearStringGrid(HistoryStringGrid);
  ClearStringGrid(AssessmentStringGrid);

  FillInSummaryGrid(SwisSBLKey, SplitMergeNo, SplitMergeYear,
                    SplitMergeRelationship, SplitMergeRelatedParcelID);

    {CHG03212004-2(2.08): Add assessment page with full market value and assessment history.}
    {CHG11012004-2(2.8.0.16)[1963]: Make the assessment tab visible to the searcher if they
                                    show assessment notes on the AV history screen.}

  If (GlblUserIsSearcher and
      (not GlblShowAssessmentNotesOnAVHistoryScreen))
    then AssessmentTabSheet.TabVisible := False
    else FillInAssessmentGrid(SwisSBLKey);

    {CHG03302000-3: Show split\merge information - display most recent.}

  If (Deblank(SplitMergeNo) <> '')
    then FillInSplitMergeInformation(SplitMergeNo, SplitMergeYear,
                                     SplitMergeRelationship,
                                     SplitMergeRelatedParcelID);

end;  {InitializeForm}

{===============================================================}
Procedure THistorySummaryForm.HistoryStringGridDrawCell(Sender: TObject;
                                                        Col, Row: Longint;
                                                        Rect: TRect;
                                                        State: TGridDrawState);

var
  ACol, ARow : LongInt;
  TempColor : TColor;

begin
  ACol := Col;
  ARow := Row;
  TempColor := clBlue;

  with HistoryStringGrid do
    begin
      Canvas.Font.Size := 9;
      Canvas.Font.Name := 'Arial';
      Canvas.Font.Style := [fsBold];
    end;

  with HistoryStringGrid do
    If (ARow > 0)
      then
        begin
          case ACol of
            smYearColumn : TempColor := clBlack;
            smRSColumn,
            smHomesteadColumn,
            smPropertyClassColumn : TempColor := clNavy;
            smOwnerColumn : TempColor := clGreen;
            smAVColumn,
            smTAVColumn,
            smBasicSTARColumn,
            smEnhancedSTARColumn,
            smSeniorColumn,
            smAlternateVetColumn,
            smOtherExemptionColumn : TempColor := clPurple;

          end;  {case ARow of}

          HistoryStringGrid.Canvas.Font.Color := TempColor;

        end;  {If (ARow > 0)}

    {Header row.}

  If (ARow = 0)
    then HistoryStringGrid.Canvas.Font.Color := clBlue;

  with HistoryStringGrid do
    If (ARow = 0)
      then CenterText(CellRect(ACol, ARow), Canvas, Cells[ACol, ARow], True,
                      True, clBtnFace)
      else
        case ACol of
          smYearColumn,
          smRSColumn,
          smHomesteadColumn,
          smPropertyClassColumn,
          smOwnerColumn : LeftJustifyText(CellRect(ACol, ARow), Canvas,
                                          Cells[ACol, ARow], True,
                                          False, clWhite, 2);

          smAVColumn,
          smTAVColumn,
          smBasicSTARColumn,
          smEnhancedSTARColumn,
          smSeniorColumn,
          smAlternateVetColumn,
          smOtherExemptionColumn : RightJustifyText(CellRect(ACol, ARow), Canvas,
                                                    Cells[ACol, ARow], True,
                                                    False, clWhite, 2);

        end;  {case ACol of}

end;  {HistoryStringGridDrawCell}

{===============================================================}
Procedure THistorySummaryForm.AssessmentStringGridDrawCell(Sender: TObject;
                                                           Col, Row: Integer;
                                                           Rect: TRect;
                                                           State: TGridDrawState);

var
  ACol, ARow : LongInt;
  TempColor : TColor;

begin
  ACol := Col;
  ARow := Row;
  TempColor := clBlue;

  with AssessmentStringGrid do
    begin
      Canvas.Font.Size := 9;
      Canvas.Font.Name := 'Arial';
      Canvas.Font.Style := [fsBold];
    end;

  with AssessmentStringGrid do
    If (ARow > 0)
      then
        begin
          case ACol of
            avYearColumn : TempColor := clBlack;
            avUniformPercentOrRARColumn : TempColor := clNavy;
            avDifferenceColumn,
            avLandAssessmentColumn,
            avTotalAssessmentColumn : TempColor := clGreen;
            avPhysicalIncreaseColumn,
            avEqualizationIncreaseColumn,
            avPhysicalDecreaseColumn,
            avEqualizationDecreaseColumn : TempColor := clPurple;
            avFullMarketColumn : TempColor := clRed;

          end;  {case ARow of}

          AssessmentStringGrid.Canvas.Font.Color := TempColor;

        end;  {If (ARow > 0)}

    {Header row.}

  If (ARow = 0)
    then AssessmentStringGrid.Canvas.Font.Color := clBlue;

  with AssessmentStringGrid do
    If (ARow = 0)
      then
        begin
          If ((ACol = avUniformPercentOrRARColumn) and
              GlblUseRAR)
            then TwoLineText(CellRect(ACol, ARow), Canvas, 'Unif %', 'or RAR', True,
                             True, clBtnFace)
            else CenterText(CellRect(ACol, ARow), Canvas, Cells[ACol, ARow], True,
                            True, clBtnFace);

        end
      else
        case ACol of
          avYearColumn : LeftJustifyText(CellRect(ACol, ARow), Canvas,
                                         Cells[ACol, ARow], True,
                                         False, clWhite, 2);


          avAssessmentNotesColumn :
            If GlblShowAssessmentNotesOnAVHistoryScreen
              then LeftJustifyText(CellRect(ACol, ARow), Canvas,
                                   Cells[ACol, ARow], True, False, clWhite, 2)
              else RightJustifyText(CellRect(ACol, ARow), Canvas,
                                    Cells[ACol, ARow], True, False, clWhite, 2);

          avUniformPercentOrRARColumn,
          avDifferenceColumn,
          avLandAssessmentColumn,
          avTotalAssessmentColumn,
          avFullMarketColumn,
          avEqualizationIncreaseColumn,
          avPhysicalDecreaseColumn,
          avEqualizationDecreaseColumn : RightJustifyText(CellRect(ACol, ARow), Canvas,
                                                          Cells[ACol, ARow], True,
                                                          False, clWhite, 2);

        end;  {case ACol of}

end;  {AssessmentStringGridDrawCell}

{===============================================================}
Procedure THistorySummaryForm.CloseButtonClick(Sender: TObject);

begin
  Close;
  GlblDialogBoxShowing := False;
end;

end.