unit Mailer4D.Indy.Impl;

interface

uses
  System.SysUtils,
  Mailer4D,
  Mailer4D.Base.Impl,
  IdSMTP,
  IdMessage,
  IdSSLOpenSSL,
  IdExplicitTLSClientServerBase,
  IdText,
  IdAttachmentFile;

type

  EIndyMailerException = class(EMailerException);

  TIndyMailer = class(TBaseMailer, IMailer)
  private const
    CONNECT_TIMEOUT = 10000;
    READ_TIMEOUT = 10000;
  private
    procedure ConfigureSmtp(const smtp: TIdSMTP);
    procedure AddToRecipients(const msg: TIdMessage);
    procedure AddCcRecipients(const msg: TIdMessage);
    procedure AddBccRecipients(const msg: TIdMessage);
    procedure AddFrom(const msg: TIdMessage);
    procedure AddAttachments(const msg: TIdMessage);
    procedure AddBody(const msg: TIdMessage);
  protected
    procedure DoSend; override;
  public
    class function New: IMailer; static;
  end;

implementation

{ TIndyMailer }

procedure TIndyMailer.AddAttachments(const msg: TIdMessage);
var
  i: Integer;
  attachment: TIdAttachmentFile;
begin
  for i := 0 to Pred(GetAttachments.Count) do
  begin
    attachment := TIdAttachmentFile.Create(msg.MessageParts, GetAttachments[i]);
    attachment.Headers.Add(Format('Content-ID: <%s>',
      [ExtractFileName(GetAttachments[i])]));
  end;
end;

procedure TIndyMailer.AddBccRecipients(const msg: TIdMessage);
var
  i: Integer;
begin
  for i := 0 to Pred(GetBccRecipients.Count) do
    with msg.BccList.Add do
      Address := GetBccRecipients[i];
end;

procedure TIndyMailer.AddBody(const msg: TIdMessage);
var
  body: TIdText;
begin
  body := TIdText.Create(msg.MessageParts);
  body.Body.Text := GetMessage.Text;
  if IsWithHTML then
    body.ContentType := 'text/html'
  else
    body.ContentType := 'text/plain';
end;

procedure TIndyMailer.AddCcRecipients(const msg: TIdMessage);
var
  i: Integer;
begin
  for i := 0 to Pred(GetCcRecipients.Count) do
    with msg.CCList.Add do
      Address := GetCcRecipients[i];
end;

procedure TIndyMailer.AddFrom(const msg: TIdMessage);
begin
  msg.From.Address := GetFromAddress;
  msg.From.Name := GetFromName;
  with msg.ReplyTo.Add do
  begin
    Address := GetFromAddress;
    Name := GetFromName;
  end;
  if IsWithConfirmation then
  begin
    msg.ReceiptRecipient.Address := GetFromAddress;
    msg.ReceiptRecipient.Name := GetFromName;
  end;
end;

procedure TIndyMailer.AddToRecipients(const msg: TIdMessage);
var
  i: Integer;
begin
  for i := 0 to Pred(GetToRecipients.Count) do
    with msg.Recipients.Add do
      Address := GetToRecipients[i];
end;

procedure TIndyMailer.ConfigureSmtp(const smtp: TIdSMTP);
begin
  smtp.ConnectTimeout := CONNECT_TIMEOUT;
  smtp.ReadTimeout := READ_TIMEOUT;
  smtp.Host := GetHost;
  smtp.Username := GetUserName;
  smtp.Password := GetPassword;
  smtp.Port := GetPort;

  if IsWithAuthentication then
    smtp.AuthType := satDefault
  else
    smtp.AuthType := satNone;

  if IsWithSSL then
  begin
    smtp.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(smtp);
    TIdSSLIOHandlerSocketOpenSSL(smtp.IOHandler).SSLOptions.Method := sslvSSLv23;
    TIdSSLIOHandlerSocketOpenSSL(smtp.IOHandler).SSLOptions.Mode := sslmClient;
    smtp.UseTLS := utUseExplicitTLS;
  end;

  if IsWithTLS then
    smtp.UseTLS := utUseRequireTLS;
end;

procedure TIndyMailer.DoSend;
var
  smtp: TIdSMTP;
  msg: TIdMessage;
begin
  inherited;
  smtp := TIdSMTP.Create(nil);
  try
    try
      ConfigureSmtp(smtp);
      msg := TIdMessage.Create(nil);
      try
        msg.Date := Now;
        msg.Subject := GetSubject;
        msg.ContentType := 'multipart/mixed';

        AddToRecipients(msg);
        AddCcRecipients(msg);
        AddBccRecipients(msg);
        AddFrom(msg);
        AddAttachments(msg);
        AddBody(msg);

        smtp.Connect;
        try
          if IsWithAuthentication then
            smtp.Authenticate;
          smtp.Send(msg);
        finally
          smtp.Disconnect;
        end;
      finally
        msg.Free;
      end;
    except
      on E: Exception do
        raise EIndyMailerException.Create(E.Message);
    end;
  finally
    smtp.Free;
  end;
end;

class function TIndyMailer.New: IMailer;
begin
  Result := TIndyMailer.Create;
end;

end.
