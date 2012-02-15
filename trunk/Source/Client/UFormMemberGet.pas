{*******************************************************************************
  作者: dmzn@163.com 2011-11-30
  描述: 选择会员
*******************************************************************************}
unit UFormMemberGet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, UFrameProductSale, ExtCtrls, UImageButton,
  StdCtrls, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxTextEdit;

type
  TfFormMemberGet = class(TSkinFormBase)
    LabelHint: TLabel;
    Panel1: TPanel;
    BtnOK: TImageButton;
    BtnExit: TImageButton;
    Label1: TLabel;
    EditID: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditIDKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FMember: PMemberInfo;
    //会员信息
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

function ShowGetMember(const nMember: PMemberInfo): Boolean;
//添加账户

implementation

{$R *.dfm}

uses
  ULibFun, DB, UFormCtrl, USysDB, USysConst, USysFun, UDataModule;

function ShowGetMember(const nMember: PMemberInfo): Boolean;
begin
  with TfFormMemberGet.Create(Application) do
  begin
    FMember := nMember;    
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormMemberGet.FormSkinID: string;
begin
  Result := 'FormDialog';
end;

procedure TfFormMemberGet.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=ComponentCount-1 downto 0 do
   if Components[nIdx] is TImageButton then
    LoadFixImageButton(TImageButton(Components[nIdx]));
  //xxxxx

  LoadFormConfig(Self);
end;

procedure TfFormMemberGet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

procedure TfFormMemberGet.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 调整按钮位置
procedure TfFormMemberGet.Panel1Resize(Sender: TObject);
var nW,nL: Integer;
begin
  nW := BtnOK.Width + 32 + BtnExit.Width;
  nL := Trunc((Panel1.Width - nW) / 2);

  BtnOk.Left := nL;
  BtnExit.Left := nL + BtnOK.Width + 32;
end;

//Desc: 响应回车
procedure TfFormMemberGet.EditIDKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BtnOKClick(nil);
  end;
end;

//Desc: 获取会员信息
procedure TfFormMemberGet.BtnOKClick(Sender: TObject);
var nStr,nHint: string;
    nDS: TDataSet;
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    EditID.SetFocus;
    ShowMsg('请填写会员卡号', sHint); Exit;
  end;

  nStr := 'Select Top 1 mem.*,S_Deduct,GlobalMember,tr.BrandID,(Select BrandID ' +
          'From $TR ter Where ter.TerminalID=''$TID'' ) As MyBrand ' +
          'From $Mem mem ' +
          ' Left Join $MT mt On mt.S_Money<=M_BuyMoney And mt.S_TerminalID=''$TID'' ' +
          ' Left Join $TR tr On tr.TerminalID=mem.M_TerminalID ' +
          ' Left Join $BR br On br.BrandID=tr.BrandID ' +
          'Where M_Card=''$ID'' Order By S_Money DESC';
  nStr := MacroValue(nStr, [MI('$Mem', sTable_Member),
          MI('$MT', sTable_MemberSet), MI('$ID', EditID.Text),
          MI('$TR', sTable_Terminal), MI('$BR', sTable_DL_Brand),
          MI('$TID', gSysParam.FTerminalID)]);
  //xxxxx

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    if nDS.RecordCount < 1 then
    begin
      EditID.SelectAll;
      ShowMsg('未找到持有该卡的会员', sHint); Exit;
    end;

    with FMember^,nDS do
    begin
      if (FieldByName('BrandID').AsString <> FieldByName('MyBrand').AsString) or
         //开卡店与本店不是同品牌
         ((FieldByName('GlobalMember').AsString <> sFlag_Yes) and
         (FieldByName('M_TerminalID').AsString <> gSysParam.FTerminalID)) then
      begin
        ShowMsg('持卡人不是本店会员', sHint); Exit;
      end;


      FID := FieldByName('M_ID').AsString;
      FCard := EditID.Text;
      FName := FieldByName('M_Name').AsString;
      FMoney := FieldByName('M_BuyMoney').AsFloat;

      FZheKou := FieldByName('S_Deduct').AsFloat;
      if (FZheKou > 10) or (FZheKou <= 0) then
        FZheKou := 10;
      //无折扣
    end;

    ModalResult := mrOk;
    ShowMsg('会员已确认', sHint);
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

end.
