program IndySample;

uses
  Vcl.Forms,
  Common.Main.View in '..\common\Common.Main.View.pas' {CommonMainView},
  Mailer4D.Base.Impl in '..\..\src\Mailer4D.Base.Impl.pas',
  Mailer4D.Indy.Impl in '..\..\src\Mailer4D.Indy.Impl.pas',
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
