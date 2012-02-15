inherited fFrameProductBillWarn: TfFrameProductBillWarn
  Width = 917
  Height = 461
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 917
    Height = 32
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = #21830#21697#35746#36135#26234#33021#39044#35686
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object wPage: TcxPageControl
    Left = 0
    Top = 32
    Width = 917
    Height = 429
    ActivePage = Sheet2
    Align = alClient
    LookAndFeel.Kind = lfUltraFlat
    LookAndFeel.NativeStyle = True
    TabOrder = 0
    ClientRectBottom = 425
    ClientRectLeft = 2
    ClientRectRight = 913
    ClientRectTop = 22
    object Sheet1: TcxTabSheet
      BorderWidth = 2
      Caption = #35746#36135#25552#37266
      ImageIndex = 1
      object GridProduct: TDrawGridEx
        Left = 0
        Top = 0
        Width = 907
        Height = 399
        Align = alClient
        TabOrder = 0
      end
    end
    object Sheet2: TcxTabSheet
      BorderWidth = 2
      Caption = #24050#24573#30053#30340#25552#37266
      ImageIndex = 0
      object GridIgnor: TDrawGridEx
        Left = 0
        Top = 0
        Width = 907
        Height = 399
        Align = alClient
        TabOrder = 0
        ColWidths = (
          64
          64
          64
          64
          64)
      end
    end
  end
end
