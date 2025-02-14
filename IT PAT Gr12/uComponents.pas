unit uComponents;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, JPEG, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, DateUtils, Data.DB, Data.Win.ADODB,
  System.Skia, Vcl.Skia, dmData_u, uFunc;

procedure createInfoBox(iLeft : Integer; sImage, sTitle, sSubtitle: string; sbPage : TScrollBox);
procedure createTopSellingBox(iLeft : Integer; sImage, sTitle, sDays : string; rCost : real ; sbPage : TScrollBox);
procedure createViewReviewBox(sbPage : TScrollBox);

implementation

procedure createViewReviewBox(sbPage : TScrollBox);
var

  shpReview : TShape;
  lblMessage : TLabel;
  imgProfile : TImage;

begin
  {
   ==========================================
   Create the review box that people can view
   ==========================================
  }

  //Gaan deur databasis van users, kyk of hulle reviews het, as hulle het wys die user se review, anders skip die user
  //Wys die user se naam, van, profile pic, waarnatoe hy gegaan het en die message
  //Maak ook die arrows vir scroll effect

  shpReview := TShape.Create(sbPage);
  with shpReview do
  begin
    parent := sbpage;
    Pen.Style := psClear;
    shape := stRoundRect;
    width := 700;
    Height := 250;
    left := 500;
    top := 1300;
  end;
end;

procedure createTopSellingBox(iLeft : Integer; sImage, sTitle, sDays : string; rCost : real ; sbPage : TScrollBox);
const
  itop = 800;
var

  imgLocation, imgIcon : TImage;
  shpDesc : TShape;
  lblTitle, lblDays, lblCost : TLabel;

begin
  {
   ===============================
   Maak die Top Destinations boxes
   ===============================
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
    Picture.LoadFromFile('Assets/locationIcon.png');
    stretch := true;
    height := 20;
    width := 20;
    left := shpDesc.Left + 20;
    top := lblTitle.Top + lblTitle.Height + 25;
  end;

  lblDays := TLabel.Create(sbpage);
  with lblDays do
  begin
    parent := sbpage;
    setLabelFont(lblDays, 14, true);
    font.color := rgb(94, 98, 130);
    caption := sDays;
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
