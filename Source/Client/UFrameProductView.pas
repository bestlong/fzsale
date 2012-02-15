{*******************************************************************************
  ����: dmzn@163.com 2011-11-21
  ����: �鿴��Ʒ���
*******************************************************************************}
unit UFrameProductView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, StdCtrls,
  cxButtons, cxLabel, cxRadioGroup, Grids, UGridPainter, UGridExPainter,
  ExtCtrls;

type
  TfFrameProductView = class(TfFrameBase)
    PanelR: TPanel;
    PanelL: TPanel;
    LabelHint: TLabel;
    GridDetail: TDrawGridEx;
    Label2: TLabel;
    GridProduct: TDrawGridEx;
    Splitter1: TSplitter;
    procedure BtnExitClick(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridPainter;
    FPainterEx: TGridExPainter;
    //��ͼ����
    FData: TList;
    //�����б�
    procedure ClearData(const nFree: Boolean);
    //��������
    procedure LoadProductData;
    procedure LoadProductList;
    //��Ʒ�б�
    function CountNumber(const nID: string): Integer;
    //ͳ������
    procedure OnBtnClick(Sender: TObject);
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
  UFormProductPrice;

type
  PDataItem = ^TDataItem;
  TDataItem = record
    FStyle: string;
    FName: string;
    FColor: string;
    FSize: string;
    FNumber: Integer;
    FTime: string;
  end;

class function TfFrameProductView.FrameID: integer;
begin
  Result := cFI_FrameProductView;
end;

procedure TfFrameProductView.OnCreateFrame;
var nIni: TIniFile;
begin
  Name := MakeFrameName(FrameID);
  FData := TList.Create;
  FPainter := TGridPainter.Create(GridProduct);
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

  with FPainterEx do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //����

    AddHeader('��ɫ', 50, True);
    AddHeader('����', 50);
    AddHeader('���д���', 50);
    AddHeader('�ϴ����ʱ��', 50);
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadDrawGridConfig(Name, GridProduct, nIni);
    LoadDrawGridConfig(Name, GridDetail, nIni);
    PanelL.Width := nIni.ReadInteger(Name, 'PanelL', 120);

    Width := PanelL.Width + GetGridHeaderWidth(GridDetail);
    LoadProductData;
  finally
    nIni.Free;
  end;
end;

procedure TfFrameProductView.OnDestroyFrame;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveDrawGridConfig(Name, GridProduct, nIni);
    SaveDrawGridConfig(Name, GridDetail, nIni);
    nIni.WriteInteger(Name, 'PanelL', PanelL.Width);
  finally
    nIni.Free;
  end;

  FPainter.Free;
  FPainterEx.Free;
  ClearData(True);
end;

procedure TfFrameProductView.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: ��������
procedure TfFrameProductView.ClearData(const nFree: Boolean);
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
procedure TfFrameProductView.LoadProductData;
var nStr,nHint: string;
    nDS: TDataSet;
    nItem: PDataItem;
begin
  nStr := 'Select pt.*,p.StyleID,StyleName,ColorName,SizeName From $PT pt' +
          ' Left Join (Select ProductID,StyleName,dpt.StyleID From $DPT dpt' +
          '  Left Join $ST st On st.StyleID=dpt.StyleID' +
          ' ) p On ProductID=pt.P_ID' +
          ' Left Join $CR cr On cr.ColorID=P_Color ' +
          ' Left Join $SZ sz on sz.SizeID=P_Size ' +
          'Where P_TerminalID=''$ID'' ' +
          'Order By p.StyleID,ColorName,SizeName';
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

//Desc: �����Ʒ�б�����
procedure TfFrameProductView.LoadProductList;
var i,nIdx,nInt: Integer;
    nList: TStrings;
    nBtn: TcxButton;
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

          nBtn := TcxButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Caption := '����';
            Width := 35;
            Height := 18;

            Enabled := gSysParam.FIsAdmin;
            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end;

          nBtn := TcxButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Caption := '��ϸ';
            Width := 35;
            Height := 18;

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

//Desc: ͳ��ָ����ʽ�Ŀ������
function TfFrameProductView.CountNumber(const nID: string): Integer;
var nIdx: Integer;
begin
  Result := 0;

  for nIdx:=FData.Count - 1 downto 0 do
   with PDataItem(FData[nIdx])^ do
    if FStyle = nID then Result := Result + FNumber;
  //xxxxx
end;

//Desc: �鿴����
procedure TfFrameProductView.OnBtnClick(Sender: TObject);
var nStr,nID: string;
    nIdx,nNum,nInt: Integer;
    nRow: TGridExDataArray;
    nCol: TGridExColDataArray;
begin
  nNum := TComponent(Sender).Tag;
  if Sender = FPainter.Data[nNum][3].FCtrls[0] then
  begin
    ShowProductPriceForm(FPainter.Data[nNum][4].FText);
    Exit;
  end; //����

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
      SetLength(nRow, 3);
      for nInt:=Low(nRow) to High(nRow) do
      begin
        nRow[nInt].FCtrls := nil;
        nRow[nInt].FAlign := taCenter;
      end;

      nRow[0].FText := FSize;
      nRow[1].FText := IntToStr(FNumber);
      nRow[2].FText := FTime;

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

initialization
  gControlManager.RegCtrl(TfFrameProductView, TfFrameProductView.FrameID);
end.
