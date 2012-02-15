inherited fFormProductFilterColor: TfFormProductFilterColor
  Left = 525
  Top = 317
  Width = 353
  Height = 320
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited WordPanel: TPanel
    Width = 345
    Height = 286
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 345
      Height = 36
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #35831#36873#25321#21830#21697#30340#39068#33394
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object Label1: TLabel
      Left = 0
      Top = 206
      Width = 345
      Height = 42
      Align = alBottom
      AutoSize = False
      Caption = '  '#35828#26126#65306'1.'#21487#29992#40736#26631#30452#25509#28857#20987#65307#13#10'        2.'#21487#29992#26041#21521#38190#36873#25321#39068#33394#21518#25353#22238#36710#38190#13#10
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Panel1: TPanel
      Left = 0
      Top = 248
      Width = 345
      Height = 38
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      OnResize = Panel1Resize
      object BtnOK: TImageButton
        Left = 148
        Top = 8
        Width = 58
        Height = 25
        OnClick = BtnOKClick
        ButtonID = 'ok'
        Checked = False
      end
      object BtnExit: TImageButton
        Left = 230
        Top = 8
        Width = 58
        Height = 25
        OnClick = BtnExitClick
        ButtonID = 'cancel'
        Checked = False
      end
    end
    object EditName: TcxTextEdit
      Left = 12
      Top = 38
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      ParentFont = False
      Properties.ReadOnly = True
      Style.Edges = []
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -20
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      Text = #26080
      Height = 28
      Width = 300
    end
    object ListColor: TcxListBox
      Left = 12
      Top = 74
      Width = 300
      Height = 85
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 22
      ListStyle = lbOwnerDrawFixed
      ParentFont = False
      Style.Edges = []
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clGray
      Style.Font.Height = -16
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 2
      OnDblClick = ListColorDblClick
      OnKeyPress = ListColorKeyPress
    end
  end
end
