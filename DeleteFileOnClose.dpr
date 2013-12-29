program DeleteFileOnClose;

uses
  Forms,
  DeleteFileOnCloseUnit in 'DeleteFileOnCloseUnit.pas' {DeleteFilesOnCloseForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDeleteFilesOnCloseForm, DeleteFilesOnCloseForm);
  Application.Run;
end.
