inherited fFrameUpdate: TfFrameUpdate
  Width = 411
  Height = 187
  object GroupBox1: TGroupBox
    Left = 8
    Top = 18
    Width = 397
    Height = 159
    Anchors = [akLeft, akTop, akRight]
    Caption = #36719#20214#21319#32423
    TabOrder = 1
    object EditMITVer: TLabeledEdit
      Left = 65
      Top = 25
      Width = 135
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 48
      EditLabel.Height = 12
      EditLabel.Caption = 'MIT'#29256#26412':'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object EditMITUrl: TLabeledEdit
      Left = 65
      Top = 53
      Width = 320
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 48
      EditLabel.Height = 12
      EditLabel.Caption = 'MIT'#21319#32423':'
      LabelPosition = lpLeft
      TabOrder = 1
    end
    object EditClientUrl: TLabeledEdit
      Left = 65
      Top = 123
      Width = 320
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #32456#31471#21319#32423':'
      LabelPosition = lpLeft
      TabOrder = 3
    end
    object EditClientVer: TLabeledEdit
      Left = 65
      Top = 95
      Width = 135
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #32456#31471#29256#26412':'
      LabelPosition = lpLeft
      TabOrder = 2
    end
  end
  object BtnSave: TButton
    Left = 367
    Top = 2
    Width = 38
    Height = 20
    Anchors = [akTop, akRight]
    Caption = #20445#23384
    TabOrder = 0
    OnClick = BtnSaveClick
  end
end
