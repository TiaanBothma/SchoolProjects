unit uComponents;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, JPEG, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, DateUtils, Data.DB, Data.Win.ADODB,
  System.Skia, Vcl.Skia,
  { Helper Files }
  uFunc, uDBCalls, dmData_u, clsUser_u, clsAdvertiser_u;

{ Stand Alone procedures }
procedure createInfoBox(iLeft : Integer; sImage, sTitle, sSubtitle: string; sbPage : TScrollBox);
procedure createDestinationBox(iLeft, itop, FlightID : Integer; sImage, sTitle, sHours : string; rCost : real ; var objUser: TUser; sbPage : TScrollBox);
procedure createViewReviewBox(iReviewCount: integer; sbPage : TScrollBox);
procedure createHotelBox(iimage : integer; shotelname, slocation : string; rhotelprice : real; isBelow: Boolean; tspage: TTabSheet);
procedure createAdvertiserBox(var objUser : TUser ;var objAdvertiser: TAdvertiser; sbPage : TScrollBox);

implementation

procedure createAdvertiserBox(var objUser : TUser ;var objAdvertiser: TAdvertiser; sbPage : TScrollBox);
var

  shpAdvertise : TShape;
  lblAdvertName, lblSize, lblDestination : TLabel;
  imgAdvertiser : TImage;

begin
  {
   ========================
   Maak die Advertiser boks
   ========================
  }

  shpAdvertise := TShape.Create(sbPage);
  with shpAdvertise do
  begin
    parent := sbPage;
    width := 800;
    height := 200;
    top := 1650;
    left := 400;
    Pen.Style := psClear;
    shape := stRoundRect;
    brush.Color := clWhite;
  end;

  imgAdvertiser := TImage.Create(sbPage);
  with imgAdvertiser do
  begin
    parent := sbPage;
    stretch := true;
    width := 400;
    height := 100;
    left := shpAdvertise.left + 20;
    top := shpAdvertise.top + 40;
    picture.LoadFromFile(objAdvertiser.getImage);
    if objUser.getIsAdmin
      then onClick := objAdvertiser.showAdvertCost
      else onClick := objAdvertiser.changeAdvertWarning;
  end;

  lblAdvertName := TLabel.Create(sbPage);
  with lblAdvertName do
  begin
    parent := sbPage;
    setLabelFont(lblAdvertName, 20, true);
    font.color := rgb(94, 98, 130);
    left := imgAdvertiser.left + imgAdvertiser.Width + 40;
    top := imgAdvertiser.top;
    caption := objAdvertiser.getName;
  end;

  lblSize := TLabel.Create(sbpage);
  with lblSize do
  begin
    parent := sbPage;
    setlabelfont(lblSize, 15, true);
    font.color := rgb(94, 98, 130);
    caption := '"' + objAdvertiser.getSize + '" Ad Size';
    top := lblAdvertName.top + lblAdvertname.Height + 20;
    left := lblAdvertname.left;
  end;

  lblDestination := TLabel.Create(sbPage);
  with lblDestination do
  begin
    parent := sbPage;
    setlabelfont(lblDestination, 18, false);
    font.Color := rgb(94, 98, 130);
    caption := 'Advert on Plane to ' + getFlightDestination(objAdvertiser.getFlightID);
    centerComponent(lblDestination, shpAdvertise);
    top := imgAdvertiser.top + imgAdvertiser.Height + 30;
  end;
end;

procedure createHotelBox(iimage : integer; shotelname, slocation : string; rhotelprice : real; isBelow: Boolean; tspage: TTabSheet);
var

  imgHotel, imgLocation : TImage;
  lblPricePN, lblHotelName, lblLocation : TLabel;
  shpHotel : TShape;

begin
  {
   =========================
   Create the Hotel view box
   =========================
  }

  imgHotel := TImage.Create(tspage);
  with imgHotel do
  begin
    parent := tspage;
    stretch := true;
    picture.LoadFromFile('Assets/Hotels/' + inttostr(iimage) + '.jpg');
    width := 850;
    height := 320;
    left := 260;
    if isBelow then top := 55 else top := 420;
  end;

  shpHotel := TShape.Create(tspage);
  with shpHotel do
  begin
    parent := tspage;
    pen.Style := psClear;
    shape := stRoundRect;
    brush.Color := clWhite;
    width := imgHotel.width + 2;
    height := 120;
    left := imgHotel.left;
    top := imgHotel.top + imgHotel.Height - Height + 20;
  end;

  lblHotelName := TLabel.Create(tspage);
  with lblHotelName do
  begin
    parent := tspage;
    setLabelFont(lblHotelname, 18, true);
    font.color := rgb(94, 98, 130);
    caption := shotelname;
    left := shpHotel.left + 20;
    top := shpHotel.Top + 20;
  end;

  imgLocation := TImage.Create(tspage);
  with imgLocation do
  begin
    parent := tspage;
    stretch := true;
    picture.LoadFromFile('Assets/locationIcon.png');
    height := 30;
    width := 30;
    left := shpHotel.left + 20;
    top := lblHotelName.Top + lblHotelName.Height + 20;
  end;

  lblLocation := TLabel.Create(tspage);
  with lblLocation do
  begin
    parent := tspage;
    setLabelFont(lblLocation, 16, true);
    font.color := rgb(94, 98, 130);
    caption := slocation;
    left := imgLocation.left + imgLocation.Width + 20;
    top := imgLocation.Top + 5;
  end;

  lblPricePN := TLabel.Create(tsPage);
  with lblPricePN do
  begin
    parent := tsPage;
    setlabelfont(lblPricePN, 16, true);
    font.color := rgb(94, 98, 130);
    caption := floattostrf(rhotelprice, ffCurrency, 8, 2);
    left := shpHotel.Left + shpHotel.Width - Width - 20;
    top := lblHotelName.top;
  end;
end;

procedure createViewReviewBox(iReviewCount: integer; sbPage : TScrollBox);
var

  shpReview : TShape;
  lblMessage, lblUser, lblTo, lblDate : TLabel;
  imgProfile : TImage;
  imgStar1, imgStar2, imgStar3, imgStar4, imgStar5 : TImage;
  iStars : integer;

begin
  {
   ==========================================
   Create the review box that people can view
   ==========================================
  }

  shpReview := TShape.Create(sbPage);
  with shpReview do
  begin
    parent := sbpage;
    Pen.Style := psClear;
    shape := stRoundRect;
    width := 600;
    Height := 180;
    left := 660;
    top := 1380 - sbPage.VertScrollBar.Position;
  end;

  imgProfile := TImage.Create(sbPage);
  with imgProfile do
  begin
    parent := sbPage;
    Stretch := true;
    width := 70;
    height := 70;
    loadProfilePic(imgProfile, getReviewUserID(ireviewcount));
    Top := shpReview.Top - (imgProfile.Height div 2);
    Left := shpReview.Left - (imgProfile.Width div 2);
  end;

  lblMessage := TLabel.Create(sbpage);
  with lblMessage do
  begin
    parent := sbPage;
    setLabelFont(lblMessage, 14, false);
    font.Color := rgb(9,98,130);
    caption := '"' + getUserReviews(iReviewCount)[0] + '"';
    left := shpReview.Left + 30;
    top := shpReview.top + 30;
  end;

  lblUser := TLabel.Create(sbPage);
  with lblUser do
  begin
    parent := sbPage;
    setLabelFont(lblUser, 16, true);
    font.Color := rgb(9,98,130);
    caption := getUserReviews(iReviewCount)[2];
    left := shpReview.Left + 30;
    top := shpReview.Top + shpReview.Height - height - 30;
  end;

  lblTo := TLabel.Create(sbpage);
  with lblTo do
  begin
    parent := sbPage;
    setLabelFont(lblTo, 12, true);
    font.Color := rgb(9,98,130);
    caption := 'Went to: ' + getUserReviews(iReviewCount)[1];
    left := lblUser.Left;
    top := lblUser.top + lblUser.Height - 2;
  end;

  lblDate := TLabel.Create(sbPage);
  with lblDate do
  begin
    parent := sbPage;
    setLabelFont(lblDate, 12, true);
    font.Color := rgb(9,98,130);
    caption := getUserReviews(iReviewCount)[3];
    left := shpReview.Left + shpReview.Width - Width - 20;
    top := shpReview.Top + 20;
  end;

  { Maak die stars wat die user gerate het }
  //Kry die stars wat die user gerate het
  istars := strtoint(getuserReviews(ireviewcount)[4]);

  imgStar1 := TImage.Create(sbPage);
  with imgStar1 do
  begin
    parent := sbpage;
    stretch := true;
    width := 30;
    height := 30;
    //Kyk of die ster gemerk is
    if iStars >= 1 then
      picture.LoadFromFile('Assets/starFilled.png')
    else
      picture.LoadFromFile('Assets/star.png');

    top := lblUser.top;
    left := lblTo.left + lblTo.width + 30;
  end;

  imgStar2 := TImage.Create(sbPage);
  with imgStar2 do
  begin
    parent := sbpage;
    stretch := true;
    width := 30;
    height := 30;
    //Kyk of die ster gemerk is
    if iStars >= 2 then
      picture.LoadFromFile('Assets/starFilled.png')
    else
      picture.LoadFromFile('Assets/star.png');

    top := lblUser.top;
    left := imgStar1.left + imgStar1.width + 10;
  end;

  imgStar3 := TImage.Create(sbPage);
  with imgStar3 do
  begin
    parent := sbpage;
    stretch := true;
    width := 30;
    height := 30;
    //Kyk of die ster gemerk is
    if iStars >= 3 then
      picture.LoadFromFile('Assets/starFilled.png')
    else
      picture.LoadFromFile('Assets/star.png');

    top := lblUser.top;
    left := imgStar2.left + imgStar2.width + 10;
  end;

  imgStar4 := TImage.Create(sbPage);
  with imgStar4 do
  begin
    parent := sbpage;
    stretch := true;
    width := 30;
    height := 30;
    //Kyk of die ster gemerk is
    if iStars >= 4 then
      picture.LoadFromFile('Assets/starFilled.png')
    else
      picture.LoadFromFile('Assets/star.png');

    top := lblUser.top;
    left := imgStar3.left + imgStar3.width + 10;
  end;

  imgStar5 := TImage.Create(sbPage);
  with imgStar5 do
  begin
    parent := sbpage;
    stretch := true;
    width := 30;
    height := 30;
    //Kyk of die ster gemerk is
    if iStars >= 5 then
      picture.LoadFromFile('Assets/starFilled.png')
    else
      picture.LoadFromFile('Assets/star.png');

    top := lblUser.top;
    left := imgStar4.left + imgStar4.width + 10;
  end;
end;

procedure createDestinationBox(iLeft, itop, FlightID : Integer; sImage, sTitle, sHours : string; rCost : real ; var objUser: TUser; sbPage : TScrollBox);
var

  imgLocation, imgIcon : TImage;
  shpDesc : TShape;
  lblTitle, lblHours, lblCost : TLabel;

begin
  {
   ========================
   Maak die Destination box
   ========================
  }

  imgLocation := TImage.Create(sbpage);
  with imgLocation do
  begin
    parent := sbPage;
    stretch := true;
    width := 350;
    height := 350;
    Picture.LoadFromFile(simage);
    top := itop;
    left := ileft;
    Tag := FlightID;
    OnClick := objUser.destinationOnClick;
  end;

  shpDesc := TShape.Create(sbpage);
  with shpDesc do
  begin
    parent := sbPage;
    Pen.style := psClear;
    Shape := stRoundRect;
    Brush.Color := clWhite;
    width := 352;
    height := 120;
    top := imgLocation.Top + imgLocation.Height - 40;
    left := ileft;
  end;

  lblTitle := TLabel.Create(shpDesc);
  with lblTitle do
  begin
    parent := sbpage;
    setLabelFont(lblTitle, 16, true);
    font.color := rgb(94, 98, 130);
    caption := sTitle;
    top := shpDesc.Top + 20;
    left := shpDesc.Left + 20;
  end;

  imgIcon := TImage.Create(sbpage);
  with imgIcon do
  begin
    parent := sbPage;
    stretch := true;
    Picture.LoadFromFile('Assets/locationIcon.png');
    height := 20;
    width := 20;
    left := shpDesc.Left + 20;
    top := lblTitle.Top + lblTitle.Height + 25;
  end;

  lblHours := TLabel.Create(sbpage);
  with lblHours do
  begin
    parent := sbpage;
    setLabelFont(lblHours, 14, true);
    font.color := rgb(94, 98, 130);
    caption := sHours;
    top := lblTitle.top + lblTitle.Height + 25;
    left := imgIcon.Left + imgIcon.Width + 10;
  end;

  lblCost := TLabel.Create(sbpage);
  with lblCost do
  begin
    parent := sbpage;
    setLabelFont(lblCost, 16, true);
    font.color := rgb(94, 98, 130);
    caption := floattostrf(rCost, ffCurrency, 8, 2);
    top := shpDesc.Top + 20;
    left := shpDesc.Left + shpDesc.Width - Width - 20;
  end;
end;

procedure createInfoBox(iLeft : Integer; sImage, sTitle, sSubtitle : string; sbPage : TScrollBox);
var

  iTop : integer;
  shpService : TShape;
  imgIcon: TImage;
  lblTitle, lblSubtitle: TLabel;

begin
  iTop := 250;

  // Create the shape
  shpService := TShape.Create(sbPage);
  with shpService do
  begin
    Parent := sbPage;
    Width := 300;
    Height := 300;
    Left := iLeft;
    Top := iTop;
    Brush.Color := clWhite;
    Shape := stRoundRect;
    Pen.Style := psClear;
  end;

  // Create the image
  imgIcon := TImage.Create(sbPage);
  with imgIcon do
  begin
    Parent := sbPage;
    Width := 70;
    Height := 60;
    Stretch := True;
    centerComponent(imgIcon, shpService);
    Top := shpService.Top + 40;
    if FileExists(sImage) then
      Picture.LoadFromFile(sImage);
  end;

  // Create the title label
  lblTitle := TLabel.Create(sbPage);
  with lblTitle do
  begin
    Parent := sbPage;
    setLabelFont(lblTitle, 16, true);
    Font.Color := rgb(30, 29, 76);
    Caption := sTitle;
    centerComponent(lbltitle, shpService);
    top := imgIcon.Top + imgIcon.Height + 20;
  end;

  // Create the subtitle label
  lblSubtitle := TLabel.Create(sbPage);
  with lblSubtitle do
  begin
    Parent := sbPage;
    setLabelFont(lblSubtitle, 12, false);
    Font.Color := rgb(94, 98, 130);
    Caption := sSubtitle;
    centerComponent(lblSubtitle, shpService);
    Top := lblTitle.Top + lblTitle.Height + 10;
  end;
end;


end.
