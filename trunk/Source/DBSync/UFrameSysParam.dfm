inherited fFrameSysParam: TfFrameSysParam
  Width = 421
  Height = 284
  object GroupBox1: TGroupBox
    Left = 8
    Top = 18
    Width = 406
    Height = 60
    Anchors = [akLeft, akTop, akRight]
    Caption = #26381#21153#31471#21475
    TabOrder = 1
    object EditPortTCP: TLabeledEdit
      Left = 62
      Top = 25
      Width = 105
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 48
      EditLabel.Height = 12
      EditLabel.Caption = 'TCP'#31471#21475':'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object EditPortHTTP: TLabeledEdit
      Left = 245
      Top = 25
      Width = 105
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = 'HTTP'#31471#21475':'
      LabelPosition = lpLeft
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 85
    Width = 201
    Height = 92
    Anchors = [akLeft, akTop, akRight]
    Caption = #36830#25509#23545#35937
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 26
      Width = 6
      Height = 12
    end
    object Label2: TLabel
      Left = 10
      Top = 53
      Width = 54
      Height = 12
      Caption = #35831#27714#24322#24120':'
    end
    object EditSizeConn: TLabeledEdit
      Left = 66
      Top = 22
      Width = 115
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #32531#20914#22823#23567':'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object EditBehaviorSrvConn: TComboBox
      Left = 66
      Top = 50
      Width = 115
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 12
      ParentCtl3D = False
      TabOrder = 1
      Items.Strings = (
        '0.'#30452#25509#36864#20986
        '1.'#31561#24453#37322#25918
        '2.'#33258#21160#21019#24314)
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 185
    Width = 406
    Height = 85
    Anchors = [akLeft, akTop, akRight]
    Caption = #36828#31243#26381#21153
    TabOrder = 4
    DesignSize = (
      406
      85)
    object Label4: TLabel
      Left = 10
      Top = 48
      Width = 387
      Height = 32
      AutoSize = False
      Caption = #27880': '#35831#22635#20889#27491#30830#30340#26381#21153#22120#20013#38388#20214'URL'#22320#22336','#24418#24335#22914': http://0.0.0.0/bin'
      WordWrap = True
    end
    object EditURL: TLabeledEdit
      Left = 62
      Top = 22
      Width = 283
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 48
      EditLabel.Height = 12
      EditLabel.Caption = #26381#21153'URL:'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object BtnTest: TButton
      Left = 349
      Top = 22
      Width = 38
      Height = 20
      Anchors = [akTop, akRight]
      Caption = #27979#35797
      TabOrder = 1
      OnClick = BtnTestClick
    end
  end
  object BtnSave: TButton
    Left = 376
    Top = 2
    Width = 38
    Height = 20
    Anchors = [akTop, akRight]
    Caption = #20445#23384
    TabOrder = 0
    OnClick = BtnSaveClick
  end
  object GroupBox4: TGroupBox
    Left = 213
    Top = 85
    Width = 201
    Height = 92
    Anchors = [akLeft, akTop, akRight]
    Caption = #25968#25454#23545#35937
    TabOrder = 3
    object Label3: TLabel
      Left = 10
      Top = 53
      Width = 54
      Height = 12
      Caption = #35831#27714#24322#24120':'
    end
    object EditSizeDB: TLabeledEdit
      Left = 66
      Top = 22
      Width = 115
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #32531#20914#22823#23567':'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object EditBehaviorSrvDB: TComboBox
      Left = 66
      Top = 50
      Width = 115
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 12
      ParentCtl3D = False
      TabOrder = 1
      Items.Strings = (
        '0.'#30452#25509#36864#20986
        '1.'#31561#24453#37322#25918
        '2.'#33258#21160#21019#24314)
    end
  end
end
