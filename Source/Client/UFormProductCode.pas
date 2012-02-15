{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 条码选择商品
*******************************************************************************}
unit UFormProductCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UFrameProductSale, ExtCtrls, UImageButton,
  StdCtrls, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxTextEdit;

type
  TfFormProductCode = class(TSkinFormBase)
    LabelHint: TLabel;
    Panel1: TPanel;
    BtnOK: TImageButton;
    BtnExit: TImageButton;
    Label1: TLabel;
    EditID: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditIDKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FList: TList;
    FProduct: PProductItem;
    //商品信息
    procedure GetProductItem;
    //获取选择
    function CheckBarCodeValid: Boolean;
    //条码验证
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowGetProductByCode(const nProduct: PProductItem): Boolean;
//按条码选择

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule,
  UFormProductFilterColor, UFormProductFilterSize;

function ShowGetProductByCode(const nProduct: PProductItem): Boolean;
begin
  with TfFormProductCode.Create(Application) do
  begin
    FProduct := nProduct;
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductCode.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductCode.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  FList := TList.Create;

  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx

  LoadFormConfig(Self);
end;

procedure TfFormProductCode.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ClearProductList(FList, True);
end;

procedure TfFormProductCode.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormProductCode.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 32 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 32;
end;

//Desc: 响应回车
procedure TfFormProductCode.EditIDKeyPress(Sender: TObject; var Key: Char);
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

//Desc: 获取第一个选中的商品
procedure TfFormProductCode.GetProductItem;
var nIdx: Integer;
    nItem: PProductItem;
begin
  for nIdx:=0 to FList.Count - 1 do
  begin
    nItem := FList[nIdx];
    if nItem.FSelected then
    begin
      FProduct^ := nItem^;
      Break;
    end;  
  end;
end;

//Desc: 只有一条选中时为True
function TfFormProductCode.CheckBarCodeValid: Boolean;
var nIdx: Integer;
    nList: TStrings;
begin
  if FList.Count = 1 then
  begin
    Result := True;
    GetProductItem; Exit;
  end;

  nList := TStringList.Create;
  try
    for nIdx:=FList.Count - 1 downto 0 do
     with PProductItem(FList[nIdx])^ do
      if FSelected then
        if nList.IndexOf(FColorName) < 0 then nList.Add(FColorName);
    //color

    Result := nList.Count < 2;
    if not Result then
    begin
      Visible := False;
      Result := ShowProductColorFilter(FList);
    end;

    if not Result then Exit;
    nList.Clear;

    for nIdx:=FList.Count - 1 downto 0 do
     with PProductItem(FList[nIdx])^ do
      if FSelected then
        if nList.IndexOf(FSizeName) < 0 then nList.Add(FSizeName);
    //size

    Result := nList.Count < 2;
    if not Result then
    begin
      Visible := False;
      Result := ShowProductSizeFilter(FList);
    end;

    if Result then GetProductItem;
    //选择生效
  finally
    nList.Free;
    Visible := True;
  end;
end;

//Desc: 获取商品信息
procedure TfFormProductCode.BtnOKClick(Sender: TObject);
var nStr,nHint: string;
    nDS: TDataSet;
    nItem: PProductItem;
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    EditID.SetFocus;
    ShowMsg('请输入有效的条码', sHint); Exit;
  end;

  nStr := 'Select pt.*,BrandName,StyleName,ColorName,SizeName From $PT pt ' +
          ' Left Join $DPT dpt On dpt.ProductID=pt.P_ID ' +
          ' Left Join $ST st On st.StyleID=dpt.StyleID ' +
          ' Left Join $SZ sz On sz.SizeID=dpt.SizeID ' +
          ' Left Join $CR cr On cr.ColorID=dpt.ColorID ' +
          ' Left Join $BR br On br.BrandID=dpt.BrandID ' +
          'Where dpt.BarCode = ''$Code'' ' +
          'Order By ColorName,SizeName';
  nStr := MacroValue(nStr, [MI('$PT', sTable_Product),
          MI('$DPT', sTable_DL_Product), MI('$ST', sTable_DL_Style),
          MI('$SZ', sTable_DL_Size), MI('$CR', sTable_DL_Color),
          MI('$BR', sTable_DL_Brand), MI('$Code', EditID.Text)]);
  //xxxxx

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    if nDS.RecordCount < 1 then
    begin
      EditID.SelectAll;
      ShowMsg('未找到该条码的商品', sHint); Exit;
    end;

    ClearProductList(FList, False);
    //xxxxx

    with nDS do
    begin
      First;

      while not Eof do
      begin
        New(nItem);
        FList.Add(nItem);

        with nItem^ do
        begin
          FProductID := FieldByName('P_ID').AsString;
          FBrandName := FieldByName('BrandName').AsString;
          FStyleName := FieldByName('StyleName').AsString;
          FColorName := FieldByName('ColorName').AsString;
          FSizeName := FieldByName('SizeName').AsString;

          FNumSale := 1;
          FNumStore := FieldByName('P_Number').AsInteger;
          FPriceSale := FieldByName('P_Price').AsFloat;  
          FPriceOld := FieldByName('P_OldPrice').AsFloat;
          FPriceIn := FieldByName('P_InPrice').AsFloat;
          FSelected := True;
        end;

        Next;
      end;
    end;  
  finally
    FDM.ReleaseDataSet(nDS);
  end;

  if CheckBarCodeValid then
       ModalResult := mrOk
  else ModalResult := mrCancel;
end;

end.
