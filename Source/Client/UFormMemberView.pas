{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 查看会员信息
*******************************************************************************}
unit UFormMemberView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UGridPainter, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  Grids, UGridExPainter, StdCtrls, ExtCtrls, UImageButton;

type
  TfFormMemberView = class(TSkinFormBase)
    Panel1: TPanel;
    BtnOK: TImageButton;
    Panel2: TPanel;
    LabelHint: TLabel;
    GridList: TDrawGridEx;
    Label1: TLabel;
    EditID: TcxTextEdit;
    Label2: TLabel;
    EditName: TcxTextEdit;
    Label3: TLabel;
    EditSex: TcxTextEdit;
    Label4: TLabel;
    EditPhone: TcxTextEdit;
    Label5: TLabel;
    EditBAddr: TcxTextEdit;
    Label6: TLabel;
    EditAddr: TcxTextEdit;
    Label7: TLabel;
    EditKZ: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridPainter;
    //绘制对象
    procedure LoadMemberInfo(const nMemberID: string);
    //载入信息
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowMemberInfoForm(const nMember: string): Boolean;
//查看会员

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule;

function ShowMemberInfoForm(const nMember: string): Boolean;
begin
  with TfFormMemberView.Create(Application) do
  begin
    LoadMemberInfo(nMember);
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormMemberView.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormMemberView.FormCreate(Sender: TObject);
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
    AddHeader('购物名称', 50);
    AddHeader('件数', 50);
    AddHeader('金额', 50);
    AddHeader('优惠', 50);
    AddHeader('购物时间', 50);
  end;

  LoadFormConfig(Self);
  LoadDrawGridConfig(Name, GridList);
end;

procedure TfFormMemberView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
end;

procedure TfFormMemberView.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormMemberView.Panel1Resize(Sender: TObject);
begin
  BtnOk.Left := Trunc((Panel1.Width - BtnOK.Width) / 2);
end;

//Desc: 读取会员信息
procedure TfFormMemberView.LoadMemberInfo(const nMemberID: string);
var nStr,nHint: string;
    nDS: TDataSet;
    nMon,nDebt,nVal: Double;
    nIdx,nInt,nNum: Integer;
    nData: TGridDataArray;
begin
  nStr := 'Select mb.*,Address From $MB mb ' +
          ' Left Join $TM tm On tm.TerminalID=mb.M_TerminalID ' +
          'Where M_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$MB', sTable_Member),
          MI('$TM', sTable_Terminal), MI('$ID', nMemberID)]);
  //xxxxx

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if (not Assigned(nDS)) or (nDS.RecordCount < 1) then
    begin
      ShowMsg('读取会员信息失败', sHint); Exit;
    end;

    with nDS do
    begin
      First;

      EditID.Text := FieldByName('M_ID').AsString;
      EditName.Text := FieldByName('M_Name').AsString;

      if FieldByName('M_Sex').AsString = sFlag_Male then
           EditSex.Text := '男'
      else EditSex.Text := '女';

      EditPhone.Text := FieldByName('M_Phone').AsString;
      EditBAddr.Text := FieldByName('Address').AsString;
      EditAddr.Text := FieldByName('M_Addr').AsString;

      if FieldByName('M_Limit').AsString = sFlag_Yes then
           EditKZ.Text := '本店使用'
      else EditKZ.Text := '所有连锁店均可';
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;

  //----------------------------------------------------------------------------
  nStr := 'Select dt.*,StyleName,ColorName,SizeName,S_Date From $DT dt ' +
          ' Left Join $PT pt On pt.ProductID=dt.D_Product ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $SL sl On sl.S_ID=dt.D_SaleID ' +
          'Where D_Member=''$ID'' Order By S_Date DESC';
  nStr := MacroValue(nStr, [MI('$DT', sTable_SaleDtl),
          MI('$PT', sTable_DL_Product), MI('$ST', sTable_DL_Style),
          MI('$CR', sTable_DL_Color), MI('$SZ', sTable_DL_Size),
          MI('$SL', sTable_Sale), MI('$ID', nMemberID)]);
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
      nMon := 0;
      nDebt := 0;

      nInt := 1;
      First;

      while not Eof do
      begin
        SetLength(nData, 6);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FText := '';
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);

        nStr := Format('%s_%s_%s', [FieldByName('StyleName').AsString,
                FieldByName('ColorName').AsString, FieldByName('SizeName').AsString]);
        nData[1].FText := nStr;

        nData[2].FText := FieldByName('D_Number').AsString;
        nNum := nNum + FieldByName('D_Number').AsInteger;

        nVal := FieldByName('D_Price').AsFloat;
        nVal := Float2Float(nVal * FieldByName('D_Number').AsInteger, 100);
        nData[3].FText := Format('%.2f', [nVal]);
        nMon := nMon + nVal;

        nData[4].FText := Format('%.2f', [FieldByName('D_DeMoney').AsFloat]);
        nDebt := nDebt + FieldByName('D_DeMoney').AsFloat;
        nData[5].FText := DateTime2Str(FieldByName('S_Date').AsDateTime);

        FPainter.AddData(nData);
        Next;
      end;
    end;

    SetLength(nData, 6);
    for nIdx:=Low(nData) to High(nData) do
    begin
      nData[nIdx].FText := '';
      nData[nIdx].FCtrls := nil;
      nData[nIdx].FAlign := taCenter;
    end;

    nData[0].FText := '总计:';
    nData[2].FText := Format('%d件', [nNum]);
    nData[3].FText := Format('%.2f元', [nMon]);
    nData[4].FText := Format('%.2f元', [nDebt]);
    FPainter.AddData(nData);
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

procedure TfFormMemberView.BtnOKClick(Sender: TObject);
begin
  Close;
end;

end.
