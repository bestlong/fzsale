{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 尺码选择商品
*******************************************************************************}
unit UFormProductFilterSize;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UFrameProductSale, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  ExtCtrls, UImageButton, StdCtrls, cxMCListBox, Grids, UGridExPainter,
  cxListBox;

type
  TfFormProductFilterSize = class(TSkinFormBase)
    LabelHint: TLabel;
    Panel1: TPanel;
    BtnOK: TImageButton;
    BtnExit: TImageButton;
    Label1: TLabel;
    EditName: TcxTextEdit;
    ListSize: TcxListBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure ListSizeDblClick(Sender: TObject);
    procedure ListSizeKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FProducts: TList;
    //商品信息
    procedure LoadProductSize;
    //读取大小
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowProductSizeFilter(const nProducts: TList): Boolean;
//按尺码选择

implementation

{$R *.dfm}

uses
  ULibFun, USysConst, USysFun;

function ShowProductSizeFilter(const nProducts: TList): Boolean;
begin
  with TfFormProductFilterSize.Create(Application) do
  begin
    FProducts := nProducts;
    LoadProductSize;
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductFilterSize.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductFilterSize.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx

  LoadFormConfig(Self);
end;

procedure TfFormProductFilterSize.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

procedure TfFormProductFilterSize.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormProductFilterSize.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 32 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 32;
end;

//Desc: 响应回车
procedure TfFormProductFilterSize.ListSizeKeyPress(Sender: TObject;
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
procedure TfFormProductFilterSize.ListSizeDblClick(Sender: TObject);
begin
  BtnOKClick(nil);
end;

//Desc: 载入尺码列表
procedure TfFormProductFilterSize.LoadProductSize;
var nStr: string;
    nList: TStrings;
    nIdx,nInt: Integer;
begin
  EditName.Clear;
  nInt := 1;
  nList := TStringList.Create;
  try
    for nIdx:=0 to FProducts.Count - 1 do
     with PProductItem(FProducts[nIdx])^ do
      if FSelected and (nList.IndexOf(FSizeName) < 0) then
      begin
        nList.Add(FSizeName);
        nStr := Format('%d.  %s', [nInt, FSizeName]);

        Inc(nInt);
        ListSize.Items.AddObject(nStr, Pointer(nIdx));

        if EditName.Text = '' then
        begin
          nStr := Format('%s(%s)', [FStyleName, FColorName]);
          EditName.Text := nStr;
        end;
      end;
  finally
    nList.Free;
  end;

  ListSize.ItemIndex := 0;
  ActiveControl := ListSize;
end;

//Desc: 尺码筛选
procedure TfFormProductFilterSize.BtnOKClick(Sender: TObject);
var nStr: string;
    nIdx: Integer;
begin
  nIdx := Integer(ListSize.Items.Objects[ListSize.ItemIndex]);
  nStr := PProductItem(FProducts[nIdx]).FSizeName;

  for nIdx:=FProducts.Count - 1 downto 0 do
   with PProductItem(FProducts[nIdx])^ do
    FSelected := CompareText(FSizeName, nStr) = 0;
  ModalResult := mrOk;
end;

end.
