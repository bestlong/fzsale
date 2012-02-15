{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 商品销售退货
*******************************************************************************}
unit UFormProductTH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UFrameProductSale, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxListBox,
  cxTextEdit, ExtCtrls, UImageButton, StdCtrls, cxMaskEdit, cxDropDownEdit;

type
  TfFormProductTH = class(TSkinFormBase)
    LabelHint: TLabel;
    Panel1: TPanel;
    BtnOK: TImageButton;
    Label1: TLabel;
    EditYMoney: TcxTextEdit;
    EditMoney: TcxTextEdit;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditUser: TcxComboBox;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditMoneyKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FMember: PMemberInfo;
    //会员信息
    FProducts: TList;
    //商品信息
    FNumber: Integer;
    //销售件数
    procedure LoadProductTH;
    //退货信息
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowProductTH(const nProducts: TList; nMember: PMemberInfo): Boolean;
//销售结算

implementation

{$R *.dfm}

uses
  ULibFun, UFormCtrl, UDataModule, DB, USysConst, USysDB, USysFun, FZSale_Intf;

function ShowProductTH(const nProducts: TList; nMember: PMemberInfo): Boolean;
begin
  with TfFormProductTH.Create(Application) do
  begin
    FMember := nMember;
    FProducts := nProducts;
    
    LoadProductTH;
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductTH.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductTH.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx

  LoadFormConfig(Self);
end;

procedure TfFormProductTH.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

procedure TfFormProductTH.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormProductTH.Panel1Resize(Sender: TObject);
begin
  BtnOk.Left := Trunc((Panel1.Width - BtnOK.Width) / 2);
end;

//Desc: 响应回车

procedure TfFormProductTH.EditMoneyKeyPress(Sender: TObject; var Key: Char);
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

//Desc: 载入退货数据
procedure TfFormProductTH.LoadProductTH;
var nIdx: Integer;
    nVal: Double;
    nStr,nHint: string;
    nDS: TDataset;
begin
  nVal := 0;
  FNumber := 0;

  for nIdx:=FProducts.Count - 1 downto 0 do
  with PProductItem(FProducts[nIdx])^ do
  begin
    FNumber := FNumber + FNumSale;
    nVal := nVal + Float2Float(FNumSale * FPriceMember, 100);
  end;

  EditYMoney.Text := Format('￥%.2f元', [nVal]);
  EditMoney.Text := FloatToStr(nVal);
  EditMoney.SelectAll;
  ActiveControl := EditMoney;

  //----------------------------------------------------------------------------
  nStr := 'Select U_Name From %s Where U_TerminalId=''%s'' And ' +
          'U_Invalid<>''%s'' Order By U_Name';
  nStr := Format(nStr, [sTable_TerminalUser, gSysParam.FTerminalID, sFlag_Yes]);
  EditUser.Properties.Items.Clear;

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if Assigned(nDS) and (nDS.RecordCount > 0) then
    with nDS do
    begin
      First;

      while not Eof do
      begin
        EditUser.Properties.Items.Add(Fields[0].AsString);
        Next;
      end;
    end;

    EditUser.ItemIndex := EditUser.Properties.Items.IndexOf(gSysParam.FUserID);
    //默认当前用户
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 结帐
procedure TfFormProductTH.BtnOKClick(Sender: TObject);
var nStr,nHint: string;
    nIdx: Integer;
    nSQLList: SQLItems;
begin
  if (not IsNumber(EditMoney.Text, True)) and (StrToFloat(EditMoney.Text) < 0) then
  begin
    EditMoney.SelectAll;
    EditMoney.SetFocus;
    ShowMsg('请输入有效金额', sHint); Exit;
  end;

  if EditUser.ItemIndex < 0 then
  begin
    EditUser.SetFocus;
    ShowMsg('请选择销售员', sHint); Exit;
  end;

  nStr := Format('退货操作将影响销售员[ %s ]的业绩,要继续吗?', [EditUser.Text]);
  if not QueryDlg(nStr, sAsk) then Exit;

  nSQLList := SQLItems.Create;
  try
    nStr := MakeSQLByStr([SF('R_Sync', sFlag_SyncW),
            SF('S_TerminalId', gSysParam.FTerminalID),
            SF('S_Number', IntToStr(-FNumber), sfVal),
            SF('S_Money', '-' + EditMoney.Text, sfVal),
            SF('S_Member', FMember.FID),
            SF('S_Deduct', '10', sfVal),
            SF('S_DeMoney', '0.00', sfVal),
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
      nStr := MakeSQLByStr([SF('R_Sync', sFlag_SyncW),
              SF('D_Product', FProductID),
              SF('D_Number', IntToStr(-FNumSale), sfVal),
              SF('D_Price', FloatToStr(FPriceSale), sfVal),
              SF('D_Member', FMember.FID),
              SF('D_Deduct', '10', sfVal),
              SF('D_DeMoney', '0.00', sfVal)
              ], sTable_SaleDtl, '', True);
      //xxxxx

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end;

      nStr := 'Update %s Set P_Number=P_Number+%d ' +
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
      nStr := 'Update %s Set M_BuyMoney=M_BuyMoney-(%s) ' +
              'Where M_ID=''%s''';
      nStr := Format(nStr, [sTable_Member, EditMoney.Text, FMember.FID]);
      
      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end;
    end;

    if FDM.SQLUpdates(nSQLList, True, nHint) > 0 then
    begin
      ShowMsg('退货成功', sHint);
      ModalResult := mrOk;
    end else ShowDlg(nHint, sWarn, Handle);
  finally
    //nSQLList.Free;
  end;
end;

end.
