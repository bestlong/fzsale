{*******************************************************************************
  作者: dmzn@163.com 2011-11-16
  描述: 登录
*******************************************************************************}
unit UFormLogin;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, ExtCtrls, UImageButton, StdCtrls, UTransEdit,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxCheckBox;

type
  TfFormLogin = class(TSkinFormBase)
    Image1: TImage;
    BtnLogin: TImageButton;
    EditUser: TEdit;
    EditPwd: TEdit;
    Check1: TcxCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnLoginClick(Sender: TObject);
    procedure EditPwdKeyPress(Sender: TObject; var Key: Char);
    procedure EditUserExit(Sender: TObject);
  private
    { Private declarations }
    procedure SaveUserInfo;
    //保存信息
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowLoginForm: Boolean;
//登录系统

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UFormWait, UDataModule, UBase64, USysConst;

function ShowLoginForm: Boolean;
begin
  {$IFDEF DEBUG}
  with gSysParam do
  begin
    FUserID := 'admin';
    FUserPwd := 'ddd';
    FIsAdmin := True;
    FRemoteURL := 'http://127.0.0.1:8082/bin';
    FTerminalID := '1003';
  end;

  Result := True;
  Exit;
  {$ENDIF}

  with TfFormLogin.Create(Application) do
  begin
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormLogin.FormSkinID: string;
begin
  Result := 'FormLogin'
end;

procedure TfFormLogin.FormCreate(Sender: TObject);
begin
  inherited;
  EditUser.BorderStyle := bsNone;
  EditPwd.BorderStyle := bsNone;

  LoadFixImageButton(BtnLogin);
  LoadFixImage(Image1.Picture.Bitmap, 'loginmid');

  Check1.Left := BtnLogin.Left + BtnLogin.Width + 10;
  Check1.Top := Trunc(BtnLogin.Top + (BtnLogin.Height - Check1.Height) / 2);
end;

procedure TfFormLogin.EditPwdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if Sender = EditUser then ActiveControl := EditPwd else
    if Sender = EditPwd then BtnLoginClick(nil);
  end;
end;

//Desc: 保存用户信息
procedure TfFormLogin.SaveUserInfo;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    if Check1.Checked then
         nIni.WriteString('UserInfo', EditUser.Text, EncodeBase64(EditPwd.Text))
    else nIni.DeleteKey('UserInfo', EditUser.Text);
  finally
    nIni.Free;
  end;
end;

//Desc: 载入用户信息
procedure TfFormLogin.EditUserExit(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  EditUser.Text := Trim(EditUser.Text);
  if EditUser.Text = '' then Exit;

  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    nStr := nIni.ReadString('UserInfo', EditUser.Text, '');
    nStr := DecodeBase64(nStr);

    Check1.Checked := nStr <> '';
    EditPwd.Text := nStr;
  finally
    nIni.Free;
  end;
end;

//Desc: 登录
procedure TfFormLogin.BtnLoginClick(Sender: TObject);
var nStr: string;
begin
  if EditUser.Text = '' then
  begin
    EditUser.SetFocus;
    ShowMsg('请填写用户名', sHint); Exit;
  end;

  if EditPwd.Text = '' then
  begin
    EditPwd.SetFocus;
    ShowMsg('请填写登录密码', sHint); Exit;
  end;

  ActiveControl := nil;
  Application.ProcessMessages;
  ShowWaitForm(Self, '连接服务器');
  try
    if not FDM.FindServer then
    begin
      ShowMsg('无法连接同步服务器', sHint); Exit;
    end;

    ShowWaitForm(Self, '验证用户');
    if FDM.SignIn(EditUser.Text, EditPwd.Text, nStr) then
    begin
      SaveUserInfo;
      ModalResult := mrOk;
      Exit;
    end;

    CloseWaitForm;
    ShowDlg(nStr, sWarn, Handle);
  finally
    CloseWaitForm;
  end;
end;

end.
