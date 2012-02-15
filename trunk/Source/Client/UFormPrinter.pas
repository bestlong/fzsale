{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 打印设置
*******************************************************************************}
unit UFormPrinter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UFrameProductSale, ExtCtrls, UImageButton,
  StdCtrls, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxTextEdit, cxMemo;

type
  TfFormPrinterSetup = class(TSkinFormBase)
    LabelHint: TLabel;
    Panel1: TPanel;
    BtnOK: TImageButton;
    BtnExit: TImageButton;
    EditTitle: TcxTextEdit;
    EditEnding: TcxMemo;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadPrinterSetup;
    //载入配置
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowPrinterSetup: Boolean;
//打印设置

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule, FZSale_Intf;

function ShowPrinterSetup: Boolean;
begin
  Result := False;
  if not gSysParam.FIsAdmin then Exit;
  //admin check

  with TfFormPrinterSetup.Create(Application) do
  begin
    LoadPrinterSetup;
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormPrinterSetup.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormPrinterSetup.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx

  LoadFormConfig(Self);
end;

procedure TfFormPrinterSetup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

procedure TfFormPrinterSetup.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormPrinterSetup.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 32 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 32;
end;

//Desc: 载入打印设置
procedure TfFormPrinterSetup.LoadPrinterSetup;
var nStr,nHint: string;
    nDS: TDataSet;
begin
  EditTitle.Text := '销售结算单';
  EditEnding.Clear;

  nStr := 'Select D_Name,D_Value From %s ' +
          'Where D_Memo=''%s'' And (D_Name=''%s'' Or D_Name=''%s'')';
  nStr := Format(nStr, [sTable_SysDict, gSysParam.FTerminalID,
          sFlag_ReportTitle, sFlag_ReportEnding]);
  //xxxxx

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn);
      Exit;
    end;

    if nDS.RecordCount > 0 then
    with nDS do
    begin
      First;

      while not Eof do
      begin
        nStr := FieldByName('D_Name').AsString;
        if CompareText(nStr, sFlag_ReportTitle) = 0 then
        begin
          nStr := FieldByName('D_Value').AsString;
          if nStr <> '' then EditTitle.Text := nStr;
        end else

        if CompareText(nStr, sFlag_ReportEnding) = 0 then
        begin
          nStr := FieldByName('D_Value').AsString;
          if nStr <> '' then EditEnding.Text := nStr;
        end;

        Next;
      end;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

//Desc: 保存
procedure TfFormPrinterSetup.BtnOKClick(Sender: TObject);
var nStr,nHint: string;
    nSQL: SQLItems;
begin
  EditTitle.Text := Trim(EditTitle.Text);
  if EditTitle.Text = '' then
  begin
    EditTitle.SetFocus;
    ShowMsg('请输入标题内容', sHint); Exit;
  end;

  nSQL := SQLItems.Create;
  try
    nStr := MakeSQLByStr([SF('D_Name', sFlag_ReportTitle),
            SF('D_Desc', sPrinterSetup), SF('D_Value', EditTitle.Text),
            SF('D_Memo', gSysParam.FTerminalID)], sTable_SysDict, '', True);
    //insert

    nHint := 'Update %s Set D_Value=''%s'' ' +
             'Where D_Name=''%s'' And D_Memo=''%s''';
    nHint := Format(nHint, [sTable_SysDict, EditTitle.Text, sFlag_ReportTitle,
             gSysParam.FTerminalID]);
    //update

    with nSQL.Add do
    begin
      SQL := nStr;
      IfRun := nHint;
      IfType := 5; //update失败,则insert
    end;

    EditEnding.Text := TrimRight(EditEnding.Text);
    nStr := MakeSQLByStr([SF('D_Name', sFlag_ReportEnding),
            SF('D_Desc', sPrinterSetup), SF('D_Value', EditEnding.Text),
            SF('D_Memo', gSysParam.FTerminalID)], sTable_SysDict, '', True);
    //insert

    nHint := 'Update %s Set D_Value=''%s'' ' +
             'Where D_Name=''%s'' And D_Memo=''%s''';
    nHint := Format(nHint, [sTable_SysDict, EditEnding.Text, sFlag_ReportEnding,
             gSysParam.FTerminalID]);
    //update

    with nSQL.Add do
    begin
      SQL := nStr;
      IfRun := nHint;
      IfType := 5; //update失败,则insert
    end;

    if FDM.SQLUpdates(nSQL, True, nHint) >= 0 then
    begin
      ShowMsg('打印设置已保存', sHint);
      ModalResult := mrOk;             
    end else ShowDlg(nHint, sWarn);
  finally
    //nSQL.Free;
  end;
end;

end.
