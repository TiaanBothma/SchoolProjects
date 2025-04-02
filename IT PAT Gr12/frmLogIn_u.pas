unit frmLogIn_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, pngimage, IdHashMessageDigest, IdGlobal, clsUser_u,
  clsAdvertiser_u;

type
  TfrmLogIn = class(TForm)
    imgCorner: TImage;
    imgPlane2: TImage;
    imgPlane: TImage;
    lblTitle: TLabel;
    imgTitle: TImage;
    btnLogIn: TButton;
    lblAccount: TLabel;
    lblSignUp: TLabel;
    lblName: TLabel;
    edtName: TEdit;
    lblPassword: TLabel;
    edtPassword: TEdit;
    procedure FormCreate(Sender: TObject);
    //My procedures
    function verifyPassword(storedHash, spassword: string): Boolean;
     procedure posInputFields(currLabel : TLabel; currEdit : TEdit; ilbltop : integer);
    procedure lblSignUpClick(Sender: TObject);
    procedure lblSignUpMouseEnter(Sender: TObject);
    procedure lblSignUpMouseLeave(Sender: TObject);
    procedure btnLogInClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogIn: TfrmLogIn;

implementation

{$R *.dfm}

uses frmSignUp_u, dmData_u, frmFlylee_u;

procedure TfrmLogIn.lblSignUpClick(Sender: TObject);
begin
  frmSignUp.Show;
  frmLogIn.Hide;
end;

procedure TfrmLogIn.lblSignUpMouseEnter(Sender: TObject);
begin
  //Change font and color when hovered over
  lblSignUp.font.color := frmFlylee.clPrimary;
  lblSignUp.font.Style := [TFontStyle.fsUnderline, TFontStyle.fsBold];
end;

procedure TfrmLogIn.lblSignUpMouseLeave(Sender: TObject);
begin
  //Revert color and font when mouse leaves
  lblSignUp.font.Color := clBlack;
  lblSignUp.font.Style := [TFontStyle.fsBold];
end;

procedure TfrmLogIn.posInputFields(currLabel: TLabel; currEdit: TEdit;
  ilbltop: integer);
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

function TfrmLogIn.verifyPassword(storedHash, spassword: string): Boolean;
var

  salt: string;
  md5: TIdHashMessageDigest5;
  hashedInputPassword: string;

begin
  {
   Hash die password wat in die edit staan en kyk of dit ooreenstem met die storedHash
  }

  // Retrieve the salt
  salt := 'random-salt';

  md5 := TIdHashMessageDigest5.Create;

  // Hash die password met die selfde salt as voorheen
  hashedInputPassword := md5.HashStringAsHex(spassword + salt);

  // Compare die hashes met mekaar
  Result := (storedHash = hashedInputPassword);

  md5.Free;
end;

procedure TfrmLogIn.btnLogInClick(Sender: TObject);
var

  bfound : boolean;

begin
  bfound := false;

  if (edtName.text = '') or (edtPassword.text = '')
  then begin
    showmessage('Please fill in fields');
    exit;
  end;


  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;

    while (not tblUsers.Eof) and (bfound = false) do
    begin
      //Check of the hashed password met die edit password ooreenstem
      if (verifyPassword(tblUsers['password'], edtpassword.text)) and (tblUsers['name'] = edtName.text)
        then begin
          //Die user is gevind hou op soek
          bfound := true;
          //Allocate die user id aan die user sodat later kan opspoor wie die persoon is
          iUserid := tblUsers['userId'];

          { User Object }
          frmFlylee.objUser := TUser.create(iuserid);
          { Advert object }
          frmFlylee.objAdvertiser := TAdvertiser.Create('Coca Cola', 'Medium', 2);

          MessageDlg('Logged In! Welcome back ' + edtName.text, TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
          frmFlylee.Show;
          frmLogIN.hide;
        end;

      tblUsers.next;
    end;
  end;

  if bfound = false
    then MessageDLG('Account not found, try making an account first!', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);

end;

procedure TfrmLogIn.FormCreate(Sender: TObject);
begin
  //Load Images
  imgPlane.Picture.LoadFromFile('Assets/plane.png');
  imgPlane2.Picture.LoadFromFile('Assets/plane.png');
  imgTitle.Picture.LoadFromFile('Assets/logoTitle.png');
  imgCorner.Picture.LoadFromFile('Assets/cornerDecor.png');

  //Load positions and size (copy frmSignUp)
  with imgCorner do
  begin
    Height := frmSignUp.imgCorner.Height;
    Width := frmSignUp.imgCorner.Width;
    Top := frmSignUp.imgCorner.Top;
    Left := frmSignUp.imgCorner.Left;
  end;

  with imgPlane do
  begin
    Height := frmSignUp.imgPlane.Height;
    Width := frmSignUp.imgPlane.Width;
    Top := frmSignUp.imgPlane.Top;
    Left := frmSignUp.imgPlane.Left;
  end;

  with imgPlane2 do
  begin
    Height := frmSignUp.imgPlane2.Height;
    Width := frmSignUp.imgPlane2.Width;
    Top := frmSignUp.imgPlane2.Top;
    Left := frmSignUp.imgPlane2.Left;
  end;

  with imgTitle do
  begin
    Height := frmSignUp.imgTitle.Height;
    Width := frmSignUp.imgTitle.Width;
    Top := frmSignUp.imgTitle.Top;
    Left := frmSignUp.imgTitle.Left;
  end;

  with lblTitle do
  begin
    Font := frmSignup.lblTitle.font;
    Height := frmSignUp.lblTitle.Height;
    Width := frmSignUp.lblTitle.Width;
    Top := frmSignUp.lblTitle.Top;
    Left := frmSignUp.lblTitle.Left + 30;
  end;

  with btnLogIn do
  begin
    Font := frmSignup.btnSignUp.font;
    Height := frmSignUp.btnSignUp.Height;
    Width := frmSignUp.btnSignUp.Width;
    Top := frmSignUp.btnSignUp.Top;
    Left := frmSignUp.btnSignUp.Left;
  end;

  with lblAccount do
  begin
    Font := frmSignup.lblAccount.font;
    Height := frmSignUp.lblAccount.Height;
    Width := frmSignUp.lblAccount.Width;
    Top := frmSignUp.lblAccount.Top;
    Left := frmSignUp.lblAccount.Left;
  end;

  with lblSignUp do
  begin
    Font := frmSignup.lblLogIn.font;
    Top := frmSignUp.lblLogIn.Top;
    Left := frmSignUp.lblLogIn.Left - 20;
  end;

  posInputFields(lblName, edtName, 100);
  posInputFields(lblPassword, edtPassword, 170);
end;

end.
