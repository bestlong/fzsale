{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 颜色选择商品
*******************************************************************************}
unit UFormProductFilterColor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UFrameProductSale, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  ExtCtrls, UImageButton, StdCtrls, cxMCListBox, Grids, UGridExPainter,
  cxListBox;

type
  TfFormProductFilterColor = class(TSkinFormBase)
    LabelHint: TLabel;
    Panel1: TPanel;
    BtnOK: TImageButton;
    BtnExit: TImageButton;
    Label1: TLabel;
    EditName: TcxTextEdit;
    ListColor: TcxListBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure ListColorDblClick(Sender: TObject);
    procedure ListColorKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FProducts: TList;
    //商品信息
    procedure LoadProductColors;
    //读取颜色
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowProductColorFilter(const nProducts: TList): Boolean;
//按颜色选择

implementation

{$R *.dfm}

uses
  ULibFun, USysConst, USysFun;

function ShowProductColorFilter(const nProducts: TList): Boolean;
begin
  with TfFormProductFilterColor.Create(Application) do
  begin
    FProducts := nProducts;
    LoadProductColors;
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductFilterColor.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductFilterColor.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx

  LoadFormConfig(Self);
end;

procedure TfFormProductFilterColor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

procedure TfFormProductFilterColor.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormProductFilterColor.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 32 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 32;
end;

//Desc: 响应回车
procedure TfFormProductFilterColor.ListColorKeyPress(Sender: TObject;
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

//Desc: 响应鼠标
procedure TfFormProductFilterColor.ListColorDblClick(Sender: TObject);
begin
  BtnOKClick(nil);
end;

//Desc: 载入颜色列表
procedure TfFormProductFilterColor.LoadProductColors;
var nStr: string;
    nList: TStrings;
    nIdx,nInt: Integer;
begin
  nInt := 1;
  nList := TStringList.Create;
  try
    for nIdx:=0 to FProducts.Count - 1 do
     with PProductItem(FProducts[nIdx])^ do
      if FSelected and (nList.IndexOf(FColorName) < 0) then
      begin
        nList.Add(FColorName);
        nStr := Format('%d.  %s', [nInt, FColorName]);

        Inc(nInt);
        ListColor.Items.AddObject(nStr, Pointer(nIdx));
      end;
  finally
    nList.Free;
  end;

  ListColor.ItemIndex := 0;
  ActiveControl := ListColor;
  EditName.Text := PProductItem(FProducts[0]).FStyleName;
end;

//Desc: 颜色筛选
procedure TfFormProductFilterColor.BtnOKClick(Sender: TObject);
var nStr: string;
    nIdx: Integer;
begin
  nIdx := Integer(ListColor.Items.Objects[ListColor.ItemIndex]);
  nStr := PProductItem(FProducts[nIdx]).FColorName;

  for nIdx:=FProducts.Count - 1 downto 0 do
   with PProductItem(FProducts[nIdx])^ do
    FSelected := CompareText(FColorName, nStr) = 0;
  ModalResult := mrOk;
end;

end.
