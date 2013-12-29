unit PEnhancedHistoryForm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Types, DB, DBTables, ComCtrls, Grids;

type
  TEnhancedHistoryForm = class(TForm)
    ParcelCreateLabel: TLabel;
    SplitMergeInfoLabel1: TLabel;
    SchoolCodeLabel: TLabel;
    SplitMergeInfoLabel2: TLabel;
    CloseButton: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    HistoryTreeView: TTreeView;
    HistoryStringGrid: TStringGrid;
    procedure HistoryStringGridDrawCell(Sender: TObject; Col,
      Row: Integer; Rect: TRect; State: TGridDrawState);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }

    ParcelTable, AssessmentTable,
    ParcelExemptionTable, ExemptionCodeTable,
    ParcelSDTable, SDCodeTable, ClassTable : TTable;

    Procedure FillInDetailedYearInfo(    SwisSBLKey : String;
                                         ProcessingType : Integer;
                                         TaxRollYr,
                                         TaxRollYrToDisplay : String;
                                         UsePriorFields : Boolean;
                                     var SplitMergeNo,
                                         SplitMergeYear,
                                         SplitMergeRelationship,
                                         SplitMergeRelatedParcelID : String);

    Procedure FillInNonYearDependantDetailedInfo(SwisSBLKey : String);

    Procedure FillInSummaryYearInfo(    SwisSBLKey : String;
                                        ProcessingType : Integer;
                                        TaxRollYr,
                                        TaxRollYrToDisplay : String;
                                        UsePriorFields : Boolean;
                                    var SplitMergeNo,
                                        SplitMergeYear,
                                        SplitMergeRelationship,
                                        SplitMergeRelatedParcelID : String;
                                    var RowIndex : Integer);

    Procedure InitializeForm(SwisSBLKey : String);
  end;

var
  EnhancedHistoryForm: TEnhancedHistoryForm;

implementation

{$R *.DFM}

uses PASTypes, PASUtils, WinUtils, Utilitys, GlblVars, GlblCnst,
     UtilEXSD, DataModule;

const
  YearColumn = 0;
  OwnerColumn = 1;
  HomesteadColumn = 2;
  AVColumn = 3;
  TAVColumn = 4;
  RSColumn = 5;
  PropertyClassColumn = 6;
  BasicSTARColumn = 7;
  EnhancedSTARColumn = 8;
  SeniorColumn = 9;
  AlternateVetColumn = 10;
  OtherExemptionColumn = 11;

{=================================================================}
Procedure TEnhancedHistoryForm.FillInSummaryYearInfo(    SwisSBLKey : String;
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

  with HistoryStringGrid do
    begin
      ColWidths[YearColumn] := 20;
      ColWidths[OwnerColumn] := 80;
      ColWidths[AVColumn] := 70;
      ColWidths[HomesteadColumn] := 20;
      ColWidths[TAVColumn] := 70;
      ColWidths[RSColumn] := 20;
      ColWidths[PropertyClassColumn] := 33;
      ColWidths[BasicSTARColumn] := 60;
      ColWidths[EnhancedSTARColumn] := 60;
      ColWidths[SeniorColumn] := 48;
      ColWidths[AlternateVetColumn] := 48;
      ColWidths[OtherExemptionColumn] := 64;

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

              TaxableVal := AssessedVal - ExemptArray[EXTown];

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
            Cells[YearColumn, RowIndex] := Copy(TaxRollYrToDisplay, 3, 2);
            Cells[OwnerColumn, RowIndex] := Take(11, _Name);
            Cells[AVColumn, RowIndex] := AssessedValStr;
            Cells[HomesteadColumn, RowIndex] := HomesteadCode;

             {FXX05012000-8: If the parcel is inactive, then say so.}

            If ParcelIsActive(ParcelTable)
              then
                begin
                  Cells[TAVColumn, RowIndex] := TaxableValStr;
                  Cells[RSColumn, RowIndex] := RollSection;
                  Cells[PropertyClassColumn, RowIndex] := PropertyClass + OwnershipCode;
                  Cells[BasicSTARColumn, RowIndex] := FormatFloat(NoDecimalDisplay_BlankZero, BasicSTARAmount);
                  Cells[EnhancedSTARColumn, RowIndex] := FormatFloat(NoDecimalDisplay_BlankZero, EnhancedSTARAmount);
                  Cells[SeniorColumn, RowIndex] := FormatFloat(NoDecimalDisplay_BlankZero, SeniorAmount);
                  Cells[AlternateVetColumn, RowIndex] := FormatFloat(NoDecimalDisplay_BlankZero, AlternateVetAmount);
                  Cells[OtherExemptionColumn, RowIndex] := FormatFloat(NoDecimalDisplay_BlankZero, OtherExemptionAmount);
                end
              else Cells[TAVColumn, RowIndex] := InactiveLabelText;

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

end;  {FillInSummaryYearInfo}

{=================================================================}
Procedure AddSpecialDistrictInformation(HistoryTreeView : TTreeView;
                                        TaxYearNode : TTreeNode;
                                        ParcelSDTable : TTable;
                                        AssessmentYear : String;
                                        SwisSBLKey : String);

var
  Done, FirstTimeThrough : Boolean;
  PageLevelNode : TTreeNode;
  Units, SecondaryUnits, CalcCode,
  TempStr, SDPercentage, CalcAmount : String;

begin
  Done := False;
  FirstTimeThrough := True;

  SetRangeOld(ParcelSDTable, ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
              [AssessmentYear, SwisSBLKey, '     '],
              [AssessmentYear, SwisSBLKey, 'ZZZZZ']);

  ParcelSDTable.First;

  If not ParcelSDTable.EOF
    then
      begin
        PageLevelNode := HistoryTreeView.Items.AddChildFirst(TaxYearNode, 'Special Districts');

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelSDTable.Next;

          If ParcelSDTable.EOF
            then Done := True;

          If not Done
            then
              with HistoryTreeView.Items, ParcelSDTable do
                begin
                  Units := FormatFloat(DecimalDisplay_BlankZero,
                                       FieldByName('PrimaryUnits').AsFloat);
                  SecondaryUnits := FormatFloat(DecimalDisplay_BlankZero,
                                                FieldByName('SecondaryUnits').AsFloat);
                  SDPercentage := FormatFloat(DecimalDisplay_BlankZero,
                                              FieldByName('SDPercentage').AsFloat);
                  CalcCode := FieldByName('CalcCode').Text;
                  CalcAmount := FormatFloat(DecimalDisplay_BlankZero,
                                            FieldByName('CalcAmount').AsFloat);

                  TempStr := ParcelSDTable.FieldByName('SDistCode').Text;

                  If (Deblank(Units) <> '')
                    then TempStr := TempStr + '    Units: ' + Units;

                  If (Deblank(SecondaryUnits) <> '')
                    then TempStr := TempStr + '    2nc Units: ' + SecondaryUnits;

                  If (Deblank(SDPercentage) <> '')
                    then TempStr := TempStr + '    %: ' + SDPercentage;

                  If (Deblank(CalcCode) <> '')
                    then TempStr := TempStr + '    Calc Code: ' + CalcCode;

                  If (Deblank(CalcAmount) <> '')
                    then TempStr := TempStr + '    Override Amt: ' + CalcAmount;

                  TempStr := TempStr + '    Initial Date: ' +
                             FieldByName('DateAdded').Text;

                  AddChild(PageLevelNode, TempStr);

                end;  {with HistoryTreeView.Items, ParcelSDTable do}

        until Done;

      end;  {If not ParcelSDTable.EOF}

end;  {AddSpecialDistrictInformation}

{=================================================================}
Procedure TEnhancedHistoryForm.FillInDetailedYearInfo(    SwisSBLKey : String;
                                                          ProcessingType : Integer;
                                                          TaxRollYr,
                                                          TaxRollYrToDisplay : String;
                                                          UsePriorFields : Boolean;
                                                      var SplitMergeNo,
                                                          SplitMergeYear,
                                                          SplitMergeRelationship,
                                                          SplitMergeRelatedParcelID : String);

var
  BasicSTARAmount, EnhancedSTARAmount,
  LandAssessedVal, AssessedVal, TaxableVal,
  EqualizationIncrease, EqualizationDecrease,
  PhysicalIncrease, PhysicalDecrease : Comp;
  Found, Quit, ClassRecordFound, PartiallyAssessed,
  ExemptionTotaled, ParcelFound, AssessmentFound : Boolean;
  ExemptArray : ExemptionTotalsArrayType;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  PropertyClass : String;
  _Name : String;
  OwnershipCode, RollSection, HomesteadCode : String;
  SchoolCode : String;
  SBLRec : SBLRecord;
  I : Integer;
  TaxYearNode, PageLevelNode, SubPageLevelNode : TTreeNode;
  TempStr, ActiveStatus, LandAssessedValStr, AssessedValStr,
  CountyTaxableValStr, TownTaxableValStr, SchoolTaxableValStr : String;
  NAddrArray : NameAddrArray;

begin
  For I := 1 to 6 do
    NAddrArray[I] := '';

  PropertyClass := '';
  _Name := '';
  OwnershipCode := '';
  RollSection := '';
  HomesteadCode := '';
  SchoolCode := '';
  BasicSTARAmount := 0;
  EnhancedSTARAmount := 0;
  PartiallyAssessed := False;

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
  ClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                       ProcessingType);
  ParcelExemptionTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                 ProcessingType);
  ExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                               ProcessingType);
  ParcelSDTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictTableName,
                                                          ProcessingType);
  SDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                        ProcessingType);
  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    ParcelFound := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot',
                               'Suffix'],
                              [TaxRollYr, SwisCode, Section, Subsection,
                               Block, Lot, Sublot, Suffix]);

  ClassRecordFound := FindKeyOld(ClassTable,
                                 ['TaxRollYr', 'SwisSBLKey'],
                                 [TaxRollYr, SwisSBLKey]);

  with ParcelTable do
    If ParcelFound
      then
        If UsePriorFields
          then
            begin
              AssessedVal := AssessmentTable.FieldByName('PriorTotalValue').AsFloat;
              AssessedValStr := FormatFloat(CurrencyDisplayNoDollarSign, AssessedVal);
              LandAssessedVal := AssessmentTable.FieldByName('PriorLandValue').AsFloat;
              LandAssessedValStr := FormatFloat(CurrencyDisplayNoDollarSign, LandAssessedVal);
              CountyTaxableValStr := 'Not on file';
              TownTaxableValStr := 'N/A';
              SchoolTaxableValStr := 'N/A';

              PropertyClass := FieldByName('PriorPropertyClass').Text;
              OwnershipCode := FieldByName('PriorOwnershipCode').Text;
              SchoolCode := FieldByName('PriorSchoolDistrict').Text;
              _Name := 'Not on file';
              RollSection := FieldByName('PriorRollSection').Text;
              HomesteadCode := FieldByName('PriorHomesteadCode').Text;
              ActiveStatus := FieldByName('HoldPriorStatus').Text;

              If (Deblank(ActiveStatus) <> '')
                then ActiveStatus := 'A';

              PartiallyAssessed := False;

            end
          else
            begin
              with AssessmentTable do
                begin
                  AssessedVal := FieldByName('TotalAssessedVal').AsFloat;
                  LandAssessedVal := FieldByName('LandAssessedVal').AsFloat;

                end;  {with AssessmentTable do}

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

              AssessedValStr := FormatFloat(CurrencyDisplayNoDollarSign, AssessedVal);
              LandAssessedValStr := FormatFloat(CurrencyDisplayNoDollarSign, LandAssessedVal);
              CountyTaxableValStr := FormatFloat(CurrencyDisplayNoDollarSign, (AssessedVal - ExemptArray[EXCounty]));
              TownTaxableValStr := FormatFloat(CurrencyDisplayNoDollarSign, (AssessedVal - ExemptArray[EXTown]));
              SchoolTaxableValStr := FormatFloat(CurrencyDisplayNoDollarSign, (AssessedVal - ExemptArray[EXSchool]));

              PropertyClass := FieldByName('PropertyClassCode').Text;
              OwnershipCode := FieldByName('OwnershipCode').Text;
              SchoolCode := FieldByName('SchoolCode').Text;
              _Name := '';
              RollSection := FieldByName('RollSection').Text;
              HomesteadCode := FieldByName('HomesteadCode').Text;
              ActiveStatus := FieldByName('ActiveFlag').Text;

              PartiallyAssessed := AssessmentTable.FieldByName('PartialAssessment').AsBoolean;

              GetNameAddress(ParcelTable, NAddrArray);

            end;  {else of If UsePriorFields}

  If ParcelFound
    then
      begin
        with HistoryTreeView.Items, ParcelTable do
          begin
            If (ActiveStatus = InactiveParcelFlag)
              then TempStr := '   ****  INACTIVE ****'
              else TempStr := '';

            TaxYearNode := Add(nil, TaxRollYrToDisplay + TempStr);

              {Base Information}

            PageLevelNode := AddChild(TaxYearNode, 'Basic Information');

            AddChild(PageLevelNode, 'Owner \ Mailing Address:');

            If (Deblank(_Name) = '')
              then
                begin
                  For I := 1 to 6 do
                    If (Deblank(NAddrArray[I]) <> '')
                      then AddChild(PageLevelNode, '   ' + NAddrArray[I]);

                  TempStr := 'Bank: ' +  FieldByName('BankCode').Text;

                  If (Roundoff(FieldByName('Acreage').AsFloat, 2) > 0)
                    then TempStr := TempStr + '    Acres: ' +
                                              FormatFloat(DecimalEditDisplay, FieldByName('Acreage').AsFloat)
                    else TempStr := TempStr + '    Frontage: ' +
                                              FormatFloat(DecimalEditDisplay, FieldByName('Frontage').AsFloat) +
                                              '    Depth: ' +
                                              FormatFloat(DecimalEditDisplay, FieldByName('Depth').AsFloat);

                  AddChild(PageLevelNode, TempStr);

                end
              else AddChild(PageLevelNode, '    ' + _Name);

            AddChild(PageLevelNode, 'Legal Address: ' + GetLegalAddressFromTable(ParcelTable));

            TempStr := 'Prop Class: ' + PropertyClass + OwnershipCode +
                       '    Roll Section: ' + RollSection;

            If GlblMunicipalityIsClassified
              then TempStr := TempStr + '    Homestead Code: ' + HomesteadCode;

            AddChild(PageLevelNode, TempStr);

              {Assessment}

            PageLevelNode := AddChild(TaxYearNode, 'Assessment');

            If PartiallyAssessed
              then TempStr := '    ** Partially Assessed **';

            AddChild(PageLevelNode, 'Land Value: ' + LandAssessedValStr +
                                    '    Total Value: ' + AssessedValStr +
                                    TempStr);
            AddChild(PageLevelNode, 'County Taxable: ' + CountyTaxableValStr +
                                    '    ' + GetMunicipalityTypeName(GlblMunicipalityType) +
                                           ' Taxable: ' +
                                           TownTaxableValStr +
                                    '    School Taxable: ' + SchoolTaxableValStr);

            TempStr := '';

            with AssessmentTable do
              begin
                If ((Roundoff(FieldByName('IncreaseForEqual').AsFloat, 2) > 0) or
                    (Roundoff(FieldByName('PhysicalQtyIncrease').AsFloat, 2) > 0))
                  then AddChild(PageLevelNode, 'Equalization Increase: ' +
                                               FormatFloat(CurrencyDisplayNoDollarSign,
                                                           FieldByName('IncreaseForEqual').AsFloat) +
                                               '    ' +
                                               'Physical Qty Increase: ' +
                                               FormatFloat(CurrencyDisplayNoDollarSign,
                                                           FieldByName('PhysicalQtyIncrease').AsFloat));

                If ((Roundoff(FieldByName('DecreaseForEqual').AsFloat, 2) > 0) or
                    (Roundoff(FieldByName('PhysicalQtyDecrease').AsFloat, 2) > 0))
                  then AddChild(PageLevelNode, 'Equalization Decrease: ' +
                                               FormatFloat(CurrencyDisplayNoDollarSign,
                                                           FieldByName('DecreaseForEqual').AsFloat) +
                                               '    ' +
                                               'Physical Qty Decrease: ' +
                                               FormatFloat(CurrencyDisplayNoDollarSign,
                                                           FieldByName('PhysicalQtyDecrease').AsFloat));

              end;  {with AssessmentTable do}

              {Class info}

            If ClassRecordFound
              then
                begin
                  PageLevelNode := AddChild(TaxYearNode, 'Class Values');

                  SubPageLevelNode := AddChild(PageLevelNode, 'Homestead Values');
                  AddChild(SubPageLevelNode, 'Acres: ' +
                                             FormatFloat(DecimalEditDisplay,
                                                         FieldByName('HstdAcres').AsFloat) +
                                             '   Land %: ' +
                                             FormatFloat(DecimalEditDisplay,
                                                         FieldByName('HstdLandPercent').AsFloat) +
                                             '   Total %: ' +
                                             FormatFloat(DecimalEditDisplay,
                                                         FieldByName('HstdTotalPercent').AsFloat));

                  AddChild(SubPageLevelNode, 'Land Value: ' +
                                             FormatFloat(CurrencyDisplayNoDollarSign,
                                                         FieldByName('HstdLandVal').AsFloat) +
                                             '   Total Value: ' +
                                             FormatFloat(CurrencyDisplayNoDollarSign,
                                                         FieldByName('HstdTotalVal').AsFloat));

                  If ((Roundoff(FieldByName('HstdEqualInc').AsFloat, 2) > 0) or
                      (Roundoff(FieldByName('HstdPhysQtyInc').AsFloat, 2) > 0))
                    then AddChild(PageLevelNode, 'Equalization Increase: ' +
                                                 FormatFloat(CurrencyDisplayNoDollarSign,
                                                             FieldByName('HstdEqualInc').AsFloat) +
                                                 '    ' +
                                                 'Physical Qty Increase: ' +
                                                 FormatFloat(CurrencyDisplayNoDollarSign,
                                                             FieldByName('HstdPhysQtyInc').AsFloat));

                  If ((Roundoff(FieldByName('HstdEqualDec').AsFloat, 2) > 0) or
                      (Roundoff(FieldByName('HstdPhysQtyDec').AsFloat, 2) > 0))
                    then AddChild(PageLevelNode, 'Equalization Decrease: ' +
                                                 FormatFloat(CurrencyDisplayNoDollarSign,
                                                             FieldByName('HstdEqualDec').AsFloat) +
                                                 '    ' +
                                                 'Physical Qty Decrease: ' +
                                                 FormatFloat(CurrencyDisplayNoDollarSign,
                                                             FieldByName('HstdPhysQtyDec').AsFloat));

                  SubPageLevelNode := AddChild(PageLevelNode, 'Nonhomestead Values');
                  AddChild(SubPageLevelNode, 'Acres: ' +
                                             FormatFloat(DecimalEditDisplay,
                                                         FieldByName('NonhstdAcres').AsFloat) +
                                             '   Land %: ' +
                                             FormatFloat(DecimalEditDisplay,
                                                         FieldByName('NonhstdLandPercent').AsFloat) +
                                             '   Total %: ' +
                                             FormatFloat(DecimalEditDisplay,
                                                         FieldByName('NonhstdTotalPercent').AsFloat));

                  AddChild(SubPageLevelNode, 'Land Value: ' +
                                             FormatFloat(CurrencyDisplayNoDollarSign,
                                                         FieldByName('NonhstdLandVal').AsFloat) +
                                             '   Total Value: ' +
                                             FormatFloat(CurrencyDisplayNoDollarSign,
                                                         FieldByName('NonhstdTotalVal').AsFloat));

                  If ((Roundoff(FieldByName('NonhstdEqualInc').AsFloat, 2) > 0) or
                      (Roundoff(FieldByName('NonhstdPhysQtyInc').AsFloat, 2) > 0))
                    then AddChild(PageLevelNode, 'Equalization Increase: ' +
                                                 FormatFloat(CurrencyDisplayNoDollarSign,
                                                             FieldByName('NonhstdEqualInc').AsFloat) +
                                                 '    ' +
                                                 'Physical Qty Increase: ' +
                                                 FormatFloat(CurrencyDisplayNoDollarSign,
                                                             FieldByName('NonhstdPhysQtyInc').AsFloat));

                  If ((Roundoff(FieldByName('NonhstdEqualDec').AsFloat, 2) > 0) or
                      (Roundoff(FieldByName('NonhstdPhysQtyDec').AsFloat, 2) > 0))
                    then AddChild(PageLevelNode, 'Equalization Decrease: ' +
                                                 FormatFloat(CurrencyDisplayNoDollarSign,
                                                             FieldByName('NonhstdEqualDec').AsFloat) +
                                                 '    ' +
                                                 'Physical Qty Decrease: ' +
                                                 FormatFloat(CurrencyDisplayNoDollarSign,
                                                             FieldByName('NonhstdPhysQtyDec').AsFloat));

                end;  {If ClassRecordFound}

              {Exemption info}

            If ((ExemptionCodes.Count > 0) or
                (Roundoff(BasicSTARAmount, 0) > 0) or
                (Roundoff(EnhancedSTARAmount, 0) > 0))
              then
                begin
                  PageLevelNode := AddChild(TaxYearNode, 'Exemptions');

                  For I := 0 to (ExemptionCodes.Count - 1) do
                    AddChild(PageLevelNode, 'Code: ' + ExemptionCodes[I] +
                                            '    County: ' +
                                            FormatFloat(CurrencyDisplayNoDollarSign,
                                                        StrToFloat(CountyExemptionAmounts[I])) +
                                            '    ' + GetMunicipalityTypeName(GlblMunicipalityType) + ': ' +
                                            FormatFloat(CurrencyDisplayNoDollarSign,
                                                        StrToFloat(TownExemptionAmounts[I])) +
                                            '    School: ' +
                                            FormatFloat(CurrencyDisplayNoDollarSign,
                                                        StrToFloat(SchoolExemptionAmounts[I])));

                  If (Roundoff(BasicSTARAmount, 0) > 0)
                    then AddChild(PageLevelNode, 'Basic STAR: ' +
                                                 FormatFloat(CurrencyDisplayNoDollarSign,
                                                             BasicSTARAmount));

                  If (Roundoff(EnhancedSTARAmount, 0) > 0)
                    then AddChild(PageLevelNode, 'Enhanced STAR: ' +
                                                 FormatFloat(CurrencyDisplayNoDollarSign,
                                                             EnhancedSTARAmount));

                end;  {If (ExemptionCodes.Count > 0)}

              {Special district info}

            AddSpecialDistrictInformation(HistoryTreeView, TaxYearNode,
                                          ParcelSDTable, TaxRollYr,
                                          SwisSBLKey);

          end;  {with HistoryTreeView.Items do}

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

end;  {FillInDetailedYearInfo}

{=================================================================}
Procedure TEnhancedHistoryForm.FillInNonYearDependantDetailedInfo(SwisSBLKey : String);

var
  Done, FirstTimeThrough : Boolean;
  PageLevelNode, SubPageLevelNode : TTreeNode;
  SalesTable, RemovedExemptionTable, NotesTable : TTable;
  TempStr : String;

begin
  Done := False;
  FirstTimeThrough := True;

  SalesTable := PASDataModule.SalesTable;
  SetRangeOld(SalesTable, ['SwisSBLKey', 'SaleNumber'],
              [SwisSBLKey, '0'], [SwisSBLKey, '32000']);

  SalesTable.First;

  If not SalesTable.EOF
    then PageLevelNode := HistoryTreeView.Items.AddChild(nil, 'Sales');

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SalesTable.Next;

    If SalesTable.EOF
      then Done := True;

    If not Done
      then
        with HistoryTreeView.Items, SalesTable do
          begin
            SubPageLevelNode := AddChild(PageLevelNode, 'Sale #: ' + FieldByName('SaleNumber').Text);

            If (Deblank(FieldByName('DateEntered').Text) <> '')
              then TempStr := '   Date Entered: ' + FieldByName('DateEntered').Text
              else TempStr := '';

            AddChild(SubPageLevelNode, 'Sale Year: ' + FieldByName('SaleAssessmentYear').Text +
                                       '   Sale Date: ' + FieldByName('SaleDate').Text +
                                       TempStr);
            AddChild(SubPageLevelNode, 'Old Owner: ' + FieldByName('OldOwnerName').Text +
                                       '    New Owner: ' + FieldByName('NewOwnerName').Text);
            AddChild(SubPageLevelNode, 'Price: ' + FormatFloat(CurrencyNormalDisplay,
                                                               FieldByName('SalePrice').AsFloat) +
                                       '   Number of Parcels: ' + FieldByName('NoParcels').Text +
                                       '   Sale Type: ' + FieldByName('SaleTypeDesc').Text);

            If (Deblank(FieldByName('DateTransmitted').Text) <> '')
              then TempStr := '   Date Transmitted: ' + FieldByName('DateTransmitted').Text
              else TempStr := '';

            If (Deblank(FieldByName('SaleConditionCode').Text) <> '')
              then TempStr := '   Conditions: ' + FieldByName('SaleConditionCode').Text;

            AddChild(SubPageLevelNode, 'Valid: ' + BoolToStr(FieldByName('ValidSale').AsBoolean) +
                                       '   Arm''s Length: ' + BoolToStr(FieldByName('ArmsLength').AsBoolean) +
                                       '   Status Code: ' + FieldByName('SaleStatusCode').Text +
                                       TempStr);

            AddChild(SubPageLevelNode, 'Deed Date: ' + FieldByName('DeedDate').Text +
                                       '   Book: ' + FieldByName('DeedBook').Text +
                                       '   Page: ' + FieldByName('DeedPage').Text +
                                       '   Type: ' + FieldByName('DeedTypeDesc').Text);

          end;  {with HistoryTreeView.Items do}

    until Done;

end;  {FillInNonYearDependantDetailedInfo}

{=================================================================}
Procedure TEnhancedHistoryForm.InitializeForm(SwisSBLKey : String);

var
  Index, TempTaxYear : Integer;
  TaxRollYear, PriorTaxYear : String;
  Quit, TaxYearFound : Boolean;
  TempStr,
  SplitMergeNo, SplitMergeYear,
  SplitMergeRelationship,
  SplitMergeRelatedParcelID : String;

begin
  GlblDialogBoxShowing := True;
  Index := 1;
  ClearStringGrid(HistoryStringGrid);

  SplitMergeNo := '';
  SplitMergeYear := '';
  SplitMergeRelationship := '';
  SplitMergeRelatedParcelID := '';
  SplitMergeInfoLabel1.Caption := '';
  SplitMergeInfoLabel2.Caption := '';

  If ((not GlblUserIsSearcher) or
      SearcherCanSeeNYValues)
    then
      begin
        FillInDetailedYearInfo(SwisSBLKey, NextYear, GlblNextYear, GlblNextYear, False,
                               SplitMergeNo, SplitMergeYear,
                               SplitMergeRelationship,
                               SplitMergeRelatedParcelID);

        FillInSummaryYearInfo(SwisSBLKey, NextYear, GlblNextYear, GlblNextYear, False,
                              SplitMergeNo, SplitMergeYear,
                              SplitMergeRelationship,
                              SplitMergeRelatedParcelID, Index);

      end;  {If ((not GlblUserIsSearcher) or ...}

  FillInDetailedYearInfo(SwisSBLKey, ThisYear, GlblThisYear, GlblThisYear, False,
                         SplitMergeNo, SplitMergeYear,
                         SplitMergeRelationship,
                         SplitMergeRelatedParcelID);

  FillInSummaryYearInfo(SwisSBLKey, ThisYear, GlblThisYear, GlblThisYear, False,
                        SplitMergeNo, SplitMergeYear,
                        SplitMergeRelationship,
                        SplitMergeRelatedParcelID, Index);

  TempTaxYear := StrToInt(GlblThisYear);
  PriorTaxYear := IntToStr(TempTaxYear - 1);
  TaxYearFound := True;

  ParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                        History);

  If HistoryExists
    then
      begin
        repeat
          FillInDetailedYearInfo(SwisSBLKey, History, PriorTaxYear, PriorTaxYear, False,
                                 SplitMergeNo, SplitMergeYear,
                                 SplitMergeRelationship,
                                 SplitMergeRelatedParcelID);

          FillInSummaryYearInfo(SwisSBLKey, History, PriorTaxYear, PriorTaxYear, False,
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
                FillInDetailedYearInfo(SwisSBLKey, History, TaxRollYear,
                                       PriorTaxYear, True,
                                       SplitMergeNo, SplitMergeYear,
                                       SplitMergeRelationship,
                                       SplitMergeRelatedParcelID);

                FillInSummaryYearInfo(SwisSBLKey, History, TaxRollYear,
                                      PriorTaxYear, True,
                                      SplitMergeNo, SplitMergeYear,
                                      SplitMergeRelationship,
                                      SplitMergeRelatedParcelID, Index);

              end;  {If not TaxYearFound}

        until (not TaxYearFound);
      end
    else
      begin
        FillInDetailedYearInfo(SwisSBLKey, ThisYear, GlblThisYear, PriorTaxYear, True,
                               SplitMergeNo, SplitMergeYear,
                               SplitMergeRelationship,
                               SplitMergeRelatedParcelID);

        FillInSummaryYearInfo(SwisSBLKey, ThisYear, GlblThisYear, PriorTaxYear, True,
                              SplitMergeNo, SplitMergeYear,
                              SplitMergeRelationship,
                              SplitMergeRelatedParcelID, Index);

      end;  {If HistoryExists}

    {Now fill in the non-year dependant info like sales, notes, removed exemptions,
     and audit information.}

  FillInNonYearDependantDetailedInfo(SwisSBLKey);

  with HistoryStringGrid do
    begin
      Cells[YearColumn, 0] := 'Yr';
      Cells[OwnerColumn, 0] := 'Owner';
      Cells[AVColumn, 0] := 'Assessed';
      Cells[HomesteadColumn, 0] := 'HC';
      Cells[TAVColumn, 0] := 'Taxable';
      Cells[RSColumn, 0] := 'RS';
      Cells[PropertyClassColumn, 0] := 'Class';
      Cells[BasicSTARColumn, 0] := 'Res STAR';
      Cells[EnhancedSTARColumn, 0] := 'Enh STAR';
      Cells[SeniorColumn, 0] := 'Senior';
      Cells[AlternateVetColumn, 0] := 'Alt Vet';
      Cells[OtherExemptionColumn, 0] := 'Other EX';

    end;  {with HistoryStringGrid do}

    {CHG03302000-3: Show split\merge information - display most recent.}

  If (Deblank(SplitMergeNo) <> '')
    then
      begin
        SplitMergeInfoLabel1.Visible := True;
        SplitMergeInfoLabel2.Visible := True;

        SplitMergeInfoLabel1.Caption := 'S\M #: ' + SplitMergeNo + ' (' +
                                        SplitMergeYear + ')';
        SplitMergeInfoLabel2.Caption := 'Related Parcel: ' + SplitMergeRelatedParcelID +
                                        ' (' + SplitMergeRelationship + ')';

      end;  {If (Deblank(SplitMergeNo) <> '')}

end;  {InitializeForm}

{===================================================================}
Procedure TEnhancedHistoryForm.HistoryStringGridDrawCell(Sender: TObject;
                                                         Col, Row: Longint;
                                                         Rect: TRect;
                                                         State: TGridDrawState);

var
  BackgroundColor : TColor;
  Selected : Boolean;
  ACol, ARow : LongInt;
  TempStr : String;
  TempColor : TColor;

begin
  ACol := Col;
  ARow := Row;

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
            YearColumn : TempColor := clBlack;
            RSColumn,
            HomesteadColumn,
            PropertyClassColumn : TempColor := clNavy;
            OwnerColumn : TempColor := clGreen;
            AVColumn,
            TAVColumn,
            BasicSTARColumn,
            EnhancedSTARColumn,
            SeniorColumn,
            AlternateVetColumn,
            OtherExemptionColumn : TempColor := clPurple;

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
          YearColumn,
          RSColumn,
          HomesteadColumn,
          PropertyClassColumn,
          OwnerColumn : LeftJustifyText(CellRect(ACol, ARow), Canvas,
                                        Cells[ACol, ARow], True,
                                        False, clWhite, 2);

          AVColumn,
          TAVColumn,
          BasicSTARColumn,
          EnhancedSTARColumn,
          SeniorColumn,
          AlternateVetColumn,
          OtherExemptionColumn : RightJustifyText(CellRect(ACol, ARow), Canvas,
                                                Cells[ACol, ARow], True,
                                                False, clWhite, 2);

        end;  {case ACol of}

end;  {HistoryStringGridDrawCell}

{=============================================================}
Procedure TEnhancedHistoryForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{=============================================================}
Procedure TEnhancedHistoryForm.FormClose(    Sender: TObject;
                                         var Action: TCloseAction);

begin
  Action := caFree;
  GlblDialogBoxShowing := False;
end;  {FormClose}

end.