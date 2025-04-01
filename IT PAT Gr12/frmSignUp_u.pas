unit frmSignUp_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, System.Skia, Vcl.Skia, DateUtils,
  { Helper Files }
  uFunc, uDBCalls, clsUser_u;

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
    dgOpenDialog: TOpenDialog;
    btnProfilePic: TButton;
    imgProfilePic: TImage;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lblLogInMouseEnter(Sender: TObject);
    procedure lblLogInMouseLeave(Sender: TObject);
    procedure posInputFields(currLabel : TLabel; currEdit : TEdit; ilbltop : integer);
    procedure btbtnGeneratePassClick(Sender: TObject);
    procedure btnSignUpClick(Sender: TObject);
    function isSignUpValidate() : boolean;
    procedure lblLogInClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnProfilePicClick(Sender: TObject);
    procedure posComponents();
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    sFileName : string; //path to profile pic
  public
    { Public declarations }
  end;

var
  frmSignUp: TfrmSignUp;

implementation

{$R *.dfm}

uses dmData_u, frmLogIn_u, frmFlylee_u, frmAdmin_u;

procedure TfrmSignUp.posComponents();
begin
  {
   ===================================
   Position the components on the form
   ===================================
  }

  posInputFields(lblName, edtName, 150);
  posInputFields(lblLastName, edtLastName, 220);
  posInputFields(lblPassword, edtPassword, 290);

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
    left := 55;
    top := edtPassword.top + edtPassword.Height + 25;
  end;

  with dtpBirthDate do
  begin
    top := lblBirthDate.top + lblBirthDate.Height + 8;
    left := 55;
  end;

  with cbNotification do
  begin
    left := btnSignUp.left + btnSignup.Width + 10;
    top := btnSignUp.top + 5;
  end;

  with imgProfilePic do
  begin
    width := 60;
    height := 60;
    top := 75;
    left := 55;
  end;

  with btnProfilePic do
  begin
    font.name := 'Roboto';
    font.Size := 12;
    font.Style := [TFontStyle.fsBold];
    width := 100;
    height := 40;
    left := imgProfilePic.left + imgProfilepic.Width + 20;
    top := 80;
  end;

end;

procedure TfrmSignUp.posInputFields(currLabel : TLabel; currEdit : TEdit; ilbltop : integer);
const

  ispace = 8;
  ileft = 55;

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
  {
   ========================================
   Genereer `n random password vir die user
   ========================================
  }

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
  {
   =======================================
   Plaas die user se data in die databasis
   =======================================
  }

  if isSignUpValidate then
  begin
    spassword := edtPassword.text;

    with dmData do
    begin
      tblUsers.open;
      tblUsers.last;
      tblUsers.Insert;

      tblUsers['flightid'] := 1;
      tblUsers['name'] := edtName.text;
      tblUsers['lastname'] := edtlastname.text;
      tblUsers['isSubscribed'] := cbNotification.Checked;
      tblUsers['birthDate'] := dtpBirthDate.date;
      tblUsers['password'] := hashPassword(spassword);
      tblUsers['isAdmin'] := false;
      tblUsers['totalSpent'] := 0;
      //Save die profile pic
      saveProfilePictoDB(sfilename);

      tblUsers.post;

      iUserId := tblUsers['userid'];
      //Save die user locally
      frmFlylee.objUser := TUser.Create(iuserid);
    end;

    MessageDlg('Sign Up Successful.' + #13 + 'Welcome to Flylee', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK], 0);
    frmFlylee.Show;
    frmSignUp.Hide;
  end
  else
  begin
    MessageDlg('An error has occured with the Sign Up.' + #13 + #9 + 'Please Try Again', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbClose], 0);
  end;

end;

procedure TfrmSignUp.Button1Click(Sender: TObject);
begin
  dmData.iUserId := 13;

  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;

      if tblUsers['userid'] = 13
        then
        frmFlylee.objUser := Tuser.create(13);
  end;

  frmSignUp.Hide;
  frmFlylee.show;
end;

procedure TfrmSignUp.Button2Click(Sender: TObject);
begin
    dmData.iUserId := 13;

  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;

      if tblUsers['userid'] = 13
        then
        frmFlylee.objUser := Tuser.create(13);
  end;

  frmAdmin.show;
  frmSignUp.Hide;
end;

procedure TfrmSignUp.btnProfilePicClick(Sender: TObject);
begin
  {
   ==============================================
   Maak 'File Explorer' oop en kies n profile pic
   ==============================================
  }

  //Mag net PNG file tipes kies
  dgOpenDialog.Filter := 'PNG Images|*.png';
  dgOpenDialog.Title := 'Select a Profile Picture';

  if dgOpenDialog.Execute then
  begin
    //Plaas die image in die image komponent
    imgProfilePic.Picture.LoadFromFile(dgOpenDialog.FileName);
    //maak die file global
    sfilename := dgOpenDialog.filename;
  end;
end;

procedure TfrmSignUp.FormCreate(Sender: TObject);
begin
  {
   ===========
   Form Create
   ===========
  }

  //Load Images
  imgTitle.Picture.LoadFromFile('Assets/logoTitle.png');
  imgCorner.Picture.LoadFromFile('Assets/cornerDecor.png');
  imgPlane.Picture.LoadFromFile('Assets/plane.png');
  imgPlane2.Picture.LoadFromFile('Assets/plane.png');

  //Fix positions of components
  posComponents();
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
    then arrVlags[3] := true;

  //Check age
  iuserage := yearsbetween(date, dtpBirthDate.date);
  if iuserage >= 18
    then arrVlags[4] := true;

  //Check if anything is emtpy
  if (edtName.text = '') or (edtLastName.text = '') or (edtPassword.text = '') then
  begin
    //Maak enige vlag false om sign up te keer
    arrVlags[1] := false;
  end;

  //finaal check of user valid is
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
  lblLogIn.font.color := frmFlylee.clPrimary;
  lblLogIn.font.Style := [TFontStyle.fsUnderline, TFontStyle.fsBold];
end;

procedure TfrmSignUp.lblLogInMouseLeave(Sender: TObject);
begin
  //Revert color and font when mouse leaves
  lblLogIn.font.Color := clBlack;
  lblLogin.font.Style := [TFontStyle.fsBold];
end;

end.
