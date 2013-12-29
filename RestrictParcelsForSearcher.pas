unit RestrictParcelsForSearcher;

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
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPFiler,
  RPDefine, RPBase, RPCanvas, RPrinter;

type
  TTRestrictParcelsForSearcherViewForm = class(TForm)
    DataSource: TwwDataSource;
    RestrictedParcelTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    DBGrid: TwwDBGrid;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    RestrictedParcelTableSwisSBLKey: TStringField;
    RestrictedParcelTableOwner: TStringField;
    ParcelTable: TTable;
    NewButton: TBitBtn;
    DeleteButton: TBitBtn;
    RestrictedParcelTableLegalAddress: TStringField;
    PrintButton: TBitBtn;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    RestrictedParcelTableParcelID: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NewButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure RestrictedParcelTableCalcFields(DataSet: TDataSet);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Preview,
  Prog, PASTypes;

{$R *.DFM}

{========================================================}
Procedure TTRestrictParcelsForSearcherViewForm.InitializeForm;

begin
  UnitName := 'RestrictParcelsForSearcher';  {mmm}

  If (FormAccessRights = raReadOnly)
    then
      begin
        RestrictedParcelTable.ReadOnly := True;  {mmm}
        NewButton.Enabled := False;
        DeleteButton.Enabled := False;
      end;

  try
    ParcelTable.Open;
  except
    SystemSupport(001, ParcelTable, 'Error opening parcel table.',
                  UnitName, GlblErrorDlgBox);
  end;

  try
    RestrictedParcelTable.Open;
  except
    SystemSupport(002, RestrictedParcelTable, 'Error opening restricted parcel table.',
                  UnitName, GlblErrorDlgBox);
  end;

end;  {InitializeForm}

{===================================================================}
Procedure TTRestrictParcelsForSearcherViewForm.RestrictedParcelTableCalcFields(DataSet: TDataSet);

var
  SBLRec : SBLRecord;
  _Found : Boolean;

begin
  If ParcelTable.Active
    then
      begin
        with RestrictedParcelTable do
          FieldByName('ParcelID').Text := ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text);

        SBLRec := ExtractSwisSBLFromSwisSBLKey(RestrictedParcelTable.FieldByName('SwisSBLKey').Text);

        with SBLRec do
          _Found := FindKeyOld(ParcelTable,
                               ['TaxRollYr', 'SwisCode', 'Section',
                                'Subsection', 'Block', 'Lot', 'Sublot',
                                'Suffix'],
                               [GlblThisYear, SwisCode, Section, SubSection,
                                Block, Lot, Sublot, Suffix]);

        If _Found
          then
            with RestrictedParcelTable do
              begin
                FieldByName('Owner').Text := ParcelTable.FieldByName('Name1').Text;
                FieldByName('LegalAddress').Text := GetLegalAddressFromTable(ParcelTable);
              end;

      end;  {If ParcelTable.Open}

end;  {RestrictedParcelsTableCalcFields}

{===================================================================}
Procedure TTRestrictParcelsForSearcherViewForm.NewButtonClick(Sender: TObject);

var
  SwisSBLKey : String;

begin
  If ExecuteParcelLocateDialog(SwisSBLKey, True, False, 'Select Parcel to Restrict', False, nil)
    then
      with RestrictedParcelTable do
        try
          Append;
          FieldByName('SwisSBLKey').Text := SwisSBLKey;
          Post;
          Refresh;
        except
          SystemSupport(001, RestrictedParcelTable, 'Error inserting restricted parcel.',
                        UnitName, GlblErrorDlgBox);
        end;

end;  {NewButtonClick}

{===================================================================}
Procedure TTRestrictParcelsForSearcherViewForm.DeleteButtonClick(Sender: TObject);

begin
  with RestrictedParcelTable do
    If (MessageDlg('Are you sure that you want to remove parcel ' +
                   ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                   ' from the restricted list?',
                   mtConfirmation, [mbYes, mbNo], 0) = idYes)
      then
        try
          Delete;
        except
          SystemSupport(002, RestrictedParcelTable, 'Error deleting restricted parcel.',
                        UnitName, GlblErrorDlgBox);
        end;

end;  {DeleteButtonClick}

{===================================================================}
Procedure TTRestrictParcelsForSearcherViewForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;

begin
  If PrintDialog.Execute
    then
      begin
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

{===================================================================}
Procedure TTRestrictParcelsForSearcherViewForm.ReportPrintHeader(Sender: TObject);

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
      SetFont('Arial',12);
      Home;
      PrintCenter('Restricted Parcels Listing', (PageWidth / 2));
      SetFont('Times New Roman', 10);
      CRLF;
      CRLF;
      PrintLn('');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.2, 0, BoxLineBottom, 0);   {Parcel ID}
      SetTab(1.6, pjCenter, 2.0, 0, BoxLineBottom, 0);   {Owner}
      SetTab(3.7, pjCenter, 2.0, 0, BoxLineBottom, 0);   {Legal Address}

      Bold := True;
      Println(#9 + 'Parcel ID' +
              #9 + 'Owner' +
              #9 + 'Legal Address');
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BoxLineNone, 0);   {Parcel ID}
      SetTab(1.6, pjLeft, 2.0, 0, BoxLineNone, 0);   {Owner}
      SetTab(3.7, pjLeft, 2.0, 0, BoxLineNone, 0);   {Legal Address}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure TTRestrictParcelsForSearcherViewForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  ProgressDialog.UserLabelCaption := '';
  ProgressDialog.Start(GetRecordCount(RestrictedParcelTable), True, True);

  RestrictedParcelTable.DisableControls;

  with Sender as TBaseReport do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else RestrictedParcelTable.Next;

      If RestrictedParcelTable.EOF
        then Done := True;

      ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(RestrictedParcelTable.FieldByName('SwisSBLKey').Text));

      If (LinesLeft < 5)
        then NewPage;

      If not Done
        then
          with RestrictedParcelTable do
            Println(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                    #9 + FieldByName('Owner').Text +
                    #9 + FieldByName('LegalAddress').Text);

    until Done;

  RestrictedParcelTable.EnableControls;
  ProgressDialog.Finish;

end;  {ReportPrint}

{===================================================================}
Procedure TTRestrictParcelsForSearcherViewForm.FormClose(    Sender: TObject;
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