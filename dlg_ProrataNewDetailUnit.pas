unit dlg_ProrataNewDetailUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, Db, DBTables, Wwtable, wwdblook;

type
  Tdlg_ProrataNewDetail = class(TForm)
    gb_ProrataYear: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    ed_RollYear: TEdit;
    gb_OtherInformation: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    cb_HomesteadCode: TComboBox;
    ed_Days: TEdit;
    ed_TaxRate: TEdit;
    ed_ExemptionAmount: TEdit;
    Label7: TLabel;
    cb_Levy: TComboBox;
    Label8: TLabel;
    ed_TaxAmount: TEdit;
    tb_LeviesToProrate: TTable;
    Label9: TLabel;
    ed_CalculationDays: TEdit;
    Label10: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ed_RollYearExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ed_ExemptionAmountExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    EditMode, RollYear, GeneralTaxType, LevyDescription, HomesteadCode : String;
    Days, ExemptionAmount : LongInt;
    TaxRate, TaxAmount : Double;
  end;

implementation

{$R *.DFM}

uses DataAccessUnit, GlblCnst, Utilitys, WinUtils;

{=========================================================================}
Procedure Tdlg_ProrataNewDetail.FormShow(Sender: TObject);

var
  Levy : String;

begin
  _OpenTable(tb_LeviesToProrate, '', '', '', NoProcessingType, []);

  with tb_LeviesToProrate do
    while not EOF do
      begin
        Levy := FieldByName('GeneralTaxType').AsString + '|' +
                FieldByName('Description').AsString;

        If _Compare(cb_Levy.Items.IndexOf(Levy), -1, coEqual)
          then cb_Levy.Items.Add(Levy);

        Next;

      end;  {while not EOF do}

  If _Compare(EditMode, emEdit, coEqual)
    then
      begin
        Caption := 'Edit the prorata detail.';
        ed_RollYear.Text := RollYear;
        MakeNonDataAwareEditReadOnly(ed_RollYear, False, '');
        cb_Levy.SetFocus;

        cb_Levy.ItemIndex := cb_Levy.Items.IndexOf(GeneralTaxType + '|' + LevyDescription);
        cb_HomesteadCode.ItemIndex := cb_HomesteadCode.Items.IndexOf(HomesteadCode);
        ed_Days.Text := IntToStr(Days);
        ed_TaxRate.Text := FormatFloat(ExtendedDecimalDisplay_BlankZero, TaxRate);
        ed_ExemptionAmount.Text := IntToStr(ExemptionAmount);
        ed_TaxAmount.Text := FormatFloat(DecimalEditDisplay, TaxAmount);

      end;  {If _Compare(EditMode, emEdit, coEqual)}

end;  {FormShow}

{================================================================}
Procedure Tdlg_ProrataNewDetail.FormKeyPress(    Sender: TObject;
                                             var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NextDlgCtl, 0, 0);
        Key := #0;
      end;  {If (Key = #13)}

end;  {FormKeyPress}

{=========================================================================}
Procedure Tdlg_ProrataNewDetail.ed_RollYearExit(Sender: TObject);

begin
  cb_Levy.SetFocus;
end;

{=========================================================================}
Procedure Tdlg_ProrataNewDetail.ed_ExemptionAmountExit(Sender: TObject);

var
  TaxAmount, TaxRate : Double;
  CalculationDays, ExemptionAmount, Days : LongInt;

begin
  try
    Days := StrToInt(ed_Days.Text);
  except
    Days := 0;
  end;

  try
    CalculationDays := StrToInt(ed_CalculationDays.Text);
  except
    CalculationDays := 0;
  end;

  try
    TaxRate := Roundoff(StrToFloat(ed_TaxRate.Text), 6);
  except
    TaxRate := 0;
  end;

  try
    ExemptionAmount := StrToInt(ed_ExemptionAmount.Text);
  except
    ExemptionAmount := 0;
  end;

  If _Compare(ed_TaxAmount.Text, coBlank)
    then
      begin
        TaxAmount := (ExemptionAmount / 100) * TaxRate * (Days / CalculationDays);
        ed_TaxAmount.Text := FormatFloat(DecimalEditDisplay, TaxAmount);
      end;

end;  {ed_ExemptionAmountExit}

{=========================================================================}
Procedure Tdlg_ProrataNewDetail.OKButtonClick(Sender: TObject);

var
  Levy : String;

begin
  RollYear := ed_RollYear.Text;
  Levy := cb_Levy.Items[cb_Levy.ItemIndex];

  GeneralTaxType := Copy(Levy, 1, (Pos('|', Levy) - 1));
  LevyDescription := Copy(Levy, (Pos('|', Levy) + 1), 200);
  HomesteadCode := cb_HomesteadCode.Text;

  try
    Days := StrToInt(ed_Days.Text);
  except
    Days := 0;
  end;

  try
    TaxRate := Roundoff(StrToFloat(ed_TaxRate.Text), 6);
  except
    TaxRate := 0;
  end;

  try
    ExemptionAmount := StrToInt(ed_ExemptionAmount.Text);
  except
    ExemptionAmount := 0;
  end;

  try
    TaxAmount := Roundoff(StrToFloat(ed_TaxAmount.Text), 2);
  except
    TaxAmount := 0;
  end;

  ModalResult := mrOK;

end;  {OKButtonClick}

{================================================================}
Procedure Tdlg_ProrataNewDetail.FormClose(    Sender: TObject;
                                             var Action: TCloseAction);

begin
  _CloseTablesForForm(Self);
  Action := caFree;
end;

end.
