{*******************************************************************************
  ����: dmzn@163.com 2011-11-21
  ����: �鿴��Ʒ���
*******************************************************************************}
unit UFrameProductKC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, StdCtrls,
  cxButtons, cxLabel, cxRadioGroup, Grids, UGridPainter, UGridExPainter,
  ExtCtrls, cxPC, UImageButton;

type
  TfFrameProductKC = class(TfFrameBase)
    PanelR: TPanel;
    LabelHint: TLabel;
    GridDetail: TDrawGridEx;
    Splitter1: TSplitter;
    PanelL: TPanel;
    Label1: TLabel;
    wPage: TcxPageControl;
    Sheet2: TcxTabSheet;
    GridPBrand: TDrawGridEx;
    Sheet1: TcxTabSheet;
    GridProduct: TDrawGridEx;
    ImageButton1: TImageButton;
    procedure BtnExitClick(Sender: TObject);
    procedure wPageChange(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridPainter;
    FPainter2: TGridPainter;
    FPainterEx: TGridExPainter;
    //��ͼ����
    FData: TList;
    //�����б�
    FBrandID: string;
    FBrandName: string;
    //Ʒ�Ʊ�ʶ
    FBrandLoad: Boolean;
    //������
    procedure ClearData(const nFree: Boolean);
    //��������
    procedure LoadProductData;
    procedure LoadProductList;
    //��Ʒ�б�
    procedure LoadBrandName;
    procedure LoadBrandList;
    //Ʒ�ƴ���
    function CountNumber(const nID: string): Integer;
    //ͳ������
    procedure ShowProdctDetail(nBtn: TcxButton);
    //��ʾ��ϸ
    procedure OnBtnClick(Sender: TObject);
    procedure OnBtnClick2(Sender: TObject);
    //�����ť
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UDataModule, DB, UMgrControl, USysConst, USysDB, USysFun,
  UFormProductBill, UFormBillConfirm, UFormProductReturn, UFormReturnConfirm,
  UFormProductPrice;

type
  PDataItem = ^TDataItem;
  TDataItem = record
    FStyle: string;    //��ʽ���
    FName: string;     //��ʽ����
    FColor: string;    //��ɫ
    FSize: string;     //��С
    FNumber: Integer;  //���
    FPrice: Double;    //���ۼ�
    FInPrice: Double;  //������
    FProPrice: Double; //�����
    FTime: string;     //����ʱ��
  end;

class function TfFrameProductKC.FrameID: integer;
begin
  Result := cFI_FrameProductKC;
end;

procedure TfFrameProductKC.OnCreateFrame;
var nIni: TIniFile;
begin
  Name := MakeFrameName(FrameID);
  FBrandLoad := False;
  FData := TList.Create;

  FPainter := TGridPainter.Create(GridProduct);
  FPainter2 := TGridPainter.Create(GridPBrand);
  FPainterEx := TGridExPainter.Create(GridDetail);

  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //����

    AddHeader('���', 50);
    AddHeader('��ʽ����', 50);
    AddHeader('�ܿ����', 50);
    AddHeader('����', 50);
  end;

  with FPainter2 do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //����

    AddHeader('���', 50);
    AddHeader('��ʽ����', 50);
    AddHeader('����', 50);
  end;

  with FPainterEx do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //����

    AddHeader('��ɫ', 50, True);
    AddHeader('����', 50);
    AddHeader('���п��', 50);
    AddHeader('���ۼ�', 50);
    AddHeader('��ǰ������', 50);
    AddHeader('�ϴ�������', 50);
    AddHeader('�ϴ����ʱ��', 50);
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadDrawGridConfig(Name, GridProduct, nIni);
    LoadDrawGridConfig(Name, GridPBrand, nIni);
    LoadDrawGridConfig(Name, GridDetail, nIni);

    PanelL.Width := nIni.ReadInteger(Name, 'PanelL', 120);
    Width := PanelL.Width + GetGridHeaderWidth(GridDetail);
    
    wPage.ActivePage := Sheet1;
    LoadBrandName;
    LoadProductData;
  finally
    nIni.Free;
  end;
end;

procedure TfFrameProductKC.OnDestroyFrame;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveDrawGridConfig(Name, GridProduct, nIni);
    SaveDrawGridConfig(Name, GridPBrand, nIni);
    SaveDrawGridConfig(Name, GridDetail, nIni);
    nIni.WriteInteger(Name, 'PanelL', PanelL.Width);
  finally
    nIni.Free;
  end;

  FPainter.Free;
  FPainterEx.Free;
  ClearData(True);
end;

procedure TfFrameProductKC.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: ��������
procedure TfFrameProductKC.ClearData(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FData.Count - 1 downto 0 do
  begin
    Dispose(PDataItem(FData[nIdx]));
    FData.Delete(nIdx);
  end;

  if nFree then FData.Free;
end;

//Desc: �����Ʒ�б�
procedure TfFrameProductKC.LoadProductData;
var nStr,nHint: string;
    nDS: TDataSet;
    nItem: PDataItem;
begin
  nStr := 'Select pt.*,p.StyleID,StyleName,ColorName,SizeName,TerminalPrice From $PT pt' +
          ' Left Join (Select ProductID,StyleName,dpt.StyleID,TerminalPrice From $DPT dpt' +
          '  Left Join $ST st On st.StyleID=dpt.StyleID' +
          ' ) p On ProductID=pt.P_ID' +
          ' Left Join $CR cr On cr.ColorID=P_Color ' +
          ' Left Join $SZ sz on sz.SizeID=P_Size ' +
          'Where P_TerminalID=''$ID'' ' +
          'Order By pt.P_ID,ColorName,SizeName';
  //xxxxx
  
  nStr := MacroValue(nStr, [MI('$PT', sTable_Product), MI('$DPT', sTable_DL_Product),
          MI('$ST', sTable_DL_Style), MI('$CR', sTable_DL_Color),
          MI('$SZ', sTable_DL_Size), MI('$ID', gSysParam.FTerminalID)]);
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

      while not Eof do
      begin
        New(nItem);
        FData.Add(nItem);

        with nItem^ do
        begin
          FStyle := FieldByName('StyleID').AsString;
          FName := FieldByName('StyleName').AsString;
          FColor := FieldByName('ColorName').AsString;
          FSize := FieldByName('SizeName').AsString;
          FNumber := FieldByName('P_Number').AsInteger;
          FPrice := FieldByName('P_Price').AsFloat;
          FInPrice := FieldByName('P_InPrice').AsFloat;
          FProPrice := FieldByName('TerminalPrice').AsFloat;
          FTime := DateTime2Str(FieldByName('P_LastIn').AsDateTime);
        end;

        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;

  LoadProductList;
end;

//Desc: ͳ��ָ����ʽ�Ŀ������
function TfFrameProductKC.CountNumber(const nID: string): Integer;
var nIdx: Integer;
begin
  Result := 0;

  for nIdx:=FData.Count - 1 downto 0 do
   with PDataItem(FData[nIdx])^ do
    if FStyle = nID then Result := Result + FNumber;
  //xxxxx
end;

//Desc: �����Ʒ�б�����
procedure TfFrameProductKC.LoadProductList;
var i,nIdx,nInt: Integer;
    nList: TStrings;
    nBtn: TImageButton;
    nData: TGridDataArray;
begin
  nList := TStringList.Create;
  try
    nInt := 1;

    for nIdx:=0 to FData.Count - 1 do
     with PDataItem(FData[nIdx])^ do
      if nList.IndexOf(FStyle) < 0 then
      begin
        nList.Add(FStyle);
        SetLength(nData, 5);

        for i:=Low(nData) to High(nData) do
        begin
          nData[i].FText := '';
          nData[i].FCtrls := nil;
          nData[i].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);
        nData[4].FText := FStyle;
        
        nData[1].FText := FName;
        nData[2].FText := IntToStr(CountNumber(FStyle));

        with nData[3] do
        begin
          FText := '';
          FAlign := taCenter;
          FCtrls := TList.Create;

          nBtn := TImageButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Parent := Self;
            ButtonID := 'btn_adjust_price';
            LoadButton(nBtn);

            Enabled := gSysParam.FIsAdmin;
            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end;

          nBtn := TImageButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Parent := Self;
            ButtonID := 'btn_bill_goods';
            LoadButton(nBtn);

            Enabled := gSysParam.FIsAdmin;
            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end;

          nBtn := TImageButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Parent := Self;
            ButtonID := 'btn_return_goods';
            LoadButton(nBtn);

            Enabled := gSysParam.FIsAdmin;
            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end;

          nBtn := TImageButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Parent := Self;
            ButtonID := 'btn_view_detail';
            LoadButton(nBtn);

            Parent := Self;
            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end;
        end;

        FPainter.AddData(nData);
      end;
  finally
    nList.Free;
  end;
end;

//Desc: ����Ʒ������
procedure TfFrameProductKC.LoadBrandName;
var nStr,nHint: string;
    nDS: TDataSet;
begin
  nStr := 'Select BrandID,BrandName From %s Where TerminalId=''%s''';
  nStr := Format(nStr, [sTable_Terminal, gSysParam.FTerminalID]);
  
  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    if nDS.RecordCount > 0 then
    with nDS do
    begin
      First;
      FBrandID := Fields[0].AsString;
      FBrandName := Fields[1].AsString;
      Sheet2.Caption := Format('%s��Ʒ��', [FBrandName]);
    end else
    begin
      ShowMsg('�޷���ȡƷ����Ϣ', sHint);
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: ����Ʒ���б�
procedure TfFrameProductKC.LoadBrandList;
var nStr,nHint: string;
    nDS: TDataSet;
    nIdx,nInt: Integer;
    nBtn: TImageButton;
    nData: TGridDataArray;
begin
  if FBrandLoad then Exit;
  //�ظ������ж�

  nStr := 'Select distinct pr.StyleID,StyleName From $PT pr ' +
          ' Left Join $ST st On st.StyleID=pr.StyleID ' +
          'Where pr.BrandID=''$BD'' Order By StyleName';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$PT', sTable_DL_Product),
          MI('$ST', sTable_DL_Style), MI('$BD', FBrandID)]);
  //xxxxx

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    FPainter2.ClearData;
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

          nBtn := TImageButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Parent := Self;
            ButtonID := 'btn_bill_goods';
            LoadButton(nBtn);
            
            OnClick := OnBtnClick2;
            Tag := FPainter2.DataCount;
          end;
        end;

        nData[3].FText := FieldByName('StyleID').AsString;
        FPainter2.AddData(nData);
        Next;
      end;
    end;

    FBrandLoad := True;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

procedure TfFrameProductKC.wPageChange(Sender: TObject);
begin
  if wPage.ActivePage = Sheet2 then LoadBrandList;
end;

procedure TfFrameProductKC.ShowProdctDetail(nBtn: TcxButton);
var nStr,nID: string;
    nIdx,nNum,nInt: Integer;
    nRow: TGridExDataArray;
    nCol: TGridExColDataArray;
begin
  nNum := nBtn.Tag;
  nID := FPainter.Data[nNum][4].FText;

  LabelHint.Caption := FPainter.Data[nNum][1].FText + '��ϸ��Ϣ';
  nInt := AdjustLabelCaption(LabelHint, GridDetail);

  if nInt > LabelHint.Width then
    Width := PanelL.Width + nInt + 32;
  //���ⳬ������Ӧ
  
  nNum := 0;
  nStr := '';
  FPainterEx.ClearData;

  for nIdx:=0 to FData.Count - 1 do
   with PDataItem(FData[nIdx])^ do
    if FStyle = nID then
    begin
      SetLength(nRow, 6);
      for nInt:=Low(nRow) to High(nRow) do
      begin
        nRow[nInt].FCtrls := nil;
        nRow[nInt].FAlign := taCenter;
      end;

      nRow[0].FText := FSize;
      nRow[1].FText := IntToStr(FNumber);
      nRow[2].FText := Format('%.2f', [FPrice]);

      nRow[3].FText := Format('%.2f', [FProPrice]);;
      nRow[4].FText := Format('%.2f', [FInPrice]);;
      nRow[5].FText := FTime;

      FPainterEx.AddRowData(nRow);
      //���������
        
      if nStr = '' then
        nStr := FColor;
      //xxxxx

      if nStr = FColor then
      begin
        Inc(nNum);
        Continue;
      end;

      SetLength(nCol, 1);
      with nCol[0] do
      begin
        FCol := 0;
        FRows := nNum;
        FAlign := taCenter;
        FText := nStr;

        nNum := 1;
        nStr := FColor;
      end;

      FPainterEx.AddColData(nCol);
    end;
  //color

  if nNum > 0 then
  begin
    SetLength(nCol, 1);
    with nCol[0] do
    begin
      FCol := 0;
      FRows := nNum;
      FAlign := taCenter;
      FText := nStr;
    end;

    FPainterEx.AddColData(nCol);
  end;
end;

//Desc: ��ť
procedure TfFrameProductKC.OnBtnClick(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  if Sender = FPainter.Data[nTag][3].FCtrls[0] then
  begin
    ShowProductPriceForm(FPainter.Data[nTag][4].FText);
  end else //����

  if Sender = FPainter.Data[nTag][3].FCtrls[1] then
  begin
    if ShowProductInForm(FPainter.Data[nTag][4].FText) then
      ShowBillConfirmForm('');
  end else //����

  if Sender = FPainter.Data[nTag][3].FCtrls[2] then
  begin
    if ShowProductReturnForm(FPainter.Data[nTag][4].FText) then
      ShowReturnConfirmForm('');
  end else //�˻�

  if Sender = FPainter.Data[nTag][3].FCtrls[3] then
  begin
    ShowProdctDetail(TcxButton(Sender));
  end; //��ϸ
end;

//Desc: ��Ʒ����
procedure TfFrameProductKC.OnBtnClick2(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  if Sender = FPainter2.Data[nTag][2].FCtrls[0] then
  begin
    if ShowProductInForm(FPainter2.Data[nTag][3].FText) then
      ShowBillConfirmForm('');
  end else //����
end;

initialization
  gControlManager.RegCtrl(TfFrameProductKC, TfFrameProductKC.FrameID);
end.
