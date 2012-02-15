inherited fFormReportSalerView: TfFormReportSalerView
  Left = 317
  Top = 200
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
      ColWidths = (
        64
        64
        64
        64
        64)
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
        ButtonID = 'ok'
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
        Width = 59
        Height = 12
        Caption = #38144#21806#26102#38388':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EditDate: TcxTextEdit
        Left = 68
        Top = 13
        Properties.ReadOnly = True
        Style.Edges = []
        TabOrder = 0
        Text = '0000-00-00'#33267'0000-00-00'
        Width = 320
      end
    end
  end
end
