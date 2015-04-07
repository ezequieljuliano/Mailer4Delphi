program IndySample;

uses
  Vcl.Forms,
  Common.Main.View in '..\common\Common.Main.View.pas' {CommonMainView},
  Mailer4D.Driver.Base in '..\..\src\Mailer4D.Driver.Base.pas',
  Mailer4D.Driver.Indy in '..\..\src\Mailer4D.Driver.Indy.pas',
  Mailer4D in '..\..\src\Mailer4D.pas',
  Indy.Main.View in 'Indy.Main.View.pas' {IndyMainView};

{$R *.res}

begin

  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TIndyMainView, IndyMainView);
  Application.Run;

end.
