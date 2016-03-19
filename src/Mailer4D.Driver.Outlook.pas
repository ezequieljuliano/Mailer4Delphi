unit Mailer4D.Driver.Outlook;

interface

uses
  Mailer4D,
  Outlook2010,
  System.Variants;

type

  EOutlookMailerException = class(EMailerException);

  TOutlookMailerFactory = class sealed
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
  Mailer4D.Driver.Base;

type

  TIndyMailerAdapter = class(TDriverMailer, IMailer)
  private const
  protected
    procedure DoSend; override;
  end;

  { TOutlookMailerFactory }

class function TOutlookMailerFactory.Build: IMailer;
begin
  Result := TIndyMailerAdapter.Create;
end;

constructor TOutlookMailerFactory.Create;
begin
  raise EOutlookMailerException.Create(CanNotBeInstantiatedException);
end;

{ TIndyMailerAdapter }

procedure TIndyMailerAdapter.DoSend;
var
  vOutlookApp: TOutlookApplication;
  vEmail: MailItem;
  I: Integer;
begin
  inherited;
  vOutlookApp := TOutlookApplication.Create(Nil);
  try
    vEmail := vOutlookApp.CreateItem(olMailItem) As MailItem;
    vEmail.Subject := GetSubject;
    vEmail.BodyFormat := olFormatHTML;
    vEmail.HTMLBody := GetMessage.Text;
    vEmail.Importance := olImportanceNormal;

    for I := 0 to Pred(GetToRecipient.Count) do
      vEmail.Recipients.Add(GetToRecipient[I]);

    for I := 0 to Pred(GetBccRecipient.Count) do
    begin
      if GetBccRecipient.Count > 1 then
      begin
        if ((GetBccRecipient.Count - 1) > I) then
          vEmail.BCC := vEmail.BCC + ';' + GetBccRecipient[I] + ';'
        else if ((GetBccRecipient.Count - 1) = I) then
          vEmail.BCC := vEmail.BCC + ';' + GetBccRecipient[I];
      end
      else
        vEmail.BCC := GetCcRecipient[I];
    end;

    for I := 0 to Pred(GetCcRecipient.Count) do
    begin
      if GetCcRecipient.Count > 1 then
      begin
       if ((GetCcRecipient.Count - 1) > I) then
          vEmail.CC := vEmail.CC + ';' + GetCcRecipient[I] + ';'
        else if ((GetCcRecipient.Count - 1) = I) then
          vEmail.CC := vEmail.CC + ';' + GetCcRecipient[I];
      end
      else
        vEmail.CC := GetCcRecipient[I];
    end;

    for I := 0 to Pred(GetAttachment.Count) do
      vEmail.Attachments.Add(GetAttachment[I], EmptyParam, EmptyParam,
        EmptyParam);

    if (vEmail.Recipients.ResolveAll) then
    begin
      vEmail.Display(true);
    end
    else
    begin
      raise Exception.Create('Invalid E-mail !!!');
    end;

    vOutlookApp.Disconnect;
  finally
    FreeAndNil(vOutlookApp);
  end;
end;

end.
