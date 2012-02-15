{*******************************************************************************
  作者: dmzn@163.com 2010-8-6
  描述: 服务器模块
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
  //服务类型

  TROModuleParam = record
    FPortTCP: Integer;
    FPortHttp: Integer;
    //监听端口
    FPoolSizeSrvConn: Integer;
    FPoolSizeSrvDB: Integer;
    //缓冲池
    FPoolBehaviorSrvConn: TROPoolBehavior;
    FPoolBehaviorSrvDB: TROPoolBehavior;
    //缓冲模式
    FVerLocalMIT: string;
    FVerClient  : string;
    //终端版本
    FRemoteURL: string;
    //远程服务
  end;

  PROModuleStatus = ^TROModuleStatus;
  TROModuleStatus = record
    FSrvTCP: Boolean;
    FSrvHttp: Boolean;    //服务状态
    FNumTCPActive: Cardinal;
    FNumTCPTotal: Cardinal;
    FNumTCPMax: Cardinal;
    FNumHttpActive: Cardinal;
    FNumHttpMax: Cardinal;
    FNumHttpTotal: Cardinal; //连接计数
    FNumConn: Cardinal;
    FNumDB: Cardinal;
    FNumSweetHeart: Cardinal;
    FNumSignIn: Cardinal;
    FNumRegister: Cardinal;
    FNumSQLQuery: Cardinal;
    FNumSQLExecute: Cardinal;
    FNumSQLUpdates: Cardinal; //请求计数
    FNumActionError: Cardinal;//执行错误计数

    FTerminalID: string;
    FSpID: string;
    FMAC: string;
    //代理,终端标识
    FOnline: Boolean;
    //是否连线
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
    //运行状态
    FSrvConn: IROClassFactory;
    //连接服务类厂
    FSrvDB: IROClassFactory;
    //数据服务类厂
    FSyncLock: TCriticalSection;
    //同步锁
    procedure RegClassFactories;
    //注册类厂
    procedure UnregClassFactories;
    //反注册
    procedure BeforeStartServer;
    procedure AfterStopServer;
    //准备,善后
  public
    { Public declarations }
    function ActiveServer(const nServer: TROServerTypes; const nActive: Boolean;
     var nMsg: string): Boolean;
    //服务操作
    function LockModuleStatus: PROModuleStatus;
    procedure ReleaseStatusLock;
    //获取状态
    procedure ActionROModuleParam(const nIsRead: Boolean);
    //处理参数
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

//Desc: 同步锁定模块状态
function TROModule.LockModuleStatus: PROModuleStatus;
begin
  FSyncLock.Enter;
  Result := @FStatus;
end;

//Desc: 释放模块同步锁
procedure TROModule.ReleaseStatusLock;
begin
  FSyncLock.Leave;
end;

//Desc: 服务器启动
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

//Desc: TCP新连接
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

//Desc: Http新连接
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

//Desc: TCP断开
procedure TROModule.ROTcp1InternalIndyServerDisconnect(AContext: TIdContext);
begin
  with gROModuleParam, LockModuleStatus^ do
  begin
    FNumTCPActive := FNumTCPActive - 1;
    ReleaseStatusLock;
  end;
end;

//Desc: HTTP断开
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

//Desc: 注册类厂
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

//Desc: 注销类厂
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
//Parm: 服务类型;动作;提示信息
//Desc: 对nServer执行nActive动作
function TROModule.ActiveServer(const nServer: TROServerTypes;
  const nActive: Boolean; var nMsg: string): Boolean;
begin
  try
    if nActive and ((not ROTcp1.Active) and (not ROHttp1.Active)) then
      BeforeStartServer;
    //启动前准备

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
    //服务广播

    if (not ROTcp1.Active) and (not ROHttp1.Active) then
    begin
      UnregClassFactories;
      //卸载类厂
      AfterStopServer;
      //关闭善后
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

//Desc: 启动前准备工作
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
    //重置系统表
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

//Desc: 服务关闭后善后工作
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

//Desc: 服务内容传递
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
