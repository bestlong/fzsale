{*******************************************************************************
  ����: dmzn@163.com 2007-10-09
  ����: ϵͳ��������������
*******************************************************************************}
unit USysService;

{$I Link.inc}
interface

uses
  Windows, Classes, SysUtils, FZSale_Intf;

const
  {*�������*}
  cAction_None      = $20;      //�޶���
  cAction_Jump      = $21;      //��ת
  cAction_Hint      = $22;      //��ʾ
  cAction_Warn      = $23;      //����
  cAction_Error     = $25;      //����

  cLevel_Master     = $22;      //�곤
  cLevel_Employer   = $29;      //Ա��

  cChannel_DB    = $0010;       //����ͨ��
  cChannel_Conn  = $0022;       //����ͨ��
  cService_DB    = 'SrvDB';     //���ݷ���
  cService_Conn  = 'SrvConn';   //���ӷ���

function MakeSrvResult: SrvResult;
//�������

resourcestring
  {*ִ�н��*}
  cAction_Succ      = 'Succ';
  cAction_Fail      = 'Fail';

  {*�ն˰汾*}
  cVersion_DBSync   = '111030';
  cVersion_Client   = '111030';

implementation

//Desc: ���ɽ�����󲢳�ʼ��
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


