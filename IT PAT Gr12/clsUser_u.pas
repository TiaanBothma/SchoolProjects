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
    function toString(): string;
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
          //Kry die user se details uit die databasis sodat dit locally gestoor is
          fBookingID := tblUsers['flightid'];
          fName := tblUsers['name'];
          fLastName := tblUsers['lastname'];
          calculateAge(tblUsers['birthDate']);
          fIsSubscribed := tblUsers['isSubscribed'];
          fIsAdmin := tblUsers['isAdmin'];
          fTotalSpent := tblUsers['totalSpent'];
          //en dan hou op soek as die regte rekord gevind is
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
          //Stuur die user se foreing key vir die flight
          result := tblFlights['to'];
          //en dan hou op soek as die regte rekord gevind is
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
          //Verander die user se display naam
          tblUsers['name'] := sname;
          tblusers.post;
          //en dan hou op soek as die regte rekord gevind is
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
          //Verander die user se van
          tblUsers['lastName'] := slastname;
          tblusers.post;
          //en dan hou op soek as die regte rekord gevind is
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
          //Verander die user se subskribsie
          tblUsers['isSubscribed'] := bIsSubscribed;
          tblusers.post;
          //en dan hou op soek as die regte rekord gevind is
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
          //Verander die user na Admin
          tblUsers['isAdmin'] := bisAdmin;
          tblusers.post;
          //en dan hou op soek as die regte rekord gevind is
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
          //Verander die prys in die databasis
          tblUsers['totalSpent'] := rAmount;
          tblusers.post;
          //En dan hou op soek as die regte rekord gevind is
          break;
        end;

      tblUsers.next;
    end;
  end;
end;

function TUser.toString: string;
var
  sline : string;
begin
  sline := fname + ' ' + fLastname + ' (' + inttostr(fage) + ')' + #13;

  if fisAdmin
    then sline := sline + ' - Admin: YES' + #13
    else sline := sline + ' - Admin: NO' + #13;

  if fIsSubscribed
    then sline := sline + ' - Subscribed: YES' + #13
    else sline := sline + ' - Subscribed: NO' + #13;

  sline := sline + 'Has spent a total of ' + floattostrf(fTotalSpent, ffCurrency,8,2) + #13;
  sline := sline + 'Currently planning on going to ' + getFlightDestination(fBookingID);

  result := sline;
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
            //Update die stats wat die user veroorsaak het
            tblStats['Clicks'] := tblStats['Clicks'] + 1;
            tblStats['bookings'] := tblStats['bookings'] + 1;
            tblStats['dateRecorded'] := date();
            tblStats.post;
            //Update die pryse in die stats tabel
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
              //Update die clicks in die database omdat user dit geclick het
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

    tblFlights.open;
    tblFlights.first;

    while not tblUsers.Eof do
    begin
      if tblUsers['Userid'] = iuserid
        then begin
          tblUsers.edit;
          //Add die Foreign Key by die user
          tblUsers['FlightId'] := iBookingid;

          while not tblFlights.Eof do
          begin
            if tblFlights['flightid'] = iBookingID
              then begin
                //add die prys by die user se spent
                tblUsers['totalSpent'] := tblFlights['price'];
                //Hou op soek as die flight gevind is
                break;
              end;


            tblFlights.next;
          end;

          tblusers.post;
          //Hou op soek as die rekord gevind is
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
