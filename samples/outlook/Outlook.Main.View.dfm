inherited OutlookMainView: TOutlookMainView
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Outlook Send E-mail'
  ClientHeight = 585
  ClientWidth = 883
  ExplicitWidth = 889
  ExplicitHeight = 613
  PixelsPerInch = 96
  TextHeight = 13
  inherited GroupBox1: TGroupBox
    Enabled = False
    inherited EdtHost: TEdit
      Enabled = False
    end
    inherited EdtPort: TEdit
      Enabled = False
    end
    inherited EdtUsername: TEdit
      Enabled = False
    end
    inherited EdtPassword: TEdit
      Enabled = False
    end
    inherited CbSSL: TCheckBox
      Enabled = False
    end
    inherited CbTLS: TCheckBox
      Enabled = False
    end
    inherited CbAuth: TCheckBox
      Enabled = False
    end
  end
  inherited GroupBox2: TGroupBox
    inherited BtnSendEmail: TSpeedButton
      OnClick = BtnSendEmailClick
    end
    inherited CbConfirmation: TCheckBox
      Enabled = False
    end
    inherited CbHtml: TCheckBox
      Enabled = False
    end
  end
end
