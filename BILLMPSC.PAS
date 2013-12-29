unit Billmpsc;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Btrvdlg, wwdblook, Mask,types,pastypes,
  Glblcnst, Gauges,Printrng, RPMemo, RPDBUtil, RPDefine, (*Progress,*) RPTXFilr,
  RPFPrint, RPreview, TabNotBk, Progress, ComCtrls;

type
  TPrintMtPleasantSchoolBillsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    PrintDialog: TPrintDialog;
    Label18: TLabel;
    CollectionLookupTable: TwwTable;
    label16: TLabel;
    Label2: TLabel;
    ScrollBox2: TScrollBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    CloseButton: TBitBtn;
    PrintButton: TBitBtn;
    BillCollTypeLookupTable: TwwTable;
    EditTaxRollYear: TEdit;
    Label8: TLabel;
    BLSpecialDistrictTaxTable: TTable;
    BLExemptionTaxTable: TTable;
    BLGeneralTaxTable: TTable;
    BLHeaderTaxTable: TTable;
    BLSpecialFeeTaxTable: TTable;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    ProgressDialog: TProgressDialog;
    AssessmentYearCtlTable: TTable;
    Label23: TLabel;
    SDCodeTable: TTable;
    Label24: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    LookupCollectionType: TwwDBLookupCombo;
    EditCollectionNumber: TEdit;
    BillTabbedNotebook: TTabbedNotebook;
    BankCodesExcludedStringGrid: TStringGrid;
    PrintOrderRadioGroup: TRadioGroup;
    BillParameterTable: TTable;
    BillParamDataSource: TDataSource;
    AssessmentRollDateDBEdit: TDBEdit;
    FullMktValDBEdit: TDBEdit;
    FiscalYearDBEdit: TDBEdit;
    WarrantDateYrDBEdit: TDBEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label20: TLabel;
    EditTaxYear: TDBEdit;
    Label21: TLabel;
    GroupBox1: TGroupBox;
    StartDataLabel: TLabel;
    StartDetailLabel: TLabel;
    StartDataEdit: TEdit;
    NameSBLEdit: TEdit;
    LATextEdit: TEdit;
    LANoEdit: TEdit;
    Label6: TLabel;
    BillParameterTableTaxRollYear: TStringField;
    BillParameterTableCollectionType: TStringField;
    BillParameterTableWarrantDate: TDateField;
    BillParameterTableFiscalYear: TStringField;
    BillParameterTableFullMktValueDate: TDateField;
    BillParameterTableAssessmentRollDate: TDateField;
    BillParameterTablePercentValue: TFloatField;
    BillParameterTableTaxYear: TStringField;
    StartDetailLabel2: TLabel;
    SwisCodeTable: TTable;
    Label7: TLabel;
    SchoolCodeTable: TTable;
    ZipPlus4Edit: TEdit;
    ZipPlus4Label: TLabel;
    SysRecTable: TTable;
    ParcelTable: TTable;
    ArrearsMessageTable: TTable;
    ArrearsMessageTableTaxRollYr: TStringField;
    ArrearsMessageTableCollectionType: TStringField;
    ArrearsMessageTableCollectionNo: TSmallintField;
    ArrearsMessageTableArrearsMessage: TMemoField;
    ArrearsMemo: TDBMemo;
    ArrearsMessageDataSource: TDataSource;
    SaveBillParamterButton: TBitBtn;
    CancelBillParameterButton: TBitBtn;
    Label9: TLabel;
    SwisCodeListBox: TListBox;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ProgressDialogCancel(Sender: TObject);
    procedure PrintOrderRadioGroupClick(Sender: TObject);
    procedure ReportPrinterBeforePrint(Sender: TObject);
    procedure ReportPrinterPrint(Sender: TObject);
    procedure BillParameterTableNewRecord(DataSet: TDataset);
    procedure SetBillingCycle(Sender: TObject;
      LookupTable: TwwTable; FillTable: TDataset; modified: Boolean);
    procedure SaveBillParamterButtonClick(Sender: TObject);
    procedure CancelBillParameterButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    PrintingCancelled : Boolean;

    GeneralRateList,
    SDRateList,
    SpecialFeeRateList,
    BillControlDetailList,
    SDExtCategoryList,
    PropertyClassDescList,
    RollSectionDescList,
    EXCodeDescList,
    SDCodeDescList,
    SDExtCodeDescList,
    SwisCodeDescList,
    SchoolCodeDescList : TList;

    ExcludedBankCodes : TStringList;

    TotalBilled, TotalNotBilled : Extended;
    TotalRS8_NoBill, TotalRS9_NoBill,
    NumBilled, NumNotBilled, NumBankCoded : LongInt;

    FoundCollectionRec : Boolean;
    CollectionType : Str2;
    NumBillsPrinted : LongInt;
    LastRollSection : Str1;
    LastSwisCode,
    LastSchoolCode : Str6;
    SequenceStr : Str30;  {Text of what order the roll is printing in.}
    RollPrintingYear : Str4;
    SelectedSwisCodes : TStringList;

    LoadFromParcelList : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Function ParcelShouldBePrinted(BLHeaderTaxTable : TTable;
                                   SelectedSwisCodes : TStringList) : Boolean;


  end;


implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Preview, Prog,
     PRCLLIST,  {Parcel list}
     UtilBill,  {Billing specific utilities.}
     Utrtotpt;  {Section totals print unit}

const
  TrialRun = False;

{$R *.DFM}

{========================================================}
Procedure TPrintMtPleasantSchoolBillsForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TPrintMtPleasantSchoolBillsForm.InitializeForm;

var
  I : Integer;
  FirstTimeThrough, Done : Boolean;

begin
  UnitName := 'BCOLLBIL.PAS';  {mmm}

      {Only let them print bills in this year.}

    {FXX10131997-1: Don't open the tables if not this year - causes error.}

  If (GlblTaxYearFlg = 'T')
    then
      begin
          {Note that the billing tax files do not get opened below.
           They get opened once the person fills in the collection type and
           number.}

        OpenTablesForForm(Self, ThisYear);

          {FXX03181999-6: Let them choose the swis code(s) to print.}

          {Fill in the swis code list.}

        SwisCodeTable.First;

        FirstTimeThrough := True;
        Done := False;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else SwisCodeTable.Next;

          If SwisCodeTable.EOF
            then Done := True;

          If not Done
            then SwisCodeListBox.Items.Add(SwisCodeTable.FieldByName('SWISSwisCode').Text);

        until Done;

          {Default to all swis codes.}

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          SwisCodeListBox.Selected[I] := True;

        SelectedSwisCodes := TStringList.Create;

      end
    else
      begin
        MessageDlg('The tax bills can only be printed in this year processing.' + #13 +
                   'Please choose the "This Year" assessment year from the main menu.',
                   mtError, [mbOK], 0);
        Close;

     end;  {If (GlblTaxYearFlg <> 'T')}

  EditTaxRollYear.Text := GlblThisYear;


end;  {InitializeForm}

{===================================================================}
Procedure TPrintMtPleasantSchoolBillsForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{========================================================================}
Procedure TPrintMtPleasantSchoolBillsForm.PrintOrderRadioGroupClick(Sender: TObject);

begin
       {set starting/ending data prompts based on key selected}

  case PrintOrderRadioGroup.ItemIndex of
    0 : begin
          StartDataEdit.Visible := False;
          StartDataLabel.Visible := False;
          StartDetailLabel2.Visible := False;
          ZipPlus4Edit.Visible := False;
          ZipPlus4Label.Visible := False;
          ZipPlus4Edit.Text := '';

          LANoEdit.Visible := False;
          LATextEdit.Visible := False;

          StartDetailLabel.Caption := 'Starting Parcel ID';
          StartDetailLabel.Visible := True;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := True;

        end;  {SBL}

    1 : begin
          StartDataEdit.Visible := False;
          StartDataLabel.Visible := False;
          LANoEdit.Visible := False;
          LATextEdit.Visible := False;
          StartDetailLabel2.Visible := False;
          ZipPlus4Edit.Visible := False;
          ZipPlus4Label.Visible := False;
          ZipPlus4Edit.Text := '';

          StartDetailLabel.Caption := 'Starting Name';
          StartDetailLabel.Visible := True;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := True;
          LANoEdit.Text := '';
          LATextEdit.Text := '';

        end;  {Name}

    2 : begin
          StartDataEdit.Visible := False;
          StartDataLabel.Visible := False;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := False;
          StartDetailLabel.Visible := False;
          ZipPlus4Edit.Visible := False;
          ZipPlus4Label.Visible := False;
          ZipPlus4Edit.Text := '';

          StartDetailLabel2.Caption := 'Starting Address (# and Street)';
          StartDetailLabel2.Visible := True;

          LANoEdit.Text := '';
          LATextEdit.Text := '';
          LANoEdit.Visible := True;
          LATextEdit.Visible := True;

        end;  {Address}

    3 : begin
          StartDataEdit.Visible := True;
          ZipPlus4Edit.Visible := True;
          ZipPlus4Label.Visible := True;
          ZipPlus4Edit.Text := '';
          StartDataLabel.Caption := 'Starting Zip';
          StartDataLabel.Visible := True;
          LANoEdit.Visible := False;
          LATextEdit.Visible := False;
          StartDetailLabel2.Visible := False;

          StartDetailLabel.Caption := 'Starting Parcel ID';
          StartDetailLabel.Visible := True;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := True;

        end;  {Zip / SBL}

    4 : begin
          StartDataEdit.Visible := True;
          ZipPlus4Label.Visible := True;
          ZipPlus4Edit.Visible := True;
          ZipPlus4Edit.Text := '';
          StartDataLabel.Caption := 'Starting Zip';
          StartDataLabel.Visible := True;
          LANoEdit.Visible := False;
          LATextEdit.Visible := False;
          StartDetailLabel2.Visible := False;

          StartDetailLabel.Caption := 'Starting Name';
          StartDetailLabel.Visible := True;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := True;

        end;  {Zip \ Name}

    5 : begin
          StartDataEdit.Visible := True;
          StartDataLabel.Caption := 'Starting Zip';
          StartDataLabel.Visible := True;
          ZipPlus4Edit.Visible := True;
          ZipPlus4Label.Visible := True;
          ZipPlus4Edit.Text := '';
          NameSBLEdit.Visible := False;
          StartDetailLabel.Visible := False;

          StartDetailLabel2.Caption := 'Starting Address (# and Street)';
          StartDetailLabel2.Visible := True;

          LANoEdit.Text := '';
          LATextEdit.Text := '';
          LANoEdit.Visible := True;
          LATextEdit.Visible := True;

        end;  {Zip \ addr}

    6 : begin
          StartDataEdit.Text := '';
          StartDataEdit.Visible := True;
          StartDataLabel.Caption := 'Starting Bank';
          StartDataLabel.Visible := True;
          LANoEdit.Visible := False;
          LATextEdit.Visible := False;
          StartDetailLabel2.Visible := False;
          ZipPlus4Edit.Visible := False;
          ZipPlus4Label.Visible := False;
          ZipPlus4Edit.Text := '';

          StartDetailLabel.Caption := 'Starting Parcel ID';
          StartDetailLabel.Visible := True;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := True;

        end; {Bank \ SBL}

    7 : begin
          StartDataEdit.Text := '';
          StartDataEdit.Visible := True;
          StartDataLabel.Caption := 'Starting Bank';
          StartDataLabel.Visible := True;
          LANoEdit.Visible := False;
          LATextEdit.Visible := False;
          StartDetailLabel2.Visible := False;
          ZipPlus4Edit.Visible := False;
          ZipPlus4Label.Visible := False;
          ZipPlus4Edit.Text := '';

          StartDetailLabel.Caption := 'Starting Name';
          StartDetailLabel.Visible := True;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := True;

        end;  {Bank / name}

    8 : begin
          StartDataEdit.Text := '';
          StartDataEdit.Visible := True;
          StartDataLabel.Caption := 'Starting Bank';
          StartDataLabel.Visible := True;
          NameSBLEdit.Visible := False;
          StartDetailLabel.Visible := False;
          ZipPlus4Edit.Visible := False;
          ZipPlus4Label.Visible := False;
          ZipPlus4Edit.Text := '';

          StartDetailLabel2.Caption := 'Starting Address (# and Street)';
          StartDetailLabel2.Visible := True;

          LANoEdit.Text := '';
          LATextEdit.Text := '';
          LANoEdit.Visible := True;
          LATextEdit.Visible := True;

        end;  {Bank / addr}

  end;  {end Case}

end;  {PrintOrderRadioGroupClick}

{===================================================================}
Procedure TPrintMtPleasantSchoolBillsForm.SaveBillParamterButtonClick(Sender: TObject);

{FXX0318199-5: Allow for save or cancel of billing parameters.}

begin
  BillParameterTable.Post;
end;

{====================================================================}
Procedure TPrintMtPleasantSchoolBillsForm.CancelBillParameterButtonClick(Sender: TObject);

begin
  BillParameterTable.Cancel;
end;

{=====================================================================}
Procedure TPrintMtPleasantSchoolBillsForm.BillParameterTableNewRecord(DataSet: TDataset);

begin
  with BillParameterTable do
    begin
      FieldByName('TaxRollYear').Text := GlblThisYear;
      FieldByName('CollectionType').Text := LookupCollectionType.Text;
    end;  {with BillParameterTable do}

end;  {BillParameterTableNewRecord}

{========================================================================}
Procedure TPrintMtPleasantSchoolBillsForm.SetBillingCycle(Sender: TObject;
                                              LookupTable: TwwTable;
                                              FillTable: TDataset;
                                              modified: Boolean);

{Once they select the collection type, load the parameter file. If there is
 not one, put it in insert mode.}

var
  _Found : Boolean;

begin
  If (Deblank(LookupCollectionType.Text) <> '')
    then
      begin
        with BillParameterTable do
          begin
              {If the last table they were working on is not posted, then post it.}

            If (State in [dsEdit, dsInsert])
              then Post;

            _Found := FindKey([GlblThisYear, LookupCollectionType.Text]);

            If _Found
              then Edit
              else Insert;

          end;  {with BillParameterTable do}

      end;  {If ((Deblank(LookupCollectionType.Text) <> '')}

end;  {SetBillingCycle}

{=====================================================================}
Procedure TPrintMtPleasantSchoolBillsForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;
  Orientation, Count, I,J : Integer;

  GeneralTotFileName,
  SDTotFileName,
  SchoolTotFileName,
  EXTotFileName,
  SpecialFeeTotFileName : String;

  BankExcluded,
  Found, OKToStartPrinting, Quit : Boolean;
  Index,
  CollectionNum : Integer;
  TaxRollYear : Str4;

  HeaderFileName, GeneralFileName,
  EXFileName, SDFileName, SpecialFeeFileName : String;

  Bins : TStrings;
  Bin : String;

begin
  OKToStartPrinting := True;
  GlblCurrentTabNo := 0;

  If (Deblank(EditTaxRollYear.Text) = '')
    then
      begin
        MessageDlg('Please enter the tax roll year.', mtError, [mbOK], 0);
        OKToStartPrinting := False;
      end;

  If (Deblank(EditCollectionNumber.Text) = '')
    then
      begin
        MessageDlg('Please enter the collection number.', mtError, [mbOK], 0);
        OKToStartPrinting := False;
      end;

  If (Deblank(LookupCollectionType.Text) = '')
    then
      begin
        MessageDlg('Please enter the collection type.', mtError, [mbOK], 0);
        OKToStartPrinting := False;
      end;

    {If they have entered all the information, look it up in the bill
     control file to make sure that a collection exists for what they
     entered.}

  If OKToStartPrinting
    then
      begin
        TaxRollYear := Take(4, EditTaxRollYear.Text);
        CollectionType := Take(2, LookupCollectionType.Text);
        CollectionNum := StrToInt(Deblank(EditCollectionNumber.Text));

        try
          Found := CollectionLookupTable.FindKey([TaxRollYear, CollectionType,
                                                  CollectionNum]);
        except
          OKToStartPrinting := False;
          SystemSupport(010, CollectionLookupTable, 'Error getting bill control record.',
                        UnitName, GlblErrorDlgBox);
        end;

        If Found
          then
            begin
              If (MessageDlg('You are going to print tax bills for collection type ' + CollectionType + ',' + #13 +
                             'collection number ' + IntToStr(CollectionNum) + '.' + #13 + #13 +
                             'Do you want to proceed?',
                             mtConfirmation, [mbYes, mbNo], 0) = idNo)
                then OKToStartPrinting := False;

            end
          else
            begin
              MessageDlg('The collection that you entered does not exist.' + #13 +
                         'Please try again.', mtError, [mbOK], 0);
              OKToStartPrinting := False;
            end;

      end;  {If OKToStartPrinting}

       {allow user to stop if no bank codes were excluded}

  If OKToStartPrinting
    then
      begin
        BankExcluded := False;

        with BankCodesExcludedStringGrid do
          For I := 0 to (ColCount - 1) do
            For J := 0 to (RowCount - 1) do
              If (Deblank(Cells[I,J]) <> '')
                then BankExcluded := True;

        If ((not BankExcluded) and
            (MessageDlg('You have not excluded any bank codes for this '+ #13 +
                        'bill print run.' + #13 + #13 + 'Do you want to proceed?',
                        mtConfirmation, [mbYes, mbNo], 0) = idNo))
          then OKToStartPrinting := False;

      end;  {If OKToStartPrinting}

    {Set the print index.}

  LoadFromParcelList := False;

  If OKToStartPrinting
    then
      with BLHeaderTaxTable do
        case PrintOrderRadioGroup.ItemIndex of
          0 : IndexFieldNames := 'SBLKey';
          1 : IndexFieldNames := 'Name1';
          2 : IndexFieldNames := 'LegalAddr;LegalAddrNo';
          3 : IndexFieldNames := 'Zip;ZipPlus4;SBLKey';
          4 : IndexFieldNames := 'Zip;ZipPlus4;Name1';
          5 : IndexFieldNames := 'Zip;ZipPlus4;LegalAddr;LegalAddrNo';
          6 : IndexFieldNames := 'BankCode;SBLKey';
          7 : IndexFieldNames := 'BankCode;Name1';
          8 : IndexFieldNames := 'BankCode;LegalAddr;LegalAddrNo';
          9 : LoadFromParcelList := True;
          else
            begin
              MessageDlg('You must select a print order for the bills.',
                         mtError, [mbOK], 0);
              OKToStartPrinting := False;
            end;

        end;  {case IndexRadioGroup.ItemIndex of}

    {If they entered a collection that exists, then open the billing and
     totals files, get the rates, and start the billing.}

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If (OKToStartPrinting and
      PrintDialog.Execute)
    then
      begin
        SelectedSwisCodes.Clear;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(SwisCodeListBox.Items[I]);

          {Post the parameter file if we need to.}

        with BillParameterTable do
          If (State in [dsEdit, dsInsert])
            then Post;

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);

        ReportPrinter.SetPaperSize(dmPaper_Legal,0,0);  {SET PAPER TO LEGAL SIZE FOR MT PLEASANT BILL}
        ReportFiler.SetPaperSize(dmPaper_Legal,0,0);  {SET PAPER TO LEGAL SIZE FOR MT PLEASANT BILL}

        Quit := False;
        NumBillsPrinted := 0;
        PrintingCancelled := False;

         {create the excluded bank code list}
         {and fill it in from excluded bank string grid}

        ExcludedBankCodes := TStringList.Create;

        with BankCodesExcludedStringGrid do
          For I := 0 to (ColCount - 1) do
            For J := 0 to (RowCount - 1) do
              If (Deblank(Cells[I,J]) <> '')
                then ExcludedBankCodes.Add(Trim(Cells[I,J]));


        TotalBilled := 0;
        TotalNotBilled := 0;
        NumBilled := 0;
        NumNotBilled := 0;
        NumBankCoded := 0;

          {CHG03221999-1: Include count of number of rs 8, no bill.}

        TotalRS8_NoBill := 0;
        TotalRS9_NoBill := 0;

          {Create the rate lists.}

        GeneralRateList := TList.Create;
        SDRateList := TList.Create;
        SpecialFeeRateList := TList.Create;
        BillControlDetailList := TList.Create;

          {Description lists}

        SDExtCategoryList := TList.Create;
        PropertyClassDescList := TList.Create;
        EXCodeDescList := TList.Create;
        SDCodeDescList := TList.Create;
        SwisCodeDescList := TList.Create;
        SchoolCodeDescList := TList.Create;
        SDExtCodeDescList := TList.Create;
        RollSectionDescList := TList.Create;

        OpenTableForProcessingType(ParcelTable, ParcelTableName, ThisYear, Quit);

          {CHG03161999-1: Add in an arrears message.}

        ArrearsMessageTable.Open;

        ArrearsMessageTable.FindKey([TaxRollYear, CollectionType, CollectionNum]);

          {Get the file names and open the billing files for this
           tax year\municipal type\collection #.}

        GetBillingFileNames(TaxRollYear, CollectionType,
                            ShiftRightAddZeroes(Take(2, IntToStr(CollectionNum))),
                            HeaderFileName, GeneralFileName,
                            EXFileName, SDFileName, SpecialFeeFileName);

        OpenBillingFiles(HeaderFileName, GeneralFileName, EXFileName,
                         SDFileName, SpecialFeeFileName, BLHeaderTaxTable,
                         BLGeneralTaxTable, BLExemptionTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLSpecialFeeTaxTable, Quit);

          {Now load the rate and description lists.}

        If not Quit
          then
            begin
              LoadRateListsFromRateFiles(TaxRollYear, CollectionType,
                                         CollectionNum, GeneralRateList,
                                         SDRateList,
                                         SpecialFeeRateList,
                                         BillControlDetailList, 'P', Quit);

              LoadSDExtCategoryList(SDExtCategoryList, Quit);

              LoadCodeList(PropertyClassDescList, 'ZPropClsTbl',
                           'MainCode', 'Description', Quit);

              LoadCodeList(RollSectionDescList, 'ZRollSectionTbl',
                           'MainCode', 'Description', Quit);

              LoadCodeList(EXCodeDescList, 'TExCodeTbl',
                           'ExCode', 'Description', Quit);

              LoadCodeList(SDCodeDescList, 'TSDCodeTbl',
                           'SDistCode', 'Description', Quit);

              LoadCodeList(SwisCodeDescList, 'TSwisTbl',
                           'SWISSwisCode', 'MunicipalityName', Quit);

              LoadCodeList(SchoolCodeDescList, 'TSchoolTbl',
                           'SCHLSchoolCode', 'SCHLSchoolName', Quit);

              LoadCodeList(SDExtCodeDescList, 'ZSDExtCodeTbl',
                           'MainCode', 'Description', Quit);

            end;  {If not Quit}

          {Now, print the roll.}
          {CHG12301997-1: Change the report printer and filer to the
                          TextPrinter component.}

        If not Quit
          then
            begin
              PrintingCancelled := False;

              If LoadFromParcelList
                then ProgressDialog.Start(ParcelListDialog.NumItems)
                else ProgressDialog.Start(ParcelTable.RecordCount);

              GlblPreviewPrint := False;

              If PrintDialog.PrintToFile
                then
                  begin
                    GlblPreviewPrint := True;
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    ReportFiler.FileName := NewFileName;

                      {link preview form to file}
                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      PreviewForm.FilePreview.ZoomFactor := 130;

                      ReportFiler.Execute;
                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;
                    end;

                      {Delete the report printer file.}

                    try
                      Chdir(GlblReportDir);
                      OldDeleteFile(NewFileName);
                    except
                    end;

                  end
                else ReportPrinter.Execute;

              ProgressDialog.Finish;

                {CHG03221999-1: Include count of number of rs 8, no bill.}

              MessageDlg('Total printed = ' +
                         FormatFloat(CurrencyDecimalDisplay, TotalBilled) +
                         '  (' + IntToStr(NumBilled) + ' bills)' + #13 +
                         'Total not printed = ' +
                         FormatFloat(CurrencyDecimalDisplay, TotalNotBilled) +
                         '  (' + IntToStr(NumNotBilled) + ' bills)' + #13 +
                         'Bills excluded by bank code = ' +
                         IntToStr(NumBankCoded) + #13 +
                         'Roll 8 bills not printed (no tax) = ' +
                         IntToStr(TotalRS8_NoBill),
                         mtInformation, [mbOK], 0);

            end;  {If not Quit}

          {Close the billing files.}

        BLHeaderTaxTable.Close;
        BLGeneralTaxTable.Close;
        BLExemptionTaxTable.Close;
        BLSpecialDistrictTaxTable.Close;
        BLSpecialFeeTaxTable.Close;

          {Finally free up the rate and totals TLists.}

        FreeTList(GeneralRateList, SizeOf(GeneralRateRecord));
        FreeTList(SDRateList, SizeOf(SDRateRecord));
        FreeTList(SpecialFeeRateList, SizeOf(SpecialFeeRecord));
        FreeTList(BillControlDetailList, SizeOf(ControlDetailRecord));

        FreeTList(SDExtCategoryList, SizeOf(SDExtCategoryRecord));

          {FXX01191998-2: Freeing the wrong record size.}
          {FXX01211998-2: Was freeing the RollSectionDescList 2x.}

        FreeTList(RollSectionDescList, SizeOf(CodeRecord));
        FreeTList(EXCodeDescList, SizeOf(CodeRecord));
        FreeTList(SDCodeDescList, SizeOf(CodeRecord));
        FreeTList(SwisCodeDescList, SizeOf(CodeRecord));
        FreeTList(SchoolCodeDescList, SizeOf(CodeRecord));
        FreeTList(SDExtCodeDescList, SizeOf(CodeRecord));
        FreeTList(PropertyClassDescList, SizeOf(CodeRecord));

        ExcludedBankCodes.Free;

      end;  {If OKToStartPrinting}

end;  {PrintButtonClick}

{==================================================================}
Procedure TPrintMtPleasantSchoolBillsForm.ProgressDialogCancel(Sender: TObject);

{FXX01021998-4: Handle pressing the cancel button.}

begin
  PrintingCancelled := True;
end;

{===================================================================}
Function TPrintMtPleasantSchoolBillsForm.ParcelShouldBePrinted(BLHeaderTaxTable : TTable;
                                                   SelectedSwisCodes : TStringList) : Boolean;

{We should print this parcel if it does not have a bank code in the exclusion list.}

var
  I, BankCodeLen : Integer;
  TotalOwed : Extended;

begin
  Result := True;

  If (Result and
      (BLHeaderTaxTable.FieldByName('RollSection').Text = '8') and
      (Roundoff(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat, 2) = 0))
    then Result := False;

    {FXX03181999-6: Allow them to select the swis code.}

  If (Result and
      (SelectedSwisCodes.IndexOf(BLHeaderTaxTable.FieldByName('SwisCode').Text) = -1))
    then Result := False;

  If Result
    then
      For I := 0 to (ExcludedBankCodes.Count - 1) do
        begin
          BankCodeLen := Length(Trim(ExcludedBankCodes[I]));

          If (Take(BankCodeLen, BLHeaderTaxTable.FieldByName('BankCode').Text) =
              Take(BankCodeLen, ExcludedBankCodes[I]))
            then
              begin
                Result := False;
                NumBankCoded := NumBankCoded + 1;
              end;

        end;  {For I := 0 to (ExcludedBankCodes.Count - 1) do}

    {CHG03221999-1: Track # of rs 8, no bills.}

  If ((BLHeaderTaxTable.FieldByName('RollSection').Text = '8') and
      (Roundoff(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat, 2) = 0))
   then TotalRS8_NoBill := TotalRS8_NoBill + 1;

  If ((BLHeaderTaxTable.FieldByName('RollSection').Text = '9') and
      (Roundoff(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat, 2) = 0))
   then TotalRS9_NoBill := TotalRS9_NoBill + 1;

    {If this is a pro-rata parcel without any amount owed, don't print.}

  If (Result and
      (BLHeaderTaxTable.FieldByName('RollSection').Text = '9') and
      (Roundoff(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat, 2) = 0))
    then Result := False
    else
      begin
        TotalOwed := BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat;

        If Result
          then
            begin
              NumBilled := NumBilled + 1;
              TotalBilled := TotalBilled + TotalOwed;
            end
          else
            begin
              NumNotBilled := NumNotBilled + 1;
              TotalNotBilled := TotalNotBilled + TotalOwed;
            end;

      end;  {If (Result and...}

end;  {ParcelShouldBePrinted}

{=======================================================================}
Function FindGeneralRate(BillType : Char; {'S'wis, S'c'hool}
                         Code : Str6;  {Swis or school code}
                         GeneralRateList : TList) : Integer;

{Find the index of the rate with this print order in the general rate list.}

var
  J, CodeLen : Integer;

begin
  Result := -1;
  Code := Trim(Code);
  CodeLen := Length(Code);

  For J := 0 to (GeneralRateList.Count - 1) do
    If (((BillType = 'S') and
         (Take(CodeLen, GeneralRatePointer(GeneralRateList[J])^.SwisCode) =
          Take(CodeLen, Code))) or
        ((BillType = 'C') and
         (Take(CodeLen, GeneralRatePointer(GeneralRateList[J])^.SchoolCode) =
          Take(CodeLen, Code))))
      then Result := J;

end;  {FindGeneralRate}

{======================================================================}
Function PrintOneBill(ReportPrinter : TReportPrinter;
                      ReportFiler : TReportFiler;
                      ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                      SwisSBLKey : Str26;
                      FormattedSwisSBLKey : String;
                      SchoolCodeTable,
                      SwisCodeTable,
                      CollectionLookupTable,
                      BLHeaderTaxTable,
                      BLGeneralTaxTable,
                      BLSpecialDistrictTaxTable,
                      BLExemptionTaxTable,
                      BLSpecialFeeTaxTable,
                      BillParameterTable : TTable;
                      SDCodeDescList,
                      EXCodeDescList,
                      PropertyClassDescList,
                      GeneralRateList,
                      SDRateList,
                      SpecialFeeRateList : TList;
                      ArrearsMessage : TStringList) : Boolean;

const
  Topmarg = 4;  {blank lines at top of page}

var
  Quit, ValidEntry : Boolean;
  Index, I, J, RateIndex : Integer;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
  NAddrArray : NameAddrArray;
  TempEXCode : Str5;
  UniformPercentValue,
  Temprl, TempReal, STARSavings : Double;
  TempStr : Str20;
  EXAppliesArray : ExemptionAppliesArrayType;
  TempPtr : SDistTaxPtr;
  TempStr2 : String;
  CL1List,
  CL2List,
  CL3List,
  CL4List,
  CL5List,
  CL6List,
  CL7List : TStringList;
  BaseReportObject : TBaseReport;

begin
  Quit := False;

  SwisCodeTable.First;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;

  {create string list for printing parallel non-related data }
    {across the page; eg Name/addr info in cl1list, ex data }
    {in CL2List}

  CL1List := TStringList.Create;
  CL2List := TStringList.Create;
  CL3List := TStringList.Create;
  CL4List := TStringList.Create;
  CL5List := TStringList.Create;
  CL6List := TStringList.Create;
  CL7List := TStringList.Create;

  If (ReportObjectToUse = 'P')
    then BaseReportObject := ReportPrinter
    else BaseReportObject := ReportFiler;

  with BaseReportObject, BLHeaderTaxTable do
    begin
         {Load the tax data  for this parcel}

      LoadTaxesForParcel(SwisSBLKey, BLGeneralTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLExemptionTaxTable,
                         BLSpecialFeeTaxTable,
                         SDCodeDescList, EXCodeDescList,
                         GeneralRateList, SDRateList,
                         SpecialFeeRateList, GnTaxList,
                         SDTaxList, SpTaxList, ExTaxList, Quit);

      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('MS Serif', 10);

        {print the bill on the form}

        {SCROLL DOWN TO FIRST PRINT LINE}

      For I := 1 to TopMarg do
        Println('');

         {>>> TAX MAP            }

         {CHG03101999-2: Make the bill printing into a seperate DLL.}
         {Need to pass in formatted parcel ID since DLL will not have access to segment layouts.}

      Bold := True;
      ClearTabs;
      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}
      PrintLn(#9 + FormattedSwisSBLKey);

        {>>> PROP LOCATION      }

      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}
      Println(#9 + GetLegalAddressFromTable(BLHeaderTaxTable));

          {>>> DIMENSIONS      }

      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}

      If ((FieldByName('HstdAcreage').AsFloat > 0.0) or
          (FieldByName('NonHstdAcreage').AsFloat > 0.0))
        then Println(#9 + 'ACRES: ' +
                          FormatFloat(DecimalDisplay, (FieldByName('HstdAcreage').AsFloat) +
                                                      (FieldByName('NonHstdAcreage').AsFloat)))
        else Println(#9 + 'FRONTAGE: ' +
                          FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat) +
                          ', DEPTH: ' +
                          FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat)) ;

          {>>> PROPERTY CLASS }

      Println(#9 + FieldByName('PropertyClassCode').Text + ' - ' +
            UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                        PropertyClassDescList)));

          {>>> ROLL SECTION }

      Println(#9 + FieldByName('RollSection').Text);

          {>>> WARRANT DATE  }

      Println(#9 + BillParameterTable.FieldByName('WarrantDate').AsString);

          {>>> SPACES }

      For I := 1 to 2 do
       Println('  ');

     GetNameAddress(BLHeaderTaxTable, NAddrArray);

         {fill in clist1 with name addr info}

     For I := 1 to 6 do
       CL1List.Add(NaddrArray[I]);

       {First line is hdr for exemptions.}

     CL2List.Add('   ');
     CL3List.Add('   ');
     CL4List.Add('   ');

         {Now fill in exemptions}

      For I := 0 to (ExTaxList.Count - 1) do
        begin
          TempExCode := ExemptTaxPtr(ExTaxList[I])^.EXCode;
          EXAppliesArray := EXApplies(TempEXCode, False);

          If EXAppliesArray[EXSchool]
            then
              begin
               CL2List.Add(Take(10, ExemptTaxPtr(ExTaxList[I])^.Description));
               CL3List.Add(ExemptTaxPtr(ExTaxList[I])^.EXCode);
               CL4List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.SchoolAmount));

             end;  {If EXAppliesArray[EXSchool]}

        end;  {For I := 0 to (ExTaxList.Count - 1) do}

          {pad out rest of exemption columns to 6 lines to match Naddr clist}

      For I := (ExTaxList.Count) to 5 do
        begin
          CL2List.Add('   ');
          CL3List.Add('   ');
          CL4List.Add('   ');
        end;

         {>>> NAME/ADDR AND EXEMPTIONS >>>}

      ClearTabs;
      SetTab(1.3, pjLeft, 3.2, 0, BOXLINENone, 0);   {nAME/ADDR}
      SetTab(5.2, pjLeft, 1.0, 0, BOXLINENone, 0);   {EX DESCR}
      SetTab(6.3, pjLeft, 0.5, 0, BOXLINENone, 0);   {EX CODE}
      SetTab(7.0, pjRight, 1.0, 0, BOXLINENone, 0);   {eX amt}

      For I := 0 to 5 do
        Println(#9 + CL1List[I] +
                #9 + CL2List[I] +
                #9 + CL3List[I] +
                #9 + CL4List[I]);

       {>>> 3 SPACES }

      For I := 1 to 3 do
        Println('  ');

         {>>> STATE AID  }

      RateIndex := FindGeneralRate('C', FieldByName('SchoolDistCode').Text,
                                   GeneralRateList);

      ClearTabs;
      SetTab(1.0, pjRight, 1.5, 0, BOXLINENone, 0);   {sTATE AID}
      Println(#9 + FormatFloat(CurrencyNormalDisplay,
                               GeneralRatePointer(GeneralRateList[RateIndex])^.EstimatedStateAid));

        {>>> TAX YR, FISCAL YR  }

      ClearTabs;
      SetTab(1.0, pjRight, 1.5, 0, BOXLINENone, 0);   {tax year}
      SetTab(4.2, pjLeft, 1.5, 0, BOXLINENone, 0);   {fiscal year}
      Println(#9 + BillParameterTable.FieldByname('TaxYear').Text +
              #9 + BillParameterTable.FieldByName('FiscalYear').Text);

         {>>> BANK CODE AND BILLNO }

      Println(#9 + FieldByName('BankCode').Text + #9 +
                   DezeroOnLeft(FieldByName('BillNo').Text));

         {>>> ASSESSMENT ROLL DATE & NYS SCHL FINANCE CODE}
         {FXX08131998-2: For now, just get tax finance code from
                         school table so don't have to recalculate.}

      SchoolCodeTable.FindKey([FieldByName('SchoolDistCode').Text]);
      TempStr2 := SchoolCodeTable.FieldByName('TaxFinanceCode').Text;

      Println(#9 + BillParameterTable.FieldByName('AssessmentRollDate').Text +
              #9 + TempStr2{FieldByName('TaxFinanceCode').Text});

        {>>> 4 SPACES }

      For I := 1 to 4 do
        Println('  ');

           {>>> PRINT TAX LINE }

      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BOXLINENone, 0);   {purpose}
      SetTab(2.5, pjRight, 1.0, 0, BOXLINENone, 0);   {total levy}
      SetTab(3.8, pjRight, 0.5, 0, BOXLINENone, 0);   {% inc /dcr}
      SetTab(4.6, pjRight, 1.0, 0, BOXLINENone, 0);   {tax val}
      SetTab(5.7, pjRight, 1.0, 0, BOXLINENone, 0);   {tax rate}
      SetTab(6.8, pjRight, 1.2, 0, BOXLINENone, 0);   {tax amt}

      If (GnTaxList.Count > 0)
         then
           with GeneralTaxPtr(GnTaxList[0])^,
                GeneralRatePointer(GeneralRateList[RateIndex])^ do
             Println(#9 + Take(20, Description) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy) +
                     #9 + FormatFloat(DecimalDisplay,
                                      ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                  PriorTaxLevy)) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal) +
                     #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                     #9 + FormatFloat(DecimalDisplay, TaxAmount));

        {FXX08101998-1: Print the SDs if rs 9.}

      If ((SDTaxList.Count > 0) and
          (FieldByName('RollSection').Text = '9'))
        then
          For I := 0 to (SDTaxList.Count - 1) do
            with SDistTaxPtr(SDTaxList[I])^ do
              begin
                FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, Index);

                TaxRate := SDRatePointer(SDRateList[Index])^.HomesteadRate;

                TempPtr :=SDistTaxPtr(SDTaxList[I]);
                If (Roundoff(TaxRate, 0) > 0)
                  then Println(#9 + Take(20, Description) +
                               #9 + #9 + #9 + #9 +
                               #9 + FormatFloat(DecimalDisplay, SDAmount));

              end;  { with SDistTaxPtr(SDTaxList[I])^ do}

         {>>> 5 SPACES }
         {FXX07091998-5: Try 5 spaces instead of 4.}
         {FXX07131998-1: Go back to 4 spaces for new form.}

      For I := 1 to 4 do
        Println('  ');

         {>>> FULL MARKET VALUE }

         {FXX07061998-2: Get the uniform % of value from the swis code table.}

     SwisCodeTable.FindKey([FieldByName('SwisCode').Text]);

     UniformPercentValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
     TempReal := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                   FieldByName('NonHstdTotalVal').AsFloat),
                                  UniformPercentValue);

     ClearTabs;
     SetTab(0.3, pjLeft, 4.0, 0, BOXLINENone, 0);   {Full mkt Val}
     Println(#9 + 'Full Market Value - ' +
              BillParameterTable.FieldByName('FullMktValueDate').Text + ':   ' +
              FormatFloat(CurrencyNormalDisplay, TempReal));

         {>>> ASSESSED VALUE }

     Println(#9 + 'Assessed Value - ' +
              BillParameterTable.FieldByName('AssessmentRollDate').Text + ':  ' +
              FormatFloat(CurrencyNormalDisplay, (FieldByName('HstdTotalVal').AsFloat +
                                             FieldByName('NonHstdTotalVal').AsFloat)));

         {>>> UNIF % VALUE  & 1H/2h AMOUNTS}

      ClearTabs;
      SetTab(0.3, pjLeft, 4.0, 0, BOXLINENone, 0);   { uNIF % VAL}
      SetTab(5.8, pjLeft, 1.1, 0, BOXLINENone, 0);   { 1H TAX}
      SetTab(7.1, pjLeft, 1.1, 0, BOXLINENone, 0);   { 2H TAX}
      Println(#9 + 'Uniform Pct. of Value for Assessments: ' +
             FormatFloat(DecimalDisplay, UniformPercentValue) +
             #9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment1').AsFloat) +
             #9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment2').AsFloat));

        {>>> STAR AMT (If applicable) }

      If (GnTaxList.Count = 0)
        then STARSavings := 0
        else STARSavings := GeneralTaxPtr(GnTaxList[0])^.StarSavings;

      If (Roundoff(STARSavings, 2) > 0)
        then
          begin
            ClearTabs;
            SetTab(0.3, pjLeft, 4.0, 0, BOXLINENone, 0);   { star text}
            Println(#9 + 'Your tax savings this year resulting from the New York');
            Println(#9 + 'State school tax relief (STAR) program is: ' +
                         FormatFloat(DecimalDisplay, StarSavings));

         end
       else
         For I := 1 to 2 do
           Println('');

          {>>> TAX DUE DATES }

      ClearTabs;
      SetTab(5.8, pjLeft, 1.1, 0, BOXLINENone, 0);   { 1H DUE DATE}
      SetTab(7.1, pjLeft, 1.1, 0, BOXLINENone, 0);   { 2H DUE DATE}
      Println(#9 + CollectionLookupTable.FieldByName('PayDate1').Text + #9 +
                   CollectionLookupTable.FieldByName('PayDate2').Text );

        {>>> 5 SPACES }

      For I := 1 to 5 do
         Println('');

(*               PrintStub(Sender, BLHeaderTaxTable, SwisSBLKey, NAddrArray,
                FieldByName('TaxPayment2').AsFloat,
                CollectionLookupTable.FieldByName('PayDate2').Text); *)

        {FXX07301998-1: Have to print stubs not in subroutine because
                        of HP8000 print problem.}
        {Print stub for 2nd half.}

      ClearTabs;
      SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   { 2h stub sbl}
      Println(#9 + FormattedSwisSBLKey);

        {>>> 2 SPACES }

      For I := 1 to 2 do
        Println('');

         {>>> PROP LOCATION}

      ClearTabs;
      SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   {PROP LOC}
      Println(#9 + GetLegalAddressFromTable(BLHeaderTaxTable));

        {>>> BILL NO, BANK CODE}

      ClearTabs;
      SetTab(4.4, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      SetTab(6.6, pjLeft, 1.0, 0, BOXLINENone, 0);   {BANK CODE}
      Println(#9 + DezeroOnLeft(BLHeaderTaxTable.FieldByName('BillNo').Text) +
                   '   (' + Copy(FieldByName('SchoolDistCode').Text, 3, 4) + ')' +
              #9 + BLHeaderTaxTable.FieldByName('BankCode').Text);

          {>>> SPACE 1 LINE}

      Println('');

          {>>> AMOUNT DUE}

      ClearTabs;
      SetTab(1.2, pjRight, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment2').AsFloat));

        {>>> SPACE 1 LINE}

      Println('');

         {>>> NAME LINE 1}

      ClearTabs;
      SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + NAddrArray[1]);

         {>>> DATE DUE AND NAME LINE 2}

      ClearTabs;
      SetTab(1.2, pjRight, 1.0, 0, BOXLINENone, 0);   {DATE DUE}
      SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + CollectionLookupTable.FieldByName('PayDate2').Text +
              #9 + NAddrArray[2]);

          {>>> REST OF NAME DATA }

      ClearTabs;
      SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      For I := 3 to 6 do
        Println(#9 +  NAddrArray[I]);

       {>>> 7 SPACES }

      For I := 1 to 7 do
        Println('');

        {Print stub for 1st half.}

      ClearTabs;
      SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   { 2h stub sbl}
      Println(#9 + FormattedSwisSBLKey);

        {>>> 2 SPACES }

      For I := 1 to 2 do
        Println('');

         {>>> PROP LOCATION}

      ClearTabs;
      SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   {PROP LOC}
      Println(#9 + GetLegalAddressFromTable(BLHeaderTaxTable));

        {>>> BILL NO, BANK CODE}

      ClearTabs;
      SetTab(4.4, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      SetTab(6.6, pjLeft, 1.0, 0, BOXLINENone, 0);   {BANK CODE}
      Println(#9 + DezeroOnLeft(BLHeaderTaxTable.FieldByName('BillNo').Text) +
                   '   (' + Copy(FieldByName('SchoolDistCode').Text, 3, 4) + ')' +
              #9 + BLHeaderTaxTable.FieldByName('BankCode').Text);

          {>>> SPACE 1 LINE}

      Println('');

          {>>> AMOUNT DUE}

      ClearTabs;
      SetTab(1.2, pjRight, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment1').AsFloat));

        {>>> SPACE 1 LINE}

      Println('');

         {>>> NAME LINE 1}

      ClearTabs;
      SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + NAddrArray[1]);

         {>>> DATE DUE AND NAME LINE 2}

      ClearTabs;
      SetTab(1.2, pjRight, 1.0, 0, BOXLINENone, 0);   {DATE DUE}
      SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + CollectionLookupTable.FieldByName('PayDate1').Text +
              #9 + NAddrArray[2]);

          {>>> REST OF NAME DATA }

      ClearTabs;
      SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      For I := 3 to 6 do
        Println(#9 +  NAddrArray[I]);

      Newpage;

    end;  {with Sender as TBaseReport do}

  CL1List.Free;
  CL2List.Free;
  CL3List.Free;
  CL4List.Free;
  CL5List.Free;
  CL6List.Free;
  CL7List.Free;

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

  Result := Quit;

end;  {PrintOneBill}

{==================================================================}
Procedure TPrintMtPleasantSchoolBillsForm.ReportPrinterBeforePrint(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.325;
      SectionLeft := 0.2;
      SectionRight := PageWidth - 0.2;

      ClearTabs;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterBeforePrint}

{=========================================================================}
Procedure TPrintMtPleasantSchoolBillsForm.ReportPrinterPrint(Sender: TObject);

var
  Quit, Done, FirstTimeThrough, Found,
  FirstParcelPositionSet, ValidEntry : Boolean;
  Name, LANumber, LAStreet, BankCode, ZipCode, ZipPlus4Code : String;
  NumPrinted : LongInt;
  SwisSBLKey : Str26;
  FormattedSwisSBLKey : String;
  Index, I : Integer;
  ReportObjectToUse : Char;
  ArrearsMessage : TStringList;
  SchoolCode : Str6;
  TotalOwed : Extended;

begin
  Index := 1;
  Quit := False;
  NumPrinted := 0;

  ArrearsMessage := TStringList.Create;

  with ArrearsMemo do
    For I := 0 to (Lines.Count - 1) do
      ArrearsMessage.Add(Lines[I]);

  with Sender as TBaseReport do
    begin
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('Times Roman', 10);
    end;

  Done := False;
  FirstTimeThrough := True;

  ProgressDialog.UserLabelCaption := 'Printing Bills.';

     {FXX07061998-7: Start at the parcel they want to start at.}

  FirstParcelPositionSet := False;

    {CHG03161999-2: Print from the parcel list.}

  If LoadFromParcelList
    then ParcelListDialog.GetParcel(ParcelTable, Index)
    else
      begin
        case PrintOrderRadioGroup.ItemIndex of
          0 : If (Deblank(NameSBLEdit.Text) <> '')
                then
                  begin
                    SwisSBLKey := ConvertSwisDashDotToSwisSBL(NameSBLEdit.Text,
                                                              SwisCodeTable,
                                                              ValidEntry);
                    If not ValidEntry
                      then MessageDlg('The starting parcel ID entry was invalid.' + #13 +
                                      'Please try again.', mtError, [mbOK], 0);

                    BLHeaderTaxTable.FindNearest([Copy(SwisSBLKey, 7, 20)]);
                    FirstParcelPositionSet := True;

                  end;  {Parcel ID}

          1 : If (Deblank(NameSBLEdit.Text) <> '')
                then
                  begin
                    Name := NameSBLEdit.Text;
                    BLHeaderTaxTable.FindNearest([Name]);
                    FirstParcelPositionSet := True;
                  end;  {Name}

          2 : If ((Deblank(LANoEdit.Text) <> '') or
                  (Deblank(LATextEdit.Text) <> ''))
                then
                  begin
                    LANumber := Trim(LANoEdit.Text);
                    LAStreet := Trim(LATextEdit.Text);
                    BLHeaderTaxTable.FindNearest([LAStreet, LANumber]);
                    FirstParcelPositionSet := True;
                  end;  {Name}

          3 : If ((Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(NameSBLEdit.Text) <> ''))
                then
                  begin
                    ZipCode := Trim(StartDataEdit.Text);
                    ZipPlus4Code := Trim(ZipPlus4Edit.Text);

                    If (Deblank(NameSBLEdit.Text) = '')
                      then SwisSBLKey := ''
                      else SwisSBLKey := ConvertSwisDashDotToSwisSBL(NameSBLEdit.Text,
                                                                     SwisCodeTable,
                                                                     ValidEntry);
                    If not ValidEntry
                      then MessageDlg('The starting parcel ID entry was invalid.' + #13 +
                                      'Please try again.', mtError, [mbOK], 0);

                    BLHeaderTaxTable.FindNearest([ZipCode, ZipPlus4Code, Copy(SwisSBLKey, 7, 20)]);
                    FirstParcelPositionSet := True;

                  end;  {Zip\Parcel ID}

          4 : If ((Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(NameSBLEdit.Text) <> ''))
                then
                  begin
                    ZipCode := Trim(StartDataEdit.Text);
                    ZipPlus4Code := Trim(ZipPlus4Edit.Text);
                    Name := NameSBLEdit.Text;
                    BLHeaderTaxTable.FindNearest([ZipCode, ZipPlus4Code, Name]);
                    FirstParcelPositionSet := True;
                  end;  {Name}

          5 : If ((Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(LANoEdit.Text) <> '') or
                  (Deblank(LATextEdit.Text) <> ''))
                then
                  begin
                    ZipCode := Trim(StartDataEdit.Text);
                    ZipPlus4Code := Trim(ZipPlus4Edit.Text);
                    LANumber := Trim(LANoEdit.Text);
                    LAStreet := Trim(LATextEdit.Text);
                    BLHeaderTaxTable.FindNearest([ZipCode, ZipPlus4Code, LAStreet, LANumber]);
                    FirstParcelPositionSet := True;
                  end;  {Name}

          6 : If ((Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(NameSBLEdit.Text) <> ''))
                then
                  begin
                    BankCode := Trim(StartDataEdit.Text);

                    If (Deblank(NameSBLEdit.Text) = '')
                      then SwisSBLKey := ''
                      else SwisSBLKey := ConvertSwisDashDotToSwisSBL(NameSBLEdit.Text,
                                                                     SwisCodeTable,
                                                                     ValidEntry);

                    If not ValidEntry
                      then MessageDlg('The starting parcel ID entry was invalid.' + #13 +
                                      'Please try again.', mtError, [mbOK], 0);

                    BLHeaderTaxTable.FindNearest([BankCode, Copy(SwisSBLKey, 7, 20)]);
                    FirstParcelPositionSet := True;

                  end;  {Bank\Parcel ID}

          7 : If ((Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(NameSBLEdit.Text) <> ''))
                then
                  begin
                    BankCode := Trim(StartDataEdit.Text);
                    Name := NameSBLEdit.Text;
                    BLHeaderTaxTable.FindNearest([BankCode, Name]);
                    FirstParcelPositionSet := True;
                  end;  {Name}

          8 : If ((Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(LANoEdit.Text) <> '') or
                  (Deblank(LATextEdit.Text) <> ''))
                then
                  begin
                    BankCode := Trim(StartDataEdit.Text);
                    LANumber := Trim(LANoEdit.Text);
                    LAStreet := Trim(LATextEdit.Text);
                    BLHeaderTaxTable.FindNearest([BankCode, LAStreet, LANumber]);
                    FirstParcelPositionSet := True;
                  end;  {Name}

          end;  {case PrintOrderRadioGroup.ItemIndex of}

       If not FirstParcelPositionSet
         then BLHeaderTaxTable.First;

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
          else BLHeaderTaxTable.Next;

    If (BLHeaderTaxTable.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)) or
        (TrialRun and
         (NumPrinted = 1)))
      then Done := True;

    with BLHeaderTaxTable do
      begin
        SwisSBLKey := FieldByName('SwisCode').Text + FieldByName('SBLKey').Text;

          {Update the progress dialog.}

        case PrintOrderRadioGroup.ItemIndex of
          0 : ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          1 : ProgressDialog.Update(Self, FieldByName('Name1').Text);
          2 : ProgressDialog.Update(Self, RTrim(FieldByName('LegalAddr').Text) + ' ' +
                                          FieldByName('LegalAddrNo').Text);
          3 : ProgressDialog.Update(Self, FieldByName('Zip').Text + '\' +
                                          ConvertSwisSBLToDashDot(SwisSBLKey));
          4 : ProgressDialog.Update(Self, FieldByName('Zip').Text + '\' +
                                          FieldByName('Name1').Text);
          5 : ProgressDialog.Update(Self, FieldByName('Zip').Text + '\' +
                                          RTrim(FieldByName('LegalAddr').Text) + ' ' +
                                          FieldByName('LegalAddrNo').Text);
          6 : ProgressDialog.Update(Self, FieldByName('BankCode').Text + '\' +
                                          ConvertSwisSBLToDashDot(SwisSBLKey));
          7 : ProgressDialog.Update(Self, FieldByName('BankCode').Text + '\' +
                                          FieldByName('Name1').Text);
          8 : ProgressDialog.Update(Self, FieldByName('BankCode').Text + '\' +
                                          RTrim(FieldByName('LegalAddr').Text) + ' ' +
                                          FieldByName('LegalAddrNo').Text);
          9 : ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

        end;  {case Index of}

      end;  {with BLHeaderTaxTable do}

    If ((not Done) and
        (LoadFromParcelList or
         ParcelShouldBePrinted(BLHeaderTaxTable, SelectedSwisCodes)))
      then
        begin
          If LoadFromParcelList
            then
              begin
                  {Get the bill for this parcel in the list.}

                SwisSBLKey := ExtractSSKey(ParcelTable);

                If (CollectionType = 'SC')
                  then SchoolCode := ParcelTable.FieldByName('SchoolCode').Text
                  else SchoolCode := '999999';

                Found := BLHeaderTaxTable.FindKey([SchoolCode,
                                                   Take(6, SwisSBLKey),
                                                   ParcelTable.FieldByName('RollSection').Text,
                                                   Copy(SwisSBLKey, 7, 20)]);

                If not Found
                  then SystemSupport(020, BLHeaderTaxTable, 'Error finding bill for ' + SwisSBLKey + '.',
                                     UnitName, GlblErrorDlgBox);

                TotalOwed := BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat;

                NumBilled := NumBilled + 1;
                TotalBilled := TotalBilled + TotalOwed;

              end;  {If LoadFromParcelList}

          NumPrinted := NumPrinted + 1;

          FormattedSwisSBLKey := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey,7,20));

          If (TBaseReport(Sender).Name = 'ReportPrinter')
            then ReportObjectToUse := 'P'
            else ReportObjectToUse := 'F';

          PrintOneBill(ReportPrinter, ReportFiler, ReportObjectToUse,
                                       SwisSBLKey,
                                       FormattedSwisSBLKey,
                                       SchoolCodeTable,
                                       SwisCodeTable,
                                       CollectionLookupTable,
                                       BLHeaderTaxTable,
                                       BLGeneralTaxTable,
                                       BLSpecialDistrictTaxTable,
                                       BLExemptionTaxTable,
                                       BLSpecialFeeTaxTable,
                                       BillParameterTable,
                                       SDCodeDescList, EXCodeDescList,
                                       PropertyClassDescList,
                                       GeneralRateList, SDRateList,
                                       SpecialFeeRateList, ArrearsMessage);

        end;  {If ((not Done) and ...}

  until (Done or PrintingCancelled);

  ArrearsMessage.Free;

end;  {ReportPrinterPrint}

{===============================================================}
Procedure TPrintMtPleasantSchoolBillsForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TPrintMtPleasantSchoolBillsForm.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

  If (SelectedSwisCodes <> nil)
    then SelectedSwisCodes.Free;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}



end.