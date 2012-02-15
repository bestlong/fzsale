{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 初始化产品
*******************************************************************************}
unit UFrameProductInit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, StdCtrls,
  cxButtons, cxLabel, cxRadioGroup, Grids, UGridPainter, UGridExPainter,
  ExtCtrls, UImageButton;

type
  TfFrameProductInit = class(TfFrameBase)
    LabelHint: TLabel;
    GridProduct: TDrawGridEx;
    procedure BtnExitClick(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridPainter;
    //绘图对象
    procedure LoadProductList;
    //产品列表
    procedure OnBtnClick(Sender: TObject);
    //点击按钮
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UDataModule, DB, UMgrControl, USysConst, USysDB, USysFun,
  UFormProductInit;

class function TfFrameProductInit.FrameID: integer;
begin
  Result := cFI_FrameProductInit;
end;

procedure TfFrameProductInit.OnCreateFrame;
begin
  Name := MakeFrameName(FrameID);
  FPainter := TGridPainter.Create(GridProduct);
  
  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('款式名称', 50);
    AddHeader('操作', 50);
  end;

  LoadDrawGridConfig(Name, GridProduct);
  AdjustLabelCaption(LabelHint, GridProduct);
  Width := GetGridHeaderWidth(GridProduct);
  LoadProductList;
end;

procedure TfFrameProductInit.OnDestroyFrame;
begin
  FPainter.Free;
  SaveDrawGridConfig(Name, GridProduct);
end;

procedure TfFrameProductInit.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 载入产品列表
procedure TfFrameProductInit.LoadProductList;
var nStr,nHint: string;
    nDS: TDataSet;
    nIdx,nInt: Integer;
    nBtn: TImageButton;
    nData: TGridDataArray;
begin
  nStr := 'Select Distinct pt.StyleID,StyleName From $PT pt ' +
          ' Left Join $ST st On pt.StyleID=st.StyleID ' +
          'Where pt.BrandId In (Select tr.BrandID From $TR tr ' +
          ' Where TerminalID=''$ID'') ' +
          'Order By pt.StyleID';
  nStr := MacroValue(nStr, [MI('$PT', sTable_DL_Product), MI('$ST', sTable_DL_Style),
          MI('$TR', sTable_Terminal), MI('$ID', gSysParam.FTerminalID)]);
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
      nInt := 1;
      First;

      while not Eof do
      begin
        SetLength(nData, 4);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FText := '';
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);
        nData[3].FText := FieldByName('StyleID').AsString;
        nData[1].FText := FieldByName('StyleName').AsString;

        with nData[2] do
        begin
          FText := '';
          FAlign := taCenter;
          FCtrls := TList.Create;

          nBtn := TImageButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Parent := Self;
            ButtonID := 'btn_in_goods';
            LoadButton(nBtn);

            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end;
        end;

        FPainter.AddData(nData);
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 入库操作
procedure TfFrameProductInit.OnBtnClick(Sender: TObject);
var nStr: string;
begin
  with TcxButton(Sender) do
    nStr := FPainter.Data[Tag][3].FText;
  ShowProductInitForm(nStr);
end;

initialization
  gControlManager.RegCtrl(TfFrameProductInit, TfFrameProductInit.FrameID);
end.
