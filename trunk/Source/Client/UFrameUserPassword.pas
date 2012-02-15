{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 更新用户密码
*******************************************************************************}
unit UFrameUserPassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, StdCtrls,
  cxButtons, cxLabel, cxRadioGroup, ExtCtrls, UImageButton;

type
  TfFrameUserPassword = class(TfFrameBase)
    EditUser: TcxTextEdit;
    EditOld: TcxTextEdit;
    EditNew: TcxTextEdit;
    EditNext: TcxTextEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    ImageButton1: TImageButton;
    ImageButton2: TImageButton;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
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
  ULibFun, UDataModule, UMgrControl, USysConst, USysDB, USysFun;

class function TfFrameUserPassword.FrameID: integer;
begin
  Result := cFI_FrameMyPassword;
end;

procedure TfFrameUserPassword.OnCreateFrame;
begin
  EditUser.Text := gSysParam.FUserID;
end;

procedure TfFrameUserPassword.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 提交
procedure TfFrameUserPassword.BtnOKClick(Sender: TObject);
var nStr, nHint: string;
begin
  if EditOld.Text <> gSysParam.FUserPwd then
  begin
    EditOld.SetFocus;
    ShowMsg('旧密码错误', sHint); Exit;
  end;

  if EditNew.Text = '' then
  begin
    EditNew.SetFocus;
    ShowMsg('请输入新密码', sHint); Exit;
  end;

  if EditNew.Text <> EditNext.Text then
  begin
    EditNext.SetFocus;
    ShowMsg('输入的新密码不一致', sHint); Exit;
  end;

  if gSysParam.FIsAdmin then
  begin
    nStr := 'Update %s Set TerPwd=''%s'' Where TerminalID=''%s''';
    nStr := Format(nStr, [sTable_Terminal, Md5Str(EditNew.Text),
            gSysParam.FTerminalID]);
    //xxxxx
  end else
  begin
    nStr := 'Update %s Set U_Pwd=''%s'' Where TerminalID=''%s'' and U_Name=''%s''';
    nStr := Format(nStr, [sTable_TerminalUser, EditNew.Text,
            gSysParam.FTerminalID, gSysParam.FUserID]);
    //xxxxx
  end;

  if FDM.SQLExecute(nStr, nHint) > 0 then
       ShowMsg('更新成功', sHint)
  else ShowDlg(nHint, sWarn);
end;

initialization
  gControlManager.RegCtrl(TfFrameUserPassword, TfFrameUserPassword.FrameID);
end.
