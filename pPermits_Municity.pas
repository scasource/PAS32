unit pPermits_Municity;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, RPFiler, RPBase, RPCanvas, RPrinter,
  Printrng, RPMemo, RPDBUtil, RPDefine, wwMemo, ComCtrls, ADODB;

type
  TPermits_MunicityForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    InactiveLabel: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    LandAVLabel: TLabel;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    FooterPanel: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel4: TPanel;
    StatusPanel: TPanel;
    Panel5: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label6: TLabel;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;
    EditLastChangeDate: TDBEdit;
    EditLastChangeByName: TDBEdit;
    MainListView: TListView;
    SetFocusTimer: TTimer;
    PrintDialog: TPrintDialog;
    TotalAVLabel: TLabel;
    ADO_MainQuery1: TADOQuery;
    qry_MunicityInspections: TADOQuery;
    tb_Sales: TTable;
    ADOQuery2: TADOQuery;
    Memo1: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrinterPrintHeader(Sender: TObject);
    procedure ReportFilerPrint(Sender: TObject);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure MainListViewClick(Sender: TObject);
    procedure MainListViewKeyPress(Sender: TObject; var Key: Char);
    procedure MainListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure MainListViewColumnClick(Sender: TObject;
      Column: TListColumn);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr, SwisSBLKey : String;
    ProcessingType, ColumnToSort : Integer;  {NextYear, ThisYear, History}

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    Procedure FillInMainListView;
    Procedure ShowSubform(_SwisSBLKey : String;
                          _PermitID : Integer;
                          _EditMode : String);
    Procedure InitializeForm;
  end;

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, Utilitys,
     GlblCnst, DataAccessUnit, PPermits_Municity_Subform,
     MunicityPermitReportPrintUnit, Preview, Prog;  {Report preview form}

{$R *.DFM}

{=====================================================================}
Procedure TPermits_MunicityForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{====================================================================}
Procedure TPermits_MunicityForm.SetFocusTimerTimer(Sender: TObject);

begin
  SetFocusTimer.Enabled := False;
  MainListView.SetFocus;
  SelectListViewItem(MainListView, 0);

end;  {SetFocusTimerTimer}

{====================================================================}
Procedure TPermits_MunicityForm.MainListViewCompare(    Sender : TObject;
                                                 Item1,
                                                 Item2 : TListItem;
                                                 Data : Integer;
                                             var Compare : Integer);

var
  Index, Int1, Int2 : Integer;

begin
  If _Compare(ColumnToSort, 0, coEqual)
    then
      begin
        try
          Int1 := StrToInt(Item1.Caption);
        except
          Int1 := 0;
        end;

        try
          Int2 := StrToInt(Item2.Caption);
        except
          Int2 := 0;
        end;

        If _Compare(Int1, Int2, coLessThan)
          then Compare := -1;

        If _Compare(Int1, Int2, coEqual)
          then Compare := 0;

        If _Compare(Int1, Int2, coGreaterThan)
          then Compare := 1;

      end
    else
      begin
        Index := ColumnToSort - 1;
        Compare := CompareText(Item1.SubItems[Index], Item2.SubItems[Index]);
      end;

end;  {MainListViewCompare}

{====================================================================}
Procedure TPermits_MunicityForm.MainListViewColumnClick(Sender : TObject;
                                                 Column : TListColumn);
begin
  ColumnToSort := Column.Index;
  (Sender as TCustomListView).AlphaSort;
end;

{====================================================================}
Procedure LoadDataForParcel(ADO_MainQuery1 : TADOQuery;
                            SwisSBLKey : String;
                            sPrintKey : String;
                            Memo1 : TMemo);

var
  sTempSwisSBL : String;

begin
    {FXX05162010(2.24.2.4)[I7347]: For Glen Cove, translate SBL to Glen Cove format.}

  If GlblUseGlenCoveFormatForCodeEnforcement
    then sTempSwisSBL := Copy(SwisSBLKey, 1, 6) +
                         ConvertFrom_PAS_To_GlenCoveTax_Building_SBL(Copy(SwisSBLKey, 7, 20))
    else sTempSwisSBL := SwisSBLKey;

  try
    WITH ADO_MainQuery1 DO BEGIN
      If Active Then
      Begin
        if (EOF or BOF) then First;
        Close;
      End; {If Active}

      with SQL do begin
        Clear;
        Add('SELECT Parcels.SwisSBLKey,');
        Add(' Parcels.Parcel_ID,');
        Add(' ParcelPermitMap.Parcel_ID AS MapParcelID,');
        Add(' ParcelPermitMap.Permit_ID,');
        Add(' Permits.Permit_ID AS PermitsPermitID,');
        Add(' Permits.PermitNo,');
        Add(' Permits.PermitDate,');
        Add(' Permits.ApplicaDate1,');
        Add(' Permits.CertOccupancyDate,');
        Add(' Permits.Description,');
        Add(' Permits.PermStatus,');
        Add(' Permits.PermitType,');
        Add(' Permits.ConstCost,');
        Add(' Permits.AssessorTempDate1,');
        Add(' Permits.AssessorTempDate2,');
        Add(' Permits.AssessorNextInspDate, ');
        Add(' Permits.AssessorOfficeClosed,');
        Add(' Permits.Deleted');
(*        Add(' Certificates.CertificateDate,');
        Add(' Certificates.CertificateType'); *)
        Add('FROM Parcels');
        Add(' INNER JOIN ParcelPermitMap ON (Parcels.Parcel_ID = ParcelPermitMap.Parcel_ID)');
        Add(' INNER JOIN Permits ON (ParcelPermitMap.Permit_ID = Permits.Permit_ID)');
        Add('WHERE ((Parcels.SwisSBLKey = ' + FormatSQLString(sTempSwisSBL) + ') or');
        Add('       (Parcels.PrintKey = ' + FormatSQLString(sPrintKey) + ')) and ');
        Add('      ((Permits.Deleted is null) or (Permits.Deleted = 0))');
        Add('ORDER BY Permits.PermitDate DESC');
      end; {with SQL do begin}
(*      Memo1.Lines.Assign(ADO_MainQuery1.SQL);
      Memo1.CopyToClipboard; *)

      Open;
    end; {With ADO_MainQuery1 Do Begin}
  except
  end; {try}
End;  {LoadDataForParcel}

{====================================================================}
Procedure TPermits_MunicityForm.FillInMainListView;

var
  sCertificateDate : String;
  fConstructionCost : Double;

begin
  LoadDataForParcel(ADO_MainQuery1, SwisSBLKey, ParcelTable.FieldByName('PrintKey').AsString, Memo1);
(*  Memo1.Lines.Assign(ADO_MainQuery1.SQL); *)

  MainListView.Enabled := False;
  MainListView.Items.Clear;

  with ADO_MainQuery1 do
    while (not EOF) do
      begin
(*        _ADOQuery(qry_MunicityInspections,
                  ['Select Inspections.SchedDate, Inspections.CloseDate',
                   'from Permits',
                   'Inner Join PermitInspectionMap on (Permits.Permit_ID = PermitInspectionMap.Permit_ID)',
                   'Inner Join Inspections on (Inspections.Inspection_ID = PermitInspectionMap.Inspection_ID)',
                   'where ((Permits.Permit_ID = ' + FieldByName('Permit_ID').AsString + ') and',
                   '       (Inspections.CloseDate > ' + FormatSQLString('1/1/1902') + '))',
                   'order by Inspections.SchedDate DESC']);

        sLastInspectionDate := '';

        If _Compare(qry_MunicityInspections.RecordCount, 0, coGreaterThan)
          then sLastInspectionDate := qry_MunicityInspections.FieldByName('SchedDate').AsString;

        _SetRange(tb_Sales, [SwisSBLKey, 0], [SwisSBLKey, 999], '', []);
        tb_Sales.Last;

        sLastSaleDate := '';

        with tb_Sales do
          If _Compare(RecordCount, 0, coGreaterThan)
            then
              begin
                Last;
                sLastSaleDate := FieldByName('SaleDate').AsString;
              end; *)

        sCertificateDate := GetMunicityCODateForPermit(ADOQuery2,
                                                       FieldByName('PermitsPermitID').AsString,
                                                       FieldByName('Parcel_ID').AsString);

        (*Memo1.Lines.Assign(AdoQuery2.SQL);
        ShowMessage('1'); *)

        If _Compare(sCertificateDate, coBlank)
          then sCertificateDate := FieldByName('CertOccupancyDate').AsString;

        try
          fConstructionCost := FieldByName('ConstCost').AsFloat;
        except
          fConstructionCost := 0;
        end;

          {CHG09182008-1(2.15.1.15): Add the Assessor's status to the front screen.}

        FillInListViewRow(MainListView,
                          [FieldByName('PermitsPermitID').AsInteger,
                           FieldByName('PermitNo').AsString,
                           DateDisplay(FieldByName('PermitDate').AsString),
                           DateDisplay(FieldByName('ApplicaDate1').AsString),
                           sCertificateDate,
                           FieldByName('PermitType').AsString,
                           FormatFloat(NoDecimalDisplay_BlankZero,
                                       fConstructionCost),
                           FieldByName('PermStatus').AsString,
                           BoolToChar_Blank_Y(not FieldByName('AssessorOfficeClosed').AsBoolean),
                           FieldByName('Description').AsString],
                           False);

        Next;

      end;  {while (not EOF) do}

  MainListView.Enabled := True;

  (*MainListViewColumnClick(MainListView, MainListView.Columns[0]); *)

end;  {FillInMainListView}

{====================================================================}
Procedure TPermits_MunicityForm.InitializeForm;

var
  Found : Boolean;

begin
  UnitName := 'pPermits_Municity';

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
       (*  If ((not ModifyAccessAllowed(FormAccessRights)) or
            _Compare(EditMode, emBrowse, coEqual))
          then
            begin
              NewButton.Enabled := False;
              DeleteButton.Enabled := False;
            end;   *)

        OpenTablesForForm(Self, ProcessingType);

        Found := _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey]);

        If not Found
          then SystemSupport(001, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        TitleLabel.Caption := 'Permits';
        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        YearLabel.Caption := GetTaxYrLbl;
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

        //MainQuery.DatabaseName := GlblBuildingSystemDatabaseName;
        ADO_MainQuery1.ConnectionString := 'FILE NAME=' + GlblDrive + ':' + GlblProgramDir + 'pasMunicity.udl';
        qry_MunicityInspections.ConnectionString := ADO_MainQuery1.ConnectionString;
        ADOQuery2.ConnectionString := ADO_MainQuery1.ConnectionString;
        FillInMainListView;

      end;  {If (Deblank(SwisSBLKey) <> '')}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  SetFocusTimer.Enabled := True;

end;  {InitializeForm}

{==============================================================}
Procedure TPermits_MunicityForm.ShowSubform(_SwisSBLKey : String;
                                     _PermitID : Integer;
                                     _EditMode : String);

begin
  try
    PermitsMunicityEditDialogForm := TPermitsMunicityEditDialogForm.Create(nil);

    PermitsMunicityEditDialogForm.InitializeForm(_SwisSBLKey, _PermitID, _EditMode);

    If (PermitsMunicityEditDialogForm.ShowModal <> idCancel)
      Then FillInMainListView;

  finally
    PermitsMunicityEditDialogForm.Free;
  end;

end;  {ShowSubform}

{==============================================================}
Procedure TPermits_MunicityForm.MainListViewClick(Sender: TObject);

var
  PermitID : Integer;
  _EditMode : String;

begin
  try
    PermitID := StrToInt(GetColumnValueForItem(MainListView, 0, -1));
  except
    PermitID := 0;
  end;

  If _Compare(PermitID, 0, coGreaterThan)
    then
      begin
        If (ModifyAccessAllowed(FormAccessRights) and
            _Compare(EditMode, emEdit, coEqual))
          then _EditMode := emEdit
          else _EditMode := emBrowse;

        ShowSubform(SwisSBLKey, PermitID, _EditMode);
        //FillInMainListView;
        SelectListViewItem(MainListView, PermitID);

      end;  {If _Compare(PermitID, 0, coGreaterThan)}

end;  {MainListViewClick}

{==============================================================}
Procedure TPermits_MunicityForm.MainListViewKeyPress(    Sender: TObject;
                                              var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        MainListViewClick(Sender);
      end;

end;  {MainListViewKeyPress}

{==============================================================}

Procedure TPermits_MunicityForm.PrintButtonClick(Sender: TObject);

var
  bQuit : Boolean;
  NewFileName : String;
  TempFile : File;

begin
  If PrintDialog.Execute
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, bQuit);
        ReportPrinter.Orientation := poLandscape;
        ReportFiler.Orientation := poLandscape;

        If PrintDialog.PrintToFile
          then
            begin
              NewFileName := GetPrintFileName(Self.Caption, True);
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

              end;  {If PrintRangeDlg.PreviewPrint}

            end  {They did not select preview, so we will go
                  right to the printer.}
          else ReportPrinter.Execute;

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{==============================================================}
Procedure TPermits_MunicityForm.CloseButtonClick(Sender: TObject);

{Note that the close button is a close for the whole
 parcel maintenance.}

{To close the whole parcel maintenance, we will once again use
 the base popup menu. We will simulate a click on the
 "Exit Parcel Maintenance" of the BasePopupMenu which will
 then call the Close of ParcelTabForm. See the locate button
 click above for more information on how this works.}

var
  I : Integer;

begin
    {Search for the name of the menu item that has "Exit"
     in it, and click it.}

  For I := 0 to (PopupMenu.Items.Count - 1) do
    If (Pos('Exit', PopupMenu.Items[I].Name) <> 0)
      then PopupMenu.Items[I].Click;

end;  {CloseButtonClick}

{====================================================================}
Procedure TPermits_MunicityForm.FormClose(    Sender: TObject;
                               var Action: TCloseAction);

begin
    {Close all tables here.}
  Try
    IF ADO_MainQuery1.Active THEN
    BEGIN
      if (ADO_MainQuery1.EOF or ADO_MainQuery1.BOF) then ADO_MainQuery1.First;
      ADO_MainQuery1.Close;
    END; {IF ADO_MainQuery1.Active}
  Except
  End; {Try}

  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}

{=============================================================================}
{===============   PRINTING LOGIC  ===========================================}
{=============================================================================}
Procedure TPermits_MunicityForm.ReportPrinterPrintHeader(Sender: TObject);

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
      SetFont('Times New Roman',12);
      Home;
      CRLF;
      Bold := True;
      PrintCenter('Building Permit Report', (PageWidth / 2));
      Bold := False;
      SetFont('Times New Roman', 12);
      CRLF;

      SectionTop := 1.4;
        {Print column headers.}

      Home;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('Times New Roman', 10);

        {parcel ID \ Name \ legal addr}
      ClearTabs;
      SetTab(0.3, pjLeft, 0.8, 0, BOXLINENone, 0);
      SetTab(1.1, pjLeft, 1.8, 0, BOXLINENone, 0);

      Bold := True;
      Print(#9 + 'Parcel ID: ');
      Bold := False;
      Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey));

      Bold := True;
      Print(#9 + 'Owner: ');
      Bold := False;
      Println(#9 + ParcelTable.FieldByName('Name1').AsString);

      Bold := True;
      Print(#9 + 'Legal Addr: ');
      Bold := False;
      Println(#9 + GetLegalAddressFromTable(ParcelTable));
      Println('');

      Bold := True;

      ClearTabs;
      SetTab(0.3, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);   {Permit #}
      SetTab(1.0, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);   {Permit date}
      SetTab(1.7, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);   {Application date}
      SetTab(2.4, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);   {C/O date}
      SetTab(3.1, pjCenter, 0.6, 5, BOXLINENOBOTTOM, 25);   {Construction Cost}
      SetTab(3.7, pjCenter, 0.6, 5, BOXLINENOBOTTOM, 25);   {Permit Status}
      SetTab(4.3, pjCenter, 1.0, 5, BOXLINENOBOTTOM, 25);   {Permit Type}
      SetTab(5.3, pjCenter, 5.4, 5, BOXLINENOBOTTOM, 25);   {Description}

      Println(#9 + 'Permit' +
              #9 + 'Permit' +
              #9 + 'Appl' +
              #9 + 'C\O' +
              #9 + 'Cost' +
              #9 + 'Permit' +
              #9 + 'Permit' +
              #9 + '');

      ClearTabs;
      SetTab(0.3, pjCenter, 0.7, 5, BOXLINENoTop, 25);   {Permit #}
      SetTab(1.0, pjCenter, 0.7, 5, BOXLINENoTop, 25);   {Permit date}
      SetTab(1.7, pjCenter, 0.7, 5, BOXLINENoTop, 25);   {Application date}
      SetTab(2.4, pjCenter, 0.7, 5, BOXLINENoTop, 25);   {C/O date}
      SetTab(3.1, pjCenter, 0.6, 5, BOXLINENoTop, 25);   {Construction Cost}
      SetTab(3.7, pjCenter, 0.6, 5, BOXLINENoTop, 25);   {Permit Status}
      SetTab(4.3, pjCenter, 1.0, 5, BOXLINENoTop, 25);   {Permit Type}
      SetTab(5.3, pjCenter, 5.4, 5, BOXLINENoTop, 25);   {Description}

      Println(#9 + 'Number' +
              #9 + 'Date' +
              #9 + 'Date' +
              #9 + 'Date' +
              #9 + 'Reptd' +
              #9 + 'Status' +
              #9 + 'Type' +
              #9 + 'Description');

      ClearTabs;
      Bold := False;
      SetTab(0.3, pjLeft, 0.7, 5, BOXLINEAll, 0);   {Permit #}
      SetTab(1.0, pjLeft, 0.7, 5, BOXLINEAll, 0);   {Permit date}
      SetTab(1.7, pjLeft, 0.7, 5, BOXLINEAll, 0);   {Application date}
      SetTab(2.4, pjLeft, 0.7, 5, BOXLINEAll, 0);   {C/O date}
      SetTab(3.1, pjRight, 0.6, 5, BOXLINEAll, 0);  {Construction Cost}
      SetTab(3.7, pjLeft, 0.6, 5, BOXLINEAll, 0);   {Permit Status}
      SetTab(4.3, pjLeft, 1.0, 5, BOXLINEAll, 0);   {Permit Type}
      SetTab(5.3, pjLeft, 5.4, 5, BOXLINEAll, 0);   {Description}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrintHeader}

{=============================================================================}
Procedure TPermits_MunicityForm.ReportFilerPrint(Sender: TObject);

var
  I : Integer;

begin
(*  ADO_MainQuery1.First;

  with Sender as TBaseReport, ADO_MainQuery1 do
    while (not EOF) do
      begin
        Println(#9 + FieldByName('PermitNo').AsString +
                #9 + FieldByName('PermitDate').AsString +
                #9 + FieldByName('ApplicaDate1').AsString +
                #9 + FieldByName('CertificateDate').AsString +
                #9 + FieldByName('ConstCost').AsString +
                #9 + FieldByName('PermStatus').AsString +
                #9 + Copy(FieldByName('PermitType').AsString, 1, 10) +
                #9 + FieldByName('Description').AsString);

        Next;

        If _Compare(LinesLeft, 4, coLessThan)
          then NewPage;

      end;  {while (not EOF) do} *)

  with Sender as TBaseReport do
    For I := 0 to (MainListView.Items.Count - 1) do
      begin
        Println(#9 + GetColumnValueForItem(MainListView, 1, I) +
                #9 + GetColumnValueForItem(MainListView, 2, I) +
                #9 + GetColumnValueForItem(MainListView, 3, I) +
                #9 + GetColumnValueForItem(MainListView, 4, I) +
                #9 + GetColumnValueForItem(MainListView, 6, I) +
                #9 + Copy(GetColumnValueForItem(MainListView, 7, I), 1, 6) +
                #9 + Copy(GetColumnValueForItem(MainListView, 5, I), 1, 10) +
                #9 + GetColumnValueForItem(MainListView, 9, I));

        If _Compare(LinesLeft, 4, coLessThan)
          then NewPage;

      end;  {For I := 0 to (MainListView.Items.Count - 1) do}

end;  {ReportFilerPrint}

{=============================================================================}

end.
