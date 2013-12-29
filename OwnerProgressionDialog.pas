unit OwnerProgressionDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, StdCtrls, Buttons, ComCtrls, ExtCtrls, MemoDialog;

type
  TSalesOwnerProgressionForm = class(TForm)
    SalesTable: TTable;
    AuditNameAddressTable: TTable;
    Panel1: TPanel;
    ProgressionOfOwnersLabel: TLabel;
    Panel2: TPanel;
    OwnerProgressionListView: TListView;
    pnlHistoryOfOwners: TPanel;
    lbHistoryOfOwnersHeader: TLabel;
    Panel4: TPanel;
    lstHistoryOfOwners: TListView;
    tbHistoryOfOwners: TTable;
    Panel3: TPanel;
    btnAddHistoryOfOwnersEntry: TBitBtn;
    MemoDialogBox: TMemoDialogBox;
    procedure btnAddHistoryOfOwnersEntryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }

    sDeedBook, sDeedPage, sDeedDate, sSwisSBLKey : String;

    Procedure LoadHistoryOfOwnersGrid;

    Procedure InitializeForm(_SwisSBLKey : String;
                             _DeedBook : String;
                             _DeedPage : String;
                             _DeedDate : String);
  end;

var
  SalesOwnerProgressionForm: TSalesOwnerProgressionForm;

implementation

{$R *.DFM}

uses GlblCnst, WinUtils, GlblVars, PASUtils, PASTypes, Utilitys, DataAccessUnit;


{=====================================================================}
Procedure TSalesOwnerProgressionForm.LoadHistoryOfOwnersGrid;

begin
  lbHistoryOfOwnersHeader.Caption := 'History of owners for ' +
                                      ConvertSwisSBLToDashDot(sSwisSBLKey);

  tbHistoryOfOwners.TableName := 'PHistoryOfOwners';
  tbHistoryOfOwners.Open;

  _SetRange(tbHistoryOfOwners, [sSwisSBLKey, '1/1/1900', 0], [sSwisSBLKey, '1/1/3000', 0], '', []);

  ClearListView(lstHistoryOfOwners);
  FillInListView(lstHistoryOfOwners, tbHistoryOfOwners,
                 ['DeedBook', 'DeedPage', 'DeedDate', 'SequenceNumber', 'Comment'],
                 False, True);

end;  {LoadHistoryOfOwnersGrid}

{=====================================================================}
Procedure TSalesOwnerProgressionForm.InitializeForm(_SwisSBLKey : String;
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
  then LoadHistoryOfOwnersGrid
  else
  begin
    pnlHistoryOfOwners.Visible := False;

      {FXX07062010-1(2.26.1.4)[I7277]: Incorrect height.}

    Height := 347;
  end;

end;  {InitializeForm}

{========================================================================}
Procedure TSalesOwnerProgressionForm.btnAddHistoryOfOwnersEntryClick(Sender: TObject);

var
  I : Integer;

begin
  MemoDialogBox.MemoCaption := lbHistoryOfOwnersHeader.Caption;

  If MemoDialogBox.Execute
  then
  begin
    For I := 0 to (MemoDialogBox.MemoLines.Count - 1) do
      with tbHistoryOfOwners do
        try
          Insert;
          FieldByName('SwisSBLKey').AsString := sSwisSBLKey;
          FieldByName('SequenceNumber').AsInteger := I + 1;
          FieldByName('DeedBook').AsString := sDeedBook;
          FieldByName('DeedPage').AsString := sDeedPage;
          FieldByName('DeedDate').AsString := sDeedDate;
          TMemoField(FieldByName('Comment')).AsString := MemoDialogBox.MemoLines[I];
          Post;
        except
        end;

    LoadHistoryOfOwnersGrid;

  end;  {If MemoDialogBox.Execute}

end;  {btnAddHistoryOfOwnersEntryClick}

{=======================================================================}
Procedure TSalesOwnerProgressionForm.FormClose(    Sender: TObject;
                                               var Action: TCloseAction);
begin
  _CloseTablesForForm(Self);
end;

end.
