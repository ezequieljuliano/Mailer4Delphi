unit Common.Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type

  TCommonMainView = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EdtHost: TEdit;
    EdtPort: TEdit;
    Label2: TLabel;
    EdtUsername: TEdit;
    Label3: TLabel;
    EdtPassword: TEdit;
    LabelPass: TLabel;
    CbSSL: TCheckBox;
    CbTLS: TCheckBox;
    CbAuth: TCheckBox;
    GroupBox2: TGroupBox;
    EdtFromName: TEdit;
    Label4: TLabel;
    EdtFromAddress: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    MnmTo: TMemo;
    MnmCc: TMemo;
    Label7: TLabel;
    MnmBcc: TMemo;
    Label8: TLabel;
    CbConfirmation: TCheckBox;
    EdtSubject: TEdit;
    Label9: TLabel;
    MnmMessage: TMemo;
    Label10: TLabel;
    CbHtml: TCheckBox;
    MnmAttachment: TMemo;
    Label11: TLabel;
    SpeedButton1: TSpeedButton;
    OdAttachment: TOpenDialog;
    BtnSendEmail: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TCommonMainView.SpeedButton1Click(Sender: TObject);
begin
  if OdAttachment.Execute then
    if (OdAttachment.FileName <> EmptyStr) then
      MnmAttachment.Lines.Add(OdAttachment.FileName);
end;

end.
