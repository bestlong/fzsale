object FDM: TFDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 327
  Top = 139
  Height = 178
  Width = 282
  object ROChannel: TROBroadcastChannel
    Retrys = 5
    IndyClient.BroadcastEnabled = True
    IndyClient.Port = 8090
    Port = 8090
    ServerLocators = <>
    DispatchOptions = []
    Left = 69
    Top = 25
  end
  object ROClient: TRODiscoveryClient
    Channel = ROChannel
    Message = ROMsg
    ServiceName = 'SomeService'
    OnNewServiceFound = ROClientNewServiceFound
    Left = 120
    Top = 25
  end
  object ROMsg: TROBinMessage
    Envelopes = <>
    Left = 16
    Top = 23
  end
  object XPMan1: TXPManifest
    Left = 14
    Top = 86
  end
  object EditStyle1: TcxDefaultEditStyleController
    Style.BorderColor = clSkyBlue
    Style.BorderStyle = ebsSingle
    Style.Font.Charset = GB2312_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -12
    Style.Font.Name = #23435#20307
    Style.Font.Style = []
    Style.Gradient = False
    Style.IsFontAssigned = True
    StyleFocused.BorderStyle = ebsSingle
    Left = 66
    Top = 84
    PixelsPerInch = 96
  end
  object cxLF1: TcxLookAndFeelController
    Kind = lfOffice11
    Left = 118
    Top = 84
  end
end
