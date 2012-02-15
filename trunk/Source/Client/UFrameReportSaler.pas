{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 销售员业绩
*******************************************************************************}
unit UFrameReportSaler;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, StdCtrls,
  cxButtons, cxLabel, cxRadioGroup, Grids, UGridPainter, UGridExPainter,
  ExtCtrls, cxMaskEdit, cxButtonEdit, cxDropDownEdit, cxCalendar,
  UImageButton;

type
  TfFrameReportSaler = class(TfFrameBase)
    GridList: TDrawGridEx;
    Panel2: TPanel;
    LabelHint: TLabel;
    EditTime: TcxComboBox;
    EditS: TcxDateEdit;
    EditE: TcxDateEdit;
    Label1: TLabel;
    BtnSearch: TImageButton;
    procedure EditNowPropertiesEditValueChanged(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridPainter;
    //绘制对象
    procedure LoadSaleTotal;
    //载入明细
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
  IniFiles, ULibFun, UDataModule, DB, UMgrControl, USysConst, USysDB, USysFun,
  UFormReportSalerView;

class function TfFrameReportSaler.FrameID: integer;
begin
  Result := cFI_FrameReportYJ;
end;

procedure TfFrameReportSaler.OnCreateFrame;
var nIni: TIniFile;
begin
  Name := MakeFrameName(FrameID);
  FPainter := TGridPainter.Create(GridList);

  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('营销员', 50);
    AddHeader('总销量', 50);
    AddHeader('总金额', 50);
    AddHeader('详细查询', 50);
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadDrawGridConfig(Name, GridList, nIni);
    AdjustLabelCaption(LabelHint, GridList);

    Width := GetGridHeaderWidth(GridList);
    EditTime.ItemIndex := 0;
    BtnSearch.Top := EditTime.Top + Trunc((EditTime.Height - BtnSearch.Height) / 2);
  finally
    nIni.Free;
  end;
end;

procedure TfFrameReportSaler.OnDestroyFrame;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveDrawGridConfig(Name, GridList, nIni);
  finally
    nIni.Free;
  end;

  FPainter.Free;
end;

//------------------------------------------------------------------------------
//Desc: 时间变动
procedure TfFrameReportSaler.EditNowPropertiesEditValueChanged(Sender: TObject);
var nS,nE: TDate;
begin
  GetDateInterval(EditTime.ItemIndex, nS, nE);
  EditS.Date := nS;
  EditE.Date := nE;
end;

procedure TfFrameReportSaler.LoadSaleTotal;
var nStr,nHint: string;
    nDS: TDataSet;
    nMon: Double;
    nIdx,nInt,nNum: Integer;
    nBtn: TImageButton;
    nData: TGridDataArray;
begin
  nStr := 'Select S_Man,Sum(S_Number) as S_Num,Sum(S_Money) as S_Mon From $SL ' +
          'Where S_TerminalID=''$ID'' And ' +
          ' (S_Date>=''$KS'' And S_Date<''$JS'') ' +
          'Group By S_Man Order By S_Man';
  nStr := MacroValue(nStr, [MI('$SL', sTable_Sale),
          MI('$ID', gSysParam.FTerminalID),
          MI('$KS', Date2Str(EditS.Date)), MI('$JS', Date2Str(EditE.Date + 1))]);
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
      nMon := 0;
      nNum := 0;
      nInt := 1;
      First;

      while not Eof do
      begin
        SetLength(nData, 5);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FText := '';
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);

        nData[1].FText := FieldByName('S_Man').AsString;
        nData[2].FText := FieldByName('S_Num').AsString;
        nNum := nNum + FieldByName('S_Num').AsInteger;
        nData[3].FText := FieldByName('S_Mon').AsString;
        nMon := nMon + FieldByName('S_Mon').AsFloat;

        with nData[4] do
        begin
          FCtrls := TList.Create;
          nBtn := TImageButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Parent := Self;
            ButtonID := 'btn_view_detail';
            LoadButton(nBtn);

            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end;
        end;

        FPainter.AddData(nData);
        Next;
      end;
    end;

    SetLength(nData, 8);
    for nIdx:=Low(nData) to High(nData) do
    begin
      nData[nIdx].FText := '';
      nData[nIdx].FCtrls := nil;
      nData[nIdx].FAlign := taCenter;
    end;

    nData[0].FText := '总计:';
    nData[2].FText := Format('%d件', [nNum]);
    nData[3].FText := Format('%.2f元', [nMon]);
    FPainter.AddData(nData);
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 查询
procedure TfFrameReportSaler.BtnSearchClick(Sender: TObject);
begin
  BtnSearch.Enabled := False;
  try
    LoadSaleTotal;
  finally
    BtnSearch.Enabled := True;
  end;
end;

//Desc: 查看详情
procedure TfFrameReportSaler.OnBtnClick(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  ShowSalerSale(FPainter.Data[nTag][1].FText, EditS.Date, EditE.Date);
end;

initialization
  gControlManager.RegCtrl(TfFrameReportSaler, TfFrameReportSaler.FrameID);
end.
