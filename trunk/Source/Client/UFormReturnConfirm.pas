{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 商品订单确认
*******************************************************************************}
unit UFormReturnConfirm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, StdCtrls,
  UImageButton, Grids, UGridPainter, cxCheckBox, cxMaskEdit,
  cxDropDownEdit, UGridExPainter, Menus, cxButtons;

type
  TfFormReturnConfirm = class(TSkinFormBase)
    LabelHint: TLabel;
    GridList: TDrawGridEx;
    Panel1: TPanel;
    Panel2: TPanel;
    BtnOK: TImageButton;
    BtnCancel: TImageButton;
    Label1: TLabel;
    EditID: TcxTextEdit;
    Label2: TLabel;
    EditMan: TcxTextEdit;
    Label3: TLabel;
    EditTime: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FID,FMan,FTime: string;
    FPainter: TGridPainter;
    //绘制对象
    procedure LoadReturnInfo(const nReturn: string);
    //退货信息
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowReturnConfirmForm(const nReturn: string): Boolean;
//退货确认

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule, FZSale_Intf;

function ShowReturnConfirmForm(const nReturn: string): Boolean;
begin
  with TfFormReturnConfirm.Create(Application) do
  begin
    LoadReturnInfo(nReturn);
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormReturnConfirm.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormReturnConfirm.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx

  FPainter := TGridPainter.Create(GridList);
  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('商品名称', 50);
    AddHeader('当前进货价', 50);
    AddHeader('当前库存', 50);
    AddHeader('退货量', 50);
  end;

  LoadFormConfig(Self);
  LoadDrawGridConfig(Name, GridList);
end;

procedure TfFormReturnConfirm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
end;

procedure TfFormReturnConfirm.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormReturnConfirm.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 65 + BtnCancel.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnCancel.Left := nL + BtnOK.Width + 65;
end;

//------------------------------------------------------------------------------
//Desc: 载入退货信息
procedure TfFormReturnConfirm.LoadReturnInfo(const nReturn: string);
var nStr,nHint: string;
    nDS: TDataSet;
    nIdx,nInt: Integer;
    nData: TGridDataArray;
begin
  if nReturn = '' then
  begin
    nStr := 'Select Top 1 * From %s Where T_Status=''%s'' And ' +
            'T_TerminalId=''%s'' Order By R_ID DESC';
    nStr := Format(nStr, [sTable_Return, sFlag_BillLock, gSysParam.FTerminalID]);
  end else
  begin
    nStr := 'Select * From %s Where T_ID=''%s'' And ' +
            '(T_Status=''%s'' or T_Status=''%s'') ';
    nStr := Format(nStr, [sTable_Return, nReturn, sFlag_BillLock, sFlag_BillNew]);
  end;

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    if nDS.RecordCount > 0 then
    begin
      FID := nDS.FieldByName('T_ID').AsString;
      FMan := nDS.FieldByName('T_Man').AsString;
      FTime := DateTime2Str(nDS.FieldByName('T_Date').AsDateTime);
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;

  if FID = '' then
  begin
    ShowMsg('没有待确认的退货单', sHint);
    Exit;
  end;

  EditID.Text := FID;
  EditMan.Text := FMan;
  EditTime.Text := FTime;

  nStr := 'Select rd.*,StyleName,SizeName,ColorName,P_Price,P_Number From $RD rd ' +
          '  Left Join $PT pt On pt.ProductID=rd.D_Product ' +
          '  Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          '  Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          '  Left Join $ST st On st.StyleID=pt.StyleID ' +
          '  Left Join $TP tp On tp.P_ID=rd.D_Product ' +
          'Where D_Return=''$ID'' Order by rd.R_ID';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$RD', sTable_ReturnDtl),
          MI('$TP', sTable_Product), MI('$PT', sTable_DL_Product),
          MI('$SZ', sTable_DL_Size), MI('$CR', sTable_DL_Color),
          MI('$ST', sTable_DL_Style), MI('$ID', FID)]);
  //xxxxx

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

      nStr := FieldByName('StyleName').AsString;
      LabelHint.Caption := Format('%s款式退货单确认', [nStr]);

      while not Eof do
      begin
        SetLength(nData, 6);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nStr := Format('%s_%s_%s', [FieldByName('StyleName').AsString,
                FieldByName('ColorName').AsString,
                FieldByName('SizeName').AsString]);
        //xxxxx

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);
        nData[1].FText := nStr;

        nData[2].FText := Format('%.2f', [FieldByName('P_Price').AsFloat]);
        nData[3].FText := FieldByName('P_Number').AsString;
        nData[4].FText := FieldByName('D_Number').AsString;

        nData[5].FText := FieldByName('D_Product').AsString;
        FPainter.AddData(nData);
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 确定
procedure TfFormReturnConfirm.BtnOKClick(Sender: TObject);
var nStr,nHint: string;
    nIdx: Integer;
    nSQLList: SQLItems;
begin
  nStr := '要确认编号为[ %s ]的退货单吗?';
  nStr := Format(nStr, [FID]);
  if not QueryDlg(nStr, sAsk, Handle) then Exit;

  nSQLList := SQLItems.Create;
  try
    nStr := 'Update %s Set T_Status=''%s'',T_ActMan=''%s'',T_ActDate=%s ' +
            'Where T_ID=''%s''';
    nStr := Format(nStr, [sTable_Return, sFlag_BillNew, gSysParam.FUserID,
            sField_SQLServer_Now, FID]);
    //xxxxx
    
    with nSQLList.Add do
    begin
      SQL := nStr;
      IfRun := '';
      IfType := 0;
    end;

    for nIdx:=0 to FPainter.DataCount - 1 do
    begin
      nStr := 'Update %s Set P_Number=P_Number-(%s) ' +
              'Where P_TerminalId=''%s'' And P_ID=''%s''';
      nStr := Format(nStr, [sTable_Product, FPainter.Data[nIdx][4].FText,
              gSysParam.FTerminalID, FPainter.Data[nIdx][5].FText]);
      //xxxxx

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end;
    end;
    
    if FDM.SQLUpdates(nSQLList, True, nHint) > 0 then
    begin
      ShowMsg('退货单确认成功', sHint);
      ModalResult := mrOk;
    end else ShowDlg(nHint, sWarn, Handle);
  finally
    //nSQLList.Free;
  end;
end;

//Desc: 取消订单
procedure TfFormReturnConfirm.BtnCancelClick(Sender: TObject);
var nStr,nHint: string;
begin
  nStr := '要取消编号为[ %s ]的退货单吗?' + #32#32#13#10#13#10 +
          '取消后退货单将作废.';
  nStr := Format(nStr, [FID]);
  if not QueryDlg(nStr, sAsk, Handle) then Exit;

  nStr := 'Update %s Set T_Status=''%s'',T_ActMan=''%s'',T_ActDate=%s ' +
          'Where T_ID=''%s''';
  nStr := Format(nStr, [sTable_Return, sFlag_BillCancel, gSysParam.FUserID,
          sField_SQLServer_Now, FID]);
  //xxxxx

  if FDM.SQLExecute(nStr, nHint) > 0 then
  begin
    ShowMsg('退货单已经取消', sHint);
    ModalResult := mrOk;
  end else ShowDlg(nHint, sWarn, Handle);
end;

end.
