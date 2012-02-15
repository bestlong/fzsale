{*******************************************************************************
  ����: dmzn@163.com 2011-11-21
  ����: ��Ա�б�
*******************************************************************************}
unit UFrameMembers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, UGridPainter, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, Grids, StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, ExtCtrls,
  UGridExPainter, UImageButton;

type
  TfFrameMembers = class(TfFrameBase)
    Panel2: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    EditCard: TcxButtonEdit;
    EditName: TcxButtonEdit;
    LabelHint: TLabel;
    GridList: TDrawGridEx;
    procedure BtnExitClick(Sender: TObject);
    procedure EditCardPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditCardKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FPainter: TGridPainter;
    //��ͼ����
    procedure LoadMembers(const nWhere: string = '');
    //�����Ա
    procedure OnBtnClick(Sender: TObject);
    //��ť���
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
  UFormMemberView;

class function TfFrameMembers.FrameID: integer;
begin
  Result := cFI_FrameMembers;
end;

procedure TfFrameMembers.OnCreateFrame;
begin
  Name := MakeFrameName(FrameID);
  FPainter := TGridPainter.Create(GridList);

  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //����

    AddHeader('���', 50);
    AddHeader('��Ա����', 50);
    AddHeader('��Ա����', 50);
    AddHeader('�Ա�', 50);
    AddHeader('����ʱ��', 50);
    AddHeader('��ϵ��ʽ', 50);
    AddHeader('�������', 50);
    AddHeader('�����ѽ��', 50);
    AddHeader('�Żݽ��', 50);
    AddHeader('��ϸ�鿴', 50);
  end;

  LoadDrawGridConfig(Name, GridList);
  AdjustLabelCaption(LabelHint, GridList);
  Width := GetGridHeaderWidth(GridList);
  LoadMembers;
end;

procedure TfFrameMembers.OnDestroyFrame;
begin
  FPainter.Free;
  SaveDrawGridConfig(Name, GridList);
end;

procedure TfFrameMembers.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFrameMembers.LoadMembers(const nWhere: string);
var nStr,nHint: string;
    nIdx,nInt: Integer;
    nDS: TDataSet;
    nBtn: TImageButton;
    nData: TGridDataArray;
begin
  nStr := 'Select * From %s Where M_TerminalId=''%s''';
  nStr := Format(nStr, [sTable_Member, gSysParam.FTerminalID]);

  if nWhere <> '' then
    nStr := nStr + ' And (' + nWhere + ')';
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
        SetLength(nData, 11);
        for nIdx:=Low(nData) to High(nData) do
        begin
          nData[nIdx].FText := '';
          nData[nIdx].FCtrls := nil;
          nData[nIdx].FAlign := taCenter;
        end;

        nData[0].FText := IntToStr(nInt);
        Inc(nInt);

        nData[1].FText := FieldByName('M_Card').AsString;
        nData[2].FText := FieldByName('M_Name').AsString;

        if FieldByName('M_Sex').AsString = sFlag_Male then
             nData[3].FText := '��'
        else nData[3].FText := 'Ů';

        nData[4].FText := FieldByName('M_Date').AsString;
        nData[5].FText := FieldByName('M_Phone').AsString;
        nData[6].FText := FieldByName('M_BuyTime').AsString;
        nData[7].FText := FieldByName('M_BuyMoney').AsString;
        nData[8].FText := FieldByName('M_DeMoney').AsString;

        with nData[9] do
        begin
          FText := '';
          FAlign := taCenter;
          FCtrls := TList.Create;

          nBtn := TImageButton.Create(Self);
          FCtrls.Add(nBtn);

          with nBtn do
          begin
            Parent := Self;
            ButtonID := 'btn_view';
            LoadButton(nBtn);
            
            OnClick := OnBtnClick;
            Tag := FPainter.DataCount;
          end; 
        end;

        nData[10].FText := FieldByName('M_ID').AsString;
        FPainter.AddData(nData);
        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

procedure TfFrameMembers.EditCardKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    TcxButtonEdit(Sender).Properties.OnButtonClick(Sender, 0);
  end;                                                        
end;

//Desc: ��ѯ���
procedure TfFrameMembers.EditCardPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  if Sender = EditCard then
  begin
    if EditCard.Text = '' then
         nStr := ''
    else nStr := Format('M_Card=''%s''', [EditCard.Text]);

    LoadMembers(nStr);
  end else

  if Sender = EditName then
  begin
    if EditName.Text = '' then
         nStr := ''
    else nStr := Format('M_Name Like ''%%%s%%''', [EditName.Text]);

    LoadMembers(nStr);
  end;
end;

//Desc: ��ť����
procedure TfFrameMembers.OnBtnClick(Sender: TObject);
var nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  ShowMemberInfoForm(FPainter.Data[nTag][10].FText);
end;

initialization
  gControlManager.RegCtrl(TfFrameMembers, TfFrameMembers.FrameID);
end.
