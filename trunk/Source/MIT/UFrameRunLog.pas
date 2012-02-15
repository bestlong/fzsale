{*******************************************************************************
  ����: dmzn@163.com 2011-10-29
  ����: ����ʱ������־
*******************************************************************************}
unit UFrameRunLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrSync, UFrameBase, StdCtrls, ExtCtrls;

type
  TfFrameRunLog = class(TfFrameBase)
    Panel1: TPanel;
    Check1: TCheckBox;
    MemoLog: TMemo;
    BtnClear: TButton;
    BtnCopy: TButton;
    procedure Check1Click(Sender: TObject);
    procedure BtnCopyClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
  private
    { Private declarations }
    FShowLog: Integer;
    //��ʾ��־
    FSyncer: TDataSynchronizer;
    //ͬ������
    procedure Showlog(const nMsg: string; const nMustShow: Boolean);
    //��ʾ��־
    procedure DoSync(const nData: Pointer; const nSize: Cardinal);
    procedure DoFree(const nData: Pointer; const nSize: Cardinal);
    //ͬ������
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, USysConst, ULibFun;

const
 cNo  = $0001;
 cYes = $0010;
 cBuf = 200; 

class function TfFrameRunLog.FrameID: integer;
begin
  Result := cFI_FrameRunlog;
end;

procedure TfFrameRunLog.OnCreateFrame;
begin
  gDebugLog := Showlog;
  FShowLog := cNo;
  FSyncer := TDataSynchronizer.Create;
  FSyncer.SyncEvent := DoSync;
  FSyncer.SyncFreeEvent := DoFree;
end;

procedure TfFrameRunLog.OnDestroyFrame;
begin
  gDebugLog := nil;
  FSyncer.Free;
end;

procedure TfFrameRunLog.Check1Click(Sender: TObject);
begin
  if Check1.Checked then
       InterlockedExchange(FShowLog, cYes)
  else InterlockedExchange(FShowlog, cNo);
end;

//Desc: �̵߳���
procedure TfFrameRunLog.Showlog(const nMsg: string; const nMustShow: Boolean);
var nPtr: PChar;
    nLen: Integer;
begin
  if nMustShow or (FShowLog = cYes) then
  begin
    nLen := Length(nMsg);
    if nLen > cBuf then
      nLen := cBuf;
    nLen := nLen + 1;

    nPtr := GetMemory(nLen);
    StrLCopy(nPtr, PChar(nMsg + #0), nLen);

    FSyncer.AddData(nPtr, nLen);
    FSyncer.ApplySync;
  end;
end;

procedure TfFrameRunLog.DoFree(const nData: Pointer; const nSize: Cardinal);
begin
  FreeMem(nData, nSize);
end;

procedure TfFrameRunLog.DoSync(const nData: Pointer; const nSize: Cardinal);
var nStr: string;
begin
  if not (csDestroying in ComponentState) then
  begin
    if MemoLog.Lines.Count > 200 then
      MemoLog.Clear;
    //clear logs

    nStr := Format('��%s��::: %s', [DateTime2Str(Now), StrPas(nData)]);
    MemoLog.Lines.Add(nStr);
  end;
end;

procedure TfFrameRunLog.BtnCopyClick(Sender: TObject);
begin
  MemoLog.SelectAll;
  MemoLog.CopyToClipboard;
  ShowMsg('�Ѹ��Ƶ�ճ����', sHint);
end;

procedure TfFrameRunLog.BtnClearClick(Sender: TObject);
begin
  MemoLog.Clear;
  ShowMsg('��־�����', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFrameRunLog, TfFrameRunLog.FrameID);
end.
