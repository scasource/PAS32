unit RptDialg;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Dialogs, Zipcopy, locatdir, WinUtils, ShellAPI;

type
  TReportDialog = class(TForm)
    DoneSaveButton: TBitBtn;
    ReportNameEdit: TEdit;
    Label1: TLabel;
    CopyButton: TBitBtn;
    DoneDontSaveButton: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    DirectoryEdit: TEdit;
    ZipCopyDialog: TZipCopyDlg;
    DirectorySpeedButton: TSpeedButton;
    ViewButton: TBitBtn;
    LocateDirectoryDlg: TLocateDirectoryDlg;
    EmailButton: TBitBtn;
    procedure DoneSaveButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DoneDontSaveButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure DirectorySpeedButtonClick(Sender: TObject);
    procedure ViewButtonClick(Sender: TObject);
    procedure EmailButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FileName,
    OrigFileName,
    OrigDirectoryName,
    DirectoryName : String;

    Procedure SaveFile(FileName,
                       DirectoryName : String);

  end;

var
  ReportDialog: TReportDialog;

implementation

{$R *.DFM}

uses Glblvars, SysUtils, Utilitys, PASUtils;

{CHG01182000-3: Allow them to choose a different name or copy right away.}

{==============================================================}
Procedure TReportDialog.FormShow(Sender: TObject);

begin
  LocateDirectoryDlg.Directory := ExpandPASPath(GlblReportDir);
  DirectoryEdit.Text := ExpandPASPath(GlblReportDir);
  ReportNameEdit.Text := FileName;
  OrigDirectoryName := DirectoryEdit.Text;
end;  {FormShow}

{==============================================================}
Procedure TReportDialog.SaveFile(FileName,
                                 DirectoryName : String);

var
  TempFile : TextFile;
  OldFileName : String;

begin
  If (Deblank(OrigDirectoryName) = '')
    then OrigDirectoryName := ExpandPASPath(GlblReportDir);
    
     {Now rename the text file to a recognizable
      name, but to do so, erase the original first.
      This is so that several people can run this job
      at once.}

     {FXX04262000-1: Make sure that the current file name <> the original file
                     name.  If it is, it has already been saved - i.e. they
                     went to Copy first.}

  If (FileName <> OrigFileName)
    then
      begin
        try
          Chdir(OrigDirectoryName);
          OldDeleteFile(FileName);
        except
        end;

        try
          RenameFile(OrigFileName, FileName);
        except
            {If the person has the report dialog up, give them an option of what to do.
             Otherwise, rename to a different extension.}

          If Visible
            then
              begin
                MessageDlg('At the current time, this report can not be saved with the name ' + #13 +
                           FileName + ' because someone else has the file open.' + #13 +
                           'Please save the report with a different name or have the ' + #13 +
                           'person exit the file and try to save it again.', mtError, [mbOK], 0);
                Abort;
              end
            else
              begin
                  {Strip off the extension and rename as .TMP.}

                OldFileName := FileName;
                FileName := GetUpToChar('.', FileName, True) + 'TMP';
                OldDeleteFile(FileName);

                try
                  Rename(TempFile, FileName);
                except
                  RenameFile(OrigFileName, FileName);
                end;

                MessageDlg('The report can not be saved with the standard name ' + OldFileName + #13 +
                           'because the file is currently being used by someone else.' + #13 +
                           'It has been saved with the name ' + FileName + '.',
                           mtInformation, [mbOK], 0);

              end;  {If Visible}

        end;

          {FXX06092003-2(2.07c): Let them change the directory name.}

        If (DirectoryName <> OrigDirectoryName)
          then
            try
              CopyOneFile(AddDirectorySlashes(OrigDirectoryName) + FileName,
                          AddDirectorySlashes(DirectoryName) + FileName);
              ChDir(OrigDirectoryName);
              OldDeleteFile(FileName);

            except
            end;

        ChDir(ExpandPASPath(GlblProgramDir));

         {FXX04272000-1: Reset original file name so rename doesn't cause prob.}

        OrigFileName := FileName;
        OrigDirectoryName := DirectoryName;

      end;  {If (FileName <> OrigFileName)}

end;  {SaveFile}

{==============================================================}
Procedure TReportDialog.DoneSaveButtonClick(Sender: TObject);

begin
  FileName := ReportNameEdit.Text;
  DirectoryName := DirectoryEdit.Text;

  SaveFile(FileName, DirectoryName);

     {This is also called by the copy button, but don't close.}

   If (TButton(Sender).Name = 'DoneSaveButton')
     then Close;

end;  {DoneSaveButtonClick}

{==============================================================}
Procedure TReportDialog.DoneDontSaveButtonClick(Sender: TObject);

begin
  FileName := '';
  DirectoryName := '';

  try
    Chdir(ExpandPASPath(GlblReportDir));
    OldDeleteFile(OrigFileName);
  finally
    ChDir(ExpandPASPath(GlblProgramDir));
  end;

  Close;

end;  {DoneDontSaveButtonClick}

{==============================================================}
Procedure TReportDialog.CopyButtonClick(Sender: TObject);

begin
    {First save the file.}

  DoneSaveButtonClick(Sender);

  with ZipCopyDialog do
    begin
      FileName := ReportNameEdit.Text;
      InitialDir := Copy(DirectoryEdit.Text, 3, 100);
      InitialDrive := Copy(DirectoryEdit.Text, 1, 1);
      SelectFile(DirectoryEdit.Text + FileName);
      Execute;

    end;  {with ZipCopyDialog do}

end;  {CopyButtonClick}

{===============================================================}
Procedure TReportDialog.DirectorySpeedButtonClick(Sender: TObject);

begin
  If LocateDirectoryDlg.Execute
    then DirectoryEdit.Text := LocateDirectoryDlg.Directory;

end;  {DirectorySpeedButtonClick}

{======================================================}
Procedure TReportDialog.ViewButtonClick(Sender: TObject);

var
  PrintFileName, TempStr : String;
  PCLFile : Boolean;
  TempFile : TextFile;
  ReturnCode : Word;
  TempPChar : PChar;

begin
  PrintFileName := ReportNameEdit.Text;
  ChDir(ExpandPASPath(OrigDirectoryName));

    {FXX01212000-1: Allow for recall of PCL format reports.}

  AssignFile(TempFile, PrintFileName);
  Reset(TempFile);
  Readln(TempFile, TempStr);

  PCLFile := (Pos('PCL', TempStr) > 0);

  If PCLFile
    then MessageDlg('Sorry, you can not view a laser only report as text.',
                    mtError, [mbOK], 0)
    else
      begin
        TempStr := 'C:\PROGRA~1\ACCESS~1\WORDPAD ' + PrintFileName;
        GetMem(TempPChar, Length(TempStr) + 1);
        StrPCopy(TempPChar, TempStr);
        ReturnCode := WinExec(TempPChar, SW_Show);
        FreeMem(TempPChar, Length(TempStr) + 1);

        If (ReturnCode < 32)
          then MessageDlg('Word pad failed to bring up the report. Error = ' + IntToStr(ReturnCode) + '.',
                          mtError, [mbOK], 0);

      end;  {else of If PCLFile}

end;  {ViewButtonClick}

{======================================================}
Procedure TReportDialog.EmailButtonClick(Sender: TObject);

{CHG10082003-1(2.07k): Extend email option to more programs.}

var
  AttachmentName, TempStr, PrintFileName : String;
  PCLFile : Boolean;
  TempFile : TextFile;

begin
  DoneSaveButtonClick(Sender);

  PrintFileName := ReportNameEdit.Text;
  ChDir(ExpandPASPath(OrigDirectoryName));

    {FXX01212000-1: Allow for recall of PCL format reports.}

  AssignFile(TempFile, PrintFileName);
  Reset(TempFile);
  Readln(TempFile, TempStr);

  PCLFile := (Pos('PCL', TempStr) > 0);
  CloseFile(TempFile);

  If PCLFile
    then MessageDlg('Sorry, you can not email a laser only report.',
                    mtError, [mbOK], 0)
    else
      begin
           {CHG03232004-4(2.08): Change the email sending process and add it to all needed places.}

        AttachmentName := ExpandPASPath(DirectoryEdit.Text) + ReportNameEdit.Text;

        SendMail('', '', AttachmentName, '', '', '', '', '', True);

      end;  {else of If PCLFile}

end;  {EmailButtonClick}

end.
