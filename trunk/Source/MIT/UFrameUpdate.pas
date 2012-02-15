{*******************************************************************************
  作者: dmzn@163.com 2011-10-30
  描述: 软件升级服务
*******************************************************************************}
unit UFrameUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, StdCtrls, ExtCtrls;

type
  TfFrameUpdate = class(TfFrameBase)
    GroupBox1: TGroupBox;
    EditMITVer: TLabeledEdit;
    EditMITUrl: TLabeledEdit;
    BtnSave: TButton;
    EditClientUrl: TLabeledEdit;
    EditClientVer: TLabeledEdit;
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
  UMgrControl, USysConst, ULibFun, UROModule;

class function TfFrameUpdate.FrameID: integer;
begin
  Result := cFI_FrameSoftUpdate;
end;

procedure TfFrameUpdate.OnCreateFrame;
begin
  FVerCentered := True;
  
  with ROModule.LockModuleStatus^,gROModuleParam do
  try
    EditMITVer.Text := FVerLocalMIT;
    EditMITUrl.Text := FURLLocalMIT;
    EditClientVer.Text := FVerClient;
    EditClientUrl.Text := FURLClient;
  finally
    ROModule.ReleaseStatusLock;
  end;
end;

//Desc: 保存
procedure TfFrameUpdate.BtnSaveClick(Sender: TObject);
begin
  with ROModule.LockModuleStatus^,gROModuleParam do
  try
    FVerLocalMIT := EditMITVer.Text;
    FURLLocalMIT := EditMITUrl.Text;
    FVerClient := EditClientVer.Text;
    FURLClient := EditClientUrl.Text;
  finally
    ROModule.ReleaseStatusLock;
  end;    

  ROModule.ActionROModuleParam(False);
  ShowMsg('升级配置保存成功', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFrameUpdate, TfFrameUpdate.FrameID);
end.
