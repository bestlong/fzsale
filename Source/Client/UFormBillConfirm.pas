{*******************************************************************************
  ����: dmzn@163.com 2011-11-30
  ����: ��Ʒ����ȷ��
*******************************************************************************}
unit UFormBillConfirm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, StdCtrls,
  UImageButton, Grids, UGridPainter, cxCheckBox, cxMaskEdit,
  cxDropDownEdit, UGridExPainter, Menus, cxButtons;

type
  TfFormBillConfirm = class(TSkinFormBase)
    LabelHint: TLabel;
    GridList: TDrawGridEx;
    Panel1: TPanel;
    Panel2: TPanel;
    BtnOK: TImageButton;
    BtnCancel: TImageButton;
    Label1: TLabel;
    EditID: TcxTextEdit;
    Label2: TLabel;
    EditMan: TcxTextEdit;
    Label3: TLabel;
    EditTime: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FBillID,FBillMan,FBillTime: string;
    //������Ϣ
    FPainter: TGridPainter;
    //���ƶ���
    procedure LoadBillInfo(const nBill: string);
    //������Ϣ
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowBillConfirmForm(const nBill: string): Boolean;
//����ȷ��

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule, FZSale_Intf;

function ShowBillConfirmForm(const nBill: string): Boolean;
begin
  with TfFormBillConfirm.Create(Application) do
  begin
    LoadBillInfo(nBill);
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormBillConfirm.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormBillConfirm.FormCreate(Sender: TObject);
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
    AddHeader('��Ʒ����', 50);
    AddHeader('��ǰ������', 50);
    AddHeader('������', 50);
    AddHeader('������', 50);
    AddHeader('����ʱ��', 50);
    AddHeader('Ԥ�Ƶ���', 50);
  end;

  LoadFormConfig(Self);
  LoadDrawGridConfig(Name, GridList);
end;

procedure TfFormBillConfirm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveDrawGridConfig(Name, GridList);
  FPainter.Free;
end;

procedure TfFormBillConfirm.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: ������ťλ��
procedure TfFormBillConfirm.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 65 + BtnCancel.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnCancel.Left := nL + BtnOK.Width + 65;
end;

//------------------------------------------------------------------------------
//Desc: ���붩����Ϣ
procedure TfFormBillConfirm.LoadBillInfo(const nBill: string);
var nStr,nHint: string;
    nDS: TDataSet;
    nIdx: Integer;
    nData: TGridDataArray;
begin
  if nBill = '' then
  begin
    nStr := 'Select Top 1 * From %s Where O_Status=''%s'' And ' +
            'O_TerminalId=''%s'' Order By R_ID DESC';
    nStr := Format(nStr, [sTable_Order, sFlag_BillLock, gSysParam.FTerminalID]);
  end else
  begin
    nStr := 'Select * From %s Where O_ID=''%s'' And ' +
            '(O_Status=''%s'' or O_Status=''%s'') ';
    nStr := Format(nStr, [sTable_Order, nBill, sFlag_BillLock, sFlag_BillNew]);
  end;

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    if nDS.RecordCount > 0 then
    begin
      FBillID := nDS.FieldByName('O_ID').AsString;
      FBillMan := nDS.FieldByName('O_Man').AsString;
      FBillTime := DateTime2Str(nDS.FieldByName('O_Date').AsDateTime);
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;

  if FBillID = '' then
  begin
    ShowMsg('û�д�ȷ�ϵĶ���', sHint);
    Exit;
  end;

  EditID.Text := FBillID;
  EditMan.Text := FBillMan;
  EditTime.Text := FBillTime;

  nStr := 'Select * From $OD od ' +
          ' Left Join (Select ProductID,pt.StyleID,pt.ColorID,pt.SizeID,' +
          '  StyleName,SizeName,ColorName From $PT pt' +
          '  Left Join $SZ sz On sz.SizeID=pt.SizeID' +
          '  Left Join $CR cr On cr.ColorID=pt.ColorID' +
          '  Left Join $ST st On st.StyleID=pt.StyleID' +
          ' ) pt On pt.ProductID=D_Product ' +
          'Where D_Order=''$ID'' Order by R_ID';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$OD', sTable_OrderDtl), MI('$PT', sTable_DL_Product),
          MI('$SZ', sTable_DL_Size), MI('$CR', sTable_DL_Color),
          MI('$ST', sTable_DL_Style), MI('$ID', FBillID)]);
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
      nStr := FieldByName('StyleName').AsString;
      LabelHint.Caption := Format('%s��ʽ������ȷ��', [nStr]);


      while not Eof do
      begin
        SetLength(nData, 11);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nStr := Format('%s_%s_%s', [FieldByName('StyleName').AsString,
                FieldByName('ColorName').AsString,
                FieldByName('SizeName').AsString]);
        //xxxxx

        nData[0].FText := FieldByName('R_ID').AsString;
        nData[1].FText := nStr;
        nData[2].FText := Format('%.2f', [FieldByName('D_Price').AsFloat]);
        nData[3].FText := FBillMan;
        nData[4].FText := FieldByName('D_Number').AsString;
        nData[5].FText := FBillTime;
        nData[6].FText := FBillTime;

        nData[7].FText := FieldByName('D_Product').AsString;
        nData[8].FText := FieldByName('StyleID').AsString;
        nData[9].FText := FieldByName('ColorID').AsString;
        nData[10].FText := FieldByName('SizeID').AsString;
        FPainter.AddData(nData);
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: ȷ��
procedure TfFormBillConfirm.BtnOKClick(Sender: TObject);
var nStr,nHint: string;
    nIdx: Integer;
    nSQLList: SQLItems;
begin
  nStr := 'Ҫȷ�ϱ��Ϊ[ %s ]�Ķ�����?' + #32#32#13#10#13#10 +
          'ֻ��ͨ��ȷ�ϵĶ���,�����̲Żᷢ��.';
  nStr := Format(nStr, [FBillID]);
  if not QueryDlg(nStr, sAsk, Handle) then Exit;

  nSQLList := SQLItems.Create;
  try
    nStr := 'Update %s Set O_Status=''%s'',O_ActDate=%s Where O_ID=''%s''';
    nStr := Format(nStr, [sTable_Order, sFlag_BillNew, sField_SQLServer_Now, FBillID]);

    with nSQLList.Add do
    begin
      SQL := nStr;
      IfRun := '';
      IfType := 0;
    end;

    nStr := MakeSQLByStr([SF('TerminalId', gSysParam.FTerminalID),
            SF('Lid', FBillID), SF('OrderState', '0', sfVal),
            SF('CreateTime', sField_SQLServer_Now, sfVal),
            SF('ActualCount', '0', sfVal), SF('SpId', '0', sfVal)
            ], sTable_DL_Order, '', True);
    //xxxxx

    with nSQLList.Add do
    begin
      SQL := nStr;
      IfRun := '';
      IfType := 0;
    end;

    for nIdx:=0 to FPainter.DataCount - 1 do
    begin
      nStr := MakeSQLByStr([SF('ProId', FPainter.Data[nIdx][7].FText),
              SF('StyleId', FPainter.Data[nIdx][8].FText, sfVal),
              SF('ProCount', FPainter.Data[nIdx][4].FText, sfVal),
              SF('OutCount', FPainter.Data[nIdx][4].FText, sfVal),
              SF('Lid', FBillID), SF('SpId', '0', sfVal)
              ], sTable_DL_OrderDtl, '', True);
      //xxxxx

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := '';
        IfType := 0;
      end; //������

      nStr := MakeSQLByStr([SF('P_ID', FPainter.Data[nIdx][7].FText),
              SF('P_Color', FPainter.Data[nIdx][9].FText, sfVal),
              SF('P_Size', FPainter.Data[nIdx][10].FText, sfVal),
              SF('P_Number', '0', sfVal),
              SF('P_Price', '0', sfVal),
              SF('P_InPrice', '0', sfVal),
              SF('P_TerminalId', gSysParam.FTerminalID),
              SF('P_LastIn', sField_SQLServer_Now, sfVal)
              ], sTable_Product, '', True);
      //xxxxx

      nHint := 'Select P_ID From %s ' +
               'Where P_TerminalId=''%s'' And P_ID=''%s''';
      nHint := Format(nHint, [sTable_Product, gSysParam.FTerminalID,
               FPainter.Data[nIdx][7].FText]);
      //where 

      with nSQLList.Add do
      begin
        SQL := nStr;
        IfRun := nHint;
        IfType := 1;
      end; //��Ʒ����ʱ,�����ն˲�Ʒ��
    end;

    if FDM.SQLUpdates(nSQLList, True, nHint) > 0 then
    begin
      ShowMsg('����ȷ�ϳɹ�', sHint);
      ModalResult := mrOk;
    end else ShowDlg(nHint, sWarn, Handle);
  finally
    //nSQLList.Free;
  end;
end;

//Desc: ȡ������
procedure TfFormBillConfirm.BtnCancelClick(Sender: TObject);
var nStr,nHint: string;
begin
  nStr := 'Ҫȡ�����Ϊ[ %s ]�Ķ�����?' + #32#32#13#10#13#10 +
          'ȡ���󶩵�������.';
  nStr := Format(nStr, [FBillID]);
  if not QueryDlg(nStr, sAsk, Handle) then Exit;

  nStr := 'Update %s Set O_Status=''%s'',O_ActDate=%s Where O_ID=''%s''';
  nStr := Format(nStr, [sTable_Order, sFlag_BillCancel, sField_SQLServer_Now, FBillID]);

  if FDM.SQLExecute(nStr, nHint) > 0 then
  begin
    ShowMsg('�����Ѿ�ȡ��', sHint);
    ModalResult := mrOk;
  end else ShowDlg(nHint, sWarn, Handle);
end;

end.
