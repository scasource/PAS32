unit Sdcodmnt;

interface

uses
  DBIProcs, SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, Mask, DBCtrls,
  Wwkeycb, DB, DBTables, Wwtable, Wwdatsrc, Printrng, Btrvdlg, Grids,
  DBGrids, DBLookup, RPBase, RPCanvas, RPrinter, Wwdbigrd, Wwdbgrid,
  TabNotBk, RPFiler, Pastypes, RPDefine, wwdblook;

type
  TSDCodeForm = class(TForm)
    SDCodeDataSource: TwwDataSource;
    SpecialDistrictCodeTable: TwwTable;
    PrintRangeDlg: TPrintRangeDlg;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    ScrollBox1: TScrollBox;
    SDCodeLookupTable: TwwTable;
    Label1: TLabel;
    Panel2: TPanel;
    PrintButton: TBitBtn;
    ExitButton: TBitBtn;
    Panel3: TPanel;
    Label6: TLabel;
    SpecialDistrictCodeSearch: TwwIncrementalSearch;
    Panel4: TPanel;
    SDCodeDBGrid: TwwDBGrid;
    NewDistrictButton: TBitBtn;
    DeleteDistrictButton: TBitBtn;
    ParcelSDTable: TTable;
    Label2: TLabel;
    procedure PrintButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReportPrinterBeforePrint(Sender: TObject);
    procedure ReportPrinterPrintHeader(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrinterPrint(Sender: TObject);
    procedure DeleteDistrictButtonClick(Sender: TObject);
    procedure NewDistrictButtonClick(Sender: TObject);
    procedure SDCodeDBGridDblClick(Sender: TObject);
  private
    UnitName : String;  {For use with the error dialog box.}
  public
    CodeInserted : Boolean;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;  {Open the tables}
  end;

implementation

{$R *.DFM}

uses
  Preview,   {Print preview form}
  Types,     {Constants, types}
  Utilitys,  {General utilities}
  PASUTILS, UTILEXSD,   {Pas-specific utilities}
  GlblVars,
  GlblCnst,
  SDCodeMaintenanceSubformUnit,
  WinUtils, DataAccessUnit;

{======================================================================}
Procedure TSDCodeForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{======================================================================}
Procedure TSDCodeForm.InitializeForm;

begin
  UnitName := 'SDCODMNT';

  If not ModifyAccessAllowed(FormAccessRights)
    then SpecialDistrictCodeTable.ReadOnly := True;

  OpenTablesForForm(Self, GlblProcessingType);

  If (GlblTaxYearFlg = 'H')
    then
      begin
        SetRangeForHistoryTaxYear(SpecialDistrictCodeTable, 'TaxRollYr', 'SDistCode');
        SetRangeForHistoryTaxYear(SDCodeLookupTable, 'TaxRollYr', 'SDistCode');

      end;  {If (GlblTaxYearFlg = 'H')}

  Caption := 'Special District Codes (' + GetTaxYrLbl + ')';

end;  {FormShow}

{===========================================================}
procedure TSDCodeForm.DeleteDistrictButtonClick(Sender: TObject);

{If there are parcels with this special district, don't let them delete it.}

var
  SpecialDistrictCode : String;

begin
  SpecialDistrictCode := SpecialDistrictCodeTable.FieldByName('SDistCode').Text;

  If _Locate(ParcelSDTable, [SpecialDistrictCode], '', [])
    then MessageDlg('This special district code can not be deleted because' + #13 +
                    'it is applied to one or more parcels.',
                    mtError, [mbOK], 0)
    else
      If (MessageDlg('Are you sure you want to delete special district ' +
                     SpecialDistrictCode + '?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
        then
          try
            SpecialDistrictCodeTable.Delete;
          except
            Abort;
          end;

end;  {DeleteDistrictButtonClick}

{===================================================================}
Procedure TSDCodeForm.SDCodeDBGridDblClick(Sender: TObject);

begin
  try
    SpecialDistrictCodeMaintenanceSubform := TSpecialDistrictCodeMaintenanceSubform.Create(Application);

    with SpecialDistrictCodeTable do
      begin
        SpecialDistrictCodeMaintenanceSubform.InitializeForm(FieldByName('SDistCode').Text,
                                                             GlblProcessingType, ReadOnly);
        SpecialDistrictCodeMaintenanceSubform.ShowModal;

      end;  {with SpecialDistrictCodeMaintenanceSubform do}

  finally
    SpecialDistrictCodeMaintenanceSubform.Free;
  end;

  SpecialDistrictCodeTable.Refresh;

end;  {SDCodeDBGridDblClick}

{===================================================================}
Procedure TSDCodeForm.NewDistrictButtonClick(Sender: TObject);

begin
  try
    SpecialDistrictCodeMaintenanceSubform := TSpecialDistrictCodeMaintenanceSubform.Create(Application);

    with SpecialDistrictCodeMaintenanceSubform do
      begin
        InitializeForm('', GlblProcessingType, False);
        ShowModal;
      end;

  finally
    SpecialDistrictCodeMaintenanceSubform.Free;
  end;

  SpecialDistrictCodeTable.Refresh;

end;  {NewDistrictButtonClick}

{===================================================================}
Procedure TSDCodeForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;

begin
  If PrintRangeDlg.Execute
    then
      begin
        If PrintRangeDlg.PreviewPrint
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

              end;

            end
          else ReportPrinter.Execute;

      end;  {If PrintRangeDlg.Execute}

end;  {PrintButtonClick}

{=============================================================================}
Procedure TSDCodeForm.ReportPrinterBeforePrint(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      MarginTop := 1.25;
      MarginBottom := 0.75;

      If PrintRangeDlg.PrintAllCodes
        then SDCodeLookupTable.First
        else FindNearestOld(SDCodeLookupTable, ['SDistCode'],
                            [PrintRangeDlg.StartRange]);

    end;  {with ReportComponent do}

end;  {ReportPrinterBeforePrint}

{=============================================================================}
Procedure TSDCodeForm.ReportPrinterPrintHeader(Sender: TObject);

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
      PrintCenter('Special District Codes Listing', (PageWidth / 2));
      SetFont('Times New Roman', 10);
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
              Println('');
              Home;
            end;  {else of If PrintAllCodes}

      Bold := True;
      PrintLn('');
      ClearTabs;
      SetTab(0.3, pjCenter, 0.7, 5, BoxLineNoBottom, 25);   {SD code}
      SetTab(1.0, pjCenter, 3.8, 5, BoxLineNoBottom, 25);   {Description}
      SetTab(4.8, pjCenter, 0.4, 5, BoxLineNoBottom, 25);   {Type}
      SetTab(5.2, pjCenter, 1.2, 5, BoxLineNoBottom, 25);   {Extension Types}
      SetTab(6.4, pjCenter, 0.3, 5, BoxLineNoBottom, 25);   {Sec 490}
      SetTab(6.7, pjCenter, 0.3, 5, BoxLineNoBottom, 25);   {Chap 562}
      SetTab(7.0, pjCenter, 0.5, 5, BoxLineNoBottom, 25);   {Split District}
      SetTab(7.5, pjCenter, 0.8, 5, BoxLineNoBottom, 25);   {Vol Fire \ Amb Applies}
      SetTab(8.3, pjCenter, 0.4, 5, BoxLineNoBottom, 25);   {Fire}
      SetTab(8.7, pjCenter, 0.2, 5, BoxLineNoBottom, 25);   {RS 9}
      SetTab(8.9, pjCenter, 0.5, 5, BoxLineNoBottom, 25);   {Pro-Rata}
      SetTab(9.4, pjCenter, 0.6, 5, BoxLineNoBottom, 25);   {Default Units}
      SetTab(10.0, pjCenter, 0.6, 5, BoxLineNoBottom, 25);   {Default 2 units}

      Println(#9 + #9 +
              #9 + 'Dist' +
              #9 +
              #9 + 'Sec' +
              #9 + 'Chp' +
              #9 + 'Split' +
              #9 + 'Vol Fire' +
              #9 + 'Fire' +
              #9 + 'RS' +
              #9 + 'Pro' +
              #9 + 'Default' +
              #9 + 'Default');

      ClearTabs;
      SetTab(0.3, pjCenter, 0.7, 5, BoxLineNoTop, 25);   {SD code}
      SetTab(1.0, pjCenter, 3.8, 5, BoxLineNoTop, 25);   {Description}
      SetTab(4.8, pjCenter, 0.4, 5, BoxLineNoTop, 25);   {Type}
      SetTab(5.2, pjCenter, 1.2, 5, BoxLineNoTop, 25);   {Extension Types}
      SetTab(6.4, pjCenter, 0.3, 5, BoxLineNoTop, 25);   {Sec 490}
      SetTab(6.7, pjCenter, 0.3, 5, BoxLineNoTop, 25);   {Chap 562}
      SetTab(7.0, pjCenter, 0.5, 5, BoxLineNoTop, 25);   {Split District}
      SetTab(7.5, pjCenter, 0.8, 5, BoxLineNoTop, 25);   {Vol Fire \ Amb Applies}
      SetTab(8.3, pjCenter, 0.4, 5, BoxLineNoTop, 25);   {Fire}
      SetTab(8.7, pjCenter, 0.2, 5, BoxLineNoTop, 25);   {RS 9}
      SetTab(8.9, pjCenter, 0.5, 5, BoxLineNoTop, 25);   {Pro-Rata}
      SetTab(9.4, pjCenter, 0.6, 5, BoxLineNoTop, 25);   {Default Units}
      SetTab(10.0, pjCenter, 0.6, 5, BoxLineNoTop, 25);   {Default 2 units}

      Println(#9 + 'Code' +
              #9 + 'Description' +
              #9 + 'Type' +
              #9 + 'Extensions' +
              #9 + '490' +
              #9 + '562' +
              #9 + 'Dist' +
              #9 + 'Applies' +
              #9 + 'Dist' +
              #9 + 'Rata' +
              #9 + '9' +
              #9 + 'Units' +
              #9 + '2nd Units');

      ClearTabs;
      SetTab(0.3, pjLeft, 0.7, 5, BoxLineNoTop, 0);   {SD code}
      SetTab(1.0, pjLeft, 3.8, 5, BoxLineNoTop, 0);   {Description}
      SetTab(4.8, pjLeft, 0.4, 5, BoxLineNoTop, 0);   {Type}
      SetTab(5.2, pjLeft, 1.2, 5, BoxLineNoTop, 0);   {Extension Types}
      SetTab(6.4, pjCenter, 0.3, 5, BoxLineNoTop, 0);   {Sec 490}
      SetTab(6.7, pjCenter, 0.3, 5, BoxLineNoTop, 0);   {Chap 562}
      SetTab(7.0, pjCenter, 0.5, 5, BoxLineNoTop, 0);   {Split District}
      SetTab(7.5, pjCenter, 0.8, 5, BoxLineNoTop, 0);   {Vol Fire \ Amb Applies}
      SetTab(8.3, pjCenter, 0.4, 5, BoxLineNoTop, 0);   {Fire}
      SetTab(8.7, pjCenter, 0.2, 5, BoxLineNoTop, 0);   {RS 9}
      SetTab(8.9, pjCenter, 0.5, 5, BoxLineNoTop, 0);   {Pro-Rata}
      SetTab(9.4, pjRight, 0.6, 5, BoxLineNoTop, 0);   {Default Units}
      SetTab(10.0, pjRight, 0.6, 5, BoxLineNoTop, 0);   {Default 2 units}
      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrintHeader}

{==============================================================================}
Procedure TSDCodeForm.ReportPrinterPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  TempFieldName, ExtensionCodes : String;
  I : Integer;

begin
  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SDCodeLookupTable.Next;

    If SDCodeLookupTable.EOF
      then Done := True;

    If not Done
      then
        with SDCodeLookupTable, Sender as TBaseReport do
          begin
            If (LinesLeft < 5)
              then NewPage;

          ExtensionCodes := '';
          For I := 1 to 5 do
            begin
              TempFieldName := 'ECd' + IntToStr(I);
              If (Deblank(FieldByName(TempFieldName).Text) <> '')
                then ExtensionCodes := ExtensionCodes +
                                       FieldByName(TempFieldName).Text + ' ';

            end;  {For I := 1 to 10 do}

            Println(#9 + FieldByName('SDistCode').Text +
                    #9 + FieldByName('Description').Text +
                    #9 + FieldByName('DistrictType').Text +
                    #9 + ExtensionCodes +
                    #9 + BoolToChar_Blank_X(FieldByName('Section490').AsBoolean) +
                    #9 + BoolToChar_Blank_X(FieldByName('Chapter562').AsBoolean) +
                    #9 + BoolToChar_Blank_X(FieldByName('SDHomestead').AsBoolean) +
                    #9 + BoolToChar_Blank_X(FieldByName('VolFireAmbApplies').AsBoolean) +
                    #9 + BoolToChar_Blank_X(FieldByName('FireDistrict').AsBoolean) +
                    #9 + BoolToChar_Blank_X(FieldByName('SDRS9').AsBoolean) +
                    #9 + BoolToChar_Blank_X(FieldByName('ProRataOmit').AsBoolean) +
                    #9 + FormatFloat(_3DecimalEditDisplay,
                                     FieldByName('DefaultUnits').AsFloat) +
                    #9 + FormatFloat(_3DecimalEditDisplay,
                                     FieldByName('Default2ndUnits').AsFloat));

        end;  {If not Done}

  until Done;

end;  {ReportPrinterPrint}

{===================================================================}
Procedure TSDCodeForm.ExitButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TSDCodeForm.FormClose(    Sender: TObject;
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








