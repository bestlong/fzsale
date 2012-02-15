{*******************************************************************************
  ����: dmzn@163.com 2011-11-21
  ����: ��Ʒ����Ԥ��
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
    //��ͼ����
    FIgnorLoad: Boolean;
    //������
    procedure OnBtnClick(Sender: TObject);
    procedure OnBtnClick2(Sender: TObject);
    //�����ť
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
    //����

    AddHeader('���', 50);
    AddHeader('��ʽ����', 50);
    AddHeader('�ܿ����', 50);
    AddHeader('����', 50);
  end;

  with FPainterEx do
  begin
    HeaderFont.Style := HeaderFont.Style + [fsBold];
    //����

    AddHeader('���', 50, True);
    AddHeader('��Ʒ����', 50, True);
    AddHeader('��ɫ', 50, True);
    AddHeader('����', 50);
    AddHeader('��һ��������', 50);
    AddHeader('���п��', 50);
    AddHeader('Ԥ�ƶϻ�ʱ��', 50);
    AddHeader('��������', 50);
    AddHeader('�������', 50, True);
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
