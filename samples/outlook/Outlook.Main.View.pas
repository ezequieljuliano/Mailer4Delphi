unit Outlook.Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Common.Main.View, Vcl.StdCtrls,
  Vcl.Buttons;

type

  TOutlookMainView = class(TCommonMainView)
    procedure BtnSendEmailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OutlookMainView: TOutlookMainView;

implementation

{$R *.dfm}

uses
  Mailer4D,
  Mailer4D.Outlook.Impl;

procedure TOutlookMainView.BtnSendEmailClick(Sender: TObject);
var
  vMailer: IMailer;
  i: Integer;
begin
  inherited;
  vMailer := TOutlookMailer.Create(True);

  vMailer.From(EdtFromName.Text, EdtFromAddress.Text);

  for i := 0 to Pred(MnmTo.Lines.Count) do
    vMailer.ToRecipient(MnmTo.Lines[i]);

  for i := 0 to Pred(MnmCc.Lines.Count) do
    vMailer.CcRecipient(MnmCc.Lines[i]);

  for i := 0 to Pred(MnmBcc.Lines.Count) do
    vMailer.BccRecipient(MnmBcc.Lines[i]);

  for i := 0 to Pred(MnmAttachment.Lines.Count) do
    vMailer.Attachment(MnmAttachment.Lines[i]);

  vMailer.Subject(EdtSubject.Text);
  vMailer.Message(MnmMessage.Lines.Text);

  vMailer.Send;
end;

end.
