unit Mapi.Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Common.Main.View, Vcl.StdCtrls, Vcl.Buttons;

type

  TMapiMainView = class(TCommonMainView)
    procedure BtnSendEmailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MapiMainView: TMapiMainView;

implementation

uses
  Mailer4D.Driver.Base, Mailer4D.Driver.Mapi, Mailer4D;

{$R *.dfm}

procedure TMapiMainView.BtnSendEmailClick(Sender: TObject);
var
  vMailer: IMailer;
  I: Integer;
begin
  inherited;
  vMailer := TMapiMailerFactory.Build(Application.Handle, True);

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
