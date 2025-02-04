unit frmSignUp_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, DateUtils, IdHashMessageDigest, IdGlobal;

type
  TfrmSignUp = class(TForm)
    imgCorner: TImage;
    imgTitle: TImage;
    imgPlane: TImage;
    imgPlane2: TImage;
    lblTitle: TLabel;
    edtName: TEdit;
    lblAccount: TLabel;
    lblLogIn: TLabel;
    lblName: TLabel;
    lblLastName: TLabel;
    edtLastName: TEdit;
    lblPassword: TLabel;
    edtPassword: TEdit;
    btbtnGeneratePass: TBitBtn;
    btnSignUp: TButton;
    dtpBirthDate: TDateTimePicker;
    lblBirthDate: TLabel;
    cbNotification: TCheckBox;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lblLogInMouseEnter(Sender: TObject);
    procedure lblLogInMouseLeave(Sender: TObject);
    //Custom Procedures
    procedure posSignUpOptions(currLabel : TLabel; currEdit : TEdit; ilbltop : integer);
    procedure btbtnGeneratePassClick(Sender: TObject);
    function hashPassword(spassword : string) : string;
    procedure btnSignUpClick(Sender: TObject);
    function isSignUpValidate() : boolean;
    procedure lblLogInClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    clPrimary, clSecondary, clAccent : TColor;
  end;

var
  frmSignUp: TfrmSignUp;

implementation

{$R *.dfm}

uses dmData_u, frmLogIn_u, frmFlylee_u;

procedure TfrmSignUp.posSignUpOptions(currLabel : TLabel; currEdit : TEdit; ilbltop : integer);
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

procedure TfrmSignUp.btbtnGeneratePassClick(Sender: TObject);
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

procedure TfrmSignUp.btnSignUpClick(Sender: TObject);
var

  spassword : string;

begin

  if isSignUpValidate then
  begin
    spassword := edtPassword.text;

    with dmData do
    begin
      tblUsers.open;
      tblUsers.last;
      tblUsers.Insert;

      tblUsers['name'] := edtName.text;
      tblUsers['lastname'] := edtlastname.text;
      tblUsers['isSubscribed'] := cbNotification.Checked;
      tblUsers['birthDate'] := dtpBirthDate.date;
      tblUsers['password'] := hashPassword(spassword);

      tblUsers.post;
    end;

    MessageDlg('Sign Up Successful.' + #13 + 'Welcome to Flylee',TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK], 0);
  end
  else
  begin
    MessageDlg('An error has occured with the Sign Up.' + #13 + #9 + 'Please Try Again', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbClose], 0);
  end;

end;

procedure TfrmSignUp.Button1Click(Sender: TObject);
begin
  dmData.iUserId := 3;
  frmSignUp.Hide;
  frmFlylee.show;
end;

procedure TfrmSignUp.FormCreate(Sender: TObject);
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

  with lblBirthDate do
  begin
    font := lblName.font;
    left := 40;
    top := edtPassword.top + edtPassword.Height + 25;
  end;

  with dtpBirthDate do
  begin
    top := lblBirthDate.top + lblBirthDate.Height + 8;
    left := 40;
  end;

  with cbNotification do
  begin
    left := btnSignUp.left + btnSignup.Width + 10;
    top := btnSignUp.top + 5;
  end;

end;

function TfrmSignUp.hashPassword(spassword : string): string;
var

  salt: string;
  md5: TIdHashMessageDigest5;

begin
  //n 'Salt' is n random string wat binne n password geplaas word sodat dit langer vat of moeiliker is om die password te 'crack'
  salt := 'random-salt';

  //MD5 hashing is een manier in Delphi om die salt en die password saam te hash
  md5 := TIdHashMessageDigest5.Create;

  //Concatenate die password en die salt
  Result := md5.HashStringAsHex(spassword + salt);

  //Gooi die md5 object uit die RAM uit
  md5.Free;
end;

function TfrmSignUp.isSignUpValidate: boolean;
var

  arrVlags : array[1..4] of Boolean;
  I, iUserAge: Integer;

begin
  for I := 1 to 4 do
  arrVlags[i] := false;

  //Check first name
  if pos(' ', edtName.Text) = 0
    then arrVlags[1] := true;

  //Check lastname
  if pos(' ', edtlastname.Text) = 0
    then arrVlags[2] := true;

  //Check password
  if length(edtPassword.Text) >= 8
    then arrVlags[3] := true
  else arrVlags[3] := true; //!remove

  //Check age
  iuserage := yearsbetween(date, dtpBirthDate.date);
  if iuserage >= 18
    then arrVlags[4] := true;


  //check if user is valid
  for I := 1 to 4 do
  begin
    if arrVlags[i] <> true
      then
      begin
        result := false;
      end;
  end;

  //if program hasn't exit-ed yet then the result can be true
  result := true;

end;

procedure TfrmSignUp.lblLogInClick(Sender: TObject);
begin
  frmLogin.show;
  frmSignup.hide;
end;

procedure TfrmSignUp.lblLogInMouseEnter(Sender: TObject);
begin
  //Change font and color when hovered over
  lblLogIn.font.color := clPrimary;
  lblLogIn.font.Style := [TFontStyle.fsUnderline, TFontStyle.fsBold];
end;

procedure TfrmSignUp.lblLogInMouseLeave(Sender: TObject);
begin
  //Revert color and font when mouse leaves
  lblLogIn.font.Color := clBlack;
  lblLogin.font.Style := [TFontStyle.fsBold];
end;

end.
