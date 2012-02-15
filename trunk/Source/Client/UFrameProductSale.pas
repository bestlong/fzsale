{*******************************************************************************
  ����: dmzn@163.com 2011-11-21
  ����: ��Ʒ����
*******************************************************************************}
unit UFrameProductSale;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, USkinManager, UGridPainter, UGridExPainter,
  cxButtons, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, ExtCtrls, UImageButton, cxTextEdit, StdCtrls, Grids;

type
  PMemberInfo = ^TMemberInfo;
  TMemberInfo = record
    FID: string;             //���
    FCard: string;           //����
    FName: string;           //����
    FMoney: Double;          //���ѽ��
    FZheKou: Double;         //�ۿ۱���
  end;

  PProductItem = ^TProductItem;
  TProductItem = record
    FProductID: string;      //��Ʒ��
    FBrandName: string;      //Ʒ��
    FStyleName: string;      //��ʽ
    FColorName: string;      //��ɫ
    FSizeName: string;       //��С

    FNumSale: Integer;       //���ۼ���
    FNumStore: Integer;      //������
    FPriceSale: Double;      //���ۼ�
    FPriceOld: Double;       //ԭ��
    FPriceMember: Double;    //��Ա��
    FPriceIn: Double;        //������
    FSelected: Boolean;      //ѡ��
  end;

  TfFrameProductSale = class(TfFrameBase)
    GridList: TDrawGridEx;
    PanelT: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditName: TcxTextEdit;
    EditID: TcxTextEdit;
    EditMoney: TcxTextEdit;
    EditZhekou: TcxTextEdit;
    LabelHint: TLabel;
    PanelB: TPanel;
    BtnJZ: TImageButton;
    BtnCancel: TImageButton;
    BtnGetPrd: TImageButton;
    BtnMember: TImageButton;
    BtnCode: TImageButton;
    BtnTH: TImageButton;
    procedure BtnExitClick(Sender: TObject);
    procedure PanelBResize(Sender: TObject);
    procedure BtnGetPrdClick(Sender: TObject);
    procedure BtnMemberClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnCodeClick(Sender: TObject);
    procedure BtnJZClick(Sender: TObject);
    procedure BtnTHClick(Sender: TObject);
  private
    { Private declarations }
    FSkinItem: TSkinItem;
    //Ƥ������
    FPainter: TGridPainter;
    //��ͼ����
    FMember: TMemberInfo;
    //��Ա��Ϣ
    FProducts: TList;
    //�����嵥
    procedure AddProduct(const nProduct: TProductItem);
    //������Ʒ
    procedure LoadProductToList;
    //��ʾ�嵥
    procedure MemberInfo(const nInit: Boolean);
    //��Ա��Ϣ
    procedure OnBtnClick(Sender: TObject);
    //�����ť
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

procedure ClearProductList(const nList: TList; const nFree: Boolean);
//����嵥

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, USkinFormBase, UDataModule, DB, UMgrControl, USysConst,
  USysDB, USysFun, UFormProductGet, UFormProductConfirm, UFormMemberGet,
  UFormProductCode, UFormProductJZ, UFormProductTH, UFrameSummary;

class function TfFrameProductSale.FrameID: integer;
begin
  Result := cFI_FrameProductSale;
end;

procedure TfFrameProductSale.OnCreateFrame;
var nIni: TIniFile;
    nIdx,nH,nInt: Integer;
begin
  Name := MakeFrameName(FrameID);
  FProducts := TList.Create;
  FPainter := TGridPainter.Create(GridList);

  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //����

    AddHeader('���', 50);
    AddHeader('��Ʒ����', 50);
    AddHeader('ԭ��', 50);
    AddHeader('�ۿۼ�', 50);
    AddHeader('��Ա��', 50);
    AddHeader('����', 50);
    AddHeader('С��', 50);
    AddHeader('����', 50);
  end;

  MemberInfo(True);
  //xxxx

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadDrawGridConfig(Name, GridList, nIni);
    AdjustLabelCaption(LabelHint, GridList);
    Width := GetGridHeaderWidth(GridList);
  finally
    nIni.Free;
  end;

  FSkinItem := gSkinManager.GetSkin('FormDialog');
  if not Assigned(FSkinItem) then
    raise Exception.Create('��ȡƤ����Ϣʧ��');
  //xxxxx

  nH := 0;
  for nIdx:=PanelB.ControlCount-1 downto 0 do
   if PanelB.Controls[nIdx] is TImageButton then
    if TSkinFormBase.LoadImageButton(PanelB.Controls[nIdx] as TImageButton, FSkinItem) then
    begin
      nInt := (PanelB.Controls[nIdx] as TImageButton).PicNormal.Height;
      if nInt > nH then nH := nInt;
    end;

  if nH > 0 then
    PanelB.Height := nH + 32;
  //xxxxx

  for nIdx:=PanelB.ControlCount-1 downto 0 do
  if PanelB.Controls[nIdx] is TImageButton then
  begin
    nH := (PanelB.Controls[nIdx] as TImageButton).Height;
    (PanelB.Controls[nIdx] as TImageButton).Top := Trunc((PanelB.Height - nH) / 2);
  end;
end;

procedure TfFrameProductSale.OnDestroyFrame;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveDrawGridConfig(Name, GridList, nIni);
  finally
    nIni.Free;
  end;

  FPainter.Free;
  ClearProductList(FProducts, True);
end;

procedure TfFrameProductSale.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: ��ťλ��
procedure TfFrameProductSale.PanelBResize(Sender: TObject);
const cInt = 12;
begin
  BtnCancel.Left := BtnJZ.Left + BtnJZ.Width + cInt;
  BtnTH.Left := PanelB.Width - 85 - BtnTH.Width;
  BtnCode.Left := BtnTH.Left - cInt - BtnCode.Width;
  BtnMember.Left := BtnCode.Left - cInt - BtnMember.Width;
  BtnGetPrd.Left := BtnMember.Left - cInt - BtnGetPrd.Width;
end;

//------------------------------------------------------------------------------
//Desc: �����Ʒ�嵥
procedure ClearProductList(const nList: TList; const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=nList.Count - 1 downto 0 do
  begin
    Dispose(PProductItem(nList[nIdx]));
    nList.Delete(nIdx);
  end;

  if nFree then
    nList.Free;
  //xxxxx
end;

//Desc: ��ʾ��Ա��Ϣ
procedure TfFrameProductSale.MemberInfo(const nInit: Boolean);
var nIdx: Integer;
begin
  if nInit then
  with FMember do
  begin
    FID := '';
    FName := '';
    FMoney := 0;
    FZheKou := 10;
  end;

  with FMember do
  begin
    if FID = '' then EditID.Text := '��' else EditID.Text := FID;
    if FName = '' then EditName.Text := '��' else EditName.Text := FName;

    if FMoney <= 0 then
         EditMoney.Text := '��'
    else EditMoney.Text := Format('��%.2fԪ', [FMoney]);

    if FZheKou >= 10 then
         EditZhekou.Text := '��'
    else EditZhekou.Text := Format('%f��', [FZheKou]);
                           
    for nIdx:=0 to FProducts.Count - 1 do
    with PProductItem(FProducts[nIdx])^ do
    begin
      if FZheKou < 10 then
           FPriceMember := FPriceSale * FZheKou / 10
      else FPriceMember := FPriceSale;
    end;
  end;
end;

//Desc: �����Ʒ�б�����
procedure TfFrameProductSale.LoadProductToList;
var nStr: string;
    nVal: Double;
    nBtn: TcxButton;
    nIdx,nInt,nNum: Integer;
    nData: TGridDataArray;
begin
  nInt := 1;
  FPainter.ClearData;

  for nIdx:=0 to FProducts.Count - 1 do
  with PProductItem(FProducts[nIdx])^ do
  begin
    SetLength(nData, 9);
    for nNum:=Low(nData) to High(nData) do
    begin
      nData[nNum].FText := '';
      nData[nNum].FCtrls := nil;
      nData[nNum].FAlign := taCenter;
    end;

    nData[0].FText := IntToStr(nInt);
    Inc(nInt);

    nStr := Format('%s_%s_%s', [FStyleName, FColorName, FSizeName]);
    nData[1].FText := nStr;
    nData[2].FText := Format('%.2f', [FPriceOld]);
    nData[3].FText := Format('%.2f', [FPriceSale]);

    if FMember.FID = '' then
         nData[4].FText := '0.00'
    else nData[4].FText := Format('%.2f', [FPriceMember]);

    nData[5].FText := IntToStr(FNumSale);
    nVal := Float2Float(FNumSale * FPriceMember, 100);
    nData[6].FText := Format('%.2f', [nVal]);

    with nData[7] do
    begin
      FCtrls := TList.Create;
      nBtn := TcxButton.Create(Self);
      FCtrls.Add(nBtn);

      with nBtn do
      begin
        Caption := '����';
        Width := 35;
        Height := 18;

        OnClick := OnBtnClick;
        Tag := FPainter.DataCount;
      end;

      nBtn := TcxButton.Create(Self);
      FCtrls.Add(nBtn);

      with nBtn do
      begin
        Caption := '����';
        Width := 35;
        Height := 18;

        OnClick := OnBtnClick;
        Tag := FPainter.DataCount;
      end;
    end;

    nData[8].FText := IntToStr(nIdx);
    FPainter.AddData(nData);
  end;

  //----------------------------------------------------------------------------
  if FProducts.Count < 1 then Exit;
  SetLength(nData, 7);

  for nIdx:=Low(nData) to High(nData) do
  begin
    nData[nIdx].FText := '';
    nData[nIdx].FCtrls := nil;
    nData[nIdx].FAlign := taCenter;
  end;

  nNum := 0;
  nVal := 0;

  for nIdx:=FProducts.Count - 1 downto 0 do
  with PProductItem(FProducts[nIdx])^ do
  begin
    nNum := nNum + FNumSale;
    if FMember.FID = '' then
         nVal := nVal + Float2Float(FNumSale * FPriceSale, 100)
    else nVal := nVal + Float2Float(FNumSale * FPriceMember, 100);
  end;

  nData[0].FText := '�ϼ�:';
  nData[5].FText := Format('%d', [nNum]);
  nData[6].FText := Format('��%.2f', [nVal]);
  FPainter.AddData(nData);
end;

//Desc: ��Ӳ�Ʒ��
procedure TfFrameProductSale.AddProduct(const nProduct: TProductItem);
var nItem: PProductItem;
begin
  New(nItem);
  FProducts.Add(nItem);

  with nItem^ do
  begin
    nItem^ := nProduct;
    if FloatRelation(FPriceSale, FPriceOld, rtGreater) or (FPriceOld <= 0) then
      FPriceOld := FPriceSale;
    //�Ǽ۵�

    if FMember.FZheKou < 10 then
         FPriceMember := FPriceSale * FMember.FZheKou / 10
    else FPriceMember := FPriceSale;
  end;

  LoadProductToList;
end;

//Desc: ѡ����Ʒ
procedure TfFrameProductSale.BtnGetPrdClick(Sender: TObject);
var nItem: TProductItem;
begin
  if ShowGetProductForm(@nItem) and ShowSaleProductConfirm(@nItem) then
    AddProduct(nItem);
  //xxxxx
end;

//Desc: ��ť
procedure TfFrameProductSale.OnBtnClick(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  if Sender = FPainter.Data[nTag][7].FCtrls[0] then
  begin
    nTag := StrToInt(FPainter.Data[nTag][8].FText);
    if ShowSaleProductConfirm(FProducts[nTag]) then
      LoadProductToList;
    //xxxxx
  end else //����

  if Sender = FPainter.Data[nTag][7].FCtrls[1] then
  begin
    nTag := StrToInt(FPainter.Data[nTag][8].FText);
    PProductItem(FProducts[nTag]).FNumSale := 0;
    LoadProductToList;
  end; //����
end;

//Desc: ѡ���Ա
procedure TfFrameProductSale.BtnMemberClick(Sender: TObject);
begin
  if ShowGetMember(@FMember) then
  begin
    MemberInfo(False);
    LoadProductToList;
  end;
end;

//Desc: �����������
procedure TfFrameProductSale.BtnCancelClick(Sender: TObject);
var nStr: string;
begin
  if FPainter.DataCount > 0 then
  begin
    nStr := 'ȷ��Ҫȡ������������?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  MemberInfo(True);
  ClearProductList(FProducts, False);
  LoadProductToList;
end;

//Desc: ��������
procedure TfFrameProductSale.BtnCodeClick(Sender: TObject);
var nItem: TProductItem;
begin
  while True do
  begin
    if ShowGetProductByCode(@nItem) then
    begin
      if nItem.FPriceSale > 0 then
           AddProduct(nItem)
      else ShowMsg('���ۼ���Ч', sHint);
    end else Break;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ����
procedure TfFrameProductSale.BtnJZClick(Sender: TObject);
var nIdx,nNum: Integer;
begin
  nNum := 0;
  for nIdx:=FProducts.Count - 1 downto 0 do
    nNum := nNum + PProductItem(FProducts[nIdx]).FNumSale;
  //xxxxx

  if nNum < 1 then
  begin
    ShowMsg('û����Ҫ���ʵ���Ʒ', sHint); Exit;
  end;

  if ShowProductJZ(FProducts, @FMember) then
  begin
    SetTendayLoadFlag(False);
    MemberInfo(True);

    ClearProductList(FProducts, False);
    LoadProductToList;
  end;
end;

//Desc: �˻�
procedure TfFrameProductSale.BtnTHClick(Sender: TObject);
var nIdx,nNum: Integer;
begin
  nNum := 0;
  for nIdx:=FProducts.Count - 1 downto 0 do
    nNum := nNum + PProductItem(FProducts[nIdx]).FNumSale;
  //xxxxx

  if nNum < 1 then
  begin
    ShowMsg('û����Ҫ�˻�����Ʒ', sHint); Exit;
  end;

  if ShowProductTH(FProducts, @FMember) then
  begin
    SetTendayLoadFlag(False);
    MemberInfo(True);
    
    ClearProductList(FProducts, False);
    LoadProductToList;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameProductSale, TfFrameProductSale.FrameID);
end.
