unit SplashScreen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TMultiP, ExtCtrls, Db, DBTables;

type
  TSplashScreenForm = class(TForm)
    Panel1: TPanel;
    SplashImage: TPMultiImage;
    SystemTable: TTable;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SplashScreenForm: TSplashScreenForm;

implementation

{$R *.DFM}

uses Utilitys;

{======================================================}
Procedure TSplashScreenForm.FormCreate(Sender: TObject);

var
  TempFile : TSearchRec;
  ReturnCode : Integer;

begin
  try
    SystemTable.Open;

      {FXX01282004-1(2.08): Make sure that we include the drive letter for the displaying th
                            splash screen.}

    ReturnCode := FindFirst(SystemTable.FieldByName('DriveLetter').Text + ':' +
                            AddDirectorySlashes(SystemTable.FieldByName('SysProgramDir').Text) +
                            'SPLASH\*.*',
                            faAnyFile, TempFile);

    If (ReturnCode = 0)
      then
        begin
          repeat
            ReturnCode := FindNext(TempFile);
          until ((ReturnCode <> 0) or
                 ((TempFile.Name <> '.') and
                  (TempFile.Name <> '..')));

            {FXX02012005-2(2.8.3.3)-2: Make sure to include the drive and fully qualified directory when setting the image name.}

          SplashImage.ImageName := SystemTable.FieldByName('DriveLetter').Text + ':' +
                                   AddDirectorySlashes(SystemTable.FieldByName('SysProgramDir').Text) +
                                   'SPLASH\' + TempFile.Name;

        end;  {If (ReturnCode <> 0)}

    SystemTable.Close;

  except
  end;

end;  {FormCreate}


end.
