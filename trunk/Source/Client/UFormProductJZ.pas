{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 商品销售结帐
*******************************************************************************}
unit UFormProductJZ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UFrameProductSale, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxListBox,
  cxTextEdit, ExtCtrls, UImageButton, StdCtrls;

type
  TfFormProductJZ = class(TSkinFormBase)
    LabelHint: TLabel;
    Panel1: TPanel;
    BtnOK: TImageButton;
    Label1: TLabel;
    EditYMoney: TcxTextEdit;
    EditMoney: TcxTextEdit;
    Label2: TLabel;
    EditJMoney: TcxTextEdit;
    Label3: TLabel;
    Label4: TLabel;
    EditZMoney: TcxTextEdit;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditMoneyKeyPress(Sender: TObject; var Key: Char);
    procedure EditMoneyPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FMember: PMemberInfo;
    //会员信息
    FProducts: TList;
    //商品信息
    FNumber: Integer;
    //销售件数
    FMoneyY,FMoneyS: Double;
    //金额大小
    procedure LoadProductJZ;
    //结算信息
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowProductJZ(const nProducts: TList; nMember: PMemberInfo): Boolean;
//销售结算
procedure PrintJZReport(const nSID: string);
//打印结算单

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, UDataModule, USysConst, USysDB, USysFun,
  UDataReport, FZSale_Intf;

function ShowProductJZ(const nProducts: TList; nMember: PMemberInfo): Boolean;
begin
  with TfFormProductJZ.Create(Application) do
  begin
    FMember := nMember;
    FProducts := nProducts;
    
    LoadProductJZ;
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductJZ.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductJZ.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx

  LoadFormConfig(Self);
end;

procedure TfFormProductJZ.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

procedure TfFormProductJZ.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormProductJZ.Panel1Resize(Sender: TObject);
begin
  BtnOk.Left := Trunc((Panel1.Width - BtnOK.Width) / 2);
end;

//Desc: 响应回车

procedure TfFormProductJZ.EditMoneyKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BtnOKClick(nil);
  end else

  if Key = Char(VK_ESCAPE) then
  begin
    Key := #0;
    Close;
  end;
end;

//Desc: 载入结算数据
procedure TfFormProductJZ.LoadProductJZ;
var nIdx: Integer;
begin
  FMoneyY := 0;
  FMoneyS := 0;
  FNumber := 0;

  for nIdx:=FProducts.Count - 1 downto 0 do
  with PProductItem(FProducts[nIdx])^ do
  begin
    FNumber := FNumber + FNumSale;
    FMoneyY := FMoneyY + Float2Float(FNumSale * FPriceSale, 100);
    FMoneyS := FMoneyS + Float2Float(FNumSale * FPriceMember, 100);
  end;

  EditYMoney.Text := Format('￥%.2f元', [FMoneyY]);
  EditJMoney.Text := Format('￥%.2f元', [FMoneyY - FMoneyS]);

  EditMoney.Text := FloatToStr(FMoneyS);
  EditMoney.SelectAll;

  EditZMoney.Text := '￥0.00元';
  ActiveControl := EditMoney;
  ReadMoney(gPath + sSoundDir, EditMoney.Text);
end;

//Desc: 计算找零
procedure TfFormProductJZ.EditMoneyPropertiesChange(Sender: TObject);
var nVal: Double;
begin
  if IsNumber(EditMoney.Text, True) and (StrToFloat(EditMoney.Text) > 0) then
  begin
    nVal := StrToFloat(EditMoney.Text);
    EditZMoney.Text := Format('￥%.2f元', [nVal - FMoneyS]);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 读取打印设置
procedure LoadPrinterSetup;
var nStr,nHint: string;
    nDS: TDataset;
    nParam: TReportParamItem;
begin
  nStr := 'Select D_Name,D_Value From %s ' +
          'Where D_Memo=''%s'' And (D_Name=''%s'' Or D_Name=''%s'')';
  nStr := Format(nStr, [sTable_SysDict, gSysParam.FTerminalID,
          sFlag_ReportTitle, sFlag_ReportEnding]);
  //xxxxx

  nParam.FName := sFlag_ReportTitle;
  nParam.FValue := '销售结算单';
  FDR.AddParamItem(nParam);

  nParam.FName := sFlag_ReportEnding;
  nParam.FValue := '';
  FDR.AddParamItem(nParam);

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if nDS.RecordCount > 0 then
    with nDS do
    begin
      First;

      while not Eof do
      begin
        nStr := FieldByName('D_Name').AsString;
        if CompareText(nStr, sFlag_ReportTitle) = 0 then
        begin
          nStr := FieldByName('D_Value').AsString;
          if nStr <> '' then
          begin
            nParam.FName := sFlag_ReportTitle;
            nParam.FValue := nStr;
            FDR.AddParamItem(nParam);
          end;
        end else

        if CompareText(nStr, sFlag_ReportEnding) = 0 then
        begin
          nStr := FieldByName('D_Value').AsString;
          if nStr <> '' then
          begin
            nParam.FName := sFlag_ReportEnding;
            nParam.FValue := nStr;
            FDR.AddParamItem(nParam);
          end;
        end;

        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc; 打印结算单
procedure PrintJZReport(const nSID: string);
var nStr,nHint: string;
    nDSA,nDSB: TDataset;
begin
  nStr := gPath + sReportDir + 'jz.fr3';
  if not FDR.LoadReportFile(nStr) then Exit;

  nDSA := nil;
  nDSB := nil;
  try
    nStr := 'Select * From $Sale ' +
            ' Left Join $Mem on M_ID=S_Member ' +
            'Where S_ID = ''$ID''';
    nStr := MacroValue(nStr, [MI('$Sale', sTable_Sale),
            MI('$Mem', sTable_Member), MI('$ID', nSID)]);
    //xxxxx

    nDSA := FDM.LockDataSet(nStr, nHint);
    if (not Assigned(nDSA)) or (nDSA.RecordCount < 1) then Exit;

    nStr := 'Select dtl.*,BrandName,StyleName,ColorName,SizeName From $DTL dtl ' +
            ' Left Join $DPT dpt On dpt.ProductID=dtl.D_Product ' +
            ' Left Join $ST st on st.StyleID=dpt.StyleID ' +
            ' Left Join $CR cr on cr.ColorID=dpt.ColorID ' +
            ' Left join $SZ sz On sz.SizeID=dpt.SizeID ' +
            ' Left join $BR br on br.BrandID=dpt.BrandID ' +
            'Where D_SaleID=''$ID'' Order By R_ID';
    nStr := MacroValue(nStr, [MI('$ID', nSID), MI('$DTL', sTable_SaleDtl),
            MI('$DPT', sTable_DL_Product), MI('$ST', sTable_DL_Style),
            MI('$CR', sTable_DL_Color), MI('$SZ', sTable_DL_Size),
            MI('$BR', sTable_DL_Brand)]);
    //xxxxx

    nDSB := FDM.LockDataSet(nStr, nHint);
    if (not Assigned(nDSB)) or (nDSB.RecordCount < 1) then Exit;
    LoadPrinterSetup;

    FDR.Dataset1.DataSet := nDSA;
    FDR.Dataset2.DataSet := nDSB;
    FDR.PrintReport;
  finally
    FDM.ReleaseDataSet(nDSA);
    FDM.ReleaseDataSet(nDSB);
  end;
end;

//Desc: 结帐单
procedure PrintJZ;
var nStr,nHint: string;
    nDS: TDataset;
begin
  nStr := 'Select Top 1 S_ID From %s ' +
          'Where S_TerminalId=''%s'' Order By R_ID DESC';
  nStr := Format(nStr, [sTable_Sale, gSysParam.FTerminalID]);

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if Assigned(nDS) and (nDS.RecordCount > 0) then
         nStr := nDS.Fields[0].AsString
    else Exit;
  finally
    FDM.ReleaseDataSet(nDS);
  end;

  PrintJZReport(nStr);
end;

//Desc: 合并相同商品
procedure CombinProduct(const nProduct,nList: TList);
var i,nIdx: Integer;
    nBool: Boolean;
    nItem,nTmp: PProductItem;
begin
  for i:=nProduct.Count - 1 downto 0 do
  begin
    nBool := False;
    nTmp := nProduct[i];

    for nIdx:=nList.Count - 1 downto 0 do
     with PProductItem(nList[nIdx])^ do
      if FProductID = nTmp.FProductID then
      begin
        FNumSale := FNumSale + nTmp.FNumSale;
        nBool := True;
        Break;
      end;
    //combin

    if not nBool then
    begin
      New(nItem);
      nList.Add(nItem);
      nItem^ := nTmp^;
    end;
  end;
end;

//Desc: 结帐
procedure TfFormProductJZ.BtnOKClick(Sender: TObject);
var nStr,nHint: string;
    nIdx: Integer;
    nVal: Double;
    nList: TList;
    nSQLList: SQLItems;
begin
  if (not IsNumber(EditMoney.Text, True)) and (StrToFloat(EditMoney.Text) < 0) then
  begin
    EditMoney.SelectAll;
    EditMoney.SetFocus;
    ShowMsg('请输入有效金额', sHint); Exit;
  end;

  if StrToFloat(EditMoney.Text) < FMoneyS then
  begin
    EditMoney.SelectAll;
    EditMoney.SetFocus;
    ShowMsg('请缴纳足够的金额', sHint); Exit;
  end;

  nList := nil;
  nSQLList := SQLItems.Create;
  try
    nStr := MakeSQLByStr([SF('R_Sync', sFlag_SyncW),
            SF('S_TerminalId', gSysParam.FTerminalID),
            SF('S_Number', IntToStr(FNumber), sfVal),
            SF('S_Money', FloatToStr(FMoneyS), sfVal),
            SF('S_Member', FMember.FID),
            SF('S_Deduct', FloatToStr(FMember.FZheKou), sfVal),
            SF('S_DeMoney', Format('%.2f', [FMoneyY - FMoneyS]), sfVal),
            SF('S_Man', gSysParam.FUserID),
            SF('S_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Sale, '', True);
    //xxxxx

    with nSQLList.Add do
    begin
      SQL := nStr;
      IfRun := '';
      IfType := 0;
    end;

    for nIdx:=0 to FProducts.Count - 1 do
    with PProductItem(FProducts[nIdx])^ do
    begin
      if FNumSale < 1 then Continue;
      //不予销售

      if FMember.FZheKou < 10 then
      begin
        nVal := Float2Float(FNumSale * FPriceSale, 100);
        nVal := nVal -  Float2Float(FNumSale * FPriceMember, 100);
      end else nVal := 0;

      nStr := MakeSQLByStr([SF('R_Sync', sFlag_SyncW),
              SF('D_Product', FProductID),
              SF('D_Number', IntToStr(FNumSale), sfVal),
              SF('D_Price', FloatToStr(FPriceMember), sfVal),
              SF('D_Member', FMember.FID),
              SF('D_Deduct', FloatToStr(FMember.FZheKou), sfVal),
              SF('D_DeMoney', Format('%.2f', [nVal]), sfVal)
              ], sTable_SaleDtl, '', True);
      //xxxxx

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end;

      nStr := 'Update %s Set P_Number=P_Number-%d ' +
              'Where P_ID=''%s'' And P_TerminalId=''%s''';
      nStr := Format(nStr, [sTable_Product, FNumSale, FProductID,
              gSysParam.FTerminalID]);
      //xxxxx

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end;
    end;

    nStr := 'Update %s Set D_SaleID=(Select Top 1 S_ID From %s ' +
            'Order By R_ID DESC) Where D_SaleID Is Null';
    nStr := Format(nStr, [sTable_SaleDtl, sTable_Sale]);
    
    with nSQLList.Add do
    begin
      SQL := nStr;
      IfRun := '';
      IfType := 0;
    end;

    if FMember.FID <> '' then
    begin
      nStr := 'Update %s Set M_BuyTime=M_BuyTime+1,M_BuyMoney=M_BuyMoney+%.2f, ' +
              'M_DeMoney=M_DeMoney+%.2f Where M_ID=''%s''';
      nStr := Format(nStr, [sTable_Member, FMoneyS, FMoneyY - FMoneyS,
              FMember.FID]);
      //xxxxx

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end;
    end;

    //--------------------------------------------------------------------------
    nList := TList.Create;
    CombinProduct(FProducts, nList);

    for nIdx:=0 to nList.Count - 1 do
    with PProductItem(nList[nIdx])^ do
    begin
      if FNumSale < 1 then Continue;
      //不予销售

      nStr := MakeSQLByStr([SF('ProductId', FProductID),
              SF('TerminalId', gSysParam.FTerminalID),
              SF('SaleCount', IntToStr(FNumSale), sfVal),
              SF('PurchPrice', FloatToStr(FPriceIn), sfVal),
              SF('SalePrice', FloatToStr(FPriceMember), sfVal),
              SF('CreateTime', sField_SQLServer_Now, sfVal)
              ], sTable_DL_TermSale, '', True);
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
      PrintJZ;
      ShowMsg('结帐成功', sHint);
      ModalResult := mrOk;
    end else ShowDlg(nHint, sWarn, Handle);
  finally    
    if Assigned(nList) then
      ClearProductList(nList, True);
    //nSQLList.Free;
  end;
end;

end.
