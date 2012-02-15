inherited fFormProductJZ: TfFormProductJZ
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
      Caption = #32467#31639#21333
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
      Top = 68
      Width = 72
      Height = 16
      Caption = #24212#25910#37329#39069':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 15
      Top = 101
      Width = 72
      Height = 16
      Caption = #23454#25910#37329#39069':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 15
      Top = 135
      Width = 72
      Height = 16
      Caption = #20026#24744#33410#30465':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 15
      Top = 168
      Width = 72
      Height = 16
      Caption = #25214'    '#38646':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 93
      Top = 101
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
      Top = 101
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
      Top = 65
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
      Left = 110
      Top = 98
      ParentFont = False
      Properties.ReadOnly = False
      Properties.OnChange = EditMoneyPropertiesChange
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 2
      OnKeyPress = EditMoneyKeyPress
      Width = 75
    end
    object EditJMoney: TcxTextEdit
      Left = 90
      Top = 132
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
      TabOrder = 3
      Width = 185
    end
    object EditZMoney: TcxTextEdit
      Left = 90
      Top = 165
      Anchors = [akLeft, akTop, akRight]
      ParentFont = False
      Properties.ReadOnly = True
      Style.Edges = []
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clRed
      Style.Font.Height = -16
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 4
      Width = 185
    end
  end
end
