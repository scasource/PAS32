unit ParclTab;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, TabNotBk, Tabs, Menus, DB, GlblVars,
  Dialogs, DBTables, WwTable, Wwdatsrc, wwidlg, DbiProcs, DbiTypes, wwDBGrid,
  DBGrids,  Buttons, Mask, DBCtrls, wwdblook,
  Types, UtilPrcl, PSToolbar, PSWindow, PSJob, PJBitmap, PJControl, PJForm,
  PSPreview, ComCtrls, FileCtrl;

type
  TParcelTabForm = class(TForm)
    ParcelTabSet: TTabSet;
    BasePopupMenu: TPopupMenu;
    Comment1: TMenuItem;
    Assessment1: TMenuItem;
    Notes1: TMenuItem;
    ResidentialSites1: TMenuItem;
    CommercialSites1: TMenuItem;
    BaseParcelPg1: TMenuItem;
    SpecialDistricts1: TMenuItem;
    Exemptions1: TMenuItem;
    Sales1: TMenuItem;
    Residence1: TMenuItem;
    Land1: TMenuItem;
    Forest1: TMenuItem;
    Improvements1: TMenuItem;
    Building1: TMenuItem;
    Land2: TMenuItem;
    RentableAreas1: TMenuItem;
    Improvements2: TMenuItem;
    IncomeExpense1: TMenuItem;
    SearchDialogueTimer: TTimer;
    N2: TMenuItem;
    LocateParcel1: TMenuItem;
    BaseParcelPage2: TMenuItem;
    ExitParcelMaintenance1: TMenuItem;
    MenuSecurityTable: TTable;
    ShowOppositeYearTabs: TMenuItem;
    _ParcelTable: TTable;
    Panel1: TPanel;
    AddParcelPanel: TPanel;
    Label1: TLabel;
    CancelButton: TBitBtn;
    OKButton: TBitBtn;
    AddParcelEdit: TEdit;
    SwisCodeTable: TTable;
    Label5: TLabel;
    AssessmentTable: TTable;
    HideNextYear1: TMenuItem;
    N3: TMenuItem;
    NextYear1: TMenuItem;
    SalesInventory1: TMenuItem;
    Class1: TMenuItem;
    Sites1: TMenuItem;
    Sites2: TMenuItem;
    UserData1: TMenuItem;
    NextParcel: TMenuItem;
    PreviousParcel: TMenuItem;
    Summary1: TMenuItem;
    Pictures: TMenuItem;
    Documents: TMenuItem;
    OppositeYearParcelTable: TTable;
    AuditParcelChangeTable: TTable;
    Permits: TMenuItem;
    LookupTable: TwwTable;
    Main1: TMenuItem;
    Denials1: TMenuItem;
    Agricultural1: TMenuItem;
    Removed1: TMenuItem;
    ShowParcelToollbar1: TMenuItem;
    MapsMenuItem: TMenuItem;
    N3rdPartyNotifications1: TMenuItem;
    SwitchtoOppositeYearMenuItem: TMenuItem;
    GrievanceMenuItem: TMenuItem;
    CertiorariMenuItem: TMenuItem;
    SmallClaimsMenuItem: TMenuItem;
    SketchMenuItem: TMenuItem;
    RestrictedParcelTable: TTable;
    FormPrintJob: TFormPrintJob;
    PreviewMain: TPreviewWindow;
    PreviewToolbar: TPreviewToolbar;
    Preview: TPreview;
    Prorata1: TMenuItem;
    PrintJob1: TPrintJob;
    AdditionalOwners1: TMenuItem;
    CertiorariTable: TTable;
    PASPermitsMenuItem: TMenuItem;
    mi_PropertyCard: TMenuItem;
    mnuSplitSchoolDistricts: TMenuItem;
    mnuitmAgriculture: TMenuItem;
    TaxBillingAddress1: TMenuItem;
    procedure ParcelTabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure PopupMenuClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure SearchDialogueTimerTimer(Sender: TObject);
    procedure LocateParcel1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ExitParcelMaintenance1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BasePopupMenuPopup(Sender: TObject);
    procedure ParcelTabSetDrawTab(Sender: TObject; TabCanvas: TCanvas;
      R: TRect; Index: Integer; Selected: Boolean);
    procedure ShowOppositeYearTabsClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HideOppositeYearTabsClick(Sender: TObject);
    procedure HideSalesInventoryClick(Sender: TObject);
    procedure ParcelScrollClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ShowParcelToollbar1Click(Sender: TObject);
    procedure SwitchtoOppositeYearMenuItemClick(Sender: TObject);
    procedure _ParcelTableFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure PreviewToolbarUserButtonClick(Sender: TObject);
    procedure FormPrintJobDraw(Sender: TObject; TheCanvas: TCanvas;
      PageIndex: Integer; TheRect: TRect; Area: TDrawArea;
      Target: TDrawTarget);


  private
    ParcelTabChild : TForm;  (*** <=== points to current active 'child' form
                      of ParcelTabForm ; every time user uses popup
                      menu to create new child/Tab/form or switch to
                      existing child/Tab/form, this pointer
                      is updated to the new form *****)

    NewTabAdded : Boolean;  {Did we just add a new Tab?}
    TabChanged : Boolean;  {Did we just change a Tab?}

      {The var. ParcelTabChildInitialized tells us whether the
       ParcelTabChild has already been created in the PopupMenuClick
       event. This is to prevent a recursive event calling, i.e.
       the person chooses a new page from the popup menu.
       The PopupMenuClick event creates the parcel and goes to this
       tab. This causes a TabSetChange event which then calls the
       PopupMenuClick event to occur again, which we do not want.
       So, ParcelTabChildInitialized is set to True in PopupMenuClick
       before any forced tab change (i.e. not user driven) event
       can occur and set to False after changing the tab. This
       prevents the above situation.}

    ParcelTabChildInitialized : Boolean;

      {Until the parcel tab form is initialized, we don't want to display
       any parcel pages. That is, the BaseParcelPage1 should not display in
       the background when the locate box appears.}

    ParcelTabFormIsInitialized : Boolean;

      {Make sure that the first time that the locate form is shown, we
       display that parcel, even if there is no SBL change (i.e. they
       select the first parcel.}

    FirstTimeLocateDialogIsShown : Boolean;

    UnitName : String;  {For use in the system support messages.}

    MenuSecurityTags,  {Tags of menu items with entries in the security table.}
    MenuSecurityLevels,  {The corresponding security levels.}
    DisableMenuItems : TStringList;  {The corresponding disable if under access flag.}

      {CHG10281997-1: Dual mode processing.}

    OppositeProcessingType : Integer;
    OppositeTaxYear : String;
    NumUserDataFields : Integer;

    LocatedParcelExists, OppositeYearTabsShowing, ClosingForm : Boolean;
    OriginalLocatedSBLKey : String;

    Procedure SetCaption(SwisSBLKey : String;
                         AccountNumber : String);

    Procedure EnablePopupMenuOptions;

    Function DetermineFormAccessRights(MenuID : Integer) : Integer;  {Based on the security level,
                                                                      do they have read only or read write access?}
  public
      {This will be set in MainForm depending on what option
       is selected from the main menu. This will determine
       what, if anything, should be read only.}

    _EditMode : Char;  {A = Add; M = Modify; V = View}
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    _ResidentialSite : PProcessingTypeArray; {What residential site are we on for this parcel
                                            for history, next year, this year, sales inv?}
    _CommercialSite : PProcessingTypeArray;  {What commercial site are we on for this parcel
                                            for history, next year, this year, sales inv?}
    _CommBuildingNo,
    _CommBuildingSection : PProcessingTypeArray;  {What commercial building and section are they on
                                                 for history, next year, this year, sales inv?}
    _SalesNumber : Integer;  {What sales number are they on? Note that since the sales are
                              year independent, there will be only one sales tab and thus
                              only one sales number that we need to keep track of.}

    _NumResSites,
    _NumComSites : PProcessingTypeArray;  {How many residential and commercial sites are there for this
                                           parcel for history, next year, this year and sales inv.?}

    _TabTypeList : TStringList;  {Because the tabs can span different processing types
                                 within one maintenance session (NextYear, ThisYear,
                                 History, SalesInventory), we need to keep a list
                                 saying which tab is which processing type. This
                                 list does that. The entry positionally says what each tab
                                 type is (i.e. If tab 13 is Sales inv., TabTypeList[12] [zero based]
                                 is 'S'). Note that the only way for the user to add a
                                 tab manually is by the popup menu. So if they do this,
                                 we know that they have just added a tab for the current
                                 global processing year flag. The only other way to add
                                 tabs is by showing the opposite year tabs and the sales
                                 inventory and in both cases we create them ourselves and
                                 have control of putting the processing type in the list.
                                 Note also that tabs are never deleted withing one parcel,
                                 but the whole list will be cleared whenever they change
                                 parcels.}

    _NewTab : Integer;
    CurrentSwisSBLKey : String;
    SwitchingYears : Boolean;

    Procedure SynchronizePages;
    {Synchronize the following pages: Assessment, Sales, GlblYear Residential Site,
     GlblYear Commercial Site, OppositeYear Residential Site, OppositeYear Commercial Site,
     Sales Residential Site, Sales Commercial Site, GlblYear Commercial Bldg No\Sect,
     OppositeYear Commercial Bldg No\Sect, and Sales Commercial Bldg No\Sect.}

    Procedure AbortParcelPageCreate(var Aborted : Boolean);
   {This is the standard error handling if the create of a parcel page fails.}

  end;  {TParcelTabForm = class(TForm)}

implementation

uses (*PBasePg1_New,  {Main parcel 1} *)
     PBasePg1,  {Main parcel 1}
     PBasePg2,  {Main parcel 2}
     PSummary,  {Summary screen}
     PAsmtFrm,  {Parcel Assessments}
     PClassFm,  {Class records}
     PExcdmnt,  {Parcel Exemptions}
     PEXDENY,   {Exemption denials}
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
     Pexremvd,   {Removed exemptions}
     PSalesmt,  {Parcel sales}
     (*PSalesmt_New,  {Parcel sales} *)
     PUserDat,  {User-Defined Data Form}
     PNoteFrm,  {Notes}
     PPicture,  {Pictures}
     PDocumnt,  {Documents}
     PPropertyCard,  {Property cards}
     PSketch,   {Sketches}
     PBldgPmt,  {Building permit tab}
     PrcLocat,  {Parcel locate}
     PPrntPrc,  {Print one parcel}
     Utilitys,  {General utilitys}
     PASUTILS, UTILEXSD,   {PAS specific utilitys}
     PASTypes,  {PAS specific types}
     GlblCnst,  {Global constants}
     WinUtils,  {General Windows utilitys}
     UtilRTot,  {Roll total utilities}
     UASMWARN,
     WarnBox,
     PMap,
     MapParcelInfoDialog,
     RecordSplitMergeNumberDialog,
     ParcelAuditPrintForm,  {Form to print audit trail.}
     ParcelToolbar,
     P3rdPartyNotification,
     PGrievance,
     PCertiorari,
     PSmallClaims,
     PProrata,
     PBuildingPermit_New,
     DataAccessUnit,
     EstimatedTaxLetterUnit,
     PAdditionalOwners,
     PNotes_New,
     PPermits,
     pPermits_Municity,
     PSplitSchoolDistricts,
     ScreenPrintDialogUnit,
     PAgriculture,
     PTaxBillNameAddress;

const
  ExemptionsMenu = 5045;
  ResidentialMenu = 5065;
  CommercialMenu = 5115;

{$R *.DFM}

{===============================================================}
Procedure TParcelTabForm.FormCreate(Sender: TObject);

{CHG02271998-1: Allow print screen from all screens.}
{Note that the parcel screen printing must be done in ParcelTab itself
 because of the way the forms are shown - ParcelTabForm is always the
 active form. To do this, we will give a special tag to the ParcelTabForm
 exclusively so we can tell that that is the active form and don't process
 it in MainForm.  We cannot tell by the caption since the caption changes
 to reflect the mode and parcel ID.}


begin
  SwitchingYears := False;
  Tag := ParcelTabFormTag;
  ClosingForm := False;

    {CHG05011998-2: Add bldg permits.}

    {CHG01302002-2: Change building permit link to allow link to all systems.}

  If (GlblBuildingSystemLinkType = bldNone)
    then Permits.Visible := False;

    {CHG11112003-1(2.07k): If the default searcher map profile is NONE, turn it off.}

  If ((not GlblUsesMaps) or
      (GlblUserIsSearcher and
       (GlblSearcherMapDefault = MapSetupDefaultNone)))
    then MapsMenuItem.Visible := False;

  If ((not GlblUsesGrievances) or
      GlblUserIsSearcher)
    then
      begin
        GrievanceMenuItem.Visible := False;
        CertiorariMenuItem.Visible := False;
        SmallClaimsMenuItem.Visible := False;
      end;

    {CHG12202002-1: Additional security for certs.}

  If not GlblCanSeeCertiorari
    then CertiorariMenuItem.Visible := False;

   {CHG04122001-1(MDT): Record removed exemptions.}
   {Decide whether or not to show the removed exemptions tab.}

  Removed1.Visible := GlblRecordRemovedExemptions;

    {CHG09272001-1: Parcel toolbar.}

(*  If GlblUserWantsParcelToolbar
    then ParcelToolbarForm.Visible := True;*)

  {CHG03282002-1: Allow easy switch between this year and next year for the
                  same parcel.}

  If ((GlblProcessingType = History) or
      (not GlblShowParcelYearFlipMenuItem))
    then SwitchtoOppositeYearMenuItem.Visible := False;

  If not GlblUsesSketches
    then SketchMenuItem.Visible := False;

    {CHG04102003-5(2.07): Restrict parcels for the searcher.}

  If (GlblUseRestrictSearcherParcelsFeature and
      GlblUserIsSearcher)
    then
      try
        RestrictedParcelTable.TableName := 'RestrictedParcelTable';
        RestrictedParcelTable.Open;
        _ParcelTable.Filtered := True;
      except
      end;

  If GlblUsesPASPermits
    then PASPermitsMenuItem.Visible := True;

  If glblUsesTaxBillNameAddr
  then 

end;  {FormCreate}

{=============================================================================}
Procedure TParcelTabForm._ParcelTableFilterRecord(    DataSet: TDataSet;
                                                  var Accept: Boolean);

var
  SwisSBLKey : String;

begin
  Accept := True;

    {CHG04102003-5(2.07): Restrict parcels for the searcher.}
    {FXX02012005-1(2.8.3.3): Do not try to filter the parcel table if the parcel table is not open.}

  If (GlblUseRestrictSearcherParcelsFeature and
      GlblUserIsSearcher and
      (not ClosingForm) and
      _ParcelTable.Active and
      RestrictedParcelTable.Active)
    then
      begin
        SwisSBLKey := ExtractSSKey(_ParcelTable);
        Accept := not FindKeyOld(RestrictedParcelTable, ['SwisSBLKey'], [SwisSBLKey]);
      end;

end;  {ParcelTableFilterRecord}

{=============================================================================}
Procedure TParcelTabForm.SetCaption(SwisSBLKey : String;
                                    AccountNumber : String);

{Set the caption for the parcel to reflect this parcel.
 To do this, we will extract the parcel maint. type (A/M/D/V) and instance number (everything
 to the left of the colon). Then we will add the SBL to this.}

var
  CaptionName : String;

begin
  CaptionName := Copy(Caption, 1, (Pos(':', Caption) - 1));

  Caption := CaptionName + ': ' + ConvertSwisSBLToDashDot(SwisSBLKey);

    {FXX12301999-2: Display if in dual modify.}

  If (GlblModifyBothYears and
      (_EditMode in ['A', 'M']) and
      (GlblProcessingType = ThisYear))
    then Caption := Caption + ' (Change This Year & Next Year)';

    {CHG06042005-1(2.8.4.8): Option to display the account # in the caption.}

  If GlblParcelMaint_DisplayAccountNumber
    then Caption := Caption + ' {Acct: ' + Trim(AccountNumber) + '}';

end;  {SetCaption}

{=============================================================================}
Procedure TParcelTabForm.FormShow(Sender: TObject);

{Set the Tabs of the constant pages, i.e. the forms that will always appear.}

var
  I : Integer;
  Done, FirstTimeThrough, Found, Quit : Boolean;

begin
  ParcelTabSet.Tabs.Clear;
  ParcelTabFormIsInitialized := False;
  OppositeYearTabsShowing := False;

    {allow time for windows to complete drawing of ParcelTabForm}
    {before allowing SearchDialog 'Form' to appear to avoid GPF}

  If not SwitchingYears
    then
      begin
        SearchDialogueTimer.Enabled := True;
        FirstTimeLocateDialogIsShown := True;
      end;

  case GlblProcessingType of
    ThisYear : SwitchtoOppositeYearMenuItem.Caption := 'Switch to Next Year';
    NextYear : SwitchtoOppositeYearMenuItem.Caption := 'Switch to This Year';
  end;

  ParcelTabChildInitialized := False;
  UnitName := 'PARCLTAB.PAS';

     {SEARCH BOX NOT RUNNING AT THIS TIME}
  GlblDialogBoxShowing := False;
  GlblParcelPageCloseCancelled := False;

  _TabTypeList := TStringList.Create;  {See declaration for explanation.}

    {By setting the Tab index to 0, we will cause a TabSetChange event to
     happen, and the first page will show on the notebook.}

  NewTabAdded := False;

    {Create the pointers to the arrays which are going to store the residential
     and commercial info. for this parcel on a per file mode basis (History, ThisYear,
     NextYear, SalesInventory), i.e. ResidentialSite[NextYear] = 2 means that the
     residential site currently selected for the next year tab is 2.}

  New(_ResidentialSite);
  New(_CommercialSite);
  New(_CommBuildingNo);
  New(_CommBuildingSection);
  New(_NumResSites);
  New(_NumComSites);

    {If this is the history file, then we want to
     set the files to read only.}

  If (GlblTaxYearFlg = 'H')
    then _ParcelTable.ReadOnly := True;

  OpenTablesForForm(Self, GlblProcessingType);

    {CHG12051997-1: Allow pictures, documents for LB, Ramapo.}
    {CHG12141997-1: Allow for MP, too.}

    {Now we will determine the security levels of the individual
     popup menu items and store them in an array. Note that a
     security level of 0 for a menu item means that no entry
     exists in the menu security table for this item, so no
     restrictions are placed on its access other than the
     view\modify restrictions (see EnablePopupMenuOptions).
     We will store the various security levels in 3 TStringLists:

      1. MenuSecurityTags with the tags of the menu items that do
         have entries in the security table.
      2. MenuSecurityLevels with the security levels corresponding
         to this entry.
      3. DisableMenuItems with a True/False to say if this menu item
         gets disabled if the person does not have access.

     This way we do not have to keep reaccessing the file to check
     for security.

     To do this, we will go through all the components of the
     form looking for TMenuItems. If we find one, we will check the
     tag value. If it has a tag value greater than 0, we will look
     it up in the menu security table. If we find it, we will add
     it to the list.}

  MenuSecurityTags   := TStringList.Create;
  MenuSecurityLevels := TStringList.Create;
  DisableMenuItems   := TStringList.Create;

  For I := 0 to (ComponentCount - 1) do
    If (Components[I] is TMenuItem)
      then
        with Components[I] as TMenuItem do
          If (Tag > 0)
            then
              begin
                Found := FindKeyOld(MenuSecurityTable, ['MenuID'],
                                    [IntToStr(Tag)]);

                  {Now, if the person does not have a high enough security
                   level to have read\write access to this item (i.e.
                   their security level is less than what is required for
                   this item), let's see if it should be disabled entirely.
                   When can tell by looking at the DisableIfUnderAccess
                   field in the MenuSecurityTable. If it is not disabled, they
                   will have read only access to this item.}

                If Found
                  then
                    begin
                      MenuSecurityTags.Add(IntToStr(Tag));
                      MenuSecurityLevels.Add(MenuSecurityTable.FieldByName('SecurityLevel').AsString);
                      DisableMenuItems.Add(MenuSecurityTable.FieldByName('DisableIfUnderAccess').AsString);

                    end;  {If Found}

              end;  {If (Tag > 0)}

    {CHG11231997-3: Don't allow locate, show opposite year tabs,
                    scroll in add mode.}

  If (_EditMode = 'A')
    then
      with BasePopupMenu do
        For I := 0 to 4 do
          Items[I].Enabled := False;

    {CHG10281997-1: Dual mode processing.
                    Note that there is only edit for assessment page,
                    no delete or insert.}

  If (GlblProcessingType = ThisYear)
    then OppositeProcessingType := NextYear
    else OppositeProcessingType := ThisYear;

  OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

  OpenTableForProcessingType(OppositeYearParcelTable,
                             ParcelTableName,
                             OppositeProcessingType, Quit);

    {Check to see if there are any user defined fields.}
    {FXX12221998-1: Only enable user data form if actual data defined.}

  NumUserDataFields := 0;
  Done := False;
  FirstTimeThrough := True;
  LookupTable.IndexName := '';
  OpenTableForProcessingType(LookupTable,
                             UserDefinitionsTableName,
                             GlblProcessingType, Quit);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else LookupTable.Next;

    If LookupTable.EOF
      then Done := True;

    If ((not Done) and
        LookupTable.FieldByName('Active').AsBoolean)
      then NumUserDataFields := NumUserDataFields + 1;

  until Done;

  LookupTable.Close;

end;  {FormShow}

{================================================================}
Procedure TParcelTabForm.FormActivate(Sender: TObject);

{The OnActivate event gets called in two places -
   1. When the parcel form is created.
   2. When the person re-enters the parcel form after switching
      between jobs along the bottom Tab bar.
 In the first case, we need to create the main parcel form and
 show it.
 In the second case, the main parcel form already exists, so we just
 want to bring the present ParcelTabChild form to the front so that
 it can be seen.}

var
  AllowChange : Boolean;
  TabNum : Integer;

begin
  AllowChange := True;
  SetFormStateMaximized(Self);

    {CHG09272001-1: Parcel toolbar.}

(*  If GlblUserWantsParcelToolbar
    then ParcelToolbarForm.BringToFront; *)

    {For some reason, the OnActivate of the ParcelTabForm is being
     called during shut down at the application level. When this
     happens we will test the GlblApplicationIsClosing variable,
     which is set in the OnClose of the main form. If it is true,
     we will not do any processing.}

  If not GlblApplicationIsClosing
    then
      begin
          {Now, if the ParcelTabShild is nil, then we are creating the
           parcel maintenance, and we need to add the tabs for the pages
           that are always present (i.e. parcel pg 1 and 2). Otherwise,
           if they are coming back to an existing parcel maint. by switching
           tabs along the bottom, we want to bring the present child to front.}

        If (ParcelTabChild = nil)
         then
           begin
             ParcelTabChildInitialized := False;
             NewTabAdded := False;

               {If some tabs already exist (i.e. we are coming back to
                an already created tab session), then we don't want
                to add more. }

             If (ParcelTabSet.Tabs.Count = 0)
               then
                 begin
                   ParcelTabSet.Tabs.Add(BaseParcelPg1TabName);  {MMM}
                   ParcelTabSet.Tabs.Add(BaseParcelPg2TabName);  {MMM}

                     {Also put two entries in the TabTypeList for the two tabs that
                      we just added.}

                   _TabTypeList.Clear;
                   _TabTypeList.Add(GlblTaxYearFlg);
                   _TabTypeList.Add(GlblTaxYearFlg);

                   TabNum := 0;

                 end  {If (ParcelTabSet.Tabs.Count = 0)}
               else TabNum := ParcelTabSet.TabIndex;

             (* {If for some reason the tabs have been created, but the there is no tab selected,
               let's set it to tab index 0 (Base Page 1).}


              then ParcelTabSet.TabIndex := 0;*)

               {Force the parcel tab set to think that this is a new
                tab even if it isn't by calling the ParcelTabSetChange
                event directly.}

             If (ParcelTabSet.TabIndex <> -1)
               then
                 begin
                   ParcelTabChildInitialized := False;
                   ParcelTabSetChange(ParcelTabSet, TabNum, AllowChange);
                 end;

           end
         else
           begin
             ParcelTabChild.BringToFront;

               {FXX03052001-1: Do this to force a refresh of the parcel page when
                               returning.}

             LockWindowUpdate(Handle);
             ParcelTabChild.Hide;
             ParcelTabChild.Show;
             LockWindowUpdate(0);

           end;  {else of If (ParcelTabChild = nil)}

        ParcelTabFormIsInitialized := True;

      end;  {If not GlblApplicationIsClosing}

end;  {FormActivate}

{=======================================================================}
Function TParcelTabForm.DetermineFormAccessRights(MenuID : Integer) : Integer;

{Based on the security level both of the overall job and the individual
 menu item, do they have read only or read
 write access? Note that if they were able to click on this menu item,
 then they must have some access since if they had no access, the
 menu item would have been turned off.}

begin
    {There are two levels of security at work here. There is the main menu
     level security for the over all job, and the popup menu item level
     security which will only apply to a few menu items.}

  If FindKeyOld(MenuSecurityTable, ['MenuID'], [IntToStr(MenuID)])
    then
      begin
        If (FormAccessRights = raReadOnly)
          then Result := raReadOnly
          else
            If (MenuSecurityTable.FieldByName('SecurityLevel').AsInteger > GlblSecurityLevel)
              then Result := raReadOnly
              else Result := raReadWrite;

      end
    else Result := FormAccessRights;

    {CHG10232002-1: Don't allow cert only users to do anything except modify certs.}
    {FXX07012003-3(2.07e): The menuid listed below was for the grievance tab, not the cert tab.}

  If (GlblCertiorariOnly and
      (MenuID <> CertiorariFormNumber) and
      (Result = raReadWrite))
    then Result := raReadOnly;

end;  {DetermineFormAccessRights}

{================================================================}
Procedure TParcelTabForm.PreviewToolbarUserButtonClick(Sender: TObject);

begin
  PreviewMain.Show;
end;

{================================================================}
Procedure TParcelTabForm.FormPrintJobDraw(Sender: TObject;
                                          TheCanvas: TCanvas;
                                          PageIndex: Integer;
                                          TheRect: TRect;
                                          Area: TDrawArea;
                                          Target: TDrawTarget);

var
  Text : String;

begin
  with TheCanvas, TheRect do
    If (Area = daFooter)
      then
        begin
          Rectangle(Left, Top, Right, Bottom);

          Font.Size := 10;
          Font.Style := [fsBold];
          Text := 'Printed on ' + DateToStr(Date);
          TextOut((Left + (Right - Left - TextWidth(Text)) div 2),
                  (Bottom - 5 * TextHeight(Text)), Text);

        end;  {If (Area = daPage)}

end;  {FormPrintJobDraw}

{================================================================}
Procedure TParcelTabForm.FormKeyDown(    Sender: TObject;
                                     var Key: Word;
                                         Shift: TShiftState);

var
  Bookmark : TBookmark;
  FoundRec, ActiveParcel : Boolean;
  SBLRec : SBLRecord;
  SwisSBLKey : String;
  TempPanel : TPanel;
  ScreenFileName, TempComparablesCommandLine : String;
  ComparablesPChar : PChar;
  TempLen : Integer;
  Bitmap : TBitmap;

begin
    {FXX10041999-5: Need dummy sender for parcel scroll click to solve problem
                    where have 2 views up, go back to first, press PgUp, get
                    "Component named PreviousParcel already exists.}

  TempPanel := TPanel.Create(nil);                                                      

  If _Compare(Key, VK_F4, coEqual)
    then
      begin
        Bitmap := Self.GetFormImage;

        If not DirectoryExists('c:\Temp')
          then ForceDirectories('c:\Temp');

        ScreenFileName := GetTemporaryFileName('Screen');
        Bitmap.SaveToFile('c:\temp\' + ScreenFileName);

        ExecuteScreenPrintDialog('c:\temp\' + ScreenFileName);

      end;  {If _Compare(Key, VK_F4, coEqual)}

   {CHG01211998-2: Allow printing of screens.  Note that we are using F3
                   since for some reason, PrintScreen is never
                   passed through to Delphi - it is intercepted at the
                   Windows level, and we get no acknowledgement of the
                   key press.}

  If (Key = VK_F3)
    then
      begin
        Key := 0;
          {FXX04022003-2(2.06r): Allow switching between the form print methods because
                                 of errors in one or the other.}
          {FXX10092004-2(2.8.0.14): Print the tabs, too when doing a print screen.}
          {FXX12022004-1(2.8.1.1): Make sure that the form is focused before doing a screen
                                   print so don't have problem when tool bar is up.}
          {CHG01122004-2(2.8.2.3): Try another print screen component.}
          {CHG04182005-1(2.8.4.2): Each user can choose from any 3 print screen method.}

(*        case GlblPrintScreenMethod of
          psNormal : PrintScreen(Application, ParcelTabChild,
                                 0, 0, ParcelTabChild.Width,
                                 (ParcelTabChild.Height + GetSystemMetrics(SM_CYHSCROLL)));
          psExcellentPrinter : TFormPrint_PrintScreen(Application, ParcelTabChild);
          psPrintSuite :
            begin
              FormPrintJob.UpdateBitmap;
              PreviewToolbar.ButtonClick(btnPrint);
            end;

        end;  {case GlblPrintScreenMethod of} *)

        If GlblUsePrintSuitePrintScreen
          then
            begin
              SelectPrinterForPrintScreen;
              FormPrintJob.UpdateBitmap;
              PreviewToolbar.ButtonClick(btnPrint);

            end
          else
            If GlblUseTFormPrint
              then TFormPrint_PrintScreen(Application, ParcelTabChild)
              else PrintScreen(Application, ParcelTabChild,
                               0, 0, ParcelTabChild.Width,
                               (ParcelTabChild.Height + GetSystemMetrics(SM_CYHSCROLL)));

      end;

  If ((Key = VK_F7) and
      GlblUserCanSeeComparables)
    then
      begin
          {FXX02032004-2(2.07l): Put the SwisSBL in double quotes for municipalilites
                                 with blanks in the SBL such as Glen Cove.}

        TempComparablesCommandLine := 'PASComparables.EXE TYPE=SALES ' +
                                      'PARCELID="' +
                                      TParcelTabForm(GlblParcelMaintenance).CurrentSwisSBLKey + '"';

        TempLen := Length(TempComparablesCommandLine);
        ComparablesPChar := StrAlloc(TempLen + 1);
        StrPCopy(ComparablesPChar, TempComparablesCommandLine);

        WinExec(ComparablesPChar, SW_SHOW);
        StrDispose(ComparablesPChar);

        SendToBack;

      end;  {If (Key = VK_F7)}

  If ((Key = VK_F6) and
      GlblPrintEstimatedTaxLetters)
    then
      try
        EstimatedTaxLetterForm := TEstimatedTaxLetterForm.Create(Application);
        EstimatedTaxLetterForm.SwisSBLKey := ExtractSSKey(_ParcelTable);
        EstimatedTaxLetterForm.ShowModal;
      finally
        EstimatedTaxLetterForm.Free;
      end;  {If (Key = VK_F6)}

    {Just call the existing Scroll event handler for the Next and Previous
     Parcel on the pop up menu.}

  If (Key = VK_Prior)
    then
      begin
        Key := 0;
        TempPanel.Name := 'PreviousParcel';
        ParcelScrollClick(TempPanel);

      end;  {If (Key = VK_Prior)}

  If (Key = VK_Next)
    then
      begin
        Key := 0;
        TempPanel.Name := 'NextParcel';
        ParcelScrollClick(TempPanel);

      end;  {If (Key = VK_Next)}

    {If there is a roll section 9 linked sbl and they press F9, go to it.}

  If ((Key = VK_F9) and
      (Deblank(_ParcelTable.FieldByName('RS9LinkedSBL').Text) <> ''))
    then
      begin
        Bookmark := _ParcelTable.GetBookmark;
        SwisSBLKey := _ParcelTable.FieldByName('RS9LinkedSBL').Text;

          {Synchronize the main parcel table on this
           form with the parcel search table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          FoundRec := FindKeyOld(_ParcelTable,
                                 ['TaxRollYr', 'SwisCode', 'Section',
                                  'Subsection', 'Block', 'Lot',
                                  'Sublot', 'Suffix'],
                                 [GetTaxRlYr, SwisCode, Section, Subsection,
                                  Block, Lot, Sublot, Suffix]);

        If not FoundRec
          then SystemSupport(101, _ParcelTable, 'Error getting parcel record.',
                             UnitName, GlblErrorDlgBox);

          {Now if the parcel is inactive, then we will not let them modify it.}

        ActiveParcel := True;

        If (FoundRec and
            (_EditMode = 'M') and
            (_ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag))
          then
            begin
              MessageDlg('That parcel is inactive and can not be modified.' + #13 +
                         'Please select a different parcel.', mtError, [mbOK], 0);
              ActiveParcel := False;
            end;

          {Now if we found the parcel and it is active (only applies for modify),
           then let's display it.}

        If (FoundRec and
            ActiveParcel)
          then
            begin
              SetCaption(SwisSBLKey, _ParcelTable.FieldByName('AccountNo').Text);

              NewTabAdded := False;

                {Set up the main tabs for parcel, i.e. the ones that apply to the GlblTaxYrFlg.}

              SetMainTabsForParcel(ParcelTabSet, _TabTypeList, LookupTable, SwisSBLKey,
                                   GetTaxRlYr, _SalesNumber,
                                   _ResidentialSite, _CommercialSite, _CommBuildingNo,
                                   _CommBuildingSection, _NumResSites, _NumComSites,
                                   True);

              EnablePopupMenuOptions;

                {Now we will simulate a click on the base form so that we go to
                 this form.}
                {CHG09301997 - Start on the first page that the
                               user wants - summary, base page 1
                               or 2 or assessment.}

                {CHG01082003-1: Allow for a different default on the parcel view, too.}

              with Sender as TComponent do
                If (_EditMode = 'V')
                  then Tag := GlblDefaultParcelViewPage
                  else Tag := GlblFirstParcelPageShown;

                {CHG08182002-2: Default Cert Only users to the cert page.}

              If GlblCertiorariOnly
                then
                  with Sender as TComponent do
                    Tag := CertiorariFormNumber;

              PopupMenuClick(Sender);

            end  {If FoundRec}
          else _ParcelTable.GotoBookmark(Bookmark);

        _ParcelTable.FreeBookmark(Bookmark);

      end;  {If ((Key = VK_F9) and ...}

  If (Key = VK_F5)
    then
      try
        with ParcelPrintDialog do
          begin
            SwisSBLKey := ExtractSSKey(_ParcelTable);
(*            ProcessingType := NextYear; *)

              {FXX05132009-1(2.10.1.1)[D954]: Property card printed in a history year has the wrong STAR amounts.}

            ProcessingType := GlblProcessingType; 
            GlblDialogBoxShowing := True;
            ShowModal;
            GlblDialogBoxShowing := False;
          end;
      except
        NonBtrvSystemSupport(104, 1, 'Error showing Parcel Print Dialog',
                             'PARCLTAB', GlblErrorDlgBox);
      end;

    {FXX08142002-3: Don't make the ParcelAuditPrintDialog autocreate since
                    it is causing a memory leak for some strange reason.}

  If ((Key = VK_F8) and
      GlblUserCanRunAudits)
    then
      try
        ParcelAuditPrintDialog := TParcelAuditPrintDialog.Create(nil);

        with ParcelAuditPrintDialog do
          begin
            SwisSBLKey := ExtractSSKey(_ParcelTable);
            GlblDialogBoxShowing := True;
            SetHeaderLabel(SwisSBLKey);
            ShowModal;
            GlblDialogBoxShowing := False;
          end;
      finally
        ParcelAuditPrintDialog.Free;
      end;

  TempPanel.Free;

end;  {FormKeyDown}

{================================================================}
Procedure TParcelTabForm.FormKeyPress(    Sender: TObject;
                                      var Key: Char);

begin
    {FXX02061998-2: Enter to tab for grids is controlled at the grid level.}

  If (Key = #13)
    then
      If (not ((Screen.ActiveControl is TwwDBGrid) or
               (Screen.ActiveControl is TDBGrid) or
               (Screen.ActiveControl is TListView)))
        then
          begin  {Not a grid.}
            Perform(WM_NEXTDLGCTL, 0, 0);
            Key := #0;
          end;

end;  {FormKeyPress}

{================================================================}
Procedure TParcelTabForm.SynchronizePages;

{Synchronize the following pages: Assessment, Sales, GlblYear Residential Site,
 GlblYear Commercial Site, OppositeYear Residential Site, OppositeYear Commercial Site,
 Sales Residential Site, Sales Commercial Site, GlblYear Commercial Bldg No\Sect,
 OppositeYear Commercial Bldg No\Sect, and Sales Commercial Bldg No\Sect.

 By GlblYear I mean the tax processing year that they chose at the beggining of this
 PAS session (stored in GlblTaxYearFlg). By OppositeYear I mean the set of tabs created
 when they chose "Show (This\Next) Year Tabs" off the popup menu. By Sales, I mean the
 sales inventory pages.

 This means that if they are leaving any of the above pages, we want to make
 a note (put in a var.) of what particular record they are on. In the case of
 the Assessment page, this is so that if they come back to this page, we will
 put them back at that record. In the case of the Sales page, this is so that we
 can put them back at the same sales record and so that if they go to a sales inventory
 page, we will have the proper sales number to synch to.

 For all the residential site pages, we want to record the site number so that any
 dependant pages (bldg, forest, improvement, land) display items for this site.
 Also, this way they return to the same residential site.

 Similarly for all the commercial site pages, we want to record the site number so that
 any dependant pages (bldg, land, improvement, income\expense, rent) display items only
 for this site. Also, this way they return to the same commercial site.

 Finally, we for all the commercial building pages, we want to record the building number
 and section so that they return to this record.

 We will be able to tell the processing type (H,N,T,S) by looking at the TabTypeList
 for the present tab since when we get here, the tab has not yet been changed.}

var
  ProcessingType, Index : Integer;

begin
    {The processing type of this form is determined by the entry in the TabTypeList for
     this tab.}

  If (ParcelTabSet.TabIndex = -1)
    then Index := 0
    else Index := ParcelTabSet.TabIndex;

  If (_TabTypeList <> nil)
    then
      begin
        ProcessingType := DetermineProcessingType(_TabTypeList[Index][1]);

          {If this is the residential site form, then we want to check to
           see if they changed sites. If they did, then we will store the
           site in a variable called ResidentialSite defined in the
           ParcelTabForm object which we can them use as a basis to
           access all records for that site.
           Also, we want to update the }

        If ((ParcelTabChild <> nil) and
            (ParcelTabChild is TParcelResidentialSiteForm))
          then
            with ParcelTabChild as TParcelResidentialSiteForm do
              begin
                _ResidentialSite^[ProcessingType] := MainTable.FieldByName('Site').AsInteger;
                _NumResSites^[ProcessingType] := NumResSites;
              end;

          {Do the same here for the commercial site form.}

        If ((ParcelTabChild <> nil) and
            (ParcelTabChild is TParcelCommercialSiteForm))
          then
            with ParcelTabChild as TParcelCommercialSiteForm do
              begin
                _CommercialSite^[ProcessingType] := MainTable.FieldByName('Site').AsInteger;
                _NumComSites^[ProcessingType] := NumComSites;
              end;

          {Now set the commercial building no and section here for the commercial bldg form.}

        If ((ParcelTabChild <> nil) and
            (ParcelTabChild is TParcelCommercialBldgForm))
          then
            with ParcelTabChild as TParcelCommercialBldgForm do
              begin
                _CommBuildingNo^[ProcessingType] := MainTable.FieldByName('BuildingNumber').AsInteger;
                _CommBuildingSection^[ProcessingType] :=
                                        MainTable.FieldByName('BuildingSection').AsInteger;
              end;

          {Figure out the sales number if this is the sales form.}

        If ((ParcelTabChild <> nil) and
            (ParcelTabChild is TSalesPageForm))
          then
            with ParcelTabChild as TSalesPageForm do
              _SalesNumber := MainTable.FieldByName('SaleNumber').AsInteger;

      end;  {If (TabTypeList <> nil)}

end;  {SynchronizePages}

{================================================================}
Procedure TParcelTabForm.ParcelTabSetChange(    Sender: TObject;
                                                NewTab: Integer;
                                            var AllowChange: Boolean);

{We will create the new form. Note that we do not have to worry about
 changing pages in the notebook, too since there is only actually one
 page in the notebook - we just keep displaying different forms on it.

 Also, in this case where they are switching Tabs along the bottom, we want
 to try to close the form here in order to get close verification from the person
 if any changes were made. This way, if they select cancel and want to stay
 on the same page, then we can set AllowChange to False and the Tab never
 gets changed and nothing happens.

 However, in the PopupClick event handler, we also try to close and free the
 form since the PopupClick is the event that is called when a person wants
 to create a new form, and we need to free up the present form. This means
 that if a person is changing Tabs, Child.Close and Child.Free are called in
 the TabSetChange event handler (this one) and the PopupClick handler. This
 will cause a GPF. To avoid this, we set a global variable (Global to this unit
 only) called TabChanged. This way when we get to the PopupClick event handler,
 we don't try to close and free the child form again.

 Another thing to note is that when a new form is added (via the popup menu),
 the child is created first, then a Tab is added, then we switch to that Tab.
 However this switching causes a TabSetChange event to occur. But, we don't
 actually want to do any processing in the TabSetChange event in this case
 since everything has already been set (child created, Tab added, Tab selected).
 So, a var. Global to this unit called NewTabAdded is set in the PopupClick
 event and if it is True when we get to the TabSetChange event, we do no
 further processing.}

var
  NewTabName : String;
  I, CurrentTab : Integer;
  TempAllowChange : Boolean;

begin
  If (NewTab <> -1)
    then NewTabName := ParcelTabSet.Tabs[NewTab];

  CurrentTab := ParcelTabSet.TabIndex;

    {CHG06122001-1: Only let the searcher view summary and pg1}

  If (GlblUserIsSearcher and
      GlblSearcherOnlySeesSummaryAndPage1 and
      (NewTabName <> BaseParcelPg1TabName) and
      (NewTabName <> SummaryTabName))
    then AllowChange := False;

    {See the variable section for an explanation of ParcelTabChildInitialized
     and ParcelTabFormIsInitialized.}

  If (ParcelTabFormIsInitialized and
      (not ParcelTabChildInitialized) and
      (NewTab <> -1) and
      AllowChange)
    then
      If NewTabAdded
        then NewTabAdded := False
        else
          begin
            TabChanged := True;

              {Be sure to make note of what site we are on if they
               were just in the residential or commercial pages since
               all of the pages below it (i.e. Residential Land) depend
               on which site they are on. Also make a note of what sales number
               or assessment date we are on.}

            SynchronizePages;

              {First try to close it - this will make sure that they
               save any changes.}

            If (ParcelTabChild <> nil)
              then ParcelTabChild.Close;

            If GlblParcelPageCloseCancelled
              then AllowChange := False
              else
                begin
                  try
                    ParcelTabChild.Free;
                    ParcelTabChild := nil;
                  except
                  end;

(*                  If (ParcelTabChild <> nil)
                    then
                      begin
                        ParcelTabChild.Release;  {Free the present page.}
                        ParcelTabChild := nil; {This is very important -
                                                Free does not nil pointer.}
                      end; *)

                  with Sender as TControl do
                    begin
                      If (NewTabName = BaseParcelPg1TabName)
                        then Tag := BaseParcelPg1FormNumber;

                      If (NewTabName = BaseParcelPg2TabName)
                        then Tag := BaseParcelPg2FormNumber;

                      If (NewTabName = SummaryTabName)
                        then Tag := SummaryFormNumber;

                      If (NewTabName = AssessmentTabName)
                        then Tag := AssessmentFormNumber;

                      If (NewTabName = ClassTabName)
                        then Tag := ClassFormNumber;

                      If (NewTabName = SpecialDistrictTabName)
                        then Tag := SpecialDistrictFormNumber;

                      If (NewTabName = ExemptionsTabName)
                        then Tag := ExemptionsFormNumber;

                        {CHG08021999-3: Add exemptions denial page.}

                      If (NewTabName = ExemptionsDenialTabName)
                        then Tag := ExemptionsDenialFormNumber;

                        {CHG04122001-1(MDT): Record removed exemptions.}

                     If (NewTabName = ExemptionsRemovedTabName)
                        then Tag := ExemptionsRemovedFormNumber;

                      If (NewTabName = SalesTabName)
                        then Tag := SalesFormNumber;

                      If (NewTabName = ResidentialSiteTabName)
                        then Tag := ResidentialSiteFormNumber;

                      If (NewTabName = ResidentialBldgTabName)
                        then Tag := ResidentialBldgFormNumber;

                      If (NewTabName = ResidentialLandTabName)
                        then Tag := ResidentialLandFormNumber;

                      If (NewTabName = ResidentialForestTabName)
                        then Tag := ResidentialForestFormNumber;

                      If (NewTabName = ResidentialImprovementsTabName)
                        then Tag := ResidentialImprovementsFormNumber;

                      If (NewTabName = CommercialSiteTabName)
                        then Tag := CommercialSiteFormNumber;

                      If (NewTabName = CommercialBldgTabName)
                        then Tag := CommercialBldgFormNumber;

                      If (NewTabName = CommercialLandTabName)
                        then Tag := CommercialLandFormNumber;

                      If (NewTabName = CommercialImprovementsTabName)
                        then Tag := CommercialImprovementsFormNumber;

                      If (NewTabName = CommercialRentTabName)
                        then Tag := CommercialRentFormNumber;

                      If (NewTabName = CommercialIncomeExpenseTabName)
                        then Tag := CommercialIncomeExpenseFormNumber;

                       If (NewTabName = UserDataTabName)
                        then Tag := UserDataFormNumber;

                      If (NewTabName = NotesTabName)
                        then Tag := NotesFormNumber;

                      If (NewTabName = PictureTabName)
                        then Tag := PictureFormNumber;

                      If (NewTabName = DocumentTabName)
                        then Tag := DocumentFormNumber;

                      If (NewTabName = AgricultureTabName)
                        then Tag := AgricultureFormNumber;

                      If (NewTabName = PropertyCardTabName)
                        then Tag := PropertyCardFormNumber;

                      If (NewTabName = SketchTabName)
                        then Tag := SketchFormNumber;

                        {CHG05011998-2: Add building permit report}

                      If (NewTabName = PermitsTabName)
                        then Tag := PermitsFormNumber;

                        {FXX01252011-2[I6818](2.26.1.32): The security level disable was not working for some tabs
                                                          since the Tag was assigned after the check.} 

                      If (NewTabName = MapTabName)
                        then Tag := MapFormNumber;

                      If (NewTabName = ProrataTabName)
                        then Tag := ProrataFormNumber;

                        {CHG01082002-1: 3rd party notification}

                      If (NewTabName = ThirdPartyNotificationTabName)
                        then Tag := ThirdPartyNotificationFormNumber;

                      If (NewTabName = AdditionalOwnersTabName)
                        then Tag := AdditionalOwnersFormNumber;

                      If (NewTabName = GrievanceTabName)
                        then Tag := GrievanceFormNumber;

                      If (NewTabName = CertiorariTabName)
                        then Tag := CertiorariFormNumber;

                      If (NewTabName = SmallClaimsTabName)
                        then Tag := SmallClaimsFormNumber;

                      If (NewTabName = PASPermitsTabName)
                        then Tag := PASPermitsFormNumber;

                      If (NewTabName = SplitSchoolDistrictTabName)
                        then Tag := SplitSchoolDistrictFormNumber;

                      If (NewTabName = TaxBillAddressTabName)
                        then Tag := TaxBillAddressFormNumber;

                        {CHG09172001-2: Enforce disable options for parcel pages.}

                      For I := 0 to (MenuSecurityTags.Count - 1) do
                        If ((MenuSecurityTags[I] = IntToStr(Tag)) and {Does this match the tag we are looking for?}
                            (GlblSecurityLevel < StrToInt(MenuSecurityLevels[I])) and
                            (DisableMenuItems[I] = 'True'))
                          then AllowChange := False;

                      If AllowChange
                        then
                          begin
                            _NewTab := NewTab;
                            PopupMenuClick(Sender);
                          end
                        else
                          begin
                              {If they are not allowed to go to this page, send
                               'em back from whence they came.}

                            TempAllowChange := True;
                            ParcelTabSetChange(Sender, CurrentTab, TempAllowChange);

                          end;  {If AllowChange}

                    end;  {with Sender as TControl do}

                end;  {else of If GlblParcelPageCloseCancelled}

          end;  {else of If NewTabAdded}

end;  {TabSetChange}

{================================================================}
{===============  FROM HERE ON IS HANDLING POPUP MENU CLICKS ====}
{================================================================}
Procedure TParcelTabForm.EnablePopupMenuOptions;

{If the residential site page exists, then enable all the pages "below it"
 (i.e. ones that have the residential site as part of their key. Simiarly,
 examine all pages dependant on the commercial site.
 Note that any base level pages (all the way to the left on the popup
 menu such as sales) will always be accessible in modify mode, but only
 accessible in view mode if a record exists for such an instance.

 Note that in edit mode, we will let them go to pages that do not
 exist. This is the same as adding a page.
 However, in view mode, we will only let them go to pages that
 already exist. This will be done by looking at what tabs exist
 for this parcel since to determine which tabs applied to this
 parcel, we had to look in each file for the existence of a tab.}

var
  I, J,
  ProcessingType : Integer;  {History, NextYear, SalesInventory, ThisYear}
  ResSiteExists, CommSiteExists : Boolean;

begin
    {The processing year of anything on the popup menu is the global tax year.}

  ProcessingType := DetermineProcessingType(GlblTaxYearFlg);

    {If the ResidentialSite is zero, then there may not yet be a residential
     site for this record - we will check (there is a case where
     ResidentialSite = 0 but a residential site does exist: If they hav
     so we will not allow them to add records below
     the residential site. Note that the tab may exist for the residential
     site, but until they actually add a record, we won't enable the
     records below it.}

  If ShowInventory
    then
      begin
        OpenLookupTable(LookupTable, ResidentialSiteTableName, DetermineProcessingType(GlblTaxYearFlg));
        LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

        If (_ResidentialSite^[ProcessingType] = 0)
          then ResSiteExists := FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                                           [_ParcelTable.FieldByName('TaxRollYr').Text, ExtractSSKey(_ParcelTable)])
          else ResSiteExists := True;

      end
    else ResSiteExists := False;

    {If the CommercialSite is zero, then there may not yet be a Commercial
     site for this record - we will check (there is a case where
     CommercialSite = 0 but a Commercial site does exist: If they hav
     so we will not allow them to add records below
     the Commercial site. Note that the tab may exist for the Commercial
     site, but until they actually add a record, we won't enable the
     records below it.}

  If ShowInventory
    then
      begin
        OpenLookupTable(LookupTable, CommercialSiteTableName, DetermineProcessingType(GlblTaxYearFlg));
        LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

        If (_CommercialSite^[ProcessingType] = 0)
          then CommSiteExists := FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                                            [_ParcelTable.FieldByName('TaxRollYr').Text, ExtractSSKey(_ParcelTable)])
          else CommSiteExists := True;
      end
    else CommSiteExists := False;

  case _EditMode of
    'A',
    'M' : For I := 0 to (BasePopupMenu.Items.Count - 1) do
            with BasePopupMenu.Items[I] do
              case Tag of
                  {The class option is only enabled if this is a split
                   parcel.}

                ClassFormNumber :
                  Enabled := _ParcelTable.FieldByName('HomesteadCode').Text = 'S';

                  {Because we moved the individual residential and
                   commercial inventory menu selections to a sub menu, we
                   will first search for the "Residential" or "Commercial"
                   main level item of the PopupMenu. When we have found
                   one, we will go through the submenu and determine
                   which type of inventory tab is enabled.}
                  {If this is roll section 9, no editing of the inventory
                   is allowed.}

                  {FXX10271997-4: When I added the parcel pages to the
                                  menu security system, I blanked out the
                                  tags of the inventory menu items on the
                                  popup menu since I did not want a security
                                  entry at this level, but it caused a problem
                                  when deciding what inv options were avail.
                                  So, I created seperate consts for the inv. menu
                                  items.}

                ResidentialMenu :
                  If (_ParcelTable.FieldByName('RollSection').Text = '9')
                    then Enabled := False
                    else
                      begin
                        Enabled := True;

                        For J := 0 to (BasePopupMenu.Items[I].Count - 1) do

                          with BasePopupMenu.Items[I].Items[J] do
                            case Tag of
                              ResidentialBldgFormNumber :
                                Enabled := ResSiteExists;

                              ResidentialLandFormNumber :
                                Enabled := ResSiteExists;

                              ResidentialForestFormNumber :
                                Enabled := ResSiteExists;

                              ResidentialImprovementsFormNumber :
                                Enabled := ResSiteExists;

                            end;  {case Tag of}

                      end;  {else of If (_ParcelTable.FieldByName('RollSection').Text = '9')}

                  {If this is roll section 9, no editing of the inventory
                   is allowed.}

                CommercialMenu :
                  If (_ParcelTable.FieldByName('RollSection').Text = '9')
                    then Enabled := False
                    else
                      begin
                        Enabled := True;

                        For J := 0 to (BasePopupMenu.Items[I].Count - 1) do
                          with BasePopupMenu.Items[I].Items[J] do
                            case Tag of
                              CommercialBldgFormNumber :
                                Enabled := CommSiteExists;

                              CommercialLandFormNumber :
                                Enabled := CommSiteExists;

                              CommercialImprovementsFormNumber :
                                Enabled := CommSiteExists;

                              CommercialRentFormNumber :
                                Enabled := CommSiteExists;

                              CommercialIncomeExpenseFormNumber :
                                Enabled := CommSiteExists;

                            end;  {case Tag of}

                      end;  {else of If (_ParcelTable.FieldByName('RollSection').Text = '9')}

                   {If this is roll section 9, they can never go to inventory,
                    sales, or exemptions.}

                ExemptionsMenu :
                  If (_ParcelTable.FieldByName('RollSection').Text = '9')
                    then Enabled := False
                    else Enabled := True;

                SalesFormNumber :
                  Enabled := (_ParcelTable.FieldByName('RollSection').Text <> '9');

                  {CHG05011998-2: Add building permits}
                  {Only visible if permits exist since can't add or delete.}

                PermitsFormNumber :
                  Enabled := (GlblUserCanViewPermits and
                              (ParcelTabSet.Tabs.IndexOf(PermitsTabName) <> -1));

                ProrataFormNumber :
                  Enabled := GlblUsesProrata;

                  {FXX12221998-1: Only enable user data form if actual data defined.}

                UserDataFormNumber :
                  Enabled := (NumUserDataFields > 0);

                GrievanceFormNumber :
                  Enabled := GlblUsesGrievances;

                CertiorariFormNumber :
                  Enabled := GlblCanSeeCertiorari;

                SmallClaimsFormNumber :
                  Enabled := GlblUsesGrievances;

                MapFormNumber :
                  Enabled := GlblUsesMaps;

                PASPermitsFormNumber :
                  Enabled := GlblUsesPASPermits;

                SplitSchoolDistrictFormNumber :
                  Enabled := GlblDisplaySplitSchoolSBLs;

              end;  {case BasePopupMenu.Items.Tag of}

    'V' : For I := 0 to (BasePopupMenu.Items.Count - 1) do
            with BasePopupMenu.Items[I] do
              case Tag of
                BaseParcelPg1FormNumber :
                  Enabled := (ParcelTabSet.Tabs.IndexOf(BaseParcelPg1TabName) <> -1);

                BaseParcelPg2FormNumber :
                  Enabled := (ParcelTabSet.Tabs.IndexOf(BaseParcelPg2TabName) <> -1);

                SummaryFormNumber :
                  Enabled := (ParcelTabSet.Tabs.IndexOf(SummaryTabName) <> -1);

                AssessmentFormNumber :
                  Enabled := (ParcelTabSet.Tabs.IndexOf(AssessmentTabName) <> -1);

                ClassFormNumber :
                  Enabled := (ParcelTabSet.Tabs.IndexOf(ClassTabName) <> -1);

                SpecialDistrictFormNumber :
                  Enabled := (ParcelTabSet.Tabs.IndexOf(SpecialDistrictTabName) <> -1);

                ExemptionsMenu :
                  For J := 0 to (BasePopupMenu.Items[I].Count - 1) do
                    with BasePopupMenu.Items[I].Items[J] do
                      case Tag of
                        ExemptionsFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(ExemptionsTabName) <> -1);

                            {CHG08021999-3: Add exemptions denial page.}

                        ExemptionsDenialFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(ExemptionsDenialTabName) <> -1);

                          {CHG04122001-1(MDT): Record removed exemptions.}

                        ExemptionsRemovedFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(ExemptionsRemovedTabName) <> -1);

                      end;  {case Tag of}

                SalesFormNumber :
                  Enabled := (ParcelTabSet.Tabs.IndexOf(SalesTabName) <> -1);

                  {Because we moved the individual residential and
                   commercial inventory menu selections to a sub menu, we
                   will first search for the "Residential" or "Commercial"
                   main level item of the PopupMenu. When we have found
                   one, we will go through the submenu and determine
                   which type of inventory tab is enabled.}

                  {FXX11171997-5: See FXX10271997-4 above.}

                ResidentialMenu:
                  For J := 0 to (BasePopupMenu.Items[I].Count - 1) do
                    with BasePopupMenu.Items[I].Items[J] do
                      case Tag of
                        ResidentialSiteFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(ResidentialSiteTabName) <> -1);

                        ResidentialBldgFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(ResidentialBldgTabName) <> -1);

                        ResidentialLandFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(ResidentialLandTabName) <> -1);

                        ResidentialForestFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(ResidentialForestTabName) <> -1);

                        ResidentialImprovementsFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(ResidentialImprovementsTabName) <> -1);

                      end;  {case Tag of}

                CommercialMenu:
                  For J := 0 to (BasePopupMenu.Items[I].Count - 1) do
                    with BasePopupMenu.Items[I].Items[J] do
                      case Tag of
                        CommercialSiteFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(CommercialSiteTabName) <> -1);

                        CommercialBldgFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(CommercialBldgTabName) <> -1);

                        CommercialLandFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(CommercialLandTabName) <> -1);

                        CommercialImprovementsFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(CommercialImprovementsTabName) <> -1);

                        CommercialRentFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(CommercialRentTabName) <> -1);

                        CommercialIncomeExpenseFormNumber :
                          Enabled := (ParcelTabSet.Tabs.IndexOf(CommercialIncomeExpenseTabName) <> -1);

                      end;  {case Tag of}

                UserDataFormNumber :
                  Enabled := (ParcelTabSet.Tabs.IndexOf(UserDataTabName) <> -1);

                  {CHG09251996 - The user can edit notes even during
                                 inquire.}
                  {FXX11191997-1: Don't let the searcher see notes.}

                NotesFormNumber :
                  Enabled := not GlblUserIsSearcher;

                  {CHG05011998-2: Add building permits}
                  {Only visible if permits exist since can't add or delete.}

                PermitsFormNumber :
                  Enabled := (GlblUserCanViewPermits and
                              (ParcelTabSet.Tabs.IndexOf(PermitsTabName) <> -1));

                ProrataFormNumber :
                  Enabled := (ParcelTabSet.Tabs.IndexOf(ProrataTabName) <> -1);

                ThirdPartyNotificationFormNumber :
                  Enabled := (ParcelTabSet.Tabs.IndexOf(ThirdPartyNotificationTabName) <> -1);

                AdditionalOwnersFormNumber :
                  Enabled := (ParcelTabSet.Tabs.IndexOf(AdditionalOwnersTabName) <> -1);

                GrievanceFormNumber :
                  Enabled := (GlblUsesGrievances and
                              (ParcelTabSet.Tabs.IndexOf(GrievanceTabName) <> -1));

                CertiorariFormNumber :
                  Enabled := (GlblUsesGrievances and
                              GlblCanSeeCertiorari and
                              (ParcelTabSet.Tabs.IndexOf(CertiorariTabName) <> -1));

                SmallClaimsFormNumber :
                  Enabled := (GlblUsesGrievances and
                              (ParcelTabSet.Tabs.IndexOf(SmallClaimsTabName) <> -1));

                  {CHG11112003-1(2.07k): If the default searcher map profile is NONE, turn it off.}

                MapFormNumber :
                  Enabled := (GlblUsesMaps and
                              ((not GlblUserIsSearcher) or
                               (GlblUserIsSearcher and
                                (GlblSearcherMapDefault = MapSetupDefaultNone))));

                PASPermitsFormNumber :
                  Enabled := (ParcelTabSet.Tabs.IndexOf(PASPermitsTabName) <> -1);

                SplitSchoolDistrictFormNumber :
                  Enabled := GlblDisplaySplitSchoolSBLs;

              end;  {case BasePopupMenu.Items[I].Tag of}

  end;  {case _EditMode of}

    {Now apply the security to the menu items.
     Once we find the menu item corresponding to the tag, we will
     compare the global security level with the security level for
     this menu item. If they do not have access, we will disable
     this item.}

  For I := 0 to (MenuSecurityTags.Count - 1) do
    For J := 0 to (ComponentCount - 1) do
      If ((Components[J] is TMenuItem) and  {Is this a menu item?}
          (MenuSecurityTags[I] = IntToStr(TMenuItem(Components[J]).Tag))) {Does this match the tag we are looking for?}
        then
          If ((GlblSecurityLevel < StrToInt(MenuSecurityLevels[I])) and
              (DisableMenuItems[I] = 'True'))
            then TMenuItem(Components[J]).Enabled := False;

end;  {EnablePopupMenuOptions}

{================================================================}
Procedure TParcelTabForm.AbortParcelPageCreate(var Aborted : Boolean);

{This is the standard error handling if the create of a parcel page fails.}

begin
  NonBtrvSystemSupport(050, 0, 'Error creating form.', UnitName, GlblErrorDlgBox);
  Aborted := True;
  GlblChildWindowCreateFailed := True;
  ParcelTabChild.Free;
  Close;

end;  {AbortParcelPageCreate}

{================================================================}
Procedure SetPartialAssessmentLabel(PartialAssessment : Boolean;
                                    PartialAssessmentLabel,
                                    TotalAVLabel : TLabel);

{CHG04102001-1: Put a star if this is a partial assesement.}

begin
  with PartialAssessmentLabel do
    If PartialAssessment
      then
        begin
          Visible := True;
          Left := TotalAVLabel.Left + TotalAVLabel.Width + 4;
          Height := 19;
          Hint := 'This parcel is partially assessed.';

        end
      else Visible := False;

end;  {SetPartialAssessmentLabel}

{================================================================}
Procedure TParcelTabForm.PopupMenuClick(Sender: TObject);

{Note that this event is "shared" with the OnTabChange event, though not
 in the real sense. If this form already exists, and the person changes
 to this page, in the OnTabChange event, we will call this event handler
 to create the form and do Table set up. Note that if this is an actual
 menu click to add a new page, then we will add a Tab to the list in the
 proper order.}

var
  MenuID, Avail, Index, NewTabPos,
  TempTabProcessingType,
  ThisTabProcessingType : Integer; {Is this tab History, NextYear, SalesInventory,
                                    or ThisYear?}
  TotalAssessedValStr, LandAssessedValStr,
  FormatString, TabName : String;
  IsSalesInventory,  {Is this tab a sales inventory tab?}
  Continue, PartialAssessment,
  Aborted, Quit : Boolean;  {Did the form create abort?}
  ThisTabProcessingTypeChar : Char;  {Is this tab 'N' = Next Year, 'T' = This Year,
                                                  'H' = History, 'S' = Sales Inv?}

begin
  MenuID := TControl(Sender).Tag;
  Continue := True;
  Quit := False;
  LogTime('c:\Trace.txt', 'Before Display Page.');


      {CHG10271997-2: Warn if they are trying to add res inv to
                    a commercial prop. Note that if they already
                    have a res prop, we don't warn again.}

  If ((MenuID = ResidentialSiteFormNumber) and
      (ParcelTabSet.Tabs.IndexOf(ResidentialSiteTabName) = -1) and
      (_ParcelTable.FieldByName('PropertyClassCode').Text[1] in ['4', '5', '6', '7']))
    then
      If (MessageDlg('You are about to add residential inventory to a commercial property.' + #13 +
                     'Are you sure you want to?', mtConfirmation, [mbYes, mbNo], 0) = idNo)
        then Continue := False;

  If ((MenuID = CommercialSiteFormNumber) and
      (ParcelTabSet.Tabs.IndexOf(CommercialSiteTabName) = -1) and
      (_ParcelTable.FieldByName('PropertyClassCode').Text[1] in ['2']))
    then
      If (MessageDlg('You are about to add commercial inventory to a residential property.' + #13 +
                     'Are you sure you want to?', mtConfirmation, [mbYes, mbNo], 0) = idNo)
        then Continue := False;

    {Be sure to make note of what site we are on if they
     were just in the residential or commercial pages since
     all of the pages below it (i.e. Residential Land) depend
     on which site they are on. Also, set the sales number or assessment
     date if they are on one of those pages.}

  If Continue
    then
      begin
        SynchronizePages;

         {First try to close it - this will make sure that they
          save any changes. HOWEVER.... note that the
          ParcelTabChild.Close method will set GlblParcelPageCloseCancelled
          to true if user elects not to close the current
          ParcelTabChild form, and in this case the next test
          below will skip PopUpMenuClick processing so
          that control returns to the current ParcelTabChild.Form}

        If ((ParcelTabChild <> nil) and
            (not TabChanged))
          then
            begin
              ParcelTabChild.Close;

              try
                ParcelTabChild.Free;
              except
              end;

            end;  {If ((ParcelTabChild <> nil) and ...}

           {if user elects NOT to Close in ParcelTabChild.Close just above, we skip}
           {rest of PopUpMenuClick processing and return to last active form}

        If not GlblParcelPageCloseCancelled {see comment block just above}
                                            {for meaning of this test}
          then
            begin
                 {Now that we know that they want to close the parcel tab child,
                  free it.}

                 {FXX03262001-1: In D5, this is redundant - the close
                                 actually frees it.}

              (*If ((ParcelTabChild <> nil) and
                  (not TabChanged))
                then
                  try
                    ParcelTabChild.Free;  {Free the present page.}
                  finally
                    ParcelTabChild := nil; {This is very important -
                                            Free does not nil pointer.}
                  end;*)

                {The Tag field of the Sender has a unique number corresponding
                 to one of the 18 forms. (Sender will be either a TMenuItem
                 [i.e. a popup menu click] or a Tab change. If it is a TMenuItem,
                 the Tag field was set in the Object Inspector. If it is a TTabSet,
                 then the Tag field was set above in the OnTabChange event.)

                 So, based on the value of the Tag field, we will create the form
                 that it represents. Also, we will set the popup menu and any
                 keys necessary for the main Table of this form. These keys
                 are in the public section of each parcel page and
                 need to be set after creating the page. After setting
                 the keys call InitializeForm of the form which is a procedure
                 in the public section of each ParcelPage which
                 opens the table and synchronizes them to this
                 parcel.

                 Then, some other properties
                 for this form which apply to all forms will be set (i.e. Alignment, Visible).
                 Then, if this was a menu click, we will check to see if we need
                 to add a Tab for this new form, or just go to the existing Tab
                 if they have created the form previously.}

              Aborted := False;
              Screen.Cursor := crHourglass;
              LockWindowUpdate(Handle);

                {First determine the tab name, and look in the tab type list to see
                 what kind this is ('N' = Next Year, 'T' = This Year, 'H' = History,
                 'S' = Sales inventory).}
                {CHG08021999-3: Add exemptions denial page.}

                {FXX11152010-1(2.26.1.20)[I7766]: User gets access violation in certain locate situations.}
                
              If _Compare(MenuID, -1, coEqual)
              then MenuID := BaseParcelPg1FormNumber;

              case MenuId of
                BaseParcelPg1FormNumber : TabName := BaseParcelPg1TabName;
                BaseParcelPg2FormNumber : TabName := BaseParcelPg2TabName;
                AssessmentFormNumber : TabName := AssessmentTabName;
                SummaryFormNumber : TabName := SummaryTabName;
                ClassFormNumber : TabName := ClassTabName;
                SpecialDistrictFormNumber : TabName := SpecialDistrictTabName;
                ExemptionsFormNumber : TabName := ExemptionsTabName;
                ExemptionsDenialFormNumber : TabName := ExemptionsDenialTabName;
                ExemptionsRemovedFormNumber : TabName := ExemptionsRemovedTabName;
                SalesFormNumber : TabName := SalesTabName;
                ResidentialSiteFormNumber : TabName := ResidentialSiteTabName;
                ResidentialBldgFormNumber : TabName := ResidentialBldgTabName;
                ResidentialLandFormNumber : TabName := ResidentialLandTabName;
                ResidentialForestFormNumber : TabName := ResidentialForestTabName;
                ResidentialImprovementsFormNumber : TabName := ResidentialImprovementsTabName;
                CommercialSiteFormNumber : TabName := CommercialSiteTabName;
                CommercialBldgFormNumber : TabName := CommercialBldgTabName;
                CommercialLandFormNumber : TabName := CommercialLandTabName;
                CommercialImprovementsFormNumber : TabName := CommercialImprovementsTabName;
                CommercialRentFormNumber : TabName := CommercialRentTabName;
                CommercialIncomeExpenseFormNumber : TabName := CommercialIncomeExpenseTabName;
                NotesFormNumber : TabName := NotesTabName;
                PictureFormNumber : TabName := PictureTabName;
                DocumentFormNumber : TabName := DocumentTabName;
                AgricultureFormNumber : TabName := AgricultureTabName;
                PropertyCardFormNumber : TabName := PropertyCardTabName;
                SketchFormNumber : TabName := SketchTabName;
                UserDataFormNumber : TabName := UserDataTabName;

                  {CHG05011998-2: Add building permit report}

                PermitsFormNumber : TabName := PermitsTabName;
                ProrataFormNumber : TabName := ProrataTabName;
                MapFormNumber : TabName := MapTabName;
                ThirdPartyNotificationFormNumber : TabName := ThirdPartyNotificationTabName;
                AdditionalOwnersFormNumber : TabName := AdditionalOwnersTabName;
                GrievanceFormNumber : TabName := GrievanceTabName;
                CertiorariFormNumber : TabName := CertiorariTabName;
                SmallClaimsFormNumber : TabName := SmallClaimsTabName;
                PASPermitsFormNumber : TabName := PASPermitsTabName;
                SplitSchoolDistrictFormNumber : TabName := SplitSchoolDistrictTabName;
                TaxBillAddressFormNumber : TabName := TaxBillAddressTabName;

              end;  {case MenuId of}

                 {If the Tab does not exist, then we will add it in the
                  correct place according to the TabOrderArray. Also, we will put an entry
                  in the TabTypeList for this tab in the correct spot saying that it is
                  of type GlblTaxYearFlg. If the tab does exist, then we will look in the
                  TabTypeList at the position of the tab that they just switched to.}

              Index := ParcelTabset.Tabs.IndexOf(TabName);

                {See the variable section for an explanation
                 of ParcelTabChildInitialized.}

              ParcelTabChildInitialized := True;

              If (Index = -1)
                then
                  begin
                    NewTabAdded := True;
                    NewTabPos := DetermineTabPos(ParcelTabset.Tabs, TabName, 0);
                    ParcelTabset.Tabs.Insert(NewTabPos, TabName);
                    _TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);
                    ThisTabProcessingTypeChar := GlblTaxYearFlg;

                    ParcelTabset.TabIndex := NewTabPos;

                      {Let's see if we need to change which options are
                       available on the popup menu.}

                    EnablePopupMenuOptions;
                    NewTabAdded := False;

                  end  {If (TabSet.Tabs.IndexOf(TabName) = -1)}
                else
                  begin
                    If TabChanged
                      then
                        begin
                            {If we have just cleared the tabs and reset them for a new parcel, i.e. they
                             chose Locate a Parcel from the popup menu, then the tab index will be -1,
                             because it has not yet been changed at this point. This is because PopupMenuClick
                             is called from the TabSetChange event and the tab index is not set until the
                             TabSetChange event handler completes. So, if the tab index is -1, then we know
                             that the base page 1 tab is about to be highlighted (since this is the default
                             tab), so we will look at the processing type for base page 1 , i.e. TabTypeList[0].}

                          If (ParcelTabSet.TabIndex = -1)
                            then ThisTabProcessingTypeChar := Take(1, _TabTypeList[0])[1]
                            else
                              begin
                                If (ParcelTabSet.TabIndex <> _NewTab)
                                  then Index := _NewTab
                                  else Index := ParcelTabSet.TabIndex;

                                ThisTabProcessingTypeChar := Take(1, _TabTypeList[Index])[1];

                              end;

                        end
                      else
                        begin
                            {They chose a page off of the popup menu, so let's go to it.
                             Note that the index is the position of this tabname in the
                             tab list and will be of processing type GlblTaxYearFlg.}

                          ThisTabProcessingTypeChar := GlblTaxYearFlg;

                            {Now switch to this Tab that they chose off of the popup menu.}

                          If (ParcelTabset.TabIndex <> Index)
                            then ParcelTabset.TabIndex := Index;

                        end;  {else of If TabChanged}

                  end;  {else of If (Index = -1)}

                {See the variable section for an explanation
                 of ParcelTabChildInitialized.}

              ParcelTabChildInitialized := False;

                {Now figure out the processing type of this tab.}

              ThisTabProcessingType := DetermineProcessingType(ThisTabProcessingTypeChar);

                {CHG12091997-1: Set the land and total assessed value
                                on each parcel page (except class and av).}

                {FXX04121998-1: Make sure that the assessment table is open
                                to the correct year for this tab so that
                                we display the correct AV's.}

                {FXX06181998-2: If sales inv page, use glbl processing type for
                                av.}
                {CHG04102001-1: Put a star if this is a partial assesement.}

              TempTabProcessingType := ThisTabProcessingType;
              If (ThisTabProcessingType = SalesInventory)
                then TempTabProcessingType := GlblProcessingType;
              PartialAssessment := False;

              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         TempTabProcessingType, Quit);

                 {CHG06291999-1: Keep the searcher from seeing next year values.}

              If ((ThisTabProcessingType = History) or
                  (ThisTabProcessingType = ThisYear) or
                  ((ThisTabProcessingType = NextYear) and
                   ((not GlblUserIsSearcher) or
                    (GlblUserIsSearcher and
                     SearcherCanSeeNYValues))))
                then
                  with AssessmentTable do
                    begin
                      FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                                 [GetTaxRollYearForProcessingType(TempTabProcessingType),
                                  ExtractSSKey(_ParcelTable)]);

                        {CHG04262007-1(2.11.1.26): Allow for option to suppress $ on assessments.}

                      FormatString := GetAssessmentDisplayFormat;

                      TotalAssessedValStr := FormatFloat(FormatString, FieldByName('TotalAssessedVal').AsFloat);
                      LandAssessedValStr := FormatFloat(FormatString, FieldByName('LandAssessedVal').AsFloat);
                      PartialAssessment := FieldByName('PartialAssessment').AsBoolean;

                    end  {with AssessmentTable do}
                else
                  begin
                    TotalAssessedValStr := '';
                    LandAssessedValStr := '';
                  end;

               {Now do the actual form creation.}

              case MenuID of
                BaseParcelPg1FormNumber :
                  begin
                    try
                      ParcelTabChild := TBaseParcelPg1Form.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TBaseParcelPg1Form do
                          begin
                            {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            NumResSites := _NumResSites^[ThisTabProcessingType];
                            NumComSites := _NumComSites^[ThisTabProcessingType];
                            ParcelTabSet := Self.ParcelTabSet;
                            TabTypeList := _TabTypeList;
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                        end;  {If not Aborted}

                  end;  {BaseParcelPg1FormNumber}

                BaseParcelPg2FormNumber :
                  begin
                    try
                      ParcelTabChild := TBaseParcelPg2Form.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TBaseParcelPg2Form do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TBaseParcelPg2Form do}

                  end;  {BaseParcelPg2FormNumber}

                SummaryFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelSummaryForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelSummaryForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            ProcessingType := ThisTabProcessingType;

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TSummaryForm do}

                  end;  {SummaryFormNumber}

                AssessmentFormNumber :
                  begin
                    try
                      ParcelTabChild := TAssessmentForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TAssessmentForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TAssessmentForm do}

                  end;  {AssessmentFormNumber}

                ClassFormNumber :
                  begin
                    try
                      ParcelTabChild := TClassForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TClassForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TClassForm do}

                  end;  {ClassFormNumber}

                SpecialDistrictFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelSpecialDistrictForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelSpecialDistrictForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelSpecialDistrictForm do}

                  end;  {SpecialDistrictFormNumber}

                ExemptionsFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelExemptionCodeForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelExemptionCodeForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);

                              {FXX06222001-4: If a denial or removed exemption tab does not exist and we
                                              create it, put up a tab right away.}

                            ParcelTabSet := Self.ParcelTabSet;
                            TabTypeList := _TabTypeList;

                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelExemptionCodeForm do}

                  end;  {ExemptionsFormNumber}

                  {CHG08021999-3: Add exemptions denial page.}

                ExemptionsDenialFormNumber :
                  begin
                    try
                      ParcelTabChild := TDeniedExemptionsForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TDeniedExemptionsForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelExemptionCodeForm do}

                  end;  {ExemptionsDenialFormNumber}

                  {CHG04122001-1(MDT): Record removed exemptions.}

                ExemptionsRemovedFormNumber :
                  begin
                    try
                      ParcelTabChild := TRemovedExemptionsForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TRemovedExemptionsForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TRemovedExemptionsForm do}

                  end;  {ExemptionsRemovedFormNumber}

                SalesFormNumber :
                  begin
                    try
                      ParcelTabChild := TSalesPageForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TSalesPageForm do
                          begin
                             {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);

                            ParcelTabSet := Self.ParcelTabSet;
                            TabTypeList := _TabTypeList;
                            ResidentialSite := _ResidentialSite;
                            CommercialSite := _CommercialSite;
                            CommBuildingNo := _CommBuildingNo;
                            CommBuildingSection := _CommBuildingSection;
                            SalesNumber := _SalesNumber;
                            NumResSites := _NumResSites;
                            NumComSites := _NumComSites;
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables, synchronizes
                               them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TSalesPageForm do}

                  end;  {SalesFormNumber}

                ResidentialSiteFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelResidentialSiteForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelResidentialSiteForm do
                          begin
                            {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            SalesNumber := _SalesNumber;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            ParcelTabSet := Self.ParcelTabSet;
                            TabTypeList := _TabTypeList;

                            NumResSites := _NumResSites^[ThisTabProcessingType];
                            NumComSites := _NumComSites^[ThisTabProcessingType];
                            LandAVLabel.Caption := LandAssessedValStr;
                            TotalAVLabel.Caption := TotalAssessedValStr;

                              {Setting the site will restore them back to the site they were previously on.}

                            Site := _ResidentialSite^[ThisTabProcessingType];

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);
                            {Call the procedure on the form which opens the tables,
                             synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                        end;  {If not Aborted}

                  end;  {ResidentialSiteFormNumber}

               ResidentialBldgFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelResidentialBldgForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelResidentialBldgForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            SalesNumber := _SalesNumber;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            NumResSites := _NumResSites^[ThisTabProcessingType];
                            NumComSites := _NumComSites^[ThisTabProcessingType];
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                              {Setting the site will limit their view to the present site.}

                            Site := _ResidentialSite^[ThisTabProcessingType];

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelResidentialBldgForm do}

                  end;  {ResidentialBldgFormNumber}

                ResidentialLandFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelResidentialLandForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelResidentialLandForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            SalesNumber := _SalesNumber;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            NumResSites := _NumResSites^[ThisTabProcessingType];
                            NumComSites := _NumComSites^[ThisTabProcessingType];
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Setting the site will limit the land view to the present site.}

                            Site := _ResidentialSite^[ThisTabProcessingType];

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelResidentialLandForm do}

                  end;  {ResidentialLandFormNumber}

                ResidentialForestFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelResidentialForestForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelResidentialForestForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            SalesNumber := _SalesNumber;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            NumResSites := _NumResSites^[ThisTabProcessingType];
                            NumComSites := _NumComSites^[ThisTabProcessingType];
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Setting the site will limit their view of forests to the
                               present site.}

                            Site := _ResidentialSite^[ThisTabProcessingType];

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelResidentialForestForm do}

                  end;  {ResidentialForestFormNumber}

                ResidentialImprovementsFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelResidentialImprovementsForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelResidentialImprovementsForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            SalesNumber := _SalesNumber;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            NumResSites := _NumResSites^[ThisTabProcessingType];
                            NumComSites := _NumComSites^[ThisTabProcessingType];
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Setting the site will limit their view of improvements to
                               the present site.}

                            Site := _ResidentialSite^[ThisTabProcessingType];

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelResidentialImprovementsForm do}

                  end;  {ResidentialImprovementsFormNumber}

                CommercialSiteFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelCommercialSiteForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelCommercialSiteForm do
                          begin
                            {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            SalesNumber := _SalesNumber;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            ParcelTabSet := Self.ParcelTabSet;
                            TabTypeList := _TabTypeList;
                            CommBuildingNo := _CommBuildingNo;
                            CommBuildingSection := _CommBuildingSection;

                            NumResSites := _NumResSites^[ThisTabProcessingType];
                            NumComSites := _NumComSites^[ThisTabProcessingType];
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Setting the site will restore them back to the site they were previously on.}

                            Site := _CommercialSite^[ThisTabProcessingType];

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {If not Aborted}

                  end;  {CommercialSiteFormNumber}

                CommercialBldgFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelCommercialBldgForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelCommercialBldgForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            SalesNumber := _SalesNumber;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            NumResSites := _NumResSites^[ThisTabProcessingType];
                            NumComSites := _NumComSites^[ThisTabProcessingType];
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Setting the site will restore them back to the site, building #,
                               and section they were previously on.}

                            Site := _CommercialSite^[ThisTabProcessingType];
                            BuildingNumber := _CommBuildingNo^[ThisTabProcessingType];
                            BuildingSection := _CommBuildingSection^[ThisTabProcessingType];

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelCommercialBldgForm do}

                  end;  {CommercialBldgFormNumber}

                CommercialLandFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelCommercialLandForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelCommercialLandForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            SalesNumber := _SalesNumber;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            NumResSites := _NumResSites^[ThisTabProcessingType];
                            NumComSites := _NumComSites^[ThisTabProcessingType];
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Setting the site will restrict their view of lands to this site.}

                            Site := _CommercialSite^[ThisTabProcessingType];

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {If not Aborted}

                  end;  {CommercialLandFormNumber}

                CommercialImprovementsFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelCommercialImprovementsForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelCommercialImprovementsForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            SalesNumber := _SalesNumber;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            NumResSites := _NumResSites^[ThisTabProcessingType];
                            NumComSites := _NumComSites^[ThisTabProcessingType];
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Setting the site will limit their view of improvements to
                               the current commercial site.}

                            Site := _CommercialSite^[ThisTabProcessingType];

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelCommercialImprovementsForm do}

                  end;  {CommercialImprovementFormNumber}

                CommercialRentFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelCommercialRentForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelCommercialRentForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            SalesNumber := _SalesNumber;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            NumResSites := _NumResSites^[ThisTabProcessingType];
                            NumComSites := _NumComSites^[ThisTabProcessingType];
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Setting the site will limit them to the rents for the
                               current commercial site.}

                            Site := _CommercialSite^[ThisTabProcessingType];

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelCommercialRentForm do}

                  end;  {CommercialRentFormNumber}

                CommercialIncomeExpenseFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelCommercialIncomeExpenseForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelCommercialIncomeExpenseForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            SalesNumber := _SalesNumber;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            NumResSites := _NumResSites^[ThisTabProcessingType];
                            NumComSites := _NumComSites^[ThisTabProcessingType];
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Setting the site will make sure that they see the comm\inc rec. for
                               this site.}

                            Site := _CommercialSite^[ThisTabProcessingType];

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelCommercialIncomeExpenseForm do}

                  end;  {CommercialIncomeExpenseFormNumber}


                UserDataFormNumber :
                  begin
                    try
                      ParcelTabChild := TParcelUserDataForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TParcelUserDataForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TNotesForm do}

                  end;  {User Data Form Number}

                NotesFormNumber :
                  If GlblUseNewStyleForms
                    then
                      begin
                        try
                          ParcelTabChild := TNotes_NewForm.Create(Self);  {MMM}
                        except
                          AbortParcelPageCreate(Aborted);
                        end;

                        If not Aborted
                          then
                            with ParcelTabChild as TNotes_NewForm do
                              begin
                                  {Set the keys for this form.}

                                SwisSBLKey := ExtractSSKey(_ParcelTable);
                                TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                                EditMode := _EditMode;
                                ProcessingType := ThisTabProcessingType;
                                FormAccessRights := DetermineFormAccessRights(MenuID);
                                TotalAVLabel.Caption := TotalAssessedValStr;
                                LandAVLabel.Caption := LandAssessedValStr;

                                SetPartialAssessmentLabel(PartialAssessment,
                                                          PartialAssessmentLabel,
                                                          TotalAVLabel);

                                  {Call the procedure on the form which opens the tables,
                                   synchronizes them to this parcel, sets labels, etc.}

                                InitializeForm;

                              end;  {with ParcelTabChild as TNotesForm do}
                      end
                    else
                      begin
                        try
                          ParcelTabChild := TNotesForm.Create(Self);  {MMM}
                        except
                          AbortParcelPageCreate(Aborted);
                        end;

                        If not Aborted
                          then
                            with ParcelTabChild as TNotesForm do
                              begin
                                  {Set the keys for this form.}

                                SwisSBLKey := ExtractSSKey(_ParcelTable);
                                TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                                EditMode := _EditMode;
                                ProcessingType := ThisTabProcessingType;
                                FormAccessRights := DetermineFormAccessRights(MenuID);
                                TotalAVLabel.Caption := TotalAssessedValStr;
                                LandAVLabel.Caption := LandAssessedValStr;

                                SetPartialAssessmentLabel(PartialAssessment,
                                                          PartialAssessmentLabel,
                                                          TotalAVLabel);

                                  {Call the procedure on the form which opens the tables,
                                   synchronizes them to this parcel, sets labels, etc.}

                                InitializeForm;

                              end;  {with ParcelTabChild as TNotesForm do}

                      end;  {else of GlblUseNewNotesForm}

                PictureFormNumber :
                  begin
                    try
                      ParcelTabChild := TPictureForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TPictureForm do
                          begin
                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            EditMode := _EditMode;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TPictureForm do}

                  end;  {PictureFormNumber}

                DocumentFormNumber :
                  begin
                    try
                      ParcelTabChild := TDocumentForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TDocumentForm do
                          begin
                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            EditMode := _EditMode;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TDocumentForm do}

                  end;  {DocumentFormNumber}

                AgricultureFormNumber :
                  begin
                    try
                      ParcelTabChild := TfmAgriculture.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TfmAgriculture do
                          begin
                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TAgricultureForm do}

                  end;  {AgricultureFormNumber}

                  {CHG07312006-1(2.10.1.1): Add a property card tab.}

                PropertyCardFormNumber :
                  begin
                    try
                      ParcelTabChild := Tfm_PropertyCard.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as Tfm_PropertyCard do
                          begin
                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            EditMode := _EditMode;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as Tfm_PropertyCard do}

                  end;  {PropertyCardFormNumber}

                SketchFormNumber :
                  begin
                    try
                      ParcelTabChild := TSketchForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TSketchForm do
                          begin
                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            EditMode := _EditMode;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TSketchForm do}

                  end;  {SketchFormNumber}

                  {CHG05011998-2: Add building permit report}
                  {CHG04182005-1(2.8.4.1): Option to use new grid based building form.}
                  {CHG05162007(2.28.2.1): Add PAS <-> Municity link.}

                PermitsFormNumber :
                  If _Compare(GlblBuildingSystemLinkType, bldMunicity, coEqual)
                    then
                      begin
                        try
                          ParcelTabChild := TPermits_MunicityForm.Create(Self);
                        except
                          AbortParcelPageCreate(Aborted);
                        end;

                        If not Aborted
                          then
                            with ParcelTabChild as TPermits_MunicityForm do
                              begin
                                  {Set the keys for this form.}

                                SwisSBLKey := ExtractSSKey(_ParcelTable);
                                TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                                EditMode := _EditMode;
                                FormAccessRights := DetermineFormAccessRights(MenuID);
                                ProcessingType := GlblProcessingType;
                                TotalAVLabel.Caption := TotalAssessedValStr;
                                LandAVLabel.Caption := LandAssessedValStr;

                                SetPartialAssessmentLabel(PartialAssessment,
                                                          PartialAssessmentLabel,
                                                          TotalAVLabel);

                                  {Call the procedure on the form which opens the tables,
                                   synchronizes them to this parcel, sets labels, etc.}

                                InitializeForm;

                              end;  {with ParcelTabChild as TPermits_MunicityForm do}

                      end
                    else
                      If GlblUseNewBuildingPermitPage
                        then
                          begin
                            try
                              ParcelTabChild := TBuildingPermitNewForm.Create(Self);  {MMM}
                            except
                              AbortParcelPageCreate(Aborted);
                            end;

                            If not Aborted
                              then
                                with ParcelTabChild as TBuildingPermitNewForm do
                                  begin
                                      {Set the keys for this form.}

                                    SwisSBLKey := ExtractSSKey(_ParcelTable);
                                    TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                                    EditMode := _EditMode;
                                    FormAccessRights := DetermineFormAccessRights(MenuID);
                                    TotalAVLabel.Caption := TotalAssessedValStr;
                                    LandAVLabel.Caption := LandAssessedValStr;

                                    SetPartialAssessmentLabel(PartialAssessment,
                                                              PartialAssessmentLabel,
                                                              TotalAVLabel);

                                      {Call the procedure on the form which opens the tables,
                                       synchronizes them to this parcel, sets labels, etc.}

                                    InitializeForm;

                                  end;  {with ParcelTabChild as TBuildingPermitNewForm do}

                          end
                        else
                          begin
                            try
                              ParcelTabChild := TBldgPermitForm.Create(Self);  {MMM}
                            except
                              AbortParcelPageCreate(Aborted);
                            end;

                            If not Aborted
                              then
                                with ParcelTabChild as TBldgPermitForm do
                                  begin
                                      {Set the keys for this form.}

                                    SwisSBLKey := ExtractSSKey(_ParcelTable);
                                    TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                                    EditMode := _EditMode;
                                    FormAccessRights := DetermineFormAccessRights(MenuID);
                                    TotalAVLabel.Caption := TotalAssessedValStr;
                                    LandAVLabel.Caption := LandAssessedValStr;

                                    SetPartialAssessmentLabel(PartialAssessment,
                                                              PartialAssessmentLabel,
                                                              TotalAVLabel);

                                      {Call the procedure on the form which opens the tables,
                                       synchronizes them to this parcel, sets labels, etc.}

                                    InitializeForm;

                                  end;  {with ParcelTabChild as TParcelSpecialDistrictForm do}

                          end;  {else of If GlblUseNewBuildingPermitPage}

                ProrataFormNumber :
                  begin
                    try
                      ParcelTabChild := TProrataForm.Create(Self);
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TProrataForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TProrataForm do}

                  end;  {ProrataForm}

                MapFormNumber :
                  begin
                    try
                      ParcelTabChild := TMapForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TMapForm do
                          begin
                              {Set the keys for this form.}

                            AssessmentYear := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelSpecialDistrictForm do}

                  end;  {MapForm}

                ThirdPartyNotificationFormNumber :
                  begin
                    try
                      ParcelTabChild := TThirdPartyNotificationForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TThirdPartyNotificationForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TNotesForm do}

                  end;  {ThirdPartyNotificationFormNumber}

                AdditionalOwnersFormNumber :
                  begin
                    try
                      ParcelTabChild := TAdditionalOwnersForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TAdditionalOwnersForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TNotesForm do}

                  end;  {AdditionalOwnersFormNumber}

                GrievanceFormNumber :
                  begin
                    try
                      ParcelTabChild := TGrievanceForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TGrievanceForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;
                            ParcelTabSet := Self.ParcelTabSet;
                            TabTypeList := _TabTypeList;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TNotesForm do}

                  end;  {GrievanceFormNumber}

                CertiorariFormNumber :
                  begin
                    try
                      ParcelTabChild := TCertiorariForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TCertiorariForm do
                          begin
                              {Set the keys for this form.}
                              {FXX03182003-2: If the base parcel does not exist, need to use the original SBL.}

                            If LocatedParcelExists
                              then SwisSBLKey := ExtractSSKey(_ParcelTable)
                              else SwisSBLKey := OriginalLocatedSBLKey;

                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TNotesForm do}

                  end;  {CertiorariFormNumber}

                SmallClaimsFormNumber :
                  begin
                    try
                      ParcelTabChild := TSmallClaimsForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TSmallClaimsForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TSmallClaimsForm do}

                  end;  {SmallClaimsFormNumber}

                PASPermitsFormNumber :
                  begin
                    try
                      ParcelTabChild := TPermitsForm.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TPermitsForm do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                            InitializeForm;

                          end;  {with ParcelTabChild as TParcelCommercialBldgForm do}

                  end;  {CommercialBldgFormNumber}

                 {CHG10082009-1(2.20.1.1)[F1005]: Allow for split school districts.}

                SplitSchoolDistrictFormNumber :
                  begin
                    try
                      ParcelTabChild := TfmSplitSchoolDistrictSBLs.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TfmSplitSchoolDistrictSBLs do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRlYr;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TfmSplitSchoolDistrictSBLs do}

                  end;  {SplitSchoolDistrictFormNumber}

                TaxBillAddressFormNumber :
                  begin
                    try
                      ParcelTabChild := TfmTaxBillAddress.Create(Self);  {MMM}
                    except
                      AbortParcelPageCreate(Aborted);
                    end;

                    If not Aborted
                      then
                        with ParcelTabChild as TfmTaxBillAddress do
                          begin
                              {Set the keys for this form.}

                            SwisSBLKey := ExtractSSKey(_ParcelTable);
                            TaxRollYr := GetTaxRollYearForProcessingType(ThisTabProcessingType);
                            EditMode := _EditMode;
                            ProcessingType := ThisTabProcessingType;
                            FormAccessRights := DetermineFormAccessRights(MenuID);
                            TotalAVLabel.Caption := TotalAssessedValStr;
                            LandAVLabel.Caption := LandAssessedValStr;

                            SetPartialAssessmentLabel(PartialAssessment,
                                                      PartialAssessmentLabel,
                                                      TotalAVLabel);

                              {Call the procedure on the form which opens the tables,
                               synchronizes them to this parcel, sets labels, etc.}

                            InitializeForm;

                          end;  {with ParcelTabChild as TBaseParcelPg2Form do}

                  end;  {TaxBillAddressFormNumber}

              end;  {case Sender.Tag of}

                {Now set the properties of the ParcelTabChild - it should have no parent, align
                 itself to the borders of the notebook, and be visible.
                 Also, we will set the tag of the from to its form number so that if
                 we need to figure out indirectly (rather than say, looking at the
                 caption) which form is showing, we can. Finally, we have
                 to bring the form to front so that it can be seen.}

              If not Aborted
                then
                  begin
                    with ParcelTabChild do
                      begin
                        Parent := Self;
                        PopupMenu := BasePopupMenu;
                        Align := alClient;
                        Visible := True;
                        Tag := TControl(Sender).Tag;
                        BringToFront;

                          {FXX12101999-5: Alow them to blank out dates.}

                        GlblParcelTabChild := ParcelTabChild;

                      end;  {with ParcelTabChild do}

              end;  {If not Aborted}

              LockWindowUpdate(0);
              Screen.Cursor := crDefault;

            end;  {If not GlblParcelPageCloseCancelled}

      end;  {If Continue}

  TabChanged := False;
  LogTime('c:\Trace.txt', 'After Display Page.');

end;  {PopupMenuClick}

{================================================================}
Procedure TParcelTabForm.BasePopupMenuPopup(Sender: TObject);

{Every time that they open up the popup menu, we will reset the enabled menu
 items in case things have changed since the last time that they went to this
 menu. For example, if they just added the first ResidentialSite record, then
 now they can go to any page beneath the ResidentialSite, whereas before they
 could not.}

begin
  EnablePopupMenuOptions;
end;  {BasePopupMenuPopup}

{=================================================================================}
Procedure TParcelTabForm.SearchDialogueTimerTimer(Sender: TObject);

{The timer has clicked, so let's turn it off and show the locate
 dialog. To do this, we will simulate a click on Locate a Parcel
 in the popup menu.

 Also, if this is view mode, we will change the PopupMenu so that
 it does not say Add\Go to Page.}

var
  I, J : Integer;

begin
    {Must turn timer off, was invoked in FormCreate.}

  SearchDialogueTimer.Enabled := False;

    {If this is view mode, then change the popup menu so that
     rather than saying 'Add\Go To Page:', it says 'Go To Page:'.}

  If (_EditMode = 'V')
    then
      For I := 0 to (PopupMenu.Items.Count - 1) do
        If (Pos('Add\Go', PopupMenu.Items[I].Caption) <> 0)
          then PopupMenu.Items[I].Caption := 'Go To Page:';

    {If this is add mode, then change the popup menu so that
     rather than saying 'Locate Parcel', it says 'Add Another Parcel'.}

  If (_EditMode = 'A')
    then
      For I := 0 to (PopupMenu.Items.Count - 1) do
        If (Pos('Locate Parcel', PopupMenu.Items[I].Caption) <> 0)
          then PopupMenu.Items[I].Caption := '&Add Another Parcel';

    {If they are in next year processing, then we want to have the
     second line read "Show This Year" instead of "Show Next Year".}

  If (GlblTaxYearFlg = 'N')
    then
      For I := 0 to (PopupMenu.Items.Count - 1) do
        If (Pos('Show Next', PopupMenu.Items[I].Caption) <> 0)
          then PopupMenu.Items[I].Caption := 'Show This &Year';

    {If they are in next year processing, then we want to have the
     third line, submenu entry 1 read (Hide) "This Year" instead of (Hide)
     "Next Year".}

  If (GlblTaxYearFlg = 'N')
    then
      For I := 0 to (PopupMenu.Items.Count - 1) do
        If (Pos('Hide', PopupMenu.Items[I].Caption) <> 0)
          then
            For J := 0 to (PopupMenu.Items[I].Count - 1) do
              If (Pos('Next', PopupMenu.Items[I].Items[J].Caption) <> 0)
                then PopupMenu.Items[I].Items[J].Caption := 'This &Year';

    {Now simulate a click on the locate parcel menu item.
     Note that in the add case, we will show the add panel rather than the locate
     dialog.}

  LocateParcel1Click(Sender);

end;  {SearchDialogueTimerTimer}

{==========================================================================}
Function GetTagForParcelTabName(ParcelTabName : String) : Integer;

{Given the tab name, return the tag for this form.}

begin
  Result := -1;

     {Set them to the same tab.}

  If (ParcelTabName = BaseParcelPg1TabName)
    then Result := BaseParcelPg1FormNumber;

  If (ParcelTabName = BaseParcelPg2TabName)
    then Result := BaseParcelPg2FormNumber;

  If (ParcelTabName = AssessmentTabName)
    then Result := AssessmentFormNumber;

  If (ParcelTabName = SummaryTabName)
    then Result := SummaryFormNumber;

  If (ParcelTabName = ClassTabName)
    then Result := ClassFormNumber;

  If (ParcelTabName = SpecialDistrictTabName)
    then Result := SpecialDistrictFormNumber;

  If (ParcelTabName = ExemptionsTabName)
    then Result := ExemptionsFormNumber;

  If (ParcelTabName = ExemptionsDenialTabName)
    then Result := ExemptionsDenialFormNumber;

  If (ParcelTabName = ExemptionsRemovedTabName)
    then Result := ExemptionsRemovedFormNumber;

  If (ParcelTabName = SalesTabName)
    then Result := SalesFormNumber;

  If (ParcelTabName = ResidentialSiteTabName)
    then Result := ResidentialSiteFormNumber;

  If (ParcelTabName = ResidentialBldgTabName)
    then Result := ResidentialBldgFormNumber;

  If (ParcelTabName = ResidentialLandTabName)
    then Result := ResidentialLandFormNumber;

  If (ParcelTabName = ResidentialForestTabName)
    then Result := ResidentialForestFormNumber;

  If (ParcelTabName = ResidentialImprovementsTabName)
    then Result := ResidentialImprovementsFormNumber;

  If (ParcelTabName = CommercialSiteTabName)
    then Result := CommercialSiteFormNumber;

  If (ParcelTabName = CommercialBldgTabName)
    then Result := CommercialBldgFormNumber;

  If (ParcelTabName = CommercialLandTabName)
    then Result := CommercialLandFormNumber;

  If (ParcelTabName = CommercialImprovementsTabName)
    then Result := CommercialImprovementsFormNumber;

  If (ParcelTabName = CommercialRentTabName)
    then Result := CommercialRentFormNumber;

  If (ParcelTabName = CommercialIncomeExpenseTabName)
    then Result := CommercialIncomeExpenseFormNumber;

   If (ParcelTabName = UserDataTabName)
    then Result := UserDataFormNumber;

  If (ParcelTabName = NotesTabName)
    then Result := NotesFormNumber;

  If (ParcelTabName = PictureTabName)
    then Result := PictureFormNumber;

  If (ParcelTabName = DocumentTabName)
    then Result := DocumentFormNumber;

  If (ParcelTabName = AgricultureTabName)
    then Result := AgricultureFormNumber;

  If (ParcelTabName = TaxBillAddressTabName)
    then Result := TaxBillAddressFormNumber;

  If (ParcelTabName = PropertyCardTabName)
    then Result := PropertyCardFormNumber;

  If (ParcelTabName = SketchTabName)
    then Result := SketchFormNumber;

    {CHG05011998-2: Add building permit report}

  If (ParcelTabName = PermitsTabName)
    then Result := PermitsFormNumber;

  If (ParcelTabName = ProrataTabName)
    then Result := ProrataFormNumber;

  If (ParcelTabName = MapTabName)
    then Result := MapFormNumber;

  If (ParcelTabName = ThirdPartyNotificationTabName)
    then Result := ThirdPartyNotificationFormNumber;

  If (ParcelTabName = GrievanceTabName)
    then Result := GrievanceFormNumber;

  If (ParcelTabName = SmallClaimsTabName)
    then Result := SmallClaimsFormNumber;

  If (ParcelTabName = CertiorariTabName)
    then Result := CertiorariFormNumber;

  If (ParcelTabName = PASPermitsTabName)
    then Result := PASPermitsFormNumber;

  If (ParcelTabName = SplitSchoolDistrictTabName)
    then Result := SplitSchoolDistrictFormNumber;

end;  {GetTagForParcelTabName}

{==========================================================================}
Procedure TParcelTabForm.LocateParcel1Click(Sender: TObject);

{If this is edit or modify mode, than we will bring up the locate dialog.
 Otherwise, we will show the add parcel panel and have them enter the new parcel ID.}

var
  SBLKey, PresentSBLKey, NewSBLKey, RollYear,
  TitleString, LastParcelTabName, TempIndexName : String;
  SBLRec : SBLRecord;
  FoundTab, DisplayThisParcel,
  ExitOfLastParcelCancelled,
  Locked, ActiveParcel, FoundRec,
  ModifyCertiorariOnInactiveParcel : Boolean;
  TempTag, I : Integer;
  TempStringList, TempStringList2,
  WarningCodeList, WarningDescList : TStringList;

begin
  case _EditMode of
    'A' : TitleString := 'Add';
    'M' : TitleString := 'Modify';
    'V' : TitleString := 'View';
  end;  {case _EditMode of}

  RollYear := GetTaxRlYr;
  PresentSBLKey := ExtractYSSKey(_ParcelTable);

  GlblDialogBoxShowing := True;  {This prevents the on active screen change
                                          from thinking that the search dialog that just
                                          appeared is a new form which need a tab
                                          (at the main form level).}

    {FXX06141999-2: Allow users to see warnings on a parcel right away.}

  ExitOfLastParcelCancelled := False;

  If ((_EditMode = 'M') and
      (not FirstTimeLocateDialogIsShown) and
      GlblShowParcelWarnings)
    then
      begin
        WarningCodeList := TStringList.Create;
        WarningDescList := TStringList.Create;

          {CHG09071999-3: Allow selection of what warning messages are displayed.}

        GetParcelWarnings(GetTaxRlYr, Copy(PresentSBLKey, 5, 26),
                          WarningCodeList, WarningDescList, GlblWarningOptions);

          {FXX11301999-2: Allow the parcel warning tables to stay open so
                          that warning report does not take so long.}

        CloseParcelWarningTables;

        If (WarningCodeList.Count > 0)
          then
            begin
              WarningMessageDialog.DisplayWarnings(GetTaxRlYr,
                                                   Copy(PresentSBLKey, 5, 26),
                                                   WarningCodeList,
                                                   WarningDescList);

              WarningMessageDialog.ShowModal;
              ExitOfLastParcelCancelled := WarningMessageDialog.Cancelled;

            end;  {If (WarningCodeList.Count > 0)}

        WarningCodeList.Free;
        WarningDescList.Free;

      end;  {If ((_EditMode = 'M') and ...}

    {Now start the search dialog, and if they accept the parcel change, and it
     it is a different parcel than the present one, we will sync. up the base
     parcel form and set the tabs up for this parcel.}

  If (_EditMode = 'A')
    then
      begin
        AddParcelPanel.Visible := True;
        AddParcelEdit.Text := '';
        AddParcelEdit.SetFocus;
      end
    else
        {FXX12011998-20: Display the present action in the locate dialog.}
        {CHG05131999-2: Let people look up parcels from the parcel list.}

      If ((not ExitOfLastParcelCancelled) and
          (SwitchingYears or
           GlblLocateParcelFromList or
           ExecuteParcelLocateDialog(SBLKey, True, True, TitleString, False, nil)))
        then
          begin
            If GlblLocateParcelFromList
              then SBLKey := GlblParcelListSBLKey;

            {CHG03282002-1: Allow easy switch between this year and next year for the
                            same parcel.}

            If SwitchingYears
              then SBLKey := CurrentSwisSBLKey;

            NewSBLKey := RollYear + SBLKey;
            CurrentSwisSBLKey := SBLKey;

            GlblLocateParcelFromList := False;

            If ((PresentSBLKey <> NewSBLKey) or
                FirstTimeLocateDialogIsShown)
              then
                begin
                    {CHG10091997-2: Add parcel locking.}
(*                  WinBtr := GetBtrieveObject(_ParcelTable);*)

                        (*UnlockParcel(_ParcelTable, WinBtr,
                                     RollYear, Copy(PresentSBLKey, 5, 26));*)

                    {Synchronize the main parcel table on this
                     form with the parcel search table.}

                  SBLRec := ExtractSwisSBLFromSwisSBLKey(SBLKey);

                      {FXX10231997-4: Need to make sure we are on the parcel id index.}

                  TempIndexName := _ParcelTable.IndexName;
                  _ParcelTable.IndexName := ParcelTable_Year_Swis_SBLKey;

                    {FXX01201999-4: There should never be a case where FoundRec would
                                    be False and this was causing a problem
                                    if the key was different.}

                 _Locate(_ParcelTable, [RollYear, SBLKey], '', [loParseSwisSBLKey, loPartialKey]);

                 FoundRec := _Compare(SBLKey, ExtractSSKey(_ParcelTable), coEqual);

                  LocatedParcelExists := FoundRec;
                  //FoundRec := True;

                    {FXX03182003-3(2.06q1): If this a grievance, etc. and the parcel does not exist, then
                                            we need to make sure to pass in the SBL as it appears on the grievance, etc. record.}

                  OriginalLocatedSBLKey := '';
                  If not LocatedParcelExists
                    then OriginalLocatedSBLKey := SBLKey;
                  GlblCurrentSwisSBLKey := SBLKey;

(*                  If not FoundRec
                    then SystemSupport(101, _ParcelTable, 'Error getting parcel record.',
                                       UnitName, GlblErrorDlgBox);*)

                     {CHG12172002-1: Sometimes the parcel might not exist in the
                                     grievance system.}

                  _ParcelTable.IndexName := TempIndexName;

                    {CHG10091997-2: Add parcel locking.}
                  (*Locked := WinBtr.IsRecordLocked;*)

                    {FXX11051998-2: Locking is not working anyway, so
                                    comment out for now to prevent
                                    problem with returning to same parcel.}

                  Locked := False;

                  If (Locked and
                      (_EditMode = 'M'))
                    then MessageDlg('Sorry, that parcel is being modified by another person.' + #13 +
                                    'Please try again later.', mtWarning, [mbOK], 0);

                    {Now if the parcel is inactive, then we will not let them modify it.}

                  ActiveParcel := True;
                  ModifyCertiorariOnInactiveParcel := False;

                  If (FoundRec and
                      (not Locked) and
                      (_EditMode = 'M') and
                      (_ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag))
                    then
                      begin
                        MessageDlg('That parcel is inactive and can not be modified.' + #13 +
                                   'Please select a different parcel.', mtError, [mbOK], 0);
                        ActiveParcel := False;

                          {CHG01292006-1(2.9.5.2): If the parcel is inactive, but it has a cert,
                                                   give them the option to modify.}

                        If ((not GlblUserIsSearcher) and
                            GlblUsesGrievances and
                            GlblCanSeeCertiorari)
                          then
                            with CertiorariTable do
                              try
                                TableName := CertiorariTableName;
                                Open;

                                If (_Locate(CertiorariTable, [SBLKey], '', []) and
                                    (MessageDlg('Do you want to modify the certiorari information?',
                                                mtInformation, [mbYes, mbNo], 0) = idYes))
                                  then ModifyCertiorariOnInactiveParcel := True;

                                Close;
                              except
                              end;

                      end;  {If (FoundRec and ...}

                  DisplayThisParcel := False;

                    {Now if we found the parcel and it is active (only applies for modify),
                     then let's display it.}

                  If (FoundRec and
                      (ActiveParcel or
                       ModifyCertiorariOnInactiveParcel) and
                      (not ((_EditMode = 'M') and  {We won't do this part if we are in edit mode}
                            Locked)))              {and it is locked.}
                    then
                      begin
                        DisplayThisParcel := True;
                        Locked := False;

                          {Set the caption for the parcel to reflect this parcel.
                           To do this, we will extract the parcel maint.
                           type (A/M/D/V) and instance number (everything
                           to the left of the colon). Then we will add the
                           SBL to this.}

                            {CHG10091997-2: Add parcel locking.}
                          {Unlock the last parcel and if this is modify mode,
                           lock the new parcel.}

(*                        UnlockParcel(_ParcelTable, WinBtr,
                                     RollYear, Copy(PresentSBLKey, 5, 26));*)

                          {FXX10121997-3: If not modify mode, need to reaccess
                                          since parcel table points to unlocked
                                          parcel.}

                          {FXX10131997-2: Don't forget to check for race condition.}
                          {FXX01211999-2: Remove all locking for now.}

                        (*WinBtr := GetBtrieveObject(_ParcelTable);*)

                        If (_EditMode = 'M')
                          then (*LockParcel(_ParcelTable, WinBtr,
                                          RollYear, SBLKey, Locked)*)
                          else
                            begin
                              TempIndexName := _ParcelTable.IndexName;
                              _ParcelTable.IndexName := ParcelTable_Year_Swis_SBLKey;

                              with SBLRec do
                                FindKeyOld(_ParcelTable,
                                           ['TaxRollYr', 'SwisCode', 'Section',
                                            'Subsection', 'Block', 'Lot',
                                            'Sublot', 'Suffix'],
                                           [RollYear, SwisCode,
                                            Section, Subsection,
                                            Block, Lot,
                                            Sublot, Suffix]);

                              _ParcelTable.IndexName := TempIndexName;

                            end;

                        If Locked
                          then
                            begin
                              DisplayThisParcel := False;
                              MessageDlg('Sorry, that parcel is being modified by another person.' + #13 +
                                         'Please try again later.', mtWarning, [mbOK], 0);
                            end
                          else
                            begin
                              SetCaption(SBLKey, _ParcelTable.FieldByName('AccountNo').Text);

                              NewTabAdded := False;

                              If ((_EditMode = 'M') and
                                  GlblAutoDetectNewPictures)
                                then
                                  begin
                                    TempStringList := TStringList.Create;
                                    TempStringList2 := TStringList.Create;
                                    DetectNewPicturesOrDocuments(SBLKey,
                                                       GlblPictureDir,
                                                       dtPicture,
                                                       False,
                                                       TempStringList,
                                                       TempStringList2,
                                                       False, True, False,
                                                       _ParcelTable.FieldByName('AccountNo').AsString,
                                                       _ParcelTable.FieldByName('PrintKey').AsString);

                                    TempStringList.Free;
                                    TempStringList2.Free;

                                  end;  {If ((_EditMode = 'M') and ...}

                              If ((_EditMode = 'M') and
                                  GlblAutoDetectNewDocuments)
                                then
                                  begin
                                    TempStringList := TStringList.Create;
                                    TempStringList2 := TStringList.Create;
                                    DetectNewPicturesOrDocuments(SBLKey,
                                                       GlblDocumentDir,
                                                       dtScannedImage,
                                                       False,
                                                       TempStringList,
                                                       TempStringList2,
                                                       False, True, False,
                                                       _ParcelTable.FieldByName('AccountNo').AsString,
                                                       _ParcelTable.FieldByName('PrintKey').AsString);

                                    TempStringList.Free;
                                    TempStringList2.Free;

                                  end;  {If ((_EditMode = 'M') and ...}

                                {Set up the main tabs for parcel, i.e. the ones that apply to the GlblTaxYrFlg.}

                              LogTime('c:\Trace.txt', 'Before Set Main Tabs.');

                              SetMainTabsForParcel(ParcelTabSet, _TabTypeList, LookupTable, SBLKey,
                                                   GetTaxRlYr, _SalesNumber,
                                                   _ResidentialSite, _CommercialSite, _CommBuildingNo,
                                                   _CommBuildingSection, _NumResSites, _NumComSites,
                                                   LocatedParcelExists);

                              LogTime('c:\Trace.txt', 'After Set Main Tabs.');

                               {FXX11241997-1: In modify mode, when
                                                locating another parcel,
                                                return to same tab.}

                              with Sender as TComponent do
                                If (Tag = 0)
                                  then LastParcelTabName := ''
                                  else
                                    try
                                      LastParcelTabName := ParcelTabSet.Tabs[ParcelTabSet.TabIndex];
                                    except
                                      LastParcelTabName := '';
                                    end;

                                {CHG03262002-1: Retain TY\NY tab setting as scroll between parcels.}

                              If OppositeYearTabsShowing
                                then ShowOppositeYearTabsClick(Sender);

                              EnablePopupMenuOptions;

                                {Now we will simulate a click on the base form so that we go to
                                 this form.}
                                {CHG09301997 - Start on the first page that the
                                               user wants - summary, base page 1
                                               or 2 or assessment.}

                                {CHG10191997-3: From MP - In modify mode,
                                                don't start on summary page.}
                                {CHG01082003-1: Allow for a different default on the parcel view, too.}

                              with Sender as TComponent do
                                If (_EditMode = 'M')
                                  then
                                    begin
                                        {FXX11171997-4: On the first locate,
                                                        the tag is 0, so show
                                                        user def screeen.}

                                        {FXX11241997-1: In modify mode, when
                                                locating another parcel,
                                                return to same tab.}

                                      If (Tag = 0)
                                        then Tag := GlblFirstParcelPageShown
                                        else
                                          begin
                                            Tag := GetTagForParcelTabName(LastParcelTabName);

                                              {FXX04131998-1: If this tag does
                                                              not exist on new parcel,
                                                              don't go to it.}

                                            FoundTab := False;

                                            For I := 0 to (ParcelTabSet.Tabs.Count - 1) do
                                              begin
                                                TempTag := GetTagForParcelTabName(ParcelTabSet.Tabs[I]);

                                                If (TempTag = Tag)
                                                  then FoundTab := True;

                                              end;  {For I := 0 to ...}

                                            If not FoundTab
                                              then Tag := GlblFirstParcelPageShown;

                                          end;  {else of If (Tag = 0)}

                                        {FXX06302003-1(2.07e): If they selected the summary page as the default
                                                               for modify, don't override it.}

(*                                      If (Tag = SummaryFormNumber)
                                        then Tag := BaseParcelPg1FormNumber; *)

                                    end
                                  else Tag := GlblDefaultParcelViewPage;

                                {CHG08182002-2: Default Cert Only users to the cert page.}
                                {CHG11042002-1: Default to grievance specific page
                                                if that is how they looked it up.}

                              If (GlblLastLocateInfoRec.LastLocatePage = 'S')
                                then
                                  with Sender as TComponent do
                                    Tag := SmallClaimsFormNumber;

                              If (GlblLastLocateInfoRec.LastLocatePage = 'G')
                                then
                                  with Sender as TComponent do
                                    Tag := GrievanceFormNumber;

                                {FXX01132004-1(2.07l): Make it so that cert only users
                                                       show up on the cert page even
                                                       if they looked up on the grievance page.}

                              If (GlblCertiorariOnly or
                                  (GlblLastLocateInfoRec.LastLocatePage = 'C'))
                                then
                                  with Sender as TComponent do
                                    Tag := CertiorariFormNumber;

                              PopupMenuClick(Sender);

                            end;  {else of If Locked}

                      end;  {If FoundRec}

                    {If they chose an inactive parcel to modify, then we will not let them - we
                     will set them back to the original parcel and redisplay the locate box.
                     Otherwise, we will set the FirstTimeLocateDialogIsShown var to False.
                     This var tells us if this is the first time the locate is shown for an
                     add\view\modify session, and they cancel, we will close the session. Otherwise,
                     if they bring up the locate dialog and they cancel, we will do nothing.}

                  If DisplayThisParcel
                    then FirstTimeLocateDialogIsShown := False
                    else
                      begin
                          {First let's resynch the parcel table to the present SBL so that
                           if they end up cancelling, we will set them back to where
                           they used to be.}

                        TempIndexName := _ParcelTable.IndexName;
                        _ParcelTable.IndexName := ParcelTable_Year_Swis_SBLKey;

                        SBLRec := ExtractSwisSBLFromSwisSBLKey(Copy(PresentSBLKey, 5, 26));

                        with SBLRec do
                          FindKeyOld(_ParcelTable,
                                     ['TaxRollYr', 'SwisCode', 'Section',
                                      'Subsection', 'Block', 'Lot',
                                      'Sublot', 'Suffix'],
                                     [RollYear, SwisCode, Section, Subsection,
                                      Block, Lot, Sublot, Suffix]);

                        _ParcelTable.IndexName := TempIndexName;

                          {Now show the parcel dialog again.}

                          {FXX12161997-1: Rather than calling LocateParcelClick
                                          directly and causing a loop, start
                                          the timer to bring up the locate
                                          dialog.}

                        SearchDialogueTimer.Enabled := True;

                      end;  {If ActiveParcel}

                end;  {If (PresentSBLKey = NewSBLKey)}

          end  {If wwParcelSearchDialog.Execute}
        else
          begin
              {CHG11181997-1: For the searcher, need a way to exit parcel view.}
              {CHG11231997-1: Return to the locate dialog for edit and modify too.}

              {FXX11231997-1: The first time the locate is shown,
                              cancel is the same as exit.}

            If FirstTimeLocateDialogIsShown
              then GlblUserPressedParcelExit := True;

            If GlblUserPressedParcelExit
              then Close;

          end;  {else of If ExecuteParcelLocateDialog(SBLKey)}

  GlblDialogBoxShowing := False;

end;  {LocateParcel1Click}

{===================================================================}
Procedure TParcelTabForm.CancelButtonClick(Sender: TObject);

{This is the cancel button from the add panel. If this is the first time
 that it is being shown, then we will Close the parcel add. Otherwise,
 we will just hide the add panel.}

begin
  If FirstTimeLocateDialogIsShown
    then Close
    else AddParcelPanel.Visible := False;

end;  {CancelButtonClick}

{==============================================================}
Procedure TParcelTabForm.OKButtonClick(Sender: TObject);

{They clicked OK on the Add parcel panel with a new parcel ID. First make sure
 that it is a valid ID and it does not already exist. If it passes these two tests,
 insert a parcel record with this SBL and tax year and bring up the parcel just like
 a modify.}

var
  SwisSBLRec : SBLRecord;
  Continue, Quit, Found, ValidEntry, FoundRec : Boolean;
  SwisSBLKey, CaptionName, SplitMergeNumber : String;
  SchoolCodeTable,
  OppositeYearAssessmentTable : TTable;

  ExemptionCodes,  {Note that the exemption lists will be empty since we are not adjusting exemption roll totals.}
  ExemptionHomesteadCodes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  SDAmounts : TList;
  OrigAuditParcelRec, NewAuditParcelRec : AuditParcelRecord;
  EXAmounts : ExemptionTotalsArrayType;
  I : Integer;

begin
  Continue := False;
  SwisSBLKey := ConvertSwisDashDotToSwisSBL(AddParcelEdit.Text, SwisCodeTable, ValidEntry);
  SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  If (((GlblProcessingType = ThisYear) and
       (GlblThisYearAccess = raReadWrite)) or
      ((GlblProcessingType = NextYear) and
       (GlblNextYearAccess = raReadWrite)))
    then Continue := True
    else MessageDlg('Sorry, you can not add a parcel because you do not' + #13 +
                    'have rights to modify the current assessment year.', mtError, [mbOK], 0);

  If (Continue and
      ValidEntry)
    then
      begin
        with SwisSBLRec do
          FoundRec := FindKeyOld(_ParcelTable,
                                 ['TaxRollYr', 'SwisCode', 'Section',
                                  'Subsection', 'Block', 'Lot',
                                  'Sublot', 'Suffix'],
                                 [GetTaxRlYr, SwisCode, Section, Subsection,
                                  Block, Lot, SubLot, Suffix]);

        If FoundRec
          then
            begin
              MessageDlg('That parcel already exists.' + #13 + 'Please re-enter.', mtError,
                         [mbOK], 0);
              AddParcelEdit.SetFocus;
            end
          else
            begin
              ExemptionCodes := TStringList.Create;
              ExemptionHomesteadCodes := TStringList.Create;
              CountyExemptionAmounts := TStringList.Create;
              TownExemptionAmounts := TStringList.Create;
              SchoolExemptionAmounts := TStringList.Create;
              VillageExemptionAmounts := TStringList.Create;
              SDAmounts := TList.Create;
              SplitMergeNumber := '';

                {CHG11052001-3: Ask for a split merge number when add a parcel.}

              If (MessageDlg('Do you want to record a split\merge number for this parcel add?',
                             mtConfirmation, [mbYes, mbNo], 0) = idYes)
                then
                  try
                    RecordSplitMergeNumberDialogForm := TRecordSplitMergeNumberDialogForm.Create(nil);
                    If (RecordSplitMergeNumberDialogForm.ShowModal = idOK)
                      then SplitMergeNumber := RecordSplitMergeNumberDialogForm.SplitMergeNumber;

                  finally
                    RecordSplitMergeNumberDialogForm.Free;
                  end;

                {Insert a parcel with this SBL.}

              with _ParcelTable do
                try
                  Insert;
                  InitializeFieldsForRecord(_ParcelTable);

                  FieldByName('TaxRollYr').Text := GetTaxRlYr;
                  FieldByName('SwisCode').Text := SwisSBLRec.SwisCode;
                  FieldByName('Section').Text := SwisSBLRec.Section;
                  FieldByName('Subsection').Text := SwisSBLRec.Subsection;
                  FieldByName('Block').Text := SwisSBLRec.Block;
                  FieldByName('Lot').Text := SwisSBLRec.Lot;
                  FieldByName('Sublot').Text := SwisSBLRec.Sublot;
                  FieldByName('Suffix').Text := SwisSBLRec.Suffix;
                  FieldByName('ActiveFlag').Text := ActiveParcelFlag;
                  FieldByName('ParcelCreatedDate').Text := DateToStr(Now);
                  FieldByName('LastChangeByName').Text := GlblUserName;
                  FieldByName('LastChangeDate').Text := DateToStr(Now);
                  FieldByName('CheckDigit').Text := ReturnCheckDigit(SwisSBLKey, 0);
                  FieldByName('PrintKey').Text := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                    {FXX03302001-1: If there is only 1 school code in the municipality,
                                    automatically fill it in.}

                  SchoolCodeTable := FindTableInDataModuleForProcessingType(DataModuleSchoolCodeTableName,
                                                                            GlblProcessingType);

                  If (SchoolCodeTable.RecordCount = 1)
                    then FieldByName('SchoolCode').Text := SchoolCodeTable.FieldByName('SchoolCode').Text;


                   {CHG06252001-1: Maintain a seperate indexed SwisSBLKey into the parcel file.}

                  with SwisSBLRec do
                    FieldByName('SwisSBLKey').Text := Take(6, SwisCode) +
                                                      Take(3, Section) + Take(3, Subsection) +
                                                      Take(4, Block) + Take(3, Lot) +
                                                      Take(3, Sublot) + Take(4, Suffix);

                  FieldByName('SplitMergeNo').Text := SplitMergeNumber;

                  Post;
                except
                  SystemSupport(005, _ParcelTable, 'Error inserting parcel record.', UnitName,
                                GlblErrorDlgBox);
                end;

                {Also, insert an assessment record.}

              with AssessmentTable do
                try
                  Insert;

                    {FXX03082006-1(2.9.5.8): The intialize has to be 1st.}
                    
                  InitializeFieldsForRecord(AssessmentTable);

                  FieldByName('TaxRollYr').Text := GetTaxRlYr;
                  FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);

                  Post;
                except
                  SystemSupport(005, AssessmentTable, 'Error inserting assessment record.', UnitName,
                                GlblErrorDlgBox);
                end;  {with AssessmentTable do}

                {FXX11071997-4: Add the new parcel to the totals file.
                                Note that we are only incrementing the
                                count here and putting it in roll section
                                1 with no homestead code. Once they
                                fill in roll section and homestead code
                                and val, the amount will switch to that
                                roll section.}

                {CHG12011997-2: STAR support}

                {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                                the parcel table for that.}
                {FXX02101999-4: Add land value to swis and school totals.}
                {FXX11021999-9: Don't adjust roll totals here - do it in the base pg. 1}

              (* AdjustRollTotalsForParcel(GetTaxRlYr,
                                        _ParcelTable.FieldByName('SwisCode').Text,
                                        '', ' ', '1', 0, 0, 0, 0,
                                        ExemptionCodes,
                                        ExemptionHomesteadCodes,
                                        CountyExemptionAmounts,
                                        TownExemptionAmounts,
                                        SchoolExemptionAmounts,
                                        VillageExemptionAmounts,
                                        _ParcelTable,
                                        BasicSTARAmount,
                                        EnhancedSTARAmount,
                                        SDAmounts,
                                        ['S'],  {Adjust swis only}
                                        'A');  {Add the totals.} *)

                {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}
                {Note that the parcel has no assessed value at this point.
                 So, we must create a blank exemption amount array.}

              For I := 1 to 4 do
                EXAmounts[I] := 0;

              GetAuditParcelRec(_ParcelTable, 0, EXAmounts, NewAuditParcelRec);

              InsertParcelChangeRec(SwisSBLKey, GetTaxRlYr, AuditParcelChangeTable,
                                    OrigAuditParcelRec, NewAuditParcelRec,
                                    'A');

                {CHG10281997-1: More dual processing.}

              If GlblModifyBothYears
                then
                  begin
                    with SwisSBLRec do
                      Found := FindKeyOld(OppositeYearParcelTable,
                                          ['TaxRollYr', 'SwisCode', 'Section',
                                           'Subsection', 'Block', 'Lot',
                                           'Sublot', 'Suffix'],
                                          [OppositeTaxYear,
                                           SwisCode, Section,
                                           SubSection,
                                           Block, Lot,
                                           Sublot, Suffix]);

                    If not Found
                      then
                        begin
                            {Open the opposite year assessment table.}

                          OppositeYearAssessmentTable := TTable.Create(nil);

                          OpenTableForProcessingType(OppositeYearAssessmentTable,
                                                     AssessmentTableName,
                                                     OppositeProcessingType, Quit);

                          FindKeyOld(OppositeYearAssessmentTable,
                                     ['TaxRollYr', 'SwisSBLKey'],
                                     [OppositeTaxYear, SwisSBLKey]);

                             {Now copy the changes to the other year.}

                          OppositeYearParcelTable.Insert;

                          CopyFields(_ParcelTable, OppositeYearParcelTable,
                                     ['TaxRollYr'], [OppositeTaxYear]);

                          try
                            OppositeYearParcelTable.Post;
                          except
                            SystemSupport(050, OppositeYearParcelTable,
                                          'Error posting opposite year record.', UnitName,
                                          GlblErrorDlgBox);
                          end;

                            {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                                          the parcel table for that.}
                            {FXX02101999-4: Add land value to swis and school totals.}
                            {FXX11021999-9: Don't adjust roll totals here - do it in the base pg. 1}

                          (*AdjustRollTotalsForParcel(OppositeTaxYear,
                                                    OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                                    '', ' ', '1', 0, 0, 0, 0,
                                                    ExemptionCodes,
                                                    ExemptionHomesteadCodes,
                                                    CountyExemptionAmounts,
                                                    TownExemptionAmounts,
                                                    SchoolExemptionAmounts,
                                                    VillageExemptionAmounts,
                                                    OppositeYearParcelTable,
                                                    BasicSTARAmount,
                                                    EnhancedSTARAmount,
                                                    SDAmounts,
                                                    ['S'],  {Adjust swis only}
                                                    'A');  {Add the totals.} *)

                            {Now create an assessment table.}

                          OppositeYearAssessmentTable.Insert;

                          CopyFields(AssessmentTable, OppositeYearAssessmentTable,
                                     ['TaxRollYr'], [OppositeTaxYear]);

                          try
                            OppositeYearAssessmentTable.Post;
                          except
                            SystemSupport(050, OppositeYearAssessmentTable,
                                          'Error posting opposite year record.', UnitName,
                                          GlblErrorDlgBox);
                          end;

                          OppositeYearAssessmentTable.Close;
                          OppositeYearAssessmentTable.Free;

                             {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}
                             {Note that the parcel has no assessed value at this point.
                              So, we must create a blank exemption amount array.}

                           For I := 1 to 4 do
                             EXAmounts[I] := 0;

                           GetAuditParcelRec(OppositeYearParcelTable, 0,
                                             EXAmounts, NewAuditParcelRec);

                           InsertParcelChangeRec(SwisSBLKey, OppositeTaxYear,
                                                 AuditParcelChangeTable,
                                                 OrigAuditParcelRec, NewAuditParcelRec,
                                                 'A');


                        end;  {If not Found}

                  end;  {If GlblModifyBothYears}

              ExemptionCodes.Free;
              ExemptionHomesteadCodes.Free;
              CountyExemptionAmounts.Free;
              TownExemptionAmounts.Free;
              SchoolExemptionAmounts.Free;
              VillageExemptionAmounts.Free;
              FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

                {Set the caption for the parcel to reflect this parcel.
                 To do this, we will extract the parcel maint.
                 type (A/M/D/V) and instance number (everything
                 to the left of the colon). Then we will add the
                 SBL to this.}

              CaptionName := Copy(Caption, 1, (Pos(':', Caption) - 1));

              Caption := CaptionName + ': ' + ConvertSwisSBLToDashDot(SwisSBLKey);

              NewTabAdded := False;

                {Set up the main tabs for parcel, i.e. the ones that apply to the GlblTaxYrFlg.}

              SetMainTabsForParcel(ParcelTabSet, _TabTypeList, LookupTable, SwisSBLKey,
                                   GetTaxRlYr, _SalesNumber,
                                   _ResidentialSite, _CommercialSite, _CommBuildingNo,
                                   _CommBuildingSection, _NumResSites, _NumComSites,
                                   True);

              EnablePopupMenuOptions;

                {Now we will simulate a click on the base form so that we go to
                 this form.}
                {CHG09301997 - Start on the first page that the
                               user wants - summary, base page 1
                               or 2 or assessment.}
                {FXX11021999-10: Force them to page 1 so they fill in the roll section.}

              with Sender as TComponent do
                Tag := BaseParcelPg1FormNumber;

              PopupMenuClick(Sender);

              AddParcelPanel.Visible := False;
              GlblDialogBoxShowing := False;

            end;  {else of If FoundRec}

      end  {If ValidEntry}
    else
      begin
        If Continue
          then
            begin
              MessageDlg(AddParcelEdit.Text + ' is not a valid parcel ID.' + #13 +
                         'Please re-enter.', mtError, [mbOK], 0);
              AddParcelEdit.SetFocus;
            end;

      end;  {If (Continue and ...}

end;  {OKButtonClick}

{=======================================================================}
Procedure TParcelTabForm.ParcelTabSetDrawTab(Sender: TObject;
                                             TabCanvas: TCanvas;
                                             R: TRect;
                                             Index: Integer;
                                             Selected: Boolean);
begin
    {FXX10231997-3: When the user switched assessment years while
                    parcel maint was up, was calling ParcelTabSetDrawTab
                    even though form called and getting GPF when tried
                    to access TabTypeList.}

  If ((_TabTypeList <> nil) and
      (Index <= (_TabTypeList.Count - 1)))
    then
      begin
        If Selected
          then TabCanvas.Brush.Color := ParcelTabSet.SelectedColor
          else
            case DetermineProcessingType(_TabTypeList[Index][1]) of
              ThisYear : begin
                           TabCanvas.Brush.Color := ThisYearTabColor;
                           TabCanvas.Font.Color := ThisYearFontColor;
                         end;

              NextYear : begin
                           TabCanvas.Brush.Color := NextYearTabColor;
                           TabCanvas.Font.Color := NextYearFontColor;
                         end;

              History : begin
                          TabCanvas.Brush.Color := HistoryTabColor;
                          TabCanvas.Font.Color := HistoryFontColor;
                        end;

              SalesInventory : begin
                                 TabCanvas.Brush.Color := SalesInventoryTabColor;
                                 TabCanvas.Font.Color := SalesInventoryFontColor;
                               end;

              NoProcessingType : begin
                                   TabCanvas.Brush.Color := clRed;
                                   TabCanvas.Font.Color := clWhite;
                                 end;

            end;  {case TabTypeList[Index] of}

        CenterText(R, TabCanvas, ParcelTabSet.Tabs[Index], True, False,
                   ParcelTabSet.SelectedColor);

      end;  {If (Index <= (TabTypeList.Count - 1))}

end;  {ParcelTabSetDrawTab}

{=================================================================}
Procedure TParcelTabForm.ShowOppositeYearTabsClick(Sender: TObject);

var
  TaxRollYear : String;
  TempOppositeYearTbl : TTable;
  ProcessingType : Integer;
  FoundRec, Quit : Boolean;
  TempStr : String;

begin
  ProcessingType := GlblProcessingType;

  case GlblTaxYearFlg of
    'T' : begin
            TaxRollYear := GlblNextYear;
            ProcessingType := NextYear;
          end;

    'N' : begin
            TaxRollYear := GlblThisYear;
            ProcessingType := ThisYear;
          end;

    'H' : begin
            TaxRollYear := GlblNextYear;  {If history, we will show next year.}
            ProcessingType := NextYear;
          end;

  end;  {case GlblTaxYearFlg of}

  NewTabAdded := False;

    {Open up a table for the opposite year and try to look up this parcel. It
     may not exist in which place we will tell them.}

  TempOppositeYearTbl := nil;
  FoundRec := False;
  try
    Quit := False;
    TempOppositeYearTbl := TTable.Create(nil);
    OpenTableForProcessingType(TempOppositeYearTbl, 'TParcelRec', ProcessingType, Quit);
    TempOppositeYearTbl.IndexName := ParcelTable_Year_Swis_SBLKey;

    with _ParcelTable do
      FoundRec := FindKeyOld(TempOppositeYearTbl,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                             [TaxRollYear,
                              FieldByName('SwisCode').Text,
                              FieldByName('Section').Text,
                              FieldByName('Subsection').Text,
                              FieldByName('Block').Text,
                              FieldByName('Lot').Text,
                              FieldByName('Sublot').Text,
                              FieldByName('Suffix').Text]);

  except
    SystemSupport(100, TempOppositeYearTbl, 'Error creating\opening opposite year parcel table.',
                  UnitName, GlblErrorDlgBox);
  end;

    {Set up the main tabs for parcel, i.e. the ones that apply to the GlblTaxYrFlg.}

  If FoundRec
    then
      begin
          {CHG03262002-1: Retain TY\NY tab setting as scroll between parcels.}

        OppositeYearTabsShowing := True;
        SetOppositeYearTabsForParcel(ParcelTabSet, _TabTypeList, LookupTable, ExtractSSKey(_ParcelTable),
                               TaxRollYear, _ResidentialSite,
                               _CommercialSite, _CommBuildingNo, _CommBuildingSection,
                               _NumResSites, _NumComSites);
      end
    else
      begin
        If (ProcessingType = NextYear)
          then TempStr := 'next year'
          else TempStr := 'this year';

        MessageDlg('This parcel does not exist in the ' + TempStr + ' assessment year file.',
                   mtInformation, [mbOK], 0);

      end;  {else of If FoundRec}

  TempOppositeYearTbl.Close;
  TempOppositeYearTbl.Free;

end;  {ShowOppositeYearTabsClick}

{================================================================}
Procedure TParcelTabForm.HideOppositeYearTabsClick(Sender: TObject);

{Go through all the tabs and take out any that are the opposite year.}

var
  Count, I : Integer;
  OppositeYearType : Char;

begin
  Count := _TabTypeList.Count;

    {CHG03262002-1: Retain TY\NY tab setting as scroll between parcels.}

  OppositeYearTabsShowing := False;
  OppositeYearType := 'N';

  case GlblTaxYearFlg of
    'T',
    'H' : OppositeYearType := 'N';
    'N' : OppositeYearType := 'T';
  end;

  For I := (Count - 1) downto 0 do
    If (_TabTypeList[I] = OppositeYearType)
      then
        begin
          _TabTypeList.Delete(I);
          ParcelTabSet.Tabs.Delete(I);
        end;

end;  {HideOppositeYearTabsClick}

{================================================================}
Procedure TParcelTabForm.HideSalesInventoryClick(Sender: TObject);

{Go through all the tabs and take out any that are sales inventory.}

var
  Count, I : Integer;

begin
  Count := _TabTypeList.Count;

  For I := (Count - 1) downto 0 do
    If (_TabTypeList[I] = 'S')
      then
        begin
          _TabTypeList.Delete(I);
          ParcelTabSet.Tabs.Delete(I);
        end;

end;  {HideSalesInventoryClick}

{================================================================}
Procedure TParcelTabForm.ParcelScrollClick(Sender: TObject);

var
  DisplayThisParcel, ExitOfLastParcelCancelled, Quit,
  FoundRec, ChangedParcels, ActiveParcel : Boolean;
  RollYear, AssessmentYear, Name1, LegalAddr, LegalAddrNo,
  LastParcelTabName, PriorSBLKey, SBLKey,
  TempTableName, IndexNumberFieldName, IndexNumberIndexName : String;
  SBLRec : SBLRecord;
  WarningCodeList, WarningDescList : TStringList;

begin
  FoundRec := True;
  RollYear := GetTaxRlYr;
  ChangedParcels := True;
  DisplayThisParcel := True;
  ExitOfLastParcelCancelled := False;
  PriorSBLKey := ExtractSSKey(_ParcelTable);

  If (GlblLastLocateInfoRec.LastLocatePage = 'P')
    then
      begin
        with _ParcelTable do
          begin
            AssessmentYear := FieldByName('TaxRollYr').Text;
            Name1 := FieldByName('Name1').Text;
            LegalAddr := FieldByName('LegalAddr').Text;
            LegalAddrNo := FieldByName('LegalAddrInt').Text;
          end;  {with _ParcelTable do}

          {Switch indices.}
          {CHG03042001-1: Look up by LegalAddrInt instead of the text addr #.}

        with _ParcelTable do
          case GlblLastLocateInfoRec.LastLocateKey of
            lcPParcelLongFormat,
            lcPParcelID : IndexName := ParcelTable_Year_Swis_SBLKey;
            lcPLegalAddress :
                begin
                  IndexName := 'BYYEAR_LEGALADDRNO_LEGALADDR';
                  FindNearestOld(_ParcelTable,
                                 ['TaxRollYr', 'LegalAddrInt', 'LegalAddr'],
                                 [AssessmentYear, LegalAddrNo,
                                  Take(30, LegalAddr)]);

                      {We may need to scroll to find this parcel.}

                  If (ExtractSSKey(_ParcelTable) <> PriorSBLKey)
                    then FindThisParcel(_ParcelTable, PriorSBLKey);

                end;  {Legal addr # \ legal addr}

            lcPStreetName :
                begin
                  IndexName := 'BYYEAR_LEGALADDR_LEGALADDRINT';

                  FindNearestOld(_ParcelTable,
                                 ['TaxRollYr', 'LegalAddr', 'LegalAddrInt'],
                                 [AssessmentYear, Take(30, LegalAddr),
                                  LegalAddrNo]);

                    {We may need to scroll to find this parcel.}

                  If (ExtractSSKey(_ParcelTable) <> PriorSBLKey)
                    then FindThisParcel(_ParcelTable, PriorSBLKey);

                end;  {Legal addr \ legal addr #}

            lcPOwnerName :
                begin
                  IndexName := 'BYYEAR_NAME';

                  FindNearestOld(_ParcelTable, ['TaxRollYr', 'Name1'],
                                 [AssessmentYear, Take(30, Name1)]);

                    {We may need to scroll to find this parcel.}

                  If (ExtractSSKey(_ParcelTable) <> PriorSBLKey)
                    then FindThisParcel(_ParcelTable, PriorSBLKey);

                end;  {Name}

          end;  {case GlblLastLocateKey of}

      end;  {If (GlblLastLocateInfoRec.LastLocatePage = 'P')}

    {CHG11052002-1: Allow scroll by grievance, small claim or cert.}

  If (GlblLastLocateInfoRec.LastLocatePage in ['G', 'C', 'S'])
    then
      begin
        case GlblLastLocateInfoRec.LastLocatePage of
          'G' : begin
                  TempTableName := GrievanceTableName;
                  IndexNumberFieldName := 'GrievanceNumber';
                  IndexNumberIndexName := 'BYGREVNUM';
                end;  {Grievance}

          'S' : begin
                  TempTableName := SmallClaimsTableName;
                  IndexNumberFieldName := 'IndexNumber';
                  IndexNumberIndexName := 'BYINDEXNUM';
                end;  {Small Claims}

          'C' : begin
                  TempTableName := CertiorariTableName;
                  IndexNumberFieldName := 'CertiorariNumber';
                  IndexNumberIndexName := 'BYCERTNUM';
                end;  {Certiorari}

        end;  {case GlblLastLocateInfoRec.LastLocatePage of}

        OpenTableForProcessingType(LookupTable, TempTableName,
                                   GlblProcessingType, Quit);

          {Make sure we limit it to the same year range as what was
           originally selected.}

        If (Deblank(GlblLastLocateInfoRec.LastSpecificGrievanceYear) <> '')
          then
            with LookupTable do
              try
                Filter := 'TaxRollYr = ' + GlblLastLocateInfoRec.LastSpecificGrievanceYear;
                Filtered := True;
              except
              end;

          {Now reaccess the grievance record for this particular parcel ID.}

        LookupTable.IndexName := 'BySwisSBLKey';

        FindKeyOld(LookupTable, ['SwisSBLKey'], [PriorSBLKey]);

        SetLastLocateInfoRec(GlblLastLocateInfoRec,
                             GlblLastLocateInfoRec.LastLocatePage,
                             GlblLastLocateInfoRec.LastLocateKey,
                             LookupTable,
                             IndexNumberFieldName,
                             GlblLastLocateInfoRec.LastSpecificGrievanceYear);

        with LookupTable do
          case GlblLastLocateInfoRec.LastLocateKey of
            lcGParcelID : IndexName := 'BySwisSBLKey';
            lcGLegalAddress : IndexName := 'BYLEGALADDRINT_LEGALADDR';
            lcGStreetName : IndexName := 'BYLEGALADDR_LEGALADDRINT';
            lcGOwnerName : IndexName := 'ByOwnerName';
            lcGIndexNumber : IndexName := IndexNumberIndexName;
            lcGPetitionerName : IndexName := 'ByPetitionerName';

          end;  {case GlblLastLocateInfoRec.LastLocateKey of}

        RelocateParcelByGrievanceTable(LookupTable,
                                       GlblLastLocateInfoRec.LastLocateKey,
                                       IndexNumberFieldName,
                                       GlblLastLocateInfoRec);

      end;  {If (GlblLastLocateInfoRec.LastLocatePage in ['G', 'C', 'S'])}

    {Now reaccess the original parcel for the given index.
     Note that we did it by location (i.e. the bookmark).}

(*  _ParcelTable.GotoBookmark(Bookmark);
  _ParcelTable.FreeBookmark(Bookmark); *)

    {FXX10111999-4: Allow selection of what warning messages are displayed
                    on scroll, too.}

  If (_EditMode = 'M')
    then
      begin
        WarningCodeList := TStringList.Create;
        WarningDescList := TStringList.Create;

          {CHG09071999-3: Allow selection of what warning messages are displayed.}

        GetParcelWarnings(GetTaxRlYr, PriorSBLKey,
                          WarningCodeList, WarningDescList, GlblWarningOptions);

        If (WarningCodeList.Count > 0)
          then
            begin
              WarningMessageDialog.DisplayWarnings(GetTaxRlYr,
                                                   PriorSBLKey,
                                                   WarningCodeList,
                                                   WarningDescList);

              WarningMessageDialog.ShowModal;
              ExitOfLastParcelCancelled := WarningMessageDialog.Cancelled;

            end;  {If (WarningCodeList.Count > 0)}

        WarningCodeList.Free;
        WarningDescList.Free;

      end;

  If not ExitOfLastParcelCancelled
    then
      begin
        with Sender as TComponent do
          If (GlblLastLocateInfoRec.LastLocatePage = 'P')
            then
              begin
                If (Name = 'NextParcel')
                  then
                    begin
                      _ParcelTable.Next;

                      If _ParcelTable.EOF
                        then ChangedParcels := False;
                    end
                  else
                    begin
                      _ParcelTable.Prior;

                      If _ParcelTable.EOF
                        then ChangedParcels := False;

                    end;  {else of If (Name = 'NextParcel') ...}
              end
            else
              begin
                If (Name = 'NextParcel')
                  then
                    begin
                      LookupTable.Next;

                      If LookupTable.EOF
                        then ChangedParcels := False;
                    end
                  else
                    begin
                      LookupTable.Prior;

                      If LookupTable.EOF
                        then ChangedParcels := False;

                    end;  {else of If (Name = 'NextParcel') ...}

                  {Now look this up in the parcel table.}

                If ChangedParcels
                  then
                    begin
                      SBLRec := ExtractSwisSBLFromSwisSBLKey(LookupTable.FieldByName('SwisSBLKey').Text);
                      _ParcelTable.IndexName := ParcelTable_Year_Swis_SBLKey;

                      with SBLRec do
                        FoundRec := FindKeyOld(_ParcelTable,
                                               ['TaxRollYr', 'SwisCode', 'Section',
                                                'Subsection', 'Block', 'Lot',
                                                'Sublot', 'Suffix'],
                                               [GetTaxRlYr, SwisCode, Section, Subsection,
                                                Block, Lot, Sublot, Suffix]);

                    end;  {If ChangedParcels}

                LookupTable.Filtered := False;
                LookupTable.Filter := '';

              end;  {else of If (GlblLastLocateInfoRec.LastLocatePage = 'P')}

        ActiveParcel := True;

        If (ChangedParcels and
            (_EditMode = 'M') and
            (_ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag))
          then
            begin
              MessageDlg('That parcel is inactive and can not be modified.' + #13 +
                         'Please select a different parcel.', mtError, [mbOK], 0);
              ActiveParcel := False;
              DisplayThisParcel := False;

            end;  {If (ChangedParcels and ...}

          {Now if we found the parcel and it is active (only applies for modify),
           then let's display it.}

        If DisplayThisParcel
          then
            begin
              SBLKey := ExtractSSKey(_ParcelTable);
              SBLRec := ExtractSwisSBLFromSwisSBLKey(SBLKey);

              CurrentSwisSBLKey := SBLKey;

                {Let's figure out what tab they are on and simulate a click to
                 this tab. If such a tab does not exist, then we will go to base
                 page 1.}

              LastParcelTabName := ParcelTabSet.Tabs[ParcelTabSet.TabIndex];

              SetCaption(SBLKey, _ParcelTable.FieldByName('AccountNo').Text);

              NewTabAdded := False;

                {Set up the main tabs for parcel, i.e. the ones that apply to the GlblTaxYrFlg.}

              SetMainTabsForParcel(ParcelTabSet, _TabTypeList, LookupTable, SBLKey,
                                   GetTaxRlYr, _SalesNumber,
                                   _ResidentialSite, _CommercialSite, _CommBuildingNo,
                                   _CommBuildingSection, _NumResSites, _NumComSites,
                                   FoundRec);

                {CHG03262002-1: Retain TY\NY tab setting as scroll between parcels.}

              If OppositeYearTabsShowing
                then ShowOppositeYearTabsClick(Sender);

              EnablePopupMenuOptions;

                {Now we will simulate a click on the same tab  as before so that we
                 go to that form.}

              with Sender as TComponent do
                If (ParcelTabSet.Tabs.IndexOf(LastParcelTabName) = -1)
                  then
                    begin
                        {CHG09301997 - Start on the first page that the
                                       user wants - summary, base page 1
                                       or 2 or assessment.}

                        {CHG01082003-1: Allow for a different default on the parcel view, too.}

                      with Sender as TComponent do
                        If (_EditMode = 'V')
                          then Tag := GlblDefaultParcelViewPage
                          else Tag := GlblFirstParcelPageShown;

                    end
                  else Tag := GetTagForParcelTabName(LastParcelTabName);

                {CHG08182002-2: Default Cert Only users to the cert page.}

              If GlblCertiorariOnly
                then
                  with Sender as TComponent do
                    Tag := CertiorariFormNumber;

              PopupMenuClick(Sender);

            end;  {If (ChangedParcels and ...}

          {Return to the last parcel if we could not go to the next one since
           this is modify mode and the next (prior) parcel is either locked or
           inactive.}

        If not ActiveParcel
          then
            with Sender as TComponent do
              If (Name = 'NextParcel')
                then _ParcelTable.Prior
                else _ParcelTable.Next;

      end;  {If not ExitOfLastParcelCancelled}

end;  {ParcelScrollClick}

{================================================================}
Procedure TParcelTabForm.SwitchtoOppositeYearMenuItemClick(Sender: TObject);

{CHG03282002-1: Allow easy switch between this year and next year for the
                same parcel.}

var
  Action : TCloseAction;

begin
  Action := caNone;
  SwitchingYears := True;

    {First close what we have.}

  FormClose(Sender, Action);

    {Now switch the GlblProcessing years and restart.}

  If (GlblProcessingType = ThisYear)
    then
      begin
        GlblProcessingType := NextYear;
        GlblTaxYearFlg := 'N';
        ShowOppositeYearTabs.Caption := 'Show This Year';

      end  {If (GlblProcessingType = ThisYear)}
    else
      If (GlblProcessingType = NextYear)
        then
          begin
            GlblProcessingType := ThisYear;
            GlblTaxYearFlg := 'T';
            ShowOppositeYearTabs.Caption := 'Show Next Year';

          end;  {If (GlblProcessingType = NextYear)}

  _ParcelTable.Close;
  _ParcelTable.TableName := ParcelTableName;

  SwisCodeTable.Close;
  SwisCodeTable.TableName := SwisCodeTableName;

  FormShow(Sender);
  FormActivate(Sender);

  LocateParcel1Click(Sender);

  SwitchingYears := False;

end;  {SwitchtoOppositeYearMenuItemClick}

{================================================================}
Procedure TParcelTabForm.ShowParcelToollbar1Click(Sender: TObject);

begin
  ParcelToolbarForm.Visible := True;
end;

{================================================================}
Procedure TParcelTabForm.ExitParcelMaintenance1Click(Sender: TObject);

begin
  Close;
end;

{========================================================================}
Procedure TParcelTabForm.FormDeactivate(Sender: TObject);

{The parcel Tab child form is the front most form, and if we are switching
 to another job. (from the top menu bar), we need to send it to back,
 so that this new job will show.}

begin
   {this allows other non-parcelTabform forms (eg sd codes, ex codes) }
   {to appear on screen}

   {Also, if they are closing the whole application, then we will not try to
    send the parcel child to the back. For some reason, the Activate and
    Deactivate events of the form are being called during a close of the
    whole application. Using the GlblApplicationIsClosing variable prevents
    us from taking action on the ParcelTabChild when we really don't want to,
    i.e. during the closing events for the whole application.}
   {CHG09272001-1: Parcel toolbar.}

  If ((ParcelTabChild <> Nil) and
      (not (GlblClosingAForm or GlblApplicationIsClosing)) and
      (Pos('Parcel List', Screen.ActiveForm.Caption) = 0) and
      (Pos('Toolbar', Screen.ActiveForm.Caption) = 0) and
      (ParcelTabChild.Tag <> MapFormNumber))
    then
      begin
          {If this is edit or add mode, send the child to the back and
           leave open.}

        If (_EditMode in ['A', 'M'])
          then ParcelTabChild.SendToBack;

          {Otherwise, free the parcel tab child (i.e. parcel page) and we will
           recreate it next time we come into this instance of parcel view.}

        If (_EditMode = 'V')
          then
            begin
              ParcelTabChild.Free;
              ParcelTabChild := nil; {This is very important -
                                      Free does not nil child pointer.}
            end;

      end;  {If ((ParcelTabChild <> Nil) and ...}

end;  {FormDeactivate}

{========================================================================}
Procedure TParcelTabForm.FormCloseQuery(    Sender: TObject;
                                        var CanClose: Boolean);

{It is OK to close ParcelTabForm if it is ok to close the active child.}

begin
    {CHG11071997-3: Once a searcher clicks close, go back to the locate
                    to find another parcel.}

(*  If (GlblUserIsSearcher and
      (not GlblUserPressedParcelExit))
    then
      begin
        CanClose := False;
        SearchDialogueTimer.Enabled := True;
      end
    else
      If (ParcelTabChild <> nil)
        then CanClose := ParcelTabChild.CloseQuery; *)

    {CHG11231997-1: Return to locate for modify and view also, but not
                    add.}
    {FXX11251997-4: Only return to parcel locate if this is the active
                    form.  They may be exiting PAS and have a different
                    form active and we don't want to show parcel locate
                    in this case.}

  If ((_EditMode in ['M', 'V']) and
      (not GlblUserPressedParcelExit) and
      (Screen.ActiveForm.Caption = Caption))
    then
      begin
          {FXX11041998-1: Move close of page to here so know right away if
                          have unsaved changes.}

       (* If ((ParcelTabChild <> nil) and
            (not TabChanged))
          then ParcelTabChild.Close;*)

           {if user elects NOT to Close in ParcelTabChild.Close just above, we skip}
           {rest of PopUpMenuClick processing and return to last active form}

(*        If not GlblParcelPageCloseCancelled
          then
            begin
              SearchDialogueTimer.Enabled := True;
              ParcelTabChild := Nil;
            end; *)

    {FXX08261999-2: If click X in upper right, exit all the way, not
                    back to locate menu.}

        If GlblApplicationIsClosing
          then CanClose := True
          else
            begin
              CanClose := False;
              SearchDialogueTimer.Enabled := True;
            end;

      end;  {If ((_EditMode in ['M', 'V']) and ...}

end;  {FormCloseQuery}

{========================================================================}
Procedure TParcelTabForm.FormClose(    Sender: TObject;
                                   var Action: TCloseAction);

begin
  ParcelToolbarForm.Visible := False;

  If (ParcelTabChild <> nil)
    then
      begin
        ParcelTabChild.Close;
        ParcelTabChild := nil;
      end;

  ClosingForm := True;
  CloseTablesForForm(Self);

    {Free up the string lists.}

  MenuSecurityTags.Free;
  MenuSecurityLevels.Free;
  DisableMenuItems.Free;
  _TabTypeList.Free;
  _TabTypeList := nil;

    {Free up the residential and commercial info arrays.}
    {FXX10081997-1: Use FreeMem rather than Dispose to make sure
                    that we are freeing the right amount of memory.}

  FreeMem(_ResidentialSite, SizeOf(ProcessingTypeArray));
  FreeMem(_CommercialSite, SizeOf(ProcessingTypeArray));
  FreeMem(_CommBuildingNo, SizeOf(ProcessingTypeArray));
  FreeMem(_CommBuildingSection, SizeOf(ProcessingTypeArray));
  FreeMem(_NumResSites, SizeOf(ProcessingTypeArray));
  FreeMem(_NumComSites, SizeOf(ProcessingTypeArray));

   {Set the ClosingAForm Boolean to true so that we know to delete
    the Tab in the MainForm. Note that we do not free the ParcelTabChild
    since it is in the private section of the form and is thus automatically
    freed by Delphi when the form closes. That is, Delphi looks through all of the
    components that is in the form declaration and frees them. If we free the
    ParcelTabChild here, we will get a GPF.}

  If SwitchingYears
    then Action := caNone
    else Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
