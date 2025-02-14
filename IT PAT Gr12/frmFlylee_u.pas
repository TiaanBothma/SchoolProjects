unit frmFlylee_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Tabs, Vcl.ExtCtrls, pngimage, jpeg, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.Buttons,
  { Helper Files }
  uDBCalls, uFunc, uComponents;

type
  TfrmFlylee = class(TForm)
    pcPages: TPageControl;
    tsHome: TTabSheet;
    imgCorner: TImage;
    imgFlyGirl: TImage;
    imgPlane: TImage;
    imgPlane2: TImage;
    lblTitle: TLabel;
    lblTopTitle: TLabel;
    imgUnderline: TImage;
    lblAbout: TLabel;
    shpFindMore: TShape;
    shpPlay: TShape;
    lblFindMore: TLabel;
    imgPlay: TImage;
    lblInfo: TLabel;
    tsInfo: TTabSheet;
    lblCategory: TLabel;
    lblOffer: TLabel;
    imgDecor: TImage;
    sbInfo: TScrollBox;
    lblTopSelling: TLabel;
    lblTopDestinations: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure posHomePageImages();
    procedure initVarsHomePage();
    procedure createMenuBar(AOwner : TComponent; AParent : TWinControl);
    procedure lblDestinationsMouseEnter(Sender: TObject);
    procedure lblDestinationsMouseLeave(Sender: TObject);
    procedure lblFlightsMouseEnter(Sender: TObject);
    procedure lblFlightsMouseLeave(Sender: TObject);
    procedure lblHotelsMouseEnter(Sender: TObject);
    procedure lblHotelsMouseLeave(Sender: TObject);
    procedure lblBookingsMouseEnter(Sender: TObject);
    procedure lblBookingsMouseLeave(Sender: TObject);
    procedure shpFindMoreMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblFindMoreClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure createInfoPage();
   { Private Scope }
  private
    arrUser : array[1..4] of string;
  { Public Scope }
  public
    { Verklaar die kleure sodat alle vorme kan gebruik }
    clPrimary, clSecondary, clAccent, clTextColor : TColor;
    { Menu Bar }
    lblDestinations, lblBookings, lblHotels, lblFlights, lblUserName : TLabel;
    imgTitle, imgProfile : TImage;
    { View Review }
    ireviewcount : integer;
  end;

var
  frmFlylee: TfrmFlylee;

implementation

{$R *.dfm}

uses frmSignUp_u, dmData_u;

procedure TfrmFlylee.FormActivate(Sender: TObject);
begin
  {
   ================
   On Form Activate
   ================
  }

  loadUserData(arrUser);
  createMenuBar(tsHome, tsHome);
  createMenuBar(sbInfo, sbInfo);
end;

procedure TfrmFlylee.FormCreate(Sender: TObject);
begin
  {
   ===========
   Form Create
   ===========
  }

  { Load Colors }
  clPrimary := rgb(255,169,15); //Web Orange
  clSecondary := rgb(223,105,81); //Burnt Sienna
  clAccent := rgb(0,99,128); //Cerulean
  clTextColor := rgb(24,30,75); //Dark Moon Blue

 { inti variables }
 ireviewcount := 1;

 { LoadImages }
 imgCorner.Picture.LoadFromFile('Assets/cornerDecor.png');
 imgFlyGirl.Picture.LoadFromFile('Assets/flyGirl.png');
 imgPlane.Picture.LoadFromFile('Assets/plane.png');
 imgPlane2.Picture.LoadFromFile('Assets/plane.png');
 imgUnderline.Picture.LoadFromFile('Assets/underline.png');
 imgPlay.Picture.LoadFromFile('Assets/playIcon.png');

 { positions and scales }
 posHomePageImages();
 initVarsHomePage();
 createInfoPage();
end;

procedure TfrmFlylee.initVarsHomePage();
begin
  {
  ===========================================
  Initialize en scale die home page variables
  ===========================================
  }
  with lblTitle do
  begin
    Caption := 'Travel, enjoy' + #13 + 'and live a new' + #13 + 'experience now';
    setlabelFont(lblTitle, 60, true);
    font.color := clTextColor;
    top := 170;
    left := 100;
  end;

  with lblTopTitle do
  begin
    Caption := 'BEST DESTINATIONS AROUND THE WORLD';
    font.size := 16;
    font.Style := [TFontStyle.fsBold];
    font.Color := clSecondary;
    left := 100;
    top := 150;
  end;

  with lblAbout do
  begin
    caption := 'We provide the best flights with ease so you don''t have to. We work' + #13 + 'with weather and shipping companies to predict the best flights.';
    setLabelFont(lblAbout, 14, false);
    font.color := clTextColor;
    top := 470;
    left := 100;
  end;

  with shpFindMore do
  begin
    brush.Color := clPrimary;
    height := 60;
    width := 170;
    left := 100;
    top := 540;
    Pen.Style := psClear;
  end;

  with shpPlay do
  begin
    brush.color := clSecondary;
    width := 55;
    height := 55;
    top := 542;
    left := shpFindMore.Left + shpFindMore.Width + 60;
    Pen.Style := psClear;
  end;

  with lblFindMore do
  begin
    setLabelFont(lblFindMore, 14, true);
    font.color := clWhite;
    //Sentreer vertikaal
    Top := shpFindMore.Top + (shpFindMore.Height - Height) div 2;
    //Sentreer horisontaal
    Left := shpFindMore.Left + (shpFindMore.Width - Width) div 2;
  end;

  with lblInfo do
  begin
    setLabelFont(lblInfo, 14, false);
    top := shpPlay.Top + 15;
    left := shpPlay.left + shpPlay.Width + 10;
  end;

  with imgPlay do
  begin
    height := 25;
    width := 25;
    centerComponent(imgPlay, shpPlay);
  end;
end;

procedure TfrmFlylee.lblBookingsMouseEnter(Sender: TObject);
begin
  lblBookings.font.color := clAccent;
end;

procedure TfrmFlylee.lblBookingsMouseLeave(Sender: TObject);
begin
  lblBookings.font.color := clBlack;
end;

procedure TfrmFlylee.lblDestinationsMouseEnter(Sender: TObject);
begin
  lblDestinations.font.color := clAccent;
end;

procedure TfrmFlylee.lblDestinationsMouseLeave(Sender: TObject);
begin
  lblDestinations.font.color := clBlack;
end;

procedure TfrmFlylee.lblFindMoreClick(Sender: TObject);
begin
  pcPages.TabIndex := 1;
end;

procedure TfrmFlylee.lblFlightsMouseEnter(Sender: TObject);
begin
  lblFlights.font.color := clAccent;
end;

procedure TfrmFlylee.lblFlightsMouseLeave(Sender: TObject);
begin
  lblFlights.font.color := clBlack;
end;

procedure TfrmFlylee.lblHotelsMouseEnter(Sender: TObject);
begin
  lblHotels.font.color := clAccent;
end;

procedure TfrmFlylee.lblHotelsMouseLeave(Sender: TObject);
begin
  lblHotels.font.color := clBlack;
end;

procedure TfrmFlylee.createInfoPage();
var

  arrDestinations : array[0..100] of string;
  arrDays : array[0..100] of integer;
  arrCosts : array[0..100] of real;
  I: Integer;
  ileft : integer;
  sImagePath : string;

  lblReviews, lblAboutSay : TLabel;

begin
  {
   =========================================================
   Position and create the category section in the Info Page
   =========================================================
  }

  { Services }
  with lblCategory do
  begin
    setLabelFont(lblCategory, 14, true);
    font.Color := clTextColor;
    caption := 'CATEGORY';
    centerComponent(lblCategory, sbInfo);
    top := 100;
  end;

  with lblOffer do
  begin
    setLabelFont(lblOffer, 40, true);
    font.color := clTextColor;
    caption := 'We Offer Best Services';
    centerComponent(lblOffer, sbInfo);
    top := 125;
  end;

  //Create category info boxes for services
  createInfoBox(40, 'Assets/weatherService.png', 'Calculated Weather', 'We offer only the best', sbInfo);
  createInfoBox(390, 'Assets/flightService.png', 'Best Flights', 'We offer only theasdf best', sbInfo);
  createInfoBox(740, 'Assets/eventService.png', 'Local Events', 'We offer only the beasdfst', sbInfo);
  createInfoBox(1090, 'Assets/settingsService.png', 'Customization', 'We offer onasdfly the best', sbInfo);

  { Top Selling Flights }
  with lblTopSelling do
  begin
    setLabelFont(lblTopSelling, 14, true);
    font.color := clTextColor;
    centerComponent(lblTopSelling, sbInfo);
    top := 630;
  end;

  with lblTopDestinations do
  begin
    setLabelFont(lblTopDestinations, 40, true);
    font.color := clTextColor;
    centerComponent(lblTopDestinations, sbInfo);
    top := 655;
  end;

  //Create top selling destination boxes
  loadTopDestinations(arrDestinations, arrDays, arrCosts);
  ileft := 70;

  //1 tot 3 want ons soek net die top 3
  for I := 1 to 3 do
  begin
    if i = 1 then
    begin
    sImagePath := 'Assets/balloons.jpeg'

    end
      else if i = 2 then
      begin
        sImagePath := 'Assets/camera.jpg'
      end
        else
        begin
          sImagePath := 'Assets/lights.jpeg';
        end;


    createTopSellingBox(ileft, sImagePath, arrDestinations[i-1], inttostr(arrDays[i-1]) + ' Days Trip' , arrCosts[i-1], sbInfo);
    inc(ileft, 440);
  end;

  { Create Review Section }
  lblReviews := TLabel.Create(sbInfo);
  with lblReviews do
  begin
    parent := sbInfo;
    setLabelFont(lblReviews, 14, true);
    font.color := rgb(94,98,130);
    caption := 'Reviews';
    top := 1380;
    left := 100;
  end;

  lblAboutSay := Tlabel.Create(sbInfo);
  with lblAboutSay do
  begin
    parent := sbInfo;
    setLabelFont(lblAboutSay, 50, true);
    font.color := clTextColor;
    Alignment := taLeftJustify;
    caption := 'What People Say' + #13 + 'About Us';
    top := lblReviews.Top + lblReviews.Height + 10;
    left := 100;
  end;

  createViewReviewBox(ireviewcount, sbInfo);
end;

procedure TfrmFlylee.posHomePageImages();
begin
  {
   ==============================================
   Position and scale the images in the home page
   ==============================================
  }
  imgUnderline.top := 245;
  imgUnderline.left := 320;

  with imgCorner do
  begin
    Width := 585;
    Height := 568;
    Top := -10;
    Left := 832;
  end;

  with imgFlyGirl do
  begin
    Width := 650;
    Height := 650;
    Top := 50;
    Left := 584;
  end;

  with imgPlane do
  begin
    Width := 170;
    Height := 170;
    Top := 95;
    Left := 656;
  end;

  with imgPlane2 do
  begin
    Width := 170;
    Height := 170;
    Top := 167;
    Left := 1112;
  end;
end;

procedure TfrmFlylee.shpFindMoreMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pcPages.TabIndex := 1;
end;

procedure TfrmFlylee.createMenuBar(AOwner : TComponent; AParent : TWinControl);
begin
  {
  ===============================================================
  Create and Position die labels in die menu bar in die home page
  ===============================================================
  }

  // Create lblDestinations
  lblDestinations := TLabel.Create(AOwner);
  with lblDestinations do
  begin
    Parent := AParent;
    setLabelFont(lblDestinations, 16, true);
    caption := 'Destinations';
    Left := 450;
    Top := 30;
    { procedures }
    OnMouseEnter := lblDestinationsMouseEnter;
    OnMouseLeave := lblDestinationsMouseLeave;
  end;

  // Create lblHotels
  lblHotels := TLabel.Create(AOwner);
  with lblHotels do
  begin
    Parent := AParent;
    setLabelFont(lblHotels, 16, true);
    caption := 'Hotels';
    Left := lblDestinations.Left + lblDestinations.Width + 60;
    Top := 30;
    { procedures }
    OnMouseEnter := lblHotelsMouseEnter;
    OnMouseLeave := lblHotelsMouseLeave;
  end;

  // Create lblFlights
  lblFlights := TLabel.Create(AOwner);
  with lblFlights do
  begin
    Parent := AParent;
    setLabelFont(lblFlights, 16, true);
    caption := 'Flights';
    Left := lblHotels.Left + lblHotels.Width + 60;
    Top := 30;
    { procedures }
    OnMouseEnter := lblFlightsMouseEnter;
    OnMouseLeave := lblFlightsMouseLeave;
  end;

  // Create lblBookings
  lblBookings := TLabel.Create(AOwner);
  with lblBookings do
  begin
    Parent := AParent;
    setLabelFont(lblBookings, 16, true);
    caption := 'Bookings';
    Left := lblFlights.Left + lblFlights.Width + 60;
    Top := 30;
    { procedures }
    OnMouseEnter := lblBookingsMouseEnter;
    OnMouseLeave := lblBookingsMouseLeave;
  end;

  //Create image
  imgProfile := TImage.Create(AOwner);
  with imgProfile do
  begin
    Parent := AParent;
    Stretch := true;
    width := 45;
    height := 45;
    top := 20;
    left := 1200;
  end;

  //Create label name
  lblUserName := TLabel.Create(AOwner);
  with lblUserName do
  begin
    Parent := AParent;
    setLabelFont(lblUsername, 16, true);
    font.color := clTextColor;
    caption := arrUser[1];
    top := 30;
    left := imgProfile.left + imgProfile.Width + 10;
  end;

  //Create logo title
  imgTitle := TImage.Create(AOwner);
  with imgTitle do
  begin
    Parent := AParent;
    Picture.LoadFromFile('Assets/logoTitle.png');
    width := 135;
    height := 50;
    top := 30;
    left := 40;
  end;

  //Nadat die profile image gemaak is kan ons die image in sit
  loadProfilePic(imgProfile, dmData.iUserId);
end;

end.
