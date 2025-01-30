program frmSignUp_p;

uses
  Vcl.Forms,
  frmSignUp_u in 'frmSignUp_u.pas' {frmFlylee};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmFlylee, frmFlylee);
  Application.Run;
end.
