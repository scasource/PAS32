unit Destinfo;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, DB, DBTables, Types;

type
  TEnterDestinationParcelInformationForm = class(TForm)
    GroupBox1: TGroupBox;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    Name1: TLabel;
    Name1Edit: TEdit;
    Name2: TLabel;
    Name2Edit: TEdit;
    Address1: TLabel;
    Addr1Edit: TEdit;
    Address2: TLabel;
    Addr2Edit: TEdit;
    Street: TLabel;
    StreetEdit: TEdit;
    City: TLabel;
    CityEdit: TEdit;
    RemapOldSBL: TLabel;
    PriorSBLKeyEdit: TEdit;
    State: TLabel;
    Zip: TLabel;
    ZipPlus4: TLabel;
    StateEdit: TEdit;
    ZipEdit: TEdit;
    ZipPlus4Edit: TEdit;
    LegalAddrNo: TLabel;
    LegalAddr: TLabel;
    LegalAddrNoEdit: TEdit;
    LegalAddrStreetEdit: TEdit;
    Depth: TLabel;
    Frontage: TLabel;
    Acreage: TLabel;
    GridCordNorth: TLabel;
    GridCordEast: TLabel;
    EditFrontage: TEdit;
    EditDepth: TEdit;
    EditGridCoordNorth: TEdit;
    EditAcreage: TEdit;
    EditGridCoordEast: TEdit;
    ParcelTable: TTable;
    AssessmentYearControlTable: TTable;
    SwisCodeTable: TTable;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    SourceSwisSBLKey : String;
    _GridLine : Integer;
    AssessmentYear : String;
    Procedure InitializeForm(DestinationSwisSBLKey : String;
                             DestParcelInfoList : TList;
                             ProcessingType : Integer);

    Function GetValueForField(DestinationSwisSBLKey : String;
                              DestParcelInfoList : TList;
                              _FieldName : String) : String;

    Procedure AddDefaultInformationItem(DestinationSwisSBLKey : String;
                                        DestParcelInfoList : TList;
                                        ProcessingType : Integer);
  end;

var
  EnterDestinationParcelInformationForm: TEnterDestinationParcelInformationForm;

implementation

{$R *.DFM}

uses PasUtils, GlblCnst, PASTypes, WinUtils, GlblVars,
     Utilitys;

{==============================================================}
Procedure TEnterDestinationParcelInformationForm.AddDefaultInformationItem(DestinationSwisSBLKey : String;
                                                                           DestParcelInfoList : TList;
                                                                           ProcessingType : Integer);

var
  DestParcelInfoPtr : DestinationParcelInformationPointer;
  I : Integer;
  Quit, ValidEntry : Boolean;

begin
  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(AssessmentYearControlTable,
                             AssessmentYearControlTableName,
                             ProcessingType, Quit);

    {First clear out any entries for this SBL.}

  For I := (DestParcelInfoList.Count - 1) downto 0 do
    If (DestinationParcelInformationPointer(DestParcelInfoList[I])^.SwisSBLKey =
        DestinationSwisSBLKey)
      then DestParcelInfoList.Delete(I);

    {Now put the new ones in.}

  For I := 0 to (ComponentCount - 1) do
    If (Components[I] is TLabel)
      then
        with Components[I] as TLabel do
          begin
            New(DestParcelInfoPtr);

            with DestParcelInfoPtr^ do
              begin
                FieldName := Name;
                TableName := 'TParcelTable';
                SwisSBLKey := DestinationSwisSBLKey;
                (*GridLine := _GridLine; *)

                  {The FocusControl of the label points to the corresponding edit.}

                  {FXX03292002-2: Not getting the old ID correctly.}

                If (GlblLocateByOldParcelID and
                    (FieldName = 'RemapOldSBL') and
                    (Deblank(TEdit(FocusControl).Text) <> ''))
                  then FieldValue := ConvertOldSwisDashDotSBLToSwisSBL(TEdit(FocusControl).Text,
                                                                       AssessmentYearControlTable,
                                                                       SwisCodeTable,
                                                                       ValidEntry)
                  else FieldValue := TEdit(FocusControl).Text;

              end;  {with DestParcelInfoPtr^ do}

            DestParcelInfoList.Add(DestParcelInfoPtr);

          end;  {with Components[I] as TLabel do}

  CloseTablesForForm(Self);

end;  {AddDefaultInformationItem}

{==============================================================}
Function TEnterDestinationParcelInformationForm.GetValueForField(DestinationSwisSBLKey : String;
                                                                 DestParcelInfoList : TList;
                                                                 _FieldName : String) : String;

{FXX03292002-3: Check for information that already exists.}

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (DestParcelInfoList.Count - 1) do
    with DestinationParcelInformationPointer(DestParcelInfoList[I])^ do
      If ((SwisSBLKey = DestinationSwisSBLKey) and
          (Take(30, FieldName) = Take(30, _FieldName)))
        then Result := FieldValue;

end;  {GetValueForField}

{==============================================================}
Procedure TEnterDestinationParcelInformationForm.InitializeForm(DestinationSwisSBLKey : String;
                                                                DestParcelInfoList : TList;
                                                                ProcessingType : Integer);

var
  SBLRec : SBLRecord;
  I : Integer;
  Quit, InformationFound : Boolean;
  TempStr : String;
  
begin
  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(AssessmentYearControlTable,
                             AssessmentYearControlTableName,
                             ProcessingType, Quit);

  GroupBox1.Caption := ' Enter information for ' +
                       ConvertSwisSBLToDashDot(DestinationSwisSBLKey) + ' ';
  Caption := 'Enter information for ' + ConvertSwisSBLToDashDot(DestinationSwisSBLKey);

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SourceSwisSBLKey);

  with SBLRec do
    FindKeyOld(ParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section', 'Subsection', 'Block',
                'Lot', 'Sublot', 'Suffix'],
               [AssessmentYear, SwisCode, Section, Subsection, Block,
                Lot, Sublot, Suffix]);

    {FXX03292002-3: Check for information that already exists.}

  InformationFound := False;

  For I := 0 to (DestParcelInfoList.Count - 1) do
    If (DestinationParcelInformationPointer(DestParcelInfoList[I])^.SwisSBLKey =
        DestinationSwisSBLKey)
      then InformationFound := True;

    {Fill in the default info.}

  If InformationFound
    then
      begin
        Name1Edit.Text := GetValueForField(DestinationSwisSBLKey,
                                           DestParcelInfoList,
                                           'Name1');
        Name2Edit.Text := GetValueForField(DestinationSwisSBLKey,
                                           DestParcelInfoList,
                                           'Name2');
        Addr1Edit.Text := GetValueForField(DestinationSwisSBLKey,
                                           DestParcelInfoList,
                                           'Address1');
        Addr2Edit.Text := GetValueForField(DestinationSwisSBLKey,
                                           DestParcelInfoList,
                                           'Address2');
        StreetEdit.Text := GetValueForField(DestinationSwisSBLKey,
                                           DestParcelInfoList,
                                           'Street');
        CityEdit.Text := GetValueForField(DestinationSwisSBLKey,
                                           DestParcelInfoList,
                                           'City');
        StateEdit.Text := GetValueForField(DestinationSwisSBLKey,
                                           DestParcelInfoList,
                                           'State');
        ZipEdit.Text := GetValueForField(DestinationSwisSBLKey,
                                         DestParcelInfoList,
                                         'Zip');
        ZipPlus4Edit.Text := GetValueForField(DestinationSwisSBLKey,
                                              DestParcelInfoList,
                                              'ZipPlus4');
        LegalAddrNoEdit.Text := GetValueForField(DestinationSwisSBLKey,
                                           DestParcelInfoList,
                                           'LegalAddrNo');
        LegalAddrStreetEdit.Text := GetValueForField(DestinationSwisSBLKey,
                                                     DestParcelInfoList,
                                                     'LegalAddr');

        try
          EditFrontage.Text := FormatFloat(DecimalEditDisplay_BlankZero,
                                           StrToFloat(GetValueForField(DestinationSwisSBLKey,
                                                                       DestParcelInfoList,
                                                                       'Frontage')));
        except
          EditFrontage.Text := '';
        end;

        try
          EditDepth.Text := FormatFloat(DecimalEditDisplay_BlankZero,
                                        StrToFloat(GetValueForField(DestinationSwisSBLKey,
                                                                    DestParcelInfoList,
                                                                    'Depth')));
        except
          EditDepth.Text := '';
        end;

        try
          EditAcreage.Text := FormatFloat(DecimalEditDisplay_BlankZero,
                                          StrToFloat(GetValueForField(DestinationSwisSBLKey,
                                                                      DestParcelInfoList,
                                                                      'Acreage')));
        except
          EditAcreage.Text := '';
        end;

        EditGridCoordNorth.Text := GetValueForField(DestinationSwisSBLKey,
                                                    DestParcelInfoList,
                                                    'GridCordNorth');
        EditGridCoordEast.Text := GetValueForField(DestinationSwisSBLKey,
                                                   DestParcelInfoList,
                                                   'GridCordEast');

        TempStr := GetValueForField(DestinationSwisSBLKey,
                                    DestParcelInfoList, 'RemapOldSBL');

        PriorSBLKeyEdit.Text := ConvertSwisSBLToOldDashDot(TempStr,
                                                           AssessmentYearControlTable);

      end
    else
      begin
        with ParcelTable do
          begin
            Name1Edit.Text := FieldByName('Name1').Text;
            Name2Edit.Text := FieldByName('Name2').Text;
            Addr1Edit.Text := FieldByName('Address1').Text;
            Addr2Edit.Text := FieldByName('Address2').Text;
            StreetEdit.Text := FieldByName('Street').Text;
            CityEdit.Text := FieldByName('City').Text;
            StateEdit.Text := FieldByName('State').Text;
            ZipEdit.Text := FieldByName('Zip').Text;
            ZipPlus4Edit.Text := FieldByName('ZipPlus4').Text;
            LegalAddrNoEdit.Text := FieldByName('LegalAddrNo').Text;
            LegalAddrStreetEdit.Text := FieldByName('LegalAddr').Text;
            EditFrontage.Text := FormatFloat(DecimalEditDisplay_BlankZero,
                                             FieldByName('Frontage').AsFloat);
            EditDepth.Text := FormatFloat(DecimalEditDisplay_BlankZero,
                                          FieldByName('Depth').AsFloat);
            EditAcreage.Text := FormatFloat(DecimalEditDisplay_BlankZero,
                                            FieldByName('Acreage').AsFloat);
            EditGridCoordNorth.Text := FieldByName('GridCordNorth').Text;
            EditGridCoordEast.Text := FieldByName('GridCordEast').Text;

          end;  {with ParcelTable do}

      end;  {else of If InformationFound}

  CloseTablesForForm(Self);

end;  {InitializeForm}

{==========================================================================}
Procedure TEnterDestinationParcelInformationForm.FormKeyPress(    Sender: TObject;
                                                              var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{==========================================================================}
end.
