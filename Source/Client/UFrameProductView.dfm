inherited fFrameProductView: TfFrameProductView
  Width = 917
  Height = 461
  object Splitter1: TSplitter
    Left = 295
    Top = 0
    Height = 461
  end
  object PanelR: TPanel
    Left = 298
    Top = 0
    Width = 619
    Height = 461
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 619
      Height = 36
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
      Top = 36
      Width = 619
      Height = 425
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
    Top = 0
    Width = 295
    Height = 461
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Label2: TLabel
      Left = 0
      Top = 0
      Width = 295
      Height = 36
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #27454#24335#21015#34920
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object GridProduct: TDrawGridEx
      Left = 0
      Top = 36
      Width = 295
      Height = 425
      Align = alClient
      TabOrder = 0
    end
  end
end
