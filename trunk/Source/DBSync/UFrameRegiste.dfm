inherited fFrameRegiste: TfFrameRegiste
  Width = 421
  Height = 183
  object GroupBox1: TGroupBox
    Left = 8
    Top = 18
    Width = 406
    Height = 155
    Anchors = [akLeft, akTop, akRight]
    Caption = #27880#20876#26412#26426
    TabOrder = 1
    object Label4: TLabel
      Left = 8
      Top = 118
      Width = 390
      Height = 25
      AutoSize = False
      Caption = #27880': '#20026#20102#23433#20840#36215#35265','#32456#31471#38656#35201#21521#26381#21153#22120#27880#20876','#31649#29702#21592#35748#35777#36890#36807#21518#25165#33021#20351#29992'.'
      WordWrap = True
    end
    object EditDID: TLabeledEdit
      Left = 80
      Top = 23
      Width = 165
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 66
      EditLabel.Height = 12
      EditLabel.Caption = #20195#29702#21830#32534#21495':'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object EditZID: TLabeledEdit
      Left = 80
      Top = 52
      Width = 165
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 66
      EditLabel.Height = 12
      EditLabel.Caption = #32456#31471#24215#32534#21495':'
      LabelPosition = lpLeft
      TabOrder = 1
    end
    object EditMAC: TLabeledEdit
      Left = 80
      Top = 81
      Width = 165
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 72
      EditLabel.Height = 12
      EditLabel.Caption = #26412#26426'MAC'#26631#35782':'
      LabelPosition = lpLeft
      TabOrder = 2
    end
  end
  object BtnReg: TButton
    Left = 376
    Top = 2
    Width = 38
    Height = 20
    Anchors = [akTop, akRight]
    Caption = #27880#20876
    TabOrder = 0
    OnClick = BtnRegClick
  end
end
