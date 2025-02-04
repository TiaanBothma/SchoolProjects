unit frmFlylee_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Tabs, Vcl.ExtCtrls, pngimage;

type
  TfrmFlylee = class(TForm)
    pcPages: TPageControl;
    tsHome: TTabSheet;
    imgCorner: TImage;
    imgFlyGirl: TImage;
    imgPlane: TImage;
    imgPlane2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure posScaleImages();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFlylee: TfrmFlylee;

implementation

{$R *.dfm}

procedure TfrmFlylee.FormCreate(Sender: TObject);
begin
 //inti variables

 //LoadImages
 imgCorner.Picture.LoadFromFile('Assets/cornerDecor.png');
 imgFlyGirl.Picture.LoadFromFile('Assets/flyGirl.png');
 imgPlane.Picture.LoadFromFile('Assets/plane.png');
 imgPlane2.Picture.LoadFromFile('Assets/plane.png');

 //positions and scales
 posScaleImages();
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
    Top := 27;
    Left := 584;
  end;

  with imgPlane do
  begin
    Width := 170;
    Height := 170;
    Top := 72;
    Left := 656;
  end;

  with imgPlane2 do
  begin
    Width := 170;
    Height := 170;
    Top := 144;
    Left := 1112;
  end;
end;

end.
