program UpdatePAS;

uses
  Forms,
  UpdatePASUnit in 'UpdatePASUnit.pas' {UpdatePASForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TUpdatePASForm, UpdatePASForm);
  Application.Run;
end.
