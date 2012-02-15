inherited fFormProductGet: TfFormProductGet
  Left = 386
  Top = 293
  Width = 690
  Height = 436
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited WordPanel: TPanel
    Width = 682
    Height = 402
    object Splitter1: TSplitter
      Left = 223
      Top = 0
      Height = 402
    end
    object PanelL: TPanel
      Left = 0
      Top = 0
      Width = 223
      Height = 402
      Align = alLeft
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 223
        Height = 36
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = #27454#24335#21015#34920
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object GridStyle: TDrawGridEx
        Left = 0
        Top = 36
        Width = 223
        Height = 366
        Align = alClient
        TabOrder = 0
      end
    end
    object PanelR: TPanel
      Left = 226
      Top = 0
      Width = 456
      Height = 402
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object LabelHint: TLabel
        Left = 0
        Top = 0
        Width = 456
        Height = 36
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = #35814#32454#20449#24687
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object GridDetail: TDrawGridEx
        Left = 0
        Top = 36
        Width = 456
        Height = 366
        Align = alClient
        TabOrder = 0
      end
    end
  end
end
