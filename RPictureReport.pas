unit RPictureReport;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, wwdblook,
  TabNotBk, Types, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Progress,
  RPTXFilr, ComCtrls, Math, Mask;

type
  TPictureReportForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    Label11: TLabel;
    Label12: TLabel;
    Panel2: TPanel;
    PictureTable: TTable;
    SchoolCodeTable: TTable;
    SwisCodeTable: TTable;
    ParcelTable: TTable;
    PropertyClassTable: TTable;
    Panel3: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    PageControl1: TPageControl;
    OptionsTabSheet: TTabSheet;
    OptionsGroupBox: TGroupBox;
    CreateParcelListCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    ShowParcelsWithoutPicturesCheckBox: TCheckBox;
    ShowParcelsWithPicturesCheckBox: TCheckBox;
    IncludeCondominiumsCheckBox: TCheckBox;
    PrintParcelDetailsCheckBox: TCheckBox;
    DateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    PrintOrderRadioGroup: TRadioGroup;
    Swis_School_TabSheet: TTabSheet;
    Label9: TLabel;
    Label18: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    PropertyClassTabSheet: TTabSheet;
    PropertyClassListBox: TListBox;
    Panel8: TPanel;
    Label1: TLabel;
    cb_ReportBadLinks: TCheckBox;
    cb_DeleteBadLinks: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
    procedure ToEndofDatesCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ShowDetails, ReportCancelled, ExtractToExcel,
    PrintAllDates, PrintToEndOfDates,
    IncludeCondominiums, PrintParcelDetails,
    ShowParcelsWithPictures, ShowParcelsWithoutPictures,
    ShowBadLinks, DeleteBadLinks : Boolean;
    StartDate, EndDate : TDateTime;

    PrintOrder : Integer;
    ExtractFile : TextFile;
    SelectedSchoolCodes, SelectedSwisCodes, SelectedPropertyClasses : TStringList;
    BadPictureLinkList : TList;

    Procedure InitializeForm;  {Open the tables and setup.}

  end;

  PictureTotalRecord = record
    SwisCode : String;
    SwisCodeName : String;
    NumberPicturesLinked : LongInt;
    NumberParcelsWithPictures : LongInt;
    NumberParcelsWithoutPictures : LongInt;
    NumberParcelsWithMultiplePictures : LongInt;
    NumberOfBadLinks : LongInt;

  end;

  PictureTotalPointer = ^PictureTotalRecord;


  BadPictureLinkRecord = record
    SwisSBLKey : String;
    PictureNumber : Integer;
    Location : String;
  end;

  BadPictureLinkPointer = ^BadPictureLinkRecord;

implementation

uses GlblVars, WinUtils, Utilitys, UTILEXSD, GlblCnst, PASUtils,
     PRCLLIST, DataAccessUnit,
     Prog, RptDialg,
     Preview, PASTypes;

{$R *.DFM}

const
  poParcelID = 0;
  poLegalAddress = 1;
  poOwnerName = 2;

{========================================================}
Procedure TPictureReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TPictureReportForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'RPictureReport';

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             NextYear, Quit);

  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             NextYear, Quit);

  PropertyClassTable.Open;

  FillOneListBox(SwisCodeListBox, SwisCodeTable,
                 'SwisCode', 'MunicipalityName', 20,
                 True, True, NextYear, GlblNextYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable,
                 'SchoolCode', 'SchoolName', 15,
                  True, True, NextYear, GlblNextYear);

  FillOneListBox(PropertyClassListBox, PropertyClassTable, 'MainCode',
                 'Description', 17, True, True, NextYear, GlblNextYear);

  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;
  SelectedPropertyClasses := TStringList.Create;

end;  {InitializeForm}

{==============================================================}
Procedure TPictureReportForm.AllDatesCheckBoxClick(Sender: TObject);

begin
 If AllDatesCheckBox.Checked
    then
      begin
        ToEndofDatesCheckBox.Checked := False;
        ToEndofDatesCheckBox.Enabled := False;
        StartDateEdit.Text := '';
        StartDateEdit.Enabled := False;
        StartDateEdit.Color := clBtnFace;
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(DateGroupBox);

end;  {AllDatesCheckBoxClick}

{==============================================================}
Procedure TPictureReportForm.ToEndofDatesCheckBoxClick(Sender: TObject);

begin
 If ToEndofDatesCheckBox.Checked
    then
      begin
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else
      begin
        EndDateEdit.Text := '  /  /    ';
        EndDateEdit.Enabled := True;
        EndDateEdit.Color := clWindow;

      end;  {else of If ToEndofDatesCheck.Checked}

end;  {ToEndofDatesCheckBoxClick}

{==============================================================}
Procedure WriteTotalsExcelHeader(var ExtractFile : TextFile);

begin
  WritelnCommaDelimitedLine(ExtractFile,
                            ['Swis Code',
                             'Swis Name',
                             '# Pics Linked',
                             '# Parcels w/Pics',
                             '# Parcels w/out Pics',
                             '# Parcels w/mult Pics']);

end;  {WriteTotalsExcelHeader}

{==============================================================}
Procedure TPictureReportForm.PrintButtonClick(Sender: TObject);

var
  NewFileName, SpreadsheetFileName : String;
  Quit : Boolean;
  I : Integer;

begin
  BadPictureLinkList := TList.Create;
  GlblCurrentCommaDelimitedField := 0;
  PrintOrder := PrintOrderRadioGroup.ItemIndex;
  ShowParcelsWithPictures := ShowParcelsWithPicturesCheckBox.Checked;
  ShowParcelsWithoutPictures := ShowParcelsWithoutPicturesCheckBox.Checked;
  SetPrintToScreenDefault(PrintDialog);
  ReportCancelled := False;
  ExtractToExcel := ExtractToExcelCheckBox.Checked;
  IncludeCondominiums := IncludeCondominiumsCheckBox.Checked;
  PrintParcelDetails := PrintParcelDetailsCheckBox.Checked;

  SelectedSwisCodes.Clear;

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    If SwisCodeListBox.Selected[I]
      then SelectedSwisCodes.Add(Copy(SwisCodeListBox.Items[I], 1, 6));

  SelectedSchoolCodes.Clear;

  For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
    If SchoolCodeListBox.Selected[I]
      then SelectedSchoolCodes.Add(Copy(SchoolCodeListBox.Items[I], 1, 6));

  SelectedPropertyClasses.Clear;

  For I := 0 to (PropertyClassListBox.Items.Count - 1) do
    If PropertyClassListBox.Selected[I]
      then SelectedPropertyClasses.Add(Copy(PropertyClassListBox.Items[I], 1, 3));

    {If they didn't select any dates, then select all.}

  If ((not AllDatesCheckBox.Checked) and
      (not ToEndOfDatesCheckBox.Checked) and
      (StartDateEdit.Text = '  /  /    ') and
      (EndDateEdit.Text = '  /  /    '))
    then AllDatesCheckBox.Checked := True;

  PrintAllDates := AllDatesCheckBox.Checked;
  PrintToEndOfDates := False;

  If not PrintAllDates
    then
      begin
        try
          StartDate := StrToDate(StartDateEdit.Text);
        except
        end;

        PrintToEndOfDates := ToEndOfDatesCheckBox.Checked;

        If not PrintToEndOfDates
          then
            try
              EndDate := StrToDate(EndDateEdit.Text);
            except
            end;

      end;  {If not PrintAllDates}

  OpenTablesForForm(Self, NextYear);

  If ((not Quit) and
      PrintDialog.Execute)
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);
        ProgressDialog.Start(ParcelTable.RecordCount, True, True);

        ReportCancelled := False;
        GlblPreviewPrint := False;

        with ParcelTable do
          case PrintOrder of
            poParcelID : IndexName := 'BYTAXROLLYR_SWISSBLKEY';
            poLegalAddress : IndexName := 'BYYEAR_LEGALADDR_LEGALADDRINT';
            poOwnerName : IndexName := 'BYYEAR_NAME';

          end;

        If ExtractToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

              If PrintParcelDetails
                then WritelnCommaDelimitedLine(ExtractFile,
                                               ['Print Key',
                                                'Owner',
                                                'Legal Address',
                                                'Class',
                                                '# Pictures'])
                else WriteTotalsExcelHeader(ExtractFile);

            end;  {If ExtractToExcel}

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

                  PreviewForm.FilePreview.ZoomFactor := 100;

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

          {Make sure to close and delete the sort file.}

        ResetPrinter(ReportPrinter);
        ProgressDialog.Finish;

        If ExtractToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

            end;  {If PrintToExcel}

      end;  {If PrintDialog.Execute}

  FreeTList(BadPictureLinkList, SizeOf(BadPictureLinkRecord));

end;  {StartButtonClick}

{==============================================================}
Procedure PrintParcelSectionHeader(Sender : TObject;
                                   PrintParcelDetails : Boolean);

begin
  with Sender as TBaseReport do
    begin
      SetFont('Times New Roman',10);
      Println('');
      Bold := True;
      Italic := True;
      ClearTabs;
      SetTab(0.4, pjLeft, 2.6, 0, BOXLINENone, 0);   {Swis Code}
      Italic := False;

      If PrintParcelDetails
        then
          begin
            ClearTabs;
            SetTab(0.4, pjCenter, 1.5, 5, BOXLINENOBOTTOM, 25);   {Parcel ID}
            SetTab(1.9, pjCenter, 2.3, 5, BOXLINENOBOTTOM, 25);   {Owner}
            SetTab(4.2, pjCenter, 2.3, 5, BOXLINENOBOTTOM, 25);   {Legal address}
            SetTab(6.5, pjCenter, 0.5, 5, BOXLINENOBOTTOM, 25);   {Property class \ ownership}
            SetTab(7.0, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);   {# pictures}

            Println(#9 + 'Print Key' +
                    #9 + 'Owner' +
                    #9 + 'Legal Address' +
                    #9 + 'Class' +
                    #9 + '# Pictures');

            ClearTabs;
            SetTab(0.4, pjLeft, 1.5, 5, BOXLINEAll, 0);   {Parcel ID}
            SetTab(1.9, pjLeft, 2.3, 5, BOXLINEAll, 0);   {Owner}
            SetTab(4.2, pjLeft, 2.3, 5, BOXLINEAll, 0);   {Legal address}
            SetTab(6.5, pjLeft, 0.5, 5, BOXLINEAll, 0);   {Property class \ ownership}
            SetTab(7.0, pjLeft, 0.7, 5, BOXLINEAll, 0);   {# pictures}

          end
        else
          begin
            ClearTabs;
            SetTab(0.4, pjCenter, 1.8, 5, BOXLINENOBOTTOM, 25);   {Parcel ID}
            SetTab(2.2, pjCenter, 1.8, 5, BOXLINENOBOTTOM, 25);   {Parcel ID}
            SetTab(4.0, pjCenter, 1.8, 5, BOXLINENOBOTTOM, 25);   {Parcel ID}
            SetTab(5.8, pjCenter, 1.8, 5, BOXLINENOBOTTOM, 25);   {Parcel ID}

            Println(#9 + 'Print Key' +
                    #9 + 'Print Key' +
                    #9 + 'Print Key' +
                    #9 + 'Print Key');

            ClearTabs;
            SetTab(0.4, pjLeft, 1.8, 5, BOXLINEAll, 0);   {Parcel ID}
            SetTab(2.2, pjLeft, 1.8, 5, BOXLINEAll, 0);   {Parcel ID}
            SetTab(4.0, pjLeft, 1.8, 5, BOXLINEAll, 0);   {Parcel ID}
            SetTab(5.8, pjLeft, 1.8, 5, BOXLINEAll, 0);   {Parcel ID}

          end;  {else of If PrintParcelDetails}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {PrintParcelSectionHeader}

{==============================================================}
Procedure PrintTotalSectionHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;

      ClearTabs;
      SetTab(0.4, pjCenter, 0.6, 5, BOXLINENOBOTTOM, 25);   {Swis Code}
      SetTab(1.0, pjCenter, 1.5, 5, BOXLINENOBOTTOM, 25);   {Swis Name}
      SetTab(2.5, pjCenter, 1.0, 5, BOXLINENOBOTTOM, 25);   {# Pictures Linked}
      SetTab(3.5, pjCenter, 1.0, 5, BOXLINENOBOTTOM, 25);   {# Parcels w/ pics}
      SetTab(4.5, pjCenter, 1.0, 5, BOXLINENOBOTTOM, 25);   {# Parcels w/out pics}
      SetTab(5.5, pjCenter, 1.0, 5, BOXLINENOBOTTOM, 25);   {# Parcels w/multiple pics}

      Println(#9 + 'Swis' +
              #9 + 'Swis Name' +
              #9 + '# Pictures' +
              #9 + '# Parcels' +
              #9 + '# Parcels' +
              #9 + '# Parcels');

      ClearTabs;
      SetTab(0.4, pjCenter, 0.6, 5, BOXLINENOTOP, 25);   {Swis Code}
      SetTab(1.0, pjCenter, 1.5, 5, BOXLINENOTOP, 25);   {Swis Name}
      SetTab(2.5, pjCenter, 1.0, 5, BOXLINENOTOP, 25);   {# Pictures Linked}
      SetTab(3.5, pjCenter, 1.0, 5, BOXLINENOTOP, 25);   {# Parcels w/ pics}
      SetTab(4.5, pjCenter, 1.0, 5, BOXLINENOTOP, 25);   {# Parcels w/out pics}
      SetTab(5.5, pjCenter, 1.0, 5, BOXLINENOTOP, 25);   {# Parcels w/multiple pics}

      Println(#9 + #9 +
              #9 + 'Linked' +
              #9 + 'w/Pictures' +
              #9 + 'w/out Pics' +
              #9 + 'w/mult Pics');
      Bold := False;

      ClearTabs;
      SetTab(0.4, pjLeft, 0.6, 5, BOXLINEALL, 0);   {Swis Code}
      SetTab(1.0, pjLeft, 1.5, 5, BOXLINEALL, 0);   {Swis Name}
      SetTab(2.5, pjRight, 1.0, 5, BOXLINEALL, 0);   {# Pictures Linked}
      SetTab(3.5, pjRight, 1.0, 5, BOXLINEALL, 0);   {# Parcels w/ pics}
      SetTab(4.5, pjRight, 1.0, 5, BOXLINEALL, 0);   {# Parcels w/out pics}
      SetTab(5.5, pjRight, 1.0, 5, BOXLINEALL, 0);   {# Parcels w/multiple pics}

    end;  {with Sender as TBaseReport do}

end;  {PrintTotalSectionHeader}

{==============================================================}
Procedure TPictureReportForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;

      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage) + '    ', pjRight);
      PrintHeader('    Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SetFont('Times New Roman',12);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Picture Report', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',12);

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==============================================================}
Procedure InitializePicturePointer(PictureTotalPtr : PictureTotalPointer;
                                   _SwisCode : String;
                                   SwisCodeTable : TTable);

begin
  with PictureTotalPtr^ do
    begin
      FindKeyOld(SwisCodeTable, ['SwisCode'], [_SwisCode]);

      SwisCode := _SwisCode;
      SwisCodeName := SwisCodeTable.FieldByName('MunicipalityName').Text;

      NumberPicturesLinked := 0;
      NumberParcelsWithPictures := 0;
      NumberParcelsWithoutPictures := 0;
      NumberParcelsWithMultiplePictures := 0;
      NumberOfBadLinks := 0;

    end;  {with PictureTotalPtr^ do}

end;  {InitializePicturePointer}

{==============================================================}
Function GetPictureDetailsForParcel(Sender : TObject;
                                    ShowDetails : Boolean;
                                    PictureTable : TTable;
                                    _SwisSBLKey : String;
                                    PictureTotalPtr : PictureTotalPointer;
                                    StartDate : TDateTime;
                                    EndDate : TDateTime;
                                    PrintAllDates : Boolean;
                                    PrintToEndOfDates : Boolean;
                                    BadPictureLinkList : TList) : Integer;

var
  Done, FirstTimeThrough : Boolean;
  _NumberPicturesLinked, _NumberOfBadLinks : LongInt;
  BadPictureLinkPtr : BadPictureLinkPointer;

begin
  FirstTimeThrough := True;
  _NumberPicturesLinked := 0;
  _NumberOfBadLinks := 0;

  _SetRange(PictureTable, [_SwisSBLKey], [], '', [loSameEndingRange]);

  with PictureTable do
    begin
      First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else Next;

        Done := EOF;

        If ((not Done) and
            MeetsDateCriteria(FieldByName('Date').AsDateTime,
                              StartDate, EndDate, PrintAllDates, PrintToEndOfDates))
          then
            begin
              _NumberPicturesLinked := _NumberPicturesLinked + 1;

              If not FileExists(FieldByName('PictureLocation').Text)
                then
                  begin
                    Inc(_NumberOfBadLinks);

                    New(BadPictureLinkPtr);

                    with BadPictureLinkPtr^ do
                      begin
                        SwisSBLKey := _SwisSBLKey;
                        PictureNumber := FieldByName('PictureNumber').AsInteger;
                        Location := FieldByName('PictureLocation').Text;

                      end;  {with BadPictureLinkPtr^ do}

                    BadPictureLinkList.Add(BadPictureLinkPtr);

                  end;  {If not FileExists(FieldByName('PictureLocation').Text)}

            end;  {If not Done}

      until Done;

    end;  {with PictureTable do}

  with PictureTotalPtr^ do
    begin
      Inc(NumberPicturesLinked, _NumberPicturesLinked);

      If _Compare(_NumberPicturesLinked, 0, coEqual)
        then Inc(NumberParcelsWithoutPictures)
        else Inc(NumberParcelsWithPictures);

      If _Compare(_NumberPicturesLinked, 1, coGreaterThan)
        then Inc(NumberParcelsWithMultiplePictures);

      Inc(NumberOfBadLinks, _NumberOfBadLinks);

    end;  {with PictureTotalPtr^ do}

  Result := _NumberPicturesLinked;

end;  {GetPictureDetailsForParcel}

{==============================================================}
Function MeetsCriteria(ParcelTable : TTable;
                       SelectedSwisCodes : TStringList;
                       SelectedSchoolCodes : TStringList;
                       SelectedPropertyClasses : TStringList;
                       IncludeCondominiums : Boolean) : Boolean;

begin
  with ParcelTable do
    Result := ((FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
               (SelectedSwisCodes.IndexOf(FieldByName('SwisCode').Text) > -1) and
               (SelectedSchoolCodes.IndexOf(FieldByName('SchoolCode').Text) > -1) and
               (SelectedPropertyClasses.IndexOf(FieldByName('PropertyClassCode').Text) > -1) and
               (IncludeCondominiums or
                _Compare(FieldByName('OwnershipCode').Text, ownCondominium, coNotEqual)));

end;  {MeetsCriteria}

{==============================================================}
Procedure TPictureReportForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  LastSwisCode, SwisSBLKey : String;
  PictureTotalPtr : PictureTotalPointer;
  PictureTotalList : TList;
  I, CurrentDetailColumn, PicturesThisParcel : Integer;
  TotalNumberPicturesLinked, TotalNumberParcelsWithPictures,
  TotalNumberParcelsWithoutPictures, TotalNumberParcelsWithMultiplePictures : LongInt;

begin
  PictureTotalList := TList.Create;
  FirstTimeThrough := True;
  ReportCancelled := False;
  CurrentDetailColumn := 0;

  ParcelTable.First;
  LastSwisCode := ParcelTable.FieldByName('SwisCode').Text;
  New(PictureTotalPtr);
  InitializePicturePointer(PictureTotalPtr, LastSwisCode, SwisCodeTable);

  PrintParcelSectionHeader(Sender, PrintParcelDetails);

  with Sender as TBaseReport do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else ParcelTable.Next;

      Done := ParcelTable.EOF;

      SwisSBLKey := ExtractSSKey(ParcelTable);
      ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
      Application.ProcessMessages;

      If (Done or
          (LastSwisCode <> Copy(SwisSBLKey, 1, 6)))
        then
          begin
            PictureTotalList.Add(PictureTotalPtr);

            If not Done
              then
                begin
                  New(PictureTotalPtr);
                  InitializePicturePointer(PictureTotalPtr, Copy(SwisSBLKey, 1, 6), SwisCodeTable);
                end;

          end;  {If (Done or ...}

      If ((not Done) and
          MeetsCriteria(ParcelTable, SelectedSwisCodes, SelectedSchoolCodes, SelectedPropertyClasses,
                        IncludeCondominiums))
        then
          begin
            If (LinesLeft < 5)
              then
                begin
                  NewPage;
                  CurrentDetailColumn := 0;
                  PrintParcelSectionHeader(Sender, PrintParcelDetails);

                end;  {If (LinesLeft < 5)}

            PicturesThisParcel := GetPictureDetailsForParcel(Sender, ShowDetails,
                                                             PictureTable, SwisSBLKey, PictureTotalPtr,
                                                             StartDate, EndDate,
                                                             PrintAllDates, PrintToEndOfDates,
                                                             BadPictureLinkList);

            If ((ShowParcelsWithoutPictures and
                 _Compare(PicturesThisParcel, 0, coEqual)) or
                (ShowParcelsWithPictures and
                 _Compare(PicturesThisParcel, 0, coGreaterThan)))
              then
                begin
                  If PrintParcelDetails
                    then
                      begin
                        with ParcelTable do
                          Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                                  #9 + FieldByName('Name1').Text +
                                  #9 + GetLegalAddressFromTable(ParcelTable) +
                                  #9 + FieldByName('PropertyClassCode').Text +
                                       FieldByName('OwnershipCode').Text +
                                  #9 + IntToStr(PicturesThisParcel));

                      end
                    else
                      begin
                        CurrentDetailColumn := CurrentDetailColumn + 1;

                        If (CurrentDetailColumn > 4)
                          then
                            begin
                              Println('');
                              CurrentDetailColumn := 1;
                            end;

                        Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey));

                      end;  {else of If PrintParcelDetails}

                  If ExtractToExcel
                    then
                      with ParcelTable do
                        WritelnCommaDelimitedLine(ExtractFile,
                                                  [ConvertSwisSBLToDashDot(SwisSBLKey),
                                                   FieldByName('Name1').Text,
                                                   GetLegalAddressFromTable(ParcelTable),
                                                   FieldByName('PropertyClassCode').Text +
                                                   FieldByName('OwnershipCode').Text,
                                                   PicturesThisParcel]);

                end;  {If ((ShowParcelsWithoutPictures and ...}

          end;  {If not Done}

      ReportCancelled := ProgressDialog.Cancelled;

      LastSwisCode := ParcelTable.FieldByName('SwisCode').Text;

    until (Done or ReportCancelled);

  If ShowParcelsWithoutPictures
    then
      with Sender as TBaseReport do
        For I := CurrentDetailColumn to 4 do
          Print(#9);

      {Now print out the totals.}

  TotalNumberPicturesLinked := 0;
  TotalNumberParcelsWithPictures := 0;
  TotalNumberParcelsWithoutPictures := 0;
  TotalNumberParcelsWithMultiplePictures := 0;

  with Sender as TBaseReport do
    begin
      NewPage;
      PrintTotalSectionHeader(Sender);

      If (ShowParcelsWithoutPictures and
          ExtractToExcel)
        then WriteTotalsExcelHeader(ExtractFile);

      For I := 0 to (PictureTotalList.Count - 1) do
        with PictureTotalPointer(PictureTotalList[I])^ do
          begin
            If (LinesLeft < 5)
              then NewPage;

            If (PrintOrder = poParcelID)
              then Println(#9 + SwisCode +
                           #9 + SwisCodeName +
                           #9 + FormatFloat(IntegerDisplay, NumberPicturesLinked) +
                           #9 + FormatFloat(IntegerDisplay, NumberParcelsWithPictures) +
                           #9 + FormatFloat(IntegerDisplay, NumberParcelsWithoutPictures) +
                           #9 + FormatFloat(IntegerDisplay, NumberParcelsWithMultiplePictures));

            If ((PrintOrder = poParcelID) and
                ExtractToExcel)
              then WritelnCommaDelimitedLine(ExtractFile,
                                             [SwisCode,
                                              SwisCodeName,
                                              NumberPicturesLinked,
                                              NumberParcelsWithPictures,
                                              NumberParcelsWithoutPictures,
                                              NumberParcelsWithMultiplePictures]);

            TotalNumberPicturesLinked := TotalNumberPicturesLinked + NumberPicturesLinked;
            TotalNumberParcelsWithPictures := TotalNumberParcelsWithPictures + NumberParcelsWithPictures;
            TotalNumberParcelsWithoutPictures := TotalNumberParcelsWithoutPictures + NumberParcelsWithoutPictures;
            TotalNumberParcelsWithMultiplePictures := TotalNumberParcelsWithMultiplePictures + NumberParcelsWithMultiplePictures;

          end;  {For I := 0 to (PictureTotalList.Count - 1) do}

      Println(#9 + #9 + #9 + #9 + #9 + #9);
      Bold := True;
      Println(#9 +
              #9 + 'Grand Total:' +
              #9 + FormatFloat(IntegerDisplay, TotalNumberPicturesLinked) +
              #9 + FormatFloat(IntegerDisplay, TotalNumberParcelsWithPictures) +
              #9 + FormatFloat(IntegerDisplay, TotalNumberParcelsWithoutPictures) +
              #9 + FormatFloat(IntegerDisplay, TotalNumberParcelsWithMultiplePictures));

      If ExtractToExcel
        then WritelnCommaDelimitedLine(ExtractFile,
                                       ['',
                                        'Grand Total:',
                                        TotalNumberPicturesLinked,
                                        TotalNumberParcelsWithPictures,
                                        TotalNumberParcelsWithoutPictures,
                                        TotalNumberParcelsWithMultiplePictures]);

    end;  {with Sender as TBaseReport do}

  FreeTList(PictureTotalList, SizeOf(PictureTotalRecord));

end;  {ReportPrint}

{===================================================================}
Procedure TPictureReportForm.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  SelectedSwisCodes.Free;
  SelectedSchoolCodes.Free;
  SelectedPropertyClasses.Free;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.