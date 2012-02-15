{*******************************************************************************
  ����: dmzn@163.com 2011-11-21
  ����: ����ģ��
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
    FUsed: Boolean;       //�Ƿ�ʹ��
    FDS: TClientDataSet;  //���ݼ�
  end;

  TDataSetArray = array of TDataSetItem;
  //���ݼ��б�

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
    //���ݼ�
    FLock: TCriticalSection;
    //ͬ����
    FClearing: Boolean;
    //��������
    FServerURL: string;
    //�����ַ
  protected
    procedure ClearDataSet;
    //������Դ
    function GetDataSet: TDataSet;
    //��ȡ���ݼ�
  public
    { Public declarations }
    function FindServer: Boolean;
    //��λ����
    function LockDataSet(const nSQL: string; var nHint: string): TDataSet;
    procedure ReleaseDataSet(const nDS: TDataSet);
    //���ݲ�ѯ
    function SQLExecute(const nSQL: string; var nHint: string): Integer; overload;
    function SQLExecute(const nSQL: SQLItem; var nHint: string): Integer; overload;
    //����ִ��
    function SQLUpdates(const nSQLList: SQLItems; const nAtomic: Boolean;
     var nHint: string): Integer;
    //����ִ��
    function SignIn(const nUser, nPwd: string; var nHint: string): Boolean;
    //��¼ϵͳ
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

//Desc: ��ȡ�������ݼ�
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

//Desc: ��ѯ���ݲ��������ݼ�
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
      nHint := '�޿�������ͨ��'; Exit;
    end;

    with nChannel^ do
    begin
      if not Assigned(FChannel) then
        FChannel := CoSrvDB.Create(FMsg, FHttp);
      //xxxxx

      FHttp.TargetURL := gSysParam.FRemoteURL;
      nRes := ISrvDB(FChannel).SQLQuery('', '', nSQL, nData);
      //ִ��Զ�̲�ѯ

      if not Assigned(nRes) then
      begin
        nHint := 'Զ�̲�ѯִ��ʧ��'; Exit;
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
          nHint := '�޿��õ����ݼ�'; Exit;
        end;

        TClientDataSet(Result).Data := VariantFromBinary(nData);
        //������Ч
      end;
    end;
  finally
    nRes.Free;
    nData.Free;
    gChannelManager.ReleaseChannel(nChannel);
  end;
end;

//Desc: ����ָ�����ݼ�
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

//Desc: ִ��д����
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
      nHint := '�޿�������ͨ��'; Exit;
    end;

    with nChannel^ do
    begin
      if not Assigned(FChannel) then
        FChannel := CoSrvDB.Create(FMsg, FHttp);
      //xxxxx

      FHttp.TargetURL := gSysParam.FRemoteURL;
      nRes := ISrvDB(FChannel).SQLExecute('', '', nSQL);
      //ִ��Զ�̲���

      if not Assigned(nRes) then
      begin
        nHint := 'Զ�̲���ʧ��'; Exit;
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
      nHint := '�޿�������ͨ��'; Exit;
    end;

    with nChannel^ do
    begin
      if not Assigned(FChannel) then
        FChannel := CoSrvDB.Create(FMsg, FHttp);
      //xxxxx

      FHttp.TargetURL := gSysParam.FRemoteURL;
      nRes := ISrvDB(FChannel).SQLUpdates('', '', nSQLList, nAtomic);
      //ִ��Զ�̲���

      if not Assigned(nRes) then
      begin
        nHint := 'Զ�̲���ʧ��'; Exit;
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

//Desc: �û���¼
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
      nHint := '�޿�������ͨ��'; Exit;
    end;

    with nChannel^ do
    begin
      if not Assigned(FChannel) then
        FChannel := CoSrvConn.Create(FMsg, FHttp);
      //xxxxx

      FHttp.TargetURL := gSysParam.FRemoteURL;
      nRes := ISrvConn(FChannel).SignIn('', '', '', nUser, nPwd, '', '');
      //ִ��Զ�̲���

      if not Assigned(nRes) then
      begin
        nHint := 'Զ�̲���ʧ��'; Exit;
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

//Desc: ��λ�����ַ
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

//Desc: �ҵ������ַ
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
