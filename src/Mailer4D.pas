unit Mailer4D;

interface

uses
  System.Classes,
  System.SysUtils;

type

  EMailerException = class(Exception);

  IMailer = interface
    ['{E2741CF9-C79F-4396-8D80-068BE8950AA4}']
    function Host(const pHost: string): IMailer;
    function Port(const pPort: Integer): IMailer;
    function UserName(const pUserName: string): IMailer;
    function Password(const pPassword: string): IMailer;
    function SSL(const pUseSSL: Boolean = True): IMailer;
    function TLS(const pUseTLS: Boolean = True): IMailer;
    function RequireAuth(const pRequireAuth: Boolean = True): IMailer;

    function From(const pName, pAddress: string): IMailer;
    function ToRecipient(const pAddress: string): IMailer;
    function CcRecipient(const pAddress: string): IMailer;
    function BccRecipient(const pAddress: string): IMailer;
    function Confirmation(const pAskConfirmation: Boolean = True): IMailer;

    function Attachment(const pFileName: string): IMailer;

    function Subject(const pSubject: string): IMailer;
    function Message(const pMessage: string): IMailer; overload;
    function Message(const pMessage: TStringList): IMailer; overload;
    function HTML(const pUseHTMLMessage: Boolean = True): IMailer;

    procedure Send();
  end;

implementation

end.
