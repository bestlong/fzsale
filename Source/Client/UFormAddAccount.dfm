inherited fFormAddAccount: TfFormAddAccount
  Left = 535
  Top = 535
  Width = 339
  Height = 244
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited WordPanel: TPanel
    Width = 331
    Height = 210
    object Label1: TLabel
      Left = 25
      Top = 53
      Width = 78
      Height = 12
      Caption = #35831#36755#20837#29992#25143#21517':'
      Transparent = True
    end
    object Label3: TLabel
      Left = 25
      Top = 112
      Width = 78
      Height = 12
      Caption = #20877#27425#36755#20837#23494#30721':'
      Transparent = True
    end
    object Label4: TLabel
      Left = 37
      Top = 83
      Width = 66
      Height = 12
      Caption = #35831#36755#20837#23494#30721':'
      Transparent = True
    end
    object Label6: TLabel
      Left = 1
      Top = 142
      Width = 102
      Height = 12
      Caption = #35831#36755#20837#32852#31995#35775#26041#24335':'
      Transparent = True
    end
    object Label2: TLabel
      Left = 104
      Top = 17
      Width = 120
      Height = 19
      Anchors = [akTop, akRight]
      Caption = #28155#21152#33829#38144#24080#21495
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BtnOK: TImageButton
      Left = 95
      Top = 172
      Width = 65
      Height = 25
      OnClick = BtnOKClick
      ButtonID = 'ok'
      Checked = False
    end
    object ImageButton1: TImageButton
      Left = 207
      Top = 172
      Width = 65
      Height = 25
      OnClick = ImageButton1Click
      ButtonID = 'exit'
      Checked = False
    end
    object EditUser: TcxTextEdit
      Left = 107
      Top = 50
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 0
      Width = 165
    end
    object EditNew: TcxTextEdit
      Left = 107
      Top = 81
      ParentFont = False
      Properties.MaxLength = 16
      Properties.PasswordChar = '*'
      TabOrder = 1
      Width = 165
    end
    object EditNext: TcxTextEdit
      Left = 107
      Top = 110
      ParentFont = False
      Properties.MaxLength = 16
      Properties.PasswordChar = '*'
      TabOrder = 2
      Width = 165
    end
    object EditPhone: TcxTextEdit
      Left = 107
      Top = 140
      ParentFont = False
      Properties.MaxLength = 20
      TabOrder = 3
      Width = 165
    end
  end
end
