program frmSignUp_p;

uses
  Vcl.Forms,
  frmSignUp_u in 'frmSignUp_u.pas' {frmSignUp},
  dmData_u in 'dmData_u.pas' {dmData: TDataModule},
  frmLogIn_u in 'frmLogIn_u.pas' {frmLogIn},
  frmFlylee_u in 'frmFlylee_u.pas' {frmFlylee},
  uDBCalls in 'uDBCalls.pas',
  uFunc in 'uFunc.pas',
  uComponents in 'uComponents.pas',
  clsAdvertiser_u in 'clsAdvertiser_u.pas',
  clsUser_u in 'clsUser_u.pas',
  frmAdmin_u in 'frmAdmin_u.pas' {frmAdmin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSignUp, frmSignUp);
  Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfrmLogIn, frmLogIn);
  Application.CreateForm(TfrmFlylee, frmFlylee);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.Run;
end.
