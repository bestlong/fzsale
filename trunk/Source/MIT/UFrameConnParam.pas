{*******************************************************************************
  作者: dmzn@163.com 2011-10-30
  描述: 数据库连接参数
*******************************************************************************}
unit UFrameConnParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, StdCtrls, ExtCtrls;

type
  TfFrameConnParam = class(TfFrameBase)
    GroupBox1: TGroupBox;
    EditHost: TLabeledEdit;
    BtnSave: TButton;
    EditPort: TLabeledEdit;
    EditDB: TLabeledEdit;
    EditUser: TLabeledEdit;
    EditPwd: TLabeledEdit;
    Label1: TLabel;
    MemoConn: TMemo;
    BtnTest: TButton;
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  UMgrControl, USysConst, ULibFun, UROModule, UDataModule, UMgrDBConn,
  UFormWait;

class function TfFrameConnParam.FrameID: integer;
begin
  Result := cFI_FrameConnParam;
end;

procedure TfFrameConnParam.OnCreateFrame;
begin
  FVerCentered := True;
  
  with gSysParam do
  begin
    EditHost.Text := FLocalHost;
    EditPort.Text := IntToStr(FLocalPort);
    EditDB.Text := FLocalDB;
    EditUser.Text := FLocalUser;
    EditPwd.Text := FLocalPwd;
    MemoConn.Text := FLocalConn;
  end;
end;

//Desc: 测试参数
procedure TfFrameConnParam.BtnTestClick(Sender: TObject);
var nParam: TDBParam;
begin
  with nParam do
  begin
    FHost := EditHost.Text;
    FPort := StrToInt(EditPort.Text);
    FDB := EditDB.Text;
    FUser := EditUser.Text;
    FPwd := EditPwd.Text;
    FConn := MemoConn.Text;
  end;

  with FDM.ConnTest do
  try
    Connected := False;
    ConnectionString := gDBConnManager.MakeDBConnection(nParam);

    ShowWaitForm(Application.MainForm, '正在连接,请稍候');
    Connected := True;
    CloseWaitForm;
    ShowMsg('测试成功', sHint);
  except
    CloseWaitForm;
    ShowMsg('无法连接数据库', '测试失败');
  end;
end;

//Desc: 保存参数
procedure TfFrameConnParam.BtnSaveClick(Sender: TObject);
var nParam: TDBParam;
begin
  with ROModule.LockModuleStatus^ do
  try
    if FSrvTCP or FSrvHttp then
    begin
      ShowMsg('请先停止服务', sHint);
      Exit;
    end;
  finally
    ROModule.ReleaseStatusLock;
  end;

  with gSysParam do
  begin
    FLocalDB    := EditDB.Text;
    FLocalHost  := EditHost.Text;
    FLocalPort  := StrToInt(EditPort.Text);
    FLocalUser  := EditUser.Text;
    FLocalPwd   := EditPwd.Text;
    FLocalConn  := MemoConn.Text;
  end;

  with nParam, gSysParam do
  begin
    FID := sSysDB;
    FHost := FLocalHost;
    FPort := FLocalPort;
    FDB := FLocalDB;
    FUser := FLocalUser;
    FPwd := FLocalPwd;
    FConn := FLocalConn;
    gDBConnManager.AddParam(nParam);
  end;

  ShowMsg('参数保存成功', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFrameConnParam, TfFrameConnParam.FrameID);
end.
