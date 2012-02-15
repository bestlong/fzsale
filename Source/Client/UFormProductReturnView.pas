{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 查看商品退货单
*******************************************************************************}
unit UFormProductReturnView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UGridPainter, ExtCtrls, UImageButton, Grids,
  UGridExPainter, StdCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit;

type
  TfFormProductReturnView = class(TSkinFormBase)
    GridList: TDrawGridEx;
    Panel1: TPanel;
    BtnOK: TImageButton;
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
    procedure LoadReturnDetail(const nReturn: string);
    //商品信息
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowProductReturnView(const nReturn: string): Boolean;
//查看退货单

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule;

function ShowProductReturnView(const nReturn: string): Boolean;
begin
  with TfFormProductReturnView.Create(Application) do
  begin
    LoadReturnDetail(nReturn);  
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductReturnView.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductReturnView.FormCreate(Sender: TObject);
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
    AddHeader('退货量', 50);
  end;

  LoadFormConfig(Self);
  LoadDrawGridConfig(Name, GridList);
end;

procedure TfFormProductReturnView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
end;

procedure TfFormProductReturnView.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormProductReturnView.Panel1Resize(Sender: TObject);
begin
  BtnOK.Left := Trunc((Panel1.Width - BtnOK.Width) / 2);
end;

//------------------------------------------------------------------------------
//Desc: 载入退货单明细
procedure TfFormProductReturnView.LoadReturnDetail(const nReturn: string);
var nStr,nHint: string;
    nIdx,nInt: Integer;
    nDS: TDataSet;
    nData: TGridDataArray;
begin
  nStr := 'Select rd.*,BrandName,StyleName,ColorName,SizeName,' +
          'T_Man,T_Date From $RD rd ' +
          ' Left Join $PT pt On pt.ProductID=rd.D_Product ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $RT rt On rt.T_ID=rd.D_Return ' +
          ' Left Join $BR br On br.BrandID=pt.BrandID ' +
          'Where D_Return=''$ID'' Order By StyleName,ColorName,SizeName';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$RD', sTable_ReturnDtl), MI('$ID', nReturn),
          MI('$ST', sTable_DL_Style), MI('$SZ', sTable_DL_Size),
          MI('$CR', sTable_DL_Color), MI('$RT', stable_Return),
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

      EditID.Text := nReturn;
      EditMan.Text := FieldByName('T_Man').AsString;
      EditTime.Text := DateTime2Str(FieldByName('T_Date').AsDateTime);

      while not Eof do
      begin
        SetLength(nData, 4);
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
        FPainter.AddData(nData);
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

procedure TfFormProductReturnView.BtnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
