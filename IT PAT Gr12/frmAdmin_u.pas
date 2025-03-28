unit frmAdmin_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, dmData_u,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmAdmin = class(TForm)
    dbGrid: TDBGrid;
    rgSort: TRadioGroup;
    cbSortingOrder: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure rgSortClick(Sender: TObject);
    procedure cbSortingOrderClick(Sender: TObject);
  private
    { Private declarations }
    bSortClick : Boolean;
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;

implementation

{$R *.dfm}

uses frmFlylee_u;

procedure TfrmAdmin.cbSortingOrderClick(Sender: TObject);
begin
  if cbSortingOrder.Checked then
  begin
    caption := 'Sorting in ASC order';
    bSortClick := cbSortingOrder.Checked;
  end
  else begin
    caption := 'Sorting in DESC order';
    bSortClick := cbSortingOrder.Checked;
  end;
  rgSort.ItemIndex := -1;
end;

procedure TfrmAdmin.FormCreate(Sender: TObject);
begin
  { Init Vars }
  bSortClick := false;
  rgSort.ItemIndex := -1;

  { Formateer Components }
  with dbGrid do
  begin
    font.Name := 'Roboto';
    font.Size := 11;
    GradientStartColor := frmFlylee.clPrimary;
    GradientEndColor := frmFlylee.clSecondary;
    FixedColor := clCream;
  end;
end;

procedure TfrmAdmin.rgSortClick(Sender: TObject);
begin
  with dmData do
  begin
    qryData.Active := false;

    if rgSort.ItemIndex = 0 then
    begin
      if bSortClick then
        qryData.SQL.Text := 'select * from tblFlights order by from DESC'
      else
        qryData.SQL.Text := 'select * from tblFlights order by from ASC';
    end
    else if rgSort.ItemIndex = 1 then
    begin
      if bSortClick then
        qryData.SQL.Text := 'select * from tblFlights order by Price DESC'
      else
        qryData.SQL.Text := 'select * from tblFlights order by Price ASC';
    end
    else if rgSort.ItemIndex = 2 then
    begin
      if bSortClick then
        qryData.SQL.Text := 'select * from tblFlights order by tripLength DESC'
      else
        qryData.SQL.Text := 'select * from tblFlights order by tripLength ASC';
    end;

    qryData.Active := True;
  end;

end;
end.
{
with dmData do
begin
  qryData.Active := false;
  qryData.SQL.text := '';
  qryData.Active := true;
end;
}
