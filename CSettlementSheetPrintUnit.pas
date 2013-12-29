unit CSettlementSheetPrintUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, StdCtrls, Grids, DBGrids, DBTables, Wwdbigrd, Wwdbgrid, Buttons,
  RPCanvas, RPrinter, RPDefine, RPBase, RPFiler, Mask;

type
  TCertiorariSettlementForm = class(TForm)
    SortSettlementSheetTable: TTable;
    Label1: TLabel;
    SortSettlementSheetDataSource: TDataSource;
    SettlementGrid: TwwDBGrid;
    TotalRefundLabel: TLabel;
    Label2: TLabel;
    EditPetitioner: TEdit;
    EditLawyers: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    EditPropertyType: TEdit;
    Label5: TLabel;
    PrintButton: TBitBtn;
    CancelButton: TBitBtn;
    CertiorariTable: TTable;
    LawyerTable: TTable;
    PropertyClassTable: TTable;
    Label6: TLabel;
    EditSpecialTerms: TEdit;
    TaxRateTable: TTable;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    Label7: TLabel;
    EditDate: TMaskEdit;
    SwisCodeTable: TTable;
    AssessorsOfficeTable: TTable;
    SchoolCodeTable: TTable;
    Label8: TLabel;
    EditOwner: TEdit;
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure SettlementGridColExit(Sender: TObject);
    procedure SortSettlementSheetTableAfterEdit(DataSet: TDataSet);
    procedure SortSettlementSheetTableAfterPost(DataSet: TDataSet);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SortSettlementSheetTableBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    SwisSBLKey, UnitName : String;
    OrigCorrectedAssessment : LongInt;
    FillingGrid, CorrectedAssessmentChanged : Boolean;

    Procedure FillInCertiorariSettlementGrid;
    Function ComputeCertiorariRefund_OneLine(TaxYear : String;
                                             SwisCode : String;
                                             TaxableValue : LongInt;
                                             GeneralTaxType : String) : Double;
    Procedure ComputeCertiorariRefund_WholeGrid;
    Procedure InitializeForm;

  end;

  Procedure ExecuteSettlementSheetPrint(_SwisSBLKey : String);

var
  CertiorariSettlementForm: TCertiorariSettlementForm;

implementation

{$R *.DFM}

uses Utilitys, WinUtils, PASUtils, GlblVars, GlblCnst, Preview, PASTypes;

{===============================================================}
Procedure TCertiorariSettlementForm.FormKeyPress(    Sender: TObject;
                                                 var Key: Char);

begin
  If (Key = #13)
    then
      If not (ActiveControl is TwwDBGrid)
        then
          begin
           {not a grid so go to next control on form}
            Perform(WM_NEXTDLGCTL, 0, 0);
            Key := #0;
          end;

end;  {FormKeyPress}

{===============================================================}
Procedure TCertiorariSettlementForm.FillInCertiorariSettlementGrid;

var
  Done, FirstTimeThrough : Boolean;

begin
  FillingGrid := True;
  Done := False;
  FirstTimeThrough := True;
  CertiorariTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CertiorariTable.Next;

    If CertiorariTable.EOF
      then Done := True;

      {Make sure to not pick up closed years.}

    If ((not Done) and
        (Deblank(CertiorariTable.FieldByName('Disposition').Text) = ''))
      then
        begin
          with SortSettlementSheetTable do
            try
              Insert;
              FieldByName('TaxRollYr').Text := CertiorariTable.FieldByName('TaxRollYr').Text;
              FieldByName('CertiorariNumber').AsInteger := CertiorariTable.FieldByName('CertiorariNumber').AsInteger;

              try
                FieldByName('OriginalAssessment').AsInteger := CertiorariTable.FieldByName('CurrentTotalValue').AsInteger;
              except
                FieldByName('OriginalAssessment').AsInteger := 0;
              end;

              try
                FieldByName('CorrectedAssessment').AsInteger := CertiorariTable.FieldByName('GrantedTotalValue').AsInteger;
              except
                FieldByName('CorrectedAssessment').AsInteger := 0;
              end;

              try
                FieldByName('AssessmentReduction').AsInteger := FieldByName('OriginalAssessment').AsInteger -
                                                                FieldByName('CorrectedAssessment').AsInteger;
              except
                FieldByName('AssessmentReduction').AsInteger := 0;
              end;

                {CHG01152003-1: Let them include or exclude lines.  Default it so that settled ones
                                are not marked include.}

              If (FieldByName('AssessmentReduction').AsInteger = 0)
                then FieldByName('Include').AsBoolean := False
                else FieldByName('Include').AsBoolean := True;

              Post;
            except
              SystemSupport(001, SortSettlementSheetTable, 'Error posting to sort settlement table.',
                            UnitName, GlblErrorDlgBox);
            end;

        end;  {If ((not Done) and ...}

  until Done;

  FillingGrid := False;

end;  {FillInCertiorariSettlementGrid}

{===============================================================}
Function TCertiorariSettlementForm.ComputeCertiorariRefund_OneLine(TaxYear : String;
                                                                   SwisCode : String;
                                                                   TaxableValue : LongInt;
                                                                   GeneralTaxType : String) : Double;

var
  Done, FirstTimeThrough, UseThisRate : Boolean;

begin
  Result := 0;
  Done := False;
  FirstTimeThrough := True;

  SetRangeOld(TaxRateTable,
              ['TaxRollYr', 'CollectionType', 'CollectionNo', 'PrintOrder'],
              [TaxYear, 'MU', '1', '1'],
              [TaxYear, 'MU', '1', '99']);

  TaxRateTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else TaxRateTable.Next;

    If TaxRateTable.EOF
      then Done := True;

    If ((not Done) and
        (TaxRateTable.FieldByName('GeneralTaxType').Text = GeneralTaxType) and
        (Pos('POLICE', TaxRateTable.FieldByName('Description').Text) = 0))
      then
        begin
            {Make sure this swis is good.}

          UseThisRate := False;

          If (Length(TaxRateTable.FieldByName('SwisCode').Text) <= 4)
            then UseThisRate := True;

          If ((Length(TaxRateTable.FieldByName('SwisCode').Text) = 6) and
              (TaxRateTable.FieldByName('SwisCode').Text = SwisCode))
            then UseThisRate := True;

          If UseThisRate
            then
              try
                Result := (TaxableValue / 1000) * TaxRateTable.FieldByName('HomesteadRate').AsFloat;
                Result := Roundoff(Result, 2);
              except
                Result := 0;
              end;

        end;  {If not Done}

  until Done;

end;  {ComputeCertiorariRefund_OneLine}

{===============================================================}
Procedure TCertiorariSettlementForm.ComputeCertiorariRefund_WholeGrid;

var
  Done, FirstTimeThrough : Boolean;
  TotalRefund, TotalThisLine : Double;
  Bookmark : TBookmark;

begin
  FillingGrid := True;
  TotalRefund := 0;
  SortSettlementSheetTable.DisableControls;
  Done := False;
  FirstTimeThrough := True;

  Bookmark := SortSettlementSheetTable.GetBookmark;
  SortSettlementSheetTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortSettlementSheetTable.Next;

    If SortSettlementSheetTable.EOF
      then Done := True;

      {Compute the refund for this line.}
      {CHG01152003-1: Let them include or exclude lines.}
      {FXX01152003-2: If the assessment reduction is 0, then do not recompute - this was a taxable
                      value change and they enter the amounts manually.}

    If ((not Done) and
        SortSettlementSheetTable.FieldByName('Include').AsBoolean and
        (SortSettlementSheetTable.FieldByName('AssessmentReduction').AsInteger > 0))
      then
        begin
          with SortSettlementSheetTable do
            try
              TotalThisLine := ComputeCertiorariRefund_OneLine(FieldByName('TaxRollYr').Text,
                                                               Copy(SwisSBLKey, 1, 6),
                                                               FieldByName('AssessmentReduction').AsInteger,
                                                               'TO');

              Edit;
              FieldByName('TaxRefund').AsFloat := TotalThisLine;
              Post;
            except
              TotalThisLine := 0;
              SystemSupport(002, SortSettlementSheetTable, 'Error editing sort settlement line.',
                            UnitName, GlblErrorDlgBox);
            end;

          TotalRefund := TotalRefund + TotalThisLine;

        end;  {If not Done}

  until Done;

  SortSettlementSheetTable.EnableControls;
  SortSettlementSheetTable.GotoBookmark(Bookmark);

  TotalRefundLabel.Caption := FormatFloat(CurrencyDecimalDisplay, TotalRefund);
  FillingGrid := False;

end;  {ComputeCertiorariRefund_WholeGrid}

{===============================================================}
Procedure TCertiorariSettlementForm.SortSettlementSheetTableAfterEdit(DataSet: TDataSet);

begin
  OrigCorrectedAssessment := SortSettlementSheetTable.FieldByName('CorrectedAssessment').AsInteger;
end;

{===============================================================}
Procedure TCertiorariSettlementForm.SortSettlementSheetTableBeforePost(DataSet: TDataSet);

begin
  If not FillingGrid
    then
      begin
        CorrectedAssessmentChanged := True;

        with SortSettlementSheetTable do
          try
            FieldByName('AssessmentReduction').AsInteger := FieldByName('OriginalAssessment').AsInteger -
                                                            FieldByName('CorrectedAssessment').AsInteger;
          except
            FieldByName('AssessmentReduction').AsInteger := 0;
          end;

      end;  {If not FillingGrid}

end;  {SortSettlementSheetTableBeforePost}

{===============================================================}
Procedure TCertiorariSettlementForm.SortSettlementSheetTableAfterPost(DataSet: TDataSet);

begin
  If not FillingGrid
    then ComputeCertiorariRefund_WholeGrid;

end;  {SortSettlementSheetTableAfterPost}

{===============================================================}
Procedure TCertiorariSettlementForm.SettlementGridColExit(Sender: TObject);

{If they change the corrected assessment, then change the reduction
 amount and recalculate.}

begin
  If ((SortSettlementSheetTable.State = dsEdit) and
      (SettlementGrid.GetActiveField.FieldName = 'CorrectedAssessment') and
      (OrigCorrectedAssessment <> SortSettlementSheetTable.FieldByName('CorrectedAssessment').AsInteger))
    then
      begin
        with SortSettlementSheetTable do
          try
              {CHG02122004-1(2.07l): If the corrected and original assessments are now the same, then
                                     set the refund amount to 0.}

            If (FieldByName('OriginalAssessment').AsInteger =
                FieldByName('CorrectedAssessment').AsInteger)
              then
                begin
                  FieldByName('TaxRefund').AsFloat := 0;
                  MessageDlg('The tax refund for this certiorari item has been set to $0.' + #13 +
                             'If this settlement offer involves granting a new exemption,' + #13 +
                             'please manually calculate the amount and enter it in the tax refund column.',
                             mtInformation, [mbOK], 0);

                end;  {If (FieldByName('AssessmentReduction').AsInteger = 0)}

            Post;
          except
            SystemSupport(003, SortSettlementSheetTable, 'Error posting corrected assessment change.',
                          UnitName, GlblErrorDlgBox);
          end;

      end;  {If ((SortSettlementSheetTable.State = dsEdit) and ...}

end;  {SettlementGridColExit}

{===============================================================}
Procedure TCertiorariSettlementForm.InitializeForm;

var
  _Found : Boolean;

begin
  FillingGrid := False;
  CorrectedAssessmentChanged := False;
  SortSettlementSheetTable.EmptyTable;
  UnitName := 'CSettlementSheetPrintUnit';
  OpenTablesForForm(Self, NextYear);

  with SortSettlementSheetTable do
    begin
      TFloatField(FieldByName('OriginalAssessment')).DisplayFormat := CurrencyDisplayNoDollarSign;
      TFloatField(FieldByName('CorrectedAssessment')).DisplayFormat := CurrencyDisplayNoDollarSign;
      TFloatField(FieldByName('AssessmentReduction')).DisplayFormat := CurrencyDisplayNoDollarSign;
      TFloatField(FieldByName('TaxRefund')).DisplayFormat := DecimalEditDisplay;

    end;  {with SortSettlementSheetTable do}

  Caption := 'Settlement Sheet Print for ' + ConvertSwisSBLToDashDot(SwisSBLKey);

    {We will assume that the most recent cert year is open for now.}

  SetRangeOld(CertiorariTable, ['SwisSBLKey', 'TaxRollYr'],
              [SwisSBLKey, '1950'], [SwisSBLKey, '3999']);

  CertiorariTable.Last;

    {FXX01152003-1: The petitioner name shold come from PetitName1 instead.}

  EditPetitioner.Text := CertiorariTable.FieldByName('PetitName1').Text;

    {CHG01152003-2: Allow them to see and change the owner name.}

  EditOwner.Text := CertiorariTable.FieldByName('CurrentName1').Text;

  _Found := FindKeyOld(LawyerTable, ['Code'], [CertiorariTable.FieldByName('LawyerCode').Text]);

  If _Found
    then EditLawyers.Text := LawyerTable.FieldByName('Name1').Text
    else EditLawyers.Text := CertiorariTable.FieldByName('LawyerCode').Text;

  _Found := FindKeyOld(PropertyClassTable, ['MainCode'], [CertiorariTable.FieldByName('PropertyClassCode').Text]);

  If _Found
    then EditPropertyType.Text := PropertyClassTable.FieldByName('Description').Text
    else EditPropertyType.Text := CertiorariTable.FieldByName('PropertyClassCode').Text;

  EditSpecialTerms.Text := 'None';
  EditDate.Text := DateToStr(Date);

  FillInCertiorariSettlementGrid;

  ComputeCertiorariRefund_WholeGrid;

end;  {InitializeForm}

{===============================================================}
Procedure PrintLabel(Sender : TObject;
                     TempStr : String);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      Print(#9 + TempStr);
      Bold := False;
    end;  {with Sender as TBaseReport do}

end;  {PrintLabel}

{===============================================================}
Procedure TCertiorariSettlementForm.ReportPrint(Sender: TObject);

var
  TaxYear, SwisCode,
  SchoolName, AssessorsName, AttorneyName : String;
  _Found, Done, FirstTimeThrough : Boolean;
  Bookmark : TBookmark;
  TotalTaxRefund : Double;
  I : Integer;
  AssessmentYearControlTable : TTable;

begin
  AssessmentYearControlTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName,
                                                                       ThisYear);
  AssessorsName := AssessorsOfficeTable.FieldByName('AssessorName').Text;
  AttorneyName := AssessorsOfficeTable.FieldByName('AttorneyName').Text;
  CertiorariTable.Last;

  with Sender as TBaseReport do
    begin
      SetFont('Times New Roman', 12);
      ClearTabs;
      SetTab(0.3, pjLeft, 0.6, 0, BoxLineNone, 0);
      SetTab(1.0, pjLeft, 5.0, 0, BoxLineNone, 0);

      For I := 1 to 6 do
        Println('');

      PrintLabel(Sender, 'To:');
      Println(#9 + 'Supervisor and Town Board');

      PrintLabel(Sender, 'From:');
      Println(#9 + AttorneyName + ' and ' + AssessorsName);

      PrintLabel(Sender, 'Date:');
      Println(#9 + EditDate.Text);

      PrintLabel(Sender, 'Re:');
      Println(#9 + 'Certiorari');
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 8.1, 0, BoxLineNone, 0);
      Println('');
      Println(#9 + EditPetitioner.Text);
      Println(#9 + 'vs.');
      Println(#9 + 'TOWN OF RAMAPO');
      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 8.1, 0, BoxLineNone, 0);
      Println(#9 + 'We propose that the following certiorari matter be settled with the condition that no refunds will be made');
      Println(#9 + 'unless and until any and all tax delinquencies are satisfied.');
      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BoxLineNone, 0);
      SetTab(1.6, pjLeft, 5.0, 0, BoxLineNone, 0);

      PrintLabel(Sender, 'Tax Parcel:');
      Println(#9 + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)));

      PrintLabel(Sender, 'Old ID:');
      Println(#9 + ConvertSBLOnlyToOldDashDot(Copy(SwisSBLKey, 7, 20),
                                              AssessmentYearControlTable));

        {CHG01152003-2: Allow them to see and change the owner name.}

      PrintLabel(Sender, 'Owner:');
      Println(#9 + EditOwner.Text);

      PrintLabel(Sender, 'Prop Address:');
      Println(#9 + GetLegalAddressFromTable(CertiorariTable));

      SwisCode := Copy(SwisSBLKey, 1, 6);
      _Found := FindKeyOld(SwisCodeTable, ['SwisCode'], [SwisCode]);

      If _Found
        then
          begin
            PrintLabel(Sender, 'Village:');
            Println(#9 + SwisCodeTable.FieldByName('MunicipalityName').Text);
          end;

      PrintLabel(Sender, 'Prop Type:');
      Println(#9 + EditPropertyType.Text);

      Println('');
      Println('');

        {The refund grid.}

      Bold := True;
      ClearTabs;
      SetTab(1.0, pjCenter, 0.5, 0, BoxLineNone, 0);  {Cert Index}
      SetTab(1.6, pjCenter, 0.9, 0, BoxLineNone, 0);  {Tax Year}
      SetTab(2.6, pjCenter, 1.1, 0, BoxLineNone, 0);  {Original AV}
      SetTab(3.8, pjCenter, 1.1, 0, BoxLineNone, 0);  {Corrected AV}
      SetTab(5.0, pjCenter, 1.1, 0, BoxLineNone, 0);  {AV Reduction}
      SetTab(6.2, pjCenter, 1.3, 0, BoxLineNone, 0);  {Tax Refund}

      Println(#9 + 'Cert' +
              #9 + 'Tax' +
              #9 + 'Original' +
              #9 + 'Corrected' +
              #9 + 'Assessment' +
              #9 + 'Town Tax');

      ClearTabs;
      SetTab(1.0, pjCenter, 0.5, 0, BoxLineBottom, 0);  {Cert Index}
      SetTab(1.6, pjCenter, 0.9, 0, BoxLineBottom, 0);  {Tax Year}
      SetTab(2.6, pjCenter, 1.1, 0, BoxLineBottom, 0);  {Original AV}
      SetTab(3.8, pjCenter, 1.1, 0, BoxLineBottom, 0);  {Corrected AV}
      SetTab(5.0, pjCenter, 1.1, 0, BoxLineBottom, 0);  {AV Reduction}
      SetTab(6.2, pjCenter, 1.3, 0, BoxLineBottom, 0);  {Tax Refund}

      Println(#9 + 'Index' +
              #9 + 'Year' +
              #9 + 'Assessment' +
              #9 + 'Assessment' +
              #9 + 'Reduction' +
              #9 + 'Refund');

      Bold := False;
      ClearTabs;
      SetTab(1.0, pjLeft, 0.5, 0, BoxLineNone, 0);  {Cert Index}
      SetTab(1.6, pjLeft, 0.9, 0, BoxLineNone, 0);  {Tax Year}
      SetTab(2.6, pjRight, 1.1, 0, BoxLineNone, 0);  {Original AV}
      SetTab(3.8, pjRight, 1.1, 0, BoxLineNone, 0);  {Corrected AV}
      SetTab(5.0, pjRight, 1.1, 0, BoxLineNone, 0);  {AV Reduction}
      SetTab(6.2, pjRight, 1.3, 0, BoxLineNone, 0);  {Tax Refund}

      SortSettlementSheetTable.DisableControls;
      Done := False;
      FirstTimeThrough := True;
      TotalTaxRefund := 0;

      Bookmark := SortSettlementSheetTable.GetBookmark;
      SortSettlementSheetTable.First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SortSettlementSheetTable.Next;

        If SortSettlementSheetTable.EOF
          then Done := True;

          {Compute the refund for this line.}

        with SortSettlementSheetTable do
          If ((not Done) and
              FieldByName('Include').AsBoolean)
            then
              begin
                TotalTaxRefund := TotalTaxRefund +
                                  FieldByName('TaxRefund').AsFloat;
                TaxYear := FieldByName('TaxRollYr').Text + '/' +
                           IntToStr(FieldByName('TaxRollYr').AsInteger + 1);

                Println(#9 + FieldByName('CertiorariNumber').Text +
                        #9 + TaxYear +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         FieldByName('OriginalAssessment').AsFloat) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         FieldByName('CorrectedAssessment').AsFloat) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         FieldByName('AssessmentReduction').AsFloat) +
                        #9 + FormatFloat(CurrencyDecimalDisplay,
                                         FieldByName('TaxRefund').AsFloat));

              end;  {If ((not Done) and ...}

      until Done;

      SortSettlementSheetTable.EnableControls;
      SortSettlementSheetTable.GotoBookmark(Bookmark);

      ClearTabs;
      SetTab(4.1, pjLeft, 2.0, 0, BoxLineNone, 0);  {Corrected AV}
      SetTab(6.2, pjRight, 1.3, 0, BoxLineNone, 0);  {Tax Refund}

      Println(#9 + #9 + '--------------');
      Bold := True;
      Println(#9 + 'Total Refund of Town Taxes:' +
              #9 + FormatFloat(CurrencyDecimalDisplay,
                               TotalTaxRefund));
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BoxLineNone, 0);
      SetTab(1.6, pjLeft, 5.0, 0, BoxLineNone, 0);
      Println('');

      PrintLabel(Sender, 'Special Terms:');

      If (Deblank(EditSpecialTerms.Text) = '')
        then Println(#9 + 'None.')
        else Println(#9 + EditSpecialTerms.Text);

      Println('');
      Println('');
      ClearTabs;

      SchoolName := '';
      If (CertiorariTable.FieldByName('SchoolCode').Text = '392601')
        then SchoolName := 'Ramapo Central';
      If (CertiorariTable.FieldByName('SchoolCode').Text = '392602')
        then SchoolName := 'East Ramapo';

      SetTab(1.0, pjLeft, 8.0, 0, BoxLineNone, 0);
      Println(#9 + Trim(EditLawyers.Text) + ' know(s) of the above settlement and will present it to the');
      Println(#9 + SchoolName + ' School District for approval.');

      Println('');
      Println('');
      Println('');
      Println('');
      ClearTabs;
      SetTab(1.0, pjLeft, 2.0, 0, BoxLineTop, 0);
      SetTab(4.3, pjLeft, 2.0, 0, BoxLineTop, 0);
      Println(#9 + AssessorsName +
              #9 + AttorneyName);

      ClearTabs;
      SetTab(1.0, pjLeft, 2.0, 0, BoxLineNone, 0);
      SetTab(4.3, pjLeft, 2.0, 0, BoxLineNone, 0);
      Println(#9 + 'Assessor' +
              #9 + 'Town Attorney');

      Println('');
      Println('');

      ClearTabs;
      SetTab(0.5, pjLeft, 8.0, 0, BoxLineNone, 0);
      Println(#9 + 'NOTE: THIS RECOMMENDATION FOR SETTLEMENT INCLUDES ONLY REFUND DUE FROM');
      Println(#9 + '             THE TOWN OF RAMAPO.  ANY REFUNDS DUE FROM OTHER TAXING JURISDICTIONS');
      Println(#9 + '             ARE NOT REFLECTED IN THE ABOVE CALCULATIONS.');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{===============================================================}
Procedure TCertiorariSettlementForm.PrintButtonClick(Sender: TObject);

var
  NewFileName: String;
  Quit : Boolean;

begin
    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  If (SortSettlementSheetTable.State = dsEdit)
    then SortSettlementSheetTable.Post;

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                              False, Quit);

        If not Quit
          then
            begin
              GlblPreviewPrint := False;

                {If they want to preview the print (i.e. have it
                 go to the screen), then we need to come up with
                 a unique file name to tell the ReportFiler
                 component where to put the output.
                 Once we have done that, we will execute the
                 report filer which will print the report to
                 that file. Then we will create and show the
                 preview print form and give it the name of the
                 file. When we are done, we will delete the file
                 and make sure that we go back to the original
                 directory.}

                {FXX07221998-1: So that more than one person can run the report
                                at once, use a time based name first and then
                                rename.}

                {If they want to see it on the screen, start the preview.}

              If PrintDialog.PrintToFile
                then
                  begin
                    GlblPreviewPrint := True;
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    ReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      PreviewForm.FilePreview.ZoomFactor := 130;

                      ReportFiler.Execute;

                        {FXX09071999-6: Tell people that printing is starting and
                                        done.}

                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;
                    end;

                  end
                else ReportPrinter.Execute;

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{===============================================================}
Procedure ExecuteSettlementSheetPrint(_SwisSBLKey : String);

begin
  try
    CertiorariSettlementForm := TCertiorariSettlementForm.Create(nil);

    with CertiorariSettlementForm do
      begin
        SwisSBLKey := _SwisSBLKey;
        InitializeForm;
        ShowModal;
      end;

  finally
    CertiorariSettlementForm.Free;
  end;

end;  {ExecuteSettlementSheetPrint}






end.