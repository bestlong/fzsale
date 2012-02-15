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
  cFI_FrameMyInfo     = $0006;                       //店面信息
  cFI_FrameMyPassword = $0007;                       //我的密码
  cFI_FrameUserAccount= $0008;                       //营销帐号
  cFI_FrameNewMember  = $0009;                       //新会员
  cFI_FrameMembers    = $0010;                       //会员列表
  cFI_FrameMemberDtl  = $0011;                       //会员详情
  cFI_FrameMemberSet  = $0012;                       //会员参数

  cFI_FrameProductInit= $0020;                       //初始化
  cFI_FrameProductView= $0021;                       //产品库存
  cFI_FrameProductKC  = $0030;                       //产品库存
  cFI_FrameBillView   = $0031;                       //查看订单
  cFI_FrameBillYS     = $0032;                       //订单验收
  cFI_FrameBillWarn   = $0033;                       //智能预警
  cFI_FrameReturnDL   = $0035;                       //退货(代理)

  cFI_FrameProductSale= $0050;                       //商品销售
  cFI_FrameReportMX   = $0051;                       //销售明细
  cFI_FrameReportHZ   = $0052;                       //销售汇总
  cFI_FrameReportLR   = $0053;                       //经营利润
  cFI_FrameReportJH   = $0054;                       //进货统计
  cFI_FrameReportTH   = $0055;                       //顾客退货
  cFI_FrameReportRT   = $0056;                       //代理退货
  cFI_FrameReportYJ   = $0057;                       //业绩统计

  cFI_FrameNotices    = $0062;                       //经营通告

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

    FAutoStart  : Boolean;                           //开机启动
    FAutoMin    : Boolean;                           //启动最小化
    FRemoteURL  : string;                            //远程地址
    FTerminalID : string;                            //终端标识
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

  sSoundDir           = 'Sound\';                    //声音目录
  sPrinterSetup       = '报表打印设置';              //报表描述

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
