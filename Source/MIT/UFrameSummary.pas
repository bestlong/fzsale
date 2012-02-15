{*******************************************************************************
  ����: dmzn@163.com 2011-10-22
  ����: ������ϢժҪ
*******************************************************************************}
unit UFrameSummary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, StdCtrls, ExtCtrls;

type
  TfFrameSummary = class(TfFrameBase)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    EditParam: TLabeledEdit;
    Timer1: TTimer;
    EditConnItem: TLabeledEdit;
    EditConnNum: TLabeledEdit;
    EditConnedNum: TLabeledEdit;
    EditReUsed: TLabeledEdit;
    EditNumWait: TLabeledEdit;
    EditMaxWait: TLabeledEdit;
    EditMaxTime: TLabeledEdit;
    EditErrNum: TLabeledEdit;
    BtnRefresh: TButton;
    EditSrvTcp: TLabeledEdit;
    EditSrvHttp: TLabeledEdit;
    GroupBox3: TGroupBox;
    EditNumTCPTotal: TLabeledEdit;
    EditNumHttpTotal: TLabeledEdit;
    EditNumTotal: TLabeledEdit;
    EditNumConn: TLabeledEdit;
    EditRegister: TLabeledEdit;
    EditLogin: TLabeledEdit;
    EditNumSHeart: TLabeledEdit;
    EditNumDB: TLabeledEdit;
    EditNumQuery: TLabeledEdit;
    EditExecute: TLabeledEdit;
    EditUpdates: TLabeledEdit;
    EditNumTCPActive: TLabeledEdit;
    EditNumHttpActive: TLabeledEdit;
    EditNumTCPMax: TLabeledEdit;
    EditNumHttpMax: TLabeledEdit;
    EditNumActionError: TLabeledEdit;
    procedure Timer1Timer(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
  private
    { Private declarations }
    FCounterA,FCounterB: Integer;
    //��������
    procedure LoadDBConnStatus;
    procedure LoadROModuleStatus;
    //����״̬
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, USysConst, UMgrDBConn, UROModule, ULibFun;

class function TfFrameSummary.FrameID: integer;
begin
  Result := cFI_FrameSummary;
end;

procedure TfFrameSummary.OnCreateFrame;
begin
  FVerCentered := True;
end;

//Desc: ˢ�²���
procedure TfFrameSummary.BtnRefreshClick(Sender: TObject);
begin
  BtnRefresh.Enabled := False;
  try
    LoadDBConnStatus;
    LoadROModuleStatus;
  finally
    BtnRefresh.Enabled := True;
  end;
end;

procedure TfFrameSummary.Timer1Timer(Sender: TObject);
begin
  Inc(FCounterA);
  Inc(FCounterB);

  if FCounterA >= 5 then
  begin
    FCounterA := 0;
    LoadDBConnStatus;
  end;

  if FCounterB >= 2 then
  begin
    FCounterB := 0;
    LoadROModuleStatus;
  end;
end;

//Desc: ���ݿ����ӳ�
procedure TfFrameSummary.LoadDBConnStatus;
begin
  with gDBConnManager.Status do
  begin
    EditParam.Text := Format('%d ��', [FNumConnParam]);
    EditConnItem.Text := Format('%d ��', [FNumConnItem]);
    EditConnNum.Text := Format('%d ��', [FNumConnObj]);
    EditConnedNum.Text := Format('%d ��', [FNumObjConned]);
    EditReUsed.Text := Format('%d ��', [FNumObjReUsed]);
    EditErrNum.Text := Format('%d ��', [FNumObjRequestErr]);
    EditNumWait.Text := Format('%d ��', [FNumObjWait]);
    EditMaxWait.Text := Format('%d ��', [FNumWaitMax]);
    EditMaxTime.Text := DateTime2Str(FNumMaxTime);
  end;
end;

//Desc: Զ��ģ������״̬
procedure TfFrameSummary.LoadROModuleStatus;
begin
  with ROModule.LockModuleStatus^ do
  try
    if FSrvTCP then
         EditSrvTcp.Text := Format('������ �˿�: %d', [gROModuleParam.FPortTCP])
    else EditSrvTcp.Text := '�ѹر�';

    if FSrvHttp then
         EditSrvHttp.Text := Format('������ �˿�: %d', [gROModuleParam.FPortHttp])
    else EditSrvHttp.Text := '�ѹر�';

    EditNumTCPTotal.Text := Format('%d ��', [FNumTCPTotal]);
    EditNumTCPActive.Text := Format('%d ��', [FNumTCPActive]);
    EditNumTCPMax.Text := Format('%d ��', [FNumTCPMax]);
    EditNumHttpTotal.Text := Format('%d ��', [FNumHttpTotal]);
    EditNumHttpActive.Text := Format('%d ��', [FNumHttpActive]);
    EditNumHttpMax.Text := Format('%d ��', [FNumHttpMax]);

    EditNumTotal.Text := Format('%d ��', [FNumConn+FNumDB]);
    EditNumDB.Text := Format('%d ��', [FNumDB]);
    EditNumConn.Text := Format('%d ��', [FNumConn]);
    EditNumSHeart.Text := Format('%d ��', [FNumSweetHeart]);
    EditLogin.Text := Format('%d ��', [FNumSignIn]);
    EditRegister.Text := Format('%d ��', [FNumRegister]);
    EditNumQuery.Text := Format('%d ��', [FNumSQLQuery]);
    EditExecute.Text := Format('%d ��', [FNumSQLExecute]);
    EditUpdates.Text := Format('%d ��', [FNumSQLUpdates]);
    EditNumActionError.Text := Format('%d ��', [FNumActionError]);
  finally
    ROModule.ReleaseStatusLock;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameSummary, TfFrameSummary.FrameID);
end.
