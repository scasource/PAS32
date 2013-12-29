unit SalesExtractLogMaintenance;

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
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, AbBase, AbBrowse,
  AbZBrows, AbUnZper, FileCtrl;

type
  TSalesExtractLogForm = class(TForm)
    DataSource: TwwDataSource;
    SalesExtractLogTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    DBGrid: TwwDBGrid;
    CloseButton: TBitBtn;
    DBNavigator: TDBNavigator;
    TitleLabel: TLabel;
    AbUnZipper: TAbUnZipper;
    ViewButton: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ViewButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils;

{$R *.DFM}


{========================================================}
Procedure TSalesExtractLogForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TSalesExtractLogForm.InitializeForm;

begin
  UnitName := 'SalesExtractLogMaintenance';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

    {FXX04302004-1(2.08): Fix the display format of the time.}

  TFloatField(SalesExtractLogTable.FieldByName('Time')).DisplayFormat := TimeFormat;

end;  {InitializeForm}

{===================================================================}
Procedure TSalesExtractLogForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{===================================================================}
Procedure TSalesExtractLogForm.ViewButtonClick(Sender: TObject);

{View the sales report from this extract.}

var
  TempDir : String;
  TempStr : String;
  ReturnCode : Word;
  TempPChar : PChar;

begin
  TempDir := ExpandPASPath(GlblProgramDir) + 'TEMP\';

  If not DirectoryExists(TempDir)
    then CreateDir(TempDir);

  with ABUnzipper do
    try
      BaseDirectory := TempDir;
      FileName := SalesExtractLogTable.FieldByName('ZipFile').Text;
      ExtractFiles('SALES.RPT');
      TempStr := 'C:\Program Files\Accessories\WORDPAD ' + TempDir + 'SALES.RPT';
      GetMem(TempPChar, Length(TempStr) + 1);
      StrPCopy(TempPChar, TempStr);
      ReturnCode := WinExec(TempPChar, SW_Show);
      FreeMem(TempPChar, Length(TempStr) + 1);

      If (ReturnCode < 32)
        then MessageDlg('Word pad failed to bring up the report. Error = ' + IntToStr(ReturnCode) + '.',
                        mtError, [mbOK], 0);
    except

    end;  {with ABUnzipper do}

end;  {ViewButtonClick}

{===================================================================}
Procedure TSalesExtractLogForm.FormClose(    Sender: TObject;
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
