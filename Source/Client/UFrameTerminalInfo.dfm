inherited fFrameTerminalInfo: TfFrameTerminalInfo
  Width = 424
  object Label1: TLabel
    Left = 35
    Top = 48
    Width = 54
    Height = 12
    Caption = #24215#38754#22320#22336':'
    Transparent = True
  end
  object Label2: TLabel
    Left = 155
    Top = 15
    Width = 120
    Height = 19
    Caption = #24215#38754#36164#26009#26356#26032
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 35
    Top = 75
    Width = 54
    Height = 12
    Caption = #24215#38754#21517#31216':'
    Transparent = True
  end
  object Label4: TLabel
    Left = 35
    Top = 102
    Width = 54
    Height = 12
    Caption = #24215#20027#22995#21517':'
    Transparent = True
  end
  object Label5: TLabel
    Left = 35
    Top = 128
    Width = 54
    Height = 12
    Caption = #24615'    '#21035':'
    Transparent = True
  end
  object Label6: TLabel
    Left = 35
    Top = 155
    Width = 54
    Height = 12
    Caption = #32852#31995#26041#24335':'
    Transparent = True
  end
  object ImageButton1: TImageButton
    Left = 98
    Top = 180
    Width = 77
    Height = 33
    OnClick = BtnOKClick
    ButtonID = 'btn_ok'
    Checked = False
  end
  object ImageButton2: TImageButton
    Left = 220
    Top = 180
    Width = 77
    Height = 33
    OnClick = BtnExitClick
    ButtonID = 'btn_cancel'
    Checked = False
  end
  object EditAddr: TcxTextEdit
    Left = 98
    Top = 45
    ParentFont = False
    TabOrder = 0
    Width = 300
  end
  object EditName: TcxTextEdit
    Left = 98
    Top = 73
    ParentFont = False
    TabOrder = 1
    Width = 300
  end
  object EditUser: TcxTextEdit
    Left = 98
    Top = 100
    ParentFont = False
    TabOrder = 2
    Width = 165
  end
  object EditPhone: TcxTextEdit
    Left = 98
    Top = 152
    ParentFont = False
    TabOrder = 3
    Width = 165
  end
  object Radio1: TcxRadioButton
    Left = 98
    Top = 128
    Width = 50
    Height = 17
    Caption = #30007
    TabOrder = 4
    Transparent = True
  end
  object Radio2: TcxRadioButton
    Left = 165
    Top = 128
    Width = 50
    Height = 17
    Caption = #22899
    Checked = True
    TabOrder = 5
    TabStop = True
    Transparent = True
  end
end
