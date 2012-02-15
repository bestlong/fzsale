inherited fFrameProductReturn: TfFrameProductReturn
  Width = 917
  Height = 461
  object PanelR: TPanel
    Left = 0
    Top = 0
    Width = 917
    Height = 461
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 917
      Height = 36
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #21830#21697#36864#36824#20195#29702#21830
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
      Top = 36
      Width = 917
      Height = 425
      ActivePage = Sheet1
      Align = alClient
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = True
      TabOrder = 0
      OnChange = wPageChange
      ClientRectBottom = 421
      ClientRectLeft = 2
      ClientRectRight = 913
      ClientRectTop = 22
      object Sheet1: TcxTabSheet
        Caption = #22788#29702#20013#30340#36864#36135#21333
        ImageIndex = 0
        object GridBill: TDrawGridEx
          Left = 0
          Top = 0
          Width = 911
          Height = 399
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
      object Sheet2: TcxTabSheet
        Caption = #24050#23436#25104#30340#36864#36135#21333
        ImageIndex = 1
        object GridDone: TDrawGridEx
          Left = 0
          Top = 0
          Width = 911
          Height = 399
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
    end
  end
end
