{*******************************************************************************
  ����: dmzn@163.com 2011-11-21
  ����: �鿴��Ʒ����
*******************************************************************************}
unit UFrameProductBill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, StdCtrls,
  cxButtons, cxLabel, cxRadioGroup, Grids, UGridPainter, UGridExPainter,
  ExtCtrls;

type
  TfFrameProductBill = class(TfFrameBase)
    LabelHint: TLabel;
    GridBill: TDrawGridEx;
    procedure BtnExitClick(Sender: TObject);
  private
    { Private declarations }
    FPainter: TGridPainter;
    //��ͼ����
    procedure LoadBillList;
    //��Ʒ�б�
    procedure OnBtnClick(Sender: TObject);
    procedure OnBtnClick2(Sender: TObject);
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
  UFormBillConfirm, UFormProductBillAdjust, UFormProductBillView;

class function TfFrameProductBill.FrameID: integer;
begin
  Result := cFI_FrameBillView;
end;

procedure TfFrameProductBill.OnCreateFrame;
var nIni: TIniFile;
begin
  Name := MakeFrameName(FrameID);
  FPainter := TGridPainter.Create(GridBill);

  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //����

    AddHeader('���', 50);
    AddHeader('����״̬', 50);
    AddHeader('�������', 50);
    AddHeader('��������', 50);
    AddHeader('�ջ�����', 50);
    AddHeader('������', 50);
    AddHeader('����ʱ��', 50);
    AddHeader('�ϴβ���ʱ��', 50);
    AddHeader('����', 50);
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadDrawGridConfig(Name, GridBill, nIni);
    AdjustLabelCaption(LabelHint, GridBill);
    Width := GetGridHeaderWidth(GridBill);
  finally
    nIni.Free;
  end;

  LoadBillList;
end;

procedure TfFrameProductBill.OnDestroyFrame;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveDrawGridConfig(Name, GridBill, nIni);
  finally
    nIni.Free;
  end;

  FPainter.Free;
end;

procedure TfFrameProductBill.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: ���붩���б�
procedure TfFrameProductBill.LoadBillList;
var nStr,nHint: string;
    nDS: TDataSet;
    nIdx,nInt: Integer;
    nBtn: TcxButton;
    nData: TGridDataArray;
begin
  nStr := 'Select Top 50 *,%s as O_Now From %s ' +
          'Where O_TerminalId=''%s'' Order By R_ID DESC';
  nStr := Format(nStr, [sField_SQLServer_Now, sTable_Order, gSysParam.FTerminalID]);

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
        SetLength(nData, 9);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);
        
        nStr := FieldByName('O_Status').AsString;
        nData[1].FText := BillStatusDesc(nStr);

        nData[2].FText := FieldByName('O_ID').AsString;
        nData[3].FText := FieldByName('O_Number').AsString;
        nData[4].FText := FieldByName('O_DoneNum').AsString;
        nData[5].FText := FieldByName('O_Man').AsString;
        nData[6].FText := DateTime2Str(FieldByName('O_Date').AsDateTime);
        nData[7].FText := DateTime2Str(FieldByName('O_ActDate').AsDateTime);

        with nData[8] do
        begin
          FText := '';
          FAlign := taLeftJustify;
          FCtrls := TList.Create;

          if nStr = sFlag_BillLock then
          begin
            nBtn := TcxButton.Create(Self);
            FCtrls.Add(nBtn);

            with nBtn do
            begin
              Caption := '����';
              Width := 35;
              Height := 18;

              Parent := Self;
              OnClick := OnBtnClick;
              Tag := FPainter.DataCount;
            end;

            nBtn := TcxButton.Create(Self);
            FCtrls.Add(nBtn);

            with nBtn do
            begin
              Caption := 'ȷ��';
              Width := 35;
              Height := 18;

              Parent := Self;
              OnClick := OnBtnClick;
              Tag := FPainter.DataCount;
            end;
          end else
          begin
            nBtn := TcxButton.Create(Self);
            FCtrls.Add(nBtn);

            with nBtn do
            begin
              Caption := '�鿴';
              Width := 35;
              Height := 18;

              Parent := Self;
              OnClick := OnBtnClick2;
              Tag := FPainter.DataCount;
            end;
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

//Desc: ��ť
procedure TfFrameProductBill.OnBtnClick(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  if Sender = FPainter.Data[nTag][8].FCtrls[0] then
  begin
    if ShowProductBillAdjust(FPainter.Data[nTag][2].FText) then
    begin
      TcxButton(Sender).Enabled := False;
      LoadBillList;
    end;
  end else //����

  if Sender = FPainter.Data[nTag][8].FCtrls[1] then
  begin
    if ShowBillConfirmForm(FPainter.Data[nTag][2].FText) then
    begin
      TcxButton(Sender).Enabled := False;
      LoadBillList;
    end;
  end; //ȷ��
end;

//Desc: �鿴����
procedure TfFrameProductBill.OnBtnClick2(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  if Sender = FPainter.Data[nTag][8].FCtrls[0] then
  begin
    ShowProductBillView(FPainter.Data[nTag][2].FText, False);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameProductBill, TfFrameProductBill.FrameID);
end.
