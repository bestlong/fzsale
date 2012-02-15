{*******************************************************************************
  作者: dmzn@163.com 2011-10-22
  描述: 常量定义
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cSBar_User            = 2;                         //用户面板索引

const
  cFI_FrameRunlog     = $0002;                       //运行日志
  cFI_FrameSummary    = $0005;                       //信息摘要
  cFI_FrameRunstatus  = $0006;                       //运行状态
  cFI_FrameSysParam   = $0007;                       //系统参数
  cFI_FrameConnParam  = $0008;                       //连接参数
  cFI_FrameRegiste    = $0009;                       //接入申请

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本
    FCopyRight  : string;                            //主窗体提示内容

    FUserID     : string;                            //用户标识
    FUserPwd    : string;                            //用户口令
    FUserName   : string;                            //用户名称
    FIsAdmin    : Boolean;                           //是否管理

    FLocalDB    : string;
    FLocalHost  : string;
    FLocalPort  : Integer;
    FLocalUser  : string;
    FLocalPwd   : string;
    FLocalConn  : string;                            //本方数据库

    FAutoStart  : Boolean;                           //开机启动
    FAutoMin    : Boolean;                           //启动最小化
  end;
  //系统参数

type
  TAdminStatusChange = procedure (const nIsAdmin: Boolean) of object;
  //管理员状态切换
  procedure AddAdminStatusChangeListener(const nFun: TAdminStatusChange);
  //添加状态切换监听对象
  procedure AdminStatusChange(const nIsAdmin: Boolean);
  //管理状态改变

type
  TShowDebugLog = procedure (const nMsg: string; const nMustShow: Boolean) of object;
  procedure ShowDebugLog(const nMsg: string; const nMustShow: Boolean = False);
  //显示调试日志

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gStatusBar: TStatusBar;                            //全局使用状态栏
  gDebugLog: TShowDebugLog = nil;                    //系统调试日志

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //默认标识
  sAppTitle           = 'DMZN';                      //程序标题
  sMainCaption        = 'DMZN';                      //主窗口标题

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户

  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sLogField           = #9;                          //记录分隔符

  sImageDir           = 'Images\';                   //图片目录
  sReportDir          = 'Report\';                   //报表目录
  sBackupDir          = 'Backup\';                   //备份目录
  sBackupFile         = 'Bacup.idx';                 //备份索引

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记

  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sSetupSec           = 'Setup';                     //配置小节
  sDBConfig           = 'DBConn.ini';                //数据连接

  sSysDB              = 'SysDB';                     //系统库标识

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出
  
implementation

var
  gListener: array of TAdminStatusChange;
  //监听组

//Desc: 添加管理状态切换监听对象
procedure AddAdminStatusChangeListener(const nFun: TAdminStatusChange);
var nLen: Integer;
begin
  nLen := Length(gListener);
  SetLength(gListener, nLen + 1);
  gListener[nLen] := nFun;
end;

procedure AdminStatusChange(const nIsAdmin: Boolean);
var nIdx: Integer;
begin
  for nIdx:=Low(gListener) to High(gListener) do
    gListener[nIdx](nIsAdmin);
  gSysParam.FIsAdmin := nIsAdmin;
end;

//Desc: 显示调试日志
procedure ShowDebugLog(const nMsg: string; const nMustShow: Boolean);
begin
  if Assigned(gDebugLog) then
  try
    gDebugLog(nMsg, nMustShow);
  except
    //ignor any error
  end;
end;

end.
