{*******************************************************************************
  作者: dmzn@163.com 2010-8-6
  描述: 服务器模块
*******************************************************************************}
unit UROModule;

interface

uses
  SysUtils, Classes, SyncObjs, uROIndyTCPServer, uROClient, uROServer,
  IdContext, uROClassFactories, UMgrDBConn, uROIndyHTTPServer, uROSOAPMessage,
  uROBinMessage, uROServerIntf;

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
    FMaxRecordCount: Integer;
    //最大记录数
    FReloadInterval: Cardinal;
    //重载间隔
    FEnableSrvConn: Boolean;
    FEnableSrvDB: Boolean;
    //服务开关
    FURLLocalMIT: string;
    FVerLocalMIT: string;
    //本地中间件
    FURLClient  : string;
    FVerClient  : string;
    //终端店客户端
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
  end;

  TROModule = class(TDataModule)
    ROBinMsg: TROBinMessage;
    ROSOAPMsg: TROSOAPMessage;
    ROHttp1: TROIndyHTTPServer;
    ROTcp1: TROIndyTCPServer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ROHttp1AfterServerActivate(Sender: TObject);
    procedure ROHttp1InternalIndyServerConnect(AContext: TIdContext);
    procedure ROTcp1InternalIndyServerConnect(AContext: TIdContext);
    procedure ROHttp1InternalIndyServerDisconnect(AContext: TIdContext);
    procedure ROTcp1InternalIndyServerDisconnect(AContext: TIdContext);
  private
    { Private declarations }
    FLastReload: Cardinal;
    //上次载入
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
    function LoadDBConfigParam: Boolean;
    //载入数据配置
    function LockDBWorker(const nAgent: string; var nHint: string): PDBWorker;
    procedure ReleaseDBWorker(const nAgent: string; const nWorker: PDBWorker);
    //数据库连接
    function VerifyMAC(const nZID,nDID,nMAC: string; const nWorker: PDBWorker): Boolean;
    //验证MAC有效性
  end;
  
var
  ROModule: TROModule;
  gROModuleParam: TROModuleParam;

implementation

{$R *.dfm}

uses
  Windows, IniFiles, UDataModule, USysConst, USysDB, SrvConn_Impl, SrvDB_Impl,
  FZSale_Invk;

const
  cParam = 'ServiceParam';
  cUpdate = 'SoftUpdate';

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

        FMaxRecordCount := ReadInteger(cParam, 'MaxRecordCount', 100);
        FReloadInterval := ReadInteger(cParam, 'ReloadInterval', 300);

        FEnableSrvConn := ReadBool(cParam, 'EnableSrvConn', True);
        FEnableSrvDB := ReadBool(cParam, 'EnableSrvDB', True);

        FURLLocalMIT := ReadString(cUpdate, 'URLLocalMIT', '');
        FVerLocalMIT := ReadString(cUpdate, 'VerLocalMIT', '');
        FURLClient := ReadString(cUpdate, 'URLClient', '');
        FVerClient := ReadString(cUpdate, 'VerClient', '');
      end else
      begin
        WriteInteger(cParam, 'PortTCP', FPortTCP);
        WriteInteger(cParam, 'PortHttp', FPortHttp);

        WriteInteger(cParam, 'PoolSizeSrvConn', FPoolSizeSrvConn);
        WriteInteger(cParam, 'PoolSizeSrvDB', FPoolSizeSrvDB);

        WriteInteger(cParam, 'PoolBehaviorSrvConn', Ord(FPoolBehaviorSrvConn));
        WriteInteger(cParam, 'PoolBehaviorSrvDB', Ord(FPoolBehaviorSrvDB));

        WriteInteger(cParam, 'MaxRecordCount', FMaxRecordCount);
        WriteInteger(cParam, 'ReloadInterval', FReloadInterval);

        WriteBool(cParam, 'EnableSrvConn', FEnableSrvConn);
        WriteBool(cParam, 'EnableSrvDB', FEnableSrvDB);

        WriteString(cUpdate, 'URLLocalMIT', FURLLocalMIT);
        WriteString(cUpdate, 'VerLocalMIT', FVerLocalMIT);
        WriteString(cUpdate, 'URLClient', FURLClient);
        WriteString(cUpdate, 'VerClient', FVerClient);
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
    FSrvConn := TROPooledClassFactory.Create('SrvConn',
                Create_SrvConn, TSrvConn_Invoker,
                FPoolSizeSrvConn, FPoolBehaviorSrvConn);
    FSrvDB := TROPooledClassFactory.Create('SrvDB',
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
  with nParam, gSysParam, FDM do
  begin
    begin
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

    LoadDBConfigParam;
    //读取数据配置
  end;

  if (FSrvConn = nil) or (FSrvDB = nil) then
    RegClassFactories;
  //xxxxx
end;

//Desc: 服务关闭后善后工作
procedure TROModule.AfterStopServer;
begin
  gDBConnManager.ClearParam;
  //清理参数
  gDBConnManager.Disconnection();
  //关闭连接
end;

//------------------------------------------------------------------------------
//Desc: 重载数据库连接参数
function TROModule.LoadDBConfigParam: Boolean;
var nStr: string;
    nParam: TDBParam;
begin
  Result := False;
  FSyncLock.Enter;
  try
    if (GetTickCount - FLastReload) >= (gROModuleParam.FReloadInterval * 1000) then
         FLastReload := GetTickCount
    else Exit;
  finally
    FSyncLock.Leave;
  end;

  nStr := 'Select * From ' + sTable_MITDB;
  with FDM.QuerySQL(nStr) do
  if RecordCount > 0 then
  begin
    gDBConnManager.ClearParam;
    First;

    while not Eof do
    begin
      with nParam do
      if FieldByName('D_Invalid').AsString <> sFlag_Yes then
      begin
        FID   := FieldByName('D_Agent').AsString;
        FHost := FieldByName('D_Host').AsString;
        FPort := FieldByName('D_Port').AsInteger;
        FDB   := FieldByName('D_DBName').AsString;
        FUser := FieldByName('D_User').AsString;
        FPwd  := FieldByName('D_Pwd').AsString;
        FConn := FieldByName('D_ConnStr').AsString;
        gDBConnManager.AddParam(nParam);
      end;

      Next;
    end;

    Result := True;
  end;
end;

//Desc: 获取nAgent代理商的数据库连接
function TROModule.LockDBWorker(const nAgent: string;
  var nHint: string): PDBWorker;
var nErr,nInt: Integer;
begin
  Result := nil;
  try
    nInt := 2;

    while nInt > 0 do
    begin
      Result := gDBConnManager.GetConnection(nAgent, nErr);
      if Assigned(Result) then Exit;

      Dec(nInt);
      if (nInt = 1) and (nErr = cErr_GetConn_NoParam) then
        if LoadDBConfigParam then Continue;
      Dec(nInt);

      case nErr of
        cErr_GetConn_NoAllowed: nHint := '数据连接池已关闭!';
        cErr_GetConn_Closing:   nHint := '数据连接池正在关闭!';
        cErr_GetConn_NoParam:   nHint := '没有找到指定连接池!'
                       else     nHint := '检索连接池对象错误!';
      end;
    end;
  except
    on e:Exception do
    begin
      nHint := e.Message;
    end;
  end;
end;

//Desc: 释放数据库连接
procedure TROModule.ReleaseDBWorker(const nAgent: string; const nWorker: PDBWorker);
begin
  gDBConnManager.ReleaseConnection(nAgent, nWorker);
end;

//Desc: 验证终端店的MAC地址是否有效
function TROModule.VerifyMAC(const nZID, nDID, nMAC: string;
 const nWorker: PDBWorker): Boolean;
begin
  Result := True;
end;

end.
