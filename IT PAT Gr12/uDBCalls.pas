unit uDBCalls;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, DateUtils, Data.DB, Data.Win.ADODB,
  System.Skia, Vcl.Skia, dmData_u;

{ Declare procedures/functions }
procedure loadUserData(var arrUser: array of string);
procedure loadProfilePic(var imgProfile : TImage; iiduser : integer);
procedure loadTopDestinations(var arrDestination : array of string; var arrHours : array of integer; var arrCost : array of real);
procedure saveProfilePictoDB(var sfilename : string);
function getUserReviews(iFieldCount : integer) : TArray<String>;
procedure loadAllDestinations(var arrDestinations : array of string; var arrHours : array of integer; var arrCost : array of real; var icount : integer);

implementation

procedure loadAllDestinations(var arrDestinations : array of string; var arrHours : array of integer; var arrCost : array of real; var icount : integer);
begin
  icount := 0;

  with dmData do
  begin
    tblFlights.open;
    tblFlights.first;
    while not tblFlights.eof do
    begin
      arrDestinations[icount] := tblFlights['to'];
      arrHours[icount] := tblFlights['tripLength'];
      arrCost[icount] := tblFlights['price'];

      inc(icount);
      tblFlights.Next;
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
  SetLength(arrUserReview, 4);

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
        arruserReview[3] := tblReviews['reviewDate'];

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

procedure loadTopDestinations(var arrDestination : array of string; var arrHours : array of integer; var arrCost : array of real);
var

  icount : integer;
  I, J: Integer;
  arrPopularity : array[0..100] of real;
  { lorries }
  slorrie : string;
  iLorrie : integer;
  rlorrie : real;
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
    tblFLights.first;
    while not tblFlights.Eof do
    begin
      arrDestination[icount] := tblFLights['to'];
      arrHours[icount] := tblFlights['tripLength'];
      arrCost[icount] := tblFlights['price'];
      arrPopularity[icount] := 0;

      tblStats.open;
      tblStats.first;
      while not tblStats.Eof do
      begin
        if tblStats['FlightID'] = tblFlights['FlightID']
          then begin
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

          // Swap arrDays
          ilorrie := arrHours[I];
          arrHours[I] := arrHours[J];
          arrHours[J] := ilorrie;

          // Swap arrCost
          rlorrie := arrCost[I];
          arrCost[I] := arrCost[J];
          arrCost[J] := rlorrie;

          // Swap arrPopularity
          rlorrie := arrPopularity[I];
          arrPopularity[I] := arrPopularity[J];
          arrPopularity[J] := rlorrie;
        end;

    end;
end;

procedure loadUserData(var arrUser: array of string);

var

  bfound : boolean;

begin
  {
   ================================================================
   Lees user se data vanaf databasis in n array vir vinniger opsoek
   ================================================================
  }

  bfound := false;

  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;
    while (not tblUsers.Eof) and (bfound = false) do
    begin
      if tblUsers['Userid'] = iUserId then
        begin
          bfound := true;
          arrUser[0] := tblUsers['name'];
          arrUser[1] := tblUsers['lastname'];
          arrUser[2] := tblUsers['isSubscribed'];
          arrUser[3] := tblUsers['birthDate'];
        end;

      tblUsers.next;
    end;
  end;

  if bfound = false then
    begin
      Showmessage('A problem occurred with your user account.');
      exit;
    end;
end;

procedure loadProfilePic(var imgProfile : TImage; iiduser : integer);
var

  Stream: TMemoryStream;
  BlobField: TBlobField;
  bfound : boolean;

begin
  {
   ==================================================================================
   Laai die user se profiel prent van Access database en wys dit in 'n TImage
   ==================================================================================
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
