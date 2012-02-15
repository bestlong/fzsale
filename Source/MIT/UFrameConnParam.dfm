inherited fFrameConnParam: TfFrameConnParam
  Width = 392
  Height = 292
  object GroupBox1: TGroupBox
    Left = 10
    Top = 18
    Width = 374
    Height = 265
    Anchors = [akLeft, akTop, akRight]
    Caption = #31995#32479#25968#25454#24211
    TabOrder = 2
    DesignSize = (
      374
      265)
    object Label1: TLabel
      Left = 10
      Top = 150
      Width = 324
      Height = 12
      Caption = #36830#25509#23383#31526#20018':$DBName,$Host,$User,$Pwd,$Port'#20026#21487#29992#23439#23450#20041'.'
    end
    object EditHost: TLabeledEdit
      Left = 10
      Top = 35
      Width = 145
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 66
      EditLabel.Height = 12
      EditLabel.Caption = #26381#21153#22120#22320#22336':'
      TabOrder = 0
    end
    object EditPort: TLabeledEdit
      Left = 185
      Top = 35
      Width = 145
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #26381#21153#31471#21475':'
      TabOrder = 1
    end
    object EditDB: TLabeledEdit
      Left = 10
      Top = 77
      Width = 145
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 60
      EditLabel.Height = 12
      EditLabel.Caption = #25968#25454#24211#21517#31216
      TabOrder = 2
    end
    object EditUser: TLabeledEdit
      Left = 187
      Top = 77
      Width = 145
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #30331#24405#24080#25143':'
      TabOrder = 3
    end
    object EditPwd: TLabeledEdit
      Left = 10
      Top = 119
      Width = 145
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #30331#24405#23494#30721':'
      PasswordChar = '*'
      TabOrder = 4
    end
    object MemoConn: TMemo
      Left = 10
      Top = 168
      Width = 352
      Height = 88
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelKind = bkFlat
      BorderStyle = bsNone
      TabOrder = 5
    end
  end
  object BtnSave: TButton
    Left = 346
    Top = 2
    Width = 38
    Height = 20
    Anchors = [akTop, akRight]
    Caption = #20445#23384
    TabOrder = 1
    OnClick = BtnSaveClick
  end
  object BtnTest: TButton
    Left = 308
    Top = 2
    Width = 38
    Height = 20
    Anchors = [akTop, akRight]
    Caption = #27979#35797
    TabOrder = 0
    OnClick = BtnTestClick
  end
end
