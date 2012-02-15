inherited fFormReturnConfirm: TfFormReturnConfirm
  Left = 437
  Top = 157
  Width = 517
  Height = 377
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited WordPanel: TPanel
    Width = 509
    Height = 343
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 509
      Height = 36
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #36864#36135#21333#30830#35748
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object GridList: TDrawGridEx
      Left = 0
      Top = 68
      Width = 509
      Height = 237
      Align = alClient
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 0
      Top = 305
      Width = 509
      Height = 38
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      OnResize = Panel1Resize
      object BtnOK: TImageButton
        Left = 172
        Top = 6
        Width = 58
        Height = 25
        OnClick = BtnOKClick
        ButtonID = 'ok'
        Checked = False
      end
      object BtnCancel: TImageButton
        Left = 276
        Top = 6
        Width = 58
        Height = 25
        OnClick = BtnCancelClick
        ButtonID = 'cancel'
        Checked = False
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 36
      Width = 509
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      OnResize = Panel1Resize
      object Label1: TLabel
        Left = 8
        Top = 11
        Width = 46
        Height = 12
        Caption = #36864#21333#21495':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 150
        Top = 11
        Width = 46
        Height = 12
        Caption = #36864#36135#20154':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 300
        Top = 11
        Width = 59
        Height = 12
        Caption = #36864#36135#26102#38388':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EditID: TcxTextEdit
        Left = 55
        Top = 6
        Properties.ReadOnly = True
        Style.Edges = []
        TabOrder = 0
        Width = 85
      end
      object EditMan: TcxTextEdit
        Left = 198
        Top = 6
        Properties.ReadOnly = True
        Style.Edges = []
        TabOrder = 1
        Width = 85
      end
      object EditTime: TcxTextEdit
        Left = 360
        Top = 6
        Properties.ReadOnly = True
        Style.Edges = []
        TabOrder = 2
        Width = 125
      end
    end
  end
end
