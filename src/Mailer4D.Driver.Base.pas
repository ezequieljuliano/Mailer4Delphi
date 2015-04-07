unit Mailer4D.Driver.Base;

interface

uses
  System.Classes,
  Mailer4D;

type

  TDriverMailer = class abstract(TInterfacedObject, IMailer)
  strict private
    FHost: string;
    FPort: Integer;
    FUserName: string;
    FPassword: string;
    FSSL: Boolean;
    FTLS: Boolean;
    FRequireAuth: Boolean;
    FFromName: string;
    FFromAddress: string;
    FToRecipient: TStringList;
    FCcRecipient: TStringList;
    FBccRecipient: TStringList;
    FConfirmation: Boolean;
    FAttachment: TStringList;
    FSubject: string;
    FMessage: TStringList;
    FHTML: Boolean;
  strict protected
    function GetHost(): string;
    function GetPort(): Integer;
    function GetUserName(): string;
    function GetPassword(): string;
    function GetUseSSL(): Boolean;
    function GetUseTLS(): Boolean;
    function GetRequireAuth(): Boolean;
    function GetFromName(): string;
    function GetFromAddress(): string;
    function GetToRecipient(): TStringList;
    function GetCcRecipient(): TStringList;
    function GetBccRecipient(): TStringList;
    function GetAskConfirmation(): Boolean;
    function GetAttachment(): TStringList;
    function GetSubject(): string;
    function GetMessage(): TStringList;
    function GetUseHTML(): Boolean;

    procedure DoSend(); virtual; abstract;
  public
    constructor Create();
    destructor Destroy(); override;

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

uses
  System.SysUtils;

{ TDriverMailer }

function TDriverMailer.Attachment(const pFileName: string): IMailer;
begin
  FAttachment.Add(pFileName);
  Result := Self;
end;

function TDriverMailer.RequireAuth(const pRequireAuth: Boolean): IMailer;
begin
  FRequireAuth := pRequireAuth;
  Result := Self;
end;

function TDriverMailer.BccRecipient(const pAddress: string): IMailer;
begin
  FBccRecipient.Add(pAddress);
  Result := Self;
end;

function TDriverMailer.CcRecipient(const pAddress: string): IMailer;
begin
  FCcRecipient.Add(pAddress);
  Result := Self;
end;

function TDriverMailer.Confirmation(const pAskConfirmation: Boolean): IMailer;
begin
  FConfirmation := pAskConfirmation;
  Result := Self;
end;

constructor TDriverMailer.Create;
begin
  FHost := EmptyStr;
  FPort := 0;
  FUserName := EmptyStr;
  FPassword := EmptyStr;
  FSSL := False;
  FTLS := False;
  FRequireAuth := False;
  FFromName := EmptyStr;
  FFromAddress := EmptyStr;
  FToRecipient := TStringList.Create;
  FCcRecipient := TStringList.Create;
  FBccRecipient := TStringList.Create;
  FConfirmation := False;
  FAttachment := TStringList.Create;
  FSubject := EmptyStr;
  FMessage := TStringList.Create;
  FHTML := False;
end;

destructor TDriverMailer.Destroy;
begin
  FreeAndNil(FToRecipient);
  FreeAndNil(FCcRecipient);
  FreeAndNil(FBccRecipient);
  FreeAndNil(FAttachment);
  FreeAndNil(FMessage);
  inherited;
end;

function TDriverMailer.From(const pName, pAddress: string): IMailer;
begin
  FFromName := pName;
  FFromAddress := pAddress;
  Result := Self;
end;

function TDriverMailer.GetAttachment: TStringList;
begin
  Result := FAttachment;
end;

function TDriverMailer.GetBccRecipient: TStringList;
begin
  Result := FBccRecipient;
end;

function TDriverMailer.GetCcRecipient: TStringList;
begin
  Result := FCcRecipient;
end;

function TDriverMailer.GetAskConfirmation: Boolean;
begin
  Result := FConfirmation;
end;

function TDriverMailer.GetFromAddress: string;
begin
  Result := FFromAddress;
end;

function TDriverMailer.GetFromName: string;
begin
  Result := FFromName;
end;

function TDriverMailer.GetHost: string;
begin
  Result := FHost;
end;

function TDriverMailer.GetRequireAuth: Boolean;
begin
  Result := FRequireAuth;
end;

function TDriverMailer.GetUseHTML: Boolean;
begin
  Result := FHTML;
end;

function TDriverMailer.GetMessage: TStringList;
begin
  Result := FMessage;
end;

function TDriverMailer.GetPassword: string;
begin
  Result := FPassword;
end;

function TDriverMailer.GetPort: Integer;
begin
  Result := FPort;
end;

function TDriverMailer.GetUseSSL: Boolean;
begin
  Result := FSSL;
end;

function TDriverMailer.GetSubject: string;
begin
  Result := FSubject;
end;

function TDriverMailer.GetUseTLS: Boolean;
begin
  Result := FTLS;
end;

function TDriverMailer.GetToRecipient: TStringList;
begin
  Result := FToRecipient;
end;

function TDriverMailer.GetUserName: string;
begin
  Result := FUserName;
end;

function TDriverMailer.Host(const pHost: string): IMailer;
begin
  FHost := pHost;
  Result := Self;
end;

function TDriverMailer.HTML(const pUseHTMLMessage: Boolean): IMailer;
begin
  FHTML := pUseHTMLMessage;
  Result := Self;
end;

function TDriverMailer.Message(const pMessage: TStringList): IMailer;
begin
  FMessage.Text := pMessage.Text;
  Result := Self;
end;

function TDriverMailer.Message(const pMessage: string): IMailer;
begin
  FMessage.Add(pMessage);
  Result := Self;
end;

function TDriverMailer.Password(const pPassword: string): IMailer;
begin
  FPassword := pPassword;
  Result := Self;
end;

function TDriverMailer.Port(const pPort: Integer): IMailer;
begin
  FPort := pPort;
  Result := Self;
end;

procedure TDriverMailer.Send;
begin
  DoSend();
end;

function TDriverMailer.SSL(const pUseSSL: Boolean): IMailer;
begin
  FSSL := pUseSSL;
  Result := Self;
end;

function TDriverMailer.Subject(const pSubject: string): IMailer;
begin
  FSubject := pSubject;
  Result := Self;
end;

function TDriverMailer.TLS(const pUseTLS: Boolean): IMailer;
begin
  FTLS := pUseTLS;
  Result := Self;
end;

function TDriverMailer.ToRecipient(const pAddress: string): IMailer;
begin
  FToRecipient.Add(pAddress);
  Result := Self;
end;

function TDriverMailer.UserName(const pUserName: string): IMailer;
begin
  FUserName := pUserName;
  Result := Self;
end;

end.
