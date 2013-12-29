unit Ugensclb;

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
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, BtrvDlg,
  wwdbLook;

type
  TGenerateScreenLabelFileForm = class(TForm)
    ScreenLabelTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    GenerateButton: TBitBtn;
    ScreenLabelLookupTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure GenerateButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    FieldValuesList,
    FieldLabelsList : TStringList;

    Procedure InitializeForm;  {Open the tables and setup.}
    Procedure AddScreenLabels(    TempForm : TForm;
                                  MainTable : TTable;
                                  ScreenName : String;
                              var Quit : Boolean);
   {Add all the labels for this screen.}

  end;

implementation

uses PBasePg1_New,  {Main parcel 1}
     PBasePg2,  {Main parcel 2}
     PAsmtFrm,  {Parcel Assessments}
     PExcdmnt,  {Parcel Exemptions}
     PSdCdMnt,  {Parcel Special Districts}
     PResSite,  {Parcel residential sites.}
     PResBldg,  {Parcel residential building info}
     PResImpr,  {Parcel residential improvements}
     PResLand,  {Parcel residential land}
     PResFrst,  {Parcel residential forest}
     PComSite,  {Parcel commercial site}
     PComBldg,  {Parcel commercial building}
     PComLand,  {Parcel commercial land}
     PComImpr,  {Parcel commercial improvements}
     PComRent,  {Parcel commercial rent (use)}
     PComInEx,  {Parcel commercial income \ expense}
     PSalesmt,  {Parcel sales}
     PClassFm,  {Class}
     PNoteFrm,
     PPicture,
     PDocumnt,
     Types,     {General types}
     Utilitys,  {General utilitys}
     PASUTILS, UTILEXSD,   {PAS specific utilitys}
     PASTypes,  {PAS specific types}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils;  {General Windows utilitys}

{$R *.DFM}

{========================================================}
Procedure TGenerateScreenLabelFileForm.InitializeForm;

begin
  UnitName := 'UGENSCLB.PAS';  {mmm}

  try
    ScreenLabelTable.Open;
  except
    SystemSupport(001, ScreenLabelTable, 'Error opening table.',
                  UnitName, GlblErrorDlgBox);
  end;

  ScreenLabelLookupTable.Open;

end;  {InitializeForm}

{===================================================================}
Procedure TGenerateScreenLabelFileForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{========================================================================}
Procedure TGenerateScreenLabelFileForm.AddScreenLabels(    TempForm : TForm;
                                                           MainTable : TTable;
                                                           ScreenName : String;
                                                       var Quit : Boolean);

{Add all the labels for this screen.}

var
  FieldValuesList, FieldLabelsList, FieldNamesList : TStringList;
  I : Integer;
  Found : Boolean;

begin
  FieldLabelsList := TStringList.Create;
  FieldNamesList := TStringList.Create;
  FieldValuesList := TStringList.Create;

   {use utility to extract label names on this form into FieldLabelsList}

  CreateFieldValuesAndLabels(TempForm, MainTable, FieldValuesList,
                             FieldLabelsList, FieldNamesList);

    {loop thru label string list for this screen and store screen name &}
    {label name in screen label file}

  For I := 0 to (FieldLabelsList.Count - 1) do
    begin
      Found := ScreenLabelLookupTable.FindKey([Take(30, ScreenName),
                                               Take(30, FieldLabelsList[I])]);

      If not Found
        then
          begin
            with ScreenLabelTable do
              try
                Insert;

                FieldByName('ScreenName').Text := Take(30, ScreenName);
                FieldByName('TableName').Text := Take(30, MainTable.TableName);
                FieldByName('LabelName').Text := Take(30, FieldLabelsList[I]);
                FieldByName('FieldName').Text := Take(30, FieldNamesList[I]);

                Post;
              except
                  {Ignore duplicates.}
                SystemSupport(003, ScreenLabelTable, 'Error Posting To Screen Label File.' +
                              'Screen = ' + ScreenName +
                              'Label = ' + FieldLabelsList[I],
                              UnitName, GlblErrorDlgBox);
                Quit := True;
              end;

          end;  {If not Found}

    end;  {For I := 0 to (FieldLabelsList.Count - 1) do}

  FieldNamesList.Free;
  FieldLabelsList.Free;
  FieldValuesList.Free;

end;  {AddScreenLabels}

{========================================================================}
Procedure TGenerateScreenLabelFileForm.GenerateButtonClick(Sender: TObject);

var
  TempForm : Tform;
  Quit, Done : Boolean;
  I : Integer;

begin
  Quit := False;
  Done := False;

   {clear the table of old definitions so data will be as of the current}
   {level of the software}

(*  try
    DeleteTable(ScreenLabelTable);
  except
    SystemSupport(002, ScreenLabelTAble, 'Error Clearing Screen Label File.', UnitName, GlblErrorDlgBox);
    Quit := True;
  end;

  If not Quit
    then
      begin
        TempForm := TBaseParcelPg1Form.Create(Nil);
        AddScreenLabels(TempForm, TBaseParcelPg1Form(TempForm).ParcelTable,
                        'Base Information', Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TBaseParcelPg2Form.Create(Nil);
        AddScreenLabels(TempForm, TBaseParcelPg2Form(TempForm).ParcelTable,
                        'Base Information', Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TAssessmentForm.Create(Nil);
        AddScreenLabels(TempForm, TAssessmentForm(TempForm).AssessmentTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelExemptionCodeForm.Create(Nil);
        TParcelExemptionCodeForm(TempForm).ExemptionTable.Open;

        AddScreenLabels(TempForm, TParcelExemptionCodeForm(TempForm).ExemptionTable,
                        'Exemption', Quit);

        TParcelExemptionCodeForm(TempForm).ExemptionTable.Close;
        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelSpecialDistrictForm.Create(Nil);

          {FXX01211998-7: Must set InitializingForm to True so that
                          OnDataChange is not executed for the DataSource.}

        TParcelSpecialDistrictForm(TempForm).InitializingForm := True;
        TParcelSpecialDistrictForm(TempForm).ParcelSDistTable.Open;
        AddScreenLabels(TempForm, TParcelSpecialDistrictForm(TempForm).ParcelSDistTable,
                        'Special District', Quit);

        TParcelSpecialDistrictForm(TempForm).ParcelSDistTable.Close;
        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TSalesPageForm.Create(Nil);
        AddScreenLabels(TempForm, TSalesPageForm(TempForm).MainTable,
                        'Sales', Quit);

        TempForm.Free;

      end;  {If not Quit}

    {FXX11101997-4: Add class labels to screen label file.}

  If not Quit
    then
      begin
        TempForm := TClassForm.Create(Nil);
        AddScreenLabels(TempForm, TClassForm(TempForm).MainTable,
                        'Class', Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelResidentialSiteForm.Create(Nil);
        AddScreenLabels(TempForm, TParcelResidentialSiteForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelResidentialBldgForm.Create(Nil);
        AddScreenLabels(TempForm, TParcelResidentialBldgForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelResidentialLandForm.Create(Nil);
        AddScreenLabels(TempForm, TParcelResidentialLandForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelResidentialImprovementsForm.Create(Nil);
        AddScreenLabels(TempForm, TParcelResidentialImprovementsForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelResidentialForestForm.Create(Nil);
        AddScreenLabels(TempForm, TParcelResidentialForestForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelCommercialSiteForm.Create(Nil);
        AddScreenLabels(TempForm, TParcelCommercialSiteForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelCommercialBldgForm.Create(Nil);
        AddScreenLabels(TempForm, TParcelCommercialBldgForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelCommercialLandForm.Create(Nil);
        AddScreenLabels(TempForm, TParcelCommercialLandForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelCommercialImprovementsForm.Create(Nil);
        AddScreenLabels(TempForm, TParcelCommercialImprovementsForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelCommercialRentForm.Create(Nil);
        AddScreenLabels(TempForm, TParcelCommercialRentForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TParcelCommercialIncomeExpenseForm.Create(Nil);
        AddScreenLabels(TempForm, TParcelCommercialIncomeExpenseForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit} *)

  If not Quit
    then
      begin
        TempForm := TNotesForm.Create(Nil);
        AddScreenLabels(TempForm, TNotesForm(TempForm).NotesTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TDocumentForm.Create(Nil);
        AddScreenLabels(TempForm, TDocumentForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}

  If not Quit
    then
      begin
        TempForm := TPictureForm.Create(Nil);
        AddScreenLabels(TempForm, TPictureForm(TempForm).MainTable,
                        TempForm.Caption, Quit);

        TempForm.Free;

      end;  {If not Quit}


  If Quit
    then MessageDlg('The screen label file was NOT generated successfully.',
                    mtError, [mbOK], 0)
    else MessageDlg('The screen label file was generated successfully.',
                    mtInformation, [mbOK], 0);

end;  {GenerateButtonClick}

{===================================================================}
Procedure TGenerateScreenLabelFileForm.FormClose(    Sender: TObject;
                                                 var Action: TCloseAction);

begin
  ScreenLabelTable.Close;
  ScreenLabelLookupTable.Close;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
