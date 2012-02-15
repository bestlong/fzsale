inherited fFrameReportProductReturn: TfFrameReportProductReturn
  Width = 917
  Height = 460
  object Splitter1: TSplitter
    Left = 407
    Top = 36
    Height = 424
  end
  object PanelR: TPanel
    Left = 410
    Top = 36
    Width = 507
    Height = 424
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 507
      Height = 45
      Align = alTop
      AutoSize = False
      Caption = #27454#24335#35814#32454#20449#24687
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object GridDetail: TDrawGridEx
      Left = 0
      Top = 45
      Width = 507
      Height = 379
      Align = alClient
      TabOrder = 0
      RowHeights = (
        24
        24
        24
        24
        24)
    end
  end
  object PanelL: TPanel
    Left = 0
    Top = 36
    Width = 407
    Height = 424
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object GridProduct: TDrawGridEx
      Left = 0
      Top = 45
      Width = 407
      Height = 379
      Align = alClient
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 407
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 30
        Height = 12
        Caption = #26465#20214':'
      end
      object BtnSearch: TImageButton
        Left = 320
        Top = 10
        Width = 69
        Height = 23
        OnClick = BtnSearchClick
        ButtonID = 'btn_query'
        Checked = False
      end
      object EditTime: TcxComboBox
        Left = 38
        Top = 12
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
        Left = 115
        Top = 12
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 1
        Width = 100
      end
      object EditE: TcxDateEdit
        Left = 218
        Top = 12
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 2
        Width = 100
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 917
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object Label2: TLabel
      Left = 0
      Top = 0
      Width = 917
      Height = 36
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #21830#21697#36864#36824#20195#29702#32479#35745
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
  end
end
