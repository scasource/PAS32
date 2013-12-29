unit LetterInsertCodesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TLetterInsertCodesForm = class(TForm)
    InsertCodesListBox: TListBox;
    OKButton: TBitBtn;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  ParcelIDInsert = '<<ParcelID>>';
  LegalAddressInsert = '<<LegalAddress>>';
  OwnerInsert = '<<Owner>>';
  FirstNameInsert = '<<FirstName>>';
  LastNameInsert = '<<LastName>>';
  AssessedValueInsert = '<<AssessedValue>>';
  LandValueInsert = '<<LandValue>>';
  CountyTaxableValueInsert = '<<CountyTaxable>>';
  MunicipalTaxableValueInsert = '<<MunicTaxable>>';
  SchoolTaxableValueInsert = '<<SchoolTaxable>>';
  CountyExemptionTotalInsert = '<<CountyExTot>>';
  MunicipalExemptionTotalInsert = '<<MunicExTot>>';
  SchoolExemptionTotalInsert = '<<SchoolExTot>>';
  PropertyClassInsert = '<<PropertyClass>>';
  AccountNumberInsert = '<<AccountNumber>>';

var
  LetterInsertCodesForm: TLetterInsertCodesForm;

implementation

{$R *.DFM}

{============================================================}
Procedure TLetterInsertCodesForm.FormCreate(Sender: TObject);

begin
  with InsertCodesListBox.Items do
    begin
      Add(ParcelIDInsert);
      Add(LegalAddressInsert);
      Add(OwnerInsert);

        {CHG03172004-2(2.07l2): Add first name and last name inserts.}

      Add(FirstNameInsert);
      Add(LastNameInsert);

      Add(AssessedValueInsert);
      Add(LandValueInsert);
      Add(CountyTaxableValueInsert);
      Add(MunicipalTaxableValueInsert);
      Add(SchoolTaxableValueInsert);
      Add(CountyExemptionTotalInsert);
      Add(MunicipalExemptionTotalInsert);
      Add(SchoolExemptionTotalInsert);

    end;  {with InsertCodesListBox.Items do}

end;  {FormCreate}

end.
