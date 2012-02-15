inherited fFrameSysParam: TfFrameSysParam
  Width = 420
  Height = 340
  object GroupBox1: TGroupBox
    Left = 8
    Top = 18
    Width = 405
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
    Width = 200
    Height = 108
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
    Top = 200
    Width = 405
    Height = 85
    Anchors = [akLeft, akTop, akRight]
    Caption = #25968#25454#37325#36733
    TabOrder = 4
    object Label4: TLabel
      Left = 10
      Top = 48
      Width = 387
      Height = 32
      AutoSize = False
      Caption = #27880': '#26381#21153#25910#21040#23458#25143#31471#35831#27714#21518','#33509#21457#29983#24322#24120'('#22914': '#23494#30721#38169#35823','#36830#25509#22833#36133#31561'),'#21017#20250#37325#26032#35835#21462#25968#25454#24211'.'#27599#27425#37325#36733#38656#35201#26102#38388#24046','#21542#21017#23481#26131#34987#25915#20987'.'
      WordWrap = True
    end
    object EditInterval: TLabeledEdit
      Left = 90
      Top = 22
      Width = 100
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 78
      EditLabel.Height = 12
      EditLabel.Caption = #21047#26032#38388#38548'('#31186'):'
      LabelPosition = lpLeft
      TabOrder = 0
    end
  end
  object BtnSave: TButton
    Left = 375
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
    Width = 200
    Height = 108
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
    object EditMaxRecord: TLabeledEdit
      Left = 68
      Top = 78
      Width = 115
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #26368#22810#26465#30446':'
      LabelPosition = lpLeft
      TabOrder = 2
    end
  end
end
