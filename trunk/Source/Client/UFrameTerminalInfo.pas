{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 更新店面资料
*******************************************************************************}
unit UFrameTerminalInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, StdCtrls,
  cxButtons, cxLabel, cxRadioGroup, ExtCtrls, UImageButton;

type
  TfFrameTerminalInfo = class(TfFrameBase)
    EditAddr: TcxTextEdit;
    EditName: TcxTextEdit;
    EditUser: TcxTextEdit;
    EditPhone: TcxTextEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Radio1: TcxRadioButton;
    Radio2: TcxRadioButton;
    ImageButton1: TImageButton;
    ImageButton2: TImageButton;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UDataModule, DB, UMgrControl, USysConst, USysDB;

class function TfFrameTerminalInfo.FrameID: integer;
begin
  Result := cFI_FrameMyInfo;
end;

procedure TfFrameTerminalInfo.OnCreateFrame;
var nStr,nHint: string;
    nDS: TDataSet;
begin
  nStr := 'Select * From %s Where TerminalID=''%s''';
  nStr := Format(nStr, [sTable_Terminal, gSysParam.FTerminalID]);

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    with nDS do
    begin
      EditAddr.Text := FieldByName('Address').AsString;
      EditAddr.Properties.MaxLength := FieldByName('Address').Size;
      EditName.Text := FieldByName('TerminalName').AsString;
      EditName.Properties.MaxLength := FieldByName('TerminalName').Size;

      EditUser.Text := FieldByName('Contact').AsString;
      EditUser.Properties.MaxLength := FieldByName('Contact').Size; 
      EditPhone.Text := FieldByName('Phone').AsString;
      EditPhone.Properties.MaxLength := FieldByName('Phone').Size;

      Radio1.Checked := FieldByName('Sex').AsInteger = 0;
      Radio2.Checked := not Radio1.Checked;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;
end;

procedure TfFrameTerminalInfo.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 提交
procedure TfFrameTerminalInfo.BtnOKClick(Sender: TObject);
var nInt: Integer;
    nStr, nHint: string;
begin
  if Radio1.Checked then
       nInt := 0
  else nInt := 1;

  nStr := 'Update %s Set TerminalName=''%s'', Address=''%s'', Contact=''%s'',' +
          'Phone=''%s'',Sex=%d Where TerminalID=''%s''';
  nStr := Format(nStr, [sTable_Terminal, EditName.Text, EditAddr.Text,
          EditUser.Text, EditPhone.Text, nInt, gSysParam.FTerminalID]);
  //xxxxx

  if FDM.SQLExecute(nStr, nHint) > 0 then
       ShowMsg('更新成功', sHint)
  else ShowDlg(nHint, sWarn);
end;

initialization
  gControlManager.RegCtrl(TfFrameTerminalInfo, TfFrameTerminalInfo.FrameID);
end.
