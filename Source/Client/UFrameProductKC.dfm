inherited fFrameProductKC: TfFrameProductKC
  Width = 917
  Height = 461
  object Splitter1: TSplitter
    Left = 275
    Top = 0
    Height = 461
  end
  object PanelR: TPanel
    Left = 278
    Top = 0
    Width = 639
    Height = 461
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 639
      Height = 55
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
      Top = 55
      Width = 639
      Height = 406
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
    Width = 275
    Height = 461
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 275
      Height = 32
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #21830#21697#27454#24335#21015#34920
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
      Width = 275
      Height = 429
      ActivePage = Sheet1
      Align = alClient
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = True
      TabOrder = 0
      OnChange = wPageChange
      ClientRectBottom = 425
      ClientRectLeft = 2
      ClientRectRight = 271
      ClientRectTop = 22
      object Sheet1: TcxTabSheet
        BorderWidth = 2
        Caption = #25105#30340#21830#21697#24211
        ImageIndex = 1
        object GridProduct: TDrawGridEx
          Left = 0
          Top = 0
          Width = 265
          Height = 399
          Align = alClient
          TabOrder = 0
          object ImageButton1: TImageButton
            Left = 102
            Top = 222
            Width = 105
            Height = 105
            Checked = False
          end
        end
      end
      object Sheet2: TcxTabSheet
        BorderWidth = 2
        Caption = 'xx'#21830#21697#24211
        ImageIndex = 0
        object GridPBrand: TDrawGridEx
          Left = 0
          Top = 0
          Width = 265
          Height = 399
          Align = alClient
          TabOrder = 0
        end
      end
    end
  end
end
