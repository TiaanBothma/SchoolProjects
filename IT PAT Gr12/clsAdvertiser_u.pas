unit clsAdvertiser_u;

interface

uses
  System.SysUtils;

  type
  TAdvertiser = class(TObject)
    private
      { Attributes }
      fName : string;
      fAdSize : string;
      fFlightID : integer;
      fFlightDuration : real;
      fTotalCost : real;

    public
      { Constructor }
      constructor Create(sName, sAdSize : string; iFlightID : integer; rFlightDuration : real); overload;
      constructor Create(); overload;

      { Assessors }
      function getName() : string;
      function getCost() : real;

      { Mutators }
      procedure setName(sname : string);
      procedure setFlightID(iflightId : integer);
      procedure setAdSize(sAdSize : string);
      procedure setFlightDuration(rFlightDuration: real);

      { Auxillary }
      procedure calculateCost();
end;

  const
    rBaseRate = 100;
    sSmallAd = 50;
    sMediumAd = 100;
    sLargeAd = 200;

implementation

{ TAdvertiser }

constructor TAdvertiser.Create(sName, sAdSize: string; iFlightID: integer; rFlightDuration: real);
begin
  inherited Create;
  fName := sName;
  fAdSize := sAdSize;
  fFlightID := iFlightID;
  fFlightDuration := rFlightDuration;
end;

constructor TAdvertiser.Create;
begin
  inherited Create;
  fName := '';
  fAdSize := '';
  fFlightID := 0;
  fFlightDuration := 0;
  fTotalCost := 0;
end;

function TAdvertiser.getName: string;
begin
  Result := fName;
end;

function TAdvertiser.getCost: real;
begin
  Result := fTotalCost;
end;

procedure TAdvertiser.setName(sName: string);
begin
  fName := sName;
end;

procedure TAdvertiser.setFlightID(iFlightId: integer);
begin
  fFlightID := iFlightId;
end;

procedure TAdvertiser.setAdSize(sAdSize: string);
begin
  fAdSize := sAdSize;
end;

procedure TAdvertiser.setFlightDuration(rFlightDuration: real);
begin
  fFlightDuration := rFlightDuration;
end;

procedure TAdvertiser.calculateCost();
begin

  if fAdSize = 'Small'
    then fTotalCost := rBaseRate * fFlightDuration + sSmallAd

  else if fAdSize = 'Medium'
    then fTotalCost := rBaseRate * fFlightDuration + sMediumAd

  else if fAdSize = 'Large'
    then fTotalCost := rBaseRate * fFlightDuration + sLargeAd

  else
    fTotalCost := rBaseRate * fFlightDuration;

end;
end.
