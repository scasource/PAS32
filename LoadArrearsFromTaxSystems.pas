unit LoadArrearsFromTaxSystems;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler;

type
  TTaxSystemsSetType = set of (tsDelinquent, tsSchool, tsTown, tsCounty);

  TGeneralDLLFunction = Function (Application : TApplication) : Boolean;
  TInitializeDelinquentDLLFunction = Function (Application : TApplication;
                                               DelinquentSystem : ShortString) : Boolean;
  TParcelHasOpenDelinquentTaxesFunction = Function (Application : TApplication;
                                                    SwisSBLKey : ShortString) : Boolean;

  TParcelHasOpenCurrentTaxesFunction = Function (Application : TApplication;
                                                 SwisSBLKey : ShortString;
                                                 SchoolCode : ShortString;
                                                 TaxSystem : ShortString) : Boolean;
  TInitializeCurrentTaxDLLFunction = Function (Application : TApplication;
                                               TaxSystems : ShortString) : Boolean;


  TLoadArrearsFlagsFromTaxesForm = class(TForm)
    ParcelTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    Label1: TLabel;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    DelinquentTaxCheckBox: TCheckBox;
    CurrentSchoolTaxCheckBox: TCheckBox;
    CurrentTownTaxCheckBox: TCheckBox;
    CurrentCountyTaxCheckBox: TCheckBox;
    gb_Options: TGroupBox;
    Label3: TLabel;
    cb_AlternateDelinquentSystem: TComboBox;
    ClearOldArrearsFlagsCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ReportHeaderPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName, AlternateDelinquentSystem : String;
    ClearArrearsFlags, ReportCancelled : Boolean;
    TaxSystemsToCheck : TTaxSystemsSetType;

    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Prog, Preview,
     Types, PASTypes;

{$R *.DFM}

const
  DTSDLLName = '\SCADLQTX\ReturnDelinquentStatusDLL.dll';
  CurrentTaxDLLName = '\SCATAX32\ReturnCurrentTaxStatus.dll';

{========================================================}
Procedure TLoadArrearsFlagsFromTaxesForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TLoadArrearsFlagsFromTaxesForm.InitializeForm;

var
  I : Integer;
  DatabaseList : TStringList;

begin
  UnitName := 'LoadArrearsFromTaxSystem';  {mmm}

  OpenTablesForForm(Self, ThisYear);

  DatabaseList := TStringList.Create;
  Session.GetDatabaseNames(DatabaseList);

  For I := 0 to (DatabaseList.Count - 1) do
    If _Compare('SCALien', DatabaseList[I], coStartsWith)
      then cb_AlternateDelinquentSystem.Items.Add(DatabaseList[I]);

  DatabaseList.Free;

end;  {InitializeForm}

{===================================================================}
Procedure TLoadArrearsFlagsFromTaxesForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{================================================================}
Procedure TLoadArrearsFlagsFromTaxesForm.StartButtonClick(Sender: TObject);

var
  Quit : Boolean;
  NewFileName : String;
  TempFile : File;

begin
  Quit := False;
  ReportCancelled := False;

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  StartButton.Enabled := False;
  Application.ProcessMessages;
  Quit := False;
  ClearArrearsFlags := ClearOldArrearsFlagsCheckBox.Checked;

  TaxSystemsToCheck := [];

  If CurrentSchoolTaxCheckBox.Checked
    then TaxSystemsToCheck := TaxSystemsToCheck + [tsSchool];

  If CurrentTownTaxCheckBox.Checked
    then TaxSystemsToCheck := TaxSystemsToCheck + [tsTown];

  If CurrentCountyTaxCheckBox.Checked
    then TaxSystemsToCheck := TaxSystemsToCheck + [tsCounty];

  If DelinquentTaxCheckBox.Checked
    then TaxSystemsToCheck := TaxSystemsToCheck + [tsDelinquent];

  with cb_AlternateDelinquentSystem do
    If _Compare(ItemIndex, -1, coGreaterThan)
      then AlternateDelinquentSystem := Items[ItemIndex]
      else AlternateDelinquentSystem := '';

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler,
                              [ptLaser], False, Quit);

        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

          {Now print the report.}

        If not (Quit or ReportCancelled)
          then
            begin
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

                        {FXX10111999-3: Make sure they know its done.}

                      ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

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

                    end;  {try PreviewForm := ...}

                  end  {If PrintDialog.PrintToFile}
                else ReportPrinter.Execute;

              ResetPrinter(ReportPrinter);

            end;  {If not Quit}

        ProgressDialog.Finish;

        DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

      end;  {If PrintDialog.Execute}

  StartButton.Enabled := True;

end;  {StartButtonClick}

{=========================================================}
Procedure TLoadArrearsFlagsFromTaxesForm.ReportHeaderPrint(Sender: TObject);

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
      Bold := True;
      Home;
      PrintCenter('Arrears Flags Cleared \ Set', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.8, 0, BOXLINEBottom, 0);   {Parcel ID}
      SetTab(2.2, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Action}

      Println(#9 + 'Parcel ID' +
              #9 + 'Action');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.8, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(2.2, pjLeft, 1.0, 0, BOXLINENone, 0);   {Action}

    end;  {with Sender as TBaseReport do}

end;  {ReportHeaderPrint}

{====================================================================}
Procedure TLoadArrearsFlagsFromTaxesForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, Quit,
  ParcelHasLien, ParcelHasSchool,
  ParcelHasTown, ParcelHasCounty : Boolean;
  SwisSBLKey : String;
  TaxSystems, SchoolCode : String;
  NumCleared, NumAdded : Integer;
  TempLen : Integer;
  TempPChar : PChar;
  DelinquentDLLHandle,
  CurrentTaxDLLHandle : THandle;
  ParcelHasOpenDelinquentTaxes : TParcelHasOpenDelinquentTaxesFunction;
  ParcelHasOpenCurrentTaxes : TParcelHasOpenCurrentTaxesFunction;
  InitializeDelinquentDLL,
  CloseDelinquentDLL, CloseCurrentTaxDLL : TGeneralDLLFunction;
  InitializeCurrentTaxDLL : TInitializeCurrentTaxDLLFunction;
  TotalLien, TotalSchool, TotalTown, TotalCounty : LongInt;

begin
  ParcelHasOpenDelinquentTaxes := nil;
  ParcelHasOpenCurrentTaxes := nil;
  CloseDelinquentDLL := nil;
  CloseCurrentTaxDLL := nil;
  DelinquentDLLHandle := 0;
  CurrentTaxDLLHandle := 0;

  Quit := False;
  NumCleared := 0;
  NumAdded := 0;
  Done := False;
  FirstTimeThrough := True;

  TotalLien := 0;
  TotalSchool := 0;
  TotalTown := 0;
  TotalCounty := 0;

    {Load the DLL for checking lien status.}

  If (tsDelinquent in TaxSystemsToCheck)
    then
      begin
        TempLen := Length(DTSDLLName);
        TempPChar := StrAlloc(TempLen + 1);
        StrPCopy(TempPChar, DTSDLLName);

        DelinquentDLLHandle := LoadLibrary(TempPChar);

        If (DelinquentDLLHandle = 0)
          then
            begin
              Quit := True;
              ShowMessage('Unable to load ' + DTSDLLName + '.');
            end
          else
            begin
              @InitializeDelinquentDLL := GetProcAddress(DelinquentDLLHandle, 'InitializeDLL');
              @ParcelHasOpenDelinquentTaxes := GetProcAddress(DelinquentDLLHandle, 'ParcelHasOpenDelinquentTaxes');
              @CloseDelinquentDLL := GetProcAddress(DelinquentDLLHandle, 'CloseDLL');

              If (@InitializeDelinquentDLL = nil)
                then Quit := True
                else InitializeDelinquentDLL(Application);

            end;  {else of If (DelinquentDLLHandle = 0)}

      end;  {If (tsDelinquent in TaxSystemsToCheck)}

  If ((tsSchool in TaxSystemsToCheck) or
      (tsTown in TaxSystemsToCheck) or
      (tsCounty in TaxSystemsToCheck))
    then
      begin
        TempLen := Length(CurrentTaxDLLName);
        TempPChar := StrAlloc(TempLen + 1);
        StrPCopy(TempPChar, CurrentTaxDLLName);

        CurrentTaxDLLHandle := LoadLibrary(TempPChar);

        If (CurrentTaxDLLHandle = 0)
          then
            begin
              Quit := True;
              ShowMessage('Unable to load ' + CurrentTaxDLLName + '.');
            end
          else
            begin
              @InitializeCurrentTaxDLL := GetProcAddress(CurrentTaxDLLHandle, 'InitializeDLL');
              @ParcelHasOpenCurrentTaxes := GetProcAddress(CurrentTaxDLLHandle, 'ParcelHasOpenCurrentTaxes');
              @CloseCurrentTaxDLL := GetProcAddress(CurrentTaxDLLHandle, 'CloseDLL');

              TaxSystems := '';

              If (tsSchool in TaxSystemsToCheck)
                then TaxSystems := TaxSystems + 'SCHOOL';

              If (tsTown in TaxSystemsToCheck)
                then TaxSystems := TaxSystems + 'TOWN';

              If (tsCounty in TaxSystemsToCheck)
                then TaxSystems := TaxSystems + 'COUNTY';

              If (@InitializeCurrentTaxDLL = nil)
                then Quit := True
                else InitializeCurrentTaxDLL(Application, TaxSystems);

            end;  {else of If (CurrentTaxDLLHandle = 0)}

      end;  {If ((tsSchool in TaxSystemsToCheck) or ...}

  If Quit
    then SystemSupport(001, ParcelTable, 'Error loading interface to Delinquent Tax Status.',
                                    UnitName, GlblErrorDlgBox)
    else
      begin
        ParcelTable.First;

        with Sender as TBaseReport do
          begin
            repeat
              If FirstTimeThrough
                then FirstTimeThrough := False
                else ParcelTable.Next;

              If ParcelTable.EOF
                then Done := True;

              SwisSBLKey := ExtractSSKey(ParcelTable);
              ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
              ProgressDialog.UserLabelCaption := 'Number Arrears Flags Added = ' + IntToStr(NumAdded);
              Application.ProcessMessages;

              If ((not Done) and
                  ClearArrearsFlags and
                  ParcelTable.FieldByName('Arrears').AsBoolean)
                then
                  with ParcelTable do
                    try
                      Edit;
                      FieldByName('Arrears').AsBoolean := False;
                      Post;

                      Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                              #9 + 'Cleared');
                      NumCleared := NumCleared + 1;

                    except
                      SystemSupport(001, ParcelTable, 'Error clearing arrears flag for ' + ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                {Now check for delinquent status.}

              SchoolCode := ParcelTable.FieldByName('SchoolCode').Text;

              ParcelHasLien := False;
              ParcelHasSchool := False;
              ParcelHasTown := False;
              ParcelHasCounty := False;

              If ((tsDelinquent in TaxSystemsToCheck) and
                  ParcelHasOpenDelinquentTaxes(Application, SwisSBLKey))
                then
                  begin
                    ParcelHasLien := True;
                    TotalLien := TotalLien + 1;
                  end;

              If ((tsSchool in TaxSystemsToCheck) and
                  ParcelHasOpenCurrentTaxes(Application, SwisSBLKey, SchoolCode, 'SCHOOL'))
                then
                  begin
                    ParcelHasSchool := True;
                    TotalSchool := TotalSchool + 1;
                  end;

              If ((tsTown in TaxSystemsToCheck) and
                  ParcelHasOpenCurrentTaxes(Application, SwisSBLKey, SchoolCode, 'TOWN'))
                then
                  begin
                    ParcelHasTown := True;
                    TotalTown := TotalTown + 1;
                  end;

              If ((tsCounty in TaxSystemsToCheck) and
                  ParcelHasOpenCurrentTaxes(Application, SwisSBLKey, SchoolCode, 'COUNTY'))
                then
                  begin
                    ParcelHasCounty := True;
                    TotalCounty := TotalCounty + 1;
                  end;

              If ((not Done) and
                  (ParcelHasLien or
                   ParcelHasSchool or
                   ParcelHasTown or
                   ParcelHasCounty))
                then
                  with ParcelTable do
                    try
                      Edit;
                      FieldByName('Arrears').AsBoolean := True;
                      Post;

                      Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                              #9 + 'Added');
                      NumAdded := NumAdded + 1;

                    except
                      SystemSupport(002, ParcelTable, 'Error adding arrears flag for ' + ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                                    UnitName, GlblErrorDlgBox);
                    end;

              ReportCancelled := ProgressDialog.Cancelled;

              If (LinesLeft < 5)
                then NewPage;

            until (Done or ReportCancelled);

            If (LinesLeft < 7)
              then NewPage;

            Println('');
            Println('');
            Println(#9 + 'Number cleared = ' + IntToStr(NumCleared));
            Println(#9 + 'Number added = ' + IntToStr(NumAdded) +
                         '  (distinct parcels that were marked with arrears flag)');

            If (tsDelinquent in TaxSystemsToCheck)
              then Println(#9 + '  Parcels with delinquent liens = ' + IntToStr(TotalLien));

            If (tsSchool in TaxSystemsToCheck)
              then Println(#9 + '  Parcels with delinquent school taxes = ' +
                           IntToStr(TotalSchool));

            If (tsTown in TaxSystemsToCheck)
              then Println(#9 + '  Parcels with delinquent town taxes = ' +
                           IntToStr(TotalTown));

            If (tsCounty in TaxSystemsToCheck)
              then Println(#9 + '  Parcels with delinquent county taxes = ' +
                           IntToStr(TotalCounty));

          end;  {with Sender as TBaseReport do}

        If (tsDelinquent in TaxSystemsToCheck)
          then
            begin
              CloseDelinquentDLL(Application);
              FreeLibrary(DelinquentDLLHandle);
              DelinquentDLLHandle := 0;

            end;  {If (tsDelinquent in TaxSystemsToCheck)}

        If ((tsSchool in TaxSystemsToCheck) or
            (tsTown in TaxSystemsToCheck) or
            (tsCounty in TaxSystemsToCheck))
          then
            begin
              CloseCurrentTaxDLL(Application);
              FreeLibrary(CurrentTaxDLLHandle);
              CurrentTaxDLLHandle := 0;

            end;  {If ((tsSchool in TaxSystemsToCheck) or ...}

      end;  {else of If Quit}

end;  {ReportPrint}

{===================================================================}
Procedure TLoadArrearsFlagsFromTaxesForm.FormClose(    Sender: TObject;
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