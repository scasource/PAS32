unit Coop_ORPS_Extract;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler, locatdir, ComCtrls;

type
  Tfm_NYSORPSCooperativeExtract = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    lb_Title: TLabel;
    tb_Exemptions: TTable;
    Panel3: TPanel;
    btn_Start: TBitBtn;
    btn_Close: TBitBtn;
    tb_ParcelNY: TTable;
    dlg_Save: TSaveDialog;
    tb_ParcelTY: TTable;
    Label1: TLabel;
    tb_TYAssessment: TTable;
    rgAssessmentYear: TRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_StartClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;

    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Prog, Preview,
     Types, PASTypes, UtilEXSD, DataAccessUnit;

{$R *.DFM}

{========================================================}
Procedure Tfm_NYSORPSCooperativeExtract.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure Tfm_NYSORPSCooperativeExtract.InitializeForm;

begin
  UnitName := 'Coop_ORPS_Extract';
end;  {InitializeForm}


{===================================================================}
Procedure ParseName(    sName : String;
                    var sFirstName : String;
                    var sLastName : String;
                    var sMiddleName : String);

var
  iSpacePos : Integer;

begin
  sFirstName := '';
  sLastName := '';
  sMiddleName := '';

  iSpacePos := Pos(' ', sName);
  If _Compare(iSpacePos, 0, coGreaterThan)
  then
  begin
    sLastName := Copy(sName, 1, (iSpacePos - 1));
    Delete(sName, 1, iSpacePos);
    sName := Trim(sName);
  end
  else
  begin
    sLastName := sName;
    sName := '';
  end;


  iSpacePos := Pos(' ', sName);
  If _Compare(iSpacePos, 0, coGreaterThan)
  then
  begin
    sFirstName := Copy(sName, 1, (iSpacePos - 1));
    Delete(sName, 1, iSpacePos);
    sName := Trim(sName);
  end
  else
  begin
    sFirstName := sName;
    sName := '';
  end;


  iSpacePos := Pos(' ', sName);
  If _Compare(iSpacePos, 0, coGreaterThan)
  then
  begin
    sMiddleName := Copy(sName, 1, (iSpacePos - 1));
    Delete(sName, 1, iSpacePos);
    sName := Trim(sName);
  end;

end;  {ParseName}

{===================================================================}
Procedure Tfm_NYSORPSCooperativeExtract.btn_StartClick(Sender: TObject);

var
  SwisSBLKey, POBox, ExtractFileName,
  ExemptionCode, ExemptionType,
  MailingStreetNumber, MailingStreetName,
  sFirst1Name, sLast1Name, sMiddle1Name,
  sFirst2Name, sLast2Name, sMiddle2Name,
  sRollYear, sPOBox,
  sLegalCity, sLegalZip,
  sStreet, sMailingStreetNumber, sMailingStreetName,
  sMobileLotNumber, sCoopUnitNumber, sWord : String;
  I, NumberExtracted : LongInt;
  ExtractCancelled : Boolean;
  tb_ParcelTemp : TTable;
  ExtractFile : TextFile;
  _FieldList : TStringList;
  SpacePos : Integer;

begin
  case rgAssessmentYear.ItemIndex of
    0 : sRollYear := GlblThisYear;
    1 : sRollYear := GlblNextYear;
  end;

  NumberExtracted := 0;
  btn_Start.Enabled := False;
  ExtractCancelled := False;
  _FieldList := TStringList.Create;

  dlg_Save.FileName := GlblMunicipalityName + '_' + GlblNextYear + '_Coop_Extract.csv';
  dlg_Save.InitialDir := GlblExportDir;

  If dlg_Save.Execute
    then
      begin
        ExtractFileName := dlg_Save.FileName;
        AssignFile(ExtractFile, ExtractFileName);
        Rewrite(ExtractFile);

       _OpenTable(tb_Exemptions, ExemptionsTableName, '', '', ThisYear, []);
        _OpenTable(tb_ParcelNY, ParcelTableName, '', '', NextYear, []);
        _OpenTable(tb_ParcelTY, ParcelTableName, '', '', ThisYear, []);
        _OpenTable(tb_TYAssessment, AssessmentTableName, '', '', ThisYear, []);

        ProgressDialog.Start(tb_Exemptions.RecordCount, True, True);

        WritelnCommaDelimitedLine(ExtractFile,
                                  ['Roll Year',
                                   'Muni Code',
                                   'SWIS Code',
                                   'Print Key',
                                   'STAR Exempt Type',
                                   'Coop Unit #',
                                   'Mobile Home Lot #',
                                   'Property Street Number',
                                   'Property Street Name',
                                   'Property Street Suffix',
                                   'Property Street P.O. Box',
                                   'Property Street City',
                                   'Property Street State',
                                   'Property Street Zip',
                                   'Mail Street Number',
                                   'Mail Street Name',
                                   'Mail Street Suffix',
                                   'Mail Street P.O. Box',
                                   'Mail Street City',
                                   'Mail Street State',
                                   'Mail Street Zip',
                                   'Last 1 Name',
                                   'First 1 Name',
                                   'Middle Initial 1 Name',
                                   'Suffix 1 Name',
                                   'Filler',
                                   'Last 2 Name',
                                   'First 2 Name',
                                   'Middle Initial 2 Name',
                                   'Suffix 2 Name',
                                   'Last 3 Name',
                                   'First 3 Name',
                                   'Middle Initial 3 Name',
                                   'Suffix 3 Name',
                                   'Last 4 Name',
                                   'First 4 Name',
                                   'Middle Initial 4 Name',
                                   'Suffix 4 Name',
                                   'Notes']);

        tb_Exemptions.First;

        with tb_Exemptions do
          begin
            while ((not EOF) or
                   ExtractCancelled) do
              begin
                SwisSBLKey := FieldByName('SwisSBLKey').AsString;
                ExemptionCode := FieldByName('ExemptionCode').AsString;
                ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
                ProgressDialog.UserLabelCaption := 'Extracted = ' + IntToStr(NumberExtracted);
                Application.ProcessMessages;
                _Locate(tb_ParcelTY, [GlblThisYear, SwisSBLKey], '', [loParseSwisSBLKey]);

                If (_Compare(ExemptionCode, [BasicSTARExemptionCode, EnhancedSTARExemptionCode], coEqual) and
                    ParcelIsActive(tb_ParcelTY))
                  then
                    begin
                      Inc(NumberExtracted);

                      _Locate(tb_TYAssessment, [GlblThisYear, SwisSBLKey], '', []);

                      tb_ParcelTemp := tb_ParcelNY;
                      sCoopUnitNumber := tb_ParcelTY.FieldByName('Suffix').AsString;
                      sMobileLotNumber := '';

                      If not _Locate(tb_ParcelTemp, [GlblNextYear, SwisSBLKey], '', [loParseSwisSBLKey])
                        then tb_ParcelTemp := tb_ParcelTY;

                      If _Compare(ExemptionCode, BasicSTARExemptionCode, coEqual)
                        then ExemptionType := 'B';

                      If _Compare(ExemptionCode, EnhancedSTARExemptionCode, coEqual)
                        then ExemptionType := 'E';

(*                      ParseStringIntoFields(tb_ParcelTemp.FieldByName('Street').AsString,
                                            _FieldList, ' ', False);

                      MailingStreetNumber := '';
                      MailingStreetName := '';

                      If (_FieldList.Count > 0)
                        then MailingStreetNumber := _FieldList[0];

                      If (_FieldList.Count > 1)
                        then
                          For I := 1 to (_FieldList.Count - 1) do
                            MailingStreetName := MailingStreetName + _FieldList[I] + ' ';

                      POBox := '';
                      If AddressIsPOBox(tb_ParcelTemp.FieldByName('Address1').AsString)
                        then POBox := tb_ParcelTemp.FieldByName('Address1').AsString;
                      If AddressIsPOBox(tb_ParcelTemp.FieldByName('Address2').AsString)
                        then POBox := tb_ParcelTemp.FieldByName('Address2').AsString; *)

                      sStreet := tb_ParcelTemp.FieldByName('Street').AsString;

                      SpacePos := Pos(' ', sStreet);

                      sMailingStreetNumber := '';
                      sMailingStreetName := sStreet;

                      If _Compare(SpacePos, 0, coGreaterThan)
                      then
                      begin
                        sWord := Copy(sStreet, 1, (SpacePos - 1));

                        If StringContainsNumber(sWord)
                        then
                        begin
                          sMailingStreetNumber := sWord;
                          sMailingStreetName := Copy(sStreet, (SpacePos + 1), 255);
                        end;  {If ContainsNumber(sWord)}

                      end;  {If _Compare(SpacePos, 0, coGreaterThan)}


                      ParseName(tb_ParcelTemp.FieldByName('Name1').AsString, sFirst1Name, sLast1Name, sMiddle1Name);
                      ParseName(tb_ParcelTemp.FieldByName('Name2').AsString, sFirst2Name, sLast2Name, sMiddle2Name);
                      sPOBox := GetPOBox(tb_ParcelTemp);

                      with tb_ParcelTemp do
                      begin
                        If _Compare(FieldByName('LegalCity').AsString, coBlank)
                        then sLegalCity := FieldByName('City').AsString
                        else sLegalCity := FieldByName('LegalCity').AsString;

                        If _Compare(FieldByName('LegalZip').AsString, coBlank)
                        then sLegalZip := FieldByName('Zip').AsString
                        else sLegalZip := FieldByName('LegalZip').AsString;

                      end;  {with tb_ParcelTemp}

                      WritelnCommaDelimitedLine(ExtractFile,
                                                [sRollYear,
                                                 Copy(tb_ParcelTemp.FieldByName('SwisCode').AsString, 1, 4) + '00',
                                                 tb_ParcelTemp.FieldByName('SwisCode').AsString,
                                                 ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)),
                                                 ExemptionType,
                                                 sCoopUnitNumber,
                                                 sMobileLotNumber,
                                                 tb_ParcelTemp.FieldByName('LegalAddrNo').AsString,
                                                 tb_ParcelTemp.FieldByName('LegalAddr').AsString,
                                                 '',
                                                 '',
                                                 sLegalCity,
                                                 'NY',
                                                 sLegalZip,
                                                 sMailingStreetNumber,
                                                 sMailingStreetName,
                                                 '',
                                                 sPOBox,
                                                 tb_ParcelTemp.FieldByName('City').AsString,
                                                 tb_ParcelTemp.FieldByName('State').AsString,
                                                 tb_ParcelTemp.FieldByName('Zip').AsString + tb_ParcelTemp.FieldByName('ZipPlus4').AsString,
                                                 sLast1Name,
                                                 sFirst1Name,
                                                 sMiddle1Name,
                                                 '',
                                                 '',
                                                 sLast2Name,
                                                 sFirst2Name,
                                                 sMiddle2Name,
                                                 '',
                                                 '',
                                                 '',
                                                 '',
                                                 '',
                                                 '',
                                                 '',
                                                 '',
                                                 '',
                                                 '']);

                    end;  {If _Compare(ExemptionCode, ...}

                ExtractCancelled := ProgressDialog.Cancelled;
                Next;

              end;  {while not EOF do}

          end;  {with tb_Exemptions do}

        CloseFile(ExtractFile);
        ProgressDialog.Finish;

        SendTextFileToExcelSpreadsheet(ExtractFileName, True, False, '');

      end;  {If dlg_Save.Execute}

  _FieldList.Free;
  Application.ProcessMessages;
  btn_Start.Enabled := True;

end; {StartButtonClick}

{===================================================================}
Procedure Tfm_NYSORPSCooperativeExtract.FormClose(    Sender: TObject;
                                             var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.