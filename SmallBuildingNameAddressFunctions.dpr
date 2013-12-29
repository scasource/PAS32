library SmallBuildingNameAddressFunctions;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  DBTables,
  Classes,
  Dialogs,
  BldUtils,
  BldTypes,
  WinUtils,
  CompatibilityUnit,
  Utilitys,
  Forms;

{$R *.RES}

{Declare all the tables needed here.}

var
  ParcelTable : TTable;

{=======================================================================}
Function OpenTable(Application : TApplication;
                   Table : TTable;
                   _TableName,
                   _IndexName,
                   _DatabaseName : String) : Boolean;

begin
  Result := True;

  with Table do
    try
      TableType := ttDBase;
      DatabaseName := _DatabaseName;
      TableName := _TableName;
      IndexName := _IndexName;
      Open;
    except
      MessageDlg('Error opening table ' + _TableName + ' in Building System.',
                 mtError, [mbOk], 0);
      Result := False;
    end;

end;  {OpenTable}

{================================================================}
Procedure CloseTable(Application : TApplication;
                     Table : TTable);

begin
  try
    Table.Close;
    Table.Free;
  except
  end;

end;  {CloseTable}

{=======================================================================}
Function InitializeDLL(Application : TApplication) : Boolean;

{Create and open the tables here.  Return false if any of the opens fail.}

begin
  ParcelTable := TTable.Create(Application);
  Result := OpenTable(Application, ParcelTable, 'PropertyTable',
                      'BYSWISSBLKEY', 'SCABuild32');

end;  {InitializeDLL}

{=======================================================================}
Function GetParcelNameAddress(    Application : TApplication;
                                  SwisCode : ShortString;
                                  SBL : ShortString;
                              var OldNameAddressArray : NameAddrArray) : Boolean;

{Using the already opened tables, lookup this parcel and see if it has any
 open amounts.  If so, return True.  Otherwise, return false.}

begin
  Result := False;

  If FindKeyOld(ParcelTable, ['SwisSBLKEY'], [SwisCode + SBL])
    then
      begin
        Result := True;
        GetNameAddress(ParcelTable, OldNameAddressArray);
      end;  {If FindKeyOld(ParcelTable}

end;  {GetParcelNameAddress}

{=======================================================================}
Procedure SetParcelNameAddress(    Application : TApplication;
                                   SwisCode : ShortString;
                                   SBL : ShortString;
                                   NewNameAddressArray : NameAddrArray);

{Using the already opened tables, lookup this parcel and see if it has any
 open amounts.  If so, return True.  Otherwise, return false.}

begin
  If FindKeyOld(ParcelTable, ['SwisSBLKey'], [SwisCode + SBL])
    then
      with ParcelTable do
        try
          Edit;
          FieldByName('OwnerName').Text := NewNameAddressArray[1];
          FieldByName('OwnerName2').Text := NewNameAddressArray[2];
          FieldByName('MailAddr1').Text := NewNameAddressArray[3];
          FieldByName('MailAddr2').Text := NewNameAddressArray[4];
          FieldByName('MailAddr3').Text := NewNameAddressArray[5];
          FieldByName('MailAddr4').Text := NewNameAddressArray[6];
          Post;
        except
          MessageDlg('Error updating name \ address for parcel ' + SBL + '.',
                     mtError, [mbOK], 0)
        end
    else MessageDlg('Error finding parcel ' + SBL + '.',
                     mtError, [mbOK], 0)

end;  {GetParcelNameAddress}

{=======================================================================}
Function CloseDLL(Application : TApplication) : Boolean;

{Close and free the tables here.}

begin
  Result := True;

  CloseTable(Application, ParcelTable);

end;  {CloseDLL}


exports
  InitializeDLL,
  GetParcelNameAddress,
  SetParcelNameAddress,
  CloseDLL;

begin
end.