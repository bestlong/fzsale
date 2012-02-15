{*******************************************************************************
  ����: dmzn@163.com 2011-10-29
  ����: ϵͳ���в�������
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
    EditURL: TLabeledEdit;
    Label4: TLabel;
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
  UMgrControl, ULibFun, USysConst, USysService, UROModule,  uROClassFactories, 
  UFormWait, UMgrChannel, FZSale_Intf;

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
    EditURL.Text := FRemoteURL;

    EditSizeConn.Text := IntToStr(FPoolSizeSrvConn);
    EditSizeDB.Text := IntToStr(FPoolSizeSrvDB);
    EditBehaviorSrvConn.ItemIndex := Ord(FPoolBehaviorSrvConn);
    EditBehaviorSrvDB.ItemIndex := Ord(FPoolBehaviorSrvDB);
  end;
end;

//Desc: ����Զ�̷���
procedure TfFrameSysParam.BtnTestClick(Sender: TObject);
var nRes: SrvResult;
    nChannel: PChannelItem;
begin
  nChannel := gChannelManager.LockChannel(cChannel_Conn);
  try
    if not Assigned(nChannel) then
    begin
      ShowMsg('�޿�������ͨ��', sHint); Exit;
    end;

    with nChannel^ do
    begin
      if not Assigned(FChannel) then
        FChannel := CoSrvConn.Create(FMsg, FHttp);
      FHttp.TargetURL := EditURL.Text;

      nRes := nil;
      try
        ShowWaitForm(Application.MainForm, '���ڲ���');
        nRes := ISrvConn(FChannel).SweetHeart;
      except
        //ignor any error
      end;

      CloseWaitForm;
      if Assigned(nRes) then
      begin
        nRes.Free;
        ShowMsg('URL��Ч', sHint);
      end else ShowMsg('URL��Ч��Զ�̷���ر�', sHint)
    end;
  finally
    gChannelManager.ReleaseChannel(nChannel);
  end;
end;

//Desc: �������
procedure TfFrameSysParam.BtnSaveClick(Sender: TObject);
begin
  if not IsNumber(EditPortTcp.Text, False) then
  begin
    EditPortTcp.SetFocus;
    ShowMsg('��������ȷ�˿ں�', sHint); Exit;
  end;

  if not IsNumber(EditPortHttp.Text, False) then
  begin
    EditPortHttp.SetFocus;
    ShowMsg('��������ȷ�˿ں�', sHint); Exit;
  end;

  if not IsNumber(EditSizeConn.Text, False) then
  begin
    EditSizeConn.SetFocus;
    ShowMsg('�����СΪ������ֵ', sHint); Exit;
  end;

  if not IsNumber(EditSizeDB.Text, False) then
  begin
    EditSizeDB.SetFocus;
    ShowMsg('�����СΪ������ֵ', sHint); Exit;
  end;

  EditURL.Text := Trim(EditURL.Text);
  if EditURL.Text = '' then
  begin
    EditURL.SetFocus;
    ShowMsg('����д�����ַ', sHint); Exit;
  end;

  with ROModule.LockModuleStatus^ do
  try
    if FSrvTCP or FSrvHttp then
    begin
      ShowMsg('����ֹͣ����', sHint);
      Exit;
    end;
  finally
    ROModule.ReleaseStatusLock;
  end;

  with gROModuleParam do
  begin
    FPortTCP := StrToInt(EditPortTcp.Text);
    FPortHttp := StrToInt(EditPortHttp.Text);
    FRemoteURL := EditURL.Text;

    FPoolSizeSrvConn := StrToInt(EditSizeConn.Text);
    FPoolSizeSrvDB := StrToInt(EditSizeDB.Text);  

    FPoolBehaviorSrvConn := TROPoolBehavior(EditBehaviorSrvConn.ItemIndex);
    FPoolBehaviorSrvDB := TROPoolBehavior(EditBehaviorSrvDB.ItemIndex);
  end;

  ROModule.ActionROModuleParam(False);
  ShowMsg('��������ɹ�', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFrameSysParam, TfFrameSysParam.FrameID);
end.
