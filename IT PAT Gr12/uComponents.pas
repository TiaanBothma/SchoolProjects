unit uComponents;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, JPEG, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, DateUtils, Data.DB, Data.Win.ADODB,
  System.Skia, Vcl.Skia, dmData_u, uFunc;

procedure createInfoBox(iLeft : Integer; sImage, sTitle, sSubtitle: string; sbPage : TScrollBox);
procedure createTopSellingBox(iLeft : Integer; sImage, sTitle, sDays : string; rCost : real ; sbPage : TScrollBox);

implementation

procedure createTopSellingBox(iLeft : Integer; sImage, sTitle, sDays : string; rCost : real ; sbPage : TScrollBox);
const
  itop = 800;
var

  imgLocation : TImage;
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
    height := 170;
    top := imgLocation.Top + imgLocation.Height - 40;
    left := ileft;
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
