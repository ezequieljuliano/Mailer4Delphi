unit Mailer4D.Base.Impl;

interface

uses
  System.SysUtils,
  System.Classes,
  Mailer4D;

type

  TBaseMailer = class abstract(TInterfacedObject, IMailer)
  private
    fHost: string;
    fPort: Integer;
    fUsername: string;
    fPassword: string;
    fSSL: Boolean;
    fTLS: Boolean;
    fAuthentication: Boolean;
    fFromName: string;
    fFromAddress: string;
    fToRecipient: TStringList;
    fCcRecipient: TStringList;
    fBccRecipient: TStringList;
    fConfirmation: Boolean;
    fAttachment: TStringList;
    fSubject: string;
    fMessage: TStringList;
    fHTML: Boolean;
  protected
    function GetHost: string;
    function GetPort: Integer;
    function GetUsername: string;
    function GetPassword: string;
    function IsWithSSL: Boolean;
    function IsWithTLS: Boolean;
    function IsWithAuthentication: Boolean;
    function GetFromName: string;
    function GetFromAddress: string;
    function GetToRecipients: TStringList;
    function GetCcRecipients: TStringList;
    function GetBccRecipients: TStringList;
    function IsWithConfirmation: Boolean;
    function GetAttachments: TStringList;
    function GetSubject: string;
    function GetMessage: TStringList;
    function IsWithHTML: Boolean;

    procedure DoSend; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;

    function Host(const value: string): IMailer;
    function Port(const value: Integer): IMailer;
    function Username(const value: string): IMailer;
    function Password(const value: string): IMailer;
    function UsingSSL(const value: Boolean = True): IMailer;
    function UsingTLS(const value: Boolean = True): IMailer;
    function AuthenticationRequired(const value: Boolean = True): IMailer;

    function From(const name, address: string): IMailer;
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

{ TBaseMailer }

function TBaseMailer.Attachment(const fileName: string): IMailer;
begin
  fAttachment.Add(fileName);
  Result := Self;
end;

function TBaseMailer.AuthenticationRequired(const value: Boolean): IMailer;
begin
  fAuthentication := value;
  Result := Self;
end;

function TBaseMailer.BccRecipient(const address: string): IMailer;
begin
  fBccRecipient.Add(address);
  Result := Self;
end;

function TBaseMailer.CcRecipient(const address: string): IMailer;
begin
  fCcRecipient.Add(address);
  Result := Self;
end;

function TBaseMailer.AskForConfirmation(const value: Boolean): IMailer;
begin
  fConfirmation := value;
  Result := Self;
end;

constructor TBaseMailer.Create;
begin
  inherited Create;
  fHost := EmptyStr;
  fPort := 0;
  fUsername := EmptyStr;
  fPassword := EmptyStr;
  fSSL := False;
  fTLS := False;
  fAuthentication := False;
  fFromName := EmptyStr;
  fFromAddress := EmptyStr;
  fToRecipient := TStringList.Create;
  fCcRecipient := TStringList.Create;
  fBccRecipient := TStringList.Create;
  fConfirmation := False;
  fAttachment := TStringList.Create;
  fSubject := EmptyStr;
  fMessage := TStringList.Create;
  fHTML := False;
end;

destructor TBaseMailer.Destroy;
begin
  fToRecipient.Free;
  fCcRecipient.Free;
  fBccRecipient.Free;
  fAttachment.Free;
  fMessage.Free;
  inherited Destroy;
end;

function TBaseMailer.From(const name, address: string): IMailer;
begin
  fFromName := name;
  fFromAddress := address;
  Result := Self;
end;

function TBaseMailer.GetAttachments: TStringList;
begin
  Result := fAttachment;
end;

function TBaseMailer.GetBccRecipients: TStringList;
begin
  Result := fBccRecipient;
end;

function TBaseMailer.GetCcRecipients: TStringList;
begin
  Result := fCcRecipient;
end;

function TBaseMailer.IsWithConfirmation: Boolean;
begin
  Result := fConfirmation;
end;

function TBaseMailer.GetFromAddress: string;
begin
  Result := fFromAddress;
end;

function TBaseMailer.GetFromName: string;
begin
  Result := fFromName;
end;

function TBaseMailer.GetHost: string;
begin
  Result := fHost;
end;

function TBaseMailer.IsWithAuthentication: Boolean;
begin
  Result := fAuthentication;
end;

function TBaseMailer.IsWithHTML: Boolean;
begin
  Result := fHTML;
end;

function TBaseMailer.GetMessage: TStringList;
begin
  Result := fMessage;
end;

function TBaseMailer.GetPassword: string;
begin
  Result := fPassword;
end;

function TBaseMailer.GetPort: Integer;
begin
  Result := fPort;
end;

function TBaseMailer.IsWithSSL: Boolean;
begin
  Result := fSSL;
end;

function TBaseMailer.GetSubject: string;
begin
  Result := fSubject;
end;

function TBaseMailer.IsWithTLS: Boolean;
begin
  Result := fTLS;
end;

function TBaseMailer.GetToRecipients: TStringList;
begin
  Result := fToRecipient;
end;

function TBaseMailer.GetUsername: string;
begin
  Result := fUsername;
end;

function TBaseMailer.Host(const value: string): IMailer;
begin
  fHost := value;
  Result := Self;
end;

function TBaseMailer.UsingHTML(const value: Boolean): IMailer;
begin
  fHTML := value;
  Result := Self;
end;

function TBaseMailer.Message(const value: TStringList): IMailer;
begin
  fMessage.Text := value.Text;
  Result := Self;
end;

function TBaseMailer.Message(const value: string): IMailer;
begin
  fMessage.Add(value);
  Result := Self;
end;

function TBaseMailer.Password(const value: string): IMailer;
begin
  fPassword := value;
  Result := Self;
end;

function TBaseMailer.Port(const value: Integer): IMailer;
begin
  fPort := value;
  Result := Self;
end;

procedure TBaseMailer.Send;
begin
  DoSend;
end;

function TBaseMailer.UsingSSL(const value: Boolean): IMailer;
begin
  fSSL := value;
  Result := Self;
end;

function TBaseMailer.Subject(const value: string): IMailer;
begin
  fSubject := value;
  Result := Self;
end;

function TBaseMailer.UsingTLS(const value: Boolean): IMailer;
begin
  fTLS := value;
  Result := Self;
end;

function TBaseMailer.ToRecipient(const address: string): IMailer;
begin
  fToRecipient.Add(address);
  Result := Self;
end;

function TBaseMailer.UserName(const value: string): IMailer;
begin
  fUsername := value;
  Result := Self;
end;

end.
