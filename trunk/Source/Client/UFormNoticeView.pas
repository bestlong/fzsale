{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 通告信息查看
*******************************************************************************}
unit UFormNoticeView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UGridPainter, UFrameNotices, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Grids, UGridExPainter, cxTextEdit, StdCtrls, ExtCtrls, UImageButton,
  cxMemo;

type
  TfFormNoticeView = class(TSkinFormBase)
    Panel1: TPanel;
    BtnOK: TImageButton;
    Panel2: TPanel;
    LabelHint: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    EditTitle: TcxTextEdit;
    EditMemo: TcxMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowNoticeViewForm(const nNotice: PNoticeItem): Boolean;
//查看通告

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule;

function ShowNoticeViewForm(const nNotice: PNoticeItem): Boolean;
begin
  with TfFormNoticeView.Create(Application) do
  begin
    EditTitle.Text := nNotice.FTitle;
    EditMemo.Text := nNotice.FMemo;
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormNoticeView.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormNoticeView.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx
  LoadFormConfig(Self);
end;

procedure TfFormNoticeView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

//Desc: 调整按钮位置
procedure TfFormNoticeView.Panel1Resize(Sender: TObject);
begin
  BtnOk.Left := Trunc((Panel1.Width - BtnOK.Width) / 2);
end;

procedure TfFormNoticeView.BtnOKClick(Sender: TObject);
begin
  Close;
end;

end.
