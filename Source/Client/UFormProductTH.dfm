inherited fFormProductTH: TfFormProductTH
  Left = 525
  Top = 317
  Width = 327
  Height = 320
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited WordPanel: TPanel
    Width = 319
    Height = 286
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 319
      Height = 36
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #36864#36135#21333
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object Label1: TLabel
      Left = 15
      Top = 78
      Width = 72
      Height = 16
      Caption = #24212#36864#37329#39069':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 15
      Top = 119
      Width = 72
      Height = 16
      Caption = #23454#36864#37329#39069':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 91
      Top = 119
      Width = 16
      Height = 16
      Caption = #65509
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 188
      Top = 119
      Width = 16
      Height = 16
      Caption = #20803
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 18
      Top = 163
      Width = 72
      Height = 20
      Caption = #21806#20986#20154#21592':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Panel1: TPanel
      Left = 0
      Top = 248
      Width = 319
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
    end
    object EditYMoney: TcxTextEdit
      Left = 90
      Top = 75
      Anchors = [akLeft, akTop, akRight]
      ParentFont = False
      Properties.ReadOnly = True
      Style.Edges = []
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      Width = 185
    end
    object EditMoney: TcxTextEdit
      Left = 108
      Top = 116
      ParentFont = False
      Properties.ReadOnly = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -14
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 2
      OnKeyPress = EditMoneyKeyPress
      Width = 75
    end
    object EditUser: TcxComboBox
      Left = 91
      Top = 160
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ItemHeight = 23
      Properties.Items.Strings = (
        '1.'#20170#26085
        '2.'#26152#26085
        '3.'#26412#26376
        '4.'#26412#23395#24230
        '5.'#26412#24180
        '6.'#33258#23450#20041)
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 3
      Width = 92
    end
  end
end
