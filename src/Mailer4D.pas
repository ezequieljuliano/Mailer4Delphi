unit Mailer4D;

interface

uses
  System.Classes,
  System.SysUtils;

type

  EMailerException = class(Exception);

  IMailer = interface
    ['{E2741CF9-C79F-4396-8D80-068BE8950AA4}']
    function Host(const value: string): IMailer;
    function Port(const value: Integer): IMailer;
    function Username(const value: string): IMailer;
    function Password(const value: string): IMailer;
    function UsingSSL(const value: Boolean = True): IMailer;
    function UsingTLS(const value: Boolean = True): IMailer;
    function AuthenticationRequired(const value: Boolean = True): IMailer;

    function From(const name, address: string): IMailer;
    function ReplyTo(const name, address: string): IMailer;
    function ToRecipient(const address: string): IMailer;
    function CcRecipient(const address: string): IMailer;
    function BccRecipient(const address: string): IMailer;
    function AskForConfirmation(const value: Boolean = True): IMailer;

    function Attachment(const fileName: string): IMailer;

    function Subject(const value: string): IMailer;
    function Message(const value: string): IMailer; overload;
    function Message(const value: TStringList): IMailer; overload;
    function UsingHTML(const value: Boolean = True): IMailer;

    procedure Send;
  end;

implementation

end.
