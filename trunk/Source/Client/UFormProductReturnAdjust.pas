{*******************************************************************************
  ����: dmzn@163.com 2011-11-30
  ����: ��Ʒ�˻�����
*******************************************************************************}
unit UFormProductReturnAdjust;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UGridPainter, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  StdCtrls, ExtCtrls, UImageButton, Grids, UGridExPainter;

type
  TfFormProductReturnAdjust = class(TSkinFormBase)
    GridList: TDrawGridEx;
    Panel1: TPanel;
    BtnOK: TImageButton;
    BtnExit: TImageButton;
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
    FReturnID: string;
    //�˵���
    FPainter: TGridPainter;
    //���ƶ���
    procedure LoadReturnDetail(const nReturn: string);
    //��Ʒ��Ϣ
    procedure OnEditExit(Sender: TObject);
    //������Ч
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowProductReturnAdjust(const nReturn: string): Boolean;
//�����˻���

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule, FZSale_Intf;

function ShowProductReturnAdjust(const nReturn: string): Boolean;
begin
  with TfFormProductReturnAdjust.Create(Application) do
  begin
    FReturnID := nReturn;
    LoadReturnDetail(nReturn);

    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductReturnAdjust.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductReturnAdjust.FormCreate(Sender: TObject);
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
    AddHeader('Ʒ��', 50);
    AddHeader('��Ʒ����', 50);
    AddHeader('���п��', 50);
    AddHeader('ԭ�˻���', 50);
    AddHeader('�ֵ���Ϊ', 50);
  end;

  LoadFormConfig(Self);
  LoadDrawGridConfig(Name, GridList);
end;

procedure TfFormProductReturnAdjust.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
end;

procedure TfFormProductReturnAdjust.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: ������ťλ��
procedure TfFormProductReturnAdjust.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 65 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 65;
end;

//------------------------------------------------------------------------------
//Desc: �����˻���ϸ
procedure TfFormProductReturnAdjust.LoadReturnDetail(const nReturn: string);
var nStr,nHint: string;
    nIdx,nInt: Integer;
    nDS: TDataSet;
    nEdit: TcxTextEdit;
    nLabel: TLabel;
    nData: TGridDataArray;
begin
  nStr := 'Select rd.*,BrandName,StyleName,ColorName,SizeName,D_Number,' +
          'P_Number,T_Man,T_Date From $RD rd ' +
          ' Left Join $PT pt On pt.ProductID=rd.D_Product ' +
          ' Left Join $ST st On st.StyleID=pt.StyleID ' +
          ' Left Join $SZ sz On sz.SizeID=pt.SizeID ' +
          ' Left Join $CR cr On cr.ColorID=pt.ColorID ' +
          ' Left Join $RT rt On rt.T_ID=rd.D_Return ' +
          ' Left Join $BR br On br.BrandID=pt.BrandID ' +
          ' Left Join $DP dp on dp.P_ID=rd.D_Product ' +
          'Where D_Return=''$ID'' Order By StyleName,ColorName,SizeName';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$RD', sTable_ReturnDtl), MI('$ID', nReturn),
          MI('$ST', sTable_DL_Style), MI('$SZ', sTable_DL_Size),
          MI('$CR', sTable_DL_Color), MI('$RT', sTable_Return),
          MI('$BR', sTable_DL_Brand), MI('$PT', sTable_DL_Product),
          MI('$DP', sTable_Product)]);
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

      EditID.Text := FReturnID;
      EditMan.Text := FieldByName('T_Man').AsString;
      EditTime.Text := DateTime2Str(FieldByName('T_Date').AsDateTime);

      while not Eof do
      begin
        SetLength(nData, 8);
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

        nData[3].FText := FieldByName('P_Number').AsString;
        nData[4].FText := FieldByName('D_Number').AsString;

        with nData[5] do
        begin
          FText := '';
          FCtrls := TList.Create;

          nEdit := TcxTextEdit.Create(Self);
          FCtrls.Add(nEdit);

          with nEdit do
          begin
            Width := 42;
            Height := 18;
            Text := nData[4].FText;

            OnExit := OnEditExit;
            Tag := FPainter.DataCount;
          end;

          nLabel := TLabel.Create(Self);
          nLabel.Transparent := True;
          nLabel.Caption := '��';
          FCtrls.Add(nLabel);
        end;

        nData[6].FText := FieldByName('D_Product').AsString;
        nData[7].FText := FieldByName('R_ID').AsString;
        FPainter.AddData(nData);
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: ������Ч
procedure TfFormProductReturnAdjust.OnEditExit(Sender: TObject);
var nTag: Integer;
begin
  with TcxTextEdit(Sender) do
  begin
    if (not IsNumber(Text, False)) or (StrToInt(Text) < 0) then
    begin
      SetFocus;
      ShowMsg('����д��Ч����', sHint); Exit;
    end;

    nTag := TComponent(Sender).Tag;
    if StrToInt(Text) > StrToInt(FPainter.Data[nTag][3].FText) then
    begin
      if not QueryDlg('�˻������Ѿ��������,Ҫ������?', sAsk) then SetFocus;
    end;
  end;
end;

//Desc: ����
procedure TfFormProductReturnAdjust.BtnOKClick(Sender: TObject);
var nStr,nHint: string;
    nIdx,nNum: Integer;
    nSQLList: SQLItems;
begin
  ActiveControl := nil;
  if Assigned(ActiveControl) then Exit;

  nSQLList := SQLItems.Create;
  try
    nNum := 0;
    for nIdx:=0 to FPainter.DataCount - 1 do
    begin
      nStr := TcxTextEdit(FPainter.Data[nIdx][5].FCtrls[0]).Text;
      if IsNumber(nStr, False) and (StrToInt(nStr) > 0) then
        nNum := nNum + StrToInt(nStr);
      //xxxxx
    end;

    if nNum < 1 then
    begin
      nSQLList.Free;
      ShowMsg('�˻�����Ϊ��', sHint); Exit;
    end;

    nStr := 'Update %s Set T_Number=%d Where T_ID=''%s''';
    nStr := Format(nStr, [sTable_Return, nNum, FReturnID]);

    with nSQLList.Add do
    begin
      SQL := nStr;
      IfRun := '';
      IfType := 0;
    end;

    for nIdx:=0 to FPainter.DataCount - 1 do
    begin
      nStr := TcxTextEdit(FPainter.Data[nIdx][5].FCtrls[0]).Text;
      if (not IsNumber(nStr, False)) or (StrToInt(nStr) < 0) then Continue;

      nNum := StrToInt(nStr);
      if nNum = StrToInt(FPainter.Data[nIdx][4].FText) then Continue;
      //�˻�������
      
      nStr := 'Update %s Set D_Number=%d Where R_ID=%s';
      nStr := Format(nStr, [sTable_ReturnDtl, nNum, FPainter.Data[nIdx][7].FText]);

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end;
    end;

    if FDM.SQLUpdates(nSQLList, True, nHint) > -1 then
    begin
      ModalResult := mrOk;
    end else ShowDlg(nHint, sWarn);
  finally
    //nSQLList.Free;
  end;
end;

end.
