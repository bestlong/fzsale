{*******************************************************************************
  ����: dmzn@163.com 2011-11-30
  ����: ��Ʒ����
*******************************************************************************}
unit UFormProductPrice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, StdCtrls,
  UImageButton, Grids, UGridExPainter, cxCheckBox, cxMaskEdit,
  cxDropDownEdit;

type
  TfFormProductPrice = class(TSkinFormBase)
    LabelHint: TLabel;
    GridList: TDrawGridEx;
    Panel1: TPanel;
    BtnOK: TImageButton;
    BtnExit: TImageButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridExPainter;
    //���ƶ���
    FSaleSame: Boolean;
    //��־
    procedure LoadProductList(const nStyleID: string);
    //��Ʒ��Ϣ
    procedure OnComboChanged(Sender: TObject);
    //������
    procedure OnCheckClick(Sender: TObject);
    //��ѡ
    procedure OnEditExit(Sender: TObject);
    //������Ч
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowProductPriceForm(const nStyleID: string): Boolean;
//����˻�

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule, FZSale_Intf;

function ShowProductPriceForm(const nStyleID: string): Boolean;
begin
  with TfFormProductPrice.Create(Application) do
  begin
    LoadProductList(nStyleID);
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProductPrice.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormProductPrice.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  FSaleSame := False;

  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx

  FPainter := TGridExPainter.Create(GridList);
  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //����

    AddHeader('��ʽ����', 50, True);
    AddHeader('��ɫ', 50, True);
    AddHeader('����', 50);
    AddHeader('���п��', 50);
    AddHeader('������', 50);
    AddHeader('���ۼ�', 50);
    AddHeader('������', 50);
  end;

  LoadFormConfig(Self);
  LoadDrawGridConfig(Name, GridList);
end;

procedure TfFormProductPrice.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
end;

procedure TfFormProductPrice.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: ������ťλ��
procedure TfFormProductPrice.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 65 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 65;
end;

//------------------------------------------------------------------------------
//Desc: ����ִ�в�Ʒ��Ϣ
procedure TfFormProductPrice.LoadProductList(const nStyleID: string);
var nStr,nHint: string;
    nInt,nNum: Integer;
    nDS: TDataSet;
    nLabel: TLabel;
    nCombo: TcxComboBox;
    nCheck: TcxCheckBox;
    nEdit: TcxTextEdit;
    nRow: TGridExDataArray;
    nCol: TGridExColDataArray;
begin
  nStr := 'Select pt.*,p.StyleID,StyleName,ColorName,SizeName From $PT pt' +
          ' Left Join (Select ProductID,StyleName,dpt.StyleID From $DPT dpt' +
          '  Left Join $ST st On st.StyleID=dpt.StyleID' +
          ' ) p On ProductID=pt.P_ID' +
          ' Left Join $CR cr On cr.ColorID=P_Color ' +
          ' Left Join $SZ sz on sz.SizeID=P_Size ' +
          'Where P_TerminalID=''$ID'' And p.StyleID=''$SID'' ' +
          'Order By ColorName,SizeName';
  //xxxxx
  
  nStr := MacroValue(nStr, [MI('$PT', sTable_Product), MI('$DPT', sTable_DL_Product),
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

    FPainter.ClearData;
    if nDS.RecordCount < 1 then Exit;

    with nDS do
    begin
      SetLength(nRow, 5);
      for nInt:=0 to 2 do
      with nRow[nInt] do
      begin
        FText := '';
        FCtrls := nil;
      end;

      with nRow[3] do
      begin
        FText := '';
        FAlign := taCenter;
        FCtrls := TList.Create;

        nLabel := TLabel.Create(Self);
        FCtrls.Add(nLabel);

        nLabel.Transparent := True;
        nLabel.Caption := '�ۿ�';
        
        nCombo := TcxComboBox.Create(Self);
        FCtrls.Add(nCombo);

        with nCombo do
        begin
          Width := 50;
          Height := 22;
          Properties.DropDownRows := 15;
          Properties.OnEditValueChanged := OnComboChanged;

          with Properties.Items do
          begin
            Add('9.9');
            Add('9.5');
            Add('9.0');
            Add('8.0');
            Add('7.5');
            Add('7.0');
            Add('6.5');
            Add('5.0');
          end;
        end;
      end;

      with nRow[4] do
      begin
        FText := '';
        FAlign := taCenter;
        FCtrls := TList.Create;

        nLabel := TLabel.Create(Self);
        FCtrls.Add(nLabel);

        nLabel.Transparent := True;
        nLabel.Caption := '��ͬ';
        
        nCheck := TcxCheckBox.Create(Self);
        FCtrls.Add(nCheck);

        with nCheck do
        begin
          Width := 32;
          Height := 22;

          Transparent := True;
          OnClick := OnCheckClick;
        end;
      end;

      FPainter.AddRowData(nRow);
      //������п���

      //------------------------------------------------------------------------
      First;
      nStr := FieldByName('StyleName').AsString;
      LabelHint.Caption := Format('%s��ʽ�۸����', [nStr]);

      SetLength(nCol, 1);
      with nCol[0] do
      begin
        FCol := 0;
        FRows := RecordCount + 1;
        FAlign := taCenter;
        FText := FieldByName('StyleName').AsString;
      end;
      FPainter.AddColData(nCol);

      nHint := '';
      nNum := 1;

      while not Eof do
      begin
        SetLength(nRow, 8);
        for nInt:=Low(nRow) to High(nRow) do
        begin
          nRow[nInt].FCtrls := nil;
          nRow[nInt].FAlign := taCenter;
        end;

        nRow[0].FText := FieldByName('SizeName').AsString;
        nRow[1].FText := IntToStr(FieldByName('P_Number').AsInteger);
        nRow[2].FText := Format('%.2f', [FieldByName('P_InPrice').AsFloat]);
        nRow[3].FText := Format('%.2f', [FieldByName('P_Price').AsFloat]);

        with nRow[4] do
        begin
          FText := '';
          FAlign := taCenter;
          FCtrls := TList.Create;

          nLabel := TLabel.Create(Self);
          nLabel.Transparent := True;
          nLabel.Caption := '��';
          FCtrls.Add(nLabel);

          nEdit := TcxTextEdit.Create(Self);
          FCtrls.Add(nEdit);

          with nEdit do
          begin
            Text := '0';
            Width := 52;
            Height := 18;
            OnExit := OnEditExit;
          end;

          nLabel := TLabel.Create(Self);
          nLabel.Transparent := True;
          nLabel.Caption := 'Ԫ';
          FCtrls.Add(nLabel);
        end;

        nRow[5].FText := FieldByName('P_Color').AsString;
        nRow[6].FText := FieldByName('P_Size').AsString;
        nRow[7].FText := FieldByName('P_ID').AsString;
        FPainter.AddRowData(nRow);
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
          FCol := 1;
          FRows := nNum;
          FAlign := taCenter;
          FText := nHint;

          nNum := 1;
          nHint := FieldByName('ColorName').AsString;
        end;

        FPainter.AddColData(nCol);
        Next;
      end;
    end;

    if nNum > 0 then
    begin
      SetLength(nCol, 1);
      with nCol[0] do
      begin
        FCol := 1;
        FRows := nNum;
        FAlign := taCenter;
        FText := nHint;
      end;
      FPainter.AddColData(nCol);
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: �������ۿ�
procedure TfFormProductPrice.OnComboChanged(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nVal,nTmp: Double;
begin
  nStr := TcxComboBox(Sender).Text;
  if not IsNumber(nStr, True) then
  begin
    ActiveControl := TcxComboBox(Sender);
    ShowMsg('�ۿ���Ч', sHint); Exit;
  end;

  nVal := StrToFloat(nStr);
  if nVal <= 0 then
  begin
    ActiveControl := TcxComboBox(Sender);
    ShowMsg('�ۿ�Ϊ">0"��С��', sHint); Exit;
  end;

  for nIdx:=1 to FPainter.DataCount - 1 do
  begin
    nTmp := StrToFloat(FPainter.Data[nIdx][3].FText);
    nTmp := RegularMoney(nTmp * nVal / 10);

    nStr := Format('%.2f', [nTmp]);
    TcxTextEdit(FPainter.Data[nIdx][4].FCtrls[1]).Text := nStr;
  end;

  GridList.Invalidate;
end;

//Desc: ��ѡ
procedure TfFormProductPrice.OnCheckClick(Sender: TObject);
begin
  with TcxCheckBox(Sender) do
  begin
    FSaleSame := Checked;
  end;
end;

//Desc: �����˳�,������Ч
procedure TfFormProductPrice.OnEditExit(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nEdit: TcxTextEdit;
begin
  with TcxTextEdit(Sender) do
  begin
    if (not IsNumber(Text, True)) or (StrToFloat(Text) < 0) then
    begin
      SetFocus;
      ShowMsg('����д��Ч����', sHint); Exit;
    end;

    if not FSaleSame then Exit;
    nStr := Format('%.2f', [StrToFloat(Text)]);

    for nIdx:=1 to FPainter.DataCount - 1 do
    begin
      nEdit := TcxTextEdit(FPainter.Data[nIdx][4].FCtrls[1]);
      nEdit.Text := nStr;
    end;
  end;
end;

//Desc: ����
procedure TfFormProductPrice.BtnOKClick(Sender: TObject);
var nStr, nHint: string;
    nIdx: Integer;
    nSQLList: SQLItems;
begin
  ActiveControl := nil;
  nSQLList := SQLItems.Create;
  try
    for nIdx:=1 to FPainter.DataCount - 1 do
    begin
      nStr := TcxTextEdit(FPainter.Data[nIdx][4].FCtrls[1]).Text;
      if (not IsNumber(nStr, True)) or (StrToFloat(nStr) <= 0) then Continue;

      nHint := 'P_TerminalId=''$TER'' And P_ID=''$ID'' And P_Size=''$SZ'' And ' +
               'P_Color=''$CR''';
      nHint := MacroValue(nHint, [MI('$TER', gSysParam.FTerminalID),
               MI('$CR', FPainter.Data[nIdx][5].FText),
               MI('$SZ', FPainter.Data[nIdx][6].FText),
               MI('$ID', FPainter.Data[nIdx][7].FText)]);
      //where

      nStr := MakeSQLByStr([SF('R_Sync', sFlag_SyncW),
              SF('P_OldPrice', 'P_Price', sfVal),
              SF('P_Price', TcxTextEdit(FPainter.Data[nIdx][4].FCtrls[1]).Text)
              ], sTable_Product, nHint, False);
      //insert sql

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0; 
      end;
    end;

    if FDM.SQLUpdates(nSQLList, True, nHint) > -1 then
    begin
      ShowMsg('�������', sHint);
      ModalResult := mrOk;
    end else ShowDlg(nHint, sWarn);
  finally
    //nSQLList.Free;
  end;
end;

end.
