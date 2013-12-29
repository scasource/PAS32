unit ParcelAuditPrintForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, RPCanvas, RPrinter, RPFiler, RPDefine, RPBase,
  RPTXFilr, Db, DBTables, Wwtable;

type
  TParcelAuditPrintDialog = class(TForm)
    UserIDGroupBox: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    StartUserEdit: TEdit;
    AllUsersCheckBox: TCheckBox;
    ToEndOfUsersCheckBox: TCheckBox;
    EndUserEdit: TEdit;
    DateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    HeaderLabel: TLabel;
    PrintButton: TBitBtn;
    CancelButton: TBitBtn;
    PrintDialog: TPrintDialog;
    TextFiler: TTextFiler;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    AuditTrailTable: TwwTable;
    AuditQuery: TQuery;
    procedure PrintButtonClick(Sender: TObject);
    procedure TextFilerPrintHeader(Sender: TObject);
    procedure TextFilerPrint(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
    procedure AllUsersCheckBoxClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SwisSBLKey : String;
    PrintAllUsers,
    PrintToEndOfUsers,
    PrintAllDates,
    PrintToEndOfDates : Boolean;
    StartUser,
    EndUser : String;
    StartDate,
    EndDate : TDateTime;

    Function RecordInRange(Date : TDateTime;
                           User : String) : Boolean;

    Procedure SetHeaderLabel(SwisSBLKey : String);
  end;

var
  ParcelAuditPrintDialog: TParcelAuditPrintDialog;

implementation

{$R *.DFM}

uses PASUtils, Preview, GlblVars, WinUtils, PASTypes, Utilitys, GlblCnst,
     DataAccessUnit;

{=============================================================}
Procedure TParcelAuditPrintDialog.FormShow(Sender: TObject);

{FXX08142002-2: This information was in FormCreate, but it should have been
                in FormShow since the form is autocreated, but the
                global variables are not yet set at this point.}

begin
    {CHG06092010-3(2.26.1)[I7208]: Allow for supervisor equivalents.}

  If ((not UserIsSupervisor(GlblUserName)) and
      (not GlblAllowAuditAccessToAll))
    then
      begin
        UserIDGroupBox.Visible := False;

          {If not the supervisor, set the start and end ranges the same.}

        PrintAllUsers := False;
        PrintToEndOfUsers := False;
        StartUser := Take(10, GlblUserName);
        EndUser := Take(10, GlblUserName);

      end;  {If (GlblUserName <> 'SUPERVISOR')}

end;  {FormShow}

{=============================================================}
Procedure TParcelAuditPrintDialog.SetHeaderLabel(SwisSBLKey : String);

begin
  HeaderLabel.Caption := 'Print audit trail for ' +
                         ConvertSwisSBLToDashDot(SwisSBLKey);
end;  {SetHeaderLabel}

{=============================================================}
Procedure TParcelAuditPrintDialog.AllDatesCheckBoxClick(Sender: TObject);

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

{=============================================================}
Procedure TParcelAuditPrintDialog.AllUsersCheckBoxClick(Sender: TObject);

begin

 If AllUsersCheckBox.Checked
    then
      begin
        ToEndofUsersCheckBox.Checked := False;
        ToEndofUsersCheckBox.Enabled := False;
        StartUserEdit.Text := '';
        StartUserEdit.Enabled := False;
        StartUserEdit.Color := clBtnFace;
        EndUserEdit.Text := '';
        EndUserEdit.Enabled := False;
        EndUserEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(UserIdGroupBox);

end;  {AllUsersCheckBoxClick}

{=============================================================}
Procedure TParcelAuditPrintDialog.PrintButtonClick(Sender: TObject);

var
  TextFileName, NewFileName : String;
  Quit, Continue : Boolean;

begin
  Quit := False;
  Continue := True;

  StartDate := 0;
  EndDate := 0;

    {FXX04232003-1(2.07): Make it so that they don't have to select a date range.}

  If ((StartDateEdit.Text = '  /  /    ') and
      (EndDateEdit.Text = '  /  /    ') and
      (not AllDatesCheckBox.Checked) and
      (not ToEndOfDatesCheckBox.Checked))
    then
      begin
        AllDatesCheckBox.Checked := True;
        PrintAllDates := True;
      end
    else
      If AllDatesCheckBox.Checked
        then PrintAllDates := True
        else
          begin
            try
              StartDate := StrToDate(StartDateEdit.Text);
            except
              Continue := False;
              MessageDlg('Sorry, ' + StartDateEdit.Text + ' is not a valid start date.' + #13 +
                         'Please correct and try again.', mtError, [mbOK], 0);
            end;

            If ToEndOfDatesCheckBox.Checked
              then PrintToEndOfDates := True
              else
                try
                  EndDate := StrToDate(EndDateEdit.Text);
                except
                  Continue := False;
                  MessageDlg('Sorry, ' + EndDateEdit.Text + ' is not a valid end date.' + #13 +
                             'Please correct and try again.', mtError, [mbOK], 0);
                end;

          end;  {else of If PrintAllDates.Checked}

  EndUser := '';
  StartUser := '';
  PrintAllUsers := False;
  PrintToEndOfUsers := False;

  If AllUsersCheckBox.Checked
    then PrintAllUsers := True
    else
      begin
        StartUser := StartUserEdit.Text;

        If ToEndOfUsersCheckBox.Checked
          then PrintToEndOfUsers := True
          else EndUser := EndUserEdit.Text;

      end;  {else of If AllUsersCheckBox.Checked}

  If ((Deblank(StartUser) = '') and
      (Deblank(EndUser) = '') and
      (not PrintAllUsers) and
      (not PrintToEndOfUsers))
    then
      begin
        AllUsersCheckBox.Checked := True;
        PrintAllUsers := True;
      end;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If (Continue and
      PrintDialog.Execute)
    then
      begin
        TextFiler.SetFont('Courier New', 10);

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

        If not Quit
          then
            begin
                {CHG02282001-1: Allow everybody to everyone elses changes.}

              If GlblAllowAuditAccessToAll
                then PrintAllUsers := True;

              If not Quit
                then
                  begin
                    GlblPreviewPrint := False;

                    TextFiler.SetFont('Courier New', 10);

                    TextFileName := GetPrintFileName(Self.Caption, True);
                    TextFiler.FileName := TextFileName;

                      {FXX01211998-1: Need to set the LastPage property so that
                                      long rolls aren't a problem.}

                    TextFiler.LastPage := 30000;

                    TextFiler.Execute;

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

                  end;  {If not Quit}

              Close;

            end;  {If not Quit}

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{===================================================================}
Function TParcelAuditPrintDialog.RecordInRange(Date : TDateTime;
                                               User : String) : Boolean;


begin
  Result := True;

  If not PrintAllDates
    then
      begin
        If (Date < StartDate)
          then Result := False;

        If ((not PrintToEndOfDates) and
            (Date > EndDate))
          then Result := False;

      end;  {If not PrintAllDates}

  If not PrintAllUsers
    then
      begin
        If (Take(10, User) < Take(10, StartUser))
          then Result := False;

        If ((not PrintToEndOfUsers) and
            (Take(10, User) > Take(10, EndUser)))
          then Result := False;

      end;  {If not PrintAllUsers}

end;  {RecordInRange}

{===================================================================}
Procedure TParcelAuditPrintDialog.TextFilerPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 13.0, 0, BoxLineNone, 0);

        {Print the date and page number.}

      Println(Take(43, GetMunicipalityName) +
              Center('Audit Trail Report', 43) +
              RightJustify('Date: ' + DateToStr(Date) +
                           '  Time: ' + FormatDateTime(TimeFormat, Now), 43));

      Println(RightJustify('Page: ' + IntToStr(CurrentPage), 129));

      Print(#9 + 'For Dates: ');
      If PrintAllDates
        then Println(' All')
        else
          begin
            Println(' ' + DateToStr(StartDate));

            If PrintToEndOfDates
              then Println(' End')
              else Println(' ' + DateToStr(EndDate));

          end;  {else of If AllDatesCheckBox.Checked}

      Print(#9 + 'For Users: ');
      If PrintAllUsers
        then Println(' All')
        else
          begin
            Print(' ' + RTrim(StartUser) + ' to ');

            If PrintToEndOfUsers
              then Println(' End')
              else Println(' ' + EndUser);

          end;  {else of If PrintAllUsers}

      Println('');

      ClearTabs;
      SetTab(10.5, pjLeft, 2.2, 0, BOXLINENONE, 0);   {Old Value}
      Println(#9 + 'Old Value');

      ClearTabs;
      SetTab(0.2, pjCenter, 2.0, 0, BOXLINEBOTTOM, 0);   {SBL}
      SetTab(2.3, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {Date Entered}
      SetTab(3.5, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Time}
      SetTab(4.4, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {User}
      SetTab(5.5, pjCenter, 0.4, 0, BOXLINEBOTTOM, 0);   {Year}
      SetTab(6.0, pjLeft, 1.9, 0, BOXLINEBOTTOM, 0);   {FormName}
      SetTab(8.0, pjLeft, 2.4, 0, BOXLINEBOTTOM, 0);   {Label Name}
      SetTab(10.5, pjLeft, 2.5, 0, BOXLINEBOTTOM, 0);   {Old Value}

      Println(#9 + 'Parcel ID' +
              #9 + 'Date ' +
              #9 + 'Time' +
              #9 + 'User' +
              #9 + 'Yr' +
              #9 + 'Screen' +
              #9 + 'Field' +
              #9 + 'New Value');

      Println('');

      ClearTabs;
      SetTab(0.2, pjLeft, 2.0, 0, BOXLINEBOTTOM, 0);   {SBL}
      SetTab(2.3, pjLeft, 1.0, 0, BOXLINEBOTTOM, 0);   {Date Entered}
      SetTab(3.5, pjLeft, 0.8, 0, BOXLINEBOTTOM, 0);   {Time}
      SetTab(4.4, pjLeft, 1.0, 0, BOXLINEBOTTOM, 0);   {User}
      SetTab(5.5, pjLeft, 0.4, 0, BOXLINEBOTTOM, 0);   {Year}
      SetTab(6.0, pjLeft, 1.9, 0, BOXLINEBOTTOM, 0);   {FormName}
      SetTab(8.0, pjLeft, 2.4, 0, BOXLINEBOTTOM, 0);   {Label Name}
      SetTab(10.5, pjLeft, 2.5, 0, BOXLINEBOTTOM, 0);   {Old Value}

    end;  {with Sender as TBaseReport do}

end;  {TextFilerPrintHeader}

{===================================================================}
Procedure TParcelAuditPrintDialog.TextFilerPrint(Sender: TObject);

var
  TempStr : String;
  Done, FirstTimeThrough, Quit : Boolean;
  NumChanged : LongInt;
  PreviousDate, PreviousTime,
  PreviousUser, PreviousScreen : String;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  NumChanged := 0;

    {CHG07102005-1(2.8.5.5): Change the audit trail access to SQL to avoid using an index.}

  with AuditQuery do
    try
      SQL.Clear;
      SQL.Add('Select * from AuditTable where');
      SQL.Add(FormatSQLConditional('SwisSBLKey', [SwisSBLKey], coEqual, []));
      Open;
    except
    end;  {with AuditQuery do}

(*  AuditTrailTable.Open;
  SetRangeOld(AuditTrailTable,
              ['SwisSBLKey', 'Date', 'Time'],
              [SwisSBLKey, '1/1/1900', ''],
              [SwisSBLKey, '1/1/2300', '']); *)

  with Sender as TBaseReport do
    begin
      PreviousDate := '';
      PreviousTime := '';
      PreviousUser := '';
      PreviousScreen := '';

        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else AuditQuery.Next;

        If AuditQuery.EOF
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              Application.ProcessMessages;

              with AuditQuery do
                If RecordInRange(FieldByName('Date').AsDateTime,
                                 FieldByName('User').Text)
                  then
                    begin
                      NumChanged := NumChanged + 1;
                      TempStr := FieldByName('OldValue').Text;

                      If (Deblank(TempStr) = '')
                        then TempStr := '{none}';

                        {FXX11171997-3: The field "FormName" was being printed
                                        out, but should be "ScreenName".}

                        {FXX12221998-3: If the parcel ID, user year, date and time are all the
                                        same, then print as one change.}

                      If ((PreviousDate = AuditQuery.FieldByName('Date').Text) and
                          (PreviousTime = AuditQuery.FieldByName('Time').Text) and
                          (Take(30, PreviousScreen) = Take(30, AuditQuery.FieldByName('ScreenName').Text)) and
                          (Take(10, PreviousUser) = Take(10, AuditQuery.FieldByName('User').Text)))
                        then Print(#9 + #9 + #9 + #9 + #9 + #9)
                        else Print(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                                   #9 + FieldByName('Date').Text +
                                   #9 + FormatDateTime(TimeFormat, FieldByName('Time').AsDateTime) +
                                   #9 + FieldByName('User').Text +
                                   #9 + FieldByName('TaxRollYr').Text +
                                   #9 + FieldByName('ScreenName').Text);

                      Println(#9 + FieldByName('LabelName').Text +
                              #9 + TempStr);

                      TempStr := FieldByName('NewValue').Text;

                      If (Deblank(TempStr) = '')
                        then TempStr := '{none}';

                      Println(#9 +
                              #9 +
                              #9 +
                              #9 +
                              #9 +
                              #9 +
                              #9 +
                              #9 + TempStr);
                      Println('');

                        {FXX12221998-3: If the parcel ID, user year, date and time are all the
                                        same, then print as one change.}
                        {FXX08061999-1: Only update the previous info if it actually changed.}

                      PreviousDate := AuditQuery.FieldByName('Date').Text;
                      PreviousTime := AuditQuery.FieldByName('Time').Text;
                      PreviousScreen := AuditQuery.FieldByName('ScreenName').Text;
                      PreviousUser := AuditQuery.FieldByName('User').Text;

                    end;  {with AuditQuery do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 8)
                then NewPage;

            end;  {If not (Done or Quit)}

      until (Done or Quit);

        {FXX01231998-5: Tell them if nothing in range.}

      If (NumChanged = 0)
        then Println('None.');

    end;  {with Sender as TBaseReport do}

end;  {TextFilerPrint}

{==============================================================}
Procedure TParcelAuditPrintDialog.ReportPrint(Sender: TObject);

var
  ReportTextFile : TextFile;

begin
  AssignFile(ReportTextFile, TextFiler.FileName);
  Reset(ReportTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, ReportTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(ReportTextFile);

end;  {ReportPrint}


end.