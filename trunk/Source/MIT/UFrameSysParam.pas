{*******************************************************************************
  作者: dmzn@163.com 2011-10-29
  描述: 系统运行参数设置
*******************************************************************************}
unit UFrameSysParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, StdCtrls, ExtCtrls;

type
  TfFrameSysParam = class(TfFrameBase)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    EditPortTCP: TLabeledEdit;
    EditPortHTTP: TLabeledEdit;
    BtnSave: TButton;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditSizeConn: TLabeledEdit;
    EditBehaviorSrvConn: TComboBox;
    EditSizeDB: TLabeledEdit;
    EditBehaviorSrvDB: TComboBox;
    Label3: TLabel;
    EditMaxRecord: TLabeledEdit;
    EditInterval: TLabeledEdit;
    Label4: TLabel;
    procedure BtnSaveClick(Sender: TObject);
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
  UMgrControl, USysConst, UROModule, uROClassFactories, ULibFun;

class function TfFrameSysParam.FrameID: integer;
begin
  Result := cFI_FrameSysParam;
end;

procedure TfFrameSysParam.OnCreateFrame;
begin
  FVerCentered := True;
  
  with gROModuleParam do
  begin
    EditPortTCP.Text := IntToStr(FPortTCP);
    EditPortHTTP.Text := IntToStr(FPortHttp);
    EditMaxRecord.Text := IntToStr(FMaxRecordCount);
    EditInterval.Text := IntToStr(FReloadInterval);

    EditSizeConn.Text := IntToStr(FPoolSizeSrvConn);
    EditSizeDB.Text := IntToStr(FPoolSizeSrvDB);
    EditBehaviorSrvConn.ItemIndex := Ord(FPoolBehaviorSrvConn);
    EditBehaviorSrvDB.ItemIndex := Ord(FPoolBehaviorSrvDB);
  end;
end;

//Desc: 保存参数
procedure TfFrameSysParam.BtnSaveClick(Sender: TObject);
begin
  if not IsNumber(EditPortTcp.Text, False) then
  begin
    EditPortTcp.SetFocus;
    ShowMsg('请输入正确端口号', sHint); Exit;
  end;

  if not IsNumber(EditPortHttp.Text, False) then
  begin
    EditPortHttp.SetFocus;
    ShowMsg('请输入正确端口号', sHint); Exit;
  end;

  if not IsNumber(EditSizeConn.Text, False) then
  begin
    EditSizeConn.SetFocus;
    ShowMsg('缓冲大小为正整数值', sHint); Exit;
  end;

  if not IsNumber(EditSizeDB.Text, False) then
  begin
    EditSizeDB.SetFocus;
    ShowMsg('缓冲大小为正整数值', sHint); Exit;
  end;

  if (not IsNumber(EditInterval.Text, False)) or
     (StrToInt(EditInterval.Text) < 10) then
  begin
    EditInterval.SetFocus;
    ShowMsg('间隔应大于10秒', sHint); Exit;
  end;

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

  with gROModuleParam do
  begin
    FPortTCP := StrToInt(EditPortTcp.Text);
    FPortHttp := StrToInt(EditPortHttp.Text);

    FPoolSizeSrvConn := StrToInt(EditSizeConn.Text);
    FPoolSizeSrvDB := StrToInt(EditSizeDB.Text);

    FMaxRecordCount := StrToInt(EditMaxRecord.Text);
    FReloadInterval := StrToInt(EditInterval.Text);

    FPoolBehaviorSrvConn := TROPoolBehavior(EditBehaviorSrvConn.ItemIndex);
    FPoolBehaviorSrvDB := TROPoolBehavior(EditBehaviorSrvDB.ItemIndex);
  end;

  ROModule.ActionROModuleParam(False);
  ShowMsg('参数保存成功', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFrameSysParam, TfFrameSysParam.FrameID);
end.
