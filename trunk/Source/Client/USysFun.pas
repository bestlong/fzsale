{*******************************************************************************
  作者: dmzn@163.com 2007-10-09
  描述: 项目通用函数定义单元
*******************************************************************************}
unit USysFun;

interface

uses
  Windows, Classes, ComCtrls, Forms, SysUtils, IniFiles, Graphics, Registry,
  cxListView, UBase64, ZnMD5, ULibFun, USysConst, USysDB, Grids, Controls,
  StdCtrls, UMgrSndPlay;

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

function Md5Str(const nStr: string): string;
//MD5字符串

function RegularMoney(const nMoney: Double): Double;
//格式化金额
procedure ReadMoney(const nPath,nMoney: string; const nIn: Boolean = True);
//语音读取金额'

function BillStatusDesc(const nStatus: string; nIsBill: Boolean = True): string;
//订单状态描述

procedure GetDateInterval(const nType: Byte; var nStart,nEnd: TDate);
//计算特定的日期间隔

function AdjustLabelCaption(const nLabel: TLabel; const nGrid: TDrawGrid): Integer;
//依据nGrid表头宽度调整nLabel内容
function GetGridHeaderWidth(const nGrid: TDrawGrid; nBC: Integer = 32): Integer;
//计算nGrid表头宽度

procedure LoadcxListViewConfig(const nID: string; const nListView: TcxListView;
 const nIni: TIniFile = nil);
procedure SavecxListViewConfig(const nID: string; const nListView: TcxListView;
 const nIni: TIniFile = nil);
//cxListView配置

procedure LoadDrawGridConfig(const nID: string; const nGrid: TDrawGrid;
 const nIni: TIniFile = nil);
procedure SaveDrawGridConfig(const nID: string; const nGrid: TDrawGrid;
 const nIni: TIniFile = nil);
//TGrawGrid配置

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
        FAutoStart := nReg.ValueExists('HX_Saler');
        FAutoMin := ReadBool('AutoAction', 'AutoMin', False);
      end else
      begin
        WriteBool('AutoAction', 'AutoMin', FAutoMin);
        //自动处理
        
        if FAutoStart then
          nReg.WriteString('HX_Saler', Application.ExeName)
        else if nReg.ValueExists('HX_Saler') then
          nReg.DeleteValue('HX_Saler');
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

//Desc: 对nStr做md5加密
function Md5Str(const nStr: string): string;
begin
  Result := MD5Print(MD5String(nStr));
end;

//Desc: 格式化金额
function RegularMoney(const nMoney: Double): Double;
var nStr: string;
    nInt: Integer;
begin
  nStr := Format('%.2f', [nMoney]);
  System.Delete(nStr, 1, Pos('.', nStr));
  nInt := StrToInt(nStr);

  if nInt > 50 then
    Result := Trunc(nMoney) + 1
  else if nInt > 10 then
    Result := StrToFloat(IntToStr(Trunc(nMoney)) + '.50')
  else Result := Trunc(nMoney);
end;

//Desc: 返回订单状态nStatus的描述
function BillStatusDesc(const nStatus: string; nIsBill: Boolean): string;
begin
  if nStatus = sFlag_BillNew then Result := '新订单' else
  if nStatus = sFlag_BillLock then Result := '待确认' else
  if nStatus = sFlag_BillCancel then Result := '已取消' else
  if nStatus = sFlag_BillAccept then Result := '代理接受' else
  if nStatus = sFlag_BillDeliver then Result := '代理发货' else
  if nStatus = sFlag_BillTakeDeliv then Result := '已收货' else
  if nStatus = sFlag_BillDone then Result := '已完成' else Result := '';

  if not nIsBill then
  begin
    if nStatus = sFlag_BillNew then Result := '已确认' else
    if nStatus = sFlag_BillDeliver then Result := '已发货' else
    if nStatus = sFlag_BillTakeDeliv then Result := '代理收货';
  end;
end;

//Desc: 按nType计算特定日期间隔
procedure GetDateInterval(const nType: Byte; var nStart,nEnd: TDate);
var nInt: Integer;
    nY,nM,nD: Word;
begin
  DecodeDate(Now, nY, nM, nD);
  //xxxxx

  case nType of
   1: //昨日
    begin
      nStart := Date() - 1;
      nEnd := Date() - 1;
    end;
   2: //本月
    begin
      nStart := EncodeDate(nY, nM, 1);
      Inc(nM);

      if nM > 12 then
      begin
        nM := 1; Inc(nY);
      end;
      nEnd := EncodeDate(nY, nM, 1) - 1;
    end;
   3: //本季度
    begin
      nInt := (Trunc((nM - 1)/ 3) + 1);
      //当前季度
      nStart := EncodeDate(nY, (nInt - 1) * 3 + 1, 1);

      Inc(nInt);
      if nInt > 4 then
      begin
        nInt := 0; Inc(nY);
      end;
      nEnd := EncodeDate(nY, (nInt - 1) * 3 + 4, 1) - 1;
    end;
   4: //本年
    begin
      nStart := EncodeDate(nY, 1, 1);
      nEnd := EncodeDate(nY+1, 1, 1) - 1;
    end else
      //今天
    begin
      nStart := Date();
      nEnd := Date();
    end;
  end;
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

procedure LoadDrawGridConfig(const nID: string; const nGrid: TDrawGrid;
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

    nList.Text := StringReplace(nTmp.ReadString(nID, nGrid.Name + '_Cols',
                                ''), ';', #13, [rfReplaceAll]);
    if nList.Count <> nGrid.ColCount then Exit;

    nCount := nGrid.ColCount - 1;
    for i:=0 to nCount do
     if IsNumber(nList[i], False) then
      nGrid.ColWidths[i] := StrToInt(nList[i]);
    //xxxxx
  finally
    nList.Free;
    if not Assigned(nIni) then FreeAndNil(nTmp);
  end;
end;

procedure SaveDrawGridConfig(const nID: string; const nGrid: TDrawGrid;
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
    nCount := nGrid.ColCount - 1;

    for i:=0 to nCount do
    begin
      nStr := nStr + IntToStr(nGrid.ColWidths[i]);
      if i <> nCount then nStr := nStr + ';';
    end;

    nTmp.WriteString(nID, nGrid.Name + '_Cols', nStr);
  finally
    if not Assigned(nIni) then FreeAndNil(nTmp);
  end;
end;

//Desc: 计算nGrid表头宽度,带补偿宽度
function GetGridHeaderWidth(const nGrid: TDrawGrid; nBC: Integer): Integer;
var nIdx: Integer;
begin
  Result := 0;
  for nIdx:=0 to nGrid.ColCount - 1 do
    Result := Result + nGrid.ColWidths[nIdx];
  //xxxxx

  if Result < 10 then
       Result := nBC
  else Result := Result + nBC;
end;

//Desc: 使nLabel.Caption视觉显示为nGrid的中间位置
function AdjustLabelCaption(const nLabel: TLabel; const nGrid: TDrawGrid): Integer;
var nW: Integer;
begin
  with nLabel do
  begin
    Canvas.Font.Assign(nLabel.Font);
    nW := GetGridHeaderWidth(nGrid, 0);
    
    nW := nW - Canvas.TextWidth(Caption);
    nW := Trunc(nW / 2);

    if nW > 0 then
      Caption := StringOfChar(' ', Trunc(nW / Canvas.TextWidth(' '))) + Caption;
    Result := Canvas.TextWidth(Caption);
  end;
end;

//------------------------------------------------------------------------------
const
  cMoneyIn = '女_income.wav';
  cMoneyOut = '女_outcome.wav';
  
  cMoneyYI = '女_亿.wav';
  cMoneyWan = '女_万.wav';
  cMoneyYuan = '女_元.wav';
  cMoneyZheng = '女_整.wav';

  cMoneyNums: array[0..9] of string = ('女_零.wav', '女_壹.wav',
    '女_贰.wav', '女_叁.wav', '女_肆.wav', '女_伍.wav', '女_陆.wav',
    '女_柒.wav', '女_捌.wav', '女_玖.wav');

  cMoneyPos: array[0..3] of string = ('', '女_拾.wav', '女_佰.wav', '女_仟.wav');
  cMoneyPos2: array[1..2] of string = ('女_角.wav', '女_分.wav');

//Desc:
procedure ReadMoney(const nPath,nMoney: string; const nIn: Boolean);
var nStr: string;
    nNum: Byte;
    i,nIdx,nLen: Integer;
    nList,nTmp: TStrings;
begin
  nTmp := nil;
  nList := nil;
  try
    nTmp := TStringList.Create;
    nList := TStringList.Create;

    if nIn then
         nList.Add(nPath + cMoneyIn)
    else nList.Add(nPath + cMoneyOut);

    nLen := Pos('.', nMoney);
    if nLen > 0 then
         nStr := Copy(nMoney, 1, nLen -1)
    else nStr := nMoney;

    while nStr <> '' do
    begin
      nLen := Length(nStr);
      if nLen > 4 then
      begin
        nTmp.Add(Copy(nStr, nLen - 3, 4));
        System.Delete(nStr, nLen - 3, 4);
      end else
      begin
        nTmp.Add(nStr);
        nStr := '';
      end;
    end;

    for i:=nTmp.Count - 1 downto 0 do
    begin
      nStr := nTmp[i];
      nLen := Length(nStr);
      nIdx := 1;

      while nIdx<= nLen do
      begin
        nNum := StrToInt(nStr[nIdx]);
        nList.Add(nPath + cMoneyNums[nNum]);
        
        if (nLen - nIdx > 0) and (nStr[nIdx] <> '0')  then
          nList.Add(nPath + cMoneyPos[nLen - nIdx]);
        Inc(nIdx);

        while True do
        begin
          if (nIdx > nLen) or (nStr[nIdx] <> '0') then Break;
          if (nNum > 0) and (nIdx + 1 <= nLen) and (nStr[nIdx+1] <> '0') then Break;

          Inc(nIdx);
        end; //合并0
      end;

      if i mod 2 > 0 then nList.Add(nPath + cMoneyWan) else
      if (i mod 2 = 0) and (i > 0) then nList.Add(nPath + cMoneyYI);
    end;

    nList.Add(nPath + cMoneyYuan);
    nLen := Pos('.', nMoney);
    if nLen < 2 then
    begin
      nList.Add(nPath + cMoneyZheng);
      gSoundPlayManager.PlaySounds(nList); Exit;
    end;

    nStr := Copy(nMoney, nLen + 1, 2);
    nLen := Length(nStr);

    for nIdx:=1 to nLen do
    begin
      nList.Add(nPath + cMoneyNums[StrToInt(nStr[nIdx])]);
      if nStr[nIdx] <> '0' then
        nList.Add(nPath + cMoneyPos2[nIdx]);
      //xxxxx
    end;

    gSoundPlayManager.PlaySounds(nList);
  finally
    nTmp.Free;
    nList.Free;
  end;
end;

end.


