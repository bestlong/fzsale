{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 数据模块
*******************************************************************************}
unit UDataModule;

interface

uses
  Windows, SysUtils, Classes, DBClient, DB, SyncObjs, FZSale_Intf,
  uROClient, uROBinMessage, uRODiscovery, uROIndyUDPChannel,
  uROBroadcastChannel, uRODiscovery_Intf, XPMan, cxEdit, cxLookAndFeels;

type
  PDataSetItem = ^TDataSetItem;
  TDataSetItem = record
    FUsed: Boolean;       //是否使用
    FDS: TClientDataSet;  //数据集
  end;

  TDataSetArray = array of TDataSetItem;
  //数据集列表

  TFDM = class(TDataModule)
    ROChannel: TROBroadcastChannel;
    ROClient: TRODiscoveryClient;
    ROMsg: TROBinMessage;
    XPMan1: TXPManifest;
    EditStyle1: TcxDefaultEditStyleController;
    cxLF1: TcxLookAndFeelController;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ROClientNewServiceFound(aSender: TObject; aName: String;
      aDiscoveryOptions: TRODiscoveryOptions);
  private
    { Private declarations }
    FDSArray: TDataSetArray;
    //数据集
    FLock: TCriticalSection;
    //同步锁
    FClearing: Boolean;
    //正在清理
    FServerURL: string;
    //服务地址
  protected
    procedure ClearDataSet;
    //清理资源
    function GetDataSet: TDataSet;
    //获取数据集
  public
    { Public declarations }
    function FindServer: Boolean;
    //定位服务
    function LockDataSet(const nSQL: string; var nHint: string): TDataSet;
    procedure ReleaseDataSet(const nDS: TDataSet);
    //数据查询
    function SQLExecute(const nSQL: string; var nHint: string): Integer; overload;
    function SQLExecute(const nSQL: SQLItem; var nHint: string): Integer; overload;
    //数据执行
    function SQLUpdates(const nSQLList: SQLItems; const nAtomic: Boolean;
     var nHint: string): Integer;
    //批量执行
    function SignIn(const nUser, nPwd: string; var nHint: string): Boolean;
    //登录系统
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}

uses
  Forms, ULibFun, UMgrChannel, uROBinaryHelpers, uROTypes, USysService,
  USysConst;

procedure TFDM.DataModuleCreate(Sender: TObject);
begin
  FClearing := False;
  SetLength(FDSArray, 0);
  FLock := TCriticalSection.Create;
end;

procedure TFDM.DataModuleDestroy(Sender: TObject);
begin
  ClearDataSet;
  FLock.Free;
  inherited;
end;

procedure TFDM.ClearDataSet;
var nIdx: Integer;
begin
  FLock.Enter;
  try
    FClearing := True;

    for nIdx:=Low(FDSArray) to High(FDSArray) do
    with FDSArray[nIdx] do
    begin
      if FUsed then
      try
        FLock.Leave;

        while FUsed do Sleep(1);
      finally
        FLock.Enter;
      end;

      if Assigned(FDS) then FreeAndNil(FDS);
    end;

    SetLength(FDSArray, 0);
  finally
    FClearing := False;
    FLock.Leave;
  end;
end;

//Desc: 获取可用数据集
function TFDM.GetDataSet: TDataSet;
var nIdx: Integer;
begin
  FLock.Enter;
  try
    Result := nil;
    if FClearing then Exit;

    for nIdx:=Low(FDSArray) to High(FDSArray) do
    with FDSArray[nIdx] do
    if not FUsed then
    begin
      FUsed := True;
      Result := FDS; Exit;
    end;

    nIdx := Length(FDSArray);
    SetLength(FDSArray, nIdx+1);

    with FDSArray[nIdx] do
    begin
      FUsed := True;
      FDS := TClientDataSet.Create(Self);
      Result := FDS;
    end;
  finally
    FLock.Leave;
  end;
end;

//Desc: 查询数据并锁定数据集
function TFDM.LockDataSet(const nSQL: string; var nHint: string): TDataSet;
var nData: Binary;
    nRes: SrvResult;
    nChannel: PChannelItem;
begin
  Result := nil;
  nRes := nil;
  nData := nil;

  nChannel := gChannelManager.LockChannel(cChannel_DB);
  try
    if not Assigned(nChannel) then
    begin
      nHint := '无可用数据通道'; Exit;
    end;

    with nChannel^ do
    begin
      if not Assigned(FChannel) then
        FChannel := CoSrvDB.Create(FMsg, FHttp);
      //xxxxx

      FHttp.TargetURL := gSysParam.FRemoteURL;
      nRes := ISrvDB(FChannel).SQLQuery('', '', nSQL, nData);
      //执行远程查询

      if not Assigned(nRes) then
      begin
        nHint := '远程查询执行失败'; Exit;
      end;

      if not nRes.Re_sult then
      begin
        nHint := nRes.DataStr; Exit;
      end;

      if Assigned(nData) then
      begin
        Result := GetDataSet;
        if not Assigned(Result) then
        begin
          nHint := '无可用的数据集'; Exit;
        end;

        TClientDataSet(Result).Data := VariantFromBinary(nData);
        //数据有效
      end;
    end;
  finally
    nRes.Free;
    nData.Free;
    gChannelManager.ReleaseChannel(nChannel);
  end;
end;

//Desc: 解锁指定数据集
procedure TFDM.ReleaseDataSet(const nDS: TDataSet);
var nIdx: Integer;
begin
  if Assigned(nDS) then
  begin
    FLock.Enter;
    try
      for nIdx:=Low(FDSArray) to High(FDSArray) do
      if FDSArray[nIdx].FDS = nDS then
      begin
        FDSArray[nIdx].FUsed := False;
        Break;
      end;
    finally
      FLock.Leave;
    end;
  end;
end;

//Desc: 执行写操作
function TFDM.SQLExecute(const nSQL: string; var nHint: string): Integer;
var nItem: SQLItem;
begin
  nItem := SQLItem.Create;
  try
    nItem.SQL := nSQL;
    Result := SQLExecute(nItem, nHint);
  finally
    //nItem.Free;
  end;
end;

function TFDM.SQLExecute(const nSQL: SQLItem; var nHint: string): Integer;
var nRes: SrvResult;
    nChannel: PChannelItem;
begin
  Result := -1;
  nRes := nil;

  nChannel := gChannelManager.LockChannel(cChannel_DB);
  try
    if not Assigned(nChannel) then
    begin
      nHint := '无可用数据通道'; Exit;
    end;

    with nChannel^ do
    begin
      if not Assigned(FChannel) then
        FChannel := CoSrvDB.Create(FMsg, FHttp);
      //xxxxx

      FHttp.TargetURL := gSysParam.FRemoteURL;
      nRes := ISrvDB(FChannel).SQLExecute('', '', nSQL);
      //执行远程操作

      if not Assigned(nRes) then
      begin
        nHint := '远程操作失败'; Exit;
      end;

      if nRes.Re_sult then
        Result := nRes.DataInt;
      nHint := nRes.DataStr;
    end;
  finally
    nRes.Free;
    gChannelManager.ReleaseChannel(nChannel);
  end;
end;

function TFDM.SQLUpdates(const nSQLList: SQLItems; const nAtomic: Boolean;
  var nHint: string): Integer;
var nRes: SrvResult;
    nChannel: PChannelItem;
begin
  Result := -1;
  nRes := nil;

  nChannel := gChannelManager.LockChannel(cChannel_DB);
  try
    if not Assigned(nChannel) then
    begin
      nHint := '无可用数据通道'; Exit;
    end;

    with nChannel^ do
    begin
      if not Assigned(FChannel) then
        FChannel := CoSrvDB.Create(FMsg, FHttp);
      //xxxxx

      FHttp.TargetURL := gSysParam.FRemoteURL;
      nRes := ISrvDB(FChannel).SQLUpdates('', '', nSQLList, nAtomic);
      //执行远程操作

      if not Assigned(nRes) then
      begin
        nHint := '远程操作失败'; Exit;
      end;

      if nRes.Re_sult then
        Result := nRes.DataInt;
      nHint := nRes.DataStr;
    end;
  finally
    nRes.Free;
    gChannelManager.ReleaseChannel(nChannel);
  end;
end;

//Desc: 用户登录
function TFDM.SignIn(const nUser, nPwd: string; var nHint: string): Boolean;
var nRes: SrvResult;
    nChannel: PChannelItem;
begin
  Result := False;
  nRes := nil;
  nChannel := gChannelManager.LockChannel(cChannel_Conn);
  try
    if not Assigned(nChannel) then
    begin
      nHint := '无可用数据通道'; Exit;
    end;

    with nChannel^ do
    begin
      if not Assigned(FChannel) then
        FChannel := CoSrvConn.Create(FMsg, FHttp);
      //xxxxx

      FHttp.TargetURL := gSysParam.FRemoteURL;
      nRes := ISrvConn(FChannel).SignIn('', '', '', nUser, nPwd, '', '');
      //执行远程操作

      if not Assigned(nRes) then
      begin
        nHint := '远程操作失败'; Exit;
      end;

      Result := nRes.Re_sult;
      nHint := nRes.DataStr;
      if not Result then Exit;

      with gSysParam do
      begin
        FUserID := nUser;
        FUserPwd := nPwd;
        FIsAdmin := nRes.DataInt = cLevel_Master;
      end;

      FreeAndNil(nRes);
      nRes := ISrvConn(FChannel).SweetHeart;
      gSysParam.FTerminalID := nRes.DataStr;
    end;
  finally
    nRes.Free;
    gChannelManager.ReleaseChannel(nChannel);
  end;
end;

//Desc: 定位服务地址
function TFDM.FindServer: Boolean;
var nInt: Integer;
begin
  Result := False;
  nInt := 0;
  FServerURL := '';
  
  ROClient.ServiceName := cService_Conn;
  ROClient.RefreshServerList();

  while true do
  begin
    Inc(nInt);
    if nInt > 5 * 500 then Break;

    Application.ProcessMessages;
    Sleep(2);
    if FServerURL <> '' then
    begin
      gSysParam.FRemoteURL := FServerURL;
      Result := True; Break;
    end;
  end;
end;

//------------------------------------------------------------------------------
type
  TMyDiscoveryResultOptions = class(TRODiscoveryOptions)
  private
    FPath: string;
  published
    property Path: string read FPath write FPath;
  end;

//Desc: 找到服务地址
procedure TFDM.ROClientNewServiceFound(aSender: TObject; aName: String;
  aDiscoveryOptions: TRODiscoveryOptions);
var nOpt: TMyDiscoveryResultOptions;
begin
  if Assigned(aDiscoveryOptions) and (aDiscoveryOptions is TMyDiscoveryResultOptions) then
  begin
    nOpt := aDiscoveryOptions as TMyDiscoveryResultOptions;
    FServerURL := Format('http://%s%s', [aName, nOpt.Path]);
  end;
end;

initialization
  RegisterROClass(TMyDiscoveryResultOptions);
finalization
  UnregisterROClass(TMyDiscoveryResultOptions);
end.
