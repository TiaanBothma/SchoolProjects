unit frmFlylee_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Tabs, Vcl.ExtCtrls, pngimage, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmFlylee = class(TForm)
    pcPages: TPageControl;
    tsHome: TTabSheet;
    imgCorner: TImage;
    imgFlyGirl: TImage;
    imgPlane: TImage;
    imgPlane2: TImage;
    lblTitle: TLabel;
    lblTopTitle: TLabel;
    imgUnderline: TImage;
    imgTitle: TImage;
    lblAbout: TLabel;
    shpFindMore: TShape;
    shpPlay: TShape;
    lblFindMore: TLabel;
    imgPlay: TImage;
    lblInfo: TLabel;
    tsInfo: TTabSheet;
    lblDestinations: TLabel;
    lblHotels: TLabel;
    lblFlights: TLabel;
    lblBookings: TLabel;
    imgProfile: TImage;
    procedure FormCreate(Sender: TObject);
    procedure posHomePageImages();
    procedure initVarsHomePage();
    procedure setLabelFont(currLabel : TLabel; isize: integer; bBold: boolean);
    procedure centerComponent(AControl, AParent: TControl);
    procedure createMenuBar();
    procedure lblDestinationsMouseEnter(Sender: TObject);
    procedure lblDestinationsMouseLeave(Sender: TObject);
    procedure lblFlightsMouseEnter(Sender: TObject);
    procedure lblFlightsMouseLeave(Sender: TObject);
    procedure lblHotelsMouseEnter(Sender: TObject);
    procedure lblHotelsMouseLeave(Sender: TObject);
    procedure lblBookingsMouseEnter(Sender: TObject);
    procedure lblBookingsMouseLeave(Sender: TObject);
    procedure shpFindMoreMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblFindMoreClick(Sender: TObject);
    procedure loadProfilePic();
    procedure loadUserData();
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    arrUser : array[1..4] of string;
  public
    { Public declarations }
  end;

var
  frmFlylee: TfrmFlylee;

implementation

{$R *.dfm}

uses frmSignUp_u, dmData_u;

procedure TfrmFlylee.FormActivate(Sender: TObject);
begin
  {
   ================
   On Form Activate
   ================
  }

  loadUserData();
  loadProfilePic();
end;

procedure TfrmFlylee.FormCreate(Sender: TObject);
begin
  {
   ===========
   Form Create
   ===========
  }

 //inti variables
 initVarsHomePage();

 //LoadImages
 imgCorner.Picture.LoadFromFile('Assets/cornerDecor.png');
 imgFlyGirl.Picture.LoadFromFile('Assets/flyGirl.png');
 imgPlane.Picture.LoadFromFile('Assets/plane.png');
 imgPlane2.Picture.LoadFromFile('Assets/plane.png');
 imgUnderline.Picture.LoadFromFile('Assets/underline.png');
 imgTitle.Picture.LoadFromFile('Assets/logoTitle.png');
 imgPlay.Picture.LoadFromFile('Assets/playIcon.png');

 //positions and scales
 posHomePageImages();
 createMenuBar();
 imgUnderline.top := 245;
 imgUnderline.left := 320;
end;

procedure TfrmFlylee.loadUserData();
var

  bfound : boolean;

begin
  {
   ================================================================
   Lees user se data vanaf databasis in n array vir vinniger opsoek
   ================================================================
  }

  bfound := false;

  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;
    while (not tblUsers.Eof) and (bfound = false) do
    begin
      if tblUsers['Userid'] = iUserId then
        begin
          bfound := true;
          arrUser[1] := tblUsers['name'];
          arruser[2] := tblUsers['lastname'];
          arrUser[3] := tblUsers['isSubscribed'];
          arrUser[4] := tblUsers['birthDate'];
        end;

      tblUsers.next;
    end;
  end;

  if bfound = false then
    begin
      Showmessage('A problem occurred with your user account.');
    end;
end;

procedure TfrmFlylee.initVarsHomePage();
begin
  {
  ===========================================
  Initialize en scale die home page variables
  ===========================================
  }
  with lblTitle do
  begin
    Caption := 'Travel, enjoy' + #13 + 'and live a new' + #13 + 'experience now';
    setlabelFont(lblTitle, 60, true);
    font.color := rgb(24,30,75);
    top := 170;
    left := 100;
  end;

  with lblTopTitle do
  begin
    Caption := 'BEST DESTINATIONS AROUND THE WORLD';
    font.size := 16;
    font.Style := [TFontStyle.fsBold];
    font.Color := frmSignUp.clSecondary;
    left := 100;
    top := 150;
  end;

  with lblAbout do
  begin
    caption := 'We provide the best flights with ease so you don''t have to. We work' + #13 + 'with weather and shipping companies to predict the best flights.';
    setLabelFont(lblAbout, 14, false);
    font.color := rgb(24,30,75);
    top := 470;
    left := 100;
  end;

  with shpFindMore do
  begin
    brush.Color := frmSignUP.clPrimary;
    height := 60;
    width := 170;
    left := 100;
    top := 540;
    Pen.Style := psClear;
  end;

  with shpPlay do
  begin
    brush.color := frmSignUp.clSecondary;
    width := 55;
    height := 55;
    top := 542;
    left := shpFindMore.Left + shpFindMore.Width + 60;
    Pen.Style := psClear;
  end;

  with lblFindMore do
  begin
    setLabelFont(lblFindMore, 14, true);
    font.color := clWhite;
    //Sentreer vertikaal
    Top := shpFindMore.Top + (shpFindMore.Height - Height) div 2;
    //Sentreer horisontaal
    Left := shpFindMore.Left + (shpFindMore.Width - Width) div 2;
  end;

  with lblInfo do
  begin
    setLabelFont(lblInfo, 14, false);
    top := shpPlay.Top + 15;
    left := shpPlay.left + shpPlay.Width + 10;
  end;

  with imgPlay do
  begin
    height := 15;
    width := 15;
    centerComponent(imgPlay, shpPlay);
  end;
end;

procedure TfrmFlylee.lblBookingsMouseEnter(Sender: TObject);
begin
  lblBookings.font.color := frmSignUp.clAccent;
end;

procedure TfrmFlylee.lblBookingsMouseLeave(Sender: TObject);
begin
  lblBookings.font.color := clBlack;
end;

procedure TfrmFlylee.lblDestinationsMouseEnter(Sender: TObject);
begin
  lblDestinations.font.color := frmSignUp.clAccent;
end;

procedure TfrmFlylee.lblDestinationsMouseLeave(Sender: TObject);
begin
  lblDestinations.font.color := clBlack;
end;

procedure TfrmFlylee.lblFindMoreClick(Sender: TObject);
begin
  pcPages.TabIndex := 1;
end;

procedure TfrmFlylee.lblFlightsMouseEnter(Sender: TObject);
begin
  lblFlights.font.color := frmSignUp.clAccent;
end;

procedure TfrmFlylee.lblFlightsMouseLeave(Sender: TObject);
begin
  lblFlights.font.color := clBlack;
end;

procedure TfrmFlylee.lblHotelsMouseEnter(Sender: TObject);
begin
  lblHotels.font.color := frmSignUp.clAccent;
end;

procedure TfrmFlylee.lblHotelsMouseLeave(Sender: TObject);
begin
  lblHotels.font.color := clBlack;
end;

procedure TfrmFlylee.loadProfilePic();
var

  Stream: TMemoryStream;
  BlobField: TBlobField;
  bfound : boolean;

begin
  {
   ==================================================================================
   Laai die user se profiel prent van Access database en wys dit in 'n TImage
   ==================================================================================
  }
  bfound := false;

  with dmData do
  begin
    tblUsers.open;
    tblUsers.first;
    while (not tblUsers.Eof) and (bfound = false) do
    begin
      if tblUsers['userid'] = iUserId then
      begin
        bfound := true;
        BlobField := dmData.tblUsers.FieldByName('profilePic') as TBlobField;
      end;

      tblUsers.next;
    end;
  end;

  // As daar geen prent is nie, gaan uit
  if BlobField.IsNull then
  begin
    showmessage('image is nil');
    imgProfile.Picture := nil;  // Maak skoon as daar geen prent is nie
    Exit;
  end;

  Stream := TMemoryStream.Create;
  try
    BlobField.SaveToStream(Stream);
    Stream.Position := 0;
    imgProfile.Picture.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TfrmFlylee.createMenuBar();
begin
  {
  ====================================================
  Position die labels in die menu bar in die home page
  ====================================================
  }
  with lblDestinations do
  begin
    setLabelFont(lblDestinations, 16, true);
    left := 450;
    top := 30;
  end;

  with lblHotels do
  begin
    setLabelFont(lblHotels, 16, true);
    Left := lblDestinations.left + lblDestinations.Width + 60;
    Top := 30;
  end;

  with lblFlights do
  begin
    setLabelFont(lblFlights, 16, true);
    Left := lblHotels.left + lblHotels.Width + 60;
    Top := 30;
  end;

  with lblBookings do
  begin
    setLabelFont(lblBookings, 16, true);
    Left := lblFlights.left + lblFlights.Width + 60;
    Top := 30;
  end;
end;

procedure TfrmFlylee.posHomePageImages();
begin
  {
   ==============================================
   Position and scale the images in the home page
   ==============================================
  }
  with imgCorner do
  begin
    Width := 585;
    Height := 568;
    Top := -10;
    Left := 832;
  end;

  with imgFlyGirl do
  begin
    Width := 650;
    Height := 650;
    Top := 50;
    Left := 584;
  end;

  with imgPlane do
  begin
    Width := 170;
    Height := 170;
    Top := 95;
    Left := 656;
  end;

  with imgPlane2 do
  begin
    Width := 170;
    Height := 170;
    Top := 167;
    Left := 1112;
  end;
end;

procedure TfrmFlylee.setLabelFont(currLabel : TLabel; isize: integer; bBold: boolean);
begin
  {
   ===================================
   Set die font van die label ingevoer
   ===================================
  }

  //Kyk of die label bestaan
  if Assigned(currLabel) then
    with currLabel.Font do
    begin
      //Stel die font
      Name := 'Roboto';
      Size := isize;
      //Kies of dit bold moet wees of nie
      if bBold then
        Style := [TFontStyle.fsBold]
      else
        Style := [];
    end;
end;

procedure TfrmFlylee.shpFindMoreMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pcPages.TabIndex := 1;
end;

procedure TfrmFlylee.centerComponent(AControl, AParent: TControl);
begin
  {
   ================================
   Sentreer komponent op op sy ouer
   ================================
  }
  //Kyk of die komponente bestaan
  if Assigned(AControl) and Assigned(AParent) then
  begin
    //Sentreer vertikaal
    AControl.Left := AParent.Left + (AParent.Width - AControl.Width) div 2;
    //Sentreer horisontaal
    AControl.Top := AParent.Top + (AParent.Height - AControl.Height) div 2;
  end;
end;

end.
