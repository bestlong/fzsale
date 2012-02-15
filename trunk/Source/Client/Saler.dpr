program Saler;

{$I link.inc}
uses
  Windows,
  Forms,
  USysFun,
  UFormMain in 'UFormMain.pas' {fFormMain},
  USkinFormBase in '..\..\..\..\Program Files\MyVCL\ZnLib\LibForm\USkinFormBase.pas' {SkinFormBase},
  UFormLogin in 'UFormLogin.pas' {fFormLogin},
  UDataModule in 'UDataModule.pas' {FDM: TDataModule},
  UFrameBase in '..\Common\UFrameBase.pas' {fFrameBase: TFrame},
  UFrameTerminalInfo in 'UFrameTerminalInfo.pas' {fFrameTerminalInfo: TFrame},
  UFrameUserPassword in 'UFrameUserPassword.pas' {fFrameUserPassword: TFrame},
  UFrameUserAccount in 'UFrameUserAccount.pas' {fFrameUserAccount: TFrame},
  UFormAddAccount in 'UFormAddAccount.pas' {fFormAddAccount},
  UFrameNewMember in 'UFrameNewMember.pas' {fFrameNewMember: TFrame},
  UFrameMembers in 'UFrameMembers.pas' {fFrameMembers: TFrame},
  UFrameProductInit in 'UFrameProductInit.pas' {fFrameProductInit: TFrame},
  UFormProductInit in 'UFormProductInit.pas' {fFormProductInit},
  UFrameProductView in 'UFrameProductView.pas' {fFrameProductView: TFrame},
  UFrameProductKC in 'UFrameProductKC.pas' {fFrameProductKC: TFrame},
  UFormProductPrice in 'UFormProductPrice.pas' {fFormProductPrice},
  UFormProductBill in 'UFormProductBill.pas' {fFormProductBill},
  UFormBillConfirm in 'UFormBillConfirm.pas' {fFormBillConfirm},
  UFrameProductBill in 'UFrameProductBill.pas' {fFrameProductBill: TFrame},
  UFrameProductBillYS in 'UFrameProductBillYS.pas' {fFrameProductBillYS: TFrame},
  UFormProductBillView in 'UFormProductBillView.pas' {fFormProductBillView},
  UFormProductBillSH in 'UFormProductBillSH.pas' {fFormProductBillSH},
  UFormProductBillDeal in 'UFormProductBillDeal.pas' {fFormProductBillDeal},
  UFormProductBillAdjust in 'UFormProductBillAdjust.pas' {fFormProductBillAdjust},
  UFrameProductBillWarn in 'UFrameProductBillWarn.pas' {fFrameProductBillWarn: TFrame},
  UFrameProductSale in 'UFrameProductSale.pas' {fFrameProductSale: TFrame},
  UFormProductGet in 'UFormProductGet.pas' {fFormProductGet},
  UFormProductConfirm in 'UFormProductConfirm.pas' {fFormProductConfirm},
  UFormMemberGet in 'UFormMemberGet.pas' {fFormMemberGet},
  UFrameMemberSet in 'UFrameMemberSet.pas' {fFrameMemberSet: TFrame},
  UFormProductCode in 'UFormProductCode.pas' {fFormProductCode},
  UFormProductFilterColor in 'UFormProductFilterColor.pas' {fFormProductFilterColor},
  UFormProductFilterSize in 'UFormProductFilterSize.pas' {fFormProductFilterSize},
  UFormProductJZ in 'UFormProductJZ.pas' {fFormProductJZ},
  UFormProductTH in 'UFormProductTH.pas' {fFormProductTH},
  UDataReport in 'UDataReport.pas' {FDR: TDataModule},
  UFormPrinter in 'UFormPrinter.pas' {fFormPrinterSetup},
  UFormMemberView in 'UFormMemberView.pas' {fFormMemberView},
  UFrameReportSaleDtl in 'UFrameReportSaleDtl.pas' {fFrameReportSaleDtl: TFrame},
  UFrameReportSaleTotal in 'UFrameReportSaleTotal.pas' {fFrameReportSaleTotal: TFrame},
  UFrameReportProductJH in 'UFrameReportProductJH.pas' {fFrameReportProductJH: TFrame},
  UFrameReportProductTH in 'UFrameReportProductTH.pas' {fFrameReportProductTH: TFrame},
  UFrameReportSaler in 'UFrameReportSaler.pas' {fFrameReportSaler: TFrame},
  UFormReportSalerView in 'UFormReportSalerView.pas' {fFormReportSalerView},
  UFrameNotices in 'UFrameNotices.pas' {fFrameNotices: TFrame},
  UFormProductReturn in 'UFormProductReturn.pas' {fFormProductReturn},
  UFormReturnConfirm in 'UFormReturnConfirm.pas' {fFormReturnConfirm},
  UFrameProductReturn in 'UFrameProductReturn.pas' {fFrameProductReturn: TFrame},
  UFormProductReturnAdjust in 'UFormProductReturnAdjust.pas' {fFormProductReturnAdjust},
  UFormProductReturnView in 'UFormProductReturnView.pas' {fFormProductReturnView},
  UFrameReportProductReturn in 'UFrameReportProductReturn.pas' {fFrameReportProductReturn: TFrame},
  UFrameSummary in 'UFrameSummary.pas' {fFrameSummary: TFrame};

{$R *.res}
{$IFDEF OnlyInstance}
var
  gMutexHwnd: Hwnd;
  //互斥句柄
{$ENDIF}

begin
  {$IFDEF OnlyInstance}
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_HX_Saler');
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
  Application.CreateForm(TFDR, FDR);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;

  {$IFDEF OnlyInstance}
  ReleaseMutex(gMutexHwnd);
  CloseHandle(gMutexHwnd);
  {$ENDIF}
end.
