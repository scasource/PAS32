unit dlg_ProrataNewUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask;

type
  Tdlg_ProrataNew = class(TForm)
    gb_ProrataYear: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    ed_ProrataYear: TEdit;
    gb_OtherInformation: TGroupBox;
    Label1: TLabel;
    cb_Category: TComboBox;
    Label2: TLabel;
    ed_EffectiveDate: TMaskEdit;
    ed_RemovalDate: TMaskEdit;
    Label3: TLabel;
    Label4: TLabel;
    ed_CalculationDate: TMaskEdit;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ed_ProrataYearExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ProrataYear, Category : String;
    EffectiveDate, RemovalDate, CalculationDate : TDateTime;
  end;

implementation

{$R *.DFM}

uses GlblCnst, GlblVars;

{=========================================================================}
Procedure Tdlg_ProrataNew.FormShow(Sender: TObject);

begin
  ed_ProrataYear.Text := ProrataYear;
  ed_CalculationDate.Text := DateToStr(Date);
end;  {FormShow}

{=========================================================================}
Procedure Tdlg_ProrataNew.FormKeyPress(Sender: TObject; var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NextDlgCtl, 0, 0);
        Key := #0;
      end;  {If (Key = #13)}

end;  {FormKeyPress}

{=========================================================================}
Procedure Tdlg_ProrataNew.ed_ProrataYearExit(Sender: TObject);

begin
  cb_Category.SetFocus;
end;

{=========================================================================}
Procedure Tdlg_ProrataNew.OKButtonClick(Sender: TObject);

begin
  ProrataYear := ed_ProrataYear.Text;

  case cb_Category.ItemIndex of
    0 : Category := mtfnCounty;
    1 : case GlblMunicipalityType of
          MTTown : Category := mtfnTown;
          MTCity : Category := mtfnCity;
          MTVillage : Category := mtfnVillage;
        end;

    2 : Category := mtfnSchool;
    3 : Category := mtfnVillage;
    else Category := mtfnTown;
  end;

  Category := ANSIUpperCase(Category);

  try
    EffectiveDate := StrToDate(ed_EffectiveDate.Text);
  except
  end;

  try
    RemovalDate := StrToDate(ed_RemovalDate.Text);
  except
  end;

  try
    CalculationDate := StrToDate(ed_CalculationDate.Text);
  except
  end;

  ModalResult := mrOK;

end;  {OKButtonClick}

end.
