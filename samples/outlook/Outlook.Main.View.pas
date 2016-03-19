unit Outlook.Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Common.Main.View, Vcl.StdCtrls,
  Vcl.Buttons;

type
  TForm2 = class(TCommonMainView)
    procedure BtnSendEmailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Mailer4D.Driver.Outlook, Mailer4D.Driver.Base, Mailer4D;

procedure TForm2.BtnSendEmailClick(Sender: TObject);
var
  vMailer: IMailer;
  I: Integer;
begin
  inherited;
  vMailer := TOutlookMailerFactory.Build();

  vMailer.From(EdtFromName.Text, EdtFromAddress.Text);

  for I := 0 to Pred(MnmTo.Lines.Count) do
    vMailer.ToRecipient(MnmTo.Lines[I]);

  for I := 0 to Pred(MnmCc.Lines.Count) do
    vMailer.CcRecipient(MnmCc.Lines[I]);

  for I := 0 to Pred(MnmBcc.Lines.Count) do
    vMailer.BccRecipient(MnmBcc.Lines[I]);

  for I := 0 to Pred(MnmAttachment.Lines.Count) do
    vMailer.Attachment(MnmAttachment.Lines[I]);

  vMailer.Subject(EdtSubject.Text);
  vMailer.Message(MnmMessage.Lines.Text);

  vMailer.Send;
end;

end.
