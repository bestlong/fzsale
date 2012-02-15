inherited fFrameNotices: TfFrameNotices
  Width = 800
  Height = 426
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 71
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 59
      Height = 12
      Caption = #26085#26399#31579#36873':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 800
      Height = 36
      Align = alTop
      AutoSize = False
      Caption = #24635#20195#32463#33829#36890#21578
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object BtnSearch: TImageButton
      Left = 350
      Top = 35
      Width = 55
      Height = 22
      OnClick = BtnSearchClick
      ButtonID = 'btn_query'
      Checked = False
    end
    object EditTime: TcxComboBox
      Left = 68
      Top = 36
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        '1.'#20170#26085
        '2.'#26152#26085
        '3.'#26412#26376
        '4.'#26412#23395#24230
        '5.'#26412#24180
        '6.'#33258#23450#20041)
      Properties.OnEditValueChanged = EditTimePropertiesEditValueChanged
      TabOrder = 0
      Width = 75
    end
    object EditS: TcxDateEdit
      Left = 145
      Top = 36
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 100
    end
    object EditE: TcxDateEdit
      Left = 248
      Top = 36
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 100
    end
  end
  object GridList: TDrawGridEx
    Left = 0
    Top = 71
    Width = 800
    Height = 355
    Align = alClient
    TabOrder = 1
    RowHeights = (
      24
      24
      24
      24
      24)
  end
end
