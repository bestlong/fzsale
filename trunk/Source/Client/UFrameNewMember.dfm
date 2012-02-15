inherited fFrameNewMember: TfFrameNewMember
  Width = 444
  Height = 312
  object Label2: TLabel
    Left = 0
    Top = 0
    Width = 444
    Height = 36
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = #24405#20837#26032#20250#21592
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label1: TLabel
    Left = 32
    Top = 51
    Width = 54
    Height = 12
    Caption = #20250#21592#21345#21495':'
    Transparent = True
  end
  object Label3: TLabel
    Left = 32
    Top = 133
    Width = 54
    Height = 12
    Caption = #20250#21592#21517#31216':'
    Transparent = True
  end
  object Label4: TLabel
    Left = 32
    Top = 215
    Width = 54
    Height = 12
    Caption = #32852#31995#26041#24335':'
    Transparent = True
  end
  object Label5: TLabel
    Left = 32
    Top = 160
    Width = 54
    Height = 12
    Caption = #24615'    '#21035':'
    Transparent = True
  end
  object Label6: TLabel
    Left = 32
    Top = 188
    Width = 54
    Height = 12
    Caption = #32852#31995#22320#22336':'
    Transparent = True
  end
  object Label7: TLabel
    Left = 32
    Top = 78
    Width = 54
    Height = 12
    Caption = #36523#20221#35777#21495':'
    Transparent = True
  end
  object Label8: TLabel
    Left = 32
    Top = 106
    Width = 54
    Height = 12
    Caption = #20986#29983#26085#26399':'
    Transparent = True
  end
  object ImageButton1: TImageButton
    Left = 92
    Top = 245
    Width = 65
    Height = 25
    OnClick = BtnOKClick
    ButtonID = 'btn_ok'
    Checked = False
  end
  object ImageButton2: TImageButton
    Left = 224
    Top = 245
    Width = 65
    Height = 25
    OnClick = BtnExitClick
    ButtonID = 'btn_cancel'
    Checked = False
  end
  object EditCard: TcxTextEdit
    Left = 92
    Top = 47
    ParentFont = False
    Properties.MaxLength = 15
    TabOrder = 0
    Width = 300
  end
  object EditName: TcxTextEdit
    Left = 92
    Top = 126
    ParentFont = False
    Properties.MaxLength = 32
    TabOrder = 3
    Width = 300
  end
  object EditPhone: TcxTextEdit
    Left = 92
    Top = 212
    ParentFont = False
    Properties.MaxLength = 32
    TabOrder = 6
    Width = 300
  end
  object EditAddr: TcxTextEdit
    Left = 92
    Top = 186
    ParentFont = False
    Properties.MaxLength = 80
    TabOrder = 5
    Width = 300
  end
  object Radio3: TcxRadioButton
    Left = 32
    Top = 286
    Width = 85
    Height = 17
    Caption = #26412#24215#20351#29992
    Checked = True
    TabOrder = 7
    TabStop = True
    Visible = False
    Transparent = True
  end
  object Radio4: TcxRadioButton
    Left = 135
    Top = 286
    Width = 135
    Height = 17
    Caption = #25152#26377#36830#38145#24215#22343#21487
    TabOrder = 8
    Visible = False
    Transparent = True
  end
  object cxGroupBox1: TcxGroupBox
    Left = 92
    Top = 153
    TabOrder = 4
    Transparent = True
    Height = 27
    Width = 300
    object Radio1: TcxRadioButton
      Left = 1
      Top = 7
      Width = 42
      Height = 17
      Caption = #30007
      Checked = True
      TabOrder = 0
      TabStop = True
      Transparent = True
    end
    object Radio2: TcxRadioButton
      Left = 45
      Top = 7
      Width = 42
      Height = 17
      Caption = #22899
      TabOrder = 1
      Transparent = True
    end
  end
  object EditSF: TcxTextEdit
    Left = 92
    Top = 74
    ParentFont = False
    Properties.MaxLength = 20
    TabOrder = 1
    Width = 300
  end
  object EditDate: TcxDateEdit
    Left = 92
    Top = 100
    TabOrder = 2
    Width = 300
  end
end
