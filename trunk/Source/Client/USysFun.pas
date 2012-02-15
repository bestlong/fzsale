{*******************************************************************************
  ����: dmzn@163.com 2007-10-09
  ����: ��Ŀͨ�ú������嵥Ԫ
*******************************************************************************}
unit USysFun;

interface

uses
  Windows, Classes, ComCtrls, Forms, SysUtils, IniFiles, Graphics, Registry,
  cxListView, UBase64, ZnMD5, ULibFun, USysConst, USysDB, Grids, Controls,
  StdCtrls, UMgrSndPlay;

procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
//��״̬����ʾ��Ϣ

procedure InitSystemEnvironment;
//��ʼ��ϵͳ���л����ı���
procedure LoadSysParameter(const nIni: TIniFile = nil);
//����ϵͳ���ò���
procedure ActionSysParameter(const nIsRead: Boolean; const nIni: TIniFile = nil);
//��дϵͳ���ò���

function MakeFrameName(const nFrameID: integer): string;
//����Frame����
function ReplaceGlobalPath(const nStr: string): string;
//�滻nStr�е�ȫ��·��

function Md5Str(const nStr: string): string;
//MD5�ַ���

function RegularMoney(const nMoney: Double): Double;
//��ʽ�����
procedure ReadMoney(const nPath,nMoney: string; const nIn: Boolean = True);
//������ȡ���'

function BillStatusDesc(const nStatus: string; nIsBill: Boolean = True): string;
//����״̬����

procedure GetDateInterval(const nType: Byte; var nStart,nEnd: TDate);
//�����ض������ڼ��

function AdjustLabelCaption(const nLabel: TLabel; const nGrid: TDrawGrid): Integer;
//����nGrid��ͷ��ȵ���nLabel����
function GetGridHeaderWidth(const nGrid: TDrawGrid; nBC: Integer = 32): Integer;
//����nGrid��ͷ���

procedure LoadcxListViewConfig(const nID: string; const nListView: TcxListView;
 const nIni: TIniFile = nil);
procedure SavecxListViewConfig(const nID: string; const nListView: TcxListView;
 const nIni: TIniFile = nil);
//cxListView����

procedure LoadDrawGridConfig(const nID: string; const nGrid: TDrawGrid;
 const nIni: TIniFile = nil);
procedure SaveDrawGridConfig(const nID: string; const nGrid: TDrawGrid;
 const nIni: TIniFile = nil);
//TGrawGrid����

implementation

//---------------------------------- �������л��� ------------------------------
//Date: 2007-01-09
//Desc: ��ʼ�����л���
procedure InitSystemEnvironment;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);
end;

//Date: 2007-09-13
//Desc: ����ϵͳ���ò���
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
      //�����ʶ�����������в���
      FAppTitle := ReadString(FProgID, 'AppTitle', sAppTitle);
      FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
      FHintText := ReadString(FProgID, 'HintText', '');
      FCopyRight := ReadString(FProgID, 'CopyRight', '');
    end;
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Desc: ��дϵͳ����
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
        //�Զ�����
        
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

//Desc: ����FrameID���������
function MakeFrameName(const nFrameID: integer): string;
begin
  Result := 'Frame' + IntToStr(nFrameID);
end;

//Desc: �滻nStr�е�ȫ��·��
function ReplaceGlobalPath(const nStr: string): string;
var nPath: string;
begin
  nPath := gPath;
  if Copy(nPath, Length(nPath), 1) = '\' then
    System.Delete(nPath, Length(nPath), 1);
  Result := StringReplace(nStr, '$Path', nPath, [rfReplaceAll, rfIgnoreCase]);
end;

//Desc: ��nStr��md5����
function Md5Str(const nStr: string): string;
begin
  Result := MD5Print(MD5String(nStr));
end;

//Desc: ��ʽ�����
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

//Desc: ���ض���״̬nStatus������
function BillStatusDesc(const nStatus: string; nIsBill: Boolean): string;
begin
  if nStatus = sFlag_BillNew then Result := '�¶���' else
  if nStatus = sFlag_BillLock then Result := '��ȷ��' else
  if nStatus = sFlag_BillCancel then Result := '��ȡ��' else
  if nStatus = sFlag_BillAccept then Result := '�������' else
  if nStatus = sFlag_BillDeliver then Result := '������' else
  if nStatus = sFlag_BillTakeDeliv then Result := '���ջ�' else
  if nStatus = sFlag_BillDone then Result := '�����' else Result := '';

  if not nIsBill then
  begin
    if nStatus = sFlag_BillNew then Result := '��ȷ��' else
    if nStatus = sFlag_BillDeliver then Result := '�ѷ���' else
    if nStatus = sFlag_BillTakeDeliv then Result := '�����ջ�';
  end;
end;

//Desc: ��nType�����ض����ڼ��
procedure GetDateInterval(const nType: Byte; var nStart,nEnd: TDate);
var nInt: Integer;
    nY,nM,nD: Word;
begin
  DecodeDate(Now, nY, nM, nD);
  //xxxxx

  case nType of
   1: //����
    begin
      nStart := Date() - 1;
      nEnd := Date() - 1;
    end;
   2: //����
    begin
      nStart := EncodeDate(nY, nM, 1);
      Inc(nM);

      if nM > 12 then
      begin
        nM := 1; Inc(nY);
      end;
      nEnd := EncodeDate(nY, nM, 1) - 1;
    end;
   3: //������
    begin
      nInt := (Trunc((nM - 1)/ 3) + 1);
      //��ǰ����
      nStart := EncodeDate(nY, (nInt - 1) * 3 + 1, 1);

      Inc(nInt);
      if nInt > 4 then
      begin
        nInt := 0; Inc(nY);
      end;
      nEnd := EncodeDate(nY, (nInt - 1) * 3 + 4, 1) - 1;
    end;
   4: //����
    begin
      nStart := EncodeDate(nY, 1, 1);
      nEnd := EncodeDate(nY+1, 1, 1) - 1;
    end else
      //����
    begin
      nStart := Date();
      nEnd := Date();
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ȫ��״̬�����һ��Panel����ʾnMsg��Ϣ
procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > 0) then
  begin
    gStatusBar.Panels[gStatusBar.Panels.Count - 1].Text := nMsg;
    Application.ProcessMessages;
  end;
end;

//Desc: ������nIdx��Panel����ʾnMsg��Ϣ
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
//Parm: ����С����;�б�;��ȡ����
//Desc: ��nIDָ����С�ڶ�ȡnList��������Ϣ
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
//Parm: ����С����;�б�;д�����
//Desc: ��nList����Ϣ����nIDָ����С��
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

//Desc: ����nGrid��ͷ���,���������
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

//Desc: ʹnLabel.Caption�Ӿ���ʾΪnGrid���м�λ��
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
  cMoneyIn = 'Ů_income.wav';
  cMoneyOut = 'Ů_outcome.wav';
  
  cMoneyYI = 'Ů_��.wav';
  cMoneyWan = 'Ů_��.wav';
  cMoneyYuan = 'Ů_Ԫ.wav';
  cMoneyZheng = 'Ů_��.wav';

  cMoneyNums: array[0..9] of string = ('Ů_��.wav', 'Ů_Ҽ.wav',
    'Ů_��.wav', 'Ů_��.wav', 'Ů_��.wav', 'Ů_��.wav', 'Ů_½.wav',
    'Ů_��.wav', 'Ů_��.wav', 'Ů_��.wav');

  cMoneyPos: array[0..3] of string = ('', 'Ů_ʰ.wav', 'Ů_��.wav', 'Ů_Ǫ.wav');
  cMoneyPos2: array[1..2] of string = ('Ů_��.wav', 'Ů_��.wav');

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
        end; //�ϲ�0
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


