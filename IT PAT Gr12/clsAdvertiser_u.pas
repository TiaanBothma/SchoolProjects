unit clsAdvertiser_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Tabs, Vcl.ExtCtrls, dmData_u,
  { Helper Files }
  uDBCalls;

  type
  TAdvertiser = class(TObject)
    private
      { Attributes }
      fName : string;
      fAdSize : string;
      fFlightID : integer;
      fTotalCost : real;
      fImage : string;

    public
      { Constructor }
      constructor Create(sName, sAdSize: string; iFlightID: integer); overload;
      constructor Create(); overload;

      { Assessors }
      function getName() : string;
      function getCost() : real;
      function getImage() : string;
      function getFlightDestination() : string;
      function getSize() : string;

      { Mutators }
      procedure setName(sname : string);
      procedure setFlightID(iflightId : integer);
      procedure setAdSize(sAdSize : string);

      { Auxillary }
      procedure calculateCost();
      procedure showAdvertCost(Sender : TObject);
      procedure changeAdvertWarning(Sender : TObject);
end;

  const
    rBaseRate = 100;
    sSmallAd = 50;
    sMediumAd = 100;
    sLargeAd = 200;

implementation

{ TAdvertiser }

constructor TAdvertiser.Create(sName, sAdSize: string; iFlightID: integer);
begin
  inherited Create;
  fName := sName;
  fAdSize := sAdSize;
  fFlightID := iFlightID;

  fimage := 'Assets/advertiser.png';
end;

procedure TAdvertiser.changeAdvertWarning(Sender: TObject);
begin
  MessageDLG('Flylee is not accepting new adverts right now.', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
end;

constructor TAdvertiser.Create;
begin
  inherited Create;
  fName := '';
  fAdSize := '';
  fFlightID := 0;
  fTotalCost := 0;
  fimage := 'Assets/advertiser.png';
end;

function TAdvertiser.getName: string;
begin
  Result := fName;
end;

function TAdvertiser.getSize: string;
begin
  result := fAdSize;
end;

function TAdvertiser.getCost: real;
begin
  Result := fTotalCost;
end;

function TAdvertiser.getFlightDestination: string;
begin
  //Kry die destination van die flight waarop die advert is
  with dmData do
  begin
    tblFlights.open;
    tblFlights.first;

    while not tblFlights.Eof do
    begin
      if tblFlights['flightid'] = fFlightID
        then begin
          //Stuur die destination terug
          result := tblFlights['to'];

          //Hou op soek as die regte rekord gevind is
          break;
        end;

      tblFlights.next;
    end;
  end;

end;

function TAdvertiser.getImage: string;
begin
  result := fimage;
end;

procedure TAdvertiser.setName(sName: string);
begin
  fName := sName;
end;

procedure TAdvertiser.showAdvertCost(Sender : TObject);
begin
  calculateCost();
  showmessage('This advertiser owes: ' + floattostrf(getCost, ffCurrency, 8, 2));
end;

procedure TAdvertiser.setFlightID(iFlightId: integer);
begin
  fFlightID := iFlightId;
end;

procedure TAdvertiser.setAdSize(sAdSize: string);
begin
  fAdSize := sAdSize;
end;

procedure TAdvertiser.calculateCost();
var
  iDuration : integer;
begin
  //Kry die totale koste wat die advertiser moet betaal
  iDuration := getFlightDuration(fFlightID);

  if fAdSize = 'Small'
    then fTotalCost := rBaseRate * iDuration + sSmallAd

  else if fAdSize = 'Medium'
    then fTotalCost := rBaseRate * iDuration + sMediumAd

  else if fAdSize = 'Large'
    then fTotalCost := rBaseRate * iDuration + sLargeAd

  else
    fTotalCost := rBaseRate * iDuration;

end;
end.
