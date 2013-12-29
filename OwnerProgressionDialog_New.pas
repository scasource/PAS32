unit OwnerProgressionDialog_New;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, StdCtrls, Buttons, ComCtrls, ExtCtrls, MemoDialog, DBCtrls,
  Mask;

type
  TSalesOwnerProgressionForm_New = class(TForm)
    SalesTable: TTable;
    AuditNameAddressTable: TTable;
    tbHistoryOfOwners: TTable;
    PageControl1: TPageControl;
    tbsProgressionOfOwners: TTabSheet;
    Panel1: TPanel;
    Panel5: TPanel;
    ProgressionOfOwnersLabel: TLabel;
    OwnerProgressionListView: TListView;
    tbsHistoryOfOwners: TTabSheet;
    Panel3: TPanel;
    btnAddHistoryOfOwnersEntry: TBitBtn;
    Panel2: TPanel;
    memHistory: TDBMemo;
    dsHistoryOfOwners: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBNavigator1: TDBNavigator;
    edDeedBook: TDBEdit;
    edDeedPage: TDBEdit;
    edDeedDate: TDBEdit;
    tbHistoryOfOwnersSwisSBLKey: TStringField;
    tbHistoryOfOwnersSequenceNumber: TIntegerField;
    tbHistoryOfOwnersDeedBook: TStringField;
    tbHistoryOfOwnersDeedPage: TStringField;
    tbHistoryOfOwnersDeedDate: TDateField;
    tbHistoryOfOwnersComment: TStringField;
    tbHistoryOfOwnersNote: TMemoField;
    edParcelID: TDBEdit;
    tbHistoryOfOwnersPrintKey: TStringField;
    procedure btnAddHistoryOfOwnersEntryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbHistoryOfOwnersCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }

    sDeedBook, sDeedPage, sDeedDate, sSwisSBLKey : String;

    Procedure SetHistoryOfOwnersCaption;

    Procedure InitializeForm(_SwisSBLKey : String;
                             _DeedBook : String;
                             _DeedPage : String;
                             _DeedDate : String);
  end;

var
  SalesOwnerProgressionForm_New: TSalesOwnerProgressionForm_New;

implementation

{$R *.DFM}

uses GlblCnst, WinUtils, GlblVars, PASUtils, PASTypes, Utilitys, DataAccessUnit;


{=====================================================================}
Procedure TSalesOwnerProgressionForm_New.SetHistoryOfOwnersCaption;

begin
  tbHistoryOfOwners.TableName := 'PHistoryOfOwners';
  tbHistoryOfOwners.Open;

  _SetRange(tbHistoryOfOwners, [sSwisSBLKey, '1/1/1900', 0], [sSwisSBLKey, '1/1/3000', 0], '', []);

  tbsHistoryOfOwners.Caption := 'History of Owners (' + IntToStr(tbHistoryOfOwners.RecordCount) + ')';

  tbHistoryOfOwners.Last;

end;  {LoadHistoryOfOwnersGrid}

{=====================================================================}
Procedure TSalesOwnerProgressionForm_New.InitializeForm(_SwisSBLKey : String;
                                                    _DeedBook : String;
                                                    _DeedPage : String;
                                                    _DeedDate : String);

var
  NewNameAddrArray, OldNameAddrArray : NameAddrArray;
  ListItem : TListItem;
  I : Integer;

begin
  sSwisSBLKey := _SwisSBLKey;
  sDeedBook := _DeedBook;
  sDeedPage := _DeedPage;
  sDeedDate := _DeedDate;
  ProgressionOfOwnersLabel.Caption := 'Progression of owners for ' +
                                      ConvertSwisSBLToDashDot(sSwisSBLKey);
  OpenTablesForForm(Self, ThisYear);

  SetRangeOld(AuditNameAddressTable, ['SwisSBLKey', 'Date', 'Time'],
              [sSwisSBLKey, '1/1/1900', ''],
              [sSwisSBLKey, '1/1/3000', '']);

  with AuditNameAddressTable do
    begin
      Last;

      while not BOF do
      begin
        FillInNameAddrArray(FieldByName('OldName1').Text,
                            FieldByName('OldName2').Text,
                            FieldByName('OldAddress1').Text,
                            FieldByName('OldAddress2').Text,
                            FieldByName('OldStreet').Text,
                            FieldByName('OldCity').Text,
                            FieldByName('OldState').Text,
                            FieldByName('OldZip').Text,
                            FieldByName('OldZipPlus4').Text,
                            True, False, OldNameAddrArray);

        FillInNameAddrArray(FieldByName('NewName1').Text,
                            FieldByName('NewName2').Text,
                            FieldByName('NewAddress1').Text,
                            FieldByName('NewAddress2').Text,
                            FieldByName('NewStreet').Text,
                            FieldByName('NewCity').Text,
                            FieldByName('NewState').Text,
                            FieldByName('NewZip').Text,
                            FieldByName('NewZipPlus4').Text,
                            True, False, NewNameAddrArray);

        with OwnerProgressionListView do
          ListItem := Items.Insert(Items.Count);

        ListItem.Caption := FieldByName('Date').Text;
        ListItem.SubItems.Add(FormatDateTime(TimeFormat,
                                             FieldByName('Time').AsDateTime));
        ListItem.SubItems.Add(OldNameAddrArray[1]);
        ListItem.SubItems.Add(NewNameAddrArray[1]);
        ListItem.SubItems.Add(FieldByName('User').Text);

        For I := 2 to 6 do
          If ((Deblank(OldNameAddrArray[I]) <> '') or
              (Deblank(NewNameAddrArray[I]) <> ''))
            then
              begin
                with OwnerProgressionListView do
                  ListItem := Items.Insert(Items.Count);

                ListItem.SubItems.Add('');
                ListItem.SubItems.Add(OldNameAddrArray[I]);
                ListItem.SubItems.Add(NewNameAddrArray[I]);

              end;  {If ((Deblank(OldNameAddrArray[I]) <> '') or ...}

          {Insert a blank line.}

        with OwnerProgressionListView do
          Items.Insert(Items.Count);

        Prior;

      end;  {while not BOF do}

    end;  {with AuditNameAddressTable do}

  If glblShowHistoryOfOwners
  then SetHistoryOfOwnersCaption
  else tbsHistoryOfOwners.TabVisible := False;

end;  {InitializeForm}

{========================================================================}
Procedure TSalesOwnerProgressionForm_New.tbHistoryOfOwnersCalcFields(DataSet: TDataSet);

begin
  with tbHistoryOfOwners do
    FieldByName('PrintKey').AsString := ConvertSBLOnlyToDashDot(Copy(FieldByName('SwisSBLKey').AsString, 7, 20));

end;  {tbHistoryOfOwnersCalcFields}

{========================================================================}
Procedure TSalesOwnerProgressionForm_New.btnAddHistoryOfOwnersEntryClick(Sender: TObject);

begin
  with tbHistoryOfOwners do
    try
      Insert;
      FieldByName('SwisSBLKey').AsString := sSwisSBLKey;
      FieldByName('DeedBook').AsString := sDeedBook;
      FieldByName('DeedPage').AsString := sDeedPage;
      FieldByName('DeedDate').AsString := sDeedDate;
      Post;
    except
    end;

  memHistory.SetFocus;

end;  {btnAddHistoryOfOwnersEntryClick}

{=======================================================================}
Procedure TSalesOwnerProgressionForm_New.FormClose(    Sender: TObject;
                                               var Action: TCloseAction);
begin
  _CloseTablesForForm(Self);
end;

end.
