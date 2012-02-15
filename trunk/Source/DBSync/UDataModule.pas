{*******************************************************************************
  ����: dmzn@163.com 2009-5-20
  ����: ���ݿ����ӡ�������� 
*******************************************************************************}
unit UDataModule;

{$I Link.Inc}
interface

uses
  Windows, Graphics, SysUtils, Classes, ULibFun, SyncObjs, XPMan, ImgList,
  Controls, cxGraphics, DB, ADODB;

type
  TFDM = class(TDataModule)
    LocalConn: TADOConnection;
    LocalQuery: TADOQuery;
    LocalCmd: TADOQuery;
    ImageBig: TcxImageList;
    Imagesmall: TcxImageList;
    ImageMid: TcxImageList;
    XPM1: TXPManifest;
    ImageBar: TcxImageList;
    ConnTest: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
    function QuerySQL(const nSQL: string): TDataSet;
    procedure QueryData(const nQuery: TADOQuery; const nSQL: string);
    {*��ѯ����*}
    function ExecuteSQL(const nSQL: string; const nCmd: TADOQuery = nil): integer;
    {*ִ��д����*}
    function AdjustAllSystemTables: Boolean;
    {*У��ϵͳ��*}
    function WriteSysLog(const nGroup,nItem,nEvent: string;
     const nHint: Boolean = True;
     const nKeyID: string = ''; const nMan: string = ''): Boolean;
    {*ϵͳ��־*}
    function SQLServerNow: string;
    function ServerNow: TDateTime;
    {*������ʱ��*}
    function GetFieldMax(const nTable,nField: string): integer;
    {*�ֶ����ֵ*}
    function GetRandomID(const nPrefix: string; const nIDLen: Integer): string;
    function GetSerialID(const nPrefix,nTable,nField: string;
     const nIncLen: Integer = 3): string;
    function GetSerialID2(const nPrefix,nTable,nKey,nField: string;
     const nFixID: Integer; const nIncLen: Integer = 3): string;
    function GetNeighborID(const nID: string;const nNext: Boolean;
     const nIncLen: Integer = 3): string;
    {*�Զ����*}
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}
uses
  USysDB, USysConst;

//------------------------------------------------------------------------------
//Desc: У��ϵͳ��,������������
function TFDM.AdjustAllSystemTables: Boolean;
var nStr: string;
    nList: TStrings;
    nP: PSysTableItem;
    i,nCount: integer;
begin
  nList := TStringList.Create;
  try
    FDM.LocalConn.GetTableNames(nList);
    nCount := gSysTableList.Count - 1;

    for i:=0 to nCount do
    begin
      nP := gSysTableList[i];
      if nList.IndexOf(nP.FTable) > -1 then Continue;

      if gSysDBType = dtAccess then
      begin
        nStr := MacroValue(nP.FNewSQL, [MI('$Inc', sField_Access_AutoInc),
                                        MI('$Float', sField_Access_Decimal),
                                        MI('$Image', sField_Access_Image)]);
      end else

      if gSysDBType = dtSQLServer then
      begin
        nStr := MacroValue(nP.FNewSQL, [MI('$Inc', sField_SQLServer_AutoInc),
                                        MI('$Float', sField_SQLServer_Decimal),
                                        MI('$Image', sField_SQLServer_Image)]);
      end;

      nStr := MacroValue(nStr, [MI('$Table', nP.FTable),
                                MI('$Integer', sFlag_Integer),
                                MI('$Decimal', sFlag_Decimal)]);
      FDM.ExecuteSQL(nStr);
    end;

    nList.Free;
    Result := True;
  except
    nList.Free;
    Result := False;
  end;
end;

//Date: 2009-6-8
//Parm: ��Ϣ����;��ʶ;�¼�;������ʶ;������
//Desc: ��ϵͳ��־��д��һ����־��¼
function TFDM.WriteSysLog(const nGroup, nItem, nEvent: string;
  const nHint: Boolean; const nKeyID, nMan: string): Boolean;
var nStr,nSQL: string;
begin
  nSQL := 'Insert Into $T(L_Date,L_Man,L_Group,L_ItemID,L_KeyID,L_Event) ' +
          'Values($D,''$M'',''$G'',''$I'',''$K'',''$E'')';
  nSQL := MacroValue(nSQL, [MI('$T', sTable_SysLog), MI('$D', SQLServerNow),
                            MI('$G', nGroup), MI('$I', nItem),
                            MI('$E', nEvent), MI('$K', nKeyID)]);

  if nMan = '' then
       nStr := gSysParam.FUserName
  else nStr := nMan;

  nSQL := MacroValue(nSQL, [MI('$M', nStr)]);
  try
    ExecuteSQL(nSQL);
    Result := True;
  except
    Result := False;
    if nHint then ShowMsg('д��ϵͳ��־ʱ��������', sHint);
  end;
end;

//Date: 2010-3-5
//Desc: sql����п��õķ�����ʱ��
function TFDM.SQLServerNow: string;
begin
  if gSysDBType = dtSQLServer then
       Result := sField_SQLServer_Now
  else Result := Format('''%s''', [DateTime2Str(Now)]);
end;

//Date: 2010-3-19
//Parm: ֻȡ������
//Desc: ���ط�������ʱ��
function TFDM.ServerNow: TDateTime;
var nStr: string;
begin
  nStr := 'Select ' + sField_SQLServer_Now;
  Result := FDM.QuerySQL(nStr).Fields[0].AsDateTime;
end;

//Date: 2009-6-10
//Parm: ����;�ֶ�
//Desc: ��ȡnTable.nField�����ֵ
function TFDM.GetFieldMax(const nTable, nField: string): integer;
var nStr: string;
begin
  nStr := 'Select Max(%s) From %s';
  nStr := Format(nStr, [nField, nTable]);

  with QuerySQL(nStr) do
  begin
    Result := Fields[0].AsInteger;
  end;
end;  

//Desc: ����ǰ׺ΪnPrefix,����ΪnIDLen��������
function TFDM.GetRandomID(const nPrefix: string; const nIDLen: Integer): string;
var nStr,nChar: string;
    nIdx,nMid: integer;
begin
  nStr := FloatToStr(Now);
  while Length(nStr) < nIDLen do
    nStr := nStr + FloatToStr(Now);
  //xxxxx

  nStr := StringReplace(nStr, '.', '0', [rfReplaceAll]);
  nMid := Trunc(Length(nStr) / 2);

  for nIdx:=1 to nMid do
  begin
    nChar := nStr[nIdx];
    nStr[nIdx] := nStr[2 * nMid - nIdx];
    nStr[2 * nMid - nIdx] := nChar[1];
  end;

  Result := nPrefix + Copy(nStr, 1, nIDLen - Length(nPrefix));
end;

//Date: 2009-8-30
//Parm: ǰ׺;����;�ֶ�;����������ų�
//Desc: ����ǰ׺ΪnPrefix,��nTable.nFieldΪ�ο����������
function TFDM.GetSerialID(const nPrefix, nTable, nField: string;
 const nIncLen: Integer = 3): string;
var nStr,nTmp: string;
begin
  Result := '';
  try
    nStr := 'Select getDate()';
    nTmp := FormatDateTime('YYMMDD', QuerySQL(nStr).Fields[0].AsDateTime);

    nStr := 'Select Top 1 $F From $T Where $F Like ''$P$D%'' Order By $F DESC';
    nStr := MacroValue(nStr, [MI('$T', nTable), MI('$F', nField),
            MI('$D', nTmp), MI('$P', nPrefix)]);
    //xxxxx

    with QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      nStr := Fields[0].AsString;
      nStr := Copy(nStr, Length(nStr) - nIncLen + 1, nIncLen);

      if IsNumber(nStr, False) then
           nStr := IntToStr(StrToInt(nStr) + 1)
      else nStr := '1';
    end else nStr := '1';

    nStr := StringOfChar('0', nIncLen - Length(nStr)) + nStr;
    Result := nPrefix + nTmp + nStr;
  except
    //ignor any error
  end;
end;

//Date: 2010-3-4
//Parm: ǰ׺;����;��������;�ֶ�;�������;��ų�
//Desc: ����nFixID��Ӧ����nPrefixΪǰ׺,nTable.nFieldΪ�ο����������
function TFDM.GetSerialID2(const nPrefix, nTable, nKey, nField: string;
  const nFixID: Integer; const nIncLen: Integer): string;
var nInt: Integer;
    nStr,nTmp: string;
begin
  Result := '';
  try
    nStr := 'Select getDate()';
    nTmp := FormatDateTime('YYMMDD', QuerySQL(nStr).Fields[0].AsDateTime);

    nStr := 'Select Top 1 $K,$F From $T Where $F Like ''$P$D%'' Order By $F DESC';
    nStr := MacroValue(nStr, [MI('$T', nTable), MI('$F', nField),
            MI('$D', nTmp), MI('$K', nKey), MI('$P', nPrefix)]);
    //xxxxx

    with QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      if nFixID = Fields[0].AsInteger then
      begin
        Result := Fields[1].AsString; Exit;
      end;

      if nFixID < Fields[0].AsInteger then
      begin
        nStr := 'Select $F From $T Where $K=$ID';
        nStr := MacroValue(nStr, [MI('$F', nField), MI('$T', nTable),
                MI('$K', nKey), MI('$ID', IntToStr(nFixID))]);
        //xxxxx

        with FDM.QuerySQL(nStr) do
        if RecordCount > 0 then
          Result := Fields[0].AsString;
        Exit;
      end;

      nStr := Fields[1].AsString;
      System.Delete(nStr, 1, Length(nPrefix + nTmp));

      if IsNumber(nStr, False) then
      begin
        nInt := Fields[0].AsInteger - StrToInt(nStr);
        nStr := IntToStr(nFixID - nInt);
      end else nStr := '1';
    end else nStr := '1';

    nStr := StringOfChar('0', nIncLen - Length(nStr)) + nStr;
    Result := nPrefix + nTmp + nStr;
  except
    //ignor any error
  end;
end;

//Date: 2009-8-20
//Parm: ���;�Ƿ���һ��
//Desc: ������nID���ڵ���һ������һ�����
function TFDM.GetNeighborID(const nID: string;const nNext: Boolean;
 const nIncLen: Integer = 3): string;
var nStr: string;
    nLen: integer;
begin
  nLen := Length(nID);
  nStr := Copy(nID, nLen - nIncLen - 1, nIncLen);

  if IsNumber(nStr, False) then
  begin
    if nNext then
         nStr := IntToStr(StrToInt(nStr) + 1)
    else nStr := IntToStr(StrToInt(nStr) - 1);
  end else nStr := '1';

  nStr := StringOfChar('0', nIncLen - Length(nStr)) + nStr;
  Result := Copy(nID, 1, nLen - nIncLen) + nStr;
end;

//------------------------------------------------------------------------------
//Desc: ִ��nSQLд����
function TFDM.ExecuteSQL(const nSQL: string; const nCmd: TADOQuery): integer;
begin
  try
    if Assigned(nCmd) then
    begin
      nCmd.Close;
      nCmd.SQL.Text := nSQL;
      Result := nCmd.ExecSQL;
    end else
    begin
      LocalCmd.Close;
      LocalCmd.SQL.Text := nSQL;
      Result := LocalCmd.ExecSQL;
    end;
  except
    Result := -1;
  end;
end;

//Desc: �����ѯ
function TFDM.QuerySQL(const nSQL: string): TDataSet;
begin
  try
    if not LocalConn.Connected then
      LocalConn.Connected := True;
    //try reconnect

    LocalQuery.Close;
    LocalQuery.SQL.Text := nSQL;
    LocalQuery.Open;
    
    Result := LocalQuery;
  except
    Result := nil;
  end;
end;

//Desc: ��nQueryִ��nSQL���
procedure TFDM.QueryData(const nQuery: TADOQuery; const nSQL: string);
var nBookMark: Pointer;
begin
  try
    nQuery.DisableControls;
    nBookMark := nQuery.GetBookmark;
    try
      nQuery.Close;
      nQuery.SQL.Text := nSQL;
      nQuery.Open;

      if nQuery.BookmarkValid(nBookMark) then
        nQuery.GotoBookmark(nBookMark);
    finally
      nQuery.FreeBookmark(nBookMark);
      nQuery.EnableControls;
    end;
  except
    //ignor any error
  end;
end;

end.
