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
    lblFindMore: TLabel;
    imgPlay: TImage;
    lblInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure posScaleImages();
    procedure initVarsHomePage();
    procedure setLabelFont(currLabel : TLabel; isize: integer; bBold: boolean);
    procedure centerComponent(AControl, AParent: TControl);
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
 imgPlay.Picture.LoadFromFile('Assets/playIcon.png');

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
    setlabelFont(lblTitle, 60, true);
    font.color := rgb(24,30,75);
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
    setLabelFont(lblAbout, 14, false);
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
    Pen.Style := psClear;
  end;

  with shpPlay do
  begin
    brush.color := frmSignUp.clSecondary;
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
    height := 15;
    width := 15;
    centerComponent(imgPlay, shpPlay);
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

//Set die font van die label ingevoer
procedure TfrmFlylee.setLabelFont(currLabel : TLabel; isize: integer; bBold: boolean);
begin
  //Kyk of die label bestaan
  if Assigned(currLabel) then
    with currLabel.Font do
    begin
      //Stel die font
      Name := 'Roboto';
      Size := isize;
      //Kies of dit bold moet wees of nie
      if bBold then
        Style := [TFontStyle.fsBold]
      else
        Style := [];
    end;
end;

//Sentreer komponent bo op sy ouer
procedure TfrmFlylee.centerComponent(AControl, AParent: TControl);
begin
  //Kyk of die komponente bestaan
  if Assigned(AControl) and Assigned(AParent) then
  begin
    //Sentreer vertikaal
    AControl.Left := AParent.Left + (AParent.Width - AControl.Width) div 2;
    //Sentreer horisontaal
    AControl.Top := AParent.Top + (AParent.Height - AControl.Height) div 2;
  end;
end;

end.
