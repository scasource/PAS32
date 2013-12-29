unit dlgSBLEntryUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, Buttons, Db, DBTables, wwdblook;

type
  TdlgEnterSBL = class(TForm)
    edSection: TEdit;
    edSubsection: TEdit;
    edBlock: TEdit;
    edLot: TEdit;
    edSublot: TEdit;
    edSuffix: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    tbSwisCodes: TTable;
    dsSwisCodes: TDataSource;
    cbxSwisCode: TwwDBLookupCombo;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sCurrentSwisSBLKey, sOldSwisSBLKey : String;

    Procedure InitializeForm(_sCurrentSwisSBLKey : String;
                             _ProcessingType : Integer);
  end;

implementation

{$R *.DFM}

uses PASUtils, DataAccessUnit, GlblCnst, GlblVars, PASTypes, Utilitys;

{=======================================================================}
Procedure TdlgEnterSBL.InitializeForm(_sCurrentSwisSBLKey : String;
                                      _ProcessingType : Integer);

var
  SBLRec : SBLRecord;

begin
  sOldSwisSBLKey := sCurrentSwisSBLKey;
  sCurrentSwisSBLKey := _sCurrentSwisSBLKey;
  SBLRec := ExtractSwisSBLFromSwisSBLKey(sCurrentSwisSBLKey);

  with SBLRec do
    begin
      edSection.Text := Trim(Section);
      edSubsection.Text := Trim(Subsection);
      edBlock.Text := Trim(Block);
      edLot.Text := Trim(Lot);
      edSublot.Text := Trim(Sublot);
      edSuffix.Text := Trim(Suffix);
    end;

  _OpenTable(tbSwisCodes, SwisCodeTableName, '', '', _ProcessingType, []);
  _Locate(tbSwisCodes, [SBLRec.SwisCode], '', []);
  cbxSwisCode.Text := SBLRec.SwisCode;

end;  {InitializeForm}

{=====================================================================}
Procedure TdlgEnterSBL.FormKeyPress(    Sender: TObject;
                                    var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NEXTDLGCTL, 0, 0);
        Key := #0;
      end;

end;  {FormKeyPress}

{========================================================}
Procedure TdlgEnterSBL.btnOKClick(Sender: TObject);

begin
  sOldSwisSBLKey := cbxSwisCode.Text +
                    Take(3, edSection.Text) +
                    Take(3, edSubSection.Text) +
                    Take(4, edBlock.Text) +
                    Take(3, edLot.Text) +
                    Take(3, edSublot.Text) +
                    Take(4, edSuffix.Text);
                    
  ModalResult := mrOK;
end;

{========================================================}
Procedure TdlgEnterSBL.btnCancelClick(Sender: TObject);

begin
  ModalResult := mrCancel;
end;

end.
