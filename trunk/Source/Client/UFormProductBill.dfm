inherited fFormProductBill: TfFormProductBill
  Left = 386
  Top = 293
  Width = 652
  Height = 560
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited WordPanel: TPanel
    Width = 644
    Height = 526
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 644
      Height = 36
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #22635#20889#35814#32454#20449#24687
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
      Top = 36
      Width = 644
      Height = 452
      Align = alClient
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 0
      Top = 488
      Width = 644
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
  end
end
