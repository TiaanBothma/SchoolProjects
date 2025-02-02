unit frmSignUp_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, Vcl.StdCtrls,
  Vcl.Buttons;

type
  TfrmFlylee = class(TForm)
    imgCorner: TImage;
    imgTitle: TImage;
    imgPlane: TImage;
    imgPlane2: TImage;
    lblTitle: TLabel;
    edtName: TEdit;
    lblAlready: TLabel;
    lblLogIn: TLabel;
    lblName: TLabel;
    lblLastName: TLabel;
    edtLastName: TEdit;
    lblPassword: TLabel;
    edtPassword: TEdit;
    btbtnGeneratePass: TBitBtn;
    btnSignUp: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lblLogInMouseEnter(Sender: TObject);
    procedure lblLogInMouseLeave(Sender: TObject);
    //Custom Procedures
    procedure posSignUpOptions(currLabel : TLabel; currEdit : TEdit; ilbltop : integer);
    procedure btbtnGeneratePassClick(Sender: TObject);
    function hashPassword() : string;
    procedure btnSignUpClick(Sender: TObject);
    function isSignUpValidate() : boolean;
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

uses dmData_u;

procedure TfrmFlylee.posSignUpOptions(currLabel : TLabel; currEdit : TEdit; ilbltop : integer);
const

  ispace = 8;
  ileft = 40;

begin
  //Fix label position and size
  with currLabel do
  begin
    Left := ileft;
    top := ilbltop;
    font := lblName.font;
  end;


  //Fix editbox position and size
  with currEdit do
  begin
    height := 25;
    width := 180;

    Left := ileft;
    top := currLabel.Top + currLabel.Height + ispace;
  end;

end;

procedure TfrmFlylee.btbtnGeneratePassClick(Sender: TObject);
var

  spass, schars : string;
  I: Integer;

begin
  schars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefgihjklmnopqrstuvwxyz1234567890!@$%^&*()[]{}';

  for I := 1 to 8 do
  begin
    spass := spass + schars[random(length(schars)) + 1];
  end;

  edtPassword.text := spass;

end;

procedure TfrmFlylee.btnSignUpClick(Sender: TObject);
begin



  with dmData do
  begin
    tblUsers.open;
    while not tblUsers.Eof do
    begin
      tblUsers.last;
      tblUsers.Insert;

      tblUsers['name'] := edtName.text;

      tblUsers.post;
    end;
  end;

end;

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

  //Fix positions of components
  posSignUpOptions(lblName, edtName, 100);
  posSignUpOptions(lblLastName, edtLastName, 170);
  posSignUpOptions(lblPassword, edtPassword, 240);

  with btbtnGeneratePass do
  begin
    Height := 25;
    Width := 25;

    //Postition generate button next to pass edit
    left := edtPassword.left + edtPassword.Width + 5;
    top := edtPassword.top;
  end;

end;

function TfrmFlylee.hashPassword(): string;
begin
  //Hash the password
  //Use salt and sha256 and utf8
end;

function TfrmFlylee.isSignUpValidate: boolean;
var

  arrVlags : array[1..5] of Boolean;
  I: Integer;

begin
  for I := 1 to 5 do
  arrVlags[i] := false;


  //Check first name
  if pos(' ', edtName.Text) = 0
    then arrVlags[1] := true;

  //Check lastname


  //Check password

  //check if user is valid
  for I := 1 to 5 do
  begin
    if arrVlags[i] <> true
      then
      begin
        result := false;
        exit;
      end;
  end;

  //if program hasn't exit-ed yet then the result can be true
  result := true;

end;

procedure TfrmFlylee.lblLogInMouseEnter(Sender: TObject);
begin
  //Change font and color when hovered over
  lblLogIn.font.color := clPrimary;
  lblLogIn.font.Style := [TFontStyle.fsUnderline, TFontStyle.fsBold];
end;

procedure TfrmFlylee.lblLogInMouseLeave(Sender: TObject);
begin
  //Revert color and font when mouse leaves
  lblLogIn.font.Color := clBlack;
  lblLogin.font.Style := [TFontStyle.fsBold];
end;

end.
