program LoadLawrenceBillToAddresses;

uses
  Forms,
  LoadLawrenceBillToAddressesUnit in 'LoadLawrenceBillToAddressesUnit.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
