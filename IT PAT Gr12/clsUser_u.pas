unit clsUser_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, JPEG, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, DateUtils, Data.DB, Data.Win.ADODB,
  System.Skia, Vcl.Skia,
  { Helper Files }
  dmData_u, uDBCalls;

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
    constructor Create(iUID : integer);

    { Accessors }
    function getName: string;
    function getLastName: string;
    function getAge: Integer;
    function getIsSubscribed: Boolean;
    function getIsAdmin: Boolean;
    function getTotalSpent: Real;
    function getBookingID: Integer;
    function getBookingDestination : string;

    { Mutators }
    procedure setName(sName: string);
    procedure setLastName(sLastName: string);
    procedure setIsSubscribed(bIsSubscribed: Boolean);
    procedure setIsAdmin(bIsAdmin: Boolean);
    procedure setTotalSpent(rAmount: Real);
    procedure setBookingID(iBookingID: Integer);

    { Auxiliary }
    procedure calculateAge(dtBirthDate: TDateTime);
    procedure destinationOnClick(Sender : TObject);
  end;

implementation

constructor TUser.Create(iUID : integer);
begin
  { Save die user locally vir beter en vinniger handeling }
  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;

    while not tblUsers.eof do
    begin
      if tblUsers['userid'] = iUID
        then begin
          fBookingID := tblUsers['flightid'];
          fName := tblUsers['name'];
          fLastName := tblUsers['lastname'];
          calculateAge(tblUsers['birthDate']);
          fIsSubscribed := tblUsers['isSubscribed'];
          fIsAdmin := tblUsers['isAdmin'];
          fTotalSpent := tblUsers['totalSpent'];

          break;
        end;

      tblUsers.next;
    end;
  end;
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

function TUser.getBookingDestination: string;
begin
  with dmData do
  begin
    tblFlights.open;
    tblFlights.first;

    while not tblFLights.eof do
    begin
      if tblFlights['flightid'] = getBookingID
        then begin
          result := tblFlights['to'];

          break;
        end;


      tblFlights.next;
    end;
  end;
end;

function TUser.getBookingID: Integer;
begin
  Result := fBookingID;
end;

procedure TUser.setName(sName: string);
begin
  fName := sName;

  //Verander ook dan in die databasis
  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;

    while not tblUsers.Eof do
    begin
      if tblUsers['Userid'] = iuserid
        then begin
          tblUsers.edit;
          tblUsers['name'] := sname;
          tblusers.post;
          break;
        end;

      tblUsers.next;
    end;
  end;
end;

procedure TUser.setLastName(sLastName: string);
begin
  fLastName := sLastName;

  //Verander ook dan in die databasis
  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;

    while not tblUsers.Eof do
    begin
      if tblUsers['Userid'] = iuserid
        then begin
          tblUsers.edit;
          tblUsers['lastName'] := slastname;
          tblusers.post;
          break;
        end;

      tblUsers.next;
    end;
  end;
end;


procedure TUser.setIsSubscribed(bIsSubscribed: Boolean);
begin
  fIsSubscribed := bIsSubscribed;

  //Verander ook dan in die databasis
  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;

    while not tblUsers.Eof do
    begin
      if tblUsers['Userid'] = iuserid
        then begin
          tblUsers.edit;
          tblUsers['isSubscribed'] := bIsSubscribed;
          tblusers.post;
          break;
        end;

      tblUsers.next;
    end;
  end;
end;

procedure TUser.setIsAdmin(bIsAdmin: Boolean);
begin
  fIsAdmin := bIsAdmin;

  //Verander ook dan in die databasis
  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;

    while not tblUsers.Eof do
    begin
      if tblUsers['Userid'] = iuserid
        then begin
          tblUsers.edit;
          tblUsers['isAdmin'] := bisAdmin;
          tblusers.post;
          break;
        end;

      tblUsers.next;
    end;
  end;
end;

procedure TUser.setTotalSpent(rAmount: Real);
begin
  fTotalSpent := rAmount;

  //Verander ook dan in die databasis
  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;

    while not tblUsers.Eof do
    begin
      if tblUsers['Userid'] = iuserid
        then begin
          tblUsers.edit;
          tblUsers['totalSpent'] := rAmount;
          tblusers.post;
          break;
        end;

      tblUsers.next;
    end;
  end;
end;

procedure TUser.destinationOnClick(Sender: TObject);
var
  iFlightID : integer;
begin
  {
   ==================================
   As die user op n destination click
   ==================================
  }

  //Kyk watse image die user op geclick het
  //Kyk na die id wat op die image gestoor is
  if Sender is TImage
    then begin
      iFlightID := TImage(sender).Tag;
    end;

  if Messagedlg('Do you want to book this flight?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbCancel,TMsgDlgBtn.mbOK], 0) = mrOK
    then begin
      with dmData do
      begin
        //Check of die flight vol is
        tblFlights.open;
        tblFlights.first;
        while not tblFlights.Eof do
        begin
          if tblFlights['Flightid'] = iFlightid
            then begin
              if tblFlights['isFull'] = False
                then setBookingID(iFlightID)  //Save dit in die user tabel
                else showmessage('This Flight is Full');

              //Hou op soek as die regte flight gekry is
              break;
            end;

          tblFlights.next;
        end;

        //Save dit in die stats tabel
        tblStats.Open;
        tblStats.first;
        while not tblStats.Eof do
        begin
          if tblStats['Flightid'] = iFlightid
          then begin
            tblStats.edit;
            tblStats['Clicks'] := tblStats['Clicks'] + 1;
            tblStats['bookings'] := tblStats['bookings'] + 1;
            tblStats['dateRecorded'] := date();
            tblStats.post;
            updateStatsTable();

            break;
          end;

          tblStats.next;
        end;
      end;
    end
    else begin
      //Update die clicks in die Stats table
      with dmdata do
      begin
        tblStats.open;
        tblStats.first;
        while not tblStats.Eof do
        begin
          if tblStats['Flightid'] = iFlightID
            then begin
              tblStats.edit;
              tblStats['clicks'] := tblStats['clicks'] + 1;
              tblStats.post;
            end;


          tblStats.next;
        end;
      end;
    end;

end;

procedure TUser.setBookingID(iBookingID: Integer);
begin
  fBookingID := iBookingID;

  //Verander ook dan in die databasis
  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;

    while not tblUsers.Eof do
    begin
      if tblUsers['Userid'] = iuserid
        then begin
          tblUsers.edit;
          tblUsers['FlightId'] := iBookingid;
          tblusers.post;
          break;
        end;

      tblUsers.next;
    end;
  end;

end;

procedure TUser.calculateAge(dtBirthDate : TDateTime);
begin
  fAge := YearsBetween(Now, dtBirthDate);
end;

end.
