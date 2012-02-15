inherited fFormProductBillSH: TfFormProductBillSH
  Left = 386
  Top = 293
  Width = 568
  Height = 458
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited WordPanel: TPanel
    Width = 560
    Height = 424
    object GridList: TDrawGridEx
      Left = 0
      Top = 46
      Width = 560
      Height = 340
      Align = alClient
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 0
      Top = 386
      Width = 560
      Height = 38
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      OnResize = Panel1Resize
      object BtnOK: TImageButton
        Left = 186
        Top = 8
        Width = 58
        Height = 25
        OnClick = BtnOKClick
        ButtonID = 'qdsh'
        Checked = False
      end
      object BtnExit: TImageButton
        Left = 324
        Top = 8
        Width = 58
        Height = 25
        OnClick = BtnExitClick
        ButtonID = 'exit'
        Checked = False
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 560
      Height = 46
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      OnResize = Panel1Resize
      object Label1: TLabel
        Left = 8
        Top = 17
        Width = 46
        Height = 12
        Caption = #35746#21333#21495':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 150
        Top = 17
        Width = 46
        Height = 12
        Caption = #35746#36135#20154':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 300
        Top = 17
        Width = 59
        Height = 12
        Caption = #35746#36135#26102#38388':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EditID: TcxTextEdit
        Left = 55
        Top = 13
        Properties.ReadOnly = True
        Style.Edges = []
        TabOrder = 0
        Width = 85
      end
      object EditMan: TcxTextEdit
        Left = 198
        Top = 13
        Properties.ReadOnly = True
        Style.Edges = []
        TabOrder = 1
        Width = 85
      end
      object EditTime: TcxTextEdit
        Left = 360
        Top = 13
        Properties.ReadOnly = True
        Style.Edges = []
        TabOrder = 2
        Width = 125
      end
    end
  end
end
