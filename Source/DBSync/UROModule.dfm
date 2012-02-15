object ROModule: TROModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 380
  Top = 313
  Height = 229
  Width = 362
  object ROBinMsg: TROBinMessage
    Envelopes = <>
    Left = 32
    Top = 20
  end
  object ROSOAPMsg: TROSOAPMessage
    Envelopes = <>
    SerializationOptions = [xsoSendUntyped, xsoStrictStructureFieldOrder, xsoDocument, xsoSplitServiceWsdls]
    Left = 32
    Top = 72
  end
  object ROHttp1: TROIndyHTTPServer
    Dispatchers = <
      item
        Name = 'ROBinMsg'
        Message = ROBinMsg
        Enabled = True
        PathInfo = 'Bin'
      end
      item
        Name = 'ROSOAPMsg'
        Message = ROSOAPMsg
        Enabled = True
        PathInfo = 'SOAP'
      end>
    OnAfterServerActivate = ROHttp1AfterServerActivate
    OnAfterServerDeactivate = ROHttp1AfterServerActivate
    IndyServer.Bindings = <>
    IndyServer.DefaultPort = 8099
    IndyServer.OnConnect = ROHttp1InternalIndyServerConnect
    IndyServer.OnDisconnect = ROHttp1InternalIndyServerDisconnect
    Port = 8099
    Left = 92
    Top = 24
  end
  object ROTcp1: TROIndyTCPServer
    Dispatchers = <
      item
        Name = 'ROBinMsg'
        Message = ROBinMsg
        Enabled = True
      end>
    OnAfterServerActivate = ROHttp1AfterServerActivate
    OnAfterServerDeactivate = ROHttp1AfterServerActivate
    IndyServer.Bindings = <>
    IndyServer.DefaultPort = 8090
    IndyServer.OnConnect = ROTcp1InternalIndyServerConnect
    IndyServer.OnDisconnect = ROTcp1InternalIndyServerDisconnect
    Port = 8090
    Left = 92
    Top = 76
  end
  object RODisSrv1: TRODiscoveryServer
    OnServiceFound = RODisSrv1ServiceFound
    Left = 92
    Top = 130
  end
  object ROBroSrv1: TROBroadcastServer
    Dispatchers = <
      item
        Name = 'RODisMsg'
        Message = RODisMsg
        Enabled = True
      end>
    IndyUDPServer.BroadcastEnabled = True
    IndyUDPServer.Bindings = <>
    IndyUDPServer.DefaultPort = 8090
    IndyUDPServer.ThreadedEvent = True
    Port = 8090
    Left = 148
    Top = 131
  end
  object RODisMsg: TROBinMessage
    Envelopes = <>
    Left = 32
    Top = 128
  end
end
