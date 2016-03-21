program OutlookSample;

uses
  Vcl.Forms,
  Outlook.Main.View in 'Outlook.Main.View.pas' {Form2},
  Common.Main.View in '..\common\Common.Main.View.pas' {CommonMainView},
  Mailer4D.Driver.Outlook in '..\..\src\Mailer4D.Driver.Outlook.pas',
  Mailer4D.Driver.Base in '..\..\src\Mailer4D.Driver.Base.pas',
  Mailer4D in '..\..\src\Mailer4D.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
