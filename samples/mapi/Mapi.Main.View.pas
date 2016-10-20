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
  Mailer4D,
  Mailer4D.Mapi.Impl;

{$R *.dfm}

procedure TMapiMainView.BtnSendEmailClick(Sender: TObject);
var
  mailer: IMailer;
  i: Integer;
begin
  inherited;
  mailer := TMapiMailer.Create(Application.Handle, True);

  mailer.From(EdtFromName.Text, EdtFromAddress.Text);

  for i := 0 to Pred(MnmTo.Lines.Count) do
    mailer.ToRecipient(MnmTo.Lines[i]);

  for i := 0 to Pred(MnmCc.Lines.Count) do
    mailer.CcRecipient(MnmCc.Lines[i]);

  for i := 0 to Pred(MnmBcc.Lines.Count) do
    mailer.BccRecipient(MnmBcc.Lines[i]);

  for i := 0 to Pred(MnmAttachment.Lines.Count) do
    mailer.Attachment(MnmAttachment.Lines[i]);

  mailer.Subject(EdtSubject.Text);
  mailer.Message(MnmMessage.Lines.Text);

  mailer.Send;
end;

end.
