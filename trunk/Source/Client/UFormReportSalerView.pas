{*******************************************************************************
  ����: dmzn@163.com 2011-11-30
  ����: ����Ա������ϸ
*******************************************************************************}
unit UFormReportSalerView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UGridPainter, ExtCtrls, UImageButton, Grids,
  UGridExPainter, StdCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit;

type
  TfFormReportSalerView = class(TSkinFormBase)
    GridList: TDrawGridEx;
    Panel1: TPanel;
    BtnOK: TImageButton;
    Panel2: TPanel;
    Label1: TLabel;
    EditDate: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridPainter;
    //���ƶ���
    procedure ShowSaleDtl(const nSaler: string; nS,nE: TDate);
    //������ϸ
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowSalerSale(const nSaler: string; nS,nE: TDate): Boolean;
//������ϸ

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule;

function ShowSalerSale(const nSaler: string; nS,nE: TDate): Boolean;
begin
  with TfFormReportSalerView.Create(Application) do
  begin
    ShowSaleDtl(nSaler, nS, nE);
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormReportSalerView.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormReportSalerView.FormCreate(Sender: TObject);
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

  LoadFormConfig(Self);
  LoadDrawGridConfig(Name, GridList);
end;

procedure TfFormReportSalerView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
end;

procedure TfFormReportSalerView.BtnOKClick(Sender: TObject);
begin
  Close;
end;

//Desc: ������ťλ��
procedure TfFormReportSalerView.Panel1Resize(Sender: TObject);
begin
  BtnOk.Left := Trunc((Panel1.Width - BtnOK.Width) / 2);
end;

procedure TfFormReportSalerView.ShowSaleDtl(const nSaler: string; nS,
  nE: TDate);
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
          'Where S_TerminalID=''$ID'' And S_Man=''$Man'' And ' +
          ' (S_Date>=''$KS'' And S_Date<''$JS'') ' +
          'Order By S_Date DESC';
  nStr := MacroValue(nStr, [MI('$DT', sTable_SaleDtl),
          MI('$PT', sTable_DL_Product), MI('$ST', sTable_DL_Style),
          MI('$CR', sTable_DL_Color), MI('$SZ', sTable_DL_Size),
          MI('$SL', sTable_Sale), MI('$MM', sTable_Member),
          MI('$ID', gSysParam.FTerminalID), MI('$Man', nSaler),
          MI('$KS', Date2Str(nS)), MI('$JS', Date2Str(nE + 1))]);
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

    EditDate.Text := Format('%s��%s  ��������Ʒ %d ��', [Date2Str(nS),
                     Date2Str(nE), nNum]);
    //xxxxx
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

end.
