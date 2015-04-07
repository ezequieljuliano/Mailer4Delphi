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
  Mailer4D.Driver.Base, Mailer4D.Driver.Indy, Mailer4D;

{$R *.dfm}

procedure TIndyMainView.BtnSendEmailClick(Sender: TObject);
var
  vMailer: IMailer;
  I: Integer;
begin
  inherited;
  vMailer := TIndyMailerFactory.Build;

  vMailer.Host(EdtHost.Text);
  vMailer.Port(StrToInt(EdtPort.Text));
  vMailer.UserName(EdtUserName.Text);
  vMailer.Password(EdtPassword.Text);

  if CbSSL.Checked then
    vMailer.SSL();

  if CbTLS.Checked then
    vMailer.TLS();

  if CbAuth.Checked then
    vMailer.RequireAuth();

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
    vMailer.Confirmation();

  if CbHtml.Checked then
    vMailer.HTML();

  vMailer.Subject(EdtSubject.Text);
  vMailer.Message(MnmMessage.Lines.Text);

  vMailer.Send;
end;

end.
