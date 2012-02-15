inherited fFrameUserAccount: TfFrameUserAccount
  Width = 522
  Height = 270
  object GridList: TDrawGridEx
    Left = 0
    Top = 51
    Width = 522
    Height = 219
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 522
    Height = 51
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 522
      Height = 32
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #33829#38144#24080#21495#35774#32622
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object BtnAddUser: TImageButton
      Left = 8
      Top = 24
      Width = 85
      Height = 23
      OnClick = BtnAddUserClick
      ButtonID = 'btn_add_user'
      Checked = False
    end
  end
end
