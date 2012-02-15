inherited fFrameProductSale: TfFrameProductSale
  Width = 856
  Height = 466
  object GridList: TDrawGridEx
    Left = 0
    Top = 65
    Width = 856
    Height = 366
    Align = alClient
    TabOrder = 0
  end
  object PanelT: TPanel
    Left = 0
    Top = 0
    Width = 856
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 45
      Width = 59
      Height = 12
      Caption = #20250#21592#21517#31216':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 140
      Top = 45
      Width = 33
      Height = 12
      Caption = #32534#21495':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 255
      Top = 45
      Width = 46
      Height = 12
      Caption = #24050#28040#36153':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 392
      Top = 45
      Width = 59
      Height = 12
      Caption = #20248#24800#25171#25240':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 856
      Height = 36
      Align = alTop
      AutoSize = False
      Caption = #38144#21806#28165#21333
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object EditName: TcxTextEdit
      Left = 68
      Top = 42
      ParentFont = False
      Properties.ReadOnly = True
      Style.Edges = []
      TabOrder = 0
      Text = #26080
      Width = 65
    end
    object EditID: TcxTextEdit
      Left = 175
      Top = 42
      ParentFont = False
      Properties.ReadOnly = True
      Style.Edges = []
      TabOrder = 1
      Text = #26080
      Width = 75
    end
    object EditMoney: TcxTextEdit
      Left = 302
      Top = 42
      ParentFont = False
      Properties.ReadOnly = True
      Style.Edges = []
      TabOrder = 2
      Text = '0'#20803
      Width = 90
    end
    object EditZhekou: TcxTextEdit
      Left = 455
      Top = 42
      ParentFont = False
      Properties.ReadOnly = True
      Style.Edges = []
      TabOrder = 3
      Text = #26080'!'
      Width = 72
    end
  end
  object PanelB: TPanel
    Left = 0
    Top = 431
    Width = 856
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    OnResize = PanelBResize
    object BtnJZ: TImageButton
      Left = 35
      Top = 8
      Width = 89
      Height = 24
      OnClick = BtnJZClick
      ButtonID = 'qrjz'
      Checked = False
    end
    object BtnCancel: TImageButton
      Left = 134
      Top = 8
      Width = 89
      Height = 24
      OnClick = BtnCancelClick
      ButtonID = 'cancel'
      Checked = False
    end
    object BtnGetPrd: TImageButton
      Left = 404
      Top = 8
      Width = 89
      Height = 24
      OnClick = BtnGetPrdClick
      ButtonID = 'xzsp'
      Checked = False
    end
    object BtnMember: TImageButton
      Left = 505
      Top = 8
      Width = 89
      Height = 24
      OnClick = BtnMemberClick
      ButtonID = 'srhy'
      Checked = False
    end
    object BtnCode: TImageButton
      Left = 605
      Top = 8
      Width = 89
      Height = 24
      OnClick = BtnCodeClick
      ButtonID = 'srtm'
      Checked = False
    end
    object BtnTH: TImageButton
      Left = 706
      Top = 8
      Width = 89
      Height = 24
      OnClick = BtnTHClick
      ButtonID = 'spth'
      Checked = False
    end
  end
end
