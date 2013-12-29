unit MapRangeCodeSelectDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, DB, DBTables;

type
  TMapRangeCodeSelectDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    CodeListBox: TListBox;
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RangeType : Integer;
    SelectedCodesList : TStringList;

    Procedure InitializeForm(_RangeType : Integer;
                             _SelectedCodesList : TStringList);
  end;

implementation

{$R *.DFM}


uses WinUtils, GlblCnst, GlblVars;

{=========================================================}
Procedure TMapRangeCodeSelectDialog.InitializeForm(_RangeType : Integer;
                                                   _SelectedCodesList : TStringList);

var
  CodeField, DescriptionField : String;
  CodeTable : TTable;
  DescriptionLength : Integer;

begin
  RangeType := _RangeType;
  SelectedCodesList := _SelectedCodesList;
  SelectedCodesList.Clear;

  CodeTable := TTable.Create(nil);
  CodeTable.TableType := ttDBase;
  CodeTable.DatabaseName := 'PASSystem';

  case RangeType of
    rtZoningCodes :
      begin
        Caption := 'Choose which zoning code(s) to display.';
        CodeTable.TableName := 'zinvzoningcodetbl';
        DescriptionLength := 15;
        CodeField := 'MainCode';
        DescriptionField := 'Description';

      end;  {rtZoningCodes}

    rtNeighborhoodCodes :
      begin
        Caption := 'Choose which neighborhood code(s) to display.';
        CodeTable.TableName := 'zinvnghbrhdcodetbl';
        DescriptionLength := 15;
        CodeField := 'MainCode';
        DescriptionField := 'Description';

      end;  {rtNeighborhoodCodes}

    rtSwisCodes :
      begin
        Caption := 'Choose which swis code(s) to display.';
        CodeTable.TableName := 'nswistbl';
        DescriptionLength := 15;
        CodeField := 'SwisCode';
        DescriptionField := 'MunicipalityName';

      end;  {rtSwisCodes}

    rtSchoolCodes :
      begin
        Caption := 'Choose which school code(s) to display.';
        CodeTable.TableName := 'nschooltbl';
        DescriptionLength := 15;
        CodeField := 'SchoolCode';
        DescriptionField := 'SchoolName';

      end;  {rtSchoolCodes}

    rtPropertyClass :
      begin
        Caption := 'Choose which property class code(s) to display.';
        CodeTable.TableName := 'zpropclstbl';
        DescriptionLength := 18;
        CodeField := 'MainCode';
        DescriptionField := 'Description';

      end;  {rtNeighborhoodCodes}

  end;  {case RangeType of}

  try
    CodeTable.Open;
  except
    MessageDlg('Error opening code table ' + CodeTable.TableName + '.',
               mtError, [mbOK], 0);
  end;

  FillOneListBox(CodeListBox, CodeTable,
                 CodeField, DescriptionField,
                 DescriptionLength, False, (DescriptionLength > 0),
                 NextYear, GlblNextYear);

  SelectItemsInListBox(CodeListBox);
  CodeListBox.TopIndex := 1;               

  try
    CodeTable.Close;
    CodeTable.Free;
  except
  end;

end;  {InitializeForm}

{=========================================================}
Procedure TMapRangeCodeSelectDialog.OKButtonClick(Sender: TObject);

var
  I, DashPos : Integer;

begin
  with CodeListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then
          begin
            DashPos := Pos('-', Items[I]);
            SelectedCodesList.Add(Copy(Items[I], 1, (DashPos - 2)));
          end;

  ModalResult := mrOK;

end;  {OKButtonClick}

end.
