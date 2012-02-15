{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 产品退货单处理
*******************************************************************************}
unit UFrameProductReturn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, UGridPainter, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, Grids, UGridExPainter, cxPC,
  StdCtrls, ExtCtrls, cxGraphics, Menus, cxButtons;

type
  TfFrameProductReturn = class(TfFrameBase)
    PanelR: TPanel;
    LabelHint: TLabel;
    wPage: TcxPageControl;
    Sheet1: TcxTabSheet;
    Sheet2: TcxTabSheet;
    GridBill: TDrawGridEx;
    GridDone: TDrawGridEx;
    procedure BtnExitClick(Sender: TObject);
    procedure wPageChange(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridPainter;
    FPainter2: TGridPainter;
    //绘图对象
    FDoneLoaded: Boolean;
    //载入标记
    procedure LoadProductReturn;
    procedure LoadProductReturnDone;
    //产品列表
    procedure OnBtnClick(Sender: TObject);
    procedure OnBtnClick2(Sender: TObject);
    procedure OnBtnClick3(Sender: TObject);
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
  IniFiles, ULibFun, UDataModule, DB, UMgrControl, USysConst, USysDB, USysFun,
  UFormReturnConfirm, UFormProductReturnAdjust, UFormProductReturnView;

class function TfFrameProductReturn.FrameID: integer;
begin
  Result := cFI_FrameReturnDL;
end;

procedure TfFrameProductReturn.OnCreateFrame;
var nIni: TIniFile;
begin
  FDoneLoaded := False;
  Name := MakeFrameName(FrameID);

  FPainter := TGridPainter.Create(GridBill);
  FPainter2 := TGridPainter.Create(GridDone);

  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('状态', 50);
    AddHeader('退货单号', 50);
    AddHeader('商品款式', 50);
    AddHeader('退货件数', 50);
    AddHeader('现有库存', 50);
    AddHeader('退货人', 50);
    AddHeader('退货日期', 50);
    AddHeader('操作', 50);
  end;

  with FPainter2 do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('退货单号', 50);
    AddHeader('商品款式', 50);
    AddHeader('退货件数', 50);
    AddHeader('退货人', 50);
    AddHeader('退货日期', 50);
    AddHeader('收货人', 50);
    AddHeader('收货日期', 50);
    AddHeader('操作', 50);
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadDrawGridConfig(Name, GridBill, nIni);
    LoadDrawGridConfig(Name, GridDone, nIni);

    wPage.ActivePage := Sheet1;
    LoadProductReturn;
  finally
    nIni.Free;
  end;
end;

procedure TfFrameProductReturn.OnDestroyFrame;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveDrawGridConfig(Name, GridBill, nIni);
    SaveDrawGridConfig(Name, GridDone, nIni);
  finally
    nIni.Free;
  end;

  FPainter.Free;
  FPainter2.Free;
end;

procedure TfFrameProductReturn.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 载入未完成退单
procedure TfFrameProductReturn.LoadProductReturn;
var nStr,nHint: string;
    nDS: TDataSet;
    nIdx,nInt: Integer;
    nBtn: TcxButton;
    nData: TGridDataArray;
begin
  nStr := 'Select Top 50 rt.*,rd.*,P_Number,StyleName,ColorName,' +
          'SizeName From $RD rd ' +
          ' Left Join $PT pt On pt.ProductID=rd.D_Product ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $RT rt On rt.T_ID=rd.D_Return ' +
          ' Left Join $TP tp On tp.P_ID=rd.D_Product ' +
          'Where T_TerminalId=''$ID'' And T_Status<>''$OK'' ' +
          'Order By D_Return DESC';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$RD', sTable_ReturnDtl),
          MI('$TP', sTable_Product), MI('$PT', sTable_DL_Product),
          MI('$ST', sTable_DL_Style), MI('$SZ', sTable_DL_Size),
          MI('$CR', sTable_DL_Color), MI('$RT', sTable_Return),
          MI('$ID', gSysParam.FTerminalID), MI('$OK', sFlag_BillDone)]);
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
      nInt := 1;

      while not Eof do
      begin
        SetLength(nData, 10);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);

        nData[1].FText := BillStatusDesc(FieldByName('T_Status').AsString, False);
        nData[2].FText := FieldByName('D_Return').AsString;

        nStr := Format('%s_%s_%s', [FieldByName('StyleName').AsString,
                FieldByName('ColorName').AsString, FieldByName('SizeName').AsString]);
        nData[3].FText := nStr;

        nData[4].FText := FieldByName('D_Number').AsString;
        nData[5].FText := IntToStr(FieldByName('P_Number').AsInteger);
        nData[6].FText := FieldByName('T_Man').AsString;
        nData[7].FText := DateTime2Str(FieldByName('T_Date').AsDateTime);

        with nData[8] do
        begin
          FText := '';
          FAlign := taLeftJustify;
          FCtrls := TList.Create;

          if FieldByName('T_Status').AsString = sFlag_BillLock then
          begin
            nBtn := TcxButton.Create(Self);
            FCtrls.Add(nBtn);

            with nBtn do
            begin
              Caption := '调整';
              Width := 35;
              Height := 18;

              OnClick := OnBtnClick2;
              Tag := FPainter.DataCount;
            end;

            nBtn := TcxButton.Create(Self);
            FCtrls.Add(nBtn);

            with nBtn do
            begin
              Caption := '确认';
              Width := 35;
              Height := 18;

              OnClick := OnBtnClick2;
              Tag := FPainter.DataCount;
            end;
          end else
          begin
            nBtn := TcxButton.Create(Self);
            FCtrls.Add(nBtn);

            with nBtn do
            begin
              Caption := '查看';
              Width := 35;
              Height := 18;

              OnClick := OnBtnClick;
              Tag := FPainter.DataCount;
            end;
          end;
        end;

        nData[9].FText := FieldByName('R_ID').AsString;
        FPainter.AddData(nData);
        Next;
      end;
    end;

    FDoneLoaded := False;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 载入已完成退单
procedure TfFrameProductReturn.LoadProductReturnDone;
var nStr,nHint: string;
    nDS: TDataSet;
    nIdx,nInt: Integer;
    nBtn: TcxButton;
    nData: TGridDataArray;
begin
  if FDoneLoaded then Exit;
  //重复载入判定

  nStr := 'Select Top 50 rt.*,rd.*,StyleName,ColorName,SizeName From $RD rd ' +
          ' Left Join $PT pt On pt.ProductID=rd.D_Product ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $RT rt On rt.T_ID=rd.D_Return ' +
          'Where T_TerminalId=''$ID'' And T_Status=''$OK'' ' +
          'Order By D_Return DESC';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$RD', sTable_ReturnDtl),
          MI('$PT', sTable_DL_Product),
          MI('$ST', sTable_DL_Style), MI('$SZ', sTable_DL_Size),
          MI('$CR', sTable_DL_Color), MI('$RT', sTable_Return),
          MI('$ID', gSysParam.FTerminalID), MI('$OK', sFlag_BillDone)]);
  //xxxxx

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    FPainter2.ClearData;
    if nDS.RecordCount < 1 then Exit;

    with nDS do
    begin 
      First;
      nInt := 1;

      while not Eof do
      begin
        SetLength(nData, 9);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);
        nData[1].FText := FieldByName('D_Return').AsString;

        nStr := Format('%s_%s_%s', [FieldByName('StyleName').AsString,
                FieldByName('ColorName').AsString, FieldByName('SizeName').AsString]);
        nData[2].FText := nStr;

        nData[3].FText := FieldByName('D_Number').AsString;
        nData[4].FText := FieldByName('T_Man').AsString;
        nData[5].FText := DateTime2Str(FieldByName('T_Date').AsDateTime);

        nData[6].FText := FieldByName('T_ActMan').AsString;
        nData[7].FText := DateTime2Str(FieldByName('T_ActDate').AsDateTime);

        with nData[8] do
        begin
          FText := '';
          FCtrls := TList.Create;

          nBtn := TcxButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Caption := '查看';
            Width := 35;
            Height := 18;
            
            OnClick := OnBtnClick3;
            Tag := FPainter2.DataCount;
          end;
        end;

        FPainter2.AddData(nData);
        Next;
      end;
    end;

    FDoneLoaded := True;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 页面切换
procedure TfFrameProductReturn.wPageChange(Sender: TObject);
begin
  if wPage.ActivePage = Sheet2 then LoadProductReturnDone;
end;

//Desc: 调整未确认单
procedure TfFrameProductReturn.OnBtnClick2(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  if Sender = FPainter.Data[nTag][8].FCtrls[0] then
  begin
    if ShowProductReturnAdjust(FPainter.Data[nTag][2].FText) then
      LoadProductReturn;
  end else //调整

  if Sender = FPainter.Data[nTag][8].FCtrls[1] then
  begin
    if ShowReturnConfirmForm(FPainter.Data[nTag][2].FText) then
      LoadProductReturn;
    //确认
  end;
end;

procedure TfFrameProductReturn.OnBtnClick(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  if Sender = FPainter.Data[nTag][8].FCtrls[0] then
  begin
    ShowProductReturnView(FPainter.Data[nTag][2].FText);
  end;
end;

procedure TfFrameProductReturn.OnBtnClick3(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  if Sender = FPainter2.Data[nTag][8].FCtrls[0] then
  begin
    ShowProductReturnView(FPainter2.Data[nTag][1].FText);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameProductReturn, TfFrameProductReturn.FrameID);
end.
