unit Mailer4D.Driver.Mapi;

interface

uses
  Mailer4D;

type

  EMapiMailerException = class(EMailerException);

  TMapiMailerFactory = class sealed
  public
    class function Build(const pAppHandle: THandle = 0; const pShowMailClient: Boolean = False): IMailer; static;
  end;

implementation

uses
  System.SysUtils,
  Mailer4D.Driver.Base,
  Winapi.Windows,
  Winapi.Mapi;

type

  TMapiMailerAdapter = class(TDriverMailer, IMailer)
  private
    FAppHandle: THandle;
    FShowMailClient: Boolean;
    procedure ProcessErrorMessage(const pErrorCode: Cardinal);
  protected
    constructor Create(const pAppHandle: THandle; const pShowMailClient: Boolean);

    procedure DoSend; override;
  end;

  { TMapiMailerFactory }

class function TMapiMailerFactory.Build(const pAppHandle: THandle; const pShowMailClient: Boolean): IMailer;
begin
  Result := TMapiMailerAdapter.Create(pAppHandle, pShowMailClient);
end;

{ TMapiMailerAdapter }

constructor TMapiMailerAdapter.Create(const pAppHandle: THandle; const pShowMailClient: Boolean);
begin
  inherited Create;
  FAppHandle := pAppHandle;
  FShowMailClient := pShowMailClient;
end;

procedure TMapiMailerAdapter.DoSend;
var
  vMessage: TMapiMessage;
  vReturn: Cardinal;
  vSender: TMapiRecipDesc;
  vRecip, vRecipients: PMapiRecipDesc;
  vAttach, vAttachments: PMapiFileDesc;
  I: Integer;
begin
  vMessage.nRecipCount := GetToRecipient.Count + GetCcRecipient.Count + GetBccRecipient.Count;
  vMessage.nFileCount := GetAttachment.Count;

  GetMem(vRecipients, vMessage.nRecipCount * sizeof(TMapiRecipDesc));
  GetMem(vAttachments, vMessage.nFileCount * sizeof(TMapiFileDesc));
  try
    vMessage.ulReserved := 0;
    vMessage.lpszSubject := PAnsiChar(AnsiString(GetSubject));
    vMessage.lpszNoteText := PAnsiChar(AnsiString(GetMessage.Text));
    vMessage.lpszMessageType := nil;
    vMessage.lpszDateReceived := nil;
    vMessage.lpszConversationID := nil;
    vMessage.flFlags := 0;

    vSender.ulReserved := 0;
    vSender.ulRecipClass := MAPI_ORIG;
    vSender.lpszName := PAnsiChar(AnsiString(GetFromName));
    vSender.lpszAddress := PAnsiChar(AnsiString(GetFromAddress));
    vSender.ulEIDSize := 0;
    vSender.lpEntryID := nil;
    vMessage.lpOriginator := @vSender;

    vRecip := vRecipients;
    if (vMessage.nRecipCount > 0) then
    begin
      for I := 0 to Pred(GetToRecipient.Count) do
      begin
        vRecip^.ulReserved := 0;
        vRecip^.ulRecipClass := MAPI_TO;
        vRecip^.lpszName := StrNew(PAnsiChar(AnsiString(GetToRecipient.Strings[I])));
        vRecip^.lpszAddress := StrNew(PAnsiChar(AnsiString('SMTP:' + GetToRecipient.Strings[I])));
        vRecip^.ulEIDSize := 0;
        vRecip^.lpEntryID := nil;
        Inc(vRecip);
      end;

      for I := 0 to Pred(GetCcRecipient.Count) do
      begin
        vRecip^.ulReserved := 0;
        vRecip^.ulRecipClass := MAPI_CC;
        vRecip^.lpszName := StrNew(PAnsiChar(AnsiString(GetCcRecipient.Strings[I])));
        vRecip^.lpszAddress := StrNew(PAnsiChar(AnsiString('SMTP:' + GetCcRecipient.Strings[I])));
        vRecip^.ulEIDSize := 0;
        vRecip^.lpEntryID := nil;
        Inc(vRecip);
      end;

      for I := 0 to Pred(GetBccRecipient.Count) do
      begin
        vRecip^.ulReserved := 0;
        vRecip^.ulRecipClass := MAPI_BCC;
        vRecip^.lpszName := StrNew(PAnsiChar(AnsiString(GetBccRecipient.Strings[I])));
        vRecip^.lpszAddress := StrNew(PAnsiChar(AnsiString('SMTP:' + GetBccRecipient.Strings[I])));
        vRecip^.ulEIDSize := 0;
        vRecip^.lpEntryID := nil;
        Inc(vRecip);
      end;
    end;
    vMessage.lpRecips := vRecipients;

    vAttach := vAttachments;
    if (GetAttachment.Count > 0) then
    begin
      for I := 0 to Pred(GetAttachment.Count) do
      begin
        vAttach^.lpszPathName := StrNew(PAnsiChar(AnsiString(GetAttachment.Strings[I])));
        vAttach^.lpszFileName := StrNew(PAnsiChar(AnsiString(GetAttachment.Strings[I])));
        vAttach^.ulReserved := 0;
        vAttach^.flFlags := 0;
        vAttach^.nPosition := Cardinal($FFFFFFFF);
        vAttach^.lpFileType := nil;
        Inc(vAttach);
      end;
    end;
    vMessage.lpFiles := vAttachments;

    if FShowMailClient then
      vReturn := MapiSendMail(0, FAppHandle, vMessage, MAPI_DIALOG or MAPI_LOGON_UI or MAPI_NEW_SESSION, 0)
    else
      vReturn := MapiSendMail(0, FAppHandle, vMessage, 0, 0);

    if (vReturn <> SUCCESS_SUCCESS) and (vReturn <> MAPI_E_USER_ABORT) then
      ProcessErrorMessage(vReturn);
  finally
    vRecip := vRecipients;
    for I := 1 to vMessage.nRecipCount do
    begin
      StrDispose(vRecip^.lpszName);
      StrDispose(vRecip^.lpszAddress);
      Inc(vRecip)
    end;
    vAttach := vAttachments;
    for I := 1 to vMessage.nFileCount do
    begin
      StrDispose(vAttach^.lpszPathName);
      StrDispose(vAttach^.lpszFileName);
      Inc(vAttach)
    end;
    FreeMem(vRecipients, vMessage.nRecipCount * sizeof(TMapiRecipDesc));
    FreeMem(vAttachments, vMessage.nFileCount * sizeof(TMapiFileDesc));
  end;
end;

procedure TMapiMailerAdapter.ProcessErrorMessage(const pErrorCode: Cardinal);
begin
  case pErrorCode of
    MAPI_E_FAILURE: raise EMapiMailerException.Create('Error: MAPI_E_FAILURE!');
    MAPI_E_LOGON_FAILURE: raise EMapiMailerException.Create('Error: MAPI_E_LOGON_FAILURE!');
    MAPI_E_DISK_FULL: raise EMapiMailerException.Create('Error: MAPI_E_DISK_FULL!');
    MAPI_E_INSUFFICIENT_MEMORY: raise EMapiMailerException.Create('Error: MAPI_E_INSUFFICIENT_MEMORY!');
    MAPI_E_ACCESS_DENIED: raise EMapiMailerException.Create('Error: MAPI_E_ACCESS_DENIED!');
    MAPI_E_TOO_MANY_SESSIONS: raise EMapiMailerException.Create('Error: MAPI_E_TOO_MANY_SESSIONS!');
    MAPI_E_TOO_MANY_FILES: raise EMapiMailerException.Create('Error: MAPI_E_TOO_MANY_FILES!');
    MAPI_E_TOO_MANY_RECIPIENTS: raise EMapiMailerException.Create('Error: MAPI_E_TOO_MANY_RECIPIENTS!');
    MAPI_E_ATTACHMENT_NOT_FOUND: raise EMapiMailerException.Create('Error: MAPI_E_ATTACHMENT_NOT_FOUND!');
    MAPI_E_ATTACHMENT_OPEN_FAILURE: raise EMapiMailerException.Create('Error: MAPI_E_ATTACHMENT_OPEN_FAILURE!');
    MAPI_E_ATTACHMENT_WRITE_FAILURE: raise EMapiMailerException.Create('Error: MAPI_E_ATTACHMENT_WRITE_FAILURE!');
    MAPI_E_UNKNOWN_RECIPIENT: raise EMapiMailerException.Create('Error: MAPI_E_UNKNOWN_RECIPIENT!');
    MAPI_E_BAD_RECIPTYPE: raise EMapiMailerException.Create('Error: MAPI_E_BAD_RECIPTYPE!');
    MAPI_E_NO_MESSAGES: raise EMapiMailerException.Create('Error: MAPI_E_NO_MESSAGES!');
    MAPI_E_INVALID_MESSAGE: raise EMapiMailerException.Create('Error: MAPI_E_INVALID_MESSAGE!');
    MAPI_E_TEXT_TOO_LARGE: raise EMapiMailerException.Create('Error: MAPI_E_TEXT_TOO_LARGE!');
    MAPI_E_INVALID_SESSION: raise EMapiMailerException.Create('Error: MAPI_E_INVALID_SESSION!');
    MAPI_E_TYPE_NOT_SUPPORTED: raise EMapiMailerException.Create('Error: MAPI_E_TYPE_NOT_SUPPORTED!');
    MAPI_E_AMBIGUOUS_RECIPIENT: raise EMapiMailerException.Create('Error: MAPI_E_AMBIGUOUS_RECIPIENT!');
    MAPI_E_MESSAGE_IN_USE: raise EMapiMailerException.Create('Error: MAPI_E_MESSAGE_IN_USE!');
    MAPI_E_NETWORK_FAILURE: raise EMapiMailerException.Create('Error: MAPI_E_NETWORK_FAILURE!');
    MAPI_E_INVALID_EDITFIELDS: raise EMapiMailerException.Create('Error: MAPI_E_INVALID_EDITFIELDS!');
    MAPI_E_INVALID_RECIPS: raise EMapiMailerException.Create('Error: MAPI_E_INVALID_RECIPS!');
    MAPI_E_NOT_SUPPORTED: raise EMapiMailerException.Create('Error: MAPI_E_NOT_SUPPORTED!');
  end;
end;

end.
