unit uDBCalls;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, DateUtils, Data.DB, Data.Win.ADODB,
  System.Skia, Vcl.Skia, dmData_u;

{ Declare procedures/functions }
procedure loadProfilePic(var imgProfile : TImage; iiduser : integer);
procedure loadTopDestinations(var arrDestination : array of string; var arrHours : array of real; var arrCost : array of real ; var arrIDs : array of integer);
procedure saveProfilePictoDB(var sfilename : string);
function getUserReviews(iFieldCount : integer) : TArray<String>;
procedure loadAllDestinations(var arrDestinations : array of string; var arrHours : array of real; var arrCosts : array of real; var arrIDs : array of integer; var icount : integer; sfilterby : string; rlowprice, rhighprice : real);
procedure getHotelInfo(var arrNames : array of string; var arrCosts : array of real; var tfile : textfile);
procedure getBookingDetails(var sDestination : string; var rHours : real; var rCost : real ; var iBookingID : integer);
procedure generateUserInvoice(ibookingID : integer ; var redtInvoice : TRichEdit; sname, slastname, sAge : string);
procedure updateStatsTable();
function getReviewUserID(ireviewID : integer) : integer;

implementation

function getReviewUserID(ireviewID : integer) : integer;
begin
  with dmData do
  begin
    tblReviews.open;
    tblReviews.first;

    while not tblReviews.Eof do
    begin
      if tblReviews['id'] = ireviewid
        then begin
          result := tblReviews['userid'];

          break;
        end;


      tblReviews.next;
    end;
  end;
end;

procedure updateStatsTable();
begin
  with dmData do
  begin
    tblStats.open;
    tblStats.first;

    tblFLights.open;
    tblFlights.first;

    while not tblFlights.Eof do
    begin

      if tblFlights['FlightID'] = tblStats['Flightid']
        then begin
          tblStats.edit;
          tblStats['Revenue'] := tblStats['Bookings'] * tblFlights['Price'];
          tblStats.post;
        end;

      tblFlights.next;
    end;
    tblStats.next;
  end;

end;

procedure generateUserInvoice(ibookingID : integer ; var redtInvoice : TRichEdit; sname, slastname, sAge : string);
var

  sDestination, sFrom, sDate: string;
  rHours, rCost: real;

begin
  redtInvoice.Clear;
  redtInvoice.font.Name := 'Roboto';
  redtInvoice.font.Size := 12;

  redtInvoice.Lines.Add('------------------------------------');
  redtInvoice.SelAttributes.size := 16;
  redtInvoice.SelAttributes.Style := [TFontStyle.fsBold];
  redtInvoice.Lines.Add('            ' + sname+ '`s'  + ' Invoice           ');
  redtInvoice.Lines.Add('------------------------------------' + #13);

  with dmData do
  begin
    tblFlights.Open;
    tblFlights.First;

    while not tblFlights.Eof do
    begin
      if tblFlights['FlightId'] = iBookingID then
      begin
        // Fetch flight details based on booking ID
        sFrom := tblFlights['from'];
        sDestination := tblFlights['to'];
        sDate := DateToStr(tblFlights['date']);
        rHours := tblFlights['tripLength'];
        rCost := tblFlights['price'];

        redtInvoice.Lines.Add('Name: ' + sname + ' ' + slastname);
        redtInvoice.Lines.Add('Age: ' + sage);
        redtInvoice.Lines.Add('------------------------------------');

        redtInvoice.Lines.Add('Flight ID: ' + #9 + IntToStr(iBookingID));
        redtInvoice.Lines.Add('From: ' + #9 + sFrom);
        redtInvoice.Lines.Add('To: ' + #9 + sDestination);
        redtInvoice.Lines.Add('Date: ' + #9 + formatdatetime('dd mmmm yyyy', strtodate(sDate)));
        redtInvoice.Lines.Add('Trip Length: ' + #9 + FloatToStr(rHours) + ' hours');
        redtInvoice.Lines.Add('Price: ' + #9 + FormatFloat('0.00', rCost) + ' ZAR');
        redtInvoice.Lines.Add('------------------------------------');

        redtInvoice.SelAttributes.Style := [TFontStyle.fsBold];
        redtInvoice.Lines.Add('Total Cost: ' + FormatFloat('0.00', rCost) + ' ZAR');

        Break;
      end;
      tblFlights.Next;
    end;
  end;

  redtInvoice.Lines.Add('------------------------------------');
  redtInvoice.SelAttributes.Style := [TFontStyle.fsBold];
  redtInvoice.SelAttributes.Size := 16;
  redtInvoice.Lines.Add('Thank you for booking with us!');
end;

procedure getBookingDetails(var sDestination : string; var rHours : real; var rCost : real ; var iBookingID : integer);
begin

  with dmData do
  begin
    tblUsers.Open;
    tblUsers.First;

    while not tblUsers.Eof do
    begin
      if tblUsers['userID'] = iUserId
      then begin
        tblFlights.Open;
        tblFlights.First;

        while not tblFlights.Eof do
        begin
          if tblFlights['FlightId'] = tblUsers['FlightId']
          then begin
            iBookingID := tblUsers['FlightId'];
            sDestination := tblFlights['to'];
            rHours := tblFlights['tripLength'];
            rCost := tblFlights['price'];
            Break;
          end;
          tblFlights.Next;
        end;
        Break; //Stop if the correct user is found
      end;
      tblUsers.Next;
    end;
  end;


end;

procedure getHotelInfo(var arrNames : array of string; var arrCosts : array of real; var tfile : textfile);
var

  sline : string;
  icount : integer;

begin
  {
   ===========================
   Fil die arrays met die info
   ===========================
  }

  icount := 0;
  if fileexists('hotels.txt') then
  begin
    assignfile(tfile, 'hotels.txt');
  end;

  reset(tfile);

  while not eof(tfile) do
  begin
    readln(tfile, sline);

    arrNames[icount] := copy(sline, 1, pos(',', sline) - 1);
    delete(sline, 1, pos(',', sline));
    arrCosts[icount] := strtofloat(copy(sline, 1, pos(',', sline) - 1));
    delete(sline, 1, pos(',', sline));
    arrNames[icount] := arrNames[icount] + ',' + copy(sline, 1, pos(',', sline) - 1);

    inc(icount);
  end;

  closefile(tfile);
end;

procedure loadAllDestinations(var arrDestinations : array of string; var arrHours : array of real; var arrCosts : array of real; var arrIDs : array of integer; var icount : integer; sfilterby : string; rlowprice, rhighprice : real);
var
  I, J : integer;
  rlorrie : real;
  slorrie : string;
  ilorrie : integer;
begin
  icount := 0;

  if (rlowprice = -1) or (rhighprice = -1) then
  begin
    with dmData do
    begin
      tblFlights.open;
      tblFlights.first;
      while not tblFlights.eof do
      begin
        arrDestinations[icount] := tblFlights['to'];
        arrHours[icount] := tblFlights['tripLength'];
        arrCosts[icount] := tblFlights['price'];
        arrIDs[icount] := tblFlights['FlightID'];

        inc(icount);
        tblFlights.Next;
      end;
    end;
  end
  else begin
    with dmData do
    begin
      tblFlights.open;
      tblFlights.first;
      while not tblFlights.eof do
      begin
        if (tblFlights['price'] >= rlowprice) and (tblFlights['price'] <= rhighprice) then
        begin
          arrDestinations[icount] := tblFlights['to'];
          arrHours[icount] := tblFlights['tripLength'];
          arrCosts[icount] := tblFlights['price'];
          arrIDs[icount] := tblFlights['FlightID'];

          inc(icount);
        end;

        tblFlights.Next;
      end;
    end;
  end;

  if sfilterby = 'Price' then
  begin
    for I := 0 to icount - 2 do
    for J := I + 1 to icount - 1 do
    begin
      if arrCosts[i] < arrCosts[j] then
      begin
        rlorrie := arrCosts[i];
        arrCosts[i] := arrCosts[j];
        arrCosts[j] := rlorrie;

        rlorrie := arrHours[i];
        arrHours[i] := arrHours[j];
        arrHours[j] := rlorrie;

        slorrie := arrDestinations[i];
        arrDestinations[i] := arrDestinations[j];
        arrDestinations[j] := slorrie;

        ilorrie := arrIDs[i];
        arrIDs[i] := arrIDs[j];
        arrIDs[j] := ilorrie;
      end;
    end;
  end
  else if sfilterby = 'Country' then
  begin
    for I := 0 to icount - 2 do
    for J := I + 1 to icount - 1 do
    begin
      if arrDestinations[i] > arrDestinations[j] then
      begin
        slorrie := arrDestinations[i];
        arrDestinations[i] := arrDestinations[j];
        arrDestinations[j] := slorrie;

        rlorrie := arrCosts[i];
        arrCosts[i] := arrCosts[j];
        arrCosts[j] := rlorrie;

        rlorrie := arrHours[i];
        arrHours[i] := arrHours[j];
        arrHours[j] := rlorrie;

        ilorrie := arrIDs[i];
        arrIDs[i] := arrIDs[j];
        arrIDs[j] := ilorrie;
      end;
    end;
  end
  else
  begin
    for I := 0 to icount - 2 do
    for J := I + 1 to icount - 1 do
    begin
     if arrHours[i] < arrHours[j] then
      begin
        rlorrie := arrHours[i];
        arrHours[i] := arrHours[j];
        arrHours[j] := rlorrie;

        slorrie := arrDestinations[i];
        arrDestinations[i] := arrDestinations[j];
        arrDestinations[j] := slorrie;

        rlorrie := arrCosts[i];
        arrCosts[i] := arrCosts[j];
        arrCosts[j] := rlorrie;

        ilorrie := arrIDs[i];
        arrIDs[i] := arrIDs[j];
        arrIDs[j] := ilorrie;
      end;
    end;
  end;
end;

function getUserReviews(iFieldCount : integer) : TArray<String>;
var

  bfound : boolean;
  arrUserReview: TArray<String>;
  imiddle : integer;
  smessage : string;

begin
  {
   ===================================
   Kry die huidige user se review info
   ===================================
  }

  //initialize die array en stel dit op 3 plekke
  SetLength(arrUserReview, 5);

  with dmData do
  begin
    tblReviews.open;
    tblReviews.first;
    while (not tblReviews.Eof) and (bfound = false) do
    begin
      if tblReviews['ID'] = ifieldcount then
      begin
        {  Add n #13 (break) in die middle van die message }
        smessage := tblReviews['message'];
        imiddle := length(smessage) div 2;
        arrUserReview[0] := Copy(smessage, 1, imiddle) + #13 + Copy(smessage, imiddle + 1, length(smessage) - imiddle);

        arruserReview[1] := tblReviews['to'];
        arruserReview[3] := formatDateTime('dd mmm yyyy', tblReviews['reviewDate']);
        arrUserReview[4] := tblReviews['stars'];

        //Kry die user se naam
        tblUsers.open;
        tblUsers.first;
        while (not tblUsers.Eof) and (bfound = false) do
        begin
          if tblReviews['userid'] = tblUsers['userid']
            then begin
              arruserReview[2] := tblUsers['name'] + ' ' + tblUsers['lastname'];
              bfound := true;
            end;

          tblUsers.next;
        end;

      end;

      tblReviews.next;
    end;
  end;

  result := arrUserReview;
end;

procedure loadTopDestinations(var arrDestination : array of string; var arrHours : array of real; var arrCost : array of real ; var arrIDs : array of integer);
var

  icount : integer;
  I, J: Integer;
  arrPopularity : array[0..100] of real;
  { lorries }
  slorrie : string;
  rlorrie : real;
  ilorrie : integer;
begin
  {
   ===================================================================
   Lees die flights in die arrays in en dan sort dit asc by popularity
   ===================================================================
  }

  icount := 0;

  //Lees data in arrays
  with dmData do
  begin
    tblFlights.open;
    tblFlights.first;
    while not tblFlights.Eof do
    begin
      arrDestination[icount] := tblFlights['to'];
      arrHours[icount] := tblFlights['tripLength'];
      arrCost[icount] := tblFlights['price'];
      arrIDs[icount] := tblFlights['FlightID'];
      arrPopularity[icount] := 0;

      tblStats.open;
      tblStats.first;
      while not tblStats.Eof do
      begin
        if tblStats['FlightID'] = tblFlights['FlightID'] then
        begin
          arrPopularity[icount] := (tblStats['clicks'] + tblStats['bookings']) / 2;
          break;
        end;
        tblStats.next;
      end;

      inc(icount);
      tblFlights.next;
    end;
  end;

  //Sorteer volgense popularity
  //arrays begin by nul dus minus ons een ekstra
  for I := 0 to icount - 2 do
    for J := I + 1 to icount - 1 do
    begin
      if arrPopularity[i] < arrPopularity[j] then
      begin
        // Swap arrDestination
        slorrie := arrDestination[I];
        arrDestination[I] := arrDestination[J];
        arrDestination[J] := slorrie;

        // Swap arrHours
        rlorrie := arrHours[I];
        arrHours[I] := arrHours[J];
        arrHours[J] := rlorrie;

        // Swap arrCost
        rlorrie := arrCost[I];
        arrCost[I] := arrCost[J];
        arrCost[J] := rlorrie;

        // Swap arrIDs
        ilorrie := arrIDs[I];
        arrIDs[I] := arrIDs[J];
        arrIDs[J] := ilorrie;

        // Swap arrPopularity
        rlorrie := arrPopularity[I];
        arrPopularity[I] := arrPopularity[J];
        arrPopularity[J] := rlorrie;
      end;
    end;
end;

procedure loadProfilePic(var imgProfile : TImage; iiduser : integer);
var

  Stream: TMemoryStream;
  BlobField: TBlobField;
  bfound : boolean;

begin
  {
   ==========================================================================
   Laai die user se profiel prent van Access database en wys dit in 'n TImage
   ==========================================================================
  }
  bfound := false;

  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;
    while (not tblUsers.Eof) and (bfound = false) do
    begin
      if tblUsers['userid'] = iiduser then
      begin
        bfound := true;
        BlobField := tblUsers.FieldByName('profilePic') as TBlobField;
      end;

      tblUsers.next;
    end;
  end;

  // As daar geen prent is nie, gaan uit
  if BlobField.IsNull then
  begin
    showmessage('image is nil');
    imgProfile.Picture := nil;  // Maak skoon as daar geen prent is nie
    Exit;
  end;

  Stream := TMemoryStream.Create;
  try
    BlobField.SaveToStream(Stream);
    Stream.Position := 0;
    imgProfile.Picture.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure saveProfilePictoDB(var sfilename : string);
var
  Stream: TMemoryStream;
  BlobField: TBlobField;
begin
  {
   =================================================================================
   Save die user se image wat hy upload, in access as n OLO Object vir n profile pic
   =================================================================================
  }

 // Stel die standaard prent as sFileName leeg is
  if sFileName = '' then
    sFileName := 'Assets/logo.png';

  Stream := TMemoryStream.Create;

  try
    Stream.LoadFromFile(sFileName);
    Stream.Position := 0;

    BlobField := dmData.tblUsers.FieldByName('profilePic') as TBlobField;
    BlobField.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

end.
