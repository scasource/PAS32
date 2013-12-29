unit NewLetterDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, Db, DBTables, Buttons, ExtCtrls;

type
  TNewLetterDialogForm = class(TForm)
    LetterNameEdit: TEdit;
    Label1: TLabel;
    AutomaticMergeCheckListBox: TCheckListBox;
    Label2: TLabel;
    MergeLetterDefinitionsTable: TTable;
    GrievanceLetterCodeTable: TTable;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    WordProcessorToUseRadioGroup: TRadioGroup;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LetterName, UnitName : String;
    WordProcessorToUse : Integer;
  end;

var
  NewLetterDialogForm: TNewLetterDialogForm;

implementation

{$R *.DFM}

uses GlblCnst, WinUtils, GlblVars, PASUtils;

const
  IncLetterDate = 0;
  IncMailingAddress = 1;
  IncParcelID = 2;
  IncLegalAddress = 3;

  wpWord = 0;
  wpWordPerfect = 1;

{==============================================================}
Procedure TNewLetterDialogForm.FormCreate(Sender: TObject);

begin
  UnitName := 'NewLetterDialog';

  OpenTablesForForm(Self, NextYear);

end;  {FormCreate}

{==============================================================}
Procedure InsertMergeField(MergeLetterDefinitionsTable : TTable;
                           LetterName : String;
                           Category : String;
                           MergeFieldName : String);

begin
  with MergeLetterDefinitionsTable do
    try
      Insert;
      FieldByName('LetterName').Text := LetterName;
      FieldByName('Category').Text := Category;
      FieldByName('MergeFieldName').Text := MergeFieldName;
      Post;
    except
      Cancel;  {An exception will probably only be raised if for some reason it already exists and we don't care.}
    end;

end;  {InsertMergeField}

{============================================================}
Procedure TNewLetterDialogForm.OKButtonClick(Sender: TObject);

var
  Continue : Boolean;

begin
  Continue := True;

  If (LetterNameEdit.Text = '')
    then
      begin
        Continue := False;
        MessageDlg('Please enter a name for this letter template.',
                   mtError, [mbOK], 0);
        LetterNameEdit.SetFocus;

      end;  {If (LetterNameEdit.Text = '')}

  If (Continue and
      FindKeyOld(GrievanceLetterCodeTable, ['LetterName'],
                 [LetterNameEdit.Text]))
    then
      begin
        Continue := False;
        LetterNameEdit.SetFocus;
        MessageDlg('Sorry, the letter template ' + LetterNameEdit.Text +
                   'has already been created.' + #13 +
                   'Please choose a different name for this letter template.',
                   mtError, [mbOK], 0);

      end;  {If (Continue and ...}

  If Continue
    then
      begin
        LetterName := LetterNameEdit.Text;

        with GrievanceLetterCodeTable do
          try
            Insert;
            FieldByName('LetterName').Text := LetterName;
            FieldByName('LetterType').AsInteger := dtMSWord;
            Post;
          except
            SystemSupport(001, GrievanceLetterCodeTable,
                          'Error posting letter code ' + LetterName + '.',
                          UnitName, GlblErrorDlgBox);
          end;

        case WordProcessorToUseRadioGroup.ItemIndex of
          wpWord : WordProcessorToUse := dtMSWord;
          wpWordPerfect : WordProcessorToUse := dtWordPerfect;
        end;

        If AutomaticMergeCheckListBox.Checked[IncLetterDate]
          then InsertMergeField(MergeLetterDefinitionsTable, LetterName,
                                'General', 'LetterDate');

        If AutomaticMergeCheckListBox.Checked[IncMailingAddress]
          then
            begin
              InsertMergeField(MergeLetterDefinitionsTable, LetterName, 'Parcel', 'Name1');
              InsertMergeField(MergeLetterDefinitionsTable, LetterName, 'Parcel', 'Name2');
              InsertMergeField(MergeLetterDefinitionsTable, LetterName, 'Parcel', 'Address1');
              InsertMergeField(MergeLetterDefinitionsTable, LetterName, 'Parcel', 'Address2');
              InsertMergeField(MergeLetterDefinitionsTable, LetterName, 'Parcel', 'Address3');
              InsertMergeField(MergeLetterDefinitionsTable, LetterName, 'Parcel', 'Address4');

            end;  {If AutomaticMergeCheckListBox.Checked[IncMailingAddress]}

        If AutomaticMergeCheckListBox.Checked[IncParcelID]
          then InsertMergeField(MergeLetterDefinitionsTable, LetterName,
                                'Parcel', 'ParcelID');

        If AutomaticMergeCheckListBox.Checked[IncLegalAddress]
          then InsertMergeField(MergeLetterDefinitionsTable, LetterName,
                                'Parcel', 'LegalAddress');

        ModalResult := mrOK;

      end;  {If Continue}

end;  {OKButtonClick}


end.
