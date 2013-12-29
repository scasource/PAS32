unit MapModifyParcelUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Wwtable, Wwdatsrc, Grids, wwDataInspector, StdCtrls,
  Buttons, MapObjects2_TLB, ComObj;

type
  TModifyShapefileRecordForm = class(TForm)
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    CloseButton: TBitBtn;
    ParcelStringGrid: TStringGrid;
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ShapefileLocation : String;
    ShapefileName : String;
    UniqueValueFieldName, UniqueValue, ParcelID : String;
    Layer : IMoMapLayer;
(*    MappingForm.ShapefileRecordSet : IMORecordSet;*)

    Procedure InitializeForm;
  end;

var
  ModifyShapefileRecordForm: TModifyShapefileRecordForm;

implementation

uses MappingFormUnit;

{$R *.DFM}

{=================================================================}
Procedure TModifyShapefileRecordForm.InitializeForm;

var
  tdesc: IMoTableDesc;
  flds : IMoFields;
  fld  : IMoField;
  I : Integer;

begin
(*  MappingForm.ShapefileRecordSet := MappingForm.MainLayer.Records;*)
  tdesc := IMoTableDesc(CreateOleObject('MapObjects2.TableDesc'));
  tdesc := MappingForm.ShapefileRecordSet.TableDesc;
  flds := MappingForm.ShapefileRecordSet.Fields;

  with ParcelStringGrid do
    begin
      Cells[0, 0] := 'Field';
      Cells[1, 0] := 'Value';
    end;

  For I := 0 to (tdesc.FieldCount - 1) do
    begin
      If (I > (ParcelStringGrid.RowCount - 1))
        then ParcelStringGrid.RowCount := ParcelStringGrid.RowCount + 1;

      fld := flds.Item(tdesc.FieldName[i]);
      ParcelStringGrid.Cells[0, (I + 1)] := fld.name ;
      ParcelStringGrid.Cells[1, (I + 1)] := fld.valueasstring;

    end;  {For I := 0 to (tdesc.FieldCount - 1) do}

end;  {InitializeForm}

{=================================================================}
Procedure TModifyShapefileRecordForm.SaveButtonClick(Sender: TObject);

var
  I : Integer;
  fld : IMoField;
  tdesc: IMoTableDesc;
  flds : IMoFields;

begin
  with MappingForm.ShapefileRecordSet, ParcelStringGrid do
    If Updatable
      then
        try
          Edit;

          For I := 1 to (RowCount - 1) do
            begin
              fld := Fields.Item(Cells[0, I]);

              case fld.Type_ of
                moLong : try
                           fld.Value := StrToInt(Cells[1, I]);
                         except
                         end;

                moDouble : try
                           fld.Value := StrToFloat(Cells[1, I]);
               (*            MessageDlg(FloatToStr(fld.Value), mtInformation, [mbOK], 0);*)
                         except
                         end;

                moDate : try
                           fld.Value := StrToDate(Cells[1, I]);
                         except
                         end;

                moString : fld.Value := Cells[1, I];

                moBoolean : If ((ANSIUpperCase(Cells[1, I]) = 'TRUE') or
                                (ANSIUpperCase(Cells[1, I]) = 'Y'))
                              then fld.Value := True
                              else fld.Value := False;

              end;  {case Field.FieldType of}

            end;  {For I := 1 to (RowCount - 1) do}

          Update;
          StopEditing;

(*  tdesc := IMoTableDesc(CreateOleObject('MapObjects2.TableDesc'));
  tdesc := MappingForm.ShapefileRecordSet.TableDesc;
  flds := MappingForm.ShapefileRecordSet.Fields;

  For I := 0 to (tdesc.FieldCount - 1) do
    begin
      If (I > (ParcelStringGrid.RowCount - 1))
        then ParcelStringGrid.RowCount := ParcelStringGrid.RowCount + 1;

      fld := flds.Item(tdesc.FieldName[i]);
      ParcelStringGrid.Cells[0, (I + 1)] := fld.name ;
      ParcelStringGrid.Cells[1, (I + 1)] := fld.valueasstring;

    end;  {For I := 0 to (tdesc.FieldCount - 1) do}*)

        except
          MessageDlg('Error saving shapefile record.', mtError, [mbOK], 0);
        end
      else MessageDlg('Sorry, the changes can not be saved because the shapefile is not updatable.',
                      mtError, [mbOK], 0);

(*  ModalResult := mrOK;*)

end;  {SaveButtonClick}

{=================================================================}
Procedure TModifyShapefileRecordForm.CancelButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to cancel all changes?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then ModalResult := mrCancel;

end;  {CancelButtonClick}

{=================================================================}
Procedure TModifyShapefileRecordForm.CloseButtonClick(Sender: TObject);

var
  ReturnValue : Integer;

begin
  ReturnValue := MessageDlg('Do you want to save your changes?', mtConfirmation,
                            [mbYes, mbNo, mbCancel], 0);

  case ReturnValue of
    idYes : SaveButtonClick(Sender);
    idNo : CancelButtonClick(Sender);

  end;

end;  {CloseButtonClick}

end.
