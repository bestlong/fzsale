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
  cFI_FrameRunstatus  = $0006;                       //����״̬
  cFI_FrameSysParam   = $0007;                       //ϵͳ����
  cFI_FrameConnParam  = $0008;                       //���Ӳ���
  cFI_FrameRegiste    = $0009;                       //��������

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

    FLocalDB    : string;
    FLocalHost  : string;
    FLocalPort  : Integer;
    FLocalUser  : string;
    FLocalPwd   : string;
    FLocalConn  : string;                            //�������ݿ�

    FAutoStart  : Boolean;                           //��������
    FAutoMin    : Boolean;                           //������С��
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

  sSysDB              = 'SysDB';                     //ϵͳ���ʶ

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
