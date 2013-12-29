unit UpdateIndividualComputerSettingsForm;

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
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Gauges, AbMeter,
  AbBase, AbBrowse, AbZBrows, AbUnZper;

type
  THandle = Integer;
  TGeneralDLLProcedure = Procedure (Application : TApplication);
  TExecuteOneItemProcedure = Procedure (    Application : TApplication;
                                        var CurrentRecordNo : Integer;
                                        var TotalNumRecords : Integer);
  TShortStringFunction = Function : ShortString;
  TBooleanFunction = Function : Boolean;
  TIntegerFunction = Function : Integer;
  TRealFunction = Function : Real;

  TUpdateIndividualSettingsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    StartButton: TBitBtn;
    ProgressGroupBox: TGroupBox;
    Notebook: TNotebook;
    CurrentlyUnzippingLabel: TLabel;
    AbMeter: TAbMeter;
    ExecutableProcessingLabel: TLabel;
    ExecutableGauge: TGauge;
    ExecutableNameLabel: TLabel;
    AbUnZipper: TAbUnZipper;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure StartButtonClick(Sender: TObject);
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

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils;

{$R *.DFM}

const
  UnzipAction = 'UNZIP';
  ExecutableAction = 'EXECUTE';

{========================================================}
Procedure TUpdateIndividualSettingsForm.InitializeForm;

begin
  UnitName := 'UpdateIndividualComputerSettingsForm';  {mmm}

end;  {InitializeForm}

{===================================================================}
Procedure TUpdateIndividualSettingsForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{===============================================}
Function GetField(var Line : String) : String;

var
  CommaPos : Integer;

begin
  Result := '';
  CommaPos := Pos(',', Line);

  If (CommaPos = 0)
    then Result := Line
    else
      begin
        Result := Copy(Line, 1, (CommaPos - 1));
        Delete(Line, 1, CommaPos);
      end;

end;  {GetField}

{=======================================================}
Procedure TUpdateIndividualSettingsForm.StartButtonClick(Sender: TObject);

var
  TempStr, LogFileName, Action, ExecutableName, Line,
  ZipFileName, FileNameToExtract, Destination : String;
  TempLen : Integer;
  TempPChar : PChar;
  CurrentDLLHandle : THandle;
  InitializeDLL : TGeneralDLLProcedure;
  ExecuteOneItem : TExecuteOneItemProcedure;
  GetCurrentlyProcessing : TShortStringFunction;
  GetApplicationName : TShortStringFunction;
  GetProgressPercent : TIntegerFunction;
  DLLFinished : TBooleanFunction;
  CurrentRecordNo, TotalNumRecords : Integer;
  ScriptFile, LogFile : TextFile;

begin
  CurrentlyUnzippingLabel.Caption := '';
  ProgressGroupBox.Visible := True;

  AssignFile(ScriptFile, GlblProgramDir + 'UpdatePAS.SPT');
  Reset(ScriptFile);
  AssignFile(LogFile, GlblErrorFileDir + 'UpdatePASLogFor.TXT');
  Rewrite(LogFile);

  while not EOF(ScriptFile) do
    begin
      Readln(ScriptFile, Line);

      Action := GetField(Line);

      If (Action = UnzipAction)
        then
          begin
            ZipFileName := GlblProgramDir + 'DELIVERIES\' + GetField(Line);
            FileNameToExtract := GetField(Line);
            Destination := GlblProgramDir + GetField(Line);
            Notebook.PageIndex := 0;

            with AbUnzipper do
              begin
                FileName := ZipFileName;
                BaseDirectory := Destination;
                CurrentlyUnzippingLabel.Caption := 'Extracting ' + FileNameToExtract +
                                                   ' to ' + Destination;
                Application.ProcessMessages;
                ExtractFiles(FileNameToExtract);

                If (LogFileName <> '')
                  then Writeln(LogFile, 'Unzipped file ' + FileName +
                                        ' from archive ' + ZipFileName +
                                        ' to ' + Destination + '.');

              end;  {with AbUnzipper do}

          end;  {If (Action = UnzipAction)}

      If (Action = ExecutableAction)
        then
          begin
            ExecutableName := GlblProgramDir + GetField(Line);

            If (Notebook.PageIndex <> 1)
              then Notebook.PageIndex := 1;

            ExecutableGauge.Progress := 0;

            TempLen := Length(ExecutableName);
            TempPChar := StrAlloc(TempLen + 1);
            StrPCopy(TempPChar, ExecutableName);

            CurrentDLLHandle := LoadLibrary(TempPChar);

            If (CurrentDLLHandle <> 0)
              then
                begin
                  @InitializeDLL := GetProcAddress(CurrentDLLHandle, 'InitializeDLL');
                  @GetCurrentlyProcessing := GetProcAddress(CurrentDLLHandle, 'GetCurrentlyProcessing');
                  @GetApplicationName := GetProcAddress(CurrentDLLHandle, 'GetApplicationName');
                  @DLLFinished := GetProcAddress(CurrentDLLHandle, 'DLLFinished');
                  @ExecuteOneItem := GetProcAddress(CurrentDLLHandle, 'ExecuteOneItem');

                  If (@InitializeDLL <> nil)
                    then
                      begin
                        InitializeDLL(Application);
                        ExecutableNameLabel.Caption := GetApplicationName;
                        CurrentRecordNo := 0;
                        TotalNumRecords := 0;

                        while not DLLFinished do
                          begin
                            try
                              ExecutableGauge.Progress := Trunc((CurrentRecordNo / TotalNumRecords) * 100);
                            except
                              ExecutableGauge.Progress := 0;
                            end;

                            ExecutableProcessingLabel.Caption := 'Processing: ' +
                                                                 GetCurrentlyProcessing;

                            ExecuteOneItem(Application, CurrentRecordNo, TotalNumRecords);
                            Application.ProcessMessages;

                          end;  {while not DLLFinished do}

                      end;  {If (@InitializeDLL <> nil)}

                  FreeLibrary(CurrentDLLHandle);
                  CurrentDLLHandle := 0;

                end;  {If (CurrentDLLHandle <> 0)}

            StrDispose(TempPChar);

          end;  {If (Action = ExecutableAction)}

    end;  {while not EOF(ScriptFile) do}

  CloseFile(ScriptFile);
  CloseFile(LogFile);

  MessageDlg('The settings have been updated.' + #13 +
             'Please restart the Property Assessment System to activate the changes.',
             mtInformation, [mbOK], 0);
  ProgressGroupBox.Visible := False;

end;  {StartButtonClick}

{===================================================================}
Procedure TUpdateIndividualSettingsForm.FormClose(    Sender: TObject;
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
