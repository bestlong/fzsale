{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 商品订单收货
*******************************************************************************}
unit UFormProductBillSH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UGridPainter, ExtCtrls, UImageButton, Grids,
  UGridExPainter, StdCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, cxButtons;

type
  TfFormProductBillSH = class(TSkinFormBase)
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
    FPainter: TGridPainter;
    //绘制对象
    FNumAll,FNumHas: Double;
    //订单状态
    procedure LoadOrderDetail(const nOrderID,nDetailID: string);
    //商品信息
    procedure OnValueChanged(Sender: TObject);
    //件数变动
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowProductBillSH(const nOrderID: string;
  const nDetailID: string = ''): Boolean;
//收货

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule, FZSale_Intf;

function ShowProductBillSH(const nOrderID,nDetailID: string): Boolean;
begin
  with TfFormProductBillSH.Create(Application) do
  begin
    LoadOrderDetail(nOrderID, nDetailID);
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductBillSH.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductBillSH.FormCreate(Sender: TObject);
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
    AddHeader('订货量', 50);
    AddHeader('实收件数', 50);
    AddHeader('缺货件数', 50);
  end;

  LoadFormConfig(Self);
  LoadDrawGridConfig(Name, GridList);
end;

procedure TfFormProductBillSH.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
end;

procedure TfFormProductBillSH.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormProductBillSH.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 65 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 65;
end;

//------------------------------------------------------------------------------
//Desc: 载入订单明细
procedure TfFormProductBillSH.LoadOrderDetail(const nOrderID,nDetailID: string);
var nStr,nHint: string;
    nIdx,nInt: Integer;
    nDS: TDataSet;
    nEdit: TcxTextEdit;
    nData: TGridDataArray;
begin
  nStr := 'Select dt.*,br.BrandName,StyleName,ColorName,SizeName,' +
          'O_Number,O_DoneNum,O_Man,O_Date,' +
          '(TerminalPrice * JHZK / 10) as D_PriceIn From $Ter ter,$DT dt ' +
          ' Left Join $PT pt On pt.ProductID=dt.D_Product ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $OD od On od.O_ID=dt.D_Order ' +
          ' Left Join $BR br On br.BrandID=pt.BrandID ' +
          'Where $WH And (ter.TerminalID=''$TID'') ' +
          'Order By StyleName,ColorName,SizeName';
  //xxxxx

  if nDetailID = '' then
       nStr := MacroValue(nStr, [MI('$WH', Format('D_Order=''%s''', [nOrderID]))])
  else nStr := MacroValue(nStr, [MI('$WH', Format('dt.R_ID=''%s''', [nDetailID]))]);

  nStr := MacroValue(nStr, [MI('$DT', sTable_OrderDtl),
          MI('$Ter', sTable_Terminal), MI('$TID', gSysParam.FTerminalID),
          MI('$ST', sTable_DL_Style), MI('$SZ', sTable_DL_Size),
          MI('$CR', sTable_DL_Color), MI('$OD', sTable_Order),
          MI('$BR', sTable_DL_Brand), MI('$PT', sTable_DL_Product)]);
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

      FNumAll := FieldByName('O_Number').AsInteger;
      FNumHas := FieldByName('O_DoneNum').AsInteger;

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
        nData[3].FText := FieldByName('D_Number').AsString;

        with nData[4] do
        begin
          FText := '';
          FCtrls := TList.Create;

          nEdit := TcxTextEdit.Create(Self);
          FCtrls.Add(nEdit);

          with nEdit do
          begin
            Width := 45;
            Height := 18;
            Text := IntToStr(FieldByName('D_Number').AsInteger -
                             FieldByName('D_HasIn').AsInteger);
            nData[6].FText := Text;

            Tag := FPainter.DataCount;
            Properties.OnEditValueChanged := OnValueChanged;
          end;
        end;

        with nData[5] do
        begin
          FText := '';
          FCtrls := TList.Create;

          nEdit := TcxTextEdit.Create(Self);
          FCtrls.Add(nEdit);

          with nEdit do
          begin
            Width := 45;
            Height := 18;
            Text := '0';

            Tag := FPainter.DataCount;
            Properties.OnEditValueChanged := OnValueChanged;
          end;
        end;

        nData[7].FText := Format('%.2f', [FieldByName('D_PriceIn').AsFloat]);
        nData[8].FText := FieldByName('D_Product').AsString;
        FPainter.AddData(nData);
        Next;
      end;
    end; 
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 件数变动
procedure TfFormProductBillSH.OnValueChanged(Sender: TObject);
var nTag,nInt: Integer;
    nEdit: TcxTextEdit;
begin
  nEdit := TcxTextEdit(Sender);
  nTag :=  nEdit.Tag;

  if nEdit = FPainter.Data[nTag][4].FCtrls[0] then
  begin
    if (not IsNumber(nEdit.Text, False)) or (StrToInt(nEdit.Text) < 0) then
    begin
      ActiveControl := nEdit;
      ShowMsg('请输入有效的件数', sHint); Exit;
    end;

    nInt := StrToInt(FPainter.Data[nTag][3].FText) - StrToInt(nEdit.Text);
    if nInt < 0 then nInt := 0;
    TcxTextEdit(FPainter.Data[nTag][5].FCtrls[0]).Text := IntToStr(nInt);
  end else //实收

  if nEdit = FPainter.Data[nTag][5].FCtrls[0] then
  begin
    if (not IsNumber(nEdit.Text, False)) or (StrToInt(nEdit.Text) < 0) then
    begin
      ActiveControl := nEdit;
      ShowMsg('请输入有效的件数', sHint); Exit;
    end;

    nInt := StrToInt(FPainter.Data[nTag][3].FText) - StrToInt(nEdit.Text);
    if nInt < 0 then nInt := 0;
    TcxTextEdit(FPainter.Data[nTag][4].FCtrls[0]).Text := IntToStr(nInt);
  end; //缺货
end;

//Desc: 收货
procedure TfFormProductBillSH.BtnOKClick(Sender: TObject);
var nStr, nHint: string;
    nIdx,nNum,nAll: Integer;
    nSQLList: SQLItems;
begin
  ActiveControl := nil;
  nSQLList := SQLItems.Create;
  try
    nNum := 0;
    nAll := 0;

    for nIdx:=0 to FPainter.DataCount - 1 do
    begin
      nStr := TcxTextEdit(FPainter.Data[nIdx][4].FCtrls[0]).Text;
      if IsNumber(nStr, False) and (StrToInt(nStr) > 0) then
        nNum := nNum + StrToInt(nStr);
      nAll := nAll + StrToInt(FPainter.Data[nIdx][6].FText);
    end;

    if nNum < 1 then
    begin
      ShowMsg('实收总件数为零', sHint);
      Exit;
    end;

    if nNum > nAll then
    begin
      nStr := '实收总件数已超过应收总件数,明细如下:' + #13#10#13#10 +
              '*.应收: %d 件' + #13#10 +
              '*.实收: %d 件' + #13#10 +
              '*.超出: %d 件' + ',要继续吗?';
      nStr := Format(nStr, [nAll, nNum, nNum - nAll]);
      if not QueryDlg(nStr, sAsk) then Exit;
    end;

    if (nNum + FNumHas) >= FNumAll then
    begin
      nStr := 'Update %s Set ActualCount=ActualCount+%d,OrderState=3,' +
              'EndTime=%s Where TerminalId=''%s'' And Lid=''%s''';
      nStr := Format(nStr, [sTable_DL_Order, nNum, sField_SQLServer_Now,
              gSysParam.FTerminalID, EditID.Text]);
      //xxxxx
    end else
    begin
      nStr := 'Update %s Set ActualCount=IsNull(ActualCount,0)+%d,OrderState=2 ' +
              'Where TerminalId=''%s'' And Lid=''%s''';
      nStr := Format(nStr, [sTable_DL_Order, nNum, gSysParam.FTerminalID, EditID.Text]);
    end;

    with nSQLList.Add do
    begin
      SQL := nStr;
      IfRun := '';
      IfType := 0;
    end; //更新代理商订单表

    //--------------------------------------------------------------------------
    if (nNum + FNumHas) >= FNumAll then
         nHint := sFlag_BillDone
    else nHint := sFlag_BillTakeDeliv;

    nStr := 'Update %s Set O_DoneNum=IsNull(O_DoneNum,0)+%d,O_Status=''%s'',' +
            'O_ActDate=%s Where O_TerminalId=''%s'' And O_ID=''%s''';
    nStr := Format(nStr, [sTable_Order, nNum, nHint, sField_SQLServer_Now,
            gSysParam.FTerminalID, EditID.Text]);
    //xxxxx
    
    with nSQLList.Add do
    begin
      SQL := nStr;
      IfRun := '';
      IfType := 0;
    end; //更新终端订单表

    for nIdx:=0 to FPainter.DataCount - 1 do
    begin
      nStr := TcxTextEdit(FPainter.Data[nIdx][4].FCtrls[0]).Text;
      if (not IsNumber(nStr, False)) or (StrToInt(nStr) <= 0) then Continue;

      nStr := MakeSQLByStr([SF('D_Order', EditID.Text),
            SF('D_Product', FPainter.Data[nIdx][8].FText),
            SF('D_Number', TcxTextEdit(FPainter.Data[nIdx][4].FCtrls[0]).Text, sfVal),
            SF('D_Price', FPainter.Data[nIdx][7].FText, sfVal),
            SF('D_Man', gSysParam.FUserID),
            SF('D_Date', sField_SQLServer_Now, sfVal)], sTable_OrderDeal, '', True);
      //xxxxx

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end; //收货明细

      nStr := 'Update $TB Set D_HasIn=IsNull(D_HasIn,0)+$Num,D_InDate=$DT ' +
              'Where D_Order=''$OD'' And D_Product=''$PT''';
      nStr := MacroValue(nStr, [MI('$TB', sTable_OrderDtl),
              MI('$Num', TcxTextEdit(FPainter.Data[nIdx][4].FCtrls[0]).Text),
              MI('$OD', EditID.Text), MI('$DT', sField_SQLServer_Now),
              MI('$PT', FPainter.Data[nIdx][8].FText)]);
      //xxxxx

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end; //订单明细

      nStr := 'Update $TB Set P_Number=IsNull(P_Number,0)+$Num,P_InPrice=$PR,' +
              'P_LastIn=$DT Where P_TerminalId=''$TD'' And P_ID=''$PT''';
      nStr := MacroValue(nStr, [MI('$TB', sTable_Product),
              MI('$Num', TcxTextEdit(FPainter.Data[nIdx][4].FCtrls[0]).Text),
              MI('$PR', FPainter.Data[nIdx][7].FText),
              MI('$DT', sField_SQLServer_Now),
              MI('$TD', gSysParam.FTerminalID),
              MI('$PT', FPainter.Data[nIdx][8].FText)]);
      //xxxxx

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end; //产品信息
    end;

    if FDM.SQLUpdates(nSQLList, True, nHint) > -1 then
    begin
      ModalResult := mrOk;
    end else ShowDlg(nHint, sWarn);

    nSQLList := nil;
  finally
    nSQLList.Free;
  end;
end;

end.
