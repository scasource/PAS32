unit Excodmnt;

interface

uses
  DBIProcs, SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, Mask, DBCtrls,
  Wwkeycb, DB, DBTables, Wwtable, Wwdatsrc, Printrng, Btrvdlg, Grids,
  DBGrids, DBLookup, RPBase, RPCanvas, RPrinter, Wwdbigrd, Wwdbgrid,
  TabNotBk, RPFiler, Pastypes, wwdblook, Wwdbdlg, RPDefine;

type
  TEXCodeForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    EXCodeDataSource: TwwDataSource;
    EXCodeTable: TwwTable;
    PrintRangeDlg: TPrintRangeDlg;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    ScrollBox1: TScrollBox;
    StatusBar: TPanel;
    EXCodeLookupTable: TwwTable;
    SwisCodeLookupTable: TwwTable;
    YearLabel: TLabel;
    Label2: TLabel;
    wwCalcMethodDBLookupCombo: TwwDBLookupCombo;
    wwCalcMethodTable: TwwTable;
    wwTotVerifyTable: TwwTable;
    wwCalcMethodTableTaxRollYr: TStringField;
    wwCalcMethodTableMainCode: TStringField;
    wwCalcMethodTableDescription: TStringField;
    wwTotVerifyTableTaxRollYr: TStringField;
    wwTotVerifyTableMainCode: TStringField;
    wwTotVerifyTableDescription: TStringField;
    wwTotVerDBLookupCombo: TwwDBLookupCombo;
    wwSWDBLookupCombo: TwwDBLookupCombo;
    ResidentialTypeLookupCombo: TwwDBLookupCombo;
    ResidentialTypeTable: TwwTable;
    Label4: TLabel;
    SwisCodeLookupTableMunicipalityName: TStringField;
    ParcelEXTable: TTable;
    OppositeYearEXCodeTable: TTable;
    SwisCodeLookupTableTaxRollYr: TStringField;
    SwisCodeLookupTableSwisCode: TStringField;
    SwisCodeLookupTableSWISShortCode: TStringField;
    Panel2: TPanel;
    Label6: TLabel;
    ExemptionCodeSearch: TwwIncrementalSearch;
    Panel3: TPanel;
    PrintButton: TBitBtn;
    ExitButton: TBitBtn;
    Panel4: TPanel;
    ExCodeDBGrid: TwwDBGrid;
    AddExemptionButton: TBitBtn;
    DeleteExemptionButton: TBitBtn;
    SaveExemptionButton: TBitBtn;
    procedure PrintButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReportPrinterPrintHeader(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure EXCodeTableBeforeDelete(DataSet: TDataset);
    procedure EXCodeTableAfterPost(DataSet: TDataset);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure EXCodeTableAfterInsert(DataSet: TDataSet);
    procedure EXCodeTableBeforeEdit(DataSet: TDataSet);
    procedure AddExemptionButtonClick(Sender: TObject);
    procedure DeleteExemptionButtonClick(Sender: TObject);
    procedure SaveExemptionButtonClick(Sender: TObject);
    procedure EXCodeTableBeforePost(DataSet: TDataSet);
    procedure OppositeYearEXCodeTableAfterEdit(DataSet: TDataSet);
    procedure OppositeYearEXCodeTableAfterPost(DataSet: TDataSet);
  private
    UnitName : String;  {For use with error dialog box.}
  public
    CodeInserted : Boolean;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    OriginalSTARAmount,
    OriginalFixedAmount, OriginalFixedPercent : Comp;
    slOriginalFieldValues : TStringList;
    lFieldTraceInformationList : TList;
    Procedure InitializeForm;  {Open the tables.}
  end;

implementation

{$R *.DFM}

uses
  Preview,   {Print preview form}
  Types,     {Constants, types}
  Utilitys,  {General utilities}
  PASUTILS, UTILEXSD,   {Pas-specific utilities}
  GlblVars,  {Global variables}
  WinUtils,  {Windows specific utilities}
  Prog, RTCalcul,
  GlblCnst;

{======================================================================}
Procedure TEXCodeForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{======================================================================}
Procedure TEXCodeForm.InitializeForm;

{Open the tables.}

var
  Quit : Boolean;

begin
  Quit := False;
  UnitName := 'EXCODMNT.PAS';
  slOriginalFieldValues := TStringList.Create;
  lFieldTraceInformationList := TList.Create;

    {If this is the history file, or they do not have read access,
     then we want to set the files to read only.
     We also want to set a filter to only include the year
     that they have selected for history.}

  If not ModifyAccessAllowed(FormAccessRights)
    then
      begin
        EXCodeTable.ReadOnly := True;
        AddExemptionButton.Enabled := False;
        DeleteExemptionButton.Enabled := False;
        SaveExemptionButton.Enabled := False;

      end;  {If not ModifyAccessAllowed(FormAccessRights)}

  OpenTablesForForm(Self, GlblProcessingType);

  If (GlblTaxYearFlg = 'H')
    then
      begin
        SetRangeForHistoryTaxYear(EXCodeTable, 'TaxRollYr', 'ExCode');
        SetRangeForHistoryTaxYear(EXCodeLookupTable, 'TaxRollYr', 'ExCode');
        SetRangeForHistoryTaxYear(SWISCodeLookupTable, 'TaxRollYr', 'SwisCode');

      end;  {If (GlblTaxYearFlg = 'H')}

    {Set a label in the upper right to indicate if they
     are doing this year, next year, or history.}

  YearLabel.Caption := GetTaxYrLbl;
  OpenTableForProcessingType(OppositeYearEXCodeTable, ExemptionCodesTableName,
                             NextYear, Quit);

end;  {InitializeForm}

{===================================================================}
Procedure TEXCodeForm.FormKeyPress(Sender: TObject;
                                        var Key: Char);

{Change carriage return into tab.}

begin
    {FXX02061998-2: Enter to tab for grids is controlled at the grid level.}

  If (Key = #13)
    then
      If (not ((ActiveControl is TDBGrid) or
               (ActiveControl is TwwDBGrid)))
        then
          begin
           {not a grid so go to next control on form}
            Perform(WM_NEXTDLGCTL, 0, 0);
            Key := #0;
          end;

end;  {FormKeyPress}

{===================================================================}
Procedure TEXCodeForm.AddExemptionButtonClick(Sender: TObject);

begin
  try
    EXCodeTable.Insert;
  except
  end;

end;  {AddExemptionButtonClick}

{===================================================================}
Procedure TEXCodeForm.DeleteExemptionButtonClick(Sender: TObject);

begin
  try
    If (MessageDlg('Are you sure you want to delete exemption ' +
                   EXCodeTable.FieldByName('EXCode').Text + '?',
                   mtConfirmation, [mbYes, mbNo], 0) = idYes)
      then EXCodeTable.Delete;
  except
  end;

end;  {DeleteExemptionButtonClick}

{===================================================================}
Procedure TEXCodeForm.SaveExemptionButtonClick(Sender: TObject);

begin
  If EXCodeTable.Modified
    then
      try
        EXCodeTable.Post;
      except
        SystemSupport(065, EXCodeTable, 'Error posting code ' +  EXCodeTable.FieldByName('EXCode').Text + '.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {SaveExemptionButtonClick}

{===================================================================}
Procedure TEXCodeForm.EXCodeTableAfterInsert(DataSet: TDataset);

{Put them in the code field after clicking insert.}

begin
  EXCodeDBGrid.SetActiveField('EXCodeTableExCode');
  EXCodeDBGrid.SetFocus;

end;  {EXCodeTableAfterInsert}

{================================================================}
Procedure TEXCodeForm.EXCodeTableBeforeDelete(DataSet: TDataset);

{If there are parcels with this exemption, don't let them delete it.}

var
  Found : Boolean;

begin
  Found := FindKeyOld(ParcelEXTable, ['ExemptionCode'],
                      [ExCodeTable.FieldByName('EXCode').Text]);

  If Found
    then
      begin
        MessageDlg('This exemption code can not be deleted because' + #13 +
                   'it is being used on one or more parcels.',
                   mtError, [mbOK], 0);
        Abort;
      end;

end;  {EXCodeTableBeforeDelete}

{=========================================================}
Procedure TEXCodeForm.EXCodeTableBeforeEdit(DataSet: TDataSet);

var
  I : Integer;

begin
    {CHG03282002-9: Remind them on change of STAR values to check coops.}

  If ((EXCodeTable.FieldByName('ExCode').Text = BasicSTARExemptionCode) or
      (EXCodeTable.FieldByName('ExCode').Text = EnhancedSTARExemptionCode))
    then OriginalSTARAmount := EXCodeTable.FieldByName('FixedAmount').AsFloat
    else OriginalSTARAmount := 0;

    {CHG03282002-10: Offer to recalc exemptions and roll totals due
                     to exemption change.}

  OriginalFixedAmount := EXCodeTable.FieldByName('FixedAmount').AsFloat;
  OriginalFixedPercent := EXCodeTable.FieldByName('FixedPercentage').AsFloat;

    {CHG07272008-1(2.15.1.1): Add additional auditing.}

  CreateFieldValuesAndLabels(Self, EXCodeTable, lFieldTraceInformationList);

  slOriginalFieldValues.Clear;

  with EXCodeTable do
    For I := 0 to (FieldCount - 1) do
      slOriginalFieldValues.Add(Fields[I].AsString);

end;  {EXCodeTableBeforeEdit}

{===============================================================}
Procedure TEXCodeForm.EXCodeTableBeforePost(DataSet: TDataSet);

begin
  If ((ExCodeTable.State = dsInsert) and
      FindKeyOld(EXCodeLookupTable, ['EXCode'], [EXCodeTable.FieldByName('EXCode').Text]))
    then
      begin
        MessageDlg('Exemption ' + EXCodeTable.FieldByName('EXCode').Text + ' already exists.' + #13 +
                   'Please change the code.', mtError, [mbOK], 0);
        Abort;
      end;

    {FXX04232009-6[D767]: Warn user if they do not enter a calc method on a new exemption.}

  If ((ExCodeTable.State = dsInsert) and
      _Compare(ExCodeTable.FieldByName('CalcMethod').AsString, coBlank))
    then MessageDlg('Exemption ' + EXCodeTable.FieldByName('EXCode').AsString + ' does not have a calculation method.' + #13 +
                    'Please verify this.', mtWarning, [mbOK], 0);

end;  {EXCodeTableBeforePost}

{===============================================================}
Procedure TEXCodeForm.EXCodeTableAfterPost(DataSet: TDataset);

{FXX02282000-2: Move to next year also, if want.}

var
  TempStr, sFieldName : String;
  I : Integer;
  Quit, ExemptionsRecalculated, Found : Boolean;

begin
  Quit := False;
  ExemptionsRecalculated := False;

    {CHG07272008-1(2.15.1.1): Add additional auditing.}

  RecordChanges(Self, 'Exemption Code', EXCodeTable, EXCodeTable.FieldByName('EXCode').AsString,
                lFieldTraceInformationList);

    {CHG03282002-10: Offer to recalc exemptions and roll totals due
                     to exemption change.}

  If ((not CodeInserted) and
      ((Roundoff(OriginalFixedAmount, 0) <>
        Roundoff(EXCodeTable.FieldByName('FixedAmount').AsFloat, 0)) or
       (Roundoff(OriginalFixedPercent, 0) <>
        Roundoff(EXCodeTable.FieldByName('FixedPercentage').AsFloat, 0))))
    then
      begin
        If (MessageDlg('The exemptions and roll totals must be recalculated' + #13 +
                       'due to a change in exemption setup.' + #13 +
                       'Do you want to recalculate now?' + #13 +
                       'If you do not, you will need to do it manually later.',
                       mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            begin
              AddToTraceFile('', 'Exemption Code',
                             'Recalculate?', 'EX Recalculate', 'Accepted', Time,
                             ExCodeTable);
              ExemptionsRecalculated := True;
              ProgressDialog.Start(1, True, True);
              RecalculateAllExemptions(Self, ProgressDialog,
                                       GlblProcessingType, GetTaxRlYr, True, Quit);

              If not Quit
                then CreateRollTotals(GlblProcessingType, GetTaxRlYr, ProgressDialog, Self,
                                      False, True);

            end  {If (MessageDlg('The exemptions ...}
          else AddToTraceFile('',
                              'Exemption Code',
                              'Recalculate?',
                              'EX Recalculate', 'Denied', Time,
                              ExCodeTable);


      end;  {If ((not CodeInserted) and ...}

  If CodeInserted
    then TempStr := 'Do you want this exemption to also be on the ' + GlblNextYear + ' roll?'
    else TempStr := 'Do you want this exemption code change to appear on the ' + GlblNextYear + ' roll?';

  If ((GlblProcessingType = ThisYear) and
      (MessageDlg(TempStr, mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then
      begin
        Found := FindKeyOld(OppositeYearEXCodeTable, ['EXCode'],
                            [EXCodeTable.FieldByName('EXCode').Text]);

          {Delete and readd the opposite year record.}
          {FXX07272008-1(2.15.1.1): Problem of dmaged NY ex code table when updating TY.}

(*        If Found
          then OppositeYearEXCodeTable.Delete;

        CopyTable_OneRecord(EXCodeTable, OppositeYearEXCodeTable, ['TaxRollYr'], [GlblNextYear]); *)

        If Found
          then
            with OppositeYearEXCodeTable do
              try
                Edit;

                For I := 0 to (Fields.Count - 1) do
                  begin
                    sFieldName := Fields[I].FieldName;
                    FieldByName(sFieldName).AsString := EXCodeTable.FieldByName(sFieldName).AsString;
                  end;

                FieldByName('TaxRollYr').AsString := GlblNextYear;
                Post;

              except
                Cancel;
              end;

        If (ExemptionsRecalculated and
            (not Quit))
          then
            begin
              MessageDlg('The Next Year exemptions and roll totals will now be recalculated.',
                         mtInformation, [mbOK], 0);

              ProgressDialog.Start(1, True, True);
              RecalculateAllExemptions(Self, ProgressDialog,
                                       NextYear, GlblNextYear, True, Quit);

              If not Quit
                then CreateRollTotals(NextYear, GlblNextYear, ProgressDialog, Self,
                                      False, True);

            end;  {If (MessageDlg('The exemptions ...}

      end;  {If ((GlblProcessingType = ThisYear) and ...}

    {CHG03282002-9: Remind them on change of STAR values to check coops.}

  If ((Roundoff(OriginalSTARAmount, 0) > 0) and
      (Roundoff(OriginalSTARAmount, 0) <>
       Roundoff(EXCodeTable.FieldByName('FixedAmount').AsFloat, 0)))
    then
      begin
        If (EXCodeTable.FieldByName('ExCode').Text = BasicSTARExemptionCode)
          then TempStr := 'basic';

        If (EXCodeTable.FieldByName('ExCode').Text = EnhancedSTARExemptionCode)
          then TempStr := 'enhanced';

        MessageDlg('The ' + TempStr + ' STAR value has changed.' + #13 +
                   'Please note that the STAR exemption amount is not automatically ' + #13 +
                   'recalculated for cooperatives and parcels in the 400 property class.' + #13 +
                   'Please recompute these amounts manually and enter them.',
                   mtInformation, [mbOK], 0);

      end;  {If ((Roundoff(OriginalSTARAmount, 0) > 0) and ...}

end;  {EXCodeTableAfterPost}

{===================================================================}
Procedure TEXCodeForm.OppositeYearEXCodeTableAfterEdit(DataSet: TDataSet);

var
  I : Integer;

begin
    {CHG07272008-1(2.15.1.1): Add additional auditing.}

  CreateFieldValuesAndLabels(Self, OppositeYearEXCodeTable, lFieldTraceInformationList);

  slOriginalFieldValues.Clear;

  with OppositeYearEXCodeTable do
    For I := 0 to (FieldCount - 1) do
      slOriginalFieldValues.Add(Fields[I].AsString);

end;  {OppositeYearEXCodeTableAfterEdit}

{===================================================================}
Procedure TEXCodeForm.OppositeYearEXCodeTableAfterPost(DataSet: TDataSet);

begin
    {CHG07272008-1(2.15.1.1): Add additional auditing.}

  RecordChanges(Self, 'Exemption Code', EXCodeTable,
                OppositeYearEXCodeTable.FieldByName('EXCode').AsString,
                lFieldTraceInformationList);

end;  {OppositeYearEXCodeTableAfterPost}

{===================================================================}
Procedure TEXCodeForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;

begin
    {First check to see if they need to post any changes.}

  If EXCodeTable.Modified
    then
      try
        EXCodeTable.Post;
      except
        If not RecordIsLocked(EXCodeTable)
          then SystemSupport(005, EXCodeTable, 'Error Attempting to Post.',
                             UnitName, GlblErrorDlgBox);
      end;

    {Now do the actual printing.}

  If PrintRangeDlg.Execute
    then
      begin
        If PrintRangeDlg.PreviewPrint
          then
            begin
              NewFileName := GetPrintFileName(Caption, True);
              ReportFiler.FileName := NewFileName;

              try
                PreviewForm := TPreviewForm.Create(self);
                PreviewForm.FilePrinter.FileName := NewFileName;
                PreviewForm.FilePreview.FileName := NewFileName;

                ReportFiler.Execute;
                PreviewForm.ShowModal;
              finally
                PreviewForm.Free;

                  {Now delete the file.}
                try
                  AssignFile(TempFile, NewFileName);
                  OldDeleteFile(NewFileName);
                finally
                  {We don't care if it does not get deleted, so we won't put up an
                   error message.}

                  ChDir(GlblProgramDir);
                end;

              end;

            end
          else ReportPrinter.Execute;

      end;  {If PrintRangeDlg.Execute}

end;  {PrintButtonClick}

{===================================================================}
Procedure TEXCodeForm.ExitButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TEXCodeForm.FormCloseQuery(    Sender: TObject;
                                     var CanClose: Boolean);


{If there are any changes, let's ask them if they want to save
 them (or cancel).}

begin
    {First see if anything needs to be saved. In order to
     determine if there are any changes, we need to sychronize
     the fields with what is in the DB edit boxes. To do this,
     we call the UpdateRecord. Then, if there are any changes,
     the Modified flag will be set to True.}

  If (EXCodeTable.State in [dsInsert, dsEdit])
    then EXCodeTable.UpdateRecord;

  If (EXCodeTable.Modified and
      (EXCodeTable.State in [dsInsert, dsEdit]))
    then
      try
        EXCodeTable.Post;
      except
        CanClose := False;
        SystemSupport(006, EXCodeTable, 'Error Attempting to Post.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {FormCloseQuery}

{===================================================================}
Procedure TEXCodeForm.FormClose(    Sender: TObject;
                                var Action: TCloseAction);

{Note that if we get here, we are definately closing the form
 since the CloseQuery event is called first. In CloseQuery, if
 there are any modifications, they have a chance to cancel
 then.}

begin
  FreeTList(lFieldTraceInformationList, SizeOf(FieldTraceInformationRecord));
  slOriginalFieldValues.Free;
  
    {Close all tables.}

  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

{=============================================================================}
{===============   PRINTING LOGIC  ===========================================}
{=============================================================================}
Procedure TEXCodeForm.ReportPrinterPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Arial',14);
      Home;
      PrintCenter('Exemption Codes Listing', (PageWidth / 2));
      SetFont('Times New Roman', 12);
      CRLF;
      CRLF;
      Print('For Codes: ');

      with PrintRangeDlg do
        If PrintAllCodes
          then Println('All')
          else
            begin
              Print(StartRange + ' to ');

              If PrintToEndOfCodes
                then Println('End')
                else Println(EndRange);

            end;  {else of If PrintAllCodes}

      Bold := True;
      Println('');
      ClearTabs;
      SetTab(0.3, pjLeft, 0.4, 0, BOXLINENONE, 0);   {SD code}
      SetTab(0.8, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Description}
      SetTab(3.4, pjLeft,  0.4, 0, BOXLINENONE, 0);   {Expir Date}
      SetTab(3.9, pjLeft,  0.4, 0, BOXLINENONE, 0);   {Calc method}
      SetTab(4.4, pjLeft,  0.4, 0, BOXLINENONE, 0);   {Amt Verif}
      SetTab(4.9, pjLeft,  0.4, 0, BOXLINENONE, 0);   {AdValorum}
      SetTab(5.4, pjLeft,  0.4, 0, BOXLINENONE, 0);   {spcl Asd }
      SetTab(5.9, pjLeft,  0.4, 0, BOXLINENONE, 0);   {490}
      SetTab(6.4, pjLeft,  0.4, 0, BOXLINENONE, 0);   {562}
      SetTab(6.9, pjLeft,  0.4, 0, BOXLINENONE, 0);   {Fixed Amt}
      SetTab(7.5, pjLeft,  0.5, 0, BOXLINENONE, 0);   {Fixed Percent}

      Print(#9 + '');
      Print(#9 + '');
      Print(#9 + 'Expr');
      Print(#9 + 'Calc');
      Print(#9 + 'Amt');
      Print(#9 + 'Ad');
      Print(#9 + 'Spcl');
      Print(#9 + 'Sct ');
      Print(#9 + 'Chp');
      Print(#9 + 'Fxd');
      Print(#9 + 'Fxd');
      Println('');

         {DO UNDERLINE}
      ClearTabs;
      SetTab(0.3, pjLeft, 0.4 ,0, BOXLINEBOTTOM, 0);   {SD code}
      SetTab(0.8, pjLeft, 2.0, 0, BOXLINEBOTTOM, 0);   {Description}
      SetTab(3.4, pjLeft,  0.4, 0, BOXLINEBOTTOM, 0);   {Expir Date}
      SetTab(3.9, pjLeft,  0.4, 0, BOXLINEBOTTOM, 0);   {Calc method}
      SetTab(4.4, pjLeft,  0.4, 0, BOXLINEBOTTOM, 0);   {Amt Verif}
      SetTab(4.9, pjLeft,  0.4, 0, BOXLINEBOTTOM, 0);   {AdValorum}
      SetTab(5.4, pjLeft,  0.4, 0, BOXLINEBOTTOM, 0);   {spcl Asd }
      SetTab(5.9, pjLeft,  0.4, 0, BOXLINEBOTTOM, 0);   {490}
      SetTab(6.4, pjLeft,  0.4, 0, BOXLINEBOTTOM, 0);   {562}
      SetTab(6.9, pjLeft,  0.4, 0, BOXLINEBOTTOM, 0);   {Fixed Amt}
      SetTab(7.5, pjLeft,  0.5, 0, BOXLINEBOTTOM, 0);   {Fixed Percent}

      Print(#9 + 'Code');
      Print(#9 + 'Description');
      Print(#9 + 'Dte');
      Print(#9 + 'Met');
      Print(#9 + 'Ver');
      Print(#9 + 'Val');
      Print(#9 + 'Asd');
      Print(#9 + '490');
      Print(#9 + '562');
      Print(#9 + 'Amt');
      Print(#9 + 'Pct');
      Println('');

      SectionTop := 1.25;
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 0.4, 0, BOXLINENONE, 0);   {SD code}
      SetTab(0.8, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Description}
      SetTab(3.4, pjLeft,  0.4, 0, BOXLINENONE, 0);   {Expir Date}
      SetTab(3.9, pjLeft,  0.4, 0, BOXLINENONE, 0);   {Calc method}
      SetTab(4.4, pjLeft,  0.4, 0, BOXLINENONE, 0);   {Amt Verif}
      SetTab(4.9, pjLeft,  0.4, 0, BOXLINENONE, 0);   {AdValorum}
      SetTab(5.4, pjLeft,  0.4, 0, BOXLINENONE, 0);   {spcl Asd }
      SetTab(5.9, pjLeft,  0.4, 0, BOXLINENONE, 0);   {490}
      SetTab(6.4, pjLeft,  0.4, 0, BOXLINENONE, 0);   {562}
      SetTab(6.9, pjLeft,  0.4, 0, BOXLINENONE, 0);   {Fixed Amt}
      SetTab(7.5, pjLeft,  0.5, 0, BOXLINENONE, 0);   {Fixed Percent}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrintHeader}

{==============================================================================}
Procedure TEXCodeForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;

  If PrintRangeDlg.PrintAllCodes
    then EXCodeLookupTable.First
    else FindNearestOld(EXCodeLookupTable, ['EXCode'], [PrintRangeDlg.StartRange]);

  with Sender as TBaseReport do
    begin
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else EXCodeLookupTable.Next;

        with PrintRangeDlg do
          If ((not (PrintAllCodes or PrintToEndOfCodes)) and
              (EXCodeLookupTable.FieldByName('ExCode').Text > EndRange))
            then Done := True;

        If EXCodeLookupTable.EOF
          then Done := True;

          {FXX02052002-1: Remove wholly exempt flag from the report - it
                          is not used.}

        If not Done
          then
            with EXCodeLookupTable do
                Println(#9 + FieldByName('ExCode').Text +
                        #9 + FieldByName('Description').Text +
                        #9 + FieldByName('ExpirationDateReqd').Text +
                        #9 + FieldByName('CalcMethod').Text +
                        #9 + FieldByName('AmtVerification').Text +
                        #9 + FieldByName('AdValorum').Text +
                        #9 + FieldByName('ApplySpclAssessmentD').Text +
                        #9 + FieldByName('Section490').Text +
                        #9 + FieldByName('ApplyChap562').Text +
                        #9 + FieldByName('FixedAmount').Text +
                        #9 + FieldByName('FixedPercentage').Text);

                  {Update the status bar.}

        StatusBar.Caption := 'Printing Code: ' + EXCodeLookupTable.FieldByName('ExCode').Text;
        StatusBar.Repaint;

        If (LinesLeft <= 5)
          then Newpage;

      until Done;

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerPrint}

end.








