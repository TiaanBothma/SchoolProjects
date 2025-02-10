unit uFunc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, pngimage, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, DateUtils, Data.DB, Data.Win.ADODB,
  System.Skia, Vcl.Skia, dmData_u;

{ Declare procedures/functions }
procedure centerComponent(AControl, AParent: TControl);

implementation

procedure centerComponent(AControl, AParent: TControl);
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
