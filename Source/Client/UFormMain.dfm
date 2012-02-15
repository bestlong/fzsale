inherited fFormMain: TfFormMain
  Left = 395
  Top = 338
  Width = 783
  Height = 471
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited WordPanel: TPanel
    Width = 775
    Height = 437
    object TitleBar: TPanel
      Left = 0
      Top = 0
      Width = 775
      Height = 80
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
      object ImageButton1: TImageButton
        Tag = 10
        Left = 0
        Top = 0
        Width = 80
        Height = 80
        Align = alLeft
        OnClick = ImageButton1Click
        ButtonID = 'zhxx'
        Checked = False
      end
      object ImageButton2: TImageButton
        Tag = 20
        Left = 80
        Top = 0
        Width = 80
        Height = 80
        Align = alLeft
        OnClick = ImageButton2Click
        ButtonID = 'ksyy'
        Checked = False
      end
      object ImageButton3: TImageButton
        Tag = 30
        Left = 160
        Top = 0
        Width = 80
        Height = 80
        Align = alLeft
        OnClick = ImageButton9Click
        ButtonID = 'xstj'
        Checked = False
      end
      object ImageButton4: TImageButton
        Tag = 40
        Left = 240
        Top = 0
        Width = 80
        Height = 80
        Align = alLeft
        OnClick = ImageButton9Click
        ButtonID = 'spgl'
        Checked = False
      end
      object ImageButton6: TImageButton
        Tag = 60
        Left = 320
        Top = 0
        Width = 80
        Height = 80
        Align = alLeft
        OnClick = ImageButton9Click
        ButtonID = 'hygl'
        Checked = False
      end
      object ImageButton8: TImageButton
        Tag = 80
        Left = 400
        Top = 0
        Width = 80
        Height = 80
        Align = alLeft
        OnClick = ImageButton8Click
        ButtonID = 'jytg'
        Checked = False
      end
      object ImageButton9: TImageButton
        Tag = 90
        Left = 480
        Top = 0
        Width = 80
        Height = 80
        Align = alLeft
        OnClick = ImageButton9Click
        ButtonID = 'xtsz'
        Checked = False
      end
      object TitleImageFit: TZnBitmapPanel
        Left = 560
        Top = 0
        Width = 215
        Height = 80
        Align = alClient
      end
    end
    object PanelMain: TPanel
      Left = 0
      Top = 109
      Width = 775
      Height = 328
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
    end
    object PanelHint: TZnBitmapPanel
      Left = 0
      Top = 80
      Width = 775
      Height = 29
      Align = alTop
      Color = clMoneyGreen
      object LabelTime: TLabel
        Left = 623
        Top = 0
        Width = 152
        Height = 29
        Align = alRight
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
      end
      object ImageTime: TImage
        Left = 581
        Top = 0
        Width = 42
        Height = 29
        Align = alRight
        Center = True
      end
      object ImageSmile: TImage
        Left = 0
        Top = 0
        Width = 42
        Height = 29
        Align = alLeft
        Center = True
        Transparent = True
      end
      object LabelSmile: TLabel
        Left = 42
        Top = 0
        Width = 111
        Height = 29
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Tag = 90
    AutoHotkeys = maManual
    Left = 502
    Top = 26
    object N3: TMenuItem
      Tag = 20
      Caption = #20462#25913#25105#30340#23494#30721
      OnClick = N1Click
    end
    object N1: TMenuItem
      Tag = 50
      Caption = #24215#38754#36164#26009#26356#26032
      OnClick = N1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object N5: TMenuItem
      Tag = 51
      Caption = #33829#38144#24080#21495#35774#32622
      OnClick = N1Click
    end
    object N18: TMenuItem
      Caption = '-'
    end
    object N19: TMenuItem
      Tag = 52
      Caption = #23567#31080#25171#21360#35774#32622
      OnClick = N1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Tag = 60
    AutoHotkeys = maManual
    Left = 347
    Top = 26
    object MenuMember: TMenuItem
      Tag = 50
      Caption = #28155#21152#26412#24215#20250#21592
      OnClick = MenuMemberClick
    end
    object MenuItem3: TMenuItem
      Tag = 10
      Caption = #26597#30475#26412#24215#20250#21592
      OnClick = MenuMemberClick
    end
    object MenuItem4: TMenuItem
      Caption = '-'
    end
    object N10: TMenuItem
      Tag = 51
      Caption = #20250#21592#25240#25187#35774#32622
      OnClick = MenuMemberClick
    end
  end
  object PopupMenu3: TPopupMenu
    Tag = 40
    AutoHotkeys = maManual
    Left = 268
    Top = 26
    object MenuProduct: TMenuItem
      Tag = 50
      Caption = #21830#21697#21021#22987#21270
      OnClick = MenuProductClick
    end
    object MenuItem6: TMenuItem
      Caption = '-'
    end
    object MenuItem7: TMenuItem
      Tag = 10
      Caption = #26597#30475#21830#21697#24211#23384
      OnClick = MenuProductClick
    end
    object MenuItem8: TMenuItem
      Caption = '-'
    end
    object N2: TMenuItem
      Tag = 51
      Caption = #26597#30475#35746#36135#21333
      OnClick = MenuProductClick
    end
    object N20: TMenuItem
      Tag = 52
      Caption = #26597#30475#36864#36135#21333
      OnClick = MenuProductClick
    end
    object N21: TMenuItem
      Caption = '-'
    end
    object N24: TMenuItem
      Tag = 53
      Caption = #35746#36135#26234#33021#39044#35686
      Visible = False
      OnClick = MenuProductClick
    end
    object N22: TMenuItem
      Tag = 12
      Caption = #35746#36135#21830#21697#20837#24211
      OnClick = MenuProductClick
    end
  end
  object MenuTJ: TPopupMenu
    Tag = 30
    AutoHotkeys = maManual
    Left = 182
    Top = 28
    object MenuReport: TMenuItem
      Tag = 50
      Caption = #38144#21806#26126#32454#34920
      OnClick = MenuReportClick
    end
    object MenuItem11: TMenuItem
      Tag = 51
      Caption = #38144#21806#27719#24635#34920
      OnClick = MenuReportClick
    end
    object MenuItem13: TMenuItem
      Caption = '-'
      Visible = False
    end
    object N9: TMenuItem
      Tag = 52
      Caption = #32463#33829#21033#28070#32479#35745
      Visible = False
      OnClick = MenuReportClick
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object N12: TMenuItem
      Tag = 53
      Caption = #21830#21697#36827#36135#32479#35745
      OnClick = MenuReportClick
    end
    object N17: TMenuItem
      Tag = 56
      Caption = #21830#21697#36864#36135#32479#35745
      OnClick = MenuReportClick
    end
    object N13: TMenuItem
      Tag = 54
      Caption = #39038#23458#36864#36135#32479#35745
      OnClick = MenuReportClick
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object N15: TMenuItem
      Tag = 55
      Caption = #33829#19994#21592#19994#32489
      OnClick = MenuReportClick
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 724
    Top = 28
  end
end
