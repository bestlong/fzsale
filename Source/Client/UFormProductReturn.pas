{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 商品退货
*******************************************************************************}
unit UFormProductReturn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, StdCtrls,
  UImageButton, Grids, UGridExPainter, cxCheckBox, cxMaskEdit,
  cxDropDownEdit;

type
  TfFormProductReturn = class(TSkinFormBase)
    LabelHint: TLabel;
    GridList: TDrawGridEx;
    Panel1: TPanel;
    BtnOK: TImageButton;
    BtnExit: TImageButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridExPainter;
    //绘制对象
    procedure LoadProductList(const nStyleID: string);
    //商品信息
    procedure OnEditExit(Sender: TObject);
    //数据生效
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowProductReturnForm(const nStyleID: string): Boolean;
//添加账户

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule, FZSale_Intf;

function ShowProductReturnForm(const nStyleID: string): Boolean;
begin
  with TfFormProductReturn.Create(Application) do
  begin
    LoadProductList(nStyleID);      
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductReturn.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductReturn.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx

  FPainter := TGridExPainter.Create(GridList);
  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('款式名称', 50, True);
    AddHeader('颜色', 50, True);
    AddHeader('尺码', 50);
    AddHeader('现有库存', 50);
    AddHeader('上次进货价', 50);
    AddHeader('当前进货价', 50);
    AddHeader('当前零售价', 50);
    AddHeader('退货量', 50);
  end;

  LoadFormConfig(Self);
  LoadDrawGridConfig(Name, GridList);
end;

procedure TfFormProductReturn.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
end;

procedure TfFormProductReturn.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormProductReturn.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 65 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 65;
end;

//------------------------------------------------------------------------------
//Desc: 载入执行产品信息
procedure TfFormProductReturn.LoadProductList(const nStyleID: string);
var nStr,nHint: string;
    nInt,nNum: Integer;
    nDS: TDataSet;
    nLabel: TLabel;
    nEdit: TcxTextEdit;
    nRow: TGridExDataArray;
    nCol: TGridExColDataArray;
begin
  nStr := 'Select pt.*,dpt.StyleID,StyleName,ColorName,SizeName,' +
          'TerminalPrice,ProductID From $DPT dpt ' +
          ' Left Join $PT pt on pt.P_ID=dpt.ProductID ' +
          ' Left Join $ST st On st.StyleID=dpt.StyleID ' +
          ' Left Join $CR cr On cr.ColorID=dpt.ColorID ' +
          ' Left Join $SZ sz on sz.SizeID=dpt.SizeID ' +
          'Where dpt.StyleID=''$SID'' ' +
          'Order By ColorName,SizeName';
  //xxxxx
  
  nStr := MacroValue(nStr, [MI('$PT', sTable_Product), MI('$DPT', sTable_DL_Product),
          MI('$ST', sTable_DL_Style), MI('$CR', sTable_DL_Color),
          MI('$SZ', sTable_DL_Size), MI('$ID', gSysParam.FTerminalID),
          MI('$SID', nStyleID)]);
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
      First;
      nStr := FieldByName('StyleName').AsString;
      LabelHint.Caption := Format('%s款式退货单', [nStr]);

      SetLength(nCol, 1);
      with nCol[0] do
      begin
        FCol := 0;
        FRows := RecordCount;
        FAlign := taCenter;
        FText := FieldByName('StyleName').AsString;
      end;
      FPainter.AddColData(nCol);

      nHint := '';
      nNum := 0;

      while not Eof do
      begin
        SetLength(nRow, 7);
        for nInt:=Low(nRow) to High(nRow) do
        begin
          nRow[nInt].FCtrls := nil;
          nRow[nInt].FAlign := taCenter;
        end;

        nRow[0].FText := FieldByName('SizeName').AsString;
        nRow[1].FText := IntToStr(FieldByName('P_Number').AsInteger);
        nRow[2].FText := Format('%.2f', [FieldByName('P_InPrice').AsFloat]);
        nRow[3].FText := Format('%.2f', [FieldByName('TerminalPrice').AsFloat]);
        nRow[4].FText := Format('%.2f', [FieldByName('P_Price').AsFloat]);

        with nRow[5] do
        begin
          FText := '';
          FCtrls := TList.Create;

          nEdit := TcxTextEdit.Create(Self);
          FCtrls.Add(nEdit);

          with nEdit do
          begin
            Width := 52;
            Height := 18;

            if FieldByName('P_Number').AsInteger >= 0 then
                 Text := '0'
            else Text := IntToStr(FieldByName('P_Number').AsInteger);

            Tag := FPainter.DataCount;
            OnExit := OnEditExit;
          end;

          nLabel := TLabel.Create(Self);
          nLabel.Transparent := True;
          nLabel.Caption := '件';
          FCtrls.Add(nLabel);
        end;

        nRow[6].FText := FieldByName('ProductID').AsString;
        FPainter.AddRowData(nRow);
        //添加行数据

        //----------------------------------------------------------------------
        if nHint = '' then
          nHint := FieldByName('ColorName').AsString;
        //first time

        if nHint = FieldByName('ColorName').AsString then
        begin
          Inc(nNum);
          Next; Continue;
        end;

        SetLength(nCol, 1);
        with nCol[0] do
        begin
          FCol := 1;
          FRows := nNum;
          FAlign := taCenter;
          FText := nHint;

          nNum := 1;
          nHint := FieldByName('ColorName').AsString;
        end;

        FPainter.AddColData(nCol);
        Next;
      end;
    end;

    if nNum > 0 then
    begin
      SetLength(nCol, 1);
      with nCol[0] do
      begin
        FCol := 1;
        FRows := nNum;
        FAlign := taCenter;
        FText := nHint;
      end;
      FPainter.AddColData(nCol);
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 内容生效
procedure TfFormProductReturn.OnEditExit(Sender: TObject);
var nTag: Integer;
begin
  with TcxTextEdit(Sender) do
  begin
    if (not IsNumber(Text, False)) or (StrToInt(Text) < 0) then
    begin
      SetFocus;
      ShowMsg('请填写有效件数', sHint); Exit;
    end;

    nTag := TComponent(Sender).Tag;
    if StrToInt(FPainter.Data[nTag][1].FText) < StrToInt(Text) then
    begin
      SetFocus;
      ShowMsg('退货件数超出了库存', sHint); 
    end;
  end;
end;

//Desc: 保存
procedure TfFormProductReturn.BtnOKClick(Sender: TObject);
var nStr, nHint: string;
    nIdx,nNum: Integer;
    nSQLList: SQLItems;
begin
  ActiveControl := nil;
  if Assigned(ActiveControl) then Exit;

  nSQLList := SQLItems.Create;
  try
    nNum := 0;
    for nIdx:=0 to FPainter.DataCount - 1 do
    begin
      nStr := TcxTextEdit(FPainter.Data[nIdx][5].FCtrls[0]).Text;
      if IsNumber(nStr, False) and (StrToInt(nStr) > 0) then
        nNum := nNum + StrToInt(nStr);
      //xxxxx
    end;

    if nNum < 1 then
    begin
      nSQLList.Free;
      ShowMsg('退单件数为零', sHint); Exit;
    end;

    nStr := MakeSQLByStr([SF('T_TerminalId', gSysParam.FTerminalID),
            SF('T_Number', IntToStr(nNum), sfVal),
            SF('T_DoneNum', '0', sfVal),
            SF('T_Man', gSysParam.FUserID),
            SF('T_Date', sField_SQLServer_Now, sfVal),
            SF('T_ActDate', sField_SQLServer_Now, sfVal),
            SF('T_Status', sFlag_BillLock)], sTable_Return, '', True);
    //insert sql

    with nSQLList.Add do
    begin
      SQL := nStr;
      IfRun := '';
      IfType := 0;
    end;

    for nIdx:=0 to FPainter.DataCount - 1 do
    begin
      nStr := TcxTextEdit(FPainter.Data[nIdx][5].FCtrls[0]).Text;
      if (not IsNumber(nStr, False)) or (StrToInt(nStr) <= 0) then Continue;

      nStr := MakeSQLByStr([SF('D_Number', nStr, sfVal),
            SF('D_Product', FPainter.Data[nIdx][6].FText),
            SF('D_HasIn', '0', sfVal),
            SF('D_InDate', sField_SQLServer_Now, sfVal)], sTable_ReturnDtl, '', True);
      //insert sql
      
      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end; 
    end;

    nStr := 'Update %s Set D_Return=(Select Top 1 T_ID From %s ' +
            'Order By R_ID DESC) Where D_Return Is Null';
    nStr := Format(nStr, [sTable_ReturnDtl, sTable_Return]);
    
    with nSQLList.Add do
    begin
      SQL := nStr;
      IfRun := '';
      IfType := 0;
    end;

    if FDM.SQLUpdates(nSQLList, True, nHint) > -1 then
    begin
      ModalResult := mrOk;
    end else ShowDlg(nHint, sWarn);
  finally
    //nSQLList.Free;
  end;
end;

end.
