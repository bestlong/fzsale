{*******************************************************************************
  作者: dmzn@163.com 2011-10-22
  描述: 运行信息摘要
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
    //计数变量
    procedure LoadDBConnStatus;
    procedure LoadROModuleStatus;
    //载入状态
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

//Desc: 刷新参数
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

//Desc: 数据库连接池
procedure TfFrameSummary.LoadDBConnStatus;
begin
  with gDBConnManager.Status do
  begin
    EditParam.Text := Format('%d 个', [FNumConnParam]);
    EditConnItem.Text := Format('%d 个', [FNumConnItem]);
    EditConnNum.Text := Format('%d 个', [FNumConnObj]);
    EditConnedNum.Text := Format('%d 个', [FNumObjConned]);
    EditReUsed.Text := Format('%d 次', [FNumObjReUsed]);
    EditErrNum.Text := Format('%d 个', [FNumObjRequestErr]);
    EditNumWait.Text := Format('%d 个', [FNumObjWait]);
    EditMaxWait.Text := Format('%d 个', [FNumWaitMax]);
    EditMaxTime.Text := DateTime2Str(FNumMaxTime);
  end;
end;

//Desc: 远程模块运行状态
procedure TfFrameSummary.LoadROModuleStatus;
begin
  with ROModule.LockModuleStatus^ do
  try
    if FSrvTCP then
         EditSrvTcp.Text := Format('工作中 端口: %d', [gROModuleParam.FPortTCP])
    else EditSrvTcp.Text := '已关闭';

    if FSrvHttp then
         EditSrvHttp.Text := Format('工作中 端口: %d', [gROModuleParam.FPortHttp])
    else EditSrvHttp.Text := '已关闭';

    EditNumTCPTotal.Text := Format('%d 次', [FNumTCPTotal]);
    EditNumTCPActive.Text := Format('%d 个', [FNumTCPActive]);
    EditNumTCPMax.Text := Format('%d 个', [FNumTCPMax]);
    EditNumHttpTotal.Text := Format('%d 次', [FNumHttpTotal]);
    EditNumHttpActive.Text := Format('%d 个', [FNumHttpActive]);
    EditNumHttpMax.Text := Format('%d 个', [FNumHttpMax]);

    EditNumTotal.Text := Format('%d 次', [FNumConn+FNumDB]);
    EditNumDB.Text := Format('%d 次', [FNumDB]);
    EditNumConn.Text := Format('%d 次', [FNumConn]);
    EditNumSHeart.Text := Format('%d 次', [FNumSweetHeart]);
    EditLogin.Text := Format('%d 次', [FNumSignIn]);
    EditRegister.Text := Format('%d 次', [FNumRegister]);
    EditNumQuery.Text := Format('%d 次', [FNumSQLQuery]);
    EditExecute.Text := Format('%d 次', [FNumSQLExecute]);
    EditUpdates.Text := Format('%d 次', [FNumSQLUpdates]);
    EditNumActionError.Text := Format('%d 次', [FNumActionError]);
  finally
    ROModule.ReleaseStatusLock;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameSummary, TfFrameSummary.FrameID);
end.
