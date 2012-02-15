{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 商品订单调整
*******************************************************************************}
unit UFormProductBillAdjust;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UGridPainter, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  StdCtrls, ExtCtrls, UImageButton, Grids, UGridExPainter;

type
  TfFormProductBillAdjust = class(TSkinFormBase)
    GridList: TDrawGridEx;
    Panel1: TPanel;
    BtnOK: TImageButton;
    BtnExit: TImageButton;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditID: TcxTextEdit;
    EditMan: TcxTextEdit;
    EditTime: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FOrderID: string;
    //订单号
    FPainter: TGridPainter;
    //绘制对象
    procedure LoadOrderDetail(const nOrderID: string);
    //商品信息
    procedure OnEditValueChanged(Sender: TObject);
    //数据生效
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowProductBillAdjust(const nOrderID: string): Boolean;
//添加账户

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule, FZSale_Intf;

function ShowProductBillAdjust(const nOrderID: string): Boolean;
begin
  with TfFormProductBillAdjust.Create(Application) do
  begin
    FOrderID := nOrderID;
    LoadOrderDetail(nOrderID);   

    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductBillAdjust.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductBillAdjust.FormCreate(Sender: TObject);
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
    AddHeader('品牌', 50);
    AddHeader('商品名称', 50);
    AddHeader('现有库存', 50);
    AddHeader('原订货量', 50);
    AddHeader('现调整为', 50);
  end;

  LoadFormConfig(Self);
  LoadDrawGridConfig(Name, GridList);
end;

procedure TfFormProductBillAdjust.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
end;

procedure TfFormProductBillAdjust.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormProductBillAdjust.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 65 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 65;
end;

//------------------------------------------------------------------------------
//Desc: 载入订单明细
procedure TfFormProductBillAdjust.LoadOrderDetail(const nOrderID: string);
var nStr,nHint: string;
    nIdx,nInt: Integer;
    nDS: TDataSet;
    nEdit: TcxTextEdit;
    nLabel: TLabel;
    nData: TGridDataArray;
begin
  nStr := 'Select dt.*,BrandName,StyleName,ColorName,SizeName,D_Number,' +
          'P_Number,TerminalPrice,O_Man,O_Date From $DT dt ' +
          ' Left Join $PT pt On pt.ProductID=dt.D_Product ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $OD od On od.O_ID=dt.D_Order ' +
          ' Left Join $BR br On br.BrandID=pt.BrandID ' +
          ' Left Join $DP dp on dp.P_ID=dt.D_Product ' +
          'Where D_Order=''$ID'' Order By StyleName,ColorName,SizeName';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$DT', sTable_OrderDtl), MI('$ID', nOrderID),
          MI('$ST', sTable_DL_Style), MI('$SZ', sTable_DL_Size),
          MI('$CR', sTable_DL_Color), MI('$OD', sTable_Order),
          MI('$BR', sTable_DL_Brand), MI('$PT', sTable_DL_Product),
          MI('$DP', sTable_Product)]);
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

      EditID.Text := nOrderID;
      EditMan.Text := FieldByName('O_Man').AsString;
      EditTime.Text := DateTime2Str(FieldByName('O_Date').AsDateTime);

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
        nData[1].FText := FieldByName('BrandName').AsString;

        nStr := Format('%s_%s_%s', [FieldByName('StyleName').AsString,
                FieldByName('ColorName').AsString, FieldByName('SizeName').AsString]);
        nData[2].FText := nStr;

        nData[3].FText := FieldByName('P_Number').AsString;
        nData[4].FText := FieldByName('D_Number').AsString;

        with nData[5] do
        begin
          FText := '';
          FCtrls := TList.Create;

          nEdit := TcxTextEdit.Create(Self);
          FCtrls.Add(nEdit);

          with nEdit do
          begin
            Width := 42;
            Height := 18;

            Text := nData[4].FText;
            Properties.OnEditValueChanged := OnEditValueChanged;
          end;

          nLabel := TLabel.Create(Self);
          nLabel.Transparent := True;
          nLabel.Caption := '件';
          FCtrls.Add(nLabel);
        end;

        nData[6].FText := FieldByName('D_Product').AsString;
        nData[7].FText := Format('%.2f', [FieldByName('TerminalPrice').AsFloat]);
        nData[8].FText := FieldByName('R_ID').AsString;
        FPainter.AddData(nData);
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 内容生效
procedure TfFormProductBillAdjust.OnEditValueChanged(Sender: TObject);
begin
  with TcxTextEdit(Sender) do
  begin
    if (not IsNumber(Text, False)) or (StrToInt(Text) < 0) then
    begin
      SetFocus;
      ShowMsg('请填写有效件数', sHint); Exit;
    end;
  end;
end;

//Desc: 保存
procedure TfFormProductBillAdjust.BtnOKClick(Sender: TObject);
var nStr,nHint: string;
    nIdx,nNum: Integer;
    nSQLList: SQLItems;
begin
  ActiveControl := nil;
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
      ShowMsg('订单件数为零', sHint); Exit;
    end;

    nStr := 'Update %s Set O_Number=%d Where O_ID=''%s''';
    nStr := Format(nStr, [sTable_Order, nNum, FOrderID]);

    with nSQLList.Add do
    begin
      SQL := nStr;
      IfRun := '';
      IfType := 0;
    end;

    for nIdx:=0 to FPainter.DataCount - 1 do
    begin
      nStr := TcxTextEdit(FPainter.Data[nIdx][5].FCtrls[0]).Text;
      if (not IsNumber(nStr, False)) or (StrToInt(nStr) < 0) then Continue;

      nNum := StrToInt(nStr);
      if nNum = StrToInt(FPainter.Data[nIdx][4].FText) then Continue;
      //下单量不变
      
      nStr := 'Update %s Set D_Number=%d,D_Price=%s Where R_ID=%s';
      nStr := Format(nStr, [sTable_OrderDtl, nNum, FPainter.Data[nIdx][7].FText,
              FPainter.Data[nIdx][8].FText]);
      //xxxxx

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end;

      nStr := MakeSQLByStr([SF('A_Order', FOrderID),
              SF('A_Product', FPainter.Data[nIdx][6].FText),
              SF('A_Number', FPainter.Data[nIdx][4].FText, sfVal),
              SF('A_NewNum', IntToStr(nNum), sfVal),
              SF('A_Man', gSysParam.FUserID),
              SF('A_Date', sField_SQLServer_Now, sfVal)
              ], sTable_OrderAdjust, '', True);
      //insert sql

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end;
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
