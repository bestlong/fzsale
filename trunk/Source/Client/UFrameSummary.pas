{*******************************************************************************
  作者: dmzn@163.com 2012-1-1
  描述: 综合信息
*******************************************************************************}
unit UFrameSummary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxButtons, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutLookAndFeels, dxLayoutControl, Grids,
  UGridExPainter, UGridPainter, StdCtrls, ExtCtrls, cxGraphics;

type
  TfFrameSummary = class(TfFrameBase)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    dxLayoutControl1Group2: TdxLayoutGroup;
    dxLayoutControl1Group3: TdxLayoutGroup;
    dxLayoutControl1Group4: TdxLayoutGroup;
    GridYesday: TDrawGridEx;
    dxLayoutControl1Item1: TdxLayoutItem;
    GridNotices: TDrawGridEx;
    dxLayoutControl1Item2: TdxLayoutItem;
    GridTenday: TDrawGridEx;
    dxLayoutControl1Item3: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    dxLayoutControl1Group6: TdxLayoutGroup;
    GridWarn: TDrawGridEx;
    dxLayoutControl1Item4: TdxLayoutItem;
    dxLayout1: TdxLayoutLookAndFeelList;
    dxLayoutWeb1: TdxLayoutWebLookAndFeel;
  private
    { Private declarations }
    FPainterA: TGridPainter;
    FPainterB: TGridPainter;
    FPainterC: TGridPainter;
    FPainterD: TGridPainter;
    //绘制对象
    procedure LoadDataYesday;
    procedure LoadDataTenday;
    //载入数据
    procedure LoadYesday;
    procedure LoadTenday;
    procedure LoadNotices;
    procedure LoadWarn;
    //载入摘要
    procedure AdjustHeight;
    //调整高度
    procedure OnBtnClick(Sender: TObject);
    procedure OnBtnClick2(Sender: TObject);
    //按钮点击
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

procedure SetTendayLoadFlag(const nFlag: Boolean);
//设置载入标记

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, USysConst, USysDB, UMgrControl, UDataModule, USysFun,
  DB, UFormNoticeView, UFrameNotices;

type
  PSaleItem = ^TSaleItem;
  TSaleItem = record
    FName: string;
    FNum: Integer;
    FMon: Double;
  end;

var
  gSaleYesday: TList = nil;
  gLoadedYesday: Boolean = False;

  gSaleTenday: TList = nil;
  gLoadedTenday: Boolean = False;
  gNotices: TList = nil;
  //全局使用

procedure SetTendayLoadFlag(const nFlag: Boolean);
begin
  gLoadedTenday := nFlag;
end;

procedure ClearList(var nList: TList; nType: Byte; nFree: Boolean = True);
var nIdx: Integer;
begin
  if not Assigned(nList) then Exit;
  for nIdx:=nList.Count - 1 downto 0 do
  begin
    case nType of
     1: Dispose(PSaleItem(nList[nIdx]));
     2: Dispose(PNoticeItem(nList[nIdx]));
    end;

    nList.Delete(nIdx);
  end;

  if nFree then FreeAndNil(nList);
end;

//------------------------------------------------------------------------------
class function TfFrameSummary.FrameID: integer;
begin
  Result := cFI_FrameSummary;
end;

procedure TfFrameSummary.OnCreateFrame;
var nIni: TIniFile;
    nInt,nW: Integer;
begin
  Name := MakeFrameName(FrameID);
  FPainterA := TGridPainter.Create(GridYesday);
  FPainterB := TGridPainter.Create(GridNotices);
  FPainterC := TGridPainter.Create(GridTenday);
  FPainterD := TGridPainter.Create(GridWarn);

  with FPainterA do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('商品名称', 50);
    AddHeader('件数', 50);
    AddHeader('总金额', 50);
  end;

  with FPainterB do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('通知标题', 50);
    AddHeader('通知时间', 50);
    AddHeader('操作', 50);
  end;

  with FPainterC do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('商品名称', 50);
    AddHeader('件数', 50);
    AddHeader('总金额', 50);
  end;

  with FPainterD do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('商品名称', 50);
    AddHeader('件数', 50);
    AddHeader('断货日期', 50);
    AddHeader('订货', 50);
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadDrawGridConfig(Name, GridYesday, nIni);
    LoadDrawGridConfig(Name, GridNotices, nIni);
    LoadDrawGridConfig(Name, GridTenday, nIni);
    LoadDrawGridConfig(Name, GridWarn, nIni);

    nInt := GetGridHeaderWidth(GridYesday);
    nW := GetGridHeaderWidth(GridTenday);
    if nInt < nW then nInt := nW;

    GridYesday.Width := nInt;
    GridTenday.Width := nInt;

    nInt := GetGridHeaderWidth(GridNotices);
    nW := GetGridHeaderWidth(GridWarn);
    if nInt < nW then nInt := nW;

    GridNotices.Width := nInt;
    GridWarn.Width := nInt;
    Width := GridTenday.Width + GridWarn.Width + 82;

    LoadYesday;
    LoadTenday;
    LoadNotices;
    
    LoadWarn;
    AdjustHeight;
  finally
    nIni.Free;
  end;
end;

procedure TfFrameSummary.OnDestroyFrame;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveDrawGridConfig(Name, GridYesday, nIni);
    SaveDrawGridConfig(Name, GridNotices, nIni);
    SaveDrawGridConfig(Name, GridTenday, nIni);
    SaveDrawGridConfig(Name, GridWarn, nIni);
  finally
    nIni.Free;
  end;

  FPainterA.Free;
  FPainterB.Free;
  FPainterC.Free;
  FPainterD.Free;
end;

//Desc: 调整各列表高度
procedure TfFrameSummary.AdjustHeight;
var nH,nInt: Integer;
begin
  nInt := FPainterA.DataCount;
  if FPainterB.DataCount > nInt then
    nInt := FPainterB.DataCount;
  nH := (nInt + 3) * GridYesday.DefaultRowHeight;

  if nH > GridYesday.Height then
    GridYesday.Height := nH;
  GridNotices.Height := GridYesday.Height;

  nInt := FPainterC.DataCount;
  if FPainterD.DataCount > nInt then
    nInt := FPainterD.DataCount;
  nH := (nInt + 3) * GridTenday.DefaultRowHeight;

  if nH > GridYesday.Height then
    GridTenday.Height := nH;
  GridWarn.Height := GridTenday.Height;
end;

//------------------------------------------------------------------------------
procedure TfFrameSummary.LoadDataYesday;
var nStr,nHint: string;
    nDS: TDataSet;
    nItem: PSaleItem;
begin
  if not Assigned(gSaleYesday) then
    gSaleYesday := TList.Create;
  if gLoadedYesday then Exit;

  nStr := 'Select Sum(D_Number) as SaleNum,Sum(D_Number*D_Price) As SaleMon,' +
          'StyleName,ColorName,SizeName From $DT dt ' +
          ' Left Join $SL sl On sl.S_ID=dt.D_SaleID ' +
          ' Left Join $PT pt On pt.ProductID=dt.D_Product ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          'Where S_TerminalId=''$ID'' And (S_Date>=''$KS'' And S_Date<''$JS'') ' +
          'Group By StyleName,ColorName,SizeName ' +
          'Order By SaleNum DESC';
  nStr := MacroValue(nStr, [MI('$DT', sTable_SaleDtl), MI('$SL', sTable_Sale),
          MI('$PT', sTable_DL_Product), MI('$ID', gSysParam.FTerminalID),
          MI('$SZ', sTable_DL_Size), MI('$CR', sTable_DL_Color),
          MI('$ST', sTable_DL_Style),
          MI('$KS', Date2Str(Date()-1)), MI('$JS', Date2Str(Date()))]);
  //xxxxx

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    gLoadedYesday := True;
    if nDS.RecordCount < 1 then Exit;

    with nDS do
    begin
      First;

      while not Eof do
      begin
        New(nItem);
        gSaleYesday.Add(nItem);

        nItem.FName := Format('%s_%s_%s', [FieldByName('StyleName').AsString,
                       FieldByName('ColorName').AsString,
                       FieldByName('SizeName').AsString]);
        nItem.FNum := FieldByName('SaleNum').AsInteger;
        nItem.FMon := FieldByName('SaleMon').AsFloat;
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

procedure TfFrameSummary.LoadDataTenday;
var nStr,nHint: string;
    nDS: TDataSet;
    nItem: PSaleItem;
begin
  if not Assigned(gSaleTenday) then
    gSaleTenday := TList.Create;
  if gLoadedTenday then Exit;

  nStr := 'Select Top 10 Sum(D_Number) as SaleNum,Sum(D_Number*D_Price) As SaleMon,' +
          'StyleName,ColorName,SizeName From $DT dt ' +
          ' Left Join $SL sl On sl.S_ID=dt.D_SaleID ' +
          ' Left Join $PT pt On pt.ProductID=dt.D_Product ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          'Where S_TerminalId=''$ID'' And (S_Date>=''$KS'' And S_Date<''$JS'') ' +
          'Group By StyleName,ColorName,SizeName ' +
          'Order By SaleNum DESC';
  nStr := MacroValue(nStr, [MI('$DT', sTable_SaleDtl), MI('$SL', sTable_Sale),
          MI('$PT', sTable_DL_Product), MI('$ID', gSysParam.FTerminalID),
          MI('$SZ', sTable_DL_Size), MI('$CR', sTable_DL_Color),
          MI('$ST', sTable_DL_Style),
          MI('$KS', Date2Str(Date()-10)), MI('$JS', Date2Str(Date()+1))]);
  //xxxxx

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    ClearList(gSaleTenday, 1, False);
    gLoadedTenday := True;
    if nDS.RecordCount < 1 then Exit;

    with nDS do
    begin
      First;

      while not Eof do
      begin
        New(nItem);
        gSaleTenday.Add(nItem);

        nItem.FName := Format('%s_%s_%s', [FieldByName('StyleName').AsString,
                       FieldByName('ColorName').AsString,
                       FieldByName('SizeName').AsString]);
        nItem.FNum := FieldByName('SaleNum').AsInteger;
        nItem.FMon := FieldByName('SaleMon').AsFloat;
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 昨天记录
procedure TfFrameSummary.LoadYesday;
var nData: TGridDataArray;
    nMon: Double;
    i,nIdx,nInt,nNum: Integer;
begin
  FPainterA.ClearData;
  LoadDataYesday;

  nNum := 0;
  nMon := 0;
  nInt := 1;
  
  for nIdx:=0 to gSaleYesday.Count - 1 do
  with PSaleItem(gSaleYesday[nIdx])^ do
  begin
    SetLength(nData, 4);
    for i:=Low(nData) to High(nData) do
    begin
      nData[i].FText := '';
      nData[i].FCtrls := nil;
      nData[i].FAlign := taCenter;
    end;

    nData[0].FText := IntToStr(nInt);
    Inc(nInt);

    nData[1].FText := FName;
    nData[2].FText := IntToStr(FNum);
    nNum := nNum + FNum;

    nData[3].FText := Format('%.2f', [FMon]);
    nMon := nMon + FMon;
    FPainterA.AddData(nData);
  end;

  SetLength(nData, 4);
  for nIdx:=Low(nData) to High(nData) do
  begin
    nData[nIdx].FText := '';
    nData[nIdx].FCtrls := nil;
    nData[nIdx].FAlign := taCenter;
  end;

  nData[0].FText := '总计:';
  nData[2].FText := Format('%d件', [nNum]);
  nData[3].FText := Format('%.2f元', [nMon]);
  FPainterA.AddData(nData);
end;

//Desc: 十日排行
procedure TfFrameSummary.LoadTenday;
var nData: TGridDataArray;
    nMon: Double;
    i,nIdx,nInt,nNum: Integer;
begin
  FPainterC.ClearData;
  LoadDataTenday;

  nNum := 0;
  nMon := 0;
  nInt := 1;
  
  for nIdx:=0 to gSaleTenday.Count - 1 do
  with PSaleItem(gSaleTenday[nIdx])^ do
  begin
    SetLength(nData, 4);
    for i:=Low(nData) to High(nData) do
    begin
      nData[i].FText := '';
      nData[i].FCtrls := nil;
      nData[i].FAlign := taCenter;
    end;

    nData[0].FText := IntToStr(nInt);
    Inc(nInt);

    nData[1].FText := FName;
    nData[2].FText := IntToStr(FNum);
    nNum := nNum + FNum;

    nData[3].FText := Format('%.2f', [FMon]);
    nMon := nMon + FMon;
    FPainterC.AddData(nData);
  end;

  SetLength(nData, 4);
  for nIdx:=Low(nData) to High(nData) do
  begin
    nData[nIdx].FText := '';
    nData[nIdx].FCtrls := nil;
    nData[nIdx].FAlign := taCenter;
  end;

  nData[0].FText := '总计:';
  nData[2].FText := Format('%d件', [nNum]);
  nData[3].FText := Format('%.2f元', [nMon]);
  FPainterC.AddData(nData);
end;

//Desc: 载入通知
procedure TfFrameSummary.LoadNotices;
var nStr,nHint: string;
    nIdx,nInt: Integer;
    nDS: TDataSet;
    nBtn: TcxButton;
    nItem: PNoticeItem;
    nData: TGridDataArray;
begin
  nStr := 'Select Top 10 * From %s Order By CreateTime DESC';
  nStr := Format(nStr, [sTable_DL_Noties]);

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    FPainterB.ClearData;
    if nDS.RecordCount < 1 then Exit;

    if Assigned(gNotices) then
         ClearList(gNotices, 2, False)
    else gNotices := TList.Create;
    
    with nDS do
    begin
      nInt := 1;
      First;

      while not Eof do
      begin
        New(nItem);
        gNotices.Add(nItem);

        nItem.FTitle := FieldByName('NoticeTitle').AsString;
        nItem.FMemo := FieldByName('NoticeContent').AsString;
        nItem.FDate := DateTime2Str(FieldByName('CreateTime').AsDateTime);

        SetLength(nData, 4);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FText := '';
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);
        nData[1].FText := nItem.FTitle;
        nData[2].FText := nItem.FDate;

        with nData[3] do
        begin
          FText := '';
          FAlign := taCenter;
          FCtrls := TList.Create;

          nBtn := TcxButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Caption := '查看';
            Width := 35;
            Height := 18;

            Parent := Self;
            OnClick := OnBtnClick;
            Tag := gNotices.Count - 1;
          end; 
        end;

        FPainterB.AddData(nData);
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

procedure TfFrameSummary.LoadWarn;
begin

end;

//Desc: 经营通知
procedure TfFrameSummary.OnBtnClick(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  ShowNoticeViewForm(gNotices[nTag]);
end;

procedure TfFrameSummary.OnBtnClick2(Sender: TObject);
begin

end;

initialization
  gControlManager.RegCtrl(TfFrameSummary, TfFrameSummary.FrameID);
finalization
  ClearList(gSaleYesday, 1);
  ClearList(gSaleTenday, 1);
  ClearList(gNotices, 2);
end.
