unit frmSignUp_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, DateUtils, IdHashMessageDigest, IdGlobal;

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
    dtpBirthDate: TDateTimePicker;
    lblBirthDate: TLabel;
    cbNotification: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure lblLogInMouseEnter(Sender: TObject);
    procedure lblLogInMouseLeave(Sender: TObject);
    //Custom Procedures
    procedure posSignUpOptions(currLabel : TLabel; currEdit : TEdit; ilbltop : integer);
    procedure btbtnGeneratePassClick(Sender: TObject);
    function hashPassword(spassword : string) : string;
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

function TfrmFlylee.hashPassword(spassword : string): string;
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

function TfrmFlylee.isSignUpValidate: boolean;
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

{
function TfrmFlylee.verifyPassword(storedHash, spassword: string): Boolean;
var
  salt: string;
  md5: TIdHashMessageDigest5;
  hashedInputPassword: string;
begin
  // Retrieve the salt (from the database or wherever you stored it)
  salt := 'some-random-salt';  // Ensure you use the same salt that was used during hashing

  md5 := TIdHashMessageDigest5.Create;

  // Hash the input password with the same salt
  hashedInputPassword := md5.HashStringAsHex(spassword + salt);

  // Compare the hashes
  Result := (storedHash = hashedInputPassword);

  md5.Free;
end;
}
