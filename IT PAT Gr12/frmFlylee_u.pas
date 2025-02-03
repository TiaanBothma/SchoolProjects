unit frmFlylee_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TfrmFlylee = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFlylee: TfrmFlylee;

implementation

{$R *.dfm}

procedure TfrmFlylee.FormCreate(Sender: TObject);
begin
 //Form Create
end;

end.
