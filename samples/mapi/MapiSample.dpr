program MapiSample;

uses
  Vcl.Forms,
  Common.Main.View in '..\common\Common.Main.View.pas' {CommonMainView},
  Mapi.Main.View in 'Mapi.Main.View.pas' {MapiMainView},
  Mailer4D.Mapi.Impl in '..\..\src\Mailer4D.Mapi.Impl.pas',
  Mailer4D in '..\..\src\Mailer4D.pas',
  Mailer4D.Base.Impl in '..\..\src\Mailer4D.Base.Impl.pas';

{$R *.res}

begin

  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMapiMainView, MapiMainView);
  Application.Run;

end.
