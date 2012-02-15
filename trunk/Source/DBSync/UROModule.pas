{*******************************************************************************
  ����: dmzn@163.com 2010-8-6
  ����: ������ģ��
*******************************************************************************}
unit UROModule;

{$I Link.Inc}
interface

uses
  SysUtils, Classes, SyncObjs, uROIndyTCPServer, uROClient, uROServer,
  IdContext, uROClassFactories, UMgrDBConn, uROIndyHTTPServer, uROSOAPMessage,
  uROBinMessage, uROServerIntf, uRODiscovery, uROIndyUDPServer,
  uRODiscovery_Intf, uROTypes, uROBroadcastServer;

type
  TROServerType = (stTcp, stHttp);
  TROServerTypes = set of TROServerType;
  //��������

  TROModuleParam = record
    FPortTCP: Integer;
    FPortHttp: Integer;
    //�����˿�
    FPoolSizeSrvConn: Integer;
    FPoolSizeSrvDB: Integer;
    //�����
    FPoolBehaviorSrvConn: TROPoolBehavior;
    FPoolBehaviorSrvDB: TROPoolBehavior;
    //����ģʽ
    FVerLocalMIT: string;
    FVerClient  : string;
    //�ն˰汾
    FRemoteURL: string;
    //Զ�̷���
  end;

  PROModuleStatus = ^TROModuleStatus;
  TROModuleStatus = record
    FSrvTCP: Boolean;
    FSrvHttp: Boolean;    //����״̬
    FNumTCPActive: Cardinal;
    FNumTCPTotal: Cardinal;
    FNumTCPMax: Cardinal;
    FNumHttpActive: Cardinal;
    FNumHttpMax: Cardinal;
    FNumHttpTotal: Cardinal; //���Ӽ���
    FNumConn: Cardinal;
    FNumDB: Cardinal;
    FNumSweetHeart: Cardinal;
    FNumSignIn: Cardinal;
    FNumRegister: Cardinal;
    FNumSQLQuery: Cardinal;
    FNumSQLExecute: Cardinal;
    FNumSQLUpdates: Cardinal; //�������
    FNumActionError: Cardinal;//ִ�д������

    FTerminalID: string;
    FSpID: string;
    FMAC: string;
    //����,�ն˱�ʶ
    FOnline: Boolean;
    //�Ƿ�����
  end;

  TROModule = class(TDataModule)
    ROBinMsg: TROBinMessage;
    ROSOAPMsg: TROSOAPMessage;
    ROHttp1: TROIndyHTTPServer;
    ROTcp1: TROIndyTCPServer;
    RODisSrv1: TRODiscoveryServer;
    ROBroSrv1: TROBroadcastServer;
    RODisMsg: TROBinMessage;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ROHttp1AfterServerActivate(Sender: TObject);
    procedure ROHttp1InternalIndyServerConnect(AContext: TIdContext);
    procedure ROTcp1InternalIndyServerConnect(AContext: TIdContext);
    procedure ROHttp1InternalIndyServerDisconnect(AContext: TIdContext);
    procedure ROTcp1InternalIndyServerDisconnect(AContext: TIdContext);
    procedure RODisSrv1ServiceFound(aSender: TObject; aName: String;
      var ioDiscoveryOptions: TRODiscoveryOptions; var ioHandled: Boolean);
  private
    { Private declarations }
    FStatus: TROModuleStatus;
    //����״̬
    FSrvConn: IROClassFactory;
    //���ӷ����೧
    FSrvDB: IROClassFactory;
    //���ݷ����೧
    FSyncLock: TCriticalSection;
    //ͬ����
    procedure RegClassFactories;
    //ע���೧
    procedure UnregClassFactories;
    //��ע��
    procedure BeforeStartServer;
    procedure AfterStopServer;
    //׼��,�ƺ�
  public
    { Public declarations }
    function ActiveServer(const nServer: TROServerTypes; const nActive: Boolean;
     var nMsg: string): Boolean;
    //�������
    function LockModuleStatus: PROModuleStatus;
    procedure ReleaseStatusLock;
    //��ȡ״̬
    procedure ActionROModuleParam(const nIsRead: Boolean);
    //�������
  end;
  
var
  ROModule: TROModule;
  gROModuleParam: TROModuleParam;

implementation

{$R *.dfm}

uses
  Windows, IniFiles, UDataModule, USysService, USysMAC, USysConst,
  SrvConn_Impl, SrvDB_Impl, FZSale_Invk;

const
  cParam = 'DBSync';

procedure TROModule.ActionROModuleParam(const nIsRead: Boolean);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    with gROModuleParam,nIni do
    begin
      if nIsRead then
      begin
        FPortTCP := ReadInteger(cParam, 'PortTCP', 8081);
        FPortHttp := ReadInteger(cParam, 'PortHttp', 8082);

        FPoolSizeSrvConn := ReadInteger(cParam, 'PoolSizeSrvConn', 5);
        FPoolSizeSrvDB := ReadInteger(cParam, 'PoolSizeSrvDB', 20);

        FPoolBehaviorSrvConn := TROPoolBehavior(ReadInteger(cParam, 'PoolBehaviorSrvConn', Ord(pbWait)));
        FPoolBehaviorSrvDB := TROPoolBehavior(ReadInteger(cParam, 'PoolBehaviorSrvDB', Ord(pbWait)));
        FRemoteURL := ReadString(cParam, 'RemoteURL', '');

        with LockModuleStatus^ do
        try
          FStatus.FTerminalID := ReadString(cParam, 'TerminalID', '');
          FStatus.FSpID := ReadString(cParam, 'SpID', '');
        finally
          ReleaseStatusLock;
        end;
      end else
      begin
        WriteInteger(cParam, 'PortTCP', FPortTCP);
        WriteInteger(cParam, 'PortHttp', FPortHttp);

        WriteInteger(cParam, 'PoolSizeSrvConn', FPoolSizeSrvConn);
        WriteInteger(cParam, 'PoolSizeSrvDB', FPoolSizeSrvDB);

        WriteInteger(cParam, 'PoolBehaviorSrvConn', Ord(FPoolBehaviorSrvConn));
        WriteInteger(cParam, 'PoolBehaviorSrvDB', Ord(FPoolBehaviorSrvDB));
        WriteString(cParam, 'RemoteURL', FRemoteURL);

        with LockModuleStatus^ do
        try
          WriteString(cParam, 'TerminalID', FTerminalID);
          WriteString(cParam, 'SpID', FSpID);
        finally
          ReleaseStatusLock;
        end;
      end;
    end;
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TROModule.DataModuleCreate(Sender: TObject);
begin
  FSrvConn := nil;
  FSrvDB := nil;
  FillChar(FStatus, SizeOf(FStatus), #0);

  FSyncLock := TCriticalSection.Create;
  ActionROModuleParam(True);
  FStatus.FMAC := MakeActionID_MAC;
end;

procedure TROModule.DataModuleDestroy(Sender: TObject);
var nStr: string;
begin
  ActiveServer([stTcp, stHttp], False, nStr);
  UnregClassFactories;
  FSyncLock.Free;
end;

//Desc: ͬ������ģ��״̬
function TROModule.LockModuleStatus: PROModuleStatus;
begin
  FSyncLock.Enter;
  Result := @FStatus;
end;

//Desc: �ͷ�ģ��ͬ����
procedure TROModule.ReleaseStatusLock;
begin
  FSyncLock.Leave;
end;

//Desc: ����������
procedure TROModule.ROHttp1AfterServerActivate(Sender: TObject);
begin
  with gROModuleParam, LockModuleStatus^ do
  begin
    FSrvTCP := ROTcp1.Active;
    FSrvHttp := ROHttp1.Active;
    ReleaseStatusLock;
  end;

  if not (csDestroying in ComponentState) then
    AdminStatusChange(gSysParam.FIsAdmin);
  //xxxxx
end;

//Desc: TCP������
procedure TROModule.ROTcp1InternalIndyServerConnect(AContext: TIdContext);
begin
  with gROModuleParam, LockModuleStatus^ do
  begin
    FNumTCPTotal := FNumTCPTotal + 1;
    FNumTCPActive := FNumTCPActive + 1;
    
    if FNumTCPActive > FNumTCPMax then
      FNumTCPMax := FNumTCPActive;
    ReleaseStatusLock;
  end;
end;

//Desc: Http������
procedure TROModule.ROHttp1InternalIndyServerConnect(AContext: TIdContext);
begin
  with gROModuleParam, LockModuleStatus^ do
  begin
    FNumHttpTotal := FNumHttpTotal + 1;
    FNumHttpActive := FNumHttpActive + 1;

    if FNumHttpActive > FNumHttpMax then
      FNumHttpMax := FNumHttpActive;
    ReleaseStatusLock;
  end;
end;

//Desc: TCP�Ͽ�
procedure TROModule.ROTcp1InternalIndyServerDisconnect(AContext: TIdContext);
begin
  with gROModuleParam, LockModuleStatus^ do
  begin
    FNumTCPActive := FNumTCPActive - 1;
    ReleaseStatusLock;
  end;
end;

//Desc: HTTP�Ͽ�
procedure TROModule.ROHttp1InternalIndyServerDisconnect(AContext: TIdContext);
begin
  with gROModuleParam, LockModuleStatus^ do
  begin
    FNumHttpActive := FNumHttpActive - 1;
    ReleaseStatusLock;
  end;
end;

//------------------------------------------------------------------------------
procedure Create_SrvDB(out anInstance : IUnknown);
begin
  anInstance := TSrvDB.Create;
end;

procedure Create_SrvConn(out anInstance : IUnknown);
begin
  anInstance := TSrvConn.Create;
end;

//Desc: ע���೧
procedure TROModule.RegClassFactories;
begin
  UnregClassFactories;
  with gROModuleParam do
  begin
    FSrvConn := TROPooledClassFactory.Create(cService_Conn,
                Create_SrvConn, TSrvConn_Invoker,
                FPoolSizeSrvConn, FPoolBehaviorSrvConn);
    FSrvDB := TROPooledClassFactory.Create(cService_DB,
                Create_SrvDB, TSrvDB_Invoker,
                FPoolSizeSrvDB, FPoolBehaviorSrvDB);
  end;
end;

//Desc: ע���೧
procedure TROModule.UnregClassFactories;
begin
  if Assigned(FSrvConn) then
  begin
    UnRegisterClassFactory(FSrvConn);
    FSrvConn := nil;
  end;

  if Assigned(FSrvDB) then
  begin
    UnRegisterClassFactory(FSrvDB);
    FSrvDB := nil;
  end;
end;

//Date: 2010-8-7
//Parm: ��������;����;��ʾ��Ϣ
//Desc: ��nServerִ��nActive����
function TROModule.ActiveServer(const nServer: TROServerTypes;
  const nActive: Boolean; var nMsg: string): Boolean;
begin
  try
    if nActive and ((not ROTcp1.Active) and (not ROHttp1.Active)) then
      BeforeStartServer;
    //����ǰ׼��

    if stTcp in nServer then
    begin
      if nActive then ROTcp1.Active := False;
      ROTcp1.Port := gROModuleParam.FPortTCP;
      ROTcp1.Active := nActive;
    end;

    if stHttp in nServer then
    begin
      if nActive then ROHttp1.Active := False;
      ROHttp1.Port := gROModuleParam.FPortHttp;
      ROHttp1.Active := nActive;
    end;

    ROBroSrv1.Active := ROHttp1.Active or ROTcp1.Active;
    //����㲥

    if (not ROTcp1.Active) and (not ROHttp1.Active) then
    begin
      UnregClassFactories;
      //ж���೧
      AfterStopServer;
      //�ر��ƺ�
    end;

    Result := True;
    nMsg := '';
  except
    on nE:Exception do
    begin
      Result := False;
      nMsg := nE.Message;
      ShowDebugLog(nMsg, True);
    end;
  end;
end;

//Desc: ����ǰ׼������
procedure TROModule.BeforeStartServer;
var nParam: TDBParam;
begin
  {$IFDEF EnableSyncDB}
  with nParam, gSysParam, FDM do
  begin
    begin
      FID := sSysDB;
      FHost := FLocalHost;
      FPort := FLocalPort;
      FDB := FLocalDB;
      FUser := FLocalUser;
      FPwd := FLocalPwd;
      FConn := FLocalConn;
    end;

    LocalConn.Close;
    LocalConn.ConnectionString := gDBConnManager.MakeDBConnection(nParam);
    LocalConn.Connected := True;

    AdjustAllSystemTables;
    //����ϵͳ��
    LocalConn.Connected := False;
    gDBConnManager.AddParam(nParam);
  end;
  {$ENDIF}

  if (FSrvConn = nil) or (FSrvDB = nil) then
    RegClassFactories;
  //xxxxx

  with RODisSrv1 do
  begin
    ServiceList.Clear;
    ServiceList.Add(cService_DB);
    ServiceList.Add(cService_Conn);
  end;
end;

//Desc: ����رպ��ƺ���
procedure TROModule.AfterStopServer;
begin
  FDM.LocalConn.Connected := False;
end;

//------------------------------------------------------------------------------
type
  TMyDiscoveryResultOptions = class(TRODiscoveryOptions)
  private
    FPath: string;
  published
    property Path: string read FPath write FPath;
  end;

//Desc: �������ݴ���
procedure TROModule.RODisSrv1ServiceFound(aSender: TObject; aName: String;
  var ioDiscoveryOptions: TRODiscoveryOptions; var ioHandled: Boolean);
var nStr: string;
begin
  with gROModuleParam do
  begin
    nStr := Format(':%d/Bin', [FPortHttp]);
    ioDiscoveryOptions := TMyDiscoveryResultOptions.Create;
    TMyDiscoveryResultOptions(ioDiscoveryOptions).Path := nStr;
  end;
end;

initialization
  RegisterROClass(TMyDiscoveryResultOptions);
finalization
  UnregisterROClass(TMyDiscoveryResultOptions);
end.
