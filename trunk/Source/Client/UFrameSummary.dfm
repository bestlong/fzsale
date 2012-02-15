inherited fFrameSummary: TfFrameSummary
  Width = 973
  Height = 658
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 973
    Height = 658
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = dxLayoutWeb1
    object GridYesday: TDrawGridEx
      Left = 18
      Top = 60
      Width = 360
      Height = 95
      BorderStyle = bsNone
      TabOrder = 0
    end
    object GridNotices: TDrawGridEx
      Left = 406
      Top = 60
      Width = 363
      Height = 155
      BorderStyle = bsNone
      TabOrder = 1
    end
    object GridTenday: TDrawGridEx
      Left = 18
      Top = 259
      Width = 360
      Height = 181
      BorderStyle = bsNone
      TabOrder = 2
    end
    object GridWarn: TDrawGridEx
      Left = 406
      Top = 259
      Width = 373
      Height = 181
      BorderStyle = bsNone
      TabOrder = 3
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group4: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        Offsets.Top = 15
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Group1: TdxLayoutGroup
          Caption = #26152#26085#38144#21806#35814#24773
          object dxLayoutControl1Item1: TdxLayoutItem
            AutoAligns = [aaHorizontal]
            AlignVert = avClient
            Caption = 'DrawGridEx1'
            ShowCaption = False
            Control = GridYesday
          end
        end
        object dxLayoutControl1Group2: TdxLayoutGroup
          AutoAligns = [aaVertical]
          Caption = #24635#24215#36890#30693
          Offsets.Left = 15
          object dxLayoutControl1Item2: TdxLayoutItem
            AutoAligns = [aaHorizontal]
            AlignVert = avClient
            Caption = 'DrawGridEx2'
            ShowCaption = False
            Control = GridNotices
          end
        end
      end
      object dxLayoutControl1Group6: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Group3: TdxLayoutGroup
          AutoAligns = [aaHorizontal]
          Caption = #36817#21313#26085#38144#21806#25490#34892
          object dxLayoutControl1Item3: TdxLayoutItem
            AutoAligns = [aaHorizontal]
            AlignVert = avClient
            Caption = 'DrawGridEx3'
            ShowCaption = False
            Control = GridTenday
          end
        end
        object dxLayoutControl1Group5: TdxLayoutGroup
          AutoAligns = [aaVertical]
          Caption = #26234#33021#39044#35686
          Offsets.Left = 15
          Visible = False
          object dxLayoutControl1Item4: TdxLayoutItem
            AutoAligns = [aaHorizontal]
            AlignVert = avClient
            Caption = 'DrawGridEx4'
            ShowCaption = False
            Control = GridWarn
          end
        end
      end
    end
  end
  object dxLayout1: TdxLayoutLookAndFeelList
    Left = 360
    Top = 52
    object dxLayoutWeb1: TdxLayoutWebLookAndFeel
      GroupOptions.CaptionOptions.Font.Charset = GB2312_CHARSET
      GroupOptions.CaptionOptions.Font.Color = clWindowText
      GroupOptions.CaptionOptions.Font.Height = -16
      GroupOptions.CaptionOptions.Font.Name = #23435#20307
      GroupOptions.CaptionOptions.Font.Style = []
      GroupOptions.CaptionOptions.UseDefaultFont = False
      GroupOptions.CaptionOptions.Color = clWhite
      GroupOptions.CaptionOptions.SeparatorWidth = 1
      GroupOptions.FrameColor = 16572094
      GroupOptions.FrameWidth = 0
      GroupOptions.OffsetItems = False
      ItemOptions.CaptionOptions.Font.Charset = GB2312_CHARSET
      ItemOptions.CaptionOptions.Font.Color = clWindowText
      ItemOptions.CaptionOptions.Font.Height = -12
      ItemOptions.CaptionOptions.Font.Name = #23435#20307
      ItemOptions.CaptionOptions.Font.Style = []
      ItemOptions.CaptionOptions.UseDefaultFont = False
      ItemOptions.ControlBorderStyle = lbsNone
      Offsets.ControlOffsetHorz = 2
      Offsets.ItemOffset = 3
    end
  end
end
