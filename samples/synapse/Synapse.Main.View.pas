unit Synapse.Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Common.Main.View, Vcl.StdCtrls, Vcl.Buttons;

type

  TSynapseMainView = class(TCommonMainView)
    procedure BtnSendEmailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SynapseMainView: TSynapseMainView;

implementation

uses
  Mailer4D,
  Mailer4D.Synapse.Impl;

{$R *.dfm}

procedure TSynapseMainView.BtnSendEmailClick(Sender: TObject);
var
  vMailer: IMailer;
  I: Integer;
begin
  inherited;
  vMailer := TSynapseMailer.Create;

  vMailer.Host(EdtHost.Text);
  vMailer.Port(StrToInt(EdtPort.Text));
  vMailer.UserName(EdtUserName.Text);
  vMailer.Password(EdtPassword.Text);

  if CbSSL.Checked then
    vMailer.UsingSSL(True);

  if CbTLS.Checked then
    vMailer.UsingTLS(True);

  if CbAuth.Checked then
    vMailer.AuthenticationRequired(True);

  vMailer.From(EdtFromName.Text, EdtFromAddress.Text);

  for I := 0 to Pred(MnmTo.Lines.Count) do
    vMailer.ToRecipient(MnmTo.Lines[I]);

  for I := 0 to Pred(MnmCc.Lines.Count) do
    vMailer.CcRecipient(MnmCc.Lines[I]);

  for I := 0 to Pred(MnmBcc.Lines.Count) do
    vMailer.BccRecipient(MnmBcc.Lines[I]);

  for I := 0 to Pred(MnmAttachment.Lines.Count) do
    vMailer.Attachment(MnmAttachment.Lines[I]);

  if CbConfirmation.Checked then
    vMailer.AskForConfirmation(True);

  if CbHtml.Checked then
    vMailer.UsingHTML(True);

  vMailer.Subject(EdtSubject.Text);
  vMailer.Message(MnmMessage.Lines.Text);

  vMailer.Send;
end;

end.
