program SynapseSample;

uses
  Vcl.Forms,
  Common.Main.View in '..\common\Common.Main.View.pas' {CommonMainView},
  Mailer4D.Driver.Base in '..\..\src\Mailer4D.Driver.Base.pas',
  Mailer4D.Driver.Synapse in '..\..\src\Mailer4D.Driver.Synapse.pas',
  Mailer4D in '..\..\src\Mailer4D.pas',
  Synapse.Main.View in 'Synapse.Main.View.pas' {SynapseMainView};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSynapseMainView, SynapseMainView);
  Application.Run;
end.
