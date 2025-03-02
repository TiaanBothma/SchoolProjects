unit frmFlylee_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Tabs, Vcl.ExtCtrls, pngimage, jpeg, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.Buttons, Math,
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
    imgArrowUp: TImage;
    imgArrowDown: TImage;
    tsDestinations: TTabSheet;
    tsHotels: TTabSheet;
    tsBookings: TTabSheet;
    sbDestinations: TScrollBox;
    lblCompare: TLabel;
    imgAboveLeft: TImage;
    imgAboveRight: TImage;
    imgBelowLeft: TImage;
    imgBelowRight: TImage;
    procedure FormCreate(Sender: TObject);
    procedure posHomePageImages();
    procedure initVarsHomePage();
    procedure createMenuBar(AOwner : TComponent; AParent : TWinControl);
    procedure lblDestinationsMouseEnter(Sender: TObject);
    procedure lblDestinationsMouseLeave(Sender: TObject);
    procedure lblHotelsMouseEnter(Sender: TObject);
    procedure lblHotelsMouseLeave(Sender: TObject);
    procedure lblBookingsMouseEnter(Sender: TObject);
    procedure lblBookingsMouseLeave(Sender: TObject);
    procedure shpFindMoreMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblFindMoreClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure createInfoPage();
    procedure imgArrowUpClick(Sender: TObject);
    procedure imgArrowDownClick(Sender: TObject);
    procedure lblDestinationsOnClick(Sender : TObject);
    procedure lblHotelsOnClick(Sender : TObject);
    procedure lblFlightsOnClick(Sender : TObject);
    procedure lblBookingsOnClick(Sender : TObject);
    procedure createDestinationsPage();
    procedure edtLowPriceClick(Sender: TObject);
    procedure edtHighPriceClick(Sender: TObject);
    procedure cbFiltersOnChange(Sender: TObject);
    procedure btnApplyFiltersOnClick(Sender: TObject);
    procedure createHotelPage();
  private
  { Private Scope }
    arrUser : array[1..4] of string;
    { All Destinations }
    cbFilters : TComboBox;
    edtHighPrice, edtLowPrice : TEdit;
    btnApplyFilters : TButton;
    sFilterDestinations : string;
    rLowPrice, rHighPrice : real;
    { Hotels }
    tfile : textfile;
  public
  { Public Scope }
    { Verklaar die kleure sodat alle vorme kan gebruik }
    clPrimary, clSecondary, clAccent, clTextColor : TColor;
    { Menu Bar }
    lblDestinations, lblBookings, lblHotels, lblUserName : TLabel;
    imgTitle, imgProfile : TImage;
    { View Review }
    ireviewcount, iMaxReviewCount : integer;
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
//  pcPages.ActivePageIndex := 0; //! remove uncomment

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

 { init variables }
 ireviewcount := 1;
 iMaxReviewCount := dmData.tblReviews.RecordCount;
 rlowprice := -1;
 rHighPrice := -1;

 { Load Images }
 imgCorner.Picture.LoadFromFile('Assets/cornerDecor.png');
 imgFlyGirl.Picture.LoadFromFile('Assets/flyGirl.png');
 imgPlane.Picture.LoadFromFile('Assets/plane.png');
 imgPlane2.Picture.LoadFromFile('Assets/plane.png');
 imgUnderline.Picture.LoadFromFile('Assets/underline.png');
 imgPlay.Picture.LoadFromFile('Assets/playIcon.png');

  //Destination Page
  edtlowPrice := TEdit.Create(sbDestinations);
  with edtlowPrice do
  begin
    parent := sbDestinations;
    width := 100;
    height := 20;
    left := 180;
    top := 24;
    text := 'Low Price';
    onClick := edtLowPriceClick;
  end;

  edtHighPrice := TEdit.Create(sbDestinations);
  with edtHighPrice do
  begin
    parent := sbDestinations;
    width := 100;
    Height := 20;
    Left := edtLowPrice.Left + edtLowPrice.Width + 7;
    Top := edtLowPrice.Top;
    Text := 'High Price';
    onClick := edtHighPriceClick;
  end;

  cbFilters := TComboBox.Create(sbDestinations);
  with cbFilters do
  begin
    parent := sbDestinations;
    width := 120;
    Height := 50;
    Left := edtLowPrice.Left;
    Top := 75;
    font.Name := 'Roboto';
    Font.Style := [TFontStyle.fsBold];
    text := 'Choose Filter';
    items.Text := 'Price' + #13 + 'Country' + #13 + 'Trip Length';
    OnClick := cbFiltersOnChange;
  end;

  btnApplyFilters := TButton.Create(sbDestinations);
  with btnApplyFilters do
  begin
    parent := sbDestinations;
    width := 50;
    height := edtHighPrice.Height;
    top := edtHighPrice.top;
    left := edtHighPrice.Left + edtHighPrice.Width + 7;
    font.name := 'Roboto';
    font.Style := [TFontStyle.fsBold];
    caption := 'Apply';
    OnClick := btnApplyFiltersOnClick;
  end;

 { positions and scales }
 posHomePageImages();
 initVarsHomePage();
 createInfoPage();
 createDestinationsPage();
 createHotelPage();
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
    //Center horizontal and vertical
    centerComponent(lblFindMore, shpFindMore);
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

procedure TfrmFlylee.lblBookingsOnClick(Sender: TObject);
begin
  pcPages.ActivePageIndex := 4;
end;

procedure TfrmFlylee.lblDestinationsMouseEnter(Sender: TObject);
begin
  lblDestinations.font.color := clAccent;
end;

procedure TfrmFlylee.lblDestinationsMouseLeave(Sender: TObject);
begin
  lblDestinations.font.color := clBlack;
end;

procedure TfrmFlylee.lblDestinationsOnClick(Sender : TObject);
begin
  pcPages.ActivePageIndex := 2;
end;

procedure TfrmFlylee.lblFindMoreClick(Sender: TObject);
begin
  pcPages.TabIndex := 1;
end;

procedure TfrmFlylee.lblFlightsOnClick(Sender: TObject);
begin
  pcPages.ActivePageIndex := 4;
end;

procedure TfrmFlylee.lblHotelsMouseEnter(Sender: TObject);
begin
  lblHotels.font.color := clAccent;
end;

procedure TfrmFlylee.lblHotelsMouseLeave(Sender: TObject);
begin
  lblHotels.font.color := clBlack;
end;

procedure TfrmFlylee.lblHotelsOnClick;
begin
  pcPages.ActivePageIndex := 3;
end;

procedure TfrmFlylee.imgArrowDownClick(Sender: TObject);
begin
  //Kyk of die review bestaan en Decrease die ireviewcount
  dec(ireviewcount);

  // As ireviewcount kleiner as 1 is, stel dit na die maksimum ID
  if ireviewcount < 1 then
    ireviewcount := iMaxReviewCount;

  //Maak die review boks oor met die nuwe review record
  createViewReviewBox(ireviewcount, sbInfo);
end;

procedure TfrmFlylee.imgArrowUpClick(Sender: TObject);
begin
  //Kyk of die review bestaan en Increase die ireviewcount
  inc(ireviewcount);

  // As ireviewcount groter as die maksimum ID is, maak dit 1
  if ireviewcount > iMaxReviewCount then
    ireviewcount := 1;

  //Maak die review boks oor met die nuwe review record
  createViewReviewBox(ireviewcount, sbInfo);
end;

procedure TfrmFlylee.btnApplyFiltersOnClick(Sender: TObject);
var

  ikode : integer;

begin
  { Apply die filters vir die prys range }
  if (edtHighPrice.text <> '') or (edtLowPrice.text <> '') then
  begin
    val(edtLowPrice.text, rLowPrice, ikode);
    if ikode <> 0 then exit;

    try
      rHighPrice := strtofloat(edtHighPrice.text);
    except
      MessageDLG('Please select a price', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
    end;

    { Apply die filters }
    clearScrollBox(sbDestinations);
    createDestinationsPage();
  end;

end;

procedure TfrmFlylee.cbFiltersOnChange(Sender: TObject);
begin
  sFilterDestinations := cbFilters.text;
  clearScrollBox(sbDestinations);
  createDestinationsPage();
end;

procedure TfrmFlylee.createDestinationsPage();
var
  imgCornerDecor, imgCornerIcons : TImage;
  lblPriceRange, lblFilterBy, lblTopDest, lblAllDestinations : TLabel;

  arrDestinations : array[0..100] of string;
  arrHours : array[0..100] of real;
  arrCosts : array[0..100] of real;
  I, ileft, itop, icount : integer;
  irandom, iprevrandom : integer;

begin
  {
   ============================
   Create the Destinations Page
   ============================
  }

  { Images }
  imgCornerDecor := TImage.Create(sbDestinations);
  with imgCornerDecor do
  begin
    parent := sbDestinations;
    Width := imgCorner.Width;
    Height := imgCorner.Height;
    Top := sbDestinations.Top;
    Left := sbDestinations.Width - Width - 21;
    picture.LoadFromFile('Assets/cornerDecor.png');
  end;

  imgCornerIcons := TImage.Create(sbDestinations);
  with imgCornerIcons do
  begin
    parent := sbDestinations;
    top := 50;
    left := sbDestinations.Left + sbDestinations.Width - 230;
    Width := 100;
    Height := 100;
    Picture.LoadFromFile('Assets/decor.png');
  end;

  { Filters }
  lblPriceRange := TLabel.Create(sbDestinations);
  with lblPriceRange do
  begin
    parent := sbDestinations;
    setLabelFont(lblPriceRange, 18, true);
    font.color := clTextColor;
    caption := 'Price Range';
    left := 30;
    top := 20;
  end;

  lblFilterBy := TLabel.Create(sbDestinations);
  with lblFilterBy do
  begin
    parent := sbDestinations;
    setLabelFont(lblFilterBy, 18, true);
    font.color := clTextColor;
    left := 30;
    top := lblPriceRange.Top + lblPriceRange.Height + 20;
    caption := 'Filter By';
  end;

  { Top Destinations }
  lblTopDest := TLabel.Create(sbDestinations);
  with lblTopDest do
  begin
    parent := sbDestinations;
    setLabelFont(lblTopDest, 32, true);
    font.color := clTextColor;
    caption := 'Top Destinations';
    centerComponent(lblTopDest, sbDestinations);
    top := 40;
  end;

  //Create top selling destination boxes
  loadTopDestinations(arrDestinations, arrHours, arrCosts);
  ileft := 70;

  //1 tot 3 want ons soek net die top 3
  for I := 1 to 3 do
  begin
    createDestinationBox(ileft, 125, 'Assets/Travel/' + inttostr(i) + '.jpg', arrDestinations[i-1], floattostr(arrHours[i-1]) + ' Hour Flight' , arrCosts[i-1], sbDestinations);
    inc(ileft, 440);
  end;

  { Show all Destinations }
  lblAllDestinations := TLabel.Create(sbDestinations);
  with lblAllDestinations do
  begin
    parent := sbDestinations;
    setLabelFont(lblAllDestinations, 18, true);
    font.color := clTextColor;
    caption := 'All Destinations';
    left := 30;
    top := 600;
  end;

  loadAllDestinations(arrDestinations, arrHours, arrCosts, icount, sFilterDestinations, rlowprice, rhighprice);
  ileft := 70;
  itop := 650;
  iprevrandom := -1;

  for I := 0 to icount - 1 do
  begin
    //Kry random image maar dit kan nie repeteer nie
    repeat
      irandom := randomrange(1, 11);
    until irandom <> iprevRandom;
    iprevRandom := irandom;

    createDestinationBox(ileft, itop, 'Assets/Travel/' + inttostr(irandom) + '.jpg', arrDestinations[i], floattostr(arrHours[i]) + ' Hour Flight', arrCosts[i], sbDestinations);
    inc(ileft, 440);
    if ((i + 1) mod 3 = 0) and (i <> 0) then
    begin
      inc(itop, 450);
      ileft := 70;
    end;
  end;
end;

procedure TfrmFlylee.createHotelPage();
const
  icount = 14;
var

  arrNames : array[0..14] of string;
  arrCosts : array[0..14] of real;
  shotelname, slocation : string;

begin
  {
   ======================
   Maak die Hotels bladsy
   ======================
  }

  with lblCompare do
  begin
    setLabelFont(lblCompare, 25, true);
    font.Color := clTextColor;
    left := 20;
    top := 20;
  end;

  { Init Images }
  with imgAboveLeft do
  begin
    width := 50;
    Height := 50;
    picture.LoadFromFile('Assets/arrowLeft.png');
    left := 70;
    top := 170;
  end;

  with imgAboveRight do
  begin
    width := 50;
    Height := 50;
    picture.LoadFromFile('Assets/arrowRight.png');
    left := 1260;
    top := 170;
  end;

  with imgBelowLeft do
  begin
    width := 50;
    Height := 50;
    picture.LoadFromFile('Assets/arrowLeft.png');
    left := 70;
    top := 600;
  end;

  with imgBelowRight do
  begin
    width := 50;
    Height := 50;
    picture.LoadFromFile('Assets/arrowRight.png');
    left := 1260;
    top := 600;
  end;

  { Maak die hotel boks met die info }
  getHotelInfo(arrNames, arrCosts, tfile);
  //Unconcatenate die stringe
  shotelname := copy(arrNames[0], 1, pos(',', arrNames[0]) - 1);
  slocation := copy(arrNames[0], pos(',', arrNames[0]) + 1);
  insert(',', slocation, pos(' ', slocation));
  //Maak die boks met die inligting
  createHotelBox(1, shotelname, slocation, arrCosts[0], true, tsHotels);
end;

procedure TfrmFlylee.createInfoPage();
var

  arrDestinations : array[0..100] of string;
  arrHours : array[0..100] of real;
  arrCosts : array[0..100] of real;
  I: Integer;
  ileft : integer;

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
  loadTopDestinations(arrDestinations, arrHours, arrCosts);
  ileft := 70;

  //1 tot 3 want ons soek net die top 3
  for I := 1 to 3 do
  begin
    createDestinationBox(ileft, 800, 'Assets/Travel/' + inttostr(i) + '.jpg', arrDestinations[i-1], floattostr(arrHours[i-1]) + ' Hour Flight' , arrCosts[i-1], sbInfo);
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

  with imgArrowUp do
  begin
    Picture.LoadFromFile('Assets/arrowUp.png');
    width := 35;
    height := 35;
    top := 1380 + 20;
    left := 660 + 600 + 20;
  end;

  with imgarrowdown do
  begin
    Picture.LoadFromFile('Assets/arrowDown.png');
    width := 35;
    height := 35;
    top := imgArrowUp.Top + imgArrowDown.Height + 30;
    left := imgArrowUp.left;
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
    Left := 490;
    Top := 30;
    { procedures }
    OnMouseEnter := lblDestinationsMouseEnter;
    OnMouseLeave := lblDestinationsMouseLeave;
    OnClick := lblDestinationsOnClick;
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
    onClick := lblHotelsOnClick;
  end;

  // Create lblBookings
  lblBookings := TLabel.Create(AOwner);
  with lblBookings do
  begin
    Parent := AParent;
    setLabelFont(lblBookings, 16, true);
    caption := 'Bookings';
    Left := lblHotels.Left + lblHotels.Width + 60;
    Top := 30;
    { procedures }
    OnMouseEnter := lblBookingsMouseEnter;
    OnMouseLeave := lblBookingsMouseLeave;
    OnClick := lblBookingsOnClick;
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

procedure TfrmFlylee.edtHighPriceClick(Sender: TObject);
begin
  edtHighPrice.text := '';
end;

procedure TfrmFlylee.edtLowPriceClick(Sender: TObject);
begin
  edtLowPrice.text := '';
end;

end.
