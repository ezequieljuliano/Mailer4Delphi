unit Indy.Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Common.Main.View, Vcl.StdCtrls, Vcl.Buttons;

type

  TIndyMainView = class(TCommonMainView)
    procedure BtnSendEmailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IndyMainView: TIndyMainView;

implementation

uses
  Mailer4D,
  Mailer4D.Indy.Impl;

{$R *.dfm}

procedure TIndyMainView.BtnSendEmailClick(Sender: TObject);
var
  mailer: IMailer;
  i: Integer;
begin
  inherited;
  mailer := TIndyMailer.Create;

  mailer.Host(EdtHost.Text);
  mailer.Port(StrToInt(EdtPort.Text));
  mailer.UserName(EdtUserName.Text);
  mailer.Password(EdtPassword.Text);

  if CbSSL.Checked then
    mailer.UsingSSL(True);

  if CbTLS.Checked then
    mailer.UsingTLS(True);

  if CbAuth.Checked then
    mailer.AuthenticationRequired(True);

  mailer.From(EdtFromName.Text, EdtFromAddress.Text);

  for i := 0 to Pred(MnmTo.Lines.Count) do
    mailer.ToRecipient(MnmTo.Lines[i]);

  for i := 0 to Pred(MnmCc.Lines.Count) do
    mailer.CcRecipient(MnmCc.Lines[i]);

  for i := 0 to Pred(MnmBcc.Lines.Count) do
    mailer.BccRecipient(MnmBcc.Lines[i]);

  for i := 0 to Pred(MnmAttachment.Lines.Count) do
    mailer.Attachment(MnmAttachment.Lines[i]);

  if CbConfirmation.Checked then
    mailer.AskForConfirmation(True);

  if CbHtml.Checked then
    mailer.UsingHTML(True);

  mailer.Subject(EdtSubject.Text);
  mailer.Message(MnmMessage.Lines.Text);

  mailer.Send;
end;

end.
