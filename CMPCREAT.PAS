unit Cmpcreat;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,pastypes,
  GlblCnst,Types, RPFiler, RPBase, RPCanvas, RPrinter, (*Progress,*) RPDefine,
  Mask;

type
  TCreateComparablesFileForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ReportFiler: TReportFiler;
    ParcelTable: TTable;
    AssessmentTable: TTable;
    ResidentialSiteTable: TTable;
    ResidentialBldgTable: TTable;
    InstructionLabel: TLabel;
    SalesTable: TTable;
    CompAssmtMinMaxTable: TwwTable;
    TableDeleteStatusMsgLabel: TLabel;
    CompSalesTable: TwwTable;
    SalesResidentialSiteTable: TTable;
    CompSalesMinMaxTable: TwwTable;
    SalesResidentialBldgTable: TTable;
    ResidentialImprovementTable: TTable;
    SalesResidentialImprovementTable: TTable;
    CompAssmtTable: TwwTable;
    StartButton: TBitBtn;
    AssessmentYearRadioGroup: TRadioGroup;
    Label1: TLabel;
    SalesDateEdit: TMaskEdit;
    cbxFillInBlankInformationFromCurrentData: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    TaxRollYear : String;
    ForceSalesComparablesAfterDate : TDateTime;
    bFillInBlankInformationFromCurrentData : Boolean;
    Procedure InitializeForm;  {Open the tables and setup.}
    Function GetCompRecords : Boolean;
    Procedure UpdateAssmtMinMaxRangeFile(CompAssmtMinMaxTable : TTable);
    Procedure UpdateSalesMinMaxRangeFile(CompSalesMinMaxFile : TTable);
    Function GetCompSalesRecords(var UseSalesInventory : Boolean) : Boolean;
    Procedure GetImprovements(CompTable,
                              ResidentialImprovementTable : TTable;
                              SwisSBLKey : String;
                              SiteNumber : Integer;
                              SalesComps : Boolean);
    Procedure ProcessCommonCompFields(CompTable,
                                      MainTable,
                                      ResSiteTable,
                                      ResBldgTable : TTable;
                                      SwisSBLKey : String;
                                      SalesComps : Boolean);
    Procedure AssignCommonMinMaxFields(MinMaxTable, CompTable: TTable);
    Procedure UpdateCommonMinMaxFields(MinMaxTable, CompTable: TTable);

    Procedure StoreAssessmentComprables;
    Procedure StoreSalesComprables;
  end;

{$R *.DFM}

implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Prog, Preview;

const
  TrialRun = false;

{========================================================}
Procedure TCreateComparablesFileForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TCreateComparablesFileForm.InitializeForm;

begin
  UnitName := 'CMPCREAT';  {mmm}

end;  {InitializeForm}

{=========================================================================================}
Function TCreateComparablesFileForm.GetCompRecords : Boolean;

{get the records for this parcel}

var
  _Found : Boolean;
  SwisSBLKey : String;

begin
  SwisSBLKey := ExtractSSKey(ParcelTable);

  _Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                       [TaxRollYear, SwisSBLKey]);

  If _Found
    then
      begin
        FindNearestOld(ResidentialSiteTable,
                       ['TaxRollYr', 'SwisSBLKey', 'Site'],
                       [TaxRollYear, SwisSBLKey, '0']);

        _Found := (Take(26, ResidentialSiteTable.FieldByName('SwisSBLKey').Text) =
                   Take(26, SwisSBLKey));

      end;  {If Found}

  If _Found
    then
      begin
        FindNearestOld(ResidentialBldgTable,
                       ['TaxRollYr', 'SwisSBLKey', 'Site'],
                       [TaxRollYear, SwisSBLKey,
                        ResidentialSiteTable.FieldByName('Site').Text]);

        with ResidentialBldgTable do
          _Found := ((Take(26, FieldByName('SwisSBLKey').Text) = Take(26, SwisSBLKey)) and
                     (FieldByName('Site').Text = ResidentialSiteTable.FieldByName('Site').Text));

      end;  {If Found}

    {must not store a comp record unless these basic codes are present}

  If (_Found and
      ((Deblank(ParcelTable.FieldByName('PropertyClassCode').Text) = '') or
       (Deblank(ResidentialSiteTable.FieldByName('NeighborhoodCode').Text) = '') or
       (Deblank(ResidentialBldgTable.FieldByName('BuildingStyleCode').AsString) = '')))
    then _Found := False;

  Result := _Found;

end;  {GetCompRecords}

{========================================================================}
Function TCreateComparablesFileForm.GetCompSalesRecords(var UseSalesInventory : Boolean) : Boolean;

{get at least 1 SALES  inventory record pair (site/bldg) for this parcel}

var
  Found : Boolean;
  SwisSBLKey : String;
  SaleNumber : Integer;
  SBLRec : SBLRecord;

begin
    {FXX03292002-4: Not correctly returning whether or not to use sales
                    inventory tables.}

  UseSalesInventory := True;

  SwisSBLKey := SalesTable.FieldByName('SwisSBLKey').Text;
  SaleNumber := SalesTable.FieldByName('SaleNumber').AsInteger;

  FindNearestOld(SalesResidentialSiteTable, ['SwisSBLKey', 'SalesNumber', 'Site'],
                 [SwisSBLKey, IntToStr(SaleNumber), '0']);

  Found := (SalesResidentialSiteTable.FieldByName('SwisSBLKey').Text = SwisSBlKey);

  If Found
    then Found := FindKeyOld(SalesResidentialBldgTable,
                             ['SwisSBLKey', 'SalesNumber', 'Site'],
                             [SwisSBLKey, IntToStr(SaleNumber),
                              SalesResidentialSiteTable.FieldByName('Site').Text]);

  If (Found and
      ((Deblank(SalesTable.FieldByName('PropClass').Text) = '') or
       (Deblank(SalesResidentialSiteTable.FieldByName('NeighborhoodCode').Text) = '') or
       (Deblank(SalesResidentialBldgTable.FieldByName('BuildingStyleCode').Text) = '')))
    then Found := False;

    {CHG10292001-1: Allow them to associate current inventory with a sale
                    if no sales data is available.}
    {FXX03292002-5: We should only do this if the information is not found above.}

  If ((not Found) and
      (bFillInBlankInformationFromCurrentData or
       ((Roundoff(ForceSalesComparablesAfterDate, 0) > 0) and
       (SalesTable.FieldByName('SaleDate').AsDateTime > ForceSalesComparablesAfterDate))))
    then
      begin
           {FXX03292002-4: Not correctly returning whether or not to use sales
                           inventory tables.}

        UseSalesInventory := False;

          {We haven't found any inventory for this sale, so see if we
           can find any on the main parcel.  To do this, locate the parcel
           and then call the function that checks for inventory on
           the main parcel.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot',
                               'Suffix'],
                              [TaxRollYear, SwisCode, Section, SubSection,
                               Block, Lot, Sublot, Suffix]);

        If Found
          then Found := GetCompRecords;

      end;  {If (Roundoff(ForceSalesComparablesAfterDate, 0) > 0)}

  Result := Found;

end;  {GetCompSalesRecords}

{===========================================================================}
Procedure TCreateComparablesFileForm.AssignCommonMinMaxFields(MinMaxTable,
                                                              CompTable: TTable);

var
  TempAcres : Double;

begin
  TempAcres := GetAcres(CompTable.FieldByName('Acreage').AsFloat,
                        CompTable.FieldByName('Frontage').AsFloat,
                        CompTable.FieldByName('Depth').AsFloat);

  with MinMaxTable do
     begin
       FieldByName('SwisCode').Text := Take(6,CompTable.FieldByName('SwisCode').Text);
       FieldByName('PropertyClass').Text := Take(3,CompTable.FieldByName('PropertyClass').Text);
       FieldByName('NeighborHood').Text := Take(5,CompTable.FieldByName('NeighborHood').Text);
       FieldByName('BuildingStyleCode').Text := Take(2,CompTable.FieldByName('BuildingStyleCode').Text);
       FieldByName('GroupParcelCount').AsInteger := 1;
       FieldByName('ActualYearBuiltMin').Text := CompTable.FieldByName('ActualYearBuilt').Text;
       FieldByName('ConditionCodeMin').Text := CompTable.FieldByName('ConditionCode').Text;
       FieldByName('OverallGradeCodeMin').Text := CompTable.FieldByName('OverallGradeCode').Text;
       FieldByName('SqFootLivingAreaMin').AsInteger := CompTable.FieldByName('SqFootLivingArea').AsInteger;
       FieldByName('FirstStoryAreaMin').AsInteger := CompTable.FieldByName('FirstStoryArea').AsInteger;
       FieldByName('NumberOfStoriesMin').AsFloat := CompTable.FieldByName('NumberOfStories').AsFloat;
       FieldByName('NumberOfBedroomsMin').AsInteger := CompTable.FieldByName('NumberOfBedrooms').AsInteger;
       FieldByName('NumberOfBathroomsMin').AsFloat := CompTable.FieldByName('NumberOfBathrooms').AsFloat;
       FieldByName('NumberOfFirePlcsMin').AsInteger := CompTable.FieldByName('NumFireplaces').AsInteger;
       FieldByName('AcreageMin').AsFloat := TempAcres;
       FieldByName('EastCoordMin').AsInteger := CompTable.FieldByName('EastCoord').AsInteger;
       FieldByName('NorthCoordMin').AsInteger := CompTable.FieldByName('NorthCoord').AsInteger;
       FieldByName('ActualYearBuiltMax').Text := CompTable.FieldByName('ActualYearBuilt').Text;
       FieldByName('ConditionCodeMax').Text := CompTable.FieldByName('ConditionCode').Text;
       FieldByName('OverallGradeCodeMax').Text := CompTable.FieldByName('OverallGradeCode').Text;
       FieldByName('SqFootLivingAreaMax').AsInteger := CompTable.FieldByName('SqFootLivingArea').AsInteger;
       FieldByName('FirstStoryAreaMax').AsInteger := CompTable.FieldByName('FirstStoryArea').AsInteger;
       FieldByName('NumberOfStoriesMax').AsFloat := CompTable.FieldByName('NumberOfStories').AsFloat;
       FieldByName('NumberOfBedroomsMax').AsInteger := CompTable.FieldByName('NumberOfBedrooms').AsInteger;
       FieldByName('NumberOfBathroomsMax').AsFloat := CompTable.FieldByName('NumberOfBathrooms').AsFloat;
       FieldByName('NumberOfFirePlcsMax').AsFloat := CompTable.FieldByName('NumFireplaces').AsFloat;
       FieldByName('AcreageMax').AsFloat := CompTable.FieldByName('Acreage').AsFloat;
       FieldByName('EastCoordMax').AsInteger := CompTable.FieldByName('EastCoord').AsInteger;
       FieldByName('NorthCoordMax').AsInteger := CompTable.FieldByName('NorthCoord').AsInteger;

     end;  {with MinMaxTable do}

end;  {AssignCommonMinMaxFields}

{===========================================================================}
Procedure TCreateComparablesFileForm.UpdateCommonMinMaxFields(MinMaxTable,
                                                              CompTable: TTable);

var
  TempAcres : Double;

begin
  TempAcres := GetAcres(CompTable.FieldByName('Acreage').AsFloat,
                        CompTable.FieldByName('Frontage').AsFloat,
                        CompTable.FieldByName('Depth').AsFloat);

  with MinMaxTable do
    begin
      FieldByName('GroupParcelCount').AsInteger := FieldByName('GroupParcelCount').AsInteger + 1;

      If (FieldByName('ActualYearBuiltMin').Text > CompTable.FieldByName('ActualYearBuilt').Text)
        then FieldByName('ActualYearBuiltMin').Text := CompTable.FieldByName('ActualYearBuilt').Text;

      If (FieldByName('ConditionCodeMin').Text > CompTable.FieldByName('ConditionCode').Text)
        then FieldByName('ConditionCodeMin').Text := CompTable.FieldByName('ConditionCode').Text;

      If (FieldByName('OverallGradeCodeMin').Text > CompTable.FieldByName('OverallGradeCode').Text)
        then FieldByName('OverallGradeCodeMin').Text := CompTable.FieldByName('OverallGradeCode').Text;

      If (FieldByName('SqFootLivingAreaMin').AsInteger > CompTable.FieldByName('SqFootLivingArea').AsInteger)
        then FieldByName('SqFootLivingAreaMin').AsInteger := CompTable.FieldByName('SqFootLivingArea').AsInteger;

      If (FieldByName('FirstStoryAreaMin').AsInteger > CompTable.FieldByName('FirstStoryArea').AsInteger)
        then FieldByName('FirstStoryAreaMin').AsInteger := CompTable.FieldByName('FirstStoryArea').AsInteger;

      If (FieldByName('NumberOfStoriesMin').AsFloat > CompTable.FieldByName('NumberOfStories').AsFloat)
        then FieldByName('NumberOfStoriesMin').AsFloat := CompTable.FieldByName('NumberOfStories').AsFloat;

      If (FieldByName('NumberOfBedroomsMin').AsInteger > CompTable.FieldByName('NumberOfBedrooms').AsInteger)
        then FieldByName('NumberOfBedroomsMin').AsInteger := CompTable.FieldByName('NumberOfBedrooms').AsInteger;

      If (FieldByName('NumberOfBathroomsMin').AsFloat > CompTable.FieldByName('NumberOfBathrooms').AsFloat)
        then FieldByName('NumberOfBathroomsMin').AsFloat := CompTable.FieldByName('NumberOfBathrooms').AsFloat;

      If (FieldByName('NumberOfFirePlcsMin').AsInteger > CompTable.FieldByName('NumFireplaces').AsInteger)
        then FieldByName('NumberOfFirePlcsMin').AsInteger :=  CompTable.FieldByName('NumFireplaces').AsInteger;

      If (FieldByName('AcreageMin').AsFloat > TempAcres)
        then FieldByName('AcreageMin').AsFloat := TempAcres;

      If (FieldByName('EastCoordMin').AsInteger > CompTable.FieldByName('EastCoord').AsInteger)
        then FieldByName('EastCoordMin').AsInteger := CompTable.FieldByName('EastCoord').AsInteger;

      If (FieldByName('NorthCoordMin').AsInteger > CompTable.FieldByName('NorthCoord').AsInteger)
        then FieldByName('NorthCoordMin').AsInteger := CompTable.FieldByName('NorthCoord').AsInteger;

      If (FieldByName('ActualYearBuiltMax').Text < CompTable.FieldByName('ActualYearBuilt').Text)
        then FieldByName('ActualYearBuiltMax').Text := CompTable.FieldByName('ActualYearBuilt').Text;

      If (FieldByName('ConditionCodeMax').Text < CompTable.FieldByName('ConditionCode').Text)
        then FieldByName('ConditionCodeMax').Text := CompTable.FieldByName('ConditionCode').Text;

      If (FieldByName('OverallGradeCodeMax').Text < CompTable.FieldByName('OverallGradeCode').Text)
        then FieldByName('OverallGradeCodeMax').Text := CompTable.FieldByName('OverallGradeCode').Text;

      If (FieldByName('SqFootLivingAreaMax').AsInteger < CompTable.FieldByName('SqFootLivingArea').AsInteger)
        then FieldByName('SqFootLivingAreaMax').AsInteger := CompTable.FieldByName('SqFootLivingArea').AsInteger;

      If (FieldByName('FirstStoryAreaMax').AsInteger < CompTable.FieldByName('FirstStoryArea').AsInteger)
        then FieldByName('FirstStoryAreaMax').AsInteger := CompTable.FieldByName('FirstStoryArea').AsInteger;

      If (FieldByName('NumberOfStoriesMax').AsFloat < CompTable.FieldByName('NumberOfStories').AsFloat)
        then FieldByName('NumberOfStoriesMax').AsFloat := CompTable.FieldByName('NumberOfStories').AsFloat;

      If (FieldByName('NumberOfBedroomsMax').AsInteger < CompTable.FieldByName('NumberOfBedrooms').AsInteger)
        then FieldByName('NumberOfBedroomsMax').AsInteger := CompTable.FieldByName('NumberOfBedrooms').AsInteger;

      If (FieldByName('NumberOfBathroomsMax').AsFloat < CompTable.FieldByName('NumberOfBathrooms').AsFloat)
        then FieldByName('NumberOfBathroomsMax').AsFloat := CompTable.FieldByName('NumberOfBathrooms').AsFloat;

      If (FieldByName('NumberOfFirePlcsMax').AsInteger < CompTable.FieldByName('NumFireplaces').AsInteger)
        then FieldByName('NumberOfFirePlcsMax').AsInteger :=  CompTable.FieldByName('NumFireplaces').AsInteger;

      If (FieldByName('AcreageMax').AsFloat < TempAcres)
        then FieldByName('AcreageMax').AsFloat := TempAcres;

      If (FieldByName('EastCoordMax').AsInteger < CompTable.FieldByName('EastCoord').AsInteger)
        then FieldByName('EastCoordMax').AsInteger := CompTable.FieldByName('EastCoord').AsInteger;

      If (FieldByName('NorthCoordMax').AsInteger < CompTable.FieldByName('NorthCoord').AsInteger)
        then FieldByName('NorthCoordMax').AsInteger := CompTable.FieldByName('NorthCoord').AsInteger;

    end;  {with MinMaxTable do}

end;  {UpdateCommonMinMaxFields}

{==========================================================================================}
Procedure TCreateComparablesFileForm.UpdateAssmtMinMaxRangeFile(CompAssmtMinMaxTable : TTable);

{look for minmax rec for this group and alter values if found, else store new rec}

var
  _Found : Boolean;

begin
  with CompAssmtTable do
    _Found := FindKeyOld(CompAssmtMinMaxTable,
                         ['SwisCode' , 'Neighborhood',
                          'PropertyClass', 'BuildingStyleCode'],
                         [Take(6, FieldByName('SwisCode').Text),
                          Take(5, FieldByName('Neighborhood').Text),
                          Take(3, FieldByName('PropertyClass').Text),
                          Take(2, FieldByName('BuildingStyleCode').Text)]);

  If _Found
    then
      begin
        CompAssmtMinMaxTable.Edit;
        UpdateCommonMinMaxFields(CompAssmtMinMaxTable, CompAssmtTable);

        with CompAssmtMinMaxTable do
          begin
            If (FieldByName('LavMin').AsFloat > AssessmentTable.FieldByName('LandAssessedVal').AsFloat)
              then FieldByName('LavMin').AsFloat := AssessmentTable.FieldByName('LandAssessedVal').AsFloat;

            If (FieldByName('LavMax').AsFloat < AssessmentTable.FieldByName('LandAssessedVal').AsFloat)
              then FieldByName('LavMax').AsFloat := AssessmentTable.FieldByName('LandAssessedVal').AsFloat;

            If (FieldByName('TavMin').AsFloat > AssessmentTable.FieldByName('TotalAssessedVal').AsFloat)
              then FieldByName('TavMin').AsFloat := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;

            If (FieldByName('TavMax').AsFloat < AssessmentTable.FieldByName('TotalAssessedVal').AsFloat)
              then FieldByName('TavMax').AsFloat := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;

          end;  {with CompAssmtMinMaxTable do}

         try
           CompAssmtMinMaxTable.Post;
         except
           SystemSupport(008, CompAssmtMinMaxTable, 'Error updating assmt min\max file.', UnitName, GlblErrorDlgBox);
           (*Abort;*)
         end;

      end
    else
      begin
        CompAssmtMinMaxTable.Insert;

        with CompAssmtMinMaxTable do
          begin
            AssignCommonMinMaxFields(CompAssmtMinMaxTable, CompAssmtTable);

            FieldByName('LavMin').AsFloat := AssessmentTable.FieldByName('LandAssessedVal').AsFloat;
            FieldByName('LavMax').AsFloat := AssessmentTable.FieldByName('LandAssessedVal').AsFloat;
            FieldByName('TavMin').AsFloat := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;
            FieldByName('TavMax').AsFloat := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;

          end;  {with CompAssmtMinMaxTable do}

        try
          CompAssmtMinMaxTable.Post;
        except
          SystemSupport(007, CompAssmtMinMaxTable, 'Error inserting assmt min\max record.', UnitName, GlblErrorDlgBox);
          (*Abort;*)
        end;

    end;  {else of If Found}

end;  {UpdateAssmtMinMaxRangeFile}

{==========================================================================}
Function GetTimeAdjustedSalesPrice(SalesPrice : Comp;
                                   SalesDate : TDateTime) : Comp;

begin
  Result := SalesPrice;
end;

{=======================================================================}
Procedure TCreateComparablesFileForm.UpdateSalesMinMaxRangeFile(CompSalesMinMaxFile : TTable);

{look for minmax rec for this group and alter values if found, else store new rec}

var
  _Found : Boolean;
  TimeAdjustedSalesPrice : Comp;

begin
  with CompSalesTable do
    _Found := FindKeyOld(CompSalesMinMaxTable,
                         ['SwisCode' , 'Neighborhood',
                          'PropertyClass', 'BuildingStyleCode'],
                         [Take(6, FieldByName('SwisCode').Text),
                          Take(5, FieldByName('Neighborhood').Text),
                          Take(3, FieldByName('PropertyClass').Text),
                          Take(2, FieldByName('BuildingStyleCode').Text)]);


  If _Found
    then
      begin
        with CompSalesMinMaxTable do
          begin
            Edit;
            UpdateCommonMinMaxFields(CompSalesMinMaxTable, CompSalesTable);

            If (FieldByName('SalesPriceMin').AsFloat > SalesTable.FieldByName('SalePrice').AsFloat)
              then FieldByName('SalesPriceMin').AsFloat := SalesTable.FieldByName('SalePrice').AsFloat;

            If (FieldByName('SalesPriceMax').AsFloat < SalesTable.FieldByName('SalePrice').AsFloat)
              then FieldByName('SalesPriceMax').AsFloat := SalesTable.FieldByName('SalePrice').AsFloat;

            TimeAdjustedSalesPrice := GetTimeAdjustedSalesPrice(SalesTable.FieldByName('SalePrice').AsFloat,
                                                                SalesTable.FieldByName('SaleDate').AsFloat);

            If (FieldByName('TaspMin').AsFloat > TimeAdjustedSalesPrice)
               then FieldByName('TaspMin').AsFloat := TimeAdjustedSalesPrice;

            If (FieldByName('TaspMax').AsFloat < TimeAdjustedSalesPrice)
              then FieldByName('TaspMax').AsFloat := TimeAdjustedSalesPrice;

            try
              Post;
            except
              SystemSupport(008, CompSalesMinMaxTable, 'Error updating sales min/max record.', UnitName, GlblErrorDlgBox);
              (*Abort;*)
            end;

          end;  {with CompSalesMinMaxTable do}

      end
    else
      begin
        CompSalesMinMaxTable.Insert;

        with CompSalesMinMaxTable do
          begin
            AssignCommonMinMaxFields(CompSalesMinMaxTable, CompSalesTable);

            FieldByName('SalesPriceMin').AsFloat := SalesTable.FieldByName('SalePrice').AsFloat;
            FieldByName('SalesPriceMax').AsFloat := SalesTable.FieldByName('SalePrice').AsFloat;
            FieldByName('TaspMin').AsFloat := GetTimeAdjustedSalesPrice(SalesTable.FieldByName('SalePrice').AsFloat,
                                                                        SalesTable.FieldByName('SaleDate').AsFloat);
            FieldByName('TaspMax').AsFloat := GetTimeAdjustedSalesPrice(SalesTable.FieldByName('SalePrice').AsFloat,
                                                                        SalesTable.FieldByName('SaleDate').AsFloat);

          end;  {with CompSalesMinMaxTable do}

        try
          CompSalesMinMaxTable.Post;
        except
          SystemSupport(007, CompSalesMinMaxTable, 'Error inserting sales min/max record.', UnitName, GlblErrorDlgBox);
          (*Abort;*)
        end;

    end;  {else of If Found}

end;  {UpdateSalesMinMaxRangeFile}

{======================================================================}
Procedure TCreateComparablesFileForm.GetImprovements(CompTable,
                                                     ResidentialImprovementTable : TTable;
                                                     SwisSBLKey : String;
                                                     SiteNumber : Integer;
                                                     SalesComps : Boolean);

var
  FirstTimeThrough, Done : Boolean;
  ImpCount : Integer;

begin
  Done := False;
  FirstTimeThrough := True;

  with CompTable do
    begin
      ImpCount := 1;

        {FXX10301998-1: Need to include tax roll year as first part of key.}
        {FXX02042004-2(2.07l): Use the assessment year that they selected in
                               the Choose Assessment Year radio box to look up in
                               the residential improvement file.}

      If SalesComps
        then FindNearestOld(ResidentialImprovementTable,
                            ['SwisSBLKey', 'SalesNumber', 'Site', 'ImprovementNumber'],
                            [SwisSBLKey, '1', '0', '0'])
        else FindNearestOld(ResidentialImprovementTable,
                            ['TaxRollYr', 'SwisSBLKey', 'Site', 'ImprovementNumber'],
                            [TaxRollYear, SwisSBLKey, '1', '0']);

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else ResidentialImprovementTable.Next;

        If ((ResidentialImprovementTable.FieldByName('SwisSBLKey').Text <> SwisSBLKey) or
            ResidentialImprovementTable.EOF or
            (ImpCount > 3))  {No more than 3 improvements shown.}
          then Done := True;

        If ((ResidentialImprovementTable.FieldByName('Site').AsInteger = SiteNumber) and
            (not Done))
          then
            begin
              case ImpCount of
                1 : begin
                      FieldByName('Imp1StructureCode').Text := ResidentialImprovementTable.FieldByName('StructureCode').Text;
                      FieldByName('Imp1YearBuilt').Text := ResidentialImprovementTable.FieldByName('YearBuilt').Text;
                      FieldByName('Imp1ConditionCode').Text := ResidentialImprovementTable.FieldByName('ConditionCode').Text;
                    end;

                2 : begin
                      FieldByName('Imp2StructureCode').Text := ResidentialImprovementTable.FieldByName('StructureCode').Text;
                      FieldByName('Imp2YearBuilt').Text := ResidentialImprovementTable.FieldByName('YearBuilt').Text;
                      FieldByName('Imp2ConditionCode').Text := ResidentialImprovementTable.FieldByName('ConditionCode').Text;
                    end;

                3 : begin
                      FieldByName('Imp3StructureCode').Text := ResidentialImprovementTable.FieldByName('StructureCode').Text;
                      FieldByName('Imp3YearBuilt').Text := ResidentialImprovementTable.FieldByName('YearBuilt').Text;
                      FieldByName('Imp3ConditionCode').Text := ResidentialImprovementTable.FieldByName('ConditionCode').Text;
                    end;

              end;  {case ImpCount of}

              ImpCount := ImpCount + 1;

            end;  {If not Done}

      until Done;

    end;  {with CompTable do}

end;  {GetImprovements}

{=========================================================================}
Procedure TCreateComparablesFileForm.ProcessCommonCompFields(CompTable,
                                                             MainTable,
                                                             ResSiteTable,
                                                             ResBldgTable : TTable;
                                                             SwisSBLKey : String;
                                                             SalesComps : Boolean);

begin
 with CompTable do
   begin
     FieldByName('SwisCode').Text := Take(6, SwisSBLKey);

     FieldByName('SBLKey').Text := Copy(SwisSBLKey, 7, 20);

     FieldByName('Site').AsInteger := ResSiteTable.FieldByName('Site').AsInteger;

     If SalesComps
       then FieldByName('PropertyClass').Text := SalesTable.FieldByName('PropClass').Text
       else FieldByName('PropertyClass').Text := ParcelTable.FieldByName('PropertyClassCode').Text;
     FieldByName('Neighborhood').Text := ResSiteTable.FieldByName('NeighborHoodCode').Text;
     FieldByName('BuildingStyleCode').Text := ResBldgTable.FieldByName('BuildingStyleCode').Text;
     FieldByName('ActualYearBuilt').Text := ResBldgTable.FieldByName('ActualYearBuilt').Text;
     FieldByName('ZoningCode').Text := ResSiteTable.FieldByName('ZoningCode').Text;
     FieldByName('SewerTypeCode').Text := ResSiteTable.FieldByName('SewerTypeCode').Text;
     FieldByName('WaterSupplyCode').Text := ResSiteTable.FieldByName('WaterSupplyCode').Text;
     FieldByName('ConditionCode').Text := ResBldgTable.FieldByName('ConditionCode').Text;
     FieldByName('OverallGradeCode').Text := ResBldgTable.FieldByName('OverallGradeCode').Text;
     FieldByName('SqFootLivingArea').AsInteger := ResBldgTable.FieldByName('SqFootLivingArea').AsInteger;
     FieldByName('FirstStoryArea').AsInteger := ResBldgTable.FieldByName('FirstStoryArea').AsInteger;
     FieldByName('NumberOfStories').AsFloat := ResBldgTable.FieldByName('NumberOfStories').AsFloat;
     FieldByName('NumberOfBedrooms').AsInteger := ResBldgTable.FieldByName('NumberOfBedrooms').AsInteger;
     FieldByName('NumberOfBathrooms').AsFloat := ResBldgTable.FieldByName('NumberOfBathrooms').AsFloat;
     FieldByName('NumFireplaces').AsInteger := ResBldgTable.FieldByName('NumberOfFirePlaces').AsInteger;
     FieldByName('NumberOfBedrooms').AsInteger := ResBldgTable.FieldByName('NumberOfBedrooms').AsInteger;
     FieldByName('BasementCode').Text := ResBldgTable.FieldByName('BasementTypeCode').Text;
     FieldByName('Acreage').AsFloat := MainTable.FieldByName('Acreage').AsFloat;
     FieldByName('Frontage').AsFloat := MainTable.FieldByName('Frontage').AsFloat;
     FieldByName('Depth').AsFloat := MainTable.FieldByName('Depth').AsFloat;

       {FXX01051999-2: A basement garage counts as an attached garage.}

     FieldByName('AttachedGarCapacity').AsInteger := ResBldgTable.FieldByName('AttachedGarCapacity').AsInteger +
                                                     ResBldgTable.FieldByName('BasementGarCapacity').AsInteger;

     If SalesComps
       then
         begin
           FieldByName('EastCoord').AsInteger := MainTable.FieldByName('EastCoord').AsInteger;
           FieldByName('NorthCoord').AsInteger := MainTable.FieldByName('NorthCoord').AsInteger;
         end
       else
         begin
           FieldByName('EastCoord').AsInteger := MainTable.FieldByName('GridCordEast').AsInteger;
           FieldByName('NorthCoord').AsInteger := MainTable.FieldByName('GridCordNorth').AsInteger;
         end;

     FieldByName('FinishedBasementArea').AsInteger := ResBldgTable.FieldByName('FinishedBasementArea').AsInteger;
     FieldByName('FinishedAtticArea').AsInteger := ResBldgTable.FieldByName('FinishedAtticArea').AsInteger;
     FieldByName('CentralAir').AsBoolean := ResBldgTable.FieldByName('CentralAir').AsBoolean;

    end;  {with CompTable do}

end;  {ProcessCommonCompFields}

{=================================================================================================}
Procedure TCreateComparablesFileForm.StoreAssessmentComprables;

{read through all the parcels in the next year file; for each active parcel}
{store one record for each residential site containing the key data upon which}
{comparables are built.  Key data comes from the parcel, assessment,res. site, and}
{residential bldg files}

var
  _Found, DoneSites, DoneParcels, FirstTimeThrough : Boolean;
  SwisSBLKey : String;

begin
  DoneParcels := False;
  FirstTimeThrough := True;

  ProgressDialog.Start(GetRecordCount(ParcelTable) + GetRecordCount(SalesTable), True, True);
  ProgressDialog.UserLabelCaption := 'Saving Comp Data';

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    If ParcelTable.EOF
      then DoneParcels := True;

    If not DoneParcels
      then
        begin
            {get the records necessary to store a summary record, including first site record}

          _Found := GetCompRecords;

          SwisSBLKey := AssessmentTable.FieldByName('SwisSBLKey').Text;
          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          DoneSites := False;  {loop thru all sites for this parcel}

          repeat    {repeat until donesites for this parcel}
            Application.ProcessMessages;

            If _Found
              then
                begin
                  CompAssmtTable.Insert;

                  ProcessCommonCompFields(CompAssmtTable, ParcelTable,
                                          ResidentialSiteTable,
                                          ResidentialBldgTable,
                                          SwisSBLKey, False);

                  GetImprovements(CompAssmtTable, ResidentialImprovementTable,
                                  SwisSBLKey,
                                  ResidentialSiteTable.FieldByName('Site').AsInteger,
                                  False);

                     {update the minmax record for this group}

                  UpdateAssmtMinMaxRangeFile(CompAssmtMinMaxTable);

                  try
                    CompAssmtTable.Post
                  except
                    SystemSupport(010, CompAssmtTable, 'Error Saving Comp Assessment Rec',
                                  UnitName, GlblErrorDlgBox);
                    (*Abort;*)
                  end;

                end {end Found}
              else DoneSites := True;  {if no recs or end of site recs, done this parcel}

              {check for another site and if exists store it in comp record file}

            If not DoneSites
              then
                begin
                  ResidentialSiteTable.Next;

                   {stop if EOF or sbl of site does not match parcel we are looking at}

                  If (not ResidentialSiteTAble.EOF and
                      (Take(26, ResidentialSiteTable.FieldByName('SwisSBLKey').Text) =
                       Take(26, SwisSBLKey)))
                    then
                      begin
                        with ResidentialSiteTable do
                          _Found := FindKeyOld(ResidentialBldgTable,
                                               ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                               [TaxRollYear, SwisSBLKey,
                                                FieldByName('Site').Text]);

                        If not _Found
                          then DoneSites := True;  {must have site & bldg rec to create comp rec}
                      end
                    else DoneSites := True;

                end;  {If not DoneSites}

          until DoneSites;  {done sites for this parcel}

        end;  {If not DoneParcels}

  until DoneParcels;

end;  {StoreAssessmentComprables}

{=================================================================================================}
Procedure TCreateComparablesFileForm.StoreSalesComprables;

{read through all the parcels in the sales file; for each active parcel}
{store one record for each residential site containing the key data upon which}
{comparables are built.  Key data comes from the parcel, assessment,res. site, and}
{residential bldg files}

var
  _Found, FoundSale, UseSalesInventory,
  DoneSites, DoneParcels, FirstTimeThrough : Boolean;
  SwisSBLKey : String;

begin
  DoneParcels := False;
  FirstTimeThrough := True;

  ProgressDialog.UserLabelCaption := 'Saving Sales Comp Data';

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SalesTable.Next;

    If SalesTable.EOF
      then DoneParcels := True;

    If not DoneParcels
      then
        begin
          Application.ProcessMessages;

            {get the records necessary to store a summary record, including first site record}

          SwisSBLKey := SalesTable.FieldByName('SwisSBLKey').Text;
          _Found := GetCompSalesRecords(UseSalesInventory);

          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          DoneSites := False;  {loop thru all sites for this parcel}

          repeat    {repeat until donesites for this parcel}
            Application.ProcessMessages;

              {FXX06071999-1: Only include arms length sales in comps, since others
                              don't matter.}

            If _Found
              then
                If SalesTable.FieldByName('ArmsLength').AsBoolean
                  then
                    begin
                        {FXX11031998-1: Since there may be more than one sale,
                                        we want only the most recent and
                                        we will delete any existing ones for this
                                        parcel.}

                      FindNearestOld(CompSalesTable,
                                     ['SwisCode', 'SBLKey', 'Site'],
                                     [Take(6, SwisSBLKey),
                                      Copy(SwisSBLKey, 7, 20),
                                      '0']);

                      FoundSale := ((CompSalesTable.FieldByName('SwisCode').Text = Take(6, SwisSBLKey)) and
                                    (CompSalesTable.FieldByName('SBLKey').Text = Copy(SwisSBLKey, 7, 20)));

                        {FXX01071999-1: So that the group parcel count does not
                                        get messed up, reduce the parcel count by one when delete.}

                      If FoundSale
                        then
                          begin
                            with CompSalesTable do
                              _Found := FindKeyOld(CompSalesMinMaxTable,
                                                   ['SwisCode', 'Neighborhood',
                                                    'PropertyClass', 'BuildingStyleCode'],
                                                   [Take(6, FieldByName('SwisCode').Text),
                                                    Take(5, FieldByName('Neighborhood').Text),
                                                    Take(3, FieldByName('PropertyClass').Text),
                                                    Take(2, FieldByName('BuildingStyleCode').Text)]);


                            If _Found
                              then
                                with CompSalesMinMaxTable do
                                  try
                                    Edit;
                                    FieldByName('GroupParcelCount').AsInteger :=
                                                FieldByName('GroupParcelCount').AsInteger - 1;
                                    Post;
                                  except
                                    SystemSupport(053, CompSalesMinMaxTable, 'Error Updating Sales Min\Max Table.',
                                                  UnitName, GlblErrorDlgBox);
                                    (*Abort;*)

                                  end;

                            CompSalesTable.Delete;

                          end;  {If FoundSale}

                      CompSalesTable.Insert;

                        {CHG10292001-1: Allow them to associate current inventory with a sale
                                        if no sales data is available.}

                      If UseSalesInventory
                        then ProcessCommonCompFields(CompSalesTable, SalesTable,
                                                     SalesResidentialSiteTable,
                                                     SalesResidentialBldgTable,
                                                     SwisSBLKey, True)
                        else ProcessCommonCompFields(CompSalesTable, SalesTable,
                                                     ResidentialSiteTable,
                                                     ResidentialBldgTable,
                                                     SwisSBLKey, True);

                      If UseSalesInventory
                        then GetImprovements(CompSalesTable, SalesResidentialImprovementTable,
                                             SwisSBLKey,
                                             SalesResidentialSiteTable.FieldByName('Site').AsInteger,
                                             True)
                        else GetImprovements(CompSalesTable, ResidentialImprovementTable,
                                             SwisSBLKey,
                                             ResidentialSiteTable.FieldByName('Site').AsInteger,
                                             False);

                        {If we are getting the inventory from the base parcel,
                         don't try to go on to the next site.}

                      If not UseSalesInventory
                        then DoneSites := True;

                         {update the minmax record for this group}

                      UpdateSalesMinMaxRangeFile(CompSalesMinMaxTable);

                      with CompSalesTable do
                        begin
                          FieldByName('UnadjustedSalesPrice').AsFloat := SalesTable.FieldByName('SalePrice').AsFloat;
                          FieldByName('SaleDate').AsDateTime := SalesTable.FieldByName('SaleDate').AsDateTime;

                          with SalesTable do
                            CompSalesTable.FieldByName('TimeAdjSalesPrice').AsFloat :=
                                 GetTimeAdjustedSalesPrice(FieldByName('SalePrice').AsFloat,
                                                           FieldByName('SaleDate').AsDateTime);
                        end;  {with CompSalesTable do}

                      try
                        CompSalesTable.Post;
                      except
                        SystemSupport(010, CompSalesTable, 'Error Saving Comp Sales Rec',
                                      UnitName, GlblErrorDlgBox);
                        (*Abort;*)
                      end;

                    end {end Found}
                  else DoneSites := True;  {if no recs or end of site recs, done this parcel}

              {check for another site and if exists store it in comp record file}

            If not DoneSites
              then
                begin
                  SalesResidentialSiteTable.Next;

                   {stop if EOF or sbl of site does not match parcel we are looking at}

                  If (not SalesResidentialSiteTable.EOF and
                      (Take(26, SalesResidentialSiteTable.FieldByName('SwisSBLKey').Text) =
                       Take(26, SwisSBLKey)))
                    then
                      begin
                        with SalesResidentialSiteTable do
                          _Found := FindKeyOld(SalesResidentialBldgTable,
                                               ['SwisSBLKey', 'SalesNumber', 'Site'],
                                               [SwisSBLKey,
                                                SalesTable.FieldByName('SaleNumber').Text,
                                                FieldByName('Site').Text]);

                        If not _Found
                          then DoneSites := True;  {must have site & bldg rec to create comp rec}
                      end
                    else DoneSites := True;

                end;  {If not DoneSites}

          until DoneSites;  {done sites for this parcel}

        end;  {If not DoneParcels}

  until DoneParcels;

end;  {StoreSalesComprables}

{=========================================================================}
Procedure TCreateComparablesFileForm.StartButtonClick(Sender: TObject);

{This logic puts 1 record in the comp file for each parcel SITE in the master file}
{that has a parcel rec, assessment rec, plus site and bldg rec.  Per conversation }
{with TOm in Ramapo assessor office we agreed that multiple site parcels would be }
{handled as follows:  the comp record will get the property class of the parent parcel}
{ (vs. the property class stored in each site record) and each site comp record will also}
{carry the TAV of the parent parcel.  ForT example if a parcel has 2 res sites coded}
{210, and the TAV of the parcel is 200,000 but the parent parcel (eg property record) }
{ is 280, two comp records will be produced, each with a prop class of 280 and each }
{with a TAV of 200,000 (the TAV is acually obtained from the assessment record) .}
{This will give the assessor properties in the correct property class category ,  }
{with a slightly inflagted assmt/sqft number since the parcel's TAV is counted 2x }
{rather than being split somehow between the 2 sites.                             }
{Also note that the acreage,frontage and depth in the comp record will be from the }
{parent parcel since these are not stored at the site level, so setting ranges for}
{selection might be affected slightly. Also grid cord east and north would be  }
{the same for the two comp site records, as they come from the parcel record.....}
{not stored at the res site record}

var
  ProcessingType : Integer;
  Quit : Boolean;
  StatusMsg : String;

begin
  Quit := False;
  InstructionLabel.Visible := False;
  InstructionLabel.Repaint;
  bFillInBlankInformationFromCurrentData := cbxFillInBlankInformationFromCurrentData.Checked;

  TableDeleteStatusMsgLabel.Visible := True;
  TableDeleteStatusMsgLabel.Repaint;
  ProcessingType := GlblProcessingType;

  case AssessmentYearRadioGroup.ItemIndex of
    0 : begin
          TaxRollYear := GlblThisYear;
          ProcessingType := ThisYear;
        end;
    1 : begin
          TaxRollYear := GlblNextYear;
          ProcessingType := NextYear;
        end;

  end;  {case AssessmentYearRadioGroup of}

    {CHG10292001-1: Allow them to associate current inventory with a sale
                    if no sales data is available.}

  try
    ForceSalesComparablesAfterDate := StrToDate(SalesDateEdit.Text);
  except
    ForceSalesComparablesAfterDate := 0;
  end;

  OpenTablesForForm(Self, ProcessingType);

  OpenTableForProcessingType(SalesResidentialSiteTable, ResidentialSiteTableName,
                             SalesInventory, Quit);
  OpenTableForProcessingType(SalesResidentialBldgTable, ResidentialBldgTableName,
                             SalesInventory, Quit);
  OpenTableForProcessingType(SalesResidentialImprovementTable, ResidentialImprovementsTableName,
                             SalesInventory, Quit);

   {empty out the comp data and min/max tables}
   {FXX12122001-1: Be sure to pack the tables after emptying them.}

(*  try *)
(*    If (GetRecordCount(CompAssmtMinMaxTable) > 0)
      then
        begin
          CompAssmtMinMaxTable.EmptyTable;
          PackTable(CompAssmtMinMaxTable, StatusMsg);
        end;

    If (GetRecordCount(CompSalesMinMaxTable) > 0)
      then
        begin
          CompSalesMinMaxTable.EmptyTable;
          PackTable(CompSalesMinMaxTable, StatusMsg);
        end;

    If (GetRecordCount(CompAssmtTable) > 0)
      then
        begin
          CompAssmtTable.EmptyTable;
          PackTable(CompAssmtTable, StatusMsg);
        end;

    If (GetRecordCount(CompSalesTable) > 0)
      then
        begin
          CompSalesTable.EmptyTable;
          PackTable(CompSalesTable, StatusMsg);
        end; *)

    TableDeleteStatusMsgLabel.Visible := False;
    TableDeleteStatusMsgLabel.Repaint;

    StoreAssessmentComprables;

    StoreSalesComprables;

    InstructionLabel.Visible := True;
    ProgressDialog.Finish;

    MessageDlg('The comparables files have been created.', mtInformation, [mbOK], 0);
(*  except
    MessageDlg('The comparables files could not be created because' + #13 +
               'someone is currently doing comparables lookups.' + #13 +
               'Please have them exit and try again.',
               mtError, [mbOK], 0);
  end; *)

end;  {StartButtonClick}

{=============================================================================================}
Procedure TCreateComparablesFileForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TCreateComparablesFileForm.FormClose(    Sender: TObject;
                                               var Action: TCloseAction);

begin
 CloseTablesForForm(Self);
    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.