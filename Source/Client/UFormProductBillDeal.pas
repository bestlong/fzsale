{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 商品订单收货明细
*******************************************************************************}
unit UFormProductBillDeal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UGridPainter, ExtCtrls, UImageButton, Grids,
  UGridExPainter, StdCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, cxButtons;

type
  TfFormProductBillDeal = class(TSkinFormBase)
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
    procedure LoadDealDetail(const nOrderID: string);
    //商品信息
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowProductBillDealView(const nOrderID: string): Boolean;
//查看收货明细

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule;

function ShowProductBillDealView(const nOrderID: string): Boolean;
begin
  with TfFormProductBillDeal.Create(Application) do
  begin
    LoadDealDetail(nOrderID);
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductBillDeal.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductBillDeal.FormCreate(Sender: TObject);
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
    AddHeader('收货单价', 50);
    AddHeader('收货件数', 50);
    AddHeader('收货人', 50);
    AddHeader('收货时间', 50);
  end;

  LoadFormConfig(Self);
  LoadDrawGridConfig(Name, GridList);
end;

procedure TfFormProductBillDeal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
end;

procedure TfFormProductBillDeal.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormProductBillDeal.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 65 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 65;
end;

//------------------------------------------------------------------------------
//Desc: 载入订单明细
procedure TfFormProductBillDeal.LoadDealDetail(const nOrderID: string);
var nStr,nHint: string;
    nIdx,nInt,nNum: Integer;
    nDS: TDataSet;
    nData: TGridDataArray;
begin
  nStr := 'Select dt.*,BrandName,StyleName,ColorName,SizeName,' +
          'O_Man,O_Date From $DT dt ' +
          ' Left Join $PT pt On pt.ProductID=dt.D_Product ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $OD od On od.O_ID=dt.D_Order ' +
          ' Left Join $BR br On br.BrandID=pt.BrandID ' +
          'Where D_Order=''$ID'' Order By dt.R_ID';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$DT', sTable_OrderDeal), MI('$ID', nOrderID),
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
      nNum := 0;

      EditID.Text := nOrderID;
      EditMan.Text := FieldByName('O_Man').AsString;
      EditTime.Text := DateTime2Str(FieldByName('O_Date').AsDateTime);

      while not Eof do
      begin
        SetLength(nData, 7);
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

        nData[3].FText := Format('%.2f', [FieldByName('D_Price').AsFloat]);
        nData[4].FText := FieldByName('D_Number').AsString;
        nNum := nNum + FieldByName('D_Number').AsInteger;

        nData[5].FText := FieldByName('D_Man').AsString;
        nData[6].FText := DateTime2Str(FieldByName('D_Date').AsDateTime);
        FPainter.AddData(nData);
        Next;
      end;
    end;

    SetLength(nData, 7);
    for nIdx:=Low(nData) to High(nData) do
    begin
      nData[nIdx].FText := '';
      nData[nIdx].FCtrls := nil;
      nData[nIdx].FAlign := taCenter;
    end;

    nData[0].FText := '合计:';
    nData[4].FText := Format('%d件', [nNum]);
    FPainter.AddData(nData);
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

procedure TfFormProductBillDeal.BtnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
