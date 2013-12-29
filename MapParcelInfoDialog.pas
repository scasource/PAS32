unit MapParcelInfoDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBTables, Db, TMultiP, ExtCtrls, Buttons, ComCtrls, DBCtrls,
  DataModule, Tabs;

type
  TMapParcelInfoForm = class(TForm)
    PictureTable: TTable;
    InformationPageControl: TPageControl;
    DemographicsTabSheet: TTabSheet;
    NameAddrLabel1: TLabel;
    NameAddrLabel2: TLabel;
    NameAddrLabel3: TLabel;
    NameAddrLabel4: TLabel;
    NameAddrLabel5: TLabel;
    NameAddrLabel6: TLabel;
    DimensionsLabel: TLabel;
    AssessmentLabel: TLabel;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ExemptionTabSheet: TTabSheet;
    PropertyClass_SchoolLabel: TLabel;
    LegalAddressLabel: TLabel;
    ImageTabSet: TTabSet;
    SDTabSheet: TTabSheet;
    Query: TQuery;
    ExemptionsListView: TListView;
    SpecialDistrictListView: TListView;
    InventoryPageControl: TPageControl;
    BuildingTabSheet: TTabSheet;
    ImprovementTabSheet: TTabSheet;
    LandTabSheet: TTabSheet;
    BuildingStyleLabel: TLabel;
    BuildingConditionLabel: TLabel;
    BuildingGradeLabel: TLabel;
    BuildingYearLabel: TLabel;
    Building1stFloorLabel: TLabel;
    BuildingRoomsLabel: TLabel;
    BuildingBedroomsLabel: TLabel;
    BuildingFireplacesLabel: TLabel;
    BuildingAreaLabel: TLabel;
    ImprovementsListView: TListView;
    Panel1: TPanel;
    ParcelPicture: TPMultiImage;
    NbhdLabel: TLabel;
    UtilityLabel: TLabel;
    SewerWaterLabel: TLabel;
    ZoningLabel: TLabel;
    LandListView: TListView;
    BuildingBathroomsLabel: TLabel;
    SalesTreeView: TTreeView;
    procedure PushpinImageClick(Sender: TObject);
    procedure ParcelPictureClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImageTabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    ResidentialSiteTable,
    CommercialSiteTable,
    ImprovementTable, LandTable,
    AssessmentTable, SalesTable,
    SpecialDistrictTable, ExemptionTable : TTable;
    SwisSBLKey : String;

    Procedure FillInParcelInformation(ParcelTable : TTable;
                                      ProcessingType : Integer);
    Procedure FillInSalesInformation;
    Procedure FillInExemptionInformation(ProcessingType : Integer);
    Procedure FillInSpecialDistrictInformation(ProcessingType : Integer);

    Procedure FillInResidentialBuildingInformation(Site : String);
    Procedure FillInImprovementInformation(ProcessingType : Integer);
    Procedure FillInLandInformation(ProcessingType : Integer);

    Procedure FillInInventoryInformation(ProcessingType : Integer);
  end;

implementation

{$R *.DFM}

uses PASUtils, Utilitys, GlblCnst, WinUtils, GlblVars, PASTypes,
     DataAccessUnit;

const
  BuildingPage = 'Building';
  ImprovementPage = 'Improvement';
  LandPage = 'Land';

  InfoDialogHeightNoPictures = 210;

{======================================================}
Procedure TMapParcelInfoForm.FillInSalesInformation;

var
  Done, FirstTimeThrough : Boolean;

begin
  FirstTimeThrough := True;

  _Query(Query,
         ['Select * from ' + SalesTableName,
          'Where SwisSBLKey = ' + FormatSQLString(SwisSBLKey),
          'Order By SaleNumber']);

  Query.First;
  SalesTreeView.Items.Clear;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Query.Next;

    Done := Query.EOF;

    If not Done
      then
        with Query do
          AddOneTreeViewItem(SalesTreeView,
                             'Sale # ' + FieldByName('SaleNumber').Text +
                             '  Sale Date: ' + FieldByName('SaleDate').Text,
                             ['New: ' + Copy(FieldByName('NewOwnerName').Text, 1, 20),
                              'Old: ' + Copy(FieldByName('OldOwnerName').Text, 1, 20),
                              'Price : ' + FormatFloat(CurrencyNormalDisplay,
                                                       FieldByName('SalePrice').AsFloat) +
                                '  Type: ' + FieldByName('SaleTypeCode').Text,
                              'Valid: ' + BoolToStr(FieldByName('ValidSale').AsBoolean) +
                                '  Arms Ln: ' + BoolToStr(FieldByName('ArmsLength').AsBoolean),
                              'Deed Bk\Pg: ' + FieldByName('DeedBook').Text + '\' +
                                               FieldByName('DeedPage').Text,
                              'Deed Date: ' + FieldByName('DeedDate').Text]);

  until Done;

end;  {FillInSalesInformation}

{======================================================}
Procedure TMapParcelInfoForm.FillInExemptionInformation(ProcessingType : Integer);

begin
  _Query(Query,
         ['Select * from ' +
          DetermineTableNameForProcessingType(ExemptionsTableName, ProcessingType),
          'where SwisSBLKey = ' + FormatSQLString(SwisSBLKey)]);

  FillInListView(ExemptionsListView, Query,
                 ['ExemptionCode', 'Percent', 'CountyAmount',
                  'TownAmount', 'SchoolAmount'],
                 ['', NoDecimalDisplay, CurrencyDisplayNoDollarSign,
                  CurrencyDisplayNoDollarSign, CurrencyDisplayNoDollarSign],
                 False, False);

end;  {FillInExemptionInformation}

{======================================================}
Procedure TMapParcelInfoForm.FillInSpecialDistrictInformation(ProcessingType : Integer);

begin
  _Query(Query,
         ['Select * from ' +
          DetermineTableNameForProcessingType(SpecialDistrictTableName, ProcessingType),
          'where SwisSBLKey = ' + FormatSQLString(SwisSBLKey)]);

  FillInListView(SpecialDistrictListView, Query,
                 ['SDistCode', 'PrimaryUnits', 'SecondaryUnits',
                  'SDPercentage', 'CalcAmount'],
                 ['', DecimalEditDisplay, DecimalEditDisplay,
                  NoDecimalDisplay, CurrencyDisplayNoDollarSign],
                 False, False);

end;  {FillInSpecialDistrictInformation}

{======================================================}
Procedure TMapParcelInfoForm.FillInResidentialBuildingInformation(Site : String);

var
  ResidentialBuildingTable : TTable;

begin
  ResidentialBuildingTable := FindTableInDataModuleForProcessingType(DataModuleResidentialBuildingTableName,
                                                                 NextYear);

  SetRangeOld(ResidentialBuildingTable, ['TaxRollYr', 'SwisSBLKey', 'Site'],
              [GlblNextYear, SwisSBLKey, Site], [GlblNextYear, SwisSBLKey, Site]);

  ResidentialBuildingTable.First;

  with ResidentialBuildingTable do
    begin
      BuildingStyleLabel.Caption := 'Style: ' + FieldByName('BuildingStyleDesc').Text;
      BuildingConditionLabel.Caption := 'Cond:  ' + FieldByName('ConditionCode').Text;
      BuildingGradeLabel.Caption := 'Grade: ' + FieldByName('OverallGradeCode').Text;
      BuildingYearLabel.Caption := 'Year:  ' + FieldByName('ActualYearBuilt').Text;
      Building1stFloorLabel.Caption := '1st Sty:   ' + FieldByName('FirstStoryArea').Text;
      BuildingRoomsLabel.Caption := 'Rooms:   ' + FieldByName('NumberOfRooms').Text;
      BuildingBedroomsLabel.Caption := 'Bedrms: ' + FieldByName('NumberOfBedrooms').Text;
      BuildingBathroomsLabel.Caption := 'Baths: ' + FieldByName('NumberOfBathrooms').Text;
      BuildingFireplacesLabel.Caption := 'Firepl:  ' + FieldByName('NumberOfFireplaces').Text;
      BuildingAreaLabel.Caption := 'SFLA:  ' + FieldByName('SqFootLivingArea').Text;

    end;  {with ResidentialBuildingTable do}

end;  {FillInResidentialBuildingInformation}

{======================================================}
Procedure TMapParcelInfoForm.FillInImprovementInformation(ProcessingType : Integer);

begin
  _Query(Query,
         ['Select StructureDesc, Quantity, YearBuilt, Dimension1',
          (* LTrim(Str(Dimension1, 6, 2)) + ' + FormatSQLString('x') + ' + LTrim(Str(Dimension2, 6, 2)) as Dimension', *)
          'from ' + DetermineTableNameForProcessingType(ResidentialImprovementsTableName, ProcessingType),
          'where SwisSBLKey = ' + FormatSQLString(SwisSBLKey)]);

  FillInListView(ImprovementsListView, Query,
                 ['StructureDesc', 'Quantity', 'Dimension1', 'YearBuilt'],
                 False, False);

end;  {FillInImprovementInformation}

{======================================================}
Procedure TMapParcelInfoForm.FillInLandInformation(ProcessingType : Integer);

begin
  _Query(Query,
         ['Select LandTypeDesc, Acreage, LandValue, UnitPrice',
          'from ' + DetermineTableNameForProcessingType(ResidentialLandTableName, ProcessingType),
          'where SwisSBLKey = ' + FormatSQLString(SwisSBLKey)]);

  FillInListView(LandListView, Query,
                 ['LandTypeDesc', 'Acreage', 'LandValue',
                  'UnitPrice'],
                 ['', _3DecimalEditDisplay, CurrencyDisplayNoDollarSign,
                  DecimalEditDisplay],
                 False, False);

end;  {FillInLandInformation}

{======================================================}
Procedure TMapParcelInfoForm.FillInInventoryInformation(ProcessingType : Integer);

begin
  with ResidentialSiteTable do
    begin
      NbhdLabel.Caption := 'Nbhd: ' + FieldByName('NeighborhoodCode').Text;
      UtilityLabel.Caption := 'Util: ' + Take(10, FieldByName('UtilityTypeDesc').Text);
      ZoningLabel.Caption := 'Zone: ' + FieldByName('ZoningCode').Text;
      SewerWaterLabel.Caption := 'Swr\Wtr: ' + Trim(FieldByName('SewerTypeDesc').Text) + '\' +
                                 FieldByName('WaterSupplyDesc').Text;

    end;  {with ResidentialSiteTable do}

  FillInResidentialBuildingInformation(ResidentialSiteTable.FieldByName('Site').Text);
  FillInImprovementInformation(ProcessingType);
  FillInLandInformation(ProcessingType);

end;  {FillInInventoryInformation}

{======================================================}
Procedure TMapParcelInfoForm.FillInParcelInformation(ParcelTable : TTable;
                                                     ProcessingType : Integer);

var
  TempLabel : TLabel;
  TempStr, AssessmentYear, TempLabelName : String;
  I, RecsInRange : Integer;
  NAddrArray : NameAddrArray;
  CommercialSiteFound, ResidentialSiteFound,
  InventoryVisible : Boolean;

begin
  SwisSBLKey := ExtractSSKey(ParcelTable);
  AssessmentYear := GetTaxRollYearForProcessingType(ProcessingType);

  PictureTable.Open;

  with ParcelTable do
    begin
      Caption := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

      GetNameAddress(ParcelTable, NAddrArray);

      For I := 1 to 6 do
        begin
          TempLabelName := 'NameAddrLabel' + IntToStr(I);
          TempLabel := TLabel(Self.FindComponent(TempLabelName));
          TempLabel.Caption := NAddrArray[I];

        end;  {For I := 1 to 6 do}

      LegalAddressLabel.Caption := 'Legal Addr: ' +
                                   GetLegalAddressFromTable(ParcelTable);

      If (Roundoff(FieldByName('Acreage').AsFloat, 2) > 0)
        then DimensionsLabel.Caption := 'Acres: ' +
                                        FormatFloat(DecimalDisplay,
                                                    FieldByName('Acreage').AsFloat)
        else DimensionsLabel.Caption := 'Front: ' +
                                        FormatFloat(DecimalDisplay,
                                                    FieldByName('Frontage').AsFloat) +
                                       '  Depth: ' +
                                        FormatFloat(DecimalDisplay,
                                                    FieldByName('Depth').AsFloat);

      If (Deblank(FieldByName('AccountNo').Text) <> '')
        then DimensionsLabel.Caption := DimensionsLabel.Caption +
                                        '   Acct: ' +
                                        FieldByName('AccountNo').Text;

    end;  {with ParcelTable do}

    {FXX05202004-2(2.08): Don't always get the NY AssessmentTable - have to look at ProcessingType.}

  AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                            ProcessingType);

  FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
             [AssessmentYear, SwisSBLKey]);

  AssessmentLabel.Caption := 'Land: ' +
                              FormatFloat(CurrencyNormalDisplay,
                                          AssessmentTable.FieldByName('LandAssessedVal').AsFloat) +
                             '  Tot: ' +
                              FormatFloat(CurrencyNormalDisplay,
                                          AssessmentTable.FieldByName('TotalAssessedVal').AsFloat);

    {CHG05202004-1(2.08): Add the zoning code if available.}
    {CHG05282004-1(2.08): Use the commercial zoning code if there is a commercial site.}

  ResidentialSiteTable := FindTableInDataModuleForProcessingType(DataModuleResidentialSiteTableName,
                                                                 NextYear);

  SetRangeOld(ResidentialSiteTable, ['TaxRollYr', 'SwisSBLKey'],
              [GlblNextYear, SwisSBLKey], [GlblNextYear, SwisSBLKey]);

  CommercialSiteFound := False;
  ResidentialSiteFound := (not ResidentialSiteTable.EOF);

  If not ResidentialSiteFound
    then
      begin
        CommercialSiteTable := FindTableInDataModuleForProcessingType(DataModuleCommercialSiteTableName,
                                                                       NextYear);

        SetRangeOld(CommercialSiteTable, ['TaxRollYr', 'SwisSBLKey'],
                    [GlblNextYear, SwisSBLKey], [GlblNextYear, SwisSBLKey]);

        CommercialSiteFound := (not CommercialSiteTable.EOF);

      end;  {If not ResidentialSiteFound}

  with ParcelTable do
    begin
      TempStr := 'Cls: ' + FieldByName('PropertyClassCode').Text +
                 FieldByName('OwnershipCode').Text;

      If not (ResidentialSiteFound or CommercialSiteFound)
        then TempStr := TempStr + '  School: '
        else TempStr := TempStr + '  Sch: ';

      TempStr := TempStr + FieldByName('SchoolCode').Text;

      If ResidentialSiteFound
        then TempStr := TempStr + '  Zn: ' +
                        Trim(ResidentialSiteTable.FieldByName('ZoningCode').Text);

      If CommercialSiteFound
        then TempStr := TempStr + '  Zn: ' +
                        Trim(CommercialSiteTable.FieldByName('ZoningCode').Text);

      PropertyClass_SchoolLabel.Caption := TempStr;

    end;  {with ParcelTable do}

  SetRangeOld(PictureTable,
              ['SwisSBLKey', 'PictureNumber'],
              [SwisSBLKey, '0'],
              [SwisSBLKey, '99999']);

  If PictureTable.EOF
    then
      begin
        ParcelPicture.Visible := False;
        Self.Height := InfoDialogHeightNoPictures;
        ImageTabSet.Visible := False;
        ImageTabSet.Enabled := False;
      end
    else
      begin
          {CHG07172002-1: If there is more than 1 picture, allow them to see them.}

        RecsInRange := NumRecordsInRange(PictureTable,
                                         ['SwisSBLKey', 'PictureNumber'],
                                         [SwisSBLKey, '0'],
                                         [SwisSBLKey, '99999']);

        If (RecsInRange = 1)
          then
            begin
              ImageTabSet.Visible := False;
              ImageTabSet.Enabled := False;
              Self.Height := 353;
            end
          else
            begin
              For I := 1 to RecsInRange do
                ImageTabSet.Tabs.Add('Pic ' + IntToStr(I));

              ImageTabSet.TabIndex := 0;

            end;  {If (RecsInRange = 1)}

        PictureTable.First;
        ParcelPicture.ImageName := PictureTable.FieldByName('PictureLocation').Text;

      end;  {If PictureTable.EOF}

  FillInSalesInformation;
  FillInExemptionInformation(ProcessingType);
  FillInSpecialDistrictInformation(ProcessingType);

  ResidentialSiteTable.First;

  InventoryVisible := not ResidentialSiteTable.EOF;

  If InventoryVisible
    then FillInInventoryInformation(ProcessingType)
    else NbhdLabel.Caption := 'No inventory.';

  UtilityLabel.Visible := InventoryVisible;
  ZoningLabel.Visible := InventoryVisible;
  SewerWaterLabel.Visible := InventoryVisible;

end;  {FillInParcelInformation}

{======================================================}
Procedure TMapParcelInfoForm.ParcelPictureClick(Sender: TObject);

{Hide the picture.}

begin
  ParcelPicture.Visible := False;
  ImageTabSet.Visible := False;
  Self.Height := InfoDialogHeightNoPictures;

end;  {ParcelPictureClick}

{=================================================================}
Procedure TMapParcelInfoForm.ImageTabSetChange(    Sender: TObject;
                                                   NewTab: Integer;
                                               var AllowChange: Boolean);

{CHG07172002-1: If there is more than 1 picture, allow them to see them.}

begin
  MoveToRecordNumber(PictureTable, (NewTab + 1));
  ParcelPicture.ImageName := PictureTable.FieldByName('PictureLocation').Text;
end;  {ImageTabSetChange}

{======================================================}
Procedure TMapParcelInfoForm.PushpinImageClick(Sender: TObject);

begin
  Close;
end;

{==========================================================}
Procedure TMapParcelInfoForm.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

{Signal the calling form that the form closed.}

begin
  GlblMapInfoFormClosed := True;
  GlblMapInfoFormClosingSwisSBLKey := SwisSBLKey;
end;

end.