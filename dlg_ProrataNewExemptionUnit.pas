unit dlg_ProrataNewExemptionUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, Db, DBTables, Wwtable, wwdblook;

type
  Tdlg_ProrataNewExemption = class(TForm)
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
    cb_ExemptionCode: TwwDBLookupCombo;
    tb_ExemptionCodes: TwwTable;
    cb_HomesteadCode: TComboBox;
    ed_CountyAmount: TEdit;
    ed_MunicipalAmount: TEdit;
    ed_SchoolAmount: TEdit;
    Label7: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ed_RollYearExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    EditMode, RollYear, ExemptionCode, HomesteadCode : String;
    CountyAmount, MunicipalAmount, SchoolAmount : LongInt;
  end;

implementation

{$R *.DFM}

uses DataAccessUnit, GlblCnst, Utilitys, WinUtils;

{=========================================================================}
Procedure Tdlg_ProrataNewExemption.FormShow(Sender: TObject);

begin
  _OpenTable(tb_ExemptionCodes, ExemptionCodesTableName, '', '', ThisYear, []);

  If _Compare(EditMode, emEdit, coEqual)
    then
      begin
        Caption := 'Edit the prorated exemption.';
        ed_RollYear.Text := RollYear;
        MakeNonDataAwareEditReadOnly(ed_RollYear, False, '');
        cb_ExemptionCode.SetFocus;

        _Locate(tb_ExemptionCodes, [ExemptionCode], '', []);

        cb_ExemptionCode.Text := ExemptionCode;
        cb_HomesteadCode.ItemIndex := cb_HomesteadCode.Items.IndexOf(HomesteadCode);
        ed_CountyAmount.Text := IntToStr(CountyAmount);
        ed_MunicipalAmount.Text := IntToStr(MunicipalAmount);
        ed_SchoolAmount.Text := IntToStr(SchoolAmount);

      end;  {If _Compare(EditMode, emEdit, coEqual)}

end;  {FormShow}

{=========================================================================}
Procedure Tdlg_ProrataNewExemption.FormKeyPress(    Sender: TObject;
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
Procedure Tdlg_ProrataNewExemption.ed_RollYearExit(Sender: TObject);

begin
  cb_ExemptionCode.SetFocus;
end;  {ed_RollYearExit}

{=========================================================================}
Procedure Tdlg_ProrataNewExemption.OKButtonClick(Sender: TObject);

begin
  RollYear := ed_RollYear.Text;
  ExemptionCode := cb_ExemptionCode.Text;
  HomesteadCode := cb_HomesteadCode.Text;

  try
    CountyAmount := StrToInt(ed_CountyAmount.Text);
  except
    CountyAmount := 0;
  end;

  try
    MunicipalAmount := StrToInt(ed_MunicipalAmount.Text);
  except
    MunicipalAmount := 0;
  end;

  try
    SchoolAmount := StrToInt(ed_SchoolAmount.Text);
  except
    SchoolAmount := 0;
  end;

  ModalResult := mrOK;

end;  {OKButtonClick}

{================================================================}
Procedure Tdlg_ProrataNewExemption.FormClose(    Sender: TObject;
                                             var Action: TCloseAction);

begin
  _CloseTablesForForm(Self);
  Action := caFree;
end;

end.
