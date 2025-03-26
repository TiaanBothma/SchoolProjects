unit clsUser_u;

interface

uses
  System.SysUtils, System.DateUtils;

type
  TUser = class(TObject)
  private
    { Attributes }
    fName: string;
    fLastName : string;
    fIsSubscribed : Boolean;
    fAge: Integer;
    fIsAdmin : Boolean;
    fTotalSpent : real;
    fBookingID : integer;

  public
    { Constructor }
    constructor Create(sName, sLastName: string; dtBirthDate: TDateTime; bIsSubscribed, bIsAdmin: Boolean; rTotalSpent: Real; iBookingID: Integer);

    { Accessors }
    function getName: string;
    function getLastName: string;
    function getAge: Integer;
    function getIsSubscribed: Boolean;
    function getIsAdmin: Boolean;
    function getTotalSpent: Real;
    function getBookingID: Integer;

    { Mutators }
    procedure setName(sName: string);
    procedure setLastName(sLastName: string);
    procedure setAge(dtBirthDate: TDateTime);
    procedure setIsSubscribed(bIsSubscribed: Boolean);
    procedure setIsAdmin(bIsAdmin: Boolean);
    procedure setTotalSpent(rAmount: Real);
    procedure setBookingID(iBookingID: Integer);

    { Auxiliary }
    procedure calculateAge(dtBirthDate: TDateTime);
  end;

implementation

constructor TUser.Create(sName, sLastName: string; dtBirthDate: TDateTime; bIsSubscribed, bIsAdmin: Boolean; rTotalSpent: Real; iBookingID: Integer);
begin
  fName := sName;
  fLastName := sLastName;
  calculateAge(dtBirthDate);
  fIsSubscribed := bIsSubscribed;
  fIsAdmin := bIsAdmin;
  fTotalSpent := rTotalSpent;
  fBookingID := iBookingID;
end;

function TUser.getName: string;
begin
  Result := fName;
end;

function TUser.getLastName: string;
begin
  Result := fLastName;
end;

function TUser.getAge: Integer;
begin
  Result := fAge;
end;

function TUser.getIsSubscribed: Boolean;
begin
  Result := fIsSubscribed;
end;

function TUser.getIsAdmin: Boolean;
begin
  Result := fIsAdmin;
end;

function TUser.getTotalSpent: Real;
begin
  Result := fTotalSpent;
end;

function TUser.getBookingID: Integer;
begin
  Result := fBookingID;
end;

procedure TUser.setName(sName: string);
begin
  fName := sName;
end;

procedure TUser.setLastName(sLastName: string);
begin
  fLastName := sLastName;
end;

procedure TUser.setAge(dtBirthDate: TDateTime);
begin
  calculateAge(dtBirthDate);
end;

procedure TUser.setIsSubscribed(bIsSubscribed: Boolean);
begin
  fIsSubscribed := bIsSubscribed;
end;

procedure TUser.setIsAdmin(bIsAdmin: Boolean);
begin
  fIsAdmin := bIsAdmin;
end;

procedure TUser.setTotalSpent(rAmount: Real);
begin
  fTotalSpent := rAmount;
end;

procedure TUser.setBookingID(iBookingID: Integer);
begin
  fBookingID := iBookingID;
end;

procedure TUser.calculateAge(dtBirthDate : TDateTime);
begin
  fAge := YearsBetween(Now, dtBirthDate);
end;

end.

