inherited fFormProductConfirm: TfFormProductConfirm
  Left = 318
  Top = 314
  Width = 366
  Height = 402
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited WordPanel: TPanel
    Width = 358
    Height = 368
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 358
      Height = 36
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #21830#21697#30830#35748
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 12
      Top = 53
      Width = 68
      Height = 14
      Caption = #21830#21697#21517#31216':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 12
      Top = 80
      Width = 68
      Height = 14
      Caption = #21697#29260#21517#31216':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 12
      Top = 107
      Width = 70
      Height = 14
      Caption = #39068'    '#33394':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 12
      Top = 134
      Width = 70
      Height = 14
      Caption = #23610'    '#30721':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 12
      Top = 162
      Width = 70
      Height = 14
      Caption = #21333'    '#20215':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 12
      Top = 189
      Width = 69
      Height = 14
      Caption = #25240' '#25187' '#20215':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 12
      Top = 216
      Width = 70
      Height = 14
      Caption = #20214'    '#25968':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 12
      Top = 243
      Width = 68
      Height = 14
      Caption = #37329#39069#23567#35745':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Panel1: TPanel
      Left = 0
      Top = 273
      Width = 358
      Height = 95
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      OnResize = Panel1Resize
      object BtnOK: TImageButton
        Left = 162
        Top = 8
        Width = 58
        Height = 25
        OnClick = BtnOKClick
        ButtonID = 'ok'
        Checked = False
      end
      object BtnExit: TImageButton
        Left = 252
        Top = 8
        Width = 58
        Height = 25
        OnClick = BtnExitClick
        ButtonID = 'cancel'
        Checked = False
      end
      object Label1: TLabel
        Left = 0
        Top = 40
        Width = 358
        Height = 55
        Align = alBottom
        AutoSize = False
        Caption = 
          '  '#35828#26126#65306'1.'#21487#25163#21160#35843#25972#25968#37327#65307#13#10'        2.'#30452#25509#25353#22238#36710#38190#21017#40664#35748#20026#30830#23450#35813#21830#21697#65307#13#10'        3.'#28857#20987#21462#28040#21017#37325#26032#24405#20837 +
          #21830#21697#65307
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -14
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
    end
    object EditStyle: TcxTextEdit
      Left = 82
      Top = 50
      Anchors = [akLeft, akTop, akRight]
      Properties.ReadOnly = True
      Style.Edges = []
      TabOrder = 1
      Text = #26080
      Width = 257
    end
    object EditBrand: TcxTextEdit
      Left = 82
      Top = 77
      Anchors = [akLeft, akTop, akRight]
      Properties.ReadOnly = True
      Style.Edges = []
      TabOrder = 2
      Text = #26080
      Width = 257
    end
    object EditColor: TcxTextEdit
      Left = 82
      Top = 104
      Anchors = [akLeft, akTop, akRight]
      Properties.ReadOnly = True
      Style.Edges = []
      TabOrder = 3
      Text = #26080
      Width = 257
    end
    object EditSize: TcxTextEdit
      Left = 82
      Top = 131
      Anchors = [akLeft, akTop, akRight]
      Properties.ReadOnly = True
      Style.Edges = []
      TabOrder = 4
      Text = #26080
      Width = 257
    end
    object EditOldPrice: TcxTextEdit
      Left = 82
      Top = 159
      Anchors = [akLeft, akTop, akRight]
      Properties.ReadOnly = True
      Style.Edges = []
      TabOrder = 5
      Text = #26080
      Width = 257
    end
    object EditPrice: TcxTextEdit
      Left = 82
      Top = 186
      Anchors = [akLeft, akTop, akRight]
      Properties.ReadOnly = True
      Style.Edges = []
      TabOrder = 6
      Text = #26080
      Width = 257
    end
    object EditNum: TcxTextEdit
      Left = 82
      Top = 213
      Properties.ReadOnly = False
      Properties.OnEditValueChanged = EditNumPropertiesEditValueChanged
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 7
      Text = '0'
      OnKeyPress = EditNumKeyPress
      Width = 55
    end
    object EditXJ: TcxTextEdit
      Left = 82
      Top = 240
      Anchors = [akLeft, akTop, akRight]
      Properties.ReadOnly = True
      Style.Edges = []
      TabOrder = 8
      Text = #26080
      Width = 257
    end
  end
end
