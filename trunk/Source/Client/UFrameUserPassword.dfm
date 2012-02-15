inherited fFrameUserPassword: TfFrameUserPassword
  Width = 348
  Height = 214
  object Label1: TLabel
    Left = 13
    Top = 50
    Width = 78
    Height = 12
    Caption = #29992#25143#36134#25143#21517#31216':'
    Transparent = True
  end
  object Label2: TLabel
    Left = 135
    Top = 15
    Width = 120
    Height = 19
    Caption = #26356#26032#25105#30340#23494#30721
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 13
    Top = 79
    Width = 78
    Height = 12
    Caption = #35831#36755#20837#26087#23494#30721':'
    Transparent = True
  end
  object Label4: TLabel
    Left = 13
    Top = 109
    Width = 78
    Height = 12
    Caption = #35831#36755#20837#26032#23494#30721':'
    Transparent = True
  end
  object Label6: TLabel
    Left = 13
    Top = 138
    Width = 78
    Height = 12
    Caption = #20877#36755#20837#26032#23494#30721':'
    Transparent = True
  end
  object ImageButton1: TImageButton
    Left = 98
    Top = 175
    Width = 65
    Height = 25
    OnClick = BtnOKClick
    ButtonID = 'btn_ok'
    Checked = False
  end
  object ImageButton2: TImageButton
    Left = 204
    Top = 175
    Width = 65
    Height = 25
    OnClick = BtnExitClick
    ButtonID = 'btn_cancel'
    Checked = False
  end
  object EditUser: TcxTextEdit
    Left = 98
    Top = 45
    ParentFont = False
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 165
  end
  object EditOld: TcxTextEdit
    Left = 98
    Top = 75
    ParentFont = False
    Properties.EchoMode = eemPassword
    Properties.MaxLength = 16
    Properties.PasswordChar = '*'
    TabOrder = 1
    Width = 165
  end
  object EditNew: TcxTextEdit
    Left = 98
    Top = 105
    ParentFont = False
    Properties.EchoMode = eemPassword
    Properties.MaxLength = 16
    Properties.PasswordChar = '*'
    TabOrder = 2
    Width = 165
  end
  object EditNext: TcxTextEdit
    Left = 98
    Top = 135
    ParentFont = False
    Properties.EchoMode = eemPassword
    Properties.MaxLength = 16
    Properties.PasswordChar = '*'
    TabOrder = 3
    Width = 165
  end
end
