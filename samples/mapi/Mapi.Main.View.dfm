inherited MapiMainView: TMapiMainView
  Caption = 'Mapi Send E-mail'
  ExplicitWidth = 906
  ExplicitHeight = 633
  PixelsPerInch = 96
  TextHeight = 13
  inherited GroupBox1: TGroupBox
    Enabled = False
    inherited Label1: TLabel
      Font.Style = [fsStrikeOut]
      ParentFont = False
    end
    inherited Label2: TLabel
      Font.Style = [fsStrikeOut]
      ParentFont = False
    end
    inherited Label3: TLabel
      Font.Style = [fsStrikeOut]
      ParentFont = False
    end
    inherited LabelPass: TLabel
      Font.Style = [fsStrikeOut]
      ParentFont = False
    end
    inherited EdtHost: TEdit
      Color = clInfoBk
      Enabled = False
    end
    inherited EdtPort: TEdit
      Color = clInfoBk
      Enabled = False
    end
    inherited EdtUserName: TEdit
      Color = clInfoBk
      Enabled = False
    end
    inherited EdtPassword: TEdit
      Color = clInfoBk
      Enabled = False
    end
    inherited CbSSL: TCheckBox
      Enabled = False
      Font.Style = [fsStrikeOut]
      ParentFont = False
    end
    inherited CbTLS: TCheckBox
      Enabled = False
      Font.Style = [fsStrikeOut]
      ParentFont = False
    end
    inherited CbAuth: TCheckBox
      Enabled = False
      Font.Style = [fsStrikeOut]
      ParentFont = False
    end
  end
  inherited GroupBox2: TGroupBox
    inherited BtnSendEmail: TSpeedButton
      OnClick = BtnSendEmailClick
    end
    inherited CbConfirmation: TCheckBox
      Enabled = False
      Font.Style = [fsStrikeOut]
      ParentFont = False
    end
    inherited CbHtml: TCheckBox
      Enabled = False
      Font.Style = [fsStrikeOut]
      ParentFont = False
    end
  end
end
