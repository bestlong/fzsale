{*******************************************************************************
  ����: dmzn@163.com 2011-10-22
  ����: ��������
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls;

const
  cSBar_Date            = 0;                         //�����������
  cSBar_Time            = 1;                         //ʱ���������
  cSBar_User            = 2;                         //�û��������

const
  cFI_FrameRunlog     = $0002;                       //������־
  cFI_FrameSummary    = $0005;                       //��ϢժҪ
  cFI_FrameMyInfo     = $0006;                       //������Ϣ
  cFI_FrameMyPassword = $0007;                       //�ҵ�����
  cFI_FrameUserAccount= $0008;                       //Ӫ���ʺ�
  cFI_FrameNewMember  = $0009;                       //�»�Ա
  cFI_FrameMembers    = $0010;                       //��Ա�б�
  cFI_FrameMemberDtl  = $0011;                       //��Ա����
  cFI_FrameMemberSet  = $0012;                       //��Ա����

  cFI_FrameProductInit= $0020;                       //��ʼ��
  cFI_FrameProductView= $0021;                       //��Ʒ���
  cFI_FrameProductKC  = $0030;                       //��Ʒ���
  cFI_FrameBillView   = $0031;                       //�鿴����
  cFI_FrameBillYS     = $0032;                       //��������
  cFI_FrameBillWarn   = $0033;                       //����Ԥ��
  cFI_FrameReturnDL   = $0035;                       //�˻�(����)

  cFI_FrameProductSale= $0050;                       //��Ʒ����
  cFI_FrameReportMX   = $0051;                       //������ϸ
  cFI_FrameReportHZ   = $0052;                       //���ۻ���
  cFI_FrameReportLR   = $0053;                       //��Ӫ����
  cFI_FrameReportJH   = $0054;                       //����ͳ��
  cFI_FrameReportTH   = $0055;                       //�˿��˻�
  cFI_FrameReportRT   = $0056;                       //�����˻�
  cFI_FrameReportYJ   = $0057;                       //ҵ��ͳ��

  cFI_FrameNotices    = $0062;                       //��Ӫͨ��

type
  TSysParam = record
    FProgID     : string;                            //�����ʶ
    FAppTitle   : string;                            //�����������ʾ
    FMainTitle  : string;                            //���������
    FHintText   : string;                            //��ʾ�ı�
    FCopyRight  : string;                            //��������ʾ����

    FUserID     : string;                            //�û���ʶ
    FUserPwd    : string;                            //�û�����
    FUserName   : string;                            //�û�����
    FIsAdmin    : Boolean;                           //�Ƿ����

    FAutoStart  : Boolean;                           //��������
    FAutoMin    : Boolean;                           //������С��
    FRemoteURL  : string;                            //Զ�̵�ַ
    FTerminalID : string;                            //�ն˱�ʶ
  end;
  //ϵͳ����

type
  TAdminStatusChange = procedure (const nIsAdmin: Boolean) of object;
  //����Ա״̬�л�
  procedure AddAdminStatusChangeListener(const nFun: TAdminStatusChange);
  //���״̬�л���������
  procedure AdminStatusChange(const nIsAdmin: Boolean);
  //����״̬�ı�

type
  TShowDebugLog = procedure (const nMsg: string; const nMustShow: Boolean) of object;
  procedure ShowDebugLog(const nMsg: string; const nMustShow: Boolean = False);
  //��ʾ������־

//------------------------------------------------------------------------------
var
  gPath: string;                                     //��������·��
  gSysParam:TSysParam;                               //���򻷾�����
  gStatusBar: TStatusBar;                            //ȫ��ʹ��״̬��
  gDebugLog: TShowDebugLog = nil;                    //ϵͳ������־

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //Ĭ�ϱ�ʶ
  sAppTitle           = 'DMZN';                      //�������
  sMainCaption        = 'DMZN';                      //�����ڱ���

  sHint               = '��ʾ';                      //�Ի������
  sWarn               = '����';                      //==
  sAsk                = 'ѯ��';                      //ѯ�ʶԻ���
  sError              = 'δ֪����';                  //����Ի���

  sDate               = '����:��%s��';               //����������
  sTime               = 'ʱ��:��%s��';               //������ʱ��
  sUser               = '�û�:��%s��';               //�������û�

  sLogDir             = 'Logs\';                     //��־Ŀ¼
  sLogExt             = '.log';                      //��־��չ��
  sLogField           = #9;                          //��¼�ָ���

  sImageDir           = 'Images\';                   //ͼƬĿ¼
  sReportDir          = 'Report\';                   //����Ŀ¼
  sBackupDir          = 'Backup\';                   //����Ŀ¼
  sBackupFile         = 'Bacup.idx';                 //��������

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sConfigSec          = 'Config';                    //������С��
  sVerifyCode         = ';Verify:';                  //У������

  sFormConfig         = 'FormInfo.ini';              //��������
  sSetupSec           = 'Setup';                     //����С��
  sDBConfig           = 'DBConn.ini';                //��������

  sSoundDir           = 'Sound\';                    //����Ŀ¼
  sPrinterSetup       = '�����ӡ����';              //��������

  sInvalidConfig      = '�����ļ���Ч���Ѿ���';    //�����ļ���Ч
  sCloseQuery         = 'ȷ��Ҫ�˳�������?';         //�������˳�
  
implementation

var
  gListener: array of TAdminStatusChange;
  //������

//Desc: ��ӹ���״̬�л���������
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

//Desc: ��ʾ������־
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
