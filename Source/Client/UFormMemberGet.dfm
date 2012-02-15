inherited fFormMemberGet: TfFormMemberGet
  Left = 476
  Top = 402
  Width = 396
  Height = 241
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited WordPanel: TPanel
    Width = 388
    Height = 207
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 388
      Height = 36
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #35831#36755#20837#20250#21592#21345#21495':'
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
      Top = 127
      Width = 388
      Height = 42
      Align = alBottom
      AutoSize = False
      Caption = '  1.'#21487#29992#38190#30424#24405#20837#25110#32773#30452#25509#21047#21345#65307#13#10'  2.'#22914#26524#26080#20250#21592#21345#30452#25509#28857#20987#30830#23450#25110#25353#22238#36710#38190#65307
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Panel1: TPanel
      Left = 0
      Top = 169
      Width = 388
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
    object EditID: TcxTextEdit
      Left = 12
      Top = 60
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -20
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      OnKeyPress = EditIDKeyPress
      Height = 32
      Width = 345
    end
  end
end
