{*******************************************************************************
  作者: dmzn@163.com 2011-10-12
  描述: 中间件主单元
*******************************************************************************}
unit UFormMain;

{$I link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UTrayIcon, StdCtrls, ExtCtrls, ComCtrls;

type
  TfFormMain = class(TForm)
    HintPanel: TPanel;
    Image1: TImage;
    Image2: TImage;
    HintLabel: TLabel;
    wPage: TPageControl;
    sBar: TStatusBar;
    SheetSummary: TTabSheet;
    SheetRunStatus: TTabSheet;
    SheetSysParam: TTabSheet;
    SheetConnParam: TTabSheet;
    SheetUpdate: TTabSheet;
    Timer1: TTimer;
    SBSummary: TScrollBox;
    SheetRunLog: TTabSheet;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure wPageChange(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    {*状态栏图标*}
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    {*配置信息*}
    procedure SetHintText(const nLabel: TLabel);
    {*提示信息*}
    procedure InitFormData(const nIsAdmin: Boolean);
    {*初始化界面*}
    procedure WMQueryEndSession(var nMsg: TMessage); message WM_QueryEndSession;
    {*关机请求*}
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UFrameBase, UROModule, USysConst, USysFun;

//------------------------------------------------------------------------------
//Date: 2007-10-15
//Parm: 标签
//Desc: 在nLabel上显示提示信息
procedure TfFormMain.SetHintText(const nLabel: TLabel);
begin
  nLabel.Font.Color := clWhite;
  nLabel.Font.Size := 12;
  nLabel.Font.Style := nLabel.Font.Style + [fsBold];

  nLabel.Caption := gSysParam.FHintText;
  nLabel.Left := 8;
  nLabel.Top := (HintPanel.Height + nLabel.Height - 12) div 2;
end;


//Desc: 载入配置
procedure TfFormMain.FormLoadConfig;
var nStr: string;
    nIni: TIniFile;
begin     
  SetHintText(HintLabel);
  HintPanel.DoubleBuffered := True;

  AddAdminStatusChangeListener(InitFormData);
  gStatusBar := sBar;
  
  nStr := Format(sDate, [DateToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Date);
  nStr := Format(sTime, [TimeToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Time);

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    ActionSysParameter(True);
  finally
    nIni.Free;
  end;

  wPage.ActivePage := SheetSummary;
  CreateBaseFrameItem(cFI_FrameSummary, SBSummary, alNone).Centered := True;
  CreateBaseFrameItem(cFI_FrameRunlog, SheetRunLog);
  CreateBaseFrameItem(cFI_FrameRunstatus, SheetRunStatus, alNone).Centered := True;
  //创建核心面板
end;

//Desc: 保存窗体配置
procedure TfFormMain.FormSaveConfig;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    ActionSysParameter(False);
  finally
    nIni.Free;
  end;
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
begin 
  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig, gPath + sDBConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end else Caption := gSysParam.FMainTitle;

  FormLoadConfig;
  //载入配置
  {$IFDEF debug}
  AdminStatusChange(True);
  {$ELSE}
  AdminStatusChange(False);
  {$ENDIF}

  FTrayIcon := TTrayIcon.Create(Self);
  FTrayIcon.Hint := gSysParam.FAppTitle;
  FTrayIcon.Visible := True;
  //任务托盘
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var nBool: Boolean;
begin
  with ROModule.LockModuleStatus^ do
  try
    {$IFDEF debug}
    nBool := False;
    {$ELSE}
    nBool := FSrvTCP or FSrvHttp;
    {$ENDIF}
  finally
    ROModule.ReleaseStatusLock;
  end;

  if nBool then
  begin
    Action := caNone;
    ShowMsg('请先停止服务', sHint); Exit;
  end;
  //stop service 

  FormSaveConfig;
  //保存配置
end;

//Desc: 授权关机操作
procedure TfFormMain.WMQueryEndSession(var nMsg: TMessage);
var nStr: string;
begin
  if ROModule.ActiveServer([stTcp, stHttp], False, nStr) then
  begin
    nMsg.Result := 1;
    Application.Terminate;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 任务栏日期,时间
procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  sBar.Panels[cSBar_Date].Text := Format(sDate, [DateToStr(Now)]);
  sBar.Panels[cSBar_Time].Text := Format(sTime, [TimeToStr(Now)]);
end;

procedure TfFormMain.InitFormData(const nIsAdmin: Boolean);
begin
  SheetSysParam.TabVisible := nIsAdmin;
  SheetConnParam.TabVisible := nIsAdmin;
  SheetUpdate.TabVisible := nIsAdmin;

  if (not nIsAdmin) and (wPage.ActivePageIndex > 2) then
    wPage.ActivePageIndex := 0;
  //xxxxx
end;

//Desc: 动态载入面板
procedure TfFormMain.wPageChange(Sender: TObject);
begin
  if wPage.ActivePage = SheetSysParam then
    CreateBaseFrameItem(cFI_FrameSysParam, SheetSysParam, alNone).Centered := True
  else if wPage.ActivePage = SheetConnParam then
    CreateBaseFrameItem(cFI_FrameConnParam, SheetConnParam, alNone).Centered := True
  else if wPage.ActivePage = SheetUpdate then
    CreateBaseFrameItem(cFI_FrameSoftUpdate, SheetUpdate, alNone).Centered := True;
end;

end.
