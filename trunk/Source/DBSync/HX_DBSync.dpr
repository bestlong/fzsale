program HX_DBSync;

{$I link.inc}
uses
  FastMM4,
  Windows,
  USysFun,
  Forms,
  UFormMain in 'UFormMain.pas' {fFormMain},
  UFrameBase in '..\Common\UFrameBase.pas' {fFrameBase: TFrame},
  UFrameSummary in 'UFrameSummary.pas' {fFrameSummary: TFrame},
  USysConst in 'USysConst.pas',
  UROModule in 'UROModule.pas' {ROModule: TDataModule},
  UDataModule in 'UDataModule.pas' {FDM: TDataModule},
  UFrameRunStatus in 'UFrameRunStatus.pas' {fFrameRunStatus: TFrame},
  UFrameSysParam in 'UFrameSysParam.pas' {fFrameSysParam: TFrame},
  SrvDB_Impl in 'SrvDB_Impl.pas',
  SrvConn_Impl in 'SrvConn_Impl.pas',
  UFrameRunLog in 'UFrameRunLog.pas' {fFrameRunLog: TFrame},
  UFrameConnParam in 'UFrameConnParam.pas' {fFrameConnParam: TFrame},
  UFrameRegiste in 'UFrameRegiste.pas' {fFrameRegiste: TFrame};

{$R *.res}
{$R RODLFile.res}

{$IFDEF OnlyInstance}
var
  gMutexHwnd: Hwnd;
  //互斥句柄
{$ENDIF}

begin
  {$IFDEF OnlyInstance}
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_HX_DBSync');
  //创建互斥量
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //已有一个实例
  {$ENDIF}

  Application.Initialize;
  InitSystemEnvironment;
  LoadSysParameter;

  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TROModule, ROModule);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;

  {$IFDEF OnlyInstance}
  ReleaseMutex(gMutexHwnd);
  CloseHandle(gMutexHwnd);
  {$ENDIF}
end.
