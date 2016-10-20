program SynapseSample;

uses
  Vcl.Forms,
  Common.Main.View in '..\common\Common.Main.View.pas' {CommonMainView},
  Mailer4D.Synapse.Impl in '..\..\src\Mailer4D.Synapse.Impl.pas',
  Mailer4D in '..\..\src\Mailer4D.pas',
  Synapse.Main.View in 'Synapse.Main.View.pas' {SynapseMainView},
  Mailer4D.Base.Impl in '..\..\src\Mailer4D.Base.Impl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSynapseMainView, SynapseMainView);
  Application.Run;
end.
