unit ParcelObject;

interface

type
  ParcelRecord = record
    SwisCode : String;
    SBL : String;

  end;

  TParcelObject = class
    private
      ParcelInfoLoaded : Boolean;
    public
      Constructor Create;
      Function LoadParcel : Boolean;
      Function Refresh : Boolean;
      Procedure Clear;
      Destructor Destroy; override;

      ParcelInfo : ParcelRecord;

    end;  {TParcelObject = class}

implementation

end.
