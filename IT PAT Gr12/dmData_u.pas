unit dmData_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmData = class(TDataModule)
    dsUsers: TDataSource;
    adoCon: TADOConnection;
    tblUsers: TADOTable;
    tblStats: TADOTable;
    dsStats: TDataSource;
    tblFlights: TADOTable;
    dsFlights: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
    iUserId : integer;
  end;

var
  dmData: TdmData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
