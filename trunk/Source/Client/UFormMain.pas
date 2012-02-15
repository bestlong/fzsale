{*******************************************************************************
  作者: dmzn@163.com 2011-11-16
  描述: 销售客户端主单元
*******************************************************************************}
unit UFormMain;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USkinFormBase, ExtCtrls, UImageButton, UBitmapPanel, Menus,
  StdCtrls;

type
  TfFormMain = class(TSkinFormBase)
    TitleBar: TPanel;
    ImageButton1: TImageButton;
    ImageButton2: TImageButton;
    ImageButton3: TImageButton;
    ImageButton4: TImageButton;
    ImageButton6: TImageButton;
    ImageButton8: TImageButton;
    ImageButton9: TImageButton;
    TitleImageFit: TZnBitmapPanel;
    PanelMain: TPanel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    PopupMenu2: TPopupMenu;
    MenuMember: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PopupMenu3: TPopupMenu;
    MenuProduct: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    N10: TMenuItem;
    MenuTJ: TPopupMenu;
    MenuReport: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem13: TMenuItem;
    N9: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    PanelHint: TZnBitmapPanel;
    LabelTime: TLabel;
    ImageTime: TImage;
    Timer1: TTimer;
    ImageSmile: TImage;
    LabelSmile: TLabel;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N2: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N24: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImageButton9Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure MenuMemberClick(Sender: TObject);
    procedure MenuProductClick(Sender: TObject);
    procedure ImageButton2Click(Sender: TObject);
    procedure MenuReportClick(Sender: TObject);
    procedure ImageButton8Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ImageButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    {*配置信息*}
    procedure ClearWorkPanel(const nExclude: array of Integer);
    //清理空间
  public
    { Public declarations }
    class function FormSkinID: string; override;
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UcxChinese, UFrameBase, UFormLogin, USysConst,
  UFormBillConfirm, UFormPrinter;

class function TfFormMain.FormSkinID: string;
begin
  Result := 'FormMain';
end;

//Desc: 载入配置
procedure TfFormMain.FormLoadConfig;
var nIni: TIniFile;
begin     
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
  finally
    nIni.Free;
  end; 
end;

//Desc: 保存窗体配置
procedure TfFormMain.FormSaveConfig;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
    nIdx,nH,nInt: Integer;
begin
  inherited;
  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig, gPath + sDBConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end else Caption := gSysParam.FMainTitle;

  if not ShowLoginForm then
  begin
    ShowWindow(Handle, SW_MINIMIZE);
    Application.ProcessMessages;
    Application.Terminate; Exit;
  end;

  //----------------------------------------------------------------------------
  nH := 0;
  for nIdx:=TitleBar.ControlCount-1 downto 0 do
   if TitleBar.Controls[nIdx] is TImageButton then
    if LoadFixImageButton(TitleBar.Controls[nIdx] as TImageButton) then
    begin
      nInt := (TitleBar.Controls[nIdx] as TImageButton).PicNormal.Height;
      if nInt > nH then nH := nInt;
    end;

  if nH > 0 then
    TitleBar.Height := nH;
  //xxxxx
  
  LoadFixImage(TitleImageFit.Bitmap, 'barblank');
  LoadFixImage(PanelHint.Bitmap, 'panelmsg');
  PanelHint.Height := PanelHint.Bitmap.Height;

  with ImageTime do
  begin
    LoadFixImage(Picture.Bitmap, 'imgtime');
    Width := Picture.Width + 10;
  end;

  with ImageSmile do
  begin
    LoadFixImage(Picture.Bitmap, 'imgsmile');
    Width := Picture.Width + 10;
  end;

  LabelSmile.Caption := Format('%s,您好! 欢迎使用本系统.', [gSysParam.FUserID]);
  FormLoadConfig;
  //载入配置
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFNDEF debug}
  if not QueryDlg(sCloseQuery, sHint) then
  begin
    Action := caNone; Exit;
  end;
  {$ENDIF}

  FormSaveConfig;
  //窗体配置
end;

//------------------------------------------------------------------------------
//Desc: 时间
procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  LabelTime.Caption := Date2CH(FormatDateTime('YYYYMMDD', Date)) + ' ' +
                       Time2Str(Time);
  //xxxxx
end;

//Desc: 按钮弹菜单
procedure TfFormMain.ImageButton9Click(Sender: TObject);
var nPos: TPoint;
    nIdx: Integer;
    nPM: TPopupMenu;
begin
  nPM := nil;

  for nIdx:=ComponentCount - 1 downto 0 do
  if (Components[nIdx] is TPopupMenu) and
     (TPopupMenu(Components[nIdx]).Tag = TComponent(Sender).Tag) then
  begin
    nPM := TPopupMenu(Components[nIdx]); Break;
  end;

  if Assigned(nPM) then
  with TImageButton(Sender) do
  begin
    for nIdx:=nPM.Items.Count - 1 downto 0 do
      nPM.Items[nIdx].Enabled := gSysParam.FIsAdmin or (nPM.Items[nIdx].Tag < 50);
    //Tag < 50指不需要管理员权限

    nPos.X := Left;
    nPos.Y := Top + Height;
    nPos := Parent.ClientToScreen(nPos);
    nPM.Popup(nPos.X, nPos.Y);
  end;
end;

//Desc: 判定nInt在nArray中
function InIntegerArray(const nInt: Integer; const nArray: array of Integer): Boolean;
var nIdx: Integer;
begin
  Result := False;

  for nIdx:=Low(nArray) to High(nArray) do
  if nArray[nIdx] = nInt then
  begin
    Result := True; Break;
  end;
end;

//Desc: 清理工作面板
procedure TfFormMain.ClearWorkPanel(const nExclude: array of Integer);
var nIdx: Integer;
begin
  for nIdx:=PanelMain.ControlCount - 1 downto 0 do
   if (PanelMain.Controls[nIdx] is TfFrameBase) and
      (not InIntegerArray(TfFrameBase(PanelMain.Controls[nIdx]).FrameID, nExclude)) then
    TfFrameBase(PanelMain.Controls[nIdx]).Close(False);
  //xxxxx
end;

//Desc: 帐户管理菜单
procedure TfFormMain.N1Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   50:
    begin
      ClearWorkPanel([cFI_FrameMyInfo]);
      CreateBaseFrameItem(cFI_FrameMyInfo, PanelMain, alNone).Centered := True;
    end;
   20:
    begin
      ClearWorkPanel([cFI_FrameMyPassword]);
      CreateBaseFrameItem(cFI_FrameMyPassword, PanelMain, alNone).Centered := True;
    end;
   51:
    begin
      ClearWorkPanel([cFI_FrameUserAccount]);
      CreateBaseFrameItem(cFI_FrameUserAccount, PanelMain, alNone).Centered := True;
    end;
   52: ShowPrinterSetup;
  end;
end;

//Desc: 会员菜单
procedure TfFormMain.MenuMemberClick(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   50:
    begin
      ClearWorkPanel([cFI_FrameNewMember]);
      CreateBaseFrameItem(cFI_FrameNewMember, PanelMain, alNone).Centered := True;
    end;
   51:
    begin
      ClearWorkPanel([cFI_FrameMemberSet]);
      CreateBaseFrameItem(cFI_FrameMemberSet, PanelMain, alNone).Centered := True;
    end;
   10:
    begin
      ClearWorkPanel([cFI_FrameMembers]);
      CreateBaseFrameItem(cFI_FrameMembers, PanelMain, alNone).Centered := True;
    end;
   20:
    begin
      ClearWorkPanel([cFI_FrameMemberDtl]);
      //CreateBaseFrameItem(cFI_FrameMemberDtl, PanelMain, alNone).Centered := True;
    end;
  end;
end;

//Desc: 商品菜单
procedure TfFormMain.MenuProductClick(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   50:
    begin
      ClearWorkPanel([cFI_FrameProductInit]);
      CreateBaseFrameItem(cFI_FrameProductInit, PanelMain, alNone).Centered := True;
    end;
   10:
    begin
      ClearWorkPanel([cFI_FrameProductKC]);
      CreateBaseFrameItem(cFI_FrameProductKC, PanelMain, alNone).Centered := True;
    end;
   12:
    begin
      ClearWorkPanel([cFI_FrameBillYS]);
      CreateBaseFrameItem(cFI_FrameBillYS, PanelMain, alClient);
    end;
   20:
    begin
      ClearWorkPanel([cFI_FrameMemberDtl]);
      //CreateBaseFrameItem(cFI_FrameMemberDtl, PanelMain, alNone).Centered := True;
    end;
   51:
    begin
      ClearWorkPanel([cFI_FrameBillView]);
      CreateBaseFrameItem(cFI_FrameBillView, PanelMain, alNone).Centered := True;
    end;
   52:
    begin
      ClearWorkPanel([cFI_FrameReturnDL]);
      CreateBaseFrameItem(cFI_FrameReturnDL, PanelMain, alClient);
    end;

  end;
end;

//Desc: 开始营业
procedure TfFormMain.ImageButton2Click(Sender: TObject);
begin
  ClearWorkPanel([cFI_FrameProductSale]);
  CreateBaseFrameItem(cFI_FrameProductSale, PanelMain, alNone).Centered := True;
end;

//Desc: 销售报表
procedure TfFormMain.MenuReportClick(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   50:
    begin
      ClearWorkPanel([cFI_FrameReportMX]);
      CreateBaseFrameItem(cFI_FrameReportMX, PanelMain, alNone).Centered := True;
    end;
   51:
    begin
      ClearWorkPanel([cFI_FrameReportHZ]);
      CreateBaseFrameItem(cFI_FrameReportHZ, PanelMain, alNone).Centered := True;
    end;
   52:
    begin
      ClearWorkPanel([cFI_FrameReportLR]);
      CreateBaseFrameItem(cFI_FrameReportLR, PanelMain, alNone).Centered := True;
    end;
   53:
    begin
      ClearWorkPanel([cFI_FrameReportJH]);
      CreateBaseFrameItem(cFI_FrameReportJH, PanelMain, alNone).Centered := True;
    end;
   54:
    begin
      ClearWorkPanel([cFI_FrameReportTH]);
      CreateBaseFrameItem(cFI_FrameReportTH, PanelMain, alNone).Centered := True;
    end;
   55:
    begin
      ClearWorkPanel([cFI_FrameReportYJ]);
      CreateBaseFrameItem(cFI_FrameReportYJ, PanelMain, alNone).Centered := True;
    end;
   56:
    begin
      ClearWorkPanel([cFI_FrameReportRT]);
      CreateBaseFrameItem(cFI_FrameReportRT, PanelMain, alNone).Centered := True;
    end;
  end;
end;

//Desc: 经营通告
procedure TfFormMain.ImageButton8Click(Sender: TObject);
begin
  ClearWorkPanel([cFI_FrameNotices]);
  CreateBaseFrameItem(cFI_FrameNotices, PanelMain, alNone).Centered := True;
end;

//Desc: 综合信息
procedure TfFormMain.ImageButton1Click(Sender: TObject);
begin
  ClearWorkPanel([cFI_FrameSummary]);
  CreateBaseFrameItem(cFI_FrameSummary, PanelMain, alNone).Centered := True;
end;

end.
