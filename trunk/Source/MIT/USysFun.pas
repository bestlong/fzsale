{*******************************************************************************
  作者: dmzn@163.com 2007-10-09
  描述: 项目通用函数定义单元
*******************************************************************************}
unit USysFun;

interface

uses
  Windows, Classes, ComCtrls, Forms, SysUtils, IniFiles, cxListView, UBase64,
  ULibFun, USysConst, Registry;

procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
//在状态栏显示信息

procedure InitSystemEnvironment;
//初始化系统运行环境的变量
procedure LoadSysParameter(const nIni: TIniFile = nil);
//载入系统配置参数
procedure ActionSysParameter(const nIsRead: Boolean; const nIni: TIniFile = nil);
//读写系统配置参数

function MakeFrameName(const nFrameID: integer): string;
//创建Frame名称
function ReplaceGlobalPath(const nStr: string): string;
//替换nStr中的全局路径

procedure LoadcxListViewConfig(const nID: string; const nListView: TcxListView;
 const nIni: TIniFile = nil);
procedure SavecxListViewConfig(const nID: string; const nListView: TcxListView;
 const nIni: TIniFile = nil);
//cxListView配置

implementation

//---------------------------------- 配置运行环境 ------------------------------
//Date: 2007-01-09
//Desc: 初始化运行环境
procedure InitSystemEnvironment;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);
end;

//Date: 2007-09-13
//Desc: 载入系统配置参数
procedure LoadSysParameter(const nIni: TIniFile = nil);
var nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sConfigFile);

  try
    with gSysParam, nTmp do
    begin
      FProgID := ReadString(sConfigSec, 'ProgID', sProgID);
      //程序标识决定以下所有参数
      FAppTitle := ReadString(FProgID, 'AppTitle', sAppTitle);
      FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
      FHintText := ReadString(FProgID, 'HintText', '');
      FCopyRight := ReadString(FProgID, 'CopyRight', '');
    end;
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Desc: 读写系统参数
procedure ActionSysParameter(const nIsRead: Boolean; const nIni: TIniFile = nil);
var nTmp: TIniFile;
    nReg: TRegistry;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sConfigFile);

  nReg := nil;
  try
    nReg := TRegistry.Create;
    nReg.RootKey := HKEY_CURRENT_USER;
    nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    //registry

    with gSysParam, nTmp do
    begin
      if nIsRead then
      begin
        FLocalDB    := ReadString('SysDB', 'LocalDB', '');
        FLocalHost  := ReadString('SysDB', 'LocalHost', '');
        FLocalPort  := ReadInteger('SysDB', 'LocalPort', 4043);
        FLocalUser  := ReadString('SysDB', 'LocalUser', '');
        FLocalPwd   := DecodeBase64(ReadString('SysDB', 'LocalPwd', ''));
        FLocalConn  := DecodeBase64(ReadString('SysDB', 'LocalConnStr', ''));

        FUserID     := DecodeBase64(ReadString('Admin', 'User', ''));
        FUserPwd    := DecodeBase64(ReadString('Admin', 'Pwd', ''));

        FAutoStart := nReg.ValueExists('HX_MITServer');
        FAutoMin := ReadBool('AutoAction', 'AutoMin', False);
      end else
      begin
        WriteString('SysDB', 'LocalDB', FLocalDB);
        WriteString('SysDB', 'LocalHost', FLocalHost);
        WriteInteger('SysDB', 'LocalPort', FLocalPort);
        WriteString('SysDB', 'LocalUser', FLocalUser);
        WriteString('SysDB', 'LocalPwd', EncodeBase64(FLocalPwd));
        WriteString('SysDB', 'LocalConnStr', EncodeBase64(FLocalConn));

        WriteString('Admin', 'User', EncodeBase64(FUserID));
        WriteString('Admin', 'Pwd', EncodeBase64(FUserPwd));
        WriteBool('AutoAction', 'AutoMin', FAutoMin);
        //自动处理
        
        if FAutoStart then
          nReg.WriteString('HX_MITServer', Application.ExeName)
        else if nReg.ValueExists('HX_MITServer') then
          nReg.DeleteValue('HX_MITServer');
        //xxxxx
      end;
    end;
  finally
    nReg.Free;
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Desc: 依据FrameID生成组件名
function MakeFrameName(const nFrameID: integer): string;
begin
  Result := 'Frame' + IntToStr(nFrameID);
end;

//Desc: 替换nStr中的全局路径
function ReplaceGlobalPath(const nStr: string): string;
var nPath: string;
begin
  nPath := gPath;
  if Copy(nPath, Length(nPath), 1) = '\' then
    System.Delete(nPath, Length(nPath), 1);
  Result := StringReplace(nStr, '$Path', nPath, [rfReplaceAll, rfIgnoreCase]);
end;

//------------------------------------------------------------------------------
//Desc: 在全局状态栏最后一个Panel上显示nMsg消息
procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > 0) then
  begin
    gStatusBar.Panels[gStatusBar.Panels.Count - 1].Text := nMsg;
    Application.ProcessMessages;
  end;
end;

//Desc: 在索引nIdx的Panel上显示nMsg消息
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > nIdx) and
     (nIdx > -1) then
  begin
    gStatusBar.Panels[nIdx].Text := nMsg;
    gStatusBar.Panels[nIdx].Width := gStatusBar.Canvas.TextWidth(nMsg) + 20;
    Application.ProcessMessages;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2010-03-09
//Parm: 配置小节名;列表;读取对象
//Desc: 从nID指定的小节读取nList的配置信息
procedure LoadcxListViewConfig(const nID: string; const nListView: TcxListView;
 const nIni: TIniFile = nil);
var nTmp: TIniFile;
    nList: TStrings;
    i,nCount: integer;
begin
  nTmp := nil;
  nList := TStringList.Create;
  try
    if Assigned(nIni) then
         nTmp := nIni
    else nTmp := TIniFile.Create(gPath + sFormConfig); 

    nList.Text := StringReplace(nTmp.ReadString(nID, nListView.Name + '_Cols',
                                ''), ';', #13, [rfReplaceAll]);
    if nList.Count <> nListView.Columns.Count then Exit;

    nCount := nListView.Columns.Count - 1;
    for i:=0 to nCount do
     if IsNumber(nList[i], False) then
      nListView.Columns[i].Width := StrToInt(nList[i]);
    //xxxxx
  finally
    nList.Free;
    if not Assigned(nIni) then FreeAndNil(nTmp);
  end;
end;

//Date: 2010-03-09
//Parm: 配置小节名;列表;写入对象
//Desc: 将nList的信息存入nID指定的小节
procedure SavecxListViewConfig(const nID: string; const nListView: TcxListView;
 const nIni: TIniFile = nil);
var nStr: string;
    nTmp: TIniFile;
    i,nCount: integer;
begin
  nTmp := nil;
  try
    if Assigned(nIni) then
         nTmp := nIni
    else nTmp := TIniFile.Create(gPath + sFormConfig); 

    nStr := '';
    nCount := nListView.Columns.Count - 1;

    for i:=0 to nCount do
    begin
      nStr := nStr + IntToStr(nListView.Columns[i].Width);
      if i <> nCount then nStr := nStr + ';';
    end;

    nTmp.WriteString(nID, nListView.Name + '_Cols', nStr);
  finally
    if not Assigned(nIni) then FreeAndNil(nTmp);
  end;
end;

end.


