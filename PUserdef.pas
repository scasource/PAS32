unit Puserdef;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus;

type
  TDefineUserFieldsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    UserFldDefDataSource: TwwDataSource;
    UserFldDefTable: TwwTable;
    DBNavigator1: TDBNavigator;
    Panel3: TPanel;
    UserDefDBGrid: TwwDBGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure UserFldDefTableBeforePost(DataSet: TDataset);
    procedure UserFldDefTableBeforeEdit(DataSet: TDataset);
    procedure FormActivate(Sender: TObject);
    procedure UserFldDefTableNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FieldWasActive : Boolean;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm ;  {Open the tables and setup.}

  end;


implementation

uses GlblVars, WinUtils, Utilitys,GlblCnst,PasUtils;

{$R *.DFM}

{========================================================}
Procedure TDefineUserFieldsForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TDefineUserFieldsForm.InitializeForm;

begin
  UnitName := 'PUSERDEF.PAS';  {mmm}

  If (FormAccessRights = raReadOnly)
    then UserFldDefTable.ReadOnly := True;  {mmm}


   OpenTAblesForForm(Self,GlblProcessingType);

end;  {InitializeForm}

{===================================================================}
Procedure TDefineUserFieldsForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{===================================================}
Procedure TDefineUserFieldsForm.UserFldDefTableNewRecord(DataSet: TDataSet);

begin
  UserFldDefTable.FieldByName('TaxRollYr').AsString := GetTaxRlYr;
end;

{===================================================}
Procedure TDefineUserFieldsForm.UserFldDefTableBeforeEdit(DataSet: TDataset);

begin
  FieldWasActive := UserFldDefTable.FieldByName('Active').AsBoolean;
end;

{==================================================}
Procedure TDefineUserFieldsForm.UserFldDefTableBeforePost(DataSet: TDataset);

begin
  If ((Deblank(UserFldDefTable.FieldByName('UserSpecifiedDescr').Text) = '') and
      UserFldDefTable.FieldByName('Active').AsBoolean)
    then
      begin
        MessageDlg('Please enter a description for this field.',
                   mtError, [mbOK], 0);
        Abort;
      end
    else
      If ((Deblank(UserFldDefTable.FieldByName('UserSpecifiedDescr').AsString) <> '') and
          (not UserFldDefTable.FieldByName('Active').AsBoolean))
        then
          begin
            MessageDlg('Please make this field active since a' + #13 +
                       'description has been filled in.' ,
                       mtError, [mbOK], 0);
            Abort;
          end
        else
          If (FieldWasActive and
              (not UserFldDefTable.FieldByName('Active').AsBoolean) and
              (MessageDlg('WARNING: You are deactivating a field which' + #13 +
                          'was previously active.  Any information that' + #13 +
                          'you have saved in this field will no longer ' + #13 +
                          'be accessible.  Are you sure you want to proceed?' , mtConfirmation,
                          [mbYes, mbNo], 0) = idNo))
            then Abort;

end;  {UserFldDefTableBeforePost}

{===================================================================}
Procedure TDefineUserFieldsForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}



end.
