{*******************************************************************************
  作者: dmzn@163.com 2007-10-09
  描述: 系统服务器常量定义
*******************************************************************************}
unit USysService;

{$I Link.inc}
interface

uses
  Windows, Classes, SysUtils, FZSale_Intf;

const
  {*结果动作*}
  cAction_None      = $20;      //无动作
  cAction_Jump      = $21;      //跳转
  cAction_Hint      = $22;      //提示
  cAction_Warn      = $23;      //警告
  cAction_Error     = $25;      //错误

  cLevel_Master     = $22;      //店长
  cLevel_Employer   = $29;      //员工

  cChannel_DB    = $0010;       //数据通道
  cChannel_Conn  = $0022;       //连接通道
  cService_DB    = 'SrvDB';     //数据服务
  cService_Conn  = 'SrvConn';   //连接服务

function MakeSrvResult: SrvResult;
//结果对象

resourcestring
  {*执行结果*}
  cAction_Succ      = 'Succ';
  cAction_Fail      = 'Fail';

  {*终端版本*}
  cVersion_DBSync   = '111030';
  cVersion_Client   = '111030';

implementation

//Desc: 生成结果对象并初始化
function MakeSrvResult: SrvResult;
begin
  Result := SrvResult.Create;
  with Result do
  begin
    Re_sult := False;
    Action := cAction_None;
    DataStr := '';
    DataInt := 0;
  end;
end;

end.


