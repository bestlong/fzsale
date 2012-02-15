{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 商品销售确认
*******************************************************************************}
unit UFormProductConfirm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UGridPainter, UFrameProductSale, Grids,
  UGridExPainter, StdCtrls, ExtCtrls, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxButtons, UImageButton, cxControls,
  cxContainer, cxEdit, cxTextEdit;

type
  TfFormProductConfirm = class(TSkinFormBase)
    LabelHint: TLabel;
    Panel1: TPanel;
    BtnOK: TImageButton;
    BtnExit: TImageButton;
    Label1: TLabel;
    Label2: TLabel;
    EditStyle: TcxTextEdit;
    Label3: TLabel;
    EditBrand: TcxTextEdit;
    Label4: TLabel;
    EditColor: TcxTextEdit;
    Label5: TLabel;
    EditSize: TcxTextEdit;
    Label6: TLabel;
    Label7: TLabel;
    EditOldPrice: TcxTextEdit;
    Label8: TLabel;
    EditPrice: TcxTextEdit;
    Label9: TLabel;
    EditNum: TcxTextEdit;
    EditXJ: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure EditNumPropertiesEditValueChanged(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditNumKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FProductInfo: PProductItem;
    //选中商品
    procedure LoadProductInfo;
    //商品信息
    function IsDataValid: Boolean;
    //验证数据
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowSaleProductConfirm(const nProduct: PProductItem): Boolean;
//选择商品

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule;

function ShowSaleProductConfirm(const nProduct: PProductItem): Boolean;
begin
  with TfFormProductConfirm.Create(Application) do
  begin
    FProductInfo := nProduct;
    LoadProductInfo;

    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductConfirm.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductConfirm.FormCreate(Sender: TObject);
var nIdx: Integer;
    nIni: TIniFile;
begin
  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self);
  finally
    nIni.Free;
  end;
end;

procedure TfFormProductConfirm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self);
  finally
    nIni.Free;
  end;
end;

procedure TfFormProductConfirm.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormProductConfirm.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 35 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 35;
end;

//------------------------------------------------------------------------------
//Desc: 显示商品信息
procedure TfFormProductConfirm.LoadProductInfo;
begin
  with FProductInfo^ do
  begin
    EditStyle.Text := FStyleName;
    EditBrand.Text := FBrandName;
    EditColor.Text := FColorName;
    EditSize.Text := FSizeName;

    if FloatRelation(FPriceSale, FPriceOld, rtGreater) or (FPriceOld <= 0) then
      FPriceOld := FPriceSale;
    //无折扣或涨价

    EditOldPrice.Text := Format('%.2f 元', [FPriceOld]);
    EditPrice.Text := Format('%.2f 元', [FPriceSale]);

    EditNum.Text := IntToStr(FNumSale);
    ActiveControl := EditNum;
  end;
end;

function TfFormProductConfirm.IsDataValid: Boolean;
var nStr: string;
begin
  Result := IsNumber(EditNum.Text, False) and (StrToInt(EditNum.Text) > 0);
  if not Result then
  begin
    ActiveControl := EditNum;
    ShowMsg('请填写有效的件数', sHint); Exit;
  end;

  Result := FProductInfo.FNumStore >= StrToInt(EditNum.Text);
  if not Result then
  begin
    ActiveControl := EditNum;
    nStr := Format('现有库存 %d 件', [FProductInfo.FNumStore]);
    ShowMsg(nStr, sHint);
  end;
end;

procedure TfFormProductConfirm.EditNumPropertiesEditValueChanged(
  Sender: TObject);
var nVal: Double;
begin
  if IsDataValid then
  begin
    nVal := FProductInfo.FPriceSale * StrToInt(EditNum.Text);
    EditXJ.Text := Format('￥%.2f元', [nVal]);
  end;
end;

procedure TfFormProductConfirm.EditNumKeyPress(Sender: TObject;
  var Key: Char);
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

//Desc: 确认
procedure TfFormProductConfirm.BtnOKClick(Sender: TObject);
begin
  if IsDataValid then
  begin
    FProductInfo.FNumSale := StrToInt(EditNum.Text);
    ModalResult := mrOk;
  end;
end;

end.
