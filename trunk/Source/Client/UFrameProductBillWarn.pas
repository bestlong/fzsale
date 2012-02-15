{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 商品智能预警
*******************************************************************************}
unit UFrameProductBillWarn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, StdCtrls,
  cxButtons, cxLabel, cxRadioGroup, Grids, UGridPainter, UGridExPainter,
  ExtCtrls, cxPC;

type
  TfFrameProductBillWarn = class(TfFrameBase)
    Label1: TLabel;
    wPage: TcxPageControl;
    Sheet1: TcxTabSheet;
    GridProduct: TDrawGridEx;
    Sheet2: TcxTabSheet;
    GridIgnor: TDrawGridEx;
  private
    { Private declarations }
    FPainter: TGridPainter;
    FPainterEx: TGridExPainter;
    //绘图对象
    FIgnorLoad: Boolean;
    //载入标记
    procedure OnBtnClick(Sender: TObject);
    procedure OnBtnClick2(Sender: TObject);
    //点击按钮
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UDataModule, DB, UMgrControl, USysConst, USysDB, USysFun;

class function TfFrameProductBillWarn.FrameID: integer;
begin
  Result := cFI_FrameBillWarn;
end;

procedure TfFrameProductBillWarn.OnCreateFrame;
var nIni: TIniFile;
begin
  Name := MakeFrameName(FrameID);
  FIgnorLoad := False;

  FPainter := TGridPainter.Create(GridIgnor);
  FPainterEx := TGridExPainter.Create(GridProduct);

  with FPainter do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50);
    AddHeader('款式名称', 50);
    AddHeader('总库存量', 50);
    AddHeader('操作', 50);
  end;

  with FPainterEx do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //粗体

    AddHeader('序号', 50, True);
    AddHeader('商品名称', 50, True);
    AddHeader('颜色', 50, True);
    AddHeader('尺码', 50);
    AddHeader('近一周日销量', 50);
    AddHeader('现有库存', 50);
    AddHeader('预计断货时间', 50);
    AddHeader('单个操作', 50);
    AddHeader('整体操作', 50, True);
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadDrawGridConfig(Name, GridProduct, nIni);
    LoadDrawGridConfig(Name, GridIgnor, nIni);

    wPage.ActivePage := Sheet1;
  finally
    nIni.Free;
  end;
end;

procedure TfFrameProductBillWarn.OnDestroyFrame;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveDrawGridConfig(Name, GridProduct, nIni);
    SaveDrawGridConfig(Name, GridIgnor, nIni);
  finally
    nIni.Free;
  end;

  FPainter.Free;
  FPainterEx.Free;
end;

procedure TfFrameProductBillWarn.OnBtnClick(Sender: TObject);
begin

end;

procedure TfFrameProductBillWarn.OnBtnClick2(Sender: TObject);
begin

end;

initialization
  gControlManager.RegCtrl(TfFrameProductBillWarn, TfFrameProductBillWarn.FrameID);
end.
