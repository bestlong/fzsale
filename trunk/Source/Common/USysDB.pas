{*******************************************************************************
  作者: dmzn@163.com 2008-08-07
  描述: 系统数据库常量定义

  备注:
  *.自动创建SQL语句,支持变量:$Inc,自增;$Float,浮点;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,二进制流
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes;

const
  cSysDatabaseName: array[0..4] of String = (
     'Access', 'SQL', 'MySQL', 'Oracle', 'DB2');
  //db names

type
  TSysDatabaseType = (dtAccess, dtSQLServer, dtMySQL, dtOracle, dtDB2);
  //db types

  PSysTableItem = ^TSysTableItem;
  TSysTableItem = record
    FTable: string;
    FNewSQL: string;
  end;
  //系统表项

var
  gSysTableList: TList = nil;                        //系统表数组
  gSysDBType: TSysDatabaseType = dtSQLServer;        //系统数据类型

//------------------------------------------------------------------------------
const
  //自增字段
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //小数字段
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //图片字段
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

  //日期相关
  sField_SQLServer_Now           = 'getDate()';

  //帐户状态
  sFlag_Normal        = 1;                           //帐户正常
  sFlag_Freeze        = 2;                           //帐户冻结
  sFlag_Invalid       = 3;                           //帐户作废

ResourceString     
  {*权限项*}
  sPopedom_Read       = 'A';                         //浏览
  sPopedom_Add        = 'B';                         //添加
  sPopedom_Edit       = 'C';                         //修改
  sPopedom_Delete     = 'D';                         //删除
  sPopedom_Preview    = 'E';                         //预览
  sPopedom_Print      = 'F';                         //打印
  sPopedom_Export     = 'G';                         //导出

  {*相关标记*}
  sFlag_Yes           = 'Y';                         //是
  sFlag_No            = 'N';                         //否
  sFlag_Enabled       = 'Y';                         //启用
  sFlag_Disabled      = 'N';                         //禁用

  sFlag_Male          = '1';                         //男
  sFlag_Female        = '0';                         //女

  sFlag_Integer       = 'I';                         //整数
  sFlag_Decimal       = 'D';                         //小数

  sFlag_SyncW         = 'N';                         //等待同步
  sFlag_Syncing       = 'S';                         //同步中
  sFlag_Synced        = 'D';                         //done

  sFlag_BillNew       = 'N';                         //新订单
  sFlag_BillLock      = 'L';                         //终端锁定
  sFlag_BillCancel    = 'C';                         //终端取消
  sFlag_BillAccept    = 'A';                         //代理确认
  sFlag_BillDeliver   = 'D';                         //代理发货
  sFlag_BillTakeDeliv = 'T';                         //终端收货
  sFlag_BillDone      = 'O';                         //订单结束

  sFlag_ReportTitle   = 'RepTitle';                  //报表头
  sFlag_ReportEnding  = 'RepEnd';                    //报表尾

  {*数据表*}
  sTable_SysDict      = 'Sys_Dict';                  //系统字典表
  sTable_SysLog       = 'Sys_EventLog';              //系统日志表
  sTable_SysExtInfo   = 'Sys_ExtInfo';               //系统扩展信息

  sTable_MITAdmin     = 'MIT_Admin';                 //中间件管理员
  sTable_MITDB        = 'MIT_DBConfig';              //数据库配置表
                                                                 
  sTable_Terminal     = 'HX_Terminal';               //终端账户表
  sTable_TerminalUser = 'HX_T_Users';                //终端用户表
  sTable_MACRebind    = 'HX_T_MACRebind';            //MAC绑定请求

  sTable_DL_Style     = 'HX_Style';                  //款式表
  sTable_DL_Product   = 'HX_Product';                //商品表
  sTable_DL_Size      = 'HX_Size';                   //尺寸
  sTable_DL_Color     = 'HX_Color';                  //颜色
  sTable_DL_Brand     = 'HX_Brand';                  //品牌
  sTable_DL_Noties    = 'HX_Notices';                //通告
  sTable_DL_Order     = 'HX_TerminalOrder';          //订单
  sTable_DL_OrderDtl  = 'HX_TerminalOrderDetail';    //订单明细
  sTable_DL_TermSale  = 'HX_TerminalSaleRecord';     //终端销售

  sTable_Product      = 'HX_T_Product';              //商品表
  sTable_Sale         = 'HX_T_Sale';                 //销售记录
  sTable_SaleDtl      = 'HX_T_SaleDtl';              //销售明细
  sTable_AutoWan      = 'HX_T_AutoWarn';             //库存预警
  sTable_Order        = 'HX_T_Order';                //订单表
  sTable_OrderDtl     = 'HX_T_OrderDtl';             //订单明细
  sTable_Return       = 'HX_T_Return';               //退单表
  sTable_ReturnDtl    = 'HX_T_ReturnDtl';            //退单明细
  sTable_OrderDeal    = 'HX_T_OrderDeal';            //订单收货
  sTable_OrderAdjust  = 'HX_T_OrderAdjust';          //订单调整
  sTable_Member       = 'HX_T_Member';               //会员信息
  sTable_MemberSet    = 'HX_T_MemberSet';            //会员设定


  {*新建表*}  
  sSQL_NewMITAdmin = 'Create Table $Table(A_UserID varChar(15),' +
       'A_Name varChar(32), A_Pwd varChar(15), A_Create DateTime,' +
       'A_Update DateTime)';
  {-----------------------------------------------------------------------------
   系统用户表: MITAdmin
   *.A_UserID: 用户账户
   *.A_Name: 用户名
   *.A_Pwd: 密码
   *.A_Create: 创建时间
   *.A_Update: 更新时间
  -----------------------------------------------------------------------------}

  sSQL_NewMITDB = 'Create Table $Table(D_Agent varChar(15), D_Name varChar(80),' +
       'D_Host varChar(32), D_Port Integer, D_DBName varChar(32),' +
       'D_User varChar(15), D_Pwd varChar(15), D_ConnStr varChar(220),' +
       'D_Create DateTime, D_Update DateTime, D_Invalid Char(1))';
  {-----------------------------------------------------------------------------
   数据库配置: DBConfig
   *.D_Agent: 代理商
   *.D_Name: 代理商名
   *.D_Host: 主机地址
   *.D_DBName: 数据库名
   *.D_Port: 端口
   *.D_User: 登录用户
   *.D_Pwd: 登录密码
   *.D_ConnStr: 连接
   *.D_Create: 创建时间
   *.D_Update: 更新时间
   *.D_Invalid: 是否失效
  -----------------------------------------------------------------------------}

  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(100), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   系统字典: MITDict
   *.D_ID: 编号
   *.D_Name: 名称
   *.D_Desc: 描述
   *.D_Value: 取值
   *.D_Memo: 相关信息
   *.D_ParamA: 浮点参数
   *.D_ParamB: 字符参数
   *.D_Index: 显示索引
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   扩展信息表: ExtInfo
   *.I_ID: 编号
   *.I_Group: 信息分组
   *.I_ItemID: 信息标识
   *.I_Item: 信息项
   *.I_Info: 信息内容
   *.I_ParamA: 浮点参数
   *.I_ParamB: 字符参数
   *.I_Memo: 备注信息
   *.I_Index: 显示索引
  -----------------------------------------------------------------------------}
  
  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(220))';
  {-----------------------------------------------------------------------------
   系统日志: SysLog
   *.L_ID: 编号
   *.L_Date: 操作日期
   *.L_Man: 操作人
   *.L_Group: 信息分组
   *.L_ItemID: 信息标识
   *.L_KeyID: 辅助标识
   *.L_Event: 事件
  -----------------------------------------------------------------------------}

  sSQL_NewTerminalUser = 'Create Table $Table(U_ID $Inc, U_Name varChar(32),' +
       'U_Pwd varChar(16), U_Phone varChar(20), U_TerminalId varChar(15),' +
       'U_Type Char(1), U_Invalid Char(1))';

  {-----------------------------------------------------------------------------
   终端用户表: TerminalUser
   *.U_ID: 编号
   *.U_Name: 账户名
   *.U_Pwd: 密码
   *.U_Phone: 电话
   *.U_TerminalId: 终端店
   *.U_Type: 类型(店长,店员)
   *.U_Invalid: 是否停用
  -----------------------------------------------------------------------------}

  sSQL_NewMACRebind = 'Create Table $Table(M_ID $Inc, M_MAC varChar(32),' +
       'M_TerminalId varChar(15), M_ReqTime DateTime,' +
       'M_Allow Char(1) Default ''N'',M_AllowMan Char(32), M_AllowTime DateTime)';

  {-----------------------------------------------------------------------------
   MAC绑定申请表: MACRebind
   *.M_ID: 编号
   *.M_MAC: MAC地址
   *.M_TerminalId: 终端标识
   *.M_Allow: 是否通过
   *.M_AllowMan: 审核人
   *.M_AllowTime:审核时间
  -----------------------------------------------------------------------------}

  sSQL_NewProduct = 'Create Table $Table(R_ID $Inc, R_Sync Char(1),' +
       'P_ID varChar(15), P_Color varChar(15), P_Size varChar(15),' +
       'P_Number Integer, P_Price $Float, P_InPrice $Float, P_OldPrice $Float,' +
       'P_TerminalId varChar(15), P_LastIn DateTime)';
  {-----------------------------------------------------------------------------
   商品表: Product
   *.R_ID: 编号
   *.R_Sync: 同步
   *.P_ID: 商品标识
   *.P_Color: 颜色
   *.P_Size: 大小
   *.P_Number: 库存量
   *.P_Price: 零售价
   *.P_InPrice: 进货价
   *.P_OldPrice: 调价前售价
   *.P_TerminalId: 终端标识
   *.P_LastIn: 最后入库时间
  -----------------------------------------------------------------------------}

  sSQL_NewSale = 'Create Table $Table(R_ID $Inc, R_Sync Char(1), S_ID varChar(15),' +
       'S_TerminalId varChar(15), S_Number Integer, S_Money $Float,' +
       'S_Member varChar(15), S_Deduct $Float, S_DeMoney $Float,' +
       'S_Man varChar(32), S_Date DateTime)';
  {-----------------------------------------------------------------------------
   销售记录: Sale
   *.R_ID: 编号
   *.R_Sync: 同步
   *.S_ID: 销售编号
   *.S_TerminalId: 终端标识
   *.S_Number: 销售件数
   *.S_Money: 销售钱数
   *.S_Member: 会员号
   *.S_Deduct: 折扣比
   *.S_DeMoney: 优惠金
   *.S_Man: 销售人
   *.S_Date: 销售时间
  -----------------------------------------------------------------------------}

  sSQL_NewSaleDtl = 'Create Table $Table(R_ID $Inc, R_Sync Char(1), D_SaleID varChar(15),' +
       'D_Product varChar(15), D_Number Integer, D_Price $Float,' +
       'D_Member varChar(15), D_Deduct $Float, D_DeMoney $Float)';
  {-----------------------------------------------------------------------------
   销售明细: SaleDtl
   *.R_ID: 编号
   *.R_Sync: 同步
   *.D_SaleID: 销售编号
   *.D_Product: 产品编号
   *.D_Number: 销售件数
   *.D_Price: 销售单价
   *.D_Member: 会员号
   *.D_Deduct: 折扣比
   *.D_DeMoney: 优惠金
  -----------------------------------------------------------------------------}

  sSQL_NewAutoWarn = 'Create Table $Table(R_ID $Inc, R_Sync Char(1),' +
       'W_TerminalId varChar(15), W_Product varChar(15), W_AvgNum Integer,' +
       'W_Status Char(1))';
  {-----------------------------------------------------------------------------
   库存预警: AutoWarn
   *.R_ID: 编号
   *.R_Sync:同步
   *.W_TerminalId: 终端
   *.W_Product: 产品编号
   *.W_AvgNum: 平均销量
   *.W_Status: 记录状态
  -----------------------------------------------------------------------------}

  sSQL_NewOrder = 'Create Table $Table(R_ID $Inc, O_ID varChar(15),' +
       'O_TerminalId varChar(15), O_Number Integer, O_DoneNum Integer,' +
       ' O_Man varChar(32), O_Date DateTime, O_ActDate DateTime, O_Status Char(1))';
  {-----------------------------------------------------------------------------
   订单表: Order
   *.R_ID: 编号
   *.O_ID: 订单号
   *.O_TerminalId: 终端
   *.O_Number: 订单总数
   *.O_DoneNum: 完成数
   *.O_Man: 下单人
   *.O_Date: 下单时间
   *.O_ActDate: 动作时间
   *.O_Status: 订单状态
  -----------------------------------------------------------------------------}

  sSQL_NewOrderDtl = 'Create Table $Table(R_ID $Inc, D_Order varChar(15),' +
       'D_Product varChar(15), D_Number Integer, D_Price $Float,' +
       'D_HasIn Integer, D_InDate DateTime)';
  {-----------------------------------------------------------------------------
   订单明细: OrderDtl
   *.R_ID: 编号
   *.D_Order: 订单号
   *.D_Product: 产品
   *.D_Number: 订单件数
   *.D_Price: 订货价
   *.D_HasIn: 已入库
   *.D_InDate: 上次入库时间
  -----------------------------------------------------------------------------}

  sSQL_NewOrderDeal = 'Create Table $Table(R_ID $Inc, D_Order varChar(15),' +
       'D_Product varChar(15), D_Number Integer, D_Price $Float,' +
       'D_Man varChar(32), D_Date DateTime, D_Memo varChar(80))';
  {-----------------------------------------------------------------------------
   订单收货: OrderDeal
   *.R_ID: 编号
   *.D_Order: 订单号
   *.D_Product: 产品
   *.D_Number: 收货数
   *.D_Price: 收货价
   *.D_Man: 收货人
   *.D_Date: 收货时间
   *.D_Memo: 备注信息
  -----------------------------------------------------------------------------}

  sSQL_NewOrderAdjust = 'Create Table $Table(R_ID $Inc, A_Order varChar(15),' +
       'A_Product varChar(15), A_Number Integer, A_NewNum Integer,' +
       'A_Man varChar(32), A_Date DateTime, A_Memo varChar(80))';
  {-----------------------------------------------------------------------------
   订单调整: OrderAdjust
   *.R_ID: 编号
   *.A_Order: 订单号
   *.A_Product: 产品
   *.A_Number: 原订货量
   *.A_NewNum: 新订货量
   *.A_Man: 修改人
   *.A_Date: 修改时间
   *.A_Memo: 备注信息
  -----------------------------------------------------------------------------}

  sSQL_NewReturn = 'Create Table $Table(R_ID $Inc, T_ID varChar(15),' +
       'T_TerminalId varChar(15), T_Number Integer, T_DoneNum Integer,' +
       'T_Man varChar(32), T_Date DateTime, T_ActMan varChar(32),' +
       'T_ActDate DateTime, T_Memo varChar(500), T_Status Char(1))';
  {-----------------------------------------------------------------------------
   退货单: Return
   *.R_ID: 编号
   *.T_ID: 退货号
   *.T_TerminalId: 终端
   *.T_Number: 退货总数
   *.T_DoneNum: 实际收货
   *.T_Man: 下单人
   *.T_Date: 下单时间
   *.T_ActMan: 动作人
   *.T_ActDate: 动作时间
   *.T_Status: 状态
  -----------------------------------------------------------------------------}

  sSQL_NewReturnDtl = 'Create Table $Table(R_ID $Inc, D_Return varChar(15),' +
       'D_Product varChar(15), D_Number Integer, D_Price $Float,' +
       'D_HasIn Integer, D_InDate DateTime)';
  {-----------------------------------------------------------------------------
   退货单明细: ReturnDtl
   *.R_ID: 编号
   *.D_Return: 退货单
   *.D_Product: 产品
   *.D_Number: 退货件数
   *.D_Price: 代理批发价
   *.D_HasIn: 已入库
   *.D_InDate: 上次入库时间
  -----------------------------------------------------------------------------}

  sSQL_NewMember = 'Create Table $Table(R_ID $Inc, R_Sync Char(1),' +
       'M_TerminalId varChar(15), M_ID varChar(15), M_Card varChar(15),' +
       'M_IDCard varChar(20), M_Name varChar(32), M_Sex Char(1), ' +
       'M_BirthDay DateTime, M_Phone varChar(32), M_Addr varChar(80),' +
       'M_BuyTime Integer, M_BuyMoney $Float, M_DeMoney $Float, M_Type Char(1),' +
       'M_Limit Char(1), M_Man varChar(32), M_Date DateTime, M_Memo varChar(80))';
  {-----------------------------------------------------------------------------
   会员表: Member
   *.R_ID: 编号
   *.R_Sync: 同步
   *.M_TerminalId: 终端
   *.M_ID: 会员号
   *.M_Card: 卡号
   *.M_IDCard: 身份证
   *.M_Name: 姓名
   *.M_Sex: 性别
   *.M_BirthDay: 生日
   *.M_Phone: 电话
   *.M_Addr: 地址
   *.M_BuyTime: 购物次数
   *.M_BuyMoney: 购物金额
   *.M_DeMoney:优惠金额
   *.M_Type: 会员类型(金卡,普通)
   *.M_Limit: 单店有效(是,否)
   *.M_Man: 办卡人
   *.M_Date: 办卡时间
   *.M_Memo: 备注信息
  -----------------------------------------------------------------------------}

  sSQL_NewMemberSet = 'Create Table $Table(R_ID $Inc, R_Sync Char(1),' +
       'S_TerminalId varChar(15), S_Type Char(15), S_Money $Float,' +
       'S_Deduct $Float, S_AddMan varChar(32), S_AddDate DateTime,' +
       'S_ModifyMan varChar(32), S_ModifyDate DateTime)';
  {-----------------------------------------------------------------------------
   会员设定: Memberset
   *.R_ID: 编号
   *.R_Sync: 同步
   *.S_TerminalId: 终端
   *.S_Type: 会员类型
   *.S_Money: 金额
   *.S_Deduct: 折扣
   *.S_AddMan: 添加人
   *.S_AddDate: 添加时间
   *.S_ModifyMan: 修改人
   *.S_ModifyDate: 修改时间
  -----------------------------------------------------------------------------}

implementation

//------------------------------------------------------------------------------
//Desc: 添加系统表项
procedure AddSysTableItem(const nTable,nNewSQL: string);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL;
end;

//Desc: 系统表
procedure InitSysTableList;
begin
  gSysTableList := TList.Create;
  AddSysTableItem(sTable_SysLog, sSQL_NewSysLog);
  AddSysTableItem(sTable_SysExtInfo, sSQL_NewExtInfo);

  AddSysTableItem(sTable_MITAdmin, sSQL_NewMITAdmin);
  AddSysTableItem(sTable_MITDB, sSQL_NewMITDB);
  AddSysTableItem(sTable_SysDict, sSQL_NewSysDict);

  AddSysTableItem(sTable_TerminalUser, sSQL_NewTerminalUser);
  AddSysTableItem(sTable_MACRebind, sSQL_NewMACRebind);

  AddSysTableItem(sTable_Product, sSQL_NewProduct);
  AddSysTableItem(sTable_Sale, sSQL_NewSale);
  AddSysTableItem(sTable_SaleDtl, sSQL_NewSaleDtl);
  AddSysTableItem(sTable_AutoWan, sSQL_NewAutoWarn);
  AddSysTableItem(sTable_Order, sSQL_NewOrder);
  AddSysTableItem(sTable_OrderDtl, sSQL_NewOrderDtl);
  AddSysTableItem(sTable_OrderDeal, sSQL_NewOrderDeal);
  AddSysTableItem(sTable_OrderAdjust, sSQL_NewOrderAdjust);
  AddSysTableItem(sTable_Return, sSQL_NewReturn);
  AddSysTableItem(sTable_ReturnDtl, sSQL_NewReturnDtl);
  AddSysTableItem(sTable_Member, sSQL_NewMember);
  AddSysTableItem(sTable_MemberSet, sSQL_NewMemberSet);
end;

//Desc: 清理系统表
procedure ClearSysTableList;
var nIdx: integer;
begin
  for nIdx:= gSysTableList.Count - 1 downto 0 do
  begin
    Dispose(PSysTableItem(gSysTableList[nIdx]));
    gSysTableList.Delete(nIdx);
  end;

  FreeAndNil(gSysTableList);
end;

initialization
  InitSysTableList;
finalization
  ClearSysTableList;
end.


