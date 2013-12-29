unit UpdateVillageNamesAndAddresses;

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
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask, Types,
  wwdblook, Psock, NMFtp, ShellAPI;

type
  TUpdateVillagesNameAndAddressForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    Label1: TLabel;
    ParcelTable: TTable;
    Label6: TLabel;
    SwisCodeListBox: TListBox;
    Label2: TLabel;
    SwisCodeTable: TwwTable;
    NMFTP: TNMFTP;
    NotificationEMailAddressComboBox: TwwDBLookupCombo;
    EmailAddressesTable: TwwTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    SelectedSwisCodes : TStringList;

    Procedure InitializeForm;  {Open the tables and setup.}

    Function RecMeetsCriteria(ParcelTable : TTable) : Boolean;

    Procedure ExtractNamesAndAddresses(var ExtractFile : TextFile;
                                       var Cancelled : Boolean);

    Procedure SendExtractFileToWebsite(    ExtractFileName : String;
                                       var Cancelled : Boolean);

    Procedure SendEmailToVillage(EMailAddress : String;
                                 ExtractFileName : String);


  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, UtilEXSD,
     PASTypes, Prog;

{$R *.DFM}

{========================================================}
procedure TUpdateVillagesNameAndAddressForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TUpdateVillagesNameAndAddressForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'UpdateVillageNamesAndAddresses';  {mmm}

  OpenTablesForForm(Self, NextYear);

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, GlblProcessingType, GetTaxRlYr);

end;  {InitializeForm}

{===================================================================}
Function TUpdateVillagesNameAndAddressForm.RecMeetsCriteria(ParcelTable : TTable) : Boolean;

begin
  Result := (SelectedSwisCodes.IndexOf(ParcelTable.FieldByName('SwisCode').Text) > -1);
end;  {RecMeetsCriteria}

{===================================================================}
Procedure TUpdateVillagesNameAndAddressForm.ExtractNamesAndAddresses(var ExtractFile : TextFile;
                                                                     var Cancelled : Boolean);

var
  FirstTimeThrough, Done : Boolean;
  SwisSBLKey : String;

begin
  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
  ParcelTable.First;

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

     If ParcelTable.EOF
       then Done := True;

     If ((not Done) and
         RecMeetsCriteria(ParcelTable))
       then
         begin
           SwisSBLKey := ExtractSSKey(ParcelTable);

           with ParcelTable do
             Writeln(ExtractFile, SwisSBLKey,
                                  FormatExtractField(FieldByName('Name1').Text),
                                  FormatExtractField(FieldByName('Name2').Text),
                                  FormatExtractField(FieldByName('Address1').Text),
                                  FormatExtractField(FieldByName('Address2').Text),
                                  FormatExtractField(FieldByName('Street').Text),
                                  FormatExtractField(FieldByName('City').Text),
                                  FormatExtractField(FieldByName('State').Text),
                                  FormatExtractField(FieldByName('Zip').Text),
                                  FormatExtractField(FieldByName('ZipPlus4').Text));


         end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;
    Cancelled := ProgressDialog.Cancelled;

  until (Done or Cancelled);

  ProgressDialog.Finish;

end;  {ExtractNameAddrChanges}

{===================================================================}
Procedure TUpdateVillagesNameAndAddressForm.SendExtractFileToWebsite(    ExtractFileName : String;
                                                                     var Cancelled : Boolean);

var
  Connected : Boolean;
  TempFile : File of Byte;
  _FileSize : LongInt;

begin
  Connected := True;
  try
    NMFTP.Connect;
  except
    Connected := False;
    MessageDlg('There was an error connecting to the website for uploading.' + #13 +
               'Please make sure that you are connected to the internet and try again.',
               mtError, [mbOK], 0);
    Cancelled := True;
  end;

  If Connected
    then
      try
        NMFTP.ChangeDir('www');
        NMFTP.ChangeDir('nameaddressupdates');
      except
        MessageDlg('There was an error changing to www/nameaddressupdates.' + #13 +
                   'Please make sure that you are connected to the internet and try again.',
                   mtError, [mbOK], 0);
        Cancelled := True;
      end;

  If (Connected and
      (not Cancelled))
    then
      try
        NMFTP.Mode(MODE_ASCII);

        AssignFile(TempFile, ExtractFileName);
        Reset(TempFile);
        _FileSize := FileSize(TempFile);
        CloseFile(TempFile);

        NMFTP.Allocate(_FileSize);
        NMFTP.Upload(ExtractFileName, StripPath(ExtractFileName));

      except
        Cancelled := True;
        MessageDlg('There was an error sending the extract file ' + ExtractFileName + ' to the website.' + #13 +
                   'Please try again.', mtError, [mbOK], 0);
      end;

  NMFTP.Disconnect;

end;  {SendExtractFileToWebsite}

{===================================================================}
Procedure TUpdateVillagesNameAndAddressForm.SendEmailToVillage(EMailAddress : String;
                                                               ExtractFileName : String);

var
  TempStr : String;
  TempPChar : PChar;
  TempLen : Integer;

begin
  TempStr := 'mailto:' + EMailAddress + '?subject=PAS Name \ Address Update' +
             '&body=There is now an update for PAS names and addresses from the Town of Ramapo.';

  TempLen := Length(TempStr);
  TempPChar := StrAlloc(TempLen + 1);
  StrPCopy(TempPChar, TempStr);

  ShellExecute(0, 'open', TempPChar, nil, nil, SW_SHOWNORMAL);

  StrDispose(TempPChar);

end;  {SendEmailToVillage}

{==============================================================}
Procedure TUpdateVillagesNameAndAddressForm.StartButtonClick(Sender: TObject);

var
  ExtractFile : TextFile;
  VillageName, ExtractFileName,
  CurrentDateStr, CurrentTimeStr : String;
  I : Integer;
  Cancelled : Boolean;

begin
  Cancelled := False;
  SelectedSwisCodes := TStringList.Create;
  VillageName := '';

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    If SwisCodeListBox.Selected[I]
      then
        begin
          SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

          If (VillageName <> '')
            then VillageName := VillageName + '_';

          VillageName := VillageName + Trim(Copy(SwisCodeListBox.Items[I], 10, 20));

        end;  {If SwisCodeListBox.Selected[I]}

  CurrentTimeStr := TimeToStr(Now);
  CurrentTimeStr := StringReplace(CurrentTimeStr, ':', '', [rfReplaceAll]);
  CurrentTimeStr := StringReplace(CurrentTimeStr, ' ', '', [rfReplaceAll]);

  CurrentDateStr := DateToStr(Date);
  CurrentDateStr := StringReplace(CurrentDateStr, '/', '', [rfReplaceAll]);
  CurrentDateStr := StringReplace(CurrentDateStr, '\', '', [rfReplaceAll]);

  ExtractFileName := GlblDrive + ':' + AddDirectorySlashes(GlblExportDir) +
                     VillageName + '_' + CurrentDateStr + '_' +
                     CurrentTimeStr + '.csv';

  AssignFile(ExtractFile, ExtractFileName);
  Rewrite(ExtractFile);

  ExtractNamesAndAddresses(ExtractFile, Cancelled);

  CloseFile(ExtractFile);

  If not Cancelled
    then SendExtractFileToWebsite(ExtractFileName, Cancelled);

  If not Cancelled
    then SendEmailToVillage(NotificationEMailAddressComboBox.Text, ExtractFileName);

  If Cancelled
    then MessageDlg('The name \ address update file was NOT sent because the extract was cancelled or the connection failed.' + #13 +
                    'Please try again.', mtWarning, [mbOK], 0)
    else MessageDlg('The name \address update file for the village of ' + VillageName + ' was sent and' +
                    ' is now available for updating the village files.', mtInformation, [mbOK], 0);

  SelectedSwisCodes.Free;

end;  {StartButtonClick}

{===================================================================}
Procedure TUpdateVillagesNameAndAddressForm.FormClose(    Sender: TObject;
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