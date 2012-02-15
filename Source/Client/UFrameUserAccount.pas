{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 营销帐号管理
*******************************************************************************}
unit UFrameUserAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, UGridPainter, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, Grids, StdCtrls, cxButtons, UGridExPainter,
  ExtCtrls, UImageButton;

type
  TfFrameUserAccount = class(TfFrameBase)
    GridList: TDrawGridEx;
    Panel1: TPanel;
    Label1: TLabel;
    BtnAddUser: TImageButton;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnAddUserClick(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridPainter;
    //绘图对象
    procedure LoadAccount;
    //载入账户
    procedure OnBtnClick(Sender: TObject);
    //按钮点击
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  DB, ULibFun, UDataModule, UMgrControl, USysFun, USysConst, USysDB,
  UFormAddAccount, USkinFormBase;

resourcestring
  sD = '删除';
  sY = '启用';
  sN = '停用';

class function TfFrameUserAccount.FrameID: integer;
begin
  Result := cFI_FrameUserAccount;
end;

procedure TfFrameUserAccount.OnCreateFrame;
begin
  Name := MakeFrameName(FrameID);
  FPainter := TGridPainter.Create(GridList);
  
  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('帐号名称', 50);
    AddHeader('密码', 50);
    AddHeader('联系电话', 50);
    AddHeader('操作', 50);
  end;

  LoadDrawGridConfig(Name, GridList);
  Width := GetGridHeaderWidth(GridList);

  BtnAddUser.Left := 10;
  BtnAddUser.Top := Panel1.Top + Panel1.Height - BtnAddUser.Height - 3; 
  LoadAccount;
end;

procedure TfFrameUserAccount.OnDestroyFrame;
begin
  FPainter.Free;
  SaveDrawGridConfig(Name, GridList);
end;

procedure TfFrameUserAccount.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
procedure TfFrameUserAccount.LoadAccount;
var nStr,nHint: string;
    nDS: TDataSet;
    nBtn: TcxButton;
    nData: TGridDataArray;
begin
  nStr := 'Select * From %s Where U_TerminalId=''%s''';
  nStr := Format(nStr, [sTable_TerminalUser, gSysParam.FTerminalID]);

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    FPainter.ClearData;
    if nDS.RecordCount < 1 then Exit;

    with nDS do
    begin
      First;

      while not Eof do
      begin
        SetLength(nData, 5);
        nData[0].FText := FieldByName('U_ID').AsString;
        nData[0].FAlign := taCenter;

        nData[1].FText := FieldByName('U_Name').AsString;
        nData[1].FAlign := taCenter;

        nData[2].FText := FieldByName('U_Pwd').AsString;
        nData[2].FAlign := taCenter;

        nData[3].FText := FieldByName('U_Phone').AsString;
        nData[3].FAlign := taCenter;

        with nData[4] do
        begin
          FText := '';
          FAlign := taCenter;
          FCtrls := TList.Create;

          nBtn := TcxButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Caption := sD;
            Width := 35;
            Height := 18;

            Parent := Self;
            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end;

          nBtn := TcxButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            if FieldByName('U_Invalid').AsString = sFlag_Yes then
                 Caption := sY
            else Caption := sN;

            Width := 35;
            Height := 18;

            Parent := Self;
            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end;
        end;

        FPainter.AddData(nData);
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 按钮处理
procedure TfFrameUserAccount.OnBtnClick(Sender: TObject);
var nStr,nHint: string;
begin
  with TcxButton(Sender) do
  begin
    if Caption = sD then
    begin
      nStr := FPainter.Data[Tag][1].FText;
      nStr := Format('确定要删除账户[ %s ]吗?', [nStr]);
      if not QueryDlg(nStr, sAsk) then Exit;

      nStr := 'Delete From %s Where U_ID=%s';
      nStr := Format(nStr, [sTable_TerminalUser, FPainter.Data[Tag][0].FText]);

      if FDM.SQLExecute(nStr, nHint) > -1 then
           LoadAccount
      else ShowDlg(nHint, sWarn);

      Exit;
    end;

    if Caption = sY then
         nHint := sFlag_No
    else nHint := sFlag_Yes;

    nStr := 'Update %s Set U_Invalid=''%s'' Where U_ID=%s';
    nStr := Format(nStr, [sTable_TerminalUser, nHint, FPainter.Data[Tag][0].FText]);

    if FDM.SQLExecute(nStr, nHint) > -1 then
         LoadAccount
    else ShowDlg(nHint, sWarn);
  end;
end;

//Desc: 添加帐号
procedure TfFrameUserAccount.BtnAddUserClick(Sender: TObject);
begin
  if ShowAddAccountForm then LoadAccount;
end;

initialization
  gControlManager.RegCtrl(TfFrameUserAccount, TfFrameUserAccount.FrameID);
end.
