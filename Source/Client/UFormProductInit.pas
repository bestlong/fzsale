unit UFormProductInit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, StdCtrls,
  UImageButton, Grids, UGridExPainter, cxCheckBox;

type
  TfFormProductInit = class(TSkinFormBase)
    Label2: TLabel;
    GridList: TDrawGridEx;
    Panel1: TPanel;
    BtnOK: TImageButton;
    BtnExit: TImageButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridExPainter;
    //绘制对象
    FInSame,FSaleSame: Boolean;
    //标志
    procedure LoadProductList(const nStyleID: string);
    //商品信息
    procedure OnCheckClick(Sender: TObject);
    //复选
    procedure OnEditExit(Sender: TObject);
    //数据生效
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowProductInitForm(const nStyleID: string): Boolean;
//添加账户

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule, FZSale_Intf;

function ShowProductInitForm(const nStyleID: string): Boolean;
begin
  with TfFormProductInit.Create(Application) do
  begin
    LoadProductList(nStyleID);
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductInit.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductInit.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  FInSame := False;
  FSaleSame := False;

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
    AddHeader('进货价', 50);
    AddHeader('零售价', 50);
  end;

  LoadFormConfig(Self);
  LoadDrawGridConfig(Name, GridList);
end;

procedure TfFormProductInit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
end;

procedure TfFormProductInit.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormProductInit.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 65 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 65;
end;

//------------------------------------------------------------------------------
//Desc: 载入执行产品信息
procedure TfFormProductInit.LoadProductList(const nStyleID: string);
var nStr,nHint: string;
    nInt,nNum: Integer;
    nDS: TDataSet;
    nLabel: TLabel;
    nCheck: TcxCheckBox;
    nEdit: TcxTextEdit;
    nRow: TGridExDataArray;
    nCol: TGridExColDataArray;
begin
  nStr := 'Select pt.*,P_Number From (' +
          ' Select ProductID,StyleName,pt.SizeID,SizeName,pt.ColorID,ColorName From $PT pt' +
          '  Left Join $ST st On st.StyleID=pt.StyleID' +
          '  Left Join $CR cr On cr.ColorID=pt.ColorID' +
          '  Left Join $SZ sz On sz.SizeID=pt.SizeID' +
          ' Where pt.StyleID=''$ID'' And pt.BrandId In (' +
          '  Select tr.BrandID From $TR tr Where TerminalID=''$TID'')' +
          ') pt Left Join $TPT On P_ID=ProductID and ' +
          '  P_Size=SizeID and P_Color=ColorID ' +
          'Order By ColorName,SizeName';
  //xxxxx
  
  nStr := MacroValue(nStr, [MI('$PT', sTable_DL_Product), MI('$ST', sTable_DL_Style),
          MI('$CR', sTable_DL_Color), MI('$SZ', sTable_DL_Size),
          MI('$TPT', sTable_Product), MI('$ID', nStyleID),
          MI('$TR', sTable_Terminal), MI('$TID', gSysParam.FTerminalID)]);
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
      SetLength(nRow, 4);
      for nInt:=0 to 1 do
      with nRow[nInt] do
      begin
        FText := '';
        FCtrls := nil;
      end;

      for nInt:=2 to 3 do
      with nRow[nInt] do
      begin
        FText := '';
        FAlign := taCenter;
        FCtrls := TList.Create;

        nLabel := TLabel.Create(Self);
        nLabel.Transparent := True;
        nLabel.Caption := '相同';
        FCtrls.Add(nLabel);

        nCheck := TcxCheckBox.Create(Self);
        FCtrls.Add(nCheck);

        with nCheck do
        begin
          Width := 22;
          Height := 22;

          Tag := nInt;
          Transparent := True;
          OnClick := OnCheckClick;
        end;
      end;

      FPainter.AddRowData(nRow);
      //添加首行控制

      //------------------------------------------------------------------------------

      SetLength(nCol, 1);
      with nCol[0] do
      begin
        FCol := 0;
        FRows := RecordCount + 1;
        FAlign := taCenter;
        FText := FieldByName('StyleName').AsString;
      end;
      FPainter.AddColData(nCol);

      nHint := '';
      nNum := 1;
      First;

      while not Eof do
      begin
        SetLength(nRow, 7);
        for nInt:=Low(nRow) to High(nRow) do
        begin
          nRow[nInt].FText := '';
          nRow[nInt].FCtrls := nil;
          nRow[nInt].FAlign := taCenter;
        end;

        nRow[0].FText := FieldByName('SizeName').AsString;
        with nRow[1] do
        begin
          FCtrls := TList.Create;
          nEdit := TcxTextEdit.Create(Self);
          FCtrls.Add(nEdit);

          with nEdit do
          begin
            Text := IntToStr(FieldByName('P_Number').AsInteger);
            Width := 42;
            Height := 18;

            Tag := 1;
            OnExit := OnEditExit;
          end;

          nLabel := TLabel.Create(Self);
          nLabel.Transparent := True;
          nLabel.Caption := '件';
          FCtrls.Add(nLabel);
        end;

        for nInt:=2 to 3 do
        with nRow[nInt] do
        begin
          FText := '';
          FAlign := taCenter;
          FCtrls := TList.Create;

          nLabel := TLabel.Create(Self);
          nLabel.Transparent := True;
          nLabel.Caption := '￥';
          FCtrls.Add(nLabel);

          nEdit := TcxTextEdit.Create(Self);
          FCtrls.Add(nEdit);

          with nEdit do
          begin
            Text := '0';
            Width := 52;
            Height := 18;

            Tag := nInt;
            OnExit := OnEditExit;
          end;

          nLabel := TLabel.Create(Self);
          nLabel.Transparent := True;
          nLabel.Caption := '元';
          FCtrls.Add(nLabel);
        end;

        nRow[4].FText := FieldByName('ColorID').AsString;
        nRow[5].FText := FieldByName('SizeID').AsString;
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

//Desc: 复选
procedure TfFormProductInit.OnCheckClick(Sender: TObject);
begin
  with TcxCheckBox(Sender) do
  begin
    if Tag = 2 then FInSame := Checked;
    if Tag = 3 then FSaleSame := Checked;
  end;
end;

//Desc: 焦点退出,内容生效
procedure TfFormProductInit.OnEditExit(Sender: TObject);
var nStr: string;
    nIdx,nTag: Integer;
    nEdit: TcxTextEdit;
begin
  with TcxTextEdit(Sender) do
  begin
    if (not IsNumber(Text, True)) or (StrToFloat(Text) < 0) then
    begin
      SetFocus;
      ShowMsg('请填写有效单价', sHint); Exit;
    end;

    nTag := TcxTextEdit(Sender).Tag;
    nStr := Format('%.2f', [StrToFloat(Text)]);
    
    if ((nTag = 2) and FInSame) or ((nTag = 3) and FSaleSame) then
    begin
      for nIdx:=1 to FPainter.DataCount - 1 do
      begin
        case nTag of
         2: nEdit := TcxTextEdit(FPainter.Data[nIdx][2].FCtrls[1]);
         3: nEdit := TcxTextEdit(FPainter.Data[nIdx][3].FCtrls[1])
         else nEdit := nil;
        end;

        if Assigned(nEdit) then
          nEdit.Text := nStr;
        //xxxxx
      end;
    end;
  end;
end;

//Desc: 保存
procedure TfFormProductInit.BtnOKClick(Sender: TObject);
var nStr, nHint: string;
    nIdx: Integer;
    nSQLList: SQLItems;
begin
  ActiveControl := nil;
  if Assigned(ActiveControl) then Exit;

  nSQLList := SQLItems.Create;
  try
    for nIdx:=1 to FPainter.DataCount - 1 do
    begin
      nStr := MakeSQLByStr([SF('R_Sync', sFlag_SyncW),
         SF('P_Color', FPainter.Data[nIdx][4].FText),
         SF('P_Size', FPainter.Data[nIdx][5].FText),
         SF('P_ID', FPainter.Data[nIdx][6].FText),
         SF('P_Number', TcxTextEdit(FPainter.Data[nIdx][1].FCtrls[0]).Text, sfVal),
         SF('P_Price', TcxTextEdit(FPainter.Data[nIdx][3].FCtrls[1]).Text),
         SF('P_InPrice', TcxTextEdit(FPainter.Data[nIdx][2].FCtrls[1]).Text),
         SF('P_TerminalId', gSysParam.FTerminalID),
         SF('P_LastIn', sField_SQLServer_Now, sfVal)], sTable_Product, '', True);
      //insert sql

      nHint := 'Select R_ID From $PT Where P_TerminalId=''$TER'' And ' +
               'P_ID=''$ID'' And P_Size=''$SZ'' And P_Color=''$CR''';
      nHint := MacroValue(nHint, [MI('$PT', sTable_Product),
               MI('$TER', gSysParam.FTerminalID),
               MI('$CR', FPainter.Data[nIdx][4].FText),
               MI('$SZ', FPainter.Data[nIdx][5].FText),
               MI('$ID', FPainter.Data[nIdx][6].FText)]);
      //where

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := nHint;
        IfType := 1; //记录不存在则执行
      end;
    end;

    if FDM.SQLUpdates(nSQLList, True, nHint) > -1 then
    begin
      ShowMsg('保存成功', sHint);
      ModalResult := mrOk;
    end else ShowDlg(nHint, sWarn);
  finally
    //nSQLList.Free;
  end;
end;

end.
