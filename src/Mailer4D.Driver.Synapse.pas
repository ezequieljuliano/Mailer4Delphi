unit Mailer4D.Driver.Synapse;

interface

uses
  Mailer4D;

type

  ESynapseMailerException = class(EMailerException);

  TSynapseMailerFactory = class sealed
  strict private
  const
    CanNotBeInstantiatedException = 'This class can not be instantiated!';
  strict private

    {$HINTS OFF}

    constructor Create;

    {$HINTS ON}

  public
    class function Build(): IMailer; static;
  end;

implementation

uses
  System.SysUtils,
  Mailer4D.Driver.Base,
  smtpsend, mimemess, mimepart, ssl_openssl;

type

  TSynapseMailerAdapter = class(TDriverMailer, IMailer)
  protected
    procedure DoSend; override;
  end;

  { TSynapseMailerAdapter }

procedure TSynapseMailerAdapter.DoSend;
var
  vSMTP: TSMTPSend;
  vMimemess: TMimemess;
  vMimepart: TMimepart;
  I: Integer;
begin
  inherited;
  vSMTP := TSMTPSend.Create;
  vMimemess := TMimemess.Create;
  try
    vMimepart := vMimemess.AddPartMultipart('mixed', nil);

    if GetUseHTML then
      vMimemess.AddPartHTML(GetMessage, vMimepart)
    else
      vMimemess.AddPartText(GetMessage, vMimepart);

    for I := 0 to Pred(GetAttachment.Count) do
      vMimemess.AddPartBinaryFromFile(GetAttachment[I], vMimepart);

    for I := 0 to Pred(GetToRecipient.Count) do
      vMimemess.Header.ToList.Add(GetToRecipient[I]);

    for I := 0 to Pred(GetCcRecipient.Count) do
      vMimemess.Header.CCList.Add(GetCcRecipient[I]);

    if not GetFromName.IsEmpty then
      vMimemess.Header.From := '"' + GetFromName + ' <' + GetFromAddress + '>"'
    else
      vMimemess.Header.From := GetFromAddress;

    vMimemess.Header.Date := Now;
    vMimemess.Header.Subject := GetSubject;
    vMimemess.Header.ReplyTo := GetFromAddress;

    if GetAskConfirmation then
      vMimemess.Header.CustomHeaders.Add('Disposition-Notification-To: ' + GetFromAddress);

    vMimemess.EncodeMessage;

    vSMTP.UserName := GetUserName;
    vSMTP.Password := GetPassword;
    vSMTP.TargetHost := GetHost;
    vSMTP.TargetPort := IntToStr(GetPort);
    vSMTP.FullSSL := GetUseSSL;
    vSMTP.AutoTLS := GetUseTLS;

    if GetUseTLS then
      vSMTP.StartTLS;

    if not vSMTP.Login then
      raise ESynapseMailerException.Create('SMTP ERROR: Login: ' + vSMTP.EnhCodeString + sLineBreak + vSMTP.FullResult.Text);

    if not vSMTP.MailFrom(GetFromAddress, Length(GetFromAddress)) then
      raise ESynapseMailerException.Create('SMTP ERROR: MailFrom: ' + vSMTP.EnhCodeString + sLineBreak + vSMTP.FullResult.Text);

    for I := 0 to Pred(GetToRecipient.Count) do
      if not vSMTP.MailTo(GetToRecipient[I]) then
        raise ESynapseMailerException.Create('SMTP ERROR: MailTo: ' + vSMTP.EnhCodeString + sLineBreak + vSMTP.FullResult.Text);

    for I := 0 to Pred(GetCcRecipient.Count) do
      if not vSMTP.MailTo(GetCcRecipient[I]) then
        raise ESynapseMailerException.Create('SMTP ERROR: MailToCC: ' + vSMTP.EnhCodeString + sLineBreak + vSMTP.FullResult.Text);

    for I := 0 to Pred(GetBccRecipient.Count) do
      if not vSMTP.MailTo(GetBccRecipient[I]) then
        raise ESynapseMailerException.Create('SMTP ERROR: MailToBCC: ' + vSMTP.EnhCodeString + sLineBreak + vSMTP.FullResult.Text);

    if not vSMTP.MailData(vMimemess.Lines) then
      raise ESynapseMailerException.Create('SMTP ERROR: MailData: ' + vSMTP.EnhCodeString + sLineBreak + vSMTP.FullResult.Text);

    if not vSMTP.Logout then
      raise ESynapseMailerException.Create('SMTP ERROR: Logout: ' + vSMTP.EnhCodeString + sLineBreak + vSMTP.FullResult.Text);
  finally
    FreeAndNil(vSMTP);
    FreeAndNil(vMimemess);
  end;
end;

{ TSynapseMailerFactory }

class function TSynapseMailerFactory.Build: IMailer;
begin
  Result := TSynapseMailerAdapter.Create;
end;

constructor TSynapseMailerFactory.Create;
begin
  raise ESynapseMailerException.Create(CanNotBeInstantiatedException);
end;

end.
