unit Mailer4D.Driver.Indy;

interface

uses
  Mailer4D;

type

  EIndyMailerException = class(EMailerException);

  TIndyMailerFactory = class sealed
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
  IdSMTP, IdMessage, IdSSLOpenSSL,
  IdExplicitTLSClientServerBase,
  IdText, IdAttachmentFile;

type

  TIndyMailerAdapter = class(TDriverMailer, IMailer)
  private
    const
    CONNECT_TIMEOUT = 10000;
    READ_TIMEOUT = 10000;
  protected
    procedure DoSend; override;
  end;

  { TIndyMailerFactory }

class function TIndyMailerFactory.Build: IMailer;
begin
  Result := TIndyMailerAdapter.Create;
end;

constructor TIndyMailerFactory.Create;
begin
  raise EIndyMailerException.Create(CanNotBeInstantiatedException);
end;

{ TIndyMailerAdapter }

procedure TIndyMailerAdapter.DoSend;
var
  vSMTP: TIdSMTP;
  vMessage: TIdMessage;
  vText: TIdText;
  I: Integer;
begin
  inherited;
  vSMTP := TIdSMTP.Create(nil);
  vMessage := TIdMessage.Create(nil);
  try
    try
      vSMTP.ConnectTimeout := CONNECT_TIMEOUT;
      vSMTP.ReadTimeout := READ_TIMEOUT;
      vSMTP.Host := GetHost;
      vSMTP.Username := GetUserName;
      vSMTP.Password := GetPassword;
      vSMTP.Port := GetPort;

      if GetRequireAuth then
        vSMTP.AuthType := satDefault
      else
        vSMTP.AuthType := satNone;

      if GetUseSSL then
      begin
        vSMTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(vSMTP);
        TIdSSLIOHandlerSocketOpenSSL(vSMTP.IOHandler).SSLOptions.Method := sslvSSLv23;
        TIdSSLIOHandlerSocketOpenSSL(vSMTP.IOHandler).SSLOptions.Mode := sslmClient;
        vSMTP.UseTLS := utUseExplicitTLS;
      end;

      if GetUseTLS then
        vSMTP.UseTLS := utUseRequireTLS;

      for I := 0 to Pred(GetToRecipient.Count) do
        with vMessage.Recipients.Add do
          Address := GetToRecipient[I];

      for I := 0 to Pred(GetCcRecipient.Count) do
        with vMessage.CCList.Add do
          Address := GetCcRecipient[I];

      for I := 0 to Pred(GetBccRecipient.Count) do
        with vMessage.BccList.Add do
          Address := GetBccRecipient[I];

      vMessage.From.Address := GetFromAddress;
      vMessage.From.Name := GetFromName;

      with vMessage.ReplyTo.Add do
      begin
        Address := GetFromAddress;
        Name := GetFromName;
      end;

      vMessage.Date := Now;
      vMessage.Subject := GetSubject;
      vMessage.ContentType := 'multipart/mixed';

      if GetAskConfirmation then
      begin
        vMessage.ReceiptRecipient.Address := GetFromAddress;
        vMessage.ReceiptRecipient.Name := GetFromName;
      end;

      vText := TIdText.Create(vMessage.MessageParts);
      vText.Body.Text := GetMessage.Text;
      if GetUseHTML then
        vText.ContentType := 'text/html'
      else
        vText.ContentType := 'text/plain';

      for I := 0 to Pred(GetAttachment.Count) do
        TIdAttachmentFile.Create(vMessage.MessageParts, GetAttachment[I]);

      vSMTP.Connect;
      try
        if GetRequireAuth then
          vSMTP.Authenticate;
        vSMTP.Send(vMessage);
      finally
        vSMTP.Disconnect();
      end;
    except
      on E: Exception do
        raise EIndyMailerException.Create(E.Message);
    end;
  finally
    FreeAndNil(vSMTP);
    FreeAndNil(vMessage);
  end;
end;

end.
