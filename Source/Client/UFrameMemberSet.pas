{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 会员卡参数
*******************************************************************************}
unit UFrameMemberSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, UGridPainter, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, Grids, StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, cxTextEdit, ExtCtrls, UGridExPainter, UImageButton;

type
  TfFrameMemberSet = class(TfFrameBase)
    Panel1: TPanel;
    LabelHint: TLabel;
    EditMoney: TcxTextEdit;
    EditZheKou: TcxTextEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    GridList: TDrawGridEx;
    BtnAdd: TImageButton;
    procedure BtnAddClick(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridPainter;
    //绘图对象
    procedure LoadMemberSet;
    //载入会员
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
  DB, ULibFun, UDataModule, UMgrControl, USysFun, USysConst, USysDB, UFormCtrl;

class function TfFrameMemberSet.FrameID: integer;
begin
  Result := cFI_FrameMemberSet;
end;

procedure TfFrameMemberSet.OnCreateFrame;
begin
  Name := MakeFrameName(FrameID);
  FPainter := TGridPainter.Create(GridList);
  
  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('消费金额', 50);
    AddHeader('优惠幅度', 50);
    AddHeader('操作', 50);
  end;

  LoadDrawGridConfig(Name, GridList);
  AdjustLabelCaption(LabelHint, GridList);
  Width := GetGridHeaderWidth(GridList);

  BtnAdd.Top := EditMoney.Top + Trunc((EditMoney.Height - BtnAdd.Height) / 2);
  LoadMemberSet;
end;

procedure TfFrameMemberSet.OnDestroyFrame;
begin
  FPainter.Free;
  SaveDrawGridConfig(Name, GridList);
end;

procedure TfFrameMemberSet.LoadMemberSet;
var nStr,nHint: string;
    nIdx,nInt: Integer;
    nDS: TDataSet;
    nBtn: TImageButton;
    nData: TGridDataArray;
begin
  nStr := 'Select * From %s Where S_TerminalId=''%s'' Order By S_Money';
  nStr := Format(nStr, [sTable_MemberSet, gSysParam.FTerminalID]);

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
      nInt := 1;
      First;

      while not Eof do
      begin
        SetLength(nData, 5);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FText := '';
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);
        nData[1].FText := Format('满 ￥%s 元', [FieldByName('S_Money').AsString]);
        nData[2].FText := Format('%s折', [FieldByName('S_Deduct').AsString]);

        with nData[3] do
        begin
          FText := '';
          FAlign := taCenter;
          FCtrls := TList.Create;

          nBtn := TImageButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Parent := Self;
            ButtonID := 'btn_small_del';
            LoadButton(nBtn);

            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end; 
        end;

        nData[4].FText := Format('%.2f', [FieldByName('S_Money').AsFloat]);
        FPainter.AddData(nData);
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 按钮处理
procedure TfFrameMemberSet.OnBtnClick(Sender: TObject);
var nStr,nHint: string;
    nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  nHint := FPainter.Data[nTag][4].FText;

  nStr := 'Delete From %s Where S_Money=%s And S_TerminalId=''%s''';
  nStr := Format(nStr, [sTable_MemberSet, nHint, gSysParam.FTerminalID]);

  if FDM.SQLExecute(nStr, nHint) > 0 then
       LoadMemberSet
  else ShowDlg(nHint, sWarn);
end;

//Desc: 添加
procedure TfFrameMemberSet.BtnAddClick(Sender: TObject);
var nStr,nHint: string;
    nIdx: Integer;
begin
  if (not IsNumber(EditMoney.Text, True)) or (StrToFloat(EditMoney.Text) <= 0) then
  begin
    EditMoney.SetFocus;
    ShowMsg('请填写正确的金额', sHint); Exit;
  end;

  if (not IsNumber(EditZheKou.Text, True)) or (StrToFloat(EditZheKou.Text) <= 0) then
  begin
    EditZheKou.SetFocus;
    ShowMsg('请输入正确的折扣', sHint); Exit;
  end;

  for nIdx:=FPainter.DataCount - 1 downto 0 do
  if StrToFloat(FPainter.Data[nIdx][4].FText) = StrToFloat(EditMoney.Text) then
  begin
    EditMoney.SetFocus;
    ShowMsg('该金额已经存在', sHint); Exit;
  end;

  nStr := MakeSQLByStr([SF('R_Sync', sFlag_SyncW),
          SF('S_TerminalId', gSysParam.FTerminalID),
          SF('S_Money', EditMoney.Text, sfVal),
          SF('S_Deduct', EditZheKou.Text, sfVal),
          SF('S_AddMan', gSysParam.FUserID),
          SF('S_AddDate', sField_SQLServer_Now, sfVal)
          ], sTable_MemberSet, '', True);
  //xxxxx

  if FDM.SQLExecute(nStr, nHint) > 0 then
       LoadMemberSet
  else ShowDlg(nHint, sWarn);
end;

initialization
  gControlManager.RegCtrl(TfFrameMemberSet, TfFrameMemberSet.FrameID);
end.
