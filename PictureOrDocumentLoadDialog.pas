unit PictureOrDocumentLoadDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TMultiP, ExtCtrls, Buttons, Types, MemoDialog;

type
  TLoadPicturesOrDocumentsDialog = class(TForm)
    InstructionLabel: TLabel;
    OK: TBitBtn;
    CancelButton: TBitBtn;
    ScrollBox: TScrollBox;
    ItemPanel4: TPanel;
    Panel8: TPanel;
    PMultiImage4: TPMultiImage;
    CheckBox4: TCheckBox;
    Memo4: TMemo;
    Button4: TButton;
    ItemPanel5: TPanel;
    Panel10: TPanel;
    PMultiImage5: TPMultiImage;
    CheckBox5: TCheckBox;
    Memo5: TMemo;
    Button5: TButton;
    ItemPanel6: TPanel;
    Panel12: TPanel;
    PMultiImage6: TPMultiImage;
    CheckBox6: TCheckBox;
    Memo6: TMemo;
    Button6: TButton;
    ItemPanel1: TPanel;
    Panel7: TPanel;
    PMultiImage1: TPMultiImage;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Button1: TButton;
    ItemPanel2: TPanel;
    Panel3: TPanel;
    PMultiImage2: TPMultiImage;
    CheckBox2: TCheckBox;
    Memo2: TMemo;
    Button2: TButton;
    ItemPanel3: TPanel;
    Panel5: TPanel;
    PMultiImage3: TPMultiImage;
    CheckBox3: TCheckBox;
    Memo3: TMemo;
    Button3: TButton;
    ItemLabel1: TLabel;
    ItemLabel2: TLabel;
    ItemLabel3: TLabel;
    ItemLabel4: TLabel;
    ItemLabel5: TLabel;
    ItemLabel6: TLabel;
    MemoDialogBox: TMemoDialogBox;
    DirectoryLabel1: TLabel;
    DirectoryLabel2: TLabel;
    DirectoryLabel3: TLabel;
    DirectoryLabel4: TLabel;
    DirectoryLabel5: TLabel;
    DirectoryLabel6: TLabel;
    ItemPanel8: TPanel;
    ItemLabel8: TLabel;
    DirectoryLabel8: TLabel;
    Panel2: TPanel;
    PMultiImage8: TPMultiImage;
    CheckBox8: TCheckBox;
    Memo8: TMemo;
    Button8: TButton;
    ItemPanel7: TPanel;
    ItemLabel7: TLabel;
    DirectoryLabel7: TLabel;
    Panel6: TPanel;
    PMultiImage7: TPMultiImage;
    CheckBox7: TCheckBox;
    Memo7: TMemo;
    Button7: TButton;
    ItemPanel9: TPanel;
    ItemLabel9: TLabel;
    DirectoryLabel9: TLabel;
    Panel11: TPanel;
    PMultiImage9: TPMultiImage;
    CheckBox9: TCheckBox;
    Memo9: TMemo;
    Button9: TButton;
    ItemPanel10: TPanel;
    ItemLabel10: TLabel;
    DirectoryLabel10: TLabel;
    Panel14: TPanel;
    PMultiImage10: TPMultiImage;
    CheckBox10: TCheckBox;
    Memo10: TMemo;
    Button10: TButton;
    ItemPanel11: TPanel;
    ItemLabel11: TLabel;
    DirectoryLabel11: TLabel;
    Panel16: TPanel;
    PMultiImage11: TPMultiImage;
    CheckBox11: TCheckBox;
    Memo11: TMemo;
    Button11: TButton;
    ItemPanel12: TPanel;
    ItemLabel12: TLabel;
    DirectoryLabel12: TLabel;
    Panel18: TPanel;
    PMultiImage12: TPMultiImage;
    CheckBox12: TCheckBox;
    Memo12: TMemo;
    Button12: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExpandMemoDialogBox(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OriginalItemList : TStringList;
    SwisSBLKey : String;
    ItemType : Integer;
    ItemTypeStr : String;  {Document or picture}

    Procedure InitializeForm;
    Procedure AddItem(ItemName : String);
    Procedure GetSelectedItems(SelectedItems : TList);
  end;

var
  LoadPicturesOrDocumentsDialog: TLoadPicturesOrDocumentsDialog;

implementation

{$R *.DFM}

uses Utilitys, DataModule, PASUtils, PASTypes;

{===================================================}
Procedure TLoadPicturesOrDocumentsDialog.FormCreate(Sender: TObject);

begin
  OriginalItemList := TStringList.Create;
end;

{===================================================}
Procedure TLoadPicturesOrDocumentsDialog.AddItem(ItemName : String);

begin
  OriginalItemList.Add(ItemName);
end;

{===================================================}
Procedure TLoadPicturesOrDocumentsDialog.InitializeForm;

var
  I : Integer;
  TempComponentName : String;

begin
  If (OriginalItemList.Count = 1)
    then
      begin
        Caption := 'The following ' + ItemTypeStr + ' is new for ' +
                   ConvertSwisSBLToDashDot(SwisSBLKey);
        InstructionLabel.Caption := 'The following new ' + ItemTypeStr +
                                    ' has been found for this parcel.' +
                                    ' Please click OK to add it to the ' +
                                    ItemTypeStr + 's page or click Cancel to not add it.' +
                                    '  You may enter notes right under the selected ' +
                                    ItemTypeStr + '.';
      end
    else
      begin
        Caption := 'The following ' + ItemTypeStr + 's are new for ' +
                   ConvertSwisSBLToDashDot(SwisSBLKey);
        InstructionLabel.Caption := 'The following new ' + ItemTypeStr +
                                    's have been found for this parcel.' +
                                    '  Please select which ones you would like to be ' +
                                    'automatically added for you.' +
                                    '  You may enter notes right under each of the selected ' +
                                    ItemTypeStr + 's.';

      end;  {else of If (OriginalItemList.Count = 1)}

  ScrollBox.VertScrollBar.Visible := (OriginalItemList.Count > 3);

    {FXX08182002-1: Make sure they don't go past the number of available pictures.
                    Also, put it in a try...except.}

  For I := 0 to (OriginalItemList.Count - 1) do
    If (I <= 11)
      then
        try
          TempComponentName := 'ItemPanel' + IntToStr(I + 1);
          TPanel(FindComponent(TempComponentName)).Visible := True;
          TempComponentName := 'PMultiImage' + IntToStr(I + 1);
          try
            TPMultiImage(FindComponent(TempComponentName)).ImageName := OriginalItemList[I];
          except
            TPMultiImage(FindComponent(TempComponentName)).ImageName := '';
          end;

          TempComponentName := 'ItemLabel' + IntToStr(I + 1);
          TLabel(FindComponent(TempComponentName)).Caption := StripPath(OriginalItemList[I]);

            {CHG07132001-1: Allow searching subdirectories and picture masks.}

          TempComponentName := 'DirectoryLabel' + IntToStr(I + 1);
          TLabel(FindComponent(TempComponentName)).Caption := ReturnPath(OriginalItemList[I]);

            {Default the check box to selected.}

          TempComponentName := 'CheckBox' + IntToStr(I + 1);
          TCheckBox(FindComponent(TempComponentName)).Checked := True;

        except
        end;  {For I := 0 to (OriginalItemList.Count - 1) do}

  If (OriginalItemList.Count > 12)
    then MessageDlg('There are more than 12 new ' + ItemTypeStr + 's for this parcel.' + #13 +
                    'After loading these ' + ItemTypeStr + 's, please exit the parcel and come back to it to load the rest.',
                    mtWarning, [mbOK], 0);

end;  {InitializeForm}

{===========================================================}
Procedure TLoadPicturesOrDocumentsDialog.ExpandMemoDialogBox(Sender: TObject);

{FXX04252001-1: Make the expansion of the memo box work.}

var
  TempComponentName, ComponentNumber : String;
  TempMemo : TMemo;
  I : Integer;

begin
  TempComponentName := TButton(Sender).Name;
  ComponentNumber := TempComponentName[Length(TempComponentName)];

  TempComponentName := 'Memo' + ComponentNumber;

  TempMemo := TMemo(FindComponent(TempComponentName));

  MemoDialogBox.SetMemoLines(TempMemo.Lines);

  If MemoDialogBox.Execute
    then
      begin
        TempMemo.Lines.Clear;

        For I := 0 to (MemoDialogBox.MemoLines.Count - 1) do
          TempMemo.Lines.Add(MemoDialogBox.MemoLines[I]);

          {By default the cursor was appearing at the end of
           the memo and the text was not visible.  So,
           this tricks Windows into putting the cursor at the
           front.}

        TempMemo.SelStart := 0;
        TempMemo.SelLength := 0;

      end;  {If MemoDialogBox.Execute}

end;  {ExpandMemoDialogBox}

{===================================================}
Procedure TLoadPicturesOrDocumentsDialog.GetSelectedItems(SelectedItems : TList);

var
  I : Integer;
  TempComponentName : String;
  SelectedPicsOrDocsPtr : SelectedPicsOrDocsPointer;

begin
    {Find the items that are selected.}
    {CHG08182002-1: Allow for up to 12 pictures per parcel.}

  For I := 1 to 12 do
    begin
      TempComponentName := 'CheckBox' + IntToStr(I);

      If TCheckBox(FindComponent(TempComponentName)).Checked
        then
          begin
            New(SelectedPicsOrDocsPtr);

            with SelectedPicsOrDocsPtr^ do
              begin
                TempComponentName := 'DirectoryLabel' + IntToStr(I);
                DirectoryName := TLabel(FindComponent(TempComponentName)).Caption;

                  {FXX11052002-1: Add the directory name to the file name.}

                TempComponentName := 'ItemLabel' + IntToStr(I);
                FileName := AddDirectorySlashes(DirectoryName) +
                            TLabel(FindComponent(TempComponentName)).Caption;

                TempComponentName := 'Memo' + IntToStr(I);
                Notes := TMemo(FindComponent(TempComponentName)).Text;

              end;  {with SelectedPicsOrDocsPtr^ do}

            SelectedItems.Add(SelectedPicsOrDocsPtr);

          end;  {If TCheckBox(FindComponent(TempComponentName)).Checked}

    end;  {For I := 1 to 12 do}

end;  {GetSelectedItems}

{===========================================================}
Procedure TLoadPicturesOrDocumentsDialog.FormClose(    Sender: TObject;
                                                   var Action: TCloseAction);
begin
  OriginalItemList.Free;
end;


end.