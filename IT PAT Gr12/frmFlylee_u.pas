unit frmFlylee_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Tabs, Vcl.ExtCtrls, pngimage,
  Vcl.StdCtrls, Vcl.Buttons;

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
    imgTitle: TImage;
    lblAbout: TLabel;
    shpFindMore: TShape;
    shpPlay: TShape;
    procedure FormCreate(Sender: TObject);
    procedure posScaleImages();
    procedure initVarsHomePage();

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFlylee: TfrmFlylee;

implementation

{$R *.dfm}

uses frmSignUp_u;

procedure TfrmFlylee.FormCreate(Sender: TObject);
begin
 //inti variables
 initVarsHomePage();

 //LoadImages
 imgCorner.Picture.LoadFromFile('Assets/cornerDecor.png');
 imgFlyGirl.Picture.LoadFromFile('Assets/flyGirl.png');
 imgPlane.Picture.LoadFromFile('Assets/plane.png');
 imgPlane2.Picture.LoadFromFile('Assets/plane.png');
 imgUnderline.Picture.LoadFromFile('Assets/underline.png');
 imgTitle.Picture.LoadFromFile('Assets/logoTitle.png');

 //positions and scales
 posScaleImages();

 imgUnderline.top := 245;
 imgUnderline.left := 320;
end;

procedure TfrmFlylee.initVarsHomePage();
begin
  //Initialize home page variables and comps
  with lblTitle do
  begin
    Caption := 'Travel, enjoy' + #13 + 'and live a new' + #13 + 'experience now';
    font.name := 'Roboto';
    font.size := 60;
    font.color := rgb(24,30,75);
    font.style := [TFontStyle.fsBold];
    top := 170;
    left := 100;
  end;

  with lblTopTitle do
  begin
    Caption := 'BEST DESTINATIONS AROUND THE WORLD';
    font.size := 16;
    font.Style := [TFontStyle.fsBold];
    font.Color := frmSignUp.clSecondary;
    left := 100;
    top := 150;
  end;

  with lblAbout do
  begin
    caption := 'We provide the best flights with ease so you don''t have to. We work' + #13 + 'with weather and shipping companies to predict the best flights.';
    font.name := 'Roboto';
    Font.size := 14;
    font.color := rgb(24,30,75);
    top := 470;
    left := 100;
  end;

  with shpFindMore do
  begin
    brush.Color := frmSignUP.clPrimary;
    height := 60;
    width := 170;
    left := 100;
    top := 540;
  end;
end;

procedure TfrmFlylee.posScaleImages();
begin
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

end.
