unit MovePASToAnotherComputerUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, Buttons, AbMeter, ComCtrls, AbBase, AbBrowse,
  AbZBrows, AbZipper, ExtCtrls, ABArcTyp, FileCtrl;

type
  TTransferPASForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    StartButton: TBitBtn;
    SystemTable: TTable;
    ParcelTable: TTable;
    AbZipper: TAbZipper;
    Notebook: TNotebook;
    ProgressGroupBox: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    CurrentlyProcessingFileLabel: TLabel;
    CurrentFileProgressMeter: TAbMeter;
    OverallProgressMeter: TAbMeter;
    GroupBox1: TGroupBox;
    DataCheckBox: TCheckBox;
    PicturesCheckBox: TCheckBox;
    DocumentsCheckBox: TCheckBox;
    ProgramsCheckBox: TCheckBox;
    GrievancesCheckBox: TCheckBox;
    MapsCheckBox: TCheckBox;
    OptionsGroupBox: TGroupBox;
    Label3: TLabel;
    SearcherCanViewNYCheckBox: TCheckBox;
    EditDestinationDrive: TEdit;
    CurrentSectionLabel: TLabel;
    CancelButton: TBitBtn;
    procedure StartButtonClick(Sender: TObject);
    procedure AbZipperArchiveItemProgress(Sender: TObject;
      Item: TAbArchiveItem; Progress: Byte; var Abort: Boolean);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Cancelled : Boolean;
    TransferDirectory : String;

    Procedure CompressData(_BaseDirectory : String;
                           FilesToCompress : String;
                           ExclusionMask : String;
                           ZipFileName : String;
                           SectionName : String);

    Procedure DeleteData(ZipFileName : String;
                         ExclusionMask : String;
                         SectionName : String);

  end;

var
  TransferPASForm: TTransferPASForm;

implementation

{$R *.DFM}

const
  DataZipFileName = 'Data.zip';
  ProgramsZipFileName = 'Programs.zip';
  MapsZipFileName = 'Map.zip';
  DocumentsZipFileName = 'Documents.zip';
  PicturesZipFileName = 'Pictures.zip';

  AutoRunFileName = 'Autorun.inf';
  DecompressionProgramName = 'DecompressPASOnAnotherComputer.exe';

{=======================================================================}
Function AddDirectorySlashes(Directory : String) : String;

{Make sure that this directory name starts and ends with a slash.
 If not, add it.}

begin
  If (Trim(Directory) = '')
    then Result := ''
    else
      begin
        If ((Directory[2] <> ':') and
            (Directory[1] <> '\'))
          then Directory := '\' + Directory;

        If (Directory[Length(Directory)] <> '\')
          then Directory := Directory + '\';

        Result := Directory;

      end;  {else of If (Trim(Directory) = '')}

end;  {AddDirectorySlashes}

{===============================================================}
Procedure DeleteAllFilesInDirectory(Directory : String;
                                    RemoveDirectory : Boolean);

var
  SearchRec : TSearchRec;
  Done, FirstTimeThrough : Boolean;
  Return : Integer;

begin
  Done := False;
  Return := 0;
  FirstTimeThrough := True;
  FindFirst(Directory + '*.*', faAnyFile, SearchRec);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Return := FindNext(SearchRec);

    If (Return <> 0)
      then Done := True;

    If ((not Done) and
        (SearchRec.Name <> '.') and
        (SearchRec.Name <> '..'))
      then
        try
          DeleteFile(Directory + SearchRec.Name);
        except
        end;

  until Done;

  If RemoveDirectory
    then
      try
        RemoveDir(Directory);
      except
      end;

end;  {DeleteAllFilesInDirectory}

{==================================================================}
Function CopyOneFile(SourceName,
                     DestinationName : String) : Boolean;

{Actual copy of file routine that copies from a fully qualified source file name
 to a fully qualified destination name.}

var
  SourceLen, DestLen : Integer;
  SourceNamePChar, DestNamePChar : PChar;

begin
  SourceLen := Length(SourceName);
  DestLen := Length(DestinationName);

  SourceNamePChar := StrAlloc(SourceLen + 1);
  DestNamePChar := StrAlloc(DestLen + 1);

  StrPCopy(SourceNamePChar, SourceName);
  StrPCopy(DestNamePChar, DestinationName);

  Result := CopyFile(SourceNamePChar, DestNamePChar, False);

  StrDispose(SourceNamePChar);
  StrDispose(DestNamePChar);

end;  {CopyOneFile}

{===============================================================}
Procedure TTransferPASForm.AbZipperArchiveItemProgress(    Sender: TObject;
                                                           Item: TAbArchiveItem;
                                                           Progress: Byte;
                                                       var Abort: Boolean);

begin
  CurrentlyProcessingFileLabel.Caption := 'Currently Processing: ' + Item.FileName;
  Abort := Cancelled;
end;  {AbZipperArchiveItemProgress}

{===============================================================}
Procedure TTransferPASForm.CompressData(_BaseDirectory : String;
                                        FilesToCompress : String;
                                        ExclusionMask : String;
                                        ZipFileName : String;
                                        SectionName : String);

begin
  Notebook.PageIndex := 1;

  CurrentSectionLabel.Caption := SectionName;

  with ABZipper do
    begin
      FileName := TransferDirectory + ZipFileName;
      BaseDirectory := _BaseDirectory;
      AddFilesEX(FilesToCompress, ExclusionMask, 0);
      Save;

    end;  {with ABZipper do}

end;  {CompressData}

{===============================================================}
Procedure TTransferPASForm.DeleteData(ZipFileName : String;
                                      ExclusionMask : String;
                                      SectionName : String);

begin
  Notebook.PageIndex := 1;

  CurrentSectionLabel.Caption := SectionName;

  with ABZipper do
    begin
      FileName := TransferDirectory + ZipFileName;
      DeleteFiles(ExclusionMask);
      Save;

    end;  {with ABZipper do}

end;  {CompressData}

{===============================================================}
Procedure TTransferPASForm.StartButtonClick(Sender: TObject);

var
  Continue, CopyData, CopyPrograms,
  CopyMaps, CopyPictures,
  CopyDocuments, CopyGrievances,
  CurrentSearcherCanSeeNY, SystemSettingsChanged : Boolean;
  CurrentProgramDirectory,  DestinationDirectory,
  CurrentDataDirectory, ExclusionMask,
  CurrentDrive, CurrentPictureDirectory,
  CurrentMapDirectory, CurrentDocumentDirectory : String;

begin
  StartButton.Enabled := False;
  CancelButton.Enabled := True;
  Continue := True;
  Cancelled := False;
  SystemSettingsChanged := False;

  CopyData := DataCheckBox.Checked;
  CopyPrograms := ProgramsCheckBox.Checked;
  CopyMaps := MapsCheckBox.Checked;
  CopyPictures := PicturesCheckBox.Checked;
  CopyDocuments := DocumentsCheckBox.Checked;
  CopyGrievances := GrievancesCheckBox.Checked;

  try
    ParcelTable.Open;
  except
    Continue := False;
    MessageDlg('One or more people are still using PAS.' + #13 +
               'Please have them exit and try again.',
               mtError, [mbOK], 0);
  end;

  If Continue
    then
      begin
        ParcelTable.Close;
        SystemSettingsChanged := True;

          {Get the directories of files that we need to copy.
           Also, set the system table so that it reflects the drive and
           ability to see NY of the system that we are copying too.}

        with SystemTable do
          try
            Open;

            CurrentDrive := FieldByName('DriveLetter').Text;
            CurrentSearcherCanSeeNY := FieldByName('SearcherCanViewNY').AsBoolean;

            CurrentDataDirectory := CurrentDrive + ':' +
                                    AddDirectorySlashes(FieldByName('SysDataDir').Text);

            CurrentPictureDirectory := CurrentDrive + ':' +
                                       AddDirectorySlashes(FieldByName('PictureDir').Text);
            CurrentMapDirectory := CurrentDrive + ':' +
                                   AddDirectorySlashes(FieldByName('MapDirectory').Text);
            CurrentDocumentDirectory := CurrentDrive + ':' +
                                        AddDirectorySlashes(FieldByName('DocumentDir').Text);
            CurrentProgramDirectory := CurrentDrive + ':' +
                                       AddDirectorySlashes(FieldByName('SysProgramDir').Text);

            TransferDirectory := CurrentProgramDirectory + 'Transfer\';

            If DirectoryExists(TransferDirectory)
              then DeleteAllFilesInDirectory(TransferDirectory, True);

            try
              MkDir(TransferDirectory);
            except
            end;

            Edit;
            FieldByName('DriveLetter').Text := EditDestinationDrive.Text;
            FieldByName('SearcherCanViewNY').AsBoolean := SearcherCanViewNYCheckBox.Checked;
            Post;

            Close;
          except
            MessageDlg('Error updating system settings.', mtError, [mbOK], 0);
            Continue := False;
          end;

      end;  {If Continue}

  If Continue
    then
      begin
        If CopyData
          then
            begin
                {Since Abbrevia does not handle multiple file specifications
                 for inclusion or exclusion, we must include all and delete
                 afterwards.}

              ExclusionMask := 'b*.*';

              CompressData(CurrentDataDirectory, '*.*', ExclusionMask,
                           DataZipFileName, 'Compressing Data');

              DeleteData(DataZipFileName, 'Sort*.*', 'Removing sort files from archive.');

              DeleteData(DataZipFileName, '*.zip', 'Removing zip files from archive.');

              If not CopyGrievances
                then DeleteData(DataZipFileName, 'g*.*', 'Removing grievance files from archive.');

            end;  {If CopyData}

        If ((not Cancelled) and
            CopyPrograms)
          then
            begin
              CompressData(CurrentProgramDirectory, '*.EXE', 'MovePAS*.EXE',
                           ProgramsZipFileName, 'Compressing Programs');

              CompressData(CurrentProgramDirectory, '*.DLL', 'MovePAS*.EXE',
                           ProgramsZipFileName, 'Compressing DLLs');

              CompressData(CurrentProgramDirectory, '*.ICO', 'MovePAS*.EXE',
                           ProgramsZipFileName, 'Compressing Icons');

            end;  {If ((not Cancelled) and ...}

        If ((not Cancelled) and
            CopyMaps)
          then CompressData(CurrentMapDirectory, '*.*', '*.zip',
                            MapsZipFileName, 'Compressing Maps');

        If ((not Cancelled) and
            CopyPictures)
          then CompressData(CurrentPictureDirectory, '*.*', '*.zip',
                            PicturesZipFileName, 'Compressing Pictures');

        If ((not Cancelled) and
            CopyDocuments)
          then CompressData(CurrentDocumentDirectory, '*.*', '*.zip',
                            DocumentsZipFileName, 'Compressing Documents');

          {Make sure to close the last archive.}

        AbZipper.CloseArchive;

      end;  {If Continue}

    {Return the system setting to their original settings.}

  If SystemSettingsChanged
    then
      with SystemTable do
        try
          Open;

          Edit;
          FieldByName('DriveLetter').Text := CurrentDrive;
          FieldByName('SearcherCanViewNY').AsBoolean := CurrentSearcherCanSeeNY;
          Post;

          Close;
        except
          MessageDlg('Error updating system settings.', mtError, [mbOK], 0);
          Continue := False;
        end;

    {Now setup the installation script and copy the information to the cd.}

  If ((not Cancelled) and
      Continue and
      (MessageDlg('Please insert a blank, formatted cd and click OK when it is ready.',
                  mtConfirmation, [mbOK, mbCancel], 0) = idOK))
    then
      begin
        If CopyData
          then CopyOneFile(TransferDirectory + DataZipFileName,
                           DestinationDirectory + DataZipFileName);

        If CopyPrograms
          then CopyOneFile(TransferDirectory + ProgramsZipFileName,
                           DestinationDirectory + ProgramsZipFileName);

        If CopyMaps
          then CopyOneFile(TransferDirectory + MapsZipFileName,
                           DestinationDirectory + MapsZipFileName);

        If CopyPictures
          then CopyOneFile(TransferDirectory + PicturesZipFileName,
                           DestinationDirectory + PicturesZipFileName);

        If CopyDocuments
          then CopyOneFile(TransferDirectory + DocumentsZipFileName,
                           DestinationDirectory + DocumentsZipFileName);

(*        CopyOneFile(CurrentProgramDirectory + AutoRunFileName,
                    DestinationDirectory + AutoRunFileName);

        CopyOneFile(CurrentProgramDirectory + DecompressionProgramName,
                    DestinationDirectory + DecompressionProgramName);*)

        MessageDlg('Please eject the cd and insert it into the other computer.' + #13 +
                   'When you eject the cd, please choose to format this cd so' + #13 +
                   'that it can be read on any computer.',
                   mtInformation, [mbOK], 0);

      end;  {If Continue}

  StartButton.Enabled := True;
  CancelButton.Enabled := False;

end;  {StartButtonClick}

{===============================================================}
Procedure TTransferPASForm.CancelButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you really sure you want to cancel this transfer?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        Cancelled := True;
        StartButton.Enabled := True;
        CancelButton.Enabled := False;
        Notebook.PageIndex := 0;

      end;  {If (MessageDlg(' ...}

end;  {CancelButtonClick}

end.
