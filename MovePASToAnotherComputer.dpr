program MovePASToAnotherComputer;

uses
  Forms,
  MovePASToAnotherComputerUnit in 'MovePASToAnotherComputerUnit.pas' {TransferPASForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TTransferPASForm, TransferPASForm);
  Application.Run;
end.
