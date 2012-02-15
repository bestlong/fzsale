inherited fFrameRunStatus: TfFrameRunStatus
  Width = 378
  Height = 299
  object GroupBox1: TGroupBox
    Left = 8
    Top = 12
    Width = 362
    Height = 103
    Caption = #26381#21153#25511#21046
    TabOrder = 0
    object Label1: TLabel
      Left = 100
      Top = 39
      Width = 198
      Height = 12
      Caption = #27880': TCP'#25552#20379#21387#32553#25968#25454#27969#26381#21153','#24615#33021#39640'.'
    end
    object Label2: TLabel
      Left = 100
      Top = 79
      Width = 222
      Height = 12
      Caption = #27880': HTTP'#25552#20379'ASCII'#30721#26126#25991#20256#36755','#31283#23450#24615#22909'.'
    end
    object BtnTCP: TButton
      Left = 16
      Top = 26
      Width = 75
      Height = 25
      Caption = #21551#21160'TCP'
      TabOrder = 0
      OnClick = BtnTCPClick
    end
    object BtnHttp: TButton
      Left = 16
      Top = 66
      Width = 75
      Height = 25
      Caption = #21551#21160'HTTP'
      TabOrder = 1
      OnClick = BtnHttpClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 128
    Width = 362
    Height = 60
    Caption = #26381#21153#21442#25968
    TabOrder = 1
    object CheckAutoStart: TCheckBox
      Left = 16
      Top = 25
      Width = 120
      Height = 17
      Caption = #24320#26426#21518#21551#21160#26412#31243#24207
      TabOrder = 0
      OnClick = CheckAutoStartClick
    end
    object CheckAutoMin: TCheckBox
      Left = 145
      Top = 25
      Width = 120
      Height = 17
      Caption = #21551#21160#21518#33258#21160#26368#23567#21270
      TabOrder = 1
      OnClick = CheckAutoStartClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 200
    Width = 362
    Height = 90
    Caption = #31649#29702#21592#30331#24405
    TabOrder = 2
    object EditAdmin: TLabeledEdit
      Left = 70
      Top = 25
      Width = 175
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #31649#29702#36134#25143':'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object EditPwd: TLabeledEdit
      Left = 70
      Top = 55
      Width = 175
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #31649#29702#23494#30721':'
      LabelPosition = lpLeft
      PasswordChar = '*'
      TabOrder = 2
    end
    object BtnLogin: TButton
      Left = 250
      Top = 25
      Width = 55
      Height = 20
      Caption = #30331#24405
      TabOrder = 1
      OnClick = BtnLoginClick
    end
    object BtnSave: TButton
      Left = 250
      Top = 55
      Width = 55
      Height = 20
      Caption = #20445#23384
      TabOrder = 3
      OnClick = BtnSaveClick
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 324
    Top = 22
  end
end
