unit Utilprcl;

interface

uses Utilitys, PASUTILS, UTILEXSD,  Types, GlblVars, DBTables, Tabs, WinUtils, Classes,
     GlblCnst, DB, DataModule, SysUtils, Dialogs, DataAccessUnit, ADODB;

{These constants and the following array are to keep track of various attributes about
 the active parcel maint. since it may span several processing types (i.e. next year, this
 year, and sales inv.). In this case, there could be 3 residential site pages active, and
 we need to keep track of the active site on all of them. The ProcessingTypeArray will
 allow us to do this, i.e. ResidentialSite[History] = 0 (not active),
 ResidentialSite[NextYear] = 2, ResidentialSite[ThisYear] = 1,
 ResidentialSite[SalesInventory] = 1. This would say that the next year residential site
 page is on site 2, the this year on site 1, etc. This will prevent us from needing lots
 of case statements everytime we need to access information such as the current
 residential site for this year, etc.

 Note that we have to have a pointer to the arrays so that changes within the sales
 maintenance are carried back to the ParcelTabForm. For example, ResidentialSite is
 a public variable in the ParcelSalesForm which is set in ParcelTabForm when it is
 created. If the sales inventory tabs are brought up, we want to know what residential
 site is active. So, by making ResidentialSite a pointer to an array and changing the
 array, the original ResidentialSite pointer in ParcelTabForm can access the changes.}

type
  PProcessingTypeArray = ^ProcessingTypeArray;
  ProcessingTypeArray = Array[1..4] of Integer;  {History, NextYear, ThisYear, SalesInventory}

const
  ShowInventory = True;  {For debugging only!}

  {Put the items into the Tab list in the order that they should appear on
   the screen left to right.  For each new form, do the following:

   1. Create a xxxTabName string constant which is the text which will appear
      on the Tab.
   2. Create a xxxFormNumber integer constant which is a unique number
      identifying the form. If this form can be created from a popup menu,
      then put this form number in the Tag field of the TMenuItem.
      (i.e. If this is the ResidentialSiteForm, and it has a form number of 6,
       then in the ObjectInspector, look up the TMenuItem for the create
       Residential Sites item, and set the Tag to 6.
   3. Adjust the MaxNumPages if necessary and add the xxxTabName constant into
      the TabOrder array so that this Tab is in the order it should appear
      from left to right.}

const
  MaxNumPages = 39;

type
  TabOrderArray = Array[1..MaxNumPages] of String;

const
   {CHG10121998-2: I had to move the screen form numbers to GlblCnst in order to
                   centralize the SetGlobalUserDefaults routine across several
                   units.}
   {CHG08021999-3: Add exemptions denial page.}
   {CHG04122001-1: Add removed exemptions page.}

  TabOrder : TabOrderArray = (SummaryTabName,
                              BaseParcelPg1TabName,
                              BaseParcelPg2TabName,
                              TaxBillAddressTabName,
                              AssessmentTabName,
                              ClassTabName,
                              SpecialDistrictTabName,
                              ExemptionsTabName,
                              ExemptionsDenialTabName,
                              ExemptionsRemovedTabName,
                              SalesTabName,
                              AdditionalOwnersTabName,
                              ResidentialSiteTabName,
                              ResidentialBldgTabName,
                              ResidentialLandTabName,
                              ResidentialForestTabName,
                              ResidentialImprovementsTabName,
                              CommercialSiteTabName,
                              CommercialBldgTabName,
                              CommercialLandTabName,
                              CommercialImprovementsTabName,
                              CommercialRentTabName,
                              CommercialIncomeExpenseTabName,
                              UserDataTabName,
                              NotesTabName,
                              PictureTabName,
                              DocumentTabName,
                              PropertyCardTabName,
                              SketchTabName,
                              PermitsTabName,
                              MapTabName,
                              ThirdPartyNotificationTabName,
                              ProrataTabName,
                              GrievanceTabName,
                              CertiorariTabName,
                              SmallClaimsTabName,
                              PASPermitsTabName,
                              SplitSchoolDistrictTabName,
                              AgricultureTabName);


Procedure OpenLookupTable(LookupTable : TTable;
                          TName : String;
                          ProcessingType : Integer);
{This is a special open because the lookup table to determine if tabs exist
 for each page is one shared table - LookupTable. So each time before a lookup,
 we close the table, set it to the table name of the table for this page,
 change the name for the tax year and finally open it up.}

Function DetermineTabPos(ParcelTabs : TStrings;
                         TabName : String;
                         TabOffset : Integer) : Integer;
{Figure out where in the present Tab list we should put the new Tab.
 The order is determined by this Tabs name in the TabOrder array defined
 in the constants above.}

Function DetermineNumSites(InventorySiteTable : TTable) : Integer;
{Given a residential or commercial site table with the range set, how many sites are there?}

Procedure DeleteInventoryTabsForProcessingType(ParcelTabSet : TTabSet;
                                               TabTypeList : TStringList;
                                               ProcessingType : Integer;
                                               InventoryType : Char;
                                               DeleteSiteTab : Boolean);  {'C' = commercial, 'R' = residential}
{Look through the tabs and delete the inventory tabs related to this processing and inventory type,
 i.e. all commercial inventory tabs for this year.}

Procedure SetCommercialInventoryTabsForSite(ParcelTabSet : TTabSet;
                                            TabTypeList : TStringList;
                                            LookupTable : TTable;
                                            TaxRollYear : String;
                                            SwisSBLKey : String;
                                            ProcessingType,
                                            Site,
                                            SalesNumber : Integer;  {Only used for sales inventory processing type.}
                                            CommBuildingNo,
                                            CommBuildingSection : PProcessingTypeArray);
{Figure out what tabs exist for this site and add them to the parcel tab set and the corresponding
 tab type list which tells us what processing type each tab is.}

Procedure SetResidentialInventoryTabsForSite(ParcelTabSet : TTabSet;
                                             TabTypeList : TStringList;
                                             LookupTable : TTable;
                                             TaxRollYear : String;
                                             SwisSBLKey : String;
                                             ProcessingType,
                                             Site,
                                             SalesNumber : Integer);  {Only used for sales inventory processing type.}
{Figure out what tabs exist for this site and add them to the parcel tab set and the corresponding
 tab type list which tells us what processing type each tab is.}

Procedure AddExemptionDenialTab(LookupTable : TTable;
                                ParcelTabset : TTabSet;
                                ProcessingType : Integer;
                                TabOffset : Integer;
                                TabTypeList : TStringList;
                                TaxRollYear : String;
                                SwisSBLKey : String);

Procedure AddExemptionRemovalTab(LookupTable : TTable;
                                 ParcelTabset : TTabSet;
                                 ProcessingType : Integer;
                                 TabOffset : Integer;
                                 TabTypeList : TStringList;
                                 TaxRollYear : String;
                                 SwisSBLKey : String);

Procedure AddExemptionTab(LookupTable : TTable;
                          ParcelTabset : TTabSet;
                          ProcessingType : Integer;
                          TabOffset : Integer;
                          TabTypeList : TStringList;
                          TaxRollYear : String;
                          SwisSBLKey : String);

Procedure SetMainTabsForParcel(    ParcelTabSet : TTabSet;
                                   TabTypeList : TStringList;
                                   LookupTable : TTable;
                                   SwisSBLKey : String;
                                   TaxRollYear : String;
                               var SalesNumber : Integer;
                                   ResidentialSite,
                                   CommercialSite,
                                   CommBuildingNo,
                                   CommBuildingSection,
                                   NumResSites,
                                   NumComSites : PProcessingTypeArray;
                                   ParcelExists : Boolean);

{Figure out what tabs apply to this new parcel. Set the main tabs up for this parcel. The main tabs
 will be the leftmost and apply to the GlblTaxYear that they are processing in only.}

Procedure SetOppositeYearTabsForParcel(ParcelTabSet : TTabSet;
                                       TabTypeList : TStringList;
                                       LookupTable : TTable;
                                       SwisSBLKey : String;
                                       TaxRollYear : String;
                                       ResidentialSite,
                                       CommercialSite,
                                       CommBuildingNo,
                                       CommBuildingSection,
                                       NumResSites,
                                       NumComSites : PProcessingTypeArray);
{Figure out what opposite year tabs apply to this new parcel. That is if this is next year, figure
 out what the this year tabs apply to this parcel. We will put them at the end of the tabs. Note that
 there is only one sales and notes page since it is not year dependant.}

Procedure SetSalesInventoryTabsForParcel(ParcelTabSet : TTabSet;
                                         TabTypeList : TStringList;
                                         LookupTable : TTable;
                                         SwisSBLKey : String;
                                         SalesNumber : Integer;
                                         ResidentialSite,
                                         CommercialSite,
                                         CommBuildingNo,
                                         CommBuildingSection,
                                         NumResSites,
                                         NumComSites : PProcessingTypeArray);
{Figure out what sales inventory tabs apply to this new parcel. We will only check the inventory tables.
 Note that the inventory we are looking for is not year dependant. We will look up based on the
 sales number.}

implementation
{=============================================================================}
Procedure OpenLookupTable(LookupTable : TTable;
                          TName : String;
                          ProcessingType : Integer);

{This is a special open because the lookup table to determine if tabs exist
 for each page is one shared table - LookupTable. So each time before a lookup,
 we close the table, set it to the table name of the table for this page,
 change the name for the tax year and finally open it up.}

var
  Quit : Boolean;

begin
    {CHG05011998-2: Add bldg permits.}

  If (TName = PermitsTableName)
    then
      begin
        LookupTable.Close;
        LookupTable.IndexName := '';
        LookupTable.DatabaseName := 'BldgDept';
        LookupTable.TableName := TName;

        LookupTable.Open;
      end
    else
      begin
        If (ANSIUpperCase(LookupTable.DatabaseName) <> 'PASSYSTEM')
          then LookupTable.Close;

        LookupTable.IndexName := '';
        OpenTableForProcessingType(LookupTable, TName,
                                   ProcessingType, Quit);

      end;  {else of If (TName = PermitsTableName)}

end;  {OpenLookupTable}

{===============================================================}
Procedure SetInventoryIndex(Table : TTable;
                            ProcessingType : Integer);

begin
  If (ProcessingType = SalesInventory)
    then Table.IndexName := 'BYSWISSBLKEY_SALESNUMBER'
    else Table.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
end;

{================================================================}
Function FoundInventoryForSite(LookupTable : TTable;
                               ProcessingType : Integer;
                               TaxRollYr : String;
                               SwisSBLKey : String;
                               SalesNumber : Integer;
                               Site : Integer) : Boolean;

var
  Done, FoundIt, FirstTimeThrough : Boolean;

begin
  SetInventoryIndex(LookupTable, ProcessingType);
  case ProcessingType of
    SalesInventory :
      begin
        FindNearestOld(LookupTable, ['SwisSBLKey', 'SalesNumber', 'Site'],
                       [SwisSBLKey, IntToStr(SalesNumber), IntToStr(Site)]);
        Result := ((Take(26, LookupTable.FieldByName('SwisSBLKey').Text) = Take(26, SwisSBLKey)) and
                   (LookupTable.FieldByName('Site').AsInteger = Site) and
                   (LookupTable.FieldByName('SalesNumber').AsInteger = SalesNumber));
      end;

    else
      begin
          {FXX05072002-4: Not setting the tabs correctly for multiple sites.}

        SetRangeOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                    [TaxRollYr, SwisSBLKey],
                    [TaxRollYr, SwisSBLKey]);

        Done := False;
        FirstTimeThrough := True;
        FoundIt := False;

        LookupTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else LookupTable.Next;

          If (LookupTable.EOF or
              FoundIt)
            then Done := True;

          If not Done
            then FoundIt := (LookupTable.FieldByName('Site').AsInteger = Site);

        until Done;

        Result := FoundIt;

      end;  {any other processing type}

  end;  {case ProcessingType of}

end;  {FoundInventoryForSite}

{================================================================}
Function DetermineTabOrder(TabName : String) : Integer;

{Look through the predefined TabOrder in the constants section above and
 look for this Tab name. This is useful to know since the order of the Tabs
 in the Tab list is the order that they will appear on the screen from left
 to right.}

var
  I : Integer;

begin
  Result := 0;
  For I := 1 to MaxNumPages do
    If (TabOrder[I] = TabName)
      then Result := I;

end;  {DetermineTabOrder}

{================================================================}
Function DetermineTabPos(ParcelTabs : TStrings;
                         TabName : String;
                         TabOffset : Integer) : Integer;

{Figure out where in the present Tab list we should put the new Tab.
 The order is determined by this Tabs name in the TabOrder array defined
 in the constants above.}

var
  I, NewTabPos, ThisTabPos : Integer;

begin
  NewTabPos := -1;
  ThisTabPos := DetermineTabOrder(TabName);  {Where in the list or predefined
                                             Tab names is this Tab name?}

  If GlblInterleaveTabs
    then TabOffset := 0;

    {Now we will go through the list of already existing Tabs and look for a
     Tab with a higher position number than the new Tab that we are looking to
     insert. This is the postion that we want to insert the new Tab.}

  If (TabOffset = (ParcelTabs.Count - 1))
    then NewTabPos := TabOffset + 1
    else
      For I := TabOffset to (ParcelTabs.Count - 1) do
        If GlblInterleaveTabs
          then
            begin
              If ((DetermineTabOrder(ParcelTabs[I]) - TabOffset) <= ThisTabPos)
                then NewTabPos := I + 1;
            end
          else
            If ((DetermineTabOrder(ParcelTabs[I]) - TabOffset) < ThisTabPos)
              then NewTabPos := I + 1;

    {If we could not find a Tab in the list of Tabs already on the screen
     with a greater position number than the new Tab, then we want to put
     the new Tab at the end of the list, i.e. Tabs.Count.}

  If (NewTabPos = -1)
    then NewTabPos := ParcelTabs.Count;

  DetermineTabPos := NewTabPos;

end;  {DetermineTabPos}

{===================================================================}
Function DetermineNumSites(InventorySiteTable : TTable) : Integer;

{Given a residential or commercial site table with the range set, how many sites are there?}

var
  Done : Boolean;

begin
  Result := 1;
  Done := False;
  InventorySiteTable.First;

  repeat
    InventorySiteTable.Next;

    If InventorySiteTable.EOF
      then Done := True
      else Result := Result + 1;

  until Done;

end;  {DetermineNumSites}

{========================================================================================}
Procedure DeleteInventoryTabsForProcessingType(ParcelTabSet : TTabSet;
                                               TabTypeList : TStringList;
                                               ProcessingType : Integer;
                                               InventoryType : Char;
                                               DeleteSiteTab : Boolean);  {'C' = commercial, 'R' = residential}

{Look through the tabs and delete the inventory tabs related to this processing and inventory type,
 i.e. all commercial inventory tabs for this year. Note that there is a boolean as to wot delete the site tab since
 this procedure is called when the site changes, implying that the site tab is still there.}

var
  I, Count : Integer;

begin
  Count := ParcelTabSet.Tabs.Count;

  For I := (Count - 1) downto 0 do
    If ((TabTypeList[I] = ConvertProcessingTypeToChar(ProcessingType)) and  {Is this tab the processing type we want?}
        (((InventoryType = 'C') and  {If we want commercial tabs, is this a commercial inv. tab?}
          (Take(3, ParcelTabSet.Tabs[I]) = 'Com')) or
         ((InventoryType = 'R') and  {If we want residential tabs, is this a residential inv. tab?}
          (Take(3, ParcelTabSet.Tabs[I]) = 'Res'))) and
        ((not DeleteSiteTab) and
         (ParcelTabSet.Tabs[I] <> ResidentialSiteTabName)) and  {However, don't delete the residential site tab}
        ((not DeleteSiteTab) and
         (ParcelTabSet.Tabs[I] <> CommercialSiteTabName)))      {or the commercial site tab, unless we want to.}
      then
        begin
          TabTypeList.Delete(I);
          ParcelTabSet.Tabs.Delete(I);

        end;  {If (TabTypeList[I] = ConvertProcessingTypeToChar(ProcessingType))}

end;  {DeleteInventoryTabsForProcessingType}

{=============================================================}
Procedure SetCommercialInventoryTabsForSite(ParcelTabSet : TTabSet;
                                            TabTypeList : TStringList;
                                            LookupTable : TTable;
                                            TaxRollYear : String;
                                            SwisSBLKey : String;
                                            ProcessingType,
                                            Site,
                                            SalesNumber : Integer;  {Only used for sales inventory processing type.}
                                            CommBuildingNo,
                                            CommBuildingSection : PProcessingTypeArray);

{Figure out what tabs exist for this site and add them to the parcel tab set and the corresponding
 tab type list which tells us what processing type each tab is.}

var
  TabOffset, NewTabPos : Integer;
  FoundRec : Boolean;

begin
  If (ConvertProcessingTypeToChar(ProcessingType) = GlblTaxYearFlg)
    then Taboffset := 0
    else TabOffset := TabTypeList.Count - 1;

    {Now add the Commercial building tab.}

  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, CommercialBldgTabName, TabOffset);
  ParcelTabset.Tabs.Insert(NewTabPos, CommercialBldgTabName);
  TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

  CommBuildingNo^[ProcessingType] := 0;
  CommBuildingSection^[ProcessingType] := 0;

    {Check for Commercial Improvements records.}

  OpenLookupTable(LookupTable, CommercialImprovementsTableName, ProcessingType);
  LookupTable.IndexName := 'BYTAXROLLYR_SBL_SITE_IMPNO';
  FoundRec := FoundInventoryForSite(LookupTable, ProcessingType,
                                    TaxRollYear, SwisSBLKey,
                                    SalesNumber, Site);

    {If we found a Commercial Improvements, then add a tab.}

  If FoundRec
    then
      begin
        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, CommercialImprovementsTabName, TabOffset);
        ParcelTabset.Tabs.Insert(NewTabPos, CommercialImprovementsTabName);
        TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

      end;  {If (ParcelTabset.Tabs.IndexOf(CommercialImprovementsTabName) = -1)}

    {Check for Commercial Land records.}

  OpenLookupTable(LookupTable, CommercialLandTableName, ProcessingType);
  LookupTable.IndexName := 'BYTAXROLLYR_SBL_SITE_LANDNUM';
  FoundRec := FoundInventoryForSite(LookupTable, ProcessingType,
                                    TaxRollYear, SwisSBLKey,
                                    SalesNumber, Site);

    {If we found a Commercial Land, then add a tab.}

  If FoundRec
    then
      begin
        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, CommercialLandTabName, TabOffset);
        ParcelTabset.Tabs.Insert(NewTabPos, CommercialLandTabName);
        TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

      end;  {If (ParcelTabset.Tabs.IndexOf(CommercialLandTabName) = -1)}

    {Check for commercial rent records.}

  OpenLookupTable(LookupTable, CommercialRentTableName, ProcessingType);
  LookupTable.IndexName := 'BYTAXROLLYR_SBL_SITE_USE';
  FoundRec := FoundInventoryForSite(LookupTable, ProcessingType,
                                    TaxRollYear, SwisSBLKey,
                                    SalesNumber, Site);

    {If we found a Commercial Rent, then add a tab.}

  If FoundRec
    then
      begin
        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, CommercialRentTabName, TabOffset);
        ParcelTabset.Tabs.Insert(NewTabPos, CommercialRentTabName);
        TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

      end;  {If (ParcelTabset.Tabs.IndexOf(CommercialRentTabName) = -1)}

    {Look for commercial income expense records.}

  OpenLookupTable(LookupTable, CommercialIncomeExpenseTableName, ProcessingType);
  LookupTable.IndexName := 'BYTAXROLLYR_SBL_SITE';
  FoundRec := FoundInventoryForSite(LookupTable, ProcessingType,
                                    TaxRollYear, SwisSBLKey,
                                    SalesNumber, Site);

  If FoundRec
    then
      begin
        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, CommercialIncomeExpenseTabName,
                                     TabOffset);
        ParcelTabset.Tabs.Insert(NewTabPos, CommercialIncomeExpenseTabName);
        TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

      end;  {If (ParcelTabset.Tabs.IndexOf(CommercialIncomeExpenseTabName) = -1)}

end;  {SetCommercialInventoryTabsForSite}

{=============================================================}
Procedure SetResidentialInventoryTabsForSite(ParcelTabSet : TTabSet;
                                             TabTypeList : TStringList;
                                             LookupTable : TTable;
                                             TaxRollYear : String;
                                             SwisSBLKey : String;
                                             ProcessingType,
                                             Site,
                                             SalesNumber : Integer);  {Only used for sales inventory processing type.}

{Figure out what tabs exist for this site and add them to the parcel tab set and the corresponding
 tab type list which tells us what processing type each tab is.}

var
  TabOffset, NewTabPos : Integer;
  FoundRec : Boolean;

begin
  If (ConvertProcessingTypeToChar(ProcessingType) = GlblTaxYearFlg)
    then Taboffset := 0
    else TabOffset := TabTypeList.Count - 1;

    {Now add the residential building tab.}

  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ResidentialBldgTabName, TabOffset);
  ParcelTabset.Tabs.Insert(NewTabPos, ResidentialBldgTabName);
  TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

    {Check for Residential Improvements records.}

  OpenLookupTable(LookupTable, ResidentialImprovementsTableName, ProcessingType);
  LookupTable.IndexName := 'BYTAXROLLYR_SBL_SITE_IMPNO';
  FoundRec := FoundInventoryForSite(LookupTable, ProcessingType,
                                    TaxRollYear, SwisSBLKey,
                                    SalesNumber, Site);

    {If we found a residential Improvements, then add a tab.}

  If FoundRec
    then
      begin
        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ResidentialImprovementsTabName, TabOffset);
        ParcelTabset.Tabs.Insert(NewTabPos, ResidentialImprovementsTabName);
        TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

      end;  {If (ParcelTabset.Tabs.IndexOf(ResidentialImprovementsTabName) = -1)}

    {Check for Residential Land records.}

  OpenLookupTable(LookupTable, ResidentialLandTableName, ProcessingType);
  LookupTable.IndexName := 'BYTAXROLLYR_SBL_SITE_LANDNUM';
  FoundRec := FoundInventoryForSite(LookupTable, ProcessingType,
                                    TaxRollYear, SwisSBLKey,
                                    SalesNumber, Site);

    {If we found a residential Land, then add a tab.}

  If FoundRec
    then
      begin
        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ResidentialLandTabName, TabOffset);
        ParcelTabset.Tabs.Insert(NewTabPos, ResidentialLandTabName);
        TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

      end;  {If (ParcelTabset.Tabs.IndexOf(ResidentialLandTabName) = -1)}

    {Check for Residential Forest records.}
  OpenLookupTable(LookupTable, ResidentialForestTableName, ProcessingType);
  LookupTable.IndexName := 'BYTAXROLLYR_SBL_SITE_FOREST';
  FoundRec := FoundInventoryForSite(LookupTable, ProcessingType,
                                    TaxRollYear, SwisSBLKey,
                                    SalesNumber, Site);

    {If we found a residential Forest, then add a tab.}

  If FoundRec
    then
      begin
        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ResidentialForestTabName, TabOffset);
        ParcelTabset.Tabs.Insert(NewTabPos, ResidentialForestTabName);
        TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

      end;  {If (ParcelTabset.Tabs.IndexOf(ResidentialForestTabName) = -1)}

end;  {SetResidentialInventoryTabsForSite}

{===============================================================}
Procedure AddExemptionDenialTab(LookupTable : TTable;
                                ParcelTabset : TTabSet;
                                ProcessingType : Integer;
                                TabOffset : Integer;
                                TabTypeList : TStringList;
                                TaxRollYear : String;
                                SwisSBLKey : String);

var
  NewTabPos : Integer;
  FoundRec : Boolean;

begin
  OpenLookupTable(LookupTable, ExemptionsDenialTableName, ProcessingType);
  LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  FoundRec := FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                         [TaxRollYear, SwisSBLKey]);

  If FoundRec
    then
      If (ParcelTabset.Tabs.IndexOf(ExemptionsDenialTabName) = -1)
        then
          begin
            NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ExemptionsDenialTabName, TabOffset);
            ParcelTabset.Tabs.Insert(NewTabPos, ExemptionsDenialTabName);
            TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

          end;  {If (ParcelTabset.Tabs.IndexOf(ExemptionsDenialTabName) = -1)}

end;  {AddExemptionDenialTab}

{===============================================================}
Procedure AddExemptionRemovalTab(LookupTable : TTable;
                                 ParcelTabset : TTabSet;
                                 ProcessingType : Integer;
                                 TabOffset : Integer;
                                 TabTypeList : TStringList;
                                 TaxRollYear : String;
                                 SwisSBLKey : String);

var
  NewTabPos : Integer;
  FoundRec : Boolean;

begin
  OpenLookupTable(LookupTable, ExemptionsRemovedTableName, ProcessingType);
  LookupTable.IndexName := 'BYSWISSBLKEY';
  FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'],
                         [SwisSBLKey]);

  If FoundRec
    then
      If (ParcelTabset.Tabs.IndexOf(ExemptionsRemovedTabName) = -1)
        then
          begin
            NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ExemptionsRemovedTabName, TabOffset);
            ParcelTabset.Tabs.Insert(NewTabPos, ExemptionsRemovedTabName);
            TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

          end;  {If (ParcelTabset.Tabs.IndexOf(ExemptionsDenialTabName) = -1)}

end;  {AddExemptionRemovalTab}

{===============================================================}
Procedure AddExemptionTab(LookupTable : TTable;
                          ParcelTabset : TTabSet;
                          ProcessingType : Integer;
                          TabOffset : Integer;
                          TabTypeList : TStringList;
                          TaxRollYear : String;
                          SwisSBLKey : String);

var
  NewTabPos : Integer;
  FoundRec : Boolean;

begin
  OpenLookupTable(LookupTable, ExemptionsTableName, ProcessingType);
  LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  LookupTable.CancelRange;
  FindNearestOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                 [TaxRollYear, SwisSBLKey]);

  FoundRec := ((TaxRollYear = LookupTable.FieldByName('TaxRollYr').Text) and
               (Take(26, SwisSBLKey) = Take(26, LookupTable.FieldByName('SwisSBLKey').Text)));

  If FoundRec
    then
      If (ParcelTabset.Tabs.IndexOf(ExemptionsTabName) = -1)
        then
          begin
            NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ExemptionsTabName, TabOffset);
            ParcelTabset.Tabs.Insert(NewTabPos, ExemptionsTabName);
            TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

          end;  {If (ParcelTabset.Tabs.IndexOf(ExemptionsTabName) = -1)}

end;  {AddExemptionRemovalTab}

{=============================================================}
Procedure SetMainTabsForParcel(    ParcelTabSet : TTabSet;
                                   TabTypeList : TStringList;
                                   LookupTable : TTable;
                                   SwisSBLKey : String;
                                   TaxRollYear : String;
                               var SalesNumber : Integer;
                                   ResidentialSite,
                                   CommercialSite,
                                   CommBuildingNo,
                                   CommBuildingSection,
                                   NumResSites,
                                   NumComSites : PProcessingTypeArray;
                                   ParcelExists : Boolean);
{Figure out what tabs apply to this new parcel. Set the main tabs up for this parcel. The main tabs
 will be the leftmost and apply to the GlblTaxYear that they are processing in only.}

var
  ProcessingType, TabOffset, NewTabPos, I : Integer;
  Continue, FoundRec : Boolean;
  TempSBL, sTempSwisSBL, sPrintKey : String;
  ADOQuery : TADOQuery;

begin
  TabOffset := 0;
  ProcessingType := DetermineProcessingType(GlblTaxYearFlg);

    {Initialize the page place holder variables (site, sale number, etc.) to null.}

  For I := 1 to 4 do
    begin
      ResidentialSite^[I] := 0;
      CommercialSite^[I] := 0;
      CommBuildingNo^[I] := 0;
      CommBuildingSection^[I] := 0;
      NumResSites^[I] := 0;
      NumComSites^[I] := 0;

    end; {For I := 1 to 4 do}

  SalesNumber := 0;
  ParcelTabset.Tabs.Clear;  {Empty the tab list.}
  TabTypeList.Clear;  {Empty the tab processing type list ('N', 'T', 'H', 'S').}

    {First let's add the pages that we know will always be there.
     This includes assessment since there is only one assessment
     record per year, it will always be there.
     Also, we will always have a summary screen.}

    {CHG12172002-1: It is not necessarily an error if the parcel is not found -
                    it could be a cert or grievance on a parcel that no
                    longer exists.}

  If ParcelExists
    then
      begin
        ParcelTabset.Tabs.Insert(DetermineTabPos(ParcelTabset.Tabs, SummaryTabName, TabOffset),
                                 SummaryTabName);
        ParcelTabset.Tabs.Insert(DetermineTabPos(ParcelTabset.Tabs, BaseParcelPg1TabName, TabOffset),
                                 BaseParcelPg1TabName);
        ParcelTabset.Tabs.Insert(DetermineTabPos(ParcelTabset.Tabs, BaseParcelPg2TabName, TabOffset),
                                 BaseParcelPg2TabName);
        ParcelTabset.Tabs.Insert(DetermineTabPos(ParcelTabset.Tabs, AssessmentTabName, TabOffset),
                                 AssessmentTabName);

          {Add in the type for the base pages and the assessment page.
           Since there is only one assessment record per year, it will
           always be there.}

        TabTypeList.Add(GlblTaxYearFlg);
        TabTypeList.Add(GlblTaxYearFlg);
        TabTypeList.Add(GlblTaxYearFlg);
        TabTypeList.Add(GlblTaxYearFlg);

        If glblUsesTaxBillNameAddr
        then
        begin
          ParcelTabset.Tabs.Insert(DetermineTabPos(ParcelTabset.Tabs, TaxBillAddressTabName, TabOffset),
                                   TaxBillAddressTabName);
          TabTypeList.Add(GlblTaxYearFlg);
        end;

      end;  {If ParcelExists}

    {Check For Class Record(s).}

  OpenLookupTable(LookupTable, ClassTableName, ProcessingType);
  LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  FoundRec := FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                         [TaxRollYear, SwisSBLKey]);

  If FoundRec
    then
      If (ParcelTabset.Tabs.IndexOf(ClassTabName) = -1)
        then
          begin
            NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ClassTabName, TabOffset);
            ParcelTabset.Tabs.Insert(NewTabPos, ClassTabName);
            TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

          end;  {If (ParcelTabset.Tabs.IndexOf(AssessmentTabName) = -1)}

    {Check For Sales Record(s). Note that we will not assume any sales number until they
     actually go to a sales page since the sales record shown is the last in the range,
     i.e. the most recent. See SynchronizePages in ParcelTabForm for more info. on how this
     is done.}

  OpenLookupTable(LookupTable, SalesTableName, ProcessingType);
  LookupTable.IndexName := 'BYSWISSBLKEY';
  FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'],
                         [SwisSBLKey]);

  If FoundRec
    then
      If (ParcelTabset.Tabs.IndexOf(SalesTabName) = -1)
        then
          begin
            NewTabPos := DetermineTabPos(ParcelTabset.Tabs, SalesTabName, TabOffset);
            ParcelTabset.Tabs.Insert(NewTabPos, SalesTabName);
            TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

          end;  {If (ParcelTabset.Tabs.IndexOf(AssessmentTabName) = -1)}

     {Check For User Data Record(s).}

  OpenLookupTable(LookupTable, UserDataTableName, ProcessingType);
  LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  FoundRec := FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                         [TaxRollYear, SwisSBLKey]);

  If FoundRec
    then
      If (ParcelTabset.Tabs.IndexOf(UserDataTabName) = -1)
        then
          begin
            NewTabPos := DetermineTabPos(ParcelTabset.Tabs, UserDataTabName, TabOffset);
            ParcelTabset.Tabs.Insert(NewTabPos, UserDataTabName);
            TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

          end;  {If (ParcelTabset.Tabs.IndexOf(AssessmentTabName) = -1)}

     {Check For Picture Record(s).}

  OpenLookupTable(LookupTable, PictureTableName, ProcessingType);
  LookupTable.IndexName := 'BYSWISSBLKEY';
  FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'], [SwisSBLKey]);

  If FoundRec
    then
      If (ParcelTabset.Tabs.IndexOf(PictureTabName) = -1)
        then
          begin
            NewTabPos := DetermineTabPos(ParcelTabset.Tabs, PictureTabName, TabOffset);
            ParcelTabset.Tabs.Insert(NewTabPos, PictureTabName);
            TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

          end;  {If (ParcelTabset.Tabs.IndexOf(AssessmentTabName) = -1)}

  If GlblUsesSketches
    then
      begin
        OpenLookupTable(LookupTable, SketchTableName, ProcessingType);
        LookupTable.IndexName := 'BYSWISSBLKEY';
        FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'], [SwisSBLKey]);

        If FoundRec
          then
            If (ParcelTabset.Tabs.IndexOf(SketchTabName) = -1)
              then
                begin
                  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, SketchTabName, TabOffset);
                  ParcelTabset.Tabs.Insert(NewTabPos, SketchTabName);
                  TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                end;  {If (ParcelTabset.Tabs.IndexOf(AssessmentTabName) = -1)}

      end;  {If GlblUsesSketches}

    {Check For Document Record(s).}

  OpenLookupTable(LookupTable, DocumentTableName, ProcessingType);
  LookupTable.IndexName := 'BYSWISSBLKEY';
  FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'], [SwisSBLKey]);

  If FoundRec
    then
      If (ParcelTabset.Tabs.IndexOf(DocumentTabName) = -1)
        then
          begin
            NewTabPos := DetermineTabPos(ParcelTabset.Tabs, DocumentTabName, TabOffset);
            ParcelTabset.Tabs.Insert(NewTabPos, DocumentTabName);
            TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

          end;  {If (ParcelTabset.Tabs.IndexOf(AssessmentTabName) = -1)}

    {Agriculture}

  OpenLookupTable(LookupTable, AgricultureTableName, ProcessingType);
  LookupTable.IndexName := 'BYTaxRollYr_SWISSBLKEY';
  FoundRec := FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'], [TaxRollYear, SwisSBLKey]);

  If FoundRec
    then
      If (ParcelTabset.Tabs.IndexOf(AgricultureTabName) = -1)
        then
          begin
            NewTabPos := DetermineTabPos(ParcelTabset.Tabs, AgricultureTabName, TabOffset);
            ParcelTabset.Tabs.Insert(NewTabPos, AgricultureTabName);
            TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

          end;  {If (ParcelTabset.Tabs.IndexOf(AssessmentTabName) = -1)}


    {Check For Property Cards.}
    {CHG07312006-1(2.10.1.1): Add a property card tab.}

  OpenLookupTable(LookupTable, PropertyCardTableName, ProcessingType);
  LookupTable.IndexName := 'BYSWISSBLKEY';
  FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'], [SwisSBLKey]);

  If FoundRec
    then
      If (ParcelTabset.Tabs.IndexOf(PropertyCardTabName) = -1)
        then
          begin
            NewTabPos := DetermineTabPos(ParcelTabset.Tabs, PropertyCardTabName, TabOffset);
            ParcelTabset.Tabs.Insert(NewTabPos, PropertyCardTabName);
            TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

          end;  {If (ParcelTabset.Tabs.IndexOf(DocumentTabName) = -1)}

    {Check for notes records.}

     {notes records span years so no TaxRollYr}

    {FXX11191997-1: Don't let the searcher see notes.}
    {CHG10232002-2: Don't allow cert only users to see notes or exemptions
                    removed or denied.}

  If (not (GlblUserIsSearcher or GlblCertiorariOnly))
    then
      begin
        OpenLookupTable(LookupTable, NotesTableName, ProcessingType);

        LookupTable.IndexDefs.Update;
        If _Compare(LookupTable.IndexDefs.Count, 0, coEqual)
          then
            begin
              _SetFilter(LookupTable, 'SwisSBLKey = ' + FormatFilterString(SwisSBLKey));
              LookupTable.First;
              FoundRec := not LookupTable.EOF;
            end
          else
            begin
              LookupTable.IndexName := 'BYSWISSBLKEY';
              FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'], [SwisSBLKey]);
            end;

        If FoundRec
          then
            If (ParcelTabset.Tabs.IndexOf(NotesTabName) = -1)
              then
                begin
                  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, NotesTabName, TabOffset);
                  ParcelTabset.Tabs.Insert(NewTabPos, NotesTabName);
                  TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                end;  {If (ParcelTabset.Tabs.IndexOf(NotesTabName) = -1)}

      end;  {If not GlblUserIsSearcher}

    {Check for SD records.}

  OpenLookupTable(LookupTable, SpecialDistrictTableName, ProcessingType);
  LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  FoundRec := FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                         [TaxRollYear, SwisSBLKey]);

  If FoundRec
    then
      If (ParcelTabset.Tabs.IndexOf(SpecialDistrictTabName) = -1)
        then
          begin
            NewTabPos := DetermineTabPos(ParcelTabset.Tabs, SpecialDistrictTabName, TabOffset);
            ParcelTabset.Tabs.Insert(NewTabPos, SpecialDistrictTabName);
            TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

          end;  {If (ParcelTabset.Tabs.IndexOf(SpecialDistrictTabName) = -1)}

    {Check for exemption records.}

  AddExemptionTab(LookupTable, ParcelTabset, ProcessingType,
                  TabOffset, TabTypeList, TaxRollYear, SwisSBLKey);

    {CHG08021999-3: Add exemptions denial page.}
    {CHG01182000-1: Option to not have searcher see exemption denials.}

  If (((not GlblUserIsSearcher) or
       (GlblUserIsSearcher and
        GlblSearcherViewsDenials)) and
      (not GlblCertiorariOnly))
    then AddExemptionDenialTab(LookupTable, ParcelTabset, ProcessingType,
                               TabOffset, TabTypeList, TaxRollYear, SwisSBLKey);

    {CHG08021999-3: Add exemptions removed page - do not let
                    the searcher see it.}

  If (GlblRecordRemovedExemptions and
      (not GlblUserIsSearcher) and
      (not GlblCertiorariOnly))
    then AddExemptionRemovalTab(LookupTable, ParcelTabset, ProcessingType,
                                TabOffset, TabTypeList, TaxRollYear, SwisSBLKey);

    {Check for permit records.}

    {CHG01302002-2: Change building permit link to allow link to all systems.}

  case GlblBuildingSystemLinkType of
    bldBTrieve :
      begin
(*        TitanLookupTable := TTbTable.Create(nil);
        with TitanLookupTable do
          try
            DatabaseName := 'BldgDept';
            TableName := PermitsTableName;
            IndexName := '12 - SBLSecondaryKey';
            IndexFieldNames := 'SBLSecondaryKey';
            Open;
          except
            MessageDlg('Error opening permits table.', mtError, [mbOK], 0);
          end;

        TitanLookupTable.FindNearest([SwisSBLKey]);

        FoundRec := (TitanLookupTable.FieldByName('SBLSecondaryKey').Text = SwisSBLKey);

        If FoundRec
          then
            If (ParcelTabset.Tabs.IndexOf(PermitsTabName) = -1)
              then
                begin
                  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, PermitsTabName, TabOffset);
                  ParcelTabset.Tabs.Insert(NewTabPos, PermitsTabName);
                  TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                end;  {If (ParcelTabset.Tabs.IndexOf(PermitsTabName) = -1)}

        TitanLookupTable.Close;
        TitanLookupTable.Free; *)

      end;  {bldBTrieve}

    bldSmallBuilding :
      begin
        Continue := True;

        with LookupTable do
          try
            Close;
            DatabaseName := GlblBuildingSystemDatabaseName;
            TableName := GlblBuildingSystemTableName;
            IndexName := GlblBuildingSystemIndexName;
            Open;
          except
            Continue := False;
          end;

        If Continue
          then
            begin
              FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'],
                                     [SwisSBLKey]);

              If FoundRec
                then
                  If (ParcelTabset.Tabs.IndexOf(PermitsTabName) = -1)
                    then
                      begin
                        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, PermitsTabName, TabOffset);
                        ParcelTabset.Tabs.Insert(NewTabPos, PermitsTabName);
                        TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                      end;  {If (ParcelTabset.Tabs.IndexOf(ThirdPartyNotificationTabName) = -1)}

            end;  {If Continue}

      end;  {bldSmallBuilding}

    bldLargeBuilding :
      begin
        Continue := True;

        with LookupTable do
          try
            Close;
            DatabaseName := GlblBuildingSystemDatabaseName;
            TableName := GlblBuildingSystemTableName;
            IndexName := GlblBuildingSystemIndexName;
            Open;
          except
            Continue := False;
          end;

        If Continue
          then
            begin
                {FXX04262004-1(2.07l3): Convert back and forth between PAS and building in Glen Cove
                                        due to incompatibilities in the format.}

              If GlblUseGlenCoveFormatForCodeEnforcement
                then TempSBL := ConvertFrom_PAS_To_GlenCoveTax_Building_SBL(Copy(SwisSBLKey, 7, 20))
                else TempSBL := Copy(SwisSBLKey, 7, 20);

              FoundRec := FindKeyOld(LookupTable, ['SwisCode', 'SBL'],
                                     [Copy(SwisSBLKey, 1, 6), TempSBL]);

              If FoundRec
                then
                  If (ParcelTabset.Tabs.IndexOf(PermitsTabName) = -1)
                    then
                      begin
                        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, PermitsTabName, TabOffset);
                        ParcelTabset.Tabs.Insert(NewTabPos, PermitsTabName);
                        TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                      end;  {If (ParcelTabset.Tabs.IndexOf(ThirdPartyNotificationTabName) = -1)}

            end;  {If Continue}

      end;  {bldLargeBuilding}

      {CHG05162007(2.28.2.1): Add PAS <-> Municity link.}

    bldMunicity :
      If GlblUserCanViewPermits
        then
      begin
        ADOQuery := nil;
        
        try
          ADOQuery := TADOQuery.Create(nil);

          with ADOQuery do
            begin
              ConnectionString := 'FILE NAME=' + GlblDrive + ':' + GlblProgramDir + 'pasMunicity.udl';

                {FXX05162010(2.24.2.4)[I7347]: For Glen Cove, translate SBL to Glen Cove format.}

              If GlblUseGlenCoveFormatForCodeEnforcement
                then sTempSwisSBL := Copy(SwisSBLKey, 1, 6) +
                                     ConvertFrom_PAS_To_GlenCoveTax_Building_SBL(Copy(SwisSBLKey, 7, 20))
                else sTempSwisSBL := SwisSBLKey;

              sPrintKey := ConvertSwisSBLToDashDot(sTempSwisSBL);

              with SQL do begin
                Clear;
                Add('SELECT Parcels.SwisSBLKey, Parcels.Parcel_ID, ParcelPermitMap.Parcel_ID');
                Add('FROM Parcels');
                Add(' INNER JOIN ParcelPermitMap ON');
                Add('   Parcels.Parcel_ID = ParcelPermitMap.Parcel_ID');
                Add('WHERE ((Parcels.SwisSBLKey = ' + FormatSQLString(sTempSwisSBL) + ') or');
                Add('       (Parcels.PrintKey = ' + FormatSQLString(sPrintKey) + '))');

              end; {with SQL do begin}

              try
                Open;
              except
                Close;
              end;

            end;  {with ADOQuery do}

        If (ADOQuery.Active and
            _Compare(ADOQuery.RecordCount, 0, coGreaterThan))
          then
            If (ParcelTabset.Tabs.IndexOf(PermitsTabName) = -1)
              then
                begin
                  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, PermitsTabName, TabOffset);
                  ParcelTabset.Tabs.Insert(NewTabPos, PermitsTabName);
                  TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                end;  {If _Compare(ADOQuery.RecordCount, 0, coGreaterThan)}
        finally
          ADOQuery.Free;
        end;

          end;  {If GlblUserCanViewPermits}

  end;  {case GlblBuildingSystemLinkType of}

    {ThirdPartyNotification records span years so no TaxRollYr}

  If not GlblUserIsSearcher
    then
      begin
        OpenLookupTable(LookupTable, ThirdPartyNotificationTableName, ProcessingType);
        LookupTable.IndexName := 'BYSWISSBLKEY';
        FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'], [SwisSBLKey]);

        If FoundRec
          then
            If (ParcelTabset.Tabs.IndexOf(ThirdPartyNotificationTabName) = -1)
              then
                begin
                  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ThirdPartyNotificationTabName, TabOffset);
                  ParcelTabset.Tabs.Insert(NewTabPos, ThirdPartyNotificationTabName);
                  TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                end;  {If (ParcelTabset.Tabs.IndexOf(ThirdPartyNotificationTabName) = -1)}

      end;  {If not GlblUserIsSearcher}

    {CHG07272005-1(2.9.2.1): Additional owners.}

  If not GlblUserIsSearcher
    then
      with LookupTable do
        try
          Close;
          TableName := AdditionalOwnersTableName;
          Open;

          LookupTable.IndexName := 'BYSWISSBLKEY';
          FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'], [SwisSBLKey]);

          If FoundRec
            then
              If (ParcelTabset.Tabs.IndexOf(AdditionalOwnersTabName) = -1)
                then
                  begin
                    NewTabPos := DetermineTabPos(ParcelTabset.Tabs, AdditionalOwnersTabName, TabOffset);
                    ParcelTabset.Tabs.Insert(NewTabPos, AdditionalOwnersTabName);
                    TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                  end;  {If (ParcelTabset.Tabs.IndexOf(AdditionalOwnersTabName) = -1)}

        except
        end;

    {CHG05312005-1(2.8.4.6): Add prorata tabs.}

  If (GlblUsesProrata and
      (not GlblUserIsSearcher))
    then
      begin
        OpenLookupTable(LookupTable, ProrataHeaderTableName, NoProcessingType);
        LookupTable.IndexName := 'BYSWISSBLKEY';
        FoundRec := _Locate(LookupTable, [SwisSBLKey], '', []);

        If FoundRec
          then
            If (ParcelTabset.Tabs.IndexOf(ProrataTabName) = -1)
              then
                begin
                  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ProrataTabName, TabOffset);
                  ParcelTabset.Tabs.Insert(NewTabPos, ProrataTabName);
                  TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                end;  {If (ParcelTabset.Tabs.IndexOf(ProrataTabName) = -1)}

      end;  {If not GlblUserIsSearcher}

    {Check for Grievance records.}

  If ((not GlblUserIsSearcher) and
      GlblUsesGrievances)
    then
      begin
        OpenLookupTable(LookupTable, GrievanceTableName, ProcessingType);
        LookupTable.IndexName := 'BYSWISSBLKEY';
        FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'], [SwisSBLKey]);

        If FoundRec
          then
            If (ParcelTabset.Tabs.IndexOf(GrievanceTabName) = -1)
              then
                begin
                  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, GrievanceTabName, TabOffset);
                  ParcelTabset.Tabs.Insert(NewTabPos, GrievanceTabName);
                  TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                end;  {If (ParcelTabset.Tabs.IndexOf(GrievanceTabName) = -1)}

      end;  {If not GlblUserIsSearcher}

  If ((not GlblUserIsSearcher) and
      GlblUsesGrievances)
    then
      begin
        OpenLookupTable(LookupTable, SmallClaimsTableName, ProcessingType);
        LookupTable.IndexName := 'BYSWISSBLKEY';
        FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'], [SwisSBLKey]);

        If FoundRec
          then
            If (ParcelTabset.Tabs.IndexOf(SmallClaimsTabName) = -1)
              then
                begin
                  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, SmallClaimsTabName, TabOffset);
                  ParcelTabset.Tabs.Insert(NewTabPos, SmallClaimsTabName);
                  TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                end;  {If (ParcelTabset.Tabs.IndexOf(SmallClaimsTabName) = -1)}

      end;  {If not GlblUserIsSearcher}

    {FXX12312003-1(2.07l): Make sure they are allowed to see certs before showing the cert tab.}

  If ((not GlblUserIsSearcher) and
      GlblUsesGrievances and
      GlblCanSeeCertiorari)
    then
      begin
        OpenLookupTable(LookupTable, CertiorariTableName, ProcessingType);
        LookupTable.IndexName := 'BYSWISSBLKEY';
        FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'], [SwisSBLKey]);

        If FoundRec
          then
            If (ParcelTabset.Tabs.IndexOf(CertiorariTabName) = -1)
              then
                begin
                  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, CertiorariTabName, TabOffset);
                  ParcelTabset.Tabs.Insert(NewTabPos, CertiorariTabName);
                  TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                end;  {If (ParcelTabset.Tabs.IndexOf(CertiorariTabName) = -1)}

      end;  {If not GlblUserIsSearcher}

  If GlblUsesPASPermits
    then
      begin
        OpenLookupTable(LookupTable, PASPermitsTableName, ProcessingType);
        LookupTable.IndexName := 'BYSWISSBLKEY';
        FoundRec := FindKeyOld(LookupTable, ['SwisSBLKey'], [SwisSBLKey]);

        If FoundRec
          then
            If (ParcelTabset.Tabs.IndexOf(PASPermitsTabName) = -1)
              then
                begin
                  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, PASPermitsTabName, TabOffset);
                  ParcelTabset.Tabs.Insert(NewTabPos, PASPermitsTabName);
                  TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                end;  {If (ParcelTabset.Tabs.IndexOf(PASPermitsTabName) = -1)}

      end;  {If GlblUsesPASPermits}

    {Check for ResidentialSite records.}

  If ShowInventory
    then
      begin
        OpenLookupTable(LookupTable, ResidentialSiteTableName, ProcessingType);
        SetInventoryIndex(LookupTable, ProcessingType);
        LookupTable.CancelRange;
        FindNearestOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                        [TaxRollYear, SwisSBLKey]);

        FoundRec := ((LookupTable.FieldByName('TaxRollYr').Text = TaxRollYear) and
                     (Take(26, LookupTable.FieldByName('SwisSBLKey').Text) =
                      Take(26, SwisSBLKey)));

          {If there is at least one residential site record, then we will
           set them at the first one. Otherwise, we will set ResidentialSite to
           0 so that we know that there are no residential sites yet.}

        If FoundRec
          then ResidentialSite^[ProcessingType] := LookupTable.FieldByName('Site').AsInteger;

          {If we found a residential site, then there is a residential
           building record, too.}

        If FoundRec
          then
            If (ParcelTabset.Tabs.IndexOf(ResidentialSiteTabName) = -1)
              then
                begin
                    {First add the residential site tab.}

                  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ResidentialSiteTabName, TabOffset);
                  ParcelTabset.Tabs.Insert(NewTabPos, ResidentialSiteTabName);
                  TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                    {Set the range for the residential site table and do a record count.}

                  SetRangeOld(LookupTable, ['TaxRollYr', 'SwisSBLKey', 'Site'],
                              [TaxRollYear, SwisSBLKey, '0'],
                              [TaxRollYear, SwisSBLKey, '32000']);

                  NumResSites^[ProcessingType] := DetermineNumSites(LookupTable);

                  SetResidentialInventoryTabsForSite(ParcelTabSet, TabTypeList, LookupTable,
                                                     TaxRollYear, SwisSBLKey, ProcessingType,
                                                     ResidentialSite^[ProcessingType], 0);

                end;  {If (ParcelTabset.Tabs.IndexOf(ResidentialSiteTabName) = -1)}

      end;  {If ShowInventory}

   {Check for CommercialSite records.}

  If ShowInventory
    then
      begin
        OpenLookupTable(LookupTable, CommercialSiteTableName, ProcessingType);
        SetInventoryIndex(LookupTable, ProcessingType);
        LookupTable.CancelRange;
        FindNearestOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                       [TaxRollYear, SwisSBLKey]);

        FoundRec := ((LookupTable.FieldByName('TaxRollYr').Text = TaxRollYear) and
                     (Take(26, LookupTable.FieldByName('SwisSBLKey').Text) =
                      Take(26, SwisSBLKey)));

          {If there is at least one Commercial site record, then we will
           set them at the first one. Otherwise, we will set CommercialSite to
           0 so that we know that there are no Commercial sites yet.}

        If FoundRec
          then CommercialSite^[ProcessingType] := LookupTable.FieldByName('Site').AsInteger;

          {If we found a Commercial site, then there is a Commercial
           building record and income\expense record, too.}

        If FoundRec
          then
            If (ParcelTabset.Tabs.IndexOf(CommercialSiteTabName) = -1)
              then
                begin
                    {First add the Commercial site tab.}

                  NewTabPos := DetermineTabPos(ParcelTabset.Tabs, CommercialSiteTabName, TabOffset);
                  ParcelTabset.Tabs.Insert(NewTabPos, CommercialSiteTabName);
                  TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);

                    {Set the range for the site table and do a record count.}

                  SetRangeOld(LookupTable,
                              ['TaxRollYr', 'SwisSBLKey', 'Site'],
                              [TaxRollYear, SwisSBLKey, '0'],
                              [TaxRollYear, SwisSBLKey, '32000']);

                  NumComSites^[ProcessingType] := DetermineNumSites(LookupTable);

                  SetCommercialInventoryTabsForSite(ParcelTabSet, TabTypeList, LookupTable,
                                                    TaxRollYear, SwisSBLKey,
                                                    ProcessingType, CommercialSite^[ProcessingType],
                                                    0, CommBuildingNo, CommBuildingSection);

                end;  {If (ParcelTabset.Tabs.IndexOf(CommercialSiteTabName) = -1)}

      end;  {If ShowInventory}

  If GlblUsesMaps
    then
      begin
        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, MapTabName, TabOffset);
        ParcelTabset.Tabs.Insert(NewTabPos, MapTabName);
        TabTypeList.Insert(NewTabPos, GlblTaxYearFlg);
      end;  {If GlblUsesMaps}

    {CHG10082009-1(2.20.1.1)[F1005]: Allow for split school districts.}

  If GlblDisplaySplitSchoolSBLs
    then
      begin
        OpenLookupTable(LookupTable, ParcelTableName, ProcessingType);
        LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        _Locate(LookupTable, [TaxRollYear, SwisSBLKey], '', [loParseSwisSBLKey]);

        If LookupTable.FieldByName('SplitSchoolDistrict').AsBoolean
          then
            begin
              NewTabPos := DetermineTabPos(ParcelTabset.Tabs, SplitSchoolDistrictTabName, TabOffset);
              ParcelTabset.Tabs.Insert(NewTabPos, SplitSchoolDistrictTabName);
              TabTypeList.Insert(NewTabPos, 'X');
            end;

      end;  {If GlblUsesMaps}

end;  {SetMainTabsForThisParcel}

{=============================================================}
Procedure SetOppositeYearTabsForParcel(ParcelTabSet : TTabSet;
                                       TabTypeList : TStringList;
                                       LookupTable : TTable;
                                       SwisSBLKey : String;
                                       TaxRollYear : String;
                                       ResidentialSite,
                                       CommercialSite,
                                       CommBuildingNo,
                                       CommBuildingSection,
                                       NumResSites,
                                       NumComSites : PProcessingTypeArray);

{Figure out what opposite year tabs apply to this new parcel. That is if this is next year, figure
 out what the this year tabs apply to this parcel. We will put them at the end of the tabs. Note that
 there is only one sales and notes page since it is not year dependant.}

var
  ProcessingType, TabOffset, NewTabPos, I : Integer;
  TabsAlreadyExist, FoundRec : Boolean;

begin
  TabOffset := TabTypeList.Count - 1;

    {Figure out what the opposite year tabs are.}

  case GlblTaxYearFlg of
    'T' : ProcessingType := NextYear;
    'N' : ProcessingType := ThisYear;
    else ProcessingType := ThisYear;
  end;

    {FXX03031998-1: Instead of not doing opposite year tabs if they exist,
                    delete them and redo in case there were any new
                    main year tabs added.}

    {FXX02231999-1: Don't let them open up a set of tabs again (i.e. going to
                    Show This Year 2x.}

  TabsAlreadyExist := False;

  For I := 0 to (TabTypeList.Count - 1) do
    If (DetermineProcessingType(TabTypeList[I][1]) = ProcessingType)
      then TabsAlreadyExist := True;

  If not TabsAlreadyExist
    then
      begin
          {Also, there will always be a summary screen.}

        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, SummaryTabName, TabOffset);
        ParcelTabset.Tabs.Insert(NewTabPos, SummaryTabName);
        TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

          {First let's add the pages that we know will always be there, base pages 1 and 2.}

        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, BaseParcelPg1TabName, TabOffset);
        ParcelTabset.Tabs.Insert(NewTabPos, BaseParcelPg1TabName);
        TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, BaseParcelPg2TabName, TabOffset);
        ParcelTabset.Tabs.Insert(NewTabPos, BaseParcelPg2TabName);
        TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

        {This includes assessment since there is only one assessment
         record per year, it will always be there.}

        NewTabPos := DetermineTabPos(ParcelTabset.Tabs, AssessmentTabName, TabOffset);
        ParcelTabset.Tabs.Insert(NewTabPos, AssessmentTabName);
        TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

          {Check for SD records.}

        OpenLookupTable(LookupTable, SpecialDistrictTableName, ProcessingType);
        LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        FoundRec := FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                               [TaxRollYear, SwisSBLKey]);

        If FoundRec
          then
            begin
              NewTabPos := DetermineTabPos(ParcelTabset.Tabs, SpecialDistrictTabName, TabOffset);
              ParcelTabset.Tabs.Insert(NewTabPos, SpecialDistrictTabName);
              TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

            end;  {If FoundRec}

          {FXX02272000-2: We were not checking for class records in opposite year.}
          {Check for class records.}

        OpenLookupTable(LookupTable, ClassTableName, ProcessingType);
        LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        FoundRec := FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                               [TaxRollYear, SwisSBLKey]);

        If FoundRec
          then
            begin
              NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ClassTabName, TabOffset);
              ParcelTabset.Tabs.Insert(NewTabPos, ClassTabName);
              TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

            end;  {If FoundRec}

          {Check for exemption records.}
        OpenLookupTable(LookupTable, ExemptionsTableName, ProcessingType);
        LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        FoundRec := FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                               [TaxRollYear, SwisSBLKey]);

        If FoundRec
          then
            begin
              NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ExemptionsTabName, TabOffset);
              ParcelTabset.Tabs.Insert(NewTabPos, ExemptionsTabName);
              TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

            end;  {If FoundRec}

          {CHG08021999-3: Add exemptions denial page.}

        OpenLookupTable(LookupTable, ExemptionsDenialTableName, ProcessingType);
        LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        FoundRec := FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                               [TaxRollYear, SwisSBLKey]);

        If FoundRec
          then
            begin
              NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ExemptionsDenialTabName, TabOffset);
              ParcelTabset.Tabs.Insert(NewTabPos, ExemptionsDenialTabName);
              TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

            end;  {If FoundRec}

          {Check for ResidentialSite records.}

        If ShowInventory
          then
            begin
              OpenLookupTable(LookupTable, ResidentialSiteTableName, ProcessingType);
              SetInventoryIndex(LookupTable, ProcessingType);
              LookupTable.First;
              FindNearestOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                             [TaxRollYear, SwisSBLKey]);

              FoundRec := ((LookupTable.FieldByName('TaxRollYr').Text = TaxRollYear) and
                           (Take(26, LookupTable.FieldByName('SwisSBLKey').Text) =
                            Take(26, SwisSBLKey)));

                {If there is at least one residential site record, then we will
                 set them at the first one. Otherwise, we will set ResidentialSite to
                 0 so that we know that there are no residential sites yet.}

              If FoundRec
                then ResidentialSite^[ProcessingType] := LookupTable.FieldByName('Site').AsInteger;

                {If we found a residential site, then there is a residential
                 building record, too.}

              If FoundRec
                then
                  begin
                      {First add the residential site tab.}

                    NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ResidentialSiteTabName, TabOffset);
                    ParcelTabset.Tabs.Insert(NewTabPos, ResidentialSiteTabName);
                    TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

                      {Set the range for the site table and do a record count.}

                    SetRangeOld(LookupTable,
                                ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                [TaxRollYear, SwisSBLKey, '0'],
                                [TaxRollYear, SwisSBLKey, '32000']);

                    NumResSites^[ProcessingType] := DetermineNumSites(LookupTable);

                    SetResidentialInventoryTabsForSite(ParcelTabSet, TabTypeList, LookupTable,
                                                       TaxRollYear, SwisSBLKey, ProcessingType,
                                                       ResidentialSite^[ProcessingType], 0);

                  end;  {If FoundRec}

            end;  {If ShowInventory}

         {Check for CommercialSite records.}

        If ShowInventory
          then
            begin
              OpenLookupTable(LookupTable, CommercialSiteTableName, ProcessingType);
              SetInventoryIndex(LookupTable, ProcessingType);
              LookupTable.First;
              FindNearestOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                             [TaxRollYear, SwisSBLKey]);

              FoundRec := ((LookupTable.FieldByName('TaxRollYr').Text = TaxRollYear) and
                           (Take(26, LookupTable.FieldByName('SwisSBLKey').Text) =
                            Take(26, SwisSBLKey)));

                {If there is at least one Commercial site record, then we will
                 set them at the first one. Otherwise, we will set CommercialSite to
                 0 so that we know that there are no Commercial sites yet.}

              If FoundRec
                then CommercialSite^[ProcessingType] := LookupTable.FieldByName('SIte').AsInteger;

                {If we found a Commercial site, then there is a Commercial
                 building record and income\expense record, too.}

              If FoundRec
                then
                  begin
                      {First add the Commercial site tab.}

                    NewTabPos := DetermineTabPos(ParcelTabset.Tabs, CommercialSiteTabName, TabOffset);
                    ParcelTabset.Tabs.Insert(NewTabPos, CommercialSiteTabName);
                    TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

                      {Set the range for the site table and do a record count.}

                    SetRangeOld(LookupTable,
                                ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                [TaxRollYear, SwisSBLKey, '0'],
                                [TaxRollYear, SwisSBLKey, '32000']);

                    NumComSites^[ProcessingType] := DetermineNumSites(LookupTable);

                    SetCommercialInventoryTabsForSite(ParcelTabSet, TabTypeList, LookupTable,
                                                      TaxRollYear, SwisSBLKey,
                                                      ProcessingType, CommercialSite^[ProcessingType],
                                                      0, CommBuildingNo, CommBuildingSection);

                  end;  {If FoundRec}

            end;  {If ShowInventory}

         {Check for User records.}

        OpenLookupTable(LookupTable, UserDataTableName, ProcessingType);
        LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        FoundRec := FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                               [TaxRollYear, SwisSBLKey]);

        If FoundRec
          then
            begin
              NewTabPos := DetermineTabPos(ParcelTabset.Tabs, UserDataTabName, TabOffset);
              ParcelTabset.Tabs.Insert(NewTabPos, UserDataTabName);
              TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

            end;  {If FoundRec}

      end;  {If not TabsAlreadyExist}

end;  {SetOppositeYearTabsForParcel}

{=============================================================}
Procedure SetSalesInventoryTabsForParcel(ParcelTabSet : TTabSet;
                                         TabTypeList : TStringList;
                                         LookupTable : TTable;
                                         SwisSBLKey : String;
                                         SalesNumber : Integer;
                                         ResidentialSite,
                                         CommercialSite,
                                         CommBuildingNo,
                                         CommBuildingSection,
                                         NumResSites,
                                         NumComSites : PProcessingTypeArray);

{Figure out what sales inventory tabs apply to this new parcel. We will only check the inventory tables.
 Note that the inventory we are looking for is not year dependant. We will look up based on the
 sales number, so we must change the key.}

var
  ProcessingType, TabOffset, NewTabPos, I : Integer;
  SalesInventoryTabsExist, FoundRec : Boolean;

begin
  TabOffset := TabTypeList.Count - 1;
  ProcessingType := SalesInventory;

    {First see if they have already brought the sales inventory tabs up for this
     parcel. If they have, then we will do nothing. To see if they have already brought
     up the sales inventory tabs, we will look through the TabTypeList for a SalesInventory
     entry. If we find any, then we know that they have already brought them up.}

  SalesInventoryTabsExist := False;

  For I := 0 to (TabTypeList.Count - 1) do
    If (DetermineProcessingType(TabTypeList[I][1]) = SalesInventory)
      then SalesInventoryTabsExist := True;

  If not SalesInventoryTabsExist
    then
      begin
        OpenLookupTable(LookupTable, ResidentialSiteTableName, ProcessingType);
        SetInventoryIndex(LookupTable, ProcessingType);
        FindKeyOld(LookupTable, ['SwisSBLKey', 'SalesNumber'],
                   [SwisSBLKey, IntToStr(SalesNumber)]);

        FoundRec := False;

          {FXX06181998-1: Need to check on sbl and sale # to see if found key,
                          can not rely on return.}

        with LookupTable do
          If ((Trim(SwisSBLKey) = Trim(FieldByName('SwisSBLKey').Text)) and
              (SalesNumber = FieldByName('SalesNumber').AsInteger))
            then FoundRec := True;

          {If there is at least one residential site record, then we will
           set them at the first one. Otherwise, we will set ResidentialSite to
           0 so that we know that there are no residential sites yet.}

        If FoundRec
          then ResidentialSite^[ProcessingType] := LookupTable.FieldByName('Site').AsInteger;

          {If we found a residential site, then there is a residential
           building record, too.}

        If FoundRec
          then
            begin
                {First add the residential site tab.}

              NewTabPos := DetermineTabPos(ParcelTabset.Tabs, ResidentialSiteTabName, TabOffset);
              ParcelTabset.Tabs.Insert(NewTabPos, ResidentialSiteTabName);
              TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

                 {Set the range for the site table and do a record count.}

              SetRangeOld(LookupTable,
                          ['SwisSBLKey', 'SalesNumber'],
                          [SwisSBLKey, IntToStr(SalesNumber)],
                          [SwisSBLKey, IntToStr(SalesNumber)]);

               NumResSites^[ProcessingType] := DetermineNumSites(LookupTable);

               SetResidentialInventoryTabsForSite(ParcelTabSet, TabTypeList, LookupTable,
                                                  '', SwisSBLKey, ProcessingType,
                                                  ResidentialSite^[ProcessingType], SalesNumber);

            end;  {If FoundRec}

         {Check for CommercialSite records.}

        OpenLookupTable(LookupTable, CommercialSiteTableName, ProcessingType);
        SetInventoryIndex(LookupTable, ProcessingType);
        FindKeyOld(LookupTable, ['SwisSBLKey', 'SalesNumber'],
                   [SwisSBLKey, IntToStr(SalesNumber)]);

        FoundRec := False;

          {FXX06181998-1: Need to check on sbl and sale # to see if found key,
                          can not rely on return.}

        with LookupTable do
          If ((Trim(SwisSBLKey) = Trim(FieldByName('SwisSBLKey').Text)) and
              (SalesNumber = FieldByName('SalesNumber').AsInteger))
            then FoundRec := True;

          {If there is at least one Commercial site record, then we will
           set them at the first one. Otherwise, we will set CommercialSite to
           0 so that we know that there are no Commercial sites yet.}

        If FoundRec
          then CommercialSite^[ProcessingType] := LookupTable.FieldByName('Site').AsInteger;

          {If we found a Commercial site, then there is a Commercial
           building record and income\expense record, too.}

        If FoundRec
          then
            begin
                {First add the Commercial site tab.}

              NewTabPos := DetermineTabPos(ParcelTabset.Tabs, CommercialSiteTabName, TabOffset);
              ParcelTabset.Tabs.Insert(NewTabPos, CommercialSiteTabName);
              TabTypeList.Insert(NewTabPos, ConvertProcessingTypeToChar(ProcessingType));

                 {Set the range for the site table and do a record count.}

               SetRangeOld(LookupTable,
                           ['SwisSBLKey', 'SalesNumber'],
                           [SwisSBLKey, IntToStr(SalesNumber)],
                           [SwisSBLKey, IntToStr(SalesNumber)]);

               NumComSites^[ProcessingType] := DetermineNumSites(LookupTable);

               SetCommercialInventoryTabsForSite(ParcelTabSet, TabTypeList, LookupTable,
                                                 '', SwisSBLKey,
                                                 ProcessingType, CommercialSite^[ProcessingType],
                                                 SalesNumber, CommBuildingNo, CommBuildingSection);

            end;  {If FoundRec}

      end;  {If not SalesInventoryTabsExist}

end;  {SetSalesInventoryTabsForParcel}

end.