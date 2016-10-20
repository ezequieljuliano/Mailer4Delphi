program OutlookSample;

uses
  Vcl.Forms,
  Outlook.Main.View in 'Outlook.Main.View.pas' {OutlookMainView},
  Common.Main.View in '..\common\Common.Main.View.pas' {CommonMainView},
  Mailer4D.Outlook.Impl in '..\..\src\Mailer4D.Outlook.Impl.pas',
  Mailer4D in '..\..\src\Mailer4D.pas',
  Mailer4D.Base.Impl in '..\..\src\Mailer4D.Base.Impl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TOutlookMainView, OutlookMainView);
  Application.Run;
end.
