program MapiSample;

uses
  Vcl.Forms,
  Common.Main.View in '..\common\Common.Main.View.pas' {CommonMainView},
  Mapi.Main.View in 'Mapi.Main.View.pas' {MapiMainView},
  Mailer4D.Driver.Base in '..\..\src\Mailer4D.Driver.Base.pas',
  Mailer4D.Driver.Mapi in '..\..\src\Mailer4D.Driver.Mapi.pas',
  Mailer4D in '..\..\src\Mailer4D.pas';

{$R *.res}

begin

  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMapiMainView, MapiMainView);
  Application.Run;

end.
