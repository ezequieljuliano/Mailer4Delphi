unit Mailer4D.Outlook.Impl;

interface

uses
  Mailer4D,
  Mailer4D.Base.Impl,
  System.SysUtils,
  System.Variants,
  Outlook2010;

type

  EOutlookMailerException = class(EMailerException);

  TOutlookMailer = class(TBaseMailer, IMailer)
  private
    fShowMailClient: Boolean;
    procedure AddBody(const email: MailItem);
    procedure AddToRecipients(const email: MailItem);
    procedure AddCcRecipients(const email: MailItem);
    procedure AddBccRecipients(const email: MailItem);
    procedure AddAttachments(const email: MailItem);
  protected
    procedure DoSend; override;
  public
    constructor Create(const showMailClient: Boolean);
    class function New(const showMailClient: Boolean): IMailer; static;
  end;

implementation


{ TOutlookMailer }

procedure TOutlookMailer.AddAttachments(const email: MailItem);
var
  i: Integer;
begin
  for i := 0 to Pred(GetAttachments.Count) do
    email.Attachments.Add(GetAttachments[i], EmptyParam, EmptyParam, EmptyParam);
end;

procedure TOutlookMailer.AddBccRecipients(const email: MailItem);
var
  i: Integer;
begin
  for i := 0 to Pred(GetBccRecipients.Count) do
    with email.Recipients.Add(GetBccRecipients[i]) do
      type_ := olBCC;
end;

procedure TOutlookMailer.AddBody(const email: MailItem);
begin
  if IsWithHTML then
  begin
    email.BodyFormat := olFormatHTML;
    email.HTMLBody := GetMessage.Text;
  end
  else
  begin
    email.BodyFormat := olFormatPlain;
    email.Body := GetMessage.Text;
  end;
end;

procedure TOutlookMailer.AddCcRecipients(const email: MailItem);
var
  i: Integer;
begin
  for i := 0 to Pred(GetCcRecipients.Count) do
    with email.Recipients.Add(GetCcRecipients[i]) do
      type_ := olCC;
end;

procedure TOutlookMailer.AddToRecipients(const email: MailItem);
var
  i: Integer;
begin
  for i := 0 to Pred(GetToRecipients.Count) do
    with email.Recipients.Add(GetToRecipients[i]) do
      type_ := olTo;
end;

constructor TOutlookMailer.Create(const showMailClient: Boolean);
begin
  inherited Create;
  fShowMailClient := showMailClient;
end;

procedure TOutlookMailer.DoSend;
var
  outlook: TOutlookApplication;
  email: MailItem;
begin
  inherited;
  outlook := TOutlookApplication.Create(nil);
  try
    try
      email := outlook.CreateItem(olMailItem) As MailItem;
      email.Subject := GetSubject;
      email.Importance := olImportanceNormal;

      AddBody(email);
      AddToRecipients(email);
      AddCcRecipients(email);
      AddBccRecipients(email);
      AddAttachments(email);

      if email.Recipients.ResolveAll then
      begin
        if fShowMailClient then
          email.Display(True)
        else
          email.Send;
      end
      else
        raise EOutlookMailerException.Create('Could not send email from Outlook. Check the parameters informed.');
    finally
      outlook.Disconnect;
    end;
  finally
    outlook.Free;
  end;
end;

class function TOutlookMailer.New(const showMailClient: Boolean): IMailer;
begin
  Result := TOutlookMailer.Create(showMailClient);
end;

end.
