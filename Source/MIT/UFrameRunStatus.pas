{*******************************************************************************
  ����: dmzn@163.com 2011-10-28
  ����: ����״̬����
*******************************************************************************}
unit UFrameRunStatus;

{$I link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, StdCtrls, ExtCtrls;

type
  TfFrameRunStatus = class(TfFrameBase)
    GroupBox1: TGroupBox;
    BtnTCP: TButton;
    BtnHttp: TButton;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    CheckAutoStart: TCheckBox;
    CheckAutoMin: TCheckBox;
    GroupBox3: TGroupBox;
    EditAdmin: TLabeledEdit;
    EditPwd: TLabeledEdit;
    BtnLogin: TButton;
    BtnSave: TButton;
    Timer1: TTimer;
    procedure BtnLoginClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure CheckAutoStartClick(Sender: TObject);
    procedure BtnTCPClick(Sender: TObject);
    procedure BtnHttpClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FNumber: Integer;
    procedure AdminChange(const nIsAdmin: Boolean);
    //��ʼ��
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, USysConst, UROModule, ULibFun;

const
  cNo = 0;
  cYes  = 1;

//------------------------------------------------------------------------------
class function TfFrameRunStatus.FrameID: integer;
begin
  Result := cFI_FrameRunStatus;
end;

procedure TfFrameRunStatus.OnCreateFrame;
begin
  BtnTCP.Tag := cNo;
  BtnHttp.Tag := cNo;
  BtnLogin.Tag := cNo;

  FNumber := 0;
  FVerCentered := True;
  
  CheckAutoStart.Checked := gSysParam.FAutoStart;
  CheckAutoMin.Checked := gSysParam.FAutoMin;

  AddAdminStatusChangeListener(AdminChange);
  AdminChange(False);

  {$IFDEF DEBUG}
  Timer1.Enabled := False;
  {$ELSE}
  Timer1.Enabled := CheckAutoMin.Checked;
  {$ENDIF}
end;

procedure TfFrameRunStatus.AdminChange(const nIsAdmin: Boolean);
begin
  BtnTCP.Enabled := nIsAdmin;
  BtnHttp.Enabled := nIsAdmin;
  BtnSave.Enabled := nIsAdmin;

  if nIsAdmin then
  begin
    BtnLogin.Caption := 'ע��';
    BtnLogin.Tag := cYes;
  end else
  begin
    BtnLogin.Caption := '��¼';
    BtnLogin.Tag := cNo;
  end;

  with ROModule.LockModuleStatus^ do
  try
    if FSrvTCP then
    begin
      BtnTCP.Caption := 'ֹͣTCP';
      BtnTCP.Tag := cYes;
    end else
    begin
      BtnTCP.Caption := '����TCP';
      BtnTCP.Tag := cNo;
    end;

    if FSrvHttp then
    begin
      BtnHttp.Caption := 'ֹͣHTTP';
      BtnHttp.Tag := cYes;
    end else
    begin
      BtnHttp.Caption := '����HTTP';
      BtnHttp.Tag := cNo;
    end;
  finally
    ROModule.ReleaseStatusLock;
  end;
end;

procedure TfFrameRunStatus.CheckAutoStartClick(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
  begin
    gSysParam.FAutoStart := CheckAutoStart.Checked;
    gSysParam.FAutoMin := CheckAutoMin.Checked;
  end;
end;

//Desc: ����Ա��¼
procedure TfFrameRunStatus.BtnLoginClick(Sender: TObject);
begin
  if (EditAdmin.Text = gSysParam.FUserID) and
     (EditPwd.Text = gSysParam.FUserPwd) then
  begin
    if BtnLogin.Tag = cNo  then
         BtnLogin.Tag := cYes
    else BtnLogin.Tag := cNo;

    AdminStatusChange(BtnLogin.Tag = cYes);
  end else ShowMsg('�˻����������', sHint);
end;

//Desc: �����˻�
procedure TfFrameRunStatus.BtnSaveClick(Sender: TObject);
begin
  gSysParam.FUserID := Trim(EditAdmin.Text);
  gSysParam.FUserPwd := Trim(EditPwd.Text);
  ShowMessage('���˻�����Ч');
end;

//Desc: ����TCP
procedure TfFrameRunStatus.BtnTCPClick(Sender: TObject);
var nStr: string;
begin
  ROModule.ActiveServer([stTcp], BtnTCP.Tag = cNo, nStr);
  if nStr <> '' then ShowDlg(nStr, sWarn);
end;

//Desc: ����HTTP
procedure TfFrameRunStatus.BtnHttpClick(Sender: TObject);
var nStr: string;
begin
  ROModule.ActiveServer([stHttp], BtnHttp.Tag = cNo, nStr);
  if nStr <> '' then ShowDlg(nStr, sWarn);
end;

//Desc: �Զ���������
procedure TfFrameRunStatus.Timer1Timer(Sender: TObject);
var nStr: string;
begin
  Inc(FNumber);
  if FNumber = 2 then
  begin
    ROModule.ActiveServer([stTcp, stHttp], BtnTCP.Tag = cNo, nStr);
    if nStr <> '' then
    begin
      Timer1.Enabled := False;
      ShowDebugLog(nStr, True);
    end;
  end else

  if FNumber >= 3 then
  begin
    with ROModule.LockModuleStatus^ do
    try
      if FSrvTCP or FSrvHttp then
      begin
        Timer1.Enabled := False;
        PostMessage(Application.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
      end;
    finally
      ROModule.ReleaseStatusLock;
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameRunStatus, TfFrameRunStatus.FrameID);
end.
