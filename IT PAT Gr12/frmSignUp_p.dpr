program frmSignUp_p;

uses
  Vcl.Forms,
  frmSignUp_u in 'frmSignUp_u.pas' {frmFlylee},
  dmData_u in 'dmData_u.pas' {dmData: TDataModule},
  frmLogIn_u in 'frmLogIn_u.pas' {frmLogIn};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmFlylee, frmFlylee);
  Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfrmLogIn, frmLogIn);
  Application.Run;
end.
