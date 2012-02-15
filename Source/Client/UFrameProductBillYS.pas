{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 产品订单验收
*******************************************************************************}
unit UFrameProductBillYS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, UGridPainter, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, Grids, UGridExPainter, cxPC,
  StdCtrls, ExtCtrls, cxGraphics, Menus, cxButtons;

type
  TfFrameProductBillYS = class(TfFrameBase)
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
    procedure LoadProductBill;
    procedure LoadProductBillDone;
    //产品列表
    procedure OnBtnClick(Sender: TObject);
    procedure OnBtnClick2(Sender: TObject);
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
  UFormProductBillView, UFormProductBillSH, UFormProductBillDeal;

class function TfFrameProductBillYS.FrameID: integer;
begin
  Result := cFI_FrameBillYS;
end;

procedure TfFrameProductBillYS.OnCreateFrame;
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
    AddHeader('订单编号', 50);
    AddHeader('简要说明', 50);
    AddHeader('订货件数', 50);
    AddHeader('待收件数', 50);
    AddHeader('订货人', 50);
    AddHeader('订货时间', 50);
    AddHeader('操作', 50);
  end;

  with FPainter2 do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('订单编号', 50);
    AddHeader('简要说明', 50);
    AddHeader('订货件数', 50);
    AddHeader('订货人', 50);
    AddHeader('订货时间', 50);
    AddHeader('收货时间', 50);
    AddHeader('操作', 50);
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadDrawGridConfig(Name, GridBill, nIni);
    LoadDrawGridConfig(Name, GridDone, nIni);

    wPage.ActivePage := Sheet1;
    LoadProductBill;
  finally
    nIni.Free;
  end;
end;

procedure TfFrameProductBillYS.OnDestroyFrame;
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

procedure TfFrameProductBillYS.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 载入待验收订单
procedure TfFrameProductBillYS.LoadProductBill;
var nStr,nHint: string;
    nDS: TDataSet;
    nIdx,nInt: Integer;
    nBtn: TcxButton;
    nData: TGridDataArray;
begin
  nStr := 'Select dt.*,StyleName,ColorName,SizeName,O_Man,O_Date From $DT dt ' +
          ' Left Join $PT pt On pt.ProductID=dt.D_Product ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $OD od On od.O_ID=dt.D_Order ' +
          'Where O_TerminalId=''$ID'' And (O_Status=''$DL'' Or ' +
          ' O_Status=''$TD'') ' +
          'Order By D_Order DESC';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$DT', sTable_OrderDtl), MI('$PT', sTable_DL_Product),
          MI('$ST', sTable_DL_Style), MI('$SZ', sTable_DL_Size),
          MI('$CR', sTable_DL_Color), MI('$OD', sTable_Order),
          MI('$ID', gSysParam.FTerminalID), MI('$FH', sFlag_BillLock),
          MI('$DL', sFlag_BillDeliver), MI('$TD', sFlag_BillTakeDeliv)]);
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
        SetLength(nData, 9);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);
        nData[1].FText := FieldByName('D_Order').AsString;

        nStr := Format('%s_%s_%s', [FieldByName('StyleName').AsString,
                FieldByName('ColorName').AsString, FieldByName('SizeName').AsString]);
        nData[2].FText := nStr;

        nData[3].FText := FieldByName('D_Number').AsString;
        nData[4].FText := IntToStr(FieldByName('D_Number').AsInteger -
                          FieldByName('D_HasIn').AsInteger);
        //xxxxx

        nData[5].FText := FieldByName('O_Man').AsString;
        nData[6].FText := DateTime2Str(FieldByName('O_Date').AsDateTime);

        with nData[7] do
        begin
          FText := '';
          FAlign := taLeftJustify;
          FCtrls := TList.Create;

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

          nBtn := TcxButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Caption := '收货';
            Width := 35;
            Height := 18;

            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end;

          if FieldByName('D_HasIn').AsInteger > 0 then
          begin
            nBtn := TcxButton.Create(Self);
            FCtrls.Add(nBtn);

            with nBtn do
            begin
              Caption := '明细';
              Width := 35;
              Height := 18;

              OnClick := OnBtnClick;
              Tag := FPainter.DataCount;
            end;
          end;
        end;

        nData[8].FText := FieldByName('R_ID').AsString;
        FPainter.AddData(nData);
        Next;
      end;
    end;

    FDoneLoaded := False;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 载入已完成订单
procedure TfFrameProductBillYS.LoadProductBillDone;
var nStr,nHint: string;
    nDS: TDataSet;
    nIdx,nInt: Integer;
    nBtn: TcxButton;
    nData: TGridDataArray;
begin
  if FDoneLoaded then Exit;
  //重复载入判定

  nStr := 'Select Top 50 dt.*,StyleName,ColorName,SizeName,O_Man,O_Date From $DT dt ' +
          ' Left Join $PT pt On pt.ProductID=dt.D_Product ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $OD od On od.O_ID=dt.D_Order ' +
          'Where O_TerminalId=''$ID'' And O_Status=''$OK'' ' +
          'Order By D_Order DESC';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$DT', sTable_OrderDtl), MI('$PT', sTable_DL_Product),
          MI('$ST', sTable_DL_Style), MI('$SZ', sTable_DL_Size),
          MI('$CR', sTable_DL_Color), MI('$OD', sTable_Order),
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
        SetLength(nData, 8);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);
        nData[1].FText := FieldByName('D_Order').AsString;

        nStr := Format('%s_%s_%s', [FieldByName('StyleName').AsString,
                FieldByName('ColorName').AsString, FieldByName('SizeName').AsString]);
        nData[2].FText := nStr;

        nData[3].FText := FieldByName('D_Number').AsString;
        nData[4].FText := IntToStr(FieldByName('D_Number').AsInteger -
                          FieldByName('D_HasIn').AsInteger);
        //xxxxx

        nData[4].FText := FieldByName('O_Man').AsString;
        nData[5].FText := DateTime2Str(FieldByName('O_Date').AsDateTime);
        nData[6].FText := DateTime2Str(FieldByName('D_InDate').AsDateTime);

        with nData[7] do
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
            
            OnClick := OnBtnClick2;
            Tag := FPainter2.DataCount;
          end;

          nBtn := TcxButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Caption := '明细';
            Width := 35;
            Height := 18;

            OnClick := OnBtnClick2;
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
procedure TfFrameProductBillYS.wPageChange(Sender: TObject);
begin
  if wPage.ActivePage = Sheet2 then LoadProductBillDone;
end;

//Desc: 按钮
procedure TfFrameProductBillYS.OnBtnClick(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  if Sender = FPainter.Data[nTag][7].FCtrls[0] then
  begin
    if ShowProductBillView(FPainter.Data[nTag][1].FText) then
    begin
      TcxButton(Sender).Enabled := False;
      LoadProductBill;
    end;
  end else //查看订单

  if Sender = FPainter.Data[nTag][7].FCtrls[1] then
  begin
    if ShowProductBillSH(FPainter.Data[nTag][1].FText,
       FPainter.Data[nTag][8].FText) then
    begin
      TcxButton(Sender).Enabled := False;
      LoadProductBill;
    end;
  end else //收货

  if Sender = FPainter.Data[nTag][7].FCtrls[2] then
  begin
    ShowProductBillDealView(FPainter.Data[nTag][1].FText);
  end; //收货明细
end;

//Desc: 完成列表按钮
procedure TfFrameProductBillYS.OnBtnClick2(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  if Sender = FPainter2.Data[nTag][7].FCtrls[0] then
  begin
    ShowProductBillView(FPainter2.Data[nTag][1].FText, False);
  end else //查看订单

  if Sender = FPainter2.Data[nTag][7].FCtrls[1] then
  begin
    ShowProductBillDealView(FPainter2.Data[nTag][1].FText);
  end; //收货明细
end;

initialization
  gControlManager.RegCtrl(TfFrameProductBillYS, TfFrameProductBillYS.FrameID);
end.
