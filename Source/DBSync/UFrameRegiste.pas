{*******************************************************************************
  ����: dmzn@163.com 2011-10-29
  ����: ��������
*******************************************************************************}
unit UFrameRegiste;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, StdCtrls, ExtCtrls;

type
  TfFrameRegiste = class(TfFrameBase)
    GroupBox1: TGroupBox;
    EditDID: TLabeledEdit;
    EditZID: TLabeledEdit;
    BtnReg: TButton;
    EditMAC: TLabeledEdit;
    Label4: TLabel;
    procedure BtnRegClick(Sender: TObject);
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
  UMgrControl, ULibFun, UROModule, FZSale_Intf, UMgrChannel, USysConst,
  UFormWait, USysService;

class function TfFrameRegiste.FrameID: integer;
begin
  Result := cFI_FrameRegiste;
end;

procedure TfFrameRegiste.OnCreateFrame;
begin
  FVerCentered := True;
  
  with ROModule.LockModuleStatus^ do
  try
    EditDID.Text := FSpID;
    EditZID.Text := FTerminalID;
    EditMAC.Text := FMAC;
  finally
    ROModule.ReleaseStatusLock;
  end;
end;

//Desc: �������
procedure TfFrameRegiste.BtnRegClick(Sender: TObject);
var nRes: SrvResult;
    nChannel: PChannelItem;
begin
  EditDID.Text := Trim(EditDID.Text);
  if EditDID.Text = '' then
  begin
    EditDID.SetFocus;
    ShowMsg('����д�����̱��', sHint); Exit;
  end;

  EditZID.Text := Trim(EditZID.Text);
  if EditZID.Text = '' then
  begin
    EditZID.SetFocus;
    ShowMsg('����д�ն˵���', sHint); Exit;
  end; 

  nRes := nil;
  nChannel := gChannelManager.LockChannel(cChannel_Conn);
  try
    if not Assigned(nChannel) then
    begin
      ShowMsg('�޿�������ͨ��', sHint); Exit;
    end;

    with nChannel^ do
    begin
      if not Assigned(FChannel) then
      begin
        FChannel := CoSrvConn.Create(FMsg, FHttp);
        FHttp.TargetURL := gROModuleParam.FRemoteURL;
      end;

      try
        ShowWaitForm(Application.MainForm, '�����ύ');
        nRes := ISrvConn(FChannel).RegistMe(EditZID.Text, EditDID.Text, EditMAC.Text, False);
      except
        //ignor any error
      end;

      CloseWaitForm;
      if not Assigned(nRes) then
      begin
        ShowMsg('Զ�̷���������Ӧ', sHint); Exit;
      end;

      if nRes.DataStr <> '' then
      begin
        if nRes.Action = cAction_Hint then
             ShowDlg(nRes.DataStr, sHint)
        else ShowDlg(nRes.DataStr, sWarn);
      end;

      if nRes.Re_sult then
      begin
        with ROModule.LockModuleStatus^ do
        try
          FSpID := EditDID.Text;
          FTerminalID := EditZID.Text;
        finally
          ROModule.ReleaseStatusLock;
        end;

        ROModule.ActionROModuleParam(False);
      end;
    end;
  finally
    nRes.Free;
    gChannelManager.ReleaseChannel(nChannel);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameRegiste, TfFrameRegiste.FrameID);
end.
