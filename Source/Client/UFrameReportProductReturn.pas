{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 商品代理退货统计
*******************************************************************************}
unit UFrameReportProductReturn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, StdCtrls,
  cxButtons, cxLabel, cxRadioGroup, Grids, UGridPainter, UGridExPainter,
  ExtCtrls, cxDropDownEdit, cxCalendar, cxMaskEdit, UImageButton;

type
  TfFrameReportProductReturn = class(TfFrameBase)
    PanelR: TPanel;
    PanelL: TPanel;
    LabelHint: TLabel;
    GridDetail: TDrawGridEx;
    GridProduct: TDrawGridEx;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Label1: TLabel;
    EditTime: TcxComboBox;
    EditS: TcxDateEdit;
    EditE: TcxDateEdit;
    Panel1: TPanel;
    Label2: TLabel;
    BtnSearch: TImageButton;
    procedure BtnExitClick(Sender: TObject);
    procedure EditTimePropertiesEditValueChanged(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridPainter;
    FPainterEx: TGridExPainter;
    //绘图对象
    FData: TList;
    //数据列表
    procedure ClearData(const nFree: Boolean);
    //清理数据
    procedure LoadProductData;
    procedure LoadProductList;
    //产品列表
    function CountNumber(const nID: string): Integer;
    //统计数量
    procedure OnBtnClick(Sender: TObject);
    //点击按钮
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UDataModule, DB, UMgrControl, USysConst, USysDB, USysFun;

type
  PDataItem = ^TDataItem;
  TDataItem = record
    FStyle: string;
    FName: string;
    FColor: string;
    FSize: string;
    FNumber: Integer;
  end;

class function TfFrameReportProductReturn.FrameID: integer;
begin
  Result := cFI_FrameReportRT;
end;

procedure TfFrameReportProductReturn.OnCreateFrame;
var nIni: TIniFile;
begin
  Name := MakeFrameName(FrameID);
  FData := TList.Create;
  FPainter := TGridPainter.Create(GridProduct);
  FPainterEx := TGridExPainter.Create(GridDetail);

  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('款式名称', 50);
    AddHeader('总退货', 50);
    AddHeader('详细查询', 50);
  end;

  with FPainterEx do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('颜色', 50, True);
    AddHeader('尺码', 50);
    AddHeader('共退货', 50);
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadDrawGridConfig(Name, GridProduct, nIni);
    LoadDrawGridConfig(Name, GridDetail, nIni);
    PanelL.Width := nIni.ReadInteger(Name, 'PanelL', 120);

    Width := PanelL.Width + GetGridHeaderWidth(GridDetail);
    EditTime.ItemIndex := 0;
    BtnSearch.Top := EditTime.Top + Trunc((EditTime.Height - BtnSearch.Height) / 2);
  finally
    nIni.Free;
  end;
end;

procedure TfFrameReportProductReturn.OnDestroyFrame;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveDrawGridConfig(Name, GridProduct, nIni);
    SaveDrawGridConfig(Name, GridDetail, nIni);
    nIni.WriteInteger(Name, 'PanelL', PanelL.Width);
  finally
    nIni.Free;
  end;

  FPainter.Free;
  FPainterEx.Free;
  ClearData(True);
end;

procedure TfFrameReportProductReturn.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 清理数据
procedure TfFrameReportProductReturn.ClearData(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FData.Count - 1 downto 0 do
  begin
    Dispose(PDataItem(FData[nIdx]));
    FData.Delete(nIdx);
  end;

  if nFree then FData.Free;
end;

//Desc: 时间变动
procedure TfFrameReportProductReturn.EditTimePropertiesEditValueChanged(Sender: TObject);
var nS,nE: TDate;
begin
  GetDateInterval(EditTime.ItemIndex, nS, nE);
  EditS.Date := nS;
  EditE.Date := nE;
end;

procedure TfFrameReportProductReturn.BtnSearchClick(Sender: TObject);
begin
  BtnSearch.Enabled := False;
  try
    LoadProductData;
  finally
    BtnSearch.Enabled := True;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入产品列表
procedure TfFrameReportProductReturn.LoadProductData;
var nStr,nHint: string;
    nDS: TDataSet;
    nItem: PDataItem;
begin
  nStr := 'Select Sum(D_Number) As D_InNum,pt.StyleID,StyleName,ColorName,' +
          'SizeName From $DL dl ' +
          ' Left Join $RT rt On rt.T_ID=dl.D_Return ' +
          ' Left Join $PT pt On pt.ProductID=dl.D_Product ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          'Where T_TerminalId = ''$ID'' And (T_Date>=''$KS'' And ' +
          ' T_Date<''$JS'') And T_Status=''$OK'' ' +
          'Group By pt.StyleID,StyleName,ColorName,SizeName ' +
          'Order By StyleName,ColorName,SizeName';
  nStr := MacroValue(nStr, [MI('$DL', sTable_ReturnDtl), MI('$RT', sTable_Return),
          MI('$PT', sTable_DL_Product), MI('$ST', sTable_DL_Style),
          MI('$CR', sTable_DL_Color), MI('$SZ', sTable_DL_Size),
          MI('$OK', sFlag_BillDone), MI('$ID', gSysParam.FTerminalID),
          MI('$KS', Date2Str(EditS.Date)), MI('$JS', Date2Str(EditE.Date + 1))]);
  //xxxxx


  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    ClearData(False);
    FPainter.ClearData;
    if nDS.RecordCount < 1 then Exit;

    with nDS do
    begin
      First;

      while not Eof do
      begin
        New(nItem);
        FData.Add(nItem);

        with nItem^ do
        begin
          FStyle := FieldByName('StyleID').AsString;
          FName := FieldByName('StyleName').AsString;
          FColor := FieldByName('ColorName').AsString;
          FSize := FieldByName('SizeName').AsString;
          FNumber := FieldByName('D_InNum').AsInteger;
        end;

        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;

  LoadProductList;
end;

//Desc: 载入产品列表到界面
procedure TfFrameReportProductReturn.LoadProductList;
var i,nIdx,nInt: Integer;
    nList: TStrings;
    nBtn: TImageButton;
    nData: TGridDataArray;
begin
  nList := TStringList.Create;
  try
    nInt := 1;

    for nIdx:=0 to FData.Count - 1 do
     with PDataItem(FData[nIdx])^ do
      if nList.IndexOf(FStyle) < 0 then
      begin
        nList.Add(FStyle);
        SetLength(nData, 5);

        for i:=Low(nData) to High(nData) do
        begin
          nData[i].FText := '';
          nData[i].FCtrls := nil;
          nData[i].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);
        nData[1].FText := FName;
        nData[2].FText := IntToStr(CountNumber(FStyle));

        with nData[3] do
        begin
          FCtrls := TList.Create;
          nBtn := TImageButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Parent := Self;
            ButtonID := 'btn_view_detail';
            LoadButton(nBtn);

            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end;
        end;

        nData[4].FText := FStyle;
        FPainter.AddData(nData);
      end;
  finally
    nList.Free;
  end;
end;

//Desc: 统计指定款式的库存总量
function TfFrameReportProductReturn.CountNumber(const nID: string): Integer;
var nIdx: Integer;
begin
  Result := 0;

  for nIdx:=FData.Count - 1 downto 0 do
   with PDataItem(FData[nIdx])^ do
    if FStyle = nID then Result := Result + FNumber;
  //xxxxx
end;

//Desc: 查看详情
procedure TfFrameReportProductReturn.OnBtnClick(Sender: TObject);
var nStr,nID: string;
    nIdx,nNum,nInt: Integer;
    nRow: TGridExDataArray;
    nCol: TGridExColDataArray;
begin
  nNum := TComponent(Sender).Tag;
  nID := FPainter.Data[nNum][4].FText;

  LabelHint.Caption := FPainter.Data[nNum][1].FText + '退货详情';
  nInt := AdjustLabelCaption(LabelHint, GridDetail);

  if nInt > LabelHint.Width then
    Width := PanelL.Width + nInt + 32;
  //标题超长自适应

  nNum := 0;
  nStr := '';
  FPainterEx.ClearData;

  for nIdx:=0 to FData.Count - 1 do
   with PDataItem(FData[nIdx])^ do
    if FStyle = nID then
    begin
      SetLength(nRow, 3);
      for nInt:=Low(nRow) to High(nRow) do
      begin
        nRow[nInt].FCtrls := nil;
        nRow[nInt].FAlign := taCenter;
      end;

      nRow[0].FText := FSize;
      nRow[1].FText := IntToStr(FNumber);
      FPainterEx.AddRowData(nRow);
      //添加行数据
        
      if nStr = '' then
        nStr := FColor;
      //xxxxx

      if nStr = FColor then
      begin
        Inc(nNum);
        Continue;
      end;

      SetLength(nCol, 1);
      with nCol[0] do
      begin
        FCol := 0;
        FRows := nNum;
        FAlign := taCenter;
        FText := nStr;

        nNum := 1;
        nStr := FColor;
      end;

      FPainterEx.AddColData(nCol);
    end;
  //color

  if nNum > 0 then
  begin
    SetLength(nCol, 1);
    with nCol[0] do
    begin
      FCol := 0;
      FRows := nNum;
      FAlign := taCenter;
      FText := nStr;
    end;

    FPainterEx.AddColData(nCol);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameReportProductReturn, TfFrameReportProductReturn.FrameID);
end.
