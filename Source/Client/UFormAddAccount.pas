unit UFormAddAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, StdCtrls,
  UImageButton;

type
  TfFormAddAccount = class(TSkinFormBase)
    Label1: TLabel;
    EditUser: TcxTextEdit;
    Label3: TLabel;
    EditNew: TcxTextEdit;
    Label4: TLabel;
    EditNext: TcxTextEdit;
    Label6: TLabel;
    EditPhone: TcxTextEdit;
    Label2: TLabel;
    BtnOK: TImageButton;
    ImageButton1: TImageButton;
    procedure FormCreate(Sender: TObject);
    procedure ImageButton1Click(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowAddAccountForm: Boolean;
//添加账户

implementation

{$R *.dfm}

uses
  ULibFun, USysDB, USysConst, UDataModule;

function ShowAddAccountForm: Boolean;
begin
  with TfFormAddAccount.Create(Application) do
  begin
    //Caption := '添加账户';
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormAddAccount.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormAddAccount.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx
end;

procedure TfFormAddAccount.ImageButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TfFormAddAccount.BtnOKClick(Sender: TObject);
var nStr, nHint: string;
begin
  EditUser.Text := Trim(EditUser.Text);
  if EditUser.Text = '' then
  begin
    EditUser.SetFocus;
    ShowMsg('请输入用户名', sHint); Exit;
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

  nStr := 'Insert Into %s(U_Name,U_Pwd,U_Phone,U_TerminalId,U_Invalid) ' +
          'Values(''%s'', ''%s'', ''%s'', ''%s'', ''%s'')';
  nStr := Format(nStr, [sTable_TerminalUser, EditUser.Text,
          EditNew.Text, EditPhone.Text, gSysParam.FTerminalID, sFlag_No]);
  //xxxxx

  if FDM.SQLExecute(nStr, nHint) > 0 then
       ModalResult := mrOK
  else ShowDlg(nHint, sWarn);
end;

end.
