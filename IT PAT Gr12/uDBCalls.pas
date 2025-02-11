unit uDBCalls;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, DateUtils, Data.DB, Data.Win.ADODB,
  System.Skia, Vcl.Skia, dmData_u;

{ Declare procedures/functions }
procedure loadUserData(var arrUser: array of string);
procedure loadProfilePic(var imgProfile : TImage);
procedure loadTopDestinations(var arrDestination : array of string; var arrDays : array of integer; var arrCost : array of real);

implementation

procedure loadTopDestinations(var arrDestination : array of string; var arrDays : array of integer; var arrCost : array of real);
begin

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

procedure loadProfilePic(var imgProfile : TImage);
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
      if tblUsers['userid'] = iUserId then
      begin
        bfound := true;
        BlobField := dmData.tblUsers.FieldByName('profilePic') as TBlobField;
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

end.
