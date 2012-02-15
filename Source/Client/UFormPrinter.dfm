inherited fFormPrinterSetup: TfFormPrinterSetup
  Left = 476
  Top = 402
  Width = 346
  Height = 321
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited WordPanel: TPanel
    Width = 338
    Height = 287
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 338
      Height = 36
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #25171#21360#26426#35774#32622
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object Label1: TLabel
      Left = 10
      Top = 45
      Width = 54
      Height = 12
      Caption = #26631#39064#20869#23481':'
    end
    object Label2: TLabel
      Left = 10
      Top = 92
      Width = 54
      Height = 12
      Caption = #38468#21152#20869#23481':'
    end
    object Panel1: TPanel
      Left = 0
      Top = 249
      Width = 338
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
    object EditTitle: TcxTextEdit
      Left = 10
      Top = 60
      Anchors = [akLeft, akTop, akRight]
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 1
      Width = 300
    end
    object EditEnding: TcxMemo
      Left = 10
      Top = 108
      Anchors = [akLeft, akTop, akRight, akBottom]
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 2
      Height = 107
      Width = 300
    end
  end
end
