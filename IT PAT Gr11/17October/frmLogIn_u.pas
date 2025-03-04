unit frmLogIn_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, dmData_u;

type
  TfrmLogIn = class(TForm)
    imgTopBar: TImage;
    imgGirl: TImage;
    lblNaam: TLabel;
    lblepos: TLabel;
    imgLogo: TImage;
    lblPassword: TLabel;
    pnlLog: TPanel;
    pnlIn: TPanel;
    edtNaam: TEdit;
    edtEpos: TEdit;
    btnLogIn: TButton;
    edtPassword: TEdit;
    imgBack: TImage;
    rgpLogin: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure btnLogInClick(Sender: TObject);
    procedure imgBackClick(Sender: TObject);
    procedure rgpLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogIn: TfrmLogIn;

implementation

{$R *.dfm}

uses frmHealthHarmony_u, frmSignUp_u;

procedure TfrmLogIn.btnLogInClick(Sender: TObject);
var

  sname, semail, spassword : string;
  bfound : Boolean;

begin

  sname := edtNaam.Text;
  semail := edtepos.Text;
  spassword := edtPassword.Text;
  bfound := false;


  if ((sname <> '') or (semail <> '')) and (spassword <> '')
    then
      begin
        with dmData do
          begin
            tblUsers.Open;
            tblUsers.First;
            while (not tblUsers.eof) and (bfound = false) do
              begin
                if (sname = tblUsers['Naam']) and (spassword = tblUsers['Password'])
                  then
                    begin
                      bfound := true;
                      sUserID := tblUsers['GebruikerID'];
                      showmessage('Successfully Logged In');
                      frmHealth.Show;
                      frmLogIn.Hide;
                    end;

                if (semail = tblUsers['Epos']) and (spassword = tblUsers['Password'])
                  then
                    begin
                      bfound := true;
                      sUserID := tblUsers['GebruikerID'];
                      showmessage('Successfully Logged In');
                      frmHealth.Show;
                      frmLogIn.Hide;
                    end;

                tblUsers.Next;
              end;

          end;
      end
      else
        begin
          MessageDlg('Please fill in all required fields', TMsgDlgType.mtError , [mbOk], 0);
        end;

  if bfound = false
    then
      MessageDlg('No user was found', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
  
end;

procedure TfrmLogIn.FormCreate(Sender: TObject);
begin
  rgpLogin.ItemIndex := 0;

  //Load Images
  imgTopBar.Picture.LoadFromFile('images/appBar.png');
  imgTopBar.Stretch := True;

  imgGirl.Picture.LoadFromFile('images/girlTennis.png');
  imgGirl.Stretch := True;

  imgLogo.Picture.LoadFromFile('images/logo.png');
  imgLogo.Stretch := True;

  imgBack.Picture.LoadFromFile('images/back.png');
  imgBack.Stretch := true;

  //Size and Postition
  lblNaam.Left := 35;
  lblepos.Left := 35;
  lblepos.Top := lblNaam.Top;
  lblPassword.Left := 35;
  btnLogIn.Left := 35;

  edtNaam.Left := 35;
  edtEpos.Left := 35;
  edtEpos.Top := edtNaam.Top;
  edtPassword.Left := 35;

  edtNaam.Width := 150;
  edtEpos.Width := 150;
  edtPassword.Width := 150;

  lblepos.Visible := false;
  edtEpos.Visible := false;
end;

procedure TfrmLogIn.imgBackClick(Sender: TObject);
begin
  frmLogIn.Hide;
  frmSignUp.Show;
end;

procedure TfrmLogIn.rgpLoginClick(Sender: TObject);
begin
  case rgpLogin.ItemIndex of
  0 : begin
        //Visible
        lblepos.Visible := false;
        edtEpos.Visible := false;
        lblNaam.Visible := true;
        edtNaam.Visible := true;

      end;
  1 : begin
        //Visible
        lblNaam.Visible := false;
        edtNaam.Visible := false;
        lblepos.Visible := true;
        edtEpos.Visible := true;
      end;
  end;

end;

end.
