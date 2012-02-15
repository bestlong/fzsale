inherited fFrameRunLog: TfFrameRunLog
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 42
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderWidth = 5
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 0
    DesignSize = (
      320
      42)
    object Check1: TCheckBox
      Left = 10
      Top = 12
      Width = 125
      Height = 17
      Caption = #26174#31034#31995#32479#35843#35797#26085#24535
      TabOrder = 0
      OnClick = Check1Click
    end
    object BtnClear: TButton
      Left = 264
      Top = 12
      Width = 45
      Height = 20
      Anchors = [akTop, akRight]
      Caption = #28165#31354
      TabOrder = 2
      OnClick = BtnClearClick
    end
    object BtnCopy: TButton
      Left = 214
      Top = 12
      Width = 45
      Height = 20
      Anchors = [akTop, akRight]
      Caption = #22797#21046
      TabOrder = 1
      OnClick = BtnCopyClick
    end
  end
  object MemoLog: TMemo
    Left = 0
    Top = 42
    Width = 320
    Height = 198
    Align = alClient
    BorderStyle = bsNone
    ReadOnly = True
    TabOrder = 1
  end
end
