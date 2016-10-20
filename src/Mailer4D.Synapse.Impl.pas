unit Mailer4D.Synapse.Impl;

interface

uses
  Mailer4D,
  Mailer4D.Base.Impl,
  System.SysUtils,
  smtpsend,
  mimemess,
  mimepart,
  ssl_openssl;

type

  ESynapseMailerException = class(EMailerException);

  TSynapseMailer = class(TBaseMailer, IMailer)
  private
    procedure ConfigureSmtp(const smtp: TSMTPSend);
    procedure AddBody(const mime: TMimemess; const mimepart: TMimepart);
    procedure AddAttachments(const mime: TMimemess; const mimepart: TMimepart);
    procedure AddToRecipients(const mime: TMimemess);
    procedure AddCcRecipients(const mime: TMimemess);
    procedure AddFrom(const mime: TMimemess);
  protected
    procedure DoSend; override;
  public
    class function New: IMailer; static;
  end;

implementation


{ TSynapseMailer }

procedure TSynapseMailer.AddAttachments(const mime: TMimemess; const mimepart: TMimepart);
var
  i: Integer;
begin
  for i := 0 to Pred(GetAttachments.Count) do
    mime.AddPartBinaryFromFile(GetAttachments[i], mimepart);
end;

procedure TSynapseMailer.AddBody(const mime: TMimemess; const mimepart: TMimepart);
begin
  if IsWithHTML then
    mime.AddPartHTML(GetMessage, mimepart)
  else
    mime.AddPartText(GetMessage, mimepart);
end;

procedure TSynapseMailer.AddCcRecipients(const mime: TMimemess);
var
  i: Integer;
begin
  for i := 0 to Pred(GetCcRecipients.Count) do
    mime.Header.CCList.Add(GetCcRecipients[i]);
end;

procedure TSynapseMailer.AddFrom(const mime: TMimemess);
begin
  if not GetFromName.IsEmpty then
    mime.Header.From := '"' + GetFromName + ' <' + GetFromAddress + '>"'
  else
    mime.Header.From := GetFromAddress;
end;

procedure TSynapseMailer.AddToRecipients(const mime: TMimemess);
var
  i: Integer;
begin
  for i := 0 to Pred(GetToRecipients.Count) do
    mime.Header.ToList.Add(GetToRecipients[i]);
end;

procedure TSynapseMailer.ConfigureSmtp(const smtp: TSMTPSend);
begin
  smtp.UserName := GetUserName;
  smtp.Password := GetPassword;
  smtp.TargetHost := GetHost;
  smtp.TargetPort := IntToStr(GetPort);
  smtp.FullSSL := IsWithSSL;
  smtp.AutoTLS := IsWithTLS;
  if IsWithTLS then
    smtp.StartTLS;
end;

procedure TSynapseMailer.DoSend;
var
  smtp: TSMTPSend;
  mime: TMimemess;
  mimepart: TMimepart;
  i: Integer;
begin
  inherited;
  smtp := TSMTPSend.Create;
  try
    try
      mime := TMimemess.Create;
      try
        ConfigureSmtp(smtp);

        mime.Header.Date := Now;
        mime.Header.Subject := GetSubject;
        mime.Header.ReplyTo := GetFromAddress;

        mimepart := mime.AddPartMultipart('mixed', nil);

        AddFrom(mime);
        AddBody(mime, mimepart);
        AddAttachments(mime, mimepart);
        AddToRecipients(mime);
        AddCcRecipients(mime);

        if IsWithConfirmation then
          mime.Header.CustomHeaders.Add('Disposition-Notification-To: ' + GetFromAddress);

        mime.EncodeMessage;

        if not smtp.Login then
          raise ESynapseMailerException.Create('SMTP ERROR: Login: ' + smtp.EnhCodeString + sLineBreak + smtp.FullResult.Text);

        if not smtp.MailFrom(GetFromAddress, Length(GetFromAddress)) then
          raise ESynapseMailerException.Create('SMTP ERROR: MailFrom: ' + smtp.EnhCodeString + sLineBreak + smtp.FullResult.Text);

        for i := 0 to Pred(GetToRecipients.Count) do
          if not smtp.MailTo(GetToRecipients[i]) then
            raise ESynapseMailerException.Create('SMTP ERROR: MailTo: ' + smtp.EnhCodeString + sLineBreak + smtp.FullResult.Text);

        for i := 0 to Pred(GetCcRecipients.Count) do
          if not smtp.MailTo(GetCcRecipients[i]) then
            raise ESynapseMailerException.Create('SMTP ERROR: MailToCC: ' + smtp.EnhCodeString + sLineBreak + smtp.FullResult.Text);

        for i := 0 to Pred(GetBccRecipients.Count) do
          if not smtp.MailTo(GetBccRecipients[i]) then
            raise ESynapseMailerException.Create('SMTP ERROR: MailToBCC: ' + smtp.EnhCodeString + sLineBreak + smtp.FullResult.Text);

        if not smtp.MailData(mime.Lines) then
          raise ESynapseMailerException.Create('SMTP ERROR: MailData: ' + smtp.EnhCodeString + sLineBreak + smtp.FullResult.Text);

        if not smtp.Logout then
          raise ESynapseMailerException.Create('SMTP ERROR: Logout: ' + smtp.EnhCodeString + sLineBreak + smtp.FullResult.Text);
      finally
        mime.Free;
      end;
    except
      on E: Exception do
        raise ESynapseMailerException.Create(E.Message);
    end;
  finally
    smtp.Free;
  end;
end;

class function TSynapseMailer.New: IMailer;
begin
  Result := TSynapseMailer.Create;
end;

end.
