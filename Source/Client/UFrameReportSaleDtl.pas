{*******************************************************************************
  ����: dmzn@163.com 2011-11-21
  ����: ������ϸ
*******************************************************************************}
unit UFrameReportSaleDtl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, StdCtrls,
  cxButtons, cxLabel, cxRadioGroup, Grids, UGridPainter, UGridExPainter,
  ExtCtrls, cxMaskEdit, cxButtonEdit, cxDropDownEdit, cxCalendar,
  UImageButton;

type
  TfFrameReportSaleDtl = class(TfFrameBase)
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
    //���ƶ���
    procedure LoadSaleDtl;
    //������ϸ
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UDataModule, DB, UMgrControl, USysConst, USysDB, USysFun;

class function TfFrameReportSaleDtl.FrameID: integer;
begin
  Result := cFI_FrameReportMX;
end;

procedure TfFrameReportSaleDtl.OnCreateFrame;
var nIni: TIniFile;
begin
  Name := MakeFrameName(FrameID);
  FPainter := TGridPainter.Create(GridList);

  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //����

    AddHeader('���', 50);
    AddHeader('��ʽ����', 50);
    AddHeader('��ɫ', 50);
    AddHeader('����', 50);
    AddHeader('����', 50);     
    AddHeader('��Ա����', 50);
    AddHeader('Ӫ��Ա', 50);
    AddHeader('Ӫ��ʱ��', 50);
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

procedure TfFrameReportSaleDtl.OnDestroyFrame;
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
//Desc: ʱ��䶯
procedure TfFrameReportSaleDtl.EditNowPropertiesEditValueChanged(Sender: TObject);
var nS,nE: TDate;
begin
  GetDateInterval(EditTime.ItemIndex, nS, nE);
  EditS.Date := nS;
  EditE.Date := nE;
end;

procedure TfFrameReportSaleDtl.LoadSaleDtl;
var nStr,nHint: string;
    nDS: TDataSet;
    nIdx,nInt,nNum: Integer;
    nData: TGridDataArray;
begin
  nStr := 'Select dt.*,StyleName,ColorName,SizeName,M_Name, ' +
          'S_Man,S_Date From $DT dt ' +
          ' Left Join $PT pt On pt.ProductID=dt.D_Product ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $SL sl On sl.S_ID=dt.D_SaleID ' +
          ' Left Join $MM mm On mm.M_ID=dt.D_Member ' +
          'Where S_TerminalID=''$ID'' And (S_Date>=''$KS'' And S_Date<''$JS'') ' +
          'Order By S_Date DESC';
  nStr := MacroValue(nStr, [MI('$DT', sTable_SaleDtl),
          MI('$PT', sTable_DL_Product), MI('$ST', sTable_DL_Style),
          MI('$CR', sTable_DL_Color), MI('$SZ', sTable_DL_Size),
          MI('$SL', sTable_Sale), MI('$MM', sTable_Member),
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
      nNum := 0;
      nInt := 1;
      First;

      while not Eof do
      begin
        SetLength(nData, 8);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FText := '';
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);

        nData[1].FText := FieldByName('StyleName').AsString;
        nData[2].FText := FieldByName('ColorName').AsString;
        nData[3].FText := FieldByName('SizeName').AsString;

        nData[4].FText := FieldByName('D_Number').AsString;
        nNum := nNum + FieldByName('D_Number').AsInteger;
        nData[5].FText := FieldByName('M_Name').AsString;


        nData[6].FText := FieldByName('S_Man').AsString;
        nData[7].FText := DateTime2Str(FieldByName('S_Date').AsDateTime);

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

    nData[0].FText := Format('�ܼ�: %d��', [nInt - 1]);
    nData[4].FText := Format('%d��', [nNum]);
    FPainter.AddData(nData);
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: ��ѯ
procedure TfFrameReportSaleDtl.BtnSearchClick(Sender: TObject);
begin
  BtnSearch.Enabled := False;
  try
    LoadSaleDtl;
  finally
    BtnSearch.Enabled := True;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameReportSaleDtl, TfFrameReportSaleDtl.FrameID);
end.
