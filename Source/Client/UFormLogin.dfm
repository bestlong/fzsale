inherited fFormLogin: TfFormLogin
  Left = 410
  Top = 472
  Width = 360
  Height = 217
  OldCreateOrder = True
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited WordPanel: TPanel
    Width = 352
    Height = 183
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 352
      Height = 183
      Align = alClient
    end
    object BtnLogin: TImageButton
      Left = 110
      Top = 130
      Width = 105
      Height = 35
      OnClick = BtnLoginClick
      ButtonID = 'login'
      Checked = False
    end
    object EditUser: TEdit
      Left = 110
      Top = 42
      Width = 168
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnExit = EditUserExit
      OnKeyPress = EditPwdKeyPress
    end
    object EditPwd: TEdit
      Left = 110
      Top = 82
      Width = 168
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
      OnKeyPress = EditPwdKeyPress
    end
    object Check1: TcxCheckBox
      Left = 216
      Top = 132
      Caption = #35760#20303#23494#30721
      ParentFont = False
      TabOrder = 2
      Transparent = True
      Width = 82
    end
  end
end
