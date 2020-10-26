program PictureBed;

uses
  Forms,
  uPictureBed in 'uPictureBed.pas' {FMain},
  superobject in 'superobject.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
