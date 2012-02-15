inherited fFrameReportSaleTotal: TfFrameReportSaleTotal
  Width = 917
  Height = 461
  object GridList: TDrawGridEx
    Left = 0
    Top = 70
    Width = 917
    Height = 391
    Align = alClient
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 917
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 917
      Height = 36
      Align = alTop
      AutoSize = False
      Caption = #38144#21806#27719#24635#32479#35745#25253#34920
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object Label1: TLabel
      Left = 8
      Top = 44
      Width = 30
      Height = 12
      Caption = #26465#20214':'
    end
    object BtnSearch: TImageButton
      Left = 320
      Top = 39
      Width = 69
      Height = 23
      OnClick = BtnSearchClick
      ButtonID = 'btn_query'
      Checked = False
    end
    object EditTime: TcxComboBox
      Left = 38
      Top = 40
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        '1.'#20170#26085
        '2.'#26152#26085
        '3.'#26412#26376
        '4.'#26412#23395#24230
        '5.'#26412#24180
        '6.'#33258#23450#20041)
      Properties.OnEditValueChanged = EditNowPropertiesEditValueChanged
      TabOrder = 0
      Width = 75
    end
    object EditS: TcxDateEdit
      Left = 115
      Top = 40
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 100
    end
    object EditE: TcxDateEdit
      Left = 218
      Top = 40
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 100
    end
  end
end
