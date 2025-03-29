unit frmAdmin_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, dmData_u,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  { Helper Files }
  uFunc, uDBCalls;

type
  TfrmAdmin = class(TForm)
    dbGrid: TDBGrid;
    rgSort: TRadioGroup;
    cbSortingOrder: TCheckBox;
    btbtnSwitch: TBitBtn;
    btnSearch: TButton;
    btbtnClose: TBitBtn;
    btnAdd: TButton;
    pnlSelected: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure rgSortClick(Sender: TObject);
    procedure cbSortingOrderClick(Sender: TObject);
    procedure btbtnSwitchClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    bSortClick : Boolean;
    sTable : string;
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;

implementation

{$R *.dfm}

uses frmFlylee_u;

procedure TfrmAdmin.btbtnSwitchClick(Sender: TObject);
begin
  sTable := inputbox('Table', 'Which table do you want to see?', '');

  if pos('USE', uppercase(sTable)) > 0 then
    sTable := 'tblUsers';
  if pos('FLI', uppercase(sTable)) > 0 then
    sTable := 'tblFlights';
  if pos('REV', uppercase(sTable)) > 0 then
    sTable := 'tblReviews';
  if pos('STAT', uppercase(sTable)) > 0 then
    sTable := 'tblStats';

  pnlSelected.caption := sTable;

  //Verander dan die dbgrid
  with dmData do
  begin
    qryData.Active := false;
    qryData.SQL.text := 'select * from ' + sTable;
    qryData.Active := true;
  end;
end;

procedure TfrmAdmin.btnAddClick(Sender: TObject);
var
  sSQL, sPassword, sHashedPassword, sProfilePic, sDateTime: string;
begin
  if MessageDlg('Do you want to add a record in ' + sTable + '?',
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbNo, TMsgDlgBtn.mbYes], 0) = mrYes
  then
  begin
    with dmData do
    begin
      qryData.Active := False;

      if sTable = 'tblFlights' then
      begin
        sDateTime := InputBox('Date', 'Enter flight date and time (YYYY/MM/DD HH:MM:SS):', '');
        sDateTime := '#' + FormatDateTime('MM/DD/YYYY hh:mm:ss', StrToDateTime(sDateTime)) + '#';

        sSQL := 'INSERT INTO tblFlights ([from], [to], [date], price, tripLength, isFull) VALUES (' +
          QuotedStr(InputBox('From', 'Enter departure location:', '')) + ', ' +
          QuotedStr(InputBox('To', 'Enter destination:', '')) + ', ' +
          sDateTime + ', ' +
          InputBox('Price', 'Enter flight price:', '') + ', ' +
          InputBox('Trip Length', 'Enter trip length:', '') + ', ' +
          InputBox('Is Full', 'Is the flight full? (1=True, 0=False):', '') + ')';

        showmessage(ssql);
      end
      else if sTable = 'tblUsers' then
      begin
        sPassword := InputBox('Password', 'Enter password:', '');
        sHashedPassword := hashPassword(sPassword);

        sProfilePic := '';
        tblUsers.Edit;
        saveProfilePictoDB(sProfilePic);
        tblUsers.Post;

        sSQL := 'INSERT INTO tblUsers (FlightID, Name, LastName, IsSubscribed, BirthDate, Password, IsAdmin, TotalSpent) VALUES (' +
          InputBox('Flight ID', 'Enter Flight ID:', '') + ', ' +
          QuotedStr(InputBox('Name', 'Enter first name:', '')) + ', ' +
          QuotedStr(InputBox('Last Name', 'Enter last name:', '')) + ', ' +
          InputBox('Is Subscribed', 'Is the user subscribed? (1=True, 0=False):', '') + ', ' +
          '#' + InputBox('Birth Date', 'Enter birth date (MM/DD/YYYY):', '') + '#, ' +
          QuotedStr(sHashedPassword) + ', ' +
          InputBox('Is Admin', 'Is the user an admin? (1=True, 0=False):', '') + ', ' +
          InputBox('Total Spent', 'Enter total amount spent:', '') + ')';

        showmessage(ssql);
      end
      else if sTable = 'tblReviews' then
      begin
        sSQL := 'INSERT INTO tblReviews (UserID, FlightID, Message, To, ReviewDate, WouldRecommend) VALUES (' +
          InputBox('User ID', 'Enter User ID:', '') + ', ' +
          InputBox('Flight ID', 'Enter Flight ID:', '') + ', ' +
          QuotedStr(InputBox('Message', 'Enter review message:', '')) + ', ' +
          QuotedStr(InputBox('To', 'Enter recipient:', '')) + ', ' +
          '#' + InputBox('Review Date', 'Enter review date (MM/DD/YYYY):', '') + '#, ' +
          InputBox('Would Recommend', 'Would recommend? (1=True, 0=False):', '') + ')';
      end
      else if sTable = 'tblStats' then
      begin
        sSQL := 'INSERT INTO tblStats (FlightID, Destination, Clicks, Bookings, DateRecorded, Revenue, DiscountApplied) VALUES (' +
          InputBox('Flight ID', 'Enter Flight ID:', '') + ', ' +
          QuotedStr(InputBox('Destination', 'Enter destination:', '')) + ', ' +
          InputBox('Clicks', 'Enter number of clicks:', '') + ', ' +
          InputBox('Bookings', 'Enter number of bookings:', '') + ', ' +
          '#' + InputBox('Date Recorded', 'Enter date recorded (MM/DD/YYYY):', '') + '#, ' +
          InputBox('Revenue', 'Enter revenue amount:', '') + ', ' +
          InputBox('Discount Applied', 'Was discount applied? (1=True, 0=False):', '') + ')';
      end
      else
      begin
        ShowMessage('Invalid table selected.');
        Exit;
      end;

      qryData.SQL.Text := sSQL;
      qryData.ExecSQL;
      ShowMessage('Record added successfully!');
    end;
  end;

end;

procedure TfrmAdmin.btnSearchClick(Sender: TObject);
var
  iid: integer;
  sField: string;
begin
  iid := StrToInt(inputbox('Record ID','What ID of the record do you want to see?', ''));

  if sTable = 'tblFlights' then
    sField := 'FlightID'
  else if sTable = 'tblUsers' then
    sField := 'UserID'
  else
    sField := 'ID';

  with dmData do
  begin
    qryData.Active := False;
    qryData.SQL.Text := 'select * from ' + sTable + ' where ' + sField + ' = ' + IntToStr(iid);
    qryData.Active := True;
  end;
end;

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
  sTable := 'tblFlights';

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
