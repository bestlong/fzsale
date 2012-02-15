{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 会员列表
*******************************************************************************}
unit UFrameNotices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, UGridPainter, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, Grids, StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, ExtCtrls,
  UGridExPainter, cxDropDownEdit, cxCalendar, UImageButton;

type
  PNoticeItem = ^TNoticeItem;
  TNoticeItem = record
    FTitle: string;
    FMemo: string;
    FDate: string;
  end;

  TfFrameNotices = class(TfFrameBase)
    Panel2: TPanel;
    Label1: TLabel;
    LabelHint: TLabel;
    GridList: TDrawGridEx;
    EditTime: TcxComboBox;
    EditS: TcxDateEdit;
    EditE: TcxDateEdit;
    BtnSearch: TImageButton;
    procedure EditTimePropertiesEditValueChanged(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridPainter;
    //绘图对象
    FList: TList;
    //列表
    procedure ClearNotices(const nFree: Boolean);
    //清理内容
    procedure LoadNotices(const nWhere: string);
    //载入通告
    procedure OnBtnClick(Sender: TObject);
    //按钮点击
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  DB, ULibFun, UDataModule, UMgrControl, USysFun, USysConst, USysDB,
  UFormNoticeView;

class function TfFrameNotices.FrameID: integer;
begin
  Result := cFI_FrameNotices;
end;

procedure TfFrameNotices.OnCreateFrame;
begin
  Name := MakeFrameName(FrameID);
  FList := TList.Create;
  FPainter := TGridPainter.Create(GridList);

  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('标题', 50);
    AddHeader('内容', 50);
    AddHeader('通告时间', 50);
    AddHeader('查看', 50);
  end;

  EditTime.ItemIndex := 0;
  LoadDrawGridConfig(Name, GridList);

  AdjustLabelCaption(LabelHint, GridList);
  Width := GetGridHeaderWidth(GridList);

  BtnSearch.Top := EditTime.Top + Trunc((EditTime.Height - BtnSearch.Height) / 2);
  LoadNotices('');
end;

procedure TfFrameNotices.OnDestroyFrame;
begin
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
  ClearNotices(True);
end;

procedure TfFrameNotices.ClearNotices(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FList.Count - 1 downto 0 do
  begin
    Dispose(PNoticeItem(FList[nIdx]));
    FList.Delete(nIdx);
  end;

  if nFree then
    FreeAndNil(FList);
  //xxxxx
end;

procedure TfFrameNotices.EditTimePropertiesEditValueChanged(Sender: TObject);
var nS,nE: TDate;
begin
  GetDateInterval(EditTime.ItemIndex, nS, nE);
  EditS.Date := nS;
  EditE.Date := nE;
end;

procedure TfFrameNotices.LoadNotices(const nWhere: string);
var nStr,nHint: string;
    nIdx,nInt: Integer;
    nDS: TDataSet;
    nBtn: TImageButton;
    nItem: PNoticeItem;
    nData: TGridDataArray;
begin
  nStr := 'Select Top 50 * From %s %s Order By CreateTime DESC';
  nStr := Format(nStr, [sTable_DL_Noties, nWhere]);

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    ClearNotices(False);
    FPainter.ClearData;
    if nDS.RecordCount < 1 then Exit;

    with nDS do
    begin
      nInt := 1;
      First;

      while not Eof do
      begin
        New(nItem);
        FList.Add(nItem);

        nItem.FTitle := FieldByName('NoticeTitle').AsString;
        nItem.FMemo := FieldByName('NoticeContent').AsString;
        nItem.FDate := DateTime2Str(FieldByName('CreateTime').AsDateTime);

        SetLength(nData, 5);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FText := '';
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);
        nData[1].FText := nItem.FTitle;

        nData[2].FText := nItem.FMemo;
        nData[3].FText := nItem.FDate;

        with nData[4] do
        begin
          FText := '';
          FAlign := taCenter;
          FCtrls := TList.Create;

          nBtn := TImageButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Parent := Self;
            nBtn.ButtonID := 'btn_view';
            LoadButton(nBtn);

            OnClick := OnBtnClick;
            Tag := FList.Count - 1;
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

//Desc: 按钮处理
procedure TfFrameNotices.OnBtnClick(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  ShowNoticeViewForm(FList[nTag]);
end;

procedure TfFrameNotices.BtnSearchClick(Sender: TObject);
var nStr: string;
begin
  BtnSearch.Enabled := False;
  try
    nStr := 'Where (CreateTime>=''%s'' And CreateTime<''%s'')';
    nStr := Format(nStr, [Date2Str(EditS.Date), Date2Str(EditE.Date+1)]);
    LoadNotices(nStr);
  finally
    BtnSearch.Enabled := True;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameNotices, TfFrameNotices.FrameID);
end.
