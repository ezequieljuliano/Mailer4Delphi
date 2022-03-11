unit Mailer4D.Mapi.Impl;

interface

uses
  Mailer4D,
  Mailer4D.Base.Impl,
  System.AnsiStrings,
  Winapi.Windows,
  Winapi.Mapi;

type

  EMapiMailerException = class(EMailerException);

  TMapiMailer = class(TBaseMailer, IMailer)
  private
    fHandle: THandle;
    fShowMailClient: Boolean;
    procedure RaiseErrorMessage(errorCode: Cardinal);
  protected
    procedure DoSend; override;
  public
    constructor Create(handle: THandle; showMailClient: Boolean);
    class function New(handle: THandle; showMailClient: Boolean): IMailer; static;
  end;

implementation

{ TMapiMailer }

constructor TMapiMailer.Create(handle: THandle; showMailClient: Boolean);
begin
  inherited Create;
  fHandle := handle;
  fShowMailClient := showMailClient;
end;

procedure TMapiMailer.DoSend;
var
  msg: TMapiMessage;
  sender: TMapiRecipDesc;
  recipients, r: PMapiRecipDesc;
  attachments, a: PMapiFileDesc;
  return: Cardinal;
  i: Integer;
  sendMailMethod: TFNMapiSendMail;
  mapiModule: HModule;
begin
  inherited;
  msg.nRecipCount := GetToRecipients.Count + GetCcRecipients.Count + GetBccRecipients.Count;
  msg.nFileCount := GetAttachments.Count;

  GetMem(recipients, msg.nRecipCount * SizeOf(TMapiRecipDesc));
  GetMem(attachments, msg.nFileCount * SizeOf(TMapiFileDesc));
  try
    try
      msg.ulReserved := 0;
      msg.lpszSubject := PAnsiChar(AnsiString(GetSubject));
      msg.lpszNoteText := PAnsiChar(AnsiString(GetMessage.Text));
      msg.lpszMessageType := nil;
      msg.lpszDateReceived := nil;
      msg.lpszConversationID := nil;
      msg.flFlags := 0;

      sender.ulReserved := 0;
      sender.ulRecipClass := MAPI_ORIG;
      sender.lpszName := PAnsiChar(AnsiString(GetFromName));
      sender.lpszAddress := PAnsiChar(AnsiString(GetFromAddress));
      sender.ulEIDSize := 0;
      sender.lpEntryID := nil;
      msg.lpOriginator := @sender;

      r := recipients;
      if (msg.nRecipCount > 0) then
      begin
        for i := 0 to Pred(GetToRecipients.Count) do
        begin
          r^.ulReserved := 0;
          r^.ulRecipClass := MAPI_TO;
          r^.lpszName := StrNew(PAnsiChar(AnsiString(GetToRecipients.Strings[i])));
          r^.lpszAddress := StrNew(PAnsiChar(AnsiString('SMTP:' + GetToRecipients.Strings[i])));
          r^.ulEIDSize := 0;
          r^.lpEntryID := nil;
          Inc(r);
        end;
        for i := 0 to Pred(GetCcRecipients.Count) do
        begin
          r^.ulReserved := 0;
          r^.ulRecipClass := MAPI_CC;
          r^.lpszName := StrNew(PAnsiChar(AnsiString(GetCcRecipients.Strings[i])));
          r^.lpszAddress := StrNew(PAnsiChar(AnsiString('SMTP:' + GetCcRecipients.Strings[i])));
          r^.ulEIDSize := 0;
          r^.lpEntryID := nil;
          Inc(r);
        end;
        for i := 0 to Pred(GetBccRecipients.Count) do
        begin
          r^.ulReserved := 0;
          r^.ulRecipClass := MAPI_BCC;
          r^.lpszName := StrNew(PAnsiChar(AnsiString(GetBccRecipients.Strings[i])));
          r^.lpszAddress := StrNew(PAnsiChar(AnsiString('SMTP:' + GetBccRecipients.Strings[i])));
          r^.ulEIDSize := 0;
          r^.lpEntryID := nil;
          Inc(r);
        end;
      end;
      msg.lpRecips := recipients;

      a := attachments;
      if (GetAttachments.Count > 0) then
      begin
        for I := 0 to Pred(GetAttachments.Count) do
        begin
          a^.lpszPathName := StrNew(PAnsiChar(AnsiString(GetAttachments.Strings[I])));
          a^.lpszFileName := StrNew(PAnsiChar(AnsiString(ExtractFileName(GetAttachments.Strings[i]))));
          a^.ulReserved := 0;
          a^.flFlags := 0;
          a^.nPosition := Cardinal($FFFFFFFF);
          a^.lpFileType := nil;
          Inc(a);
        end;
      end;
      msg.lpFiles := attachments;

      mapiModule := LoadLibrary(PChar(MAPIDLL));
      if (mapiModule = 0) then
        return := MAPI_E_FAILURE
      else
      begin
        try
          sendMailMethod := GetProcAddress(mapiModule, 'MAPISendMail');
          if (@sendMailMethod <> nil) then
          begin
            if fShowMailClient then
              return := sendMailMethod(0, fHandle, msg, MAPI_DIALOG or MAPI_LOGON_UI or MAPI_NEW_SESSION, 0)
            else
              return := sendMailMethod(0, fHandle, msg, 0, 0);
          end
          else
            return := MAPI_E_FAILURE;
        finally
          FreeLibrary(mapiModule);
        end;
      end;

      if (return <> SUCCESS_SUCCESS) and (return <> MAPI_E_USER_ABORT) then
        RaiseErrorMessage(return);
    finally
      r := recipients;
      for I := 1 to msg.nRecipCount do
      begin
        StrDispose(r^.lpszName);
        StrDispose(r^.lpszAddress);
        Inc(r)
      end;
      a := attachments;
      for I := 1 to msg.nFileCount do
      begin
        StrDispose(a^.lpszPathName);
        StrDispose(a^.lpszFileName);
        Inc(a)
      end;
    end;
  finally
    FreeMem(recipients, msg.nRecipCount * SizeOf(TMapiRecipDesc));
    FreeMem(attachments, msg.nFileCount * SizeOf(TMapiFileDesc));
  end;
end;

class function TMapiMailer.New(handle: THandle; showMailClient: Boolean): IMailer;
begin
  Result := TMapiMailer.Create(handle, showMailClient);
end;

procedure TMapiMailer.RaiseErrorMessage(errorCode: Cardinal);
begin
  case errorCode of
    MAPI_E_FAILURE: raise EMapiMailerException.Create('Error sending email: MAPI_E_FAILURE!');
    MAPI_E_LOGON_FAILURE: raise EMapiMailerException.Create('Error sending email: MAPI_E_LOGON_FAILURE!');
    MAPI_E_DISK_FULL: raise EMapiMailerException.Create('Error sending email: MAPI_E_DISK_FULL!');
    MAPI_E_INSUFFICIENT_MEMORY: raise EMapiMailerException.Create('Error sending email: MAPI_E_INSUFFICIENT_MEMORY!');
    MAPI_E_ACCESS_DENIED: raise EMapiMailerException.Create('Error sending email: MAPI_E_ACCESS_DENIED!');
    MAPI_E_TOO_MANY_SESSIONS: raise EMapiMailerException.Create('Error sending email: MAPI_E_TOO_MANY_SESSIONS!');
    MAPI_E_TOO_MANY_FILES: raise EMapiMailerException.Create('Error sending email: MAPI_E_TOO_MANY_FILES!');
    MAPI_E_TOO_MANY_RECIPIENTS: raise EMapiMailerException.Create('Error sending email: MAPI_E_TOO_MANY_RECIPIENTS!');
    MAPI_E_ATTACHMENT_NOT_FOUND: raise EMapiMailerException.Create('Error sending email: MAPI_E_ATTACHMENT_NOT_FOUND!');
    MAPI_E_ATTACHMENT_OPEN_FAILURE: raise EMapiMailerException.Create('Error sending email: MAPI_E_ATTACHMENT_OPEN_FAILURE!');
    MAPI_E_ATTACHMENT_WRITE_FAILURE: raise EMapiMailerException.Create('Error sending email: MAPI_E_ATTACHMENT_WRITE_FAILURE!');
    MAPI_E_UNKNOWN_RECIPIENT: raise EMapiMailerException.Create('Error sending email: MAPI_E_UNKNOWN_RECIPIENT!');
    MAPI_E_BAD_RECIPTYPE: raise EMapiMailerException.Create('Error sending email: MAPI_E_BAD_RECIPTYPE!');
    MAPI_E_NO_MESSAGES: raise EMapiMailerException.Create('Error sending email: MAPI_E_NO_MESSAGES!');
    MAPI_E_INVALID_MESSAGE: raise EMapiMailerException.Create('Error sending email: MAPI_E_INVALID_MESSAGE!');
    MAPI_E_TEXT_TOO_LARGE: raise EMapiMailerException.Create('Error sending email: MAPI_E_TEXT_TOO_LARGE!');
    MAPI_E_INVALID_SESSION: raise EMapiMailerException.Create('Error sending email: MAPI_E_INVALID_SESSION!');
    MAPI_E_TYPE_NOT_SUPPORTED: raise EMapiMailerException.Create('Error sending email: MAPI_E_TYPE_NOT_SUPPORTED!');
    MAPI_E_AMBIGUOUS_RECIPIENT: raise EMapiMailerException.Create('Error sending email: MAPI_E_AMBIGUOUS_RECIPIENT!');
    MAPI_E_MESSAGE_IN_USE: raise EMapiMailerException.Create('Error sending email: MAPI_E_MESSAGE_IN_USE!');
    MAPI_E_NETWORK_FAILURE: raise EMapiMailerException.Create('Error sending email: MAPI_E_NETWORK_FAILURE!');
    MAPI_E_INVALID_EDITFIELDS: raise EMapiMailerException.Create('Error sending email: MAPI_E_INVALID_EDITFIELDS!');
    MAPI_E_INVALID_RECIPS: raise EMapiMailerException.Create('Error sending email: MAPI_E_INVALID_RECIPS!');
    MAPI_E_NOT_SUPPORTED: raise EMapiMailerException.Create('Error sending email: MAPI_E_NOT_SUPPORTED!');
  end;
end;

end.
