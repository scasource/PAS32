unit RPrintParcelSummaryWithSketch;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, (*Progress,*)
  RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, PASTypes, Types, UPRNTPRC,
  TMultiP, Printers;

type
  TParcelInformationWithSketchPrintForm = class(TForm)
    Panel2: TPanel;
    ParcelTable: TTable;
    SwisCodeTable: TTable;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    GroupBox1: TGroupBox;
    ResidentialInventoryCheckBox: TCheckBox;
    CommercialInventoryCheckBox: TCheckBox;
    SalesCheckBox: TCheckBox;
    ExemptionCheckBox: TCheckBox;
    SpecialDistrictCheckBox: TCheckBox;
    BaseInformationCheckBox: TCheckBox;
    AssessmentsCheckBox: TCheckBox;
    CheckAllButton: TBitBtn;
    UncheckAllButton: TBitBtn;
    PictureCheckBox: TCheckBox;
    TaxableValuesGroupBox2: TGroupBox;
    SchoolTaxableCheckBox: TCheckBox;
    TownTaxableCheckBox: TCheckBox;
    CountyTaxableCheckBox: TCheckBox;
    NotesCheckBox: TCheckBox;
    AssessmentYearRadioGroup: TRadioGroup;
    SBLGroupBox: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    StartSBLEdit: TEdit;
    EndSBLEdit: TEdit;
    AllSBLCheckBox: TCheckBox;
    ToEndOfSBLCheckBox: TCheckBox;
    LoadFromParcelListCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    cb_Permits: TCheckBox;
    cbSketches: TCheckBox;
    cbPropertyCards: TCheckBox;
    Image: TPMultiImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure CheckAllButtonClick(Sender: TObject);
    procedure UncheckAllButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ReportCancelled : Boolean;
    LoadFromParcelList,
    CreateParcelList : Boolean;
    SwisSBLKey : String;
    Options : OptionsSet;
    tbPropertyCard : TTable;

    ProcessingType : Integer;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure PrintPropertyCard(tbPropertyCard : TTable;
                                sSwisSBLKey : String);

    Procedure PrintParcels;

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils,
     Preview, Prog, RPTDialg, DataAccessUnit,
     PRCLLIST;  {Print parcel information}

{$R *.DFM}

{========================================================}
Procedure TParcelInformationWithSketchPrintForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TParcelInformationWithSketchPrintForm.InitializeForm;

begin
  UnitName := 'RPPRCPRT';  {mmm}

    {CHG04302006-1(2.9.7.1): Allow the for permit printing.}

  If _Compare(GlblBuildingSystemLinkType, bldMunicity, coEqual)
    then cb_Permits.Visible := True
    else cb_Permits.Checked := False;

    {CHG04262012-1(2.28.4.19)[PAS-305]:  Add sketches to the F5 print.}

  If GlblUsesSketches
    then cbSketches.Visible := True;

end;  {InitializeForm}

{===================================================================}
Procedure TParcelInformationWithSketchPrintForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{====================================================================}
Procedure TParcelInformationWithSketchPrintForm.CheckAllButtonClick(Sender: TObject);

begin
  ResidentialInventoryCheckBox.Checked := True;
  CommercialInventoryCheckBox.Checked := True;
  SalesCheckBox.Checked := True;
  ExemptionCheckBox.Checked := True;
  SpecialDistrictCheckBox.Checked := True;
  BaseInformationCheckBox.Checked := True;
  AssessmentsCheckBox.Checked := True;
  CountyTaxableCheckBox.Checked := True;
  TownTaxableCheckBox.Checked := True;
  SchoolTaxableCheckBox.Checked := True;

    {CHG04302006-1(2.9.7.1): Allow the for permit printing.}

  If GlblUsesPASPermits
    then cb_Permits.Checked := True;

    {CHG04262012-1(2.28.4.19)[PAS-305]:  Add sketches to the F5 print.}

  If GlblUsesSketches
    then cbSketches.Checked := True;

end;  {CheckAllButtonClick}

{==============================================================}
Procedure TParcelInformationWithSketchPrintForm.UncheckAllButtonClick(Sender: TObject);

begin
  ResidentialInventoryCheckBox.Checked := False;
  CommercialInventoryCheckBox.Checked := False;
  SalesCheckBox.Checked := False;
  ExemptionCheckBox.Checked := False;
  SpecialDistrictCheckBox.Checked := False;
  BaseInformationCheckBox.Checked := False;
  AssessmentsCheckBox.Checked := False;
  CountyTaxableCheckBox.Checked := False;
  TownTaxableCheckBox.Checked := False;
  SchoolTaxableCheckBox.Checked := False;

    {CHG04302006-1(2.9.7.1): Allow the for permit printing.}

  If GlblUsesPASPermits
    then cb_Permits.Checked := False;

    {CHG04262012-1(2.28.4.19)[PAS-305]:  Add sketches to the F5 print.}

  If GlblUsesSketches
    then cbSketches.Visible := False;
  
end;  {UncheckAllButtonClick}

{====================================================================}
Procedure TParcelInformationWithSketchPrintForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'propinfo.prc', 'Property Cards');

end;  {SaveButtonClick}

{====================================================================}
Procedure TParcelInformationWithSketchPrintForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'propinfo.prc', 'Property Cards');

end;  {LoadButtonClick}

{===================================================================}
Procedure TParcelInformationWithSketchPrintForm.PrintButtonClick(Sender: TObject);

var
  Quit : Boolean;

begin
  ReportCancelled := False;
    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  PrintButton.Enabled := False;
  Application.ProcessMessages;

  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
          {FXX04052000-1: Check all if no selection.}

        If ((not (AllSBLCheckBox.Checked or
                  ToEndOfSBLCheckBox.Checked)) and
            (Deblank(StartSBLEdit.Text) = '') and
            (Deblank(EndSBLEdit.Text) = ''))
          then AllSBLCheckBox.Checked := True;

        LoadFromParcelList := LoadFromParcelListCheckBox.Checked;

          {CHG09071999-2: Add create parcel list.}

        CreateParcelList := CreateParcelListCheckBox.Checked;

        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);

        PrintParcels();

        If CreateParcelList
          then ParcelListDialog.Show;

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

  PrintButton.Enabled := True;

end;  {PrintButtonClick}


{===========================================================================}
Procedure TParcelInformationWithSketchPrintForm.PrintPropertyCard(tbPropertyCard : TTable;
                                                                  sSwisSBLKey : String);

begin
  If (tbPropertyCard = nil)
  then
  begin
    tbPropertyCard := TTable.Create(nil);

    with tbPropertyCard do
    try
      DatabaseName := 'PASSystem';
      TableType := ttDBase;
      TableName := PropertyCardTableName;
      IndexName := 'BYSWISSBLKEY_DOCUMENTNUMBER';
      Open;
    except
    end;

  end;


  _SetRange(tbPropertyCard, [sSwisSBLKey, 0], [sSwisSBLKey, 9999], '', []);

  If _Compare(tbPropertyCard.RecordCount, 0, coGreaterThan)
  then
    try
      tbPropertyCard.First;

      try
        Printer.Refresh;
        Image.GetInfoAndType(tbPropertyCard.FieldByName('DocumentLocation').Text);
        Image.ImageName := tbPropertyCard.FieldByName('DocumentLocation').AsString;

        PrintImage(Image, Handle, 0, 0, 6360, 4900,
                   0, 999, False);
      except
      end;

    except
    end;

end;  {PrintPropertyCard}

{=======================================================================}
Procedure TParcelInformationWithSketchPrintForm.ReportPrint(Sender: TObject);

begin
  PrintAParcel(Sender, SwisSBLKey, ProcessingType, Options);

  If (ptPropertyCard in Options)
    then PrintPropertyCard(tbPropertyCard, SwisSBLKey);

end;

{=======================================================================}
Procedure TParcelInformationWithSketchPrintForm.PrintParcels;

var
  PrintAllParcelIDs,
  ValidEntry : Boolean;
  StartSwisSBLKey, EndSwisSBLKey : String;
  Index : Integer;
  SBLRec : SBLRecord;
  Quit, Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  Index := 1;

  If (AssessmentYearRadioGroup.ItemIndex = 0)
     then ProcessingType := ThisYear
     else ProcessingType := NextYear;

   Options := [];

   Options := Options + [ptPrintNextYear];

   If BaseInformationCheckBox.Checked
     then Options := Options + [ptBaseInformation];

  If AssessmentsCheckBox.Checked
    then Options := Options + [ptAssessments];

   If SpecialDistrictCheckBox.Checked
     then Options := Options + [ptSpecialDistricts];

   If ExemptionCheckBox.Checked
     then Options := Options + [ptExemptions];

   If SalesCheckBox.Checked
     then Options := Options + [ptSales];

   If ResidentialInventoryCheckBox.Checked
     then Options := Options + [ptResidentialInventory];

   If CommercialInventoryCheckBox.Checked
     then Options := Options + [ptCommercialInventory];

   If PictureCheckBox.Checked
     then Options := Options + [ptPictures];

    {CHG09192001-2: Allow them to select which taxable values to show.}

  If CountyTaxableCheckBox.Checked
    then Options := Options + [ptCountyTaxable];

  If TownTaxableCheckBox.Checked
    then Options := Options + [ptTownTaxable];

  If SchoolTaxableCheckBox.Checked
    then Options := Options + [ptSchoolTaxable];

    {CHG03282002-11: Allow them to print notes.}

  If (NotesCheckBox.Checked and
      (not GlblUserIsSearcher))
    then Options := Options + [ptNotes];

    {CHG04302006-1(2.9.7.1): Allow the for permit printing.}

  If (cb_Permits.Checked and
      (not GlblUserIsSearcher))
    then Options := Options + [ptPermits];

    {CHG04262012-1(2.28.4.19)[PAS-305]:  Add sketches to the F5 print.}

  If GlblUsesSketches
    then Options := Options + [ptSketches];

  If cbPropertyCards.Checked
    then Options := Options + [ptPropertyCard];

   OpenTablesForForm(Self, ProcessingType);

   PrintAllParcelIDs := False;

   If not LoadFromParcelList
     then
       If AllSBLCheckBox.Checked
         then PrintAllParcelIDs := True
         else
           begin
             StartSwisSBLKey := ConvertSwisDashDotToSwisSBL(StartSBLEdit.Text, SwisCodeTable,
                                                            ValidEntry);

               {FXX12011998-21: Was using StartSBLEdit for end range.}

             If not ToEndOfSBLCheckBox.Checked
               then EndSwisSBLKey := ConvertSwisDashDotToSwisSBL(EndSBLEdit.Text,
                                                                 SwisCodeTable,
                                                                 ValidEntry);

           end;  {If AllSBLCheckBox.Checked}

    {CHG03191999-2: Add option to load from parcel list.}

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(ParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

        If PrintAllParcelIDs
          then ParcelTable.First
          else
            begin
              SBLRec := ExtractSwisSBLFromSwisSBLKey(StartSwisSBLKey);

                {FXX12011998-22: Forgot that 1st part of key is tax roll year.}

              with SBLRec do
                FindNearestOld(ParcelTable,
                               ['TaxRollYr', 'SwisCode', 'Section',
                                'Subsection', 'Block', 'Lot', 'Sublot',
                                'Suffix'],
                               [GetTaxRollYearForProcessingType(ProcessingType),
                                SwisCode, Section, Subsection, Block, Lot,
                                Sublot, Suffix]);

            end;  {else of If PrintAllParcelIDs}

      end;  {else of If LoadFromParcelList}

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              Index := Index + 1;
              ParcelListDialog.GetParcel(ParcelTable, Index);
            end
          else ParcelTable.Next;

    SwisSBLKey := ExtractSSKey(ParcelTable);

      {FXX12011998-23: Check for entered end range.}
      {FXX06251999-2: Was not checking the PrintAllParcels and so Print All Parcels was
                      not working.}

    If (ParcelTable.EOF or
        ((not PrintAllParcelIDs) and
         (not LoadFromParcelList) and
         (SwisSBLKey > EndSwisSBLKey)) or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    If LoadFromParcelList
      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
      else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

    If not Done
      then
        begin
          Application.ProcessMessages;

          AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);

          ReportPrinter.Execute;

            {CHG09071999-2: Add create parcel list.}

          If CreateParcelList
            then ParcelListDialog.AddOneParcel(SwisSBLKey);

        end;  {If not Done}

  until (Done or ProgressDialog.Cancelled);

  ProgressDialog.Finish;

end;  {PrintParcels}

{===================================================================}
Procedure TParcelInformationWithSketchPrintForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

  try
    tbPropertyCard.Close;
    tbPropertyCard.Free;
  except
  end;

end;  {FormClose}


end.
