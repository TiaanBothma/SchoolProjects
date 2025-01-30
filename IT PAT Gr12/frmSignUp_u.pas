unit frmSignUp_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, Vcl.StdCtrls;

type
  TfrmFlylee = class(TForm)
    imgCorner: TImage;
    imgTitle: TImage;
    imgPlane: TImage;
    imgPlane2: TImage;
    lblTitle: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    clPrimary, clSecondary, clAccent : TColor;
  end;

var
  frmFlylee: TfrmFlylee;

implementation

{$R *.dfm}

procedure TfrmFlylee.FormCreate(Sender: TObject);
begin
  //Load Colors
  clPrimary := rgb(255,169,15); //Web Orange
  clSecondary := rgb(223,105,81); //Burnt Sienna
  clAccent := rgb(0,99,128); //Cerulean

  //Load Images
  imgTitle.Picture.LoadFromFile('Assets/logoTitle.png');
  imgCorner.Picture.LoadFromFile('Assets/cornerDecor.png');
  imgPlane.Picture.LoadFromFile('Assets/plane.png');
  imgPlane2.Picture.LoadFromFile('Assets/plane.png');
end;

end.
