{*******************************************************************************
  ����: dmzn@163.com 2011-11-30
  ����: ��Ʒ�����ջ�
*******************************************************************************}
unit UFormProductGet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UGridPainter, UFrameProductSale, Grids,
  UGridExPainter, StdCtrls, ExtCtrls, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxButtons;

type
  TfFormProductGet = class(TSkinFormBase)
    PanelL: TPanel;
    PanelR: TPanel;
    GridDetail: TDrawGridEx;
    GridStyle: TDrawGridEx;
    Splitter1: TSplitter;
    Label1: TLabel;
    LabelHint: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FPainter: TGridPainter;
    FPainterEx: TGridExPainter;
    //���ƶ���
    FProductInfo: PProductItem;
    //ѡ����Ʒ
    procedure LoadStyleList;
    //��ʽ�б�
    procedure LoadProductList(const nStyleID: string);
    //��Ʒ��ϸ
    procedure OnBtnClick(Sender: TObject);
    procedure OnBtnClick2(Sender: TObject);
    //�����ť
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowGetProductForm(const nProduct: PProductItem): Boolean;
//ѡ����Ʒ

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule;

function ShowGetProductForm(const nProduct: PProductItem): Boolean;
begin
  with TfFormProductGet.Create(Application) do
  begin
    FProductInfo := nProduct;
    LoadStyleList;

    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductGet.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductGet.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FPainter := TGridPainter.Create(GridStyle);
  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //����

    AddHeader('���', 50);
    AddHeader('��ʽ����', 50);
    AddHeader('����', 50);
  end;

  FPainterEx := TGridExPainter.Create(GridDetail);
  with FPainterEx do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //����

    AddHeader('��ɫ', 50, True);
    AddHeader('�ߴ�', 50);
    AddHeader('���п��', 50);
    AddHeader('���ۼ�', 50);
    AddHeader('����', 50);
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self);
    PanelL.Width := nIni.ReadInteger(Name, 'PanelL', 120);

    LoadDrawGridConfig(Name, GridStyle);
    LoadDrawGridConfig(Name, GridDetail);
  finally
    nIni.Free;
  end;
end;

procedure TfFormProductGet.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self);
    nIni.WriteInteger(Name, 'PanelL', PanelL.Width);

    SaveDrawGridConfig(Name, GridStyle);
    SaveDrawGridConfig(Name, GridDetail);

    FPainter.Free;
    FPainterEx.Free;
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: �����ʽ
procedure TfFormProductGet.LoadStyleList;
var nStr,nHint: string;
    nDS: TDataSet;
    nBtn: TcxButton;
    nIdx,nInt: Integer;
    nData: TGridDataArray;
begin
  nStr := 'Select distinct st.StyleID,StyleName from $PT pt ' +
          ' Left Join $DPT dpt On dpt.ProductID=pt.P_ID ' +
          ' Left Join $ST st On st.StyleID=dpt.StyleID ' +
          'Where P_TerminalID=''$ID'' And P_Number > 0 Order By StyleName';
  //xxxxx
  
  nStr := MacroValue(nStr, [MI('$PT', sTable_Product),
          MI('$DPT', sTable_DL_Product), MI('$ST', sTable_DL_Style),
          MI('$ID', gSysParam.FTerminalID)]);
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
        nData[1].FText := FieldByName('StyleName').AsString;

        with nData[2] do
        begin
          FText := '';
          FCtrls := TList.Create;

          nBtn := TcxButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Caption := 'ѡ��';
            Width := 35;
            Height := 18;

            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end;
        end;

        nData[3].FText := FieldByName('StyleID').AsString; 
        FPainter.AddData(nData);
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: �����Ʒ��ϸ
procedure TfFormProductGet.LoadProductList(const nStyleID: string);
var nStr,nHint: string;
    nInt,nNum: Integer;
    nDS: TDataSet;
    nBtn: TcxButton;
    nRow: TGridExDataArray;
    nCol: TGridExColDataArray;
begin
  nStr := 'Select pt.*,StyleName,ColorName,SizeName,BrandName From $PT pt ' +
          ' Left Join $DPT dpt on dpt.ProductID=pt.P_ID ' +
          ' Left Join $ST st On st.StyleID=dpt.StyleID ' +
          ' Left Join $CR cr On cr.ColorID=dpt.ColorID ' +
          ' Left Join $SZ sz on sz.SizeID=dpt.SizeID ' +
          ' Left Join $BR br On br.BrandID=dpt.BrandID ' +
          'Where dpt.StyleID=''$SID'' ' +
          'Order By ColorName,SizeName';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$PT', sTable_Product),
          MI('$DPT', sTable_DL_Product), MI('$BR', sTable_DL_Brand),
          MI('$ST', sTable_DL_Style), MI('$CR', sTable_DL_Color),
          MI('$SZ', sTable_DL_Size), MI('$ID', gSysParam.FTerminalID),
          MI('$SID', nStyleID)]);
  //xxxxx

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    FPainterEx.ClearData;
    if nDS.RecordCount < 1 then Exit;

    with nDS do
    begin
      First;
      LabelHint.Caption := FieldByName('StyleName').AsString;

      nHint := '';
      nNum := 0;

      while not Eof do
      begin
        SetLength(nRow, 9);
        for nInt:=Low(nRow) to High(nRow) do
        begin
          nRow[nInt].FCtrls := nil;
          nRow[nInt].FAlign := taCenter;
        end;

        nRow[0].FText := FieldByName('SizeName').AsString;
        nRow[1].FText := IntToStr(FieldByName('P_Number').AsInteger);
        nRow[2].FText := Format('%.2f', [FieldByName('P_Price').AsFloat]);

        with nRow[3] do
        begin
          FText := '';
          FCtrls := TList.Create;

          nBtn := TcxButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Caption := 'ѡ��';
            Width := 35;
            Height := 18;

            OnClick := OnBtnClick2;
            Tag := FPainterEx.DataCount;
          end;
        end;

        nRow[4].FText := FieldByName('P_ID').AsString;
        nRow[5].FText := Format('%.2f', [FieldByName('P_OldPrice').AsFloat]);
        nRow[6].FText := FieldByName('ColorName').AsString;
        nRow[7].FText := FieldByName('BrandName').AsString;
        nRow[8].FText := FloatToStr(FieldByName('P_InPrice').AsFloat);
        FPainterEx.AddRowData(nRow);
        //���������

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
          FCol := 0;
          FRows := nNum;
          FAlign := taCenter;
          FText := nHint;

          nNum := 1;
          nHint := FieldByName('ColorName').AsString;
        end;

        FPainterEx.AddColData(nCol);
        Next;
      end;
    end;

    if nNum > 0 then
    begin
      SetLength(nCol, 1);
      with nCol[0] do
      begin
        FCol := 0;
        FRows := nNum;
        FAlign := taCenter;
        FText := nHint;
      end;
      FPainterEx.AddColData(nCol);
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: ѡ���ʽ
procedure TfFormProductGet.OnBtnClick(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  FProductInfo.FStyleName := FPainter.Data[nTag][1].FText;
  LoadProductList(FPainter.Data[nTag][3].FText);
end;

//Desc: ѡ����Ʒ
procedure TfFormProductGet.OnBtnClick2(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  with FProductInfo^,FPainterEx do
  begin
    if StrToFloat(Data[nTag][2].FText) <= 0 then
    begin
      ShowMsg('���ۼ���Ч', sHint); Exit;
    end;

    FProductID := Data[nTag][4].FText;
    FColorName := Data[nTag][6].FText;
    FSizeName := Data[nTag][0].FText;
    FNumSale := 1;
    FNumStore := StrToInt(Data[nTag][1].FText);

    FPriceSale := StrToFloat(Data[nTag][2].FText);
    FPriceOld := StrToFloat(Data[nTag][5].FText);
    FPriceIn := StrToFloat(Data[nTag][8].FText);
    FBrandName := Data[nTag][7].FText;
    ModalResult := mrOk;
  end;
end;

end.
